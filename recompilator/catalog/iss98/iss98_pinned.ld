SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80005F40 0x80005F40 : AT(0x00006B40) { FILL(0x00000000); build/asm/main_80005F40.s.o(.text); build/asm/main_80005F40.s.o(.rodata); build/asm/main_80005F40.s.o(.data); }
    .main_80005F40_bss (NOLOAD) : { build/asm/main_80005F40.s.o(.bss); }
    .main_80006720 0x80006720 : AT(0x00007320) { FILL(0x00000000); build/asm/main_80006720.s.o(.text); build/asm/main_80006720.s.o(.rodata); build/asm/main_80006720.s.o(.data); }
    .main_80006720_bss (NOLOAD) : { build/asm/main_80006720.s.o(.bss); }
    .main_8000AAC0 0x8000AAC0 : AT(0x0000B6C0) { FILL(0x00000000); build/asm/main_8000AAC0.s.o(.text); build/asm/main_8000AAC0.s.o(.rodata); build/asm/main_8000AAC0.s.o(.data); }
    .main_8000AAC0_bss (NOLOAD) : { build/asm/main_8000AAC0.s.o(.bss); }
    .main_8000B428 0x8000B428 : AT(0x0000C028) { FILL(0x00000000); build/asm/main_8000B428.s.o(.text); build/asm/main_8000B428.s.o(.rodata); build/asm/main_8000B428.s.o(.data); }
    .main_8000B428_bss (NOLOAD) : { build/asm/main_8000B428.s.o(.bss); }
    .main_8000B50C 0x8000B50C : AT(0x0000C10C) { FILL(0x00000000); build/asm/main_8000B50C.s.o(.text); build/asm/main_8000B50C.s.o(.rodata); build/asm/main_8000B50C.s.o(.data); }
    .main_8000B50C_bss (NOLOAD) : { build/asm/main_8000B50C.s.o(.bss); }
    .main_8000B7CC 0x8000B7CC : AT(0x0000C3CC) { FILL(0x00000000); build/asm/main_8000B7CC.s.o(.text); build/asm/main_8000B7CC.s.o(.rodata); build/asm/main_8000B7CC.s.o(.data); }
    .main_8000B7CC_bss (NOLOAD) : { build/asm/main_8000B7CC.s.o(.bss); }
    .main_8000CC4C 0x8000CC4C : AT(0x0000D84C) { FILL(0x00000000); build/asm/main_8000CC4C.s.o(.text); build/asm/main_8000CC4C.s.o(.rodata); build/asm/main_8000CC4C.s.o(.data); }
    .main_8000CC4C_bss (NOLOAD) : { build/asm/main_8000CC4C.s.o(.bss); }
    .main_8000CE98 0x8000CE98 : AT(0x0000DA98) { FILL(0x00000000); build/asm/main_8000CE98.s.o(.text); build/asm/main_8000CE98.s.o(.rodata); build/asm/main_8000CE98.s.o(.data); }
    .main_8000CE98_bss (NOLOAD) : { build/asm/main_8000CE98.s.o(.bss); }
    .main_8000E178 0x8000E178 : AT(0x0000ED78) { FILL(0x00000000); build/asm/main_8000E178.s.o(.text); build/asm/main_8000E178.s.o(.rodata); build/asm/main_8000E178.s.o(.data); }
    .main_8000E178_bss (NOLOAD) : { build/asm/main_8000E178.s.o(.bss); }
    .main_8000F7B4 0x8000F7B4 : AT(0x000103B4) { FILL(0x00000000); build/asm/main_8000F7B4.s.o(.text); build/asm/main_8000F7B4.s.o(.rodata); build/asm/main_8000F7B4.s.o(.data); }
    .main_8000F7B4_bss (NOLOAD) : { build/asm/main_8000F7B4.s.o(.bss); }
    .main_800250E0 0x800250E0 : AT(0x00025CE0) { FILL(0x00000000); build/asm/main_800250E0.s.o(.text); build/asm/main_800250E0.s.o(.rodata); build/asm/main_800250E0.s.o(.data); }
    .main_800250E0_bss (NOLOAD) : { build/asm/main_800250E0.s.o(.bss); }
    .main_8002FC50 0x8002FC50 : AT(0x00030850) { FILL(0x00000000); build/asm/main_8002FC50.s.o(.text); build/asm/main_8002FC50.s.o(.rodata); build/asm/main_8002FC50.s.o(.data); }
    .main_8002FC50_bss (NOLOAD) : { build/asm/main_8002FC50.s.o(.bss); }
    .main_800430B0 0x800430B0 : AT(0x00043CB0) { FILL(0x00000000); build/asm/main_800430B0.s.o(.text); build/asm/main_800430B0.s.o(.rodata); build/asm/main_800430B0.s.o(.data); }
    .main_800430B0_bss (NOLOAD) : { build/asm/main_800430B0.s.o(.bss); }
    .main_80045F78 0x80045F78 : AT(0x00046B78) { FILL(0x00000000); build/asm/main_80045F78.s.o(.text); build/asm/main_80045F78.s.o(.rodata); build/asm/main_80045F78.s.o(.data); }
    .main_80045F78_bss (NOLOAD) : { build/asm/main_80045F78.s.o(.bss); }
    .main_80046214 0x80046214 : AT(0x00046E14) { FILL(0x00000000); build/asm/main_80046214.s.o(.text); build/asm/main_80046214.s.o(.rodata); build/asm/main_80046214.s.o(.data); }
    .main_80046214_bss (NOLOAD) : { build/asm/main_80046214.s.o(.bss); }
    .main_80046270 0x80046270 : AT(0x00046E70) { FILL(0x00000000); build/asm/main_80046270.s.o(.text); build/asm/main_80046270.s.o(.rodata); build/asm/main_80046270.s.o(.data); }
    .main_80046270_bss (NOLOAD) : { build/asm/main_80046270.s.o(.bss); }
    .main_80047300 0x80047300 : AT(0x00047F00) { FILL(0x00000000); build/asm/main_80047300.s.o(.text); build/asm/main_80047300.s.o(.rodata); build/asm/main_80047300.s.o(.data); }
    .main_80047300_bss (NOLOAD) : { build/asm/main_80047300.s.o(.bss); }
    .main_80047A6C 0x80047A6C : AT(0x0004866C) { FILL(0x00000000); build/asm/main_80047A6C.s.o(.text); build/asm/main_80047A6C.s.o(.rodata); build/asm/main_80047A6C.s.o(.data); }
    .main_80047A6C_bss (NOLOAD) : { build/asm/main_80047A6C.s.o(.bss); }
    .main_80047C80 0x80047C80 : AT(0x00048880) { FILL(0x00000000); build/asm/main_80047C80.s.o(.text); build/asm/main_80047C80.s.o(.rodata); build/asm/main_80047C80.s.o(.data); }
    .main_80047C80_bss (NOLOAD) : { build/asm/main_80047C80.s.o(.bss); }
    .main_80047E20 0x80047E20 : AT(0x00048A20) { FILL(0x00000000); build/asm/main_80047E20.s.o(.text); build/asm/main_80047E20.s.o(.rodata); build/asm/main_80047E20.s.o(.data); }
    .main_80047E20_bss (NOLOAD) : { build/asm/main_80047E20.s.o(.bss); }
    .main_80048350 0x80048350 : AT(0x00048F50) { FILL(0x00000000); build/asm/main_80048350.s.o(.text); build/asm/main_80048350.s.o(.rodata); build/asm/main_80048350.s.o(.data); }
    .main_80048350_bss (NOLOAD) : { build/asm/main_80048350.s.o(.bss); }
    .main_8004A6DC 0x8004A6DC : AT(0x0004B2DC) { FILL(0x00000000); build/asm/main_8004A6DC.s.o(.text); build/asm/main_8004A6DC.s.o(.rodata); build/asm/main_8004A6DC.s.o(.data); }
    .main_8004A6DC_bss (NOLOAD) : { build/asm/main_8004A6DC.s.o(.bss); }
    .main_8004AA84 0x8004AA84 : AT(0x0004B684) { FILL(0x00000000); build/asm/main_8004AA84.s.o(.text); build/asm/main_8004AA84.s.o(.rodata); build/asm/main_8004AA84.s.o(.data); }
    .main_8004AA84_bss (NOLOAD) : { build/asm/main_8004AA84.s.o(.bss); }
    .main_8004AF1C 0x8004AF1C : AT(0x0004BB1C) { FILL(0x00000000); build/asm/main_8004AF1C.s.o(.text); build/asm/main_8004AF1C.s.o(.rodata); build/asm/main_8004AF1C.s.o(.data); }
    .main_8004AF1C_bss (NOLOAD) : { build/asm/main_8004AF1C.s.o(.bss); }
    .main_80057EB0 0x80057EB0 : AT(0x00058AB0) { FILL(0x00000000); build/asm/main_80057EB0.s.o(.text); build/asm/main_80057EB0.s.o(.rodata); build/asm/main_80057EB0.s.o(.data); }
    .main_80057EB0_bss (NOLOAD) : { build/asm/main_80057EB0.s.o(.bss); }
    .main_80058718 0x80058718 : AT(0x00059318) { FILL(0x00000000); build/asm/main_80058718.s.o(.text); build/asm/main_80058718.s.o(.rodata); build/asm/main_80058718.s.o(.data); }
    .main_80058718_bss (NOLOAD) : { build/asm/main_80058718.s.o(.bss); }
    .main_80058924 0x80058924 : AT(0x00059524) { FILL(0x00000000); build/asm/main_80058924.s.o(.text); build/asm/main_80058924.s.o(.rodata); build/asm/main_80058924.s.o(.data); }
    .main_80058924_bss (NOLOAD) : { build/asm/main_80058924.s.o(.bss); }
    .main_8005D940 0x8005D940 : AT(0x0005E540) { FILL(0x00000000); build/asm/main_8005D940.s.o(.text); build/asm/main_8005D940.s.o(.rodata); build/asm/main_8005D940.s.o(.data); }
    .main_8005D940_bss (NOLOAD) : { build/asm/main_8005D940.s.o(.bss); }
    .main_8005DF84 0x8005DF84 : AT(0x0005EB84) { FILL(0x00000000); build/asm/main_8005DF84.s.o(.text); build/asm/main_8005DF84.s.o(.rodata); build/asm/main_8005DF84.s.o(.data); }
    .main_8005DF84_bss (NOLOAD) : { build/asm/main_8005DF84.s.o(.bss); }
    .main_8005E6DC 0x8005E6DC : AT(0x0005F2DC) { FILL(0x00000000); build/asm/main_8005E6DC.s.o(.text); build/asm/main_8005E6DC.s.o(.rodata); build/asm/main_8005E6DC.s.o(.data); }
    .main_8005E6DC_bss (NOLOAD) : { build/asm/main_8005E6DC.s.o(.bss); }
    .main_8006D9E0 0x8006D9E0 : AT(0x0006E5E0) { FILL(0x00000000); build/asm/main_8006D9E0.s.o(.text); build/asm/main_8006D9E0.s.o(.rodata); build/asm/main_8006D9E0.s.o(.data); }
    .main_8006D9E0_bss (NOLOAD) : { build/asm/main_8006D9E0.s.o(.bss); }
    .main_80070AC0 0x80070AC0 : AT(0x000716C0) { FILL(0x00000000); build/asm/main_80070AC0.s.o(.text); build/asm/main_80070AC0.s.o(.rodata); build/asm/main_80070AC0.s.o(.data); }
    .main_80070AC0_bss (NOLOAD) : { build/asm/main_80070AC0.s.o(.bss); }
    .main_80073A90 0x80073A90 : AT(0x00074690) { FILL(0x00000000); build/asm/main_80073A90.s.o(.text); build/asm/main_80073A90.s.o(.rodata); build/asm/main_80073A90.s.o(.data); }
    .main_80073A90_bss (NOLOAD) : { build/asm/main_80073A90.s.o(.bss); }
    .main_80073E9C 0x80073E9C : AT(0x00074A9C) { FILL(0x00000000); build/asm/main_80073E9C.s.o(.text); build/asm/main_80073E9C.s.o(.rodata); build/asm/main_80073E9C.s.o(.data); }
    .main_80073E9C_bss (NOLOAD) : { build/asm/main_80073E9C.s.o(.bss); }
    .main_8007441C 0x8007441C : AT(0x0007501C) { FILL(0x00000000); build/asm/main_8007441C.s.o(.text); build/asm/main_8007441C.s.o(.rodata); build/asm/main_8007441C.s.o(.data); }
    .main_8007441C_bss (NOLOAD) : { build/asm/main_8007441C.s.o(.bss); }
    .main_80074D60 0x80074D60 : AT(0x00075960) { FILL(0x00000000); build/asm/main_80074D60.s.o(.text); build/asm/main_80074D60.s.o(.rodata); build/asm/main_80074D60.s.o(.data); }
    .main_80074D60_bss (NOLOAD) : { build/asm/main_80074D60.s.o(.bss); }
    .main_80074F7C 0x80074F7C : AT(0x00075B7C) { FILL(0x00000000); build/asm/main_80074F7C.s.o(.text); build/asm/main_80074F7C.s.o(.rodata); build/asm/main_80074F7C.s.o(.data); }
    .main_80074F7C_bss (NOLOAD) : { build/asm/main_80074F7C.s.o(.bss); }
    .main_800753F0 0x800753F0 : AT(0x00075FF0) { FILL(0x00000000); build/asm/main_800753F0.s.o(.text); build/asm/main_800753F0.s.o(.rodata); build/asm/main_800753F0.s.o(.data); }
    .main_800753F0_bss (NOLOAD) : { build/asm/main_800753F0.s.o(.bss); }
    .main_800755F4 0x800755F4 : AT(0x000761F4) { FILL(0x00000000); build/asm/main_800755F4.s.o(.text); build/asm/main_800755F4.s.o(.rodata); build/asm/main_800755F4.s.o(.data); }
    .main_800755F4_bss (NOLOAD) : { build/asm/main_800755F4.s.o(.bss); }
    .main_80075D20 0x80075D20 : AT(0x00076920) { FILL(0x00000000); build/asm/main_80075D20.s.o(.text); build/asm/main_80075D20.s.o(.rodata); build/asm/main_80075D20.s.o(.data); }
    .main_80075D20_bss (NOLOAD) : { build/asm/main_80075D20.s.o(.bss); }
    .main_800780E0 0x800780E0 : AT(0x00078CE0) { FILL(0x00000000); build/asm/main_800780E0.s.o(.text); build/asm/main_800780E0.s.o(.rodata); build/asm/main_800780E0.s.o(.data); }
    .main_800780E0_bss (NOLOAD) : { build/asm/main_800780E0.s.o(.bss); }
    .main_80078764 0x80078764 : AT(0x00079364) { FILL(0x00000000); build/asm/main_80078764.s.o(.text); build/asm/main_80078764.s.o(.rodata); build/asm/main_80078764.s.o(.data); }
    .main_80078764_bss (NOLOAD) : { build/asm/main_80078764.s.o(.bss); }
    .main_80078B40 0x80078B40 : AT(0x00079740) { FILL(0x00000000); build/asm/main_80078B40.s.o(.text); build/asm/main_80078B40.s.o(.rodata); build/asm/main_80078B40.s.o(.data); }
    .main_80078B40_bss (NOLOAD) : { build/asm/main_80078B40.s.o(.bss); }
    .main_80080224 0x80080224 : AT(0x00080E24) { FILL(0x00000000); build/asm/main_80080224.s.o(.text); build/asm/main_80080224.s.o(.rodata); build/asm/main_80080224.s.o(.data); }
    .main_80080224_bss (NOLOAD) : { build/asm/main_80080224.s.o(.bss); }
    .main_800824DC 0x800824DC : AT(0x000830DC) { FILL(0x00000000); build/asm/main_800824DC.s.o(.text); build/asm/main_800824DC.s.o(.rodata); build/asm/main_800824DC.s.o(.data); }
    .main_800824DC_bss (NOLOAD) : { build/asm/main_800824DC.s.o(.bss); }
    .main_80085304 0x80085304 : AT(0x00085F04) { FILL(0x00000000); build/asm/main_80085304.s.o(.text); build/asm/main_80085304.s.o(.rodata); build/asm/main_80085304.s.o(.data); }
    .main_80085304_bss (NOLOAD) : { build/asm/main_80085304.s.o(.bss); }
    .main_80086138 0x80086138 : AT(0x00086D38) { FILL(0x00000000); build/asm/main_80086138.s.o(.text); build/asm/main_80086138.s.o(.rodata); build/asm/main_80086138.s.o(.data); }
    .main_80086138_bss (NOLOAD) : { build/asm/main_80086138.s.o(.bss); }
    .main_80088A04 0x80088A04 : AT(0x00089604) { build/asm/data/main_80088A04.bin.o(.data); }
    .main_80088F78 0x80088F78 : AT(0x00089B78) { build/asm/data/main_80088F78.bin.o(.data); }
    .main_80089008 0x80089008 : AT(0x00089C08) { FILL(0x00000000); build/asm/main_80089008.s.o(.text); build/asm/main_80089008.s.o(.rodata); build/asm/main_80089008.s.o(.data); }
    .main_80089008_bss (NOLOAD) : { build/asm/main_80089008.s.o(.bss); }
    .main_80089018 0x80089018 : AT(0x00089C18) { build/asm/data/main_80089018.bin.o(.data); }
    .main_80089584 0x80089584 : AT(0x0008A184) { FILL(0x00000000); build/asm/main_80089584.s.o(.text); build/asm/main_80089584.s.o(.rodata); build/asm/main_80089584.s.o(.data); }
    .main_80089584_bss (NOLOAD) : { build/asm/main_80089584.s.o(.bss); }
    .main_800895DC 0x800895DC : AT(0x0008A1DC) { build/asm/data/main_800895DC.bin.o(.data); }
    .main_80089D80 0x80089D80 : AT(0x0008A980) { FILL(0x00000000); build/asm/main_80089D80.s.o(.text); build/asm/main_80089D80.s.o(.rodata); build/asm/main_80089D80.s.o(.data); }
    .main_80089D80_bss (NOLOAD) : { build/asm/main_80089D80.s.o(.bss); }
    .main_80089DE8 0x80089DE8 : AT(0x0008A9E8) { build/asm/data/main_80089DE8.bin.o(.data); }
    .main_8008C6B8 0x8008C6B8 : AT(0x0008D2B8) { FILL(0x00000000); build/asm/main_8008C6B8.s.o(.text); build/asm/main_8008C6B8.s.o(.rodata); build/asm/main_8008C6B8.s.o(.data); }
    .main_8008C6B8_bss (NOLOAD) : { build/asm/main_8008C6B8.s.o(.bss); }
    .main_8008C814 0x8008C814 : AT(0x0008D414) { FILL(0x00000000); build/asm/main_8008C814.s.o(.text); build/asm/main_8008C814.s.o(.rodata); build/asm/main_8008C814.s.o(.data); }
    .main_8008C814_bss (NOLOAD) : { build/asm/main_8008C814.s.o(.bss); }
    .main_8008CA54 0x8008CA54 : AT(0x0008D654) { FILL(0x00000000); build/asm/main_8008CA54.s.o(.text); build/asm/main_8008CA54.s.o(.rodata); build/asm/main_8008CA54.s.o(.data); }
    .main_8008CA54_bss (NOLOAD) : { build/asm/main_8008CA54.s.o(.bss); }
    .main_8008CD00 0x8008CD00 : AT(0x0008D900) { FILL(0x00000000); build/asm/main_8008CD00.s.o(.text); build/asm/main_8008CD00.s.o(.rodata); build/asm/main_8008CD00.s.o(.data); }
    .main_8008CD00_bss (NOLOAD) : { build/asm/main_8008CD00.s.o(.bss); }
    .main_8008CFD0 0x8008CFD0 : AT(0x0008DBD0) { FILL(0x00000000); build/asm/main_8008CFD0.s.o(.text); build/asm/main_8008CFD0.s.o(.rodata); build/asm/main_8008CFD0.s.o(.data); }
    .main_8008CFD0_bss (NOLOAD) : { build/asm/main_8008CFD0.s.o(.bss); }
    .main_8008D01C 0x8008D01C : AT(0x0008DC1C) { FILL(0x00000000); build/asm/main_8008D01C.s.o(.text); build/asm/main_8008D01C.s.o(.rodata); build/asm/main_8008D01C.s.o(.data); }
    .main_8008D01C_bss (NOLOAD) : { build/asm/main_8008D01C.s.o(.bss); }
    .main_8008D06C 0x8008D06C : AT(0x0008DC6C) { FILL(0x00000000); build/asm/main_8008D06C.s.o(.text); build/asm/main_8008D06C.s.o(.rodata); build/asm/main_8008D06C.s.o(.data); }
    .main_8008D06C_bss (NOLOAD) : { build/asm/main_8008D06C.s.o(.bss); }
    .main_8008D0A4 0x8008D0A4 : AT(0x0008DCA4) { build/asm/data/main_8008D0A4.bin.o(.data); }
    .main_8008D134 0x8008D134 : AT(0x0008DD34) { FILL(0x00000000); build/asm/main_8008D134.s.o(.text); build/asm/main_8008D134.s.o(.rodata); build/asm/main_8008D134.s.o(.data); }
    .main_8008D134_bss (NOLOAD) : { build/asm/main_8008D134.s.o(.bss); }
    .main_8008D1F0 0x8008D1F0 : AT(0x0008DDF0) { build/asm/data/main_8008D1F0.bin.o(.data); }
    .main_8008D2AC 0x8008D2AC : AT(0x0008DEAC) { FILL(0x00000000); build/asm/main_8008D2AC.s.o(.text); build/asm/main_8008D2AC.s.o(.rodata); build/asm/main_8008D2AC.s.o(.data); }
    .main_8008D2AC_bss (NOLOAD) : { build/asm/main_8008D2AC.s.o(.bss); }
    .main_8008D368 0x8008D368 : AT(0x0008DF68) { FILL(0x00000000); build/asm/main_8008D368.s.o(.text); build/asm/main_8008D368.s.o(.rodata); build/asm/main_8008D368.s.o(.data); }
    .main_8008D368_bss (NOLOAD) : { build/asm/main_8008D368.s.o(.bss); }
    .main_8008DCC8 0x8008DCC8 : AT(0x0008E8C8) { FILL(0x00000000); build/asm/main_8008DCC8.s.o(.text); build/asm/main_8008DCC8.s.o(.rodata); build/asm/main_8008DCC8.s.o(.data); }
    .main_8008DCC8_bss (NOLOAD) : { build/asm/main_8008DCC8.s.o(.bss); }
    .main_8008DF64 0x8008DF64 : AT(0x0008EB64) { FILL(0x00000000); build/asm/main_8008DF64.s.o(.text); build/asm/main_8008DF64.s.o(.rodata); build/asm/main_8008DF64.s.o(.data); }
    .main_8008DF64_bss (NOLOAD) : { build/asm/main_8008DF64.s.o(.bss); }
    .main_80093960 0x80093960 : AT(0x00094560) { build/asm/data/main_80093960.bin.o(.data); }
    .main_80094374 0x80094374 : AT(0x00094F74) { FILL(0x00000000); build/asm/main_80094374.s.o(.text); build/asm/main_80094374.s.o(.rodata); build/asm/main_80094374.s.o(.data); }
    .main_80094374_bss (NOLOAD) : { build/asm/main_80094374.s.o(.bss); }
    .main_80094384 0x80094384 : AT(0x00094F84) { build/asm/data/main_80094384.bin.o(.data); }
    .main_800994DC 0x800994DC : AT(0x0009A0DC) { FILL(0x00000000); build/asm/main_800994DC.s.o(.text); build/asm/main_800994DC.s.o(.rodata); build/asm/main_800994DC.s.o(.data); }
    .main_800994DC_bss (NOLOAD) : { build/asm/main_800994DC.s.o(.bss); }
    .main_8009AA9C 0x8009AA9C : AT(0x0009B69C) { build/asm/data/main_8009AA9C.bin.o(.data); }
    .main_8009AF90 0x8009AF90 : AT(0x0009BB90) { FILL(0x00000000); build/asm/main_8009AF90.s.o(.text); build/asm/main_8009AF90.s.o(.rodata); build/asm/main_8009AF90.s.o(.data); }
    .main_8009AF90_bss (NOLOAD) : { build/asm/main_8009AF90.s.o(.bss); }
    .main_8009BAAC 0x8009BAAC : AT(0x0009C6AC) { build/asm/data/main_8009BAAC.bin.o(.data); }
    .main_8009BEF4 0x8009BEF4 : AT(0x0009CAF4) { FILL(0x00000000); build/asm/main_8009BEF4.s.o(.text); build/asm/main_8009BEF4.s.o(.rodata); build/asm/main_8009BEF4.s.o(.data); }
    .main_8009BEF4_bss (NOLOAD) : { build/asm/main_8009BEF4.s.o(.bss); }
    .main_8009BFF0 0x8009BFF0 : AT(0x0009CBF0) { FILL(0x00000000); build/asm/main_8009BFF0.s.o(.text); build/asm/main_8009BFF0.s.o(.rodata); build/asm/main_8009BFF0.s.o(.data); }
    .main_8009BFF0_bss (NOLOAD) : { build/asm/main_8009BFF0.s.o(.bss); }
    .main_8009C7F0 0x8009C7F0 : AT(0x0009D3F0) { build/asm/data/main_8009C7F0.bin.o(.data); }
    .main_8009CC40 0x8009CC40 : AT(0x0009D840) { FILL(0x00000000); build/asm/main_8009CC40.s.o(.text); build/asm/main_8009CC40.s.o(.rodata); build/asm/main_8009CC40.s.o(.data); }
    .main_8009CC40_bss (NOLOAD) : { build/asm/main_8009CC40.s.o(.bss); }
    .main_8009CCBC 0x8009CCBC : AT(0x0009D8BC) { FILL(0x00000000); build/asm/main_8009CCBC.s.o(.text); build/asm/main_8009CCBC.s.o(.rodata); build/asm/main_8009CCBC.s.o(.data); }
    .main_8009CCBC_bss (NOLOAD) : { build/asm/main_8009CCBC.s.o(.bss); }
    .main_8009CF28 0x8009CF28 : AT(0x0009DB28) { build/asm/data/main_8009CF28.bin.o(.data); }
    .main_8009CF44 0x8009CF44 : AT(0x0009DB44) { build/asm/data/main_8009CF44.bin.o(.data); }
    .main_8009D2C0 0x8009D2C0 : AT(0x0009DEC0) { FILL(0x00000000); build/asm/main_8009D2C0.s.o(.text); build/asm/main_8009D2C0.s.o(.rodata); build/asm/main_8009D2C0.s.o(.data); }
    .main_8009D2C0_bss (NOLOAD) : { build/asm/main_8009D2C0.s.o(.bss); }
    .main_8009D33C 0x8009D33C : AT(0x0009DF3C) { FILL(0x00000000); build/asm/main_8009D33C.s.o(.text); build/asm/main_8009D33C.s.o(.rodata); build/asm/main_8009D33C.s.o(.data); }
    .main_8009D33C_bss (NOLOAD) : { build/asm/main_8009D33C.s.o(.bss); }
    .main_8009F9DC 0x8009F9DC : AT(0x000A05DC) { FILL(0x00000000); build/asm/main_8009F9DC.s.o(.text); build/asm/main_8009F9DC.s.o(.rodata); build/asm/main_8009F9DC.s.o(.data); }
    .main_8009F9DC_bss (NOLOAD) : { build/asm/main_8009F9DC.s.o(.bss); }
    .main_800A3A2C 0x800A3A2C : AT(0x000A462C) { FILL(0x00000000); build/asm/main_800A3A2C.s.o(.text); build/asm/main_800A3A2C.s.o(.rodata); build/asm/main_800A3A2C.s.o(.data); }
    .main_800A3A2C_bss (NOLOAD) : { build/asm/main_800A3A2C.s.o(.bss); }
    .main_800A5A5C 0x800A5A5C : AT(0x000A665C) { build/asm/data/main_800A5A5C.bin.o(.data); }
    .main_800A73D8 0x800A73D8 : AT(0x000A7FD8) { FILL(0x00000000); build/asm/main_800A73D8.s.o(.text); build/asm/main_800A73D8.s.o(.rodata); build/asm/main_800A73D8.s.o(.data); }
    .main_800A73D8_bss (NOLOAD) : { build/asm/main_800A73D8.s.o(.bss); }
    .main_800AAAC8 0x800AAAC8 : AT(0x000AB6C8) { FILL(0x00000000); build/asm/main_800AAAC8.s.o(.text); build/asm/main_800AAAC8.s.o(.rodata); build/asm/main_800AAAC8.s.o(.data); }
    .main_800AAAC8_bss (NOLOAD) : { build/asm/main_800AAAC8.s.o(.bss); }
    .main_800AAD64 0x800AAD64 : AT(0x000AB964) { FILL(0x00000000); build/asm/main_800AAD64.s.o(.text); build/asm/main_800AAD64.s.o(.rodata); build/asm/main_800AAD64.s.o(.data); }
    .main_800AAD64_bss (NOLOAD) : { build/asm/main_800AAD64.s.o(.bss); }
    .main_800AB664 0x800AB664 : AT(0x000AC264) { FILL(0x00000000); build/asm/main_800AB664.s.o(.text); build/asm/main_800AB664.s.o(.rodata); build/asm/main_800AB664.s.o(.data); }
    .main_800AB664_bss (NOLOAD) : { build/asm/main_800AB664.s.o(.bss); }
    .main_800B53E8 0x800B53E8 : AT(0x000B5FE8) { FILL(0x00000000); build/asm/main_800B53E8.s.o(.text); build/asm/main_800B53E8.s.o(.rodata); build/asm/main_800B53E8.s.o(.data); }
    .main_800B53E8_bss (NOLOAD) : { build/asm/main_800B53E8.s.o(.bss); }
    .main_800CFAF4 0x800CFAF4 : AT(0x000D06F4) { FILL(0x00000000); build/asm/main_800CFAF4.s.o(.text); build/asm/main_800CFAF4.s.o(.rodata); build/asm/main_800CFAF4.s.o(.data); }
    .main_800CFAF4_bss (NOLOAD) : { build/asm/main_800CFAF4.s.o(.bss); }
    .main_800CFB50 0x800CFB50 : AT(0x000D0750) { build/asm/data/main_800CFB50.bin.o(.data); }
    .main_800F57D8 0x800F57D8 : AT(0x000F63D8) { FILL(0x00000000); build/asm/main_800F57D8.s.o(.text); build/asm/main_800F57D8.s.o(.rodata); build/asm/main_800F57D8.s.o(.data); }
    .main_800F57D8_bss (NOLOAD) : { build/asm/main_800F57D8.s.o(.bss); }
    .main_800F5908 0x800F5908 : AT(0x000F6508) { build/asm/data/main_800F5908.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
