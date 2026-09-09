/* sm64_pinned.ld — the byte-exact pinned linker script (the SESSION 44 lesson,
 * applied from day one for game #3).
 *
 * splat's generated script places subsegments by FLOW (__romPos accumulation),
 * but mips-gas pads section sizes to 16-byte alignment, shifting everything
 * downstream of any non-16-aligned subsegment. N64Recomp reconstructs
 * context.rom from ELF placements (elf.cpp: rom = paddr + (sh_offset - seg.offset));
 * a shifted placement silently diverges jump tables and %lo() immediates from
 * hardware. So: the recon (sm64.yaml) is ground truth — PIN every subsegment at
 * its exact vma/rom. Assembler pad tails overlap the next section's head by
 * design; sections are listed in ascending rom order and both N64Recomp's
 * elf.cpp and verify_rom_match.py copy in order, so real bytes overwrite pad
 * zeros. Link with --no-check-sections. tools/verify_rom_match.py is the hard
 * gate proving byte-exactness.
 *
 * Layout (sm64.yaml recon):
 *   header       rom 0x0        vma 0x0
 *   ipl3         rom 0x40       vma 0x40
 *   main text    rom 0x1000     vma 0x80246000
 *   main data    rom 0xE78A0    vma 0x8032C8A0   (contiguous delta)
 *   lib text     rom 0xF5580    vma 0x80378800   (the audio library segment)
 *   lib data     rom 0x102D08   vma 0x80385F88   (contiguous delta)
 *   assets1      rom 0x108A40   vma 0x8038BCC0   (contiguous from lib)
 *   goddard text rom 0x21F4C0   vma 0x8016F000
 *   goddard data rom 0x257CF0   vma 0x801A7830   (contiguous delta)
 *   assets2      rom 0x26A3A0   vma 0x801B9EE0   (contiguous delta; vma overlap
 *                with main is harmless — only rom (AT) placement feeds context.rom,
 *                and asset blobs carry no symbols)
 */
SECTIONS
{
    _gp = 0x0;

    .header 0x00000000 : AT(0x00000000)
    {
        FILL(0x00000000);
        build/asm/header.s.o(.data);
    }

    .ipl3 0x00000040 : AT(0x00000040)
    {
        FILL(0x00000000);
        build/assets/ipl3.bin.o(.data);
    }

    .main 0x80246000 : AT(0x00001000)
    {
        FILL(0x00000000);
        build/asm/main.s.o(.text);
        build/asm/main.s.o(.rodata);
    }
    .main_data 0x8032C8A0 : AT(0x000E78A0)
    {
        FILL(0x00000000);
        build/asm/data/main_data.data.s.o(.data);
    }
    .main_bss (NOLOAD) :
    {
        build/asm/main.s.o(.bss);
    }

    .lib 0x80378800 : AT(0x000F5580)
    {
        FILL(0x00000000);
        build/asm/lib.s.o(.text);
        build/asm/lib.s.o(.rodata);
    }
    .lib_data 0x80385F88 : AT(0x00102D08)
    {
        FILL(0x00000000);
        build/asm/data/lib_data.data.s.o(.data);
    }
    .lib_bss (NOLOAD) :
    {
        build/asm/lib.s.o(.bss);
    }

    .assets1 0x8038BCC0 : AT(0x00108A40)
    {
        FILL(0x00000000);
        build/assets/assets1.bin.o(.data);
    }

    .goddard 0x8016F000 : AT(0x0021F4C0)
    {
        FILL(0x00000000);
        build/asm/goddard.s.o(.text);
        build/asm/goddard.s.o(.rodata);
    }
    .goddard_data 0x801A7830 : AT(0x00257CF0)
    {
        FILL(0x00000000);
        build/asm/data/goddard_data.data.s.o(.data);
    }
    .goddard_bss (NOLOAD) :
    {
        build/asm/goddard.s.o(.bss);
    }

    .assets2 0x801B9EE0 : AT(0x0026A3A0)
    {
        FILL(0x00000000);
        build/assets/assets2.bin.o(.data);
    }

    /DISCARD/ :
    {
        *(*);
    }
}
