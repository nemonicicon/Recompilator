#!/usr/bin/env python3
"""data_vs_code_veto.py — recompilator P1 tool: the data-vs-code veto classifier (diagnostics-driven).

Reads the #1 diagnostics sink's failures.json and carves the EMBEDDED DATA BLOBS that splat disassembled as
code — large contiguous regions whose bytes N64Recomp decodes as garbage instructions (the unhandled-opcode
flood that wedges segment_refine with "recomp stuck"). It emits them as force-data RANGES (vaddr lo..hi),
which gen_segmented turns into `bin` subsegments so the blob is never recompiled.

WHY RANGES, NOT FUNCTIONS: a data blob spans MANY small "functions" (splat names a few addresses inside it;
each carries only a slice of the garbage). Per-function force-data only carves the named head and leaves the
blob's tail decoding as code. Clustering the unhandled-opcode vaddrs directly recovers the blob's true extent
regardless of the spurious function boundaries inside it. (Validated on Blast Corps: ~586 blobs, biggest
6.6 KB; per-func eviction cleared 4k of 33,812 unhandled, range eviction clears the blob whole.)

CONSERVATIVE BY DESIGN: a cluster is built ONLY from unhandled-opcode vaddrs, so it is garbage-dense by
construction; the `--gap` bridges the occasional valid-decoding data word inside a blob, and `--min-words`
drops tiny clusters so a real function with one genuinely-rare instruction (a real `sync`/`cache`) is never
carved. force-data is byte-exact-NEUTRAL (same bytes, classified data vs code), so a wrong carve cannot break
the byte-exact gate — the floors are there to avoid turning a few real edge instructions into data.

Usage:
  python data_vs_code_veto.py --failures <app>/RecompiledFuncs/failures.json --fe-dir <fe> \
     [--gap 0x40] [--min-words 6] [--apply]
Dry-run (default) reports; --apply merges into <fe>/_force_data_ranges.txt (lo hi per line; coalesced).
Exit 0 = nothing to carve; exit 2 = data blobs found (ranges emitted or proposed).
"""
import argparse, bisect, json, os, sys

def cluster(vaddrs, gap):
    """Contiguous runs of unhandled vaddrs (a gap > `gap` starts a new blob).
    Returns [(lo, hi_excl, unhandled_count)] — count is the # of unhandled words inside [lo, hi)."""
    if not vaddrs:
        return []
    vaddrs = sorted(set(vaddrs))
    out = []
    start = prev = vaddrs[0]; cnt = 1
    for v in vaddrs[1:]:
        if v - prev > gap:
            out.append((start, prev + 4, cnt))
            start = v; cnt = 1
        else:
            cnt += 1
        prev = v
    out.append((start, prev + 4, cnt))
    return out

def coalesce(ranges):
    """Merge overlapping/adjacent [lo, hi) ranges."""
    ranges = sorted(ranges)
    merged = []
    for lo, hi in ranges:
        if merged and lo <= merged[-1][1]:
            merged[-1] = (merged[-1][0], max(merged[-1][1], hi))
        else:
            merged.append((lo, hi))
    return merged

def read_ranges(path):
    out = []
    if os.path.exists(path):
        for l in open(path, encoding="utf-8"):
            l = l.strip()
            if l and not l.startswith("#"):
                p = l.split()
                if len(p) >= 2:
                    try:
                        out.append((int(p[0], 16), int(p[1], 16)))
                    except ValueError:
                        pass
    return out

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--failures", required=True, help="failures.json (the #1 build-side diagnostics sink)")
    ap.add_argument("--fe-dir", default=".")
    ap.add_argument("--out", default=None, help="ranges file (default <fe-dir>/_force_data_ranges.txt)")
    ap.add_argument("--gap", default="0x40", help="max byte gap bridged inside one blob (default 0x40)")
    ap.add_argument("--min-words", type=int, default=6, help="min words in a blob to carve (drops tiny clusters)")
    ap.add_argument("--min-invalid", type=int, default=2, help="min INVALID-opcode decodes a cluster must contain "
                    "to be carved. INVALID = not a valid instruction at all = unambiguously DATA; real code "
                    "never contains it (a compiler never emits an invalid opcode). A real function using a few "
                    "UNIMPLEMENTED-but-valid instrs (osInvalICache's `cache`, a `sync`, COP2) has ZERO INVALID "
                    "and is left as code. This is the gate that stops the veto carving real functions away.")
    ap.add_argument("--apply", action="store_true", help="merge into _force_data_ranges.txt (default: dry-run)")
    a = ap.parse_args()
    gap = int(a.gap, 0)

    d = json.load(open(a.failures, encoding="utf-8"))
    events = d["events"] if isinstance(d, dict) else d
    uo = [int(e["vaddr"], 16) for e in events if e.get("kind") == "unhandled-opcode"]
    invalid = sorted(int(e["vaddr"], 16) for e in events
                     if e.get("kind") == "unhandled-opcode" and e.get("detail") == "INVALID")
    # INVALID GATE: carve a cluster only if it contains >= min-invalid INVALID decodes. INVALID is the
    # unambiguous data signal (real code has none); a cluster of only `cache`/`sync`/COP2 (valid but
    # unimplemented, as in osInvalICache) has zero INVALID and stays code — those degrade to no-ops in the
    # recompiled function, which is correct for the PC port.
    blobs = []
    for lo, hi, cnt in cluster(uo, gap):
        if (hi - lo) // 4 < a.min_words:
            continue
        n_inv = bisect.bisect_left(invalid, hi) - bisect.bisect_left(invalid, lo)
        if n_inv >= a.min_invalid:
            blobs.append((lo, hi))
    if not blobs:
        print(f"[veto] no data blobs (>= {a.min_words} words, gap<=0x{gap:X}) in {len(uo)} unhandled-opcode "
              "decodes. Nothing to carve.")
        return 0

    carved = sum(hi - lo for lo, hi in blobs)
    print(f"[veto] {len(blobs)} embedded-data blob(s) from {len(uo)} unhandled-opcode decodes "
          f"(0x{carved:X} bytes to carve as bin):")
    for lo, hi in sorted(blobs, key=lambda b: -(b[1] - b[0]))[:20]:
        print(f"  force-data-range 0x{lo:08X}..0x{hi:08X}  ({(hi - lo) // 4} words, 0x{hi - lo:X} bytes)")
    if len(blobs) > 20:
        print(f"  ... and {len(blobs) - 20} more")

    out_path = a.out or os.path.join(a.fe_dir, "_force_data_ranges.txt")
    existing = read_ranges(out_path)
    merged = coalesce(existing + blobs)
    new_bytes = sum(hi - lo for lo, hi in merged) - sum(hi - lo for lo, hi in coalesce(existing))
    if a.apply:
        with open(out_path, "w", newline="\n", encoding="utf-8") as f:
            f.write("\n".join(f"0x{lo:08X} 0x{hi:08X}" for lo, hi in merged) + ("\n" if merged else ""))
        print(f"[veto] APPLIED: {len(merged)} range(s) total (+0x{new_bytes:X} new bytes) -> {out_path}")
    else:
        print(f"[veto] DRY-RUN: would write {len(merged)} range(s) (+0x{new_bytes:X} new bytes) to {out_path}  "
              "(re-run with --apply)")
    return 2

if __name__ == "__main__":
    sys.exit(main())
