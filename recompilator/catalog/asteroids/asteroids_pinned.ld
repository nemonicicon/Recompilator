SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80001088 0x80001088 : AT(0x00001C88) { FILL(0x00000000); build/asm/main_80001088.s.o(.text); build/asm/main_80001088.s.o(.rodata); build/asm/main_80001088.s.o(.data); }
    .main_80001088_bss (NOLOAD) : { build/asm/main_80001088.s.o(.bss); }
    .main_80001564 0x80001564 : AT(0x00002164) { build/asm/data/main_80001564.bin.o(.data); }
    .main_800017BC 0x800017BC : AT(0x000023BC) { FILL(0x00000000); build/asm/main_800017BC.s.o(.text); build/asm/main_800017BC.s.o(.rodata); build/asm/main_800017BC.s.o(.data); }
    .main_800017BC_bss (NOLOAD) : { build/asm/main_800017BC.s.o(.bss); }
    .main_80001AE8 0x80001AE8 : AT(0x000026E8) { build/asm/data/main_80001AE8.bin.o(.data); }
    .main_80001FB4 0x80001FB4 : AT(0x00002BB4) { FILL(0x00000000); build/asm/main_80001FB4.s.o(.text); build/asm/main_80001FB4.s.o(.rodata); build/asm/main_80001FB4.s.o(.data); }
    .main_80001FB4_bss (NOLOAD) : { build/asm/main_80001FB4.s.o(.bss); }
    .main_80001FD8 0x80001FD8 : AT(0x00002BD8) { build/asm/data/main_80001FD8.bin.o(.data); }
    .main_80009510 0x80009510 : AT(0x0000A110) { FILL(0x00000000); build/asm/main_80009510.s.o(.text); build/asm/main_80009510.s.o(.rodata); build/asm/main_80009510.s.o(.data); }
    .main_80009510_bss (NOLOAD) : { build/asm/main_80009510.s.o(.bss); }
    .main_800548A0 0x800548A0 : AT(0x000554A0) { build/asm/data/main_800548A0.bin.o(.data); }
    .main_80055BAC 0x80055BAC : AT(0x000567AC) { FILL(0x00000000); build/asm/main_80055BAC.s.o(.text); build/asm/main_80055BAC.s.o(.rodata); build/asm/main_80055BAC.s.o(.data); }
    .main_80055BAC_bss (NOLOAD) : { build/asm/main_80055BAC.s.o(.bss); }
    .main_80055BCC 0x80055BCC : AT(0x000567CC) { build/asm/data/main_80055BCC.bin.o(.data); }
    .main_80057D80 0x80057D80 : AT(0x00058980) { FILL(0x00000000); build/asm/main_80057D80.s.o(.text); build/asm/main_80057D80.s.o(.rodata); build/asm/main_80057D80.s.o(.data); }
    .main_80057D80_bss (NOLOAD) : { build/asm/main_80057D80.s.o(.bss); }
    .main_8006DDE0 0x8006DDE0 : AT(0x0006E9E0) { build/asm/data/main_8006DDE0.bin.o(.data); }
    .main_80073120 0x80073120 : AT(0x00073D20) { FILL(0x00000000); build/asm/main_80073120.s.o(.text); build/asm/main_80073120.s.o(.rodata); build/asm/main_80073120.s.o(.data); }
    .main_80073120_bss (NOLOAD) : { build/asm/main_80073120.s.o(.bss); }
    .main_80080078 0x80080078 : AT(0x00080C78) { build/asm/data/main_80080078.bin.o(.data); }
    .main_80082CD0 0x80082CD0 : AT(0x000838D0) { FILL(0x00000000); build/asm/main_80082CD0.s.o(.text); build/asm/main_80082CD0.s.o(.rodata); build/asm/main_80082CD0.s.o(.data); }
    .main_80082CD0_bss (NOLOAD) : { build/asm/main_80082CD0.s.o(.bss); }
    .main_80082F58 0x80082F58 : AT(0x00083B58) { build/asm/data/main_80082F58.bin.o(.data); }
    .main_80083468 0x80083468 : AT(0x00084068) { FILL(0x00000000); build/asm/main_80083468.s.o(.text); build/asm/main_80083468.s.o(.rodata); build/asm/main_80083468.s.o(.data); }
    .main_80083468_bss (NOLOAD) : { build/asm/main_80083468.s.o(.bss); }
    .main_800836F0 0x800836F0 : AT(0x000842F0) { build/asm/data/main_800836F0.bin.o(.data); }
    .main_80083D10 0x80083D10 : AT(0x00084910) { FILL(0x00000000); build/asm/main_80083D10.s.o(.text); build/asm/main_80083D10.s.o(.rodata); build/asm/main_80083D10.s.o(.data); }
    .main_80083D10_bss (NOLOAD) : { build/asm/main_80083D10.s.o(.bss); }
    .main_800844CC 0x800844CC : AT(0x000850CC) { build/asm/data/main_800844CC.bin.o(.data); }
    .main_8008742C 0x8008742C : AT(0x0008802C) { FILL(0x00000000); build/asm/main_8008742C.s.o(.text); build/asm/main_8008742C.s.o(.rodata); build/asm/main_8008742C.s.o(.data); }
    .main_8008742C_bss (NOLOAD) : { build/asm/main_8008742C.s.o(.bss); }
    .main_800879A8 0x800879A8 : AT(0x000885A8) { build/asm/data/main_800879A8.bin.o(.data); }
    .main_8008867C 0x8008867C : AT(0x0008927C) { FILL(0x00000000); build/asm/main_8008867C.s.o(.text); build/asm/main_8008867C.s.o(.rodata); build/asm/main_8008867C.s.o(.data); }
    .main_8008867C_bss (NOLOAD) : { build/asm/main_8008867C.s.o(.bss); }
    .main_80088698 0x80088698 : AT(0x00089298) { build/asm/data/main_80088698.bin.o(.data); }
    .main_8008AE00 0x8008AE00 : AT(0x0008BA00) { FILL(0x00000000); build/asm/main_8008AE00.s.o(.text); build/asm/main_8008AE00.s.o(.rodata); build/asm/main_8008AE00.s.o(.data); }
    .main_8008AE00_bss (NOLOAD) : { build/asm/main_8008AE00.s.o(.bss); }
    .main_8008AE1C 0x8008AE1C : AT(0x0008BA1C) { build/asm/data/main_8008AE1C.bin.o(.data); }
    .main_8008AE2C 0x8008AE2C : AT(0x0008BA2C) { FILL(0x00000000); build/asm/main_8008AE2C.s.o(.text); build/asm/main_8008AE2C.s.o(.rodata); build/asm/main_8008AE2C.s.o(.data); }
    .main_8008AE2C_bss (NOLOAD) : { build/asm/main_8008AE2C.s.o(.bss); }
    .main_8008AE40 0x8008AE40 : AT(0x0008BA40) { build/asm/data/main_8008AE40.bin.o(.data); }
    .main_8008AE48 0x8008AE48 : AT(0x0008BA48) { FILL(0x00000000); build/asm/main_8008AE48.s.o(.text); build/asm/main_8008AE48.s.o(.rodata); build/asm/main_8008AE48.s.o(.data); }
    .main_8008AE48_bss (NOLOAD) : { build/asm/main_8008AE48.s.o(.bss); }
    .main_8008AE50 0x8008AE50 : AT(0x0008BA50) { build/asm/data/main_8008AE50.bin.o(.data); }
    .main_8008AF5C 0x8008AF5C : AT(0x0008BB5C) { FILL(0x00000000); build/asm/main_8008AF5C.s.o(.text); build/asm/main_8008AF5C.s.o(.rodata); build/asm/main_8008AF5C.s.o(.data); }
    .main_8008AF5C_bss (NOLOAD) : { build/asm/main_8008AF5C.s.o(.bss); }
    .main_8008AF70 0x8008AF70 : AT(0x0008BB70) { build/asm/data/main_8008AF70.bin.o(.data); }
    .main_8008F620 0x8008F620 : AT(0x00090220) { FILL(0x00000000); build/asm/main_8008F620.s.o(.text); build/asm/main_8008F620.s.o(.rodata); build/asm/main_8008F620.s.o(.data); }
    .main_8008F620_bss (NOLOAD) : { build/asm/main_8008F620.s.o(.bss); }
    .main_8008F630 0x8008F630 : AT(0x00090230) { build/asm/data/main_8008F630.bin.o(.data); }
    .main_800A7D38 0x800A7D38 : AT(0x000A8938) { FILL(0x00000000); build/asm/main_800A7D38.s.o(.text); build/asm/main_800A7D38.s.o(.rodata); build/asm/main_800A7D38.s.o(.data); }
    .main_800A7D38_bss (NOLOAD) : { build/asm/main_800A7D38.s.o(.bss); }
    .main_800A7D54 0x800A7D54 : AT(0x000A8954) { build/asm/data/main_800A7D54.bin.o(.data); }
    .main_800A901C 0x800A901C : AT(0x000A9C1C) { FILL(0x00000000); build/asm/main_800A901C.s.o(.text); build/asm/main_800A901C.s.o(.rodata); build/asm/main_800A901C.s.o(.data); }
    .main_800A901C_bss (NOLOAD) : { build/asm/main_800A901C.s.o(.bss); }
    .main_800A9020 0x800A9020 : AT(0x000A9C20) { build/asm/data/main_800A9020.bin.o(.data); }
    .main_800A9CA0 0x800A9CA0 : AT(0x000AA8A0) { FILL(0x00000000); build/asm/main_800A9CA0.s.o(.text); build/asm/main_800A9CA0.s.o(.rodata); build/asm/main_800A9CA0.s.o(.data); }
    .main_800A9CA0_bss (NOLOAD) : { build/asm/main_800A9CA0.s.o(.bss); }
    .main_800A9CB0 0x800A9CB0 : AT(0x000AA8B0) { build/asm/data/main_800A9CB0.bin.o(.data); }
    .main_800BB4C8 0x800BB4C8 : AT(0x000BC0C8) { FILL(0x00000000); build/asm/main_800BB4C8.s.o(.text); build/asm/main_800BB4C8.s.o(.rodata); build/asm/main_800BB4C8.s.o(.data); }
    .main_800BB4C8_bss (NOLOAD) : { build/asm/main_800BB4C8.s.o(.bss); }
    .main_800BB5A4 0x800BB5A4 : AT(0x000BC1A4) { build/asm/data/main_800BB5A4.bin.o(.data); }
    .main_800C351C 0x800C351C : AT(0x000C411C) { FILL(0x00000000); build/asm/main_800C351C.s.o(.text); build/asm/main_800C351C.s.o(.rodata); build/asm/main_800C351C.s.o(.data); }
    .main_800C351C_bss (NOLOAD) : { build/asm/main_800C351C.s.o(.bss); }
    .main_800C3544 0x800C3544 : AT(0x000C4144) { build/asm/data/main_800C3544.bin.o(.data); }
    .main_800C744C 0x800C744C : AT(0x000C804C) { FILL(0x00000000); build/asm/main_800C744C.s.o(.text); build/asm/main_800C744C.s.o(.rodata); build/asm/main_800C744C.s.o(.data); }
    .main_800C744C_bss (NOLOAD) : { build/asm/main_800C744C.s.o(.bss); }
    .main_800C75C4 0x800C75C4 : AT(0x000C81C4) { build/asm/data/main_800C75C4.bin.o(.data); }
    .main_800C8C48 0x800C8C48 : AT(0x000C9848) { FILL(0x00000000); build/asm/main_800C8C48.s.o(.text); build/asm/main_800C8C48.s.o(.rodata); build/asm/main_800C8C48.s.o(.data); }
    .main_800C8C48_bss (NOLOAD) : { build/asm/main_800C8C48.s.o(.bss); }
    .main_800CA548 0x800CA548 : AT(0x000CB148) { build/asm/data/main_800CA548.bin.o(.data); }
    .main_800CFAD4 0x800CFAD4 : AT(0x000D06D4) { FILL(0x00000000); build/asm/main_800CFAD4.s.o(.text); build/asm/main_800CFAD4.s.o(.rodata); build/asm/main_800CFAD4.s.o(.data); }
    .main_800CFAD4_bss (NOLOAD) : { build/asm/main_800CFAD4.s.o(.bss); }
    .main_800CFB54 0x800CFB54 : AT(0x000D0754) { build/asm/data/main_800CFB54.bin.o(.data); }
    .main_800DED84 0x800DED84 : AT(0x000DF984) { FILL(0x00000000); build/asm/main_800DED84.s.o(.text); build/asm/main_800DED84.s.o(.rodata); build/asm/main_800DED84.s.o(.data); }
    .main_800DED84_bss (NOLOAD) : { build/asm/main_800DED84.s.o(.bss); }
    .main_800DEFA8 0x800DEFA8 : AT(0x000DFBA8) { build/asm/data/main_800DEFA8.bin.o(.data); }
    .main_800EAE54 0x800EAE54 : AT(0x000EBA54) { FILL(0x00000000); build/asm/main_800EAE54.s.o(.text); build/asm/main_800EAE54.s.o(.rodata); build/asm/main_800EAE54.s.o(.data); }
    .main_800EAE54_bss (NOLOAD) : { build/asm/main_800EAE54.s.o(.bss); }
    .main_800EAEB4 0x800EAEB4 : AT(0x000EBAB4) { build/asm/data/main_800EAEB4.bin.o(.data); }
    .main_800EB074 0x800EB074 : AT(0x000EBC74) { FILL(0x00000000); build/asm/main_800EB074.s.o(.text); build/asm/main_800EB074.s.o(.rodata); build/asm/main_800EB074.s.o(.data); }
    .main_800EB074_bss (NOLOAD) : { build/asm/main_800EB074.s.o(.bss); }
    .main_800EB08C 0x800EB08C : AT(0x000EBC8C) { build/asm/data/main_800EB08C.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
