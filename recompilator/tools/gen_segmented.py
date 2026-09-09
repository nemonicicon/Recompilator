#!/usr/bin/env python3
"""
gen_segmented.py — the interleaved code/data segmenter (with build-error-driven overrides).

Classifies every function in the resident (out-of-range branch / invalid op / pointer table = DATA),
runs a REACHABILITY pass (anything a code func branches/jals to IS code), then applies build-driven
OVERRIDES (--force-code / --force-data: addresses the C compiler proved are code/data). Merges contiguous
same-class funcs into ranges and emits splat subsegments (alternating asm/data) + a byte-exact pinned .ld.

Re-runnable from a preserved disassemble_all toml: the build-refine loop feeds back force lists each round.

Usage:
  python gen_segmented.py --toml <g>_full.toml --rom <dir>/baserom.z64 --basename <g> \
     --vram 0x80000400 --rom-off 0x1000 --resident-end 0x101000 \
     --yaml-out <dir>/_subsegs.txt --ld-out <dir>/<g>_pinned.ld \
     [--force-code-file <f>] [--force-data-file <f>]
"""
import argparse, bisect, os, re, struct, sys

KNOWN_OPS = set([0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f,
                 0x10,0x11,0x12,0x14,0x15,0x16,0x17,0x18,0x19,0x1a,0x1b,
                 0x20,0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2a,0x2b,0x2c,0x2d,0x2e,0x2f,
                 0x30,0x31,0x32,0x35,0x37,0x38,0x39,0x3d,0x3f])
RAM_LO, RAM_HI = 0x80000000, 0x80800000

def is_data(words, v0, in_ram=None):
    """Code or data? A function whose jump or branch leaves RAM is data, not code.

    `in_ram` decides what RAM means. The default is the direct-mapped segment, which is right for
    almost every cart and WRONG for one whose body runs from a mapped window: the Acclaim Turok
    family executes at user-segment 0x00200000, so every internal jal target failed the fixed
    0x80000000..0x80800000 test and EVERY function containing a single jump was condemned as data
    on its first instruction. MEASURED 2026-09-09 on Turok 2: 17 KB of a 32 MB cart survived as
    code (0.1%), 166 data subsegments against 116 code ones, while the cart carries 2,071 function
    prologues. Callers that know the cart's real region map pass a predicate that accepts it.
    """
    if in_ram is None:
        in_ram = lambda a: RAM_LO <= a < RAM_HI
    n = len(words)
    if n == 0: return False
    invalid = ramaddr = 0
    for i, w in enumerate(words):
        v = v0 + i*4; o = (w >> 26) & 0x3f
        if in_ram(w): ramaddr += 1
        if o not in KNOWN_OPS: invalid += 1; continue
        if o in (0x02,0x03):
            t = ((v+4)&0xf0000000)|((w&0x3ffffff)<<2)
            if not in_ram(t): return True
        elif o in (0x04,0x05,0x06,0x07,0x14,0x15,0x16,0x17):
            imm = w & 0xffff; simm = imm-0x10000 if imm&0x8000 else imm
            if not in_ram(v+4+(simm<<2)): return True
    if invalid > max(2, n//8): return True
    if ramaddr >= max(4, n//2): return True
    return False

def read_addrs(path):
    if not path: return set()
    try:
        return {int(l.strip(), 16) for l in open(path) if l.strip() and not l.startswith("#")}
    except FileNotFoundError:
        return set()

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--toml", required=True); ap.add_argument("--rom", required=True)
    ap.add_argument("--basename", required=True)
    ap.add_argument("--vram", default="0x80000400"); ap.add_argument("--rom-off", default="0x1000")
    ap.add_argument("--resident-end", default="0x101000")
    ap.add_argument("--yaml-out", required=True); ap.add_argument("--ld-out", required=True)
    ap.add_argument("--force-code-file", default=None); ap.add_argument("--force-data-file", default=None)
    ap.add_argument("--force-code-ranges-file", default=None)
    ap.add_argument("--force-data-ranges-file", default=None)
    a = ap.parse_args()
    vram = int(a.vram,0); ro = int(a.rom_off,0); rend = int(a.resident_end,0); delta = vram - ro
    rom = open(a.rom,"rb").read()

    # DETACHED MODULES (2026-09-07). A cartridge's code is not always one contiguous run: a
    # second module is loaded past the first module's .bss, so ROM offset -> address is a
    # PIECEWISE map, not one delta. tools/detached_segments.py finds those modules from the
    # cart's own call targets and blind_bringup writes them here; without this the whole
    # module is filed under addresses that do not exist in the running game (Castlevania
    # renders black, Mario runs at 0 fps) and only a hand-written recipe could fix it.
    mods = []
    _mfile = os.path.join(os.path.dirname(os.path.abspath(a.ld_out)), "_modules.txt")
    if os.path.exists(_mfile):
        for _l in open(_mfile):
            _l = _l.split("#")[0].strip()
            if _l:
                _p = _l.split()
                mods.append((int(_p[0], 0), int(_p[1], 0), int(_p[2], 0)))
    mods.sort()
    rend = max([rend] + [m[1] for m in mods])
    # regions tile [ro, rend): the main run, then one per module, each to the next boundary
    bounds = [ro] + [m[0] for m in mods] + [rend]
    regions = []                                   # (rom_start, rom_end, vram)
    for i in range(len(bounds) - 1):
        rs, re_ = bounds[i], bounds[i + 1]
        regions.append((rs, re_, vram + (rs - ro) if i == 0 else mods[i - 1][2]))

    def region_of_vram(v):
        for i, (rs, re_, rv) in enumerate(regions):
            if rv <= v < rv + (re_ - rs):
                return i
        return None

    def off_of(v):
        i = region_of_vram(v)
        if i is None:
            return None
        rs, _re, rv = regions[i]
        return rs + (v - rv)

    def covered(v):
        return region_of_vram(v) is not None

    def rname(i):
        return "main" if i == 0 else "mod%d" % (i + 1)

    if mods:
        print("[segment] %d detached module(s): %s" % (len(mods), ", ".join(
            "ROM 0x%X..0x%X at 0x%08X" % m for m in mods)))
    funcs = sorted((int(n.split("_")[1],16), int(s)) for n,s in
             re.findall(r'\{\s*name\s*=\s*"(func_[0-9A-Fa-f]+)"\s*,\s*size\s*=\s*(\d+)\s*\}', open(a.toml,encoding="utf-8").read()))
    fcode = read_addrs(a.force_code_file); fdata = read_addrs(a.force_data_file)

    recs = []  # [v0, vend, is_data, targets, locked]
    jtbl_entries = set()
    for v0, sz in funcs:
        off = off_of(v0)
        if off is None or off < 0 or off+sz > len(rom): continue
        words = list(struct.unpack(f">{sz//4}I", rom[off:off+(sz//4)*4])) if sz>=4 else []
        # The cart's OWN region map decides what counts as RAM here, so a body that runs from a
        # mapped window is judged against the addresses it actually uses. covered() accepts only
        # the declared regions, so a cart without a window is unchanged.
        d = is_data(words, v0, lambda a: (RAM_LO <= a < RAM_HI) or covered(a))
        tg = set()
        for i, w in enumerate(words):
            v = v0 + i*4; o = (w>>26)&0x3f
            if o in (0x02,0x03):
                t = ((v+4)&0xf0000000)|((w&0x3ffffff)<<2)
                if covered(t): tg.add(t)
            elif o in (0x04,0x05,0x06,0x07,0x14,0x15,0x16,0x17):
                imm=w&0xffff; simm=imm-0x10000 if imm&0x8000 else imm
                t=v+4+(simm<<2)
                if covered(t): tg.add(t)
        # JUMP TABLE: a func that is mostly in-range, 4-aligned code-addresses is a jtbl / pointer table.
        # LOCK it as DATA (force-code ranges + reachability must never disassemble it as code), and treat
        # its entries as CODE (the switch-case targets the surrounding function jumps to).
        entries = [w for w in words if covered(w) and (w & 3) == 0]
        is_jt = bool(words) and len(entries) >= max(3, (len(words) * 3) // 4)
        if is_jt:
            jtbl_entries.update(entries)
        recs.append([v0, v0+sz, (d or is_jt), tg, is_jt, is_jt])  # rec[5]=original is_jt (read-only; rec[4]=lock)

    # FORCE-CODE HOLES (2026-07-18, drmario materialization pilot): a runtime-discovered
    # function can sit in a region the full disassembly emitted NO record for (the original
    # data carve produced no func entries there), so rec_at() below returns None and the
    # force-code address silently did nothing — the whole reingest->materialize loop no-op'd.
    # Synthesize a locked CODE record from each uncovered forced address to the next known
    # record start (capped at 8KB; consecutive forced addrs in one hole chain naturally).
    # Overreach is safe: the data-vs-code veto and the build-error feedback carve wrong tails.
    recs.sort(key=lambda r: r[0])
    _starts_tmp = [r[0] for r in recs]
    synth = []
    for addr in sorted(fcode):
        k = bisect.bisect_right(_starts_tmp, addr) - 1
        covered = 0 <= k < len(recs) and recs[k][0] <= addr < recs[k][1]
        if covered: continue
        nxt = recs[k+1][0] if k+1 < len(recs) else addr + 0x2000
        synth.append((addr, min(nxt, addr + 0x2000)))
    for i in range(len(synth) - 1):
        s_a, s_e = synth[i]
        if s_e > synth[i+1][0]: synth[i] = (s_a, synth[i+1][0])
    if synth:
        print(f"[segment] force-code synthesized {len(synth)} code record(s) in disassembly holes")
        for s_a, s_e in synth:
            recs.append([s_a, s_e, False, set(), True, False])
        recs.sort(key=lambda r: r[0])

    starts = [r[0] for r in recs]
    def rec_at(addr):
        k = bisect.bisect_right(starts, addr) - 1
        if 0 <= k < len(recs) and recs[k][0] <= addr < recs[k][1]: return recs[k]
        return None
    # build-driven force-CODE (undefined-label targets, unresolved funcs; jtbl entries added below)
    for addr in fcode:
        r = rec_at(addr)
        if r: r[2] = False; r[4] = True
    # jump-table ENTRIES are switch-case CODE (the func with the `jr $reg` jumps to them)
    for addr in jtbl_entries:
        r = rec_at(addr)
        if r and not r[4]:           # don't override a locked jtbl
            r[2] = False; r[4] = True
    # force-code RANGES: a function spans [F, X] across a spurious data span -> the whole range is code
    franges = []
    if a.force_code_ranges_file:
        try:
            for l in open(a.force_code_ranges_file):
                l = l.strip()
                if l and not l.startswith("#"):
                    lo, hi = l.split()[:2]; franges.append((int(lo,16), int(hi,16)))
        except FileNotFoundError:
            pass
    for lo, hi in franges:
        for r in recs:
            if r[0] < hi and r[1] > lo:   # func overlaps the range
                if r[4] and r[2]:         # locked DATA (a jump table) -> keep as data, don't over-flip
                    continue
                r[2] = False; r[4] = True
    # REACHABILITY fixpoint: a branch/jal target from CODE is CODE (but never touch locked funcs)
    for _ in range(10):
        T = sorted(set().union(*[r[3] for r in recs if not r[2]])) if any(not r[2] for r in recs) else []
        flipped = 0
        for r in recs:
            if r[2] and not r[4]:
                k = bisect.bisect_left(T, r[0])
                if k < len(T) and T[k] < r[1]:
                    r[2] = False; flipped += 1
        if not flipped: break
    # force-DATA WINS: build-error ground truth (malformed funcs, spurious-goto funcs) is the final word,
    # overriding any force-code / jtbl-entry / reachability that tried to make these code.
    for addr in fdata:
        r = rec_at(addr)
        if r: r[2] = True; r[4] = True
    # force-DATA RANGES: carve a contiguous embedded-data blob (the data-vs-code veto's RANGE output) as bin,
    # regardless of function boundaries. A blob spans MANY small funcs (each below the per-func veto
    # threshold), so per-func force-data only carves the blob's head; the RANGE carves the WHOLE blob — every
    # func it overlaps becomes data + locked, overriding reachability / spurious-jal flips (a real data blob
    # is never code). This is the range-granular eviction the per-func veto lacked.
    dranges = []
    if a.force_data_ranges_file:
        try:
            for l in open(a.force_data_ranges_file):
                l = l.strip()
                if l and not l.startswith("#"):
                    lo, hi = l.split()[:2]; dranges.append((int(lo,16), int(hi,16)))
        except FileNotFoundError:
            pass
    for lo, hi in dranges:
        for r in recs:
            if r[0] < hi and r[1] > lo:    # func overlaps the data range
                r[2] = True; r[4] = True   # data, locked
    # merge contiguous same-class into spans; key on (is_data, is_jtbl) so a PLAIN-DATA span never merges
    # with a jtbl/pointer-table span — they emit differently (raw bin vs spimdisasm data).
    spans = []
    for v0, vend, d, _tg, _lk, jt0 in recs:
        jt = bool(d and jt0)          # jtbl/pointer-table span (keep spimdisasm 'data'); plain data -> bin
        if spans and spans[-1][2] == d and spans[-1][3] == jt and spans[-1][1] == v0:
            spans[-1] = (spans[-1][0], vend, d, jt)
        else:
            spans.append((v0, vend, d, jt))
    # ENTRYPOINT COVERAGE: some games' first toml func starts AFTER the resident base (splat made no func at
    # 0x80000400) -> the entrypoint region becomes an uncovered gap (byte-exact verify tolerates it) -> the
    # segmented re-splat has no entrypoint function -> N64Recomp aborts "Could not find entrypoint function".
    # The base is definitionally code; prepend an asm span covering [vram, first_span_start).
    if spans and spans[0][0] > vram:
        spans.insert(0, (vram, spans[0][0], False, False))
    elif spans and spans[0][0] == vram and spans[0][2]:
        # the entrypoint span EXISTS but splat classified it DATA -> the resident base is definitionally
        # code (N64Recomp needs a function there, else the severed-net absorbs it -> "Could not find
        # entrypoint function"). Force the entrypoint span to code. (ratattack / nukestrike64)
        spans[0] = (vram, spans[0][1], False, False)
    subsegs, ldsecs = [], []
    cur_region = None
    # EMIT IN ROM ORDER, NOT ADDRESS ORDER.
    #
    # `spans` inherits the address ordering `recs` needs for its bisect lookups. That is the same
    # thing for a cart whose regions rise together, and WRONG for one whose code runs from a mapped
    # window: the Acclaim Turok family maps its body to user-segment 0x00200000, which sorts BELOW
    # main's 0x80000400, so the module's spans were emitted first. splat requires ascending ROM
    # order and rejected the result outright - "segments out of order (mod2_002C4DD0 starts at
    # 0xC59D0, but next segment starts at 0x1000)" - and, because the first region encountered gets
    # no header (it is spliced into main's existing subsegment list), main was then re-declared
    # after the module, which is where the duplicate came from.
    #
    # Sort the OUTPUT only. recs/starts stay address-ordered so every lookup above is untouched.
    # For a cart with one region this is a no-op: ROM order and address order already agree.
    spans = sorted(spans, key=lambda sp: (off_of(sp[0]) if off_of(sp[0]) is not None else 0))
    for vstart, vend, d, jt in spans:
        ri = region_of_vram(vstart)
        if ri is None: continue
        if ri != cur_region:
            # A detached module is its own top-level splat segment. _subsegs.txt is spliced into
            # the yaml INSIDE the first segment's subsegments list, so emitting a 2-space-indented
            # `- name:` here opens the next segment - the same shape a hand-authored entry has.
            if cur_region is not None:
                rs, _re, rv = regions[ri]
                subsegs.append(f"  - name: {rname(ri)}")
                subsegs.append("    type: code")
                subsegs.append(f"    start: 0x{rs:X}")
                subsegs.append(f"    vram: 0x{rv:08X}")
                subsegs.append("    subsegments:")
            cur_region = ri
        rstart = off_of(vstart); name = f"{rname(ri)}_{vstart:08X}"
        if d and not jt:
            # PLAIN DATA -> raw .incbin of the cartridge bytes (byte-exact by construction: no spimdisasm
            # .double/.align 3 realignment, no symbolic .word drift). The build slices this from the ROM.
            subsegs.append(f"      - [0x{rstart:X}, bin, {name}]")
            ldsecs.append(f"    .{name} 0x{vstart:08X} : AT(0x{rstart:08X}) {{ build/asm/data/{name}.bin.o(.data); }}")
        elif d and jt:
            # JUMP/POINTER TABLE -> keep spimdisasm 'data' so segment_refine can force-code entries and gas
            # keeps the table 4-aligned. N64Recomp jtbl detection reads context.rom bytes, not this .s.
            subsegs.append(f"      - [0x{rstart:X}, data, {name}]")
            ldsecs.append(f"    .{name} 0x{vstart:08X} : AT(0x{rstart:08X}) {{ FILL(0x00000000); build/asm/data/{name}.data.s.o(.data); }}")
        else:
            subsegs.append(f"      - [0x{rstart:X}, asm, {name}]")
            ldsecs.append(f"    .{name} 0x{vstart:08X} : AT(0x{rstart:08X}) {{ FILL(0x00000000); build/asm/{name}.s.o(.text); build/asm/{name}.s.o(.rodata); build/asm/{name}.s.o(.data); }}")
            ldsecs.append(f"    .{name}_bss (NOLOAD) : {{ build/asm/{name}.s.o(.bss); }}")
    open(a.yaml_out,"w",newline="\n").write("\n".join(subsegs)+"\n")
    # GP-relative carts (loderunner3d/sprally): the SEGMENTED link needs the same pinned _gp as the
    # front-end so %gp_rel re-encodes byte-exact (sweep_game.py writes it to gp_override.txt in the
    # game dir). Without it the segmented link re-overflows GPREL16 -> segment_refine "did not converge".
    gp = 0
    _ldd = os.path.dirname(os.path.abspath(a.ld_out))
    for _c in ("gp_override.txt", os.path.join(_ldd, "gp_override.txt"), os.path.join(_ldd, "..", "gp_override.txt")):
        if os.path.exists(_c):
            try: gp = int(open(_c).read().strip(), 0)
            except Exception: gp = 0
            if gp: break
    ld = ["SECTIONS", "{", f"    _gp = 0x{gp:08X};",
          "    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }",
          "    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }"]
    ld += ldsecs
    ld += [f"    .assets 0x{(vram + 0x400000) & 0xFFFFFFFF:08X} : AT(0x{rend:08X}) {{ FILL(0x00000000); build/assets/assets.bin.o(.data); }}",
           "    /DISCARD/ : { *(*); }", "}"]
    open(a.ld_out,"w",newline="\n").write("\n".join(ld)+"\n")
    nc = sum(1 for s in spans if not s[2]); nd = sum(1 for s in spans if s[2] and not s[3]); nj = sum(1 for s in spans if s[3])
    print(f"[segment] {len(funcs)} funcs -> {len(spans)} spans ({nc} code, {nd} bin-data, {nj} jtbl-data) "
          f"[force-code {len(fcode)}, force-data {len(fdata)}] -> {a.yaml_out}, {a.ld_out}")

if __name__ == "__main__":
    main()
