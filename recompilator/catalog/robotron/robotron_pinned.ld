/* robotron_pinned.ld — byte-exact pinned linker script (the SESSION 44 lesson).
 * Each subsegment pinned at its recon-exact vma/rom; link --no-check-sections;
 * tools/verify_rom_match.py is the hard gate. Robotron = clean standard layout:
 *   header        rom 0x0       vma 0x0
 *   ipl3 (bin)    rom 0x40      vma 0x40
 *   main text     rom 0x1000    vma 0x80000400   (delta 0x7FFFF400, whole code+data stream)
 *   assets (bin)  rom 0x79000   (no symbols; AT placement only feeds context.rom)
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

    .main 0x80000400 : AT(0x00001000)
    {
        FILL(0x00000000);
        build/asm/main.s.o(.text);
        build/asm/main.s.o(.rodata);
    }
    .main_bss (NOLOAD) :
    {
        build/asm/main.s.o(.bss);
    }

    .assets 0x80400000 : AT(0x00079000)
    {
        FILL(0x00000000);
        build/assets/assets.bin.o(.data);
    }

    /DISCARD/ :
    {
        *(*);
    }
}
