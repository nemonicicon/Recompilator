SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004CC 0x800004CC : AT(0x000010CC) { FILL(0x00000000); build/asm/main_800004CC.s.o(.text); build/asm/main_800004CC.s.o(.rodata); build/asm/main_800004CC.s.o(.data); }
    .main_800004CC_bss (NOLOAD) : { build/asm/main_800004CC.s.o(.bss); }
    .main_80000860 0x80000860 : AT(0x00001460) { FILL(0x00000000); build/asm/main_80000860.s.o(.text); build/asm/main_80000860.s.o(.rodata); build/asm/main_80000860.s.o(.data); }
    .main_80000860_bss (NOLOAD) : { build/asm/main_80000860.s.o(.bss); }
    .main_80000D4C 0x80000D4C : AT(0x0000194C) { FILL(0x00000000); build/asm/main_80000D4C.s.o(.text); build/asm/main_80000D4C.s.o(.rodata); build/asm/main_80000D4C.s.o(.data); }
    .main_80000D4C_bss (NOLOAD) : { build/asm/main_80000D4C.s.o(.bss); }
    .main_80002834 0x80002834 : AT(0x00003434) { FILL(0x00000000); build/asm/main_80002834.s.o(.text); build/asm/main_80002834.s.o(.rodata); build/asm/main_80002834.s.o(.data); }
    .main_80002834_bss (NOLOAD) : { build/asm/main_80002834.s.o(.bss); }
    .main_80004DCC 0x80004DCC : AT(0x000059CC) { FILL(0x00000000); build/asm/main_80004DCC.s.o(.text); build/asm/main_80004DCC.s.o(.rodata); build/asm/main_80004DCC.s.o(.data); }
    .main_80004DCC_bss (NOLOAD) : { build/asm/main_80004DCC.s.o(.bss); }
    .main_80005930 0x80005930 : AT(0x00006530) { FILL(0x00000000); build/asm/main_80005930.s.o(.text); build/asm/main_80005930.s.o(.rodata); build/asm/main_80005930.s.o(.data); }
    .main_80005930_bss (NOLOAD) : { build/asm/main_80005930.s.o(.bss); }
    .main_8000B5D0 0x8000B5D0 : AT(0x0000C1D0) { FILL(0x00000000); build/asm/main_8000B5D0.s.o(.text); build/asm/main_8000B5D0.s.o(.rodata); build/asm/main_8000B5D0.s.o(.data); }
    .main_8000B5D0_bss (NOLOAD) : { build/asm/main_8000B5D0.s.o(.bss); }
    .main_8000F380 0x8000F380 : AT(0x0000FF80) { FILL(0x00000000); build/asm/main_8000F380.s.o(.text); build/asm/main_8000F380.s.o(.rodata); build/asm/main_8000F380.s.o(.data); }
    .main_8000F380_bss (NOLOAD) : { build/asm/main_8000F380.s.o(.bss); }
    .main_8000F8D8 0x8000F8D8 : AT(0x000104D8) { FILL(0x00000000); build/asm/main_8000F8D8.s.o(.text); build/asm/main_8000F8D8.s.o(.rodata); build/asm/main_8000F8D8.s.o(.data); }
    .main_8000F8D8_bss (NOLOAD) : { build/asm/main_8000F8D8.s.o(.bss); }
    .main_8000FA70 0x8000FA70 : AT(0x00010670) { FILL(0x00000000); build/asm/main_8000FA70.s.o(.text); build/asm/main_8000FA70.s.o(.rodata); build/asm/main_8000FA70.s.o(.data); }
    .main_8000FA70_bss (NOLOAD) : { build/asm/main_8000FA70.s.o(.bss); }
    .main_8001054C 0x8001054C : AT(0x0001114C) { FILL(0x00000000); build/asm/main_8001054C.s.o(.text); build/asm/main_8001054C.s.o(.rodata); build/asm/main_8001054C.s.o(.data); }
    .main_8001054C_bss (NOLOAD) : { build/asm/main_8001054C.s.o(.bss); }
    .main_80010830 0x80010830 : AT(0x00011430) { FILL(0x00000000); build/asm/main_80010830.s.o(.text); build/asm/main_80010830.s.o(.rodata); build/asm/main_80010830.s.o(.data); }
    .main_80010830_bss (NOLOAD) : { build/asm/main_80010830.s.o(.bss); }
    .main_80010AF8 0x80010AF8 : AT(0x000116F8) { FILL(0x00000000); build/asm/main_80010AF8.s.o(.text); build/asm/main_80010AF8.s.o(.rodata); build/asm/main_80010AF8.s.o(.data); }
    .main_80010AF8_bss (NOLOAD) : { build/asm/main_80010AF8.s.o(.bss); }
    .main_80011230 0x80011230 : AT(0x00011E30) { FILL(0x00000000); build/asm/main_80011230.s.o(.text); build/asm/main_80011230.s.o(.rodata); build/asm/main_80011230.s.o(.data); }
    .main_80011230_bss (NOLOAD) : { build/asm/main_80011230.s.o(.bss); }
    .main_800116E4 0x800116E4 : AT(0x000122E4) { FILL(0x00000000); build/asm/main_800116E4.s.o(.text); build/asm/main_800116E4.s.o(.rodata); build/asm/main_800116E4.s.o(.data); }
    .main_800116E4_bss (NOLOAD) : { build/asm/main_800116E4.s.o(.bss); }
    .main_80011840 0x80011840 : AT(0x00012440) { FILL(0x00000000); build/asm/main_80011840.s.o(.text); build/asm/main_80011840.s.o(.rodata); build/asm/main_80011840.s.o(.data); }
    .main_80011840_bss (NOLOAD) : { build/asm/main_80011840.s.o(.bss); }
    .main_80011F04 0x80011F04 : AT(0x00012B04) { FILL(0x00000000); build/asm/main_80011F04.s.o(.text); build/asm/main_80011F04.s.o(.rodata); build/asm/main_80011F04.s.o(.data); }
    .main_80011F04_bss (NOLOAD) : { build/asm/main_80011F04.s.o(.bss); }
    .main_80012538 0x80012538 : AT(0x00013138) { build/asm/data/main_80012538.bin.o(.data); }
    .main_8001335C 0x8001335C : AT(0x00013F5C) { build/asm/data/main_8001335C.bin.o(.data); }
    .main_80013478 0x80013478 : AT(0x00014078) { FILL(0x00000000); build/asm/main_80013478.s.o(.text); build/asm/main_80013478.s.o(.rodata); build/asm/main_80013478.s.o(.data); }
    .main_80013478_bss (NOLOAD) : { build/asm/main_80013478.s.o(.bss); }
    .main_800134C0 0x800134C0 : AT(0x000140C0) { build/asm/data/main_800134C0.bin.o(.data); }
    .main_8001468C 0x8001468C : AT(0x0001528C) { build/asm/data/main_8001468C.bin.o(.data); }
    .main_80015CF0 0x80015CF0 : AT(0x000168F0) { build/asm/data/main_80015CF0.bin.o(.data); }
    .main_80016A14 0x80016A14 : AT(0x00017614) { build/asm/data/main_80016A14.bin.o(.data); }
    .main_80016A64 0x80016A64 : AT(0x00017664) { build/asm/data/main_80016A64.bin.o(.data); }
    .main_80016B5C 0x80016B5C : AT(0x0001775C) { build/asm/data/main_80016B5C.bin.o(.data); }
    .main_8001800C 0x8001800C : AT(0x00018C0C) { FILL(0x00000000); build/asm/main_8001800C.s.o(.text); build/asm/main_8001800C.s.o(.rodata); build/asm/main_8001800C.s.o(.data); }
    .main_8001800C_bss (NOLOAD) : { build/asm/main_8001800C.s.o(.bss); }
    .main_80018044 0x80018044 : AT(0x00018C44) { build/asm/data/main_80018044.bin.o(.data); }
    .main_8001AF38 0x8001AF38 : AT(0x0001BB38) { FILL(0x00000000); build/asm/main_8001AF38.s.o(.text); build/asm/main_8001AF38.s.o(.rodata); build/asm/main_8001AF38.s.o(.data); }
    .main_8001AF38_bss (NOLOAD) : { build/asm/main_8001AF38.s.o(.bss); }
    .main_8001B010 0x8001B010 : AT(0x0001BC10) { build/asm/data/main_8001B010.bin.o(.data); }
    .main_8001BE3C 0x8001BE3C : AT(0x0001CA3C) { FILL(0x00000000); build/asm/main_8001BE3C.s.o(.text); build/asm/main_8001BE3C.s.o(.rodata); build/asm/main_8001BE3C.s.o(.data); }
    .main_8001BE3C_bss (NOLOAD) : { build/asm/main_8001BE3C.s.o(.bss); }
    .main_8001BEC4 0x8001BEC4 : AT(0x0001CAC4) { build/asm/data/main_8001BEC4.bin.o(.data); }
    .main_8001E9BC 0x8001E9BC : AT(0x0001F5BC) { FILL(0x00000000); build/asm/main_8001E9BC.s.o(.text); build/asm/main_8001E9BC.s.o(.rodata); build/asm/main_8001E9BC.s.o(.data); }
    .main_8001E9BC_bss (NOLOAD) : { build/asm/main_8001E9BC.s.o(.bss); }
    .main_8001E9D0 0x8001E9D0 : AT(0x0001F5D0) { build/asm/data/main_8001E9D0.bin.o(.data); }
    .main_80024430 0x80024430 : AT(0x00025030) { FILL(0x00000000); build/asm/main_80024430.s.o(.text); build/asm/main_80024430.s.o(.rodata); build/asm/main_80024430.s.o(.data); }
    .main_80024430_bss (NOLOAD) : { build/asm/main_80024430.s.o(.bss); }
    .main_80024464 0x80024464 : AT(0x00025064) { build/asm/data/main_80024464.bin.o(.data); }
    .main_80027C3C 0x80027C3C : AT(0x0002883C) { FILL(0x00000000); build/asm/main_80027C3C.s.o(.text); build/asm/main_80027C3C.s.o(.rodata); build/asm/main_80027C3C.s.o(.data); }
    .main_80027C3C_bss (NOLOAD) : { build/asm/main_80027C3C.s.o(.bss); }
    .main_80027C5C 0x80027C5C : AT(0x0002885C) { build/asm/data/main_80027C5C.bin.o(.data); }
    .main_800281BC 0x800281BC : AT(0x00028DBC) { FILL(0x00000000); build/asm/main_800281BC.s.o(.text); build/asm/main_800281BC.s.o(.rodata); build/asm/main_800281BC.s.o(.data); }
    .main_800281BC_bss (NOLOAD) : { build/asm/main_800281BC.s.o(.bss); }
    .main_800281D8 0x800281D8 : AT(0x00028DD8) { build/asm/data/main_800281D8.bin.o(.data); }
    .main_80028854 0x80028854 : AT(0x00029454) { FILL(0x00000000); build/asm/main_80028854.s.o(.text); build/asm/main_80028854.s.o(.rodata); build/asm/main_80028854.s.o(.data); }
    .main_80028854_bss (NOLOAD) : { build/asm/main_80028854.s.o(.bss); }
    .main_80028868 0x80028868 : AT(0x00029468) { build/asm/data/main_80028868.bin.o(.data); }
    .main_80028A60 0x80028A60 : AT(0x00029660) { FILL(0x00000000); build/asm/main_80028A60.s.o(.text); build/asm/main_80028A60.s.o(.rodata); build/asm/main_80028A60.s.o(.data); }
    .main_80028A60_bss (NOLOAD) : { build/asm/main_80028A60.s.o(.bss); }
    .main_80028A68 0x80028A68 : AT(0x00029668) { build/asm/data/main_80028A68.bin.o(.data); }
    .main_8002DBC4 0x8002DBC4 : AT(0x0002E7C4) { FILL(0x00000000); build/asm/main_8002DBC4.s.o(.text); build/asm/main_8002DBC4.s.o(.rodata); build/asm/main_8002DBC4.s.o(.data); }
    .main_8002DBC4_bss (NOLOAD) : { build/asm/main_8002DBC4.s.o(.bss); }
    .main_8002DC64 0x8002DC64 : AT(0x0002E864) { build/asm/data/main_8002DC64.bin.o(.data); }
    .main_80035318 0x80035318 : AT(0x00035F18) { FILL(0x00000000); build/asm/main_80035318.s.o(.text); build/asm/main_80035318.s.o(.rodata); build/asm/main_80035318.s.o(.data); }
    .main_80035318_bss (NOLOAD) : { build/asm/main_80035318.s.o(.bss); }
    .main_80035454 0x80035454 : AT(0x00036054) { build/asm/data/main_80035454.bin.o(.data); }
    .main_80035DB0 0x80035DB0 : AT(0x000369B0) { FILL(0x00000000); build/asm/main_80035DB0.s.o(.text); build/asm/main_80035DB0.s.o(.rodata); build/asm/main_80035DB0.s.o(.data); }
    .main_80035DB0_bss (NOLOAD) : { build/asm/main_80035DB0.s.o(.bss); }
    .main_80035DCC 0x80035DCC : AT(0x000369CC) { build/asm/data/main_80035DCC.bin.o(.data); }
    .main_800376E8 0x800376E8 : AT(0x000382E8) { FILL(0x00000000); build/asm/main_800376E8.s.o(.text); build/asm/main_800376E8.s.o(.rodata); build/asm/main_800376E8.s.o(.data); }
    .main_800376E8_bss (NOLOAD) : { build/asm/main_800376E8.s.o(.bss); }
    .main_80037740 0x80037740 : AT(0x00038340) { build/asm/data/main_80037740.bin.o(.data); }
    .main_8003997C 0x8003997C : AT(0x0003A57C) { FILL(0x00000000); build/asm/main_8003997C.s.o(.text); build/asm/main_8003997C.s.o(.rodata); build/asm/main_8003997C.s.o(.data); }
    .main_8003997C_bss (NOLOAD) : { build/asm/main_8003997C.s.o(.bss); }
    .main_800399D0 0x800399D0 : AT(0x0003A5D0) { build/asm/data/main_800399D0.bin.o(.data); }
    .main_8003DEBC 0x8003DEBC : AT(0x0003EABC) { FILL(0x00000000); build/asm/main_8003DEBC.s.o(.text); build/asm/main_8003DEBC.s.o(.rodata); build/asm/main_8003DEBC.s.o(.data); }
    .main_8003DEBC_bss (NOLOAD) : { build/asm/main_8003DEBC.s.o(.bss); }
    .main_8003DF80 0x8003DF80 : AT(0x0003EB80) { build/asm/data/main_8003DF80.bin.o(.data); }
    .main_8004077C 0x8004077C : AT(0x0004137C) { FILL(0x00000000); build/asm/main_8004077C.s.o(.text); build/asm/main_8004077C.s.o(.rodata); build/asm/main_8004077C.s.o(.data); }
    .main_8004077C_bss (NOLOAD) : { build/asm/main_8004077C.s.o(.bss); }
    .main_8004078C 0x8004078C : AT(0x0004138C) { build/asm/data/main_8004078C.bin.o(.data); }
    .main_800410D0 0x800410D0 : AT(0x00041CD0) { FILL(0x00000000); build/asm/main_800410D0.s.o(.text); build/asm/main_800410D0.s.o(.rodata); build/asm/main_800410D0.s.o(.data); }
    .main_800410D0_bss (NOLOAD) : { build/asm/main_800410D0.s.o(.bss); }
    .main_800410F4 0x800410F4 : AT(0x00041CF4) { build/asm/data/main_800410F4.bin.o(.data); }
    .main_80042650 0x80042650 : AT(0x00043250) { FILL(0x00000000); build/asm/main_80042650.s.o(.text); build/asm/main_80042650.s.o(.rodata); build/asm/main_80042650.s.o(.data); }
    .main_80042650_bss (NOLOAD) : { build/asm/main_80042650.s.o(.bss); }
    .main_80042678 0x80042678 : AT(0x00043278) { build/asm/data/main_80042678.bin.o(.data); }
    .main_80047490 0x80047490 : AT(0x00048090) { FILL(0x00000000); build/asm/main_80047490.s.o(.text); build/asm/main_80047490.s.o(.rodata); build/asm/main_80047490.s.o(.data); }
    .main_80047490_bss (NOLOAD) : { build/asm/main_80047490.s.o(.bss); }
    .main_80047498 0x80047498 : AT(0x00048098) { build/asm/data/main_80047498.bin.o(.data); }
    .main_80047B40 0x80047B40 : AT(0x00048740) { FILL(0x00000000); build/asm/main_80047B40.s.o(.text); build/asm/main_80047B40.s.o(.rodata); build/asm/main_80047B40.s.o(.data); }
    .main_80047B40_bss (NOLOAD) : { build/asm/main_80047B40.s.o(.bss); }
    .main_80047B80 0x80047B80 : AT(0x00048780) { build/asm/data/main_80047B80.bin.o(.data); }
    .main_800487FC 0x800487FC : AT(0x000493FC) { FILL(0x00000000); build/asm/main_800487FC.s.o(.text); build/asm/main_800487FC.s.o(.rodata); build/asm/main_800487FC.s.o(.data); }
    .main_800487FC_bss (NOLOAD) : { build/asm/main_800487FC.s.o(.bss); }
    .main_80048800 0x80048800 : AT(0x00049400) { build/asm/data/main_80048800.bin.o(.data); }
    .main_80049B40 0x80049B40 : AT(0x0004A740) { FILL(0x00000000); build/asm/main_80049B40.s.o(.text); build/asm/main_80049B40.s.o(.rodata); build/asm/main_80049B40.s.o(.data); }
    .main_80049B40_bss (NOLOAD) : { build/asm/main_80049B40.s.o(.bss); }
    .main_80049C3C 0x80049C3C : AT(0x0004A83C) { build/asm/data/main_80049C3C.bin.o(.data); }
    .main_8004FDB4 0x8004FDB4 : AT(0x000509B4) { FILL(0x00000000); build/asm/main_8004FDB4.s.o(.text); build/asm/main_8004FDB4.s.o(.rodata); build/asm/main_8004FDB4.s.o(.data); }
    .main_8004FDB4_bss (NOLOAD) : { build/asm/main_8004FDB4.s.o(.bss); }
    .main_8004FDDC 0x8004FDDC : AT(0x000509DC) { build/asm/data/main_8004FDDC.bin.o(.data); }
    .main_80052880 0x80052880 : AT(0x00053480) { FILL(0x00000000); build/asm/main_80052880.s.o(.text); build/asm/main_80052880.s.o(.rodata); build/asm/main_80052880.s.o(.data); }
    .main_80052880_bss (NOLOAD) : { build/asm/main_80052880.s.o(.bss); }
    .main_80052898 0x80052898 : AT(0x00053498) { build/asm/data/main_80052898.bin.o(.data); }
    .main_80052AE4 0x80052AE4 : AT(0x000536E4) { FILL(0x00000000); build/asm/main_80052AE4.s.o(.text); build/asm/main_80052AE4.s.o(.rodata); build/asm/main_80052AE4.s.o(.data); }
    .main_80052AE4_bss (NOLOAD) : { build/asm/main_80052AE4.s.o(.bss); }
    .main_80052B28 0x80052B28 : AT(0x00053728) { build/asm/data/main_80052B28.bin.o(.data); }
    .main_80053F60 0x80053F60 : AT(0x00054B60) { FILL(0x00000000); build/asm/main_80053F60.s.o(.text); build/asm/main_80053F60.s.o(.rodata); build/asm/main_80053F60.s.o(.data); }
    .main_80053F60_bss (NOLOAD) : { build/asm/main_80053F60.s.o(.bss); }
    .main_80053F64 0x80053F64 : AT(0x00054B64) { build/asm/data/main_80053F64.bin.o(.data); }
    .main_8005A3A0 0x8005A3A0 : AT(0x0005AFA0) { FILL(0x00000000); build/asm/main_8005A3A0.s.o(.text); build/asm/main_8005A3A0.s.o(.rodata); build/asm/main_8005A3A0.s.o(.data); }
    .main_8005A3A0_bss (NOLOAD) : { build/asm/main_8005A3A0.s.o(.bss); }
    .main_8005A3C0 0x8005A3C0 : AT(0x0005AFC0) { build/asm/data/main_8005A3C0.bin.o(.data); }
    .main_8005A4CC 0x8005A4CC : AT(0x0005B0CC) { FILL(0x00000000); build/asm/main_8005A4CC.s.o(.text); build/asm/main_8005A4CC.s.o(.rodata); build/asm/main_8005A4CC.s.o(.data); }
    .main_8005A4CC_bss (NOLOAD) : { build/asm/main_8005A4CC.s.o(.bss); }
    .main_8005A51C 0x8005A51C : AT(0x0005B11C) { build/asm/data/main_8005A51C.bin.o(.data); }
    .main_8005C2F4 0x8005C2F4 : AT(0x0005CEF4) { FILL(0x00000000); build/asm/main_8005C2F4.s.o(.text); build/asm/main_8005C2F4.s.o(.rodata); build/asm/main_8005C2F4.s.o(.data); }
    .main_8005C2F4_bss (NOLOAD) : { build/asm/main_8005C2F4.s.o(.bss); }
    .main_8005C308 0x8005C308 : AT(0x0005CF08) { build/asm/data/main_8005C308.bin.o(.data); }
    .main_8005F490 0x8005F490 : AT(0x00060090) { FILL(0x00000000); build/asm/main_8005F490.s.o(.text); build/asm/main_8005F490.s.o(.rodata); build/asm/main_8005F490.s.o(.data); }
    .main_8005F490_bss (NOLOAD) : { build/asm/main_8005F490.s.o(.bss); }
    .main_8005F548 0x8005F548 : AT(0x00060148) { build/asm/data/main_8005F548.bin.o(.data); }
    .main_8005F604 0x8005F604 : AT(0x00060204) { FILL(0x00000000); build/asm/main_8005F604.s.o(.text); build/asm/main_8005F604.s.o(.rodata); build/asm/main_8005F604.s.o(.data); }
    .main_8005F604_bss (NOLOAD) : { build/asm/main_8005F604.s.o(.bss); }
    .main_8005F614 0x8005F614 : AT(0x00060214) { build/asm/data/main_8005F614.bin.o(.data); }
    .main_800615F0 0x800615F0 : AT(0x000621F0) { FILL(0x00000000); build/asm/main_800615F0.s.o(.text); build/asm/main_800615F0.s.o(.rodata); build/asm/main_800615F0.s.o(.data); }
    .main_800615F0_bss (NOLOAD) : { build/asm/main_800615F0.s.o(.bss); }
    .main_800615F8 0x800615F8 : AT(0x000621F8) { build/asm/data/main_800615F8.bin.o(.data); }
    .main_800618A0 0x800618A0 : AT(0x000624A0) { FILL(0x00000000); build/asm/main_800618A0.s.o(.text); build/asm/main_800618A0.s.o(.rodata); build/asm/main_800618A0.s.o(.data); }
    .main_800618A0_bss (NOLOAD) : { build/asm/main_800618A0.s.o(.bss); }
    .main_800618AC 0x800618AC : AT(0x000624AC) { build/asm/data/main_800618AC.bin.o(.data); }
    .main_80063B70 0x80063B70 : AT(0x00064770) { FILL(0x00000000); build/asm/main_80063B70.s.o(.text); build/asm/main_80063B70.s.o(.rodata); build/asm/main_80063B70.s.o(.data); }
    .main_80063B70_bss (NOLOAD) : { build/asm/main_80063B70.s.o(.bss); }
    .main_80063B74 0x80063B74 : AT(0x00064774) { build/asm/data/main_80063B74.bin.o(.data); }
    .main_80067B00 0x80067B00 : AT(0x00068700) { FILL(0x00000000); build/asm/main_80067B00.s.o(.text); build/asm/main_80067B00.s.o(.rodata); build/asm/main_80067B00.s.o(.data); }
    .main_80067B00_bss (NOLOAD) : { build/asm/main_80067B00.s.o(.bss); }
    .main_80067B60 0x80067B60 : AT(0x00068760) { build/asm/data/main_80067B60.bin.o(.data); }
    .main_8006AFD8 0x8006AFD8 : AT(0x0006BBD8) { FILL(0x00000000); build/asm/main_8006AFD8.s.o(.text); build/asm/main_8006AFD8.s.o(.rodata); build/asm/main_8006AFD8.s.o(.data); }
    .main_8006AFD8_bss (NOLOAD) : { build/asm/main_8006AFD8.s.o(.bss); }
    .main_8006B010 0x8006B010 : AT(0x0006BC10) { build/asm/data/main_8006B010.bin.o(.data); }
    .main_8006FEB8 0x8006FEB8 : AT(0x00070AB8) { FILL(0x00000000); build/asm/main_8006FEB8.s.o(.text); build/asm/main_8006FEB8.s.o(.rodata); build/asm/main_8006FEB8.s.o(.data); }
    .main_8006FEB8_bss (NOLOAD) : { build/asm/main_8006FEB8.s.o(.bss); }
    .main_8006FEEC 0x8006FEEC : AT(0x00070AEC) { build/asm/data/main_8006FEEC.bin.o(.data); }
    .main_800764E8 0x800764E8 : AT(0x000770E8) { FILL(0x00000000); build/asm/main_800764E8.s.o(.text); build/asm/main_800764E8.s.o(.rodata); build/asm/main_800764E8.s.o(.data); }
    .main_800764E8_bss (NOLOAD) : { build/asm/main_800764E8.s.o(.bss); }
    .main_80076510 0x80076510 : AT(0x00077110) { build/asm/data/main_80076510.bin.o(.data); }
    .main_80076E24 0x80076E24 : AT(0x00077A24) { FILL(0x00000000); build/asm/main_80076E24.s.o(.text); build/asm/main_80076E24.s.o(.rodata); build/asm/main_80076E24.s.o(.data); }
    .main_80076E24_bss (NOLOAD) : { build/asm/main_80076E24.s.o(.bss); }
    .main_80076E5C 0x80076E5C : AT(0x00077A5C) { build/asm/data/main_80076E5C.bin.o(.data); }
    .main_80077904 0x80077904 : AT(0x00078504) { FILL(0x00000000); build/asm/main_80077904.s.o(.text); build/asm/main_80077904.s.o(.rodata); build/asm/main_80077904.s.o(.data); }
    .main_80077904_bss (NOLOAD) : { build/asm/main_80077904.s.o(.bss); }
    .main_8007796C 0x8007796C : AT(0x0007856C) { build/asm/data/main_8007796C.bin.o(.data); }
    .main_8007BAD8 0x8007BAD8 : AT(0x0007C6D8) { FILL(0x00000000); build/asm/main_8007BAD8.s.o(.text); build/asm/main_8007BAD8.s.o(.rodata); build/asm/main_8007BAD8.s.o(.data); }
    .main_8007BAD8_bss (NOLOAD) : { build/asm/main_8007BAD8.s.o(.bss); }
    .main_8007BAEC 0x8007BAEC : AT(0x0007C6EC) { build/asm/data/main_8007BAEC.bin.o(.data); }
    .main_8007D720 0x8007D720 : AT(0x0007E320) { FILL(0x00000000); build/asm/main_8007D720.s.o(.text); build/asm/main_8007D720.s.o(.rodata); build/asm/main_8007D720.s.o(.data); }
    .main_8007D720_bss (NOLOAD) : { build/asm/main_8007D720.s.o(.bss); }
    .main_8007D730 0x8007D730 : AT(0x0007E330) { build/asm/data/main_8007D730.bin.o(.data); }
    .main_8007E4FC 0x8007E4FC : AT(0x0007F0FC) { FILL(0x00000000); build/asm/main_8007E4FC.s.o(.text); build/asm/main_8007E4FC.s.o(.rodata); build/asm/main_8007E4FC.s.o(.data); }
    .main_8007E4FC_bss (NOLOAD) : { build/asm/main_8007E4FC.s.o(.bss); }
    .main_8007E51C 0x8007E51C : AT(0x0007F11C) { build/asm/data/main_8007E51C.bin.o(.data); }
    .main_8007F900 0x8007F900 : AT(0x00080500) { FILL(0x00000000); build/asm/main_8007F900.s.o(.text); build/asm/main_8007F900.s.o(.rodata); build/asm/main_8007F900.s.o(.data); }
    .main_8007F900_bss (NOLOAD) : { build/asm/main_8007F900.s.o(.bss); }
    .main_8007F904 0x8007F904 : AT(0x00080504) { build/asm/data/main_8007F904.bin.o(.data); }
    .main_8007FBA4 0x8007FBA4 : AT(0x000807A4) { FILL(0x00000000); build/asm/main_8007FBA4.s.o(.text); build/asm/main_8007FBA4.s.o(.rodata); build/asm/main_8007FBA4.s.o(.data); }
    .main_8007FBA4_bss (NOLOAD) : { build/asm/main_8007FBA4.s.o(.bss); }
    .main_8007FC40 0x8007FC40 : AT(0x00080840) { build/asm/data/main_8007FC40.bin.o(.data); }
    .main_80080074 0x80080074 : AT(0x00080C74) { FILL(0x00000000); build/asm/main_80080074.s.o(.text); build/asm/main_80080074.s.o(.rodata); build/asm/main_80080074.s.o(.data); }
    .main_80080074_bss (NOLOAD) : { build/asm/main_80080074.s.o(.bss); }
    .main_80080078 0x80080078 : AT(0x00080C78) { build/asm/data/main_80080078.bin.o(.data); }
    .main_80089C80 0x80089C80 : AT(0x0008A880) { FILL(0x00000000); build/asm/main_80089C80.s.o(.text); build/asm/main_80089C80.s.o(.rodata); build/asm/main_80089C80.s.o(.data); }
    .main_80089C80_bss (NOLOAD) : { build/asm/main_80089C80.s.o(.bss); }
    .main_80089C98 0x80089C98 : AT(0x0008A898) { build/asm/data/main_80089C98.bin.o(.data); }
    .main_8008A1AC 0x8008A1AC : AT(0x0008ADAC) { FILL(0x00000000); build/asm/main_8008A1AC.s.o(.text); build/asm/main_8008A1AC.s.o(.rodata); build/asm/main_8008A1AC.s.o(.data); }
    .main_8008A1AC_bss (NOLOAD) : { build/asm/main_8008A1AC.s.o(.bss); }
    .main_8008A1B4 0x8008A1B4 : AT(0x0008ADB4) { build/asm/data/main_8008A1B4.bin.o(.data); }
    .main_8008BA50 0x8008BA50 : AT(0x0008C650) { FILL(0x00000000); build/asm/main_8008BA50.s.o(.text); build/asm/main_8008BA50.s.o(.rodata); build/asm/main_8008BA50.s.o(.data); }
    .main_8008BA50_bss (NOLOAD) : { build/asm/main_8008BA50.s.o(.bss); }
    .main_8008BA68 0x8008BA68 : AT(0x0008C668) { build/asm/data/main_8008BA68.bin.o(.data); }
    .main_8008E4BC 0x8008E4BC : AT(0x0008F0BC) { FILL(0x00000000); build/asm/main_8008E4BC.s.o(.text); build/asm/main_8008E4BC.s.o(.rodata); build/asm/main_8008E4BC.s.o(.data); }
    .main_8008E4BC_bss (NOLOAD) : { build/asm/main_8008E4BC.s.o(.bss); }
    .main_8008E4C0 0x8008E4C0 : AT(0x0008F0C0) { build/asm/data/main_8008E4C0.bin.o(.data); }
    .main_800920B0 0x800920B0 : AT(0x00092CB0) { FILL(0x00000000); build/asm/main_800920B0.s.o(.text); build/asm/main_800920B0.s.o(.rodata); build/asm/main_800920B0.s.o(.data); }
    .main_800920B0_bss (NOLOAD) : { build/asm/main_800920B0.s.o(.bss); }
    .main_800920B8 0x800920B8 : AT(0x00092CB8) { build/asm/data/main_800920B8.bin.o(.data); }
    .main_800953BC 0x800953BC : AT(0x00095FBC) { FILL(0x00000000); build/asm/main_800953BC.s.o(.text); build/asm/main_800953BC.s.o(.rodata); build/asm/main_800953BC.s.o(.data); }
    .main_800953BC_bss (NOLOAD) : { build/asm/main_800953BC.s.o(.bss); }
    .main_800953C0 0x800953C0 : AT(0x00095FC0) { build/asm/data/main_800953C0.bin.o(.data); }
    .main_8009DB34 0x8009DB34 : AT(0x0009E734) { FILL(0x00000000); build/asm/main_8009DB34.s.o(.text); build/asm/main_8009DB34.s.o(.rodata); build/asm/main_8009DB34.s.o(.data); }
    .main_8009DB34_bss (NOLOAD) : { build/asm/main_8009DB34.s.o(.bss); }
    .main_8009DB44 0x8009DB44 : AT(0x0009E744) { build/asm/data/main_8009DB44.bin.o(.data); }
    .main_8009E838 0x8009E838 : AT(0x0009F438) { FILL(0x00000000); build/asm/main_8009E838.s.o(.text); build/asm/main_8009E838.s.o(.rodata); build/asm/main_8009E838.s.o(.data); }
    .main_8009E838_bss (NOLOAD) : { build/asm/main_8009E838.s.o(.bss); }
    .main_8009E858 0x8009E858 : AT(0x0009F458) { build/asm/data/main_8009E858.bin.o(.data); }
    .main_800A0240 0x800A0240 : AT(0x000A0E40) { FILL(0x00000000); build/asm/main_800A0240.s.o(.text); build/asm/main_800A0240.s.o(.rodata); build/asm/main_800A0240.s.o(.data); }
    .main_800A0240_bss (NOLOAD) : { build/asm/main_800A0240.s.o(.bss); }
    .main_800A0258 0x800A0258 : AT(0x000A0E58) { build/asm/data/main_800A0258.bin.o(.data); }
    .main_800A5024 0x800A5024 : AT(0x000A5C24) { FILL(0x00000000); build/asm/main_800A5024.s.o(.text); build/asm/main_800A5024.s.o(.rodata); build/asm/main_800A5024.s.o(.data); }
    .main_800A5024_bss (NOLOAD) : { build/asm/main_800A5024.s.o(.bss); }
    .main_800A50B0 0x800A50B0 : AT(0x000A5CB0) { build/asm/data/main_800A50B0.bin.o(.data); }
    .main_800A5C8C 0x800A5C8C : AT(0x000A688C) { FILL(0x00000000); build/asm/main_800A5C8C.s.o(.text); build/asm/main_800A5C8C.s.o(.rodata); build/asm/main_800A5C8C.s.o(.data); }
    .main_800A5C8C_bss (NOLOAD) : { build/asm/main_800A5C8C.s.o(.bss); }
    .main_800A5CE8 0x800A5CE8 : AT(0x000A68E8) { build/asm/data/main_800A5CE8.bin.o(.data); }
    .main_800A96BC 0x800A96BC : AT(0x000AA2BC) { FILL(0x00000000); build/asm/main_800A96BC.s.o(.text); build/asm/main_800A96BC.s.o(.rodata); build/asm/main_800A96BC.s.o(.data); }
    .main_800A96BC_bss (NOLOAD) : { build/asm/main_800A96BC.s.o(.bss); }
    .main_800A96D4 0x800A96D4 : AT(0x000AA2D4) { build/asm/data/main_800A96D4.bin.o(.data); }
    .main_800B01C0 0x800B01C0 : AT(0x000B0DC0) { FILL(0x00000000); build/asm/main_800B01C0.s.o(.text); build/asm/main_800B01C0.s.o(.rodata); build/asm/main_800B01C0.s.o(.data); }
    .main_800B01C0_bss (NOLOAD) : { build/asm/main_800B01C0.s.o(.bss); }
    .main_800B01C4 0x800B01C4 : AT(0x000B0DC4) { build/asm/data/main_800B01C4.bin.o(.data); }
    .main_800B182C 0x800B182C : AT(0x000B242C) { FILL(0x00000000); build/asm/main_800B182C.s.o(.text); build/asm/main_800B182C.s.o(.rodata); build/asm/main_800B182C.s.o(.data); }
    .main_800B182C_bss (NOLOAD) : { build/asm/main_800B182C.s.o(.bss); }
    .main_800B1834 0x800B1834 : AT(0x000B2434) { build/asm/data/main_800B1834.bin.o(.data); }
    .main_800B39F8 0x800B39F8 : AT(0x000B45F8) { FILL(0x00000000); build/asm/main_800B39F8.s.o(.text); build/asm/main_800B39F8.s.o(.rodata); build/asm/main_800B39F8.s.o(.data); }
    .main_800B39F8_bss (NOLOAD) : { build/asm/main_800B39F8.s.o(.bss); }
    .main_800B3A1C 0x800B3A1C : AT(0x000B461C) { build/asm/data/main_800B3A1C.bin.o(.data); }
    .main_800B80DC 0x800B80DC : AT(0x000B8CDC) { FILL(0x00000000); build/asm/main_800B80DC.s.o(.text); build/asm/main_800B80DC.s.o(.rodata); build/asm/main_800B80DC.s.o(.data); }
    .main_800B80DC_bss (NOLOAD) : { build/asm/main_800B80DC.s.o(.bss); }
    .main_800B80E0 0x800B80E0 : AT(0x000B8CE0) { build/asm/data/main_800B80E0.bin.o(.data); }
    .main_800B843C 0x800B843C : AT(0x000B903C) { FILL(0x00000000); build/asm/main_800B843C.s.o(.text); build/asm/main_800B843C.s.o(.rodata); build/asm/main_800B843C.s.o(.data); }
    .main_800B843C_bss (NOLOAD) : { build/asm/main_800B843C.s.o(.bss); }
    .main_800B8448 0x800B8448 : AT(0x000B9048) { build/asm/data/main_800B8448.bin.o(.data); }
    .main_800BC3EC 0x800BC3EC : AT(0x000BCFEC) { FILL(0x00000000); build/asm/main_800BC3EC.s.o(.text); build/asm/main_800BC3EC.s.o(.rodata); build/asm/main_800BC3EC.s.o(.data); }
    .main_800BC3EC_bss (NOLOAD) : { build/asm/main_800BC3EC.s.o(.bss); }
    .main_800BC418 0x800BC418 : AT(0x000BD018) { build/asm/data/main_800BC418.bin.o(.data); }
    .main_800BC658 0x800BC658 : AT(0x000BD258) { FILL(0x00000000); build/asm/main_800BC658.s.o(.text); build/asm/main_800BC658.s.o(.rodata); build/asm/main_800BC658.s.o(.data); }
    .main_800BC658_bss (NOLOAD) : { build/asm/main_800BC658.s.o(.bss); }
    .main_800BC670 0x800BC670 : AT(0x000BD270) { build/asm/data/main_800BC670.bin.o(.data); }
    .main_800C09D0 0x800C09D0 : AT(0x000C15D0) { FILL(0x00000000); build/asm/main_800C09D0.s.o(.text); build/asm/main_800C09D0.s.o(.rodata); build/asm/main_800C09D0.s.o(.data); }
    .main_800C09D0_bss (NOLOAD) : { build/asm/main_800C09D0.s.o(.bss); }
    .main_800C0A68 0x800C0A68 : AT(0x000C1668) { build/asm/data/main_800C0A68.bin.o(.data); }
    .main_800C18F0 0x800C18F0 : AT(0x000C24F0) { FILL(0x00000000); build/asm/main_800C18F0.s.o(.text); build/asm/main_800C18F0.s.o(.rodata); build/asm/main_800C18F0.s.o(.data); }
    .main_800C18F0_bss (NOLOAD) : { build/asm/main_800C18F0.s.o(.bss); }
    .main_800C1924 0x800C1924 : AT(0x000C2524) { build/asm/data/main_800C1924.bin.o(.data); }
    .main_800C29D8 0x800C29D8 : AT(0x000C35D8) { FILL(0x00000000); build/asm/main_800C29D8.s.o(.text); build/asm/main_800C29D8.s.o(.rodata); build/asm/main_800C29D8.s.o(.data); }
    .main_800C29D8_bss (NOLOAD) : { build/asm/main_800C29D8.s.o(.bss); }
    .main_800C2A80 0x800C2A80 : AT(0x000C3680) { build/asm/data/main_800C2A80.bin.o(.data); }
    .main_800C4420 0x800C4420 : AT(0x000C5020) { FILL(0x00000000); build/asm/main_800C4420.s.o(.text); build/asm/main_800C4420.s.o(.rodata); build/asm/main_800C4420.s.o(.data); }
    .main_800C4420_bss (NOLOAD) : { build/asm/main_800C4420.s.o(.bss); }
    .main_800C4444 0x800C4444 : AT(0x000C5044) { build/asm/data/main_800C4444.bin.o(.data); }
    .main_800C51AC 0x800C51AC : AT(0x000C5DAC) { FILL(0x00000000); build/asm/main_800C51AC.s.o(.text); build/asm/main_800C51AC.s.o(.rodata); build/asm/main_800C51AC.s.o(.data); }
    .main_800C51AC_bss (NOLOAD) : { build/asm/main_800C51AC.s.o(.bss); }
    .main_800C51F4 0x800C51F4 : AT(0x000C5DF4) { build/asm/data/main_800C51F4.bin.o(.data); }
    .main_800C73F0 0x800C73F0 : AT(0x000C7FF0) { FILL(0x00000000); build/asm/main_800C73F0.s.o(.text); build/asm/main_800C73F0.s.o(.rodata); build/asm/main_800C73F0.s.o(.data); }
    .main_800C73F0_bss (NOLOAD) : { build/asm/main_800C73F0.s.o(.bss); }
    .main_800C743C 0x800C743C : AT(0x000C803C) { build/asm/data/main_800C743C.bin.o(.data); }
    .main_800C8170 0x800C8170 : AT(0x000C8D70) { FILL(0x00000000); build/asm/main_800C8170.s.o(.text); build/asm/main_800C8170.s.o(.rodata); build/asm/main_800C8170.s.o(.data); }
    .main_800C8170_bss (NOLOAD) : { build/asm/main_800C8170.s.o(.bss); }
    .main_800C81A0 0x800C81A0 : AT(0x000C8DA0) { build/asm/data/main_800C81A0.bin.o(.data); }
    .main_800C8B64 0x800C8B64 : AT(0x000C9764) { FILL(0x00000000); build/asm/main_800C8B64.s.o(.text); build/asm/main_800C8B64.s.o(.rodata); build/asm/main_800C8B64.s.o(.data); }
    .main_800C8B64_bss (NOLOAD) : { build/asm/main_800C8B64.s.o(.bss); }
    .main_800C8B9C 0x800C8B9C : AT(0x000C979C) { build/asm/data/main_800C8B9C.bin.o(.data); }
    .main_800CA008 0x800CA008 : AT(0x000CAC08) { FILL(0x00000000); build/asm/main_800CA008.s.o(.text); build/asm/main_800CA008.s.o(.rodata); build/asm/main_800CA008.s.o(.data); }
    .main_800CA008_bss (NOLOAD) : { build/asm/main_800CA008.s.o(.bss); }
    .main_800CA01C 0x800CA01C : AT(0x000CAC1C) { build/asm/data/main_800CA01C.bin.o(.data); }
    .main_800CA674 0x800CA674 : AT(0x000CB274) { FILL(0x00000000); build/asm/main_800CA674.s.o(.text); build/asm/main_800CA674.s.o(.rodata); build/asm/main_800CA674.s.o(.data); }
    .main_800CA674_bss (NOLOAD) : { build/asm/main_800CA674.s.o(.bss); }
    .main_800CA684 0x800CA684 : AT(0x000CB284) { build/asm/data/main_800CA684.bin.o(.data); }
    .main_800CB6E0 0x800CB6E0 : AT(0x000CC2E0) { FILL(0x00000000); build/asm/main_800CB6E0.s.o(.text); build/asm/main_800CB6E0.s.o(.rodata); build/asm/main_800CB6E0.s.o(.data); }
    .main_800CB6E0_bss (NOLOAD) : { build/asm/main_800CB6E0.s.o(.bss); }
    .main_800CB718 0x800CB718 : AT(0x000CC318) { build/asm/data/main_800CB718.bin.o(.data); }
    .main_800CE03C 0x800CE03C : AT(0x000CEC3C) { FILL(0x00000000); build/asm/main_800CE03C.s.o(.text); build/asm/main_800CE03C.s.o(.rodata); build/asm/main_800CE03C.s.o(.data); }
    .main_800CE03C_bss (NOLOAD) : { build/asm/main_800CE03C.s.o(.bss); }
    .main_800CE040 0x800CE040 : AT(0x000CEC40) { build/asm/data/main_800CE040.bin.o(.data); }
    .main_800CE1F8 0x800CE1F8 : AT(0x000CEDF8) { FILL(0x00000000); build/asm/main_800CE1F8.s.o(.text); build/asm/main_800CE1F8.s.o(.rodata); build/asm/main_800CE1F8.s.o(.data); }
    .main_800CE1F8_bss (NOLOAD) : { build/asm/main_800CE1F8.s.o(.bss); }
    .main_800CE1FC 0x800CE1FC : AT(0x000CEDFC) { build/asm/data/main_800CE1FC.bin.o(.data); }
    .main_800D018C 0x800D018C : AT(0x000D0D8C) { FILL(0x00000000); build/asm/main_800D018C.s.o(.text); build/asm/main_800D018C.s.o(.rodata); build/asm/main_800D018C.s.o(.data); }
    .main_800D018C_bss (NOLOAD) : { build/asm/main_800D018C.s.o(.bss); }
    .main_800D01AC 0x800D01AC : AT(0x000D0DAC) { build/asm/data/main_800D01AC.bin.o(.data); }
    .main_800D1318 0x800D1318 : AT(0x000D1F18) { FILL(0x00000000); build/asm/main_800D1318.s.o(.text); build/asm/main_800D1318.s.o(.rodata); build/asm/main_800D1318.s.o(.data); }
    .main_800D1318_bss (NOLOAD) : { build/asm/main_800D1318.s.o(.bss); }
    .main_800D1368 0x800D1368 : AT(0x000D1F68) { build/asm/data/main_800D1368.bin.o(.data); }
    .main_800D1454 0x800D1454 : AT(0x000D2054) { FILL(0x00000000); build/asm/main_800D1454.s.o(.text); build/asm/main_800D1454.s.o(.rodata); build/asm/main_800D1454.s.o(.data); }
    .main_800D1454_bss (NOLOAD) : { build/asm/main_800D1454.s.o(.bss); }
    .main_800D146C 0x800D146C : AT(0x000D206C) { build/asm/data/main_800D146C.bin.o(.data); }
    .main_800D1748 0x800D1748 : AT(0x000D2348) { FILL(0x00000000); build/asm/main_800D1748.s.o(.text); build/asm/main_800D1748.s.o(.rodata); build/asm/main_800D1748.s.o(.data); }
    .main_800D1748_bss (NOLOAD) : { build/asm/main_800D1748.s.o(.bss); }
    .main_800D1760 0x800D1760 : AT(0x000D2360) { build/asm/data/main_800D1760.bin.o(.data); }
    .main_800E31D8 0x800E31D8 : AT(0x000E3DD8) { FILL(0x00000000); build/asm/main_800E31D8.s.o(.text); build/asm/main_800E31D8.s.o(.rodata); build/asm/main_800E31D8.s.o(.data); }
    .main_800E31D8_bss (NOLOAD) : { build/asm/main_800E31D8.s.o(.bss); }
    .main_800E3228 0x800E3228 : AT(0x000E3E28) { build/asm/data/main_800E3228.bin.o(.data); }
    .main_800F4630 0x800F4630 : AT(0x000F5230) { FILL(0x00000000); build/asm/main_800F4630.s.o(.text); build/asm/main_800F4630.s.o(.rodata); build/asm/main_800F4630.s.o(.data); }
    .main_800F4630_bss (NOLOAD) : { build/asm/main_800F4630.s.o(.bss); }
    .main_800F4634 0x800F4634 : AT(0x000F5234) { build/asm/data/main_800F4634.bin.o(.data); }
    .main_800F52A4 0x800F52A4 : AT(0x000F5EA4) { FILL(0x00000000); build/asm/main_800F52A4.s.o(.text); build/asm/main_800F52A4.s.o(.rodata); build/asm/main_800F52A4.s.o(.data); }
    .main_800F52A4_bss (NOLOAD) : { build/asm/main_800F52A4.s.o(.bss); }
    .main_800F52D0 0x800F52D0 : AT(0x000F5ED0) { build/asm/data/main_800F52D0.bin.o(.data); }
    .main_800F7BE4 0x800F7BE4 : AT(0x000F87E4) { FILL(0x00000000); build/asm/main_800F7BE4.s.o(.text); build/asm/main_800F7BE4.s.o(.rodata); build/asm/main_800F7BE4.s.o(.data); }
    .main_800F7BE4_bss (NOLOAD) : { build/asm/main_800F7BE4.s.o(.bss); }
    .main_800F7C20 0x800F7C20 : AT(0x000F8820) { build/asm/data/main_800F7C20.bin.o(.data); }
    .main_800FA26C 0x800FA26C : AT(0x000FAE6C) { FILL(0x00000000); build/asm/main_800FA26C.s.o(.text); build/asm/main_800FA26C.s.o(.rodata); build/asm/main_800FA26C.s.o(.data); }
    .main_800FA26C_bss (NOLOAD) : { build/asm/main_800FA26C.s.o(.bss); }
    .main_800FA278 0x800FA278 : AT(0x000FAE78) { build/asm/data/main_800FA278.bin.o(.data); }
    .main_800FA5B4 0x800FA5B4 : AT(0x000FB1B4) { FILL(0x00000000); build/asm/main_800FA5B4.s.o(.text); build/asm/main_800FA5B4.s.o(.rodata); build/asm/main_800FA5B4.s.o(.data); }
    .main_800FA5B4_bss (NOLOAD) : { build/asm/main_800FA5B4.s.o(.bss); }
    .main_800FA5D0 0x800FA5D0 : AT(0x000FB1D0) { build/asm/data/main_800FA5D0.bin.o(.data); }
    .main_800FB0DC 0x800FB0DC : AT(0x000FBCDC) { FILL(0x00000000); build/asm/main_800FB0DC.s.o(.text); build/asm/main_800FB0DC.s.o(.rodata); build/asm/main_800FB0DC.s.o(.data); }
    .main_800FB0DC_bss (NOLOAD) : { build/asm/main_800FB0DC.s.o(.bss); }
    .main_800FB100 0x800FB100 : AT(0x000FBD00) { build/asm/data/main_800FB100.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
