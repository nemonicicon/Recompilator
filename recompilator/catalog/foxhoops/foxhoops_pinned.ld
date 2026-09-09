SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80006FB0 0x80006FB0 : AT(0x00007BB0) { FILL(0x00000000); build/asm/main_80006FB0.s.o(.text); build/asm/main_80006FB0.s.o(.rodata); build/asm/main_80006FB0.s.o(.data); }
    .main_80006FB0_bss (NOLOAD) : { build/asm/main_80006FB0.s.o(.bss); }
    .main_80007450 0x80007450 : AT(0x00008050) { FILL(0x00000000); build/asm/main_80007450.s.o(.text); build/asm/main_80007450.s.o(.rodata); build/asm/main_80007450.s.o(.data); }
    .main_80007450_bss (NOLOAD) : { build/asm/main_80007450.s.o(.bss); }
    .main_80026C68 0x80026C68 : AT(0x00027868) { FILL(0x00000000); build/asm/main_80026C68.s.o(.text); build/asm/main_80026C68.s.o(.rodata); build/asm/main_80026C68.s.o(.data); }
    .main_80026C68_bss (NOLOAD) : { build/asm/main_80026C68.s.o(.bss); }
    .main_80027080 0x80027080 : AT(0x00027C80) { FILL(0x00000000); build/asm/main_80027080.s.o(.text); build/asm/main_80027080.s.o(.rodata); build/asm/main_80027080.s.o(.data); }
    .main_80027080_bss (NOLOAD) : { build/asm/main_80027080.s.o(.bss); }
    .main_80031070 0x80031070 : AT(0x00031C70) { FILL(0x00000000); build/asm/main_80031070.s.o(.text); build/asm/main_80031070.s.o(.rodata); build/asm/main_80031070.s.o(.data); }
    .main_80031070_bss (NOLOAD) : { build/asm/main_80031070.s.o(.bss); }
    .main_8003126C 0x8003126C : AT(0x00031E6C) { FILL(0x00000000); build/asm/main_8003126C.s.o(.text); build/asm/main_8003126C.s.o(.rodata); build/asm/main_8003126C.s.o(.data); }
    .main_8003126C_bss (NOLOAD) : { build/asm/main_8003126C.s.o(.bss); }
    .main_8003CFB0 0x8003CFB0 : AT(0x0003DBB0) { FILL(0x00000000); build/asm/main_8003CFB0.s.o(.text); build/asm/main_8003CFB0.s.o(.rodata); build/asm/main_8003CFB0.s.o(.data); }
    .main_8003CFB0_bss (NOLOAD) : { build/asm/main_8003CFB0.s.o(.bss); }
    .main_8005B004 0x8005B004 : AT(0x0005BC04) { FILL(0x00000000); build/asm/main_8005B004.s.o(.text); build/asm/main_8005B004.s.o(.rodata); build/asm/main_8005B004.s.o(.data); }
    .main_8005B004_bss (NOLOAD) : { build/asm/main_8005B004.s.o(.bss); }
    .main_80062038 0x80062038 : AT(0x00062C38) { FILL(0x00000000); build/asm/main_80062038.s.o(.text); build/asm/main_80062038.s.o(.rodata); build/asm/main_80062038.s.o(.data); }
    .main_80062038_bss (NOLOAD) : { build/asm/main_80062038.s.o(.bss); }
    .main_80062EF8 0x80062EF8 : AT(0x00063AF8) { FILL(0x00000000); build/asm/main_80062EF8.s.o(.text); build/asm/main_80062EF8.s.o(.rodata); build/asm/main_80062EF8.s.o(.data); }
    .main_80062EF8_bss (NOLOAD) : { build/asm/main_80062EF8.s.o(.bss); }
    .main_800646E4 0x800646E4 : AT(0x000652E4) { FILL(0x00000000); build/asm/main_800646E4.s.o(.text); build/asm/main_800646E4.s.o(.rodata); build/asm/main_800646E4.s.o(.data); }
    .main_800646E4_bss (NOLOAD) : { build/asm/main_800646E4.s.o(.bss); }
    .main_80064F30 0x80064F30 : AT(0x00065B30) { FILL(0x00000000); build/asm/main_80064F30.s.o(.text); build/asm/main_80064F30.s.o(.rodata); build/asm/main_80064F30.s.o(.data); }
    .main_80064F30_bss (NOLOAD) : { build/asm/main_80064F30.s.o(.bss); }
    .main_8006CA68 0x8006CA68 : AT(0x0006D668) { FILL(0x00000000); build/asm/main_8006CA68.s.o(.text); build/asm/main_8006CA68.s.o(.rodata); build/asm/main_8006CA68.s.o(.data); }
    .main_8006CA68_bss (NOLOAD) : { build/asm/main_8006CA68.s.o(.bss); }
    .main_80079DF0 0x80079DF0 : AT(0x0007A9F0) { FILL(0x00000000); build/asm/main_80079DF0.s.o(.text); build/asm/main_80079DF0.s.o(.rodata); build/asm/main_80079DF0.s.o(.data); }
    .main_80079DF0_bss (NOLOAD) : { build/asm/main_80079DF0.s.o(.bss); }
    .main_80079F90 0x80079F90 : AT(0x0007AB90) { FILL(0x00000000); build/asm/main_80079F90.s.o(.text); build/asm/main_80079F90.s.o(.rodata); build/asm/main_80079F90.s.o(.data); }
    .main_80079F90_bss (NOLOAD) : { build/asm/main_80079F90.s.o(.bss); }
    .main_8007A624 0x8007A624 : AT(0x0007B224) { FILL(0x00000000); build/asm/main_8007A624.s.o(.text); build/asm/main_8007A624.s.o(.rodata); build/asm/main_8007A624.s.o(.data); }
    .main_8007A624_bss (NOLOAD) : { build/asm/main_8007A624.s.o(.bss); }
    .main_8007AA60 0x8007AA60 : AT(0x0007B660) { FILL(0x00000000); build/asm/main_8007AA60.s.o(.text); build/asm/main_8007AA60.s.o(.rodata); build/asm/main_8007AA60.s.o(.data); }
    .main_8007AA60_bss (NOLOAD) : { build/asm/main_8007AA60.s.o(.bss); }
    .main_8007B580 0x8007B580 : AT(0x0007C180) { FILL(0x00000000); build/asm/main_8007B580.s.o(.text); build/asm/main_8007B580.s.o(.rodata); build/asm/main_8007B580.s.o(.data); }
    .main_8007B580_bss (NOLOAD) : { build/asm/main_8007B580.s.o(.bss); }
    .main_8007BA18 0x8007BA18 : AT(0x0007C618) { FILL(0x00000000); build/asm/main_8007BA18.s.o(.text); build/asm/main_8007BA18.s.o(.rodata); build/asm/main_8007BA18.s.o(.data); }
    .main_8007BA18_bss (NOLOAD) : { build/asm/main_8007BA18.s.o(.bss); }
    .main_8007C360 0x8007C360 : AT(0x0007CF60) { FILL(0x00000000); build/asm/main_8007C360.s.o(.text); build/asm/main_8007C360.s.o(.rodata); build/asm/main_8007C360.s.o(.data); }
    .main_8007C360_bss (NOLOAD) : { build/asm/main_8007C360.s.o(.bss); }
    .main_8007C8F0 0x8007C8F0 : AT(0x0007D4F0) { FILL(0x00000000); build/asm/main_8007C8F0.s.o(.text); build/asm/main_8007C8F0.s.o(.rodata); build/asm/main_8007C8F0.s.o(.data); }
    .main_8007C8F0_bss (NOLOAD) : { build/asm/main_8007C8F0.s.o(.bss); }
    .main_8007D000 0x8007D000 : AT(0x0007DC00) { FILL(0x00000000); build/asm/main_8007D000.s.o(.text); build/asm/main_8007D000.s.o(.rodata); build/asm/main_8007D000.s.o(.data); }
    .main_8007D000_bss (NOLOAD) : { build/asm/main_8007D000.s.o(.bss); }
    .main_8007D230 0x8007D230 : AT(0x0007DE30) { FILL(0x00000000); build/asm/main_8007D230.s.o(.text); build/asm/main_8007D230.s.o(.rodata); build/asm/main_8007D230.s.o(.data); }
    .main_8007D230_bss (NOLOAD) : { build/asm/main_8007D230.s.o(.bss); }
    .main_8007D430 0x8007D430 : AT(0x0007E030) { FILL(0x00000000); build/asm/main_8007D430.s.o(.text); build/asm/main_8007D430.s.o(.rodata); build/asm/main_8007D430.s.o(.data); }
    .main_8007D430_bss (NOLOAD) : { build/asm/main_8007D430.s.o(.bss); }
    .main_8007D820 0x8007D820 : AT(0x0007E420) { FILL(0x00000000); build/asm/main_8007D820.s.o(.text); build/asm/main_8007D820.s.o(.rodata); build/asm/main_8007D820.s.o(.data); }
    .main_8007D820_bss (NOLOAD) : { build/asm/main_8007D820.s.o(.bss); }
    .main_8007DB00 0x8007DB00 : AT(0x0007E700) { FILL(0x00000000); build/asm/main_8007DB00.s.o(.text); build/asm/main_8007DB00.s.o(.rodata); build/asm/main_8007DB00.s.o(.data); }
    .main_8007DB00_bss (NOLOAD) : { build/asm/main_8007DB00.s.o(.bss); }
    .main_8007DBF4 0x8007DBF4 : AT(0x0007E7F4) { FILL(0x00000000); build/asm/main_8007DBF4.s.o(.text); build/asm/main_8007DBF4.s.o(.rodata); build/asm/main_8007DBF4.s.o(.data); }
    .main_8007DBF4_bss (NOLOAD) : { build/asm/main_8007DBF4.s.o(.bss); }
    .main_8007E1C0 0x8007E1C0 : AT(0x0007EDC0) { FILL(0x00000000); build/asm/main_8007E1C0.s.o(.text); build/asm/main_8007E1C0.s.o(.rodata); build/asm/main_8007E1C0.s.o(.data); }
    .main_8007E1C0_bss (NOLOAD) : { build/asm/main_8007E1C0.s.o(.bss); }
    .main_8007EB80 0x8007EB80 : AT(0x0007F780) { FILL(0x00000000); build/asm/main_8007EB80.s.o(.text); build/asm/main_8007EB80.s.o(.rodata); build/asm/main_8007EB80.s.o(.data); }
    .main_8007EB80_bss (NOLOAD) : { build/asm/main_8007EB80.s.o(.bss); }
    .main_8007F420 0x8007F420 : AT(0x00080020) { FILL(0x00000000); build/asm/main_8007F420.s.o(.text); build/asm/main_8007F420.s.o(.rodata); build/asm/main_8007F420.s.o(.data); }
    .main_8007F420_bss (NOLOAD) : { build/asm/main_8007F420.s.o(.bss); }
    .main_80080080 0x80080080 : AT(0x00080C80) { FILL(0x00000000); build/asm/main_80080080.s.o(.text); build/asm/main_80080080.s.o(.rodata); build/asm/main_80080080.s.o(.data); }
    .main_80080080_bss (NOLOAD) : { build/asm/main_80080080.s.o(.bss); }
    .main_80080B60 0x80080B60 : AT(0x00081760) { FILL(0x00000000); build/asm/main_80080B60.s.o(.text); build/asm/main_80080B60.s.o(.rodata); build/asm/main_80080B60.s.o(.data); }
    .main_80080B60_bss (NOLOAD) : { build/asm/main_80080B60.s.o(.bss); }
    .main_80081CD0 0x80081CD0 : AT(0x000828D0) { FILL(0x00000000); build/asm/main_80081CD0.s.o(.text); build/asm/main_80081CD0.s.o(.rodata); build/asm/main_80081CD0.s.o(.data); }
    .main_80081CD0_bss (NOLOAD) : { build/asm/main_80081CD0.s.o(.bss); }
    .main_80082820 0x80082820 : AT(0x00083420) { FILL(0x00000000); build/asm/main_80082820.s.o(.text); build/asm/main_80082820.s.o(.rodata); build/asm/main_80082820.s.o(.data); }
    .main_80082820_bss (NOLOAD) : { build/asm/main_80082820.s.o(.bss); }
    .main_80082DA0 0x80082DA0 : AT(0x000839A0) { FILL(0x00000000); build/asm/main_80082DA0.s.o(.text); build/asm/main_80082DA0.s.o(.rodata); build/asm/main_80082DA0.s.o(.data); }
    .main_80082DA0_bss (NOLOAD) : { build/asm/main_80082DA0.s.o(.bss); }
    .main_80083370 0x80083370 : AT(0x00083F70) { FILL(0x00000000); build/asm/main_80083370.s.o(.text); build/asm/main_80083370.s.o(.rodata); build/asm/main_80083370.s.o(.data); }
    .main_80083370_bss (NOLOAD) : { build/asm/main_80083370.s.o(.bss); }
    .main_80083698 0x80083698 : AT(0x00084298) { FILL(0x00000000); build/asm/main_80083698.s.o(.text); build/asm/main_80083698.s.o(.rodata); build/asm/main_80083698.s.o(.data); }
    .main_80083698_bss (NOLOAD) : { build/asm/main_80083698.s.o(.bss); }
    .main_800842D0 0x800842D0 : AT(0x00084ED0) { FILL(0x00000000); build/asm/main_800842D0.s.o(.text); build/asm/main_800842D0.s.o(.rodata); build/asm/main_800842D0.s.o(.data); }
    .main_800842D0_bss (NOLOAD) : { build/asm/main_800842D0.s.o(.bss); }
    .main_800843E0 0x800843E0 : AT(0x00084FE0) { FILL(0x00000000); build/asm/main_800843E0.s.o(.text); build/asm/main_800843E0.s.o(.rodata); build/asm/main_800843E0.s.o(.data); }
    .main_800843E0_bss (NOLOAD) : { build/asm/main_800843E0.s.o(.bss); }
    .main_800845F0 0x800845F0 : AT(0x000851F0) { FILL(0x00000000); build/asm/main_800845F0.s.o(.text); build/asm/main_800845F0.s.o(.rodata); build/asm/main_800845F0.s.o(.data); }
    .main_800845F0_bss (NOLOAD) : { build/asm/main_800845F0.s.o(.bss); }
    .main_800847E0 0x800847E0 : AT(0x000853E0) { FILL(0x00000000); build/asm/main_800847E0.s.o(.text); build/asm/main_800847E0.s.o(.rodata); build/asm/main_800847E0.s.o(.data); }
    .main_800847E0_bss (NOLOAD) : { build/asm/main_800847E0.s.o(.bss); }
    .main_80084EA0 0x80084EA0 : AT(0x00085AA0) { FILL(0x00000000); build/asm/main_80084EA0.s.o(.text); build/asm/main_80084EA0.s.o(.rodata); build/asm/main_80084EA0.s.o(.data); }
    .main_80084EA0_bss (NOLOAD) : { build/asm/main_80084EA0.s.o(.bss); }
    .main_80084ED0 0x80084ED0 : AT(0x00085AD0) { FILL(0x00000000); build/asm/main_80084ED0.s.o(.text); build/asm/main_80084ED0.s.o(.rodata); build/asm/main_80084ED0.s.o(.data); }
    .main_80084ED0_bss (NOLOAD) : { build/asm/main_80084ED0.s.o(.bss); }
    .main_80085070 0x80085070 : AT(0x00085C70) { FILL(0x00000000); build/asm/main_80085070.s.o(.text); build/asm/main_80085070.s.o(.rodata); build/asm/main_80085070.s.o(.data); }
    .main_80085070_bss (NOLOAD) : { build/asm/main_80085070.s.o(.bss); }
    .main_800853F0 0x800853F0 : AT(0x00085FF0) { FILL(0x00000000); build/asm/main_800853F0.s.o(.text); build/asm/main_800853F0.s.o(.rodata); build/asm/main_800853F0.s.o(.data); }
    .main_800853F0_bss (NOLOAD) : { build/asm/main_800853F0.s.o(.bss); }
    .main_800856A0 0x800856A0 : AT(0x000862A0) { FILL(0x00000000); build/asm/main_800856A0.s.o(.text); build/asm/main_800856A0.s.o(.rodata); build/asm/main_800856A0.s.o(.data); }
    .main_800856A0_bss (NOLOAD) : { build/asm/main_800856A0.s.o(.bss); }
    .main_80086D00 0x80086D00 : AT(0x00087900) { FILL(0x00000000); build/asm/main_80086D00.s.o(.text); build/asm/main_80086D00.s.o(.rodata); build/asm/main_80086D00.s.o(.data); }
    .main_80086D00_bss (NOLOAD) : { build/asm/main_80086D00.s.o(.bss); }
    .main_800881B0 0x800881B0 : AT(0x00088DB0) { FILL(0x00000000); build/asm/main_800881B0.s.o(.text); build/asm/main_800881B0.s.o(.rodata); build/asm/main_800881B0.s.o(.data); }
    .main_800881B0_bss (NOLOAD) : { build/asm/main_800881B0.s.o(.bss); }
    .main_800888D0 0x800888D0 : AT(0x000894D0) { FILL(0x00000000); build/asm/main_800888D0.s.o(.text); build/asm/main_800888D0.s.o(.rodata); build/asm/main_800888D0.s.o(.data); }
    .main_800888D0_bss (NOLOAD) : { build/asm/main_800888D0.s.o(.bss); }
    .main_80088930 0x80088930 : AT(0x00089530) { FILL(0x00000000); build/asm/main_80088930.s.o(.text); build/asm/main_80088930.s.o(.rodata); build/asm/main_80088930.s.o(.data); }
    .main_80088930_bss (NOLOAD) : { build/asm/main_80088930.s.o(.bss); }
    .main_80089334 0x80089334 : AT(0x00089F34) { FILL(0x00000000); build/asm/main_80089334.s.o(.text); build/asm/main_80089334.s.o(.rodata); build/asm/main_80089334.s.o(.data); }
    .main_80089334_bss (NOLOAD) : { build/asm/main_80089334.s.o(.bss); }
    .main_80089690 0x80089690 : AT(0x0008A290) { FILL(0x00000000); build/asm/main_80089690.s.o(.text); build/asm/main_80089690.s.o(.rodata); build/asm/main_80089690.s.o(.data); }
    .main_80089690_bss (NOLOAD) : { build/asm/main_80089690.s.o(.bss); }
    .main_8008AA10 0x8008AA10 : AT(0x0008B610) { FILL(0x00000000); build/asm/main_8008AA10.s.o(.text); build/asm/main_8008AA10.s.o(.rodata); build/asm/main_8008AA10.s.o(.data); }
    .main_8008AA10_bss (NOLOAD) : { build/asm/main_8008AA10.s.o(.bss); }
    .main_8008B1F0 0x8008B1F0 : AT(0x0008BDF0) { build/asm/data/main_8008B1F0.bin.o(.data); }
    .main_80092024 0x80092024 : AT(0x00092C24) { FILL(0x00000000); build/asm/main_80092024.s.o(.text); build/asm/main_80092024.s.o(.rodata); build/asm/main_80092024.s.o(.data); }
    .main_80092024_bss (NOLOAD) : { build/asm/main_80092024.s.o(.bss); }
    .main_80095434 0x80095434 : AT(0x00096034) { FILL(0x00000000); build/asm/main_80095434.s.o(.text); build/asm/main_80095434.s.o(.rodata); build/asm/main_80095434.s.o(.data); }
    .main_80095434_bss (NOLOAD) : { build/asm/main_80095434.s.o(.bss); }
    .main_80096260 0x80096260 : AT(0x00096E60) { FILL(0x00000000); build/asm/main_80096260.s.o(.text); build/asm/main_80096260.s.o(.rodata); build/asm/main_80096260.s.o(.data); }
    .main_80096260_bss (NOLOAD) : { build/asm/main_80096260.s.o(.bss); }
    .main_800968F4 0x800968F4 : AT(0x000974F4) { FILL(0x00000000); build/asm/main_800968F4.s.o(.text); build/asm/main_800968F4.s.o(.rodata); build/asm/main_800968F4.s.o(.data); }
    .main_800968F4_bss (NOLOAD) : { build/asm/main_800968F4.s.o(.bss); }
    .main_80096D28 0x80096D28 : AT(0x00097928) { FILL(0x00000000); build/asm/main_80096D28.s.o(.text); build/asm/main_80096D28.s.o(.rodata); build/asm/main_80096D28.s.o(.data); }
    .main_80096D28_bss (NOLOAD) : { build/asm/main_80096D28.s.o(.bss); }
    .main_80097010 0x80097010 : AT(0x00097C10) { FILL(0x00000000); build/asm/main_80097010.s.o(.text); build/asm/main_80097010.s.o(.rodata); build/asm/main_80097010.s.o(.data); }
    .main_80097010_bss (NOLOAD) : { build/asm/main_80097010.s.o(.bss); }
    .main_80097144 0x80097144 : AT(0x00097D44) { FILL(0x00000000); build/asm/main_80097144.s.o(.text); build/asm/main_80097144.s.o(.rodata); build/asm/main_80097144.s.o(.data); }
    .main_80097144_bss (NOLOAD) : { build/asm/main_80097144.s.o(.bss); }
    .main_80097480 0x80097480 : AT(0x00098080) { FILL(0x00000000); build/asm/main_80097480.s.o(.text); build/asm/main_80097480.s.o(.rodata); build/asm/main_80097480.s.o(.data); }
    .main_80097480_bss (NOLOAD) : { build/asm/main_80097480.s.o(.bss); }
    .main_800978A0 0x800978A0 : AT(0x000984A0) { FILL(0x00000000); build/asm/main_800978A0.s.o(.text); build/asm/main_800978A0.s.o(.rodata); build/asm/main_800978A0.s.o(.data); }
    .main_800978A0_bss (NOLOAD) : { build/asm/main_800978A0.s.o(.bss); }
    .main_80097C3C 0x80097C3C : AT(0x0009883C) { FILL(0x00000000); build/asm/main_80097C3C.s.o(.text); build/asm/main_80097C3C.s.o(.rodata); build/asm/main_80097C3C.s.o(.data); }
    .main_80097C3C_bss (NOLOAD) : { build/asm/main_80097C3C.s.o(.bss); }
    .main_8009B450 0x8009B450 : AT(0x0009C050) { FILL(0x00000000); build/asm/main_8009B450.s.o(.text); build/asm/main_8009B450.s.o(.rodata); build/asm/main_8009B450.s.o(.data); }
    .main_8009B450_bss (NOLOAD) : { build/asm/main_8009B450.s.o(.bss); }
    .main_8009B548 0x8009B548 : AT(0x0009C148) { FILL(0x00000000); build/asm/main_8009B548.s.o(.text); build/asm/main_8009B548.s.o(.rodata); build/asm/main_8009B548.s.o(.data); }
    .main_8009B548_bss (NOLOAD) : { build/asm/main_8009B548.s.o(.bss); }
    .main_8009BF6C 0x8009BF6C : AT(0x0009CB6C) { FILL(0x00000000); build/asm/main_8009BF6C.s.o(.text); build/asm/main_8009BF6C.s.o(.rodata); build/asm/main_8009BF6C.s.o(.data); }
    .main_8009BF6C_bss (NOLOAD) : { build/asm/main_8009BF6C.s.o(.bss); }
    .main_8009C730 0x8009C730 : AT(0x0009D330) { build/asm/data/main_8009C730.bin.o(.data); }
    .main_8009CD08 0x8009CD08 : AT(0x0009D908) { FILL(0x00000000); build/asm/main_8009CD08.s.o(.text); build/asm/main_8009CD08.s.o(.rodata); build/asm/main_8009CD08.s.o(.data); }
    .main_8009CD08_bss (NOLOAD) : { build/asm/main_8009CD08.s.o(.bss); }
    .main_8009D56C 0x8009D56C : AT(0x0009E16C) { build/asm/data/main_8009D56C.bin.o(.data); }
    .main_8009D5F4 0x8009D5F4 : AT(0x0009E1F4) { FILL(0x00000000); build/asm/main_8009D5F4.s.o(.text); build/asm/main_8009D5F4.s.o(.rodata); build/asm/main_8009D5F4.s.o(.data); }
    .main_8009D5F4_bss (NOLOAD) : { build/asm/main_8009D5F4.s.o(.bss); }
    .main_8009D8B4 0x8009D8B4 : AT(0x0009E4B4) { build/asm/data/main_8009D8B4.bin.o(.data); }
    .main_8009D93C 0x8009D93C : AT(0x0009E53C) { FILL(0x00000000); build/asm/main_8009D93C.s.o(.text); build/asm/main_8009D93C.s.o(.rodata); build/asm/main_8009D93C.s.o(.data); }
    .main_8009D93C_bss (NOLOAD) : { build/asm/main_8009D93C.s.o(.bss); }
    .main_8009DB78 0x8009DB78 : AT(0x0009E778) { build/asm/data/main_8009DB78.bin.o(.data); }
    .main_8009DE34 0x8009DE34 : AT(0x0009EA34) { FILL(0x00000000); build/asm/main_8009DE34.s.o(.text); build/asm/main_8009DE34.s.o(.rodata); build/asm/main_8009DE34.s.o(.data); }
    .main_8009DE34_bss (NOLOAD) : { build/asm/main_8009DE34.s.o(.bss); }
    .main_8009DE64 0x8009DE64 : AT(0x0009EA64) { build/asm/data/main_8009DE64.bin.o(.data); }
    .main_8009E558 0x8009E558 : AT(0x0009F158) { FILL(0x00000000); build/asm/main_8009E558.s.o(.text); build/asm/main_8009E558.s.o(.rodata); build/asm/main_8009E558.s.o(.data); }
    .main_8009E558_bss (NOLOAD) : { build/asm/main_8009E558.s.o(.bss); }
    .main_8009F758 0x8009F758 : AT(0x000A0358) { build/asm/data/main_8009F758.bin.o(.data); }
    .main_800A15E0 0x800A15E0 : AT(0x000A21E0) { FILL(0x00000000); build/asm/main_800A15E0.s.o(.text); build/asm/main_800A15E0.s.o(.rodata); build/asm/main_800A15E0.s.o(.data); }
    .main_800A15E0_bss (NOLOAD) : { build/asm/main_800A15E0.s.o(.bss); }
    .main_800A1B5C 0x800A1B5C : AT(0x000A275C) { build/asm/data/main_800A1B5C.bin.o(.data); }
    .main_800A2624 0x800A2624 : AT(0x000A3224) { FILL(0x00000000); build/asm/main_800A2624.s.o(.text); build/asm/main_800A2624.s.o(.rodata); build/asm/main_800A2624.s.o(.data); }
    .main_800A2624_bss (NOLOAD) : { build/asm/main_800A2624.s.o(.bss); }
    .main_800A351C 0x800A351C : AT(0x000A411C) { build/asm/data/main_800A351C.bin.o(.data); }
    .main_800A361C 0x800A361C : AT(0x000A421C) { FILL(0x00000000); build/asm/main_800A361C.s.o(.text); build/asm/main_800A361C.s.o(.rodata); build/asm/main_800A361C.s.o(.data); }
    .main_800A361C_bss (NOLOAD) : { build/asm/main_800A361C.s.o(.bss); }
    .main_800A3814 0x800A3814 : AT(0x000A4414) { FILL(0x00000000); build/asm/main_800A3814.s.o(.text); build/asm/main_800A3814.s.o(.rodata); build/asm/main_800A3814.s.o(.data); }
    .main_800A3814_bss (NOLOAD) : { build/asm/main_800A3814.s.o(.bss); }
    .main_800A5670 0x800A5670 : AT(0x000A6270) { FILL(0x00000000); build/asm/main_800A5670.s.o(.text); build/asm/main_800A5670.s.o(.rodata); build/asm/main_800A5670.s.o(.data); }
    .main_800A5670_bss (NOLOAD) : { build/asm/main_800A5670.s.o(.bss); }
    .main_800A6338 0x800A6338 : AT(0x000A6F38) { FILL(0x00000000); build/asm/main_800A6338.s.o(.text); build/asm/main_800A6338.s.o(.rodata); build/asm/main_800A6338.s.o(.data); }
    .main_800A6338_bss (NOLOAD) : { build/asm/main_800A6338.s.o(.bss); }
    .main_800A6AD0 0x800A6AD0 : AT(0x000A76D0) { build/asm/data/main_800A6AD0.bin.o(.data); }
    .main_800A6D34 0x800A6D34 : AT(0x000A7934) { FILL(0x00000000); build/asm/main_800A6D34.s.o(.text); build/asm/main_800A6D34.s.o(.rodata); build/asm/main_800A6D34.s.o(.data); }
    .main_800A6D34_bss (NOLOAD) : { build/asm/main_800A6D34.s.o(.bss); }
    .main_800A6FE0 0x800A6FE0 : AT(0x000A7BE0) { build/asm/data/main_800A6FE0.bin.o(.data); }
    .main_800A7B68 0x800A7B68 : AT(0x000A8768) { build/asm/data/main_800A7B68.bin.o(.data); }
    .main_800A7C6C 0x800A7C6C : AT(0x000A886C) { FILL(0x00000000); build/asm/main_800A7C6C.s.o(.text); build/asm/main_800A7C6C.s.o(.rodata); build/asm/main_800A7C6C.s.o(.data); }
    .main_800A7C6C_bss (NOLOAD) : { build/asm/main_800A7C6C.s.o(.bss); }
    .main_800A7CAC 0x800A7CAC : AT(0x000A88AC) { build/asm/data/main_800A7CAC.bin.o(.data); }
    .main_800A8378 0x800A8378 : AT(0x000A8F78) { build/asm/data/main_800A8378.bin.o(.data); }
    .main_800A8778 0x800A8778 : AT(0x000A9378) { build/asm/data/main_800A8778.bin.o(.data); }
    .main_800A9BBC 0x800A9BBC : AT(0x000AA7BC) { build/asm/data/main_800A9BBC.bin.o(.data); }
    .main_800AC6B0 0x800AC6B0 : AT(0x000AD2B0) { build/asm/data/main_800AC6B0.bin.o(.data); }
    .main_800AF40C 0x800AF40C : AT(0x000B000C) { build/asm/data/main_800AF40C.bin.o(.data); }
    .main_800B2110 0x800B2110 : AT(0x000B2D10) { FILL(0x00000000); build/asm/main_800B2110.s.o(.text); build/asm/main_800B2110.s.o(.rodata); build/asm/main_800B2110.s.o(.data); }
    .main_800B2110_bss (NOLOAD) : { build/asm/main_800B2110.s.o(.bss); }
    .main_800B23F8 0x800B23F8 : AT(0x000B2FF8) { FILL(0x00000000); build/asm/main_800B23F8.s.o(.text); build/asm/main_800B23F8.s.o(.rodata); build/asm/main_800B23F8.s.o(.data); }
    .main_800B23F8_bss (NOLOAD) : { build/asm/main_800B23F8.s.o(.bss); }
    .main_800B2D30 0x800B2D30 : AT(0x000B3930) { build/asm/data/main_800B2D30.bin.o(.data); }
    .main_800B3778 0x800B3778 : AT(0x000B4378) { FILL(0x00000000); build/asm/main_800B3778.s.o(.text); build/asm/main_800B3778.s.o(.rodata); build/asm/main_800B3778.s.o(.data); }
    .main_800B3778_bss (NOLOAD) : { build/asm/main_800B3778.s.o(.bss); }
    .main_800B47E8 0x800B47E8 : AT(0x000B53E8) { build/asm/data/main_800B47E8.bin.o(.data); }
    .main_800B49A0 0x800B49A0 : AT(0x000B55A0) { FILL(0x00000000); build/asm/main_800B49A0.s.o(.text); build/asm/main_800B49A0.s.o(.rodata); build/asm/main_800B49A0.s.o(.data); }
    .main_800B49A0_bss (NOLOAD) : { build/asm/main_800B49A0.s.o(.bss); }
    .main_800B49E4 0x800B49E4 : AT(0x000B55E4) { build/asm/data/main_800B49E4.bin.o(.data); }
    .main_800B839C 0x800B839C : AT(0x000B8F9C) { build/asm/data/main_800B839C.bin.o(.data); }
    .main_800B9B88 0x800B9B88 : AT(0x000BA788) { build/asm/data/main_800B9B88.bin.o(.data); }
    .main_800BADC8 0x800BADC8 : AT(0x000BB9C8) { FILL(0x00000000); build/asm/main_800BADC8.s.o(.text); build/asm/main_800BADC8.s.o(.rodata); build/asm/main_800BADC8.s.o(.data); }
    .main_800BADC8_bss (NOLOAD) : { build/asm/main_800BADC8.s.o(.bss); }
    .main_800BBFDC 0x800BBFDC : AT(0x000BCBDC) { build/asm/data/main_800BBFDC.bin.o(.data); }
    .main_800BDBDC 0x800BDBDC : AT(0x000BE7DC) { FILL(0x00000000); build/asm/main_800BDBDC.s.o(.text); build/asm/main_800BDBDC.s.o(.rodata); build/asm/main_800BDBDC.s.o(.data); }
    .main_800BDBDC_bss (NOLOAD) : { build/asm/main_800BDBDC.s.o(.bss); }
    .main_800BDBE0 0x800BDBE0 : AT(0x000BE7E0) { build/asm/data/main_800BDBE0.bin.o(.data); }
    .main_800C16A4 0x800C16A4 : AT(0x000C22A4) { FILL(0x00000000); build/asm/main_800C16A4.s.o(.text); build/asm/main_800C16A4.s.o(.rodata); build/asm/main_800C16A4.s.o(.data); }
    .main_800C16A4_bss (NOLOAD) : { build/asm/main_800C16A4.s.o(.bss); }
    .main_800C16AC 0x800C16AC : AT(0x000C22AC) { build/asm/data/main_800C16AC.bin.o(.data); }
    .main_800C3DAC 0x800C3DAC : AT(0x000C49AC) { FILL(0x00000000); build/asm/main_800C3DAC.s.o(.text); build/asm/main_800C3DAC.s.o(.rodata); build/asm/main_800C3DAC.s.o(.data); }
    .main_800C3DAC_bss (NOLOAD) : { build/asm/main_800C3DAC.s.o(.bss); }
    .main_800C3DE0 0x800C3DE0 : AT(0x000C49E0) { build/asm/data/main_800C3DE0.bin.o(.data); }
    .main_800C50C8 0x800C50C8 : AT(0x000C5CC8) { FILL(0x00000000); build/asm/main_800C50C8.s.o(.text); build/asm/main_800C50C8.s.o(.rodata); build/asm/main_800C50C8.s.o(.data); }
    .main_800C50C8_bss (NOLOAD) : { build/asm/main_800C50C8.s.o(.bss); }
    .main_800C50D8 0x800C50D8 : AT(0x000C5CD8) { build/asm/data/main_800C50D8.bin.o(.data); }
    .main_800C92D4 0x800C92D4 : AT(0x000C9ED4) { FILL(0x00000000); build/asm/main_800C92D4.s.o(.text); build/asm/main_800C92D4.s.o(.rodata); build/asm/main_800C92D4.s.o(.data); }
    .main_800C92D4_bss (NOLOAD) : { build/asm/main_800C92D4.s.o(.bss); }
    .main_800C9300 0x800C9300 : AT(0x000C9F00) { build/asm/data/main_800C9300.bin.o(.data); }
    .main_800CA080 0x800CA080 : AT(0x000CAC80) { FILL(0x00000000); build/asm/main_800CA080.s.o(.text); build/asm/main_800CA080.s.o(.rodata); build/asm/main_800CA080.s.o(.data); }
    .main_800CA080_bss (NOLOAD) : { build/asm/main_800CA080.s.o(.bss); }
    .main_800CA0C0 0x800CA0C0 : AT(0x000CACC0) { build/asm/data/main_800CA0C0.bin.o(.data); }
    .main_800CA8B4 0x800CA8B4 : AT(0x000CB4B4) { build/asm/data/main_800CA8B4.bin.o(.data); }
    .main_800CBC4C 0x800CBC4C : AT(0x000CC84C) { build/asm/data/main_800CBC4C.bin.o(.data); }
    .main_800CCCB0 0x800CCCB0 : AT(0x000CD8B0) { FILL(0x00000000); build/asm/main_800CCCB0.s.o(.text); build/asm/main_800CCCB0.s.o(.rodata); build/asm/main_800CCCB0.s.o(.data); }
    .main_800CCCB0_bss (NOLOAD) : { build/asm/main_800CCCB0.s.o(.bss); }
    .main_800CCCF4 0x800CCCF4 : AT(0x000CD8F4) { build/asm/data/main_800CCCF4.bin.o(.data); }
    .main_800CE420 0x800CE420 : AT(0x000CF020) { FILL(0x00000000); build/asm/main_800CE420.s.o(.text); build/asm/main_800CE420.s.o(.rodata); build/asm/main_800CE420.s.o(.data); }
    .main_800CE420_bss (NOLOAD) : { build/asm/main_800CE420.s.o(.bss); }
    .main_800CE664 0x800CE664 : AT(0x000CF264) { FILL(0x00000000); build/asm/main_800CE664.s.o(.text); build/asm/main_800CE664.s.o(.rodata); build/asm/main_800CE664.s.o(.data); }
    .main_800CE664_bss (NOLOAD) : { build/asm/main_800CE664.s.o(.bss); }
    .main_800CEB28 0x800CEB28 : AT(0x000CF728) { build/asm/data/main_800CEB28.bin.o(.data); }
    .main_800CF2C4 0x800CF2C4 : AT(0x000CFEC4) { FILL(0x00000000); build/asm/main_800CF2C4.s.o(.text); build/asm/main_800CF2C4.s.o(.rodata); build/asm/main_800CF2C4.s.o(.data); }
    .main_800CF2C4_bss (NOLOAD) : { build/asm/main_800CF2C4.s.o(.bss); }
    .main_800CF3DC 0x800CF3DC : AT(0x000CFFDC) { build/asm/data/main_800CF3DC.bin.o(.data); }
    .main_800D28BC 0x800D28BC : AT(0x000D34BC) { FILL(0x00000000); build/asm/main_800D28BC.s.o(.text); build/asm/main_800D28BC.s.o(.rodata); build/asm/main_800D28BC.s.o(.data); }
    .main_800D28BC_bss (NOLOAD) : { build/asm/main_800D28BC.s.o(.bss); }
    .main_800D28D0 0x800D28D0 : AT(0x000D34D0) { build/asm/data/main_800D28D0.bin.o(.data); }
    .main_800D2B4C 0x800D2B4C : AT(0x000D374C) { FILL(0x00000000); build/asm/main_800D2B4C.s.o(.text); build/asm/main_800D2B4C.s.o(.rodata); build/asm/main_800D2B4C.s.o(.data); }
    .main_800D2B4C_bss (NOLOAD) : { build/asm/main_800D2B4C.s.o(.bss); }
    .main_800D2B7C 0x800D2B7C : AT(0x000D377C) { build/asm/data/main_800D2B7C.bin.o(.data); }
    .main_800D685C 0x800D685C : AT(0x000D745C) { FILL(0x00000000); build/asm/main_800D685C.s.o(.text); build/asm/main_800D685C.s.o(.rodata); build/asm/main_800D685C.s.o(.data); }
    .main_800D685C_bss (NOLOAD) : { build/asm/main_800D685C.s.o(.bss); }
    .main_800D69CC 0x800D69CC : AT(0x000D75CC) { build/asm/data/main_800D69CC.bin.o(.data); }
    .main_800D8BA4 0x800D8BA4 : AT(0x000D97A4) { FILL(0x00000000); build/asm/main_800D8BA4.s.o(.text); build/asm/main_800D8BA4.s.o(.rodata); build/asm/main_800D8BA4.s.o(.data); }
    .main_800D8BA4_bss (NOLOAD) : { build/asm/main_800D8BA4.s.o(.bss); }
    .main_800D8BA8 0x800D8BA8 : AT(0x000D97A8) { build/asm/data/main_800D8BA8.bin.o(.data); }
    .main_800DA95C 0x800DA95C : AT(0x000DB55C) { FILL(0x00000000); build/asm/main_800DA95C.s.o(.text); build/asm/main_800DA95C.s.o(.rodata); build/asm/main_800DA95C.s.o(.data); }
    .main_800DA95C_bss (NOLOAD) : { build/asm/main_800DA95C.s.o(.bss); }
    .main_800DA960 0x800DA960 : AT(0x000DB560) { build/asm/data/main_800DA960.bin.o(.data); }
    .main_800E2A6C 0x800E2A6C : AT(0x000E366C) { build/asm/data/main_800E2A6C.bin.o(.data); }
    .main_800ED5C0 0x800ED5C0 : AT(0x000EE1C0) { FILL(0x00000000); build/asm/main_800ED5C0.s.o(.text); build/asm/main_800ED5C0.s.o(.rodata); build/asm/main_800ED5C0.s.o(.data); }
    .main_800ED5C0_bss (NOLOAD) : { build/asm/main_800ED5C0.s.o(.bss); }
    .main_800ED834 0x800ED834 : AT(0x000EE434) { build/asm/data/main_800ED834.bin.o(.data); }
    .main_800FCC78 0x800FCC78 : AT(0x000FD878) { build/asm/data/main_800FCC78.bin.o(.data); }
    .main_800FD1C0 0x800FD1C0 : AT(0x000FDDC0) { build/asm/data/main_800FD1C0.bin.o(.data); }
    .main_800FD5DC 0x800FD5DC : AT(0x000FE1DC) { build/asm/data/main_800FD5DC.bin.o(.data); }
    .main_800FE970 0x800FE970 : AT(0x000FF570) { FILL(0x00000000); build/asm/main_800FE970.s.o(.text); build/asm/main_800FE970.s.o(.rodata); build/asm/main_800FE970.s.o(.data); }
    .main_800FE970_bss (NOLOAD) : { build/asm/main_800FE970.s.o(.bss); }
    .main_800FE980 0x800FE980 : AT(0x000FF580) { build/asm/data/main_800FE980.bin.o(.data); }
    .main_800FF804 0x800FF804 : AT(0x00100404) { FILL(0x00000000); build/asm/main_800FF804.s.o(.text); build/asm/main_800FF804.s.o(.rodata); build/asm/main_800FF804.s.o(.data); }
    .main_800FF804_bss (NOLOAD) : { build/asm/main_800FF804.s.o(.bss); }
    .main_800FF84C 0x800FF84C : AT(0x0010044C) { build/asm/data/main_800FF84C.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
