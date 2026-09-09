# Recompilator

A program that statically recompiles an N64 ROM **you already own** into a native Windows
program, and plays it. One window, one program: add a ROM, build it, play it.

This is not an emulator. Your ROM's MIPS code is translated into C, compiled to native x86-64,
and runs directly on your CPU; graphics go through [RT64](https://github.com/rt64/rt64). The
result is a real Windows program for that game, built on your machine, from your cartridge.

## About this project and AI

<!-- AUTHOR: put this paragraph in your own words. The facts below are accurate. -->
This project was built with heavy use of AI assistance (Anthropic's Claude), directed, reviewed
and tested by its author. That includes the engine work, the build pipeline and the tools.
Nothing here was generated and shipped unverified: every engine change is checked against a
fixed set of games running on screen before it is kept. The author is responsible for all of it.

## Get it

1. Download the newest `Recompilator-<version>.zip` from the
   [Releases](../../releases) page. This repository is the source; the zip is the program.
2. Unzip it anywhere you have write access. Everything lives inside that folder.
3. Run `Recompilator.exe`.

Windows may show *"Windows protected your PC"* the first time, because the program is not
code-signed. Choose *More info* and then *Run anyway*.

**Requirements:** Windows 10 or 11, 64-bit; a GPU with DirectX 12; about 1 GB of disk for
the program and around 100 MB for each game you build; a ROM of a game you own, as `.z64`,
`.n64`, `.v64` or a `.zip` holding one. Nothing else has to be installed: the compiler, the
assembler and the recompiler ship inside the zip.

## Using it

1. **ADD ROM** (press `A`, or select it): pick your file. The program reads the cartridge's
   own header and tells you what it is.
2. **BUILD** (`Enter`): the pipeline runs, stage by stage, on the screen. A build takes one to
   four minutes on a modern desktop. It is kept, so playing again later is immediate.
   If the program ships a *recipe* for that cartridge, `Enter` builds from it and `B` builds
   **blind** instead, from the cartridge alone. The choice is yours, per game, and both builds
   are kept side by side.
3. **PLAY** (`Enter` on a built game): the game runs in the same window.
4. **`Esc`** leaves a game after a yes/no. `F1` opens the renderer's own options while playing.

Games you build are stored in `archive/` next to the program. Saves and the game's Controller
Pak live under `%APPDATA%\<game>pc\`.

**Controls.** A game controller is used if Windows sees one: the D-pad, A, B, Start, the
bumpers for L and R, *Back* for Z, the left stick for the control stick and the right stick for
the C buttons. On the keyboard: arrows for the D-pad, `W A S D` for the control stick, `Z` for A,
`X` for B, `Left Shift` for Z, `Enter` for Start. In the menus: arrows move, `Enter` selects,
`Esc` goes back, `A` adds a ROM, `B` builds blind on the ADD ROM screen, `Q` quits.

## What the build does

| stage | what happens |
|---|---|
| RECOGNISED | the ROM is identified from its own header and hashes: internal name, entry point, boot chip, region |
| BRING-UP | the layout of the cartridge is worked out by reading it: where its code begins, which parts are data, which library functions it links |
| BYTE-EXACT ELF | the ROM is split into segments and reassembled, and the result must match your ROM **byte for byte** before anything else runs. A mismatch stops the build and says so. |
| SEGMENTATION | the code/data boundary is refined until the recompiler and the compiler are both clean |
| SYMBOLS + RECOMPILER | the operating-system layer is recognised by shape and bound to the engine; the game's own code is translated to C |
| RSP MICROCODE | the cartridge's own audio and graphics microcode, recompiled the same way |
| COMPILE | the emitted C is compiled and linked into a game module |
| RESULT | the module is ready to play, and the line says how much of the cartridge was recompiled |

A game that stops at a stage stops loudly: the screen names the stage and the reason, and the
log it wrote. Nothing half-built is ever reported as a build.

## What is here, and what is not

* **No ROMs. No game assets. No cartridge code or data of any kind.** Not in this repository,
  not in a release, not in any artifact published anywhere. Nothing here runs without a
  cartridge you provide, and everything derived from your cartridge (the split, the symbols,
  the emitted C, the built game) is written to your own folders and stays there.
* **No decompilations.** Nothing in the program depends on one.
* **Recipes.** Some games ship a *recipe*: a short description of how that cartridge is laid
  out. Addresses and names, worked out once and written down, plus the small amount of glue
  every game needs. A recipe holds none of the cartridge and does nothing on its own; it only
  saves your machine from working out again what has already been worked out. Most games have
  no recipe and are built from scratch by reading the cartridge, which is the path every game
  takes the first time. A recipe is never forced on you: where one exists you can build blind
  instead and compare.
* **The library signature database** (`recompilator/data/libultra_sigdb.json`) is how the
  program recognises the console's operating-system functions inside a cartridge. It holds, per
  library function, one-way hashes of its instruction *shape*, the positions and names of the
  functions it calls, and its constants under a key that only a matching body can derive.
  It contains no instruction words and nothing in it can be turned back into code. It was made
  on the author's machine from reference builds of the library, which are not distributed.

## Status

Early, and honest about it. N64 games differ enormously in how they were built, and how far a
given cartridge gets on the first try varies with it. Some boot to gameplay, some reach a title
screen, some stop at a stage the program names for you. The pipeline reports what happened at
every step rather than failing silently, and the engine improves one game at a time.

If a game fails for you, the useful things to note are the cartridge's internal name and
region, the stage it stopped at, and the log the build screen names.

## Building from source

The program is built on Windows with Visual Studio 2022 or newer (the *Desktop development
with C++* workload, which includes CMake and the Windows SDK):

```
cmake -S recompilator/launcher -B recompilator/launcher/build/windows-x64 -G "Visual Studio 17 2022" -A x64
cmake --build recompilator/launcher/build/windows-x64 --config Release
```

The executable lands in `recompilator/launcher/build/windows-x64/Release/`. To build *games*
from a source checkout you also need the toolchain a release carries: copy the `toolchain/`
folder from a release zip next to the source tree, or assemble your own with
`recompilator/tools/make_toolchain.ps1` (its header and `TOOLCHAIN.txt` list every piece).

Pull requests are not accepted. The engine folders are forks kept deliberately at an earlier
upstream point; they are not tracked against upstream and no change here is proposed upstream.

## Licences

* **This project's own code** (the launcher, the pipeline, the tools, the templates):
  **GPL-3.0-or-later**. See `LICENSE`.
* **`engine/rt64`**: MIT (RT64 Contributors). See `engine/rt64/LICENSE`. Its vendored
  dependencies carry their own terms in `engine/rt64/src/contrib`, including the DirectX Shader
  Compiler (University of Illinois/NCSA and LLVM licences), SDL2 (zlib) and mupen64plus-core
  (GPL-2.0, of which only the API headers are used).
* **`engine/runtime/N64Recomp`**: MIT (Wiseguy). See `engine/runtime/N64Recomp/LICENSE`.
* **`engine/runtime`** (N64 Modern Runtime: ultramodern + librecomp): GPL-3.0, per the
  `COPYING` file carried in that folder.
* **Bundled toolchain** (`toolchain/`, in a release only):
  * clang and LLD from [llvm-mingw](https://github.com/mstorsjo/llvm-mingw): Apache-2.0 with
    LLVM exception, plus the mingw-w64 runtime under its own per-file terms.
  * GNU binutils (the MIPS assembler and linker): GPL-3.0-or-later. The matching source
    tarball is attached to every release.
  * Python: PSF licence. splat, spimdisasm and rabbitizer: MIT.
  * Each piece's provenance and hash is listed in `toolchain/TOOLCHAIN.txt`.

## Credits

RT64, N64Recomp and the N64 Modern Runtime made this possible; splat, spimdisasm and
rabbitizer do the disassembly work underneath the pipeline.
