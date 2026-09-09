SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_8004B400 0x8004B400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_8004B400.s.o(.text); build/asm/main_8004B400.s.o(.rodata); build/asm/main_8004B400.s.o(.data); }
    .main_8004B400_bss (NOLOAD) : { build/asm/main_8004B400.s.o(.bss); }
    .main_8004B4B4 0x8004B4B4 : AT(0x000010B4) { FILL(0x00000000); build/asm/main_8004B4B4.s.o(.text); build/asm/main_8004B4B4.s.o(.rodata); build/asm/main_8004B4B4.s.o(.data); }
    .main_8004B4B4_bss (NOLOAD) : { build/asm/main_8004B4B4.s.o(.bss); }
    .main_800C4564 0x800C4564 : AT(0x0007A164) { FILL(0x00000000); build/asm/main_800C4564.s.o(.text); build/asm/main_800C4564.s.o(.rodata); build/asm/main_800C4564.s.o(.data); }
    .main_800C4564_bss (NOLOAD) : { build/asm/main_800C4564.s.o(.bss); }
    .main_800C4930 0x800C4930 : AT(0x0007A530) { FILL(0x00000000); build/asm/main_800C4930.s.o(.text); build/asm/main_800C4930.s.o(.rodata); build/asm/main_800C4930.s.o(.data); }
    .main_800C4930_bss (NOLOAD) : { build/asm/main_800C4930.s.o(.bss); }
    .main_800DBC9C 0x800DBC9C : AT(0x0009189C) { FILL(0x00000000); build/asm/main_800DBC9C.s.o(.text); build/asm/main_800DBC9C.s.o(.rodata); build/asm/main_800DBC9C.s.o(.data); }
    .main_800DBC9C_bss (NOLOAD) : { build/asm/main_800DBC9C.s.o(.bss); }
    .main_800DD97C 0x800DD97C : AT(0x0009357C) { build/asm/data/main_800DD97C.bin.o(.data); }
    .main_800DDCE0 0x800DDCE0 : AT(0x000938E0) { FILL(0x00000000); build/asm/main_800DDCE0.s.o(.text); build/asm/main_800DDCE0.s.o(.rodata); build/asm/main_800DDCE0.s.o(.data); }
    .main_800DDCE0_bss (NOLOAD) : { build/asm/main_800DDCE0.s.o(.bss); }
    .main_800DE4C0 0x800DE4C0 : AT(0x000940C0) { build/asm/data/main_800DE4C0.bin.o(.data); }
    .main_800DF0AC 0x800DF0AC : AT(0x00094CAC) { FILL(0x00000000); build/asm/main_800DF0AC.s.o(.text); build/asm/main_800DF0AC.s.o(.rodata); build/asm/main_800DF0AC.s.o(.data); }
    .main_800DF0AC_bss (NOLOAD) : { build/asm/main_800DF0AC.s.o(.bss); }
    .main_800DF42C 0x800DF42C : AT(0x0009502C) { build/asm/data/main_800DF42C.bin.o(.data); }
    .main_800DF694 0x800DF694 : AT(0x00095294) { FILL(0x00000000); build/asm/main_800DF694.s.o(.text); build/asm/main_800DF694.s.o(.rodata); build/asm/main_800DF694.s.o(.data); }
    .main_800DF694_bss (NOLOAD) : { build/asm/main_800DF694.s.o(.bss); }
    .main_800DFE64 0x800DFE64 : AT(0x00095A64) { build/asm/data/main_800DFE64.bin.o(.data); }
    .main_800E04B0 0x800E04B0 : AT(0x000960B0) { FILL(0x00000000); build/asm/main_800E04B0.s.o(.text); build/asm/main_800E04B0.s.o(.rodata); build/asm/main_800E04B0.s.o(.data); }
    .main_800E04B0_bss (NOLOAD) : { build/asm/main_800E04B0.s.o(.bss); }
    .main_800E04BC 0x800E04BC : AT(0x000960BC) { build/asm/data/main_800E04BC.bin.o(.data); }
    .main_800E0510 0x800E0510 : AT(0x00096110) { FILL(0x00000000); build/asm/main_800E0510.s.o(.text); build/asm/main_800E0510.s.o(.rodata); build/asm/main_800E0510.s.o(.data); }
    .main_800E0510_bss (NOLOAD) : { build/asm/main_800E0510.s.o(.bss); }
    .main_800E1630 0x800E1630 : AT(0x00097230) { build/asm/data/main_800E1630.bin.o(.data); }
    .main_800E18D4 0x800E18D4 : AT(0x000974D4) { FILL(0x00000000); build/asm/main_800E18D4.s.o(.text); build/asm/main_800E18D4.s.o(.rodata); build/asm/main_800E18D4.s.o(.data); }
    .main_800E18D4_bss (NOLOAD) : { build/asm/main_800E18D4.s.o(.bss); }
    .main_800E2530 0x800E2530 : AT(0x00098130) { build/asm/data/main_800E2530.bin.o(.data); }
    .main_800E26F0 0x800E26F0 : AT(0x000982F0) { FILL(0x00000000); build/asm/main_800E26F0.s.o(.text); build/asm/main_800E26F0.s.o(.rodata); build/asm/main_800E26F0.s.o(.data); }
    .main_800E26F0_bss (NOLOAD) : { build/asm/main_800E26F0.s.o(.bss); }
    .main_800E3D94 0x800E3D94 : AT(0x00099994) { build/asm/data/main_800E3D94.bin.o(.data); }
    .main_800E3FA4 0x800E3FA4 : AT(0x00099BA4) { FILL(0x00000000); build/asm/main_800E3FA4.s.o(.text); build/asm/main_800E3FA4.s.o(.rodata); build/asm/main_800E3FA4.s.o(.data); }
    .main_800E3FA4_bss (NOLOAD) : { build/asm/main_800E3FA4.s.o(.bss); }
    .main_800E499C 0x800E499C : AT(0x0009A59C) { build/asm/data/main_800E499C.bin.o(.data); }
    .main_800E4CE0 0x800E4CE0 : AT(0x0009A8E0) { FILL(0x00000000); build/asm/main_800E4CE0.s.o(.text); build/asm/main_800E4CE0.s.o(.rodata); build/asm/main_800E4CE0.s.o(.data); }
    .main_800E4CE0_bss (NOLOAD) : { build/asm/main_800E4CE0.s.o(.bss); }
    .main_800E4D70 0x800E4D70 : AT(0x0009A970) { build/asm/data/main_800E4D70.bin.o(.data); }
    .main_800E4D98 0x800E4D98 : AT(0x0009A998) { FILL(0x00000000); build/asm/main_800E4D98.s.o(.text); build/asm/main_800E4D98.s.o(.rodata); build/asm/main_800E4D98.s.o(.data); }
    .main_800E4D98_bss (NOLOAD) : { build/asm/main_800E4D98.s.o(.bss); }
    .main_800E4EFC 0x800E4EFC : AT(0x0009AAFC) { build/asm/data/main_800E4EFC.bin.o(.data); }
    .main_800E50B8 0x800E50B8 : AT(0x0009ACB8) { FILL(0x00000000); build/asm/main_800E50B8.s.o(.text); build/asm/main_800E50B8.s.o(.rodata); build/asm/main_800E50B8.s.o(.data); }
    .main_800E50B8_bss (NOLOAD) : { build/asm/main_800E50B8.s.o(.bss); }
    .main_800E50F0 0x800E50F0 : AT(0x0009ACF0) { build/asm/data/main_800E50F0.bin.o(.data); }
    .main_800E5294 0x800E5294 : AT(0x0009AE94) { FILL(0x00000000); build/asm/main_800E5294.s.o(.text); build/asm/main_800E5294.s.o(.rodata); build/asm/main_800E5294.s.o(.data); }
    .main_800E5294_bss (NOLOAD) : { build/asm/main_800E5294.s.o(.bss); }
    .main_800E5348 0x800E5348 : AT(0x0009AF48) { build/asm/data/main_800E5348.bin.o(.data); }
    .main_800E5550 0x800E5550 : AT(0x0009B150) { FILL(0x00000000); build/asm/main_800E5550.s.o(.text); build/asm/main_800E5550.s.o(.rodata); build/asm/main_800E5550.s.o(.data); }
    .main_800E5550_bss (NOLOAD) : { build/asm/main_800E5550.s.o(.bss); }
    .main_800E5908 0x800E5908 : AT(0x0009B508) { build/asm/data/main_800E5908.bin.o(.data); }
    .main_800EC3FC 0x800EC3FC : AT(0x000A1FFC) { FILL(0x00000000); build/asm/main_800EC3FC.s.o(.text); build/asm/main_800EC3FC.s.o(.rodata); build/asm/main_800EC3FC.s.o(.data); }
    .main_800EC3FC_bss (NOLOAD) : { build/asm/main_800EC3FC.s.o(.bss); }
    .main_800ED9A4 0x800ED9A4 : AT(0x000A35A4) { build/asm/data/main_800ED9A4.bin.o(.data); }
    .main_800EE398 0x800EE398 : AT(0x000A3F98) { FILL(0x00000000); build/asm/main_800EE398.s.o(.text); build/asm/main_800EE398.s.o(.rodata); build/asm/main_800EE398.s.o(.data); }
    .main_800EE398_bss (NOLOAD) : { build/asm/main_800EE398.s.o(.bss); }
    .main_800EE3F4 0x800EE3F4 : AT(0x000A3FF4) { build/asm/data/main_800EE3F4.bin.o(.data); }
    .main_800EE538 0x800EE538 : AT(0x000A4138) { FILL(0x00000000); build/asm/main_800EE538.s.o(.text); build/asm/main_800EE538.s.o(.rodata); build/asm/main_800EE538.s.o(.data); }
    .main_800EE538_bss (NOLOAD) : { build/asm/main_800EE538.s.o(.bss); }
    .main_800EE6FC 0x800EE6FC : AT(0x000A42FC) { build/asm/data/main_800EE6FC.bin.o(.data); }
    .main_800EE7DC 0x800EE7DC : AT(0x000A43DC) { FILL(0x00000000); build/asm/main_800EE7DC.s.o(.text); build/asm/main_800EE7DC.s.o(.rodata); build/asm/main_800EE7DC.s.o(.data); }
    .main_800EE7DC_bss (NOLOAD) : { build/asm/main_800EE7DC.s.o(.bss); }
    .main_800EE814 0x800EE814 : AT(0x000A4414) { FILL(0x00000000); build/asm/main_800EE814.s.o(.text); build/asm/main_800EE814.s.o(.rodata); build/asm/main_800EE814.s.o(.data); }
    .main_800EE814_bss (NOLOAD) : { build/asm/main_800EE814.s.o(.bss); }
    .main_800EE8BC 0x800EE8BC : AT(0x000A44BC) { FILL(0x00000000); build/asm/main_800EE8BC.s.o(.text); build/asm/main_800EE8BC.s.o(.rodata); build/asm/main_800EE8BC.s.o(.data); }
    .main_800EE8BC_bss (NOLOAD) : { build/asm/main_800EE8BC.s.o(.bss); }
    .main_800FA238 0x800FA238 : AT(0x000AFE38) { FILL(0x00000000); build/asm/main_800FA238.s.o(.text); build/asm/main_800FA238.s.o(.rodata); build/asm/main_800FA238.s.o(.data); }
    .main_800FA238_bss (NOLOAD) : { build/asm/main_800FA238.s.o(.bss); }
    .main_800FD9C0 0x800FD9C0 : AT(0x000B35C0) { FILL(0x00000000); build/asm/main_800FD9C0.s.o(.text); build/asm/main_800FD9C0.s.o(.rodata); build/asm/main_800FD9C0.s.o(.data); }
    .main_800FD9C0_bss (NOLOAD) : { build/asm/main_800FD9C0.s.o(.bss); }
    .main_800FF1CC 0x800FF1CC : AT(0x000B4DCC) { FILL(0x00000000); build/asm/main_800FF1CC.s.o(.text); build/asm/main_800FF1CC.s.o(.rodata); build/asm/main_800FF1CC.s.o(.data); }
    .main_800FF1CC_bss (NOLOAD) : { build/asm/main_800FF1CC.s.o(.bss); }
    .main_800FF6EC 0x800FF6EC : AT(0x000B52EC) { build/asm/data/main_800FF6EC.bin.o(.data); }
    .main_80100B88 0x80100B88 : AT(0x000B6788) { build/asm/data/main_80100B88.bin.o(.data); }
    .main_80100EB0 0x80100EB0 : AT(0x000B6AB0) { FILL(0x00000000); build/asm/main_80100EB0.s.o(.text); build/asm/main_80100EB0.s.o(.rodata); build/asm/main_80100EB0.s.o(.data); }
    .main_80100EB0_bss (NOLOAD) : { build/asm/main_80100EB0.s.o(.bss); }
    .main_8010153C 0x8010153C : AT(0x000B713C) { build/asm/data/main_8010153C.bin.o(.data); }
    .main_80101B14 0x80101B14 : AT(0x000B7714) { build/asm/data/main_80101B14.bin.o(.data); }
    .main_80101EC8 0x80101EC8 : AT(0x000B7AC8) { FILL(0x00000000); build/asm/main_80101EC8.s.o(.text); build/asm/main_80101EC8.s.o(.rodata); build/asm/main_80101EC8.s.o(.data); }
    .main_80101EC8_bss (NOLOAD) : { build/asm/main_80101EC8.s.o(.bss); }
    .main_80103594 0x80103594 : AT(0x000B9194) { FILL(0x00000000); build/asm/main_80103594.s.o(.text); build/asm/main_80103594.s.o(.rodata); build/asm/main_80103594.s.o(.data); }
    .main_80103594_bss (NOLOAD) : { build/asm/main_80103594.s.o(.bss); }
    .main_801066C0 0x801066C0 : AT(0x000BC2C0) { build/asm/data/main_801066C0.bin.o(.data); }
    .main_80107690 0x80107690 : AT(0x000BD290) { build/asm/data/main_80107690.bin.o(.data); }
    .main_8010AA00 0x8010AA00 : AT(0x000C0600) { build/asm/data/main_8010AA00.bin.o(.data); }
    .main_8010B450 0x8010B450 : AT(0x000C1050) { build/asm/data/main_8010B450.bin.o(.data); }
    .main_8010EE0C 0x8010EE0C : AT(0x000C4A0C) { build/asm/data/main_8010EE0C.bin.o(.data); }
    .main_801130A4 0x801130A4 : AT(0x000C8CA4) { build/asm/data/main_801130A4.bin.o(.data); }
    .main_80118600 0x80118600 : AT(0x000CE200) { build/asm/data/main_80118600.bin.o(.data); }
    .main_8011EB20 0x8011EB20 : AT(0x000D4720) { build/asm/data/main_8011EB20.bin.o(.data); }
    .main_801205AC 0x801205AC : AT(0x000D61AC) { build/asm/data/main_801205AC.bin.o(.data); }
    .main_801235F8 0x801235F8 : AT(0x000D91F8) { FILL(0x00000000); build/asm/main_801235F8.s.o(.text); build/asm/main_801235F8.s.o(.rodata); build/asm/main_801235F8.s.o(.data); }
    .main_801235F8_bss (NOLOAD) : { build/asm/main_801235F8.s.o(.bss); }
    .main_80123FF4 0x80123FF4 : AT(0x000D9BF4) { FILL(0x00000000); build/asm/main_80123FF4.s.o(.text); build/asm/main_80123FF4.s.o(.rodata); build/asm/main_80123FF4.s.o(.data); }
    .main_80123FF4_bss (NOLOAD) : { build/asm/main_80123FF4.s.o(.bss); }
    .main_80124088 0x80124088 : AT(0x000D9C88) { build/asm/data/main_80124088.bin.o(.data); }
    .main_801303E8 0x801303E8 : AT(0x000E5FE8) { FILL(0x00000000); build/asm/main_801303E8.s.o(.text); build/asm/main_801303E8.s.o(.rodata); build/asm/main_801303E8.s.o(.data); }
    .main_801303E8_bss (NOLOAD) : { build/asm/main_801303E8.s.o(.bss); }
    .main_8013044C 0x8013044C : AT(0x000E604C) { build/asm/data/main_8013044C.bin.o(.data); }
    .assets 0x8044B400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
