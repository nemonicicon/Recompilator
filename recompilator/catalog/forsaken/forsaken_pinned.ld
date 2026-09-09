SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80001420 0x80001420 : AT(0x00002020) { FILL(0x00000000); build/asm/main_80001420.s.o(.text); build/asm/main_80001420.s.o(.rodata); build/asm/main_80001420.s.o(.data); }
    .main_80001420_bss (NOLOAD) : { build/asm/main_80001420.s.o(.bss); }
    .main_80001BC0 0x80001BC0 : AT(0x000027C0) { FILL(0x00000000); build/asm/main_80001BC0.s.o(.text); build/asm/main_80001BC0.s.o(.rodata); build/asm/main_80001BC0.s.o(.data); }
    .main_80001BC0_bss (NOLOAD) : { build/asm/main_80001BC0.s.o(.bss); }
    .main_80002064 0x80002064 : AT(0x00002C64) { FILL(0x00000000); build/asm/main_80002064.s.o(.text); build/asm/main_80002064.s.o(.rodata); build/asm/main_80002064.s.o(.data); }
    .main_80002064_bss (NOLOAD) : { build/asm/main_80002064.s.o(.bss); }
    .main_80002C8C 0x80002C8C : AT(0x0000388C) { FILL(0x00000000); build/asm/main_80002C8C.s.o(.text); build/asm/main_80002C8C.s.o(.rodata); build/asm/main_80002C8C.s.o(.data); }
    .main_80002C8C_bss (NOLOAD) : { build/asm/main_80002C8C.s.o(.bss); }
    .main_80002F34 0x80002F34 : AT(0x00003B34) { FILL(0x00000000); build/asm/main_80002F34.s.o(.text); build/asm/main_80002F34.s.o(.rodata); build/asm/main_80002F34.s.o(.data); }
    .main_80002F34_bss (NOLOAD) : { build/asm/main_80002F34.s.o(.bss); }
    .main_800031FC 0x800031FC : AT(0x00003DFC) { build/asm/data/main_800031FC.bin.o(.data); }
    .main_80003828 0x80003828 : AT(0x00004428) { FILL(0x00000000); build/asm/main_80003828.s.o(.text); build/asm/main_80003828.s.o(.rodata); build/asm/main_80003828.s.o(.data); }
    .main_80003828_bss (NOLOAD) : { build/asm/main_80003828.s.o(.bss); }
    .main_80003840 0x80003840 : AT(0x00004440) { build/asm/data/main_80003840.bin.o(.data); }
    .main_80006250 0x80006250 : AT(0x00006E50) { FILL(0x00000000); build/asm/main_80006250.s.o(.text); build/asm/main_80006250.s.o(.rodata); build/asm/main_80006250.s.o(.data); }
    .main_80006250_bss (NOLOAD) : { build/asm/main_80006250.s.o(.bss); }
    .main_800062DC 0x800062DC : AT(0x00006EDC) { FILL(0x00000000); build/asm/main_800062DC.s.o(.text); build/asm/main_800062DC.s.o(.rodata); build/asm/main_800062DC.s.o(.data); }
    .main_800062DC_bss (NOLOAD) : { build/asm/main_800062DC.s.o(.bss); }
    .main_800069F4 0x800069F4 : AT(0x000075F4) { FILL(0x00000000); build/asm/main_800069F4.s.o(.text); build/asm/main_800069F4.s.o(.rodata); build/asm/main_800069F4.s.o(.data); }
    .main_800069F4_bss (NOLOAD) : { build/asm/main_800069F4.s.o(.bss); }
    .main_800081BC 0x800081BC : AT(0x00008DBC) { FILL(0x00000000); build/asm/main_800081BC.s.o(.text); build/asm/main_800081BC.s.o(.rodata); build/asm/main_800081BC.s.o(.data); }
    .main_800081BC_bss (NOLOAD) : { build/asm/main_800081BC.s.o(.bss); }
    .main_80008C4C 0x80008C4C : AT(0x0000984C) { FILL(0x00000000); build/asm/main_80008C4C.s.o(.text); build/asm/main_80008C4C.s.o(.rodata); build/asm/main_80008C4C.s.o(.data); }
    .main_80008C4C_bss (NOLOAD) : { build/asm/main_80008C4C.s.o(.bss); }
    .main_80009A20 0x80009A20 : AT(0x0000A620) { FILL(0x00000000); build/asm/main_80009A20.s.o(.text); build/asm/main_80009A20.s.o(.rodata); build/asm/main_80009A20.s.o(.data); }
    .main_80009A20_bss (NOLOAD) : { build/asm/main_80009A20.s.o(.bss); }
    .main_8000AD90 0x8000AD90 : AT(0x0000B990) { FILL(0x00000000); build/asm/main_8000AD90.s.o(.text); build/asm/main_8000AD90.s.o(.rodata); build/asm/main_8000AD90.s.o(.data); }
    .main_8000AD90_bss (NOLOAD) : { build/asm/main_8000AD90.s.o(.bss); }
    .main_8000BBE8 0x8000BBE8 : AT(0x0000C7E8) { FILL(0x00000000); build/asm/main_8000BBE8.s.o(.text); build/asm/main_8000BBE8.s.o(.rodata); build/asm/main_8000BBE8.s.o(.data); }
    .main_8000BBE8_bss (NOLOAD) : { build/asm/main_8000BBE8.s.o(.bss); }
    .main_8000E154 0x8000E154 : AT(0x0000ED54) { FILL(0x00000000); build/asm/main_8000E154.s.o(.text); build/asm/main_8000E154.s.o(.rodata); build/asm/main_8000E154.s.o(.data); }
    .main_8000E154_bss (NOLOAD) : { build/asm/main_8000E154.s.o(.bss); }
    .main_8000E530 0x8000E530 : AT(0x0000F130) { FILL(0x00000000); build/asm/main_8000E530.s.o(.text); build/asm/main_8000E530.s.o(.rodata); build/asm/main_8000E530.s.o(.data); }
    .main_8000E530_bss (NOLOAD) : { build/asm/main_8000E530.s.o(.bss); }
    .main_80010ED4 0x80010ED4 : AT(0x00011AD4) { FILL(0x00000000); build/asm/main_80010ED4.s.o(.text); build/asm/main_80010ED4.s.o(.rodata); build/asm/main_80010ED4.s.o(.data); }
    .main_80010ED4_bss (NOLOAD) : { build/asm/main_80010ED4.s.o(.bss); }
    .main_80012224 0x80012224 : AT(0x00012E24) { FILL(0x00000000); build/asm/main_80012224.s.o(.text); build/asm/main_80012224.s.o(.rodata); build/asm/main_80012224.s.o(.data); }
    .main_80012224_bss (NOLOAD) : { build/asm/main_80012224.s.o(.bss); }
    .main_80013D3C 0x80013D3C : AT(0x0001493C) { FILL(0x00000000); build/asm/main_80013D3C.s.o(.text); build/asm/main_80013D3C.s.o(.rodata); build/asm/main_80013D3C.s.o(.data); }
    .main_80013D3C_bss (NOLOAD) : { build/asm/main_80013D3C.s.o(.bss); }
    .main_80015CB0 0x80015CB0 : AT(0x000168B0) { FILL(0x00000000); build/asm/main_80015CB0.s.o(.text); build/asm/main_80015CB0.s.o(.rodata); build/asm/main_80015CB0.s.o(.data); }
    .main_80015CB0_bss (NOLOAD) : { build/asm/main_80015CB0.s.o(.bss); }
    .main_800160BC 0x800160BC : AT(0x00016CBC) { FILL(0x00000000); build/asm/main_800160BC.s.o(.text); build/asm/main_800160BC.s.o(.rodata); build/asm/main_800160BC.s.o(.data); }
    .main_800160BC_bss (NOLOAD) : { build/asm/main_800160BC.s.o(.bss); }
    .main_8001663C 0x8001663C : AT(0x0001723C) { FILL(0x00000000); build/asm/main_8001663C.s.o(.text); build/asm/main_8001663C.s.o(.rodata); build/asm/main_8001663C.s.o(.data); }
    .main_8001663C_bss (NOLOAD) : { build/asm/main_8001663C.s.o(.bss); }
    .main_80016F80 0x80016F80 : AT(0x00017B80) { FILL(0x00000000); build/asm/main_80016F80.s.o(.text); build/asm/main_80016F80.s.o(.rodata); build/asm/main_80016F80.s.o(.data); }
    .main_80016F80_bss (NOLOAD) : { build/asm/main_80016F80.s.o(.bss); }
    .main_8001719C 0x8001719C : AT(0x00017D9C) { FILL(0x00000000); build/asm/main_8001719C.s.o(.text); build/asm/main_8001719C.s.o(.rodata); build/asm/main_8001719C.s.o(.data); }
    .main_8001719C_bss (NOLOAD) : { build/asm/main_8001719C.s.o(.bss); }
    .main_80017610 0x80017610 : AT(0x00018210) { FILL(0x00000000); build/asm/main_80017610.s.o(.text); build/asm/main_80017610.s.o(.rodata); build/asm/main_80017610.s.o(.data); }
    .main_80017610_bss (NOLOAD) : { build/asm/main_80017610.s.o(.bss); }
    .main_80017814 0x80017814 : AT(0x00018414) { FILL(0x00000000); build/asm/main_80017814.s.o(.text); build/asm/main_80017814.s.o(.rodata); build/asm/main_80017814.s.o(.data); }
    .main_80017814_bss (NOLOAD) : { build/asm/main_80017814.s.o(.bss); }
    .main_80017F40 0x80017F40 : AT(0x00018B40) { FILL(0x00000000); build/asm/main_80017F40.s.o(.text); build/asm/main_80017F40.s.o(.rodata); build/asm/main_80017F40.s.o(.data); }
    .main_80017F40_bss (NOLOAD) : { build/asm/main_80017F40.s.o(.bss); }
    .main_80019260 0x80019260 : AT(0x00019E60) { FILL(0x00000000); build/asm/main_80019260.s.o(.text); build/asm/main_80019260.s.o(.rodata); build/asm/main_80019260.s.o(.data); }
    .main_80019260_bss (NOLOAD) : { build/asm/main_80019260.s.o(.bss); }
    .main_8001E300 0x8001E300 : AT(0x0001EF00) { FILL(0x00000000); build/asm/main_8001E300.s.o(.text); build/asm/main_8001E300.s.o(.rodata); build/asm/main_8001E300.s.o(.data); }
    .main_8001E300_bss (NOLOAD) : { build/asm/main_8001E300.s.o(.bss); }
    .main_8001F100 0x8001F100 : AT(0x0001FD00) { FILL(0x00000000); build/asm/main_8001F100.s.o(.text); build/asm/main_8001F100.s.o(.rodata); build/asm/main_8001F100.s.o(.data); }
    .main_8001F100_bss (NOLOAD) : { build/asm/main_8001F100.s.o(.bss); }
    .main_8001FCF0 0x8001FCF0 : AT(0x000208F0) { FILL(0x00000000); build/asm/main_8001FCF0.s.o(.text); build/asm/main_8001FCF0.s.o(.rodata); build/asm/main_8001FCF0.s.o(.data); }
    .main_8001FCF0_bss (NOLOAD) : { build/asm/main_8001FCF0.s.o(.bss); }
    .main_80021880 0x80021880 : AT(0x00022480) { build/asm/data/main_80021880.bin.o(.data); }
    .main_80021920 0x80021920 : AT(0x00022520) { FILL(0x00000000); build/asm/main_80021920.s.o(.text); build/asm/main_80021920.s.o(.rodata); build/asm/main_80021920.s.o(.data); }
    .main_80021920_bss (NOLOAD) : { build/asm/main_80021920.s.o(.bss); }
    .main_80022098 0x80022098 : AT(0x00022C98) { FILL(0x00000000); build/asm/main_80022098.s.o(.text); build/asm/main_80022098.s.o(.rodata); build/asm/main_80022098.s.o(.data); }
    .main_80022098_bss (NOLOAD) : { build/asm/main_80022098.s.o(.bss); }
    .main_80022930 0x80022930 : AT(0x00023530) { build/asm/data/main_80022930.bin.o(.data); }
    .main_80023130 0x80023130 : AT(0x00023D30) { build/asm/data/main_80023130.bin.o(.data); }
    .main_80023580 0x80023580 : AT(0x00024180) { FILL(0x00000000); build/asm/main_80023580.s.o(.text); build/asm/main_80023580.s.o(.rodata); build/asm/main_80023580.s.o(.data); }
    .main_80023580_bss (NOLOAD) : { build/asm/main_80023580.s.o(.bss); }
    .main_80023D00 0x80023D00 : AT(0x00024900) { build/asm/data/main_80023D00.bin.o(.data); }
    .main_80028B40 0x80028B40 : AT(0x00029740) { FILL(0x00000000); build/asm/main_80028B40.s.o(.text); build/asm/main_80028B40.s.o(.rodata); build/asm/main_80028B40.s.o(.data); }
    .main_80028B40_bss (NOLOAD) : { build/asm/main_80028B40.s.o(.bss); }
    .main_80029740 0x80029740 : AT(0x0002A340) { FILL(0x00000000); build/asm/main_80029740.s.o(.text); build/asm/main_80029740.s.o(.rodata); build/asm/main_80029740.s.o(.data); }
    .main_80029740_bss (NOLOAD) : { build/asm/main_80029740.s.o(.bss); }
    .main_80029FF4 0x80029FF4 : AT(0x0002ABF4) { build/asm/data/main_80029FF4.bin.o(.data); }
    .main_8003ADF0 0x8003ADF0 : AT(0x0003B9F0) { build/asm/data/main_8003ADF0.bin.o(.data); }
    .main_8003C4A8 0x8003C4A8 : AT(0x0003D0A8) { build/asm/data/main_8003C4A8.bin.o(.data); }
    .main_80040404 0x80040404 : AT(0x00041004) { build/asm/data/main_80040404.bin.o(.data); }
    .main_80042390 0x80042390 : AT(0x00042F90) { build/asm/data/main_80042390.bin.o(.data); }
    .main_80046530 0x80046530 : AT(0x00047130) { FILL(0x00000000); build/asm/main_80046530.s.o(.text); build/asm/main_80046530.s.o(.rodata); build/asm/main_80046530.s.o(.data); }
    .main_80046530_bss (NOLOAD) : { build/asm/main_80046530.s.o(.bss); }
    .main_80046F84 0x80046F84 : AT(0x00047B84) { build/asm/data/main_80046F84.bin.o(.data); }
    .main_80048784 0x80048784 : AT(0x00049384) { build/asm/data/main_80048784.bin.o(.data); }
    .main_8005069C 0x8005069C : AT(0x0005129C) { FILL(0x00000000); build/asm/main_8005069C.s.o(.text); build/asm/main_8005069C.s.o(.rodata); build/asm/main_8005069C.s.o(.data); }
    .main_8005069C_bss (NOLOAD) : { build/asm/main_8005069C.s.o(.bss); }
    .main_80050FBC 0x80050FBC : AT(0x00051BBC) { build/asm/data/main_80050FBC.bin.o(.data); }
    .main_80059EAC 0x80059EAC : AT(0x0005AAAC) { FILL(0x00000000); build/asm/main_80059EAC.s.o(.text); build/asm/main_80059EAC.s.o(.rodata); build/asm/main_80059EAC.s.o(.data); }
    .main_80059EAC_bss (NOLOAD) : { build/asm/main_80059EAC.s.o(.bss); }
    .main_80059EBC 0x80059EBC : AT(0x0005AABC) { build/asm/data/main_80059EBC.bin.o(.data); }
    .main_8005D304 0x8005D304 : AT(0x0005DF04) { FILL(0x00000000); build/asm/main_8005D304.s.o(.text); build/asm/main_8005D304.s.o(.rodata); build/asm/main_8005D304.s.o(.data); }
    .main_8005D304_bss (NOLOAD) : { build/asm/main_8005D304.s.o(.bss); }
    .main_8005D314 0x8005D314 : AT(0x0005DF14) { build/asm/data/main_8005D314.bin.o(.data); }
    .main_80061E68 0x80061E68 : AT(0x00062A68) { FILL(0x00000000); build/asm/main_80061E68.s.o(.text); build/asm/main_80061E68.s.o(.rodata); build/asm/main_80061E68.s.o(.data); }
    .main_80061E68_bss (NOLOAD) : { build/asm/main_80061E68.s.o(.bss); }
    .main_80061EF0 0x80061EF0 : AT(0x00062AF0) { build/asm/data/main_80061EF0.bin.o(.data); }
    .main_8006D568 0x8006D568 : AT(0x0006E168) { FILL(0x00000000); build/asm/main_8006D568.s.o(.text); build/asm/main_8006D568.s.o(.rodata); build/asm/main_8006D568.s.o(.data); }
    .main_8006D568_bss (NOLOAD) : { build/asm/main_8006D568.s.o(.bss); }
    .main_8006D5AC 0x8006D5AC : AT(0x0006E1AC) { build/asm/data/main_8006D5AC.bin.o(.data); }
    .main_80070A18 0x80070A18 : AT(0x00071618) { FILL(0x00000000); build/asm/main_80070A18.s.o(.text); build/asm/main_80070A18.s.o(.rodata); build/asm/main_80070A18.s.o(.data); }
    .main_80070A18_bss (NOLOAD) : { build/asm/main_80070A18.s.o(.bss); }
    .main_80070A28 0x80070A28 : AT(0x00071628) { build/asm/data/main_80070A28.bin.o(.data); }
    .main_8007C2C0 0x8007C2C0 : AT(0x0007CEC0) { build/asm/data/main_8007C2C0.bin.o(.data); }
    .main_8007CD74 0x8007CD74 : AT(0x0007D974) { FILL(0x00000000); build/asm/main_8007CD74.s.o(.text); build/asm/main_8007CD74.s.o(.rodata); build/asm/main_8007CD74.s.o(.data); }
    .main_8007CD74_bss (NOLOAD) : { build/asm/main_8007CD74.s.o(.bss); }
    .main_8007CDA0 0x8007CDA0 : AT(0x0007D9A0) { build/asm/data/main_8007CDA0.bin.o(.data); }
    .main_8007FAA4 0x8007FAA4 : AT(0x000806A4) { build/asm/data/main_8007FAA4.bin.o(.data); }
    .main_8007FF58 0x8007FF58 : AT(0x00080B58) { build/asm/data/main_8007FF58.bin.o(.data); }
    .main_800810F8 0x800810F8 : AT(0x00081CF8) { FILL(0x00000000); build/asm/main_800810F8.s.o(.text); build/asm/main_800810F8.s.o(.rodata); build/asm/main_800810F8.s.o(.data); }
    .main_800810F8_bss (NOLOAD) : { build/asm/main_800810F8.s.o(.bss); }
    .main_80081104 0x80081104 : AT(0x00081D04) { build/asm/data/main_80081104.bin.o(.data); }
    .main_800822E0 0x800822E0 : AT(0x00082EE0) { FILL(0x00000000); build/asm/main_800822E0.s.o(.text); build/asm/main_800822E0.s.o(.rodata); build/asm/main_800822E0.s.o(.data); }
    .main_800822E0_bss (NOLOAD) : { build/asm/main_800822E0.s.o(.bss); }
    .main_80082308 0x80082308 : AT(0x00082F08) { build/asm/data/main_80082308.bin.o(.data); }
    .main_800823D8 0x800823D8 : AT(0x00082FD8) { FILL(0x00000000); build/asm/main_800823D8.s.o(.text); build/asm/main_800823D8.s.o(.rodata); build/asm/main_800823D8.s.o(.data); }
    .main_800823D8_bss (NOLOAD) : { build/asm/main_800823D8.s.o(.bss); }
    .main_80082400 0x80082400 : AT(0x00083000) { build/asm/data/main_80082400.bin.o(.data); }
    .main_80086828 0x80086828 : AT(0x00087428) { build/asm/data/main_80086828.bin.o(.data); }
    .main_80088D2C 0x80088D2C : AT(0x0008992C) { FILL(0x00000000); build/asm/main_80088D2C.s.o(.text); build/asm/main_80088D2C.s.o(.rodata); build/asm/main_80088D2C.s.o(.data); }
    .main_80088D2C_bss (NOLOAD) : { build/asm/main_80088D2C.s.o(.bss); }
    .main_80088D58 0x80088D58 : AT(0x00089958) { build/asm/data/main_80088D58.bin.o(.data); }
    .main_8008ADFC 0x8008ADFC : AT(0x0008B9FC) { build/asm/data/main_8008ADFC.bin.o(.data); }
    .main_8008C390 0x8008C390 : AT(0x0008CF90) { build/asm/data/main_8008C390.bin.o(.data); }
    .main_8008C5FC 0x8008C5FC : AT(0x0008D1FC) { build/asm/data/main_8008C5FC.bin.o(.data); }
    .main_8008E860 0x8008E860 : AT(0x0008F460) { build/asm/data/main_8008E860.bin.o(.data); }
    .main_8008EBB8 0x8008EBB8 : AT(0x0008F7B8) { build/asm/data/main_8008EBB8.bin.o(.data); }
    .main_8008EE64 0x8008EE64 : AT(0x0008FA64) { FILL(0x00000000); build/asm/main_8008EE64.s.o(.text); build/asm/main_8008EE64.s.o(.rodata); build/asm/main_8008EE64.s.o(.data); }
    .main_8008EE64_bss (NOLOAD) : { build/asm/main_8008EE64.s.o(.bss); }
    .main_8008F15C 0x8008F15C : AT(0x0008FD5C) { build/asm/data/main_8008F15C.bin.o(.data); }
    .main_80090428 0x80090428 : AT(0x00091028) { FILL(0x00000000); build/asm/main_80090428.s.o(.text); build/asm/main_80090428.s.o(.rodata); build/asm/main_80090428.s.o(.data); }
    .main_80090428_bss (NOLOAD) : { build/asm/main_80090428.s.o(.bss); }
    .main_80090460 0x80090460 : AT(0x00091060) { build/asm/data/main_80090460.bin.o(.data); }
    .main_8009966C 0x8009966C : AT(0x0009A26C) { FILL(0x00000000); build/asm/main_8009966C.s.o(.text); build/asm/main_8009966C.s.o(.rodata); build/asm/main_8009966C.s.o(.data); }
    .main_8009966C_bss (NOLOAD) : { build/asm/main_8009966C.s.o(.bss); }
    .main_80099670 0x80099670 : AT(0x0009A270) { build/asm/data/main_80099670.bin.o(.data); }
    .main_8009C9F8 0x8009C9F8 : AT(0x0009D5F8) { FILL(0x00000000); build/asm/main_8009C9F8.s.o(.text); build/asm/main_8009C9F8.s.o(.rodata); build/asm/main_8009C9F8.s.o(.data); }
    .main_8009C9F8_bss (NOLOAD) : { build/asm/main_8009C9F8.s.o(.bss); }
    .main_8009CA1C 0x8009CA1C : AT(0x0009D61C) { build/asm/data/main_8009CA1C.bin.o(.data); }
    .main_800A083C 0x800A083C : AT(0x000A143C) { FILL(0x00000000); build/asm/main_800A083C.s.o(.text); build/asm/main_800A083C.s.o(.rodata); build/asm/main_800A083C.s.o(.data); }
    .main_800A083C_bss (NOLOAD) : { build/asm/main_800A083C.s.o(.bss); }
    .main_800A0848 0x800A0848 : AT(0x000A1448) { build/asm/data/main_800A0848.bin.o(.data); }
    .main_800A9FC8 0x800A9FC8 : AT(0x000AABC8) { FILL(0x00000000); build/asm/main_800A9FC8.s.o(.text); build/asm/main_800A9FC8.s.o(.rodata); build/asm/main_800A9FC8.s.o(.data); }
    .main_800A9FC8_bss (NOLOAD) : { build/asm/main_800A9FC8.s.o(.bss); }
    .main_800A9FDC 0x800A9FDC : AT(0x000AABDC) { build/asm/data/main_800A9FDC.bin.o(.data); }
    .main_800B0420 0x800B0420 : AT(0x000B1020) { FILL(0x00000000); build/asm/main_800B0420.s.o(.text); build/asm/main_800B0420.s.o(.rodata); build/asm/main_800B0420.s.o(.data); }
    .main_800B0420_bss (NOLOAD) : { build/asm/main_800B0420.s.o(.bss); }
    .main_800B044C 0x800B044C : AT(0x000B104C) { build/asm/data/main_800B044C.bin.o(.data); }
    .main_800B47D8 0x800B47D8 : AT(0x000B53D8) { build/asm/data/main_800B47D8.bin.o(.data); }
    .main_800B4C34 0x800B4C34 : AT(0x000B5834) { build/asm/data/main_800B4C34.bin.o(.data); }
    .main_800B60E8 0x800B60E8 : AT(0x000B6CE8) { build/asm/data/main_800B60E8.bin.o(.data); }
    .main_800B7890 0x800B7890 : AT(0x000B8490) { build/asm/data/main_800B7890.bin.o(.data); }
    .main_800B861C 0x800B861C : AT(0x000B921C) { build/asm/data/main_800B861C.bin.o(.data); }
    .main_800BA19C 0x800BA19C : AT(0x000BAD9C) { FILL(0x00000000); build/asm/main_800BA19C.s.o(.text); build/asm/main_800BA19C.s.o(.rodata); build/asm/main_800BA19C.s.o(.data); }
    .main_800BA19C_bss (NOLOAD) : { build/asm/main_800BA19C.s.o(.bss); }
    .main_800BA1B0 0x800BA1B0 : AT(0x000BADB0) { build/asm/data/main_800BA1B0.bin.o(.data); }
    .main_800BF404 0x800BF404 : AT(0x000C0004) { FILL(0x00000000); build/asm/main_800BF404.s.o(.text); build/asm/main_800BF404.s.o(.rodata); build/asm/main_800BF404.s.o(.data); }
    .main_800BF404_bss (NOLOAD) : { build/asm/main_800BF404.s.o(.bss); }
    .main_800BF464 0x800BF464 : AT(0x000C0064) { build/asm/data/main_800BF464.bin.o(.data); }
    .main_800C8E84 0x800C8E84 : AT(0x000C9A84) { build/asm/data/main_800C8E84.bin.o(.data); }
    .main_800C8EA4 0x800C8EA4 : AT(0x000C9AA4) { build/asm/data/main_800C8EA4.bin.o(.data); }
    .main_800D39E8 0x800D39E8 : AT(0x000D45E8) { FILL(0x00000000); build/asm/main_800D39E8.s.o(.text); build/asm/main_800D39E8.s.o(.rodata); build/asm/main_800D39E8.s.o(.data); }
    .main_800D39E8_bss (NOLOAD) : { build/asm/main_800D39E8.s.o(.bss); }
    .main_800D39F8 0x800D39F8 : AT(0x000D45F8) { build/asm/data/main_800D39F8.bin.o(.data); }
    .main_800D6040 0x800D6040 : AT(0x000D6C40) { FILL(0x00000000); build/asm/main_800D6040.s.o(.text); build/asm/main_800D6040.s.o(.rodata); build/asm/main_800D6040.s.o(.data); }
    .main_800D6040_bss (NOLOAD) : { build/asm/main_800D6040.s.o(.bss); }
    .main_800D6054 0x800D6054 : AT(0x000D6C54) { build/asm/data/main_800D6054.bin.o(.data); }
    .main_800EC064 0x800EC064 : AT(0x000ECC64) { FILL(0x00000000); build/asm/main_800EC064.s.o(.text); build/asm/main_800EC064.s.o(.rodata); build/asm/main_800EC064.s.o(.data); }
    .main_800EC064_bss (NOLOAD) : { build/asm/main_800EC064.s.o(.bss); }
    .main_800EC074 0x800EC074 : AT(0x000ECC74) { build/asm/data/main_800EC074.bin.o(.data); }
    .main_800F0074 0x800F0074 : AT(0x000F0C74) { FILL(0x00000000); build/asm/main_800F0074.s.o(.text); build/asm/main_800F0074.s.o(.rodata); build/asm/main_800F0074.s.o(.data); }
    .main_800F0074_bss (NOLOAD) : { build/asm/main_800F0074.s.o(.bss); }
    .main_800F00F0 0x800F00F0 : AT(0x000F0CF0) { build/asm/data/main_800F00F0.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
