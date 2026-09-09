SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80002B3C 0x80002B3C : AT(0x0000373C) { FILL(0x00000000); build/asm/main_80002B3C.s.o(.text); build/asm/main_80002B3C.s.o(.rodata); build/asm/main_80002B3C.s.o(.data); }
    .main_80002B3C_bss (NOLOAD) : { build/asm/main_80002B3C.s.o(.bss); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    .ovl_snap_main 0x80000400 : AT(0x00C00000) { FILL(0x00000000); build/asm/ovl_snap_main.s.o(.text); build/asm/ovl_snap_main.s.o(.rodata); build/asm/ovl_snap_main.s.o(.data); }
    .ovl_snap_main_bss (NOLOAD) : { build/asm/ovl_snap_main.s.o(.bss); }
    /DISCARD/ : { *(*); }
}
