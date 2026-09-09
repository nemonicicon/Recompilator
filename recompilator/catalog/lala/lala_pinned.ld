SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800272B0 0x800272B0 : AT(0x00027EB0) { FILL(0x00000000); build/asm/main_800272B0.s.o(.text); build/asm/main_800272B0.s.o(.rodata); build/asm/main_800272B0.s.o(.data); }
    .main_800272B0_bss (NOLOAD) : { build/asm/main_800272B0.s.o(.bss); }
    .main_80027B20 0x80027B20 : AT(0x00028720) { FILL(0x00000000); build/asm/main_80027B20.s.o(.text); build/asm/main_80027B20.s.o(.rodata); build/asm/main_80027B20.s.o(.data); }
    .main_80027B20_bss (NOLOAD) : { build/asm/main_80027B20.s.o(.bss); }
    .main_80028670 0x80028670 : AT(0x00029270) { FILL(0x00000000); build/asm/main_80028670.s.o(.text); build/asm/main_80028670.s.o(.rodata); build/asm/main_80028670.s.o(.data); }
    .main_80028670_bss (NOLOAD) : { build/asm/main_80028670.s.o(.bss); }
    .main_80028714 0x80028714 : AT(0x00029314) { FILL(0x00000000); build/asm/main_80028714.s.o(.text); build/asm/main_80028714.s.o(.rodata); build/asm/main_80028714.s.o(.data); }
    .main_80028714_bss (NOLOAD) : { build/asm/main_80028714.s.o(.bss); }
    .main_80028808 0x80028808 : AT(0x00029408) { FILL(0x00000000); build/asm/main_80028808.s.o(.text); build/asm/main_80028808.s.o(.rodata); build/asm/main_80028808.s.o(.data); }
    .main_80028808_bss (NOLOAD) : { build/asm/main_80028808.s.o(.bss); }
    .main_80028AD0 0x80028AD0 : AT(0x000296D0) { FILL(0x00000000); build/asm/main_80028AD0.s.o(.text); build/asm/main_80028AD0.s.o(.rodata); build/asm/main_80028AD0.s.o(.data); }
    .main_80028AD0_bss (NOLOAD) : { build/asm/main_80028AD0.s.o(.bss); }
    .main_8002907C 0x8002907C : AT(0x00029C7C) { FILL(0x00000000); build/asm/main_8002907C.s.o(.text); build/asm/main_8002907C.s.o(.rodata); build/asm/main_8002907C.s.o(.data); }
    .main_8002907C_bss (NOLOAD) : { build/asm/main_8002907C.s.o(.bss); }
    .main_800298F4 0x800298F4 : AT(0x0002A4F4) { FILL(0x00000000); build/asm/main_800298F4.s.o(.text); build/asm/main_800298F4.s.o(.rodata); build/asm/main_800298F4.s.o(.data); }
    .main_800298F4_bss (NOLOAD) : { build/asm/main_800298F4.s.o(.bss); }
    .main_8002A670 0x8002A670 : AT(0x0002B270) { FILL(0x00000000); build/asm/main_8002A670.s.o(.text); build/asm/main_8002A670.s.o(.rodata); build/asm/main_8002A670.s.o(.data); }
    .main_8002A670_bss (NOLOAD) : { build/asm/main_8002A670.s.o(.bss); }
    .main_8002AE88 0x8002AE88 : AT(0x0002BA88) { FILL(0x00000000); build/asm/main_8002AE88.s.o(.text); build/asm/main_8002AE88.s.o(.rodata); build/asm/main_8002AE88.s.o(.data); }
    .main_8002AE88_bss (NOLOAD) : { build/asm/main_8002AE88.s.o(.bss); }
    .main_8002B2A8 0x8002B2A8 : AT(0x0002BEA8) { FILL(0x00000000); build/asm/main_8002B2A8.s.o(.text); build/asm/main_8002B2A8.s.o(.rodata); build/asm/main_8002B2A8.s.o(.data); }
    .main_8002B2A8_bss (NOLOAD) : { build/asm/main_8002B2A8.s.o(.bss); }
    .main_8002BAD0 0x8002BAD0 : AT(0x0002C6D0) { FILL(0x00000000); build/asm/main_8002BAD0.s.o(.text); build/asm/main_8002BAD0.s.o(.rodata); build/asm/main_8002BAD0.s.o(.data); }
    .main_8002BAD0_bss (NOLOAD) : { build/asm/main_8002BAD0.s.o(.bss); }
    .main_8002BE90 0x8002BE90 : AT(0x0002CA90) { FILL(0x00000000); build/asm/main_8002BE90.s.o(.text); build/asm/main_8002BE90.s.o(.rodata); build/asm/main_8002BE90.s.o(.data); }
    .main_8002BE90_bss (NOLOAD) : { build/asm/main_8002BE90.s.o(.bss); }
    .main_8002C010 0x8002C010 : AT(0x0002CC10) { FILL(0x00000000); build/asm/main_8002C010.s.o(.text); build/asm/main_8002C010.s.o(.rodata); build/asm/main_8002C010.s.o(.data); }
    .main_8002C010_bss (NOLOAD) : { build/asm/main_8002C010.s.o(.bss); }
    .main_8002CD90 0x8002CD90 : AT(0x0002D990) { FILL(0x00000000); build/asm/main_8002CD90.s.o(.text); build/asm/main_8002CD90.s.o(.rodata); build/asm/main_8002CD90.s.o(.data); }
    .main_8002CD90_bss (NOLOAD) : { build/asm/main_8002CD90.s.o(.bss); }
    .main_8002D374 0x8002D374 : AT(0x0002DF74) { FILL(0x00000000); build/asm/main_8002D374.s.o(.text); build/asm/main_8002D374.s.o(.rodata); build/asm/main_8002D374.s.o(.data); }
    .main_8002D374_bss (NOLOAD) : { build/asm/main_8002D374.s.o(.bss); }
    .main_8002D840 0x8002D840 : AT(0x0002E440) { FILL(0x00000000); build/asm/main_8002D840.s.o(.text); build/asm/main_8002D840.s.o(.rodata); build/asm/main_8002D840.s.o(.data); }
    .main_8002D840_bss (NOLOAD) : { build/asm/main_8002D840.s.o(.bss); }
    .main_8002D980 0x8002D980 : AT(0x0002E580) { FILL(0x00000000); build/asm/main_8002D980.s.o(.text); build/asm/main_8002D980.s.o(.rodata); build/asm/main_8002D980.s.o(.data); }
    .main_8002D980_bss (NOLOAD) : { build/asm/main_8002D980.s.o(.bss); }
    .main_8002DC90 0x8002DC90 : AT(0x0002E890) { FILL(0x00000000); build/asm/main_8002DC90.s.o(.text); build/asm/main_8002DC90.s.o(.rodata); build/asm/main_8002DC90.s.o(.data); }
    .main_8002DC90_bss (NOLOAD) : { build/asm/main_8002DC90.s.o(.bss); }
    .main_8002DFA0 0x8002DFA0 : AT(0x0002EBA0) { FILL(0x00000000); build/asm/main_8002DFA0.s.o(.text); build/asm/main_8002DFA0.s.o(.rodata); build/asm/main_8002DFA0.s.o(.data); }
    .main_8002DFA0_bss (NOLOAD) : { build/asm/main_8002DFA0.s.o(.bss); }
    .main_8002E8B0 0x8002E8B0 : AT(0x0002F4B0) { FILL(0x00000000); build/asm/main_8002E8B0.s.o(.text); build/asm/main_8002E8B0.s.o(.rodata); build/asm/main_8002E8B0.s.o(.data); }
    .main_8002E8B0_bss (NOLOAD) : { build/asm/main_8002E8B0.s.o(.bss); }
    .main_80030BD0 0x80030BD0 : AT(0x000317D0) { FILL(0x00000000); build/asm/main_80030BD0.s.o(.text); build/asm/main_80030BD0.s.o(.rodata); build/asm/main_80030BD0.s.o(.data); }
    .main_80030BD0_bss (NOLOAD) : { build/asm/main_80030BD0.s.o(.bss); }
    .main_800311B0 0x800311B0 : AT(0x00031DB0) { FILL(0x00000000); build/asm/main_800311B0.s.o(.text); build/asm/main_800311B0.s.o(.rodata); build/asm/main_800311B0.s.o(.data); }
    .main_800311B0_bss (NOLOAD) : { build/asm/main_800311B0.s.o(.bss); }
    .main_80031890 0x80031890 : AT(0x00032490) { FILL(0x00000000); build/asm/main_80031890.s.o(.text); build/asm/main_80031890.s.o(.rodata); build/asm/main_80031890.s.o(.data); }
    .main_80031890_bss (NOLOAD) : { build/asm/main_80031890.s.o(.bss); }
    .main_80031AA0 0x80031AA0 : AT(0x000326A0) { FILL(0x00000000); build/asm/main_80031AA0.s.o(.text); build/asm/main_80031AA0.s.o(.rodata); build/asm/main_80031AA0.s.o(.data); }
    .main_80031AA0_bss (NOLOAD) : { build/asm/main_80031AA0.s.o(.bss); }
    .main_80034AD0 0x80034AD0 : AT(0x000356D0) { FILL(0x00000000); build/asm/main_80034AD0.s.o(.text); build/asm/main_80034AD0.s.o(.rodata); build/asm/main_80034AD0.s.o(.data); }
    .main_80034AD0_bss (NOLOAD) : { build/asm/main_80034AD0.s.o(.bss); }
    .main_80034C70 0x80034C70 : AT(0x00035870) { FILL(0x00000000); build/asm/main_80034C70.s.o(.text); build/asm/main_80034C70.s.o(.rodata); build/asm/main_80034C70.s.o(.data); }
    .main_80034C70_bss (NOLOAD) : { build/asm/main_80034C70.s.o(.bss); }
    .main_80040404 0x80040404 : AT(0x00041004) { FILL(0x00000000); build/asm/main_80040404.s.o(.text); build/asm/main_80040404.s.o(.rodata); build/asm/main_80040404.s.o(.data); }
    .main_80040404_bss (NOLOAD) : { build/asm/main_80040404.s.o(.bss); }
    .main_80040E04 0x80040E04 : AT(0x00041A04) { FILL(0x00000000); build/asm/main_80040E04.s.o(.text); build/asm/main_80040E04.s.o(.rodata); build/asm/main_80040E04.s.o(.data); }
    .main_80040E04_bss (NOLOAD) : { build/asm/main_80040E04.s.o(.bss); }
    .main_8004237C 0x8004237C : AT(0x00042F7C) { FILL(0x00000000); build/asm/main_8004237C.s.o(.text); build/asm/main_8004237C.s.o(.rodata); build/asm/main_8004237C.s.o(.data); }
    .main_8004237C_bss (NOLOAD) : { build/asm/main_8004237C.s.o(.bss); }
    .main_80049524 0x80049524 : AT(0x0004A124) { build/asm/data/main_80049524.bin.o(.data); }
    .main_80051A50 0x80051A50 : AT(0x00052650) { FILL(0x00000000); build/asm/main_80051A50.s.o(.text); build/asm/main_80051A50.s.o(.rodata); build/asm/main_80051A50.s.o(.data); }
    .main_80051A50_bss (NOLOAD) : { build/asm/main_80051A50.s.o(.bss); }
    .main_8005256C 0x8005256C : AT(0x0005316C) { FILL(0x00000000); build/asm/main_8005256C.s.o(.text); build/asm/main_8005256C.s.o(.rodata); build/asm/main_8005256C.s.o(.data); }
    .main_8005256C_bss (NOLOAD) : { build/asm/main_8005256C.s.o(.bss); }
    .main_80053EF0 0x80053EF0 : AT(0x00054AF0) { build/asm/data/main_80053EF0.bin.o(.data); }
    .main_800546F0 0x800546F0 : AT(0x000552F0) { FILL(0x00000000); build/asm/main_800546F0.s.o(.text); build/asm/main_800546F0.s.o(.rodata); build/asm/main_800546F0.s.o(.data); }
    .main_800546F0_bss (NOLOAD) : { build/asm/main_800546F0.s.o(.bss); }
    .main_80054B3C 0x80054B3C : AT(0x0005573C) { build/asm/data/main_80054B3C.bin.o(.data); }
    .main_80054EF0 0x80054EF0 : AT(0x00055AF0) { FILL(0x00000000); build/asm/main_80054EF0.s.o(.text); build/asm/main_80054EF0.s.o(.rodata); build/asm/main_80054EF0.s.o(.data); }
    .main_80054EF0_bss (NOLOAD) : { build/asm/main_80054EF0.s.o(.bss); }
    .main_80055140 0x80055140 : AT(0x00055D40) { build/asm/data/main_80055140.bin.o(.data); }
    .main_800556F0 0x800556F0 : AT(0x000562F0) { FILL(0x00000000); build/asm/main_800556F0.s.o(.text); build/asm/main_800556F0.s.o(.rodata); build/asm/main_800556F0.s.o(.data); }
    .main_800556F0_bss (NOLOAD) : { build/asm/main_800556F0.s.o(.bss); }
    .main_80055940 0x80055940 : AT(0x00056540) { build/asm/data/main_80055940.bin.o(.data); }
    .main_80055EF0 0x80055EF0 : AT(0x00056AF0) { build/asm/data/main_80055EF0.bin.o(.data); }
    .main_80056340 0x80056340 : AT(0x00056F40) { FILL(0x00000000); build/asm/main_80056340.s.o(.text); build/asm/main_80056340.s.o(.rodata); build/asm/main_80056340.s.o(.data); }
    .main_80056340_bss (NOLOAD) : { build/asm/main_80056340.s.o(.bss); }
    .main_800563BC 0x800563BC : AT(0x00056FBC) { build/asm/data/main_800563BC.bin.o(.data); }
    .main_80067008 0x80067008 : AT(0x00067C08) { FILL(0x00000000); build/asm/main_80067008.s.o(.text); build/asm/main_80067008.s.o(.rodata); build/asm/main_80067008.s.o(.data); }
    .main_80067008_bss (NOLOAD) : { build/asm/main_80067008.s.o(.bss); }
    .main_80067660 0x80067660 : AT(0x00068260) { build/asm/data/main_80067660.bin.o(.data); }
    .main_800694B4 0x800694B4 : AT(0x0006A0B4) { FILL(0x00000000); build/asm/main_800694B4.s.o(.text); build/asm/main_800694B4.s.o(.rodata); build/asm/main_800694B4.s.o(.data); }
    .main_800694B4_bss (NOLOAD) : { build/asm/main_800694B4.s.o(.bss); }
    .main_800694D4 0x800694D4 : AT(0x0006A0D4) { build/asm/data/main_800694D4.bin.o(.data); }
    .main_800695B4 0x800695B4 : AT(0x0006A1B4) { FILL(0x00000000); build/asm/main_800695B4.s.o(.text); build/asm/main_800695B4.s.o(.rodata); build/asm/main_800695B4.s.o(.data); }
    .main_800695B4_bss (NOLOAD) : { build/asm/main_800695B4.s.o(.bss); }
    .main_800695E4 0x800695E4 : AT(0x0006A1E4) { build/asm/data/main_800695E4.bin.o(.data); }
    .main_8006C5FC 0x8006C5FC : AT(0x0006D1FC) { FILL(0x00000000); build/asm/main_8006C5FC.s.o(.text); build/asm/main_8006C5FC.s.o(.rodata); build/asm/main_8006C5FC.s.o(.data); }
    .main_8006C5FC_bss (NOLOAD) : { build/asm/main_8006C5FC.s.o(.bss); }
    .main_8006C60C 0x8006C60C : AT(0x0006D20C) { build/asm/data/main_8006C60C.bin.o(.data); }
    .main_8006D098 0x8006D098 : AT(0x0006DC98) { FILL(0x00000000); build/asm/main_8006D098.s.o(.text); build/asm/main_8006D098.s.o(.rodata); build/asm/main_8006D098.s.o(.data); }
    .main_8006D098_bss (NOLOAD) : { build/asm/main_8006D098.s.o(.bss); }
    .main_8006D1B8 0x8006D1B8 : AT(0x0006DDB8) { build/asm/data/main_8006D1B8.bin.o(.data); }
    .main_8006D238 0x8006D238 : AT(0x0006DE38) { FILL(0x00000000); build/asm/main_8006D238.s.o(.text); build/asm/main_8006D238.s.o(.rodata); build/asm/main_8006D238.s.o(.data); }
    .main_8006D238_bss (NOLOAD) : { build/asm/main_8006D238.s.o(.bss); }
    .main_8006D298 0x8006D298 : AT(0x0006DE98) { build/asm/data/main_8006D298.bin.o(.data); }
    .main_8006EA50 0x8006EA50 : AT(0x0006F650) { FILL(0x00000000); build/asm/main_8006EA50.s.o(.text); build/asm/main_8006EA50.s.o(.rodata); build/asm/main_8006EA50.s.o(.data); }
    .main_8006EA50_bss (NOLOAD) : { build/asm/main_8006EA50.s.o(.bss); }
    .main_8006EA70 0x8006EA70 : AT(0x0006F670) { build/asm/data/main_8006EA70.bin.o(.data); }
    .main_8006EBC8 0x8006EBC8 : AT(0x0006F7C8) { FILL(0x00000000); build/asm/main_8006EBC8.s.o(.text); build/asm/main_8006EBC8.s.o(.rodata); build/asm/main_8006EBC8.s.o(.data); }
    .main_8006EBC8_bss (NOLOAD) : { build/asm/main_8006EBC8.s.o(.bss); }
    .main_8006EBD8 0x8006EBD8 : AT(0x0006F7D8) { build/asm/data/main_8006EBD8.bin.o(.data); }
    .main_8006EDC8 0x8006EDC8 : AT(0x0006F9C8) { FILL(0x00000000); build/asm/main_8006EDC8.s.o(.text); build/asm/main_8006EDC8.s.o(.rodata); build/asm/main_8006EDC8.s.o(.data); }
    .main_8006EDC8_bss (NOLOAD) : { build/asm/main_8006EDC8.s.o(.bss); }
    .main_8006EE28 0x8006EE28 : AT(0x0006FA28) { build/asm/data/main_8006EE28.bin.o(.data); }
    .main_8006F7D8 0x8006F7D8 : AT(0x000703D8) { FILL(0x00000000); build/asm/main_8006F7D8.s.o(.text); build/asm/main_8006F7D8.s.o(.rodata); build/asm/main_8006F7D8.s.o(.data); }
    .main_8006F7D8_bss (NOLOAD) : { build/asm/main_8006F7D8.s.o(.bss); }
    .main_8006F7E8 0x8006F7E8 : AT(0x000703E8) { build/asm/data/main_8006F7E8.bin.o(.data); }
    .main_8007A3A4 0x8007A3A4 : AT(0x0007AFA4) { FILL(0x00000000); build/asm/main_8007A3A4.s.o(.text); build/asm/main_8007A3A4.s.o(.rodata); build/asm/main_8007A3A4.s.o(.data); }
    .main_8007A3A4_bss (NOLOAD) : { build/asm/main_8007A3A4.s.o(.bss); }
    .main_80080000 0x80080000 : AT(0x00080C00) { build/asm/data/main_80080000.bin.o(.data); }
    .main_800844D0 0x800844D0 : AT(0x000850D0) { FILL(0x00000000); build/asm/main_800844D0.s.o(.text); build/asm/main_800844D0.s.o(.rodata); build/asm/main_800844D0.s.o(.data); }
    .main_800844D0_bss (NOLOAD) : { build/asm/main_800844D0.s.o(.bss); }
    .main_80087D68 0x80087D68 : AT(0x00088968) { build/asm/data/main_80087D68.bin.o(.data); }
    .main_8008D86C 0x8008D86C : AT(0x0008E46C) { FILL(0x00000000); build/asm/main_8008D86C.s.o(.text); build/asm/main_8008D86C.s.o(.rodata); build/asm/main_8008D86C.s.o(.data); }
    .main_8008D86C_bss (NOLOAD) : { build/asm/main_8008D86C.s.o(.bss); }
    .main_80093C10 0x80093C10 : AT(0x00094810) { build/asm/data/main_80093C10.bin.o(.data); }
    .main_800BA208 0x800BA208 : AT(0x000BAE08) { FILL(0x00000000); build/asm/main_800BA208.s.o(.text); build/asm/main_800BA208.s.o(.rodata); build/asm/main_800BA208.s.o(.data); }
    .main_800BA208_bss (NOLOAD) : { build/asm/main_800BA208.s.o(.bss); }
    .main_800C0000 0x800C0000 : AT(0x000C0C00) { build/asm/data/main_800C0000.bin.o(.data); }
    .main_800CD80C 0x800CD80C : AT(0x000CE40C) { FILL(0x00000000); build/asm/main_800CD80C.s.o(.text); build/asm/main_800CD80C.s.o(.rodata); build/asm/main_800CD80C.s.o(.data); }
    .main_800CD80C_bss (NOLOAD) : { build/asm/main_800CD80C.s.o(.bss); }
    .main_800CF49C 0x800CF49C : AT(0x000D009C) { build/asm/data/main_800CF49C.bin.o(.data); }
    .main_800D0B80 0x800D0B80 : AT(0x000D1780) { FILL(0x00000000); build/asm/main_800D0B80.s.o(.text); build/asm/main_800D0B80.s.o(.rodata); build/asm/main_800D0B80.s.o(.data); }
    .main_800D0B80_bss (NOLOAD) : { build/asm/main_800D0B80.s.o(.bss); }
    .main_800D0B90 0x800D0B90 : AT(0x000D1790) { build/asm/data/main_800D0B90.bin.o(.data); }
    .main_800D4DE0 0x800D4DE0 : AT(0x000D59E0) { FILL(0x00000000); build/asm/main_800D4DE0.s.o(.text); build/asm/main_800D4DE0.s.o(.rodata); build/asm/main_800D4DE0.s.o(.data); }
    .main_800D4DE0_bss (NOLOAD) : { build/asm/main_800D4DE0.s.o(.bss); }
    .main_800D4DF0 0x800D4DF0 : AT(0x000D59F0) { build/asm/data/main_800D4DF0.bin.o(.data); }
    .main_800DFBC0 0x800DFBC0 : AT(0x000E07C0) { FILL(0x00000000); build/asm/main_800DFBC0.s.o(.text); build/asm/main_800DFBC0.s.o(.rodata); build/asm/main_800DFBC0.s.o(.data); }
    .main_800DFBC0_bss (NOLOAD) : { build/asm/main_800DFBC0.s.o(.bss); }
    .main_800E23A0 0x800E23A0 : AT(0x000E2FA0) { build/asm/data/main_800E23A0.bin.o(.data); }
    .main_800EAC8C 0x800EAC8C : AT(0x000EB88C) { FILL(0x00000000); build/asm/main_800EAC8C.s.o(.text); build/asm/main_800EAC8C.s.o(.rodata); build/asm/main_800EAC8C.s.o(.data); }
    .main_800EAC8C_bss (NOLOAD) : { build/asm/main_800EAC8C.s.o(.bss); }
    .main_800EB134 0x800EB134 : AT(0x000EBD34) { build/asm/data/main_800EB134.bin.o(.data); }
    .main_800EB190 0x800EB190 : AT(0x000EBD90) { FILL(0x00000000); build/asm/main_800EB190.s.o(.text); build/asm/main_800EB190.s.o(.rodata); build/asm/main_800EB190.s.o(.data); }
    .main_800EB190_bss (NOLOAD) : { build/asm/main_800EB190.s.o(.bss); }
    .main_800EB32C 0x800EB32C : AT(0x000EBF2C) { build/asm/data/main_800EB32C.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
