SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80046800 0x80046800 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80046800.s.o(.text); build/asm/main_80046800.s.o(.rodata); build/asm/main_80046800.s.o(.data); }
    .main_80046800_bss (NOLOAD) : { build/asm/main_80046800.s.o(.bss); }
    .main_800C5720 0x800C5720 : AT(0x0007FF20) { FILL(0x00000000); build/asm/main_800C5720.s.o(.text); build/asm/main_800C5720.s.o(.rodata); build/asm/main_800C5720.s.o(.data); }
    .main_800C5720_bss (NOLOAD) : { build/asm/main_800C5720.s.o(.bss); }
    .main_800C57A0 0x800C57A0 : AT(0x0007FFA0) { FILL(0x00000000); build/asm/main_800C57A0.s.o(.text); build/asm/main_800C57A0.s.o(.rodata); build/asm/main_800C57A0.s.o(.data); }
    .main_800C57A0_bss (NOLOAD) : { build/asm/main_800C57A0.s.o(.bss); }
    .main_800C5B40 0x800C5B40 : AT(0x00080340) { FILL(0x00000000); build/asm/main_800C5B40.s.o(.text); build/asm/main_800C5B40.s.o(.rodata); build/asm/main_800C5B40.s.o(.data); }
    .main_800C5B40_bss (NOLOAD) : { build/asm/main_800C5B40.s.o(.bss); }
    .main_800C5BC0 0x800C5BC0 : AT(0x000803C0) { FILL(0x00000000); build/asm/main_800C5BC0.s.o(.text); build/asm/main_800C5BC0.s.o(.rodata); build/asm/main_800C5BC0.s.o(.data); }
    .main_800C5BC0_bss (NOLOAD) : { build/asm/main_800C5BC0.s.o(.bss); }
    .main_800C6060 0x800C6060 : AT(0x00080860) { FILL(0x00000000); build/asm/main_800C6060.s.o(.text); build/asm/main_800C6060.s.o(.rodata); build/asm/main_800C6060.s.o(.data); }
    .main_800C6060_bss (NOLOAD) : { build/asm/main_800C6060.s.o(.bss); }
    .main_800C6654 0x800C6654 : AT(0x00080E54) { FILL(0x00000000); build/asm/main_800C6654.s.o(.text); build/asm/main_800C6654.s.o(.rodata); build/asm/main_800C6654.s.o(.data); }
    .main_800C6654_bss (NOLOAD) : { build/asm/main_800C6654.s.o(.bss); }
    .main_800C68E0 0x800C68E0 : AT(0x000810E0) { FILL(0x00000000); build/asm/main_800C68E0.s.o(.text); build/asm/main_800C68E0.s.o(.rodata); build/asm/main_800C68E0.s.o(.data); }
    .main_800C68E0_bss (NOLOAD) : { build/asm/main_800C68E0.s.o(.bss); }
    .main_800C6D70 0x800C6D70 : AT(0x00081570) { FILL(0x00000000); build/asm/main_800C6D70.s.o(.text); build/asm/main_800C6D70.s.o(.rodata); build/asm/main_800C6D70.s.o(.data); }
    .main_800C6D70_bss (NOLOAD) : { build/asm/main_800C6D70.s.o(.bss); }
    .main_800CA260 0x800CA260 : AT(0x00084A60) { FILL(0x00000000); build/asm/main_800CA260.s.o(.text); build/asm/main_800CA260.s.o(.rodata); build/asm/main_800CA260.s.o(.data); }
    .main_800CA260_bss (NOLOAD) : { build/asm/main_800CA260.s.o(.bss); }
    .main_800CA4A0 0x800CA4A0 : AT(0x00084CA0) { FILL(0x00000000); build/asm/main_800CA4A0.s.o(.text); build/asm/main_800CA4A0.s.o(.rodata); build/asm/main_800CA4A0.s.o(.data); }
    .main_800CA4A0_bss (NOLOAD) : { build/asm/main_800CA4A0.s.o(.bss); }
    .main_800CA7B0 0x800CA7B0 : AT(0x00084FB0) { FILL(0x00000000); build/asm/main_800CA7B0.s.o(.text); build/asm/main_800CA7B0.s.o(.rodata); build/asm/main_800CA7B0.s.o(.data); }
    .main_800CA7B0_bss (NOLOAD) : { build/asm/main_800CA7B0.s.o(.bss); }
    .main_800CA8B0 0x800CA8B0 : AT(0x000850B0) { FILL(0x00000000); build/asm/main_800CA8B0.s.o(.text); build/asm/main_800CA8B0.s.o(.rodata); build/asm/main_800CA8B0.s.o(.data); }
    .main_800CA8B0_bss (NOLOAD) : { build/asm/main_800CA8B0.s.o(.bss); }
    .main_800CAE48 0x800CAE48 : AT(0x00085648) { FILL(0x00000000); build/asm/main_800CAE48.s.o(.text); build/asm/main_800CAE48.s.o(.rodata); build/asm/main_800CAE48.s.o(.data); }
    .main_800CAE48_bss (NOLOAD) : { build/asm/main_800CAE48.s.o(.bss); }
    .main_800CB170 0x800CB170 : AT(0x00085970) { FILL(0x00000000); build/asm/main_800CB170.s.o(.text); build/asm/main_800CB170.s.o(.rodata); build/asm/main_800CB170.s.o(.data); }
    .main_800CB170_bss (NOLOAD) : { build/asm/main_800CB170.s.o(.bss); }
    .main_800CBBD0 0x800CBBD0 : AT(0x000863D0) { FILL(0x00000000); build/asm/main_800CBBD0.s.o(.text); build/asm/main_800CBBD0.s.o(.rodata); build/asm/main_800CBBD0.s.o(.data); }
    .main_800CBBD0_bss (NOLOAD) : { build/asm/main_800CBBD0.s.o(.bss); }
    .main_800CBCC0 0x800CBCC0 : AT(0x000864C0) { FILL(0x00000000); build/asm/main_800CBCC0.s.o(.text); build/asm/main_800CBCC0.s.o(.rodata); build/asm/main_800CBCC0.s.o(.data); }
    .main_800CBCC0_bss (NOLOAD) : { build/asm/main_800CBCC0.s.o(.bss); }
    .main_800CC380 0x800CC380 : AT(0x00086B80) { FILL(0x00000000); build/asm/main_800CC380.s.o(.text); build/asm/main_800CC380.s.o(.rodata); build/asm/main_800CC380.s.o(.data); }
    .main_800CC380_bss (NOLOAD) : { build/asm/main_800CC380.s.o(.bss); }
    .main_800CC584 0x800CC584 : AT(0x00086D84) { FILL(0x00000000); build/asm/main_800CC584.s.o(.text); build/asm/main_800CC584.s.o(.rodata); build/asm/main_800CC584.s.o(.data); }
    .main_800CC584_bss (NOLOAD) : { build/asm/main_800CC584.s.o(.bss); }
    .main_800CC678 0x800CC678 : AT(0x00086E78) { FILL(0x00000000); build/asm/main_800CC678.s.o(.text); build/asm/main_800CC678.s.o(.rodata); build/asm/main_800CC678.s.o(.data); }
    .main_800CC678_bss (NOLOAD) : { build/asm/main_800CC678.s.o(.bss); }
    .main_800CC880 0x800CC880 : AT(0x00087080) { FILL(0x00000000); build/asm/main_800CC880.s.o(.text); build/asm/main_800CC880.s.o(.rodata); build/asm/main_800CC880.s.o(.data); }
    .main_800CC880_bss (NOLOAD) : { build/asm/main_800CC880.s.o(.bss); }
    .main_800D0430 0x800D0430 : AT(0x0008AC30) { FILL(0x00000000); build/asm/main_800D0430.s.o(.text); build/asm/main_800D0430.s.o(.rodata); build/asm/main_800D0430.s.o(.data); }
    .main_800D0430_bss (NOLOAD) : { build/asm/main_800D0430.s.o(.bss); }
    .main_800D0BA0 0x800D0BA0 : AT(0x0008B3A0) { FILL(0x00000000); build/asm/main_800D0BA0.s.o(.text); build/asm/main_800D0BA0.s.o(.rodata); build/asm/main_800D0BA0.s.o(.data); }
    .main_800D0BA0_bss (NOLOAD) : { build/asm/main_800D0BA0.s.o(.bss); }
    .main_800D7244 0x800D7244 : AT(0x00091A44) { FILL(0x00000000); build/asm/main_800D7244.s.o(.text); build/asm/main_800D7244.s.o(.rodata); build/asm/main_800D7244.s.o(.data); }
    .main_800D7244_bss (NOLOAD) : { build/asm/main_800D7244.s.o(.bss); }
    .main_800E5638 0x800E5638 : AT(0x0009FE38) { build/asm/data/main_800E5638.bin.o(.data); }
    .main_800E5858 0x800E5858 : AT(0x000A0058) { build/asm/data/main_800E5858.bin.o(.data); }
    .main_800E5B50 0x800E5B50 : AT(0x000A0350) { build/asm/data/main_800E5B50.bin.o(.data); }
    .main_800E5C34 0x800E5C34 : AT(0x000A0434) { build/asm/data/main_800E5C34.bin.o(.data); }
    .main_800E5CF0 0x800E5CF0 : AT(0x000A04F0) { build/asm/data/main_800E5CF0.bin.o(.data); }
    .main_800E5E08 0x800E5E08 : AT(0x000A0608) { FILL(0x00000000); build/asm/main_800E5E08.s.o(.text); build/asm/main_800E5E08.s.o(.rodata); build/asm/main_800E5E08.s.o(.data); }
    .main_800E5E08_bss (NOLOAD) : { build/asm/main_800E5E08.s.o(.bss); }
    .main_800EE8B0 0x800EE8B0 : AT(0x000A90B0) { build/asm/data/main_800EE8B0.bin.o(.data); }
    .main_800EF300 0x800EF300 : AT(0x000A9B00) { FILL(0x00000000); build/asm/main_800EF300.s.o(.text); build/asm/main_800EF300.s.o(.rodata); build/asm/main_800EF300.s.o(.data); }
    .main_800EF300_bss (NOLOAD) : { build/asm/main_800EF300.s.o(.bss); }
    .main_800FC5B8 0x800FC5B8 : AT(0x000B6DB8) { FILL(0x00000000); build/asm/main_800FC5B8.s.o(.text); build/asm/main_800FC5B8.s.o(.rodata); build/asm/main_800FC5B8.s.o(.data); }
    .main_800FC5B8_bss (NOLOAD) : { build/asm/main_800FC5B8.s.o(.bss); }
    .main_801074A8 0x801074A8 : AT(0x000C1CA8) { build/asm/data/main_801074A8.bin.o(.data); }
    .main_80115BC4 0x80115BC4 : AT(0x000D03C4) { FILL(0x00000000); build/asm/main_80115BC4.s.o(.text); build/asm/main_80115BC4.s.o(.rodata); build/asm/main_80115BC4.s.o(.data); }
    .main_80115BC4_bss (NOLOAD) : { build/asm/main_80115BC4.s.o(.bss); }
    .main_80115C44 0x80115C44 : AT(0x000D0444) { build/asm/data/main_80115C44.bin.o(.data); }
    .main_8011A2D8 0x8011A2D8 : AT(0x000D4AD8) { FILL(0x00000000); build/asm/main_8011A2D8.s.o(.text); build/asm/main_8011A2D8.s.o(.rodata); build/asm/main_8011A2D8.s.o(.data); }
    .main_8011A2D8_bss (NOLOAD) : { build/asm/main_8011A2D8.s.o(.bss); }
    .main_8011A2E4 0x8011A2E4 : AT(0x000D4AE4) { build/asm/data/main_8011A2E4.bin.o(.data); }
    .main_8011A3B0 0x8011A3B0 : AT(0x000D4BB0) { FILL(0x00000000); build/asm/main_8011A3B0.s.o(.text); build/asm/main_8011A3B0.s.o(.rodata); build/asm/main_8011A3B0.s.o(.data); }
    .main_8011A3B0_bss (NOLOAD) : { build/asm/main_8011A3B0.s.o(.bss); }
    .main_8011A3BC 0x8011A3BC : AT(0x000D4BBC) { build/asm/data/main_8011A3BC.bin.o(.data); }
    .main_8011A480 0x8011A480 : AT(0x000D4C80) { FILL(0x00000000); build/asm/main_8011A480.s.o(.text); build/asm/main_8011A480.s.o(.rodata); build/asm/main_8011A480.s.o(.data); }
    .main_8011A480_bss (NOLOAD) : { build/asm/main_8011A480.s.o(.bss); }
    .main_8011A48C 0x8011A48C : AT(0x000D4C8C) { build/asm/data/main_8011A48C.bin.o(.data); }
    .main_8011A56C 0x8011A56C : AT(0x000D4D6C) { FILL(0x00000000); build/asm/main_8011A56C.s.o(.text); build/asm/main_8011A56C.s.o(.rodata); build/asm/main_8011A56C.s.o(.data); }
    .main_8011A56C_bss (NOLOAD) : { build/asm/main_8011A56C.s.o(.bss); }
    .main_8011A648 0x8011A648 : AT(0x000D4E48) { build/asm/data/main_8011A648.bin.o(.data); }
    .main_8011A72C 0x8011A72C : AT(0x000D4F2C) { FILL(0x00000000); build/asm/main_8011A72C.s.o(.text); build/asm/main_8011A72C.s.o(.rodata); build/asm/main_8011A72C.s.o(.data); }
    .main_8011A72C_bss (NOLOAD) : { build/asm/main_8011A72C.s.o(.bss); }
    .main_8011A9D8 0x8011A9D8 : AT(0x000D51D8) { build/asm/data/main_8011A9D8.bin.o(.data); }
    .main_801262C0 0x801262C0 : AT(0x000E0AC0) { build/asm/data/main_801262C0.bin.o(.data); }
    .main_80128B8C 0x80128B8C : AT(0x000E338C) { FILL(0x00000000); build/asm/main_80128B8C.s.o(.text); build/asm/main_80128B8C.s.o(.rodata); build/asm/main_80128B8C.s.o(.data); }
    .main_80128B8C_bss (NOLOAD) : { build/asm/main_80128B8C.s.o(.bss); }
    .main_80128DB4 0x80128DB4 : AT(0x000E35B4) { build/asm/data/main_80128DB4.bin.o(.data); }
    .main_80129390 0x80129390 : AT(0x000E3B90) { FILL(0x00000000); build/asm/main_80129390.s.o(.text); build/asm/main_80129390.s.o(.rodata); build/asm/main_80129390.s.o(.data); }
    .main_80129390_bss (NOLOAD) : { build/asm/main_80129390.s.o(.bss); }
    .main_8012939C 0x8012939C : AT(0x000E3B9C) { build/asm/data/main_8012939C.bin.o(.data); }
    .main_80129450 0x80129450 : AT(0x000E3C50) { FILL(0x00000000); build/asm/main_80129450.s.o(.text); build/asm/main_80129450.s.o(.rodata); build/asm/main_80129450.s.o(.data); }
    .main_80129450_bss (NOLOAD) : { build/asm/main_80129450.s.o(.bss); }
    .main_80129518 0x80129518 : AT(0x000E3D18) { build/asm/data/main_80129518.bin.o(.data); }
    .main_801295CC 0x801295CC : AT(0x000E3DCC) { FILL(0x00000000); build/asm/main_801295CC.s.o(.text); build/asm/main_801295CC.s.o(.rodata); build/asm/main_801295CC.s.o(.data); }
    .main_801295CC_bss (NOLOAD) : { build/asm/main_801295CC.s.o(.bss); }
    .main_80129B14 0x80129B14 : AT(0x000E4314) { build/asm/data/main_80129B14.bin.o(.data); }
    .main_80129C14 0x80129C14 : AT(0x000E4414) { FILL(0x00000000); build/asm/main_80129C14.s.o(.text); build/asm/main_80129C14.s.o(.rodata); build/asm/main_80129C14.s.o(.data); }
    .main_80129C14_bss (NOLOAD) : { build/asm/main_80129C14.s.o(.bss); }
    .main_80129C20 0x80129C20 : AT(0x000E4420) { build/asm/data/main_80129C20.bin.o(.data); }
    .main_8012BBC8 0x8012BBC8 : AT(0x000E63C8) { FILL(0x00000000); build/asm/main_8012BBC8.s.o(.text); build/asm/main_8012BBC8.s.o(.rodata); build/asm/main_8012BBC8.s.o(.data); }
    .main_8012BBC8_bss (NOLOAD) : { build/asm/main_8012BBC8.s.o(.bss); }
    .main_8012C3C8 0x8012C3C8 : AT(0x000E6BC8) { build/asm/data/main_8012C3C8.bin.o(.data); }
    .main_8012CD54 0x8012CD54 : AT(0x000E7554) { FILL(0x00000000); build/asm/main_8012CD54.s.o(.text); build/asm/main_8012CD54.s.o(.rodata); build/asm/main_8012CD54.s.o(.data); }
    .main_8012CD54_bss (NOLOAD) : { build/asm/main_8012CD54.s.o(.bss); }
    .main_8012CD70 0x8012CD70 : AT(0x000E7570) { build/asm/data/main_8012CD70.bin.o(.data); }
    .main_8012DC48 0x8012DC48 : AT(0x000E8448) { FILL(0x00000000); build/asm/main_8012DC48.s.o(.text); build/asm/main_8012DC48.s.o(.rodata); build/asm/main_8012DC48.s.o(.data); }
    .main_8012DC48_bss (NOLOAD) : { build/asm/main_8012DC48.s.o(.bss); }
    .main_8012DC60 0x8012DC60 : AT(0x000E8460) { build/asm/data/main_8012DC60.bin.o(.data); }
    .main_80130918 0x80130918 : AT(0x000EB118) { FILL(0x00000000); build/asm/main_80130918.s.o(.text); build/asm/main_80130918.s.o(.rodata); build/asm/main_80130918.s.o(.data); }
    .main_80130918_bss (NOLOAD) : { build/asm/main_80130918.s.o(.bss); }
    .main_80130924 0x80130924 : AT(0x000EB124) { build/asm/data/main_80130924.bin.o(.data); }
    .main_801309F0 0x801309F0 : AT(0x000EB1F0) { FILL(0x00000000); build/asm/main_801309F0.s.o(.text); build/asm/main_801309F0.s.o(.rodata); build/asm/main_801309F0.s.o(.data); }
    .main_801309F0_bss (NOLOAD) : { build/asm/main_801309F0.s.o(.bss); }
    .main_801309FC 0x801309FC : AT(0x000EB1FC) { build/asm/data/main_801309FC.bin.o(.data); }
    .main_80130AB8 0x80130AB8 : AT(0x000EB2B8) { FILL(0x00000000); build/asm/main_80130AB8.s.o(.text); build/asm/main_80130AB8.s.o(.rodata); build/asm/main_80130AB8.s.o(.data); }
    .main_80130AB8_bss (NOLOAD) : { build/asm/main_80130AB8.s.o(.bss); }
    .main_80130AC4 0x80130AC4 : AT(0x000EB2C4) { build/asm/data/main_80130AC4.bin.o(.data); }
    .main_80130B74 0x80130B74 : AT(0x000EB374) { FILL(0x00000000); build/asm/main_80130B74.s.o(.text); build/asm/main_80130B74.s.o(.rodata); build/asm/main_80130B74.s.o(.data); }
    .main_80130B74_bss (NOLOAD) : { build/asm/main_80130B74.s.o(.bss); }
    .main_80130B98 0x80130B98 : AT(0x000EB398) { build/asm/data/main_80130B98.bin.o(.data); }
    .main_80130BC0 0x80130BC0 : AT(0x000EB3C0) { FILL(0x00000000); build/asm/main_80130BC0.s.o(.text); build/asm/main_80130BC0.s.o(.rodata); build/asm/main_80130BC0.s.o(.data); }
    .main_80130BC0_bss (NOLOAD) : { build/asm/main_80130BC0.s.o(.bss); }
    .main_80130BC4 0x80130BC4 : AT(0x000EB3C4) { build/asm/data/main_80130BC4.bin.o(.data); }
    .main_80130C5C 0x80130C5C : AT(0x000EB45C) { FILL(0x00000000); build/asm/main_80130C5C.s.o(.text); build/asm/main_80130C5C.s.o(.rodata); build/asm/main_80130C5C.s.o(.data); }
    .main_80130C5C_bss (NOLOAD) : { build/asm/main_80130C5C.s.o(.bss); }
    .main_80130C68 0x80130C68 : AT(0x000EB468) { build/asm/data/main_80130C68.bin.o(.data); }
    .main_80130D54 0x80130D54 : AT(0x000EB554) { FILL(0x00000000); build/asm/main_80130D54.s.o(.text); build/asm/main_80130D54.s.o(.rodata); build/asm/main_80130D54.s.o(.data); }
    .main_80130D54_bss (NOLOAD) : { build/asm/main_80130D54.s.o(.bss); }
    .main_80130D60 0x80130D60 : AT(0x000EB560) { build/asm/data/main_80130D60.bin.o(.data); }
    .main_80138438 0x80138438 : AT(0x000F2C38) { build/asm/data/main_80138438.bin.o(.data); }
    .main_8013845C 0x8013845C : AT(0x000F2C5C) { FILL(0x00000000); build/asm/main_8013845C.s.o(.text); build/asm/main_8013845C.s.o(.rodata); build/asm/main_8013845C.s.o(.data); }
    .main_8013845C_bss (NOLOAD) : { build/asm/main_8013845C.s.o(.bss); }
    .assets 0x80446800 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
