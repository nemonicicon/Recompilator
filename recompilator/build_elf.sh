#!/bin/sh
# ── THE RECOMPILATOR — generic byte-exact ELF builder (SINGLE SOURCE). ─────────────────────────
# ROM -> splat disassembly -> byte-exact ELF, for ANY game, from its DATA only. There are NO
# per-game build scripts: this one script carries every general fix; a game folder holds only
# data (<game>.yaml, baserom.z64, <game>_pinned.ld, symbol_addrs.txt, *_stubs/_overlays.txt).
# All shared tools come from recompilator/tools/ (the single source) — never a per-game clone.
#
# Runs inside the cv64-build Docker image (sh — the image's bash is broken). Mount N64PC at /rb:
#   docker run --rm --entrypoint sh -v <N64PC>:/rb cv64-build -c "sh /rb/recompilator/build_elf.sh <game>"
set -e
GAME="$1"
[ -n "$GAME" ] || { echo "usage: build_elf.sh <game>"; exit 2; }
ROOT=/rb
TOOLS="$ROOT/recompilator/tools"
cd "$ROOT/$GAME"
[ -f "$GAME.yaml" ]   || { echo "FATAL: $GAME/$GAME.yaml missing"; exit 2; }
[ -f baserom.z64 ]    || { echo "FATAL: $GAME/baserom.z64 missing"; exit 2; }

if ! which mips-linux-gnu-as > /dev/null 2>&1; then
    apt-get update -qq
    apt-get install -y -qq binutils-mips-linux-gnu python3 python3-pip > /dev/null 2>&1
fi
pip3 install -q splat64 2>/dev/null || true

# ── GENERAL FIX: ROM-size-derived assets terminator (NEVER per-game). ──────────────────────────
# The splat yaml's final bare segment terminator must equal the ROM size, or rom[term..romend] is
# in NO ELF section -> N64Recomp's context.rom has a silent hole (the 4MB-asset-gap class that cost
# MKT + every <full-size> cart). Force the LAST bare `- [0xADDR]` to the actual baserom size here,
# at build time, idempotently — so it is correct for every game regardless of what the yaml says.
python3 - "$GAME" <<'PY'
import sys, os, re
g = sys.argv[1]; yf = f"{g}.yaml"
rom_end = os.path.getsize("baserom.z64")
lines = open(yf, encoding="utf-8").read().split("\n")
# bare terminator = a list item whose [...] holds ONLY an address (no type/name -> no comma)
term_re = re.compile(r'^(\s*-\s*\[\s*)0x[0-9A-Fa-f]+(\s*\])(.*)$')
last = max((i for i, l in enumerate(lines) if term_re.match(l)), default=-1)
if last < 0:
    sys.exit(f"FATAL: no bare terminator '- [0xADDR]' in {yf}")
m = term_re.match(lines[last])
new = f"{m.group(1)}0x{rom_end:X}{m.group(2)}{m.group(3)}"
if new != lines[last]:
    print(f"[terminator] {yf}: {lines[last].strip()}  ->  - [0x{rom_end:X}]  (ROM size)")
    lines[last] = new
    open(yf, "w", encoding="utf-8", newline="\n").write("\n".join(lines))
else:
    print(f"[terminator] {yf}: already 0x{rom_end:X} (ROM size)")
PY

echo "=== splat split ==="
rm -rf asm build assets
mkdir -p build
# ── COMPRESSED OVERLAYS: gzip-inflate code overlays into a working ROM (no-op if no overlay_manifest.txt).
# Runs AFTER the build/ wipe so its outputs survive; BEFORE splat so the overlay .bin exists for overlay splat.
python3 "$TOOLS/decompress_overlays.py" "$ROOT/$GAME"
# RELOCATABLE OVERLAYS FROM THE CART'S OWN BYTES (no-op unless the ROM carries a file table AND an
# overlay table): recovers the file table, Yaz0-decompresses every overlay, parses each overlay's own
# relocation trailer, appends the decompressed bytes to the working ROM, and writes asm/ovl/*.s +
# build/overlay_sections.ld + <game>_overlays.txt. See tools/declare_overlays.py.
python3 "$TOOLS/declare_overlays.py" "$ROOT/$GAME" prepare
touch symbol_addrs.txt
[ -f undefined_syms_manual.ld ] || : > undefined_syms_manual.ld
# GENERAL FIX (large/data-heavy carts): splat's %hi/%lo look-ahead recurses per-instruction; on a
# 32MB cart the default Python limit (1000) overflows -> RuntimeError. Raise it (byte-exact-neutral).
python3 -c "import sys; sys.setrecursionlimit(200000); sys.argv=['splat','split','$GAME.yaml']; import runpy; runpy.run_module('splat', run_name='__main__')" 2>&1 | tail -5

# overlay splat: disassemble each decompressed code overlay as its own code segment (gated on the working ROM)
if [ -f build/overlay_layout.txt ] && [ ! -f build/overlay_sections.ld ]; then
    echo "=== splat overlays ==="
    while read -r oname orom oovl ovram osize; do
        case "$oname" in \#*|"") continue;; esac
        [ -f "${oname}.yaml" ] || { echo "WARN: overlay $oname has no ${oname}.yaml"; continue; }
        python3 -c "import sys; sys.setrecursionlimit(200000); sys.argv=['splat','split','${oname}.yaml']; import runpy; runpy.run_module('splat', run_name='__main__')" 2>&1 | tail -3
    done < build/overlay_layout.txt
fi

echo "=== pinned linker script ==="
cp "${GAME}_pinned.ld" "build/$GAME.ld"
python3 "$TOOLS/declare_overlays.py" "$ROOT/$GAME" spliceld

echo "=== rename .L jtbl/addr labels -> PROVIDE-able L_ ==="
for s in $(find asm -name '*.s'); do
    sed -i -E 's/\.L([0-9A-Fa-f]{6,8})/L_\1/g' "$s"
    sed -i -E 's/^[[:space:]]*glabel ((L_|D_|jtbl_|jpt_)[0-9A-Fa-f_]+)[[:space:]]*$/.global \1\n\1:/' "$s"
    sed -i -E 's/^[[:space:]]*((L_|jtbl_|jpt_)[0-9A-Fa-f]+):[[:space:]]*$/.global \1\n\1:/' "$s"
done

echo "=== dataregion-fix (silent-mis-assembly class: div-family + label-relative b/j in data) ==="
python3 "$TOOLS/dataregion_fix.py" $(find asm -name '*.s')

# FALSE gp-rel fix for self-contained overlays ($gp used as a general register, not the IDO global pointer):
# rewrite splat's mis-symbolized %gp_rel(...) to literal offsets so they don't overflow GPREL16 at link.
for s in $(find asm -path '*ovl_*' -name '*.s' -not -path 'asm/ovl/*' 2>/dev/null); do python3 "$TOOLS/fix_false_gprel.py" "$s"; done

# Make the overlay's DUPLICATE libultra symbols LOCAL (named but file-scoped) so they don't collide with the
# resident's globals at link, while still HLE-binding by name (gen_toml reads local STT_FUNC too) — so the
# overlay's OS primitives (osSetEventMesg etc.) reach the engine HLE and managers register queues there.
for s in $(find asm -path '*ovl_*' -name '*.s' -not -path 'asm/ovl/*' 2>/dev/null); do python3 "$TOOLS/localize_overlay_dups.py" symbol_addrs.txt "$s"; done

echo "=== gprel: PROVIDE offset-named gp symbols at _gp+offset (gp carts) ==="
python3 "$TOOLS/gprel_provide.py" build/gprel_syms.ld

echo "=== assemble (D-gas loop: rewrite gas-hostile valid VR4300 encodings to byte-exact .word) ==="
AS=mips-linux-gnu-as; LD=mips-linux-gnu-ld; OBJCOPY=mips-linux-gnu-objcopy
mkdir -p build/asm build/assets
for s in $(find asm -name '*.s'); do
    o=build/$(echo "$s" | sed 's/\.s$/.s.o/'); mkdir -p $(dirname "$o"); tries=0
    while true; do
        if $AS -march=mips4 -mabi=32 -mno-pdr -I include -o "$o" "$s" 2> "$o.aserr"; then break; fi
        tries=$((tries+1)); if [ $tries -gt 4 ]; then echo "GAS-GIVEUP $s"; cat "$o.aserr"; exit 1; fi
        python3 - "$s" "$o.aserr" <<'PY'
import re, sys
sf, ef = sys.argv[1], sys.argv[2]
lines = open(sf, encoding="utf-8", errors="replace").read().split("\n")
errtxt = open(ef, encoding="utf-8", errors="replace").read()
errlns = sorted({int(m.group(1)) for m in re.finditer(r":(\d+):\s*Error:", errtxt)})
chg = 0
for ln in errlns:
    i = ln - 1
    if i < 0 or i >= len(lines) or "*/" not in lines[i]: continue
    m = re.search(r"/\*\s*[0-9A-Fa-f]+\s+[0-9A-Fa-f]+\s+([0-9A-Fa-f]{8})\s*\*/", lines[i])
    if not m: continue
    pre = lines[i].split("*/", 1)[0] + "*/"; instr = lines[i].split("*/", 1)[1].strip()
    lines[i] = "%s  .word 0x%s  # gas-hostile: %s" % (pre, m.group(1), instr); chg += 1
open(sf, "w", encoding="utf-8", newline="\n").write("\n".join(lines))
print("D-gas: rewrote", chg, "gas-hostile instr(s) to .word in", sf)
PY
    done
done
echo "assembled $(find build/asm -name '*.o' | wc -l) objects"
for o in $(find build/asm -name '*.o'); do
    for sec in .text .data .rodata; do $OBJCOPY --set-section-alignment $sec=4 "$o" 2>/dev/null || true; done
done
# SNAPSHOT-OVERLAY symbol localization (2026-07-18, SOTE class): a full-RAM snapshot overlay
# (ovl_snap_* by convention) covers the SAME vram range as the resident spans, so splat emits
# duplicate func_/L_/D_ global symbols -> multiple-definition link failure. Localize the
# overlay object's symbols: branches/refs inside the overlay bind self-contained, the link is
# clean, and runtime dispatch never needed the names (FuncEntry binds by address).
for o in $(find build/asm -name 'ovl_snap_*.s.o' 2>/dev/null); do
    $OBJCOPY -w -L 'func_*' -L 'L_*' -L 'D_*' -L 'jtbl_*' -L 'jpt_*' -L '.L*' "$o" 2>/dev/null || true
    echo "localized snapshot-overlay symbols: $o"
done
for b in $(find assets -name '*.bin' 2>/dev/null); do
    o=build/$(echo "$b" | sed 's/\.bin$/.bin.o/'); mkdir -p $(dirname "$o"); $LD -r -b binary -o "$o" "$b"
done

# CLASS-B: slice plain-data (bin) subsegs straight from ROM (byte-exact, no spimdisasm drift).
if [ -f _subsegs.txt ]; then
echo "=== CLASS-B: slice plain-data (bin) spans from ROM ==="
mkdir -p build/asm/data
GAME="$GAME" python3 - <<'PY'
import re, os
rom = open("baserom.z64","rb").read()
subs = []
for line in open("_subsegs.txt"):
    # [2026-09-03] any code-segment subsegment name (main2_..., ovl01_..., boot), not only main_
    m = re.search(r"\[0x([0-9A-Fa-f]+),\s*(asm|data|bin),\s*(\w+)\]", line)
    if m: subs.append((int(m.group(1),16), m.group(2), m.group(3)))
subs.sort()
# [2026-09-03] a bin span ends at the next subsegment OR the next TOP-LEVEL yaml segment (FD's bin_5CB70,
# 1080's data_pre), never past it: the linker script links those segments as their own sections now, and an
# over-sliced blob would overlap them.
_tops = sorted(int(x, 16) for x in re.findall(r"^\s*start:\s*(0x[0-9A-Fa-f]+)", open(os.environ["GAME"] + ".yaml", encoding="utf-8").read(), re.M))
def _next_top(after):
    for t in _tops:
        if t > after: return t
    return None
# [assets-start 2026-09-03] the last bin span ends where `assets` begins in THIS yaml (FD: 0x124D60), not at a
# hardcoded 1 MB; a wrong REND under-slices the span -> coverage gap / divergent ELF.
REND = 0x101000
_in = False
for _l in open(os.environ["GAME"] + ".yaml", encoding="utf-8"):
    if re.match(r"\s*-\s*name:\s*assets\s*$", _l): _in = True; continue
    if _in:
        _m = re.match(r"\s*start:\s*0x([0-9A-Fa-f]+)", _l)
        if _m: REND = int(_m.group(1), 16); break
        if re.match(r"\s*-\s*name:", _l): _in = False
print("assets start (REND) = 0x%X" % REND)
n = 0
for i,(rstart,typ,name) in enumerate(subs):
    # [2026-09-03] `data` subsegments are ROM bytes exactly like `bin` ones: slice them too (the pinned.ld now
    # links build/asm/data/<name>.bin.o for both; splat's .data.s reassembly is not needed and often .aserr's).
    if typ not in ("bin", "data"): continue
    rend = subs[i+1][0] if i+1 < len(subs) else REND
    _nt = _next_top(rstart)
    if _nt is not None and _nt < rend: rend = _nt
    open(f"build/asm/data/{name}.bin","wb").write(rom[rstart:rend]); n += 1
print("sliced", n, "bin spans from ROM")
PY
for b in $(find build/asm/data -name '*.bin' 2>/dev/null); do $LD -r -b binary -o "${b%.bin}.bin.o" "$b"; done
fi

echo "=== link (pass 1: collect undefineds) ==="
rm -f "build/$GAME.elf"
$LD -G 0 -T build/gprel_syms.ld -T "build/$GAME.ld" -T undefined_syms_manual.ld --no-check-sections --accept-unknown-input-arch -o "build/$GAME.elf" 2> build/link_err.txt || true
echo "=== auto-PROVIDE: address-named symbols heal to their literal address ({2,8} floor) ==="
grep -oE "undefined reference to .(D_|func_|jpt_|jtbl_|B_|L_)[0-9A-Fa-f]{1,8}(_[A-Za-z0-9_]+)?" build/link_err.txt | sed -E "s/.*to .((D_|func_|jpt_|jtbl_|B_|L_)([0-9A-Fa-f]{1,8})(_[A-Za-z0-9_]+)?)/PROVIDE(\1 = 0x\3);/" | sort -u > build/undefined_syms_auto.ld
wc -l build/undefined_syms_auto.ld
echo "=== auto-PROVIDE: NAMED libultra symbols heal from symbol_addrs.txt (already HLE'd by the engine) ==="
# Real GCC-compiled (late-cart) libultra code that splat carved as bin/data has no glabel, so the linker
# can't resolve osRecvMesg / osWritebackDCacheAll / etc. Their addresses ARE in symbol_addrs.txt and the
# engine HLE substitutes them at runtime -- the link just needs the address. PROVIDE each remaining
# undefined NAMED (non-address-named) symbol from symbol_addrs.txt. GENERAL FIX for the late-GCC
# "named-libultra-carved-as-data" build cluster (Majora's Mask, Carmageddon, Naboo, NHL Breakaway, ...).
grep -oE "undefined reference to .[A-Za-z_][A-Za-z0-9_]*" build/link_err.txt \
  | sed -E "s/.*to .//" \
  | grep -vE "^(D_|func_|jpt_|jtbl_|B_|L_)[0-9A-Fa-f]" \
  | sort -u > build/undef_named.txt
_np=0
while IFS= read -r _sym; do
    [ -n "$_sym" ] || continue
    _addr=$(grep -E "^[[:space:]]*${_sym}[[:space:]]*=[[:space:]]*0x[0-9A-Fa-f]+" symbol_addrs.txt 2>/dev/null | head -1 | grep -oE "0x[0-9A-Fa-f]+" | head -1)
    if [ -n "$_addr" ]; then echo "PROVIDE($_sym = $_addr);" >> build/undefined_syms_auto.ld; _np=$((_np+1)); fi
done < build/undef_named.txt
echo "named-symbol PROVIDEs from symbol_addrs.txt: $_np"
sort -u build/undefined_syms_auto.ld -o build/undefined_syms_auto.ld
echo "=== link (pass 2) ==="
rm -f "build/$GAME.elf"
$LD -G 0 -T build/gprel_syms.ld -T "build/$GAME.ld" -T undefined_syms_manual.ld -T build/undefined_syms_auto.ld --no-check-sections --accept-unknown-input-arch -o "build/$GAME.elf" 2> build/link_err2.txt || true
head -10 build/link_err2.txt
# REAL link-success gate (NOT `ls && SUCCESS` — ld leaves a partial ELF, so existence is a false positive).
[ -f "build/$GAME.elf" ] || { echo "LINK FAILED: no ELF produced"; exit 1; }
undef2=$(grep -c 'undefined reference' build/link_err2.txt || true)
[ "$undef2" -eq 0 ] || { echo "LINK FAILED: $undef2 unresolved reference(s) after auto-PROVIDE (build/link_err2.txt)"; exit 1; }
ls -lh "build/$GAME.elf" && echo "LINK CLEAN"

echo "=== verify ROM byte-exactness (HARD gate: fails on any coverage gap) ==="
# overlay builds verify against the working ROM (pristine + appended decompressed overlays); else pristine.
VERIFY_ROM=baserom.z64
[ -f build/baserom_dec.z64 ] && VERIFY_ROM=build/baserom_dec.z64
python3 "$TOOLS/verify_rom_match.py" "build/$GAME.elf" "$VERIFY_ROM"

# OVERLAY RELOCATIONS: one .rel.<section> per declared overlay, built from that overlay's OWN
# relocation trailer, so N64Recomp emits the section as relocatable (no-op without them).
python3 "$TOOLS/declare_overlays.py" "$ROOT/$GAME" relocs
