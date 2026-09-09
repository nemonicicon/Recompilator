SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_8000348C 0x8000348C : AT(0x0000408C) { FILL(0x00000000); build/asm/main_8000348C.s.o(.text); build/asm/main_8000348C.s.o(.rodata); build/asm/main_8000348C.s.o(.data); }
    .main_8000348C_bss (NOLOAD) : { build/asm/main_8000348C.s.o(.bss); }
    .main_800042B8 0x800042B8 : AT(0x00004EB8) { FILL(0x00000000); build/asm/main_800042B8.s.o(.text); build/asm/main_800042B8.s.o(.rodata); build/asm/main_800042B8.s.o(.data); }
    .main_800042B8_bss (NOLOAD) : { build/asm/main_800042B8.s.o(.bss); }
    .main_800057C0 0x800057C0 : AT(0x000063C0) { FILL(0x00000000); build/asm/main_800057C0.s.o(.text); build/asm/main_800057C0.s.o(.rodata); build/asm/main_800057C0.s.o(.data); }
    .main_800057C0_bss (NOLOAD) : { build/asm/main_800057C0.s.o(.bss); }
    .main_80006E44 0x80006E44 : AT(0x00007A44) { FILL(0x00000000); build/asm/main_80006E44.s.o(.text); build/asm/main_80006E44.s.o(.rodata); build/asm/main_80006E44.s.o(.data); }
    .main_80006E44_bss (NOLOAD) : { build/asm/main_80006E44.s.o(.bss); }
    .main_80007470 0x80007470 : AT(0x00008070) { FILL(0x00000000); build/asm/main_80007470.s.o(.text); build/asm/main_80007470.s.o(.rodata); build/asm/main_80007470.s.o(.data); }
    .main_80007470_bss (NOLOAD) : { build/asm/main_80007470.s.o(.bss); }
    .main_8000C1E0 0x8000C1E0 : AT(0x0000CDE0) { FILL(0x00000000); build/asm/main_8000C1E0.s.o(.text); build/asm/main_8000C1E0.s.o(.rodata); build/asm/main_8000C1E0.s.o(.data); }
    .main_8000C1E0_bss (NOLOAD) : { build/asm/main_8000C1E0.s.o(.bss); }
    .main_8000C338 0x8000C338 : AT(0x0000CF38) { FILL(0x00000000); build/asm/main_8000C338.s.o(.text); build/asm/main_8000C338.s.o(.rodata); build/asm/main_8000C338.s.o(.data); }
    .main_8000C338_bss (NOLOAD) : { build/asm/main_8000C338.s.o(.bss); }
    .main_8000D34C 0x8000D34C : AT(0x0000DF4C) { FILL(0x00000000); build/asm/main_8000D34C.s.o(.text); build/asm/main_8000D34C.s.o(.rodata); build/asm/main_8000D34C.s.o(.data); }
    .main_8000D34C_bss (NOLOAD) : { build/asm/main_8000D34C.s.o(.bss); }
    .main_800115BC 0x800115BC : AT(0x000121BC) { FILL(0x00000000); build/asm/main_800115BC.s.o(.text); build/asm/main_800115BC.s.o(.rodata); build/asm/main_800115BC.s.o(.data); }
    .main_800115BC_bss (NOLOAD) : { build/asm/main_800115BC.s.o(.bss); }
    .main_80018360 0x80018360 : AT(0x00018F60) { FILL(0x00000000); build/asm/main_80018360.s.o(.text); build/asm/main_80018360.s.o(.rodata); build/asm/main_80018360.s.o(.data); }
    .main_80018360_bss (NOLOAD) : { build/asm/main_80018360.s.o(.bss); }
    .main_80018938 0x80018938 : AT(0x00019538) { FILL(0x00000000); build/asm/main_80018938.s.o(.text); build/asm/main_80018938.s.o(.rodata); build/asm/main_80018938.s.o(.data); }
    .main_80018938_bss (NOLOAD) : { build/asm/main_80018938.s.o(.bss); }
    .main_800192F8 0x800192F8 : AT(0x00019EF8) { FILL(0x00000000); build/asm/main_800192F8.s.o(.text); build/asm/main_800192F8.s.o(.rodata); build/asm/main_800192F8.s.o(.data); }
    .main_800192F8_bss (NOLOAD) : { build/asm/main_800192F8.s.o(.bss); }
    .main_8001A180 0x8001A180 : AT(0x0001AD80) { FILL(0x00000000); build/asm/main_8001A180.s.o(.text); build/asm/main_8001A180.s.o(.rodata); build/asm/main_8001A180.s.o(.data); }
    .main_8001A180_bss (NOLOAD) : { build/asm/main_8001A180.s.o(.bss); }
    .main_8001AB70 0x8001AB70 : AT(0x0001B770) { FILL(0x00000000); build/asm/main_8001AB70.s.o(.text); build/asm/main_8001AB70.s.o(.rodata); build/asm/main_8001AB70.s.o(.data); }
    .main_8001AB70_bss (NOLOAD) : { build/asm/main_8001AB70.s.o(.bss); }
    .main_80027C4C 0x80027C4C : AT(0x0002884C) { FILL(0x00000000); build/asm/main_80027C4C.s.o(.text); build/asm/main_80027C4C.s.o(.rodata); build/asm/main_80027C4C.s.o(.data); }
    .main_80027C4C_bss (NOLOAD) : { build/asm/main_80027C4C.s.o(.bss); }
    .main_80027D88 0x80027D88 : AT(0x00028988) { FILL(0x00000000); build/asm/main_80027D88.s.o(.text); build/asm/main_80027D88.s.o(.rodata); build/asm/main_80027D88.s.o(.data); }
    .main_80027D88_bss (NOLOAD) : { build/asm/main_80027D88.s.o(.bss); }
    .main_8002BE90 0x8002BE90 : AT(0x0002CA90) { FILL(0x00000000); build/asm/main_8002BE90.s.o(.text); build/asm/main_8002BE90.s.o(.rodata); build/asm/main_8002BE90.s.o(.data); }
    .main_8002BE90_bss (NOLOAD) : { build/asm/main_8002BE90.s.o(.bss); }
    .main_8002CB0C 0x8002CB0C : AT(0x0002D70C) { FILL(0x00000000); build/asm/main_8002CB0C.s.o(.text); build/asm/main_8002CB0C.s.o(.rodata); build/asm/main_8002CB0C.s.o(.data); }
    .main_8002CB0C_bss (NOLOAD) : { build/asm/main_8002CB0C.s.o(.bss); }
    .main_8002DB04 0x8002DB04 : AT(0x0002E704) { FILL(0x00000000); build/asm/main_8002DB04.s.o(.text); build/asm/main_8002DB04.s.o(.rodata); build/asm/main_8002DB04.s.o(.data); }
    .main_8002DB04_bss (NOLOAD) : { build/asm/main_8002DB04.s.o(.bss); }
    .main_8002DCF4 0x8002DCF4 : AT(0x0002E8F4) { FILL(0x00000000); build/asm/main_8002DCF4.s.o(.text); build/asm/main_8002DCF4.s.o(.rodata); build/asm/main_8002DCF4.s.o(.data); }
    .main_8002DCF4_bss (NOLOAD) : { build/asm/main_8002DCF4.s.o(.bss); }
    .main_8002E780 0x8002E780 : AT(0x0002F380) { FILL(0x00000000); build/asm/main_8002E780.s.o(.text); build/asm/main_8002E780.s.o(.rodata); build/asm/main_8002E780.s.o(.data); }
    .main_8002E780_bss (NOLOAD) : { build/asm/main_8002E780.s.o(.bss); }
    .main_8002EBA0 0x8002EBA0 : AT(0x0002F7A0) { FILL(0x00000000); build/asm/main_8002EBA0.s.o(.text); build/asm/main_8002EBA0.s.o(.rodata); build/asm/main_8002EBA0.s.o(.data); }
    .main_8002EBA0_bss (NOLOAD) : { build/asm/main_8002EBA0.s.o(.bss); }
    .main_80030A48 0x80030A48 : AT(0x00031648) { FILL(0x00000000); build/asm/main_80030A48.s.o(.text); build/asm/main_80030A48.s.o(.rodata); build/asm/main_80030A48.s.o(.data); }
    .main_80030A48_bss (NOLOAD) : { build/asm/main_80030A48.s.o(.bss); }
    .main_8003287C 0x8003287C : AT(0x0003347C) { FILL(0x00000000); build/asm/main_8003287C.s.o(.text); build/asm/main_8003287C.s.o(.rodata); build/asm/main_8003287C.s.o(.data); }
    .main_8003287C_bss (NOLOAD) : { build/asm/main_8003287C.s.o(.bss); }
    .main_80032CF0 0x80032CF0 : AT(0x000338F0) { FILL(0x00000000); build/asm/main_80032CF0.s.o(.text); build/asm/main_80032CF0.s.o(.rodata); build/asm/main_80032CF0.s.o(.data); }
    .main_80032CF0_bss (NOLOAD) : { build/asm/main_80032CF0.s.o(.bss); }
    .main_8003362C 0x8003362C : AT(0x0003422C) { FILL(0x00000000); build/asm/main_8003362C.s.o(.text); build/asm/main_8003362C.s.o(.rodata); build/asm/main_8003362C.s.o(.data); }
    .main_8003362C_bss (NOLOAD) : { build/asm/main_8003362C.s.o(.bss); }
    .main_80033C7C 0x80033C7C : AT(0x0003487C) { FILL(0x00000000); build/asm/main_80033C7C.s.o(.text); build/asm/main_80033C7C.s.o(.rodata); build/asm/main_80033C7C.s.o(.data); }
    .main_80033C7C_bss (NOLOAD) : { build/asm/main_80033C7C.s.o(.bss); }
    .main_800347B4 0x800347B4 : AT(0x000353B4) { FILL(0x00000000); build/asm/main_800347B4.s.o(.text); build/asm/main_800347B4.s.o(.rodata); build/asm/main_800347B4.s.o(.data); }
    .main_800347B4_bss (NOLOAD) : { build/asm/main_800347B4.s.o(.bss); }
    .main_800360B4 0x800360B4 : AT(0x00036CB4) { FILL(0x00000000); build/asm/main_800360B4.s.o(.text); build/asm/main_800360B4.s.o(.rodata); build/asm/main_800360B4.s.o(.data); }
    .main_800360B4_bss (NOLOAD) : { build/asm/main_800360B4.s.o(.bss); }
    .main_80036448 0x80036448 : AT(0x00037048) { FILL(0x00000000); build/asm/main_80036448.s.o(.text); build/asm/main_80036448.s.o(.rodata); build/asm/main_80036448.s.o(.data); }
    .main_80036448_bss (NOLOAD) : { build/asm/main_80036448.s.o(.bss); }
    .main_80037780 0x80037780 : AT(0x00038380) { build/asm/data/main_80037780.bin.o(.data); }
    .main_80038974 0x80038974 : AT(0x00039574) { build/asm/data/main_80038974.bin.o(.data); }
    .main_80039E20 0x80039E20 : AT(0x0003AA20) { FILL(0x00000000); build/asm/main_80039E20.s.o(.text); build/asm/main_80039E20.s.o(.rodata); build/asm/main_80039E20.s.o(.data); }
    .main_80039E20_bss (NOLOAD) : { build/asm/main_80039E20.s.o(.bss); }
    .main_8003A670 0x8003A670 : AT(0x0003B270) { FILL(0x00000000); build/asm/main_8003A670.s.o(.text); build/asm/main_8003A670.s.o(.rodata); build/asm/main_8003A670.s.o(.data); }
    .main_8003A670_bss (NOLOAD) : { build/asm/main_8003A670.s.o(.bss); }
    .main_8003AD80 0x8003AD80 : AT(0x0003B980) { FILL(0x00000000); build/asm/main_8003AD80.s.o(.text); build/asm/main_8003AD80.s.o(.rodata); build/asm/main_8003AD80.s.o(.data); }
    .main_8003AD80_bss (NOLOAD) : { build/asm/main_8003AD80.s.o(.bss); }
    .main_8003B280 0x8003B280 : AT(0x0003BE80) { FILL(0x00000000); build/asm/main_8003B280.s.o(.text); build/asm/main_8003B280.s.o(.rodata); build/asm/main_8003B280.s.o(.data); }
    .main_8003B280_bss (NOLOAD) : { build/asm/main_8003B280.s.o(.bss); }
    .main_8003CC48 0x8003CC48 : AT(0x0003D848) { FILL(0x00000000); build/asm/main_8003CC48.s.o(.text); build/asm/main_8003CC48.s.o(.rodata); build/asm/main_8003CC48.s.o(.data); }
    .main_8003CC48_bss (NOLOAD) : { build/asm/main_8003CC48.s.o(.bss); }
    .main_8003DB88 0x8003DB88 : AT(0x0003E788) { FILL(0x00000000); build/asm/main_8003DB88.s.o(.text); build/asm/main_8003DB88.s.o(.rodata); build/asm/main_8003DB88.s.o(.data); }
    .main_8003DB88_bss (NOLOAD) : { build/asm/main_8003DB88.s.o(.bss); }
    .main_8003E158 0x8003E158 : AT(0x0003ED58) { FILL(0x00000000); build/asm/main_8003E158.s.o(.text); build/asm/main_8003E158.s.o(.rodata); build/asm/main_8003E158.s.o(.data); }
    .main_8003E158_bss (NOLOAD) : { build/asm/main_8003E158.s.o(.bss); }
    .main_8003E2E8 0x8003E2E8 : AT(0x0003EEE8) { FILL(0x00000000); build/asm/main_8003E2E8.s.o(.text); build/asm/main_8003E2E8.s.o(.rodata); build/asm/main_8003E2E8.s.o(.data); }
    .main_8003E2E8_bss (NOLOAD) : { build/asm/main_8003E2E8.s.o(.bss); }
    .main_8003FF50 0x8003FF50 : AT(0x00040B50) { FILL(0x00000000); build/asm/main_8003FF50.s.o(.text); build/asm/main_8003FF50.s.o(.rodata); build/asm/main_8003FF50.s.o(.data); }
    .main_8003FF50_bss (NOLOAD) : { build/asm/main_8003FF50.s.o(.bss); }
    .main_8004082C 0x8004082C : AT(0x0004142C) { FILL(0x00000000); build/asm/main_8004082C.s.o(.text); build/asm/main_8004082C.s.o(.rodata); build/asm/main_8004082C.s.o(.data); }
    .main_8004082C_bss (NOLOAD) : { build/asm/main_8004082C.s.o(.bss); }
    .main_80042768 0x80042768 : AT(0x00043368) { FILL(0x00000000); build/asm/main_80042768.s.o(.text); build/asm/main_80042768.s.o(.rodata); build/asm/main_80042768.s.o(.data); }
    .main_80042768_bss (NOLOAD) : { build/asm/main_80042768.s.o(.bss); }
    .main_80042C18 0x80042C18 : AT(0x00043818) { FILL(0x00000000); build/asm/main_80042C18.s.o(.text); build/asm/main_80042C18.s.o(.rodata); build/asm/main_80042C18.s.o(.data); }
    .main_80042C18_bss (NOLOAD) : { build/asm/main_80042C18.s.o(.bss); }
    .main_80042F18 0x80042F18 : AT(0x00043B18) { FILL(0x00000000); build/asm/main_80042F18.s.o(.text); build/asm/main_80042F18.s.o(.rodata); build/asm/main_80042F18.s.o(.data); }
    .main_80042F18_bss (NOLOAD) : { build/asm/main_80042F18.s.o(.bss); }
    .main_80043CAC 0x80043CAC : AT(0x000448AC) { FILL(0x00000000); build/asm/main_80043CAC.s.o(.text); build/asm/main_80043CAC.s.o(.rodata); build/asm/main_80043CAC.s.o(.data); }
    .main_80043CAC_bss (NOLOAD) : { build/asm/main_80043CAC.s.o(.bss); }
    .main_80044008 0x80044008 : AT(0x00044C08) { FILL(0x00000000); build/asm/main_80044008.s.o(.text); build/asm/main_80044008.s.o(.rodata); build/asm/main_80044008.s.o(.data); }
    .main_80044008_bss (NOLOAD) : { build/asm/main_80044008.s.o(.bss); }
    .main_800440C8 0x800440C8 : AT(0x00044CC8) { FILL(0x00000000); build/asm/main_800440C8.s.o(.text); build/asm/main_800440C8.s.o(.rodata); build/asm/main_800440C8.s.o(.data); }
    .main_800440C8_bss (NOLOAD) : { build/asm/main_800440C8.s.o(.bss); }
    .main_80045678 0x80045678 : AT(0x00046278) { FILL(0x00000000); build/asm/main_80045678.s.o(.text); build/asm/main_80045678.s.o(.rodata); build/asm/main_80045678.s.o(.data); }
    .main_80045678_bss (NOLOAD) : { build/asm/main_80045678.s.o(.bss); }
    .main_80046E28 0x80046E28 : AT(0x00047A28) { FILL(0x00000000); build/asm/main_80046E28.s.o(.text); build/asm/main_80046E28.s.o(.rodata); build/asm/main_80046E28.s.o(.data); }
    .main_80046E28_bss (NOLOAD) : { build/asm/main_80046E28.s.o(.bss); }
    .main_800494AC 0x800494AC : AT(0x0004A0AC) { FILL(0x00000000); build/asm/main_800494AC.s.o(.text); build/asm/main_800494AC.s.o(.rodata); build/asm/main_800494AC.s.o(.data); }
    .main_800494AC_bss (NOLOAD) : { build/asm/main_800494AC.s.o(.bss); }
    .main_8004B888 0x8004B888 : AT(0x0004C488) { FILL(0x00000000); build/asm/main_8004B888.s.o(.text); build/asm/main_8004B888.s.o(.rodata); build/asm/main_8004B888.s.o(.data); }
    .main_8004B888_bss (NOLOAD) : { build/asm/main_8004B888.s.o(.bss); }
    .main_8004D19C 0x8004D19C : AT(0x0004DD9C) { FILL(0x00000000); build/asm/main_8004D19C.s.o(.text); build/asm/main_8004D19C.s.o(.rodata); build/asm/main_8004D19C.s.o(.data); }
    .main_8004D19C_bss (NOLOAD) : { build/asm/main_8004D19C.s.o(.bss); }
    .main_8004D798 0x8004D798 : AT(0x0004E398) { FILL(0x00000000); build/asm/main_8004D798.s.o(.text); build/asm/main_8004D798.s.o(.rodata); build/asm/main_8004D798.s.o(.data); }
    .main_8004D798_bss (NOLOAD) : { build/asm/main_8004D798.s.o(.bss); }
    .main_8005330C 0x8005330C : AT(0x00053F0C) { build/asm/data/main_8005330C.bin.o(.data); }
    .main_80064844 0x80064844 : AT(0x00065444) { FILL(0x00000000); build/asm/main_80064844.s.o(.text); build/asm/main_80064844.s.o(.rodata); build/asm/main_80064844.s.o(.data); }
    .main_80064844_bss (NOLOAD) : { build/asm/main_80064844.s.o(.bss); }
    .main_8006CAC8 0x8006CAC8 : AT(0x0006D6C8) { build/asm/data/main_8006CAC8.bin.o(.data); }
    .main_800714E0 0x800714E0 : AT(0x000720E0) { FILL(0x00000000); build/asm/main_800714E0.s.o(.text); build/asm/main_800714E0.s.o(.rodata); build/asm/main_800714E0.s.o(.data); }
    .main_800714E0_bss (NOLOAD) : { build/asm/main_800714E0.s.o(.bss); }
    .main_80071CE0 0x80071CE0 : AT(0x000728E0) { build/asm/data/main_80071CE0.bin.o(.data); }
    .main_80071F30 0x80071F30 : AT(0x00072B30) { FILL(0x00000000); build/asm/main_80071F30.s.o(.text); build/asm/main_80071F30.s.o(.rodata); build/asm/main_80071F30.s.o(.data); }
    .main_80071F30_bss (NOLOAD) : { build/asm/main_80071F30.s.o(.bss); }
    .main_80072730 0x80072730 : AT(0x00073330) { build/asm/data/main_80072730.bin.o(.data); }
    .main_80075B7C 0x80075B7C : AT(0x0007677C) { FILL(0x00000000); build/asm/main_80075B7C.s.o(.text); build/asm/main_80075B7C.s.o(.rodata); build/asm/main_80075B7C.s.o(.data); }
    .main_80075B7C_bss (NOLOAD) : { build/asm/main_80075B7C.s.o(.bss); }
    .main_80075D7C 0x80075D7C : AT(0x0007697C) { FILL(0x00000000); build/asm/main_80075D7C.s.o(.text); build/asm/main_80075D7C.s.o(.rodata); build/asm/main_80075D7C.s.o(.data); }
    .main_80075D7C_bss (NOLOAD) : { build/asm/main_80075D7C.s.o(.bss); }
    .main_80075DB8 0x80075DB8 : AT(0x000769B8) { build/asm/data/main_80075DB8.bin.o(.data); }
    .main_80076178 0x80076178 : AT(0x00076D78) { FILL(0x00000000); build/asm/main_80076178.s.o(.text); build/asm/main_80076178.s.o(.rodata); build/asm/main_80076178.s.o(.data); }
    .main_80076178_bss (NOLOAD) : { build/asm/main_80076178.s.o(.bss); }
    .main_80092904 0x80092904 : AT(0x00093504) { build/asm/data/main_80092904.bin.o(.data); }
    .main_80099554 0x80099554 : AT(0x0009A154) { build/asm/data/main_80099554.bin.o(.data); }
    .main_8009AAC0 0x8009AAC0 : AT(0x0009B6C0) { FILL(0x00000000); build/asm/main_8009AAC0.s.o(.text); build/asm/main_8009AAC0.s.o(.rodata); build/asm/main_8009AAC0.s.o(.data); }
    .main_8009AAC0_bss (NOLOAD) : { build/asm/main_8009AAC0.s.o(.bss); }
    .main_8009AADC 0x8009AADC : AT(0x0009B6DC) { build/asm/data/main_8009AADC.bin.o(.data); }
    .main_8009B914 0x8009B914 : AT(0x0009C514) { FILL(0x00000000); build/asm/main_8009B914.s.o(.text); build/asm/main_8009B914.s.o(.rodata); build/asm/main_8009B914.s.o(.data); }
    .main_8009B914_bss (NOLOAD) : { build/asm/main_8009B914.s.o(.bss); }
    .main_8009B944 0x8009B944 : AT(0x0009C544) { build/asm/data/main_8009B944.bin.o(.data); }
    .main_8009D55C 0x8009D55C : AT(0x0009E15C) { build/asm/data/main_8009D55C.bin.o(.data); }
    .main_8009DD68 0x8009DD68 : AT(0x0009E968) { FILL(0x00000000); build/asm/main_8009DD68.s.o(.text); build/asm/main_8009DD68.s.o(.rodata); build/asm/main_8009DD68.s.o(.data); }
    .main_8009DD68_bss (NOLOAD) : { build/asm/main_8009DD68.s.o(.bss); }
    .main_8009DD74 0x8009DD74 : AT(0x0009E974) { build/asm/data/main_8009DD74.bin.o(.data); }
    .main_800A36D4 0x800A36D4 : AT(0x000A42D4) { build/asm/data/main_800A36D4.bin.o(.data); }
    .main_800A598C 0x800A598C : AT(0x000A658C) { FILL(0x00000000); build/asm/main_800A598C.s.o(.text); build/asm/main_800A598C.s.o(.rodata); build/asm/main_800A598C.s.o(.data); }
    .main_800A598C_bss (NOLOAD) : { build/asm/main_800A598C.s.o(.bss); }
    .main_800A59AC 0x800A59AC : AT(0x000A65AC) { build/asm/data/main_800A59AC.bin.o(.data); }
    .main_800A8548 0x800A8548 : AT(0x000A9148) { build/asm/data/main_800A8548.bin.o(.data); }
    .main_800B9660 0x800B9660 : AT(0x000BA260) { FILL(0x00000000); build/asm/main_800B9660.s.o(.text); build/asm/main_800B9660.s.o(.rodata); build/asm/main_800B9660.s.o(.data); }
    .main_800B9660_bss (NOLOAD) : { build/asm/main_800B9660.s.o(.bss); }
    .main_800B9668 0x800B9668 : AT(0x000BA268) { build/asm/data/main_800B9668.bin.o(.data); }
    .main_800BF0BC 0x800BF0BC : AT(0x000BFCBC) { FILL(0x00000000); build/asm/main_800BF0BC.s.o(.text); build/asm/main_800BF0BC.s.o(.rodata); build/asm/main_800BF0BC.s.o(.data); }
    .main_800BF0BC_bss (NOLOAD) : { build/asm/main_800BF0BC.s.o(.bss); }
    .main_800BF0DC 0x800BF0DC : AT(0x000BFCDC) { build/asm/data/main_800BF0DC.bin.o(.data); }
    .main_800C0944 0x800C0944 : AT(0x000C1544) { FILL(0x00000000); build/asm/main_800C0944.s.o(.text); build/asm/main_800C0944.s.o(.rodata); build/asm/main_800C0944.s.o(.data); }
    .main_800C0944_bss (NOLOAD) : { build/asm/main_800C0944.s.o(.bss); }
    .main_800C09C4 0x800C09C4 : AT(0x000C15C4) { build/asm/data/main_800C09C4.bin.o(.data); }
    .main_800C8B90 0x800C8B90 : AT(0x000C9790) { FILL(0x00000000); build/asm/main_800C8B90.s.o(.text); build/asm/main_800C8B90.s.o(.rodata); build/asm/main_800C8B90.s.o(.data); }
    .main_800C8B90_bss (NOLOAD) : { build/asm/main_800C8B90.s.o(.bss); }
    .main_800C8BA4 0x800C8BA4 : AT(0x000C97A4) { build/asm/data/main_800C8BA4.bin.o(.data); }
    .main_800CDACC 0x800CDACC : AT(0x000CE6CC) { build/asm/data/main_800CDACC.bin.o(.data); }
    .main_800CDFBC 0x800CDFBC : AT(0x000CEBBC) { build/asm/data/main_800CDFBC.bin.o(.data); }
    .main_800D0554 0x800D0554 : AT(0x000D1154) { FILL(0x00000000); build/asm/main_800D0554.s.o(.text); build/asm/main_800D0554.s.o(.rodata); build/asm/main_800D0554.s.o(.data); }
    .main_800D0554_bss (NOLOAD) : { build/asm/main_800D0554.s.o(.bss); }
    .main_800D09E4 0x800D09E4 : AT(0x000D15E4) { build/asm/data/main_800D09E4.bin.o(.data); }
    .main_800D12BC 0x800D12BC : AT(0x000D1EBC) { build/asm/data/main_800D12BC.bin.o(.data); }
    .main_800D1EE8 0x800D1EE8 : AT(0x000D2AE8) { build/asm/data/main_800D1EE8.bin.o(.data); }
    .main_800D3A5C 0x800D3A5C : AT(0x000D465C) { build/asm/data/main_800D3A5C.bin.o(.data); }
    .main_800D4494 0x800D4494 : AT(0x000D5094) { build/asm/data/main_800D4494.bin.o(.data); }
    .main_800D7740 0x800D7740 : AT(0x000D8340) { build/asm/data/main_800D7740.bin.o(.data); }
    .main_800D7B44 0x800D7B44 : AT(0x000D8744) { build/asm/data/main_800D7B44.bin.o(.data); }
    .main_800D896C 0x800D896C : AT(0x000D956C) { build/asm/data/main_800D896C.bin.o(.data); }
    .main_800DA4F0 0x800DA4F0 : AT(0x000DB0F0) { FILL(0x00000000); build/asm/main_800DA4F0.s.o(.text); build/asm/main_800DA4F0.s.o(.rodata); build/asm/main_800DA4F0.s.o(.data); }
    .main_800DA4F0_bss (NOLOAD) : { build/asm/main_800DA4F0.s.o(.bss); }
    .main_800DA564 0x800DA564 : AT(0x000DB164) { build/asm/data/main_800DA564.bin.o(.data); }
    .main_800DBE58 0x800DBE58 : AT(0x000DCA58) { FILL(0x00000000); build/asm/main_800DBE58.s.o(.text); build/asm/main_800DBE58.s.o(.rodata); build/asm/main_800DBE58.s.o(.data); }
    .main_800DBE58_bss (NOLOAD) : { build/asm/main_800DBE58.s.o(.bss); }
    .main_800DBE84 0x800DBE84 : AT(0x000DCA84) { build/asm/data/main_800DBE84.bin.o(.data); }
    .main_800DE20C 0x800DE20C : AT(0x000DEE0C) { build/asm/data/main_800DE20C.bin.o(.data); }
    .main_800DE84C 0x800DE84C : AT(0x000DF44C) { build/asm/data/main_800DE84C.bin.o(.data); }
    .main_800DF180 0x800DF180 : AT(0x000DFD80) { build/asm/data/main_800DF180.bin.o(.data); }
    .main_800DFD78 0x800DFD78 : AT(0x000E0978) { build/asm/data/main_800DFD78.bin.o(.data); }
    .main_800E03B4 0x800E03B4 : AT(0x000E0FB4) { build/asm/data/main_800E03B4.bin.o(.data); }
    .main_800E042C 0x800E042C : AT(0x000E102C) { FILL(0x00000000); build/asm/main_800E042C.s.o(.text); build/asm/main_800E042C.s.o(.rodata); build/asm/main_800E042C.s.o(.data); }
    .main_800E042C_bss (NOLOAD) : { build/asm/main_800E042C.s.o(.bss); }
    .main_800E044C 0x800E044C : AT(0x000E104C) { build/asm/data/main_800E044C.bin.o(.data); }
    .main_800E1038 0x800E1038 : AT(0x000E1C38) { FILL(0x00000000); build/asm/main_800E1038.s.o(.text); build/asm/main_800E1038.s.o(.rodata); build/asm/main_800E1038.s.o(.data); }
    .main_800E1038_bss (NOLOAD) : { build/asm/main_800E1038.s.o(.bss); }
    .main_800E1AD4 0x800E1AD4 : AT(0x000E26D4) { build/asm/data/main_800E1AD4.bin.o(.data); }
    .main_800E46C0 0x800E46C0 : AT(0x000E52C0) { build/asm/data/main_800E46C0.bin.o(.data); }
    .main_800E5C3C 0x800E5C3C : AT(0x000E683C) { build/asm/data/main_800E5C3C.bin.o(.data); }
    .main_800E6000 0x800E6000 : AT(0x000E6C00) { build/asm/data/main_800E6000.bin.o(.data); }
    .main_800E6F78 0x800E6F78 : AT(0x000E7B78) { build/asm/data/main_800E6F78.bin.o(.data); }
    .main_800E97B8 0x800E97B8 : AT(0x000EA3B8) { build/asm/data/main_800E97B8.bin.o(.data); }
    .main_800ED3B0 0x800ED3B0 : AT(0x000EDFB0) { FILL(0x00000000); build/asm/main_800ED3B0.s.o(.text); build/asm/main_800ED3B0.s.o(.rodata); build/asm/main_800ED3B0.s.o(.data); }
    .main_800ED3B0_bss (NOLOAD) : { build/asm/main_800ED3B0.s.o(.bss); }
    .main_800ED3E8 0x800ED3E8 : AT(0x000EDFE8) { build/asm/data/main_800ED3E8.bin.o(.data); }
    .main_800F89FC 0x800F89FC : AT(0x000F95FC) { FILL(0x00000000); build/asm/main_800F89FC.s.o(.text); build/asm/main_800F89FC.s.o(.rodata); build/asm/main_800F89FC.s.o(.data); }
    .main_800F89FC_bss (NOLOAD) : { build/asm/main_800F89FC.s.o(.bss); }
    .main_800F8A04 0x800F8A04 : AT(0x000F9604) { build/asm/data/main_800F8A04.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
