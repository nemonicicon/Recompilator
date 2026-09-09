SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80001854 0x80001854 : AT(0x00002454) { FILL(0x00000000); build/asm/main_80001854.s.o(.text); build/asm/main_80001854.s.o(.rodata); build/asm/main_80001854.s.o(.data); }
    .main_80001854_bss (NOLOAD) : { build/asm/main_80001854.s.o(.bss); }
    .main_80001C20 0x80001C20 : AT(0x00002820) { FILL(0x00000000); build/asm/main_80001C20.s.o(.text); build/asm/main_80001C20.s.o(.rodata); build/asm/main_80001C20.s.o(.data); }
    .main_80001C20_bss (NOLOAD) : { build/asm/main_80001C20.s.o(.bss); }
    .main_80004780 0x80004780 : AT(0x00005380) { build/asm/data/main_80004780.bin.o(.data); }
    .main_800048B0 0x800048B0 : AT(0x000054B0) { build/asm/data/main_800048B0.bin.o(.data); }
    .main_80005488 0x80005488 : AT(0x00006088) { build/asm/data/main_80005488.bin.o(.data); }
    .main_800056E0 0x800056E0 : AT(0x000062E0) { build/asm/data/main_800056E0.bin.o(.data); }
    .main_80007BFC 0x80007BFC : AT(0x000087FC) { build/asm/data/main_80007BFC.bin.o(.data); }
    .main_80008DD0 0x80008DD0 : AT(0x000099D0) { build/asm/data/main_80008DD0.bin.o(.data); }
    .main_80008FC0 0x80008FC0 : AT(0x00009BC0) { build/asm/data/main_80008FC0.bin.o(.data); }
    .main_80009460 0x80009460 : AT(0x0000A060) { build/asm/data/main_80009460.bin.o(.data); }
    .main_80009478 0x80009478 : AT(0x0000A078) { build/asm/data/main_80009478.bin.o(.data); }
    .main_80009F20 0x80009F20 : AT(0x0000AB20) { build/asm/data/main_80009F20.bin.o(.data); }
    .main_80009F50 0x80009F50 : AT(0x0000AB50) { build/asm/data/main_80009F50.bin.o(.data); }
    .main_8000A07C 0x8000A07C : AT(0x0000AC7C) { build/asm/data/main_8000A07C.bin.o(.data); }
    .main_8000A088 0x8000A088 : AT(0x0000AC88) { build/asm/data/main_8000A088.bin.o(.data); }
    .main_8000A110 0x8000A110 : AT(0x0000AD10) { build/asm/data/main_8000A110.bin.o(.data); }
    .main_8000A114 0x8000A114 : AT(0x0000AD14) { build/asm/data/main_8000A114.bin.o(.data); }
    .main_8000F38C 0x8000F38C : AT(0x0000FF8C) { build/asm/data/main_8000F38C.bin.o(.data); }
    .main_8000F390 0x8000F390 : AT(0x0000FF90) { build/asm/data/main_8000F390.bin.o(.data); }
    .main_8001E044 0x8001E044 : AT(0x0001EC44) { build/asm/data/main_8001E044.bin.o(.data); }
    .main_8001E05C 0x8001E05C : AT(0x0001EC5C) { build/asm/data/main_8001E05C.bin.o(.data); }
    .main_8001FAB4 0x8001FAB4 : AT(0x000206B4) { build/asm/data/main_8001FAB4.bin.o(.data); }
    .main_8001FAF4 0x8001FAF4 : AT(0x000206F4) { build/asm/data/main_8001FAF4.bin.o(.data); }
    .main_80023E84 0x80023E84 : AT(0x00024A84) { build/asm/data/main_80023E84.bin.o(.data); }
    .main_80023E98 0x80023E98 : AT(0x00024A98) { build/asm/data/main_80023E98.bin.o(.data); }
    .main_800249D4 0x800249D4 : AT(0x000255D4) { build/asm/data/main_800249D4.bin.o(.data); }
    .main_80024A00 0x80024A00 : AT(0x00025600) { build/asm/data/main_80024A00.bin.o(.data); }
    .main_80039624 0x80039624 : AT(0x0003A224) { build/asm/data/main_80039624.bin.o(.data); }
    .main_800396A4 0x800396A4 : AT(0x0003A2A4) { build/asm/data/main_800396A4.bin.o(.data); }
    .main_8003D884 0x8003D884 : AT(0x0003E484) { build/asm/data/main_8003D884.bin.o(.data); }
    .main_8003D8AC 0x8003D8AC : AT(0x0003E4AC) { build/asm/data/main_8003D8AC.bin.o(.data); }
    .main_8005FDCC 0x8005FDCC : AT(0x000609CC) { build/asm/data/main_8005FDCC.bin.o(.data); }
    .main_8005FDD0 0x8005FDD0 : AT(0x000609D0) { build/asm/data/main_8005FDD0.bin.o(.data); }
    .main_80065AA4 0x80065AA4 : AT(0x000666A4) { build/asm/data/main_80065AA4.bin.o(.data); }
    .main_80065AD8 0x80065AD8 : AT(0x000666D8) { build/asm/data/main_80065AD8.bin.o(.data); }
    .main_80071550 0x80071550 : AT(0x00072150) { build/asm/data/main_80071550.bin.o(.data); }
    .main_80071560 0x80071560 : AT(0x00072160) { build/asm/data/main_80071560.bin.o(.data); }
    .main_8007810C 0x8007810C : AT(0x00078D0C) { build/asm/data/main_8007810C.bin.o(.data); }
    .main_80078134 0x80078134 : AT(0x00078D34) { build/asm/data/main_80078134.bin.o(.data); }
    .main_80087DBC 0x80087DBC : AT(0x000889BC) { build/asm/data/main_80087DBC.bin.o(.data); }
    .main_80087DF4 0x80087DF4 : AT(0x000889F4) { build/asm/data/main_80087DF4.bin.o(.data); }
    .main_8008D5FC 0x8008D5FC : AT(0x0008E1FC) { build/asm/data/main_8008D5FC.bin.o(.data); }
    .main_8008D600 0x8008D600 : AT(0x0008E200) { build/asm/data/main_8008D600.bin.o(.data); }
    .main_8008DBD8 0x8008DBD8 : AT(0x0008E7D8) { build/asm/data/main_8008DBD8.bin.o(.data); }
    .main_8008DC10 0x8008DC10 : AT(0x0008E810) { build/asm/data/main_8008DC10.bin.o(.data); }
    .main_80091038 0x80091038 : AT(0x00091C38) { build/asm/data/main_80091038.bin.o(.data); }
    .main_8009109C 0x8009109C : AT(0x00091C9C) { build/asm/data/main_8009109C.bin.o(.data); }
    .main_80092CDC 0x80092CDC : AT(0x000938DC) { build/asm/data/main_80092CDC.bin.o(.data); }
    .main_80092D18 0x80092D18 : AT(0x00093918) { build/asm/data/main_80092D18.bin.o(.data); }
    .main_80093F34 0x80093F34 : AT(0x00094B34) { build/asm/data/main_80093F34.bin.o(.data); }
    .main_80093F38 0x80093F38 : AT(0x00094B38) { build/asm/data/main_80093F38.bin.o(.data); }
    .main_800978C0 0x800978C0 : AT(0x000984C0) { build/asm/data/main_800978C0.bin.o(.data); }
    .main_800978D4 0x800978D4 : AT(0x000984D4) { build/asm/data/main_800978D4.bin.o(.data); }
    .main_8009C224 0x8009C224 : AT(0x0009CE24) { build/asm/data/main_8009C224.bin.o(.data); }
    .main_8009C22C 0x8009C22C : AT(0x0009CE2C) { build/asm/data/main_8009C22C.bin.o(.data); }
    .main_8009D9F4 0x8009D9F4 : AT(0x0009E5F4) { build/asm/data/main_8009D9F4.bin.o(.data); }
    .main_8009D9FC 0x8009D9FC : AT(0x0009E5FC) { build/asm/data/main_8009D9FC.bin.o(.data); }
    .main_8009FEF4 0x8009FEF4 : AT(0x000A0AF4) { build/asm/data/main_8009FEF4.bin.o(.data); }
    .main_8009FF08 0x8009FF08 : AT(0x000A0B08) { build/asm/data/main_8009FF08.bin.o(.data); }
    .main_800AB758 0x800AB758 : AT(0x000AC358) { build/asm/data/main_800AB758.bin.o(.data); }
    .main_800AB788 0x800AB788 : AT(0x000AC388) { build/asm/data/main_800AB788.bin.o(.data); }
    .main_800AF8A8 0x800AF8A8 : AT(0x000B04A8) { build/asm/data/main_800AF8A8.bin.o(.data); }
    .main_800AF8B0 0x800AF8B0 : AT(0x000B04B0) { build/asm/data/main_800AF8B0.bin.o(.data); }
    .main_800B93D0 0x800B93D0 : AT(0x000B9FD0) { build/asm/data/main_800B93D0.bin.o(.data); }
    .main_800B93EC 0x800B93EC : AT(0x000B9FEC) { build/asm/data/main_800B93EC.bin.o(.data); }
    .main_800B9924 0x800B9924 : AT(0x000BA524) { build/asm/data/main_800B9924.bin.o(.data); }
    .main_800B9928 0x800B9928 : AT(0x000BA528) { build/asm/data/main_800B9928.bin.o(.data); }
    .main_800BC0A0 0x800BC0A0 : AT(0x000BCCA0) { build/asm/data/main_800BC0A0.bin.o(.data); }
    .main_800BC0B0 0x800BC0B0 : AT(0x000BCCB0) { build/asm/data/main_800BC0B0.bin.o(.data); }
    .main_800BD4C0 0x800BD4C0 : AT(0x000BE0C0) { build/asm/data/main_800BD4C0.bin.o(.data); }
    .main_800BD510 0x800BD510 : AT(0x000BE110) { build/asm/data/main_800BD510.bin.o(.data); }
    .main_800BEE74 0x800BEE74 : AT(0x000BFA74) { build/asm/data/main_800BEE74.bin.o(.data); }
    .main_800BEE8C 0x800BEE8C : AT(0x000BFA8C) { build/asm/data/main_800BEE8C.bin.o(.data); }
    .main_800BFD2C 0x800BFD2C : AT(0x000C092C) { build/asm/data/main_800BFD2C.bin.o(.data); }
    .main_800BFDE0 0x800BFDE0 : AT(0x000C09E0) { build/asm/data/main_800BFDE0.bin.o(.data); }
    .main_800C8B70 0x800C8B70 : AT(0x000C9770) { build/asm/data/main_800C8B70.bin.o(.data); }
    .main_800C8B8C 0x800C8B8C : AT(0x000C978C) { build/asm/data/main_800C8B8C.bin.o(.data); }
    .main_800C964C 0x800C964C : AT(0x000CA24C) { build/asm/data/main_800C964C.bin.o(.data); }
    .main_800C9668 0x800C9668 : AT(0x000CA268) { build/asm/data/main_800C9668.bin.o(.data); }
    .main_800CE084 0x800CE084 : AT(0x000CEC84) { build/asm/data/main_800CE084.bin.o(.data); }
    .main_800CE0A8 0x800CE0A8 : AT(0x000CECA8) { build/asm/data/main_800CE0A8.bin.o(.data); }
    .main_800DCCFC 0x800DCCFC : AT(0x000DD8FC) { build/asm/data/main_800DCCFC.bin.o(.data); }
    .main_800DCD40 0x800DCD40 : AT(0x000DD940) { build/asm/data/main_800DCD40.bin.o(.data); }
    .main_800E1AE0 0x800E1AE0 : AT(0x000E26E0) { build/asm/data/main_800E1AE0.bin.o(.data); }
    .main_800E1AF8 0x800E1AF8 : AT(0x000E26F8) { build/asm/data/main_800E1AF8.bin.o(.data); }
    .main_800E2488 0x800E2488 : AT(0x000E3088) { build/asm/data/main_800E2488.bin.o(.data); }
    .main_800E24B4 0x800E24B4 : AT(0x000E30B4) { build/asm/data/main_800E24B4.bin.o(.data); }
    .main_800EA9FC 0x800EA9FC : AT(0x000EB5FC) { build/asm/data/main_800EA9FC.bin.o(.data); }
    .main_800EAA24 0x800EAA24 : AT(0x000EB624) { build/asm/data/main_800EAA24.bin.o(.data); }
    .main_800F83C4 0x800F83C4 : AT(0x000F8FC4) { build/asm/data/main_800F83C4.bin.o(.data); }
    .main_800F8450 0x800F8450 : AT(0x000F9050) { build/asm/data/main_800F8450.bin.o(.data); }
    .main_800FB994 0x800FB994 : AT(0x000FC594) { build/asm/data/main_800FB994.bin.o(.data); }
    .main_800FB9FC 0x800FB9FC : AT(0x000FC5FC) { build/asm/data/main_800FB9FC.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
