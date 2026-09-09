SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .boot_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/boot_80000400.s.o(.text); build/asm/boot_80000400.s.o(.rodata); build/asm/boot_80000400.s.o(.data); }
    .boot_80000400_bss (NOLOAD) : { build/asm/boot_80000400.s.o(.bss); }
    .main_002009F0 0x002009F0 : AT(0x000015F0) { FILL(0x00000000); build/asm/main_002009F0.s.o(.text); build/asm/main_002009F0.s.o(.rodata); build/asm/main_002009F0.s.o(.data); }
    .main_002009F0_bss (NOLOAD) : { build/asm/main_002009F0.s.o(.bss); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
