#!/usr/bin/env python3
"""
recomp_autostub.py — drive N64Recomp to a CLEAN recompile by auto-stubbing the
functions it can't handle (the data-as-code fallout of an over-disassembled resident).

N64Recomp aborts on the FIRST function it can't recompile (out-of-range branch, INVALID
opcode, etc. — almost always a DATA region splat disassembled as code). Stubbing such a
function is correct: it is never reached as code, and its bytes still live in rodata/assets,
so the ROM stays byte-exact. This loop runs the recompiler, reads the failing function from
its output, appends it to <basename>_stubs.txt, regenerates the toml, and retries.

Usage:
  python recomp_autostub.py --dir <front-end dir> --basename <game> --recomp <N64Recomp.exe> [--max 250]

Run AFTER the byte-exact ELF + gen_<basename>_toml.py exist. Reports iterations + stub count.
A high stub count means the resident image is data-heavy — narrow the code segment later for
recomp quality (L4); for L3 (builds) the stubs are harmless.
"""
import argparse, os, re, subprocess, sys

ERR = re.compile(r"Error recompiling (func_[0-9A-Fa-f]+(?:_[0-9A-Fa-f]+)?)")

# [cop0-guard 2026-09-06, Gauntlet Legends #120] NEVER stub a function that programs the CPU's COP0/TLB.
# Fifteen trees had their osMapTLB stubbed by this tool (the stubs predate N64Recomp's LLE-TLB support,
# when tlbwi made a function fail to recompile); a stubbed osMapTLB means the kernel's window is never
# installed and the first call through it dies (Gauntlet Legends' kseg3 kernel; Twisted Edge's
# "1.4 G tlbmiss"). Such a function is CODE by definition, so it is refused here with a hard error:
# fix the recompiler or the segment, do not paper over it.
# [2026-09-06, cv64blind] splat writes every instruction as `    /* ROM VRAM WORD */  mnemonic ...`, so a pattern
# anchored at the line start never matched and this guard had NEVER fired (the three TLB mappers of the blind
# Castlevania were stubbed to empty bodies under it). Allow the address comment before the mnemonic.
COP0_MNEMONICS = re.compile(r"^\s*(?:/\*[^*]*\*/\s*)?(tlbwi|tlbwr|tlbp|tlbr|mtc0|mfc0|dmtc0|dmfc0|eret|cache)\b", re.M)

def has_cop0_tlb(d, fn):
    """True if the splat asm for <fn> under <d>/asm contains a COP0/TLB/cache op."""
    asm_root = os.path.join(d, "asm")
    if not os.path.isdir(asm_root):
        return False
    label = re.compile(r"^glabel\s+" + re.escape(fn) + r"\s*$", re.M)
    for root, _, files in os.walk(asm_root):
        for name in files:
            if not name.endswith(".s"):
                continue
            path = os.path.join(root, name)
            try:
                txt = open(path, encoding="utf-8", errors="replace").read()
            except OSError:
                continue
            m = label.search(txt)
            if not m:
                continue
            nxt = re.search(r"^(glabel|endlabel)\s", txt[m.end():], re.M)
            body = txt[m.end(): m.end() + nxt.start()] if nxt else txt[m.end():]
            return COP0_MNEMONICS.search(body) is not None
    return False

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dir", required=True, help="game front-end dir (holds <basename>.toml, gen_<basename>_toml.py)")
    ap.add_argument("--basename", required=True)
    ap.add_argument("--recomp", required=True, help="path to N64Recomp.exe (the engine build)")
    ap.add_argument("--max", type=int, default=250)
    a = ap.parse_args()

    d = os.path.abspath(a.dir)
    toml = f"{a.basename}.toml"
    gen = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "gen_toml.py")  # SINGLE SOURCE: per-game gen_<g>_toml.py was deleted in the consolidation
    stubs_file = os.path.join(d, f"{a.basename}_stubs.txt")
    if not os.path.isfile(os.path.join(d, toml)): sys.exit(f"no {toml} in {d}")
    if not os.path.isfile(gen): sys.exit(f"no {gen}")

    stubs = []
    if os.path.exists(stubs_file):
        stubs = [l.strip() for l in open(stubs_file) if l.strip() and not l.startswith("#")]
    seen = set(stubs)

    # Force the #1 build-side diagnostics sink ON so segment_refine's data-vs-code veto always has a fresh
    # failures.json to read (inherited-env propagation proved unreliable through the subprocess chain).
    recomp_env = {**os.environ, "RECOMP_DIAG": "1"}
    for it in range(1, a.max + 1):
        p = subprocess.run([a.recomp, toml], cwd=d, capture_output=True, text=True, env=recomp_env)
        out = (p.stdout or "") + (p.stderr or "")
        if p.returncode == 0:
            n = len([f for f in os.listdir(os.path.join(d, "..", f"{a.basename}pc", "RecompiledFuncs"))
                     if f.startswith("funcs_") and f.endswith(".c")]) if os.path.isdir(
                     os.path.join(d, "..", f"{a.basename}pc", "RecompiledFuncs")) else "?"
            print(f"[autostub] CLEAN after {it-1} stubs added (total {len(stubs)} stubs). funcs_*.c = {n}")
            return 0
        matches = ERR.findall(out)
        if not matches:
            print(f"[autostub] iter {it}: recomp failed but no 'Error recompiling func_*' found — different error:")
            print("\n".join(out.splitlines()[-12:]))
            return 1
        # The recompiler reports every failing function per run (error-continue), so take them
        # all at once instead of one per iteration.
        new = [b for b in dict.fromkeys(matches) if b not in seen]
        cop0 = [b for b in new if has_cop0_tlb(d, b)]
        if cop0:
            print(f"[autostub] REFUSED: {', '.join(cop0)} contain COP0/TLB ops — real code (osMapTLB-class), not data. "
                  f"Stubbing would leave the kernel's TLB window uninstalled (Gauntlet Legends #120). Fix the recompile instead.")
            return 3
        if not new:
            print(f"[autostub] iter {it}: {matches[0]} already stubbed yet still failing — stubbing isn't clearing it. Stop.")
            print("\n".join([l for l in out.splitlines() if "Unhandled" in l or "Error" in l][-8:]))
            return 1
        bad = new[-1]
        for b in new:
            seen.add(b); stubs.append(b)
        with open(stubs_file, "w", newline="\n") as f:
            f.write("# auto-stubbed data-as-code funcs (recomp_autostub.py)\n")
            f.write("\n".join(stubs) + "\n")
        subprocess.run([sys.executable, gen, a.basename], capture_output=True, text=True)  # gen_toml.py <game> self-resolves paths
        if it % 10 == 0:
            print(f"[autostub] ...{it} iters, {len(stubs)} stubs (latest {bad})")

    print(f"[autostub] hit --max={a.max} with {len(stubs)} stubs, still failing. Resident is data-heavy; narrow the code segment.")
    return 2

if __name__ == "__main__":
    sys.exit(main())
