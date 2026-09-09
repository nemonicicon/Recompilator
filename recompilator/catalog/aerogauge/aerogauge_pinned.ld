SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80066020 0x80066020 : AT(0x00066C20) { FILL(0x00000000); build/asm/main_80066020.s.o(.text); build/asm/main_80066020.s.o(.rodata); build/asm/main_80066020.s.o(.data); }
    .main_80066020_bss (NOLOAD) : { build/asm/main_80066020.s.o(.bss); }
    .main_800661D0 0x800661D0 : AT(0x00066DD0) { FILL(0x00000000); build/asm/main_800661D0.s.o(.text); build/asm/main_800661D0.s.o(.rodata); build/asm/main_800661D0.s.o(.data); }
    .main_800661D0_bss (NOLOAD) : { build/asm/main_800661D0.s.o(.bss); }
    .main_80067AF0 0x80067AF0 : AT(0x000686F0) { FILL(0x00000000); build/asm/main_80067AF0.s.o(.text); build/asm/main_80067AF0.s.o(.rodata); build/asm/main_80067AF0.s.o(.data); }
    .main_80067AF0_bss (NOLOAD) : { build/asm/main_80067AF0.s.o(.bss); }
    .main_80067E50 0x80067E50 : AT(0x00068A50) { FILL(0x00000000); build/asm/main_80067E50.s.o(.text); build/asm/main_80067E50.s.o(.rodata); build/asm/main_80067E50.s.o(.data); }
    .main_80067E50_bss (NOLOAD) : { build/asm/main_80067E50.s.o(.bss); }
    .main_80067FF0 0x80067FF0 : AT(0x00068BF0) { FILL(0x00000000); build/asm/main_80067FF0.s.o(.text); build/asm/main_80067FF0.s.o(.rodata); build/asm/main_80067FF0.s.o(.data); }
    .main_80067FF0_bss (NOLOAD) : { build/asm/main_80067FF0.s.o(.bss); }
    .main_80068820 0x80068820 : AT(0x00069420) { FILL(0x00000000); build/asm/main_80068820.s.o(.text); build/asm/main_80068820.s.o(.rodata); build/asm/main_80068820.s.o(.data); }
    .main_80068820_bss (NOLOAD) : { build/asm/main_80068820.s.o(.bss); }
    .main_8006ABB0 0x8006ABB0 : AT(0x0006B7B0) { FILL(0x00000000); build/asm/main_8006ABB0.s.o(.text); build/asm/main_8006ABB0.s.o(.rodata); build/asm/main_8006ABB0.s.o(.data); }
    .main_8006ABB0_bss (NOLOAD) : { build/asm/main_8006ABB0.s.o(.bss); }
    .main_8006AE70 0x8006AE70 : AT(0x0006BA70) { FILL(0x00000000); build/asm/main_8006AE70.s.o(.text); build/asm/main_8006AE70.s.o(.rodata); build/asm/main_8006AE70.s.o(.data); }
    .main_8006AE70_bss (NOLOAD) : { build/asm/main_8006AE70.s.o(.bss); }
    .main_8006B050 0x8006B050 : AT(0x0006BC50) { FILL(0x00000000); build/asm/main_8006B050.s.o(.text); build/asm/main_8006B050.s.o(.rodata); build/asm/main_8006B050.s.o(.data); }
    .main_8006B050_bss (NOLOAD) : { build/asm/main_8006B050.s.o(.bss); }
    .main_8006C540 0x8006C540 : AT(0x0006D140) { FILL(0x00000000); build/asm/main_8006C540.s.o(.text); build/asm/main_8006C540.s.o(.rodata); build/asm/main_8006C540.s.o(.data); }
    .main_8006C540_bss (NOLOAD) : { build/asm/main_8006C540.s.o(.bss); }
    .main_8006C5E4 0x8006C5E4 : AT(0x0006D1E4) { FILL(0x00000000); build/asm/main_8006C5E4.s.o(.text); build/asm/main_8006C5E4.s.o(.rodata); build/asm/main_8006C5E4.s.o(.data); }
    .main_8006C5E4_bss (NOLOAD) : { build/asm/main_8006C5E4.s.o(.bss); }
    .main_8006C6D8 0x8006C6D8 : AT(0x0006D2D8) { FILL(0x00000000); build/asm/main_8006C6D8.s.o(.text); build/asm/main_8006C6D8.s.o(.rodata); build/asm/main_8006C6D8.s.o(.data); }
    .main_8006C6D8_bss (NOLOAD) : { build/asm/main_8006C6D8.s.o(.bss); }
    .main_8006C890 0x8006C890 : AT(0x0006D490) { FILL(0x00000000); build/asm/main_8006C890.s.o(.text); build/asm/main_8006C890.s.o(.rodata); build/asm/main_8006C890.s.o(.data); }
    .main_8006C890_bss (NOLOAD) : { build/asm/main_8006C890.s.o(.bss); }
    .main_8006CAA0 0x8006CAA0 : AT(0x0006D6A0) { FILL(0x00000000); build/asm/main_8006CAA0.s.o(.text); build/asm/main_8006CAA0.s.o(.rodata); build/asm/main_8006CAA0.s.o(.data); }
    .main_8006CAA0_bss (NOLOAD) : { build/asm/main_8006CAA0.s.o(.bss); }
    .main_8006CD00 0x8006CD00 : AT(0x0006D900) { FILL(0x00000000); build/asm/main_8006CD00.s.o(.text); build/asm/main_8006CD00.s.o(.rodata); build/asm/main_8006CD00.s.o(.data); }
    .main_8006CD00_bss (NOLOAD) : { build/asm/main_8006CD00.s.o(.bss); }
    .main_8006F980 0x8006F980 : AT(0x00070580) { FILL(0x00000000); build/asm/main_8006F980.s.o(.text); build/asm/main_8006F980.s.o(.rodata); build/asm/main_8006F980.s.o(.data); }
    .main_8006F980_bss (NOLOAD) : { build/asm/main_8006F980.s.o(.bss); }
    .main_800701C0 0x800701C0 : AT(0x00070DC0) { FILL(0x00000000); build/asm/main_800701C0.s.o(.text); build/asm/main_800701C0.s.o(.rodata); build/asm/main_800701C0.s.o(.data); }
    .main_800701C0_bss (NOLOAD) : { build/asm/main_800701C0.s.o(.bss); }
    .main_80070600 0x80070600 : AT(0x00071200) { FILL(0x00000000); build/asm/main_80070600.s.o(.text); build/asm/main_80070600.s.o(.rodata); build/asm/main_80070600.s.o(.data); }
    .main_80070600_bss (NOLOAD) : { build/asm/main_80070600.s.o(.bss); }
    .main_800708A0 0x800708A0 : AT(0x000714A0) { FILL(0x00000000); build/asm/main_800708A0.s.o(.text); build/asm/main_800708A0.s.o(.rodata); build/asm/main_800708A0.s.o(.data); }
    .main_800708A0_bss (NOLOAD) : { build/asm/main_800708A0.s.o(.bss); }
    .main_80070DE4 0x80070DE4 : AT(0x000719E4) { FILL(0x00000000); build/asm/main_80070DE4.s.o(.text); build/asm/main_80070DE4.s.o(.rodata); build/asm/main_80070DE4.s.o(.data); }
    .main_80070DE4_bss (NOLOAD) : { build/asm/main_80070DE4.s.o(.bss); }
    .main_800711B0 0x800711B0 : AT(0x00071DB0) { FILL(0x00000000); build/asm/main_800711B0.s.o(.text); build/asm/main_800711B0.s.o(.rodata); build/asm/main_800711B0.s.o(.data); }
    .main_800711B0_bss (NOLOAD) : { build/asm/main_800711B0.s.o(.bss); }
    .main_80074240 0x80074240 : AT(0x00074E40) { FILL(0x00000000); build/asm/main_80074240.s.o(.text); build/asm/main_80074240.s.o(.rodata); build/asm/main_80074240.s.o(.data); }
    .main_80074240_bss (NOLOAD) : { build/asm/main_80074240.s.o(.bss); }
    .main_80076D20 0x80076D20 : AT(0x00077920) { FILL(0x00000000); build/asm/main_80076D20.s.o(.text); build/asm/main_80076D20.s.o(.rodata); build/asm/main_80076D20.s.o(.data); }
    .main_80076D20_bss (NOLOAD) : { build/asm/main_80076D20.s.o(.bss); }
    .main_80077C80 0x80077C80 : AT(0x00078880) { FILL(0x00000000); build/asm/main_80077C80.s.o(.text); build/asm/main_80077C80.s.o(.rodata); build/asm/main_80077C80.s.o(.data); }
    .main_80077C80_bss (NOLOAD) : { build/asm/main_80077C80.s.o(.bss); }
    .main_80077FC0 0x80077FC0 : AT(0x00078BC0) { FILL(0x00000000); build/asm/main_80077FC0.s.o(.text); build/asm/main_80077FC0.s.o(.rodata); build/asm/main_80077FC0.s.o(.data); }
    .main_80077FC0_bss (NOLOAD) : { build/asm/main_80077FC0.s.o(.bss); }
    .main_800786F0 0x800786F0 : AT(0x000792F0) { FILL(0x00000000); build/asm/main_800786F0.s.o(.text); build/asm/main_800786F0.s.o(.rodata); build/asm/main_800786F0.s.o(.data); }
    .main_800786F0_bss (NOLOAD) : { build/asm/main_800786F0.s.o(.bss); }
    .main_80078740 0x80078740 : AT(0x00079340) { FILL(0x00000000); build/asm/main_80078740.s.o(.text); build/asm/main_80078740.s.o(.rodata); build/asm/main_80078740.s.o(.data); }
    .main_80078740_bss (NOLOAD) : { build/asm/main_80078740.s.o(.bss); }
    .main_80078860 0x80078860 : AT(0x00079460) { FILL(0x00000000); build/asm/main_80078860.s.o(.text); build/asm/main_80078860.s.o(.rodata); build/asm/main_80078860.s.o(.data); }
    .main_80078860_bss (NOLOAD) : { build/asm/main_80078860.s.o(.bss); }
    .main_80078980 0x80078980 : AT(0x00079580) { FILL(0x00000000); build/asm/main_80078980.s.o(.text); build/asm/main_80078980.s.o(.rodata); build/asm/main_80078980.s.o(.data); }
    .main_80078980_bss (NOLOAD) : { build/asm/main_80078980.s.o(.bss); }
    .main_80079E30 0x80079E30 : AT(0x0007AA30) { FILL(0x00000000); build/asm/main_80079E30.s.o(.text); build/asm/main_80079E30.s.o(.rodata); build/asm/main_80079E30.s.o(.data); }
    .main_80079E30_bss (NOLOAD) : { build/asm/main_80079E30.s.o(.bss); }
    .main_80084410 0x80084410 : AT(0x00085010) { build/asm/data/main_80084410.bin.o(.data); }
    .main_8008EB70 0x8008EB70 : AT(0x0008F770) { FILL(0x00000000); build/asm/main_8008EB70.s.o(.text); build/asm/main_8008EB70.s.o(.rodata); build/asm/main_8008EB70.s.o(.data); }
    .main_8008EB70_bss (NOLOAD) : { build/asm/main_8008EB70.s.o(.bss); }
    .main_8008EB90 0x8008EB90 : AT(0x0008F790) { build/asm/data/main_8008EB90.bin.o(.data); }
    .main_8008EB98 0x8008EB98 : AT(0x0008F798) { FILL(0x00000000); build/asm/main_8008EB98.s.o(.text); build/asm/main_8008EB98.s.o(.rodata); build/asm/main_8008EB98.s.o(.data); }
    .main_8008EB98_bss (NOLOAD) : { build/asm/main_8008EB98.s.o(.bss); }
    .main_8008EBA4 0x8008EBA4 : AT(0x0008F7A4) { FILL(0x00000000); build/asm/main_8008EBA4.s.o(.text); build/asm/main_8008EBA4.s.o(.rodata); build/asm/main_8008EBA4.s.o(.data); }
    .main_8008EBA4_bss (NOLOAD) : { build/asm/main_8008EBA4.s.o(.bss); }
    .main_800940B0 0x800940B0 : AT(0x00094CB0) { build/asm/data/main_800940B0.bin.o(.data); }
    .main_80094BCC 0x80094BCC : AT(0x000957CC) { FILL(0x00000000); build/asm/main_80094BCC.s.o(.text); build/asm/main_80094BCC.s.o(.rodata); build/asm/main_80094BCC.s.o(.data); }
    .main_80094BCC_bss (NOLOAD) : { build/asm/main_80094BCC.s.o(.bss); }
    .main_800960D8 0x800960D8 : AT(0x00096CD8) { FILL(0x00000000); build/asm/main_800960D8.s.o(.text); build/asm/main_800960D8.s.o(.rodata); build/asm/main_800960D8.s.o(.data); }
    .main_800960D8_bss (NOLOAD) : { build/asm/main_800960D8.s.o(.bss); }
    .main_800984EC 0x800984EC : AT(0x000990EC) { build/asm/data/main_800984EC.bin.o(.data); }
    .main_800AD6C0 0x800AD6C0 : AT(0x000AE2C0) { FILL(0x00000000); build/asm/main_800AD6C0.s.o(.text); build/asm/main_800AD6C0.s.o(.rodata); build/asm/main_800AD6C0.s.o(.data); }
    .main_800AD6C0_bss (NOLOAD) : { build/asm/main_800AD6C0.s.o(.bss); }
    .main_800AD6C4 0x800AD6C4 : AT(0x000AE2C4) { build/asm/data/main_800AD6C4.bin.o(.data); }
    .main_800ADC70 0x800ADC70 : AT(0x000AE870) { FILL(0x00000000); build/asm/main_800ADC70.s.o(.text); build/asm/main_800ADC70.s.o(.rodata); build/asm/main_800ADC70.s.o(.data); }
    .main_800ADC70_bss (NOLOAD) : { build/asm/main_800ADC70.s.o(.bss); }
    .main_800ADC74 0x800ADC74 : AT(0x000AE874) { build/asm/data/main_800ADC74.bin.o(.data); }
    .main_800AE220 0x800AE220 : AT(0x000AEE20) { FILL(0x00000000); build/asm/main_800AE220.s.o(.text); build/asm/main_800AE220.s.o(.rodata); build/asm/main_800AE220.s.o(.data); }
    .main_800AE220_bss (NOLOAD) : { build/asm/main_800AE220.s.o(.bss); }
    .main_800AE224 0x800AE224 : AT(0x000AEE24) { build/asm/data/main_800AE224.bin.o(.data); }
    .main_800B1F48 0x800B1F48 : AT(0x000B2B48) { FILL(0x00000000); build/asm/main_800B1F48.s.o(.text); build/asm/main_800B1F48.s.o(.rodata); build/asm/main_800B1F48.s.o(.data); }
    .main_800B1F48_bss (NOLOAD) : { build/asm/main_800B1F48.s.o(.bss); }
    .main_800B1F84 0x800B1F84 : AT(0x000B2B84) { build/asm/data/main_800B1F84.bin.o(.data); }
    .main_800B1FFC 0x800B1FFC : AT(0x000B2BFC) { FILL(0x00000000); build/asm/main_800B1FFC.s.o(.text); build/asm/main_800B1FFC.s.o(.rodata); build/asm/main_800B1FFC.s.o(.data); }
    .main_800B1FFC_bss (NOLOAD) : { build/asm/main_800B1FFC.s.o(.bss); }
    .main_800B2038 0x800B2038 : AT(0x000B2C38) { build/asm/data/main_800B2038.bin.o(.data); }
    .main_800B3798 0x800B3798 : AT(0x000B4398) { FILL(0x00000000); build/asm/main_800B3798.s.o(.text); build/asm/main_800B3798.s.o(.rodata); build/asm/main_800B3798.s.o(.data); }
    .main_800B3798_bss (NOLOAD) : { build/asm/main_800B3798.s.o(.bss); }
    .main_800B4004 0x800B4004 : AT(0x000B4C04) { build/asm/data/main_800B4004.bin.o(.data); }
    .main_800B4A18 0x800B4A18 : AT(0x000B5618) { FILL(0x00000000); build/asm/main_800B4A18.s.o(.text); build/asm/main_800B4A18.s.o(.rodata); build/asm/main_800B4A18.s.o(.data); }
    .main_800B4A18_bss (NOLOAD) : { build/asm/main_800B4A18.s.o(.bss); }
    .main_800B4A54 0x800B4A54 : AT(0x000B5654) { build/asm/data/main_800B4A54.bin.o(.data); }
    .main_800B4D20 0x800B4D20 : AT(0x000B5920) { FILL(0x00000000); build/asm/main_800B4D20.s.o(.text); build/asm/main_800B4D20.s.o(.rodata); build/asm/main_800B4D20.s.o(.data); }
    .main_800B4D20_bss (NOLOAD) : { build/asm/main_800B4D20.s.o(.bss); }
    .main_800B6A94 0x800B6A94 : AT(0x000B7694) { build/asm/data/main_800B6A94.bin.o(.data); }
    .main_800B6D68 0x800B6D68 : AT(0x000B7968) { FILL(0x00000000); build/asm/main_800B6D68.s.o(.text); build/asm/main_800B6D68.s.o(.rodata); build/asm/main_800B6D68.s.o(.data); }
    .main_800B6D68_bss (NOLOAD) : { build/asm/main_800B6D68.s.o(.bss); }
    .main_800B6D80 0x800B6D80 : AT(0x000B7980) { build/asm/data/main_800B6D80.bin.o(.data); }
    .main_800B6FE4 0x800B6FE4 : AT(0x000B7BE4) { FILL(0x00000000); build/asm/main_800B6FE4.s.o(.text); build/asm/main_800B6FE4.s.o(.rodata); build/asm/main_800B6FE4.s.o(.data); }
    .main_800B6FE4_bss (NOLOAD) : { build/asm/main_800B6FE4.s.o(.bss); }
    .main_800B8320 0x800B8320 : AT(0x000B8F20) { build/asm/data/main_800B8320.bin.o(.data); }
    .main_800C1D00 0x800C1D00 : AT(0x000C2900) { FILL(0x00000000); build/asm/main_800C1D00.s.o(.text); build/asm/main_800C1D00.s.o(.rodata); build/asm/main_800C1D00.s.o(.data); }
    .main_800C1D00_bss (NOLOAD) : { build/asm/main_800C1D00.s.o(.bss); }
    .main_800C2418 0x800C2418 : AT(0x000C3018) { build/asm/data/main_800C2418.bin.o(.data); }
    .main_800C2528 0x800C2528 : AT(0x000C3128) { FILL(0x00000000); build/asm/main_800C2528.s.o(.text); build/asm/main_800C2528.s.o(.rodata); build/asm/main_800C2528.s.o(.data); }
    .main_800C2528_bss (NOLOAD) : { build/asm/main_800C2528.s.o(.bss); }
    .main_800C2588 0x800C2588 : AT(0x000C3188) { build/asm/data/main_800C2588.bin.o(.data); }
    .main_800C25AC 0x800C25AC : AT(0x000C31AC) { FILL(0x00000000); build/asm/main_800C25AC.s.o(.text); build/asm/main_800C25AC.s.o(.rodata); build/asm/main_800C25AC.s.o(.data); }
    .main_800C25AC_bss (NOLOAD) : { build/asm/main_800C25AC.s.o(.bss); }
    .main_800C260C 0x800C260C : AT(0x000C320C) { build/asm/data/main_800C260C.bin.o(.data); }
    .main_800C26F0 0x800C26F0 : AT(0x000C32F0) { FILL(0x00000000); build/asm/main_800C26F0.s.o(.text); build/asm/main_800C26F0.s.o(.rodata); build/asm/main_800C26F0.s.o(.data); }
    .main_800C26F0_bss (NOLOAD) : { build/asm/main_800C26F0.s.o(.bss); }
    .main_800C2708 0x800C2708 : AT(0x000C3308) { build/asm/data/main_800C2708.bin.o(.data); }
    .main_800C2FE4 0x800C2FE4 : AT(0x000C3BE4) { FILL(0x00000000); build/asm/main_800C2FE4.s.o(.text); build/asm/main_800C2FE4.s.o(.rodata); build/asm/main_800C2FE4.s.o(.data); }
    .main_800C2FE4_bss (NOLOAD) : { build/asm/main_800C2FE4.s.o(.bss); }
    .main_800C2FF8 0x800C2FF8 : AT(0x000C3BF8) { build/asm/data/main_800C2FF8.bin.o(.data); }
    .main_800C314C 0x800C314C : AT(0x000C3D4C) { FILL(0x00000000); build/asm/main_800C314C.s.o(.text); build/asm/main_800C314C.s.o(.rodata); build/asm/main_800C314C.s.o(.data); }
    .main_800C314C_bss (NOLOAD) : { build/asm/main_800C314C.s.o(.bss); }
    .main_800C3154 0x800C3154 : AT(0x000C3D54) { build/asm/data/main_800C3154.bin.o(.data); }
    .main_800C3170 0x800C3170 : AT(0x000C3D70) { FILL(0x00000000); build/asm/main_800C3170.s.o(.text); build/asm/main_800C3170.s.o(.rodata); build/asm/main_800C3170.s.o(.data); }
    .main_800C3170_bss (NOLOAD) : { build/asm/main_800C3170.s.o(.bss); }
    .main_800C31A8 0x800C31A8 : AT(0x000C3DA8) { build/asm/data/main_800C31A8.bin.o(.data); }
    .main_800C3280 0x800C3280 : AT(0x000C3E80) { FILL(0x00000000); build/asm/main_800C3280.s.o(.text); build/asm/main_800C3280.s.o(.rodata); build/asm/main_800C3280.s.o(.data); }
    .main_800C3280_bss (NOLOAD) : { build/asm/main_800C3280.s.o(.bss); }
    .main_800C332C 0x800C332C : AT(0x000C3F2C) { build/asm/data/main_800C332C.bin.o(.data); }
    .main_800C3398 0x800C3398 : AT(0x000C3F98) { FILL(0x00000000); build/asm/main_800C3398.s.o(.text); build/asm/main_800C3398.s.o(.rodata); build/asm/main_800C3398.s.o(.data); }
    .main_800C3398_bss (NOLOAD) : { build/asm/main_800C3398.s.o(.bss); }
    .main_800C33A0 0x800C33A0 : AT(0x000C3FA0) { build/asm/data/main_800C33A0.bin.o(.data); }
    .main_800C33A8 0x800C33A8 : AT(0x000C3FA8) { FILL(0x00000000); build/asm/main_800C33A8.s.o(.text); build/asm/main_800C33A8.s.o(.rodata); build/asm/main_800C33A8.s.o(.data); }
    .main_800C33A8_bss (NOLOAD) : { build/asm/main_800C33A8.s.o(.bss); }
    .main_800C3B7C 0x800C3B7C : AT(0x000C477C) { build/asm/data/main_800C3B7C.bin.o(.data); }
    .main_800C7250 0x800C7250 : AT(0x000C7E50) { FILL(0x00000000); build/asm/main_800C7250.s.o(.text); build/asm/main_800C7250.s.o(.rodata); build/asm/main_800C7250.s.o(.data); }
    .main_800C7250_bss (NOLOAD) : { build/asm/main_800C7250.s.o(.bss); }
    .main_800C7490 0x800C7490 : AT(0x000C8090) { build/asm/data/main_800C7490.bin.o(.data); }
    .main_800C7A50 0x800C7A50 : AT(0x000C8650) { build/asm/data/main_800C7A50.bin.o(.data); }
    .main_800C7EA0 0x800C7EA0 : AT(0x000C8AA0) { build/asm/data/main_800C7EA0.bin.o(.data); }
    .main_800C9080 0x800C9080 : AT(0x000C9C80) { FILL(0x00000000); build/asm/main_800C9080.s.o(.text); build/asm/main_800C9080.s.o(.rodata); build/asm/main_800C9080.s.o(.data); }
    .main_800C9080_bss (NOLOAD) : { build/asm/main_800C9080.s.o(.bss); }
    .main_800C908C 0x800C908C : AT(0x000C9C8C) { build/asm/data/main_800C908C.bin.o(.data); }
    .main_800C91E8 0x800C91E8 : AT(0x000C9DE8) { FILL(0x00000000); build/asm/main_800C91E8.s.o(.text); build/asm/main_800C91E8.s.o(.rodata); build/asm/main_800C91E8.s.o(.data); }
    .main_800C91E8_bss (NOLOAD) : { build/asm/main_800C91E8.s.o(.bss); }
    .main_800C91F4 0x800C91F4 : AT(0x000C9DF4) { build/asm/data/main_800C91F4.bin.o(.data); }
    .main_800D8DA0 0x800D8DA0 : AT(0x000D99A0) { FILL(0x00000000); build/asm/main_800D8DA0.s.o(.text); build/asm/main_800D8DA0.s.o(.rodata); build/asm/main_800D8DA0.s.o(.data); }
    .main_800D8DA0_bss (NOLOAD) : { build/asm/main_800D8DA0.s.o(.bss); }
    .main_800D903C 0x800D903C : AT(0x000D9C3C) { build/asm/data/main_800D903C.bin.o(.data); }
    .main_800D9794 0x800D9794 : AT(0x000DA394) { FILL(0x00000000); build/asm/main_800D9794.s.o(.text); build/asm/main_800D9794.s.o(.rodata); build/asm/main_800D9794.s.o(.data); }
    .main_800D9794_bss (NOLOAD) : { build/asm/main_800D9794.s.o(.bss); }
    .main_800D991C 0x800D991C : AT(0x000DA51C) { build/asm/data/main_800D991C.bin.o(.data); }
    .main_800DA0D8 0x800DA0D8 : AT(0x000DACD8) { FILL(0x00000000); build/asm/main_800DA0D8.s.o(.text); build/asm/main_800DA0D8.s.o(.rodata); build/asm/main_800DA0D8.s.o(.data); }
    .main_800DA0D8_bss (NOLOAD) : { build/asm/main_800DA0D8.s.o(.bss); }
    .main_800DA0F8 0x800DA0F8 : AT(0x000DACF8) { build/asm/data/main_800DA0F8.bin.o(.data); }
    .main_800DAB8C 0x800DAB8C : AT(0x000DB78C) { FILL(0x00000000); build/asm/main_800DAB8C.s.o(.text); build/asm/main_800DAB8C.s.o(.rodata); build/asm/main_800DAB8C.s.o(.data); }
    .main_800DAB8C_bss (NOLOAD) : { build/asm/main_800DAB8C.s.o(.bss); }
    .main_800DAC88 0x800DAC88 : AT(0x000DB888) { build/asm/data/main_800DAC88.bin.o(.data); }
    .main_800DD7C4 0x800DD7C4 : AT(0x000DE3C4) { FILL(0x00000000); build/asm/main_800DD7C4.s.o(.text); build/asm/main_800DD7C4.s.o(.rodata); build/asm/main_800DD7C4.s.o(.data); }
    .main_800DD7C4_bss (NOLOAD) : { build/asm/main_800DD7C4.s.o(.bss); }
    .main_800DD8E4 0x800DD8E4 : AT(0x000DE4E4) { build/asm/data/main_800DD8E4.bin.o(.data); }
    .main_800E0648 0x800E0648 : AT(0x000E1248) { FILL(0x00000000); build/asm/main_800E0648.s.o(.text); build/asm/main_800E0648.s.o(.rodata); build/asm/main_800E0648.s.o(.data); }
    .main_800E0648_bss (NOLOAD) : { build/asm/main_800E0648.s.o(.bss); }
    .main_800E6CCC 0x800E6CCC : AT(0x000E78CC) { build/asm/data/main_800E6CCC.bin.o(.data); }
    .main_800E874C 0x800E874C : AT(0x000E934C) { FILL(0x00000000); build/asm/main_800E874C.s.o(.text); build/asm/main_800E874C.s.o(.rodata); build/asm/main_800E874C.s.o(.data); }
    .main_800E874C_bss (NOLOAD) : { build/asm/main_800E874C.s.o(.bss); }
    .main_800E92C8 0x800E92C8 : AT(0x000E9EC8) { build/asm/data/main_800E92C8.bin.o(.data); }
    .main_800E9378 0x800E9378 : AT(0x000E9F78) { FILL(0x00000000); build/asm/main_800E9378.s.o(.text); build/asm/main_800E9378.s.o(.rodata); build/asm/main_800E9378.s.o(.data); }
    .main_800E9378_bss (NOLOAD) : { build/asm/main_800E9378.s.o(.bss); }
    .main_800E9918 0x800E9918 : AT(0x000EA518) { build/asm/data/main_800E9918.bin.o(.data); }
    .main_800EA52C 0x800EA52C : AT(0x000EB12C) { FILL(0x00000000); build/asm/main_800EA52C.s.o(.text); build/asm/main_800EA52C.s.o(.rodata); build/asm/main_800EA52C.s.o(.data); }
    .main_800EA52C_bss (NOLOAD) : { build/asm/main_800EA52C.s.o(.bss); }
    .main_800EB058 0x800EB058 : AT(0x000EBC58) { build/asm/data/main_800EB058.bin.o(.data); }
    .main_800EBD34 0x800EBD34 : AT(0x000EC934) { FILL(0x00000000); build/asm/main_800EBD34.s.o(.text); build/asm/main_800EBD34.s.o(.rodata); build/asm/main_800EBD34.s.o(.data); }
    .main_800EBD34_bss (NOLOAD) : { build/asm/main_800EBD34.s.o(.bss); }
    .main_800EE350 0x800EE350 : AT(0x000EEF50) { build/asm/data/main_800EE350.bin.o(.data); }
    .main_800FC1A0 0x800FC1A0 : AT(0x000FCDA0) { FILL(0x00000000); build/asm/main_800FC1A0.s.o(.text); build/asm/main_800FC1A0.s.o(.rodata); build/asm/main_800FC1A0.s.o(.data); }
    .main_800FC1A0_bss (NOLOAD) : { build/asm/main_800FC1A0.s.o(.bss); }
    .main_800FC1B0 0x800FC1B0 : AT(0x000FCDB0) { build/asm/data/main_800FC1B0.bin.o(.data); }
    .main_800FC3D0 0x800FC3D0 : AT(0x000FCFD0) { FILL(0x00000000); build/asm/main_800FC3D0.s.o(.text); build/asm/main_800FC3D0.s.o(.rodata); build/asm/main_800FC3D0.s.o(.data); }
    .main_800FC3D0_bss (NOLOAD) : { build/asm/main_800FC3D0.s.o(.bss); }
    .main_800FC7F4 0x800FC7F4 : AT(0x000FD3F4) { build/asm/data/main_800FC7F4.bin.o(.data); }
    .main_800FDD00 0x800FDD00 : AT(0x000FE900) { FILL(0x00000000); build/asm/main_800FDD00.s.o(.text); build/asm/main_800FDD00.s.o(.rodata); build/asm/main_800FDD00.s.o(.data); }
    .main_800FDD00_bss (NOLOAD) : { build/asm/main_800FDD00.s.o(.bss); }
    .main_800FDE1C 0x800FDE1C : AT(0x000FEA1C) { build/asm/data/main_800FDE1C.bin.o(.data); }
    .main_800FF120 0x800FF120 : AT(0x000FFD20) { FILL(0x00000000); build/asm/main_800FF120.s.o(.text); build/asm/main_800FF120.s.o(.rodata); build/asm/main_800FF120.s.o(.data); }
    .main_800FF120_bss (NOLOAD) : { build/asm/main_800FF120.s.o(.bss); }
    .main_800FF83C 0x800FF83C : AT(0x0010043C) { build/asm/data/main_800FF83C.bin.o(.data); }
    .main_800FF848 0x800FF848 : AT(0x00100448) { FILL(0x00000000); build/asm/main_800FF848.s.o(.text); build/asm/main_800FF848.s.o(.rodata); build/asm/main_800FF848.s.o(.data); }
    .main_800FF848_bss (NOLOAD) : { build/asm/main_800FF848.s.o(.bss); }
    .main_800FF888 0x800FF888 : AT(0x00100488) { build/asm/data/main_800FF888.bin.o(.data); }
    .main_800FF900 0x800FF900 : AT(0x00100500) { FILL(0x00000000); build/asm/main_800FF900.s.o(.text); build/asm/main_800FF900.s.o(.rodata); build/asm/main_800FF900.s.o(.data); }
    .main_800FF900_bss (NOLOAD) : { build/asm/main_800FF900.s.o(.bss); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
