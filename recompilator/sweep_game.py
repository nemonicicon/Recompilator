#!/usr/bin/env python3
"""
sweep_game.py — drive ONE Tier-A game from ROM to a level on the ladder, fully automated,
and append the outcome to recompilator/sweep_results.md.

Standard CIC-6102 recipe (all Tier-A games share entry 0x80000400 -> vram 0x80000400, 1MB resident):
  unzip -> recon -> clone front-end skeleton + author yaml/pinned.ld -> Docker splat -> byte-exact gate
  -> scaffold app -> gen toml -> recomp (+auto-stub, capped) -> add to sweep master -> build.

TRIAGE (the bail rule, automated):
  - front-end not byte-exact            -> L0, blocker "front-end"
  - auto-stub exceeds --cap (data-heavy)-> L1, blocker "data-heavy resident (needs segmentation)"  [DEFER]
  - app build fails                     -> L2, blocker "build: <first error>"
  - all pass                            -> L3  (builds; boot-check is by eye, later)

Usage:
  python sweep_game.py --id turok --rom "../../n64roms/Turok - Dinosaur Hunter (USA).zip" \
     --title "Turok Dinosaur Hunter" [--savetype None_] [--cap 40]
"""
import argparse, json, os, re, shutil, subprocess, sys, zipfile, glob
from pathlib import Path

HERE = Path(__file__).resolve().parent
N64PC = HERE.parent
sys.path.insert(0, str(HERE / "tools"))
# SINGLE COPY (2026-09-07): the CIC-aware resident base and the whole front-end authoring moved to
# tools/blind_bringup.py so the lab sweep and the shipped program's ADD ROM run the SAME code. This
# file keeps what is its own: the scoreboard, the triage, the two per-game maps below and the
# Docker/MSBuild lab route.
import blind_bringup as blind
SWEEP_CML = N64PC / "sweep" / "CMakeLists.txt"
RECOMP_EXE = N64PC / "engine" / "runtime" / "N64Recomp" / "build_cli" / "Release" / "N64Recomp.exe"
CMAKE = r"C:\Program Files\Microsoft Visual Studio\18\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
RESULTS = HERE / "sweep_results.md"

# GP-relative small-data games: their real _gp (derived from %gp_rel pairs). The default _gp=0x0 +
# the template's -G 0 handles non-gp-relative carts; these carts genuinely use GPREL16 and need their
# pinned _gp so %gp_rel re-encodes byte-exact (without it the relocations overflow the +/-32KB window).
# Per-game like a symbol map. Survives re-scaffold; also written to gp_override.txt for the segmented link.
GP_OVERRIDE = {
    "loderunner3d": 0x801505B0,
    "sprally":      0x80085F60,
}

# Per-game force-data SEED: spans splat mis-classified as code that silently mis-assemble (a verify-driven
# force-data loop would auto-find these; seeding the known offset is the low-risk equivalent). segment_refine
# reads _force_data.txt at init, so writing the seed there forces the span to bin (byte-exact). Like a symbol map.
FORCE_DATA_SEED = {
    "tetrisphere": [0x80120568],   # 24-byte divergence span '.main_80120568' (verified)
}
TMP = Path(os.environ.get("TEMP", "/tmp"))

def run(cmd, cwd=None, timeout=900):
    # Stream the subprocess output line-by-line and TEE it to the CRT raw-activity channel (the live
    # recompiler/Docker/compiler torrent shows as the fast purple back-layer on the tube). Still returns
    # (rc, full_output) exactly as before.
    try:
        import crt_feed as _crt
        rawf = open(_crt.RAW, "a", encoding="utf-8", errors="replace")
    except Exception:
        rawf = None
    out = []
    p = subprocess.Popen(cmd, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                         text=True, bufsize=1, errors="replace")
    n = 0
    try:
        for line in p.stdout:
            out.append(line)
            if rawf:
                rawf.write(line); n += 1
                if n % 8 == 0: rawf.flush()
        p.wait(timeout=timeout)
    except subprocess.TimeoutExpired:
        p.kill()
        try: p.wait(5)
        except Exception: pass
    finally:
        if rawf:
            try: rawf.flush(); rawf.close()
            except Exception: pass
            try:
                if os.path.getsize(_crt.RAW) > 300_000:          # keep the raw log bounded
                    with open(_crt.RAW, encoding="utf-8", errors="replace") as f: tail = f.readlines()[-600:]
                    with open(_crt.RAW, "w", encoding="utf-8", errors="replace") as f: f.writelines(tail)
            except Exception: pass
    return (p.returncode if p.returncode is not None else -1), "".join(out)

def record(idg, title, level, blocker, extra=""):
    line = f"| {idg} | {title} | **L{level}** | {blocker or '-'} | {extra} |\n"
    if not RESULTS.exists():
        RESULTS.write_text("# Tier-A sweep results\n\n| id | title | level | blocker | notes |\n|---|---|---|---|---|\n", encoding="utf-8")
    with open(RESULTS, "a", encoding="utf-8") as f:
        f.write(line)
    print(f"[sweep] RESULT {idg}: L{level} ({blocker or 'clean'}) {extra}")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--id", required=True)
    ap.add_argument("--rom", required=True, help="path to .zip or .z64")
    ap.add_argument("--title", required=True)
    ap.add_argument("--savetype", default="None")  # recomp::SaveType enum value (None, not None_)
    ap.add_argument("--cap", type=int, default=40)
    ap.add_argument("--results", default=None, help="scoreboard .md path (default sweep_results.md)")
    ap.add_argument("--entry", default=None, help="override exec entrypoint (e.g. 0x80001000 for CIC-6105); "
                    "bypasses the standard-0x80000400 gate. Resident base stays 0x80000400.")
    a = ap.parse_args()
    if a.results:
        global RESULTS
        RESULTS = Path(a.results)
    idg = a.id
    fe = N64PC / idg              # front-end dir
    app = N64PC / f"{idg}pc"

    # ---- 0. obtain the .z64 ----
    rom = Path(a.rom)
    if not rom.is_absolute(): rom = (Path.cwd() / rom).resolve()
    if rom.suffix.lower() == ".zip":
        ex = TMP / f"sweep_{idg}"; ex.mkdir(parents=True, exist_ok=True)
        with zipfile.ZipFile(rom) as z: z.extractall(ex)
        cands = [p for p in ex.rglob("*") if p.suffix.lower() in (".z64", ".n64", ".v64")]
        if not cands: return record(idg, a.title, 0, "no rom in zip")
        rom = cands[0]
    if not rom.exists(): return record(idg, a.title, 0, "rom not found")

    # ---- 1. recon ----
    rc, out = run([sys.executable, str(HERE / "recon.py"), str(rom)])
    def field(k):
        m = re.search(rf"{k}\s+(\S+)", out)
        return m.group(1) if m else None
    entry = field("entrypoint"); xxh = field("xxh3_64"); sha1 = field("sha1"); cic = field("cic")
    internal = a.title
    if not entry: return record(idg, a.title, 0, "recon failed")
    # ENTRY/CIC-AWARE resident base. n64brew Initial_Program_Load + en64 CIC table; pilotwings (entry
    # 0x80200050) is the in-tree precedent that PLAYS. IPL3 DMAs the 1 MB resident (rom 0x1000) to the ROM
    # header's boot address (offset 0x08) and JUMPS there. CIC-6103/-6106 inflate that header field by
    # +0x100000 / +0x200000 as an anti-backup trick, so the REAL load/run base = entry - bias.
    # THE CIC-6103/6106 BIAS IS REAL — re-confirmed 2026-06-15 (the prior "byte-exact refuted it" note was a
    # FALSE NEGATIVE). The byte-exact gate does NOT discriminate vram: the segment refiner forces code/data
    # classification until the bytes round-trip, which it can achieve at ANY base, so byte-exactness "passed"
    # 1080 at 0x80100400 — but that placement is wrong. The real arbiter is the BAKED-IN ABSOLUTE jal/j targets
    # in the boot stub: for every 6103 cart (excitebike, 1080, Diddy, Banjo, Kirby, Paper Mario; F-Zero/Cruis'n
    # World are 6106), 100% of those targets land in 0x8000xxxx = exactly the bias below the 0x8010xxxx/0x8020xxxx
    # header entry. Placed at the un-biased entry, the targets point at PHANTOM addresses → N64Recomp hard-errors
    # ("Unhandled branch" on a plain j) OR its runtime-function-lookup dispatch (normal for a jal whose target
    # isn't statically linked) resolves to a phantom at boot → crash. Placed at entry-bias (0x80000400) the
    # targets become REAL registered functions, so the same lookup resolves correctly. PROVEN: excitebike64
    # re-based to 0x80000400 — its boot-stub `jal 0x80000450` now maps to func_80000450 (which EXISTS; 0 stale
    # 0x8010xxxx funcs) and the unhandled-`j` hard error is gone → byte-exact + LINKED (was L2). NB: "Unresolved
    # jal → runtime lookup" lines persist regardless of base (normal) — the metric is whether the TARGET is a
    # real func, which the bias fixes, not the line count. 6101/6102/6105 have no bias.
    # --entry overrides. (librecomp loads the resident at whatever entrypoint_address the app registers;
    # elf.cpp keys entrypoint detection off rom 0x1000. cic is parsed/logged for the later 6105 8MB/IMEM work.)
    # THE CIC-AWARE RESIDENT BASE lives in tools/blind_bringup.py (one copy; the doctrine and
    # the proofs for the 6103/6106 bias and the 6105 correction are in its docstring).
    resident_base = blind.resident_base(int(entry, 16), cic, a.entry)
    ep = f"0x{resident_base:08X}"
    abase = f"0x{(resident_base + 0x400000) & 0xFFFFFFFF:08X}"
    print(f"[sweep] {idg}: entry={entry} cic={cic} -> resident_base={ep} xxh3={xxh} sha1={sha1}")
    if not (0x80000000 <= resident_base < 0x80800000):
        return record(idg, a.title, 0, f"resident base {ep} out of RDRAM range (entry {entry} cic {cic})")

    # ---- 2. front-end skeleton ----
    # ONE COPY of the authoring (tools/blind_bringup.author_tree): baserom, include/macro.inc, the
    # libultra byte-signature match, the gap re-ingest, the disassemble_all yaml and the pinned
    # linker script. The two per-game maps above are this file's own and are passed in; there is no
    # game name inside the shared code.
    with open(rom, "rb") as _rf:
        rom_bytes = blind.to_z64(_rf.read())
    _nlib = blind.author_tree(N64PC, idg, rom_bytes, a.title, sha1, resident_base,
                              python=sys.executable, gp=GP_OVERRIDE.get(idg, 0),
                              force_data=FORCE_DATA_SEED.get(idg))
    fe = N64PC / idg
    print(f"[sweep] {idg}: libultra match -> {_nlib} named functions")

    # ---- 3. Docker front-end -> byte-exact ----
    # SINGLE SOURCE: mount the N64PC ROOT as /rb and run the generic recompilator/build_elf.sh <game> (same
    # invocation segment_refine.py uses). The old per-game build_<game>.sh was deleted in the consolidation.
    # GUARD (2026-07-18): a down docker daemon used to be reported as "front-end not byte-exact" — a
    # mislabeled environment failure that poisons the sweep board. Probe the daemon first and report
    # DOCKER_DOWN distinctly so no L0 verdict is recorded from an unreachable environment.
    rc, out = run(["docker", "info", "--format", "{{.ServerVersion}}"], timeout=60)
    if rc != 0:
        tail = "; ".join(out.splitlines()[-2:])[:160]
        return record(idg, a.title, 0, "DOCKER_DOWN (environment, NOT a byte-exactness verdict)", tail)
    root_posix = N64PC.as_posix()
    rc, out = run(["docker", "run", "--rm", "--entrypoint", "sh", "-v", f"{root_posix}:/rb",
                   "cv64-build", "-c", f"sh /rb/recompilator/build_elf.sh {idg}"], timeout=1200)
    if "BYTE-EXACT" not in out:
        tail = "; ".join([l for l in out.splitlines() if "rror" in l or "FAIL" in l][-3:])
        return record(idg, a.title, 0, "front-end not byte-exact", tail[:160])
    print(f"[sweep] {idg}: L1 byte-exact")

    # ---- 4. scaffold app ----
    rc, out = run([sys.executable, str(HERE / "scaffold_app.py"), "--game", idg, "--title", a.title,
                   "--internal", internal, "--hash", xxh, "--entrypoint", ep, "--sha1", sha1,
                   "--save-type", a.savetype, "--force"])
    if not (app / "RecompiledFuncs").exists():
        return record(idg, a.title, 1, "scaffold failed", out.splitlines()[-1][:120] if out else "")

    # ---- 5. SEGMENT + REFINE to a linked app ----
    # The first front-end ran disassemble_all (byte-exact, all-funcs toml). Preserve it as the template, then
    # segment_refine.py drives the build-error-feedback loop: gen_segmented (classify + reachability +
    # force-code/force-data) → re-splat (data emitted as data) → recomp (+auto-stub recomp-abort data) →
    # build → feed undefined-label targets (force-code) & malformed funcs (force-data) back → re-segment,
    # until the app links. The C compiler is ground truth for the last code/data ambiguities.
    import shutil as _sh
    def regen(): run([sys.executable, str(HERE / "gen_toml.py"), idg])   # SINGLE SOURCE (self-resolves game dir)
    regen()                                              # disassemble_all toml (all funcs)
    _sh.copy(fe / f"{idg}.yaml", fe / f"{idg}_full.yaml")
    _sh.copy(fe / f"{idg}.toml", fe / f"{idg}_full.toml")
    # add app to the sweep master (idempotent) + configure so the target exists
    cml = SWEEP_CML.read_text(encoding="utf-8")
    addline = f"add_subdirectory(../{idg}pc {idg}pc)"
    if addline not in cml:
        cml = cml.replace("# >>> SWEEP_APPS (the sweep appends add_subdirectory lines below this marker) <<<",
                          "# >>> SWEEP_APPS (the sweep appends add_subdirectory lines below this marker) <<<\n"
                          f"{addline}   # {a.title}")
        SWEEP_CML.write_text(cml, encoding="utf-8", newline="\n")
    run([CMAKE, "-S", str(N64PC / "sweep"), "-B", str(N64PC / "sweep" / "build")], timeout=600)
    rc, out = run([sys.executable, str(HERE / "tools" / "segment_refine.py"), "--basename", idg,
                   "--fe-dir", str(fe), "--app", f"{idg}pc",
                   "--full-yaml", str(fe / f"{idg}_full.yaml"), "--full-toml", str(fe / f"{idg}_full.toml"),
                   "--recomp", str(RECOMP_EXE), "--cmake", CMAKE, "--sweep", str(N64PC / "sweep"),
                   "--entrypoint", ep, "--vram", ep, "--max", "20", "--cap", str(a.cap)], timeout=10800)
    tail = "; ".join(out.splitlines()[-2:])[:160]
    if list((N64PC / "sweep" / "build").rglob(f"{idg}pc.exe")) and "LINKED" in out:
        return record(idg, a.title, 3, "", "BUILDS (segmented)")
    return record(idg, a.title, 2, "segment_refine did not converge", tail)

if __name__ == "__main__":
    sys.exit(main() or 0)
