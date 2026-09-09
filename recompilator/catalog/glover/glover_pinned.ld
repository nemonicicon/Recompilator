SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80100000 0x80100000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80100000.s.o(.text); build/asm/main_80100000.s.o(.rodata); build/asm/main_80100000.s.o(.data); }
    .main_80100000_bss (NOLOAD) : { build/asm/main_80100000.s.o(.bss); }
    .main_80100400 0x80100400 : AT(0x00001400) { FILL(0x00000000); build/asm/main_80100400.s.o(.text); build/asm/main_80100400.s.o(.rodata); build/asm/main_80100400.s.o(.data); }
    .main_80100400_bss (NOLOAD) : { build/asm/main_80100400.s.o(.bss); }
    .main_80100C00 0x80100C00 : AT(0x00001C00) { build/asm/data/main_80100C00.bin.o(.data); }
    .main_8010C920 0x8010C920 : AT(0x0000D920) { FILL(0x00000000); build/asm/main_8010C920.s.o(.text); build/asm/main_8010C920.s.o(.rodata); build/asm/main_8010C920.s.o(.data); }
    .main_8010C920_bss (NOLOAD) : { build/asm/main_8010C920.s.o(.bss); }
    .main_80112808 0x80112808 : AT(0x00013808) { build/asm/data/main_80112808.bin.o(.data); }
    .main_80112F80 0x80112F80 : AT(0x00013F80) { FILL(0x00000000); build/asm/main_80112F80.s.o(.text); build/asm/main_80112F80.s.o(.rodata); build/asm/main_80112F80.s.o(.data); }
    .main_80112F80_bss (NOLOAD) : { build/asm/main_80112F80.s.o(.bss); }
    .main_8011C36C 0x8011C36C : AT(0x0001D36C) { build/asm/data/main_8011C36C.bin.o(.data); }
    .main_8011C810 0x8011C810 : AT(0x0001D810) { FILL(0x00000000); build/asm/main_8011C810.s.o(.text); build/asm/main_8011C810.s.o(.rodata); build/asm/main_8011C810.s.o(.data); }
    .main_8011C810_bss (NOLOAD) : { build/asm/main_8011C810.s.o(.bss); }
    .main_80155AE4 0x80155AE4 : AT(0x00056AE4) { build/asm/data/main_80155AE4.bin.o(.data); }
    .main_80155B90 0x80155B90 : AT(0x00056B90) { FILL(0x00000000); build/asm/main_80155B90.s.o(.text); build/asm/main_80155B90.s.o(.rodata); build/asm/main_80155B90.s.o(.data); }
    .main_80155B90_bss (NOLOAD) : { build/asm/main_80155B90.s.o(.bss); }
    .main_801BC5E4 0x801BC5E4 : AT(0x000BD5E4) { build/asm/data/main_801BC5E4.bin.o(.data); }
    .main_801BF800 0x801BF800 : AT(0x000C0800) { FILL(0x00000000); build/asm/main_801BF800.s.o(.text); build/asm/main_801BF800.s.o(.rodata); build/asm/main_801BF800.s.o(.data); }
    .main_801BF800_bss (NOLOAD) : { build/asm/main_801BF800.s.o(.bss); }
    .main_801D41A0 0x801D41A0 : AT(0x000D51A0) { FILL(0x00000000); build/asm/main_801D41A0.s.o(.text); build/asm/main_801D41A0.s.o(.rodata); build/asm/main_801D41A0.s.o(.data); }
    .main_801D41A0_bss (NOLOAD) : { build/asm/main_801D41A0.s.o(.bss); }
    .main_801EF784 0x801EF784 : AT(0x000F0784) { FILL(0x00000000); build/asm/main_801EF784.s.o(.text); build/asm/main_801EF784.s.o(.rodata); build/asm/main_801EF784.s.o(.data); }
    .main_801EF784_bss (NOLOAD) : { build/asm/main_801EF784.s.o(.bss); }
    .main_801EFB74 0x801EFB74 : AT(0x000F0B74) { build/asm/data/main_801EFB74.bin.o(.data); }
    .main_801F2E80 0x801F2E80 : AT(0x000F3E80) { FILL(0x00000000); build/asm/main_801F2E80.s.o(.text); build/asm/main_801F2E80.s.o(.rodata); build/asm/main_801F2E80.s.o(.data); }
    .main_801F2E80_bss (NOLOAD) : { build/asm/main_801F2E80.s.o(.bss); }
    .main_801F3B4C 0x801F3B4C : AT(0x000F4B4C) { build/asm/data/main_801F3B4C.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
