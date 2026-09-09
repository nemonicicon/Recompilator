#!/usr/bin/env python3
"""split_severed_entries.py — THE RECOMPILATOR severed-entry repair (general).

A "severed entry" is a cross-function jump/call target that lands in the MIDDLE of another,
auto-mis-sized function. N64Recomp emits the target as its own `static_<sec>_<VADDR>` function
but with an EMPTY body (the bytes are owned by the enclosing named func, whose gen_toml size
swallowed the target). So `j/jal <target>` reaches a do-nothing stub -> control is silently lost.
This is exactly NC's scheduler dispatcher (static_18_80080FCC empty -> the yield never switches
tasks) and Blast Corps' jtbl mis-split.

THE FIX (general, data-only, baseline-safe): for every EMPTY static stub that is actually CALLED,
append `func_<VADDR> = 0x<VADDR>; // type:func` to <game>/symbol_addrs.txt. On the next
splat -> ELF -> gen_toml, that address becomes a NAMED boundary: the enclosing func is sized to
end there, and the target is recompiled as a real function with its real code. The cross-function
jumps then resolve to it.

SAFE: backs up symbol_addrs.txt (.bak_severed); ONLY appends addresses not already named (never
moves/clobbers a curated symbol). Dry-run by default; --apply writes. gen_toml reads the ELF
SYMTAB, so a full re-splat (build_elf) is required for the new boundaries to take effect.

Usage:  python split_severed_entries.py <game> [--apply]
"""
import os, re, sys, glob, shutil

if len(sys.argv) < 2:
    sys.exit("usage: split_severed_entries.py <game> [--apply]")
GAME = sys.argv[1]
APPLY = "--apply" in sys.argv[2:]
N64PC = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))  # parent of recompilator/tools/
GDIR = os.path.join(N64PC, GAME)
RECOMP = os.path.join(N64PC, f"{GAME}pc", "RecompiledFuncs")
SYMS = os.path.join(GDIR, "symbol_addrs.txt")

if not os.path.isdir(RECOMP):
    sys.exit(f"no RecompiledFuncs at {RECOMP} (recompile the game first)")

# An empty stub body is ONLY the boilerplate locals the recompiler always emits, then `;}`.
# Any real func has ctx-> / MEM_ / a call / a goto. We detect the boilerplate-only body.
BOILER = re.compile(r'^\s*(uint64_t hi = 0[^;]*;|int c1cs = 0;|uint32_t poll_guard[^;]*;\s*\(void\)poll_guard;|;)\s*$')
FUNC_RE = re.compile(r'RECOMP_FUNC\s+void\s+(static_\d+_([0-9A-Fa-f]{8}))\s*\([^)]*\)\s*\{', re.M)

def body_is_empty(src, open_brace_idx):
    depth, i = 0, open_brace_idx
    while i < len(src):
        c = src[i]
        if c == '{': depth += 1
        elif c == '}':
            depth -= 1
            if depth == 0:
                body = src[open_brace_idx+1:i]
                for line in body.splitlines():
                    if line.strip() and not BOILER.match(line):
                        return False, i
                return True, i
        i += 1
    return False, i

empty_stubs = {}   # vaddr_hex -> static name
for cf in glob.glob(os.path.join(RECOMP, "*.c")):
    src = open(cf, encoding='utf-8', errors='replace').read()
    for m in FUNC_RE.finditer(src):
        name, vaddr = m.group(1), m.group(2).upper()
        empty, _ = body_is_empty(src, m.end()-1)
        if empty:
            empty_stubs[vaddr] = name

# Keep only stubs that are actually CALLED somewhere (a severed entry that is never reached
# needs no repair). Scan all recompiled C for `<name>(rdram, ctx)` call sites.
called = set()
allsrc = "".join(open(cf, encoding='utf-8', errors='replace').read() for cf in glob.glob(os.path.join(RECOMP, "*.c")))
for vaddr, name in empty_stubs.items():
    if re.search(re.escape(name) + r'\s*\(\s*rdram', allsrc):
        called.add(vaddr)

# Existing named addresses in symbol_addrs (never clobber a curated symbol).
named = set()
if os.path.exists(SYMS):
    for ln in open(SYMS, encoding='utf-8', errors='replace'):
        mm = re.search(r'=\s*0x([0-9A-Fa-f]{8})', ln)
        if mm: named.add(mm.group(1).upper())

todo = sorted(v for v in called if v not in named)
skipped_uncalled = sorted(v for v in empty_stubs if v not in called)
skipped_named = sorted(v for v in called if v in named)

print(f"== split_severed_entries: {GAME} ==")
print(f"  empty static stubs found : {len(empty_stubs)}")
print(f"  ...actually called       : {len(called)}")
print(f"  ...already named (skip)   : {len(skipped_named)} {['0x'+v for v in skipped_named]}")
print(f"  ...uncalled (skip)        : {len(skipped_uncalled)}")
print(f"  NEW boundaries to add     : {len(todo)}")
for v in todo:
    print(f"      func_{v} = 0x{v}; // type:func ({empty_stubs[v]} was empty severed entry)")

if not todo:
    print("  nothing to split. exit 0.")
    sys.exit(0)

if not APPLY:
    print("\n  DRY-RUN. re-run with --apply to append these boundaries to symbol_addrs.txt,")
    print("  then re-splat (build_elf) -> gen_toml -> recompile so the entries get real code.")
    sys.exit(0)

shutil.copy2(SYMS, SYMS + ".bak_severed")
with open(SYMS, "a", encoding='utf-8') as f:
    f.write("\n// severed-entry boundaries (split_severed_entries.py): mid-function jump targets\n")
    f.write("// that N64Recomp emitted as EMPTY stubs; naming them forces gen_toml to size the\n")
    f.write("// enclosing func correctly so the target recompiles with its real code.\n")
    for v in todo:
        f.write(f"func_{v} = 0x{v}; // type:func\n")
print(f"\n  APPLIED: appended {len(todo)} boundaries to {SYMS} (backup .bak_severed).")
print("  NEXT: re-splat (build_elf) -> gen_toml -> N64Recomp -> cmake to materialize the code.")
