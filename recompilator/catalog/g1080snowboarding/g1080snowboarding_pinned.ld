SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .boot 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/boot.s.o(.text); build/asm/boot.s.o(.rodata); build/asm/boot.s.o(.data); }
    .boot_bss (NOLOAD) : { build/asm/boot.s.o(.bss); }
    .boot_rewritten 0x8000A260 : AT(0x0000AE60) { build/asm/data/boot_rewritten.bin.o(.data); }
    .data_pre 0xA0065E40 : AT(0x00065E40) { build/assets/data_pre.bin.o(.data); }
    .ovl1 0x80065240 : AT(0x00D9FE44) { build/asm/data/ovl1.bin.o(.data); }
    .toc1 0xA0DA23E4 : AT(0x00DA23E4) { build/assets/toc1.bin.o(.data); }
    .ovl2 0x800677E0 : AT(0x00DA23F0) { build/asm/data/ovl2.bin.o(.data); }
    .toc2 0xA0DD0A60 : AT(0x00DD0A60) { build/assets/toc2.bin.o(.data); }
    .ovl3 0x80095E50 : AT(0x00DD0A6C) { build/asm/data/ovl3.bin.o(.data); }
    .toc3 0xA0E5A37C : AT(0x00E5A37C) { build/assets/toc3.bin.o(.data); }
    .ovl4 0x8011F770 : AT(0x00E5A388) { build/asm/data/ovl4.bin.o(.data); }
    .toc4 0xA0E620E0 : AT(0x00E620E0) { build/assets/toc4.bin.o(.data); }
    .ovl5 0x801274C8 : AT(0x00E620EC) { build/asm/data/ovl5.bin.o(.data); }
    .toc5 0xA0E8F980 : AT(0x00E8F980) { build/assets/toc5.bin.o(.data); }
    .ovl6 0x80154D60 : AT(0x00E8F98C) { build/asm/data/ovl6.bin.o(.data); }
    .toc6 0xA0E95944 : AT(0x00E95944) { build/assets/toc6.bin.o(.data); }
    .ovl7 0x8015AD18 : AT(0x00E95950) { build/asm/data/ovl7.bin.o(.data); }
    .assets 0x80400400 : AT(0x00E98488) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
