SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004A8 0x800004A8 : AT(0x000010A8) { FILL(0x00000000); build/asm/main_800004A8.s.o(.text); build/asm/main_800004A8.s.o(.rodata); build/asm/main_800004A8.s.o(.data); }
    .main_800004A8_bss (NOLOAD) : { build/asm/main_800004A8.s.o(.bss); }
    .main_8001AEEC 0x8001AEEC : AT(0x0001BAEC) { FILL(0x00000000); build/asm/main_8001AEEC.s.o(.text); build/asm/main_8001AEEC.s.o(.rodata); build/asm/main_8001AEEC.s.o(.data); }
    .main_8001AEEC_bss (NOLOAD) : { build/asm/main_8001AEEC.s.o(.bss); }
    .main_8007B544 0x8007B544 : AT(0x0007C144) { FILL(0x00000000); build/asm/main_8007B544.s.o(.text); build/asm/main_8007B544.s.o(.rodata); build/asm/main_8007B544.s.o(.data); }
    .main_8007B544_bss (NOLOAD) : { build/asm/main_8007B544.s.o(.bss); }
    .main_8007B910 0x8007B910 : AT(0x0007C510) { FILL(0x00000000); build/asm/main_8007B910.s.o(.text); build/asm/main_8007B910.s.o(.rodata); build/asm/main_8007B910.s.o(.data); }
    .main_8007B910_bss (NOLOAD) : { build/asm/main_8007B910.s.o(.bss); }
    .main_80089800 0x80089800 : AT(0x0008A400) { FILL(0x00000000); build/asm/main_80089800.s.o(.text); build/asm/main_80089800.s.o(.rodata); build/asm/main_80089800.s.o(.data); }
    .main_80089800_bss (NOLOAD) : { build/asm/main_80089800.s.o(.bss); }
    .main_80090574 0x80090574 : AT(0x00091174) { build/asm/data/main_80090574.bin.o(.data); }
    .main_8009E880 0x8009E880 : AT(0x0009F480) { FILL(0x00000000); build/asm/main_8009E880.s.o(.text); build/asm/main_8009E880.s.o(.rodata); build/asm/main_8009E880.s.o(.data); }
    .main_8009E880_bss (NOLOAD) : { build/asm/main_8009E880.s.o(.bss); }
    .main_8009F080 0x8009F080 : AT(0x0009FC80) { build/asm/data/main_8009F080.bin.o(.data); }
    .main_8009F4D0 0x8009F4D0 : AT(0x000A00D0) { FILL(0x00000000); build/asm/main_8009F4D0.s.o(.text); build/asm/main_8009F4D0.s.o(.rodata); build/asm/main_8009F4D0.s.o(.data); }
    .main_8009F4D0_bss (NOLOAD) : { build/asm/main_8009F4D0.s.o(.bss); }
    .main_8009FB50 0x8009FB50 : AT(0x000A0750) { FILL(0x00000000); build/asm/main_8009FB50.s.o(.text); build/asm/main_8009FB50.s.o(.rodata); build/asm/main_8009FB50.s.o(.data); }
    .main_8009FB50_bss (NOLOAD) : { build/asm/main_8009FB50.s.o(.bss); }
    .main_8009FBCC 0x8009FBCC : AT(0x000A07CC) { build/asm/data/main_8009FBCC.bin.o(.data); }
    .main_800B7C78 0x800B7C78 : AT(0x000B8878) { FILL(0x00000000); build/asm/main_800B7C78.s.o(.text); build/asm/main_800B7C78.s.o(.rodata); build/asm/main_800B7C78.s.o(.data); }
    .main_800B7C78_bss (NOLOAD) : { build/asm/main_800B7C78.s.o(.bss); }
    .main_800F6608 0x800F6608 : AT(0x000F7208) { FILL(0x00000000); build/asm/main_800F6608.s.o(.text); build/asm/main_800F6608.s.o(.rodata); build/asm/main_800F6608.s.o(.data); }
    .main_800F6608_bss (NOLOAD) : { build/asm/main_800F6608.s.o(.bss); }
    .main_800F94DC 0x800F94DC : AT(0x000FA0DC) { build/asm/data/main_800F94DC.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
