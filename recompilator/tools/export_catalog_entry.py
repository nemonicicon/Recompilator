#!/usr/bin/env python3
"""export_catalog_entry.py -- export ONE game's catalog entry (alexbeav's group 2: game config + our patches)
from the bench trees into catalog/<game>/, and AUDIT it: nothing from group 4 (ROM bytes or anything
mechanically derived from them) may be in the export.  PACKAGING_FIRST_GAME.md (2026-09-06) is the plan.

The bench trees do not move.  The entry is a COPY, derived by this script, so the publish shape can be
regenerated at any time from the working set.

Two tree shapes:
  * sweep-shaped (<g>/ + <g>pc/, the 300-odd trees the sweep tooling built): symbol_addrs.txt, <g>.yaml,
    <g>.toml, <g>_pinned.ld, _subsegs.txt, _force_*.txt, *_stubs.txt, *_overlays.txt, ucode *.toml,
    <g>pc/CMakeLists.txt, CMakePresets.json, <g>pc/src/**
  * cv64 (decomp-shaped): the segment map + the FOUR symbol files live in the blazkowolf/cv64 decomp
    clone (cv64/castlevania.yaml, cv64/linker/symbol_addrs*.txt); the recompiler config, ucode tomls,
    app glue and patches in cv64pc/.  The decomp itself is a DEPENDENCY (its pinned commit is recorded
    in entry.json), not a copy.

The audit (refuses the export on any hit):
  * a file whose first four bytes are an N64 ROM magic word (any byte order) -- ROMs by content, never by name
  * a path matching the group-4 names: *.z64 *.n64 *.v64, asm/, assets/, build/, RecompiledFuncs*/, *_ram/,
    ni_section_data.c, *_captures/, *.log, *.bak_*, *.pre_*
  * a C/C++ file carrying a byte array over 64 KB (the ni_section_data.c shape: ROM bytes as C)

Usage:  py -3 recompilator/tools/export_catalog_entry.py <game> [--out <dir>] [--force]
"""
import sys
import hashlib, json, os, re, shutil, subprocess, sys

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

# The workspace this export reads from. A release runs the same script against ITS OWN tree (the
# program writes the user's locally-authored entries there), so --root overrides it.
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
N64_MAGIC = {b"\x80\x37\x12\x40", b"\x37\x80\x40\x12", b"\x40\x12\x37\x80", b"\x12\x40\x80\x37"}
GROUP4_DIRS = ("asm", "assets", "build", "_ram")
GROUP4_RE = re.compile(r"(\.z64$|\.n64$|\.v64$|(^|[\\/])RecompiledFuncs|ni_section_data\.c$|_captures([\\/]|$)|\.log$|\.bak_|\.pre_|_ram([\\/]|$))", re.I)
BYTE_ARRAY_RE = re.compile(rb"(0x[0-9A-Fa-f]{2}\s*,\s*){2000,}")


def sha1_of(path):
    h = hashlib.sha1()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def git(cwd, *args):
    try:
        return subprocess.check_output(["git", *args], cwd=cwd, stderr=subprocess.DEVNULL).decode("utf-8", "replace").strip()
    except Exception:
        return ""


def audit_file(path):
    rel = os.path.relpath(path, ROOT)
    if GROUP4_RE.search(rel):
        return "group-4 name: " + rel
    parts = rel.replace("\\", "/").split("/")
    if any(p in GROUP4_DIRS for p in parts[:-1]):
        return "group-4 directory: " + rel
    with open(path, "rb") as f:
        head = f.read(4)
        if head in N64_MAGIC:
            return "N64 ROM magic word: " + rel
        if path.lower().endswith((".c", ".cpp", ".h", ".hpp", ".inl")):
            f.seek(0)
            body = f.read()
            if len(body) > 65536 and BYTE_ARRAY_RE.search(body):
                return "byte array over 64 KB in C (ROM bytes as source?): " + rel
    return None


def is_rsp_config(path):
    """An RSPRecomp microcode config: addresses and names the user's machine regenerates the
    recompiled microcode from. Any other toml beside a tree is a lab artefact (a recompiler config
    pointing at a decompilation build, a size list) and never travels."""
    try:
        s = open(path, encoding="utf-8", errors="replace").read()
    except OSError:
        return False
    return "output_function_name" in s and "text_offset" in s


SOURCE_EXT = (".c", ".cpp", ".h", ".hpp", ".inc")


def trim_presets_to_windows(path):
    """Keep only the windows-x64 configure preset (and the build presets that use it). A release
    ships Windows alone; the other targets are not announced (2026-09-09)."""
    try:
        with open(path, encoding="utf-8") as f:
            d = json.load(f)
    except Exception:
        return
    cps = d.get("configurePresets", [])
    keep = [c for c in cps if c.get("name") == "windows-x64"]
    if len(keep) == len(cps):
        return
    d["configurePresets"] = keep
    if "buildPresets" in d:
        d["buildPresets"] = [b for b in d["buildPresets"] if b.get("configurePreset") == "windows-x64"]
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        json.dump(d, f, indent=2); f.write("\n")


def collect_sweep_shaped(g):
    t, tp = os.path.join(ROOT, g), os.path.join(ROOT, g + "pc")
    files = []
    for name in os.listdir(t):
        p = os.path.join(t, name)
        if not os.path.isfile(p) or ".bak" in name or ".pre_" in name:
            continue          # backups beside the facts are never facts
        # A UCODE CONFIG IS AN ENTRY FILE. The recompiled microcode itself is derived from the cart
        # and never ships, so a user's machine regenerates it from a toml of addresses and names -
        # and without that toml the first catalog build on a clean machine links everything and then
        # fails on one undefined symbol, aspMain (2026-09-07).
        if name.endswith(".toml") and name != g + ".toml":
            if is_rsp_config(p):
                files.append((p, name))
            continue
        # _modules.txt carries the cart's detached code modules (ROM offset -> load address).
        # Without it gen_segmented falls back to one contiguous region on a rebuild and files a
        # whole module at addresses that do not exist in the running game.
        if name in ("symbol_addrs.txt", g + ".yaml", g + ".toml", g + "_pinned.ld", "_subsegs.txt", "_modules.txt", "undefined_syms_manual.ld") \
           or name.startswith("_force_") or name.endswith(("_stubs.txt", "_overlays.txt")):
            files.append((p, name))
    for name in os.listdir(tp):
        p = os.path.join(tp, name)
        if os.path.isfile(p) and (name in ("CMakeLists.txt", "CMakePresets.json", g + "_overlays.txt") or (name.endswith(".toml") and name != g + ".toml" and is_rsp_config(p))):
            files.append((p, os.path.join("app", name) if name in ("CMakeLists.txt", "CMakePresets.json") else os.path.join("ucode", name)))
    # THE ASSEMBLY MACROS ARE A BUILD INPUT, NOT DECORATION. splat writes asm that says
    # `glabel func_...` and `nonmatching ...`; those macros live in the tree's include/macro.inc,
    # and without it the assembler stops at the first function with "unrecognized opcode `glabel`"
    # - which is exactly how the first real catalog build on a clean machine failed (2026-09-07).
    # Only the macro files travel. A tree's tools/ holds lab one-offs with absolute paths and
    # never travels; the one generated-data tool a decomp-shaped entry needs is named explicitly
    # by collect_cv64.
    inc = os.path.join(t, "include")
    if os.path.isdir(inc):
        for f in sorted(os.listdir(inc)):
            if f.endswith(".inc") and ".bak" not in f and ".pre_" not in f:
                files.append((os.path.join(inc, f), "include/" + f))
    src = os.path.join(tp, "src")
    if os.path.isdir(src):
        for dp, dn, fn in os.walk(src):
            for f in fn:
                if ".bak" in f or ".pre_" in f or ".pre-" in f or ".attempt" in f:
                    continue      # backups beside the glue are never glue
                if not f.endswith(SOURCE_EXT):
                    continue      # only source travels: no captures, dumps or notes beside it
                p = os.path.join(dp, f)
                files.append((p, os.path.join("app", "src", os.path.relpath(p, src))))
    return files, {}


def collect_cv64():
    t, tp = os.path.join(ROOT, "cv64"), os.path.join(ROOT, "cv64pc")
    files = [
        (os.path.join(t, "castlevania.yaml"), "game.yaml"),
        (os.path.join(t, "castlevania.sha1"), "rom.sha1"),
    ]
    for name in ("symbol_addrs.txt", "symbol_addrs_makerom.txt", "symbol_addrs_overlays.txt", "symbol_addrs_assets.txt"):
        files.append((os.path.join(t, "linker", name), os.path.join("linker", name)))
    for name, dst in (("cv64.toml", "recomp.toml"), ("func_sizes.toml", "func_sizes.toml"), ("cv64_overlays.txt", "overlays.txt"),
                      ("f3dex2.toml", "ucode/f3dex2.toml"), ("aspMain.toml", "ucode/aspMain.toml"),
                      ("CMakeLists.txt", "app/CMakeLists.txt"), ("CMakePresets.json", "app/CMakePresets.json")):
        files.append((os.path.join(tp, name), dst))
    src = os.path.join(tp, "src")
    for dp, dn, fn in os.walk(src):
        for f in fn:
            if f == "ni_section_data.c" or ".bak" in f or ".pre_" in f:
                continue          # ROM-derived (generated locally by tools/gen_ni_data.py) / backups
            p = os.path.join(dp, f)
            files.append((p, os.path.join("app", "src", os.path.relpath(p, src))))
    files.append((os.path.join(tp, "tools", "gen_ni_data.py"), os.path.join("tools", "gen_ni_data.py")))
    deps = {
        "decomp": {
            "project": "blazkowolf/cv64 (Castlevania decompilation)",
            "url": git(t, "remote", "get-url", "origin"),
            "pinned_commit": git(t, "rev-parse", "HEAD"),
            "upstream_base": (git(t, "merge-base", "HEAD", "origin/main") or git(t, "merge-base", "HEAD", "origin/master")),
            "licence": "NOT STATED in the clone (no LICENSE file, none in README) -- ask the project before shipping",
            "used_for": "the segment map (castlevania.yaml) and the four symbol files under linker/; the ELF the recompiler reads is built from this project against the user's ROM",
        }
    }
    return files, deps


def rom_facts_from_main(main_cpp):
    facts = {}
    try:
        txt = open(main_cpp, encoding="utf-8", errors="replace").read()
    except OSError:
        return facts
    m = re.search(r"SHA1:\s*([0-9a-fA-F]{40})", txt)
    if m: facts["sha1"] = m.group(1).lower()
    m = re.search(r"ROM_HASH\s*=\s*0x([0-9A-Fa-f]{16})", txt)
    if m: facts["xxh3_64"] = "0x" + m.group(1).upper()
    m = re.search(r"ENTRYPOINT_VRAM\s*=\s*0x([0-9A-Fa-f]{8})", txt)
    if m: facts["entrypoint"] = "0x" + m.group(1).upper()
    return facts


def report_verdict(g):
    """The newest _sweep/dispatch/<g>_<date>.md: its VERDICT line + the depth line, for trees the roster does not carry."""
    d = os.path.join(ROOT, "_sweep", "dispatch")
    if not os.path.isdir(d):
        return {}                  # no bench in a release tree; the entry carries no verdict
    cands = sorted(f for f in os.listdir(d) if re.fullmatch(re.escape(g) + r"_\d{8}\.md", f))
    if not cands:
        return {}
    txt = open(os.path.join(d, cands[-1]), encoding="utf-8", errors="replace").read()
    m = re.search(r"VERDICT[\s\S]{0,300}?\b(PASS|CAP \d/\d)([^\n]{0,200})", txt)
    out = {"report": "_sweep/dispatch/" + cands[-1]}
    if m:
        out["verdict"] = m.group(1)
        out["verdict_line"] = (m.group(1) + m.group(2)).strip()[:240]
    return out


def _sweep_facts(g):
    p = os.path.join(ROOT, "recompilator", "bench")
    cands = sorted([f for f in os.listdir(p) if f.startswith("corpus_state_") and f.endswith(".md")]) \
            if os.path.isdir(p) else []
    if not cands:
        # No roster (a release tree, or a cart the roster never carried): the tree yaml name is
        # the title, and report_verdict adds a verdict if a dispatch report happens to exist.
        r = report_verdict(g)
        y = os.path.join(ROOT, g, g + ".yaml")
        if os.path.isfile(y):
            for line in open(y, encoding="utf-8", errors="replace"):
                if line.startswith("name:"):
                    r["title"] = line.split(":", 1)[1].strip(); break
        return r
    for line in open(os.path.join(p, cands[-1]), encoding="utf-8", errors="replace"):
        if "`%s`" % g in line and line.startswith("|"):
            cells = [c.strip() for c in line.strip("|").split("|")]
            if len(cells) >= 6:
                d = {"row": cells[0], "release": cells[1], "title": cells[2], "sweep": cells[4], "state": cells[5][:300]}
                d.update(report_verdict(g)); return d
    r = report_verdict(g)          # not on the roster (a blind twin): the dispatch report is the state
    y = os.path.join(ROOT, g, g + ".yaml")
    if os.path.isfile(y):
        for line in open(y, encoding="utf-8", errors="replace"):
            if line.startswith("name:"):
                r["title"] = line.split(":", 1)[1].strip(); break
    if r.get("verdict"):
        r["sweep"] = "PASS" if r["verdict"] == "PASS" else r["verdict"]
    return r


def sweep_state(g):
    """The two facts an entry carries about how far the game was seen to get: the sweep verdict
    and, for a pass, whether it reached gameplay or a title. The working notes those facts were
    read from (the board row, the report path, the verdict sentence) stay in the lab."""
    facts = _sweep_facts(g) or {}
    text = (str(facts.get("state", "")) + " " + str(facts.get("verdict_line", ""))).upper()
    verdict = facts.get("sweep") or facts.get("verdict") or ""
    out = {}
    for k in ("title", "release"):
        if facts.get(k):
            out[k] = facts[k]
    if verdict:
        out["sweep"] = verdict
    if verdict.upper() == "PASS":
        out["reached"] = "gameplay" if ("GAMEPLAY" in text or "PLAYABLE" in text) else "title"
    return out


def main():
    args = sys.argv[1:]
    if not args:
        print(__doc__); return 2
    g = args[0]
    global ROOT
    if "--root" in args:
        ROOT = os.path.abspath(args[args.index("--root") + 1])
    out = os.path.join(ROOT, "recompilator", "catalog", g)
    if "--out" in args: out = args[args.index("--out") + 1]
    force = "--force" in args
    authored = "--authored" in args
    files, deps = (collect_cv64() if g == "cv64" else collect_sweep_shaped(g))
    missing = [s for s, d in files if not os.path.isfile(s)]
    if missing:
        print("MISSING source files (fix the manifest):"); [print("  " + m) for m in missing]; return 1
    problems = [audit_file(s) for s, d in files]
    problems = [p for p in problems if p]
    if problems:
        print("AUDIT REFUSED the export:"); [print("  " + p) for p in problems]; return 1
    if os.path.isdir(out):
        if not force:
            print("exists: %s (use --force to overwrite)" % out); return 1
        shutil.rmtree(out)
    total = 0
    for s, d in files:
        dst = os.path.join(out, d)
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        shutil.copy2(s, dst); total += os.path.getsize(s)
        if os.path.basename(dst) == "CMakePresets.json":
            trim_presets_to_windows(dst)   # a release is Windows-only; the lab trees still carry every preset
    main_cpp = os.path.join(ROOT, g + "pc", "src", "main.cpp")
    rom_facts = rom_facts_from_main(main_cpp)

    # THE CART IN THE TREE IS THE TRUTH. The facts above are read out of a comment in the generated
    # main.cpp, and a comment can go stale - two entries out of 170 carried a sha1 belonging to a
    # DIFFERENT cartridge (2026-09-07: waverace's entry held Pilotwings' hash, so adding Pilotwings
    # matched the Wave Race recipe and the build failed at the byte-exact stage saying so). A wrong
    # recipe applied to the wrong cart is worse than no recipe, and this is the one fact the whole
    # match turns on, so take it from the bytes the tree was actually built against.
    tree_rom = os.path.join(ROOT, g, "baserom.z64")
    if os.path.isfile(tree_rom):
        actual = sha1_of(tree_rom)
        claimed = (rom_facts.get("sha1") or "").lower()
        if claimed and claimed != actual:
            print("  sha1 in %spc/src/main.cpp is STALE (%s); using the cart's own %s"
                  % (g, claimed[:12], actual[:12]))
        rom_facts["sha1"] = actual

    entry = {
        "game": g,
        "rom": rom_facts,
        "sweep": sweep_state(g),
        "dependencies": deps,
        "engine": {
            "rt64": git(os.path.join(ROOT, "engine", "rt64"), "rev-parse", "--short", "HEAD"),
            "runtime": git(os.path.join(ROOT, "engine", "runtime"), "rev-parse", "--short", "HEAD"),
            "N64Recomp": git(os.path.join(ROOT, "engine", "runtime", "N64Recomp"), "rev-parse", "--short", "HEAD"),
        },
        "files": sorted(d.replace("\\", "/") for s, d in files),
        "never_shipped": ["the ROM", "asm/", "assets/", "build/ (the ELF)", "RecompiledFuncs/ (emitted C)", "ni_section_data.c (generated locally by tools/gen_ni_data.py)", "captures, logs, backups"],
        "exported_by": "recompilator/tools/export_catalog_entry.py",
    }
    if authored:
        # A LOCALLY AUTHORED ENTRY. Nothing about this game shipped: the program read the
        # user's own cartridge and wrote this entry on their machine. Marked so nobody ever
        # mistakes it for a lab-verified entry.
        entry["authored"] = {
            "by": "recompilator/tools/blind_bringup.py",
            "how": "blind bring-up from the cartridge's own bytes on this machine",
            "shipped": False,
        }
        if not isinstance(entry.get("sweep"), dict):
            entry["sweep"] = {}
        if not entry["sweep"].get("sweep"):
            entry["sweep"]["sweep"] = "LOCAL"
    with open(os.path.join(out, "entry.json"), "w", encoding="utf-8") as f:
        json.dump(entry, f, indent=2)
    # a second audit pass over what was actually written (belt and braces)
    post = []
    for dp, dn, fn in os.walk(out):
        for f in fn:
            r = audit_file(os.path.join(dp, f))
            if r: post.append(r)
    if post:
        print("POST-AUDIT REFUSED:"); [print("  " + p) for p in post]; shutil.rmtree(out); return 1
    print("exported %d files, %d bytes -> %s" % (len(files), total, out))
    print("audit: clean (no ROM magic, no group-4 names, no >64 KB byte arrays in C)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
