SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_8021ED00 0x8021ED00 : AT(0x00001000) { FILL(0x00000000); build/asm/main_8021ED00.s.o(.text); build/asm/main_8021ED00.s.o(.rodata); build/asm/main_8021ED00.s.o(.data); }
    .main_8021ED00_bss (NOLOAD) : { build/asm/main_8021ED00.s.o(.bss); }
    .main_80220CC0 0x80220CC0 : AT(0x00002FC0) { FILL(0x00000000); build/asm/main_80220CC0.s.o(.text); build/asm/main_80220CC0.s.o(.rodata); build/asm/main_80220CC0.s.o(.data); }
    .main_80220CC0_bss (NOLOAD) : { build/asm/main_80220CC0.s.o(.bss); }
    .main_80220F90 0x80220F90 : AT(0x00003290) { FILL(0x00000000); build/asm/main_80220F90.s.o(.text); build/asm/main_80220F90.s.o(.rodata); build/asm/main_80220F90.s.o(.data); }
    .main_80220F90_bss (NOLOAD) : { build/asm/main_80220F90.s.o(.bss); }
    .main_80221048 0x80221048 : AT(0x00003348) { FILL(0x00000000); build/asm/main_80221048.s.o(.text); build/asm/main_80221048.s.o(.rodata); build/asm/main_80221048.s.o(.data); }
    .main_80221048_bss (NOLOAD) : { build/asm/main_80221048.s.o(.bss); }
    .main_802218CC 0x802218CC : AT(0x00003BCC) { FILL(0x00000000); build/asm/main_802218CC.s.o(.text); build/asm/main_802218CC.s.o(.rodata); build/asm/main_802218CC.s.o(.data); }
    .main_802218CC_bss (NOLOAD) : { build/asm/main_802218CC.s.o(.bss); }
    .main_802219A0 0x802219A0 : AT(0x00003CA0) { FILL(0x00000000); build/asm/main_802219A0.s.o(.text); build/asm/main_802219A0.s.o(.rodata); build/asm/main_802219A0.s.o(.data); }
    .main_802219A0_bss (NOLOAD) : { build/asm/main_802219A0.s.o(.bss); }
    .main_80221BB4 0x80221BB4 : AT(0x00003EB4) { FILL(0x00000000); build/asm/main_80221BB4.s.o(.text); build/asm/main_80221BB4.s.o(.rodata); build/asm/main_80221BB4.s.o(.data); }
    .main_80221BB4_bss (NOLOAD) : { build/asm/main_80221BB4.s.o(.bss); }
    .main_80221CE8 0x80221CE8 : AT(0x00003FE8) { FILL(0x00000000); build/asm/main_80221CE8.s.o(.text); build/asm/main_80221CE8.s.o(.rodata); build/asm/main_80221CE8.s.o(.data); }
    .main_80221CE8_bss (NOLOAD) : { build/asm/main_80221CE8.s.o(.bss); }
    .main_80221D64 0x80221D64 : AT(0x00004064) { FILL(0x00000000); build/asm/main_80221D64.s.o(.text); build/asm/main_80221D64.s.o(.rodata); build/asm/main_80221D64.s.o(.data); }
    .main_80221D64_bss (NOLOAD) : { build/asm/main_80221D64.s.o(.bss); }
    .main_80222444 0x80222444 : AT(0x00004744) { FILL(0x00000000); build/asm/main_80222444.s.o(.text); build/asm/main_80222444.s.o(.rodata); build/asm/main_80222444.s.o(.data); }
    .main_80222444_bss (NOLOAD) : { build/asm/main_80222444.s.o(.bss); }
    .main_80222520 0x80222520 : AT(0x00004820) { FILL(0x00000000); build/asm/main_80222520.s.o(.text); build/asm/main_80222520.s.o(.rodata); build/asm/main_80222520.s.o(.data); }
    .main_80222520_bss (NOLOAD) : { build/asm/main_80222520.s.o(.bss); }
    .main_80222788 0x80222788 : AT(0x00004A88) { FILL(0x00000000); build/asm/main_80222788.s.o(.text); build/asm/main_80222788.s.o(.rodata); build/asm/main_80222788.s.o(.data); }
    .main_80222788_bss (NOLOAD) : { build/asm/main_80222788.s.o(.bss); }
    .main_802228CC 0x802228CC : AT(0x00004BCC) { FILL(0x00000000); build/asm/main_802228CC.s.o(.text); build/asm/main_802228CC.s.o(.rodata); build/asm/main_802228CC.s.o(.data); }
    .main_802228CC_bss (NOLOAD) : { build/asm/main_802228CC.s.o(.bss); }
    .main_802228D0 0x802228D0 : AT(0x00004BD0) { build/asm/data/main_802228D0.bin.o(.data); }
    .main_802229F8 0x802229F8 : AT(0x00004CF8) { FILL(0x00000000); build/asm/main_802229F8.s.o(.text); build/asm/main_802229F8.s.o(.rodata); build/asm/main_802229F8.s.o(.data); }
    .main_802229F8_bss (NOLOAD) : { build/asm/main_802229F8.s.o(.bss); }
    .main_80222A14 0x80222A14 : AT(0x00004D14) { FILL(0x00000000); build/asm/main_80222A14.s.o(.text); build/asm/main_80222A14.s.o(.rodata); build/asm/main_80222A14.s.o(.data); }
    .main_80222A14_bss (NOLOAD) : { build/asm/main_80222A14.s.o(.bss); }
    .main_80222A50 0x80222A50 : AT(0x00004D50) { FILL(0x00000000); build/asm/main_80222A50.s.o(.text); build/asm/main_80222A50.s.o(.rodata); build/asm/main_80222A50.s.o(.data); }
    .main_80222A50_bss (NOLOAD) : { build/asm/main_80222A50.s.o(.bss); }
    .main_80222AFC 0x80222AFC : AT(0x00004DFC) { build/asm/data/main_80222AFC.bin.o(.data); }
    .main_80224258 0x80224258 : AT(0x00006558) { FILL(0x00000000); build/asm/main_80224258.s.o(.text); build/asm/main_80224258.s.o(.rodata); build/asm/main_80224258.s.o(.data); }
    .main_80224258_bss (NOLOAD) : { build/asm/main_80224258.s.o(.bss); }
    .main_802243CC 0x802243CC : AT(0x000066CC) { build/asm/data/main_802243CC.bin.o(.data); }
    .main_802248FC 0x802248FC : AT(0x00006BFC) { FILL(0x00000000); build/asm/main_802248FC.s.o(.text); build/asm/main_802248FC.s.o(.rodata); build/asm/main_802248FC.s.o(.data); }
    .main_802248FC_bss (NOLOAD) : { build/asm/main_802248FC.s.o(.bss); }
    .main_80224914 0x80224914 : AT(0x00006C14) { build/asm/data/main_80224914.bin.o(.data); }
    .main_802249CC 0x802249CC : AT(0x00006CCC) { FILL(0x00000000); build/asm/main_802249CC.s.o(.text); build/asm/main_802249CC.s.o(.rodata); build/asm/main_802249CC.s.o(.data); }
    .main_802249CC_bss (NOLOAD) : { build/asm/main_802249CC.s.o(.bss); }
    .main_802249D4 0x802249D4 : AT(0x00006CD4) { build/asm/data/main_802249D4.bin.o(.data); }
    .main_80224A28 0x80224A28 : AT(0x00006D28) { FILL(0x00000000); build/asm/main_80224A28.s.o(.text); build/asm/main_80224A28.s.o(.rodata); build/asm/main_80224A28.s.o(.data); }
    .main_80224A28_bss (NOLOAD) : { build/asm/main_80224A28.s.o(.bss); }
    .main_80224A38 0x80224A38 : AT(0x00006D38) { FILL(0x00000000); build/asm/main_80224A38.s.o(.text); build/asm/main_80224A38.s.o(.rodata); build/asm/main_80224A38.s.o(.data); }
    .main_80224A38_bss (NOLOAD) : { build/asm/main_80224A38.s.o(.bss); }
    .main_80224A64 0x80224A64 : AT(0x00006D64) { build/asm/data/main_80224A64.bin.o(.data); }
    .main_80224C2C 0x80224C2C : AT(0x00006F2C) { build/asm/data/main_80224C2C.bin.o(.data); }
    .main_80224D6C 0x80224D6C : AT(0x0000706C) { build/asm/data/main_80224D6C.bin.o(.data); }
    .main_80224F94 0x80224F94 : AT(0x00007294) { FILL(0x00000000); build/asm/main_80224F94.s.o(.text); build/asm/main_80224F94.s.o(.rodata); build/asm/main_80224F94.s.o(.data); }
    .main_80224F94_bss (NOLOAD) : { build/asm/main_80224F94.s.o(.bss); }
    .main_80224F9C 0x80224F9C : AT(0x0000729C) { build/asm/data/main_80224F9C.bin.o(.data); }
    .main_80225300 0x80225300 : AT(0x00007600) { FILL(0x00000000); build/asm/main_80225300.s.o(.text); build/asm/main_80225300.s.o(.rodata); build/asm/main_80225300.s.o(.data); }
    .main_80225300_bss (NOLOAD) : { build/asm/main_80225300.s.o(.bss); }
    .main_802253E8 0x802253E8 : AT(0x000076E8) { build/asm/data/main_802253E8.bin.o(.data); }
    .main_8022546C 0x8022546C : AT(0x0000776C) { FILL(0x00000000); build/asm/main_8022546C.s.o(.text); build/asm/main_8022546C.s.o(.rodata); build/asm/main_8022546C.s.o(.data); }
    .main_8022546C_bss (NOLOAD) : { build/asm/main_8022546C.s.o(.bss); }
    .main_802254DC 0x802254DC : AT(0x000077DC) { build/asm/data/main_802254DC.bin.o(.data); }
    .main_802256BC 0x802256BC : AT(0x000079BC) { FILL(0x00000000); build/asm/main_802256BC.s.o(.text); build/asm/main_802256BC.s.o(.rodata); build/asm/main_802256BC.s.o(.data); }
    .main_802256BC_bss (NOLOAD) : { build/asm/main_802256BC.s.o(.bss); }
    .main_802256C8 0x802256C8 : AT(0x000079C8) { build/asm/data/main_802256C8.bin.o(.data); }
    .main_80225CA4 0x80225CA4 : AT(0x00007FA4) { FILL(0x00000000); build/asm/main_80225CA4.s.o(.text); build/asm/main_80225CA4.s.o(.rodata); build/asm/main_80225CA4.s.o(.data); }
    .main_80225CA4_bss (NOLOAD) : { build/asm/main_80225CA4.s.o(.bss); }
    .main_80225CAC 0x80225CAC : AT(0x00007FAC) { build/asm/data/main_80225CAC.bin.o(.data); }
    .main_80225DD8 0x80225DD8 : AT(0x000080D8) { FILL(0x00000000); build/asm/main_80225DD8.s.o(.text); build/asm/main_80225DD8.s.o(.rodata); build/asm/main_80225DD8.s.o(.data); }
    .main_80225DD8_bss (NOLOAD) : { build/asm/main_80225DD8.s.o(.bss); }
    .main_80225E1C 0x80225E1C : AT(0x0000811C) { build/asm/data/main_80225E1C.bin.o(.data); }
    .main_80225F2C 0x80225F2C : AT(0x0000822C) { FILL(0x00000000); build/asm/main_80225F2C.s.o(.text); build/asm/main_80225F2C.s.o(.rodata); build/asm/main_80225F2C.s.o(.data); }
    .main_80225F2C_bss (NOLOAD) : { build/asm/main_80225F2C.s.o(.bss); }
    .main_80225F5C 0x80225F5C : AT(0x0000825C) { build/asm/data/main_80225F5C.bin.o(.data); }
    .main_8022609C 0x8022609C : AT(0x0000839C) { FILL(0x00000000); build/asm/main_8022609C.s.o(.text); build/asm/main_8022609C.s.o(.rodata); build/asm/main_8022609C.s.o(.data); }
    .main_8022609C_bss (NOLOAD) : { build/asm/main_8022609C.s.o(.bss); }
    .main_802260C4 0x802260C4 : AT(0x000083C4) { build/asm/data/main_802260C4.bin.o(.data); }
    .main_80226234 0x80226234 : AT(0x00008534) { FILL(0x00000000); build/asm/main_80226234.s.o(.text); build/asm/main_80226234.s.o(.rodata); build/asm/main_80226234.s.o(.data); }
    .main_80226234_bss (NOLOAD) : { build/asm/main_80226234.s.o(.bss); }
    .main_80226284 0x80226284 : AT(0x00008584) { build/asm/data/main_80226284.bin.o(.data); }
    .main_8022660C 0x8022660C : AT(0x0000890C) { FILL(0x00000000); build/asm/main_8022660C.s.o(.text); build/asm/main_8022660C.s.o(.rodata); build/asm/main_8022660C.s.o(.data); }
    .main_8022660C_bss (NOLOAD) : { build/asm/main_8022660C.s.o(.bss); }
    .main_80226614 0x80226614 : AT(0x00008914) { build/asm/data/main_80226614.bin.o(.data); }
    .main_8022679C 0x8022679C : AT(0x00008A9C) { FILL(0x00000000); build/asm/main_8022679C.s.o(.text); build/asm/main_8022679C.s.o(.rodata); build/asm/main_8022679C.s.o(.data); }
    .main_8022679C_bss (NOLOAD) : { build/asm/main_8022679C.s.o(.bss); }
    .main_802267B4 0x802267B4 : AT(0x00008AB4) { build/asm/data/main_802267B4.bin.o(.data); }
    .main_80226B3C 0x80226B3C : AT(0x00008E3C) { FILL(0x00000000); build/asm/main_80226B3C.s.o(.text); build/asm/main_80226B3C.s.o(.rodata); build/asm/main_80226B3C.s.o(.data); }
    .main_80226B3C_bss (NOLOAD) : { build/asm/main_80226B3C.s.o(.bss); }
    .main_80226B4C 0x80226B4C : AT(0x00008E4C) { build/asm/data/main_80226B4C.bin.o(.data); }
    .main_80226E5C 0x80226E5C : AT(0x0000915C) { FILL(0x00000000); build/asm/main_80226E5C.s.o(.text); build/asm/main_80226E5C.s.o(.rodata); build/asm/main_80226E5C.s.o(.data); }
    .main_80226E5C_bss (NOLOAD) : { build/asm/main_80226E5C.s.o(.bss); }
    .main_80226E64 0x80226E64 : AT(0x00009164) { build/asm/data/main_80226E64.bin.o(.data); }
    .main_80226FEC 0x80226FEC : AT(0x000092EC) { FILL(0x00000000); build/asm/main_80226FEC.s.o(.text); build/asm/main_80226FEC.s.o(.rodata); build/asm/main_80226FEC.s.o(.data); }
    .main_80226FEC_bss (NOLOAD) : { build/asm/main_80226FEC.s.o(.bss); }
    .main_80227014 0x80227014 : AT(0x00009314) { build/asm/data/main_80227014.bin.o(.data); }
    .main_802273BC 0x802273BC : AT(0x000096BC) { FILL(0x00000000); build/asm/main_802273BC.s.o(.text); build/asm/main_802273BC.s.o(.rodata); build/asm/main_802273BC.s.o(.data); }
    .main_802273BC_bss (NOLOAD) : { build/asm/main_802273BC.s.o(.bss); }
    .main_802273F4 0x802273F4 : AT(0x000096F4) { build/asm/data/main_802273F4.bin.o(.data); }
    .main_802277D4 0x802277D4 : AT(0x00009AD4) { FILL(0x00000000); build/asm/main_802277D4.s.o(.text); build/asm/main_802277D4.s.o(.rodata); build/asm/main_802277D4.s.o(.data); }
    .main_802277D4_bss (NOLOAD) : { build/asm/main_802277D4.s.o(.bss); }
    .main_802277DC 0x802277DC : AT(0x00009ADC) { build/asm/data/main_802277DC.bin.o(.data); }
    .main_80227A88 0x80227A88 : AT(0x00009D88) { FILL(0x00000000); build/asm/main_80227A88.s.o(.text); build/asm/main_80227A88.s.o(.rodata); build/asm/main_80227A88.s.o(.data); }
    .main_80227A88_bss (NOLOAD) : { build/asm/main_80227A88.s.o(.bss); }
    .main_80227ABC 0x80227ABC : AT(0x00009DBC) { build/asm/data/main_80227ABC.bin.o(.data); }
    .main_80227EA4 0x80227EA4 : AT(0x0000A1A4) { FILL(0x00000000); build/asm/main_80227EA4.s.o(.text); build/asm/main_80227EA4.s.o(.rodata); build/asm/main_80227EA4.s.o(.data); }
    .main_80227EA4_bss (NOLOAD) : { build/asm/main_80227EA4.s.o(.bss); }
    .main_80228078 0x80228078 : AT(0x0000A378) { build/asm/data/main_80228078.bin.o(.data); }
    .main_80228E64 0x80228E64 : AT(0x0000B164) { FILL(0x00000000); build/asm/main_80228E64.s.o(.text); build/asm/main_80228E64.s.o(.rodata); build/asm/main_80228E64.s.o(.data); }
    .main_80228E64_bss (NOLOAD) : { build/asm/main_80228E64.s.o(.bss); }
    .main_80229098 0x80229098 : AT(0x0000B398) { build/asm/data/main_80229098.bin.o(.data); }
    .main_8022AB18 0x8022AB18 : AT(0x0000CE18) { FILL(0x00000000); build/asm/main_8022AB18.s.o(.text); build/asm/main_8022AB18.s.o(.rodata); build/asm/main_8022AB18.s.o(.data); }
    .main_8022AB18_bss (NOLOAD) : { build/asm/main_8022AB18.s.o(.bss); }
    .main_8022ACEC 0x8022ACEC : AT(0x0000CFEC) { build/asm/data/main_8022ACEC.bin.o(.data); }
    .main_8022B1E0 0x8022B1E0 : AT(0x0000D4E0) { FILL(0x00000000); build/asm/main_8022B1E0.s.o(.text); build/asm/main_8022B1E0.s.o(.rodata); build/asm/main_8022B1E0.s.o(.data); }
    .main_8022B1E0_bss (NOLOAD) : { build/asm/main_8022B1E0.s.o(.bss); }
    .main_8022B350 0x8022B350 : AT(0x0000D650) { build/asm/data/main_8022B350.bin.o(.data); }
    .main_8022B844 0x8022B844 : AT(0x0000DB44) { FILL(0x00000000); build/asm/main_8022B844.s.o(.text); build/asm/main_8022B844.s.o(.rodata); build/asm/main_8022B844.s.o(.data); }
    .main_8022B844_bss (NOLOAD) : { build/asm/main_8022B844.s.o(.bss); }
    .main_8022B9B0 0x8022B9B0 : AT(0x0000DCB0) { build/asm/data/main_8022B9B0.bin.o(.data); }
    .main_8022C798 0x8022C798 : AT(0x0000EA98) { FILL(0x00000000); build/asm/main_8022C798.s.o(.text); build/asm/main_8022C798.s.o(.rodata); build/asm/main_8022C798.s.o(.data); }
    .main_8022C798_bss (NOLOAD) : { build/asm/main_8022C798.s.o(.bss); }
    .main_8022C7A4 0x8022C7A4 : AT(0x0000EAA4) { build/asm/data/main_8022C7A4.bin.o(.data); }
    .main_8022CE80 0x8022CE80 : AT(0x0000F180) { FILL(0x00000000); build/asm/main_8022CE80.s.o(.text); build/asm/main_8022CE80.s.o(.rodata); build/asm/main_8022CE80.s.o(.data); }
    .main_8022CE80_bss (NOLOAD) : { build/asm/main_8022CE80.s.o(.bss); }
    .main_8022CEB4 0x8022CEB4 : AT(0x0000F1B4) { build/asm/data/main_8022CEB4.bin.o(.data); }
    .main_8022D9AC 0x8022D9AC : AT(0x0000FCAC) { FILL(0x00000000); build/asm/main_8022D9AC.s.o(.text); build/asm/main_8022D9AC.s.o(.rodata); build/asm/main_8022D9AC.s.o(.data); }
    .main_8022D9AC_bss (NOLOAD) : { build/asm/main_8022D9AC.s.o(.bss); }
    .main_8022DAD8 0x8022DAD8 : AT(0x0000FDD8) { build/asm/data/main_8022DAD8.bin.o(.data); }
    .main_8022F1F4 0x8022F1F4 : AT(0x000114F4) { FILL(0x00000000); build/asm/main_8022F1F4.s.o(.text); build/asm/main_8022F1F4.s.o(.rodata); build/asm/main_8022F1F4.s.o(.data); }
    .main_8022F1F4_bss (NOLOAD) : { build/asm/main_8022F1F4.s.o(.bss); }
    .main_8022F7B8 0x8022F7B8 : AT(0x00011AB8) { build/asm/data/main_8022F7B8.bin.o(.data); }
    .main_80230768 0x80230768 : AT(0x00012A68) { FILL(0x00000000); build/asm/main_80230768.s.o(.text); build/asm/main_80230768.s.o(.rodata); build/asm/main_80230768.s.o(.data); }
    .main_80230768_bss (NOLOAD) : { build/asm/main_80230768.s.o(.bss); }
    .main_80230790 0x80230790 : AT(0x00012A90) { build/asm/data/main_80230790.bin.o(.data); }
    .main_80230B34 0x80230B34 : AT(0x00012E34) { FILL(0x00000000); build/asm/main_80230B34.s.o(.text); build/asm/main_80230B34.s.o(.rodata); build/asm/main_80230B34.s.o(.data); }
    .main_80230B34_bss (NOLOAD) : { build/asm/main_80230B34.s.o(.bss); }
    .main_80230B40 0x80230B40 : AT(0x00012E40) { build/asm/data/main_80230B40.bin.o(.data); }
    .main_8023119C 0x8023119C : AT(0x0001349C) { FILL(0x00000000); build/asm/main_8023119C.s.o(.text); build/asm/main_8023119C.s.o(.rodata); build/asm/main_8023119C.s.o(.data); }
    .main_8023119C_bss (NOLOAD) : { build/asm/main_8023119C.s.o(.bss); }
    .main_802311E8 0x802311E8 : AT(0x000134E8) { build/asm/data/main_802311E8.bin.o(.data); }
    .main_80231358 0x80231358 : AT(0x00013658) { FILL(0x00000000); build/asm/main_80231358.s.o(.text); build/asm/main_80231358.s.o(.rodata); build/asm/main_80231358.s.o(.data); }
    .main_80231358_bss (NOLOAD) : { build/asm/main_80231358.s.o(.bss); }
    .main_8023135C 0x8023135C : AT(0x0001365C) { build/asm/data/main_8023135C.bin.o(.data); }
    .main_80231764 0x80231764 : AT(0x00013A64) { FILL(0x00000000); build/asm/main_80231764.s.o(.text); build/asm/main_80231764.s.o(.rodata); build/asm/main_80231764.s.o(.data); }
    .main_80231764_bss (NOLOAD) : { build/asm/main_80231764.s.o(.bss); }
    .main_8023178C 0x8023178C : AT(0x00013A8C) { build/asm/data/main_8023178C.bin.o(.data); }
    .main_80232760 0x80232760 : AT(0x00014A60) { FILL(0x00000000); build/asm/main_80232760.s.o(.text); build/asm/main_80232760.s.o(.rodata); build/asm/main_80232760.s.o(.data); }
    .main_80232760_bss (NOLOAD) : { build/asm/main_80232760.s.o(.bss); }
    .main_8023279C 0x8023279C : AT(0x00014A9C) { build/asm/data/main_8023279C.bin.o(.data); }
    .main_80233F0C 0x80233F0C : AT(0x0001620C) { FILL(0x00000000); build/asm/main_80233F0C.s.o(.text); build/asm/main_80233F0C.s.o(.rodata); build/asm/main_80233F0C.s.o(.data); }
    .main_80233F0C_bss (NOLOAD) : { build/asm/main_80233F0C.s.o(.bss); }
    .main_80233F14 0x80233F14 : AT(0x00016214) { build/asm/data/main_80233F14.bin.o(.data); }
    .main_802346EC 0x802346EC : AT(0x000169EC) { FILL(0x00000000); build/asm/main_802346EC.s.o(.text); build/asm/main_802346EC.s.o(.rodata); build/asm/main_802346EC.s.o(.data); }
    .main_802346EC_bss (NOLOAD) : { build/asm/main_802346EC.s.o(.bss); }
    .main_802346F0 0x802346F0 : AT(0x000169F0) { build/asm/data/main_802346F0.bin.o(.data); }
    .main_80234D74 0x80234D74 : AT(0x00017074) { FILL(0x00000000); build/asm/main_80234D74.s.o(.text); build/asm/main_80234D74.s.o(.rodata); build/asm/main_80234D74.s.o(.data); }
    .main_80234D74_bss (NOLOAD) : { build/asm/main_80234D74.s.o(.bss); }
    .main_80234D88 0x80234D88 : AT(0x00017088) { build/asm/data/main_80234D88.bin.o(.data); }
    .main_80235550 0x80235550 : AT(0x00017850) { FILL(0x00000000); build/asm/main_80235550.s.o(.text); build/asm/main_80235550.s.o(.rodata); build/asm/main_80235550.s.o(.data); }
    .main_80235550_bss (NOLOAD) : { build/asm/main_80235550.s.o(.bss); }
    .main_80235600 0x80235600 : AT(0x00017900) { build/asm/data/main_80235600.bin.o(.data); }
    .main_80235CEC 0x80235CEC : AT(0x00017FEC) { FILL(0x00000000); build/asm/main_80235CEC.s.o(.text); build/asm/main_80235CEC.s.o(.rodata); build/asm/main_80235CEC.s.o(.data); }
    .main_80235CEC_bss (NOLOAD) : { build/asm/main_80235CEC.s.o(.bss); }
    .main_80235CF0 0x80235CF0 : AT(0x00017FF0) { build/asm/data/main_80235CF0.bin.o(.data); }
    .main_80235E80 0x80235E80 : AT(0x00018180) { FILL(0x00000000); build/asm/main_80235E80.s.o(.text); build/asm/main_80235E80.s.o(.rodata); build/asm/main_80235E80.s.o(.data); }
    .main_80235E80_bss (NOLOAD) : { build/asm/main_80235E80.s.o(.bss); }
    .main_80235E8C 0x80235E8C : AT(0x0001818C) { build/asm/data/main_80235E8C.bin.o(.data); }
    .main_80236288 0x80236288 : AT(0x00018588) { FILL(0x00000000); build/asm/main_80236288.s.o(.text); build/asm/main_80236288.s.o(.rodata); build/asm/main_80236288.s.o(.data); }
    .main_80236288_bss (NOLOAD) : { build/asm/main_80236288.s.o(.bss); }
    .main_802362CC 0x802362CC : AT(0x000185CC) { build/asm/data/main_802362CC.bin.o(.data); }
    .main_80236308 0x80236308 : AT(0x00018608) { FILL(0x00000000); build/asm/main_80236308.s.o(.text); build/asm/main_80236308.s.o(.rodata); build/asm/main_80236308.s.o(.data); }
    .main_80236308_bss (NOLOAD) : { build/asm/main_80236308.s.o(.bss); }
    .main_80236364 0x80236364 : AT(0x00018664) { build/asm/data/main_80236364.bin.o(.data); }
    .main_80236550 0x80236550 : AT(0x00018850) { FILL(0x00000000); build/asm/main_80236550.s.o(.text); build/asm/main_80236550.s.o(.rodata); build/asm/main_80236550.s.o(.data); }
    .main_80236550_bss (NOLOAD) : { build/asm/main_80236550.s.o(.bss); }
    .main_802365A0 0x802365A0 : AT(0x000188A0) { build/asm/data/main_802365A0.bin.o(.data); }
    .main_8023757C 0x8023757C : AT(0x0001987C) { FILL(0x00000000); build/asm/main_8023757C.s.o(.text); build/asm/main_8023757C.s.o(.rodata); build/asm/main_8023757C.s.o(.data); }
    .main_8023757C_bss (NOLOAD) : { build/asm/main_8023757C.s.o(.bss); }
    .main_802375C4 0x802375C4 : AT(0x000198C4) { build/asm/data/main_802375C4.bin.o(.data); }
    .main_802380CC 0x802380CC : AT(0x0001A3CC) { FILL(0x00000000); build/asm/main_802380CC.s.o(.text); build/asm/main_802380CC.s.o(.rodata); build/asm/main_802380CC.s.o(.data); }
    .main_802380CC_bss (NOLOAD) : { build/asm/main_802380CC.s.o(.bss); }
    .main_802380E0 0x802380E0 : AT(0x0001A3E0) { build/asm/data/main_802380E0.bin.o(.data); }
    .main_80238184 0x80238184 : AT(0x0001A484) { FILL(0x00000000); build/asm/main_80238184.s.o(.text); build/asm/main_80238184.s.o(.rodata); build/asm/main_80238184.s.o(.data); }
    .main_80238184_bss (NOLOAD) : { build/asm/main_80238184.s.o(.bss); }
    .main_802381CC 0x802381CC : AT(0x0001A4CC) { build/asm/data/main_802381CC.bin.o(.data); }
    .main_80239058 0x80239058 : AT(0x0001B358) { FILL(0x00000000); build/asm/main_80239058.s.o(.text); build/asm/main_80239058.s.o(.rodata); build/asm/main_80239058.s.o(.data); }
    .main_80239058_bss (NOLOAD) : { build/asm/main_80239058.s.o(.bss); }
    .main_802390E8 0x802390E8 : AT(0x0001B3E8) { build/asm/data/main_802390E8.bin.o(.data); }
    .main_802394B4 0x802394B4 : AT(0x0001B7B4) { FILL(0x00000000); build/asm/main_802394B4.s.o(.text); build/asm/main_802394B4.s.o(.rodata); build/asm/main_802394B4.s.o(.data); }
    .main_802394B4_bss (NOLOAD) : { build/asm/main_802394B4.s.o(.bss); }
    .main_802394BC 0x802394BC : AT(0x0001B7BC) { build/asm/data/main_802394BC.bin.o(.data); }
    .main_802394E0 0x802394E0 : AT(0x0001B7E0) { FILL(0x00000000); build/asm/main_802394E0.s.o(.text); build/asm/main_802394E0.s.o(.rodata); build/asm/main_802394E0.s.o(.data); }
    .main_802394E0_bss (NOLOAD) : { build/asm/main_802394E0.s.o(.bss); }
    .main_80239574 0x80239574 : AT(0x0001B874) { build/asm/data/main_80239574.bin.o(.data); }
    .main_80239FA4 0x80239FA4 : AT(0x0001C2A4) { FILL(0x00000000); build/asm/main_80239FA4.s.o(.text); build/asm/main_80239FA4.s.o(.rodata); build/asm/main_80239FA4.s.o(.data); }
    .main_80239FA4_bss (NOLOAD) : { build/asm/main_80239FA4.s.o(.bss); }
    .main_80239FAC 0x80239FAC : AT(0x0001C2AC) { build/asm/data/main_80239FAC.bin.o(.data); }
    .main_8023A56C 0x8023A56C : AT(0x0001C86C) { FILL(0x00000000); build/asm/main_8023A56C.s.o(.text); build/asm/main_8023A56C.s.o(.rodata); build/asm/main_8023A56C.s.o(.data); }
    .main_8023A56C_bss (NOLOAD) : { build/asm/main_8023A56C.s.o(.bss); }
    .main_8023A5C4 0x8023A5C4 : AT(0x0001C8C4) { build/asm/data/main_8023A5C4.bin.o(.data); }
    .main_8023B324 0x8023B324 : AT(0x0001D624) { FILL(0x00000000); build/asm/main_8023B324.s.o(.text); build/asm/main_8023B324.s.o(.rodata); build/asm/main_8023B324.s.o(.data); }
    .main_8023B324_bss (NOLOAD) : { build/asm/main_8023B324.s.o(.bss); }
    .main_8023B354 0x8023B354 : AT(0x0001D654) { build/asm/data/main_8023B354.bin.o(.data); }
    .main_8023B3CC 0x8023B3CC : AT(0x0001D6CC) { FILL(0x00000000); build/asm/main_8023B3CC.s.o(.text); build/asm/main_8023B3CC.s.o(.rodata); build/asm/main_8023B3CC.s.o(.data); }
    .main_8023B3CC_bss (NOLOAD) : { build/asm/main_8023B3CC.s.o(.bss); }
    .main_8023B3E8 0x8023B3E8 : AT(0x0001D6E8) { build/asm/data/main_8023B3E8.bin.o(.data); }
    .main_8023BF94 0x8023BF94 : AT(0x0001E294) { FILL(0x00000000); build/asm/main_8023BF94.s.o(.text); build/asm/main_8023BF94.s.o(.rodata); build/asm/main_8023BF94.s.o(.data); }
    .main_8023BF94_bss (NOLOAD) : { build/asm/main_8023BF94.s.o(.bss); }
    .main_8023BF9C 0x8023BF9C : AT(0x0001E29C) { build/asm/data/main_8023BF9C.bin.o(.data); }
    .main_8023C57C 0x8023C57C : AT(0x0001E87C) { FILL(0x00000000); build/asm/main_8023C57C.s.o(.text); build/asm/main_8023C57C.s.o(.rodata); build/asm/main_8023C57C.s.o(.data); }
    .main_8023C57C_bss (NOLOAD) : { build/asm/main_8023C57C.s.o(.bss); }
    .main_8023C72C 0x8023C72C : AT(0x0001EA2C) { build/asm/data/main_8023C72C.bin.o(.data); }
    .main_8023C9A8 0x8023C9A8 : AT(0x0001ECA8) { FILL(0x00000000); build/asm/main_8023C9A8.s.o(.text); build/asm/main_8023C9A8.s.o(.rodata); build/asm/main_8023C9A8.s.o(.data); }
    .main_8023C9A8_bss (NOLOAD) : { build/asm/main_8023C9A8.s.o(.bss); }
    .main_8023C9EC 0x8023C9EC : AT(0x0001ECEC) { build/asm/data/main_8023C9EC.bin.o(.data); }
    .main_8023CEE8 0x8023CEE8 : AT(0x0001F1E8) { FILL(0x00000000); build/asm/main_8023CEE8.s.o(.text); build/asm/main_8023CEE8.s.o(.rodata); build/asm/main_8023CEE8.s.o(.data); }
    .main_8023CEE8_bss (NOLOAD) : { build/asm/main_8023CEE8.s.o(.bss); }
    .main_8023CEF8 0x8023CEF8 : AT(0x0001F1F8) { build/asm/data/main_8023CEF8.bin.o(.data); }
    .main_8023D1C0 0x8023D1C0 : AT(0x0001F4C0) { FILL(0x00000000); build/asm/main_8023D1C0.s.o(.text); build/asm/main_8023D1C0.s.o(.rodata); build/asm/main_8023D1C0.s.o(.data); }
    .main_8023D1C0_bss (NOLOAD) : { build/asm/main_8023D1C0.s.o(.bss); }
    .main_8023D2F8 0x8023D2F8 : AT(0x0001F5F8) { build/asm/data/main_8023D2F8.bin.o(.data); }
    .main_8023D47C 0x8023D47C : AT(0x0001F77C) { FILL(0x00000000); build/asm/main_8023D47C.s.o(.text); build/asm/main_8023D47C.s.o(.rodata); build/asm/main_8023D47C.s.o(.data); }
    .main_8023D47C_bss (NOLOAD) : { build/asm/main_8023D47C.s.o(.bss); }
    .main_8023D4A0 0x8023D4A0 : AT(0x0001F7A0) { build/asm/data/main_8023D4A0.bin.o(.data); }
    .main_8023D910 0x8023D910 : AT(0x0001FC10) { FILL(0x00000000); build/asm/main_8023D910.s.o(.text); build/asm/main_8023D910.s.o(.rodata); build/asm/main_8023D910.s.o(.data); }
    .main_8023D910_bss (NOLOAD) : { build/asm/main_8023D910.s.o(.bss); }
    .main_8023D968 0x8023D968 : AT(0x0001FC68) { build/asm/data/main_8023D968.bin.o(.data); }
    .main_8023DE44 0x8023DE44 : AT(0x00020144) { FILL(0x00000000); build/asm/main_8023DE44.s.o(.text); build/asm/main_8023DE44.s.o(.rodata); build/asm/main_8023DE44.s.o(.data); }
    .main_8023DE44_bss (NOLOAD) : { build/asm/main_8023DE44.s.o(.bss); }
    .main_8023DE54 0x8023DE54 : AT(0x00020154) { build/asm/data/main_8023DE54.bin.o(.data); }
    .main_8023DFD0 0x8023DFD0 : AT(0x000202D0) { FILL(0x00000000); build/asm/main_8023DFD0.s.o(.text); build/asm/main_8023DFD0.s.o(.rodata); build/asm/main_8023DFD0.s.o(.data); }
    .main_8023DFD0_bss (NOLOAD) : { build/asm/main_8023DFD0.s.o(.bss); }
    .main_8023E114 0x8023E114 : AT(0x00020414) { build/asm/data/main_8023E114.bin.o(.data); }
    .main_8023E14C 0x8023E14C : AT(0x0002044C) { FILL(0x00000000); build/asm/main_8023E14C.s.o(.text); build/asm/main_8023E14C.s.o(.rodata); build/asm/main_8023E14C.s.o(.data); }
    .main_8023E14C_bss (NOLOAD) : { build/asm/main_8023E14C.s.o(.bss); }
    .main_8023E164 0x8023E164 : AT(0x00020464) { build/asm/data/main_8023E164.bin.o(.data); }
    .main_8023E190 0x8023E190 : AT(0x00020490) { FILL(0x00000000); build/asm/main_8023E190.s.o(.text); build/asm/main_8023E190.s.o(.rodata); build/asm/main_8023E190.s.o(.data); }
    .main_8023E190_bss (NOLOAD) : { build/asm/main_8023E190.s.o(.bss); }
    .main_8023E298 0x8023E298 : AT(0x00020598) { build/asm/data/main_8023E298.bin.o(.data); }
    .main_8023E3A0 0x8023E3A0 : AT(0x000206A0) { FILL(0x00000000); build/asm/main_8023E3A0.s.o(.text); build/asm/main_8023E3A0.s.o(.rodata); build/asm/main_8023E3A0.s.o(.data); }
    .main_8023E3A0_bss (NOLOAD) : { build/asm/main_8023E3A0.s.o(.bss); }
    .main_8023E40C 0x8023E40C : AT(0x0002070C) { build/asm/data/main_8023E40C.bin.o(.data); }
    .main_8023E5C8 0x8023E5C8 : AT(0x000208C8) { FILL(0x00000000); build/asm/main_8023E5C8.s.o(.text); build/asm/main_8023E5C8.s.o(.rodata); build/asm/main_8023E5C8.s.o(.data); }
    .main_8023E5C8_bss (NOLOAD) : { build/asm/main_8023E5C8.s.o(.bss); }
    .main_8023E5F8 0x8023E5F8 : AT(0x000208F8) { build/asm/data/main_8023E5F8.bin.o(.data); }
    .main_8023E8A0 0x8023E8A0 : AT(0x00020BA0) { FILL(0x00000000); build/asm/main_8023E8A0.s.o(.text); build/asm/main_8023E8A0.s.o(.rodata); build/asm/main_8023E8A0.s.o(.data); }
    .main_8023E8A0_bss (NOLOAD) : { build/asm/main_8023E8A0.s.o(.bss); }
    .main_8023E8DC 0x8023E8DC : AT(0x00020BDC) { build/asm/data/main_8023E8DC.bin.o(.data); }
    .main_8023EAE4 0x8023EAE4 : AT(0x00020DE4) { FILL(0x00000000); build/asm/main_8023EAE4.s.o(.text); build/asm/main_8023EAE4.s.o(.rodata); build/asm/main_8023EAE4.s.o(.data); }
    .main_8023EAE4_bss (NOLOAD) : { build/asm/main_8023EAE4.s.o(.bss); }
    .main_8023EB44 0x8023EB44 : AT(0x00020E44) { build/asm/data/main_8023EB44.bin.o(.data); }
    .main_8023EC44 0x8023EC44 : AT(0x00020F44) { FILL(0x00000000); build/asm/main_8023EC44.s.o(.text); build/asm/main_8023EC44.s.o(.rodata); build/asm/main_8023EC44.s.o(.data); }
    .main_8023EC44_bss (NOLOAD) : { build/asm/main_8023EC44.s.o(.bss); }
    .main_8023ED98 0x8023ED98 : AT(0x00021098) { build/asm/data/main_8023ED98.bin.o(.data); }
    .main_8023EFC8 0x8023EFC8 : AT(0x000212C8) { FILL(0x00000000); build/asm/main_8023EFC8.s.o(.text); build/asm/main_8023EFC8.s.o(.rodata); build/asm/main_8023EFC8.s.o(.data); }
    .main_8023EFC8_bss (NOLOAD) : { build/asm/main_8023EFC8.s.o(.bss); }
    .main_8023F060 0x8023F060 : AT(0x00021360) { build/asm/data/main_8023F060.bin.o(.data); }
    .main_8023F264 0x8023F264 : AT(0x00021564) { FILL(0x00000000); build/asm/main_8023F264.s.o(.text); build/asm/main_8023F264.s.o(.rodata); build/asm/main_8023F264.s.o(.data); }
    .main_8023F264_bss (NOLOAD) : { build/asm/main_8023F264.s.o(.bss); }
    .main_8023F2B8 0x8023F2B8 : AT(0x000215B8) { build/asm/data/main_8023F2B8.bin.o(.data); }
    .main_8023F4C4 0x8023F4C4 : AT(0x000217C4) { FILL(0x00000000); build/asm/main_8023F4C4.s.o(.text); build/asm/main_8023F4C4.s.o(.rodata); build/asm/main_8023F4C4.s.o(.data); }
    .main_8023F4C4_bss (NOLOAD) : { build/asm/main_8023F4C4.s.o(.bss); }
    .main_8023F4CC 0x8023F4CC : AT(0x000217CC) { build/asm/data/main_8023F4CC.bin.o(.data); }
    .main_8023FB38 0x8023FB38 : AT(0x00021E38) { FILL(0x00000000); build/asm/main_8023FB38.s.o(.text); build/asm/main_8023FB38.s.o(.rodata); build/asm/main_8023FB38.s.o(.data); }
    .main_8023FB38_bss (NOLOAD) : { build/asm/main_8023FB38.s.o(.bss); }
    .main_8023FB70 0x8023FB70 : AT(0x00021E70) { build/asm/data/main_8023FB70.bin.o(.data); }
    .main_802400E0 0x802400E0 : AT(0x000223E0) { FILL(0x00000000); build/asm/main_802400E0.s.o(.text); build/asm/main_802400E0.s.o(.rodata); build/asm/main_802400E0.s.o(.data); }
    .main_802400E0_bss (NOLOAD) : { build/asm/main_802400E0.s.o(.bss); }
    .main_80240124 0x80240124 : AT(0x00022424) { build/asm/data/main_80240124.bin.o(.data); }
    .main_80240830 0x80240830 : AT(0x00022B30) { FILL(0x00000000); build/asm/main_80240830.s.o(.text); build/asm/main_80240830.s.o(.rodata); build/asm/main_80240830.s.o(.data); }
    .main_80240830_bss (NOLOAD) : { build/asm/main_80240830.s.o(.bss); }
    .main_80240854 0x80240854 : AT(0x00022B54) { build/asm/data/main_80240854.bin.o(.data); }
    .main_80243DEC 0x80243DEC : AT(0x000260EC) { FILL(0x00000000); build/asm/main_80243DEC.s.o(.text); build/asm/main_80243DEC.s.o(.rodata); build/asm/main_80243DEC.s.o(.data); }
    .main_80243DEC_bss (NOLOAD) : { build/asm/main_80243DEC.s.o(.bss); }
    .main_80243E28 0x80243E28 : AT(0x00026128) { build/asm/data/main_80243E28.bin.o(.data); }
    .main_80251870 0x80251870 : AT(0x00033B70) { build/asm/data/main_80251870.bin.o(.data); }
    .main_802518E0 0x802518E0 : AT(0x00033BE0) { build/asm/data/main_802518E0.bin.o(.data); }
    .main_80253320 0x80253320 : AT(0x00035620) { build/asm/data/main_80253320.bin.o(.data); }
    .main_802533BC 0x802533BC : AT(0x000356BC) { build/asm/data/main_802533BC.bin.o(.data); }
    .main_80256554 0x80256554 : AT(0x00038854) { build/asm/data/main_80256554.bin.o(.data); }
    .main_80256810 0x80256810 : AT(0x00038B10) { build/asm/data/main_80256810.bin.o(.data); }
    .main_8025699C 0x8025699C : AT(0x00038C9C) { build/asm/data/main_8025699C.bin.o(.data); }
    .main_802569D8 0x802569D8 : AT(0x00038CD8) { build/asm/data/main_802569D8.bin.o(.data); }
    .main_80259268 0x80259268 : AT(0x0003B568) { build/asm/data/main_80259268.bin.o(.data); }
    .main_8025929C 0x8025929C : AT(0x0003B59C) { build/asm/data/main_8025929C.bin.o(.data); }
    .main_80259750 0x80259750 : AT(0x0003BA50) { build/asm/data/main_80259750.bin.o(.data); }
    .main_8025975C 0x8025975C : AT(0x0003BA5C) { build/asm/data/main_8025975C.bin.o(.data); }
    .main_8025BCD4 0x8025BCD4 : AT(0x0003DFD4) { build/asm/data/main_8025BCD4.bin.o(.data); }
    .main_8025BCD8 0x8025BCD8 : AT(0x0003DFD8) { build/asm/data/main_8025BCD8.bin.o(.data); }
    .main_8025DF28 0x8025DF28 : AT(0x00040228) { build/asm/data/main_8025DF28.bin.o(.data); }
    .main_8025DF50 0x8025DF50 : AT(0x00040250) { build/asm/data/main_8025DF50.bin.o(.data); }
    .main_8025F63C 0x8025F63C : AT(0x0004193C) { build/asm/data/main_8025F63C.bin.o(.data); }
    .main_8025F64C 0x8025F64C : AT(0x0004194C) { build/asm/data/main_8025F64C.bin.o(.data); }
    .main_802604DC 0x802604DC : AT(0x000427DC) { build/asm/data/main_802604DC.bin.o(.data); }
    .main_80260514 0x80260514 : AT(0x00042814) { build/asm/data/main_80260514.bin.o(.data); }
    .main_80260EA4 0x80260EA4 : AT(0x000431A4) { build/asm/data/main_80260EA4.bin.o(.data); }
    .main_80261148 0x80261148 : AT(0x00043448) { build/asm/data/main_80261148.bin.o(.data); }
    .main_80261ADC 0x80261ADC : AT(0x00043DDC) { build/asm/data/main_80261ADC.bin.o(.data); }
    .main_80261B5C 0x80261B5C : AT(0x00043E5C) { build/asm/data/main_80261B5C.bin.o(.data); }
    .main_80262908 0x80262908 : AT(0x00044C08) { build/asm/data/main_80262908.bin.o(.data); }
    .main_80262AE4 0x80262AE4 : AT(0x00044DE4) { build/asm/data/main_80262AE4.bin.o(.data); }
    .main_80263AD0 0x80263AD0 : AT(0x00045DD0) { build/asm/data/main_80263AD0.bin.o(.data); }
    .main_80263C3C 0x80263C3C : AT(0x00045F3C) { build/asm/data/main_80263C3C.bin.o(.data); }
    .main_80263D30 0x80263D30 : AT(0x00046030) { build/asm/data/main_80263D30.bin.o(.data); }
    .main_80263D38 0x80263D38 : AT(0x00046038) { build/asm/data/main_80263D38.bin.o(.data); }
    .main_80263DA0 0x80263DA0 : AT(0x000460A0) { build/asm/data/main_80263DA0.bin.o(.data); }
    .main_80263E74 0x80263E74 : AT(0x00046174) { build/asm/data/main_80263E74.bin.o(.data); }
    .main_80263F9C 0x80263F9C : AT(0x0004629C) { build/asm/data/main_80263F9C.bin.o(.data); }
    .main_80263FA0 0x80263FA0 : AT(0x000462A0) { build/asm/data/main_80263FA0.bin.o(.data); }
    .main_8026407C 0x8026407C : AT(0x0004637C) { build/asm/data/main_8026407C.bin.o(.data); }
    .main_8026409C 0x8026409C : AT(0x0004639C) { build/asm/data/main_8026409C.bin.o(.data); }
    .main_80264364 0x80264364 : AT(0x00046664) { build/asm/data/main_80264364.bin.o(.data); }
    .main_80264380 0x80264380 : AT(0x00046680) { build/asm/data/main_80264380.bin.o(.data); }
    .main_80264834 0x80264834 : AT(0x00046B34) { build/asm/data/main_80264834.bin.o(.data); }
    .main_8026489C 0x8026489C : AT(0x00046B9C) { build/asm/data/main_8026489C.bin.o(.data); }
    .main_8026493C 0x8026493C : AT(0x00046C3C) { build/asm/data/main_8026493C.bin.o(.data); }
    .main_80264B34 0x80264B34 : AT(0x00046E34) { build/asm/data/main_80264B34.bin.o(.data); }
    .main_80264B78 0x80264B78 : AT(0x00046E78) { build/asm/data/main_80264B78.bin.o(.data); }
    .main_80264C2C 0x80264C2C : AT(0x00046F2C) { build/asm/data/main_80264C2C.bin.o(.data); }
    .main_80264D6C 0x80264D6C : AT(0x0004706C) { build/asm/data/main_80264D6C.bin.o(.data); }
    .main_802651B4 0x802651B4 : AT(0x000474B4) { build/asm/data/main_802651B4.bin.o(.data); }
    .main_80265238 0x80265238 : AT(0x00047538) { build/asm/data/main_80265238.bin.o(.data); }
    .main_802652C4 0x802652C4 : AT(0x000475C4) { build/asm/data/main_802652C4.bin.o(.data); }
    .main_80265ACC 0x80265ACC : AT(0x00047DCC) { build/asm/data/main_80265ACC.bin.o(.data); }
    .main_80265AEC 0x80265AEC : AT(0x00047DEC) { build/asm/data/main_80265AEC.bin.o(.data); }
    .main_80265B64 0x80265B64 : AT(0x00047E64) { build/asm/data/main_80265B64.bin.o(.data); }
    .main_80265BDC 0x80265BDC : AT(0x00047EDC) { build/asm/data/main_80265BDC.bin.o(.data); }
    .main_80265E40 0x80265E40 : AT(0x00048140) { build/asm/data/main_80265E40.bin.o(.data); }
    .main_80265E54 0x80265E54 : AT(0x00048154) { build/asm/data/main_80265E54.bin.o(.data); }
    .main_80265E80 0x80265E80 : AT(0x00048180) { build/asm/data/main_80265E80.bin.o(.data); }
    .main_80265E9C 0x80265E9C : AT(0x0004819C) { build/asm/data/main_80265E9C.bin.o(.data); }
    .main_802661FC 0x802661FC : AT(0x000484FC) { build/asm/data/main_802661FC.bin.o(.data); }
    .main_80266268 0x80266268 : AT(0x00048568) { build/asm/data/main_80266268.bin.o(.data); }
    .main_80266578 0x80266578 : AT(0x00048878) { build/asm/data/main_80266578.bin.o(.data); }
    .main_80266604 0x80266604 : AT(0x00048904) { build/asm/data/main_80266604.bin.o(.data); }
    .main_80266C88 0x80266C88 : AT(0x00048F88) { build/asm/data/main_80266C88.bin.o(.data); }
    .main_80266C90 0x80266C90 : AT(0x00048F90) { build/asm/data/main_80266C90.bin.o(.data); }
    .main_802671B0 0x802671B0 : AT(0x000494B0) { build/asm/data/main_802671B0.bin.o(.data); }
    .main_802671B8 0x802671B8 : AT(0x000494B8) { build/asm/data/main_802671B8.bin.o(.data); }
    .main_80267618 0x80267618 : AT(0x00049918) { build/asm/data/main_80267618.bin.o(.data); }
    .main_8026761C 0x8026761C : AT(0x0004991C) { build/asm/data/main_8026761C.bin.o(.data); }
    .main_802681D4 0x802681D4 : AT(0x0004A4D4) { build/asm/data/main_802681D4.bin.o(.data); }
    .main_802681F4 0x802681F4 : AT(0x0004A4F4) { build/asm/data/main_802681F4.bin.o(.data); }
    .main_802682C0 0x802682C0 : AT(0x0004A5C0) { build/asm/data/main_802682C0.bin.o(.data); }
    .main_80268458 0x80268458 : AT(0x0004A758) { build/asm/data/main_80268458.bin.o(.data); }
    .main_80269D0C 0x80269D0C : AT(0x0004C00C) { build/asm/data/main_80269D0C.bin.o(.data); }
    .main_80269D30 0x80269D30 : AT(0x0004C030) { build/asm/data/main_80269D30.bin.o(.data); }
    .main_8026A194 0x8026A194 : AT(0x0004C494) { build/asm/data/main_8026A194.bin.o(.data); }
    .main_8026A1BC 0x8026A1BC : AT(0x0004C4BC) { build/asm/data/main_8026A1BC.bin.o(.data); }
    .main_8026A85C 0x8026A85C : AT(0x0004CB5C) { build/asm/data/main_8026A85C.bin.o(.data); }
    .main_8026A870 0x8026A870 : AT(0x0004CB70) { build/asm/data/main_8026A870.bin.o(.data); }
    .main_8026C66C 0x8026C66C : AT(0x0004E96C) { build/asm/data/main_8026C66C.bin.o(.data); }
    .main_8026C6A8 0x8026C6A8 : AT(0x0004E9A8) { build/asm/data/main_8026C6A8.bin.o(.data); }
    .main_8026D178 0x8026D178 : AT(0x0004F478) { build/asm/data/main_8026D178.bin.o(.data); }
    .main_8026D188 0x8026D188 : AT(0x0004F488) { build/asm/data/main_8026D188.bin.o(.data); }
    .main_8026EC60 0x8026EC60 : AT(0x00050F60) { build/asm/data/main_8026EC60.bin.o(.data); }
    .main_8026EC68 0x8026EC68 : AT(0x00050F68) { build/asm/data/main_8026EC68.bin.o(.data); }
    .main_8026FEF8 0x8026FEF8 : AT(0x000521F8) { build/asm/data/main_8026FEF8.bin.o(.data); }
    .main_8026FF1C 0x8026FF1C : AT(0x0005221C) { build/asm/data/main_8026FF1C.bin.o(.data); }
    .main_802702A4 0x802702A4 : AT(0x000525A4) { build/asm/data/main_802702A4.bin.o(.data); }
    .main_802702A8 0x802702A8 : AT(0x000525A8) { build/asm/data/main_802702A8.bin.o(.data); }
    .main_802704D0 0x802704D0 : AT(0x000527D0) { build/asm/data/main_802704D0.bin.o(.data); }
    .main_802704D4 0x802704D4 : AT(0x000527D4) { build/asm/data/main_802704D4.bin.o(.data); }
    .main_8027051C 0x8027051C : AT(0x0005281C) { build/asm/data/main_8027051C.bin.o(.data); }
    .main_80270520 0x80270520 : AT(0x00052820) { build/asm/data/main_80270520.bin.o(.data); }
    .main_802705F0 0x802705F0 : AT(0x000528F0) { build/asm/data/main_802705F0.bin.o(.data); }
    .main_80270604 0x80270604 : AT(0x00052904) { build/asm/data/main_80270604.bin.o(.data); }
    .main_802708F4 0x802708F4 : AT(0x00052BF4) { build/asm/data/main_802708F4.bin.o(.data); }
    .main_80270904 0x80270904 : AT(0x00052C04) { build/asm/data/main_80270904.bin.o(.data); }
    .main_80270DB0 0x80270DB0 : AT(0x000530B0) { build/asm/data/main_80270DB0.bin.o(.data); }
    .main_80270DE0 0x80270DE0 : AT(0x000530E0) { build/asm/data/main_80270DE0.bin.o(.data); }
    .main_80271764 0x80271764 : AT(0x00053A64) { build/asm/data/main_80271764.bin.o(.data); }
    .main_80271768 0x80271768 : AT(0x00053A68) { build/asm/data/main_80271768.bin.o(.data); }
    .main_802721AC 0x802721AC : AT(0x000544AC) { build/asm/data/main_802721AC.bin.o(.data); }
    .main_802721D0 0x802721D0 : AT(0x000544D0) { build/asm/data/main_802721D0.bin.o(.data); }
    .main_802722E4 0x802722E4 : AT(0x000545E4) { build/asm/data/main_802722E4.bin.o(.data); }
    .main_802722E8 0x802722E8 : AT(0x000545E8) { build/asm/data/main_802722E8.bin.o(.data); }
    .main_80272CDC 0x80272CDC : AT(0x00054FDC) { build/asm/data/main_80272CDC.bin.o(.data); }
    .main_80272CF4 0x80272CF4 : AT(0x00054FF4) { build/asm/data/main_80272CF4.bin.o(.data); }
    .main_8027355C 0x8027355C : AT(0x0005585C) { build/asm/data/main_8027355C.bin.o(.data); }
    .main_80273564 0x80273564 : AT(0x00055864) { build/asm/data/main_80273564.bin.o(.data); }
    .main_80274C94 0x80274C94 : AT(0x00056F94) { build/asm/data/main_80274C94.bin.o(.data); }
    .main_80274CDC 0x80274CDC : AT(0x00056FDC) { build/asm/data/main_80274CDC.bin.o(.data); }
    .main_80274EB4 0x80274EB4 : AT(0x000571B4) { build/asm/data/main_80274EB4.bin.o(.data); }
    .main_80274EC0 0x80274EC0 : AT(0x000571C0) { build/asm/data/main_80274EC0.bin.o(.data); }
    .main_80275340 0x80275340 : AT(0x00057640) { build/asm/data/main_80275340.bin.o(.data); }
    .main_80275364 0x80275364 : AT(0x00057664) { build/asm/data/main_80275364.bin.o(.data); }
    .main_80275640 0x80275640 : AT(0x00057940) { build/asm/data/main_80275640.bin.o(.data); }
    .main_80275644 0x80275644 : AT(0x00057944) { build/asm/data/main_80275644.bin.o(.data); }
    .main_80275C38 0x80275C38 : AT(0x00057F38) { build/asm/data/main_80275C38.bin.o(.data); }
    .main_80275C4C 0x80275C4C : AT(0x00057F4C) { build/asm/data/main_80275C4C.bin.o(.data); }
    .main_80275EDC 0x80275EDC : AT(0x000581DC) { build/asm/data/main_80275EDC.bin.o(.data); }
    .main_80275F3C 0x80275F3C : AT(0x0005823C) { build/asm/data/main_80275F3C.bin.o(.data); }
    .main_802764C4 0x802764C4 : AT(0x000587C4) { build/asm/data/main_802764C4.bin.o(.data); }
    .main_802764D8 0x802764D8 : AT(0x000587D8) { build/asm/data/main_802764D8.bin.o(.data); }
    .main_802765A8 0x802765A8 : AT(0x000588A8) { build/asm/data/main_802765A8.bin.o(.data); }
    .main_802765B0 0x802765B0 : AT(0x000588B0) { build/asm/data/main_802765B0.bin.o(.data); }
    .main_80276F08 0x80276F08 : AT(0x00059208) { build/asm/data/main_80276F08.bin.o(.data); }
    .main_80276F20 0x80276F20 : AT(0x00059220) { build/asm/data/main_80276F20.bin.o(.data); }
    .main_80277034 0x80277034 : AT(0x00059334) { build/asm/data/main_80277034.bin.o(.data); }
    .main_8027704C 0x8027704C : AT(0x0005934C) { build/asm/data/main_8027704C.bin.o(.data); }
    .main_802781BC 0x802781BC : AT(0x0005A4BC) { build/asm/data/main_802781BC.bin.o(.data); }
    .main_802781D8 0x802781D8 : AT(0x0005A4D8) { build/asm/data/main_802781D8.bin.o(.data); }
    .main_802786E8 0x802786E8 : AT(0x0005A9E8) { build/asm/data/main_802786E8.bin.o(.data); }
    .main_802786F0 0x802786F0 : AT(0x0005A9F0) { build/asm/data/main_802786F0.bin.o(.data); }
    .main_80278758 0x80278758 : AT(0x0005AA58) { build/asm/data/main_80278758.bin.o(.data); }
    .main_802787D4 0x802787D4 : AT(0x0005AAD4) { build/asm/data/main_802787D4.bin.o(.data); }
    .main_80278888 0x80278888 : AT(0x0005AB88) { build/asm/data/main_80278888.bin.o(.data); }
    .main_80278898 0x80278898 : AT(0x0005AB98) { build/asm/data/main_80278898.bin.o(.data); }
    .main_80278DF0 0x80278DF0 : AT(0x0005B0F0) { build/asm/data/main_80278DF0.bin.o(.data); }
    .main_80278E38 0x80278E38 : AT(0x0005B138) { build/asm/data/main_80278E38.bin.o(.data); }
    .main_802799C4 0x802799C4 : AT(0x0005BCC4) { build/asm/data/main_802799C4.bin.o(.data); }
    .main_802799EC 0x802799EC : AT(0x0005BCEC) { build/asm/data/main_802799EC.bin.o(.data); }
    .main_80279AAC 0x80279AAC : AT(0x0005BDAC) { build/asm/data/main_80279AAC.bin.o(.data); }
    .main_80279AE8 0x80279AE8 : AT(0x0005BDE8) { build/asm/data/main_80279AE8.bin.o(.data); }
    .main_80279E84 0x80279E84 : AT(0x0005C184) { build/asm/data/main_80279E84.bin.o(.data); }
    .main_80279E98 0x80279E98 : AT(0x0005C198) { build/asm/data/main_80279E98.bin.o(.data); }
    .main_8027A29C 0x8027A29C : AT(0x0005C59C) { build/asm/data/main_8027A29C.bin.o(.data); }
    .main_8027A2AC 0x8027A2AC : AT(0x0005C5AC) { build/asm/data/main_8027A2AC.bin.o(.data); }
    .main_8027A4B4 0x8027A4B4 : AT(0x0005C7B4) { build/asm/data/main_8027A4B4.bin.o(.data); }
    .main_8027A4C4 0x8027A4C4 : AT(0x0005C7C4) { build/asm/data/main_8027A4C4.bin.o(.data); }
    .main_8027A564 0x8027A564 : AT(0x0005C864) { build/asm/data/main_8027A564.bin.o(.data); }
    .main_8027A56C 0x8027A56C : AT(0x0005C86C) { build/asm/data/main_8027A56C.bin.o(.data); }
    .main_8027A7AC 0x8027A7AC : AT(0x0005CAAC) { build/asm/data/main_8027A7AC.bin.o(.data); }
    .main_8027A7B0 0x8027A7B0 : AT(0x0005CAB0) { build/asm/data/main_8027A7B0.bin.o(.data); }
    .main_8027A880 0x8027A880 : AT(0x0005CB80) { build/asm/data/main_8027A880.bin.o(.data); }
    .main_8027A8B8 0x8027A8B8 : AT(0x0005CBB8) { build/asm/data/main_8027A8B8.bin.o(.data); }
    .main_8027BA6C 0x8027BA6C : AT(0x0005DD6C) { build/asm/data/main_8027BA6C.bin.o(.data); }
    .main_8027BB18 0x8027BB18 : AT(0x0005DE18) { build/asm/data/main_8027BB18.bin.o(.data); }
    .main_8027BD90 0x8027BD90 : AT(0x0005E090) { build/asm/data/main_8027BD90.bin.o(.data); }
    .main_8027BD98 0x8027BD98 : AT(0x0005E098) { build/asm/data/main_8027BD98.bin.o(.data); }
    .main_8027C0C8 0x8027C0C8 : AT(0x0005E3C8) { build/asm/data/main_8027C0C8.bin.o(.data); }
    .main_8027C110 0x8027C110 : AT(0x0005E410) { build/asm/data/main_8027C110.bin.o(.data); }
    .main_8027C60C 0x8027C60C : AT(0x0005E90C) { build/asm/data/main_8027C60C.bin.o(.data); }
    .main_8027C62C 0x8027C62C : AT(0x0005E92C) { build/asm/data/main_8027C62C.bin.o(.data); }
    .main_8027CCC0 0x8027CCC0 : AT(0x0005EFC0) { build/asm/data/main_8027CCC0.bin.o(.data); }
    .main_8027CCF0 0x8027CCF0 : AT(0x0005EFF0) { build/asm/data/main_8027CCF0.bin.o(.data); }
    .main_8027D108 0x8027D108 : AT(0x0005F408) { build/asm/data/main_8027D108.bin.o(.data); }
    .main_8027D110 0x8027D110 : AT(0x0005F410) { build/asm/data/main_8027D110.bin.o(.data); }
    .main_8027D5C0 0x8027D5C0 : AT(0x0005F8C0) { build/asm/data/main_8027D5C0.bin.o(.data); }
    .main_8027D5E0 0x8027D5E0 : AT(0x0005F8E0) { build/asm/data/main_8027D5E0.bin.o(.data); }
    .main_8027D704 0x8027D704 : AT(0x0005FA04) { build/asm/data/main_8027D704.bin.o(.data); }
    .main_8027D724 0x8027D724 : AT(0x0005FA24) { build/asm/data/main_8027D724.bin.o(.data); }
    .main_8027DB80 0x8027DB80 : AT(0x0005FE80) { build/asm/data/main_8027DB80.bin.o(.data); }
    .main_8027DB88 0x8027DB88 : AT(0x0005FE88) { build/asm/data/main_8027DB88.bin.o(.data); }
    .main_8027E168 0x8027E168 : AT(0x00060468) { build/asm/data/main_8027E168.bin.o(.data); }
    .main_8027E208 0x8027E208 : AT(0x00060508) { build/asm/data/main_8027E208.bin.o(.data); }
    .main_8027E270 0x8027E270 : AT(0x00060570) { build/asm/data/main_8027E270.bin.o(.data); }
    .main_8027E2FC 0x8027E2FC : AT(0x000605FC) { build/asm/data/main_8027E2FC.bin.o(.data); }
    .main_8027E540 0x8027E540 : AT(0x00060840) { build/asm/data/main_8027E540.bin.o(.data); }
    .main_8027E584 0x8027E584 : AT(0x00060884) { build/asm/data/main_8027E584.bin.o(.data); }
    .main_8027E648 0x8027E648 : AT(0x00060948) { build/asm/data/main_8027E648.bin.o(.data); }
    .main_8027E650 0x8027E650 : AT(0x00060950) { build/asm/data/main_8027E650.bin.o(.data); }
    .main_8027E7D0 0x8027E7D0 : AT(0x00060AD0) { build/asm/data/main_8027E7D0.bin.o(.data); }
    .main_8027E7FC 0x8027E7FC : AT(0x00060AFC) { build/asm/data/main_8027E7FC.bin.o(.data); }
    .main_8027EC64 0x8027EC64 : AT(0x00060F64) { build/asm/data/main_8027EC64.bin.o(.data); }
    .main_8027ECF8 0x8027ECF8 : AT(0x00060FF8) { build/asm/data/main_8027ECF8.bin.o(.data); }
    .main_8027ED70 0x8027ED70 : AT(0x00061070) { build/asm/data/main_8027ED70.bin.o(.data); }
    .main_8027EE00 0x8027EE00 : AT(0x00061100) { build/asm/data/main_8027EE00.bin.o(.data); }
    .main_8027F07C 0x8027F07C : AT(0x0006137C) { build/asm/data/main_8027F07C.bin.o(.data); }
    .main_8027F0B4 0x8027F0B4 : AT(0x000613B4) { build/asm/data/main_8027F0B4.bin.o(.data); }
    .main_8027F5CC 0x8027F5CC : AT(0x000618CC) { build/asm/data/main_8027F5CC.bin.o(.data); }
    .main_8027F63C 0x8027F63C : AT(0x0006193C) { build/asm/data/main_8027F63C.bin.o(.data); }
    .main_8027FF6C 0x8027FF6C : AT(0x0006226C) { build/asm/data/main_8027FF6C.bin.o(.data); }
    .main_8027FFC0 0x8027FFC0 : AT(0x000622C0) { build/asm/data/main_8027FFC0.bin.o(.data); }
    .main_80280004 0x80280004 : AT(0x00062304) { build/asm/data/main_80280004.bin.o(.data); }
    .main_8028009C 0x8028009C : AT(0x0006239C) { build/asm/data/main_8028009C.bin.o(.data); }
    .main_802804A8 0x802804A8 : AT(0x000627A8) { build/asm/data/main_802804A8.bin.o(.data); }
    .main_802804AC 0x802804AC : AT(0x000627AC) { build/asm/data/main_802804AC.bin.o(.data); }
    .main_80280EB0 0x80280EB0 : AT(0x000631B0) { build/asm/data/main_80280EB0.bin.o(.data); }
    .main_80280F9C 0x80280F9C : AT(0x0006329C) { build/asm/data/main_80280F9C.bin.o(.data); }
    .main_802815DC 0x802815DC : AT(0x000638DC) { build/asm/data/main_802815DC.bin.o(.data); }
    .main_8028164C 0x8028164C : AT(0x0006394C) { build/asm/data/main_8028164C.bin.o(.data); }
    .main_80281764 0x80281764 : AT(0x00063A64) { build/asm/data/main_80281764.bin.o(.data); }
    .main_802817F8 0x802817F8 : AT(0x00063AF8) { build/asm/data/main_802817F8.bin.o(.data); }
    .main_80281A7C 0x80281A7C : AT(0x00063D7C) { build/asm/data/main_80281A7C.bin.o(.data); }
    .main_80281CEC 0x80281CEC : AT(0x00063FEC) { build/asm/data/main_80281CEC.bin.o(.data); }
    .main_80281D6C 0x80281D6C : AT(0x0006406C) { build/asm/data/main_80281D6C.bin.o(.data); }
    .main_80281D78 0x80281D78 : AT(0x00064078) { build/asm/data/main_80281D78.bin.o(.data); }
    .main_80281EEC 0x80281EEC : AT(0x000641EC) { build/asm/data/main_80281EEC.bin.o(.data); }
    .main_80281F38 0x80281F38 : AT(0x00064238) { build/asm/data/main_80281F38.bin.o(.data); }
    .main_802823C0 0x802823C0 : AT(0x000646C0) { build/asm/data/main_802823C0.bin.o(.data); }
    .main_80282430 0x80282430 : AT(0x00064730) { build/asm/data/main_80282430.bin.o(.data); }
    .main_80282850 0x80282850 : AT(0x00064B50) { build/asm/data/main_80282850.bin.o(.data); }
    .main_802828D4 0x802828D4 : AT(0x00064BD4) { build/asm/data/main_802828D4.bin.o(.data); }
    .main_80283C20 0x80283C20 : AT(0x00065F20) { build/asm/data/main_80283C20.bin.o(.data); }
    .main_80283DB8 0x80283DB8 : AT(0x000660B8) { build/asm/data/main_80283DB8.bin.o(.data); }
    .main_80284528 0x80284528 : AT(0x00066828) { build/asm/data/main_80284528.bin.o(.data); }
    .main_802845A8 0x802845A8 : AT(0x000668A8) { build/asm/data/main_802845A8.bin.o(.data); }
    .main_80285060 0x80285060 : AT(0x00067360) { build/asm/data/main_80285060.bin.o(.data); }
    .main_80285074 0x80285074 : AT(0x00067374) { build/asm/data/main_80285074.bin.o(.data); }
    .main_802850A4 0x802850A4 : AT(0x000673A4) { build/asm/data/main_802850A4.bin.o(.data); }
    .main_802851C0 0x802851C0 : AT(0x000674C0) { build/asm/data/main_802851C0.bin.o(.data); }
    .main_802851E0 0x802851E0 : AT(0x000674E0) { build/asm/data/main_802851E0.bin.o(.data); }
    .main_802851F4 0x802851F4 : AT(0x000674F4) { build/asm/data/main_802851F4.bin.o(.data); }
    .main_8028567C 0x8028567C : AT(0x0006797C) { build/asm/data/main_8028567C.bin.o(.data); }
    .main_802856E0 0x802856E0 : AT(0x000679E0) { build/asm/data/main_802856E0.bin.o(.data); }
    .main_80285B50 0x80285B50 : AT(0x00067E50) { build/asm/data/main_80285B50.bin.o(.data); }
    .main_80285BA4 0x80285BA4 : AT(0x00067EA4) { build/asm/data/main_80285BA4.bin.o(.data); }
    .main_802868BC 0x802868BC : AT(0x00068BBC) { build/asm/data/main_802868BC.bin.o(.data); }
    .main_802868C8 0x802868C8 : AT(0x00068BC8) { build/asm/data/main_802868C8.bin.o(.data); }
    .main_802886CC 0x802886CC : AT(0x0006A9CC) { build/asm/data/main_802886CC.bin.o(.data); }
    .main_802886EC 0x802886EC : AT(0x0006A9EC) { build/asm/data/main_802886EC.bin.o(.data); }
    .main_802894D8 0x802894D8 : AT(0x0006B7D8) { build/asm/data/main_802894D8.bin.o(.data); }
    .main_802894E0 0x802894E0 : AT(0x0006B7E0) { build/asm/data/main_802894E0.bin.o(.data); }
    .main_802898BC 0x802898BC : AT(0x0006BBBC) { build/asm/data/main_802898BC.bin.o(.data); }
    .main_802898D0 0x802898D0 : AT(0x0006BBD0) { build/asm/data/main_802898D0.bin.o(.data); }
    .main_8028A098 0x8028A098 : AT(0x0006C398) { build/asm/data/main_8028A098.bin.o(.data); }
    .main_8028A0BC 0x8028A0BC : AT(0x0006C3BC) { build/asm/data/main_8028A0BC.bin.o(.data); }
    .main_80299914 0x80299914 : AT(0x0007BC14) { build/asm/data/main_80299914.bin.o(.data); }
    .main_8029999C 0x8029999C : AT(0x0007BC9C) { build/asm/data/main_8029999C.bin.o(.data); }
    .main_80299B6C 0x80299B6C : AT(0x0007BE6C) { build/asm/data/main_80299B6C.bin.o(.data); }
    .main_80299C4C 0x80299C4C : AT(0x0007BF4C) { build/asm/data/main_80299C4C.bin.o(.data); }
    .main_8029C75C 0x8029C75C : AT(0x0007EA5C) { build/asm/data/main_8029C75C.bin.o(.data); }
    .main_8029C8AC 0x8029C8AC : AT(0x0007EBAC) { build/asm/data/main_8029C8AC.bin.o(.data); }
    .main_8029CB34 0x8029CB34 : AT(0x0007EE34) { build/asm/data/main_8029CB34.bin.o(.data); }
    .main_8029CB44 0x8029CB44 : AT(0x0007EE44) { build/asm/data/main_8029CB44.bin.o(.data); }
    .main_8029D3B8 0x8029D3B8 : AT(0x0007F6B8) { build/asm/data/main_8029D3B8.bin.o(.data); }
    .main_8029D3E4 0x8029D3E4 : AT(0x0007F6E4) { build/asm/data/main_8029D3E4.bin.o(.data); }
    .main_8029DD18 0x8029DD18 : AT(0x00080018) { build/asm/data/main_8029DD18.bin.o(.data); }
    .main_8029DDE0 0x8029DDE0 : AT(0x000800E0) { build/asm/data/main_8029DDE0.bin.o(.data); }
    .main_802A0C8C 0x802A0C8C : AT(0x00082F8C) { build/asm/data/main_802A0C8C.bin.o(.data); }
    .main_802A0CF0 0x802A0CF0 : AT(0x00082FF0) { build/asm/data/main_802A0CF0.bin.o(.data); }
    .main_802A55E4 0x802A55E4 : AT(0x000878E4) { build/asm/data/main_802A55E4.bin.o(.data); }
    .main_802A5684 0x802A5684 : AT(0x00087984) { build/asm/data/main_802A5684.bin.o(.data); }
    .main_802A85D0 0x802A85D0 : AT(0x0008A8D0) { build/asm/data/main_802A85D0.bin.o(.data); }
    .main_802A85E8 0x802A85E8 : AT(0x0008A8E8) { build/asm/data/main_802A85E8.bin.o(.data); }
    .main_802A8FB4 0x802A8FB4 : AT(0x0008B2B4) { build/asm/data/main_802A8FB4.bin.o(.data); }
    .main_802A92E4 0x802A92E4 : AT(0x0008B5E4) { build/asm/data/main_802A92E4.bin.o(.data); }
    .main_802AA190 0x802AA190 : AT(0x0008C490) { build/asm/data/main_802AA190.bin.o(.data); }
    .main_802AA1E4 0x802AA1E4 : AT(0x0008C4E4) { build/asm/data/main_802AA1E4.bin.o(.data); }
    .main_802AADD4 0x802AADD4 : AT(0x0008D0D4) { build/asm/data/main_802AADD4.bin.o(.data); }
    .main_802AB1BC 0x802AB1BC : AT(0x0008D4BC) { build/asm/data/main_802AB1BC.bin.o(.data); }
    .main_802B7E2C 0x802B7E2C : AT(0x0009A12C) { build/asm/data/main_802B7E2C.bin.o(.data); }
    .main_802B85FC 0x802B85FC : AT(0x0009A8FC) { build/asm/data/main_802B85FC.bin.o(.data); }
    .main_802B867C 0x802B867C : AT(0x0009A97C) { build/asm/data/main_802B867C.bin.o(.data); }
    .main_802B8704 0x802B8704 : AT(0x0009AA04) { build/asm/data/main_802B8704.bin.o(.data); }
    .main_802B93C0 0x802B93C0 : AT(0x0009B6C0) { build/asm/data/main_802B93C0.bin.o(.data); }
    .main_802B93E8 0x802B93E8 : AT(0x0009B6E8) { build/asm/data/main_802B93E8.bin.o(.data); }
    .main_802B9580 0x802B9580 : AT(0x0009B880) { build/asm/data/main_802B9580.bin.o(.data); }
    .main_802B9668 0x802B9668 : AT(0x0009B968) { build/asm/data/main_802B9668.bin.o(.data); }
    .main_802B98C8 0x802B98C8 : AT(0x0009BBC8) { build/asm/data/main_802B98C8.bin.o(.data); }
    .main_802B99A8 0x802B99A8 : AT(0x0009BCA8) { build/asm/data/main_802B99A8.bin.o(.data); }
    .main_802B9D74 0x802B9D74 : AT(0x0009C074) { build/asm/data/main_802B9D74.bin.o(.data); }
    .main_802B9DC4 0x802B9DC4 : AT(0x0009C0C4) { build/asm/data/main_802B9DC4.bin.o(.data); }
    .main_802BA354 0x802BA354 : AT(0x0009C654) { build/asm/data/main_802BA354.bin.o(.data); }
    .main_802BA400 0x802BA400 : AT(0x0009C700) { build/asm/data/main_802BA400.bin.o(.data); }
    .main_802BA538 0x802BA538 : AT(0x0009C838) { build/asm/data/main_802BA538.bin.o(.data); }
    .main_802BA5A8 0x802BA5A8 : AT(0x0009C8A8) { build/asm/data/main_802BA5A8.bin.o(.data); }
    .main_802BA64C 0x802BA64C : AT(0x0009C94C) { build/asm/data/main_802BA64C.bin.o(.data); }
    .main_802BA740 0x802BA740 : AT(0x0009CA40) { build/asm/data/main_802BA740.bin.o(.data); }
    .main_802BA880 0x802BA880 : AT(0x0009CB80) { build/asm/data/main_802BA880.bin.o(.data); }
    .main_802BA908 0x802BA908 : AT(0x0009CC08) { build/asm/data/main_802BA908.bin.o(.data); }
    .main_802BABD4 0x802BABD4 : AT(0x0009CED4) { build/asm/data/main_802BABD4.bin.o(.data); }
    .main_802BABF4 0x802BABF4 : AT(0x0009CEF4) { build/asm/data/main_802BABF4.bin.o(.data); }
    .main_802BAE6C 0x802BAE6C : AT(0x0009D16C) { build/asm/data/main_802BAE6C.bin.o(.data); }
    .main_802BAF28 0x802BAF28 : AT(0x0009D228) { build/asm/data/main_802BAF28.bin.o(.data); }
    .main_802BB400 0x802BB400 : AT(0x0009D700) { build/asm/data/main_802BB400.bin.o(.data); }
    .main_802BB4CC 0x802BB4CC : AT(0x0009D7CC) { build/asm/data/main_802BB4CC.bin.o(.data); }
    .main_802BB6C4 0x802BB6C4 : AT(0x0009D9C4) { build/asm/data/main_802BB6C4.bin.o(.data); }
    .main_802BB870 0x802BB870 : AT(0x0009DB70) { build/asm/data/main_802BB870.bin.o(.data); }
    .main_802BB898 0x802BB898 : AT(0x0009DB98) { build/asm/data/main_802BB898.bin.o(.data); }
    .main_802BB8A8 0x802BB8A8 : AT(0x0009DBA8) { build/asm/data/main_802BB8A8.bin.o(.data); }
    .main_802BB91C 0x802BB91C : AT(0x0009DC1C) { build/asm/data/main_802BB91C.bin.o(.data); }
    .main_802BB9C0 0x802BB9C0 : AT(0x0009DCC0) { build/asm/data/main_802BB9C0.bin.o(.data); }
    .main_802BBA08 0x802BBA08 : AT(0x0009DD08) { build/asm/data/main_802BBA08.bin.o(.data); }
    .main_802BBA18 0x802BBA18 : AT(0x0009DD18) { build/asm/data/main_802BBA18.bin.o(.data); }
    .main_802BBB40 0x802BBB40 : AT(0x0009DE40) { build/asm/data/main_802BBB40.bin.o(.data); }
    .main_802BBB50 0x802BBB50 : AT(0x0009DE50) { build/asm/data/main_802BBB50.bin.o(.data); }
    .main_802BBBE0 0x802BBBE0 : AT(0x0009DEE0) { build/asm/data/main_802BBBE0.bin.o(.data); }
    .main_802BBC14 0x802BBC14 : AT(0x0009DF14) { build/asm/data/main_802BBC14.bin.o(.data); }
    .main_802BC024 0x802BC024 : AT(0x0009E324) { build/asm/data/main_802BC024.bin.o(.data); }
    .main_802BC054 0x802BC054 : AT(0x0009E354) { build/asm/data/main_802BC054.bin.o(.data); }
    .main_802BC070 0x802BC070 : AT(0x0009E370) { build/asm/data/main_802BC070.bin.o(.data); }
    .main_802BC0A8 0x802BC0A8 : AT(0x0009E3A8) { build/asm/data/main_802BC0A8.bin.o(.data); }
    .main_802BC118 0x802BC118 : AT(0x0009E418) { build/asm/data/main_802BC118.bin.o(.data); }
    .main_802BC12C 0x802BC12C : AT(0x0009E42C) { build/asm/data/main_802BC12C.bin.o(.data); }
    .main_802BC564 0x802BC564 : AT(0x0009E864) { build/asm/data/main_802BC564.bin.o(.data); }
    .main_802BC570 0x802BC570 : AT(0x0009E870) { build/asm/data/main_802BC570.bin.o(.data); }
    .main_802BC6C0 0x802BC6C0 : AT(0x0009E9C0) { build/asm/data/main_802BC6C0.bin.o(.data); }
    .main_802BC6D0 0x802BC6D0 : AT(0x0009E9D0) { build/asm/data/main_802BC6D0.bin.o(.data); }
    .main_802BC878 0x802BC878 : AT(0x0009EB78) { build/asm/data/main_802BC878.bin.o(.data); }
    .main_802BC880 0x802BC880 : AT(0x0009EB80) { build/asm/data/main_802BC880.bin.o(.data); }
    .main_802C301C 0x802C301C : AT(0x000A531C) { build/asm/data/main_802C301C.bin.o(.data); }
    .main_802C3024 0x802C3024 : AT(0x000A5324) { build/asm/data/main_802C3024.bin.o(.data); }
    .assets 0x8061ED00 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /* Decompressed gzip CODE overlay (hd_code_text). Runtime VRAM 0x802447C0 (boot loader hard-codes it);
       LMA = the working-ROM append offset 0x800000 (past pristine ROM end), so N64Recomp's context.rom gets
       the real instruction bytes and byte-exact verify (vs baserom_dec.z64) covers it. Overlaps the resident
       placeholder VMA, so it is force-registered at init via load_overlays(0x800000,0x802447C0,0xA4360). */
    .ovl_hdcode 0x802447C0 : AT(0x00800000) { FILL(0x00000000); build/asm/ovl_hdcode/ovl_hdcode.s.o(.text); build/asm/ovl_hdcode/ovl_hdcode.s.o(.rodata); build/asm/ovl_hdcode/ovl_hdcode.s.o(.data); }
    .ovl_hdcode_bss (NOLOAD) : { build/asm/ovl_hdcode/ovl_hdcode.s.o(.bss); }
    /DISCARD/ : { *(*); }
}
