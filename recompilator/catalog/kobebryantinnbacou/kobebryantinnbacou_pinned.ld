SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000440 0x80000440 : AT(0x00001040) { FILL(0x00000000); build/asm/main_80000440.s.o(.text); build/asm/main_80000440.s.o(.rodata); build/asm/main_80000440.s.o(.data); }
    .main_80000440_bss (NOLOAD) : { build/asm/main_80000440.s.o(.bss); }
    .main_80002138 0x80002138 : AT(0x00002D38) { build/asm/data/main_80002138.bin.o(.data); }
    .main_80003DAC 0x80003DAC : AT(0x000049AC) { build/asm/data/main_80003DAC.bin.o(.data); }
    .main_80003DB8 0x80003DB8 : AT(0x000049B8) { build/asm/data/main_80003DB8.bin.o(.data); }
    .main_80004B74 0x80004B74 : AT(0x00005774) { build/asm/data/main_80004B74.bin.o(.data); }
    .main_800308D0 0x800308D0 : AT(0x000314D0) { build/asm/data/main_800308D0.bin.o(.data); }
    .main_80030938 0x80030938 : AT(0x00031538) { build/asm/data/main_80030938.bin.o(.data); }
    .main_80030A48 0x80030A48 : AT(0x00031648) { build/asm/data/main_80030A48.bin.o(.data); }
    .main_80030A58 0x80030A58 : AT(0x00031658) { build/asm/data/main_80030A58.bin.o(.data); }
    .main_80063E00 0x80063E00 : AT(0x00064A00) { FILL(0x00000000); build/asm/main_80063E00.s.o(.text); build/asm/main_80063E00.s.o(.rodata); build/asm/main_80063E00.s.o(.data); }
    .main_80063E00_bss (NOLOAD) : { build/asm/main_80063E00.s.o(.bss); }
    .main_80065420 0x80065420 : AT(0x00066020) { build/asm/data/main_80065420.bin.o(.data); }
    .main_80068000 0x80068000 : AT(0x00068C00) { FILL(0x00000000); build/asm/main_80068000.s.o(.text); build/asm/main_80068000.s.o(.rodata); build/asm/main_80068000.s.o(.data); }
    .main_80068000_bss (NOLOAD) : { build/asm/main_80068000.s.o(.bss); }
    .main_8007E0B0 0x8007E0B0 : AT(0x0007ECB0) { build/asm/data/main_8007E0B0.bin.o(.data); }
    .main_8007E250 0x8007E250 : AT(0x0007EE50) { FILL(0x00000000); build/asm/main_8007E250.s.o(.text); build/asm/main_8007E250.s.o(.rodata); build/asm/main_8007E250.s.o(.data); }
    .main_8007E250_bss (NOLOAD) : { build/asm/main_8007E250.s.o(.bss); }
    .main_800B3A48 0x800B3A48 : AT(0x000B4648) { build/asm/data/main_800B3A48.bin.o(.data); }
    .main_800B4130 0x800B4130 : AT(0x000B4D30) { FILL(0x00000000); build/asm/main_800B4130.s.o(.text); build/asm/main_800B4130.s.o(.rodata); build/asm/main_800B4130.s.o(.data); }
    .main_800B4130_bss (NOLOAD) : { build/asm/main_800B4130.s.o(.bss); }
    .main_800B468C 0x800B468C : AT(0x000B528C) { build/asm/data/main_800B468C.bin.o(.data); }
    .main_800B4BC4 0x800B4BC4 : AT(0x000B57C4) { FILL(0x00000000); build/asm/main_800B4BC4.s.o(.text); build/asm/main_800B4BC4.s.o(.rodata); build/asm/main_800B4BC4.s.o(.data); }
    .main_800B4BC4_bss (NOLOAD) : { build/asm/main_800B4BC4.s.o(.bss); }
    .main_800B5884 0x800B5884 : AT(0x000B6484) { build/asm/data/main_800B5884.bin.o(.data); }
    .main_800B9A50 0x800B9A50 : AT(0x000BA650) { FILL(0x00000000); build/asm/main_800B9A50.s.o(.text); build/asm/main_800B9A50.s.o(.rodata); build/asm/main_800B9A50.s.o(.data); }
    .main_800B9A50_bss (NOLOAD) : { build/asm/main_800B9A50.s.o(.bss); }
    .main_800BA028 0x800BA028 : AT(0x000BAC28) { build/asm/data/main_800BA028.bin.o(.data); }
    .main_800C41B8 0x800C41B8 : AT(0x000C4DB8) { FILL(0x00000000); build/asm/main_800C41B8.s.o(.text); build/asm/main_800C41B8.s.o(.rodata); build/asm/main_800C41B8.s.o(.data); }
    .main_800C41B8_bss (NOLOAD) : { build/asm/main_800C41B8.s.o(.bss); }
    .main_800C5F64 0x800C5F64 : AT(0x000C6B64) { build/asm/data/main_800C5F64.bin.o(.data); }
    .main_800CF140 0x800CF140 : AT(0x000CFD40) { FILL(0x00000000); build/asm/main_800CF140.s.o(.text); build/asm/main_800CF140.s.o(.rodata); build/asm/main_800CF140.s.o(.data); }
    .main_800CF140_bss (NOLOAD) : { build/asm/main_800CF140.s.o(.bss); }
    .main_800CF940 0x800CF940 : AT(0x000D0540) { build/asm/data/main_800CF940.bin.o(.data); }
    .main_800D0410 0x800D0410 : AT(0x000D1010) { FILL(0x00000000); build/asm/main_800D0410.s.o(.text); build/asm/main_800D0410.s.o(.rodata); build/asm/main_800D0410.s.o(.data); }
    .main_800D0410_bss (NOLOAD) : { build/asm/main_800D0410.s.o(.bss); }
    .main_800D04F8 0x800D04F8 : AT(0x000D10F8) { build/asm/data/main_800D04F8.bin.o(.data); }
    .main_800D22C4 0x800D22C4 : AT(0x000D2EC4) { FILL(0x00000000); build/asm/main_800D22C4.s.o(.text); build/asm/main_800D22C4.s.o(.rodata); build/asm/main_800D22C4.s.o(.data); }
    .main_800D22C4_bss (NOLOAD) : { build/asm/main_800D22C4.s.o(.bss); }
    .main_800D3160 0x800D3160 : AT(0x000D3D60) { build/asm/data/main_800D3160.bin.o(.data); }
    .main_800D93D4 0x800D93D4 : AT(0x000D9FD4) { FILL(0x00000000); build/asm/main_800D93D4.s.o(.text); build/asm/main_800D93D4.s.o(.rodata); build/asm/main_800D93D4.s.o(.data); }
    .main_800D93D4_bss (NOLOAD) : { build/asm/main_800D93D4.s.o(.bss); }
    .main_800DA3B8 0x800DA3B8 : AT(0x000DAFB8) { build/asm/data/main_800DA3B8.bin.o(.data); }
    .main_800DE270 0x800DE270 : AT(0x000DEE70) { FILL(0x00000000); build/asm/main_800DE270.s.o(.text); build/asm/main_800DE270.s.o(.rodata); build/asm/main_800DE270.s.o(.data); }
    .main_800DE270_bss (NOLOAD) : { build/asm/main_800DE270.s.o(.bss); }
    .main_800DEA64 0x800DEA64 : AT(0x000DF664) { build/asm/data/main_800DEA64.bin.o(.data); }
    .main_800DEBB4 0x800DEBB4 : AT(0x000DF7B4) { FILL(0x00000000); build/asm/main_800DEBB4.s.o(.text); build/asm/main_800DEBB4.s.o(.rodata); build/asm/main_800DEBB4.s.o(.data); }
    .main_800DEBB4_bss (NOLOAD) : { build/asm/main_800DEBB4.s.o(.bss); }
    .main_800DF710 0x800DF710 : AT(0x000E0310) { build/asm/data/main_800DF710.bin.o(.data); }
    .main_800E1DDC 0x800E1DDC : AT(0x000E29DC) { build/asm/data/main_800E1DDC.bin.o(.data); }
    .main_800E4744 0x800E4744 : AT(0x000E5344) { build/asm/data/main_800E4744.bin.o(.data); }
    .main_800E52F8 0x800E52F8 : AT(0x000E5EF8) { build/asm/data/main_800E52F8.bin.o(.data); }
    .main_800F0284 0x800F0284 : AT(0x000F0E84) { FILL(0x00000000); build/asm/main_800F0284.s.o(.text); build/asm/main_800F0284.s.o(.rodata); build/asm/main_800F0284.s.o(.data); }
    .main_800F0284_bss (NOLOAD) : { build/asm/main_800F0284.s.o(.bss); }
    .main_800F02A0 0x800F02A0 : AT(0x000F0EA0) { build/asm/data/main_800F02A0.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
