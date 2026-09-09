SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80200050 0x80200050 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80200050.s.o(.text); build/asm/main_80200050.s.o(.rodata); build/asm/main_80200050.s.o(.data); }
    .main_80200050_bss (NOLOAD) : { build/asm/main_80200050.s.o(.bss); }
    .main_80241D14 0x80241D14 : AT(0x00042CC4) { FILL(0x00000000); build/asm/main_80241D14.s.o(.text); build/asm/main_80241D14.s.o(.rodata); build/asm/main_80241D14.s.o(.data); }
    .main_80241D14_bss (NOLOAD) : { build/asm/main_80241D14.s.o(.bss); }
    .main_802420E0 0x802420E0 : AT(0x00043090) { FILL(0x00000000); build/asm/main_802420E0.s.o(.text); build/asm/main_802420E0.s.o(.rodata); build/asm/main_802420E0.s.o(.data); }
    .main_802420E0_bss (NOLOAD) : { build/asm/main_802420E0.s.o(.bss); }
    .main_802562F0 0x802562F0 : AT(0x000572A0) { FILL(0x00000000); build/asm/main_802562F0.s.o(.text); build/asm/main_802562F0.s.o(.rodata); build/asm/main_802562F0.s.o(.data); }
    .main_802562F0_bss (NOLOAD) : { build/asm/main_802562F0.s.o(.bss); }
    .main_80256AF0 0x80256AF0 : AT(0x00057AA0) { build/asm/data/main_80256AF0.bin.o(.data); }
    .main_80256D40 0x80256D40 : AT(0x00057CF0) { FILL(0x00000000); build/asm/main_80256D40.s.o(.text); build/asm/main_80256D40.s.o(.rodata); build/asm/main_80256D40.s.o(.data); }
    .main_80256D40_bss (NOLOAD) : { build/asm/main_80256D40.s.o(.bss); }
    .main2_80287430 0x80287430 : AT(0x00057D20) { FILL(0x00000000); build/asm/main2_80287430.s.o(.text); build/asm/main2_80287430.s.o(.rodata); build/asm/main2_80287430.s.o(.data); }
    .main2_80287430_bss (NOLOAD) : { build/asm/main2_80287430.s.o(.bss); }
    .main2_803233C0 0x803233C0 : AT(0x000F3CB0) { build/asm/data/main2_803233C0.bin.o(.data); }
    .assets 0x80400400 : AT(0x00119530) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
