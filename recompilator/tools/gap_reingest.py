#!/usr/bin/env python3
"""gap_reingest.py — recompilator roadmap tool #3 (the static-reingest half).

The JOURNAL half is the runtime gap_report.json the diagnostics sink writes on a RECOMP_DIAG=1 run
(events[] gfgap/cartbus/kseg0 dispatch misses + gap_cache[] live-gap JITs). This tool closes the
runtime->static feedback loop: it merges the runtime-DISCOVERED code gaps — functions the STATIC
recompile missed but the runtime found INSIDE a known section (gfgap-section-miss) or JIT'd as real code
(gap_cache is_code) — into the game's symbol_addrs.txt as FUNC symbols. On the next
splat -> ELF -> gen_toml -> recompile, those addresses are emitted as native recompiled functions, so the
runtime gap-net no longer has to interpret them. The static image strictly improves run over run — the
mechanism the engine's own hint asks for ("recompile it in the game front-end for speed", overlays.cpp).

SAFE BY DESIGN (honors the project's symbol_addrs discipline): backs up symbol_addrs.txt before writing,
and ONLY APPENDS addresses not already present — it never moves, renames, or clobbers a curated symbol.
Dry-run by default; --apply writes.

Caveat: a gfgap-section-miss vaddr is guaranteed inside a static section, so its bytes exist statically and
the symbol will materialize. A gap_cache vaddr MAY be a raw-DMA'd overlay (bytes not in the resident ELF);
splat simply ignores a symbol that lands in no segment, so adding it is harmless but may not materialize —
the per-symbol comment records its source so that's visible.

Usage:
  python gap_reingest.py --gap-report <appdata>/<game>/saves/gap_report.json \
     --syms <fe>/symbol_addrs.txt [--apply]
"""
import argparse, datetime, json, os, re, sys, shutil

def existing_addrs(path):
    """Set of addresses already mapped in symbol_addrs.txt (so we never dupe/clobber one)."""
    addrs = set()
    if os.path.exists(path):
        for l in open(path, encoding="utf-8"):
            m = re.search(r'=\s*(0x[0-9A-Fa-f]+)\s*;', l)
            if m:
                addrs.add(int(m.group(1), 16))
    return addrs

def collect_candidates(report):
    """Return {vaddr: source_note} of confirmed runtime code gaps worth reingesting as FUNC symbols."""
    cands = {}
    for e in report.get("events", []):
        if e.get("kind") == "gfgap-section-miss":
            v = int(e["vaddr"], 16)
            cands.setdefault(v, f"gfgap section-miss, hit {e.get('hit_count', 1)}")
    for g in report.get("gap_cache", []):
        if g.get("is_code"):
            v = int(g["vaddr"], 16)
            cands.setdefault(v, f"live-gap JIT, code 0x{g.get('code_size', 0):X}")
    return cands

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--gap-report", required=True)
    ap.add_argument("--syms", required=True)
    ap.add_argument("--apply", action="store_true", help="append to symbol_addrs.txt (default: dry-run report)")
    ap.add_argument("--force-crashed", action="store_true",
                    help="consume the report even though a gap_report.crashed marker says the run crashed")
    a = ap.parse_args()

    # Provenance guard (2026-07-18): a CRASHED run's gap_cache can hold garbage decodes that poison
    # symbol_addrs (the JIT-on-era candc/sc64 quarantine). The runtime's exception filter drops a
    # gap_report.crashed marker beside the report; a healthy run clears it on its first flush. Refuse
    # a report whose marker is at least as new as the report itself. Always log the report's mtime so
    # stale-report consumption is visible in the transcript.
    rep_mtime = os.path.getmtime(a.gap_report)
    print(f"[reingest] report mtime: {datetime.datetime.fromtimestamp(rep_mtime):%Y-%m-%d %H:%M:%S}  ({a.gap_report})")
    marker = os.path.join(os.path.dirname(a.gap_report), "gap_report.crashed")
    if os.path.exists(marker) and os.path.getmtime(marker) >= rep_mtime - 2.0:
        try:
            detail = open(marker, encoding="utf-8").read().strip()
        except OSError:
            detail = "(unreadable)"
        if not a.force_crashed:
            print(f"[reingest] REFUSED: the run that wrote this report CRASHED — {detail}")
            print("[reingest] a crashed run's gap_cache is untrusted (garbage decodes poison symbol_addrs).")
            print("[reingest] re-run the game to produce a healthy report, or pass --force-crashed to override.")
            return 2
        print(f"[reingest] WARNING: consuming a CRASHED run's report (--force-crashed) — {detail}")

    report = json.load(open(a.gap_report, encoding="utf-8"))
    cands = collect_candidates(report)
    if not cands:
        print("[reingest] no runtime code gaps in the report - nothing to reingest "
              "(the static image already covered this run).")
        return 0

    existing = existing_addrs(a.syms)
    new = {v: note for v, note in cands.items() if v not in existing}
    print(f"[reingest] {len(cands)} candidate gap func(s); {len(new)} new, "
          f"{len(cands) - len(new)} already named in symbol_addrs.txt.")
    for v in sorted(new):
        print(f"  + func_{v:08X} = 0x{v:08X}  ({new[v]})")
    if not new:
        print("[reingest] all candidates already named; nothing to add.")
        return 0

    if a.apply:
        bak = a.syms + ".bak_reingest"
        if os.path.exists(a.syms) and not os.path.exists(bak):
            shutil.copyfile(a.syms, bak)
        with open(a.syms, "a", encoding="utf-8", newline="\n") as f:
            f.write(f"// --- reingested from runtime gap_report: {len(new)} func(s) the static pass missed ---\n")
            for v in sorted(new):
                f.write(f"func_{v:08X} = 0x{v:08X}; // type:func\n")
        print(f"[reingest] APPLIED: appended {len(new)} func symbol(s) to {a.syms}"
              + (f" (backup: {os.path.basename(bak)})" if os.path.exists(bak) else ""))
        print("[reingest] Re-run the pipeline (splat -> gen_toml -> N64Recomp) to emit them natively.")
    else:
        print(f"[reingest] DRY-RUN: would append {len(new)} func symbol(s) to {a.syms}  (re-run with --apply).")
    return 0

if __name__ == "__main__":
    sys.exit(main())
