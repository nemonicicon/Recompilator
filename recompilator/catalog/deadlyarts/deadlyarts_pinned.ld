SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80027684 0x80027684 : AT(0x00028284) { FILL(0x00000000); build/asm/main_80027684.s.o(.text); build/asm/main_80027684.s.o(.rodata); build/asm/main_80027684.s.o(.data); }
    .main_80027684_bss (NOLOAD) : { build/asm/main_80027684.s.o(.bss); }
    .main_80027A50 0x80027A50 : AT(0x00028650) { FILL(0x00000000); build/asm/main_80027A50.s.o(.text); build/asm/main_80027A50.s.o(.rodata); build/asm/main_80027A50.s.o(.data); }
    .main_80027A50_bss (NOLOAD) : { build/asm/main_80027A50.s.o(.bss); }
    .main_8003230C 0x8003230C : AT(0x00032F0C) { FILL(0x00000000); build/asm/main_8003230C.s.o(.text); build/asm/main_8003230C.s.o(.rodata); build/asm/main_8003230C.s.o(.data); }
    .main_8003230C_bss (NOLOAD) : { build/asm/main_8003230C.s.o(.bss); }
    .main_80033CEC 0x80033CEC : AT(0x000348EC) { build/asm/data/main_80033CEC.bin.o(.data); }
    .main_80038180 0x80038180 : AT(0x00038D80) { FILL(0x00000000); build/asm/main_80038180.s.o(.text); build/asm/main_80038180.s.o(.rodata); build/asm/main_80038180.s.o(.data); }
    .main_80038180_bss (NOLOAD) : { build/asm/main_80038180.s.o(.bss); }
    .main_8003848C 0x8003848C : AT(0x0003908C) { build/asm/data/main_8003848C.bin.o(.data); }
    .main_80038980 0x80038980 : AT(0x00039580) { build/asm/data/main_80038980.bin.o(.data); }
    .main_80038DC4 0x80038DC4 : AT(0x000399C4) { build/asm/data/main_80038DC4.bin.o(.data); }
    .main_80039550 0x80039550 : AT(0x0003A150) { build/asm/data/main_80039550.bin.o(.data); }
    .main_800395CC 0x800395CC : AT(0x0003A1CC) { FILL(0x00000000); build/asm/main_800395CC.s.o(.text); build/asm/main_800395CC.s.o(.rodata); build/asm/main_800395CC.s.o(.data); }
    .main_800395CC_bss (NOLOAD) : { build/asm/main_800395CC.s.o(.bss); }
    .main_80039678 0x80039678 : AT(0x0003A278) { build/asm/data/main_80039678.bin.o(.data); }
    .main_80039F98 0x80039F98 : AT(0x0003AB98) { build/asm/data/main_80039F98.bin.o(.data); }
    .main_8003B644 0x8003B644 : AT(0x0003C244) { FILL(0x00000000); build/asm/main_8003B644.s.o(.text); build/asm/main_8003B644.s.o(.rodata); build/asm/main_8003B644.s.o(.data); }
    .main_8003B644_bss (NOLOAD) : { build/asm/main_8003B644.s.o(.bss); }
    .main_8003B64C 0x8003B64C : AT(0x0003C24C) { build/asm/data/main_8003B64C.bin.o(.data); }
    .main_8003CD5C 0x8003CD5C : AT(0x0003D95C) { FILL(0x00000000); build/asm/main_8003CD5C.s.o(.text); build/asm/main_8003CD5C.s.o(.rodata); build/asm/main_8003CD5C.s.o(.data); }
    .main_8003CD5C_bss (NOLOAD) : { build/asm/main_8003CD5C.s.o(.bss); }
    .main_8003CD64 0x8003CD64 : AT(0x0003D964) { build/asm/data/main_8003CD64.bin.o(.data); }
    .main_8003D7B0 0x8003D7B0 : AT(0x0003E3B0) { build/asm/data/main_8003D7B0.bin.o(.data); }
    .main_8003E514 0x8003E514 : AT(0x0003F114) { FILL(0x00000000); build/asm/main_8003E514.s.o(.text); build/asm/main_8003E514.s.o(.rodata); build/asm/main_8003E514.s.o(.data); }
    .main_8003E514_bss (NOLOAD) : { build/asm/main_8003E514.s.o(.bss); }
    .main_8003E70C 0x8003E70C : AT(0x0003F30C) { build/asm/data/main_8003E70C.bin.o(.data); }
    .main_80040164 0x80040164 : AT(0x00040D64) { build/asm/data/main_80040164.bin.o(.data); }
    .main_800403E0 0x800403E0 : AT(0x00040FE0) { FILL(0x00000000); build/asm/main_800403E0.s.o(.text); build/asm/main_800403E0.s.o(.rodata); build/asm/main_800403E0.s.o(.data); }
    .main_800403E0_bss (NOLOAD) : { build/asm/main_800403E0.s.o(.bss); }
    .main_800403E4 0x800403E4 : AT(0x00040FE4) { build/asm/data/main_800403E4.bin.o(.data); }
    .main_800418F4 0x800418F4 : AT(0x000424F4) { FILL(0x00000000); build/asm/main_800418F4.s.o(.text); build/asm/main_800418F4.s.o(.rodata); build/asm/main_800418F4.s.o(.data); }
    .main_800418F4_bss (NOLOAD) : { build/asm/main_800418F4.s.o(.bss); }
    .main_8004192C 0x8004192C : AT(0x0004252C) { build/asm/data/main_8004192C.bin.o(.data); }
    .main_80044440 0x80044440 : AT(0x00045040) { build/asm/data/main_80044440.bin.o(.data); }
    .main_800444C4 0x800444C4 : AT(0x000450C4) { FILL(0x00000000); build/asm/main_800444C4.s.o(.text); build/asm/main_800444C4.s.o(.rodata); build/asm/main_800444C4.s.o(.data); }
    .main_800444C4_bss (NOLOAD) : { build/asm/main_800444C4.s.o(.bss); }
    .main_80044570 0x80044570 : AT(0x00045170) { FILL(0x00000000); build/asm/main_80044570.s.o(.text); build/asm/main_80044570.s.o(.rodata); build/asm/main_80044570.s.o(.data); }
    .main_80044570_bss (NOLOAD) : { build/asm/main_80044570.s.o(.bss); }
    .main_8004498C 0x8004498C : AT(0x0004558C) { FILL(0x00000000); build/asm/main_8004498C.s.o(.text); build/asm/main_8004498C.s.o(.rodata); build/asm/main_8004498C.s.o(.data); }
    .main_8004498C_bss (NOLOAD) : { build/asm/main_8004498C.s.o(.bss); }
    .main_800449F0 0x800449F0 : AT(0x000455F0) { build/asm/data/main_800449F0.bin.o(.data); }
    .main_80044AAC 0x80044AAC : AT(0x000456AC) { build/asm/data/main_80044AAC.bin.o(.data); }
    .main_800456CC 0x800456CC : AT(0x000462CC) { FILL(0x00000000); build/asm/main_800456CC.s.o(.text); build/asm/main_800456CC.s.o(.rodata); build/asm/main_800456CC.s.o(.data); }
    .main_800456CC_bss (NOLOAD) : { build/asm/main_800456CC.s.o(.bss); }
    .main_8004577C 0x8004577C : AT(0x0004637C) { FILL(0x00000000); build/asm/main_8004577C.s.o(.text); build/asm/main_8004577C.s.o(.rodata); build/asm/main_8004577C.s.o(.data); }
    .main_8004577C_bss (NOLOAD) : { build/asm/main_8004577C.s.o(.bss); }
    .main_80045984 0x80045984 : AT(0x00046584) { FILL(0x00000000); build/asm/main_80045984.s.o(.text); build/asm/main_80045984.s.o(.rodata); build/asm/main_80045984.s.o(.data); }
    .main_80045984_bss (NOLOAD) : { build/asm/main_80045984.s.o(.bss); }
    .main_80045AC0 0x80045AC0 : AT(0x000466C0) { build/asm/data/main_80045AC0.bin.o(.data); }
    .main_80045D00 0x80045D00 : AT(0x00046900) { build/asm/data/main_80045D00.bin.o(.data); }
    .main_80045FC4 0x80045FC4 : AT(0x00046BC4) { build/asm/data/main_80045FC4.bin.o(.data); }
    .main_800464DC 0x800464DC : AT(0x000470DC) { build/asm/data/main_800464DC.bin.o(.data); }
    .main_80046D28 0x80046D28 : AT(0x00047928) { FILL(0x00000000); build/asm/main_80046D28.s.o(.text); build/asm/main_80046D28.s.o(.rodata); build/asm/main_80046D28.s.o(.data); }
    .main_80046D28_bss (NOLOAD) : { build/asm/main_80046D28.s.o(.bss); }
    .main_80046D94 0x80046D94 : AT(0x00047994) { build/asm/data/main_80046D94.bin.o(.data); }
    .main_8004774C 0x8004774C : AT(0x0004834C) { FILL(0x00000000); build/asm/main_8004774C.s.o(.text); build/asm/main_8004774C.s.o(.rodata); build/asm/main_8004774C.s.o(.data); }
    .main_8004774C_bss (NOLOAD) : { build/asm/main_8004774C.s.o(.bss); }
    .main_800477DC 0x800477DC : AT(0x000483DC) { build/asm/data/main_800477DC.bin.o(.data); }
    .main_8004876C 0x8004876C : AT(0x0004936C) { FILL(0x00000000); build/asm/main_8004876C.s.o(.text); build/asm/main_8004876C.s.o(.rodata); build/asm/main_8004876C.s.o(.data); }
    .main_8004876C_bss (NOLOAD) : { build/asm/main_8004876C.s.o(.bss); }
    .main_8004879C 0x8004879C : AT(0x0004939C) { build/asm/data/main_8004879C.bin.o(.data); }
    .main_8004A294 0x8004A294 : AT(0x0004AE94) { FILL(0x00000000); build/asm/main_8004A294.s.o(.text); build/asm/main_8004A294.s.o(.rodata); build/asm/main_8004A294.s.o(.data); }
    .main_8004A294_bss (NOLOAD) : { build/asm/main_8004A294.s.o(.bss); }
    .main_8004A2D8 0x8004A2D8 : AT(0x0004AED8) { build/asm/data/main_8004A2D8.bin.o(.data); }
    .main_8004A54C 0x8004A54C : AT(0x0004B14C) { FILL(0x00000000); build/asm/main_8004A54C.s.o(.text); build/asm/main_8004A54C.s.o(.rodata); build/asm/main_8004A54C.s.o(.data); }
    .main_8004A54C_bss (NOLOAD) : { build/asm/main_8004A54C.s.o(.bss); }
    .main_8004A578 0x8004A578 : AT(0x0004B178) { build/asm/data/main_8004A578.bin.o(.data); }
    .main_8004A9AC 0x8004A9AC : AT(0x0004B5AC) { FILL(0x00000000); build/asm/main_8004A9AC.s.o(.text); build/asm/main_8004A9AC.s.o(.rodata); build/asm/main_8004A9AC.s.o(.data); }
    .main_8004A9AC_bss (NOLOAD) : { build/asm/main_8004A9AC.s.o(.bss); }
    .main_8004A9F4 0x8004A9F4 : AT(0x0004B5F4) { build/asm/data/main_8004A9F4.bin.o(.data); }
    .main_8004C15C 0x8004C15C : AT(0x0004CD5C) { FILL(0x00000000); build/asm/main_8004C15C.s.o(.text); build/asm/main_8004C15C.s.o(.rodata); build/asm/main_8004C15C.s.o(.data); }
    .main_8004C15C_bss (NOLOAD) : { build/asm/main_8004C15C.s.o(.bss); }
    .main_8004C170 0x8004C170 : AT(0x0004CD70) { build/asm/data/main_8004C170.bin.o(.data); }
    .main_8004C22C 0x8004C22C : AT(0x0004CE2C) { FILL(0x00000000); build/asm/main_8004C22C.s.o(.text); build/asm/main_8004C22C.s.o(.rodata); build/asm/main_8004C22C.s.o(.data); }
    .main_8004C22C_bss (NOLOAD) : { build/asm/main_8004C22C.s.o(.bss); }
    .main_8004C284 0x8004C284 : AT(0x0004CE84) { build/asm/data/main_8004C284.bin.o(.data); }
    .main_8007AE60 0x8007AE60 : AT(0x0007BA60) { FILL(0x00000000); build/asm/main_8007AE60.s.o(.text); build/asm/main_8007AE60.s.o(.rodata); build/asm/main_8007AE60.s.o(.data); }
    .main_8007AE60_bss (NOLOAD) : { build/asm/main_8007AE60.s.o(.bss); }
    .main_8007AEC8 0x8007AEC8 : AT(0x0007BAC8) { build/asm/data/main_8007AEC8.bin.o(.data); }
    .main_8007B148 0x8007B148 : AT(0x0007BD48) { FILL(0x00000000); build/asm/main_8007B148.s.o(.text); build/asm/main_8007B148.s.o(.rodata); build/asm/main_8007B148.s.o(.data); }
    .main_8007B148_bss (NOLOAD) : { build/asm/main_8007B148.s.o(.bss); }
    .main_8007B1B0 0x8007B1B0 : AT(0x0007BDB0) { build/asm/data/main_8007B1B0.bin.o(.data); }
    .main_8007B21C 0x8007B21C : AT(0x0007BE1C) { FILL(0x00000000); build/asm/main_8007B21C.s.o(.text); build/asm/main_8007B21C.s.o(.rodata); build/asm/main_8007B21C.s.o(.data); }
    .main_8007B21C_bss (NOLOAD) : { build/asm/main_8007B21C.s.o(.bss); }
    .main_8007B230 0x8007B230 : AT(0x0007BE30) { build/asm/data/main_8007B230.bin.o(.data); }
    .main_8007C7DC 0x8007C7DC : AT(0x0007D3DC) { FILL(0x00000000); build/asm/main_8007C7DC.s.o(.text); build/asm/main_8007C7DC.s.o(.rodata); build/asm/main_8007C7DC.s.o(.data); }
    .main_8007C7DC_bss (NOLOAD) : { build/asm/main_8007C7DC.s.o(.bss); }
    .main_8007C860 0x8007C860 : AT(0x0007D460) { build/asm/data/main_8007C860.bin.o(.data); }
    .main_800827D8 0x800827D8 : AT(0x000833D8) { FILL(0x00000000); build/asm/main_800827D8.s.o(.text); build/asm/main_800827D8.s.o(.rodata); build/asm/main_800827D8.s.o(.data); }
    .main_800827D8_bss (NOLOAD) : { build/asm/main_800827D8.s.o(.bss); }
    .main_80082808 0x80082808 : AT(0x00083408) { build/asm/data/main_80082808.bin.o(.data); }
    .main_80085170 0x80085170 : AT(0x00085D70) { FILL(0x00000000); build/asm/main_80085170.s.o(.text); build/asm/main_80085170.s.o(.rodata); build/asm/main_80085170.s.o(.data); }
    .main_80085170_bss (NOLOAD) : { build/asm/main_80085170.s.o(.bss); }
    .main_80085178 0x80085178 : AT(0x00085D78) { build/asm/data/main_80085178.bin.o(.data); }
    .main_800883BC 0x800883BC : AT(0x00088FBC) { FILL(0x00000000); build/asm/main_800883BC.s.o(.text); build/asm/main_800883BC.s.o(.rodata); build/asm/main_800883BC.s.o(.data); }
    .main_800883BC_bss (NOLOAD) : { build/asm/main_800883BC.s.o(.bss); }
    .main_800883D0 0x800883D0 : AT(0x00088FD0) { build/asm/data/main_800883D0.bin.o(.data); }
    .main_800937AC 0x800937AC : AT(0x000943AC) { FILL(0x00000000); build/asm/main_800937AC.s.o(.text); build/asm/main_800937AC.s.o(.rodata); build/asm/main_800937AC.s.o(.data); }
    .main_800937AC_bss (NOLOAD) : { build/asm/main_800937AC.s.o(.bss); }
    .main_80093F08 0x80093F08 : AT(0x00094B08) { build/asm/data/main_80093F08.bin.o(.data); }
    .main_80094698 0x80094698 : AT(0x00095298) { FILL(0x00000000); build/asm/main_80094698.s.o(.text); build/asm/main_80094698.s.o(.rodata); build/asm/main_80094698.s.o(.data); }
    .main_80094698_bss (NOLOAD) : { build/asm/main_80094698.s.o(.bss); }
    .main_80094720 0x80094720 : AT(0x00095320) { build/asm/data/main_80094720.bin.o(.data); }
    .main_80096CE8 0x80096CE8 : AT(0x000978E8) { build/asm/data/main_80096CE8.bin.o(.data); }
    .main_80097EFC 0x80097EFC : AT(0x00098AFC) { build/asm/data/main_80097EFC.bin.o(.data); }
    .main_80099954 0x80099954 : AT(0x0009A554) { build/asm/data/main_80099954.bin.o(.data); }
    .main_8009A9BC 0x8009A9BC : AT(0x0009B5BC) { build/asm/data/main_8009A9BC.bin.o(.data); }
    .main_8009DCC0 0x8009DCC0 : AT(0x0009E8C0) { build/asm/data/main_8009DCC0.bin.o(.data); }
    .main_8009EA50 0x8009EA50 : AT(0x0009F650) { FILL(0x00000000); build/asm/main_8009EA50.s.o(.text); build/asm/main_8009EA50.s.o(.rodata); build/asm/main_8009EA50.s.o(.data); }
    .main_8009EA50_bss (NOLOAD) : { build/asm/main_8009EA50.s.o(.bss); }
    .main_8009EA5C 0x8009EA5C : AT(0x0009F65C) { build/asm/data/main_8009EA5C.bin.o(.data); }
    .main_800AB694 0x800AB694 : AT(0x000AC294) { FILL(0x00000000); build/asm/main_800AB694.s.o(.text); build/asm/main_800AB694.s.o(.rodata); build/asm/main_800AB694.s.o(.data); }
    .main_800AB694_bss (NOLOAD) : { build/asm/main_800AB694.s.o(.bss); }
    .main_800AB6AC 0x800AB6AC : AT(0x000AC2AC) { build/asm/data/main_800AB6AC.bin.o(.data); }
    .main_800B5574 0x800B5574 : AT(0x000B6174) { FILL(0x00000000); build/asm/main_800B5574.s.o(.text); build/asm/main_800B5574.s.o(.rodata); build/asm/main_800B5574.s.o(.data); }
    .main_800B5574_bss (NOLOAD) : { build/asm/main_800B5574.s.o(.bss); }
    .main_800B557C 0x800B557C : AT(0x000B617C) { build/asm/data/main_800B557C.bin.o(.data); }
    .main_800C3654 0x800C3654 : AT(0x000C4254) { FILL(0x00000000); build/asm/main_800C3654.s.o(.text); build/asm/main_800C3654.s.o(.rodata); build/asm/main_800C3654.s.o(.data); }
    .main_800C3654_bss (NOLOAD) : { build/asm/main_800C3654.s.o(.bss); }
    .main_800C366C 0x800C366C : AT(0x000C426C) { build/asm/data/main_800C366C.bin.o(.data); }
    .main_800D48EC 0x800D48EC : AT(0x000D54EC) { FILL(0x00000000); build/asm/main_800D48EC.s.o(.text); build/asm/main_800D48EC.s.o(.rodata); build/asm/main_800D48EC.s.o(.data); }
    .main_800D48EC_bss (NOLOAD) : { build/asm/main_800D48EC.s.o(.bss); }
    .main_800D4934 0x800D4934 : AT(0x000D5534) { build/asm/data/main_800D4934.bin.o(.data); }
    .main_800E3AA4 0x800E3AA4 : AT(0x000E46A4) { FILL(0x00000000); build/asm/main_800E3AA4.s.o(.text); build/asm/main_800E3AA4.s.o(.rodata); build/asm/main_800E3AA4.s.o(.data); }
    .main_800E3AA4_bss (NOLOAD) : { build/asm/main_800E3AA4.s.o(.bss); }
    .main_800E3B54 0x800E3B54 : AT(0x000E4754) { build/asm/data/main_800E3B54.bin.o(.data); }
    .main_800E70CC 0x800E70CC : AT(0x000E7CCC) { FILL(0x00000000); build/asm/main_800E70CC.s.o(.text); build/asm/main_800E70CC.s.o(.rodata); build/asm/main_800E70CC.s.o(.data); }
    .main_800E70CC_bss (NOLOAD) : { build/asm/main_800E70CC.s.o(.bss); }
    .main_800E70DC 0x800E70DC : AT(0x000E7CDC) { build/asm/data/main_800E70DC.bin.o(.data); }
    .main_800EF068 0x800EF068 : AT(0x000EFC68) { FILL(0x00000000); build/asm/main_800EF068.s.o(.text); build/asm/main_800EF068.s.o(.rodata); build/asm/main_800EF068.s.o(.data); }
    .main_800EF068_bss (NOLOAD) : { build/asm/main_800EF068.s.o(.bss); }
    .main_800EF0D4 0x800EF0D4 : AT(0x000EFCD4) { build/asm/data/main_800EF0D4.bin.o(.data); }
    .main_800F25D8 0x800F25D8 : AT(0x000F31D8) { FILL(0x00000000); build/asm/main_800F25D8.s.o(.text); build/asm/main_800F25D8.s.o(.rodata); build/asm/main_800F25D8.s.o(.data); }
    .main_800F25D8_bss (NOLOAD) : { build/asm/main_800F25D8.s.o(.bss); }
    .main_800F25E8 0x800F25E8 : AT(0x000F31E8) { build/asm/data/main_800F25E8.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
