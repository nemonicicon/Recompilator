#!/usr/bin/env python3
"""verify_diff_to_forcedata.py — recompilator roadmap tool #2.

Turns verify_rom_match's byte-DIFFS into auto force-data. Each divergent ROM byte is mapped back to its
owning toml function (rom_off = rom_base + (func_vram - vram_base)); a function that diverges is a span the
front-end mis-assembled as CODE but that doesn't round-trip byte-exact, i.e. it is really DATA. Forcing
those functions to data makes the rebuild byte-exact. The owning function vrams are merged into the
front-end's _force_data.txt, which segment_refine.py / gen_segmented.py already consume.

This replaces the hand-seeded FORCE_DATA_SEED dict in sweep_game.py — the "verify-driven force-data loop"
the author explicitly wished for (sweep_game.py:40-44).

Coverage GAPS (uncovered ROM not in any ELF section) are REPORTED but never force-data'd: a gap needs
segmentation (yaml assets terminator / overlay segments), not a force-data flag on a non-existent func.

Limitation (v1): the rom<->vram map uses the single RESIDENT delta (--vram/--rom-off). Functions inside
relocatable OVERLAY sections have a different delta, so a divergence there is counted as "unmapped" and
reported (not silently mis-forced). Resident divergences — the common force-data case — are handled.

Usage (run from the game dir, or pass explicit paths):
  python verify_diff_to_forcedata.py --toml <fe>/<g>.toml --fe-dir <fe> \
     [--elf build/<g>.elf] [--rom baserom.z64] [--vram 0x80000400] [--rom-off 0x1000] [--apply]
Dry-run (default) only reports; --apply merges into <fe>/_force_data.txt.
Exit 0 = byte-exact / nothing to force; exit 2 = divergences found (force-data emitted or proposed).
"""
import argparse, os, re, sys, glob, bisect

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import verify_rom_match as vrm

def parse_toml_funcs(toml_path):
    """Return [(vram, size)] from the toml's function_sizes list (same regex as classify_funcs.py).

    ASSUMES the disassemble_all FULL toml (segment_refine passes a.full_toml). gen_toml only emits
    ELF-zero-sized FUNCs into function_sizes[], but splat's glabel'd funcs all land in that branch, so the
    full toml empirically lists every resident func with a computed size. A non-disassemble_all toml with
    pre-sized funcs would under-count the diff->func mapping — only feed this the *_full.toml."""
    txt = open(toml_path, encoding="utf-8").read()
    funcs = re.findall(r'\{\s*name\s*=\s*"(func_[0-9A-Fa-f]+)"\s*,\s*size\s*=\s*(\d+)\s*\}', txt)
    return [(int(n.split("_")[1], 16), int(s)) for n, s in funcs]

def build_spans(funcs, vram_base, rom_base):
    """funcs=[(vram,size)] -> sorted [(rom_start, rom_end, vram, size)] using the resident rom<->vram delta."""
    spans = [(rom_base + (v - vram_base), rom_base + (v - vram_base) + s, v, s) for v, s in funcs]
    spans.sort()
    return spans

def map_diffs_to_funcs(diffs, spans):
    """Map each divergent rom offset to its owning func span (binary search over sorted spans).
    Returns (forced, unmapped): forced = {func_vram: [size, divergent_byte_count]}, unmapped = int."""
    starts = [s[0] for s in spans]
    forced = {}
    unmapped = 0
    for off in diffs:
        idx = bisect.bisect_right(starts, off) - 1
        if idx >= 0 and spans[idx][0] <= off < spans[idx][1]:
            v, sz = spans[idx][2], spans[idx][3]
            forced.setdefault(v, [sz, 0])[1] += 1
        else:
            unmapped += 1
    return forced, unmapped

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--elf", default=None)
    ap.add_argument("--rom", default="baserom.z64")
    ap.add_argument("--toml", required=True)
    ap.add_argument("--vram", default="0x80000400")
    ap.add_argument("--rom-off", default="0x1000")
    ap.add_argument("--fe-dir", default=".")
    ap.add_argument("--out", default=None, help="force-data file (default <fe-dir>/_force_data.txt)")
    ap.add_argument("--apply", action="store_true", help="merge into _force_data.txt (default: dry-run report)")
    a = ap.parse_args()

    elf = a.elf
    if not elf:
        elfs = sorted(glob.glob("build/*.elf"))
        if not elfs:
            sys.exit("verify_diff_to_forcedata: no build/*.elf in CWD (pass --elf or run from the game dir)")
        elf = elfs[0]
    vram_base = int(a.vram, 0)
    rom_base = int(a.rom_off, 0)
    out_path = a.out or os.path.join(a.fe_dir, "_force_data.txt")

    # UNCAPPED: this is a measurement that drives a decision, not a printout.
    r = vrm.analyze(elf, a.rom, max_diffs=None)
    diffs, gaps = r["diffs"], r["gap_ranges"]
    if not diffs and not gaps:
        print("[fd] BYTE-EXACT - no diffs, no coverage gaps. Nothing to force-data.")
        return 0

    spans = build_spans(parse_toml_funcs(a.toml), vram_base, rom_base)
    forced, unmapped = map_diffs_to_funcs(diffs, spans)

    print(f"[fd] {len(diffs)}{'+' if len(diffs) >= 4096 else ''} divergent byte(s) -> "
          f"{len(forced)} owning func(s) to force-data"
          + (f"; {unmapped} unmapped (not inside any resident toml func — overlay/data?)" if unmapped else ""))
    for vram in sorted(forced):
        size, hits = forced[vram]
        print(f"  force-data func_{vram:08X} (size 0x{size:X}, {hits} divergent byte(s))")
    if gaps:
        print(f"[fd] NOTE: {len(gaps)} coverage-gap range(s) NOT force-data'd (need segmentation, not force-data):")
        for s, e in gaps[:8]:
            print(f"  uncovered rom 0x{s:08X}..0x{e:08X} (0x{e - s:X} bytes)")

    if not forced:
        return 2 if diffs else 0

    # Merge owning-func vrams into _force_data.txt (dedup with any existing entries).
    existing = set()
    if os.path.exists(out_path):
        for line in open(out_path, encoding="utf-8"):
            line = line.strip()
            if line and not line.startswith("#"):
                try:
                    existing.add(int(line, 0))
                except ValueError:
                    pass
    new = set(forced.keys()) - existing
    merged = sorted(existing | set(forced.keys()))
    if a.apply:
        with open(out_path, "w", newline="\n", encoding="utf-8") as f:
            f.write("\n".join(f"0x{v:08X}" for v in merged) + ("\n" if merged else ""))
        print(f"[fd] APPLIED: +{len(new)} new, {len(merged)} total -> {out_path}")
    else:
        print(f"[fd] DRY-RUN: would add +{len(new)} new ({len(merged)} total) to {out_path}  (re-run with --apply)")
    return 2

if __name__ == "__main__":
    sys.exit(main())
