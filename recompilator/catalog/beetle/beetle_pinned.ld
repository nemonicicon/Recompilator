SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800042FC 0x800042FC : AT(0x00004EFC) { FILL(0x00000000); build/asm/main_800042FC.s.o(.text); build/asm/main_800042FC.s.o(.rodata); build/asm/main_800042FC.s.o(.data); }
    .main_800042FC_bss (NOLOAD) : { build/asm/main_800042FC.s.o(.bss); }
    .main_80005220 0x80005220 : AT(0x00005E20) { FILL(0x00000000); build/asm/main_80005220.s.o(.text); build/asm/main_80005220.s.o(.rodata); build/asm/main_80005220.s.o(.data); }
    .main_80005220_bss (NOLOAD) : { build/asm/main_80005220.s.o(.bss); }
    .main_80005304 0x80005304 : AT(0x00005F04) { FILL(0x00000000); build/asm/main_80005304.s.o(.text); build/asm/main_80005304.s.o(.rodata); build/asm/main_80005304.s.o(.data); }
    .main_80005304_bss (NOLOAD) : { build/asm/main_80005304.s.o(.bss); }
    .main_80005688 0x80005688 : AT(0x00006288) { FILL(0x00000000); build/asm/main_80005688.s.o(.text); build/asm/main_80005688.s.o(.rodata); build/asm/main_80005688.s.o(.data); }
    .main_80005688_bss (NOLOAD) : { build/asm/main_80005688.s.o(.bss); }
    .main_800056E0 0x800056E0 : AT(0x000062E0) { FILL(0x00000000); build/asm/main_800056E0.s.o(.text); build/asm/main_800056E0.s.o(.rodata); build/asm/main_800056E0.s.o(.data); }
    .main_800056E0_bss (NOLOAD) : { build/asm/main_800056E0.s.o(.bss); }
    .main_80005754 0x80005754 : AT(0x00006354) { FILL(0x00000000); build/asm/main_80005754.s.o(.text); build/asm/main_80005754.s.o(.rodata); build/asm/main_80005754.s.o(.data); }
    .main_80005754_bss (NOLOAD) : { build/asm/main_80005754.s.o(.bss); }
    .main_800057A8 0x800057A8 : AT(0x000063A8) { FILL(0x00000000); build/asm/main_800057A8.s.o(.text); build/asm/main_800057A8.s.o(.rodata); build/asm/main_800057A8.s.o(.data); }
    .main_800057A8_bss (NOLOAD) : { build/asm/main_800057A8.s.o(.bss); }
    .main_8000590C 0x8000590C : AT(0x0000650C) { FILL(0x00000000); build/asm/main_8000590C.s.o(.text); build/asm/main_8000590C.s.o(.rodata); build/asm/main_8000590C.s.o(.data); }
    .main_8000590C_bss (NOLOAD) : { build/asm/main_8000590C.s.o(.bss); }
    .main_800059E8 0x800059E8 : AT(0x000065E8) { FILL(0x00000000); build/asm/main_800059E8.s.o(.text); build/asm/main_800059E8.s.o(.rodata); build/asm/main_800059E8.s.o(.data); }
    .main_800059E8_bss (NOLOAD) : { build/asm/main_800059E8.s.o(.bss); }
    .main_80005AC4 0x80005AC4 : AT(0x000066C4) { FILL(0x00000000); build/asm/main_80005AC4.s.o(.text); build/asm/main_80005AC4.s.o(.rodata); build/asm/main_80005AC4.s.o(.data); }
    .main_80005AC4_bss (NOLOAD) : { build/asm/main_80005AC4.s.o(.bss); }
    .main_80005B44 0x80005B44 : AT(0x00006744) { FILL(0x00000000); build/asm/main_80005B44.s.o(.text); build/asm/main_80005B44.s.o(.rodata); build/asm/main_80005B44.s.o(.data); }
    .main_80005B44_bss (NOLOAD) : { build/asm/main_80005B44.s.o(.bss); }
    .main_80005C1C 0x80005C1C : AT(0x0000681C) { FILL(0x00000000); build/asm/main_80005C1C.s.o(.text); build/asm/main_80005C1C.s.o(.rodata); build/asm/main_80005C1C.s.o(.data); }
    .main_80005C1C_bss (NOLOAD) : { build/asm/main_80005C1C.s.o(.bss); }
    .main_80005C3C 0x80005C3C : AT(0x0000683C) { FILL(0x00000000); build/asm/main_80005C3C.s.o(.text); build/asm/main_80005C3C.s.o(.rodata); build/asm/main_80005C3C.s.o(.data); }
    .main_80005C3C_bss (NOLOAD) : { build/asm/main_80005C3C.s.o(.bss); }
    .main_80005D7C 0x80005D7C : AT(0x0000697C) { FILL(0x00000000); build/asm/main_80005D7C.s.o(.text); build/asm/main_80005D7C.s.o(.rodata); build/asm/main_80005D7C.s.o(.data); }
    .main_80005D7C_bss (NOLOAD) : { build/asm/main_80005D7C.s.o(.bss); }
    .main_80005EBC 0x80005EBC : AT(0x00006ABC) { FILL(0x00000000); build/asm/main_80005EBC.s.o(.text); build/asm/main_80005EBC.s.o(.rodata); build/asm/main_80005EBC.s.o(.data); }
    .main_80005EBC_bss (NOLOAD) : { build/asm/main_80005EBC.s.o(.bss); }
    .main_80005F48 0x80005F48 : AT(0x00006B48) { FILL(0x00000000); build/asm/main_80005F48.s.o(.text); build/asm/main_80005F48.s.o(.rodata); build/asm/main_80005F48.s.o(.data); }
    .main_80005F48_bss (NOLOAD) : { build/asm/main_80005F48.s.o(.bss); }
    .main_80006170 0x80006170 : AT(0x00006D70) { FILL(0x00000000); build/asm/main_80006170.s.o(.text); build/asm/main_80006170.s.o(.rodata); build/asm/main_80006170.s.o(.data); }
    .main_80006170_bss (NOLOAD) : { build/asm/main_80006170.s.o(.bss); }
    .main_800061FC 0x800061FC : AT(0x00006DFC) { FILL(0x00000000); build/asm/main_800061FC.s.o(.text); build/asm/main_800061FC.s.o(.rodata); build/asm/main_800061FC.s.o(.data); }
    .main_800061FC_bss (NOLOAD) : { build/asm/main_800061FC.s.o(.bss); }
    .main_8000626C 0x8000626C : AT(0x00006E6C) { FILL(0x00000000); build/asm/main_8000626C.s.o(.text); build/asm/main_8000626C.s.o(.rodata); build/asm/main_8000626C.s.o(.data); }
    .main_8000626C_bss (NOLOAD) : { build/asm/main_8000626C.s.o(.bss); }
    .main_80006330 0x80006330 : AT(0x00006F30) { FILL(0x00000000); build/asm/main_80006330.s.o(.text); build/asm/main_80006330.s.o(.rodata); build/asm/main_80006330.s.o(.data); }
    .main_80006330_bss (NOLOAD) : { build/asm/main_80006330.s.o(.bss); }
    .main_80006604 0x80006604 : AT(0x00007204) { FILL(0x00000000); build/asm/main_80006604.s.o(.text); build/asm/main_80006604.s.o(.rodata); build/asm/main_80006604.s.o(.data); }
    .main_80006604_bss (NOLOAD) : { build/asm/main_80006604.s.o(.bss); }
    .main_80006690 0x80006690 : AT(0x00007290) { FILL(0x00000000); build/asm/main_80006690.s.o(.text); build/asm/main_80006690.s.o(.rodata); build/asm/main_80006690.s.o(.data); }
    .main_80006690_bss (NOLOAD) : { build/asm/main_80006690.s.o(.bss); }
    .main_800068A8 0x800068A8 : AT(0x000074A8) { FILL(0x00000000); build/asm/main_800068A8.s.o(.text); build/asm/main_800068A8.s.o(.rodata); build/asm/main_800068A8.s.o(.data); }
    .main_800068A8_bss (NOLOAD) : { build/asm/main_800068A8.s.o(.bss); }
    .main_80006954 0x80006954 : AT(0x00007554) { FILL(0x00000000); build/asm/main_80006954.s.o(.text); build/asm/main_80006954.s.o(.rodata); build/asm/main_80006954.s.o(.data); }
    .main_80006954_bss (NOLOAD) : { build/asm/main_80006954.s.o(.bss); }
    .main_80006AD0 0x80006AD0 : AT(0x000076D0) { FILL(0x00000000); build/asm/main_80006AD0.s.o(.text); build/asm/main_80006AD0.s.o(.rodata); build/asm/main_80006AD0.s.o(.data); }
    .main_80006AD0_bss (NOLOAD) : { build/asm/main_80006AD0.s.o(.bss); }
    .main_80006C30 0x80006C30 : AT(0x00007830) { FILL(0x00000000); build/asm/main_80006C30.s.o(.text); build/asm/main_80006C30.s.o(.rodata); build/asm/main_80006C30.s.o(.data); }
    .main_80006C30_bss (NOLOAD) : { build/asm/main_80006C30.s.o(.bss); }
    .main_80007054 0x80007054 : AT(0x00007C54) { FILL(0x00000000); build/asm/main_80007054.s.o(.text); build/asm/main_80007054.s.o(.rodata); build/asm/main_80007054.s.o(.data); }
    .main_80007054_bss (NOLOAD) : { build/asm/main_80007054.s.o(.bss); }
    .main_800073BC 0x800073BC : AT(0x00007FBC) { FILL(0x00000000); build/asm/main_800073BC.s.o(.text); build/asm/main_800073BC.s.o(.rodata); build/asm/main_800073BC.s.o(.data); }
    .main_800073BC_bss (NOLOAD) : { build/asm/main_800073BC.s.o(.bss); }
    .main_8000757C 0x8000757C : AT(0x0000817C) { FILL(0x00000000); build/asm/main_8000757C.s.o(.text); build/asm/main_8000757C.s.o(.rodata); build/asm/main_8000757C.s.o(.data); }
    .main_8000757C_bss (NOLOAD) : { build/asm/main_8000757C.s.o(.bss); }
    .main_80007740 0x80007740 : AT(0x00008340) { FILL(0x00000000); build/asm/main_80007740.s.o(.text); build/asm/main_80007740.s.o(.rodata); build/asm/main_80007740.s.o(.data); }
    .main_80007740_bss (NOLOAD) : { build/asm/main_80007740.s.o(.bss); }
    .main_80007C58 0x80007C58 : AT(0x00008858) { FILL(0x00000000); build/asm/main_80007C58.s.o(.text); build/asm/main_80007C58.s.o(.rodata); build/asm/main_80007C58.s.o(.data); }
    .main_80007C58_bss (NOLOAD) : { build/asm/main_80007C58.s.o(.bss); }
    .main_800083E0 0x800083E0 : AT(0x00008FE0) { FILL(0x00000000); build/asm/main_800083E0.s.o(.text); build/asm/main_800083E0.s.o(.rodata); build/asm/main_800083E0.s.o(.data); }
    .main_800083E0_bss (NOLOAD) : { build/asm/main_800083E0.s.o(.bss); }
    .main_800085F8 0x800085F8 : AT(0x000091F8) { FILL(0x00000000); build/asm/main_800085F8.s.o(.text); build/asm/main_800085F8.s.o(.rodata); build/asm/main_800085F8.s.o(.data); }
    .main_800085F8_bss (NOLOAD) : { build/asm/main_800085F8.s.o(.bss); }
    .main_80008858 0x80008858 : AT(0x00009458) { FILL(0x00000000); build/asm/main_80008858.s.o(.text); build/asm/main_80008858.s.o(.rodata); build/asm/main_80008858.s.o(.data); }
    .main_80008858_bss (NOLOAD) : { build/asm/main_80008858.s.o(.bss); }
    .main_80008900 0x80008900 : AT(0x00009500) { FILL(0x00000000); build/asm/main_80008900.s.o(.text); build/asm/main_80008900.s.o(.rodata); build/asm/main_80008900.s.o(.data); }
    .main_80008900_bss (NOLOAD) : { build/asm/main_80008900.s.o(.bss); }
    .main_80008DC8 0x80008DC8 : AT(0x000099C8) { FILL(0x00000000); build/asm/main_80008DC8.s.o(.text); build/asm/main_80008DC8.s.o(.rodata); build/asm/main_80008DC8.s.o(.data); }
    .main_80008DC8_bss (NOLOAD) : { build/asm/main_80008DC8.s.o(.bss); }
    .main_80009130 0x80009130 : AT(0x00009D30) { FILL(0x00000000); build/asm/main_80009130.s.o(.text); build/asm/main_80009130.s.o(.rodata); build/asm/main_80009130.s.o(.data); }
    .main_80009130_bss (NOLOAD) : { build/asm/main_80009130.s.o(.bss); }
    .main_80009314 0x80009314 : AT(0x00009F14) { FILL(0x00000000); build/asm/main_80009314.s.o(.text); build/asm/main_80009314.s.o(.rodata); build/asm/main_80009314.s.o(.data); }
    .main_80009314_bss (NOLOAD) : { build/asm/main_80009314.s.o(.bss); }
    .main_8000969C 0x8000969C : AT(0x0000A29C) { FILL(0x00000000); build/asm/main_8000969C.s.o(.text); build/asm/main_8000969C.s.o(.rodata); build/asm/main_8000969C.s.o(.data); }
    .main_8000969C_bss (NOLOAD) : { build/asm/main_8000969C.s.o(.bss); }
    .main_80009AD4 0x80009AD4 : AT(0x0000A6D4) { FILL(0x00000000); build/asm/main_80009AD4.s.o(.text); build/asm/main_80009AD4.s.o(.rodata); build/asm/main_80009AD4.s.o(.data); }
    .main_80009AD4_bss (NOLOAD) : { build/asm/main_80009AD4.s.o(.bss); }
    .main_80009C80 0x80009C80 : AT(0x0000A880) { FILL(0x00000000); build/asm/main_80009C80.s.o(.text); build/asm/main_80009C80.s.o(.rodata); build/asm/main_80009C80.s.o(.data); }
    .main_80009C80_bss (NOLOAD) : { build/asm/main_80009C80.s.o(.bss); }
    .main_8000A5F0 0x8000A5F0 : AT(0x0000B1F0) { FILL(0x00000000); build/asm/main_8000A5F0.s.o(.text); build/asm/main_8000A5F0.s.o(.rodata); build/asm/main_8000A5F0.s.o(.data); }
    .main_8000A5F0_bss (NOLOAD) : { build/asm/main_8000A5F0.s.o(.bss); }
    .main_8000C7DC 0x8000C7DC : AT(0x0000D3DC) { FILL(0x00000000); build/asm/main_8000C7DC.s.o(.text); build/asm/main_8000C7DC.s.o(.rodata); build/asm/main_8000C7DC.s.o(.data); }
    .main_8000C7DC_bss (NOLOAD) : { build/asm/main_8000C7DC.s.o(.bss); }
    .main_8000E3A0 0x8000E3A0 : AT(0x0000EFA0) { FILL(0x00000000); build/asm/main_8000E3A0.s.o(.text); build/asm/main_8000E3A0.s.o(.rodata); build/asm/main_8000E3A0.s.o(.data); }
    .main_8000E3A0_bss (NOLOAD) : { build/asm/main_8000E3A0.s.o(.bss); }
    .main_8000E6E0 0x8000E6E0 : AT(0x0000F2E0) { FILL(0x00000000); build/asm/main_8000E6E0.s.o(.text); build/asm/main_8000E6E0.s.o(.rodata); build/asm/main_8000E6E0.s.o(.data); }
    .main_8000E6E0_bss (NOLOAD) : { build/asm/main_8000E6E0.s.o(.bss); }
    .main_8000F170 0x8000F170 : AT(0x0000FD70) { FILL(0x00000000); build/asm/main_8000F170.s.o(.text); build/asm/main_8000F170.s.o(.rodata); build/asm/main_8000F170.s.o(.data); }
    .main_8000F170_bss (NOLOAD) : { build/asm/main_8000F170.s.o(.bss); }
    .main_8000F294 0x8000F294 : AT(0x0000FE94) { FILL(0x00000000); build/asm/main_8000F294.s.o(.text); build/asm/main_8000F294.s.o(.rodata); build/asm/main_8000F294.s.o(.data); }
    .main_8000F294_bss (NOLOAD) : { build/asm/main_8000F294.s.o(.bss); }
    .main_8000F534 0x8000F534 : AT(0x00010134) { FILL(0x00000000); build/asm/main_8000F534.s.o(.text); build/asm/main_8000F534.s.o(.rodata); build/asm/main_8000F534.s.o(.data); }
    .main_8000F534_bss (NOLOAD) : { build/asm/main_8000F534.s.o(.bss); }
    .main_8000F694 0x8000F694 : AT(0x00010294) { FILL(0x00000000); build/asm/main_8000F694.s.o(.text); build/asm/main_8000F694.s.o(.rodata); build/asm/main_8000F694.s.o(.data); }
    .main_8000F694_bss (NOLOAD) : { build/asm/main_8000F694.s.o(.bss); }
    .main_8000FFF4 0x8000FFF4 : AT(0x00010BF4) { FILL(0x00000000); build/asm/main_8000FFF4.s.o(.text); build/asm/main_8000FFF4.s.o(.rodata); build/asm/main_8000FFF4.s.o(.data); }
    .main_8000FFF4_bss (NOLOAD) : { build/asm/main_8000FFF4.s.o(.bss); }
    .main_800109F0 0x800109F0 : AT(0x000115F0) { FILL(0x00000000); build/asm/main_800109F0.s.o(.text); build/asm/main_800109F0.s.o(.rodata); build/asm/main_800109F0.s.o(.data); }
    .main_800109F0_bss (NOLOAD) : { build/asm/main_800109F0.s.o(.bss); }
    .main_800111B8 0x800111B8 : AT(0x00011DB8) { FILL(0x00000000); build/asm/main_800111B8.s.o(.text); build/asm/main_800111B8.s.o(.rodata); build/asm/main_800111B8.s.o(.data); }
    .main_800111B8_bss (NOLOAD) : { build/asm/main_800111B8.s.o(.bss); }
    .main_800124A0 0x800124A0 : AT(0x000130A0) { FILL(0x00000000); build/asm/main_800124A0.s.o(.text); build/asm/main_800124A0.s.o(.rodata); build/asm/main_800124A0.s.o(.data); }
    .main_800124A0_bss (NOLOAD) : { build/asm/main_800124A0.s.o(.bss); }
    .main_800125B0 0x800125B0 : AT(0x000131B0) { FILL(0x00000000); build/asm/main_800125B0.s.o(.text); build/asm/main_800125B0.s.o(.rodata); build/asm/main_800125B0.s.o(.data); }
    .main_800125B0_bss (NOLOAD) : { build/asm/main_800125B0.s.o(.bss); }
    .main_80012670 0x80012670 : AT(0x00013270) { FILL(0x00000000); build/asm/main_80012670.s.o(.text); build/asm/main_80012670.s.o(.rodata); build/asm/main_80012670.s.o(.data); }
    .main_80012670_bss (NOLOAD) : { build/asm/main_80012670.s.o(.bss); }
    .main_80013D50 0x80013D50 : AT(0x00014950) { FILL(0x00000000); build/asm/main_80013D50.s.o(.text); build/asm/main_80013D50.s.o(.rodata); build/asm/main_80013D50.s.o(.data); }
    .main_80013D50_bss (NOLOAD) : { build/asm/main_80013D50.s.o(.bss); }
    .main_80015110 0x80015110 : AT(0x00015D10) { FILL(0x00000000); build/asm/main_80015110.s.o(.text); build/asm/main_80015110.s.o(.rodata); build/asm/main_80015110.s.o(.data); }
    .main_80015110_bss (NOLOAD) : { build/asm/main_80015110.s.o(.bss); }
    .main_80017F84 0x80017F84 : AT(0x00018B84) { FILL(0x00000000); build/asm/main_80017F84.s.o(.text); build/asm/main_80017F84.s.o(.rodata); build/asm/main_80017F84.s.o(.data); }
    .main_80017F84_bss (NOLOAD) : { build/asm/main_80017F84.s.o(.bss); }
    .main_800182E0 0x800182E0 : AT(0x00018EE0) { FILL(0x00000000); build/asm/main_800182E0.s.o(.text); build/asm/main_800182E0.s.o(.rodata); build/asm/main_800182E0.s.o(.data); }
    .main_800182E0_bss (NOLOAD) : { build/asm/main_800182E0.s.o(.bss); }
    .main_80018B30 0x80018B30 : AT(0x00019730) { FILL(0x00000000); build/asm/main_80018B30.s.o(.text); build/asm/main_80018B30.s.o(.rodata); build/asm/main_80018B30.s.o(.data); }
    .main_80018B30_bss (NOLOAD) : { build/asm/main_80018B30.s.o(.bss); }
    .main_80018DF0 0x80018DF0 : AT(0x000199F0) { FILL(0x00000000); build/asm/main_80018DF0.s.o(.text); build/asm/main_80018DF0.s.o(.rodata); build/asm/main_80018DF0.s.o(.data); }
    .main_80018DF0_bss (NOLOAD) : { build/asm/main_80018DF0.s.o(.bss); }
    .main_80019C50 0x80019C50 : AT(0x0001A850) { build/asm/data/main_80019C50.bin.o(.data); }
    .main_8001A244 0x8001A244 : AT(0x0001AE44) { FILL(0x00000000); build/asm/main_8001A244.s.o(.text); build/asm/main_8001A244.s.o(.rodata); build/asm/main_8001A244.s.o(.data); }
    .main_8001A244_bss (NOLOAD) : { build/asm/main_8001A244.s.o(.bss); }
    .main_8001D6BC 0x8001D6BC : AT(0x0001E2BC) { build/asm/data/main_8001D6BC.bin.o(.data); }
    .main_800225F0 0x800225F0 : AT(0x000231F0) { build/asm/data/main_800225F0.bin.o(.data); }
    .main_80022A00 0x80022A00 : AT(0x00023600) { build/asm/data/main_80022A00.bin.o(.data); }
    .main_80022E98 0x80022E98 : AT(0x00023A98) { build/asm/data/main_80022E98.bin.o(.data); }
    .main_8003B548 0x8003B548 : AT(0x0003C148) { build/asm/data/main_8003B548.bin.o(.data); }
    .main_800422AC 0x800422AC : AT(0x00042EAC) { build/asm/data/main_800422AC.bin.o(.data); }
    .main_800426BC 0x800426BC : AT(0x000432BC) { build/asm/data/main_800426BC.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
