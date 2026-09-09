SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80004C80 0x80004C80 : AT(0x00005880) { FILL(0x00000000); build/asm/main_80004C80.s.o(.text); build/asm/main_80004C80.s.o(.rodata); build/asm/main_80004C80.s.o(.data); }
    .main_80004C80_bss (NOLOAD) : { build/asm/main_80004C80.s.o(.bss); }
    .main_800054D0 0x800054D0 : AT(0x000060D0) { FILL(0x00000000); build/asm/main_800054D0.s.o(.text); build/asm/main_800054D0.s.o(.rodata); build/asm/main_800054D0.s.o(.data); }
    .main_800054D0_bss (NOLOAD) : { build/asm/main_800054D0.s.o(.bss); }
    .main_80005C30 0x80005C30 : AT(0x00006830) { FILL(0x00000000); build/asm/main_80005C30.s.o(.text); build/asm/main_80005C30.s.o(.rodata); build/asm/main_80005C30.s.o(.data); }
    .main_80005C30_bss (NOLOAD) : { build/asm/main_80005C30.s.o(.bss); }
    .main_80006078 0x80006078 : AT(0x00006C78) { FILL(0x00000000); build/asm/main_80006078.s.o(.text); build/asm/main_80006078.s.o(.rodata); build/asm/main_80006078.s.o(.data); }
    .main_80006078_bss (NOLOAD) : { build/asm/main_80006078.s.o(.bss); }
    .main_80006EF8 0x80006EF8 : AT(0x00007AF8) { FILL(0x00000000); build/asm/main_80006EF8.s.o(.text); build/asm/main_80006EF8.s.o(.rodata); build/asm/main_80006EF8.s.o(.data); }
    .main_80006EF8_bss (NOLOAD) : { build/asm/main_80006EF8.s.o(.bss); }
    .main_80007EFC 0x80007EFC : AT(0x00008AFC) { FILL(0x00000000); build/asm/main_80007EFC.s.o(.text); build/asm/main_80007EFC.s.o(.rodata); build/asm/main_80007EFC.s.o(.data); }
    .main_80007EFC_bss (NOLOAD) : { build/asm/main_80007EFC.s.o(.bss); }
    .main_80008B88 0x80008B88 : AT(0x00009788) { FILL(0x00000000); build/asm/main_80008B88.s.o(.text); build/asm/main_80008B88.s.o(.rodata); build/asm/main_80008B88.s.o(.data); }
    .main_80008B88_bss (NOLOAD) : { build/asm/main_80008B88.s.o(.bss); }
    .main_8000DAF4 0x8000DAF4 : AT(0x0000E6F4) { FILL(0x00000000); build/asm/main_8000DAF4.s.o(.text); build/asm/main_8000DAF4.s.o(.rodata); build/asm/main_8000DAF4.s.o(.data); }
    .main_8000DAF4_bss (NOLOAD) : { build/asm/main_8000DAF4.s.o(.bss); }
    .main_8000F8EC 0x8000F8EC : AT(0x000104EC) { FILL(0x00000000); build/asm/main_8000F8EC.s.o(.text); build/asm/main_8000F8EC.s.o(.rodata); build/asm/main_8000F8EC.s.o(.data); }
    .main_8000F8EC_bss (NOLOAD) : { build/asm/main_8000F8EC.s.o(.bss); }
    .main_8000FD24 0x8000FD24 : AT(0x00010924) { FILL(0x00000000); build/asm/main_8000FD24.s.o(.text); build/asm/main_8000FD24.s.o(.rodata); build/asm/main_8000FD24.s.o(.data); }
    .main_8000FD24_bss (NOLOAD) : { build/asm/main_8000FD24.s.o(.bss); }
    .main_80011F30 0x80011F30 : AT(0x00012B30) { FILL(0x00000000); build/asm/main_80011F30.s.o(.text); build/asm/main_80011F30.s.o(.rodata); build/asm/main_80011F30.s.o(.data); }
    .main_80011F30_bss (NOLOAD) : { build/asm/main_80011F30.s.o(.bss); }
    .main_80012F90 0x80012F90 : AT(0x00013B90) { FILL(0x00000000); build/asm/main_80012F90.s.o(.text); build/asm/main_80012F90.s.o(.rodata); build/asm/main_80012F90.s.o(.data); }
    .main_80012F90_bss (NOLOAD) : { build/asm/main_80012F90.s.o(.bss); }
    .main_80015310 0x80015310 : AT(0x00015F10) { FILL(0x00000000); build/asm/main_80015310.s.o(.text); build/asm/main_80015310.s.o(.rodata); build/asm/main_80015310.s.o(.data); }
    .main_80015310_bss (NOLOAD) : { build/asm/main_80015310.s.o(.bss); }
    .main_800159F8 0x800159F8 : AT(0x000165F8) { FILL(0x00000000); build/asm/main_800159F8.s.o(.text); build/asm/main_800159F8.s.o(.rodata); build/asm/main_800159F8.s.o(.data); }
    .main_800159F8_bss (NOLOAD) : { build/asm/main_800159F8.s.o(.bss); }
    .main_80019040 0x80019040 : AT(0x00019C40) { FILL(0x00000000); build/asm/main_80019040.s.o(.text); build/asm/main_80019040.s.o(.rodata); build/asm/main_80019040.s.o(.data); }
    .main_80019040_bss (NOLOAD) : { build/asm/main_80019040.s.o(.bss); }
    .main_80019C48 0x80019C48 : AT(0x0001A848) { FILL(0x00000000); build/asm/main_80019C48.s.o(.text); build/asm/main_80019C48.s.o(.rodata); build/asm/main_80019C48.s.o(.data); }
    .main_80019C48_bss (NOLOAD) : { build/asm/main_80019C48.s.o(.bss); }
    .main_8001A7BC 0x8001A7BC : AT(0x0001B3BC) { FILL(0x00000000); build/asm/main_8001A7BC.s.o(.text); build/asm/main_8001A7BC.s.o(.rodata); build/asm/main_8001A7BC.s.o(.data); }
    .main_8001A7BC_bss (NOLOAD) : { build/asm/main_8001A7BC.s.o(.bss); }
    .main_8001C4B4 0x8001C4B4 : AT(0x0001D0B4) { FILL(0x00000000); build/asm/main_8001C4B4.s.o(.text); build/asm/main_8001C4B4.s.o(.rodata); build/asm/main_8001C4B4.s.o(.data); }
    .main_8001C4B4_bss (NOLOAD) : { build/asm/main_8001C4B4.s.o(.bss); }
    .main_80022FEC 0x80022FEC : AT(0x00023BEC) { FILL(0x00000000); build/asm/main_80022FEC.s.o(.text); build/asm/main_80022FEC.s.o(.rodata); build/asm/main_80022FEC.s.o(.data); }
    .main_80022FEC_bss (NOLOAD) : { build/asm/main_80022FEC.s.o(.bss); }
    .main_80023374 0x80023374 : AT(0x00023F74) { FILL(0x00000000); build/asm/main_80023374.s.o(.text); build/asm/main_80023374.s.o(.rodata); build/asm/main_80023374.s.o(.data); }
    .main_80023374_bss (NOLOAD) : { build/asm/main_80023374.s.o(.bss); }
    .main_80024F00 0x80024F00 : AT(0x00025B00) { FILL(0x00000000); build/asm/main_80024F00.s.o(.text); build/asm/main_80024F00.s.o(.rodata); build/asm/main_80024F00.s.o(.data); }
    .main_80024F00_bss (NOLOAD) : { build/asm/main_80024F00.s.o(.bss); }
    .main_80029C68 0x80029C68 : AT(0x0002A868) { FILL(0x00000000); build/asm/main_80029C68.s.o(.text); build/asm/main_80029C68.s.o(.rodata); build/asm/main_80029C68.s.o(.data); }
    .main_80029C68_bss (NOLOAD) : { build/asm/main_80029C68.s.o(.bss); }
    .main_8002A294 0x8002A294 : AT(0x0002AE94) { FILL(0x00000000); build/asm/main_8002A294.s.o(.text); build/asm/main_8002A294.s.o(.rodata); build/asm/main_8002A294.s.o(.data); }
    .main_8002A294_bss (NOLOAD) : { build/asm/main_8002A294.s.o(.bss); }
    .main_8002A4F8 0x8002A4F8 : AT(0x0002B0F8) { FILL(0x00000000); build/asm/main_8002A4F8.s.o(.text); build/asm/main_8002A4F8.s.o(.rodata); build/asm/main_8002A4F8.s.o(.data); }
    .main_8002A4F8_bss (NOLOAD) : { build/asm/main_8002A4F8.s.o(.bss); }
    .main_8002A79C 0x8002A79C : AT(0x0002B39C) { FILL(0x00000000); build/asm/main_8002A79C.s.o(.text); build/asm/main_8002A79C.s.o(.rodata); build/asm/main_8002A79C.s.o(.data); }
    .main_8002A79C_bss (NOLOAD) : { build/asm/main_8002A79C.s.o(.bss); }
    .main_8002B754 0x8002B754 : AT(0x0002C354) { FILL(0x00000000); build/asm/main_8002B754.s.o(.text); build/asm/main_8002B754.s.o(.rodata); build/asm/main_8002B754.s.o(.data); }
    .main_8002B754_bss (NOLOAD) : { build/asm/main_8002B754.s.o(.bss); }
    .main_8002E440 0x8002E440 : AT(0x0002F040) { FILL(0x00000000); build/asm/main_8002E440.s.o(.text); build/asm/main_8002E440.s.o(.rodata); build/asm/main_8002E440.s.o(.data); }
    .main_8002E440_bss (NOLOAD) : { build/asm/main_8002E440.s.o(.bss); }
    .main_8002FE18 0x8002FE18 : AT(0x00030A18) { FILL(0x00000000); build/asm/main_8002FE18.s.o(.text); build/asm/main_8002FE18.s.o(.rodata); build/asm/main_8002FE18.s.o(.data); }
    .main_8002FE18_bss (NOLOAD) : { build/asm/main_8002FE18.s.o(.bss); }
    .main_8002FF40 0x8002FF40 : AT(0x00030B40) { FILL(0x00000000); build/asm/main_8002FF40.s.o(.text); build/asm/main_8002FF40.s.o(.rodata); build/asm/main_8002FF40.s.o(.data); }
    .main_8002FF40_bss (NOLOAD) : { build/asm/main_8002FF40.s.o(.bss); }
    .main_80030230 0x80030230 : AT(0x00030E30) { FILL(0x00000000); build/asm/main_80030230.s.o(.text); build/asm/main_80030230.s.o(.rodata); build/asm/main_80030230.s.o(.data); }
    .main_80030230_bss (NOLOAD) : { build/asm/main_80030230.s.o(.bss); }
    .main_80030D48 0x80030D48 : AT(0x00031948) { FILL(0x00000000); build/asm/main_80030D48.s.o(.text); build/asm/main_80030D48.s.o(.rodata); build/asm/main_80030D48.s.o(.data); }
    .main_80030D48_bss (NOLOAD) : { build/asm/main_80030D48.s.o(.bss); }
    .main_80031E74 0x80031E74 : AT(0x00032A74) { FILL(0x00000000); build/asm/main_80031E74.s.o(.text); build/asm/main_80031E74.s.o(.rodata); build/asm/main_80031E74.s.o(.data); }
    .main_80031E74_bss (NOLOAD) : { build/asm/main_80031E74.s.o(.bss); }
    .main_8003308C 0x8003308C : AT(0x00033C8C) { FILL(0x00000000); build/asm/main_8003308C.s.o(.text); build/asm/main_8003308C.s.o(.rodata); build/asm/main_8003308C.s.o(.data); }
    .main_8003308C_bss (NOLOAD) : { build/asm/main_8003308C.s.o(.bss); }
    .main_80033A0C 0x80033A0C : AT(0x0003460C) { FILL(0x00000000); build/asm/main_80033A0C.s.o(.text); build/asm/main_80033A0C.s.o(.rodata); build/asm/main_80033A0C.s.o(.data); }
    .main_80033A0C_bss (NOLOAD) : { build/asm/main_80033A0C.s.o(.bss); }
    .main_800348F4 0x800348F4 : AT(0x000354F4) { FILL(0x00000000); build/asm/main_800348F4.s.o(.text); build/asm/main_800348F4.s.o(.rodata); build/asm/main_800348F4.s.o(.data); }
    .main_800348F4_bss (NOLOAD) : { build/asm/main_800348F4.s.o(.bss); }
    .main_80035B40 0x80035B40 : AT(0x00036740) { FILL(0x00000000); build/asm/main_80035B40.s.o(.text); build/asm/main_80035B40.s.o(.rodata); build/asm/main_80035B40.s.o(.data); }
    .main_80035B40_bss (NOLOAD) : { build/asm/main_80035B40.s.o(.bss); }
    .main_800364B0 0x800364B0 : AT(0x000370B0) { FILL(0x00000000); build/asm/main_800364B0.s.o(.text); build/asm/main_800364B0.s.o(.rodata); build/asm/main_800364B0.s.o(.data); }
    .main_800364B0_bss (NOLOAD) : { build/asm/main_800364B0.s.o(.bss); }
    .main_80037178 0x80037178 : AT(0x00037D78) { FILL(0x00000000); build/asm/main_80037178.s.o(.text); build/asm/main_80037178.s.o(.rodata); build/asm/main_80037178.s.o(.data); }
    .main_80037178_bss (NOLOAD) : { build/asm/main_80037178.s.o(.bss); }
    .main_80037DC0 0x80037DC0 : AT(0x000389C0) { FILL(0x00000000); build/asm/main_80037DC0.s.o(.text); build/asm/main_80037DC0.s.o(.rodata); build/asm/main_80037DC0.s.o(.data); }
    .main_80037DC0_bss (NOLOAD) : { build/asm/main_80037DC0.s.o(.bss); }
    .main_80038348 0x80038348 : AT(0x00038F48) { FILL(0x00000000); build/asm/main_80038348.s.o(.text); build/asm/main_80038348.s.o(.rodata); build/asm/main_80038348.s.o(.data); }
    .main_80038348_bss (NOLOAD) : { build/asm/main_80038348.s.o(.bss); }
    .main_80038520 0x80038520 : AT(0x00039120) { FILL(0x00000000); build/asm/main_80038520.s.o(.text); build/asm/main_80038520.s.o(.rodata); build/asm/main_80038520.s.o(.data); }
    .main_80038520_bss (NOLOAD) : { build/asm/main_80038520.s.o(.bss); }
    .main_800389BC 0x800389BC : AT(0x000395BC) { FILL(0x00000000); build/asm/main_800389BC.s.o(.text); build/asm/main_800389BC.s.o(.rodata); build/asm/main_800389BC.s.o(.data); }
    .main_800389BC_bss (NOLOAD) : { build/asm/main_800389BC.s.o(.bss); }
    .main_8003A95C 0x8003A95C : AT(0x0003B55C) { FILL(0x00000000); build/asm/main_8003A95C.s.o(.text); build/asm/main_8003A95C.s.o(.rodata); build/asm/main_8003A95C.s.o(.data); }
    .main_8003A95C_bss (NOLOAD) : { build/asm/main_8003A95C.s.o(.bss); }
    .main_8003B3C4 0x8003B3C4 : AT(0x0003BFC4) { FILL(0x00000000); build/asm/main_8003B3C4.s.o(.text); build/asm/main_8003B3C4.s.o(.rodata); build/asm/main_8003B3C4.s.o(.data); }
    .main_8003B3C4_bss (NOLOAD) : { build/asm/main_8003B3C4.s.o(.bss); }
    .main_8003B790 0x8003B790 : AT(0x0003C390) { FILL(0x00000000); build/asm/main_8003B790.s.o(.text); build/asm/main_8003B790.s.o(.rodata); build/asm/main_8003B790.s.o(.data); }
    .main_8003B790_bss (NOLOAD) : { build/asm/main_8003B790.s.o(.bss); }
    .main_8003BD98 0x8003BD98 : AT(0x0003C998) { FILL(0x00000000); build/asm/main_8003BD98.s.o(.text); build/asm/main_8003BD98.s.o(.rodata); build/asm/main_8003BD98.s.o(.data); }
    .main_8003BD98_bss (NOLOAD) : { build/asm/main_8003BD98.s.o(.bss); }
    .main_8003C930 0x8003C930 : AT(0x0003D530) { FILL(0x00000000); build/asm/main_8003C930.s.o(.text); build/asm/main_8003C930.s.o(.rodata); build/asm/main_8003C930.s.o(.data); }
    .main_8003C930_bss (NOLOAD) : { build/asm/main_8003C930.s.o(.bss); }
    .main_8003CC04 0x8003CC04 : AT(0x0003D804) { FILL(0x00000000); build/asm/main_8003CC04.s.o(.text); build/asm/main_8003CC04.s.o(.rodata); build/asm/main_8003CC04.s.o(.data); }
    .main_8003CC04_bss (NOLOAD) : { build/asm/main_8003CC04.s.o(.bss); }
    .main_8003CF50 0x8003CF50 : AT(0x0003DB50) { FILL(0x00000000); build/asm/main_8003CF50.s.o(.text); build/asm/main_8003CF50.s.o(.rodata); build/asm/main_8003CF50.s.o(.data); }
    .main_8003CF50_bss (NOLOAD) : { build/asm/main_8003CF50.s.o(.bss); }
    .main_8003CFBC 0x8003CFBC : AT(0x0003DBBC) { FILL(0x00000000); build/asm/main_8003CFBC.s.o(.text); build/asm/main_8003CFBC.s.o(.rodata); build/asm/main_8003CFBC.s.o(.data); }
    .main_8003CFBC_bss (NOLOAD) : { build/asm/main_8003CFBC.s.o(.bss); }
    .main_8003D688 0x8003D688 : AT(0x0003E288) { FILL(0x00000000); build/asm/main_8003D688.s.o(.text); build/asm/main_8003D688.s.o(.rodata); build/asm/main_8003D688.s.o(.data); }
    .main_8003D688_bss (NOLOAD) : { build/asm/main_8003D688.s.o(.bss); }
    .main_8003D93C 0x8003D93C : AT(0x0003E53C) { FILL(0x00000000); build/asm/main_8003D93C.s.o(.text); build/asm/main_8003D93C.s.o(.rodata); build/asm/main_8003D93C.s.o(.data); }
    .main_8003D93C_bss (NOLOAD) : { build/asm/main_8003D93C.s.o(.bss); }
    .main_8003DA18 0x8003DA18 : AT(0x0003E618) { FILL(0x00000000); build/asm/main_8003DA18.s.o(.text); build/asm/main_8003DA18.s.o(.rodata); build/asm/main_8003DA18.s.o(.data); }
    .main_8003DA18_bss (NOLOAD) : { build/asm/main_8003DA18.s.o(.bss); }
    .main_8003E588 0x8003E588 : AT(0x0003F188) { FILL(0x00000000); build/asm/main_8003E588.s.o(.text); build/asm/main_8003E588.s.o(.rodata); build/asm/main_8003E588.s.o(.data); }
    .main_8003E588_bss (NOLOAD) : { build/asm/main_8003E588.s.o(.bss); }
    .main_80040020 0x80040020 : AT(0x00040C20) { FILL(0x00000000); build/asm/main_80040020.s.o(.text); build/asm/main_80040020.s.o(.rodata); build/asm/main_80040020.s.o(.data); }
    .main_80040020_bss (NOLOAD) : { build/asm/main_80040020.s.o(.bss); }
    .main_80040310 0x80040310 : AT(0x00040F10) { FILL(0x00000000); build/asm/main_80040310.s.o(.text); build/asm/main_80040310.s.o(.rodata); build/asm/main_80040310.s.o(.data); }
    .main_80040310_bss (NOLOAD) : { build/asm/main_80040310.s.o(.bss); }
    .main_80040D14 0x80040D14 : AT(0x00041914) { FILL(0x00000000); build/asm/main_80040D14.s.o(.text); build/asm/main_80040D14.s.o(.rodata); build/asm/main_80040D14.s.o(.data); }
    .main_80040D14_bss (NOLOAD) : { build/asm/main_80040D14.s.o(.bss); }
    .main_80040E9C 0x80040E9C : AT(0x00041A9C) { FILL(0x00000000); build/asm/main_80040E9C.s.o(.text); build/asm/main_80040E9C.s.o(.rodata); build/asm/main_80040E9C.s.o(.data); }
    .main_80040E9C_bss (NOLOAD) : { build/asm/main_80040E9C.s.o(.bss); }
    .main_800414FC 0x800414FC : AT(0x000420FC) { FILL(0x00000000); build/asm/main_800414FC.s.o(.text); build/asm/main_800414FC.s.o(.rodata); build/asm/main_800414FC.s.o(.data); }
    .main_800414FC_bss (NOLOAD) : { build/asm/main_800414FC.s.o(.bss); }
    .main_80041794 0x80041794 : AT(0x00042394) { FILL(0x00000000); build/asm/main_80041794.s.o(.text); build/asm/main_80041794.s.o(.rodata); build/asm/main_80041794.s.o(.data); }
    .main_80041794_bss (NOLOAD) : { build/asm/main_80041794.s.o(.bss); }
    .main_80041A78 0x80041A78 : AT(0x00042678) { FILL(0x00000000); build/asm/main_80041A78.s.o(.text); build/asm/main_80041A78.s.o(.rodata); build/asm/main_80041A78.s.o(.data); }
    .main_80041A78_bss (NOLOAD) : { build/asm/main_80041A78.s.o(.bss); }
    .main_80041F40 0x80041F40 : AT(0x00042B40) { FILL(0x00000000); build/asm/main_80041F40.s.o(.text); build/asm/main_80041F40.s.o(.rodata); build/asm/main_80041F40.s.o(.data); }
    .main_80041F40_bss (NOLOAD) : { build/asm/main_80041F40.s.o(.bss); }
    .main_800420C8 0x800420C8 : AT(0x00042CC8) { FILL(0x00000000); build/asm/main_800420C8.s.o(.text); build/asm/main_800420C8.s.o(.rodata); build/asm/main_800420C8.s.o(.data); }
    .main_800420C8_bss (NOLOAD) : { build/asm/main_800420C8.s.o(.bss); }
    .main_800421C0 0x800421C0 : AT(0x00042DC0) { FILL(0x00000000); build/asm/main_800421C0.s.o(.text); build/asm/main_800421C0.s.o(.rodata); build/asm/main_800421C0.s.o(.data); }
    .main_800421C0_bss (NOLOAD) : { build/asm/main_800421C0.s.o(.bss); }
    .main_8004276C 0x8004276C : AT(0x0004336C) { FILL(0x00000000); build/asm/main_8004276C.s.o(.text); build/asm/main_8004276C.s.o(.rodata); build/asm/main_8004276C.s.o(.data); }
    .main_8004276C_bss (NOLOAD) : { build/asm/main_8004276C.s.o(.bss); }
    .main_80042978 0x80042978 : AT(0x00043578) { FILL(0x00000000); build/asm/main_80042978.s.o(.text); build/asm/main_80042978.s.o(.rodata); build/asm/main_80042978.s.o(.data); }
    .main_80042978_bss (NOLOAD) : { build/asm/main_80042978.s.o(.bss); }
    .main_80042C10 0x80042C10 : AT(0x00043810) { FILL(0x00000000); build/asm/main_80042C10.s.o(.text); build/asm/main_80042C10.s.o(.rodata); build/asm/main_80042C10.s.o(.data); }
    .main_80042C10_bss (NOLOAD) : { build/asm/main_80042C10.s.o(.bss); }
    .main_80043150 0x80043150 : AT(0x00043D50) { FILL(0x00000000); build/asm/main_80043150.s.o(.text); build/asm/main_80043150.s.o(.rodata); build/asm/main_80043150.s.o(.data); }
    .main_80043150_bss (NOLOAD) : { build/asm/main_80043150.s.o(.bss); }
    .main_80044D28 0x80044D28 : AT(0x00045928) { FILL(0x00000000); build/asm/main_80044D28.s.o(.text); build/asm/main_80044D28.s.o(.rodata); build/asm/main_80044D28.s.o(.data); }
    .main_80044D28_bss (NOLOAD) : { build/asm/main_80044D28.s.o(.bss); }
    .main_80044E40 0x80044E40 : AT(0x00045A40) { FILL(0x00000000); build/asm/main_80044E40.s.o(.text); build/asm/main_80044E40.s.o(.rodata); build/asm/main_80044E40.s.o(.data); }
    .main_80044E40_bss (NOLOAD) : { build/asm/main_80044E40.s.o(.bss); }
    .main_80045560 0x80045560 : AT(0x00046160) { FILL(0x00000000); build/asm/main_80045560.s.o(.text); build/asm/main_80045560.s.o(.rodata); build/asm/main_80045560.s.o(.data); }
    .main_80045560_bss (NOLOAD) : { build/asm/main_80045560.s.o(.bss); }
    .main_80045D18 0x80045D18 : AT(0x00046918) { FILL(0x00000000); build/asm/main_80045D18.s.o(.text); build/asm/main_80045D18.s.o(.rodata); build/asm/main_80045D18.s.o(.data); }
    .main_80045D18_bss (NOLOAD) : { build/asm/main_80045D18.s.o(.bss); }
    .main_80046A40 0x80046A40 : AT(0x00047640) { FILL(0x00000000); build/asm/main_80046A40.s.o(.text); build/asm/main_80046A40.s.o(.rodata); build/asm/main_80046A40.s.o(.data); }
    .main_80046A40_bss (NOLOAD) : { build/asm/main_80046A40.s.o(.bss); }
    .main_800471CC 0x800471CC : AT(0x00047DCC) { FILL(0x00000000); build/asm/main_800471CC.s.o(.text); build/asm/main_800471CC.s.o(.rodata); build/asm/main_800471CC.s.o(.data); }
    .main_800471CC_bss (NOLOAD) : { build/asm/main_800471CC.s.o(.bss); }
    .main_80047568 0x80047568 : AT(0x00048168) { FILL(0x00000000); build/asm/main_80047568.s.o(.text); build/asm/main_80047568.s.o(.rodata); build/asm/main_80047568.s.o(.data); }
    .main_80047568_bss (NOLOAD) : { build/asm/main_80047568.s.o(.bss); }
    .main_80047B10 0x80047B10 : AT(0x00048710) { FILL(0x00000000); build/asm/main_80047B10.s.o(.text); build/asm/main_80047B10.s.o(.rodata); build/asm/main_80047B10.s.o(.data); }
    .main_80047B10_bss (NOLOAD) : { build/asm/main_80047B10.s.o(.bss); }
    .main_80047F4C 0x80047F4C : AT(0x00048B4C) { FILL(0x00000000); build/asm/main_80047F4C.s.o(.text); build/asm/main_80047F4C.s.o(.rodata); build/asm/main_80047F4C.s.o(.data); }
    .main_80047F4C_bss (NOLOAD) : { build/asm/main_80047F4C.s.o(.bss); }
    .main_80048960 0x80048960 : AT(0x00049560) { FILL(0x00000000); build/asm/main_80048960.s.o(.text); build/asm/main_80048960.s.o(.rodata); build/asm/main_80048960.s.o(.data); }
    .main_80048960_bss (NOLOAD) : { build/asm/main_80048960.s.o(.bss); }
    .main_80048F8C 0x80048F8C : AT(0x00049B8C) { FILL(0x00000000); build/asm/main_80048F8C.s.o(.text); build/asm/main_80048F8C.s.o(.rodata); build/asm/main_80048F8C.s.o(.data); }
    .main_80048F8C_bss (NOLOAD) : { build/asm/main_80048F8C.s.o(.bss); }
    .main_800494E0 0x800494E0 : AT(0x0004A0E0) { FILL(0x00000000); build/asm/main_800494E0.s.o(.text); build/asm/main_800494E0.s.o(.rodata); build/asm/main_800494E0.s.o(.data); }
    .main_800494E0_bss (NOLOAD) : { build/asm/main_800494E0.s.o(.bss); }
    .main_8004AFB8 0x8004AFB8 : AT(0x0004BBB8) { FILL(0x00000000); build/asm/main_8004AFB8.s.o(.text); build/asm/main_8004AFB8.s.o(.rodata); build/asm/main_8004AFB8.s.o(.data); }
    .main_8004AFB8_bss (NOLOAD) : { build/asm/main_8004AFB8.s.o(.bss); }
    .main_8004B430 0x8004B430 : AT(0x0004C030) { FILL(0x00000000); build/asm/main_8004B430.s.o(.text); build/asm/main_8004B430.s.o(.rodata); build/asm/main_8004B430.s.o(.data); }
    .main_8004B430_bss (NOLOAD) : { build/asm/main_8004B430.s.o(.bss); }
    .main_8004C644 0x8004C644 : AT(0x0004D244) { FILL(0x00000000); build/asm/main_8004C644.s.o(.text); build/asm/main_8004C644.s.o(.rodata); build/asm/main_8004C644.s.o(.data); }
    .main_8004C644_bss (NOLOAD) : { build/asm/main_8004C644.s.o(.bss); }
    .main_8004DA90 0x8004DA90 : AT(0x0004E690) { FILL(0x00000000); build/asm/main_8004DA90.s.o(.text); build/asm/main_8004DA90.s.o(.rodata); build/asm/main_8004DA90.s.o(.data); }
    .main_8004DA90_bss (NOLOAD) : { build/asm/main_8004DA90.s.o(.bss); }
    .main_8004EC6C 0x8004EC6C : AT(0x0004F86C) { FILL(0x00000000); build/asm/main_8004EC6C.s.o(.text); build/asm/main_8004EC6C.s.o(.rodata); build/asm/main_8004EC6C.s.o(.data); }
    .main_8004EC6C_bss (NOLOAD) : { build/asm/main_8004EC6C.s.o(.bss); }
    .main_8004F2DC 0x8004F2DC : AT(0x0004FEDC) { FILL(0x00000000); build/asm/main_8004F2DC.s.o(.text); build/asm/main_8004F2DC.s.o(.rodata); build/asm/main_8004F2DC.s.o(.data); }
    .main_8004F2DC_bss (NOLOAD) : { build/asm/main_8004F2DC.s.o(.bss); }
    .main_8004F75C 0x8004F75C : AT(0x0005035C) { FILL(0x00000000); build/asm/main_8004F75C.s.o(.text); build/asm/main_8004F75C.s.o(.rodata); build/asm/main_8004F75C.s.o(.data); }
    .main_8004F75C_bss (NOLOAD) : { build/asm/main_8004F75C.s.o(.bss); }
    .main_8004F964 0x8004F964 : AT(0x00050564) { FILL(0x00000000); build/asm/main_8004F964.s.o(.text); build/asm/main_8004F964.s.o(.rodata); build/asm/main_8004F964.s.o(.data); }
    .main_8004F964_bss (NOLOAD) : { build/asm/main_8004F964.s.o(.bss); }
    .main_8004FCC4 0x8004FCC4 : AT(0x000508C4) { FILL(0x00000000); build/asm/main_8004FCC4.s.o(.text); build/asm/main_8004FCC4.s.o(.rodata); build/asm/main_8004FCC4.s.o(.data); }
    .main_8004FCC4_bss (NOLOAD) : { build/asm/main_8004FCC4.s.o(.bss); }
    .main_8004FF90 0x8004FF90 : AT(0x00050B90) { FILL(0x00000000); build/asm/main_8004FF90.s.o(.text); build/asm/main_8004FF90.s.o(.rodata); build/asm/main_8004FF90.s.o(.data); }
    .main_8004FF90_bss (NOLOAD) : { build/asm/main_8004FF90.s.o(.bss); }
    .main_800507E0 0x800507E0 : AT(0x000513E0) { FILL(0x00000000); build/asm/main_800507E0.s.o(.text); build/asm/main_800507E0.s.o(.rodata); build/asm/main_800507E0.s.o(.data); }
    .main_800507E0_bss (NOLOAD) : { build/asm/main_800507E0.s.o(.bss); }
    .main_80050908 0x80050908 : AT(0x00051508) { FILL(0x00000000); build/asm/main_80050908.s.o(.text); build/asm/main_80050908.s.o(.rodata); build/asm/main_80050908.s.o(.data); }
    .main_80050908_bss (NOLOAD) : { build/asm/main_80050908.s.o(.bss); }
    .main_80050A1C 0x80050A1C : AT(0x0005161C) { FILL(0x00000000); build/asm/main_80050A1C.s.o(.text); build/asm/main_80050A1C.s.o(.rodata); build/asm/main_80050A1C.s.o(.data); }
    .main_80050A1C_bss (NOLOAD) : { build/asm/main_80050A1C.s.o(.bss); }
    .main_80050B2C 0x80050B2C : AT(0x0005172C) { FILL(0x00000000); build/asm/main_80050B2C.s.o(.text); build/asm/main_80050B2C.s.o(.rodata); build/asm/main_80050B2C.s.o(.data); }
    .main_80050B2C_bss (NOLOAD) : { build/asm/main_80050B2C.s.o(.bss); }
    .main_80050DF4 0x80050DF4 : AT(0x000519F4) { FILL(0x00000000); build/asm/main_80050DF4.s.o(.text); build/asm/main_80050DF4.s.o(.rodata); build/asm/main_80050DF4.s.o(.data); }
    .main_80050DF4_bss (NOLOAD) : { build/asm/main_80050DF4.s.o(.bss); }
    .main_8005100C 0x8005100C : AT(0x00051C0C) { FILL(0x00000000); build/asm/main_8005100C.s.o(.text); build/asm/main_8005100C.s.o(.rodata); build/asm/main_8005100C.s.o(.data); }
    .main_8005100C_bss (NOLOAD) : { build/asm/main_8005100C.s.o(.bss); }
    .main_80051708 0x80051708 : AT(0x00052308) { FILL(0x00000000); build/asm/main_80051708.s.o(.text); build/asm/main_80051708.s.o(.rodata); build/asm/main_80051708.s.o(.data); }
    .main_80051708_bss (NOLOAD) : { build/asm/main_80051708.s.o(.bss); }
    .main_80051D20 0x80051D20 : AT(0x00052920) { FILL(0x00000000); build/asm/main_80051D20.s.o(.text); build/asm/main_80051D20.s.o(.rodata); build/asm/main_80051D20.s.o(.data); }
    .main_80051D20_bss (NOLOAD) : { build/asm/main_80051D20.s.o(.bss); }
    .main_8005208C 0x8005208C : AT(0x00052C8C) { FILL(0x00000000); build/asm/main_8005208C.s.o(.text); build/asm/main_8005208C.s.o(.rodata); build/asm/main_8005208C.s.o(.data); }
    .main_8005208C_bss (NOLOAD) : { build/asm/main_8005208C.s.o(.bss); }
    .main_800531D0 0x800531D0 : AT(0x00053DD0) { FILL(0x00000000); build/asm/main_800531D0.s.o(.text); build/asm/main_800531D0.s.o(.rodata); build/asm/main_800531D0.s.o(.data); }
    .main_800531D0_bss (NOLOAD) : { build/asm/main_800531D0.s.o(.bss); }
    .main_800535E0 0x800535E0 : AT(0x000541E0) { FILL(0x00000000); build/asm/main_800535E0.s.o(.text); build/asm/main_800535E0.s.o(.rodata); build/asm/main_800535E0.s.o(.data); }
    .main_800535E0_bss (NOLOAD) : { build/asm/main_800535E0.s.o(.bss); }
    .main_80053AD8 0x80053AD8 : AT(0x000546D8) { FILL(0x00000000); build/asm/main_80053AD8.s.o(.text); build/asm/main_80053AD8.s.o(.rodata); build/asm/main_80053AD8.s.o(.data); }
    .main_80053AD8_bss (NOLOAD) : { build/asm/main_80053AD8.s.o(.bss); }
    .main_80056520 0x80056520 : AT(0x00057120) { FILL(0x00000000); build/asm/main_80056520.s.o(.text); build/asm/main_80056520.s.o(.rodata); build/asm/main_80056520.s.o(.data); }
    .main_80056520_bss (NOLOAD) : { build/asm/main_80056520.s.o(.bss); }
    .main_80057970 0x80057970 : AT(0x00058570) { FILL(0x00000000); build/asm/main_80057970.s.o(.text); build/asm/main_80057970.s.o(.rodata); build/asm/main_80057970.s.o(.data); }
    .main_80057970_bss (NOLOAD) : { build/asm/main_80057970.s.o(.bss); }
    .main_800591D0 0x800591D0 : AT(0x00059DD0) { FILL(0x00000000); build/asm/main_800591D0.s.o(.text); build/asm/main_800591D0.s.o(.rodata); build/asm/main_800591D0.s.o(.data); }
    .main_800591D0_bss (NOLOAD) : { build/asm/main_800591D0.s.o(.bss); }
    .main_800595C0 0x800595C0 : AT(0x0005A1C0) { FILL(0x00000000); build/asm/main_800595C0.s.o(.text); build/asm/main_800595C0.s.o(.rodata); build/asm/main_800595C0.s.o(.data); }
    .main_800595C0_bss (NOLOAD) : { build/asm/main_800595C0.s.o(.bss); }
    .main_8005C340 0x8005C340 : AT(0x0005CF40) { FILL(0x00000000); build/asm/main_8005C340.s.o(.text); build/asm/main_8005C340.s.o(.rodata); build/asm/main_8005C340.s.o(.data); }
    .main_8005C340_bss (NOLOAD) : { build/asm/main_8005C340.s.o(.bss); }
    .main_8005CB90 0x8005CB90 : AT(0x0005D790) { FILL(0x00000000); build/asm/main_8005CB90.s.o(.text); build/asm/main_8005CB90.s.o(.rodata); build/asm/main_8005CB90.s.o(.data); }
    .main_8005CB90_bss (NOLOAD) : { build/asm/main_8005CB90.s.o(.bss); }
    .main_8005D844 0x8005D844 : AT(0x0005E444) { FILL(0x00000000); build/asm/main_8005D844.s.o(.text); build/asm/main_8005D844.s.o(.rodata); build/asm/main_8005D844.s.o(.data); }
    .main_8005D844_bss (NOLOAD) : { build/asm/main_8005D844.s.o(.bss); }
    .main_8005DC10 0x8005DC10 : AT(0x0005E810) { FILL(0x00000000); build/asm/main_8005DC10.s.o(.text); build/asm/main_8005DC10.s.o(.rodata); build/asm/main_8005DC10.s.o(.data); }
    .main_8005DC10_bss (NOLOAD) : { build/asm/main_8005DC10.s.o(.bss); }
    .main_80061110 0x80061110 : AT(0x00061D10) { FILL(0x00000000); build/asm/main_80061110.s.o(.text); build/asm/main_80061110.s.o(.rodata); build/asm/main_80061110.s.o(.data); }
    .main_80061110_bss (NOLOAD) : { build/asm/main_80061110.s.o(.bss); }
    .main_800616E0 0x800616E0 : AT(0x000622E0) { FILL(0x00000000); build/asm/main_800616E0.s.o(.text); build/asm/main_800616E0.s.o(.rodata); build/asm/main_800616E0.s.o(.data); }
    .main_800616E0_bss (NOLOAD) : { build/asm/main_800616E0.s.o(.bss); }
    .main_80061830 0x80061830 : AT(0x00062430) { FILL(0x00000000); build/asm/main_80061830.s.o(.text); build/asm/main_80061830.s.o(.rodata); build/asm/main_80061830.s.o(.data); }
    .main_80061830_bss (NOLOAD) : { build/asm/main_80061830.s.o(.bss); }
    .main_800621C4 0x800621C4 : AT(0x00062DC4) { FILL(0x00000000); build/asm/main_800621C4.s.o(.text); build/asm/main_800621C4.s.o(.rodata); build/asm/main_800621C4.s.o(.data); }
    .main_800621C4_bss (NOLOAD) : { build/asm/main_800621C4.s.o(.bss); }
    .main_80062520 0x80062520 : AT(0x00063120) { FILL(0x00000000); build/asm/main_80062520.s.o(.text); build/asm/main_80062520.s.o(.rodata); build/asm/main_80062520.s.o(.data); }
    .main_80062520_bss (NOLOAD) : { build/asm/main_80062520.s.o(.bss); }
    .main_80062DF8 0x80062DF8 : AT(0x000639F8) { FILL(0x00000000); build/asm/main_80062DF8.s.o(.text); build/asm/main_80062DF8.s.o(.rodata); build/asm/main_80062DF8.s.o(.data); }
    .main_80062DF8_bss (NOLOAD) : { build/asm/main_80062DF8.s.o(.bss); }
    .main_80063A30 0x80063A30 : AT(0x00064630) { FILL(0x00000000); build/asm/main_80063A30.s.o(.text); build/asm/main_80063A30.s.o(.rodata); build/asm/main_80063A30.s.o(.data); }
    .main_80063A30_bss (NOLOAD) : { build/asm/main_80063A30.s.o(.bss); }
    .main_80063D50 0x80063D50 : AT(0x00064950) { FILL(0x00000000); build/asm/main_80063D50.s.o(.text); build/asm/main_80063D50.s.o(.rodata); build/asm/main_80063D50.s.o(.data); }
    .main_80063D50_bss (NOLOAD) : { build/asm/main_80063D50.s.o(.bss); }
    .main_80063E10 0x80063E10 : AT(0x00064A10) { FILL(0x00000000); build/asm/main_80063E10.s.o(.text); build/asm/main_80063E10.s.o(.rodata); build/asm/main_80063E10.s.o(.data); }
    .main_80063E10_bss (NOLOAD) : { build/asm/main_80063E10.s.o(.bss); }
    .main_80064840 0x80064840 : AT(0x00065440) { FILL(0x00000000); build/asm/main_80064840.s.o(.text); build/asm/main_80064840.s.o(.rodata); build/asm/main_80064840.s.o(.data); }
    .main_80064840_bss (NOLOAD) : { build/asm/main_80064840.s.o(.bss); }
    .main_8006A490 0x8006A490 : AT(0x0006B090) { FILL(0x00000000); build/asm/main_8006A490.s.o(.text); build/asm/main_8006A490.s.o(.rodata); build/asm/main_8006A490.s.o(.data); }
    .main_8006A490_bss (NOLOAD) : { build/asm/main_8006A490.s.o(.bss); }
    .main_8006B5C0 0x8006B5C0 : AT(0x0006C1C0) { FILL(0x00000000); build/asm/main_8006B5C0.s.o(.text); build/asm/main_8006B5C0.s.o(.rodata); build/asm/main_8006B5C0.s.o(.data); }
    .main_8006B5C0_bss (NOLOAD) : { build/asm/main_8006B5C0.s.o(.bss); }
    .main_8006E2F8 0x8006E2F8 : AT(0x0006EEF8) { FILL(0x00000000); build/asm/main_8006E2F8.s.o(.text); build/asm/main_8006E2F8.s.o(.rodata); build/asm/main_8006E2F8.s.o(.data); }
    .main_8006E2F8_bss (NOLOAD) : { build/asm/main_8006E2F8.s.o(.bss); }
    .main_80072298 0x80072298 : AT(0x00072E98) { build/asm/data/main_80072298.bin.o(.data); }
    .main_80076A14 0x80076A14 : AT(0x00077614) { FILL(0x00000000); build/asm/main_80076A14.s.o(.text); build/asm/main_80076A14.s.o(.rodata); build/asm/main_80076A14.s.o(.data); }
    .main_80076A14_bss (NOLOAD) : { build/asm/main_80076A14.s.o(.bss); }
    .main_80077D4C 0x80077D4C : AT(0x0007894C) { FILL(0x00000000); build/asm/main_80077D4C.s.o(.text); build/asm/main_80077D4C.s.o(.rodata); build/asm/main_80077D4C.s.o(.data); }
    .main_80077D4C_bss (NOLOAD) : { build/asm/main_80077D4C.s.o(.bss); }
    .main_800782E4 0x800782E4 : AT(0x00078EE4) { FILL(0x00000000); build/asm/main_800782E4.s.o(.text); build/asm/main_800782E4.s.o(.rodata); build/asm/main_800782E4.s.o(.data); }
    .main_800782E4_bss (NOLOAD) : { build/asm/main_800782E4.s.o(.bss); }
    .main_800785A4 0x800785A4 : AT(0x000791A4) { FILL(0x00000000); build/asm/main_800785A4.s.o(.text); build/asm/main_800785A4.s.o(.rodata); build/asm/main_800785A4.s.o(.data); }
    .main_800785A4_bss (NOLOAD) : { build/asm/main_800785A4.s.o(.bss); }
    .main_8007AD40 0x8007AD40 : AT(0x0007B940) { FILL(0x00000000); build/asm/main_8007AD40.s.o(.text); build/asm/main_8007AD40.s.o(.rodata); build/asm/main_8007AD40.s.o(.data); }
    .main_8007AD40_bss (NOLOAD) : { build/asm/main_8007AD40.s.o(.bss); }
    .main_8007C3E0 0x8007C3E0 : AT(0x0007CFE0) { build/asm/data/main_8007C3E0.bin.o(.data); }
    .main_8007D030 0x8007D030 : AT(0x0007DC30) { build/asm/data/main_8007D030.bin.o(.data); }
    .main_8007DB00 0x8007DB00 : AT(0x0007E700) { build/asm/data/main_8007DB00.bin.o(.data); }
    .main_8007E0C4 0x8007E0C4 : AT(0x0007ECC4) { FILL(0x00000000); build/asm/main_8007E0C4.s.o(.text); build/asm/main_8007E0C4.s.o(.rodata); build/asm/main_8007E0C4.s.o(.data); }
    .main_8007E0C4_bss (NOLOAD) : { build/asm/main_8007E0C4.s.o(.bss); }
    .main_8007E61C 0x8007E61C : AT(0x0007F21C) { build/asm/data/main_8007E61C.bin.o(.data); }
    .main_8007FDC4 0x8007FDC4 : AT(0x000809C4) { build/asm/data/main_8007FDC4.bin.o(.data); }
    .main_80081AFC 0x80081AFC : AT(0x000826FC) { build/asm/data/main_80081AFC.bin.o(.data); }
    .main_8008260C 0x8008260C : AT(0x0008320C) { FILL(0x00000000); build/asm/main_8008260C.s.o(.text); build/asm/main_8008260C.s.o(.rodata); build/asm/main_8008260C.s.o(.data); }
    .main_8008260C_bss (NOLOAD) : { build/asm/main_8008260C.s.o(.bss); }
    .main_80082644 0x80082644 : AT(0x00083244) { build/asm/data/main_80082644.bin.o(.data); }
    .main_80089EAC 0x80089EAC : AT(0x0008AAAC) { build/asm/data/main_80089EAC.bin.o(.data); }
    .main_8008BDE4 0x8008BDE4 : AT(0x0008C9E4) { build/asm/data/main_8008BDE4.bin.o(.data); }
    .main_800969FC 0x800969FC : AT(0x000975FC) { FILL(0x00000000); build/asm/main_800969FC.s.o(.text); build/asm/main_800969FC.s.o(.rodata); build/asm/main_800969FC.s.o(.data); }
    .main_800969FC_bss (NOLOAD) : { build/asm/main_800969FC.s.o(.bss); }
    .main_80096A28 0x80096A28 : AT(0x00097628) { build/asm/data/main_80096A28.bin.o(.data); }
    .main_800A0A74 0x800A0A74 : AT(0x000A1674) { FILL(0x00000000); build/asm/main_800A0A74.s.o(.text); build/asm/main_800A0A74.s.o(.rodata); build/asm/main_800A0A74.s.o(.data); }
    .main_800A0A74_bss (NOLOAD) : { build/asm/main_800A0A74.s.o(.bss); }
    .main_800A0A8C 0x800A0A8C : AT(0x000A168C) { build/asm/data/main_800A0A8C.bin.o(.data); }
    .main_800ACED4 0x800ACED4 : AT(0x000ADAD4) { build/asm/data/main_800ACED4.bin.o(.data); }
    .main_800AEF38 0x800AEF38 : AT(0x000AFB38) { build/asm/data/main_800AEF38.bin.o(.data); }
    .main_800AFD08 0x800AFD08 : AT(0x000B0908) { FILL(0x00000000); build/asm/main_800AFD08.s.o(.text); build/asm/main_800AFD08.s.o(.rodata); build/asm/main_800AFD08.s.o(.data); }
    .main_800AFD08_bss (NOLOAD) : { build/asm/main_800AFD08.s.o(.bss); }
    .main_800AFE60 0x800AFE60 : AT(0x000B0A60) { build/asm/data/main_800AFE60.bin.o(.data); }
    .main_800B012C 0x800B012C : AT(0x000B0D2C) { build/asm/data/main_800B012C.bin.o(.data); }
    .main_800B09B4 0x800B09B4 : AT(0x000B15B4) { build/asm/data/main_800B09B4.bin.o(.data); }
    .main_800B1D38 0x800B1D38 : AT(0x000B2938) { build/asm/data/main_800B1D38.bin.o(.data); }
    .main_800B2A08 0x800B2A08 : AT(0x000B3608) { build/asm/data/main_800B2A08.bin.o(.data); }
    .main_800B3E70 0x800B3E70 : AT(0x000B4A70) { build/asm/data/main_800B3E70.bin.o(.data); }
    .main_800B419C 0x800B419C : AT(0x000B4D9C) { build/asm/data/main_800B419C.bin.o(.data); }
    .main_800B4824 0x800B4824 : AT(0x000B5424) { build/asm/data/main_800B4824.bin.o(.data); }
    .main_800B61EC 0x800B61EC : AT(0x000B6DEC) { build/asm/data/main_800B61EC.bin.o(.data); }
    .main_800B8CF0 0x800B8CF0 : AT(0x000B98F0) { build/asm/data/main_800B8CF0.bin.o(.data); }
    .main_800BA54C 0x800BA54C : AT(0x000BB14C) { build/asm/data/main_800BA54C.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
