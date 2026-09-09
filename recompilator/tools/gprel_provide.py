#!/usr/bin/env python3
"""gprel_provide.py — PROVIDE offset-named gp-relative symbols at _gp + offset.

GENERAL front-end fix for gp-relative carts (loderunner3d/sprally class). splat emits
gp-relative ops as `op $r, $gp, %gp_rel(D_<offset>)` where the symbol is named by its 16-bit
gp-OFFSET (e.g. `addiu $v0,$gp,%gp_rel(D_CF0)` from word 0x27820CF0 -> offset 0x0CF0 -> D_CF0),
NOT its full address. The address-named auto-PROVIDE floor would place D_CF0 at the LITERAL
0xCF0, so the GPREL16 reloc computes `0xCF0 - _gp` and overflows the +/-32KB window.

The correct address is `_gp + 0xCF0`, so the reloc re-encodes to the original 0x0CF0 offset
field = BYTE-EXACT, and the link succeeds. This distinguishes the class from the D_40 %hi/%lo
constant-load class by RELOCATION TYPE: only %gp_rel(...) references are rewritten, so %hi/%lo
absolute loads (D_40 = 0x40 literal) are untouched.

Reads _gp from gp_override.txt (only gp-relative carts have it). No-op otherwise. Run after
splat + the .L->L_ rename, before the link. Emits build/gprel_syms.ld (included in BOTH passes
BEFORE undefined_syms_auto.ld so these PROVIDEs win over the literal floor).
"""
import re, sys, glob, os

GPREL = re.compile(r"%gp_rel\(((?:D_|func_|jtbl_|jpt_|L_)([0-9A-Fa-f]+))\)")

def main():
    out = sys.argv[1] if len(sys.argv) > 1 else "build/gprel_syms.ld"
    gp = 0
    if os.path.exists("gp_override.txt"):
        try: gp = int(open("gp_override.txt").read().strip(), 0)
        except Exception: gp = 0
    syms = {}
    if gp:
        for s in glob.glob("asm/**/*.s", recursive=True):
            txt = open(s, encoding="utf-8", errors="replace").read()
            for m in GPREL.finditer(txt):
                name, hexa = m.group(1), m.group(2)
                v = int(hexa, 16)
                if v < 0x80000000:           # offset-named -> real address is _gp + offset
                    syms[name] = (gp + v) & 0xFFFFFFFF
    # SECOND PASS (decouple data from code): a DATA word whose value equals a gp-offset gets splat-
    # symbolized as `.word D_<off>`. Our PROVIDE moves D_<off> to _gp+off, so `.word D_<off>` would now
    # emit the full address (DIVERGENT). The same symbol can't be both _gp+off (for %gp_rel code) and the
    # literal off (for the .word data). Rewrite those data words back to the literal ROM word from the
    # byte-exact comment, so the data stays byte-exact while %gp_rel uses the PROVIDE'd address.
    if syms:
        wre = re.compile(r"^(\s*/\* [0-9A-Fa-f]+ [0-9A-Fa-f]+ ([0-9A-Fa-f]{8}) \*/)\s*\.word\s+([A-Za-z0-9_]+)\b")
        for s in glob.glob("asm/**/*.s", recursive=True):
            lines = open(s, encoding="utf-8", errors="replace").read().split("\n")
            chg = 0
            for i, l in enumerate(lines):
                m = wre.match(l)
                if m and m.group(3) in syms:
                    lines[i] = "%s  .word 0x%s  # gprel-data-fix: was .word %s" % (m.group(1), m.group(2), m.group(3))
                    chg += 1
            if chg:
                open(s, "w", encoding="utf-8", newline="\n").write("\n".join(lines))
                print(f"gprel-data-fix: {chg} `.word <offset-sym>` -> literal in {s}")
    os.makedirs(os.path.dirname(out) or ".", exist_ok=True)
    with open(out, "w", newline="\n") as f:
        for name, addr in sorted(syms.items()):
            f.write(f"PROVIDE({name} = 0x{addr:08X});\n")
    print(f"gprel-provide: {len(syms)} offset-named gp-relative symbols -> {out}")

if __name__ == "__main__":
    main()
