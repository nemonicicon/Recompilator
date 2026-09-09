SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000C7C 0x80000C7C : AT(0x0000187C) { FILL(0x00000000); build/asm/main_80000C7C.s.o(.text); build/asm/main_80000C7C.s.o(.rodata); build/asm/main_80000C7C.s.o(.data); }
    .main_80000C7C_bss (NOLOAD) : { build/asm/main_80000C7C.s.o(.bss); }
    .main_80001300 0x80001300 : AT(0x00001F00) { build/asm/data/main_80001300.bin.o(.data); }
    /* RAM-snapshot overlay (2026-08-30). VMA deliberately OVERLAPS .main_80001300: that section
       holds the PACKED bytes (entropy 7.62, zero jr-ra); this one holds the DECOMPRESSED body
       captured from RDRAM, and force-registers over the fictional functions recompiled from the
       packed bytes. Same shape as shadows/shadows_pinned.ld (SOTE, the proven case). */
    .ovl_snap_main 0x80001300 : AT(0x00800000) { FILL(0x00000000); build/asm/ovl_snap_main.s.o(.text); build/asm/ovl_snap_main.s.o(.rodata); build/asm/ovl_snap_main.s.o(.data); }
    .ovl_snap_main_bss (NOLOAD) : { build/asm/ovl_snap_main.s.o(.bss); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
