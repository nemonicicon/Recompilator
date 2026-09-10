#!/usr/bin/env python3
"""blind_bringup.py - BRING UP A CARTRIDGE NOBODY HAS EVER SEEN, from the cart's own bytes.

    py -3 recompilator/tools/blind_bringup.py --rom "<any .z64/.n64/.v64/.zip>" [--root <N64PC>]

This is the last piece of the Recompilator loop. A release ships the engine and the pipeline and
NOTHING about any particular game (2026-09-07: no game ships with the program, and
nothing depends on a decompilation). So when a user's ROM matches no catalog
entry - which in a release it never can - the program has to work out what the cartridge is BY
READING IT, and build a playable program from it, on their machine. That is this file.

NOTHING HERE IS PER-GAME. Every value is read out of the cart: the entrypoint and the internal name
from the ROM header, the CIC family from the IPL3 CRC, the libultra surface by byte-signature match,
the code/data segmentation by the recompiler's and the compiler's own complaints. The two optional
dictionaries a lab caller can pass in (gp override, force-data seed) are its own, never this file's.

THE PHASES, and a failure names the one it stopped in:

    IDENTITY      the ROM header + IPL3 CRC + SHA-1 + XXH3: id, title, entrypoint, CIC, resident base
    TREE          the tree is authored: baserom, macro.inc, the libultra symbol match, the splat yaml
                  (disassemble_all) and the pinned linker script
    BYTE-EXACT    tools/build_elf.py rebuilds the ROM from the ELF and the bytes must match EXACTLY.
                  A cart that cannot reach this stops HERE, loudly, with the reason - never a silent
                  half-build.
    APP           scaffold_app.py renders <id>pc from the templates (no reference tree needed)
    SEGMENTATION  tools/segment_refine.py drives code-vs-data to convergence, with the bundled
                  toolchain for the ELF and the bundled clang for the compiler - no docker, no
                  Visual Studio, nothing installed.

Machine output (one per line, for a driver to parse or a human to read):

    [blind] <phase> ...            progress
    BRINGUP OK <id> <title>        the tree and the app exist and the segmentation converged
    BRINGUP FAIL <phase> <reason>  and the exit code is 1

sweep_game.py imports author_tree()/resident_base()/identify() from here so the lab and the shipped
program run the SAME code; this file is the single copy.
"""

import argparse
import hashlib
import os
import re
import shutil
import struct
import subprocess
import sys
import zipfile
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import code_window
import detached_segments
import find_ucode

# A CARTRIDGE TITLE CAN CONTAIN ANY CHARACTER, AND PRINTING IT MUST NEVER KILL THE TOOL.
# Python picks the console codepage for stdout on Windows (cp1252 here), so the moment a
# Japanese title reached a print() this whole bring-up died with UnicodeEncodeError
# (2026-09-07, Saikyou Habu Shougi). Say it in UTF-8 and replace what cannot be shown;
# files are written with an explicit encoding elsewhere and are unaffected.
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

HERE = Path(__file__).resolve().parent               # recompilator/tools
RECOMPILATOR = HERE.parent                           # recompilator
DEFAULT_ROOT = RECOMPILATOR.parent                   # N64PC

CIC_CRC = {  # crc32 of the IPL3 bootcode 0x40..0x1000 -> CIC family
    0x6170A4A1: "6101", 0x90BB6CB5: "6102", 0x0B050EE0: "6103",
    0x98BC2C86: "6105", 0xACC8580A: "6106",
}


# --------------------------------------------------------------------- plumbing --

def say(msg):
    print(msg, flush=True)


class BringupError(Exception):
    def __init__(self, phase, reason):
        super().__init__(reason)
        self.phase = phase
        self.reason = reason


def run(argv, cwd=None, timeout=7200):
    """Run a child and return (rc, combined text). Never raises on a non-zero rc."""
    p = subprocess.run([str(x) for x in argv], cwd=cwd, stdout=subprocess.PIPE,
                       stderr=subprocess.STDOUT, timeout=timeout)
    return p.returncode, p.stdout.decode("utf-8", "replace")


def to_z64(data: bytes) -> bytes:
    """Any byte order -> big-endian z64, by the magic word at offset 0 (never by the file name)."""
    if len(data) < 4:
        return data
    m = tuple(data[:4])
    if m == (0x80, 0x37, 0x12, 0x40):
        return data
    if m == (0x37, 0x80, 0x40, 0x12):          # v64: byte pairs swapped
        b = bytearray(data)
        b[0::2], b[1::2] = data[1::2], data[0::2]
        return bytes(b)
    if m == (0x40, 0x12, 0x37, 0x80):          # n64: little-endian words
        b = bytearray(len(data))
        for i in range(0, len(data) - 3, 4):
            b[i:i + 4] = data[i:i + 4][::-1]
        return bytes(b)
    return data


def read_rom(path: Path):
    """Return (z64 bytes, member name). A .zip is opened and its first N64 image taken."""
    if path.suffix.lower() == ".zip":
        with zipfile.ZipFile(path) as z:
            for n in z.namelist():
                if n.lower().endswith((".z64", ".n64", ".v64")):
                    return to_z64(z.read(n)), os.path.basename(n)
        raise BringupError("IDENTITY", "no N64 image inside %s" % path.name)
    return to_z64(path.read_bytes()), path.name


def xxh3_64(data: bytes):
    """The app's rom_hash, as librecomp computes it. The bundled toolchain carries the xxhash
    package; without it a blind bring-up cannot author a correct app, so this is a hard failure
    rather than a silently wrong constant."""
    try:
        import xxhash
    except Exception:
        raise BringupError("IDENTITY",
                           "no xxhash module in %s - the toolchain must carry it (the app's ROM hash "
                           "is XXH3-64 and cannot be guessed)" % sys.executable)
    return "0x%016X" % xxhash.xxh3_64_intdigest(data)


def yaml_scalar(text: str) -> str:
    """A cartridge's own name, safe to write as a QUOTED yaml scalar.

    The split file's first line is `name: <the cart's internal name>`, written raw. A cart whose
    name contains a colon then breaks the yaml parser on line 1: "Turok 2: Seeds of Ev" dies with
    `mapping values are not allowed in this context` at column 14, which is its second colon, and
    the blind path fails at BYTE-EXACT ELF before it has done anything (2026-09-09). Turok 3 and
    every other colon-carrying title fail the same way, so this is a general blind-path defect and
    not one game's problem.

    Quoting is the fix; escaping the two characters a double-quoted yaml scalar cares about is what
    makes the quoting safe for any name a cart can carry.
    """
    return (text or "").replace("\\", "\\\\").replace('"', '\\"')


def sanitize_id(text: str) -> str:
    """A game id is a directory name AND a C++ identifier (namespace, function prefix), so it is
    letters and digits only, lowercase, never digit-leading."""
    s = re.sub(r"[^a-z0-9]", "", (text or "").lower())
    if not s:
        return ""
    if s[0].isdigit():
        s = "g" + s
    return s[:18]


# --------------------------------------------------------------------- identity --

def resident_base(entry: int, cic: str, override: str = None) -> int:
    """WHERE IPL3 PUTS THE FIRST MEGABYTE, from the header entry and the CIC family alone.

    6101/6102: no bias, the resident base IS the header entry.
    6103/7103: the header boot address is inflated by +0x100000 as an anti-backup trick.
    6106/7106: the same trick, +0x200000.
    6105:      entry-coupled like 6102 (the 2026-09-06 Conker/Perfect Dark correction).
    """
    if override:
        return int(override, 16) & 0xFFFFFFFF
    fam = (cic or "").replace("CIC-", "").split("/")[0]
    if fam in ("6103", "7103"):
        return (entry - 0x100000) & 0xFFFFFFFF
    if fam in ("6106", "7106"):
        return (entry - 0x200000) & 0xFFFFFFFF
    return entry & 0xFFFFFFFF


def _decode_name(raw: bytes) -> str:
    """The cartridge title, in whatever encoding the cart used (ascii, then Shift-JIS, then latin1)."""
    raw = raw.split(b"\x00")[0]
    for enc in ("ascii", "cp932", "latin1"):
        try:
            return raw.decode(enc).strip()
        except UnicodeDecodeError:
            continue
    return raw.decode("latin1", "replace").strip()


def identify(rom: bytes, file_stem: str = "") -> dict:
    """Everything the pipeline needs about a cart, read out of the cart."""
    import zlib
    if rom[:4] != b"\x80\x37\x12\x40":
        raise BringupError("IDENTITY", "not an N64 ROM (magic %s after byte-order normalisation)"
                           % rom[:4].hex())
    entry = struct.unpack(">I", rom[0x08:0x0C])[0]
    # ascii -> cp932 -> latin1, the same rule as recon.py / tools/rom_identity.py: a Japanese cart
    # writes its title in Shift-JIS and latin1 alone turns it into mojibake that then travels into
    # the yaml name, the tree, the module descriptor and the library row (2026-09-07).
    internal = _decode_name(rom[0x20:0x34])
    serial = rom[0x3B:0x3F].decode("ascii", "replace").strip()
    cic = CIC_CRC.get(zlib.crc32(rom[0x40:0x1000]) & 0xFFFFFFFF, "unknown")
    sha1 = hashlib.sha1(rom).hexdigest()
    gid = sanitize_id(internal) or sanitize_id(serial) or ("cart" + sha1[:8])
    title = internal if internal else (file_stem or gid)
    return {
        "id": gid, "title": title, "internal_name": internal, "serial": serial,
        "entrypoint": entry, "cic": cic, "sha1": sha1, "size": len(rom),
        "xxh3_64": xxh3_64(rom), "resident_base": resident_base(entry, cic),
    }


def unique_id(root: Path, gid: str, sha1: str) -> str:
    """A second cart that names itself the same thing as one already on disk (a revision, a
    prototype) gets its own tree rather than overwriting one. Decided by the ROM's SHA-1."""
    # LOOK WHERE THE TREES ACTUALLY ARE. This checked <root>/<game> only, which is where games
    # lived before 2026-09-07; tree_dir() has written them to <root>/archive/<game> ever since. So
    # the check inspected an empty path, declared the name free, and the build landed ON TOP of the
    # cart already holding it. MEASURED 2026-09-08: the Japanese Turok 1 (sha1 726baefd) overwrote
    # the US cart (40fb0250) - same internal name, same slot, and the US build was simply gone.
    # Consult BOTH locations, exactly as tree_dir resolves them.
    def _sha1_of(path):
        h = hashlib.sha1()
        with open(path, "rb") as f:
            for chunk in iter(lambda: f.read(1 << 20), b""):
                h.update(chunk)
        return h.hexdigest()

    cand = gid
    n = 1
    while True:
        occupied = False
        for tree in (root / cand, root / ARCHIVE / cand):
            if not tree.exists():
                continue
            occupied = True
            rom = tree / "baserom.z64"
            if rom.is_file() and _sha1_of(rom) == sha1:
                return cand          # the same cart: reuse its tree
        if not occupied:
            return cand
        n += 1
        cand = "%s%d" % (gid, n)


# ------------------------------------------------------------------------ tree --

FULL_YAML = """name: "{title_yaml}"
sha1: {sha1}
options:
  basename: {game}
  target_path: baserom.z64
  base_path: .
  build_path: build
  asm_path: asm
  src_path: src
  asset_path: assets
  ld_script_path: build/{game}.ld
  compiler: IDO
  platform: n64
  undefined_funcs_auto_path: build/undefined_funcs_auto.txt
  undefined_syms_auto_path: build/undefined_syms_auto.txt
  symbol_addrs_path: symbol_addrs.txt
  find_file_boundaries: false
  # THE INTERNAL NAME IS NOT ALWAYS ASCII (Saikyou Habu Shougi (Japan), 2026-09-07 07:29):
  # splat's header segment decodes bytes 0x20..0x34 with header_encoding (default ASCII) and dies on
  # a Japanese title - 'ascii codec can't decode byte 0xbb' - before the split even starts. Decoding
  # as shift-jis instead would ASSEMBLE the name back as UTF-8 and break byte-exactness, so emit the
  # name as raw WORDS: byte-exact by construction and blind to the cart's language. Every region's
  # cartridge takes the same path; nothing is lost but a comment in the generated assembly.
  header_encoding: word
  use_legacy_include_asm: false
  disassemble_all: true
  mips_abi_float_regs: numeric
segments:
  - name: header
    type: header
    start: 0x0
  - name: ipl3
    type: bin
    start: 0x40
  - name: main
    type: code
    start: 0x1000
    vram: {ep}
    subsegments:
      - [0x1000, asm, main]
{extra_segments}  - name: assets
    type: bin
    start: 0x{assets_start:X}
  - [0x{rom_end:X}]
"""

PINNED_LD = """SECTIONS
{{
    _gp = 0x{gp:08X};
    .header 0x00000000 : AT(0x00000000) {{ FILL(0x00000000); build/asm/header.s.o(.data); }}
    .ipl3 0x00000040 : AT(0x00000040) {{ FILL(0x00000000); build/assets/ipl3.bin.o(.data); }}
    .main {ep} : AT(0x00001000) {{ FILL(0x00000000); build/asm/main.s.o(.text); build/asm/main.s.o(.rodata); build/asm/main.s.o(.data); }}
    .main_bss (NOLOAD) : {{ build/asm/main.s.o(.bss); }}
{extra_sections}    .assets {abase} : AT(0x{assets_at:08X}) {{ FILL(0x00000000); build/assets/assets.bin.o(.data); }}
    /DISCARD/ : {{ *(*); }}
}}
"""


ARCHIVE = "archive"     # every game the user builds lives under <root>/archive/

def tree_dir(root: Path, game: str) -> Path:
    """<root>/archive/<game>. Games used to be created loose in the root, which turned a
    release folder into a pile of per-game directories (2026-09-07: added games belong
    in a folder named archive, not loose in the program's directory). A tree ALREADY at the old location keeps being used where it is, so nothing
    built before this moves or breaks."""
    old = root / game
    if old.is_dir() and (old / (game + ".yaml")).is_file():
        return old
    return root / ARCHIVE / game


def app_dir(root: Path, game: str) -> Path:
    """The <game>pc tree, beside its front end."""
    return tree_dir(root, game).parent / (game + "pc")


def macro_inc_source(root: Path) -> Path:
    """The assembler macro header every splat tree needs. It is our own file, shipped as a template."""
    c = RECOMPILATOR / "templates" / "tree" / "macro.inc"
    if c.is_file():
        return c
    raise BringupError("TREE", "no macro.inc template (recompilator/templates/tree/macro.inc)")


def author_tree(root: Path, game: str, rom_bytes: bytes, title: str, sha1: str,
                resident_ep: int, python=None, gp: int = 0, force_data=None):
    """Write the whole splat front end for one cart. Everything below is derived from the cart or
    is the same for every cart; there is no game name in any decision.

    Returns the number of libultra functions the byte-signature matcher named."""
    py = python or sys.executable
    fe = tree_dir(root, game)
    if fe.exists():
        shutil.rmtree(fe, ignore_errors=True)
    (fe / "tools").mkdir(parents=True, exist_ok=True)
    (fe / "include").mkdir(parents=True, exist_ok=True)
    (fe / "baserom.z64").write_bytes(rom_bytes)
    shutil.copyfile(macro_inc_source(root), fe / "include" / "macro.inc")
    (fe / "undefined_syms_manual.ld").write_text(
        "/* manual undefined-symbol PROVIDEs (filled as the link surfaces them). */\n",
        encoding="utf-8", newline="\n")

    ep = "0x%08X" % resident_ep

    # DETACHED MODULES, FIRST - before anything downstream assumes an address.
    # A cartridge's code is not always one contiguous run: a second module is loaded past the
    # first module's .bss, hundreds of kilobytes further on. Declared as one segment it is still
    # recompiled, just filed under addresses that do not exist in the running game, so every call
    # the cart makes to the real address finds nothing (Castlevania renders black, Mario runs at
    # 0 fps - both had been fixed by hand, per game). detached_segments.detect finds them from the
    # cart's own call targets. This runs before the libultra match because a module can BE the
    # library: Mario's audio library is the detached one.
    # A MAPPED CODE WINDOW MOVES THE MODULE INTO THE USER SEGMENT (tools/code_window.py).
    # The cart programs one TLB entry in its boot stub and runs its body from there; without this
    # every function is filed 0x80000000 too high, at an address the game never jumps to.
    # Read the windows FIRST: they are also the corroboration the detector needs. Its margin test
    # refuses a candidate that does not beat its runner-up fourfold, which is right for a guess but
    # wrong when the cart's own TLB entry already names the address - Turok 2 rev 1 scored 1.90 and
    # was refused, building a 460 KB module where the 1.0 cart built 9.06 MB from the same code.
    windows = code_window.find_windows(rom_bytes)
    for base, size in windows:
        say("[blind] TREE  boot stub maps a code window at 0x%08X, %d KB" % (base, size // 1024))

    def in_window(va):
        phys = va & 0x1FFFFFFF
        return any(base <= phys < base + size for base, size in windows)

    mods = detached_segments.detect(rom_bytes, 0x1000, 0x101000, resident_ep,
                                    log=lambda m: say("[blind] TREE  " + m),
                                    trusted=in_window if windows else None)
    for base, size in windows:
        for m in mods:
            phys = m["vram"] & 0x1FFFFFFF
            if base <= phys < base + size and m["vram"] != phys:
                say("[blind] TREE  module 0x%08X runs from the window -> 0x%08X" % (m["vram"], phys))
                m["vram"] = phys

    (fe / "_modules.txt").write_text(
        "".join("0x%X 0x%X 0x%08X" % (m["rom"], m["rom_end"], m["vram"]) + chr(10) for m in mods),
        encoding="utf-8", newline=chr(10))
    assets_start = max([0x101000] + [m["rom_end"] for m in mods])
    regions = [(0x1000, mods[0]["rom"] if mods else assets_start, resident_ep)]
    for i, m in enumerate(mods):
        regions.append((m["rom"], mods[i + 1]["rom"] if i + 1 < len(mods) else assets_start,
                        m["vram"]))

    # THE LIBULTRA SURFACE, by masked byte-signature against the named references. Without it
    # N64Recomp recompiles the scheduler and the interrupt path raw instead of binding them to the
    # engine's HLE, and the game spins on MI_INTR_MASK.
    (fe / "symbol_addrs.txt").write_text("", encoding="utf-8")
    # THE SIGNATURE DATABASE IS WHAT MAKES THIS WORK OFF THIS MACHINE. match_libultra's
    # reference ELFs live at absolute paths in the lab and are never shipped, so on a user's
    # machine they simply are not there: the matcher names nothing, N64Recomp recompiles the
    # scheduler and the interrupt path raw instead of binding them to the engine, and the game
    # spins. recompilator/data/libultra_sigdb.json carries the same knowledge in ~1 MB and
    # produces byte-identical output (verified 2026-09-07). Use it when it is there; fall back
    # to the references when it is not, so the lab keeps working if the file is ever missing.
    sigdb = HERE.parent / "data" / "libultra_sigdb.json"
    match_cmd = [py, HERE / "match_libultra.py", "--rom", fe / "baserom.z64",
                 "--out", fe / "symbol_addrs.txt"]
    for rs, re_, rv in regions:
        match_cmd += ["--region", "0x%X:0x%X:0x%08X" % (rs, re_, rv)]
    if sigdb.exists():
        match_cmd += ["--sigdb", sigdb]
    rc, out = run(match_cmd)
    nlib = (fe / "symbol_addrs.txt").read_text(encoding="utf-8", errors="replace").count("type:func")
    if nlib == 0:
        say("[blind] TREE  WARNING: the libultra matcher named 0 functions "
            "(last line: %s)" % (out.strip().splitlines()[-1] if out.strip() else "no output"))

    # The runtime->static loop: a PRIOR run of this app may have left a gap report naming code the
    # static pass missed. No-op on a first build, which a blind cart always is.
    appdata = os.environ.get("APPDATA", "")
    if appdata:
        for gr in (Path(appdata) / ("%spc" % game) / "saves" / "gap_report.json",
                   Path(appdata) / ("%spc" % game) / "gap_report.json"):
            if gr.exists():
                run([py, HERE / "gap_reingest.py", "--gap-report", gr,
                     "--syms", fe / "symbol_addrs.txt", "--apply"])
                break

    (fe / ("%s_stubs.txt" % game)).write_text("", encoding="utf-8")
    (fe / ("%s_overlays.txt" % game)).write_text("", encoding="utf-8")
    if force_data:
        (fe / "_force_data.txt").write_text(
            "\n".join("0x%08X" % x for x in force_data) + "\n", encoding="utf-8")

    rom_end = len(rom_bytes)

    # Each detached module is its OWN top-level splat segment and its own linker section, so the
    # byte-exact ELF, the toml, the recompiler and the game module all carry the right addresses
    # from the first pass. The names match what a hand-authored entry used (mod2, mod3, ...).
    seg_txt, ld_txt = "", ""
    for i, m in enumerate(mods):
        nm = "mod%d" % (i + 2)
        seg_txt += ("  - name: %s" % nm + chr(10) + "    type: code" + chr(10)
                    + "    start: 0x%X" % m["rom"] + chr(10)
                    + "    vram: 0x%08X" % m["vram"] + chr(10)
                    + "    subsegments:" + chr(10)
                    + "      - [0x%X, asm, %s]" % (m["rom"], nm) + chr(10))
        ld_txt += ("    .%s 0x%08X : AT(0x%08X) { FILL(0x00000000); build/asm/%s.s.o(.text); "
                   "build/asm/%s.s.o(.rodata); build/asm/%s.s.o(.data); }"
                   % (nm, m["vram"], m["rom"], nm, nm, nm) + chr(10)
                   + "    .%s_bss (NOLOAD) : { build/asm/%s.s.o(.bss); }" % (nm, nm) + chr(10))

    (fe / ("%s.yaml" % game)).write_text(
        FULL_YAML.format(title=title, title_yaml=yaml_scalar(title), sha1=sha1, game=game, ep=ep, rom_end=rom_end,
                         extra_segments=seg_txt, assets_start=assets_start),
        encoding="utf-8", newline="\n")
    if gp:
        (fe / "gp_override.txt").write_text("0x%08X\n" % gp, encoding="utf-8")
    abase = "0x%08X" % ((resident_ep + 0x400000) & 0xFFFFFFFF)
    (fe / ("%s_pinned.ld" % game)).write_text(
        PINNED_LD.format(gp=gp, ep=ep, abase=abase, extra_sections=ld_txt,
                         assets_at=assets_start),
        encoding="utf-8", newline="\n")
    return nlib


# ------------------------------------------------------------------ toolchain --

def resolve_toolchain(explicit, root: Path):
    cands = []
    if explicit:
        cands.append(Path(explicit))
    if os.environ.get("RECOMPILATOR_TOOLCHAIN"):
        cands.append(Path(os.environ["RECOMPILATOR_TOOLCHAIN"]))
    cands += [root / "_toolchain", root / "toolchain", RECOMPILATOR.parent / "toolchain"]
    for c in cands:
        if (c / "mips" / "bin" / "mips64-elf-as.exe").is_file() and (c / "python" / "python.exe").is_file():
            return c
    return None


# ---------------------------------------------------------------------- main --

def bringup(args):
    root = Path(args.root).resolve() if args.root else DEFAULT_ROOT
    rom_path = Path(args.rom).resolve()
    if not rom_path.is_file():
        raise BringupError("IDENTITY", "no ROM at %s" % rom_path)

    # ---- IDENTITY -----------------------------------------------------------------
    rom, member = read_rom(rom_path)
    info = identify(rom, rom_path.stem)
    gid = sanitize_id(args.id) if args.id else unique_id(root, info["id"], info["sha1"])
    title = args.title or info["title"]
    ep = int(args.entry, 16) if args.entry else info["resident_base"]
    info["id"] = gid
    info["title"] = title
    info["resident_base"] = ep
    say("[blind] IDENTITY  id=%s title=%r internal=%r serial=%s size=%d" %
        (gid, title, info["internal_name"], info["serial"], info["size"]))
    say("[blind] IDENTITY  entry=0x%08X cic=%s -> resident base 0x%08X   sha1=%s xxh3=%s" %
        (info["entrypoint"], info["cic"], ep, info["sha1"], info["xxh3_64"]))
    if not (0x80000000 <= ep < 0x80800000):
        raise BringupError("IDENTITY", "resident base 0x%08X is outside RDRAM (entry 0x%08X, CIC %s)"
                           % (ep, info["entrypoint"], info["cic"]))

    tc = resolve_toolchain(args.toolchain, root)
    py = str(tc / "python" / "python.exe") if tc else sys.executable
    recomp = None
    for c in ((tc / "n64recomp" / "N64Recomp.exe") if tc else None,
              root / "engine" / "runtime" / "N64Recomp" / "build_cli" / "Release" / "N64Recomp.exe"):
        if c and Path(c).is_file():
            recomp = Path(c)
            break
    if recomp is None:
        raise BringupError("TREE", "no N64Recomp.exe (looked in the toolchain and engine/runtime)")
    say("[blind] IDENTITY  toolchain=%s  python=%s  recomp=%s" % (tc or "(none)", py, recomp))

    # ---- TREE ---------------------------------------------------------------------
    nlib = author_tree(root, gid, rom, title, info["sha1"], ep, python=py)
    say("[blind] TREE      authored %s/ from the cart; libultra match named %d function(s)" % (gid, nlib))
    if args.stop_after == "tree":
        return info

    # ---- BYTE-EXACT ---------------------------------------------------------------
    elf_mode = args.elf_mode
    if elf_mode == "auto":
        elf_mode = "native" if tc else "docker"
    say("[blind] BYTE-EXACT  rebuilding the ROM from the ELF (%s)" % elf_mode)
    if elf_mode == "native":
        rc, out = run([py, "-I", HERE / "build_elf.py", gid, "--root", root] +
                      (["--toolchain", str(tc)] if tc else []))
    else:
        rc, out = run(["docker", "run", "--rm", "--entrypoint", "sh", "-v",
                       "%s:/rb" % root.as_posix(), "cv64-build", "-c",
                       "sh /rb/recompilator/build_elf.sh %s" % gid])
    verdict = ""
    for line in out.splitlines():
        if "BYTE-EXACT: ELF-reconstructed ROM matches" in line:
            verdict = line.strip()
    if not verdict:
        why = ""
        for line in out.splitlines():
            if re.search(r"FATAL|LINK FAILED|GAS-GIVEUP|MISMATCH|Traceback|not byte-exact", line):
                why = line.strip()
                break
        if not why:
            why = "%s exit %d; no BYTE-EXACT line" % (elf_mode, rc)
        (root / "_sweep" / "dispatch").mkdir(parents=True, exist_ok=True)
        (root / "_sweep" / "dispatch" / ("blind_%s_elf.log" % gid)).write_text(out, encoding="utf-8",
                                                                              errors="replace")
        raise BringupError("BYTE-EXACT", why)
    say("[blind] BYTE-EXACT  %s" % verdict)

    # the all-functions template the segmentation loop refines from
    rc, out = run([py, RECOMPILATOR / "gen_toml.py", gid], cwd=root)
    fe = tree_dir(root, gid)
    if not (fe / ("%s.toml" % gid)).is_file():
        raise BringupError("BYTE-EXACT", "gen_toml.py produced no %s.toml (exit %d)" % (gid, rc))
    shutil.copyfile(fe / ("%s.yaml" % gid), fe / ("%s_full.yaml" % gid))
    shutil.copyfile(fe / ("%s.toml" % gid), fe / ("%s_full.toml" % gid))
    say("[blind] BYTE-EXACT  all-functions template saved (%s_full.yaml/.toml)" % gid)
    if args.stop_after == "elf":
        return info

    # ---- APP ----------------------------------------------------------------------
    rc, out = run([py, RECOMPILATOR / "scaffold_app.py", "--game", gid, "--title", title,
                   "--internal", info["internal_name"] or title, "--hash", info["xxh3_64"],
                   "--entrypoint", "0x%08X" % ep, "--sha1", info["sha1"],
                   "--save-type", args.save_type, "--force",
                   "--out", app_dir(root, gid)], cwd=root)
    if not (app_dir(root, gid) / "src" / "main.cpp").is_file():
        raise BringupError("APP", "scaffold_app.py produced no %spc/src/main.cpp: %s"
                           % (gid, (out.strip().splitlines() or ["no output"])[-1][:160]))
    say("[blind] APP       %spc scaffolded (save type %s)" % (gid, args.save_type))

    # ---- RSP MICROCODE ------------------------------------------------------------
    # THE CART'S OWN AUDIO MICROCODE, recompiled here from the cart. One implementation,
    # find_ucode.emit(), shared with the recipe path in build_entry.ps1 - it was written here
    # first and not there, and a recipe with no microcode config then linked against nothing
    # and died on `undefined symbol: aspMain` (2026-09-07).
    rspx = None
    for cand in ((tc / "n64recomp" / "RSPRecomp.exe") if tc else None,
                 root / "engine" / "runtime" / "N64Recomp" / "build" / "Release" / "RSPRecomp.exe"):
        if cand and Path(cand).is_file():
            rspx = str(cand)
            break
    note = find_ucode.emit(str(fe / "baserom.z64"), str(fe), str(app_dir(root, gid)), rspx,
                           log=lambda m: say("[blind] RSP       " + m))
    say("[blind] RSP       " + note)

    if args.stop_after == "app":
        return info

    # ---- SEGMENTATION -------------------------------------------------------------
    build_mode = args.build_mode
    if build_mode == "auto":
        build_mode = "module" if (tc and (tc / "clang" / "bin" / "clang.exe").is_file()) else "none"
    say("[blind] SEGMENT   code-vs-data refinement (elf %s, compiler %s, max %d rounds)"
        % (elf_mode, build_mode, args.max))
    argv = [py, HERE / "segment_refine.py", "--basename", gid, "--fe-dir", fe,
            "--app", "%spc" % gid, "--app-dir", app_dir(root, gid), "--full-yaml", fe / ("%s_full.yaml" % gid),
            "--full-toml", fe / ("%s_full.toml" % gid), "--recomp", recomp,
            "--entrypoint", "0x%08X" % ep, "--vram", "0x%08X" % ep,
            "--max", str(args.max), "--cap", str(args.cap),
            "--elf-mode", elf_mode, "--build-mode", build_mode, "--root", root,
            "--python", py, "--jobs", str(args.jobs)]
    if tc:
        argv += ["--toolchain", tc]
    p = subprocess.Popen([str(x) for x in argv], stdout=subprocess.PIPE,
                         stderr=subprocess.STDOUT, text=True, bufsize=1, errors="replace")
    tail = []
    for line in p.stdout:
        line = line.rstrip("\n")
        tail.append(line)
        if line.startswith("[refine]"):
            say("[blind] SEGMENT   " + line[len("[refine] "):])
    p.wait()
    ok = any(l.startswith("[refine]") and ("LINKED" in l or "CONVERGED" in l) for l in tail)
    if not ok:
        why = ""
        for l in reversed(tail):
            if l.startswith("[refine]"):
                why = l[len("[refine] "):]
                break
        raise BringupError("SEGMENTATION", why or ("segment_refine exit %d" % p.returncode))

    # ---- LIBRARY ------------------------------------------------------------------
    # REGISTER THE GAME, or the work is invisible and the user builds it again.
    # The launcher's library is exactly the entry.json files under <root>/recompilator/catalog:
    # it finds the module, the exe and the cart by convention from the game id, but a game with
    # no entry.json is not in the library at all. Nothing wrote one after a build, so every
    # launch showed an empty library and every cartridge had to be added and built afresh -
    # Army Men Sarge's Heroes was built twice for that reason (2026-09-07). Writing it here
    # covers BOTH paths, because the launcher's ADD ROM runs this same file.
    try:
        import json
        # THE ENTRY LIVES WITH THE GAME, in archive/<game>/, not in the shipped catalog.
        # recompilator/catalog is replaced wholesale by every export, so an entry written
        # there is thrown away the next time the program is refreshed - which is exactly how
        # the library kept getting lost. archive/ is the user's, and is preserved.
        cat = tree_dir(root, gid)
        cat.mkdir(parents=True, exist_ok=True)
        entry = {
            "game": gid,
            "rom": {"sha1": info["sha1"], "xxh3_64": info["xxh3_64"],
                    "entrypoint": "0x%08X" % info["entrypoint"]},
            # "LOCAL" is the launcher's word for an entry built HERE rather than swept in the lab;
            # state_label_for turns it into BUILT. Anything else it does not recognise reads as
            # NOT REACHED, which would be a lying label on a game sitting there built.
            "sweep": {"title": title, "sweep": "LOCAL", "verdict": "LOCAL",
                      "verdict_line": "Built from the cartridge on this machine."},
            # This entry was made by a build here, from a cart the user owns. It is NOT part of
            # what the project publishes, and export_release holds it back on this key.
            "origin": "blind",
            "built_by": "recompilator/tools/blind_bringup.py",
        }
        (cat / "entry.json").write_text(json.dumps(entry, indent=2), encoding="utf-8")
        say("[blind] LIBRARY   registered %s in the library (%s)" % (title, cat / "entry.json"))
    except Exception as e:
        say("[blind] LIBRARY   WARNING: could not register the game (%s) - it will build but not "
            "appear in the library" % e)
    return info


def main():
    ap = argparse.ArgumentParser(description="Bring up an unknown N64 cartridge from its own bytes.")
    ap.add_argument("--rom", required=True)
    ap.add_argument("--root", default="")
    ap.add_argument("--id", default="", help="override the id derived from the cart's internal name")
    ap.add_argument("--title", default="", help="override the display title")
    ap.add_argument("--entry", default="", help="override the resident base (hex)")
    # SAVE HARDWARE: ALLOW IT ALL RATHER THAN GUESS AT IT.
    # This defaulted to "None", and nothing ever set it, so EVERY blind-built cart shipped with no
    # save device at all. Pilotwings boots to its own "EEPROM CHECK FAILED" screen because of it,
    # and 269 of the 322 authored trees declare some kind of EEPROM - so "None" is wrong for the
    # large majority of the corpus, not an edge case.
    # The size cannot be derived from the cart: match_libultra names osEepromProbe/osEepromRead AND
    # osEepromLongRead on Pilotwings, whose authored tree is Eep4k, so the presence of the 16k API
    # says nothing (libultra links the whole module either way). AllowAll is the runtime's own
    # answer to exactly this - game.hpp: "Allows all save types to work and reports eeprom size as
    # 16kbit" - so a cart gets working save hardware without anyone guessing which kind.
    ap.add_argument("--save-type", default="AllowAll", help="recomp::SaveType value for the app")
    ap.add_argument("--toolchain", default="")
    ap.add_argument("--elf-mode", choices=("auto", "native", "docker"), default="auto")
    ap.add_argument("--build-mode", choices=("auto", "module", "none", "msbuild"), default="auto")
    ap.add_argument("--max", type=int, default=20)
    ap.add_argument("--cap", type=int, default=40)
    ap.add_argument("--jobs", type=int, default=8)
    ap.add_argument("--stop-after", choices=("", "tree", "elf", "app"), default="")
    a = ap.parse_args()
    try:
        info = bringup(a)
    except BringupError as e:
        print("BRINGUP FAIL %s %s" % (e.phase, e.reason), flush=True)
        return 1
    except Exception as e:                       # a crash is a failure with a name, never a hang
        print("BRINGUP FAIL INTERNAL %s: %s" % (type(e).__name__, e), flush=True)
        return 1
    print("BRINGUP OK %s %s" % (info["id"], info["title"]), flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
