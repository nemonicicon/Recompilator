/* pilotwings_pinned.ld — byte-exact pinned linker script (the SESSION 44 lesson, day one).
 * Each subsegment PINNED at its recon-exact vma/rom (yaml = ground truth); assembler pad
 * tails overlap the next section's head by design (ascending rom order, real bytes overwrite
 * pad zeros). Link --no-check-sections; tools/verify_rom_match.py is the gate.
 *
 * ONE code segment for the byte-exact milestone (region-2 overlay vram TBD — see yaml):
 *   header        rom 0x0       vma 0x0
 *   ipl3 (bin)    rom 0x40      vma 0x40
 *   main text     rom 0x1000    vma 0x80200000   (delta 0x801FF000, whole code stream)
 *   assets (bin)  rom 0xda000   (no symbols; AT placement only feeds context.rom)
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

    .main 0x80200050 : AT(0x00001000)
    {
        FILL(0x00000000);
        build/asm/main.s.o(.text);
        build/asm/main.s.o(.rodata);
    }
    .main_bss (NOLOAD) :
    {
        build/asm/main.s.o(.bss);
    }

    .overlay 0x802CA900 : AT(0x00051E30)
    {
        FILL(0x00000000);
        build/asm/overlay.s.o(.text);
        build/asm/overlay.s.o(.rodata);
    }
    .overlay_bss (NOLOAD) :
    {
        build/asm/overlay.s.o(.bss);
    }

    .assets 0x80400000 : AT(0x000da000)
    {
        FILL(0x00000000);
        build/assets/assets.bin.o(.data);
    }

    /DISCARD/ :
    {
        *(*);
    }
}
