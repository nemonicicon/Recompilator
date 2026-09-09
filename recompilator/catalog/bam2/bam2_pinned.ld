SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000564 0x80000564 : AT(0x00001164) { FILL(0x00000000); build/asm/main_80000564.s.o(.text); build/asm/main_80000564.s.o(.rodata); build/asm/main_80000564.s.o(.data); }
    .main_80000564_bss (NOLOAD) : { build/asm/main_80000564.s.o(.bss); }
    .main_8000056C 0x8000056C : AT(0x0000116C) { build/asm/data/main_8000056C.bin.o(.data); }
    .main_80000584 0x80000584 : AT(0x00001184) { FILL(0x00000000); build/asm/main_80000584.s.o(.text); build/asm/main_80000584.s.o(.rodata); build/asm/main_80000584.s.o(.data); }
    .main_80000584_bss (NOLOAD) : { build/asm/main_80000584.s.o(.bss); }
    .main_80000588 0x80000588 : AT(0x00001188) { build/asm/data/main_80000588.bin.o(.data); }
    .main_8000071C 0x8000071C : AT(0x0000131C) { FILL(0x00000000); build/asm/main_8000071C.s.o(.text); build/asm/main_8000071C.s.o(.rodata); build/asm/main_8000071C.s.o(.data); }
    .main_8000071C_bss (NOLOAD) : { build/asm/main_8000071C.s.o(.bss); }
    .main_80000750 0x80000750 : AT(0x00001350) { build/asm/data/main_80000750.bin.o(.data); }
    .main_80000940 0x80000940 : AT(0x00001540) { FILL(0x00000000); build/asm/main_80000940.s.o(.text); build/asm/main_80000940.s.o(.rodata); build/asm/main_80000940.s.o(.data); }
    .main_80000940_bss (NOLOAD) : { build/asm/main_80000940.s.o(.bss); }
    .main_80000968 0x80000968 : AT(0x00001568) { build/asm/data/main_80000968.bin.o(.data); }
    .main_800012E4 0x800012E4 : AT(0x00001EE4) { FILL(0x00000000); build/asm/main_800012E4.s.o(.text); build/asm/main_800012E4.s.o(.rodata); build/asm/main_800012E4.s.o(.data); }
    .main_800012E4_bss (NOLOAD) : { build/asm/main_800012E4.s.o(.bss); }
    .main_80001300 0x80001300 : AT(0x00001F00) { build/asm/data/main_80001300.bin.o(.data); }
    .main_800018EC 0x800018EC : AT(0x000024EC) { FILL(0x00000000); build/asm/main_800018EC.s.o(.text); build/asm/main_800018EC.s.o(.rodata); build/asm/main_800018EC.s.o(.data); }
    .main_800018EC_bss (NOLOAD) : { build/asm/main_800018EC.s.o(.bss); }
    .main_80001EF4 0x80001EF4 : AT(0x00002AF4) { build/asm/data/main_80001EF4.bin.o(.data); }
    .main_80002EDC 0x80002EDC : AT(0x00003ADC) { FILL(0x00000000); build/asm/main_80002EDC.s.o(.text); build/asm/main_80002EDC.s.o(.rodata); build/asm/main_80002EDC.s.o(.data); }
    .main_80002EDC_bss (NOLOAD) : { build/asm/main_80002EDC.s.o(.bss); }
    .main_80002EFC 0x80002EFC : AT(0x00003AFC) { build/asm/data/main_80002EFC.bin.o(.data); }
    .main_800030E0 0x800030E0 : AT(0x00003CE0) { FILL(0x00000000); build/asm/main_800030E0.s.o(.text); build/asm/main_800030E0.s.o(.rodata); build/asm/main_800030E0.s.o(.data); }
    .main_800030E0_bss (NOLOAD) : { build/asm/main_800030E0.s.o(.bss); }
    .main_80003100 0x80003100 : AT(0x00003D00) { build/asm/data/main_80003100.bin.o(.data); }
    .main_80003920 0x80003920 : AT(0x00004520) { FILL(0x00000000); build/asm/main_80003920.s.o(.text); build/asm/main_80003920.s.o(.rodata); build/asm/main_80003920.s.o(.data); }
    .main_80003920_bss (NOLOAD) : { build/asm/main_80003920.s.o(.bss); }
    .main_80032668 0x80032668 : AT(0x00033268) { build/asm/data/main_80032668.bin.o(.data); }
    .main_80032700 0x80032700 : AT(0x00033300) { FILL(0x00000000); build/asm/main_80032700.s.o(.text); build/asm/main_80032700.s.o(.rodata); build/asm/main_80032700.s.o(.data); }
    .main_80032700_bss (NOLOAD) : { build/asm/main_80032700.s.o(.bss); }
    .main_8003673C 0x8003673C : AT(0x0003733C) { build/asm/data/main_8003673C.bin.o(.data); }
    .main_800367E8 0x800367E8 : AT(0x000373E8) { FILL(0x00000000); build/asm/main_800367E8.s.o(.text); build/asm/main_800367E8.s.o(.rodata); build/asm/main_800367E8.s.o(.data); }
    .main_800367E8_bss (NOLOAD) : { build/asm/main_800367E8.s.o(.bss); }
    .main_80042480 0x80042480 : AT(0x00043080) { build/asm/data/main_80042480.bin.o(.data); }
    .main_800424D0 0x800424D0 : AT(0x000430D0) { FILL(0x00000000); build/asm/main_800424D0.s.o(.text); build/asm/main_800424D0.s.o(.rodata); build/asm/main_800424D0.s.o(.data); }
    .main_800424D0_bss (NOLOAD) : { build/asm/main_800424D0.s.o(.bss); }
    .main_80049044 0x80049044 : AT(0x00049C44) { build/asm/data/main_80049044.bin.o(.data); }
    .main_80049070 0x80049070 : AT(0x00049C70) { FILL(0x00000000); build/asm/main_80049070.s.o(.text); build/asm/main_80049070.s.o(.rodata); build/asm/main_80049070.s.o(.data); }
    .main_80049070_bss (NOLOAD) : { build/asm/main_80049070.s.o(.bss); }
    .main_8004C3B8 0x8004C3B8 : AT(0x0004CFB8) { build/asm/data/main_8004C3B8.bin.o(.data); }
    .main_8004C558 0x8004C558 : AT(0x0004D158) { FILL(0x00000000); build/asm/main_8004C558.s.o(.text); build/asm/main_8004C558.s.o(.rodata); build/asm/main_8004C558.s.o(.data); }
    .main_8004C558_bss (NOLOAD) : { build/asm/main_8004C558.s.o(.bss); }
    .main_800553E4 0x800553E4 : AT(0x00055FE4) { build/asm/data/main_800553E4.bin.o(.data); }
    .main_80055450 0x80055450 : AT(0x00056050) { FILL(0x00000000); build/asm/main_80055450.s.o(.text); build/asm/main_80055450.s.o(.rodata); build/asm/main_80055450.s.o(.data); }
    .main_80055450_bss (NOLOAD) : { build/asm/main_80055450.s.o(.bss); }
    .main_800554D4 0x800554D4 : AT(0x000560D4) { build/asm/data/main_800554D4.bin.o(.data); }
    .main_80055510 0x80055510 : AT(0x00056110) { FILL(0x00000000); build/asm/main_80055510.s.o(.text); build/asm/main_80055510.s.o(.rodata); build/asm/main_80055510.s.o(.data); }
    .main_80055510_bss (NOLOAD) : { build/asm/main_80055510.s.o(.bss); }
    .main_800569E8 0x800569E8 : AT(0x000575E8) { build/asm/data/main_800569E8.bin.o(.data); }
    .main_80058DB0 0x80058DB0 : AT(0x000599B0) { FILL(0x00000000); build/asm/main_80058DB0.s.o(.text); build/asm/main_80058DB0.s.o(.rodata); build/asm/main_80058DB0.s.o(.data); }
    .main_80058DB0_bss (NOLOAD) : { build/asm/main_80058DB0.s.o(.bss); }
    .main_80059BC0 0x80059BC0 : AT(0x0005A7C0) { build/asm/data/main_80059BC0.bin.o(.data); }
    .main_80059EC0 0x80059EC0 : AT(0x0005AAC0) { FILL(0x00000000); build/asm/main_80059EC0.s.o(.text); build/asm/main_80059EC0.s.o(.rodata); build/asm/main_80059EC0.s.o(.data); }
    .main_80059EC0_bss (NOLOAD) : { build/asm/main_80059EC0.s.o(.bss); }
    .main_800622B4 0x800622B4 : AT(0x00062EB4) { build/asm/data/main_800622B4.bin.o(.data); }
    .main_800623E8 0x800623E8 : AT(0x00062FE8) { FILL(0x00000000); build/asm/main_800623E8.s.o(.text); build/asm/main_800623E8.s.o(.rodata); build/asm/main_800623E8.s.o(.data); }
    .main_800623E8_bss (NOLOAD) : { build/asm/main_800623E8.s.o(.bss); }
    .main_8007B440 0x8007B440 : AT(0x0007C040) { build/asm/data/main_8007B440.bin.o(.data); }
    .main_80080214 0x80080214 : AT(0x00080E14) { FILL(0x00000000); build/asm/main_80080214.s.o(.text); build/asm/main_80080214.s.o(.rodata); build/asm/main_80080214.s.o(.data); }
    .main_80080214_bss (NOLOAD) : { build/asm/main_80080214.s.o(.bss); }
    .main_80080720 0x80080720 : AT(0x00081320) { build/asm/data/main_80080720.bin.o(.data); }
    .main_80080908 0x80080908 : AT(0x00081508) { FILL(0x00000000); build/asm/main_80080908.s.o(.text); build/asm/main_80080908.s.o(.rodata); build/asm/main_80080908.s.o(.data); }
    .main_80080908_bss (NOLOAD) : { build/asm/main_80080908.s.o(.bss); }
    .main_80080924 0x80080924 : AT(0x00081524) { build/asm/data/main_80080924.bin.o(.data); }
    .main_80080B00 0x80080B00 : AT(0x00081700) { FILL(0x00000000); build/asm/main_80080B00.s.o(.text); build/asm/main_80080B00.s.o(.rodata); build/asm/main_80080B00.s.o(.data); }
    .main_80080B00_bss (NOLOAD) : { build/asm/main_80080B00.s.o(.bss); }
    .main_80080B04 0x80080B04 : AT(0x00081704) { build/asm/data/main_80080B04.bin.o(.data); }
    .main_80080D04 0x80080D04 : AT(0x00081904) { FILL(0x00000000); build/asm/main_80080D04.s.o(.text); build/asm/main_80080D04.s.o(.rodata); build/asm/main_80080D04.s.o(.data); }
    .main_80080D04_bss (NOLOAD) : { build/asm/main_80080D04.s.o(.bss); }
    .main_80080D20 0x80080D20 : AT(0x00081920) { build/asm/data/main_80080D20.bin.o(.data); }
    .main_80080F1C 0x80080F1C : AT(0x00081B1C) { FILL(0x00000000); build/asm/main_80080F1C.s.o(.text); build/asm/main_80080F1C.s.o(.rodata); build/asm/main_80080F1C.s.o(.data); }
    .main_80080F1C_bss (NOLOAD) : { build/asm/main_80080F1C.s.o(.bss); }
    .main_80080FF4 0x80080FF4 : AT(0x00081BF4) { build/asm/data/main_80080FF4.bin.o(.data); }
    .main_800810E8 0x800810E8 : AT(0x00081CE8) { FILL(0x00000000); build/asm/main_800810E8.s.o(.text); build/asm/main_800810E8.s.o(.rodata); build/asm/main_800810E8.s.o(.data); }
    .main_800810E8_bss (NOLOAD) : { build/asm/main_800810E8.s.o(.bss); }
    .main_8008110C 0x8008110C : AT(0x00081D0C) { build/asm/data/main_8008110C.bin.o(.data); }
    .main_80081910 0x80081910 : AT(0x00082510) { FILL(0x00000000); build/asm/main_80081910.s.o(.text); build/asm/main_80081910.s.o(.rodata); build/asm/main_80081910.s.o(.data); }
    .main_80081910_bss (NOLOAD) : { build/asm/main_80081910.s.o(.bss); }
    .main_8008A800 0x8008A800 : AT(0x0008B400) { build/asm/data/main_8008A800.bin.o(.data); }
    .main_80093820 0x80093820 : AT(0x00094420) { FILL(0x00000000); build/asm/main_80093820.s.o(.text); build/asm/main_80093820.s.o(.rodata); build/asm/main_80093820.s.o(.data); }
    .main_80093820_bss (NOLOAD) : { build/asm/main_80093820.s.o(.bss); }
    .main_80094018 0x80094018 : AT(0x00094C18) { build/asm/data/main_80094018.bin.o(.data); }
    .main_800977E4 0x800977E4 : AT(0x000983E4) { FILL(0x00000000); build/asm/main_800977E4.s.o(.text); build/asm/main_800977E4.s.o(.rodata); build/asm/main_800977E4.s.o(.data); }
    .main_800977E4_bss (NOLOAD) : { build/asm/main_800977E4.s.o(.bss); }
    .main_800A13F0 0x800A13F0 : AT(0x000A1FF0) { build/asm/data/main_800A13F0.bin.o(.data); }
    .main_800A9C0C 0x800A9C0C : AT(0x000AA80C) { FILL(0x00000000); build/asm/main_800A9C0C.s.o(.text); build/asm/main_800A9C0C.s.o(.rodata); build/asm/main_800A9C0C.s.o(.data); }
    .main_800A9C0C_bss (NOLOAD) : { build/asm/main_800A9C0C.s.o(.bss); }
    .main_800AA5B0 0x800AA5B0 : AT(0x000AB1B0) { build/asm/data/main_800AA5B0.bin.o(.data); }
    .main_800AE68C 0x800AE68C : AT(0x000AF28C) { FILL(0x00000000); build/asm/main_800AE68C.s.o(.text); build/asm/main_800AE68C.s.o(.rodata); build/asm/main_800AE68C.s.o(.data); }
    .main_800AE68C_bss (NOLOAD) : { build/asm/main_800AE68C.s.o(.bss); }
    .main_800AECA0 0x800AECA0 : AT(0x000AF8A0) { build/asm/data/main_800AECA0.bin.o(.data); }
    .main_800AF770 0x800AF770 : AT(0x000B0370) { FILL(0x00000000); build/asm/main_800AF770.s.o(.text); build/asm/main_800AF770.s.o(.rodata); build/asm/main_800AF770.s.o(.data); }
    .main_800AF770_bss (NOLOAD) : { build/asm/main_800AF770.s.o(.bss); }
    .main_800AF7EC 0x800AF7EC : AT(0x000B03EC) { build/asm/data/main_800AF7EC.bin.o(.data); }
    .main_800B160C 0x800B160C : AT(0x000B220C) { FILL(0x00000000); build/asm/main_800B160C.s.o(.text); build/asm/main_800B160C.s.o(.rodata); build/asm/main_800B160C.s.o(.data); }
    .main_800B160C_bss (NOLOAD) : { build/asm/main_800B160C.s.o(.bss); }
    .main_800B1F0C 0x800B1F0C : AT(0x000B2B0C) { build/asm/data/main_800B1F0C.bin.o(.data); }
    .main_800C01E0 0x800C01E0 : AT(0x000C0DE0) { FILL(0x00000000); build/asm/main_800C01E0.s.o(.text); build/asm/main_800C01E0.s.o(.rodata); build/asm/main_800C01E0.s.o(.data); }
    .main_800C01E0_bss (NOLOAD) : { build/asm/main_800C01E0.s.o(.bss); }
    .main_800C0210 0x800C0210 : AT(0x000C0E10) { build/asm/data/main_800C0210.bin.o(.data); }
    .main_800C0300 0x800C0300 : AT(0x000C0F00) { FILL(0x00000000); build/asm/main_800C0300.s.o(.text); build/asm/main_800C0300.s.o(.rodata); build/asm/main_800C0300.s.o(.data); }
    .main_800C0300_bss (NOLOAD) : { build/asm/main_800C0300.s.o(.bss); }
    .main_800C0378 0x800C0378 : AT(0x000C0F78) { build/asm/data/main_800C0378.bin.o(.data); }
    .main_800C0524 0x800C0524 : AT(0x000C1124) { FILL(0x00000000); build/asm/main_800C0524.s.o(.text); build/asm/main_800C0524.s.o(.rodata); build/asm/main_800C0524.s.o(.data); }
    .main_800C0524_bss (NOLOAD) : { build/asm/main_800C0524.s.o(.bss); }
    .main_800C0550 0x800C0550 : AT(0x000C1150) { build/asm/data/main_800C0550.bin.o(.data); }
    .main_800C06E8 0x800C06E8 : AT(0x000C12E8) { FILL(0x00000000); build/asm/main_800C06E8.s.o(.text); build/asm/main_800C06E8.s.o(.rodata); build/asm/main_800C06E8.s.o(.data); }
    .main_800C06E8_bss (NOLOAD) : { build/asm/main_800C06E8.s.o(.bss); }
    .main_800C08A4 0x800C08A4 : AT(0x000C14A4) { build/asm/data/main_800C08A4.bin.o(.data); }
    .main_800C08FC 0x800C08FC : AT(0x000C14FC) { FILL(0x00000000); build/asm/main_800C08FC.s.o(.text); build/asm/main_800C08FC.s.o(.rodata); build/asm/main_800C08FC.s.o(.data); }
    .main_800C08FC_bss (NOLOAD) : { build/asm/main_800C08FC.s.o(.bss); }
    .main_800C0938 0x800C0938 : AT(0x000C1538) { build/asm/data/main_800C0938.bin.o(.data); }
    .main_800C0ACC 0x800C0ACC : AT(0x000C16CC) { FILL(0x00000000); build/asm/main_800C0ACC.s.o(.text); build/asm/main_800C0ACC.s.o(.rodata); build/asm/main_800C0ACC.s.o(.data); }
    .main_800C0ACC_bss (NOLOAD) : { build/asm/main_800C0ACC.s.o(.bss); }
    .main_800C0AF0 0x800C0AF0 : AT(0x000C16F0) { build/asm/data/main_800C0AF0.bin.o(.data); }
    .main_800C0D14 0x800C0D14 : AT(0x000C1914) { FILL(0x00000000); build/asm/main_800C0D14.s.o(.text); build/asm/main_800C0D14.s.o(.rodata); build/asm/main_800C0D14.s.o(.data); }
    .main_800C0D14_bss (NOLOAD) : { build/asm/main_800C0D14.s.o(.bss); }
    .main_800C0D3C 0x800C0D3C : AT(0x000C193C) { build/asm/data/main_800C0D3C.bin.o(.data); }
    .main_800C16D0 0x800C16D0 : AT(0x000C22D0) { FILL(0x00000000); build/asm/main_800C16D0.s.o(.text); build/asm/main_800C16D0.s.o(.rodata); build/asm/main_800C16D0.s.o(.data); }
    .main_800C16D0_bss (NOLOAD) : { build/asm/main_800C16D0.s.o(.bss); }
    .main_800C16EC 0x800C16EC : AT(0x000C22EC) { build/asm/data/main_800C16EC.bin.o(.data); }
    .main_800C18DC 0x800C18DC : AT(0x000C24DC) { FILL(0x00000000); build/asm/main_800C18DC.s.o(.text); build/asm/main_800C18DC.s.o(.rodata); build/asm/main_800C18DC.s.o(.data); }
    .main_800C18DC_bss (NOLOAD) : { build/asm/main_800C18DC.s.o(.bss); }
    .main_800C18F8 0x800C18F8 : AT(0x000C24F8) { build/asm/data/main_800C18F8.bin.o(.data); }
    .main_800C210C 0x800C210C : AT(0x000C2D0C) { FILL(0x00000000); build/asm/main_800C210C.s.o(.text); build/asm/main_800C210C.s.o(.rodata); build/asm/main_800C210C.s.o(.data); }
    .main_800C210C_bss (NOLOAD) : { build/asm/main_800C210C.s.o(.bss); }
    .main_800C212C 0x800C212C : AT(0x000C2D2C) { build/asm/data/main_800C212C.bin.o(.data); }
    .main_800C24DC 0x800C24DC : AT(0x000C30DC) { FILL(0x00000000); build/asm/main_800C24DC.s.o(.text); build/asm/main_800C24DC.s.o(.rodata); build/asm/main_800C24DC.s.o(.data); }
    .main_800C24DC_bss (NOLOAD) : { build/asm/main_800C24DC.s.o(.bss); }
    .main_800C24FC 0x800C24FC : AT(0x000C30FC) { build/asm/data/main_800C24FC.bin.o(.data); }
    .main_800C3938 0x800C3938 : AT(0x000C4538) { FILL(0x00000000); build/asm/main_800C3938.s.o(.text); build/asm/main_800C3938.s.o(.rodata); build/asm/main_800C3938.s.o(.data); }
    .main_800C3938_bss (NOLOAD) : { build/asm/main_800C3938.s.o(.bss); }
    .main_800C3980 0x800C3980 : AT(0x000C4580) { build/asm/data/main_800C3980.bin.o(.data); }
    .main_800C44E4 0x800C44E4 : AT(0x000C50E4) { FILL(0x00000000); build/asm/main_800C44E4.s.o(.text); build/asm/main_800C44E4.s.o(.rodata); build/asm/main_800C44E4.s.o(.data); }
    .main_800C44E4_bss (NOLOAD) : { build/asm/main_800C44E4.s.o(.bss); }
    .main_800C4504 0x800C4504 : AT(0x000C5104) { build/asm/data/main_800C4504.bin.o(.data); }
    .main_800C6430 0x800C6430 : AT(0x000C7030) { FILL(0x00000000); build/asm/main_800C6430.s.o(.text); build/asm/main_800C6430.s.o(.rodata); build/asm/main_800C6430.s.o(.data); }
    .main_800C6430_bss (NOLOAD) : { build/asm/main_800C6430.s.o(.bss); }
    .main_800C6438 0x800C6438 : AT(0x000C7038) { build/asm/data/main_800C6438.bin.o(.data); }
    .main_800D67C4 0x800D67C4 : AT(0x000D73C4) { FILL(0x00000000); build/asm/main_800D67C4.s.o(.text); build/asm/main_800D67C4.s.o(.rodata); build/asm/main_800D67C4.s.o(.data); }
    .main_800D67C4_bss (NOLOAD) : { build/asm/main_800D67C4.s.o(.bss); }
    .main_800D67F4 0x800D67F4 : AT(0x000D73F4) { build/asm/data/main_800D67F4.bin.o(.data); }
    .main_800F71C0 0x800F71C0 : AT(0x000F7DC0) { build/asm/data/main_800F71C0.bin.o(.data); }
    .main_800F83AC 0x800F83AC : AT(0x000F8FAC) { build/asm/data/main_800F83AC.bin.o(.data); }
    .main_801001B0 0x801001B0 : AT(0x00100DB0) { FILL(0x00000000); build/asm/main_801001B0.s.o(.text); build/asm/main_801001B0.s.o(.rodata); build/asm/main_801001B0.s.o(.data); }
    .main_801001B0_bss (NOLOAD) : { build/asm/main_801001B0.s.o(.bss); }
    .main_801001E4 0x801001E4 : AT(0x00100DE4) { build/asm/data/main_801001E4.bin.o(.data); }
    .main_80100310 0x80100310 : AT(0x00100F10) { FILL(0x00000000); build/asm/main_80100310.s.o(.text); build/asm/main_80100310.s.o(.rodata); build/asm/main_80100310.s.o(.data); }
    .main_80100310_bss (NOLOAD) : { build/asm/main_80100310.s.o(.bss); }
    .main_8010034C 0x8010034C : AT(0x00100F4C) { build/asm/data/main_8010034C.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
