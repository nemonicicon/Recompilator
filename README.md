# Recompilator

Static recompilation of n64 games.

## About this project and AI

Heavy use of AI.  Sonnet then opus then fable

## How get?

Download the release, one download, one program. point it at your cart reader or archive.

**Requirements:** Windows 10 or 11, 64-bit; a GPU with DirectX 12; about 1 GB of disk for
the program and around 100 MB for each game you build; a ROM of a game you own.

## What the build does

| stage |          what happens |
|---|---|
| RECOGNISED |           the ROM is identified from its own header and hashes: internal name, entry point, boot chip, region |
| BRING-UP |             the layout of the cartridge is worked out by reading it: where its code begins, which parts are data, which library functions it links |
| BYTE-EXACT ELF |       the ROM is split into segments and reassembled, and the result must match your ROM **byte for byte** before anything else runs. A mismatch stops the build and says so. |
| SEGMENTATION |         the code/data boundary is refined until the recompiler and the compiler are both clean |
| SYMBOLS + RECOMPILER | the operating-system layer is recognised by shape and bound to the engine; the game's own code is translated to C |
| RSP MICROCODE |        the cartridge's own audio and graphics microcode, recompiled the same way |
| COMPILE |              the emitted C is compiled and linked into a game module |
| RESULT |               the module is ready to play, and the line says how much of the cartridge was recompiled |

A game that stops at a stage stops loudly: the screen names the stage and the reason, and the
log it wrote. Nothing half-built is ever reported as a build.

## What is here, and what is not

* **No ROMs. No game assets. No cartridge code or data of any kind.**
* **No decompilations.**
* **The library signature database** (`recompilator/data/libultra_sigdb.json`) is how the
  program recognises the console's operating-system functions inside a cartridge. It holds, per
  library function, one-way hashes of its instruction *shape*, the positions and names of the
  functions it calls, and its constants under a key that only a matching body can derive.
  It contains no instruction words and nothing in it can be turned back into code. It was made
  on the author's machine from reference builds of the library, which are not distributed.



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
