SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004AC 0x800004AC : AT(0x000010AC) { FILL(0x00000000); build/asm/main_800004AC.s.o(.text); build/asm/main_800004AC.s.o(.rodata); build/asm/main_800004AC.s.o(.data); }
    .main_800004AC_bss (NOLOAD) : { build/asm/main_800004AC.s.o(.bss); }
    .main_8005B51C 0x8005B51C : AT(0x0005C11C) { FILL(0x00000000); build/asm/main_8005B51C.s.o(.text); build/asm/main_8005B51C.s.o(.rodata); build/asm/main_8005B51C.s.o(.data); }
    .main_8005B51C_bss (NOLOAD) : { build/asm/main_8005B51C.s.o(.bss); }
    .main_8005BB00 0x8005BB00 : AT(0x0005C700) { FILL(0x00000000); build/asm/main_8005BB00.s.o(.text); build/asm/main_8005BB00.s.o(.rodata); build/asm/main_8005BB00.s.o(.data); }
    .main_8005BB00_bss (NOLOAD) : { build/asm/main_8005BB00.s.o(.bss); }
    .main_80063420 0x80063420 : AT(0x00064020) { FILL(0x00000000); build/asm/data/main_80063420.data.s.o(.data); }
    .main_80063D28 0x80063D28 : AT(0x00064928) { FILL(0x00000000); build/asm/data/main_80063D28.data.s.o(.data); }
    .main_80064454 0x80064454 : AT(0x00065054) { FILL(0x00000000); build/asm/main_80064454.s.o(.text); build/asm/main_80064454.s.o(.rodata); build/asm/main_80064454.s.o(.data); }
    .main_80064454_bss (NOLOAD) : { build/asm/main_80064454.s.o(.bss); }
    .main_80064E30 0x80064E30 : AT(0x00065A30) { FILL(0x00000000); build/asm/main_80064E30.s.o(.text); build/asm/main_80064E30.s.o(.rodata); build/asm/main_80064E30.s.o(.data); }
    .main_80064E30_bss (NOLOAD) : { build/asm/main_80064E30.s.o(.bss); }
    .main_80065F48 0x80065F48 : AT(0x00066B48) { FILL(0x00000000); build/asm/main_80065F48.s.o(.text); build/asm/main_80065F48.s.o(.rodata); build/asm/main_80065F48.s.o(.data); }
    .main_80065F48_bss (NOLOAD) : { build/asm/main_80065F48.s.o(.bss); }
    .main_80066C48 0x80066C48 : AT(0x00067848) { FILL(0x00000000); build/asm/main_80066C48.s.o(.text); build/asm/main_80066C48.s.o(.rodata); build/asm/main_80066C48.s.o(.data); }
    .main_80066C48_bss (NOLOAD) : { build/asm/main_80066C48.s.o(.bss); }
    .main_80068F80 0x80068F80 : AT(0x00069B80) { FILL(0x00000000); build/asm/main_80068F80.s.o(.text); build/asm/main_80068F80.s.o(.rodata); build/asm/main_80068F80.s.o(.data); }
    .main_80068F80_bss (NOLOAD) : { build/asm/main_80068F80.s.o(.bss); }
    .main_8006A190 0x8006A190 : AT(0x0006AD90) { FILL(0x00000000); build/asm/main_8006A190.s.o(.text); build/asm/main_8006A190.s.o(.rodata); build/asm/main_8006A190.s.o(.data); }
    .main_8006A190_bss (NOLOAD) : { build/asm/main_8006A190.s.o(.bss); }
    .main_8006B424 0x8006B424 : AT(0x0006C024) { FILL(0x00000000); build/asm/main_8006B424.s.o(.text); build/asm/main_8006B424.s.o(.rodata); build/asm/main_8006B424.s.o(.data); }
    .main_8006B424_bss (NOLOAD) : { build/asm/main_8006B424.s.o(.bss); }
    .main_8006C3C8 0x8006C3C8 : AT(0x0006CFC8) { FILL(0x00000000); build/asm/data/main_8006C3C8.data.s.o(.data); }
    .main_8006CA90 0x8006CA90 : AT(0x0006D690) { FILL(0x00000000); build/asm/main_8006CA90.s.o(.text); build/asm/main_8006CA90.s.o(.rodata); build/asm/main_8006CA90.s.o(.data); }
    .main_8006CA90_bss (NOLOAD) : { build/asm/main_8006CA90.s.o(.bss); }
    .main_8006D620 0x8006D620 : AT(0x0006E220) { FILL(0x00000000); build/asm/data/main_8006D620.data.s.o(.data); }
    .main_8006DB20 0x8006DB20 : AT(0x0006E720) { FILL(0x00000000); build/asm/main_8006DB20.s.o(.text); build/asm/main_8006DB20.s.o(.rodata); build/asm/main_8006DB20.s.o(.data); }
    .main_8006DB20_bss (NOLOAD) : { build/asm/main_8006DB20.s.o(.bss); }
    .main_8006E320 0x8006E320 : AT(0x0006EF20) { FILL(0x00000000); build/asm/data/main_8006E320.data.s.o(.data); }
    .main_8006E770 0x8006E770 : AT(0x0006F370) { FILL(0x00000000); build/asm/main_8006E770.s.o(.text); build/asm/main_8006E770.s.o(.rodata); build/asm/main_8006E770.s.o(.data); }
    .main_8006E770_bss (NOLOAD) : { build/asm/main_8006E770.s.o(.bss); }
    .main_8006E7EC 0x8006E7EC : AT(0x0006F3EC) { FILL(0x00000000); build/asm/main_8006E7EC.s.o(.text); build/asm/main_8006E7EC.s.o(.rodata); build/asm/main_8006E7EC.s.o(.data); }
    .main_8006E7EC_bss (NOLOAD) : { build/asm/main_8006E7EC.s.o(.bss); }
    .main_8006EDF0 0x8006EDF0 : AT(0x0006F9F0) { FILL(0x00000000); build/asm/main_8006EDF0.s.o(.text); build/asm/main_8006EDF0.s.o(.rodata); build/asm/main_8006EDF0.s.o(.data); }
    .main_8006EDF0_bss (NOLOAD) : { build/asm/main_8006EDF0.s.o(.bss); }
    .main_8006EE6C 0x8006EE6C : AT(0x0006FA6C) { FILL(0x00000000); build/asm/main_8006EE6C.s.o(.text); build/asm/main_8006EE6C.s.o(.rodata); build/asm/main_8006EE6C.s.o(.data); }
    .main_8006EE6C_bss (NOLOAD) : { build/asm/main_8006EE6C.s.o(.bss); }
    .main_80070DD0 0x80070DD0 : AT(0x000719D0) { FILL(0x00000000); build/asm/data/main_80070DD0.data.s.o(.data); }
    .main_800718B4 0x800718B4 : AT(0x000724B4) { FILL(0x00000000); build/asm/main_800718B4.s.o(.text); build/asm/main_800718B4.s.o(.rodata); build/asm/main_800718B4.s.o(.data); }
    .main_800718B4_bss (NOLOAD) : { build/asm/main_800718B4.s.o(.bss); }
    .main_80071BC0 0x80071BC0 : AT(0x000727C0) { FILL(0x00000000); build/asm/data/main_80071BC0.data.s.o(.data); }
    .main_80072330 0x80072330 : AT(0x00072F30) { FILL(0x00000000); build/asm/data/main_80072330.data.s.o(.data); }
    .main_80072D9C 0x80072D9C : AT(0x0007399C) { FILL(0x00000000); build/asm/data/main_80072D9C.data.s.o(.data); }
    .main_8007432C 0x8007432C : AT(0x00074F2C) { FILL(0x00000000); build/asm/data/main_8007432C.data.s.o(.data); }
    .main_8007577C 0x8007577C : AT(0x0007637C) { FILL(0x00000000); build/asm/data/main_8007577C.data.s.o(.data); }
    .main_8007855C 0x8007855C : AT(0x0007915C) { FILL(0x00000000); build/asm/data/main_8007855C.data.s.o(.data); }
    .main_8007B60C 0x8007B60C : AT(0x0007C20C) { FILL(0x00000000); build/asm/data/main_8007B60C.data.s.o(.data); }
    .main_80084F3C 0x80084F3C : AT(0x00085B3C) { FILL(0x00000000); build/asm/data/main_80084F3C.data.s.o(.data); }
    .main_800869B0 0x800869B0 : AT(0x000875B0) { FILL(0x00000000); build/asm/data/main_800869B0.data.s.o(.data); }
    .main_8008849C 0x8008849C : AT(0x0008909C) { FILL(0x00000000); build/asm/data/main_8008849C.data.s.o(.data); }
    .main_800897B8 0x800897B8 : AT(0x0008A3B8) { FILL(0x00000000); build/asm/data/main_800897B8.data.s.o(.data); }
    .main_80089A1C 0x80089A1C : AT(0x0008A61C) { FILL(0x00000000); build/asm/main_80089A1C.s.o(.text); build/asm/main_80089A1C.s.o(.rodata); build/asm/main_80089A1C.s.o(.data); }
    .main_80089A1C_bss (NOLOAD) : { build/asm/main_80089A1C.s.o(.bss); }
    .main_80089A40 0x80089A40 : AT(0x0008A640) { FILL(0x00000000); build/asm/data/main_80089A40.data.s.o(.data); }
    .main_8008A23C 0x8008A23C : AT(0x0008AE3C) { FILL(0x00000000); build/asm/data/main_8008A23C.data.s.o(.data); }
    .main_8008B11C 0x8008B11C : AT(0x0008BD1C) { FILL(0x00000000); build/asm/data/main_8008B11C.data.s.o(.data); }
    .main_8008BC50 0x8008BC50 : AT(0x0008C850) { FILL(0x00000000); build/asm/data/main_8008BC50.data.s.o(.data); }
    .main_8008D730 0x8008D730 : AT(0x0008E330) { FILL(0x00000000); build/asm/data/main_8008D730.data.s.o(.data); }
    .main_8008E3F0 0x8008E3F0 : AT(0x0008EFF0) { FILL(0x00000000); build/asm/main_8008E3F0.s.o(.text); build/asm/main_8008E3F0.s.o(.rodata); build/asm/main_8008E3F0.s.o(.data); }
    .main_8008E3F0_bss (NOLOAD) : { build/asm/main_8008E3F0.s.o(.bss); }
    .main_8008ED88 0x8008ED88 : AT(0x0008F988) { FILL(0x00000000); build/asm/data/main_8008ED88.data.s.o(.data); }
    .main_80092340 0x80092340 : AT(0x00092F40) { FILL(0x00000000); build/asm/main_80092340.s.o(.text); build/asm/main_80092340.s.o(.rodata); build/asm/main_80092340.s.o(.data); }
    .main_80092340_bss (NOLOAD) : { build/asm/main_80092340.s.o(.bss); }
    .main_80092398 0x80092398 : AT(0x00092F98) { FILL(0x00000000); build/asm/data/main_80092398.data.s.o(.data); }
    .main_80094798 0x80094798 : AT(0x00095398) { FILL(0x00000000); build/asm/main_80094798.s.o(.text); build/asm/main_80094798.s.o(.rodata); build/asm/main_80094798.s.o(.data); }
    .main_80094798_bss (NOLOAD) : { build/asm/main_80094798.s.o(.bss); }
    .main_80094814 0x80094814 : AT(0x00095414) { FILL(0x00000000); build/asm/data/main_80094814.data.s.o(.data); }
    .main_80095304 0x80095304 : AT(0x00095F04) { FILL(0x00000000); build/asm/data/main_80095304.data.s.o(.data); }
    .main_80095C38 0x80095C38 : AT(0x00096838) { FILL(0x00000000); build/asm/data/main_80095C38.data.s.o(.data); }
    .main_800960D8 0x800960D8 : AT(0x00096CD8) { FILL(0x00000000); build/asm/data/main_800960D8.data.s.o(.data); }
    .main_800978AC 0x800978AC : AT(0x000984AC) { FILL(0x00000000); build/asm/data/main_800978AC.data.s.o(.data); }
    .main_800A3578 0x800A3578 : AT(0x000A4178) { FILL(0x00000000); build/asm/data/main_800A3578.data.s.o(.data); }
    .main_800A4824 0x800A4824 : AT(0x000A5424) { FILL(0x00000000); build/asm/main_800A4824.s.o(.text); build/asm/main_800A4824.s.o(.rodata); build/asm/main_800A4824.s.o(.data); }
    .main_800A4824_bss (NOLOAD) : { build/asm/main_800A4824.s.o(.bss); }
    .main_800A4838 0x800A4838 : AT(0x000A5438) { FILL(0x00000000); build/asm/data/main_800A4838.data.s.o(.data); }
    .main_800A6FAC 0x800A6FAC : AT(0x000A7BAC) { FILL(0x00000000); build/asm/data/main_800A6FAC.data.s.o(.data); }
    .main_800A9600 0x800A9600 : AT(0x000AA200) { FILL(0x00000000); build/asm/data/main_800A9600.data.s.o(.data); }
    .main_800CBED4 0x800CBED4 : AT(0x000CCAD4) { FILL(0x00000000); build/asm/main_800CBED4.s.o(.text); build/asm/main_800CBED4.s.o(.rodata); build/asm/main_800CBED4.s.o(.data); }
    .main_800CBED4_bss (NOLOAD) : { build/asm/main_800CBED4.s.o(.bss); }
    .main_800CBEF0 0x800CBEF0 : AT(0x000CCAF0) { FILL(0x00000000); build/asm/data/main_800CBEF0.data.s.o(.data); }
    .main_800E09D8 0x800E09D8 : AT(0x000E15D8) { FILL(0x00000000); build/asm/main_800E09D8.s.o(.text); build/asm/main_800E09D8.s.o(.rodata); build/asm/main_800E09D8.s.o(.data); }
    .main_800E09D8_bss (NOLOAD) : { build/asm/main_800E09D8.s.o(.bss); }
    .main_800E0A14 0x800E0A14 : AT(0x000E1614) { FILL(0x00000000); build/asm/data/main_800E0A14.data.s.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
