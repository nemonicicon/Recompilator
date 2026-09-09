SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004C4 0x800004C4 : AT(0x000010C4) { FILL(0x00000000); build/asm/main_800004C4.s.o(.text); build/asm/main_800004C4.s.o(.rodata); build/asm/main_800004C4.s.o(.data); }
    .main_800004C4_bss (NOLOAD) : { build/asm/main_800004C4.s.o(.bss); }
    .main_8004F724 0x8004F724 : AT(0x00050324) { FILL(0x00000000); build/asm/main_8004F724.s.o(.text); build/asm/main_8004F724.s.o(.rodata); build/asm/main_8004F724.s.o(.data); }
    .main_8004F724_bss (NOLOAD) : { build/asm/main_8004F724.s.o(.bss); }
    .main_8004FAF0 0x8004FAF0 : AT(0x000506F0) { FILL(0x00000000); build/asm/main_8004FAF0.s.o(.text); build/asm/main_8004FAF0.s.o(.rodata); build/asm/main_8004FAF0.s.o(.data); }
    .main_8004FAF0_bss (NOLOAD) : { build/asm/main_8004FAF0.s.o(.bss); }
    .main_80069C58 0x80069C58 : AT(0x0006A858) { build/asm/data/main_80069C58.bin.o(.data); }
    .main_8006AC90 0x8006AC90 : AT(0x0006B890) { FILL(0x00000000); build/asm/main_8006AC90.s.o(.text); build/asm/main_8006AC90.s.o(.rodata); build/asm/main_8006AC90.s.o(.data); }
    .main_8006AC90_bss (NOLOAD) : { build/asm/main_8006AC90.s.o(.bss); }
    .main_8006B044 0x8006B044 : AT(0x0006BC44) { build/asm/data/main_8006B044.bin.o(.data); }
    .main_8006BE00 0x8006BE00 : AT(0x0006CA00) { FILL(0x00000000); build/asm/main_8006BE00.s.o(.text); build/asm/main_8006BE00.s.o(.rodata); build/asm/main_8006BE00.s.o(.data); }
    .main_8006BE00_bss (NOLOAD) : { build/asm/main_8006BE00.s.o(.bss); }
    .main_8006CC70 0x8006CC70 : AT(0x0006D870) { FILL(0x00000000); build/asm/main_8006CC70.s.o(.text); build/asm/main_8006CC70.s.o(.rodata); build/asm/main_8006CC70.s.o(.data); }
    .main_8006CC70_bss (NOLOAD) : { build/asm/main_8006CC70.s.o(.bss); }
    .main_8006D2D4 0x8006D2D4 : AT(0x0006DED4) { FILL(0x00000000); build/asm/main_8006D2D4.s.o(.text); build/asm/main_8006D2D4.s.o(.rodata); build/asm/main_8006D2D4.s.o(.data); }
    .main_8006D2D4_bss (NOLOAD) : { build/asm/main_8006D2D4.s.o(.bss); }
    .main_80072E04 0x80072E04 : AT(0x00073A04) { FILL(0x00000000); build/asm/main_80072E04.s.o(.text); build/asm/main_80072E04.s.o(.rodata); build/asm/main_80072E04.s.o(.data); }
    .main_80072E04_bss (NOLOAD) : { build/asm/main_80072E04.s.o(.bss); }
    .main_80073114 0x80073114 : AT(0x00073D14) { build/asm/data/main_80073114.bin.o(.data); }
    .main_80075884 0x80075884 : AT(0x00076484) { FILL(0x00000000); build/asm/main_80075884.s.o(.text); build/asm/main_80075884.s.o(.rodata); build/asm/main_80075884.s.o(.data); }
    .main_80075884_bss (NOLOAD) : { build/asm/main_80075884.s.o(.bss); }
    .main_80075890 0x80075890 : AT(0x00076490) { build/asm/data/main_80075890.bin.o(.data); }
    .main_8008042C 0x8008042C : AT(0x0008102C) { build/asm/data/main_8008042C.bin.o(.data); }
    .main_80081594 0x80081594 : AT(0x00082194) { build/asm/data/main_80081594.bin.o(.data); }
    .main_80081B60 0x80081B60 : AT(0x00082760) { build/asm/data/main_80081B60.bin.o(.data); }
    .main_8008219C 0x8008219C : AT(0x00082D9C) { FILL(0x00000000); build/asm/main_8008219C.s.o(.text); build/asm/main_8008219C.s.o(.rodata); build/asm/main_8008219C.s.o(.data); }
    .main_8008219C_bss (NOLOAD) : { build/asm/main_8008219C.s.o(.bss); }
    .main_8009A758 0x8009A758 : AT(0x0009B358) { build/asm/data/main_8009A758.bin.o(.data); }
    .main_800E4860 0x800E4860 : AT(0x000E5460) { FILL(0x00000000); build/asm/main_800E4860.s.o(.text); build/asm/main_800E4860.s.o(.rodata); build/asm/main_800E4860.s.o(.data); }
    .main_800E4860_bss (NOLOAD) : { build/asm/main_800E4860.s.o(.bss); }
    .main_800E4884 0x800E4884 : AT(0x000E5484) { build/asm/data/main_800E4884.bin.o(.data); }
    .main_800F4DB4 0x800F4DB4 : AT(0x000F59B4) { FILL(0x00000000); build/asm/main_800F4DB4.s.o(.text); build/asm/main_800F4DB4.s.o(.rodata); build/asm/main_800F4DB4.s.o(.data); }
    .main_800F4DB4_bss (NOLOAD) : { build/asm/main_800F4DB4.s.o(.bss); }
    .main_800F4EE4 0x800F4EE4 : AT(0x000F5AE4) { build/asm/data/main_800F4EE4.bin.o(.data); }
    .main_800F7904 0x800F7904 : AT(0x000F8504) { FILL(0x00000000); build/asm/main_800F7904.s.o(.text); build/asm/main_800F7904.s.o(.rodata); build/asm/main_800F7904.s.o(.data); }
    .main_800F7904_bss (NOLOAD) : { build/asm/main_800F7904.s.o(.bss); }
    .main_800F7924 0x800F7924 : AT(0x000F8524) { build/asm/data/main_800F7924.bin.o(.data); }
    .main_800F9F3C 0x800F9F3C : AT(0x000FAB3C) { FILL(0x00000000); build/asm/main_800F9F3C.s.o(.text); build/asm/main_800F9F3C.s.o(.rodata); build/asm/main_800F9F3C.s.o(.data); }
    .main_800F9F3C_bss (NOLOAD) : { build/asm/main_800F9F3C.s.o(.bss); }
    .main_800FA054 0x800FA054 : AT(0x000FAC54) { build/asm/data/main_800FA054.bin.o(.data); }
    .main_800FA508 0x800FA508 : AT(0x000FB108) { FILL(0x00000000); build/asm/main_800FA508.s.o(.text); build/asm/main_800FA508.s.o(.rodata); build/asm/main_800FA508.s.o(.data); }
    .main_800FA508_bss (NOLOAD) : { build/asm/main_800FA508.s.o(.bss); }
    .main_800FA58C 0x800FA58C : AT(0x000FB18C) { build/asm/data/main_800FA58C.bin.o(.data); }
    .main_800FDFFC 0x800FDFFC : AT(0x000FEBFC) { FILL(0x00000000); build/asm/main_800FDFFC.s.o(.text); build/asm/main_800FDFFC.s.o(.rodata); build/asm/main_800FDFFC.s.o(.data); }
    .main_800FDFFC_bss (NOLOAD) : { build/asm/main_800FDFFC.s.o(.bss); }
    .main_800FE040 0x800FE040 : AT(0x000FEC40) { build/asm/data/main_800FE040.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
