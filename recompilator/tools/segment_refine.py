#!/usr/bin/env python3
"""
segment_refine.py — drive an interleaved game to a LINKED app via build-error-driven segmentation.

Each round: re-segment (gen_segmented + accumulated force lists) -> regenerate yaml from the disassemble_all
template -> re-splat (byte-exact) -> gen_toml -> recomp (+auto-stub recomp-ABORT data funcs) -> build the
app. The C COMPILER is ground truth:
  - `undefined label L_X` at funcs_N.c(LINE): a single function (enclosing func F at LINE) spans a spurious
    data span up to target X. FORCE-CODE the whole RANGE [F, X] so the function is one contiguous code span.
  - malformed func (after_N / C1075 / C2371): the enclosing func is data -> FORCE-DATA it.
Feed the forces back, re-segment, repeat until the app links (or no new offenders -> stuck).
"""
import sys
import argparse, os, re, subprocess, sys
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

# The recomp must write the #1 diagnostics sink (failures.json) so the data-vs-code veto can read the
# unhandled-opcode blobs at the recomp-stuck dead-end. setdefault = a caller can still force it off.
os.environ.setdefault("RECOMP_DIAG", "1")

HERE = Path(__file__).resolve().parent

sys.path.insert(0, str(HERE))
import recomp_autostub


def cop0_filter(fe, names, why):
    """NEVER STUB A FUNCTION THAT PROGRAMS COP0/THE TLB - in EVERY path that can stub one.

    A stub returns without doing anything, so a stubbed osMapTLB means the kernel's window is
    never opened and every access through it faults forever. recomp_autostub has refused these
    since 2026-09-06, but it is not the only path that can stub: this file stubs from the
    malformed-C scan and from build errors, and neither was guarded. On a blind Castlevania
    that stubbed three TLB mappers, and un-stubbing them by hand was one of the two per-game
    attempts of 09-06 (measured again 09-07: 3 of the 6 functions stubbed here hold COP0 ops).
    Such a function is code by definition. If its C is malformed the recompiler needs fixing;
    silently emptying it turns a loud failure into a black screen.
    """
    if not names:
        return names
    bad = {n for n in names if recomp_autostub.has_cop0_tlb(str(fe), n)}
    if bad:
        print("[refine] REFUSED to stub (%s): %s - they program COP0/the TLB and are code by "
              "definition" % (why, ", ".join(sorted(bad))), flush=True)
    return set(names) - bad
# Match BOTH real funcs and N64Recomp's auto-created statics (CreateStatic: an in-section jal target with no
# func symbol -> `static_<section>_<vram>`). enclosing() must find the NEAREST decl above the error line; if it
# only knew func_, a static_ offender would mis-attribute the error to the previous real func and wrongly stub it.
DECL = re.compile(r"RECOMP_FUNC\s+void\s+(func_[0-9A-Fa-f]+|static_\w+)\s*\(")
LBLLOC = re.compile(r"funcs_(\d+)\.c\((\d+)[,)][^\n]*undefined label '?L_([0-9A-Fa-f]+)'?")
BADF = re.compile(r"funcs_(\d+)\.c\((\d+)[,)][^\n]*(C1075|C2371|after_)")
# THE SAME TWO CLASSES AS CLANG SAYS THEM (the bundled-clang module build; MSVC's forms above stay for
# the Visual Studio route). clang: `...funcs_3.c:1234:9: error: use of undeclared label 'L_800A1234'`.
LBLLOC_CLANG = re.compile(r"funcs_(\d+)\.c:(\d+):\d+:\s*error:[^\n]*(?:undeclared|undefined) label '?L_([0-9A-Fa-f]+)'?")
BADF_CLANG = re.compile(r"funcs_(\d+)\.c:(\d+):\d+:\s*error:[^\n]*(after_|redefinition|expected)")
# lld names an unresolved symbol on its own line and the referencing object on the following ones.
UNDEF_LLD = re.compile(r"undefined symbol:\s*_?(func_[0-9A-Fa-f]+)(_recomp)?")
def run(cmd, cwd=None, timeout=1800):
    p = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, timeout=timeout)
    return p.returncode, (p.stdout or "") + (p.stderr or "")

def enclosing(cfile, line):
    """Return the NAME (func_XXXX or static_XX_XXXX) of the function containing `line`, or None."""
    if not cfile.exists(): return None
    L = cfile.read_text(encoding="utf-8", errors="replace").splitlines()
    for i in range(min(line, len(L))-1, -1, -1):
        m = DECL.search(L[i])
        if m: return m.group(1)
    return None

ELF_HOW = "docker"          # set in main(); named in the abort messages so a failure says WHICH toolchain
BUILD_HOW = "msbuild"


def build_elf_native(py, root, game, toolchain):
    """The no-docker byte-exact stage: tools/build_elf.py with the bundled toolchain. Same steps, same
    verdict line ('BYTE-EXACT: ...'), so every caller's gate is unchanged."""
    argv = [py, "-I", str(HERE / "build_elf.py"), game, "--root", str(root)]
    if toolchain:
        argv += ["--toolchain", str(toolchain)]
    return run(argv, timeout=3600)


def build_elf_docker(root, game):
    return run(["docker", "run", "--rm", "--entrypoint", "sh", "-v", f"{Path(root).as_posix()}:/rb",
                "cv64-build", "-c", f"sh /rb/recompilator/build_elf.sh {game}"], timeout=1200)


def build_module(py, root, game, toolchain, jobs):
    """The bundled-clang module build = the C compiler as ground truth WITHOUT Visual Studio. The face
    is rendered first (scaffold_app.py --module) exactly as build_entry.ps1 stage 5 does it, so the
    loop compiles the same thing the driver will."""
    rc, out = run([py, "-I", str(HERE.parent / "scaffold_app.py"), "--game", game, "--module"], timeout=600)
    if "[module] rendered" not in out:
        return rc, out + "\nMODULE FACE FAILED\n"
    argv = ["powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass",
            "-File", str(HERE / "build_module.ps1"), game, "-Jobs", str(jobs)]
    if toolchain:
        argv += ["-Toolchain", str(toolchain)]
    rc2, out2 = run(argv, timeout=3600)
    return rc2, out + out2


def main():
    ap = argparse.ArgumentParser()
    for n in ("basename","fe-dir","app","full-yaml","full-toml","recomp"):
        ap.add_argument("--"+n, required=True)
    # --cmake/--sweep are the MSBuild route's own arguments: required only when that route is used.
    ap.add_argument("--cmake", default=""); ap.add_argument("--sweep", default="")
    # THE TWO SHIPPABLE SWAPS (2026-09-07). Everything below used to assume the lab: docker for the
    # ELF and Visual Studio for the compiler. A user of the Recompilator installs neither, so both
    # steps are now selectable and the bundled toolchain is the other side of each. Defaults are the
    # historical behaviour, so every existing caller is unchanged.
    ap.add_argument("--elf-mode", choices=("docker", "native", "auto"), default="docker")
    ap.add_argument("--build-mode", choices=("msbuild", "module", "none"), default="msbuild")
    ap.add_argument("--toolchain", default="")
    ap.add_argument("--python", default="")
    ap.add_argument("--root", default="")
    ap.add_argument("--app-dir", default="", help="the <game>pc directory; defaults to <root>/<app>")
    ap.add_argument("--jobs", type=int, default=8)
    ap.add_argument("--vram", default="0x80000400"); ap.add_argument("--rom-off", default="0x1000")
    ap.add_argument("--resident-end", default="0x101000")
    ap.add_argument("--entrypoint", default=None)  # exec entry (may differ from resident base, e.g. CIC-6105)
    ap.add_argument("--max", type=int, default=12); ap.add_argument("--cap", type=int, default=30)
    a = ap.parse_args()
    g = a.basename; fe = Path(a.fe_dir).resolve()
    root = Path(a.root).resolve() if a.root else fe.parent
    sweep = Path(a.sweep).resolve() if a.sweep else None
    global ELF_HOW, BUILD_HOW
    py = a.python or sys.executable
    tc = a.toolchain
    if a.elf_mode == "auto":
        ELF_HOW = "native" if (tc and os.path.isfile(os.path.join(tc, "mips", "bin", "mips64-elf-as.exe"))) else "docker"
    else:
        ELF_HOW = a.elf_mode
    BUILD_HOW = a.build_mode
    if BUILD_HOW == "msbuild" and not (a.cmake and sweep):
        print("[refine] --build-mode msbuild needs --cmake and --sweep", flush=True); return 1
    # --app is the app NAME (also the cmake target and the exe name); --app-dir is where it
    # actually is, which is <root>/archive/<game>pc now and used to be <root>/<game>pc.
    app_dir = Path(a.app_dir) if a.app_dir else (root / a.app)
    rf = app_dir / "RecompiledFuncs"
    build = (sweep / "build") if sweep else None
    fc_file = fe / "_force_code.txt"; fd_file = fe / "_force_data.txt"; fcr_file = fe / "_force_code_ranges.txt"
    fdr_file = fe / "_force_data_ranges.txt"   # data_vs_code_veto's blob ranges -> gen_segmented bin spans
    fi_file = fe / "_force_ignore.txt"   # malformed phantom funcs -> toml [patches] ignored (skipped entirely)
    toml_path = fe / f"{g}.toml"
    full_yaml = Path(a.full_yaml).read_text(encoding="utf-8")
    fcode = {int(x,16) for x in fc_file.read_text().split()} if fc_file.exists() else set()
    fdata = {int(x,16) for x in fd_file.read_text().split()} if fd_file.exists() else set()
    fignore = {l.strip() for l in fi_file.read_text().splitlines() if l.strip().startswith("func_")} if fi_file.exists() else set()
    franges = set()
    if fcr_file.exists():
        for l in fcr_file.read_text().splitlines():
            if l.strip() and not l.startswith("#"):
                lo,hi = l.split()[:2]; franges.add((int(lo,16), int(hi,16)))
    feu = str(fe).replace("\\","/")

    # THE BYTE-EXACT PAIR, KEPT ASIDE BEFORE SEGMENTATION OVERWRITES IT.
    # blind_bringup wrote <game>.yaml (disassemble_all, ONE asm subsegment per code segment) and a
    # <game>_pinned.ld to match, and the BYTE-EXACT ELF stage has just proved that pair reproduces
    # the cartridge over the full ROM with no coverage gaps. gen_segmented then replaces both with
    # an interleaved asm/bin/data split, and for some carts that split does not round-trip - which
    # is the failure this loop aborts on. Keep the proven pair so the abort has somewhere to fall.
    flat_yaml = full_yaml
    flat_ld   = (fe / f"{g}_pinned.ld").read_text(encoding="utf-8") if (fe / f"{g}_pinned.ld").exists() else None
    flat_active = False   # once set, this round SKIPS re-segmentation and uses the kept pair
    flat_ld_text = None
    prev_subsegs = None   # skip the (slow) Docker re-splat on rounds where only the stub list changed
    severed_rounds = 0; SEVERED_MAX = 8   # cap split_severed_entries re-splats so a materialize->new-severed cascade can't loop forever
    for rnd in range(1, a.max+1):
        fc_file.write_text("\n".join(f"0x{x:08X}" for x in sorted(fcode))+"\n", newline="\n")
        fd_file.write_text("\n".join(f"0x{x:08X}" for x in sorted(fdata))+"\n", newline="\n")
        fcr_file.write_text("\n".join(f"0x{lo:08X} 0x{hi:08X}" for lo,hi in sorted(franges))+"\n", newline="\n")
        fi_file.write_text("\n".join(sorted(fignore))+"\n", newline="\n")
        if flat_active:
            # THE FALLBACK ROUND. Do not re-segment: gen_segmented would rebuild the interleaved
            # split that just failed to round-trip, straight over the byte-exact pair we fell back
            # to, and the round would fail again for the same reason. Measured 2026-09-08 - the
            # first version of this fallback used `continue` and therefore never took effect.
            print(f"[refine] round {rnd}: using the byte-exact one-asm-subsegment split", flush=True)
            subsegs = "<flat>"
        else:
            rc,out = run([sys.executable, str(HERE/"gen_segmented.py"), "--toml", a.full_toml, "--rom", str(fe/"baserom.z64"),
                          "--basename", g, "--vram", a.vram, "--rom-off", a.rom_off, "--resident-end", a.resident_end,
                          "--yaml-out", str(fe/"_subsegs.txt"), "--ld-out", str(fe/f"{g}_pinned.ld"),
                          "--force-code-file", str(fc_file), "--force-data-file", str(fd_file),
                          "--force-code-ranges-file", str(fcr_file), "--force-data-ranges-file", str(fdr_file)])
            print(f"[refine] round {rnd}: {out.strip().splitlines()[-1] if out.strip() else 'segmented'}", flush=True)
            subsegs = (fe/"_subsegs.txt").read_text(encoding="utf-8").rstrip("\n")
        (fe/f"{g}_stubs.txt").write_text("", encoding="utf-8")
        # The ELF depends only on the segmentation (_subsegs). When a round changes only the stub list
        # (fignore grows but segmentation is identical), the re-splat would reproduce a byte-identical ELF
        # -> skip it and reuse the previous round's ELF. Big win for cascade games (each phantom = 1 round).
        if subsegs != prev_subsegs:
            # gen_segmented emits EVERY code segment's subsegments (a cart with a detached module
            # has more than one), so replace the whole span from the seed subsegment line down to
            # the assets segment - replacing just the seed line would leave the template's own
            # module blocks behind and declare them twice.
            if flat_active:
                (fe/f"{g}.yaml").write_text(flat_yaml, encoding="utf-8", newline="\n")
                (fe/f"{g}_pinned.ld").write_text(flat_ld_text, encoding="utf-8", newline="\n")
            else:
                _y = re.sub(r"      - \[0x1000, asm, main\].*?(?=  - name: assets)",
                            subsegs + "\n", full_yaml, flags=re.S)
                (fe/f"{g}.yaml").write_text(_y.replace("disassemble_all: true","disassemble_all: false"), encoding="utf-8", newline="\n")
            # ENTRYPOINT FUNC: force splat to make a FUNC at the resident base. Some games' boot code is only
            # reached by the CPU at reset (never jal'd), so splat labels it D_<base> (NOTYPE/data) -> the ELF
            # has no STT_FUNC there -> N64Recomp aborts "Could not find entrypoint function". Seed it as a func.
            ep = int(a.entrypoint, 0) if a.entrypoint else int(a.vram, 0)
            # PRESERVE pre-seeded symbols (the libultra names from match_libultra) — only ENSURE the
            # entrypoint func is present, never clobber. FIX 1: the matched scheduler/interrupt names must
            # survive the refine loop so N64Recomp binds them to the HLE path (else the game spins on
            # MI_INTR_MASK and crashes). Was: write_text(only-the-entrypoint) -> wiped the libultra surface.
            _cur = (fe/"symbol_addrs.txt").read_text(encoding="utf-8", errors="replace") if (fe/"symbol_addrs.txt").exists() else ""
            if f"= 0x{ep:08X};" not in _cur:
                _cur = f"func_{ep:08X} = 0x{ep:08X}; // type:func\n" + _cur
            (fe/"symbol_addrs.txt").write_text(_cur, encoding="utf-8")
            # SINGLE SOURCE: build_{g}.sh clones were deleted in the consolidation sweep. Mount the N64PC
            # ROOT (fe.parent) as /rb and run the generic recompilator/build_elf.sh <game>. (Same repoint as
            # ingest.py b539688.) The game dir holds DATA only now.
            if ELF_HOW == "native":
                rc,out = build_elf_native(py, root, g, tc)
            else:
                rc,out = build_elf_docker(root, g)
            if "BYTE-EXACT" not in out:
                # ROADMAP TOOL #2 (verify_diff_to_forcedata): don't dead-abort. Map each divergent ROM byte
                # back to its owning func (via the all-funcs full toml's vram<->rom delta) and force-data it,
                # then RETRY — the verify-driven force-data loop the FORCE_DATA_SEED comment wished for. A span
                # splat emitted as CODE but that doesn't round-trip byte-exact is really DATA; forcing it fixes
                # the segmentation. Bounded by --max; if #2 finds no NEW resident func to force, we still abort
                # (the divergence is a coverage gap / overlay-delta, not a resident force-data case).
                elf = fe / "build" / f"{g}.elf"
                if not elf.exists() or "LINK FAILED" in out or "FATAL" in out:
                    # the re-splat BUILD itself failed (no ELF) — NOT a byte divergence, so #2 can't help and
                    # would crash on the missing ELF. Surface the real build error instead.
                    errs = [l for l in out.splitlines() if any(k in l for k in
                            ("error", "FAILED", "FATAL", "undefined reference", "No such"))]
                    print(f"[refine] round {rnd}: re-splat BUILD FAILED (no ELF) -> abort:\n  " +
                          "\n  ".join(errs[-6:]), flush=True); return 1
                before_fd = set(fdata)
                rc2, out2 = run([sys.executable, str(HERE/"verify_diff_to_forcedata.py"), "--toml", a.full_toml,
                                 "--elf", str(elf), "--rom", str(fe/"baserom.z64"), "--vram", a.vram,
                                 "--rom-off", a.rom_off, "--fe-dir", str(fe), "--apply"])
                if rc2 not in (0, 2):   # 0=byte-exact, 2=divergences handled; anything else = the tool crashed
                    print(f"[refine] round {rnd}: verify_diff_to_forcedata FAILED (rc={rc2}) -> abort:\n{out2}", flush=True); return 1
                fdata = {int(x,16) for x in fd_file.read_text().split()} if fd_file.exists() else set()
                if fdata - before_fd:
                    # The on-disk ELF is the DIVERGENT one we just rejected. Invalidate prev_subsegs so next
                    # round ALWAYS re-splats + re-verifies byte-exactness, even when the new force-data doesn't
                    # move a segment boundary (else the 'segmentation unchanged -> reuse ELF' fast-path would
                    # link the STALE divergent ELF and slip a wrong build through — defeating tool #2 entirely).
                    prev_subsegs = None
                    print(f"[refine] round {rnd}: re-splat NOT byte-exact -> #2 force-data'd {len(fdata-before_fd)} func(s), retry", flush=True); continue
                # NOT AN ABORT ANY MORE: FALL BACK TO THE SHAPE THAT IS ALREADY PROVEN.
                # The divergence is not force-data'able (it is coverage, or a boundary the split
                # invented), and the interleaved split is the only thing that introduced it - the
                # one-asm-subsegment pair was byte-exact minutes ago over the whole ROM. That is
                # also exactly what the hand-authored trees carry: Pilotwings' yaml says "ONE asm
                # subsegment keeps byte-order exact; data-as-code handled via <game>_stubs.txt".
                # So keep the code/data knowledge where the recompiler reads it - _force_ignore -
                # and stop asking splat to express it as segment boundaries.
                # 2026-09-08: Pilotwings, Doom 64 and Space Invaders all died here.
                if flat_ld is not None and not flat_active:
                    print(f"[refine] round {rnd}: re-splat NOT byte-exact and #2 found nothing new "
                          f"to force -> falling back to the byte-exact one-asm-subsegment split", flush=True)
                    flat_active  = True
                    flat_ld_text = flat_ld
                    prev_subsegs = None
                    continue
                print(f"[refine] round {rnd}: re-splat NOT byte-exact and #2 found no new resident func to force -> abort", flush=True); return 1
            prev_subsegs = subsegs
        else:
            print(f"[refine] round {rnd}: segmentation unchanged -> reuse ELF (skip re-splat)", flush=True)
        # gen_toml reads _force_ignore.txt itself and emits the malformed funcs as [patches] stubs (empty
        # defined body -> real callers still link), filtered to funcs that actually exist in the ELF.
        # SINGLE SOURCE: per-game gen_{g}_toml.py clones were deleted -> recompilator/gen_toml.py <game>.
        run([sys.executable, str(HERE.parent/"gen_toml.py"), g])
        # CRITICAL: N64Recomp shards output into funcs_N.c; when force-data evicts funcs the count drops and
        # stale funcs_N.c files linger with OLD malformed content that breaks the build. Clear before recomp.
        for stale in rf.glob("funcs_*.c"): stale.unlink()
        # FRESH DIAGNOSTICS: the build-side diag sink MERGES into failures.json (accumulates events across
        # recomp runs), so a stale round-1 copy makes the data-vs-code veto keep re-finding already-carved
        # blobs -> the loop wedges at "recomp stuck" while the carved recomp is actually clean. Delete it so
        # each round's veto acts on CURRENT data only. (This was the bug that stopped Blast Corps converging.)
        (rf / "failures.json").unlink(missing_ok=True)
        rc,out = run([sys.executable, str(HERE/"recomp_autostub.py"), "--dir", str(fe), "--basename", g, "--recomp", a.recomp, "--max", str(a.cap)], timeout=1800)
        # recomp-abort funcs (recomp_autostub stubbed them in {g}_stubs.txt) are genuine non-code. Fold into
        # the PERSISTENT stub accumulator (_force_ignore.txt) so they stay stubbed every round. force-data
        # CANNOT evict a jal-targeted phantom (splat re-emits the FUNC symbol), so STUB is the reliable lever.
        sp = fe/f"{g}_stubs.txt"; before = len(fignore)
        if sp.exists():
            for l in sp.read_text().splitlines():
                l = l.strip()
                if l.startswith("func_"): fignore.add(l)
        # PROACTIVE DATA-vs-CODE VETO (every round, not just at the stuck dead-end): carve the embedded-data
        # blobs the #1 diagnostics sink recorded (unhandled-opcode floods = data splat disassembled as code).
        # With recomp_autostub fixed the recomp degrades CLEAN (never "stuck"), so without this the blobs would
        # survive into the build as dead nops; firing here carves them for a CLEAN build. Re-segment + retry
        # until no new blobs remain, THEN fall through to the clean/build logic.
        failures = rf / "failures.json"
        if failures.exists():
            before_fdr = fdr_file.read_text() if fdr_file.exists() else ""
            run([sys.executable, str(HERE/"data_vs_code_veto.py"), "--failures", str(failures),
                 "--fe-dir", str(fe), "--apply"])
            if (fdr_file.read_text() if fdr_file.exists() else "") != before_fdr:
                prev_subsegs = None
                print(f"[refine] round {rnd}: data-vs-code veto carved new data blobs -> re-segment", flush=True); continue
        if "CLEAN" not in out:
            if len(fignore) > before:
                print(f"[refine] round {rnd}: recomp not clean; folded {len(fignore)-before} abort funcs into stubs; retry", flush=True); continue
            # (the data-vs-code veto already ran proactively above, so any carveable data blobs are handled;
            # reaching here means the recomp aborted on something that is neither a stubbable func nor data.)
            print(f"[refine] round {rnd}: recomp stuck (no new stubs; data blobs already carved above)", flush=True); return 1
        # SEVERED ENTRIES (general; same recomp->static feedback as gap_reingest, but wired into THIS loop
        # because match_libultra wipes+regenerates symbol_addrs.txt before the refine starts — a one-shot
        # append in sweep_game would be lost, so it must be re-derived every run). N64Recomp emits cross-
        # function jump/call targets that land mid-(mis-sized)-func as EMPTY static_ stubs: the enclosing named
        # func's gen_toml size swallowed them, so `j/jal <target>` reaches a do-nothing body and control is
        # silently lost (NC's scheduler dispatcher static_18_80080FCC; Blast Corps' jtbl mis-split). recomp is
        # now CLEAN so the FULL .c set is on disk -> split_severed_entries sees every empty-but-called stub and
        # NAMES it as a func boundary in symbol_addrs.txt; the NEXT splat then sizes the enclosing func to end
        # there and the target recompiles with REAL code. Must run AFTER recomp (reveals the stubs) and BEFORE
        # the next re-splat. Append-only + idempotent (backs up .bak_severed, skips already-named) so once named
        # it reports 0 new and stops; byte-exact-NEUTRAL (splitting one code func into two changes no bytes, so
        # the re-splat's byte-exact gate still holds). prev_subsegs=None forces the re-splat (symbol_addrs grew
        # but the segmentation didn't, so the reuse-ELF fast-path would otherwise skip it). SEVERED_MAX bounds a
        # materialize->new-severed-entry cascade.
        if severed_rounds < SEVERED_MAX:
            rc_se, out_se = run([sys.executable, str(HERE/"split_severed_entries.py"), g, "--apply"])
            m_se = re.search(r"NEW boundaries to add\s*:\s*(\d+)", out_se)
            n_se = int(m_se.group(1)) if m_se else 0
            if n_se > 0:
                severed_rounds += 1
                prev_subsegs = None
                print(f"[refine] round {rnd}: split_severed_entries named {n_se} severed "
                      f"entr{'y' if n_se == 1 else 'ies'} -> re-splat ({severed_rounds}/{SEVERED_MAX})", flush=True)
                continue
        # PROACTIVE phantom scan: find ALL `goto <absent label>` funcs in the generated C in one pass. The
        # build only surfaces 1-2 per file before aborting, so build-driven discovery converges ~1 func/round;
        # this stubs them all at once (collapses many rounds into ~1). func_ -> stub; static_ -> needs manual_funcs.
        rc_s, scan_out = run([sys.executable, str(HERE/"scan_malformed.py"), str(rf)])
        new_scanned = {l.strip() for l in scan_out.splitlines() if l.strip().startswith("func_")} - fignore
        new_scanned = cop0_filter(fe, new_scanned, "malformed-C scan")
        if new_scanned:
            fignore |= new_scanned
            print(f"[refine] round {rnd}: scan found {len(new_scanned)} malformed func_ -> stub + re-recomp", flush=True); continue
        if BUILD_HOW == "none":
            # NO COMPILER IN THE LOOP. Everything above is compiler-free (the recompiler's own aborts,
            # the diagnostics sink's data blobs, the malformed-C scan, the severed-entry scan), so a
            # tree that survives all of it is as far as the loop can carry it without one. The caller's
            # own COMPILE stage is then the gate, and it fails loudly there if the C does not build.
            print(f"[refine] CONVERGED after {rnd} rounds, no compiler in the loop "
                  f"(ranges {len(franges)}, force-code {len(fcode)}, force-data {len(fdata)}, stubs {len(fignore)})", flush=True)
            return 0
        if BUILD_HOW == "module":
            rc,out = build_module(py, root, g, tc, a.jobs)
            ok = "MODULE OK" in out
        else:
            rc,out = run([a.cmake,"--build",str(build),"--config","Release","--target",a.app], timeout=1800)
            ok = bool(list(build.rglob(f"{a.app}.exe"))) and "error C" not in out
        if ok:
            print(f"[refine] LINKED after {rnd} rounds via {BUILD_HOW} (ranges {len(franges)}, force-code {len(fcode)}, force-data {len(fdata)})", flush=True); return 0
        newfcr, newfd, newfc, newig, static_off = set(), set(), set(), set(), set()
        for fidx,line,xs in (LBLLOC.findall(out) + LBLLOC_CLANG.findall(out)):
            F = enclosing(rf/f"funcs_{fidx}.c", int(line))
            if F and F.startswith("func_"):
                # An undefined label = N64Recomp emitted `goto L_X` to an address it never made a label for.
                # Now that jtbl switch-detection handles in-function jump tables, a REAL function won't hit
                # this -> F is a phantom (data bytes splat emitted as a jal-target FUNC, decoding as code with
                # a spurious branch). STUB it (empty defined body; force-data can't evict a jal-targeted sym).
                newig.add(F)
            elif F and F.startswith("static_"):
                static_off.add(F)   # CreateStatic phantom: can't stub by toml name; needs manual_funcs (pass-2)
            else:
                newfc.add(int(xs,16))
        # malformed func (after_N / C1075 / C2371): a phantom func splat emitted as a FUNC symbol inside a
        # data span (a jal-target). force-data CAN'T evict it (spimdisasm re-creates the symbol), so use
        # N64Recomp's [patches] ignored: rename _recomp + skip recomp AND decl (no C2371 like stubs cause).
        for fidx,line,_ in (BADF.findall(out) + BADF_CLANG.findall(out)):
            fn = enclosing(rf/f"funcs_{fidx}.c", int(line))
            if fn and fn.startswith("func_"): newig.add(fn)
            elif fn and fn.startswith("static_"): static_off.add(fn)
        # lld's shape of the same "an ignored func IS called" / "a real func was marked data" pair.
        lines_out = out.splitlines()
        for i, l in enumerate(lines_out):
            m = UNDEF_LLD.search(l)
            if not m: continue
            sym, isrec = m.group(1), m.group(2)
            if isrec:
                for j in range(i + 1, min(i + 6, len(lines_out))):
                    mr = re.search(r"(func_[0-9A-Fa-f]+)_recomp", lines_out[j])
                    if mr and mr.group(1) != sym:
                        newfd.add(int(mr.group(1).split("_")[1], 16)); break
            elif sym not in fignore and sym not in newig:
                newfc.add(int(sym.split("_")[1], 16))
        # unresolved externals: (a) "func_X_recomp ... referenced in function func_Y" = an ignored func IS
        # called by recompiled code -> the CALLER is also data, force-data func_Y; (b) plain "func_X" = a
        # real code func wrongly marked data -> force-code it (entry-adjacent boot-stub callees, etc.).
        for m in re.finditer(r'unresolved external symbol "?_?(func_[0-9A-Fa-f]+)(_recomp)?"?(?:[^\n]*?referenced in function "?_?(func_[0-9A-Fa-f]+))?', out):
            sym, isrec, ref = m.group(1), m.group(2), m.group(3)
            if isrec:
                if ref: newfd.add(int(ref.split("_")[1], 16))
            elif sym not in fignore and sym not in newig:
                newfc.add(int(sym.split("_")[1], 16))
        if not (newfcr-franges) and not (newfd-fdata) and not (newfc-fcode) and not (newig-fignore):
            extra = f" [{len(static_off)} static_ offenders need manual_funcs (pass-2): {', '.join(sorted(static_off)[:4])}]" if static_off else ""
            # THE FAILURE HAS TO SAY WHAT IT WAS. This line used to be MULTI-LINE and to filter on a
            # lowercase 'error', so a stage protocol that takes one line printed 'errors:' and nothing at
            # all - and the message it was hiding said the module face could not read the window title.
            # One line, case-insensitive, and the loud shapes too (FAILED/FATAL/cannot/undefined).
            _pat = re.compile(r'error|failed|fatal|cannot|undefined|missing', re.I)
            _errs = [l.strip() for l in out.splitlines() if _pat.search(l)]
            _show = ' | '.join(_errs[:3]) if _errs else 'the build produced no message this pass could recognise'
            print(f"[refine] round {rnd}: STUCK after {len(_errs)} error line(s){extra}: {_show}", flush=True)
            (fe/"_refine_fail.log").write_text(f"STUCK round {rnd}; static_off={sorted(static_off)}\n\n"+out, encoding="utf-8", errors="replace")
            return 1
        newig = cop0_filter(fe, newig, "build-error stub")
        franges |= newfcr; fdata |= newfd; fcode |= newfc; fignore |= newig
        print(f"[refine] round {rnd}: +{len(newfcr)} ranges, +{len(newfd)} force-data, +{len(newfc)} force-code, +{len(newig)} ignored", flush=True)
    print(f"[refine] hit --max={a.max}", flush=True)
    (fe/"_refine_fail.log").write_text(f"hit --max={a.max}\n\n"+out, encoding="utf-8", errors="replace")
    return 2

if __name__ == "__main__":
    sys.exit(main())
