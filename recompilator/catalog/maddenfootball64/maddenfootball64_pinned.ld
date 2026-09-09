SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80200400 0x80200400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80200400.s.o(.text); build/asm/main_80200400.s.o(.rodata); build/asm/main_80200400.s.o(.data); }
    .main_80200400_bss (NOLOAD) : { build/asm/main_80200400.s.o(.bss); }
    .main_802004B4 0x802004B4 : AT(0x000010B4) { FILL(0x00000000); build/asm/main_802004B4.s.o(.text); build/asm/main_802004B4.s.o(.rodata); build/asm/main_802004B4.s.o(.data); }
    .main_802004B4_bss (NOLOAD) : { build/asm/main_802004B4.s.o(.bss); }
    .main_80200968 0x80200968 : AT(0x00001568) { build/asm/data/main_80200968.bin.o(.data); }
    .main_80200A9C 0x80200A9C : AT(0x0000169C) { FILL(0x00000000); build/asm/main_80200A9C.s.o(.text); build/asm/main_80200A9C.s.o(.rodata); build/asm/main_80200A9C.s.o(.data); }
    .main_80200A9C_bss (NOLOAD) : { build/asm/main_80200A9C.s.o(.bss); }
    .main_80200AA0 0x80200AA0 : AT(0x000016A0) { build/asm/data/main_80200AA0.bin.o(.data); }
    .main_80200BC0 0x80200BC0 : AT(0x000017C0) { FILL(0x00000000); build/asm/main_80200BC0.s.o(.text); build/asm/main_80200BC0.s.o(.rodata); build/asm/main_80200BC0.s.o(.data); }
    .main_80200BC0_bss (NOLOAD) : { build/asm/main_80200BC0.s.o(.bss); }
    .main_80200BDC 0x80200BDC : AT(0x000017DC) { build/asm/data/main_80200BDC.bin.o(.data); }
    .main_8020102C 0x8020102C : AT(0x00001C2C) { FILL(0x00000000); build/asm/main_8020102C.s.o(.text); build/asm/main_8020102C.s.o(.rodata); build/asm/main_8020102C.s.o(.data); }
    .main_8020102C_bss (NOLOAD) : { build/asm/main_8020102C.s.o(.bss); }
    .main_80201070 0x80201070 : AT(0x00001C70) { build/asm/data/main_80201070.bin.o(.data); }
    .main_80201658 0x80201658 : AT(0x00002258) { FILL(0x00000000); build/asm/main_80201658.s.o(.text); build/asm/main_80201658.s.o(.rodata); build/asm/main_80201658.s.o(.data); }
    .main_80201658_bss (NOLOAD) : { build/asm/main_80201658.s.o(.bss); }
    .main_80201660 0x80201660 : AT(0x00002260) { build/asm/data/main_80201660.bin.o(.data); }
    .main_80201A0C 0x80201A0C : AT(0x0000260C) { FILL(0x00000000); build/asm/main_80201A0C.s.o(.text); build/asm/main_80201A0C.s.o(.rodata); build/asm/main_80201A0C.s.o(.data); }
    .main_80201A0C_bss (NOLOAD) : { build/asm/main_80201A0C.s.o(.bss); }
    .main_80201A70 0x80201A70 : AT(0x00002670) { build/asm/data/main_80201A70.bin.o(.data); }
    .main_80202708 0x80202708 : AT(0x00003308) { FILL(0x00000000); build/asm/main_80202708.s.o(.text); build/asm/main_80202708.s.o(.rodata); build/asm/main_80202708.s.o(.data); }
    .main_80202708_bss (NOLOAD) : { build/asm/main_80202708.s.o(.bss); }
    .main_80202730 0x80202730 : AT(0x00003330) { build/asm/data/main_80202730.bin.o(.data); }
    .main_80203EE8 0x80203EE8 : AT(0x00004AE8) { FILL(0x00000000); build/asm/main_80203EE8.s.o(.text); build/asm/main_80203EE8.s.o(.rodata); build/asm/main_80203EE8.s.o(.data); }
    .main_80203EE8_bss (NOLOAD) : { build/asm/main_80203EE8.s.o(.bss); }
    .main_80203F20 0x80203F20 : AT(0x00004B20) { build/asm/data/main_80203F20.bin.o(.data); }
    .main_802043A4 0x802043A4 : AT(0x00004FA4) { FILL(0x00000000); build/asm/main_802043A4.s.o(.text); build/asm/main_802043A4.s.o(.rodata); build/asm/main_802043A4.s.o(.data); }
    .main_802043A4_bss (NOLOAD) : { build/asm/main_802043A4.s.o(.bss); }
    .main_802043A8 0x802043A8 : AT(0x00004FA8) { build/asm/data/main_802043A8.bin.o(.data); }
    .main_80204BD4 0x80204BD4 : AT(0x000057D4) { FILL(0x00000000); build/asm/main_80204BD4.s.o(.text); build/asm/main_80204BD4.s.o(.rodata); build/asm/main_80204BD4.s.o(.data); }
    .main_80204BD4_bss (NOLOAD) : { build/asm/main_80204BD4.s.o(.bss); }
    .main_80204C14 0x80204C14 : AT(0x00005814) { build/asm/data/main_80204C14.bin.o(.data); }
    .main_80204E14 0x80204E14 : AT(0x00005A14) { FILL(0x00000000); build/asm/main_80204E14.s.o(.text); build/asm/main_80204E14.s.o(.rodata); build/asm/main_80204E14.s.o(.data); }
    .main_80204E14_bss (NOLOAD) : { build/asm/main_80204E14.s.o(.bss); }
    .main_80205014 0x80205014 : AT(0x00005C14) { build/asm/data/main_80205014.bin.o(.data); }
    .main_8020507C 0x8020507C : AT(0x00005C7C) { FILL(0x00000000); build/asm/main_8020507C.s.o(.text); build/asm/main_8020507C.s.o(.rodata); build/asm/main_8020507C.s.o(.data); }
    .main_8020507C_bss (NOLOAD) : { build/asm/main_8020507C.s.o(.bss); }
    .main_8020509C 0x8020509C : AT(0x00005C9C) { build/asm/data/main_8020509C.bin.o(.data); }
    .main_80205598 0x80205598 : AT(0x00006198) { FILL(0x00000000); build/asm/main_80205598.s.o(.text); build/asm/main_80205598.s.o(.rodata); build/asm/main_80205598.s.o(.data); }
    .main_80205598_bss (NOLOAD) : { build/asm/main_80205598.s.o(.bss); }
    .main_802055C8 0x802055C8 : AT(0x000061C8) { build/asm/data/main_802055C8.bin.o(.data); }
    .main_80205A94 0x80205A94 : AT(0x00006694) { FILL(0x00000000); build/asm/main_80205A94.s.o(.text); build/asm/main_80205A94.s.o(.rodata); build/asm/main_80205A94.s.o(.data); }
    .main_80205A94_bss (NOLOAD) : { build/asm/main_80205A94.s.o(.bss); }
    .main_80205AA4 0x80205AA4 : AT(0x000066A4) { build/asm/data/main_80205AA4.bin.o(.data); }
    .main_80207D5C 0x80207D5C : AT(0x0000895C) { FILL(0x00000000); build/asm/main_80207D5C.s.o(.text); build/asm/main_80207D5C.s.o(.rodata); build/asm/main_80207D5C.s.o(.data); }
    .main_80207D5C_bss (NOLOAD) : { build/asm/main_80207D5C.s.o(.bss); }
    .main_80207FB0 0x80207FB0 : AT(0x00008BB0) { build/asm/data/main_80207FB0.bin.o(.data); }
    .main_80208F10 0x80208F10 : AT(0x00009B10) { FILL(0x00000000); build/asm/main_80208F10.s.o(.text); build/asm/main_80208F10.s.o(.rodata); build/asm/main_80208F10.s.o(.data); }
    .main_80208F10_bss (NOLOAD) : { build/asm/main_80208F10.s.o(.bss); }
    .main_80209014 0x80209014 : AT(0x00009C14) { build/asm/data/main_80209014.bin.o(.data); }
    .main_80209538 0x80209538 : AT(0x0000A138) { FILL(0x00000000); build/asm/main_80209538.s.o(.text); build/asm/main_80209538.s.o(.rodata); build/asm/main_80209538.s.o(.data); }
    .main_80209538_bss (NOLOAD) : { build/asm/main_80209538.s.o(.bss); }
    .main_80209540 0x80209540 : AT(0x0000A140) { build/asm/data/main_80209540.bin.o(.data); }
    .main_8020A010 0x8020A010 : AT(0x0000AC10) { FILL(0x00000000); build/asm/main_8020A010.s.o(.text); build/asm/main_8020A010.s.o(.rodata); build/asm/main_8020A010.s.o(.data); }
    .main_8020A010_bss (NOLOAD) : { build/asm/main_8020A010.s.o(.bss); }
    .main_8020A024 0x8020A024 : AT(0x0000AC24) { build/asm/data/main_8020A024.bin.o(.data); }
    .main_8020CC18 0x8020CC18 : AT(0x0000D818) { FILL(0x00000000); build/asm/main_8020CC18.s.o(.text); build/asm/main_8020CC18.s.o(.rodata); build/asm/main_8020CC18.s.o(.data); }
    .main_8020CC18_bss (NOLOAD) : { build/asm/main_8020CC18.s.o(.bss); }
    .main_8020CC20 0x8020CC20 : AT(0x0000D820) { build/asm/data/main_8020CC20.bin.o(.data); }
    .main_8020D7F0 0x8020D7F0 : AT(0x0000E3F0) { FILL(0x00000000); build/asm/main_8020D7F0.s.o(.text); build/asm/main_8020D7F0.s.o(.rodata); build/asm/main_8020D7F0.s.o(.data); }
    .main_8020D7F0_bss (NOLOAD) : { build/asm/main_8020D7F0.s.o(.bss); }
    .main_8020D7F8 0x8020D7F8 : AT(0x0000E3F8) { build/asm/data/main_8020D7F8.bin.o(.data); }
    .main_8020DDBC 0x8020DDBC : AT(0x0000E9BC) { FILL(0x00000000); build/asm/main_8020DDBC.s.o(.text); build/asm/main_8020DDBC.s.o(.rodata); build/asm/main_8020DDBC.s.o(.data); }
    .main_8020DDBC_bss (NOLOAD) : { build/asm/main_8020DDBC.s.o(.bss); }
    .main_8020DE38 0x8020DE38 : AT(0x0000EA38) { build/asm/data/main_8020DE38.bin.o(.data); }
    .main_8020E530 0x8020E530 : AT(0x0000F130) { FILL(0x00000000); build/asm/main_8020E530.s.o(.text); build/asm/main_8020E530.s.o(.rodata); build/asm/main_8020E530.s.o(.data); }
    .main_8020E530_bss (NOLOAD) : { build/asm/main_8020E530.s.o(.bss); }
    .main_8020E590 0x8020E590 : AT(0x0000F190) { build/asm/data/main_8020E590.bin.o(.data); }
    .main_8020F09C 0x8020F09C : AT(0x0000FC9C) { FILL(0x00000000); build/asm/main_8020F09C.s.o(.text); build/asm/main_8020F09C.s.o(.rodata); build/asm/main_8020F09C.s.o(.data); }
    .main_8020F09C_bss (NOLOAD) : { build/asm/main_8020F09C.s.o(.bss); }
    .main_8020F0E8 0x8020F0E8 : AT(0x0000FCE8) { build/asm/data/main_8020F0E8.bin.o(.data); }
    .main_8020F668 0x8020F668 : AT(0x00010268) { FILL(0x00000000); build/asm/main_8020F668.s.o(.text); build/asm/main_8020F668.s.o(.rodata); build/asm/main_8020F668.s.o(.data); }
    .main_8020F668_bss (NOLOAD) : { build/asm/main_8020F668.s.o(.bss); }
    .main_8020F680 0x8020F680 : AT(0x00010280) { build/asm/data/main_8020F680.bin.o(.data); }
    .main_8020FED8 0x8020FED8 : AT(0x00010AD8) { FILL(0x00000000); build/asm/main_8020FED8.s.o(.text); build/asm/main_8020FED8.s.o(.rodata); build/asm/main_8020FED8.s.o(.data); }
    .main_8020FED8_bss (NOLOAD) : { build/asm/main_8020FED8.s.o(.bss); }
    .main_8020FF3C 0x8020FF3C : AT(0x00010B3C) { build/asm/data/main_8020FF3C.bin.o(.data); }
    .main_8021000C 0x8021000C : AT(0x00010C0C) { FILL(0x00000000); build/asm/main_8021000C.s.o(.text); build/asm/main_8021000C.s.o(.rodata); build/asm/main_8021000C.s.o(.data); }
    .main_8021000C_bss (NOLOAD) : { build/asm/main_8021000C.s.o(.bss); }
    .main_80210090 0x80210090 : AT(0x00010C90) { build/asm/data/main_80210090.bin.o(.data); }
    .main_80210834 0x80210834 : AT(0x00011434) { FILL(0x00000000); build/asm/main_80210834.s.o(.text); build/asm/main_80210834.s.o(.rodata); build/asm/main_80210834.s.o(.data); }
    .main_80210834_bss (NOLOAD) : { build/asm/main_80210834.s.o(.bss); }
    .main_802108D0 0x802108D0 : AT(0x000114D0) { build/asm/data/main_802108D0.bin.o(.data); }
    .main_8021188C 0x8021188C : AT(0x0001248C) { FILL(0x00000000); build/asm/main_8021188C.s.o(.text); build/asm/main_8021188C.s.o(.rodata); build/asm/main_8021188C.s.o(.data); }
    .main_8021188C_bss (NOLOAD) : { build/asm/main_8021188C.s.o(.bss); }
    .main_80211960 0x80211960 : AT(0x00012560) { build/asm/data/main_80211960.bin.o(.data); }
    .main_80211AE8 0x80211AE8 : AT(0x000126E8) { FILL(0x00000000); build/asm/main_80211AE8.s.o(.text); build/asm/main_80211AE8.s.o(.rodata); build/asm/main_80211AE8.s.o(.data); }
    .main_80211AE8_bss (NOLOAD) : { build/asm/main_80211AE8.s.o(.bss); }
    .main_80211B24 0x80211B24 : AT(0x00012724) { build/asm/data/main_80211B24.bin.o(.data); }
    .main_80212118 0x80212118 : AT(0x00012D18) { FILL(0x00000000); build/asm/main_80212118.s.o(.text); build/asm/main_80212118.s.o(.rodata); build/asm/main_80212118.s.o(.data); }
    .main_80212118_bss (NOLOAD) : { build/asm/main_80212118.s.o(.bss); }
    .main_80212158 0x80212158 : AT(0x00012D58) { build/asm/data/main_80212158.bin.o(.data); }
    .main_80212920 0x80212920 : AT(0x00013520) { FILL(0x00000000); build/asm/main_80212920.s.o(.text); build/asm/main_80212920.s.o(.rodata); build/asm/main_80212920.s.o(.data); }
    .main_80212920_bss (NOLOAD) : { build/asm/main_80212920.s.o(.bss); }
    .main_80212958 0x80212958 : AT(0x00013558) { build/asm/data/main_80212958.bin.o(.data); }
    .main_802129C0 0x802129C0 : AT(0x000135C0) { FILL(0x00000000); build/asm/main_802129C0.s.o(.text); build/asm/main_802129C0.s.o(.rodata); build/asm/main_802129C0.s.o(.data); }
    .main_802129C0_bss (NOLOAD) : { build/asm/main_802129C0.s.o(.bss); }
    .main_802129D4 0x802129D4 : AT(0x000135D4) { build/asm/data/main_802129D4.bin.o(.data); }
    .main_80213C2C 0x80213C2C : AT(0x0001482C) { FILL(0x00000000); build/asm/main_80213C2C.s.o(.text); build/asm/main_80213C2C.s.o(.rodata); build/asm/main_80213C2C.s.o(.data); }
    .main_80213C2C_bss (NOLOAD) : { build/asm/main_80213C2C.s.o(.bss); }
    .main_80213C5C 0x80213C5C : AT(0x0001485C) { build/asm/data/main_80213C5C.bin.o(.data); }
    .main_80214194 0x80214194 : AT(0x00014D94) { FILL(0x00000000); build/asm/main_80214194.s.o(.text); build/asm/main_80214194.s.o(.rodata); build/asm/main_80214194.s.o(.data); }
    .main_80214194_bss (NOLOAD) : { build/asm/main_80214194.s.o(.bss); }
    .main_802141F4 0x802141F4 : AT(0x00014DF4) { build/asm/data/main_802141F4.bin.o(.data); }
    .main_802143CC 0x802143CC : AT(0x00014FCC) { FILL(0x00000000); build/asm/main_802143CC.s.o(.text); build/asm/main_802143CC.s.o(.rodata); build/asm/main_802143CC.s.o(.data); }
    .main_802143CC_bss (NOLOAD) : { build/asm/main_802143CC.s.o(.bss); }
    .main_802143E4 0x802143E4 : AT(0x00014FE4) { build/asm/data/main_802143E4.bin.o(.data); }
    .main_80214940 0x80214940 : AT(0x00015540) { FILL(0x00000000); build/asm/main_80214940.s.o(.text); build/asm/main_80214940.s.o(.rodata); build/asm/main_80214940.s.o(.data); }
    .main_80214940_bss (NOLOAD) : { build/asm/main_80214940.s.o(.bss); }
    .main_80214944 0x80214944 : AT(0x00015544) { build/asm/data/main_80214944.bin.o(.data); }
    .main_80214B10 0x80214B10 : AT(0x00015710) { FILL(0x00000000); build/asm/main_80214B10.s.o(.text); build/asm/main_80214B10.s.o(.rodata); build/asm/main_80214B10.s.o(.data); }
    .main_80214B10_bss (NOLOAD) : { build/asm/main_80214B10.s.o(.bss); }
    .main_80214B18 0x80214B18 : AT(0x00015718) { build/asm/data/main_80214B18.bin.o(.data); }
    .main_80215984 0x80215984 : AT(0x00016584) { FILL(0x00000000); build/asm/main_80215984.s.o(.text); build/asm/main_80215984.s.o(.rodata); build/asm/main_80215984.s.o(.data); }
    .main_80215984_bss (NOLOAD) : { build/asm/main_80215984.s.o(.bss); }
    .main_802159B4 0x802159B4 : AT(0x000165B4) { build/asm/data/main_802159B4.bin.o(.data); }
    .main_80215EFC 0x80215EFC : AT(0x00016AFC) { FILL(0x00000000); build/asm/main_80215EFC.s.o(.text); build/asm/main_80215EFC.s.o(.rodata); build/asm/main_80215EFC.s.o(.data); }
    .main_80215EFC_bss (NOLOAD) : { build/asm/main_80215EFC.s.o(.bss); }
    .main_80215F30 0x80215F30 : AT(0x00016B30) { build/asm/data/main_80215F30.bin.o(.data); }
    .main_802166F8 0x802166F8 : AT(0x000172F8) { FILL(0x00000000); build/asm/main_802166F8.s.o(.text); build/asm/main_802166F8.s.o(.rodata); build/asm/main_802166F8.s.o(.data); }
    .main_802166F8_bss (NOLOAD) : { build/asm/main_802166F8.s.o(.bss); }
    .main_80216708 0x80216708 : AT(0x00017308) { build/asm/data/main_80216708.bin.o(.data); }
    .main_802167E4 0x802167E4 : AT(0x000173E4) { FILL(0x00000000); build/asm/main_802167E4.s.o(.text); build/asm/main_802167E4.s.o(.rodata); build/asm/main_802167E4.s.o(.data); }
    .main_802167E4_bss (NOLOAD) : { build/asm/main_802167E4.s.o(.bss); }
    .main_802167F4 0x802167F4 : AT(0x000173F4) { build/asm/data/main_802167F4.bin.o(.data); }
    .main_80216E54 0x80216E54 : AT(0x00017A54) { FILL(0x00000000); build/asm/main_80216E54.s.o(.text); build/asm/main_80216E54.s.o(.rodata); build/asm/main_80216E54.s.o(.data); }
    .main_80216E54_bss (NOLOAD) : { build/asm/main_80216E54.s.o(.bss); }
    .main_80216EE8 0x80216EE8 : AT(0x00017AE8) { build/asm/data/main_80216EE8.bin.o(.data); }
    .main_802177C0 0x802177C0 : AT(0x000183C0) { FILL(0x00000000); build/asm/main_802177C0.s.o(.text); build/asm/main_802177C0.s.o(.rodata); build/asm/main_802177C0.s.o(.data); }
    .main_802177C0_bss (NOLOAD) : { build/asm/main_802177C0.s.o(.bss); }
    .main_80217860 0x80217860 : AT(0x00018460) { build/asm/data/main_80217860.bin.o(.data); }
    .main_80218094 0x80218094 : AT(0x00018C94) { FILL(0x00000000); build/asm/main_80218094.s.o(.text); build/asm/main_80218094.s.o(.rodata); build/asm/main_80218094.s.o(.data); }
    .main_80218094_bss (NOLOAD) : { build/asm/main_80218094.s.o(.bss); }
    .main_802180CC 0x802180CC : AT(0x00018CCC) { build/asm/data/main_802180CC.bin.o(.data); }
    .main_802184D0 0x802184D0 : AT(0x000190D0) { FILL(0x00000000); build/asm/main_802184D0.s.o(.text); build/asm/main_802184D0.s.o(.rodata); build/asm/main_802184D0.s.o(.data); }
    .main_802184D0_bss (NOLOAD) : { build/asm/main_802184D0.s.o(.bss); }
    .main_802184D4 0x802184D4 : AT(0x000190D4) { build/asm/data/main_802184D4.bin.o(.data); }
    .main_80218878 0x80218878 : AT(0x00019478) { FILL(0x00000000); build/asm/main_80218878.s.o(.text); build/asm/main_80218878.s.o(.rodata); build/asm/main_80218878.s.o(.data); }
    .main_80218878_bss (NOLOAD) : { build/asm/main_80218878.s.o(.bss); }
    .main_802188D0 0x802188D0 : AT(0x000194D0) { build/asm/data/main_802188D0.bin.o(.data); }
    .main_80218DEC 0x80218DEC : AT(0x000199EC) { FILL(0x00000000); build/asm/main_80218DEC.s.o(.text); build/asm/main_80218DEC.s.o(.rodata); build/asm/main_80218DEC.s.o(.data); }
    .main_80218DEC_bss (NOLOAD) : { build/asm/main_80218DEC.s.o(.bss); }
    .main_80218DF8 0x80218DF8 : AT(0x000199F8) { build/asm/data/main_80218DF8.bin.o(.data); }
    .main_8021920C 0x8021920C : AT(0x00019E0C) { FILL(0x00000000); build/asm/main_8021920C.s.o(.text); build/asm/main_8021920C.s.o(.rodata); build/asm/main_8021920C.s.o(.data); }
    .main_8021920C_bss (NOLOAD) : { build/asm/main_8021920C.s.o(.bss); }
    .main_8021921C 0x8021921C : AT(0x00019E1C) { build/asm/data/main_8021921C.bin.o(.data); }
    .main_802197F8 0x802197F8 : AT(0x0001A3F8) { FILL(0x00000000); build/asm/main_802197F8.s.o(.text); build/asm/main_802197F8.s.o(.rodata); build/asm/main_802197F8.s.o(.data); }
    .main_802197F8_bss (NOLOAD) : { build/asm/main_802197F8.s.o(.bss); }
    .main_80219824 0x80219824 : AT(0x0001A424) { build/asm/data/main_80219824.bin.o(.data); }
    .main_802198DC 0x802198DC : AT(0x0001A4DC) { FILL(0x00000000); build/asm/main_802198DC.s.o(.text); build/asm/main_802198DC.s.o(.rodata); build/asm/main_802198DC.s.o(.data); }
    .main_802198DC_bss (NOLOAD) : { build/asm/main_802198DC.s.o(.bss); }
    .main_802199D0 0x802199D0 : AT(0x0001A5D0) { build/asm/data/main_802199D0.bin.o(.data); }
    .main_80219AB8 0x80219AB8 : AT(0x0001A6B8) { FILL(0x00000000); build/asm/main_80219AB8.s.o(.text); build/asm/main_80219AB8.s.o(.rodata); build/asm/main_80219AB8.s.o(.data); }
    .main_80219AB8_bss (NOLOAD) : { build/asm/main_80219AB8.s.o(.bss); }
    .main_80219BD8 0x80219BD8 : AT(0x0001A7D8) { build/asm/data/main_80219BD8.bin.o(.data); }
    .main_8021A934 0x8021A934 : AT(0x0001B534) { FILL(0x00000000); build/asm/main_8021A934.s.o(.text); build/asm/main_8021A934.s.o(.rodata); build/asm/main_8021A934.s.o(.data); }
    .main_8021A934_bss (NOLOAD) : { build/asm/main_8021A934.s.o(.bss); }
    .main_8021A9CC 0x8021A9CC : AT(0x0001B5CC) { build/asm/data/main_8021A9CC.bin.o(.data); }
    .main_8021AB60 0x8021AB60 : AT(0x0001B760) { FILL(0x00000000); build/asm/main_8021AB60.s.o(.text); build/asm/main_8021AB60.s.o(.rodata); build/asm/main_8021AB60.s.o(.data); }
    .main_8021AB60_bss (NOLOAD) : { build/asm/main_8021AB60.s.o(.bss); }
    .main_8021AB64 0x8021AB64 : AT(0x0001B764) { build/asm/data/main_8021AB64.bin.o(.data); }
    .main_8021ABE0 0x8021ABE0 : AT(0x0001B7E0) { FILL(0x00000000); build/asm/main_8021ABE0.s.o(.text); build/asm/main_8021ABE0.s.o(.rodata); build/asm/main_8021ABE0.s.o(.data); }
    .main_8021ABE0_bss (NOLOAD) : { build/asm/main_8021ABE0.s.o(.bss); }
    .main_8021ABF0 0x8021ABF0 : AT(0x0001B7F0) { build/asm/data/main_8021ABF0.bin.o(.data); }
    .main_8021B28C 0x8021B28C : AT(0x0001BE8C) { FILL(0x00000000); build/asm/main_8021B28C.s.o(.text); build/asm/main_8021B28C.s.o(.rodata); build/asm/main_8021B28C.s.o(.data); }
    .main_8021B28C_bss (NOLOAD) : { build/asm/main_8021B28C.s.o(.bss); }
    .main_8021B290 0x8021B290 : AT(0x0001BE90) { build/asm/data/main_8021B290.bin.o(.data); }
    .main_8021BFFC 0x8021BFFC : AT(0x0001CBFC) { FILL(0x00000000); build/asm/main_8021BFFC.s.o(.text); build/asm/main_8021BFFC.s.o(.rodata); build/asm/main_8021BFFC.s.o(.data); }
    .main_8021BFFC_bss (NOLOAD) : { build/asm/main_8021BFFC.s.o(.bss); }
    .main_8021C02C 0x8021C02C : AT(0x0001CC2C) { build/asm/data/main_8021C02C.bin.o(.data); }
    .main_8021C13C 0x8021C13C : AT(0x0001CD3C) { FILL(0x00000000); build/asm/main_8021C13C.s.o(.text); build/asm/main_8021C13C.s.o(.rodata); build/asm/main_8021C13C.s.o(.data); }
    .main_8021C13C_bss (NOLOAD) : { build/asm/main_8021C13C.s.o(.bss); }
    .main_8021C1A8 0x8021C1A8 : AT(0x0001CDA8) { build/asm/data/main_8021C1A8.bin.o(.data); }
    .main_8021CAD4 0x8021CAD4 : AT(0x0001D6D4) { FILL(0x00000000); build/asm/main_8021CAD4.s.o(.text); build/asm/main_8021CAD4.s.o(.rodata); build/asm/main_8021CAD4.s.o(.data); }
    .main_8021CAD4_bss (NOLOAD) : { build/asm/main_8021CAD4.s.o(.bss); }
    .main_8021CAE4 0x8021CAE4 : AT(0x0001D6E4) { build/asm/data/main_8021CAE4.bin.o(.data); }
    .main_8021D000 0x8021D000 : AT(0x0001DC00) { FILL(0x00000000); build/asm/main_8021D000.s.o(.text); build/asm/main_8021D000.s.o(.rodata); build/asm/main_8021D000.s.o(.data); }
    .main_8021D000_bss (NOLOAD) : { build/asm/main_8021D000.s.o(.bss); }
    .main_8021D008 0x8021D008 : AT(0x0001DC08) { build/asm/data/main_8021D008.bin.o(.data); }
    .main_8021D628 0x8021D628 : AT(0x0001E228) { FILL(0x00000000); build/asm/main_8021D628.s.o(.text); build/asm/main_8021D628.s.o(.rodata); build/asm/main_8021D628.s.o(.data); }
    .main_8021D628_bss (NOLOAD) : { build/asm/main_8021D628.s.o(.bss); }
    .main_8021D64C 0x8021D64C : AT(0x0001E24C) { build/asm/data/main_8021D64C.bin.o(.data); }
    .main_8021D964 0x8021D964 : AT(0x0001E564) { FILL(0x00000000); build/asm/main_8021D964.s.o(.text); build/asm/main_8021D964.s.o(.rodata); build/asm/main_8021D964.s.o(.data); }
    .main_8021D964_bss (NOLOAD) : { build/asm/main_8021D964.s.o(.bss); }
    .main_8021D96C 0x8021D96C : AT(0x0001E56C) { build/asm/data/main_8021D96C.bin.o(.data); }
    .main_8021DD28 0x8021DD28 : AT(0x0001E928) { FILL(0x00000000); build/asm/main_8021DD28.s.o(.text); build/asm/main_8021DD28.s.o(.rodata); build/asm/main_8021DD28.s.o(.data); }
    .main_8021DD28_bss (NOLOAD) : { build/asm/main_8021DD28.s.o(.bss); }
    .main_8021DD64 0x8021DD64 : AT(0x0001E964) { build/asm/data/main_8021DD64.bin.o(.data); }
    .main_8021E654 0x8021E654 : AT(0x0001F254) { FILL(0x00000000); build/asm/main_8021E654.s.o(.text); build/asm/main_8021E654.s.o(.rodata); build/asm/main_8021E654.s.o(.data); }
    .main_8021E654_bss (NOLOAD) : { build/asm/main_8021E654.s.o(.bss); }
    .main_8021E668 0x8021E668 : AT(0x0001F268) { build/asm/data/main_8021E668.bin.o(.data); }
    .main_8021EB38 0x8021EB38 : AT(0x0001F738) { FILL(0x00000000); build/asm/main_8021EB38.s.o(.text); build/asm/main_8021EB38.s.o(.rodata); build/asm/main_8021EB38.s.o(.data); }
    .main_8021EB38_bss (NOLOAD) : { build/asm/main_8021EB38.s.o(.bss); }
    .main_8021EB44 0x8021EB44 : AT(0x0001F744) { build/asm/data/main_8021EB44.bin.o(.data); }
    .main_8021EDD8 0x8021EDD8 : AT(0x0001F9D8) { FILL(0x00000000); build/asm/main_8021EDD8.s.o(.text); build/asm/main_8021EDD8.s.o(.rodata); build/asm/main_8021EDD8.s.o(.data); }
    .main_8021EDD8_bss (NOLOAD) : { build/asm/main_8021EDD8.s.o(.bss); }
    .main_8021EDF8 0x8021EDF8 : AT(0x0001F9F8) { build/asm/data/main_8021EDF8.bin.o(.data); }
    .main_80220520 0x80220520 : AT(0x00021120) { FILL(0x00000000); build/asm/main_80220520.s.o(.text); build/asm/main_80220520.s.o(.rodata); build/asm/main_80220520.s.o(.data); }
    .main_80220520_bss (NOLOAD) : { build/asm/main_80220520.s.o(.bss); }
    .main_80220534 0x80220534 : AT(0x00021134) { build/asm/data/main_80220534.bin.o(.data); }
    .main_80220608 0x80220608 : AT(0x00021208) { FILL(0x00000000); build/asm/main_80220608.s.o(.text); build/asm/main_80220608.s.o(.rodata); build/asm/main_80220608.s.o(.data); }
    .main_80220608_bss (NOLOAD) : { build/asm/main_80220608.s.o(.bss); }
    .main_80220628 0x80220628 : AT(0x00021228) { build/asm/data/main_80220628.bin.o(.data); }
    .main_80220AE4 0x80220AE4 : AT(0x000216E4) { FILL(0x00000000); build/asm/main_80220AE4.s.o(.text); build/asm/main_80220AE4.s.o(.rodata); build/asm/main_80220AE4.s.o(.data); }
    .main_80220AE4_bss (NOLOAD) : { build/asm/main_80220AE4.s.o(.bss); }
    .main_80220AF4 0x80220AF4 : AT(0x000216F4) { build/asm/data/main_80220AF4.bin.o(.data); }
    .main_80220BF8 0x80220BF8 : AT(0x000217F8) { FILL(0x00000000); build/asm/main_80220BF8.s.o(.text); build/asm/main_80220BF8.s.o(.rodata); build/asm/main_80220BF8.s.o(.data); }
    .main_80220BF8_bss (NOLOAD) : { build/asm/main_80220BF8.s.o(.bss); }
    .main_80220C04 0x80220C04 : AT(0x00021804) { build/asm/data/main_80220C04.bin.o(.data); }
    .main_802227D0 0x802227D0 : AT(0x000233D0) { FILL(0x00000000); build/asm/main_802227D0.s.o(.text); build/asm/main_802227D0.s.o(.rodata); build/asm/main_802227D0.s.o(.data); }
    .main_802227D0_bss (NOLOAD) : { build/asm/main_802227D0.s.o(.bss); }
    .main_802227F8 0x802227F8 : AT(0x000233F8) { build/asm/data/main_802227F8.bin.o(.data); }
    .main_802237C4 0x802237C4 : AT(0x000243C4) { FILL(0x00000000); build/asm/main_802237C4.s.o(.text); build/asm/main_802237C4.s.o(.rodata); build/asm/main_802237C4.s.o(.data); }
    .main_802237C4_bss (NOLOAD) : { build/asm/main_802237C4.s.o(.bss); }
    .main_802237D0 0x802237D0 : AT(0x000243D0) { build/asm/data/main_802237D0.bin.o(.data); }
    .main_802239C0 0x802239C0 : AT(0x000245C0) { FILL(0x00000000); build/asm/main_802239C0.s.o(.text); build/asm/main_802239C0.s.o(.rodata); build/asm/main_802239C0.s.o(.data); }
    .main_802239C0_bss (NOLOAD) : { build/asm/main_802239C0.s.o(.bss); }
    .main_802239D4 0x802239D4 : AT(0x000245D4) { build/asm/data/main_802239D4.bin.o(.data); }
    .main_80223CAC 0x80223CAC : AT(0x000248AC) { FILL(0x00000000); build/asm/main_80223CAC.s.o(.text); build/asm/main_80223CAC.s.o(.rodata); build/asm/main_80223CAC.s.o(.data); }
    .main_80223CAC_bss (NOLOAD) : { build/asm/main_80223CAC.s.o(.bss); }
    .main_80223CC4 0x80223CC4 : AT(0x000248C4) { build/asm/data/main_80223CC4.bin.o(.data); }
    .main_80224AC4 0x80224AC4 : AT(0x000256C4) { FILL(0x00000000); build/asm/main_80224AC4.s.o(.text); build/asm/main_80224AC4.s.o(.rodata); build/asm/main_80224AC4.s.o(.data); }
    .main_80224AC4_bss (NOLOAD) : { build/asm/main_80224AC4.s.o(.bss); }
    .main_80224B48 0x80224B48 : AT(0x00025748) { build/asm/data/main_80224B48.bin.o(.data); }
    .main_80224DF4 0x80224DF4 : AT(0x000259F4) { FILL(0x00000000); build/asm/main_80224DF4.s.o(.text); build/asm/main_80224DF4.s.o(.rodata); build/asm/main_80224DF4.s.o(.data); }
    .main_80224DF4_bss (NOLOAD) : { build/asm/main_80224DF4.s.o(.bss); }
    .main_80224E18 0x80224E18 : AT(0x00025A18) { build/asm/data/main_80224E18.bin.o(.data); }
    .main_80225050 0x80225050 : AT(0x00025C50) { FILL(0x00000000); build/asm/main_80225050.s.o(.text); build/asm/main_80225050.s.o(.rodata); build/asm/main_80225050.s.o(.data); }
    .main_80225050_bss (NOLOAD) : { build/asm/main_80225050.s.o(.bss); }
    .main_8022508C 0x8022508C : AT(0x00025C8C) { build/asm/data/main_8022508C.bin.o(.data); }
    .main_80225098 0x80225098 : AT(0x00025C98) { FILL(0x00000000); build/asm/main_80225098.s.o(.text); build/asm/main_80225098.s.o(.rodata); build/asm/main_80225098.s.o(.data); }
    .main_80225098_bss (NOLOAD) : { build/asm/main_80225098.s.o(.bss); }
    .main_802250A4 0x802250A4 : AT(0x00025CA4) { build/asm/data/main_802250A4.bin.o(.data); }
    .main_8022584C 0x8022584C : AT(0x0002644C) { FILL(0x00000000); build/asm/main_8022584C.s.o(.text); build/asm/main_8022584C.s.o(.rodata); build/asm/main_8022584C.s.o(.data); }
    .main_8022584C_bss (NOLOAD) : { build/asm/main_8022584C.s.o(.bss); }
    .main_80225858 0x80225858 : AT(0x00026458) { build/asm/data/main_80225858.bin.o(.data); }
    .main_8022607C 0x8022607C : AT(0x00026C7C) { FILL(0x00000000); build/asm/main_8022607C.s.o(.text); build/asm/main_8022607C.s.o(.rodata); build/asm/main_8022607C.s.o(.data); }
    .main_8022607C_bss (NOLOAD) : { build/asm/main_8022607C.s.o(.bss); }
    .main_802260B4 0x802260B4 : AT(0x00026CB4) { build/asm/data/main_802260B4.bin.o(.data); }
    .main_802272BC 0x802272BC : AT(0x00027EBC) { FILL(0x00000000); build/asm/main_802272BC.s.o(.text); build/asm/main_802272BC.s.o(.rodata); build/asm/main_802272BC.s.o(.data); }
    .main_802272BC_bss (NOLOAD) : { build/asm/main_802272BC.s.o(.bss); }
    .main_80227350 0x80227350 : AT(0x00027F50) { build/asm/data/main_80227350.bin.o(.data); }
    .main_80228030 0x80228030 : AT(0x00028C30) { FILL(0x00000000); build/asm/main_80228030.s.o(.text); build/asm/main_80228030.s.o(.rodata); build/asm/main_80228030.s.o(.data); }
    .main_80228030_bss (NOLOAD) : { build/asm/main_80228030.s.o(.bss); }
    .main_80228080 0x80228080 : AT(0x00028C80) { build/asm/data/main_80228080.bin.o(.data); }
    .main_80229728 0x80229728 : AT(0x0002A328) { FILL(0x00000000); build/asm/main_80229728.s.o(.text); build/asm/main_80229728.s.o(.rodata); build/asm/main_80229728.s.o(.data); }
    .main_80229728_bss (NOLOAD) : { build/asm/main_80229728.s.o(.bss); }
    .main_802297E8 0x802297E8 : AT(0x0002A3E8) { build/asm/data/main_802297E8.bin.o(.data); }
    .main_80229B78 0x80229B78 : AT(0x0002A778) { FILL(0x00000000); build/asm/main_80229B78.s.o(.text); build/asm/main_80229B78.s.o(.rodata); build/asm/main_80229B78.s.o(.data); }
    .main_80229B78_bss (NOLOAD) : { build/asm/main_80229B78.s.o(.bss); }
    .main_80229BC4 0x80229BC4 : AT(0x0002A7C4) { build/asm/data/main_80229BC4.bin.o(.data); }
    .main_80229CF4 0x80229CF4 : AT(0x0002A8F4) { FILL(0x00000000); build/asm/main_80229CF4.s.o(.text); build/asm/main_80229CF4.s.o(.rodata); build/asm/main_80229CF4.s.o(.data); }
    .main_80229CF4_bss (NOLOAD) : { build/asm/main_80229CF4.s.o(.bss); }
    .main_80229E14 0x80229E14 : AT(0x0002AA14) { build/asm/data/main_80229E14.bin.o(.data); }
    .main_80229FB0 0x80229FB0 : AT(0x0002ABB0) { FILL(0x00000000); build/asm/main_80229FB0.s.o(.text); build/asm/main_80229FB0.s.o(.rodata); build/asm/main_80229FB0.s.o(.data); }
    .main_80229FB0_bss (NOLOAD) : { build/asm/main_80229FB0.s.o(.bss); }
    .main_80229FC4 0x80229FC4 : AT(0x0002ABC4) { build/asm/data/main_80229FC4.bin.o(.data); }
    .main_8022A124 0x8022A124 : AT(0x0002AD24) { FILL(0x00000000); build/asm/main_8022A124.s.o(.text); build/asm/main_8022A124.s.o(.rodata); build/asm/main_8022A124.s.o(.data); }
    .main_8022A124_bss (NOLOAD) : { build/asm/main_8022A124.s.o(.bss); }
    .main_8022A19C 0x8022A19C : AT(0x0002AD9C) { build/asm/data/main_8022A19C.bin.o(.data); }
    .main_8022B528 0x8022B528 : AT(0x0002C128) { FILL(0x00000000); build/asm/main_8022B528.s.o(.text); build/asm/main_8022B528.s.o(.rodata); build/asm/main_8022B528.s.o(.data); }
    .main_8022B528_bss (NOLOAD) : { build/asm/main_8022B528.s.o(.bss); }
    .main_8022B53C 0x8022B53C : AT(0x0002C13C) { build/asm/data/main_8022B53C.bin.o(.data); }
    .main_8022B7B4 0x8022B7B4 : AT(0x0002C3B4) { FILL(0x00000000); build/asm/main_8022B7B4.s.o(.text); build/asm/main_8022B7B4.s.o(.rodata); build/asm/main_8022B7B4.s.o(.data); }
    .main_8022B7B4_bss (NOLOAD) : { build/asm/main_8022B7B4.s.o(.bss); }
    .main_8022B818 0x8022B818 : AT(0x0002C418) { build/asm/data/main_8022B818.bin.o(.data); }
    .main_8022C8EC 0x8022C8EC : AT(0x0002D4EC) { FILL(0x00000000); build/asm/main_8022C8EC.s.o(.text); build/asm/main_8022C8EC.s.o(.rodata); build/asm/main_8022C8EC.s.o(.data); }
    .main_8022C8EC_bss (NOLOAD) : { build/asm/main_8022C8EC.s.o(.bss); }
    .main_8022C910 0x8022C910 : AT(0x0002D510) { build/asm/data/main_8022C910.bin.o(.data); }
    .main_8022CB9C 0x8022CB9C : AT(0x0002D79C) { FILL(0x00000000); build/asm/main_8022CB9C.s.o(.text); build/asm/main_8022CB9C.s.o(.rodata); build/asm/main_8022CB9C.s.o(.data); }
    .main_8022CB9C_bss (NOLOAD) : { build/asm/main_8022CB9C.s.o(.bss); }
    .main_8022CC3C 0x8022CC3C : AT(0x0002D83C) { build/asm/data/main_8022CC3C.bin.o(.data); }
    .main_8022CFE8 0x8022CFE8 : AT(0x0002DBE8) { FILL(0x00000000); build/asm/main_8022CFE8.s.o(.text); build/asm/main_8022CFE8.s.o(.rodata); build/asm/main_8022CFE8.s.o(.data); }
    .main_8022CFE8_bss (NOLOAD) : { build/asm/main_8022CFE8.s.o(.bss); }
    .main_8022D130 0x8022D130 : AT(0x0002DD30) { build/asm/data/main_8022D130.bin.o(.data); }
    .main_8022D288 0x8022D288 : AT(0x0002DE88) { FILL(0x00000000); build/asm/main_8022D288.s.o(.text); build/asm/main_8022D288.s.o(.rodata); build/asm/main_8022D288.s.o(.data); }
    .main_8022D288_bss (NOLOAD) : { build/asm/main_8022D288.s.o(.bss); }
    .main_8022D294 0x8022D294 : AT(0x0002DE94) { build/asm/data/main_8022D294.bin.o(.data); }
    .main_8022DA84 0x8022DA84 : AT(0x0002E684) { FILL(0x00000000); build/asm/main_8022DA84.s.o(.text); build/asm/main_8022DA84.s.o(.rodata); build/asm/main_8022DA84.s.o(.data); }
    .main_8022DA84_bss (NOLOAD) : { build/asm/main_8022DA84.s.o(.bss); }
    .main_8022DAA8 0x8022DAA8 : AT(0x0002E6A8) { build/asm/data/main_8022DAA8.bin.o(.data); }
    .main_8022DFAC 0x8022DFAC : AT(0x0002EBAC) { FILL(0x00000000); build/asm/main_8022DFAC.s.o(.text); build/asm/main_8022DFAC.s.o(.rodata); build/asm/main_8022DFAC.s.o(.data); }
    .main_8022DFAC_bss (NOLOAD) : { build/asm/main_8022DFAC.s.o(.bss); }
    .main_8022DFD4 0x8022DFD4 : AT(0x0002EBD4) { build/asm/data/main_8022DFD4.bin.o(.data); }
    .main_8022E174 0x8022E174 : AT(0x0002ED74) { FILL(0x00000000); build/asm/main_8022E174.s.o(.text); build/asm/main_8022E174.s.o(.rodata); build/asm/main_8022E174.s.o(.data); }
    .main_8022E174_bss (NOLOAD) : { build/asm/main_8022E174.s.o(.bss); }
    .main_8022E240 0x8022E240 : AT(0x0002EE40) { build/asm/data/main_8022E240.bin.o(.data); }
    .main_8022E43C 0x8022E43C : AT(0x0002F03C) { FILL(0x00000000); build/asm/main_8022E43C.s.o(.text); build/asm/main_8022E43C.s.o(.rodata); build/asm/main_8022E43C.s.o(.data); }
    .main_8022E43C_bss (NOLOAD) : { build/asm/main_8022E43C.s.o(.bss); }
    .main_8022E480 0x8022E480 : AT(0x0002F080) { build/asm/data/main_8022E480.bin.o(.data); }
    .main_8022E7AC 0x8022E7AC : AT(0x0002F3AC) { FILL(0x00000000); build/asm/main_8022E7AC.s.o(.text); build/asm/main_8022E7AC.s.o(.rodata); build/asm/main_8022E7AC.s.o(.data); }
    .main_8022E7AC_bss (NOLOAD) : { build/asm/main_8022E7AC.s.o(.bss); }
    .main_8022E820 0x8022E820 : AT(0x0002F420) { build/asm/data/main_8022E820.bin.o(.data); }
    .main_8022F038 0x8022F038 : AT(0x0002FC38) { FILL(0x00000000); build/asm/main_8022F038.s.o(.text); build/asm/main_8022F038.s.o(.rodata); build/asm/main_8022F038.s.o(.data); }
    .main_8022F038_bss (NOLOAD) : { build/asm/main_8022F038.s.o(.bss); }
    .main_8022F07C 0x8022F07C : AT(0x0002FC7C) { build/asm/data/main_8022F07C.bin.o(.data); }
    .main_8022F17C 0x8022F17C : AT(0x0002FD7C) { FILL(0x00000000); build/asm/main_8022F17C.s.o(.text); build/asm/main_8022F17C.s.o(.rodata); build/asm/main_8022F17C.s.o(.data); }
    .main_8022F17C_bss (NOLOAD) : { build/asm/main_8022F17C.s.o(.bss); }
    .main_8022F1D4 0x8022F1D4 : AT(0x0002FDD4) { build/asm/data/main_8022F1D4.bin.o(.data); }
    .main_8022F518 0x8022F518 : AT(0x00030118) { FILL(0x00000000); build/asm/main_8022F518.s.o(.text); build/asm/main_8022F518.s.o(.rodata); build/asm/main_8022F518.s.o(.data); }
    .main_8022F518_bss (NOLOAD) : { build/asm/main_8022F518.s.o(.bss); }
    .main_8022F534 0x8022F534 : AT(0x00030134) { build/asm/data/main_8022F534.bin.o(.data); }
    .main_8022F618 0x8022F618 : AT(0x00030218) { FILL(0x00000000); build/asm/main_8022F618.s.o(.text); build/asm/main_8022F618.s.o(.rodata); build/asm/main_8022F618.s.o(.data); }
    .main_8022F618_bss (NOLOAD) : { build/asm/main_8022F618.s.o(.bss); }
    .main_8022F65C 0x8022F65C : AT(0x0003025C) { build/asm/data/main_8022F65C.bin.o(.data); }
    .main_8022FDAC 0x8022FDAC : AT(0x000309AC) { FILL(0x00000000); build/asm/main_8022FDAC.s.o(.text); build/asm/main_8022FDAC.s.o(.rodata); build/asm/main_8022FDAC.s.o(.data); }
    .main_8022FDAC_bss (NOLOAD) : { build/asm/main_8022FDAC.s.o(.bss); }
    .main_8022FE54 0x8022FE54 : AT(0x00030A54) { build/asm/data/main_8022FE54.bin.o(.data); }
    .main_80230020 0x80230020 : AT(0x00030C20) { FILL(0x00000000); build/asm/main_80230020.s.o(.text); build/asm/main_80230020.s.o(.rodata); build/asm/main_80230020.s.o(.data); }
    .main_80230020_bss (NOLOAD) : { build/asm/main_80230020.s.o(.bss); }
    .main_80230038 0x80230038 : AT(0x00030C38) { build/asm/data/main_80230038.bin.o(.data); }
    .main_80230428 0x80230428 : AT(0x00031028) { FILL(0x00000000); build/asm/main_80230428.s.o(.text); build/asm/main_80230428.s.o(.rodata); build/asm/main_80230428.s.o(.data); }
    .main_80230428_bss (NOLOAD) : { build/asm/main_80230428.s.o(.bss); }
    .main_80230444 0x80230444 : AT(0x00031044) { build/asm/data/main_80230444.bin.o(.data); }
    .main_8023069C 0x8023069C : AT(0x0003129C) { FILL(0x00000000); build/asm/main_8023069C.s.o(.text); build/asm/main_8023069C.s.o(.rodata); build/asm/main_8023069C.s.o(.data); }
    .main_8023069C_bss (NOLOAD) : { build/asm/main_8023069C.s.o(.bss); }
    .main_802306A0 0x802306A0 : AT(0x000312A0) { build/asm/data/main_802306A0.bin.o(.data); }
    .main_80230884 0x80230884 : AT(0x00031484) { FILL(0x00000000); build/asm/main_80230884.s.o(.text); build/asm/main_80230884.s.o(.rodata); build/asm/main_80230884.s.o(.data); }
    .main_80230884_bss (NOLOAD) : { build/asm/main_80230884.s.o(.bss); }
    .main_802308F0 0x802308F0 : AT(0x000314F0) { build/asm/data/main_802308F0.bin.o(.data); }
    .main_80230E88 0x80230E88 : AT(0x00031A88) { FILL(0x00000000); build/asm/main_80230E88.s.o(.text); build/asm/main_80230E88.s.o(.rodata); build/asm/main_80230E88.s.o(.data); }
    .main_80230E88_bss (NOLOAD) : { build/asm/main_80230E88.s.o(.bss); }
    .main_80230ED0 0x80230ED0 : AT(0x00031AD0) { build/asm/data/main_80230ED0.bin.o(.data); }
    .main_802314C4 0x802314C4 : AT(0x000320C4) { FILL(0x00000000); build/asm/main_802314C4.s.o(.text); build/asm/main_802314C4.s.o(.rodata); build/asm/main_802314C4.s.o(.data); }
    .main_802314C4_bss (NOLOAD) : { build/asm/main_802314C4.s.o(.bss); }
    .main_802314D0 0x802314D0 : AT(0x000320D0) { build/asm/data/main_802314D0.bin.o(.data); }
    .main_80231714 0x80231714 : AT(0x00032314) { FILL(0x00000000); build/asm/main_80231714.s.o(.text); build/asm/main_80231714.s.o(.rodata); build/asm/main_80231714.s.o(.data); }
    .main_80231714_bss (NOLOAD) : { build/asm/main_80231714.s.o(.bss); }
    .main_80231748 0x80231748 : AT(0x00032348) { build/asm/data/main_80231748.bin.o(.data); }
    .main_802317C0 0x802317C0 : AT(0x000323C0) { FILL(0x00000000); build/asm/main_802317C0.s.o(.text); build/asm/main_802317C0.s.o(.rodata); build/asm/main_802317C0.s.o(.data); }
    .main_802317C0_bss (NOLOAD) : { build/asm/main_802317C0.s.o(.bss); }
    .main_802317C8 0x802317C8 : AT(0x000323C8) { build/asm/data/main_802317C8.bin.o(.data); }
    .main_80231CC8 0x80231CC8 : AT(0x000328C8) { FILL(0x00000000); build/asm/main_80231CC8.s.o(.text); build/asm/main_80231CC8.s.o(.rodata); build/asm/main_80231CC8.s.o(.data); }
    .main_80231CC8_bss (NOLOAD) : { build/asm/main_80231CC8.s.o(.bss); }
    .main_80231CD8 0x80231CD8 : AT(0x000328D8) { build/asm/data/main_80231CD8.bin.o(.data); }
    .main_80231E4C 0x80231E4C : AT(0x00032A4C) { FILL(0x00000000); build/asm/main_80231E4C.s.o(.text); build/asm/main_80231E4C.s.o(.rodata); build/asm/main_80231E4C.s.o(.data); }
    .main_80231E4C_bss (NOLOAD) : { build/asm/main_80231E4C.s.o(.bss); }
    .main_80231E60 0x80231E60 : AT(0x00032A60) { build/asm/data/main_80231E60.bin.o(.data); }
    .main_80232204 0x80232204 : AT(0x00032E04) { FILL(0x00000000); build/asm/main_80232204.s.o(.text); build/asm/main_80232204.s.o(.rodata); build/asm/main_80232204.s.o(.data); }
    .main_80232204_bss (NOLOAD) : { build/asm/main_80232204.s.o(.bss); }
    .main_80232208 0x80232208 : AT(0x00032E08) { build/asm/data/main_80232208.bin.o(.data); }
    .main_802323B4 0x802323B4 : AT(0x00032FB4) { FILL(0x00000000); build/asm/main_802323B4.s.o(.text); build/asm/main_802323B4.s.o(.rodata); build/asm/main_802323B4.s.o(.data); }
    .main_802323B4_bss (NOLOAD) : { build/asm/main_802323B4.s.o(.bss); }
    .main_80232404 0x80232404 : AT(0x00033004) { build/asm/data/main_80232404.bin.o(.data); }
    .main_80232440 0x80232440 : AT(0x00033040) { FILL(0x00000000); build/asm/main_80232440.s.o(.text); build/asm/main_80232440.s.o(.rodata); build/asm/main_80232440.s.o(.data); }
    .main_80232440_bss (NOLOAD) : { build/asm/main_80232440.s.o(.bss); }
    .main_802324B0 0x802324B0 : AT(0x000330B0) { build/asm/data/main_802324B0.bin.o(.data); }
    .main_80232A4C 0x80232A4C : AT(0x0003364C) { FILL(0x00000000); build/asm/main_80232A4C.s.o(.text); build/asm/main_80232A4C.s.o(.rodata); build/asm/main_80232A4C.s.o(.data); }
    .main_80232A4C_bss (NOLOAD) : { build/asm/main_80232A4C.s.o(.bss); }
    .main_80232A84 0x80232A84 : AT(0x00033684) { build/asm/data/main_80232A84.bin.o(.data); }
    .main_802337B4 0x802337B4 : AT(0x000343B4) { FILL(0x00000000); build/asm/main_802337B4.s.o(.text); build/asm/main_802337B4.s.o(.rodata); build/asm/main_802337B4.s.o(.data); }
    .main_802337B4_bss (NOLOAD) : { build/asm/main_802337B4.s.o(.bss); }
    .main_802337C0 0x802337C0 : AT(0x000343C0) { build/asm/data/main_802337C0.bin.o(.data); }
    .main_80233F08 0x80233F08 : AT(0x00034B08) { FILL(0x00000000); build/asm/main_80233F08.s.o(.text); build/asm/main_80233F08.s.o(.rodata); build/asm/main_80233F08.s.o(.data); }
    .main_80233F08_bss (NOLOAD) : { build/asm/main_80233F08.s.o(.bss); }
    .main_80233F44 0x80233F44 : AT(0x00034B44) { build/asm/data/main_80233F44.bin.o(.data); }
    .main_80234318 0x80234318 : AT(0x00034F18) { FILL(0x00000000); build/asm/main_80234318.s.o(.text); build/asm/main_80234318.s.o(.rodata); build/asm/main_80234318.s.o(.data); }
    .main_80234318_bss (NOLOAD) : { build/asm/main_80234318.s.o(.bss); }
    .main_80234338 0x80234338 : AT(0x00034F38) { build/asm/data/main_80234338.bin.o(.data); }
    .main_8023492C 0x8023492C : AT(0x0003552C) { FILL(0x00000000); build/asm/main_8023492C.s.o(.text); build/asm/main_8023492C.s.o(.rodata); build/asm/main_8023492C.s.o(.data); }
    .main_8023492C_bss (NOLOAD) : { build/asm/main_8023492C.s.o(.bss); }
    .main_80234A58 0x80234A58 : AT(0x00035658) { build/asm/data/main_80234A58.bin.o(.data); }
    .main_80234CE4 0x80234CE4 : AT(0x000358E4) { FILL(0x00000000); build/asm/main_80234CE4.s.o(.text); build/asm/main_80234CE4.s.o(.rodata); build/asm/main_80234CE4.s.o(.data); }
    .main_80234CE4_bss (NOLOAD) : { build/asm/main_80234CE4.s.o(.bss); }
    .main_80234D14 0x80234D14 : AT(0x00035914) { build/asm/data/main_80234D14.bin.o(.data); }
    .main_80235188 0x80235188 : AT(0x00035D88) { FILL(0x00000000); build/asm/main_80235188.s.o(.text); build/asm/main_80235188.s.o(.rodata); build/asm/main_80235188.s.o(.data); }
    .main_80235188_bss (NOLOAD) : { build/asm/main_80235188.s.o(.bss); }
    .main_80235234 0x80235234 : AT(0x00035E34) { build/asm/data/main_80235234.bin.o(.data); }
    .main_80235508 0x80235508 : AT(0x00036108) { FILL(0x00000000); build/asm/main_80235508.s.o(.text); build/asm/main_80235508.s.o(.rodata); build/asm/main_80235508.s.o(.data); }
    .main_80235508_bss (NOLOAD) : { build/asm/main_80235508.s.o(.bss); }
    .main_80235548 0x80235548 : AT(0x00036148) { build/asm/data/main_80235548.bin.o(.data); }
    .main_80235628 0x80235628 : AT(0x00036228) { FILL(0x00000000); build/asm/main_80235628.s.o(.text); build/asm/main_80235628.s.o(.rodata); build/asm/main_80235628.s.o(.data); }
    .main_80235628_bss (NOLOAD) : { build/asm/main_80235628.s.o(.bss); }
    .main_80235630 0x80235630 : AT(0x00036230) { build/asm/data/main_80235630.bin.o(.data); }
    .main_80235924 0x80235924 : AT(0x00036524) { FILL(0x00000000); build/asm/main_80235924.s.o(.text); build/asm/main_80235924.s.o(.rodata); build/asm/main_80235924.s.o(.data); }
    .main_80235924_bss (NOLOAD) : { build/asm/main_80235924.s.o(.bss); }
    .main_80235964 0x80235964 : AT(0x00036564) { build/asm/data/main_80235964.bin.o(.data); }
    .main_80235A44 0x80235A44 : AT(0x00036644) { FILL(0x00000000); build/asm/main_80235A44.s.o(.text); build/asm/main_80235A44.s.o(.rodata); build/asm/main_80235A44.s.o(.data); }
    .main_80235A44_bss (NOLOAD) : { build/asm/main_80235A44.s.o(.bss); }
    .main_80235A48 0x80235A48 : AT(0x00036648) { build/asm/data/main_80235A48.bin.o(.data); }
    .main_80235B60 0x80235B60 : AT(0x00036760) { FILL(0x00000000); build/asm/main_80235B60.s.o(.text); build/asm/main_80235B60.s.o(.rodata); build/asm/main_80235B60.s.o(.data); }
    .main_80235B60_bss (NOLOAD) : { build/asm/main_80235B60.s.o(.bss); }
    .main_80235C30 0x80235C30 : AT(0x00036830) { build/asm/data/main_80235C30.bin.o(.data); }
    .main_80236174 0x80236174 : AT(0x00036D74) { FILL(0x00000000); build/asm/main_80236174.s.o(.text); build/asm/main_80236174.s.o(.rodata); build/asm/main_80236174.s.o(.data); }
    .main_80236174_bss (NOLOAD) : { build/asm/main_80236174.s.o(.bss); }
    .main_8023618C 0x8023618C : AT(0x00036D8C) { build/asm/data/main_8023618C.bin.o(.data); }
    .main_802363E0 0x802363E0 : AT(0x00036FE0) { FILL(0x00000000); build/asm/main_802363E0.s.o(.text); build/asm/main_802363E0.s.o(.rodata); build/asm/main_802363E0.s.o(.data); }
    .main_802363E0_bss (NOLOAD) : { build/asm/main_802363E0.s.o(.bss); }
    .main_80236480 0x80236480 : AT(0x00037080) { build/asm/data/main_80236480.bin.o(.data); }
    .main_8023695C 0x8023695C : AT(0x0003755C) { FILL(0x00000000); build/asm/main_8023695C.s.o(.text); build/asm/main_8023695C.s.o(.rodata); build/asm/main_8023695C.s.o(.data); }
    .main_8023695C_bss (NOLOAD) : { build/asm/main_8023695C.s.o(.bss); }
    .main_80236998 0x80236998 : AT(0x00037598) { build/asm/data/main_80236998.bin.o(.data); }
    .main_80236FD0 0x80236FD0 : AT(0x00037BD0) { FILL(0x00000000); build/asm/main_80236FD0.s.o(.text); build/asm/main_80236FD0.s.o(.rodata); build/asm/main_80236FD0.s.o(.data); }
    .main_80236FD0_bss (NOLOAD) : { build/asm/main_80236FD0.s.o(.bss); }
    .main_802370FC 0x802370FC : AT(0x00037CFC) { build/asm/data/main_802370FC.bin.o(.data); }
    .main_80237CF4 0x80237CF4 : AT(0x000388F4) { FILL(0x00000000); build/asm/main_80237CF4.s.o(.text); build/asm/main_80237CF4.s.o(.rodata); build/asm/main_80237CF4.s.o(.data); }
    .main_80237CF4_bss (NOLOAD) : { build/asm/main_80237CF4.s.o(.bss); }
    .main_80237D04 0x80237D04 : AT(0x00038904) { build/asm/data/main_80237D04.bin.o(.data); }
    .main_80237E6C 0x80237E6C : AT(0x00038A6C) { FILL(0x00000000); build/asm/main_80237E6C.s.o(.text); build/asm/main_80237E6C.s.o(.rodata); build/asm/main_80237E6C.s.o(.data); }
    .main_80237E6C_bss (NOLOAD) : { build/asm/main_80237E6C.s.o(.bss); }
    .main_80237F78 0x80237F78 : AT(0x00038B78) { build/asm/data/main_80237F78.bin.o(.data); }
    .main_802391B4 0x802391B4 : AT(0x00039DB4) { FILL(0x00000000); build/asm/main_802391B4.s.o(.text); build/asm/main_802391B4.s.o(.rodata); build/asm/main_802391B4.s.o(.data); }
    .main_802391B4_bss (NOLOAD) : { build/asm/main_802391B4.s.o(.bss); }
    .main_80239308 0x80239308 : AT(0x00039F08) { build/asm/data/main_80239308.bin.o(.data); }
    .main_80239400 0x80239400 : AT(0x0003A000) { FILL(0x00000000); build/asm/main_80239400.s.o(.text); build/asm/main_80239400.s.o(.rodata); build/asm/main_80239400.s.o(.data); }
    .main_80239400_bss (NOLOAD) : { build/asm/main_80239400.s.o(.bss); }
    .main_80239440 0x80239440 : AT(0x0003A040) { build/asm/data/main_80239440.bin.o(.data); }
    .main_802398F4 0x802398F4 : AT(0x0003A4F4) { FILL(0x00000000); build/asm/main_802398F4.s.o(.text); build/asm/main_802398F4.s.o(.rodata); build/asm/main_802398F4.s.o(.data); }
    .main_802398F4_bss (NOLOAD) : { build/asm/main_802398F4.s.o(.bss); }
    .main_80239984 0x80239984 : AT(0x0003A584) { build/asm/data/main_80239984.bin.o(.data); }
    .main_80239C18 0x80239C18 : AT(0x0003A818) { FILL(0x00000000); build/asm/main_80239C18.s.o(.text); build/asm/main_80239C18.s.o(.rodata); build/asm/main_80239C18.s.o(.data); }
    .main_80239C18_bss (NOLOAD) : { build/asm/main_80239C18.s.o(.bss); }
    .main_80239CC0 0x80239CC0 : AT(0x0003A8C0) { build/asm/data/main_80239CC0.bin.o(.data); }
    .main_8023A5C4 0x8023A5C4 : AT(0x0003B1C4) { FILL(0x00000000); build/asm/main_8023A5C4.s.o(.text); build/asm/main_8023A5C4.s.o(.rodata); build/asm/main_8023A5C4.s.o(.data); }
    .main_8023A5C4_bss (NOLOAD) : { build/asm/main_8023A5C4.s.o(.bss); }
    .main_8023A65C 0x8023A65C : AT(0x0003B25C) { build/asm/data/main_8023A65C.bin.o(.data); }
    .main_8023A938 0x8023A938 : AT(0x0003B538) { FILL(0x00000000); build/asm/main_8023A938.s.o(.text); build/asm/main_8023A938.s.o(.rodata); build/asm/main_8023A938.s.o(.data); }
    .main_8023A938_bss (NOLOAD) : { build/asm/main_8023A938.s.o(.bss); }
    .main_8023A994 0x8023A994 : AT(0x0003B594) { build/asm/data/main_8023A994.bin.o(.data); }
    .main_8023AC1C 0x8023AC1C : AT(0x0003B81C) { FILL(0x00000000); build/asm/main_8023AC1C.s.o(.text); build/asm/main_8023AC1C.s.o(.rodata); build/asm/main_8023AC1C.s.o(.data); }
    .main_8023AC1C_bss (NOLOAD) : { build/asm/main_8023AC1C.s.o(.bss); }
    .main_8023AC20 0x8023AC20 : AT(0x0003B820) { build/asm/data/main_8023AC20.bin.o(.data); }
    .main_8023AE8C 0x8023AE8C : AT(0x0003BA8C) { FILL(0x00000000); build/asm/main_8023AE8C.s.o(.text); build/asm/main_8023AE8C.s.o(.rodata); build/asm/main_8023AE8C.s.o(.data); }
    .main_8023AE8C_bss (NOLOAD) : { build/asm/main_8023AE8C.s.o(.bss); }
    .main_8023AEA0 0x8023AEA0 : AT(0x0003BAA0) { build/asm/data/main_8023AEA0.bin.o(.data); }
    .main_8023B5F4 0x8023B5F4 : AT(0x0003C1F4) { FILL(0x00000000); build/asm/main_8023B5F4.s.o(.text); build/asm/main_8023B5F4.s.o(.rodata); build/asm/main_8023B5F4.s.o(.data); }
    .main_8023B5F4_bss (NOLOAD) : { build/asm/main_8023B5F4.s.o(.bss); }
    .main_8023B618 0x8023B618 : AT(0x0003C218) { build/asm/data/main_8023B618.bin.o(.data); }
    .main_8023C1E0 0x8023C1E0 : AT(0x0003CDE0) { FILL(0x00000000); build/asm/main_8023C1E0.s.o(.text); build/asm/main_8023C1E0.s.o(.rodata); build/asm/main_8023C1E0.s.o(.data); }
    .main_8023C1E0_bss (NOLOAD) : { build/asm/main_8023C1E0.s.o(.bss); }
    .main_8023C2E4 0x8023C2E4 : AT(0x0003CEE4) { build/asm/data/main_8023C2E4.bin.o(.data); }
    .main_8023C4B4 0x8023C4B4 : AT(0x0003D0B4) { FILL(0x00000000); build/asm/main_8023C4B4.s.o(.text); build/asm/main_8023C4B4.s.o(.rodata); build/asm/main_8023C4B4.s.o(.data); }
    .main_8023C4B4_bss (NOLOAD) : { build/asm/main_8023C4B4.s.o(.bss); }
    .main_8023C518 0x8023C518 : AT(0x0003D118) { build/asm/data/main_8023C518.bin.o(.data); }
    .main_8023ED88 0x8023ED88 : AT(0x0003F988) { FILL(0x00000000); build/asm/main_8023ED88.s.o(.text); build/asm/main_8023ED88.s.o(.rodata); build/asm/main_8023ED88.s.o(.data); }
    .main_8023ED88_bss (NOLOAD) : { build/asm/main_8023ED88.s.o(.bss); }
    .main_8023EDBC 0x8023EDBC : AT(0x0003F9BC) { build/asm/data/main_8023EDBC.bin.o(.data); }
    .main_8023EE28 0x8023EE28 : AT(0x0003FA28) { FILL(0x00000000); build/asm/main_8023EE28.s.o(.text); build/asm/main_8023EE28.s.o(.rodata); build/asm/main_8023EE28.s.o(.data); }
    .main_8023EE28_bss (NOLOAD) : { build/asm/main_8023EE28.s.o(.bss); }
    .main_8023EEEC 0x8023EEEC : AT(0x0003FAEC) { build/asm/data/main_8023EEEC.bin.o(.data); }
    .main_8023F69C 0x8023F69C : AT(0x0004029C) { FILL(0x00000000); build/asm/main_8023F69C.s.o(.text); build/asm/main_8023F69C.s.o(.rodata); build/asm/main_8023F69C.s.o(.data); }
    .main_8023F69C_bss (NOLOAD) : { build/asm/main_8023F69C.s.o(.bss); }
    .main_8023F6AC 0x8023F6AC : AT(0x000402AC) { build/asm/data/main_8023F6AC.bin.o(.data); }
    .main_8023F76C 0x8023F76C : AT(0x0004036C) { FILL(0x00000000); build/asm/main_8023F76C.s.o(.text); build/asm/main_8023F76C.s.o(.rodata); build/asm/main_8023F76C.s.o(.data); }
    .main_8023F76C_bss (NOLOAD) : { build/asm/main_8023F76C.s.o(.bss); }
    .main_8023F788 0x8023F788 : AT(0x00040388) { build/asm/data/main_8023F788.bin.o(.data); }
    .main_8023FCBC 0x8023FCBC : AT(0x000408BC) { FILL(0x00000000); build/asm/main_8023FCBC.s.o(.text); build/asm/main_8023FCBC.s.o(.rodata); build/asm/main_8023FCBC.s.o(.data); }
    .main_8023FCBC_bss (NOLOAD) : { build/asm/main_8023FCBC.s.o(.bss); }
    .main_8023FCC8 0x8023FCC8 : AT(0x000408C8) { build/asm/data/main_8023FCC8.bin.o(.data); }
    .main_8023FEA0 0x8023FEA0 : AT(0x00040AA0) { FILL(0x00000000); build/asm/main_8023FEA0.s.o(.text); build/asm/main_8023FEA0.s.o(.rodata); build/asm/main_8023FEA0.s.o(.data); }
    .main_8023FEA0_bss (NOLOAD) : { build/asm/main_8023FEA0.s.o(.bss); }
    .main_8023FEA4 0x8023FEA4 : AT(0x00040AA4) { build/asm/data/main_8023FEA4.bin.o(.data); }
    .main_802406B8 0x802406B8 : AT(0x000412B8) { FILL(0x00000000); build/asm/main_802406B8.s.o(.text); build/asm/main_802406B8.s.o(.rodata); build/asm/main_802406B8.s.o(.data); }
    .main_802406B8_bss (NOLOAD) : { build/asm/main_802406B8.s.o(.bss); }
    .main_802406C8 0x802406C8 : AT(0x000412C8) { build/asm/data/main_802406C8.bin.o(.data); }
    .main_802408B4 0x802408B4 : AT(0x000414B4) { FILL(0x00000000); build/asm/main_802408B4.s.o(.text); build/asm/main_802408B4.s.o(.rodata); build/asm/main_802408B4.s.o(.data); }
    .main_802408B4_bss (NOLOAD) : { build/asm/main_802408B4.s.o(.bss); }
    .main_802408FC 0x802408FC : AT(0x000414FC) { build/asm/data/main_802408FC.bin.o(.data); }
    .main_80240944 0x80240944 : AT(0x00041544) { FILL(0x00000000); build/asm/main_80240944.s.o(.text); build/asm/main_80240944.s.o(.rodata); build/asm/main_80240944.s.o(.data); }
    .main_80240944_bss (NOLOAD) : { build/asm/main_80240944.s.o(.bss); }
    .main_8024094C 0x8024094C : AT(0x0004154C) { build/asm/data/main_8024094C.bin.o(.data); }
    .main_80240A6C 0x80240A6C : AT(0x0004166C) { FILL(0x00000000); build/asm/main_80240A6C.s.o(.text); build/asm/main_80240A6C.s.o(.rodata); build/asm/main_80240A6C.s.o(.data); }
    .main_80240A6C_bss (NOLOAD) : { build/asm/main_80240A6C.s.o(.bss); }
    .main_80240A74 0x80240A74 : AT(0x00041674) { build/asm/data/main_80240A74.bin.o(.data); }
    .main_80240AAC 0x80240AAC : AT(0x000416AC) { FILL(0x00000000); build/asm/main_80240AAC.s.o(.text); build/asm/main_80240AAC.s.o(.rodata); build/asm/main_80240AAC.s.o(.data); }
    .main_80240AAC_bss (NOLOAD) : { build/asm/main_80240AAC.s.o(.bss); }
    .main_80240AF4 0x80240AF4 : AT(0x000416F4) { build/asm/data/main_80240AF4.bin.o(.data); }
    .main_802410E0 0x802410E0 : AT(0x00041CE0) { FILL(0x00000000); build/asm/main_802410E0.s.o(.text); build/asm/main_802410E0.s.o(.rodata); build/asm/main_802410E0.s.o(.data); }
    .main_802410E0_bss (NOLOAD) : { build/asm/main_802410E0.s.o(.bss); }
    .main_80241158 0x80241158 : AT(0x00041D58) { build/asm/data/main_80241158.bin.o(.data); }
    .main_80241FAC 0x80241FAC : AT(0x00042BAC) { FILL(0x00000000); build/asm/main_80241FAC.s.o(.text); build/asm/main_80241FAC.s.o(.rodata); build/asm/main_80241FAC.s.o(.data); }
    .main_80241FAC_bss (NOLOAD) : { build/asm/main_80241FAC.s.o(.bss); }
    .main_80241FC4 0x80241FC4 : AT(0x00042BC4) { build/asm/data/main_80241FC4.bin.o(.data); }
    .main_80242850 0x80242850 : AT(0x00043450) { FILL(0x00000000); build/asm/main_80242850.s.o(.text); build/asm/main_80242850.s.o(.rodata); build/asm/main_80242850.s.o(.data); }
    .main_80242850_bss (NOLOAD) : { build/asm/main_80242850.s.o(.bss); }
    .main_8024299C 0x8024299C : AT(0x0004359C) { build/asm/data/main_8024299C.bin.o(.data); }
    .main_80242A80 0x80242A80 : AT(0x00043680) { FILL(0x00000000); build/asm/main_80242A80.s.o(.text); build/asm/main_80242A80.s.o(.rodata); build/asm/main_80242A80.s.o(.data); }
    .main_80242A80_bss (NOLOAD) : { build/asm/main_80242A80.s.o(.bss); }
    .main_80242AB4 0x80242AB4 : AT(0x000436B4) { build/asm/data/main_80242AB4.bin.o(.data); }
    .main_80242B04 0x80242B04 : AT(0x00043704) { FILL(0x00000000); build/asm/main_80242B04.s.o(.text); build/asm/main_80242B04.s.o(.rodata); build/asm/main_80242B04.s.o(.data); }
    .main_80242B04_bss (NOLOAD) : { build/asm/main_80242B04.s.o(.bss); }
    .main_80242BE4 0x80242BE4 : AT(0x000437E4) { build/asm/data/main_80242BE4.bin.o(.data); }
    .main_80242D80 0x80242D80 : AT(0x00043980) { FILL(0x00000000); build/asm/main_80242D80.s.o(.text); build/asm/main_80242D80.s.o(.rodata); build/asm/main_80242D80.s.o(.data); }
    .main_80242D80_bss (NOLOAD) : { build/asm/main_80242D80.s.o(.bss); }
    .main_80242FA8 0x80242FA8 : AT(0x00043BA8) { build/asm/data/main_80242FA8.bin.o(.data); }
    .main_8024313C 0x8024313C : AT(0x00043D3C) { FILL(0x00000000); build/asm/main_8024313C.s.o(.text); build/asm/main_8024313C.s.o(.rodata); build/asm/main_8024313C.s.o(.data); }
    .main_8024313C_bss (NOLOAD) : { build/asm/main_8024313C.s.o(.bss); }
    .main_80243150 0x80243150 : AT(0x00043D50) { build/asm/data/main_80243150.bin.o(.data); }
    .main_802431E0 0x802431E0 : AT(0x00043DE0) { FILL(0x00000000); build/asm/main_802431E0.s.o(.text); build/asm/main_802431E0.s.o(.rodata); build/asm/main_802431E0.s.o(.data); }
    .main_802431E0_bss (NOLOAD) : { build/asm/main_802431E0.s.o(.bss); }
    .main_80243238 0x80243238 : AT(0x00043E38) { build/asm/data/main_80243238.bin.o(.data); }
    .main_802434E8 0x802434E8 : AT(0x000440E8) { FILL(0x00000000); build/asm/main_802434E8.s.o(.text); build/asm/main_802434E8.s.o(.rodata); build/asm/main_802434E8.s.o(.data); }
    .main_802434E8_bss (NOLOAD) : { build/asm/main_802434E8.s.o(.bss); }
    .main_802435D4 0x802435D4 : AT(0x000441D4) { build/asm/data/main_802435D4.bin.o(.data); }
    .main_80243774 0x80243774 : AT(0x00044374) { FILL(0x00000000); build/asm/main_80243774.s.o(.text); build/asm/main_80243774.s.o(.rodata); build/asm/main_80243774.s.o(.data); }
    .main_80243774_bss (NOLOAD) : { build/asm/main_80243774.s.o(.bss); }
    .main_80243834 0x80243834 : AT(0x00044434) { build/asm/data/main_80243834.bin.o(.data); }
    .main_80243A5C 0x80243A5C : AT(0x0004465C) { FILL(0x00000000); build/asm/main_80243A5C.s.o(.text); build/asm/main_80243A5C.s.o(.rodata); build/asm/main_80243A5C.s.o(.data); }
    .main_80243A5C_bss (NOLOAD) : { build/asm/main_80243A5C.s.o(.bss); }
    .main_80243AEC 0x80243AEC : AT(0x000446EC) { build/asm/data/main_80243AEC.bin.o(.data); }
    .main_80243B70 0x80243B70 : AT(0x00044770) { FILL(0x00000000); build/asm/main_80243B70.s.o(.text); build/asm/main_80243B70.s.o(.rodata); build/asm/main_80243B70.s.o(.data); }
    .main_80243B70_bss (NOLOAD) : { build/asm/main_80243B70.s.o(.bss); }
    .main_80243BBC 0x80243BBC : AT(0x000447BC) { build/asm/data/main_80243BBC.bin.o(.data); }
    .main_80243C88 0x80243C88 : AT(0x00044888) { FILL(0x00000000); build/asm/main_80243C88.s.o(.text); build/asm/main_80243C88.s.o(.rodata); build/asm/main_80243C88.s.o(.data); }
    .main_80243C88_bss (NOLOAD) : { build/asm/main_80243C88.s.o(.bss); }
    .main_80243C8C 0x80243C8C : AT(0x0004488C) { build/asm/data/main_80243C8C.bin.o(.data); }
    .main_802447FC 0x802447FC : AT(0x000453FC) { FILL(0x00000000); build/asm/main_802447FC.s.o(.text); build/asm/main_802447FC.s.o(.rodata); build/asm/main_802447FC.s.o(.data); }
    .main_802447FC_bss (NOLOAD) : { build/asm/main_802447FC.s.o(.bss); }
    .main_80244804 0x80244804 : AT(0x00045404) { build/asm/data/main_80244804.bin.o(.data); }
    .main_80244AB8 0x80244AB8 : AT(0x000456B8) { FILL(0x00000000); build/asm/main_80244AB8.s.o(.text); build/asm/main_80244AB8.s.o(.rodata); build/asm/main_80244AB8.s.o(.data); }
    .main_80244AB8_bss (NOLOAD) : { build/asm/main_80244AB8.s.o(.bss); }
    .main_80244CD8 0x80244CD8 : AT(0x000458D8) { build/asm/data/main_80244CD8.bin.o(.data); }
    .main_80244D54 0x80244D54 : AT(0x00045954) { FILL(0x00000000); build/asm/main_80244D54.s.o(.text); build/asm/main_80244D54.s.o(.rodata); build/asm/main_80244D54.s.o(.data); }
    .main_80244D54_bss (NOLOAD) : { build/asm/main_80244D54.s.o(.bss); }
    .main_80244DD0 0x80244DD0 : AT(0x000459D0) { build/asm/data/main_80244DD0.bin.o(.data); }
    .main_80244F70 0x80244F70 : AT(0x00045B70) { FILL(0x00000000); build/asm/main_80244F70.s.o(.text); build/asm/main_80244F70.s.o(.rodata); build/asm/main_80244F70.s.o(.data); }
    .main_80244F70_bss (NOLOAD) : { build/asm/main_80244F70.s.o(.bss); }
    .main_80244FF0 0x80244FF0 : AT(0x00045BF0) { build/asm/data/main_80244FF0.bin.o(.data); }
    .main_80245024 0x80245024 : AT(0x00045C24) { FILL(0x00000000); build/asm/main_80245024.s.o(.text); build/asm/main_80245024.s.o(.rodata); build/asm/main_80245024.s.o(.data); }
    .main_80245024_bss (NOLOAD) : { build/asm/main_80245024.s.o(.bss); }
    .main_80245070 0x80245070 : AT(0x00045C70) { build/asm/data/main_80245070.bin.o(.data); }
    .main_8024528C 0x8024528C : AT(0x00045E8C) { FILL(0x00000000); build/asm/main_8024528C.s.o(.text); build/asm/main_8024528C.s.o(.rodata); build/asm/main_8024528C.s.o(.data); }
    .main_8024528C_bss (NOLOAD) : { build/asm/main_8024528C.s.o(.bss); }
    .main_80245364 0x80245364 : AT(0x00045F64) { build/asm/data/main_80245364.bin.o(.data); }
    .main_80246114 0x80246114 : AT(0x00046D14) { FILL(0x00000000); build/asm/main_80246114.s.o(.text); build/asm/main_80246114.s.o(.rodata); build/asm/main_80246114.s.o(.data); }
    .main_80246114_bss (NOLOAD) : { build/asm/main_80246114.s.o(.bss); }
    .main_80246138 0x80246138 : AT(0x00046D38) { build/asm/data/main_80246138.bin.o(.data); }
    .main_802461E8 0x802461E8 : AT(0x00046DE8) { FILL(0x00000000); build/asm/main_802461E8.s.o(.text); build/asm/main_802461E8.s.o(.rodata); build/asm/main_802461E8.s.o(.data); }
    .main_802461E8_bss (NOLOAD) : { build/asm/main_802461E8.s.o(.bss); }
    .main_802461FC 0x802461FC : AT(0x00046DFC) { build/asm/data/main_802461FC.bin.o(.data); }
    .main_8024629C 0x8024629C : AT(0x00046E9C) { FILL(0x00000000); build/asm/main_8024629C.s.o(.text); build/asm/main_8024629C.s.o(.rodata); build/asm/main_8024629C.s.o(.data); }
    .main_8024629C_bss (NOLOAD) : { build/asm/main_8024629C.s.o(.bss); }
    .main_802462DC 0x802462DC : AT(0x00046EDC) { build/asm/data/main_802462DC.bin.o(.data); }
    .main_802468E0 0x802468E0 : AT(0x000474E0) { FILL(0x00000000); build/asm/main_802468E0.s.o(.text); build/asm/main_802468E0.s.o(.rodata); build/asm/main_802468E0.s.o(.data); }
    .main_802468E0_bss (NOLOAD) : { build/asm/main_802468E0.s.o(.bss); }
    .main_802468E8 0x802468E8 : AT(0x000474E8) { build/asm/data/main_802468E8.bin.o(.data); }
    .main_80246AB4 0x80246AB4 : AT(0x000476B4) { FILL(0x00000000); build/asm/main_80246AB4.s.o(.text); build/asm/main_80246AB4.s.o(.rodata); build/asm/main_80246AB4.s.o(.data); }
    .main_80246AB4_bss (NOLOAD) : { build/asm/main_80246AB4.s.o(.bss); }
    .main_80246AB8 0x80246AB8 : AT(0x000476B8) { build/asm/data/main_80246AB8.bin.o(.data); }
    .main_80247F80 0x80247F80 : AT(0x00048B80) { FILL(0x00000000); build/asm/main_80247F80.s.o(.text); build/asm/main_80247F80.s.o(.rodata); build/asm/main_80247F80.s.o(.data); }
    .main_80247F80_bss (NOLOAD) : { build/asm/main_80247F80.s.o(.bss); }
    .main_80247FE4 0x80247FE4 : AT(0x00048BE4) { build/asm/data/main_80247FE4.bin.o(.data); }
    .main_802487E0 0x802487E0 : AT(0x000493E0) { FILL(0x00000000); build/asm/main_802487E0.s.o(.text); build/asm/main_802487E0.s.o(.rodata); build/asm/main_802487E0.s.o(.data); }
    .main_802487E0_bss (NOLOAD) : { build/asm/main_802487E0.s.o(.bss); }
    .main_802487F4 0x802487F4 : AT(0x000493F4) { build/asm/data/main_802487F4.bin.o(.data); }
    .main_80249170 0x80249170 : AT(0x00049D70) { FILL(0x00000000); build/asm/main_80249170.s.o(.text); build/asm/main_80249170.s.o(.rodata); build/asm/main_80249170.s.o(.data); }
    .main_80249170_bss (NOLOAD) : { build/asm/main_80249170.s.o(.bss); }
    .main_8024918C 0x8024918C : AT(0x00049D8C) { build/asm/data/main_8024918C.bin.o(.data); }
    .main_802492D4 0x802492D4 : AT(0x00049ED4) { FILL(0x00000000); build/asm/main_802492D4.s.o(.text); build/asm/main_802492D4.s.o(.rodata); build/asm/main_802492D4.s.o(.data); }
    .main_802492D4_bss (NOLOAD) : { build/asm/main_802492D4.s.o(.bss); }
    .main_802492EC 0x802492EC : AT(0x00049EEC) { build/asm/data/main_802492EC.bin.o(.data); }
    .main_80249AE4 0x80249AE4 : AT(0x0004A6E4) { FILL(0x00000000); build/asm/main_80249AE4.s.o(.text); build/asm/main_80249AE4.s.o(.rodata); build/asm/main_80249AE4.s.o(.data); }
    .main_80249AE4_bss (NOLOAD) : { build/asm/main_80249AE4.s.o(.bss); }
    .main_80249B04 0x80249B04 : AT(0x0004A704) { build/asm/data/main_80249B04.bin.o(.data); }
    .main_80249B7C 0x80249B7C : AT(0x0004A77C) { FILL(0x00000000); build/asm/main_80249B7C.s.o(.text); build/asm/main_80249B7C.s.o(.rodata); build/asm/main_80249B7C.s.o(.data); }
    .main_80249B7C_bss (NOLOAD) : { build/asm/main_80249B7C.s.o(.bss); }
    .main_80249BB8 0x80249BB8 : AT(0x0004A7B8) { build/asm/data/main_80249BB8.bin.o(.data); }
    .main_8024A3B4 0x8024A3B4 : AT(0x0004AFB4) { FILL(0x00000000); build/asm/main_8024A3B4.s.o(.text); build/asm/main_8024A3B4.s.o(.rodata); build/asm/main_8024A3B4.s.o(.data); }
    .main_8024A3B4_bss (NOLOAD) : { build/asm/main_8024A3B4.s.o(.bss); }
    .main_8024A438 0x8024A438 : AT(0x0004B038) { build/asm/data/main_8024A438.bin.o(.data); }
    .main_8024A958 0x8024A958 : AT(0x0004B558) { FILL(0x00000000); build/asm/main_8024A958.s.o(.text); build/asm/main_8024A958.s.o(.rodata); build/asm/main_8024A958.s.o(.data); }
    .main_8024A958_bss (NOLOAD) : { build/asm/main_8024A958.s.o(.bss); }
    .main_8024A96C 0x8024A96C : AT(0x0004B56C) { build/asm/data/main_8024A96C.bin.o(.data); }
    .main_8024ABD0 0x8024ABD0 : AT(0x0004B7D0) { FILL(0x00000000); build/asm/main_8024ABD0.s.o(.text); build/asm/main_8024ABD0.s.o(.rodata); build/asm/main_8024ABD0.s.o(.data); }
    .main_8024ABD0_bss (NOLOAD) : { build/asm/main_8024ABD0.s.o(.bss); }
    .main_8024ABEC 0x8024ABEC : AT(0x0004B7EC) { build/asm/data/main_8024ABEC.bin.o(.data); }
    .main_8024ACF4 0x8024ACF4 : AT(0x0004B8F4) { FILL(0x00000000); build/asm/main_8024ACF4.s.o(.text); build/asm/main_8024ACF4.s.o(.rodata); build/asm/main_8024ACF4.s.o(.data); }
    .main_8024ACF4_bss (NOLOAD) : { build/asm/main_8024ACF4.s.o(.bss); }
    .main_8024AD88 0x8024AD88 : AT(0x0004B988) { build/asm/data/main_8024AD88.bin.o(.data); }
    .main_8024B000 0x8024B000 : AT(0x0004BC00) { FILL(0x00000000); build/asm/main_8024B000.s.o(.text); build/asm/main_8024B000.s.o(.rodata); build/asm/main_8024B000.s.o(.data); }
    .main_8024B000_bss (NOLOAD) : { build/asm/main_8024B000.s.o(.bss); }
    .main_8024B0A4 0x8024B0A4 : AT(0x0004BCA4) { build/asm/data/main_8024B0A4.bin.o(.data); }
    .main_8024BACC 0x8024BACC : AT(0x0004C6CC) { FILL(0x00000000); build/asm/main_8024BACC.s.o(.text); build/asm/main_8024BACC.s.o(.rodata); build/asm/main_8024BACC.s.o(.data); }
    .main_8024BACC_bss (NOLOAD) : { build/asm/main_8024BACC.s.o(.bss); }
    .main_8024BB24 0x8024BB24 : AT(0x0004C724) { build/asm/data/main_8024BB24.bin.o(.data); }
    .main_8024BEAC 0x8024BEAC : AT(0x0004CAAC) { FILL(0x00000000); build/asm/main_8024BEAC.s.o(.text); build/asm/main_8024BEAC.s.o(.rodata); build/asm/main_8024BEAC.s.o(.data); }
    .main_8024BEAC_bss (NOLOAD) : { build/asm/main_8024BEAC.s.o(.bss); }
    .main_8024BFEC 0x8024BFEC : AT(0x0004CBEC) { build/asm/data/main_8024BFEC.bin.o(.data); }
    .main_8024C524 0x8024C524 : AT(0x0004D124) { FILL(0x00000000); build/asm/main_8024C524.s.o(.text); build/asm/main_8024C524.s.o(.rodata); build/asm/main_8024C524.s.o(.data); }
    .main_8024C524_bss (NOLOAD) : { build/asm/main_8024C524.s.o(.bss); }
    .main_8024C56C 0x8024C56C : AT(0x0004D16C) { build/asm/data/main_8024C56C.bin.o(.data); }
    .main_8024C800 0x8024C800 : AT(0x0004D400) { FILL(0x00000000); build/asm/main_8024C800.s.o(.text); build/asm/main_8024C800.s.o(.rodata); build/asm/main_8024C800.s.o(.data); }
    .main_8024C800_bss (NOLOAD) : { build/asm/main_8024C800.s.o(.bss); }
    .main_8024C85C 0x8024C85C : AT(0x0004D45C) { build/asm/data/main_8024C85C.bin.o(.data); }
    .main_8024CB9C 0x8024CB9C : AT(0x0004D79C) { FILL(0x00000000); build/asm/main_8024CB9C.s.o(.text); build/asm/main_8024CB9C.s.o(.rodata); build/asm/main_8024CB9C.s.o(.data); }
    .main_8024CB9C_bss (NOLOAD) : { build/asm/main_8024CB9C.s.o(.bss); }
    .main_8024CC60 0x8024CC60 : AT(0x0004D860) { build/asm/data/main_8024CC60.bin.o(.data); }
    .main_8024D044 0x8024D044 : AT(0x0004DC44) { FILL(0x00000000); build/asm/main_8024D044.s.o(.text); build/asm/main_8024D044.s.o(.rodata); build/asm/main_8024D044.s.o(.data); }
    .main_8024D044_bss (NOLOAD) : { build/asm/main_8024D044.s.o(.bss); }
    .main_8024D0B0 0x8024D0B0 : AT(0x0004DCB0) { build/asm/data/main_8024D0B0.bin.o(.data); }
    .main_8024D588 0x8024D588 : AT(0x0004E188) { FILL(0x00000000); build/asm/main_8024D588.s.o(.text); build/asm/main_8024D588.s.o(.rodata); build/asm/main_8024D588.s.o(.data); }
    .main_8024D588_bss (NOLOAD) : { build/asm/main_8024D588.s.o(.bss); }
    .main_8024D5C0 0x8024D5C0 : AT(0x0004E1C0) { build/asm/data/main_8024D5C0.bin.o(.data); }
    .main_8024D96C 0x8024D96C : AT(0x0004E56C) { FILL(0x00000000); build/asm/main_8024D96C.s.o(.text); build/asm/main_8024D96C.s.o(.rodata); build/asm/main_8024D96C.s.o(.data); }
    .main_8024D96C_bss (NOLOAD) : { build/asm/main_8024D96C.s.o(.bss); }
    .main_8024D9BC 0x8024D9BC : AT(0x0004E5BC) { build/asm/data/main_8024D9BC.bin.o(.data); }
    .main_8024DDD4 0x8024DDD4 : AT(0x0004E9D4) { FILL(0x00000000); build/asm/main_8024DDD4.s.o(.text); build/asm/main_8024DDD4.s.o(.rodata); build/asm/main_8024DDD4.s.o(.data); }
    .main_8024DDD4_bss (NOLOAD) : { build/asm/main_8024DDD4.s.o(.bss); }
    .main_8024DDF8 0x8024DDF8 : AT(0x0004E9F8) { build/asm/data/main_8024DDF8.bin.o(.data); }
    .main_8024E7D8 0x8024E7D8 : AT(0x0004F3D8) { FILL(0x00000000); build/asm/main_8024E7D8.s.o(.text); build/asm/main_8024E7D8.s.o(.rodata); build/asm/main_8024E7D8.s.o(.data); }
    .main_8024E7D8_bss (NOLOAD) : { build/asm/main_8024E7D8.s.o(.bss); }
    .main_8024E7E0 0x8024E7E0 : AT(0x0004F3E0) { build/asm/data/main_8024E7E0.bin.o(.data); }
    .main_8024E8D0 0x8024E8D0 : AT(0x0004F4D0) { FILL(0x00000000); build/asm/main_8024E8D0.s.o(.text); build/asm/main_8024E8D0.s.o(.rodata); build/asm/main_8024E8D0.s.o(.data); }
    .main_8024E8D0_bss (NOLOAD) : { build/asm/main_8024E8D0.s.o(.bss); }
    .main_8024E90C 0x8024E90C : AT(0x0004F50C) { build/asm/data/main_8024E90C.bin.o(.data); }
    .main_8024EBA0 0x8024EBA0 : AT(0x0004F7A0) { FILL(0x00000000); build/asm/main_8024EBA0.s.o(.text); build/asm/main_8024EBA0.s.o(.rodata); build/asm/main_8024EBA0.s.o(.data); }
    .main_8024EBA0_bss (NOLOAD) : { build/asm/main_8024EBA0.s.o(.bss); }
    .main_8024EBAC 0x8024EBAC : AT(0x0004F7AC) { build/asm/data/main_8024EBAC.bin.o(.data); }
    .main_8024EF28 0x8024EF28 : AT(0x0004FB28) { FILL(0x00000000); build/asm/main_8024EF28.s.o(.text); build/asm/main_8024EF28.s.o(.rodata); build/asm/main_8024EF28.s.o(.data); }
    .main_8024EF28_bss (NOLOAD) : { build/asm/main_8024EF28.s.o(.bss); }
    .main_8024EF64 0x8024EF64 : AT(0x0004FB64) { build/asm/data/main_8024EF64.bin.o(.data); }
    .main_8024FB70 0x8024FB70 : AT(0x00050770) { FILL(0x00000000); build/asm/main_8024FB70.s.o(.text); build/asm/main_8024FB70.s.o(.rodata); build/asm/main_8024FB70.s.o(.data); }
    .main_8024FB70_bss (NOLOAD) : { build/asm/main_8024FB70.s.o(.bss); }
    .main_8024FC08 0x8024FC08 : AT(0x00050808) { build/asm/data/main_8024FC08.bin.o(.data); }
    .main_802505DC 0x802505DC : AT(0x000511DC) { FILL(0x00000000); build/asm/main_802505DC.s.o(.text); build/asm/main_802505DC.s.o(.rodata); build/asm/main_802505DC.s.o(.data); }
    .main_802505DC_bss (NOLOAD) : { build/asm/main_802505DC.s.o(.bss); }
    .main_802505E8 0x802505E8 : AT(0x000511E8) { build/asm/data/main_802505E8.bin.o(.data); }
    .main_8025071C 0x8025071C : AT(0x0005131C) { FILL(0x00000000); build/asm/main_8025071C.s.o(.text); build/asm/main_8025071C.s.o(.rodata); build/asm/main_8025071C.s.o(.data); }
    .main_8025071C_bss (NOLOAD) : { build/asm/main_8025071C.s.o(.bss); }
    .main_8025074C 0x8025074C : AT(0x0005134C) { build/asm/data/main_8025074C.bin.o(.data); }
    .main_80251410 0x80251410 : AT(0x00052010) { FILL(0x00000000); build/asm/main_80251410.s.o(.text); build/asm/main_80251410.s.o(.rodata); build/asm/main_80251410.s.o(.data); }
    .main_80251410_bss (NOLOAD) : { build/asm/main_80251410.s.o(.bss); }
    .main_8025144C 0x8025144C : AT(0x0005204C) { build/asm/data/main_8025144C.bin.o(.data); }
    .main_802519E8 0x802519E8 : AT(0x000525E8) { FILL(0x00000000); build/asm/main_802519E8.s.o(.text); build/asm/main_802519E8.s.o(.rodata); build/asm/main_802519E8.s.o(.data); }
    .main_802519E8_bss (NOLOAD) : { build/asm/main_802519E8.s.o(.bss); }
    .main_802519F8 0x802519F8 : AT(0x000525F8) { build/asm/data/main_802519F8.bin.o(.data); }
    .main_80252718 0x80252718 : AT(0x00053318) { FILL(0x00000000); build/asm/main_80252718.s.o(.text); build/asm/main_80252718.s.o(.rodata); build/asm/main_80252718.s.o(.data); }
    .main_80252718_bss (NOLOAD) : { build/asm/main_80252718.s.o(.bss); }
    .main_80252740 0x80252740 : AT(0x00053340) { build/asm/data/main_80252740.bin.o(.data); }
    .main_80253CC8 0x80253CC8 : AT(0x000548C8) { FILL(0x00000000); build/asm/main_80253CC8.s.o(.text); build/asm/main_80253CC8.s.o(.rodata); build/asm/main_80253CC8.s.o(.data); }
    .main_80253CC8_bss (NOLOAD) : { build/asm/main_80253CC8.s.o(.bss); }
    .main_80253D04 0x80253D04 : AT(0x00054904) { build/asm/data/main_80253D04.bin.o(.data); }
    .main_802540C8 0x802540C8 : AT(0x00054CC8) { FILL(0x00000000); build/asm/main_802540C8.s.o(.text); build/asm/main_802540C8.s.o(.rodata); build/asm/main_802540C8.s.o(.data); }
    .main_802540C8_bss (NOLOAD) : { build/asm/main_802540C8.s.o(.bss); }
    .main_80254158 0x80254158 : AT(0x00054D58) { build/asm/data/main_80254158.bin.o(.data); }
    .main_80254AD4 0x80254AD4 : AT(0x000556D4) { FILL(0x00000000); build/asm/main_80254AD4.s.o(.text); build/asm/main_80254AD4.s.o(.rodata); build/asm/main_80254AD4.s.o(.data); }
    .main_80254AD4_bss (NOLOAD) : { build/asm/main_80254AD4.s.o(.bss); }
    .main_80254AF4 0x80254AF4 : AT(0x000556F4) { build/asm/data/main_80254AF4.bin.o(.data); }
    .main_80254D48 0x80254D48 : AT(0x00055948) { FILL(0x00000000); build/asm/main_80254D48.s.o(.text); build/asm/main_80254D48.s.o(.rodata); build/asm/main_80254D48.s.o(.data); }
    .main_80254D48_bss (NOLOAD) : { build/asm/main_80254D48.s.o(.bss); }
    .main_80254E10 0x80254E10 : AT(0x00055A10) { build/asm/data/main_80254E10.bin.o(.data); }
    .main_802551CC 0x802551CC : AT(0x00055DCC) { FILL(0x00000000); build/asm/main_802551CC.s.o(.text); build/asm/main_802551CC.s.o(.rodata); build/asm/main_802551CC.s.o(.data); }
    .main_802551CC_bss (NOLOAD) : { build/asm/main_802551CC.s.o(.bss); }
    .main_80255244 0x80255244 : AT(0x00055E44) { build/asm/data/main_80255244.bin.o(.data); }
    .main_80255680 0x80255680 : AT(0x00056280) { FILL(0x00000000); build/asm/main_80255680.s.o(.text); build/asm/main_80255680.s.o(.rodata); build/asm/main_80255680.s.o(.data); }
    .main_80255680_bss (NOLOAD) : { build/asm/main_80255680.s.o(.bss); }
    .main_80255690 0x80255690 : AT(0x00056290) { build/asm/data/main_80255690.bin.o(.data); }
    .main_80255A58 0x80255A58 : AT(0x00056658) { FILL(0x00000000); build/asm/main_80255A58.s.o(.text); build/asm/main_80255A58.s.o(.rodata); build/asm/main_80255A58.s.o(.data); }
    .main_80255A58_bss (NOLOAD) : { build/asm/main_80255A58.s.o(.bss); }
    .main_80255AD0 0x80255AD0 : AT(0x000566D0) { build/asm/data/main_80255AD0.bin.o(.data); }
    .main_802561E8 0x802561E8 : AT(0x00056DE8) { FILL(0x00000000); build/asm/main_802561E8.s.o(.text); build/asm/main_802561E8.s.o(.rodata); build/asm/main_802561E8.s.o(.data); }
    .main_802561E8_bss (NOLOAD) : { build/asm/main_802561E8.s.o(.bss); }
    .main_80256260 0x80256260 : AT(0x00056E60) { build/asm/data/main_80256260.bin.o(.data); }
    .main_8025874C 0x8025874C : AT(0x0005934C) { FILL(0x00000000); build/asm/main_8025874C.s.o(.text); build/asm/main_8025874C.s.o(.rodata); build/asm/main_8025874C.s.o(.data); }
    .main_8025874C_bss (NOLOAD) : { build/asm/main_8025874C.s.o(.bss); }
    .main_80258760 0x80258760 : AT(0x00059360) { build/asm/data/main_80258760.bin.o(.data); }
    .main_80258D7C 0x80258D7C : AT(0x0005997C) { FILL(0x00000000); build/asm/main_80258D7C.s.o(.text); build/asm/main_80258D7C.s.o(.rodata); build/asm/main_80258D7C.s.o(.data); }
    .main_80258D7C_bss (NOLOAD) : { build/asm/main_80258D7C.s.o(.bss); }
    .main_80258D80 0x80258D80 : AT(0x00059980) { build/asm/data/main_80258D80.bin.o(.data); }
    .main_80259F1C 0x80259F1C : AT(0x0005AB1C) { FILL(0x00000000); build/asm/main_80259F1C.s.o(.text); build/asm/main_80259F1C.s.o(.rodata); build/asm/main_80259F1C.s.o(.data); }
    .main_80259F1C_bss (NOLOAD) : { build/asm/main_80259F1C.s.o(.bss); }
    .main_80259F40 0x80259F40 : AT(0x0005AB40) { build/asm/data/main_80259F40.bin.o(.data); }
    .main_8025A4F0 0x8025A4F0 : AT(0x0005B0F0) { FILL(0x00000000); build/asm/main_8025A4F0.s.o(.text); build/asm/main_8025A4F0.s.o(.rodata); build/asm/main_8025A4F0.s.o(.data); }
    .main_8025A4F0_bss (NOLOAD) : { build/asm/main_8025A4F0.s.o(.bss); }
    .main_8025A520 0x8025A520 : AT(0x0005B120) { build/asm/data/main_8025A520.bin.o(.data); }
    .main_8025AF0C 0x8025AF0C : AT(0x0005BB0C) { FILL(0x00000000); build/asm/main_8025AF0C.s.o(.text); build/asm/main_8025AF0C.s.o(.rodata); build/asm/main_8025AF0C.s.o(.data); }
    .main_8025AF0C_bss (NOLOAD) : { build/asm/main_8025AF0C.s.o(.bss); }
    .main_8025AF2C 0x8025AF2C : AT(0x0005BB2C) { build/asm/data/main_8025AF2C.bin.o(.data); }
    .main_8025BC18 0x8025BC18 : AT(0x0005C818) { FILL(0x00000000); build/asm/main_8025BC18.s.o(.text); build/asm/main_8025BC18.s.o(.rodata); build/asm/main_8025BC18.s.o(.data); }
    .main_8025BC18_bss (NOLOAD) : { build/asm/main_8025BC18.s.o(.bss); }
    .main_8025BC74 0x8025BC74 : AT(0x0005C874) { build/asm/data/main_8025BC74.bin.o(.data); }
    .main_8025BDBC 0x8025BDBC : AT(0x0005C9BC) { FILL(0x00000000); build/asm/main_8025BDBC.s.o(.text); build/asm/main_8025BDBC.s.o(.rodata); build/asm/main_8025BDBC.s.o(.data); }
    .main_8025BDBC_bss (NOLOAD) : { build/asm/main_8025BDBC.s.o(.bss); }
    .main_8025BE44 0x8025BE44 : AT(0x0005CA44) { build/asm/data/main_8025BE44.bin.o(.data); }
    .main_8025C07C 0x8025C07C : AT(0x0005CC7C) { FILL(0x00000000); build/asm/main_8025C07C.s.o(.text); build/asm/main_8025C07C.s.o(.rodata); build/asm/main_8025C07C.s.o(.data); }
    .main_8025C07C_bss (NOLOAD) : { build/asm/main_8025C07C.s.o(.bss); }
    .main_8025C094 0x8025C094 : AT(0x0005CC94) { build/asm/data/main_8025C094.bin.o(.data); }
    .main_8025CACC 0x8025CACC : AT(0x0005D6CC) { FILL(0x00000000); build/asm/main_8025CACC.s.o(.text); build/asm/main_8025CACC.s.o(.rodata); build/asm/main_8025CACC.s.o(.data); }
    .main_8025CACC_bss (NOLOAD) : { build/asm/main_8025CACC.s.o(.bss); }
    .main_8025CBA8 0x8025CBA8 : AT(0x0005D7A8) { build/asm/data/main_8025CBA8.bin.o(.data); }
    .main_8025D604 0x8025D604 : AT(0x0005E204) { FILL(0x00000000); build/asm/main_8025D604.s.o(.text); build/asm/main_8025D604.s.o(.rodata); build/asm/main_8025D604.s.o(.data); }
    .main_8025D604_bss (NOLOAD) : { build/asm/main_8025D604.s.o(.bss); }
    .main_8025D628 0x8025D628 : AT(0x0005E228) { build/asm/data/main_8025D628.bin.o(.data); }
    .main_8025E3B0 0x8025E3B0 : AT(0x0005EFB0) { FILL(0x00000000); build/asm/main_8025E3B0.s.o(.text); build/asm/main_8025E3B0.s.o(.rodata); build/asm/main_8025E3B0.s.o(.data); }
    .main_8025E3B0_bss (NOLOAD) : { build/asm/main_8025E3B0.s.o(.bss); }
    .main_8025E444 0x8025E444 : AT(0x0005F044) { build/asm/data/main_8025E444.bin.o(.data); }
    .main_8025E5C4 0x8025E5C4 : AT(0x0005F1C4) { FILL(0x00000000); build/asm/main_8025E5C4.s.o(.text); build/asm/main_8025E5C4.s.o(.rodata); build/asm/main_8025E5C4.s.o(.data); }
    .main_8025E5C4_bss (NOLOAD) : { build/asm/main_8025E5C4.s.o(.bss); }
    .main_8025E5CC 0x8025E5CC : AT(0x0005F1CC) { build/asm/data/main_8025E5CC.bin.o(.data); }
    .main_8025E63C 0x8025E63C : AT(0x0005F23C) { FILL(0x00000000); build/asm/main_8025E63C.s.o(.text); build/asm/main_8025E63C.s.o(.rodata); build/asm/main_8025E63C.s.o(.data); }
    .main_8025E63C_bss (NOLOAD) : { build/asm/main_8025E63C.s.o(.bss); }
    .main_8025E678 0x8025E678 : AT(0x0005F278) { build/asm/data/main_8025E678.bin.o(.data); }
    .main_8025E990 0x8025E990 : AT(0x0005F590) { FILL(0x00000000); build/asm/main_8025E990.s.o(.text); build/asm/main_8025E990.s.o(.rodata); build/asm/main_8025E990.s.o(.data); }
    .main_8025E990_bss (NOLOAD) : { build/asm/main_8025E990.s.o(.bss); }
    .main_8025EA40 0x8025EA40 : AT(0x0005F640) { build/asm/data/main_8025EA40.bin.o(.data); }
    .main_8025ED38 0x8025ED38 : AT(0x0005F938) { FILL(0x00000000); build/asm/main_8025ED38.s.o(.text); build/asm/main_8025ED38.s.o(.rodata); build/asm/main_8025ED38.s.o(.data); }
    .main_8025ED38_bss (NOLOAD) : { build/asm/main_8025ED38.s.o(.bss); }
    .main_8025ED44 0x8025ED44 : AT(0x0005F944) { build/asm/data/main_8025ED44.bin.o(.data); }
    .main_8025EE90 0x8025EE90 : AT(0x0005FA90) { FILL(0x00000000); build/asm/main_8025EE90.s.o(.text); build/asm/main_8025EE90.s.o(.rodata); build/asm/main_8025EE90.s.o(.data); }
    .main_8025EE90_bss (NOLOAD) : { build/asm/main_8025EE90.s.o(.bss); }
    .main_8025EEC4 0x8025EEC4 : AT(0x0005FAC4) { build/asm/data/main_8025EEC4.bin.o(.data); }
    .main_8025F1C0 0x8025F1C0 : AT(0x0005FDC0) { FILL(0x00000000); build/asm/main_8025F1C0.s.o(.text); build/asm/main_8025F1C0.s.o(.rodata); build/asm/main_8025F1C0.s.o(.data); }
    .main_8025F1C0_bss (NOLOAD) : { build/asm/main_8025F1C0.s.o(.bss); }
    .main_8025F224 0x8025F224 : AT(0x0005FE24) { build/asm/data/main_8025F224.bin.o(.data); }
    .main_8025F238 0x8025F238 : AT(0x0005FE38) { FILL(0x00000000); build/asm/main_8025F238.s.o(.text); build/asm/main_8025F238.s.o(.rodata); build/asm/main_8025F238.s.o(.data); }
    .main_8025F238_bss (NOLOAD) : { build/asm/main_8025F238.s.o(.bss); }
    .main_8025F26C 0x8025F26C : AT(0x0005FE6C) { build/asm/data/main_8025F26C.bin.o(.data); }
    .main_8025F2B8 0x8025F2B8 : AT(0x0005FEB8) { FILL(0x00000000); build/asm/main_8025F2B8.s.o(.text); build/asm/main_8025F2B8.s.o(.rodata); build/asm/main_8025F2B8.s.o(.data); }
    .main_8025F2B8_bss (NOLOAD) : { build/asm/main_8025F2B8.s.o(.bss); }
    .main_8025F300 0x8025F300 : AT(0x0005FF00) { build/asm/data/main_8025F300.bin.o(.data); }
    .main_8026156C 0x8026156C : AT(0x0006216C) { FILL(0x00000000); build/asm/main_8026156C.s.o(.text); build/asm/main_8026156C.s.o(.rodata); build/asm/main_8026156C.s.o(.data); }
    .main_8026156C_bss (NOLOAD) : { build/asm/main_8026156C.s.o(.bss); }
    .main_80261598 0x80261598 : AT(0x00062198) { build/asm/data/main_80261598.bin.o(.data); }
    .main_80261ACC 0x80261ACC : AT(0x000626CC) { FILL(0x00000000); build/asm/main_80261ACC.s.o(.text); build/asm/main_80261ACC.s.o(.rodata); build/asm/main_80261ACC.s.o(.data); }
    .main_80261ACC_bss (NOLOAD) : { build/asm/main_80261ACC.s.o(.bss); }
    .main_80261AD0 0x80261AD0 : AT(0x000626D0) { build/asm/data/main_80261AD0.bin.o(.data); }
    .main_80261B94 0x80261B94 : AT(0x00062794) { FILL(0x00000000); build/asm/main_80261B94.s.o(.text); build/asm/main_80261B94.s.o(.rodata); build/asm/main_80261B94.s.o(.data); }
    .main_80261B94_bss (NOLOAD) : { build/asm/main_80261B94.s.o(.bss); }
    .main_80261C60 0x80261C60 : AT(0x00062860) { build/asm/data/main_80261C60.bin.o(.data); }
    .main_80261F84 0x80261F84 : AT(0x00062B84) { FILL(0x00000000); build/asm/main_80261F84.s.o(.text); build/asm/main_80261F84.s.o(.rodata); build/asm/main_80261F84.s.o(.data); }
    .main_80261F84_bss (NOLOAD) : { build/asm/main_80261F84.s.o(.bss); }
    .main_80261FA0 0x80261FA0 : AT(0x00062BA0) { build/asm/data/main_80261FA0.bin.o(.data); }
    .main_802625E0 0x802625E0 : AT(0x000631E0) { FILL(0x00000000); build/asm/main_802625E0.s.o(.text); build/asm/main_802625E0.s.o(.rodata); build/asm/main_802625E0.s.o(.data); }
    .main_802625E0_bss (NOLOAD) : { build/asm/main_802625E0.s.o(.bss); }
    .main_80262610 0x80262610 : AT(0x00063210) { build/asm/data/main_80262610.bin.o(.data); }
    .main_80262750 0x80262750 : AT(0x00063350) { FILL(0x00000000); build/asm/main_80262750.s.o(.text); build/asm/main_80262750.s.o(.rodata); build/asm/main_80262750.s.o(.data); }
    .main_80262750_bss (NOLOAD) : { build/asm/main_80262750.s.o(.bss); }
    .main_8026276C 0x8026276C : AT(0x0006336C) { build/asm/data/main_8026276C.bin.o(.data); }
    .main_80263474 0x80263474 : AT(0x00064074) { FILL(0x00000000); build/asm/main_80263474.s.o(.text); build/asm/main_80263474.s.o(.rodata); build/asm/main_80263474.s.o(.data); }
    .main_80263474_bss (NOLOAD) : { build/asm/main_80263474.s.o(.bss); }
    .main_80263480 0x80263480 : AT(0x00064080) { build/asm/data/main_80263480.bin.o(.data); }
    .main_80263798 0x80263798 : AT(0x00064398) { FILL(0x00000000); build/asm/main_80263798.s.o(.text); build/asm/main_80263798.s.o(.rodata); build/asm/main_80263798.s.o(.data); }
    .main_80263798_bss (NOLOAD) : { build/asm/main_80263798.s.o(.bss); }
    .main_802637C8 0x802637C8 : AT(0x000643C8) { build/asm/data/main_802637C8.bin.o(.data); }
    .main_802638F0 0x802638F0 : AT(0x000644F0) { FILL(0x00000000); build/asm/main_802638F0.s.o(.text); build/asm/main_802638F0.s.o(.rodata); build/asm/main_802638F0.s.o(.data); }
    .main_802638F0_bss (NOLOAD) : { build/asm/main_802638F0.s.o(.bss); }
    .main_8026391C 0x8026391C : AT(0x0006451C) { build/asm/data/main_8026391C.bin.o(.data); }
    .main_80263B70 0x80263B70 : AT(0x00064770) { FILL(0x00000000); build/asm/main_80263B70.s.o(.text); build/asm/main_80263B70.s.o(.rodata); build/asm/main_80263B70.s.o(.data); }
    .main_80263B70_bss (NOLOAD) : { build/asm/main_80263B70.s.o(.bss); }
    .main_80263B78 0x80263B78 : AT(0x00064778) { build/asm/data/main_80263B78.bin.o(.data); }
    .main_80263CFC 0x80263CFC : AT(0x000648FC) { FILL(0x00000000); build/asm/main_80263CFC.s.o(.text); build/asm/main_80263CFC.s.o(.rodata); build/asm/main_80263CFC.s.o(.data); }
    .main_80263CFC_bss (NOLOAD) : { build/asm/main_80263CFC.s.o(.bss); }
    .main_80263D4C 0x80263D4C : AT(0x0006494C) { build/asm/data/main_80263D4C.bin.o(.data); }
    .main_80264AF4 0x80264AF4 : AT(0x000656F4) { FILL(0x00000000); build/asm/main_80264AF4.s.o(.text); build/asm/main_80264AF4.s.o(.rodata); build/asm/main_80264AF4.s.o(.data); }
    .main_80264AF4_bss (NOLOAD) : { build/asm/main_80264AF4.s.o(.bss); }
    .main_80264B28 0x80264B28 : AT(0x00065728) { build/asm/data/main_80264B28.bin.o(.data); }
    .main_80264F9C 0x80264F9C : AT(0x00065B9C) { FILL(0x00000000); build/asm/main_80264F9C.s.o(.text); build/asm/main_80264F9C.s.o(.rodata); build/asm/main_80264F9C.s.o(.data); }
    .main_80264F9C_bss (NOLOAD) : { build/asm/main_80264F9C.s.o(.bss); }
    .main_8026500C 0x8026500C : AT(0x00065C0C) { build/asm/data/main_8026500C.bin.o(.data); }
    .main_80265C2C 0x80265C2C : AT(0x0006682C) { FILL(0x00000000); build/asm/main_80265C2C.s.o(.text); build/asm/main_80265C2C.s.o(.rodata); build/asm/main_80265C2C.s.o(.data); }
    .main_80265C2C_bss (NOLOAD) : { build/asm/main_80265C2C.s.o(.bss); }
    .main_80265C9C 0x80265C9C : AT(0x0006689C) { build/asm/data/main_80265C9C.bin.o(.data); }
    .main_802675B4 0x802675B4 : AT(0x000681B4) { FILL(0x00000000); build/asm/main_802675B4.s.o(.text); build/asm/main_802675B4.s.o(.rodata); build/asm/main_802675B4.s.o(.data); }
    .main_802675B4_bss (NOLOAD) : { build/asm/main_802675B4.s.o(.bss); }
    .main_802675D8 0x802675D8 : AT(0x000681D8) { build/asm/data/main_802675D8.bin.o(.data); }
    .main_802675EC 0x802675EC : AT(0x000681EC) { FILL(0x00000000); build/asm/main_802675EC.s.o(.text); build/asm/main_802675EC.s.o(.rodata); build/asm/main_802675EC.s.o(.data); }
    .main_802675EC_bss (NOLOAD) : { build/asm/main_802675EC.s.o(.bss); }
    .main_80267640 0x80267640 : AT(0x00068240) { build/asm/data/main_80267640.bin.o(.data); }
    .main_8026777C 0x8026777C : AT(0x0006837C) { FILL(0x00000000); build/asm/main_8026777C.s.o(.text); build/asm/main_8026777C.s.o(.rodata); build/asm/main_8026777C.s.o(.data); }
    .main_8026777C_bss (NOLOAD) : { build/asm/main_8026777C.s.o(.bss); }
    .main_80267790 0x80267790 : AT(0x00068390) { build/asm/data/main_80267790.bin.o(.data); }
    .main_80267818 0x80267818 : AT(0x00068418) { FILL(0x00000000); build/asm/main_80267818.s.o(.text); build/asm/main_80267818.s.o(.rodata); build/asm/main_80267818.s.o(.data); }
    .main_80267818_bss (NOLOAD) : { build/asm/main_80267818.s.o(.bss); }
    .main_80267958 0x80267958 : AT(0x00068558) { build/asm/data/main_80267958.bin.o(.data); }
    .main_8026833C 0x8026833C : AT(0x00068F3C) { FILL(0x00000000); build/asm/main_8026833C.s.o(.text); build/asm/main_8026833C.s.o(.rodata); build/asm/main_8026833C.s.o(.data); }
    .main_8026833C_bss (NOLOAD) : { build/asm/main_8026833C.s.o(.bss); }
    .main_8026840C 0x8026840C : AT(0x0006900C) { build/asm/data/main_8026840C.bin.o(.data); }
    .main_80268600 0x80268600 : AT(0x00069200) { FILL(0x00000000); build/asm/main_80268600.s.o(.text); build/asm/main_80268600.s.o(.rodata); build/asm/main_80268600.s.o(.data); }
    .main_80268600_bss (NOLOAD) : { build/asm/main_80268600.s.o(.bss); }
    .main_8026860C 0x8026860C : AT(0x0006920C) { build/asm/data/main_8026860C.bin.o(.data); }
    .main_80268B1C 0x80268B1C : AT(0x0006971C) { FILL(0x00000000); build/asm/main_80268B1C.s.o(.text); build/asm/main_80268B1C.s.o(.rodata); build/asm/main_80268B1C.s.o(.data); }
    .main_80268B1C_bss (NOLOAD) : { build/asm/main_80268B1C.s.o(.bss); }
    .main_80268C1C 0x80268C1C : AT(0x0006981C) { build/asm/data/main_80268C1C.bin.o(.data); }
    .main_80268EC8 0x80268EC8 : AT(0x00069AC8) { FILL(0x00000000); build/asm/main_80268EC8.s.o(.text); build/asm/main_80268EC8.s.o(.rodata); build/asm/main_80268EC8.s.o(.data); }
    .main_80268EC8_bss (NOLOAD) : { build/asm/main_80268EC8.s.o(.bss); }
    .main_80268EE0 0x80268EE0 : AT(0x00069AE0) { build/asm/data/main_80268EE0.bin.o(.data); }
    .main_80269070 0x80269070 : AT(0x00069C70) { FILL(0x00000000); build/asm/main_80269070.s.o(.text); build/asm/main_80269070.s.o(.rodata); build/asm/main_80269070.s.o(.data); }
    .main_80269070_bss (NOLOAD) : { build/asm/main_80269070.s.o(.bss); }
    .main_802690A0 0x802690A0 : AT(0x00069CA0) { build/asm/data/main_802690A0.bin.o(.data); }
    .main_80269EA0 0x80269EA0 : AT(0x0006AAA0) { FILL(0x00000000); build/asm/main_80269EA0.s.o(.text); build/asm/main_80269EA0.s.o(.rodata); build/asm/main_80269EA0.s.o(.data); }
    .main_80269EA0_bss (NOLOAD) : { build/asm/main_80269EA0.s.o(.bss); }
    .main_80269EB0 0x80269EB0 : AT(0x0006AAB0) { build/asm/data/main_80269EB0.bin.o(.data); }
    .main_8026B09C 0x8026B09C : AT(0x0006BC9C) { FILL(0x00000000); build/asm/main_8026B09C.s.o(.text); build/asm/main_8026B09C.s.o(.rodata); build/asm/main_8026B09C.s.o(.data); }
    .main_8026B09C_bss (NOLOAD) : { build/asm/main_8026B09C.s.o(.bss); }
    .main_8026B0E0 0x8026B0E0 : AT(0x0006BCE0) { build/asm/data/main_8026B0E0.bin.o(.data); }
    .main_8026B3D0 0x8026B3D0 : AT(0x0006BFD0) { FILL(0x00000000); build/asm/main_8026B3D0.s.o(.text); build/asm/main_8026B3D0.s.o(.rodata); build/asm/main_8026B3D0.s.o(.data); }
    .main_8026B3D0_bss (NOLOAD) : { build/asm/main_8026B3D0.s.o(.bss); }
    .main_8026B45C 0x8026B45C : AT(0x0006C05C) { build/asm/data/main_8026B45C.bin.o(.data); }
    .main_8026B508 0x8026B508 : AT(0x0006C108) { FILL(0x00000000); build/asm/main_8026B508.s.o(.text); build/asm/main_8026B508.s.o(.rodata); build/asm/main_8026B508.s.o(.data); }
    .main_8026B508_bss (NOLOAD) : { build/asm/main_8026B508.s.o(.bss); }
    .main_8026B50C 0x8026B50C : AT(0x0006C10C) { build/asm/data/main_8026B50C.bin.o(.data); }
    .main_8026B620 0x8026B620 : AT(0x0006C220) { FILL(0x00000000); build/asm/main_8026B620.s.o(.text); build/asm/main_8026B620.s.o(.rodata); build/asm/main_8026B620.s.o(.data); }
    .main_8026B620_bss (NOLOAD) : { build/asm/main_8026B620.s.o(.bss); }
    .main_8026B6AC 0x8026B6AC : AT(0x0006C2AC) { build/asm/data/main_8026B6AC.bin.o(.data); }
    .main_8026BA18 0x8026BA18 : AT(0x0006C618) { FILL(0x00000000); build/asm/main_8026BA18.s.o(.text); build/asm/main_8026BA18.s.o(.rodata); build/asm/main_8026BA18.s.o(.data); }
    .main_8026BA18_bss (NOLOAD) : { build/asm/main_8026BA18.s.o(.bss); }
    .main_8026BA20 0x8026BA20 : AT(0x0006C620) { build/asm/data/main_8026BA20.bin.o(.data); }
    .main_8026BBFC 0x8026BBFC : AT(0x0006C7FC) { FILL(0x00000000); build/asm/main_8026BBFC.s.o(.text); build/asm/main_8026BBFC.s.o(.rodata); build/asm/main_8026BBFC.s.o(.data); }
    .main_8026BBFC_bss (NOLOAD) : { build/asm/main_8026BBFC.s.o(.bss); }
    .main_8026BD70 0x8026BD70 : AT(0x0006C970) { build/asm/data/main_8026BD70.bin.o(.data); }
    .main_8026C294 0x8026C294 : AT(0x0006CE94) { FILL(0x00000000); build/asm/main_8026C294.s.o(.text); build/asm/main_8026C294.s.o(.rodata); build/asm/main_8026C294.s.o(.data); }
    .main_8026C294_bss (NOLOAD) : { build/asm/main_8026C294.s.o(.bss); }
    .main_8026C2AC 0x8026C2AC : AT(0x0006CEAC) { build/asm/data/main_8026C2AC.bin.o(.data); }
    .main_8026C86C 0x8026C86C : AT(0x0006D46C) { FILL(0x00000000); build/asm/main_8026C86C.s.o(.text); build/asm/main_8026C86C.s.o(.rodata); build/asm/main_8026C86C.s.o(.data); }
    .main_8026C86C_bss (NOLOAD) : { build/asm/main_8026C86C.s.o(.bss); }
    .main_8026CA28 0x8026CA28 : AT(0x0006D628) { build/asm/data/main_8026CA28.bin.o(.data); }
    .main_8026DC94 0x8026DC94 : AT(0x0006E894) { FILL(0x00000000); build/asm/main_8026DC94.s.o(.text); build/asm/main_8026DC94.s.o(.rodata); build/asm/main_8026DC94.s.o(.data); }
    .main_8026DC94_bss (NOLOAD) : { build/asm/main_8026DC94.s.o(.bss); }
    .main_8026DCB8 0x8026DCB8 : AT(0x0006E8B8) { build/asm/data/main_8026DCB8.bin.o(.data); }
    .main_8026DDB8 0x8026DDB8 : AT(0x0006E9B8) { FILL(0x00000000); build/asm/main_8026DDB8.s.o(.text); build/asm/main_8026DDB8.s.o(.rodata); build/asm/main_8026DDB8.s.o(.data); }
    .main_8026DDB8_bss (NOLOAD) : { build/asm/main_8026DDB8.s.o(.bss); }
    .main_8026DE44 0x8026DE44 : AT(0x0006EA44) { build/asm/data/main_8026DE44.bin.o(.data); }
    .main_8026E39C 0x8026E39C : AT(0x0006EF9C) { FILL(0x00000000); build/asm/main_8026E39C.s.o(.text); build/asm/main_8026E39C.s.o(.rodata); build/asm/main_8026E39C.s.o(.data); }
    .main_8026E39C_bss (NOLOAD) : { build/asm/main_8026E39C.s.o(.bss); }
    .main_8026E3A8 0x8026E3A8 : AT(0x0006EFA8) { build/asm/data/main_8026E3A8.bin.o(.data); }
    .main_8026F000 0x8026F000 : AT(0x0006FC00) { FILL(0x00000000); build/asm/main_8026F000.s.o(.text); build/asm/main_8026F000.s.o(.rodata); build/asm/main_8026F000.s.o(.data); }
    .main_8026F000_bss (NOLOAD) : { build/asm/main_8026F000.s.o(.bss); }
    .main_8026F0C0 0x8026F0C0 : AT(0x0006FCC0) { build/asm/data/main_8026F0C0.bin.o(.data); }
    .main_8026FBA0 0x8026FBA0 : AT(0x000707A0) { FILL(0x00000000); build/asm/main_8026FBA0.s.o(.text); build/asm/main_8026FBA0.s.o(.rodata); build/asm/main_8026FBA0.s.o(.data); }
    .main_8026FBA0_bss (NOLOAD) : { build/asm/main_8026FBA0.s.o(.bss); }
    .main_8026FBD4 0x8026FBD4 : AT(0x000707D4) { build/asm/data/main_8026FBD4.bin.o(.data); }
    .main_802701B8 0x802701B8 : AT(0x00070DB8) { FILL(0x00000000); build/asm/main_802701B8.s.o(.text); build/asm/main_802701B8.s.o(.rodata); build/asm/main_802701B8.s.o(.data); }
    .main_802701B8_bss (NOLOAD) : { build/asm/main_802701B8.s.o(.bss); }
    .main_802701C4 0x802701C4 : AT(0x00070DC4) { build/asm/data/main_802701C4.bin.o(.data); }
    .main_802702B4 0x802702B4 : AT(0x00070EB4) { FILL(0x00000000); build/asm/main_802702B4.s.o(.text); build/asm/main_802702B4.s.o(.rodata); build/asm/main_802702B4.s.o(.data); }
    .main_802702B4_bss (NOLOAD) : { build/asm/main_802702B4.s.o(.bss); }
    .main_802702E0 0x802702E0 : AT(0x00070EE0) { build/asm/data/main_802702E0.bin.o(.data); }
    .main_80270BC0 0x80270BC0 : AT(0x000717C0) { FILL(0x00000000); build/asm/main_80270BC0.s.o(.text); build/asm/main_80270BC0.s.o(.rodata); build/asm/main_80270BC0.s.o(.data); }
    .main_80270BC0_bss (NOLOAD) : { build/asm/main_80270BC0.s.o(.bss); }
    .main_80270BFC 0x80270BFC : AT(0x000717FC) { build/asm/data/main_80270BFC.bin.o(.data); }
    .main_80270C14 0x80270C14 : AT(0x00071814) { FILL(0x00000000); build/asm/main_80270C14.s.o(.text); build/asm/main_80270C14.s.o(.rodata); build/asm/main_80270C14.s.o(.data); }
    .main_80270C14_bss (NOLOAD) : { build/asm/main_80270C14.s.o(.bss); }
    .main_80270C4C 0x80270C4C : AT(0x0007184C) { build/asm/data/main_80270C4C.bin.o(.data); }
    .main_80270F88 0x80270F88 : AT(0x00071B88) { FILL(0x00000000); build/asm/main_80270F88.s.o(.text); build/asm/main_80270F88.s.o(.rodata); build/asm/main_80270F88.s.o(.data); }
    .main_80270F88_bss (NOLOAD) : { build/asm/main_80270F88.s.o(.bss); }
    .main_80270FC0 0x80270FC0 : AT(0x00071BC0) { build/asm/data/main_80270FC0.bin.o(.data); }
    .main_80271A90 0x80271A90 : AT(0x00072690) { FILL(0x00000000); build/asm/main_80271A90.s.o(.text); build/asm/main_80271A90.s.o(.rodata); build/asm/main_80271A90.s.o(.data); }
    .main_80271A90_bss (NOLOAD) : { build/asm/main_80271A90.s.o(.bss); }
    .main_80271AA4 0x80271AA4 : AT(0x000726A4) { build/asm/data/main_80271AA4.bin.o(.data); }
    .main_80271C14 0x80271C14 : AT(0x00072814) { FILL(0x00000000); build/asm/main_80271C14.s.o(.text); build/asm/main_80271C14.s.o(.rodata); build/asm/main_80271C14.s.o(.data); }
    .main_80271C14_bss (NOLOAD) : { build/asm/main_80271C14.s.o(.bss); }
    .main_80271C18 0x80271C18 : AT(0x00072818) { build/asm/data/main_80271C18.bin.o(.data); }
    .main_80271E5C 0x80271E5C : AT(0x00072A5C) { FILL(0x00000000); build/asm/main_80271E5C.s.o(.text); build/asm/main_80271E5C.s.o(.rodata); build/asm/main_80271E5C.s.o(.data); }
    .main_80271E5C_bss (NOLOAD) : { build/asm/main_80271E5C.s.o(.bss); }
    .main_80271EA0 0x80271EA0 : AT(0x00072AA0) { build/asm/data/main_80271EA0.bin.o(.data); }
    .main_80272A28 0x80272A28 : AT(0x00073628) { FILL(0x00000000); build/asm/main_80272A28.s.o(.text); build/asm/main_80272A28.s.o(.rodata); build/asm/main_80272A28.s.o(.data); }
    .main_80272A28_bss (NOLOAD) : { build/asm/main_80272A28.s.o(.bss); }
    .main_80272AD0 0x80272AD0 : AT(0x000736D0) { build/asm/data/main_80272AD0.bin.o(.data); }
    .main_802731F0 0x802731F0 : AT(0x00073DF0) { FILL(0x00000000); build/asm/main_802731F0.s.o(.text); build/asm/main_802731F0.s.o(.rodata); build/asm/main_802731F0.s.o(.data); }
    .main_802731F0_bss (NOLOAD) : { build/asm/main_802731F0.s.o(.bss); }
    .main_802731F4 0x802731F4 : AT(0x00073DF4) { build/asm/data/main_802731F4.bin.o(.data); }
    .main_80274074 0x80274074 : AT(0x00074C74) { FILL(0x00000000); build/asm/main_80274074.s.o(.text); build/asm/main_80274074.s.o(.rodata); build/asm/main_80274074.s.o(.data); }
    .main_80274074_bss (NOLOAD) : { build/asm/main_80274074.s.o(.bss); }
    .main_80274080 0x80274080 : AT(0x00074C80) { build/asm/data/main_80274080.bin.o(.data); }
    .main_8027450C 0x8027450C : AT(0x0007510C) { FILL(0x00000000); build/asm/main_8027450C.s.o(.text); build/asm/main_8027450C.s.o(.rodata); build/asm/main_8027450C.s.o(.data); }
    .main_8027450C_bss (NOLOAD) : { build/asm/main_8027450C.s.o(.bss); }
    .main_802745A0 0x802745A0 : AT(0x000751A0) { build/asm/data/main_802745A0.bin.o(.data); }
    .main_8027478C 0x8027478C : AT(0x0007538C) { FILL(0x00000000); build/asm/main_8027478C.s.o(.text); build/asm/main_8027478C.s.o(.rodata); build/asm/main_8027478C.s.o(.data); }
    .main_8027478C_bss (NOLOAD) : { build/asm/main_8027478C.s.o(.bss); }
    .main_8027480C 0x8027480C : AT(0x0007540C) { build/asm/data/main_8027480C.bin.o(.data); }
    .main_80275398 0x80275398 : AT(0x00075F98) { FILL(0x00000000); build/asm/main_80275398.s.o(.text); build/asm/main_80275398.s.o(.rodata); build/asm/main_80275398.s.o(.data); }
    .main_80275398_bss (NOLOAD) : { build/asm/main_80275398.s.o(.bss); }
    .main_80275408 0x80275408 : AT(0x00076008) { build/asm/data/main_80275408.bin.o(.data); }
    .main_80275658 0x80275658 : AT(0x00076258) { FILL(0x00000000); build/asm/main_80275658.s.o(.text); build/asm/main_80275658.s.o(.rodata); build/asm/main_80275658.s.o(.data); }
    .main_80275658_bss (NOLOAD) : { build/asm/main_80275658.s.o(.bss); }
    .main_80275698 0x80275698 : AT(0x00076298) { build/asm/data/main_80275698.bin.o(.data); }
    .main_80275E80 0x80275E80 : AT(0x00076A80) { FILL(0x00000000); build/asm/main_80275E80.s.o(.text); build/asm/main_80275E80.s.o(.rodata); build/asm/main_80275E80.s.o(.data); }
    .main_80275E80_bss (NOLOAD) : { build/asm/main_80275E80.s.o(.bss); }
    .main_80275E88 0x80275E88 : AT(0x00076A88) { build/asm/data/main_80275E88.bin.o(.data); }
    .main_8027653C 0x8027653C : AT(0x0007713C) { FILL(0x00000000); build/asm/main_8027653C.s.o(.text); build/asm/main_8027653C.s.o(.rodata); build/asm/main_8027653C.s.o(.data); }
    .main_8027653C_bss (NOLOAD) : { build/asm/main_8027653C.s.o(.bss); }
    .main_80276570 0x80276570 : AT(0x00077170) { build/asm/data/main_80276570.bin.o(.data); }
    .main_802769F0 0x802769F0 : AT(0x000775F0) { FILL(0x00000000); build/asm/main_802769F0.s.o(.text); build/asm/main_802769F0.s.o(.rodata); build/asm/main_802769F0.s.o(.data); }
    .main_802769F0_bss (NOLOAD) : { build/asm/main_802769F0.s.o(.bss); }
    .main_80276A30 0x80276A30 : AT(0x00077630) { build/asm/data/main_80276A30.bin.o(.data); }
    .main_80277174 0x80277174 : AT(0x00077D74) { FILL(0x00000000); build/asm/main_80277174.s.o(.text); build/asm/main_80277174.s.o(.rodata); build/asm/main_80277174.s.o(.data); }
    .main_80277174_bss (NOLOAD) : { build/asm/main_80277174.s.o(.bss); }
    .main_802771A0 0x802771A0 : AT(0x00077DA0) { build/asm/data/main_802771A0.bin.o(.data); }
    .main_802772D4 0x802772D4 : AT(0x00077ED4) { FILL(0x00000000); build/asm/main_802772D4.s.o(.text); build/asm/main_802772D4.s.o(.rodata); build/asm/main_802772D4.s.o(.data); }
    .main_802772D4_bss (NOLOAD) : { build/asm/main_802772D4.s.o(.bss); }
    .main_802772F4 0x802772F4 : AT(0x00077EF4) { build/asm/data/main_802772F4.bin.o(.data); }
    .main_80278BC0 0x80278BC0 : AT(0x000797C0) { FILL(0x00000000); build/asm/main_80278BC0.s.o(.text); build/asm/main_80278BC0.s.o(.rodata); build/asm/main_80278BC0.s.o(.data); }
    .main_80278BC0_bss (NOLOAD) : { build/asm/main_80278BC0.s.o(.bss); }
    .main_80278BE8 0x80278BE8 : AT(0x000797E8) { build/asm/data/main_80278BE8.bin.o(.data); }
    .main_802791FC 0x802791FC : AT(0x00079DFC) { FILL(0x00000000); build/asm/main_802791FC.s.o(.text); build/asm/main_802791FC.s.o(.rodata); build/asm/main_802791FC.s.o(.data); }
    .main_802791FC_bss (NOLOAD) : { build/asm/main_802791FC.s.o(.bss); }
    .main_80279208 0x80279208 : AT(0x00079E08) { build/asm/data/main_80279208.bin.o(.data); }
    .main_802797AC 0x802797AC : AT(0x0007A3AC) { FILL(0x00000000); build/asm/main_802797AC.s.o(.text); build/asm/main_802797AC.s.o(.rodata); build/asm/main_802797AC.s.o(.data); }
    .main_802797AC_bss (NOLOAD) : { build/asm/main_802797AC.s.o(.bss); }
    .main_802797C8 0x802797C8 : AT(0x0007A3C8) { build/asm/data/main_802797C8.bin.o(.data); }
    .main_80279D1C 0x80279D1C : AT(0x0007A91C) { FILL(0x00000000); build/asm/main_80279D1C.s.o(.text); build/asm/main_80279D1C.s.o(.rodata); build/asm/main_80279D1C.s.o(.data); }
    .main_80279D1C_bss (NOLOAD) : { build/asm/main_80279D1C.s.o(.bss); }
    .main_80279D7C 0x80279D7C : AT(0x0007A97C) { build/asm/data/main_80279D7C.bin.o(.data); }
    .main_80279E38 0x80279E38 : AT(0x0007AA38) { FILL(0x00000000); build/asm/main_80279E38.s.o(.text); build/asm/main_80279E38.s.o(.rodata); build/asm/main_80279E38.s.o(.data); }
    .main_80279E38_bss (NOLOAD) : { build/asm/main_80279E38.s.o(.bss); }
    .main_80279E54 0x80279E54 : AT(0x0007AA54) { build/asm/data/main_80279E54.bin.o(.data); }
    .main_8027AA58 0x8027AA58 : AT(0x0007B658) { FILL(0x00000000); build/asm/main_8027AA58.s.o(.text); build/asm/main_8027AA58.s.o(.rodata); build/asm/main_8027AA58.s.o(.data); }
    .main_8027AA58_bss (NOLOAD) : { build/asm/main_8027AA58.s.o(.bss); }
    .main_8027AA80 0x8027AA80 : AT(0x0007B680) { build/asm/data/main_8027AA80.bin.o(.data); }
    .main_8027C2A0 0x8027C2A0 : AT(0x0007CEA0) { FILL(0x00000000); build/asm/main_8027C2A0.s.o(.text); build/asm/main_8027C2A0.s.o(.rodata); build/asm/main_8027C2A0.s.o(.data); }
    .main_8027C2A0_bss (NOLOAD) : { build/asm/main_8027C2A0.s.o(.bss); }
    .main_8027C2BC 0x8027C2BC : AT(0x0007CEBC) { build/asm/data/main_8027C2BC.bin.o(.data); }
    .main_8027D3D8 0x8027D3D8 : AT(0x0007DFD8) { FILL(0x00000000); build/asm/main_8027D3D8.s.o(.text); build/asm/main_8027D3D8.s.o(.rodata); build/asm/main_8027D3D8.s.o(.data); }
    .main_8027D3D8_bss (NOLOAD) : { build/asm/main_8027D3D8.s.o(.bss); }
    .main_8027D3EC 0x8027D3EC : AT(0x0007DFEC) { build/asm/data/main_8027D3EC.bin.o(.data); }
    .main_8027D414 0x8027D414 : AT(0x0007E014) { FILL(0x00000000); build/asm/main_8027D414.s.o(.text); build/asm/main_8027D414.s.o(.rodata); build/asm/main_8027D414.s.o(.data); }
    .main_8027D414_bss (NOLOAD) : { build/asm/main_8027D414.s.o(.bss); }
    .main_8027D454 0x8027D454 : AT(0x0007E054) { build/asm/data/main_8027D454.bin.o(.data); }
    .main_8027D958 0x8027D958 : AT(0x0007E558) { FILL(0x00000000); build/asm/main_8027D958.s.o(.text); build/asm/main_8027D958.s.o(.rodata); build/asm/main_8027D958.s.o(.data); }
    .main_8027D958_bss (NOLOAD) : { build/asm/main_8027D958.s.o(.bss); }
    .main_8027D964 0x8027D964 : AT(0x0007E564) { build/asm/data/main_8027D964.bin.o(.data); }
    .main_8027E7E0 0x8027E7E0 : AT(0x0007F3E0) { FILL(0x00000000); build/asm/main_8027E7E0.s.o(.text); build/asm/main_8027E7E0.s.o(.rodata); build/asm/main_8027E7E0.s.o(.data); }
    .main_8027E7E0_bss (NOLOAD) : { build/asm/main_8027E7E0.s.o(.bss); }
    .main_8027E81C 0x8027E81C : AT(0x0007F41C) { build/asm/data/main_8027E81C.bin.o(.data); }
    .main_8027EC70 0x8027EC70 : AT(0x0007F870) { FILL(0x00000000); build/asm/main_8027EC70.s.o(.text); build/asm/main_8027EC70.s.o(.rodata); build/asm/main_8027EC70.s.o(.data); }
    .main_8027EC70_bss (NOLOAD) : { build/asm/main_8027EC70.s.o(.bss); }
    .main_8027ED20 0x8027ED20 : AT(0x0007F920) { build/asm/data/main_8027ED20.bin.o(.data); }
    .main_8027EF20 0x8027EF20 : AT(0x0007FB20) { FILL(0x00000000); build/asm/main_8027EF20.s.o(.text); build/asm/main_8027EF20.s.o(.rodata); build/asm/main_8027EF20.s.o(.data); }
    .main_8027EF20_bss (NOLOAD) : { build/asm/main_8027EF20.s.o(.bss); }
    .main_8027EF5C 0x8027EF5C : AT(0x0007FB5C) { build/asm/data/main_8027EF5C.bin.o(.data); }
    .main_80280178 0x80280178 : AT(0x00080D78) { FILL(0x00000000); build/asm/main_80280178.s.o(.text); build/asm/main_80280178.s.o(.rodata); build/asm/main_80280178.s.o(.data); }
    .main_80280178_bss (NOLOAD) : { build/asm/main_80280178.s.o(.bss); }
    .main_80280194 0x80280194 : AT(0x00080D94) { build/asm/data/main_80280194.bin.o(.data); }
    .main_802809BC 0x802809BC : AT(0x000815BC) { FILL(0x00000000); build/asm/main_802809BC.s.o(.text); build/asm/main_802809BC.s.o(.rodata); build/asm/main_802809BC.s.o(.data); }
    .main_802809BC_bss (NOLOAD) : { build/asm/main_802809BC.s.o(.bss); }
    .main_802809E0 0x802809E0 : AT(0x000815E0) { build/asm/data/main_802809E0.bin.o(.data); }
    .main_80280B80 0x80280B80 : AT(0x00081780) { FILL(0x00000000); build/asm/main_80280B80.s.o(.text); build/asm/main_80280B80.s.o(.rodata); build/asm/main_80280B80.s.o(.data); }
    .main_80280B80_bss (NOLOAD) : { build/asm/main_80280B80.s.o(.bss); }
    .main_80280B90 0x80280B90 : AT(0x00081790) { build/asm/data/main_80280B90.bin.o(.data); }
    .main_80280D20 0x80280D20 : AT(0x00081920) { FILL(0x00000000); build/asm/main_80280D20.s.o(.text); build/asm/main_80280D20.s.o(.rodata); build/asm/main_80280D20.s.o(.data); }
    .main_80280D20_bss (NOLOAD) : { build/asm/main_80280D20.s.o(.bss); }
    .main_80280D50 0x80280D50 : AT(0x00081950) { build/asm/data/main_80280D50.bin.o(.data); }
    .main_802810DC 0x802810DC : AT(0x00081CDC) { FILL(0x00000000); build/asm/main_802810DC.s.o(.text); build/asm/main_802810DC.s.o(.rodata); build/asm/main_802810DC.s.o(.data); }
    .main_802810DC_bss (NOLOAD) : { build/asm/main_802810DC.s.o(.bss); }
    .main_802810E0 0x802810E0 : AT(0x00081CE0) { build/asm/data/main_802810E0.bin.o(.data); }
    .main_80281B94 0x80281B94 : AT(0x00082794) { FILL(0x00000000); build/asm/main_80281B94.s.o(.text); build/asm/main_80281B94.s.o(.rodata); build/asm/main_80281B94.s.o(.data); }
    .main_80281B94_bss (NOLOAD) : { build/asm/main_80281B94.s.o(.bss); }
    .main_80281C00 0x80281C00 : AT(0x00082800) { build/asm/data/main_80281C00.bin.o(.data); }
    .main_80281E24 0x80281E24 : AT(0x00082A24) { FILL(0x00000000); build/asm/main_80281E24.s.o(.text); build/asm/main_80281E24.s.o(.rodata); build/asm/main_80281E24.s.o(.data); }
    .main_80281E24_bss (NOLOAD) : { build/asm/main_80281E24.s.o(.bss); }
    .main_80281E94 0x80281E94 : AT(0x00082A94) { build/asm/data/main_80281E94.bin.o(.data); }
    .main_80282084 0x80282084 : AT(0x00082C84) { FILL(0x00000000); build/asm/main_80282084.s.o(.text); build/asm/main_80282084.s.o(.rodata); build/asm/main_80282084.s.o(.data); }
    .main_80282084_bss (NOLOAD) : { build/asm/main_80282084.s.o(.bss); }
    .main_80282118 0x80282118 : AT(0x00082D18) { build/asm/data/main_80282118.bin.o(.data); }
    .main_802822AC 0x802822AC : AT(0x00082EAC) { FILL(0x00000000); build/asm/main_802822AC.s.o(.text); build/asm/main_802822AC.s.o(.rodata); build/asm/main_802822AC.s.o(.data); }
    .main_802822AC_bss (NOLOAD) : { build/asm/main_802822AC.s.o(.bss); }
    .main_802822F4 0x802822F4 : AT(0x00082EF4) { build/asm/data/main_802822F4.bin.o(.data); }
    .main_80282A5C 0x80282A5C : AT(0x0008365C) { FILL(0x00000000); build/asm/main_80282A5C.s.o(.text); build/asm/main_80282A5C.s.o(.rodata); build/asm/main_80282A5C.s.o(.data); }
    .main_80282A5C_bss (NOLOAD) : { build/asm/main_80282A5C.s.o(.bss); }
    .main_80282A90 0x80282A90 : AT(0x00083690) { build/asm/data/main_80282A90.bin.o(.data); }
    .main_80282B10 0x80282B10 : AT(0x00083710) { FILL(0x00000000); build/asm/main_80282B10.s.o(.text); build/asm/main_80282B10.s.o(.rodata); build/asm/main_80282B10.s.o(.data); }
    .main_80282B10_bss (NOLOAD) : { build/asm/main_80282B10.s.o(.bss); }
    .main_80282BC4 0x80282BC4 : AT(0x000837C4) { build/asm/data/main_80282BC4.bin.o(.data); }
    .main_802838C4 0x802838C4 : AT(0x000844C4) { FILL(0x00000000); build/asm/main_802838C4.s.o(.text); build/asm/main_802838C4.s.o(.rodata); build/asm/main_802838C4.s.o(.data); }
    .main_802838C4_bss (NOLOAD) : { build/asm/main_802838C4.s.o(.bss); }
    .main_802838C8 0x802838C8 : AT(0x000844C8) { build/asm/data/main_802838C8.bin.o(.data); }
    .main_8028411C 0x8028411C : AT(0x00084D1C) { FILL(0x00000000); build/asm/main_8028411C.s.o(.text); build/asm/main_8028411C.s.o(.rodata); build/asm/main_8028411C.s.o(.data); }
    .main_8028411C_bss (NOLOAD) : { build/asm/main_8028411C.s.o(.bss); }
    .main_80284138 0x80284138 : AT(0x00084D38) { build/asm/data/main_80284138.bin.o(.data); }
    .main_80284268 0x80284268 : AT(0x00084E68) { FILL(0x00000000); build/asm/main_80284268.s.o(.text); build/asm/main_80284268.s.o(.rodata); build/asm/main_80284268.s.o(.data); }
    .main_80284268_bss (NOLOAD) : { build/asm/main_80284268.s.o(.bss); }
    .main_80284338 0x80284338 : AT(0x00084F38) { build/asm/data/main_80284338.bin.o(.data); }
    .main_802844CC 0x802844CC : AT(0x000850CC) { FILL(0x00000000); build/asm/main_802844CC.s.o(.text); build/asm/main_802844CC.s.o(.rodata); build/asm/main_802844CC.s.o(.data); }
    .main_802844CC_bss (NOLOAD) : { build/asm/main_802844CC.s.o(.bss); }
    .main_802844F4 0x802844F4 : AT(0x000850F4) { build/asm/data/main_802844F4.bin.o(.data); }
    .main_80284AD4 0x80284AD4 : AT(0x000856D4) { FILL(0x00000000); build/asm/main_80284AD4.s.o(.text); build/asm/main_80284AD4.s.o(.rodata); build/asm/main_80284AD4.s.o(.data); }
    .main_80284AD4_bss (NOLOAD) : { build/asm/main_80284AD4.s.o(.bss); }
    .main_80284B60 0x80284B60 : AT(0x00085760) { build/asm/data/main_80284B60.bin.o(.data); }
    .main_80284FD0 0x80284FD0 : AT(0x00085BD0) { FILL(0x00000000); build/asm/main_80284FD0.s.o(.text); build/asm/main_80284FD0.s.o(.rodata); build/asm/main_80284FD0.s.o(.data); }
    .main_80284FD0_bss (NOLOAD) : { build/asm/main_80284FD0.s.o(.bss); }
    .main_80285018 0x80285018 : AT(0x00085C18) { build/asm/data/main_80285018.bin.o(.data); }
    .main_80285258 0x80285258 : AT(0x00085E58) { FILL(0x00000000); build/asm/main_80285258.s.o(.text); build/asm/main_80285258.s.o(.rodata); build/asm/main_80285258.s.o(.data); }
    .main_80285258_bss (NOLOAD) : { build/asm/main_80285258.s.o(.bss); }
    .main_80285274 0x80285274 : AT(0x00085E74) { build/asm/data/main_80285274.bin.o(.data); }
    .main_80285684 0x80285684 : AT(0x00086284) { FILL(0x00000000); build/asm/main_80285684.s.o(.text); build/asm/main_80285684.s.o(.rodata); build/asm/main_80285684.s.o(.data); }
    .main_80285684_bss (NOLOAD) : { build/asm/main_80285684.s.o(.bss); }
    .main_802856F0 0x802856F0 : AT(0x000862F0) { build/asm/data/main_802856F0.bin.o(.data); }
    .main_80286E80 0x80286E80 : AT(0x00087A80) { FILL(0x00000000); build/asm/main_80286E80.s.o(.text); build/asm/main_80286E80.s.o(.rodata); build/asm/main_80286E80.s.o(.data); }
    .main_80286E80_bss (NOLOAD) : { build/asm/main_80286E80.s.o(.bss); }
    .main_80286EEC 0x80286EEC : AT(0x00087AEC) { build/asm/data/main_80286EEC.bin.o(.data); }
    .main_80287250 0x80287250 : AT(0x00087E50) { FILL(0x00000000); build/asm/main_80287250.s.o(.text); build/asm/main_80287250.s.o(.rodata); build/asm/main_80287250.s.o(.data); }
    .main_80287250_bss (NOLOAD) : { build/asm/main_80287250.s.o(.bss); }
    .main_8028725C 0x8028725C : AT(0x00087E5C) { build/asm/data/main_8028725C.bin.o(.data); }
    .main_8028757C 0x8028757C : AT(0x0008817C) { FILL(0x00000000); build/asm/main_8028757C.s.o(.text); build/asm/main_8028757C.s.o(.rodata); build/asm/main_8028757C.s.o(.data); }
    .main_8028757C_bss (NOLOAD) : { build/asm/main_8028757C.s.o(.bss); }
    .main_802875EC 0x802875EC : AT(0x000881EC) { build/asm/data/main_802875EC.bin.o(.data); }
    .main_80287758 0x80287758 : AT(0x00088358) { FILL(0x00000000); build/asm/main_80287758.s.o(.text); build/asm/main_80287758.s.o(.rodata); build/asm/main_80287758.s.o(.data); }
    .main_80287758_bss (NOLOAD) : { build/asm/main_80287758.s.o(.bss); }
    .main_80287824 0x80287824 : AT(0x00088424) { build/asm/data/main_80287824.bin.o(.data); }
    .main_80287AF8 0x80287AF8 : AT(0x000886F8) { FILL(0x00000000); build/asm/main_80287AF8.s.o(.text); build/asm/main_80287AF8.s.o(.rodata); build/asm/main_80287AF8.s.o(.data); }
    .main_80287AF8_bss (NOLOAD) : { build/asm/main_80287AF8.s.o(.bss); }
    .main_80287B5C 0x80287B5C : AT(0x0008875C) { build/asm/data/main_80287B5C.bin.o(.data); }
    .main_80287BCC 0x80287BCC : AT(0x000887CC) { FILL(0x00000000); build/asm/main_80287BCC.s.o(.text); build/asm/main_80287BCC.s.o(.rodata); build/asm/main_80287BCC.s.o(.data); }
    .main_80287BCC_bss (NOLOAD) : { build/asm/main_80287BCC.s.o(.bss); }
    .main_80287C04 0x80287C04 : AT(0x00088804) { build/asm/data/main_80287C04.bin.o(.data); }
    .main_80287D9C 0x80287D9C : AT(0x0008899C) { FILL(0x00000000); build/asm/main_80287D9C.s.o(.text); build/asm/main_80287D9C.s.o(.rodata); build/asm/main_80287D9C.s.o(.data); }
    .main_80287D9C_bss (NOLOAD) : { build/asm/main_80287D9C.s.o(.bss); }
    .main_80287DA4 0x80287DA4 : AT(0x000889A4) { build/asm/data/main_80287DA4.bin.o(.data); }
    .main_80288EAC 0x80288EAC : AT(0x00089AAC) { FILL(0x00000000); build/asm/main_80288EAC.s.o(.text); build/asm/main_80288EAC.s.o(.rodata); build/asm/main_80288EAC.s.o(.data); }
    .main_80288EAC_bss (NOLOAD) : { build/asm/main_80288EAC.s.o(.bss); }
    .main_80288EC8 0x80288EC8 : AT(0x00089AC8) { build/asm/data/main_80288EC8.bin.o(.data); }
    .main_80288F70 0x80288F70 : AT(0x00089B70) { FILL(0x00000000); build/asm/main_80288F70.s.o(.text); build/asm/main_80288F70.s.o(.rodata); build/asm/main_80288F70.s.o(.data); }
    .main_80288F70_bss (NOLOAD) : { build/asm/main_80288F70.s.o(.bss); }
    .main_80288F90 0x80288F90 : AT(0x00089B90) { build/asm/data/main_80288F90.bin.o(.data); }
    .main_802891C8 0x802891C8 : AT(0x00089DC8) { FILL(0x00000000); build/asm/main_802891C8.s.o(.text); build/asm/main_802891C8.s.o(.rodata); build/asm/main_802891C8.s.o(.data); }
    .main_802891C8_bss (NOLOAD) : { build/asm/main_802891C8.s.o(.bss); }
    .main_80289218 0x80289218 : AT(0x00089E18) { build/asm/data/main_80289218.bin.o(.data); }
    .main_802897C8 0x802897C8 : AT(0x0008A3C8) { FILL(0x00000000); build/asm/main_802897C8.s.o(.text); build/asm/main_802897C8.s.o(.rodata); build/asm/main_802897C8.s.o(.data); }
    .main_802897C8_bss (NOLOAD) : { build/asm/main_802897C8.s.o(.bss); }
    .main_802897EC 0x802897EC : AT(0x0008A3EC) { build/asm/data/main_802897EC.bin.o(.data); }
    .main_80289F18 0x80289F18 : AT(0x0008AB18) { FILL(0x00000000); build/asm/main_80289F18.s.o(.text); build/asm/main_80289F18.s.o(.rodata); build/asm/main_80289F18.s.o(.data); }
    .main_80289F18_bss (NOLOAD) : { build/asm/main_80289F18.s.o(.bss); }
    .main_80289F38 0x80289F38 : AT(0x0008AB38) { build/asm/data/main_80289F38.bin.o(.data); }
    .main_8028A030 0x8028A030 : AT(0x0008AC30) { FILL(0x00000000); build/asm/main_8028A030.s.o(.text); build/asm/main_8028A030.s.o(.rodata); build/asm/main_8028A030.s.o(.data); }
    .main_8028A030_bss (NOLOAD) : { build/asm/main_8028A030.s.o(.bss); }
    .main_8028A084 0x8028A084 : AT(0x0008AC84) { build/asm/data/main_8028A084.bin.o(.data); }
    .main_8028A828 0x8028A828 : AT(0x0008B428) { FILL(0x00000000); build/asm/main_8028A828.s.o(.text); build/asm/main_8028A828.s.o(.rodata); build/asm/main_8028A828.s.o(.data); }
    .main_8028A828_bss (NOLOAD) : { build/asm/main_8028A828.s.o(.bss); }
    .main_8028A860 0x8028A860 : AT(0x0008B460) { build/asm/data/main_8028A860.bin.o(.data); }
    .main_8028A98C 0x8028A98C : AT(0x0008B58C) { FILL(0x00000000); build/asm/main_8028A98C.s.o(.text); build/asm/main_8028A98C.s.o(.rodata); build/asm/main_8028A98C.s.o(.data); }
    .main_8028A98C_bss (NOLOAD) : { build/asm/main_8028A98C.s.o(.bss); }
    .main_8028A9B4 0x8028A9B4 : AT(0x0008B5B4) { build/asm/data/main_8028A9B4.bin.o(.data); }
    .main_8028ABEC 0x8028ABEC : AT(0x0008B7EC) { FILL(0x00000000); build/asm/main_8028ABEC.s.o(.text); build/asm/main_8028ABEC.s.o(.rodata); build/asm/main_8028ABEC.s.o(.data); }
    .main_8028ABEC_bss (NOLOAD) : { build/asm/main_8028ABEC.s.o(.bss); }
    .main_8028ABF8 0x8028ABF8 : AT(0x0008B7F8) { build/asm/data/main_8028ABF8.bin.o(.data); }
    .main_8028ADB4 0x8028ADB4 : AT(0x0008B9B4) { FILL(0x00000000); build/asm/main_8028ADB4.s.o(.text); build/asm/main_8028ADB4.s.o(.rodata); build/asm/main_8028ADB4.s.o(.data); }
    .main_8028ADB4_bss (NOLOAD) : { build/asm/main_8028ADB4.s.o(.bss); }
    .main_8028ADF4 0x8028ADF4 : AT(0x0008B9F4) { build/asm/data/main_8028ADF4.bin.o(.data); }
    .main_8028B9C4 0x8028B9C4 : AT(0x0008C5C4) { FILL(0x00000000); build/asm/main_8028B9C4.s.o(.text); build/asm/main_8028B9C4.s.o(.rodata); build/asm/main_8028B9C4.s.o(.data); }
    .main_8028B9C4_bss (NOLOAD) : { build/asm/main_8028B9C4.s.o(.bss); }
    .main_8028BA4C 0x8028BA4C : AT(0x0008C64C) { build/asm/data/main_8028BA4C.bin.o(.data); }
    .main_8028BEB4 0x8028BEB4 : AT(0x0008CAB4) { FILL(0x00000000); build/asm/main_8028BEB4.s.o(.text); build/asm/main_8028BEB4.s.o(.rodata); build/asm/main_8028BEB4.s.o(.data); }
    .main_8028BEB4_bss (NOLOAD) : { build/asm/main_8028BEB4.s.o(.bss); }
    .main_8028BEBC 0x8028BEBC : AT(0x0008CABC) { build/asm/data/main_8028BEBC.bin.o(.data); }
    .main_8028CC70 0x8028CC70 : AT(0x0008D870) { FILL(0x00000000); build/asm/main_8028CC70.s.o(.text); build/asm/main_8028CC70.s.o(.rodata); build/asm/main_8028CC70.s.o(.data); }
    .main_8028CC70_bss (NOLOAD) : { build/asm/main_8028CC70.s.o(.bss); }
    .main_8028CCE0 0x8028CCE0 : AT(0x0008D8E0) { build/asm/data/main_8028CCE0.bin.o(.data); }
    .main_8028D0F0 0x8028D0F0 : AT(0x0008DCF0) { FILL(0x00000000); build/asm/main_8028D0F0.s.o(.text); build/asm/main_8028D0F0.s.o(.rodata); build/asm/main_8028D0F0.s.o(.data); }
    .main_8028D0F0_bss (NOLOAD) : { build/asm/main_8028D0F0.s.o(.bss); }
    .main_8028D104 0x8028D104 : AT(0x0008DD04) { build/asm/data/main_8028D104.bin.o(.data); }
    .main_8028DDD4 0x8028DDD4 : AT(0x0008E9D4) { FILL(0x00000000); build/asm/main_8028DDD4.s.o(.text); build/asm/main_8028DDD4.s.o(.rodata); build/asm/main_8028DDD4.s.o(.data); }
    .main_8028DDD4_bss (NOLOAD) : { build/asm/main_8028DDD4.s.o(.bss); }
    .main_8028DDDC 0x8028DDDC : AT(0x0008E9DC) { build/asm/data/main_8028DDDC.bin.o(.data); }
    .main_8028E088 0x8028E088 : AT(0x0008EC88) { FILL(0x00000000); build/asm/main_8028E088.s.o(.text); build/asm/main_8028E088.s.o(.rodata); build/asm/main_8028E088.s.o(.data); }
    .main_8028E088_bss (NOLOAD) : { build/asm/main_8028E088.s.o(.bss); }
    .main_8028E08C 0x8028E08C : AT(0x0008EC8C) { build/asm/data/main_8028E08C.bin.o(.data); }
    .main_8028E37C 0x8028E37C : AT(0x0008EF7C) { FILL(0x00000000); build/asm/main_8028E37C.s.o(.text); build/asm/main_8028E37C.s.o(.rodata); build/asm/main_8028E37C.s.o(.data); }
    .main_8028E37C_bss (NOLOAD) : { build/asm/main_8028E37C.s.o(.bss); }
    .main_8028E394 0x8028E394 : AT(0x0008EF94) { build/asm/data/main_8028E394.bin.o(.data); }
    .main_8028F81C 0x8028F81C : AT(0x0009041C) { FILL(0x00000000); build/asm/main_8028F81C.s.o(.text); build/asm/main_8028F81C.s.o(.rodata); build/asm/main_8028F81C.s.o(.data); }
    .main_8028F81C_bss (NOLOAD) : { build/asm/main_8028F81C.s.o(.bss); }
    .main_8028F854 0x8028F854 : AT(0x00090454) { build/asm/data/main_8028F854.bin.o(.data); }
    .main_8028F924 0x8028F924 : AT(0x00090524) { FILL(0x00000000); build/asm/main_8028F924.s.o(.text); build/asm/main_8028F924.s.o(.rodata); build/asm/main_8028F924.s.o(.data); }
    .main_8028F924_bss (NOLOAD) : { build/asm/main_8028F924.s.o(.bss); }
    .main_8028F994 0x8028F994 : AT(0x00090594) { build/asm/data/main_8028F994.bin.o(.data); }
    .main_8028FC24 0x8028FC24 : AT(0x00090824) { FILL(0x00000000); build/asm/main_8028FC24.s.o(.text); build/asm/main_8028FC24.s.o(.rodata); build/asm/main_8028FC24.s.o(.data); }
    .main_8028FC24_bss (NOLOAD) : { build/asm/main_8028FC24.s.o(.bss); }
    .main_8028FC28 0x8028FC28 : AT(0x00090828) { build/asm/data/main_8028FC28.bin.o(.data); }
    .main_8028FFD4 0x8028FFD4 : AT(0x00090BD4) { FILL(0x00000000); build/asm/main_8028FFD4.s.o(.text); build/asm/main_8028FFD4.s.o(.rodata); build/asm/main_8028FFD4.s.o(.data); }
    .main_8028FFD4_bss (NOLOAD) : { build/asm/main_8028FFD4.s.o(.bss); }
    .main_8028FFEC 0x8028FFEC : AT(0x00090BEC) { build/asm/data/main_8028FFEC.bin.o(.data); }
    .main_802903C4 0x802903C4 : AT(0x00090FC4) { FILL(0x00000000); build/asm/main_802903C4.s.o(.text); build/asm/main_802903C4.s.o(.rodata); build/asm/main_802903C4.s.o(.data); }
    .main_802903C4_bss (NOLOAD) : { build/asm/main_802903C4.s.o(.bss); }
    .main_802904DC 0x802904DC : AT(0x000910DC) { build/asm/data/main_802904DC.bin.o(.data); }
    .main_80290998 0x80290998 : AT(0x00091598) { FILL(0x00000000); build/asm/main_80290998.s.o(.text); build/asm/main_80290998.s.o(.rodata); build/asm/main_80290998.s.o(.data); }
    .main_80290998_bss (NOLOAD) : { build/asm/main_80290998.s.o(.bss); }
    .main_802909CC 0x802909CC : AT(0x000915CC) { build/asm/data/main_802909CC.bin.o(.data); }
    .main_80290ABC 0x80290ABC : AT(0x000916BC) { FILL(0x00000000); build/asm/main_80290ABC.s.o(.text); build/asm/main_80290ABC.s.o(.rodata); build/asm/main_80290ABC.s.o(.data); }
    .main_80290ABC_bss (NOLOAD) : { build/asm/main_80290ABC.s.o(.bss); }
    .main_80290B40 0x80290B40 : AT(0x00091740) { build/asm/data/main_80290B40.bin.o(.data); }
    .main_80290B9C 0x80290B9C : AT(0x0009179C) { FILL(0x00000000); build/asm/main_80290B9C.s.o(.text); build/asm/main_80290B9C.s.o(.rodata); build/asm/main_80290B9C.s.o(.data); }
    .main_80290B9C_bss (NOLOAD) : { build/asm/main_80290B9C.s.o(.bss); }
    .main_80290BA8 0x80290BA8 : AT(0x000917A8) { build/asm/data/main_80290BA8.bin.o(.data); }
    .main_80291380 0x80291380 : AT(0x00091F80) { FILL(0x00000000); build/asm/main_80291380.s.o(.text); build/asm/main_80291380.s.o(.rodata); build/asm/main_80291380.s.o(.data); }
    .main_80291380_bss (NOLOAD) : { build/asm/main_80291380.s.o(.bss); }
    .main_802913EC 0x802913EC : AT(0x00091FEC) { build/asm/data/main_802913EC.bin.o(.data); }
    .main_80291A68 0x80291A68 : AT(0x00092668) { FILL(0x00000000); build/asm/main_80291A68.s.o(.text); build/asm/main_80291A68.s.o(.rodata); build/asm/main_80291A68.s.o(.data); }
    .main_80291A68_bss (NOLOAD) : { build/asm/main_80291A68.s.o(.bss); }
    .main_80291A80 0x80291A80 : AT(0x00092680) { build/asm/data/main_80291A80.bin.o(.data); }
    .main_80291BD4 0x80291BD4 : AT(0x000927D4) { FILL(0x00000000); build/asm/main_80291BD4.s.o(.text); build/asm/main_80291BD4.s.o(.rodata); build/asm/main_80291BD4.s.o(.data); }
    .main_80291BD4_bss (NOLOAD) : { build/asm/main_80291BD4.s.o(.bss); }
    .main_80291C04 0x80291C04 : AT(0x00092804) { build/asm/data/main_80291C04.bin.o(.data); }
    .main_80292314 0x80292314 : AT(0x00092F14) { FILL(0x00000000); build/asm/main_80292314.s.o(.text); build/asm/main_80292314.s.o(.rodata); build/asm/main_80292314.s.o(.data); }
    .main_80292314_bss (NOLOAD) : { build/asm/main_80292314.s.o(.bss); }
    .main_802923EC 0x802923EC : AT(0x00092FEC) { build/asm/data/main_802923EC.bin.o(.data); }
    .main_802947AC 0x802947AC : AT(0x000953AC) { FILL(0x00000000); build/asm/main_802947AC.s.o(.text); build/asm/main_802947AC.s.o(.rodata); build/asm/main_802947AC.s.o(.data); }
    .main_802947AC_bss (NOLOAD) : { build/asm/main_802947AC.s.o(.bss); }
    .main_802947DC 0x802947DC : AT(0x000953DC) { build/asm/data/main_802947DC.bin.o(.data); }
    .main_80294C48 0x80294C48 : AT(0x00095848) { FILL(0x00000000); build/asm/main_80294C48.s.o(.text); build/asm/main_80294C48.s.o(.rodata); build/asm/main_80294C48.s.o(.data); }
    .main_80294C48_bss (NOLOAD) : { build/asm/main_80294C48.s.o(.bss); }
    .main_80294C54 0x80294C54 : AT(0x00095854) { build/asm/data/main_80294C54.bin.o(.data); }
    .main_80294E40 0x80294E40 : AT(0x00095A40) { FILL(0x00000000); build/asm/main_80294E40.s.o(.text); build/asm/main_80294E40.s.o(.rodata); build/asm/main_80294E40.s.o(.data); }
    .main_80294E40_bss (NOLOAD) : { build/asm/main_80294E40.s.o(.bss); }
    .main_80294EA4 0x80294EA4 : AT(0x00095AA4) { build/asm/data/main_80294EA4.bin.o(.data); }
    .main_80294EE0 0x80294EE0 : AT(0x00095AE0) { FILL(0x00000000); build/asm/main_80294EE0.s.o(.text); build/asm/main_80294EE0.s.o(.rodata); build/asm/main_80294EE0.s.o(.data); }
    .main_80294EE0_bss (NOLOAD) : { build/asm/main_80294EE0.s.o(.bss); }
    .main_80295110 0x80295110 : AT(0x00095D10) { build/asm/data/main_80295110.bin.o(.data); }
    .main_80295188 0x80295188 : AT(0x00095D88) { FILL(0x00000000); build/asm/main_80295188.s.o(.text); build/asm/main_80295188.s.o(.rodata); build/asm/main_80295188.s.o(.data); }
    .main_80295188_bss (NOLOAD) : { build/asm/main_80295188.s.o(.bss); }
    .main_8029521C 0x8029521C : AT(0x00095E1C) { build/asm/data/main_8029521C.bin.o(.data); }
    .main_802953A0 0x802953A0 : AT(0x00095FA0) { FILL(0x00000000); build/asm/main_802953A0.s.o(.text); build/asm/main_802953A0.s.o(.rodata); build/asm/main_802953A0.s.o(.data); }
    .main_802953A0_bss (NOLOAD) : { build/asm/main_802953A0.s.o(.bss); }
    .main_802953F8 0x802953F8 : AT(0x00095FF8) { build/asm/data/main_802953F8.bin.o(.data); }
    .main_802961C4 0x802961C4 : AT(0x00096DC4) { FILL(0x00000000); build/asm/main_802961C4.s.o(.text); build/asm/main_802961C4.s.o(.rodata); build/asm/main_802961C4.s.o(.data); }
    .main_802961C4_bss (NOLOAD) : { build/asm/main_802961C4.s.o(.bss); }
    .main_80296244 0x80296244 : AT(0x00096E44) { build/asm/data/main_80296244.bin.o(.data); }
    .main_80296EFC 0x80296EFC : AT(0x00097AFC) { FILL(0x00000000); build/asm/main_80296EFC.s.o(.text); build/asm/main_80296EFC.s.o(.rodata); build/asm/main_80296EFC.s.o(.data); }
    .main_80296EFC_bss (NOLOAD) : { build/asm/main_80296EFC.s.o(.bss); }
    .main_80296F20 0x80296F20 : AT(0x00097B20) { build/asm/data/main_80296F20.bin.o(.data); }
    .main_80296FE4 0x80296FE4 : AT(0x00097BE4) { FILL(0x00000000); build/asm/main_80296FE4.s.o(.text); build/asm/main_80296FE4.s.o(.rodata); build/asm/main_80296FE4.s.o(.data); }
    .main_80296FE4_bss (NOLOAD) : { build/asm/main_80296FE4.s.o(.bss); }
    .main_80297084 0x80297084 : AT(0x00097C84) { build/asm/data/main_80297084.bin.o(.data); }
    .main_80297300 0x80297300 : AT(0x00097F00) { FILL(0x00000000); build/asm/main_80297300.s.o(.text); build/asm/main_80297300.s.o(.rodata); build/asm/main_80297300.s.o(.data); }
    .main_80297300_bss (NOLOAD) : { build/asm/main_80297300.s.o(.bss); }
    .main_80297304 0x80297304 : AT(0x00097F04) { build/asm/data/main_80297304.bin.o(.data); }
    .main_8029753C 0x8029753C : AT(0x0009813C) { FILL(0x00000000); build/asm/main_8029753C.s.o(.text); build/asm/main_8029753C.s.o(.rodata); build/asm/main_8029753C.s.o(.data); }
    .main_8029753C_bss (NOLOAD) : { build/asm/main_8029753C.s.o(.bss); }
    .main_8029764C 0x8029764C : AT(0x0009824C) { build/asm/data/main_8029764C.bin.o(.data); }
    .main_80297978 0x80297978 : AT(0x00098578) { FILL(0x00000000); build/asm/main_80297978.s.o(.text); build/asm/main_80297978.s.o(.rodata); build/asm/main_80297978.s.o(.data); }
    .main_80297978_bss (NOLOAD) : { build/asm/main_80297978.s.o(.bss); }
    .main_802979A4 0x802979A4 : AT(0x000985A4) { build/asm/data/main_802979A4.bin.o(.data); }
    .main_80297C04 0x80297C04 : AT(0x00098804) { FILL(0x00000000); build/asm/main_80297C04.s.o(.text); build/asm/main_80297C04.s.o(.rodata); build/asm/main_80297C04.s.o(.data); }
    .main_80297C04_bss (NOLOAD) : { build/asm/main_80297C04.s.o(.bss); }
    .main_80297C30 0x80297C30 : AT(0x00098830) { build/asm/data/main_80297C30.bin.o(.data); }
    .main_80298870 0x80298870 : AT(0x00099470) { FILL(0x00000000); build/asm/main_80298870.s.o(.text); build/asm/main_80298870.s.o(.rodata); build/asm/main_80298870.s.o(.data); }
    .main_80298870_bss (NOLOAD) : { build/asm/main_80298870.s.o(.bss); }
    .main_80298890 0x80298890 : AT(0x00099490) { build/asm/data/main_80298890.bin.o(.data); }
    .main_80298950 0x80298950 : AT(0x00099550) { FILL(0x00000000); build/asm/main_80298950.s.o(.text); build/asm/main_80298950.s.o(.rodata); build/asm/main_80298950.s.o(.data); }
    .main_80298950_bss (NOLOAD) : { build/asm/main_80298950.s.o(.bss); }
    .main_80298978 0x80298978 : AT(0x00099578) { build/asm/data/main_80298978.bin.o(.data); }
    .main_802991A0 0x802991A0 : AT(0x00099DA0) { FILL(0x00000000); build/asm/main_802991A0.s.o(.text); build/asm/main_802991A0.s.o(.rodata); build/asm/main_802991A0.s.o(.data); }
    .main_802991A0_bss (NOLOAD) : { build/asm/main_802991A0.s.o(.bss); }
    .main_802991EC 0x802991EC : AT(0x00099DEC) { build/asm/data/main_802991EC.bin.o(.data); }
    .main_80299354 0x80299354 : AT(0x00099F54) { FILL(0x00000000); build/asm/main_80299354.s.o(.text); build/asm/main_80299354.s.o(.rodata); build/asm/main_80299354.s.o(.data); }
    .main_80299354_bss (NOLOAD) : { build/asm/main_80299354.s.o(.bss); }
    .main_80299370 0x80299370 : AT(0x00099F70) { build/asm/data/main_80299370.bin.o(.data); }
    .main_80299458 0x80299458 : AT(0x0009A058) { FILL(0x00000000); build/asm/main_80299458.s.o(.text); build/asm/main_80299458.s.o(.rodata); build/asm/main_80299458.s.o(.data); }
    .main_80299458_bss (NOLOAD) : { build/asm/main_80299458.s.o(.bss); }
    .main_802994E0 0x802994E0 : AT(0x0009A0E0) { build/asm/data/main_802994E0.bin.o(.data); }
    .main_80299D5C 0x80299D5C : AT(0x0009A95C) { FILL(0x00000000); build/asm/main_80299D5C.s.o(.text); build/asm/main_80299D5C.s.o(.rodata); build/asm/main_80299D5C.s.o(.data); }
    .main_80299D5C_bss (NOLOAD) : { build/asm/main_80299D5C.s.o(.bss); }
    .main_80299D68 0x80299D68 : AT(0x0009A968) { build/asm/data/main_80299D68.bin.o(.data); }
    .main_80299EC0 0x80299EC0 : AT(0x0009AAC0) { FILL(0x00000000); build/asm/main_80299EC0.s.o(.text); build/asm/main_80299EC0.s.o(.rodata); build/asm/main_80299EC0.s.o(.data); }
    .main_80299EC0_bss (NOLOAD) : { build/asm/main_80299EC0.s.o(.bss); }
    .main_80299F38 0x80299F38 : AT(0x0009AB38) { build/asm/data/main_80299F38.bin.o(.data); }
    .main_8029A804 0x8029A804 : AT(0x0009B404) { FILL(0x00000000); build/asm/main_8029A804.s.o(.text); build/asm/main_8029A804.s.o(.rodata); build/asm/main_8029A804.s.o(.data); }
    .main_8029A804_bss (NOLOAD) : { build/asm/main_8029A804.s.o(.bss); }
    .main_8029A898 0x8029A898 : AT(0x0009B498) { build/asm/data/main_8029A898.bin.o(.data); }
    .main_8029B37C 0x8029B37C : AT(0x0009BF7C) { FILL(0x00000000); build/asm/main_8029B37C.s.o(.text); build/asm/main_8029B37C.s.o(.rodata); build/asm/main_8029B37C.s.o(.data); }
    .main_8029B37C_bss (NOLOAD) : { build/asm/main_8029B37C.s.o(.bss); }
    .main_8029B3E0 0x8029B3E0 : AT(0x0009BFE0) { build/asm/data/main_8029B3E0.bin.o(.data); }
    .main_8029B92C 0x8029B92C : AT(0x0009C52C) { FILL(0x00000000); build/asm/main_8029B92C.s.o(.text); build/asm/main_8029B92C.s.o(.rodata); build/asm/main_8029B92C.s.o(.data); }
    .main_8029B92C_bss (NOLOAD) : { build/asm/main_8029B92C.s.o(.bss); }
    .main_8029B94C 0x8029B94C : AT(0x0009C54C) { build/asm/data/main_8029B94C.bin.o(.data); }
    .main_8029C0A8 0x8029C0A8 : AT(0x0009CCA8) { FILL(0x00000000); build/asm/main_8029C0A8.s.o(.text); build/asm/main_8029C0A8.s.o(.rodata); build/asm/main_8029C0A8.s.o(.data); }
    .main_8029C0A8_bss (NOLOAD) : { build/asm/main_8029C0A8.s.o(.bss); }
    .main_8029C0CC 0x8029C0CC : AT(0x0009CCCC) { build/asm/data/main_8029C0CC.bin.o(.data); }
    .main_8029C1FC 0x8029C1FC : AT(0x0009CDFC) { FILL(0x00000000); build/asm/main_8029C1FC.s.o(.text); build/asm/main_8029C1FC.s.o(.rodata); build/asm/main_8029C1FC.s.o(.data); }
    .main_8029C1FC_bss (NOLOAD) : { build/asm/main_8029C1FC.s.o(.bss); }
    .main_8029C21C 0x8029C21C : AT(0x0009CE1C) { build/asm/data/main_8029C21C.bin.o(.data); }
    .main_8029CB48 0x8029CB48 : AT(0x0009D748) { FILL(0x00000000); build/asm/main_8029CB48.s.o(.text); build/asm/main_8029CB48.s.o(.rodata); build/asm/main_8029CB48.s.o(.data); }
    .main_8029CB48_bss (NOLOAD) : { build/asm/main_8029CB48.s.o(.bss); }
    .main_8029CB74 0x8029CB74 : AT(0x0009D774) { build/asm/data/main_8029CB74.bin.o(.data); }
    .main_8029CD94 0x8029CD94 : AT(0x0009D994) { FILL(0x00000000); build/asm/main_8029CD94.s.o(.text); build/asm/main_8029CD94.s.o(.rodata); build/asm/main_8029CD94.s.o(.data); }
    .main_8029CD94_bss (NOLOAD) : { build/asm/main_8029CD94.s.o(.bss); }
    .main_8029CFBC 0x8029CFBC : AT(0x0009DBBC) { build/asm/data/main_8029CFBC.bin.o(.data); }
    .main_8029D2C0 0x8029D2C0 : AT(0x0009DEC0) { FILL(0x00000000); build/asm/main_8029D2C0.s.o(.text); build/asm/main_8029D2C0.s.o(.rodata); build/asm/main_8029D2C0.s.o(.data); }
    .main_8029D2C0_bss (NOLOAD) : { build/asm/main_8029D2C0.s.o(.bss); }
    .main_8029D40C 0x8029D40C : AT(0x0009E00C) { build/asm/data/main_8029D40C.bin.o(.data); }
    .main_8029DBA4 0x8029DBA4 : AT(0x0009E7A4) { FILL(0x00000000); build/asm/main_8029DBA4.s.o(.text); build/asm/main_8029DBA4.s.o(.rodata); build/asm/main_8029DBA4.s.o(.data); }
    .main_8029DBA4_bss (NOLOAD) : { build/asm/main_8029DBA4.s.o(.bss); }
    .main_8029DBE8 0x8029DBE8 : AT(0x0009E7E8) { build/asm/data/main_8029DBE8.bin.o(.data); }
    .main_8029E4D8 0x8029E4D8 : AT(0x0009F0D8) { FILL(0x00000000); build/asm/main_8029E4D8.s.o(.text); build/asm/main_8029E4D8.s.o(.rodata); build/asm/main_8029E4D8.s.o(.data); }
    .main_8029E4D8_bss (NOLOAD) : { build/asm/main_8029E4D8.s.o(.bss); }
    .main_8029E508 0x8029E508 : AT(0x0009F108) { build/asm/data/main_8029E508.bin.o(.data); }
    .main_8029E910 0x8029E910 : AT(0x0009F510) { FILL(0x00000000); build/asm/main_8029E910.s.o(.text); build/asm/main_8029E910.s.o(.rodata); build/asm/main_8029E910.s.o(.data); }
    .main_8029E910_bss (NOLOAD) : { build/asm/main_8029E910.s.o(.bss); }
    .main_8029E968 0x8029E968 : AT(0x0009F568) { build/asm/data/main_8029E968.bin.o(.data); }
    .main_8029E970 0x8029E970 : AT(0x0009F570) { FILL(0x00000000); build/asm/main_8029E970.s.o(.text); build/asm/main_8029E970.s.o(.rodata); build/asm/main_8029E970.s.o(.data); }
    .main_8029E970_bss (NOLOAD) : { build/asm/main_8029E970.s.o(.bss); }
    .main_8029EA04 0x8029EA04 : AT(0x0009F604) { build/asm/data/main_8029EA04.bin.o(.data); }
    .main_8029ED34 0x8029ED34 : AT(0x0009F934) { FILL(0x00000000); build/asm/main_8029ED34.s.o(.text); build/asm/main_8029ED34.s.o(.rodata); build/asm/main_8029ED34.s.o(.data); }
    .main_8029ED34_bss (NOLOAD) : { build/asm/main_8029ED34.s.o(.bss); }
    .main_8029ED58 0x8029ED58 : AT(0x0009F958) { build/asm/data/main_8029ED58.bin.o(.data); }
    .main_8029EF14 0x8029EF14 : AT(0x0009FB14) { FILL(0x00000000); build/asm/main_8029EF14.s.o(.text); build/asm/main_8029EF14.s.o(.rodata); build/asm/main_8029EF14.s.o(.data); }
    .main_8029EF14_bss (NOLOAD) : { build/asm/main_8029EF14.s.o(.bss); }
    .main_8029EF28 0x8029EF28 : AT(0x0009FB28) { build/asm/data/main_8029EF28.bin.o(.data); }
    .main_8029F3AC 0x8029F3AC : AT(0x0009FFAC) { FILL(0x00000000); build/asm/main_8029F3AC.s.o(.text); build/asm/main_8029F3AC.s.o(.rodata); build/asm/main_8029F3AC.s.o(.data); }
    .main_8029F3AC_bss (NOLOAD) : { build/asm/main_8029F3AC.s.o(.bss); }
    .main_8029F3B0 0x8029F3B0 : AT(0x0009FFB0) { build/asm/data/main_8029F3B0.bin.o(.data); }
    .main_8029F84C 0x8029F84C : AT(0x000A044C) { FILL(0x00000000); build/asm/main_8029F84C.s.o(.text); build/asm/main_8029F84C.s.o(.rodata); build/asm/main_8029F84C.s.o(.data); }
    .main_8029F84C_bss (NOLOAD) : { build/asm/main_8029F84C.s.o(.bss); }
    .main_8029F884 0x8029F884 : AT(0x000A0484) { build/asm/data/main_8029F884.bin.o(.data); }
    .main_8029FE70 0x8029FE70 : AT(0x000A0A70) { FILL(0x00000000); build/asm/main_8029FE70.s.o(.text); build/asm/main_8029FE70.s.o(.rodata); build/asm/main_8029FE70.s.o(.data); }
    .main_8029FE70_bss (NOLOAD) : { build/asm/main_8029FE70.s.o(.bss); }
    .main_8029FEA4 0x8029FEA4 : AT(0x000A0AA4) { build/asm/data/main_8029FEA4.bin.o(.data); }
    .main_802A00A4 0x802A00A4 : AT(0x000A0CA4) { FILL(0x00000000); build/asm/main_802A00A4.s.o(.text); build/asm/main_802A00A4.s.o(.rodata); build/asm/main_802A00A4.s.o(.data); }
    .main_802A00A4_bss (NOLOAD) : { build/asm/main_802A00A4.s.o(.bss); }
    .main_802A00B4 0x802A00B4 : AT(0x000A0CB4) { build/asm/data/main_802A00B4.bin.o(.data); }
    .main_802A0B44 0x802A0B44 : AT(0x000A1744) { FILL(0x00000000); build/asm/main_802A0B44.s.o(.text); build/asm/main_802A0B44.s.o(.rodata); build/asm/main_802A0B44.s.o(.data); }
    .main_802A0B44_bss (NOLOAD) : { build/asm/main_802A0B44.s.o(.bss); }
    .main_802A0B50 0x802A0B50 : AT(0x000A1750) { build/asm/data/main_802A0B50.bin.o(.data); }
    .main_802A0F58 0x802A0F58 : AT(0x000A1B58) { FILL(0x00000000); build/asm/main_802A0F58.s.o(.text); build/asm/main_802A0F58.s.o(.rodata); build/asm/main_802A0F58.s.o(.data); }
    .main_802A0F58_bss (NOLOAD) : { build/asm/main_802A0F58.s.o(.bss); }
    .main_802A0FBC 0x802A0FBC : AT(0x000A1BBC) { build/asm/data/main_802A0FBC.bin.o(.data); }
    .main_802A1C50 0x802A1C50 : AT(0x000A2850) { FILL(0x00000000); build/asm/main_802A1C50.s.o(.text); build/asm/main_802A1C50.s.o(.rodata); build/asm/main_802A1C50.s.o(.data); }
    .main_802A1C50_bss (NOLOAD) : { build/asm/main_802A1C50.s.o(.bss); }
    .main_802A1C78 0x802A1C78 : AT(0x000A2878) { build/asm/data/main_802A1C78.bin.o(.data); }
    .main_802A1E34 0x802A1E34 : AT(0x000A2A34) { FILL(0x00000000); build/asm/main_802A1E34.s.o(.text); build/asm/main_802A1E34.s.o(.rodata); build/asm/main_802A1E34.s.o(.data); }
    .main_802A1E34_bss (NOLOAD) : { build/asm/main_802A1E34.s.o(.bss); }
    .main_802A1E48 0x802A1E48 : AT(0x000A2A48) { build/asm/data/main_802A1E48.bin.o(.data); }
    .main_802A21AC 0x802A21AC : AT(0x000A2DAC) { FILL(0x00000000); build/asm/main_802A21AC.s.o(.text); build/asm/main_802A21AC.s.o(.rodata); build/asm/main_802A21AC.s.o(.data); }
    .main_802A21AC_bss (NOLOAD) : { build/asm/main_802A21AC.s.o(.bss); }
    .main_802A21D4 0x802A21D4 : AT(0x000A2DD4) { build/asm/data/main_802A21D4.bin.o(.data); }
    .main_802A2728 0x802A2728 : AT(0x000A3328) { FILL(0x00000000); build/asm/main_802A2728.s.o(.text); build/asm/main_802A2728.s.o(.rodata); build/asm/main_802A2728.s.o(.data); }
    .main_802A2728_bss (NOLOAD) : { build/asm/main_802A2728.s.o(.bss); }
    .main_802A2740 0x802A2740 : AT(0x000A3340) { build/asm/data/main_802A2740.bin.o(.data); }
    .main_802A32EC 0x802A32EC : AT(0x000A3EEC) { FILL(0x00000000); build/asm/main_802A32EC.s.o(.text); build/asm/main_802A32EC.s.o(.rodata); build/asm/main_802A32EC.s.o(.data); }
    .main_802A32EC_bss (NOLOAD) : { build/asm/main_802A32EC.s.o(.bss); }
    .main_802A334C 0x802A334C : AT(0x000A3F4C) { build/asm/data/main_802A334C.bin.o(.data); }
    .main_802A33B8 0x802A33B8 : AT(0x000A3FB8) { FILL(0x00000000); build/asm/main_802A33B8.s.o(.text); build/asm/main_802A33B8.s.o(.rodata); build/asm/main_802A33B8.s.o(.data); }
    .main_802A33B8_bss (NOLOAD) : { build/asm/main_802A33B8.s.o(.bss); }
    .main_802A34B8 0x802A34B8 : AT(0x000A40B8) { build/asm/data/main_802A34B8.bin.o(.data); }
    .main_802A3790 0x802A3790 : AT(0x000A4390) { FILL(0x00000000); build/asm/main_802A3790.s.o(.text); build/asm/main_802A3790.s.o(.rodata); build/asm/main_802A3790.s.o(.data); }
    .main_802A3790_bss (NOLOAD) : { build/asm/main_802A3790.s.o(.bss); }
    .main_802A37A8 0x802A37A8 : AT(0x000A43A8) { build/asm/data/main_802A37A8.bin.o(.data); }
    .main_802A3C88 0x802A3C88 : AT(0x000A4888) { FILL(0x00000000); build/asm/main_802A3C88.s.o(.text); build/asm/main_802A3C88.s.o(.rodata); build/asm/main_802A3C88.s.o(.data); }
    .main_802A3C88_bss (NOLOAD) : { build/asm/main_802A3C88.s.o(.bss); }
    .main_802A3CE0 0x802A3CE0 : AT(0x000A48E0) { build/asm/data/main_802A3CE0.bin.o(.data); }
    .main_802A3E08 0x802A3E08 : AT(0x000A4A08) { FILL(0x00000000); build/asm/main_802A3E08.s.o(.text); build/asm/main_802A3E08.s.o(.rodata); build/asm/main_802A3E08.s.o(.data); }
    .main_802A3E08_bss (NOLOAD) : { build/asm/main_802A3E08.s.o(.bss); }
    .main_802A3E1C 0x802A3E1C : AT(0x000A4A1C) { build/asm/data/main_802A3E1C.bin.o(.data); }
    .main_802A4364 0x802A4364 : AT(0x000A4F64) { FILL(0x00000000); build/asm/main_802A4364.s.o(.text); build/asm/main_802A4364.s.o(.rodata); build/asm/main_802A4364.s.o(.data); }
    .main_802A4364_bss (NOLOAD) : { build/asm/main_802A4364.s.o(.bss); }
    .main_802A43B0 0x802A43B0 : AT(0x000A4FB0) { build/asm/data/main_802A43B0.bin.o(.data); }
    .main_802A4708 0x802A4708 : AT(0x000A5308) { FILL(0x00000000); build/asm/main_802A4708.s.o(.text); build/asm/main_802A4708.s.o(.rodata); build/asm/main_802A4708.s.o(.data); }
    .main_802A4708_bss (NOLOAD) : { build/asm/main_802A4708.s.o(.bss); }
    .main_802A4728 0x802A4728 : AT(0x000A5328) { build/asm/data/main_802A4728.bin.o(.data); }
    .main_802A52E8 0x802A52E8 : AT(0x000A5EE8) { FILL(0x00000000); build/asm/main_802A52E8.s.o(.text); build/asm/main_802A52E8.s.o(.rodata); build/asm/main_802A52E8.s.o(.data); }
    .main_802A52E8_bss (NOLOAD) : { build/asm/main_802A52E8.s.o(.bss); }
    .main_802A5364 0x802A5364 : AT(0x000A5F64) { build/asm/data/main_802A5364.bin.o(.data); }
    .main_802A553C 0x802A553C : AT(0x000A613C) { FILL(0x00000000); build/asm/main_802A553C.s.o(.text); build/asm/main_802A553C.s.o(.rodata); build/asm/main_802A553C.s.o(.data); }
    .main_802A553C_bss (NOLOAD) : { build/asm/main_802A553C.s.o(.bss); }
    .main_802A5590 0x802A5590 : AT(0x000A6190) { build/asm/data/main_802A5590.bin.o(.data); }
    .main_802A5D8C 0x802A5D8C : AT(0x000A698C) { FILL(0x00000000); build/asm/main_802A5D8C.s.o(.text); build/asm/main_802A5D8C.s.o(.rodata); build/asm/main_802A5D8C.s.o(.data); }
    .main_802A5D8C_bss (NOLOAD) : { build/asm/main_802A5D8C.s.o(.bss); }
    .main_802A5D90 0x802A5D90 : AT(0x000A6990) { build/asm/data/main_802A5D90.bin.o(.data); }
    .main_802A6014 0x802A6014 : AT(0x000A6C14) { FILL(0x00000000); build/asm/main_802A6014.s.o(.text); build/asm/main_802A6014.s.o(.rodata); build/asm/main_802A6014.s.o(.data); }
    .main_802A6014_bss (NOLOAD) : { build/asm/main_802A6014.s.o(.bss); }
    .main_802A6120 0x802A6120 : AT(0x000A6D20) { build/asm/data/main_802A6120.bin.o(.data); }
    .main_802A6414 0x802A6414 : AT(0x000A7014) { FILL(0x00000000); build/asm/main_802A6414.s.o(.text); build/asm/main_802A6414.s.o(.rodata); build/asm/main_802A6414.s.o(.data); }
    .main_802A6414_bss (NOLOAD) : { build/asm/main_802A6414.s.o(.bss); }
    .main_802A64A8 0x802A64A8 : AT(0x000A70A8) { build/asm/data/main_802A64A8.bin.o(.data); }
    .main_802A6580 0x802A6580 : AT(0x000A7180) { FILL(0x00000000); build/asm/main_802A6580.s.o(.text); build/asm/main_802A6580.s.o(.rodata); build/asm/main_802A6580.s.o(.data); }
    .main_802A6580_bss (NOLOAD) : { build/asm/main_802A6580.s.o(.bss); }
    .main_802A65A0 0x802A65A0 : AT(0x000A71A0) { build/asm/data/main_802A65A0.bin.o(.data); }
    .main_802A6D10 0x802A6D10 : AT(0x000A7910) { FILL(0x00000000); build/asm/main_802A6D10.s.o(.text); build/asm/main_802A6D10.s.o(.rodata); build/asm/main_802A6D10.s.o(.data); }
    .main_802A6D10_bss (NOLOAD) : { build/asm/main_802A6D10.s.o(.bss); }
    .main_802A6D2C 0x802A6D2C : AT(0x000A792C) { build/asm/data/main_802A6D2C.bin.o(.data); }
    .main_802A768C 0x802A768C : AT(0x000A828C) { FILL(0x00000000); build/asm/main_802A768C.s.o(.text); build/asm/main_802A768C.s.o(.rodata); build/asm/main_802A768C.s.o(.data); }
    .main_802A768C_bss (NOLOAD) : { build/asm/main_802A768C.s.o(.bss); }
    .main_802A7744 0x802A7744 : AT(0x000A8344) { build/asm/data/main_802A7744.bin.o(.data); }
    .main_802A7EBC 0x802A7EBC : AT(0x000A8ABC) { FILL(0x00000000); build/asm/main_802A7EBC.s.o(.text); build/asm/main_802A7EBC.s.o(.rodata); build/asm/main_802A7EBC.s.o(.data); }
    .main_802A7EBC_bss (NOLOAD) : { build/asm/main_802A7EBC.s.o(.bss); }
    .main_802A8550 0x802A8550 : AT(0x000A9150) { build/asm/data/main_802A8550.bin.o(.data); }
    .main_802A9758 0x802A9758 : AT(0x000AA358) { FILL(0x00000000); build/asm/main_802A9758.s.o(.text); build/asm/main_802A9758.s.o(.rodata); build/asm/main_802A9758.s.o(.data); }
    .main_802A9758_bss (NOLOAD) : { build/asm/main_802A9758.s.o(.bss); }
    .main_802A9824 0x802A9824 : AT(0x000AA424) { build/asm/data/main_802A9824.bin.o(.data); }
    .main_802ABA98 0x802ABA98 : AT(0x000AC698) { FILL(0x00000000); build/asm/main_802ABA98.s.o(.text); build/asm/main_802ABA98.s.o(.rodata); build/asm/main_802ABA98.s.o(.data); }
    .main_802ABA98_bss (NOLOAD) : { build/asm/main_802ABA98.s.o(.bss); }
    .main_802ABACC 0x802ABACC : AT(0x000AC6CC) { build/asm/data/main_802ABACC.bin.o(.data); }
    .main_802ABB00 0x802ABB00 : AT(0x000AC700) { FILL(0x00000000); build/asm/main_802ABB00.s.o(.text); build/asm/main_802ABB00.s.o(.rodata); build/asm/main_802ABB00.s.o(.data); }
    .main_802ABB00_bss (NOLOAD) : { build/asm/main_802ABB00.s.o(.bss); }
    .main_802ABB38 0x802ABB38 : AT(0x000AC738) { build/asm/data/main_802ABB38.bin.o(.data); }
    .main_802AC228 0x802AC228 : AT(0x000ACE28) { FILL(0x00000000); build/asm/main_802AC228.s.o(.text); build/asm/main_802AC228.s.o(.rodata); build/asm/main_802AC228.s.o(.data); }
    .main_802AC228_bss (NOLOAD) : { build/asm/main_802AC228.s.o(.bss); }
    .main_802AC268 0x802AC268 : AT(0x000ACE68) { build/asm/data/main_802AC268.bin.o(.data); }
    .main_802AC378 0x802AC378 : AT(0x000ACF78) { FILL(0x00000000); build/asm/main_802AC378.s.o(.text); build/asm/main_802AC378.s.o(.rodata); build/asm/main_802AC378.s.o(.data); }
    .main_802AC378_bss (NOLOAD) : { build/asm/main_802AC378.s.o(.bss); }
    .main_802AC3D0 0x802AC3D0 : AT(0x000ACFD0) { build/asm/data/main_802AC3D0.bin.o(.data); }
    .main_802AC898 0x802AC898 : AT(0x000AD498) { FILL(0x00000000); build/asm/main_802AC898.s.o(.text); build/asm/main_802AC898.s.o(.rodata); build/asm/main_802AC898.s.o(.data); }
    .main_802AC898_bss (NOLOAD) : { build/asm/main_802AC898.s.o(.bss); }
    .main_802AC89C 0x802AC89C : AT(0x000AD49C) { build/asm/data/main_802AC89C.bin.o(.data); }
    .main_802AD114 0x802AD114 : AT(0x000ADD14) { FILL(0x00000000); build/asm/main_802AD114.s.o(.text); build/asm/main_802AD114.s.o(.rodata); build/asm/main_802AD114.s.o(.data); }
    .main_802AD114_bss (NOLOAD) : { build/asm/main_802AD114.s.o(.bss); }
    .main_802AD128 0x802AD128 : AT(0x000ADD28) { build/asm/data/main_802AD128.bin.o(.data); }
    .main_802AD358 0x802AD358 : AT(0x000ADF58) { FILL(0x00000000); build/asm/main_802AD358.s.o(.text); build/asm/main_802AD358.s.o(.rodata); build/asm/main_802AD358.s.o(.data); }
    .main_802AD358_bss (NOLOAD) : { build/asm/main_802AD358.s.o(.bss); }
    .main_802AD3A0 0x802AD3A0 : AT(0x000ADFA0) { build/asm/data/main_802AD3A0.bin.o(.data); }
    .main_802ADB94 0x802ADB94 : AT(0x000AE794) { FILL(0x00000000); build/asm/main_802ADB94.s.o(.text); build/asm/main_802ADB94.s.o(.rodata); build/asm/main_802ADB94.s.o(.data); }
    .main_802ADB94_bss (NOLOAD) : { build/asm/main_802ADB94.s.o(.bss); }
    .main_802ADB98 0x802ADB98 : AT(0x000AE798) { build/asm/data/main_802ADB98.bin.o(.data); }
    .main_802AE520 0x802AE520 : AT(0x000AF120) { FILL(0x00000000); build/asm/main_802AE520.s.o(.text); build/asm/main_802AE520.s.o(.rodata); build/asm/main_802AE520.s.o(.data); }
    .main_802AE520_bss (NOLOAD) : { build/asm/main_802AE520.s.o(.bss); }
    .main_802AE590 0x802AE590 : AT(0x000AF190) { build/asm/data/main_802AE590.bin.o(.data); }
    .main_802AE8DC 0x802AE8DC : AT(0x000AF4DC) { FILL(0x00000000); build/asm/main_802AE8DC.s.o(.text); build/asm/main_802AE8DC.s.o(.rodata); build/asm/main_802AE8DC.s.o(.data); }
    .main_802AE8DC_bss (NOLOAD) : { build/asm/main_802AE8DC.s.o(.bss); }
    .main_802AE964 0x802AE964 : AT(0x000AF564) { build/asm/data/main_802AE964.bin.o(.data); }
    .main_802AF17C 0x802AF17C : AT(0x000AFD7C) { FILL(0x00000000); build/asm/main_802AF17C.s.o(.text); build/asm/main_802AF17C.s.o(.rodata); build/asm/main_802AF17C.s.o(.data); }
    .main_802AF17C_bss (NOLOAD) : { build/asm/main_802AF17C.s.o(.bss); }
    .main_802AF270 0x802AF270 : AT(0x000AFE70) { build/asm/data/main_802AF270.bin.o(.data); }
    .main_802AF54C 0x802AF54C : AT(0x000B014C) { FILL(0x00000000); build/asm/main_802AF54C.s.o(.text); build/asm/main_802AF54C.s.o(.rodata); build/asm/main_802AF54C.s.o(.data); }
    .main_802AF54C_bss (NOLOAD) : { build/asm/main_802AF54C.s.o(.bss); }
    .main_802AF56C 0x802AF56C : AT(0x000B016C) { build/asm/data/main_802AF56C.bin.o(.data); }
    .main_802B08E4 0x802B08E4 : AT(0x000B14E4) { FILL(0x00000000); build/asm/main_802B08E4.s.o(.text); build/asm/main_802B08E4.s.o(.rodata); build/asm/main_802B08E4.s.o(.data); }
    .main_802B08E4_bss (NOLOAD) : { build/asm/main_802B08E4.s.o(.bss); }
    .main_802B08F0 0x802B08F0 : AT(0x000B14F0) { build/asm/data/main_802B08F0.bin.o(.data); }
    .main_802B0B1C 0x802B0B1C : AT(0x000B171C) { FILL(0x00000000); build/asm/main_802B0B1C.s.o(.text); build/asm/main_802B0B1C.s.o(.rodata); build/asm/main_802B0B1C.s.o(.data); }
    .main_802B0B1C_bss (NOLOAD) : { build/asm/main_802B0B1C.s.o(.bss); }
    .main_802B0B84 0x802B0B84 : AT(0x000B1784) { build/asm/data/main_802B0B84.bin.o(.data); }
    .main_802B0CB4 0x802B0CB4 : AT(0x000B18B4) { FILL(0x00000000); build/asm/main_802B0CB4.s.o(.text); build/asm/main_802B0CB4.s.o(.rodata); build/asm/main_802B0CB4.s.o(.data); }
    .main_802B0CB4_bss (NOLOAD) : { build/asm/main_802B0CB4.s.o(.bss); }
    .main_802B0CC4 0x802B0CC4 : AT(0x000B18C4) { build/asm/data/main_802B0CC4.bin.o(.data); }
    .main_802B26E8 0x802B26E8 : AT(0x000B32E8) { FILL(0x00000000); build/asm/main_802B26E8.s.o(.text); build/asm/main_802B26E8.s.o(.rodata); build/asm/main_802B26E8.s.o(.data); }
    .main_802B26E8_bss (NOLOAD) : { build/asm/main_802B26E8.s.o(.bss); }
    .main_802B2764 0x802B2764 : AT(0x000B3364) { build/asm/data/main_802B2764.bin.o(.data); }
    .main_802B2854 0x802B2854 : AT(0x000B3454) { FILL(0x00000000); build/asm/main_802B2854.s.o(.text); build/asm/main_802B2854.s.o(.rodata); build/asm/main_802B2854.s.o(.data); }
    .main_802B2854_bss (NOLOAD) : { build/asm/main_802B2854.s.o(.bss); }
    .main_802B2870 0x802B2870 : AT(0x000B3470) { build/asm/data/main_802B2870.bin.o(.data); }
    .main_802B2BD4 0x802B2BD4 : AT(0x000B37D4) { FILL(0x00000000); build/asm/main_802B2BD4.s.o(.text); build/asm/main_802B2BD4.s.o(.rodata); build/asm/main_802B2BD4.s.o(.data); }
    .main_802B2BD4_bss (NOLOAD) : { build/asm/main_802B2BD4.s.o(.bss); }
    .main_802B2E54 0x802B2E54 : AT(0x000B3A54) { build/asm/data/main_802B2E54.bin.o(.data); }
    .main_802B33F0 0x802B33F0 : AT(0x000B3FF0) { FILL(0x00000000); build/asm/main_802B33F0.s.o(.text); build/asm/main_802B33F0.s.o(.rodata); build/asm/main_802B33F0.s.o(.data); }
    .main_802B33F0_bss (NOLOAD) : { build/asm/main_802B33F0.s.o(.bss); }
    .main_802B3404 0x802B3404 : AT(0x000B4004) { build/asm/data/main_802B3404.bin.o(.data); }
    .main_802B3474 0x802B3474 : AT(0x000B4074) { FILL(0x00000000); build/asm/main_802B3474.s.o(.text); build/asm/main_802B3474.s.o(.rodata); build/asm/main_802B3474.s.o(.data); }
    .main_802B3474_bss (NOLOAD) : { build/asm/main_802B3474.s.o(.bss); }
    .main_802B356C 0x802B356C : AT(0x000B416C) { build/asm/data/main_802B356C.bin.o(.data); }
    .main_802B36E0 0x802B36E0 : AT(0x000B42E0) { FILL(0x00000000); build/asm/main_802B36E0.s.o(.text); build/asm/main_802B36E0.s.o(.rodata); build/asm/main_802B36E0.s.o(.data); }
    .main_802B36E0_bss (NOLOAD) : { build/asm/main_802B36E0.s.o(.bss); }
    .main_802B36F4 0x802B36F4 : AT(0x000B42F4) { build/asm/data/main_802B36F4.bin.o(.data); }
    .main_802B3928 0x802B3928 : AT(0x000B4528) { FILL(0x00000000); build/asm/main_802B3928.s.o(.text); build/asm/main_802B3928.s.o(.rodata); build/asm/main_802B3928.s.o(.data); }
    .main_802B3928_bss (NOLOAD) : { build/asm/main_802B3928.s.o(.bss); }
    .main_802B39D0 0x802B39D0 : AT(0x000B45D0) { build/asm/data/main_802B39D0.bin.o(.data); }
    .main_802B3BC4 0x802B3BC4 : AT(0x000B47C4) { FILL(0x00000000); build/asm/main_802B3BC4.s.o(.text); build/asm/main_802B3BC4.s.o(.rodata); build/asm/main_802B3BC4.s.o(.data); }
    .main_802B3BC4_bss (NOLOAD) : { build/asm/main_802B3BC4.s.o(.bss); }
    .main_802B3C5C 0x802B3C5C : AT(0x000B485C) { build/asm/data/main_802B3C5C.bin.o(.data); }
    .main_802B3FC8 0x802B3FC8 : AT(0x000B4BC8) { FILL(0x00000000); build/asm/main_802B3FC8.s.o(.text); build/asm/main_802B3FC8.s.o(.rodata); build/asm/main_802B3FC8.s.o(.data); }
    .main_802B3FC8_bss (NOLOAD) : { build/asm/main_802B3FC8.s.o(.bss); }
    .main_802B4058 0x802B4058 : AT(0x000B4C58) { build/asm/data/main_802B4058.bin.o(.data); }
    .main_802B4C3C 0x802B4C3C : AT(0x000B583C) { FILL(0x00000000); build/asm/main_802B4C3C.s.o(.text); build/asm/main_802B4C3C.s.o(.rodata); build/asm/main_802B4C3C.s.o(.data); }
    .main_802B4C3C_bss (NOLOAD) : { build/asm/main_802B4C3C.s.o(.bss); }
    .main_802B4C6C 0x802B4C6C : AT(0x000B586C) { build/asm/data/main_802B4C6C.bin.o(.data); }
    .main_802B5388 0x802B5388 : AT(0x000B5F88) { FILL(0x00000000); build/asm/main_802B5388.s.o(.text); build/asm/main_802B5388.s.o(.rodata); build/asm/main_802B5388.s.o(.data); }
    .main_802B5388_bss (NOLOAD) : { build/asm/main_802B5388.s.o(.bss); }
    .main_802B53B8 0x802B53B8 : AT(0x000B5FB8) { build/asm/data/main_802B53B8.bin.o(.data); }
    .main_802B6018 0x802B6018 : AT(0x000B6C18) { FILL(0x00000000); build/asm/main_802B6018.s.o(.text); build/asm/main_802B6018.s.o(.rodata); build/asm/main_802B6018.s.o(.data); }
    .main_802B6018_bss (NOLOAD) : { build/asm/main_802B6018.s.o(.bss); }
    .main_802B6034 0x802B6034 : AT(0x000B6C34) { build/asm/data/main_802B6034.bin.o(.data); }
    .main_802B6404 0x802B6404 : AT(0x000B7004) { FILL(0x00000000); build/asm/main_802B6404.s.o(.text); build/asm/main_802B6404.s.o(.rodata); build/asm/main_802B6404.s.o(.data); }
    .main_802B6404_bss (NOLOAD) : { build/asm/main_802B6404.s.o(.bss); }
    .main_802B640C 0x802B640C : AT(0x000B700C) { build/asm/data/main_802B640C.bin.o(.data); }
    .main_802B7180 0x802B7180 : AT(0x000B7D80) { FILL(0x00000000); build/asm/main_802B7180.s.o(.text); build/asm/main_802B7180.s.o(.rodata); build/asm/main_802B7180.s.o(.data); }
    .main_802B7180_bss (NOLOAD) : { build/asm/main_802B7180.s.o(.bss); }
    .main_802B7184 0x802B7184 : AT(0x000B7D84) { build/asm/data/main_802B7184.bin.o(.data); }
    .main_802B76A8 0x802B76A8 : AT(0x000B82A8) { FILL(0x00000000); build/asm/main_802B76A8.s.o(.text); build/asm/main_802B76A8.s.o(.rodata); build/asm/main_802B76A8.s.o(.data); }
    .main_802B76A8_bss (NOLOAD) : { build/asm/main_802B76A8.s.o(.bss); }
    .main_802B76B4 0x802B76B4 : AT(0x000B82B4) { build/asm/data/main_802B76B4.bin.o(.data); }
    .main_802B7A18 0x802B7A18 : AT(0x000B8618) { FILL(0x00000000); build/asm/main_802B7A18.s.o(.text); build/asm/main_802B7A18.s.o(.rodata); build/asm/main_802B7A18.s.o(.data); }
    .main_802B7A18_bss (NOLOAD) : { build/asm/main_802B7A18.s.o(.bss); }
    .main_802B7A34 0x802B7A34 : AT(0x000B8634) { build/asm/data/main_802B7A34.bin.o(.data); }
    .main_802B7AF8 0x802B7AF8 : AT(0x000B86F8) { FILL(0x00000000); build/asm/main_802B7AF8.s.o(.text); build/asm/main_802B7AF8.s.o(.rodata); build/asm/main_802B7AF8.s.o(.data); }
    .main_802B7AF8_bss (NOLOAD) : { build/asm/main_802B7AF8.s.o(.bss); }
    .main_802B7B28 0x802B7B28 : AT(0x000B8728) { build/asm/data/main_802B7B28.bin.o(.data); }
    .main_802B864C 0x802B864C : AT(0x000B924C) { FILL(0x00000000); build/asm/main_802B864C.s.o(.text); build/asm/main_802B864C.s.o(.rodata); build/asm/main_802B864C.s.o(.data); }
    .main_802B864C_bss (NOLOAD) : { build/asm/main_802B864C.s.o(.bss); }
    .main_802B8654 0x802B8654 : AT(0x000B9254) { build/asm/data/main_802B8654.bin.o(.data); }
    .main_802B9430 0x802B9430 : AT(0x000BA030) { FILL(0x00000000); build/asm/main_802B9430.s.o(.text); build/asm/main_802B9430.s.o(.rodata); build/asm/main_802B9430.s.o(.data); }
    .main_802B9430_bss (NOLOAD) : { build/asm/main_802B9430.s.o(.bss); }
    .main_802B9450 0x802B9450 : AT(0x000BA050) { build/asm/data/main_802B9450.bin.o(.data); }
    .main_802B98C0 0x802B98C0 : AT(0x000BA4C0) { FILL(0x00000000); build/asm/main_802B98C0.s.o(.text); build/asm/main_802B98C0.s.o(.rodata); build/asm/main_802B98C0.s.o(.data); }
    .main_802B98C0_bss (NOLOAD) : { build/asm/main_802B98C0.s.o(.bss); }
    .main_802B99B0 0x802B99B0 : AT(0x000BA5B0) { build/asm/data/main_802B99B0.bin.o(.data); }
    .main_802B9B00 0x802B9B00 : AT(0x000BA700) { FILL(0x00000000); build/asm/main_802B9B00.s.o(.text); build/asm/main_802B9B00.s.o(.rodata); build/asm/main_802B9B00.s.o(.data); }
    .main_802B9B00_bss (NOLOAD) : { build/asm/main_802B9B00.s.o(.bss); }
    .main_802B9B64 0x802B9B64 : AT(0x000BA764) { build/asm/data/main_802B9B64.bin.o(.data); }
    .main_802BA3AC 0x802BA3AC : AT(0x000BAFAC) { FILL(0x00000000); build/asm/main_802BA3AC.s.o(.text); build/asm/main_802BA3AC.s.o(.rodata); build/asm/main_802BA3AC.s.o(.data); }
    .main_802BA3AC_bss (NOLOAD) : { build/asm/main_802BA3AC.s.o(.bss); }
    .main_802BA3C0 0x802BA3C0 : AT(0x000BAFC0) { build/asm/data/main_802BA3C0.bin.o(.data); }
    .main_802BA8C0 0x802BA8C0 : AT(0x000BB4C0) { FILL(0x00000000); build/asm/main_802BA8C0.s.o(.text); build/asm/main_802BA8C0.s.o(.rodata); build/asm/main_802BA8C0.s.o(.data); }
    .main_802BA8C0_bss (NOLOAD) : { build/asm/main_802BA8C0.s.o(.bss); }
    .main_802BA8EC 0x802BA8EC : AT(0x000BB4EC) { build/asm/data/main_802BA8EC.bin.o(.data); }
    .main_802BB2A0 0x802BB2A0 : AT(0x000BBEA0) { FILL(0x00000000); build/asm/main_802BB2A0.s.o(.text); build/asm/main_802BB2A0.s.o(.rodata); build/asm/main_802BB2A0.s.o(.data); }
    .main_802BB2A0_bss (NOLOAD) : { build/asm/main_802BB2A0.s.o(.bss); }
    .main_802BB2C4 0x802BB2C4 : AT(0x000BBEC4) { build/asm/data/main_802BB2C4.bin.o(.data); }
    .main_802BCF30 0x802BCF30 : AT(0x000BDB30) { FILL(0x00000000); build/asm/main_802BCF30.s.o(.text); build/asm/main_802BCF30.s.o(.rodata); build/asm/main_802BCF30.s.o(.data); }
    .main_802BCF30_bss (NOLOAD) : { build/asm/main_802BCF30.s.o(.bss); }
    .main_802BCF90 0x802BCF90 : AT(0x000BDB90) { build/asm/data/main_802BCF90.bin.o(.data); }
    .main_802BD1FC 0x802BD1FC : AT(0x000BDDFC) { FILL(0x00000000); build/asm/main_802BD1FC.s.o(.text); build/asm/main_802BD1FC.s.o(.rodata); build/asm/main_802BD1FC.s.o(.data); }
    .main_802BD1FC_bss (NOLOAD) : { build/asm/main_802BD1FC.s.o(.bss); }
    .main_802BD24C 0x802BD24C : AT(0x000BDE4C) { build/asm/data/main_802BD24C.bin.o(.data); }
    .main_802BDDD4 0x802BDDD4 : AT(0x000BE9D4) { FILL(0x00000000); build/asm/main_802BDDD4.s.o(.text); build/asm/main_802BDDD4.s.o(.rodata); build/asm/main_802BDDD4.s.o(.data); }
    .main_802BDDD4_bss (NOLOAD) : { build/asm/main_802BDDD4.s.o(.bss); }
    .main_802BDDEC 0x802BDDEC : AT(0x000BE9EC) { build/asm/data/main_802BDDEC.bin.o(.data); }
    .main_802BE1E0 0x802BE1E0 : AT(0x000BEDE0) { FILL(0x00000000); build/asm/main_802BE1E0.s.o(.text); build/asm/main_802BE1E0.s.o(.rodata); build/asm/main_802BE1E0.s.o(.data); }
    .main_802BE1E0_bss (NOLOAD) : { build/asm/main_802BE1E0.s.o(.bss); }
    .main_802BE1FC 0x802BE1FC : AT(0x000BEDFC) { build/asm/data/main_802BE1FC.bin.o(.data); }
    .main_802BE978 0x802BE978 : AT(0x000BF578) { FILL(0x00000000); build/asm/main_802BE978.s.o(.text); build/asm/main_802BE978.s.o(.rodata); build/asm/main_802BE978.s.o(.data); }
    .main_802BE978_bss (NOLOAD) : { build/asm/main_802BE978.s.o(.bss); }
    .main_802BEA58 0x802BEA58 : AT(0x000BF658) { build/asm/data/main_802BEA58.bin.o(.data); }
    .main_802BEB14 0x802BEB14 : AT(0x000BF714) { FILL(0x00000000); build/asm/main_802BEB14.s.o(.text); build/asm/main_802BEB14.s.o(.rodata); build/asm/main_802BEB14.s.o(.data); }
    .main_802BEB14_bss (NOLOAD) : { build/asm/main_802BEB14.s.o(.bss); }
    .main_802BEB4C 0x802BEB4C : AT(0x000BF74C) { build/asm/data/main_802BEB4C.bin.o(.data); }
    .main_802BFCF8 0x802BFCF8 : AT(0x000C08F8) { FILL(0x00000000); build/asm/main_802BFCF8.s.o(.text); build/asm/main_802BFCF8.s.o(.rodata); build/asm/main_802BFCF8.s.o(.data); }
    .main_802BFCF8_bss (NOLOAD) : { build/asm/main_802BFCF8.s.o(.bss); }
    .main_802BFD50 0x802BFD50 : AT(0x000C0950) { build/asm/data/main_802BFD50.bin.o(.data); }
    .main_802C089C 0x802C089C : AT(0x000C149C) { FILL(0x00000000); build/asm/main_802C089C.s.o(.text); build/asm/main_802C089C.s.o(.rodata); build/asm/main_802C089C.s.o(.data); }
    .main_802C089C_bss (NOLOAD) : { build/asm/main_802C089C.s.o(.bss); }
    .main_802C08A0 0x802C08A0 : AT(0x000C14A0) { build/asm/data/main_802C08A0.bin.o(.data); }
    .main_802C0914 0x802C0914 : AT(0x000C1514) { FILL(0x00000000); build/asm/main_802C0914.s.o(.text); build/asm/main_802C0914.s.o(.rodata); build/asm/main_802C0914.s.o(.data); }
    .main_802C0914_bss (NOLOAD) : { build/asm/main_802C0914.s.o(.bss); }
    .main_802C0938 0x802C0938 : AT(0x000C1538) { build/asm/data/main_802C0938.bin.o(.data); }
    .main_802C12B8 0x802C12B8 : AT(0x000C1EB8) { FILL(0x00000000); build/asm/main_802C12B8.s.o(.text); build/asm/main_802C12B8.s.o(.rodata); build/asm/main_802C12B8.s.o(.data); }
    .main_802C12B8_bss (NOLOAD) : { build/asm/main_802C12B8.s.o(.bss); }
    .main_802C12E4 0x802C12E4 : AT(0x000C1EE4) { build/asm/data/main_802C12E4.bin.o(.data); }
    .main_802C1A74 0x802C1A74 : AT(0x000C2674) { FILL(0x00000000); build/asm/main_802C1A74.s.o(.text); build/asm/main_802C1A74.s.o(.rodata); build/asm/main_802C1A74.s.o(.data); }
    .main_802C1A74_bss (NOLOAD) : { build/asm/main_802C1A74.s.o(.bss); }
    .main_802C1B3C 0x802C1B3C : AT(0x000C273C) { build/asm/data/main_802C1B3C.bin.o(.data); }
    .main_802C1C90 0x802C1C90 : AT(0x000C2890) { FILL(0x00000000); build/asm/main_802C1C90.s.o(.text); build/asm/main_802C1C90.s.o(.rodata); build/asm/main_802C1C90.s.o(.data); }
    .main_802C1C90_bss (NOLOAD) : { build/asm/main_802C1C90.s.o(.bss); }
    .main_802C1CA4 0x802C1CA4 : AT(0x000C28A4) { build/asm/data/main_802C1CA4.bin.o(.data); }
    .main_802C2050 0x802C2050 : AT(0x000C2C50) { FILL(0x00000000); build/asm/main_802C2050.s.o(.text); build/asm/main_802C2050.s.o(.rodata); build/asm/main_802C2050.s.o(.data); }
    .main_802C2050_bss (NOLOAD) : { build/asm/main_802C2050.s.o(.bss); }
    .main_802C20F8 0x802C20F8 : AT(0x000C2CF8) { build/asm/data/main_802C20F8.bin.o(.data); }
    .main_802C24F0 0x802C24F0 : AT(0x000C30F0) { FILL(0x00000000); build/asm/main_802C24F0.s.o(.text); build/asm/main_802C24F0.s.o(.rodata); build/asm/main_802C24F0.s.o(.data); }
    .main_802C24F0_bss (NOLOAD) : { build/asm/main_802C24F0.s.o(.bss); }
    .main_802C25D4 0x802C25D4 : AT(0x000C31D4) { build/asm/data/main_802C25D4.bin.o(.data); }
    .main_802C286C 0x802C286C : AT(0x000C346C) { FILL(0x00000000); build/asm/main_802C286C.s.o(.text); build/asm/main_802C286C.s.o(.rodata); build/asm/main_802C286C.s.o(.data); }
    .main_802C286C_bss (NOLOAD) : { build/asm/main_802C286C.s.o(.bss); }
    .main_802C2884 0x802C2884 : AT(0x000C3484) { build/asm/data/main_802C2884.bin.o(.data); }
    .main_802C2BC0 0x802C2BC0 : AT(0x000C37C0) { FILL(0x00000000); build/asm/main_802C2BC0.s.o(.text); build/asm/main_802C2BC0.s.o(.rodata); build/asm/main_802C2BC0.s.o(.data); }
    .main_802C2BC0_bss (NOLOAD) : { build/asm/main_802C2BC0.s.o(.bss); }
    .main_802C2BF0 0x802C2BF0 : AT(0x000C37F0) { build/asm/data/main_802C2BF0.bin.o(.data); }
    .main_802C2F4C 0x802C2F4C : AT(0x000C3B4C) { FILL(0x00000000); build/asm/main_802C2F4C.s.o(.text); build/asm/main_802C2F4C.s.o(.rodata); build/asm/main_802C2F4C.s.o(.data); }
    .main_802C2F4C_bss (NOLOAD) : { build/asm/main_802C2F4C.s.o(.bss); }
    .main_802C3034 0x802C3034 : AT(0x000C3C34) { build/asm/data/main_802C3034.bin.o(.data); }
    .main_802C399C 0x802C399C : AT(0x000C459C) { FILL(0x00000000); build/asm/main_802C399C.s.o(.text); build/asm/main_802C399C.s.o(.rodata); build/asm/main_802C399C.s.o(.data); }
    .main_802C399C_bss (NOLOAD) : { build/asm/main_802C399C.s.o(.bss); }
    .main_802C39C4 0x802C39C4 : AT(0x000C45C4) { build/asm/data/main_802C39C4.bin.o(.data); }
    .main_802C3D04 0x802C3D04 : AT(0x000C4904) { FILL(0x00000000); build/asm/main_802C3D04.s.o(.text); build/asm/main_802C3D04.s.o(.rodata); build/asm/main_802C3D04.s.o(.data); }
    .main_802C3D04_bss (NOLOAD) : { build/asm/main_802C3D04.s.o(.bss); }
    .main_802C3D08 0x802C3D08 : AT(0x000C4908) { build/asm/data/main_802C3D08.bin.o(.data); }
    .main_802C4960 0x802C4960 : AT(0x000C5560) { FILL(0x00000000); build/asm/main_802C4960.s.o(.text); build/asm/main_802C4960.s.o(.rodata); build/asm/main_802C4960.s.o(.data); }
    .main_802C4960_bss (NOLOAD) : { build/asm/main_802C4960.s.o(.bss); }
    .main_802C4978 0x802C4978 : AT(0x000C5578) { build/asm/data/main_802C4978.bin.o(.data); }
    .main_802C5150 0x802C5150 : AT(0x000C5D50) { FILL(0x00000000); build/asm/main_802C5150.s.o(.text); build/asm/main_802C5150.s.o(.rodata); build/asm/main_802C5150.s.o(.data); }
    .main_802C5150_bss (NOLOAD) : { build/asm/main_802C5150.s.o(.bss); }
    .main_802C5198 0x802C5198 : AT(0x000C5D98) { build/asm/data/main_802C5198.bin.o(.data); }
    .main_802C621C 0x802C621C : AT(0x000C6E1C) { FILL(0x00000000); build/asm/main_802C621C.s.o(.text); build/asm/main_802C621C.s.o(.rodata); build/asm/main_802C621C.s.o(.data); }
    .main_802C621C_bss (NOLOAD) : { build/asm/main_802C621C.s.o(.bss); }
    .main_802C6220 0x802C6220 : AT(0x000C6E20) { build/asm/data/main_802C6220.bin.o(.data); }
    .main_802C7B84 0x802C7B84 : AT(0x000C8784) { FILL(0x00000000); build/asm/main_802C7B84.s.o(.text); build/asm/main_802C7B84.s.o(.rodata); build/asm/main_802C7B84.s.o(.data); }
    .main_802C7B84_bss (NOLOAD) : { build/asm/main_802C7B84.s.o(.bss); }
    .main_802C7BE4 0x802C7BE4 : AT(0x000C87E4) { build/asm/data/main_802C7BE4.bin.o(.data); }
    .main_802C7EEC 0x802C7EEC : AT(0x000C8AEC) { FILL(0x00000000); build/asm/main_802C7EEC.s.o(.text); build/asm/main_802C7EEC.s.o(.rodata); build/asm/main_802C7EEC.s.o(.data); }
    .main_802C7EEC_bss (NOLOAD) : { build/asm/main_802C7EEC.s.o(.bss); }
    .main_802C7EFC 0x802C7EFC : AT(0x000C8AFC) { build/asm/data/main_802C7EFC.bin.o(.data); }
    .main_802C8500 0x802C8500 : AT(0x000C9100) { FILL(0x00000000); build/asm/main_802C8500.s.o(.text); build/asm/main_802C8500.s.o(.rodata); build/asm/main_802C8500.s.o(.data); }
    .main_802C8500_bss (NOLOAD) : { build/asm/main_802C8500.s.o(.bss); }
    .main_802C8530 0x802C8530 : AT(0x000C9130) { build/asm/data/main_802C8530.bin.o(.data); }
    .main_802C8AA8 0x802C8AA8 : AT(0x000C96A8) { FILL(0x00000000); build/asm/main_802C8AA8.s.o(.text); build/asm/main_802C8AA8.s.o(.rodata); build/asm/main_802C8AA8.s.o(.data); }
    .main_802C8AA8_bss (NOLOAD) : { build/asm/main_802C8AA8.s.o(.bss); }
    .main_802C8AD4 0x802C8AD4 : AT(0x000C96D4) { build/asm/data/main_802C8AD4.bin.o(.data); }
    .main_802C98E4 0x802C98E4 : AT(0x000CA4E4) { FILL(0x00000000); build/asm/main_802C98E4.s.o(.text); build/asm/main_802C98E4.s.o(.rodata); build/asm/main_802C98E4.s.o(.data); }
    .main_802C98E4_bss (NOLOAD) : { build/asm/main_802C98E4.s.o(.bss); }
    .main_802C992C 0x802C992C : AT(0x000CA52C) { build/asm/data/main_802C992C.bin.o(.data); }
    .main_802C99F4 0x802C99F4 : AT(0x000CA5F4) { FILL(0x00000000); build/asm/main_802C99F4.s.o(.text); build/asm/main_802C99F4.s.o(.rodata); build/asm/main_802C99F4.s.o(.data); }
    .main_802C99F4_bss (NOLOAD) : { build/asm/main_802C99F4.s.o(.bss); }
    .main_802C9A10 0x802C9A10 : AT(0x000CA610) { build/asm/data/main_802C9A10.bin.o(.data); }
    .main_802C9C90 0x802C9C90 : AT(0x000CA890) { FILL(0x00000000); build/asm/main_802C9C90.s.o(.text); build/asm/main_802C9C90.s.o(.rodata); build/asm/main_802C9C90.s.o(.data); }
    .main_802C9C90_bss (NOLOAD) : { build/asm/main_802C9C90.s.o(.bss); }
    .main_802C9CA0 0x802C9CA0 : AT(0x000CA8A0) { build/asm/data/main_802C9CA0.bin.o(.data); }
    .main_802CA1E8 0x802CA1E8 : AT(0x000CADE8) { FILL(0x00000000); build/asm/main_802CA1E8.s.o(.text); build/asm/main_802CA1E8.s.o(.rodata); build/asm/main_802CA1E8.s.o(.data); }
    .main_802CA1E8_bss (NOLOAD) : { build/asm/main_802CA1E8.s.o(.bss); }
    .main_802CA208 0x802CA208 : AT(0x000CAE08) { build/asm/data/main_802CA208.bin.o(.data); }
    .main_802CA838 0x802CA838 : AT(0x000CB438) { FILL(0x00000000); build/asm/main_802CA838.s.o(.text); build/asm/main_802CA838.s.o(.rodata); build/asm/main_802CA838.s.o(.data); }
    .main_802CA838_bss (NOLOAD) : { build/asm/main_802CA838.s.o(.bss); }
    .main_802CA908 0x802CA908 : AT(0x000CB508) { build/asm/data/main_802CA908.bin.o(.data); }
    .main_802CAECC 0x802CAECC : AT(0x000CBACC) { FILL(0x00000000); build/asm/main_802CAECC.s.o(.text); build/asm/main_802CAECC.s.o(.rodata); build/asm/main_802CAECC.s.o(.data); }
    .main_802CAECC_bss (NOLOAD) : { build/asm/main_802CAECC.s.o(.bss); }
    .main_802CAEE0 0x802CAEE0 : AT(0x000CBAE0) { build/asm/data/main_802CAEE0.bin.o(.data); }
    .main_802CB1A0 0x802CB1A0 : AT(0x000CBDA0) { FILL(0x00000000); build/asm/main_802CB1A0.s.o(.text); build/asm/main_802CB1A0.s.o(.rodata); build/asm/main_802CB1A0.s.o(.data); }
    .main_802CB1A0_bss (NOLOAD) : { build/asm/main_802CB1A0.s.o(.bss); }
    .main_802CB1B4 0x802CB1B4 : AT(0x000CBDB4) { build/asm/data/main_802CB1B4.bin.o(.data); }
    .main_802CBBA8 0x802CBBA8 : AT(0x000CC7A8) { FILL(0x00000000); build/asm/main_802CBBA8.s.o(.text); build/asm/main_802CBBA8.s.o(.rodata); build/asm/main_802CBBA8.s.o(.data); }
    .main_802CBBA8_bss (NOLOAD) : { build/asm/main_802CBBA8.s.o(.bss); }
    .main_802CBBAC 0x802CBBAC : AT(0x000CC7AC) { build/asm/data/main_802CBBAC.bin.o(.data); }
    .main_802CBC68 0x802CBC68 : AT(0x000CC868) { FILL(0x00000000); build/asm/main_802CBC68.s.o(.text); build/asm/main_802CBC68.s.o(.rodata); build/asm/main_802CBC68.s.o(.data); }
    .main_802CBC68_bss (NOLOAD) : { build/asm/main_802CBC68.s.o(.bss); }
    .main_802CBD9C 0x802CBD9C : AT(0x000CC99C) { build/asm/data/main_802CBD9C.bin.o(.data); }
    .main_802CBF78 0x802CBF78 : AT(0x000CCB78) { FILL(0x00000000); build/asm/main_802CBF78.s.o(.text); build/asm/main_802CBF78.s.o(.rodata); build/asm/main_802CBF78.s.o(.data); }
    .main_802CBF78_bss (NOLOAD) : { build/asm/main_802CBF78.s.o(.bss); }
    .main_802CC000 0x802CC000 : AT(0x000CCC00) { build/asm/data/main_802CC000.bin.o(.data); }
    .main_802CC43C 0x802CC43C : AT(0x000CD03C) { FILL(0x00000000); build/asm/main_802CC43C.s.o(.text); build/asm/main_802CC43C.s.o(.rodata); build/asm/main_802CC43C.s.o(.data); }
    .main_802CC43C_bss (NOLOAD) : { build/asm/main_802CC43C.s.o(.bss); }
    .main_802CC4A8 0x802CC4A8 : AT(0x000CD0A8) { build/asm/data/main_802CC4A8.bin.o(.data); }
    .main_802CC4EC 0x802CC4EC : AT(0x000CD0EC) { FILL(0x00000000); build/asm/main_802CC4EC.s.o(.text); build/asm/main_802CC4EC.s.o(.rodata); build/asm/main_802CC4EC.s.o(.data); }
    .main_802CC4EC_bss (NOLOAD) : { build/asm/main_802CC4EC.s.o(.bss); }
    .main_802CC50C 0x802CC50C : AT(0x000CD10C) { build/asm/data/main_802CC50C.bin.o(.data); }
    .main_802CC658 0x802CC658 : AT(0x000CD258) { FILL(0x00000000); build/asm/main_802CC658.s.o(.text); build/asm/main_802CC658.s.o(.rodata); build/asm/main_802CC658.s.o(.data); }
    .main_802CC658_bss (NOLOAD) : { build/asm/main_802CC658.s.o(.bss); }
    .main_802CC678 0x802CC678 : AT(0x000CD278) { build/asm/data/main_802CC678.bin.o(.data); }
    .main_802CE104 0x802CE104 : AT(0x000CED04) { FILL(0x00000000); build/asm/main_802CE104.s.o(.text); build/asm/main_802CE104.s.o(.rodata); build/asm/main_802CE104.s.o(.data); }
    .main_802CE104_bss (NOLOAD) : { build/asm/main_802CE104.s.o(.bss); }
    .main_802CE108 0x802CE108 : AT(0x000CED08) { build/asm/data/main_802CE108.bin.o(.data); }
    .main_802CE320 0x802CE320 : AT(0x000CEF20) { FILL(0x00000000); build/asm/main_802CE320.s.o(.text); build/asm/main_802CE320.s.o(.rodata); build/asm/main_802CE320.s.o(.data); }
    .main_802CE320_bss (NOLOAD) : { build/asm/main_802CE320.s.o(.bss); }
    .main_802CE3D0 0x802CE3D0 : AT(0x000CEFD0) { build/asm/data/main_802CE3D0.bin.o(.data); }
    .main_802CE5F4 0x802CE5F4 : AT(0x000CF1F4) { FILL(0x00000000); build/asm/main_802CE5F4.s.o(.text); build/asm/main_802CE5F4.s.o(.rodata); build/asm/main_802CE5F4.s.o(.data); }
    .main_802CE5F4_bss (NOLOAD) : { build/asm/main_802CE5F4.s.o(.bss); }
    .main_802CE610 0x802CE610 : AT(0x000CF210) { build/asm/data/main_802CE610.bin.o(.data); }
    .main_802CE8F4 0x802CE8F4 : AT(0x000CF4F4) { FILL(0x00000000); build/asm/main_802CE8F4.s.o(.text); build/asm/main_802CE8F4.s.o(.rodata); build/asm/main_802CE8F4.s.o(.data); }
    .main_802CE8F4_bss (NOLOAD) : { build/asm/main_802CE8F4.s.o(.bss); }
    .main_802CE91C 0x802CE91C : AT(0x000CF51C) { build/asm/data/main_802CE91C.bin.o(.data); }
    .main_802CEA80 0x802CEA80 : AT(0x000CF680) { FILL(0x00000000); build/asm/main_802CEA80.s.o(.text); build/asm/main_802CEA80.s.o(.rodata); build/asm/main_802CEA80.s.o(.data); }
    .main_802CEA80_bss (NOLOAD) : { build/asm/main_802CEA80.s.o(.bss); }
    .main_802CEA88 0x802CEA88 : AT(0x000CF688) { build/asm/data/main_802CEA88.bin.o(.data); }
    .main_802CF7AC 0x802CF7AC : AT(0x000D03AC) { FILL(0x00000000); build/asm/main_802CF7AC.s.o(.text); build/asm/main_802CF7AC.s.o(.rodata); build/asm/main_802CF7AC.s.o(.data); }
    .main_802CF7AC_bss (NOLOAD) : { build/asm/main_802CF7AC.s.o(.bss); }
    .main_802CF820 0x802CF820 : AT(0x000D0420) { build/asm/data/main_802CF820.bin.o(.data); }
    .main_802D02E8 0x802D02E8 : AT(0x000D0EE8) { FILL(0x00000000); build/asm/main_802D02E8.s.o(.text); build/asm/main_802D02E8.s.o(.rodata); build/asm/main_802D02E8.s.o(.data); }
    .main_802D02E8_bss (NOLOAD) : { build/asm/main_802D02E8.s.o(.bss); }
    .main_802D0390 0x802D0390 : AT(0x000D0F90) { build/asm/data/main_802D0390.bin.o(.data); }
    .main_802D0534 0x802D0534 : AT(0x000D1134) { FILL(0x00000000); build/asm/main_802D0534.s.o(.text); build/asm/main_802D0534.s.o(.rodata); build/asm/main_802D0534.s.o(.data); }
    .main_802D0534_bss (NOLOAD) : { build/asm/main_802D0534.s.o(.bss); }
    .main_802D0540 0x802D0540 : AT(0x000D1140) { build/asm/data/main_802D0540.bin.o(.data); }
    .main_802D1C20 0x802D1C20 : AT(0x000D2820) { FILL(0x00000000); build/asm/main_802D1C20.s.o(.text); build/asm/main_802D1C20.s.o(.rodata); build/asm/main_802D1C20.s.o(.data); }
    .main_802D1C20_bss (NOLOAD) : { build/asm/main_802D1C20.s.o(.bss); }
    .main_802D1C30 0x802D1C30 : AT(0x000D2830) { build/asm/data/main_802D1C30.bin.o(.data); }
    .main_802D1E0C 0x802D1E0C : AT(0x000D2A0C) { FILL(0x00000000); build/asm/main_802D1E0C.s.o(.text); build/asm/main_802D1E0C.s.o(.rodata); build/asm/main_802D1E0C.s.o(.data); }
    .main_802D1E0C_bss (NOLOAD) : { build/asm/main_802D1E0C.s.o(.bss); }
    .main_802D1E54 0x802D1E54 : AT(0x000D2A54) { build/asm/data/main_802D1E54.bin.o(.data); }
    .main_802D3094 0x802D3094 : AT(0x000D3C94) { FILL(0x00000000); build/asm/main_802D3094.s.o(.text); build/asm/main_802D3094.s.o(.rodata); build/asm/main_802D3094.s.o(.data); }
    .main_802D3094_bss (NOLOAD) : { build/asm/main_802D3094.s.o(.bss); }
    .main_802D3098 0x802D3098 : AT(0x000D3C98) { build/asm/data/main_802D3098.bin.o(.data); }
    .main_802D376C 0x802D376C : AT(0x000D436C) { FILL(0x00000000); build/asm/main_802D376C.s.o(.text); build/asm/main_802D376C.s.o(.rodata); build/asm/main_802D376C.s.o(.data); }
    .main_802D376C_bss (NOLOAD) : { build/asm/main_802D376C.s.o(.bss); }
    .main_802D3774 0x802D3774 : AT(0x000D4374) { build/asm/data/main_802D3774.bin.o(.data); }
    .main_802D3954 0x802D3954 : AT(0x000D4554) { FILL(0x00000000); build/asm/main_802D3954.s.o(.text); build/asm/main_802D3954.s.o(.rodata); build/asm/main_802D3954.s.o(.data); }
    .main_802D3954_bss (NOLOAD) : { build/asm/main_802D3954.s.o(.bss); }
    .main_802D3978 0x802D3978 : AT(0x000D4578) { build/asm/data/main_802D3978.bin.o(.data); }
    .main_802D3A30 0x802D3A30 : AT(0x000D4630) { FILL(0x00000000); build/asm/main_802D3A30.s.o(.text); build/asm/main_802D3A30.s.o(.rodata); build/asm/main_802D3A30.s.o(.data); }
    .main_802D3A30_bss (NOLOAD) : { build/asm/main_802D3A30.s.o(.bss); }
    .main_802D3A60 0x802D3A60 : AT(0x000D4660) { build/asm/data/main_802D3A60.bin.o(.data); }
    .main_802D3B44 0x802D3B44 : AT(0x000D4744) { FILL(0x00000000); build/asm/main_802D3B44.s.o(.text); build/asm/main_802D3B44.s.o(.rodata); build/asm/main_802D3B44.s.o(.data); }
    .main_802D3B44_bss (NOLOAD) : { build/asm/main_802D3B44.s.o(.bss); }
    .main_802D3B6C 0x802D3B6C : AT(0x000D476C) { build/asm/data/main_802D3B6C.bin.o(.data); }
    .main_802D44E8 0x802D44E8 : AT(0x000D50E8) { FILL(0x00000000); build/asm/main_802D44E8.s.o(.text); build/asm/main_802D44E8.s.o(.rodata); build/asm/main_802D44E8.s.o(.data); }
    .main_802D44E8_bss (NOLOAD) : { build/asm/main_802D44E8.s.o(.bss); }
    .main_802D451C 0x802D451C : AT(0x000D511C) { build/asm/data/main_802D451C.bin.o(.data); }
    .main_802D54D0 0x802D54D0 : AT(0x000D60D0) { FILL(0x00000000); build/asm/main_802D54D0.s.o(.text); build/asm/main_802D54D0.s.o(.rodata); build/asm/main_802D54D0.s.o(.data); }
    .main_802D54D0_bss (NOLOAD) : { build/asm/main_802D54D0.s.o(.bss); }
    .main_802D5538 0x802D5538 : AT(0x000D6138) { build/asm/data/main_802D5538.bin.o(.data); }
    .main_802D5998 0x802D5998 : AT(0x000D6598) { FILL(0x00000000); build/asm/main_802D5998.s.o(.text); build/asm/main_802D5998.s.o(.rodata); build/asm/main_802D5998.s.o(.data); }
    .main_802D5998_bss (NOLOAD) : { build/asm/main_802D5998.s.o(.bss); }
    .main_802D59BC 0x802D59BC : AT(0x000D65BC) { build/asm/data/main_802D59BC.bin.o(.data); }
    .main_802D5D3C 0x802D5D3C : AT(0x000D693C) { FILL(0x00000000); build/asm/main_802D5D3C.s.o(.text); build/asm/main_802D5D3C.s.o(.rodata); build/asm/main_802D5D3C.s.o(.data); }
    .main_802D5D3C_bss (NOLOAD) : { build/asm/main_802D5D3C.s.o(.bss); }
    .main_802D5DA0 0x802D5DA0 : AT(0x000D69A0) { build/asm/data/main_802D5DA0.bin.o(.data); }
    .main_802D6348 0x802D6348 : AT(0x000D6F48) { FILL(0x00000000); build/asm/main_802D6348.s.o(.text); build/asm/main_802D6348.s.o(.rodata); build/asm/main_802D6348.s.o(.data); }
    .main_802D6348_bss (NOLOAD) : { build/asm/main_802D6348.s.o(.bss); }
    .main_802D6398 0x802D6398 : AT(0x000D6F98) { build/asm/data/main_802D6398.bin.o(.data); }
    .main_802D6E44 0x802D6E44 : AT(0x000D7A44) { FILL(0x00000000); build/asm/main_802D6E44.s.o(.text); build/asm/main_802D6E44.s.o(.rodata); build/asm/main_802D6E44.s.o(.data); }
    .main_802D6E44_bss (NOLOAD) : { build/asm/main_802D6E44.s.o(.bss); }
    .main_802D6E68 0x802D6E68 : AT(0x000D7A68) { build/asm/data/main_802D6E68.bin.o(.data); }
    .main_802D7568 0x802D7568 : AT(0x000D8168) { FILL(0x00000000); build/asm/main_802D7568.s.o(.text); build/asm/main_802D7568.s.o(.rodata); build/asm/main_802D7568.s.o(.data); }
    .main_802D7568_bss (NOLOAD) : { build/asm/main_802D7568.s.o(.bss); }
    .main_802D756C 0x802D756C : AT(0x000D816C) { build/asm/data/main_802D756C.bin.o(.data); }
    .main_802D765C 0x802D765C : AT(0x000D825C) { FILL(0x00000000); build/asm/main_802D765C.s.o(.text); build/asm/main_802D765C.s.o(.rodata); build/asm/main_802D765C.s.o(.data); }
    .main_802D765C_bss (NOLOAD) : { build/asm/main_802D765C.s.o(.bss); }
    .main_802D766C 0x802D766C : AT(0x000D826C) { build/asm/data/main_802D766C.bin.o(.data); }
    .main_802D77C4 0x802D77C4 : AT(0x000D83C4) { FILL(0x00000000); build/asm/main_802D77C4.s.o(.text); build/asm/main_802D77C4.s.o(.rodata); build/asm/main_802D77C4.s.o(.data); }
    .main_802D77C4_bss (NOLOAD) : { build/asm/main_802D77C4.s.o(.bss); }
    .main_802D77F0 0x802D77F0 : AT(0x000D83F0) { build/asm/data/main_802D77F0.bin.o(.data); }
    .main_802D7D84 0x802D7D84 : AT(0x000D8984) { FILL(0x00000000); build/asm/main_802D7D84.s.o(.text); build/asm/main_802D7D84.s.o(.rodata); build/asm/main_802D7D84.s.o(.data); }
    .main_802D7D84_bss (NOLOAD) : { build/asm/main_802D7D84.s.o(.bss); }
    .main_802D7D88 0x802D7D88 : AT(0x000D8988) { build/asm/data/main_802D7D88.bin.o(.data); }
    .main_802D8A70 0x802D8A70 : AT(0x000D9670) { FILL(0x00000000); build/asm/main_802D8A70.s.o(.text); build/asm/main_802D8A70.s.o(.rodata); build/asm/main_802D8A70.s.o(.data); }
    .main_802D8A70_bss (NOLOAD) : { build/asm/main_802D8A70.s.o(.bss); }
    .main_802D8B14 0x802D8B14 : AT(0x000D9714) { build/asm/data/main_802D8B14.bin.o(.data); }
    .main_802D946C 0x802D946C : AT(0x000DA06C) { FILL(0x00000000); build/asm/main_802D946C.s.o(.text); build/asm/main_802D946C.s.o(.rodata); build/asm/main_802D946C.s.o(.data); }
    .main_802D946C_bss (NOLOAD) : { build/asm/main_802D946C.s.o(.bss); }
    .main_802D9474 0x802D9474 : AT(0x000DA074) { build/asm/data/main_802D9474.bin.o(.data); }
    .main_802D959C 0x802D959C : AT(0x000DA19C) { FILL(0x00000000); build/asm/main_802D959C.s.o(.text); build/asm/main_802D959C.s.o(.rodata); build/asm/main_802D959C.s.o(.data); }
    .main_802D959C_bss (NOLOAD) : { build/asm/main_802D959C.s.o(.bss); }
    .main_802D95C4 0x802D95C4 : AT(0x000DA1C4) { build/asm/data/main_802D95C4.bin.o(.data); }
    .main_802D96C4 0x802D96C4 : AT(0x000DA2C4) { FILL(0x00000000); build/asm/main_802D96C4.s.o(.text); build/asm/main_802D96C4.s.o(.rodata); build/asm/main_802D96C4.s.o(.data); }
    .main_802D96C4_bss (NOLOAD) : { build/asm/main_802D96C4.s.o(.bss); }
    .main_802D976C 0x802D976C : AT(0x000DA36C) { build/asm/data/main_802D976C.bin.o(.data); }
    .main_802DA094 0x802DA094 : AT(0x000DAC94) { FILL(0x00000000); build/asm/main_802DA094.s.o(.text); build/asm/main_802DA094.s.o(.rodata); build/asm/main_802DA094.s.o(.data); }
    .main_802DA094_bss (NOLOAD) : { build/asm/main_802DA094.s.o(.bss); }
    .main_802DA0F4 0x802DA0F4 : AT(0x000DACF4) { build/asm/data/main_802DA0F4.bin.o(.data); }
    .main_802DA218 0x802DA218 : AT(0x000DAE18) { FILL(0x00000000); build/asm/main_802DA218.s.o(.text); build/asm/main_802DA218.s.o(.rodata); build/asm/main_802DA218.s.o(.data); }
    .main_802DA218_bss (NOLOAD) : { build/asm/main_802DA218.s.o(.bss); }
    .main_802DA280 0x802DA280 : AT(0x000DAE80) { build/asm/data/main_802DA280.bin.o(.data); }
    .main_802DA720 0x802DA720 : AT(0x000DB320) { FILL(0x00000000); build/asm/main_802DA720.s.o(.text); build/asm/main_802DA720.s.o(.rodata); build/asm/main_802DA720.s.o(.data); }
    .main_802DA720_bss (NOLOAD) : { build/asm/main_802DA720.s.o(.bss); }
    .main_802DA738 0x802DA738 : AT(0x000DB338) { build/asm/data/main_802DA738.bin.o(.data); }
    .main_802DAA94 0x802DAA94 : AT(0x000DB694) { FILL(0x00000000); build/asm/main_802DAA94.s.o(.text); build/asm/main_802DAA94.s.o(.rodata); build/asm/main_802DAA94.s.o(.data); }
    .main_802DAA94_bss (NOLOAD) : { build/asm/main_802DAA94.s.o(.bss); }
    .main_802DAABC 0x802DAABC : AT(0x000DB6BC) { build/asm/data/main_802DAABC.bin.o(.data); }
    .main_802DB1B0 0x802DB1B0 : AT(0x000DBDB0) { FILL(0x00000000); build/asm/main_802DB1B0.s.o(.text); build/asm/main_802DB1B0.s.o(.rodata); build/asm/main_802DB1B0.s.o(.data); }
    .main_802DB1B0_bss (NOLOAD) : { build/asm/main_802DB1B0.s.o(.bss); }
    .main_802DB210 0x802DB210 : AT(0x000DBE10) { build/asm/data/main_802DB210.bin.o(.data); }
    .main_802DB328 0x802DB328 : AT(0x000DBF28) { FILL(0x00000000); build/asm/main_802DB328.s.o(.text); build/asm/main_802DB328.s.o(.rodata); build/asm/main_802DB328.s.o(.data); }
    .main_802DB328_bss (NOLOAD) : { build/asm/main_802DB328.s.o(.bss); }
    .main_802DB34C 0x802DB34C : AT(0x000DBF4C) { build/asm/data/main_802DB34C.bin.o(.data); }
    .main_802DB41C 0x802DB41C : AT(0x000DC01C) { FILL(0x00000000); build/asm/main_802DB41C.s.o(.text); build/asm/main_802DB41C.s.o(.rodata); build/asm/main_802DB41C.s.o(.data); }
    .main_802DB41C_bss (NOLOAD) : { build/asm/main_802DB41C.s.o(.bss); }
    .main_802DB464 0x802DB464 : AT(0x000DC064) { build/asm/data/main_802DB464.bin.o(.data); }
    .main_802DB738 0x802DB738 : AT(0x000DC338) { FILL(0x00000000); build/asm/main_802DB738.s.o(.text); build/asm/main_802DB738.s.o(.rodata); build/asm/main_802DB738.s.o(.data); }
    .main_802DB738_bss (NOLOAD) : { build/asm/main_802DB738.s.o(.bss); }
    .main_802DB73C 0x802DB73C : AT(0x000DC33C) { build/asm/data/main_802DB73C.bin.o(.data); }
    .main_802DB840 0x802DB840 : AT(0x000DC440) { FILL(0x00000000); build/asm/main_802DB840.s.o(.text); build/asm/main_802DB840.s.o(.rodata); build/asm/main_802DB840.s.o(.data); }
    .main_802DB840_bss (NOLOAD) : { build/asm/main_802DB840.s.o(.bss); }
    .main_802DB868 0x802DB868 : AT(0x000DC468) { build/asm/data/main_802DB868.bin.o(.data); }
    .main_802DBAC8 0x802DBAC8 : AT(0x000DC6C8) { FILL(0x00000000); build/asm/main_802DBAC8.s.o(.text); build/asm/main_802DBAC8.s.o(.rodata); build/asm/main_802DBAC8.s.o(.data); }
    .main_802DBAC8_bss (NOLOAD) : { build/asm/main_802DBAC8.s.o(.bss); }
    .main_802DBC58 0x802DBC58 : AT(0x000DC858) { build/asm/data/main_802DBC58.bin.o(.data); }
    .main_802DC2FC 0x802DC2FC : AT(0x000DCEFC) { FILL(0x00000000); build/asm/main_802DC2FC.s.o(.text); build/asm/main_802DC2FC.s.o(.rodata); build/asm/main_802DC2FC.s.o(.data); }
    .main_802DC2FC_bss (NOLOAD) : { build/asm/main_802DC2FC.s.o(.bss); }
    .main_802DC304 0x802DC304 : AT(0x000DCF04) { build/asm/data/main_802DC304.bin.o(.data); }
    .main_802DCF94 0x802DCF94 : AT(0x000DDB94) { FILL(0x00000000); build/asm/main_802DCF94.s.o(.text); build/asm/main_802DCF94.s.o(.rodata); build/asm/main_802DCF94.s.o(.data); }
    .main_802DCF94_bss (NOLOAD) : { build/asm/main_802DCF94.s.o(.bss); }
    .main_802DCFF4 0x802DCFF4 : AT(0x000DDBF4) { build/asm/data/main_802DCFF4.bin.o(.data); }
    .main_802DD04C 0x802DD04C : AT(0x000DDC4C) { FILL(0x00000000); build/asm/main_802DD04C.s.o(.text); build/asm/main_802DD04C.s.o(.rodata); build/asm/main_802DD04C.s.o(.data); }
    .main_802DD04C_bss (NOLOAD) : { build/asm/main_802DD04C.s.o(.bss); }
    .main_802DD060 0x802DD060 : AT(0x000DDC60) { build/asm/data/main_802DD060.bin.o(.data); }
    .main_802DF124 0x802DF124 : AT(0x000DFD24) { FILL(0x00000000); build/asm/main_802DF124.s.o(.text); build/asm/main_802DF124.s.o(.rodata); build/asm/main_802DF124.s.o(.data); }
    .main_802DF124_bss (NOLOAD) : { build/asm/main_802DF124.s.o(.bss); }
    .main_802DF17C 0x802DF17C : AT(0x000DFD7C) { build/asm/data/main_802DF17C.bin.o(.data); }
    .main_802E0268 0x802E0268 : AT(0x000E0E68) { FILL(0x00000000); build/asm/main_802E0268.s.o(.text); build/asm/main_802E0268.s.o(.rodata); build/asm/main_802E0268.s.o(.data); }
    .main_802E0268_bss (NOLOAD) : { build/asm/main_802E0268.s.o(.bss); }
    .main_802E028C 0x802E028C : AT(0x000E0E8C) { build/asm/data/main_802E028C.bin.o(.data); }
    .main_802E06F0 0x802E06F0 : AT(0x000E12F0) { FILL(0x00000000); build/asm/main_802E06F0.s.o(.text); build/asm/main_802E06F0.s.o(.rodata); build/asm/main_802E06F0.s.o(.data); }
    .main_802E06F0_bss (NOLOAD) : { build/asm/main_802E06F0.s.o(.bss); }
    .main_802E0700 0x802E0700 : AT(0x000E1300) { build/asm/data/main_802E0700.bin.o(.data); }
    .main_802E0F78 0x802E0F78 : AT(0x000E1B78) { FILL(0x00000000); build/asm/main_802E0F78.s.o(.text); build/asm/main_802E0F78.s.o(.rodata); build/asm/main_802E0F78.s.o(.data); }
    .main_802E0F78_bss (NOLOAD) : { build/asm/main_802E0F78.s.o(.bss); }
    .main_802E0F98 0x802E0F98 : AT(0x000E1B98) { build/asm/data/main_802E0F98.bin.o(.data); }
    .main_802E1DF8 0x802E1DF8 : AT(0x000E29F8) { FILL(0x00000000); build/asm/main_802E1DF8.s.o(.text); build/asm/main_802E1DF8.s.o(.rodata); build/asm/main_802E1DF8.s.o(.data); }
    .main_802E1DF8_bss (NOLOAD) : { build/asm/main_802E1DF8.s.o(.bss); }
    .main_802E1DFC 0x802E1DFC : AT(0x000E29FC) { build/asm/data/main_802E1DFC.bin.o(.data); }
    .main_802E2344 0x802E2344 : AT(0x000E2F44) { FILL(0x00000000); build/asm/main_802E2344.s.o(.text); build/asm/main_802E2344.s.o(.rodata); build/asm/main_802E2344.s.o(.data); }
    .main_802E2344_bss (NOLOAD) : { build/asm/main_802E2344.s.o(.bss); }
    .main_802E2378 0x802E2378 : AT(0x000E2F78) { build/asm/data/main_802E2378.bin.o(.data); }
    .main_802E23F0 0x802E23F0 : AT(0x000E2FF0) { FILL(0x00000000); build/asm/main_802E23F0.s.o(.text); build/asm/main_802E23F0.s.o(.rodata); build/asm/main_802E23F0.s.o(.data); }
    .main_802E23F0_bss (NOLOAD) : { build/asm/main_802E23F0.s.o(.bss); }
    .main_802E245C 0x802E245C : AT(0x000E305C) { build/asm/data/main_802E245C.bin.o(.data); }
    .main_802E2844 0x802E2844 : AT(0x000E3444) { FILL(0x00000000); build/asm/main_802E2844.s.o(.text); build/asm/main_802E2844.s.o(.rodata); build/asm/main_802E2844.s.o(.data); }
    .main_802E2844_bss (NOLOAD) : { build/asm/main_802E2844.s.o(.bss); }
    .main_802E2854 0x802E2854 : AT(0x000E3454) { build/asm/data/main_802E2854.bin.o(.data); }
    .main_802E32FC 0x802E32FC : AT(0x000E3EFC) { FILL(0x00000000); build/asm/main_802E32FC.s.o(.text); build/asm/main_802E32FC.s.o(.rodata); build/asm/main_802E32FC.s.o(.data); }
    .main_802E32FC_bss (NOLOAD) : { build/asm/main_802E32FC.s.o(.bss); }
    .main_802E3354 0x802E3354 : AT(0x000E3F54) { build/asm/data/main_802E3354.bin.o(.data); }
    .main_802E41A0 0x802E41A0 : AT(0x000E4DA0) { FILL(0x00000000); build/asm/main_802E41A0.s.o(.text); build/asm/main_802E41A0.s.o(.rodata); build/asm/main_802E41A0.s.o(.data); }
    .main_802E41A0_bss (NOLOAD) : { build/asm/main_802E41A0.s.o(.bss); }
    .main_802E41A4 0x802E41A4 : AT(0x000E4DA4) { build/asm/data/main_802E41A4.bin.o(.data); }
    .main_802E4240 0x802E4240 : AT(0x000E4E40) { FILL(0x00000000); build/asm/main_802E4240.s.o(.text); build/asm/main_802E4240.s.o(.rodata); build/asm/main_802E4240.s.o(.data); }
    .main_802E4240_bss (NOLOAD) : { build/asm/main_802E4240.s.o(.bss); }
    .main_802E4298 0x802E4298 : AT(0x000E4E98) { build/asm/data/main_802E4298.bin.o(.data); }
    .main_802E4488 0x802E4488 : AT(0x000E5088) { FILL(0x00000000); build/asm/main_802E4488.s.o(.text); build/asm/main_802E4488.s.o(.rodata); build/asm/main_802E4488.s.o(.data); }
    .main_802E4488_bss (NOLOAD) : { build/asm/main_802E4488.s.o(.bss); }
    .main_802E448C 0x802E448C : AT(0x000E508C) { build/asm/data/main_802E448C.bin.o(.data); }
    .main_802E4804 0x802E4804 : AT(0x000E5404) { FILL(0x00000000); build/asm/main_802E4804.s.o(.text); build/asm/main_802E4804.s.o(.rodata); build/asm/main_802E4804.s.o(.data); }
    .main_802E4804_bss (NOLOAD) : { build/asm/main_802E4804.s.o(.bss); }
    .main_802E4900 0x802E4900 : AT(0x000E5500) { build/asm/data/main_802E4900.bin.o(.data); }
    .main_802E4B04 0x802E4B04 : AT(0x000E5704) { FILL(0x00000000); build/asm/main_802E4B04.s.o(.text); build/asm/main_802E4B04.s.o(.rodata); build/asm/main_802E4B04.s.o(.data); }
    .main_802E4B04_bss (NOLOAD) : { build/asm/main_802E4B04.s.o(.bss); }
    .main_802E4B20 0x802E4B20 : AT(0x000E5720) { build/asm/data/main_802E4B20.bin.o(.data); }
    .main_802EAF58 0x802EAF58 : AT(0x000EBB58) { FILL(0x00000000); build/asm/main_802EAF58.s.o(.text); build/asm/main_802EAF58.s.o(.rodata); build/asm/main_802EAF58.s.o(.data); }
    .main_802EAF58_bss (NOLOAD) : { build/asm/main_802EAF58.s.o(.bss); }
    .main_802EAF6C 0x802EAF6C : AT(0x000EBB6C) { build/asm/data/main_802EAF6C.bin.o(.data); }
    .main_802EB7FC 0x802EB7FC : AT(0x000EC3FC) { FILL(0x00000000); build/asm/main_802EB7FC.s.o(.text); build/asm/main_802EB7FC.s.o(.rodata); build/asm/main_802EB7FC.s.o(.data); }
    .main_802EB7FC_bss (NOLOAD) : { build/asm/main_802EB7FC.s.o(.bss); }
    .main_802EB910 0x802EB910 : AT(0x000EC510) { build/asm/data/main_802EB910.bin.o(.data); }
    .main_802EE7E8 0x802EE7E8 : AT(0x000EF3E8) { FILL(0x00000000); build/asm/main_802EE7E8.s.o(.text); build/asm/main_802EE7E8.s.o(.rodata); build/asm/main_802EE7E8.s.o(.data); }
    .main_802EE7E8_bss (NOLOAD) : { build/asm/main_802EE7E8.s.o(.bss); }
    .main_802EE80C 0x802EE80C : AT(0x000EF40C) { build/asm/data/main_802EE80C.bin.o(.data); }
    .main_802EEB2C 0x802EEB2C : AT(0x000EF72C) { FILL(0x00000000); build/asm/main_802EEB2C.s.o(.text); build/asm/main_802EEB2C.s.o(.rodata); build/asm/main_802EEB2C.s.o(.data); }
    .main_802EEB2C_bss (NOLOAD) : { build/asm/main_802EEB2C.s.o(.bss); }
    .main_802EEB30 0x802EEB30 : AT(0x000EF730) { build/asm/data/main_802EEB30.bin.o(.data); }
    .main_802EF544 0x802EF544 : AT(0x000F0144) { FILL(0x00000000); build/asm/main_802EF544.s.o(.text); build/asm/main_802EF544.s.o(.rodata); build/asm/main_802EF544.s.o(.data); }
    .main_802EF544_bss (NOLOAD) : { build/asm/main_802EF544.s.o(.bss); }
    .main_802EF564 0x802EF564 : AT(0x000F0164) { build/asm/data/main_802EF564.bin.o(.data); }
    .main_802F0248 0x802F0248 : AT(0x000F0E48) { FILL(0x00000000); build/asm/main_802F0248.s.o(.text); build/asm/main_802F0248.s.o(.rodata); build/asm/main_802F0248.s.o(.data); }
    .main_802F0248_bss (NOLOAD) : { build/asm/main_802F0248.s.o(.bss); }
    .main_802F0268 0x802F0268 : AT(0x000F0E68) { build/asm/data/main_802F0268.bin.o(.data); }
    .main_802F03D0 0x802F03D0 : AT(0x000F0FD0) { FILL(0x00000000); build/asm/main_802F03D0.s.o(.text); build/asm/main_802F03D0.s.o(.rodata); build/asm/main_802F03D0.s.o(.data); }
    .main_802F03D0_bss (NOLOAD) : { build/asm/main_802F03D0.s.o(.bss); }
    .main_802F0454 0x802F0454 : AT(0x000F1054) { build/asm/data/main_802F0454.bin.o(.data); }
    .main_802F10EC 0x802F10EC : AT(0x000F1CEC) { FILL(0x00000000); build/asm/main_802F10EC.s.o(.text); build/asm/main_802F10EC.s.o(.rodata); build/asm/main_802F10EC.s.o(.data); }
    .main_802F10EC_bss (NOLOAD) : { build/asm/main_802F10EC.s.o(.bss); }
    .main_802F1138 0x802F1138 : AT(0x000F1D38) { build/asm/data/main_802F1138.bin.o(.data); }
    .main_802F1CDC 0x802F1CDC : AT(0x000F28DC) { FILL(0x00000000); build/asm/main_802F1CDC.s.o(.text); build/asm/main_802F1CDC.s.o(.rodata); build/asm/main_802F1CDC.s.o(.data); }
    .main_802F1CDC_bss (NOLOAD) : { build/asm/main_802F1CDC.s.o(.bss); }
    .main_802F1CE0 0x802F1CE0 : AT(0x000F28E0) { build/asm/data/main_802F1CE0.bin.o(.data); }
    .main_802F377C 0x802F377C : AT(0x000F437C) { FILL(0x00000000); build/asm/main_802F377C.s.o(.text); build/asm/main_802F377C.s.o(.rodata); build/asm/main_802F377C.s.o(.data); }
    .main_802F377C_bss (NOLOAD) : { build/asm/main_802F377C.s.o(.bss); }
    .main_802F37AC 0x802F37AC : AT(0x000F43AC) { build/asm/data/main_802F37AC.bin.o(.data); }
    .main_802F3ECC 0x802F3ECC : AT(0x000F4ACC) { FILL(0x00000000); build/asm/main_802F3ECC.s.o(.text); build/asm/main_802F3ECC.s.o(.rodata); build/asm/main_802F3ECC.s.o(.data); }
    .main_802F3ECC_bss (NOLOAD) : { build/asm/main_802F3ECC.s.o(.bss); }
    .main_802F3FD4 0x802F3FD4 : AT(0x000F4BD4) { build/asm/data/main_802F3FD4.bin.o(.data); }
    .main_802F50A0 0x802F50A0 : AT(0x000F5CA0) { FILL(0x00000000); build/asm/main_802F50A0.s.o(.text); build/asm/main_802F50A0.s.o(.rodata); build/asm/main_802F50A0.s.o(.data); }
    .main_802F50A0_bss (NOLOAD) : { build/asm/main_802F50A0.s.o(.bss); }
    .main_802F50CC 0x802F50CC : AT(0x000F5CCC) { build/asm/data/main_802F50CC.bin.o(.data); }
    .main_802F5894 0x802F5894 : AT(0x000F6494) { FILL(0x00000000); build/asm/main_802F5894.s.o(.text); build/asm/main_802F5894.s.o(.rodata); build/asm/main_802F5894.s.o(.data); }
    .main_802F5894_bss (NOLOAD) : { build/asm/main_802F5894.s.o(.bss); }
    .main_802F58C4 0x802F58C4 : AT(0x000F64C4) { build/asm/data/main_802F58C4.bin.o(.data); }
    .main_802F59D4 0x802F59D4 : AT(0x000F65D4) { FILL(0x00000000); build/asm/main_802F59D4.s.o(.text); build/asm/main_802F59D4.s.o(.rodata); build/asm/main_802F59D4.s.o(.data); }
    .main_802F59D4_bss (NOLOAD) : { build/asm/main_802F59D4.s.o(.bss); }
    .main_802F59E8 0x802F59E8 : AT(0x000F65E8) { build/asm/data/main_802F59E8.bin.o(.data); }
    .main_802F6710 0x802F6710 : AT(0x000F7310) { FILL(0x00000000); build/asm/main_802F6710.s.o(.text); build/asm/main_802F6710.s.o(.rodata); build/asm/main_802F6710.s.o(.data); }
    .main_802F6710_bss (NOLOAD) : { build/asm/main_802F6710.s.o(.bss); }
    .main_802F671C 0x802F671C : AT(0x000F731C) { build/asm/data/main_802F671C.bin.o(.data); }
    .main_802F74E4 0x802F74E4 : AT(0x000F80E4) { FILL(0x00000000); build/asm/main_802F74E4.s.o(.text); build/asm/main_802F74E4.s.o(.rodata); build/asm/main_802F74E4.s.o(.data); }
    .main_802F74E4_bss (NOLOAD) : { build/asm/main_802F74E4.s.o(.bss); }
    .main_802F7574 0x802F7574 : AT(0x000F8174) { build/asm/data/main_802F7574.bin.o(.data); }
    .main_802F762C 0x802F762C : AT(0x000F822C) { FILL(0x00000000); build/asm/main_802F762C.s.o(.text); build/asm/main_802F762C.s.o(.rodata); build/asm/main_802F762C.s.o(.data); }
    .main_802F762C_bss (NOLOAD) : { build/asm/main_802F762C.s.o(.bss); }
    .main_802F7644 0x802F7644 : AT(0x000F8244) { build/asm/data/main_802F7644.bin.o(.data); }
    .main_802F775C 0x802F775C : AT(0x000F835C) { FILL(0x00000000); build/asm/main_802F775C.s.o(.text); build/asm/main_802F775C.s.o(.rodata); build/asm/main_802F775C.s.o(.data); }
    .main_802F775C_bss (NOLOAD) : { build/asm/main_802F775C.s.o(.bss); }
    .main_802F7778 0x802F7778 : AT(0x000F8378) { build/asm/data/main_802F7778.bin.o(.data); }
    .main_802F79A0 0x802F79A0 : AT(0x000F85A0) { FILL(0x00000000); build/asm/main_802F79A0.s.o(.text); build/asm/main_802F79A0.s.o(.rodata); build/asm/main_802F79A0.s.o(.data); }
    .main_802F79A0_bss (NOLOAD) : { build/asm/main_802F79A0.s.o(.bss); }
    .main_802F7A50 0x802F7A50 : AT(0x000F8650) { build/asm/data/main_802F7A50.bin.o(.data); }
    .main_802F85B4 0x802F85B4 : AT(0x000F91B4) { FILL(0x00000000); build/asm/main_802F85B4.s.o(.text); build/asm/main_802F85B4.s.o(.rodata); build/asm/main_802F85B4.s.o(.data); }
    .main_802F85B4_bss (NOLOAD) : { build/asm/main_802F85B4.s.o(.bss); }
    .main_802F8698 0x802F8698 : AT(0x000F9298) { build/asm/data/main_802F8698.bin.o(.data); }
    .main_802F8C34 0x802F8C34 : AT(0x000F9834) { FILL(0x00000000); build/asm/main_802F8C34.s.o(.text); build/asm/main_802F8C34.s.o(.rodata); build/asm/main_802F8C34.s.o(.data); }
    .main_802F8C34_bss (NOLOAD) : { build/asm/main_802F8C34.s.o(.bss); }
    .main_802F8C64 0x802F8C64 : AT(0x000F9864) { build/asm/data/main_802F8C64.bin.o(.data); }
    .main_802F8C98 0x802F8C98 : AT(0x000F9898) { FILL(0x00000000); build/asm/main_802F8C98.s.o(.text); build/asm/main_802F8C98.s.o(.rodata); build/asm/main_802F8C98.s.o(.data); }
    .main_802F8C98_bss (NOLOAD) : { build/asm/main_802F8C98.s.o(.bss); }
    .main_802F8CD0 0x802F8CD0 : AT(0x000F98D0) { build/asm/data/main_802F8CD0.bin.o(.data); }
    .main_802F8DA8 0x802F8DA8 : AT(0x000F99A8) { FILL(0x00000000); build/asm/main_802F8DA8.s.o(.text); build/asm/main_802F8DA8.s.o(.rodata); build/asm/main_802F8DA8.s.o(.data); }
    .main_802F8DA8_bss (NOLOAD) : { build/asm/main_802F8DA8.s.o(.bss); }
    .main_802F8DB0 0x802F8DB0 : AT(0x000F99B0) { build/asm/data/main_802F8DB0.bin.o(.data); }
    .main_802F9038 0x802F9038 : AT(0x000F9C38) { FILL(0x00000000); build/asm/main_802F9038.s.o(.text); build/asm/main_802F9038.s.o(.rodata); build/asm/main_802F9038.s.o(.data); }
    .main_802F9038_bss (NOLOAD) : { build/asm/main_802F9038.s.o(.bss); }
    .main_802F903C 0x802F903C : AT(0x000F9C3C) { build/asm/data/main_802F903C.bin.o(.data); }
    .main_802F9628 0x802F9628 : AT(0x000FA228) { FILL(0x00000000); build/asm/main_802F9628.s.o(.text); build/asm/main_802F9628.s.o(.rodata); build/asm/main_802F9628.s.o(.data); }
    .main_802F9628_bss (NOLOAD) : { build/asm/main_802F9628.s.o(.bss); }
    .main_802F97F8 0x802F97F8 : AT(0x000FA3F8) { build/asm/data/main_802F97F8.bin.o(.data); }
    .main_802FC600 0x802FC600 : AT(0x000FD200) { FILL(0x00000000); build/asm/main_802FC600.s.o(.text); build/asm/main_802FC600.s.o(.rodata); build/asm/main_802FC600.s.o(.data); }
    .main_802FC600_bss (NOLOAD) : { build/asm/main_802FC600.s.o(.bss); }
    .main_802FC684 0x802FC684 : AT(0x000FD284) { build/asm/data/main_802FC684.bin.o(.data); }
    .main_802FD5A0 0x802FD5A0 : AT(0x000FE1A0) { FILL(0x00000000); build/asm/main_802FD5A0.s.o(.text); build/asm/main_802FD5A0.s.o(.rodata); build/asm/main_802FD5A0.s.o(.data); }
    .main_802FD5A0_bss (NOLOAD) : { build/asm/main_802FD5A0.s.o(.bss); }
    .main_802FD5CC 0x802FD5CC : AT(0x000FE1CC) { build/asm/data/main_802FD5CC.bin.o(.data); }
    .main_802FFDCC 0x802FFDCC : AT(0x001009CC) { FILL(0x00000000); build/asm/main_802FFDCC.s.o(.text); build/asm/main_802FFDCC.s.o(.rodata); build/asm/main_802FFDCC.s.o(.data); }
    .main_802FFDCC_bss (NOLOAD) : { build/asm/main_802FFDCC.s.o(.bss); }
    .main_802FFE94 0x802FFE94 : AT(0x00100A94) { build/asm/data/main_802FFE94.bin.o(.data); }
    .main_80300210 0x80300210 : AT(0x00100E10) { FILL(0x00000000); build/asm/main_80300210.s.o(.text); build/asm/main_80300210.s.o(.rodata); build/asm/main_80300210.s.o(.data); }
    .main_80300210_bss (NOLOAD) : { build/asm/main_80300210.s.o(.bss); }
    .main_80300230 0x80300230 : AT(0x00100E30) { build/asm/data/main_80300230.bin.o(.data); }
    .main_803002D8 0x803002D8 : AT(0x00100ED8) { FILL(0x00000000); build/asm/main_803002D8.s.o(.text); build/asm/main_803002D8.s.o(.rodata); build/asm/main_803002D8.s.o(.data); }
    .main_803002D8_bss (NOLOAD) : { build/asm/main_803002D8.s.o(.bss); }
    .main_8030030C 0x8030030C : AT(0x00100F0C) { build/asm/data/main_8030030C.bin.o(.data); }
    .assets 0x80600400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
