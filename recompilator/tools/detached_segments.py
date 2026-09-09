#!/usr/bin/env python3
"""detached_segments.py - find code a blind split would place at the WRONG address.

    py -3 recompilator/tools/detached_segments.py --rom baserom.z64 --yaml game.yaml

THE DEFECT (2026-09-07; measured on Castlevania and Super Mario 64)
-------------------------------------------------------------------
A blind split assumes a cartridge's code is ONE run: ROM 0x1000 onwards, loaded
contiguously at one address. Many cartridges are not built that way. A second module is
loaded PAST the first module's .bss, so its true address is the contiguous guess plus a
gap of hundreds of kilobytes.

Nothing crashes and nothing is missing. The code is recompiled - just filed under
addresses that do not exist in the running game, so every call the cartridge makes to the
real address finds nothing. Castlevania renders black. Mario runs at 0 fps. Both had been
fixed by hand, per game, by a person finding this address and writing it into a recipe.

THE SIGNAL
----------
The calls are still in the instruction stream. A jal carries an absolute target, so a
blind disassembly is full of calls to addresses no segment covers. Scattered ones are data
misread as code; a detached module is a dense cluster of hundreds inside one span.

FINDING WHERE IT LIVES IN THE ROM
--------------------------------
Every one of those targets is a function's first instruction. If the module is at ROM
offset R, then for target T the word at R + (T - T0) is a prologue. Each (prologue in the
cartridge, target) pair votes for one R, and the true offset is voted for by most targets
at once, while wrong offsets collect a couple by chance. One unknown, one Hough transform.

MEASURED, against answers that had been established by hand:

    Castlevania   ROM 0x0A8420 -> 0x80125230   114 votes, runner-up 14
    Mario         ROM 0x0F5580 -> 0x80378800    91 votes, runner-up 11

Both exact. A candidate that does not beat its runner-up fourfold is refused rather than
guessed at - a wrong segment address is worse than no segment at all.
"""
import argparse
import struct
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

RDRAM_TOP = 0x80800000     # 8 MB with the Expansion Pak. Hardware, not a fact about any game.
JR_RA = 0x03E00008


def word(rom, off):
    return struct.unpack(">I", rom[off:off + 4])[0]


def is_prologue(w):
    """addiu $sp, $sp, -N - the first instruction of nearly every non-leaf MIPS function."""
    return (w >> 16) == 0x27BD and (w & 0x8000) != 0


def jal_target(w):
    if (w >> 26) != 3:
        return None
    return ((w & 0x03FFFFFF) << 2) | 0x80000000


def homeless_targets(rom, scan, covered):
    """Every jal target in scan that no declared span covers. Both are lists of (lo, hi, name)."""
    hits = {}
    inside = 0
    for lo, hi, _ in scan:
        for off in range(lo, min(hi, len(rom)) - 3, 4):
            t = jal_target(word(rom, off))
            if t is None or t >= RDRAM_TOP:
                continue
            if any(a <= t < b for a, b, _ in covered):
                inside += 1
            else:
                hits[t] = hits.get(t, 0) + 1
    return hits, inside


def cluster(hits, gap):
    keys = sorted(hits)
    if not keys:
        return []
    out, run = [], [keys[0]]
    for k in keys[1:]:
        if k - run[-1] <= gap:
            run.append(k)
        else:
            out.append(run)
            run = [k]
    out.append(run)
    out.sort(key=lambda c: -sum(hits[k] for k in c))
    return out


def localise(rom, targets, lo):
    """Vote for the ROM offset of targets[0]. Returns (best, votes, ranked)."""
    t0 = targets[0]
    deltas = [t - t0 for t in targets]
    span = deltas[-1]
    votes = {}
    for off in range(lo, len(rom) - 3, 4):
        if not is_prologue(word(rom, off)):
            continue
        for d in deltas:
            r = off - d
            if lo <= r and r + span < len(rom):
                votes[r] = votes.get(r, 0) + 1
    if not votes:
        return None, 0, []
    ranked = sorted(votes.items(), key=lambda kv: -kv[1])[:4]
    return ranked[0][0], ranked[0][1], ranked


def module_start(rom, r, homeless, floor):
    """Walk back to the module's first byte.

    A module's functions call each other, so their jals land in the homeless cluster. A
    function belonging to the PREVIOUS module calls into space the split already covers,
    and the walk stops there - in the data between the two modules, which is the seam.
    """
    start = r
    while start - 4 > floor:
        p = None
        for off in range(start - 4, max(floor, start - 0x4000), -4):
            if is_prologue(word(rom, off)):
                p = off
                break
        if p is None:
            break
        into_module = into_split = 0
        for off in range(p, start, 4):
            t = jal_target(word(rom, off))
            if t is None or t >= RDRAM_TOP:
                continue
            if t in homeless:
                into_module += 1
            else:
                into_split += 1
        if into_module == 0 and into_split > 0:
            break
        start = p
    return start


def module_end(rom, r_last):
    """Forward to the end of the last function: the last jr $ra before the code stops."""
    last = r_last
    off = r_last
    while off < len(rom) - 8:
        if word(rom, off) == JR_RA:
            last = off + 8
        elif off - last > 0x800:
            break
        off += 4
    return (last + 15) & ~15


def bss_seam(rom, code_start, code_vram, span=0x400):
    """THE SEAM, READ OUT OF THE BOOT CODE INSTEAD OF VOTED FOR.

    The resident image ends where BSS begins, and every libultra cart's entry point clears BSS
    before it does anything else - so the FIRST RDRAM address the entry stub materialises with a
    lui/addiu (or lui/ori) pair IS the end of the loaded image. Turn it back into a ROM offset
    with the resident delta and that is where the next segment starts.

    WHY THIS AND NOT ANOTHER VOTE. detect() already recovers a module's RELOCATION exactly - the
    docstring above says so - and only its START is wrong, and only when the module aliases the
    guessed span (Pilotwings loads at 0x802CA900 inside a guess of 0x80200050..0x80300050, so its
    calls are never homeless and the seam is missed by 219 KB). Two statistical seam tests were
    tried before this one and neither separated the modules, because the ROM is dense with
    prologue-shaped words. This is not statistical: it is one address the boot code names.

    MEASURED 2026-09-08 against every seam anyone has established by hand:
        Castlevania  entry 0x80000400  BSS 0x800A7820  ->  ROM 0x0A8420   (tree says 0x0A8420)
        Super Mario  entry 0x80246000  BSS 0x8033A580  ->  ROM 0x0F5580   (tree says 0x0F5580)
        Pilotwings   entry 0x80200050  BSS 0x80250E80  ->  ROM 0x051E30   (tree says 0x051E30)
    Three for three, including the two the vote already gets right - so it agrees where the vote
    works and corrects it where it does not.

    Returns the ROM offset, or None when the stub builds no plausible RDRAM address.
    """
    regs = {}
    for off in range(code_start, min(code_start + span, len(rom) - 4), 4):
        ins = word(rom, off)
        op, rs, rt, imm = ins >> 26, (ins >> 21) & 31, (ins >> 16) & 31, ins & 0xFFFF
        if op == 0x0F:                                   # lui rt, imm
            regs[rt] = imm << 16
        elif op in (0x09, 0x0D) and rs in regs:          # addiu / ori rt, rs, imm
            v = regs[rs] + (imm - 0x10000 if (op == 0x09 and imm & 0x8000) else imm)
            if 0x80000000 <= v < 0x80800000:
                seam = v - (code_vram - code_start)
                return seam if code_start < seam < len(rom) else None
            regs[rt] = v
    return None


def detect(rom, code_start, code_end, vram, gap=0x20000, min_targets=24, min_margin=4.0,
           log=None, rounds=1, trusted=None):
    """THE CAPABILITY. Given one assumed code region, return the modules it misplaces.

    Each result is {rom, rom_end, vram, targets, votes, runner_up}. The caller declares
    each as its own segment, and everything downstream then has the right addresses.

    THE ALIASING CASE, and why `rounds` defaults to 1 (measured 2026-09-07). The assumed code
    region is a guess: ROM 0x1000 for one megabyte. A module whose real addresses fall INSIDE
    that guessed span therefore looks resolved - its calls are never homeless and only the part
    poking out above the guess is seen. Pilotwings is exactly that: its overlay loads at
    0x802CA900 while the guess claims 0x80200050..0x80300050, so one pass recovers the
    relocation EXACTLY (ROM 0x87978 + 0x80278AD0, the same delta the hand-authored tree
    documents) but starts the segment 219 KB after the tree's ROM 0x51E30.

    Iterating - shrinking the main span to what is left after the modules found so far, which
    frees the aliased calls to be seen - moves that to 31 KB BEFORE 0x51E30. Closer, and the
    wrong side: a late boundary leaves module code where it already was, while an early one
    moves MAIN's code to addresses it does not have, which is a new break on a cart nobody has
    verified. Both a per-function call vote and a last-main-callee floor were tried as seam
    tests and neither separates the two modules (the ROM is dense with prologue-shaped words).
    So the default is one pass: exact on Castlevania and Mario, conservative on the aliasing
    case. Raising `rounds` enables the refinement for anyone measuring it against a known tree.
    """
    def say(m):
        if log:
            log(m)

    breaks = [[code_start, vram]]          # [rom_start, vram], sorted, tiling to code_end
    stats = {}                             # rom_start -> (targets, votes, runner_up)
    for _round in range(rounds):
        covered = []
        for i, (rs, rv) in enumerate(breaks):
            nxt = breaks[i + 1][0] if i + 1 < len(breaks) else code_end
            covered.append((rv, rv + (nxt - rs), i))
        hits, inside = homeless_targets(rom, [(code_start, code_end, "scan")], covered)
        if _round == 0:
            say("%d calls resolve inside the split, %d distinct targets have no home"
                % (inside, len(hits)))
        best = None
        for c in cluster(hits, gap):
            if len(c) < min_targets or (c[-1] - c[0]) < 0x1000:
                continue
            r, votes, ranked = localise(rom, c, code_start)
            if r is None:
                continue
            runner = ranked[1][1] if len(ranked) > 1 else 0
            if runner and votes < runner * min_margin:
                # THE MARGIN GUARDS A GUESS, AND A WINDOW CART HAS ALREADY ANSWERED. `trusted` is
                # true when the cart's own boot stub maps a TLB window over this load address; the
                # hardware has then named the answer and a prologue-density tie is not evidence
                # against it. MEASURED 2026-09-09: Turok 2 rev 1 finds the SAME module at the SAME
                # address as the 1.0 cart (ROM 0x1100 -> 0x80200500, 1851 call targets) and scored
                # 922 over 486 = 1.90, refused - while 1.0 scored 912 over 208 = 4.38 and passed.
                # The whole Acclaim window class was clearing min_margin on luck, and rev 1 built a
                # 460 KB module against 1.0's 9.06 MB because of it.
                if trusted and trusted(c[0]):
                    say("cluster 0x%08X: %d over %d is not decisive, but the boot stub maps this "
                        "address - corroborated, accepted" % (c[0], votes, runner))
                else:
                    say("cluster 0x%08X: best offset 0x%X scores %d against %d - not decisive, "
                        "refused" % (c[0], r, votes, runner))
                    continue
            best = (c, r, votes, runner)
            break
        if best is None:
            break
        c, r, votes, runner = best
        delta = c[0] - r
        st = module_start(rom, r, set(c), code_start)
        # THE RELOCATION IS RIGHT; TAKE THE SEAM FROM THE BOOT CODE. When the entry stub names a
        # BSS start that falls BELOW the start this scan found, the scan has landed inside the
        # module rather than at its head - the aliasing case - and everything between the seam and
        # `st` is module bytes currently being assembled at MAIN's addresses, which is exactly why
        # the re-splat is not byte-exact. Only ever moves the boundary DOWN, and only to an address
        # the cart itself names.
        seam = bss_seam(rom, code_start, vram)
        if seam is not None and code_start < seam < st:
            say("boot code puts BSS at ROM 0x%06X; module scan started at 0x%06X - taking the "
                "seam, %d bytes earlier" % (seam, st, st - seam))
            st = seam
        if st <= code_start:
            break
        # A module already known with this relocation has simply been found to start earlier:
        # move it down rather than declaring a second copy of the same module.
        same = [b for b in breaks[1:] if b[1] - b[0] == delta]
        if same:
            if st >= same[0][0]:
                break                       # this round learned nothing; settled
            stats.pop(same[0][0], None)
            same[0][0], same[0][1] = st, st + delta
        else:
            breaks.append([st, st + delta])
        breaks.sort()
        stats[st] = (len(c), votes, runner)

    found = []
    for i, (rs, rv) in enumerate(breaks):
        if i == 0:
            continue
        nxt = breaks[i + 1][0] if i + 1 < len(breaks) else None
        last_call = max([t for t in [rv] if True])
        en = module_end(rom, min(nxt, code_end) - 4 if nxt else max(rs + 0x100, code_end - 4))
        t, v, ru = stats.get(rs, (0, 0, 0))
        blind = vram + (rs - code_start)
        found.append({"rom": rs, "rom_end": max(en, rs + 0x100), "vram": rv,
                      "targets": t, "votes": v, "runner_up": ru})
        say("MODULE at ROM 0x%06X loads at 0x%08X, not 0x%08X: relocated by 0x%X, "
            "%d call targets, %d prologue votes over %d"
            % (rs, rv, blind, rv - blind, t, v, ru))
        _ = last_call
    return found


# --------------------------------------------------------------------------- CLI


def parse_yaml_segments(path):
    segs, cur = [], None
    for raw in open(path, encoding="utf-8"):
        s = raw.strip()
        if s.startswith("- name:"):
            cur = {"name": s.split(":", 1)[1].strip(), "type": None, "start": None, "vram": None}
            segs.append(cur)
        elif cur is not None and s.startswith("type:"):
            cur["type"] = s.split(":", 1)[1].strip()
        elif cur is not None and s.startswith("start:"):
            cur["start"] = int(s.split(":", 1)[1].strip(), 0)
        elif cur is not None and s.startswith("vram:"):
            cur["vram"] = int(s.split(":", 1)[1].strip(), 0)
        elif s.startswith("- [0x") and "," not in s:
            try:
                segs.append({"name": "end", "type": "end",
                             "start": int(s[3:].strip().lstrip("[").rstrip("]"), 0), "vram": None})
            except ValueError:
                pass
    return segs


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rom", required=True)
    ap.add_argument("--yaml", required=True)
    ap.add_argument("--gap", type=lambda x: int(x, 0), default=0x20000)
    ap.add_argument("--min-targets", type=int, default=24)
    a = ap.parse_args()
    rom = open(a.rom, "rb").read()
    segs = parse_yaml_segments(a.yaml)
    starts = sorted(s["start"] for s in segs if s["start"] is not None)
    code = [s for s in segs if s.get("type") == "code" and s["vram"] is not None]
    if not code:
        print("no code segment in %s" % a.yaml)
        return 1
    s0 = code[0]
    end = min([e for e in starts if e > s0["start"]], default=len(rom))
    print("%s: code ROM 0x%X..0x%X at vram 0x%08X" % (a.rom, s0["start"], end, s0["vram"]))
    mods = detect(rom, s0["start"], end, s0["vram"], gap=a.gap, min_targets=a.min_targets,
                  log=lambda m: print("   " + m))
    print("%d detached module(s)" % len(mods))
    for m in mods:
        print("   SEGMENT start 0x%06X  end 0x%06X  vram 0x%08X  (%d KB, %d targets)"
              % (m["rom"], m["rom_end"], m["vram"], (m["rom_end"] - m["rom"]) // 1024,
                 m["targets"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
