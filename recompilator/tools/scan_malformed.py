#!/usr/bin/env python3
"""
scan_malformed.py — find ALL malformed recompiled functions in one pass (no build needed).

The dominant phantom symptom is `goto LABEL;` to a LABEL that is never defined in the same function
(N64Recomp emitted a branch/jump for data bytes it decoded as code). The build surfaces these one or two
at a time (MSVC aborts a file early), so the build-driven refine loop converges ~1 func/round. This scans
the generated C directly and returns EVERY function whose body contains a goto to an absent label —
collapsing many refine rounds into one.

Scope: only `func_XXXXXXXX` (real toml funcs that can be STUBBED). `static_*` funcs (N64Recomp CreateStatic)
are reported separately — they can't be stubbed by toml name (need manual_funcs).

Usage:
  python scan_malformed.py <RecompiledFuncs dir>            # prints func_ names (one per line)
  python scan_malformed.py <dir> --report                   # human summary incl static_ offenders
"""
import argparse, re, sys
from pathlib import Path

DECL  = re.compile(r"RECOMP_FUNC\s+void\s+(func_[0-9A-Fa-f]+|static_\w+)\s*\(")
GOTO  = re.compile(r"\bgoto\s+([A-Za-z_]\w*)\s*;")
LABEL = re.compile(r"^\s*([A-Za-z_]\w*)\s*:")        # a label definition `name:` at line start

def scan_file(text):
    """Yield (func_name, set_of_undefined_goto_targets) for each malformed function in one C file."""
    lines = text.splitlines()
    # find function start lines
    starts = [(i, m.group(1)) for i, l in enumerate(lines) for m in [DECL.search(l)] if m]
    for k, (si, name) in enumerate(starts):
        ei = starts[k+1][0] if k+1 < len(starts) else len(lines)
        body = lines[si:ei]
        gotos, labels = set(), set()
        for bl in body:
            for g in GOTO.findall(bl): gotos.add(g)
            m = LABEL.match(bl)
            if m and "goto" not in bl: labels.add(m.group(1))
        missing = gotos - labels
        if missing:
            yield name, missing

def scan_dir(d):
    funcs, statics = {}, {}
    for cf in sorted(Path(d).glob("funcs_*.c")):
        txt = cf.read_text(encoding="utf-8", errors="replace")
        for name, missing in scan_file(txt):
            tgt = funcs if name.startswith("func_") else statics
            tgt.setdefault(name, set()).update(missing)
    return funcs, statics

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("dir")
    ap.add_argument("--report", action="store_true")
    a = ap.parse_args()
    funcs, statics = scan_dir(a.dir)
    if a.report:
        print(f"[scan] {len(funcs)} malformed func_ (stub-able), {len(statics)} malformed static_ (need manual_funcs)")
        for n, miss in sorted(funcs.items())[:20]:
            print(f"  {n} -> missing {sorted(miss)[:3]}")
        if statics:
            print("  static_ offenders:", ", ".join(sorted(statics)[:8]))
    else:
        for n in sorted(funcs): print(n)

if __name__ == "__main__":
    main()
