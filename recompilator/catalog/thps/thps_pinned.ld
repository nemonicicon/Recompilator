SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_8000078C 0x8000078C : AT(0x0000138C) { FILL(0x00000000); build/asm/main_8000078C.s.o(.text); build/asm/main_8000078C.s.o(.rodata); build/asm/main_8000078C.s.o(.data); }
    .main_8000078C_bss (NOLOAD) : { build/asm/main_8000078C.s.o(.bss); }
    .main_80000870 0x80000870 : AT(0x00001470) { FILL(0x00000000); build/asm/main_80000870.s.o(.text); build/asm/main_80000870.s.o(.rodata); build/asm/main_80000870.s.o(.data); }
    .main_80000870_bss (NOLOAD) : { build/asm/main_80000870.s.o(.bss); }
    .main_8000126C 0x8000126C : AT(0x00001E6C) { FILL(0x00000000); build/asm/main_8000126C.s.o(.text); build/asm/main_8000126C.s.o(.rodata); build/asm/main_8000126C.s.o(.data); }
    .main_8000126C_bss (NOLOAD) : { build/asm/main_8000126C.s.o(.bss); }
    .main_800026C4 0x800026C4 : AT(0x000032C4) { FILL(0x00000000); build/asm/main_800026C4.s.o(.text); build/asm/main_800026C4.s.o(.rodata); build/asm/main_800026C4.s.o(.data); }
    .main_800026C4_bss (NOLOAD) : { build/asm/main_800026C4.s.o(.bss); }
    .main_80002A90 0x80002A90 : AT(0x00003690) { FILL(0x00000000); build/asm/main_80002A90.s.o(.text); build/asm/main_80002A90.s.o(.rodata); build/asm/main_80002A90.s.o(.data); }
    .main_80002A90_bss (NOLOAD) : { build/asm/main_80002A90.s.o(.bss); }
    .main_800047F4 0x800047F4 : AT(0x000053F4) { FILL(0x00000000); build/asm/main_800047F4.s.o(.text); build/asm/main_800047F4.s.o(.rodata); build/asm/main_800047F4.s.o(.data); }
    .main_800047F4_bss (NOLOAD) : { build/asm/main_800047F4.s.o(.bss); }
    .main_80004ED0 0x80004ED0 : AT(0x00005AD0) { FILL(0x00000000); build/asm/main_80004ED0.s.o(.text); build/asm/main_80004ED0.s.o(.rodata); build/asm/main_80004ED0.s.o(.data); }
    .main_80004ED0_bss (NOLOAD) : { build/asm/main_80004ED0.s.o(.bss); }
    .main_80005840 0x80005840 : AT(0x00006440) { FILL(0x00000000); build/asm/main_80005840.s.o(.text); build/asm/main_80005840.s.o(.rodata); build/asm/main_80005840.s.o(.data); }
    .main_80005840_bss (NOLOAD) : { build/asm/main_80005840.s.o(.bss); }
    .main_8000B740 0x8000B740 : AT(0x0000C340) { FILL(0x00000000); build/asm/main_8000B740.s.o(.text); build/asm/main_8000B740.s.o(.rodata); build/asm/main_8000B740.s.o(.data); }
    .main_8000B740_bss (NOLOAD) : { build/asm/main_8000B740.s.o(.bss); }
    .main_8000D5B4 0x8000D5B4 : AT(0x0000E1B4) { FILL(0x00000000); build/asm/main_8000D5B4.s.o(.text); build/asm/main_8000D5B4.s.o(.rodata); build/asm/main_8000D5B4.s.o(.data); }
    .main_8000D5B4_bss (NOLOAD) : { build/asm/main_8000D5B4.s.o(.bss); }
    .main_8000D7B8 0x8000D7B8 : AT(0x0000E3B8) { FILL(0x00000000); build/asm/main_8000D7B8.s.o(.text); build/asm/main_8000D7B8.s.o(.rodata); build/asm/main_8000D7B8.s.o(.data); }
    .main_8000D7B8_bss (NOLOAD) : { build/asm/main_8000D7B8.s.o(.bss); }
    .main_8000DCD8 0x8000DCD8 : AT(0x0000E8D8) { FILL(0x00000000); build/asm/main_8000DCD8.s.o(.text); build/asm/main_8000DCD8.s.o(.rodata); build/asm/main_8000DCD8.s.o(.data); }
    .main_8000DCD8_bss (NOLOAD) : { build/asm/main_8000DCD8.s.o(.bss); }
    .main_8000E910 0x8000E910 : AT(0x0000F510) { FILL(0x00000000); build/asm/main_8000E910.s.o(.text); build/asm/main_8000E910.s.o(.rodata); build/asm/main_8000E910.s.o(.data); }
    .main_8000E910_bss (NOLOAD) : { build/asm/main_8000E910.s.o(.bss); }
    .main_8000EA80 0x8000EA80 : AT(0x0000F680) { FILL(0x00000000); build/asm/main_8000EA80.s.o(.text); build/asm/main_8000EA80.s.o(.rodata); build/asm/main_8000EA80.s.o(.data); }
    .main_8000EA80_bss (NOLOAD) : { build/asm/main_8000EA80.s.o(.bss); }
    .main_8000EC34 0x8000EC34 : AT(0x0000F834) { FILL(0x00000000); build/asm/main_8000EC34.s.o(.text); build/asm/main_8000EC34.s.o(.rodata); build/asm/main_8000EC34.s.o(.data); }
    .main_8000EC34_bss (NOLOAD) : { build/asm/main_8000EC34.s.o(.bss); }
    .main_8000F674 0x8000F674 : AT(0x00010274) { FILL(0x00000000); build/asm/main_8000F674.s.o(.text); build/asm/main_8000F674.s.o(.rodata); build/asm/main_8000F674.s.o(.data); }
    .main_8000F674_bss (NOLOAD) : { build/asm/main_8000F674.s.o(.bss); }
    .main_8000F6F0 0x8000F6F0 : AT(0x000102F0) { FILL(0x00000000); build/asm/main_8000F6F0.s.o(.text); build/asm/main_8000F6F0.s.o(.rodata); build/asm/main_8000F6F0.s.o(.data); }
    .main_8000F6F0_bss (NOLOAD) : { build/asm/main_8000F6F0.s.o(.bss); }
    .main_8000FA90 0x8000FA90 : AT(0x00010690) { FILL(0x00000000); build/asm/main_8000FA90.s.o(.text); build/asm/main_8000FA90.s.o(.rodata); build/asm/main_8000FA90.s.o(.data); }
    .main_8000FA90_bss (NOLOAD) : { build/asm/main_8000FA90.s.o(.bss); }
    .main_80011FB8 0x80011FB8 : AT(0x00012BB8) { build/asm/data/main_80011FB8.bin.o(.data); }
    .main_80013CB0 0x80013CB0 : AT(0x000148B0) { build/asm/data/main_80013CB0.bin.o(.data); }
    .main_8001460C 0x8001460C : AT(0x0001520C) { build/asm/data/main_8001460C.bin.o(.data); }
    .main_80016E88 0x80016E88 : AT(0x00017A88) { build/asm/data/main_80016E88.bin.o(.data); }
    .main_80019F00 0x80019F00 : AT(0x0001AB00) { FILL(0x00000000); build/asm/main_80019F00.s.o(.text); build/asm/main_80019F00.s.o(.rodata); build/asm/main_80019F00.s.o(.data); }
    .main_80019F00_bss (NOLOAD) : { build/asm/main_80019F00.s.o(.bss); }
    .main_80019F30 0x80019F30 : AT(0x0001AB30) { build/asm/data/main_80019F30.bin.o(.data); }
    .main_80028528 0x80028528 : AT(0x00029128) { FILL(0x00000000); build/asm/main_80028528.s.o(.text); build/asm/main_80028528.s.o(.rodata); build/asm/main_80028528.s.o(.data); }
    .main_80028528_bss (NOLOAD) : { build/asm/main_80028528.s.o(.bss); }
    .main_800285B0 0x800285B0 : AT(0x000291B0) { build/asm/data/main_800285B0.bin.o(.data); }
    .main_8002BFCC 0x8002BFCC : AT(0x0002CBCC) { FILL(0x00000000); build/asm/main_8002BFCC.s.o(.text); build/asm/main_8002BFCC.s.o(.rodata); build/asm/main_8002BFCC.s.o(.data); }
    .main_8002BFCC_bss (NOLOAD) : { build/asm/main_8002BFCC.s.o(.bss); }
    .main_8002BFD0 0x8002BFD0 : AT(0x0002CBD0) { build/asm/data/main_8002BFD0.bin.o(.data); }
    .main_8002BFEC 0x8002BFEC : AT(0x0002CBEC) { FILL(0x00000000); build/asm/main_8002BFEC.s.o(.text); build/asm/main_8002BFEC.s.o(.rodata); build/asm/main_8002BFEC.s.o(.data); }
    .main_8002BFEC_bss (NOLOAD) : { build/asm/main_8002BFEC.s.o(.bss); }
    .main_8002C048 0x8002C048 : AT(0x0002CC48) { build/asm/data/main_8002C048.bin.o(.data); }
    .main_800339E4 0x800339E4 : AT(0x000345E4) { FILL(0x00000000); build/asm/main_800339E4.s.o(.text); build/asm/main_800339E4.s.o(.rodata); build/asm/main_800339E4.s.o(.data); }
    .main_800339E4_bss (NOLOAD) : { build/asm/main_800339E4.s.o(.bss); }
    .main_80033AA8 0x80033AA8 : AT(0x000346A8) { build/asm/data/main_80033AA8.bin.o(.data); }
    .main_80043804 0x80043804 : AT(0x00044404) { FILL(0x00000000); build/asm/main_80043804.s.o(.text); build/asm/main_80043804.s.o(.rodata); build/asm/main_80043804.s.o(.data); }
    .main_80043804_bss (NOLOAD) : { build/asm/main_80043804.s.o(.bss); }
    .main_80043814 0x80043814 : AT(0x00044414) { build/asm/data/main_80043814.bin.o(.data); }
    .main_80049CE8 0x80049CE8 : AT(0x0004A8E8) { FILL(0x00000000); build/asm/main_80049CE8.s.o(.text); build/asm/main_80049CE8.s.o(.rodata); build/asm/main_80049CE8.s.o(.data); }
    .main_80049CE8_bss (NOLOAD) : { build/asm/main_80049CE8.s.o(.bss); }
    .main_80049D24 0x80049D24 : AT(0x0004A924) { build/asm/data/main_80049D24.bin.o(.data); }
    .main_8005D2B4 0x8005D2B4 : AT(0x0005DEB4) { FILL(0x00000000); build/asm/main_8005D2B4.s.o(.text); build/asm/main_8005D2B4.s.o(.rodata); build/asm/main_8005D2B4.s.o(.data); }
    .main_8005D2B4_bss (NOLOAD) : { build/asm/main_8005D2B4.s.o(.bss); }
    .main_8005D2C0 0x8005D2C0 : AT(0x0005DEC0) { build/asm/data/main_8005D2C0.bin.o(.data); }
    .main_8005F89C 0x8005F89C : AT(0x0006049C) { FILL(0x00000000); build/asm/main_8005F89C.s.o(.text); build/asm/main_8005F89C.s.o(.rodata); build/asm/main_8005F89C.s.o(.data); }
    .main_8005F89C_bss (NOLOAD) : { build/asm/main_8005F89C.s.o(.bss); }
    .main_8005F8B4 0x8005F8B4 : AT(0x000604B4) { build/asm/data/main_8005F8B4.bin.o(.data); }
    .main_8005FC5C 0x8005FC5C : AT(0x0006085C) { FILL(0x00000000); build/asm/main_8005FC5C.s.o(.text); build/asm/main_8005FC5C.s.o(.rodata); build/asm/main_8005FC5C.s.o(.data); }
    .main_8005FC5C_bss (NOLOAD) : { build/asm/main_8005FC5C.s.o(.bss); }
    .main_8005FC68 0x8005FC68 : AT(0x00060868) { build/asm/data/main_8005FC68.bin.o(.data); }
    .main_80066FB0 0x80066FB0 : AT(0x00067BB0) { FILL(0x00000000); build/asm/main_80066FB0.s.o(.text); build/asm/main_80066FB0.s.o(.rodata); build/asm/main_80066FB0.s.o(.data); }
    .main_80066FB0_bss (NOLOAD) : { build/asm/main_80066FB0.s.o(.bss); }
    .main_80066FC0 0x80066FC0 : AT(0x00067BC0) { build/asm/data/main_80066FC0.bin.o(.data); }
    .main_8006A6B0 0x8006A6B0 : AT(0x0006B2B0) { FILL(0x00000000); build/asm/main_8006A6B0.s.o(.text); build/asm/main_8006A6B0.s.o(.rodata); build/asm/main_8006A6B0.s.o(.data); }
    .main_8006A6B0_bss (NOLOAD) : { build/asm/main_8006A6B0.s.o(.bss); }
    .main_8006A720 0x8006A720 : AT(0x0006B320) { build/asm/data/main_8006A720.bin.o(.data); }
    .main_80089828 0x80089828 : AT(0x0008A428) { FILL(0x00000000); build/asm/main_80089828.s.o(.text); build/asm/main_80089828.s.o(.rodata); build/asm/main_80089828.s.o(.data); }
    .main_80089828_bss (NOLOAD) : { build/asm/main_80089828.s.o(.bss); }
    .main_80089878 0x80089878 : AT(0x0008A478) { build/asm/data/main_80089878.bin.o(.data); }
    .main_80093478 0x80093478 : AT(0x00094078) { FILL(0x00000000); build/asm/main_80093478.s.o(.text); build/asm/main_80093478.s.o(.rodata); build/asm/main_80093478.s.o(.data); }
    .main_80093478_bss (NOLOAD) : { build/asm/main_80093478.s.o(.bss); }
    .main_800934EC 0x800934EC : AT(0x000940EC) { build/asm/data/main_800934EC.bin.o(.data); }
    .main_8009CDCC 0x8009CDCC : AT(0x0009D9CC) { FILL(0x00000000); build/asm/main_8009CDCC.s.o(.text); build/asm/main_8009CDCC.s.o(.rodata); build/asm/main_8009CDCC.s.o(.data); }
    .main_8009CDCC_bss (NOLOAD) : { build/asm/main_8009CDCC.s.o(.bss); }
    .main_8009CE10 0x8009CE10 : AT(0x0009DA10) { build/asm/data/main_8009CE10.bin.o(.data); }
    .main_800AA35C 0x800AA35C : AT(0x000AAF5C) { FILL(0x00000000); build/asm/main_800AA35C.s.o(.text); build/asm/main_800AA35C.s.o(.rodata); build/asm/main_800AA35C.s.o(.data); }
    .main_800AA35C_bss (NOLOAD) : { build/asm/main_800AA35C.s.o(.bss); }
    .main_800AA388 0x800AA388 : AT(0x000AAF88) { build/asm/data/main_800AA388.bin.o(.data); }
    .main_800AAD64 0x800AAD64 : AT(0x000AB964) { FILL(0x00000000); build/asm/main_800AAD64.s.o(.text); build/asm/main_800AAD64.s.o(.rodata); build/asm/main_800AAD64.s.o(.data); }
    .main_800AAD64_bss (NOLOAD) : { build/asm/main_800AAD64.s.o(.bss); }
    .main_800AAD68 0x800AAD68 : AT(0x000AB968) { build/asm/data/main_800AAD68.bin.o(.data); }
    .main_800BD188 0x800BD188 : AT(0x000BDD88) { FILL(0x00000000); build/asm/main_800BD188.s.o(.text); build/asm/main_800BD188.s.o(.rodata); build/asm/main_800BD188.s.o(.data); }
    .main_800BD188_bss (NOLOAD) : { build/asm/main_800BD188.s.o(.bss); }
    .main_800BD198 0x800BD198 : AT(0x000BDD98) { build/asm/data/main_800BD198.bin.o(.data); }
    .main_800CE49C 0x800CE49C : AT(0x000CF09C) { FILL(0x00000000); build/asm/main_800CE49C.s.o(.text); build/asm/main_800CE49C.s.o(.rodata); build/asm/main_800CE49C.s.o(.data); }
    .main_800CE49C_bss (NOLOAD) : { build/asm/main_800CE49C.s.o(.bss); }
    .main_800CE4A4 0x800CE4A4 : AT(0x000CF0A4) { build/asm/data/main_800CE4A4.bin.o(.data); }
    .main_800CF058 0x800CF058 : AT(0x000CFC58) { FILL(0x00000000); build/asm/main_800CF058.s.o(.text); build/asm/main_800CF058.s.o(.rodata); build/asm/main_800CF058.s.o(.data); }
    .main_800CF058_bss (NOLOAD) : { build/asm/main_800CF058.s.o(.bss); }
    .main_800CF064 0x800CF064 : AT(0x000CFC64) { build/asm/data/main_800CF064.bin.o(.data); }
    .main_800D1954 0x800D1954 : AT(0x000D2554) { FILL(0x00000000); build/asm/main_800D1954.s.o(.text); build/asm/main_800D1954.s.o(.rodata); build/asm/main_800D1954.s.o(.data); }
    .main_800D1954_bss (NOLOAD) : { build/asm/main_800D1954.s.o(.bss); }
    .main_800D198C 0x800D198C : AT(0x000D258C) { build/asm/data/main_800D198C.bin.o(.data); }
    .main_800D8E8C 0x800D8E8C : AT(0x000D9A8C) { FILL(0x00000000); build/asm/main_800D8E8C.s.o(.text); build/asm/main_800D8E8C.s.o(.rodata); build/asm/main_800D8E8C.s.o(.data); }
    .main_800D8E8C_bss (NOLOAD) : { build/asm/main_800D8E8C.s.o(.bss); }
    .main_800D8EC8 0x800D8EC8 : AT(0x000D9AC8) { build/asm/data/main_800D8EC8.bin.o(.data); }
    .main_800DD1DC 0x800DD1DC : AT(0x000DDDDC) { FILL(0x00000000); build/asm/main_800DD1DC.s.o(.text); build/asm/main_800DD1DC.s.o(.rodata); build/asm/main_800DD1DC.s.o(.data); }
    .main_800DD1DC_bss (NOLOAD) : { build/asm/main_800DD1DC.s.o(.bss); }
    .main_800DD1EC 0x800DD1EC : AT(0x000DDDEC) { build/asm/data/main_800DD1EC.bin.o(.data); }
    .main_800DF31C 0x800DF31C : AT(0x000DFF1C) { FILL(0x00000000); build/asm/main_800DF31C.s.o(.text); build/asm/main_800DF31C.s.o(.rodata); build/asm/main_800DF31C.s.o(.data); }
    .main_800DF31C_bss (NOLOAD) : { build/asm/main_800DF31C.s.o(.bss); }
    .main_800DF330 0x800DF330 : AT(0x000DFF30) { build/asm/data/main_800DF330.bin.o(.data); }
    .main_800DF748 0x800DF748 : AT(0x000E0348) { FILL(0x00000000); build/asm/main_800DF748.s.o(.text); build/asm/main_800DF748.s.o(.rodata); build/asm/main_800DF748.s.o(.data); }
    .main_800DF748_bss (NOLOAD) : { build/asm/main_800DF748.s.o(.bss); }
    .main_800DF7D8 0x800DF7D8 : AT(0x000E03D8) { build/asm/data/main_800DF7D8.bin.o(.data); }
    .main_800E3EFC 0x800E3EFC : AT(0x000E4AFC) { FILL(0x00000000); build/asm/main_800E3EFC.s.o(.text); build/asm/main_800E3EFC.s.o(.rodata); build/asm/main_800E3EFC.s.o(.data); }
    .main_800E3EFC_bss (NOLOAD) : { build/asm/main_800E3EFC.s.o(.bss); }
    .main_800E3F0C 0x800E3F0C : AT(0x000E4B0C) { build/asm/data/main_800E3F0C.bin.o(.data); }
    .main_800E475C 0x800E475C : AT(0x000E535C) { FILL(0x00000000); build/asm/main_800E475C.s.o(.text); build/asm/main_800E475C.s.o(.rodata); build/asm/main_800E475C.s.o(.data); }
    .main_800E475C_bss (NOLOAD) : { build/asm/main_800E475C.s.o(.bss); }
    .main_800E47EC 0x800E47EC : AT(0x000E53EC) { build/asm/data/main_800E47EC.bin.o(.data); }
    .main_800E696C 0x800E696C : AT(0x000E756C) { FILL(0x00000000); build/asm/main_800E696C.s.o(.text); build/asm/main_800E696C.s.o(.rodata); build/asm/main_800E696C.s.o(.data); }
    .main_800E696C_bss (NOLOAD) : { build/asm/main_800E696C.s.o(.bss); }
    .main_800E6974 0x800E6974 : AT(0x000E7574) { build/asm/data/main_800E6974.bin.o(.data); }
    .main_800F41E8 0x800F41E8 : AT(0x000F4DE8) { build/asm/data/main_800F41E8.bin.o(.data); }
    .main_800F9374 0x800F9374 : AT(0x000F9F74) { FILL(0x00000000); build/asm/main_800F9374.s.o(.text); build/asm/main_800F9374.s.o(.rodata); build/asm/main_800F9374.s.o(.data); }
    .main_800F9374_bss (NOLOAD) : { build/asm/main_800F9374.s.o(.bss); }
    .main_800F939C 0x800F939C : AT(0x000F9F9C) { build/asm/data/main_800F939C.bin.o(.data); }
    .main_800F9D34 0x800F9D34 : AT(0x000FA934) { build/asm/data/main_800F9D34.bin.o(.data); }
    .main_800FE108 0x800FE108 : AT(0x000FED08) { FILL(0x00000000); build/asm/main_800FE108.s.o(.text); build/asm/main_800FE108.s.o(.rodata); build/asm/main_800FE108.s.o(.data); }
    .main_800FE108_bss (NOLOAD) : { build/asm/main_800FE108.s.o(.bss); }
    .main_800FE118 0x800FE118 : AT(0x000FED18) { build/asm/data/main_800FE118.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
