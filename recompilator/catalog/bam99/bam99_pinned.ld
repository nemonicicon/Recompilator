SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000558 0x80000558 : AT(0x00001158) { FILL(0x00000000); build/asm/main_80000558.s.o(.text); build/asm/main_80000558.s.o(.rodata); build/asm/main_80000558.s.o(.data); }
    .main_80000558_bss (NOLOAD) : { build/asm/main_80000558.s.o(.bss); }
    .main_8000056C 0x8000056C : AT(0x0000116C) { build/asm/data/main_8000056C.bin.o(.data); }
    .main_80000584 0x80000584 : AT(0x00001184) { FILL(0x00000000); build/asm/main_80000584.s.o(.text); build/asm/main_80000584.s.o(.rodata); build/asm/main_80000584.s.o(.data); }
    .main_80000584_bss (NOLOAD) : { build/asm/main_80000584.s.o(.bss); }
    .main_80000C70 0x80000C70 : AT(0x00001870) { build/asm/data/main_80000C70.bin.o(.data); }
    .main_80077DC4 0x80077DC4 : AT(0x000789C4) { FILL(0x00000000); build/asm/main_80077DC4.s.o(.text); build/asm/main_80077DC4.s.o(.rodata); build/asm/main_80077DC4.s.o(.data); }
    .main_80077DC4_bss (NOLOAD) : { build/asm/main_80077DC4.s.o(.bss); }
    .main_8007954C 0x8007954C : AT(0x0007A14C) { build/asm/data/main_8007954C.bin.o(.data); }
    .main_800795F8 0x800795F8 : AT(0x0007A1F8) { FILL(0x00000000); build/asm/main_800795F8.s.o(.text); build/asm/main_800795F8.s.o(.rodata); build/asm/main_800795F8.s.o(.data); }
    .main_800795F8_bss (NOLOAD) : { build/asm/main_800795F8.s.o(.bss); }
    .main_80079604 0x80079604 : AT(0x0007A204) { build/asm/data/main_80079604.bin.o(.data); }
    .main_8007D3DC 0x8007D3DC : AT(0x0007DFDC) { FILL(0x00000000); build/asm/main_8007D3DC.s.o(.text); build/asm/main_8007D3DC.s.o(.rodata); build/asm/main_8007D3DC.s.o(.data); }
    .main_8007D3DC_bss (NOLOAD) : { build/asm/main_8007D3DC.s.o(.bss); }
    .main_8007DB70 0x8007DB70 : AT(0x0007E770) { build/asm/data/main_8007DB70.bin.o(.data); }
    .main_80080F10 0x80080F10 : AT(0x00081B10) { FILL(0x00000000); build/asm/main_80080F10.s.o(.text); build/asm/main_80080F10.s.o(.rodata); build/asm/main_80080F10.s.o(.data); }
    .main_80080F10_bss (NOLOAD) : { build/asm/main_80080F10.s.o(.bss); }
    .main_800ACC38 0x800ACC38 : AT(0x000AD838) { build/asm/data/main_800ACC38.bin.o(.data); }
    .main_800AD1A0 0x800AD1A0 : AT(0x000ADDA0) { FILL(0x00000000); build/asm/main_800AD1A0.s.o(.text); build/asm/main_800AD1A0.s.o(.rodata); build/asm/main_800AD1A0.s.o(.data); }
    .main_800AD1A0_bss (NOLOAD) : { build/asm/main_800AD1A0.s.o(.bss); }
    .main_800AF33C 0x800AF33C : AT(0x000AFF3C) { build/asm/data/main_800AF33C.bin.o(.data); }
    .main_800AFCDC 0x800AFCDC : AT(0x000B08DC) { FILL(0x00000000); build/asm/main_800AFCDC.s.o(.text); build/asm/main_800AFCDC.s.o(.rodata); build/asm/main_800AFCDC.s.o(.data); }
    .main_800AFCDC_bss (NOLOAD) : { build/asm/main_800AFCDC.s.o(.bss); }
    .main_800B8204 0x800B8204 : AT(0x000B8E04) { build/asm/data/main_800B8204.bin.o(.data); }
    .main_800B880C 0x800B880C : AT(0x000B940C) { FILL(0x00000000); build/asm/main_800B880C.s.o(.text); build/asm/main_800B880C.s.o(.rodata); build/asm/main_800B880C.s.o(.data); }
    .main_800B880C_bss (NOLOAD) : { build/asm/main_800B880C.s.o(.bss); }
    .main_800B9A54 0x800B9A54 : AT(0x000BA654) { build/asm/data/main_800B9A54.bin.o(.data); }
    .main_800BA288 0x800BA288 : AT(0x000BAE88) { FILL(0x00000000); build/asm/main_800BA288.s.o(.text); build/asm/main_800BA288.s.o(.rodata); build/asm/main_800BA288.s.o(.data); }
    .main_800BA288_bss (NOLOAD) : { build/asm/main_800BA288.s.o(.bss); }
    .main_800BA418 0x800BA418 : AT(0x000BB018) { build/asm/data/main_800BA418.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
