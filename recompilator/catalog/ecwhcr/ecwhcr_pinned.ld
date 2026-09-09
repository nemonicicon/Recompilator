SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80001800 0x80001800 : AT(0x00002400) { build/asm/data/main_80001800.bin.o(.data); }
    .main_80006DB4 0x80006DB4 : AT(0x000079B4) { FILL(0x00000000); build/asm/main_80006DB4.s.o(.text); build/asm/main_80006DB4.s.o(.rodata); build/asm/main_80006DB4.s.o(.data); }
    .main_80006DB4_bss (NOLOAD) : { build/asm/main_80006DB4.s.o(.bss); }
    .main_80006DD4 0x80006DD4 : AT(0x000079D4) { build/asm/data/main_80006DD4.bin.o(.data); }
    .main_800071C4 0x800071C4 : AT(0x00007DC4) { FILL(0x00000000); build/asm/main_800071C4.s.o(.text); build/asm/main_800071C4.s.o(.rodata); build/asm/main_800071C4.s.o(.data); }
    .main_800071C4_bss (NOLOAD) : { build/asm/main_800071C4.s.o(.bss); }
    .main_800071E4 0x800071E4 : AT(0x00007DE4) { build/asm/data/main_800071E4.bin.o(.data); }
    .main_800073B4 0x800073B4 : AT(0x00007FB4) { FILL(0x00000000); build/asm/main_800073B4.s.o(.text); build/asm/main_800073B4.s.o(.rodata); build/asm/main_800073B4.s.o(.data); }
    .main_800073B4_bss (NOLOAD) : { build/asm/main_800073B4.s.o(.bss); }
    .main_800073D4 0x800073D4 : AT(0x00007FD4) { build/asm/data/main_800073D4.bin.o(.data); }
    .main_80008A18 0x80008A18 : AT(0x00009618) { FILL(0x00000000); build/asm/main_80008A18.s.o(.text); build/asm/main_80008A18.s.o(.rodata); build/asm/main_80008A18.s.o(.data); }
    .main_80008A18_bss (NOLOAD) : { build/asm/main_80008A18.s.o(.bss); }
    .main_8000B7EC 0x8000B7EC : AT(0x0000C3EC) { build/asm/data/main_8000B7EC.bin.o(.data); }
    .main_8000BA28 0x8000BA28 : AT(0x0000C628) { FILL(0x00000000); build/asm/main_8000BA28.s.o(.text); build/asm/main_8000BA28.s.o(.rodata); build/asm/main_8000BA28.s.o(.data); }
    .main_8000BA28_bss (NOLOAD) : { build/asm/main_8000BA28.s.o(.bss); }
    .main_8000C9B0 0x8000C9B0 : AT(0x0000D5B0) { build/asm/data/main_8000C9B0.bin.o(.data); }
    .main_80010CEC 0x80010CEC : AT(0x000118EC) { FILL(0x00000000); build/asm/main_80010CEC.s.o(.text); build/asm/main_80010CEC.s.o(.rodata); build/asm/main_80010CEC.s.o(.data); }
    .main_80010CEC_bss (NOLOAD) : { build/asm/main_80010CEC.s.o(.bss); }
    .main_80010CF4 0x80010CF4 : AT(0x000118F4) { build/asm/data/main_80010CF4.bin.o(.data); }
    .main_80013E94 0x80013E94 : AT(0x00014A94) { FILL(0x00000000); build/asm/main_80013E94.s.o(.text); build/asm/main_80013E94.s.o(.rodata); build/asm/main_80013E94.s.o(.data); }
    .main_80013E94_bss (NOLOAD) : { build/asm/main_80013E94.s.o(.bss); }
    .main_80013EA8 0x80013EA8 : AT(0x00014AA8) { build/asm/data/main_80013EA8.bin.o(.data); }
    .main_80017FDC 0x80017FDC : AT(0x00018BDC) { FILL(0x00000000); build/asm/main_80017FDC.s.o(.text); build/asm/main_80017FDC.s.o(.rodata); build/asm/main_80017FDC.s.o(.data); }
    .main_80017FDC_bss (NOLOAD) : { build/asm/main_80017FDC.s.o(.bss); }
    .main_80018018 0x80018018 : AT(0x00018C18) { build/asm/data/main_80018018.bin.o(.data); }
    .main_800273D4 0x800273D4 : AT(0x00027FD4) { FILL(0x00000000); build/asm/main_800273D4.s.o(.text); build/asm/main_800273D4.s.o(.rodata); build/asm/main_800273D4.s.o(.data); }
    .main_800273D4_bss (NOLOAD) : { build/asm/main_800273D4.s.o(.bss); }
    .main_800273E0 0x800273E0 : AT(0x00027FE0) { build/asm/data/main_800273E0.bin.o(.data); }
    .main_80036838 0x80036838 : AT(0x00037438) { FILL(0x00000000); build/asm/main_80036838.s.o(.text); build/asm/main_80036838.s.o(.rodata); build/asm/main_80036838.s.o(.data); }
    .main_80036838_bss (NOLOAD) : { build/asm/main_80036838.s.o(.bss); }
    .main_80036874 0x80036874 : AT(0x00037474) { build/asm/data/main_80036874.bin.o(.data); }
    .main_80036F28 0x80036F28 : AT(0x00037B28) { FILL(0x00000000); build/asm/main_80036F28.s.o(.text); build/asm/main_80036F28.s.o(.rodata); build/asm/main_80036F28.s.o(.data); }
    .main_80036F28_bss (NOLOAD) : { build/asm/main_80036F28.s.o(.bss); }
    .main_80036F30 0x80036F30 : AT(0x00037B30) { build/asm/data/main_80036F30.bin.o(.data); }
    .main_8003E400 0x8003E400 : AT(0x0003F000) { FILL(0x00000000); build/asm/main_8003E400.s.o(.text); build/asm/main_8003E400.s.o(.rodata); build/asm/main_8003E400.s.o(.data); }
    .main_8003E400_bss (NOLOAD) : { build/asm/main_8003E400.s.o(.bss); }
    .main_8003E4A0 0x8003E4A0 : AT(0x0003F0A0) { build/asm/data/main_8003E4A0.bin.o(.data); }
    .main_800400E0 0x800400E0 : AT(0x00040CE0) { FILL(0x00000000); build/asm/main_800400E0.s.o(.text); build/asm/main_800400E0.s.o(.rodata); build/asm/main_800400E0.s.o(.data); }
    .main_800400E0_bss (NOLOAD) : { build/asm/main_800400E0.s.o(.bss); }
    .main_800400F8 0x800400F8 : AT(0x00040CF8) { build/asm/data/main_800400F8.bin.o(.data); }
    .main_80046B20 0x80046B20 : AT(0x00047720) { FILL(0x00000000); build/asm/main_80046B20.s.o(.text); build/asm/main_80046B20.s.o(.rodata); build/asm/main_80046B20.s.o(.data); }
    .main_80046B20_bss (NOLOAD) : { build/asm/main_80046B20.s.o(.bss); }
    .main_80046B64 0x80046B64 : AT(0x00047764) { build/asm/data/main_80046B64.bin.o(.data); }
    .main_800502B8 0x800502B8 : AT(0x00050EB8) { FILL(0x00000000); build/asm/main_800502B8.s.o(.text); build/asm/main_800502B8.s.o(.rodata); build/asm/main_800502B8.s.o(.data); }
    .main_800502B8_bss (NOLOAD) : { build/asm/main_800502B8.s.o(.bss); }
    .main_80050338 0x80050338 : AT(0x00050F38) { build/asm/data/main_80050338.bin.o(.data); }
    .main_8005C63C 0x8005C63C : AT(0x0005D23C) { FILL(0x00000000); build/asm/main_8005C63C.s.o(.text); build/asm/main_8005C63C.s.o(.rodata); build/asm/main_8005C63C.s.o(.data); }
    .main_8005C63C_bss (NOLOAD) : { build/asm/main_8005C63C.s.o(.bss); }
    .main_8005C6AC 0x8005C6AC : AT(0x0005D2AC) { build/asm/data/main_8005C6AC.bin.o(.data); }
    .main_800624BC 0x800624BC : AT(0x000630BC) { FILL(0x00000000); build/asm/main_800624BC.s.o(.text); build/asm/main_800624BC.s.o(.rodata); build/asm/main_800624BC.s.o(.data); }
    .main_800624BC_bss (NOLOAD) : { build/asm/main_800624BC.s.o(.bss); }
    .main_80062534 0x80062534 : AT(0x00063134) { build/asm/data/main_80062534.bin.o(.data); }
    .main_80078294 0x80078294 : AT(0x00078E94) { FILL(0x00000000); build/asm/main_80078294.s.o(.text); build/asm/main_80078294.s.o(.rodata); build/asm/main_80078294.s.o(.data); }
    .main_80078294_bss (NOLOAD) : { build/asm/main_80078294.s.o(.bss); }
    .main_800782A4 0x800782A4 : AT(0x00078EA4) { build/asm/data/main_800782A4.bin.o(.data); }
    .main_8007BF78 0x8007BF78 : AT(0x0007CB78) { FILL(0x00000000); build/asm/main_8007BF78.s.o(.text); build/asm/main_8007BF78.s.o(.rodata); build/asm/main_8007BF78.s.o(.data); }
    .main_8007BF78_bss (NOLOAD) : { build/asm/main_8007BF78.s.o(.bss); }
    .main_8007BFA4 0x8007BFA4 : AT(0x0007CBA4) { build/asm/data/main_8007BFA4.bin.o(.data); }
    .main_8007ECDC 0x8007ECDC : AT(0x0007F8DC) { FILL(0x00000000); build/asm/main_8007ECDC.s.o(.text); build/asm/main_8007ECDC.s.o(.rodata); build/asm/main_8007ECDC.s.o(.data); }
    .main_8007ECDC_bss (NOLOAD) : { build/asm/main_8007ECDC.s.o(.bss); }
    .main_8007EDD4 0x8007EDD4 : AT(0x0007F9D4) { build/asm/data/main_8007EDD4.bin.o(.data); }
    .main_8007F0D8 0x8007F0D8 : AT(0x0007FCD8) { FILL(0x00000000); build/asm/main_8007F0D8.s.o(.text); build/asm/main_8007F0D8.s.o(.rodata); build/asm/main_8007F0D8.s.o(.data); }
    .main_8007F0D8_bss (NOLOAD) : { build/asm/main_8007F0D8.s.o(.bss); }
    .main_8007F0FC 0x8007F0FC : AT(0x0007FCFC) { build/asm/data/main_8007F0FC.bin.o(.data); }
    .main_8008A700 0x8008A700 : AT(0x0008B300) { FILL(0x00000000); build/asm/main_8008A700.s.o(.text); build/asm/main_8008A700.s.o(.rodata); build/asm/main_8008A700.s.o(.data); }
    .main_8008A700_bss (NOLOAD) : { build/asm/main_8008A700.s.o(.bss); }
    .main_8008A714 0x8008A714 : AT(0x0008B314) { build/asm/data/main_8008A714.bin.o(.data); }
    .main_800A011C 0x800A011C : AT(0x000A0D1C) { FILL(0x00000000); build/asm/main_800A011C.s.o(.text); build/asm/main_800A011C.s.o(.rodata); build/asm/main_800A011C.s.o(.data); }
    .main_800A011C_bss (NOLOAD) : { build/asm/main_800A011C.s.o(.bss); }
    .main_800A0148 0x800A0148 : AT(0x000A0D48) { build/asm/data/main_800A0148.bin.o(.data); }
    .main_800CCD04 0x800CCD04 : AT(0x000CD904) { FILL(0x00000000); build/asm/main_800CCD04.s.o(.text); build/asm/main_800CCD04.s.o(.rodata); build/asm/main_800CCD04.s.o(.data); }
    .main_800CCD04_bss (NOLOAD) : { build/asm/main_800CCD04.s.o(.bss); }
    .main_800CCD38 0x800CCD38 : AT(0x000CD938) { build/asm/data/main_800CCD38.bin.o(.data); }
    .main_800CDA1C 0x800CDA1C : AT(0x000CE61C) { FILL(0x00000000); build/asm/main_800CDA1C.s.o(.text); build/asm/main_800CDA1C.s.o(.rodata); build/asm/main_800CDA1C.s.o(.data); }
    .main_800CDA1C_bss (NOLOAD) : { build/asm/main_800CDA1C.s.o(.bss); }
    .main_800CDA64 0x800CDA64 : AT(0x000CE664) { build/asm/data/main_800CDA64.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
