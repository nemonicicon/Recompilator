SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80200400 0x80200400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80200400.s.o(.text); build/asm/main_80200400.s.o(.rodata); build/asm/main_80200400.s.o(.data); }
    .main_80200400_bss (NOLOAD) : { build/asm/main_80200400.s.o(.bss); }
    .main_80200470 0x80200470 : AT(0x00001070) { FILL(0x00000000); build/asm/main_80200470.s.o(.text); build/asm/main_80200470.s.o(.rodata); build/asm/main_80200470.s.o(.data); }
    .main_80200470_bss (NOLOAD) : { build/asm/main_80200470.s.o(.bss); }
    .main_802007F4 0x802007F4 : AT(0x000013F4) { build/asm/data/main_802007F4.bin.o(.data); }
    .main_80219088 0x80219088 : AT(0x00019C88) { FILL(0x00000000); build/asm/main_80219088.s.o(.text); build/asm/main_80219088.s.o(.rodata); build/asm/main_80219088.s.o(.data); }
    .main_80219088_bss (NOLOAD) : { build/asm/main_80219088.s.o(.bss); }
    .main_80219098 0x80219098 : AT(0x00019C98) { build/asm/data/main_80219098.bin.o(.data); }
    .main_8022B738 0x8022B738 : AT(0x0002C338) { FILL(0x00000000); build/asm/main_8022B738.s.o(.text); build/asm/main_8022B738.s.o(.rodata); build/asm/main_8022B738.s.o(.data); }
    .main_8022B738_bss (NOLOAD) : { build/asm/main_8022B738.s.o(.bss); }
    .main_8022B760 0x8022B760 : AT(0x0002C360) { build/asm/data/main_8022B760.bin.o(.data); }
    .main_8022D570 0x8022D570 : AT(0x0002E170) { FILL(0x00000000); build/asm/main_8022D570.s.o(.text); build/asm/main_8022D570.s.o(.rodata); build/asm/main_8022D570.s.o(.data); }
    .main_8022D570_bss (NOLOAD) : { build/asm/main_8022D570.s.o(.bss); }
    .main_8022D578 0x8022D578 : AT(0x0002E178) { build/asm/data/main_8022D578.bin.o(.data); }
    .main_802345FC 0x802345FC : AT(0x000351FC) { FILL(0x00000000); build/asm/main_802345FC.s.o(.text); build/asm/main_802345FC.s.o(.rodata); build/asm/main_802345FC.s.o(.data); }
    .main_802345FC_bss (NOLOAD) : { build/asm/main_802345FC.s.o(.bss); }
    .main_80234604 0x80234604 : AT(0x00035204) { build/asm/data/main_80234604.bin.o(.data); }
    .main_80244CF0 0x80244CF0 : AT(0x000458F0) { FILL(0x00000000); build/asm/main_80244CF0.s.o(.text); build/asm/main_80244CF0.s.o(.rodata); build/asm/main_80244CF0.s.o(.data); }
    .main_80244CF0_bss (NOLOAD) : { build/asm/main_80244CF0.s.o(.bss); }
    .main_80244DF4 0x80244DF4 : AT(0x000459F4) { build/asm/data/main_80244DF4.bin.o(.data); }
    .main_8024E2E4 0x8024E2E4 : AT(0x0004EEE4) { FILL(0x00000000); build/asm/main_8024E2E4.s.o(.text); build/asm/main_8024E2E4.s.o(.rodata); build/asm/main_8024E2E4.s.o(.data); }
    .main_8024E2E4_bss (NOLOAD) : { build/asm/main_8024E2E4.s.o(.bss); }
    .main_8024E30C 0x8024E30C : AT(0x0004EF0C) { build/asm/data/main_8024E30C.bin.o(.data); }
    .main_8027A964 0x8027A964 : AT(0x0007B564) { FILL(0x00000000); build/asm/main_8027A964.s.o(.text); build/asm/main_8027A964.s.o(.rodata); build/asm/main_8027A964.s.o(.data); }
    .main_8027A964_bss (NOLOAD) : { build/asm/main_8027A964.s.o(.bss); }
    .main_8027AA0C 0x8027AA0C : AT(0x0007B60C) { build/asm/data/main_8027AA0C.bin.o(.data); }
    .main_8027DDC8 0x8027DDC8 : AT(0x0007E9C8) { FILL(0x00000000); build/asm/main_8027DDC8.s.o(.text); build/asm/main_8027DDC8.s.o(.rodata); build/asm/main_8027DDC8.s.o(.data); }
    .main_8027DDC8_bss (NOLOAD) : { build/asm/main_8027DDC8.s.o(.bss); }
    .main_8027DEB4 0x8027DEB4 : AT(0x0007EAB4) { build/asm/data/main_8027DEB4.bin.o(.data); }
    .main_80293954 0x80293954 : AT(0x00094554) { FILL(0x00000000); build/asm/main_80293954.s.o(.text); build/asm/main_80293954.s.o(.rodata); build/asm/main_80293954.s.o(.data); }
    .main_80293954_bss (NOLOAD) : { build/asm/main_80293954.s.o(.bss); }
    .main_80293B9C 0x80293B9C : AT(0x0009479C) { build/asm/data/main_80293B9C.bin.o(.data); }
    .main_80295B68 0x80295B68 : AT(0x00096768) { FILL(0x00000000); build/asm/main_80295B68.s.o(.text); build/asm/main_80295B68.s.o(.rodata); build/asm/main_80295B68.s.o(.data); }
    .main_80295B68_bss (NOLOAD) : { build/asm/main_80295B68.s.o(.bss); }
    .main_80295F80 0x80295F80 : AT(0x00096B80) { build/asm/data/main_80295F80.bin.o(.data); }
    .assets 0x80600400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
