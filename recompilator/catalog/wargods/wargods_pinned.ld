SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80280200 0x80280200 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80280200.s.o(.text); build/asm/main_80280200.s.o(.rodata); build/asm/main_80280200.s.o(.data); }
    .main_80280200_bss (NOLOAD) : { build/asm/main_80280200.s.o(.bss); }
    .main_80312644 0x80312644 : AT(0x00093444) { FILL(0x00000000); build/asm/main_80312644.s.o(.text); build/asm/main_80312644.s.o(.rodata); build/asm/main_80312644.s.o(.data); }
    .main_80312644_bss (NOLOAD) : { build/asm/main_80312644.s.o(.bss); }
    .main_80312A10 0x80312A10 : AT(0x00093810) { FILL(0x00000000); build/asm/main_80312A10.s.o(.text); build/asm/main_80312A10.s.o(.rodata); build/asm/main_80312A10.s.o(.data); }
    .main_80312A10_bss (NOLOAD) : { build/asm/main_80312A10.s.o(.bss); }
    .main_80317ED0 0x80317ED0 : AT(0x00098CD0) { FILL(0x00000000); build/asm/main_80317ED0.s.o(.text); build/asm/main_80317ED0.s.o(.rodata); build/asm/main_80317ED0.s.o(.data); }
    .main_80317ED0_bss (NOLOAD) : { build/asm/main_80317ED0.s.o(.bss); }
    .main_80318CA0 0x80318CA0 : AT(0x00099AA0) { FILL(0x00000000); build/asm/main_80318CA0.s.o(.text); build/asm/main_80318CA0.s.o(.rodata); build/asm/main_80318CA0.s.o(.data); }
    .main_80318CA0_bss (NOLOAD) : { build/asm/main_80318CA0.s.o(.bss); }
    .main_80319220 0x80319220 : AT(0x0009A020) { FILL(0x00000000); build/asm/main_80319220.s.o(.text); build/asm/main_80319220.s.o(.rodata); build/asm/main_80319220.s.o(.data); }
    .main_80319220_bss (NOLOAD) : { build/asm/main_80319220.s.o(.bss); }
    .main_803197F0 0x803197F0 : AT(0x0009A5F0) { FILL(0x00000000); build/asm/main_803197F0.s.o(.text); build/asm/main_803197F0.s.o(.rodata); build/asm/main_803197F0.s.o(.data); }
    .main_803197F0_bss (NOLOAD) : { build/asm/main_803197F0.s.o(.bss); }
    .main_80319B18 0x80319B18 : AT(0x0009A918) { FILL(0x00000000); build/asm/main_80319B18.s.o(.text); build/asm/main_80319B18.s.o(.rodata); build/asm/main_80319B18.s.o(.data); }
    .main_80319B18_bss (NOLOAD) : { build/asm/main_80319B18.s.o(.bss); }
    .main_8031A750 0x8031A750 : AT(0x0009B550) { FILL(0x00000000); build/asm/main_8031A750.s.o(.text); build/asm/main_8031A750.s.o(.rodata); build/asm/main_8031A750.s.o(.data); }
    .main_8031A750_bss (NOLOAD) : { build/asm/main_8031A750.s.o(.bss); }
    .main_8031A860 0x8031A860 : AT(0x0009B660) { FILL(0x00000000); build/asm/main_8031A860.s.o(.text); build/asm/main_8031A860.s.o(.rodata); build/asm/main_8031A860.s.o(.data); }
    .main_8031A860_bss (NOLOAD) : { build/asm/main_8031A860.s.o(.bss); }
    .main_8031A920 0x8031A920 : AT(0x0009B720) { FILL(0x00000000); build/asm/main_8031A920.s.o(.text); build/asm/main_8031A920.s.o(.rodata); build/asm/main_8031A920.s.o(.data); }
    .main_8031A920_bss (NOLOAD) : { build/asm/main_8031A920.s.o(.bss); }
    .main_8031C988 0x8031C988 : AT(0x0009D788) { FILL(0x00000000); build/asm/main_8031C988.s.o(.text); build/asm/main_8031C988.s.o(.rodata); build/asm/main_8031C988.s.o(.data); }
    .main_8031C988_bss (NOLOAD) : { build/asm/main_8031C988.s.o(.bss); }
    .main_8031CDE0 0x8031CDE0 : AT(0x0009DBE0) { FILL(0x00000000); build/asm/main_8031CDE0.s.o(.text); build/asm/main_8031CDE0.s.o(.rodata); build/asm/main_8031CDE0.s.o(.data); }
    .main_8031CDE0_bss (NOLOAD) : { build/asm/main_8031CDE0.s.o(.bss); }
    .main_8031D520 0x8031D520 : AT(0x0009E320) { build/asm/data/main_8031D520.bin.o(.data); }
    .main_8031F980 0x8031F980 : AT(0x000A0780) { build/asm/data/main_8031F980.bin.o(.data); }
    .main_8031FB0C 0x8031FB0C : AT(0x000A090C) { FILL(0x00000000); build/asm/main_8031FB0C.s.o(.text); build/asm/main_8031FB0C.s.o(.rodata); build/asm/main_8031FB0C.s.o(.data); }
    .main_8031FB0C_bss (NOLOAD) : { build/asm/main_8031FB0C.s.o(.bss); }
    .main_8031FCAC 0x8031FCAC : AT(0x000A0AAC) { build/asm/data/main_8031FCAC.bin.o(.data); }
    .main_80321528 0x80321528 : AT(0x000A2328) { FILL(0x00000000); build/asm/main_80321528.s.o(.text); build/asm/main_80321528.s.o(.rodata); build/asm/main_80321528.s.o(.data); }
    .main_80321528_bss (NOLOAD) : { build/asm/main_80321528.s.o(.bss); }
    .main_803226FC 0x803226FC : AT(0x000A34FC) { FILL(0x00000000); build/asm/main_803226FC.s.o(.text); build/asm/main_803226FC.s.o(.rodata); build/asm/main_803226FC.s.o(.data); }
    .main_803226FC_bss (NOLOAD) : { build/asm/main_803226FC.s.o(.bss); }
    .main_80322908 0x80322908 : AT(0x000A3708) { FILL(0x00000000); build/asm/main_80322908.s.o(.text); build/asm/main_80322908.s.o(.rodata); build/asm/main_80322908.s.o(.data); }
    .main_80322908_bss (NOLOAD) : { build/asm/main_80322908.s.o(.bss); }
    .main_80322B44 0x80322B44 : AT(0x000A3944) { FILL(0x00000000); build/asm/main_80322B44.s.o(.text); build/asm/main_80322B44.s.o(.rodata); build/asm/main_80322B44.s.o(.data); }
    .main_80322B44_bss (NOLOAD) : { build/asm/main_80322B44.s.o(.bss); }
    .main_80322B5C 0x80322B5C : AT(0x000A395C) { FILL(0x00000000); build/asm/main_80322B5C.s.o(.text); build/asm/main_80322B5C.s.o(.rodata); build/asm/main_80322B5C.s.o(.data); }
    .main_80322B5C_bss (NOLOAD) : { build/asm/main_80322B5C.s.o(.bss); }
    .main_803234DC 0x803234DC : AT(0x000A42DC) { FILL(0x00000000); build/asm/main_803234DC.s.o(.text); build/asm/main_803234DC.s.o(.rodata); build/asm/main_803234DC.s.o(.data); }
    .main_803234DC_bss (NOLOAD) : { build/asm/main_803234DC.s.o(.bss); }
    .main_8032E33C 0x8032E33C : AT(0x000AF13C) { build/asm/data/main_8032E33C.bin.o(.data); }
    .main_80331188 0x80331188 : AT(0x000B1F88) { FILL(0x00000000); build/asm/main_80331188.s.o(.text); build/asm/main_80331188.s.o(.rodata); build/asm/main_80331188.s.o(.data); }
    .main_80331188_bss (NOLOAD) : { build/asm/main_80331188.s.o(.bss); }
    .main_80331ACC 0x80331ACC : AT(0x000B28CC) { FILL(0x00000000); build/asm/main_80331ACC.s.o(.text); build/asm/main_80331ACC.s.o(.rodata); build/asm/main_80331ACC.s.o(.data); }
    .main_80331ACC_bss (NOLOAD) : { build/asm/main_80331ACC.s.o(.bss); }
    .main_803339EC 0x803339EC : AT(0x000B47EC) { build/asm/data/main_803339EC.bin.o(.data); }
    .main_80334530 0x80334530 : AT(0x000B5330) { build/asm/data/main_80334530.bin.o(.data); }
    .main_80334BD4 0x80334BD4 : AT(0x000B59D4) { build/asm/data/main_80334BD4.bin.o(.data); }
    .main_8033878C 0x8033878C : AT(0x000B958C) { FILL(0x00000000); build/asm/main_8033878C.s.o(.text); build/asm/main_8033878C.s.o(.rodata); build/asm/main_8033878C.s.o(.data); }
    .main_8033878C_bss (NOLOAD) : { build/asm/main_8033878C.s.o(.bss); }
    .main_80338CBC 0x80338CBC : AT(0x000B9ABC) { build/asm/data/main_80338CBC.bin.o(.data); }
    .main_8033976C 0x8033976C : AT(0x000BA56C) { FILL(0x00000000); build/asm/main_8033976C.s.o(.text); build/asm/main_8033976C.s.o(.rodata); build/asm/main_8033976C.s.o(.data); }
    .main_8033976C_bss (NOLOAD) : { build/asm/main_8033976C.s.o(.bss); }
    .main_8033C324 0x8033C324 : AT(0x000BD124) { FILL(0x00000000); build/asm/main_8033C324.s.o(.text); build/asm/main_8033C324.s.o(.rodata); build/asm/main_8033C324.s.o(.data); }
    .main_8033C324_bss (NOLOAD) : { build/asm/main_8033C324.s.o(.bss); }
    .main_8033D2C8 0x8033D2C8 : AT(0x000BE0C8) { FILL(0x00000000); build/asm/main_8033D2C8.s.o(.text); build/asm/main_8033D2C8.s.o(.rodata); build/asm/main_8033D2C8.s.o(.data); }
    .main_8033D2C8_bss (NOLOAD) : { build/asm/main_8033D2C8.s.o(.bss); }
    .main_8033F2A8 0x8033F2A8 : AT(0x000C00A8) { FILL(0x00000000); build/asm/main_8033F2A8.s.o(.text); build/asm/main_8033F2A8.s.o(.rodata); build/asm/main_8033F2A8.s.o(.data); }
    .main_8033F2A8_bss (NOLOAD) : { build/asm/main_8033F2A8.s.o(.bss); }
    .main_80340A38 0x80340A38 : AT(0x000C1838) { build/asm/data/main_80340A38.bin.o(.data); }
    .main_803438A0 0x803438A0 : AT(0x000C46A0) { build/asm/data/main_803438A0.bin.o(.data); }
    .main_80344018 0x80344018 : AT(0x000C4E18) { FILL(0x00000000); build/asm/main_80344018.s.o(.text); build/asm/main_80344018.s.o(.rodata); build/asm/main_80344018.s.o(.data); }
    .main_80344018_bss (NOLOAD) : { build/asm/main_80344018.s.o(.bss); }
    .main_80344A3C 0x80344A3C : AT(0x000C583C) { FILL(0x00000000); build/asm/main_80344A3C.s.o(.text); build/asm/main_80344A3C.s.o(.rodata); build/asm/main_80344A3C.s.o(.data); }
    .main_80344A3C_bss (NOLOAD) : { build/asm/main_80344A3C.s.o(.bss); }
    .main_80345DAC 0x80345DAC : AT(0x000C6BAC) { build/asm/data/main_80345DAC.bin.o(.data); }
    .main_8034662C 0x8034662C : AT(0x000C742C) { build/asm/data/main_8034662C.bin.o(.data); }
    .main_80346D50 0x80346D50 : AT(0x000C7B50) { FILL(0x00000000); build/asm/main_80346D50.s.o(.text); build/asm/main_80346D50.s.o(.rodata); build/asm/main_80346D50.s.o(.data); }
    .main_80346D50_bss (NOLOAD) : { build/asm/main_80346D50.s.o(.bss); }
    .main_80347FA0 0x80347FA0 : AT(0x000C8DA0) { build/asm/data/main_80347FA0.bin.o(.data); }
    .main_80348684 0x80348684 : AT(0x000C9484) { FILL(0x00000000); build/asm/main_80348684.s.o(.text); build/asm/main_80348684.s.o(.rodata); build/asm/main_80348684.s.o(.data); }
    .main_80348684_bss (NOLOAD) : { build/asm/main_80348684.s.o(.bss); }
    .main_80349798 0x80349798 : AT(0x000CA598) { build/asm/data/main_80349798.bin.o(.data); }
    .main_8034ACD0 0x8034ACD0 : AT(0x000CBAD0) { build/asm/data/main_8034ACD0.bin.o(.data); }
    .main_8034C1B8 0x8034C1B8 : AT(0x000CCFB8) { FILL(0x00000000); build/asm/main_8034C1B8.s.o(.text); build/asm/main_8034C1B8.s.o(.rodata); build/asm/main_8034C1B8.s.o(.data); }
    .main_8034C1B8_bss (NOLOAD) : { build/asm/main_8034C1B8.s.o(.bss); }
    .main_8034C1E0 0x8034C1E0 : AT(0x000CCFE0) { build/asm/data/main_8034C1E0.bin.o(.data); }
    .main_8034CE50 0x8034CE50 : AT(0x000CDC50) { build/asm/data/main_8034CE50.bin.o(.data); }
    .main_8034CF0C 0x8034CF0C : AT(0x000CDD0C) { FILL(0x00000000); build/asm/main_8034CF0C.s.o(.text); build/asm/main_8034CF0C.s.o(.rodata); build/asm/main_8034CF0C.s.o(.data); }
    .main_8034CF0C_bss (NOLOAD) : { build/asm/main_8034CF0C.s.o(.bss); }
    .main_8034D084 0x8034D084 : AT(0x000CDE84) { build/asm/data/main_8034D084.bin.o(.data); }
    .main_8034E498 0x8034E498 : AT(0x000CF298) { FILL(0x00000000); build/asm/main_8034E498.s.o(.text); build/asm/main_8034E498.s.o(.rodata); build/asm/main_8034E498.s.o(.data); }
    .main_8034E498_bss (NOLOAD) : { build/asm/main_8034E498.s.o(.bss); }
    .main_8034E800 0x8034E800 : AT(0x000CF600) { build/asm/data/main_8034E800.bin.o(.data); }
    .main_8034F0DC 0x8034F0DC : AT(0x000CFEDC) { build/asm/data/main_8034F0DC.bin.o(.data); }
    .main_8035CD74 0x8035CD74 : AT(0x000DDB74) { FILL(0x00000000); build/asm/main_8035CD74.s.o(.text); build/asm/main_8035CD74.s.o(.rodata); build/asm/main_8035CD74.s.o(.data); }
    .main_8035CD74_bss (NOLOAD) : { build/asm/main_8035CD74.s.o(.bss); }
    .main_8035CD80 0x8035CD80 : AT(0x000DDB80) { build/asm/data/main_8035CD80.bin.o(.data); }
    .main_80366CEC 0x80366CEC : AT(0x000E7AEC) { build/asm/data/main_80366CEC.bin.o(.data); }
    .main_803675A0 0x803675A0 : AT(0x000E83A0) { build/asm/data/main_803675A0.bin.o(.data); }
    .main_80376A34 0x80376A34 : AT(0x000F7834) { build/asm/data/main_80376A34.bin.o(.data); }
    .main_80378DDC 0x80378DDC : AT(0x000F9BDC) { build/asm/data/main_80378DDC.bin.o(.data); }
    .assets 0x80680200 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
