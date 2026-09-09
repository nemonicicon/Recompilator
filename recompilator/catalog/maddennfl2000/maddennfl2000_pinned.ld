SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80200400 0x80200400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80200400.s.o(.text); build/asm/main_80200400.s.o(.rodata); build/asm/main_80200400.s.o(.data); }
    .main_80200400_bss (NOLOAD) : { build/asm/main_80200400.s.o(.bss); }
    .main_80200E00 0x80200E00 : AT(0x00001A00) { build/asm/data/main_80200E00.bin.o(.data); }
    .main_80201340 0x80201340 : AT(0x00001F40) { FILL(0x00000000); build/asm/main_80201340.s.o(.text); build/asm/main_80201340.s.o(.rodata); build/asm/main_80201340.s.o(.data); }
    .main_80201340_bss (NOLOAD) : { build/asm/main_80201340.s.o(.bss); }
    .main_80201354 0x80201354 : AT(0x00001F54) { build/asm/data/main_80201354.bin.o(.data); }
    .main_80202B14 0x80202B14 : AT(0x00003714) { FILL(0x00000000); build/asm/main_80202B14.s.o(.text); build/asm/main_80202B14.s.o(.rodata); build/asm/main_80202B14.s.o(.data); }
    .main_80202B14_bss (NOLOAD) : { build/asm/main_80202B14.s.o(.bss); }
    .main_80202B20 0x80202B20 : AT(0x00003720) { build/asm/data/main_80202B20.bin.o(.data); }
    .main_80203B7C 0x80203B7C : AT(0x0000477C) { FILL(0x00000000); build/asm/main_80203B7C.s.o(.text); build/asm/main_80203B7C.s.o(.rodata); build/asm/main_80203B7C.s.o(.data); }
    .main_80203B7C_bss (NOLOAD) : { build/asm/main_80203B7C.s.o(.bss); }
    .main_80203BBC 0x80203BBC : AT(0x000047BC) { build/asm/data/main_80203BBC.bin.o(.data); }
    .main_80204CBC 0x80204CBC : AT(0x000058BC) { FILL(0x00000000); build/asm/main_80204CBC.s.o(.text); build/asm/main_80204CBC.s.o(.rodata); build/asm/main_80204CBC.s.o(.data); }
    .main_80204CBC_bss (NOLOAD) : { build/asm/main_80204CBC.s.o(.bss); }
    .main_80204D08 0x80204D08 : AT(0x00005908) { build/asm/data/main_80204D08.bin.o(.data); }
    .main_80205EC8 0x80205EC8 : AT(0x00006AC8) { FILL(0x00000000); build/asm/main_80205EC8.s.o(.text); build/asm/main_80205EC8.s.o(.rodata); build/asm/main_80205EC8.s.o(.data); }
    .main_80205EC8_bss (NOLOAD) : { build/asm/main_80205EC8.s.o(.bss); }
    .main_80205EE8 0x80205EE8 : AT(0x00006AE8) { build/asm/data/main_80205EE8.bin.o(.data); }
    .main_802084D0 0x802084D0 : AT(0x000090D0) { FILL(0x00000000); build/asm/main_802084D0.s.o(.text); build/asm/main_802084D0.s.o(.rodata); build/asm/main_802084D0.s.o(.data); }
    .main_802084D0_bss (NOLOAD) : { build/asm/main_802084D0.s.o(.bss); }
    .main_802084E8 0x802084E8 : AT(0x000090E8) { build/asm/data/main_802084E8.bin.o(.data); }
    .main_802090C8 0x802090C8 : AT(0x00009CC8) { FILL(0x00000000); build/asm/main_802090C8.s.o(.text); build/asm/main_802090C8.s.o(.rodata); build/asm/main_802090C8.s.o(.data); }
    .main_802090C8_bss (NOLOAD) : { build/asm/main_802090C8.s.o(.bss); }
    .main_80209124 0x80209124 : AT(0x00009D24) { build/asm/data/main_80209124.bin.o(.data); }
    .main_8020BAF4 0x8020BAF4 : AT(0x0000C6F4) { FILL(0x00000000); build/asm/main_8020BAF4.s.o(.text); build/asm/main_8020BAF4.s.o(.rodata); build/asm/main_8020BAF4.s.o(.data); }
    .main_8020BAF4_bss (NOLOAD) : { build/asm/main_8020BAF4.s.o(.bss); }
    .main_8020BBCC 0x8020BBCC : AT(0x0000C7CC) { build/asm/data/main_8020BBCC.bin.o(.data); }
    .main_8020C5B4 0x8020C5B4 : AT(0x0000D1B4) { FILL(0x00000000); build/asm/main_8020C5B4.s.o(.text); build/asm/main_8020C5B4.s.o(.rodata); build/asm/main_8020C5B4.s.o(.data); }
    .main_8020C5B4_bss (NOLOAD) : { build/asm/main_8020C5B4.s.o(.bss); }
    .main_8020C608 0x8020C608 : AT(0x0000D208) { build/asm/data/main_8020C608.bin.o(.data); }
    .main_8020E670 0x8020E670 : AT(0x0000F270) { FILL(0x00000000); build/asm/main_8020E670.s.o(.text); build/asm/main_8020E670.s.o(.rodata); build/asm/main_8020E670.s.o(.data); }
    .main_8020E670_bss (NOLOAD) : { build/asm/main_8020E670.s.o(.bss); }
    .main_8020E680 0x8020E680 : AT(0x0000F280) { build/asm/data/main_8020E680.bin.o(.data); }
    .main_8020EDF4 0x8020EDF4 : AT(0x0000F9F4) { FILL(0x00000000); build/asm/main_8020EDF4.s.o(.text); build/asm/main_8020EDF4.s.o(.rodata); build/asm/main_8020EDF4.s.o(.data); }
    .main_8020EDF4_bss (NOLOAD) : { build/asm/main_8020EDF4.s.o(.bss); }
    .main_8020EDF8 0x8020EDF8 : AT(0x0000F9F8) { build/asm/data/main_8020EDF8.bin.o(.data); }
    .main_8020EE40 0x8020EE40 : AT(0x0000FA40) { FILL(0x00000000); build/asm/main_8020EE40.s.o(.text); build/asm/main_8020EE40.s.o(.rodata); build/asm/main_8020EE40.s.o(.data); }
    .main_8020EE40_bss (NOLOAD) : { build/asm/main_8020EE40.s.o(.bss); }
    .main_8020EE54 0x8020EE54 : AT(0x0000FA54) { build/asm/data/main_8020EE54.bin.o(.data); }
    .main_8020F7E8 0x8020F7E8 : AT(0x000103E8) { FILL(0x00000000); build/asm/main_8020F7E8.s.o(.text); build/asm/main_8020F7E8.s.o(.rodata); build/asm/main_8020F7E8.s.o(.data); }
    .main_8020F7E8_bss (NOLOAD) : { build/asm/main_8020F7E8.s.o(.bss); }
    .main_8020F8B4 0x8020F8B4 : AT(0x000104B4) { build/asm/data/main_8020F8B4.bin.o(.data); }
    .main_8021028C 0x8021028C : AT(0x00010E8C) { FILL(0x00000000); build/asm/main_8021028C.s.o(.text); build/asm/main_8021028C.s.o(.rodata); build/asm/main_8021028C.s.o(.data); }
    .main_8021028C_bss (NOLOAD) : { build/asm/main_8021028C.s.o(.bss); }
    .main_80210294 0x80210294 : AT(0x00010E94) { build/asm/data/main_80210294.bin.o(.data); }
    .main_80212A20 0x80212A20 : AT(0x00013620) { FILL(0x00000000); build/asm/main_80212A20.s.o(.text); build/asm/main_80212A20.s.o(.rodata); build/asm/main_80212A20.s.o(.data); }
    .main_80212A20_bss (NOLOAD) : { build/asm/main_80212A20.s.o(.bss); }
    .main_80212A28 0x80212A28 : AT(0x00013628) { build/asm/data/main_80212A28.bin.o(.data); }
    .main_802156D8 0x802156D8 : AT(0x000162D8) { FILL(0x00000000); build/asm/main_802156D8.s.o(.text); build/asm/main_802156D8.s.o(.rodata); build/asm/main_802156D8.s.o(.data); }
    .main_802156D8_bss (NOLOAD) : { build/asm/main_802156D8.s.o(.bss); }
    .main_80215780 0x80215780 : AT(0x00016380) { build/asm/data/main_80215780.bin.o(.data); }
    .main_80217D9C 0x80217D9C : AT(0x0001899C) { FILL(0x00000000); build/asm/main_80217D9C.s.o(.text); build/asm/main_80217D9C.s.o(.rodata); build/asm/main_80217D9C.s.o(.data); }
    .main_80217D9C_bss (NOLOAD) : { build/asm/main_80217D9C.s.o(.bss); }
    .main_80217E24 0x80217E24 : AT(0x00018A24) { build/asm/data/main_80217E24.bin.o(.data); }
    .main_80218E04 0x80218E04 : AT(0x00019A04) { FILL(0x00000000); build/asm/main_80218E04.s.o(.text); build/asm/main_80218E04.s.o(.rodata); build/asm/main_80218E04.s.o(.data); }
    .main_80218E04_bss (NOLOAD) : { build/asm/main_80218E04.s.o(.bss); }
    .main_80218E90 0x80218E90 : AT(0x00019A90) { build/asm/data/main_80218E90.bin.o(.data); }
    .main_80219778 0x80219778 : AT(0x0001A378) { FILL(0x00000000); build/asm/main_80219778.s.o(.text); build/asm/main_80219778.s.o(.rodata); build/asm/main_80219778.s.o(.data); }
    .main_80219778_bss (NOLOAD) : { build/asm/main_80219778.s.o(.bss); }
    .main_802197A8 0x802197A8 : AT(0x0001A3A8) { build/asm/data/main_802197A8.bin.o(.data); }
    .main_8021B398 0x8021B398 : AT(0x0001BF98) { FILL(0x00000000); build/asm/main_8021B398.s.o(.text); build/asm/main_8021B398.s.o(.rodata); build/asm/main_8021B398.s.o(.data); }
    .main_8021B398_bss (NOLOAD) : { build/asm/main_8021B398.s.o(.bss); }
    .main_8021B3B4 0x8021B3B4 : AT(0x0001BFB4) { build/asm/data/main_8021B3B4.bin.o(.data); }
    .main_8021DC64 0x8021DC64 : AT(0x0001E864) { FILL(0x00000000); build/asm/main_8021DC64.s.o(.text); build/asm/main_8021DC64.s.o(.rodata); build/asm/main_8021DC64.s.o(.data); }
    .main_8021DC64_bss (NOLOAD) : { build/asm/main_8021DC64.s.o(.bss); }
    .main_8021DCE4 0x8021DCE4 : AT(0x0001E8E4) { build/asm/data/main_8021DCE4.bin.o(.data); }
    .main_8021DFEC 0x8021DFEC : AT(0x0001EBEC) { FILL(0x00000000); build/asm/main_8021DFEC.s.o(.text); build/asm/main_8021DFEC.s.o(.rodata); build/asm/main_8021DFEC.s.o(.data); }
    .main_8021DFEC_bss (NOLOAD) : { build/asm/main_8021DFEC.s.o(.bss); }
    .main_8021DFF0 0x8021DFF0 : AT(0x0001EBF0) { build/asm/data/main_8021DFF0.bin.o(.data); }
    .main_8021F284 0x8021F284 : AT(0x0001FE84) { FILL(0x00000000); build/asm/main_8021F284.s.o(.text); build/asm/main_8021F284.s.o(.rodata); build/asm/main_8021F284.s.o(.data); }
    .main_8021F284_bss (NOLOAD) : { build/asm/main_8021F284.s.o(.bss); }
    .main_8021F298 0x8021F298 : AT(0x0001FE98) { build/asm/data/main_8021F298.bin.o(.data); }
    .main_80222114 0x80222114 : AT(0x00022D14) { FILL(0x00000000); build/asm/main_80222114.s.o(.text); build/asm/main_80222114.s.o(.rodata); build/asm/main_80222114.s.o(.data); }
    .main_80222114_bss (NOLOAD) : { build/asm/main_80222114.s.o(.bss); }
    .main_80222130 0x80222130 : AT(0x00022D30) { build/asm/data/main_80222130.bin.o(.data); }
    .main_80223680 0x80223680 : AT(0x00024280) { FILL(0x00000000); build/asm/main_80223680.s.o(.text); build/asm/main_80223680.s.o(.rodata); build/asm/main_80223680.s.o(.data); }
    .main_80223680_bss (NOLOAD) : { build/asm/main_80223680.s.o(.bss); }
    .main_802236A0 0x802236A0 : AT(0x000242A0) { build/asm/data/main_802236A0.bin.o(.data); }
    .main_802275B8 0x802275B8 : AT(0x000281B8) { FILL(0x00000000); build/asm/main_802275B8.s.o(.text); build/asm/main_802275B8.s.o(.rodata); build/asm/main_802275B8.s.o(.data); }
    .main_802275B8_bss (NOLOAD) : { build/asm/main_802275B8.s.o(.bss); }
    .main_802275C0 0x802275C0 : AT(0x000281C0) { build/asm/data/main_802275C0.bin.o(.data); }
    .main_80227EA4 0x80227EA4 : AT(0x00028AA4) { FILL(0x00000000); build/asm/main_80227EA4.s.o(.text); build/asm/main_80227EA4.s.o(.rodata); build/asm/main_80227EA4.s.o(.data); }
    .main_80227EA4_bss (NOLOAD) : { build/asm/main_80227EA4.s.o(.bss); }
    .main_80227ED0 0x80227ED0 : AT(0x00028AD0) { build/asm/data/main_80227ED0.bin.o(.data); }
    .main_80228298 0x80228298 : AT(0x00028E98) { FILL(0x00000000); build/asm/main_80228298.s.o(.text); build/asm/main_80228298.s.o(.rodata); build/asm/main_80228298.s.o(.data); }
    .main_80228298_bss (NOLOAD) : { build/asm/main_80228298.s.o(.bss); }
    .main_802282C4 0x802282C4 : AT(0x00028EC4) { build/asm/data/main_802282C4.bin.o(.data); }
    .main_802284E8 0x802284E8 : AT(0x000290E8) { FILL(0x00000000); build/asm/main_802284E8.s.o(.text); build/asm/main_802284E8.s.o(.rodata); build/asm/main_802284E8.s.o(.data); }
    .main_802284E8_bss (NOLOAD) : { build/asm/main_802284E8.s.o(.bss); }
    .main_802284FC 0x802284FC : AT(0x000290FC) { build/asm/data/main_802284FC.bin.o(.data); }
    .main_8022E018 0x8022E018 : AT(0x0002EC18) { FILL(0x00000000); build/asm/main_8022E018.s.o(.text); build/asm/main_8022E018.s.o(.rodata); build/asm/main_8022E018.s.o(.data); }
    .main_8022E018_bss (NOLOAD) : { build/asm/main_8022E018.s.o(.bss); }
    .main_8022E02C 0x8022E02C : AT(0x0002EC2C) { build/asm/data/main_8022E02C.bin.o(.data); }
    .main_8022F0BC 0x8022F0BC : AT(0x0002FCBC) { FILL(0x00000000); build/asm/main_8022F0BC.s.o(.text); build/asm/main_8022F0BC.s.o(.rodata); build/asm/main_8022F0BC.s.o(.data); }
    .main_8022F0BC_bss (NOLOAD) : { build/asm/main_8022F0BC.s.o(.bss); }
    .main_8022F0E0 0x8022F0E0 : AT(0x0002FCE0) { build/asm/data/main_8022F0E0.bin.o(.data); }
    .main_8022F590 0x8022F590 : AT(0x00030190) { FILL(0x00000000); build/asm/main_8022F590.s.o(.text); build/asm/main_8022F590.s.o(.rodata); build/asm/main_8022F590.s.o(.data); }
    .main_8022F590_bss (NOLOAD) : { build/asm/main_8022F590.s.o(.bss); }
    .main_8022F62C 0x8022F62C : AT(0x0003022C) { build/asm/data/main_8022F62C.bin.o(.data); }
    .main_80230AE0 0x80230AE0 : AT(0x000316E0) { FILL(0x00000000); build/asm/main_80230AE0.s.o(.text); build/asm/main_80230AE0.s.o(.rodata); build/asm/main_80230AE0.s.o(.data); }
    .main_80230AE0_bss (NOLOAD) : { build/asm/main_80230AE0.s.o(.bss); }
    .main_80230AEC 0x80230AEC : AT(0x000316EC) { build/asm/data/main_80230AEC.bin.o(.data); }
    .main_80230D74 0x80230D74 : AT(0x00031974) { FILL(0x00000000); build/asm/main_80230D74.s.o(.text); build/asm/main_80230D74.s.o(.rodata); build/asm/main_80230D74.s.o(.data); }
    .main_80230D74_bss (NOLOAD) : { build/asm/main_80230D74.s.o(.bss); }
    .main_80230DF0 0x80230DF0 : AT(0x000319F0) { build/asm/data/main_80230DF0.bin.o(.data); }
    .main_802318AC 0x802318AC : AT(0x000324AC) { FILL(0x00000000); build/asm/main_802318AC.s.o(.text); build/asm/main_802318AC.s.o(.rodata); build/asm/main_802318AC.s.o(.data); }
    .main_802318AC_bss (NOLOAD) : { build/asm/main_802318AC.s.o(.bss); }
    .main_80231A34 0x80231A34 : AT(0x00032634) { build/asm/data/main_80231A34.bin.o(.data); }
    .main_80233098 0x80233098 : AT(0x00033C98) { FILL(0x00000000); build/asm/main_80233098.s.o(.text); build/asm/main_80233098.s.o(.rodata); build/asm/main_80233098.s.o(.data); }
    .main_80233098_bss (NOLOAD) : { build/asm/main_80233098.s.o(.bss); }
    .main_80233108 0x80233108 : AT(0x00033D08) { build/asm/data/main_80233108.bin.o(.data); }
    .main_80233428 0x80233428 : AT(0x00034028) { FILL(0x00000000); build/asm/main_80233428.s.o(.text); build/asm/main_80233428.s.o(.rodata); build/asm/main_80233428.s.o(.data); }
    .main_80233428_bss (NOLOAD) : { build/asm/main_80233428.s.o(.bss); }
    .main_80233490 0x80233490 : AT(0x00034090) { build/asm/data/main_80233490.bin.o(.data); }
    .main_80233AC8 0x80233AC8 : AT(0x000346C8) { FILL(0x00000000); build/asm/main_80233AC8.s.o(.text); build/asm/main_80233AC8.s.o(.rodata); build/asm/main_80233AC8.s.o(.data); }
    .main_80233AC8_bss (NOLOAD) : { build/asm/main_80233AC8.s.o(.bss); }
    .main_80233AD8 0x80233AD8 : AT(0x000346D8) { build/asm/data/main_80233AD8.bin.o(.data); }
    .main_80234094 0x80234094 : AT(0x00034C94) { FILL(0x00000000); build/asm/main_80234094.s.o(.text); build/asm/main_80234094.s.o(.rodata); build/asm/main_80234094.s.o(.data); }
    .main_80234094_bss (NOLOAD) : { build/asm/main_80234094.s.o(.bss); }
    .main_80234110 0x80234110 : AT(0x00034D10) { build/asm/data/main_80234110.bin.o(.data); }
    .main_802342A4 0x802342A4 : AT(0x00034EA4) { FILL(0x00000000); build/asm/main_802342A4.s.o(.text); build/asm/main_802342A4.s.o(.rodata); build/asm/main_802342A4.s.o(.data); }
    .main_802342A4_bss (NOLOAD) : { build/asm/main_802342A4.s.o(.bss); }
    .main_80234304 0x80234304 : AT(0x00034F04) { build/asm/data/main_80234304.bin.o(.data); }
    .main_8023521C 0x8023521C : AT(0x00035E1C) { FILL(0x00000000); build/asm/main_8023521C.s.o(.text); build/asm/main_8023521C.s.o(.rodata); build/asm/main_8023521C.s.o(.data); }
    .main_8023521C_bss (NOLOAD) : { build/asm/main_8023521C.s.o(.bss); }
    .main_80235260 0x80235260 : AT(0x00035E60) { build/asm/data/main_80235260.bin.o(.data); }
    .main_802352D4 0x802352D4 : AT(0x00035ED4) { FILL(0x00000000); build/asm/main_802352D4.s.o(.text); build/asm/main_802352D4.s.o(.rodata); build/asm/main_802352D4.s.o(.data); }
    .main_802352D4_bss (NOLOAD) : { build/asm/main_802352D4.s.o(.bss); }
    .main_802352E0 0x802352E0 : AT(0x00035EE0) { build/asm/data/main_802352E0.bin.o(.data); }
    .main_802365E8 0x802365E8 : AT(0x000371E8) { FILL(0x00000000); build/asm/main_802365E8.s.o(.text); build/asm/main_802365E8.s.o(.rodata); build/asm/main_802365E8.s.o(.data); }
    .main_802365E8_bss (NOLOAD) : { build/asm/main_802365E8.s.o(.bss); }
    .main_80236608 0x80236608 : AT(0x00037208) { build/asm/data/main_80236608.bin.o(.data); }
    .main_80238D48 0x80238D48 : AT(0x00039948) { FILL(0x00000000); build/asm/main_80238D48.s.o(.text); build/asm/main_80238D48.s.o(.rodata); build/asm/main_80238D48.s.o(.data); }
    .main_80238D48_bss (NOLOAD) : { build/asm/main_80238D48.s.o(.bss); }
    .main_80238D98 0x80238D98 : AT(0x00039998) { build/asm/data/main_80238D98.bin.o(.data); }
    .main_8023A0A0 0x8023A0A0 : AT(0x0003ACA0) { FILL(0x00000000); build/asm/main_8023A0A0.s.o(.text); build/asm/main_8023A0A0.s.o(.rodata); build/asm/main_8023A0A0.s.o(.data); }
    .main_8023A0A0_bss (NOLOAD) : { build/asm/main_8023A0A0.s.o(.bss); }
    .main_8023A0E8 0x8023A0E8 : AT(0x0003ACE8) { build/asm/data/main_8023A0E8.bin.o(.data); }
    .main_8023AF68 0x8023AF68 : AT(0x0003BB68) { FILL(0x00000000); build/asm/main_8023AF68.s.o(.text); build/asm/main_8023AF68.s.o(.rodata); build/asm/main_8023AF68.s.o(.data); }
    .main_8023AF68_bss (NOLOAD) : { build/asm/main_8023AF68.s.o(.bss); }
    .main_8023AFC8 0x8023AFC8 : AT(0x0003BBC8) { build/asm/data/main_8023AFC8.bin.o(.data); }
    .main_8023B3E0 0x8023B3E0 : AT(0x0003BFE0) { FILL(0x00000000); build/asm/main_8023B3E0.s.o(.text); build/asm/main_8023B3E0.s.o(.rodata); build/asm/main_8023B3E0.s.o(.data); }
    .main_8023B3E0_bss (NOLOAD) : { build/asm/main_8023B3E0.s.o(.bss); }
    .main_8023B408 0x8023B408 : AT(0x0003C008) { build/asm/data/main_8023B408.bin.o(.data); }
    .main_8023BF98 0x8023BF98 : AT(0x0003CB98) { FILL(0x00000000); build/asm/main_8023BF98.s.o(.text); build/asm/main_8023BF98.s.o(.rodata); build/asm/main_8023BF98.s.o(.data); }
    .main_8023BF98_bss (NOLOAD) : { build/asm/main_8023BF98.s.o(.bss); }
    .main_8023BFC0 0x8023BFC0 : AT(0x0003CBC0) { build/asm/data/main_8023BFC0.bin.o(.data); }
    .main_8023E7A4 0x8023E7A4 : AT(0x0003F3A4) { FILL(0x00000000); build/asm/main_8023E7A4.s.o(.text); build/asm/main_8023E7A4.s.o(.rodata); build/asm/main_8023E7A4.s.o(.data); }
    .main_8023E7A4_bss (NOLOAD) : { build/asm/main_8023E7A4.s.o(.bss); }
    .main_8023E7AC 0x8023E7AC : AT(0x0003F3AC) { build/asm/data/main_8023E7AC.bin.o(.data); }
    .main_80240E28 0x80240E28 : AT(0x00041A28) { FILL(0x00000000); build/asm/main_80240E28.s.o(.text); build/asm/main_80240E28.s.o(.rodata); build/asm/main_80240E28.s.o(.data); }
    .main_80240E28_bss (NOLOAD) : { build/asm/main_80240E28.s.o(.bss); }
    .main_80240E50 0x80240E50 : AT(0x00041A50) { build/asm/data/main_80240E50.bin.o(.data); }
    .main_80241D6C 0x80241D6C : AT(0x0004296C) { FILL(0x00000000); build/asm/main_80241D6C.s.o(.text); build/asm/main_80241D6C.s.o(.rodata); build/asm/main_80241D6C.s.o(.data); }
    .main_80241D6C_bss (NOLOAD) : { build/asm/main_80241D6C.s.o(.bss); }
    .main_80241E24 0x80241E24 : AT(0x00042A24) { build/asm/data/main_80241E24.bin.o(.data); }
    .main_8024245C 0x8024245C : AT(0x0004305C) { FILL(0x00000000); build/asm/main_8024245C.s.o(.text); build/asm/main_8024245C.s.o(.rodata); build/asm/main_8024245C.s.o(.data); }
    .main_8024245C_bss (NOLOAD) : { build/asm/main_8024245C.s.o(.bss); }
    .main_8024247C 0x8024247C : AT(0x0004307C) { build/asm/data/main_8024247C.bin.o(.data); }
    .main_802430A8 0x802430A8 : AT(0x00043CA8) { FILL(0x00000000); build/asm/main_802430A8.s.o(.text); build/asm/main_802430A8.s.o(.rodata); build/asm/main_802430A8.s.o(.data); }
    .main_802430A8_bss (NOLOAD) : { build/asm/main_802430A8.s.o(.bss); }
    .main_80243130 0x80243130 : AT(0x00043D30) { build/asm/data/main_80243130.bin.o(.data); }
    .main_80245774 0x80245774 : AT(0x00046374) { FILL(0x00000000); build/asm/main_80245774.s.o(.text); build/asm/main_80245774.s.o(.rodata); build/asm/main_80245774.s.o(.data); }
    .main_80245774_bss (NOLOAD) : { build/asm/main_80245774.s.o(.bss); }
    .main_8024578C 0x8024578C : AT(0x0004638C) { build/asm/data/main_8024578C.bin.o(.data); }
    .main_802468B8 0x802468B8 : AT(0x000474B8) { FILL(0x00000000); build/asm/main_802468B8.s.o(.text); build/asm/main_802468B8.s.o(.rodata); build/asm/main_802468B8.s.o(.data); }
    .main_802468B8_bss (NOLOAD) : { build/asm/main_802468B8.s.o(.bss); }
    .main_8024693C 0x8024693C : AT(0x0004753C) { build/asm/data/main_8024693C.bin.o(.data); }
    .main_8024B1F4 0x8024B1F4 : AT(0x0004BDF4) { FILL(0x00000000); build/asm/main_8024B1F4.s.o(.text); build/asm/main_8024B1F4.s.o(.rodata); build/asm/main_8024B1F4.s.o(.data); }
    .main_8024B1F4_bss (NOLOAD) : { build/asm/main_8024B1F4.s.o(.bss); }
    .main_8024B230 0x8024B230 : AT(0x0004BE30) { build/asm/data/main_8024B230.bin.o(.data); }
    .main_8024CA60 0x8024CA60 : AT(0x0004D660) { FILL(0x00000000); build/asm/main_8024CA60.s.o(.text); build/asm/main_8024CA60.s.o(.rodata); build/asm/main_8024CA60.s.o(.data); }
    .main_8024CA60_bss (NOLOAD) : { build/asm/main_8024CA60.s.o(.bss); }
    .main_8024CA84 0x8024CA84 : AT(0x0004D684) { build/asm/data/main_8024CA84.bin.o(.data); }
    .main_8024F688 0x8024F688 : AT(0x00050288) { FILL(0x00000000); build/asm/main_8024F688.s.o(.text); build/asm/main_8024F688.s.o(.rodata); build/asm/main_8024F688.s.o(.data); }
    .main_8024F688_bss (NOLOAD) : { build/asm/main_8024F688.s.o(.bss); }
    .main_8024F690 0x8024F690 : AT(0x00050290) { build/asm/data/main_8024F690.bin.o(.data); }
    .main_80251904 0x80251904 : AT(0x00052504) { FILL(0x00000000); build/asm/main_80251904.s.o(.text); build/asm/main_80251904.s.o(.rodata); build/asm/main_80251904.s.o(.data); }
    .main_80251904_bss (NOLOAD) : { build/asm/main_80251904.s.o(.bss); }
    .main_80251918 0x80251918 : AT(0x00052518) { build/asm/data/main_80251918.bin.o(.data); }
    .main_80252130 0x80252130 : AT(0x00052D30) { FILL(0x00000000); build/asm/main_80252130.s.o(.text); build/asm/main_80252130.s.o(.rodata); build/asm/main_80252130.s.o(.data); }
    .main_80252130_bss (NOLOAD) : { build/asm/main_80252130.s.o(.bss); }
    .main_8025219C 0x8025219C : AT(0x00052D9C) { build/asm/data/main_8025219C.bin.o(.data); }
    .main_80253184 0x80253184 : AT(0x00053D84) { FILL(0x00000000); build/asm/main_80253184.s.o(.text); build/asm/main_80253184.s.o(.rodata); build/asm/main_80253184.s.o(.data); }
    .main_80253184_bss (NOLOAD) : { build/asm/main_80253184.s.o(.bss); }
    .main_802531A0 0x802531A0 : AT(0x00053DA0) { build/asm/data/main_802531A0.bin.o(.data); }
    .main_80254AA4 0x80254AA4 : AT(0x000556A4) { FILL(0x00000000); build/asm/main_80254AA4.s.o(.text); build/asm/main_80254AA4.s.o(.rodata); build/asm/main_80254AA4.s.o(.data); }
    .main_80254AA4_bss (NOLOAD) : { build/asm/main_80254AA4.s.o(.bss); }
    .main_80254AD8 0x80254AD8 : AT(0x000556D8) { build/asm/data/main_80254AD8.bin.o(.data); }
    .main_80254DD4 0x80254DD4 : AT(0x000559D4) { FILL(0x00000000); build/asm/main_80254DD4.s.o(.text); build/asm/main_80254DD4.s.o(.rodata); build/asm/main_80254DD4.s.o(.data); }
    .main_80254DD4_bss (NOLOAD) : { build/asm/main_80254DD4.s.o(.bss); }
    .main_80254DF4 0x80254DF4 : AT(0x000559F4) { build/asm/data/main_80254DF4.bin.o(.data); }
    .main_80256780 0x80256780 : AT(0x00057380) { FILL(0x00000000); build/asm/main_80256780.s.o(.text); build/asm/main_80256780.s.o(.rodata); build/asm/main_80256780.s.o(.data); }
    .main_80256780_bss (NOLOAD) : { build/asm/main_80256780.s.o(.bss); }
    .main_802567A8 0x802567A8 : AT(0x000573A8) { build/asm/data/main_802567A8.bin.o(.data); }
    .main_80256854 0x80256854 : AT(0x00057454) { FILL(0x00000000); build/asm/main_80256854.s.o(.text); build/asm/main_80256854.s.o(.rodata); build/asm/main_80256854.s.o(.data); }
    .main_80256854_bss (NOLOAD) : { build/asm/main_80256854.s.o(.bss); }
    .main_8025689C 0x8025689C : AT(0x0005749C) { build/asm/data/main_8025689C.bin.o(.data); }
    .main_80258688 0x80258688 : AT(0x00059288) { FILL(0x00000000); build/asm/main_80258688.s.o(.text); build/asm/main_80258688.s.o(.rodata); build/asm/main_80258688.s.o(.data); }
    .main_80258688_bss (NOLOAD) : { build/asm/main_80258688.s.o(.bss); }
    .main_802586D0 0x802586D0 : AT(0x000592D0) { build/asm/data/main_802586D0.bin.o(.data); }
    .main_8025AF94 0x8025AF94 : AT(0x0005BB94) { FILL(0x00000000); build/asm/main_8025AF94.s.o(.text); build/asm/main_8025AF94.s.o(.rodata); build/asm/main_8025AF94.s.o(.data); }
    .main_8025AF94_bss (NOLOAD) : { build/asm/main_8025AF94.s.o(.bss); }
    .main_8025AFC8 0x8025AFC8 : AT(0x0005BBC8) { build/asm/data/main_8025AFC8.bin.o(.data); }
    .main_8025BAF8 0x8025BAF8 : AT(0x0005C6F8) { FILL(0x00000000); build/asm/main_8025BAF8.s.o(.text); build/asm/main_8025BAF8.s.o(.rodata); build/asm/main_8025BAF8.s.o(.data); }
    .main_8025BAF8_bss (NOLOAD) : { build/asm/main_8025BAF8.s.o(.bss); }
    .main_8025BB14 0x8025BB14 : AT(0x0005C714) { build/asm/data/main_8025BB14.bin.o(.data); }
    .main_8025C758 0x8025C758 : AT(0x0005D358) { FILL(0x00000000); build/asm/main_8025C758.s.o(.text); build/asm/main_8025C758.s.o(.rodata); build/asm/main_8025C758.s.o(.data); }
    .main_8025C758_bss (NOLOAD) : { build/asm/main_8025C758.s.o(.bss); }
    .main_8025C75C 0x8025C75C : AT(0x0005D35C) { build/asm/data/main_8025C75C.bin.o(.data); }
    .main_8025CCE0 0x8025CCE0 : AT(0x0005D8E0) { FILL(0x00000000); build/asm/main_8025CCE0.s.o(.text); build/asm/main_8025CCE0.s.o(.rodata); build/asm/main_8025CCE0.s.o(.data); }
    .main_8025CCE0_bss (NOLOAD) : { build/asm/main_8025CCE0.s.o(.bss); }
    .main_8025CCE8 0x8025CCE8 : AT(0x0005D8E8) { build/asm/data/main_8025CCE8.bin.o(.data); }
    .main_8025D228 0x8025D228 : AT(0x0005DE28) { FILL(0x00000000); build/asm/main_8025D228.s.o(.text); build/asm/main_8025D228.s.o(.rodata); build/asm/main_8025D228.s.o(.data); }
    .main_8025D228_bss (NOLOAD) : { build/asm/main_8025D228.s.o(.bss); }
    .main_8025D260 0x8025D260 : AT(0x0005DE60) { build/asm/data/main_8025D260.bin.o(.data); }
    .main_8025D8D0 0x8025D8D0 : AT(0x0005E4D0) { FILL(0x00000000); build/asm/main_8025D8D0.s.o(.text); build/asm/main_8025D8D0.s.o(.rodata); build/asm/main_8025D8D0.s.o(.data); }
    .main_8025D8D0_bss (NOLOAD) : { build/asm/main_8025D8D0.s.o(.bss); }
    .main_8025D8E4 0x8025D8E4 : AT(0x0005E4E4) { build/asm/data/main_8025D8E4.bin.o(.data); }
    .main_8025E620 0x8025E620 : AT(0x0005F220) { FILL(0x00000000); build/asm/main_8025E620.s.o(.text); build/asm/main_8025E620.s.o(.rodata); build/asm/main_8025E620.s.o(.data); }
    .main_8025E620_bss (NOLOAD) : { build/asm/main_8025E620.s.o(.bss); }
    .main_8025E638 0x8025E638 : AT(0x0005F238) { build/asm/data/main_8025E638.bin.o(.data); }
    .main_802620A4 0x802620A4 : AT(0x00062CA4) { FILL(0x00000000); build/asm/main_802620A4.s.o(.text); build/asm/main_802620A4.s.o(.rodata); build/asm/main_802620A4.s.o(.data); }
    .main_802620A4_bss (NOLOAD) : { build/asm/main_802620A4.s.o(.bss); }
    .main_802620F8 0x802620F8 : AT(0x00062CF8) { build/asm/data/main_802620F8.bin.o(.data); }
    .main_80262190 0x80262190 : AT(0x00062D90) { FILL(0x00000000); build/asm/main_80262190.s.o(.text); build/asm/main_80262190.s.o(.rodata); build/asm/main_80262190.s.o(.data); }
    .main_80262190_bss (NOLOAD) : { build/asm/main_80262190.s.o(.bss); }
    .main_80262264 0x80262264 : AT(0x00062E64) { build/asm/data/main_80262264.bin.o(.data); }
    .main_802646F0 0x802646F0 : AT(0x000652F0) { FILL(0x00000000); build/asm/main_802646F0.s.o(.text); build/asm/main_802646F0.s.o(.rodata); build/asm/main_802646F0.s.o(.data); }
    .main_802646F0_bss (NOLOAD) : { build/asm/main_802646F0.s.o(.bss); }
    .main_8026471C 0x8026471C : AT(0x0006531C) { build/asm/data/main_8026471C.bin.o(.data); }
    .main_80265598 0x80265598 : AT(0x00066198) { FILL(0x00000000); build/asm/main_80265598.s.o(.text); build/asm/main_80265598.s.o(.rodata); build/asm/main_80265598.s.o(.data); }
    .main_80265598_bss (NOLOAD) : { build/asm/main_80265598.s.o(.bss); }
    .main_802655A8 0x802655A8 : AT(0x000661A8) { build/asm/data/main_802655A8.bin.o(.data); }
    .main_80267270 0x80267270 : AT(0x00067E70) { FILL(0x00000000); build/asm/main_80267270.s.o(.text); build/asm/main_80267270.s.o(.rodata); build/asm/main_80267270.s.o(.data); }
    .main_80267270_bss (NOLOAD) : { build/asm/main_80267270.s.o(.bss); }
    .main_80267278 0x80267278 : AT(0x00067E78) { build/asm/data/main_80267278.bin.o(.data); }
    .main_80268D2C 0x80268D2C : AT(0x0006992C) { FILL(0x00000000); build/asm/main_80268D2C.s.o(.text); build/asm/main_80268D2C.s.o(.rodata); build/asm/main_80268D2C.s.o(.data); }
    .main_80268D2C_bss (NOLOAD) : { build/asm/main_80268D2C.s.o(.bss); }
    .main_80268D3C 0x80268D3C : AT(0x0006993C) { build/asm/data/main_80268D3C.bin.o(.data); }
    .main_8026C468 0x8026C468 : AT(0x0006D068) { FILL(0x00000000); build/asm/main_8026C468.s.o(.text); build/asm/main_8026C468.s.o(.rodata); build/asm/main_8026C468.s.o(.data); }
    .main_8026C468_bss (NOLOAD) : { build/asm/main_8026C468.s.o(.bss); }
    .main_8026C490 0x8026C490 : AT(0x0006D090) { build/asm/data/main_8026C490.bin.o(.data); }
    .main_8026D758 0x8026D758 : AT(0x0006E358) { FILL(0x00000000); build/asm/main_8026D758.s.o(.text); build/asm/main_8026D758.s.o(.rodata); build/asm/main_8026D758.s.o(.data); }
    .main_8026D758_bss (NOLOAD) : { build/asm/main_8026D758.s.o(.bss); }
    .main_8026D760 0x8026D760 : AT(0x0006E360) { build/asm/data/main_8026D760.bin.o(.data); }
    .main_8026D970 0x8026D970 : AT(0x0006E570) { FILL(0x00000000); build/asm/main_8026D970.s.o(.text); build/asm/main_8026D970.s.o(.rodata); build/asm/main_8026D970.s.o(.data); }
    .main_8026D970_bss (NOLOAD) : { build/asm/main_8026D970.s.o(.bss); }
    .main_8026D998 0x8026D998 : AT(0x0006E598) { build/asm/data/main_8026D998.bin.o(.data); }
    .main_8027467C 0x8027467C : AT(0x0007527C) { FILL(0x00000000); build/asm/main_8027467C.s.o(.text); build/asm/main_8027467C.s.o(.rodata); build/asm/main_8027467C.s.o(.data); }
    .main_8027467C_bss (NOLOAD) : { build/asm/main_8027467C.s.o(.bss); }
    .main_802746B8 0x802746B8 : AT(0x000752B8) { build/asm/data/main_802746B8.bin.o(.data); }
    .main_80275524 0x80275524 : AT(0x00076124) { FILL(0x00000000); build/asm/main_80275524.s.o(.text); build/asm/main_80275524.s.o(.rodata); build/asm/main_80275524.s.o(.data); }
    .main_80275524_bss (NOLOAD) : { build/asm/main_80275524.s.o(.bss); }
    .main_802755AC 0x802755AC : AT(0x000761AC) { build/asm/data/main_802755AC.bin.o(.data); }
    .main_80276A2C 0x80276A2C : AT(0x0007762C) { FILL(0x00000000); build/asm/main_80276A2C.s.o(.text); build/asm/main_80276A2C.s.o(.rodata); build/asm/main_80276A2C.s.o(.data); }
    .main_80276A2C_bss (NOLOAD) : { build/asm/main_80276A2C.s.o(.bss); }
    .main_80276A60 0x80276A60 : AT(0x00077660) { build/asm/data/main_80276A60.bin.o(.data); }
    .main_802774F4 0x802774F4 : AT(0x000780F4) { FILL(0x00000000); build/asm/main_802774F4.s.o(.text); build/asm/main_802774F4.s.o(.rodata); build/asm/main_802774F4.s.o(.data); }
    .main_802774F4_bss (NOLOAD) : { build/asm/main_802774F4.s.o(.bss); }
    .main_8027751C 0x8027751C : AT(0x0007811C) { build/asm/data/main_8027751C.bin.o(.data); }
    .main_802798EC 0x802798EC : AT(0x0007A4EC) { FILL(0x00000000); build/asm/main_802798EC.s.o(.text); build/asm/main_802798EC.s.o(.rodata); build/asm/main_802798EC.s.o(.data); }
    .main_802798EC_bss (NOLOAD) : { build/asm/main_802798EC.s.o(.bss); }
    .main_80279908 0x80279908 : AT(0x0007A508) { build/asm/data/main_80279908.bin.o(.data); }
    .main_80279B58 0x80279B58 : AT(0x0007A758) { FILL(0x00000000); build/asm/main_80279B58.s.o(.text); build/asm/main_80279B58.s.o(.rodata); build/asm/main_80279B58.s.o(.data); }
    .main_80279B58_bss (NOLOAD) : { build/asm/main_80279B58.s.o(.bss); }
    .main_80279DF0 0x80279DF0 : AT(0x0007A9F0) { build/asm/data/main_80279DF0.bin.o(.data); }
    .main_8027B6B8 0x8027B6B8 : AT(0x0007C2B8) { FILL(0x00000000); build/asm/main_8027B6B8.s.o(.text); build/asm/main_8027B6B8.s.o(.rodata); build/asm/main_8027B6B8.s.o(.data); }
    .main_8027B6B8_bss (NOLOAD) : { build/asm/main_8027B6B8.s.o(.bss); }
    .main_8027C07C 0x8027C07C : AT(0x0007CC7C) { build/asm/data/main_8027C07C.bin.o(.data); }
    .main_8027C39C 0x8027C39C : AT(0x0007CF9C) { FILL(0x00000000); build/asm/main_8027C39C.s.o(.text); build/asm/main_8027C39C.s.o(.rodata); build/asm/main_8027C39C.s.o(.data); }
    .main_8027C39C_bss (NOLOAD) : { build/asm/main_8027C39C.s.o(.bss); }
    .main_8027C3D8 0x8027C3D8 : AT(0x0007CFD8) { build/asm/data/main_8027C3D8.bin.o(.data); }
    .main_8027C6A8 0x8027C6A8 : AT(0x0007D2A8) { FILL(0x00000000); build/asm/main_8027C6A8.s.o(.text); build/asm/main_8027C6A8.s.o(.rodata); build/asm/main_8027C6A8.s.o(.data); }
    .main_8027C6A8_bss (NOLOAD) : { build/asm/main_8027C6A8.s.o(.bss); }
    .main_8027C6E8 0x8027C6E8 : AT(0x0007D2E8) { build/asm/data/main_8027C6E8.bin.o(.data); }
    .main_8027D040 0x8027D040 : AT(0x0007DC40) { FILL(0x00000000); build/asm/main_8027D040.s.o(.text); build/asm/main_8027D040.s.o(.rodata); build/asm/main_8027D040.s.o(.data); }
    .main_8027D040_bss (NOLOAD) : { build/asm/main_8027D040.s.o(.bss); }
    .main_8027D168 0x8027D168 : AT(0x0007DD68) { build/asm/data/main_8027D168.bin.o(.data); }
    .main_8027E4B0 0x8027E4B0 : AT(0x0007F0B0) { FILL(0x00000000); build/asm/main_8027E4B0.s.o(.text); build/asm/main_8027E4B0.s.o(.rodata); build/asm/main_8027E4B0.s.o(.data); }
    .main_8027E4B0_bss (NOLOAD) : { build/asm/main_8027E4B0.s.o(.bss); }
    .main_8027E4D4 0x8027E4D4 : AT(0x0007F0D4) { build/asm/data/main_8027E4D4.bin.o(.data); }
    .main_80280710 0x80280710 : AT(0x00081310) { FILL(0x00000000); build/asm/main_80280710.s.o(.text); build/asm/main_80280710.s.o(.rodata); build/asm/main_80280710.s.o(.data); }
    .main_80280710_bss (NOLOAD) : { build/asm/main_80280710.s.o(.bss); }
    .main_80280750 0x80280750 : AT(0x00081350) { build/asm/data/main_80280750.bin.o(.data); }
    .main_80282218 0x80282218 : AT(0x00082E18) { FILL(0x00000000); build/asm/main_80282218.s.o(.text); build/asm/main_80282218.s.o(.rodata); build/asm/main_80282218.s.o(.data); }
    .main_80282218_bss (NOLOAD) : { build/asm/main_80282218.s.o(.bss); }
    .main_80282240 0x80282240 : AT(0x00082E40) { build/asm/data/main_80282240.bin.o(.data); }
    .main_80282B50 0x80282B50 : AT(0x00083750) { FILL(0x00000000); build/asm/main_80282B50.s.o(.text); build/asm/main_80282B50.s.o(.rodata); build/asm/main_80282B50.s.o(.data); }
    .main_80282B50_bss (NOLOAD) : { build/asm/main_80282B50.s.o(.bss); }
    .main_80282B80 0x80282B80 : AT(0x00083780) { build/asm/data/main_80282B80.bin.o(.data); }
    .main_80282E90 0x80282E90 : AT(0x00083A90) { FILL(0x00000000); build/asm/main_80282E90.s.o(.text); build/asm/main_80282E90.s.o(.rodata); build/asm/main_80282E90.s.o(.data); }
    .main_80282E90_bss (NOLOAD) : { build/asm/main_80282E90.s.o(.bss); }
    .main_80282E98 0x80282E98 : AT(0x00083A98) { build/asm/data/main_80282E98.bin.o(.data); }
    .main_80285778 0x80285778 : AT(0x00086378) { FILL(0x00000000); build/asm/main_80285778.s.o(.text); build/asm/main_80285778.s.o(.rodata); build/asm/main_80285778.s.o(.data); }
    .main_80285778_bss (NOLOAD) : { build/asm/main_80285778.s.o(.bss); }
    .main_802857A8 0x802857A8 : AT(0x000863A8) { build/asm/data/main_802857A8.bin.o(.data); }
    .main_80285B0C 0x80285B0C : AT(0x0008670C) { FILL(0x00000000); build/asm/main_80285B0C.s.o(.text); build/asm/main_80285B0C.s.o(.rodata); build/asm/main_80285B0C.s.o(.data); }
    .main_80285B0C_bss (NOLOAD) : { build/asm/main_80285B0C.s.o(.bss); }
    .main_80285B18 0x80285B18 : AT(0x00086718) { build/asm/data/main_80285B18.bin.o(.data); }
    .main_802867D8 0x802867D8 : AT(0x000873D8) { FILL(0x00000000); build/asm/main_802867D8.s.o(.text); build/asm/main_802867D8.s.o(.rodata); build/asm/main_802867D8.s.o(.data); }
    .main_802867D8_bss (NOLOAD) : { build/asm/main_802867D8.s.o(.bss); }
    .main_802867F8 0x802867F8 : AT(0x000873F8) { build/asm/data/main_802867F8.bin.o(.data); }
    .main_80286B20 0x80286B20 : AT(0x00087720) { FILL(0x00000000); build/asm/main_80286B20.s.o(.text); build/asm/main_80286B20.s.o(.rodata); build/asm/main_80286B20.s.o(.data); }
    .main_80286B20_bss (NOLOAD) : { build/asm/main_80286B20.s.o(.bss); }
    .main_80286B30 0x80286B30 : AT(0x00087730) { build/asm/data/main_80286B30.bin.o(.data); }
    .main_8028B510 0x8028B510 : AT(0x0008C110) { FILL(0x00000000); build/asm/main_8028B510.s.o(.text); build/asm/main_8028B510.s.o(.rodata); build/asm/main_8028B510.s.o(.data); }
    .main_8028B510_bss (NOLOAD) : { build/asm/main_8028B510.s.o(.bss); }
    .main_8028B514 0x8028B514 : AT(0x0008C114) { build/asm/data/main_8028B514.bin.o(.data); }
    .main_8028B7DC 0x8028B7DC : AT(0x0008C3DC) { FILL(0x00000000); build/asm/main_8028B7DC.s.o(.text); build/asm/main_8028B7DC.s.o(.rodata); build/asm/main_8028B7DC.s.o(.data); }
    .main_8028B7DC_bss (NOLOAD) : { build/asm/main_8028B7DC.s.o(.bss); }
    .main_8028B7E8 0x8028B7E8 : AT(0x0008C3E8) { build/asm/data/main_8028B7E8.bin.o(.data); }
    .main_8028D4FC 0x8028D4FC : AT(0x0008E0FC) { FILL(0x00000000); build/asm/main_8028D4FC.s.o(.text); build/asm/main_8028D4FC.s.o(.rodata); build/asm/main_8028D4FC.s.o(.data); }
    .main_8028D4FC_bss (NOLOAD) : { build/asm/main_8028D4FC.s.o(.bss); }
    .main_8028D508 0x8028D508 : AT(0x0008E108) { build/asm/data/main_8028D508.bin.o(.data); }
    .main_8028D8F8 0x8028D8F8 : AT(0x0008E4F8) { FILL(0x00000000); build/asm/main_8028D8F8.s.o(.text); build/asm/main_8028D8F8.s.o(.rodata); build/asm/main_8028D8F8.s.o(.data); }
    .main_8028D8F8_bss (NOLOAD) : { build/asm/main_8028D8F8.s.o(.bss); }
    .main_8028D900 0x8028D900 : AT(0x0008E500) { build/asm/data/main_8028D900.bin.o(.data); }
    .main_8028FCB4 0x8028FCB4 : AT(0x000908B4) { FILL(0x00000000); build/asm/main_8028FCB4.s.o(.text); build/asm/main_8028FCB4.s.o(.rodata); build/asm/main_8028FCB4.s.o(.data); }
    .main_8028FCB4_bss (NOLOAD) : { build/asm/main_8028FCB4.s.o(.bss); }
    .main_8028FCC0 0x8028FCC0 : AT(0x000908C0) { build/asm/data/main_8028FCC0.bin.o(.data); }
    .main_802916F0 0x802916F0 : AT(0x000922F0) { FILL(0x00000000); build/asm/main_802916F0.s.o(.text); build/asm/main_802916F0.s.o(.rodata); build/asm/main_802916F0.s.o(.data); }
    .main_802916F0_bss (NOLOAD) : { build/asm/main_802916F0.s.o(.bss); }
    .main_80291734 0x80291734 : AT(0x00092334) { build/asm/data/main_80291734.bin.o(.data); }
    .main_80292498 0x80292498 : AT(0x00093098) { FILL(0x00000000); build/asm/main_80292498.s.o(.text); build/asm/main_80292498.s.o(.rodata); build/asm/main_80292498.s.o(.data); }
    .main_80292498_bss (NOLOAD) : { build/asm/main_80292498.s.o(.bss); }
    .main_802924A8 0x802924A8 : AT(0x000930A8) { build/asm/data/main_802924A8.bin.o(.data); }
    .main_8029284C 0x8029284C : AT(0x0009344C) { FILL(0x00000000); build/asm/main_8029284C.s.o(.text); build/asm/main_8029284C.s.o(.rodata); build/asm/main_8029284C.s.o(.data); }
    .main_8029284C_bss (NOLOAD) : { build/asm/main_8029284C.s.o(.bss); }
    .main_802928CC 0x802928CC : AT(0x000934CC) { build/asm/data/main_802928CC.bin.o(.data); }
    .main_80293B64 0x80293B64 : AT(0x00094764) { FILL(0x00000000); build/asm/main_80293B64.s.o(.text); build/asm/main_80293B64.s.o(.rodata); build/asm/main_80293B64.s.o(.data); }
    .main_80293B64_bss (NOLOAD) : { build/asm/main_80293B64.s.o(.bss); }
    .main_80293B7C 0x80293B7C : AT(0x0009477C) { build/asm/data/main_80293B7C.bin.o(.data); }
    .main_80295C08 0x80295C08 : AT(0x00096808) { FILL(0x00000000); build/asm/main_80295C08.s.o(.text); build/asm/main_80295C08.s.o(.rodata); build/asm/main_80295C08.s.o(.data); }
    .main_80295C08_bss (NOLOAD) : { build/asm/main_80295C08.s.o(.bss); }
    .main_80295C44 0x80295C44 : AT(0x00096844) { build/asm/data/main_80295C44.bin.o(.data); }
    .main_802979C8 0x802979C8 : AT(0x000985C8) { FILL(0x00000000); build/asm/main_802979C8.s.o(.text); build/asm/main_802979C8.s.o(.rodata); build/asm/main_802979C8.s.o(.data); }
    .main_802979C8_bss (NOLOAD) : { build/asm/main_802979C8.s.o(.bss); }
    .main_80297A84 0x80297A84 : AT(0x00098684) { build/asm/data/main_80297A84.bin.o(.data); }
    .main_80297C7C 0x80297C7C : AT(0x0009887C) { FILL(0x00000000); build/asm/main_80297C7C.s.o(.text); build/asm/main_80297C7C.s.o(.rodata); build/asm/main_80297C7C.s.o(.data); }
    .main_80297C7C_bss (NOLOAD) : { build/asm/main_80297C7C.s.o(.bss); }
    .main_80297CB4 0x80297CB4 : AT(0x000988B4) { build/asm/data/main_80297CB4.bin.o(.data); }
    .main_80298F58 0x80298F58 : AT(0x00099B58) { FILL(0x00000000); build/asm/main_80298F58.s.o(.text); build/asm/main_80298F58.s.o(.rodata); build/asm/main_80298F58.s.o(.data); }
    .main_80298F58_bss (NOLOAD) : { build/asm/main_80298F58.s.o(.bss); }
    .main_80298F84 0x80298F84 : AT(0x00099B84) { build/asm/data/main_80298F84.bin.o(.data); }
    .main_8029A090 0x8029A090 : AT(0x0009AC90) { FILL(0x00000000); build/asm/main_8029A090.s.o(.text); build/asm/main_8029A090.s.o(.rodata); build/asm/main_8029A090.s.o(.data); }
    .main_8029A090_bss (NOLOAD) : { build/asm/main_8029A090.s.o(.bss); }
    .main_8029A0E8 0x8029A0E8 : AT(0x0009ACE8) { build/asm/data/main_8029A0E8.bin.o(.data); }
    .main_8029BC8C 0x8029BC8C : AT(0x0009C88C) { FILL(0x00000000); build/asm/main_8029BC8C.s.o(.text); build/asm/main_8029BC8C.s.o(.rodata); build/asm/main_8029BC8C.s.o(.data); }
    .main_8029BC8C_bss (NOLOAD) : { build/asm/main_8029BC8C.s.o(.bss); }
    .main_8029BCC4 0x8029BCC4 : AT(0x0009C8C4) { build/asm/data/main_8029BCC4.bin.o(.data); }
    .main_802A1D94 0x802A1D94 : AT(0x000A2994) { FILL(0x00000000); build/asm/main_802A1D94.s.o(.text); build/asm/main_802A1D94.s.o(.rodata); build/asm/main_802A1D94.s.o(.data); }
    .main_802A1D94_bss (NOLOAD) : { build/asm/main_802A1D94.s.o(.bss); }
    .main_802A1DBC 0x802A1DBC : AT(0x000A29BC) { build/asm/data/main_802A1DBC.bin.o(.data); }
    .main_802A3770 0x802A3770 : AT(0x000A4370) { FILL(0x00000000); build/asm/main_802A3770.s.o(.text); build/asm/main_802A3770.s.o(.rodata); build/asm/main_802A3770.s.o(.data); }
    .main_802A3770_bss (NOLOAD) : { build/asm/main_802A3770.s.o(.bss); }
    .main_802A3780 0x802A3780 : AT(0x000A4380) { build/asm/data/main_802A3780.bin.o(.data); }
    .main_802A4E54 0x802A4E54 : AT(0x000A5A54) { FILL(0x00000000); build/asm/main_802A4E54.s.o(.text); build/asm/main_802A4E54.s.o(.rodata); build/asm/main_802A4E54.s.o(.data); }
    .main_802A4E54_bss (NOLOAD) : { build/asm/main_802A4E54.s.o(.bss); }
    .main_802A4EA8 0x802A4EA8 : AT(0x000A5AA8) { build/asm/data/main_802A4EA8.bin.o(.data); }
    .main_802A51BC 0x802A51BC : AT(0x000A5DBC) { FILL(0x00000000); build/asm/main_802A51BC.s.o(.text); build/asm/main_802A51BC.s.o(.rodata); build/asm/main_802A51BC.s.o(.data); }
    .main_802A51BC_bss (NOLOAD) : { build/asm/main_802A51BC.s.o(.bss); }
    .main_802A51DC 0x802A51DC : AT(0x000A5DDC) { build/asm/data/main_802A51DC.bin.o(.data); }
    .main_802A5500 0x802A5500 : AT(0x000A6100) { FILL(0x00000000); build/asm/main_802A5500.s.o(.text); build/asm/main_802A5500.s.o(.rodata); build/asm/main_802A5500.s.o(.data); }
    .main_802A5500_bss (NOLOAD) : { build/asm/main_802A5500.s.o(.bss); }
    .main_802A551C 0x802A551C : AT(0x000A611C) { build/asm/data/main_802A551C.bin.o(.data); }
    .main_802A5770 0x802A5770 : AT(0x000A6370) { FILL(0x00000000); build/asm/main_802A5770.s.o(.text); build/asm/main_802A5770.s.o(.rodata); build/asm/main_802A5770.s.o(.data); }
    .main_802A5770_bss (NOLOAD) : { build/asm/main_802A5770.s.o(.bss); }
    .main_802A57B4 0x802A57B4 : AT(0x000A63B4) { build/asm/data/main_802A57B4.bin.o(.data); }
    .main_802A6304 0x802A6304 : AT(0x000A6F04) { FILL(0x00000000); build/asm/main_802A6304.s.o(.text); build/asm/main_802A6304.s.o(.rodata); build/asm/main_802A6304.s.o(.data); }
    .main_802A6304_bss (NOLOAD) : { build/asm/main_802A6304.s.o(.bss); }
    .main_802A6308 0x802A6308 : AT(0x000A6F08) { build/asm/data/main_802A6308.bin.o(.data); }
    .main_802A7244 0x802A7244 : AT(0x000A7E44) { FILL(0x00000000); build/asm/main_802A7244.s.o(.text); build/asm/main_802A7244.s.o(.rodata); build/asm/main_802A7244.s.o(.data); }
    .main_802A7244_bss (NOLOAD) : { build/asm/main_802A7244.s.o(.bss); }
    .main_802A728C 0x802A728C : AT(0x000A7E8C) { build/asm/data/main_802A728C.bin.o(.data); }
    .main_802A74C8 0x802A74C8 : AT(0x000A80C8) { FILL(0x00000000); build/asm/main_802A74C8.s.o(.text); build/asm/main_802A74C8.s.o(.rodata); build/asm/main_802A74C8.s.o(.data); }
    .main_802A74C8_bss (NOLOAD) : { build/asm/main_802A74C8.s.o(.bss); }
    .main_802A74D0 0x802A74D0 : AT(0x000A80D0) { build/asm/data/main_802A74D0.bin.o(.data); }
    .main_802ABDA0 0x802ABDA0 : AT(0x000AC9A0) { FILL(0x00000000); build/asm/main_802ABDA0.s.o(.text); build/asm/main_802ABDA0.s.o(.rodata); build/asm/main_802ABDA0.s.o(.data); }
    .main_802ABDA0_bss (NOLOAD) : { build/asm/main_802ABDA0.s.o(.bss); }
    .main_802ABDE0 0x802ABDE0 : AT(0x000AC9E0) { build/asm/data/main_802ABDE0.bin.o(.data); }
    .main_802AC7D0 0x802AC7D0 : AT(0x000AD3D0) { FILL(0x00000000); build/asm/main_802AC7D0.s.o(.text); build/asm/main_802AC7D0.s.o(.rodata); build/asm/main_802AC7D0.s.o(.data); }
    .main_802AC7D0_bss (NOLOAD) : { build/asm/main_802AC7D0.s.o(.bss); }
    .main_802AC7E0 0x802AC7E0 : AT(0x000AD3E0) { build/asm/data/main_802AC7E0.bin.o(.data); }
    .main_802AD6D0 0x802AD6D0 : AT(0x000AE2D0) { FILL(0x00000000); build/asm/main_802AD6D0.s.o(.text); build/asm/main_802AD6D0.s.o(.rodata); build/asm/main_802AD6D0.s.o(.data); }
    .main_802AD6D0_bss (NOLOAD) : { build/asm/main_802AD6D0.s.o(.bss); }
    .main_802AD6F0 0x802AD6F0 : AT(0x000AE2F0) { build/asm/data/main_802AD6F0.bin.o(.data); }
    .main_802B6144 0x802B6144 : AT(0x000B6D44) { FILL(0x00000000); build/asm/main_802B6144.s.o(.text); build/asm/main_802B6144.s.o(.rodata); build/asm/main_802B6144.s.o(.data); }
    .main_802B6144_bss (NOLOAD) : { build/asm/main_802B6144.s.o(.bss); }
    .main_802B6168 0x802B6168 : AT(0x000B6D68) { build/asm/data/main_802B6168.bin.o(.data); }
    .main_802B84E8 0x802B84E8 : AT(0x000B90E8) { FILL(0x00000000); build/asm/main_802B84E8.s.o(.text); build/asm/main_802B84E8.s.o(.rodata); build/asm/main_802B84E8.s.o(.data); }
    .main_802B84E8_bss (NOLOAD) : { build/asm/main_802B84E8.s.o(.bss); }
    .main_802B8550 0x802B8550 : AT(0x000B9150) { build/asm/data/main_802B8550.bin.o(.data); }
    .main_802B8D84 0x802B8D84 : AT(0x000B9984) { FILL(0x00000000); build/asm/main_802B8D84.s.o(.text); build/asm/main_802B8D84.s.o(.rodata); build/asm/main_802B8D84.s.o(.data); }
    .main_802B8D84_bss (NOLOAD) : { build/asm/main_802B8D84.s.o(.bss); }
    .main_802B8DAC 0x802B8DAC : AT(0x000B99AC) { build/asm/data/main_802B8DAC.bin.o(.data); }
    .main_802BAB80 0x802BAB80 : AT(0x000BB780) { FILL(0x00000000); build/asm/main_802BAB80.s.o(.text); build/asm/main_802BAB80.s.o(.rodata); build/asm/main_802BAB80.s.o(.data); }
    .main_802BAB80_bss (NOLOAD) : { build/asm/main_802BAB80.s.o(.bss); }
    .main_802BABD8 0x802BABD8 : AT(0x000BB7D8) { build/asm/data/main_802BABD8.bin.o(.data); }
    .main_802BAFFC 0x802BAFFC : AT(0x000BBBFC) { FILL(0x00000000); build/asm/main_802BAFFC.s.o(.text); build/asm/main_802BAFFC.s.o(.rodata); build/asm/main_802BAFFC.s.o(.data); }
    .main_802BAFFC_bss (NOLOAD) : { build/asm/main_802BAFFC.s.o(.bss); }
    .main_802BB004 0x802BB004 : AT(0x000BBC04) { build/asm/data/main_802BB004.bin.o(.data); }
    .main_802BB624 0x802BB624 : AT(0x000BC224) { FILL(0x00000000); build/asm/main_802BB624.s.o(.text); build/asm/main_802BB624.s.o(.rodata); build/asm/main_802BB624.s.o(.data); }
    .main_802BB624_bss (NOLOAD) : { build/asm/main_802BB624.s.o(.bss); }
    .main_802BB62C 0x802BB62C : AT(0x000BC22C) { build/asm/data/main_802BB62C.bin.o(.data); }
    .main_802BB998 0x802BB998 : AT(0x000BC598) { FILL(0x00000000); build/asm/main_802BB998.s.o(.text); build/asm/main_802BB998.s.o(.rodata); build/asm/main_802BB998.s.o(.data); }
    .main_802BB998_bss (NOLOAD) : { build/asm/main_802BB998.s.o(.bss); }
    .main_802BB9A8 0x802BB9A8 : AT(0x000BC5A8) { build/asm/data/main_802BB9A8.bin.o(.data); }
    .main_802BD8FC 0x802BD8FC : AT(0x000BE4FC) { FILL(0x00000000); build/asm/main_802BD8FC.s.o(.text); build/asm/main_802BD8FC.s.o(.rodata); build/asm/main_802BD8FC.s.o(.data); }
    .main_802BD8FC_bss (NOLOAD) : { build/asm/main_802BD8FC.s.o(.bss); }
    .main_802BD934 0x802BD934 : AT(0x000BE534) { build/asm/data/main_802BD934.bin.o(.data); }
    .main_802C074C 0x802C074C : AT(0x000C134C) { FILL(0x00000000); build/asm/main_802C074C.s.o(.text); build/asm/main_802C074C.s.o(.rodata); build/asm/main_802C074C.s.o(.data); }
    .main_802C074C_bss (NOLOAD) : { build/asm/main_802C074C.s.o(.bss); }
    .main_802C0770 0x802C0770 : AT(0x000C1370) { build/asm/data/main_802C0770.bin.o(.data); }
    .main_802C1B50 0x802C1B50 : AT(0x000C2750) { FILL(0x00000000); build/asm/main_802C1B50.s.o(.text); build/asm/main_802C1B50.s.o(.rodata); build/asm/main_802C1B50.s.o(.data); }
    .main_802C1B50_bss (NOLOAD) : { build/asm/main_802C1B50.s.o(.bss); }
    .main_802C1BA0 0x802C1BA0 : AT(0x000C27A0) { build/asm/data/main_802C1BA0.bin.o(.data); }
    .main_802C2724 0x802C2724 : AT(0x000C3324) { FILL(0x00000000); build/asm/main_802C2724.s.o(.text); build/asm/main_802C2724.s.o(.rodata); build/asm/main_802C2724.s.o(.data); }
    .main_802C2724_bss (NOLOAD) : { build/asm/main_802C2724.s.o(.bss); }
    .main_802C2730 0x802C2730 : AT(0x000C3330) { build/asm/data/main_802C2730.bin.o(.data); }
    .main_802C2BF8 0x802C2BF8 : AT(0x000C37F8) { FILL(0x00000000); build/asm/main_802C2BF8.s.o(.text); build/asm/main_802C2BF8.s.o(.rodata); build/asm/main_802C2BF8.s.o(.data); }
    .main_802C2BF8_bss (NOLOAD) : { build/asm/main_802C2BF8.s.o(.bss); }
    .main_802C2C00 0x802C2C00 : AT(0x000C3800) { build/asm/data/main_802C2C00.bin.o(.data); }
    .main_802C2F24 0x802C2F24 : AT(0x000C3B24) { FILL(0x00000000); build/asm/main_802C2F24.s.o(.text); build/asm/main_802C2F24.s.o(.rodata); build/asm/main_802C2F24.s.o(.data); }
    .main_802C2F24_bss (NOLOAD) : { build/asm/main_802C2F24.s.o(.bss); }
    .main_802C2FD4 0x802C2FD4 : AT(0x000C3BD4) { build/asm/data/main_802C2FD4.bin.o(.data); }
    .main_802C31A8 0x802C31A8 : AT(0x000C3DA8) { FILL(0x00000000); build/asm/main_802C31A8.s.o(.text); build/asm/main_802C31A8.s.o(.rodata); build/asm/main_802C31A8.s.o(.data); }
    .main_802C31A8_bss (NOLOAD) : { build/asm/main_802C31A8.s.o(.bss); }
    .main_802C31AC 0x802C31AC : AT(0x000C3DAC) { build/asm/data/main_802C31AC.bin.o(.data); }
    .main_802C47C4 0x802C47C4 : AT(0x000C53C4) { FILL(0x00000000); build/asm/main_802C47C4.s.o(.text); build/asm/main_802C47C4.s.o(.rodata); build/asm/main_802C47C4.s.o(.data); }
    .main_802C47C4_bss (NOLOAD) : { build/asm/main_802C47C4.s.o(.bss); }
    .main_802C4838 0x802C4838 : AT(0x000C5438) { build/asm/data/main_802C4838.bin.o(.data); }
    .main_802C5C5C 0x802C5C5C : AT(0x000C685C) { FILL(0x00000000); build/asm/main_802C5C5C.s.o(.text); build/asm/main_802C5C5C.s.o(.rodata); build/asm/main_802C5C5C.s.o(.data); }
    .main_802C5C5C_bss (NOLOAD) : { build/asm/main_802C5C5C.s.o(.bss); }
    .main_802C5D98 0x802C5D98 : AT(0x000C6998) { build/asm/data/main_802C5D98.bin.o(.data); }
    .main_802C651C 0x802C651C : AT(0x000C711C) { FILL(0x00000000); build/asm/main_802C651C.s.o(.text); build/asm/main_802C651C.s.o(.rodata); build/asm/main_802C651C.s.o(.data); }
    .main_802C651C_bss (NOLOAD) : { build/asm/main_802C651C.s.o(.bss); }
    .main_802C6528 0x802C6528 : AT(0x000C7128) { build/asm/data/main_802C6528.bin.o(.data); }
    .main_802C7248 0x802C7248 : AT(0x000C7E48) { FILL(0x00000000); build/asm/main_802C7248.s.o(.text); build/asm/main_802C7248.s.o(.rodata); build/asm/main_802C7248.s.o(.data); }
    .main_802C7248_bss (NOLOAD) : { build/asm/main_802C7248.s.o(.bss); }
    .main_802C724C 0x802C724C : AT(0x000C7E4C) { build/asm/data/main_802C724C.bin.o(.data); }
    .main_802CA418 0x802CA418 : AT(0x000CB018) { FILL(0x00000000); build/asm/main_802CA418.s.o(.text); build/asm/main_802CA418.s.o(.rodata); build/asm/main_802CA418.s.o(.data); }
    .main_802CA418_bss (NOLOAD) : { build/asm/main_802CA418.s.o(.bss); }
    .main_802CA428 0x802CA428 : AT(0x000CB028) { build/asm/data/main_802CA428.bin.o(.data); }
    .main_802CC3C8 0x802CC3C8 : AT(0x000CCFC8) { FILL(0x00000000); build/asm/main_802CC3C8.s.o(.text); build/asm/main_802CC3C8.s.o(.rodata); build/asm/main_802CC3C8.s.o(.data); }
    .main_802CC3C8_bss (NOLOAD) : { build/asm/main_802CC3C8.s.o(.bss); }
    .main_802CC46C 0x802CC46C : AT(0x000CD06C) { build/asm/data/main_802CC46C.bin.o(.data); }
    .main_802CC4C4 0x802CC4C4 : AT(0x000CD0C4) { FILL(0x00000000); build/asm/main_802CC4C4.s.o(.text); build/asm/main_802CC4C4.s.o(.rodata); build/asm/main_802CC4C4.s.o(.data); }
    .main_802CC4C4_bss (NOLOAD) : { build/asm/main_802CC4C4.s.o(.bss); }
    .main_802CC4EC 0x802CC4EC : AT(0x000CD0EC) { build/asm/data/main_802CC4EC.bin.o(.data); }
    .main_802D05C8 0x802D05C8 : AT(0x000D11C8) { FILL(0x00000000); build/asm/main_802D05C8.s.o(.text); build/asm/main_802D05C8.s.o(.rodata); build/asm/main_802D05C8.s.o(.data); }
    .main_802D05C8_bss (NOLOAD) : { build/asm/main_802D05C8.s.o(.bss); }
    .main_802D0610 0x802D0610 : AT(0x000D1210) { build/asm/data/main_802D0610.bin.o(.data); }
    .main_802D5C7C 0x802D5C7C : AT(0x000D687C) { FILL(0x00000000); build/asm/main_802D5C7C.s.o(.text); build/asm/main_802D5C7C.s.o(.rodata); build/asm/main_802D5C7C.s.o(.data); }
    .main_802D5C7C_bss (NOLOAD) : { build/asm/main_802D5C7C.s.o(.bss); }
    .main_802D5C8C 0x802D5C8C : AT(0x000D688C) { build/asm/data/main_802D5C8C.bin.o(.data); }
    .main_802D9378 0x802D9378 : AT(0x000D9F78) { FILL(0x00000000); build/asm/main_802D9378.s.o(.text); build/asm/main_802D9378.s.o(.rodata); build/asm/main_802D9378.s.o(.data); }
    .main_802D9378_bss (NOLOAD) : { build/asm/main_802D9378.s.o(.bss); }
    .main_802D93B8 0x802D93B8 : AT(0x000D9FB8) { build/asm/data/main_802D93B8.bin.o(.data); }
    .main_802D9C30 0x802D9C30 : AT(0x000DA830) { FILL(0x00000000); build/asm/main_802D9C30.s.o(.text); build/asm/main_802D9C30.s.o(.rodata); build/asm/main_802D9C30.s.o(.data); }
    .main_802D9C30_bss (NOLOAD) : { build/asm/main_802D9C30.s.o(.bss); }
    .main_802D9C40 0x802D9C40 : AT(0x000DA840) { build/asm/data/main_802D9C40.bin.o(.data); }
    .main_802DA92C 0x802DA92C : AT(0x000DB52C) { FILL(0x00000000); build/asm/main_802DA92C.s.o(.text); build/asm/main_802DA92C.s.o(.rodata); build/asm/main_802DA92C.s.o(.data); }
    .main_802DA92C_bss (NOLOAD) : { build/asm/main_802DA92C.s.o(.bss); }
    .main_802DA950 0x802DA950 : AT(0x000DB550) { build/asm/data/main_802DA950.bin.o(.data); }
    .main_802DC8EC 0x802DC8EC : AT(0x000DD4EC) { FILL(0x00000000); build/asm/main_802DC8EC.s.o(.text); build/asm/main_802DC8EC.s.o(.rodata); build/asm/main_802DC8EC.s.o(.data); }
    .main_802DC8EC_bss (NOLOAD) : { build/asm/main_802DC8EC.s.o(.bss); }
    .main_802DC8F4 0x802DC8F4 : AT(0x000DD4F4) { build/asm/data/main_802DC8F4.bin.o(.data); }
    .main_802E362C 0x802E362C : AT(0x000E422C) { FILL(0x00000000); build/asm/main_802E362C.s.o(.text); build/asm/main_802E362C.s.o(.rodata); build/asm/main_802E362C.s.o(.data); }
    .main_802E362C_bss (NOLOAD) : { build/asm/main_802E362C.s.o(.bss); }
    .main_802E3678 0x802E3678 : AT(0x000E4278) { build/asm/data/main_802E3678.bin.o(.data); }
    .main_802E9140 0x802E9140 : AT(0x000E9D40) { FILL(0x00000000); build/asm/main_802E9140.s.o(.text); build/asm/main_802E9140.s.o(.rodata); build/asm/main_802E9140.s.o(.data); }
    .main_802E9140_bss (NOLOAD) : { build/asm/main_802E9140.s.o(.bss); }
    .main_802E91F4 0x802E91F4 : AT(0x000E9DF4) { build/asm/data/main_802E91F4.bin.o(.data); }
    .main_802E9744 0x802E9744 : AT(0x000EA344) { FILL(0x00000000); build/asm/main_802E9744.s.o(.text); build/asm/main_802E9744.s.o(.rodata); build/asm/main_802E9744.s.o(.data); }
    .main_802E9744_bss (NOLOAD) : { build/asm/main_802E9744.s.o(.bss); }
    .main_802E975C 0x802E975C : AT(0x000EA35C) { build/asm/data/main_802E975C.bin.o(.data); }
    .main_802EFEBC 0x802EFEBC : AT(0x000F0ABC) { FILL(0x00000000); build/asm/main_802EFEBC.s.o(.text); build/asm/main_802EFEBC.s.o(.rodata); build/asm/main_802EFEBC.s.o(.data); }
    .main_802EFEBC_bss (NOLOAD) : { build/asm/main_802EFEBC.s.o(.bss); }
    .main_802EFEDC 0x802EFEDC : AT(0x000F0ADC) { build/asm/data/main_802EFEDC.bin.o(.data); }
    .main_802F4D54 0x802F4D54 : AT(0x000F5954) { FILL(0x00000000); build/asm/main_802F4D54.s.o(.text); build/asm/main_802F4D54.s.o(.rodata); build/asm/main_802F4D54.s.o(.data); }
    .main_802F4D54_bss (NOLOAD) : { build/asm/main_802F4D54.s.o(.bss); }
    .main_802F4D9C 0x802F4D9C : AT(0x000F599C) { build/asm/data/main_802F4D9C.bin.o(.data); }
    .main_802F5498 0x802F5498 : AT(0x000F6098) { FILL(0x00000000); build/asm/main_802F5498.s.o(.text); build/asm/main_802F5498.s.o(.rodata); build/asm/main_802F5498.s.o(.data); }
    .main_802F5498_bss (NOLOAD) : { build/asm/main_802F5498.s.o(.bss); }
    .main_802F54A0 0x802F54A0 : AT(0x000F60A0) { build/asm/data/main_802F54A0.bin.o(.data); }
    .main_802F7BC0 0x802F7BC0 : AT(0x000F87C0) { FILL(0x00000000); build/asm/main_802F7BC0.s.o(.text); build/asm/main_802F7BC0.s.o(.rodata); build/asm/main_802F7BC0.s.o(.data); }
    .main_802F7BC0_bss (NOLOAD) : { build/asm/main_802F7BC0.s.o(.bss); }
    .main_802F7BCC 0x802F7BCC : AT(0x000F87CC) { build/asm/data/main_802F7BCC.bin.o(.data); }
    .main_802F9378 0x802F9378 : AT(0x000F9F78) { FILL(0x00000000); build/asm/main_802F9378.s.o(.text); build/asm/main_802F9378.s.o(.rodata); build/asm/main_802F9378.s.o(.data); }
    .main_802F9378_bss (NOLOAD) : { build/asm/main_802F9378.s.o(.bss); }
    .main_802F9388 0x802F9388 : AT(0x000F9F88) { build/asm/data/main_802F9388.bin.o(.data); }
    .main_802FADCC 0x802FADCC : AT(0x000FB9CC) { FILL(0x00000000); build/asm/main_802FADCC.s.o(.text); build/asm/main_802FADCC.s.o(.rodata); build/asm/main_802FADCC.s.o(.data); }
    .main_802FADCC_bss (NOLOAD) : { build/asm/main_802FADCC.s.o(.bss); }
    .main_802FB754 0x802FB754 : AT(0x000FC354) { build/asm/data/main_802FB754.bin.o(.data); }
    .main_802FFA4C 0x802FFA4C : AT(0x0010064C) { FILL(0x00000000); build/asm/main_802FFA4C.s.o(.text); build/asm/main_802FFA4C.s.o(.rodata); build/asm/main_802FFA4C.s.o(.data); }
    .main_802FFA4C_bss (NOLOAD) : { build/asm/main_802FFA4C.s.o(.bss); }
    .main_802FFB00 0x802FFB00 : AT(0x00100700) { build/asm/data/main_802FFB00.bin.o(.data); }
    .assets 0x80600400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
