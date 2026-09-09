SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80057000 0x80057000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80057000.s.o(.text); build/asm/main_80057000.s.o(.rodata); build/asm/main_80057000.s.o(.data); }
    .main_80057000_bss (NOLOAD) : { build/asm/main_80057000.s.o(.bss); }
    .main_800578E0 0x800578E0 : AT(0x000018E0) { FILL(0x00000000); build/asm/main_800578E0.s.o(.text); build/asm/main_800578E0.s.o(.rodata); build/asm/main_800578E0.s.o(.data); }
    .main_800578E0_bss (NOLOAD) : { build/asm/main_800578E0.s.o(.bss); }
    .main_8007B768 0x8007B768 : AT(0x00025768) { FILL(0x00000000); build/asm/main_8007B768.s.o(.text); build/asm/main_8007B768.s.o(.rodata); build/asm/main_8007B768.s.o(.data); }
    .main_8007B768_bss (NOLOAD) : { build/asm/main_8007B768.s.o(.bss); }
    .main_8007BB30 0x8007BB30 : AT(0x00025B30) { FILL(0x00000000); build/asm/main_8007BB30.s.o(.text); build/asm/main_8007BB30.s.o(.rodata); build/asm/main_8007BB30.s.o(.data); }
    .main_8007BB30_bss (NOLOAD) : { build/asm/main_8007BB30.s.o(.bss); }
    .main_80093A10 0x80093A10 : AT(0x0003DA10) { build/asm/data/main_80093A10.bin.o(.data); }
    .main_80094210 0x80094210 : AT(0x0003E210) { build/asm/data/main_80094210.bin.o(.data); }
    .ovl15_8011A9B0 0x8011A9B0 : AT(0x0003E490) { FILL(0x00000000); build/asm/ovl15_8011A9B0.s.o(.text); build/asm/ovl15_8011A9B0.s.o(.rodata); build/asm/ovl15_8011A9B0.s.o(.data); }
    .ovl15_8011A9B0_bss (NOLOAD) : { build/asm/ovl15_8011A9B0.s.o(.bss); }
    .ovl11_80126EA0 0x80126EA0 : AT(0x00046400) { FILL(0x00000000); build/asm/ovl11_80126EA0.s.o(.text); build/asm/ovl11_80126EA0.s.o(.rodata); build/asm/ovl11_80126EA0.s.o(.data); }
    .ovl11_80126EA0_bss (NOLOAD) : { build/asm/ovl11_80126EA0.s.o(.bss); }
    .bin_586B0 0xA00586B0 : AT(0x000586B0) { build/assets/bin_586B0.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
