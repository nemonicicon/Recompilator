#!/usr/bin/env python3
"""build_elf.py - THE RECOMPILATOR's byte-exact ELF builder, WITHOUT DOCKER AND WITHOUT A SHELL.

    <toolchain>/python/python.exe recompilator/tools/build_elf.py <game> [--root <N64PC>] [--toolchain <dir>]

This is a faithful port of recompilator/build_elf.sh to the bundled toolchain: the same steps in
the same order, from the game's DATA only, with every `find`/`sed`/`grep`/`rm` replaced by Python
and mips-linux-gnu-{as,ld,objcopy} replaced by the bundled mips64-elf binutils. There is still NO
per-game code: this one file carries every general fix, exactly as the sh does.

Why it exists: build_elf.sh runs inside the cv64-build Docker image. A user of the Recompilator
installs nothing, so stage 2 of the BUILD screen cannot need docker, a POSIX shell, or a system
Python. It needs only <toolchain>/ (see recompilator/tools/make_toolchain.ps1).

Toolchain resolution, first hit wins:
    --toolchain <dir> | %RECOMPILATOR_TOOLCHAIN% | <root>/_toolchain | <root>/toolchain
        | <dir of this file>/../../toolchain      (the shipped layout: toolchain/ beside the exe)

The verdict line every caller gates on is printed by tools/verify_rom_match.py and is unchanged:
    BYTE-EXACT: ELF-reconstructed ROM matches baserom.z64 over the FULL ROM (no coverage gaps).
"""

import argparse
import os
import re
import shutil
import subprocess
import sys

# A CARTRIDGE TITLE CAN CONTAIN ANY CHARACTER, AND PRINTING IT MUST NEVER KILL THE TOOL.
# Python picks the console codepage for stdout on Windows (cp1252 here), so the moment a
# Japanese title reached a print() this whole bring-up died with UnicodeEncodeError
# (2026-09-07, Saikyou Habu Shougi). Say it in UTF-8 and replace what cannot be shown;
# files are written with an explicit encoding elsewhere and are unaffected.
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

# ------------------------------------------------------------------ plumbing --

def say(msg):
    print(msg, flush=True)


def fatal(msg, code=2):
    say(msg)
    sys.exit(code)


def run(argv, cwd, capture=True, check=False, stderr_to=None):
    """Run a program. Returns (rc, text). Never raises on a non-zero rc unless check."""
    if capture:
        p = subprocess.run(argv, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        text = p.stdout.decode("utf-8", "replace")
    elif stderr_to is not None:
        with open(stderr_to, "wb") as fe:
            p = subprocess.run(argv, cwd=cwd, stdout=subprocess.PIPE, stderr=fe)
        text = p.stdout.decode("utf-8", "replace")
    else:
        p = subprocess.run(argv, cwd=cwd)
        text = ""
    if check and p.returncode != 0:
        say(text)
        fatal("FATAL: command failed (%d): %s" % (p.returncode, " ".join(argv)))
    return p.returncode, text


def find_s(base):
    """`find asm -name '*.s'` - relative POSIX-style paths, deterministic order."""
    out = []
    for dirpath, dirnames, filenames in os.walk(base):
        dirnames.sort()
        for fn in sorted(filenames):
            if fn.endswith(".s"):
                out.append(os.path.join(dirpath, fn).replace("\\", "/"))
    return out


def find_ext(base, ext):
    out = []
    for dirpath, dirnames, filenames in os.walk(base):
        dirnames.sort()
        for fn in sorted(filenames):
            if fn.endswith(ext):
                out.append(os.path.join(dirpath, fn).replace("\\", "/"))
    return out


def read_text(path):
    with open(path, encoding="utf-8", errors="replace") as f:
        return f.read()


def write_text(path, text):
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


# ------------------------------------------------------------------ toolchain --

class Toolchain:
    def __init__(self, root_dir):
        self.dir = root_dir
        b = os.path.join(root_dir, "mips", "bin")
        self.AS = os.path.join(b, "mips64-elf-as.exe")
        self.LD = os.path.join(b, "mips64-elf-ld.exe")
        self.OBJCOPY = os.path.join(b, "mips64-elf-objcopy.exe")

    def ok(self):
        return all(os.path.isfile(p) for p in (self.AS, self.LD, self.OBJCOPY))


def resolve_toolchain(explicit, root):
    here = os.path.dirname(os.path.abspath(__file__))
    cands = []
    if explicit:
        cands.append(explicit)
    if os.environ.get("RECOMPILATOR_TOOLCHAIN"):
        cands.append(os.environ["RECOMPILATOR_TOOLCHAIN"])
    cands.append(os.path.join(root, "_toolchain"))
    cands.append(os.path.join(root, "toolchain"))
    cands.append(os.path.abspath(os.path.join(here, "..", "..", "toolchain")))
    for c in cands:
        tc = Toolchain(c)
        if tc.ok():
            return tc
    fatal("FATAL: no bundled toolchain found (looked in: %s). Run recompilator/tools/make_toolchain.ps1."
          % ", ".join(cands))


# ---------------------------------------------------------------------- steps --

def step_terminator(game):
    """GENERAL FIX: the yaml's final bare segment terminator must equal the ROM size."""
    yf = "%s.yaml" % game
    rom_end = os.path.getsize("baserom.z64")
    lines = read_text(yf).split("\n")
    term_re = re.compile(r"^(\s*-\s*\[\s*)0x[0-9A-Fa-f]+(\s*\])(.*)$")
    last = -1
    for i, l in enumerate(lines):
        if term_re.match(l):
            last = i
    if last < 0:
        fatal("FATAL: no bare terminator '- [0xADDR]' in %s" % yf)
    m = term_re.match(lines[last])
    new = "%s0x%X%s%s" % (m.group(1), rom_end, m.group(2), m.group(3))
    if new != lines[last]:
        say("[terminator] %s: %s  ->  - [0x%X]  (ROM size)" % (yf, lines[last].strip(), rom_end))
        lines[last] = new
        write_text(yf, "\n".join(lines))
    else:
        say("[terminator] %s: already 0x%X (ROM size)" % (yf, rom_end))


# EVERY CHILD PYTHON RUNS IN UTF-8 MODE. The tree's text files - the splat yaml, the pinned
# linker script, the stub list - are UTF-8, because the comments in a hand-authored one carry
# em-dashes. A child on Windows defaults to cp1252 and dies reading them:
#   UnicodeDecodeError: 'charmap' codec can't decode byte 0x8f
# which is what stopped 9 of the 170 shipped recipes from splitting at all (2026-09-07).
# It has to be the -X switch and not PYTHONUTF8, because these run with -I (isolated), which
# ignores the environment by design.
def step_splat(py, gamedir, yaml_name):
    """splat split, with the recursion limit raised (large/data-heavy carts)."""
    code = ("import sys; sys.setrecursionlimit(200000); "
            "sys.argv=['splat','split','%s']; import runpy; runpy.run_module('splat', run_name='__main__')"
            % yaml_name)
    rc, out = run([py, "-X", "utf8", "-I", "-c", code], cwd=gamedir)
    tail = [l for l in out.split("\n") if l.strip()][-5:]
    for l in tail:
        say(l)
    if rc != 0:
        fatal("FATAL: splat split failed on %s (exit %d)" % (yaml_name, rc))


LABEL_RE_1 = re.compile(r"\.L([0-9A-Fa-f]{6,8})")
LABEL_RE_2 = re.compile(r"^[ \t]*glabel ((?:L_|D_|jtbl_|jpt_)[0-9A-Fa-f_]+)[ \t]*$", re.M)
LABEL_RE_3 = re.compile(r"^[ \t]*((?:L_|jtbl_|jpt_)[0-9A-Fa-f]+):[ \t]*$", re.M)


def step_rename_labels(paths):
    """the three `sed -i -E` passes: .L<hex> -> L_<hex>, and PROVIDE-able .global forms."""
    for p in paths:
        t = read_text(p)
        n = LABEL_RE_1.sub(lambda m: "L_" + m.group(1), t)
        n = LABEL_RE_2.sub(lambda m: ".global %s\n%s:" % (m.group(1), m.group(1)), n)
        n = LABEL_RE_3.sub(lambda m: ".global %s\n%s:" % (m.group(1), m.group(1)), n)
        if n != t:
            write_text(p, n)


GAS_ERR_LINE = re.compile(r":(\d+):\s*Error:")
GAS_WORD = re.compile(r"/\*\s*[0-9A-Fa-f]+\s+[0-9A-Fa-f]+\s+([0-9A-Fa-f]{8})\s*\*/")


def dgas_rewrite(sfile, errfile):
    """The D-gas loop's body: rewrite the gas-hostile lines gas named to byte-exact .word."""
    lines = read_text(sfile).split("\n")
    errtxt = read_text(errfile)
    errlns = sorted({int(m.group(1)) for m in GAS_ERR_LINE.finditer(errtxt)})
    chg = 0
    for ln in errlns:
        i = ln - 1
        if i < 0 or i >= len(lines) or "*/" not in lines[i]:
            continue
        m = GAS_WORD.search(lines[i])
        if not m:
            continue
        pre = lines[i].split("*/", 1)[0] + "*/"
        instr = lines[i].split("*/", 1)[1].strip()
        lines[i] = "%s  .word 0x%s  # gas-hostile: %s" % (pre, m.group(1), instr)
        chg += 1
    write_text(sfile, "\n".join(lines))
    say("D-gas: rewrote %d gas-hostile instr(s) to .word in %s" % (chg, sfile))


def step_assemble(tc, gamedir, sfiles):
    for s in sfiles:
        o = "build/" + re.sub(r"\.s$", ".s.o", s)
        od = os.path.join(gamedir, os.path.dirname(o))
        if not os.path.isdir(od):
            os.makedirs(od, exist_ok=True)
        aserr = os.path.join(gamedir, o + ".aserr")
        tries = 0
        while True:
            rc, _ = run([tc.AS, "-march=mips4", "-mabi=32", "-mno-pdr", "-I", "include", "-o", o, s],
                        cwd=gamedir, capture=False, stderr_to=aserr)
            if rc == 0:
                break
            tries += 1
            if tries > 4:
                say("GAS-GIVEUP %s" % s)
                say(read_text(aserr))
                sys.exit(1)
            dgas_rewrite(os.path.join(gamedir, s), aserr)
    say("assembled %d objects" % len(find_ext(os.path.join(gamedir, "build", "asm"), ".o")))


def step_align(tc, gamedir, objs):
    """objcopy --set-section-alignment: absent before binutils 2.32. The sh tolerates its failure
    (`|| true`) and so do we - the bundled `as` already emits 4-byte-aligned .text/.data/.bss."""
    for o in objs:
        for sec in (".text", ".data", ".rodata"):
            run([tc.OBJCOPY, "--set-section-alignment", "%s=4" % sec, o], cwd=gamedir)


def step_localize_snapshot(tc, gamedir, objs):
    for o in objs:
        if not os.path.basename(o).startswith("ovl_snap_"):
            continue
        run([tc.OBJCOPY, "-w", "-L", "func_*", "-L", "L_*", "-L", "D_*",
             "-L", "jtbl_*", "-L", "jpt_*", "-L", ".L*", o], cwd=gamedir)
        say("localized snapshot-overlay symbols: %s" % o)


def step_bin_objects(tc, gamedir, bins, prefix=""):
    """ld -r -b binary: the blob's symbol names come from the PATH, so keep it relative + POSIX.
    `prefix` mirrors the sh: assets/x.bin -> build/assets/x.bin.o, but build/asm/data/x.bin
    -> build/asm/data/x.bin.o (already under build/)."""
    for b in bins:
        o = prefix + re.sub(r"\.bin$", ".bin.o", b)
        od = os.path.join(gamedir, os.path.dirname(o))
        if od and not os.path.isdir(od):
            os.makedirs(od, exist_ok=True)
        run([tc.LD, "-r", "-b", "binary", "-o", o, b], cwd=gamedir, check=True)


def step_classb_slice(gamedir, game):
    """CLASS-B: slice plain-data (bin/data) subsegs straight from ROM, byte-exact."""
    subs = []
    sub_re = re.compile(r"\[0x([0-9A-Fa-f]+),\s*(asm|data|bin),\s*(\w+)\]")
    for line in read_text(os.path.join(gamedir, "_subsegs.txt")).split("\n"):
        m = sub_re.search(line)
        if m:
            subs.append((int(m.group(1), 16), m.group(2), m.group(3)))
    subs.sort()
    yaml_text = read_text(os.path.join(gamedir, "%s.yaml" % game))
    tops = sorted(int(x, 16) for x in re.findall(r"^\s*start:\s*(0x[0-9A-Fa-f]+)", yaml_text, re.M))

    def next_top(after):
        for t in tops:
            if t > after:
                return t
        return None

    rend = 0x101000
    in_assets = False
    for l in yaml_text.split("\n"):
        if re.match(r"\s*-\s*name:\s*assets\s*$", l):
            in_assets = True
            continue
        if in_assets:
            m = re.match(r"\s*start:\s*0x([0-9A-Fa-f]+)", l)
            if m:
                rend = int(m.group(1), 16)
                break
            if re.match(r"\s*-\s*name:", l):
                in_assets = False
    say("assets start (REND) = 0x%X" % rend)
    with open(os.path.join(gamedir, "baserom.z64"), "rb") as f:
        rom = f.read()
    outdir = os.path.join(gamedir, "build", "asm", "data")
    os.makedirs(outdir, exist_ok=True)
    n = 0
    for i, (rstart, typ, name) in enumerate(subs):
        if typ not in ("bin", "data"):
            continue
        rend_i = subs[i + 1][0] if i + 1 < len(subs) else rend
        nt = next_top(rstart)
        if nt is not None and nt < rend_i:
            rend_i = nt
        with open(os.path.join(outdir, "%s.bin" % name), "wb") as f:
            f.write(rom[rstart:rend_i])
        n += 1
    say("sliced %d bin spans from ROM" % n)


UNDEF_ADDR = re.compile(r"undefined reference to .((?:D_|func_|jpt_|jtbl_|B_|L_)([0-9A-Fa-f]{1,8})(?:_[A-Za-z0-9_]+)?)")
UNDEF_NAMED = re.compile(r"undefined reference to .([A-Za-z_][A-Za-z0-9_]*)")
ADDR_NAMED = re.compile(r"^(?:D_|func_|jpt_|jtbl_|B_|L_)[0-9A-Fa-f]")


def link(tc, gamedir, game, scripts, errname):
    elf = "build/%s.elf" % game
    p = os.path.join(gamedir, elf)
    if os.path.exists(p):
        os.remove(p)
    argv = [tc.LD, "-G", "0"]
    for s in scripts:
        argv += ["-T", s]
    argv += ["--no-check-sections", "--accept-unknown-input-arch", "-o", elf]
    run(argv, cwd=gamedir, capture=False, stderr_to=os.path.join(gamedir, "build", errname))
    return read_text(os.path.join(gamedir, "build", errname))


# ----------------------------------------------------------------------- main --

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("game")
    ap.add_argument("--root", default="")
    ap.add_argument("--toolchain", default="")
    a = ap.parse_args()

    game = a.game
    here = os.path.dirname(os.path.abspath(__file__))
    root = os.path.abspath(a.root) if a.root else os.path.abspath(os.path.join(here, "..", ".."))
    tools = os.path.join(root, "recompilator", "tools")
    # A GAME TREE IS <root>/archive/<game> NOW, and used to be <root>/<game>. Both are accepted:
    # trees made before the change stay where they are and keep building (2026-09-07).
    gamedir = os.path.join(root, game)
    if not os.path.isfile(os.path.join(gamedir, "%s.yaml" % game)):
        in_archive = os.path.join(root, "archive", game)
        if os.path.isfile(os.path.join(in_archive, "%s.yaml" % game)):
            gamedir = in_archive
    py = sys.executable

    if not os.path.isdir(gamedir):
        fatal("FATAL: no game tree at %s (nor under archive/)" % gamedir)
    os.chdir(gamedir)
    if not os.path.isfile("%s.yaml" % game):
        fatal("FATAL: %s/%s.yaml missing" % (game, game))
    if not os.path.isfile("baserom.z64"):
        fatal("FATAL: %s/baserom.z64 missing" % game)

    tc = resolve_toolchain(a.toolchain, root)
    say("=== toolchain: %s ===" % tc.dir)
    say("    as      %s" % tc.AS)
    say("    ld      %s" % tc.LD)
    say("    python  %s" % py)

    step_terminator(game)

    say("=== splat split ===")
    for d in ("asm", "build", "assets"):
        if os.path.isdir(d):
            shutil.rmtree(d)
    os.makedirs("build", exist_ok=True)

    run([py, "-X", "utf8", "-I", os.path.join(tools, "decompress_overlays.py"), gamedir], cwd=gamedir, capture=False)
    run([py, "-X", "utf8", "-I", os.path.join(tools, "declare_overlays.py"), gamedir, "prepare"], cwd=gamedir, capture=False)

    if not os.path.exists("symbol_addrs.txt"):
        open("symbol_addrs.txt", "a").close()
    if not os.path.exists("undefined_syms_manual.ld"):
        open("undefined_syms_manual.ld", "w").close()

    step_splat(py, gamedir, "%s.yaml" % game)

    # overlay splat: each decompressed code overlay as its own code segment
    if os.path.isfile("build/overlay_layout.txt") and not os.path.isfile("build/overlay_sections.ld"):
        say("=== splat overlays ===")
        for line in read_text("build/overlay_layout.txt").split("\n"):
            if not line.strip() or line.lstrip().startswith("#"):
                continue
            oname = line.split()[0]
            if not os.path.isfile("%s.yaml" % oname):
                say("WARN: overlay %s has no %s.yaml" % (oname, oname))
                continue
            step_splat(py, gamedir, "%s.yaml" % oname)

    say("=== pinned linker script ===")
    shutil.copyfile("%s_pinned.ld" % game, "build/%s.ld" % game)
    run([py, "-X", "utf8", "-I", os.path.join(tools, "declare_overlays.py"), gamedir, "spliceld"], cwd=gamedir, capture=False)

    say("=== rename .L jtbl/addr labels -> PROVIDE-able L_ ===")
    sfiles = find_s("asm")
    step_rename_labels(sfiles)

    say("=== dataregion-fix (silent-mis-assembly class: div-family + label-relative b/j in data) ===")
    if sfiles:
        run([py, "-X", "utf8", "-I", os.path.join(tools, "dataregion_fix.py")] + sfiles, cwd=gamedir, capture=False)

    ovl_s = [s for s in sfiles if "ovl_" in s and not s.startswith("asm/ovl/")]
    for s in ovl_s:
        run([py, "-X", "utf8", "-I", os.path.join(tools, "fix_false_gprel.py"), s], cwd=gamedir, capture=False)
    for s in ovl_s:
        run([py, "-X", "utf8", "-I", os.path.join(tools, "localize_overlay_dups.py"), "symbol_addrs.txt", s],
            cwd=gamedir, capture=False)

    say("=== gprel: PROVIDE offset-named gp symbols at _gp+offset (gp carts) ===")
    run([py, "-X", "utf8", "-I", os.path.join(tools, "gprel_provide.py"), "build/gprel_syms.ld"], cwd=gamedir, capture=False)

    say("=== assemble (D-gas loop: rewrite gas-hostile valid VR4300 encodings to byte-exact .word) ===")
    os.makedirs("build/asm", exist_ok=True)
    os.makedirs("build/assets", exist_ok=True)
    step_assemble(tc, gamedir, sfiles)

    objs = find_ext("build/asm", ".o")
    step_align(tc, gamedir, objs)
    step_localize_snapshot(tc, gamedir, objs)

    step_bin_objects(tc, gamedir, find_ext("assets", ".bin") if os.path.isdir("assets") else [], "build/")

    if os.path.isfile("_subsegs.txt"):
        say("=== CLASS-B: slice plain-data (bin) spans from ROM ===")
        step_classb_slice(gamedir, game)
        step_bin_objects(tc, gamedir, find_ext("build/asm/data", ".bin"))

    say("=== link (pass 1: collect undefineds) ===")
    scripts = ["build/gprel_syms.ld", "build/%s.ld" % game, "undefined_syms_manual.ld"]
    err1 = link(tc, gamedir, game, scripts, "link_err.txt")

    say("=== auto-PROVIDE: address-named symbols heal to their literal address ({2,8} floor) ===")
    provides = set()
    for m in UNDEF_ADDR.finditer(err1):
        provides.add("PROVIDE(%s = 0x%s);" % (m.group(1), m.group(2)))
    say("%d build/undefined_syms_auto.ld" % len(provides))

    say("=== auto-PROVIDE: NAMED libultra symbols heal from symbol_addrs.txt (already HLE'd by the engine) ===")
    named = sorted({m.group(1) for m in UNDEF_NAMED.finditer(err1) if not ADDR_NAMED.match(m.group(1))})
    write_text("build/undef_named.txt", "\n".join(named) + ("\n" if named else ""))
    sym_addr = {}
    if os.path.isfile("symbol_addrs.txt"):
        for l in read_text("symbol_addrs.txt").split("\n"):
            m = re.match(r"\s*([A-Za-z_]\w*)\s*=\s*(0x[0-9A-Fa-f]+)", l)
            if m and m.group(1) not in sym_addr:
                sym_addr[m.group(1)] = m.group(2)
    np = 0
    for s in named:
        if s in sym_addr:
            provides.add("PROVIDE(%s = %s);" % (s, sym_addr[s]))
            np += 1
    say("named-symbol PROVIDEs from symbol_addrs.txt: %d" % np)
    write_text("build/undefined_syms_auto.ld", "\n".join(sorted(provides)) + ("\n" if provides else ""))

    say("=== link (pass 2) ===")
    scripts2 = scripts + ["build/undefined_syms_auto.ld"]
    err2 = link(tc, gamedir, game, scripts2, "link_err2.txt")
    for l in err2.split("\n")[:10]:
        if l.strip():
            say(l)

    elf = "build/%s.elf" % game
    if not os.path.isfile(elf):
        fatal("LINK FAILED: no ELF produced", 1)
    undef2 = err2.count("undefined reference")
    if undef2:
        fatal("LINK FAILED: %d unresolved reference(s) after auto-PROVIDE (build/link_err2.txt)" % undef2, 1)
    say("%s %d bytes" % (elf, os.path.getsize(elf)))
    say("LINK CLEAN")

    say("=== verify ROM byte-exactness (HARD gate: fails on any coverage gap) ===")
    verify_rom = "baserom.z64"
    if os.path.isfile("build/baserom_dec.z64"):
        verify_rom = "build/baserom_dec.z64"
    rc, out = run([py, "-X", "utf8", "-I", os.path.join(tools, "verify_rom_match.py"), elf, verify_rom], cwd=gamedir)
    say(out.rstrip("\n"))
    if rc != 0:
        sys.exit(rc)

    run([py, "-X", "utf8", "-I", os.path.join(tools, "declare_overlays.py"), gamedir, "relocs"], cwd=gamedir, capture=False)


if __name__ == "__main__":
    main()
