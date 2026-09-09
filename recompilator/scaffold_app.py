#!/usr/bin/env python3
"""
scaffold_app.py — generate a <game>pc/ application directory for THE RECOMPILATOR.

This replaces the old ritual of "clone a named sibling game's app dir and sed it".
The generated app links the ONE agnostic engine at ../engine (rt64 + runtime); it
never references another game.

  CMakeLists.txt + src/main.cpp   -> rendered from recompilator/templates/gamepc/*.tmpl
  src/{audio,input,rsp,rt64_renderer}.* + src/patches/*  -> copied from a reference
       app (default: waveracepc) with the game-token renamed so the symbol contract
       with main.cpp holds (main.cpp calls <game>_audio_init / <ns>::renderer::...).

  NOT copied: build/, RecompiledFuncs/ (produced by the recomp stage), .git, *.map,
       *.sln/*.vcxproj, *_overlays.txt. rsp/aspMain.cpp is NOT copied: the pipeline
       ucode is a starting point; replace per game).

Usage:
  python scaffold_app.py --game spaceinv --title "Space Invaders 64" \
      --internal "SPACE INVADERS" --hash 0xE1C49BA5F7D4FEE0 --entrypoint 0x80200050 \
      --sha1 <sha1> --save-type Eep4k [--pfx SI] [--ns spaceinv] [--ref waveracepc]

Idempotency: refuses to overwrite an existing non-empty out dir unless --force.
"""
import sys
import argparse, os, re, shutil, sys
from pathlib import Path

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

HERE = Path(__file__).resolve().parent
N64PC = HERE.parent
TPL = HERE / "templates" / "gamepc"

# Support files copied verbatim-with-rename from the reference app.
SUPPORT = [
    "src/audio.cpp", "src/input.cpp", "src/rsp.cpp",
    "src/rt64_renderer.cpp", "src/rt64_renderer.hpp",
    "src/patches/os_stubs.c", "src/patches/math_patches.c", "src/patches/engine_shims.c",
]
# rsp/aspMain.cpp is NOT here any more (2026-09-07). Copying one reference tree's recompiled
# audio microcode into every game was right by luck for carts carrying the stock SDK revision
# and silently WRONG for the rest - Army Men Sarge's Heroes played with no sound - and it
# shipped 138 KB of cartridge-derived C in both published artifacts. blind_bringup now finds
# the cart's OWN microcode (tools/find_ucode.py) and recompiles it on the user's machine.
OPTIONAL = ["rsp/f3dex2.cpp"]


def detect_ref_token(ref_dir: Path) -> str:
    """The reference app's lowercase game token, from its CMake project() name minus 'pc'."""
    cml = (ref_dir / "CMakeLists.txt").read_text(encoding="utf-8", errors="replace")
    m = re.search(r"project\((\w+?)pc\b", cml)
    if not m:
        sys.exit(f"ERROR: cannot detect the reference game token in {ref_dir}/CMakeLists.txt")
    return m.group(1)


def render(tmpl_text: str, subs: dict) -> str:
    out = tmpl_text
    for k, v in subs.items():
        out = out.replace("{{" + k + "}}", v)
    leftover = re.findall(r"\{\{(\w+)\}\}", out)
    if leftover:
        sys.exit(f"ERROR: unfilled template placeholders: {sorted(set(leftover))}")
    return out


# App-local game tokens that may bleed into a reference app from its clone ancestry
# (every app descends by clone, so e.g. waveracepc still carries pilotwings comments).
# Scrub them to the new game's token so a generated app never names another game.
# DELIBERATELY EXCLUDES 'cv64'/'sm64'/'lod': 'g_cv64_present_fps' is an ENGINE global
# shared verbatim between main.cpp and rt64_renderer.cpp (scrubbing it breaks the link),
# and 'lod' collides with the graphics term level-of-detail.
ANCESTRY_TOKENS = ["waverace", "pilotwings", "robotron", "spaceinv", "nightmare"]


def rename_tokens(text: str, ref: str, game: str) -> str:
    """Rename the reference game's token (and any app-local ancestry tokens) to the new
    game's, in all three cases, so namespaces/symbol-prefixes/log-tags/comments migrate.
    Hardware names (SP_WR_LEN) and the engine path '../engine' carry no game token."""
    for t in dict.fromkeys([ref] + ANCESTRY_TOKENS):  # ref first, dedup, preserve order
        text = text.replace(t, game)
        text = text.replace(t.upper(), game.upper())
        text = text.replace(t.capitalize(), game.capitalize())
    return text


# The reference app's rt64_renderer.cpp descends from cv64 and carries cv64's renderer
# POLICY: it unconditionally sets enhancementConfig.f3dex.forceBranch = true with the
# comment "Same F3DEX2 GBI as CV64". That hardcode is only correct for the F3DEX2
# microcode family cv64 runs; the sweep library spans F3DEX/S2DEX/Factor-5/Rare custom
# ucodes, and forcing an F3DEX2 LOD branch on those mis-routes the display list (a
# suspected "boot to 60fps black screen" cause). The engine now AUTO-GATES this config
# to the detected ucode (engine/rt64 RSP::forceBranchEnabled), so even if the line is
# left in it is inert on non-F3DEX2 games — but a freshly scaffolded app should not bake
# in another game's renderer policy or its misleading comment. De-flavor on copy.
_F3DEX_FORCEBRANCH_RE = re.compile(
    r"[ \t]*//[^\n]*\n[ \t]*\w*->enhancementConfig\.f3dex\.forceBranch\s*=\s*true\s*;[^\n]*\n")


def deflavor_renderer(text: str) -> str:
    """Strip cv64's hardcoded f3dex.forceBranch override (+ its comment) from a copied
    rt64_renderer.cpp and replace it with a neutral note. The engine default is false
    and it is auto-gated to F3DEX2 anyway, so a new game starts ucode-agnostic. F3DEX2
    games (incl. cv64 itself, which keeps its OWN unmodified rt64_renderer.cpp) are
    unaffected: the engine still honors the global flag when it is set for them."""
    note = ("    // NOTE: enhancementConfig.f3dex.forceBranch intentionally left at the\n"
            "    // engine default (false). The engine gates that enhancement to the F3DEX2\n"
            "    // microcode family at runtime; do NOT hardcode it true here for a\n"
            "    // non-F3DEX2 game — it would mis-route display-list branches. Set it only\n"
            "    // if this game's recon confirms an F3DEX2-family ucode AND wants the LOD\n"
            "    // branch enhancement.\n")
    new_text, n = _F3DEX_FORCEBRANCH_RE.subn(note, text)
    return new_text


# ══════════════════════════════════════════════════════════════════════════════════════════════
#  THE GAME MODULE FACE  (module/module_main.cpp)
#
#  The product is ONE program: Recompilator.exe is the host and a game is a <game>.dll built by
#  the bundled clang from the emitted C, the recompiled RSP microcode and this one face
#  (recompilator/include/recomp_module.h).  Until 2026-09-07 that face was written BY HAND for
#  cv64blind, which is exactly the per-game code this project keeps deleting.
#
#  EVERY value below is READ OUT OF THE TREE (src/main.cpp, src/rsp.cpp, src/patches/, the
#  RecompiledFuncs* sets) or out of recompilator/catalog/<game>/entry.json.  There is NO table of
#  per-game constants in this file, and nothing is taken from another game.  Each derivation
#  records where it read the value; `--module` prints the provenance line by line.
# ══════════════════════════════════════════════════════════════════════════════════════════════

_LINE_COMMENT_RE = re.compile(r"//[^\n]*")
_BLOCK_COMMENT_RE = re.compile(r"/\*.*?\*/", re.S)


def strip_cxx_comments(text: str) -> str:
    """Blank out C/C++ comments (keeping newlines) so a regex cannot match commented-out code.
    String literals in this corpus never contain '//' or '/*', so a plain strip is safe here and
    a wrong strip would only ever LOSE a match, never invent one."""
    text = _BLOCK_COMMENT_RE.sub(lambda m: "\n" * m.group(0).count("\n"), text)
    return _LINE_COMMENT_RE.sub("", text)


class Provenance:
    """Every module substitution, with the file it was read from. Printed, and put in the report."""

    def __init__(self):
        self.rows = []

    def add(self, field, value, source):
        self.rows.append((field, value, source))
        return value

    def dump(self, prefix="[module]   "):
        for f, v, s in self.rows:
            shown = v if len(str(v)) <= 58 else str(v)[:55] + "..."
            print(f"{prefix}{f:<22} = {shown:<60} <- {s}")


def _need(pattern, text, what, where, flags=0):
    m = re.search(pattern, text, flags)
    if not m:
        sys.exit(f"ERROR: cannot read {what} out of {where} (pattern {pattern!r}). "
                 f"The module face is derived from the tree; fix the tree or extend "
                 f"scaffold_app.py's derivation — do NOT hand-write the module.")
    return m


def live_recomp_dirs(tree: Path):
    """The RecompiledFuncs sets this tree actually builds, in INCLUDE ORDER (a suffixed set such
    as RecompiledFuncsRAM shadows the plain one — the same order <game>pc/CMakeLists.txt uses).
    Backups (RecompiledFuncs.bak_*, .prev) carry a dot and are excluded by the name rule."""
    dirs = [d for d in sorted(tree.iterdir())
            if d.is_dir() and re.fullmatch(r"RecompiledFuncs[A-Za-z0-9]*", d.name)]
    dirs.sort(key=lambda d: (d.name == "RecompiledFuncs", d.name))
    return dirs


def derive_identity(tree: Path, game: str, prov: Provenance) -> dict:
    """Identity + the message-queue requeue policy, read out of <game>pc/src/main.cpp, and
    cross-checked against recompilator/catalog/<game>/entry.json when that exists."""
    main_cpp = tree / "src" / "main.cpp"
    if not main_cpp.is_file():
        sys.exit(f"ERROR: no {main_cpp} — the module face is derived from it")
    src = strip_cxx_comments(main_cpp.read_text(encoding="utf-8", errors="replace"))
    where = f"{tree.name}/src/main.cpp"

    m = _need(r"uint64_t\s+([A-Za-z_]\w*)_ROM_HASH\s*=\s*(0[xX][0-9A-Fa-f]+)ULL", src,
              "the ROM hash constant", where)
    pfx, hash_hex = m.group(1), m.group(2)
    ep = _need(r"uint32_t\s+" + re.escape(pfx) + r"_ENTRYPOINT_VRAM\s*=\s*(0[xX][0-9A-Fa-f]+)", src,
               "the entrypoint constant", where).group(1)
    internal = _need(r"entry\.internal_name\s*=\s*\"((?:[^\"\\]|\\.)*)\"", src,
                     "entry.internal_name", where).group(1)
    game_id = _need(r"entry\.game_id\s*=\s*u8\"([^\"]*)\"", src, "entry.game_id", where).group(1)
    mm = re.search(r"entry\.mod_game_id\s*=\s*\"([^\"]*)\"", src)
    mod_game_id = mm.group(1) if mm else ""
    save = _need(r"entry\.save_type\s*=\s*recomp::SaveType::(\w+)", src, "entry.save_type", where).group(1)
    # The window title used to end in " PC" and this pattern required it. When the template stopped
    # calling every game a PC port (2026-09-07: these are not PC ports), the
    # pattern stopped matching and EVERY BLIND BUILD died at segmentation with an empty error list -
    # a naming change silently breaking the pipeline an hour later. Accept the title with or without
    # the old suffix, and never let it be the reason a build fails again.
    title = _need(r"SDL_CreateWindow\(\s*\"(.*?)(?: PC)?\"", src, "the window title", where, re.S).group(1)

    prov.add("PFX", pfx, where + " (the *_ROM_HASH constant's name)")
    prov.add("HASH", hash_hex, where + f" ({pfx}_ROM_HASH)")
    prov.add("ENTRYPOINT", ep, where + f" ({pfx}_ENTRYPOINT_VRAM)")
    prov.add("INTERNAL", internal, where + " (entry.internal_name)")
    prov.add("GAMEID", game_id, where + " (entry.game_id)")
    prov.add("MODGAMEID", mod_game_id or "(empty)", where + " (entry.mod_game_id)")
    prov.add("SAVETYPE", save, where + " (entry.save_type)")
    prov.add("TITLE", title, where + " (SDL_CreateWindow)")

    requeue = {}
    for name, val in re.findall(r"\.requeue_(\w+)\s*=\s*(true|false)", src):
        requeue[name] = "1" if val == "true" else "0"
    for k in ("timer", "sp", "si", "ai", "vi", "pi", "dp"):
        if k not in requeue:
            sys.exit(f"ERROR: {where} declares no .requeue_{k} — cannot derive MessageQueueControl")
    prov.add("requeue_*", ",".join(f"{k}={requeue[k]}" for k in
                                   ("timer", "sp", "si", "ai", "vi", "pi", "dp")),
             where + " (cfg.message_queue_control)")

    identity_source = f"recon: ROM header + XXH3, read from {tree.name}/src/main.cpp"
    cat = N64PC / "recompilator" / "catalog" / game / "entry.json"
    if cat.is_file():
        import json
        j = json.loads(cat.read_text(encoding="utf-8"))
        rom = j.get("rom", {})
        c_hash, c_ep = str(rom.get("xxh3_64", "")), str(rom.get("entrypoint", ""))
        # THE ENTRY IS LOOKED UP BY GAME ID, SO IT MAY DESCRIBE A DIFFERENT DUMP OF THE SAME GAME.
        #
        # A recipe is selected by CART HASH, upstream, in the RECOGNISED stage. When no entry
        # carries the user's sha1 that stage says so and the cart is brought up BLIND - and the
        # blind path then names the tree after the game ("blastcorps"), which is exactly the name
        # a shipped recipe for some OTHER dump of that game already has. This cross-check found
        # that unrelated entry by name and killed the build.
        #
        # Blast Corps, 2026-09-08: the cart is sha1 483f7161, the shipped recipe is for
        # 185a6ef7, RECOGNISED had already printed "no catalog entry carries this sha1 -> BLIND
        # BRING-UP", and the build died at SEGMENTATION with "ROM hash disagrees ... Refusing to
        # guess" over a recipe nothing had chosen. He reported it as "no elf produced".
        #
        # main.cpp's identity is read by recon FROM THE USER'S OWN CART, so on a disagreement the
        # cart wins and the entry is simply about a different cartridge. Say so and ignore it.
        # Refusing to guess stays right for an entry that IS this cart: a mismatched entrypoint
        # there means the recipe and the recon disagree about the same bytes, which is a real
        # fault and must still stop.
        if c_hash and int(c_hash, 16) != int(hash_hex, 16):
            print(f"note: catalog/{game}/entry.json describes a different dump of this game "
                  f"({c_hash} vs this cart's {hash_hex}) - ignoring it; this cart's own identity "
                  f"is authoritative", file=sys.stderr)
        else:
            if c_ep and int(c_ep, 16) != int(ep, 16):
                sys.exit(f"ERROR: entrypoint disagrees — {where} says {ep}, "
                         f"catalog/{game}/entry.json says {c_ep}. Refusing to guess.")
            prov.add("(cross-check)", f"hash {c_hash} entry {c_ep}", f"recompilator/catalog/{game}/entry.json")
            identity_source = (f"recon: ROM header + XXH3, from {tree.name}/src/main.cpp, "
                               f"cross-checked against catalog/{game}/entry.json")

    _SAVE_ENUM = {
        "None": "RECOMP_MODULE_SAVE_NONE", "Eep4k": "RECOMP_MODULE_SAVE_EEP4K",
        "Eep16k": "RECOMP_MODULE_SAVE_EEP16K", "Sram": "RECOMP_MODULE_SAVE_SRAM",
        "Flashram": "RECOMP_MODULE_SAVE_FLASHRAM", "AllowAll": "RECOMP_MODULE_SAVE_ALLOW_ALL",
    }
    if save not in _SAVE_ENUM:
        sys.exit(f"ERROR: {where} names recomp::SaveType::{save}, which recomp_module.h has no value for")

    return {
        "PFX": pfx, "HASH": hash_hex, "ENTRYPOINT": ep, "INTERNAL": internal,
        "GAMEID": game_id, "MODGAMEID": mod_game_id, "TITLE": title,
        "SAVETYPE_ENUM": _SAVE_ENUM[save],
        "IDENTITY_SOURCE": identity_source,
        "REQUEUE_TIMER": requeue["timer"], "REQUEUE_SP": requeue["sp"],
        "REQUEUE_SI": requeue["si"], "REQUEUE_AI": requeue["ai"],
        "REQUEUE_VI": requeue["vi"], "REQUEUE_PI": requeue["pi"],
        "REQUEUE_DP": requeue["dp"],
    }


_WATCHDOG_WRAPPER = """
/* Same wrapper policy as the exe build: a watchdog bail must not fatal-exit the runtime —
 * degrade that task to silence. */
static RspExitReason {name}_logged(uint8_t* rdram, uint32_t ucode_addr) {{
    static int bail_logs = 0;
    RspExitReason result = {name}(rdram, ucode_addr);
    if (result != RspExitReason::Broke) {{
        if (bail_logs < 5) {{
            bail_logs++;
            fprintf(stderr, "[rsp] {name} returned result=%d -- converting to Broke\\n", (int)result);
            fflush(stderr);
        }}
        return RspExitReason::Broke;
    }}
    return result;
}}
"""


def derive_rsp(tree: Path, game: str, prov: Provenance) -> dict:
    """The RSP dispatch and the ucode catalog registry, read out of <game>pc/src/rsp.cpp — the
    DESKTOP tier of it (the console tier lives behind #ifdef RDPC_CAPTURE_CHAIN, which a module
    never defines, so its capture_gfx is the desktop no-op by construction)."""
    rsp_cpp = tree / "src" / "rsp.cpp"
    where = f"{tree.name}/src/rsp.cpp"
    if not rsp_cpp.is_file():
        sys.exit(f"ERROR: no {rsp_cpp} — the module's RSP dispatch is derived from it")
    src = strip_cxx_comments(rsp_cpp.read_text(encoding="utf-8", errors="replace"))

    # 1. the recompiled microcode artifacts this tree links (file-scope forward declarations)
    artifacts = re.findall(r"^\s*RspExitReason\s+(\w+)\s*\(\s*uint8_t\s*\*[^)]*\)\s*;",
                           src, re.M)
    artifacts = list(dict.fromkeys(artifacts))
    # 1b. DO NOT DECLARE A MICROCODE THIS TREE DOES NOT HAVE.
    #
    # src/rsp.cpp is copied in from the reference tree, and a lab-era one can name a recompiled
    # GRAPHICS microcode - Legend of the Dragoon's names f3dex2 - that the pipeline never builds.
    # Only the AUDIO microcode is found in the cart automatically (tools/find_ucode.py); nothing
    # produces rsp/f3dex2.cpp on a user's machine. The face was emitted anyway and the module died
    # at `undefined symbol: f3dex2` (the 09-08 playtest).
    #
    # Dropping it is not a loss: every other tree in the release resolves that slot to the no-op
    # stub and lets RT64 render F3DEX2 display lists natively, which is the HLE path the renderer
    # is built around. Keep only artifacts whose source is actually present.
    _rsp_dir = tree / "rsp"
    _missing = [a for a in artifacts if not (_rsp_dir / (a + ".cpp")).is_file()]
    if _missing:
        artifacts = [a for a in artifacts if a not in _missing]
        print("note: %s/src/rsp.cpp names %s, but rsp/%s.cpp is not in this tree - that task type "
              "falls back to the no-op stub and RT64 handles it (this is what every other tree does)"
              % (tree.name, ", ".join(_missing), _missing[0]), file=sys.stderr)

    # 2. the watchdog wrappers the tree wraps them in
    wrapped = [a for a in artifacts if re.search(r"static\s+RspExitReason\s+" + re.escape(a) + r"_logged\s*\(", src)]

    # 2b. the tree's own TRIVIAL no-op stubs. Every app names one, but not all name it the same
    # ('rsp_noop_stub' in most trees, 'aspMain_stub' in cv64pc), and a dispatch case may return it.
    # A stub is recognised by its BODY, not its name: `{ return RspExitReason::Broke; }` and
    # nothing else. Anything less trivial is refused below rather than silently re-created.
    stubs = [n for n in re.findall(
        r"static\s+RspExitReason\s+(\w+)\s*\([^)]*\)\s*\{\s*return\s+RspExitReason::Broke\s*;\s*\}", src)
        if n != "rsp_noop_stub"]
    stubs = list(dict.fromkeys(stubs))

    # 3. the task-type dispatch
    body = _need(r"RspUcodeFunc\*\s+\w*get_rsp_microcode\s*\([^)]*\)\s*\{(.*?)\n\}",
                 src, "get_rsp_microcode()", where, re.S).group(1)
    cases = re.findall(r"case\s+(\w+)\s*:\s*(?:[^;{}]*?)\breturn\s+(\w+)\s*;", body, re.S)
    default_fn = _need(r"default\s*:.*?\breturn\s+(\w+)\s*;", body,
                       "the default: return of get_rsp_microcode()", where, re.S).group(1)

    # a case that named a dropped artifact now resolves to the no-op stub
    if _missing:
        _drop = set(_missing) | {a + "_logged" for a in _missing}
        cases = [(t, ("rsp_noop_stub" if f in _drop else f)) for t, f in cases]
        if default_fn in _drop:
            default_fn = "rsp_noop_stub"
    known = set(artifacts) | {a + "_logged" for a in wrapped} | set(stubs) | {"rsp_noop_stub"}
    for _, fn in cases + [("default", default_fn)]:
        if fn not in known:
            sys.exit(f"ERROR: {where}'s dispatch returns '{fn}', which the module face cannot "
                     f"provide (it knows {sorted(known)}). Extend the derivation rather than "
                     f"hand-writing module_main.cpp.")

    # 4. the ucode catalog registry: register_ucode(hash, "name", fn[, off, len, fnv])
    ucodes = re.findall(
        r"register_ucode\(\s*(0[xX][0-9A-Fa-f]+)ull\s*,\s*\"([^\"]*)\"\s*,\s*(\w+)\s*"
        r"(?:,\s*(0[xX][0-9A-Fa-f]+)\s*,\s*(0[xX][0-9A-Fa-f]+)\s*,\s*(0[xX][0-9A-Fa-f]+)ull\s*)?\)",
        src, re.S)

    prov.add("RSP artifacts", ", ".join(artifacts) or "(none)", where + " (RspExitReason decls)")
    prov.add("RSP wrappers", ", ".join(a + "_logged" for a in wrapped) or "(none)", where)
    prov.add("RSP stubs", ", ".join(stubs) or "(none, beyond rsp_noop_stub)", where + " (trivial Broke stubs)")
    prov.add("RSP dispatch", "; ".join(f"{t}->{f}" for t, f in cases) + f"; default->{default_fn}",
             where + " (get_rsp_microcode)")
    prov.add("ucodes", ", ".join(u[1] for u in ucodes) or "(none)", where + " (register_ucode)")

    if artifacts:
        decls = "\n".join(
            f"RspExitReason {a}(uint8_t* rdram, uint32_t ucode_addr);"
            f"   /* rsp/{a}.cpp, in this module */" for a in artifacts)
    else:
        decls = ("/* This tree declares no recompiled RSP microcode artifact of its own: every task\n"
                 " * type below resolves to the no-op stub, which is what its exe does too. */")

    wrappers = "".join(
        f"\n/* The tree's own trivial no-op stub, by the name its dispatch uses "
        f"({tree.name}/src/rsp.cpp). */\n"
        f"static RspExitReason {s}(uint8_t* /*rdram*/, uint32_t /*ucode_addr*/) {{\n"
        f"    return RspExitReason::Broke;\n"
        f"}}\n" for s in stubs)
    wrappers += "".join(_WATCHDOG_WRAPPER.format(name=a) for a in wrapped)

    case_lines = "".join(
        f"    case {t}:\n        return (RecompModuleUcodeFunc){f};\n" for t, f in cases)

    if ucodes:
        rows = []
        for h, name, fn, off, ln, fnv in ucodes:
            if off:
                rows.append(f"    {{ {h}ull, \"{name}\", (RecompModuleUcodeFunc){fn},\n"
                            f"      {off}u, {ln}u, {fnv}ull }},")
            else:
                rows.append(f"    {{ {h}ull, \"{name}\", (RecompModuleUcodeFunc){fn}, 0u, 0u, 0ull }},")
        table = ("/* UCODE CATALOG REGISTRY (organ 3), from src/rsp.cpp's register_ucode call(s):\n"
                 " * content-hash dispatch, law v1 with the verify window where the tree gives one. */\n"
                 f"static const RecompModuleUcodeEntry {game}_ucodes[] = {{\n" +
                 "\n".join(rows) + "\n};\n")
        ucodes_field = f"{game}_ucodes"
        num_field = f"sizeof({game}_ucodes) / sizeof({game}_ucodes[0])"
    else:
        table = "/* No register_ucode() call in src/rsp.cpp: this cart registers no ucode by content hash. */\n"
        ucodes_field, num_field = "NULL", "0"

    return {
        "RSP_ARTIFACT_DECLS": decls, "RSP_WRAPPERS": wrappers,
        "RSP_DISPATCH_CASES": case_lines, "RSP_DEFAULT": default_fn,
        "UCODE_TABLE": table, "UCODES_FIELD": ucodes_field, "NUM_UCODES_FIELD": num_field,
    }


# librecomp's own default (engine/runtime/librecomp/src/default_gamestate_change.c) is a loud
# no-op; a tree whose only definition is the engine_shims.c copy is in exactly that case, and
# engine_shims.c is EXCLUDED from the module by build_module.ps1 (it exists only to satisfy the
# exe link). So the module carries its own loud no-op instead.
def derive_engine_debt(tree: Path, game: str, prov: Provenance) -> dict:
    """gamestate_change and the NI overlay-content catalog: the two CV64-shaped symbols the engine
    used to demand of every application. Both are read from the sources build_module.ps1 actually
    compiles into the module (src/patches/*.c minus engine_shims.c, plus src/ni_section_data.c)."""
    out = {}
    module_c = []
    patches = tree / "src" / "patches"
    if patches.is_dir():
        module_c += [p for p in sorted(patches.glob("*.c")) if p.name != "engine_shims.c"]
    ni_c = tree / "src" / "ni_section_data.c"
    if ni_c.is_file():
        module_c.append(ni_c)

    gs_file = None
    for p in module_c:
        if re.search(r"^\s*(?:RECOMP_FUNC\s+)?void\s+gamestate_change\s*\(", p.read_text(
                encoding="utf-8", errors="replace"), re.M):
            gs_file = p
            break
    if gs_file is not None:
        rel = gs_file.relative_to(tree.parent)
        out["GAMESTATE_BLOCK"] = (
            f"/* This tree defines a real CV64 NI boot-stub hook in {rel.as_posix()}, and\n"
            f" * build_module.ps1 compiles that file into the module — so the descriptor points at it. */\n"
            f"extern \"C\" void gamestate_change(uint8_t* rdram, recomp_context* ctx);\n")
        out["GAMESTATE_FIELD"] = "(RecompModuleGuestFunc)gamestate_change"
        prov.add("gamestate_change", "the tree's own", str(rel.as_posix()))
    else:
        out["GAMESTATE_BLOCK"] = (
            f"/* CV64's NI boot-stub hook. No source this module compiles defines one, so {game} gets\n"
            f" * the loud no-op — it can never fire, and says so if it does. */\n"
            f"static void module_gamestate_change(uint8_t* /*rdram*/, void* ctx_v) {{\n"
            f"    recomp_context* ctx = (recomp_context*)ctx_v;\n"
            f"    fprintf(stderr, \"[{game}.dll] gamestate_change(%d) fired -- CV64 NI boot path in {game}?!\\n\",\n"
            f"            (int)ctx->r4);\n"
            f"    fflush(stderr);\n"
            f"}}\n")
        out["GAMESTATE_FIELD"] = "module_gamestate_change"
        prov.add("gamestate_change", "loud no-op (none in the module's sources)",
                 f"{tree.name}/src/patches/ (engine_shims.c excluded by build_module.ps1)")

    if ni_c.is_file():
        out["NI_BLOCK"] = (
            "/* The NI overlay-content catalog generated by tools/gen_ni_data.py into\n"
            " * src/ni_section_data.c, which build_module.ps1 compiles into the module. Its element\n"
            " * layout is RecompModuleNiSection's by construction (librecomp overlays.cpp NiSectionData). */\n"
            "extern \"C\" const RecompModuleNiSection ni_section_data_table[];\n"
            "extern \"C\" const size_t ni_section_data_table_count;\n")
        out["NI_FIELD"] = "ni_section_data_table"
        out["NI_COUNT_FIELD"] = "ni_section_data_table_count"
        prov.add("ni_sections", "the tree's own catalog", f"{tree.name}/src/ni_section_data.c")
    else:
        out["NI_BLOCK"] = (f"/* No NI content catalog: {game}'s overlays are static "
                           f"(ni_sections = NULL, count = 0). */\n")
        out["NI_FIELD"] = "NULL"
        out["NI_COUNT_FIELD"] = "0"
        prov.add("ni_sections", "none", f"{tree.name}/src/ni_section_data.c is absent")
    return out


def derive_pins(tree: Path, prov: Provenance) -> dict:
    """The RAM-shadow set's pinned functions. merge_recomp_sets.py writes ram_shadow_pins.inl next
    to the shadowing set; <game>pc/src/main.cpp calls register_ram_shadow_pins() before
    recomp::start(). The .inl calls recomp::overlays::register_pinned_function, a C++-MANGLED
    engine symbol that no module can import, so the module defines that one function locally and
    forwards it across the C boundary — the generated .inl compiles unchanged in both builds."""
    hit = None
    for d in live_recomp_dirs(tree):
        p = d / "ram_shadow_pins.inl"
        if p.is_file():
            hit = p
            break
    if hit is None:
        prov.add("ram_shadow_pins", "none", f"no RecompiledFuncs*/ram_shadow_pins.inl in {tree.name}")
        return {"PINS_BLOCK": "", "MODULE_INIT_BLOCK": "", "MODULE_INIT_FIELD": "NULL"}
    prov.add("ram_shadow_pins", hit.parent.name + "/ram_shadow_pins.inl", str(hit.relative_to(tree.parent).as_posix()))
    return {
        "PINS_BLOCK":
            "\n/* ── the RAM-shadow set's pinned functions ─────────────────────────────────────────────── */\n"
            f"/* {hit.parent.name}/ram_shadow_pins.inl, generated by merge_recomp_sets.py. It calls\n"
            " * recomp::overlays::register_pinned_function — a C++-mangled engine symbol a module cannot\n"
            " * import — so that one function is DEFINED HERE and forwarded to the host's C entry point.\n"
            " * The generated .inl is used verbatim, exactly as src/main.cpp uses it. */\n"
            "extern \"C\" void recomp_register_pinned_function(int32_t vram, recomp_func_t* func);\n"
            "#include \"ram_shadow_pins.inl\"\n"
            "namespace recomp { namespace overlays {\n"
            "void register_pinned_function(int32_t vram, recomp_func_t* func) {\n"
            "    recomp_register_pinned_function(vram, func);\n"
            "}\n"
            "} }\n",
        "MODULE_INIT_BLOCK":
            "\n/* The host calls this once, immediately before start_game() — the same point in the boot\n"
            " * order at which src/main.cpp calls register_ram_shadow_pins() before recomp::start(). */\n"
            "static void module_init(void) {\n"
            "    register_ram_shadow_pins();\n"
            "}\n",
        "MODULE_INIT_FIELD": "module_init",
    }


def game_app_dir(game: str) -> Path:
    """<root>/archive/<game>pc, or the old <root>/<game>pc when a tree is already there.
    Games are created inside archive/ so a release folder is not a pile of per-game
    directories (2026-09-07); trees made before that keep working where they are."""
    old = N64PC / (game + "pc")
    if (old / "CMakeLists.txt").is_file():
        return old
    return N64PC / "archive" / (game + "pc")


def emit_module(out: Path, game: str, quiet: bool = False) -> Path:
    """Render <game>pc/module/module_main.cpp from the tree. Returns the written path."""
    prov = Provenance()
    subs = {"GAME": game}
    subs.update(derive_identity(out, game, prov))
    subs.update(derive_rsp(out, game, prov))
    subs.update(derive_engine_debt(out, game, prov))
    subs.update(derive_pins(out, prov))

    text = render((TPL / "module_main.cpp.tmpl").read_text(encoding="utf-8"), subs)
    dest = out / "module" / "module_main.cpp"
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_text(text, encoding="utf-8")
    if not quiet:
        print(f"[module] rendered {dest} ({len(text.splitlines())} lines) — provenance:")
        prov.dump()
    return dest


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--game", required=True, help="lowercase id, e.g. spaceinv (-> spaceinvpc, namespace, fn prefixes)")
    ap.add_argument("--module", action="store_true",
                    help="MODULE ONLY: render <game>pc/module/module_main.cpp from the existing tree "
                         "and exit. Touches nothing else; the identity args are not needed.")
    ap.add_argument("--title", help='display title, e.g. "Space Invaders 64"')
    ap.add_argument("--internal", help='ROM internal name, e.g. "SPACE INVADERS"')
    ap.add_argument("--hash", help="XXH3_64 of the ROM, e.g. 0xE1C49BA5F7D4FEE0")
    ap.add_argument("--entrypoint", help="entrypoint VRAM, e.g. 0x80200050")
    ap.add_argument("--sha1", default="(unknown)", help="ROM SHA1 (shown in the wrong-ROM dialog)")
    ap.add_argument("--save-type", default="Eep4k", help="recomp::SaveType enum value (game.hpp): "
                    "None / Eep4k / Eep16k / Sram / Flashram / AllowAll  (NOT 'Flash' or 'None_')")
    ap.add_argument("--pfx", default=None, help="constant prefix (default: GAME upper)")
    ap.add_argument("--ns", default=None, help="renderer namespace (default: game)")
    ap.add_argument("--ref", default="waveracepc", help="reference app for the support files")
    ap.add_argument("--out", default=None, help="output dir (default: ../<game>pc)")
    ap.add_argument("--force", action="store_true")
    a = ap.parse_args()

    if a.module:
        game = a.game.strip()
        out = Path(a.out).resolve() if a.out else game_app_dir(game).resolve()
        if not out.is_dir():
            sys.exit(f"ERROR: no game tree at {out} — --module renders the face of an EXISTING tree")
        emit_module(out, game)
        print("[module] DONE. Build it with: "
              f"powershell -NoProfile -File recompilator\\tools\\build_module.ps1 {game}")
        return

    for req in ("title", "internal", "hash", "entrypoint"):
        if getattr(a, req) is None:
            sys.exit(f"ERROR: --{req} is required when scaffolding a whole app "
                     f"(it is not needed with --module, which reads the existing tree)")

    game = a.game.strip()
    if not game or not (game[0].isalpha() or game[0] == "_"):
        sys.exit(f"ERROR: game id '{game}' must be a valid C++ identifier — it becomes a namespace and "
                 f"function-name prefix (e.g. '{game}_audio_init', 'namespace {game}'). Start it with a "
                 f"letter or underscore; prefix digit-leading names, e.g. '40winks' -> 'fortywinks'.")
    _VALID_SAVES = {"None", "Eep4k", "Eep16k", "Sram", "Flashram", "AllowAll"}
    if a.save_type not in _VALID_SAVES:
        sys.exit(f"ERROR: --save-type '{a.save_type}' is not a recomp::SaveType value (librecomp game.hpp): "
                 f"{sorted(_VALID_SAVES)}. Common slips: 'Flash' -> 'Flashram', 'None_' -> 'None'.")
    pfx = (a.pfx or game.upper()).strip()
    if pfx and pfx[0].isdigit():
        pfx = "G" + pfx   # C identifiers can't start with a digit (40winks -> G40WINKS; sweep BUILD_FAIL 2026-07-15)
    ns = (a.ns or game).strip()
    if ns and ns[0].isdigit():
        ns = "g" + ns
    # THE REFERENCE APP. In the lab it is a real tree (waveracepc). A RELEASE ships no game tree at
    # all (2026-09-07: no game ships with the program), so the support
    # files the scaffold copies are also kept as templates/refapp/ - our own app glue, nothing
    # ROM-derived. The named tree wins when it is there; the template is the fallback, so a blind
    # bring-up on a user's machine scaffolds exactly as the lab does.
    ref_dir = (N64PC / a.ref).resolve()
    out = Path(a.out).resolve() if a.out else game_app_dir(game).resolve()

    if not ref_dir.is_dir():
        fallback = (HERE / "templates" / "refapp").resolve()
        if fallback.is_dir():
            print(f"[scaffold] no reference tree at {ref_dir} - using the shipped {fallback}")
            ref_dir = fallback
        else:
            sys.exit(f"ERROR: reference app not found: {ref_dir} (and no templates/refapp)")
    if out.exists() and any(out.iterdir()) and not a.force:
        sys.exit(f"ERROR: {out} exists and is non-empty (use --force to overwrite)")

    ref = detect_ref_token(ref_dir)
    print(f"[scaffold] ref={a.ref} (token '{ref}')  ->  {out.name} (game '{game}', ns '{ns}', pfx '{pfx}')")

    subs = {
        "GAME": game, "TITLE": a.title, "INTERNAL": a.internal,
        "HASH": a.hash, "ENTRYPOINT": a.entrypoint, "SHA1": a.sha1,
        "SAVETYPE": a.save_type, "PFX": pfx, "NS": ns,
    }

    (out / "src" / "patches").mkdir(parents=True, exist_ok=True)
    (out / "RecompiledFuncs").mkdir(parents=True, exist_ok=True)  # filled by the recomp stage

    # 1. rendered templates (CMakePresets is static — it has no {{placeholders}})
    (out / "CMakeLists.txt").write_text(
        render((TPL / "CMakeLists.txt.tmpl").read_text(encoding="utf-8"), subs), encoding="utf-8")
    (out / "src" / "main.cpp").write_text(
        render((TPL / "main.cpp.tmpl").read_text(encoding="utf-8"), subs), encoding="utf-8")
    (out / "CMakePresets.json").write_text(
        render((TPL / "CMakePresets.json.tmpl").read_text(encoding="utf-8"), subs), encoding="utf-8")
    print("[scaffold]   rendered CMakeLists.txt + src/main.cpp + CMakePresets.json (cross-platform)")

    # 2. support files, copied + token-renamed
    copied, missing = [], []
    for rel in SUPPORT + OPTIONAL:
        src = ref_dir / rel
        if not src.is_file():
            if rel in SUPPORT:
                missing.append(rel)
            continue
        txt = src.read_text(encoding="utf-8", errors="replace")
        txt = rename_tokens(txt, ref, game)
        # De-flavor the renderer so a new app does not inherit cv64's F3DEX2-only
        # forceBranch hardcode (see deflavor_renderer). Only the renderer carries it.
        if rel == "src/rt64_renderer.cpp":
            txt = deflavor_renderer(txt)
        (out / rel).parent.mkdir(parents=True, exist_ok=True)
        (out / rel).write_text(txt, encoding="utf-8")
        copied.append(rel)
    print(f"[scaffold]   copied+renamed {len(copied)} support files" + (f"  (optional skipped: aspMain/f3dex2 absent in ref)" if "rsp/aspMain.cpp" not in copied else ""))
    if missing:
        print(f"[scaffold]   WARNING missing required support files in ref: {missing}")

    # 3. the game module face, derived from the src/ files just written (never from a table here)
    emit_module(out, game)

    print(f"[scaffold] DONE -> {out}")
    print( "[scaffold] next: the recomp stage fills RecompiledFuncs/ + recomp_overlays.inl,")
    print( "[scaffold] then `cmake -S {0} -B {0}/build` && build.".format(out.name))


if __name__ == "__main__":
    main()
