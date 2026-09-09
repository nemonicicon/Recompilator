SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80025C50 0x80025C50 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80025C50.s.o(.text); build/asm/main_80025C50.s.o(.rodata); build/asm/main_80025C50.s.o(.data); }
    .main_80025C50_bss (NOLOAD) : { build/asm/main_80025C50.s.o(.bss); }
    .main_80026370 0x80026370 : AT(0x00001720) { FILL(0x00000000); build/asm/main_80026370.s.o(.text); build/asm/main_80026370.s.o(.rodata); build/asm/main_80026370.s.o(.data); }
    .main_80026370_bss (NOLOAD) : { build/asm/main_80026370.s.o(.bss); }
    .main_800D7C44 0x800D7C44 : AT(0x000B2FF4) { FILL(0x00000000); build/asm/main_800D7C44.s.o(.text); build/asm/main_800D7C44.s.o(.rodata); build/asm/main_800D7C44.s.o(.data); }
    .main_800D7C44_bss (NOLOAD) : { build/asm/main_800D7C44.s.o(.bss); }
    .main_800D8010 0x800D8010 : AT(0x000B33C0) { FILL(0x00000000); build/asm/main_800D8010.s.o(.text); build/asm/main_800D8010.s.o(.rodata); build/asm/main_800D8010.s.o(.data); }
    .main_800D8010_bss (NOLOAD) : { build/asm/main_800D8010.s.o(.bss); }
    .main_800DD300 0x800DD300 : AT(0x000B86B0) { build/asm/data/main_800DD300.bin.o(.data); }
    .main_800DD478 0x800DD478 : AT(0x000B8828) { build/asm/data/main_800DD478.bin.o(.data); }
    .main_800E0080 0x800E0080 : AT(0x000BB430) { FILL(0x00000000); build/asm/main_800E0080.s.o(.text); build/asm/main_800E0080.s.o(.rodata); build/asm/main_800E0080.s.o(.data); }
    .main_800E0080_bss (NOLOAD) : { build/asm/main_800E0080.s.o(.bss); }
    .main_800E0880 0x800E0880 : AT(0x000BBC30) { FILL(0x00000000); build/asm/main_800E0880.s.o(.text); build/asm/main_800E0880.s.o(.rodata); build/asm/main_800E0880.s.o(.data); }
    .main_800E0880_bss (NOLOAD) : { build/asm/main_800E0880.s.o(.bss); }
    .main_800E08C0 0x800E08C0 : AT(0x000BBC70) { build/asm/data/main_800E08C0.bin.o(.data); }
    .main_800E1090 0x800E1090 : AT(0x000BC440) { FILL(0x00000000); build/asm/main_800E1090.s.o(.text); build/asm/main_800E1090.s.o(.rodata); build/asm/main_800E1090.s.o(.data); }
    .main_800E1090_bss (NOLOAD) : { build/asm/main_800E1090.s.o(.bss); }
    .main_800E1130 0x800E1130 : AT(0x000BC4E0) { FILL(0x00000000); build/asm/main_800E1130.s.o(.text); build/asm/main_800E1130.s.o(.rodata); build/asm/main_800E1130.s.o(.data); }
    .main_800E1130_bss (NOLOAD) : { build/asm/main_800E1130.s.o(.bss); }
    .main_800E156C 0x800E156C : AT(0x000BC91C) { build/asm/data/main_800E156C.bin.o(.data); }
    .main_800E1900 0x800E1900 : AT(0x000BCCB0) { FILL(0x00000000); build/asm/main_800E1900.s.o(.text); build/asm/main_800E1900.s.o(.rodata); build/asm/main_800E1900.s.o(.data); }
    .main_800E1900_bss (NOLOAD) : { build/asm/main_800E1900.s.o(.bss); }
    .main_800E22A8 0x800E22A8 : AT(0x000BD658) { FILL(0x00000000); build/asm/main_800E22A8.s.o(.text); build/asm/main_800E22A8.s.o(.rodata); build/asm/main_800E22A8.s.o(.data); }
    .main_800E22A8_bss (NOLOAD) : { build/asm/main_800E22A8.s.o(.bss); }
    .main_800E2F70 0x800E2F70 : AT(0x000BE320) { build/asm/data/main_800E2F70.bin.o(.data); }
    .main_800E35B0 0x800E35B0 : AT(0x000BE960) { build/asm/data/main_800E35B0.bin.o(.data); }
    .main_800E4090 0x800E4090 : AT(0x000BF440) { build/asm/data/main_800E4090.bin.o(.data); }
    .main_800E7F8C 0x800E7F8C : AT(0x000C333C) { FILL(0x00000000); build/asm/main_800E7F8C.s.o(.text); build/asm/main_800E7F8C.s.o(.rodata); build/asm/main_800E7F8C.s.o(.data); }
    .main_800E7F8C_bss (NOLOAD) : { build/asm/main_800E7F8C.s.o(.bss); }
    .main_800EA438 0x800EA438 : AT(0x000C57E8) { FILL(0x00000000); build/asm/main_800EA438.s.o(.text); build/asm/main_800EA438.s.o(.rodata); build/asm/main_800EA438.s.o(.data); }
    .main_800EA438_bss (NOLOAD) : { build/asm/main_800EA438.s.o(.bss); }
    .main_800EA790 0x800EA790 : AT(0x000C5B40) { build/asm/data/main_800EA790.bin.o(.data); }
    .main_800EB3B4 0x800EB3B4 : AT(0x000C6764) { build/asm/data/main_800EB3B4.bin.o(.data); }
    .main_800EB414 0x800EB414 : AT(0x000C67C4) { FILL(0x00000000); build/asm/main_800EB414.s.o(.text); build/asm/main_800EB414.s.o(.rodata); build/asm/main_800EB414.s.o(.data); }
    .main_800EB414_bss (NOLOAD) : { build/asm/main_800EB414.s.o(.bss); }
    .main_800EB590 0x800EB590 : AT(0x000C6940) { FILL(0x00000000); build/asm/main_800EB590.s.o(.text); build/asm/main_800EB590.s.o(.rodata); build/asm/main_800EB590.s.o(.data); }
    .main_800EB590_bss (NOLOAD) : { build/asm/main_800EB590.s.o(.bss); }
    .main_800EBB3C 0x800EBB3C : AT(0x000C6EEC) { FILL(0x00000000); build/asm/main_800EBB3C.s.o(.text); build/asm/main_800EBB3C.s.o(.rodata); build/asm/main_800EBB3C.s.o(.data); }
    .main_800EBB3C_bss (NOLOAD) : { build/asm/main_800EBB3C.s.o(.bss); }
    .main_800EC0AC 0x800EC0AC : AT(0x000C745C) { build/asm/data/main_800EC0AC.bin.o(.data); }
    .main_800ED060 0x800ED060 : AT(0x000C8410) { build/asm/data/main_800ED060.bin.o(.data); }
    .main_800F0444 0x800F0444 : AT(0x000CB7F4) { FILL(0x00000000); build/asm/main_800F0444.s.o(.text); build/asm/main_800F0444.s.o(.rodata); build/asm/main_800F0444.s.o(.data); }
    .main_800F0444_bss (NOLOAD) : { build/asm/main_800F0444.s.o(.bss); }
    .main_800F0564 0x800F0564 : AT(0x000CB914) { FILL(0x00000000); build/asm/main_800F0564.s.o(.text); build/asm/main_800F0564.s.o(.rodata); build/asm/main_800F0564.s.o(.data); }
    .main_800F0564_bss (NOLOAD) : { build/asm/main_800F0564.s.o(.bss); }
    .main_800F0888 0x800F0888 : AT(0x000CBC38) { FILL(0x00000000); build/asm/main_800F0888.s.o(.text); build/asm/main_800F0888.s.o(.rodata); build/asm/main_800F0888.s.o(.data); }
    .main_800F0888_bss (NOLOAD) : { build/asm/main_800F0888.s.o(.bss); }
    .main_800F11CC 0x800F11CC : AT(0x000CC57C) { build/asm/data/main_800F11CC.bin.o(.data); }
    .main_800F19A8 0x800F19A8 : AT(0x000CCD58) { FILL(0x00000000); build/asm/main_800F19A8.s.o(.text); build/asm/main_800F19A8.s.o(.rodata); build/asm/main_800F19A8.s.o(.data); }
    .main_800F19A8_bss (NOLOAD) : { build/asm/main_800F19A8.s.o(.bss); }
    .main_800F1DA8 0x800F1DA8 : AT(0x000CD158) { FILL(0x00000000); build/asm/main_800F1DA8.s.o(.text); build/asm/main_800F1DA8.s.o(.rodata); build/asm/main_800F1DA8.s.o(.data); }
    .main_800F1DA8_bss (NOLOAD) : { build/asm/main_800F1DA8.s.o(.bss); }
    .main_800F1DB0 0x800F1DB0 : AT(0x000CD160) { build/asm/data/main_800F1DB0.bin.o(.data); }
    .main_800F2800 0x800F2800 : AT(0x000CDBB0) { build/asm/data/main_800F2800.bin.o(.data); }
    .main_800F2954 0x800F2954 : AT(0x000CDD04) { FILL(0x00000000); build/asm/main_800F2954.s.o(.text); build/asm/main_800F2954.s.o(.rodata); build/asm/main_800F2954.s.o(.data); }
    .main_800F2954_bss (NOLOAD) : { build/asm/main_800F2954.s.o(.bss); }
    .main_800F2A10 0x800F2A10 : AT(0x000CDDC0) { build/asm/data/main_800F2A10.bin.o(.data); }
    .main_800F518C 0x800F518C : AT(0x000D053C) { build/asm/data/main_800F518C.bin.o(.data); }
    .main_800F7AC8 0x800F7AC8 : AT(0x000D2E78) { build/asm/data/main_800F7AC8.bin.o(.data); }
    .main_800F8A38 0x800F8A38 : AT(0x000D3DE8) { build/asm/data/main_800F8A38.bin.o(.data); }
    .main_800FA110 0x800FA110 : AT(0x000D54C0) { FILL(0x00000000); build/asm/main_800FA110.s.o(.text); build/asm/main_800FA110.s.o(.rodata); build/asm/main_800FA110.s.o(.data); }
    .main_800FA110_bss (NOLOAD) : { build/asm/main_800FA110.s.o(.bss); }
    .main_800FA114 0x800FA114 : AT(0x000D54C4) { build/asm/data/main_800FA114.bin.o(.data); }
    .main_800FB1CC 0x800FB1CC : AT(0x000D657C) { build/asm/data/main_800FB1CC.bin.o(.data); }
    .main_800FC978 0x800FC978 : AT(0x000D7D28) { build/asm/data/main_800FC978.bin.o(.data); }
    .main_800FE774 0x800FE774 : AT(0x000D9B24) { build/asm/data/main_800FE774.bin.o(.data); }
    .main_800FF9CC 0x800FF9CC : AT(0x000DAD7C) { FILL(0x00000000); build/asm/main_800FF9CC.s.o(.text); build/asm/main_800FF9CC.s.o(.rodata); build/asm/main_800FF9CC.s.o(.data); }
    .main_800FF9CC_bss (NOLOAD) : { build/asm/main_800FF9CC.s.o(.bss); }
    .main_800FFA04 0x800FFA04 : AT(0x000DADB4) { build/asm/data/main_800FFA04.bin.o(.data); }
    .main_801006A0 0x801006A0 : AT(0x000DBA50) { FILL(0x00000000); build/asm/main_801006A0.s.o(.text); build/asm/main_801006A0.s.o(.rodata); build/asm/main_801006A0.s.o(.data); }
    .main_801006A0_bss (NOLOAD) : { build/asm/main_801006A0.s.o(.bss); }
    .main_801006F4 0x801006F4 : AT(0x000DBAA4) { build/asm/data/main_801006F4.bin.o(.data); }
    .main_80100FF8 0x80100FF8 : AT(0x000DC3A8) { FILL(0x00000000); build/asm/main_80100FF8.s.o(.text); build/asm/main_80100FF8.s.o(.rodata); build/asm/main_80100FF8.s.o(.data); }
    .main_80100FF8_bss (NOLOAD) : { build/asm/main_80100FF8.s.o(.bss); }
    .main_80101164 0x80101164 : AT(0x000DC514) { build/asm/data/main_80101164.bin.o(.data); }
    .main_801023CC 0x801023CC : AT(0x000DD77C) { build/asm/data/main_801023CC.bin.o(.data); }
    .main_8010316C 0x8010316C : AT(0x000DE51C) { build/asm/data/main_8010316C.bin.o(.data); }
    .main_80103834 0x80103834 : AT(0x000DEBE4) { build/asm/data/main_80103834.bin.o(.data); }
    .main_801040D8 0x801040D8 : AT(0x000DF488) { build/asm/data/main_801040D8.bin.o(.data); }
    .main_80104408 0x80104408 : AT(0x000DF7B8) { build/asm/data/main_80104408.bin.o(.data); }
    .main_80104C68 0x80104C68 : AT(0x000E0018) { FILL(0x00000000); build/asm/main_80104C68.s.o(.text); build/asm/main_80104C68.s.o(.rodata); build/asm/main_80104C68.s.o(.data); }
    .main_80104C68_bss (NOLOAD) : { build/asm/main_80104C68.s.o(.bss); }
    .main_80104E4C 0x80104E4C : AT(0x000E01FC) { FILL(0x00000000); build/asm/main_80104E4C.s.o(.text); build/asm/main_80104E4C.s.o(.rodata); build/asm/main_80104E4C.s.o(.data); }
    .main_80104E4C_bss (NOLOAD) : { build/asm/main_80104E4C.s.o(.bss); }
    .main_80105410 0x80105410 : AT(0x000E07C0) { build/asm/data/main_80105410.bin.o(.data); }
    .main_80106C98 0x80106C98 : AT(0x000E2048) { FILL(0x00000000); build/asm/main_80106C98.s.o(.text); build/asm/main_80106C98.s.o(.rodata); build/asm/main_80106C98.s.o(.data); }
    .main_80106C98_bss (NOLOAD) : { build/asm/main_80106C98.s.o(.bss); }
    .main_80107738 0x80107738 : AT(0x000E2AE8) { build/asm/data/main_80107738.bin.o(.data); }
    .main_80108370 0x80108370 : AT(0x000E3720) { FILL(0x00000000); build/asm/main_80108370.s.o(.text); build/asm/main_80108370.s.o(.rodata); build/asm/main_80108370.s.o(.data); }
    .main_80108370_bss (NOLOAD) : { build/asm/main_80108370.s.o(.bss); }
    .main_8010847C 0x8010847C : AT(0x000E382C) { build/asm/data/main_8010847C.bin.o(.data); }
    .main_80108CA8 0x80108CA8 : AT(0x000E4058) { build/asm/data/main_80108CA8.bin.o(.data); }
    .main_8010A038 0x8010A038 : AT(0x000E53E8) { build/asm/data/main_8010A038.bin.o(.data); }
    .main_8010A1E4 0x8010A1E4 : AT(0x000E5594) { FILL(0x00000000); build/asm/main_8010A1E4.s.o(.text); build/asm/main_8010A1E4.s.o(.rodata); build/asm/main_8010A1E4.s.o(.data); }
    .main_8010A1E4_bss (NOLOAD) : { build/asm/main_8010A1E4.s.o(.bss); }
    .main_8010A520 0x8010A520 : AT(0x000E58D0) { build/asm/data/main_8010A520.bin.o(.data); }
    .main_8010A9A8 0x8010A9A8 : AT(0x000E5D58) { FILL(0x00000000); build/asm/main_8010A9A8.s.o(.text); build/asm/main_8010A9A8.s.o(.rodata); build/asm/main_8010A9A8.s.o(.data); }
    .main_8010A9A8_bss (NOLOAD) : { build/asm/main_8010A9A8.s.o(.bss); }
    .main_8010AAE8 0x8010AAE8 : AT(0x000E5E98) { build/asm/data/main_8010AAE8.bin.o(.data); }
    .main_8010BADC 0x8010BADC : AT(0x000E6E8C) { build/asm/data/main_8010BADC.bin.o(.data); }
    .main_8010CA80 0x8010CA80 : AT(0x000E7E30) { build/asm/data/main_8010CA80.bin.o(.data); }
    .main_8010E0D4 0x8010E0D4 : AT(0x000E9484) { build/asm/data/main_8010E0D4.bin.o(.data); }
    .main_8010FFAC 0x8010FFAC : AT(0x000EB35C) { build/asm/data/main_8010FFAC.bin.o(.data); }
    .main_80110570 0x80110570 : AT(0x000EB920) { FILL(0x00000000); build/asm/main_80110570.s.o(.text); build/asm/main_80110570.s.o(.rodata); build/asm/main_80110570.s.o(.data); }
    .main_80110570_bss (NOLOAD) : { build/asm/main_80110570.s.o(.bss); }
    .main_8011063C 0x8011063C : AT(0x000EB9EC) { build/asm/data/main_8011063C.bin.o(.data); }
    .main_80110D9C 0x80110D9C : AT(0x000EC14C) { build/asm/data/main_80110D9C.bin.o(.data); }
    .main_801116C0 0x801116C0 : AT(0x000ECA70) { FILL(0x00000000); build/asm/main_801116C0.s.o(.text); build/asm/main_801116C0.s.o(.rodata); build/asm/main_801116C0.s.o(.data); }
    .main_801116C0_bss (NOLOAD) : { build/asm/main_801116C0.s.o(.bss); }
    .main_801116D0 0x801116D0 : AT(0x000ECA80) { build/asm/data/main_801116D0.bin.o(.data); }
    .main_80111E00 0x80111E00 : AT(0x000ED1B0) { build/asm/data/main_80111E00.bin.o(.data); }
    .main_80112908 0x80112908 : AT(0x000EDCB8) { build/asm/data/main_80112908.bin.o(.data); }
    .main_80112A2C 0x80112A2C : AT(0x000EDDDC) { FILL(0x00000000); build/asm/main_80112A2C.s.o(.text); build/asm/main_80112A2C.s.o(.rodata); build/asm/main_80112A2C.s.o(.data); }
    .main_80112A2C_bss (NOLOAD) : { build/asm/main_80112A2C.s.o(.bss); }
    .main_80112A3C 0x80112A3C : AT(0x000EDDEC) { build/asm/data/main_80112A3C.bin.o(.data); }
    .main_80112DC0 0x80112DC0 : AT(0x000EE170) { FILL(0x00000000); build/asm/main_80112DC0.s.o(.text); build/asm/main_80112DC0.s.o(.rodata); build/asm/main_80112DC0.s.o(.data); }
    .main_80112DC0_bss (NOLOAD) : { build/asm/main_80112DC0.s.o(.bss); }
    .main_80112EB8 0x80112EB8 : AT(0x000EE268) { FILL(0x00000000); build/asm/main_80112EB8.s.o(.text); build/asm/main_80112EB8.s.o(.rodata); build/asm/main_80112EB8.s.o(.data); }
    .main_80112EB8_bss (NOLOAD) : { build/asm/main_80112EB8.s.o(.bss); }
    .main_80112F30 0x80112F30 : AT(0x000EE2E0) { build/asm/data/main_80112F30.bin.o(.data); }
    .main_8011403C 0x8011403C : AT(0x000EF3EC) { build/asm/data/main_8011403C.bin.o(.data); }
    .main_801157A0 0x801157A0 : AT(0x000F0B50) { FILL(0x00000000); build/asm/main_801157A0.s.o(.text); build/asm/main_801157A0.s.o(.rodata); build/asm/main_801157A0.s.o(.data); }
    .main_801157A0_bss (NOLOAD) : { build/asm/main_801157A0.s.o(.bss); }
    .main_80115D28 0x80115D28 : AT(0x000F10D8) { build/asm/data/main_80115D28.bin.o(.data); }
    .main_801160FC 0x801160FC : AT(0x000F14AC) { FILL(0x00000000); build/asm/main_801160FC.s.o(.text); build/asm/main_801160FC.s.o(.rodata); build/asm/main_801160FC.s.o(.data); }
    .main_801160FC_bss (NOLOAD) : { build/asm/main_801160FC.s.o(.bss); }
    .main_8011610C 0x8011610C : AT(0x000F14BC) { FILL(0x00000000); build/asm/main_8011610C.s.o(.text); build/asm/main_8011610C.s.o(.rodata); build/asm/main_8011610C.s.o(.data); }
    .main_8011610C_bss (NOLOAD) : { build/asm/main_8011610C.s.o(.bss); }
    .main_80116334 0x80116334 : AT(0x000F16E4) { build/asm/data/main_80116334.bin.o(.data); }
    .main_80117068 0x80117068 : AT(0x000F2418) { build/asm/data/main_80117068.bin.o(.data); }
    .main_801173D4 0x801173D4 : AT(0x000F2784) { FILL(0x00000000); build/asm/main_801173D4.s.o(.text); build/asm/main_801173D4.s.o(.rodata); build/asm/main_801173D4.s.o(.data); }
    .main_801173D4_bss (NOLOAD) : { build/asm/main_801173D4.s.o(.bss); }
    .main_801173E0 0x801173E0 : AT(0x000F2790) { build/asm/data/main_801173E0.bin.o(.data); }
    .main_80118954 0x80118954 : AT(0x000F3D04) { FILL(0x00000000); build/asm/main_80118954.s.o(.text); build/asm/main_80118954.s.o(.rodata); build/asm/main_80118954.s.o(.data); }
    .main_80118954_bss (NOLOAD) : { build/asm/main_80118954.s.o(.bss); }
    .main_8011895C 0x8011895C : AT(0x000F3D0C) { build/asm/data/main_8011895C.bin.o(.data); }
    .main_801197DC 0x801197DC : AT(0x000F4B8C) { FILL(0x00000000); build/asm/main_801197DC.s.o(.text); build/asm/main_801197DC.s.o(.rodata); build/asm/main_801197DC.s.o(.data); }
    .main_801197DC_bss (NOLOAD) : { build/asm/main_801197DC.s.o(.bss); }
    .main_80119930 0x80119930 : AT(0x000F4CE0) { build/asm/data/main_80119930.bin.o(.data); }
    .main_8011B7F0 0x8011B7F0 : AT(0x000F6BA0) { build/asm/data/main_8011B7F0.bin.o(.data); }
    .main_8011D8CC 0x8011D8CC : AT(0x000F8C7C) { FILL(0x00000000); build/asm/main_8011D8CC.s.o(.text); build/asm/main_8011D8CC.s.o(.rodata); build/asm/main_8011D8CC.s.o(.data); }
    .main_8011D8CC_bss (NOLOAD) : { build/asm/main_8011D8CC.s.o(.bss); }
    .main_8011DA70 0x8011DA70 : AT(0x000F8E20) { build/asm/data/main_8011DA70.bin.o(.data); }
    .main_8011E2A8 0x8011E2A8 : AT(0x000F9658) { FILL(0x00000000); build/asm/main_8011E2A8.s.o(.text); build/asm/main_8011E2A8.s.o(.rodata); build/asm/main_8011E2A8.s.o(.data); }
    .main_8011E2A8_bss (NOLOAD) : { build/asm/main_8011E2A8.s.o(.bss); }
    .main_8011E2C8 0x8011E2C8 : AT(0x000F9678) { build/asm/data/main_8011E2C8.bin.o(.data); }
    .main_80124C3C 0x80124C3C : AT(0x000FFFEC) { FILL(0x00000000); build/asm/main_80124C3C.s.o(.text); build/asm/main_80124C3C.s.o(.rodata); build/asm/main_80124C3C.s.o(.data); }
    .main_80124C3C_bss (NOLOAD) : { build/asm/main_80124C3C.s.o(.bss); }
    .main_80124C9C 0x80124C9C : AT(0x0010004C) { build/asm/data/main_80124C9C.bin.o(.data); }
    .assets 0x80425C50 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
