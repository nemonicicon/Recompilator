SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800885A4 0x800885A4 : AT(0x000891A4) { FILL(0x00000000); build/asm/main_800885A4.s.o(.text); build/asm/main_800885A4.s.o(.rodata); build/asm/main_800885A4.s.o(.data); }
    .main_800885A4_bss (NOLOAD) : { build/asm/main_800885A4.s.o(.bss); }
    .main_80088970 0x80088970 : AT(0x00089570) { FILL(0x00000000); build/asm/main_80088970.s.o(.text); build/asm/main_80088970.s.o(.rodata); build/asm/main_80088970.s.o(.data); }
    .main_80088970_bss (NOLOAD) : { build/asm/main_80088970.s.o(.bss); }
    .main_80098E34 0x80098E34 : AT(0x00099A34) { FILL(0x00000000); build/asm/main_80098E34.s.o(.text); build/asm/main_80098E34.s.o(.rodata); build/asm/main_80098E34.s.o(.data); }
    .main_80098E34_bss (NOLOAD) : { build/asm/main_80098E34.s.o(.bss); }
    .main_800998E0 0x800998E0 : AT(0x0009A4E0) { build/asm/data/main_800998E0.bin.o(.data); }
    .main_80099B90 0x80099B90 : AT(0x0009A790) { FILL(0x00000000); build/asm/main_80099B90.s.o(.text); build/asm/main_80099B90.s.o(.rodata); build/asm/main_80099B90.s.o(.data); }
    .main_80099B90_bss (NOLOAD) : { build/asm/main_80099B90.s.o(.bss); }
    .main_8009AFAC 0x8009AFAC : AT(0x0009BBAC) { FILL(0x00000000); build/asm/main_8009AFAC.s.o(.text); build/asm/main_8009AFAC.s.o(.rodata); build/asm/main_8009AFAC.s.o(.data); }
    .main_8009AFAC_bss (NOLOAD) : { build/asm/main_8009AFAC.s.o(.bss); }
    .main_800A7820 0x800A7820 : AT(0x000A8420) { build/asm/data/main_800A7820.bin.o(.data); }
    .main_800A7C6C 0x800A7C6C : AT(0x000A886C) { FILL(0x00000000); build/asm/main_800A7C6C.s.o(.text); build/asm/main_800A7C6C.s.o(.rodata); build/asm/main_800A7C6C.s.o(.data); }
    .main_800A7C6C_bss (NOLOAD) : { build/asm/main_800A7C6C.s.o(.bss); }
    .main_800A7C88 0x800A7C88 : AT(0x000A8888) { build/asm/data/main_800A7C88.bin.o(.data); }
    .main_800A7D4C 0x800A7D4C : AT(0x000A894C) { FILL(0x00000000); build/asm/main_800A7D4C.s.o(.text); build/asm/main_800A7D4C.s.o(.rodata); build/asm/main_800A7D4C.s.o(.data); }
    .main_800A7D4C_bss (NOLOAD) : { build/asm/main_800A7D4C.s.o(.bss); }
    .main_800A7DD8 0x800A7DD8 : AT(0x000A89D8) { build/asm/data/main_800A7DD8.bin.o(.data); }
    .main_800A85F0 0x800A85F0 : AT(0x000A91F0) { build/asm/data/main_800A85F0.bin.o(.data); }
    .main_800A9B00 0x800A9B00 : AT(0x000AA700) { build/asm/data/main_800A9B00.bin.o(.data); }
    .main_800ABADC 0x800ABADC : AT(0x000AC6DC) { FILL(0x00000000); build/asm/main_800ABADC.s.o(.text); build/asm/main_800ABADC.s.o(.rodata); build/asm/main_800ABADC.s.o(.data); }
    .main_800ABADC_bss (NOLOAD) : { build/asm/main_800ABADC.s.o(.bss); }
    .main_800ACF60 0x800ACF60 : AT(0x000ADB60) { build/asm/data/main_800ACF60.bin.o(.data); }
    .main_800ADAF0 0x800ADAF0 : AT(0x000AE6F0) { build/asm/data/main_800ADAF0.bin.o(.data); }
    .main_800B0F48 0x800B0F48 : AT(0x000B1B48) { FILL(0x00000000); build/asm/main_800B0F48.s.o(.text); build/asm/main_800B0F48.s.o(.rodata); build/asm/main_800B0F48.s.o(.data); }
    .main_800B0F48_bss (NOLOAD) : { build/asm/main_800B0F48.s.o(.bss); }
    .main_800B10D4 0x800B10D4 : AT(0x000B1CD4) { build/asm/data/main_800B10D4.bin.o(.data); }
    .main_800B4018 0x800B4018 : AT(0x000B4C18) { FILL(0x00000000); build/asm/main_800B4018.s.o(.text); build/asm/main_800B4018.s.o(.rodata); build/asm/main_800B4018.s.o(.data); }
    .main_800B4018_bss (NOLOAD) : { build/asm/main_800B4018.s.o(.bss); }
    .main_800B674C 0x800B674C : AT(0x000B734C) { build/asm/data/main_800B674C.bin.o(.data); }
    .main_800B9198 0x800B9198 : AT(0x000B9D98) { FILL(0x00000000); build/asm/main_800B9198.s.o(.text); build/asm/main_800B9198.s.o(.rodata); build/asm/main_800B9198.s.o(.data); }
    .main_800B9198_bss (NOLOAD) : { build/asm/main_800B9198.s.o(.bss); }
    .main_800B92C4 0x800B92C4 : AT(0x000B9EC4) { build/asm/data/main_800B92C4.bin.o(.data); }
    .main_800B9764 0x800B9764 : AT(0x000BA364) { FILL(0x00000000); build/asm/main_800B9764.s.o(.text); build/asm/main_800B9764.s.o(.rodata); build/asm/main_800B9764.s.o(.data); }
    .main_800B9764_bss (NOLOAD) : { build/asm/main_800B9764.s.o(.bss); }
    .main_800B9794 0x800B9794 : AT(0x000BA394) { build/asm/data/main_800B9794.bin.o(.data); }
    .main_800C1350 0x800C1350 : AT(0x000C1F50) { build/asm/data/main_800C1350.bin.o(.data); }
    .main_800C28CC 0x800C28CC : AT(0x000C34CC) { build/asm/data/main_800C28CC.bin.o(.data); }
    .main_800C2AC4 0x800C2AC4 : AT(0x000C36C4) { FILL(0x00000000); build/asm/main_800C2AC4.s.o(.text); build/asm/main_800C2AC4.s.o(.rodata); build/asm/main_800C2AC4.s.o(.data); }
    .main_800C2AC4_bss (NOLOAD) : { build/asm/main_800C2AC4.s.o(.bss); }
    .main_800C2E04 0x800C2E04 : AT(0x000C3A04) { build/asm/data/main_800C2E04.bin.o(.data); }
    .main_800C2F0C 0x800C2F0C : AT(0x000C3B0C) { FILL(0x00000000); build/asm/main_800C2F0C.s.o(.text); build/asm/main_800C2F0C.s.o(.rodata); build/asm/main_800C2F0C.s.o(.data); }
    .main_800C2F0C_bss (NOLOAD) : { build/asm/main_800C2F0C.s.o(.bss); }
    .main_800C3088 0x800C3088 : AT(0x000C3C88) { build/asm/data/main_800C3088.bin.o(.data); }
    .main_800C7230 0x800C7230 : AT(0x000C7E30) { FILL(0x00000000); build/asm/main_800C7230.s.o(.text); build/asm/main_800C7230.s.o(.rodata); build/asm/main_800C7230.s.o(.data); }
    .main_800C7230_bss (NOLOAD) : { build/asm/main_800C7230.s.o(.bss); }
    .main_800C9548 0x800C9548 : AT(0x000CA148) { build/asm/data/main_800C9548.bin.o(.data); }
    .main_800CCD60 0x800CCD60 : AT(0x000CD960) { FILL(0x00000000); build/asm/main_800CCD60.s.o(.text); build/asm/main_800CCD60.s.o(.rodata); build/asm/main_800CCD60.s.o(.data); }
    .main_800CCD60_bss (NOLOAD) : { build/asm/main_800CCD60.s.o(.bss); }
    .main_800CF984 0x800CF984 : AT(0x000D0584) { build/asm/data/main_800CF984.bin.o(.data); }
    .main_800D00EC 0x800D00EC : AT(0x000D0CEC) { FILL(0x00000000); build/asm/main_800D00EC.s.o(.text); build/asm/main_800D00EC.s.o(.rodata); build/asm/main_800D00EC.s.o(.data); }
    .main_800D00EC_bss (NOLOAD) : { build/asm/main_800D00EC.s.o(.bss); }
    .main_800D00F4 0x800D00F4 : AT(0x000D0CF4) { build/asm/data/main_800D00F4.bin.o(.data); }
    .main_800D0194 0x800D0194 : AT(0x000D0D94) { FILL(0x00000000); build/asm/main_800D0194.s.o(.text); build/asm/main_800D0194.s.o(.rodata); build/asm/main_800D0194.s.o(.data); }
    .main_800D0194_bss (NOLOAD) : { build/asm/main_800D0194.s.o(.bss); }
    .main_800D019C 0x800D019C : AT(0x000D0D9C) { build/asm/data/main_800D019C.bin.o(.data); }
    .main_800D0504 0x800D0504 : AT(0x000D1104) { FILL(0x00000000); build/asm/main_800D0504.s.o(.text); build/asm/main_800D0504.s.o(.rodata); build/asm/main_800D0504.s.o(.data); }
    .main_800D0504_bss (NOLOAD) : { build/asm/main_800D0504.s.o(.bss); }
    .main_800D053C 0x800D053C : AT(0x000D113C) { build/asm/data/main_800D053C.bin.o(.data); }
    .main_800D05FC 0x800D05FC : AT(0x000D11FC) { FILL(0x00000000); build/asm/main_800D05FC.s.o(.text); build/asm/main_800D05FC.s.o(.rodata); build/asm/main_800D05FC.s.o(.data); }
    .main_800D05FC_bss (NOLOAD) : { build/asm/main_800D05FC.s.o(.bss); }
    .main_800D0614 0x800D0614 : AT(0x000D1214) { build/asm/data/main_800D0614.bin.o(.data); }
    .main_800D06A4 0x800D06A4 : AT(0x000D12A4) { FILL(0x00000000); build/asm/main_800D06A4.s.o(.text); build/asm/main_800D06A4.s.o(.rodata); build/asm/main_800D06A4.s.o(.data); }
    .main_800D06A4_bss (NOLOAD) : { build/asm/main_800D06A4.s.o(.bss); }
    .main_800D22D0 0x800D22D0 : AT(0x000D2ED0) { FILL(0x00000000); build/asm/main_800D22D0.s.o(.text); build/asm/main_800D22D0.s.o(.rodata); build/asm/main_800D22D0.s.o(.data); }
    .main_800D22D0_bss (NOLOAD) : { build/asm/main_800D22D0.s.o(.bss); }
    .main_800D2DEC 0x800D2DEC : AT(0x000D39EC) { build/asm/data/main_800D2DEC.bin.o(.data); }
    .main_800DBE10 0x800DBE10 : AT(0x000DCA10) { build/asm/data/main_800DBE10.bin.o(.data); }
    .main_800DC610 0x800DC610 : AT(0x000DD210) { build/asm/data/main_800DC610.bin.o(.data); }
    .main2_8024B950 0x8024B950 : AT(0x000DD5E0) { FILL(0x00000000); build/asm/main2_8024B950.s.o(.text); build/asm/main2_8024B950.s.o(.rodata); build/asm/main2_8024B950.s.o(.data); }
    .main2_8024B950_bss (NOLOAD) : { build/asm/main2_8024B950.s.o(.bss); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
