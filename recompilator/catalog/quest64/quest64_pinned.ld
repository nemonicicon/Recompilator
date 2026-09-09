SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004B0 0x800004B0 : AT(0x000010B0) { FILL(0x00000000); build/asm/main_800004B0.s.o(.text); build/asm/main_800004B0.s.o(.rodata); build/asm/main_800004B0.s.o(.data); }
    .main_800004B0_bss (NOLOAD) : { build/asm/main_800004B0.s.o(.bss); }
    .main_800363E0 0x800363E0 : AT(0x00036FE0) { FILL(0x00000000); build/asm/main_800363E0.s.o(.text); build/asm/main_800363E0.s.o(.rodata); build/asm/main_800363E0.s.o(.data); }
    .main_800363E0_bss (NOLOAD) : { build/asm/main_800363E0.s.o(.bss); }
    .main_80038190 0x80038190 : AT(0x00038D90) { FILL(0x00000000); build/asm/main_80038190.s.o(.text); build/asm/main_80038190.s.o(.rodata); build/asm/main_80038190.s.o(.data); }
    .main_80038190_bss (NOLOAD) : { build/asm/main_80038190.s.o(.bss); }
    .main_800396D4 0x800396D4 : AT(0x0003A2D4) { FILL(0x00000000); build/asm/main_800396D4.s.o(.text); build/asm/main_800396D4.s.o(.rodata); build/asm/main_800396D4.s.o(.data); }
    .main_800396D4_bss (NOLOAD) : { build/asm/main_800396D4.s.o(.bss); }
    .main_8003CFA4 0x8003CFA4 : AT(0x0003DBA4) { FILL(0x00000000); build/asm/main_8003CFA4.s.o(.text); build/asm/main_8003CFA4.s.o(.rodata); build/asm/main_8003CFA4.s.o(.data); }
    .main_8003CFA4_bss (NOLOAD) : { build/asm/main_8003CFA4.s.o(.bss); }
    .main_8003D370 0x8003D370 : AT(0x0003DF70) { FILL(0x00000000); build/asm/main_8003D370.s.o(.text); build/asm/main_8003D370.s.o(.rodata); build/asm/main_8003D370.s.o(.data); }
    .main_8003D370_bss (NOLOAD) : { build/asm/main_8003D370.s.o(.bss); }
    .main_8003D9F0 0x8003D9F0 : AT(0x0003E5F0) { FILL(0x00000000); build/asm/main_8003D9F0.s.o(.text); build/asm/main_8003D9F0.s.o(.rodata); build/asm/main_8003D9F0.s.o(.data); }
    .main_8003D9F0_bss (NOLOAD) : { build/asm/main_8003D9F0.s.o(.bss); }
    .main_8003E0B0 0x8003E0B0 : AT(0x0003ECB0) { FILL(0x00000000); build/asm/main_8003E0B0.s.o(.text); build/asm/main_8003E0B0.s.o(.rodata); build/asm/main_8003E0B0.s.o(.data); }
    .main_8003E0B0_bss (NOLOAD) : { build/asm/main_8003E0B0.s.o(.bss); }
    .main_80040A20 0x80040A20 : AT(0x00041620) { FILL(0x00000000); build/asm/main_80040A20.s.o(.text); build/asm/main_80040A20.s.o(.rodata); build/asm/main_80040A20.s.o(.data); }
    .main_80040A20_bss (NOLOAD) : { build/asm/main_80040A20.s.o(.bss); }
    .main_80040E04 0x80040E04 : AT(0x00041A04) { FILL(0x00000000); build/asm/main_80040E04.s.o(.text); build/asm/main_80040E04.s.o(.rodata); build/asm/main_80040E04.s.o(.data); }
    .main_80040E04_bss (NOLOAD) : { build/asm/main_80040E04.s.o(.bss); }
    .main_80041570 0x80041570 : AT(0x00042170) { FILL(0x00000000); build/asm/main_80041570.s.o(.text); build/asm/main_80041570.s.o(.rodata); build/asm/main_80041570.s.o(.data); }
    .main_80041570_bss (NOLOAD) : { build/asm/main_80041570.s.o(.bss); }
    .main_80041898 0x80041898 : AT(0x00042498) { FILL(0x00000000); build/asm/main_80041898.s.o(.text); build/asm/main_80041898.s.o(.rodata); build/asm/main_80041898.s.o(.data); }
    .main_80041898_bss (NOLOAD) : { build/asm/main_80041898.s.o(.bss); }
    .main_800424D0 0x800424D0 : AT(0x000430D0) { FILL(0x00000000); build/asm/main_800424D0.s.o(.text); build/asm/main_800424D0.s.o(.rodata); build/asm/main_800424D0.s.o(.data); }
    .main_800424D0_bss (NOLOAD) : { build/asm/main_800424D0.s.o(.bss); }
    .main_800425E0 0x800425E0 : AT(0x000431E0) { FILL(0x00000000); build/asm/main_800425E0.s.o(.text); build/asm/main_800425E0.s.o(.rodata); build/asm/main_800425E0.s.o(.data); }
    .main_800425E0_bss (NOLOAD) : { build/asm/main_800425E0.s.o(.bss); }
    .main_800426A0 0x800426A0 : AT(0x000432A0) { FILL(0x00000000); build/asm/main_800426A0.s.o(.text); build/asm/main_800426A0.s.o(.rodata); build/asm/main_800426A0.s.o(.data); }
    .main_800426A0_bss (NOLOAD) : { build/asm/main_800426A0.s.o(.bss); }
    .main_80043D10 0x80043D10 : AT(0x00044910) { FILL(0x00000000); build/asm/main_80043D10.s.o(.text); build/asm/main_80043D10.s.o(.rodata); build/asm/main_80043D10.s.o(.data); }
    .main_80043D10_bss (NOLOAD) : { build/asm/main_80043D10.s.o(.bss); }
    .main_800493D4 0x800493D4 : AT(0x00049FD4) { FILL(0x00000000); build/asm/main_800493D4.s.o(.text); build/asm/main_800493D4.s.o(.rodata); build/asm/main_800493D4.s.o(.data); }
    .main_800493D4_bss (NOLOAD) : { build/asm/main_800493D4.s.o(.bss); }
    .main_8004974C 0x8004974C : AT(0x0004A34C) { FILL(0x00000000); build/asm/main_8004974C.s.o(.text); build/asm/main_8004974C.s.o(.rodata); build/asm/main_8004974C.s.o(.data); }
    .main_8004974C_bss (NOLOAD) : { build/asm/main_8004974C.s.o(.bss); }
    .main_8004CF54 0x8004CF54 : AT(0x0004DB54) { FILL(0x00000000); build/asm/main_8004CF54.s.o(.text); build/asm/main_8004CF54.s.o(.rodata); build/asm/main_8004CF54.s.o(.data); }
    .main_8004CF54_bss (NOLOAD) : { build/asm/main_8004CF54.s.o(.bss); }
    .main_8004D034 0x8004D034 : AT(0x0004DC34) { FILL(0x00000000); build/asm/main_8004D034.s.o(.text); build/asm/main_8004D034.s.o(.rodata); build/asm/main_8004D034.s.o(.data); }
    .main_8004D034_bss (NOLOAD) : { build/asm/main_8004D034.s.o(.bss); }
    .main_8005495C 0x8005495C : AT(0x0005555C) { build/asm/data/main_8005495C.bin.o(.data); }
    .main_800558CC 0x800558CC : AT(0x000564CC) { FILL(0x00000000); build/asm/main_800558CC.s.o(.text); build/asm/main_800558CC.s.o(.rodata); build/asm/main_800558CC.s.o(.data); }
    .main_800558CC_bss (NOLOAD) : { build/asm/main_800558CC.s.o(.bss); }
    .main_800561C0 0x800561C0 : AT(0x00056DC0) { FILL(0x00000000); build/asm/main_800561C0.s.o(.text); build/asm/main_800561C0.s.o(.rodata); build/asm/main_800561C0.s.o(.data); }
    .main_800561C0_bss (NOLOAD) : { build/asm/main_800561C0.s.o(.bss); }
    .main_80056A9C 0x80056A9C : AT(0x0005769C) { build/asm/data/main_80056A9C.bin.o(.data); }
    .main_8005E708 0x8005E708 : AT(0x0005F308) { FILL(0x00000000); build/asm/main_8005E708.s.o(.text); build/asm/main_8005E708.s.o(.rodata); build/asm/main_8005E708.s.o(.data); }
    .main_8005E708_bss (NOLOAD) : { build/asm/main_8005E708.s.o(.bss); }
    .main_80061610 0x80061610 : AT(0x00062210) { build/asm/data/main_80061610.bin.o(.data); }
    .main_80062304 0x80062304 : AT(0x00062F04) { FILL(0x00000000); build/asm/main_80062304.s.o(.text); build/asm/main_80062304.s.o(.rodata); build/asm/main_80062304.s.o(.data); }
    .main_80062304_bss (NOLOAD) : { build/asm/main_80062304.s.o(.bss); }
    .main_8006239C 0x8006239C : AT(0x00062F9C) { build/asm/data/main_8006239C.bin.o(.data); }
    .main_80064004 0x80064004 : AT(0x00064C04) { FILL(0x00000000); build/asm/main_80064004.s.o(.text); build/asm/main_80064004.s.o(.rodata); build/asm/main_80064004.s.o(.data); }
    .main_80064004_bss (NOLOAD) : { build/asm/main_80064004.s.o(.bss); }
    .main_80064274 0x80064274 : AT(0x00064E74) { build/asm/data/main_80064274.bin.o(.data); }
    .main_80065054 0x80065054 : AT(0x00065C54) { build/asm/data/main_80065054.bin.o(.data); }
    .main_8006C2D8 0x8006C2D8 : AT(0x0006CED8) { build/asm/data/main_8006C2D8.bin.o(.data); }
    .main_8006E4B0 0x8006E4B0 : AT(0x0006F0B0) { FILL(0x00000000); build/asm/main_8006E4B0.s.o(.text); build/asm/main_8006E4B0.s.o(.rodata); build/asm/main_8006E4B0.s.o(.data); }
    .main_8006E4B0_bss (NOLOAD) : { build/asm/main_8006E4B0.s.o(.bss); }
    .main_8006EF98 0x8006EF98 : AT(0x0006FB98) { FILL(0x00000000); build/asm/main_8006EF98.s.o(.text); build/asm/main_8006EF98.s.o(.rodata); build/asm/main_8006EF98.s.o(.data); }
    .main_8006EF98_bss (NOLOAD) : { build/asm/main_8006EF98.s.o(.bss); }
    .main_8006F8CC 0x8006F8CC : AT(0x000704CC) { FILL(0x00000000); build/asm/main_8006F8CC.s.o(.text); build/asm/main_8006F8CC.s.o(.rodata); build/asm/main_8006F8CC.s.o(.data); }
    .main_8006F8CC_bss (NOLOAD) : { build/asm/main_8006F8CC.s.o(.bss); }
    .main_8006F8F0 0x8006F8F0 : AT(0x000704F0) { build/asm/data/main_8006F8F0.bin.o(.data); }
    .main_8006FE58 0x8006FE58 : AT(0x00070A58) { FILL(0x00000000); build/asm/main_8006FE58.s.o(.text); build/asm/main_8006FE58.s.o(.rodata); build/asm/main_8006FE58.s.o(.data); }
    .main_8006FE58_bss (NOLOAD) : { build/asm/main_8006FE58.s.o(.bss); }
    .main_80070724 0x80070724 : AT(0x00071324) { build/asm/data/main_80070724.bin.o(.data); }
    .main_800713D0 0x800713D0 : AT(0x00071FD0) { FILL(0x00000000); build/asm/main_800713D0.s.o(.text); build/asm/main_800713D0.s.o(.rodata); build/asm/main_800713D0.s.o(.data); }
    .main_800713D0_bss (NOLOAD) : { build/asm/main_800713D0.s.o(.bss); }
    .main_80071EEC 0x80071EEC : AT(0x00072AEC) { FILL(0x00000000); build/asm/main_80071EEC.s.o(.text); build/asm/main_80071EEC.s.o(.rodata); build/asm/main_80071EEC.s.o(.data); }
    .main_80071EEC_bss (NOLOAD) : { build/asm/main_80071EEC.s.o(.bss); }
    .main_80072C10 0x80072C10 : AT(0x00073810) { build/asm/data/main_80072C10.bin.o(.data); }
    .main_80073860 0x80073860 : AT(0x00074460) { build/asm/data/main_80073860.bin.o(.data); }
    .main_800744C0 0x800744C0 : AT(0x000750C0) { FILL(0x00000000); build/asm/main_800744C0.s.o(.text); build/asm/main_800744C0.s.o(.rodata); build/asm/main_800744C0.s.o(.data); }
    .main_800744C0_bss (NOLOAD) : { build/asm/main_800744C0.s.o(.bss); }
    .main_8007474C 0x8007474C : AT(0x0007534C) { build/asm/data/main_8007474C.bin.o(.data); }
    .main_800764D0 0x800764D0 : AT(0x000770D0) { build/asm/data/main_800764D0.bin.o(.data); }
    .main_80079440 0x80079440 : AT(0x0007A040) { build/asm/data/main_80079440.bin.o(.data); }
    .main_8007BF14 0x8007BF14 : AT(0x0007CB14) { build/asm/data/main_8007BF14.bin.o(.data); }
    .main_8007FB44 0x8007FB44 : AT(0x00080744) { FILL(0x00000000); build/asm/main_8007FB44.s.o(.text); build/asm/main_8007FB44.s.o(.rodata); build/asm/main_8007FB44.s.o(.data); }
    .main_8007FB44_bss (NOLOAD) : { build/asm/main_8007FB44.s.o(.bss); }
    .main_8007FF58 0x8007FF58 : AT(0x00080B58) { build/asm/data/main_8007FF58.bin.o(.data); }
    .main_8007FF84 0x8007FF84 : AT(0x00080B84) { FILL(0x00000000); build/asm/main_8007FF84.s.o(.text); build/asm/main_8007FF84.s.o(.rodata); build/asm/main_8007FF84.s.o(.data); }
    .main_8007FF84_bss (NOLOAD) : { build/asm/main_8007FF84.s.o(.bss); }
    .main_80080054 0x80080054 : AT(0x00080C54) { build/asm/data/main_80080054.bin.o(.data); }
    .main_8008006C 0x8008006C : AT(0x00080C6C) { FILL(0x00000000); build/asm/main_8008006C.s.o(.text); build/asm/main_8008006C.s.o(.rodata); build/asm/main_8008006C.s.o(.data); }
    .main_8008006C_bss (NOLOAD) : { build/asm/main_8008006C.s.o(.bss); }
    .main_800802DC 0x800802DC : AT(0x00080EDC) { build/asm/data/main_800802DC.bin.o(.data); }
    .main_80080344 0x80080344 : AT(0x00080F44) { FILL(0x00000000); build/asm/main_80080344.s.o(.text); build/asm/main_80080344.s.o(.rodata); build/asm/main_80080344.s.o(.data); }
    .main_80080344_bss (NOLOAD) : { build/asm/main_80080344.s.o(.bss); }
    .main_80080348 0x80080348 : AT(0x00080F48) { build/asm/data/main_80080348.bin.o(.data); }
    .main_800803D0 0x800803D0 : AT(0x00080FD0) { FILL(0x00000000); build/asm/main_800803D0.s.o(.text); build/asm/main_800803D0.s.o(.rodata); build/asm/main_800803D0.s.o(.data); }
    .main_800803D0_bss (NOLOAD) : { build/asm/main_800803D0.s.o(.bss); }
    .main_80080460 0x80080460 : AT(0x00081060) { build/asm/data/main_80080460.bin.o(.data); }
    .main_800804C4 0x800804C4 : AT(0x000810C4) { FILL(0x00000000); build/asm/main_800804C4.s.o(.text); build/asm/main_800804C4.s.o(.rodata); build/asm/main_800804C4.s.o(.data); }
    .main_800804C4_bss (NOLOAD) : { build/asm/main_800804C4.s.o(.bss); }
    .main_800807A4 0x800807A4 : AT(0x000813A4) { build/asm/data/main_800807A4.bin.o(.data); }
    .main_800807F4 0x800807F4 : AT(0x000813F4) { FILL(0x00000000); build/asm/main_800807F4.s.o(.text); build/asm/main_800807F4.s.o(.rodata); build/asm/main_800807F4.s.o(.data); }
    .main_800807F4_bss (NOLOAD) : { build/asm/main_800807F4.s.o(.bss); }
    .main_80080858 0x80080858 : AT(0x00081458) { build/asm/data/main_80080858.bin.o(.data); }
    .main_80080904 0x80080904 : AT(0x00081504) { FILL(0x00000000); build/asm/main_80080904.s.o(.text); build/asm/main_80080904.s.o(.rodata); build/asm/main_80080904.s.o(.data); }
    .main_80080904_bss (NOLOAD) : { build/asm/main_80080904.s.o(.bss); }
    .main_80080960 0x80080960 : AT(0x00081560) { build/asm/data/main_80080960.bin.o(.data); }
    .main_800809F8 0x800809F8 : AT(0x000815F8) { FILL(0x00000000); build/asm/main_800809F8.s.o(.text); build/asm/main_800809F8.s.o(.rodata); build/asm/main_800809F8.s.o(.data); }
    .main_800809F8_bss (NOLOAD) : { build/asm/main_800809F8.s.o(.bss); }
    .main_80080A24 0x80080A24 : AT(0x00081624) { build/asm/data/main_80080A24.bin.o(.data); }
    .main_80080A40 0x80080A40 : AT(0x00081640) { FILL(0x00000000); build/asm/main_80080A40.s.o(.text); build/asm/main_80080A40.s.o(.rodata); build/asm/main_80080A40.s.o(.data); }
    .main_80080A40_bss (NOLOAD) : { build/asm/main_80080A40.s.o(.bss); }
    .main_80080A5C 0x80080A5C : AT(0x0008165C) { build/asm/data/main_80080A5C.bin.o(.data); }
    .main_8008101C 0x8008101C : AT(0x00081C1C) { FILL(0x00000000); build/asm/main_8008101C.s.o(.text); build/asm/main_8008101C.s.o(.rodata); build/asm/main_8008101C.s.o(.data); }
    .main_8008101C_bss (NOLOAD) : { build/asm/main_8008101C.s.o(.bss); }
    .main_800810A8 0x800810A8 : AT(0x00081CA8) { build/asm/data/main_800810A8.bin.o(.data); }
    .main_800811E8 0x800811E8 : AT(0x00081DE8) { FILL(0x00000000); build/asm/main_800811E8.s.o(.text); build/asm/main_800811E8.s.o(.rodata); build/asm/main_800811E8.s.o(.data); }
    .main_800811E8_bss (NOLOAD) : { build/asm/main_800811E8.s.o(.bss); }
    .main_80081230 0x80081230 : AT(0x00081E30) { build/asm/data/main_80081230.bin.o(.data); }
    .main_800812FC 0x800812FC : AT(0x00081EFC) { FILL(0x00000000); build/asm/main_800812FC.s.o(.text); build/asm/main_800812FC.s.o(.rodata); build/asm/main_800812FC.s.o(.data); }
    .main_800812FC_bss (NOLOAD) : { build/asm/main_800812FC.s.o(.bss); }
    .main_80081368 0x80081368 : AT(0x00081F68) { build/asm/data/main_80081368.bin.o(.data); }
    .main_800813A0 0x800813A0 : AT(0x00081FA0) { FILL(0x00000000); build/asm/main_800813A0.s.o(.text); build/asm/main_800813A0.s.o(.rodata); build/asm/main_800813A0.s.o(.data); }
    .main_800813A0_bss (NOLOAD) : { build/asm/main_800813A0.s.o(.bss); }
    .main_800813E0 0x800813E0 : AT(0x00081FE0) { build/asm/data/main_800813E0.bin.o(.data); }
    .main_80081568 0x80081568 : AT(0x00082168) { build/asm/data/main_80081568.bin.o(.data); }
    .main_8008159C 0x8008159C : AT(0x0008219C) { FILL(0x00000000); build/asm/main_8008159C.s.o(.text); build/asm/main_8008159C.s.o(.rodata); build/asm/main_8008159C.s.o(.data); }
    .main_8008159C_bss (NOLOAD) : { build/asm/main_8008159C.s.o(.bss); }
    .main_800815B0 0x800815B0 : AT(0x000821B0) { build/asm/data/main_800815B0.bin.o(.data); }
    .main_800816D4 0x800816D4 : AT(0x000822D4) { FILL(0x00000000); build/asm/main_800816D4.s.o(.text); build/asm/main_800816D4.s.o(.rodata); build/asm/main_800816D4.s.o(.data); }
    .main_800816D4_bss (NOLOAD) : { build/asm/main_800816D4.s.o(.bss); }
    .main_8008171C 0x8008171C : AT(0x0008231C) { build/asm/data/main_8008171C.bin.o(.data); }
    .main_80081760 0x80081760 : AT(0x00082360) { FILL(0x00000000); build/asm/main_80081760.s.o(.text); build/asm/main_80081760.s.o(.rodata); build/asm/main_80081760.s.o(.data); }
    .main_80081760_bss (NOLOAD) : { build/asm/main_80081760.s.o(.bss); }
    .main_8008176C 0x8008176C : AT(0x0008236C) { build/asm/data/main_8008176C.bin.o(.data); }
    .main_80081918 0x80081918 : AT(0x00082518) { FILL(0x00000000); build/asm/main_80081918.s.o(.text); build/asm/main_80081918.s.o(.rodata); build/asm/main_80081918.s.o(.data); }
    .main_80081918_bss (NOLOAD) : { build/asm/main_80081918.s.o(.bss); }
    .main_80081924 0x80081924 : AT(0x00082524) { build/asm/data/main_80081924.bin.o(.data); }
    .main_80081A28 0x80081A28 : AT(0x00082628) { FILL(0x00000000); build/asm/main_80081A28.s.o(.text); build/asm/main_80081A28.s.o(.rodata); build/asm/main_80081A28.s.o(.data); }
    .main_80081A28_bss (NOLOAD) : { build/asm/main_80081A28.s.o(.bss); }
    .main_80081A30 0x80081A30 : AT(0x00082630) { build/asm/data/main_80081A30.bin.o(.data); }
    .main_80081C08 0x80081C08 : AT(0x00082808) { FILL(0x00000000); build/asm/main_80081C08.s.o(.text); build/asm/main_80081C08.s.o(.rodata); build/asm/main_80081C08.s.o(.data); }
    .main_80081C08_bss (NOLOAD) : { build/asm/main_80081C08.s.o(.bss); }
    .main_80081D3C 0x80081D3C : AT(0x0008293C) { build/asm/data/main_80081D3C.bin.o(.data); }
    .main_80081DF8 0x80081DF8 : AT(0x000829F8) { FILL(0x00000000); build/asm/main_80081DF8.s.o(.text); build/asm/main_80081DF8.s.o(.rodata); build/asm/main_80081DF8.s.o(.data); }
    .main_80081DF8_bss (NOLOAD) : { build/asm/main_80081DF8.s.o(.bss); }
    .main_8008210C 0x8008210C : AT(0x00082D0C) { FILL(0x00000000); build/asm/main_8008210C.s.o(.text); build/asm/main_8008210C.s.o(.rodata); build/asm/main_8008210C.s.o(.data); }
    .main_8008210C_bss (NOLOAD) : { build/asm/main_8008210C.s.o(.bss); }
    .main_80082704 0x80082704 : AT(0x00083304) { FILL(0x00000000); build/asm/main_80082704.s.o(.text); build/asm/main_80082704.s.o(.rodata); build/asm/main_80082704.s.o(.data); }
    .main_80082704_bss (NOLOAD) : { build/asm/main_80082704.s.o(.bss); }
    .main_800827A8 0x800827A8 : AT(0x000833A8) { FILL(0x00000000); build/asm/main_800827A8.s.o(.text); build/asm/main_800827A8.s.o(.rodata); build/asm/main_800827A8.s.o(.data); }
    .main_800827A8_bss (NOLOAD) : { build/asm/main_800827A8.s.o(.bss); }
    .main_80082D60 0x80082D60 : AT(0x00083960) { FILL(0x00000000); build/asm/main_80082D60.s.o(.text); build/asm/main_80082D60.s.o(.rodata); build/asm/main_80082D60.s.o(.data); }
    .main_80082D60_bss (NOLOAD) : { build/asm/main_80082D60.s.o(.bss); }
    .main_80082D90 0x80082D90 : AT(0x00083990) { build/asm/data/main_80082D90.bin.o(.data); }
    .main_80083260 0x80083260 : AT(0x00083E60) { FILL(0x00000000); build/asm/main_80083260.s.o(.text); build/asm/main_80083260.s.o(.rodata); build/asm/main_80083260.s.o(.data); }
    .main_80083260_bss (NOLOAD) : { build/asm/main_80083260.s.o(.bss); }
    .main_800834B8 0x800834B8 : AT(0x000840B8) { build/asm/data/main_800834B8.bin.o(.data); }
    .main_800836B0 0x800836B0 : AT(0x000842B0) { FILL(0x00000000); build/asm/main_800836B0.s.o(.text); build/asm/main_800836B0.s.o(.rodata); build/asm/main_800836B0.s.o(.data); }
    .main_800836B0_bss (NOLOAD) : { build/asm/main_800836B0.s.o(.bss); }
    .main_800838DC 0x800838DC : AT(0x000844DC) { FILL(0x00000000); build/asm/main_800838DC.s.o(.text); build/asm/main_800838DC.s.o(.rodata); build/asm/main_800838DC.s.o(.data); }
    .main_800838DC_bss (NOLOAD) : { build/asm/main_800838DC.s.o(.bss); }
    .main_80083EF0 0x80083EF0 : AT(0x00084AF0) { FILL(0x00000000); build/asm/main_80083EF0.s.o(.text); build/asm/main_80083EF0.s.o(.rodata); build/asm/main_80083EF0.s.o(.data); }
    .main_80083EF0_bss (NOLOAD) : { build/asm/main_80083EF0.s.o(.bss); }
    .main_80083F38 0x80083F38 : AT(0x00084B38) { build/asm/data/main_80083F38.bin.o(.data); }
    .main_80084178 0x80084178 : AT(0x00084D78) { FILL(0x00000000); build/asm/main_80084178.s.o(.text); build/asm/main_80084178.s.o(.rodata); build/asm/main_80084178.s.o(.data); }
    .main_80084178_bss (NOLOAD) : { build/asm/main_80084178.s.o(.bss); }
    .main_800841C0 0x800841C0 : AT(0x00084DC0) { FILL(0x00000000); build/asm/main_800841C0.s.o(.text); build/asm/main_800841C0.s.o(.rodata); build/asm/main_800841C0.s.o(.data); }
    .main_800841C0_bss (NOLOAD) : { build/asm/main_800841C0.s.o(.bss); }
    .main_800841F8 0x800841F8 : AT(0x00084DF8) { build/asm/data/main_800841F8.bin.o(.data); }
    .main_80084388 0x80084388 : AT(0x00084F88) { FILL(0x00000000); build/asm/main_80084388.s.o(.text); build/asm/main_80084388.s.o(.rodata); build/asm/main_80084388.s.o(.data); }
    .main_80084388_bss (NOLOAD) : { build/asm/main_80084388.s.o(.bss); }
    .main_80084398 0x80084398 : AT(0x00084F98) { build/asm/data/main_80084398.bin.o(.data); }
    .main_800843C8 0x800843C8 : AT(0x00084FC8) { FILL(0x00000000); build/asm/main_800843C8.s.o(.text); build/asm/main_800843C8.s.o(.rodata); build/asm/main_800843C8.s.o(.data); }
    .main_800843C8_bss (NOLOAD) : { build/asm/main_800843C8.s.o(.bss); }
    .main_800843D8 0x800843D8 : AT(0x00084FD8) { build/asm/data/main_800843D8.bin.o(.data); }
    .main_800846E8 0x800846E8 : AT(0x000852E8) { FILL(0x00000000); build/asm/main_800846E8.s.o(.text); build/asm/main_800846E8.s.o(.rodata); build/asm/main_800846E8.s.o(.data); }
    .main_800846E8_bss (NOLOAD) : { build/asm/main_800846E8.s.o(.bss); }
    .main_800846F8 0x800846F8 : AT(0x000852F8) { build/asm/data/main_800846F8.bin.o(.data); }
    .main_80084768 0x80084768 : AT(0x00085368) { FILL(0x00000000); build/asm/main_80084768.s.o(.text); build/asm/main_80084768.s.o(.rodata); build/asm/main_80084768.s.o(.data); }
    .main_80084768_bss (NOLOAD) : { build/asm/main_80084768.s.o(.bss); }
    .main_80084778 0x80084778 : AT(0x00085378) { build/asm/data/main_80084778.bin.o(.data); }
    .main_8008524C 0x8008524C : AT(0x00085E4C) { build/asm/data/main_8008524C.bin.o(.data); }
    .main_80085B78 0x80085B78 : AT(0x00086778) { FILL(0x00000000); build/asm/main_80085B78.s.o(.text); build/asm/main_80085B78.s.o(.rodata); build/asm/main_80085B78.s.o(.data); }
    .main_80085B78_bss (NOLOAD) : { build/asm/main_80085B78.s.o(.bss); }
    .main_80085BB8 0x80085BB8 : AT(0x000867B8) { FILL(0x00000000); build/asm/main_80085BB8.s.o(.text); build/asm/main_80085BB8.s.o(.rodata); build/asm/main_80085BB8.s.o(.data); }
    .main_80085BB8_bss (NOLOAD) : { build/asm/main_80085BB8.s.o(.bss); }
    .main_800875A8 0x800875A8 : AT(0x000881A8) { FILL(0x00000000); build/asm/main_800875A8.s.o(.text); build/asm/main_800875A8.s.o(.rodata); build/asm/main_800875A8.s.o(.data); }
    .main_800875A8_bss (NOLOAD) : { build/asm/main_800875A8.s.o(.bss); }
    .main_80089D08 0x80089D08 : AT(0x0008A908) { FILL(0x00000000); build/asm/main_80089D08.s.o(.text); build/asm/main_80089D08.s.o(.rodata); build/asm/main_80089D08.s.o(.data); }
    .main_80089D08_bss (NOLOAD) : { build/asm/main_80089D08.s.o(.bss); }
    .main_8008B808 0x8008B808 : AT(0x0008C408) { build/asm/data/main_8008B808.bin.o(.data); }
    .main_8008E1EC 0x8008E1EC : AT(0x0008EDEC) { build/asm/data/main_8008E1EC.bin.o(.data); }
    .main_8009BA74 0x8009BA74 : AT(0x0009C674) { build/asm/data/main_8009BA74.bin.o(.data); }
    .main_800ABCA0 0x800ABCA0 : AT(0x000AC8A0) { FILL(0x00000000); build/asm/main_800ABCA0.s.o(.text); build/asm/main_800ABCA0.s.o(.rodata); build/asm/main_800ABCA0.s.o(.data); }
    .main_800ABCA0_bss (NOLOAD) : { build/asm/main_800ABCA0.s.o(.bss); }
    .main_800ABDF4 0x800ABDF4 : AT(0x000AC9F4) { build/asm/data/main_800ABDF4.bin.o(.data); }
    .main_800AD8C0 0x800AD8C0 : AT(0x000AE4C0) { FILL(0x00000000); build/asm/main_800AD8C0.s.o(.text); build/asm/main_800AD8C0.s.o(.rodata); build/asm/main_800AD8C0.s.o(.data); }
    .main_800AD8C0_bss (NOLOAD) : { build/asm/main_800AD8C0.s.o(.bss); }
    .main_800AE064 0x800AE064 : AT(0x000AEC64) { build/asm/data/main_800AE064.bin.o(.data); }
    .main_800B2BAC 0x800B2BAC : AT(0x000B37AC) { FILL(0x00000000); build/asm/main_800B2BAC.s.o(.text); build/asm/main_800B2BAC.s.o(.rodata); build/asm/main_800B2BAC.s.o(.data); }
    .main_800B2BAC_bss (NOLOAD) : { build/asm/main_800B2BAC.s.o(.bss); }
    .main_800B2C60 0x800B2C60 : AT(0x000B3860) { build/asm/data/main_800B2C60.bin.o(.data); }
    .main_800B6840 0x800B6840 : AT(0x000B7440) { FILL(0x00000000); build/asm/main_800B6840.s.o(.text); build/asm/main_800B6840.s.o(.rodata); build/asm/main_800B6840.s.o(.data); }
    .main_800B6840_bss (NOLOAD) : { build/asm/main_800B6840.s.o(.bss); }
    .main_800B6BC0 0x800B6BC0 : AT(0x000B77C0) { build/asm/data/main_800B6BC0.bin.o(.data); }
    .main_800B9FE4 0x800B9FE4 : AT(0x000BABE4) { FILL(0x00000000); build/asm/main_800B9FE4.s.o(.text); build/asm/main_800B9FE4.s.o(.rodata); build/asm/main_800B9FE4.s.o(.data); }
    .main_800B9FE4_bss (NOLOAD) : { build/asm/main_800B9FE4.s.o(.bss); }
    .main_800BA3B8 0x800BA3B8 : AT(0x000BAFB8) { build/asm/data/main_800BA3B8.bin.o(.data); }
    .main_800BFC4C 0x800BFC4C : AT(0x000C084C) { FILL(0x00000000); build/asm/main_800BFC4C.s.o(.text); build/asm/main_800BFC4C.s.o(.rodata); build/asm/main_800BFC4C.s.o(.data); }
    .main_800BFC4C_bss (NOLOAD) : { build/asm/main_800BFC4C.s.o(.bss); }
    .main_800C0C6C 0x800C0C6C : AT(0x000C186C) { FILL(0x00000000); build/asm/main_800C0C6C.s.o(.text); build/asm/main_800C0C6C.s.o(.rodata); build/asm/main_800C0C6C.s.o(.data); }
    .main_800C0C6C_bss (NOLOAD) : { build/asm/main_800C0C6C.s.o(.bss); }
    .main_800C38E8 0x800C38E8 : AT(0x000C44E8) { FILL(0x00000000); build/asm/main_800C38E8.s.o(.text); build/asm/main_800C38E8.s.o(.rodata); build/asm/main_800C38E8.s.o(.data); }
    .main_800C38E8_bss (NOLOAD) : { build/asm/main_800C38E8.s.o(.bss); }
    .main_800C3DD0 0x800C3DD0 : AT(0x000C49D0) { build/asm/data/main_800C3DD0.bin.o(.data); }
    .main_800C4270 0x800C4270 : AT(0x000C4E70) { FILL(0x00000000); build/asm/main_800C4270.s.o(.text); build/asm/main_800C4270.s.o(.rodata); build/asm/main_800C4270.s.o(.data); }
    .main_800C4270_bss (NOLOAD) : { build/asm/main_800C4270.s.o(.bss); }
    .main_800C42B0 0x800C42B0 : AT(0x000C4EB0) { build/asm/data/main_800C42B0.bin.o(.data); }
    .main_800C4880 0x800C4880 : AT(0x000C5480) { build/asm/data/main_800C4880.bin.o(.data); }
    .main_800C4BBC 0x800C4BBC : AT(0x000C57BC) { FILL(0x00000000); build/asm/main_800C4BBC.s.o(.text); build/asm/main_800C4BBC.s.o(.rodata); build/asm/main_800C4BBC.s.o(.data); }
    .main_800C4BBC_bss (NOLOAD) : { build/asm/main_800C4BBC.s.o(.bss); }
    .main_800C50A0 0x800C50A0 : AT(0x000C5CA0) { build/asm/data/main_800C50A0.bin.o(.data); }
    .main_800CB8B8 0x800CB8B8 : AT(0x000CC4B8) { build/asm/data/main_800CB8B8.bin.o(.data); }
    .main_800D13F0 0x800D13F0 : AT(0x000D1FF0) { FILL(0x00000000); build/asm/main_800D13F0.s.o(.text); build/asm/main_800D13F0.s.o(.rodata); build/asm/main_800D13F0.s.o(.data); }
    .main_800D13F0_bss (NOLOAD) : { build/asm/main_800D13F0.s.o(.bss); }
    .main_800D14C8 0x800D14C8 : AT(0x000D20C8) { build/asm/data/main_800D14C8.bin.o(.data); }
    .main_800EA34C 0x800EA34C : AT(0x000EAF4C) { build/asm/data/main_800EA34C.bin.o(.data); }
    .main_800EBD5C 0x800EBD5C : AT(0x000EC95C) { build/asm/data/main_800EBD5C.bin.o(.data); }
    .main_800F114C 0x800F114C : AT(0x000F1D4C) { FILL(0x00000000); build/asm/main_800F114C.s.o(.text); build/asm/main_800F114C.s.o(.rodata); build/asm/main_800F114C.s.o(.data); }
    .main_800F114C_bss (NOLOAD) : { build/asm/main_800F114C.s.o(.bss); }
    .main_800F118C 0x800F118C : AT(0x000F1D8C) { build/asm/data/main_800F118C.bin.o(.data); }
    .main_800F3648 0x800F3648 : AT(0x000F4248) { FILL(0x00000000); build/asm/main_800F3648.s.o(.text); build/asm/main_800F3648.s.o(.rodata); build/asm/main_800F3648.s.o(.data); }
    .main_800F3648_bss (NOLOAD) : { build/asm/main_800F3648.s.o(.bss); }
    .main_800F3848 0x800F3848 : AT(0x000F4448) { build/asm/data/main_800F3848.bin.o(.data); }
    .main_800F5638 0x800F5638 : AT(0x000F6238) { FILL(0x00000000); build/asm/main_800F5638.s.o(.text); build/asm/main_800F5638.s.o(.rodata); build/asm/main_800F5638.s.o(.data); }
    .main_800F5638_bss (NOLOAD) : { build/asm/main_800F5638.s.o(.bss); }
    .main_800F5838 0x800F5838 : AT(0x000F6438) { build/asm/data/main_800F5838.bin.o(.data); }
    .main_800FEDCC 0x800FEDCC : AT(0x000FF9CC) { FILL(0x00000000); build/asm/main_800FEDCC.s.o(.text); build/asm/main_800FEDCC.s.o(.rodata); build/asm/main_800FEDCC.s.o(.data); }
    .main_800FEDCC_bss (NOLOAD) : { build/asm/main_800FEDCC.s.o(.bss); }
    .main_800FEE14 0x800FEE14 : AT(0x000FFA14) { build/asm/data/main_800FEE14.bin.o(.data); }
    .main_80100000 0x80100000 : AT(0x00100C00) { FILL(0x00000000); build/asm/main_80100000.s.o(.text); build/asm/main_80100000.s.o(.rodata); build/asm/main_80100000.s.o(.data); }
    .main_80100000_bss (NOLOAD) : { build/asm/main_80100000.s.o(.bss); }
    .main_8010004C 0x8010004C : AT(0x00100C4C) { FILL(0x00000000); build/asm/main_8010004C.s.o(.text); build/asm/main_8010004C.s.o(.rodata); build/asm/main_8010004C.s.o(.data); }
    .main_8010004C_bss (NOLOAD) : { build/asm/main_8010004C.s.o(.bss); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
