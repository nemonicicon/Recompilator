SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000E64 0x80000E64 : AT(0x00001A64) { FILL(0x00000000); build/asm/main_80000E64.s.o(.text); build/asm/main_80000E64.s.o(.rodata); build/asm/main_80000E64.s.o(.data); }
    .main_80000E64_bss (NOLOAD) : { build/asm/main_80000E64.s.o(.bss); }
    .main_80001088 0x80001088 : AT(0x00001C88) { FILL(0x00000000); build/asm/main_80001088.s.o(.text); build/asm/main_80001088.s.o(.rodata); build/asm/main_80001088.s.o(.data); }
    .main_80001088_bss (NOLOAD) : { build/asm/main_80001088.s.o(.bss); }
    .main_800013C0 0x800013C0 : AT(0x00001FC0) { FILL(0x00000000); build/asm/main_800013C0.s.o(.text); build/asm/main_800013C0.s.o(.rodata); build/asm/main_800013C0.s.o(.data); }
    .main_800013C0_bss (NOLOAD) : { build/asm/main_800013C0.s.o(.bss); }
    .main_80001764 0x80001764 : AT(0x00002364) { build/asm/data/main_80001764.bin.o(.data); }
    .main_80001FB4 0x80001FB4 : AT(0x00002BB4) { FILL(0x00000000); build/asm/main_80001FB4.s.o(.text); build/asm/main_80001FB4.s.o(.rodata); build/asm/main_80001FB4.s.o(.data); }
    .main_80001FB4_bss (NOLOAD) : { build/asm/main_80001FB4.s.o(.bss); }
    .main_80001FD8 0x80001FD8 : AT(0x00002BD8) { build/asm/data/main_80001FD8.bin.o(.data); }
    .main_8000339C 0x8000339C : AT(0x00003F9C) { FILL(0x00000000); build/asm/main_8000339C.s.o(.text); build/asm/main_8000339C.s.o(.rodata); build/asm/main_8000339C.s.o(.data); }
    .main_8000339C_bss (NOLOAD) : { build/asm/main_8000339C.s.o(.bss); }
    .main_8000388C 0x8000388C : AT(0x0000448C) { FILL(0x00000000); build/asm/main_8000388C.s.o(.text); build/asm/main_8000388C.s.o(.rodata); build/asm/main_8000388C.s.o(.data); }
    .main_8000388C_bss (NOLOAD) : { build/asm/main_8000388C.s.o(.bss); }
    .main_80006544 0x80006544 : AT(0x00007144) { FILL(0x00000000); build/asm/main_80006544.s.o(.text); build/asm/main_80006544.s.o(.rodata); build/asm/main_80006544.s.o(.data); }
    .main_80006544_bss (NOLOAD) : { build/asm/main_80006544.s.o(.bss); }
    .main_8000AC40 0x8000AC40 : AT(0x0000B840) { FILL(0x00000000); build/asm/main_8000AC40.s.o(.text); build/asm/main_8000AC40.s.o(.rodata); build/asm/main_8000AC40.s.o(.data); }
    .main_8000AC40_bss (NOLOAD) : { build/asm/main_8000AC40.s.o(.bss); }
    .main_8000B814 0x8000B814 : AT(0x0000C414) { FILL(0x00000000); build/asm/main_8000B814.s.o(.text); build/asm/main_8000B814.s.o(.rodata); build/asm/main_8000B814.s.o(.data); }
    .main_8000B814_bss (NOLOAD) : { build/asm/main_8000B814.s.o(.bss); }
    .main_8000BBF0 0x8000BBF0 : AT(0x0000C7F0) { FILL(0x00000000); build/asm/main_8000BBF0.s.o(.text); build/asm/main_8000BBF0.s.o(.rodata); build/asm/main_8000BBF0.s.o(.data); }
    .main_8000BBF0_bss (NOLOAD) : { build/asm/main_8000BBF0.s.o(.bss); }
    .main_8000C2A0 0x8000C2A0 : AT(0x0000CEA0) { FILL(0x00000000); build/asm/main_8000C2A0.s.o(.text); build/asm/main_8000C2A0.s.o(.rodata); build/asm/main_8000C2A0.s.o(.data); }
    .main_8000C2A0_bss (NOLOAD) : { build/asm/main_8000C2A0.s.o(.bss); }
    .main_8000D830 0x8000D830 : AT(0x0000E430) { FILL(0x00000000); build/asm/main_8000D830.s.o(.text); build/asm/main_8000D830.s.o(.rodata); build/asm/main_8000D830.s.o(.data); }
    .main_8000D830_bss (NOLOAD) : { build/asm/main_8000D830.s.o(.bss); }
    .main_800118F0 0x800118F0 : AT(0x000124F0) { FILL(0x00000000); build/asm/main_800118F0.s.o(.text); build/asm/main_800118F0.s.o(.rodata); build/asm/main_800118F0.s.o(.data); }
    .main_800118F0_bss (NOLOAD) : { build/asm/main_800118F0.s.o(.bss); }
    .main_80011AF4 0x80011AF4 : AT(0x000126F4) { FILL(0x00000000); build/asm/main_80011AF4.s.o(.text); build/asm/main_80011AF4.s.o(.rodata); build/asm/main_80011AF4.s.o(.data); }
    .main_80011AF4_bss (NOLOAD) : { build/asm/main_80011AF4.s.o(.bss); }
    .main_80012B90 0x80012B90 : AT(0x00013790) { FILL(0x00000000); build/asm/main_80012B90.s.o(.text); build/asm/main_80012B90.s.o(.rodata); build/asm/main_80012B90.s.o(.data); }
    .main_80012B90_bss (NOLOAD) : { build/asm/main_80012B90.s.o(.bss); }
    .main_800143DC 0x800143DC : AT(0x00014FDC) { FILL(0x00000000); build/asm/main_800143DC.s.o(.text); build/asm/main_800143DC.s.o(.rodata); build/asm/main_800143DC.s.o(.data); }
    .main_800143DC_bss (NOLOAD) : { build/asm/main_800143DC.s.o(.bss); }
    .main_8001575C 0x8001575C : AT(0x0001635C) { FILL(0x00000000); build/asm/main_8001575C.s.o(.text); build/asm/main_8001575C.s.o(.rodata); build/asm/main_8001575C.s.o(.data); }
    .main_8001575C_bss (NOLOAD) : { build/asm/main_8001575C.s.o(.bss); }
    .main_80016720 0x80016720 : AT(0x00017320) { FILL(0x00000000); build/asm/main_80016720.s.o(.text); build/asm/main_80016720.s.o(.rodata); build/asm/main_80016720.s.o(.data); }
    .main_80016720_bss (NOLOAD) : { build/asm/main_80016720.s.o(.bss); }
    .main_80016C3C 0x80016C3C : AT(0x0001783C) { FILL(0x00000000); build/asm/main_80016C3C.s.o(.text); build/asm/main_80016C3C.s.o(.rodata); build/asm/main_80016C3C.s.o(.data); }
    .main_80016C3C_bss (NOLOAD) : { build/asm/main_80016C3C.s.o(.bss); }
    .main_80016DDC 0x80016DDC : AT(0x000179DC) { FILL(0x00000000); build/asm/main_80016DDC.s.o(.text); build/asm/main_80016DDC.s.o(.rodata); build/asm/main_80016DDC.s.o(.data); }
    .main_80016DDC_bss (NOLOAD) : { build/asm/main_80016DDC.s.o(.bss); }
    .main_80016F50 0x80016F50 : AT(0x00017B50) { FILL(0x00000000); build/asm/main_80016F50.s.o(.text); build/asm/main_80016F50.s.o(.rodata); build/asm/main_80016F50.s.o(.data); }
    .main_80016F50_bss (NOLOAD) : { build/asm/main_80016F50.s.o(.bss); }
    .main_80017080 0x80017080 : AT(0x00017C80) { FILL(0x00000000); build/asm/main_80017080.s.o(.text); build/asm/main_80017080.s.o(.rodata); build/asm/main_80017080.s.o(.data); }
    .main_80017080_bss (NOLOAD) : { build/asm/main_80017080.s.o(.bss); }
    .main_80019958 0x80019958 : AT(0x0001A558) { FILL(0x00000000); build/asm/main_80019958.s.o(.text); build/asm/main_80019958.s.o(.rodata); build/asm/main_80019958.s.o(.data); }
    .main_80019958_bss (NOLOAD) : { build/asm/main_80019958.s.o(.bss); }
    .main_80019BE0 0x80019BE0 : AT(0x0001A7E0) { FILL(0x00000000); build/asm/main_80019BE0.s.o(.text); build/asm/main_80019BE0.s.o(.rodata); build/asm/main_80019BE0.s.o(.data); }
    .main_80019BE0_bss (NOLOAD) : { build/asm/main_80019BE0.s.o(.bss); }
    .main_80019E68 0x80019E68 : AT(0x0001AA68) { FILL(0x00000000); build/asm/main_80019E68.s.o(.text); build/asm/main_80019E68.s.o(.rodata); build/asm/main_80019E68.s.o(.data); }
    .main_80019E68_bss (NOLOAD) : { build/asm/main_80019E68.s.o(.bss); }
    .main_8001A0F0 0x8001A0F0 : AT(0x0001ACF0) { build/asm/data/main_8001A0F0.bin.o(.data); }
    .main_8001A378 0x8001A378 : AT(0x0001AF78) { build/asm/data/main_8001A378.bin.o(.data); }
    .main_8001A600 0x8001A600 : AT(0x0001B200) { build/asm/data/main_8001A600.bin.o(.data); }
    .main_8001CABC 0x8001CABC : AT(0x0001D6BC) { build/asm/data/main_8001CABC.bin.o(.data); }
    .main_8001DE00 0x8001DE00 : AT(0x0001EA00) { FILL(0x00000000); build/asm/main_8001DE00.s.o(.text); build/asm/main_8001DE00.s.o(.rodata); build/asm/main_8001DE00.s.o(.data); }
    .main_8001DE00_bss (NOLOAD) : { build/asm/main_8001DE00.s.o(.bss); }
    .main_8001E330 0x8001E330 : AT(0x0001EF30) { FILL(0x00000000); build/asm/main_8001E330.s.o(.text); build/asm/main_8001E330.s.o(.rodata); build/asm/main_8001E330.s.o(.data); }
    .main_8001E330_bss (NOLOAD) : { build/asm/main_8001E330.s.o(.bss); }
    .main_800221F0 0x800221F0 : AT(0x00022DF0) { FILL(0x00000000); build/asm/main_800221F0.s.o(.text); build/asm/main_800221F0.s.o(.rodata); build/asm/main_800221F0.s.o(.data); }
    .main_800221F0_bss (NOLOAD) : { build/asm/main_800221F0.s.o(.bss); }
    .main_800601A4 0x800601A4 : AT(0x00060DA4) { FILL(0x00000000); build/asm/main_800601A4.s.o(.text); build/asm/main_800601A4.s.o(.rodata); build/asm/main_800601A4.s.o(.data); }
    .main_800601A4_bss (NOLOAD) : { build/asm/main_800601A4.s.o(.bss); }
    .main_8006B430 0x8006B430 : AT(0x0006C030) { FILL(0x00000000); build/asm/main_8006B430.s.o(.text); build/asm/main_8006B430.s.o(.rodata); build/asm/main_8006B430.s.o(.data); }
    .main_8006B430_bss (NOLOAD) : { build/asm/main_8006B430.s.o(.bss); }
    .main_8006FFD4 0x8006FFD4 : AT(0x00070BD4) { FILL(0x00000000); build/asm/main_8006FFD4.s.o(.text); build/asm/main_8006FFD4.s.o(.rodata); build/asm/main_8006FFD4.s.o(.data); }
    .main_8006FFD4_bss (NOLOAD) : { build/asm/main_8006FFD4.s.o(.bss); }
    .main_80073DA8 0x80073DA8 : AT(0x000749A8) { FILL(0x00000000); build/asm/main_80073DA8.s.o(.text); build/asm/main_80073DA8.s.o(.rodata); build/asm/main_80073DA8.s.o(.data); }
    .main_80073DA8_bss (NOLOAD) : { build/asm/main_80073DA8.s.o(.bss); }
    .main_8007DA04 0x8007DA04 : AT(0x0007E604) { FILL(0x00000000); build/asm/main_8007DA04.s.o(.text); build/asm/main_8007DA04.s.o(.rodata); build/asm/main_8007DA04.s.o(.data); }
    .main_8007DA04_bss (NOLOAD) : { build/asm/main_8007DA04.s.o(.bss); }
    .main_800946A4 0x800946A4 : AT(0x000952A4) { FILL(0x00000000); build/asm/main_800946A4.s.o(.text); build/asm/main_800946A4.s.o(.rodata); build/asm/main_800946A4.s.o(.data); }
    .main_800946A4_bss (NOLOAD) : { build/asm/main_800946A4.s.o(.bss); }
    .main_80095440 0x80095440 : AT(0x00096040) { FILL(0x00000000); build/asm/main_80095440.s.o(.text); build/asm/main_80095440.s.o(.rodata); build/asm/main_80095440.s.o(.data); }
    .main_80095440_bss (NOLOAD) : { build/asm/main_80095440.s.o(.bss); }
    .main_800974E0 0x800974E0 : AT(0x000980E0) { FILL(0x00000000); build/asm/main_800974E0.s.o(.text); build/asm/main_800974E0.s.o(.rodata); build/asm/main_800974E0.s.o(.data); }
    .main_800974E0_bss (NOLOAD) : { build/asm/main_800974E0.s.o(.bss); }
    .main_800995F8 0x800995F8 : AT(0x0009A1F8) { FILL(0x00000000); build/asm/main_800995F8.s.o(.text); build/asm/main_800995F8.s.o(.rodata); build/asm/main_800995F8.s.o(.data); }
    .main_800995F8_bss (NOLOAD) : { build/asm/main_800995F8.s.o(.bss); }
    .main_800A53C4 0x800A53C4 : AT(0x000A5FC4) { FILL(0x00000000); build/asm/main_800A53C4.s.o(.text); build/asm/main_800A53C4.s.o(.rodata); build/asm/main_800A53C4.s.o(.data); }
    .main_800A53C4_bss (NOLOAD) : { build/asm/main_800A53C4.s.o(.bss); }
    .main_800A8DCC 0x800A8DCC : AT(0x000A99CC) { build/asm/data/main_800A8DCC.bin.o(.data); }
    .main_800AEBB8 0x800AEBB8 : AT(0x000AF7B8) { FILL(0x00000000); build/asm/main_800AEBB8.s.o(.text); build/asm/main_800AEBB8.s.o(.rodata); build/asm/main_800AEBB8.s.o(.data); }
    .main_800AEBB8_bss (NOLOAD) : { build/asm/main_800AEBB8.s.o(.bss); }
    .main_800B0B68 0x800B0B68 : AT(0x000B1768) { FILL(0x00000000); build/asm/main_800B0B68.s.o(.text); build/asm/main_800B0B68.s.o(.rodata); build/asm/main_800B0B68.s.o(.data); }
    .main_800B0B68_bss (NOLOAD) : { build/asm/main_800B0B68.s.o(.bss); }
    .main_800B2BD4 0x800B2BD4 : AT(0x000B37D4) { build/asm/data/main_800B2BD4.bin.o(.data); }
    .main_800B7D94 0x800B7D94 : AT(0x000B8994) { FILL(0x00000000); build/asm/main_800B7D94.s.o(.text); build/asm/main_800B7D94.s.o(.rodata); build/asm/main_800B7D94.s.o(.data); }
    .main_800B7D94_bss (NOLOAD) : { build/asm/main_800B7D94.s.o(.bss); }
    .main_800B7DD0 0x800B7DD0 : AT(0x000B89D0) { build/asm/data/main_800B7DD0.bin.o(.data); }
    .main_800B86FC 0x800B86FC : AT(0x000B92FC) { FILL(0x00000000); build/asm/main_800B86FC.s.o(.text); build/asm/main_800B86FC.s.o(.rodata); build/asm/main_800B86FC.s.o(.data); }
    .main_800B86FC_bss (NOLOAD) : { build/asm/main_800B86FC.s.o(.bss); }
    .main_800B8824 0x800B8824 : AT(0x000B9424) { build/asm/data/main_800B8824.bin.o(.data); }
    .main_800B8B6C 0x800B8B6C : AT(0x000B976C) { FILL(0x00000000); build/asm/main_800B8B6C.s.o(.text); build/asm/main_800B8B6C.s.o(.rodata); build/asm/main_800B8B6C.s.o(.data); }
    .main_800B8B6C_bss (NOLOAD) : { build/asm/main_800B8B6C.s.o(.bss); }
    .main_800B9E64 0x800B9E64 : AT(0x000BAA64) { FILL(0x00000000); build/asm/main_800B9E64.s.o(.text); build/asm/main_800B9E64.s.o(.rodata); build/asm/main_800B9E64.s.o(.data); }
    .main_800B9E64_bss (NOLOAD) : { build/asm/main_800B9E64.s.o(.bss); }
    .main_800BA0BC 0x800BA0BC : AT(0x000BACBC) { FILL(0x00000000); build/asm/main_800BA0BC.s.o(.text); build/asm/main_800BA0BC.s.o(.rodata); build/asm/main_800BA0BC.s.o(.data); }
    .main_800BA0BC_bss (NOLOAD) : { build/asm/main_800BA0BC.s.o(.bss); }
    .main_800BA930 0x800BA930 : AT(0x000BB530) { FILL(0x00000000); build/asm/main_800BA930.s.o(.text); build/asm/main_800BA930.s.o(.rodata); build/asm/main_800BA930.s.o(.data); }
    .main_800BA930_bss (NOLOAD) : { build/asm/main_800BA930.s.o(.bss); }
    .main_800BB91C 0x800BB91C : AT(0x000BC51C) { build/asm/data/main_800BB91C.bin.o(.data); }
    .main_800BC064 0x800BC064 : AT(0x000BCC64) { FILL(0x00000000); build/asm/main_800BC064.s.o(.text); build/asm/main_800BC064.s.o(.rodata); build/asm/main_800BC064.s.o(.data); }
    .main_800BC064_bss (NOLOAD) : { build/asm/main_800BC064.s.o(.bss); }
    .main_800BC118 0x800BC118 : AT(0x000BCD18) { FILL(0x00000000); build/asm/main_800BC118.s.o(.text); build/asm/main_800BC118.s.o(.rodata); build/asm/main_800BC118.s.o(.data); }
    .main_800BC118_bss (NOLOAD) : { build/asm/main_800BC118.s.o(.bss); }
    .main_800BC1F8 0x800BC1F8 : AT(0x000BCDF8) { build/asm/data/main_800BC1F8.bin.o(.data); }
    .main_800BC894 0x800BC894 : AT(0x000BD494) { FILL(0x00000000); build/asm/main_800BC894.s.o(.text); build/asm/main_800BC894.s.o(.rodata); build/asm/main_800BC894.s.o(.data); }
    .main_800BC894_bss (NOLOAD) : { build/asm/main_800BC894.s.o(.bss); }
    .main_800BD6A4 0x800BD6A4 : AT(0x000BE2A4) { FILL(0x00000000); build/asm/main_800BD6A4.s.o(.text); build/asm/main_800BD6A4.s.o(.rodata); build/asm/main_800BD6A4.s.o(.data); }
    .main_800BD6A4_bss (NOLOAD) : { build/asm/main_800BD6A4.s.o(.bss); }
    .main_800BDD34 0x800BDD34 : AT(0x000BE934) { FILL(0x00000000); build/asm/main_800BDD34.s.o(.text); build/asm/main_800BDD34.s.o(.rodata); build/asm/main_800BDD34.s.o(.data); }
    .main_800BDD34_bss (NOLOAD) : { build/asm/main_800BDD34.s.o(.bss); }
    .main_800BDE9C 0x800BDE9C : AT(0x000BEA9C) { build/asm/data/main_800BDE9C.bin.o(.data); }
    .main_800BE260 0x800BE260 : AT(0x000BEE60) { FILL(0x00000000); build/asm/main_800BE260.s.o(.text); build/asm/main_800BE260.s.o(.rodata); build/asm/main_800BE260.s.o(.data); }
    .main_800BE260_bss (NOLOAD) : { build/asm/main_800BE260.s.o(.bss); }
    .main_800BEA5C 0x800BEA5C : AT(0x000BF65C) { build/asm/data/main_800BEA5C.bin.o(.data); }
    .main_800BEDD8 0x800BEDD8 : AT(0x000BF9D8) { FILL(0x00000000); build/asm/main_800BEDD8.s.o(.text); build/asm/main_800BEDD8.s.o(.rodata); build/asm/main_800BEDD8.s.o(.data); }
    .main_800BEDD8_bss (NOLOAD) : { build/asm/main_800BEDD8.s.o(.bss); }
    .main_800BF06C 0x800BF06C : AT(0x000BFC6C) { FILL(0x00000000); build/asm/main_800BF06C.s.o(.text); build/asm/main_800BF06C.s.o(.rodata); build/asm/main_800BF06C.s.o(.data); }
    .main_800BF06C_bss (NOLOAD) : { build/asm/main_800BF06C.s.o(.bss); }
    .main_800BFA08 0x800BFA08 : AT(0x000C0608) { build/asm/data/main_800BFA08.bin.o(.data); }
    .main_800BFB34 0x800BFB34 : AT(0x000C0734) { FILL(0x00000000); build/asm/main_800BFB34.s.o(.text); build/asm/main_800BFB34.s.o(.rodata); build/asm/main_800BFB34.s.o(.data); }
    .main_800BFB34_bss (NOLOAD) : { build/asm/main_800BFB34.s.o(.bss); }
    .main_800C000C 0x800C000C : AT(0x000C0C0C) { FILL(0x00000000); build/asm/main_800C000C.s.o(.text); build/asm/main_800C000C.s.o(.rodata); build/asm/main_800C000C.s.o(.data); }
    .main_800C000C_bss (NOLOAD) : { build/asm/main_800C000C.s.o(.bss); }
    .main_800C024C 0x800C024C : AT(0x000C0E4C) { FILL(0x00000000); build/asm/main_800C024C.s.o(.text); build/asm/main_800C024C.s.o(.rodata); build/asm/main_800C024C.s.o(.data); }
    .main_800C024C_bss (NOLOAD) : { build/asm/main_800C024C.s.o(.bss); }
    .main_800C041C 0x800C041C : AT(0x000C101C) { FILL(0x00000000); build/asm/main_800C041C.s.o(.text); build/asm/main_800C041C.s.o(.rodata); build/asm/main_800C041C.s.o(.data); }
    .main_800C041C_bss (NOLOAD) : { build/asm/main_800C041C.s.o(.bss); }
    .main_800C04AC 0x800C04AC : AT(0x000C10AC) { FILL(0x00000000); build/asm/main_800C04AC.s.o(.text); build/asm/main_800C04AC.s.o(.rodata); build/asm/main_800C04AC.s.o(.data); }
    .main_800C04AC_bss (NOLOAD) : { build/asm/main_800C04AC.s.o(.bss); }
    .main_800C06A8 0x800C06A8 : AT(0x000C12A8) { build/asm/data/main_800C06A8.bin.o(.data); }
    .main_800C0814 0x800C0814 : AT(0x000C1414) { FILL(0x00000000); build/asm/main_800C0814.s.o(.text); build/asm/main_800C0814.s.o(.rodata); build/asm/main_800C0814.s.o(.data); }
    .main_800C0814_bss (NOLOAD) : { build/asm/main_800C0814.s.o(.bss); }
    .main_800C095C 0x800C095C : AT(0x000C155C) { build/asm/data/main_800C095C.bin.o(.data); }
    .main_800C1694 0x800C1694 : AT(0x000C2294) { FILL(0x00000000); build/asm/main_800C1694.s.o(.text); build/asm/main_800C1694.s.o(.rodata); build/asm/main_800C1694.s.o(.data); }
    .main_800C1694_bss (NOLOAD) : { build/asm/main_800C1694.s.o(.bss); }
    .main_800C16A0 0x800C16A0 : AT(0x000C22A0) { build/asm/data/main_800C16A0.bin.o(.data); }
    .main_800C1968 0x800C1968 : AT(0x000C2568) { build/asm/data/main_800C1968.bin.o(.data); }
    .main_800C1D3C 0x800C1D3C : AT(0x000C293C) { FILL(0x00000000); build/asm/main_800C1D3C.s.o(.text); build/asm/main_800C1D3C.s.o(.rodata); build/asm/main_800C1D3C.s.o(.data); }
    .main_800C1D3C_bss (NOLOAD) : { build/asm/main_800C1D3C.s.o(.bss); }
    .main_800C1DB8 0x800C1DB8 : AT(0x000C29B8) { build/asm/data/main_800C1DB8.bin.o(.data); }
    .main_800C7114 0x800C7114 : AT(0x000C7D14) { FILL(0x00000000); build/asm/main_800C7114.s.o(.text); build/asm/main_800C7114.s.o(.rodata); build/asm/main_800C7114.s.o(.data); }
    .main_800C7114_bss (NOLOAD) : { build/asm/main_800C7114.s.o(.bss); }
    .main_800C7184 0x800C7184 : AT(0x000C7D84) { build/asm/data/main_800C7184.bin.o(.data); }
    .main_800C7700 0x800C7700 : AT(0x000C8300) { FILL(0x00000000); build/asm/main_800C7700.s.o(.text); build/asm/main_800C7700.s.o(.rodata); build/asm/main_800C7700.s.o(.data); }
    .main_800C7700_bss (NOLOAD) : { build/asm/main_800C7700.s.o(.bss); }
    .main_800C7740 0x800C7740 : AT(0x000C8340) { build/asm/data/main_800C7740.bin.o(.data); }
    .main_800D2DE0 0x800D2DE0 : AT(0x000D39E0) { build/asm/data/main_800D2DE0.bin.o(.data); }
    .main_800DA578 0x800DA578 : AT(0x000DB178) { FILL(0x00000000); build/asm/main_800DA578.s.o(.text); build/asm/main_800DA578.s.o(.rodata); build/asm/main_800DA578.s.o(.data); }
    .main_800DA578_bss (NOLOAD) : { build/asm/main_800DA578.s.o(.bss); }
    .main_800DA5B8 0x800DA5B8 : AT(0x000DB1B8) { build/asm/data/main_800DA5B8.bin.o(.data); }
    .main_800E5A50 0x800E5A50 : AT(0x000E6650) { build/asm/data/main_800E5A50.bin.o(.data); }
    .main_800E6088 0x800E6088 : AT(0x000E6C88) { build/asm/data/main_800E6088.bin.o(.data); }
    .main_800E7764 0x800E7764 : AT(0x000E8364) { build/asm/data/main_800E7764.bin.o(.data); }
    .main_800EFE5C 0x800EFE5C : AT(0x000F0A5C) { FILL(0x00000000); build/asm/main_800EFE5C.s.o(.text); build/asm/main_800EFE5C.s.o(.rodata); build/asm/main_800EFE5C.s.o(.data); }
    .main_800EFE5C_bss (NOLOAD) : { build/asm/main_800EFE5C.s.o(.bss); }
    .main_800EFE70 0x800EFE70 : AT(0x000F0A70) { build/asm/data/main_800EFE70.bin.o(.data); }
    .main_800F76F4 0x800F76F4 : AT(0x000F82F4) { build/asm/data/main_800F76F4.bin.o(.data); }
    .main_800FD17C 0x800FD17C : AT(0x000FDD7C) { FILL(0x00000000); build/asm/main_800FD17C.s.o(.text); build/asm/main_800FD17C.s.o(.rodata); build/asm/main_800FD17C.s.o(.data); }
    .main_800FD17C_bss (NOLOAD) : { build/asm/main_800FD17C.s.o(.bss); }
    .main_800FD1A0 0x800FD1A0 : AT(0x000FDDA0) { build/asm/data/main_800FD1A0.bin.o(.data); }
    .main_800FE8D0 0x800FE8D0 : AT(0x000FF4D0) { FILL(0x00000000); build/asm/main_800FE8D0.s.o(.text); build/asm/main_800FE8D0.s.o(.rodata); build/asm/main_800FE8D0.s.o(.data); }
    .main_800FE8D0_bss (NOLOAD) : { build/asm/main_800FE8D0.s.o(.bss); }
    .main_800FE95C 0x800FE95C : AT(0x000FF55C) { build/asm/data/main_800FE95C.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
