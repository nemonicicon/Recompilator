SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800039F0 0x800039F0 : AT(0x000045F0) { FILL(0x00000000); build/asm/main_800039F0.s.o(.text); build/asm/main_800039F0.s.o(.rodata); build/asm/main_800039F0.s.o(.data); }
    .main_800039F0_bss (NOLOAD) : { build/asm/main_800039F0.s.o(.bss); }
    .main_80004068 0x80004068 : AT(0x00004C68) { FILL(0x00000000); build/asm/main_80004068.s.o(.text); build/asm/main_80004068.s.o(.rodata); build/asm/main_80004068.s.o(.data); }
    .main_80004068_bss (NOLOAD) : { build/asm/main_80004068.s.o(.bss); }
    .main_80004458 0x80004458 : AT(0x00005058) { FILL(0x00000000); build/asm/main_80004458.s.o(.text); build/asm/main_80004458.s.o(.rodata); build/asm/main_80004458.s.o(.data); }
    .main_80004458_bss (NOLOAD) : { build/asm/main_80004458.s.o(.bss); }
    .main_80004BC0 0x80004BC0 : AT(0x000057C0) { FILL(0x00000000); build/asm/main_80004BC0.s.o(.text); build/asm/main_80004BC0.s.o(.rodata); build/asm/main_80004BC0.s.o(.data); }
    .main_80004BC0_bss (NOLOAD) : { build/asm/main_80004BC0.s.o(.bss); }
    .main_8000512C 0x8000512C : AT(0x00005D2C) { FILL(0x00000000); build/asm/main_8000512C.s.o(.text); build/asm/main_8000512C.s.o(.rodata); build/asm/main_8000512C.s.o(.data); }
    .main_8000512C_bss (NOLOAD) : { build/asm/main_8000512C.s.o(.bss); }
    .main_80008240 0x80008240 : AT(0x00008E40) { build/asm/data/main_80008240.bin.o(.data); }
    .main_800082B8 0x800082B8 : AT(0x00008EB8) { FILL(0x00000000); build/asm/main_800082B8.s.o(.text); build/asm/main_800082B8.s.o(.rodata); build/asm/main_800082B8.s.o(.data); }
    .main_800082B8_bss (NOLOAD) : { build/asm/main_800082B8.s.o(.bss); }
    .main_8000AA1C 0x8000AA1C : AT(0x0000B61C) { FILL(0x00000000); build/asm/main_8000AA1C.s.o(.text); build/asm/main_8000AA1C.s.o(.rodata); build/asm/main_8000AA1C.s.o(.data); }
    .main_8000AA1C_bss (NOLOAD) : { build/asm/main_8000AA1C.s.o(.bss); }
    .main_8000AD88 0x8000AD88 : AT(0x0000B988) { FILL(0x00000000); build/asm/main_8000AD88.s.o(.text); build/asm/main_8000AD88.s.o(.rodata); build/asm/main_8000AD88.s.o(.data); }
    .main_8000AD88_bss (NOLOAD) : { build/asm/main_8000AD88.s.o(.bss); }
    .main_8000D768 0x8000D768 : AT(0x0000E368) { build/asm/data/main_8000D768.bin.o(.data); }
    .main_8000D790 0x8000D790 : AT(0x0000E390) { FILL(0x00000000); build/asm/main_8000D790.s.o(.text); build/asm/main_8000D790.s.o(.rodata); build/asm/main_8000D790.s.o(.data); }
    .main_8000D790_bss (NOLOAD) : { build/asm/main_8000D790.s.o(.bss); }
    .main_8000F150 0x8000F150 : AT(0x0000FD50) { FILL(0x00000000); build/asm/main_8000F150.s.o(.text); build/asm/main_8000F150.s.o(.rodata); build/asm/main_8000F150.s.o(.data); }
    .main_8000F150_bss (NOLOAD) : { build/asm/main_8000F150.s.o(.bss); }
    .main_8000F9D4 0x8000F9D4 : AT(0x000105D4) { FILL(0x00000000); build/asm/main_8000F9D4.s.o(.text); build/asm/main_8000F9D4.s.o(.rodata); build/asm/main_8000F9D4.s.o(.data); }
    .main_8000F9D4_bss (NOLOAD) : { build/asm/main_8000F9D4.s.o(.bss); }
    .main_8001151C 0x8001151C : AT(0x0001211C) { FILL(0x00000000); build/asm/main_8001151C.s.o(.text); build/asm/main_8001151C.s.o(.rodata); build/asm/main_8001151C.s.o(.data); }
    .main_8001151C_bss (NOLOAD) : { build/asm/main_8001151C.s.o(.bss); }
    .main_80012778 0x80012778 : AT(0x00013378) { FILL(0x00000000); build/asm/main_80012778.s.o(.text); build/asm/main_80012778.s.o(.rodata); build/asm/main_80012778.s.o(.data); }
    .main_80012778_bss (NOLOAD) : { build/asm/main_80012778.s.o(.bss); }
    .main_800162B0 0x800162B0 : AT(0x00016EB0) { FILL(0x00000000); build/asm/main_800162B0.s.o(.text); build/asm/main_800162B0.s.o(.rodata); build/asm/main_800162B0.s.o(.data); }
    .main_800162B0_bss (NOLOAD) : { build/asm/main_800162B0.s.o(.bss); }
    .main_80016530 0x80016530 : AT(0x00017130) { FILL(0x00000000); build/asm/main_80016530.s.o(.text); build/asm/main_80016530.s.o(.rodata); build/asm/main_80016530.s.o(.data); }
    .main_80016530_bss (NOLOAD) : { build/asm/main_80016530.s.o(.bss); }
    .main_800166F0 0x800166F0 : AT(0x000172F0) { build/asm/data/main_800166F0.bin.o(.data); }
    .main_80016830 0x80016830 : AT(0x00017430) { FILL(0x00000000); build/asm/main_80016830.s.o(.text); build/asm/main_80016830.s.o(.rodata); build/asm/main_80016830.s.o(.data); }
    .main_80016830_bss (NOLOAD) : { build/asm/main_80016830.s.o(.bss); }
    .main_800196E8 0x800196E8 : AT(0x0001A2E8) { build/asm/data/main_800196E8.bin.o(.data); }
    .main_80019740 0x80019740 : AT(0x0001A340) { FILL(0x00000000); build/asm/main_80019740.s.o(.text); build/asm/main_80019740.s.o(.rodata); build/asm/main_80019740.s.o(.data); }
    .main_80019740_bss (NOLOAD) : { build/asm/main_80019740.s.o(.bss); }
    .main_8001DEE8 0x8001DEE8 : AT(0x0001EAE8) { FILL(0x00000000); build/asm/main_8001DEE8.s.o(.text); build/asm/main_8001DEE8.s.o(.rodata); build/asm/main_8001DEE8.s.o(.data); }
    .main_8001DEE8_bss (NOLOAD) : { build/asm/main_8001DEE8.s.o(.bss); }
    .main_8001DEF8 0x8001DEF8 : AT(0x0001EAF8) { build/asm/data/main_8001DEF8.bin.o(.data); }
    .main_8001E0B0 0x8001E0B0 : AT(0x0001ECB0) { FILL(0x00000000); build/asm/main_8001E0B0.s.o(.text); build/asm/main_8001E0B0.s.o(.rodata); build/asm/main_8001E0B0.s.o(.data); }
    .main_8001E0B0_bss (NOLOAD) : { build/asm/main_8001E0B0.s.o(.bss); }
    .main_8001E630 0x8001E630 : AT(0x0001F230) { build/asm/data/main_8001E630.bin.o(.data); }
    .main_8001E650 0x8001E650 : AT(0x0001F250) { FILL(0x00000000); build/asm/main_8001E650.s.o(.text); build/asm/main_8001E650.s.o(.rodata); build/asm/main_8001E650.s.o(.data); }
    .main_8001E650_bss (NOLOAD) : { build/asm/main_8001E650.s.o(.bss); }
    .main_80020444 0x80020444 : AT(0x00021044) { build/asm/data/main_80020444.bin.o(.data); }
    .main_80020680 0x80020680 : AT(0x00021280) { FILL(0x00000000); build/asm/main_80020680.s.o(.text); build/asm/main_80020680.s.o(.rodata); build/asm/main_80020680.s.o(.data); }
    .main_80020680_bss (NOLOAD) : { build/asm/main_80020680.s.o(.bss); }
    .main_80020E8C 0x80020E8C : AT(0x00021A8C) { FILL(0x00000000); build/asm/main_80020E8C.s.o(.text); build/asm/main_80020E8C.s.o(.rodata); build/asm/main_80020E8C.s.o(.data); }
    .main_80020E8C_bss (NOLOAD) : { build/asm/main_80020E8C.s.o(.bss); }
    .main_80022844 0x80022844 : AT(0x00023444) { build/asm/data/main_80022844.bin.o(.data); }
    .main_80022A50 0x80022A50 : AT(0x00023650) { FILL(0x00000000); build/asm/main_80022A50.s.o(.text); build/asm/main_80022A50.s.o(.rodata); build/asm/main_80022A50.s.o(.data); }
    .main_80022A50_bss (NOLOAD) : { build/asm/main_80022A50.s.o(.bss); }
    .main_80023544 0x80023544 : AT(0x00024144) { build/asm/data/main_80023544.bin.o(.data); }
    .main_800235F0 0x800235F0 : AT(0x000241F0) { FILL(0x00000000); build/asm/main_800235F0.s.o(.text); build/asm/main_800235F0.s.o(.rodata); build/asm/main_800235F0.s.o(.data); }
    .main_800235F0_bss (NOLOAD) : { build/asm/main_800235F0.s.o(.bss); }
    .main_80025730 0x80025730 : AT(0x00026330) { build/asm/data/main_80025730.bin.o(.data); }
    .main_80025C20 0x80025C20 : AT(0x00026820) { FILL(0x00000000); build/asm/main_80025C20.s.o(.text); build/asm/main_80025C20.s.o(.rodata); build/asm/main_80025C20.s.o(.data); }
    .main_80025C20_bss (NOLOAD) : { build/asm/main_80025C20.s.o(.bss); }
    .main_80026294 0x80026294 : AT(0x00026E94) { build/asm/data/main_80026294.bin.o(.data); }
    .main_80026310 0x80026310 : AT(0x00026F10) { FILL(0x00000000); build/asm/main_80026310.s.o(.text); build/asm/main_80026310.s.o(.rodata); build/asm/main_80026310.s.o(.data); }
    .main_80026310_bss (NOLOAD) : { build/asm/main_80026310.s.o(.bss); }
    .main_80027880 0x80027880 : AT(0x00028480) { FILL(0x00000000); build/asm/main_80027880.s.o(.text); build/asm/main_80027880.s.o(.rodata); build/asm/main_80027880.s.o(.data); }
    .main_80027880_bss (NOLOAD) : { build/asm/main_80027880.s.o(.bss); }
    .main_80027978 0x80027978 : AT(0x00028578) { FILL(0x00000000); build/asm/main_80027978.s.o(.text); build/asm/main_80027978.s.o(.rodata); build/asm/main_80027978.s.o(.data); }
    .main_80027978_bss (NOLOAD) : { build/asm/main_80027978.s.o(.bss); }
    .main_80027F48 0x80027F48 : AT(0x00028B48) { FILL(0x00000000); build/asm/main_80027F48.s.o(.text); build/asm/main_80027F48.s.o(.rodata); build/asm/main_80027F48.s.o(.data); }
    .main_80027F48_bss (NOLOAD) : { build/asm/main_80027F48.s.o(.bss); }
    .main_80028E9C 0x80028E9C : AT(0x00029A9C) { build/asm/data/main_80028E9C.bin.o(.data); }
    .main_80028F80 0x80028F80 : AT(0x00029B80) { FILL(0x00000000); build/asm/main_80028F80.s.o(.text); build/asm/main_80028F80.s.o(.rodata); build/asm/main_80028F80.s.o(.data); }
    .main_80028F80_bss (NOLOAD) : { build/asm/main_80028F80.s.o(.bss); }
    .main_8002D404 0x8002D404 : AT(0x0002E004) { FILL(0x00000000); build/asm/main_8002D404.s.o(.text); build/asm/main_8002D404.s.o(.rodata); build/asm/main_8002D404.s.o(.data); }
    .main_8002D404_bss (NOLOAD) : { build/asm/main_8002D404.s.o(.bss); }
    .main_8002DA20 0x8002DA20 : AT(0x0002E620) { FILL(0x00000000); build/asm/main_8002DA20.s.o(.text); build/asm/main_8002DA20.s.o(.rodata); build/asm/main_8002DA20.s.o(.data); }
    .main_8002DA20_bss (NOLOAD) : { build/asm/main_8002DA20.s.o(.bss); }
    .main_800301C8 0x800301C8 : AT(0x00030DC8) { build/asm/data/main_800301C8.bin.o(.data); }
    .main_80030200 0x80030200 : AT(0x00030E00) { FILL(0x00000000); build/asm/main_80030200.s.o(.text); build/asm/main_80030200.s.o(.rodata); build/asm/main_80030200.s.o(.data); }
    .main_80030200_bss (NOLOAD) : { build/asm/main_80030200.s.o(.bss); }
    .main_800309C4 0x800309C4 : AT(0x000315C4) { FILL(0x00000000); build/asm/main_800309C4.s.o(.text); build/asm/main_800309C4.s.o(.rodata); build/asm/main_800309C4.s.o(.data); }
    .main_800309C4_bss (NOLOAD) : { build/asm/main_800309C4.s.o(.bss); }
    .main_80030F14 0x80030F14 : AT(0x00031B14) { FILL(0x00000000); build/asm/main_80030F14.s.o(.text); build/asm/main_80030F14.s.o(.rodata); build/asm/main_80030F14.s.o(.data); }
    .main_80030F14_bss (NOLOAD) : { build/asm/main_80030F14.s.o(.bss); }
    .main_8003131C 0x8003131C : AT(0x00031F1C) { FILL(0x00000000); build/asm/main_8003131C.s.o(.text); build/asm/main_8003131C.s.o(.rodata); build/asm/main_8003131C.s.o(.data); }
    .main_8003131C_bss (NOLOAD) : { build/asm/main_8003131C.s.o(.bss); }
    .main_80033D00 0x80033D00 : AT(0x00034900) { FILL(0x00000000); build/asm/main_80033D00.s.o(.text); build/asm/main_80033D00.s.o(.rodata); build/asm/main_80033D00.s.o(.data); }
    .main_80033D00_bss (NOLOAD) : { build/asm/main_80033D00.s.o(.bss); }
    .main_80033E1C 0x80033E1C : AT(0x00034A1C) { FILL(0x00000000); build/asm/main_80033E1C.s.o(.text); build/asm/main_80033E1C.s.o(.rodata); build/asm/main_80033E1C.s.o(.data); }
    .main_80033E1C_bss (NOLOAD) : { build/asm/main_80033E1C.s.o(.bss); }
    .main_80034300 0x80034300 : AT(0x00034F00) { build/asm/data/main_80034300.bin.o(.data); }
    .main_80034350 0x80034350 : AT(0x00034F50) { FILL(0x00000000); build/asm/main_80034350.s.o(.text); build/asm/main_80034350.s.o(.rodata); build/asm/main_80034350.s.o(.data); }
    .main_80034350_bss (NOLOAD) : { build/asm/main_80034350.s.o(.bss); }
    .main_80036138 0x80036138 : AT(0x00036D38) { build/asm/data/main_80036138.bin.o(.data); }
    .main_80037C38 0x80037C38 : AT(0x00038838) { build/asm/data/main_80037C38.bin.o(.data); }
    .main_800387CC 0x800387CC : AT(0x000393CC) { build/asm/data/main_800387CC.bin.o(.data); }
    .main_80038950 0x80038950 : AT(0x00039550) { FILL(0x00000000); build/asm/main_80038950.s.o(.text); build/asm/main_80038950.s.o(.rodata); build/asm/main_80038950.s.o(.data); }
    .main_80038950_bss (NOLOAD) : { build/asm/main_80038950.s.o(.bss); }
    .main_8003CACC 0x8003CACC : AT(0x0003D6CC) { FILL(0x00000000); build/asm/main_8003CACC.s.o(.text); build/asm/main_8003CACC.s.o(.rodata); build/asm/main_8003CACC.s.o(.data); }
    .main_8003CACC_bss (NOLOAD) : { build/asm/main_8003CACC.s.o(.bss); }
    .main_800417F0 0x800417F0 : AT(0x000423F0) { FILL(0x00000000); build/asm/main_800417F0.s.o(.text); build/asm/main_800417F0.s.o(.rodata); build/asm/main_800417F0.s.o(.data); }
    .main_800417F0_bss (NOLOAD) : { build/asm/main_800417F0.s.o(.bss); }
    .main_8004290C 0x8004290C : AT(0x0004350C) { FILL(0x00000000); build/asm/main_8004290C.s.o(.text); build/asm/main_8004290C.s.o(.rodata); build/asm/main_8004290C.s.o(.data); }
    .main_8004290C_bss (NOLOAD) : { build/asm/main_8004290C.s.o(.bss); }
    .main_80042F30 0x80042F30 : AT(0x00043B30) { FILL(0x00000000); build/asm/main_80042F30.s.o(.text); build/asm/main_80042F30.s.o(.rodata); build/asm/main_80042F30.s.o(.data); }
    .main_80042F30_bss (NOLOAD) : { build/asm/main_80042F30.s.o(.bss); }
    .main_80043D8C 0x80043D8C : AT(0x0004498C) { FILL(0x00000000); build/asm/main_80043D8C.s.o(.text); build/asm/main_80043D8C.s.o(.rodata); build/asm/main_80043D8C.s.o(.data); }
    .main_80043D8C_bss (NOLOAD) : { build/asm/main_80043D8C.s.o(.bss); }
    .main_80045888 0x80045888 : AT(0x00046488) { build/asm/data/main_80045888.bin.o(.data); }
    .main_80045890 0x80045890 : AT(0x00046490) { FILL(0x00000000); build/asm/main_80045890.s.o(.text); build/asm/main_80045890.s.o(.rodata); build/asm/main_80045890.s.o(.data); }
    .main_80045890_bss (NOLOAD) : { build/asm/main_80045890.s.o(.bss); }
    .main_80048328 0x80048328 : AT(0x00048F28) { FILL(0x00000000); build/asm/main_80048328.s.o(.text); build/asm/main_80048328.s.o(.rodata); build/asm/main_80048328.s.o(.data); }
    .main_80048328_bss (NOLOAD) : { build/asm/main_80048328.s.o(.bss); }
    .main_80048900 0x80048900 : AT(0x00049500) { FILL(0x00000000); build/asm/main_80048900.s.o(.text); build/asm/main_80048900.s.o(.rodata); build/asm/main_80048900.s.o(.data); }
    .main_80048900_bss (NOLOAD) : { build/asm/main_80048900.s.o(.bss); }
    .main_8004A700 0x8004A700 : AT(0x0004B300) { FILL(0x00000000); build/asm/main_8004A700.s.o(.text); build/asm/main_8004A700.s.o(.rodata); build/asm/main_8004A700.s.o(.data); }
    .main_8004A700_bss (NOLOAD) : { build/asm/main_8004A700.s.o(.bss); }
    .main_8004AB0C 0x8004AB0C : AT(0x0004B70C) { FILL(0x00000000); build/asm/main_8004AB0C.s.o(.text); build/asm/main_8004AB0C.s.o(.rodata); build/asm/main_8004AB0C.s.o(.data); }
    .main_8004AB0C_bss (NOLOAD) : { build/asm/main_8004AB0C.s.o(.bss); }
    .main_8004B08C 0x8004B08C : AT(0x0004BC8C) { FILL(0x00000000); build/asm/main_8004B08C.s.o(.text); build/asm/main_8004B08C.s.o(.rodata); build/asm/main_8004B08C.s.o(.data); }
    .main_8004B08C_bss (NOLOAD) : { build/asm/main_8004B08C.s.o(.bss); }
    .main_8004B9E0 0x8004B9E0 : AT(0x0004C5E0) { FILL(0x00000000); build/asm/main_8004B9E0.s.o(.text); build/asm/main_8004B9E0.s.o(.rodata); build/asm/main_8004B9E0.s.o(.data); }
    .main_8004B9E0_bss (NOLOAD) : { build/asm/main_8004B9E0.s.o(.bss); }
    .main_8004BBFC 0x8004BBFC : AT(0x0004C7FC) { FILL(0x00000000); build/asm/main_8004BBFC.s.o(.text); build/asm/main_8004BBFC.s.o(.rodata); build/asm/main_8004BBFC.s.o(.data); }
    .main_8004BBFC_bss (NOLOAD) : { build/asm/main_8004BBFC.s.o(.bss); }
    .main_8004C070 0x8004C070 : AT(0x0004CC70) { FILL(0x00000000); build/asm/main_8004C070.s.o(.text); build/asm/main_8004C070.s.o(.rodata); build/asm/main_8004C070.s.o(.data); }
    .main_8004C070_bss (NOLOAD) : { build/asm/main_8004C070.s.o(.bss); }
    .main_8004C274 0x8004C274 : AT(0x0004CE74) { FILL(0x00000000); build/asm/main_8004C274.s.o(.text); build/asm/main_8004C274.s.o(.rodata); build/asm/main_8004C274.s.o(.data); }
    .main_8004C274_bss (NOLOAD) : { build/asm/main_8004C274.s.o(.bss); }
    .main_8004C9A0 0x8004C9A0 : AT(0x0004D5A0) { FILL(0x00000000); build/asm/main_8004C9A0.s.o(.text); build/asm/main_8004C9A0.s.o(.rodata); build/asm/main_8004C9A0.s.o(.data); }
    .main_8004C9A0_bss (NOLOAD) : { build/asm/main_8004C9A0.s.o(.bss); }
    .main_8004FAF0 0x8004FAF0 : AT(0x000506F0) { FILL(0x00000000); build/asm/main_8004FAF0.s.o(.text); build/asm/main_8004FAF0.s.o(.rodata); build/asm/main_8004FAF0.s.o(.data); }
    .main_8004FAF0_bss (NOLOAD) : { build/asm/main_8004FAF0.s.o(.bss); }
    .main_80050740 0x80050740 : AT(0x00051340) { FILL(0x00000000); build/asm/main_80050740.s.o(.text); build/asm/main_80050740.s.o(.rodata); build/asm/main_80050740.s.o(.data); }
    .main_80050740_bss (NOLOAD) : { build/asm/main_80050740.s.o(.bss); }
    .main_8005145C 0x8005145C : AT(0x0005205C) { FILL(0x00000000); build/asm/main_8005145C.s.o(.text); build/asm/main_8005145C.s.o(.rodata); build/asm/main_8005145C.s.o(.data); }
    .main_8005145C_bss (NOLOAD) : { build/asm/main_8005145C.s.o(.bss); }
    .main_80052510 0x80052510 : AT(0x00053110) { FILL(0x00000000); build/asm/main_80052510.s.o(.text); build/asm/main_80052510.s.o(.rodata); build/asm/main_80052510.s.o(.data); }
    .main_80052510_bss (NOLOAD) : { build/asm/main_80052510.s.o(.bss); }
    .main_80052A58 0x80052A58 : AT(0x00053658) { FILL(0x00000000); build/asm/main_80052A58.s.o(.text); build/asm/main_80052A58.s.o(.rodata); build/asm/main_80052A58.s.o(.data); }
    .main_80052A58_bss (NOLOAD) : { build/asm/main_80052A58.s.o(.bss); }
    .main_80053DD8 0x80053DD8 : AT(0x000549D8) { build/asm/data/main_80053DD8.bin.o(.data); }
    .main_800553C8 0x800553C8 : AT(0x00055FC8) { FILL(0x00000000); build/asm/main_800553C8.s.o(.text); build/asm/main_800553C8.s.o(.rodata); build/asm/main_800553C8.s.o(.data); }
    .main_800553C8_bss (NOLOAD) : { build/asm/main_800553C8.s.o(.bss); }
    .main_80055400 0x80055400 : AT(0x00056000) { build/asm/data/main_80055400.bin.o(.data); }
    .main_80056050 0x80056050 : AT(0x00056C50) { FILL(0x00000000); build/asm/main_80056050.s.o(.text); build/asm/main_80056050.s.o(.rodata); build/asm/main_80056050.s.o(.data); }
    .main_80056050_bss (NOLOAD) : { build/asm/main_80056050.s.o(.bss); }
    .main_800560CC 0x800560CC : AT(0x00056CCC) { FILL(0x00000000); build/asm/main_800560CC.s.o(.text); build/asm/main_800560CC.s.o(.rodata); build/asm/main_800560CC.s.o(.data); }
    .main_800560CC_bss (NOLOAD) : { build/asm/main_800560CC.s.o(.bss); }
    .main_8005651C 0x8005651C : AT(0x0005711C) { build/asm/data/main_8005651C.bin.o(.data); }
    .main_80056E40 0x80056E40 : AT(0x00057A40) { FILL(0x00000000); build/asm/main_80056E40.s.o(.text); build/asm/main_80056E40.s.o(.rodata); build/asm/main_80056E40.s.o(.data); }
    .main_80056E40_bss (NOLOAD) : { build/asm/main_80056E40.s.o(.bss); }
    .main_8005738C 0x8005738C : AT(0x00057F8C) { FILL(0x00000000); build/asm/main_8005738C.s.o(.text); build/asm/main_8005738C.s.o(.rodata); build/asm/main_8005738C.s.o(.data); }
    .main_8005738C_bss (NOLOAD) : { build/asm/main_8005738C.s.o(.bss); }
    .main_800578F8 0x800578F8 : AT(0x000584F8) { build/asm/data/main_800578F8.bin.o(.data); }
    .main_80057C20 0x80057C20 : AT(0x00058820) { FILL(0x00000000); build/asm/main_80057C20.s.o(.text); build/asm/main_80057C20.s.o(.rodata); build/asm/main_80057C20.s.o(.data); }
    .main_80057C20_bss (NOLOAD) : { build/asm/main_80057C20.s.o(.bss); }
    .main_80057E90 0x80057E90 : AT(0x00058A90) { build/asm/data/main_80057E90.bin.o(.data); }
    .main_800580E4 0x800580E4 : AT(0x00058CE4) { build/asm/data/main_800580E4.bin.o(.data); }
    .main_80058314 0x80058314 : AT(0x00058F14) { build/asm/data/main_80058314.bin.o(.data); }
    .main_80058738 0x80058738 : AT(0x00059338) { build/asm/data/main_80058738.bin.o(.data); }
    .main_80058810 0x80058810 : AT(0x00059410) { build/asm/data/main_80058810.bin.o(.data); }
    .main_80058870 0x80058870 : AT(0x00059470) { FILL(0x00000000); build/asm/main_80058870.s.o(.text); build/asm/main_80058870.s.o(.rodata); build/asm/main_80058870.s.o(.data); }
    .main_80058870_bss (NOLOAD) : { build/asm/main_80058870.s.o(.bss); }
    .main_80058D24 0x80058D24 : AT(0x00059924) { build/asm/data/main_80058D24.bin.o(.data); }
    .main_80059370 0x80059370 : AT(0x00059F70) { build/asm/data/main_80059370.bin.o(.data); }
    .main_80059668 0x80059668 : AT(0x0005A268) { FILL(0x00000000); build/asm/main_80059668.s.o(.text); build/asm/main_80059668.s.o(.rodata); build/asm/main_80059668.s.o(.data); }
    .main_80059668_bss (NOLOAD) : { build/asm/main_80059668.s.o(.bss); }
    .main_800596AC 0x800596AC : AT(0x0005A2AC) { build/asm/data/main_800596AC.bin.o(.data); }
    .main_80059824 0x80059824 : AT(0x0005A424) { FILL(0x00000000); build/asm/main_80059824.s.o(.text); build/asm/main_80059824.s.o(.rodata); build/asm/main_80059824.s.o(.data); }
    .main_80059824_bss (NOLOAD) : { build/asm/main_80059824.s.o(.bss); }
    .main_80059844 0x80059844 : AT(0x0005A444) { build/asm/data/main_80059844.bin.o(.data); }
    .main_8005A16C 0x8005A16C : AT(0x0005AD6C) { FILL(0x00000000); build/asm/main_8005A16C.s.o(.text); build/asm/main_8005A16C.s.o(.rodata); build/asm/main_8005A16C.s.o(.data); }
    .main_8005A16C_bss (NOLOAD) : { build/asm/main_8005A16C.s.o(.bss); }
    .main_8005A21C 0x8005A21C : AT(0x0005AE1C) { build/asm/data/main_8005A21C.bin.o(.data); }
    .main_8005A3A8 0x8005A3A8 : AT(0x0005AFA8) { FILL(0x00000000); build/asm/main_8005A3A8.s.o(.text); build/asm/main_8005A3A8.s.o(.rodata); build/asm/main_8005A3A8.s.o(.data); }
    .main_8005A3A8_bss (NOLOAD) : { build/asm/main_8005A3A8.s.o(.bss); }
    .main_8005A414 0x8005A414 : AT(0x0005B014) { build/asm/data/main_8005A414.bin.o(.data); }
    .main_8005AAC0 0x8005AAC0 : AT(0x0005B6C0) { FILL(0x00000000); build/asm/main_8005AAC0.s.o(.text); build/asm/main_8005AAC0.s.o(.rodata); build/asm/main_8005AAC0.s.o(.data); }
    .main_8005AAC0_bss (NOLOAD) : { build/asm/main_8005AAC0.s.o(.bss); }
    .main_8005AAC4 0x8005AAC4 : AT(0x0005B6C4) { build/asm/data/main_8005AAC4.bin.o(.data); }
    .main_8005ACA4 0x8005ACA4 : AT(0x0005B8A4) { FILL(0x00000000); build/asm/main_8005ACA4.s.o(.text); build/asm/main_8005ACA4.s.o(.rodata); build/asm/main_8005ACA4.s.o(.data); }
    .main_8005ACA4_bss (NOLOAD) : { build/asm/main_8005ACA4.s.o(.bss); }
    .main_8005ACE4 0x8005ACE4 : AT(0x0005B8E4) { build/asm/data/main_8005ACE4.bin.o(.data); }
    .main_8005B2D8 0x8005B2D8 : AT(0x0005BED8) { FILL(0x00000000); build/asm/main_8005B2D8.s.o(.text); build/asm/main_8005B2D8.s.o(.rodata); build/asm/main_8005B2D8.s.o(.data); }
    .main_8005B2D8_bss (NOLOAD) : { build/asm/main_8005B2D8.s.o(.bss); }
    .main_8005B3CC 0x8005B3CC : AT(0x0005BFCC) { build/asm/data/main_8005B3CC.bin.o(.data); }
    .main_8005B424 0x8005B424 : AT(0x0005C024) { FILL(0x00000000); build/asm/main_8005B424.s.o(.text); build/asm/main_8005B424.s.o(.rodata); build/asm/main_8005B424.s.o(.data); }
    .main_8005B424_bss (NOLOAD) : { build/asm/main_8005B424.s.o(.bss); }
    .main_8005B450 0x8005B450 : AT(0x0005C050) { build/asm/data/main_8005B450.bin.o(.data); }
    .main_8005B928 0x8005B928 : AT(0x0005C528) { build/asm/data/main_8005B928.bin.o(.data); }
    .main_8005BB60 0x8005BB60 : AT(0x0005C760) { build/asm/data/main_8005BB60.bin.o(.data); }
    .main_8005FBC4 0x8005FBC4 : AT(0x000607C4) { build/asm/data/main_8005FBC4.bin.o(.data); }
    .main_80060AC0 0x80060AC0 : AT(0x000616C0) { FILL(0x00000000); build/asm/main_80060AC0.s.o(.text); build/asm/main_80060AC0.s.o(.rodata); build/asm/main_80060AC0.s.o(.data); }
    .main_80060AC0_bss (NOLOAD) : { build/asm/main_80060AC0.s.o(.bss); }
    .main_80060AC8 0x80060AC8 : AT(0x000616C8) { build/asm/data/main_80060AC8.bin.o(.data); }
    .main_80060F08 0x80060F08 : AT(0x00061B08) { FILL(0x00000000); build/asm/main_80060F08.s.o(.text); build/asm/main_80060F08.s.o(.rodata); build/asm/main_80060F08.s.o(.data); }
    .main_80060F08_bss (NOLOAD) : { build/asm/main_80060F08.s.o(.bss); }
    .main_80060F20 0x80060F20 : AT(0x00061B20) { build/asm/data/main_80060F20.bin.o(.data); }
    .main_800626DC 0x800626DC : AT(0x000632DC) { build/asm/data/main_800626DC.bin.o(.data); }
    .main_8006670C 0x8006670C : AT(0x0006730C) { build/asm/data/main_8006670C.bin.o(.data); }
    .main_8006790C 0x8006790C : AT(0x0006850C) { build/asm/data/main_8006790C.bin.o(.data); }
    .main_8006DFE8 0x8006DFE8 : AT(0x0006EBE8) { build/asm/data/main_8006DFE8.bin.o(.data); }
    .main_8006F80C 0x8006F80C : AT(0x0007040C) { build/asm/data/main_8006F80C.bin.o(.data); }
    .main_8006F878 0x8006F878 : AT(0x00070478) { FILL(0x00000000); build/asm/main_8006F878.s.o(.text); build/asm/main_8006F878.s.o(.rodata); build/asm/main_8006F878.s.o(.data); }
    .main_8006F878_bss (NOLOAD) : { build/asm/main_8006F878.s.o(.bss); }
    .main_8006F8CC 0x8006F8CC : AT(0x000704CC) { build/asm/data/main_8006F8CC.bin.o(.data); }
    .main_8006FBC4 0x8006FBC4 : AT(0x000707C4) { FILL(0x00000000); build/asm/main_8006FBC4.s.o(.text); build/asm/main_8006FBC4.s.o(.rodata); build/asm/main_8006FBC4.s.o(.data); }
    .main_8006FBC4_bss (NOLOAD) : { build/asm/main_8006FBC4.s.o(.bss); }
    .main_8006FE90 0x8006FE90 : AT(0x00070A90) { build/asm/data/main_8006FE90.bin.o(.data); }
    .main_80070600 0x80070600 : AT(0x00071200) { build/asm/data/main_80070600.bin.o(.data); }
    .main_800723D4 0x800723D4 : AT(0x00072FD4) { build/asm/data/main_800723D4.bin.o(.data); }
    .main_8007401C 0x8007401C : AT(0x00074C1C) { FILL(0x00000000); build/asm/main_8007401C.s.o(.text); build/asm/main_8007401C.s.o(.rodata); build/asm/main_8007401C.s.o(.data); }
    .main_8007401C_bss (NOLOAD) : { build/asm/main_8007401C.s.o(.bss); }
    .main_80074064 0x80074064 : AT(0x00074C64) { build/asm/data/main_80074064.bin.o(.data); }
    .main_8007476C 0x8007476C : AT(0x0007536C) { build/asm/data/main_8007476C.bin.o(.data); }
    .main_800768AC 0x800768AC : AT(0x000774AC) { build/asm/data/main_800768AC.bin.o(.data); }
    .main_80077C68 0x80077C68 : AT(0x00078868) { build/asm/data/main_80077C68.bin.o(.data); }
    .main_8008F8C8 0x8008F8C8 : AT(0x000904C8) { FILL(0x00000000); build/asm/main_8008F8C8.s.o(.text); build/asm/main_8008F8C8.s.o(.rodata); build/asm/main_8008F8C8.s.o(.data); }
    .main_8008F8C8_bss (NOLOAD) : { build/asm/main_8008F8C8.s.o(.bss); }
    .main_8008F8CC 0x8008F8CC : AT(0x000904CC) { build/asm/data/main_8008F8CC.bin.o(.data); }
    .main_800947AC 0x800947AC : AT(0x000953AC) { FILL(0x00000000); build/asm/main_800947AC.s.o(.text); build/asm/main_800947AC.s.o(.rodata); build/asm/main_800947AC.s.o(.data); }
    .main_800947AC_bss (NOLOAD) : { build/asm/main_800947AC.s.o(.bss); }
    .main_800947EC 0x800947EC : AT(0x000953EC) { build/asm/data/main_800947EC.bin.o(.data); }
    .main_80096E08 0x80096E08 : AT(0x00097A08) { FILL(0x00000000); build/asm/main_80096E08.s.o(.text); build/asm/main_80096E08.s.o(.rodata); build/asm/main_80096E08.s.o(.data); }
    .main_80096E08_bss (NOLOAD) : { build/asm/main_80096E08.s.o(.bss); }
    .main_80096E0C 0x80096E0C : AT(0x00097A0C) { build/asm/data/main_80096E0C.bin.o(.data); }
    .main_80097828 0x80097828 : AT(0x00098428) { FILL(0x00000000); build/asm/main_80097828.s.o(.text); build/asm/main_80097828.s.o(.rodata); build/asm/main_80097828.s.o(.data); }
    .main_80097828_bss (NOLOAD) : { build/asm/main_80097828.s.o(.bss); }
    .main_80097EB4 0x80097EB4 : AT(0x00098AB4) { build/asm/data/main_80097EB4.bin.o(.data); }
    .main_80098134 0x80098134 : AT(0x00098D34) { FILL(0x00000000); build/asm/main_80098134.s.o(.text); build/asm/main_80098134.s.o(.rodata); build/asm/main_80098134.s.o(.data); }
    .main_80098134_bss (NOLOAD) : { build/asm/main_80098134.s.o(.bss); }
    .main_80098164 0x80098164 : AT(0x00098D64) { build/asm/data/main_80098164.bin.o(.data); }
    .main_80098260 0x80098260 : AT(0x00098E60) { FILL(0x00000000); build/asm/main_80098260.s.o(.text); build/asm/main_80098260.s.o(.rodata); build/asm/main_80098260.s.o(.data); }
    .main_80098260_bss (NOLOAD) : { build/asm/main_80098260.s.o(.bss); }
    .main_800982A4 0x800982A4 : AT(0x00098EA4) { build/asm/data/main_800982A4.bin.o(.data); }
    .main_8009A5DC 0x8009A5DC : AT(0x0009B1DC) { build/asm/data/main_8009A5DC.bin.o(.data); }
    .main_8009BC3C 0x8009BC3C : AT(0x0009C83C) { build/asm/data/main_8009BC3C.bin.o(.data); }
    .main_8009C550 0x8009C550 : AT(0x0009D150) { build/asm/data/main_8009C550.bin.o(.data); }
    .main_8009FB28 0x8009FB28 : AT(0x000A0728) { FILL(0x00000000); build/asm/main_8009FB28.s.o(.text); build/asm/main_8009FB28.s.o(.rodata); build/asm/main_8009FB28.s.o(.data); }
    .main_8009FB28_bss (NOLOAD) : { build/asm/main_8009FB28.s.o(.bss); }
    .main_8009FB70 0x8009FB70 : AT(0x000A0770) { build/asm/data/main_8009FB70.bin.o(.data); }
    .main_800A4674 0x800A4674 : AT(0x000A5274) { FILL(0x00000000); build/asm/main_800A4674.s.o(.text); build/asm/main_800A4674.s.o(.rodata); build/asm/main_800A4674.s.o(.data); }
    .main_800A4674_bss (NOLOAD) : { build/asm/main_800A4674.s.o(.bss); }
    .main_800A46DC 0x800A46DC : AT(0x000A52DC) { build/asm/data/main_800A46DC.bin.o(.data); }
    .main_800ACB94 0x800ACB94 : AT(0x000AD794) { FILL(0x00000000); build/asm/main_800ACB94.s.o(.text); build/asm/main_800ACB94.s.o(.rodata); build/asm/main_800ACB94.s.o(.data); }
    .main_800ACB94_bss (NOLOAD) : { build/asm/main_800ACB94.s.o(.bss); }
    .main_800ACC00 0x800ACC00 : AT(0x000AD800) { build/asm/data/main_800ACC00.bin.o(.data); }
    .main_800B0B28 0x800B0B28 : AT(0x000B1728) { FILL(0x00000000); build/asm/main_800B0B28.s.o(.text); build/asm/main_800B0B28.s.o(.rodata); build/asm/main_800B0B28.s.o(.data); }
    .main_800B0B28_bss (NOLOAD) : { build/asm/main_800B0B28.s.o(.bss); }
    .main_800B0B30 0x800B0B30 : AT(0x000B1730) { build/asm/data/main_800B0B30.bin.o(.data); }
    .main_800B9358 0x800B9358 : AT(0x000B9F58) { FILL(0x00000000); build/asm/main_800B9358.s.o(.text); build/asm/main_800B9358.s.o(.rodata); build/asm/main_800B9358.s.o(.data); }
    .main_800B9358_bss (NOLOAD) : { build/asm/main_800B9358.s.o(.bss); }
    .main_800B9C20 0x800B9C20 : AT(0x000BA820) { build/asm/data/main_800B9C20.bin.o(.data); }
    .main_800BAC80 0x800BAC80 : AT(0x000BB880) { FILL(0x00000000); build/asm/main_800BAC80.s.o(.text); build/asm/main_800BAC80.s.o(.rodata); build/asm/main_800BAC80.s.o(.data); }
    .main_800BAC80_bss (NOLOAD) : { build/asm/main_800BAC80.s.o(.bss); }
    .main_800BAC90 0x800BAC90 : AT(0x000BB890) { build/asm/data/main_800BAC90.bin.o(.data); }
    .main_800BEC74 0x800BEC74 : AT(0x000BF874) { FILL(0x00000000); build/asm/main_800BEC74.s.o(.text); build/asm/main_800BEC74.s.o(.rodata); build/asm/main_800BEC74.s.o(.data); }
    .main_800BEC74_bss (NOLOAD) : { build/asm/main_800BEC74.s.o(.bss); }
    .main_800BEC7C 0x800BEC7C : AT(0x000BF87C) { build/asm/data/main_800BEC7C.bin.o(.data); }
    .main_800C1CD4 0x800C1CD4 : AT(0x000C28D4) { build/asm/data/main_800C1CD4.bin.o(.data); }
    .main_800C3600 0x800C3600 : AT(0x000C4200) { build/asm/data/main_800C3600.bin.o(.data); }
    .main_800C3EEC 0x800C3EEC : AT(0x000C4AEC) { build/asm/data/main_800C3EEC.bin.o(.data); }
    .main_800C3F48 0x800C3F48 : AT(0x000C4B48) { FILL(0x00000000); build/asm/main_800C3F48.s.o(.text); build/asm/main_800C3F48.s.o(.rodata); build/asm/main_800C3F48.s.o(.data); }
    .main_800C3F48_bss (NOLOAD) : { build/asm/main_800C3F48.s.o(.bss); }
    .main_800C4164 0x800C4164 : AT(0x000C4D64) { build/asm/data/main_800C4164.bin.o(.data); }
    .main_800C4528 0x800C4528 : AT(0x000C5128) { build/asm/data/main_800C4528.bin.o(.data); }
    .main_800C45A8 0x800C45A8 : AT(0x000C51A8) { build/asm/data/main_800C45A8.bin.o(.data); }
    .main_800C4EC4 0x800C4EC4 : AT(0x000C5AC4) { build/asm/data/main_800C4EC4.bin.o(.data); }
    .main_800C5E3C 0x800C5E3C : AT(0x000C6A3C) { build/asm/data/main_800C5E3C.bin.o(.data); }
    .main_800C6D70 0x800C6D70 : AT(0x000C7970) { build/asm/data/main_800C6D70.bin.o(.data); }
    .main_800C8040 0x800C8040 : AT(0x000C8C40) { build/asm/data/main_800C8040.bin.o(.data); }
    .main_800CE548 0x800CE548 : AT(0x000CF148) { FILL(0x00000000); build/asm/main_800CE548.s.o(.text); build/asm/main_800CE548.s.o(.rodata); build/asm/main_800CE548.s.o(.data); }
    .main_800CE548_bss (NOLOAD) : { build/asm/main_800CE548.s.o(.bss); }
    .main_800CE590 0x800CE590 : AT(0x000CF190) { build/asm/data/main_800CE590.bin.o(.data); }
    .main_800DECA0 0x800DECA0 : AT(0x000DF8A0) { FILL(0x00000000); build/asm/main_800DECA0.s.o(.text); build/asm/main_800DECA0.s.o(.rodata); build/asm/main_800DECA0.s.o(.data); }
    .main_800DECA0_bss (NOLOAD) : { build/asm/main_800DECA0.s.o(.bss); }
    .main_800DECD0 0x800DECD0 : AT(0x000DF8D0) { build/asm/data/main_800DECD0.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
