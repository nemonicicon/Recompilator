SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80125900 0x80125900 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80125900.s.o(.text); build/asm/main_80125900.s.o(.rodata); build/asm/main_80125900.s.o(.data); }
    .main_80125900_bss (NOLOAD) : { build/asm/main_80125900.s.o(.bss); }
    .main_80125980 0x80125980 : AT(0x00001080) { FILL(0x00000000); build/asm/main_80125980.s.o(.text); build/asm/main_80125980.s.o(.rodata); build/asm/main_80125980.s.o(.data); }
    .main_80125980_bss (NOLOAD) : { build/asm/main_80125980.s.o(.bss); }
    .main_80137B50 0x80137B50 : AT(0x00013250) { FILL(0x00000000); build/asm/main_80137B50.s.o(.text); build/asm/main_80137B50.s.o(.rodata); build/asm/main_80137B50.s.o(.data); }
    .main_80137B50_bss (NOLOAD) : { build/asm/main_80137B50.s.o(.bss); }
    .main_80137BF4 0x80137BF4 : AT(0x000132F4) { FILL(0x00000000); build/asm/main_80137BF4.s.o(.text); build/asm/main_80137BF4.s.o(.rodata); build/asm/main_80137BF4.s.o(.data); }
    .main_80137BF4_bss (NOLOAD) : { build/asm/main_80137BF4.s.o(.bss); }
    .main_80137CE8 0x80137CE8 : AT(0x000133E8) { FILL(0x00000000); build/asm/main_80137CE8.s.o(.text); build/asm/main_80137CE8.s.o(.rodata); build/asm/main_80137CE8.s.o(.data); }
    .main_80137CE8_bss (NOLOAD) : { build/asm/main_80137CE8.s.o(.bss); }
    .main_80138330 0x80138330 : AT(0x00013A30) { FILL(0x00000000); build/asm/main_80138330.s.o(.text); build/asm/main_80138330.s.o(.rodata); build/asm/main_80138330.s.o(.data); }
    .main_80138330_bss (NOLOAD) : { build/asm/main_80138330.s.o(.bss); }
    .main_80139200 0x80139200 : AT(0x00014900) { FILL(0x00000000); build/asm/main_80139200.s.o(.text); build/asm/main_80139200.s.o(.rodata); build/asm/main_80139200.s.o(.data); }
    .main_80139200_bss (NOLOAD) : { build/asm/main_80139200.s.o(.bss); }
    .main_801395D0 0x801395D0 : AT(0x00014CD0) { FILL(0x00000000); build/asm/main_801395D0.s.o(.text); build/asm/main_801395D0.s.o(.rodata); build/asm/main_801395D0.s.o(.data); }
    .main_801395D0_bss (NOLOAD) : { build/asm/main_801395D0.s.o(.bss); }
    .main_80139980 0x80139980 : AT(0x00015080) { FILL(0x00000000); build/asm/main_80139980.s.o(.text); build/asm/main_80139980.s.o(.rodata); build/asm/main_80139980.s.o(.data); }
    .main_80139980_bss (NOLOAD) : { build/asm/main_80139980.s.o(.bss); }
    .main_80139CB0 0x80139CB0 : AT(0x000153B0) { FILL(0x00000000); build/asm/main_80139CB0.s.o(.text); build/asm/main_80139CB0.s.o(.rodata); build/asm/main_80139CB0.s.o(.data); }
    .main_80139CB0_bss (NOLOAD) : { build/asm/main_80139CB0.s.o(.bss); }
    .main_8013E0F0 0x8013E0F0 : AT(0x000197F0) { FILL(0x00000000); build/asm/main_8013E0F0.s.o(.text); build/asm/main_8013E0F0.s.o(.rodata); build/asm/main_8013E0F0.s.o(.data); }
    .main_8013E0F0_bss (NOLOAD) : { build/asm/main_8013E0F0.s.o(.bss); }
    .main_8013E360 0x8013E360 : AT(0x00019A60) { FILL(0x00000000); build/asm/main_8013E360.s.o(.text); build/asm/main_8013E360.s.o(.rodata); build/asm/main_8013E360.s.o(.data); }
    .main_8013E360_bss (NOLOAD) : { build/asm/main_8013E360.s.o(.bss); }
    .main_8013E590 0x8013E590 : AT(0x00019C90) { FILL(0x00000000); build/asm/main_8013E590.s.o(.text); build/asm/main_8013E590.s.o(.rodata); build/asm/main_8013E590.s.o(.data); }
    .main_8013E590_bss (NOLOAD) : { build/asm/main_8013E590.s.o(.bss); }
    .main_8013F2E0 0x8013F2E0 : AT(0x0001A9E0) { FILL(0x00000000); build/asm/main_8013F2E0.s.o(.text); build/asm/main_8013F2E0.s.o(.rodata); build/asm/main_8013F2E0.s.o(.data); }
    .main_8013F2E0_bss (NOLOAD) : { build/asm/main_8013F2E0.s.o(.bss); }
    .main_80140D90 0x80140D90 : AT(0x0001C490) { FILL(0x00000000); build/asm/main_80140D90.s.o(.text); build/asm/main_80140D90.s.o(.rodata); build/asm/main_80140D90.s.o(.data); }
    .main_80140D90_bss (NOLOAD) : { build/asm/main_80140D90.s.o(.bss); }
    .main_80141374 0x80141374 : AT(0x0001CA74) { FILL(0x00000000); build/asm/main_80141374.s.o(.text); build/asm/main_80141374.s.o(.rodata); build/asm/main_80141374.s.o(.data); }
    .main_80141374_bss (NOLOAD) : { build/asm/main_80141374.s.o(.bss); }
    .main_801417C0 0x801417C0 : AT(0x0001CEC0) { FILL(0x00000000); build/asm/main_801417C0.s.o(.text); build/asm/main_801417C0.s.o(.rodata); build/asm/main_801417C0.s.o(.data); }
    .main_801417C0_bss (NOLOAD) : { build/asm/main_801417C0.s.o(.bss); }
    .main_801418D0 0x801418D0 : AT(0x0001CFD0) { FILL(0x00000000); build/asm/main_801418D0.s.o(.text); build/asm/main_801418D0.s.o(.rodata); build/asm/main_801418D0.s.o(.data); }
    .main_801418D0_bss (NOLOAD) : { build/asm/main_801418D0.s.o(.bss); }
    .main_80141E20 0x80141E20 : AT(0x0001D520) { FILL(0x00000000); build/asm/main_80141E20.s.o(.text); build/asm/main_80141E20.s.o(.rodata); build/asm/main_80141E20.s.o(.data); }
    .main_80141E20_bss (NOLOAD) : { build/asm/main_80141E20.s.o(.bss); }
    .main_801420D8 0x801420D8 : AT(0x0001D7D8) { FILL(0x00000000); build/asm/main_801420D8.s.o(.text); build/asm/main_801420D8.s.o(.rodata); build/asm/main_801420D8.s.o(.data); }
    .main_801420D8_bss (NOLOAD) : { build/asm/main_801420D8.s.o(.bss); }
    .main_801427D0 0x801427D0 : AT(0x0001DED0) { FILL(0x00000000); build/asm/main_801427D0.s.o(.text); build/asm/main_801427D0.s.o(.rodata); build/asm/main_801427D0.s.o(.data); }
    .main_801427D0_bss (NOLOAD) : { build/asm/main_801427D0.s.o(.bss); }
    .main_801428A0 0x801428A0 : AT(0x0001DFA0) { FILL(0x00000000); build/asm/main_801428A0.s.o(.text); build/asm/main_801428A0.s.o(.rodata); build/asm/main_801428A0.s.o(.data); }
    .main_801428A0_bss (NOLOAD) : { build/asm/main_801428A0.s.o(.bss); }
    .main_80143EB0 0x80143EB0 : AT(0x0001F5B0) { FILL(0x00000000); build/asm/main_80143EB0.s.o(.text); build/asm/main_80143EB0.s.o(.rodata); build/asm/main_80143EB0.s.o(.data); }
    .main_80143EB0_bss (NOLOAD) : { build/asm/main_80143EB0.s.o(.bss); }
    .main_80147240 0x80147240 : AT(0x00022940) { FILL(0x00000000); build/asm/main_80147240.s.o(.text); build/asm/main_80147240.s.o(.rodata); build/asm/main_80147240.s.o(.data); }
    .main_80147240_bss (NOLOAD) : { build/asm/main_80147240.s.o(.bss); }
    .main_80149580 0x80149580 : AT(0x00024C80) { FILL(0x00000000); build/asm/main_80149580.s.o(.text); build/asm/main_80149580.s.o(.rodata); build/asm/main_80149580.s.o(.data); }
    .main_80149580_bss (NOLOAD) : { build/asm/main_80149580.s.o(.bss); }
    .main_8014AC20 0x8014AC20 : AT(0x00026320) { FILL(0x00000000); build/asm/main_8014AC20.s.o(.text); build/asm/main_8014AC20.s.o(.rodata); build/asm/main_8014AC20.s.o(.data); }
    .main_8014AC20_bss (NOLOAD) : { build/asm/main_8014AC20.s.o(.bss); }
    .main_8014B2C0 0x8014B2C0 : AT(0x000269C0) { FILL(0x00000000); build/asm/main_8014B2C0.s.o(.text); build/asm/main_8014B2C0.s.o(.rodata); build/asm/main_8014B2C0.s.o(.data); }
    .main_8014B2C0_bss (NOLOAD) : { build/asm/main_8014B2C0.s.o(.bss); }
    .main_8014B310 0x8014B310 : AT(0x00026A10) { FILL(0x00000000); build/asm/main_8014B310.s.o(.text); build/asm/main_8014B310.s.o(.rodata); build/asm/main_8014B310.s.o(.data); }
    .main_8014B310_bss (NOLOAD) : { build/asm/main_8014B310.s.o(.bss); }
    .main_801558FC 0x801558FC : AT(0x00030FFC) { build/asm/data/main_801558FC.bin.o(.data); }
    .main_80158450 0x80158450 : AT(0x00033B50) { FILL(0x00000000); build/asm/main_80158450.s.o(.text); build/asm/main_80158450.s.o(.rodata); build/asm/main_80158450.s.o(.data); }
    .main_80158450_bss (NOLOAD) : { build/asm/main_80158450.s.o(.bss); }
    .main_8015BFD0 0x8015BFD0 : AT(0x000376D0) { FILL(0x00000000); build/asm/main_8015BFD0.s.o(.text); build/asm/main_8015BFD0.s.o(.rodata); build/asm/main_8015BFD0.s.o(.data); }
    .main_8015BFD0_bss (NOLOAD) : { build/asm/main_8015BFD0.s.o(.bss); }
    .main_8015CA20 0x8015CA20 : AT(0x00038120) { FILL(0x00000000); build/asm/main_8015CA20.s.o(.text); build/asm/main_8015CA20.s.o(.rodata); build/asm/main_8015CA20.s.o(.data); }
    .main_8015CA20_bss (NOLOAD) : { build/asm/main_8015CA20.s.o(.bss); }
    .main_8015D9E0 0x8015D9E0 : AT(0x000390E0) { build/asm/data/main_8015D9E0.bin.o(.data); }
    .main_8015DF50 0x8015DF50 : AT(0x00039650) { build/asm/data/main_8015DF50.bin.o(.data); }
    .main_8015E820 0x8015E820 : AT(0x00039F20) { FILL(0x00000000); build/asm/main_8015E820.s.o(.text); build/asm/main_8015E820.s.o(.rodata); build/asm/main_8015E820.s.o(.data); }
    .main_8015E820_bss (NOLOAD) : { build/asm/main_8015E820.s.o(.bss); }
    .main_8015EAA0 0x8015EAA0 : AT(0x0003A1A0) { build/asm/data/main_8015EAA0.bin.o(.data); }
    .main_8015EB20 0x8015EB20 : AT(0x0003A220) { FILL(0x00000000); build/asm/main_8015EB20.s.o(.text); build/asm/main_8015EB20.s.o(.rodata); build/asm/main_8015EB20.s.o(.data); }
    .main_8015EB20_bss (NOLOAD) : { build/asm/main_8015EB20.s.o(.bss); }
    .main_8015EBA0 0x8015EBA0 : AT(0x0003A2A0) { build/asm/data/main_8015EBA0.bin.o(.data); }
    .main_80160000 0x80160000 : AT(0x0003B700) { FILL(0x00000000); build/asm/main_80160000.s.o(.text); build/asm/main_80160000.s.o(.rodata); build/asm/main_80160000.s.o(.data); }
    .main_80160000_bss (NOLOAD) : { build/asm/main_80160000.s.o(.bss); }
    .main_80160028 0x80160028 : AT(0x0003B728) { build/asm/data/main_80160028.bin.o(.data); }
    .main_801607AC 0x801607AC : AT(0x0003BEAC) { build/asm/data/main_801607AC.bin.o(.data); }
    .main_8016328C 0x8016328C : AT(0x0003E98C) { build/asm/data/main_8016328C.bin.o(.data); }
    .main_80164B8C 0x80164B8C : AT(0x0004028C) { FILL(0x00000000); build/asm/main_80164B8C.s.o(.text); build/asm/main_80164B8C.s.o(.rodata); build/asm/main_80164B8C.s.o(.data); }
    .main_80164B8C_bss (NOLOAD) : { build/asm/main_80164B8C.s.o(.bss); }
    .main_80164F9C 0x80164F9C : AT(0x0004069C) { build/asm/data/main_80164F9C.bin.o(.data); }
    .main_8016565C 0x8016565C : AT(0x00040D5C) { FILL(0x00000000); build/asm/main_8016565C.s.o(.text); build/asm/main_8016565C.s.o(.rodata); build/asm/main_8016565C.s.o(.data); }
    .main_8016565C_bss (NOLOAD) : { build/asm/main_8016565C.s.o(.bss); }
    .main_80165C9C 0x80165C9C : AT(0x0004139C) { build/asm/data/main_80165C9C.bin.o(.data); }
    .main_8016C82C 0x8016C82C : AT(0x00047F2C) { FILL(0x00000000); build/asm/main_8016C82C.s.o(.text); build/asm/main_8016C82C.s.o(.rodata); build/asm/main_8016C82C.s.o(.data); }
    .main_8016C82C_bss (NOLOAD) : { build/asm/main_8016C82C.s.o(.bss); }
    .main_8016C8FC 0x8016C8FC : AT(0x00047FFC) { build/asm/data/main_8016C8FC.bin.o(.data); }
    .main_8016C9DC 0x8016C9DC : AT(0x000480DC) { FILL(0x00000000); build/asm/main_8016C9DC.s.o(.text); build/asm/main_8016C9DC.s.o(.rodata); build/asm/main_8016C9DC.s.o(.data); }
    .main_8016C9DC_bss (NOLOAD) : { build/asm/main_8016C9DC.s.o(.bss); }
    .main_8016C9EC 0x8016C9EC : AT(0x000480EC) { build/asm/data/main_8016C9EC.bin.o(.data); }
    .main_8016D8DC 0x8016D8DC : AT(0x00048FDC) { FILL(0x00000000); build/asm/main_8016D8DC.s.o(.text); build/asm/main_8016D8DC.s.o(.rodata); build/asm/main_8016D8DC.s.o(.data); }
    .main_8016D8DC_bss (NOLOAD) : { build/asm/main_8016D8DC.s.o(.bss); }
    .main_8016D93C 0x8016D93C : AT(0x0004903C) { build/asm/data/main_8016D93C.bin.o(.data); }
    .main_8016DA0C 0x8016DA0C : AT(0x0004910C) { FILL(0x00000000); build/asm/main_8016DA0C.s.o(.text); build/asm/main_8016DA0C.s.o(.rodata); build/asm/main_8016DA0C.s.o(.data); }
    .main_8016DA0C_bss (NOLOAD) : { build/asm/main_8016DA0C.s.o(.bss); }
    .main_8016FEDC 0x8016FEDC : AT(0x0004B5DC) { build/asm/data/main_8016FEDC.bin.o(.data); }
    .main_801738F4 0x801738F4 : AT(0x0004EFF4) { FILL(0x00000000); build/asm/main_801738F4.s.o(.text); build/asm/main_801738F4.s.o(.rodata); build/asm/main_801738F4.s.o(.data); }
    .main_801738F4_bss (NOLOAD) : { build/asm/main_801738F4.s.o(.bss); }
    .main_80173D04 0x80173D04 : AT(0x0004F404) { build/asm/data/main_80173D04.bin.o(.data); }
    .main_80173F94 0x80173F94 : AT(0x0004F694) { FILL(0x00000000); build/asm/main_80173F94.s.o(.text); build/asm/main_80173F94.s.o(.rodata); build/asm/main_80173F94.s.o(.data); }
    .main_80173F94_bss (NOLOAD) : { build/asm/main_80173F94.s.o(.bss); }
    .main_80173FB4 0x80173FB4 : AT(0x0004F6B4) { build/asm/data/main_80173FB4.bin.o(.data); }
    .main_80174120 0x80174120 : AT(0x0004F820) { FILL(0x00000000); build/asm/main_80174120.s.o(.text); build/asm/main_80174120.s.o(.rodata); build/asm/main_80174120.s.o(.data); }
    .main_80174120_bss (NOLOAD) : { build/asm/main_80174120.s.o(.bss); }
    .main_8017487C 0x8017487C : AT(0x0004FF7C) { build/asm/data/main_8017487C.bin.o(.data); }
    .main_80176690 0x80176690 : AT(0x00051D90) { FILL(0x00000000); build/asm/main_80176690.s.o(.text); build/asm/main_80176690.s.o(.rodata); build/asm/main_80176690.s.o(.data); }
    .main_80176690_bss (NOLOAD) : { build/asm/main_80176690.s.o(.bss); }
    .main_801769C0 0x801769C0 : AT(0x000520C0) { build/asm/data/main_801769C0.bin.o(.data); }
    .main_80176B70 0x80176B70 : AT(0x00052270) { FILL(0x00000000); build/asm/main_80176B70.s.o(.text); build/asm/main_80176B70.s.o(.rodata); build/asm/main_80176B70.s.o(.data); }
    .main_80176B70_bss (NOLOAD) : { build/asm/main_80176B70.s.o(.bss); }
    .main_80176DE0 0x80176DE0 : AT(0x000524E0) { build/asm/data/main_80176DE0.bin.o(.data); }
    .main_8017B5FC 0x8017B5FC : AT(0x00056CFC) { FILL(0x00000000); build/asm/main_8017B5FC.s.o(.text); build/asm/main_8017B5FC.s.o(.rodata); build/asm/main_8017B5FC.s.o(.data); }
    .main_8017B5FC_bss (NOLOAD) : { build/asm/main_8017B5FC.s.o(.bss); }
    .main_8017BBFC 0x8017BBFC : AT(0x000572FC) { build/asm/data/main_8017BBFC.bin.o(.data); }
    .main_8017F124 0x8017F124 : AT(0x0005A824) { FILL(0x00000000); build/asm/main_8017F124.s.o(.text); build/asm/main_8017F124.s.o(.rodata); build/asm/main_8017F124.s.o(.data); }
    .main_8017F124_bss (NOLOAD) : { build/asm/main_8017F124.s.o(.bss); }
    .main_8017F7F8 0x8017F7F8 : AT(0x0005AEF8) { build/asm/data/main_8017F7F8.bin.o(.data); }
    .main_80180000 0x80180000 : AT(0x0005B700) { FILL(0x00000000); build/asm/main_80180000.s.o(.text); build/asm/main_80180000.s.o(.rodata); build/asm/main_80180000.s.o(.data); }
    .main_80180000_bss (NOLOAD) : { build/asm/main_80180000.s.o(.bss); }
    .main_80180920 0x80180920 : AT(0x0005C020) { build/asm/data/main_80180920.bin.o(.data); }
    .main_80183F3C 0x80183F3C : AT(0x0005F63C) { FILL(0x00000000); build/asm/main_80183F3C.s.o(.text); build/asm/main_80183F3C.s.o(.rodata); build/asm/main_80183F3C.s.o(.data); }
    .main_80183F3C_bss (NOLOAD) : { build/asm/main_80183F3C.s.o(.bss); }
    .main_80184B9C 0x80184B9C : AT(0x0006029C) { build/asm/data/main_80184B9C.bin.o(.data); }
    .main_8018A018 0x8018A018 : AT(0x00065718) { FILL(0x00000000); build/asm/main_8018A018.s.o(.text); build/asm/main_8018A018.s.o(.rodata); build/asm/main_8018A018.s.o(.data); }
    .main_8018A018_bss (NOLOAD) : { build/asm/main_8018A018.s.o(.bss); }
    .main_8018A094 0x8018A094 : AT(0x00065794) { build/asm/data/main_8018A094.bin.o(.data); }
    .main_8019559C 0x8019559C : AT(0x00070C9C) { FILL(0x00000000); build/asm/main_8019559C.s.o(.text); build/asm/main_8019559C.s.o(.rodata); build/asm/main_8019559C.s.o(.data); }
    .main_8019559C_bss (NOLOAD) : { build/asm/main_8019559C.s.o(.bss); }
    .main_80195D54 0x80195D54 : AT(0x00071454) { build/asm/data/main_80195D54.bin.o(.data); }
    .main_801A5E54 0x801A5E54 : AT(0x00081554) { build/asm/data/main_801A5E54.bin.o(.data); }
    .main_801A6B24 0x801A6B24 : AT(0x00082224) { FILL(0x00000000); build/asm/main_801A6B24.s.o(.text); build/asm/main_801A6B24.s.o(.rodata); build/asm/main_801A6B24.s.o(.data); }
    .main_801A6B24_bss (NOLOAD) : { build/asm/main_801A6B24.s.o(.bss); }
    .main_801A6C84 0x801A6C84 : AT(0x00082384) { build/asm/data/main_801A6C84.bin.o(.data); }
    .main_801A8F20 0x801A8F20 : AT(0x00084620) { FILL(0x00000000); build/asm/main_801A8F20.s.o(.text); build/asm/main_801A8F20.s.o(.rodata); build/asm/main_801A8F20.s.o(.data); }
    .main_801A8F20_bss (NOLOAD) : { build/asm/main_801A8F20.s.o(.bss); }
    .main_801A9CB4 0x801A9CB4 : AT(0x000853B4) { build/asm/data/main_801A9CB4.bin.o(.data); }
    .main_801AA030 0x801AA030 : AT(0x00085730) { FILL(0x00000000); build/asm/main_801AA030.s.o(.text); build/asm/main_801AA030.s.o(.rodata); build/asm/main_801AA030.s.o(.data); }
    .main_801AA030_bss (NOLOAD) : { build/asm/main_801AA030.s.o(.bss); }
    .main_801AB104 0x801AB104 : AT(0x00086804) { build/asm/data/main_801AB104.bin.o(.data); }
    .main_801ACEC0 0x801ACEC0 : AT(0x000885C0) { FILL(0x00000000); build/asm/main_801ACEC0.s.o(.text); build/asm/main_801ACEC0.s.o(.rodata); build/asm/main_801ACEC0.s.o(.data); }
    .main_801ACEC0_bss (NOLOAD) : { build/asm/main_801ACEC0.s.o(.bss); }
    .main_801ACF20 0x801ACF20 : AT(0x00088620) { build/asm/data/main_801ACF20.bin.o(.data); }
    .main_801AD3A8 0x801AD3A8 : AT(0x00088AA8) { FILL(0x00000000); build/asm/main_801AD3A8.s.o(.text); build/asm/main_801AD3A8.s.o(.rodata); build/asm/main_801AD3A8.s.o(.data); }
    .main_801AD3A8_bss (NOLOAD) : { build/asm/main_801AD3A8.s.o(.bss); }
    .main_801AD468 0x801AD468 : AT(0x00088B68) { build/asm/data/main_801AD468.bin.o(.data); }
    .main_801ADD3C 0x801ADD3C : AT(0x0008943C) { FILL(0x00000000); build/asm/main_801ADD3C.s.o(.text); build/asm/main_801ADD3C.s.o(.rodata); build/asm/main_801ADD3C.s.o(.data); }
    .main_801ADD3C_bss (NOLOAD) : { build/asm/main_801ADD3C.s.o(.bss); }
    .main_801AE3C0 0x801AE3C0 : AT(0x00089AC0) { build/asm/data/main_801AE3C0.bin.o(.data); }
    .main_801AE59C 0x801AE59C : AT(0x00089C9C) { FILL(0x00000000); build/asm/main_801AE59C.s.o(.text); build/asm/main_801AE59C.s.o(.rodata); build/asm/main_801AE59C.s.o(.data); }
    .main_801AE59C_bss (NOLOAD) : { build/asm/main_801AE59C.s.o(.bss); }
    .main_801AE5A0 0x801AE5A0 : AT(0x00089CA0) { build/asm/data/main_801AE5A0.bin.o(.data); }
    .main_801B1744 0x801B1744 : AT(0x0008CE44) { FILL(0x00000000); build/asm/main_801B1744.s.o(.text); build/asm/main_801B1744.s.o(.rodata); build/asm/main_801B1744.s.o(.data); }
    .main_801B1744_bss (NOLOAD) : { build/asm/main_801B1744.s.o(.bss); }
    .main_801B1794 0x801B1794 : AT(0x0008CE94) { build/asm/data/main_801B1794.bin.o(.data); }
    .main_801B1B68 0x801B1B68 : AT(0x0008D268) { FILL(0x00000000); build/asm/main_801B1B68.s.o(.text); build/asm/main_801B1B68.s.o(.rodata); build/asm/main_801B1B68.s.o(.data); }
    .main_801B1B68_bss (NOLOAD) : { build/asm/main_801B1B68.s.o(.bss); }
    .main_801B1BB8 0x801B1BB8 : AT(0x0008D2B8) { build/asm/data/main_801B1BB8.bin.o(.data); }
    .main_801B46C0 0x801B46C0 : AT(0x0008FDC0) { FILL(0x00000000); build/asm/main_801B46C0.s.o(.text); build/asm/main_801B46C0.s.o(.rodata); build/asm/main_801B46C0.s.o(.data); }
    .main_801B46C0_bss (NOLOAD) : { build/asm/main_801B46C0.s.o(.bss); }
    .main_801B4D28 0x801B4D28 : AT(0x00090428) { build/asm/data/main_801B4D28.bin.o(.data); }
    .main_801B5228 0x801B5228 : AT(0x00090928) { FILL(0x00000000); build/asm/main_801B5228.s.o(.text); build/asm/main_801B5228.s.o(.rodata); build/asm/main_801B5228.s.o(.data); }
    .main_801B5228_bss (NOLOAD) : { build/asm/main_801B5228.s.o(.bss); }
    .main_801B5250 0x801B5250 : AT(0x00090950) { build/asm/data/main_801B5250.bin.o(.data); }
    .main_801B56D8 0x801B56D8 : AT(0x00090DD8) { FILL(0x00000000); build/asm/main_801B56D8.s.o(.text); build/asm/main_801B56D8.s.o(.rodata); build/asm/main_801B56D8.s.o(.data); }
    .main_801B56D8_bss (NOLOAD) : { build/asm/main_801B56D8.s.o(.bss); }
    .main_801B5710 0x801B5710 : AT(0x00090E10) { build/asm/data/main_801B5710.bin.o(.data); }
    .main_801B6A64 0x801B6A64 : AT(0x00092164) { FILL(0x00000000); build/asm/main_801B6A64.s.o(.text); build/asm/main_801B6A64.s.o(.rodata); build/asm/main_801B6A64.s.o(.data); }
    .main_801B6A64_bss (NOLOAD) : { build/asm/main_801B6A64.s.o(.bss); }
    .main_801B6FF4 0x801B6FF4 : AT(0x000926F4) { build/asm/data/main_801B6FF4.bin.o(.data); }
    .main_801B71E0 0x801B71E0 : AT(0x000928E0) { FILL(0x00000000); build/asm/main_801B71E0.s.o(.text); build/asm/main_801B71E0.s.o(.rodata); build/asm/main_801B71E0.s.o(.data); }
    .main_801B71E0_bss (NOLOAD) : { build/asm/main_801B71E0.s.o(.bss); }
    .main_801B8564 0x801B8564 : AT(0x00093C64) { build/asm/data/main_801B8564.bin.o(.data); }
    .main_801B9B54 0x801B9B54 : AT(0x00095254) { FILL(0x00000000); build/asm/main_801B9B54.s.o(.text); build/asm/main_801B9B54.s.o(.rodata); build/asm/main_801B9B54.s.o(.data); }
    .main_801B9B54_bss (NOLOAD) : { build/asm/main_801B9B54.s.o(.bss); }
    .main_801B9BE4 0x801B9BE4 : AT(0x000952E4) { build/asm/data/main_801B9BE4.bin.o(.data); }
    .main_801BA014 0x801BA014 : AT(0x00095714) { FILL(0x00000000); build/asm/main_801BA014.s.o(.text); build/asm/main_801BA014.s.o(.rodata); build/asm/main_801BA014.s.o(.data); }
    .main_801BA014_bss (NOLOAD) : { build/asm/main_801BA014.s.o(.bss); }
    .main_801BA074 0x801BA074 : AT(0x00095774) { build/asm/data/main_801BA074.bin.o(.data); }
    .main_801BA60C 0x801BA60C : AT(0x00095D0C) { FILL(0x00000000); build/asm/main_801BA60C.s.o(.text); build/asm/main_801BA60C.s.o(.rodata); build/asm/main_801BA60C.s.o(.data); }
    .main_801BA60C_bss (NOLOAD) : { build/asm/main_801BA60C.s.o(.bss); }
    .main_801BBB00 0x801BBB00 : AT(0x00097200) { build/asm/data/main_801BBB00.bin.o(.data); }
    .main_801BCBC0 0x801BCBC0 : AT(0x000982C0) { FILL(0x00000000); build/asm/main_801BCBC0.s.o(.text); build/asm/main_801BCBC0.s.o(.rodata); build/asm/main_801BCBC0.s.o(.data); }
    .main_801BCBC0_bss (NOLOAD) : { build/asm/main_801BCBC0.s.o(.bss); }
    .main_801BCD50 0x801BCD50 : AT(0x00098450) { build/asm/data/main_801BCD50.bin.o(.data); }
    .main_801BCEB0 0x801BCEB0 : AT(0x000985B0) { FILL(0x00000000); build/asm/main_801BCEB0.s.o(.text); build/asm/main_801BCEB0.s.o(.rodata); build/asm/main_801BCEB0.s.o(.data); }
    .main_801BCEB0_bss (NOLOAD) : { build/asm/main_801BCEB0.s.o(.bss); }
    .main_801BCF40 0x801BCF40 : AT(0x00098640) { build/asm/data/main_801BCF40.bin.o(.data); }
    .main_801BCFE0 0x801BCFE0 : AT(0x000986E0) { FILL(0x00000000); build/asm/main_801BCFE0.s.o(.text); build/asm/main_801BCFE0.s.o(.rodata); build/asm/main_801BCFE0.s.o(.data); }
    .main_801BCFE0_bss (NOLOAD) : { build/asm/main_801BCFE0.s.o(.bss); }
    .main_801BCFF0 0x801BCFF0 : AT(0x000986F0) { build/asm/data/main_801BCFF0.bin.o(.data); }
    .main_801BE3FC 0x801BE3FC : AT(0x00099AFC) { FILL(0x00000000); build/asm/main_801BE3FC.s.o(.text); build/asm/main_801BE3FC.s.o(.rodata); build/asm/main_801BE3FC.s.o(.data); }
    .main_801BE3FC_bss (NOLOAD) : { build/asm/main_801BE3FC.s.o(.bss); }
    .main_801BE46C 0x801BE46C : AT(0x00099B6C) { build/asm/data/main_801BE46C.bin.o(.data); }
    .main_801BE65C 0x801BE65C : AT(0x00099D5C) { FILL(0x00000000); build/asm/main_801BE65C.s.o(.text); build/asm/main_801BE65C.s.o(.rodata); build/asm/main_801BE65C.s.o(.data); }
    .main_801BE65C_bss (NOLOAD) : { build/asm/main_801BE65C.s.o(.bss); }
    .main_801BEA04 0x801BEA04 : AT(0x0009A104) { build/asm/data/main_801BEA04.bin.o(.data); }
    .main_801BEF5C 0x801BEF5C : AT(0x0009A65C) { FILL(0x00000000); build/asm/main_801BEF5C.s.o(.text); build/asm/main_801BEF5C.s.o(.rodata); build/asm/main_801BEF5C.s.o(.data); }
    .main_801BEF5C_bss (NOLOAD) : { build/asm/main_801BEF5C.s.o(.bss); }
    .main_801BEF74 0x801BEF74 : AT(0x0009A674) { build/asm/data/main_801BEF74.bin.o(.data); }
    .main_801C4924 0x801C4924 : AT(0x000A0024) { FILL(0x00000000); build/asm/main_801C4924.s.o(.text); build/asm/main_801C4924.s.o(.rodata); build/asm/main_801C4924.s.o(.data); }
    .main_801C4924_bss (NOLOAD) : { build/asm/main_801C4924.s.o(.bss); }
    .main_801C5574 0x801C5574 : AT(0x000A0C74) { build/asm/data/main_801C5574.bin.o(.data); }
    .main_801C5920 0x801C5920 : AT(0x000A1020) { FILL(0x00000000); build/asm/main_801C5920.s.o(.text); build/asm/main_801C5920.s.o(.rodata); build/asm/main_801C5920.s.o(.data); }
    .main_801C5920_bss (NOLOAD) : { build/asm/main_801C5920.s.o(.bss); }
    .main_801C5974 0x801C5974 : AT(0x000A1074) { build/asm/data/main_801C5974.bin.o(.data); }
    .main_801D00A0 0x801D00A0 : AT(0x000AB7A0) { FILL(0x00000000); build/asm/main_801D00A0.s.o(.text); build/asm/main_801D00A0.s.o(.rodata); build/asm/main_801D00A0.s.o(.data); }
    .main_801D00A0_bss (NOLOAD) : { build/asm/main_801D00A0.s.o(.bss); }
    .main_801D00B0 0x801D00B0 : AT(0x000AB7B0) { build/asm/data/main_801D00B0.bin.o(.data); }
    .main_801D0160 0x801D0160 : AT(0x000AB860) { FILL(0x00000000); build/asm/main_801D0160.s.o(.text); build/asm/main_801D0160.s.o(.rodata); build/asm/main_801D0160.s.o(.data); }
    .main_801D0160_bss (NOLOAD) : { build/asm/main_801D0160.s.o(.bss); }
    .main_801D0170 0x801D0170 : AT(0x000AB870) { build/asm/data/main_801D0170.bin.o(.data); }
    .main_801D0190 0x801D0190 : AT(0x000AB890) { FILL(0x00000000); build/asm/main_801D0190.s.o(.text); build/asm/main_801D0190.s.o(.rodata); build/asm/main_801D0190.s.o(.data); }
    .main_801D0190_bss (NOLOAD) : { build/asm/main_801D0190.s.o(.bss); }
    .main_801D01C0 0x801D01C0 : AT(0x000AB8C0) { build/asm/data/main_801D01C0.bin.o(.data); }
    .main_801D0620 0x801D0620 : AT(0x000ABD20) { FILL(0x00000000); build/asm/main_801D0620.s.o(.text); build/asm/main_801D0620.s.o(.rodata); build/asm/main_801D0620.s.o(.data); }
    .main_801D0620_bss (NOLOAD) : { build/asm/main_801D0620.s.o(.bss); }
    .main_801D0624 0x801D0624 : AT(0x000ABD24) { build/asm/data/main_801D0624.bin.o(.data); }
    .main_801D06E0 0x801D06E0 : AT(0x000ABDE0) { FILL(0x00000000); build/asm/main_801D06E0.s.o(.text); build/asm/main_801D06E0.s.o(.rodata); build/asm/main_801D06E0.s.o(.data); }
    .main_801D06E0_bss (NOLOAD) : { build/asm/main_801D06E0.s.o(.bss); }
    .main_801D06E4 0x801D06E4 : AT(0x000ABDE4) { build/asm/data/main_801D06E4.bin.o(.data); }
    .main_801D0870 0x801D0870 : AT(0x000ABF70) { FILL(0x00000000); build/asm/main_801D0870.s.o(.text); build/asm/main_801D0870.s.o(.rodata); build/asm/main_801D0870.s.o(.data); }
    .main_801D0870_bss (NOLOAD) : { build/asm/main_801D0870.s.o(.bss); }
    .main_801D0E84 0x801D0E84 : AT(0x000AC584) { build/asm/data/main_801D0E84.bin.o(.data); }
    .main_801D0EE4 0x801D0EE4 : AT(0x000AC5E4) { FILL(0x00000000); build/asm/main_801D0EE4.s.o(.text); build/asm/main_801D0EE4.s.o(.rodata); build/asm/main_801D0EE4.s.o(.data); }
    .main_801D0EE4_bss (NOLOAD) : { build/asm/main_801D0EE4.s.o(.bss); }
    .main_801D0F64 0x801D0F64 : AT(0x000AC664) { build/asm/data/main_801D0F64.bin.o(.data); }
    .main_801D0FE4 0x801D0FE4 : AT(0x000AC6E4) { FILL(0x00000000); build/asm/main_801D0FE4.s.o(.text); build/asm/main_801D0FE4.s.o(.rodata); build/asm/main_801D0FE4.s.o(.data); }
    .main_801D0FE4_bss (NOLOAD) : { build/asm/main_801D0FE4.s.o(.bss); }
    .main_801D1564 0x801D1564 : AT(0x000ACC64) { build/asm/data/main_801D1564.bin.o(.data); }
    .main_801D15B4 0x801D15B4 : AT(0x000ACCB4) { FILL(0x00000000); build/asm/main_801D15B4.s.o(.text); build/asm/main_801D15B4.s.o(.rodata); build/asm/main_801D15B4.s.o(.data); }
    .main_801D15B4_bss (NOLOAD) : { build/asm/main_801D15B4.s.o(.bss); }
    .main_801D1774 0x801D1774 : AT(0x000ACE74) { build/asm/data/main_801D1774.bin.o(.data); }
    .main_801D17B4 0x801D17B4 : AT(0x000ACEB4) { FILL(0x00000000); build/asm/main_801D17B4.s.o(.text); build/asm/main_801D17B4.s.o(.rodata); build/asm/main_801D17B4.s.o(.data); }
    .main_801D17B4_bss (NOLOAD) : { build/asm/main_801D17B4.s.o(.bss); }
    .main_801D1874 0x801D1874 : AT(0x000ACF74) { build/asm/data/main_801D1874.bin.o(.data); }
    .main_801D1A2C 0x801D1A2C : AT(0x000AD12C) { FILL(0x00000000); build/asm/main_801D1A2C.s.o(.text); build/asm/main_801D1A2C.s.o(.rodata); build/asm/main_801D1A2C.s.o(.data); }
    .main_801D1A2C_bss (NOLOAD) : { build/asm/main_801D1A2C.s.o(.bss); }
    .main_801D1BFC 0x801D1BFC : AT(0x000AD2FC) { build/asm/data/main_801D1BFC.bin.o(.data); }
    .main_801D2288 0x801D2288 : AT(0x000AD988) { FILL(0x00000000); build/asm/main_801D2288.s.o(.text); build/asm/main_801D2288.s.o(.rodata); build/asm/main_801D2288.s.o(.data); }
    .main_801D2288_bss (NOLOAD) : { build/asm/main_801D2288.s.o(.bss); }
    .main_801D22D0 0x801D22D0 : AT(0x000AD9D0) { build/asm/data/main_801D22D0.bin.o(.data); }
    .main_801D2440 0x801D2440 : AT(0x000ADB40) { FILL(0x00000000); build/asm/main_801D2440.s.o(.text); build/asm/main_801D2440.s.o(.rodata); build/asm/main_801D2440.s.o(.data); }
    .main_801D2440_bss (NOLOAD) : { build/asm/main_801D2440.s.o(.bss); }
    .main_801D26B8 0x801D26B8 : AT(0x000ADDB8) { build/asm/data/main_801D26B8.bin.o(.data); }
    .main_801D286C 0x801D286C : AT(0x000ADF6C) { FILL(0x00000000); build/asm/main_801D286C.s.o(.text); build/asm/main_801D286C.s.o(.rodata); build/asm/main_801D286C.s.o(.data); }
    .main_801D286C_bss (NOLOAD) : { build/asm/main_801D286C.s.o(.bss); }
    .main_801D2BE8 0x801D2BE8 : AT(0x000AE2E8) { build/asm/data/main_801D2BE8.bin.o(.data); }
    .main_801D2D68 0x801D2D68 : AT(0x000AE468) { FILL(0x00000000); build/asm/main_801D2D68.s.o(.text); build/asm/main_801D2D68.s.o(.rodata); build/asm/main_801D2D68.s.o(.data); }
    .main_801D2D68_bss (NOLOAD) : { build/asm/main_801D2D68.s.o(.bss); }
    .main_801D2E5C 0x801D2E5C : AT(0x000AE55C) { build/asm/data/main_801D2E5C.bin.o(.data); }
    .main_801D3174 0x801D3174 : AT(0x000AE874) { FILL(0x00000000); build/asm/main_801D3174.s.o(.text); build/asm/main_801D3174.s.o(.rodata); build/asm/main_801D3174.s.o(.data); }
    .main_801D3174_bss (NOLOAD) : { build/asm/main_801D3174.s.o(.bss); }
    .main_801D3B6C 0x801D3B6C : AT(0x000AF26C) { build/asm/data/main_801D3B6C.bin.o(.data); }
    .main_801D4BB0 0x801D4BB0 : AT(0x000B02B0) { FILL(0x00000000); build/asm/main_801D4BB0.s.o(.text); build/asm/main_801D4BB0.s.o(.rodata); build/asm/main_801D4BB0.s.o(.data); }
    .main_801D4BB0_bss (NOLOAD) : { build/asm/main_801D4BB0.s.o(.bss); }
    .main_801D4DE0 0x801D4DE0 : AT(0x000B04E0) { build/asm/data/main_801D4DE0.bin.o(.data); }
    .main_801D4F28 0x801D4F28 : AT(0x000B0628) { FILL(0x00000000); build/asm/main_801D4F28.s.o(.text); build/asm/main_801D4F28.s.o(.rodata); build/asm/main_801D4F28.s.o(.data); }
    .main_801D4F28_bss (NOLOAD) : { build/asm/main_801D4F28.s.o(.bss); }
    .main_801D5178 0x801D5178 : AT(0x000B0878) { build/asm/data/main_801D5178.bin.o(.data); }
    .main_801D6758 0x801D6758 : AT(0x000B1E58) { FILL(0x00000000); build/asm/main_801D6758.s.o(.text); build/asm/main_801D6758.s.o(.rodata); build/asm/main_801D6758.s.o(.data); }
    .main_801D6758_bss (NOLOAD) : { build/asm/main_801D6758.s.o(.bss); }
    .main_801D6A18 0x801D6A18 : AT(0x000B2118) { build/asm/data/main_801D6A18.bin.o(.data); }
    .main_801D8F78 0x801D8F78 : AT(0x000B4678) { FILL(0x00000000); build/asm/main_801D8F78.s.o(.text); build/asm/main_801D8F78.s.o(.rodata); build/asm/main_801D8F78.s.o(.data); }
    .main_801D8F78_bss (NOLOAD) : { build/asm/main_801D8F78.s.o(.bss); }
    .main_801D9558 0x801D9558 : AT(0x000B4C58) { build/asm/data/main_801D9558.bin.o(.data); }
    .main_801D9598 0x801D9598 : AT(0x000B4C98) { FILL(0x00000000); build/asm/main_801D9598.s.o(.text); build/asm/main_801D9598.s.o(.rodata); build/asm/main_801D9598.s.o(.data); }
    .main_801D9598_bss (NOLOAD) : { build/asm/main_801D9598.s.o(.bss); }
    .main_801D9618 0x801D9618 : AT(0x000B4D18) { build/asm/data/main_801D9618.bin.o(.data); }
    .main_801D9678 0x801D9678 : AT(0x000B4D78) { FILL(0x00000000); build/asm/main_801D9678.s.o(.text); build/asm/main_801D9678.s.o(.rodata); build/asm/main_801D9678.s.o(.data); }
    .main_801D9678_bss (NOLOAD) : { build/asm/main_801D9678.s.o(.bss); }
    .main_801DA77C 0x801DA77C : AT(0x000B5E7C) { FILL(0x00000000); build/asm/main_801DA77C.s.o(.text); build/asm/main_801DA77C.s.o(.rodata); build/asm/main_801DA77C.s.o(.data); }
    .main_801DA77C_bss (NOLOAD) : { build/asm/main_801DA77C.s.o(.bss); }
    .main_801DB48C 0x801DB48C : AT(0x000B6B8C) { build/asm/data/main_801DB48C.bin.o(.data); }
    .main_801DC7AC 0x801DC7AC : AT(0x000B7EAC) { FILL(0x00000000); build/asm/main_801DC7AC.s.o(.text); build/asm/main_801DC7AC.s.o(.rodata); build/asm/main_801DC7AC.s.o(.data); }
    .main_801DC7AC_bss (NOLOAD) : { build/asm/main_801DC7AC.s.o(.bss); }
    .main_801DCE4C 0x801DCE4C : AT(0x000B854C) { build/asm/data/main_801DCE4C.bin.o(.data); }
    .main_801DD24C 0x801DD24C : AT(0x000B894C) { FILL(0x00000000); build/asm/main_801DD24C.s.o(.text); build/asm/main_801DD24C.s.o(.rodata); build/asm/main_801DD24C.s.o(.data); }
    .main_801DD24C_bss (NOLOAD) : { build/asm/main_801DD24C.s.o(.bss); }
    .main_801DD26C 0x801DD26C : AT(0x000B896C) { build/asm/data/main_801DD26C.bin.o(.data); }
    .main_801DD30C 0x801DD30C : AT(0x000B8A0C) { FILL(0x00000000); build/asm/main_801DD30C.s.o(.text); build/asm/main_801DD30C.s.o(.rodata); build/asm/main_801DD30C.s.o(.data); }
    .main_801DD30C_bss (NOLOAD) : { build/asm/main_801DD30C.s.o(.bss); }
    .main_801DDD8C 0x801DDD8C : AT(0x000B948C) { build/asm/data/main_801DDD8C.bin.o(.data); }
    .main_801DF260 0x801DF260 : AT(0x000BA960) { FILL(0x00000000); build/asm/main_801DF260.s.o(.text); build/asm/main_801DF260.s.o(.rodata); build/asm/main_801DF260.s.o(.data); }
    .main_801DF260_bss (NOLOAD) : { build/asm/main_801DF260.s.o(.bss); }
    .main_801DF410 0x801DF410 : AT(0x000BAB10) { build/asm/data/main_801DF410.bin.o(.data); }
    .main_801E05A4 0x801E05A4 : AT(0x000BBCA4) { FILL(0x00000000); build/asm/main_801E05A4.s.o(.text); build/asm/main_801E05A4.s.o(.rodata); build/asm/main_801E05A4.s.o(.data); }
    .main_801E05A4_bss (NOLOAD) : { build/asm/main_801E05A4.s.o(.bss); }
    .main_801E05DC 0x801E05DC : AT(0x000BBCDC) { build/asm/data/main_801E05DC.bin.o(.data); }
    .main_801E09EC 0x801E09EC : AT(0x000BC0EC) { FILL(0x00000000); build/asm/main_801E09EC.s.o(.text); build/asm/main_801E09EC.s.o(.rodata); build/asm/main_801E09EC.s.o(.data); }
    .main_801E09EC_bss (NOLOAD) : { build/asm/main_801E09EC.s.o(.bss); }
    .main_801E0C28 0x801E0C28 : AT(0x000BC328) { build/asm/data/main_801E0C28.bin.o(.data); }
    .main_801E0C6C 0x801E0C6C : AT(0x000BC36C) { FILL(0x00000000); build/asm/main_801E0C6C.s.o(.text); build/asm/main_801E0C6C.s.o(.rodata); build/asm/main_801E0C6C.s.o(.data); }
    .main_801E0C6C_bss (NOLOAD) : { build/asm/main_801E0C6C.s.o(.bss); }
    .main_801E15BC 0x801E15BC : AT(0x000BCCBC) { build/asm/data/main_801E15BC.bin.o(.data); }
    .main_801E183C 0x801E183C : AT(0x000BCF3C) { FILL(0x00000000); build/asm/main_801E183C.s.o(.text); build/asm/main_801E183C.s.o(.rodata); build/asm/main_801E183C.s.o(.data); }
    .main_801E183C_bss (NOLOAD) : { build/asm/main_801E183C.s.o(.bss); }
    .main_801E1B9C 0x801E1B9C : AT(0x000BD29C) { build/asm/data/main_801E1B9C.bin.o(.data); }
    .main_801E2A18 0x801E2A18 : AT(0x000BE118) { FILL(0x00000000); build/asm/main_801E2A18.s.o(.text); build/asm/main_801E2A18.s.o(.rodata); build/asm/main_801E2A18.s.o(.data); }
    .main_801E2A18_bss (NOLOAD) : { build/asm/main_801E2A18.s.o(.bss); }
    .main_801E2D20 0x801E2D20 : AT(0x000BE420) { build/asm/data/main_801E2D20.bin.o(.data); }
    .main_801E3188 0x801E3188 : AT(0x000BE888) { FILL(0x00000000); build/asm/main_801E3188.s.o(.text); build/asm/main_801E3188.s.o(.rodata); build/asm/main_801E3188.s.o(.data); }
    .main_801E3188_bss (NOLOAD) : { build/asm/main_801E3188.s.o(.bss); }
    .main_801E3500 0x801E3500 : AT(0x000BEC00) { build/asm/data/main_801E3500.bin.o(.data); }
    .main_801E37A4 0x801E37A4 : AT(0x000BEEA4) { FILL(0x00000000); build/asm/main_801E37A4.s.o(.text); build/asm/main_801E37A4.s.o(.rodata); build/asm/main_801E37A4.s.o(.data); }
    .main_801E37A4_bss (NOLOAD) : { build/asm/main_801E37A4.s.o(.bss); }
    .main_801E3904 0x801E3904 : AT(0x000BF004) { build/asm/data/main_801E3904.bin.o(.data); }
    .main_801E3CF4 0x801E3CF4 : AT(0x000BF3F4) { FILL(0x00000000); build/asm/main_801E3CF4.s.o(.text); build/asm/main_801E3CF4.s.o(.rodata); build/asm/main_801E3CF4.s.o(.data); }
    .main_801E3CF4_bss (NOLOAD) : { build/asm/main_801E3CF4.s.o(.bss); }
    .main_801E3E84 0x801E3E84 : AT(0x000BF584) { build/asm/data/main_801E3E84.bin.o(.data); }
    .main_801E50A8 0x801E50A8 : AT(0x000C07A8) { FILL(0x00000000); build/asm/main_801E50A8.s.o(.text); build/asm/main_801E50A8.s.o(.rodata); build/asm/main_801E50A8.s.o(.data); }
    .main_801E50A8_bss (NOLOAD) : { build/asm/main_801E50A8.s.o(.bss); }
    .main_801E52E8 0x801E52E8 : AT(0x000C09E8) { build/asm/data/main_801E52E8.bin.o(.data); }
    .main_801E571C 0x801E571C : AT(0x000C0E1C) { FILL(0x00000000); build/asm/main_801E571C.s.o(.text); build/asm/main_801E571C.s.o(.rodata); build/asm/main_801E571C.s.o(.data); }
    .main_801E571C_bss (NOLOAD) : { build/asm/main_801E571C.s.o(.bss); }
    .main_801E572C 0x801E572C : AT(0x000C0E2C) { build/asm/data/main_801E572C.bin.o(.data); }
    .main_801E7944 0x801E7944 : AT(0x000C3044) { FILL(0x00000000); build/asm/main_801E7944.s.o(.text); build/asm/main_801E7944.s.o(.rodata); build/asm/main_801E7944.s.o(.data); }
    .main_801E7944_bss (NOLOAD) : { build/asm/main_801E7944.s.o(.bss); }
    .main_801E8F48 0x801E8F48 : AT(0x000C4648) { build/asm/data/main_801E8F48.bin.o(.data); }
    .main_801E92D4 0x801E92D4 : AT(0x000C49D4) { FILL(0x00000000); build/asm/main_801E92D4.s.o(.text); build/asm/main_801E92D4.s.o(.rodata); build/asm/main_801E92D4.s.o(.data); }
    .main_801E92D4_bss (NOLOAD) : { build/asm/main_801E92D4.s.o(.bss); }
    .main_801E9358 0x801E9358 : AT(0x000C4A58) { build/asm/data/main_801E9358.bin.o(.data); }
    .main_801E9A24 0x801E9A24 : AT(0x000C5124) { FILL(0x00000000); build/asm/main_801E9A24.s.o(.text); build/asm/main_801E9A24.s.o(.rodata); build/asm/main_801E9A24.s.o(.data); }
    .main_801E9A24_bss (NOLOAD) : { build/asm/main_801E9A24.s.o(.bss); }
    .main_801E9A4C 0x801E9A4C : AT(0x000C514C) { build/asm/data/main_801E9A4C.bin.o(.data); }
    .main_801EA424 0x801EA424 : AT(0x000C5B24) { FILL(0x00000000); build/asm/main_801EA424.s.o(.text); build/asm/main_801EA424.s.o(.rodata); build/asm/main_801EA424.s.o(.data); }
    .main_801EA424_bss (NOLOAD) : { build/asm/main_801EA424.s.o(.bss); }
    .main_801EA94C 0x801EA94C : AT(0x000C604C) { build/asm/data/main_801EA94C.bin.o(.data); }
    .main_801EACDC 0x801EACDC : AT(0x000C63DC) { FILL(0x00000000); build/asm/main_801EACDC.s.o(.text); build/asm/main_801EACDC.s.o(.rodata); build/asm/main_801EACDC.s.o(.data); }
    .main_801EACDC_bss (NOLOAD) : { build/asm/main_801EACDC.s.o(.bss); }
    .main_801EB2CC 0x801EB2CC : AT(0x000C69CC) { build/asm/data/main_801EB2CC.bin.o(.data); }
    .main_801EB39C 0x801EB39C : AT(0x000C6A9C) { FILL(0x00000000); build/asm/main_801EB39C.s.o(.text); build/asm/main_801EB39C.s.o(.rodata); build/asm/main_801EB39C.s.o(.data); }
    .main_801EB39C_bss (NOLOAD) : { build/asm/main_801EB39C.s.o(.bss); }
    .main_801EB63C 0x801EB63C : AT(0x000C6D3C) { build/asm/data/main_801EB63C.bin.o(.data); }
    .main_801ECDF0 0x801ECDF0 : AT(0x000C84F0) { FILL(0x00000000); build/asm/main_801ECDF0.s.o(.text); build/asm/main_801ECDF0.s.o(.rodata); build/asm/main_801ECDF0.s.o(.data); }
    .main_801ECDF0_bss (NOLOAD) : { build/asm/main_801ECDF0.s.o(.bss); }
    .main_801ED0AC 0x801ED0AC : AT(0x000C87AC) { build/asm/data/main_801ED0AC.bin.o(.data); }
    .main_801ED6C8 0x801ED6C8 : AT(0x000C8DC8) { FILL(0x00000000); build/asm/main_801ED6C8.s.o(.text); build/asm/main_801ED6C8.s.o(.rodata); build/asm/main_801ED6C8.s.o(.data); }
    .main_801ED6C8_bss (NOLOAD) : { build/asm/main_801ED6C8.s.o(.bss); }
    .main_801ED76C 0x801ED76C : AT(0x000C8E6C) { build/asm/data/main_801ED76C.bin.o(.data); }
    .main_801EE06C 0x801EE06C : AT(0x000C976C) { FILL(0x00000000); build/asm/main_801EE06C.s.o(.text); build/asm/main_801EE06C.s.o(.rodata); build/asm/main_801EE06C.s.o(.data); }
    .main_801EE06C_bss (NOLOAD) : { build/asm/main_801EE06C.s.o(.bss); }
    .main_801EE16C 0x801EE16C : AT(0x000C986C) { build/asm/data/main_801EE16C.bin.o(.data); }
    .main_801EE7BC 0x801EE7BC : AT(0x000C9EBC) { FILL(0x00000000); build/asm/main_801EE7BC.s.o(.text); build/asm/main_801EE7BC.s.o(.rodata); build/asm/main_801EE7BC.s.o(.data); }
    .main_801EE7BC_bss (NOLOAD) : { build/asm/main_801EE7BC.s.o(.bss); }
    .main_801EEAD0 0x801EEAD0 : AT(0x000CA1D0) { build/asm/data/main_801EEAD0.bin.o(.data); }
    .main_801EEB80 0x801EEB80 : AT(0x000CA280) { FILL(0x00000000); build/asm/main_801EEB80.s.o(.text); build/asm/main_801EEB80.s.o(.rodata); build/asm/main_801EEB80.s.o(.data); }
    .main_801EEB80_bss (NOLOAD) : { build/asm/main_801EEB80.s.o(.bss); }
    .main_801EFB74 0x801EFB74 : AT(0x000CB274) { build/asm/data/main_801EFB74.bin.o(.data); }
    .main_801EFC40 0x801EFC40 : AT(0x000CB340) { FILL(0x00000000); build/asm/main_801EFC40.s.o(.text); build/asm/main_801EFC40.s.o(.rodata); build/asm/main_801EFC40.s.o(.data); }
    .main_801EFC40_bss (NOLOAD) : { build/asm/main_801EFC40.s.o(.bss); }
    .main_801F0264 0x801F0264 : AT(0x000CB964) { build/asm/data/main_801F0264.bin.o(.data); }
    .main_801F07BC 0x801F07BC : AT(0x000CBEBC) { FILL(0x00000000); build/asm/main_801F07BC.s.o(.text); build/asm/main_801F07BC.s.o(.rodata); build/asm/main_801F07BC.s.o(.data); }
    .main_801F07BC_bss (NOLOAD) : { build/asm/main_801F07BC.s.o(.bss); }
    .main_801F0DE0 0x801F0DE0 : AT(0x000CC4E0) { build/asm/data/main_801F0DE0.bin.o(.data); }
    .main_801F131C 0x801F131C : AT(0x000CCA1C) { FILL(0x00000000); build/asm/main_801F131C.s.o(.text); build/asm/main_801F131C.s.o(.rodata); build/asm/main_801F131C.s.o(.data); }
    .main_801F131C_bss (NOLOAD) : { build/asm/main_801F131C.s.o(.bss); }
    .main_801F148C 0x801F148C : AT(0x000CCB8C) { build/asm/data/main_801F148C.bin.o(.data); }
    .main_801F17EC 0x801F17EC : AT(0x000CCEEC) { FILL(0x00000000); build/asm/main_801F17EC.s.o(.text); build/asm/main_801F17EC.s.o(.rodata); build/asm/main_801F17EC.s.o(.data); }
    .main_801F17EC_bss (NOLOAD) : { build/asm/main_801F17EC.s.o(.bss); }
    .main_801F19C0 0x801F19C0 : AT(0x000CD0C0) { build/asm/data/main_801F19C0.bin.o(.data); }
    .main_801F222C 0x801F222C : AT(0x000CD92C) { FILL(0x00000000); build/asm/main_801F222C.s.o(.text); build/asm/main_801F222C.s.o(.rodata); build/asm/main_801F222C.s.o(.data); }
    .main_801F222C_bss (NOLOAD) : { build/asm/main_801F222C.s.o(.bss); }
    .main_801F228C 0x801F228C : AT(0x000CD98C) { build/asm/data/main_801F228C.bin.o(.data); }
    .main_801F251C 0x801F251C : AT(0x000CDC1C) { FILL(0x00000000); build/asm/main_801F251C.s.o(.text); build/asm/main_801F251C.s.o(.rodata); build/asm/main_801F251C.s.o(.data); }
    .main_801F251C_bss (NOLOAD) : { build/asm/main_801F251C.s.o(.bss); }
    .main_801F26EC 0x801F26EC : AT(0x000CDDEC) { build/asm/data/main_801F26EC.bin.o(.data); }
    .main_801F2CCC 0x801F2CCC : AT(0x000CE3CC) { FILL(0x00000000); build/asm/main_801F2CCC.s.o(.text); build/asm/main_801F2CCC.s.o(.rodata); build/asm/main_801F2CCC.s.o(.data); }
    .main_801F2CCC_bss (NOLOAD) : { build/asm/main_801F2CCC.s.o(.bss); }
    .main_801F2F6C 0x801F2F6C : AT(0x000CE66C) { build/asm/data/main_801F2F6C.bin.o(.data); }
    .main_801F347C 0x801F347C : AT(0x000CEB7C) { FILL(0x00000000); build/asm/main_801F347C.s.o(.text); build/asm/main_801F347C.s.o(.rodata); build/asm/main_801F347C.s.o(.data); }
    .main_801F347C_bss (NOLOAD) : { build/asm/main_801F347C.s.o(.bss); }
    .main_801F38FC 0x801F38FC : AT(0x000CEFFC) { build/asm/data/main_801F38FC.bin.o(.data); }
    .main_801F39FC 0x801F39FC : AT(0x000CF0FC) { FILL(0x00000000); build/asm/main_801F39FC.s.o(.text); build/asm/main_801F39FC.s.o(.rodata); build/asm/main_801F39FC.s.o(.data); }
    .main_801F39FC_bss (NOLOAD) : { build/asm/main_801F39FC.s.o(.bss); }
    .main_801F40FC 0x801F40FC : AT(0x000CF7FC) { build/asm/data/main_801F40FC.bin.o(.data); }
    .main_801F41FC 0x801F41FC : AT(0x000CF8FC) { FILL(0x00000000); build/asm/main_801F41FC.s.o(.text); build/asm/main_801F41FC.s.o(.rodata); build/asm/main_801F41FC.s.o(.data); }
    .main_801F41FC_bss (NOLOAD) : { build/asm/main_801F41FC.s.o(.bss); }
    .main_801F49EC 0x801F49EC : AT(0x000D00EC) { build/asm/data/main_801F49EC.bin.o(.data); }
    .main_801F4A7C 0x801F4A7C : AT(0x000D017C) { FILL(0x00000000); build/asm/main_801F4A7C.s.o(.text); build/asm/main_801F4A7C.s.o(.rodata); build/asm/main_801F4A7C.s.o(.data); }
    .main_801F4A7C_bss (NOLOAD) : { build/asm/main_801F4A7C.s.o(.bss); }
    .main_801F54AC 0x801F54AC : AT(0x000D0BAC) { build/asm/data/main_801F54AC.bin.o(.data); }
    .main_801F54FC 0x801F54FC : AT(0x000D0BFC) { FILL(0x00000000); build/asm/main_801F54FC.s.o(.text); build/asm/main_801F54FC.s.o(.rodata); build/asm/main_801F54FC.s.o(.data); }
    .main_801F54FC_bss (NOLOAD) : { build/asm/main_801F54FC.s.o(.bss); }
    .main_801F5E8C 0x801F5E8C : AT(0x000D158C) { build/asm/data/main_801F5E8C.bin.o(.data); }
    .main_801F64EC 0x801F64EC : AT(0x000D1BEC) { FILL(0x00000000); build/asm/main_801F64EC.s.o(.text); build/asm/main_801F64EC.s.o(.rodata); build/asm/main_801F64EC.s.o(.data); }
    .main_801F64EC_bss (NOLOAD) : { build/asm/main_801F64EC.s.o(.bss); }
    .main_801F6EFC 0x801F6EFC : AT(0x000D25FC) { build/asm/data/main_801F6EFC.bin.o(.data); }
    .main_801F749C 0x801F749C : AT(0x000D2B9C) { FILL(0x00000000); build/asm/main_801F749C.s.o(.text); build/asm/main_801F749C.s.o(.rodata); build/asm/main_801F749C.s.o(.data); }
    .main_801F749C_bss (NOLOAD) : { build/asm/main_801F749C.s.o(.bss); }
    .main_801F77FC 0x801F77FC : AT(0x000D2EFC) { build/asm/data/main_801F77FC.bin.o(.data); }
    .main_801F840C 0x801F840C : AT(0x000D3B0C) { FILL(0x00000000); build/asm/main_801F840C.s.o(.text); build/asm/main_801F840C.s.o(.rodata); build/asm/main_801F840C.s.o(.data); }
    .main_801F840C_bss (NOLOAD) : { build/asm/main_801F840C.s.o(.bss); }
    .main_801F848C 0x801F848C : AT(0x000D3B8C) { build/asm/data/main_801F848C.bin.o(.data); }
    .main_801F84FC 0x801F84FC : AT(0x000D3BFC) { FILL(0x00000000); build/asm/main_801F84FC.s.o(.text); build/asm/main_801F84FC.s.o(.rodata); build/asm/main_801F84FC.s.o(.data); }
    .main_801F84FC_bss (NOLOAD) : { build/asm/main_801F84FC.s.o(.bss); }
    .main_801F85AC 0x801F85AC : AT(0x000D3CAC) { build/asm/data/main_801F85AC.bin.o(.data); }
    .main_801F861C 0x801F861C : AT(0x000D3D1C) { FILL(0x00000000); build/asm/main_801F861C.s.o(.text); build/asm/main_801F861C.s.o(.rodata); build/asm/main_801F861C.s.o(.data); }
    .main_801F861C_bss (NOLOAD) : { build/asm/main_801F861C.s.o(.bss); }
    .main_801F8914 0x801F8914 : AT(0x000D4014) { build/asm/data/main_801F8914.bin.o(.data); }
    .main_8020360C 0x8020360C : AT(0x000DED0C) { FILL(0x00000000); build/asm/main_8020360C.s.o(.text); build/asm/main_8020360C.s.o(.rodata); build/asm/main_8020360C.s.o(.data); }
    .main_8020360C_bss (NOLOAD) : { build/asm/main_8020360C.s.o(.bss); }
    .main_8020373C 0x8020373C : AT(0x000DEE3C) { build/asm/data/main_8020373C.bin.o(.data); }
    .main_80204178 0x80204178 : AT(0x000DF878) { FILL(0x00000000); build/asm/main_80204178.s.o(.text); build/asm/main_80204178.s.o(.rodata); build/asm/main_80204178.s.o(.data); }
    .main_80204178_bss (NOLOAD) : { build/asm/main_80204178.s.o(.bss); }
    .main_80204A5C 0x80204A5C : AT(0x000E015C) { build/asm/data/main_80204A5C.bin.o(.data); }
    .main_80204BC4 0x80204BC4 : AT(0x000E02C4) { FILL(0x00000000); build/asm/main_80204BC4.s.o(.text); build/asm/main_80204BC4.s.o(.rodata); build/asm/main_80204BC4.s.o(.data); }
    .main_80204BC4_bss (NOLOAD) : { build/asm/main_80204BC4.s.o(.bss); }
    .main_80204C74 0x80204C74 : AT(0x000E0374) { build/asm/data/main_80204C74.bin.o(.data); }
    .main_802053C8 0x802053C8 : AT(0x000E0AC8) { FILL(0x00000000); build/asm/main_802053C8.s.o(.text); build/asm/main_802053C8.s.o(.rodata); build/asm/main_802053C8.s.o(.data); }
    .main_802053C8_bss (NOLOAD) : { build/asm/main_802053C8.s.o(.bss); }
    .main_8020542C 0x8020542C : AT(0x000E0B2C) { FILL(0x00000000); build/asm/main_8020542C.s.o(.text); build/asm/main_8020542C.s.o(.rodata); build/asm/main_8020542C.s.o(.data); }
    .main_8020542C_bss (NOLOAD) : { build/asm/main_8020542C.s.o(.bss); }
    .main_802056A0 0x802056A0 : AT(0x000E0DA0) { build/asm/data/main_802056A0.bin.o(.data); }
    .main_802059A0 0x802059A0 : AT(0x000E10A0) { FILL(0x00000000); build/asm/main_802059A0.s.o(.text); build/asm/main_802059A0.s.o(.rodata); build/asm/main_802059A0.s.o(.data); }
    .main_802059A0_bss (NOLOAD) : { build/asm/main_802059A0.s.o(.bss); }
    .main_802059D0 0x802059D0 : AT(0x000E10D0) { build/asm/data/main_802059D0.bin.o(.data); }
    .main_80206D14 0x80206D14 : AT(0x000E2414) { FILL(0x00000000); build/asm/main_80206D14.s.o(.text); build/asm/main_80206D14.s.o(.rodata); build/asm/main_80206D14.s.o(.data); }
    .main_80206D14_bss (NOLOAD) : { build/asm/main_80206D14.s.o(.bss); }
    .main_80206F8C 0x80206F8C : AT(0x000E268C) { build/asm/data/main_80206F8C.bin.o(.data); }
    .main_8020BAF0 0x8020BAF0 : AT(0x000E71F0) { FILL(0x00000000); build/asm/main_8020BAF0.s.o(.text); build/asm/main_8020BAF0.s.o(.rodata); build/asm/main_8020BAF0.s.o(.data); }
    .main_8020BAF0_bss (NOLOAD) : { build/asm/main_8020BAF0.s.o(.bss); }
    .main_8020BC1C 0x8020BC1C : AT(0x000E731C) { build/asm/data/main_8020BC1C.bin.o(.data); }
    .main_8020D884 0x8020D884 : AT(0x000E8F84) { FILL(0x00000000); build/asm/main_8020D884.s.o(.text); build/asm/main_8020D884.s.o(.rodata); build/asm/main_8020D884.s.o(.data); }
    .main_8020D884_bss (NOLOAD) : { build/asm/main_8020D884.s.o(.bss); }
    .main_8020E16C 0x8020E16C : AT(0x000E986C) { build/asm/data/main_8020E16C.bin.o(.data); }
    .main_8020ECA0 0x8020ECA0 : AT(0x000EA3A0) { FILL(0x00000000); build/asm/main_8020ECA0.s.o(.text); build/asm/main_8020ECA0.s.o(.rodata); build/asm/main_8020ECA0.s.o(.data); }
    .main_8020ECA0_bss (NOLOAD) : { build/asm/main_8020ECA0.s.o(.bss); }
    .main_8020EE38 0x8020EE38 : AT(0x000EA538) { build/asm/data/main_8020EE38.bin.o(.data); }
    .main_8020EEA0 0x8020EEA0 : AT(0x000EA5A0) { FILL(0x00000000); build/asm/main_8020EEA0.s.o(.text); build/asm/main_8020EEA0.s.o(.rodata); build/asm/main_8020EEA0.s.o(.data); }
    .main_8020EEA0_bss (NOLOAD) : { build/asm/main_8020EEA0.s.o(.bss); }
    .main_8020F31C 0x8020F31C : AT(0x000EAA1C) { build/asm/data/main_8020F31C.bin.o(.data); }
    .main_8020F83C 0x8020F83C : AT(0x000EAF3C) { FILL(0x00000000); build/asm/main_8020F83C.s.o(.text); build/asm/main_8020F83C.s.o(.rodata); build/asm/main_8020F83C.s.o(.data); }
    .main_8020F83C_bss (NOLOAD) : { build/asm/main_8020F83C.s.o(.bss); }
    .main_8020F928 0x8020F928 : AT(0x000EB028) { build/asm/data/main_8020F928.bin.o(.data); }
    .main_8020F9B0 0x8020F9B0 : AT(0x000EB0B0) { FILL(0x00000000); build/asm/main_8020F9B0.s.o(.text); build/asm/main_8020F9B0.s.o(.rodata); build/asm/main_8020F9B0.s.o(.data); }
    .main_8020F9B0_bss (NOLOAD) : { build/asm/main_8020F9B0.s.o(.bss); }
    .main_8020FC4C 0x8020FC4C : AT(0x000EB34C) { build/asm/data/main_8020FC4C.bin.o(.data); }
    .main_8020FD94 0x8020FD94 : AT(0x000EB494) { FILL(0x00000000); build/asm/main_8020FD94.s.o(.text); build/asm/main_8020FD94.s.o(.rodata); build/asm/main_8020FD94.s.o(.data); }
    .main_8020FD94_bss (NOLOAD) : { build/asm/main_8020FD94.s.o(.bss); }
    .main_8020FDD4 0x8020FDD4 : AT(0x000EB4D4) { build/asm/data/main_8020FDD4.bin.o(.data); }
    .main_8020FFD4 0x8020FFD4 : AT(0x000EB6D4) { FILL(0x00000000); build/asm/main_8020FFD4.s.o(.text); build/asm/main_8020FFD4.s.o(.rodata); build/asm/main_8020FFD4.s.o(.data); }
    .main_8020FFD4_bss (NOLOAD) : { build/asm/main_8020FFD4.s.o(.bss); }
    .main_802104AC 0x802104AC : AT(0x000EBBAC) { build/asm/data/main_802104AC.bin.o(.data); }
    .main_80210F3C 0x80210F3C : AT(0x000EC63C) { FILL(0x00000000); build/asm/main_80210F3C.s.o(.text); build/asm/main_80210F3C.s.o(.rodata); build/asm/main_80210F3C.s.o(.data); }
    .main_80210F3C_bss (NOLOAD) : { build/asm/main_80210F3C.s.o(.bss); }
    .main_80211B9C 0x80211B9C : AT(0x000ED29C) { build/asm/data/main_80211B9C.bin.o(.data); }
    .main_80211D60 0x80211D60 : AT(0x000ED460) { FILL(0x00000000); build/asm/main_80211D60.s.o(.text); build/asm/main_80211D60.s.o(.rodata); build/asm/main_80211D60.s.o(.data); }
    .main_80211D60_bss (NOLOAD) : { build/asm/main_80211D60.s.o(.bss); }
    .main_802124E4 0x802124E4 : AT(0x000EDBE4) { build/asm/data/main_802124E4.bin.o(.data); }
    .main_80214E60 0x80214E60 : AT(0x000F0560) { FILL(0x00000000); build/asm/main_80214E60.s.o(.text); build/asm/main_80214E60.s.o(.rodata); build/asm/main_80214E60.s.o(.data); }
    .main_80214E60_bss (NOLOAD) : { build/asm/main_80214E60.s.o(.bss); }
    .main_8021597C 0x8021597C : AT(0x000F107C) { build/asm/data/main_8021597C.bin.o(.data); }
    .main_80215DC0 0x80215DC0 : AT(0x000F14C0) { FILL(0x00000000); build/asm/main_80215DC0.s.o(.text); build/asm/main_80215DC0.s.o(.rodata); build/asm/main_80215DC0.s.o(.data); }
    .main_80215DC0_bss (NOLOAD) : { build/asm/main_80215DC0.s.o(.bss); }
    .main_802166B8 0x802166B8 : AT(0x000F1DB8) { build/asm/data/main_802166B8.bin.o(.data); }
    .main_80216DFC 0x80216DFC : AT(0x000F24FC) { FILL(0x00000000); build/asm/main_80216DFC.s.o(.text); build/asm/main_80216DFC.s.o(.rodata); build/asm/main_80216DFC.s.o(.data); }
    .main_80216DFC_bss (NOLOAD) : { build/asm/main_80216DFC.s.o(.bss); }
    .main_80217168 0x80217168 : AT(0x000F2868) { build/asm/data/main_80217168.bin.o(.data); }
    .main_8021763C 0x8021763C : AT(0x000F2D3C) { FILL(0x00000000); build/asm/main_8021763C.s.o(.text); build/asm/main_8021763C.s.o(.rodata); build/asm/main_8021763C.s.o(.data); }
    .main_8021763C_bss (NOLOAD) : { build/asm/main_8021763C.s.o(.bss); }
    .main_8021843C 0x8021843C : AT(0x000F3B3C) { build/asm/data/main_8021843C.bin.o(.data); }
    .main_802189BC 0x802189BC : AT(0x000F40BC) { FILL(0x00000000); build/asm/main_802189BC.s.o(.text); build/asm/main_802189BC.s.o(.rodata); build/asm/main_802189BC.s.o(.data); }
    .main_802189BC_bss (NOLOAD) : { build/asm/main_802189BC.s.o(.bss); }
    .main_80218BEC 0x80218BEC : AT(0x000F42EC) { build/asm/data/main_80218BEC.bin.o(.data); }
    .main_80219D5C 0x80219D5C : AT(0x000F545C) { FILL(0x00000000); build/asm/main_80219D5C.s.o(.text); build/asm/main_80219D5C.s.o(.rodata); build/asm/main_80219D5C.s.o(.data); }
    .main_80219D5C_bss (NOLOAD) : { build/asm/main_80219D5C.s.o(.bss); }
    .main_8021A09C 0x8021A09C : AT(0x000F579C) { build/asm/data/main_8021A09C.bin.o(.data); }
    .main_8021A6DC 0x8021A6DC : AT(0x000F5DDC) { FILL(0x00000000); build/asm/main_8021A6DC.s.o(.text); build/asm/main_8021A6DC.s.o(.rodata); build/asm/main_8021A6DC.s.o(.data); }
    .main_8021A6DC_bss (NOLOAD) : { build/asm/main_8021A6DC.s.o(.bss); }
    .main_8021A88C 0x8021A88C : AT(0x000F5F8C) { build/asm/data/main_8021A88C.bin.o(.data); }
    .main_8021B4AC 0x8021B4AC : AT(0x000F6BAC) { FILL(0x00000000); build/asm/main_8021B4AC.s.o(.text); build/asm/main_8021B4AC.s.o(.rodata); build/asm/main_8021B4AC.s.o(.data); }
    .main_8021B4AC_bss (NOLOAD) : { build/asm/main_8021B4AC.s.o(.bss); }
    .main_8021BA4C 0x8021BA4C : AT(0x000F714C) { build/asm/data/main_8021BA4C.bin.o(.data); }
    .main_8021C020 0x8021C020 : AT(0x000F7720) { FILL(0x00000000); build/asm/main_8021C020.s.o(.text); build/asm/main_8021C020.s.o(.rodata); build/asm/main_8021C020.s.o(.data); }
    .main_8021C020_bss (NOLOAD) : { build/asm/main_8021C020.s.o(.bss); }
    .main_8021C24C 0x8021C24C : AT(0x000F794C) { build/asm/data/main_8021C24C.bin.o(.data); }
    .main_8021C88C 0x8021C88C : AT(0x000F7F8C) { FILL(0x00000000); build/asm/main_8021C88C.s.o(.text); build/asm/main_8021C88C.s.o(.rodata); build/asm/main_8021C88C.s.o(.data); }
    .main_8021C88C_bss (NOLOAD) : { build/asm/main_8021C88C.s.o(.bss); }
    .main_8021CC3C 0x8021CC3C : AT(0x000F833C) { build/asm/data/main_8021CC3C.bin.o(.data); }
    .main_8021CCCC 0x8021CCCC : AT(0x000F83CC) { FILL(0x00000000); build/asm/main_8021CCCC.s.o(.text); build/asm/main_8021CCCC.s.o(.rodata); build/asm/main_8021CCCC.s.o(.data); }
    .main_8021CCCC_bss (NOLOAD) : { build/asm/main_8021CCCC.s.o(.bss); }
    .main_8021D37C 0x8021D37C : AT(0x000F8A7C) { build/asm/data/main_8021D37C.bin.o(.data); }
    .main_8021D70C 0x8021D70C : AT(0x000F8E0C) { FILL(0x00000000); build/asm/main_8021D70C.s.o(.text); build/asm/main_8021D70C.s.o(.rodata); build/asm/main_8021D70C.s.o(.data); }
    .main_8021D70C_bss (NOLOAD) : { build/asm/main_8021D70C.s.o(.bss); }
    .main_8021D9CC 0x8021D9CC : AT(0x000F90CC) { build/asm/data/main_8021D9CC.bin.o(.data); }
    .main_8021DF0C 0x8021DF0C : AT(0x000F960C) { FILL(0x00000000); build/asm/main_8021DF0C.s.o(.text); build/asm/main_8021DF0C.s.o(.rodata); build/asm/main_8021DF0C.s.o(.data); }
    .main_8021DF0C_bss (NOLOAD) : { build/asm/main_8021DF0C.s.o(.bss); }
    .main_8021E1DC 0x8021E1DC : AT(0x000F98DC) { build/asm/data/main_8021E1DC.bin.o(.data); }
    .main_8021E62C 0x8021E62C : AT(0x000F9D2C) { FILL(0x00000000); build/asm/main_8021E62C.s.o(.text); build/asm/main_8021E62C.s.o(.rodata); build/asm/main_8021E62C.s.o(.data); }
    .main_8021E62C_bss (NOLOAD) : { build/asm/main_8021E62C.s.o(.bss); }
    .main_8021E63C 0x8021E63C : AT(0x000F9D3C) { build/asm/data/main_8021E63C.bin.o(.data); }
    .main_8021E79C 0x8021E79C : AT(0x000F9E9C) { FILL(0x00000000); build/asm/main_8021E79C.s.o(.text); build/asm/main_8021E79C.s.o(.rodata); build/asm/main_8021E79C.s.o(.data); }
    .main_8021E79C_bss (NOLOAD) : { build/asm/main_8021E79C.s.o(.bss); }
    .main_8021E90C 0x8021E90C : AT(0x000FA00C) { build/asm/data/main_8021E90C.bin.o(.data); }
    .main_8021E95C 0x8021E95C : AT(0x000FA05C) { FILL(0x00000000); build/asm/main_8021E95C.s.o(.text); build/asm/main_8021E95C.s.o(.rodata); build/asm/main_8021E95C.s.o(.data); }
    .main_8021E95C_bss (NOLOAD) : { build/asm/main_8021E95C.s.o(.bss); }
    .main_8021EE6C 0x8021EE6C : AT(0x000FA56C) { build/asm/data/main_8021EE6C.bin.o(.data); }
    .main_8021FCF4 0x8021FCF4 : AT(0x000FB3F4) { FILL(0x00000000); build/asm/main_8021FCF4.s.o(.text); build/asm/main_8021FCF4.s.o(.rodata); build/asm/main_8021FCF4.s.o(.data); }
    .main_8021FCF4_bss (NOLOAD) : { build/asm/main_8021FCF4.s.o(.bss); }
    .main_8021FF38 0x8021FF38 : AT(0x000FB638) { build/asm/data/main_8021FF38.bin.o(.data); }
    .main_80220004 0x80220004 : AT(0x000FB704) { FILL(0x00000000); build/asm/main_80220004.s.o(.text); build/asm/main_80220004.s.o(.rodata); build/asm/main_80220004.s.o(.data); }
    .main_80220004_bss (NOLOAD) : { build/asm/main_80220004.s.o(.bss); }
    .main_802201A8 0x802201A8 : AT(0x000FB8A8) { build/asm/data/main_802201A8.bin.o(.data); }
    .main_80220318 0x80220318 : AT(0x000FBA18) { FILL(0x00000000); build/asm/main_80220318.s.o(.text); build/asm/main_80220318.s.o(.rodata); build/asm/main_80220318.s.o(.data); }
    .main_80220318_bss (NOLOAD) : { build/asm/main_80220318.s.o(.bss); }
    .main_80220334 0x80220334 : AT(0x000FBA34) { build/asm/data/main_80220334.bin.o(.data); }
    .main_802203F4 0x802203F4 : AT(0x000FBAF4) { FILL(0x00000000); build/asm/main_802203F4.s.o(.text); build/asm/main_802203F4.s.o(.rodata); build/asm/main_802203F4.s.o(.data); }
    .main_802203F4_bss (NOLOAD) : { build/asm/main_802203F4.s.o(.bss); }
    .main_80220484 0x80220484 : AT(0x000FBB84) { build/asm/data/main_80220484.bin.o(.data); }
    .main_802204C8 0x802204C8 : AT(0x000FBBC8) { FILL(0x00000000); build/asm/main_802204C8.s.o(.text); build/asm/main_802204C8.s.o(.rodata); build/asm/main_802204C8.s.o(.data); }
    .main_802204C8_bss (NOLOAD) : { build/asm/main_802204C8.s.o(.bss); }
    .main_80220518 0x80220518 : AT(0x000FBC18) { build/asm/data/main_80220518.bin.o(.data); }
    .main_802210DC 0x802210DC : AT(0x000FC7DC) { FILL(0x00000000); build/asm/main_802210DC.s.o(.text); build/asm/main_802210DC.s.o(.rodata); build/asm/main_802210DC.s.o(.data); }
    .main_802210DC_bss (NOLOAD) : { build/asm/main_802210DC.s.o(.bss); }
    .main_802210EC 0x802210EC : AT(0x000FC7EC) { build/asm/data/main_802210EC.bin.o(.data); }
    .main_8022113C 0x8022113C : AT(0x000FC83C) { FILL(0x00000000); build/asm/main_8022113C.s.o(.text); build/asm/main_8022113C.s.o(.rodata); build/asm/main_8022113C.s.o(.data); }
    .main_8022113C_bss (NOLOAD) : { build/asm/main_8022113C.s.o(.bss); }
    .main_8022114C 0x8022114C : AT(0x000FC84C) { build/asm/data/main_8022114C.bin.o(.data); }
    .main_80224860 0x80224860 : AT(0x000FFF60) { FILL(0x00000000); build/asm/main_80224860.s.o(.text); build/asm/main_80224860.s.o(.rodata); build/asm/main_80224860.s.o(.data); }
    .main_80224860_bss (NOLOAD) : { build/asm/main_80224860.s.o(.bss); }
    .main_80224B74 0x80224B74 : AT(0x00100274) { build/asm/data/main_80224B74.bin.o(.data); }
    .main_80225110 0x80225110 : AT(0x00100810) { FILL(0x00000000); build/asm/main_80225110.s.o(.text); build/asm/main_80225110.s.o(.rodata); build/asm/main_80225110.s.o(.data); }
    .main_80225110_bss (NOLOAD) : { build/asm/main_80225110.s.o(.bss); }
    .main_802253CC 0x802253CC : AT(0x00100ACC) { build/asm/data/main_802253CC.bin.o(.data); }
    .assets 0x80525900 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
