SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000F50 0x80000F50 : AT(0x00001B50) { build/asm/data/main_80000F50.bin.o(.data); }
    .main_80001588 0x80001588 : AT(0x00002188) { FILL(0x00000000); build/asm/main_80001588.s.o(.text); build/asm/main_80001588.s.o(.rodata); build/asm/main_80001588.s.o(.data); }
    .main_80001588_bss (NOLOAD) : { build/asm/main_80001588.s.o(.bss); }
    .main_800015F4 0x800015F4 : AT(0x000021F4) { build/asm/data/main_800015F4.bin.o(.data); }
    .main_8000167C 0x8000167C : AT(0x0000227C) { FILL(0x00000000); build/asm/main_8000167C.s.o(.text); build/asm/main_8000167C.s.o(.rodata); build/asm/main_8000167C.s.o(.data); }
    .main_8000167C_bss (NOLOAD) : { build/asm/main_8000167C.s.o(.bss); }
    .main_800016E4 0x800016E4 : AT(0x000022E4) { build/asm/data/main_800016E4.bin.o(.data); }
    .main_800017D0 0x800017D0 : AT(0x000023D0) { FILL(0x00000000); build/asm/main_800017D0.s.o(.text); build/asm/main_800017D0.s.o(.rodata); build/asm/main_800017D0.s.o(.data); }
    .main_800017D0_bss (NOLOAD) : { build/asm/main_800017D0.s.o(.bss); }
    .main_80003DA8 0x80003DA8 : AT(0x000049A8) { build/asm/data/main_80003DA8.bin.o(.data); }
    .main_80004620 0x80004620 : AT(0x00005220) { FILL(0x00000000); build/asm/main_80004620.s.o(.text); build/asm/main_80004620.s.o(.rodata); build/asm/main_80004620.s.o(.data); }
    .main_80004620_bss (NOLOAD) : { build/asm/main_80004620.s.o(.bss); }
    .main_80005520 0x80005520 : AT(0x00006120) { build/asm/data/main_80005520.bin.o(.data); }
    .main_80005858 0x80005858 : AT(0x00006458) { FILL(0x00000000); build/asm/main_80005858.s.o(.text); build/asm/main_80005858.s.o(.rodata); build/asm/main_80005858.s.o(.data); }
    .main_80005858_bss (NOLOAD) : { build/asm/main_80005858.s.o(.bss); }
    .main_80005A08 0x80005A08 : AT(0x00006608) { build/asm/data/main_80005A08.bin.o(.data); }
    .main_80005BA0 0x80005BA0 : AT(0x000067A0) { FILL(0x00000000); build/asm/main_80005BA0.s.o(.text); build/asm/main_80005BA0.s.o(.rodata); build/asm/main_80005BA0.s.o(.data); }
    .main_80005BA0_bss (NOLOAD) : { build/asm/main_80005BA0.s.o(.bss); }
    .main_80034DD8 0x80034DD8 : AT(0x000359D8) { build/asm/data/main_80034DD8.bin.o(.data); }
    .main_8003567C 0x8003567C : AT(0x0003627C) { FILL(0x00000000); build/asm/main_8003567C.s.o(.text); build/asm/main_8003567C.s.o(.rodata); build/asm/main_8003567C.s.o(.data); }
    .main_8003567C_bss (NOLOAD) : { build/asm/main_8003567C.s.o(.bss); }
    .main_800357F0 0x800357F0 : AT(0x000363F0) { build/asm/data/main_800357F0.bin.o(.data); }
    .main_80035AD4 0x80035AD4 : AT(0x000366D4) { FILL(0x00000000); build/asm/main_80035AD4.s.o(.text); build/asm/main_80035AD4.s.o(.rodata); build/asm/main_80035AD4.s.o(.data); }
    .main_80035AD4_bss (NOLOAD) : { build/asm/main_80035AD4.s.o(.bss); }
    .main_80035B60 0x80035B60 : AT(0x00036760) { build/asm/data/main_80035B60.bin.o(.data); }
    .main_80035DF0 0x80035DF0 : AT(0x000369F0) { FILL(0x00000000); build/asm/main_80035DF0.s.o(.text); build/asm/main_80035DF0.s.o(.rodata); build/asm/main_80035DF0.s.o(.data); }
    .main_80035DF0_bss (NOLOAD) : { build/asm/main_80035DF0.s.o(.bss); }
    .main_80037170 0x80037170 : AT(0x00037D70) { build/asm/data/main_80037170.bin.o(.data); }
    .main_8003B060 0x8003B060 : AT(0x0003BC60) { FILL(0x00000000); build/asm/main_8003B060.s.o(.text); build/asm/main_8003B060.s.o(.rodata); build/asm/main_8003B060.s.o(.data); }
    .main_8003B060_bss (NOLOAD) : { build/asm/main_8003B060.s.o(.bss); }
    .main_8003B250 0x8003B250 : AT(0x0003BE50) { FILL(0x00000000); build/asm/main_8003B250.s.o(.text); build/asm/main_8003B250.s.o(.rodata); build/asm/main_8003B250.s.o(.data); }
    .main_8003B250_bss (NOLOAD) : { build/asm/main_8003B250.s.o(.bss); }
    .main_8003B68C 0x8003B68C : AT(0x0003C28C) { FILL(0x00000000); build/asm/main_8003B68C.s.o(.text); build/asm/main_8003B68C.s.o(.rodata); build/asm/main_8003B68C.s.o(.data); }
    .main_8003B68C_bss (NOLOAD) : { build/asm/main_8003B68C.s.o(.bss); }
    .main_8003B97C 0x8003B97C : AT(0x0003C57C) { FILL(0x00000000); build/asm/main_8003B97C.s.o(.text); build/asm/main_8003B97C.s.o(.rodata); build/asm/main_8003B97C.s.o(.data); }
    .main_8003B97C_bss (NOLOAD) : { build/asm/main_8003B97C.s.o(.bss); }
    .main_8003BE94 0x8003BE94 : AT(0x0003CA94) { FILL(0x00000000); build/asm/main_8003BE94.s.o(.text); build/asm/main_8003BE94.s.o(.rodata); build/asm/main_8003BE94.s.o(.data); }
    .main_8003BE94_bss (NOLOAD) : { build/asm/main_8003BE94.s.o(.bss); }
    .main_8003C0F0 0x8003C0F0 : AT(0x0003CCF0) { FILL(0x00000000); build/asm/main_8003C0F0.s.o(.text); build/asm/main_8003C0F0.s.o(.rodata); build/asm/main_8003C0F0.s.o(.data); }
    .main_8003C0F0_bss (NOLOAD) : { build/asm/main_8003C0F0.s.o(.bss); }
    .main_8003CC04 0x8003CC04 : AT(0x0003D804) { FILL(0x00000000); build/asm/main_8003CC04.s.o(.text); build/asm/main_8003CC04.s.o(.rodata); build/asm/main_8003CC04.s.o(.data); }
    .main_8003CC04_bss (NOLOAD) : { build/asm/main_8003CC04.s.o(.bss); }
    .main_8003DC74 0x8003DC74 : AT(0x0003E874) { FILL(0x00000000); build/asm/main_8003DC74.s.o(.text); build/asm/main_8003DC74.s.o(.rodata); build/asm/main_8003DC74.s.o(.data); }
    .main_8003DC74_bss (NOLOAD) : { build/asm/main_8003DC74.s.o(.bss); }
    .main_8003E440 0x8003E440 : AT(0x0003F040) { FILL(0x00000000); build/asm/main_8003E440.s.o(.text); build/asm/main_8003E440.s.o(.rodata); build/asm/main_8003E440.s.o(.data); }
    .main_8003E440_bss (NOLOAD) : { build/asm/main_8003E440.s.o(.bss); }
    .main_8003F980 0x8003F980 : AT(0x00040580) { FILL(0x00000000); build/asm/main_8003F980.s.o(.text); build/asm/main_8003F980.s.o(.rodata); build/asm/main_8003F980.s.o(.data); }
    .main_8003F980_bss (NOLOAD) : { build/asm/main_8003F980.s.o(.bss); }
    .main_8003FC30 0x8003FC30 : AT(0x00040830) { FILL(0x00000000); build/asm/main_8003FC30.s.o(.text); build/asm/main_8003FC30.s.o(.rodata); build/asm/main_8003FC30.s.o(.data); }
    .main_8003FC30_bss (NOLOAD) : { build/asm/main_8003FC30.s.o(.bss); }
    .main_800406E0 0x800406E0 : AT(0x000412E0) { FILL(0x00000000); build/asm/main_800406E0.s.o(.text); build/asm/main_800406E0.s.o(.rodata); build/asm/main_800406E0.s.o(.data); }
    .main_800406E0_bss (NOLOAD) : { build/asm/main_800406E0.s.o(.bss); }
    .main_80040A20 0x80040A20 : AT(0x00041620) { FILL(0x00000000); build/asm/main_80040A20.s.o(.text); build/asm/main_80040A20.s.o(.rodata); build/asm/main_80040A20.s.o(.data); }
    .main_80040A20_bss (NOLOAD) : { build/asm/main_80040A20.s.o(.bss); }
    .main_80040BD0 0x80040BD0 : AT(0x000417D0) { FILL(0x00000000); build/asm/main_80040BD0.s.o(.text); build/asm/main_80040BD0.s.o(.rodata); build/asm/main_80040BD0.s.o(.data); }
    .main_80040BD0_bss (NOLOAD) : { build/asm/main_80040BD0.s.o(.bss); }
    .main_80040C50 0x80040C50 : AT(0x00041850) { FILL(0x00000000); build/asm/main_80040C50.s.o(.text); build/asm/main_80040C50.s.o(.rodata); build/asm/main_80040C50.s.o(.data); }
    .main_80040C50_bss (NOLOAD) : { build/asm/main_80040C50.s.o(.bss); }
    .main_80040D40 0x80040D40 : AT(0x00041940) { FILL(0x00000000); build/asm/main_80040D40.s.o(.text); build/asm/main_80040D40.s.o(.rodata); build/asm/main_80040D40.s.o(.data); }
    .main_80040D40_bss (NOLOAD) : { build/asm/main_80040D40.s.o(.bss); }
    .main_80040E30 0x80040E30 : AT(0x00041A30) { FILL(0x00000000); build/asm/main_80040E30.s.o(.text); build/asm/main_80040E30.s.o(.rodata); build/asm/main_80040E30.s.o(.data); }
    .main_80040E30_bss (NOLOAD) : { build/asm/main_80040E30.s.o(.bss); }
    .main_80040F40 0x80040F40 : AT(0x00041B40) { FILL(0x00000000); build/asm/main_80040F40.s.o(.text); build/asm/main_80040F40.s.o(.rodata); build/asm/main_80040F40.s.o(.data); }
    .main_80040F40_bss (NOLOAD) : { build/asm/main_80040F40.s.o(.bss); }
    .main_80041AC0 0x80041AC0 : AT(0x000426C0) { FILL(0x00000000); build/asm/main_80041AC0.s.o(.text); build/asm/main_80041AC0.s.o(.rodata); build/asm/main_80041AC0.s.o(.data); }
    .main_80041AC0_bss (NOLOAD) : { build/asm/main_80041AC0.s.o(.bss); }
    .main_80041B70 0x80041B70 : AT(0x00042770) { FILL(0x00000000); build/asm/main_80041B70.s.o(.text); build/asm/main_80041B70.s.o(.rodata); build/asm/main_80041B70.s.o(.data); }
    .main_80041B70_bss (NOLOAD) : { build/asm/main_80041B70.s.o(.bss); }
    .main_80041CD0 0x80041CD0 : AT(0x000428D0) { FILL(0x00000000); build/asm/main_80041CD0.s.o(.text); build/asm/main_80041CD0.s.o(.rodata); build/asm/main_80041CD0.s.o(.data); }
    .main_80041CD0_bss (NOLOAD) : { build/asm/main_80041CD0.s.o(.bss); }
    .main_800422F0 0x800422F0 : AT(0x00042EF0) { FILL(0x00000000); build/asm/main_800422F0.s.o(.text); build/asm/main_800422F0.s.o(.rodata); build/asm/main_800422F0.s.o(.data); }
    .main_800422F0_bss (NOLOAD) : { build/asm/main_800422F0.s.o(.bss); }
    .main_80042840 0x80042840 : AT(0x00043440) { FILL(0x00000000); build/asm/main_80042840.s.o(.text); build/asm/main_80042840.s.o(.rodata); build/asm/main_80042840.s.o(.data); }
    .main_80042840_bss (NOLOAD) : { build/asm/main_80042840.s.o(.bss); }
    .main_800429E0 0x800429E0 : AT(0x000435E0) { FILL(0x00000000); build/asm/main_800429E0.s.o(.text); build/asm/main_800429E0.s.o(.rodata); build/asm/main_800429E0.s.o(.data); }
    .main_800429E0_bss (NOLOAD) : { build/asm/main_800429E0.s.o(.bss); }
    .main_80042BF0 0x80042BF0 : AT(0x000437F0) { FILL(0x00000000); build/asm/main_80042BF0.s.o(.text); build/asm/main_80042BF0.s.o(.rodata); build/asm/main_80042BF0.s.o(.data); }
    .main_80042BF0_bss (NOLOAD) : { build/asm/main_80042BF0.s.o(.bss); }
    .main_80043000 0x80043000 : AT(0x00043C00) { FILL(0x00000000); build/asm/main_80043000.s.o(.text); build/asm/main_80043000.s.o(.rodata); build/asm/main_80043000.s.o(.data); }
    .main_80043000_bss (NOLOAD) : { build/asm/main_80043000.s.o(.bss); }
    .main_80044BB0 0x80044BB0 : AT(0x000457B0) { build/asm/data/main_80044BB0.bin.o(.data); }
    .main_800485BC 0x800485BC : AT(0x000491BC) { FILL(0x00000000); build/asm/main_800485BC.s.o(.text); build/asm/main_800485BC.s.o(.rodata); build/asm/main_800485BC.s.o(.data); }
    .main_800485BC_bss (NOLOAD) : { build/asm/main_800485BC.s.o(.bss); }
    .main_80048D54 0x80048D54 : AT(0x00049954) { build/asm/data/main_80048D54.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
