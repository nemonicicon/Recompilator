SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_8023FFB0 0x8023FFB0 : AT(0x00001000) { FILL(0x00000000); build/asm/main_8023FFB0.s.o(.text); build/asm/main_8023FFB0.s.o(.rodata); build/asm/main_8023FFB0.s.o(.data); }
    .main_8023FFB0_bss (NOLOAD) : { build/asm/main_8023FFB0.s.o(.bss); }
    .main_802790E4 0x802790E4 : AT(0x0003A134) { FILL(0x00000000); build/asm/main_802790E4.s.o(.text); build/asm/main_802790E4.s.o(.rodata); build/asm/main_802790E4.s.o(.data); }
    .main_802790E4_bss (NOLOAD) : { build/asm/main_802790E4.s.o(.bss); }
    .main_802794B0 0x802794B0 : AT(0x0003A500) { FILL(0x00000000); build/asm/main_802794B0.s.o(.text); build/asm/main_802794B0.s.o(.rodata); build/asm/main_802794B0.s.o(.data); }
    .main_802794B0_bss (NOLOAD) : { build/asm/main_802794B0.s.o(.bss); }
    .main_8029B360 0x8029B360 : AT(0x0005C3B0) { build/asm/data/main_8029B360.bin.o(.data); }
    .bin_5CB70 0xA005CB70 : AT(0x0005CB70) { build/assets/bin_5CB70.bin.o(.data); }
    .bin_7AAD0 0xA007AAD0 : AT(0x0007AAD0) { build/assets/bin_7AAD0.bin.o(.data); }
    .bin_95780 0xA0095780 : AT(0x00095780) { build/assets/bin_95780.bin.o(.data); }
    .ovl01_80000400 0x80000400 : AT(0x00096410) { FILL(0x00000000); build/asm/ovl01_80000400.s.o(.text); build/asm/ovl01_80000400.s.o(.rodata); build/asm/ovl01_80000400.s.o(.data); }
    .ovl01_80000400_bss (NOLOAD) : { build/asm/ovl01_80000400.s.o(.bss); }
    .ovl02_80022660 0x80022660 : AT(0x000B0D50) { FILL(0x00000000); build/asm/ovl02_80022660.s.o(.text); build/asm/ovl02_80022660.s.o(.rodata); build/asm/ovl02_80022660.s.o(.data); }
    .ovl02_80022660_bss (NOLOAD) : { build/asm/ovl02_80022660.s.o(.bss); }
    .ovl03_80027AF0 0x80027AF0 : AT(0x000B56B0) { FILL(0x00000000); build/asm/ovl03_80027AF0.s.o(.text); build/asm/ovl03_80027AF0.s.o(.rodata); build/asm/ovl03_80027AF0.s.o(.data); }
    .ovl03_80027AF0_bss (NOLOAD) : { build/asm/ovl03_80027AF0.s.o(.bss); }
    .bin_B6740 0xA00B6740 : AT(0x000B6740) { build/assets/bin_B6740.bin.o(.data); }
    .ovl04_8019A000 0x8019A000 : AT(0x000BBF00) { FILL(0x00000000); build/asm/ovl04_8019A000.s.o(.text); build/asm/ovl04_8019A000.s.o(.rodata); build/asm/ovl04_8019A000.s.o(.data); }
    .ovl04_8019A000_bss (NOLOAD) : { build/asm/ovl04_8019A000.s.o(.bss); }
    .assets 0x80400400 : AT(0x00124D60) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
