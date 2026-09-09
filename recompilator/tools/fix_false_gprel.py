#!/usr/bin/env python3
"""fix_false_gprel.py — convert splat's FALSE %gp_rel(...) to literal $gp offsets (byte-exact).

When a code segment uses $gp ($28) as a GENERAL register (loading addresses into it, not as the IDO global
pointer), splat's register tracking still symbolizes `offset($gp)` accesses as %gp_rel(D_<tracked_gp+off>),
which the assembler turns into R_MIPS_GPREL16 relocs the linker resolves against a single _gp — and they
overflow ("relocation truncated to fit"), because the "tracked gp" is not one small-data base (the segment
loads many different values into $gp). The original instruction's offset is a plain 16-bit literal, sitting
right in splat's byte comment (e.g. `A3830000` => offset 0x0000). This rewrites each `%gp_rel(SYM)` operand
to that literal, so the instruction reassembles byte-exact with NO GPREL16 reloc. Apply to segments whose $gp
is not the global pointer (self-contained overlays / IDO game code where splat mis-tracks $gp).

Only the %gp_rel(...) OPERAND form is rewritten; the bare "%gp_rel" inside splat's warning COMMENTS (no parens)
is left alone. Usage: fix_false_gprel.py <file.s> [<file.s> ...]
"""
import re, sys

BYTES = re.compile(r"/\*\s*[0-9A-Fa-f]+\s+[0-9A-Fa-f]+\s+([0-9A-Fa-f]{8})\s*\*/")
GPREL = re.compile(r"%gp_rel\([^)]*\)")
LO_D = re.compile(r"%lo\(D_([0-9A-Fa-f]+)\)")  # auto data %lo — may be mis-tracked off the wrong $gp value


def main():
    total = 0
    for path in sys.argv[1:]:
        lines = open(path, encoding="utf-8", errors="replace").read().split("\n")
        n = 0
        for i, l in enumerate(lines):
            if "%gp_rel(" not in l and "%lo(D_" not in l:
                continue
            mb = BYTES.search(l)
            if not mb:
                continue
            off = int(mb.group(1), 16) & 0xFFFF
            new = l
            # %gp_rel is ALWAYS gp-relative — wrong whenever $gp isn't the global pointer; restore the literal.
            if "%gp_rel(" in new:
                new = GPREL.sub(f"0x{off:X}", new)
            # %lo(D_addr) is wrong ONLY when the symbol's low-16 != the instruction's actual offset — that
            # mismatch is splat pairing the %lo off a mis-tracked $gp value. Leave correct %lo pairs alone.
            new = LO_D.sub(lambda m: f"0x{off:X}" if (int(m.group(1), 16) & 0xFFFF) != off else m.group(0), new)
            if new != l:
                lines[i] = new
                n += 1
        if n:
            open(path, "w", encoding="utf-8", newline="\n").write("\n".join(lines))
        print(f"[fix_false_gprel] {path}: {n} %gp_rel -> literal offset")
        total += n
    return total


if __name__ == "__main__":
    main()
    sys.exit(0)
