#!/usr/bin/env python
"""
recomp_coverage.py - HOW MUCH OF A GAME DID WE ACTUALLY RECOMPILE?

WHY THIS EXISTS (2026-08-29, after KI Gold):
  "we need to be MAKING SURE TO CHECK THAT IN THE FUTURE INSTEAD OF CONSISTENTLY ONLY
   FINDING OUT ABOUT IT AFTER 4 HOURS ON EVERY GAME"
Coverage is a STATIC property. It costs seconds. On KI Gold it was found only after a
morning of chasing display-list corruption that was plausibly downstream of it.
RUN THIS FIRST, BEFORE ANY DEBUGGING, ON EVERY GAME.

WHAT IT MEASURES (all from the recompiler's OWN artifacts, no ground truth needed):
  declared  - functions declared in <game>/asm/*.s, BOTH `func_XXXXXXXX` AND named
              (osInitialize etc). ** Counting only func_ names undercounts badly --
              that mistake was made three times in one session. **
  bytes     - sum of declared function sizes vs the span they lie in => % covered.
              The UNCOVERED bytes are code the recompiler never saw; at runtime it
              falls into the interpreter live-gap path (spin-watch `gap{interp,...}`).
  emitted   - function bodies actually written to <game>pc/RecompiledFuncs/*.c
  failures  - <game>pc/RecompiledFuncs/failures.json events by kind
              (`branch-out-of-function` = the overlay_boundary_rules class)

READ THE VERDICT, NOT THE COUNT: a game can declare many functions and still leave a
250KB hole. Byte coverage is the number that matters.
"""
import sys, os, re, json, glob, collections, math

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))   # <root>/recompilator/tools -> <root>

def parse_asm(game_dir):
    """(vaddr, size, name) for EVERY declared function in asm/*.s.

    Keys off the `nonmatching NAME, 0xSIZE` lines, which are the COMPLETE list, and
    takes the address from the next `/* ROMOFF VADDR WORD */` comment. Do NOT key off
    `glabel` -- only some functions use it (121 of 178 in kigold), and do NOT filter on
    a `func_` name prefix -- named functions (osInitialize, ...) are declared too.
    Both of those mistakes were made on 2026-08-29 and each produced a wrong hole size.
    """
    funcs = []
    pend = []   # [sizeless] size-less functions, resolved after the scan; must exist even when the asm glob is empty
    for path in glob.glob(os.path.join(game_dir, "asm", "*.s")):
        try:
            txt = open(path, encoding="utf-8", errors="ignore").read()
        except OSError:
            continue
        # [sizeless 2026-09-03] spimdisasm 1.40 (the _ram trees) writes `nonmatching NAME` with no size:
        # size = distance to the next function (last one: its word count). The old regex required the
        # `, 0xSIZE` and silently parsed 0 functions from a RAM tree.
        for m in re.finditer(r'nonmatching\s+(\S+?)(?:,\s*(0x[0-9A-Fa-f]+))?\s*\n(.*?)'
                             r'(?=nonmatching\s|\Z)', txt, re.S):
            name, body = m.group(1), m.group(3)
            size = int(m.group(2), 16) if m.group(2) else None
            vm = re.search(r'/\*\s*[0-9A-Fa-f]+\s+([0-9A-Fa-f]{8})\s', body)
            if vm and size is None:
                pend.append((int(vm.group(1), 16), name, len(re.findall(r'^\s*/\*\s*[0-9A-Fa-f]+\s+[0-9A-Fa-f]{8}\s', body, re.M)) * 4))
                continue
            if vm and not name.startswith("D_"):
                # D_XXXXXXXX are DATA symbols, not functions. kigold's asm has 178
                # `nonmatching` lines = 119 functions + 59 data. Counting the data as
                # functions inflates the count; counting the data REGIONS as "missing
                # code" inflates the hole. Both mistakes were made on 2026-08-29.
                funcs.append((int(vm.group(1), 16), size, name))
    for i, (va, name, words) in enumerate(pend):
        nxt = pend[i + 1][0] if i + 1 < len(pend) else va + words
        if not name.startswith("D_"):
            funcs.append((va, max(4, nxt - va), name))
    funcs.sort()
    return funcs

BODY_RE = re.compile(r'^\s*(?:RECOMP_FUNC\s+)?void\s+\w+\(uint8_t\s*\*\s*rdram', re.M)

def parse_overlays(game_dir):
    """(vaddr, size, name) for overlay functions.

    Overlay .s files are `.incbin` BLOBS, shaped differently from asm/*.s:
        .global func_801CBCCC
        func_801CBCCC:
        .incbin "blob.bin", 0x201AC, 0x204
    Parsing ONLY asm/ makes every overlay PC look un-recompiled -- a false positive
    that makes this checker cry wolf (hit 2026-08-29 on 0x801AD914, which IS declared).
    Line-based on purpose: a multiline regex here got its escapes mangled once already.
    Addresses come from the func_XXXXXXXX name; overlay functions with a real name are
    simply not listed -- they are never reported as missing.
    """
    out = []
    for path in glob.glob(os.path.join(game_dir, "overlay_*", "*.s")):
        try:
            lines = open(path, encoding="utf-8", errors="ignore").read().splitlines()
        except OSError:
            continue
        pending = None
        for ln in lines:
            lab = re.match(r'^(\w+):\s*$', ln)
            if lab:
                pending = lab.group(1)
                continue
            if pending and '.incbin' in ln:
                m = re.search(r'0x[0-9A-Fa-f]+\s*,\s*(0x[0-9A-Fa-f]+)\s*$', ln)
                am = re.match(r'func_([0-9A-Fa-f]{8})$', pending)
                if m and am:
                    out.append((int(am.group(1), 16), int(m.group(1), 16), pending))
                pending = None
            elif ln.strip() and not ln.startswith(('.', '#', '/')):
                pending = None
    out.sort()
    return out

def emitted_bodies(pc_dir):
    """(main, overlay) emitted function-body counts.

    ONLY under RecompiledFuncs -- never the build dirs, which contain generated copies
    and would double-count. Main and overlay are reported SEPARATELY: `declared` below
    is main-segment asm only, so adding overlay bodies to it compares different scopes.
    """
    rf = os.path.join(pc_dir, "RecompiledFuncs")
    main = ovl = 0
    for path in glob.glob(os.path.join(rf, "**", "*.c"), recursive=True):
        try:
            n = len(BODY_RE.findall(open(path, encoding="utf-8",
                                         errors="ignore").read()))
        except OSError:
            continue
        if os.path.dirname(path).rstrip(r"\/") == rf.rstrip(r"\/"):
            main += n
        else:
            ovl += n
    return main, ovl

def failures(pc_dir):
    p = os.path.join(pc_dir, "RecompiledFuncs", "failures.json")
    if not os.path.exists(p):
        return None
    try:
        d = json.load(open(p))
    except Exception:
        return None
    c = collections.Counter()
    for e in d.get("events", []):
        c[e.get("kind", "?")] += 1
    return c

def report(game, verbose=False):
    gd, pc = os.path.join(ROOT, game), os.path.join(ROOT, game + "pc")
    if not os.path.isdir(gd):
        return None
    funcs = sorted(parse_asm(gd) + parse_overlays(gd))
    if not funcs:
        return dict(game=game, declared=0, pct=None,
                    emitted=emitted_bodies(pc), fails=failures(pc), gaps=[])
    # Split into contiguous REGIONS (main segment, each overlay). Measuring one span
    # from the lowest to the highest address counts the main->overlay address jump as a
    # ~1.7MB 'gap' that does not exist. 2026-08-29: that false gap was reported as a
    # finding before this split existed.
    REGION_BREAK = 0x8000
    covered = sum(s for _, s, _ in funcs)
    gaps, span = [], 0
    rstart = funcs[0][0]
    for i in range(len(funcs) - 1):
        end = funcs[i][0] + funcs[i][1]
        nxt = funcs[i + 1][0]
        if nxt - end > REGION_BREAK:
            span += end - rstart
            rstart = nxt
        elif nxt > end:
            gaps.append((nxt - end, end, nxt))
    span += (funcs[-1][0] + funcs[-1][1]) - rstart
    gaps.sort(reverse=True)
    return dict(game=game, declared=len(funcs), covered=covered, span=span,
                pct=(100.0 * covered / span if span else 0),
                emitted=emitted_bodies(pc), fails=failures(pc), gaps=gaps[:5])

def fmt(r, verbose=False):
    if r is None:
        return None
    pct = "n/a" if r["pct"] is None else "%5.1f%%" % r["pct"]
    flag = ""
    if r["pct"] is not None:
        if r["pct"] < 50:   flag = "  << large uncovered span (may be DATA - verify with --pc)"
        elif r["pct"] < 85: flag = "  << check"
    fj = ""
    if r["fails"]:
        fj = "  failures:" + ",".join("%s=%d" % (k[:22], v)
                                      for k, v in r["fails"].most_common(3))
    line = "%-20s declared=%-5d emitted(main)=%-5d (+ovl %-5d) bytes=%s%s%s" % (
        r["game"], r["declared"], r["emitted"][0], r["emitted"][1], pct, fj, flag)
    if verbose and r.get("gaps"):
        for g, s, e in r["gaps"]:
            line += "\n      gap 0x%08X..0x%08X  %8d bytes" % (s, e, g)
    return line

def all_funcs(gd):
    """Declared functions of the resident tree PLUS its <game>_ram tree (the RAM-snapshot recipe's merged set).
    2026-09-03: without the _ram tree every RAM-set pc read NO EMITTED BODY on iggy - STEP ZERO cried wolf."""
    funcs = parse_asm(gd) + parse_overlays(gd)
    rd = gd.rstrip("\\/") + "_ram"
    if os.path.isdir(rd):
        funcs += parse_asm(rd)
    return funcs
def covered_pcs(game, pcs):
    """THE CHECK THAT MATTERS. For each executed PC, does an emitted body exist?

    Byte-coverage alone CANNOT prove missing code -- the uncovered span is full of data
    symbols. But a PC the game demonstrably EXECUTED, with no emitted body, is proof.
    Feed it spin-watch `pc=`, [gapcaller] targets, or any address from a hang.
    """
    gd = os.path.join(ROOT, game)
    funcs = all_funcs(gd)
    funcs.sort()
    out = []
    for pc in pcs:
        hit = [f for f in funcs if f[0] <= pc < f[0] + f[1]]
        prev = [f for f in funcs if f[0] <= pc]
        out.append((pc, hit[0] if hit else None, prev[-1] if prev else None))
    return out

def blind_declared_code(tree):
    """HOW MUCH OF THIS CARTRIDGE DID SEGMENTATION EVEN CALL CODE?

    The coverage question above ("of the code we declared, how much got emitted") assumes the
    declaration is roughly right. On the blind path it often is not, and that failure is upstream of
    everything else: if segmentation calls 98% of the cart `bin`, the recompiler emits almost
    nothing, the module links, the pipeline reports success, and the game cannot run. Turok 1 built
    to a 97 KB module and "ready to play" on 2026-09-08 for exactly this reason.

    So measure the split the yaml actually declares, straight from the cart's own segmentation:
    sum the span of every `asm` subsegment against the ROM's size. No ground truth needed.

    MEASURED 2026-09-08 over six blind-built carts - the split is bimodal with nothing in between:
        Rage Wars           8 MB   100.0% code   3674 libultra names
        Super Mario 64 JP   8 MB    99.8%           58
        Perfect Dark       32 MB    98.8%            6   (code declared, symbols missing - other bug)
        Donkey Kong 64     32 MB     2.2%           69
        Turok 2 JP         32 MB     2.7%           24
        Turok 1             8 MB     2.2%            4
    A low fraction does NOT prove the cart is compressed on its own - a cart can be genuinely
    asset-heavy - so this reports the number and says what it usually means, and never fails a build.
    """
    tree = os.path.abspath(tree)
    name = os.path.basename(tree.rstrip("\\/"))
    yml = os.path.join(tree, name + ".yaml")
    rom = os.path.join(tree, "baserom.z64")
    if not os.path.isfile(yml) or not os.path.isfile(rom):
        return None
    txt = open(yml, encoding="utf-8", errors="replace").read()
    ents = sorted((int(m.group(1), 16), m.group(2))
                  for m in re.finditer(r"-\s*\[\s*(0x[0-9A-Fa-f]+)\s*,\s*([A-Za-z0-9_]+)", txt))
    romsz = os.path.getsize(rom)
    by = collections.Counter()
    for i, (off, typ) in enumerate(ents):
        end = ents[i + 1][0] if i + 1 < len(ents) else romsz
        by[typ] += max(0, end - off)
    asm = by.get("asm", 0)
    syms = os.path.join(tree, "symbol_addrs.txt")
    nsym = sum(1 for _ in open(syms, encoding="utf-8", errors="replace")) if os.path.isfile(syms) else -1
    pc_dir = tree + "pc"
    if not os.path.isdir(pc_dir):
        pc_dir = os.path.join(os.path.dirname(tree), name + "pc")
    emitted = len(glob.glob(os.path.join(pc_dir, "RecompiledFuncs", "funcs_*.c")))
    # AND IS THERE ANY CODE IN THIS CART TO DECLARE IN THE FIRST PLACE?
    #
    # "Declared code as a share of the ROM" is a BAD judge on its own and nearly shipped as one
    # (2026-09-08). A 32 MB cart is mostly assets: Turok 2 JP holds 2398 of its 2432 function
    # prologues in the first megabyte and essentially none in the other 31, so declaring 894 KB of
    # code - 2.7% of the cart - is CORRECT, and a share-of-ROM rule calls it a failure. The share is
    # context, never the verdict.
    #
    # The honest question is whether we declared the code that is actually THERE, so measure the
    # cart the way tools/compressed_probe.py does, over the window every yaml declares
    # (ROM 0x1000..0x101000): count function prologues and take the entropy. A cart that ships its
    # body compressed has a bootloader and nothing else - single-digit prologues and entropy near 8 -
    # while a code-rich cart has thousands and sits near 5.8. That discriminator was validated across
    # the corpus on 2026-08-05 and re-confirmed today:
    #     Turok 1        3 prologues  entropy 7.62   compressed
    #     Perfect Dark  35            7.95           compressed
    #     Donkey Kong 64 149          7.95           compressed
    #     Rage Wars   1917            5.79           code-rich
    #     Turok 2 JP  2389            5.87           code-rich
    #     Super Mario 3206            5.82           code-rich
    #
    # PURE STDLIB ON PURPOSE. compressed_probe.py imports numpy, and the toolchain python the
    # product ships has no numpy and runs isolated (-I), so calling that tool from the pipeline
    # would fail on every user's machine. Checked before wiring it, not after.
    LO, HI = 0x1000, 0x101000
    prologues = jrra = 0
    entropy = 0.0
    with open(rom, "rb") as fh:
        fh.seek(LO)
        win = fh.read(HI - LO)
    if win:
        for i in range(0, len(win) - 4, 4):
            if win[i] == 0x27 and win[i + 1] == 0xBD and win[i + 2] >= 0x80:
                prologues += 1          # addiu sp, sp, -N
            elif win[i] == 0x03 and win[i + 1] == 0xE0 and win[i + 2] == 0x00 and win[i + 3] == 0x08:
                jrra += 1               # jr ra
        counts = collections.Counter(win)
        n = float(len(win))
        for c in counts.values():
            pr = c / n
            entropy -= pr * math.log2(pr)
    compressed = (prologues < 150 and entropy >= 6.5)
    return {"rom": romsz, "asm": asm, "pct": (100.0 * asm / romsz) if romsz else 0.0,
            "symbols": nsym, "emitted_files": emitted,
            "prologues": prologues, "jrra": jrra, "entropy": entropy, "compressed": compressed}


def pcs_from_log(path):
    txt = open(path, encoding="utf-8", errors="ignore").read()
    pcs = set(int(x, 16) for x in re.findall(r'spin-watch\] pc=0x([0-9A-Fa-f]{8})', txt))
    pcs |= set(int(x, 16) for x in re.findall(r'interp_pc=0x([0-9A-Fa-f]{8})', txt))
    pcs |= set(int(x, 16) for x in re.findall(r'gapcaller\] target=0x([0-9A-Fa-f]{8})', txt))
    return sorted(pcs)

if __name__ == "__main__":
    argv = sys.argv[1:]
    verbose = "-v" in argv
    # --blind <tree-dir>: the declaration check for a blind-built cart. Prints ONE line so a build
    # driver can quote it, and always exits 0 - this reports, it never fails a build.
    if "--blind" in argv:
        rest = [a for a in argv if a not in ("--blind", "-v")]
        info = blind_declared_code(rest[0]) if rest else None
        if not info:
            print("BLIND-COVERAGE unavailable (no <name>.yaml + baserom.z64 in %s)" % (rest[0] if rest else "?"))
            sys.exit(0)
        # FOUR OUTCOMES, AND ONLY TWO OF THEM ARE OUR FAULT. Cross what segmentation DECLARED with
        # what the cartridge actually CONTAINS; either half alone gives a wrong answer.
        #   compressed + little declared  -> EXPECTED. Nothing was there to declare. Not a bug; the
        #       cart needs the runtime-capture path before it can run (Turok 1, Donkey Kong 64).
        #   compressed + lots declared    -> MISDECLARED. Segmentation called compressed payload
        #       code, so the recompiler chokes on it and emission collapses. Perfect Dark declares
        #       98.8% of 32 MB as code and emits THREE files.
        #   code-rich + emission collapsed-> EMISSION SHORTFALL. The declaration was fine and almost
        #       nothing came out. N64Recomp bounds its output file size, so healthy builds land near
        #       100 KB of declared code per emitted file.
        #   code-rich + emitted           -> OK.
        # All measured 2026-09-08.
        kb = info["asm"] // 1024
        per_file = (kb / info["emitted_files"]) if info["emitted_files"] else float("inf")
        cart = ("compressed (%d prologues, entropy %.2f)" % (info["prologues"], info["entropy"])
                if info["compressed"] else
                "code-rich (%d prologues, entropy %.2f)" % (info["prologues"], info["entropy"]))
        if info["compressed"] and info["pct"] < 25.0:
            verdict = ("EXPECTED - this cartridge stores its code compressed and ships only a "
                       "bootloader as plain instructions, so there was almost nothing to declare. "
                       "This is not a pipeline error: the game needs its code captured while it runs "
                       "before it can be recompiled. Expect a small module and little on screen")
        elif info["compressed"]:
            verdict = ("MISDECLARED - the cartridge is compressed but segmentation declared %.1f%% of "
                       "it as code, so the recompiler was handed packed data. Emission collapses and "
                       "most of the game has no translated body" % info["pct"])
        elif per_file > 400.0:
            verdict = ("EMISSION SHORTFALL - %d KB of code was declared but only %d file(s) came out "
                       "(%.0f KB per file against a healthy ~100). The declaration is fine and the "
                       "recompiler produced almost nothing" % (kb, info["emitted_files"], per_file))
        else:
            verdict = "OK"
        print("BLIND-COVERAGE declared_code=%d KB of %d KB (%.1f%%) cart=%s libultra_names=%d "
              "emitted_files=%d verdict=%s"
              % (info["asm"] // 1024, info["rom"] // 1024, info["pct"], cart,
                 info["symbols"], info["emitted_files"], verdict))
        sys.exit(0)
    # --pc <game> <addr>...   /   --log <game> <logfile>
    if "--pc" in argv or "--log" in argv:
        mode = "--pc" if "--pc" in argv else "--log"
        rest = [a for a in argv if a not in ("--pc", "--log", "-v")]
        game = rest[0]
        pcs = (pcs_from_log(rest[1]) if mode == "--log"
               else [int(a, 16) for a in rest[1:]])
        if not pcs:
            print("no PCs found"); sys.exit(0)
        print("%-12s %-38s %s" % ("PC", "containing function", "verdict"))
        print("-" * 78)
        bad = 0
        for pc, hit, prev in covered_pcs(game, pcs):
            if hit:
                print("0x%08X   %-36s RECOMPILED" % (pc, "%s @0x%08X" % (hit[2], hit[0])))
            else:
                bad += 1
                pv = ("after %s @0x%08X" % (prev[2], prev[0])) if prev else "-"
                print("0x%08X   %-36s *** NO EMITTED BODY (interpreted) ***" % (pc, pv))
        print("-" * 78)
        print("%d/%d executed PCs have NO recompiled body" % (bad, len(pcs)))
        sys.exit(1 if bad else 0)
    args = [a for a in argv if not a.startswith("-")]
    if args:
        games = args
    else:
        games = sorted(os.path.basename(d)[:-2]
                       for d in glob.glob(os.path.join(ROOT, "*pc"))
                       if os.path.isdir(d) and
                       os.path.isdir(os.path.join(ROOT, os.path.basename(d)[:-2])))
    rows = []
    for g in games:
        r = report(g, verbose)
        if r:
            rows.append(r)
    rows.sort(key=lambda r: (r["pct"] if r["pct"] is not None else 999))
    print("%-22s %-13s %-13s %s" % ("GAME", "declared", "emitted", "byte-coverage"))
    print("-" * 78)
    for r in rows:
        print(fmt(r, verbose))
    bad = [r for r in rows if r["pct"] is not None and r["pct"] < 85]
    print("-" * 78)
    print("%d game(s) scanned; %d below 85%% byte coverage" % (len(rows), len(bad)))
