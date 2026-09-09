#!/usr/bin/env python3
"""verify_rom_match.py — hard byte-exact gate for the splat-less front-end (GAME #4).

Reconstructs the ROM the way N64Recomp's elf.cpp does (each allocated PROGBITS section
copied to rom = segment.paddr + (sh_offset - segment.offset)) and byte-compares against
baserom.z64. Any mismatch => the recompiled output would diverge from hardware.
Exit 0 = byte-exact. Exit 1 = divergence. Run from the game repo root.

Also exposes analyze(elf, rom) so tooling (verify_diff_to_forcedata.py = roadmap tool #2) can ride
the same reconstruction + diff/gap computation instead of duplicating the ELF logic.
"""
import struct, sys, os, glob

# Agnostic resolution — run from the GAME dir (CWD): ELF = the single build/*.elf, ROM = ./baserom.z64.
# Or pass explicit paths: verify_rom_match.py <elf> <rom>. NEVER hardcode a game name.
def _resolve():
    if len(sys.argv) >= 3:
        return sys.argv[1], sys.argv[2]
    rom = "baserom.z64"
    elfs = sorted(glob.glob("build/*.elf"))
    if not elfs:
        sys.exit("verify_rom_match: no build/*.elf in CWD (run from the game dir or pass <elf> <rom>)")
    if len(elfs) > 1:
        cwd = os.path.basename(os.getcwd())
        elfs = [e for e in elfs if os.path.basename(e) == f"{cwd}.elf"] or elfs
    return elfs[0], rom

def parse_elf(path):
    d = open(path, "rb").read()
    assert d[:4] == b"\x7fELF", "not an ELF"
    is64 = d[4] == 2
    en = ">" if d[5] == 2 else "<"
    if is64:
        e_phoff, e_shoff = struct.unpack_from(en + "QQ", d, 0x20)
        e_phentsize, e_phnum, e_shentsize, e_shnum, e_shstrndx = struct.unpack_from(en + "HHHHH", d, 0x36)
    else:
        e_phoff, e_shoff = struct.unpack_from(en + "II", d, 0x1C)
        e_phentsize, e_phnum, e_shentsize, e_shnum, e_shstrndx = struct.unpack_from(en + "HHHHH", d, 0x2A)
    phdrs = []
    for i in range(e_phnum):
        o = e_phoff + i * e_phentsize
        if is64:
            p_type, p_flags = struct.unpack_from(en + "II", d, o)
            p_offset, p_vaddr, p_paddr, p_filesz, p_memsz, p_align = struct.unpack_from(en + "QQQQQQ", d, o + 8)
        else:
            p_type, p_offset, p_vaddr, p_paddr, p_filesz, p_memsz, p_flags, p_align = struct.unpack_from(en + "IIIIIIII", d, o)
        phdrs.append(dict(type=p_type, offset=p_offset, vaddr=p_vaddr, paddr=p_paddr, filesz=p_filesz))
    sections = []
    for i in range(e_shnum):
        o = e_shoff + i * e_shentsize
        if is64:
            sh_name, sh_type = struct.unpack_from(en + "II", d, o)
            sh_flags, sh_addr, sh_offset, sh_size = struct.unpack_from(en + "QQQQ", d, o + 8)
        else:
            sh_name, sh_type, sh_flags, sh_addr, sh_offset, sh_size = struct.unpack_from(en + "IIIIII", d, o)
        sections.append(dict(name_off=sh_name, type=sh_type, flags=sh_flags,
                             addr=sh_addr, offset=sh_offset, size=sh_size))
    shstr = sections[e_shstrndx]
    strtab = d[shstr["offset"]:shstr["offset"] + shstr["size"]]
    for s in sections:
        end = strtab.find(b"\0", s["name_off"])
        s["name"] = strtab[s["name_off"]:end].decode()
    return d, phdrs, sections

BOOT_END = 0x1000  # header 0x0..0x40 + ipl3 0x40..0x1000 are never recompiled; gaps there are expected.

def analyze(elf_path, rom_path, max_diffs=4096):
    """Reconstruct the ROM from ELF section placements and diff it against baserom.

    Returns a dict:
      sec_log    : list of per-section records in ELF order, each {name, vma, placed, rom_addr, size, reason, over_end}
      diffs      : list of differing rom offsets (capped at 4096, same as the CLI)
      gap_ranges : list of (start, end) uncovered runs in the recompile region (rom >= BOOT_END)
      rom_len    : len(baserom)
      image      : the reconstructed image (bytearray)
      rom        : the baserom bytes
    Pure: prints nothing, never exits. The CLI main() formats + decides the exit code from this.
    """
    d, phdrs, sections = parse_elf(elf_path)
    rom = open(rom_path, "rb").read()
    image = bytearray(len(rom))
    covered = bytearray(len(rom))
    sec_log = []
    for s in sections:
        if not (s["flags"] & 0x2) or s["type"] == 8 or s["size"] == 0:  # !ALLOC or NOBITS or empty
            continue
        seg = next((p for p in phdrs if p["type"] == 1 and
                    p["offset"] <= s["offset"] < p["offset"] + max(p["filesz"], 1)), None)
        if seg is None:
            sec_log.append(dict(name=s["name"], vma=s["addr"], placed=False, rom_addr=0,
                                size=s["size"], reason="not in any PT_LOAD — skipped by N64Recomp", over_end=False))
            continue
        rom_addr = seg["paddr"] + (s["offset"] - seg["offset"])
        over_end = (rom_addr + s["size"] > len(image))
        rec = dict(name=s["name"], vma=s["addr"], placed=True, rom_addr=rom_addr,
                   size=s["size"], reason="", over_end=over_end)
        sec_log.append(rec)
        if over_end:
            return dict(sec_log=sec_log, diffs=[], gap_ranges=[], rom_len=len(rom), image=image, rom=rom)
        image[rom_addr:rom_addr + s["size"]] = d[s["offset"]:s["offset"] + s["size"]]
        covered[rom_addr:rom_addr + s["size"]] = b"\1" * s["size"]
    diffs = []
    gap_ranges = []
    run_start = None
    for i in range(len(rom)):
        covd = covered[i]
        if not covd and i >= BOOT_END:
            if run_start is None:
                run_start = i
        elif run_start is not None:
            gap_ranges.append((run_start, i)); run_start = None
        if not covd:
            continue
        if image[i] != rom[i]:
            diffs.append(i)
            # THE CAP IS A DISPLAY BUDGET, NOT A MEASUREMENT. Breaking here also truncates
            # gap_ranges, and - the reason this became a parameter - verify_diff_to_forcedata
            # rides on this list to decide which functions to force to data. With a hard 4096 it
            # only ever sees the FIRST 4096 divergent bytes, so a single large unmapped region at
            # a low ROM offset hides every mappable function behind it and the refinement loop
            # aborts with "found no new resident func to force" while candidates remain.
            # Space Invaders, 2026-09-08: 4096 diffs, 3891 of them unmapped, loop dead.
            # The CLI keeps the budget; tool #2 passes max_diffs=None.
            if max_diffs is not None and len(diffs) >= max_diffs:
                break
    if run_start is not None:
        gap_ranges.append((run_start, len(rom)))
    return dict(sec_log=sec_log, diffs=diffs, gap_ranges=gap_ranges, rom_len=len(rom), image=image, rom=rom)

def main():
    ELF, ROM = _resolve()
    r = analyze(ELF, ROM)
    image, rom = r["image"], r["rom"]
    print("section -> rom placement (N64Recomp elf.cpp formula):")
    for s in r["sec_log"]:
        if not s["placed"]:
            print(f"  {s['name']:<24} vma=0x{s['vma']:08X} {s['reason']}")
            continue
        print(f"  {s['name']:<24} vma=0x{s['vma']:08X} rom=0x{s['rom_addr']:08X} size=0x{s['size']:X}")
        if s["over_end"]:
            print(f"    !! extends past ROM end (0x{len(rom):X})")
            sys.exit(1)
    # Total uncovered bytes in the recompile region (boot ROM < BOOT_END is exempt and excluded from gap_ranges).
    gap_bytes = sum(e - s for s, e in r["gap_ranges"])
    print(f"\ncoverage gaps: 0x{gap_bytes:X} bytes uncovered (recompile region rom >= 0x{BOOT_END:X}; boot ROM exempt)")
    diffs = r["diffs"]
    if diffs:
        print(f"DIVERGENT: {len(diffs)}{'+' if len(diffs) >= 4096 else ''} differing bytes")
        for i in diffs[:10]:
            print(f"  rom 0x{i:08X}: elf={image[i]:02X} rom={rom[i]:02X}")
        sys.exit(1)
    if r["gap_ranges"]:
        ngap = sum(e - s for s, e in r["gap_ranges"])
        print(f"COVERAGE GAP: 0x{ngap:X} bytes of the recompile region (rom >= 0x{BOOT_END:X}) are in NO")
        print("ELF section -> N64Recomp's context.rom has holes (silent-divergence risk). Extend the")
        print("front-end segmentation (yaml assets terminator / overlay segments) to cover these ranges:")
        for s, e in r["gap_ranges"][:16]:
            print(f"  uncovered rom 0x{s:08X}..0x{e:08X}  (0x{e - s:X} bytes)")
        sys.exit(1)
    print("BYTE-EXACT: ELF-reconstructed ROM matches baserom.z64 over the FULL ROM (no coverage gaps).")

if __name__ == "__main__":
    main()
