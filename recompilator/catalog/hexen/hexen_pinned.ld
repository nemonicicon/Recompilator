SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_8004B400 0x8004B400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_8004B400.s.o(.text); build/asm/main_8004B400.s.o(.rodata); build/asm/main_8004B400.s.o(.data); }
    .main_8004B400_bss (NOLOAD) : { build/asm/main_8004B400.s.o(.bss); }
    .main_8004B4AC 0x8004B4AC : AT(0x000010AC) { FILL(0x00000000); build/asm/main_8004B4AC.s.o(.text); build/asm/main_8004B4AC.s.o(.rodata); build/asm/main_8004B4AC.s.o(.data); }
    .main_8004B4AC_bss (NOLOAD) : { build/asm/main_8004B4AC.s.o(.bss); }
    .main_8005A544 0x8005A544 : AT(0x00010144) { FILL(0x00000000); build/asm/main_8005A544.s.o(.text); build/asm/main_8005A544.s.o(.rodata); build/asm/main_8005A544.s.o(.data); }
    .main_8005A544_bss (NOLOAD) : { build/asm/main_8005A544.s.o(.bss); }
    .main_8005A910 0x8005A910 : AT(0x00010510) { FILL(0x00000000); build/asm/main_8005A910.s.o(.text); build/asm/main_8005A910.s.o(.rodata); build/asm/main_8005A910.s.o(.data); }
    .main_8005A910_bss (NOLOAD) : { build/asm/main_8005A910.s.o(.bss); }
    .main_8006A970 0x8006A970 : AT(0x00020570) { build/asm/data/main_8006A970.bin.o(.data); }
    .main_8006B170 0x8006B170 : AT(0x00020D70) { build/asm/data/main_8006B170.bin.o(.data); }
    .main_8006B5C0 0x8006B5C0 : AT(0x000211C0) { FILL(0x00000000); build/asm/main_8006B5C0.s.o(.text); build/asm/main_8006B5C0.s.o(.rodata); build/asm/main_8006B5C0.s.o(.data); }
    .main_8006B5C0_bss (NOLOAD) : { build/asm/main_8006B5C0.s.o(.bss); }
    .main_8006BD40 0x8006BD40 : AT(0x00021940) { FILL(0x00000000); build/asm/main_8006BD40.s.o(.text); build/asm/main_8006BD40.s.o(.rodata); build/asm/main_8006BD40.s.o(.data); }
    .main_8006BD40_bss (NOLOAD) : { build/asm/main_8006BD40.s.o(.bss); }
    .main_8007003C 0x8007003C : AT(0x00025C3C) { FILL(0x00000000); build/asm/main_8007003C.s.o(.text); build/asm/main_8007003C.s.o(.rodata); build/asm/main_8007003C.s.o(.data); }
    .main_8007003C_bss (NOLOAD) : { build/asm/main_8007003C.s.o(.bss); }
    .main_80077D00 0x80077D00 : AT(0x0002D900) { FILL(0x00000000); build/asm/main_80077D00.s.o(.text); build/asm/main_80077D00.s.o(.rodata); build/asm/main_80077D00.s.o(.data); }
    .main_80077D00_bss (NOLOAD) : { build/asm/main_80077D00.s.o(.bss); }
    .main_80077D10 0x80077D10 : AT(0x0002D910) { build/asm/data/main_80077D10.bin.o(.data); }
    .main_80077DC0 0x80077DC0 : AT(0x0002D9C0) { FILL(0x00000000); build/asm/main_80077DC0.s.o(.text); build/asm/main_80077DC0.s.o(.rodata); build/asm/main_80077DC0.s.o(.data); }
    .main_80077DC0_bss (NOLOAD) : { build/asm/main_80077DC0.s.o(.bss); }
    .main_80077E00 0x80077E00 : AT(0x0002DA00) { build/asm/data/main_80077E00.bin.o(.data); }
    .main_80077E80 0x80077E80 : AT(0x0002DA80) { FILL(0x00000000); build/asm/main_80077E80.s.o(.text); build/asm/main_80077E80.s.o(.rodata); build/asm/main_80077E80.s.o(.data); }
    .main_80077E80_bss (NOLOAD) : { build/asm/main_80077E80.s.o(.bss); }
    .main_80077E90 0x80077E90 : AT(0x0002DA90) { build/asm/data/main_80077E90.bin.o(.data); }
    .main_80078020 0x80078020 : AT(0x0002DC20) { FILL(0x00000000); build/asm/main_80078020.s.o(.text); build/asm/main_80078020.s.o(.rodata); build/asm/main_80078020.s.o(.data); }
    .main_80078020_bss (NOLOAD) : { build/asm/main_80078020.s.o(.bss); }
    .main_80078030 0x80078030 : AT(0x0002DC30) { build/asm/data/main_80078030.bin.o(.data); }
    .main_8007890C 0x8007890C : AT(0x0002E50C) { FILL(0x00000000); build/asm/main_8007890C.s.o(.text); build/asm/main_8007890C.s.o(.rodata); build/asm/main_8007890C.s.o(.data); }
    .main_8007890C_bss (NOLOAD) : { build/asm/main_8007890C.s.o(.bss); }
    .main_8007891C 0x8007891C : AT(0x0002E51C) { build/asm/data/main_8007891C.bin.o(.data); }
    .main_800789B0 0x800789B0 : AT(0x0002E5B0) { FILL(0x00000000); build/asm/main_800789B0.s.o(.text); build/asm/main_800789B0.s.o(.rodata); build/asm/main_800789B0.s.o(.data); }
    .main_800789B0_bss (NOLOAD) : { build/asm/main_800789B0.s.o(.bss); }
    .main_800789CC 0x800789CC : AT(0x0002E5CC) { build/asm/data/main_800789CC.bin.o(.data); }
    .main_80078B0C 0x80078B0C : AT(0x0002E70C) { FILL(0x00000000); build/asm/main_80078B0C.s.o(.text); build/asm/main_80078B0C.s.o(.rodata); build/asm/main_80078B0C.s.o(.data); }
    .main_80078B0C_bss (NOLOAD) : { build/asm/main_80078B0C.s.o(.bss); }
    .main_80078B1C 0x80078B1C : AT(0x0002E71C) { build/asm/data/main_80078B1C.bin.o(.data); }
    .main_80079F5C 0x80079F5C : AT(0x0002FB5C) { FILL(0x00000000); build/asm/main_80079F5C.s.o(.text); build/asm/main_80079F5C.s.o(.rodata); build/asm/main_80079F5C.s.o(.data); }
    .main_80079F5C_bss (NOLOAD) : { build/asm/main_80079F5C.s.o(.bss); }
    .main_80079F6C 0x80079F6C : AT(0x0002FB6C) { build/asm/data/main_80079F6C.bin.o(.data); }
    .main_8007A22C 0x8007A22C : AT(0x0002FE2C) { FILL(0x00000000); build/asm/main_8007A22C.s.o(.text); build/asm/main_8007A22C.s.o(.rodata); build/asm/main_8007A22C.s.o(.data); }
    .main_8007A22C_bss (NOLOAD) : { build/asm/main_8007A22C.s.o(.bss); }
    .main_8007A23C 0x8007A23C : AT(0x0002FE3C) { build/asm/data/main_8007A23C.bin.o(.data); }
    .main_8007A29C 0x8007A29C : AT(0x0002FE9C) { FILL(0x00000000); build/asm/main_8007A29C.s.o(.text); build/asm/main_8007A29C.s.o(.rodata); build/asm/main_8007A29C.s.o(.data); }
    .main_8007A29C_bss (NOLOAD) : { build/asm/main_8007A29C.s.o(.bss); }
    .main_8007A2AC 0x8007A2AC : AT(0x0002FEAC) { build/asm/data/main_8007A2AC.bin.o(.data); }
    .main_8007ADE8 0x8007ADE8 : AT(0x000309E8) { FILL(0x00000000); build/asm/main_8007ADE8.s.o(.text); build/asm/main_8007ADE8.s.o(.rodata); build/asm/main_8007ADE8.s.o(.data); }
    .main_8007ADE8_bss (NOLOAD) : { build/asm/main_8007ADE8.s.o(.bss); }
    .main_8007ADF8 0x8007ADF8 : AT(0x000309F8) { build/asm/data/main_8007ADF8.bin.o(.data); }
    .main_8007AEE8 0x8007AEE8 : AT(0x00030AE8) { FILL(0x00000000); build/asm/main_8007AEE8.s.o(.text); build/asm/main_8007AEE8.s.o(.rodata); build/asm/main_8007AEE8.s.o(.data); }
    .main_8007AEE8_bss (NOLOAD) : { build/asm/main_8007AEE8.s.o(.bss); }
    .main_8007AEFC 0x8007AEFC : AT(0x00030AFC) { build/asm/data/main_8007AEFC.bin.o(.data); }
    .main_8007B038 0x8007B038 : AT(0x00030C38) { FILL(0x00000000); build/asm/main_8007B038.s.o(.text); build/asm/main_8007B038.s.o(.rodata); build/asm/main_8007B038.s.o(.data); }
    .main_8007B038_bss (NOLOAD) : { build/asm/main_8007B038.s.o(.bss); }
    .main_8007B068 0x8007B068 : AT(0x00030C68) { build/asm/data/main_8007B068.bin.o(.data); }
    .main_8007BD48 0x8007BD48 : AT(0x00031948) { FILL(0x00000000); build/asm/main_8007BD48.s.o(.text); build/asm/main_8007BD48.s.o(.rodata); build/asm/main_8007BD48.s.o(.data); }
    .main_8007BD48_bss (NOLOAD) : { build/asm/main_8007BD48.s.o(.bss); }
    .main_8007C334 0x8007C334 : AT(0x00031F34) { FILL(0x00000000); build/asm/main_8007C334.s.o(.text); build/asm/main_8007C334.s.o(.rodata); build/asm/main_8007C334.s.o(.data); }
    .main_8007C334_bss (NOLOAD) : { build/asm/main_8007C334.s.o(.bss); }
    .main_8007C4A0 0x8007C4A0 : AT(0x000320A0) { build/asm/data/main_8007C4A0.bin.o(.data); }
    .main_8007CBEC 0x8007CBEC : AT(0x000327EC) { FILL(0x00000000); build/asm/main_8007CBEC.s.o(.text); build/asm/main_8007CBEC.s.o(.rodata); build/asm/main_8007CBEC.s.o(.data); }
    .main_8007CBEC_bss (NOLOAD) : { build/asm/main_8007CBEC.s.o(.bss); }
    .main_8007CC0C 0x8007CC0C : AT(0x0003280C) { build/asm/data/main_8007CC0C.bin.o(.data); }
    .main_8007CD08 0x8007CD08 : AT(0x00032908) { FILL(0x00000000); build/asm/main_8007CD08.s.o(.text); build/asm/main_8007CD08.s.o(.rodata); build/asm/main_8007CD08.s.o(.data); }
    .main_8007CD08_bss (NOLOAD) : { build/asm/main_8007CD08.s.o(.bss); }
    .main_8007CD28 0x8007CD28 : AT(0x00032928) { build/asm/data/main_8007CD28.bin.o(.data); }
    .main_8007D078 0x8007D078 : AT(0x00032C78) { FILL(0x00000000); build/asm/main_8007D078.s.o(.text); build/asm/main_8007D078.s.o(.rodata); build/asm/main_8007D078.s.o(.data); }
    .main_8007D078_bss (NOLOAD) : { build/asm/main_8007D078.s.o(.bss); }
    .main_8007D0A8 0x8007D0A8 : AT(0x00032CA8) { build/asm/data/main_8007D0A8.bin.o(.data); }
    .main_8007D1C8 0x8007D1C8 : AT(0x00032DC8) { FILL(0x00000000); build/asm/main_8007D1C8.s.o(.text); build/asm/main_8007D1C8.s.o(.rodata); build/asm/main_8007D1C8.s.o(.data); }
    .main_8007D1C8_bss (NOLOAD) : { build/asm/main_8007D1C8.s.o(.bss); }
    .main_8007D1E4 0x8007D1E4 : AT(0x00032DE4) { build/asm/data/main_8007D1E4.bin.o(.data); }
    .main_8007D278 0x8007D278 : AT(0x00032E78) { FILL(0x00000000); build/asm/main_8007D278.s.o(.text); build/asm/main_8007D278.s.o(.rodata); build/asm/main_8007D278.s.o(.data); }
    .main_8007D278_bss (NOLOAD) : { build/asm/main_8007D278.s.o(.bss); }
    .main_8007D29C 0x8007D29C : AT(0x00032E9C) { build/asm/data/main_8007D29C.bin.o(.data); }
    .main_8007D518 0x8007D518 : AT(0x00033118) { FILL(0x00000000); build/asm/main_8007D518.s.o(.text); build/asm/main_8007D518.s.o(.rodata); build/asm/main_8007D518.s.o(.data); }
    .main_8007D518_bss (NOLOAD) : { build/asm/main_8007D518.s.o(.bss); }
    .main_8007D530 0x8007D530 : AT(0x00033130) { build/asm/data/main_8007D530.bin.o(.data); }
    .main_8007D7B0 0x8007D7B0 : AT(0x000333B0) { FILL(0x00000000); build/asm/main_8007D7B0.s.o(.text); build/asm/main_8007D7B0.s.o(.rodata); build/asm/main_8007D7B0.s.o(.data); }
    .main_8007D7B0_bss (NOLOAD) : { build/asm/main_8007D7B0.s.o(.bss); }
    .main_8007D7C0 0x8007D7C0 : AT(0x000333C0) { build/asm/data/main_8007D7C0.bin.o(.data); }
    .main_8007D8BC 0x8007D8BC : AT(0x000334BC) { FILL(0x00000000); build/asm/main_8007D8BC.s.o(.text); build/asm/main_8007D8BC.s.o(.rodata); build/asm/main_8007D8BC.s.o(.data); }
    .main_8007D8BC_bss (NOLOAD) : { build/asm/main_8007D8BC.s.o(.bss); }
    .main_8007D8DC 0x8007D8DC : AT(0x000334DC) { build/asm/data/main_8007D8DC.bin.o(.data); }
    .main_8007D978 0x8007D978 : AT(0x00033578) { FILL(0x00000000); build/asm/main_8007D978.s.o(.text); build/asm/main_8007D978.s.o(.rodata); build/asm/main_8007D978.s.o(.data); }
    .main_8007D978_bss (NOLOAD) : { build/asm/main_8007D978.s.o(.bss); }
    .main_8007D98C 0x8007D98C : AT(0x0003358C) { build/asm/data/main_8007D98C.bin.o(.data); }
    .main_8007DAB8 0x8007DAB8 : AT(0x000336B8) { FILL(0x00000000); build/asm/main_8007DAB8.s.o(.text); build/asm/main_8007DAB8.s.o(.rodata); build/asm/main_8007DAB8.s.o(.data); }
    .main_8007DAB8_bss (NOLOAD) : { build/asm/main_8007DAB8.s.o(.bss); }
    .main_8007DAD8 0x8007DAD8 : AT(0x000336D8) { build/asm/data/main_8007DAD8.bin.o(.data); }
    .main_8007DB08 0x8007DB08 : AT(0x00033708) { FILL(0x00000000); build/asm/main_8007DB08.s.o(.text); build/asm/main_8007DB08.s.o(.rodata); build/asm/main_8007DB08.s.o(.data); }
    .main_8007DB08_bss (NOLOAD) : { build/asm/main_8007DB08.s.o(.bss); }
    .main_8007E050 0x8007E050 : AT(0x00033C50) { FILL(0x00000000); build/asm/main_8007E050.s.o(.text); build/asm/main_8007E050.s.o(.rodata); build/asm/main_8007E050.s.o(.data); }
    .main_8007E050_bss (NOLOAD) : { build/asm/main_8007E050.s.o(.bss); }
    .main_80080284 0x80080284 : AT(0x00035E84) { FILL(0x00000000); build/asm/main_80080284.s.o(.text); build/asm/main_80080284.s.o(.rodata); build/asm/main_80080284.s.o(.data); }
    .main_80080284_bss (NOLOAD) : { build/asm/main_80080284.s.o(.bss); }
    .main_80082280 0x80082280 : AT(0x00037E80) { FILL(0x00000000); build/asm/main_80082280.s.o(.text); build/asm/main_80082280.s.o(.rodata); build/asm/main_80082280.s.o(.data); }
    .main_80082280_bss (NOLOAD) : { build/asm/main_80082280.s.o(.bss); }
    .main_80082B44 0x80082B44 : AT(0x00038744) { build/asm/data/main_80082B44.bin.o(.data); }
    .main_800830F8 0x800830F8 : AT(0x00038CF8) { build/asm/data/main_800830F8.bin.o(.data); }
    .main_80083C88 0x80083C88 : AT(0x00039888) { build/asm/data/main_80083C88.bin.o(.data); }
    .main_800842B8 0x800842B8 : AT(0x00039EB8) { FILL(0x00000000); build/asm/main_800842B8.s.o(.text); build/asm/main_800842B8.s.o(.rodata); build/asm/main_800842B8.s.o(.data); }
    .main_800842B8_bss (NOLOAD) : { build/asm/main_800842B8.s.o(.bss); }
    .main_80084354 0x80084354 : AT(0x00039F54) { build/asm/data/main_80084354.bin.o(.data); }
    .main_80084BF0 0x80084BF0 : AT(0x0003A7F0) { build/asm/data/main_80084BF0.bin.o(.data); }
    .main_800852F0 0x800852F0 : AT(0x0003AEF0) { build/asm/data/main_800852F0.bin.o(.data); }
    .main_80085448 0x80085448 : AT(0x0003B048) { FILL(0x00000000); build/asm/main_80085448.s.o(.text); build/asm/main_80085448.s.o(.rodata); build/asm/main_80085448.s.o(.data); }
    .main_80085448_bss (NOLOAD) : { build/asm/main_80085448.s.o(.bss); }
    .main_80085450 0x80085450 : AT(0x0003B050) { build/asm/data/main_80085450.bin.o(.data); }
    .main_800856FC 0x800856FC : AT(0x0003B2FC) { FILL(0x00000000); build/asm/main_800856FC.s.o(.text); build/asm/main_800856FC.s.o(.rodata); build/asm/main_800856FC.s.o(.data); }
    .main_800856FC_bss (NOLOAD) : { build/asm/main_800856FC.s.o(.bss); }
    .main_8008574C 0x8008574C : AT(0x0003B34C) { build/asm/data/main_8008574C.bin.o(.data); }
    .main_80085B14 0x80085B14 : AT(0x0003B714) { FILL(0x00000000); build/asm/main_80085B14.s.o(.text); build/asm/main_80085B14.s.o(.rodata); build/asm/main_80085B14.s.o(.data); }
    .main_80085B14_bss (NOLOAD) : { build/asm/main_80085B14.s.o(.bss); }
    .main_80085BC8 0x80085BC8 : AT(0x0003B7C8) { build/asm/data/main_80085BC8.bin.o(.data); }
    .main_80086B98 0x80086B98 : AT(0x0003C798) { FILL(0x00000000); build/asm/main_80086B98.s.o(.text); build/asm/main_80086B98.s.o(.rodata); build/asm/main_80086B98.s.o(.data); }
    .main_80086B98_bss (NOLOAD) : { build/asm/main_80086B98.s.o(.bss); }
    .main_80086C3C 0x80086C3C : AT(0x0003C83C) { build/asm/data/main_80086C3C.bin.o(.data); }
    .main_80087178 0x80087178 : AT(0x0003CD78) { FILL(0x00000000); build/asm/main_80087178.s.o(.text); build/asm/main_80087178.s.o(.rodata); build/asm/main_80087178.s.o(.data); }
    .main_80087178_bss (NOLOAD) : { build/asm/main_80087178.s.o(.bss); }
    .main_800871CC 0x800871CC : AT(0x0003CDCC) { build/asm/data/main_800871CC.bin.o(.data); }
    .main_80087510 0x80087510 : AT(0x0003D110) { build/asm/data/main_80087510.bin.o(.data); }
    .main_80087AD0 0x80087AD0 : AT(0x0003D6D0) { build/asm/data/main_80087AD0.bin.o(.data); }
    .main_80087C2C 0x80087C2C : AT(0x0003D82C) { build/asm/data/main_80087C2C.bin.o(.data); }
    .main_80087F84 0x80087F84 : AT(0x0003DB84) { FILL(0x00000000); build/asm/main_80087F84.s.o(.text); build/asm/main_80087F84.s.o(.rodata); build/asm/main_80087F84.s.o(.data); }
    .main_80087F84_bss (NOLOAD) : { build/asm/main_80087F84.s.o(.bss); }
    .main_80087FB8 0x80087FB8 : AT(0x0003DBB8) { build/asm/data/main_80087FB8.bin.o(.data); }
    .main_80088644 0x80088644 : AT(0x0003E244) { FILL(0x00000000); build/asm/main_80088644.s.o(.text); build/asm/main_80088644.s.o(.rodata); build/asm/main_80088644.s.o(.data); }
    .main_80088644_bss (NOLOAD) : { build/asm/main_80088644.s.o(.bss); }
    .main_80088674 0x80088674 : AT(0x0003E274) { build/asm/data/main_80088674.bin.o(.data); }
    .main_80089620 0x80089620 : AT(0x0003F220) { FILL(0x00000000); build/asm/main_80089620.s.o(.text); build/asm/main_80089620.s.o(.rodata); build/asm/main_80089620.s.o(.data); }
    .main_80089620_bss (NOLOAD) : { build/asm/main_80089620.s.o(.bss); }
    .main_80089894 0x80089894 : AT(0x0003F494) { build/asm/data/main_80089894.bin.o(.data); }
    .main_80089D58 0x80089D58 : AT(0x0003F958) { FILL(0x00000000); build/asm/main_80089D58.s.o(.text); build/asm/main_80089D58.s.o(.rodata); build/asm/main_80089D58.s.o(.data); }
    .main_80089D58_bss (NOLOAD) : { build/asm/main_80089D58.s.o(.bss); }
    .main_80089D88 0x80089D88 : AT(0x0003F988) { build/asm/data/main_80089D88.bin.o(.data); }
    .main_80097BFC 0x80097BFC : AT(0x0004D7FC) { build/asm/data/main_80097BFC.bin.o(.data); }
    .main_8009E398 0x8009E398 : AT(0x00053F98) { FILL(0x00000000); build/asm/main_8009E398.s.o(.text); build/asm/main_8009E398.s.o(.rodata); build/asm/main_8009E398.s.o(.data); }
    .main_8009E398_bss (NOLOAD) : { build/asm/main_8009E398.s.o(.bss); }
    .main_8009E3A8 0x8009E3A8 : AT(0x00053FA8) { build/asm/data/main_8009E3A8.bin.o(.data); }
    .main_800A7A64 0x800A7A64 : AT(0x0005D664) { FILL(0x00000000); build/asm/main_800A7A64.s.o(.text); build/asm/main_800A7A64.s.o(.rodata); build/asm/main_800A7A64.s.o(.data); }
    .main_800A7A64_bss (NOLOAD) : { build/asm/main_800A7A64.s.o(.bss); }
    .main_800A7AB4 0x800A7AB4 : AT(0x0005D6B4) { build/asm/data/main_800A7AB4.bin.o(.data); }
    .main_800BF810 0x800BF810 : AT(0x00075410) { FILL(0x00000000); build/asm/main_800BF810.s.o(.text); build/asm/main_800BF810.s.o(.rodata); build/asm/main_800BF810.s.o(.data); }
    .main_800BF810_bss (NOLOAD) : { build/asm/main_800BF810.s.o(.bss); }
    .main_800BF83C 0x800BF83C : AT(0x0007543C) { build/asm/data/main_800BF83C.bin.o(.data); }
    .main_800C2730 0x800C2730 : AT(0x00078330) { build/asm/data/main_800C2730.bin.o(.data); }
    .main_800CA8E0 0x800CA8E0 : AT(0x000804E0) { build/asm/data/main_800CA8E0.bin.o(.data); }
    .main_800CAEA0 0x800CAEA0 : AT(0x00080AA0) { FILL(0x00000000); build/asm/main_800CAEA0.s.o(.text); build/asm/main_800CAEA0.s.o(.rodata); build/asm/main_800CAEA0.s.o(.data); }
    .main_800CAEA0_bss (NOLOAD) : { build/asm/main_800CAEA0.s.o(.bss); }
    .main_800CAEB8 0x800CAEB8 : AT(0x00080AB8) { build/asm/data/main_800CAEB8.bin.o(.data); }
    .main_800CBBE0 0x800CBBE0 : AT(0x000817E0) { FILL(0x00000000); build/asm/main_800CBBE0.s.o(.text); build/asm/main_800CBBE0.s.o(.rodata); build/asm/main_800CBBE0.s.o(.data); }
    .main_800CBBE0_bss (NOLOAD) : { build/asm/main_800CBBE0.s.o(.bss); }
    .main_800CBF1C 0x800CBF1C : AT(0x00081B1C) { build/asm/data/main_800CBF1C.bin.o(.data); }
    .main_800CBFE0 0x800CBFE0 : AT(0x00081BE0) { FILL(0x00000000); build/asm/main_800CBFE0.s.o(.text); build/asm/main_800CBFE0.s.o(.rodata); build/asm/main_800CBFE0.s.o(.data); }
    .main_800CBFE0_bss (NOLOAD) : { build/asm/main_800CBFE0.s.o(.bss); }
    .main_800CBFE4 0x800CBFE4 : AT(0x00081BE4) { build/asm/data/main_800CBFE4.bin.o(.data); }
    .main_800CCC70 0x800CCC70 : AT(0x00082870) { build/asm/data/main_800CCC70.bin.o(.data); }
    .main_800CD60C 0x800CD60C : AT(0x0008320C) { build/asm/data/main_800CD60C.bin.o(.data); }
    .main_800CE2C8 0x800CE2C8 : AT(0x00083EC8) { build/asm/data/main_800CE2C8.bin.o(.data); }
    .main_800CF164 0x800CF164 : AT(0x00084D64) { build/asm/data/main_800CF164.bin.o(.data); }
    .main_800CF290 0x800CF290 : AT(0x00084E90) { build/asm/data/main_800CF290.bin.o(.data); }
    .main_800CF4E0 0x800CF4E0 : AT(0x000850E0) { build/asm/data/main_800CF4E0.bin.o(.data); }
    .main_800D00E0 0x800D00E0 : AT(0x00085CE0) { build/asm/data/main_800D00E0.bin.o(.data); }
    .main_800D0128 0x800D0128 : AT(0x00085D28) { build/asm/data/main_800D0128.bin.o(.data); }
    .main_800D12D0 0x800D12D0 : AT(0x00086ED0) { build/asm/data/main_800D12D0.bin.o(.data); }
    .main_800D12E0 0x800D12E0 : AT(0x00086EE0) { build/asm/data/main_800D12E0.bin.o(.data); }
    .main_800D3F88 0x800D3F88 : AT(0x00089B88) { build/asm/data/main_800D3F88.bin.o(.data); }
    .main_800D3FAC 0x800D3FAC : AT(0x00089BAC) { build/asm/data/main_800D3FAC.bin.o(.data); }
    .main_800D49A4 0x800D49A4 : AT(0x0008A5A4) { build/asm/data/main_800D49A4.bin.o(.data); }
    .main_800D49D4 0x800D49D4 : AT(0x0008A5D4) { build/asm/data/main_800D49D4.bin.o(.data); }
    .main_800D94B8 0x800D94B8 : AT(0x0008F0B8) { build/asm/data/main_800D94B8.bin.o(.data); }
    .main_800D94E8 0x800D94E8 : AT(0x0008F0E8) { build/asm/data/main_800D94E8.bin.o(.data); }
    .main_800DC674 0x800DC674 : AT(0x00092274) { build/asm/data/main_800DC674.bin.o(.data); }
    .main_800DC708 0x800DC708 : AT(0x00092308) { build/asm/data/main_800DC708.bin.o(.data); }
    .main_800E5988 0x800E5988 : AT(0x0009B588) { build/asm/data/main_800E5988.bin.o(.data); }
    .main_800E5990 0x800E5990 : AT(0x0009B590) { build/asm/data/main_800E5990.bin.o(.data); }
    .main_80101BC8 0x80101BC8 : AT(0x000B77C8) { build/asm/data/main_80101BC8.bin.o(.data); }
    .main_80101BE8 0x80101BE8 : AT(0x000B77E8) { build/asm/data/main_80101BE8.bin.o(.data); }
    .main_80108A6C 0x80108A6C : AT(0x000BE66C) { build/asm/data/main_80108A6C.bin.o(.data); }
    .main_80108AA8 0x80108AA8 : AT(0x000BE6A8) { build/asm/data/main_80108AA8.bin.o(.data); }
    .main_8010FF7C 0x8010FF7C : AT(0x000C5B7C) { build/asm/data/main_8010FF7C.bin.o(.data); }
    .main_8010FFA0 0x8010FFA0 : AT(0x000C5BA0) { build/asm/data/main_8010FFA0.bin.o(.data); }
    .main_80111E20 0x80111E20 : AT(0x000C7A20) { build/asm/data/main_80111E20.bin.o(.data); }
    .main_80111E48 0x80111E48 : AT(0x000C7A48) { build/asm/data/main_80111E48.bin.o(.data); }
    .main_80115578 0x80115578 : AT(0x000CB178) { build/asm/data/main_80115578.bin.o(.data); }
    .main_80115598 0x80115598 : AT(0x000CB198) { build/asm/data/main_80115598.bin.o(.data); }
    .main_8012D6E0 0x8012D6E0 : AT(0x000E32E0) { FILL(0x00000000); build/asm/main_8012D6E0.s.o(.text); build/asm/main_8012D6E0.s.o(.rodata); build/asm/main_8012D6E0.s.o(.data); }
    .main_8012D6E0_bss (NOLOAD) : { build/asm/main_8012D6E0.s.o(.bss); }
    .main_8012D708 0x8012D708 : AT(0x000E3308) { build/asm/data/main_8012D708.bin.o(.data); }
    .main_80131FB8 0x80131FB8 : AT(0x000E7BB8) { FILL(0x00000000); build/asm/main_80131FB8.s.o(.text); build/asm/main_80131FB8.s.o(.rodata); build/asm/main_80131FB8.s.o(.data); }
    .main_80131FB8_bss (NOLOAD) : { build/asm/main_80131FB8.s.o(.bss); }
    .main_80131FFC 0x80131FFC : AT(0x000E7BFC) { build/asm/data/main_80131FFC.bin.o(.data); }
    .main_80132800 0x80132800 : AT(0x000E8400) { build/asm/data/main_80132800.bin.o(.data); }
    .main_8013768C 0x8013768C : AT(0x000ED28C) { build/asm/data/main_8013768C.bin.o(.data); }
    .main_80138A54 0x80138A54 : AT(0x000EE654) { build/asm/data/main_80138A54.bin.o(.data); }
    .main_8013CA84 0x8013CA84 : AT(0x000F2684) { build/asm/data/main_8013CA84.bin.o(.data); }
    .main_8013DE3C 0x8013DE3C : AT(0x000F3A3C) { build/asm/data/main_8013DE3C.bin.o(.data); }
    .main_80146CDC 0x80146CDC : AT(0x000FC8DC) { build/asm/data/main_80146CDC.bin.o(.data); }
    .main_801496A4 0x801496A4 : AT(0x000FF2A4) { build/asm/data/main_801496A4.bin.o(.data); }
    .main_8014AF68 0x8014AF68 : AT(0x00100B68) { build/asm/data/main_8014AF68.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
