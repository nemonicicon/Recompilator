#!/usr/bin/env python3
"""localize_overlay_dups.py — make an overlay's DUPLICATE libultra symbols LOCAL so they don't collide with
the resident's globals at link, while staying NAMED (so N64Recomp still HLE-binds them by name).

A self-contained overlay (e.g. Blast Corps' hd_code) bundles its OWN libultra; many of its names
(osSetEventMesg, __osDisableInt, ...) duplicate the resident boot's. BOTH must be HLE-bound — the GAME runs on
the overlay's libultra and its OS primitives must reach the engine HLE (else managers register queues into the
overlay's own raw tables and the engine never sees them) — but two GLOBAL symbols of the same name are a
linker "multiple definition" error. Making the overlay's copy a LOCAL symbol resolves it: the overlay's
intra-section calls bind to its own copy, the resident's to theirs, and gen_toml reads BOTH from the symtab
(it filters on STT_FUNC, NOT on binding) so N64Recomp HLE-binds each by name. This rewrites `glabel <dup>` ->
`<dup>:` (a local label) in the overlay asm for every name that also appears in the resident symbol_addrs.txt.

Usage: localize_overlay_dups.py <resident_symbol_addrs.txt> <overlay_asm.s> [<overlay_asm.s> ...]
"""
import re, sys


def main():
    names = set()
    for l in open(sys.argv[1], encoding="utf-8"):
        m = re.match(r"\s*([A-Za-z_]\w*)\s*=\s*0x", l)
        if m:
            names.add(m.group(1))
    total = 0
    for asm in sys.argv[2:]:
        lines = open(asm, encoding="utf-8").read().split("\n")
        n = 0
        for i, l in enumerate(lines):
            m = re.match(r"(\s*)glabel\s+([A-Za-z_]\w*)\s*$", l)
            if m and m.group(2) in names:
                lines[i] = f"{m.group(1)}{m.group(2)}:"  # local label — drop the glabel macro's .globl
                n += 1
        if n:
            open(asm, "w", encoding="utf-8", newline="\n").write("\n".join(lines))
        print(f"[localize_dups] {asm}: {n} duplicate symbol(s) made local")
        total += n
    return total


if __name__ == "__main__":
    main()
