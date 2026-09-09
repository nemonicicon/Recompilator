SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004F0 0x800004F0 : AT(0x000010F0) { FILL(0x00000000); build/asm/main_800004F0.s.o(.text); build/asm/main_800004F0.s.o(.rodata); build/asm/main_800004F0.s.o(.data); }
    .main_800004F0_bss (NOLOAD) : { build/asm/main_800004F0.s.o(.bss); }
    .main_80001534 0x80001534 : AT(0x00002134) { build/asm/data/main_80001534.bin.o(.data); }
    .main_80005F18 0x80005F18 : AT(0x00006B18) { FILL(0x00000000); build/asm/main_80005F18.s.o(.text); build/asm/main_80005F18.s.o(.rodata); build/asm/main_80005F18.s.o(.data); }
    .main_80005F18_bss (NOLOAD) : { build/asm/main_80005F18.s.o(.bss); }
    .main_80005F38 0x80005F38 : AT(0x00006B38) { build/asm/data/main_80005F38.bin.o(.data); }
    .main_80006328 0x80006328 : AT(0x00006F28) { FILL(0x00000000); build/asm/main_80006328.s.o(.text); build/asm/main_80006328.s.o(.rodata); build/asm/main_80006328.s.o(.data); }
    .main_80006328_bss (NOLOAD) : { build/asm/main_80006328.s.o(.bss); }
    .main_80006348 0x80006348 : AT(0x00006F48) { build/asm/data/main_80006348.bin.o(.data); }
    .main_80006518 0x80006518 : AT(0x00007118) { FILL(0x00000000); build/asm/main_80006518.s.o(.text); build/asm/main_80006518.s.o(.rodata); build/asm/main_80006518.s.o(.data); }
    .main_80006518_bss (NOLOAD) : { build/asm/main_80006518.s.o(.bss); }
    .main_80006538 0x80006538 : AT(0x00007138) { build/asm/data/main_80006538.bin.o(.data); }
    .main_80006D80 0x80006D80 : AT(0x00007980) { FILL(0x00000000); build/asm/main_80006D80.s.o(.text); build/asm/main_80006D80.s.o(.rodata); build/asm/main_80006D80.s.o(.data); }
    .main_80006D80_bss (NOLOAD) : { build/asm/main_80006D80.s.o(.bss); }
    .main_8000A7CC 0x8000A7CC : AT(0x0000B3CC) { build/asm/data/main_8000A7CC.bin.o(.data); }
    .main_8000A9CC 0x8000A9CC : AT(0x0000B5CC) { FILL(0x00000000); build/asm/main_8000A9CC.s.o(.text); build/asm/main_8000A9CC.s.o(.rodata); build/asm/main_8000A9CC.s.o(.data); }
    .main_8000A9CC_bss (NOLOAD) : { build/asm/main_8000A9CC.s.o(.bss); }
    .main_8000B8E4 0x8000B8E4 : AT(0x0000C4E4) { build/asm/data/main_8000B8E4.bin.o(.data); }
    .main_8000D6B4 0x8000D6B4 : AT(0x0000E2B4) { FILL(0x00000000); build/asm/main_8000D6B4.s.o(.text); build/asm/main_8000D6B4.s.o(.rodata); build/asm/main_8000D6B4.s.o(.data); }
    .main_8000D6B4_bss (NOLOAD) : { build/asm/main_8000D6B4.s.o(.bss); }
    .main_8000D7DC 0x8000D7DC : AT(0x0000E3DC) { build/asm/data/main_8000D7DC.bin.o(.data); }
    .main_8000D898 0x8000D898 : AT(0x0000E498) { FILL(0x00000000); build/asm/main_8000D898.s.o(.text); build/asm/main_8000D898.s.o(.rodata); build/asm/main_8000D898.s.o(.data); }
    .main_8000D898_bss (NOLOAD) : { build/asm/main_8000D898.s.o(.bss); }
    .main_8000DE74 0x8000DE74 : AT(0x0000EA74) { build/asm/data/main_8000DE74.bin.o(.data); }
    .main_80015048 0x80015048 : AT(0x00015C48) { FILL(0x00000000); build/asm/main_80015048.s.o(.text); build/asm/main_80015048.s.o(.rodata); build/asm/main_80015048.s.o(.data); }
    .main_80015048_bss (NOLOAD) : { build/asm/main_80015048.s.o(.bss); }
    .main_8001504C 0x8001504C : AT(0x00015C4C) { build/asm/data/main_8001504C.bin.o(.data); }
    .main_8001E7AC 0x8001E7AC : AT(0x0001F3AC) { FILL(0x00000000); build/asm/main_8001E7AC.s.o(.text); build/asm/main_8001E7AC.s.o(.rodata); build/asm/main_8001E7AC.s.o(.data); }
    .main_8001E7AC_bss (NOLOAD) : { build/asm/main_8001E7AC.s.o(.bss); }
    .main_8001E7BC 0x8001E7BC : AT(0x0001F3BC) { build/asm/data/main_8001E7BC.bin.o(.data); }
    .main_80020EB0 0x80020EB0 : AT(0x00021AB0) { FILL(0x00000000); build/asm/main_80020EB0.s.o(.text); build/asm/main_80020EB0.s.o(.rodata); build/asm/main_80020EB0.s.o(.data); }
    .main_80020EB0_bss (NOLOAD) : { build/asm/main_80020EB0.s.o(.bss); }
    .main_80020ECC 0x80020ECC : AT(0x00021ACC) { build/asm/data/main_80020ECC.bin.o(.data); }
    .main_800235A4 0x800235A4 : AT(0x000241A4) { FILL(0x00000000); build/asm/main_800235A4.s.o(.text); build/asm/main_800235A4.s.o(.rodata); build/asm/main_800235A4.s.o(.data); }
    .main_800235A4_bss (NOLOAD) : { build/asm/main_800235A4.s.o(.bss); }
    .main_800235FC 0x800235FC : AT(0x000241FC) { build/asm/data/main_800235FC.bin.o(.data); }
    .main_800255D0 0x800255D0 : AT(0x000261D0) { FILL(0x00000000); build/asm/main_800255D0.s.o(.text); build/asm/main_800255D0.s.o(.rodata); build/asm/main_800255D0.s.o(.data); }
    .main_800255D0_bss (NOLOAD) : { build/asm/main_800255D0.s.o(.bss); }
    .main_800255D8 0x800255D8 : AT(0x000261D8) { build/asm/data/main_800255D8.bin.o(.data); }
    .main_8002C06C 0x8002C06C : AT(0x0002CC6C) { FILL(0x00000000); build/asm/main_8002C06C.s.o(.text); build/asm/main_8002C06C.s.o(.rodata); build/asm/main_8002C06C.s.o(.data); }
    .main_8002C06C_bss (NOLOAD) : { build/asm/main_8002C06C.s.o(.bss); }
    .main_8002C0D0 0x8002C0D0 : AT(0x0002CCD0) { build/asm/data/main_8002C0D0.bin.o(.data); }
    .main_80030588 0x80030588 : AT(0x00031188) { FILL(0x00000000); build/asm/main_80030588.s.o(.text); build/asm/main_80030588.s.o(.rodata); build/asm/main_80030588.s.o(.data); }
    .main_80030588_bss (NOLOAD) : { build/asm/main_80030588.s.o(.bss); }
    .main_800305B4 0x800305B4 : AT(0x000311B4) { build/asm/data/main_800305B4.bin.o(.data); }
    .main_800362B8 0x800362B8 : AT(0x00036EB8) { FILL(0x00000000); build/asm/main_800362B8.s.o(.text); build/asm/main_800362B8.s.o(.rodata); build/asm/main_800362B8.s.o(.data); }
    .main_800362B8_bss (NOLOAD) : { build/asm/main_800362B8.s.o(.bss); }
    .main_800362C8 0x800362C8 : AT(0x00036EC8) { build/asm/data/main_800362C8.bin.o(.data); }
    .main_8003D7AC 0x8003D7AC : AT(0x0003E3AC) { FILL(0x00000000); build/asm/main_8003D7AC.s.o(.text); build/asm/main_8003D7AC.s.o(.rodata); build/asm/main_8003D7AC.s.o(.data); }
    .main_8003D7AC_bss (NOLOAD) : { build/asm/main_8003D7AC.s.o(.bss); }
    .main_8003D80C 0x8003D80C : AT(0x0003E40C) { build/asm/data/main_8003D80C.bin.o(.data); }
    .main_80053CF4 0x80053CF4 : AT(0x000548F4) { FILL(0x00000000); build/asm/main_80053CF4.s.o(.text); build/asm/main_80053CF4.s.o(.rodata); build/asm/main_80053CF4.s.o(.data); }
    .main_80053CF4_bss (NOLOAD) : { build/asm/main_80053CF4.s.o(.bss); }
    .main_80053D10 0x80053D10 : AT(0x00054910) { build/asm/data/main_80053D10.bin.o(.data); }
    .main_80058F98 0x80058F98 : AT(0x00059B98) { FILL(0x00000000); build/asm/main_80058F98.s.o(.text); build/asm/main_80058F98.s.o(.rodata); build/asm/main_80058F98.s.o(.data); }
    .main_80058F98_bss (NOLOAD) : { build/asm/main_80058F98.s.o(.bss); }
    .main_80058FF0 0x80058FF0 : AT(0x00059BF0) { build/asm/data/main_80058FF0.bin.o(.data); }
    .main_8005DE78 0x8005DE78 : AT(0x0005EA78) { FILL(0x00000000); build/asm/main_8005DE78.s.o(.text); build/asm/main_8005DE78.s.o(.rodata); build/asm/main_8005DE78.s.o(.data); }
    .main_8005DE78_bss (NOLOAD) : { build/asm/main_8005DE78.s.o(.bss); }
    .main_8005DE98 0x8005DE98 : AT(0x0005EA98) { build/asm/data/main_8005DE98.bin.o(.data); }
    .main_8006FBF8 0x8006FBF8 : AT(0x000707F8) { FILL(0x00000000); build/asm/main_8006FBF8.s.o(.text); build/asm/main_8006FBF8.s.o(.rodata); build/asm/main_8006FBF8.s.o(.data); }
    .main_8006FBF8_bss (NOLOAD) : { build/asm/main_8006FBF8.s.o(.bss); }
    .main_8006FCC0 0x8006FCC0 : AT(0x000708C0) { build/asm/data/main_8006FCC0.bin.o(.data); }
    .main_80073DA8 0x80073DA8 : AT(0x000749A8) { FILL(0x00000000); build/asm/main_80073DA8.s.o(.text); build/asm/main_80073DA8.s.o(.rodata); build/asm/main_80073DA8.s.o(.data); }
    .main_80073DA8_bss (NOLOAD) : { build/asm/main_80073DA8.s.o(.bss); }
    .main_80073DD8 0x80073DD8 : AT(0x000749D8) { build/asm/data/main_80073DD8.bin.o(.data); }
    .main_8007FAB0 0x8007FAB0 : AT(0x000806B0) { FILL(0x00000000); build/asm/main_8007FAB0.s.o(.text); build/asm/main_8007FAB0.s.o(.rodata); build/asm/main_8007FAB0.s.o(.data); }
    .main_8007FAB0_bss (NOLOAD) : { build/asm/main_8007FAB0.s.o(.bss); }
    .main_8007FAB8 0x8007FAB8 : AT(0x000806B8) { build/asm/data/main_8007FAB8.bin.o(.data); }
    .main_80080E58 0x80080E58 : AT(0x00081A58) { FILL(0x00000000); build/asm/main_80080E58.s.o(.text); build/asm/main_80080E58.s.o(.rodata); build/asm/main_80080E58.s.o(.data); }
    .main_80080E58_bss (NOLOAD) : { build/asm/main_80080E58.s.o(.bss); }
    .main_80080EB4 0x80080EB4 : AT(0x00081AB4) { build/asm/data/main_80080EB4.bin.o(.data); }
    .main_800816CC 0x800816CC : AT(0x000822CC) { FILL(0x00000000); build/asm/main_800816CC.s.o(.text); build/asm/main_800816CC.s.o(.rodata); build/asm/main_800816CC.s.o(.data); }
    .main_800816CC_bss (NOLOAD) : { build/asm/main_800816CC.s.o(.bss); }
    .main_80081754 0x80081754 : AT(0x00082354) { build/asm/data/main_80081754.bin.o(.data); }
    .main_80082128 0x80082128 : AT(0x00082D28) { FILL(0x00000000); build/asm/main_80082128.s.o(.text); build/asm/main_80082128.s.o(.rodata); build/asm/main_80082128.s.o(.data); }
    .main_80082128_bss (NOLOAD) : { build/asm/main_80082128.s.o(.bss); }
    .main_8008212C 0x8008212C : AT(0x00082D2C) { build/asm/data/main_8008212C.bin.o(.data); }
    .main_80083CB0 0x80083CB0 : AT(0x000848B0) { FILL(0x00000000); build/asm/main_80083CB0.s.o(.text); build/asm/main_80083CB0.s.o(.rodata); build/asm/main_80083CB0.s.o(.data); }
    .main_80083CB0_bss (NOLOAD) : { build/asm/main_80083CB0.s.o(.bss); }
    .main_80083DA0 0x80083DA0 : AT(0x000849A0) { build/asm/data/main_80083DA0.bin.o(.data); }
    .main_800981A8 0x800981A8 : AT(0x00098DA8) { FILL(0x00000000); build/asm/main_800981A8.s.o(.text); build/asm/main_800981A8.s.o(.rodata); build/asm/main_800981A8.s.o(.data); }
    .main_800981A8_bss (NOLOAD) : { build/asm/main_800981A8.s.o(.bss); }
    .main_800981B4 0x800981B4 : AT(0x00098DB4) { build/asm/data/main_800981B4.bin.o(.data); }
    .main_80099224 0x80099224 : AT(0x00099E24) { FILL(0x00000000); build/asm/main_80099224.s.o(.text); build/asm/main_80099224.s.o(.rodata); build/asm/main_80099224.s.o(.data); }
    .main_80099224_bss (NOLOAD) : { build/asm/main_80099224.s.o(.bss); }
    .main_80099320 0x80099320 : AT(0x00099F20) { build/asm/data/main_80099320.bin.o(.data); }
    .main_8009B3C0 0x8009B3C0 : AT(0x0009BFC0) { FILL(0x00000000); build/asm/main_8009B3C0.s.o(.text); build/asm/main_8009B3C0.s.o(.rodata); build/asm/main_8009B3C0.s.o(.data); }
    .main_8009B3C0_bss (NOLOAD) : { build/asm/main_8009B3C0.s.o(.bss); }
    .main_8009B3D4 0x8009B3D4 : AT(0x0009BFD4) { build/asm/data/main_8009B3D4.bin.o(.data); }
    .main_800A8310 0x800A8310 : AT(0x000A8F10) { FILL(0x00000000); build/asm/main_800A8310.s.o(.text); build/asm/main_800A8310.s.o(.rodata); build/asm/main_800A8310.s.o(.data); }
    .main_800A8310_bss (NOLOAD) : { build/asm/main_800A8310.s.o(.bss); }
    .main_800A8314 0x800A8314 : AT(0x000A8F14) { build/asm/data/main_800A8314.bin.o(.data); }
    .main_800B67C0 0x800B67C0 : AT(0x000B73C0) { FILL(0x00000000); build/asm/main_800B67C0.s.o(.text); build/asm/main_800B67C0.s.o(.rodata); build/asm/main_800B67C0.s.o(.data); }
    .main_800B67C0_bss (NOLOAD) : { build/asm/main_800B67C0.s.o(.bss); }
    .main_800B67D8 0x800B67D8 : AT(0x000B73D8) { build/asm/data/main_800B67D8.bin.o(.data); }
    .main_800D4944 0x800D4944 : AT(0x000D5544) { FILL(0x00000000); build/asm/main_800D4944.s.o(.text); build/asm/main_800D4944.s.o(.rodata); build/asm/main_800D4944.s.o(.data); }
    .main_800D4944_bss (NOLOAD) : { build/asm/main_800D4944.s.o(.bss); }
    .main_800D4954 0x800D4954 : AT(0x000D5554) { build/asm/data/main_800D4954.bin.o(.data); }
    .main_800DC038 0x800DC038 : AT(0x000DCC38) { FILL(0x00000000); build/asm/main_800DC038.s.o(.text); build/asm/main_800DC038.s.o(.rodata); build/asm/main_800DC038.s.o(.data); }
    .main_800DC038_bss (NOLOAD) : { build/asm/main_800DC038.s.o(.bss); }
    .main_800DC0C8 0x800DC0C8 : AT(0x000DCCC8) { build/asm/data/main_800DC0C8.bin.o(.data); }
    .main_800DD1FC 0x800DD1FC : AT(0x000DDDFC) { FILL(0x00000000); build/asm/main_800DD1FC.s.o(.text); build/asm/main_800DD1FC.s.o(.rodata); build/asm/main_800DD1FC.s.o(.data); }
    .main_800DD1FC_bss (NOLOAD) : { build/asm/main_800DD1FC.s.o(.bss); }
    .main_800DD270 0x800DD270 : AT(0x000DDE70) { build/asm/data/main_800DD270.bin.o(.data); }
    .main_800DD4A4 0x800DD4A4 : AT(0x000DE0A4) { FILL(0x00000000); build/asm/main_800DD4A4.s.o(.text); build/asm/main_800DD4A4.s.o(.rodata); build/asm/main_800DD4A4.s.o(.data); }
    .main_800DD4A4_bss (NOLOAD) : { build/asm/main_800DD4A4.s.o(.bss); }
    .main_800DD504 0x800DD504 : AT(0x000DE104) { build/asm/data/main_800DD504.bin.o(.data); }
    .main_800DE8F4 0x800DE8F4 : AT(0x000DF4F4) { FILL(0x00000000); build/asm/main_800DE8F4.s.o(.text); build/asm/main_800DE8F4.s.o(.rodata); build/asm/main_800DE8F4.s.o(.data); }
    .main_800DE8F4_bss (NOLOAD) : { build/asm/main_800DE8F4.s.o(.bss); }
    .main_800DE938 0x800DE938 : AT(0x000DF538) { build/asm/data/main_800DE938.bin.o(.data); }
    .main_800F4500 0x800F4500 : AT(0x000F5100) { FILL(0x00000000); build/asm/main_800F4500.s.o(.text); build/asm/main_800F4500.s.o(.rodata); build/asm/main_800F4500.s.o(.data); }
    .main_800F4500_bss (NOLOAD) : { build/asm/main_800F4500.s.o(.bss); }
    .main_800F45A0 0x800F45A0 : AT(0x000F51A0) { build/asm/data/main_800F45A0.bin.o(.data); }
    .main_800F8DD8 0x800F8DD8 : AT(0x000F99D8) { FILL(0x00000000); build/asm/main_800F8DD8.s.o(.text); build/asm/main_800F8DD8.s.o(.rodata); build/asm/main_800F8DD8.s.o(.data); }
    .main_800F8DD8_bss (NOLOAD) : { build/asm/main_800F8DD8.s.o(.bss); }
    .main_800F8DE0 0x800F8DE0 : AT(0x000F99E0) { build/asm/data/main_800F8DE0.bin.o(.data); }
    .main_800FF1D0 0x800FF1D0 : AT(0x000FFDD0) { FILL(0x00000000); build/asm/main_800FF1D0.s.o(.text); build/asm/main_800FF1D0.s.o(.rodata); build/asm/main_800FF1D0.s.o(.data); }
    .main_800FF1D0_bss (NOLOAD) : { build/asm/main_800FF1D0.s.o(.bss); }
    .main_800FF1F4 0x800FF1F4 : AT(0x000FFDF4) { build/asm/data/main_800FF1F4.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
