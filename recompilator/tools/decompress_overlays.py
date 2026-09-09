#!/usr/bin/env python3
"""decompress_overlays.py — recompilator pre-splat step: gzip-inflate a game's compressed CODE overlays into
a working ROM so splat / match_libultra / N64Recomp see REAL instruction bytes.

Some N64 games (Rare titles like Blast Corps, etc.) ship their game code GZIP-COMPRESSED in the ROM; only a
small boot+libultra resident is uncompressed. The render/OS primitives (e.g. osViSetEvent) live in the
compressed overlays, so the static recompiler never sees them and the name-based HLE can't intercept them.
This tool decompresses the code overlays listed in <game_dir>/overlay_manifest.txt and APPENDS them to a copy
of the ROM (baserom_dec.z64) at fresh 16-aligned offsets past the original ROM end. The pristine bytes are
left 100% intact (so the resident byte-exact verify stays green), and the appended decompressed bytes give
the downstream tools (splat code segment, match_libultra --region, N64Recomp's ELF section data via the
pinned-ld AT() LMA) a ROM offset that holds real code.

Manifest format (one overlay per line, '#' comments):  rom_off  vram  expected_decomp_size  name
Outputs (under <game_dir>/build/):
  <name>_<vram>.bin     raw decompressed overlay bytes
  baserom_dec.z64       pristine ROM + appended decompressed overlays
  overlay_layout.txt    one line per overlay: name rom_off ovl_rom vram size  (consumed by ld/splat/match)

No-op (exit 0) if the game has no overlay_manifest.txt — keeps build_elf.sh general + baseline-safe.
"""
import os, sys, struct, zlib


def main():
    if len(sys.argv) < 2:
        sys.exit("usage: decompress_overlays.py <game_dir>")
    gdir = os.path.abspath(sys.argv[1])
    manifest = os.path.join(gdir, "overlay_manifest.txt")
    if not os.path.isfile(manifest):
        print(f"[decompress_overlays] no overlay_manifest.txt in {gdir} — nothing to do.")
        return 0
    rom = open(os.path.join(gdir, "baserom.z64"), "rb").read()
    pristine_size = len(rom)
    build = os.path.join(gdir, "build")
    os.makedirs(build, exist_ok=True)

    overlays = []
    for ln in open(manifest, encoding="utf-8"):
        ln = ln.split("#")[0].strip()
        if not ln:
            continue
        p = ln.split()
        # FILE-SOURCE mode (2026-07-18, the RAM-snapshot recipe): `file:<path>  vram  size  name`
        # takes the decompressed bytes from a capture file (RECOMP_RAM_SNAPSHOT) instead of
        # inflating a ROM offset — the compression-agnostic source for custom-unpacker games
        # (SOTE's "B1" class: 100% of RAM differs from the ROM; the snapshot IS the truth).
        if p[0].startswith("file:"):
            overlays.append((p[0][5:], int(p[1], 0), int(p[2], 0), p[3]))
        else:
            overlays.append((int(p[0], 0), int(p[1], 0), int(p[2], 0), p[3]))  # rom_off, vram, expected_size, name

    work = bytearray(rom)  # starts byte-identical to pristine
    layout = []
    for rom_off, vram, exp, name in overlays:
        if isinstance(rom_off, str):
            # FILE-SOURCE: the capture already IS the decompressed bytes (ROM byte order).
            src_path = rom_off if os.path.isabs(rom_off) else os.path.join(gdir, rom_off)
            dec = open(src_path, "rb").read()
            rom_off = 0  # layout wants a number; 0 = "no in-ROM compressed source"
        else:
            # FORMAT AUTO-DETECT (2026-07-18, drmario): gzip when the 1F 8B magic is present, else
            # HEADERLESS RAW DEFLATE (drmario's gzip_smallmem segments carry no gzip header — the
            # boot stub knows the offsets; verified: raw inflate of rom 0x11A70 reproduces every
            # RECOMP_GAP_DUMP-captured function at one consistent vram base).
            if rom[rom_off:rom_off+2] == b"\x1f\x8b":
                d = zlib.decompressobj(16 + zlib.MAX_WBITS)  # 16 = gzip header
            else:
                d = zlib.decompressobj(-zlib.MAX_WBITS)      # raw deflate, stops at its own final block
            dec = d.decompress(rom[rom_off:])
        if len(dec) != exp:                          # HARD assert — a wrong decode corrupts everything downstream
            sys.exit(f"[decompress_overlays] {name}: decompressed {len(dec)} B, expected 0x{exp:X} — ABORT")
        w0 = struct.unpack(">I", dec[:4])[0]
        if not ((w0 >> 16) == 0x27BD and (w0 & 0x8000)):
            print(f"[decompress_overlays] WARNING {name}: first word 0x{w0:08X} is not a prologue "
                  "(addiu sp,sp,-N) — overlay may start with a header; continuing.")
        # CONTIGUOUS MERGE: an overlay whose vram directly continues the previous one (e.g. hd_code's rodata /
        # jump-table data, a separate gzip blob sitting right after its .text) is FOLDED into the previous
        # overlay — appended with NO fresh 16-align so the bytes stay contiguous in the working ROM, and the
        # previous layout entry + .bin are extended. The recompiler then sees ONE section spanning code+rodata,
        # so jump tables that live in the rodata resolve against the reading function's OWN section (no
        # cross-section lookup, no resident-placeholder collision). General: any code overlay whose rodata is a
        # separate blob. (Blast Corps: hd_code .text @0x802447C0 + its jtbl rodata @0x802E8B20.)
        if layout and vram == layout[-1][3] + layout[-1][4] and len(work) == layout[-1][2] + layout[-1][4]:
            work.extend(dec)
            pname, prom_off, povl_rom, pvram, psize = layout[-1]
            with open(os.path.join(build, f"{pname}_{pvram:08X}.bin"), "ab") as bf:
                bf.write(dec)
            layout[-1] = (pname, prom_off, povl_rom, pvram, psize + len(dec))
            print(f"[decompress_overlays] {name}: 0x{len(dec):X} B @ vram 0x{vram:08X} MERGED (contiguous) "
                  f"into {pname} -> 0x{psize + len(dec):X} B total")
            continue
        open(os.path.join(build, f"{name}_{vram:08X}.bin"), "wb").write(dec)
        ovl_rom = (len(work) + 0xF) & ~0xF           # 16-align the append offset
        work.extend(b"\x00" * (ovl_rom - len(work)))
        work.extend(dec)
        layout.append((name, rom_off, ovl_rom, vram, len(dec)))
        print(f"[decompress_overlays] {name}: ROM 0x{rom_off:06X} (gzip) -> 0x{len(dec):X} B @ vram "
              f"0x{vram:08X}, appended at working-ROM 0x{ovl_rom:08X}")

    assert bytes(work[:pristine_size]) == rom, "working ROM diverges from pristine in the resident region!"
    open(os.path.join(build, "baserom_dec.z64"), "wb").write(work)
    with open(os.path.join(build, "overlay_layout.txt"), "w", newline="\n") as f:
        f.write("# name rom_off ovl_rom vram size  (decompress_overlays.py)\n")
        for name, rom_off, ovl_rom, vram, size in layout:
            f.write(f"{name} 0x{rom_off:08X} 0x{ovl_rom:08X} 0x{vram:08X} 0x{size:08X}\n")
    print(f"[decompress_overlays] wrote build/baserom_dec.z64 ({len(work)} B = pristine {pristine_size} + "
          f"{len(overlays)} overlay(s)) + build/overlay_layout.txt")
    return 0


if __name__ == "__main__":
    sys.exit(main())
