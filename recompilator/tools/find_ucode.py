#!/usr/bin/env python3
"""find_ucode.py - locate a cartridge's OWN audio microcode and write the config to recompile it.

    py -3 recompilator/tools/find_ucode.py --rom baserom.z64 --out aspMain.toml

WHY THIS EXISTS (2026-09-07, found because Army Men Sarge's Heroes played with no sound)
------------------------------------------------------------------------------------------------
Every game tree was getting the SAME rsp/aspMain.cpp, copied from a reference tree by
scaffold_app rather than recompiled from the cartridge. Many carts carry the same stock SDK
audio microcode, so the copy was right for them by luck - Castlevania, 40 Winks and Super
Mario 64 all carry byte-identical microcode. Army Men carries a different revision, so it got
another game's audio code, and the result was silence with no error anywhere.

The copy was also a compliance problem: that file is 138 KB of C recompiled from a cartridge's
microcode, and it shipped in both published artifacts, while the README promises that no code
derived from any ROM ships. The audit missed it because it looks for ROM header magic, group-4
names and byte-array dumps, and a generated function body is none of those.

One fix serves both. Find the microcode in the user's own cartridge, recompile it on their
machine, and ship no microcode C at all.

HOW EACH VALUE IS FOUND, from the cart alone
--------------------------------------------
ENTRY   The audio microcode's preamble loads the OSTask's ucode_data pointer and size from task
        offsets 0x30 and 0x34 into $gp and $k1. That pair is the SDK's task layout - the same
        class of fact as `addiu $sp` being a function prologue - and it appears exactly once in
        every cart measured. Revisions differ in what precedes it (Castlevania loads two
        immediates first, Army Men reads SP_STATUS first), so the walk back over those leading
        `addi rX, $zero` / `mfc0` instructions finds the true first byte.

SIZE    Text ends in the zero padding that separates the microcode's code from its data. Take
        the padding's start plus one 8-byte block: enough to carry the trailing block a jump
        target can land in, without reaching into the data. Capped at 0xF80, because IMEM is
        4 KB and the text is loaded at offset 0x80 - a hardware bound, not a guess.

ADDRESS 0x04001080 always. Audio and graphics microcode is DMA'd into IMEM at offset 0x80,
        past the 0x80-byte task header, and the jump targets are IMEM-absolute. With the wrong
        base every indirect dispatch lands 32 instructions past its handler.

TARGETS EVERY 4-aligned address in the text. The dispatch is an indirect jump the recompiler
        cannot follow, so it must be told where such a jump can land. Finding the actual table
        by pattern was a losing game - it has empty slots, trailing out-of-range values, and
        every similarity measure tried was beaten by unrelated data elsewhere in the cart. A
        jump can only land inside this microcode's text and the text is under 4 KB, so name
        them all: nothing guessed, nothing missed.

MEASURED 2026-09-07, against the config that was written by hand earlier the same day:

    Castlevania    ROM 0x091D30  size 0xE20    offset and size exact
    40 Winks       ROM 0x0823F0  size 0xE20    same microcode as Castlevania, byte for byte
    Mario          ROM 0x0E7740  size 0xE20    same microcode as Castlevania, byte for byte
    Army Men       ROM 0x075FE0  size 0xC5C    a DIFFERENT revision; confirmed against the
                                               OSTask the game itself submits at runtime
                                               (ucode=0x000753E0, which is this ROM offset)
"""
import argparse
import os
import struct
import subprocess
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

# The OSTask fields the audio microcode's preamble loads: ucode_data and its size, at task
# offsets 0x30/0x34, into $gp and $k1. lw $gp,0x30($at) / lw $k1,0x34($at).
PREAMBLE = (0x8C3C0030, 0x8C3B0034)
TEXT_ADDRESS = 0x04001080      # IMEM base + the 0x80-byte task header. Hardware.
IMEM_TEXT_MAX = 0xF80          # 4 KB of IMEM less that header.
MIN_TABLE = 8                  # a run this long of in-range halfwords is a dispatch table


def word(rom, off):
    return struct.unpack(">I", rom[off:off + 4])[0]


def half(rom, off):
    return struct.unpack(">H", rom[off:off + 2])[0]


def find_entry(rom, lo=0x1000):
    """Every ROM offset where the audio microcode's preamble begins."""
    out = []
    for o in range(lo, len(rom) - 8, 4):
        if word(rom, o) == PREAMBLE[0] and word(rom, o + 4) == PREAMBLE[1]:
            s = o
            while s - 4 >= lo:                       # back over the revision's own preamble
                x = word(rom, s - 4)
                op, rs = x >> 26, (x >> 21) & 31
                if (op == 0x08 and rs == 0) or (op == 0x10 and rs == 0):
                    s -= 4
                else:
                    break
            out.append(s)
    return out


def text_size(rom, start, cap=IMEM_TEXT_MAX):
    o = start
    while o < start + cap - 4:
        if word(rom, o) == 0 and word(rom, o + 4) == 0:
            return (o - start) + 8
        o += 4
    return cap


def find_targets(rom, size):
    """EVERY 4-aligned address in the microcode's own text.

    The command dispatch is an indirect jump through a table in the microcode's data, which the
    recompiler cannot follow, so it has to be told where those jumps can land. Finding the table
    by pattern was a losing game: it has empty slots for unused commands, trailing values outside
    the text, and a cartridge is full of other data that scores better on any similarity measure I
    tried. Army Men Sarge's Heroes is what proved it - a wrong table let the build succeed and then
    aspMain returned UnhandledJumpTarget every frame, which is silence with no error.

    So do not look for the table. A jump can only land on an instruction inside this microcode's
    text, and the text is small (under 4 KB, an IMEM bound), so name them all. RSPRecomp accepts
    the lot and emits a larger file with a label per instruction - about 690 KB instead of 128 KB
    on Castlevania, compiled once, on a machine that has just compiled several thousand functions.
    Nothing is guessed and nothing can be missed.
    """
    base = TEXT_ADDRESS & 0xFFFF
    return list(range(base, base + size, 4))


STUB_MARK = "No audio microcode was recognised"   # what the give-up stub says; grep for it


def extra_sources(tree, rom_path):
    """Byte sources OTHER than the raw cartridge that may carry this cart's audio microcode.

    WHY THIS EXISTS (2026-09-08, found because a playtest of the release showed six carts were
    silent). find_entry scans the cartridge. That works only for a cart that stores its microcode
    UNCOMPRESSED. Killer Instinct Gold does not: its audio microcode is the stock SDK revision,
    byte-identical to Castlevania's, and not one 16-byte run of it appears anywhere in its 12 MB
    ROM. The game unpacks it into RDRAM at boot, and the OSTask it submits at runtime points at
    0x00043BF0 - which is exactly where the preamble sits in a RAM capture of that game.

    So the detector was never wrong; it was being handed bytes that do not contain the answer.
    Anything that holds the cart's memory AFTER it has unpacked itself is a valid source: a RAM
    snapshot the overlay recipe already captured, or one the engine wrote via RECOMP_UCODE_DUMP.
    This is packer-agnostic on purpose - it needs to know nothing about Rare's compression, or
    Factor 5's, or Yaz0.

    Ordered biggest-first: a full 8 MB RDRAM image is likelier to hold the microcode than a
    partial overlay capture.
    """
    out = []
    named = []
    rom_abs = os.path.abspath(rom_path)
    # The stub's own capture, first and by name. It is ~8 KB - far below the floor a memory
    # image has to clear - because it holds the microcode and nothing else.
    cap = os.path.join(tree, "aspMain_capture.bin")
    if os.path.isfile(cap):
        named.append(cap)
    # ONLY THIS GAME'S OWN DIRECTORIES. Never the parent: sibling trees sit there, and
    # picking up another cart's microcode is precisely the silent-and-wrong failure this
    # whole tool exists to end (Army Men Sarge's Heroes, 2026-09-07).
    for d in (tree, os.path.join(tree, "build")):
        if not os.path.isdir(d):
            continue
        for name in sorted(os.listdir(d)):
            if not name.lower().endswith(".bin"):
                continue
            full = os.path.join(d, name)
            if not os.path.isfile(full) or os.path.abspath(full) == rom_abs:
                continue
            size = os.path.getsize(full)
            if size < 0x10000:            # too small to be a memory image
                continue
            out.append((size, full))
    out.sort(reverse=True)
    return named + [f for _, f in out]


def detect(rom, log=None, lo=0x1000):
    """Return {rom, size, targets} for the cart's audio microcode, or None."""
    def say(m):
        if log:
            log(m)
    hits = find_entry(rom, lo=lo)
    if not hits:
        say("no audio microcode preamble found in this cartridge")
        return None
    if len(hits) > 1:
        say("%d microcode preambles found (0x%s); taking the first"
            % (len(hits), ", 0x".join("%X" % h for h in hits)))
    start = hits[0]
    size = text_size(rom, start)
    targets = find_targets(rom, size)
    say("audio microcode at ROM 0x%06X, text 0x%X bytes, %d dispatch target(s)"
        % (start, size, len(targets)))
    return {"rom": start, "size": size, "targets": targets}


def write_toml(info, rom_name, out_path, output_cpp):
    NL = chr(10)
    t = []
    t.append("# aspMain: THIS CARTRIDGE'S OWN audio microcode, located by tools/find_ucode.py.")
    t.append("# Every value below is read out of the cartridge - see that file for how each is found.")
    t.append("# The recompiled microcode is derived from the cart and is never shipped; it is made")
    t.append("# here, on this machine, from the cart the user owns.")
    t.append("text_offset = 0x%X" % info["rom"])
    t.append("text_size = 0x%X" % info["size"])
    t.append("text_address = 0x%08X" % TEXT_ADDRESS)
    t.append('rom_file_path = "%s"' % rom_name)
    t.append('output_file_path = "%s"' % output_cpp)
    t.append('output_function_name = "aspMain"')
    if info["targets"]:
        t.append("")
        t.append("# the command dispatch table, which the recompiler cannot follow statically")
        t.append("extra_indirect_branch_targets = [")
        for i in range(0, len(info["targets"]), 8):
            t.append("    " + ", ".join("0x%X" % x for x in info["targets"][i:i + 8]) + ",")
        t.append("]")
    t.append("")
    with open(out_path, "w", encoding="utf-8", newline=NL) as f:
        f.write(NL.join(t))


def emit(rom_path, tree, app, rspx, log=print):
    """FIND THE CART'S MICROCODE AND PRODUCE rsp/aspMain.cpp, or a no-op that says why not.

    ONE implementation for BOTH build paths. The blind bring-up learned to do this on 2026-09-07,
    when the single shared recompiled microcode stopped being copied into every tree. The RECIPE
    path did not learn it, so a recipe carrying no microcode config linked against nothing and died
    on `undefined symbol: aspMain` - Ocarina of Time and AeroGauge, found the same evening.
    A fix applied in one caller and not the other is the same bug twice.

    Returns a one-line note for the build stage to print.
    """
    NL = chr(10)
    BS = chr(92)
    rom = open(rom_path, "rb").read()
    info = detect(rom, log=lambda m: log("[ucode] " + m))
    source_name = os.path.basename(rom_path)
    if info is None:
        # THE CART DOES NOT STORE IT AS BYTES. Look in anything that holds this game's memory
        # after it has unpacked itself - see extra_sources() for why this is the right move and
        # not a workaround.
        for cand in extra_sources(tree, rom_path):
            with open(cand, "rb") as f:
                blob = f.read()
            found = detect(blob, log=None, lo=0)
            if found:
                info = found
                # RELATIVE TO THE TOML, not a bare file name. extra_sources() also looks under
                # <tree>/build/, and RSPRecomp resolves rom_file_path against the config's own
                # directory (rsp_recomp.cpp read_config: basedir / value) - so a bare name for a
                # file one level down names a file that does not exist, and build_entry's
                # normaliser then fell back to baserom.z64 at this offset (2026-09-08 review).
                source_name = os.path.relpath(cand, tree).replace(os.sep, "/")
                log("[ucode] not in the cartridge as bytes (it is packed); found it in %s"
                    % source_name)
                log("[ucode] audio microcode at 0x%06X of that image, text 0x%X bytes, %d target(s)"
                    % (info["rom"], info["size"], len(info["targets"])))
                break
    rsp_dir = os.path.join(app, "rsp")
    os.makedirs(rsp_dir, exist_ok=True)
    out_cpp = os.path.join(rsp_dir, "aspMain.cpp")

    if info is None:
        # NOT FOUND ANYWHERE ON DISK - SO CAPTURE IT WHILE THE GAME IS RUNNING.
        #
        # A cart that packs its audio microcode has no copy of it in the ROM, and a machine that
        # has never run the game has no memory image either. But the game itself unpacks it, and
        # the OSTask it submits points straight at it: aspMain is handed `ucode_addr`, so at the
        # moment this stub is called the bytes ARE in RDRAM, at a known address.
        #
        # So the stub is not a dead end any more. It writes the microcode out beside the tree,
        # where extra_sources() will find it on the next build, and says so. One silent run, then
        # sound - with no knowledge of Rare's packer, Factor 5's, or Yaz0, and no engine change.
        # Killer Instinct Gold, 2026-09-08.
        cap = os.path.join(os.path.abspath(tree), "aspMain_capture.bin").replace(BS, "/")
        stub = NL.join([
            '#include "librecomp/rsp.hpp"',
            "#include <cstdio>",
            "",
            "// No audio microcode was recognised in this cartridge. Written by tools/find_ucode.py.",
            "// On the first audio task this captures the microcode out of RDRAM, where the game has",
            "// just unpacked it, so the NEXT build of this game can recompile it and have sound.",
            "RspExitReason aspMain(uint8_t* rdram, uint32_t ucode_addr) {",
            "    static bool done = false;",
            "    if (!done) {",
            "        done = true;",
            '        const char* path = "%s";' % cap,
            "        uint32_t phys = ucode_addr & 0x00FFFFFFu;",
            "        bool wrote = false;",
            "        if (phys != 0 && phys < 0x800000u) {",
            '            if (FILE* f = fopen(path, "wb")) {',
            "                for (uint32_t i = 0; i < 0x2000u && (phys + i) < 0x800000u; i++) {",
            "                    fputc(rdram[(phys + i) ^ 3], f);   // ^3 = back to cartridge byte order",
            "                }",
            "                fclose(f);",
            "                wrote = true;",
            "            }",
            "        }",
            "        if (wrote) {",
            '            fprintf(stderr, "[rsp] this cart packs its audio microcode, so this build has '
            'no sound.' + BS + 'n"',
            '                            "[rsp] captured it from RDRAM 0x%08X -> %s' + BS + 'n"',
            '                            "[rsp] BUILD THIS GAME AGAIN and it will have sound.' + BS + 'n",',
            "                            ucode_addr, path);",
            "        } else {",
            '            fprintf(stderr, "[rsp] this cartridge audio microcode was not recognised - '
            'no sound' + BS + 'n");',
            "        }",
            "    }",
            "    return RspExitReason::Broke;",
            "}",
            "",
        ])
        with open(out_cpp, "w", encoding="utf-8", newline=NL) as f:
            f.write(stub)
        return ("NO AUDIO: no audio microcode found in this cart or in any memory image beside "
                "it - the game will build and play SILENT")

    toml_path = os.path.join(tree, "aspMain.toml")
    rel_out = "../" + os.path.basename(os.path.abspath(app)) + "/rsp/aspMain.cpp"
    write_toml(info, source_name, toml_path, rel_out)
    if not rspx or not os.path.isfile(rspx):
        return "found this cart's audio microcode but no RSPRecomp.exe to build it"
    before = os.path.getmtime(out_cpp) if os.path.exists(out_cpp) else 0
    subprocess.run([rspx, toml_path], cwd=tree, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    # RSPRecomp's exit code is not to be trusted; judge by the artifact.
    if not os.path.exists(out_cpp) or os.path.getmtime(out_cpp) <= before:
        raise SystemExit("RSPRecomp wrote nothing (expected %s)" % out_cpp)
    where = ("ROM 0x%06X" % info["rom"] if source_name == os.path.basename(rom_path)
             else "0x%06X of %s (packed in the cart)" % (info["rom"], source_name))
    return ("this cart's own audio microcode, recompiled here: %s, %d bytes of text"
            % (where, info["size"]))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rom", required=True)
    ap.add_argument("--out", default=None, help="write a RSPRecomp config here")
    ap.add_argument("--rom-name", default="baserom.z64", help="rom_file_path to record in the config")
    ap.add_argument("--output-cpp", default="rsp/aspMain.cpp",
                    help="output_file_path to record. RSPRecomp CRASHES on a bare filename with no "
                         "directory component, so keep a directory in it.")
    ap.add_argument("--emit", action="store_true",
                    help="find it AND produce <app>/rsp/aspMain.cpp, or a no-op saying why not")
    ap.add_argument("--tree", default=None, help="--emit: the game front-end tree")
    ap.add_argument("--app", default=None, help="--emit: the <game>pc tree")
    ap.add_argument("--rspx", default=None, help="--emit: path to RSPRecomp.exe")
    a = ap.parse_args()
    if a.emit:
        if not (a.tree and a.app):
            print("--emit needs --tree and --app")
            return 2
        print(emit(a.rom, a.tree, a.app, a.rspx))
        return 0
    rom = open(a.rom, "rb").read()
    info = detect(rom, log=lambda m: print("[ucode] " + m))
    if not info:
        return 1
    if a.out:
        write_toml(info, a.rom_name, a.out, a.output_cpp)
        print("[ucode] wrote %s" % a.out)
    return 0


if __name__ == "__main__":
    sys.exit(main())
