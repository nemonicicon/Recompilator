SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80001FB4 0x80001FB4 : AT(0x00002BB4) { FILL(0x00000000); build/asm/main_80001FB4.s.o(.text); build/asm/main_80001FB4.s.o(.rodata); build/asm/main_80001FB4.s.o(.data); }
    .main_80001FB4_bss (NOLOAD) : { build/asm/main_80001FB4.s.o(.bss); }
    .main_80002440 0x80002440 : AT(0x00003040) { FILL(0x00000000); build/asm/main_80002440.s.o(.text); build/asm/main_80002440.s.o(.rodata); build/asm/main_80002440.s.o(.data); }
    .main_80002440_bss (NOLOAD) : { build/asm/main_80002440.s.o(.bss); }
    .main_8000AFFC 0x8000AFFC : AT(0x0000BBFC) { FILL(0x00000000); build/asm/main_8000AFFC.s.o(.text); build/asm/main_8000AFFC.s.o(.rodata); build/asm/main_8000AFFC.s.o(.data); }
    .main_8000AFFC_bss (NOLOAD) : { build/asm/main_8000AFFC.s.o(.bss); }
    .ovlnhdr 0xA000DF80 : AT(0x0000DF80) { build/assets/ovlnhdr.bin.o(.data); }
    .main2_800135A0 0x800135A0 : AT(0x0000DF90) { FILL(0x00000000); build/asm/main2_800135A0.s.o(.text); build/asm/main2_800135A0.s.o(.rodata); build/asm/main2_800135A0.s.o(.data); }
    .main2_800135A0_bss (NOLOAD) : { build/asm/main2_800135A0.s.o(.bss); }
    .main2_80013D18 0x80013D18 : AT(0x0000E708) { FILL(0x00000000); build/asm/main2_80013D18.s.o(.text); build/asm/main2_80013D18.s.o(.rodata); build/asm/main2_80013D18.s.o(.data); }
    .main2_80013D18_bss (NOLOAD) : { build/asm/main2_80013D18.s.o(.bss); }
    .main2_800148D0 0x800148D0 : AT(0x0000F2C0) { FILL(0x00000000); build/asm/main2_800148D0.s.o(.text); build/asm/main2_800148D0.s.o(.rodata); build/asm/main2_800148D0.s.o(.data); }
    .main2_800148D0_bss (NOLOAD) : { build/asm/main2_800148D0.s.o(.bss); }
    .main2_80019D2C 0x80019D2C : AT(0x0001471C) { FILL(0x00000000); build/asm/main2_80019D2C.s.o(.text); build/asm/main2_80019D2C.s.o(.rodata); build/asm/main2_80019D2C.s.o(.data); }
    .main2_80019D2C_bss (NOLOAD) : { build/asm/main2_80019D2C.s.o(.bss); }
    .main2_8003FB6C 0x8003FB6C : AT(0x0003A55C) { FILL(0x00000000); build/asm/main2_8003FB6C.s.o(.text); build/asm/main2_8003FB6C.s.o(.rodata); build/asm/main2_8003FB6C.s.o(.data); }
    .main2_8003FB6C_bss (NOLOAD) : { build/asm/main2_8003FB6C.s.o(.bss); }
    .main2_80040E54 0x80040E54 : AT(0x0003B844) { FILL(0x00000000); build/asm/main2_80040E54.s.o(.text); build/asm/main2_80040E54.s.o(.rodata); build/asm/main2_80040E54.s.o(.data); }
    .main2_80040E54_bss (NOLOAD) : { build/asm/main2_80040E54.s.o(.bss); }
    .main2_80040FA0 0x80040FA0 : AT(0x0003B990) { FILL(0x00000000); build/asm/main2_80040FA0.s.o(.text); build/asm/main2_80040FA0.s.o(.rodata); build/asm/main2_80040FA0.s.o(.data); }
    .main2_80040FA0_bss (NOLOAD) : { build/asm/main2_80040FA0.s.o(.bss); }
    .main2_80043CA4 0x80043CA4 : AT(0x0003E694) { FILL(0x00000000); build/asm/main2_80043CA4.s.o(.text); build/asm/main2_80043CA4.s.o(.rodata); build/asm/main2_80043CA4.s.o(.data); }
    .main2_80043CA4_bss (NOLOAD) : { build/asm/main2_80043CA4.s.o(.bss); }
    .main2_80044040 0x80044040 : AT(0x0003EA30) { FILL(0x00000000); build/asm/main2_80044040.s.o(.text); build/asm/main2_80044040.s.o(.rodata); build/asm/main2_80044040.s.o(.data); }
    .main2_80044040_bss (NOLOAD) : { build/asm/main2_80044040.s.o(.bss); }
    .main2_80053098 0x80053098 : AT(0x0004DA88) { FILL(0x00000000); build/asm/main2_80053098.s.o(.text); build/asm/main2_80053098.s.o(.rodata); build/asm/main2_80053098.s.o(.data); }
    .main2_80053098_bss (NOLOAD) : { build/asm/main2_80053098.s.o(.bss); }
    .main2_800541EC 0x800541EC : AT(0x0004EBDC) { FILL(0x00000000); build/asm/main2_800541EC.s.o(.text); build/asm/main2_800541EC.s.o(.rodata); build/asm/main2_800541EC.s.o(.data); }
    .main2_800541EC_bss (NOLOAD) : { build/asm/main2_800541EC.s.o(.bss); }
    .main2_80055808 0x80055808 : AT(0x000501F8) { FILL(0x00000000); build/asm/main2_80055808.s.o(.text); build/asm/main2_80055808.s.o(.rodata); build/asm/main2_80055808.s.o(.data); }
    .main2_80055808_bss (NOLOAD) : { build/asm/main2_80055808.s.o(.bss); }
    .main2_800558F0 0x800558F0 : AT(0x000502E0) { FILL(0x00000000); build/asm/main2_800558F0.s.o(.text); build/asm/main2_800558F0.s.o(.rodata); build/asm/main2_800558F0.s.o(.data); }
    .main2_800558F0_bss (NOLOAD) : { build/asm/main2_800558F0.s.o(.bss); }
    .main2_8005ABB4 0x8005ABB4 : AT(0x000555A4) { FILL(0x00000000); build/asm/main2_8005ABB4.s.o(.text); build/asm/main2_8005ABB4.s.o(.rodata); build/asm/main2_8005ABB4.s.o(.data); }
    .main2_8005ABB4_bss (NOLOAD) : { build/asm/main2_8005ABB4.s.o(.bss); }
    .main2_8005B1E8 0x8005B1E8 : AT(0x00055BD8) { FILL(0x00000000); build/asm/main2_8005B1E8.s.o(.text); build/asm/main2_8005B1E8.s.o(.rodata); build/asm/main2_8005B1E8.s.o(.data); }
    .main2_8005B1E8_bss (NOLOAD) : { build/asm/main2_8005B1E8.s.o(.bss); }
    .main2_8005CBA4 0x8005CBA4 : AT(0x00057594) { FILL(0x00000000); build/asm/main2_8005CBA4.s.o(.text); build/asm/main2_8005CBA4.s.o(.rodata); build/asm/main2_8005CBA4.s.o(.data); }
    .main2_8005CBA4_bss (NOLOAD) : { build/asm/main2_8005CBA4.s.o(.bss); }
    .main2_8005CCF0 0x8005CCF0 : AT(0x000576E0) { FILL(0x00000000); build/asm/main2_8005CCF0.s.o(.text); build/asm/main2_8005CCF0.s.o(.rodata); build/asm/main2_8005CCF0.s.o(.data); }
    .main2_8005CCF0_bss (NOLOAD) : { build/asm/main2_8005CCF0.s.o(.bss); }
    .main2_8005DE94 0x8005DE94 : AT(0x00058884) { FILL(0x00000000); build/asm/main2_8005DE94.s.o(.text); build/asm/main2_8005DE94.s.o(.rodata); build/asm/main2_8005DE94.s.o(.data); }
    .main2_8005DE94_bss (NOLOAD) : { build/asm/main2_8005DE94.s.o(.bss); }
    .main2_8005E170 0x8005E170 : AT(0x00058B60) { FILL(0x00000000); build/asm/main2_8005E170.s.o(.text); build/asm/main2_8005E170.s.o(.rodata); build/asm/main2_8005E170.s.o(.data); }
    .main2_8005E170_bss (NOLOAD) : { build/asm/main2_8005E170.s.o(.bss); }
    .main2_8005E488 0x8005E488 : AT(0x00058E78) { FILL(0x00000000); build/asm/main2_8005E488.s.o(.text); build/asm/main2_8005E488.s.o(.rodata); build/asm/main2_8005E488.s.o(.data); }
    .main2_8005E488_bss (NOLOAD) : { build/asm/main2_8005E488.s.o(.bss); }
    .main2_8005EE18 0x8005EE18 : AT(0x00059808) { FILL(0x00000000); build/asm/main2_8005EE18.s.o(.text); build/asm/main2_8005EE18.s.o(.rodata); build/asm/main2_8005EE18.s.o(.data); }
    .main2_8005EE18_bss (NOLOAD) : { build/asm/main2_8005EE18.s.o(.bss); }
    .main2_8005F940 0x8005F940 : AT(0x0005A330) { FILL(0x00000000); build/asm/main2_8005F940.s.o(.text); build/asm/main2_8005F940.s.o(.rodata); build/asm/main2_8005F940.s.o(.data); }
    .main2_8005F940_bss (NOLOAD) : { build/asm/main2_8005F940.s.o(.bss); }
    .main2_800625F4 0x800625F4 : AT(0x0005CFE4) { FILL(0x00000000); build/asm/main2_800625F4.s.o(.text); build/asm/main2_800625F4.s.o(.rodata); build/asm/main2_800625F4.s.o(.data); }
    .main2_800625F4_bss (NOLOAD) : { build/asm/main2_800625F4.s.o(.bss); }
    .main2_800629B4 0x800629B4 : AT(0x0005D3A4) { FILL(0x00000000); build/asm/main2_800629B4.s.o(.text); build/asm/main2_800629B4.s.o(.rodata); build/asm/main2_800629B4.s.o(.data); }
    .main2_800629B4_bss (NOLOAD) : { build/asm/main2_800629B4.s.o(.bss); }
    .main2_80062BA0 0x80062BA0 : AT(0x0005D590) { FILL(0x00000000); build/asm/main2_80062BA0.s.o(.text); build/asm/main2_80062BA0.s.o(.rodata); build/asm/main2_80062BA0.s.o(.data); }
    .main2_80062BA0_bss (NOLOAD) : { build/asm/main2_80062BA0.s.o(.bss); }
    .main2_80063180 0x80063180 : AT(0x0005DB70) { FILL(0x00000000); build/asm/main2_80063180.s.o(.text); build/asm/main2_80063180.s.o(.rodata); build/asm/main2_80063180.s.o(.data); }
    .main2_80063180_bss (NOLOAD) : { build/asm/main2_80063180.s.o(.bss); }
    .main2_80064F20 0x80064F20 : AT(0x0005F910) { FILL(0x00000000); build/asm/main2_80064F20.s.o(.text); build/asm/main2_80064F20.s.o(.rodata); build/asm/main2_80064F20.s.o(.data); }
    .main2_80064F20_bss (NOLOAD) : { build/asm/main2_80064F20.s.o(.bss); }
    .main2_800663D4 0x800663D4 : AT(0x00060DC4) { FILL(0x00000000); build/asm/main2_800663D4.s.o(.text); build/asm/main2_800663D4.s.o(.rodata); build/asm/main2_800663D4.s.o(.data); }
    .main2_800663D4_bss (NOLOAD) : { build/asm/main2_800663D4.s.o(.bss); }
    .main2_800666BC 0x800666BC : AT(0x000610AC) { FILL(0x00000000); build/asm/main2_800666BC.s.o(.text); build/asm/main2_800666BC.s.o(.rodata); build/asm/main2_800666BC.s.o(.data); }
    .main2_800666BC_bss (NOLOAD) : { build/asm/main2_800666BC.s.o(.bss); }
    .main2_80069B18 0x80069B18 : AT(0x00064508) { FILL(0x00000000); build/asm/main2_80069B18.s.o(.text); build/asm/main2_80069B18.s.o(.rodata); build/asm/main2_80069B18.s.o(.data); }
    .main2_80069B18_bss (NOLOAD) : { build/asm/main2_80069B18.s.o(.bss); }
    .main2_80069FC0 0x80069FC0 : AT(0x000649B0) { FILL(0x00000000); build/asm/main2_80069FC0.s.o(.text); build/asm/main2_80069FC0.s.o(.rodata); build/asm/main2_80069FC0.s.o(.data); }
    .main2_80069FC0_bss (NOLOAD) : { build/asm/main2_80069FC0.s.o(.bss); }
    .main2_8006A2C0 0x8006A2C0 : AT(0x00064CB0) { FILL(0x00000000); build/asm/main2_8006A2C0.s.o(.text); build/asm/main2_8006A2C0.s.o(.rodata); build/asm/main2_8006A2C0.s.o(.data); }
    .main2_8006A2C0_bss (NOLOAD) : { build/asm/main2_8006A2C0.s.o(.bss); }
    .main2_8006A590 0x8006A590 : AT(0x00064F80) { FILL(0x00000000); build/asm/main2_8006A590.s.o(.text); build/asm/main2_8006A590.s.o(.rodata); build/asm/main2_8006A590.s.o(.data); }
    .main2_8006A590_bss (NOLOAD) : { build/asm/main2_8006A590.s.o(.bss); }
    .main2_8006B700 0x8006B700 : AT(0x000660F0) { FILL(0x00000000); build/asm/main2_8006B700.s.o(.text); build/asm/main2_8006B700.s.o(.rodata); build/asm/main2_8006B700.s.o(.data); }
    .main2_8006B700_bss (NOLOAD) : { build/asm/main2_8006B700.s.o(.bss); }
    .main2_8006D720 0x8006D720 : AT(0x00068110) { FILL(0x00000000); build/asm/main2_8006D720.s.o(.text); build/asm/main2_8006D720.s.o(.rodata); build/asm/main2_8006D720.s.o(.data); }
    .main2_8006D720_bss (NOLOAD) : { build/asm/main2_8006D720.s.o(.bss); }
    .main2_8006DEFC 0x8006DEFC : AT(0x000688EC) { FILL(0x00000000); build/asm/main2_8006DEFC.s.o(.text); build/asm/main2_8006DEFC.s.o(.rodata); build/asm/main2_8006DEFC.s.o(.data); }
    .main2_8006DEFC_bss (NOLOAD) : { build/asm/main2_8006DEFC.s.o(.bss); }
    .main2_800704B4 0x800704B4 : AT(0x0006AEA4) { FILL(0x00000000); build/asm/main2_800704B4.s.o(.text); build/asm/main2_800704B4.s.o(.rodata); build/asm/main2_800704B4.s.o(.data); }
    .main2_800704B4_bss (NOLOAD) : { build/asm/main2_800704B4.s.o(.bss); }
    .main2_8007121C 0x8007121C : AT(0x0006BC0C) { FILL(0x00000000); build/asm/main2_8007121C.s.o(.text); build/asm/main2_8007121C.s.o(.rodata); build/asm/main2_8007121C.s.o(.data); }
    .main2_8007121C_bss (NOLOAD) : { build/asm/main2_8007121C.s.o(.bss); }
    .main2_8007234C 0x8007234C : AT(0x0006CD3C) { FILL(0x00000000); build/asm/main2_8007234C.s.o(.text); build/asm/main2_8007234C.s.o(.rodata); build/asm/main2_8007234C.s.o(.data); }
    .main2_8007234C_bss (NOLOAD) : { build/asm/main2_8007234C.s.o(.bss); }
    .main2_800732C0 0x800732C0 : AT(0x0006DCB0) { FILL(0x00000000); build/asm/main2_800732C0.s.o(.text); build/asm/main2_800732C0.s.o(.rodata); build/asm/main2_800732C0.s.o(.data); }
    .main2_800732C0_bss (NOLOAD) : { build/asm/main2_800732C0.s.o(.bss); }
    .main2_800742F4 0x800742F4 : AT(0x0006ECE4) { FILL(0x00000000); build/asm/main2_800742F4.s.o(.text); build/asm/main2_800742F4.s.o(.rodata); build/asm/main2_800742F4.s.o(.data); }
    .main2_800742F4_bss (NOLOAD) : { build/asm/main2_800742F4.s.o(.bss); }
    .main2_800750A8 0x800750A8 : AT(0x0006FA98) { FILL(0x00000000); build/asm/main2_800750A8.s.o(.text); build/asm/main2_800750A8.s.o(.rodata); build/asm/main2_800750A8.s.o(.data); }
    .main2_800750A8_bss (NOLOAD) : { build/asm/main2_800750A8.s.o(.bss); }
    .main2_800764AC 0x800764AC : AT(0x00070E9C) { FILL(0x00000000); build/asm/main2_800764AC.s.o(.text); build/asm/main2_800764AC.s.o(.rodata); build/asm/main2_800764AC.s.o(.data); }
    .main2_800764AC_bss (NOLOAD) : { build/asm/main2_800764AC.s.o(.bss); }
    .main2_800771B0 0x800771B0 : AT(0x00071BA0) { FILL(0x00000000); build/asm/main2_800771B0.s.o(.text); build/asm/main2_800771B0.s.o(.rodata); build/asm/main2_800771B0.s.o(.data); }
    .main2_800771B0_bss (NOLOAD) : { build/asm/main2_800771B0.s.o(.bss); }
    .main2_80077E50 0x80077E50 : AT(0x00072840) { FILL(0x00000000); build/asm/main2_80077E50.s.o(.text); build/asm/main2_80077E50.s.o(.rodata); build/asm/main2_80077E50.s.o(.data); }
    .main2_80077E50_bss (NOLOAD) : { build/asm/main2_80077E50.s.o(.bss); }
    .main2_8007A07C 0x8007A07C : AT(0x00074A6C) { FILL(0x00000000); build/asm/main2_8007A07C.s.o(.text); build/asm/main2_8007A07C.s.o(.rodata); build/asm/main2_8007A07C.s.o(.data); }
    .main2_8007A07C_bss (NOLOAD) : { build/asm/main2_8007A07C.s.o(.bss); }
    .main2_8007C488 0x8007C488 : AT(0x00076E78) { FILL(0x00000000); build/asm/main2_8007C488.s.o(.text); build/asm/main2_8007C488.s.o(.rodata); build/asm/main2_8007C488.s.o(.data); }
    .main2_8007C488_bss (NOLOAD) : { build/asm/main2_8007C488.s.o(.bss); }
    .main2_8007D4B0 0x8007D4B0 : AT(0x00077EA0) { FILL(0x00000000); build/asm/main2_8007D4B0.s.o(.text); build/asm/main2_8007D4B0.s.o(.rodata); build/asm/main2_8007D4B0.s.o(.data); }
    .main2_8007D4B0_bss (NOLOAD) : { build/asm/main2_8007D4B0.s.o(.bss); }
    .main2_800808C4 0x800808C4 : AT(0x0007B2B4) { FILL(0x00000000); build/asm/main2_800808C4.s.o(.text); build/asm/main2_800808C4.s.o(.rodata); build/asm/main2_800808C4.s.o(.data); }
    .main2_800808C4_bss (NOLOAD) : { build/asm/main2_800808C4.s.o(.bss); }
    .main2_800816A8 0x800816A8 : AT(0x0007C098) { FILL(0x00000000); build/asm/main2_800816A8.s.o(.text); build/asm/main2_800816A8.s.o(.rodata); build/asm/main2_800816A8.s.o(.data); }
    .main2_800816A8_bss (NOLOAD) : { build/asm/main2_800816A8.s.o(.bss); }
    .main2_8008292C 0x8008292C : AT(0x0007D31C) { FILL(0x00000000); build/asm/main2_8008292C.s.o(.text); build/asm/main2_8008292C.s.o(.rodata); build/asm/main2_8008292C.s.o(.data); }
    .main2_8008292C_bss (NOLOAD) : { build/asm/main2_8008292C.s.o(.bss); }
    .main2_80083218 0x80083218 : AT(0x0007DC08) { FILL(0x00000000); build/asm/main2_80083218.s.o(.text); build/asm/main2_80083218.s.o(.rodata); build/asm/main2_80083218.s.o(.data); }
    .main2_80083218_bss (NOLOAD) : { build/asm/main2_80083218.s.o(.bss); }
    .main2_800834E0 0x800834E0 : AT(0x0007DED0) { FILL(0x00000000); build/asm/main2_800834E0.s.o(.text); build/asm/main2_800834E0.s.o(.rodata); build/asm/main2_800834E0.s.o(.data); }
    .main2_800834E0_bss (NOLOAD) : { build/asm/main2_800834E0.s.o(.bss); }
    .main2_80083F38 0x80083F38 : AT(0x0007E928) { FILL(0x00000000); build/asm/main2_80083F38.s.o(.text); build/asm/main2_80083F38.s.o(.rodata); build/asm/main2_80083F38.s.o(.data); }
    .main2_80083F38_bss (NOLOAD) : { build/asm/main2_80083F38.s.o(.bss); }
    .main2_80084988 0x80084988 : AT(0x0007F378) { FILL(0x00000000); build/asm/main2_80084988.s.o(.text); build/asm/main2_80084988.s.o(.rodata); build/asm/main2_80084988.s.o(.data); }
    .main2_80084988_bss (NOLOAD) : { build/asm/main2_80084988.s.o(.bss); }
    .main2_80084BB8 0x80084BB8 : AT(0x0007F5A8) { FILL(0x00000000); build/asm/main2_80084BB8.s.o(.text); build/asm/main2_80084BB8.s.o(.rodata); build/asm/main2_80084BB8.s.o(.data); }
    .main2_80084BB8_bss (NOLOAD) : { build/asm/main2_80084BB8.s.o(.bss); }
    .main2_800852F0 0x800852F0 : AT(0x0007FCE0) { FILL(0x00000000); build/asm/main2_800852F0.s.o(.text); build/asm/main2_800852F0.s.o(.rodata); build/asm/main2_800852F0.s.o(.data); }
    .main2_800852F0_bss (NOLOAD) : { build/asm/main2_800852F0.s.o(.bss); }
    .main2_80085744 0x80085744 : AT(0x00080134) { FILL(0x00000000); build/asm/main2_80085744.s.o(.text); build/asm/main2_80085744.s.o(.rodata); build/asm/main2_80085744.s.o(.data); }
    .main2_80085744_bss (NOLOAD) : { build/asm/main2_80085744.s.o(.bss); }
    .main2_80085C5C 0x80085C5C : AT(0x0008064C) { FILL(0x00000000); build/asm/main2_80085C5C.s.o(.text); build/asm/main2_80085C5C.s.o(.rodata); build/asm/main2_80085C5C.s.o(.data); }
    .main2_80085C5C_bss (NOLOAD) : { build/asm/main2_80085C5C.s.o(.bss); }
    .main2_800C4760 0x800C4760 : AT(0x000BF150) { FILL(0x00000000); build/asm/main2_800C4760.s.o(.text); build/asm/main2_800C4760.s.o(.rodata); build/asm/main2_800C4760.s.o(.data); }
    .main2_800C4760_bss (NOLOAD) : { build/asm/main2_800C4760.s.o(.bss); }
    .main2_800DE380 0x800DE380 : AT(0x000D8D70) { FILL(0x00000000); build/asm/main2_800DE380.s.o(.text); build/asm/main2_800DE380.s.o(.rodata); build/asm/main2_800DE380.s.o(.data); }
    .main2_800DE380_bss (NOLOAD) : { build/asm/main2_800DE380.s.o(.bss); }
    .main2_800DF230 0x800DF230 : AT(0x000D9C20) { FILL(0x00000000); build/asm/main2_800DF230.s.o(.text); build/asm/main2_800DF230.s.o(.rodata); build/asm/main2_800DF230.s.o(.data); }
    .main2_800DF230_bss (NOLOAD) : { build/asm/main2_800DF230.s.o(.bss); }
    .main2_800E2C28 0x800E2C28 : AT(0x000DD618) { FILL(0x00000000); build/asm/main2_800E2C28.s.o(.text); build/asm/main2_800E2C28.s.o(.rodata); build/asm/main2_800E2C28.s.o(.data); }
    .main2_800E2C28_bss (NOLOAD) : { build/asm/main2_800E2C28.s.o(.bss); }
    .main2_800FC41C 0x800FC41C : AT(0x000F6E0C) { FILL(0x00000000); build/asm/main2_800FC41C.s.o(.text); build/asm/main2_800FC41C.s.o(.rodata); build/asm/main2_800FC41C.s.o(.data); }
    .main2_800FC41C_bss (NOLOAD) : { build/asm/main2_800FC41C.s.o(.bss); }
    .main2_800FD0AC 0x800FD0AC : AT(0x000F7A9C) { FILL(0x00000000); build/asm/main2_800FD0AC.s.o(.text); build/asm/main2_800FD0AC.s.o(.rodata); build/asm/main2_800FD0AC.s.o(.data); }
    .main2_800FD0AC_bss (NOLOAD) : { build/asm/main2_800FD0AC.s.o(.bss); }
    .main2_800FE71C 0x800FE71C : AT(0x000F910C) { FILL(0x00000000); build/asm/main2_800FE71C.s.o(.text); build/asm/main2_800FE71C.s.o(.rodata); build/asm/main2_800FE71C.s.o(.data); }
    .main2_800FE71C_bss (NOLOAD) : { build/asm/main2_800FE71C.s.o(.bss); }
    .main2_801043A0 0x801043A0 : AT(0x000FED90) { FILL(0x00000000); build/asm/main2_801043A0.s.o(.text); build/asm/main2_801043A0.s.o(.rodata); build/asm/main2_801043A0.s.o(.data); }
    .main2_801043A0_bss (NOLOAD) : { build/asm/main2_801043A0.s.o(.bss); }
    .main2_80104AFC 0x80104AFC : AT(0x000FF4EC) { FILL(0x00000000); build/asm/main2_80104AFC.s.o(.text); build/asm/main2_80104AFC.s.o(.rodata); build/asm/main2_80104AFC.s.o(.data); }
    .main2_80104AFC_bss (NOLOAD) : { build/asm/main2_80104AFC.s.o(.bss); }
    .main2_80105498 0x80105498 : AT(0x000FFE88) { FILL(0x00000000); build/asm/main2_80105498.s.o(.text); build/asm/main2_80105498.s.o(.rodata); build/asm/main2_80105498.s.o(.data); }
    .main2_80105498_bss (NOLOAD) : { build/asm/main2_80105498.s.o(.bss); }
    .main2_801057B4 0x801057B4 : AT(0x001001A4) { FILL(0x00000000); build/asm/main2_801057B4.s.o(.text); build/asm/main2_801057B4.s.o(.rodata); build/asm/main2_801057B4.s.o(.data); }
    .main2_801057B4_bss (NOLOAD) : { build/asm/main2_801057B4.s.o(.bss); }
    .main2_80105B14 0x80105B14 : AT(0x00100504) { FILL(0x00000000); build/asm/main2_80105B14.s.o(.text); build/asm/main2_80105B14.s.o(.rodata); build/asm/main2_80105B14.s.o(.data); }
    .main2_80105B14_bss (NOLOAD) : { build/asm/main2_80105B14.s.o(.bss); }
    .assets 0x80400400 : AT(0x0012D000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
