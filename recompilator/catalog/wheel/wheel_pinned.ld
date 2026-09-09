SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80002348 0x80002348 : AT(0x00002F48) { FILL(0x00000000); build/asm/main_80002348.s.o(.text); build/asm/main_80002348.s.o(.rodata); build/asm/main_80002348.s.o(.data); }
    .main_80002348_bss (NOLOAD) : { build/asm/main_80002348.s.o(.bss); }
    .main_80003944 0x80003944 : AT(0x00004544) { FILL(0x00000000); build/asm/main_80003944.s.o(.text); build/asm/main_80003944.s.o(.rodata); build/asm/main_80003944.s.o(.data); }
    .main_80003944_bss (NOLOAD) : { build/asm/main_80003944.s.o(.bss); }
    .main_80003FDC 0x80003FDC : AT(0x00004BDC) { FILL(0x00000000); build/asm/main_80003FDC.s.o(.text); build/asm/main_80003FDC.s.o(.rodata); build/asm/main_80003FDC.s.o(.data); }
    .main_80003FDC_bss (NOLOAD) : { build/asm/main_80003FDC.s.o(.bss); }
    .main_8000420C 0x8000420C : AT(0x00004E0C) { FILL(0x00000000); build/asm/main_8000420C.s.o(.text); build/asm/main_8000420C.s.o(.rodata); build/asm/main_8000420C.s.o(.data); }
    .main_8000420C_bss (NOLOAD) : { build/asm/main_8000420C.s.o(.bss); }
    .main_800051B4 0x800051B4 : AT(0x00005DB4) { FILL(0x00000000); build/asm/main_800051B4.s.o(.text); build/asm/main_800051B4.s.o(.rodata); build/asm/main_800051B4.s.o(.data); }
    .main_800051B4_bss (NOLOAD) : { build/asm/main_800051B4.s.o(.bss); }
    .main_8000648C 0x8000648C : AT(0x0000708C) { FILL(0x00000000); build/asm/main_8000648C.s.o(.text); build/asm/main_8000648C.s.o(.rodata); build/asm/main_8000648C.s.o(.data); }
    .main_8000648C_bss (NOLOAD) : { build/asm/main_8000648C.s.o(.bss); }
    .main_80006828 0x80006828 : AT(0x00007428) { FILL(0x00000000); build/asm/main_80006828.s.o(.text); build/asm/main_80006828.s.o(.rodata); build/asm/main_80006828.s.o(.data); }
    .main_80006828_bss (NOLOAD) : { build/asm/main_80006828.s.o(.bss); }
    .main_8000BE6C 0x8000BE6C : AT(0x0000CA6C) { FILL(0x00000000); build/asm/main_8000BE6C.s.o(.text); build/asm/main_8000BE6C.s.o(.rodata); build/asm/main_8000BE6C.s.o(.data); }
    .main_8000BE6C_bss (NOLOAD) : { build/asm/main_8000BE6C.s.o(.bss); }
    .main_8000E6B4 0x8000E6B4 : AT(0x0000F2B4) { FILL(0x00000000); build/asm/main_8000E6B4.s.o(.text); build/asm/main_8000E6B4.s.o(.rodata); build/asm/main_8000E6B4.s.o(.data); }
    .main_8000E6B4_bss (NOLOAD) : { build/asm/main_8000E6B4.s.o(.bss); }
    .main_8000EE78 0x8000EE78 : AT(0x0000FA78) { FILL(0x00000000); build/asm/main_8000EE78.s.o(.text); build/asm/main_8000EE78.s.o(.rodata); build/asm/main_8000EE78.s.o(.data); }
    .main_8000EE78_bss (NOLOAD) : { build/asm/main_8000EE78.s.o(.bss); }
    .main_8000FC3C 0x8000FC3C : AT(0x0001083C) { FILL(0x00000000); build/asm/main_8000FC3C.s.o(.text); build/asm/main_8000FC3C.s.o(.rodata); build/asm/main_8000FC3C.s.o(.data); }
    .main_8000FC3C_bss (NOLOAD) : { build/asm/main_8000FC3C.s.o(.bss); }
    .main_80010AB8 0x80010AB8 : AT(0x000116B8) { FILL(0x00000000); build/asm/main_80010AB8.s.o(.text); build/asm/main_80010AB8.s.o(.rodata); build/asm/main_80010AB8.s.o(.data); }
    .main_80010AB8_bss (NOLOAD) : { build/asm/main_80010AB8.s.o(.bss); }
    .main_800111F0 0x800111F0 : AT(0x00011DF0) { FILL(0x00000000); build/asm/main_800111F0.s.o(.text); build/asm/main_800111F0.s.o(.rodata); build/asm/main_800111F0.s.o(.data); }
    .main_800111F0_bss (NOLOAD) : { build/asm/main_800111F0.s.o(.bss); }
    .main_8001277C 0x8001277C : AT(0x0001337C) { FILL(0x00000000); build/asm/main_8001277C.s.o(.text); build/asm/main_8001277C.s.o(.rodata); build/asm/main_8001277C.s.o(.data); }
    .main_8001277C_bss (NOLOAD) : { build/asm/main_8001277C.s.o(.bss); }
    .main_800132EC 0x800132EC : AT(0x00013EEC) { FILL(0x00000000); build/asm/main_800132EC.s.o(.text); build/asm/main_800132EC.s.o(.rodata); build/asm/main_800132EC.s.o(.data); }
    .main_800132EC_bss (NOLOAD) : { build/asm/main_800132EC.s.o(.bss); }
    .main_80015848 0x80015848 : AT(0x00016448) { FILL(0x00000000); build/asm/main_80015848.s.o(.text); build/asm/main_80015848.s.o(.rodata); build/asm/main_80015848.s.o(.data); }
    .main_80015848_bss (NOLOAD) : { build/asm/main_80015848.s.o(.bss); }
    .main_80016944 0x80016944 : AT(0x00017544) { FILL(0x00000000); build/asm/main_80016944.s.o(.text); build/asm/main_80016944.s.o(.rodata); build/asm/main_80016944.s.o(.data); }
    .main_80016944_bss (NOLOAD) : { build/asm/main_80016944.s.o(.bss); }
    .main_8001745C 0x8001745C : AT(0x0001805C) { FILL(0x00000000); build/asm/main_8001745C.s.o(.text); build/asm/main_8001745C.s.o(.rodata); build/asm/main_8001745C.s.o(.data); }
    .main_8001745C_bss (NOLOAD) : { build/asm/main_8001745C.s.o(.bss); }
    .main_80017C00 0x80017C00 : AT(0x00018800) { FILL(0x00000000); build/asm/main_80017C00.s.o(.text); build/asm/main_80017C00.s.o(.rodata); build/asm/main_80017C00.s.o(.data); }
    .main_80017C00_bss (NOLOAD) : { build/asm/main_80017C00.s.o(.bss); }
    .main_8001A424 0x8001A424 : AT(0x0001B024) { FILL(0x00000000); build/asm/main_8001A424.s.o(.text); build/asm/main_8001A424.s.o(.rodata); build/asm/main_8001A424.s.o(.data); }
    .main_8001A424_bss (NOLOAD) : { build/asm/main_8001A424.s.o(.bss); }
    .main_8001D320 0x8001D320 : AT(0x0001DF20) { FILL(0x00000000); build/asm/main_8001D320.s.o(.text); build/asm/main_8001D320.s.o(.rodata); build/asm/main_8001D320.s.o(.data); }
    .main_8001D320_bss (NOLOAD) : { build/asm/main_8001D320.s.o(.bss); }
    .main_80021908 0x80021908 : AT(0x00022508) { FILL(0x00000000); build/asm/main_80021908.s.o(.text); build/asm/main_80021908.s.o(.rodata); build/asm/main_80021908.s.o(.data); }
    .main_80021908_bss (NOLOAD) : { build/asm/main_80021908.s.o(.bss); }
    .main_800226BC 0x800226BC : AT(0x000232BC) { FILL(0x00000000); build/asm/main_800226BC.s.o(.text); build/asm/main_800226BC.s.o(.rodata); build/asm/main_800226BC.s.o(.data); }
    .main_800226BC_bss (NOLOAD) : { build/asm/main_800226BC.s.o(.bss); }
    .main_80023B44 0x80023B44 : AT(0x00024744) { FILL(0x00000000); build/asm/main_80023B44.s.o(.text); build/asm/main_80023B44.s.o(.rodata); build/asm/main_80023B44.s.o(.data); }
    .main_80023B44_bss (NOLOAD) : { build/asm/main_80023B44.s.o(.bss); }
    .main_80024D60 0x80024D60 : AT(0x00025960) { FILL(0x00000000); build/asm/main_80024D60.s.o(.text); build/asm/main_80024D60.s.o(.rodata); build/asm/main_80024D60.s.o(.data); }
    .main_80024D60_bss (NOLOAD) : { build/asm/main_80024D60.s.o(.bss); }
    .main_800258BC 0x800258BC : AT(0x000264BC) { FILL(0x00000000); build/asm/main_800258BC.s.o(.text); build/asm/main_800258BC.s.o(.rodata); build/asm/main_800258BC.s.o(.data); }
    .main_800258BC_bss (NOLOAD) : { build/asm/main_800258BC.s.o(.bss); }
    .main_80028900 0x80028900 : AT(0x00029500) { FILL(0x00000000); build/asm/main_80028900.s.o(.text); build/asm/main_80028900.s.o(.rodata); build/asm/main_80028900.s.o(.data); }
    .main_80028900_bss (NOLOAD) : { build/asm/main_80028900.s.o(.bss); }
    .main_80028C4C 0x80028C4C : AT(0x0002984C) { FILL(0x00000000); build/asm/main_80028C4C.s.o(.text); build/asm/main_80028C4C.s.o(.rodata); build/asm/main_80028C4C.s.o(.data); }
    .main_80028C4C_bss (NOLOAD) : { build/asm/main_80028C4C.s.o(.bss); }
    .main_80029440 0x80029440 : AT(0x0002A040) { FILL(0x00000000); build/asm/main_80029440.s.o(.text); build/asm/main_80029440.s.o(.rodata); build/asm/main_80029440.s.o(.data); }
    .main_80029440_bss (NOLOAD) : { build/asm/main_80029440.s.o(.bss); }
    .main_8002A014 0x8002A014 : AT(0x0002AC14) { FILL(0x00000000); build/asm/main_8002A014.s.o(.text); build/asm/main_8002A014.s.o(.rodata); build/asm/main_8002A014.s.o(.data); }
    .main_8002A014_bss (NOLOAD) : { build/asm/main_8002A014.s.o(.bss); }
    .main_8002CAB4 0x8002CAB4 : AT(0x0002D6B4) { FILL(0x00000000); build/asm/main_8002CAB4.s.o(.text); build/asm/main_8002CAB4.s.o(.rodata); build/asm/main_8002CAB4.s.o(.data); }
    .main_8002CAB4_bss (NOLOAD) : { build/asm/main_8002CAB4.s.o(.bss); }
    .main_8002D8B0 0x8002D8B0 : AT(0x0002E4B0) { FILL(0x00000000); build/asm/main_8002D8B0.s.o(.text); build/asm/main_8002D8B0.s.o(.rodata); build/asm/main_8002D8B0.s.o(.data); }
    .main_8002D8B0_bss (NOLOAD) : { build/asm/main_8002D8B0.s.o(.bss); }
    .main_8002DF80 0x8002DF80 : AT(0x0002EB80) { FILL(0x00000000); build/asm/main_8002DF80.s.o(.text); build/asm/main_8002DF80.s.o(.rodata); build/asm/main_8002DF80.s.o(.data); }
    .main_8002DF80_bss (NOLOAD) : { build/asm/main_8002DF80.s.o(.bss); }
    .main_8002EB40 0x8002EB40 : AT(0x0002F740) { FILL(0x00000000); build/asm/main_8002EB40.s.o(.text); build/asm/main_8002EB40.s.o(.rodata); build/asm/main_8002EB40.s.o(.data); }
    .main_8002EB40_bss (NOLOAD) : { build/asm/main_8002EB40.s.o(.bss); }
    .main_8002FCD8 0x8002FCD8 : AT(0x000308D8) { FILL(0x00000000); build/asm/main_8002FCD8.s.o(.text); build/asm/main_8002FCD8.s.o(.rodata); build/asm/main_8002FCD8.s.o(.data); }
    .main_8002FCD8_bss (NOLOAD) : { build/asm/main_8002FCD8.s.o(.bss); }
    .main_80031340 0x80031340 : AT(0x00031F40) { FILL(0x00000000); build/asm/main_80031340.s.o(.text); build/asm/main_80031340.s.o(.rodata); build/asm/main_80031340.s.o(.data); }
    .main_80031340_bss (NOLOAD) : { build/asm/main_80031340.s.o(.bss); }
    .main_800323C4 0x800323C4 : AT(0x00032FC4) { FILL(0x00000000); build/asm/main_800323C4.s.o(.text); build/asm/main_800323C4.s.o(.rodata); build/asm/main_800323C4.s.o(.data); }
    .main_800323C4_bss (NOLOAD) : { build/asm/main_800323C4.s.o(.bss); }
    .main_800339E8 0x800339E8 : AT(0x000345E8) { FILL(0x00000000); build/asm/main_800339E8.s.o(.text); build/asm/main_800339E8.s.o(.rodata); build/asm/main_800339E8.s.o(.data); }
    .main_800339E8_bss (NOLOAD) : { build/asm/main_800339E8.s.o(.bss); }
    .main_800380B8 0x800380B8 : AT(0x00038CB8) { FILL(0x00000000); build/asm/main_800380B8.s.o(.text); build/asm/main_800380B8.s.o(.rodata); build/asm/main_800380B8.s.o(.data); }
    .main_800380B8_bss (NOLOAD) : { build/asm/main_800380B8.s.o(.bss); }
    .main_80039538 0x80039538 : AT(0x0003A138) { FILL(0x00000000); build/asm/main_80039538.s.o(.text); build/asm/main_80039538.s.o(.rodata); build/asm/main_80039538.s.o(.data); }
    .main_80039538_bss (NOLOAD) : { build/asm/main_80039538.s.o(.bss); }
    .main_800396B8 0x800396B8 : AT(0x0003A2B8) { FILL(0x00000000); build/asm/main_800396B8.s.o(.text); build/asm/main_800396B8.s.o(.rodata); build/asm/main_800396B8.s.o(.data); }
    .main_800396B8_bss (NOLOAD) : { build/asm/main_800396B8.s.o(.bss); }
    .main_8003AC18 0x8003AC18 : AT(0x0003B818) { FILL(0x00000000); build/asm/main_8003AC18.s.o(.text); build/asm/main_8003AC18.s.o(.rodata); build/asm/main_8003AC18.s.o(.data); }
    .main_8003AC18_bss (NOLOAD) : { build/asm/main_8003AC18.s.o(.bss); }
    .main_8003B1E8 0x8003B1E8 : AT(0x0003BDE8) { FILL(0x00000000); build/asm/main_8003B1E8.s.o(.text); build/asm/main_8003B1E8.s.o(.rodata); build/asm/main_8003B1E8.s.o(.data); }
    .main_8003B1E8_bss (NOLOAD) : { build/asm/main_8003B1E8.s.o(.bss); }
    .main_8003B378 0x8003B378 : AT(0x0003BF78) { FILL(0x00000000); build/asm/main_8003B378.s.o(.text); build/asm/main_8003B378.s.o(.rodata); build/asm/main_8003B378.s.o(.data); }
    .main_8003B378_bss (NOLOAD) : { build/asm/main_8003B378.s.o(.bss); }
    .main_8003D3CC 0x8003D3CC : AT(0x0003DFCC) { FILL(0x00000000); build/asm/main_8003D3CC.s.o(.text); build/asm/main_8003D3CC.s.o(.rodata); build/asm/main_8003D3CC.s.o(.data); }
    .main_8003D3CC_bss (NOLOAD) : { build/asm/main_8003D3CC.s.o(.bss); }
    .main_8003DE3C 0x8003DE3C : AT(0x0003EA3C) { FILL(0x00000000); build/asm/main_8003DE3C.s.o(.text); build/asm/main_8003DE3C.s.o(.rodata); build/asm/main_8003DE3C.s.o(.data); }
    .main_8003DE3C_bss (NOLOAD) : { build/asm/main_8003DE3C.s.o(.bss); }
    .main_8003F7C8 0x8003F7C8 : AT(0x000403C8) { FILL(0x00000000); build/asm/main_8003F7C8.s.o(.text); build/asm/main_8003F7C8.s.o(.rodata); build/asm/main_8003F7C8.s.o(.data); }
    .main_8003F7C8_bss (NOLOAD) : { build/asm/main_8003F7C8.s.o(.bss); }
    .main_8003FC78 0x8003FC78 : AT(0x00040878) { FILL(0x00000000); build/asm/main_8003FC78.s.o(.text); build/asm/main_8003FC78.s.o(.rodata); build/asm/main_8003FC78.s.o(.data); }
    .main_8003FC78_bss (NOLOAD) : { build/asm/main_8003FC78.s.o(.bss); }
    .main_8003FF78 0x8003FF78 : AT(0x00040B78) { FILL(0x00000000); build/asm/main_8003FF78.s.o(.text); build/asm/main_8003FF78.s.o(.rodata); build/asm/main_8003FF78.s.o(.data); }
    .main_8003FF78_bss (NOLOAD) : { build/asm/main_8003FF78.s.o(.bss); }
    .main_800408EC 0x800408EC : AT(0x000414EC) { FILL(0x00000000); build/asm/main_800408EC.s.o(.text); build/asm/main_800408EC.s.o(.rodata); build/asm/main_800408EC.s.o(.data); }
    .main_800408EC_bss (NOLOAD) : { build/asm/main_800408EC.s.o(.bss); }
    .main_80040C48 0x80040C48 : AT(0x00041848) { FILL(0x00000000); build/asm/main_80040C48.s.o(.text); build/asm/main_80040C48.s.o(.rodata); build/asm/main_80040C48.s.o(.data); }
    .main_80040C48_bss (NOLOAD) : { build/asm/main_80040C48.s.o(.bss); }
    .main_80040D08 0x80040D08 : AT(0x00041908) { FILL(0x00000000); build/asm/main_80040D08.s.o(.text); build/asm/main_80040D08.s.o(.rodata); build/asm/main_80040D08.s.o(.data); }
    .main_80040D08_bss (NOLOAD) : { build/asm/main_80040D08.s.o(.bss); }
    .main_800422B8 0x800422B8 : AT(0x00042EB8) { FILL(0x00000000); build/asm/main_800422B8.s.o(.text); build/asm/main_800422B8.s.o(.rodata); build/asm/main_800422B8.s.o(.data); }
    .main_800422B8_bss (NOLOAD) : { build/asm/main_800422B8.s.o(.bss); }
    .main_80043A68 0x80043A68 : AT(0x00044668) { FILL(0x00000000); build/asm/main_80043A68.s.o(.text); build/asm/main_80043A68.s.o(.rodata); build/asm/main_80043A68.s.o(.data); }
    .main_80043A68_bss (NOLOAD) : { build/asm/main_80043A68.s.o(.bss); }
    .main_800491A8 0x800491A8 : AT(0x00049DA8) { FILL(0x00000000); build/asm/main_800491A8.s.o(.text); build/asm/main_800491A8.s.o(.rodata); build/asm/main_800491A8.s.o(.data); }
    .main_800491A8_bss (NOLOAD) : { build/asm/main_800491A8.s.o(.bss); }
    .main_8004AABC 0x8004AABC : AT(0x0004B6BC) { FILL(0x00000000); build/asm/main_8004AABC.s.o(.text); build/asm/main_8004AABC.s.o(.rodata); build/asm/main_8004AABC.s.o(.data); }
    .main_8004AABC_bss (NOLOAD) : { build/asm/main_8004AABC.s.o(.bss); }
    .main_8004B0B8 0x8004B0B8 : AT(0x0004BCB8) { FILL(0x00000000); build/asm/main_8004B0B8.s.o(.text); build/asm/main_8004B0B8.s.o(.rodata); build/asm/main_8004B0B8.s.o(.data); }
    .main_8004B0B8_bss (NOLOAD) : { build/asm/main_8004B0B8.s.o(.bss); }
    .main_80050F44 0x80050F44 : AT(0x00051B44) { FILL(0x00000000); build/asm/main_80050F44.s.o(.text); build/asm/main_80050F44.s.o(.rodata); build/asm/main_80050F44.s.o(.data); }
    .main_80050F44_bss (NOLOAD) : { build/asm/main_80050F44.s.o(.bss); }
    .main_80058B80 0x80058B80 : AT(0x00059780) { FILL(0x00000000); build/asm/main_80058B80.s.o(.text); build/asm/main_80058B80.s.o(.rodata); build/asm/main_80058B80.s.o(.data); }
    .main_80058B80_bss (NOLOAD) : { build/asm/main_80058B80.s.o(.bss); }
    .main_80068ACC 0x80068ACC : AT(0x000696CC) { FILL(0x00000000); build/asm/main_80068ACC.s.o(.text); build/asm/main_80068ACC.s.o(.rodata); build/asm/main_80068ACC.s.o(.data); }
    .main_80068ACC_bss (NOLOAD) : { build/asm/main_80068ACC.s.o(.bss); }
    .main_80070F84 0x80070F84 : AT(0x00071B84) { build/asm/data/main_80070F84.bin.o(.data); }
    .main_80079CC4 0x80079CC4 : AT(0x0007A8C4) { FILL(0x00000000); build/asm/main_80079CC4.s.o(.text); build/asm/main_80079CC4.s.o(.rodata); build/asm/main_80079CC4.s.o(.data); }
    .main_80079CC4_bss (NOLOAD) : { build/asm/main_80079CC4.s.o(.bss); }
    .main_8007AFC8 0x8007AFC8 : AT(0x0007BBC8) { build/asm/data/main_8007AFC8.bin.o(.data); }
    .main_8007C2C4 0x8007C2C4 : AT(0x0007CEC4) { FILL(0x00000000); build/asm/main_8007C2C4.s.o(.text); build/asm/main_8007C2C4.s.o(.rodata); build/asm/main_8007C2C4.s.o(.data); }
    .main_8007C2C4_bss (NOLOAD) : { build/asm/main_8007C2C4.s.o(.bss); }
    .main_8007C4BC 0x8007C4BC : AT(0x0007D0BC) { build/asm/data/main_8007C4BC.bin.o(.data); }
    .main_80083408 0x80083408 : AT(0x00084008) { FILL(0x00000000); build/asm/main_80083408.s.o(.text); build/asm/main_80083408.s.o(.rodata); build/asm/main_80083408.s.o(.data); }
    .main_80083408_bss (NOLOAD) : { build/asm/main_80083408.s.o(.bss); }
    .main_80083C08 0x80083C08 : AT(0x00084808) { build/asm/data/main_80083C08.bin.o(.data); }
    .main_80083E58 0x80083E58 : AT(0x00084A58) { FILL(0x00000000); build/asm/main_80083E58.s.o(.text); build/asm/main_80083E58.s.o(.rodata); build/asm/main_80083E58.s.o(.data); }
    .main_80083E58_bss (NOLOAD) : { build/asm/main_80083E58.s.o(.bss); }
    .main_80084238 0x80084238 : AT(0x00084E38) { FILL(0x00000000); build/asm/main_80084238.s.o(.text); build/asm/main_80084238.s.o(.rodata); build/asm/main_80084238.s.o(.data); }
    .main_80084238_bss (NOLOAD) : { build/asm/main_80084238.s.o(.bss); }
    .main_80084658 0x80084658 : AT(0x00085258) { build/asm/data/main_80084658.bin.o(.data); }
    .main_800879DC 0x800879DC : AT(0x000885DC) { FILL(0x00000000); build/asm/main_800879DC.s.o(.text); build/asm/main_800879DC.s.o(.rodata); build/asm/main_800879DC.s.o(.data); }
    .main_800879DC_bss (NOLOAD) : { build/asm/main_800879DC.s.o(.bss); }
    .main_80087A18 0x80087A18 : AT(0x00088618) { build/asm/data/main_80087A18.bin.o(.data); }
    .main_80087B48 0x80087B48 : AT(0x00088748) { FILL(0x00000000); build/asm/main_80087B48.s.o(.text); build/asm/main_80087B48.s.o(.rodata); build/asm/main_80087B48.s.o(.data); }
    .main_80087B48_bss (NOLOAD) : { build/asm/main_80087B48.s.o(.bss); }
    .main_80087FDC 0x80087FDC : AT(0x00088BDC) { build/asm/data/main_80087FDC.bin.o(.data); }
    .main_800887D8 0x800887D8 : AT(0x000893D8) { FILL(0x00000000); build/asm/main_800887D8.s.o(.text); build/asm/main_800887D8.s.o(.rodata); build/asm/main_800887D8.s.o(.data); }
    .main_800887D8_bss (NOLOAD) : { build/asm/main_800887D8.s.o(.bss); }
    .main_800A5334 0x800A5334 : AT(0x000A5F34) { build/asm/data/main_800A5334.bin.o(.data); }
    .main_800A75B0 0x800A75B0 : AT(0x000A81B0) { build/asm/data/main_800A75B0.bin.o(.data); }
    .main_800A9320 0x800A9320 : AT(0x000A9F20) { build/asm/data/main_800A9320.bin.o(.data); }
    .main_800AB82C 0x800AB82C : AT(0x000AC42C) { build/asm/data/main_800AB82C.bin.o(.data); }
    .main_800AF03C 0x800AF03C : AT(0x000AFC3C) { build/asm/data/main_800AF03C.bin.o(.data); }
    .main_800AF688 0x800AF688 : AT(0x000B0288) { FILL(0x00000000); build/asm/main_800AF688.s.o(.text); build/asm/main_800AF688.s.o(.rodata); build/asm/main_800AF688.s.o(.data); }
    .main_800AF688_bss (NOLOAD) : { build/asm/main_800AF688.s.o(.bss); }
    .main_800AF8F8 0x800AF8F8 : AT(0x000B04F8) { build/asm/data/main_800AF8F8.bin.o(.data); }
    .main_800AFB28 0x800AFB28 : AT(0x000B0728) { build/asm/data/main_800AFB28.bin.o(.data); }
    .main_800B06E4 0x800B06E4 : AT(0x000B12E4) { build/asm/data/main_800B06E4.bin.o(.data); }
    .main_800B1884 0x800B1884 : AT(0x000B2484) { build/asm/data/main_800B1884.bin.o(.data); }
    .main_800B2738 0x800B2738 : AT(0x000B3338) { FILL(0x00000000); build/asm/main_800B2738.s.o(.text); build/asm/main_800B2738.s.o(.rodata); build/asm/main_800B2738.s.o(.data); }
    .main_800B2738_bss (NOLOAD) : { build/asm/main_800B2738.s.o(.bss); }
    .main_800B2804 0x800B2804 : AT(0x000B3404) { build/asm/data/main_800B2804.bin.o(.data); }
    .main_800B2BFC 0x800B2BFC : AT(0x000B37FC) { build/asm/data/main_800B2BFC.bin.o(.data); }
    .main_800B3F5C 0x800B3F5C : AT(0x000B4B5C) { build/asm/data/main_800B3F5C.bin.o(.data); }
    .main_800B46E8 0x800B46E8 : AT(0x000B52E8) { build/asm/data/main_800B46E8.bin.o(.data); }
    .main_800B657C 0x800B657C : AT(0x000B717C) { build/asm/data/main_800B657C.bin.o(.data); }
    .main_800B6BA4 0x800B6BA4 : AT(0x000B77A4) { build/asm/data/main_800B6BA4.bin.o(.data); }
    .main_800B6E1C 0x800B6E1C : AT(0x000B7A1C) { build/asm/data/main_800B6E1C.bin.o(.data); }
    .main_800B833C 0x800B833C : AT(0x000B8F3C) { build/asm/data/main_800B833C.bin.o(.data); }
    .main_800BA064 0x800BA064 : AT(0x000BAC64) { build/asm/data/main_800BA064.bin.o(.data); }
    .main_800BA178 0x800BA178 : AT(0x000BAD78) { build/asm/data/main_800BA178.bin.o(.data); }
    .main_800BA3C4 0x800BA3C4 : AT(0x000BAFC4) { build/asm/data/main_800BA3C4.bin.o(.data); }
    .main_800BA64C 0x800BA64C : AT(0x000BB24C) { build/asm/data/main_800BA64C.bin.o(.data); }
    .main_800BC438 0x800BC438 : AT(0x000BD038) { FILL(0x00000000); build/asm/main_800BC438.s.o(.text); build/asm/main_800BC438.s.o(.rodata); build/asm/main_800BC438.s.o(.data); }
    .main_800BC438_bss (NOLOAD) : { build/asm/main_800BC438.s.o(.bss); }
    .main_800BC448 0x800BC448 : AT(0x000BD048) { build/asm/data/main_800BC448.bin.o(.data); }
    .main_800BC9C4 0x800BC9C4 : AT(0x000BD5C4) { build/asm/data/main_800BC9C4.bin.o(.data); }
    .main_800BD36C 0x800BD36C : AT(0x000BDF6C) { build/asm/data/main_800BD36C.bin.o(.data); }
    .main_800BF29C 0x800BF29C : AT(0x000BFE9C) { build/asm/data/main_800BF29C.bin.o(.data); }
    .main_800C5470 0x800C5470 : AT(0x000C6070) { FILL(0x00000000); build/asm/main_800C5470.s.o(.text); build/asm/main_800C5470.s.o(.rodata); build/asm/main_800C5470.s.o(.data); }
    .main_800C5470_bss (NOLOAD) : { build/asm/main_800C5470.s.o(.bss); }
    .main_800C5480 0x800C5480 : AT(0x000C6080) { build/asm/data/main_800C5480.bin.o(.data); }
    .main_800C9F60 0x800C9F60 : AT(0x000CAB60) { build/asm/data/main_800C9F60.bin.o(.data); }
    .main_800CB09C 0x800CB09C : AT(0x000CBC9C) { FILL(0x00000000); build/asm/main_800CB09C.s.o(.text); build/asm/main_800CB09C.s.o(.rodata); build/asm/main_800CB09C.s.o(.data); }
    .main_800CB09C_bss (NOLOAD) : { build/asm/main_800CB09C.s.o(.bss); }
    .main_800CB0D0 0x800CB0D0 : AT(0x000CBCD0) { build/asm/data/main_800CB0D0.bin.o(.data); }
    .main_800DD5D8 0x800DD5D8 : AT(0x000DE1D8) { build/asm/data/main_800DD5D8.bin.o(.data); }
    .main_800E1848 0x800E1848 : AT(0x000E2448) { FILL(0x00000000); build/asm/main_800E1848.s.o(.text); build/asm/main_800E1848.s.o(.rodata); build/asm/main_800E1848.s.o(.data); }
    .main_800E1848_bss (NOLOAD) : { build/asm/main_800E1848.s.o(.bss); }
    .main_800E184C 0x800E184C : AT(0x000E244C) { build/asm/data/main_800E184C.bin.o(.data); }
    .main_800E8430 0x800E8430 : AT(0x000E9030) { build/asm/data/main_800E8430.bin.o(.data); }
    .main_800FBC08 0x800FBC08 : AT(0x000FC808) { build/asm/data/main_800FBC08.bin.o(.data); }
    .main_800FC1DC 0x800FC1DC : AT(0x000FCDDC) { build/asm/data/main_800FC1DC.bin.o(.data); }
    .main_800FD498 0x800FD498 : AT(0x000FE098) { build/asm/data/main_800FD498.bin.o(.data); }
    .main_800FF7B0 0x800FF7B0 : AT(0x001003B0) { build/asm/data/main_800FF7B0.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
