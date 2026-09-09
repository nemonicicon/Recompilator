SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004AC 0x800004AC : AT(0x000010AC) { FILL(0x00000000); build/asm/main_800004AC.s.o(.text); build/asm/main_800004AC.s.o(.rodata); build/asm/main_800004AC.s.o(.data); }
    .main_800004AC_bss (NOLOAD) : { build/asm/main_800004AC.s.o(.bss); }
    .main_8001DFE4 0x8001DFE4 : AT(0x0001EBE4) { FILL(0x00000000); build/asm/main_8001DFE4.s.o(.text); build/asm/main_8001DFE4.s.o(.rodata); build/asm/main_8001DFE4.s.o(.data); }
    .main_8001DFE4_bss (NOLOAD) : { build/asm/main_8001DFE4.s.o(.bss); }
    .main_800201C4 0x800201C4 : AT(0x00020DC4) { FILL(0x00000000); build/asm/main_800201C4.s.o(.text); build/asm/main_800201C4.s.o(.rodata); build/asm/main_800201C4.s.o(.data); }
    .main_800201C4_bss (NOLOAD) : { build/asm/main_800201C4.s.o(.bss); }
    .main_800206B0 0x800206B0 : AT(0x000212B0) { FILL(0x00000000); build/asm/main_800206B0.s.o(.text); build/asm/main_800206B0.s.o(.rodata); build/asm/main_800206B0.s.o(.data); }
    .main_800206B0_bss (NOLOAD) : { build/asm/main_800206B0.s.o(.bss); }
    .main_800211B0 0x800211B0 : AT(0x00021DB0) { FILL(0x00000000); build/asm/main_800211B0.s.o(.text); build/asm/main_800211B0.s.o(.rodata); build/asm/main_800211B0.s.o(.data); }
    .main_800211B0_bss (NOLOAD) : { build/asm/main_800211B0.s.o(.bss); }
    .main_800217A0 0x800217A0 : AT(0x000223A0) { FILL(0x00000000); build/asm/main_800217A0.s.o(.text); build/asm/main_800217A0.s.o(.rodata); build/asm/main_800217A0.s.o(.data); }
    .main_800217A0_bss (NOLOAD) : { build/asm/main_800217A0.s.o(.bss); }
    .main_80022428 0x80022428 : AT(0x00023028) { FILL(0x00000000); build/asm/main_80022428.s.o(.text); build/asm/main_80022428.s.o(.rodata); build/asm/main_80022428.s.o(.data); }
    .main_80022428_bss (NOLOAD) : { build/asm/main_80022428.s.o(.bss); }
    .main_80022694 0x80022694 : AT(0x00023294) { FILL(0x00000000); build/asm/main_80022694.s.o(.text); build/asm/main_80022694.s.o(.rodata); build/asm/main_80022694.s.o(.data); }
    .main_80022694_bss (NOLOAD) : { build/asm/main_80022694.s.o(.bss); }
    .main_80023BE4 0x80023BE4 : AT(0x000247E4) { FILL(0x00000000); build/asm/main_80023BE4.s.o(.text); build/asm/main_80023BE4.s.o(.rodata); build/asm/main_80023BE4.s.o(.data); }
    .main_80023BE4_bss (NOLOAD) : { build/asm/main_80023BE4.s.o(.bss); }
    .main_80024214 0x80024214 : AT(0x00024E14) { FILL(0x00000000); build/asm/main_80024214.s.o(.text); build/asm/main_80024214.s.o(.rodata); build/asm/main_80024214.s.o(.data); }
    .main_80024214_bss (NOLOAD) : { build/asm/main_80024214.s.o(.bss); }
    .main_800249B0 0x800249B0 : AT(0x000255B0) { FILL(0x00000000); build/asm/main_800249B0.s.o(.text); build/asm/main_800249B0.s.o(.rodata); build/asm/main_800249B0.s.o(.data); }
    .main_800249B0_bss (NOLOAD) : { build/asm/main_800249B0.s.o(.bss); }
    .main_80027054 0x80027054 : AT(0x00027C54) { FILL(0x00000000); build/asm/main_80027054.s.o(.text); build/asm/main_80027054.s.o(.rodata); build/asm/main_80027054.s.o(.data); }
    .main_80027054_bss (NOLOAD) : { build/asm/main_80027054.s.o(.bss); }
    .main_80028120 0x80028120 : AT(0x00028D20) { FILL(0x00000000); build/asm/main_80028120.s.o(.text); build/asm/main_80028120.s.o(.rodata); build/asm/main_80028120.s.o(.data); }
    .main_80028120_bss (NOLOAD) : { build/asm/main_80028120.s.o(.bss); }
    .main_8002856C 0x8002856C : AT(0x0002916C) { FILL(0x00000000); build/asm/main_8002856C.s.o(.text); build/asm/main_8002856C.s.o(.rodata); build/asm/main_8002856C.s.o(.data); }
    .main_8002856C_bss (NOLOAD) : { build/asm/main_8002856C.s.o(.bss); }
    .main_80028E84 0x80028E84 : AT(0x00029A84) { FILL(0x00000000); build/asm/main_80028E84.s.o(.text); build/asm/main_80028E84.s.o(.rodata); build/asm/main_80028E84.s.o(.data); }
    .main_80028E84_bss (NOLOAD) : { build/asm/main_80028E84.s.o(.bss); }
    .main_80028FCC 0x80028FCC : AT(0x00029BCC) { FILL(0x00000000); build/asm/main_80028FCC.s.o(.text); build/asm/main_80028FCC.s.o(.rodata); build/asm/main_80028FCC.s.o(.data); }
    .main_80028FCC_bss (NOLOAD) : { build/asm/main_80028FCC.s.o(.bss); }
    .main_8002A890 0x8002A890 : AT(0x0002B490) { FILL(0x00000000); build/asm/main_8002A890.s.o(.text); build/asm/main_8002A890.s.o(.rodata); build/asm/main_8002A890.s.o(.data); }
    .main_8002A890_bss (NOLOAD) : { build/asm/main_8002A890.s.o(.bss); }
    .main_8002CB28 0x8002CB28 : AT(0x0002D728) { FILL(0x00000000); build/asm/main_8002CB28.s.o(.text); build/asm/main_8002CB28.s.o(.rodata); build/asm/main_8002CB28.s.o(.data); }
    .main_8002CB28_bss (NOLOAD) : { build/asm/main_8002CB28.s.o(.bss); }
    .main_8002D1A8 0x8002D1A8 : AT(0x0002DDA8) { FILL(0x00000000); build/asm/main_8002D1A8.s.o(.text); build/asm/main_8002D1A8.s.o(.rodata); build/asm/main_8002D1A8.s.o(.data); }
    .main_8002D1A8_bss (NOLOAD) : { build/asm/main_8002D1A8.s.o(.bss); }
    .main_8002DFCC 0x8002DFCC : AT(0x0002EBCC) { FILL(0x00000000); build/asm/main_8002DFCC.s.o(.text); build/asm/main_8002DFCC.s.o(.rodata); build/asm/main_8002DFCC.s.o(.data); }
    .main_8002DFCC_bss (NOLOAD) : { build/asm/main_8002DFCC.s.o(.bss); }
    .main_8002FA78 0x8002FA78 : AT(0x00030678) { FILL(0x00000000); build/asm/main_8002FA78.s.o(.text); build/asm/main_8002FA78.s.o(.rodata); build/asm/main_8002FA78.s.o(.data); }
    .main_8002FA78_bss (NOLOAD) : { build/asm/main_8002FA78.s.o(.bss); }
    .main_80030070 0x80030070 : AT(0x00030C70) { FILL(0x00000000); build/asm/main_80030070.s.o(.text); build/asm/main_80030070.s.o(.rodata); build/asm/main_80030070.s.o(.data); }
    .main_80030070_bss (NOLOAD) : { build/asm/main_80030070.s.o(.bss); }
    .main_80030908 0x80030908 : AT(0x00031508) { FILL(0x00000000); build/asm/main_80030908.s.o(.text); build/asm/main_80030908.s.o(.rodata); build/asm/main_80030908.s.o(.data); }
    .main_80030908_bss (NOLOAD) : { build/asm/main_80030908.s.o(.bss); }
    .main_80030BB0 0x80030BB0 : AT(0x000317B0) { FILL(0x00000000); build/asm/main_80030BB0.s.o(.text); build/asm/main_80030BB0.s.o(.rodata); build/asm/main_80030BB0.s.o(.data); }
    .main_80030BB0_bss (NOLOAD) : { build/asm/main_80030BB0.s.o(.bss); }
    .main_800310C8 0x800310C8 : AT(0x00031CC8) { FILL(0x00000000); build/asm/main_800310C8.s.o(.text); build/asm/main_800310C8.s.o(.rodata); build/asm/main_800310C8.s.o(.data); }
    .main_800310C8_bss (NOLOAD) : { build/asm/main_800310C8.s.o(.bss); }
    .main_80031D4C 0x80031D4C : AT(0x0003294C) { FILL(0x00000000); build/asm/main_80031D4C.s.o(.text); build/asm/main_80031D4C.s.o(.rodata); build/asm/main_80031D4C.s.o(.data); }
    .main_80031D4C_bss (NOLOAD) : { build/asm/main_80031D4C.s.o(.bss); }
    .main_80031E4C 0x80031E4C : AT(0x00032A4C) { FILL(0x00000000); build/asm/main_80031E4C.s.o(.text); build/asm/main_80031E4C.s.o(.rodata); build/asm/main_80031E4C.s.o(.data); }
    .main_80031E4C_bss (NOLOAD) : { build/asm/main_80031E4C.s.o(.bss); }
    .main_800321C0 0x800321C0 : AT(0x00032DC0) { FILL(0x00000000); build/asm/main_800321C0.s.o(.text); build/asm/main_800321C0.s.o(.rodata); build/asm/main_800321C0.s.o(.data); }
    .main_800321C0_bss (NOLOAD) : { build/asm/main_800321C0.s.o(.bss); }
    .main_80032CEC 0x80032CEC : AT(0x000338EC) { FILL(0x00000000); build/asm/main_80032CEC.s.o(.text); build/asm/main_80032CEC.s.o(.rodata); build/asm/main_80032CEC.s.o(.data); }
    .main_80032CEC_bss (NOLOAD) : { build/asm/main_80032CEC.s.o(.bss); }
    .main_800333F4 0x800333F4 : AT(0x00033FF4) { FILL(0x00000000); build/asm/main_800333F4.s.o(.text); build/asm/main_800333F4.s.o(.rodata); build/asm/main_800333F4.s.o(.data); }
    .main_800333F4_bss (NOLOAD) : { build/asm/main_800333F4.s.o(.bss); }
    .main_80033FB0 0x80033FB0 : AT(0x00034BB0) { FILL(0x00000000); build/asm/main_80033FB0.s.o(.text); build/asm/main_80033FB0.s.o(.rodata); build/asm/main_80033FB0.s.o(.data); }
    .main_80033FB0_bss (NOLOAD) : { build/asm/main_80033FB0.s.o(.bss); }
    .main_800343EC 0x800343EC : AT(0x00034FEC) { FILL(0x00000000); build/asm/main_800343EC.s.o(.text); build/asm/main_800343EC.s.o(.rodata); build/asm/main_800343EC.s.o(.data); }
    .main_800343EC_bss (NOLOAD) : { build/asm/main_800343EC.s.o(.bss); }
    .main_800349F0 0x800349F0 : AT(0x000355F0) { FILL(0x00000000); build/asm/main_800349F0.s.o(.text); build/asm/main_800349F0.s.o(.rodata); build/asm/main_800349F0.s.o(.data); }
    .main_800349F0_bss (NOLOAD) : { build/asm/main_800349F0.s.o(.bss); }
    .main_80034F34 0x80034F34 : AT(0x00035B34) { FILL(0x00000000); build/asm/main_80034F34.s.o(.text); build/asm/main_80034F34.s.o(.rodata); build/asm/main_80034F34.s.o(.data); }
    .main_80034F34_bss (NOLOAD) : { build/asm/main_80034F34.s.o(.bss); }
    .main_80036194 0x80036194 : AT(0x00036D94) { FILL(0x00000000); build/asm/main_80036194.s.o(.text); build/asm/main_80036194.s.o(.rodata); build/asm/main_80036194.s.o(.data); }
    .main_80036194_bss (NOLOAD) : { build/asm/main_80036194.s.o(.bss); }
    .main_80037E28 0x80037E28 : AT(0x00038A28) { FILL(0x00000000); build/asm/main_80037E28.s.o(.text); build/asm/main_80037E28.s.o(.rodata); build/asm/main_80037E28.s.o(.data); }
    .main_80037E28_bss (NOLOAD) : { build/asm/main_80037E28.s.o(.bss); }
    .main_80038E00 0x80038E00 : AT(0x00039A00) { FILL(0x00000000); build/asm/main_80038E00.s.o(.text); build/asm/main_80038E00.s.o(.rodata); build/asm/main_80038E00.s.o(.data); }
    .main_80038E00_bss (NOLOAD) : { build/asm/main_80038E00.s.o(.bss); }
    .main_8003950C 0x8003950C : AT(0x0003A10C) { FILL(0x00000000); build/asm/main_8003950C.s.o(.text); build/asm/main_8003950C.s.o(.rodata); build/asm/main_8003950C.s.o(.data); }
    .main_8003950C_bss (NOLOAD) : { build/asm/main_8003950C.s.o(.bss); }
    .main_8003A150 0x8003A150 : AT(0x0003AD50) { FILL(0x00000000); build/asm/main_8003A150.s.o(.text); build/asm/main_8003A150.s.o(.rodata); build/asm/main_8003A150.s.o(.data); }
    .main_8003A150_bss (NOLOAD) : { build/asm/main_8003A150.s.o(.bss); }
    .main_8003A6F0 0x8003A6F0 : AT(0x0003B2F0) { FILL(0x00000000); build/asm/main_8003A6F0.s.o(.text); build/asm/main_8003A6F0.s.o(.rodata); build/asm/main_8003A6F0.s.o(.data); }
    .main_8003A6F0_bss (NOLOAD) : { build/asm/main_8003A6F0.s.o(.bss); }
    .main_8003ABD0 0x8003ABD0 : AT(0x0003B7D0) { FILL(0x00000000); build/asm/main_8003ABD0.s.o(.text); build/asm/main_8003ABD0.s.o(.rodata); build/asm/main_8003ABD0.s.o(.data); }
    .main_8003ABD0_bss (NOLOAD) : { build/asm/main_8003ABD0.s.o(.bss); }
    .main_8003B5A0 0x8003B5A0 : AT(0x0003C1A0) { FILL(0x00000000); build/asm/main_8003B5A0.s.o(.text); build/asm/main_8003B5A0.s.o(.rodata); build/asm/main_8003B5A0.s.o(.data); }
    .main_8003B5A0_bss (NOLOAD) : { build/asm/main_8003B5A0.s.o(.bss); }
    .main_8003B860 0x8003B860 : AT(0x0003C460) { FILL(0x00000000); build/asm/main_8003B860.s.o(.text); build/asm/main_8003B860.s.o(.rodata); build/asm/main_8003B860.s.o(.data); }
    .main_8003B860_bss (NOLOAD) : { build/asm/main_8003B860.s.o(.bss); }
    .main_8003B8E0 0x8003B8E0 : AT(0x0003C4E0) { FILL(0x00000000); build/asm/main_8003B8E0.s.o(.text); build/asm/main_8003B8E0.s.o(.rodata); build/asm/main_8003B8E0.s.o(.data); }
    .main_8003B8E0_bss (NOLOAD) : { build/asm/main_8003B8E0.s.o(.bss); }
    .main_8003BC10 0x8003BC10 : AT(0x0003C810) { FILL(0x00000000); build/asm/main_8003BC10.s.o(.text); build/asm/main_8003BC10.s.o(.rodata); build/asm/main_8003BC10.s.o(.data); }
    .main_8003BC10_bss (NOLOAD) : { build/asm/main_8003BC10.s.o(.bss); }
    .main_8003D290 0x8003D290 : AT(0x0003DE90) { FILL(0x00000000); build/asm/main_8003D290.s.o(.text); build/asm/main_8003D290.s.o(.rodata); build/asm/main_8003D290.s.o(.data); }
    .main_8003D290_bss (NOLOAD) : { build/asm/main_8003D290.s.o(.bss); }
    .main_8003DB64 0x8003DB64 : AT(0x0003E764) { FILL(0x00000000); build/asm/main_8003DB64.s.o(.text); build/asm/main_8003DB64.s.o(.rodata); build/asm/main_8003DB64.s.o(.data); }
    .main_8003DB64_bss (NOLOAD) : { build/asm/main_8003DB64.s.o(.bss); }
    .main_8003E058 0x8003E058 : AT(0x0003EC58) { FILL(0x00000000); build/asm/main_8003E058.s.o(.text); build/asm/main_8003E058.s.o(.rodata); build/asm/main_8003E058.s.o(.data); }
    .main_8003E058_bss (NOLOAD) : { build/asm/main_8003E058.s.o(.bss); }
    .main_8003EDEC 0x8003EDEC : AT(0x0003F9EC) { FILL(0x00000000); build/asm/main_8003EDEC.s.o(.text); build/asm/main_8003EDEC.s.o(.rodata); build/asm/main_8003EDEC.s.o(.data); }
    .main_8003EDEC_bss (NOLOAD) : { build/asm/main_8003EDEC.s.o(.bss); }
    .main_8003F080 0x8003F080 : AT(0x0003FC80) { FILL(0x00000000); build/asm/main_8003F080.s.o(.text); build/asm/main_8003F080.s.o(.rodata); build/asm/main_8003F080.s.o(.data); }
    .main_8003F080_bss (NOLOAD) : { build/asm/main_8003F080.s.o(.bss); }
    .main_8003F8C0 0x8003F8C0 : AT(0x000404C0) { FILL(0x00000000); build/asm/main_8003F8C0.s.o(.text); build/asm/main_8003F8C0.s.o(.rodata); build/asm/main_8003F8C0.s.o(.data); }
    .main_8003F8C0_bss (NOLOAD) : { build/asm/main_8003F8C0.s.o(.bss); }
    .main_8003FBB0 0x8003FBB0 : AT(0x000407B0) { FILL(0x00000000); build/asm/main_8003FBB0.s.o(.text); build/asm/main_8003FBB0.s.o(.rodata); build/asm/main_8003FBB0.s.o(.data); }
    .main_8003FBB0_bss (NOLOAD) : { build/asm/main_8003FBB0.s.o(.bss); }
    .main_80040250 0x80040250 : AT(0x00040E50) { FILL(0x00000000); build/asm/main_80040250.s.o(.text); build/asm/main_80040250.s.o(.rodata); build/asm/main_80040250.s.o(.data); }
    .main_80040250_bss (NOLOAD) : { build/asm/main_80040250.s.o(.bss); }
    .main_800405D0 0x800405D0 : AT(0x000411D0) { FILL(0x00000000); build/asm/main_800405D0.s.o(.text); build/asm/main_800405D0.s.o(.rodata); build/asm/main_800405D0.s.o(.data); }
    .main_800405D0_bss (NOLOAD) : { build/asm/main_800405D0.s.o(.bss); }
    .main_800406B0 0x800406B0 : AT(0x000412B0) { FILL(0x00000000); build/asm/main_800406B0.s.o(.text); build/asm/main_800406B0.s.o(.rodata); build/asm/main_800406B0.s.o(.data); }
    .main_800406B0_bss (NOLOAD) : { build/asm/main_800406B0.s.o(.bss); }
    .main_80040B10 0x80040B10 : AT(0x00041710) { FILL(0x00000000); build/asm/main_80040B10.s.o(.text); build/asm/main_80040B10.s.o(.rodata); build/asm/main_80040B10.s.o(.data); }
    .main_80040B10_bss (NOLOAD) : { build/asm/main_80040B10.s.o(.bss); }
    .main_80040FC0 0x80040FC0 : AT(0x00041BC0) { FILL(0x00000000); build/asm/main_80040FC0.s.o(.text); build/asm/main_80040FC0.s.o(.rodata); build/asm/main_80040FC0.s.o(.data); }
    .main_80040FC0_bss (NOLOAD) : { build/asm/main_80040FC0.s.o(.bss); }
    .main_80041430 0x80041430 : AT(0x00042030) { FILL(0x00000000); build/asm/main_80041430.s.o(.text); build/asm/main_80041430.s.o(.rodata); build/asm/main_80041430.s.o(.data); }
    .main_80041430_bss (NOLOAD) : { build/asm/main_80041430.s.o(.bss); }
    .main_80041BC0 0x80041BC0 : AT(0x000427C0) { FILL(0x00000000); build/asm/main_80041BC0.s.o(.text); build/asm/main_80041BC0.s.o(.rodata); build/asm/main_80041BC0.s.o(.data); }
    .main_80041BC0_bss (NOLOAD) : { build/asm/main_80041BC0.s.o(.bss); }
    .main_800424D0 0x800424D0 : AT(0x000430D0) { FILL(0x00000000); build/asm/main_800424D0.s.o(.text); build/asm/main_800424D0.s.o(.rodata); build/asm/main_800424D0.s.o(.data); }
    .main_800424D0_bss (NOLOAD) : { build/asm/main_800424D0.s.o(.bss); }
    .main_80042E80 0x80042E80 : AT(0x00043A80) { FILL(0x00000000); build/asm/main_80042E80.s.o(.text); build/asm/main_80042E80.s.o(.rodata); build/asm/main_80042E80.s.o(.data); }
    .main_80042E80_bss (NOLOAD) : { build/asm/main_80042E80.s.o(.bss); }
    .main_800431B4 0x800431B4 : AT(0x00043DB4) { FILL(0x00000000); build/asm/main_800431B4.s.o(.text); build/asm/main_800431B4.s.o(.rodata); build/asm/main_800431B4.s.o(.data); }
    .main_800431B4_bss (NOLOAD) : { build/asm/main_800431B4.s.o(.bss); }
    .main_8004397C 0x8004397C : AT(0x0004457C) { FILL(0x00000000); build/asm/main_8004397C.s.o(.text); build/asm/main_8004397C.s.o(.rodata); build/asm/main_8004397C.s.o(.data); }
    .main_8004397C_bss (NOLOAD) : { build/asm/main_8004397C.s.o(.bss); }
    .main_80043CF8 0x80043CF8 : AT(0x000448F8) { FILL(0x00000000); build/asm/main_80043CF8.s.o(.text); build/asm/main_80043CF8.s.o(.rodata); build/asm/main_80043CF8.s.o(.data); }
    .main_80043CF8_bss (NOLOAD) : { build/asm/main_80043CF8.s.o(.bss); }
    .main_80044930 0x80044930 : AT(0x00045530) { FILL(0x00000000); build/asm/main_80044930.s.o(.text); build/asm/main_80044930.s.o(.rodata); build/asm/main_80044930.s.o(.data); }
    .main_80044930_bss (NOLOAD) : { build/asm/main_80044930.s.o(.bss); }
    .main_80044A40 0x80044A40 : AT(0x00045640) { FILL(0x00000000); build/asm/main_80044A40.s.o(.text); build/asm/main_80044A40.s.o(.rodata); build/asm/main_80044A40.s.o(.data); }
    .main_80044A40_bss (NOLOAD) : { build/asm/main_80044A40.s.o(.bss); }
    .main_80044BE0 0x80044BE0 : AT(0x000457E0) { FILL(0x00000000); build/asm/main_80044BE0.s.o(.text); build/asm/main_80044BE0.s.o(.rodata); build/asm/main_80044BE0.s.o(.data); }
    .main_80044BE0_bss (NOLOAD) : { build/asm/main_80044BE0.s.o(.bss); }
    .main_80045760 0x80045760 : AT(0x00046360) { FILL(0x00000000); build/asm/main_80045760.s.o(.text); build/asm/main_80045760.s.o(.rodata); build/asm/main_80045760.s.o(.data); }
    .main_80045760_bss (NOLOAD) : { build/asm/main_80045760.s.o(.bss); }
    .main_800460C0 0x800460C0 : AT(0x00046CC0) { FILL(0x00000000); build/asm/main_800460C0.s.o(.text); build/asm/main_800460C0.s.o(.rodata); build/asm/main_800460C0.s.o(.data); }
    .main_800460C0_bss (NOLOAD) : { build/asm/main_800460C0.s.o(.bss); }
    .main_80046420 0x80046420 : AT(0x00047020) { FILL(0x00000000); build/asm/main_80046420.s.o(.text); build/asm/main_80046420.s.o(.rodata); build/asm/main_80046420.s.o(.data); }
    .main_80046420_bss (NOLOAD) : { build/asm/main_80046420.s.o(.bss); }
    .main_8004F990 0x8004F990 : AT(0x00050590) { FILL(0x00000000); build/asm/main_8004F990.s.o(.text); build/asm/main_8004F990.s.o(.rodata); build/asm/main_8004F990.s.o(.data); }
    .main_8004F990_bss (NOLOAD) : { build/asm/main_8004F990.s.o(.bss); }
    .main_80051954 0x80051954 : AT(0x00052554) { FILL(0x00000000); build/asm/main_80051954.s.o(.text); build/asm/main_80051954.s.o(.rodata); build/asm/main_80051954.s.o(.data); }
    .main_80051954_bss (NOLOAD) : { build/asm/main_80051954.s.o(.bss); }
    .main_80052464 0x80052464 : AT(0x00053064) { FILL(0x00000000); build/asm/main_80052464.s.o(.text); build/asm/main_80052464.s.o(.rodata); build/asm/main_80052464.s.o(.data); }
    .main_80052464_bss (NOLOAD) : { build/asm/main_80052464.s.o(.bss); }
    .main_800530F8 0x800530F8 : AT(0x00053CF8) { FILL(0x00000000); build/asm/main_800530F8.s.o(.text); build/asm/main_800530F8.s.o(.rodata); build/asm/main_800530F8.s.o(.data); }
    .main_800530F8_bss (NOLOAD) : { build/asm/main_800530F8.s.o(.bss); }
    .main_800560A0 0x800560A0 : AT(0x00056CA0) { build/asm/data/main_800560A0.bin.o(.data); }
    .main_80056AF0 0x80056AF0 : AT(0x000576F0) { FILL(0x00000000); build/asm/main_80056AF0.s.o(.text); build/asm/main_80056AF0.s.o(.rodata); build/asm/main_80056AF0.s.o(.data); }
    .main_80056AF0_bss (NOLOAD) : { build/asm/main_80056AF0.s.o(.bss); }
    .main_80058820 0x80058820 : AT(0x00059420) { build/asm/data/main_80058820.bin.o(.data); }
    .main_800590DC 0x800590DC : AT(0x00059CDC) { build/asm/data/main_800590DC.bin.o(.data); }
    .main_8005CC54 0x8005CC54 : AT(0x0005D854) { build/asm/data/main_8005CC54.bin.o(.data); }
    .main_80062D44 0x80062D44 : AT(0x00063944) { FILL(0x00000000); build/asm/main_80062D44.s.o(.text); build/asm/main_80062D44.s.o(.rodata); build/asm/main_80062D44.s.o(.data); }
    .main_80062D44_bss (NOLOAD) : { build/asm/main_80062D44.s.o(.bss); }
    .main_80062D4C 0x80062D4C : AT(0x0006394C) { build/asm/data/main_80062D4C.bin.o(.data); }
    .main_8006E1CC 0x8006E1CC : AT(0x0006EDCC) { build/asm/data/main_8006E1CC.bin.o(.data); }
    .main_80081028 0x80081028 : AT(0x00081C28) { build/asm/data/main_80081028.bin.o(.data); }
    .main_80081360 0x80081360 : AT(0x00081F60) { build/asm/data/main_80081360.bin.o(.data); }
    .main_80081D4C 0x80081D4C : AT(0x0008294C) { FILL(0x00000000); build/asm/main_80081D4C.s.o(.text); build/asm/main_80081D4C.s.o(.rodata); build/asm/main_80081D4C.s.o(.data); }
    .main_80081D4C_bss (NOLOAD) : { build/asm/main_80081D4C.s.o(.bss); }
    .main_80081D74 0x80081D74 : AT(0x00082974) { build/asm/data/main_80081D74.bin.o(.data); }
    .main_800A4608 0x800A4608 : AT(0x000A5208) { FILL(0x00000000); build/asm/main_800A4608.s.o(.text); build/asm/main_800A4608.s.o(.rodata); build/asm/main_800A4608.s.o(.data); }
    .main_800A4608_bss (NOLOAD) : { build/asm/main_800A4608.s.o(.bss); }
    .main_800A4BE8 0x800A4BE8 : AT(0x000A57E8) { build/asm/data/main_800A4BE8.bin.o(.data); }
    .main_800AA9CC 0x800AA9CC : AT(0x000AB5CC) { build/asm/data/main_800AA9CC.bin.o(.data); }
    .main_800ABBCC 0x800ABBCC : AT(0x000AC7CC) { FILL(0x00000000); build/asm/main_800ABBCC.s.o(.text); build/asm/main_800ABBCC.s.o(.rodata); build/asm/main_800ABBCC.s.o(.data); }
    .main_800ABBCC_bss (NOLOAD) : { build/asm/main_800ABBCC.s.o(.bss); }
    .main_800ABBE4 0x800ABBE4 : AT(0x000AC7E4) { build/asm/data/main_800ABBE4.bin.o(.data); }
    .main_800AC6CC 0x800AC6CC : AT(0x000AD2CC) { FILL(0x00000000); build/asm/main_800AC6CC.s.o(.text); build/asm/main_800AC6CC.s.o(.rodata); build/asm/main_800AC6CC.s.o(.data); }
    .main_800AC6CC_bss (NOLOAD) : { build/asm/main_800AC6CC.s.o(.bss); }
    .main_800ACF44 0x800ACF44 : AT(0x000ADB44) { build/asm/data/main_800ACF44.bin.o(.data); }
    .main_800AE600 0x800AE600 : AT(0x000AF200) { build/asm/data/main_800AE600.bin.o(.data); }
    .main_800AF930 0x800AF930 : AT(0x000B0530) { build/asm/data/main_800AF930.bin.o(.data); }
    .main_800B0B94 0x800B0B94 : AT(0x000B1794) { FILL(0x00000000); build/asm/main_800B0B94.s.o(.text); build/asm/main_800B0B94.s.o(.rodata); build/asm/main_800B0B94.s.o(.data); }
    .main_800B0B94_bss (NOLOAD) : { build/asm/main_800B0B94.s.o(.bss); }
    .main_800B0C98 0x800B0C98 : AT(0x000B1898) { FILL(0x00000000); build/asm/main_800B0C98.s.o(.text); build/asm/main_800B0C98.s.o(.rodata); build/asm/main_800B0C98.s.o(.data); }
    .main_800B0C98_bss (NOLOAD) : { build/asm/main_800B0C98.s.o(.bss); }
    .main_800B0FE0 0x800B0FE0 : AT(0x000B1BE0) { build/asm/data/main_800B0FE0.bin.o(.data); }
    .main_800B2588 0x800B2588 : AT(0x000B3188) { build/asm/data/main_800B2588.bin.o(.data); }
    .main_800B339C 0x800B339C : AT(0x000B3F9C) { build/asm/data/main_800B339C.bin.o(.data); }
    .main_800B4CE0 0x800B4CE0 : AT(0x000B58E0) { build/asm/data/main_800B4CE0.bin.o(.data); }
    .main_800B5178 0x800B5178 : AT(0x000B5D78) { build/asm/data/main_800B5178.bin.o(.data); }
    .main_800B6BF0 0x800B6BF0 : AT(0x000B77F0) { build/asm/data/main_800B6BF0.bin.o(.data); }
    .main_800B79E0 0x800B79E0 : AT(0x000B85E0) { build/asm/data/main_800B79E0.bin.o(.data); }
    .main_800BCB5C 0x800BCB5C : AT(0x000BD75C) { build/asm/data/main_800BCB5C.bin.o(.data); }
    .main_800C21E8 0x800C21E8 : AT(0x000C2DE8) { FILL(0x00000000); build/asm/main_800C21E8.s.o(.text); build/asm/main_800C21E8.s.o(.rodata); build/asm/main_800C21E8.s.o(.data); }
    .main_800C21E8_bss (NOLOAD) : { build/asm/main_800C21E8.s.o(.bss); }
    .main_800C2294 0x800C2294 : AT(0x000C2E94) { build/asm/data/main_800C2294.bin.o(.data); }
    .main_800CB470 0x800CB470 : AT(0x000CC070) { FILL(0x00000000); build/asm/main_800CB470.s.o(.text); build/asm/main_800CB470.s.o(.rodata); build/asm/main_800CB470.s.o(.data); }
    .main_800CB470_bss (NOLOAD) : { build/asm/main_800CB470.s.o(.bss); }
    .main_800CB490 0x800CB490 : AT(0x000CC090) { build/asm/data/main_800CB490.bin.o(.data); }
    .main_800DCC04 0x800DCC04 : AT(0x000DD804) { FILL(0x00000000); build/asm/main_800DCC04.s.o(.text); build/asm/main_800DCC04.s.o(.rodata); build/asm/main_800DCC04.s.o(.data); }
    .main_800DCC04_bss (NOLOAD) : { build/asm/main_800DCC04.s.o(.bss); }
    .main_800DCC64 0x800DCC64 : AT(0x000DD864) { build/asm/data/main_800DCC64.bin.o(.data); }
    .main_800E665C 0x800E665C : AT(0x000E725C) { FILL(0x00000000); build/asm/main_800E665C.s.o(.text); build/asm/main_800E665C.s.o(.rodata); build/asm/main_800E665C.s.o(.data); }
    .main_800E665C_bss (NOLOAD) : { build/asm/main_800E665C.s.o(.bss); }
    .main_800E66A0 0x800E66A0 : AT(0x000E72A0) { build/asm/data/main_800E66A0.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
