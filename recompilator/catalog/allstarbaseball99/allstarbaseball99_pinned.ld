SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80300000 0x80300000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80300000.s.o(.text); build/asm/main_80300000.s.o(.rodata); build/asm/main_80300000.s.o(.data); }
    .main_80300000_bss (NOLOAD) : { build/asm/main_80300000.s.o(.bss); }
    .main_80300068 0x80300068 : AT(0x00001068) { FILL(0x00000000); build/asm/main_80300068.s.o(.text); build/asm/main_80300068.s.o(.rodata); build/asm/main_80300068.s.o(.data); }
    .main_80300068_bss (NOLOAD) : { build/asm/main_80300068.s.o(.bss); }
    .main_80301918 0x80301918 : AT(0x00002918) { FILL(0x00000000); build/asm/main_80301918.s.o(.text); build/asm/main_80301918.s.o(.rodata); build/asm/main_80301918.s.o(.data); }
    .main_80301918_bss (NOLOAD) : { build/asm/main_80301918.s.o(.bss); }
    .main_80301EC0 0x80301EC0 : AT(0x00002EC0) { FILL(0x00000000); build/asm/main_80301EC0.s.o(.text); build/asm/main_80301EC0.s.o(.rodata); build/asm/main_80301EC0.s.o(.data); }
    .main_80301EC0_bss (NOLOAD) : { build/asm/main_80301EC0.s.o(.bss); }
    .main_803022F4 0x803022F4 : AT(0x000032F4) { build/asm/data/main_803022F4.bin.o(.data); }
    .main_80302744 0x80302744 : AT(0x00003744) { FILL(0x00000000); build/asm/main_80302744.s.o(.text); build/asm/main_80302744.s.o(.rodata); build/asm/main_80302744.s.o(.data); }
    .main_80302744_bss (NOLOAD) : { build/asm/main_80302744.s.o(.bss); }
    .main_80303178 0x80303178 : AT(0x00004178) { build/asm/data/main_80303178.bin.o(.data); }
    .main_80303BDC 0x80303BDC : AT(0x00004BDC) { FILL(0x00000000); build/asm/main_80303BDC.s.o(.text); build/asm/main_80303BDC.s.o(.rodata); build/asm/main_80303BDC.s.o(.data); }
    .main_80303BDC_bss (NOLOAD) : { build/asm/main_80303BDC.s.o(.bss); }
    .main_803041CC 0x803041CC : AT(0x000051CC) { build/asm/data/main_803041CC.bin.o(.data); }
    .main_80307E50 0x80307E50 : AT(0x00008E50) { FILL(0x00000000); build/asm/main_80307E50.s.o(.text); build/asm/main_80307E50.s.o(.rodata); build/asm/main_80307E50.s.o(.data); }
    .main_80307E50_bss (NOLOAD) : { build/asm/main_80307E50.s.o(.bss); }
    .main_80307E84 0x80307E84 : AT(0x00008E84) { build/asm/data/main_80307E84.bin.o(.data); }
    .main_8031125C 0x8031125C : AT(0x0001225C) { FILL(0x00000000); build/asm/main_8031125C.s.o(.text); build/asm/main_8031125C.s.o(.rodata); build/asm/main_8031125C.s.o(.data); }
    .main_8031125C_bss (NOLOAD) : { build/asm/main_8031125C.s.o(.bss); }
    .main_80311318 0x80311318 : AT(0x00012318) { build/asm/data/main_80311318.bin.o(.data); }
    .main_80313AC4 0x80313AC4 : AT(0x00014AC4) { FILL(0x00000000); build/asm/main_80313AC4.s.o(.text); build/asm/main_80313AC4.s.o(.rodata); build/asm/main_80313AC4.s.o(.data); }
    .main_80313AC4_bss (NOLOAD) : { build/asm/main_80313AC4.s.o(.bss); }
    .main_80313AD4 0x80313AD4 : AT(0x00014AD4) { build/asm/data/main_80313AD4.bin.o(.data); }
    .main_803249A8 0x803249A8 : AT(0x000259A8) { FILL(0x00000000); build/asm/main_803249A8.s.o(.text); build/asm/main_803249A8.s.o(.rodata); build/asm/main_803249A8.s.o(.data); }
    .main_803249A8_bss (NOLOAD) : { build/asm/main_803249A8.s.o(.bss); }
    .main_803249C4 0x803249C4 : AT(0x000259C4) { build/asm/data/main_803249C4.bin.o(.data); }
    .main_80327CDC 0x80327CDC : AT(0x00028CDC) { FILL(0x00000000); build/asm/main_80327CDC.s.o(.text); build/asm/main_80327CDC.s.o(.rodata); build/asm/main_80327CDC.s.o(.data); }
    .main_80327CDC_bss (NOLOAD) : { build/asm/main_80327CDC.s.o(.bss); }
    .main_80327CF8 0x80327CF8 : AT(0x00028CF8) { build/asm/data/main_80327CF8.bin.o(.data); }
    .main_80333EBC 0x80333EBC : AT(0x00034EBC) { FILL(0x00000000); build/asm/main_80333EBC.s.o(.text); build/asm/main_80333EBC.s.o(.rodata); build/asm/main_80333EBC.s.o(.data); }
    .main_80333EBC_bss (NOLOAD) : { build/asm/main_80333EBC.s.o(.bss); }
    .main_80333EDC 0x80333EDC : AT(0x00034EDC) { build/asm/data/main_80333EDC.bin.o(.data); }
    .main_803459B4 0x803459B4 : AT(0x000469B4) { FILL(0x00000000); build/asm/main_803459B4.s.o(.text); build/asm/main_803459B4.s.o(.rodata); build/asm/main_803459B4.s.o(.data); }
    .main_803459B4_bss (NOLOAD) : { build/asm/main_803459B4.s.o(.bss); }
    .main_803459C8 0x803459C8 : AT(0x000469C8) { build/asm/data/main_803459C8.bin.o(.data); }
    .main_80345A8C 0x80345A8C : AT(0x00046A8C) { FILL(0x00000000); build/asm/main_80345A8C.s.o(.text); build/asm/main_80345A8C.s.o(.rodata); build/asm/main_80345A8C.s.o(.data); }
    .main_80345A8C_bss (NOLOAD) : { build/asm/main_80345A8C.s.o(.bss); }
    .main_80345B74 0x80345B74 : AT(0x00046B74) { build/asm/data/main_80345B74.bin.o(.data); }
    .main_80350694 0x80350694 : AT(0x00051694) { FILL(0x00000000); build/asm/main_80350694.s.o(.text); build/asm/main_80350694.s.o(.rodata); build/asm/main_80350694.s.o(.data); }
    .main_80350694_bss (NOLOAD) : { build/asm/main_80350694.s.o(.bss); }
    .main_80350698 0x80350698 : AT(0x00051698) { build/asm/data/main_80350698.bin.o(.data); }
    .main_80359AA8 0x80359AA8 : AT(0x0005AAA8) { FILL(0x00000000); build/asm/main_80359AA8.s.o(.text); build/asm/main_80359AA8.s.o(.rodata); build/asm/main_80359AA8.s.o(.data); }
    .main_80359AA8_bss (NOLOAD) : { build/asm/main_80359AA8.s.o(.bss); }
    .main_80359B2C 0x80359B2C : AT(0x0005AB2C) { build/asm/data/main_80359B2C.bin.o(.data); }
    .main_8035AC5C 0x8035AC5C : AT(0x0005BC5C) { FILL(0x00000000); build/asm/main_8035AC5C.s.o(.text); build/asm/main_8035AC5C.s.o(.rodata); build/asm/main_8035AC5C.s.o(.data); }
    .main_8035AC5C_bss (NOLOAD) : { build/asm/main_8035AC5C.s.o(.bss); }
    .main_8035AD30 0x8035AD30 : AT(0x0005BD30) { build/asm/data/main_8035AD30.bin.o(.data); }
    .main_803640B4 0x803640B4 : AT(0x000650B4) { FILL(0x00000000); build/asm/main_803640B4.s.o(.text); build/asm/main_803640B4.s.o(.rodata); build/asm/main_803640B4.s.o(.data); }
    .main_803640B4_bss (NOLOAD) : { build/asm/main_803640B4.s.o(.bss); }
    .main_8036422C 0x8036422C : AT(0x0006522C) { build/asm/data/main_8036422C.bin.o(.data); }
    .main_80375800 0x80375800 : AT(0x00076800) { FILL(0x00000000); build/asm/main_80375800.s.o(.text); build/asm/main_80375800.s.o(.rodata); build/asm/main_80375800.s.o(.data); }
    .main_80375800_bss (NOLOAD) : { build/asm/main_80375800.s.o(.bss); }
    .main_80375828 0x80375828 : AT(0x00076828) { build/asm/data/main_80375828.bin.o(.data); }
    .main_8038A6FC 0x8038A6FC : AT(0x0008B6FC) { FILL(0x00000000); build/asm/main_8038A6FC.s.o(.text); build/asm/main_8038A6FC.s.o(.rodata); build/asm/main_8038A6FC.s.o(.data); }
    .main_8038A6FC_bss (NOLOAD) : { build/asm/main_8038A6FC.s.o(.bss); }
    .main_8038AF70 0x8038AF70 : AT(0x0008BF70) { build/asm/data/main_8038AF70.bin.o(.data); }
    .main_8038FCD8 0x8038FCD8 : AT(0x00090CD8) { FILL(0x00000000); build/asm/main_8038FCD8.s.o(.text); build/asm/main_8038FCD8.s.o(.rodata); build/asm/main_8038FCD8.s.o(.data); }
    .main_8038FCD8_bss (NOLOAD) : { build/asm/main_8038FCD8.s.o(.bss); }
    .main_8038FE10 0x8038FE10 : AT(0x00090E10) { build/asm/data/main_8038FE10.bin.o(.data); }
    .main_80390820 0x80390820 : AT(0x00091820) { FILL(0x00000000); build/asm/main_80390820.s.o(.text); build/asm/main_80390820.s.o(.rodata); build/asm/main_80390820.s.o(.data); }
    .main_80390820_bss (NOLOAD) : { build/asm/main_80390820.s.o(.bss); }
    .main_8039085C 0x8039085C : AT(0x0009185C) { build/asm/data/main_8039085C.bin.o(.data); }
    .main_803913C8 0x803913C8 : AT(0x000923C8) { FILL(0x00000000); build/asm/main_803913C8.s.o(.text); build/asm/main_803913C8.s.o(.rodata); build/asm/main_803913C8.s.o(.data); }
    .main_803913C8_bss (NOLOAD) : { build/asm/main_803913C8.s.o(.bss); }
    .main_803913FC 0x803913FC : AT(0x000923FC) { build/asm/data/main_803913FC.bin.o(.data); }
    .main_80391520 0x80391520 : AT(0x00092520) { FILL(0x00000000); build/asm/main_80391520.s.o(.text); build/asm/main_80391520.s.o(.rodata); build/asm/main_80391520.s.o(.data); }
    .main_80391520_bss (NOLOAD) : { build/asm/main_80391520.s.o(.bss); }
    .main_8039163C 0x8039163C : AT(0x0009263C) { build/asm/data/main_8039163C.bin.o(.data); }
    .main_80391AF4 0x80391AF4 : AT(0x00092AF4) { FILL(0x00000000); build/asm/main_80391AF4.s.o(.text); build/asm/main_80391AF4.s.o(.rodata); build/asm/main_80391AF4.s.o(.data); }
    .main_80391AF4_bss (NOLOAD) : { build/asm/main_80391AF4.s.o(.bss); }
    .main_80391B14 0x80391B14 : AT(0x00092B14) { build/asm/data/main_80391B14.bin.o(.data); }
    .main_80391CF4 0x80391CF4 : AT(0x00092CF4) { FILL(0x00000000); build/asm/main_80391CF4.s.o(.text); build/asm/main_80391CF4.s.o(.rodata); build/asm/main_80391CF4.s.o(.data); }
    .main_80391CF4_bss (NOLOAD) : { build/asm/main_80391CF4.s.o(.bss); }
    .main_80391D48 0x80391D48 : AT(0x00092D48) { build/asm/data/main_80391D48.bin.o(.data); }
    .main_803927A4 0x803927A4 : AT(0x000937A4) { FILL(0x00000000); build/asm/main_803927A4.s.o(.text); build/asm/main_803927A4.s.o(.rodata); build/asm/main_803927A4.s.o(.data); }
    .main_803927A4_bss (NOLOAD) : { build/asm/main_803927A4.s.o(.bss); }
    .main_80392884 0x80392884 : AT(0x00093884) { build/asm/data/main_80392884.bin.o(.data); }
    .main_803928E0 0x803928E0 : AT(0x000938E0) { FILL(0x00000000); build/asm/main_803928E0.s.o(.text); build/asm/main_803928E0.s.o(.rodata); build/asm/main_803928E0.s.o(.data); }
    .main_803928E0_bss (NOLOAD) : { build/asm/main_803928E0.s.o(.bss); }
    .main_803929F4 0x803929F4 : AT(0x000939F4) { build/asm/data/main_803929F4.bin.o(.data); }
    .main_803A46F8 0x803A46F8 : AT(0x000A56F8) { FILL(0x00000000); build/asm/main_803A46F8.s.o(.text); build/asm/main_803A46F8.s.o(.rodata); build/asm/main_803A46F8.s.o(.data); }
    .main_803A46F8_bss (NOLOAD) : { build/asm/main_803A46F8.s.o(.bss); }
    .main_803A475C 0x803A475C : AT(0x000A575C) { build/asm/data/main_803A475C.bin.o(.data); }
    .main_803AE9D0 0x803AE9D0 : AT(0x000AF9D0) { FILL(0x00000000); build/asm/main_803AE9D0.s.o(.text); build/asm/main_803AE9D0.s.o(.rodata); build/asm/main_803AE9D0.s.o(.data); }
    .main_803AE9D0_bss (NOLOAD) : { build/asm/main_803AE9D0.s.o(.bss); }
    .main_803AE9D8 0x803AE9D8 : AT(0x000AF9D8) { build/asm/data/main_803AE9D8.bin.o(.data); }
    .main_803AEB44 0x803AEB44 : AT(0x000AFB44) { FILL(0x00000000); build/asm/main_803AEB44.s.o(.text); build/asm/main_803AEB44.s.o(.rodata); build/asm/main_803AEB44.s.o(.data); }
    .main_803AEB44_bss (NOLOAD) : { build/asm/main_803AEB44.s.o(.bss); }
    .main_803AEB50 0x803AEB50 : AT(0x000AFB50) { build/asm/data/main_803AEB50.bin.o(.data); }
    .main_803B45C8 0x803B45C8 : AT(0x000B55C8) { FILL(0x00000000); build/asm/main_803B45C8.s.o(.text); build/asm/main_803B45C8.s.o(.rodata); build/asm/main_803B45C8.s.o(.data); }
    .main_803B45C8_bss (NOLOAD) : { build/asm/main_803B45C8.s.o(.bss); }
    .main_803B45D4 0x803B45D4 : AT(0x000B55D4) { build/asm/data/main_803B45D4.bin.o(.data); }
    .main_803BBB80 0x803BBB80 : AT(0x000BCB80) { FILL(0x00000000); build/asm/main_803BBB80.s.o(.text); build/asm/main_803BBB80.s.o(.rodata); build/asm/main_803BBB80.s.o(.data); }
    .main_803BBB80_bss (NOLOAD) : { build/asm/main_803BBB80.s.o(.bss); }
    .main_803BBBA4 0x803BBBA4 : AT(0x000BCBA4) { build/asm/data/main_803BBBA4.bin.o(.data); }
    .main_803D1474 0x803D1474 : AT(0x000D2474) { FILL(0x00000000); build/asm/main_803D1474.s.o(.text); build/asm/main_803D1474.s.o(.rodata); build/asm/main_803D1474.s.o(.data); }
    .main_803D1474_bss (NOLOAD) : { build/asm/main_803D1474.s.o(.bss); }
    .main_803D1490 0x803D1490 : AT(0x000D2490) { build/asm/data/main_803D1490.bin.o(.data); }
    .main_803DC1F4 0x803DC1F4 : AT(0x000DD1F4) { FILL(0x00000000); build/asm/main_803DC1F4.s.o(.text); build/asm/main_803DC1F4.s.o(.rodata); build/asm/main_803DC1F4.s.o(.data); }
    .main_803DC1F4_bss (NOLOAD) : { build/asm/main_803DC1F4.s.o(.bss); }
    .main_803DC204 0x803DC204 : AT(0x000DD204) { build/asm/data/main_803DC204.bin.o(.data); }
    .main_803DCA70 0x803DCA70 : AT(0x000DDA70) { FILL(0x00000000); build/asm/main_803DCA70.s.o(.text); build/asm/main_803DCA70.s.o(.rodata); build/asm/main_803DCA70.s.o(.data); }
    .main_803DCA70_bss (NOLOAD) : { build/asm/main_803DCA70.s.o(.bss); }
    .main_803DCA90 0x803DCA90 : AT(0x000DDA90) { build/asm/data/main_803DCA90.bin.o(.data); }
    .main_803E3034 0x803E3034 : AT(0x000E4034) { FILL(0x00000000); build/asm/main_803E3034.s.o(.text); build/asm/main_803E3034.s.o(.rodata); build/asm/main_803E3034.s.o(.data); }
    .main_803E3034_bss (NOLOAD) : { build/asm/main_803E3034.s.o(.bss); }
    .main_803E3040 0x803E3040 : AT(0x000E4040) { build/asm/data/main_803E3040.bin.o(.data); }
    .main_803F8108 0x803F8108 : AT(0x000F9108) { FILL(0x00000000); build/asm/main_803F8108.s.o(.text); build/asm/main_803F8108.s.o(.rodata); build/asm/main_803F8108.s.o(.data); }
    .main_803F8108_bss (NOLOAD) : { build/asm/main_803F8108.s.o(.bss); }
    .main_803F811C 0x803F811C : AT(0x000F911C) { build/asm/data/main_803F811C.bin.o(.data); }
    .main_803FC0C4 0x803FC0C4 : AT(0x000FD0C4) { FILL(0x00000000); build/asm/main_803FC0C4.s.o(.text); build/asm/main_803FC0C4.s.o(.rodata); build/asm/main_803FC0C4.s.o(.data); }
    .main_803FC0C4_bss (NOLOAD) : { build/asm/main_803FC0C4.s.o(.bss); }
    .main_803FC0C8 0x803FC0C8 : AT(0x000FD0C8) { build/asm/data/main_803FC0C8.bin.o(.data); }
    .assets 0x80700000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
