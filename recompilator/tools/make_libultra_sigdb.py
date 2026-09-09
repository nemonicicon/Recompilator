#!/usr/bin/env python3
"""make_libultra_sigdb.py - distil the reference builds into the shape database a release carries.

    py -3 recompilator/tools/make_libultra_sigdb.py --out recompilator/data/libultra_sigdb.json

WHY THIS EXISTS
---------------
match_libultra.py names a cartridge's operating-system layer by comparing it against named
reference builds of the N64 library. Those builds are not something a release can carry, and
without anything to compare against the matcher names nothing: the recompiler then emits the
scheduler and the interrupt path raw instead of binding them to the engine, and the cartridge
spins. The matcher does not need the references at run time; it needs a SHAPE per library
function, and that is what this writes.

WHAT IT CONTAINS, PRECISELY (tools/libultra_shapes.py)
------------------------------------------------------
For every reference and every name the engine's symbol lists ask for (plus the library functions
those bodies call, which the matcher ports by call position): the function's address and size in
that build, one-way digests of its masked instruction prefixes (one per length), the positions and
names of its calls, and its immediates XOR-ed with a key derived from the masked prefix in front of
each - decodable only by code that already has a byte-for-byte matching body. Nothing in the file
is an instruction, and none of it can be turned back into one. It also carries the two name sets
the matcher looks for, so a release needs no engine source to run it.

The reference list is engine/references/sigdb_references.json on the machine that has them (lab
only; that folder is never exported). --refs points at another manifest.
"""
import argparse
import json
import os
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import match_libultra as M   # the one source of truth for parsing, sizes and the name sets
import libultra_shapes as LS


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", required=True)
    ap.add_argument("--refs", default=None, help="reference manifest (default: the lab's)")
    ap.add_argument("--symlists", default=None, help="N64Recomp's symbol_lists.cpp (default: the engine's)")
    a = ap.parse_args()

    manifest = a.refs or M.REFERENCE_MANIFEST
    if not os.path.exists(manifest):
        print("no reference manifest at %s" % manifest)
        return 1
    refs = M.load_reference_manifest(manifest)

    symlists = a.symlists or M.SYMLISTS
    reimp, ignored = M.parse_name_sets(symlists)
    targets = [t for t in sorted(reimp | ignored) if t not in LS.RMON_NOISE]
    targets_set = set(targets)
    print("%d target names from %s" % (len(targets), symlists))

    db = {"format": 3,
          "reimplemented": sorted(reimp),
          "ignored": sorted(ignored),
          "made_by": "recompilator/tools/make_libultra_sigdb.py",
          "what": "Shapes of N64 library functions for match_libultra.py --sigdb: per function its "
                  "address and size in a reference build, one-way digests of its masked instruction "
                  "prefixes, the positions and names of its calls, and its immediates under a key only "
                  "a matching body can derive. No instruction words, no ROM data, nothing runnable "
                  "(tools/libultra_shapes.py).",
          "references": []}
    total_shapes = 0
    for label, path, toml in refs:
        if not os.path.exists(path):
            print("  %-6s MISSING: %s" % (label, path))
            continue
        shapes = M.shapes_from_reference(path, toml, targets)
        funcs = {n: LS.shape_to_json(sh) for n, sh in shapes.items()}
        db["references"].append({"label": label, "names": len(funcs), "funcs": funcs})
        extra = sorted(n for n in shapes if n not in targets_set)
        digests = sum(len(sh.f) for sh in shapes.values())
        print("  %-6s %4d shapes (%d targets + %d callees), %6d prefix digests"
              % (label, len(funcs), len(funcs) - len(extra), len(extra), digests))
        if extra:
            print("         callees: %s" % ", ".join(extra))
        total_shapes += len(funcs)

    os.makedirs(os.path.dirname(os.path.abspath(a.out)) or ".", exist_ok=True)
    with open(a.out, "w", encoding="utf-8") as f:
        json.dump(db, f, separators=(",", ":"), sort_keys=True)
    size = os.path.getsize(a.out)
    print("wrote %s: %d references, %d shapes, %.1f KB"
          % (a.out, len(db["references"]), total_shapes, size / 1024.0))
    if not db["references"]:
        print("NO REFERENCES FOUND - this database would name nothing")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
