SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80001088 0x80001088 : AT(0x00001C88) { build/asm/data/main_80001088.bin.o(.data); }
    .main_80001FB4 0x80001FB4 : AT(0x00002BB4) { FILL(0x00000000); build/asm/main_80001FB4.s.o(.text); build/asm/main_80001FB4.s.o(.rodata); build/asm/main_80001FB4.s.o(.data); }
    .main_80001FB4_bss (NOLOAD) : { build/asm/main_80001FB4.s.o(.bss); }
    .main_80001FD8 0x80001FD8 : AT(0x00002BD8) { build/asm/data/main_80001FD8.bin.o(.data); }
    .main_80004270 0x80004270 : AT(0x00004E70) { FILL(0x00000000); build/asm/main_80004270.s.o(.text); build/asm/main_80004270.s.o(.rodata); build/asm/main_80004270.s.o(.data); }
    .main_80004270_bss (NOLOAD) : { build/asm/main_80004270.s.o(.bss); }
    .main_800254B0 0x800254B0 : AT(0x000260B0) { FILL(0x00000000); build/asm/main_800254B0.s.o(.text); build/asm/main_800254B0.s.o(.rodata); build/asm/main_800254B0.s.o(.data); }
    .main_800254B0_bss (NOLOAD) : { build/asm/main_800254B0.s.o(.bss); }
    .main_80025F50 0x80025F50 : AT(0x00026B50) { FILL(0x00000000); build/asm/main_80025F50.s.o(.text); build/asm/main_80025F50.s.o(.rodata); build/asm/main_80025F50.s.o(.data); }
    .main_80025F50_bss (NOLOAD) : { build/asm/main_80025F50.s.o(.bss); }
    .main_8002B5A0 0x8002B5A0 : AT(0x0002C1A0) { FILL(0x00000000); build/asm/main_8002B5A0.s.o(.text); build/asm/main_8002B5A0.s.o(.rodata); build/asm/main_8002B5A0.s.o(.data); }
    .main_8002B5A0_bss (NOLOAD) : { build/asm/main_8002B5A0.s.o(.bss); }
    .main_8002EBB0 0x8002EBB0 : AT(0x0002F7B0) { FILL(0x00000000); build/asm/main_8002EBB0.s.o(.text); build/asm/main_8002EBB0.s.o(.rodata); build/asm/main_8002EBB0.s.o(.data); }
    .main_8002EBB0_bss (NOLOAD) : { build/asm/main_8002EBB0.s.o(.bss); }
    .main_800332E0 0x800332E0 : AT(0x00033EE0) { FILL(0x00000000); build/asm/main_800332E0.s.o(.text); build/asm/main_800332E0.s.o(.rodata); build/asm/main_800332E0.s.o(.data); }
    .main_800332E0_bss (NOLOAD) : { build/asm/main_800332E0.s.o(.bss); }
    .main_80033AF0 0x80033AF0 : AT(0x000346F0) { FILL(0x00000000); build/asm/main_80033AF0.s.o(.text); build/asm/main_80033AF0.s.o(.rodata); build/asm/main_80033AF0.s.o(.data); }
    .main_80033AF0_bss (NOLOAD) : { build/asm/main_80033AF0.s.o(.bss); }
    .main_80045AB0 0x80045AB0 : AT(0x000466B0) { build/asm/data/main_80045AB0.bin.o(.data); }
    .main_80048BE4 0x80048BE4 : AT(0x000497E4) { FILL(0x00000000); build/asm/main_80048BE4.s.o(.text); build/asm/main_80048BE4.s.o(.rodata); build/asm/main_80048BE4.s.o(.data); }
    .main_80048BE4_bss (NOLOAD) : { build/asm/main_80048BE4.s.o(.bss); }
    .main_80048EA0 0x80048EA0 : AT(0x00049AA0) { build/asm/data/main_80048EA0.bin.o(.data); }
    .main_80049104 0x80049104 : AT(0x00049D04) { FILL(0x00000000); build/asm/main_80049104.s.o(.text); build/asm/main_80049104.s.o(.rodata); build/asm/main_80049104.s.o(.data); }
    .main_80049104_bss (NOLOAD) : { build/asm/main_80049104.s.o(.bss); }
    .main_80049128 0x80049128 : AT(0x00049D28) { build/asm/data/main_80049128.bin.o(.data); }
    .main_80049394 0x80049394 : AT(0x00049F94) { FILL(0x00000000); build/asm/main_80049394.s.o(.text); build/asm/main_80049394.s.o(.rodata); build/asm/main_80049394.s.o(.data); }
    .main_80049394_bss (NOLOAD) : { build/asm/main_80049394.s.o(.bss); }
    .main_800493B0 0x800493B0 : AT(0x00049FB0) { build/asm/data/main_800493B0.bin.o(.data); }
    .main_800498B4 0x800498B4 : AT(0x0004A4B4) { FILL(0x00000000); build/asm/main_800498B4.s.o(.text); build/asm/main_800498B4.s.o(.rodata); build/asm/main_800498B4.s.o(.data); }
    .main_800498B4_bss (NOLOAD) : { build/asm/main_800498B4.s.o(.bss); }
    .main_800676FC 0x800676FC : AT(0x000682FC) { build/asm/data/main_800676FC.bin.o(.data); }
    .main_8008666C 0x8008666C : AT(0x0008726C) { FILL(0x00000000); build/asm/main_8008666C.s.o(.text); build/asm/main_8008666C.s.o(.rodata); build/asm/main_8008666C.s.o(.data); }
    .main_8008666C_bss (NOLOAD) : { build/asm/main_8008666C.s.o(.bss); }
    .main_8008668C 0x8008668C : AT(0x0008728C) { build/asm/data/main_8008668C.bin.o(.data); }
    .main_800866E8 0x800866E8 : AT(0x000872E8) { FILL(0x00000000); build/asm/main_800866E8.s.o(.text); build/asm/main_800866E8.s.o(.rodata); build/asm/main_800866E8.s.o(.data); }
    .main_800866E8_bss (NOLOAD) : { build/asm/main_800866E8.s.o(.bss); }
    .main_80086788 0x80086788 : AT(0x00087388) { build/asm/data/main_80086788.bin.o(.data); }
    .main_800867BC 0x800867BC : AT(0x000873BC) { FILL(0x00000000); build/asm/main_800867BC.s.o(.text); build/asm/main_800867BC.s.o(.rodata); build/asm/main_800867BC.s.o(.data); }
    .main_800867BC_bss (NOLOAD) : { build/asm/main_800867BC.s.o(.bss); }
    .main_80086924 0x80086924 : AT(0x00087524) { build/asm/data/main_80086924.bin.o(.data); }
    .main_8008AD4C 0x8008AD4C : AT(0x0008B94C) { FILL(0x00000000); build/asm/main_8008AD4C.s.o(.text); build/asm/main_8008AD4C.s.o(.rodata); build/asm/main_8008AD4C.s.o(.data); }
    .main_8008AD4C_bss (NOLOAD) : { build/asm/main_8008AD4C.s.o(.bss); }
    .main_8008B094 0x8008B094 : AT(0x0008BC94) { build/asm/data/main_8008B094.bin.o(.data); }
    .main_8008BF50 0x8008BF50 : AT(0x0008CB50) { FILL(0x00000000); build/asm/main_8008BF50.s.o(.text); build/asm/main_8008BF50.s.o(.rodata); build/asm/main_8008BF50.s.o(.data); }
    .main_8008BF50_bss (NOLOAD) : { build/asm/main_8008BF50.s.o(.bss); }
    .main_80090480 0x80090480 : AT(0x00091080) { build/asm/data/main_80090480.bin.o(.data); }
    .main_800932A8 0x800932A8 : AT(0x00093EA8) { FILL(0x00000000); build/asm/main_800932A8.s.o(.text); build/asm/main_800932A8.s.o(.rodata); build/asm/main_800932A8.s.o(.data); }
    .main_800932A8_bss (NOLOAD) : { build/asm/main_800932A8.s.o(.bss); }
    .main_8009A6E8 0x8009A6E8 : AT(0x0009B2E8) { build/asm/data/main_8009A6E8.bin.o(.data); }
    .main_8009AF6C 0x8009AF6C : AT(0x0009BB6C) { FILL(0x00000000); build/asm/main_8009AF6C.s.o(.text); build/asm/main_8009AF6C.s.o(.rodata); build/asm/main_8009AF6C.s.o(.data); }
    .main_8009AF6C_bss (NOLOAD) : { build/asm/main_8009AF6C.s.o(.bss); }
    .main_8009B2EC 0x8009B2EC : AT(0x0009BEEC) { build/asm/data/main_8009B2EC.bin.o(.data); }
    .main_8009B5F0 0x8009B5F0 : AT(0x0009C1F0) { FILL(0x00000000); build/asm/main_8009B5F0.s.o(.text); build/asm/main_8009B5F0.s.o(.rodata); build/asm/main_8009B5F0.s.o(.data); }
    .main_8009B5F0_bss (NOLOAD) : { build/asm/main_8009B5F0.s.o(.bss); }
    .main_8009B98C 0x8009B98C : AT(0x0009C58C) { build/asm/data/main_8009B98C.bin.o(.data); }
    .main_8009BAD8 0x8009BAD8 : AT(0x0009C6D8) { FILL(0x00000000); build/asm/main_8009BAD8.s.o(.text); build/asm/main_8009BAD8.s.o(.rodata); build/asm/main_8009BAD8.s.o(.data); }
    .main_8009BAD8_bss (NOLOAD) : { build/asm/main_8009BAD8.s.o(.bss); }
    .main_8009BB3C 0x8009BB3C : AT(0x0009C73C) { build/asm/data/main_8009BB3C.bin.o(.data); }
    .main_8009BB90 0x8009BB90 : AT(0x0009C790) { FILL(0x00000000); build/asm/main_8009BB90.s.o(.text); build/asm/main_8009BB90.s.o(.rodata); build/asm/main_8009BB90.s.o(.data); }
    .main_8009BB90_bss (NOLOAD) : { build/asm/main_8009BB90.s.o(.bss); }
    .main_8009BE18 0x8009BE18 : AT(0x0009CA18) { build/asm/data/main_8009BE18.bin.o(.data); }
    .main_8009C364 0x8009C364 : AT(0x0009CF64) { FILL(0x00000000); build/asm/main_8009C364.s.o(.text); build/asm/main_8009C364.s.o(.rodata); build/asm/main_8009C364.s.o(.data); }
    .main_8009C364_bss (NOLOAD) : { build/asm/main_8009C364.s.o(.bss); }
    .main_8009C698 0x8009C698 : AT(0x0009D298) { build/asm/data/main_8009C698.bin.o(.data); }
    .main_8009D4E8 0x8009D4E8 : AT(0x0009E0E8) { FILL(0x00000000); build/asm/main_8009D4E8.s.o(.text); build/asm/main_8009D4E8.s.o(.rodata); build/asm/main_8009D4E8.s.o(.data); }
    .main_8009D4E8_bss (NOLOAD) : { build/asm/main_8009D4E8.s.o(.bss); }
    .main_8009D4F4 0x8009D4F4 : AT(0x0009E0F4) { build/asm/data/main_8009D4F4.bin.o(.data); }
    .main_8009D830 0x8009D830 : AT(0x0009E430) { FILL(0x00000000); build/asm/main_8009D830.s.o(.text); build/asm/main_8009D830.s.o(.rodata); build/asm/main_8009D830.s.o(.data); }
    .main_8009D830_bss (NOLOAD) : { build/asm/main_8009D830.s.o(.bss); }
    .main_8009D85C 0x8009D85C : AT(0x0009E45C) { build/asm/data/main_8009D85C.bin.o(.data); }
    .main_8009D914 0x8009D914 : AT(0x0009E514) { FILL(0x00000000); build/asm/main_8009D914.s.o(.text); build/asm/main_8009D914.s.o(.rodata); build/asm/main_8009D914.s.o(.data); }
    .main_8009D914_bss (NOLOAD) : { build/asm/main_8009D914.s.o(.bss); }
    .main_8009D9A4 0x8009D9A4 : AT(0x0009E5A4) { build/asm/data/main_8009D9A4.bin.o(.data); }
    .main_8009DA24 0x8009DA24 : AT(0x0009E624) { FILL(0x00000000); build/asm/main_8009DA24.s.o(.text); build/asm/main_8009DA24.s.o(.rodata); build/asm/main_8009DA24.s.o(.data); }
    .main_8009DA24_bss (NOLOAD) : { build/asm/main_8009DA24.s.o(.bss); }
    .main_8009DA5C 0x8009DA5C : AT(0x0009E65C) { build/asm/data/main_8009DA5C.bin.o(.data); }
    .main_8009DDF8 0x8009DDF8 : AT(0x0009E9F8) { FILL(0x00000000); build/asm/main_8009DDF8.s.o(.text); build/asm/main_8009DDF8.s.o(.rodata); build/asm/main_8009DDF8.s.o(.data); }
    .main_8009DDF8_bss (NOLOAD) : { build/asm/main_8009DDF8.s.o(.bss); }
    .main_8009DEC4 0x8009DEC4 : AT(0x0009EAC4) { build/asm/data/main_8009DEC4.bin.o(.data); }
    .main_8009DF8C 0x8009DF8C : AT(0x0009EB8C) { FILL(0x00000000); build/asm/main_8009DF8C.s.o(.text); build/asm/main_8009DF8C.s.o(.rodata); build/asm/main_8009DF8C.s.o(.data); }
    .main_8009DF8C_bss (NOLOAD) : { build/asm/main_8009DF8C.s.o(.bss); }
    .main_8009DF9C 0x8009DF9C : AT(0x0009EB9C) { build/asm/data/main_8009DF9C.bin.o(.data); }
    .main_8009E238 0x8009E238 : AT(0x0009EE38) { FILL(0x00000000); build/asm/main_8009E238.s.o(.text); build/asm/main_8009E238.s.o(.rodata); build/asm/main_8009E238.s.o(.data); }
    .main_8009E238_bss (NOLOAD) : { build/asm/main_8009E238.s.o(.bss); }
    .main_8009E4C0 0x8009E4C0 : AT(0x0009F0C0) { build/asm/data/main_8009E4C0.bin.o(.data); }
    .main_8009EA34 0x8009EA34 : AT(0x0009F634) { FILL(0x00000000); build/asm/main_8009EA34.s.o(.text); build/asm/main_8009EA34.s.o(.rodata); build/asm/main_8009EA34.s.o(.data); }
    .main_8009EA34_bss (NOLOAD) : { build/asm/main_8009EA34.s.o(.bss); }
    .main_8009EA6C 0x8009EA6C : AT(0x0009F66C) { build/asm/data/main_8009EA6C.bin.o(.data); }
    .main_8009FBA4 0x8009FBA4 : AT(0x000A07A4) { FILL(0x00000000); build/asm/main_8009FBA4.s.o(.text); build/asm/main_8009FBA4.s.o(.rodata); build/asm/main_8009FBA4.s.o(.data); }
    .main_8009FBA4_bss (NOLOAD) : { build/asm/main_8009FBA4.s.o(.bss); }
    .main_8009FBBC 0x8009FBBC : AT(0x000A07BC) { build/asm/data/main_8009FBBC.bin.o(.data); }
    .main_800A0420 0x800A0420 : AT(0x000A1020) { FILL(0x00000000); build/asm/main_800A0420.s.o(.text); build/asm/main_800A0420.s.o(.rodata); build/asm/main_800A0420.s.o(.data); }
    .main_800A0420_bss (NOLOAD) : { build/asm/main_800A0420.s.o(.bss); }
    .main_800A0514 0x800A0514 : AT(0x000A1114) { build/asm/data/main_800A0514.bin.o(.data); }
    .main_800A249C 0x800A249C : AT(0x000A309C) { FILL(0x00000000); build/asm/main_800A249C.s.o(.text); build/asm/main_800A249C.s.o(.rodata); build/asm/main_800A249C.s.o(.data); }
    .main_800A249C_bss (NOLOAD) : { build/asm/main_800A249C.s.o(.bss); }
    .main_800A25B4 0x800A25B4 : AT(0x000A31B4) { build/asm/data/main_800A25B4.bin.o(.data); }
    .main_800A276C 0x800A276C : AT(0x000A336C) { FILL(0x00000000); build/asm/main_800A276C.s.o(.text); build/asm/main_800A276C.s.o(.rodata); build/asm/main_800A276C.s.o(.data); }
    .main_800A276C_bss (NOLOAD) : { build/asm/main_800A276C.s.o(.bss); }
    .main_800A277C 0x800A277C : AT(0x000A337C) { build/asm/data/main_800A277C.bin.o(.data); }
    .main_800A29CC 0x800A29CC : AT(0x000A35CC) { FILL(0x00000000); build/asm/main_800A29CC.s.o(.text); build/asm/main_800A29CC.s.o(.rodata); build/asm/main_800A29CC.s.o(.data); }
    .main_800A29CC_bss (NOLOAD) : { build/asm/main_800A29CC.s.o(.bss); }
    .main_800A2BF0 0x800A2BF0 : AT(0x000A37F0) { build/asm/data/main_800A2BF0.bin.o(.data); }
    .main_800A3154 0x800A3154 : AT(0x000A3D54) { FILL(0x00000000); build/asm/main_800A3154.s.o(.text); build/asm/main_800A3154.s.o(.rodata); build/asm/main_800A3154.s.o(.data); }
    .main_800A3154_bss (NOLOAD) : { build/asm/main_800A3154.s.o(.bss); }
    .main_800A3264 0x800A3264 : AT(0x000A3E64) { build/asm/data/main_800A3264.bin.o(.data); }
    .main_800A35FC 0x800A35FC : AT(0x000A41FC) { FILL(0x00000000); build/asm/main_800A35FC.s.o(.text); build/asm/main_800A35FC.s.o(.rodata); build/asm/main_800A35FC.s.o(.data); }
    .main_800A35FC_bss (NOLOAD) : { build/asm/main_800A35FC.s.o(.bss); }
    .main_800A3614 0x800A3614 : AT(0x000A4214) { build/asm/data/main_800A3614.bin.o(.data); }
    .main_800A3724 0x800A3724 : AT(0x000A4324) { FILL(0x00000000); build/asm/main_800A3724.s.o(.text); build/asm/main_800A3724.s.o(.rodata); build/asm/main_800A3724.s.o(.data); }
    .main_800A3724_bss (NOLOAD) : { build/asm/main_800A3724.s.o(.bss); }
    .main_800A380C 0x800A380C : AT(0x000A440C) { build/asm/data/main_800A380C.bin.o(.data); }
    .main_800A41CC 0x800A41CC : AT(0x000A4DCC) { FILL(0x00000000); build/asm/main_800A41CC.s.o(.text); build/asm/main_800A41CC.s.o(.rodata); build/asm/main_800A41CC.s.o(.data); }
    .main_800A41CC_bss (NOLOAD) : { build/asm/main_800A41CC.s.o(.bss); }
    .main_800A421C 0x800A421C : AT(0x000A4E1C) { build/asm/data/main_800A421C.bin.o(.data); }
    .main_800A4394 0x800A4394 : AT(0x000A4F94) { FILL(0x00000000); build/asm/main_800A4394.s.o(.text); build/asm/main_800A4394.s.o(.rodata); build/asm/main_800A4394.s.o(.data); }
    .main_800A4394_bss (NOLOAD) : { build/asm/main_800A4394.s.o(.bss); }
    .main_800A439C 0x800A439C : AT(0x000A4F9C) { build/asm/data/main_800A439C.bin.o(.data); }
    .main_800A4630 0x800A4630 : AT(0x000A5230) { FILL(0x00000000); build/asm/main_800A4630.s.o(.text); build/asm/main_800A4630.s.o(.rodata); build/asm/main_800A4630.s.o(.data); }
    .main_800A4630_bss (NOLOAD) : { build/asm/main_800A4630.s.o(.bss); }
    .main_800A4784 0x800A4784 : AT(0x000A5384) { build/asm/data/main_800A4784.bin.o(.data); }
    .main_800A4B5C 0x800A4B5C : AT(0x000A575C) { FILL(0x00000000); build/asm/main_800A4B5C.s.o(.text); build/asm/main_800A4B5C.s.o(.rodata); build/asm/main_800A4B5C.s.o(.data); }
    .main_800A4B5C_bss (NOLOAD) : { build/asm/main_800A4B5C.s.o(.bss); }
    .main_800A4B7C 0x800A4B7C : AT(0x000A577C) { build/asm/data/main_800A4B7C.bin.o(.data); }
    .main_800A50EC 0x800A50EC : AT(0x000A5CEC) { FILL(0x00000000); build/asm/main_800A50EC.s.o(.text); build/asm/main_800A50EC.s.o(.rodata); build/asm/main_800A50EC.s.o(.data); }
    .main_800A50EC_bss (NOLOAD) : { build/asm/main_800A50EC.s.o(.bss); }
    .main_800A5138 0x800A5138 : AT(0x000A5D38) { build/asm/data/main_800A5138.bin.o(.data); }
    .main_800A5DBC 0x800A5DBC : AT(0x000A69BC) { FILL(0x00000000); build/asm/main_800A5DBC.s.o(.text); build/asm/main_800A5DBC.s.o(.rodata); build/asm/main_800A5DBC.s.o(.data); }
    .main_800A5DBC_bss (NOLOAD) : { build/asm/main_800A5DBC.s.o(.bss); }
    .main_800A5FDC 0x800A5FDC : AT(0x000A6BDC) { build/asm/data/main_800A5FDC.bin.o(.data); }
    .main_800A611C 0x800A611C : AT(0x000A6D1C) { FILL(0x00000000); build/asm/main_800A611C.s.o(.text); build/asm/main_800A611C.s.o(.rodata); build/asm/main_800A611C.s.o(.data); }
    .main_800A611C_bss (NOLOAD) : { build/asm/main_800A611C.s.o(.bss); }
    .main_800A6134 0x800A6134 : AT(0x000A6D34) { build/asm/data/main_800A6134.bin.o(.data); }
    .main_800A6E5C 0x800A6E5C : AT(0x000A7A5C) { FILL(0x00000000); build/asm/main_800A6E5C.s.o(.text); build/asm/main_800A6E5C.s.o(.rodata); build/asm/main_800A6E5C.s.o(.data); }
    .main_800A6E5C_bss (NOLOAD) : { build/asm/main_800A6E5C.s.o(.bss); }
    .main_800A6EC4 0x800A6EC4 : AT(0x000A7AC4) { build/asm/data/main_800A6EC4.bin.o(.data); }
    .main_800A7244 0x800A7244 : AT(0x000A7E44) { FILL(0x00000000); build/asm/main_800A7244.s.o(.text); build/asm/main_800A7244.s.o(.rodata); build/asm/main_800A7244.s.o(.data); }
    .main_800A7244_bss (NOLOAD) : { build/asm/main_800A7244.s.o(.bss); }
    .main_800A73A4 0x800A73A4 : AT(0x000A7FA4) { build/asm/data/main_800A73A4.bin.o(.data); }
    .main_800A7B5C 0x800A7B5C : AT(0x000A875C) { FILL(0x00000000); build/asm/main_800A7B5C.s.o(.text); build/asm/main_800A7B5C.s.o(.rodata); build/asm/main_800A7B5C.s.o(.data); }
    .main_800A7B5C_bss (NOLOAD) : { build/asm/main_800A7B5C.s.o(.bss); }
    .main_800A7B7C 0x800A7B7C : AT(0x000A877C) { build/asm/data/main_800A7B7C.bin.o(.data); }
    .main_800A7CBC 0x800A7CBC : AT(0x000A88BC) { FILL(0x00000000); build/asm/main_800A7CBC.s.o(.text); build/asm/main_800A7CBC.s.o(.rodata); build/asm/main_800A7CBC.s.o(.data); }
    .main_800A7CBC_bss (NOLOAD) : { build/asm/main_800A7CBC.s.o(.bss); }
    .main_800A7DD4 0x800A7DD4 : AT(0x000A89D4) { build/asm/data/main_800A7DD4.bin.o(.data); }
    .main_800A7FCC 0x800A7FCC : AT(0x000A8BCC) { FILL(0x00000000); build/asm/main_800A7FCC.s.o(.text); build/asm/main_800A7FCC.s.o(.rodata); build/asm/main_800A7FCC.s.o(.data); }
    .main_800A7FCC_bss (NOLOAD) : { build/asm/main_800A7FCC.s.o(.bss); }
    .main_800A8300 0x800A8300 : AT(0x000A8F00) { build/asm/data/main_800A8300.bin.o(.data); }
    .main_800A8DD4 0x800A8DD4 : AT(0x000A99D4) { FILL(0x00000000); build/asm/main_800A8DD4.s.o(.text); build/asm/main_800A8DD4.s.o(.rodata); build/asm/main_800A8DD4.s.o(.data); }
    .main_800A8DD4_bss (NOLOAD) : { build/asm/main_800A8DD4.s.o(.bss); }
    .main_800A907C 0x800A907C : AT(0x000A9C7C) { build/asm/data/main_800A907C.bin.o(.data); }
    .main_800A92DC 0x800A92DC : AT(0x000A9EDC) { FILL(0x00000000); build/asm/main_800A92DC.s.o(.text); build/asm/main_800A92DC.s.o(.rodata); build/asm/main_800A92DC.s.o(.data); }
    .main_800A92DC_bss (NOLOAD) : { build/asm/main_800A92DC.s.o(.bss); }
    .main_800A932C 0x800A932C : AT(0x000A9F2C) { build/asm/data/main_800A932C.bin.o(.data); }
    .main_800A95DC 0x800A95DC : AT(0x000AA1DC) { FILL(0x00000000); build/asm/main_800A95DC.s.o(.text); build/asm/main_800A95DC.s.o(.rodata); build/asm/main_800A95DC.s.o(.data); }
    .main_800A95DC_bss (NOLOAD) : { build/asm/main_800A95DC.s.o(.bss); }
    .main_800A9C34 0x800A9C34 : AT(0x000AA834) { build/asm/data/main_800A9C34.bin.o(.data); }
    .main_800A9E2C 0x800A9E2C : AT(0x000AAA2C) { FILL(0x00000000); build/asm/main_800A9E2C.s.o(.text); build/asm/main_800A9E2C.s.o(.rodata); build/asm/main_800A9E2C.s.o(.data); }
    .main_800A9E2C_bss (NOLOAD) : { build/asm/main_800A9E2C.s.o(.bss); }
    .main_800A9EF8 0x800A9EF8 : AT(0x000AAAF8) { build/asm/data/main_800A9EF8.bin.o(.data); }
    .main_800AA19C 0x800AA19C : AT(0x000AAD9C) { FILL(0x00000000); build/asm/main_800AA19C.s.o(.text); build/asm/main_800AA19C.s.o(.rodata); build/asm/main_800AA19C.s.o(.data); }
    .main_800AA19C_bss (NOLOAD) : { build/asm/main_800AA19C.s.o(.bss); }
    .main_800AA7AC 0x800AA7AC : AT(0x000AB3AC) { build/asm/data/main_800AA7AC.bin.o(.data); }
    .main_800AA85C 0x800AA85C : AT(0x000AB45C) { FILL(0x00000000); build/asm/main_800AA85C.s.o(.text); build/asm/main_800AA85C.s.o(.rodata); build/asm/main_800AA85C.s.o(.data); }
    .main_800AA85C_bss (NOLOAD) : { build/asm/main_800AA85C.s.o(.bss); }
    .main_800AAA74 0x800AAA74 : AT(0x000AB674) { build/asm/data/main_800AAA74.bin.o(.data); }
    .main_800AAC54 0x800AAC54 : AT(0x000AB854) { FILL(0x00000000); build/asm/main_800AAC54.s.o(.text); build/asm/main_800AAC54.s.o(.rodata); build/asm/main_800AAC54.s.o(.data); }
    .main_800AAC54_bss (NOLOAD) : { build/asm/main_800AAC54.s.o(.bss); }
    .main_800AB1DC 0x800AB1DC : AT(0x000ABDDC) { build/asm/data/main_800AB1DC.bin.o(.data); }
    .main_800AB81C 0x800AB81C : AT(0x000AC41C) { FILL(0x00000000); build/asm/main_800AB81C.s.o(.text); build/asm/main_800AB81C.s.o(.rodata); build/asm/main_800AB81C.s.o(.data); }
    .main_800AB81C_bss (NOLOAD) : { build/asm/main_800AB81C.s.o(.bss); }
    .main_800ABF04 0x800ABF04 : AT(0x000ACB04) { build/asm/data/main_800ABF04.bin.o(.data); }
    .main_800AC06C 0x800AC06C : AT(0x000ACC6C) { FILL(0x00000000); build/asm/main_800AC06C.s.o(.text); build/asm/main_800AC06C.s.o(.rodata); build/asm/main_800AC06C.s.o(.data); }
    .main_800AC06C_bss (NOLOAD) : { build/asm/main_800AC06C.s.o(.bss); }
    .main_800AC0AC 0x800AC0AC : AT(0x000ACCAC) { build/asm/data/main_800AC0AC.bin.o(.data); }
    .main_800AC1A4 0x800AC1A4 : AT(0x000ACDA4) { FILL(0x00000000); build/asm/main_800AC1A4.s.o(.text); build/asm/main_800AC1A4.s.o(.rodata); build/asm/main_800AC1A4.s.o(.data); }
    .main_800AC1A4_bss (NOLOAD) : { build/asm/main_800AC1A4.s.o(.bss); }
    .main_800AC784 0x800AC784 : AT(0x000AD384) { build/asm/data/main_800AC784.bin.o(.data); }
    .main_800AC7A0 0x800AC7A0 : AT(0x000AD3A0) { FILL(0x00000000); build/asm/main_800AC7A0.s.o(.text); build/asm/main_800AC7A0.s.o(.rodata); build/asm/main_800AC7A0.s.o(.data); }
    .main_800AC7A0_bss (NOLOAD) : { build/asm/main_800AC7A0.s.o(.bss); }
    .main_800AC86C 0x800AC86C : AT(0x000AD46C) { build/asm/data/main_800AC86C.bin.o(.data); }
    .main_800AC93C 0x800AC93C : AT(0x000AD53C) { FILL(0x00000000); build/asm/main_800AC93C.s.o(.text); build/asm/main_800AC93C.s.o(.rodata); build/asm/main_800AC93C.s.o(.data); }
    .main_800AC93C_bss (NOLOAD) : { build/asm/main_800AC93C.s.o(.bss); }
    .main_800AC95C 0x800AC95C : AT(0x000AD55C) { build/asm/data/main_800AC95C.bin.o(.data); }
    .main_800ACCBC 0x800ACCBC : AT(0x000AD8BC) { FILL(0x00000000); build/asm/main_800ACCBC.s.o(.text); build/asm/main_800ACCBC.s.o(.rodata); build/asm/main_800ACCBC.s.o(.data); }
    .main_800ACCBC_bss (NOLOAD) : { build/asm/main_800ACCBC.s.o(.bss); }
    .main_800ACF34 0x800ACF34 : AT(0x000ADB34) { build/asm/data/main_800ACF34.bin.o(.data); }
    .main_800AD13C 0x800AD13C : AT(0x000ADD3C) { FILL(0x00000000); build/asm/main_800AD13C.s.o(.text); build/asm/main_800AD13C.s.o(.rodata); build/asm/main_800AD13C.s.o(.data); }
    .main_800AD13C_bss (NOLOAD) : { build/asm/main_800AD13C.s.o(.bss); }
    .main_800AD17C 0x800AD17C : AT(0x000ADD7C) { build/asm/data/main_800AD17C.bin.o(.data); }
    .main_800AD2E0 0x800AD2E0 : AT(0x000ADEE0) { FILL(0x00000000); build/asm/main_800AD2E0.s.o(.text); build/asm/main_800AD2E0.s.o(.rodata); build/asm/main_800AD2E0.s.o(.data); }
    .main_800AD2E0_bss (NOLOAD) : { build/asm/main_800AD2E0.s.o(.bss); }
    .main_800AD45C 0x800AD45C : AT(0x000AE05C) { build/asm/data/main_800AD45C.bin.o(.data); }
    .main_800AD52C 0x800AD52C : AT(0x000AE12C) { FILL(0x00000000); build/asm/main_800AD52C.s.o(.text); build/asm/main_800AD52C.s.o(.rodata); build/asm/main_800AD52C.s.o(.data); }
    .main_800AD52C_bss (NOLOAD) : { build/asm/main_800AD52C.s.o(.bss); }
    .main_800AD57C 0x800AD57C : AT(0x000AE17C) { build/asm/data/main_800AD57C.bin.o(.data); }
    .main_800AD77C 0x800AD77C : AT(0x000AE37C) { FILL(0x00000000); build/asm/main_800AD77C.s.o(.text); build/asm/main_800AD77C.s.o(.rodata); build/asm/main_800AD77C.s.o(.data); }
    .main_800AD77C_bss (NOLOAD) : { build/asm/main_800AD77C.s.o(.bss); }
    .main_800AD81C 0x800AD81C : AT(0x000AE41C) { build/asm/data/main_800AD81C.bin.o(.data); }
    .main_800ADA04 0x800ADA04 : AT(0x000AE604) { FILL(0x00000000); build/asm/main_800ADA04.s.o(.text); build/asm/main_800ADA04.s.o(.rodata); build/asm/main_800ADA04.s.o(.data); }
    .main_800ADA04_bss (NOLOAD) : { build/asm/main_800ADA04.s.o(.bss); }
    .main_800ADCD4 0x800ADCD4 : AT(0x000AE8D4) { build/asm/data/main_800ADCD4.bin.o(.data); }
    .main_800AE0EC 0x800AE0EC : AT(0x000AECEC) { FILL(0x00000000); build/asm/main_800AE0EC.s.o(.text); build/asm/main_800AE0EC.s.o(.rodata); build/asm/main_800AE0EC.s.o(.data); }
    .main_800AE0EC_bss (NOLOAD) : { build/asm/main_800AE0EC.s.o(.bss); }
    .main_800AE244 0x800AE244 : AT(0x000AEE44) { build/asm/data/main_800AE244.bin.o(.data); }
    .main_800AE41C 0x800AE41C : AT(0x000AF01C) { FILL(0x00000000); build/asm/main_800AE41C.s.o(.text); build/asm/main_800AE41C.s.o(.rodata); build/asm/main_800AE41C.s.o(.data); }
    .main_800AE41C_bss (NOLOAD) : { build/asm/main_800AE41C.s.o(.bss); }
    .main_800AEC84 0x800AEC84 : AT(0x000AF884) { build/asm/data/main_800AEC84.bin.o(.data); }
    .main_800AF07C 0x800AF07C : AT(0x000AFC7C) { FILL(0x00000000); build/asm/main_800AF07C.s.o(.text); build/asm/main_800AF07C.s.o(.rodata); build/asm/main_800AF07C.s.o(.data); }
    .main_800AF07C_bss (NOLOAD) : { build/asm/main_800AF07C.s.o(.bss); }
    .main_800B021C 0x800B021C : AT(0x000B0E1C) { build/asm/data/main_800B021C.bin.o(.data); }
    .main_800B0444 0x800B0444 : AT(0x000B1044) { FILL(0x00000000); build/asm/main_800B0444.s.o(.text); build/asm/main_800B0444.s.o(.rodata); build/asm/main_800B0444.s.o(.data); }
    .main_800B0444_bss (NOLOAD) : { build/asm/main_800B0444.s.o(.bss); }
    .main_800B083C 0x800B083C : AT(0x000B143C) { build/asm/data/main_800B083C.bin.o(.data); }
    .main_800B0ABC 0x800B0ABC : AT(0x000B16BC) { FILL(0x00000000); build/asm/main_800B0ABC.s.o(.text); build/asm/main_800B0ABC.s.o(.rodata); build/asm/main_800B0ABC.s.o(.data); }
    .main_800B0ABC_bss (NOLOAD) : { build/asm/main_800B0ABC.s.o(.bss); }
    .main_800B0AD4 0x800B0AD4 : AT(0x000B16D4) { build/asm/data/main_800B0AD4.bin.o(.data); }
    .main_800B0B94 0x800B0B94 : AT(0x000B1794) { FILL(0x00000000); build/asm/main_800B0B94.s.o(.text); build/asm/main_800B0B94.s.o(.rodata); build/asm/main_800B0B94.s.o(.data); }
    .main_800B0B94_bss (NOLOAD) : { build/asm/main_800B0B94.s.o(.bss); }
    .main_800B121C 0x800B121C : AT(0x000B1E1C) { build/asm/data/main_800B121C.bin.o(.data); }
    .main_800B13AC 0x800B13AC : AT(0x000B1FAC) { FILL(0x00000000); build/asm/main_800B13AC.s.o(.text); build/asm/main_800B13AC.s.o(.rodata); build/asm/main_800B13AC.s.o(.data); }
    .main_800B13AC_bss (NOLOAD) : { build/asm/main_800B13AC.s.o(.bss); }
    .main_800B14EC 0x800B14EC : AT(0x000B20EC) { build/asm/data/main_800B14EC.bin.o(.data); }
    .main_800B1964 0x800B1964 : AT(0x000B2564) { FILL(0x00000000); build/asm/main_800B1964.s.o(.text); build/asm/main_800B1964.s.o(.rodata); build/asm/main_800B1964.s.o(.data); }
    .main_800B1964_bss (NOLOAD) : { build/asm/main_800B1964.s.o(.bss); }
    .main_800B1974 0x800B1974 : AT(0x000B2574) { build/asm/data/main_800B1974.bin.o(.data); }
    .main_800B19CC 0x800B19CC : AT(0x000B25CC) { FILL(0x00000000); build/asm/main_800B19CC.s.o(.text); build/asm/main_800B19CC.s.o(.rodata); build/asm/main_800B19CC.s.o(.data); }
    .main_800B19CC_bss (NOLOAD) : { build/asm/main_800B19CC.s.o(.bss); }
    .main_800B19F4 0x800B19F4 : AT(0x000B25F4) { build/asm/data/main_800B19F4.bin.o(.data); }
    .main_800B1ACC 0x800B1ACC : AT(0x000B26CC) { FILL(0x00000000); build/asm/main_800B1ACC.s.o(.text); build/asm/main_800B1ACC.s.o(.rodata); build/asm/main_800B1ACC.s.o(.data); }
    .main_800B1ACC_bss (NOLOAD) : { build/asm/main_800B1ACC.s.o(.bss); }
    .main_800B206C 0x800B206C : AT(0x000B2C6C) { build/asm/data/main_800B206C.bin.o(.data); }
    .main_800B29B0 0x800B29B0 : AT(0x000B35B0) { FILL(0x00000000); build/asm/main_800B29B0.s.o(.text); build/asm/main_800B29B0.s.o(.rodata); build/asm/main_800B29B0.s.o(.data); }
    .main_800B29B0_bss (NOLOAD) : { build/asm/main_800B29B0.s.o(.bss); }
    .main_800B2BB4 0x800B2BB4 : AT(0x000B37B4) { build/asm/data/main_800B2BB4.bin.o(.data); }
    .main_800B30CC 0x800B30CC : AT(0x000B3CCC) { FILL(0x00000000); build/asm/main_800B30CC.s.o(.text); build/asm/main_800B30CC.s.o(.rodata); build/asm/main_800B30CC.s.o(.data); }
    .main_800B30CC_bss (NOLOAD) : { build/asm/main_800B30CC.s.o(.bss); }
    .main_800B3164 0x800B3164 : AT(0x000B3D64) { build/asm/data/main_800B3164.bin.o(.data); }
    .main_800B345C 0x800B345C : AT(0x000B405C) { FILL(0x00000000); build/asm/main_800B345C.s.o(.text); build/asm/main_800B345C.s.o(.rodata); build/asm/main_800B345C.s.o(.data); }
    .main_800B345C_bss (NOLOAD) : { build/asm/main_800B345C.s.o(.bss); }
    .main_800B35AC 0x800B35AC : AT(0x000B41AC) { build/asm/data/main_800B35AC.bin.o(.data); }
    .main_800B3734 0x800B3734 : AT(0x000B4334) { FILL(0x00000000); build/asm/main_800B3734.s.o(.text); build/asm/main_800B3734.s.o(.rodata); build/asm/main_800B3734.s.o(.data); }
    .main_800B3734_bss (NOLOAD) : { build/asm/main_800B3734.s.o(.bss); }
    .main_800B3744 0x800B3744 : AT(0x000B4344) { build/asm/data/main_800B3744.bin.o(.data); }
    .main_800B3A8C 0x800B3A8C : AT(0x000B468C) { FILL(0x00000000); build/asm/main_800B3A8C.s.o(.text); build/asm/main_800B3A8C.s.o(.rodata); build/asm/main_800B3A8C.s.o(.data); }
    .main_800B3A8C_bss (NOLOAD) : { build/asm/main_800B3A8C.s.o(.bss); }
    .main_800BF454 0x800BF454 : AT(0x000C0054) { build/asm/data/main_800BF454.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
