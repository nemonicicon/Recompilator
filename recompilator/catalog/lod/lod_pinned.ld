/* lod_pinned.ld — SESSION 44: the byte-exact pinned linker script.
 *
 * splat's generated lod.ld derives placement by FLOW (__romPos accumulation),
 * but mips-gas pads every section's size up to its 16-byte alignment
 * (common .text true 0x4C0F8 -> object 0x4C100, common_data 0xAF08 -> 0xAF10),
 * so everything downstream of a non-16-aligned subsegment shifts (+8 data,
 * +0x10 assets). N64Recomp reconstructs context.rom from these placements:
 * the shift made every jump table above rom 0x10D0F8 unreadable (the entire
 * 39-stub "Failed to determine size of jump table" class) and resolved %lo()
 * data immediates 8 bytes off the real ROM.
 *
 * Fix: the recon (lod.yaml) is ground truth — PIN every subsegment at its
 * exact vma/rom address instead of flowing. Assembler pad bytes at section
 * tails then OVERLAP the next section's start by design; sections are listed
 * in ascending rom order, and both N64Recomp's elf.cpp and verify_rom_match.py
 * copy sections in order, so the later section's real bytes overwrite the
 * earlier section's zero padding. Link with --no-check-sections (already
 * required by the self-healing pass). tools/verify_rom_match.py is the hard
 * gate proving the reconstruction is byte-exact.
 *
 * Layout (lod.yaml / SESSION 43 recon):
 *   header      rom 0x0       vma 0x0
 *   ipl3        rom 0x40      vma 0x40
 *   entry       rom 0x1000    vma 0x80000400
 *   main text   rom 0x1060    vma 0x80000460
 *   main data   rom 0xACF60   vma 0x800AC360   (contiguous delta)
 *   common text rom 0xC1000   vma 0x80140750
 *   common data rom 0x10D0F8  vma 0x8018C848   (contiguous delta)
 *   assets      rom 0x118000  vma 0x80197750   (contiguous delta — the static
 *               data region provably extends past 0x118000: jtbl 0x8019C330
 *               lives at rom 0x11CBE0 with this exact mapping)
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

    .entry 0x80000400 : AT(0x00001000)
    {
        FILL(0x00000000);
        build/asm/entry.s.o(.text);
        build/asm/entry.s.o(.data);
        build/asm/entry.s.o(.rodata);
    }
    .entry_bss (NOLOAD) :
    {
        build/asm/entry.s.o(.bss);
    }

    .main 0x80000460 : AT(0x00001060)
    {
        FILL(0x00000000);
        build/asm/main.s.o(.text);
        build/asm/main.s.o(.rodata);
    }
    .main_data 0x800AC360 : AT(0x000ACF60)
    {
        FILL(0x00000000);
        build/asm/data/main_data.data.s.o(.data);
    }
    .main_bss (NOLOAD) :
    {
        build/asm/main.s.o(.bss);
    }

    .common 0x80140750 : AT(0x000C1000)
    {
        FILL(0x00000000);
        build/asm/common.s.o(.text);
        build/asm/common.s.o(.rodata);
    }
    .common_data 0x8018C848 : AT(0x0010D0F8)
    {
        FILL(0x00000000);
        build/asm/data/common_data.data.s.o(.data);
    }
    .common_bss (NOLOAD) :
    {
        build/asm/common.s.o(.bss);
    }

    .assets 0x80197750 : AT(0x00118000)
    {
        FILL(0x00000000);
        build/assets/assets.bin.o(.data);
    }

    /DISCARD/ :
    {
        *(*);
    }
}
