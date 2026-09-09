SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80019560 0x80019560 : AT(0x0001A160) { FILL(0x00000000); build/asm/main_80019560.s.o(.text); build/asm/main_80019560.s.o(.rodata); build/asm/main_80019560.s.o(.data); }
    .main_80019560_bss (NOLOAD) : { build/asm/main_80019560.s.o(.bss); }
    .main_8007F5D0 0x8007F5D0 : AT(0x000801D0) { FILL(0x00000000); build/asm/main_8007F5D0.s.o(.text); build/asm/main_8007F5D0.s.o(.rodata); build/asm/main_8007F5D0.s.o(.data); }
    .main_8007F5D0_bss (NOLOAD) : { build/asm/main_8007F5D0.s.o(.bss); }
    .main_8007FA40 0x8007FA40 : AT(0x00080640) { FILL(0x00000000); build/asm/main_8007FA40.s.o(.text); build/asm/main_8007FA40.s.o(.rodata); build/asm/main_8007FA40.s.o(.data); }
    .main_8007FA40_bss (NOLOAD) : { build/asm/main_8007FA40.s.o(.bss); }
    .main_800802B0 0x800802B0 : AT(0x00080EB0) { FILL(0x00000000); build/asm/main_800802B0.s.o(.text); build/asm/main_800802B0.s.o(.rodata); build/asm/main_800802B0.s.o(.data); }
    .main_800802B0_bss (NOLOAD) : { build/asm/main_800802B0.s.o(.bss); }
    .main_800808A4 0x800808A4 : AT(0x000814A4) { FILL(0x00000000); build/asm/main_800808A4.s.o(.text); build/asm/main_800808A4.s.o(.rodata); build/asm/main_800808A4.s.o(.data); }
    .main_800808A4_bss (NOLOAD) : { build/asm/main_800808A4.s.o(.bss); }
    .main_80080C70 0x80080C70 : AT(0x00081870) { FILL(0x00000000); build/asm/main_80080C70.s.o(.text); build/asm/main_80080C70.s.o(.rodata); build/asm/main_80080C70.s.o(.data); }
    .main_80080C70_bss (NOLOAD) : { build/asm/main_80080C70.s.o(.bss); }
    .main_80080E00 0x80080E00 : AT(0x00081A00) { FILL(0x00000000); build/asm/main_80080E00.s.o(.text); build/asm/main_80080E00.s.o(.rodata); build/asm/main_80080E00.s.o(.data); }
    .main_80080E00_bss (NOLOAD) : { build/asm/main_80080E00.s.o(.bss); }
    .main_80081030 0x80081030 : AT(0x00081C30) { FILL(0x00000000); build/asm/main_80081030.s.o(.text); build/asm/main_80081030.s.o(.rodata); build/asm/main_80081030.s.o(.data); }
    .main_80081030_bss (NOLOAD) : { build/asm/main_80081030.s.o(.bss); }
    .main_80081520 0x80081520 : AT(0x00082120) { FILL(0x00000000); build/asm/main_80081520.s.o(.text); build/asm/main_80081520.s.o(.rodata); build/asm/main_80081520.s.o(.data); }
    .main_80081520_bss (NOLOAD) : { build/asm/main_80081520.s.o(.bss); }
    .main_80082028 0x80082028 : AT(0x00082C28) { FILL(0x00000000); build/asm/main_80082028.s.o(.text); build/asm/main_80082028.s.o(.rodata); build/asm/main_80082028.s.o(.data); }
    .main_80082028_bss (NOLOAD) : { build/asm/main_80082028.s.o(.bss); }
    .main_80082174 0x80082174 : AT(0x00082D74) { FILL(0x00000000); build/asm/main_80082174.s.o(.text); build/asm/main_80082174.s.o(.rodata); build/asm/main_80082174.s.o(.data); }
    .main_80082174_bss (NOLOAD) : { build/asm/main_80082174.s.o(.bss); }
    .main_80082268 0x80082268 : AT(0x00082E68) { FILL(0x00000000); build/asm/main_80082268.s.o(.text); build/asm/main_80082268.s.o(.rodata); build/asm/main_80082268.s.o(.data); }
    .main_80082268_bss (NOLOAD) : { build/asm/main_80082268.s.o(.bss); }
    .main_80082490 0x80082490 : AT(0x00083090) { FILL(0x00000000); build/asm/main_80082490.s.o(.text); build/asm/main_80082490.s.o(.rodata); build/asm/main_80082490.s.o(.data); }
    .main_80082490_bss (NOLOAD) : { build/asm/main_80082490.s.o(.bss); }
    .main_80082530 0x80082530 : AT(0x00083130) { FILL(0x00000000); build/asm/main_80082530.s.o(.text); build/asm/main_80082530.s.o(.rodata); build/asm/main_80082530.s.o(.data); }
    .main_80082530_bss (NOLOAD) : { build/asm/main_80082530.s.o(.bss); }
    .main_80082770 0x80082770 : AT(0x00083370) { FILL(0x00000000); build/asm/main_80082770.s.o(.text); build/asm/main_80082770.s.o(.rodata); build/asm/main_80082770.s.o(.data); }
    .main_80082770_bss (NOLOAD) : { build/asm/main_80082770.s.o(.bss); }
    .main_80082830 0x80082830 : AT(0x00083430) { FILL(0x00000000); build/asm/main_80082830.s.o(.text); build/asm/main_80082830.s.o(.rodata); build/asm/main_80082830.s.o(.data); }
    .main_80082830_bss (NOLOAD) : { build/asm/main_80082830.s.o(.bss); }
    .main_80082C80 0x80082C80 : AT(0x00083880) { FILL(0x00000000); build/asm/main_80082C80.s.o(.text); build/asm/main_80082C80.s.o(.rodata); build/asm/main_80082C80.s.o(.data); }
    .main_80082C80_bss (NOLOAD) : { build/asm/main_80082C80.s.o(.bss); }
    .main_80083B80 0x80083B80 : AT(0x00084780) { FILL(0x00000000); build/asm/main_80083B80.s.o(.text); build/asm/main_80083B80.s.o(.rodata); build/asm/main_80083B80.s.o(.data); }
    .main_80083B80_bss (NOLOAD) : { build/asm/main_80083B80.s.o(.bss); }
    .main_80083FE0 0x80083FE0 : AT(0x00084BE0) { FILL(0x00000000); build/asm/main_80083FE0.s.o(.text); build/asm/main_80083FE0.s.o(.rodata); build/asm/main_80083FE0.s.o(.data); }
    .main_80083FE0_bss (NOLOAD) : { build/asm/main_80083FE0.s.o(.bss); }
    .main_800846D0 0x800846D0 : AT(0x000852D0) { FILL(0x00000000); build/asm/main_800846D0.s.o(.text); build/asm/main_800846D0.s.o(.rodata); build/asm/main_800846D0.s.o(.data); }
    .main_800846D0_bss (NOLOAD) : { build/asm/main_800846D0.s.o(.bss); }
    .main_800853C0 0x800853C0 : AT(0x00085FC0) { FILL(0x00000000); build/asm/main_800853C0.s.o(.text); build/asm/main_800853C0.s.o(.rodata); build/asm/main_800853C0.s.o(.data); }
    .main_800853C0_bss (NOLOAD) : { build/asm/main_800853C0.s.o(.bss); }
    .main_80088C40 0x80088C40 : AT(0x00089840) { FILL(0x00000000); build/asm/main_80088C40.s.o(.text); build/asm/main_80088C40.s.o(.rodata); build/asm/main_80088C40.s.o(.data); }
    .main_80088C40_bss (NOLOAD) : { build/asm/main_80088C40.s.o(.bss); }
    .main_80088D20 0x80088D20 : AT(0x00089920) { FILL(0x00000000); build/asm/main_80088D20.s.o(.text); build/asm/main_80088D20.s.o(.rodata); build/asm/main_80088D20.s.o(.data); }
    .main_80088D20_bss (NOLOAD) : { build/asm/main_80088D20.s.o(.bss); }
    .main_80089D60 0x80089D60 : AT(0x0008A960) { FILL(0x00000000); build/asm/main_80089D60.s.o(.text); build/asm/main_80089D60.s.o(.rodata); build/asm/main_80089D60.s.o(.data); }
    .main_80089D60_bss (NOLOAD) : { build/asm/main_80089D60.s.o(.bss); }
    .main_80089FA0 0x80089FA0 : AT(0x0008ABA0) { FILL(0x00000000); build/asm/main_80089FA0.s.o(.text); build/asm/main_80089FA0.s.o(.rodata); build/asm/main_80089FA0.s.o(.data); }
    .main_80089FA0_bss (NOLOAD) : { build/asm/main_80089FA0.s.o(.bss); }
    .main_8008A530 0x8008A530 : AT(0x0008B130) { FILL(0x00000000); build/asm/main_8008A530.s.o(.text); build/asm/main_8008A530.s.o(.rodata); build/asm/main_8008A530.s.o(.data); }
    .main_8008A530_bss (NOLOAD) : { build/asm/main_8008A530.s.o(.bss); }
    .main_8008A6E0 0x8008A6E0 : AT(0x0008B2E0) { FILL(0x00000000); build/asm/main_8008A6E0.s.o(.text); build/asm/main_8008A6E0.s.o(.rodata); build/asm/main_8008A6E0.s.o(.data); }
    .main_8008A6E0_bss (NOLOAD) : { build/asm/main_8008A6E0.s.o(.bss); }
    .main_8008B040 0x8008B040 : AT(0x0008BC40) { FILL(0x00000000); build/asm/main_8008B040.s.o(.text); build/asm/main_8008B040.s.o(.rodata); build/asm/main_8008B040.s.o(.data); }
    .main_8008B040_bss (NOLOAD) : { build/asm/main_8008B040.s.o(.bss); }
    .main_8008B5E0 0x8008B5E0 : AT(0x0008C1E0) { FILL(0x00000000); build/asm/main_8008B5E0.s.o(.text); build/asm/main_8008B5E0.s.o(.rodata); build/asm/main_8008B5E0.s.o(.data); }
    .main_8008B5E0_bss (NOLOAD) : { build/asm/main_8008B5E0.s.o(.bss); }
    .main_8008B990 0x8008B990 : AT(0x0008C590) { FILL(0x00000000); build/asm/main_8008B990.s.o(.text); build/asm/main_8008B990.s.o(.rodata); build/asm/main_8008B990.s.o(.data); }
    .main_8008B990_bss (NOLOAD) : { build/asm/main_8008B990.s.o(.bss); }
    .main_8008BD70 0x8008BD70 : AT(0x0008C970) { FILL(0x00000000); build/asm/main_8008BD70.s.o(.text); build/asm/main_8008BD70.s.o(.rodata); build/asm/main_8008BD70.s.o(.data); }
    .main_8008BD70_bss (NOLOAD) : { build/asm/main_8008BD70.s.o(.bss); }
    .main_8008C550 0x8008C550 : AT(0x0008D150) { FILL(0x00000000); build/asm/main_8008C550.s.o(.text); build/asm/main_8008C550.s.o(.rodata); build/asm/main_8008C550.s.o(.data); }
    .main_8008C550_bss (NOLOAD) : { build/asm/main_8008C550.s.o(.bss); }
    .main_8008C830 0x8008C830 : AT(0x0008D430) { FILL(0x00000000); build/asm/main_8008C830.s.o(.text); build/asm/main_8008C830.s.o(.rodata); build/asm/main_8008C830.s.o(.data); }
    .main_8008C830_bss (NOLOAD) : { build/asm/main_8008C830.s.o(.bss); }
    .main_8008CCA8 0x8008CCA8 : AT(0x0008D8A8) { FILL(0x00000000); build/asm/main_8008CCA8.s.o(.text); build/asm/main_8008CCA8.s.o(.rodata); build/asm/main_8008CCA8.s.o(.data); }
    .main_8008CCA8_bss (NOLOAD) : { build/asm/main_8008CCA8.s.o(.bss); }
    .main_8008D760 0x8008D760 : AT(0x0008E360) { FILL(0x00000000); build/asm/main_8008D760.s.o(.text); build/asm/main_8008D760.s.o(.rodata); build/asm/main_8008D760.s.o(.data); }
    .main_8008D760_bss (NOLOAD) : { build/asm/main_8008D760.s.o(.bss); }
    .main_8008D850 0x8008D850 : AT(0x0008E450) { FILL(0x00000000); build/asm/main_8008D850.s.o(.text); build/asm/main_8008D850.s.o(.rodata); build/asm/main_8008D850.s.o(.data); }
    .main_8008D850_bss (NOLOAD) : { build/asm/main_8008D850.s.o(.bss); }
    .main_8008E170 0x8008E170 : AT(0x0008ED70) { FILL(0x00000000); build/asm/main_8008E170.s.o(.text); build/asm/main_8008E170.s.o(.rodata); build/asm/main_8008E170.s.o(.data); }
    .main_8008E170_bss (NOLOAD) : { build/asm/main_8008E170.s.o(.bss); }
    .main_8008F430 0x8008F430 : AT(0x00090030) { FILL(0x00000000); build/asm/main_8008F430.s.o(.text); build/asm/main_8008F430.s.o(.rodata); build/asm/main_8008F430.s.o(.data); }
    .main_8008F430_bss (NOLOAD) : { build/asm/main_8008F430.s.o(.bss); }
    .main_8008F470 0x8008F470 : AT(0x00090070) { FILL(0x00000000); build/asm/main_8008F470.s.o(.text); build/asm/main_8008F470.s.o(.rodata); build/asm/main_8008F470.s.o(.data); }
    .main_8008F470_bss (NOLOAD) : { build/asm/main_8008F470.s.o(.bss); }
    .main_8008FA40 0x8008FA40 : AT(0x00090640) { FILL(0x00000000); build/asm/main_8008FA40.s.o(.text); build/asm/main_8008FA40.s.o(.rodata); build/asm/main_8008FA40.s.o(.data); }
    .main_8008FA40_bss (NOLOAD) : { build/asm/main_8008FA40.s.o(.bss); }
    .main_8008FC20 0x8008FC20 : AT(0x00090820) { FILL(0x00000000); build/asm/main_8008FC20.s.o(.text); build/asm/main_8008FC20.s.o(.rodata); build/asm/main_8008FC20.s.o(.data); }
    .main_8008FC20_bss (NOLOAD) : { build/asm/main_8008FC20.s.o(.bss); }
    .main_80090F7C 0x80090F7C : AT(0x00091B7C) { build/asm/data/main_80090F7C.bin.o(.data); }
    .main_80093DD4 0x80093DD4 : AT(0x000949D4) { FILL(0x00000000); build/asm/main_80093DD4.s.o(.text); build/asm/main_80093DD4.s.o(.rodata); build/asm/main_80093DD4.s.o(.data); }
    .main_80093DD4_bss (NOLOAD) : { build/asm/main_80093DD4.s.o(.bss); }
    .main_80094068 0x80094068 : AT(0x00094C68) { FILL(0x00000000); build/asm/main_80094068.s.o(.text); build/asm/main_80094068.s.o(.rodata); build/asm/main_80094068.s.o(.data); }
    .main_80094068_bss (NOLOAD) : { build/asm/main_80094068.s.o(.bss); }
    .main_800942F8 0x800942F8 : AT(0x00094EF8) { FILL(0x00000000); build/asm/main_800942F8.s.o(.text); build/asm/main_800942F8.s.o(.rodata); build/asm/main_800942F8.s.o(.data); }
    .main_800942F8_bss (NOLOAD) : { build/asm/main_800942F8.s.o(.bss); }
    .main_8009874C 0x8009874C : AT(0x0009934C) { FILL(0x00000000); build/asm/main_8009874C.s.o(.text); build/asm/main_8009874C.s.o(.rodata); build/asm/main_8009874C.s.o(.data); }
    .main_8009874C_bss (NOLOAD) : { build/asm/main_8009874C.s.o(.bss); }
    .main_80099440 0x80099440 : AT(0x0009A040) { build/asm/data/main_80099440.bin.o(.data); }
    .main_80099610 0x80099610 : AT(0x0009A210) { build/asm/data/main_80099610.bin.o(.data); }
    .main_800999B8 0x800999B8 : AT(0x0009A5B8) { FILL(0x00000000); build/asm/main_800999B8.s.o(.text); build/asm/main_800999B8.s.o(.rodata); build/asm/main_800999B8.s.o(.data); }
    .main_800999B8_bss (NOLOAD) : { build/asm/main_800999B8.s.o(.bss); }
    .main_80099E0C 0x80099E0C : AT(0x0009AA0C) { FILL(0x00000000); build/asm/main_80099E0C.s.o(.text); build/asm/main_80099E0C.s.o(.rodata); build/asm/main_80099E0C.s.o(.data); }
    .main_80099E0C_bss (NOLOAD) : { build/asm/main_80099E0C.s.o(.bss); }
    .main_8009A0E4 0x8009A0E4 : AT(0x0009ACE4) { FILL(0x00000000); build/asm/main_8009A0E4.s.o(.text); build/asm/main_8009A0E4.s.o(.rodata); build/asm/main_8009A0E4.s.o(.data); }
    .main_8009A0E4_bss (NOLOAD) : { build/asm/main_8009A0E4.s.o(.bss); }
    .main_8009A96C 0x8009A96C : AT(0x0009B56C) { build/asm/data/main_8009A96C.bin.o(.data); }
    .main_8009B50C 0x8009B50C : AT(0x0009C10C) { build/asm/data/main_8009B50C.bin.o(.data); }
    .main_8009B814 0x8009B814 : AT(0x0009C414) { FILL(0x00000000); build/asm/main_8009B814.s.o(.text); build/asm/main_8009B814.s.o(.rodata); build/asm/main_8009B814.s.o(.data); }
    .main_8009B814_bss (NOLOAD) : { build/asm/main_8009B814.s.o(.bss); }
    .main_8009B844 0x8009B844 : AT(0x0009C444) { build/asm/data/main_8009B844.bin.o(.data); }
    .main_8009B8F4 0x8009B8F4 : AT(0x0009C4F4) { FILL(0x00000000); build/asm/main_8009B8F4.s.o(.text); build/asm/main_8009B8F4.s.o(.rodata); build/asm/main_8009B8F4.s.o(.data); }
    .main_8009B8F4_bss (NOLOAD) : { build/asm/main_8009B8F4.s.o(.bss); }
    .main_8009BFEC 0x8009BFEC : AT(0x0009CBEC) { build/asm/data/main_8009BFEC.bin.o(.data); }
    .main_8009C844 0x8009C844 : AT(0x0009D444) { FILL(0x00000000); build/asm/main_8009C844.s.o(.text); build/asm/main_8009C844.s.o(.rodata); build/asm/main_8009C844.s.o(.data); }
    .main_8009C844_bss (NOLOAD) : { build/asm/main_8009C844.s.o(.bss); }
    .main_8009CA1C 0x8009CA1C : AT(0x0009D61C) { build/asm/data/main_8009CA1C.bin.o(.data); }
    .main_8009CEFC 0x8009CEFC : AT(0x0009DAFC) { FILL(0x00000000); build/asm/main_8009CEFC.s.o(.text); build/asm/main_8009CEFC.s.o(.rodata); build/asm/main_8009CEFC.s.o(.data); }
    .main_8009CEFC_bss (NOLOAD) : { build/asm/main_8009CEFC.s.o(.bss); }
    .main_8009D194 0x8009D194 : AT(0x0009DD94) { build/asm/data/main_8009D194.bin.o(.data); }
    .main_8009D83C 0x8009D83C : AT(0x0009E43C) { FILL(0x00000000); build/asm/main_8009D83C.s.o(.text); build/asm/main_8009D83C.s.o(.rodata); build/asm/main_8009D83C.s.o(.data); }
    .main_8009D83C_bss (NOLOAD) : { build/asm/main_8009D83C.s.o(.bss); }
    .main_8009D884 0x8009D884 : AT(0x0009E484) { build/asm/data/main_8009D884.bin.o(.data); }
    .main_8009E63C 0x8009E63C : AT(0x0009F23C) { FILL(0x00000000); build/asm/main_8009E63C.s.o(.text); build/asm/main_8009E63C.s.o(.rodata); build/asm/main_8009E63C.s.o(.data); }
    .main_8009E63C_bss (NOLOAD) : { build/asm/main_8009E63C.s.o(.bss); }
    .main_8009E844 0x8009E844 : AT(0x0009F444) { FILL(0x00000000); build/asm/main_8009E844.s.o(.text); build/asm/main_8009E844.s.o(.rodata); build/asm/main_8009E844.s.o(.data); }
    .main_8009E844_bss (NOLOAD) : { build/asm/main_8009E844.s.o(.bss); }
    .main_8009EA0C 0x8009EA0C : AT(0x0009F60C) { FILL(0x00000000); build/asm/main_8009EA0C.s.o(.text); build/asm/main_8009EA0C.s.o(.rodata); build/asm/main_8009EA0C.s.o(.data); }
    .main_8009EA0C_bss (NOLOAD) : { build/asm/main_8009EA0C.s.o(.bss); }
    .main_8009F7FC 0x8009F7FC : AT(0x000A03FC) { FILL(0x00000000); build/asm/main_8009F7FC.s.o(.text); build/asm/main_8009F7FC.s.o(.rodata); build/asm/main_8009F7FC.s.o(.data); }
    .main_8009F7FC_bss (NOLOAD) : { build/asm/main_8009F7FC.s.o(.bss); }
    .main_800A19B0 0x800A19B0 : AT(0x000A25B0) { build/asm/data/main_800A19B0.bin.o(.data); }
    .main_800A24CC 0x800A24CC : AT(0x000A30CC) { FILL(0x00000000); build/asm/main_800A24CC.s.o(.text); build/asm/main_800A24CC.s.o(.rodata); build/asm/main_800A24CC.s.o(.data); }
    .main_800A24CC_bss (NOLOAD) : { build/asm/main_800A24CC.s.o(.bss); }
    .main_800A32D4 0x800A32D4 : AT(0x000A3ED4) { FILL(0x00000000); build/asm/main_800A32D4.s.o(.text); build/asm/main_800A32D4.s.o(.rodata); build/asm/main_800A32D4.s.o(.data); }
    .main_800A32D4_bss (NOLOAD) : { build/asm/main_800A32D4.s.o(.bss); }
    .main_800A3DE4 0x800A3DE4 : AT(0x000A49E4) { build/asm/data/main_800A3DE4.bin.o(.data); }
    .main_800A4884 0x800A4884 : AT(0x000A5484) { build/asm/data/main_800A4884.bin.o(.data); }
    .main_800A59EC 0x800A59EC : AT(0x000A65EC) { build/asm/data/main_800A59EC.bin.o(.data); }
    .main_800A72EC 0x800A72EC : AT(0x000A7EEC) { build/asm/data/main_800A72EC.bin.o(.data); }
    .main_800A76CC 0x800A76CC : AT(0x000A82CC) { build/asm/data/main_800A76CC.bin.o(.data); }
    .mod2_80125230 0x80125230 : AT(0x000A8420) { FILL(0x00000000); build/asm/mod2_80125230.s.o(.text); build/asm/mod2_80125230.s.o(.rodata); build/asm/mod2_80125230.s.o(.data); }
    .mod2_80125230_bss (NOLOAD) : { build/asm/mod2_80125230.s.o(.bss); }
    .mod2_80126138 0x80126138 : AT(0x000A9328) { FILL(0x00000000); build/asm/mod2_80126138.s.o(.text); build/asm/mod2_80126138.s.o(.rodata); build/asm/mod2_80126138.s.o(.data); }
    .mod2_80126138_bss (NOLOAD) : { build/asm/mod2_80126138.s.o(.bss); }
    .mod2_801263C0 0x801263C0 : AT(0x000A95B0) { FILL(0x00000000); build/asm/mod2_801263C0.s.o(.text); build/asm/mod2_801263C0.s.o(.rodata); build/asm/mod2_801263C0.s.o(.data); }
    .mod2_801263C0_bss (NOLOAD) : { build/asm/mod2_801263C0.s.o(.bss); }
    .mod2_80136FB4 0x80136FB4 : AT(0x000BA1A4) { FILL(0x00000000); build/asm/mod2_80136FB4.s.o(.text); build/asm/mod2_80136FB4.s.o(.rodata); build/asm/mod2_80136FB4.s.o(.data); }
    .mod2_80136FB4_bss (NOLOAD) : { build/asm/mod2_80136FB4.s.o(.bss); }
    .mod2_8016A740 0x8016A740 : AT(0x000ED930) { build/asm/data/mod2_8016A740.bin.o(.data); }
    .mod2_8016D5B8 0x8016D5B8 : AT(0x000F07A8) { FILL(0x00000000); build/asm/mod2_8016D5B8.s.o(.text); build/asm/mod2_8016D5B8.s.o(.rodata); build/asm/mod2_8016D5B8.s.o(.data); }
    .mod2_8016D5B8_bss (NOLOAD) : { build/asm/mod2_8016D5B8.s.o(.bss); }
    .mod2_8016E438 0x8016E438 : AT(0x000F1628) { build/asm/data/mod2_8016E438.bin.o(.data); }
    .mod2_80170C30 0x80170C30 : AT(0x000F3E20) { FILL(0x00000000); build/asm/mod2_80170C30.s.o(.text); build/asm/mod2_80170C30.s.o(.rodata); build/asm/mod2_80170C30.s.o(.data); }
    .mod2_80170C30_bss (NOLOAD) : { build/asm/mod2_80170C30.s.o(.bss); }
    .mod2_80170ED0 0x80170ED0 : AT(0x000F40C0) { build/asm/data/mod2_80170ED0.bin.o(.data); }
    .mod2_80173AE4 0x80173AE4 : AT(0x000F6CD4) { FILL(0x00000000); build/asm/mod2_80173AE4.s.o(.text); build/asm/mod2_80173AE4.s.o(.rodata); build/asm/mod2_80173AE4.s.o(.data); }
    .mod2_80173AE4_bss (NOLOAD) : { build/asm/mod2_80173AE4.s.o(.bss); }
    .mod2_80173E78 0x80173E78 : AT(0x000F7068) { build/asm/data/mod2_80173E78.bin.o(.data); }
    .mod2_801747F4 0x801747F4 : AT(0x000F79E4) { FILL(0x00000000); build/asm/mod2_801747F4.s.o(.text); build/asm/mod2_801747F4.s.o(.rodata); build/asm/mod2_801747F4.s.o(.data); }
    .mod2_801747F4_bss (NOLOAD) : { build/asm/mod2_801747F4.s.o(.bss); }
    .mod2_80174A40 0x80174A40 : AT(0x000F7C30) { build/asm/data/mod2_80174A40.bin.o(.data); }
    .mod2_801777C8 0x801777C8 : AT(0x000FA9B8) { FILL(0x00000000); build/asm/mod2_801777C8.s.o(.text); build/asm/mod2_801777C8.s.o(.rodata); build/asm/mod2_801777C8.s.o(.data); }
    .mod2_801777C8_bss (NOLOAD) : { build/asm/mod2_801777C8.s.o(.bss); }
    .mod2_80177830 0x80177830 : AT(0x000FAA20) { build/asm/data/mod2_80177830.bin.o(.data); }
    .mod2_80179F00 0x80179F00 : AT(0x000FD0F0) { FILL(0x00000000); build/asm/mod2_80179F00.s.o(.text); build/asm/mod2_80179F00.s.o(.rodata); build/asm/mod2_80179F00.s.o(.data); }
    .mod2_80179F00_bss (NOLOAD) : { build/asm/mod2_80179F00.s.o(.bss); }
    .mod2_8017A0F0 0x8017A0F0 : AT(0x000FD2E0) { build/asm/data/mod2_8017A0F0.bin.o(.data); }
    .mod2_8017B104 0x8017B104 : AT(0x000FE2F4) { FILL(0x00000000); build/asm/mod2_8017B104.s.o(.text); build/asm/mod2_8017B104.s.o(.rodata); build/asm/mod2_8017B104.s.o(.data); }
    .mod2_8017B104_bss (NOLOAD) : { build/asm/mod2_8017B104.s.o(.bss); }
    .mod2_8017B228 0x8017B228 : AT(0x000FE418) { build/asm/data/mod2_8017B228.bin.o(.data); }
    .mod2_8017BB98 0x8017BB98 : AT(0x000FED88) { FILL(0x00000000); build/asm/mod2_8017BB98.s.o(.text); build/asm/mod2_8017BB98.s.o(.rodata); build/asm/mod2_8017BB98.s.o(.data); }
    .mod2_8017BB98_bss (NOLOAD) : { build/asm/mod2_8017BB98.s.o(.bss); }
    .mod2_8017BB9C 0x8017BB9C : AT(0x000FED8C) { build/asm/data/mod2_8017BB9C.bin.o(.data); }
    .mod2_8017C9EC 0x8017C9EC : AT(0x000FFBDC) { FILL(0x00000000); build/asm/mod2_8017C9EC.s.o(.text); build/asm/mod2_8017C9EC.s.o(.rodata); build/asm/mod2_8017C9EC.s.o(.data); }
    .mod2_8017C9EC_bss (NOLOAD) : { build/asm/mod2_8017C9EC.s.o(.bss); }
    .mod2_8017CADC 0x8017CADC : AT(0x000FFCCC) { build/asm/data/mod2_8017CADC.bin.o(.data); }
    .mod2_8017DE10 0x8017DE10 : AT(0x00101000) { build/asm/data/mod2_8017DE10.bin.o(.data); }
    .assets 0x80400400 : AT(0x0010FC40) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
