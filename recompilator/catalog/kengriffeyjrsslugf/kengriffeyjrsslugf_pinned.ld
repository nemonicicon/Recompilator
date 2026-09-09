SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80061600 0x80061600 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80061600.s.o(.text); build/asm/main_80061600.s.o(.rodata); build/asm/main_80061600.s.o(.data); }
    .main_80061600_bss (NOLOAD) : { build/asm/main_80061600.s.o(.bss); }
    .main_80061890 0x80061890 : AT(0x00001290) { FILL(0x00000000); build/asm/main_80061890.s.o(.text); build/asm/main_80061890.s.o(.rodata); build/asm/main_80061890.s.o(.data); }
    .main_80061890_bss (NOLOAD) : { build/asm/main_80061890.s.o(.bss); }
    .main_80062954 0x80062954 : AT(0x00002354) { FILL(0x00000000); build/asm/main_80062954.s.o(.text); build/asm/main_80062954.s.o(.rodata); build/asm/main_80062954.s.o(.data); }
    .main_80062954_bss (NOLOAD) : { build/asm/main_80062954.s.o(.bss); }
    .main_80062D20 0x80062D20 : AT(0x00002720) { FILL(0x00000000); build/asm/main_80062D20.s.o(.text); build/asm/main_80062D20.s.o(.rodata); build/asm/main_80062D20.s.o(.data); }
    .main_80062D20_bss (NOLOAD) : { build/asm/main_80062D20.s.o(.bss); }
    .main_80067BB8 0x80067BB8 : AT(0x000075B8) { FILL(0x00000000); build/asm/main_80067BB8.s.o(.text); build/asm/main_80067BB8.s.o(.rodata); build/asm/main_80067BB8.s.o(.data); }
    .main_80067BB8_bss (NOLOAD) : { build/asm/main_80067BB8.s.o(.bss); }
    .main_80067F30 0x80067F30 : AT(0x00007930) { build/asm/data/main_80067F30.bin.o(.data); }
    .main_80068C38 0x80068C38 : AT(0x00008638) { build/asm/data/main_80068C38.bin.o(.data); }
    .main_8006962C 0x8006962C : AT(0x0000902C) { build/asm/data/main_8006962C.bin.o(.data); }
    .main_800699A8 0x800699A8 : AT(0x000093A8) { build/asm/data/main_800699A8.bin.o(.data); }
    .main_8006A97C 0x8006A97C : AT(0x0000A37C) { build/asm/data/main_8006A97C.bin.o(.data); }
    .main_8006C180 0x8006C180 : AT(0x0000BB80) { build/asm/data/main_8006C180.bin.o(.data); }
    .main_8006C1B4 0x8006C1B4 : AT(0x0000BBB4) { build/asm/data/main_8006C1B4.bin.o(.data); }
    .main_80070598 0x80070598 : AT(0x0000FF98) { build/asm/data/main_80070598.bin.o(.data); }
    .main_800705BC 0x800705BC : AT(0x0000FFBC) { build/asm/data/main_800705BC.bin.o(.data); }
    .main_800739E0 0x800739E0 : AT(0x000133E0) { build/asm/data/main_800739E0.bin.o(.data); }
    .main_80073A28 0x80073A28 : AT(0x00013428) { build/asm/data/main_80073A28.bin.o(.data); }
    .main_80074818 0x80074818 : AT(0x00014218) { build/asm/data/main_80074818.bin.o(.data); }
    .main_80074838 0x80074838 : AT(0x00014238) { build/asm/data/main_80074838.bin.o(.data); }
    .main_80075F38 0x80075F38 : AT(0x00015938) { build/asm/data/main_80075F38.bin.o(.data); }
    .main_8007603C 0x8007603C : AT(0x00015A3C) { build/asm/data/main_8007603C.bin.o(.data); }
    .main_80076874 0x80076874 : AT(0x00016274) { build/asm/data/main_80076874.bin.o(.data); }
    .main_800769B4 0x800769B4 : AT(0x000163B4) { build/asm/data/main_800769B4.bin.o(.data); }
    .main_8007A438 0x8007A438 : AT(0x00019E38) { build/asm/data/main_8007A438.bin.o(.data); }
    .main_8007A448 0x8007A448 : AT(0x00019E48) { build/asm/data/main_8007A448.bin.o(.data); }
    .main_8008C9F8 0x8008C9F8 : AT(0x0002C3F8) { build/asm/data/main_8008C9F8.bin.o(.data); }
    .main_8008CA20 0x8008CA20 : AT(0x0002C420) { build/asm/data/main_8008CA20.bin.o(.data); }
    .main_8009E008 0x8009E008 : AT(0x0003DA08) { build/asm/data/main_8009E008.bin.o(.data); }
    .main_8009E038 0x8009E038 : AT(0x0003DA38) { build/asm/data/main_8009E038.bin.o(.data); }
    .main_800A318C 0x800A318C : AT(0x00042B8C) { build/asm/data/main_800A318C.bin.o(.data); }
    .main_800A319C 0x800A319C : AT(0x00042B9C) { build/asm/data/main_800A319C.bin.o(.data); }
    .main_800B82DC 0x800B82DC : AT(0x00057CDC) { build/asm/data/main_800B82DC.bin.o(.data); }
    .main_800B82FC 0x800B82FC : AT(0x00057CFC) { build/asm/data/main_800B82FC.bin.o(.data); }
    .main_800BF490 0x800BF490 : AT(0x0005EE90) { build/asm/data/main_800BF490.bin.o(.data); }
    .main_800BF49C 0x800BF49C : AT(0x0005EE9C) { build/asm/data/main_800BF49C.bin.o(.data); }
    .main_800C2454 0x800C2454 : AT(0x00061E54) { build/asm/data/main_800C2454.bin.o(.data); }
    .main_800C2460 0x800C2460 : AT(0x00061E60) { build/asm/data/main_800C2460.bin.o(.data); }
    .main_800CE2B0 0x800CE2B0 : AT(0x0006DCB0) { build/asm/data/main_800CE2B0.bin.o(.data); }
    .main_800CE2E0 0x800CE2E0 : AT(0x0006DCE0) { build/asm/data/main_800CE2E0.bin.o(.data); }
    .main_800D5D88 0x800D5D88 : AT(0x00075788) { build/asm/data/main_800D5D88.bin.o(.data); }
    .main_800D5DAC 0x800D5DAC : AT(0x000757AC) { build/asm/data/main_800D5DAC.bin.o(.data); }
    .main_800DAF18 0x800DAF18 : AT(0x0007A918) { build/asm/data/main_800DAF18.bin.o(.data); }
    .main_800DB02C 0x800DB02C : AT(0x0007AA2C) { build/asm/data/main_800DB02C.bin.o(.data); }
    .main_800EF044 0x800EF044 : AT(0x0008EA44) { build/asm/data/main_800EF044.bin.o(.data); }
    .main_800EF158 0x800EF158 : AT(0x0008EB58) { build/asm/data/main_800EF158.bin.o(.data); }
    .main_800FB4F4 0x800FB4F4 : AT(0x0009AEF4) { build/asm/data/main_800FB4F4.bin.o(.data); }
    .main_800FB50C 0x800FB50C : AT(0x0009AF0C) { build/asm/data/main_800FB50C.bin.o(.data); }
    .main_80101480 0x80101480 : AT(0x000A0E80) { build/asm/data/main_80101480.bin.o(.data); }
    .main_8010157C 0x8010157C : AT(0x000A0F7C) { build/asm/data/main_8010157C.bin.o(.data); }
    .main_801017AC 0x801017AC : AT(0x000A11AC) { build/asm/data/main_801017AC.bin.o(.data); }
    .main_801019D0 0x801019D0 : AT(0x000A13D0) { build/asm/data/main_801019D0.bin.o(.data); }
    .main_8010C088 0x8010C088 : AT(0x000ABA88) { build/asm/data/main_8010C088.bin.o(.data); }
    .main_8010C0B8 0x8010C0B8 : AT(0x000ABAB8) { build/asm/data/main_8010C0B8.bin.o(.data); }
    .main_8011177C 0x8011177C : AT(0x000B117C) { build/asm/data/main_8011177C.bin.o(.data); }
    .main_80111788 0x80111788 : AT(0x000B1188) { build/asm/data/main_80111788.bin.o(.data); }
    .main_80111FEC 0x80111FEC : AT(0x000B19EC) { build/asm/data/main_80111FEC.bin.o(.data); }
    .main_80111FFC 0x80111FFC : AT(0x000B19FC) { build/asm/data/main_80111FFC.bin.o(.data); }
    .main_801129F0 0x801129F0 : AT(0x000B23F0) { build/asm/data/main_801129F0.bin.o(.data); }
    .main_801129F4 0x801129F4 : AT(0x000B23F4) { build/asm/data/main_801129F4.bin.o(.data); }
    .main_80117718 0x80117718 : AT(0x000B7118) { build/asm/data/main_80117718.bin.o(.data); }
    .main_80117740 0x80117740 : AT(0x000B7140) { build/asm/data/main_80117740.bin.o(.data); }
    .main_801207D4 0x801207D4 : AT(0x000C01D4) { build/asm/data/main_801207D4.bin.o(.data); }
    .main_801207F8 0x801207F8 : AT(0x000C01F8) { build/asm/data/main_801207F8.bin.o(.data); }
    .main_80120BE4 0x80120BE4 : AT(0x000C05E4) { build/asm/data/main_80120BE4.bin.o(.data); }
    .main_80120C00 0x80120C00 : AT(0x000C0600) { build/asm/data/main_80120C00.bin.o(.data); }
    .main_801246B8 0x801246B8 : AT(0x000C40B8) { build/asm/data/main_801246B8.bin.o(.data); }
    .main_801247C4 0x801247C4 : AT(0x000C41C4) { build/asm/data/main_801247C4.bin.o(.data); }
    .main_801280B0 0x801280B0 : AT(0x000C7AB0) { build/asm/data/main_801280B0.bin.o(.data); }
    .main_80128198 0x80128198 : AT(0x000C7B98) { build/asm/data/main_80128198.bin.o(.data); }
    .main_801293E0 0x801293E0 : AT(0x000C8DE0) { build/asm/data/main_801293E0.bin.o(.data); }
    .main_801293F4 0x801293F4 : AT(0x000C8DF4) { build/asm/data/main_801293F4.bin.o(.data); }
    .main_8012AFC0 0x8012AFC0 : AT(0x000CA9C0) { build/asm/data/main_8012AFC0.bin.o(.data); }
    .main_8012AFC4 0x8012AFC4 : AT(0x000CA9C4) { build/asm/data/main_8012AFC4.bin.o(.data); }
    .main_8013A67C 0x8013A67C : AT(0x000DA07C) { build/asm/data/main_8013A67C.bin.o(.data); }
    .main_8013A700 0x8013A700 : AT(0x000DA100) { build/asm/data/main_8013A700.bin.o(.data); }
    .main_8013C048 0x8013C048 : AT(0x000DBA48) { build/asm/data/main_8013C048.bin.o(.data); }
    .main_8013C04C 0x8013C04C : AT(0x000DBA4C) { build/asm/data/main_8013C04C.bin.o(.data); }
    .main_8013EB04 0x8013EB04 : AT(0x000DE504) { build/asm/data/main_8013EB04.bin.o(.data); }
    .main_8013EB1C 0x8013EB1C : AT(0x000DE51C) { build/asm/data/main_8013EB1C.bin.o(.data); }
    .main_801583B0 0x801583B0 : AT(0x000F7DB0) { build/asm/data/main_801583B0.bin.o(.data); }
    .main_801583E4 0x801583E4 : AT(0x000F7DE4) { build/asm/data/main_801583E4.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
