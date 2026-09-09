SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80029400 0x80029400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80029400.s.o(.text); build/asm/main_80029400.s.o(.rodata); build/asm/main_80029400.s.o(.data); }
    .main_80029400_bss (NOLOAD) : { build/asm/main_80029400.s.o(.bss); }
    .main_8002C8E4 0x8002C8E4 : AT(0x000044E4) { FILL(0x00000000); build/asm/main_8002C8E4.s.o(.text); build/asm/main_8002C8E4.s.o(.rodata); build/asm/main_8002C8E4.s.o(.data); }
    .main_8002C8E4_bss (NOLOAD) : { build/asm/main_8002C8E4.s.o(.bss); }
    .main_8002CAA0 0x8002CAA0 : AT(0x000046A0) { FILL(0x00000000); build/asm/main_8002CAA0.s.o(.text); build/asm/main_8002CAA0.s.o(.rodata); build/asm/main_8002CAA0.s.o(.data); }
    .main_8002CAA0_bss (NOLOAD) : { build/asm/main_8002CAA0.s.o(.bss); }
    .main_8002E300 0x8002E300 : AT(0x00005F00) { FILL(0x00000000); build/asm/main_8002E300.s.o(.text); build/asm/main_8002E300.s.o(.rodata); build/asm/main_8002E300.s.o(.data); }
    .main_8002E300_bss (NOLOAD) : { build/asm/main_8002E300.s.o(.bss); }
    .main_80031CEC 0x80031CEC : AT(0x000098EC) { FILL(0x00000000); build/asm/main_80031CEC.s.o(.text); build/asm/main_80031CEC.s.o(.rodata); build/asm/main_80031CEC.s.o(.data); }
    .main_80031CEC_bss (NOLOAD) : { build/asm/main_80031CEC.s.o(.bss); }
    .main_80032B3C 0x80032B3C : AT(0x0000A73C) { FILL(0x00000000); build/asm/main_80032B3C.s.o(.text); build/asm/main_80032B3C.s.o(.rodata); build/asm/main_80032B3C.s.o(.data); }
    .main_80032B3C_bss (NOLOAD) : { build/asm/main_80032B3C.s.o(.bss); }
    .main_80032C4C 0x80032C4C : AT(0x0000A84C) { FILL(0x00000000); build/asm/main_80032C4C.s.o(.text); build/asm/main_80032C4C.s.o(.rodata); build/asm/main_80032C4C.s.o(.data); }
    .main_80032C4C_bss (NOLOAD) : { build/asm/main_80032C4C.s.o(.bss); }
    .main_80033F74 0x80033F74 : AT(0x0000BB74) { FILL(0x00000000); build/asm/main_80033F74.s.o(.text); build/asm/main_80033F74.s.o(.rodata); build/asm/main_80033F74.s.o(.data); }
    .main_80033F74_bss (NOLOAD) : { build/asm/main_80033F74.s.o(.bss); }
    .main_800345EC 0x800345EC : AT(0x0000C1EC) { FILL(0x00000000); build/asm/main_800345EC.s.o(.text); build/asm/main_800345EC.s.o(.rodata); build/asm/main_800345EC.s.o(.data); }
    .main_800345EC_bss (NOLOAD) : { build/asm/main_800345EC.s.o(.bss); }
    .main_80034C80 0x80034C80 : AT(0x0000C880) { FILL(0x00000000); build/asm/main_80034C80.s.o(.text); build/asm/main_80034C80.s.o(.rodata); build/asm/main_80034C80.s.o(.data); }
    .main_80034C80_bss (NOLOAD) : { build/asm/main_80034C80.s.o(.bss); }
    .main_80035710 0x80035710 : AT(0x0000D310) { FILL(0x00000000); build/asm/main_80035710.s.o(.text); build/asm/main_80035710.s.o(.rodata); build/asm/main_80035710.s.o(.data); }
    .main_80035710_bss (NOLOAD) : { build/asm/main_80035710.s.o(.bss); }
    .main_80035AC4 0x80035AC4 : AT(0x0000D6C4) { FILL(0x00000000); build/asm/main_80035AC4.s.o(.text); build/asm/main_80035AC4.s.o(.rodata); build/asm/main_80035AC4.s.o(.data); }
    .main_80035AC4_bss (NOLOAD) : { build/asm/main_80035AC4.s.o(.bss); }
    .main_800361A0 0x800361A0 : AT(0x0000DDA0) { FILL(0x00000000); build/asm/main_800361A0.s.o(.text); build/asm/main_800361A0.s.o(.rodata); build/asm/main_800361A0.s.o(.data); }
    .main_800361A0_bss (NOLOAD) : { build/asm/main_800361A0.s.o(.bss); }
    .main_8003B900 0x8003B900 : AT(0x00013500) { FILL(0x00000000); build/asm/main_8003B900.s.o(.text); build/asm/main_8003B900.s.o(.rodata); build/asm/main_8003B900.s.o(.data); }
    .main_8003B900_bss (NOLOAD) : { build/asm/main_8003B900.s.o(.bss); }
    .main_8003E4E0 0x8003E4E0 : AT(0x000160E0) { FILL(0x00000000); build/asm/main_8003E4E0.s.o(.text); build/asm/main_8003E4E0.s.o(.rodata); build/asm/main_8003E4E0.s.o(.data); }
    .main_8003E4E0_bss (NOLOAD) : { build/asm/main_8003E4E0.s.o(.bss); }
    .main_800426C0 0x800426C0 : AT(0x0001A2C0) { FILL(0x00000000); build/asm/main_800426C0.s.o(.text); build/asm/main_800426C0.s.o(.rodata); build/asm/main_800426C0.s.o(.data); }
    .main_800426C0_bss (NOLOAD) : { build/asm/main_800426C0.s.o(.bss); }
    .main_80043754 0x80043754 : AT(0x0001B354) { FILL(0x00000000); build/asm/main_80043754.s.o(.text); build/asm/main_80043754.s.o(.rodata); build/asm/main_80043754.s.o(.data); }
    .main_80043754_bss (NOLOAD) : { build/asm/main_80043754.s.o(.bss); }
    .main_80043BDC 0x80043BDC : AT(0x0001B7DC) { FILL(0x00000000); build/asm/main_80043BDC.s.o(.text); build/asm/main_80043BDC.s.o(.rodata); build/asm/main_80043BDC.s.o(.data); }
    .main_80043BDC_bss (NOLOAD) : { build/asm/main_80043BDC.s.o(.bss); }
    .main_80044050 0x80044050 : AT(0x0001BC50) { FILL(0x00000000); build/asm/main_80044050.s.o(.text); build/asm/main_80044050.s.o(.rodata); build/asm/main_80044050.s.o(.data); }
    .main_80044050_bss (NOLOAD) : { build/asm/main_80044050.s.o(.bss); }
    .main_80045760 0x80045760 : AT(0x0001D360) { FILL(0x00000000); build/asm/main_80045760.s.o(.text); build/asm/main_80045760.s.o(.rodata); build/asm/main_80045760.s.o(.data); }
    .main_80045760_bss (NOLOAD) : { build/asm/main_80045760.s.o(.bss); }
    .main_80045E68 0x80045E68 : AT(0x0001DA68) { FILL(0x00000000); build/asm/main_80045E68.s.o(.text); build/asm/main_80045E68.s.o(.rodata); build/asm/main_80045E68.s.o(.data); }
    .main_80045E68_bss (NOLOAD) : { build/asm/main_80045E68.s.o(.bss); }
    .main_80046670 0x80046670 : AT(0x0001E270) { FILL(0x00000000); build/asm/main_80046670.s.o(.text); build/asm/main_80046670.s.o(.rodata); build/asm/main_80046670.s.o(.data); }
    .main_80046670_bss (NOLOAD) : { build/asm/main_80046670.s.o(.bss); }
    .main_8004C77C 0x8004C77C : AT(0x0002437C) { FILL(0x00000000); build/asm/main_8004C77C.s.o(.text); build/asm/main_8004C77C.s.o(.rodata); build/asm/main_8004C77C.s.o(.data); }
    .main_8004C77C_bss (NOLOAD) : { build/asm/main_8004C77C.s.o(.bss); }
    .main_8004D770 0x8004D770 : AT(0x00025370) { FILL(0x00000000); build/asm/main_8004D770.s.o(.text); build/asm/main_8004D770.s.o(.rodata); build/asm/main_8004D770.s.o(.data); }
    .main_8004D770_bss (NOLOAD) : { build/asm/main_8004D770.s.o(.bss); }
    .main_8004E32C 0x8004E32C : AT(0x00025F2C) { FILL(0x00000000); build/asm/main_8004E32C.s.o(.text); build/asm/main_8004E32C.s.o(.rodata); build/asm/main_8004E32C.s.o(.data); }
    .main_8004E32C_bss (NOLOAD) : { build/asm/main_8004E32C.s.o(.bss); }
    .main_8004E760 0x8004E760 : AT(0x00026360) { FILL(0x00000000); build/asm/main_8004E760.s.o(.text); build/asm/main_8004E760.s.o(.rodata); build/asm/main_8004E760.s.o(.data); }
    .main_8004E760_bss (NOLOAD) : { build/asm/main_8004E760.s.o(.bss); }
    .main_800587CC 0x800587CC : AT(0x000303CC) { FILL(0x00000000); build/asm/main_800587CC.s.o(.text); build/asm/main_800587CC.s.o(.rodata); build/asm/main_800587CC.s.o(.data); }
    .main_800587CC_bss (NOLOAD) : { build/asm/main_800587CC.s.o(.bss); }
    .main_80058910 0x80058910 : AT(0x00030510) { FILL(0x00000000); build/asm/main_80058910.s.o(.text); build/asm/main_80058910.s.o(.rodata); build/asm/main_80058910.s.o(.data); }
    .main_80058910_bss (NOLOAD) : { build/asm/main_80058910.s.o(.bss); }
    .main_8005A75C 0x8005A75C : AT(0x0003235C) { FILL(0x00000000); build/asm/main_8005A75C.s.o(.text); build/asm/main_8005A75C.s.o(.rodata); build/asm/main_8005A75C.s.o(.data); }
    .main_8005A75C_bss (NOLOAD) : { build/asm/main_8005A75C.s.o(.bss); }
    .main_8005AE2C 0x8005AE2C : AT(0x00032A2C) { FILL(0x00000000); build/asm/main_8005AE2C.s.o(.text); build/asm/main_8005AE2C.s.o(.rodata); build/asm/main_8005AE2C.s.o(.data); }
    .main_8005AE2C_bss (NOLOAD) : { build/asm/main_8005AE2C.s.o(.bss); }
    .main_8005C994 0x8005C994 : AT(0x00034594) { FILL(0x00000000); build/asm/main_8005C994.s.o(.text); build/asm/main_8005C994.s.o(.rodata); build/asm/main_8005C994.s.o(.data); }
    .main_8005C994_bss (NOLOAD) : { build/asm/main_8005C994.s.o(.bss); }
    .main_800613E0 0x800613E0 : AT(0x00038FE0) { FILL(0x00000000); build/asm/main_800613E0.s.o(.text); build/asm/main_800613E0.s.o(.rodata); build/asm/main_800613E0.s.o(.data); }
    .main_800613E0_bss (NOLOAD) : { build/asm/main_800613E0.s.o(.bss); }
    .main_800685C0 0x800685C0 : AT(0x000401C0) { FILL(0x00000000); build/asm/main_800685C0.s.o(.text); build/asm/main_800685C0.s.o(.rodata); build/asm/main_800685C0.s.o(.data); }
    .main_800685C0_bss (NOLOAD) : { build/asm/main_800685C0.s.o(.bss); }
    .main_8006AD68 0x8006AD68 : AT(0x00042968) { FILL(0x00000000); build/asm/main_8006AD68.s.o(.text); build/asm/main_8006AD68.s.o(.rodata); build/asm/main_8006AD68.s.o(.data); }
    .main_8006AD68_bss (NOLOAD) : { build/asm/main_8006AD68.s.o(.bss); }
    .main_8006B9FC 0x8006B9FC : AT(0x000435FC) { FILL(0x00000000); build/asm/main_8006B9FC.s.o(.text); build/asm/main_8006B9FC.s.o(.rodata); build/asm/main_8006B9FC.s.o(.data); }
    .main_8006B9FC_bss (NOLOAD) : { build/asm/main_8006B9FC.s.o(.bss); }
    .main_8006BEE0 0x8006BEE0 : AT(0x00043AE0) { FILL(0x00000000); build/asm/main_8006BEE0.s.o(.text); build/asm/main_8006BEE0.s.o(.rodata); build/asm/main_8006BEE0.s.o(.data); }
    .main_8006BEE0_bss (NOLOAD) : { build/asm/main_8006BEE0.s.o(.bss); }
    .main_8006D90C 0x8006D90C : AT(0x0004550C) { FILL(0x00000000); build/asm/main_8006D90C.s.o(.text); build/asm/main_8006D90C.s.o(.rodata); build/asm/main_8006D90C.s.o(.data); }
    .main_8006D90C_bss (NOLOAD) : { build/asm/main_8006D90C.s.o(.bss); }
    .main_80070060 0x80070060 : AT(0x00047C60) { FILL(0x00000000); build/asm/main_80070060.s.o(.text); build/asm/main_80070060.s.o(.rodata); build/asm/main_80070060.s.o(.data); }
    .main_80070060_bss (NOLOAD) : { build/asm/main_80070060.s.o(.bss); }
    .main_80070240 0x80070240 : AT(0x00047E40) { FILL(0x00000000); build/asm/main_80070240.s.o(.text); build/asm/main_80070240.s.o(.rodata); build/asm/main_80070240.s.o(.data); }
    .main_80070240_bss (NOLOAD) : { build/asm/main_80070240.s.o(.bss); }
    .main_80072B84 0x80072B84 : AT(0x0004A784) { FILL(0x00000000); build/asm/main_80072B84.s.o(.text); build/asm/main_80072B84.s.o(.rodata); build/asm/main_80072B84.s.o(.data); }
    .main_80072B84_bss (NOLOAD) : { build/asm/main_80072B84.s.o(.bss); }
    .main_80073504 0x80073504 : AT(0x0004B104) { FILL(0x00000000); build/asm/main_80073504.s.o(.text); build/asm/main_80073504.s.o(.rodata); build/asm/main_80073504.s.o(.data); }
    .main_80073504_bss (NOLOAD) : { build/asm/main_80073504.s.o(.bss); }
    .main_80074B80 0x80074B80 : AT(0x0004C780) { FILL(0x00000000); build/asm/main_80074B80.s.o(.text); build/asm/main_80074B80.s.o(.rodata); build/asm/main_80074B80.s.o(.data); }
    .main_80074B80_bss (NOLOAD) : { build/asm/main_80074B80.s.o(.bss); }
    .main_800757D0 0x800757D0 : AT(0x0004D3D0) { FILL(0x00000000); build/asm/main_800757D0.s.o(.text); build/asm/main_800757D0.s.o(.rodata); build/asm/main_800757D0.s.o(.data); }
    .main_800757D0_bss (NOLOAD) : { build/asm/main_800757D0.s.o(.bss); }
    .main_80075A00 0x80075A00 : AT(0x0004D600) { FILL(0x00000000); build/asm/main_80075A00.s.o(.text); build/asm/main_80075A00.s.o(.rodata); build/asm/main_80075A00.s.o(.data); }
    .main_80075A00_bss (NOLOAD) : { build/asm/main_80075A00.s.o(.bss); }
    .main_80079A50 0x80079A50 : AT(0x00051650) { FILL(0x00000000); build/asm/main_80079A50.s.o(.text); build/asm/main_80079A50.s.o(.rodata); build/asm/main_80079A50.s.o(.data); }
    .main_80079A50_bss (NOLOAD) : { build/asm/main_80079A50.s.o(.bss); }
    .main_8007C790 0x8007C790 : AT(0x00054390) { FILL(0x00000000); build/asm/main_8007C790.s.o(.text); build/asm/main_8007C790.s.o(.rodata); build/asm/main_8007C790.s.o(.data); }
    .main_8007C790_bss (NOLOAD) : { build/asm/main_8007C790.s.o(.bss); }
    .main_8007E2CC 0x8007E2CC : AT(0x00055ECC) { FILL(0x00000000); build/asm/main_8007E2CC.s.o(.text); build/asm/main_8007E2CC.s.o(.rodata); build/asm/main_8007E2CC.s.o(.data); }
    .main_8007E2CC_bss (NOLOAD) : { build/asm/main_8007E2CC.s.o(.bss); }
    .main_8007FD60 0x8007FD60 : AT(0x00057960) { FILL(0x00000000); build/asm/main_8007FD60.s.o(.text); build/asm/main_8007FD60.s.o(.rodata); build/asm/main_8007FD60.s.o(.data); }
    .main_8007FD60_bss (NOLOAD) : { build/asm/main_8007FD60.s.o(.bss); }
    .main_800820D4 0x800820D4 : AT(0x00059CD4) { FILL(0x00000000); build/asm/main_800820D4.s.o(.text); build/asm/main_800820D4.s.o(.rodata); build/asm/main_800820D4.s.o(.data); }
    .main_800820D4_bss (NOLOAD) : { build/asm/main_800820D4.s.o(.bss); }
    .main_80082400 0x80082400 : AT(0x0005A000) { FILL(0x00000000); build/asm/main_80082400.s.o(.text); build/asm/main_80082400.s.o(.rodata); build/asm/main_80082400.s.o(.data); }
    .main_80082400_bss (NOLOAD) : { build/asm/main_80082400.s.o(.bss); }
    .main_800831EC 0x800831EC : AT(0x0005ADEC) { FILL(0x00000000); build/asm/main_800831EC.s.o(.text); build/asm/main_800831EC.s.o(.rodata); build/asm/main_800831EC.s.o(.data); }
    .main_800831EC_bss (NOLOAD) : { build/asm/main_800831EC.s.o(.bss); }
    .main_800835D0 0x800835D0 : AT(0x0005B1D0) { FILL(0x00000000); build/asm/main_800835D0.s.o(.text); build/asm/main_800835D0.s.o(.rodata); build/asm/main_800835D0.s.o(.data); }
    .main_800835D0_bss (NOLOAD) : { build/asm/main_800835D0.s.o(.bss); }
    .main_80084584 0x80084584 : AT(0x0005C184) { FILL(0x00000000); build/asm/main_80084584.s.o(.text); build/asm/main_80084584.s.o(.rodata); build/asm/main_80084584.s.o(.data); }
    .main_80084584_bss (NOLOAD) : { build/asm/main_80084584.s.o(.bss); }
    .main_80085084 0x80085084 : AT(0x0005CC84) { FILL(0x00000000); build/asm/main_80085084.s.o(.text); build/asm/main_80085084.s.o(.rodata); build/asm/main_80085084.s.o(.data); }
    .main_80085084_bss (NOLOAD) : { build/asm/main_80085084.s.o(.bss); }
    .main_80085340 0x80085340 : AT(0x0005CF40) { FILL(0x00000000); build/asm/main_80085340.s.o(.text); build/asm/main_80085340.s.o(.rodata); build/asm/main_80085340.s.o(.data); }
    .main_80085340_bss (NOLOAD) : { build/asm/main_80085340.s.o(.bss); }
    .main_80085948 0x80085948 : AT(0x0005D548) { FILL(0x00000000); build/asm/main_80085948.s.o(.text); build/asm/main_80085948.s.o(.rodata); build/asm/main_80085948.s.o(.data); }
    .main_80085948_bss (NOLOAD) : { build/asm/main_80085948.s.o(.bss); }
    .main_8008BF00 0x8008BF00 : AT(0x00063B00) { FILL(0x00000000); build/asm/main_8008BF00.s.o(.text); build/asm/main_8008BF00.s.o(.rodata); build/asm/main_8008BF00.s.o(.data); }
    .main_8008BF00_bss (NOLOAD) : { build/asm/main_8008BF00.s.o(.bss); }
    .main_8008BFF0 0x8008BFF0 : AT(0x00063BF0) { FILL(0x00000000); build/asm/main_8008BFF0.s.o(.text); build/asm/main_8008BFF0.s.o(.rodata); build/asm/main_8008BFF0.s.o(.data); }
    .main_8008BFF0_bss (NOLOAD) : { build/asm/main_8008BFF0.s.o(.bss); }
    .main_8008C590 0x8008C590 : AT(0x00064190) { FILL(0x00000000); build/asm/main_8008C590.s.o(.text); build/asm/main_8008C590.s.o(.rodata); build/asm/main_8008C590.s.o(.data); }
    .main_8008C590_bss (NOLOAD) : { build/asm/main_8008C590.s.o(.bss); }
    .main_8008CDC0 0x8008CDC0 : AT(0x000649C0) { FILL(0x00000000); build/asm/main_8008CDC0.s.o(.text); build/asm/main_8008CDC0.s.o(.rodata); build/asm/main_8008CDC0.s.o(.data); }
    .main_8008CDC0_bss (NOLOAD) : { build/asm/main_8008CDC0.s.o(.bss); }
    .main_8008FD88 0x8008FD88 : AT(0x00067988) { FILL(0x00000000); build/asm/main_8008FD88.s.o(.text); build/asm/main_8008FD88.s.o(.rodata); build/asm/main_8008FD88.s.o(.data); }
    .main_8008FD88_bss (NOLOAD) : { build/asm/main_8008FD88.s.o(.bss); }
    .main_800920AC 0x800920AC : AT(0x00069CAC) { FILL(0x00000000); build/asm/main_800920AC.s.o(.text); build/asm/main_800920AC.s.o(.rodata); build/asm/main_800920AC.s.o(.data); }
    .main_800920AC_bss (NOLOAD) : { build/asm/main_800920AC.s.o(.bss); }
    .main_80093894 0x80093894 : AT(0x0006B494) { FILL(0x00000000); build/asm/main_80093894.s.o(.text); build/asm/main_80093894.s.o(.rodata); build/asm/main_80093894.s.o(.data); }
    .main_80093894_bss (NOLOAD) : { build/asm/main_80093894.s.o(.bss); }
    .main_80093D3C 0x80093D3C : AT(0x0006B93C) { FILL(0x00000000); build/asm/main_80093D3C.s.o(.text); build/asm/main_80093D3C.s.o(.rodata); build/asm/main_80093D3C.s.o(.data); }
    .main_80093D3C_bss (NOLOAD) : { build/asm/main_80093D3C.s.o(.bss); }
    .main_800946A0 0x800946A0 : AT(0x0006C2A0) { FILL(0x00000000); build/asm/main_800946A0.s.o(.text); build/asm/main_800946A0.s.o(.rodata); build/asm/main_800946A0.s.o(.data); }
    .main_800946A0_bss (NOLOAD) : { build/asm/main_800946A0.s.o(.bss); }
    .main_80097DC8 0x80097DC8 : AT(0x0006F9C8) { FILL(0x00000000); build/asm/main_80097DC8.s.o(.text); build/asm/main_80097DC8.s.o(.rodata); build/asm/main_80097DC8.s.o(.data); }
    .main_80097DC8_bss (NOLOAD) : { build/asm/main_80097DC8.s.o(.bss); }
    .main_800985B4 0x800985B4 : AT(0x000701B4) { FILL(0x00000000); build/asm/main_800985B4.s.o(.text); build/asm/main_800985B4.s.o(.rodata); build/asm/main_800985B4.s.o(.data); }
    .main_800985B4_bss (NOLOAD) : { build/asm/main_800985B4.s.o(.bss); }
    .main_80098D78 0x80098D78 : AT(0x00070978) { FILL(0x00000000); build/asm/main_80098D78.s.o(.text); build/asm/main_80098D78.s.o(.rodata); build/asm/main_80098D78.s.o(.data); }
    .main_80098D78_bss (NOLOAD) : { build/asm/main_80098D78.s.o(.bss); }
    .main_8009C1CC 0x8009C1CC : AT(0x00073DCC) { FILL(0x00000000); build/asm/main_8009C1CC.s.o(.text); build/asm/main_8009C1CC.s.o(.rodata); build/asm/main_8009C1CC.s.o(.data); }
    .main_8009C1CC_bss (NOLOAD) : { build/asm/main_8009C1CC.s.o(.bss); }
    .main_8009CC20 0x8009CC20 : AT(0x00074820) { FILL(0x00000000); build/asm/main_8009CC20.s.o(.text); build/asm/main_8009CC20.s.o(.rodata); build/asm/main_8009CC20.s.o(.data); }
    .main_8009CC20_bss (NOLOAD) : { build/asm/main_8009CC20.s.o(.bss); }
    .main_800A2794 0x800A2794 : AT(0x0007A394) { FILL(0x00000000); build/asm/main_800A2794.s.o(.text); build/asm/main_800A2794.s.o(.rodata); build/asm/main_800A2794.s.o(.data); }
    .main_800A2794_bss (NOLOAD) : { build/asm/main_800A2794.s.o(.bss); }
    .main_800A6500 0x800A6500 : AT(0x0007E100) { FILL(0x00000000); build/asm/main_800A6500.s.o(.text); build/asm/main_800A6500.s.o(.rodata); build/asm/main_800A6500.s.o(.data); }
    .main_800A6500_bss (NOLOAD) : { build/asm/main_800A6500.s.o(.bss); }
    .main_800A690C 0x800A690C : AT(0x0007E50C) { FILL(0x00000000); build/asm/main_800A690C.s.o(.text); build/asm/main_800A690C.s.o(.rodata); build/asm/main_800A690C.s.o(.data); }
    .main_800A690C_bss (NOLOAD) : { build/asm/main_800A690C.s.o(.bss); }
    .main_800A6E40 0x800A6E40 : AT(0x0007EA40) { FILL(0x00000000); build/asm/main_800A6E40.s.o(.text); build/asm/main_800A6E40.s.o(.rodata); build/asm/main_800A6E40.s.o(.data); }
    .main_800A6E40_bss (NOLOAD) : { build/asm/main_800A6E40.s.o(.bss); }
    .main_800A7750 0x800A7750 : AT(0x0007F350) { FILL(0x00000000); build/asm/main_800A7750.s.o(.text); build/asm/main_800A7750.s.o(.rodata); build/asm/main_800A7750.s.o(.data); }
    .main_800A7750_bss (NOLOAD) : { build/asm/main_800A7750.s.o(.bss); }
    .main_800A796C 0x800A796C : AT(0x0007F56C) { FILL(0x00000000); build/asm/main_800A796C.s.o(.text); build/asm/main_800A796C.s.o(.rodata); build/asm/main_800A796C.s.o(.data); }
    .main_800A796C_bss (NOLOAD) : { build/asm/main_800A796C.s.o(.bss); }
    .main_800A7DA4 0x800A7DA4 : AT(0x0007F9A4) { FILL(0x00000000); build/asm/main_800A7DA4.s.o(.text); build/asm/main_800A7DA4.s.o(.rodata); build/asm/main_800A7DA4.s.o(.data); }
    .main_800A7DA4_bss (NOLOAD) : { build/asm/main_800A7DA4.s.o(.bss); }
    .main_800A7FA8 0x800A7FA8 : AT(0x0007FBA8) { FILL(0x00000000); build/asm/main_800A7FA8.s.o(.text); build/asm/main_800A7FA8.s.o(.rodata); build/asm/main_800A7FA8.s.o(.data); }
    .main_800A7FA8_bss (NOLOAD) : { build/asm/main_800A7FA8.s.o(.bss); }
    .main_800A8678 0x800A8678 : AT(0x00080278) { FILL(0x00000000); build/asm/main_800A8678.s.o(.text); build/asm/main_800A8678.s.o(.rodata); build/asm/main_800A8678.s.o(.data); }
    .main_800A8678_bss (NOLOAD) : { build/asm/main_800A8678.s.o(.bss); }
    .main_800A970C 0x800A970C : AT(0x0008130C) { FILL(0x00000000); build/asm/main_800A970C.s.o(.text); build/asm/main_800A970C.s.o(.rodata); build/asm/main_800A970C.s.o(.data); }
    .main_800A970C_bss (NOLOAD) : { build/asm/main_800A970C.s.o(.bss); }
    .main_800A9E2C 0x800A9E2C : AT(0x00081A2C) { FILL(0x00000000); build/asm/main_800A9E2C.s.o(.text); build/asm/main_800A9E2C.s.o(.rodata); build/asm/main_800A9E2C.s.o(.data); }
    .main_800A9E2C_bss (NOLOAD) : { build/asm/main_800A9E2C.s.o(.bss); }
    .main_800AA850 0x800AA850 : AT(0x00082450) { FILL(0x00000000); build/asm/main_800AA850.s.o(.text); build/asm/main_800AA850.s.o(.rodata); build/asm/main_800AA850.s.o(.data); }
    .main_800AA850_bss (NOLOAD) : { build/asm/main_800AA850.s.o(.bss); }
    .main_800AB180 0x800AB180 : AT(0x00082D80) { FILL(0x00000000); build/asm/main_800AB180.s.o(.text); build/asm/main_800AB180.s.o(.rodata); build/asm/main_800AB180.s.o(.data); }
    .main_800AB180_bss (NOLOAD) : { build/asm/main_800AB180.s.o(.bss); }
    .main_800AB428 0x800AB428 : AT(0x00083028) { FILL(0x00000000); build/asm/main_800AB428.s.o(.text); build/asm/main_800AB428.s.o(.rodata); build/asm/main_800AB428.s.o(.data); }
    .main_800AB428_bss (NOLOAD) : { build/asm/main_800AB428.s.o(.bss); }
    .main_800AB490 0x800AB490 : AT(0x00083090) { FILL(0x00000000); build/asm/main_800AB490.s.o(.text); build/asm/main_800AB490.s.o(.rodata); build/asm/main_800AB490.s.o(.data); }
    .main_800AB490_bss (NOLOAD) : { build/asm/main_800AB490.s.o(.bss); }
    .main_800B1610 0x800B1610 : AT(0x00089210) { build/asm/data/main_800B1610.bin.o(.data); }
    .main_800B1E10 0x800B1E10 : AT(0x00089A10) { build/asm/data/main_800B1E10.bin.o(.data); }
    .main_800B2260 0x800B2260 : AT(0x00089E60) { FILL(0x00000000); build/asm/main_800B2260.s.o(.text); build/asm/main_800B2260.s.o(.rodata); build/asm/main_800B2260.s.o(.data); }
    .main_800B2260_bss (NOLOAD) : { build/asm/main_800B2260.s.o(.bss); }
    .main_800B22DC 0x800B22DC : AT(0x00089EDC) { build/asm/data/main_800B22DC.bin.o(.data); }
    .main_800B24E4 0x800B24E4 : AT(0x0008A0E4) { FILL(0x00000000); build/asm/main_800B24E4.s.o(.text); build/asm/main_800B24E4.s.o(.rodata); build/asm/main_800B24E4.s.o(.data); }
    .main_800B24E4_bss (NOLOAD) : { build/asm/main_800B24E4.s.o(.bss); }
    .main_800B29E0 0x800B29E0 : AT(0x0008A5E0) { FILL(0x00000000); build/asm/main_800B29E0.s.o(.text); build/asm/main_800B29E0.s.o(.rodata); build/asm/main_800B29E0.s.o(.data); }
    .main_800B29E0_bss (NOLOAD) : { build/asm/main_800B29E0.s.o(.bss); }
    .main_800C31A8 0x800C31A8 : AT(0x0009ADA8) { FILL(0x00000000); build/asm/main_800C31A8.s.o(.text); build/asm/main_800C31A8.s.o(.rodata); build/asm/main_800C31A8.s.o(.data); }
    .main_800C31A8_bss (NOLOAD) : { build/asm/main_800C31A8.s.o(.bss); }
    .main_800C5460 0x800C5460 : AT(0x0009D060) { FILL(0x00000000); build/asm/main_800C5460.s.o(.text); build/asm/main_800C5460.s.o(.rodata); build/asm/main_800C5460.s.o(.data); }
    .main_800C5460_bss (NOLOAD) : { build/asm/main_800C5460.s.o(.bss); }
    .main_800C7F3C 0x800C7F3C : AT(0x0009FB3C) { FILL(0x00000000); build/asm/main_800C7F3C.s.o(.text); build/asm/main_800C7F3C.s.o(.rodata); build/asm/main_800C7F3C.s.o(.data); }
    .main_800C7F3C_bss (NOLOAD) : { build/asm/main_800C7F3C.s.o(.bss); }
    .main_800C8890 0x800C8890 : AT(0x000A0490) { FILL(0x00000000); build/asm/main_800C8890.s.o(.text); build/asm/main_800C8890.s.o(.rodata); build/asm/main_800C8890.s.o(.data); }
    .main_800C8890_bss (NOLOAD) : { build/asm/main_800C8890.s.o(.bss); }
    .main_800C93A0 0x800C93A0 : AT(0x000A0FA0) { FILL(0x00000000); build/asm/main_800C93A0.s.o(.text); build/asm/main_800C93A0.s.o(.rodata); build/asm/main_800C93A0.s.o(.data); }
    .main_800C93A0_bss (NOLOAD) : { build/asm/main_800C93A0.s.o(.bss); }
    .main_800C9864 0x800C9864 : AT(0x000A1464) { FILL(0x00000000); build/asm/main_800C9864.s.o(.text); build/asm/main_800C9864.s.o(.rodata); build/asm/main_800C9864.s.o(.data); }
    .main_800C9864_bss (NOLOAD) : { build/asm/main_800C9864.s.o(.bss); }
    .main_800CAA08 0x800CAA08 : AT(0x000A2608) { FILL(0x00000000); build/asm/main_800CAA08.s.o(.text); build/asm/main_800CAA08.s.o(.rodata); build/asm/main_800CAA08.s.o(.data); }
    .main_800CAA08_bss (NOLOAD) : { build/asm/main_800CAA08.s.o(.bss); }
    .main_800CBE94 0x800CBE94 : AT(0x000A3A94) { FILL(0x00000000); build/asm/main_800CBE94.s.o(.text); build/asm/main_800CBE94.s.o(.rodata); build/asm/main_800CBE94.s.o(.data); }
    .main_800CBE94_bss (NOLOAD) : { build/asm/main_800CBE94.s.o(.bss); }
    .main_800CDB44 0x800CDB44 : AT(0x000A5744) { FILL(0x00000000); build/asm/main_800CDB44.s.o(.text); build/asm/main_800CDB44.s.o(.rodata); build/asm/main_800CDB44.s.o(.data); }
    .main_800CDB44_bss (NOLOAD) : { build/asm/main_800CDB44.s.o(.bss); }
    .main_800D5A98 0x800D5A98 : AT(0x000AD698) { FILL(0x00000000); build/asm/main_800D5A98.s.o(.text); build/asm/main_800D5A98.s.o(.rodata); build/asm/main_800D5A98.s.o(.data); }
    .main_800D5A98_bss (NOLOAD) : { build/asm/main_800D5A98.s.o(.bss); }
    .main_800D5D28 0x800D5D28 : AT(0x000AD928) { FILL(0x00000000); build/asm/main_800D5D28.s.o(.text); build/asm/main_800D5D28.s.o(.rodata); build/asm/main_800D5D28.s.o(.data); }
    .main_800D5D28_bss (NOLOAD) : { build/asm/main_800D5D28.s.o(.bss); }
    .main_800D6614 0x800D6614 : AT(0x000AE214) { build/asm/data/main_800D6614.bin.o(.data); }
    .main_800D91B8 0x800D91B8 : AT(0x000B0DB8) { FILL(0x00000000); build/asm/main_800D91B8.s.o(.text); build/asm/main_800D91B8.s.o(.rodata); build/asm/main_800D91B8.s.o(.data); }
    .main_800D91B8_bss (NOLOAD) : { build/asm/main_800D91B8.s.o(.bss); }
    .main_800D972C 0x800D972C : AT(0x000B132C) { FILL(0x00000000); build/asm/main_800D972C.s.o(.text); build/asm/main_800D972C.s.o(.rodata); build/asm/main_800D972C.s.o(.data); }
    .main_800D972C_bss (NOLOAD) : { build/asm/main_800D972C.s.o(.bss); }
    .main_800D99D0 0x800D99D0 : AT(0x000B15D0) { FILL(0x00000000); build/asm/main_800D99D0.s.o(.text); build/asm/main_800D99D0.s.o(.rodata); build/asm/main_800D99D0.s.o(.data); }
    .main_800D99D0_bss (NOLOAD) : { build/asm/main_800D99D0.s.o(.bss); }
    .main_800DDF38 0x800DDF38 : AT(0x000B5B38) { build/asm/data/main_800DDF38.bin.o(.data); }
    .main_800E3098 0x800E3098 : AT(0x000BAC98) { build/asm/data/main_800E3098.bin.o(.data); }
    .main_800E3F94 0x800E3F94 : AT(0x000BBB94) { build/asm/data/main_800E3F94.bin.o(.data); }
    .main_800E62C8 0x800E62C8 : AT(0x000BDEC8) { build/asm/data/main_800E62C8.bin.o(.data); }
    .main_800E7318 0x800E7318 : AT(0x000BEF18) { build/asm/data/main_800E7318.bin.o(.data); }
    .main_800E7770 0x800E7770 : AT(0x000BF370) { build/asm/data/main_800E7770.bin.o(.data); }
    .main_800E836C 0x800E836C : AT(0x000BFF6C) { build/asm/data/main_800E836C.bin.o(.data); }
    .main_800E9650 0x800E9650 : AT(0x000C1250) { build/asm/data/main_800E9650.bin.o(.data); }
    .main_800EB2A0 0x800EB2A0 : AT(0x000C2EA0) { build/asm/data/main_800EB2A0.bin.o(.data); }
    .main_800EB54C 0x800EB54C : AT(0x000C314C) { build/asm/data/main_800EB54C.bin.o(.data); }
    .main_800EB5CC 0x800EB5CC : AT(0x000C31CC) { FILL(0x00000000); build/asm/main_800EB5CC.s.o(.text); build/asm/main_800EB5CC.s.o(.rodata); build/asm/main_800EB5CC.s.o(.data); }
    .main_800EB5CC_bss (NOLOAD) : { build/asm/main_800EB5CC.s.o(.bss); }
    .main_800EE9AC 0x800EE9AC : AT(0x000C65AC) { build/asm/data/main_800EE9AC.bin.o(.data); }
    .main_800EF4D4 0x800EF4D4 : AT(0x000C70D4) { build/asm/data/main_800EF4D4.bin.o(.data); }
    .main_800EF780 0x800EF780 : AT(0x000C7380) { build/asm/data/main_800EF780.bin.o(.data); }
    .main_800F04F0 0x800F04F0 : AT(0x000C80F0) { build/asm/data/main_800F04F0.bin.o(.data); }
    .main_800F0E34 0x800F0E34 : AT(0x000C8A34) { build/asm/data/main_800F0E34.bin.o(.data); }
    .main_800F21BC 0x800F21BC : AT(0x000C9DBC) { build/asm/data/main_800F21BC.bin.o(.data); }
    .main_800F2E90 0x800F2E90 : AT(0x000CAA90) { build/asm/data/main_800F2E90.bin.o(.data); }
    .main_800F3734 0x800F3734 : AT(0x000CB334) { build/asm/data/main_800F3734.bin.o(.data); }
    .main_800F3C0C 0x800F3C0C : AT(0x000CB80C) { FILL(0x00000000); build/asm/main_800F3C0C.s.o(.text); build/asm/main_800F3C0C.s.o(.rodata); build/asm/main_800F3C0C.s.o(.data); }
    .main_800F3C0C_bss (NOLOAD) : { build/asm/main_800F3C0C.s.o(.bss); }
    .main_800F4AA0 0x800F4AA0 : AT(0x000CC6A0) { build/asm/data/main_800F4AA0.bin.o(.data); }
    .main_800F749C 0x800F749C : AT(0x000CF09C) { build/asm/data/main_800F749C.bin.o(.data); }
    .main_800F8AA0 0x800F8AA0 : AT(0x000D06A0) { build/asm/data/main_800F8AA0.bin.o(.data); }
    .main_800F8E50 0x800F8E50 : AT(0x000D0A50) { build/asm/data/main_800F8E50.bin.o(.data); }
    .main_800F9B40 0x800F9B40 : AT(0x000D1740) { build/asm/data/main_800F9B40.bin.o(.data); }
    .main_800FB9F4 0x800FB9F4 : AT(0x000D35F4) { build/asm/data/main_800FB9F4.bin.o(.data); }
    .main_801008C4 0x801008C4 : AT(0x000D84C4) { build/asm/data/main_801008C4.bin.o(.data); }
    .main_801039B4 0x801039B4 : AT(0x000DB5B4) { build/asm/data/main_801039B4.bin.o(.data); }
    .main_801041B8 0x801041B8 : AT(0x000DBDB8) { build/asm/data/main_801041B8.bin.o(.data); }
    .main_8011E4A0 0x8011E4A0 : AT(0x000F60A0) { FILL(0x00000000); build/asm/main_8011E4A0.s.o(.text); build/asm/main_8011E4A0.s.o(.rodata); build/asm/main_8011E4A0.s.o(.data); }
    .main_8011E4A0_bss (NOLOAD) : { build/asm/main_8011E4A0.s.o(.bss); }
    .main_8011E4D0 0x8011E4D0 : AT(0x000F60D0) { build/asm/data/main_8011E4D0.bin.o(.data); }
    .assets 0x80429400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
