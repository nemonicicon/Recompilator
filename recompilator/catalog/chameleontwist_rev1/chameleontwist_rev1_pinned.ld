SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80025C00 0x80025C00 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80025C00.s.o(.text); build/asm/main_80025C00.s.o(.rodata); build/asm/main_80025C00.s.o(.data); }
    .main_80025C00_bss (NOLOAD) : { build/asm/main_80025C00.s.o(.bss); }
    .main_80025CC8 0x80025CC8 : AT(0x000010C8) { FILL(0x00000000); build/asm/main_80025CC8.s.o(.text); build/asm/main_80025CC8.s.o(.rodata); build/asm/main_80025CC8.s.o(.data); }
    .main_80025CC8_bss (NOLOAD) : { build/asm/main_80025CC8.s.o(.bss); }
    .main_800D9344 0x800D9344 : AT(0x000B4744) { FILL(0x00000000); build/asm/main_800D9344.s.o(.text); build/asm/main_800D9344.s.o(.rodata); build/asm/main_800D9344.s.o(.data); }
    .main_800D9344_bss (NOLOAD) : { build/asm/main_800D9344.s.o(.bss); }
    .main_800D9710 0x800D9710 : AT(0x000B4B10) { FILL(0x00000000); build/asm/main_800D9710.s.o(.text); build/asm/main_800D9710.s.o(.rodata); build/asm/main_800D9710.s.o(.data); }
    .main_800D9710_bss (NOLOAD) : { build/asm/main_800D9710.s.o(.bss); }
    .main_8010D4C0 0x8010D4C0 : AT(0x000E88C0) { build/asm/data/main_8010D4C0.bin.o(.data); }
    .main_8010E110 0x8010E110 : AT(0x000E9510) { FILL(0x00000000); build/asm/main_8010E110.s.o(.text); build/asm/main_8010E110.s.o(.rodata); build/asm/main_8010E110.s.o(.data); }
    .main_8010E110_bss (NOLOAD) : { build/asm/main_8010E110.s.o(.bss); }
    .assets 0x80425C00 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
