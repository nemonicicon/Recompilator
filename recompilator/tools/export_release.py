#!/usr/bin/env python3
"""export_release.py - the publish step: assemble THE PROGRAM (Recompilator) into a clean tree.

    py -3 recompilator/tools/export_release.py --dest D:\\stageprep

The tree mirrors the N64PC layout (recompilator/, engine/, _masterbuild/) so the launcher finds its
root and its CMake reaches the engine by relative path. The release carries the catalog of
recompiler-side entries (09-07 09:16); the launcher roots itself on the pipeline driver and
creates the user's own catalog folder for anything they build themselves.

What goes (group 1 + 2 of alexbeav's four groups): the launcher, the pipeline scripts and tools, the
scaffold templates, the catalog entries (addresses and names, never bytes), the engine forks as
source, the master CMake, the plan documents. What never goes: anything derived from a ROM
(emission shadows, RecompiledFuncs, RAM-snapshot trees, base ROMs), bench logs, boards, dossiers,
backups, build directories, the ROM library index, the SDK references.

After the copy the tree is AUDITED: every file's first bytes against the N64 ROM magic words, every
name against the group-4 patterns, every C source against the ">64 KB of byte literals" rule. A
failing audit is reported and the script exits 1 - the tree is left for inspection, never shipped.
"""
import argparse
import os
import re
import shutil
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))  # N64PC

# ---- the ship list -------------------------------------------------------------------------------
# (source relative to ROOT, kind). kind: "dir" = recursive with the common exclusions; "file" = one file.
# TWO ARTIFACTS, ONE SCRIPT (2026-09-07: the folder that is uploaded must be the thing people run).
#   --mode repo    : the SOURCE, what is pushed to GitHub and browsed. No binaries, no toolchain.
#   --mode release : the RUNNABLE PROGRAM, what a person downloads as a Release zip and unzips.
#                    It carries the built exe, the bundled toolchain, the pipeline, and the engine
#                    HEADERS ONLY - a user compiles their own game against the engine already
#                    inside Recompilator.exe, and never compiles the engine itself.
SHIP_REPO = [
    ("recompilator/launcher",   "dir"),
    ("recompilator/templates",  "dir"),
    ("recompilator/tools",      "dir-top"),
    ("recompilator/include",    "dir"),
    ("engine/rt64",             "dir"),
    ("engine/runtime",          "dir"),
    ("_masterbuild/CMakeLists.txt", "file"),
    ("recompilator/data",       "dir"),          # the libultra signature database (~1 MB)
    # THE CATALOG SHIPS (decided 09-07, once testing showed what a user loses without it; every
    # recompilation project ships this kind of per-game knowledge). An entry is RECOMPILER-SIDE knowledge about a cartridge - where its code lives, which
    # library functions it uses, the app glue - and nothing from any ROM, ~250 KB a game. Without
    # it a user gets only what the blind split works out unaided, which is not enough for Super
    # Mario 64, whose audio library at 0x80378800 nobody finds by accident.
    ("recompilator/catalog",    "dir"),
]
SHIP_RELEASE = [
    ("recompilator/templates",  "dir"),
    ("recompilator/tools",      "dir-top"),
    ("recompilator/include",    "dir"),
    ("recompilator/launcher/recomp_host_abi.txt", "file"),   # the host ABI the module links against
    ("engine/runtime/N64Recomp/include",  "dir"),
    ("engine/runtime/librecomp/include",  "dir"),
    ("engine/runtime/ultramodern/include", "dir"),
    ("recompilator/data",       "dir"),          # the libultra signature database (~1 MB)
    # THE CATALOG SHIPS (decided 09-07, once testing showed what a user loses without it; every
    # recompilation project ships this kind of per-game knowledge). An entry is RECOMPILER-SIDE knowledge about a cartridge - where its code lives, which
    # library functions it uses, the app glue - and nothing from any ROM, ~250 KB a game. Without
    # it a user gets only what the blind split works out unaided, which is not enough for Super
    # Mario 64, whose audio library at 0x80378800 nobody finds by accident.
    ("recompilator/catalog",    "dir"),
]
# THE PIPELINE IS AN ALLOWLIST. The recompilator root and recompilator/tools also hold the lab's
# harnesses, census tools and one-off probes, many of which carry absolute paths of this machine.
# What ships is the set the stage runner, the blind bring-up, the module build and the launcher
# actually reach, followed transitively through their references and imports (2026-09-09).
ROOT_SCRIPT_SHIP = {"build_elf.sh", "gen_toml.py", "recon.py", "scaffold_app.py", "sweep_game.py"}
TOOLS_SHIP = {
    "blind_bringup.py", "build_elf.py", "build_entry.ps1", "build_module.ps1", "code_window.py",
    "data_vs_code_veto.py", "dataregion_fix.py", "declare_overlays.py", "decompress_overlays.py",
    "detached_segments.py", "export_catalog_entry.py", "export_release.py", "find_ucode.py",
    "fix_false_gprel.py", "gap_reingest.py", "gen_segmented.py", "gprel_provide.py", "libultra_shapes.py",
    "localize_overlay_dups.py", "make_host_abi.ps1", "make_libultra_sigdb.py", "make_toolchain.ps1",
    "match_libultra.py", "merge_recomp_sets.py", "recomp_autostub.py", "recomp_coverage.py",
    "scan_malformed.py", "segment_refine.py", "split_severed_entries.py", "verify_diff_to_forcedata.py",
    "verify_rom_match.py", "yaz0.py",
}
# The planning documents are LAB documents: they carry verbatim working notes, internal criticism
# and process notes (PACKAGING_FIRST_GAME.md names him 25 times). They are not shipped by default in
# either artifact - the public document is release/README.md. Add one here deliberately, never by habit.
DOCS = []

# common exclusions inside a shipped directory (names, matched against each path component / file name)
EXCLUDE_DIRS = {".git", "build", "build-capture", "build_engine", "build_standalone", "softrdp_frames",
                "_desk_captures", "_gfx_captures", "_asp_captures", "__pycache__", "references",
                "softrdp_cap", "_oracles", "runs", "captures"}
# Any directory named build* is a build directory (a whole Visual Studio build tree had been
# committed under N64Recomp/build_cli, cache and absolute paths included).
def is_build_dir(name):
    return name == "build" or name.startswith(("build_", "build-"))
# A Windows-only release does not carry the vendored compiler's macOS/Linux libraries and binaries,
# nor the mupen64plus dependency bundle beyond SDL2, which is all RT64 and the launcher link.
EXCLUDE_PATHS = {
    "engine/rt64/src/contrib/dxc/lib",
    "engine/rt64/src/contrib/dxc/bin/arm64",
    "engine/rt64/src/contrib/mupen64plus-win32-deps/boost-1.81.0",
    "engine/rt64/src/contrib/mupen64plus-win32-deps/nasm-2.16.01",
    "engine/rt64/src/contrib/mupen64plus-win32-deps/gawk-3.1.6-1",
    "engine/rt64/src/contrib/mupen64plus-win32-deps/freetype-2.13.0",
    "engine/rt64/src/contrib/mupen64plus-win32-deps/opengl",
    "engine/rt64/src/contrib/mupen64plus-win32-deps/libpng-1.6.39",
    "engine/rt64/src/contrib/mupen64plus-win32-deps/zlib-1.2.13",
    "engine/rt64/src/contrib/mupen64plus-win32-deps/SDL2_net-2.2.0",
}
EXCLUDE_FILES = {
    "engine/rt64/src/contrib/dxc/bin/x64/dxc-linux",
    "engine/rt64/src/contrib/dxc/bin/x64/dxc-macos",
    # The console tier is not announced yet: its design note stays in the lab (2026-09-09).
    "engine/rt64/V3D_CAPABILITY_GATING.md",
}
# NOTHING SHIPPED NAMES THE CONSOLE TIER. Its announcement is deliberate and later; until then no
# shipped text may name the board, its GPU or the console. The audit fails the export on any of
# these words outside vendored code (2026-09-09). One upstream changelog line is exempt by file.
CONSOLE_WORDS_RE = re.compile(r"[Rr]aspberry|\bV3D\b|\bPi ?4\b|[Vv]ideo[Cc]ore|\bthe Pi\b|\bon the Pi\b|\(Pi\)|Pi console|\bPi's\b")   # case-sensitive: the N64 PI is uppercase
CONSOLE_WORDS_EXEMPT = ("imgui_impl_sdl2_custom.cpp", "export_release.py")   # this file must name what it forbids
AI_WORDS_RE = re.compile(r"\b(?:opus|fable|claude|anthropic|sonnet|chatgpt|copilot)\b", re.IGNORECASE)   # any case: CLAUDE.md, .claude/; README.md carries the disclosure on purpose
TEXT_EXT = (".c", ".cpp", ".h", ".hpp", ".hlsl", ".hlsli", ".inc", ".tmpl", ".py", ".ps1", ".sh", ".txt", ".toml",
            ".yaml", ".ld", ".json", ".cmake", ".md")
# built things outside a vendored dependency are never source
BINARY_EXT = (".exe", ".obj", ".pdb", ".ilk", ".lib", ".dll", ".exp")
EXCLUDE_FILE_RE = re.compile(
    r"(\.bak(_|\.|$)|\.pre_|_attempt_|\.camerafix$|pristine_bak|rung157|\.orig$|\.rej$|\.png$|\.log$|\.pcm$|\.wav$|\.raw$|\.tsv$|"
    r"^capture_.*\.ps1$|\.z64$|\.n64$|\.v64$|^baserom|\.jsonl$)", re.I)
LAUNCHER_EXCLUDE_FILE_RE = re.compile(r"\.ps1$|\.png$", re.I)   # every bench driver beside the launcher is lab-only

ROM_MAGIC = {b"\x80\x37\x12\x40", b"\x37\x80\x40\x12", b"\x40\x12\x37\x80"}
GROUP4_NAME_RE = re.compile(r"(^baserom|\.z64$|\.n64$|\.v64$|^RecompiledFuncs|^_ram$|^ni_section_data\.c$|"
                            r"^emit_(shadows|cv64)|\.rom$)", re.I)


def want_file(name):
    if name == ".git":          # a submodule pointer FILE; a fresh git init must not see nested repos
        return False
    return not EXCLUDE_FILE_RE.search(name)


def entry_has_decomp(entry_dir):
    """True when an entry must NOT ship: it declares a decompilation, or it was written by a
    build on this machine rather than authored for publication.

    The second case exists because blind_bringup now registers every game it builds in the
    catalog, so the launcher's library survives a restart (2026-09-07). Those entries are a
    record of what the person at this keyboard built from carts they own; they are not part of
    what the project publishes, and without this an ordinary test build in the lab would quietly
    add a game to the released catalog."""
    j = os.path.join(entry_dir, "entry.json")
    if not os.path.exists(j):
        return False
    try:
        import json as _json
        with open(j, encoding="utf-8") as f:
            e = _json.load(f)
        if e.get("origin") == "blind":
            return True
        return bool((e.get("dependencies") or {}).get("decomp"))
    except Exception:
        return True     # unreadable provenance is treated as unshippable, never the reverse


def copy_catalog(src, dst, stats):
    """The catalog, minus any entry built from a decompilation.

    The rule (2026-09-07): nothing here depends on a decompilation. The blind entries
    are the cart's own bytes worked out by the pipeline and carry no such lineage; an entry like
    cv64 is derived from a decompilation whose licence is unstated. This is a RULE and not a
    name: any future entry that declares one is held back the same way, and for cv64 nothing is
    lost because the blind Castlevania is the better build, confirmed on screen.
    """
    for name in sorted(os.listdir(src)):
        d = os.path.join(src, name)
        if not os.path.isdir(d):
            continue
        if entry_has_decomp(d):
            print(f"  catalog: HELD BACK {name} (built from a decompilation)")
            continue
        copy_dir(d, os.path.join(dst, name), stats=stats)


def copy_dir(src, dst, top_only=False, stats=None, allow=None):
    for dirpath, dirnames, filenames in os.walk(src):
        rel = os.path.relpath(dirpath, src)
        relroot = os.path.relpath(dirpath, ROOT).replace("\\", "/")
        # prune
        dirnames[:] = [d for d in dirnames
                       if d not in EXCLUDE_DIRS and not is_build_dir(d) and not d.startswith("emit_")
                       and not EXCLUDE_FILE_RE.search(d) and (relroot + "/" + d) not in EXCLUDE_PATHS]
        if top_only and rel != ".":
            dirnames[:] = []
            continue
        for f in filenames:
            if not want_file(f):
                continue
            if top_only and not f.lower().endswith((".py", ".ps1", ".sh")):
                continue
            if allow is not None and f not in allow:
                continue
            if (relroot + "/" + f) in EXCLUDE_FILES:
                continue
            if f.lower().endswith(BINARY_EXT) and "/contrib/" not in (relroot + "/"):
                continue
            s = os.path.join(dirpath, f)
            d = os.path.join(dst, rel, f) if rel != "." else os.path.join(dst, f)
            os.makedirs(os.path.dirname(d), exist_ok=True)
            shutil.copy2(s, d)
            stats["files"] += 1
            stats["bytes"] += os.path.getsize(s)


def audit(dest):
    """Audit WHAT WE SHIP. Not archive/, and not .git.

    The audit exists to prove no cartridge data is in the artifact. archive/ is the user's own
    games - their carts, their built trees - kept across a re-export on purpose. Auditing it finds
    exactly what it should find there (a ROM) and fails the export every time, which would make an
    honest check useless. It is not part of the artifact, so it is not audited."""
    fails = []
    for dirpath, dirnames, filenames in os.walk(dest):
        if os.path.abspath(dirpath) == os.path.abspath(dest):
            dirnames[:] = [d for d in dirnames if d not in ("archive", ".git")]
        for d in dirnames:
            if GROUP4_NAME_RE.search(d):
                fails.append(("group-4 name (dir)", os.path.join(dirpath, d)))
        for f in filenames:
            p = os.path.join(dirpath, f)
            if GROUP4_NAME_RE.search(f):
                fails.append(("group-4 name", p))
            try:
                with open(p, "rb") as fh:
                    head = fh.read(4)
            except OSError:
                continue
            if head in ROM_MAGIC:
                fails.append(("N64 ROM magic by content", p))
            # THE SIGNATURE DATABASE MAY CARRY SHAPES, NEVER BODIES. The format-2 file shipped 765 KB
            # of library machine code as base64, which none of the checks above can see (2026-09-09).
            # A database is accepted only as format 3 (tools/libultra_shapes.py) with no "blob" key.
            if f.lower().endswith(".json") and os.sep + "data" + os.sep in p:
                try:
                    import json as _json
                    with open(p, encoding="utf-8") as fh:
                        db = _json.load(fh)
                    if db.get("format") != 3:
                        fails.append(("signature database is not format 3 (shapes only)", p))
                    if '"blob"' in open(p, encoding="utf-8").read():
                        fails.append(("signature database carries function bodies", p))
                except Exception as e:
                    fails.append(("unreadable signature database: %s" % e, p))
            rel = os.path.relpath(p, dest).replace("\\", "/")
            if (f.lower().endswith(TEXT_EXT) and f not in CONSOLE_WORDS_EXEMPT
                    and not rel.startswith("toolchain/")          # vendored: python, binutils, clang
                    and "/contrib/" not in "/" + rel and "/thirdparty/" not in "/" + rel and "/lib/" not in "/" + rel):
                try:
                    with open(p, encoding="utf-8", errors="replace") as fh:
                        txt = fh.read()
                    if CONSOLE_WORDS_RE.search(txt) and "v3Depth" not in txt:
                        fails.append(("names the console tier", p))
                    elif CONSOLE_WORDS_RE.search(txt.replace("v3Depth", "")):
                        fails.append(("names the console tier", p))
                    if f != "README.md" and AI_WORDS_RE.search(txt):
                        fails.append(("names an AI assistant", p))
                except OSError:
                    pass
            if f.lower().endswith((".c", ".h", ".inl", ".cpp")):
                size = os.path.getsize(p)
                if size > 65536:
                    with open(p, "rb") as fh:
                        data = fh.read()
                    hexes = data.count(b"0x")
                    # a byte-array dump is ~5-6 bytes per literal; source code is nowhere near that dense
                    if hexes * 5 > size // 2:
                        fails.append((">64 KB of byte literals (a data dump in C)", p))
    return fails


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dest", required=True)
    ap.add_argument("--force", action="store_true", help="allow a non-empty destination (it is cleared first)")
    ap.add_argument("--with-binaries", action="store_true",
                    help="also place the built Recompilator.exe + its DLLs at the top of the tree (a click target)")
    ap.add_argument("--mode", choices=("repo", "release"), default="repo",
                    help="repo = the source to push; release = the runnable program (implies binaries + toolchain)")
    ap.add_argument("--zip", metavar="PATH", help="after building the tree, write it as a zip (a GitHub Release asset)")
    ap.add_argument("--audit-only", action="store_true", help="audit an existing tree at --dest; copy nothing")
    ap.add_argument("--with-toolchain", action="store_true",
                    help="also copy _toolchain/ (python+splat, mips binutils, N64Recomp, clang) to <dest>/toolchain/ - the end user installs nothing")
    a = ap.parse_args()
    dest = os.path.abspath(a.dest)
    if a.audit_only:
        fails = audit(dest)
        if fails:
            print(f"AUDIT FAILED ({len(fails)}):")
            for why, p in fails[:40]:
                print(f"  {why}: {os.path.relpath(p, dest)}")
            return 1
        print("AUDIT CLEAN: no ROM magic by content, no group-4 names, no byte-array dumps in C")
        return 0
    if os.path.isdir(dest) and os.listdir(dest):
        if not a.force:
            print(f"refusing: {dest} exists and is not empty (pass --force to clear it)")
            return 2
        # CLEAR THE TREE BUT NEVER THE HISTORY. Deleting the whole destination took .git with
        # it, so the published repo could only ever be a fresh tree force-pushed over itself -
        # one commit, no versioning, and no way to see what changed between two exports. Keeping
        # .git makes the destination a live clone: export over it, `git status` IS the diff, and
        # each publish is an ordinary reviewable commit on top of the last (2026-09-07, as asked).
        # KEEP WHAT IS THE USER'S, NOT OURS. `.git` is the published history; `archive` is the
        # games they built from their own cartridges. Re-exporting over a working install used to
        # delete both, which meant every refresh threw their library away and they had to build
        # everything again (it did exactly that repeatedly on 2026-09-07).
        KEEP = {".git", "archive"}
        kept = 0
        for name in os.listdir(dest):
            if name in KEEP:
                kept += 1
                continue
            p = os.path.join(dest, name)
            if os.path.isdir(p) and not os.path.islink(p):
                shutil.rmtree(p)
            else:
                os.remove(p)
        if kept:
            print("kept %d existing item(s) in %s: %s" % (kept, dest, ", ".join(sorted(KEEP))))
    os.makedirs(dest, exist_ok=True)

    if a.mode == "release":
        a.with_binaries = True
        a.with_toolchain = True
    ship = SHIP_RELEASE if a.mode == "release" else SHIP_REPO
    stats = {"files": 0, "bytes": 0}
    for src_rel, kind in ship:
        src = os.path.join(ROOT, src_rel)
        dst = os.path.join(dest, src_rel)
        if not os.path.exists(src):
            print(f"MISSING on disk: {src_rel}")
            continue
        if kind == "file":
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            shutil.copy2(src, dst)
            stats["files"] += 1; stats["bytes"] += os.path.getsize(src)
        elif src_rel.endswith("/catalog"):
            copy_catalog(src, dst, stats)
        elif src_rel == "recompilator/tools":
            copy_dir(src, dst, top_only=True, stats=stats, allow=TOOLS_SHIP)
        else:
            copy_dir(src, dst, top_only=(kind == "dir-top"), stats=stats)
    # the launcher's own bench scripts and shots do not ship
    ldir = os.path.join(dest, "recompilator", "launcher")
    for f in list(os.listdir(ldir)) if os.path.isdir(ldir) else []:
        if LAUNCHER_EXCLUDE_FILE_RE.search(f):
            os.remove(os.path.join(ldir, f)); stats["files"] -= 1
    # the pipeline scripts and the docs at the recompilator root
    rdir = os.path.join(ROOT, "recompilator")
    for f in sorted(os.listdir(rdir)):
        p = os.path.join(rdir, f)
        if not os.path.isfile(p):
            continue
        if f in ROOT_SCRIPT_SHIP or f in DOCS:
            shutil.copy2(p, os.path.join(dest, "recompilator", f))
            stats["files"] += 1; stats["bytes"] += os.path.getsize(p)
    # the built program at the top of the tree: the launcher finds its root from its own directory
    if a.with_binaries:
        bdir = os.path.join(ROOT, "recompilator", "launcher", "build", "windows-x64", "Release")
        for f, dst_name in (("recompilator.exe", "Recompilator.exe"), ("SDL2.dll", "SDL2.dll"),
                            ("dxcompiler.dll", "dxcompiler.dll"), ("dxil.dll", "dxil.dll")):
            s = os.path.join(bdir, f)
            if os.path.exists(s):
                shutil.copy2(s, os.path.join(dest, dst_name)); stats["files"] += 1; stats["bytes"] += os.path.getsize(s)
            else:
                print(f"MISSING binary: {f} (build the launcher first)")
    # the bundled toolchain (tools/make_toolchain.ps1 builds _toolchain/; nothing in it is ROM-derived)
    if a.with_toolchain:
        tsrc = os.path.join(ROOT, "_toolchain")
        if os.path.isdir(tsrc):
            tdst = os.path.join(dest, "toolchain")
            n0 = stats["files"]
            for dirpath, dirnames, filenames in os.walk(tsrc):
                rel = os.path.relpath(dirpath, tsrc)
                dirnames[:] = [d for d in dirnames if d not in ("downloads", "__pycache__")]   # the zips stay in the lab
                for f in filenames:
                    s = os.path.join(dirpath, f)
                    d = os.path.join(tdst, rel, f) if rel != "." else os.path.join(tdst, f)
                    os.makedirs(os.path.dirname(d), exist_ok=True)
                    shutil.copy2(s, d); stats["files"] += 1; stats["bytes"] += os.path.getsize(s)
            print(f"toolchain: {stats['files'] - n0} files")
        else:
            print("MISSING _toolchain/ (run tools/make_toolchain.ps1 first)")
    # the release README and LICENSE go to the TREE ROOT (a repo's README must be at its top);
    # the lab's own recompilator/README.md is a different document and never ships.
    for src_name, dst_name in (("release/README.md", "README.md"), ("release/LICENSE", "LICENSE")):
        s = os.path.join(ROOT, "recompilator", *src_name.split("/"))
        if os.path.exists(s):
            shutil.copy2(s, os.path.join(dest, dst_name))
            stats["files"] += 1; stats["bytes"] += os.path.getsize(s)
        else:
            print(f"MISSING {src_name} (the release tree ships without it)")
    # A .gitignore for the published tree.
    #
    # EVERY GAME-TREE RULE IS ANCHORED. An unanchored `*pc/` matches at ANY depth, so it also
    # matched recompilator/templates/gamepc/ and quietly kept the game-tree TEMPLATES out of the
    # repository entirely - the pipeline could not scaffold a game from a fresh clone, and nothing
    # said so (found 2026-09-07 when the templates would not stage). Anchor them to the root, where
    # a built game tree actually is, and exclude archive/ too now that games are created there.
    with open(os.path.join(dest, ".gitignore"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("# derived from a ROM or from a build - never committed\n"
                 "*.z64\n*.n64\n*.v64\nbaserom*\nRecompiledFuncs/\n_ram/\n"
                 "# game trees: the user's own builds, at the root and in the archive\n"
                 "/archive/\n/*pc/\n"
                 "build/\nbuild_*/\nbuild-*/\n_masterbuild/build/\n"
                 "recompilator/launcher/build/\n*.log\n__pycache__/\n"
                 "# the built program is a release artifact, not source\n/Recompilator.exe\n/*.dll\n")

    # what the pipeline references that is not in the tree
    missing = []
    sg = os.path.join(dest, "recompilator", "sweep_game.py")
    if os.path.exists(sg):
        txt = open(sg, encoding="utf-8", errors="replace").read()
        for m in sorted(set(re.findall(r"(?:tools/)?[A-Za-z0-9_]+\.(?:py|sh|ps1)", txt))):
            if m == "sweep_game.py":
                continue
            cands = [os.path.join(dest, "recompilator", m), os.path.join(dest, "recompilator", "tools", os.path.basename(m))]
            if not any(os.path.exists(c) for c in cands):
                missing.append(m)

    # report
    per_top = {}
    for dirpath, _, filenames in os.walk(dest):
        rel = os.path.relpath(dirpath, dest)
        top = rel.split(os.sep)[0] if rel != "." else "(root)"
        if top in ("recompilator",) and rel != "recompilator":
            top = "recompilator/" + rel.split(os.sep)[1]
        for f in filenames:
            per_top[top] = per_top.get(top, 0) + os.path.getsize(os.path.join(dirpath, f))
    print(f"exported {stats['files']} files, {stats['bytes']/1048576:.1f} MB -> {dest}")
    for k, v in sorted(per_top.items(), key=lambda kv: -kv[1]):
        print(f"  {v/1048576:8.1f} MB  {k}")
    if missing:
        print("pipeline references NOT in the tree (sweep_game.py):", ", ".join(missing))
    if a.zip:
        import zipfile
        zpath = os.path.abspath(a.zip)
        os.makedirs(os.path.dirname(zpath) or ".", exist_ok=True)
        top = os.path.splitext(os.path.basename(zpath))[0]   # unzips into one named folder
        n = 0
        # THE ZIP IS THE EXPORT, NOT THE FOLDER. The destination also holds what a refresh keeps
        # (archive/ = the user's own games and carts, .git) and whatever a bench left beside the
        # program; none of that is the release. Walk the same way the audit does, then audit the
        # zip's own contents by name and by magic, because the folder audit skips archive/ by design.
        with zipfile.ZipFile(zpath, "w", zipfile.ZIP_DEFLATED, compresslevel=6) as z:
            for dirpath, dirnames, filenames in os.walk(dest):
                if os.path.abspath(dirpath) == os.path.abspath(dest):
                    dirnames[:] = [d for d in dirnames if d not in ("archive", ".git", "_sweep")]
                for f in filenames:
                    full = os.path.join(dirpath, f)
                    z.write(full, os.path.join(top, os.path.relpath(full, dest)))
                    n += 1
        bad = []
        with zipfile.ZipFile(zpath) as z:
            for info in z.infolist():
                nm = info.filename
                if GROUP4_NAME_RE.search(os.path.basename(nm)) or "/archive/" in nm or "/.git/" in nm:
                    bad.append(nm)
                elif info.file_size >= 4:
                    with z.open(info) as fh:
                        if fh.read(4) in ROM_MAGIC:
                            bad.append(nm)
        if bad:
            os.remove(zpath)
            print(f"ZIP REFUSED: {len(bad)} member(s) that must never ship, e.g. {bad[:5]}")
            return 1
        print(f"zip: {n} files, {os.path.getsize(zpath)/1048576:.1f} MB -> {zpath}  (zip audit clean)")
    fails = audit(dest)
    if fails:
        print(f"AUDIT FAILED ({len(fails)}):")
        for why, p in fails[:40]:
            print(f"  {why}: {os.path.relpath(p, dest)}")
        return 1
    print("AUDIT CLEAN: no ROM magic by content, no group-4 names, no byte-array dumps in C")
    return 0


if __name__ == "__main__":
    sys.exit(main())
