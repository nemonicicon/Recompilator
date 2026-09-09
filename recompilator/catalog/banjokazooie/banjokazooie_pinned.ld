SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000550 0x80000550 : AT(0x00001150) { FILL(0x00000000); build/asm/main_80000550.s.o(.text); build/asm/main_80000550.s.o(.rodata); build/asm/main_80000550.s.o(.data); }
    .main_80000550_bss (NOLOAD) : { build/asm/main_80000550.s.o(.bss); }
    .main_80002000 0x80002000 : AT(0x00002C00) { FILL(0x00000000); build/asm/main_80002000.s.o(.text); build/asm/main_80002000.s.o(.rodata); build/asm/main_80002000.s.o(.data); }
    .main_80002000_bss (NOLOAD) : { build/asm/main_80002000.s.o(.bss); }
    .main_800021C0 0x800021C0 : AT(0x00002DC0) { FILL(0x00000000); build/asm/main_800021C0.s.o(.text); build/asm/main_800021C0.s.o(.rodata); build/asm/main_800021C0.s.o(.data); }
    .main_800021C0_bss (NOLOAD) : { build/asm/main_800021C0.s.o(.bss); }
    .main_800027A4 0x800027A4 : AT(0x000033A4) { FILL(0x00000000); build/asm/main_800027A4.s.o(.text); build/asm/main_800027A4.s.o(.rodata); build/asm/main_800027A4.s.o(.data); }
    .main_800027A4_bss (NOLOAD) : { build/asm/main_800027A4.s.o(.bss); }
    .main_80002C70 0x80002C70 : AT(0x00003870) { FILL(0x00000000); build/asm/main_80002C70.s.o(.text); build/asm/main_80002C70.s.o(.rodata); build/asm/main_80002C70.s.o(.data); }
    .main_80002C70_bss (NOLOAD) : { build/asm/main_80002C70.s.o(.bss); }
    .main_80002DD4 0x80002DD4 : AT(0x000039D4) { FILL(0x00000000); build/asm/main_80002DD4.s.o(.text); build/asm/main_80002DD4.s.o(.rodata); build/asm/main_80002DD4.s.o(.data); }
    .main_80002DD4_bss (NOLOAD) : { build/asm/main_80002DD4.s.o(.bss); }
    .main_80002EC8 0x80002EC8 : AT(0x00003AC8) { FILL(0x00000000); build/asm/main_80002EC8.s.o(.text); build/asm/main_80002EC8.s.o(.rodata); build/asm/main_80002EC8.s.o(.data); }
    .main_80002EC8_bss (NOLOAD) : { build/asm/main_80002EC8.s.o(.bss); }
    .main_800030D0 0x800030D0 : AT(0x00003CD0) { FILL(0x00000000); build/asm/main_800030D0.s.o(.text); build/asm/main_800030D0.s.o(.rodata); build/asm/main_800030D0.s.o(.data); }
    .main_800030D0_bss (NOLOAD) : { build/asm/main_800030D0.s.o(.bss); }
    .main_80003BD0 0x80003BD0 : AT(0x000047D0) { FILL(0x00000000); build/asm/main_80003BD0.s.o(.text); build/asm/main_80003BD0.s.o(.rodata); build/asm/main_80003BD0.s.o(.data); }
    .main_80003BD0_bss (NOLOAD) : { build/asm/main_80003BD0.s.o(.bss); }
    .main_80004000 0x80004000 : AT(0x00004C00) { FILL(0x00000000); build/asm/main_80004000.s.o(.text); build/asm/main_80004000.s.o(.rodata); build/asm/main_80004000.s.o(.data); }
    .main_80004000_bss (NOLOAD) : { build/asm/main_80004000.s.o(.bss); }
    .main_800042C0 0x800042C0 : AT(0x00004EC0) { FILL(0x00000000); build/asm/main_800042C0.s.o(.text); build/asm/main_800042C0.s.o(.rodata); build/asm/main_800042C0.s.o(.data); }
    .main_800042C0_bss (NOLOAD) : { build/asm/main_800042C0.s.o(.bss); }
    .main_800045D0 0x800045D0 : AT(0x000051D0) { FILL(0x00000000); build/asm/main_800045D0.s.o(.text); build/asm/main_800045D0.s.o(.rodata); build/asm/main_800045D0.s.o(.data); }
    .main_800045D0_bss (NOLOAD) : { build/asm/main_800045D0.s.o(.bss); }
    .main_80004E40 0x80004E40 : AT(0x00005A40) { FILL(0x00000000); build/asm/main_80004E40.s.o(.text); build/asm/main_80004E40.s.o(.rodata); build/asm/main_80004E40.s.o(.data); }
    .main_80004E40_bss (NOLOAD) : { build/asm/main_80004E40.s.o(.bss); }
    .main_800054D4 0x800054D4 : AT(0x000060D4) { FILL(0x00000000); build/asm/main_800054D4.s.o(.text); build/asm/main_800054D4.s.o(.rodata); build/asm/main_800054D4.s.o(.data); }
    .main_800054D4_bss (NOLOAD) : { build/asm/main_800054D4.s.o(.bss); }
    .main_800078B0 0x800078B0 : AT(0x000084B0) { FILL(0x00000000); build/asm/main_800078B0.s.o(.text); build/asm/main_800078B0.s.o(.rodata); build/asm/main_800078B0.s.o(.data); }
    .main_800078B0_bss (NOLOAD) : { build/asm/main_800078B0.s.o(.bss); }
    .main_80009CD4 0x80009CD4 : AT(0x0000A8D4) { FILL(0x00000000); build/asm/main_80009CD4.s.o(.text); build/asm/main_80009CD4.s.o(.rodata); build/asm/main_80009CD4.s.o(.data); }
    .main_80009CD4_bss (NOLOAD) : { build/asm/main_80009CD4.s.o(.bss); }
    .main_800100A0 0x800100A0 : AT(0x00010CA0) { build/asm/data/main_800100A0.bin.o(.data); }
    .main_80024EDC 0x80024EDC : AT(0x00025ADC) { FILL(0x00000000); build/asm/main_80024EDC.s.o(.text); build/asm/main_80024EDC.s.o(.rodata); build/asm/main_80024EDC.s.o(.data); }
    .main_80024EDC_bss (NOLOAD) : { build/asm/main_80024EDC.s.o(.bss); }
    .main_80024F04 0x80024F04 : AT(0x00025B04) { build/asm/data/main_80024F04.bin.o(.data); }
    .main_8002D7D4 0x8002D7D4 : AT(0x0002E3D4) { build/asm/data/main_8002D7D4.bin.o(.data); }
    .main_8003E3C0 0x8003E3C0 : AT(0x0003EFC0) { FILL(0x00000000); build/asm/main_8003E3C0.s.o(.text); build/asm/main_8003E3C0.s.o(.rodata); build/asm/main_8003E3C0.s.o(.data); }
    .main_8003E3C0_bss (NOLOAD) : { build/asm/main_8003E3C0.s.o(.bss); }
    .main_8003E400 0x8003E400 : AT(0x0003F000) { build/asm/data/main_8003E400.bin.o(.data); }
    .main_8006CFE4 0x8006CFE4 : AT(0x0006DBE4) { FILL(0x00000000); build/asm/main_8006CFE4.s.o(.text); build/asm/main_8006CFE4.s.o(.rodata); build/asm/main_8006CFE4.s.o(.data); }
    .main_8006CFE4_bss (NOLOAD) : { build/asm/main_8006CFE4.s.o(.bss); }
    .main_8006D024 0x8006D024 : AT(0x0006DC24) { build/asm/data/main_8006D024.bin.o(.data); }
    .main_80088AFC 0x80088AFC : AT(0x000896FC) { FILL(0x00000000); build/asm/main_80088AFC.s.o(.text); build/asm/main_80088AFC.s.o(.rodata); build/asm/main_80088AFC.s.o(.data); }
    .main_80088AFC_bss (NOLOAD) : { build/asm/main_80088AFC.s.o(.bss); }
    .main_80088B40 0x80088B40 : AT(0x00089740) { build/asm/data/main_80088B40.bin.o(.data); }
    .main_800AF120 0x800AF120 : AT(0x000AFD20) { FILL(0x00000000); build/asm/main_800AF120.s.o(.text); build/asm/main_800AF120.s.o(.rodata); build/asm/main_800AF120.s.o(.data); }
    .main_800AF120_bss (NOLOAD) : { build/asm/main_800AF120.s.o(.bss); }
    .main_800AF12C 0x800AF12C : AT(0x000AFD2C) { build/asm/data/main_800AF12C.bin.o(.data); }
    .main_800E60A4 0x800E60A4 : AT(0x000E6CA4) { FILL(0x00000000); build/asm/main_800E60A4.s.o(.text); build/asm/main_800E60A4.s.o(.rodata); build/asm/main_800E60A4.s.o(.data); }
    .main_800E60A4_bss (NOLOAD) : { build/asm/main_800E60A4.s.o(.bss); }
    .main_800E60B8 0x800E60B8 : AT(0x000E6CB8) { build/asm/data/main_800E60B8.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
