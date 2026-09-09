SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800005E4 0x800005E4 : AT(0x000011E4) { FILL(0x00000000); build/asm/main_800005E4.s.o(.text); build/asm/main_800005E4.s.o(.rodata); build/asm/main_800005E4.s.o(.data); }
    .main_800005E4_bss (NOLOAD) : { build/asm/main_800005E4.s.o(.bss); }
    .main_8003AEF4 0x8003AEF4 : AT(0x0003BAF4) { FILL(0x00000000); build/asm/main_8003AEF4.s.o(.text); build/asm/main_8003AEF4.s.o(.rodata); build/asm/main_8003AEF4.s.o(.data); }
    .main_8003AEF4_bss (NOLOAD) : { build/asm/main_8003AEF4.s.o(.bss); }
    .main_8003B2C0 0x8003B2C0 : AT(0x0003BEC0) { FILL(0x00000000); build/asm/main_8003B2C0.s.o(.text); build/asm/main_8003B2C0.s.o(.rodata); build/asm/main_8003B2C0.s.o(.data); }
    .main_8003B2C0_bss (NOLOAD) : { build/asm/main_8003B2C0.s.o(.bss); }
    .main_8004D170 0x8004D170 : AT(0x0004DD70) { build/asm/data/main_8004D170.bin.o(.data); }
    .gamecode_8005BAD0 0x8005BAD0 : AT(0x0004DFF0) { FILL(0x00000000); build/asm/gamecode_8005BAD0.s.o(.text); build/asm/gamecode_8005BAD0.s.o(.rodata); build/asm/gamecode_8005BAD0.s.o(.data); }
    .gamecode_8005BAD0_bss (NOLOAD) : { build/asm/gamecode_8005BAD0.s.o(.bss); }
    .gamecode_data 0x80100520 : AT(0x000F2A40) { build/asm/data/gamecode_data.bin.o(.data); }
    .assets 0x80400400 : AT(0x00126CB0) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
