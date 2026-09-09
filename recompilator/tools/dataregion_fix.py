#!/usr/bin/env python3
"""dataregion_fix.py — GENERAL front-end fix for the splat-mis-typed-data-as-instruction class.

splat (disassemble_all: true) decodes every resident word as MIPS. Most data words re-encode
byte-identically through gas (absolute-field ops: lw/sb/slti/addi/andi/ori/lh/...), so they
survive the byte-exact gate. But a few do NOT, and they silently mis-assemble (no gas error, so
the build's D-gas error-loop never catches them):
  * macro-expanding div family — `d?div[u]? rd,rs,rt` (3-operand) -> gas emits a div-by-zero
    guard (`bne; .. ; break 0x7; mflo`) = up to 4 words, shifting every following byte.
    (the `00 07 00 0D` = `break 0x7` signature seen in pokemonsnap/batman/tetrisphere.)
  * label/symbol-relative ops in data — `b/beq/bne/beqz/j/jal` -> gas recomputes the
    offset/target from the splat-invented label, not the data's original encoded field.

Fix: identify spans splat disassembled that are actually DATA (a sliding window dominated by
`.word`/`invalid instruction`), and in those spans rewrite ONLY the divergence-prone decoded
instructions (the div family + symbol-relative b/beq/bne/beqz/j/jal — see DIVERGE below) back to
`.word 0x<romword>` using the byte-exact hex splat already prints in the `/* rom vram WORD */`
comment. Absolute-field ops (lw/sb/addi/...) re-encode byte-exact, so they are left alone — this
keeps the footprint minimal AND guarantees a real function is never stripped over an absolute-field
op. Real code is never touched (real functions are instruction-dominated, classified CODE), so the
recompiler still sees true functions; only mis-typed data is neutralized.

This runs after splat + the .L->L_ rename, before assembly. It mutates asm/*.s in place.
"""
import re, sys, glob, os

# sliding-window data detector
WIN = 16
THRESH = 0.62
cre = re.compile(r"^(\s*/\* [0-9A-Fa-f]+ [0-9A-Fa-f]{8} ([0-9A-Fa-f]{8}) \*/)\s+(\S.*)$")
wordcomment = re.compile(r"^\s*/\* [0-9A-Fa-f]+ [0-9A-Fa-f]{8} [0-9A-Fa-f]{8} \*/(.*)$")

# Only these decoded mnemonics actually re-encode to DIFFERENT bytes than the ROM word and so
# break byte-exactness (measured empirically across pokemonsnap/batman/tetrisphere):
#   * div family in the 3-operand form -> gas macro-expands (div-by-zero guard, the `break 0x7`
#     = 00 07 00 0D signature), inflating 1 word to up to 4 and shifting everything after.
#   * symbol/label-relative control flow -> gas recomputes the offset/target from the
#     splat-invented label instead of the data's original encoded field.
# Every absolute-field op (lw/sb/slti/addi/andi/ori/lh/cache/pref/lwc2/...) re-encodes byte-exact,
# so we deliberately leave those alone — touching only the truly-divergent lines keeps the
# footprint minimal and guarantees we never strip a real function over an absolute-field op.
DIVERGE = re.compile(r"^(d?divu?|b|bal|beq|beql|bne|bnel|beqz|bnez|blez|blezl|bgtz|bgtzl|"
                     r"bltz|bltzl|bgez|bgezl|bltzal|bgezal|bc1[tf]l?|bc0[tf]l?|j|jal)$")

def _is_diverging(rest):
    toks = rest.split()
    if not toks:
        return False
    mnem = toks[0].split(".")[0]
    return bool(DIVERGE.match(mnem))

# GENERAL (wcwrevenge): a decoded branch/jump whose target vram is IMPOSSIBLE (outside the 8MB RDRAM
# window: >= 0x80800000 or < 0x80000400) is data misread as code. Such garbage `j`/`jal`/`b...` lines
# otherwise count as plausible "code" and dilute the sliding-window data fraction below THRESH, hiding a
# real divergence (e.g. a 3-op div macro-expansion) sitting in the same data span. Count them as data.
_IMPOSSIBLE_TGT = re.compile(r"(?:func_|L_|jtbl_|jpt_|D_)([0-9A-Fa-f]{8})\b")
def _impossible_target(rest):
    toks = rest.split()
    if not toks or not DIVERGE.match(toks[0].split(".")[0]):
        return False
    for m in _IMPOSSIBLE_TGT.finditer(rest):
        t = int(m.group(1), 16)
        if t >= 0x80800000 or t < 0x80000400:
            return True
    return False

def process(path):
    lines = open(path, encoding="utf-8", errors="replace").read().split("\n")
    # classify each commented line as word-ish (data evidence) or not
    rec_idx = []   # indices into `lines` that carry a /* rom vram word */ comment
    is_wordish = []
    for i, l in enumerate(lines):
        m = wordcomment.match(l)
        if m:
            rest = m.group(1).strip()
            rec_idx.append(i)
            is_wordish.append(rest.startswith(".word") or "invalid instruction" in rest or _impossible_target(rest))
    n = len(rec_idx)
    rewrites = 0
    for j in range(n):
        i = rec_idx[j]
        m = cre.match(lines[i])
        if not m:
            continue  # this commented line is a .word (no instruction) -> skip
        rest = m.group(3)
        if rest.strip().startswith(".word"):
            continue
        if not _is_diverging(rest):
            continue  # absolute-field op -> re-encodes byte-exact, leave it (could be real code)
        if _impossible_target(rest):
            # an unconditional j/jal/b... to a target outside 8MB RDRAM is DEFINITELY data misread as code
            # (a real branch can't reach it; a jal would R_MIPS_26-truncate at link) -> rewrite it
            # window-INDEPENDENTLY. Byte-exact (the ROM word) and never strips real code (no real branch
            # targets an impossible address). Cures the sprally layer-2 link failure. (window check below
            # still gates the div-macro-expansion / ordinary-target-branch class.)
            lines[i] = "%s  .word 0x%s  # dataregion-fix(impossible-target): %s" % (m.group(1), m.group(2), rest.strip())
            rewrites += 1
            continue
        a = max(0, j - WIN)
        b = min(n, j + WIN + 1)
        wc = sum(1 for k in range(a, b) if is_wordish[k])
        if wc / (b - a) >= THRESH:
            lines[i] = "%s  .word 0x%s  # dataregion-fix: %s" % (m.group(1), m.group(2), rest.strip())
            rewrites += 1
    if rewrites:
        open(path, "w", encoding="utf-8", newline="\n").write("\n".join(lines))
    return rewrites

def main():
    paths = sys.argv[1:] if len(sys.argv) > 1 else glob.glob("asm/**/*.s", recursive=True)
    total = 0
    for p in paths:
        r = process(p)
        if r:
            print("dataregion-fix: %d line(s) -> .word in %s" % (r, p))
            total += r
    print("dataregion-fix: %d total rewrites" % total)

if __name__ == "__main__":
    main()
