SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004A4 0x800004A4 : AT(0x000010A4) { FILL(0x00000000); build/asm/main_800004A4.s.o(.text); build/asm/main_800004A4.s.o(.rodata); build/asm/main_800004A4.s.o(.data); }
    .main_800004A4_bss (NOLOAD) : { build/asm/main_800004A4.s.o(.bss); }
    .main_8001BDE4 0x8001BDE4 : AT(0x0001C9E4) { FILL(0x00000000); build/asm/main_8001BDE4.s.o(.text); build/asm/main_8001BDE4.s.o(.rodata); build/asm/main_8001BDE4.s.o(.data); }
    .main_8001BDE4_bss (NOLOAD) : { build/asm/main_8001BDE4.s.o(.bss); }
    .main_8001C1C0 0x8001C1C0 : AT(0x0001CDC0) { FILL(0x00000000); build/asm/main_8001C1C0.s.o(.text); build/asm/main_8001C1C0.s.o(.rodata); build/asm/main_8001C1C0.s.o(.data); }
    .main_8001C1C0_bss (NOLOAD) : { build/asm/main_8001C1C0.s.o(.bss); }
    .main_800364C0 0x800364C0 : AT(0x000370C0) { FILL(0x00000000); build/asm/main_800364C0.s.o(.text); build/asm/main_800364C0.s.o(.rodata); build/asm/main_800364C0.s.o(.data); }
    .main_800364C0_bss (NOLOAD) : { build/asm/main_800364C0.s.o(.bss); }
    .main_8004EB40 0x8004EB40 : AT(0x0004F740) { build/asm/data/main_8004EB40.bin.o(.data); }
    .main_8004F610 0x8004F610 : AT(0x00050210) { FILL(0x00000000); build/asm/main_8004F610.s.o(.text); build/asm/main_8004F610.s.o(.rodata); build/asm/main_8004F610.s.o(.data); }
    .main_8004F610_bss (NOLOAD) : { build/asm/main_8004F610.s.o(.bss); }
    .main_8004F68C 0x8004F68C : AT(0x0005028C) { build/asm/data/main_8004F68C.bin.o(.data); }
    .game_80132000 0x80132000 : AT(0x00051400) { FILL(0x00000000); build/asm/game_80132000.s.o(.text); build/asm/game_80132000.s.o(.rodata); build/asm/game_80132000.s.o(.data); }
    .game_80132000_bss (NOLOAD) : { build/asm/game_80132000.s.o(.bss); }
    .game_801D8000 0x801D8000 : AT(0x000F7400) { build/asm/data/game_801D8000.bin.o(.data); }
    .assets 0x80400400 : AT(0x0012ACA0) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
