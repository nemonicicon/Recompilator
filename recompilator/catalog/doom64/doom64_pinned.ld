SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main.s.o(.text); build/asm/main.s.o(.rodata); build/asm/main.s.o(.data); }
    .main_bss (NOLOAD) : { build/asm/main.s.o(.bss); }
    .assets 0x80400000 : AT(0x0004d0e4) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
