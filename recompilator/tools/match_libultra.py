#!/usr/bin/env python3
"""match_libultra.py (GENERIC) — blind libultra-surface identification, game-agnostic.

librecomp replaces the libultra OS layer BY NAME (N64Recomp's reimplemented_funcs /
ignored_funcs in symbol_lists.cpp). A blind ELF has no names, so the recompiler would
emit the raw N64 kernel (thread dispatch, COP0, ERET, raw interrupt-wait) as game code —
unbootable by construction (the SESSION 44 LoD lesson, and the "~84 swept games crash on
the 7th present after 4000 MI_INTR_MASK writes" cluster: their interrupt/scheduler
machinery was recompiled as raw MIPS with no raw-interrupt-delivery model).

THE FIX this tool produces: name the libultra functions in the game's symbol_addrs.txt so
N64Recomp's elf.cpp routes them to the HLE path (the already-working reimplemented_funcs
natives that deliver RCP interrupts as messages — the same path that boots sm64/cv64).

The matcher compares the game's code against named reference builds of the library by masked
signature across several passes, with strict unique-match discipline (a missed name only
degrades; a WRONG name corrupts). It never needs the references' code: each function is reduced
to a SHAPE (tools/libultra_shapes.py) - one-way hashes of its masked prefixes, its call sites and
their names, its immediates under a key only a matching body can derive - and a release carries
those shapes in recompilator/data/libultra_sigdb.json. The names looked for come from the
engine's own symbol lists (which names the HLE path reimplements or ignores).

Usage:
  python3 match_libultra.py --rom <baserom.z64> --out <symbol_addrs.txt> \
        [--region ROM_START:ROM_END:VRAM] [--vram VRAM] [--census]

  --region defaults to 0x1000:0x101000:<vram>  (the 1 MB resident image; libultra lives here).
  --vram   shortcut to set just the resident base when using the default rom span.
  --census runs Pass 8 (pointer-dispatch census) over the SAME single region. Default is to
           SKIP it: the interrupt binding (the whole point) comes from passes 1-7, and pass 8's
           extra func_* symbols are a bonus that — if the region is mis-described — can corrupt
           the symbol table by splitting real functions. Off unless you ask for it.
"""
import json
import argparse
import bisect
import os
import re
import struct
import sys
from collections import defaultdict

# ---- REFERENCES. A cartridge is matched against named builds of the N64 library, one per SDK
# era, in order: the first reference to uniquely match a name claims it, later references only
# FILL GAPS (additive, never override - a missed name only degrades, a wrong name corrupts).
#
# What the matcher compares against is a SHAPE per library function (tools/libultra_shapes.py):
# one-way hashes of its masked instruction prefixes, the positions and names of its calls, and
# its immediates under a key only a matching body can derive. No instruction words.
#   * A release carries those shapes in recompilator/data/libultra_sigdb.json (--sigdb).
#   * The machine that builds that file has the reference builds themselves, listed in
#     engine/references/sigdb_references.json (lab only, never exported; --refs to point elsewhere).
# Both sources become the same shapes, so the passes below run one code path everywhere.
HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)
import libultra_shapes as LS

ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
REFERENCE_MANIFEST = os.path.join(ROOT, "engine", "references", "sigdb_references.json")
# The engine's own symbol lists: the single source of truth for which names the HLE path
# reimplements or ignores. A shape database carries a copy, so a release needs no engine source.
SYMLISTS = os.path.join(ROOT, "engine", "runtime", "N64Recomp", "src", "symbol_lists.cpp")


def load_reference_manifest(path):
    """[(label, path, toml)] from the lab's manifest. Relative paths resolve against the manifest."""
    with open(path, encoding="utf-8") as f:
        m = json.load(f)
    base = os.path.dirname(os.path.abspath(path))
    out = []
    for r in m["references"]:
        p = r["path"] if os.path.isabs(r["path"]) else os.path.join(base, r["path"])
        t = r.get("toml", "") or ""
        if t and not os.path.isabs(t):
            t = os.path.join(base, t)
        out.append((r["label"], p, t))
    return out


def load_sigdb(path):
    """{label: {name: Shape}} and the (reimplemented, ignored) name sets, from a shape database."""
    with open(path, encoding="utf-8") as f:
        db = json.load(f)
    if db.get("format") != 3:
        raise SystemExit("%s is a format-%s signature database. Only format 3 (shapes, no code) is "
                         "accepted; rebuild it with tools/make_libultra_sigdb.py." % (path, db.get("format")))
    out = {}
    for r in db.get("references", []):
        out[r["label"]] = {n: LS.shape_from_json(n, j) for n, j in r["funcs"].items()}
    return out, (set(db.get("reimplemented", [])), set(db.get("ignored", [])))


MIN_WORDS = 6  # signatures shorter than this are too weak to trust

# ALIASED TWINS: one routine that ships under two module names in the SDK (cont/pfs both carry
# GetInitData). Their bodies drift by SDK VERSION, not by identity, so unmasked-immediate scoring
# cannot decide the name (a 2.0I Pfs body IS the 1996 Cont body verbatim). Challenges between them
# keep the incumbent — either name serves the HLE identically (the old dedupe's documented rationale).
TWIN_ALIASES = {frozenset({"__osContGetInitData", "__osPfsGetInitData"})}


def parse_name_sets(path):
    src = open(path, encoding="utf-8").read()
    def grab(setname):
        m = re.search(setname + r"\s*\{(.*?)\};", src, re.S)
        return set(re.findall(r'"([^"]+)"', m.group(1))) if m else set()
    reimp = grab(r"reimplemented_funcs")
    ignored = grab(r"ignored_funcs")
    return reimp, ignored


def parse_elf_symtab(path):
    d = open(path, "rb").read()
    assert d[:4] == b"\x7fELF" and d[5] == 2
    shoff = struct.unpack(">I", d[0x20:0x24])[0]
    shentsize, shnum, shstrndx = struct.unpack(">HHH", d[0x2E:0x34])
    def sh(i):
        o = shoff + i * shentsize
        return struct.unpack(">10I", d[o:o+40])
    secs = [sh(i) for i in range(shnum)]
    symtab = strtab = None
    for s in secs:
        if s[1] == 2:
            symtab = s; strtab = secs[s[6]]
    syms = {}
    n = symtab[5] // 16
    for i in range(n):
        o = symtab[4] + i * 16
        nm, val, sz, info, other, shndx = struct.unpack(">IIIBBH", d[o:o+16])
        if nm == 0 or shndx in (0, 0xFFF1) or shndx >= shnum:
            continue
        e = d.index(b"\0", strtab[4] + nm)
        name = d[strtab[4] + nm:e].decode()
        sec = secs[shndx]
        if sec[1] == 8:  # NOBITS
            continue
        off = sec[4] + (val - sec[3])
        syms[name] = (val, sz, off)
    return d, syms


def parse_ar_archive(path):
    """Parse a Unix `ar` archive of relocatable .o ELFs (SDK libgultra_rom.a etc.) into the SAME
    (data, syms) shape as parse_elf_symtab. KEY: late carts (1999-2001) shipped GCC-compiled libultra,
    but every game-ELF/IDO reference we had is IDO-compiled -> zero byte-match. The SDK .a is the EXACT
    library those carts linked. Each member's .o bytes are appended to one buffer; FUNC symbols get a
    synthetic unique vram (members 0x100000 apart) so the addr-map never collides. The byte-sig passes
    (1-3) match on the unrelocated bytes (jal/lui/load/store immediates are masked anyway); cross-.o jal
    targets stay 0 (relocations), so pass-4 callee-porting is naturally limited -- fine, the lib matches."""
    ar = open(path, "rb").read()
    assert ar[:8] == b"!<arch>\n", "not an ar archive"
    combined = bytearray(); syms = {}; pos = 8; midx = 0
    while pos + 60 <= len(ar):
        hdr = ar[pos:pos+60]
        try: size = int(hdr[48:58].decode().strip())
        except Exception: break
        name = hdr[:16].decode("latin1").rstrip("/ ").strip(); pos += 60
        data = ar[pos:pos+size]; pos += size + (size & 1)
        if data[:4] != b"\x7fELF" or data[5] != 2:   # skip the // long-name table, symbol index, non-BE
            continue
        midx += 1; base_off = len(combined); base_vram = midx * 0x100000; combined += data
        shoff = struct.unpack(">I", data[0x20:0x24])[0]
        shent, shnum = struct.unpack(">HH", data[0x2E:0x32])
        secs = [struct.unpack(">10I", data[shoff+i*shent:shoff+i*shent+40]) for i in range(shnum)]
        sts = [s for s in secs if s[1] == 2]
        if not sts: continue
        st = sts[0]; strt = secs[st[6]]
        for i in range(st[5] // 16):
            o = st[4] + i*16
            nm, val, sz, info, oth, shndx = struct.unpack(">IIIBBH", data[o:o+16])
            if nm == 0 or shndx == 0 or shndx >= shnum or (info & 0xf) != 2: continue
            e = data.index(b"\0", strt[4]+nm); sn = data[strt[4]+nm:e].decode("latin1")
            if not sn or sn in syms: continue
            sec = secs[shndx]
            if sec[1] == 8: continue
            syms[sn] = (base_vram + val, sz, base_off + sec[4] + (val - sec[3]))
    return bytes(combined), syms


mask_for = LS.mask_for   # the one definition of the compare mask lives with the shapes


def reference_sizes(syms, toml_path):
    """size_of(name) for a parsed reference: the symbol's own size, else the toml's, else the gap
    to the next symbol (an accurate size in a fully-named ELF), capped at 0x600."""
    toml_sizes = {}
    if toml_path and os.path.exists(toml_path):
        toml_sizes = {m.group(1): int(m.group(2)) for m in re.finditer(
            r'\{\s*name\s*=\s*"([^"]+)"\s*,\s*size\s*=\s*(\d+)\s*\}', open(toml_path, encoding="utf-8").read())}
    addrs_sorted = sorted(v[0] for v in syms.values())

    def size_of(name):
        val, sz, off = syms[name]
        if sz:
            return sz
        if name in toml_sizes:
            return toml_sizes[name]
        k = bisect.bisect_right(addrs_sorted, val)
        if k < len(addrs_sorted):
            return min(addrs_sorted[k] - val, 0x600)
        return 0
    return size_of


def shapes_from_reference(ref_path, ref_toml, targets):
    """{name: Shape} for every target the reference links, plus the library functions those
    bodies call (pass 4 ports and verifies callee names, so their shapes travel too). Only calls
    INSIDE a body extend the set: the 16-word window past a small function belongs to its
    neighbour, which in a game build is game code."""
    elf, syms = parse_ar_archive(ref_path) if ref_path.endswith(".a") else parse_elf_symtab(ref_path)
    size_of = reference_sizes(syms, ref_toml)
    addr_names = defaultdict(list)
    for n, (v, s, o) in syms.items():
        addr_names[v].append(n)

    def names_at(addr):
        return addr_names.get(addr, ())
    shapes = {}
    queue = [t for t in targets if t in syms]
    while queue:
        name = queue.pop()
        if name in shapes:
            continue
        val, _, off = syms[name]
        size = size_of(name)
        want = max(size // 4, LS.WINDOW_MIN)
        avail = max(0, min(want, (len(elf) - off) // 4))
        words = struct.unpack(f">{avail}I", elf[off:off + avail * 4]) if avail else ()
        sh = LS.build_shape(name, val, size, words, names_at)
        shapes[name] = sh
        for k, op, names in sh.calls:
            if k >= sh.n:
                continue
            for nm in names:
                if nm in syms and nm not in shapes and not LS.GENERIC_NAME.match(nm) and nm not in LS.RMON_NOISE:
                    queue.append(nm)
    return shapes


def parse_region(spec, default_vram):
    """ROM_START:ROM_END:VRAM (hex). Any field may be blank to take its default."""
    parts = spec.split(":")
    if len(parts) != 3:
        raise SystemExit(f"--region must be ROM_START:ROM_END:VRAM, got {spec!r}")
    def h(x, dflt):
        x = x.strip()
        return dflt if x == "" else int(x, 16)
    rom_start = h(parts[0], 0x1000)
    rom_end   = h(parts[1], 0x101000)
    vram      = h(parts[2], default_vram if default_vram is not None else 0)
    if vram == 0:
        raise SystemExit("region VRAM is 0 — pass --vram or the VRAM field of --region")
    return (rom_start, rom_end, vram)


def main():
    ap = argparse.ArgumentParser(description="Generic blind libultra-surface matcher.")
    ap.add_argument("--rom", required=True, help="path to the game's baserom (.z64, big-endian)")
    ap.add_argument("--out", required=True, help="output symbol_addrs.txt path")
    ap.add_argument("--region", default=None, action="append",
                    help="ROM_START:ROM_END:VRAM (hex). Default 0x1000:0x101000:<vram>. REPEATABLE: "
                         "a cartridge whose code is not one contiguous run needs one region per "
                         "loaded module, or the library inside a detached module is named at "
                         "addresses that do not exist (Mario's audio library, 2026-09-07).")
    ap.add_argument("--vram", default=None,
                    help="resident base vram (hex). Used when --region is omitted, or to fill its VRAM field.")
    ap.add_argument("--census", action="store_true",
                    help="run Pass 8 (pointer-dispatch census) over the SAME region. Default: SKIP.")
    ap.add_argument("--sigdb", default=None, metavar="PATH",
                    help="a shape database from tools/make_libultra_sigdb.py, used INSTEAD of the "
                         "reference builds. This is what a release carries: without it the matcher "
                         "names nothing and a cartridge's OS layer is recompiled raw instead of bound "
                         "to the engine.")
    ap.add_argument("--refs", default=None, metavar="PATH",
                    help="a reference manifest (default: engine/references/sigdb_references.json, the lab's).")
    ap.add_argument("--ref", action="append", default=None, metavar="LABEL:ELF:TOML",
                    help="one named reference build (repeatable), overriding the manifest. "
                         "Each is matched in order; first unique match wins, later refs fill gaps.")
    args = ap.parse_args()

    SIGDB = {}
    SIGDB_NAMESETS = (set(), set())
    if args.sigdb:
        SIGDB, SIGDB_NAMESETS = load_sigdb(args.sigdb)
        print("[match_libultra] sigdb %s: %d reference(s), %d shapes"
              % (args.sigdb, len(SIGDB), sum(len(s) for s in SIGDB.values())))

    if args.ref:
        references = []
        for spec in args.ref:
            parts = spec.split(":", 2)
            if len(parts) != 3:
                raise SystemExit(f"--ref must be LABEL:ELF:TOML, got {spec!r}")
            references.append((parts[0], parts[1], parts[2]))
    elif SIGDB:
        references = [(lab, "", "") for lab in SIGDB]
    else:
        manifest = args.refs or REFERENCE_MANIFEST
        if not os.path.exists(manifest):
            raise SystemExit("no --sigdb and no reference manifest at %s: nothing to match against" % manifest)
        references = load_reference_manifest(manifest)

    GAME_ROM = args.rom
    OUT = args.out
    default_vram = int(args.vram, 16) if args.vram is not None else None
    if args.region:
        GAME_REGIONS = [parse_region(r, default_vram) for r in args.region]
    else:
        if default_vram is None:
            raise SystemExit("either --region ROM_START:ROM_END:VRAM or --vram VRAM is required")
        GAME_REGIONS = [(0x1000, 0x101000, default_vram)]
    print(f"[match_libultra] rom={GAME_ROM}")
    for _rs, _re, _rv in GAME_REGIONS:
        print(f"[match_libultra] region rom 0x{_rs:X}..0x{_re:X} @ vram 0x{_rv:08X}")
    print(f"[match_libultra] out={OUT}  census={'ON' if args.census else 'off'}")

    # The name sets travel WITH the signatures when a database is given: symbol_lists.cpp lives in
    # the engine's SOURCE and a release ships only its headers, so reading it by absolute path fails
    # on any machine but this one - the same defect as the references, in a second place.
    if SIGDB_NAMESETS[0] or SIGDB_NAMESETS[1]:
        reimp, ignored = SIGDB_NAMESETS
    else:
        if not os.path.exists(SYMLISTS):
            raise SystemExit("no --sigdb and no symbol lists at %s: no names to look for" % SYMLISTS)
        reimp, ignored = parse_name_sets(SYMLISTS)
    # EXCLUDE rmon/debug-monitor internals (send/send_mesg/send_packet/kdebugserver/string_to_u32/handle_CpU):
    # they are debug-only, almost never linked in retail carts, ignored-only (never written to output, so
    # matching them does nothing useful), and their generic byte signatures cause FALSE POSITIVES that claim
    # real public primitives' addresses (e.g. send_mesg byte-matched Blast Corps' osCreateThread, blocking the
    # structural detector). Dropping them removes the noise + frees those addresses. General fix.
    RMON_NOISE = {"send", "send_mesg", "send_packet", "kdebugserver", "string_to_u32", "handle_CpU"}
    targets = [t for t in sorted(reimp | ignored) if t not in RMON_NOISE]
    print(f"{len(targets)} target names from symbol_lists.cpp (excluding {len(RMON_NOISE)} rmon/debug internals)")

    import bisect
    rom = open(GAME_ROM, "rb").read()

    regions = []
    for rom_start, rom_end, vram in GAME_REGIONS:
        words = list(struct.unpack(f">{(rom_end-rom_start)//4}I", rom[rom_start:rom_start + ((rom_end-rom_start)//4)*4]))
        regions.append((rom_start, vram, words))
    # The cartridge side of the comparison: every region's masked words hashed once; a shape's
    # masked prefix of any length is then looked up, never scanned for.
    G = LS.GameIndex(regions)

    # region_of is game-side (reference-independent) - passes 5-8 share it with the passes below.
    region_of = G.region_of

    found = {}      # name -> game_vram. CUMULATIVE across references: first unique match wins.
    ambiguous = {}  # name -> [hits]. PER-reference: reset each run; the last run's leftovers report.
    claim_sig = {}  # name -> (shape, W) of the reference prefix that claimed it (for challenges)
    targets_set = set(targets)

    # ---- Passes 1-4 run ONCE PER REFERENCE (the multi-reference generalization). Each
    # reference is a named libultra build from a particular SDK era; a name a reference can't
    # match degrades to "unmatched", but a later reference (different SDK) may match it. STRICT
    # additive discipline: a reference only ATTEMPTS names not already found, so an earlier
    # reference's unique match is never overridden (a missed name degrades; a wrong name
    # corrupts). The passes are the original single-reference logic; only the reference state
    # (the shapes) is per-call.
    def run_reference(label, REF_ELF, REF_TOML):
        # A SHAPE DATABASE holds exactly what a reference build is turned into here, so every pass
        # below is the same code whether the shapes came from the lab's references or from the
        # file a release carries (tools/libultra_shapes.py).
        if label in SIGDB:
            shapes = SIGDB[label]
        else:
            shapes = shapes_from_reference(REF_ELF, REF_TOML, targets)

        ambiguous.clear()  # ambiguity is per-reference; found is cumulative across references.
        challenges = []    # (name, addr, shape, W): unique hits on OCCUPIED addrs, resolved at run end

        # ---- Pass 1: windowed masked signatures. Only names NOT already claimed by an
        # earlier reference, and only those this reference actually links (has a shape for).
        # Small functions (cop0 one-liners like osGetCount) carry too little structure alone -
        # the window extends into the following code (Shape.L1 = max(size, 16) words). Non-sibling
        # caveat: module/link order may differ from the reference's, so windowed matches can fail
        # where the function is identical; pass 3 below retries small funcs unwindowed.
        for name in targets:
            if name in found or name not in shapes:
                continue
            sh = shapes[name]
            hits = G.search(sh, sh.L1)
            # A unique hit on an OCCUPIED address is a NAME CONFLICT, not a claim: two different
            # names' masked prefixes matched one site (masked load/store immediates hide struct
            # offsets - osGetThreadId vs osGetThreadPri). Record a challenge; run-end resolution
            # keeps whichever reference body agrees with the game's UNMASKED immediates
            # (first-ref-wins and alphabetical-keep are both coin flips that corrupt).
            if len(hits) == 1:
                if hits[0] in found.values():
                    challenges.append((name, hits[0], sh, sh.L1))
                else:
                    found[name] = hits[0]
                    claim_sig[name] = (sh, sh.L1)
            elif len(hits) > 1:
                ambiguous[name] = hits

        # Disambiguation pass 1: jal fingerprints. A call inside the reference body to a target
        # already placed in the game must be a call to that address at the candidate site.
        def target_callee(names):   # the target name at a reference call site (last in sorted order)
            c = [nm for nm in names if nm in targets_set]
            return max(c) if c else None
        for name in list(ambiguous.keys()):
            sh = shapes[name]
            checks = []
            for k, op, names in sh.calls:
                if op != 3:
                    continue
                callee = target_callee(names)
                if callee and callee in found:
                    checks.append((k, found[callee]))
            if not checks:
                continue
            survivors = []
            for h in ambiguous[name]:
                ok = True
                for k, want in checks:
                    ri, vram_base, words = next((ri, v, w) for ri, (rs, v, w) in enumerate(regions)
                                                if v <= h < v + len(w) * 4)
                    w = words[(h - vram_base) // 4 + k]
                    if (w >> 26) != 3 or (0x80000000 | ((w & 0x03FFFFFF) << 2)) != want:
                        ok = False
                        break
                if ok:
                    survivors.append(h)
            if len(survivors) == 1 and survivors[0] not in found.values():
                found[name] = survivors[0]
                del ambiguous[name]
            elif survivors:
                ambiguous[name] = survivors

        # Disambiguation pass 2: cluster rank order (libultra internal link order is
        # archive-order, broadly stable across SDK versions - but VERIFY at boot for
        # non-sibling games).
        clusters = defaultdict(list)
        for name, hits in ambiguous.items():
            clusters[tuple(hits)].append(name)
        for hitset, names in clusters.items():
            if len(names) == len(hitset) and not any(h in found.values() for h in hitset):
                names_by_ref = sorted(names, key=lambda n: shapes[n].vram)
                for n, h in zip(names_by_ref, sorted(hitset)):
                    found[n] = h
                    del ambiguous[n]
                print(f"  [{label}] rank-ordered cluster: {names_by_ref} -> {[hex(h) for h in sorted(hitset)]}")

        print(f"[{label}] pass 1+2 (windowed masked signatures): {len(found)} matched")

        # ---- Pass 3: body-exact, NO window. The 16-word window misses small STABLE
        # functions whose neighbors differ in the older SDK (osCreateMesgQueue is 8
        # words of identical code with a different module neighbor). Uniqueness still
        # required; floor of MIN_WORDS keeps weak signatures out. The body is compared with its
        # trailing pad-nops trimmed (sizes from gap-to-next include alignment padding): Shape.L3.
        for name in [n for n in targets if n in shapes and n not in found]:
            sh = shapes[name]
            if sh.n < MIN_WORDS:
                continue
            if sh.L3 is None or sh.L3 < MIN_WORDS:
                continue
            hits = G.search(sh, sh.L3)
            if len(hits) == 1:
                if hits[0] in found.values():
                    challenges.append((name, hits[0], sh, sh.L3))
                else:
                    found[name] = hits[0]
                    claim_sig[name] = (sh, sh.L3)
        print(f"[{label}] pass 3 (+body-exact unwindowed): {len(found)} matched")

        # ---- Pass 3.5: ENTRY-FINGERPRINT. A function whose TAIL diverges from the reference
        # (vendor-patched libultra: Blitz's osCreateThread = 96 words byte-identical to GD20K then an
        # inserted Midway hook; the amshpc osPfs* divergent-build class) can never full-body match.
        # Claim by the LONGEST masked PREFIX window that hits EXACTLY ONCE in the game (floor
        # FP_MIN_WORDS), guarded: no other target in this reference may share that masked prefix
        # (twin guard - masked load/store immediates hide struct offsets, so osGetThreadId vs
        # osGetThreadPri look identical under the mask), and the address must be unclaimed.
        FP_MIN_WORDS = 16
        fp_claims = 0
        for name in [n for n in targets if n in shapes and n not in found and n not in ambiguous]:
            sh = shapes[name]
            if sh.n < FP_MIN_WORDS:
                continue
            if sh.L3 is None or sh.L3 < FP_MIN_WORDS:
                continue
            # hits(W) is monotone non-increasing in W: binary-search the largest W with >=1 hit.
            lo, hi, best_w = FP_MIN_WORDS, sh.L3, None
            while lo <= hi:
                mid = (lo + hi) // 2
                if G.search(sh, mid):
                    best_w = mid; lo = mid + 1
                else:
                    hi = mid - 1
            if best_w is None or best_w >= sh.L3:
                continue  # 0 hits anywhere, or full body hits (pass 1/3 territory: ambiguous there)
            hits = G.search(sh, best_w)
            if len(hits) != 1:
                continue
            if hits[0] in found.values():
                challenges.append((name, hits[0], sh, best_w))
                continue
            # twin guard: another target with the same masked prefix at this W could claim this site
            fw = sh.F(best_w)
            twin = False
            for other in targets:
                if other == name or other not in shapes:
                    continue
                osh = shapes[other]
                if osh.n < best_w:
                    continue
                if osh.F(best_w) == fw:
                    twin = True
                    break
            if twin:
                continue
            found[name] = hits[0]
            claim_sig[name] = (sh, best_w)
            fp_claims += 1
            print(f"  [{label}] pass3.5 entry-fingerprint: {name} = {hex(hits[0])} (W={best_w}/{sh.L3})")
        if fp_claims:
            print(f"[{label}] pass 3.5 (+entry-fingerprint): {len(found)} matched")

        # ---- Pass 4: callee-position porting, iterated to fixpoint. A masked-matched
        # body has IDENTICAL call structure to its reference original (only jal/j targets
        # were masked), so callee k at the game site corresponds to callee k of the
        # reference body - port the callee names. Discipline: propagate only from sites
        # whose body masked-matches the reference's (verified in place); auto-ish names are
        # never ported; conflicting claims are dropped loudly.
        def body_matches_at(name, vram):
            sh = shapes[name]
            if sh.n < 4 or sh.L3 is None:
                return False
            return G.matches_at(sh, sh.L3, vram)

        def port_callee(names):   # the reference's name for a callee: the first that is not auto-ish
            for nm in names:
                if not LS.GENERIC_NAME.match(nm) and nm not in RMON_NOISE:   # rmon noise false-positives
                    return nm
            return None

        # only names this reference can verify (guards found names from earlier refs not in shapes)
        verified = {n for n in found if n in shapes and body_matches_at(n, found[n])}
        propagated_from = set()
        while True:
            new = {}
            conflicts = set()
            for name in list(verified - propagated_from):
                propagated_from.add(name)
                sh = shapes[name]
                base, words = region_of(found[name])
                wi = (found[name] - base) // 4
                for k, op, names in sh.calls:
                    if k >= sh.n or wi + k >= len(words):
                        break
                    callee = port_callee(names)
                    if not callee or callee in found:
                        continue
                    sw = words[wi + k]
                    if (sw >> 26) != op:
                        continue
                    sm_tgt = 0x80000000 | ((sw & 0x03FFFFFF) << 2)
                    if region_of(sm_tgt)[0] is None:
                        continue
                    if callee in new and new[callee] != sm_tgt:
                        conflicts.add(callee)
                        continue
                    prior = next((n2 for n2, v2 in {**found, **new}.items() if v2 == sm_tgt and n2 != callee), None)
                    if prior:
                        conflicts.add(callee)
                        continue
                    new[callee] = sm_tgt
            for c in conflicts:
                new.pop(c, None)
                print(f"  [{label}] pass4 CONFLICT dropped: {c}")
            if not new:
                break
            for callee, vram in new.items():
                found[callee] = vram
                if callee in shapes and body_matches_at(callee, vram):
                    verified.add(callee)
        print(f"[{label}] pass 4 (+callee-position porting): {len(found)} matched")

        # ---- Run-end CHALLENGE resolution: a unique hit on an occupied address means two names'
        # masked prefixes matched one site - at most one is right. Score BOTH claimants' reference
        # bodies against the game's unmasked immediates (GameIndex.imm_score); the challenger takes
        # the address only by STRICTLY winning (fewer mismatches, then more checked immediates).
        # Ties keep the incumbent (true twins - one shared impl - are byte-identical, so either
        # name serves). Incumbents without a recorded claim (structural/ported) are never usurped.
        # Caught live: CV64's osGetThreadPri uniquely hit SM64's osGetThreadId site; SM64's own
        # byte-exact osGetThreadId then challenged and won (0 mismatches vs 1).
        for name, addr, csh, cW in challenges:
            if name in found:
                continue
            incumbent = next((n for n, v in found.items() if v == addr), None)
            if incumbent is None:           # address freed meanwhile (a prior challenge swapped it)
                found[name] = addr
                claim_sig[name] = (csh, cW)
                continue
            if frozenset({name, incumbent}) in TWIN_ALIASES:
                continue
            inc = claim_sig.get(incumbent)
            if inc is None:
                continue
            im, ic = G.imm_score(inc[0], inc[1], addr)
            cm, cc = G.imm_score(csh, cW, addr)
            if (cm, -cc) < (im, -ic):
                del found[incumbent]
                found[name] = addr
                claim_sig[name] = (csh, cW)
                print(f"  [{label}] challenge @{hex(addr)}: {name} (mism={cm}/chk={cc}) USURPS "
                      f"{incumbent} (mism={im}/chk={ic})")

    for _lbl, _relf, _rtoml in references:
        print(f"=== reference {_lbl}: {_relf} ===")
        # A missing/broken reference ELF (e.g. cv64's un-built build/castlevania) must NOT crash the
        # whole match — skip it and keep matching against the references that ARE present. General fix:
        # the reference set is best-effort; each game matches against whatever is available.
        try:
            run_reference(_lbl, _relf, _rtoml)
        except FileNotFoundError as _e:
            print(f"    [skip] reference {_lbl} unavailable (file not found): {_e}")
        except Exception as _e:
            print(f"    [skip] reference {_lbl} failed: {type(_e).__name__}: {_e}")

    # ---- Pass 5: cop0/fpu-leaf templates. Version-invariant hardware one-liners
    # carry their identity in a single rare opcode word; window-free and exact.
    def find_word_sites(word):
        sites = []
        for rom_start, base, words in regions:
            sites += [base + i * 4 for i, w in enumerate(words) if w == word]
        return sites

    def word_at(vram):
        base, words = region_of(vram)
        return None if base is None else words[(vram - base) // 4]

    JR_RA = 0x03E00008
    leaf_templates = {
        # name: (anchor word, start offset words back from anchor, expected next words predicate)
        "osGetCount":     (0x40024800, 0),  # mfc0 v0, C0_COUNT; jr ra
        "__osSetCompare": (0x40845800, 0),  # mtc0 a0, C0_COMPARE; jr ra
        "__osGetSR":      (0x40026000, 0),  # mfc0 v0, C0_SR; jr ra
        "__osSetSR":      (0x40846000, 0),  # mtc0 a0, C0_SR; jr ra
        "__osSetFpcCsr":  (0x44C4F800, 1),  # cfc1 v0,$31; ctc1 a0,$31; jr ra
        "__osGetCause":   (0x40026800, 0),  # mfc0 v0, C0_CAUSE; jr ra
    }
    for name, (anchor, back) in leaf_templates.items():
        if name in found:
            continue
        sites = find_word_sites(anchor)
        # require a jr $ra within 2 words after the anchor (leaf shape)
        sites = [s for s in sites if word_at(s + 4) == JR_RA or word_at(s + 8) == JR_RA]
        if len(sites) == 1:
            found[name] = sites[0] - back * 4
            print(f"  pass5 leaf: {name} = {hex(found[name])}")
    # __osDisableInt / __osRestoreInt (old-SDK forms; anchored on SR mtc0 shapes)
    if "__osDisableInt" not in found:
        sites = [s for s in find_word_sites(0x40086000)          # mfc0 t0, C0_SR
                 if word_at(s + 12) == 0x31020001 or word_at(s + 16) == 0x31020001]  # andi v0,t0,1
        if len(sites) == 1:
            found["__osDisableInt"] = sites[0]
            print(f"  pass5 leaf: __osDisableInt = {hex(sites[0])}")
    if "__osRestoreInt" not in found:
        sites = [s for s in find_word_sites(0x40086000)
                 if word_at(s + 4) == 0x01044025 and word_at(s + 8) == 0x40886000]   # or t0,t0,a0; mtc0 t0
        if len(sites) == 1:
            found["__osRestoreInt"] = sites[0]
            print(f"  pass5 leaf: __osRestoreInt = {hex(sites[0])}")

    # ---- Pass 6: MMIO-anchored + topology detectors. Hardware register addresses
    # and call topology are SDK-version-invariant — this is the "generic libultra
    # identification" layer the engine needed for its first non-sibling game.
    # Function starts approximated by the jal/j-target set (kernel asm is reached
    # by j, not jal).
    # jal targets ONLY: IDO emits j for intra-function jumps, so j targets would
    # fragment every function and break body attribution. Already-found names are
    # starts too (they bound their predecessors' bodies).
    starts = set(found.values())
    for rom_start, base, words in regions:
        for w in words:
            if (w >> 26) == 3:
                t = 0x80000000 | ((w & 0x03FFFFFF) << 2)
                if region_of(t)[0] is not None:
                    starts.add(t)
    # PROLOGUE-SCAN starts (general accuracy fix, 2026-06-20): jal-targets ALONE miss every function reached
    # only by function-pointer or fall-through, so they MERGE into a neighbor and the structural/topology
    # detectors (passes 5-8) read wrong-bounded bodies (osSetEventMesg wasn't even a start; osCreateThread
    # mis-matched). Add each `addiu sp,sp,-N` (stack-frame allocation = a function entry) that is PRECEDED by a
    # terminator (jr/j + delay slot, or nop padding) — the S34 rule, so a false positive can never split a real
    # function. Sharpens body_words()/func_start_of() for every structural detector below.
    def _is_term(x):
        return ((x >> 26) == 0 and (x & 0x3F) == 8) or (x >> 26) == 2   # jr / j = function exit
    for rom_start, base, words in regions:
        for i in range(3, len(words)):
            w = words[i]
            if (w >> 16) == 0x27BD and (w & 0x8000):          # addiu sp, sp, -N (frame alloc = entry)
                wm1, wm2, wm3 = words[i - 1], words[i - 2], words[i - 3]
                if _is_term(wm2) or (wm1 == 0 and wm2 == 0) or (wm1 == 0 and _is_term(wm3)):
                    starts.add(base + i * 4)
    starts = sorted(starts)
    import bisect as _b

    def func_start_of(vram):
        k = _b.bisect_right(starts, vram) - 1
        return starts[k] if k >= 0 else None

    def body_words(start, cap=0x800):
        k = _b.bisect_right(starts, start)
        end = starts[k] if k < len(starts) else start + cap
        end = min(end, start + cap)
        base, words = region_of(start)
        if base is None:
            # jal targets are raw decodes; a garbage/other-segment target must degrade to an empty
            # body, not crash the whole match (pass-7 li_consts walked one on Mischief Makers).
            return []
        wi = (start - base) // 4
        return words[wi:wi + (end - start) // 4]

    def jals_of(start):
        out = []
        for k, w in enumerate(body_words(start)):
            if (w >> 26) == 3:
                out.append((k, 0x80000000 | ((w & 0x03FFFFFF) << 2)))
        return out

    # Per-function MMIO access sets: track lui-loaded bases through lw/sw.
    mmio_bases = {0xA404, 0xA408, 0xA440, 0xA450, 0xA460, 0xA480, 0xBFC0}
    func_mmio = defaultdict(set)   # start -> {(base16, offset, is_store)}
    for st in starts:
        regbase = {}
        for w in body_words(st):
            op = w >> 26
            if op == 0x0F:  # lui rt, imm  (rt = bits 20:16)
                rt = (w >> 16) & 0x1F
                if (w & 0xFFFF) in mmio_bases:
                    regbase[rt] = w & 0xFFFF
                else:
                    regbase.pop(rt, None)
            elif op in (0x23, 0x2B):  # lw / sw
                rs = (w >> 21) & 0x1F
                if rs in regbase:
                    func_mmio[st].add((regbase[rs], w & 0xFFFF, op == 0x2B))

    def claim(name, vram, why):
        if name in found or vram is None:
            return
        if vram in found.values():
            return
        found[name] = vram
        print(f"  pass6 {why}: {name} = {hex(vram)}")

    def unique_func_with(pred):
        c = [st for st in starts if pred(st)]
        return c[0] if len(c) == 1 else None

    # AI trio (0xA450 block: 0=DRAM_ADDR, 4=LEN, 0x10=DACRATE)
    claim("osAiGetLength",     unique_func_with(lambda st: (0xA450, 4, False) in func_mmio[st] and len(body_words(st)) <= 8), "mmio")
    claim("osAiSetNextBuffer", unique_func_with(lambda st: (0xA450, 0, True) in func_mmio[st]), "mmio")
    claim("osAiSetFrequency",  unique_func_with(lambda st: (0xA450, 0x10, True) in func_mmio[st]), "mmio")
    # SP raw DMA (0xA404: 0=MEM_ADDR, 4=DRAM_ADDR)
    claim("__osSpRawStartDma", unique_func_with(lambda st: (0xA404, 0, True) in func_mmio[st] and (0xA404, 4, True) in func_mmio[st]), "mmio")
    # SI (0xA480: 0=DRAM_ADDR, 0x18=STATUS) and direct PIF IO (0xBFC0)
    claim("__osSiRawStartDma", unique_func_with(lambda st: (0xA480, 0, True) in func_mmio[st]), "mmio")
    claim("__osSiDeviceBusy",  unique_func_with(lambda st: (0xA480, 0x18, False) in func_mmio[st] and len(body_words(st)) <= 10), "mmio")
    claim("__osSiRawReadIo",   unique_func_with(lambda st: any(b == 0xBFC0 and not s for b, o, s in func_mmio[st]) and len(body_words(st)) <= 16), "mmio")
    claim("__osSiRawWriteIo",  unique_func_with(lambda st: any(b == 0xBFC0 and s for b, o, s in func_mmio[st]) and len(body_words(st)) <= 16), "mmio")
    # PI raw DMA (0xA460: 0=DRAM_ADDR, 4=CART_ADDR)
    claim("__osPiRawStartDma", unique_func_with(lambda st: (0xA460, 0, True) in func_mmio[st] and (0xA460, 4, True) in func_mmio[st]), "mmio")
    # VI swap context: the function writing many VI registers
    claim("__osViSwapContext", unique_func_with(lambda st: len({o for b, o, s in func_mmio[st] if b == 0xA440 and s}) >= 4), "mmio")
    # access-queue releases: module-adjacent, next function after the matched Get
    for get_name, rel_name in (("__osPiGetAccess", "__osPiRelAccess"), ("__osSiGetAccess", "__osSiRelAccess")):
        if get_name in found and rel_name not in found:
            k = _b.bisect_right(starts, found[get_name])
            if k < len(starts) and starts[k] - found[get_name] <= 0x100:
                claim(rel_name, starts[k], "adjacency")
    # Pi/Si access-queue modules compile from the same source: if the Si pair
    # resolved but the PI Rel was never jal'd (nothing links its callers), place it
    # by the symmetric module delta.
    if ("__osPiRelAccess" not in found and all(n in found for n in ("__osPiGetAccess", "__osSiGetAccess", "__osSiRelAccess"))):
        claim("__osPiRelAccess", found["__osPiGetAccess"] + (found["__osSiRelAccess"] - found["__osSiGetAccess"]), "module-symmetry")
    # osSpTaskLoad: the common caller of __osSpSetStatus and __osSpRawStartDma
    if "__osSpSetStatus" in found and "__osSpRawStartDma" in found:
        a, b2 = found["__osSpSetStatus"], found["__osSpRawStartDma"]
        claim("osSpTaskLoad", unique_func_with(lambda st: {a, b2} <= {t for _, t in jals_of(st)}), "topology")
    # osPiStartDma: calls osVirtualToPhysical + both osSendMesg and osJamMesg (pri routing)
    if all(n in found for n in ("osVirtualToPhysical", "osSendMesg", "osJamMesg")):
        v, s_, j = found["osVirtualToPhysical"], found["osSendMesg"], found["osJamMesg"]
        claim("osPiStartDma", unique_func_with(lambda st: {v, s_, j} <= {t for _, t in jals_of(st)}), "topology")
    # VI getters (2026-09-06, Star Wars Racer #102): osViGetNextFramebuffer and osViGetCurrentFramebuffer
    # are byte-identical except for the %lo of the global they load (__osViNext vs __osViCurr, 4 bytes
    # apart), and the masked reference match assigned them SWAPPED in 75 trees. The tie-break is the
    # tree's own osViSwapBuffer (unmistakable: writes +4, ORs 0x10 into the state halfword), whose first
    # lui/lw pair IS __osViNext: the getter loading that word is Next, the one 4 lower is Current.
    # (recompilator/tools/census_vigetter.py judges existing trees by the same rule.)
    def first_lui_load(st):
        hi = {}
        for w in body_words(st)[:24]:
            op = w >> 26
            if op == 0x0F:
                hi[(w >> 16) & 31] = (w & 0xFFFF) << 16
            elif op in (0x23, 0x2B):
                base = (w >> 21) & 31
                if base in hi:
                    off = w & 0xFFFF
                    return (hi[base] + (off - 0x10000 if off & 0x8000 else off)) & 0xFFFFFFFF
        return None
    if "osViSwapBuffer" in found:
        vi_next = first_lui_load(found["osViSwapBuffer"])
        if vi_next is not None:
            getters = {n: found[n] for n in ("osViGetNextFramebuffer", "osViGetCurrentFramebuffer") if n in found}
            resolved = {}
            for n, st in getters.items():
                a = first_lui_load(st)
                want = ("osViGetNextFramebuffer" if a == vi_next else
                        "osViGetCurrentFramebuffer" if a == ((vi_next - 4) & 0xFFFFFFFF) else None)
                if want and want != n:
                    resolved[st] = want
            if resolved:
                for n in getters:
                    del found[n]
                for st, want in resolved.items():
                    found[want] = st
                    print(f"  pass6 vi-getter: {want} = {hex(st)} (its %lo against osViSwapBuffer's __osViNext)")
                for n, st in getters.items():          # a getter that was right stays where it was
                    if st not in resolved and n not in found and st not in found.values():
                        found[n] = st
    # osYieldThread: the smallest caller of __osEnqueueAndYield
    # 2026-09-06 (bam99 #98): the <=12-word cap made this rule UNMATCHABLE — libultra's
    # osYieldThread is 18 words of body (prologue, __osDisableInt, the __osRunningThread /
    # __osRunQueue pair, state=OS_STATE_RUNNABLE, __osEnqueueAndYield, __osRestoreInt, epilogue)
    # and assembles to 0x50 bytes = 20 words with padding, so no tree in the corpus was ever
    # claimed by it. bam99 left its osYieldThread at 0x80098530 unnamed and recompiled raw; its
    # guest eret is a no-op under HLE, so the yield returned instantly and a two-thread rendezvous
    # spun at 416k iterations/s. Cap raised to 24; the len(callers) == 1 uniqueness test below is
    # what keeps osStopThread / osRecvMesg (the other __osEnqueueAndYield callers) from claiming it.
    if "__osEnqueueAndYield" in found:
        e = found["__osEnqueueAndYield"]
        callers = [st for st in starts if e in {t for _, t in jals_of(st)} and st not in found.values()]
        callers = [st for st in callers if len(body_words(st)) <= 24]
        if len(callers) == 1:
            claim("osYieldThread", callers[0], "topology")
    # Manager creators: callers of osCreateThread+osStartThread; thread entry = a3
    # constant before the osCreateThread jal. Entry jal'ing __osViSwapContext =
    # viMgrMain (creator = osCreateViManager); entry jal'ing __osPiRawStartDma =
    # __osDevMgrMain (creator = osCreatePiManager).
    if "osCreateThread" in found and "osStartThread" in found:
        ct, st_ = found["osCreateThread"], found["osStartThread"]
        for cand in starts:
            tg = {t for _, t in jals_of(cand)}
            if not ({ct, st_} <= tg) or cand in found.values():
                continue
            bw = body_words(cand)
            ct_idx = next((k for k, w in enumerate(bw) if (w >> 26) == 3 and (0x80000000 | ((w & 0x03FFFFFF) << 2)) == ct), None)
            if ct_idx is None:
                continue
            hi = lo = None
            for w in bw[max(0, ct_idx - 12):ct_idx + 2]:
                if (w >> 26) == 0x0F and ((w >> 16) & 0x1F) == 7:        # lui a3
                    hi = (w & 0xFFFF) << 16
                if (w >> 26) == 0x09 and ((w >> 16) & 0x1F) == 7 and ((w >> 21) & 0x1F) == 7:  # addiu a3,a3
                    lo = w & 0xFFFF
            if hi is None:
                continue
            entry = hi + ((lo - 0x10000) if lo and lo >= 0x8000 else (lo or 0))
            if region_of(entry)[0] is None:
                continue
            entry_tg = {t for _, t in jals_of(entry)}
            if "__osViSwapContext" in found and found["__osViSwapContext"] in entry_tg:
                claim("viMgrMain", entry, "thread-entry")
                claim("osCreateViManager", cand, "topology")
                # osCreateViManager jals osSetEventMesg twice (VI + COUNTER events)
                # and __osViInit once among its unnamed callees.
                unk = [t for _, t in jals_of(cand) if t not in found.values()]
                twice = {t for t in unk if unk.count(t) == 2}
                once = [t for t in set(unk) if unk.count(t) == 1]
                if len(twice) == 1:
                    claim("osSetEventMesg", twice.pop(), "topology")
                vi_init = [t for t in once if any(b == 0xA440 for b, o, s in func_mmio[t])]
                if len(vi_init) == 1:
                    claim("__osViInit", vi_init[0], "topology")
            elif "__osPiRawStartDma" in found and found["__osPiRawStartDma"] in entry_tg:
                claim("__osDevMgrMain", entry, "thread-entry")
                claim("osCreatePiManager", cand, "topology")
    # ---- Pass 7: non-sibling SDK topology (debugged interactively against SM64's
    # launch-era libultra; every claim carries a structural verification).
    def callers_of(t):
        return [st for st in starts if t in {x for _, x in jals_of(st)}]

    def li_consts(st):
        return {w & 0xFFFF for w in body_words(st)
                if ((w >> 26) == 0x09 or (w >> 26) == 0x0D) and ((w >> 21) & 0x1F) == 0}

    # osPiStartDma: the unique osJamMesg caller (PI high-priority routing is unique
    # to it); verified by osSendMesg + osPiGetCmdQueue in the same body.
    if "osJamMesg" in found and "osPiStartDma" not in found:
        c = [st for st in callers_of(found["osJamMesg"]) if st not in found.values()]
        c = [st for st in c if found.get("osSendMesg") in {t for _, t in jals_of(st)}]
        if len(c) == 1:
            claim("osPiStartDma", c[0], "jammesg-topology")
    # Manager creators: callers of osCreateThread+osStartThread; thread entry = the
    # a2 constant (osCreateThread arg 3) before the jal.
    def entry_arg_of(cand):
        bw = body_words(cand)
        ct = found.get("osCreateThread")
        ci = next((k for k, w in enumerate(bw) if (w >> 26) == 3 and (0x80000000 | ((w & 0x03FFFFFF) << 2)) == ct), None)
        if ci is None:
            return None
        hi = lo = None
        for w in bw[max(0, ci - 12):ci + 2]:
            if (w >> 26) == 0x0F and ((w >> 16) & 0x1F) == 6:
                hi = (w & 0xFFFF) << 16
            if (w >> 26) == 0x09 and ((w >> 16) & 0x1F) == 6 and ((w >> 21) & 0x1F) == 6:
                lo = w & 0xFFFF
        if hi is None:
            return None
        e = hi + ((lo - 0x10000) if lo and lo >= 0x8000 else (lo or 0))
        return e if region_of(e)[0] is not None else None

    # NOTE (2026-06-20): a cross-vendor osCreateThread/osStartThread detector (topology + OSThread context-
    # offset {0x118,0x11C,0x12C} signature) was prototyped here and REVERTED. The context-offset signature is
    # SHARED by the thread-INIT writer (osCreateThread, stores the caller's ENTRY arg -> PC offset 0x11C) AND
    # the context-SAVE routines (yield/block/dispatch, store `ra` -> 0x11C), so on Blast Corps it uniquely but
    # WRONGLY matched a save routine (verified: 0x80221588 does `sw ra,0x11C(a1)`). Distinguishing them needs
    # data-flow (the 0x11C store's source = an ARG reg vs ra). The rmon-noise exclusion above DID land (general).
    # Verified design data + the careful next approach: [[project_libultra_matching_topology]].

    if "osCreateThread" in found and "osStartThread" in found:
        ct, sth = found["osCreateThread"], found["osStartThread"]
        for cand in starts:
            tg = {t for _, t in jals_of(cand)}
            if not ({ct, sth} <= tg) or cand in found.values():
                continue
            entry = entry_arg_of(cand)
            if entry is None:
                continue
            etg = {t for _, t in jals_of(entry)}
            if "__osViSwapContext" in found and found["__osViSwapContext"] in etg:
                claim("viMgrMain", entry, "thread-entry")
                claim("osCreateViManager", cand, "topology")
                unk = [t for _, t in jals_of(cand) if t not in found.values()]
                # the callee jal'd twice = osSetEventMesg (VI + COUNTER events);
                # the once-callee whose body touches VI MMIO = __osViInit
                # the creator body may overrun into viMgrMain (not a jal target), so
                # twice-counting can pick up viMgrMain's callees — require the
                # Disable/Restore critical section osSetEventMesg always has.
                twice = {t for t in unk if unk.count(t) == 2
                         and found.get("__osDisableInt") in {x for _, x in jals_of(t)}}
                if len(twice) == 1:
                    claim("osSetEventMesg", twice.pop(), "vi-event-topology")
                once = [t for t in set(unk) if unk.count(t) == 1
                        and any(b == 0xA440 for b, o, s in func_mmio[t])]
                if len(once) == 1:
                    claim("__osViInit", once[0], "vi-init-topology")
                # __osViGetCurrentContext: viMgrMain's tiny callee (lui;lw;jr shape)
                tiny = [t for t in etg if t not in found.values() and len(body_words(t)) <= 5
                        and any((w >> 26) == 0x23 for w in body_words(t))]
                if len(tiny) == 1:
                    claim("__osViGetCurrentContext", tiny[0], "vi-ctx-topology")
            elif "__osPiCreateAccessQueue" in found and found["__osPiCreateAccessQueue"] in tg:
                claim("__osDevMgrMain", entry, "thread-entry")
                claim("osCreatePiManager", cand, "topology")
    # osUnmapTLBAll: the unnamed tlbwi function with a backward branch (the 31-entry
    # wipe loop); osInitialize = its unique caller (verified to contain COP0 ops).
    if "osUnmapTLBAll" not in found:
        cands = []
        for site in find_word_sites(0x42000002):
            st = func_start_of(site)
            if st is None or st in found.values():
                continue
            bw = body_words(st)
            has_loop = any((w >> 26) in (4, 5, 1, 0x14, 0x15) and (w & 0x8000) for w in bw)  # backward bcc incl. likely forms
            if has_loop and len(bw) <= 24:
                cands.append(st)
        if len(set(cands)) == 1:
            claim("osUnmapTLBAll", cands[0], "tlbwi-loop")
    # osInitialize: the unique caller of osMapTLBRdb that also performs the SR/FpcCsr
    # setup (SM64's osUnmapTLBAll callers turned out to be GAME code — its engine
    # manages TLBs itself, served by the faithful LLE TLB).
    if "osMapTLBRdb" in found and "osInitialize" not in found:
        c = [st for st in callers_of(found["osMapTLBRdb"]) if st not in found.values()]
        c = [st for st in c if found.get("__osSetSR") in {t for _, t in jals_of(st)}
             and found.get("__osSetFpcCsr") in {t for _, t in jals_of(st)}]
        if len(c) == 1:
            claim("osInitialize", c[0], "rdb-init-topology")
    # SI transaction family. PIF command bytes identify the packers, packers
    # identify their owners: cmd 5/tx 10 = eeprom write; cmd 4/rx 8 = eeprom read;
    # cmd 1/rx 4 = controller read-data.
    if "__osSiGetAccess" in found and "__osSiRawStartDma" in found:
        si_dma = found["__osSiRawStartDma"]
        ga = found["__osSiGetAccess"]
        eep_status = None
        trans = [st for st in callers_of(ga) if st not in found.values()]
        ids = {}
        for st in trans:
            helpers = [t for _, t in jals_of(st) if t not in found.values() and t != st]
            consts = set()
            for h in helpers:
                consts |= li_consts(h)
            does_dma = si_dma in {t for _, t in jals_of(st)}
            if does_dma and {0x5, 0xA} <= consts:
                ids[st] = "osEepromWrite"
            elif does_dma and {0x4, 0x8} <= consts:
                ids[st] = "osEepromRead"
            elif does_dma and 0x1 in consts and 0x4 in consts:
                ids[st] = "osContStartReadData"
            elif not does_dma:
                # [2026-09-02] osPfsInitPak ALSO takes SI access without a direct DMA (its DMA sits in
                # __osPfsGetStatus); this rule labelled it osEepromProbe in 29 corpus trees, and since
                # osEepromProbe is HLE'd the cart's pak init vanished and the engine's EEPROM probe
                # answered 1 = PFS_ERR_NOPACK ("no pak" / "malfunction" with zero pak traffic: Doom 64,
                # ISS64 verified by disassembly). Discriminate by the prologue: osEepromProbe(mq) saves
                # at most $a0; osPfsInitPak(mq, pfs, channel) saves $a0..$a2 to the frame.
                # [2026-09-06] osEepromProbe was a FALLBACK label and three more victim shapes landed on it in the
                # sweep: osPfsInitPak with its args MOVED (`addu $sN,$aN,$zero` -- mkmyth, bottom9) rather than
                # saved, and osCartRomInit -- no args, builds the static OSPiHandle with baseAddress = 0xB0000000
                # (an `lui rX,0xB000` in its body; Chameleon Twist 2 #92, Super Smash Bros #96, Pokemon Snap
                # #112, Army Men Sarge's Heroes 1/2). A wrong osEepromProbe binding runs the engine's EEPROM probe
                # in place of the cart-ROM init -> zero cart DMA -> a dead boot. Census tool: census_eepromprobe.py.
                bw = body_words(st)
                arg_saves = sum(1 for w in bw[:12]
                                if (w >> 26) == 0x2B and ((w >> 21) & 0x1F) == 29 and ((w >> 16) & 0x1F) in (4, 5, 6, 7))
                arg_saves += sum(1 for w in bw[:16]
                                 if (w >> 26) == 0 and (w & 0x3F) == 0x21 and ((w >> 21) & 0x1F) in (5, 6, 7) and ((w >> 16) & 0x1F) == 0)
                cart = any((w & 0xFFE0FFFF) == 0x3C00B000 for w in bw[:48])   # lui rX, 0xB000 (rt is bits 16..20)
                ids[st] = "osCartRomInit" if cart else ("osPfsInitPak" if arg_saves >= 2 else "osEepromProbe")
        for st, name in ids.items():
            claim(name, st, "pif-cmd-topology")
        # osContGetReadData: contreaddata.c module order — the next jal-target
        # after osContStartReadData, before its packer helper.
        if "osContStartReadData" in found:
            srd = found["osContStartReadData"]
            k = _b.bisect_right(starts, srd)
            if k < len(starts) and starts[k] - srd <= 0x200:
                claim("osContGetReadData", starts[k], "module-order")
        # osContInit: the SiRawStartDma caller that also creates the Si access queue
        if "__osSiCreateAccessQueue" in found:
            c = [st for st in callers_of(si_dma)
                 if found["__osSiCreateAccessQueue"] in {t for _, t in jals_of(st)}
                 and st not in found.values()]
            if len(c) == 1:
                claim("osContInit", c[0], "si-init-topology")
    # __osPiRawStartDma: never jal'd (the PI manager calls it via function pointer).
    # It is the jr-ra-delimited unit after __osPiRelAccess that writes PI_DRAM_ADDR
    # and PI_CART_ADDR.
    if "__osPiRawStartDma" not in found and "__osPiRelAccess" in found:
        base, words = region_of(found["__osPiRelAccess"])
        wi = (found["__osPiRelAccess"] - base) // 4
        end = next((i for i in range(wi, wi + 0x40) if words[i] == JR_RA), None)
        if end is not None:
            cand = base + (end + 2) * 4  # skip jr + delay slot
            regbase = {}
            ok_writes = set()
            for w in words[(cand - base) // 4:(cand - base) // 4 + 0x40]:
                op = w >> 26
                if op == 0x0F:
                    if (w & 0xFFFF) == 0xA460:
                        regbase[(w >> 16) & 0x1F] = 0xA460
                    else:
                        regbase.pop((w >> 16) & 0x1F, None)
                elif op == 0x2B and ((w >> 21) & 0x1F) in regbase:
                    ok_writes.add(w & 0xFFFF)
                if w == JR_RA and ok_writes:
                    break
            if {0, 4} <= ok_writes:
                claim("__osPiRawStartDma", cand, "pi-dma-unit")

    # osDestroyThread: the unique unnamed caller of BOTH __osDequeueThread and
    # __osDispatchThread (the link-time scorecard found it: its recompiled body
    # was the only referencer of those two kernel-asm names; librecomp
    # reimplements osDestroyThread, so naming it deletes the body entirely).
    if all(n in found for n in ("__osDequeueThread", "__osDispatchThread")) and "osDestroyThread" not in found:
        dq, dp = found["__osDequeueThread"], found["__osDispatchThread"]
        c = [st for st in starts if {dq, dp} <= {t for _, t in jals_of(st)} and st not in found.values()]
        if len(c) == 1:
            claim("osDestroyThread", c[0], "thread-kernel-topology")

    # osSetIntMask: the remaining small function that both reads and writes C0_SR
    # (Disable/Restore are already named and excluded by uniqueness).
    if "osSetIntMask" not in found:
        c = []
        for st in starts:
            if st in found.values():
                continue
            bw = body_words(st)
            if len(bw) > 32:
                continue
            has_mfc0_sr = any((w & 0xFFE0FFFF) == 0x40006000 for w in bw)
            has_mtc0_sr = any((w & 0xFFE0FFFF) == 0x40806000 for w in bw)
            if has_mfc0_sr and has_mtc0_sr:
                c.append(st)
        if len(c) == 1:
            claim("osSetIntMask", c[0], "sr-rw-shape")

    # __osException: target of the 16-byte exception vector stub (lui k0/addiu k0/jr k0),
    # which lives in the loaded image and is bcopy'd to 0x80000180 at boot. Scan the
    # FULL resident span (region rom_start..rom_end), not a hardcoded SM64 window.
    res_rom_start, _res_vram, _res_words = regions[0]
    res_span_bytes = len(_res_words) * 4
    rom_words = struct.unpack(f">{res_span_bytes // 4}I", rom[res_rom_start:res_rom_start + res_span_bytes])
    for i in range(len(rom_words) - 2):
        w0, w1, w2 = rom_words[i:i + 3]
        if (w0 >> 16) == 0x3C1A and (w1 >> 16) == 0x275A and w2 == 0x03400008:
            tgt = ((w0 & 0xFFFF) << 16) + ((w1 & 0xFFFF) - 0x10000 if (w1 & 0xFFFF) >= 0x8000 else (w1 & 0xFFFF))
            if region_of(tgt)[0] is not None:
                claim("__osException", tgt, "vector-stub")
                break
    # osUnmapTLBAll: the smallest function containing tlbwi (0x42000002)
    tlbwi_funcs = sorted({func_start_of(s) for s in find_word_sites(0x42000002) if func_start_of(s)})
    tlbwi_funcs = [f for f in tlbwi_funcs if f not in found.values()]
    if tlbwi_funcs:
        smallest = min(tlbwi_funcs, key=lambda f: len(body_words(f)))
        if len(body_words(smallest)) <= 16:
            claim("osUnmapTLBAll", smallest, "tlbwi")

    # ---- Pass 7.5: MESSAGE-QUEUE / EVENT FAMILY structural detectors (Lever B, 2026-06-21).
    # The portfolio mq=NULL wall: byte-sig + the CHAINED topology detectors miss osViSetEvent/
    # osSetEventMesg/osCreateMesgQueue on later-SDK carts (1999-2001) -> the engine HLE never
    # registers the VI retrace queue -> the game's frame loop never wakes -> black. These key ONLY
    # on SDK-INVARIANT structure (OSMesgQueue struct offsets, the COP0 Disable/Restore anchors, the
    # event*8 table index), verified byte-IDENTICAL across SM64(1996 launch) and SDK 2.0I(1998).
    # Uniqueness-gated via unique_func_with: ambiguous -> skipped (a miss only degrades, never corrupts).
    def _stores(st):   # (rt, base_rs, offset, is_halfword) for every sw/sh in the body
        out = []
        for w in body_words(st):
            op = w >> 26
            if op in (0x2B, 0x29):
                out.append(((w >> 16) & 31, (w >> 21) & 31, w & 0xFFFF, op == 0x29))
        return out
    def _calls(st, name):
        return name in found and found[name] in {t for _, t in jals_of(st)}
    import os as _os
    _mdbg = _os.environ.get("MATCH_DEBUG")
    def _claim_unique(name, pred, why):
        cands = [st for st in starts if pred(st)]
        if _mdbg:
            print(f"  [DBG] {name}: {len(cands)} candidate(s): {[hex(c) for c in cands[:10]]}")
        claim(name, cands[0] if len(cands) == 1 else None, why)

    # osCreateMesgQueue: LEAF (no jal) writing the fixed OSMesgQueue layout
    #   sw $zero,8($a0); sw $zero,12($a0); sw $a2,16($a0); sw $a1,20($a0)   (a0=4, a1=5, a2=6)
    def _is_create_mq(st):
        if any((w >> 26) == 3 for w in body_words(st)):   # must be a leaf
            return False
        s = _stores(st)
        return (0,4,8,False) in s and (0,4,12,False) in s and (6,4,16,False) in s and (5,4,20,False) in s
    _claim_unique("osCreateMesgQueue", _is_create_mq, "mq-struct-init")

    if all(n in found for n in ("__osDisableInt", "__osRestoreInt")):
        # osSetEventMesg: Disable/Restore-wrapped; indexes __osEventStateTab by event*8
        #   (sll _,_,3 ; addu ; sw a1,0(idx) ; sw a2,4(idx)).
        def _is_set_event(st):
            if not (_calls(st, "__osDisableInt") and _calls(st, "__osRestoreInt")):
                return False
            bw = body_words(st)
            if len(bw) > 32:                       # osSetEventMesg is ~28 words; timer funcs are larger
                return False
            has_sll3 = any((w >> 26) == 0 and (w & 0x3F) == 0 and ((w >> 6) & 31) == 3 and w != 0 for w in bw)
            offs = {o for _, _, o, hw in _stores(st) if not hw}
            return has_sll3 and 0 in offs and 4 in offs
        _claim_unique("osSetEventMesg", _is_set_event, "event-table-index")

        # osViSetEvent: Disable/Restore-wrapped; stores the u16 retrace count via `sh` — the only
        # Disable/Restore-wrapped libultra fn that does a halfword store.
        def _is_vi_set_event(st):
            if not (_calls(st, "__osDisableInt") and _calls(st, "__osRestoreInt")):
                return False
            if len(body_words(st)) > 32:                           # osViSetEvent is ~28 words
                return False
            s = _stores(st)
            has_sh2 = any(hw and o == 2 for _, _, o, hw in s)      # the u16 retrace count -> 2(ctx)
            offs = {o for _, _, o, hw in s if not hw}
            return has_sh2 and 16 in offs and 20 in offs           # queue ptr -> 16, msg -> 20
        _claim_unique("osViSetEvent", _is_vi_set_event, "vi-event-halfword")

    print(f"matched total: {len(found)}")
    print(f"unresolved ambiguous (last reference): {len(ambiguous)}")
    for name, hs in ambiguous.items():
        print(f"  AMBIG {name}: {[hex(h) for h in hs]}")
    unmatched = [n for n in targets if n not in found and n not in ambiguous]
    print(f"NO-HIT (not matched by any reference / not linked by this game): {len(unmatched)}")
    for n in unmatched:
        print(f"  MISS {n}")

    # ---- Pass 8: POINTER-DISPATCH CENSUS (game-wide, boot #2 root cause). OPT-IN.
    # Functions called ONLY via function pointers are invisible to the jal census,
    # get no splat symbol, and are never recompiled — the runtime then no-ops them
    # via the gfgap net. Sweep the WHOLE ROM for big-endian words that point into a
    # code range, gated by:
    #   (a) PROLOGUE at the target (addiu $sp,$sp,-N), and
    #   (b) TERMINATOR before the target (jr/j + delay, or nop padding) — the S34
    #       rule, so a real function can never be split by a false positive.
    # GENERIC CAVEAT: the original SM64 build hardcoded three CODE_RANGES (main /
    # audio / goddard) at SM64-specific vrams. For an arbitrary game we do NOT know
    # the overlay layout, so census CODE_RANGES = the SINGLE passed resident region.
    # That is the only range we can trust here; a wrong wider range could split real
    # functions and corrupt the symbol table — hence Pass 8 is OFF unless --census.
    if args.census:
        CODE_RANGES = list(GAME_REGIONS)  # (rom_start, rom_end, vram), one per loaded module
        def code_rom_of(vaddr):
            for a, b, v in CODE_RANGES:
                if v <= vaddr < v + (b - a):
                    return a + (vaddr - v)
            return None

        def rom_word(off):
            return int.from_bytes(rom[off:off+4], "big")

        def is_terminator(wd):
            return ((wd >> 26) == 0 and (wd & 0x3F) == 8) or (wd >> 26) == 2  # jr / j

        jal_targets_all = set()
        for a, b, v in CODE_RANGES:
            n = (b - a) // 4
            ws = struct.unpack(f">{n}I", rom[a:a + n * 4])
            for x in ws:
                if (x >> 26) == 3:
                    jal_targets_all.add(0x80000000 | ((x & 0x03FFFFFF) << 2))

        census = set()
        nrom = len(rom) // 4
        for off in range(0, nrom * 4, 4):
            v = rom_word(off)
            if (v & 3) or not (0x80000000 <= v < 0x80400000):
                continue
            rt = code_rom_of(v)
            if rt is None or v in jal_targets_all or v in found.values():
                continue
            tw = rom_word(rt)
            if not ((tw >> 16) == 0x27BD and (tw & 0x8000)):   # prologue gate
                continue
            if rt < 8:
                continue
            wm1, wm2 = rom_word(rt - 4), rom_word(rt - 8)
            wm3 = rom_word(rt - 12) if rt >= 12 else 0
            ok = is_terminator(wm2) or (wm1 == 0 and wm2 == 0) or (wm1 == 0 and is_terminator(wm3))
            if ok:
                census.add(v)
        for v in sorted(census):
            found[f"func_{v:08X}"] = v
        print(f"pass 8 (pointer-dispatch census): +{len(census)} function-pointer targets")
    else:
        print("pass 8 (pointer-dispatch census): SKIPPED (pass --census to enable)")

    # Final address dedupe (cross-reference residue): true twins within one reference are already
    # resolved by pass 3.6 (immediate-compare or twin-keep). A collision that SURVIVES to here means
    # two different references byte-claimed different names at one address — at most one attribution
    # is right and we cannot tell which (the refs are unloaded). A wrong name corrupts; a missed name
    # only degrades: DROP ALL, loudly. (Old behavior kept the alphabetical name — a coin flip.)
    by_addr = defaultdict(list)
    for n, v in found.items():
        by_addr[v].append(n)
    for v, names in by_addr.items():
        if len(names) > 1:
            for n in names:
                del found[n]
            print(f"  dedupe: DROPPED ALL of {sorted(names)} (cross-reference collision at {hex(v)})")

    # SKIP ignored-only kernel internals (__osDispatchThread/__osEnqueueThread/__osDequeueThread/
    # __osEnqueueAndYield/viMgrMain/__osViSwapContext/__osException/osYieldThread...). These are in
    # ignored_funcs but NOT reimplemented_funcs -> the engine has NO native, so naming them makes
    # N64Recomp suppress the body (ignored=true) AND emit no native -> any caller that wasn't itself
    # HLE-matched yields `unresolved external <name>_recomp` (the DK64 link wall). Leaving them UNNAMED
    # lets them recompile RAW with real bodies so their callers link; the HLE still delivers interrupts
    # through the REIMPLEMENTED set above them (osRecvMesg/osSetEventMesg/osViSetEvent/osCreateViManager).
    ignored_only = ignored - reimp

    # ================= THE HLE SURFACE MUST BE COHERENT, OR IT MUST NOT EXIST =================
    # A cart gets ALL of its OS from the engine or NONE of it. A PARTIAL surface deadlocks at the
    # seam, and the deadlock is structural, not a tuning problem:
    #
    #   A bound blocking primitive (osRecvMesg) parks a guest fiber INSIDE a native host call.
    #   The only things that can wake it are the HLE's own senders. If those were not matched, the
    #   cart's own kernel posts to ITS queues while the host receiver waits on a mailbox nobody
    #   fills -- and a fiber parked in a native callee has no legal interrupted pc, so the very
    #   interrupt that would break the tie is deferred forever.
    #
    # This was established BY HAND on World Cup 98 (2026-09-04, memory: baremetal_all_or_nothing)
    # and never taught to the blind path, so every self-hosted cart it built carried the fault.
    # MEASURED 2026-09-09, the named surface of trees whose behaviour is known:
    #
    #   castlevania 61 · donkeykong64 55 · supermario64 48 · robotron 45   ALL of the set below -> PLAY
    #   Turok 2 JP 20 · Turok 3 18        osRecvMesg bound, NONE of its wakers -> WEDGE at the
    #                                     first blocking receive (HANDLER=0, no interrupt ever taken)
    #   Turok 1 · Turok 2 · Rage Wars 0   whole OS handed to the guest -> PLAY
    #
    # So the test is not a threshold on the count; it is whether the surface can function.
    HLE_BLOCKING  = {"osRecvMesg", "osJamMesg"}          # park a fiber inside a native call
    HLE_WAKERS    = {"osSendMesg", "osSetEventMesg"}     # the only things that can release it
    HLE_BOOTSTRAP = {"osCreateThread", "osStartThread"}  # without these the guest owns the threads
    matched_names = {n for n in found if not n.startswith("func_")}
    if matched_names & HLE_BLOCKING:
        missing = sorted((HLE_WAKERS | HLE_BOOTSTRAP) - matched_names)
        if missing:
            os_named = sorted(n for n in matched_names if re.match(r"^_*os[A-Za-z0-9_]+$", n))
            print("  INCOHERENT HLE SURFACE: a blocking primitive is matched but %s %s missing."
                  % (", ".join(missing), "is" if len(missing) == 1 else "are"))
            print("  -> handing the WHOLE OS to the cart: dropping %d os*/__os* name(s) to func_*."
                  % len(os_named))
            for n in os_named:
                found["func_%08X" % found[n]] = found[n]
                del found[n]

    emit = [(n, v) for n, v in found.items() if n not in ignored_only or n.startswith("func_")]
    skipped = sorted(n for n in found if n in ignored_only and not n.startswith("func_"))
    # The entrypoint (resident base) is ALWAYS code: IPL3 DMAs the resident in and JUMPS to it.
    # splat sometimes emits the boot stub as data (D_<addr> / STT_OBJECT) -> N64Recomp's entrypoint
    # detection (which requires STT_FUNC at the entry, even its rom-0x1000 fallback) then fails with
    # "Could not find entrypoint function". Seed func_<entry> so splat types it STT_FUNC. General:
    # every cart's entry is a function at the resident base (== --vram here). Harmless when splat
    # already auto-detects it (same addr -> same function). Surfaced: Star Fox 64.
    entry_vram = GAME_REGIONS[0][2]   # the resident base: always the FIRST region
    if not any(v == entry_vram for _, v in emit):
        emit.append((f"func_{entry_vram:08X}", entry_vram))
    # ── UNION-MERGE: preserve curated entries match can't reproduce (NON-DESTRUCTIVE). ────────────
    # match owns the auto libultra surface; but bare-metal/PSX ports (nightmare/spaceinv/robotron)
    # carry HAND-IDENTIFIED game-specific names in symbol_addrs.txt (the scheduler PUBLIC API blind-
    # IDed by topology, prologue-scan funcs splat under-detected, etc.) that signature-matching will
    # NEVER find. Overwriting symbol_addrs.txt would DESTROY them -> the game regresses, OR the whole
    # pipeline can't run (you'd have to skip match). So: read the EXISTING symbol_addrs.txt first and
    # KEEP, verbatim, every entry at an address match did NOT emit (fresh match wins on conflicts).
    # General + idempotent (dedup by address; an unchanged ROM converges). Surfaced: Nightmare/SpaceInv.
    emit_addrs = {v for _, v in emit}
    emit_names = {n for n, _ in emit}
    preserved = []  # (addr, original_line)
    if os.path.exists(OUT):
        ent_re = re.compile(r'^\s*([A-Za-z_]\w*)\s*=\s*0x([0-9A-Fa-f]+)\s*;')
        seen_addr, seen_name = set(), set()
        for line in open(OUT, encoding="utf-8"):
            m = ent_re.match(line)
            if not m:
                continue
            nm = m.group(1)
            addr = int(m.group(2), 16)
            # Fresh match wins by BOTH address AND name. A stale curated entry that reuses a name
            # match just emitted (at a different addr) would otherwise duplicate -> splat aborts
            # "Duplicate symbol". Drop it. (Surfaced: GoldenEye osEepromProbe stale @0x80013810 vs
            # fresh @0x80014FD0.) Also dedup the preserved set itself by addr+name.
            if addr in emit_addrs or nm in emit_names or addr in seen_addr or nm in seen_name:
                continue
            seen_addr.add(addr)
            seen_name.add(nm)
            preserved.append((addr, line.rstrip("\n")))
    with open(OUT, "w", newline="\n", encoding="utf-8") as f:
        f.write("// generated by recompilator/tools/match_libultra.py -- libultra surface\n")
        f.write("// identified by masked byte signature against CV64's named ELF.\n")
        f.write("// (ignored-only kernel internals are skipped -> recompiled raw; see tool source.)\n")
        for name, vram in sorted(emit, key=lambda kv: kv[1]):
            f.write(f"{name} = 0x{vram:08X}; // type:func\n")
        if preserved:
            f.write("// --- preserved curated entries (union-merged; not reproduced by match) ---\n")
            for _, line in sorted(preserved):
                f.write(line + "\n")
    print(f"wrote {len(emit)} entries to {OUT}  (+ {len(preserved)} curated preserved)"
          f"  (skipped {len(skipped)} ignored-only: {', '.join(skipped)})")


if __name__ == "__main__":
    main()
