SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80001394 0x80001394 : AT(0x00001F94) { FILL(0x00000000); build/asm/main_80001394.s.o(.text); build/asm/main_80001394.s.o(.rodata); build/asm/main_80001394.s.o(.data); }
    .main_80001394_bss (NOLOAD) : { build/asm/main_80001394.s.o(.bss); }
    .main_80001C00 0x80001C00 : AT(0x00002800) { FILL(0x00000000); build/asm/main_80001C00.s.o(.text); build/asm/main_80001C00.s.o(.rodata); build/asm/main_80001C00.s.o(.data); }
    .main_80001C00_bss (NOLOAD) : { build/asm/main_80001C00.s.o(.bss); }
    .main_80003E00 0x80003E00 : AT(0x00004A00) { build/asm/data/main_80003E00.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
