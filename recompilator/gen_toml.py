#!/usr/bin/env python3
"""gen_toml.py — THE RECOMPILATOR generic N64Recomp toml generator (SINGLE SOURCE).

Usage:  python gen_toml.py <game>
Reads  <game>/build/<game>.elf  +  <game>/baserom.z64  (entrypoint from the ROM header) and
writes <game>/<game>.toml with N64Recomp-relative paths. No per-game clones: a game folder holds
only data (<game>_stubs.txt, _force_ignore.txt, <game>_overlays.txt). All logic lives here.

function_sizes: every size-0 FUNC gets size = gap to the next *named* boundary in its section
(.L*/L_* are mid-function labels, never boundaries — else a switch's case labels truncate the func
and N64Recomp can't size its jump table). stubs = <game>_stubs.txt + _force_ignore.txt, filtered
to funcs actually present in the ELF (N64Recomp aborts on a stub that doesn't exist).
"""
import sys
import struct, os, bisect, sys

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

if len(sys.argv) < 2:
    sys.exit("usage: gen_toml.py <game>")
GAME = sys.argv[1]
N64PC = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))   # parent of recompilator/
# A game tree is <root>/archive/<game> now and used to be <root>/<game>; both are accepted so
# nothing built before the change has to move (2026-09-07). The N64Recomp-relative ROM path
# below is unaffected: the app tree sits beside its front end either way, so "../<game>/..." holds.
GDIR  = os.path.join(N64PC, GAME)
if not os.path.isfile(os.path.join(GDIR, f"{GAME}.yaml")):
    _arch = os.path.join(N64PC, "archive", GAME)
    if os.path.isfile(os.path.join(_arch, f"{GAME}.yaml")):
        GDIR = _arch
ELF   = os.path.join(GDIR, "build", f"{GAME}.elf")
OUT   = os.path.join(GDIR, f"{GAME}.toml")
ROM   = os.path.join(GDIR, "baserom.z64")
# Compressed-overlay games: N64Recomp must read instruction bytes from the WORKING ROM (pristine + appended
# decompressed overlays, built by decompress_overlays.py) so overlay code-section ROM offsets resolve. The
# resident byte-exact verify still gates against the pristine ROM. Falls back to pristine when no working ROM.
ROM_REL = f"../{GAME}/build/baserom_dec.z64" if os.path.exists(os.path.join(GDIR, "build", "baserom_dec.z64")) else f"../{GAME}/baserom.z64"

# Entrypoint from the ROM header (offset 0x8, big-endian) — never hardcoded per game.
with open(ROM, "rb") as r:
    r.seek(0x8); entrypoint = struct.unpack(">I", r.read(4))[0]
# [cic-bias 2026-09-03] CIC-6103/6106 carts inflate the header boot address by +0x100000/+0x200000 (IPL3 jumps to
# entry - bias). The yaml's main segment vram is the authoritative, already-corrected resident base (sweep_game.py
# applies the bias when it writes the yaml); a raw-header entrypoint here mismatched it on 15 trees (Yoshi's Story
# 0x80200400 vs 0x80000400). Prefer the yaml's main vram when present; fall back to the header.
try:
    import re as _re
    _y = open(os.path.join(GDIR, f"{GAME}.yaml"), encoding="utf-8", errors="replace").read()
    _m = _re.search(r"start:\s*0x1000\s*\n\s*vram:\s*(0x[0-9A-Fa-f]+)", _y)
    if _m:
        _yv = int(_m.group(1), 16)
        if _yv != entrypoint:
            print(f"[cic-bias] header entry 0x{entrypoint:08X} != yaml main vram 0x{_yv:08X} -> using the yaml (bias 0x{(entrypoint - _yv) & 0xFFFFFFFF:X})")
            entrypoint = _yv
except Exception as _e:
    print(f"[cic-bias] yaml read failed ({_e}); keeping the header entrypoint")

f = open(ELF, 'rb').read()
assert f[:4] == b'\x7fELF' and f[5] == 2, "not a big-endian 32-bit ELF"
shoff = struct.unpack('>I', f[0x20:0x24])[0]
shentsize, shnum, shstrndx = struct.unpack('>HHH', f[0x2E:0x34])

def sh(i):
    off = shoff + i * shentsize
    name, typ, flags, addr, offset, size, link, info, align, entsize = struct.unpack('>10I', f[off:off+40])
    return dict(name=name, typ=typ, flags=flags, addr=addr, offset=offset, size=size, link=link, entsize=entsize)

symtab = strtab = None
for i in range(shnum):
    s = sh(i)
    if s['typ'] == 2:  # SHT_SYMTAB
        symtab = s; strtab = sh(s['link'])
assert symtab, 'no symtab'

syms = []       # FUNC symbols (what N64Recomp recompiles)
bounds = []     # ALL named symbols = size boundaries so funcs never swallow data tails
n = symtab['size'] // 16
for i in range(n):
    o = symtab['offset'] + i * 16
    nm, val, sz, info, other, shndx = struct.unpack('>IIIBBH', f[o:o+16])
    if nm == 0 or val == 0:
        continue
    e = f.index(b'\0', strtab['offset'] + nm)
    name = f[strtab['offset'] + nm:e].decode()
    if not (name.startswith('.L') or name.startswith('L_')):
        bounds.append((val, shndx))
    if (info & 0xF) != 2:  # STT_FUNC only
        continue
    syms.append((val, sz, name, shndx))

syms.sort(); bounds.sort()
print(f'{len(syms)} FUNC symbols, {len(bounds)} boundary symbols, entrypoint 0x{entrypoint:08X}')

sec_end = {}
for i in range(shnum):
    s = sh(i)
    if s['flags'] & 4:  # SHF_EXECINSTR
        sec_end[i] = s['addr'] + s['size']

# ── GENERAL FIX (bare-metal exception-handler / carved-tail jump tables): explicit function-size
# overrides from <game>/_force_func_sizes.txt. N64Recomp's manually_sized_funcs (elf.cpp:128) lets a
# function's recompiled extent be LARGER than its carved ELF symbol, which is exactly what a hand-written
# __osException dispatch needs: its jr jump table (jtbl_80003400 in NC) indexes INTERIOR labels of the
# dispatch tail, but the tail is carved into separate functions (func_80080A88/B84/C7C...) because the
# runtime ALSO reaches those starts through a distinct `jr $sN` func-pointer dispatch and so each must
# stay independently LOOKUP_FUNC-able. Carving truncates the head function so its jump table can't size
# (analysis.cpp:362) -> live-gap stub -> interpreter derail -> run-queue corruption -> crash. The fix:
# OVERRIDE the head function's size so it spans the whole dispatch tail (its jtbl case labels become
# in-function `goto`s and the table sizes), while the carved siblings stay separate (the func-pointer
# dispatch still resolves them). They legitimately overlap. Format, one per line: `func_NAME = SIZE`
# (decimal or 0x hex), comments with #. Durable across re-splats (this runs every build).
force_sizes = {}
_ffs = os.path.join(GDIR, "_force_func_sizes.txt")
if os.path.exists(_ffs):
    for _l in open(_ffs):
        _l = _l.split('#', 1)[0].strip()
        if not _l or '=' not in _l:
            continue
        _nm, _sz = (x.strip() for x in _l.split('=', 1))
        try:
            force_sizes[_nm] = int(_sz, 0)
        except ValueError:
            print(f'  [force-size] WARN: bad size for {_nm!r}: {_sz!r}')
    print(f'{len(force_sizes)} explicit function-size override(s) from _force_func_sizes.txt')

lines = []; zero_sized = 0
emitted_forced = set()
for (val, sz, name, shndx) in syms:
    # Explicit override wins over BOTH the ELF symbol size and the auto-computed gap size.
    if name in force_sizes:
        if name not in emitted_forced:
            lines.append(f'  {{ name = "{name}", size = {force_sizes[name]} }},')
            emitted_forced.add(name)
        continue
    if sz != 0:
        continue
    zero_sized += 1
    nxt = None
    k = bisect.bisect_right(bounds, (val, 0xFFFF))
    while k < len(bounds):
        bv, bs = bounds[k]
        if bs == shndx and bv > val:
            nxt = bv; break
        k += 1
    if nxt is None:
        nxt = sec_end.get(shndx, val + 4)
    size = max(4, (nxt - val) & ~3)
    lines.append(f'  {{ name = "{name}", size = {size} }},')
_missing = set(force_sizes) - emitted_forced
if _missing:
    print(f'  [force-size] WARN: not in ELF symtab (ignored): {sorted(_missing)}')
print(f'{zero_sized} size-0 FUNCs got computed sizes')

VALID = {nm for (_, _, nm, _) in syms}

def read_list(path, pred=lambda l: True):
    if not os.path.exists(path):
        return []
    return [l.strip() for l in open(path) if l.strip() and not l.startswith('#') and pred(l.strip())]

STUBS  = read_list(os.path.join(GDIR, f"{GAME}_stubs.txt"))
IGNORE = read_list(os.path.join(GDIR, "_force_ignore.txt"), lambda l: l.startswith('func_'))
# Overlay dual names (2026-07-18, SOTE snapshot overlay): N64Recomp renames a vram-colliding
# overlay function to func_<VRAM>_<ROM> at load, and its ignored-list matches the FINAL name —
# which is never in the ELF symtab. Accept a stub whose base (dual suffix stripped) is present.
def _stub_ok(s):
    if s in VALID:
        return True
    base, _, suffix = s.rpartition('_')
    return len(suffix) in (6, 7, 8) and all(c in '0123456789abcdefABCDEF' for c in suffix) and base in VALID
STUBS  = sorted({s for s in (STUBS + IGNORE) if _stub_ok(s)})
print(f'{len(STUBS)} stubs (from {GAME}_stubs.txt + _force_ignore.txt, filtered to present funcs)')

toml = f'''[input]
entrypoint                = 0x{entrypoint:08X}
elf_path                  = "../{GAME}/build/{GAME}.elf"
rom_file_path             = "{ROM_REL}"
output_func_path          = "../{GAME}pc/RecompiledFuncs"
relocatable_sections_path = "{GAME}_overlays.txt"

uses_mips3_float_mode = true

function_sizes = [
''' + '\n'.join(lines) + '''
]

exact_size_funcs = [
''' + '\n'.join(f'  "{nm}",' for nm in sorted(emitted_forced)) + '''
]

[patches]
stubs = [
''' + '\n'.join(f'  "{s}",' for s in STUBS) + '''
]
'''
open(OUT, 'w', newline='\n').write(toml)
print(f'wrote {OUT}')
