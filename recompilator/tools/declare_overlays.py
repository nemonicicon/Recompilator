#!/usr/bin/env python3
"""declare_overlays.py — THE RECOMPILATOR generic RELOCATABLE-OVERLAY declarer (SINGLE SOURCE).

Turns a cart's own bytes into N64Recomp relocatable sections. NOTHING here is per-game: the file
table, the overlay table, every overlay's section sizes and its whole relocation list are FOUND in
the ROM at run time. No decomp, no symbol list, no hand-typed address.

THE FOUR FACTS THE CART CARRIES (and where each is read from)
  1. THE FILE TABLE (`dmadata`). A libultra cart's file table is an array of
     {vromStart, vromEnd, romStart, romEnd} u32 records whose FIRST record is
     {0, <makerom size>, 0, 0} and which chains forward (vromStart never goes backwards,
     vromEnd > vromStart, and a compressed file has romEnd > romStart). Located by scanning the
     ROM on 16-byte boundaries for that shape and taking the longest chain.
     `romEnd == 0` -> the file is stored raw; `romEnd != 0` -> it is stored COMPRESSED at
     [romStart, romEnd) and its decompressed length is vromEnd - vromStart.
  2. THE OVERLAY TABLE. An N64 relocatable-overlay record begins with the four words
     {vromStart, vromEnd, vramStart, vramEnd} followed by `loadedRamAddr` = 0 (nothing is loaded
     at build time). It is recognised WITHOUT knowing its stride: vromStart/vromEnd must be an
     EXACT span of the file table, vramStart/vramEnd must be KSEG0, and the vram length must equal
     the vrom length (the record describes the DECOMPRESSED image). Every decompressed file is
     scanned for that shape; the file holding the most records is the game's code file.
  3. THE OVERLAY RELOCATION TRAILER. Every N64 relocatable overlay ends with its own relocation
     section, and the file's LAST word is the distance BACK from the file end to that section:
         u32 textSize, dataSize, rodataSize, bssSize, nRelocations; u32 relocations[nRelocations]
     Each relocation word is  (section << 30) | (type << 24) | offset  with section 1=.text,
     2=.data, 3=.rodata and `type` the MIPS ELF relocation number itself (2 = R_MIPS_32,
     4 = R_MIPS_26, 5 = R_MIPS_HI16, 6 = R_MIPS_LO16). The overlay's code is linked at vramStart
     and the loader re-points it at the address it allocates — which is exactly ELF REL semantics
     against a symbol defined at the section base, so the trailer converts 1:1 into `.rel` entries.
  4. FUNCTION BOUNDARIES. The overlay has no symbols, so starts are derived: {0} + every
     intra-overlay `jal` target (the R_MIPS_26 relocations name them exactly) + the word after
     every `jr $ra` and its delay slot with padding skipped, MINUS every address some instruction
     in .text can reach without calling it (a branch target, a `j` target, a jump-table entry) --
     those are interior labels, and splitting there truncates the real function. See
     derive_function_starts() and [[overlay_boundary_rules]].

WHAT IT WRITES  (all derived; a game with no overlay table is a silent no-op)
  <game>/<game>_overlay_table.txt   the recovered table (cache + audit trail)
  <game>/<game>_overlays.txt        the N64Recomp relocatable-sections list (one name per line)
  <game>/build/baserom_dec.z64      pristine ROM + the decompressed overlays appended past its end
  <game>/build/overlay_layout.txt   name / compressed rom / appended rom / vram / size
  <game>/build/ovl/<name>.bin       each overlay's decompressed bytes (the .incbin source)
  <game>/build/overlay_sections.ld  the pinned-ld SECTIONS lines for the overlays
  <game>/build/overlay_relocs.bin   the relocation lists, for the post-link ELF injection
  <game>/asm/ovl/<name>.s           one assembly stub per overlay: the section, its function
                                    symbols with sizes, and .incbin of the real bytes

USAGE
  declare_overlays.py <game> discover   find + cache the overlay table, print what the bytes gave
  declare_overlays.py <game> prepare    (build_elf.sh, after the build wipe, before splat)
  declare_overlays.py <game> spliceld   (build_elf.sh) add the overlay SECTIONS to build/<game>.ld
  declare_overlays.py <game> relocs     (build_elf.sh, after the link) inject .rel.<section>
"""
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import yaz0                                                    # noqa: E402

N64PC = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# ── relocation word encoding (fact 3) ─────────────────────────────────────────
RELOC_SECTION = lambda r: (r >> 30) & 3          # noqa: E731  1=.text 2=.data 3=.rodata
RELOC_TYPE    = lambda r: (r >> 24) & 0x3F       # noqa: E731  the MIPS ELF reloc number
RELOC_OFFSET  = lambda r: r & 0x00FFFFFF         # noqa: E731  byte offset inside that section

R_MIPS_32, R_MIPS_26, R_MIPS_HI16, R_MIPS_LO16 = 2, 4, 5, 6
# A file table entry whose ROM span is -1/-1 names a file that was OMITTED from the build
# (Majora's Mask carries 17 of them). It is a legal record and the table chains straight through it.
ABSENT = lambda c, d: c == 0xFFFFFFFF and d == 0xFFFFFFFF        # noqa: E731
JR_RA = 0x03E00008


# ══════════════════════════════════════════════════════════════════════════════
# FACT 1 — the file table
# ══════════════════════════════════════════════════════════════════════════════
def find_dmadata(rom, search_limit=0x200000):
    """Return (offset, entries) for the cart's file table, or (None, [])."""
    best = None
    limit = min(len(rom), search_limit)
    for off in range(0, limit, 16):
        w0, w1, w2, w3 = struct.unpack_from(">4I", rom, off)
        if w0 != 0 or w2 != 0 or w3 != 0:
            continue
        if not (0x1000 <= w1 <= 0x100000) or (w1 & 0xF):
            continue
        n, prev_end, p = 1, w1, off + 16
        while p + 16 <= len(rom):
            a, b, c, d = struct.unpack_from(">4I", rom, p)
            if a == 0 and b == 0 and c == 0 and d == 0:
                break
            if a < prev_end or b <= a or b > 0x4000000:
                break
            if not ABSENT(c, d):                 # a file omitted from the build is romStart/End = -1
                if (d != 0 and d <= c) or c >= len(rom) or (d != 0 and d > len(rom)):
                    break
            prev_end, n, p = b, n + 1, p + 16
        if n >= 64 and (best is None or n > best[1]):
            best = (off, n)
    if best is None:
        return None, []
    off = best[0]
    ents, p = [], off
    while p + 16 <= len(rom):
        a, b, c, d = struct.unpack_from(">4I", rom, p)
        if a == 0 and b == 0 and c == 0 and d == 0:
            break
        ents.append((a, b, c, d))
        p += 16
    return off, ents


def read_file_entry(rom, ent):
    """The DECOMPRESSED bytes of one file table entry (Yaz0 or raw); b"" for an omitted file."""
    vs, ve, rs, re_ = ent
    if ABSENT(rs, re_):
        return b""
    if re_ != 0:
        dec, _used = yaz0.decompress(rom, rs, limit=re_ - rs)
        return dec
    return rom[rs:rs + (ve - vs)]


# ══════════════════════════════════════════════════════════════════════════════
# FACT 2 — the overlay table
# ══════════════════════════════════════════════════════════════════════════════
def scan_overlay_records(buf, spans):
    """Every offset in `buf` where an overlay record's five leading words sit."""
    out = []
    n = len(buf) - 20
    off = 0
    while off < n:
        w0 = struct.unpack_from(">I", buf, off)[0]
        end = spans.get(w0)
        if end is not None:
            w1, w2, w3, w4 = struct.unpack_from(">4I", buf, off + 4)
            if (w1 == end and (w2 >> 24) == 0x80 and (w3 >> 24) == 0x80
                    and (w3 - w2) == (w1 - w0) and w4 == 0 and w3 > w2):
                out.append((off, w0, w1, w2, w3))
        off += 4
    return out


def discover_table(rom, verbose=True):
    """Find the file table, then the overlay table. Returns (dma_off, ents, code_index, records)."""
    dma_off, ents = find_dmadata(rom)
    if dma_off is None:
        return None, [], None, []
    spans = {a: b for a, b, c, d in ents}
    best = (None, [])
    for i, ent in enumerate(ents):
        if ent[1] - ent[0] < 0x10000 or ABSENT(ent[2], ent[3]):   # the table lives in a big code file
            continue
        try:
            buf = read_file_entry(rom, ent)
        except Exception:
            continue
        recs = scan_overlay_records(buf, spans)
        if len(recs) > len(best[1]):
            best = (i, recs)
        if verbose and recs:
            print(f"[declare_overlays] file {i} vrom {ent[0]:08X}-{ent[1]:08X}: {len(recs)} overlay record(s)")
    return dma_off, ents, best[0], best[1]


# ══════════════════════════════════════════════════════════════════════════════
# FACT 3 — the relocation trailer
# ══════════════════════════════════════════════════════════════════════════════
def parse_trailer(ov):
    """(textSize, dataSize, rodataSize, bssSize, [reloc words]) or None if the file has no trailer."""
    if len(ov) < 24:
        return None
    back = struct.unpack_from(">I", ov, len(ov) - 4)[0]
    rstart = len(ov) - back
    if not (0 < rstart <= len(ov) - 20) or (rstart & 3):
        return None
    tsz, dsz, rosz, bsz, nrel = struct.unpack_from(">5I", ov, rstart)
    if (tsz | dsz | rosz | bsz) & 3:
        return None
    if tsz + dsz + rosz != rstart:               # the three sections must fill the file exactly
        return None
    if rstart + 0x14 + nrel * 4 > len(ov):
        return None
    relocs = list(struct.unpack_from(f">{nrel}I", ov, rstart + 0x14)) if nrel else []
    return tsz, dsz, rosz, bsz, relocs


# ══════════════════════════════════════════════════════════════════════════════
# FACT 4 — function boundaries
# ══════════════════════════════════════════════════════════════════════════════
def branch_target(word, addr):
    """The PC-relative target of a MIPS branch at `addr`, or None if `word` is not a branch."""
    op = word >> 26
    if op in (4, 5, 6, 7, 20, 21, 22, 23):           # beq bne blez bgtz + their likely forms
        pass
    elif op == 1:                                    # REGIMM: bltz/bgez/bltzal/bgezal (+likely)
        if ((word >> 16) & 0x1F) not in (0, 1, 2, 3, 16, 17, 18, 19):
            return None
    elif op == 17 and ((word >> 21) & 0x1F) == 8:    # COP1 BC1F/BC1T (+likely)
        pass
    else:
        return None
    off = word & 0xFFFF
    if off & 0x8000:
        off -= 0x10000
    return addr + 4 + off * 4


def derive_function_starts(ov, vram_start, tsz, dsz, relocs):
    """Offsets (from the overlay base) at which a function begins, inside .text only.

    Three rules, every one of them read off the cart:
      START  offset 0, and every intra-overlay `jal` target. The R_MIPS_26 relocations name those
             exactly; only opcode 3 (`jal`) counts, because only a call can name a function entry.
      START  the word after every `jr $ra` and its delay slot, alignment padding skipped
             ([[overlay_boundary_rules]] miss #1: jr_ra + 8 lands on the FIRST nop).
      VETO   a `jr $ra`-derived candidate that some instruction in .text can reach WITHOUT calling
             it: the target of a PC-relative branch, the target of a `j` (R_MIPS_26 on opcode 2),
             or an entry of a switch jump table (a run of >= 3 consecutive R_MIPS_32 relocations
             4 bytes apart in .data/.rodata, all pointing into .text). A function is never ENTERED
             that way, so the address is a label INSIDE a function whose early `jr $ra` return the
             boundary rule mistook for the end of it. Splitting there does not merely add a wrong
             entry: it TRUNCATES the real function, and N64Recomp then sizes that function's switch
             by how many jump-table entries still land inside it. Measured 2026-09-06 on
             ovl_80885B00: a `beq` target at +0x35C became a false start, func_80885B0C lost its
             tail, its 13-case switch (`sltiu $at, $t6, 0xD`) emitted ONE case, and the first native
             call into the overlay took the default arm and killed the run.
    """
    jal_starts = set()
    veto = set()
    for r in relocs:
        if RELOC_TYPE(r) != R_MIPS_26 or RELOC_SECTION(r) != 1:
            continue
        off = RELOC_OFFSET(r)
        if off + 4 > tsz:
            continue
        word = struct.unpack_from(">I", ov, off)[0]
        rel = (0x80000000 | ((word & 0x03FFFFFF) << 2)) - vram_start
        if not (0 <= rel < tsz) or (rel & 3):
            continue
        if (word >> 26) == 3:                        # jal -> a function entry
            jal_starts.add(rel)
        elif (word >> 26) == 2:                      # j   -> a long branch inside a function
            veto.add(rel)
    # every PC-relative branch target inside .text is an interior label
    for i in range(0, tsz - 3, 4):
        t = branch_target(struct.unpack_from(">I", ov, i)[0], vram_start + i)
        if t is not None:
            rel = t - vram_start
            if 0 <= rel < tsz:
                veto.add(rel)
    # switch jump tables: runs of >= 3 consecutive R_MIPS_32 relocs, 4 bytes apart, in .data or
    # .rodata, whose words all point into .text. Their entries are case labels, never entries.
    sec_base = {1: 0, 2: tsz, 3: tsz + dsz}
    for sec in (2, 3):
        offs = sorted(RELOC_OFFSET(r) for r in relocs
                      if RELOC_TYPE(r) == R_MIPS_32 and RELOC_SECTION(r) == sec)
        run = []
        for o in offs + [None]:
            if run and o is not None and o == run[-1] + 4:
                run.append(o)
                continue
            if len(run) >= 3:
                tgts = []
                for ro in run:
                    fo = sec_base[sec] + ro
                    if fo + 4 > len(ov):
                        tgts = []
                        break
                    rel = struct.unpack_from(">I", ov, fo)[0] - vram_start
                    if not (0 <= rel < tsz):
                        tgts = []
                        break
                    tgts.append(rel)
                veto.update(tgts)
            run = [] if o is None else [o]
    starts = {0} | jal_starts
    i = 0
    while i + 8 <= tsz:
        if struct.unpack_from(">I", ov, i)[0] == JR_RA:
            j = i + 8
            while j + 4 <= tsz and struct.unpack_from(">I", ov, j)[0] == 0:
                j += 4
            if j < tsz and j not in veto:
                starts.add(j)
            i = j
        else:
            i += 4
    return sorted(s for s in starts if s < tsz)


# ══════════════════════════════════════════════════════════════════════════════
# the table cache
# ══════════════════════════════════════════════════════════════════════════════
def table_path(gdir, game):
    return os.path.join(gdir, f"{game}_overlay_table.txt")


def write_table(path, dma_off, ents, code_index, records, rom):
    spans = {a: (b, c, d) for a, b, c, d in ents}
    lines = [
        "# overlay table recovered from the cart's OWN bytes by recompilator/tools/declare_overlays.py",
        f"# file table (dmadata) at ROM 0x{dma_off:X}, {len(ents)} entries; "
        f"{sum(1 for e in ents if e[3] != 0 and not ABSENT(e[2], e[3]))} of them compressed, "
        f"{sum(1 for e in ents if ABSENT(e[2], e[3]))} absent (-1/-1)",
        f"# overlay records found in file index {code_index} "
        f"(vrom {ents[code_index][0]:08X}-{ents[code_index][1]:08X})",
        f"# {len(records)} records",
        "# tableOff vromStart vromEnd vramStart vramEnd size romStart romEnd compressed",
    ]
    for off, vs, ve, vrs, vre in records:
        _e, rs, re_ = spans[vs]
        lines.append(f"0x{off:06X} {vs:08X} {ve:08X} {vrs:08X} {vre:08X} "
                     f"{ve - vs:8d} {rs:08X} {re_:08X} {'Y' if re_ else 'N'}")
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lines) + "\n")


def read_table(path):
    records = []
    if not os.path.isfile(path):
        return records
    for ln in open(path, encoding="utf-8"):
        ln = ln.strip()
        if not ln or ln.startswith("#"):
            continue
        p = ln.split()
        records.append(dict(table_off=int(p[0], 16), vrom_start=int(p[1], 16), vrom_end=int(p[2], 16),
                            vram_start=int(p[3], 16), vram_end=int(p[4], 16), size=int(p[5]),
                            rom_start=int(p[6], 16), rom_end=int(p[7], 16)))
    return records


# ══════════════════════════════════════════════════════════════════════════════
# stage: discover
# ══════════════════════════════════════════════════════════════════════════════
def cmd_discover(game, gdir, rom):
    dma_off, ents, code_index, records = discover_table(rom)
    if dma_off is None:
        print("[declare_overlays] no file table in this ROM — nothing to declare.")
        return 0
    yz = sum(1 for e in ents if e[3] != 0 and not ABSENT(e[2], e[3]))
    ab = sum(1 for e in ents if ABSENT(e[2], e[3]))
    print(f"[declare_overlays] file table at ROM 0x{dma_off:X}: {len(ents)} files, "
          f"{yz} compressed, {ab} absent")
    if not records:
        print("[declare_overlays] no overlay records — nothing to declare.")
        return 0
    write_table(table_path(gdir, game), dma_off, ents, code_index, records, rom)
    print(f"[declare_overlays] {len(records)} overlay records -> {table_path(gdir, game)}")
    return 0


# ══════════════════════════════════════════════════════════════════════════════
# stage: prepare
# ══════════════════════════════════════════════════════════════════════════════
def cmd_prepare(game, gdir, rom):
    recs = read_table(table_path(gdir, game))
    if not recs:
        dma_off, ents, code_index, records = discover_table(rom, verbose=False)
        if not records:
            print("[declare_overlays] no overlay table for this game — nothing to do.")
            return 0
        write_table(table_path(gdir, game), dma_off, ents, code_index, records, rom)
        recs = read_table(table_path(gdir, game))
    recs.sort(key=lambda r: r["vram_start"])

    build = os.path.join(gdir, "build")
    ovldir = os.path.join(build, "ovl")
    asmdir = os.path.join(gdir, "asm", "ovl")
    os.makedirs(ovldir, exist_ok=True)
    os.makedirs(asmdir, exist_ok=True)

    work = bytearray(rom)
    pristine_size = len(rom)
    layout, ld_lines, names, reloc_blobs = [], [], [], []
    n_funcs = n_relocs = 0
    skipped = []

    for r in recs:
        vs, ve = r["vrom_start"], r["vrom_end"]
        vram, size = r["vram_start"], r["size"]
        rs, re_ = r["rom_start"], r["rom_end"]
        if ABSENT(rs, re_):
            skipped.append((vram, "the file table marks this file absent (-1/-1)"))
            continue
        try:
            ov = yaz0.decompress(rom, rs, limit=re_ - rs)[0] if re_ else rom[rs:rs + (ve - vs)]
        except Exception as e:
            skipped.append((vram, f"decompress failed: {e}"))
            continue
        if len(ov) != size:
            skipped.append((vram, f"decompressed {len(ov)} B, table says {size} B"))
            continue
        t = parse_trailer(ov)
        if t is None:
            skipped.append((vram, "no relocation trailer"))
            continue
        tsz, dsz, rosz, bsz, relocs = t

        name = f"ovl_{vram:08X}"
        sec = "." + name
        ovl_rom = len(work)                      # overlay file sizes are 16-aligned: no padding, no gaps
        assert (ovl_rom & 0xF) == 0, "working-ROM append lost 16-byte alignment"
        work.extend(ov)
        with open(os.path.join(ovldir, f"{name}.bin"), "wb") as f:
            f.write(ov)

        starts = derive_function_starts(ov, vram, tsz, dsz, relocs)
        n_funcs += len(starts)
        bounds = starts + [tsz]
        s = [f"/* {name}: overlay linked at 0x{vram:08X}, {size} B "
             f"(text 0x{tsz:X} data 0x{dsz:X} rodata 0x{rosz:X} bss 0x{bsz:X}), "
             f"{len(relocs)} relocations, {len(starts)} functions.",
             "   Every number here came from the cart: the file table span, the overlay record, and the",
             "   overlay's own relocation trailer. Generated by recompilator/tools/declare_overlays.py. */",
             f'.section {sec}, "ax"',
             ".set noreorder",
             ".set noat"]
        for i, off in enumerate(starts):
            fend = bounds[i + 1]
            fname = f"func_{vram + off:08X}"
            s.append(f".globl {fname}")
            s.append(f".type {fname}, @function")
            s.append(f"{fname}:")
            s.append(f'.incbin "build/ovl/{name}.bin", 0x{off:X}, 0x{fend - off:X}')
            s.append(f".size {fname}, 0x{fend - off:X}")
        if tsz < size:                            # data + rodata + the relocation trailer
            s.append(f".globl {name}_data")
            s.append(f"{name}_data:")
            s.append(f'.incbin "build/ovl/{name}.bin", 0x{tsz:X}, 0x{size - tsz:X}')
        with open(os.path.join(asmdir, f"{name}.s"), "w", encoding="utf-8", newline="\n") as f:
            f.write("\n".join(s) + "\n")

        ld_lines.append(f"    {sec} 0x{vram:08X} : AT(0x{ovl_rom:08X}) "
                        f"{{ build/asm/ovl/{name}.s.o({sec}); }}")
        layout.append((name, rs, ovl_rom, vram, size))
        names.append(sec)

        # the .rel entries: (vram address of the relocated word, MIPS reloc type), trailer order
        sec_base = {1: 0, 2: tsz, 3: tsz + dsz}
        entries = []
        for w in relocs:
            b = sec_base.get(RELOC_SECTION(w))
            if b is None:
                continue
            entries.append((vram + b + RELOC_OFFSET(w), RELOC_TYPE(w)))
        n_relocs += len(entries)
        blob = bytearray()
        blob += struct.pack(">I", len(sec)) + sec.encode()
        blob += struct.pack(">I", len(entries))
        for addr, typ in entries:
            blob += struct.pack(">II", addr, typ)
        reloc_blobs.append(bytes(blob))

    assert bytes(work[:pristine_size]) == rom, "the working ROM diverges from the pristine ROM!"
    with open(os.path.join(build, "baserom_dec.z64"), "wb") as f:
        f.write(work)
    with open(os.path.join(build, "overlay_layout.txt"), "w", newline="\n") as f:
        f.write("# name rom_off ovl_rom vram size  (declare_overlays.py)\n")
        for name, rom_off, ovl_rom, vram, size in layout:
            f.write(f"{name} 0x{rom_off:08X} 0x{ovl_rom:08X} 0x{vram:08X} 0x{size:08X}\n")
    with open(os.path.join(build, "overlay_sections.ld"), "w", newline="\n") as f:
        f.write("\n".join(ld_lines) + "\n")
    with open(os.path.join(build, "overlay_relocs.bin"), "wb") as f:
        f.write(struct.pack(">I", len(reloc_blobs)))
        for b in reloc_blobs:
            f.write(b)
    with open(os.path.join(gdir, f"{game}_overlays.txt"), "w", newline="\n") as f:
        f.write("\n".join(names) + "\n")

    print(f"[declare_overlays] {len(layout)} overlays declared: {n_funcs} functions, "
          f"{n_relocs} relocations, {len(work) - pristine_size} B appended "
          f"(working ROM {len(work)} B)")
    if skipped:
        print(f"[declare_overlays] {len(skipped)} record(s) skipped:")
        for v, why in skipped[:10]:
            print(f"    0x{v:08X}: {why}")
    return 0


# ══════════════════════════════════════════════════════════════════════════════
# stage: spliceld — put the overlay SECTIONS into the copied pinned linker script
# ══════════════════════════════════════════════════════════════════════════════
def cmd_spliceld(game, gdir, rom):
    src = os.path.join(gdir, "build", "overlay_sections.ld")
    dst = os.path.join(gdir, "build", f"{game}.ld")
    if not os.path.isfile(src):
        print("[declare_overlays] no build/overlay_sections.ld — linker script untouched.")
        return 0
    ld = open(dst, encoding="utf-8").read().split("\n")
    ovl = open(src, encoding="utf-8").read().rstrip("\n").split("\n")
    if any(l.strip().startswith(".ovl_") for l in ld):
        print("[declare_overlays] overlay sections already present in the linker script.")
        return 0
    at = next((i for i, l in enumerate(ld) if "/DISCARD/" in l), max(len(ld) - 1, 0))
    ld[at:at] = ovl
    with open(dst, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(ld))
    print(f"[declare_overlays] spliced {len(ovl)} overlay section(s) into build/{game}.ld")
    return 0


# ══════════════════════════════════════════════════════════════════════════════
# stage: relocs — inject .rel.<section> into the linked ELF
# ══════════════════════════════════════════════════════════════════════════════
def cmd_relocs(game, gdir, rom):
    blob_path = os.path.join(gdir, "build", "overlay_relocs.bin")
    elf_path = os.path.join(gdir, "build", f"{game}.elf")
    if not os.path.isfile(blob_path):
        print("[declare_overlays] no build/overlay_relocs.bin — nothing to inject.")
        return 0
    blob = open(blob_path, "rb").read()
    pos = 0
    (nsec,) = struct.unpack_from(">I", blob, pos); pos += 4
    want = []
    for _ in range(nsec):
        (ln,) = struct.unpack_from(">I", blob, pos); pos += 4
        name = blob[pos:pos + ln].decode(); pos += ln
        (nent,) = struct.unpack_from(">I", blob, pos); pos += 4
        ents = list(struct.unpack_from(f">{nent * 2}I", blob, pos)) if nent else []
        pos += nent * 8
        want.append((name, [(ents[i * 2], ents[i * 2 + 1]) for i in range(nent)]))

    d = bytearray(open(elf_path, "rb").read())
    assert d[:4] == b"\x7fELF" and d[4] == 1 and d[5] == 2, "expected a 32-bit big-endian ELF"
    e_shoff = struct.unpack_from(">I", d, 0x20)[0]
    e_shentsize, e_shnum, e_shstrndx = struct.unpack_from(">3H", d, 0x2E)
    assert e_shentsize == 40, "unexpected section header size"

    def shdr(i):
        o = e_shoff + i * 40
        return list(struct.unpack_from(">10I", d, o))

    shdrs = [shdr(i) for i in range(e_shnum)]
    shstr_off, shstr_size = shdrs[e_shstrndx][4], shdrs[e_shstrndx][5]
    shstr = bytes(d[shstr_off:shstr_off + shstr_size])

    def sname(i):
        n = shdrs[i][0]
        return shstr[n:shstr.index(b"\0", n)].decode()

    by_name = {sname(i): i for i in range(e_shnum)}
    symtab_index = next((i for i in range(e_shnum) if shdrs[i][1] == 2), None)
    assert symtab_index is not None, "no symtab in the ELF"
    sym_off, sym_size = shdrs[symtab_index][4], shdrs[symtab_index][5]

    # one symbol per overlay section: N64Recomp reads only the symbol's SECTION, so any
    # symbol defined in the section identifies it (elf.cpp: rel_section_vram = that section's vram).
    sym_for_section = {}
    for i in range(sym_size // 16):
        o = sym_off + i * 16
        st_shndx = struct.unpack_from(">H", d, o + 14)[0]
        if st_shndx and st_shndx < e_shnum and st_shndx not in sym_for_section:
            sym_for_section[st_shndx] = i

    new_shstr = bytearray(shstr)
    new_shdrs = []
    out = bytearray(d)
    injected = missing = total = 0
    for name, ents in want:
        si = by_name.get(name)
        if si is None:
            missing += 1
            continue
        sym = sym_for_section.get(si)
        if sym is None:
            missing += 1
            continue
        while len(out) & 3:
            out.append(0)
        off = len(out)
        for addr, typ in ents:
            out += struct.pack(">II", addr, (sym << 8) | typ)
        nm_off = len(new_shstr)
        new_shstr += (".rel" + name).encode() + b"\0"
        new_shdrs.append([nm_off, 9, 0, 0, off, len(ents) * 8, symtab_index, si, 4, 8])
        injected += 1
        total += len(ents)

    while len(out) & 3:
        out.append(0)
    new_shstr_off = len(out)
    out += new_shstr
    shdrs[e_shstrndx][4] = new_shstr_off
    shdrs[e_shstrndx][5] = len(new_shstr)
    while len(out) & 3:
        out.append(0)
    new_shoff = len(out)
    for h in shdrs + new_shdrs:
        out += struct.pack(">10I", *h)
    struct.pack_into(">I", out, 0x20, new_shoff)
    struct.pack_into(">H", out, 0x30, e_shnum + len(new_shdrs))
    with open(elf_path, "wb") as f:
        f.write(out)
    print(f"[declare_overlays] injected {injected} .rel sections ({total} relocations) into "
          f"{os.path.basename(elf_path)}; {missing} section(s) not found in the ELF")
    return 0


def main(argv):
    if len(argv) < 2:
        print(__doc__)
        return 2
    game = argv[1]
    stage = argv[2] if len(argv) > 2 else "discover"
    gdir = game if os.path.isdir(game) else os.path.join(N64PC, game)
    gdir = os.path.abspath(gdir)
    game = os.path.basename(gdir)
    rom = open(os.path.join(gdir, "baserom.z64"), "rb").read()
    if stage == "discover":
        return cmd_discover(game, gdir, rom)
    if stage == "prepare":
        return cmd_prepare(game, gdir, rom)
    if stage == "spliceld":
        return cmd_spliceld(game, gdir, rom)
    if stage == "relocs":
        return cmd_relocs(game, gdir, rom)
    print(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv))
