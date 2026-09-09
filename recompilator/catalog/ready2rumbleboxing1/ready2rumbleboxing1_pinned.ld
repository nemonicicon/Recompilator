SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80026C00 0x80026C00 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80026C00.s.o(.text); build/asm/main_80026C00.s.o(.rodata); build/asm/main_80026C00.s.o(.data); }
    .main_80026C00_bss (NOLOAD) : { build/asm/main_80026C00.s.o(.bss); }
    .main_80029F80 0x80029F80 : AT(0x00004380) { FILL(0x00000000); build/asm/main_80029F80.s.o(.text); build/asm/main_80029F80.s.o(.rodata); build/asm/main_80029F80.s.o(.data); }
    .main_80029F80_bss (NOLOAD) : { build/asm/main_80029F80.s.o(.bss); }
    .main_8002B8D8 0x8002B8D8 : AT(0x00005CD8) { FILL(0x00000000); build/asm/main_8002B8D8.s.o(.text); build/asm/main_8002B8D8.s.o(.rodata); build/asm/main_8002B8D8.s.o(.data); }
    .main_8002B8D8_bss (NOLOAD) : { build/asm/main_8002B8D8.s.o(.bss); }
    .main_8002BC00 0x8002BC00 : AT(0x00006000) { FILL(0x00000000); build/asm/main_8002BC00.s.o(.text); build/asm/main_8002BC00.s.o(.rodata); build/asm/main_8002BC00.s.o(.data); }
    .main_8002BC00_bss (NOLOAD) : { build/asm/main_8002BC00.s.o(.bss); }
    .main_8002BDB0 0x8002BDB0 : AT(0x000061B0) { FILL(0x00000000); build/asm/main_8002BDB0.s.o(.text); build/asm/main_8002BDB0.s.o(.rodata); build/asm/main_8002BDB0.s.o(.data); }
    .main_8002BDB0_bss (NOLOAD) : { build/asm/main_8002BDB0.s.o(.bss); }
    .main_8002E8F4 0x8002E8F4 : AT(0x00008CF4) { FILL(0x00000000); build/asm/main_8002E8F4.s.o(.text); build/asm/main_8002E8F4.s.o(.rodata); build/asm/main_8002E8F4.s.o(.data); }
    .main_8002E8F4_bss (NOLOAD) : { build/asm/main_8002E8F4.s.o(.bss); }
    .main_8002F000 0x8002F000 : AT(0x00009400) { FILL(0x00000000); build/asm/main_8002F000.s.o(.text); build/asm/main_8002F000.s.o(.rodata); build/asm/main_8002F000.s.o(.data); }
    .main_8002F000_bss (NOLOAD) : { build/asm/main_8002F000.s.o(.bss); }
    .main_8003139C 0x8003139C : AT(0x0000B79C) { FILL(0x00000000); build/asm/main_8003139C.s.o(.text); build/asm/main_8003139C.s.o(.rodata); build/asm/main_8003139C.s.o(.data); }
    .main_8003139C_bss (NOLOAD) : { build/asm/main_8003139C.s.o(.bss); }
    .main_80035468 0x80035468 : AT(0x0000F868) { FILL(0x00000000); build/asm/main_80035468.s.o(.text); build/asm/main_80035468.s.o(.rodata); build/asm/main_80035468.s.o(.data); }
    .main_80035468_bss (NOLOAD) : { build/asm/main_80035468.s.o(.bss); }
    .main_80037C50 0x80037C50 : AT(0x00012050) { FILL(0x00000000); build/asm/main_80037C50.s.o(.text); build/asm/main_80037C50.s.o(.rodata); build/asm/main_80037C50.s.o(.data); }
    .main_80037C50_bss (NOLOAD) : { build/asm/main_80037C50.s.o(.bss); }
    .main_80037DF0 0x80037DF0 : AT(0x000121F0) { FILL(0x00000000); build/asm/main_80037DF0.s.o(.text); build/asm/main_80037DF0.s.o(.rodata); build/asm/main_80037DF0.s.o(.data); }
    .main_80037DF0_bss (NOLOAD) : { build/asm/main_80037DF0.s.o(.bss); }
    .main_8003BA34 0x8003BA34 : AT(0x00015E34) { FILL(0x00000000); build/asm/main_8003BA34.s.o(.text); build/asm/main_8003BA34.s.o(.rodata); build/asm/main_8003BA34.s.o(.data); }
    .main_8003BA34_bss (NOLOAD) : { build/asm/main_8003BA34.s.o(.bss); }
    .main_8003BB90 0x8003BB90 : AT(0x00015F90) { FILL(0x00000000); build/asm/main_8003BB90.s.o(.text); build/asm/main_8003BB90.s.o(.rodata); build/asm/main_8003BB90.s.o(.data); }
    .main_8003BB90_bss (NOLOAD) : { build/asm/main_8003BB90.s.o(.bss); }
    .main_8003BC70 0x8003BC70 : AT(0x00016070) { FILL(0x00000000); build/asm/main_8003BC70.s.o(.text); build/asm/main_8003BC70.s.o(.rodata); build/asm/main_8003BC70.s.o(.data); }
    .main_8003BC70_bss (NOLOAD) : { build/asm/main_8003BC70.s.o(.bss); }
    .main_8003D114 0x8003D114 : AT(0x00017514) { FILL(0x00000000); build/asm/main_8003D114.s.o(.text); build/asm/main_8003D114.s.o(.rodata); build/asm/main_8003D114.s.o(.data); }
    .main_8003D114_bss (NOLOAD) : { build/asm/main_8003D114.s.o(.bss); }
    .main_800439A0 0x800439A0 : AT(0x0001DDA0) { FILL(0x00000000); build/asm/main_800439A0.s.o(.text); build/asm/main_800439A0.s.o(.rodata); build/asm/main_800439A0.s.o(.data); }
    .main_800439A0_bss (NOLOAD) : { build/asm/main_800439A0.s.o(.bss); }
    .main_80047EBC 0x80047EBC : AT(0x000222BC) { FILL(0x00000000); build/asm/main_80047EBC.s.o(.text); build/asm/main_80047EBC.s.o(.rodata); build/asm/main_80047EBC.s.o(.data); }
    .main_80047EBC_bss (NOLOAD) : { build/asm/main_80047EBC.s.o(.bss); }
    .main_800487E0 0x800487E0 : AT(0x00022BE0) { FILL(0x00000000); build/asm/main_800487E0.s.o(.text); build/asm/main_800487E0.s.o(.rodata); build/asm/main_800487E0.s.o(.data); }
    .main_800487E0_bss (NOLOAD) : { build/asm/main_800487E0.s.o(.bss); }
    .main_80048F30 0x80048F30 : AT(0x00023330) { FILL(0x00000000); build/asm/main_80048F30.s.o(.text); build/asm/main_80048F30.s.o(.rodata); build/asm/main_80048F30.s.o(.data); }
    .main_80048F30_bss (NOLOAD) : { build/asm/main_80048F30.s.o(.bss); }
    .main_8004C920 0x8004C920 : AT(0x00026D20) { FILL(0x00000000); build/asm/main_8004C920.s.o(.text); build/asm/main_8004C920.s.o(.rodata); build/asm/main_8004C920.s.o(.data); }
    .main_8004C920_bss (NOLOAD) : { build/asm/main_8004C920.s.o(.bss); }
    .main_8004D034 0x8004D034 : AT(0x00027434) { FILL(0x00000000); build/asm/main_8004D034.s.o(.text); build/asm/main_8004D034.s.o(.rodata); build/asm/main_8004D034.s.o(.data); }
    .main_8004D034_bss (NOLOAD) : { build/asm/main_8004D034.s.o(.bss); }
    .main_8004D8B0 0x8004D8B0 : AT(0x00027CB0) { FILL(0x00000000); build/asm/main_8004D8B0.s.o(.text); build/asm/main_8004D8B0.s.o(.rodata); build/asm/main_8004D8B0.s.o(.data); }
    .main_8004D8B0_bss (NOLOAD) : { build/asm/main_8004D8B0.s.o(.bss); }
    .main_8004F084 0x8004F084 : AT(0x00029484) { FILL(0x00000000); build/asm/main_8004F084.s.o(.text); build/asm/main_8004F084.s.o(.rodata); build/asm/main_8004F084.s.o(.data); }
    .main_8004F084_bss (NOLOAD) : { build/asm/main_8004F084.s.o(.bss); }
    .main_8004F838 0x8004F838 : AT(0x00029C38) { FILL(0x00000000); build/asm/main_8004F838.s.o(.text); build/asm/main_8004F838.s.o(.rodata); build/asm/main_8004F838.s.o(.data); }
    .main_8004F838_bss (NOLOAD) : { build/asm/main_8004F838.s.o(.bss); }
    .main_80053AB4 0x80053AB4 : AT(0x0002DEB4) { FILL(0x00000000); build/asm/main_80053AB4.s.o(.text); build/asm/main_80053AB4.s.o(.rodata); build/asm/main_80053AB4.s.o(.data); }
    .main_80053AB4_bss (NOLOAD) : { build/asm/main_80053AB4.s.o(.bss); }
    .main_80054AC4 0x80054AC4 : AT(0x0002EEC4) { FILL(0x00000000); build/asm/main_80054AC4.s.o(.text); build/asm/main_80054AC4.s.o(.rodata); build/asm/main_80054AC4.s.o(.data); }
    .main_80054AC4_bss (NOLOAD) : { build/asm/main_80054AC4.s.o(.bss); }
    .main_80055A3C 0x80055A3C : AT(0x0002FE3C) { FILL(0x00000000); build/asm/main_80055A3C.s.o(.text); build/asm/main_80055A3C.s.o(.rodata); build/asm/main_80055A3C.s.o(.data); }
    .main_80055A3C_bss (NOLOAD) : { build/asm/main_80055A3C.s.o(.bss); }
    .main_80056090 0x80056090 : AT(0x00030490) { FILL(0x00000000); build/asm/main_80056090.s.o(.text); build/asm/main_80056090.s.o(.rodata); build/asm/main_80056090.s.o(.data); }
    .main_80056090_bss (NOLOAD) : { build/asm/main_80056090.s.o(.bss); }
    .main_80056A80 0x80056A80 : AT(0x00030E80) { FILL(0x00000000); build/asm/main_80056A80.s.o(.text); build/asm/main_80056A80.s.o(.rodata); build/asm/main_80056A80.s.o(.data); }
    .main_80056A80_bss (NOLOAD) : { build/asm/main_80056A80.s.o(.bss); }
    .main_8005BC7C 0x8005BC7C : AT(0x0003607C) { FILL(0x00000000); build/asm/main_8005BC7C.s.o(.text); build/asm/main_8005BC7C.s.o(.rodata); build/asm/main_8005BC7C.s.o(.data); }
    .main_8005BC7C_bss (NOLOAD) : { build/asm/main_8005BC7C.s.o(.bss); }
    .main_8005D02C 0x8005D02C : AT(0x0003742C) { FILL(0x00000000); build/asm/main_8005D02C.s.o(.text); build/asm/main_8005D02C.s.o(.rodata); build/asm/main_8005D02C.s.o(.data); }
    .main_8005D02C_bss (NOLOAD) : { build/asm/main_8005D02C.s.o(.bss); }
    .main_8005D1D0 0x8005D1D0 : AT(0x000375D0) { FILL(0x00000000); build/asm/main_8005D1D0.s.o(.text); build/asm/main_8005D1D0.s.o(.rodata); build/asm/main_8005D1D0.s.o(.data); }
    .main_8005D1D0_bss (NOLOAD) : { build/asm/main_8005D1D0.s.o(.bss); }
    .main_8005D964 0x8005D964 : AT(0x00037D64) { FILL(0x00000000); build/asm/main_8005D964.s.o(.text); build/asm/main_8005D964.s.o(.rodata); build/asm/main_8005D964.s.o(.data); }
    .main_8005D964_bss (NOLOAD) : { build/asm/main_8005D964.s.o(.bss); }
    .main_8005DA60 0x8005DA60 : AT(0x00037E60) { FILL(0x00000000); build/asm/main_8005DA60.s.o(.text); build/asm/main_8005DA60.s.o(.rodata); build/asm/main_8005DA60.s.o(.data); }
    .main_8005DA60_bss (NOLOAD) : { build/asm/main_8005DA60.s.o(.bss); }
    .main_8005FDF4 0x8005FDF4 : AT(0x0003A1F4) { FILL(0x00000000); build/asm/main_8005FDF4.s.o(.text); build/asm/main_8005FDF4.s.o(.rodata); build/asm/main_8005FDF4.s.o(.data); }
    .main_8005FDF4_bss (NOLOAD) : { build/asm/main_8005FDF4.s.o(.bss); }
    .main_8006167C 0x8006167C : AT(0x0003BA7C) { FILL(0x00000000); build/asm/main_8006167C.s.o(.text); build/asm/main_8006167C.s.o(.rodata); build/asm/main_8006167C.s.o(.data); }
    .main_8006167C_bss (NOLOAD) : { build/asm/main_8006167C.s.o(.bss); }
    .main_800622F0 0x800622F0 : AT(0x0003C6F0) { FILL(0x00000000); build/asm/main_800622F0.s.o(.text); build/asm/main_800622F0.s.o(.rodata); build/asm/main_800622F0.s.o(.data); }
    .main_800622F0_bss (NOLOAD) : { build/asm/main_800622F0.s.o(.bss); }
    .main_80063A78 0x80063A78 : AT(0x0003DE78) { FILL(0x00000000); build/asm/main_80063A78.s.o(.text); build/asm/main_80063A78.s.o(.rodata); build/asm/main_80063A78.s.o(.data); }
    .main_80063A78_bss (NOLOAD) : { build/asm/main_80063A78.s.o(.bss); }
    .main_8006469C 0x8006469C : AT(0x0003EA9C) { FILL(0x00000000); build/asm/main_8006469C.s.o(.text); build/asm/main_8006469C.s.o(.rodata); build/asm/main_8006469C.s.o(.data); }
    .main_8006469C_bss (NOLOAD) : { build/asm/main_8006469C.s.o(.bss); }
    .main_80064C3C 0x80064C3C : AT(0x0003F03C) { FILL(0x00000000); build/asm/main_80064C3C.s.o(.text); build/asm/main_80064C3C.s.o(.rodata); build/asm/main_80064C3C.s.o(.data); }
    .main_80064C3C_bss (NOLOAD) : { build/asm/main_80064C3C.s.o(.bss); }
    .main_8006513C 0x8006513C : AT(0x0003F53C) { FILL(0x00000000); build/asm/main_8006513C.s.o(.text); build/asm/main_8006513C.s.o(.rodata); build/asm/main_8006513C.s.o(.data); }
    .main_8006513C_bss (NOLOAD) : { build/asm/main_8006513C.s.o(.bss); }
    .main_80065440 0x80065440 : AT(0x0003F840) { FILL(0x00000000); build/asm/main_80065440.s.o(.text); build/asm/main_80065440.s.o(.rodata); build/asm/main_80065440.s.o(.data); }
    .main_80065440_bss (NOLOAD) : { build/asm/main_80065440.s.o(.bss); }
    .main_80069E8C 0x80069E8C : AT(0x0004428C) { FILL(0x00000000); build/asm/main_80069E8C.s.o(.text); build/asm/main_80069E8C.s.o(.rodata); build/asm/main_80069E8C.s.o(.data); }
    .main_80069E8C_bss (NOLOAD) : { build/asm/main_80069E8C.s.o(.bss); }
    .main_8006C0C0 0x8006C0C0 : AT(0x000464C0) { FILL(0x00000000); build/asm/main_8006C0C0.s.o(.text); build/asm/main_8006C0C0.s.o(.rodata); build/asm/main_8006C0C0.s.o(.data); }
    .main_8006C0C0_bss (NOLOAD) : { build/asm/main_8006C0C0.s.o(.bss); }
    .main_8006F7F0 0x8006F7F0 : AT(0x00049BF0) { FILL(0x00000000); build/asm/main_8006F7F0.s.o(.text); build/asm/main_8006F7F0.s.o(.rodata); build/asm/main_8006F7F0.s.o(.data); }
    .main_8006F7F0_bss (NOLOAD) : { build/asm/main_8006F7F0.s.o(.bss); }
    .main_8007111C 0x8007111C : AT(0x0004B51C) { FILL(0x00000000); build/asm/main_8007111C.s.o(.text); build/asm/main_8007111C.s.o(.rodata); build/asm/main_8007111C.s.o(.data); }
    .main_8007111C_bss (NOLOAD) : { build/asm/main_8007111C.s.o(.bss); }
    .main_80071798 0x80071798 : AT(0x0004BB98) { FILL(0x00000000); build/asm/main_80071798.s.o(.text); build/asm/main_80071798.s.o(.rodata); build/asm/main_80071798.s.o(.data); }
    .main_80071798_bss (NOLOAD) : { build/asm/main_80071798.s.o(.bss); }
    .main_80072EE8 0x80072EE8 : AT(0x0004D2E8) { FILL(0x00000000); build/asm/main_80072EE8.s.o(.text); build/asm/main_80072EE8.s.o(.rodata); build/asm/main_80072EE8.s.o(.data); }
    .main_80072EE8_bss (NOLOAD) : { build/asm/main_80072EE8.s.o(.bss); }
    .main_800742DC 0x800742DC : AT(0x0004E6DC) { FILL(0x00000000); build/asm/main_800742DC.s.o(.text); build/asm/main_800742DC.s.o(.rodata); build/asm/main_800742DC.s.o(.data); }
    .main_800742DC_bss (NOLOAD) : { build/asm/main_800742DC.s.o(.bss); }
    .main_80074B2C 0x80074B2C : AT(0x0004EF2C) { FILL(0x00000000); build/asm/main_80074B2C.s.o(.text); build/asm/main_80074B2C.s.o(.rodata); build/asm/main_80074B2C.s.o(.data); }
    .main_80074B2C_bss (NOLOAD) : { build/asm/main_80074B2C.s.o(.bss); }
    .main_80075090 0x80075090 : AT(0x0004F490) { FILL(0x00000000); build/asm/main_80075090.s.o(.text); build/asm/main_80075090.s.o(.rodata); build/asm/main_80075090.s.o(.data); }
    .main_80075090_bss (NOLOAD) : { build/asm/main_80075090.s.o(.bss); }
    .main_8007ABD4 0x8007ABD4 : AT(0x00054FD4) { FILL(0x00000000); build/asm/main_8007ABD4.s.o(.text); build/asm/main_8007ABD4.s.o(.rodata); build/asm/main_8007ABD4.s.o(.data); }
    .main_8007ABD4_bss (NOLOAD) : { build/asm/main_8007ABD4.s.o(.bss); }
    .main_8007CDB0 0x8007CDB0 : AT(0x000571B0) { FILL(0x00000000); build/asm/main_8007CDB0.s.o(.text); build/asm/main_8007CDB0.s.o(.rodata); build/asm/main_8007CDB0.s.o(.data); }
    .main_8007CDB0_bss (NOLOAD) : { build/asm/main_8007CDB0.s.o(.bss); }
    .main_8007E6A8 0x8007E6A8 : AT(0x00058AA8) { FILL(0x00000000); build/asm/main_8007E6A8.s.o(.text); build/asm/main_8007E6A8.s.o(.rodata); build/asm/main_8007E6A8.s.o(.data); }
    .main_8007E6A8_bss (NOLOAD) : { build/asm/main_8007E6A8.s.o(.bss); }
    .main_8007F39C 0x8007F39C : AT(0x0005979C) { FILL(0x00000000); build/asm/main_8007F39C.s.o(.text); build/asm/main_8007F39C.s.o(.rodata); build/asm/main_8007F39C.s.o(.data); }
    .main_8007F39C_bss (NOLOAD) : { build/asm/main_8007F39C.s.o(.bss); }
    .main_8007F4A0 0x8007F4A0 : AT(0x000598A0) { FILL(0x00000000); build/asm/main_8007F4A0.s.o(.text); build/asm/main_8007F4A0.s.o(.rodata); build/asm/main_8007F4A0.s.o(.data); }
    .main_8007F4A0_bss (NOLOAD) : { build/asm/main_8007F4A0.s.o(.bss); }
    .main_80080AD0 0x80080AD0 : AT(0x0005AED0) { FILL(0x00000000); build/asm/main_80080AD0.s.o(.text); build/asm/main_80080AD0.s.o(.rodata); build/asm/main_80080AD0.s.o(.data); }
    .main_80080AD0_bss (NOLOAD) : { build/asm/main_80080AD0.s.o(.bss); }
    .main_80081720 0x80081720 : AT(0x0005BB20) { FILL(0x00000000); build/asm/main_80081720.s.o(.text); build/asm/main_80081720.s.o(.rodata); build/asm/main_80081720.s.o(.data); }
    .main_80081720_bss (NOLOAD) : { build/asm/main_80081720.s.o(.bss); }
    .main_80082060 0x80082060 : AT(0x0005C460) { FILL(0x00000000); build/asm/main_80082060.s.o(.text); build/asm/main_80082060.s.o(.rodata); build/asm/main_80082060.s.o(.data); }
    .main_80082060_bss (NOLOAD) : { build/asm/main_80082060.s.o(.bss); }
    .main_80084598 0x80084598 : AT(0x0005E998) { FILL(0x00000000); build/asm/main_80084598.s.o(.text); build/asm/main_80084598.s.o(.rodata); build/asm/main_80084598.s.o(.data); }
    .main_80084598_bss (NOLOAD) : { build/asm/main_80084598.s.o(.bss); }
    .main_80084A70 0x80084A70 : AT(0x0005EE70) { FILL(0x00000000); build/asm/main_80084A70.s.o(.text); build/asm/main_80084A70.s.o(.rodata); build/asm/main_80084A70.s.o(.data); }
    .main_80084A70_bss (NOLOAD) : { build/asm/main_80084A70.s.o(.bss); }
    .main_800853E0 0x800853E0 : AT(0x0005F7E0) { FILL(0x00000000); build/asm/main_800853E0.s.o(.text); build/asm/main_800853E0.s.o(.rodata); build/asm/main_800853E0.s.o(.data); }
    .main_800853E0_bss (NOLOAD) : { build/asm/main_800853E0.s.o(.bss); }
    .main_80087650 0x80087650 : AT(0x00061A50) { FILL(0x00000000); build/asm/main_80087650.s.o(.text); build/asm/main_80087650.s.o(.rodata); build/asm/main_80087650.s.o(.data); }
    .main_80087650_bss (NOLOAD) : { build/asm/main_80087650.s.o(.bss); }
    .main_800880B0 0x800880B0 : AT(0x000624B0) { FILL(0x00000000); build/asm/main_800880B0.s.o(.text); build/asm/main_800880B0.s.o(.rodata); build/asm/main_800880B0.s.o(.data); }
    .main_800880B0_bss (NOLOAD) : { build/asm/main_800880B0.s.o(.bss); }
    .main_8008DC20 0x8008DC20 : AT(0x00068020) { FILL(0x00000000); build/asm/main_8008DC20.s.o(.text); build/asm/main_8008DC20.s.o(.rodata); build/asm/main_8008DC20.s.o(.data); }
    .main_8008DC20_bss (NOLOAD) : { build/asm/main_8008DC20.s.o(.bss); }
    .main_8008E954 0x8008E954 : AT(0x00068D54) { FILL(0x00000000); build/asm/main_8008E954.s.o(.text); build/asm/main_8008E954.s.o(.rodata); build/asm/main_8008E954.s.o(.data); }
    .main_8008E954_bss (NOLOAD) : { build/asm/main_8008E954.s.o(.bss); }
    .main_8008EF7C 0x8008EF7C : AT(0x0006937C) { FILL(0x00000000); build/asm/main_8008EF7C.s.o(.text); build/asm/main_8008EF7C.s.o(.rodata); build/asm/main_8008EF7C.s.o(.data); }
    .main_8008EF7C_bss (NOLOAD) : { build/asm/main_8008EF7C.s.o(.bss); }
    .main_8008F58C 0x8008F58C : AT(0x0006998C) { FILL(0x00000000); build/asm/main_8008F58C.s.o(.text); build/asm/main_8008F58C.s.o(.rodata); build/asm/main_8008F58C.s.o(.data); }
    .main_8008F58C_bss (NOLOAD) : { build/asm/main_8008F58C.s.o(.bss); }
    .main_80090888 0x80090888 : AT(0x0006AC88) { FILL(0x00000000); build/asm/main_80090888.s.o(.text); build/asm/main_80090888.s.o(.rodata); build/asm/main_80090888.s.o(.data); }
    .main_80090888_bss (NOLOAD) : { build/asm/main_80090888.s.o(.bss); }
    .main_80090E10 0x80090E10 : AT(0x0006B210) { FILL(0x00000000); build/asm/main_80090E10.s.o(.text); build/asm/main_80090E10.s.o(.rodata); build/asm/main_80090E10.s.o(.data); }
    .main_80090E10_bss (NOLOAD) : { build/asm/main_80090E10.s.o(.bss); }
    .main_800951A0 0x800951A0 : AT(0x0006F5A0) { FILL(0x00000000); build/asm/main_800951A0.s.o(.text); build/asm/main_800951A0.s.o(.rodata); build/asm/main_800951A0.s.o(.data); }
    .main_800951A0_bss (NOLOAD) : { build/asm/main_800951A0.s.o(.bss); }
    .main_80097EEC 0x80097EEC : AT(0x000722EC) { FILL(0x00000000); build/asm/main_80097EEC.s.o(.text); build/asm/main_80097EEC.s.o(.rodata); build/asm/main_80097EEC.s.o(.data); }
    .main_80097EEC_bss (NOLOAD) : { build/asm/main_80097EEC.s.o(.bss); }
    .main_800982D0 0x800982D0 : AT(0x000726D0) { FILL(0x00000000); build/asm/main_800982D0.s.o(.text); build/asm/main_800982D0.s.o(.rodata); build/asm/main_800982D0.s.o(.data); }
    .main_800982D0_bss (NOLOAD) : { build/asm/main_800982D0.s.o(.bss); }
    .main_80099284 0x80099284 : AT(0x00073684) { FILL(0x00000000); build/asm/main_80099284.s.o(.text); build/asm/main_80099284.s.o(.rodata); build/asm/main_80099284.s.o(.data); }
    .main_80099284_bss (NOLOAD) : { build/asm/main_80099284.s.o(.bss); }
    .main_80099D84 0x80099D84 : AT(0x00074184) { FILL(0x00000000); build/asm/main_80099D84.s.o(.text); build/asm/main_80099D84.s.o(.rodata); build/asm/main_80099D84.s.o(.data); }
    .main_80099D84_bss (NOLOAD) : { build/asm/main_80099D84.s.o(.bss); }
    .main_8009A040 0x8009A040 : AT(0x00074440) { FILL(0x00000000); build/asm/main_8009A040.s.o(.text); build/asm/main_8009A040.s.o(.rodata); build/asm/main_8009A040.s.o(.data); }
    .main_8009A040_bss (NOLOAD) : { build/asm/main_8009A040.s.o(.bss); }
    .main_8009A648 0x8009A648 : AT(0x00074A48) { FILL(0x00000000); build/asm/main_8009A648.s.o(.text); build/asm/main_8009A648.s.o(.rodata); build/asm/main_8009A648.s.o(.data); }
    .main_8009A648_bss (NOLOAD) : { build/asm/main_8009A648.s.o(.bss); }
    .main_8009CDD0 0x8009CDD0 : AT(0x000771D0) { FILL(0x00000000); build/asm/main_8009CDD0.s.o(.text); build/asm/main_8009CDD0.s.o(.rodata); build/asm/main_8009CDD0.s.o(.data); }
    .main_8009CDD0_bss (NOLOAD) : { build/asm/main_8009CDD0.s.o(.bss); }
    .main_8009CEC0 0x8009CEC0 : AT(0x000772C0) { FILL(0x00000000); build/asm/main_8009CEC0.s.o(.text); build/asm/main_8009CEC0.s.o(.rodata); build/asm/main_8009CEC0.s.o(.data); }
    .main_8009CEC0_bss (NOLOAD) : { build/asm/main_8009CEC0.s.o(.bss); }
    .main_8009D460 0x8009D460 : AT(0x00077860) { FILL(0x00000000); build/asm/main_8009D460.s.o(.text); build/asm/main_8009D460.s.o(.rodata); build/asm/main_8009D460.s.o(.data); }
    .main_8009D460_bss (NOLOAD) : { build/asm/main_8009D460.s.o(.bss); }
    .main_8009DC90 0x8009DC90 : AT(0x00078090) { FILL(0x00000000); build/asm/main_8009DC90.s.o(.text); build/asm/main_8009DC90.s.o(.rodata); build/asm/main_8009DC90.s.o(.data); }
    .main_8009DC90_bss (NOLOAD) : { build/asm/main_8009DC90.s.o(.bss); }
    .main_800A6FF4 0x800A6FF4 : AT(0x000813F4) { FILL(0x00000000); build/asm/main_800A6FF4.s.o(.text); build/asm/main_800A6FF4.s.o(.rodata); build/asm/main_800A6FF4.s.o(.data); }
    .main_800A6FF4_bss (NOLOAD) : { build/asm/main_800A6FF4.s.o(.bss); }
    .main_800A85AC 0x800A85AC : AT(0x000829AC) { FILL(0x00000000); build/asm/main_800A85AC.s.o(.text); build/asm/main_800A85AC.s.o(.rodata); build/asm/main_800A85AC.s.o(.data); }
    .main_800A85AC_bss (NOLOAD) : { build/asm/main_800A85AC.s.o(.bss); }
    .main_800A9C44 0x800A9C44 : AT(0x00084044) { FILL(0x00000000); build/asm/main_800A9C44.s.o(.text); build/asm/main_800A9C44.s.o(.rodata); build/asm/main_800A9C44.s.o(.data); }
    .main_800A9C44_bss (NOLOAD) : { build/asm/main_800A9C44.s.o(.bss); }
    .main_800AB66C 0x800AB66C : AT(0x00085A6C) { FILL(0x00000000); build/asm/main_800AB66C.s.o(.text); build/asm/main_800AB66C.s.o(.rodata); build/asm/main_800AB66C.s.o(.data); }
    .main_800AB66C_bss (NOLOAD) : { build/asm/main_800AB66C.s.o(.bss); }
    .main_800AC5D0 0x800AC5D0 : AT(0x000869D0) { FILL(0x00000000); build/asm/main_800AC5D0.s.o(.text); build/asm/main_800AC5D0.s.o(.rodata); build/asm/main_800AC5D0.s.o(.data); }
    .main_800AC5D0_bss (NOLOAD) : { build/asm/main_800AC5D0.s.o(.bss); }
    .main_800AE730 0x800AE730 : AT(0x00088B30) { FILL(0x00000000); build/asm/main_800AE730.s.o(.text); build/asm/main_800AE730.s.o(.rodata); build/asm/main_800AE730.s.o(.data); }
    .main_800AE730_bss (NOLOAD) : { build/asm/main_800AE730.s.o(.bss); }
    .main_800AFEC0 0x800AFEC0 : AT(0x0008A2C0) { FILL(0x00000000); build/asm/main_800AFEC0.s.o(.text); build/asm/main_800AFEC0.s.o(.rodata); build/asm/main_800AFEC0.s.o(.data); }
    .main_800AFEC0_bss (NOLOAD) : { build/asm/main_800AFEC0.s.o(.bss); }
    .main_800B3FA0 0x800B3FA0 : AT(0x0008E3A0) { FILL(0x00000000); build/asm/main_800B3FA0.s.o(.text); build/asm/main_800B3FA0.s.o(.rodata); build/asm/main_800B3FA0.s.o(.data); }
    .main_800B3FA0_bss (NOLOAD) : { build/asm/main_800B3FA0.s.o(.bss); }
    .main_800B47A0 0x800B47A0 : AT(0x0008EBA0) { FILL(0x00000000); build/asm/main_800B47A0.s.o(.text); build/asm/main_800B47A0.s.o(.rodata); build/asm/main_800B47A0.s.o(.data); }
    .main_800B47A0_bss (NOLOAD) : { build/asm/main_800B47A0.s.o(.bss); }
    .main_800B509C 0x800B509C : AT(0x0008F49C) { FILL(0x00000000); build/asm/main_800B509C.s.o(.text); build/asm/main_800B509C.s.o(.rodata); build/asm/main_800B509C.s.o(.data); }
    .main_800B509C_bss (NOLOAD) : { build/asm/main_800B509C.s.o(.bss); }
    .main_800B5844 0x800B5844 : AT(0x0008FC44) { FILL(0x00000000); build/asm/main_800B5844.s.o(.text); build/asm/main_800B5844.s.o(.rodata); build/asm/main_800B5844.s.o(.data); }
    .main_800B5844_bss (NOLOAD) : { build/asm/main_800B5844.s.o(.bss); }
    .main_800B6A78 0x800B6A78 : AT(0x00090E78) { FILL(0x00000000); build/asm/main_800B6A78.s.o(.text); build/asm/main_800B6A78.s.o(.rodata); build/asm/main_800B6A78.s.o(.data); }
    .main_800B6A78_bss (NOLOAD) : { build/asm/main_800B6A78.s.o(.bss); }
    .main_800BDED4 0x800BDED4 : AT(0x000982D4) { FILL(0x00000000); build/asm/main_800BDED4.s.o(.text); build/asm/main_800BDED4.s.o(.rodata); build/asm/main_800BDED4.s.o(.data); }
    .main_800BDED4_bss (NOLOAD) : { build/asm/main_800BDED4.s.o(.bss); }
    .main_800C1C40 0x800C1C40 : AT(0x0009C040) { FILL(0x00000000); build/asm/main_800C1C40.s.o(.text); build/asm/main_800C1C40.s.o(.rodata); build/asm/main_800C1C40.s.o(.data); }
    .main_800C1C40_bss (NOLOAD) : { build/asm/main_800C1C40.s.o(.bss); }
    .main_800C204C 0x800C204C : AT(0x0009C44C) { FILL(0x00000000); build/asm/main_800C204C.s.o(.text); build/asm/main_800C204C.s.o(.rodata); build/asm/main_800C204C.s.o(.data); }
    .main_800C204C_bss (NOLOAD) : { build/asm/main_800C204C.s.o(.bss); }
    .main_800C2580 0x800C2580 : AT(0x0009C980) { FILL(0x00000000); build/asm/main_800C2580.s.o(.text); build/asm/main_800C2580.s.o(.rodata); build/asm/main_800C2580.s.o(.data); }
    .main_800C2580_bss (NOLOAD) : { build/asm/main_800C2580.s.o(.bss); }
    .main_800C2E90 0x800C2E90 : AT(0x0009D290) { FILL(0x00000000); build/asm/main_800C2E90.s.o(.text); build/asm/main_800C2E90.s.o(.rodata); build/asm/main_800C2E90.s.o(.data); }
    .main_800C2E90_bss (NOLOAD) : { build/asm/main_800C2E90.s.o(.bss); }
    .main_800C30AC 0x800C30AC : AT(0x0009D4AC) { FILL(0x00000000); build/asm/main_800C30AC.s.o(.text); build/asm/main_800C30AC.s.o(.rodata); build/asm/main_800C30AC.s.o(.data); }
    .main_800C30AC_bss (NOLOAD) : { build/asm/main_800C30AC.s.o(.bss); }
    .main_800C34E4 0x800C34E4 : AT(0x0009D8E4) { FILL(0x00000000); build/asm/main_800C34E4.s.o(.text); build/asm/main_800C34E4.s.o(.rodata); build/asm/main_800C34E4.s.o(.data); }
    .main_800C34E4_bss (NOLOAD) : { build/asm/main_800C34E4.s.o(.bss); }
    .main_800C36E8 0x800C36E8 : AT(0x0009DAE8) { FILL(0x00000000); build/asm/main_800C36E8.s.o(.text); build/asm/main_800C36E8.s.o(.rodata); build/asm/main_800C36E8.s.o(.data); }
    .main_800C36E8_bss (NOLOAD) : { build/asm/main_800C36E8.s.o(.bss); }
    .main_800C3DB8 0x800C3DB8 : AT(0x0009E1B8) { FILL(0x00000000); build/asm/main_800C3DB8.s.o(.text); build/asm/main_800C3DB8.s.o(.rodata); build/asm/main_800C3DB8.s.o(.data); }
    .main_800C3DB8_bss (NOLOAD) : { build/asm/main_800C3DB8.s.o(.bss); }
    .main_800C4E4C 0x800C4E4C : AT(0x0009F24C) { FILL(0x00000000); build/asm/main_800C4E4C.s.o(.text); build/asm/main_800C4E4C.s.o(.rodata); build/asm/main_800C4E4C.s.o(.data); }
    .main_800C4E4C_bss (NOLOAD) : { build/asm/main_800C4E4C.s.o(.bss); }
    .main_800C54F0 0x800C54F0 : AT(0x0009F8F0) { FILL(0x00000000); build/asm/main_800C54F0.s.o(.text); build/asm/main_800C54F0.s.o(.rodata); build/asm/main_800C54F0.s.o(.data); }
    .main_800C54F0_bss (NOLOAD) : { build/asm/main_800C54F0.s.o(.bss); }
    .main_800C5C78 0x800C5C78 : AT(0x000A0078) { FILL(0x00000000); build/asm/main_800C5C78.s.o(.text); build/asm/main_800C5C78.s.o(.rodata); build/asm/main_800C5C78.s.o(.data); }
    .main_800C5C78_bss (NOLOAD) : { build/asm/main_800C5C78.s.o(.bss); }
    .main_800CE370 0x800CE370 : AT(0x000A8770) { build/asm/data/main_800CE370.bin.o(.data); }
    .main_800CEB70 0x800CEB70 : AT(0x000A8F70) { build/asm/data/main_800CEB70.bin.o(.data); }
    .main_800CEFC0 0x800CEFC0 : AT(0x000A93C0) { FILL(0x00000000); build/asm/main_800CEFC0.s.o(.text); build/asm/main_800CEFC0.s.o(.rodata); build/asm/main_800CEFC0.s.o(.data); }
    .main_800CEFC0_bss (NOLOAD) : { build/asm/main_800CEFC0.s.o(.bss); }
    .main_800CF740 0x800CF740 : AT(0x000A9B40) { FILL(0x00000000); build/asm/main_800CF740.s.o(.text); build/asm/main_800CF740.s.o(.rodata); build/asm/main_800CF740.s.o(.data); }
    .main_800CF740_bss (NOLOAD) : { build/asm/main_800CF740.s.o(.bss); }
    .main_800CF7BC 0x800CF7BC : AT(0x000A9BBC) { FILL(0x00000000); build/asm/main_800CF7BC.s.o(.text); build/asm/main_800CF7BC.s.o(.rodata); build/asm/main_800CF7BC.s.o(.data); }
    .main_800CF7BC_bss (NOLOAD) : { build/asm/main_800CF7BC.s.o(.bss); }
    .main_800DF47C 0x800DF47C : AT(0x000B987C) { FILL(0x00000000); build/asm/main_800DF47C.s.o(.text); build/asm/main_800DF47C.s.o(.rodata); build/asm/main_800DF47C.s.o(.data); }
    .main_800DF47C_bss (NOLOAD) : { build/asm/main_800DF47C.s.o(.bss); }
    .main_800E2FD4 0x800E2FD4 : AT(0x000BD3D4) { FILL(0x00000000); build/asm/main_800E2FD4.s.o(.text); build/asm/main_800E2FD4.s.o(.rodata); build/asm/main_800E2FD4.s.o(.data); }
    .main_800E2FD4_bss (NOLOAD) : { build/asm/main_800E2FD4.s.o(.bss); }
    .main_800E3F34 0x800E3F34 : AT(0x000BE334) { FILL(0x00000000); build/asm/main_800E3F34.s.o(.text); build/asm/main_800E3F34.s.o(.rodata); build/asm/main_800E3F34.s.o(.data); }
    .main_800E3F34_bss (NOLOAD) : { build/asm/main_800E3F34.s.o(.bss); }
    .main_800E7768 0x800E7768 : AT(0x000C1B68) { FILL(0x00000000); build/asm/main_800E7768.s.o(.text); build/asm/main_800E7768.s.o(.rodata); build/asm/main_800E7768.s.o(.data); }
    .main_800E7768_bss (NOLOAD) : { build/asm/main_800E7768.s.o(.bss); }
    .main_800E7D7C 0x800E7D7C : AT(0x000C217C) { FILL(0x00000000); build/asm/main_800E7D7C.s.o(.text); build/asm/main_800E7D7C.s.o(.rodata); build/asm/main_800E7D7C.s.o(.data); }
    .main_800E7D7C_bss (NOLOAD) : { build/asm/main_800E7D7C.s.o(.bss); }
    .main_800EB760 0x800EB760 : AT(0x000C5B60) { FILL(0x00000000); build/asm/main_800EB760.s.o(.text); build/asm/main_800EB760.s.o(.rodata); build/asm/main_800EB760.s.o(.data); }
    .main_800EB760_bss (NOLOAD) : { build/asm/main_800EB760.s.o(.bss); }
    .main_800EB8C8 0x800EB8C8 : AT(0x000C5CC8) { build/asm/data/main_800EB8C8.bin.o(.data); }
    .main_800ED8BC 0x800ED8BC : AT(0x000C7CBC) { FILL(0x00000000); build/asm/main_800ED8BC.s.o(.text); build/asm/main_800ED8BC.s.o(.rodata); build/asm/main_800ED8BC.s.o(.data); }
    .main_800ED8BC_bss (NOLOAD) : { build/asm/main_800ED8BC.s.o(.bss); }
    .main_800F0AB0 0x800F0AB0 : AT(0x000CAEB0) { FILL(0x00000000); build/asm/main_800F0AB0.s.o(.text); build/asm/main_800F0AB0.s.o(.rodata); build/asm/main_800F0AB0.s.o(.data); }
    .main_800F0AB0_bss (NOLOAD) : { build/asm/main_800F0AB0.s.o(.bss); }
    .main_800F21EC 0x800F21EC : AT(0x000CC5EC) { build/asm/data/main_800F21EC.bin.o(.data); }
    .main_800F6918 0x800F6918 : AT(0x000D0D18) { FILL(0x00000000); build/asm/main_800F6918.s.o(.text); build/asm/main_800F6918.s.o(.rodata); build/asm/main_800F6918.s.o(.data); }
    .main_800F6918_bss (NOLOAD) : { build/asm/main_800F6918.s.o(.bss); }
    .main_800F8E68 0x800F8E68 : AT(0x000D3268) { build/asm/data/main_800F8E68.bin.o(.data); }
    .main_800FBB6C 0x800FBB6C : AT(0x000D5F6C) { build/asm/data/main_800FBB6C.bin.o(.data); }
    .main_800FD00C 0x800FD00C : AT(0x000D740C) { build/asm/data/main_800FD00C.bin.o(.data); }
    .main_800FDD34 0x800FDD34 : AT(0x000D8134) { FILL(0x00000000); build/asm/main_800FDD34.s.o(.text); build/asm/main_800FDD34.s.o(.rodata); build/asm/main_800FDD34.s.o(.data); }
    .main_800FDD34_bss (NOLOAD) : { build/asm/main_800FDD34.s.o(.bss); }
    .main_800FE258 0x800FE258 : AT(0x000D8658) { build/asm/data/main_800FE258.bin.o(.data); }
    .main_800FE4F0 0x800FE4F0 : AT(0x000D88F0) { build/asm/data/main_800FE4F0.bin.o(.data); }
    .main_800FE718 0x800FE718 : AT(0x000D8B18) { FILL(0x00000000); build/asm/main_800FE718.s.o(.text); build/asm/main_800FE718.s.o(.rodata); build/asm/main_800FE718.s.o(.data); }
    .main_800FE718_bss (NOLOAD) : { build/asm/main_800FE718.s.o(.bss); }
    .main_800FE7C8 0x800FE7C8 : AT(0x000D8BC8) { FILL(0x00000000); build/asm/main_800FE7C8.s.o(.text); build/asm/main_800FE7C8.s.o(.rodata); build/asm/main_800FE7C8.s.o(.data); }
    .main_800FE7C8_bss (NOLOAD) : { build/asm/main_800FE7C8.s.o(.bss); }
    .main_80100808 0x80100808 : AT(0x000DAC08) { build/asm/data/main_80100808.bin.o(.data); }
    .main_80101CE0 0x80101CE0 : AT(0x000DC0E0) { FILL(0x00000000); build/asm/main_80101CE0.s.o(.text); build/asm/main_80101CE0.s.o(.rodata); build/asm/main_80101CE0.s.o(.data); }
    .main_80101CE0_bss (NOLOAD) : { build/asm/main_80101CE0.s.o(.bss); }
    .main_80102558 0x80102558 : AT(0x000DC958) { build/asm/data/main_80102558.bin.o(.data); }
    .main_80104424 0x80104424 : AT(0x000DE824) { build/asm/data/main_80104424.bin.o(.data); }
    .main_80105BEC 0x80105BEC : AT(0x000DFFEC) { FILL(0x00000000); build/asm/main_80105BEC.s.o(.text); build/asm/main_80105BEC.s.o(.rodata); build/asm/main_80105BEC.s.o(.data); }
    .main_80105BEC_bss (NOLOAD) : { build/asm/main_80105BEC.s.o(.bss); }
    .main_80105D64 0x80105D64 : AT(0x000E0164) { build/asm/data/main_80105D64.bin.o(.data); }
    .main_80106FE0 0x80106FE0 : AT(0x000E13E0) { build/asm/data/main_80106FE0.bin.o(.data); }
    .main_8010768C 0x8010768C : AT(0x000E1A8C) { build/asm/data/main_8010768C.bin.o(.data); }
    .main_80108420 0x80108420 : AT(0x000E2820) { build/asm/data/main_80108420.bin.o(.data); }
    .main_8010A81C 0x8010A81C : AT(0x000E4C1C) { build/asm/data/main_8010A81C.bin.o(.data); }
    .main_8010D490 0x8010D490 : AT(0x000E7890) { build/asm/data/main_8010D490.bin.o(.data); }
    .main_8010DBB8 0x8010DBB8 : AT(0x000E7FB8) { build/asm/data/main_8010DBB8.bin.o(.data); }
    .main_801121E8 0x801121E8 : AT(0x000EC5E8) { FILL(0x00000000); build/asm/main_801121E8.s.o(.text); build/asm/main_801121E8.s.o(.rodata); build/asm/main_801121E8.s.o(.data); }
    .main_801121E8_bss (NOLOAD) : { build/asm/main_801121E8.s.o(.bss); }
    .main_80112A58 0x80112A58 : AT(0x000ECE58) { build/asm/data/main_80112A58.bin.o(.data); }
    .main_80114BEC 0x80114BEC : AT(0x000EEFEC) { build/asm/data/main_80114BEC.bin.o(.data); }
    .main_801154B0 0x801154B0 : AT(0x000EF8B0) { build/asm/data/main_801154B0.bin.o(.data); }
    .main_80117554 0x80117554 : AT(0x000F1954) { build/asm/data/main_80117554.bin.o(.data); }
    .main_80117E24 0x80117E24 : AT(0x000F2224) { build/asm/data/main_80117E24.bin.o(.data); }
    .main_801199CC 0x801199CC : AT(0x000F3DCC) { build/asm/data/main_801199CC.bin.o(.data); }
    .assets 0x80426C00 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
