SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80002D30 0x80002D30 : AT(0x00003930) { FILL(0x00000000); build/asm/main_80002D30.s.o(.text); build/asm/main_80002D30.s.o(.rodata); build/asm/main_80002D30.s.o(.data); }
    .main_80002D30_bss (NOLOAD) : { build/asm/main_80002D30.s.o(.bss); }
    .main_80006030 0x80006030 : AT(0x00006C30) { FILL(0x00000000); build/asm/main_80006030.s.o(.text); build/asm/main_80006030.s.o(.rodata); build/asm/main_80006030.s.o(.data); }
    .main_80006030_bss (NOLOAD) : { build/asm/main_80006030.s.o(.bss); }
    .main_800063E4 0x800063E4 : AT(0x00006FE4) { FILL(0x00000000); build/asm/main_800063E4.s.o(.text); build/asm/main_800063E4.s.o(.rodata); build/asm/main_800063E4.s.o(.data); }
    .main_800063E4_bss (NOLOAD) : { build/asm/main_800063E4.s.o(.bss); }
    .main_80006624 0x80006624 : AT(0x00007224) { FILL(0x00000000); build/asm/main_80006624.s.o(.text); build/asm/main_80006624.s.o(.rodata); build/asm/main_80006624.s.o(.data); }
    .main_80006624_bss (NOLOAD) : { build/asm/main_80006624.s.o(.bss); }
    .main_80006804 0x80006804 : AT(0x00007404) { FILL(0x00000000); build/asm/main_80006804.s.o(.text); build/asm/main_80006804.s.o(.rodata); build/asm/main_80006804.s.o(.data); }
    .main_80006804_bss (NOLOAD) : { build/asm/main_80006804.s.o(.bss); }
    .main_800068A4 0x800068A4 : AT(0x000074A4) { FILL(0x00000000); build/asm/main_800068A4.s.o(.text); build/asm/main_800068A4.s.o(.rodata); build/asm/main_800068A4.s.o(.data); }
    .main_800068A4_bss (NOLOAD) : { build/asm/main_800068A4.s.o(.bss); }
    .main_80007494 0x80007494 : AT(0x00008094) { FILL(0x00000000); build/asm/main_80007494.s.o(.text); build/asm/main_80007494.s.o(.rodata); build/asm/main_80007494.s.o(.data); }
    .main_80007494_bss (NOLOAD) : { build/asm/main_80007494.s.o(.bss); }
    .main_80016F30 0x80016F30 : AT(0x00017B30) { FILL(0x00000000); build/asm/main_80016F30.s.o(.text); build/asm/main_80016F30.s.o(.rodata); build/asm/main_80016F30.s.o(.data); }
    .main_80016F30_bss (NOLOAD) : { build/asm/main_80016F30.s.o(.bss); }
    .main_8001712C 0x8001712C : AT(0x00017D2C) { FILL(0x00000000); build/asm/main_8001712C.s.o(.text); build/asm/main_8001712C.s.o(.rodata); build/asm/main_8001712C.s.o(.data); }
    .main_8001712C_bss (NOLOAD) : { build/asm/main_8001712C.s.o(.bss); }
    .main_80017924 0x80017924 : AT(0x00018524) { FILL(0x00000000); build/asm/main_80017924.s.o(.text); build/asm/main_80017924.s.o(.rodata); build/asm/main_80017924.s.o(.data); }
    .main_80017924_bss (NOLOAD) : { build/asm/main_80017924.s.o(.bss); }
    .main_80017EA4 0x80017EA4 : AT(0x00018AA4) { FILL(0x00000000); build/asm/main_80017EA4.s.o(.text); build/asm/main_80017EA4.s.o(.rodata); build/asm/main_80017EA4.s.o(.data); }
    .main_80017EA4_bss (NOLOAD) : { build/asm/main_80017EA4.s.o(.bss); }
    .main_800182E4 0x800182E4 : AT(0x00018EE4) { FILL(0x00000000); build/asm/main_800182E4.s.o(.text); build/asm/main_800182E4.s.o(.rodata); build/asm/main_800182E4.s.o(.data); }
    .main_800182E4_bss (NOLOAD) : { build/asm/main_800182E4.s.o(.bss); }
    .main_8001A654 0x8001A654 : AT(0x0001B254) { FILL(0x00000000); build/asm/main_8001A654.s.o(.text); build/asm/main_8001A654.s.o(.rodata); build/asm/main_8001A654.s.o(.data); }
    .main_8001A654_bss (NOLOAD) : { build/asm/main_8001A654.s.o(.bss); }
    .main_8001AD30 0x8001AD30 : AT(0x0001B930) { FILL(0x00000000); build/asm/main_8001AD30.s.o(.text); build/asm/main_8001AD30.s.o(.rodata); build/asm/main_8001AD30.s.o(.data); }
    .main_8001AD30_bss (NOLOAD) : { build/asm/main_8001AD30.s.o(.bss); }
    .main_8001B0FC 0x8001B0FC : AT(0x0001BCFC) { FILL(0x00000000); build/asm/main_8001B0FC.s.o(.text); build/asm/main_8001B0FC.s.o(.rodata); build/asm/main_8001B0FC.s.o(.data); }
    .main_8001B0FC_bss (NOLOAD) : { build/asm/main_8001B0FC.s.o(.bss); }
    .main_8001B2D4 0x8001B2D4 : AT(0x0001BED4) { FILL(0x00000000); build/asm/main_8001B2D4.s.o(.text); build/asm/main_8001B2D4.s.o(.rodata); build/asm/main_8001B2D4.s.o(.data); }
    .main_8001B2D4_bss (NOLOAD) : { build/asm/main_8001B2D4.s.o(.bss); }
    .main_8001BC44 0x8001BC44 : AT(0x0001C844) { FILL(0x00000000); build/asm/main_8001BC44.s.o(.text); build/asm/main_8001BC44.s.o(.rodata); build/asm/main_8001BC44.s.o(.data); }
    .main_8001BC44_bss (NOLOAD) : { build/asm/main_8001BC44.s.o(.bss); }
    .main_8001C408 0x8001C408 : AT(0x0001D008) { FILL(0x00000000); build/asm/main_8001C408.s.o(.text); build/asm/main_8001C408.s.o(.rodata); build/asm/main_8001C408.s.o(.data); }
    .main_8001C408_bss (NOLOAD) : { build/asm/main_8001C408.s.o(.bss); }
    .main_8001CFA8 0x8001CFA8 : AT(0x0001DBA8) { FILL(0x00000000); build/asm/main_8001CFA8.s.o(.text); build/asm/main_8001CFA8.s.o(.rodata); build/asm/main_8001CFA8.s.o(.data); }
    .main_8001CFA8_bss (NOLOAD) : { build/asm/main_8001CFA8.s.o(.bss); }
    .main_8001D40C 0x8001D40C : AT(0x0001E00C) { FILL(0x00000000); build/asm/main_8001D40C.s.o(.text); build/asm/main_8001D40C.s.o(.rodata); build/asm/main_8001D40C.s.o(.data); }
    .main_8001D40C_bss (NOLOAD) : { build/asm/main_8001D40C.s.o(.bss); }
    .main_8001E6F0 0x8001E6F0 : AT(0x0001F2F0) { FILL(0x00000000); build/asm/main_8001E6F0.s.o(.text); build/asm/main_8001E6F0.s.o(.rodata); build/asm/main_8001E6F0.s.o(.data); }
    .main_8001E6F0_bss (NOLOAD) : { build/asm/main_8001E6F0.s.o(.bss); }
    .main_8001E968 0x8001E968 : AT(0x0001F568) { FILL(0x00000000); build/asm/main_8001E968.s.o(.text); build/asm/main_8001E968.s.o(.rodata); build/asm/main_8001E968.s.o(.data); }
    .main_8001E968_bss (NOLOAD) : { build/asm/main_8001E968.s.o(.bss); }
    .main_8001F11C 0x8001F11C : AT(0x0001FD1C) { FILL(0x00000000); build/asm/main_8001F11C.s.o(.text); build/asm/main_8001F11C.s.o(.rodata); build/asm/main_8001F11C.s.o(.data); }
    .main_8001F11C_bss (NOLOAD) : { build/asm/main_8001F11C.s.o(.bss); }
    .main_8005D9AC 0x8005D9AC : AT(0x0005E5AC) { FILL(0x00000000); build/asm/main_8005D9AC.s.o(.text); build/asm/main_8005D9AC.s.o(.rodata); build/asm/main_8005D9AC.s.o(.data); }
    .main_8005D9AC_bss (NOLOAD) : { build/asm/main_8005D9AC.s.o(.bss); }
    .main_80066720 0x80066720 : AT(0x00067320) { FILL(0x00000000); build/asm/main_80066720.s.o(.text); build/asm/main_80066720.s.o(.rodata); build/asm/main_80066720.s.o(.data); }
    .main_80066720_bss (NOLOAD) : { build/asm/main_80066720.s.o(.bss); }
    .main_8006CFA0 0x8006CFA0 : AT(0x0006DBA0) { FILL(0x00000000); build/asm/main_8006CFA0.s.o(.text); build/asm/main_8006CFA0.s.o(.rodata); build/asm/main_8006CFA0.s.o(.data); }
    .main_8006CFA0_bss (NOLOAD) : { build/asm/main_8006CFA0.s.o(.bss); }
    .main_8006E7D0 0x8006E7D0 : AT(0x0006F3D0) { FILL(0x00000000); build/asm/main_8006E7D0.s.o(.text); build/asm/main_8006E7D0.s.o(.rodata); build/asm/main_8006E7D0.s.o(.data); }
    .main_8006E7D0_bss (NOLOAD) : { build/asm/main_8006E7D0.s.o(.bss); }
    .main_800720B4 0x800720B4 : AT(0x00072CB4) { FILL(0x00000000); build/asm/main_800720B4.s.o(.text); build/asm/main_800720B4.s.o(.rodata); build/asm/main_800720B4.s.o(.data); }
    .main_800720B4_bss (NOLOAD) : { build/asm/main_800720B4.s.o(.bss); }
    .main_80072FA4 0x80072FA4 : AT(0x00073BA4) { FILL(0x00000000); build/asm/main_80072FA4.s.o(.text); build/asm/main_80072FA4.s.o(.rodata); build/asm/main_80072FA4.s.o(.data); }
    .main_80072FA4_bss (NOLOAD) : { build/asm/main_80072FA4.s.o(.bss); }
    .main_80074304 0x80074304 : AT(0x00074F04) { FILL(0x00000000); build/asm/main_80074304.s.o(.text); build/asm/main_80074304.s.o(.rodata); build/asm/main_80074304.s.o(.data); }
    .main_80074304_bss (NOLOAD) : { build/asm/main_80074304.s.o(.bss); }
    .main_800746D0 0x800746D0 : AT(0x000752D0) { FILL(0x00000000); build/asm/main_800746D0.s.o(.text); build/asm/main_800746D0.s.o(.rodata); build/asm/main_800746D0.s.o(.data); }
    .main_800746D0_bss (NOLOAD) : { build/asm/main_800746D0.s.o(.bss); }
    .main_80074EE4 0x80074EE4 : AT(0x00075AE4) { FILL(0x00000000); build/asm/main_80074EE4.s.o(.text); build/asm/main_80074EE4.s.o(.rodata); build/asm/main_80074EE4.s.o(.data); }
    .main_80074EE4_bss (NOLOAD) : { build/asm/main_80074EE4.s.o(.bss); }
    .main_800752C0 0x800752C0 : AT(0x00075EC0) { FILL(0x00000000); build/asm/main_800752C0.s.o(.text); build/asm/main_800752C0.s.o(.rodata); build/asm/main_800752C0.s.o(.data); }
    .main_800752C0_bss (NOLOAD) : { build/asm/main_800752C0.s.o(.bss); }
    .main_80075750 0x80075750 : AT(0x00076350) { FILL(0x00000000); build/asm/main_80075750.s.o(.text); build/asm/main_80075750.s.o(.rodata); build/asm/main_80075750.s.o(.data); }
    .main_80075750_bss (NOLOAD) : { build/asm/main_80075750.s.o(.bss); }
    .main_80077C10 0x80077C10 : AT(0x00078810) { FILL(0x00000000); build/asm/main_80077C10.s.o(.text); build/asm/main_80077C10.s.o(.rodata); build/asm/main_80077C10.s.o(.data); }
    .main_80077C10_bss (NOLOAD) : { build/asm/main_80077C10.s.o(.bss); }
    .main_80078190 0x80078190 : AT(0x00078D90) { FILL(0x00000000); build/asm/main_80078190.s.o(.text); build/asm/main_80078190.s.o(.rodata); build/asm/main_80078190.s.o(.data); }
    .main_80078190_bss (NOLOAD) : { build/asm/main_80078190.s.o(.bss); }
    .main_80078760 0x80078760 : AT(0x00079360) { FILL(0x00000000); build/asm/main_80078760.s.o(.text); build/asm/main_80078760.s.o(.rodata); build/asm/main_80078760.s.o(.data); }
    .main_80078760_bss (NOLOAD) : { build/asm/main_80078760.s.o(.bss); }
    .main_80078A88 0x80078A88 : AT(0x00079688) { FILL(0x00000000); build/asm/main_80078A88.s.o(.text); build/asm/main_80078A88.s.o(.rodata); build/asm/main_80078A88.s.o(.data); }
    .main_80078A88_bss (NOLOAD) : { build/asm/main_80078A88.s.o(.bss); }
    .main_800796C0 0x800796C0 : AT(0x0007A2C0) { FILL(0x00000000); build/asm/main_800796C0.s.o(.text); build/asm/main_800796C0.s.o(.rodata); build/asm/main_800796C0.s.o(.data); }
    .main_800796C0_bss (NOLOAD) : { build/asm/main_800796C0.s.o(.bss); }
    .main_800797D0 0x800797D0 : AT(0x0007A3D0) { FILL(0x00000000); build/asm/main_800797D0.s.o(.text); build/asm/main_800797D0.s.o(.rodata); build/asm/main_800797D0.s.o(.data); }
    .main_800797D0_bss (NOLOAD) : { build/asm/main_800797D0.s.o(.bss); }
    .main_80079890 0x80079890 : AT(0x0007A490) { FILL(0x00000000); build/asm/main_80079890.s.o(.text); build/asm/main_80079890.s.o(.rodata); build/asm/main_80079890.s.o(.data); }
    .main_80079890_bss (NOLOAD) : { build/asm/main_80079890.s.o(.bss); }
    .main_8007A288 0x8007A288 : AT(0x0007AE88) { FILL(0x00000000); build/asm/main_8007A288.s.o(.text); build/asm/main_8007A288.s.o(.rodata); build/asm/main_8007A288.s.o(.data); }
    .main_8007A288_bss (NOLOAD) : { build/asm/main_8007A288.s.o(.bss); }
    .main_8007D4C0 0x8007D4C0 : AT(0x0007E0C0) { FILL(0x00000000); build/asm/main_8007D4C0.s.o(.text); build/asm/main_8007D4C0.s.o(.rodata); build/asm/main_8007D4C0.s.o(.data); }
    .main_8007D4C0_bss (NOLOAD) : { build/asm/main_8007D4C0.s.o(.bss); }
    .main_8007EF10 0x8007EF10 : AT(0x0007FB10) { FILL(0x00000000); build/asm/main_8007EF10.s.o(.text); build/asm/main_8007EF10.s.o(.rodata); build/asm/main_8007EF10.s.o(.data); }
    .main_8007EF10_bss (NOLOAD) : { build/asm/main_8007EF10.s.o(.bss); }
    .main_800809F4 0x800809F4 : AT(0x000815F4) { FILL(0x00000000); build/asm/main_800809F4.s.o(.text); build/asm/main_800809F4.s.o(.rodata); build/asm/main_800809F4.s.o(.data); }
    .main_800809F4_bss (NOLOAD) : { build/asm/main_800809F4.s.o(.bss); }
    .main_800817E8 0x800817E8 : AT(0x000823E8) { FILL(0x00000000); build/asm/main_800817E8.s.o(.text); build/asm/main_800817E8.s.o(.rodata); build/asm/main_800817E8.s.o(.data); }
    .main_800817E8_bss (NOLOAD) : { build/asm/main_800817E8.s.o(.bss); }
    .main_8008369C 0x8008369C : AT(0x0008429C) { FILL(0x00000000); build/asm/main_8008369C.s.o(.text); build/asm/main_8008369C.s.o(.rodata); build/asm/main_8008369C.s.o(.data); }
    .main_8008369C_bss (NOLOAD) : { build/asm/main_8008369C.s.o(.bss); }
    .main_80088740 0x80088740 : AT(0x00089340) { FILL(0x00000000); build/asm/main_80088740.s.o(.text); build/asm/main_80088740.s.o(.rodata); build/asm/main_80088740.s.o(.data); }
    .main_80088740_bss (NOLOAD) : { build/asm/main_80088740.s.o(.bss); }
    .main_8008AA40 0x8008AA40 : AT(0x0008B640) { FILL(0x00000000); build/asm/main_8008AA40.s.o(.text); build/asm/main_8008AA40.s.o(.rodata); build/asm/main_8008AA40.s.o(.data); }
    .main_8008AA40_bss (NOLOAD) : { build/asm/main_8008AA40.s.o(.bss); }
    .main_8008B550 0x8008B550 : AT(0x0008C150) { FILL(0x00000000); build/asm/main_8008B550.s.o(.text); build/asm/main_8008B550.s.o(.rodata); build/asm/main_8008B550.s.o(.data); }
    .main_8008B550_bss (NOLOAD) : { build/asm/main_8008B550.s.o(.bss); }
    .main_8008B690 0x8008B690 : AT(0x0008C290) { FILL(0x00000000); build/asm/data/main_8008B690.data.s.o(.data); }
    .main_800907B4 0x800907B4 : AT(0x000913B4) { FILL(0x00000000); build/asm/main_800907B4.s.o(.text); build/asm/main_800907B4.s.o(.rodata); build/asm/main_800907B4.s.o(.data); }
    .main_800907B4_bss (NOLOAD) : { build/asm/main_800907B4.s.o(.bss); }
    .main_80090854 0x80090854 : AT(0x00091454) { FILL(0x00000000); build/asm/data/main_80090854.data.s.o(.data); }
    .main_80092CCC 0x80092CCC : AT(0x000938CC) { FILL(0x00000000); build/asm/data/main_80092CCC.data.s.o(.data); }
    .main_800A5A50 0x800A5A50 : AT(0x000A6650) { FILL(0x00000000); build/asm/data/main_800A5A50.data.s.o(.data); }
    .main_800ABB68 0x800ABB68 : AT(0x000AC768) { FILL(0x00000000); build/asm/main_800ABB68.s.o(.text); build/asm/main_800ABB68.s.o(.rodata); build/asm/main_800ABB68.s.o(.data); }
    .main_800ABB68_bss (NOLOAD) : { build/asm/main_800ABB68.s.o(.bss); }
    .main_800ABB6C 0x800ABB6C : AT(0x000AC76C) { FILL(0x00000000); build/asm/data/main_800ABB6C.data.s.o(.data); }
    .main_800ADC80 0x800ADC80 : AT(0x000AE880) { FILL(0x00000000); build/asm/main_800ADC80.s.o(.text); build/asm/main_800ADC80.s.o(.rodata); build/asm/main_800ADC80.s.o(.data); }
    .main_800ADC80_bss (NOLOAD) : { build/asm/main_800ADC80.s.o(.bss); }
    .main_800ADD28 0x800ADD28 : AT(0x000AE928) { FILL(0x00000000); build/asm/data/main_800ADD28.data.s.o(.data); }
    .main_800B51E8 0x800B51E8 : AT(0x000B5DE8) { FILL(0x00000000); build/asm/main_800B51E8.s.o(.text); build/asm/main_800B51E8.s.o(.rodata); build/asm/main_800B51E8.s.o(.data); }
    .main_800B51E8_bss (NOLOAD) : { build/asm/main_800B51E8.s.o(.bss); }
    .main_800B51FC 0x800B51FC : AT(0x000B5DFC) { FILL(0x00000000); build/asm/data/main_800B51FC.data.s.o(.data); }
    .main_800B52F8 0x800B52F8 : AT(0x000B5EF8) { FILL(0x00000000); build/asm/main_800B52F8.s.o(.text); build/asm/main_800B52F8.s.o(.rodata); build/asm/main_800B52F8.s.o(.data); }
    .main_800B52F8_bss (NOLOAD) : { build/asm/main_800B52F8.s.o(.bss); }
    .main_800B530C 0x800B530C : AT(0x000B5F0C) { FILL(0x00000000); build/asm/data/main_800B530C.data.s.o(.data); }
    .main_800C3EDC 0x800C3EDC : AT(0x000C4ADC) { FILL(0x00000000); build/asm/main_800C3EDC.s.o(.text); build/asm/main_800C3EDC.s.o(.rodata); build/asm/main_800C3EDC.s.o(.data); }
    .main_800C3EDC_bss (NOLOAD) : { build/asm/main_800C3EDC.s.o(.bss); }
    .main_800C3EF4 0x800C3EF4 : AT(0x000C4AF4) { FILL(0x00000000); build/asm/data/main_800C3EF4.data.s.o(.data); }
    .main_800C3F0C 0x800C3F0C : AT(0x000C4B0C) { FILL(0x00000000); build/asm/main_800C3F0C.s.o(.text); build/asm/main_800C3F0C.s.o(.rodata); build/asm/main_800C3F0C.s.o(.data); }
    .main_800C3F0C_bss (NOLOAD) : { build/asm/main_800C3F0C.s.o(.bss); }
    .main_800C3F18 0x800C3F18 : AT(0x000C4B18) { FILL(0x00000000); build/asm/data/main_800C3F18.data.s.o(.data); }
    .main_800CDD60 0x800CDD60 : AT(0x000CE960) { FILL(0x00000000); build/asm/main_800CDD60.s.o(.text); build/asm/main_800CDD60.s.o(.rodata); build/asm/main_800CDD60.s.o(.data); }
    .main_800CDD60_bss (NOLOAD) : { build/asm/main_800CDD60.s.o(.bss); }
    .main_800CDD90 0x800CDD90 : AT(0x000CE990) { FILL(0x00000000); build/asm/data/main_800CDD90.data.s.o(.data); }
    .main_800E4320 0x800E4320 : AT(0x000E4F20) { FILL(0x00000000); build/asm/main_800E4320.s.o(.text); build/asm/main_800E4320.s.o(.rodata); build/asm/main_800E4320.s.o(.data); }
    .main_800E4320_bss (NOLOAD) : { build/asm/main_800E4320.s.o(.bss); }
    .main_800E432C 0x800E432C : AT(0x000E4F2C) { FILL(0x00000000); build/asm/data/main_800E432C.data.s.o(.data); }
    .main_800E4668 0x800E4668 : AT(0x000E5268) { FILL(0x00000000); build/asm/main_800E4668.s.o(.text); build/asm/main_800E4668.s.o(.rodata); build/asm/main_800E4668.s.o(.data); }
    .main_800E4668_bss (NOLOAD) : { build/asm/main_800E4668.s.o(.bss); }
    .main_800E4674 0x800E4674 : AT(0x000E5274) { FILL(0x00000000); build/asm/data/main_800E4674.data.s.o(.data); }
    .main_800E64D0 0x800E64D0 : AT(0x000E70D0) { FILL(0x00000000); build/asm/main_800E64D0.s.o(.text); build/asm/main_800E64D0.s.o(.rodata); build/asm/main_800E64D0.s.o(.data); }
    .main_800E64D0_bss (NOLOAD) : { build/asm/main_800E64D0.s.o(.bss); }
    .main_800E65C0 0x800E65C0 : AT(0x000E71C0) { FILL(0x00000000); build/asm/data/main_800E65C0.data.s.o(.data); }
    .main_800F0FAC 0x800F0FAC : AT(0x000F1BAC) { FILL(0x00000000); build/asm/data/main_800F0FAC.data.s.o(.data); }
    .main_800F2BF0 0x800F2BF0 : AT(0x000F37F0) { FILL(0x00000000); build/asm/data/main_800F2BF0.data.s.o(.data); }
    .main_800F7244 0x800F7244 : AT(0x000F7E44) { FILL(0x00000000); build/asm/data/main_800F7244.data.s.o(.data); }
    .main_800FC454 0x800FC454 : AT(0x000FD054) { FILL(0x00000000); build/asm/data/main_800FC454.data.s.o(.data); }
    .main_800FE9D4 0x800FE9D4 : AT(0x000FF5D4) { FILL(0x00000000); build/asm/main_800FE9D4.s.o(.text); build/asm/main_800FE9D4.s.o(.rodata); build/asm/main_800FE9D4.s.o(.data); }
    .main_800FE9D4_bss (NOLOAD) : { build/asm/main_800FE9D4.s.o(.bss); }
    .main_800FEB04 0x800FEB04 : AT(0x000FF704) { FILL(0x00000000); build/asm/data/main_800FEB04.data.s.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
