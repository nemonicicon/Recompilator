/* waverace_pinned.ld — byte-exact pinned linker script (the SESSION 44 lesson).
 * Each subsegment PINNED at its recon-exact vma/rom (yaml = ground truth); assembler pad
 * tails overlap the next section's head by design (ascending rom order, real bytes overwrite
 * pad zeros). Link --no-check-sections; tools/verify_rom_match.py is the gate.
 *
 *   header        rom 0x0       vma 0x0
 *   ipl3 (bin)    rom 0x40      vma 0x40
 *   main text     rom 0x1000    vma 0x80046800   (delta 0x80045800, resident image)
 *   main bss      (NOLOAD)      vma 0x800EEB30
 *   assets (bin)  rom 0xA9330   (no symbols; AT placement only feeds context.rom)
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

    .main 0x80046800 : AT(0x00001000)
    {
        FILL(0x00000000);
        build/asm/main.s.o(.text);
        build/asm/main.s.o(.rodata);
    }
    .main_bss (NOLOAD) :
    {
        build/asm/main.s.o(.bss);
    }

    .ovl00 0x801DAD00 : AT(0x000A9330)
    {
        FILL(0x00000000);
        build/asm/ovl00.s.o(.text);
        build/asm/ovl00.s.o(.rodata);
    }
    .ovl00_bss (NOLOAD) :
    {
        build/asm/ovl00.s.o(.bss);
    }

    .assets 0x80400000 : AT(0x000F5E50)
    {
        FILL(0x00000000);
        build/assets/assets.bin.o(.data);
    }

    /DISCARD/ :
    {
        *(*);
    }
}
