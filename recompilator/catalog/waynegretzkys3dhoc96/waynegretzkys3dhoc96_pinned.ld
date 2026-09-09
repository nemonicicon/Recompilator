SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80001C00 0x80001C00 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80001C00.s.o(.text); build/asm/main_80001C00.s.o(.rodata); build/asm/main_80001C00.s.o(.data); }
    .main_80001C00_bss (NOLOAD) : { build/asm/main_80001C00.s.o(.bss); }
    .assets 0x80400400 : AT(0x000C0000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
