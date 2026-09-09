SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80200400 0x80200400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80200400.s.o(.text); build/asm/main_80200400.s.o(.rodata); build/asm/main_80200400.s.o(.data); }
    .main_80200400_bss (NOLOAD) : { build/asm/main_80200400.s.o(.bss); }
    .main_80200574 0x80200574 : AT(0x00001174) { FILL(0x00000000); build/asm/main_80200574.s.o(.text); build/asm/main_80200574.s.o(.rodata); build/asm/main_80200574.s.o(.data); }
    .main_80200574_bss (NOLOAD) : { build/asm/main_80200574.s.o(.bss); }
    .main_802010A8 0x802010A8 : AT(0x00001CA8) { build/asm/data/main_802010A8.bin.o(.data); }
    .main_802038F8 0x802038F8 : AT(0x000044F8) { FILL(0x00000000); build/asm/main_802038F8.s.o(.text); build/asm/main_802038F8.s.o(.rodata); build/asm/main_802038F8.s.o(.data); }
    .main_802038F8_bss (NOLOAD) : { build/asm/main_802038F8.s.o(.bss); }
    .main_80203904 0x80203904 : AT(0x00004504) { build/asm/data/main_80203904.bin.o(.data); }
    .main_80208A24 0x80208A24 : AT(0x00009624) { FILL(0x00000000); build/asm/main_80208A24.s.o(.text); build/asm/main_80208A24.s.o(.rodata); build/asm/main_80208A24.s.o(.data); }
    .main_80208A24_bss (NOLOAD) : { build/asm/main_80208A24.s.o(.bss); }
    .main_80208A40 0x80208A40 : AT(0x00009640) { build/asm/data/main_80208A40.bin.o(.data); }
    .main_8020AE9C 0x8020AE9C : AT(0x0000BA9C) { FILL(0x00000000); build/asm/main_8020AE9C.s.o(.text); build/asm/main_8020AE9C.s.o(.rodata); build/asm/main_8020AE9C.s.o(.data); }
    .main_8020AE9C_bss (NOLOAD) : { build/asm/main_8020AE9C.s.o(.bss); }
    .main_8020AEAC 0x8020AEAC : AT(0x0000BAAC) { build/asm/data/main_8020AEAC.bin.o(.data); }
    .main_8020AFF4 0x8020AFF4 : AT(0x0000BBF4) { FILL(0x00000000); build/asm/main_8020AFF4.s.o(.text); build/asm/main_8020AFF4.s.o(.rodata); build/asm/main_8020AFF4.s.o(.data); }
    .main_8020AFF4_bss (NOLOAD) : { build/asm/main_8020AFF4.s.o(.bss); }
    .main_8020B000 0x8020B000 : AT(0x0000BC00) { build/asm/data/main_8020B000.bin.o(.data); }
    .main_8020B39C 0x8020B39C : AT(0x0000BF9C) { FILL(0x00000000); build/asm/main_8020B39C.s.o(.text); build/asm/main_8020B39C.s.o(.rodata); build/asm/main_8020B39C.s.o(.data); }
    .main_8020B39C_bss (NOLOAD) : { build/asm/main_8020B39C.s.o(.bss); }
    .main_8020B3A8 0x8020B3A8 : AT(0x0000BFA8) { build/asm/data/main_8020B3A8.bin.o(.data); }
    .main_8020E1E8 0x8020E1E8 : AT(0x0000EDE8) { FILL(0x00000000); build/asm/main_8020E1E8.s.o(.text); build/asm/main_8020E1E8.s.o(.rodata); build/asm/main_8020E1E8.s.o(.data); }
    .main_8020E1E8_bss (NOLOAD) : { build/asm/main_8020E1E8.s.o(.bss); }
    .main_8020E230 0x8020E230 : AT(0x0000EE30) { build/asm/data/main_8020E230.bin.o(.data); }
    .main_8020E424 0x8020E424 : AT(0x0000F024) { FILL(0x00000000); build/asm/main_8020E424.s.o(.text); build/asm/main_8020E424.s.o(.rodata); build/asm/main_8020E424.s.o(.data); }
    .main_8020E424_bss (NOLOAD) : { build/asm/main_8020E424.s.o(.bss); }
    .main_8020E428 0x8020E428 : AT(0x0000F028) { build/asm/data/main_8020E428.bin.o(.data); }
    .main_8020F464 0x8020F464 : AT(0x00010064) { FILL(0x00000000); build/asm/main_8020F464.s.o(.text); build/asm/main_8020F464.s.o(.rodata); build/asm/main_8020F464.s.o(.data); }
    .main_8020F464_bss (NOLOAD) : { build/asm/main_8020F464.s.o(.bss); }
    .main_8020F4A8 0x8020F4A8 : AT(0x000100A8) { build/asm/data/main_8020F4A8.bin.o(.data); }
    .main_8020FF0C 0x8020FF0C : AT(0x00010B0C) { FILL(0x00000000); build/asm/main_8020FF0C.s.o(.text); build/asm/main_8020FF0C.s.o(.rodata); build/asm/main_8020FF0C.s.o(.data); }
    .main_8020FF0C_bss (NOLOAD) : { build/asm/main_8020FF0C.s.o(.bss); }
    .main_8020FF8C 0x8020FF8C : AT(0x00010B8C) { build/asm/data/main_8020FF8C.bin.o(.data); }
    .main_80211AE8 0x80211AE8 : AT(0x000126E8) { FILL(0x00000000); build/asm/main_80211AE8.s.o(.text); build/asm/main_80211AE8.s.o(.rodata); build/asm/main_80211AE8.s.o(.data); }
    .main_80211AE8_bss (NOLOAD) : { build/asm/main_80211AE8.s.o(.bss); }
    .main_80211AF0 0x80211AF0 : AT(0x000126F0) { build/asm/data/main_80211AF0.bin.o(.data); }
    .main_8021265C 0x8021265C : AT(0x0001325C) { FILL(0x00000000); build/asm/main_8021265C.s.o(.text); build/asm/main_8021265C.s.o(.rodata); build/asm/main_8021265C.s.o(.data); }
    .main_8021265C_bss (NOLOAD) : { build/asm/main_8021265C.s.o(.bss); }
    .main_80212690 0x80212690 : AT(0x00013290) { build/asm/data/main_80212690.bin.o(.data); }
    .main_80213280 0x80213280 : AT(0x00013E80) { FILL(0x00000000); build/asm/main_80213280.s.o(.text); build/asm/main_80213280.s.o(.rodata); build/asm/main_80213280.s.o(.data); }
    .main_80213280_bss (NOLOAD) : { build/asm/main_80213280.s.o(.bss); }
    .main_80213284 0x80213284 : AT(0x00013E84) { build/asm/data/main_80213284.bin.o(.data); }
    .main_802136E0 0x802136E0 : AT(0x000142E0) { FILL(0x00000000); build/asm/main_802136E0.s.o(.text); build/asm/main_802136E0.s.o(.rodata); build/asm/main_802136E0.s.o(.data); }
    .main_802136E0_bss (NOLOAD) : { build/asm/main_802136E0.s.o(.bss); }
    .main_80213728 0x80213728 : AT(0x00014328) { build/asm/data/main_80213728.bin.o(.data); }
    .main_80214E28 0x80214E28 : AT(0x00015A28) { FILL(0x00000000); build/asm/main_80214E28.s.o(.text); build/asm/main_80214E28.s.o(.rodata); build/asm/main_80214E28.s.o(.data); }
    .main_80214E28_bss (NOLOAD) : { build/asm/main_80214E28.s.o(.bss); }
    .main_80214E78 0x80214E78 : AT(0x00015A78) { build/asm/data/main_80214E78.bin.o(.data); }
    .main_80215FF8 0x80215FF8 : AT(0x00016BF8) { FILL(0x00000000); build/asm/main_80215FF8.s.o(.text); build/asm/main_80215FF8.s.o(.rodata); build/asm/main_80215FF8.s.o(.data); }
    .main_80215FF8_bss (NOLOAD) : { build/asm/main_80215FF8.s.o(.bss); }
    .main_80216008 0x80216008 : AT(0x00016C08) { build/asm/data/main_80216008.bin.o(.data); }
    .main_80219520 0x80219520 : AT(0x0001A120) { FILL(0x00000000); build/asm/main_80219520.s.o(.text); build/asm/main_80219520.s.o(.rodata); build/asm/main_80219520.s.o(.data); }
    .main_80219520_bss (NOLOAD) : { build/asm/main_80219520.s.o(.bss); }
    .main_80219584 0x80219584 : AT(0x0001A184) { build/asm/data/main_80219584.bin.o(.data); }
    .main_802199D4 0x802199D4 : AT(0x0001A5D4) { FILL(0x00000000); build/asm/main_802199D4.s.o(.text); build/asm/main_802199D4.s.o(.rodata); build/asm/main_802199D4.s.o(.data); }
    .main_802199D4_bss (NOLOAD) : { build/asm/main_802199D4.s.o(.bss); }
    .main_802199F4 0x802199F4 : AT(0x0001A5F4) { build/asm/data/main_802199F4.bin.o(.data); }
    .main_80219C40 0x80219C40 : AT(0x0001A840) { FILL(0x00000000); build/asm/main_80219C40.s.o(.text); build/asm/main_80219C40.s.o(.rodata); build/asm/main_80219C40.s.o(.data); }
    .main_80219C40_bss (NOLOAD) : { build/asm/main_80219C40.s.o(.bss); }
    .main_80219C50 0x80219C50 : AT(0x0001A850) { build/asm/data/main_80219C50.bin.o(.data); }
    .main_8021A394 0x8021A394 : AT(0x0001AF94) { FILL(0x00000000); build/asm/main_8021A394.s.o(.text); build/asm/main_8021A394.s.o(.rodata); build/asm/main_8021A394.s.o(.data); }
    .main_8021A394_bss (NOLOAD) : { build/asm/main_8021A394.s.o(.bss); }
    .main_8021A444 0x8021A444 : AT(0x0001B044) { build/asm/data/main_8021A444.bin.o(.data); }
    .main_8021B044 0x8021B044 : AT(0x0001BC44) { FILL(0x00000000); build/asm/main_8021B044.s.o(.text); build/asm/main_8021B044.s.o(.rodata); build/asm/main_8021B044.s.o(.data); }
    .main_8021B044_bss (NOLOAD) : { build/asm/main_8021B044.s.o(.bss); }
    .main_8021B078 0x8021B078 : AT(0x0001BC78) { build/asm/data/main_8021B078.bin.o(.data); }
    .main_8021B71C 0x8021B71C : AT(0x0001C31C) { FILL(0x00000000); build/asm/main_8021B71C.s.o(.text); build/asm/main_8021B71C.s.o(.rodata); build/asm/main_8021B71C.s.o(.data); }
    .main_8021B71C_bss (NOLOAD) : { build/asm/main_8021B71C.s.o(.bss); }
    .main_8021B73C 0x8021B73C : AT(0x0001C33C) { build/asm/data/main_8021B73C.bin.o(.data); }
    .main_8021FA70 0x8021FA70 : AT(0x00020670) { FILL(0x00000000); build/asm/main_8021FA70.s.o(.text); build/asm/main_8021FA70.s.o(.rodata); build/asm/main_8021FA70.s.o(.data); }
    .main_8021FA70_bss (NOLOAD) : { build/asm/main_8021FA70.s.o(.bss); }
    .main_8021FAB8 0x8021FAB8 : AT(0x000206B8) { build/asm/data/main_8021FAB8.bin.o(.data); }
    .main_80220400 0x80220400 : AT(0x00021000) { FILL(0x00000000); build/asm/main_80220400.s.o(.text); build/asm/main_80220400.s.o(.rodata); build/asm/main_80220400.s.o(.data); }
    .main_80220400_bss (NOLOAD) : { build/asm/main_80220400.s.o(.bss); }
    .main_80220408 0x80220408 : AT(0x00021008) { build/asm/data/main_80220408.bin.o(.data); }
    .main_80221940 0x80221940 : AT(0x00022540) { FILL(0x00000000); build/asm/main_80221940.s.o(.text); build/asm/main_80221940.s.o(.rodata); build/asm/main_80221940.s.o(.data); }
    .main_80221940_bss (NOLOAD) : { build/asm/main_80221940.s.o(.bss); }
    .main_802219AC 0x802219AC : AT(0x000225AC) { build/asm/data/main_802219AC.bin.o(.data); }
    .main_80221CB4 0x80221CB4 : AT(0x000228B4) { FILL(0x00000000); build/asm/main_80221CB4.s.o(.text); build/asm/main_80221CB4.s.o(.rodata); build/asm/main_80221CB4.s.o(.data); }
    .main_80221CB4_bss (NOLOAD) : { build/asm/main_80221CB4.s.o(.bss); }
    .main_80221D04 0x80221D04 : AT(0x00022904) { build/asm/data/main_80221D04.bin.o(.data); }
    .main_80222B90 0x80222B90 : AT(0x00023790) { FILL(0x00000000); build/asm/main_80222B90.s.o(.text); build/asm/main_80222B90.s.o(.rodata); build/asm/main_80222B90.s.o(.data); }
    .main_80222B90_bss (NOLOAD) : { build/asm/main_80222B90.s.o(.bss); }
    .main_80222BA0 0x80222BA0 : AT(0x000237A0) { build/asm/data/main_80222BA0.bin.o(.data); }
    .main_80222FC8 0x80222FC8 : AT(0x00023BC8) { FILL(0x00000000); build/asm/main_80222FC8.s.o(.text); build/asm/main_80222FC8.s.o(.rodata); build/asm/main_80222FC8.s.o(.data); }
    .main_80222FC8_bss (NOLOAD) : { build/asm/main_80222FC8.s.o(.bss); }
    .main_80222FDC 0x80222FDC : AT(0x00023BDC) { build/asm/data/main_80222FDC.bin.o(.data); }
    .main_802244A8 0x802244A8 : AT(0x000250A8) { FILL(0x00000000); build/asm/main_802244A8.s.o(.text); build/asm/main_802244A8.s.o(.rodata); build/asm/main_802244A8.s.o(.data); }
    .main_802244A8_bss (NOLOAD) : { build/asm/main_802244A8.s.o(.bss); }
    .main_80224504 0x80224504 : AT(0x00025104) { build/asm/data/main_80224504.bin.o(.data); }
    .main_80224BB8 0x80224BB8 : AT(0x000257B8) { FILL(0x00000000); build/asm/main_80224BB8.s.o(.text); build/asm/main_80224BB8.s.o(.rodata); build/asm/main_80224BB8.s.o(.data); }
    .main_80224BB8_bss (NOLOAD) : { build/asm/main_80224BB8.s.o(.bss); }
    .main_80224BCC 0x80224BCC : AT(0x000257CC) { build/asm/data/main_80224BCC.bin.o(.data); }
    .main_80224D74 0x80224D74 : AT(0x00025974) { FILL(0x00000000); build/asm/main_80224D74.s.o(.text); build/asm/main_80224D74.s.o(.rodata); build/asm/main_80224D74.s.o(.data); }
    .main_80224D74_bss (NOLOAD) : { build/asm/main_80224D74.s.o(.bss); }
    .main_80224DDC 0x80224DDC : AT(0x000259DC) { build/asm/data/main_80224DDC.bin.o(.data); }
    .main_80227C64 0x80227C64 : AT(0x00028864) { FILL(0x00000000); build/asm/main_80227C64.s.o(.text); build/asm/main_80227C64.s.o(.rodata); build/asm/main_80227C64.s.o(.data); }
    .main_80227C64_bss (NOLOAD) : { build/asm/main_80227C64.s.o(.bss); }
    .main_80227CFC 0x80227CFC : AT(0x000288FC) { build/asm/data/main_80227CFC.bin.o(.data); }
    .main_8022B50C 0x8022B50C : AT(0x0002C10C) { FILL(0x00000000); build/asm/main_8022B50C.s.o(.text); build/asm/main_8022B50C.s.o(.rodata); build/asm/main_8022B50C.s.o(.data); }
    .main_8022B50C_bss (NOLOAD) : { build/asm/main_8022B50C.s.o(.bss); }
    .main_8022B510 0x8022B510 : AT(0x0002C110) { build/asm/data/main_8022B510.bin.o(.data); }
    .main_8022BE40 0x8022BE40 : AT(0x0002CA40) { FILL(0x00000000); build/asm/main_8022BE40.s.o(.text); build/asm/main_8022BE40.s.o(.rodata); build/asm/main_8022BE40.s.o(.data); }
    .main_8022BE40_bss (NOLOAD) : { build/asm/main_8022BE40.s.o(.bss); }
    .main_8022BE78 0x8022BE78 : AT(0x0002CA78) { build/asm/data/main_8022BE78.bin.o(.data); }
    .main_80230828 0x80230828 : AT(0x00031428) { FILL(0x00000000); build/asm/main_80230828.s.o(.text); build/asm/main_80230828.s.o(.rodata); build/asm/main_80230828.s.o(.data); }
    .main_80230828_bss (NOLOAD) : { build/asm/main_80230828.s.o(.bss); }
    .main_80230874 0x80230874 : AT(0x00031474) { build/asm/data/main_80230874.bin.o(.data); }
    .main_80231620 0x80231620 : AT(0x00032220) { FILL(0x00000000); build/asm/main_80231620.s.o(.text); build/asm/main_80231620.s.o(.rodata); build/asm/main_80231620.s.o(.data); }
    .main_80231620_bss (NOLOAD) : { build/asm/main_80231620.s.o(.bss); }
    .main_80231648 0x80231648 : AT(0x00032248) { build/asm/data/main_80231648.bin.o(.data); }
    .main_80233B78 0x80233B78 : AT(0x00034778) { FILL(0x00000000); build/asm/main_80233B78.s.o(.text); build/asm/main_80233B78.s.o(.rodata); build/asm/main_80233B78.s.o(.data); }
    .main_80233B78_bss (NOLOAD) : { build/asm/main_80233B78.s.o(.bss); }
    .main_80233BC4 0x80233BC4 : AT(0x000347C4) { build/asm/data/main_80233BC4.bin.o(.data); }
    .main_802380BC 0x802380BC : AT(0x00038CBC) { FILL(0x00000000); build/asm/main_802380BC.s.o(.text); build/asm/main_802380BC.s.o(.rodata); build/asm/main_802380BC.s.o(.data); }
    .main_802380BC_bss (NOLOAD) : { build/asm/main_802380BC.s.o(.bss); }
    .main_802381A4 0x802381A4 : AT(0x00038DA4) { build/asm/data/main_802381A4.bin.o(.data); }
    .main_8023852C 0x8023852C : AT(0x0003912C) { FILL(0x00000000); build/asm/main_8023852C.s.o(.text); build/asm/main_8023852C.s.o(.rodata); build/asm/main_8023852C.s.o(.data); }
    .main_8023852C_bss (NOLOAD) : { build/asm/main_8023852C.s.o(.bss); }
    .main_80238770 0x80238770 : AT(0x00039370) { build/asm/data/main_80238770.bin.o(.data); }
    .main_80238C2C 0x80238C2C : AT(0x0003982C) { FILL(0x00000000); build/asm/main_80238C2C.s.o(.text); build/asm/main_80238C2C.s.o(.rodata); build/asm/main_80238C2C.s.o(.data); }
    .main_80238C2C_bss (NOLOAD) : { build/asm/main_80238C2C.s.o(.bss); }
    .main_80238C4C 0x80238C4C : AT(0x0003984C) { build/asm/data/main_80238C4C.bin.o(.data); }
    .main_80238CF4 0x80238CF4 : AT(0x000398F4) { FILL(0x00000000); build/asm/main_80238CF4.s.o(.text); build/asm/main_80238CF4.s.o(.rodata); build/asm/main_80238CF4.s.o(.data); }
    .main_80238CF4_bss (NOLOAD) : { build/asm/main_80238CF4.s.o(.bss); }
    .main_80238D9C 0x80238D9C : AT(0x0003999C) { build/asm/data/main_80238D9C.bin.o(.data); }
    .main_8023AAC0 0x8023AAC0 : AT(0x0003B6C0) { FILL(0x00000000); build/asm/main_8023AAC0.s.o(.text); build/asm/main_8023AAC0.s.o(.rodata); build/asm/main_8023AAC0.s.o(.data); }
    .main_8023AAC0_bss (NOLOAD) : { build/asm/main_8023AAC0.s.o(.bss); }
    .main_8023AAD0 0x8023AAD0 : AT(0x0003B6D0) { build/asm/data/main_8023AAD0.bin.o(.data); }
    .main_8023B530 0x8023B530 : AT(0x0003C130) { FILL(0x00000000); build/asm/main_8023B530.s.o(.text); build/asm/main_8023B530.s.o(.rodata); build/asm/main_8023B530.s.o(.data); }
    .main_8023B530_bss (NOLOAD) : { build/asm/main_8023B530.s.o(.bss); }
    .main_8023B550 0x8023B550 : AT(0x0003C150) { build/asm/data/main_8023B550.bin.o(.data); }
    .main_8023CD84 0x8023CD84 : AT(0x0003D984) { FILL(0x00000000); build/asm/main_8023CD84.s.o(.text); build/asm/main_8023CD84.s.o(.rodata); build/asm/main_8023CD84.s.o(.data); }
    .main_8023CD84_bss (NOLOAD) : { build/asm/main_8023CD84.s.o(.bss); }
    .main_8023CD98 0x8023CD98 : AT(0x0003D998) { build/asm/data/main_8023CD98.bin.o(.data); }
    .main_8023F358 0x8023F358 : AT(0x0003FF58) { FILL(0x00000000); build/asm/main_8023F358.s.o(.text); build/asm/main_8023F358.s.o(.rodata); build/asm/main_8023F358.s.o(.data); }
    .main_8023F358_bss (NOLOAD) : { build/asm/main_8023F358.s.o(.bss); }
    .main_8023F370 0x8023F370 : AT(0x0003FF70) { build/asm/data/main_8023F370.bin.o(.data); }
    .main_8023F5F4 0x8023F5F4 : AT(0x000401F4) { FILL(0x00000000); build/asm/main_8023F5F4.s.o(.text); build/asm/main_8023F5F4.s.o(.rodata); build/asm/main_8023F5F4.s.o(.data); }
    .main_8023F5F4_bss (NOLOAD) : { build/asm/main_8023F5F4.s.o(.bss); }
    .main_8023F668 0x8023F668 : AT(0x00040268) { build/asm/data/main_8023F668.bin.o(.data); }
    .main_80247A9C 0x80247A9C : AT(0x0004869C) { FILL(0x00000000); build/asm/main_80247A9C.s.o(.text); build/asm/main_80247A9C.s.o(.rodata); build/asm/main_80247A9C.s.o(.data); }
    .main_80247A9C_bss (NOLOAD) : { build/asm/main_80247A9C.s.o(.bss); }
    .main_80247B00 0x80247B00 : AT(0x00048700) { build/asm/data/main_80247B00.bin.o(.data); }
    .main_80247D44 0x80247D44 : AT(0x00048944) { FILL(0x00000000); build/asm/main_80247D44.s.o(.text); build/asm/main_80247D44.s.o(.rodata); build/asm/main_80247D44.s.o(.data); }
    .main_80247D44_bss (NOLOAD) : { build/asm/main_80247D44.s.o(.bss); }
    .main_80247D74 0x80247D74 : AT(0x00048974) { build/asm/data/main_80247D74.bin.o(.data); }
    .main_80250380 0x80250380 : AT(0x00050F80) { FILL(0x00000000); build/asm/main_80250380.s.o(.text); build/asm/main_80250380.s.o(.rodata); build/asm/main_80250380.s.o(.data); }
    .main_80250380_bss (NOLOAD) : { build/asm/main_80250380.s.o(.bss); }
    .main_802503BC 0x802503BC : AT(0x00050FBC) { build/asm/data/main_802503BC.bin.o(.data); }
    .main_80251364 0x80251364 : AT(0x00051F64) { FILL(0x00000000); build/asm/main_80251364.s.o(.text); build/asm/main_80251364.s.o(.rodata); build/asm/main_80251364.s.o(.data); }
    .main_80251364_bss (NOLOAD) : { build/asm/main_80251364.s.o(.bss); }
    .main_8025139C 0x8025139C : AT(0x00051F9C) { build/asm/data/main_8025139C.bin.o(.data); }
    .main_8025172C 0x8025172C : AT(0x0005232C) { FILL(0x00000000); build/asm/main_8025172C.s.o(.text); build/asm/main_8025172C.s.o(.rodata); build/asm/main_8025172C.s.o(.data); }
    .main_8025172C_bss (NOLOAD) : { build/asm/main_8025172C.s.o(.bss); }
    .main_802517A4 0x802517A4 : AT(0x000523A4) { build/asm/data/main_802517A4.bin.o(.data); }
    .main_8025405C 0x8025405C : AT(0x00054C5C) { FILL(0x00000000); build/asm/main_8025405C.s.o(.text); build/asm/main_8025405C.s.o(.rodata); build/asm/main_8025405C.s.o(.data); }
    .main_8025405C_bss (NOLOAD) : { build/asm/main_8025405C.s.o(.bss); }
    .main_802540F8 0x802540F8 : AT(0x00054CF8) { build/asm/data/main_802540F8.bin.o(.data); }
    .main_802544EC 0x802544EC : AT(0x000550EC) { FILL(0x00000000); build/asm/main_802544EC.s.o(.text); build/asm/main_802544EC.s.o(.rodata); build/asm/main_802544EC.s.o(.data); }
    .main_802544EC_bss (NOLOAD) : { build/asm/main_802544EC.s.o(.bss); }
    .main_80254518 0x80254518 : AT(0x00055118) { build/asm/data/main_80254518.bin.o(.data); }
    .main_80254D74 0x80254D74 : AT(0x00055974) { FILL(0x00000000); build/asm/main_80254D74.s.o(.text); build/asm/main_80254D74.s.o(.rodata); build/asm/main_80254D74.s.o(.data); }
    .main_80254D74_bss (NOLOAD) : { build/asm/main_80254D74.s.o(.bss); }
    .main_80254DBC 0x80254DBC : AT(0x000559BC) { build/asm/data/main_80254DBC.bin.o(.data); }
    .main_80255400 0x80255400 : AT(0x00056000) { FILL(0x00000000); build/asm/main_80255400.s.o(.text); build/asm/main_80255400.s.o(.rodata); build/asm/main_80255400.s.o(.data); }
    .main_80255400_bss (NOLOAD) : { build/asm/main_80255400.s.o(.bss); }
    .main_80255B44 0x80255B44 : AT(0x00056744) { build/asm/data/main_80255B44.bin.o(.data); }
    .main_80255B80 0x80255B80 : AT(0x00056780) { FILL(0x00000000); build/asm/main_80255B80.s.o(.text); build/asm/main_80255B80.s.o(.rodata); build/asm/main_80255B80.s.o(.data); }
    .main_80255B80_bss (NOLOAD) : { build/asm/main_80255B80.s.o(.bss); }
    .main_80255C54 0x80255C54 : AT(0x00056854) { build/asm/data/main_80255C54.bin.o(.data); }
    .main_80255CE4 0x80255CE4 : AT(0x000568E4) { FILL(0x00000000); build/asm/main_80255CE4.s.o(.text); build/asm/main_80255CE4.s.o(.rodata); build/asm/main_80255CE4.s.o(.data); }
    .main_80255CE4_bss (NOLOAD) : { build/asm/main_80255CE4.s.o(.bss); }
    .main_80255D84 0x80255D84 : AT(0x00056984) { build/asm/data/main_80255D84.bin.o(.data); }
    .main_8025639C 0x8025639C : AT(0x00056F9C) { FILL(0x00000000); build/asm/main_8025639C.s.o(.text); build/asm/main_8025639C.s.o(.rodata); build/asm/main_8025639C.s.o(.data); }
    .main_8025639C_bss (NOLOAD) : { build/asm/main_8025639C.s.o(.bss); }
    .main_802563E0 0x802563E0 : AT(0x00056FE0) { build/asm/data/main_802563E0.bin.o(.data); }
    .main_80256410 0x80256410 : AT(0x00057010) { FILL(0x00000000); build/asm/main_80256410.s.o(.text); build/asm/main_80256410.s.o(.rodata); build/asm/main_80256410.s.o(.data); }
    .main_80256410_bss (NOLOAD) : { build/asm/main_80256410.s.o(.bss); }
    .main_8025643C 0x8025643C : AT(0x0005703C) { build/asm/data/main_8025643C.bin.o(.data); }
    .main_80258F60 0x80258F60 : AT(0x00059B60) { FILL(0x00000000); build/asm/main_80258F60.s.o(.text); build/asm/main_80258F60.s.o(.rodata); build/asm/main_80258F60.s.o(.data); }
    .main_80258F60_bss (NOLOAD) : { build/asm/main_80258F60.s.o(.bss); }
    .main_80258F68 0x80258F68 : AT(0x00059B68) { build/asm/data/main_80258F68.bin.o(.data); }
    .main_8025A3D4 0x8025A3D4 : AT(0x0005AFD4) { FILL(0x00000000); build/asm/main_8025A3D4.s.o(.text); build/asm/main_8025A3D4.s.o(.rodata); build/asm/main_8025A3D4.s.o(.data); }
    .main_8025A3D4_bss (NOLOAD) : { build/asm/main_8025A3D4.s.o(.bss); }
    .main_8025A3E4 0x8025A3E4 : AT(0x0005AFE4) { build/asm/data/main_8025A3E4.bin.o(.data); }
    .main_8025D840 0x8025D840 : AT(0x0005E440) { FILL(0x00000000); build/asm/main_8025D840.s.o(.text); build/asm/main_8025D840.s.o(.rodata); build/asm/main_8025D840.s.o(.data); }
    .main_8025D840_bss (NOLOAD) : { build/asm/main_8025D840.s.o(.bss); }
    .main_8025D8C4 0x8025D8C4 : AT(0x0005E4C4) { build/asm/data/main_8025D8C4.bin.o(.data); }
    .main_8025F13C 0x8025F13C : AT(0x0005FD3C) { FILL(0x00000000); build/asm/main_8025F13C.s.o(.text); build/asm/main_8025F13C.s.o(.rodata); build/asm/main_8025F13C.s.o(.data); }
    .main_8025F13C_bss (NOLOAD) : { build/asm/main_8025F13C.s.o(.bss); }
    .main_8025F1B0 0x8025F1B0 : AT(0x0005FDB0) { build/asm/data/main_8025F1B0.bin.o(.data); }
    .main_802610FC 0x802610FC : AT(0x00061CFC) { FILL(0x00000000); build/asm/main_802610FC.s.o(.text); build/asm/main_802610FC.s.o(.rodata); build/asm/main_802610FC.s.o(.data); }
    .main_802610FC_bss (NOLOAD) : { build/asm/main_802610FC.s.o(.bss); }
    .main_80261154 0x80261154 : AT(0x00061D54) { build/asm/data/main_80261154.bin.o(.data); }
    .main_802612C4 0x802612C4 : AT(0x00061EC4) { FILL(0x00000000); build/asm/main_802612C4.s.o(.text); build/asm/main_802612C4.s.o(.rodata); build/asm/main_802612C4.s.o(.data); }
    .main_802612C4_bss (NOLOAD) : { build/asm/main_802612C4.s.o(.bss); }
    .main_802612F8 0x802612F8 : AT(0x00061EF8) { build/asm/data/main_802612F8.bin.o(.data); }
    .main_802625C8 0x802625C8 : AT(0x000631C8) { FILL(0x00000000); build/asm/main_802625C8.s.o(.text); build/asm/main_802625C8.s.o(.rodata); build/asm/main_802625C8.s.o(.data); }
    .main_802625C8_bss (NOLOAD) : { build/asm/main_802625C8.s.o(.bss); }
    .main_8026263C 0x8026263C : AT(0x0006323C) { build/asm/data/main_8026263C.bin.o(.data); }
    .main_80263054 0x80263054 : AT(0x00063C54) { FILL(0x00000000); build/asm/main_80263054.s.o(.text); build/asm/main_80263054.s.o(.rodata); build/asm/main_80263054.s.o(.data); }
    .main_80263054_bss (NOLOAD) : { build/asm/main_80263054.s.o(.bss); }
    .main_8026305C 0x8026305C : AT(0x00063C5C) { build/asm/data/main_8026305C.bin.o(.data); }
    .main_80265B24 0x80265B24 : AT(0x00066724) { FILL(0x00000000); build/asm/main_80265B24.s.o(.text); build/asm/main_80265B24.s.o(.rodata); build/asm/main_80265B24.s.o(.data); }
    .main_80265B24_bss (NOLOAD) : { build/asm/main_80265B24.s.o(.bss); }
    .main_80265B70 0x80265B70 : AT(0x00066770) { build/asm/data/main_80265B70.bin.o(.data); }
    .main_80265C04 0x80265C04 : AT(0x00066804) { FILL(0x00000000); build/asm/main_80265C04.s.o(.text); build/asm/main_80265C04.s.o(.rodata); build/asm/main_80265C04.s.o(.data); }
    .main_80265C04_bss (NOLOAD) : { build/asm/main_80265C04.s.o(.bss); }
    .main_80265C10 0x80265C10 : AT(0x00066810) { build/asm/data/main_80265C10.bin.o(.data); }
    .main_80267E5C 0x80267E5C : AT(0x00068A5C) { FILL(0x00000000); build/asm/main_80267E5C.s.o(.text); build/asm/main_80267E5C.s.o(.rodata); build/asm/main_80267E5C.s.o(.data); }
    .main_80267E5C_bss (NOLOAD) : { build/asm/main_80267E5C.s.o(.bss); }
    .main_80267E64 0x80267E64 : AT(0x00068A64) { build/asm/data/main_80267E64.bin.o(.data); }
    .main_8026AD14 0x8026AD14 : AT(0x0006B914) { FILL(0x00000000); build/asm/main_8026AD14.s.o(.text); build/asm/main_8026AD14.s.o(.rodata); build/asm/main_8026AD14.s.o(.data); }
    .main_8026AD14_bss (NOLOAD) : { build/asm/main_8026AD14.s.o(.bss); }
    .main_8026AD18 0x8026AD18 : AT(0x0006B918) { build/asm/data/main_8026AD18.bin.o(.data); }
    .main_8026B810 0x8026B810 : AT(0x0006C410) { FILL(0x00000000); build/asm/main_8026B810.s.o(.text); build/asm/main_8026B810.s.o(.rodata); build/asm/main_8026B810.s.o(.data); }
    .main_8026B810_bss (NOLOAD) : { build/asm/main_8026B810.s.o(.bss); }
    .main_8026B86C 0x8026B86C : AT(0x0006C46C) { build/asm/data/main_8026B86C.bin.o(.data); }
    .main_8026C110 0x8026C110 : AT(0x0006CD10) { FILL(0x00000000); build/asm/main_8026C110.s.o(.text); build/asm/main_8026C110.s.o(.rodata); build/asm/main_8026C110.s.o(.data); }
    .main_8026C110_bss (NOLOAD) : { build/asm/main_8026C110.s.o(.bss); }
    .main_8026C164 0x8026C164 : AT(0x0006CD64) { build/asm/data/main_8026C164.bin.o(.data); }
    .main_8026C1F4 0x8026C1F4 : AT(0x0006CDF4) { FILL(0x00000000); build/asm/main_8026C1F4.s.o(.text); build/asm/main_8026C1F4.s.o(.rodata); build/asm/main_8026C1F4.s.o(.data); }
    .main_8026C1F4_bss (NOLOAD) : { build/asm/main_8026C1F4.s.o(.bss); }
    .main_8026C200 0x8026C200 : AT(0x0006CE00) { build/asm/data/main_8026C200.bin.o(.data); }
    .main_8026EAE4 0x8026EAE4 : AT(0x0006F6E4) { FILL(0x00000000); build/asm/main_8026EAE4.s.o(.text); build/asm/main_8026EAE4.s.o(.rodata); build/asm/main_8026EAE4.s.o(.data); }
    .main_8026EAE4_bss (NOLOAD) : { build/asm/main_8026EAE4.s.o(.bss); }
    .main_8026EB20 0x8026EB20 : AT(0x0006F720) { build/asm/data/main_8026EB20.bin.o(.data); }
    .main_80270ECC 0x80270ECC : AT(0x00071ACC) { FILL(0x00000000); build/asm/main_80270ECC.s.o(.text); build/asm/main_80270ECC.s.o(.rodata); build/asm/main_80270ECC.s.o(.data); }
    .main_80270ECC_bss (NOLOAD) : { build/asm/main_80270ECC.s.o(.bss); }
    .main_80270EE8 0x80270EE8 : AT(0x00071AE8) { build/asm/data/main_80270EE8.bin.o(.data); }
    .main_8027120C 0x8027120C : AT(0x00071E0C) { FILL(0x00000000); build/asm/main_8027120C.s.o(.text); build/asm/main_8027120C.s.o(.rodata); build/asm/main_8027120C.s.o(.data); }
    .main_8027120C_bss (NOLOAD) : { build/asm/main_8027120C.s.o(.bss); }
    .main_80271238 0x80271238 : AT(0x00071E38) { build/asm/data/main_80271238.bin.o(.data); }
    .main_80271EE4 0x80271EE4 : AT(0x00072AE4) { FILL(0x00000000); build/asm/main_80271EE4.s.o(.text); build/asm/main_80271EE4.s.o(.rodata); build/asm/main_80271EE4.s.o(.data); }
    .main_80271EE4_bss (NOLOAD) : { build/asm/main_80271EE4.s.o(.bss); }
    .main_80271F20 0x80271F20 : AT(0x00072B20) { build/asm/data/main_80271F20.bin.o(.data); }
    .main_802726B4 0x802726B4 : AT(0x000732B4) { FILL(0x00000000); build/asm/main_802726B4.s.o(.text); build/asm/main_802726B4.s.o(.rodata); build/asm/main_802726B4.s.o(.data); }
    .main_802726B4_bss (NOLOAD) : { build/asm/main_802726B4.s.o(.bss); }
    .main_802726CC 0x802726CC : AT(0x000732CC) { build/asm/data/main_802726CC.bin.o(.data); }
    .main_80275110 0x80275110 : AT(0x00075D10) { FILL(0x00000000); build/asm/main_80275110.s.o(.text); build/asm/main_80275110.s.o(.rodata); build/asm/main_80275110.s.o(.data); }
    .main_80275110_bss (NOLOAD) : { build/asm/main_80275110.s.o(.bss); }
    .main_802751C0 0x802751C0 : AT(0x00075DC0) { build/asm/data/main_802751C0.bin.o(.data); }
    .main_80275F64 0x80275F64 : AT(0x00076B64) { FILL(0x00000000); build/asm/main_80275F64.s.o(.text); build/asm/main_80275F64.s.o(.rodata); build/asm/main_80275F64.s.o(.data); }
    .main_80275F64_bss (NOLOAD) : { build/asm/main_80275F64.s.o(.bss); }
    .main_80275F6C 0x80275F6C : AT(0x00076B6C) { build/asm/data/main_80275F6C.bin.o(.data); }
    .main_8027781C 0x8027781C : AT(0x0007841C) { FILL(0x00000000); build/asm/main_8027781C.s.o(.text); build/asm/main_8027781C.s.o(.rodata); build/asm/main_8027781C.s.o(.data); }
    .main_8027781C_bss (NOLOAD) : { build/asm/main_8027781C.s.o(.bss); }
    .main_8027784C 0x8027784C : AT(0x0007844C) { build/asm/data/main_8027784C.bin.o(.data); }
    .main_80277E88 0x80277E88 : AT(0x00078A88) { FILL(0x00000000); build/asm/main_80277E88.s.o(.text); build/asm/main_80277E88.s.o(.rodata); build/asm/main_80277E88.s.o(.data); }
    .main_80277E88_bss (NOLOAD) : { build/asm/main_80277E88.s.o(.bss); }
    .main_80277EA0 0x80277EA0 : AT(0x00078AA0) { build/asm/data/main_80277EA0.bin.o(.data); }
    .main_8027B164 0x8027B164 : AT(0x0007BD64) { FILL(0x00000000); build/asm/main_8027B164.s.o(.text); build/asm/main_8027B164.s.o(.rodata); build/asm/main_8027B164.s.o(.data); }
    .main_8027B164_bss (NOLOAD) : { build/asm/main_8027B164.s.o(.bss); }
    .main_8027B1A4 0x8027B1A4 : AT(0x0007BDA4) { build/asm/data/main_8027B1A4.bin.o(.data); }
    .main_8027D5AC 0x8027D5AC : AT(0x0007E1AC) { FILL(0x00000000); build/asm/main_8027D5AC.s.o(.text); build/asm/main_8027D5AC.s.o(.rodata); build/asm/main_8027D5AC.s.o(.data); }
    .main_8027D5AC_bss (NOLOAD) : { build/asm/main_8027D5AC.s.o(.bss); }
    .main_8027D5C8 0x8027D5C8 : AT(0x0007E1C8) { build/asm/data/main_8027D5C8.bin.o(.data); }
    .main_8027DC1C 0x8027DC1C : AT(0x0007E81C) { FILL(0x00000000); build/asm/main_8027DC1C.s.o(.text); build/asm/main_8027DC1C.s.o(.rodata); build/asm/main_8027DC1C.s.o(.data); }
    .main_8027DC1C_bss (NOLOAD) : { build/asm/main_8027DC1C.s.o(.bss); }
    .main_8027DC24 0x8027DC24 : AT(0x0007E824) { build/asm/data/main_8027DC24.bin.o(.data); }
    .main_8027FA2C 0x8027FA2C : AT(0x0008062C) { FILL(0x00000000); build/asm/main_8027FA2C.s.o(.text); build/asm/main_8027FA2C.s.o(.rodata); build/asm/main_8027FA2C.s.o(.data); }
    .main_8027FA2C_bss (NOLOAD) : { build/asm/main_8027FA2C.s.o(.bss); }
    .main_8027FAB4 0x8027FAB4 : AT(0x000806B4) { build/asm/data/main_8027FAB4.bin.o(.data); }
    .main_80282034 0x80282034 : AT(0x00082C34) { FILL(0x00000000); build/asm/main_80282034.s.o(.text); build/asm/main_80282034.s.o(.rodata); build/asm/main_80282034.s.o(.data); }
    .main_80282034_bss (NOLOAD) : { build/asm/main_80282034.s.o(.bss); }
    .main_80282054 0x80282054 : AT(0x00082C54) { build/asm/data/main_80282054.bin.o(.data); }
    .main_8028A6C8 0x8028A6C8 : AT(0x0008B2C8) { FILL(0x00000000); build/asm/main_8028A6C8.s.o(.text); build/asm/main_8028A6C8.s.o(.rodata); build/asm/main_8028A6C8.s.o(.data); }
    .main_8028A6C8_bss (NOLOAD) : { build/asm/main_8028A6C8.s.o(.bss); }
    .main_8028A6E4 0x8028A6E4 : AT(0x0008B2E4) { build/asm/data/main_8028A6E4.bin.o(.data); }
    .main_8028CC50 0x8028CC50 : AT(0x0008D850) { FILL(0x00000000); build/asm/main_8028CC50.s.o(.text); build/asm/main_8028CC50.s.o(.rodata); build/asm/main_8028CC50.s.o(.data); }
    .main_8028CC50_bss (NOLOAD) : { build/asm/main_8028CC50.s.o(.bss); }
    .main_8028CCB0 0x8028CCB0 : AT(0x0008D8B0) { build/asm/data/main_8028CCB0.bin.o(.data); }
    .main_8028D470 0x8028D470 : AT(0x0008E070) { FILL(0x00000000); build/asm/main_8028D470.s.o(.text); build/asm/main_8028D470.s.o(.rodata); build/asm/main_8028D470.s.o(.data); }
    .main_8028D470_bss (NOLOAD) : { build/asm/main_8028D470.s.o(.bss); }
    .main_8028D5A4 0x8028D5A4 : AT(0x0008E1A4) { build/asm/data/main_8028D5A4.bin.o(.data); }
    .main_8028E8A8 0x8028E8A8 : AT(0x0008F4A8) { FILL(0x00000000); build/asm/main_8028E8A8.s.o(.text); build/asm/main_8028E8A8.s.o(.rodata); build/asm/main_8028E8A8.s.o(.data); }
    .main_8028E8A8_bss (NOLOAD) : { build/asm/main_8028E8A8.s.o(.bss); }
    .main_8028E8B8 0x8028E8B8 : AT(0x0008F4B8) { build/asm/data/main_8028E8B8.bin.o(.data); }
    .main_80290280 0x80290280 : AT(0x00090E80) { FILL(0x00000000); build/asm/main_80290280.s.o(.text); build/asm/main_80290280.s.o(.rodata); build/asm/main_80290280.s.o(.data); }
    .main_80290280_bss (NOLOAD) : { build/asm/main_80290280.s.o(.bss); }
    .main_802902A8 0x802902A8 : AT(0x00090EA8) { build/asm/data/main_802902A8.bin.o(.data); }
    .main_80292608 0x80292608 : AT(0x00093208) { FILL(0x00000000); build/asm/main_80292608.s.o(.text); build/asm/main_80292608.s.o(.rodata); build/asm/main_80292608.s.o(.data); }
    .main_80292608_bss (NOLOAD) : { build/asm/main_80292608.s.o(.bss); }
    .main_80292628 0x80292628 : AT(0x00093228) { build/asm/data/main_80292628.bin.o(.data); }
    .main_80293C84 0x80293C84 : AT(0x00094884) { FILL(0x00000000); build/asm/main_80293C84.s.o(.text); build/asm/main_80293C84.s.o(.rodata); build/asm/main_80293C84.s.o(.data); }
    .main_80293C84_bss (NOLOAD) : { build/asm/main_80293C84.s.o(.bss); }
    .main_80293CD4 0x80293CD4 : AT(0x000948D4) { build/asm/data/main_80293CD4.bin.o(.data); }
    .main_80293E30 0x80293E30 : AT(0x00094A30) { FILL(0x00000000); build/asm/main_80293E30.s.o(.text); build/asm/main_80293E30.s.o(.rodata); build/asm/main_80293E30.s.o(.data); }
    .main_80293E30_bss (NOLOAD) : { build/asm/main_80293E30.s.o(.bss); }
    .main_80293F70 0x80293F70 : AT(0x00094B70) { build/asm/data/main_80293F70.bin.o(.data); }
    .main_8029443C 0x8029443C : AT(0x0009503C) { FILL(0x00000000); build/asm/main_8029443C.s.o(.text); build/asm/main_8029443C.s.o(.rodata); build/asm/main_8029443C.s.o(.data); }
    .main_8029443C_bss (NOLOAD) : { build/asm/main_8029443C.s.o(.bss); }
    .main_8029448C 0x8029448C : AT(0x0009508C) { build/asm/data/main_8029448C.bin.o(.data); }
    .main_80294870 0x80294870 : AT(0x00095470) { FILL(0x00000000); build/asm/main_80294870.s.o(.text); build/asm/main_80294870.s.o(.rodata); build/asm/main_80294870.s.o(.data); }
    .main_80294870_bss (NOLOAD) : { build/asm/main_80294870.s.o(.bss); }
    .main_802948F8 0x802948F8 : AT(0x000954F8) { build/asm/data/main_802948F8.bin.o(.data); }
    .main_80296C28 0x80296C28 : AT(0x00097828) { FILL(0x00000000); build/asm/main_80296C28.s.o(.text); build/asm/main_80296C28.s.o(.rodata); build/asm/main_80296C28.s.o(.data); }
    .main_80296C28_bss (NOLOAD) : { build/asm/main_80296C28.s.o(.bss); }
    .main_80296C3C 0x80296C3C : AT(0x0009783C) { build/asm/data/main_80296C3C.bin.o(.data); }
    .main_8029AE90 0x8029AE90 : AT(0x0009BA90) { FILL(0x00000000); build/asm/main_8029AE90.s.o(.text); build/asm/main_8029AE90.s.o(.rodata); build/asm/main_8029AE90.s.o(.data); }
    .main_8029AE90_bss (NOLOAD) : { build/asm/main_8029AE90.s.o(.bss); }
    .main_8029AF1C 0x8029AF1C : AT(0x0009BB1C) { build/asm/data/main_8029AF1C.bin.o(.data); }
    .main_8029D268 0x8029D268 : AT(0x0009DE68) { FILL(0x00000000); build/asm/main_8029D268.s.o(.text); build/asm/main_8029D268.s.o(.rodata); build/asm/main_8029D268.s.o(.data); }
    .main_8029D268_bss (NOLOAD) : { build/asm/main_8029D268.s.o(.bss); }
    .main_8029D2F4 0x8029D2F4 : AT(0x0009DEF4) { build/asm/data/main_8029D2F4.bin.o(.data); }
    .main_8029DB8C 0x8029DB8C : AT(0x0009E78C) { FILL(0x00000000); build/asm/main_8029DB8C.s.o(.text); build/asm/main_8029DB8C.s.o(.rodata); build/asm/main_8029DB8C.s.o(.data); }
    .main_8029DB8C_bss (NOLOAD) : { build/asm/main_8029DB8C.s.o(.bss); }
    .main_8029DBA8 0x8029DBA8 : AT(0x0009E7A8) { build/asm/data/main_8029DBA8.bin.o(.data); }
    .main_8029DBF0 0x8029DBF0 : AT(0x0009E7F0) { FILL(0x00000000); build/asm/main_8029DBF0.s.o(.text); build/asm/main_8029DBF0.s.o(.rodata); build/asm/main_8029DBF0.s.o(.data); }
    .main_8029DBF0_bss (NOLOAD) : { build/asm/main_8029DBF0.s.o(.bss); }
    .main_8029DC14 0x8029DC14 : AT(0x0009E814) { build/asm/data/main_8029DC14.bin.o(.data); }
    .main_8029E3FC 0x8029E3FC : AT(0x0009EFFC) { FILL(0x00000000); build/asm/main_8029E3FC.s.o(.text); build/asm/main_8029E3FC.s.o(.rodata); build/asm/main_8029E3FC.s.o(.data); }
    .main_8029E3FC_bss (NOLOAD) : { build/asm/main_8029E3FC.s.o(.bss); }
    .main_8029E404 0x8029E404 : AT(0x0009F004) { build/asm/data/main_8029E404.bin.o(.data); }
    .main_8029F800 0x8029F800 : AT(0x000A0400) { FILL(0x00000000); build/asm/main_8029F800.s.o(.text); build/asm/main_8029F800.s.o(.rodata); build/asm/main_8029F800.s.o(.data); }
    .main_8029F800_bss (NOLOAD) : { build/asm/main_8029F800.s.o(.bss); }
    .main_8029F83C 0x8029F83C : AT(0x000A043C) { build/asm/data/main_8029F83C.bin.o(.data); }
    .main_8029FCC4 0x8029FCC4 : AT(0x000A08C4) { FILL(0x00000000); build/asm/main_8029FCC4.s.o(.text); build/asm/main_8029FCC4.s.o(.rodata); build/asm/main_8029FCC4.s.o(.data); }
    .main_8029FCC4_bss (NOLOAD) : { build/asm/main_8029FCC4.s.o(.bss); }
    .main_8029FD4C 0x8029FD4C : AT(0x000A094C) { build/asm/data/main_8029FD4C.bin.o(.data); }
    .main_802A3034 0x802A3034 : AT(0x000A3C34) { FILL(0x00000000); build/asm/main_802A3034.s.o(.text); build/asm/main_802A3034.s.o(.rodata); build/asm/main_802A3034.s.o(.data); }
    .main_802A3034_bss (NOLOAD) : { build/asm/main_802A3034.s.o(.bss); }
    .main_802A3090 0x802A3090 : AT(0x000A3C90) { build/asm/data/main_802A3090.bin.o(.data); }
    .main_802A5320 0x802A5320 : AT(0x000A5F20) { FILL(0x00000000); build/asm/main_802A5320.s.o(.text); build/asm/main_802A5320.s.o(.rodata); build/asm/main_802A5320.s.o(.data); }
    .main_802A5320_bss (NOLOAD) : { build/asm/main_802A5320.s.o(.bss); }
    .main_802A5324 0x802A5324 : AT(0x000A5F24) { build/asm/data/main_802A5324.bin.o(.data); }
    .main_802A7BB0 0x802A7BB0 : AT(0x000A87B0) { FILL(0x00000000); build/asm/main_802A7BB0.s.o(.text); build/asm/main_802A7BB0.s.o(.rodata); build/asm/main_802A7BB0.s.o(.data); }
    .main_802A7BB0_bss (NOLOAD) : { build/asm/main_802A7BB0.s.o(.bss); }
    .main_802A7BBC 0x802A7BBC : AT(0x000A87BC) { build/asm/data/main_802A7BBC.bin.o(.data); }
    .main_802A8700 0x802A8700 : AT(0x000A9300) { FILL(0x00000000); build/asm/main_802A8700.s.o(.text); build/asm/main_802A8700.s.o(.rodata); build/asm/main_802A8700.s.o(.data); }
    .main_802A8700_bss (NOLOAD) : { build/asm/main_802A8700.s.o(.bss); }
    .main_802A87A8 0x802A87A8 : AT(0x000A93A8) { build/asm/data/main_802A87A8.bin.o(.data); }
    .main_802A969C 0x802A969C : AT(0x000AA29C) { FILL(0x00000000); build/asm/main_802A969C.s.o(.text); build/asm/main_802A969C.s.o(.rodata); build/asm/main_802A969C.s.o(.data); }
    .main_802A969C_bss (NOLOAD) : { build/asm/main_802A969C.s.o(.bss); }
    .main_802A96EC 0x802A96EC : AT(0x000AA2EC) { build/asm/data/main_802A96EC.bin.o(.data); }
    .main_802AA68C 0x802AA68C : AT(0x000AB28C) { FILL(0x00000000); build/asm/main_802AA68C.s.o(.text); build/asm/main_802AA68C.s.o(.rodata); build/asm/main_802AA68C.s.o(.data); }
    .main_802AA68C_bss (NOLOAD) : { build/asm/main_802AA68C.s.o(.bss); }
    .main_802AA6CC 0x802AA6CC : AT(0x000AB2CC) { build/asm/data/main_802AA6CC.bin.o(.data); }
    .main_802ABCBC 0x802ABCBC : AT(0x000AC8BC) { FILL(0x00000000); build/asm/main_802ABCBC.s.o(.text); build/asm/main_802ABCBC.s.o(.rodata); build/asm/main_802ABCBC.s.o(.data); }
    .main_802ABCBC_bss (NOLOAD) : { build/asm/main_802ABCBC.s.o(.bss); }
    .main_802ABCF4 0x802ABCF4 : AT(0x000AC8F4) { build/asm/data/main_802ABCF4.bin.o(.data); }
    .main_802ACEF0 0x802ACEF0 : AT(0x000ADAF0) { FILL(0x00000000); build/asm/main_802ACEF0.s.o(.text); build/asm/main_802ACEF0.s.o(.rodata); build/asm/main_802ACEF0.s.o(.data); }
    .main_802ACEF0_bss (NOLOAD) : { build/asm/main_802ACEF0.s.o(.bss); }
    .main_802ACF3C 0x802ACF3C : AT(0x000ADB3C) { build/asm/data/main_802ACF3C.bin.o(.data); }
    .main_802AE630 0x802AE630 : AT(0x000AF230) { FILL(0x00000000); build/asm/main_802AE630.s.o(.text); build/asm/main_802AE630.s.o(.rodata); build/asm/main_802AE630.s.o(.data); }
    .main_802AE630_bss (NOLOAD) : { build/asm/main_802AE630.s.o(.bss); }
    .main_802AE6D4 0x802AE6D4 : AT(0x000AF2D4) { build/asm/data/main_802AE6D4.bin.o(.data); }
    .main_802AE704 0x802AE704 : AT(0x000AF304) { FILL(0x00000000); build/asm/main_802AE704.s.o(.text); build/asm/main_802AE704.s.o(.rodata); build/asm/main_802AE704.s.o(.data); }
    .main_802AE704_bss (NOLOAD) : { build/asm/main_802AE704.s.o(.bss); }
    .main_802AE728 0x802AE728 : AT(0x000AF328) { build/asm/data/main_802AE728.bin.o(.data); }
    .main_802AEB08 0x802AEB08 : AT(0x000AF708) { FILL(0x00000000); build/asm/main_802AEB08.s.o(.text); build/asm/main_802AEB08.s.o(.rodata); build/asm/main_802AEB08.s.o(.data); }
    .main_802AEB08_bss (NOLOAD) : { build/asm/main_802AEB08.s.o(.bss); }
    .main_802AEB1C 0x802AEB1C : AT(0x000AF71C) { build/asm/data/main_802AEB1C.bin.o(.data); }
    .main_802AF02C 0x802AF02C : AT(0x000AFC2C) { FILL(0x00000000); build/asm/main_802AF02C.s.o(.text); build/asm/main_802AF02C.s.o(.rodata); build/asm/main_802AF02C.s.o(.data); }
    .main_802AF02C_bss (NOLOAD) : { build/asm/main_802AF02C.s.o(.bss); }
    .main_802AF040 0x802AF040 : AT(0x000AFC40) { build/asm/data/main_802AF040.bin.o(.data); }
    .main_802B0AA4 0x802B0AA4 : AT(0x000B16A4) { FILL(0x00000000); build/asm/main_802B0AA4.s.o(.text); build/asm/main_802B0AA4.s.o(.rodata); build/asm/main_802B0AA4.s.o(.data); }
    .main_802B0AA4_bss (NOLOAD) : { build/asm/main_802B0AA4.s.o(.bss); }
    .main_802B0AE8 0x802B0AE8 : AT(0x000B16E8) { build/asm/data/main_802B0AE8.bin.o(.data); }
    .main_802B24B4 0x802B24B4 : AT(0x000B30B4) { FILL(0x00000000); build/asm/main_802B24B4.s.o(.text); build/asm/main_802B24B4.s.o(.rodata); build/asm/main_802B24B4.s.o(.data); }
    .main_802B24B4_bss (NOLOAD) : { build/asm/main_802B24B4.s.o(.bss); }
    .main_802B252C 0x802B252C : AT(0x000B312C) { build/asm/data/main_802B252C.bin.o(.data); }
    .main_802B26B0 0x802B26B0 : AT(0x000B32B0) { FILL(0x00000000); build/asm/main_802B26B0.s.o(.text); build/asm/main_802B26B0.s.o(.rodata); build/asm/main_802B26B0.s.o(.data); }
    .main_802B26B0_bss (NOLOAD) : { build/asm/main_802B26B0.s.o(.bss); }
    .main_802B26D4 0x802B26D4 : AT(0x000B32D4) { build/asm/data/main_802B26D4.bin.o(.data); }
    .main_802B2ACC 0x802B2ACC : AT(0x000B36CC) { FILL(0x00000000); build/asm/main_802B2ACC.s.o(.text); build/asm/main_802B2ACC.s.o(.rodata); build/asm/main_802B2ACC.s.o(.data); }
    .main_802B2ACC_bss (NOLOAD) : { build/asm/main_802B2ACC.s.o(.bss); }
    .main_802B2B14 0x802B2B14 : AT(0x000B3714) { build/asm/data/main_802B2B14.bin.o(.data); }
    .main_802B2B98 0x802B2B98 : AT(0x000B3798) { FILL(0x00000000); build/asm/main_802B2B98.s.o(.text); build/asm/main_802B2B98.s.o(.rodata); build/asm/main_802B2B98.s.o(.data); }
    .main_802B2B98_bss (NOLOAD) : { build/asm/main_802B2B98.s.o(.bss); }
    .main_802B2C50 0x802B2C50 : AT(0x000B3850) { build/asm/data/main_802B2C50.bin.o(.data); }
    .main_802B4F4C 0x802B4F4C : AT(0x000B5B4C) { FILL(0x00000000); build/asm/main_802B4F4C.s.o(.text); build/asm/main_802B4F4C.s.o(.rodata); build/asm/main_802B4F4C.s.o(.data); }
    .main_802B4F4C_bss (NOLOAD) : { build/asm/main_802B4F4C.s.o(.bss); }
    .main_802B4F70 0x802B4F70 : AT(0x000B5B70) { build/asm/data/main_802B4F70.bin.o(.data); }
    .main_802B5080 0x802B5080 : AT(0x000B5C80) { FILL(0x00000000); build/asm/main_802B5080.s.o(.text); build/asm/main_802B5080.s.o(.rodata); build/asm/main_802B5080.s.o(.data); }
    .main_802B5080_bss (NOLOAD) : { build/asm/main_802B5080.s.o(.bss); }
    .main_802B50F0 0x802B50F0 : AT(0x000B5CF0) { build/asm/data/main_802B50F0.bin.o(.data); }
    .main_802B54F4 0x802B54F4 : AT(0x000B60F4) { FILL(0x00000000); build/asm/main_802B54F4.s.o(.text); build/asm/main_802B54F4.s.o(.rodata); build/asm/main_802B54F4.s.o(.data); }
    .main_802B54F4_bss (NOLOAD) : { build/asm/main_802B54F4.s.o(.bss); }
    .main_802B5524 0x802B5524 : AT(0x000B6124) { build/asm/data/main_802B5524.bin.o(.data); }
    .main_802B5CCC 0x802B5CCC : AT(0x000B68CC) { FILL(0x00000000); build/asm/main_802B5CCC.s.o(.text); build/asm/main_802B5CCC.s.o(.rodata); build/asm/main_802B5CCC.s.o(.data); }
    .main_802B5CCC_bss (NOLOAD) : { build/asm/main_802B5CCC.s.o(.bss); }
    .main_802B5CE8 0x802B5CE8 : AT(0x000B68E8) { build/asm/data/main_802B5CE8.bin.o(.data); }
    .main_802B68F0 0x802B68F0 : AT(0x000B74F0) { FILL(0x00000000); build/asm/main_802B68F0.s.o(.text); build/asm/main_802B68F0.s.o(.rodata); build/asm/main_802B68F0.s.o(.data); }
    .main_802B68F0_bss (NOLOAD) : { build/asm/main_802B68F0.s.o(.bss); }
    .main_802B68F8 0x802B68F8 : AT(0x000B74F8) { build/asm/data/main_802B68F8.bin.o(.data); }
    .main_802B924C 0x802B924C : AT(0x000B9E4C) { FILL(0x00000000); build/asm/main_802B924C.s.o(.text); build/asm/main_802B924C.s.o(.rodata); build/asm/main_802B924C.s.o(.data); }
    .main_802B924C_bss (NOLOAD) : { build/asm/main_802B924C.s.o(.bss); }
    .main_802B9260 0x802B9260 : AT(0x000B9E60) { build/asm/data/main_802B9260.bin.o(.data); }
    .main_802B9EA4 0x802B9EA4 : AT(0x000BAAA4) { FILL(0x00000000); build/asm/main_802B9EA4.s.o(.text); build/asm/main_802B9EA4.s.o(.rodata); build/asm/main_802B9EA4.s.o(.data); }
    .main_802B9EA4_bss (NOLOAD) : { build/asm/main_802B9EA4.s.o(.bss); }
    .main_802B9ED4 0x802B9ED4 : AT(0x000BAAD4) { build/asm/data/main_802B9ED4.bin.o(.data); }
    .main_802BA2A8 0x802BA2A8 : AT(0x000BAEA8) { FILL(0x00000000); build/asm/main_802BA2A8.s.o(.text); build/asm/main_802BA2A8.s.o(.rodata); build/asm/main_802BA2A8.s.o(.data); }
    .main_802BA2A8_bss (NOLOAD) : { build/asm/main_802BA2A8.s.o(.bss); }
    .main_802BA2AC 0x802BA2AC : AT(0x000BAEAC) { build/asm/data/main_802BA2AC.bin.o(.data); }
    .main_802BC6FC 0x802BC6FC : AT(0x000BD2FC) { FILL(0x00000000); build/asm/main_802BC6FC.s.o(.text); build/asm/main_802BC6FC.s.o(.rodata); build/asm/main_802BC6FC.s.o(.data); }
    .main_802BC6FC_bss (NOLOAD) : { build/asm/main_802BC6FC.s.o(.bss); }
    .main_802BC72C 0x802BC72C : AT(0x000BD32C) { build/asm/data/main_802BC72C.bin.o(.data); }
    .main_802C5FF4 0x802C5FF4 : AT(0x000C6BF4) { FILL(0x00000000); build/asm/main_802C5FF4.s.o(.text); build/asm/main_802C5FF4.s.o(.rodata); build/asm/main_802C5FF4.s.o(.data); }
    .main_802C5FF4_bss (NOLOAD) : { build/asm/main_802C5FF4.s.o(.bss); }
    .main_802C600C 0x802C600C : AT(0x000C6C0C) { build/asm/data/main_802C600C.bin.o(.data); }
    .main_802C6E84 0x802C6E84 : AT(0x000C7A84) { FILL(0x00000000); build/asm/main_802C6E84.s.o(.text); build/asm/main_802C6E84.s.o(.rodata); build/asm/main_802C6E84.s.o(.data); }
    .main_802C6E84_bss (NOLOAD) : { build/asm/main_802C6E84.s.o(.bss); }
    .main_802C6EC0 0x802C6EC0 : AT(0x000C7AC0) { build/asm/data/main_802C6EC0.bin.o(.data); }
    .main_802C82C8 0x802C82C8 : AT(0x000C8EC8) { FILL(0x00000000); build/asm/main_802C82C8.s.o(.text); build/asm/main_802C82C8.s.o(.rodata); build/asm/main_802C82C8.s.o(.data); }
    .main_802C82C8_bss (NOLOAD) : { build/asm/main_802C82C8.s.o(.bss); }
    .main_802C82D8 0x802C82D8 : AT(0x000C8ED8) { build/asm/data/main_802C82D8.bin.o(.data); }
    .main_802C9720 0x802C9720 : AT(0x000CA320) { FILL(0x00000000); build/asm/main_802C9720.s.o(.text); build/asm/main_802C9720.s.o(.rodata); build/asm/main_802C9720.s.o(.data); }
    .main_802C9720_bss (NOLOAD) : { build/asm/main_802C9720.s.o(.bss); }
    .main_802C9764 0x802C9764 : AT(0x000CA364) { build/asm/data/main_802C9764.bin.o(.data); }
    .main_802C9960 0x802C9960 : AT(0x000CA560) { FILL(0x00000000); build/asm/main_802C9960.s.o(.text); build/asm/main_802C9960.s.o(.rodata); build/asm/main_802C9960.s.o(.data); }
    .main_802C9960_bss (NOLOAD) : { build/asm/main_802C9960.s.o(.bss); }
    .main_802C9968 0x802C9968 : AT(0x000CA568) { build/asm/data/main_802C9968.bin.o(.data); }
    .main_802CA5E4 0x802CA5E4 : AT(0x000CB1E4) { FILL(0x00000000); build/asm/main_802CA5E4.s.o(.text); build/asm/main_802CA5E4.s.o(.rodata); build/asm/main_802CA5E4.s.o(.data); }
    .main_802CA5E4_bss (NOLOAD) : { build/asm/main_802CA5E4.s.o(.bss); }
    .main_802CA614 0x802CA614 : AT(0x000CB214) { build/asm/data/main_802CA614.bin.o(.data); }
    .main_802CBDC8 0x802CBDC8 : AT(0x000CC9C8) { FILL(0x00000000); build/asm/main_802CBDC8.s.o(.text); build/asm/main_802CBDC8.s.o(.rodata); build/asm/main_802CBDC8.s.o(.data); }
    .main_802CBDC8_bss (NOLOAD) : { build/asm/main_802CBDC8.s.o(.bss); }
    .main_802CBDCC 0x802CBDCC : AT(0x000CC9CC) { build/asm/data/main_802CBDCC.bin.o(.data); }
    .main_802CC388 0x802CC388 : AT(0x000CCF88) { FILL(0x00000000); build/asm/main_802CC388.s.o(.text); build/asm/main_802CC388.s.o(.rodata); build/asm/main_802CC388.s.o(.data); }
    .main_802CC388_bss (NOLOAD) : { build/asm/main_802CC388.s.o(.bss); }
    .main_802CC40C 0x802CC40C : AT(0x000CD00C) { build/asm/data/main_802CC40C.bin.o(.data); }
    .main_802CCE90 0x802CCE90 : AT(0x000CDA90) { FILL(0x00000000); build/asm/main_802CCE90.s.o(.text); build/asm/main_802CCE90.s.o(.rodata); build/asm/main_802CCE90.s.o(.data); }
    .main_802CCE90_bss (NOLOAD) : { build/asm/main_802CCE90.s.o(.bss); }
    .main_802CCE94 0x802CCE94 : AT(0x000CDA94) { build/asm/data/main_802CCE94.bin.o(.data); }
    .main_802CD508 0x802CD508 : AT(0x000CE108) { FILL(0x00000000); build/asm/main_802CD508.s.o(.text); build/asm/main_802CD508.s.o(.rodata); build/asm/main_802CD508.s.o(.data); }
    .main_802CD508_bss (NOLOAD) : { build/asm/main_802CD508.s.o(.bss); }
    .main_802CD518 0x802CD518 : AT(0x000CE118) { build/asm/data/main_802CD518.bin.o(.data); }
    .main_802D2214 0x802D2214 : AT(0x000D2E14) { FILL(0x00000000); build/asm/main_802D2214.s.o(.text); build/asm/main_802D2214.s.o(.rodata); build/asm/main_802D2214.s.o(.data); }
    .main_802D2214_bss (NOLOAD) : { build/asm/main_802D2214.s.o(.bss); }
    .main_802D2224 0x802D2224 : AT(0x000D2E24) { build/asm/data/main_802D2224.bin.o(.data); }
    .main_802D2B44 0x802D2B44 : AT(0x000D3744) { FILL(0x00000000); build/asm/main_802D2B44.s.o(.text); build/asm/main_802D2B44.s.o(.rodata); build/asm/main_802D2B44.s.o(.data); }
    .main_802D2B44_bss (NOLOAD) : { build/asm/main_802D2B44.s.o(.bss); }
    .main_802D2BD8 0x802D2BD8 : AT(0x000D37D8) { build/asm/data/main_802D2BD8.bin.o(.data); }
    .main_802D4EBC 0x802D4EBC : AT(0x000D5ABC) { FILL(0x00000000); build/asm/main_802D4EBC.s.o(.text); build/asm/main_802D4EBC.s.o(.rodata); build/asm/main_802D4EBC.s.o(.data); }
    .main_802D4EBC_bss (NOLOAD) : { build/asm/main_802D4EBC.s.o(.bss); }
    .main_802D4F00 0x802D4F00 : AT(0x000D5B00) { build/asm/data/main_802D4F00.bin.o(.data); }
    .main_802D5F40 0x802D5F40 : AT(0x000D6B40) { FILL(0x00000000); build/asm/main_802D5F40.s.o(.text); build/asm/main_802D5F40.s.o(.rodata); build/asm/main_802D5F40.s.o(.data); }
    .main_802D5F40_bss (NOLOAD) : { build/asm/main_802D5F40.s.o(.bss); }
    .main_802D5F54 0x802D5F54 : AT(0x000D6B54) { build/asm/data/main_802D5F54.bin.o(.data); }
    .main_802D6574 0x802D6574 : AT(0x000D7174) { FILL(0x00000000); build/asm/main_802D6574.s.o(.text); build/asm/main_802D6574.s.o(.rodata); build/asm/main_802D6574.s.o(.data); }
    .main_802D6574_bss (NOLOAD) : { build/asm/main_802D6574.s.o(.bss); }
    .main_802D6580 0x802D6580 : AT(0x000D7180) { build/asm/data/main_802D6580.bin.o(.data); }
    .main_802D85B0 0x802D85B0 : AT(0x000D91B0) { FILL(0x00000000); build/asm/main_802D85B0.s.o(.text); build/asm/main_802D85B0.s.o(.rodata); build/asm/main_802D85B0.s.o(.data); }
    .main_802D85B0_bss (NOLOAD) : { build/asm/main_802D85B0.s.o(.bss); }
    .main_802D8600 0x802D8600 : AT(0x000D9200) { build/asm/data/main_802D8600.bin.o(.data); }
    .main_802DB274 0x802DB274 : AT(0x000DBE74) { FILL(0x00000000); build/asm/main_802DB274.s.o(.text); build/asm/main_802DB274.s.o(.rodata); build/asm/main_802DB274.s.o(.data); }
    .main_802DB274_bss (NOLOAD) : { build/asm/main_802DB274.s.o(.bss); }
    .main_802DB278 0x802DB278 : AT(0x000DBE78) { build/asm/data/main_802DB278.bin.o(.data); }
    .main_802DB388 0x802DB388 : AT(0x000DBF88) { FILL(0x00000000); build/asm/main_802DB388.s.o(.text); build/asm/main_802DB388.s.o(.rodata); build/asm/main_802DB388.s.o(.data); }
    .main_802DB388_bss (NOLOAD) : { build/asm/main_802DB388.s.o(.bss); }
    .main_802DB39C 0x802DB39C : AT(0x000DBF9C) { build/asm/data/main_802DB39C.bin.o(.data); }
    .main_802DB880 0x802DB880 : AT(0x000DC480) { FILL(0x00000000); build/asm/main_802DB880.s.o(.text); build/asm/main_802DB880.s.o(.rodata); build/asm/main_802DB880.s.o(.data); }
    .main_802DB880_bss (NOLOAD) : { build/asm/main_802DB880.s.o(.bss); }
    .main_802DB898 0x802DB898 : AT(0x000DC498) { build/asm/data/main_802DB898.bin.o(.data); }
    .main_802DC290 0x802DC290 : AT(0x000DCE90) { FILL(0x00000000); build/asm/main_802DC290.s.o(.text); build/asm/main_802DC290.s.o(.rodata); build/asm/main_802DC290.s.o(.data); }
    .main_802DC290_bss (NOLOAD) : { build/asm/main_802DC290.s.o(.bss); }
    .main_802DC2A4 0x802DC2A4 : AT(0x000DCEA4) { build/asm/data/main_802DC2A4.bin.o(.data); }
    .main_802DD7DC 0x802DD7DC : AT(0x000DE3DC) { FILL(0x00000000); build/asm/main_802DD7DC.s.o(.text); build/asm/main_802DD7DC.s.o(.rodata); build/asm/main_802DD7DC.s.o(.data); }
    .main_802DD7DC_bss (NOLOAD) : { build/asm/main_802DD7DC.s.o(.bss); }
    .main_802DD808 0x802DD808 : AT(0x000DE408) { build/asm/data/main_802DD808.bin.o(.data); }
    .main_802E11CC 0x802E11CC : AT(0x000E1DCC) { FILL(0x00000000); build/asm/main_802E11CC.s.o(.text); build/asm/main_802E11CC.s.o(.rodata); build/asm/main_802E11CC.s.o(.data); }
    .main_802E11CC_bss (NOLOAD) : { build/asm/main_802E11CC.s.o(.bss); }
    .main_802E120C 0x802E120C : AT(0x000E1E0C) { build/asm/data/main_802E120C.bin.o(.data); }
    .main_802E26F4 0x802E26F4 : AT(0x000E32F4) { FILL(0x00000000); build/asm/main_802E26F4.s.o(.text); build/asm/main_802E26F4.s.o(.rodata); build/asm/main_802E26F4.s.o(.data); }
    .main_802E26F4_bss (NOLOAD) : { build/asm/main_802E26F4.s.o(.bss); }
    .main_802E2774 0x802E2774 : AT(0x000E3374) { build/asm/data/main_802E2774.bin.o(.data); }
    .main_802E59A8 0x802E59A8 : AT(0x000E65A8) { FILL(0x00000000); build/asm/main_802E59A8.s.o(.text); build/asm/main_802E59A8.s.o(.rodata); build/asm/main_802E59A8.s.o(.data); }
    .main_802E59A8_bss (NOLOAD) : { build/asm/main_802E59A8.s.o(.bss); }
    .main_802E59C8 0x802E59C8 : AT(0x000E65C8) { build/asm/data/main_802E59C8.bin.o(.data); }
    .main_802E810C 0x802E810C : AT(0x000E8D0C) { FILL(0x00000000); build/asm/main_802E810C.s.o(.text); build/asm/main_802E810C.s.o(.rodata); build/asm/main_802E810C.s.o(.data); }
    .main_802E810C_bss (NOLOAD) : { build/asm/main_802E810C.s.o(.bss); }
    .main_802E8118 0x802E8118 : AT(0x000E8D18) { build/asm/data/main_802E8118.bin.o(.data); }
    .main_802E8BF4 0x802E8BF4 : AT(0x000E97F4) { FILL(0x00000000); build/asm/main_802E8BF4.s.o(.text); build/asm/main_802E8BF4.s.o(.rodata); build/asm/main_802E8BF4.s.o(.data); }
    .main_802E8BF4_bss (NOLOAD) : { build/asm/main_802E8BF4.s.o(.bss); }
    .main_802E8C04 0x802E8C04 : AT(0x000E9804) { build/asm/data/main_802E8C04.bin.o(.data); }
    .main_802EBFA8 0x802EBFA8 : AT(0x000ECBA8) { FILL(0x00000000); build/asm/main_802EBFA8.s.o(.text); build/asm/main_802EBFA8.s.o(.rodata); build/asm/main_802EBFA8.s.o(.data); }
    .main_802EBFA8_bss (NOLOAD) : { build/asm/main_802EBFA8.s.o(.bss); }
    .main_802EBFE4 0x802EBFE4 : AT(0x000ECBE4) { build/asm/data/main_802EBFE4.bin.o(.data); }
    .main_802EF274 0x802EF274 : AT(0x000EFE74) { FILL(0x00000000); build/asm/main_802EF274.s.o(.text); build/asm/main_802EF274.s.o(.rodata); build/asm/main_802EF274.s.o(.data); }
    .main_802EF274_bss (NOLOAD) : { build/asm/main_802EF274.s.o(.bss); }
    .main_802EF284 0x802EF284 : AT(0x000EFE84) { build/asm/data/main_802EF284.bin.o(.data); }
    .main_802F0BD4 0x802F0BD4 : AT(0x000F17D4) { FILL(0x00000000); build/asm/main_802F0BD4.s.o(.text); build/asm/main_802F0BD4.s.o(.rodata); build/asm/main_802F0BD4.s.o(.data); }
    .main_802F0BD4_bss (NOLOAD) : { build/asm/main_802F0BD4.s.o(.bss); }
    .main_802F0C54 0x802F0C54 : AT(0x000F1854) { build/asm/data/main_802F0C54.bin.o(.data); }
    .main_802F3F1C 0x802F3F1C : AT(0x000F4B1C) { FILL(0x00000000); build/asm/main_802F3F1C.s.o(.text); build/asm/main_802F3F1C.s.o(.rodata); build/asm/main_802F3F1C.s.o(.data); }
    .main_802F3F1C_bss (NOLOAD) : { build/asm/main_802F3F1C.s.o(.bss); }
    .main_802F3F8C 0x802F3F8C : AT(0x000F4B8C) { build/asm/data/main_802F3F8C.bin.o(.data); }
    .main_802F80F8 0x802F80F8 : AT(0x000F8CF8) { FILL(0x00000000); build/asm/main_802F80F8.s.o(.text); build/asm/main_802F80F8.s.o(.rodata); build/asm/main_802F80F8.s.o(.data); }
    .main_802F80F8_bss (NOLOAD) : { build/asm/main_802F80F8.s.o(.bss); }
    .main_802F8188 0x802F8188 : AT(0x000F8D88) { build/asm/data/main_802F8188.bin.o(.data); }
    .main_802FA280 0x802FA280 : AT(0x000FAE80) { FILL(0x00000000); build/asm/main_802FA280.s.o(.text); build/asm/main_802FA280.s.o(.rodata); build/asm/main_802FA280.s.o(.data); }
    .main_802FA280_bss (NOLOAD) : { build/asm/main_802FA280.s.o(.bss); }
    .main_802FA28C 0x802FA28C : AT(0x000FAE8C) { build/asm/data/main_802FA28C.bin.o(.data); }
    .main_802FC044 0x802FC044 : AT(0x000FCC44) { FILL(0x00000000); build/asm/main_802FC044.s.o(.text); build/asm/main_802FC044.s.o(.rodata); build/asm/main_802FC044.s.o(.data); }
    .main_802FC044_bss (NOLOAD) : { build/asm/main_802FC044.s.o(.bss); }
    .main_802FC048 0x802FC048 : AT(0x000FCC48) { build/asm/data/main_802FC048.bin.o(.data); }
    .main_802FC0C0 0x802FC0C0 : AT(0x000FCCC0) { FILL(0x00000000); build/asm/main_802FC0C0.s.o(.text); build/asm/main_802FC0C0.s.o(.rodata); build/asm/main_802FC0C0.s.o(.data); }
    .main_802FC0C0_bss (NOLOAD) : { build/asm/main_802FC0C0.s.o(.bss); }
    .main_802FC0C8 0x802FC0C8 : AT(0x000FCCC8) { build/asm/data/main_802FC0C8.bin.o(.data); }
    .main_802FD2B8 0x802FD2B8 : AT(0x000FDEB8) { FILL(0x00000000); build/asm/main_802FD2B8.s.o(.text); build/asm/main_802FD2B8.s.o(.rodata); build/asm/main_802FD2B8.s.o(.data); }
    .main_802FD2B8_bss (NOLOAD) : { build/asm/main_802FD2B8.s.o(.bss); }
    .main_802FD358 0x802FD358 : AT(0x000FDF58) { build/asm/data/main_802FD358.bin.o(.data); }
    .main_802FEF2C 0x802FEF2C : AT(0x000FFB2C) { FILL(0x00000000); build/asm/main_802FEF2C.s.o(.text); build/asm/main_802FEF2C.s.o(.rodata); build/asm/main_802FEF2C.s.o(.data); }
    .main_802FEF2C_bss (NOLOAD) : { build/asm/main_802FEF2C.s.o(.bss); }
    .main_802FEF40 0x802FEF40 : AT(0x000FFB40) { build/asm/data/main_802FEF40.bin.o(.data); }
    .assets 0x80600400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
