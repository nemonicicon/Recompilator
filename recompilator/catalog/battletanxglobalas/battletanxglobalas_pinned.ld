SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80071000 0x80071000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80071000.s.o(.text); build/asm/main_80071000.s.o(.rodata); build/asm/main_80071000.s.o(.data); }
    .main_80071000_bss (NOLOAD) : { build/asm/main_80071000.s.o(.bss); }
    .main_80077C40 0x80077C40 : AT(0x00007C40) { FILL(0x00000000); build/asm/main_80077C40.s.o(.text); build/asm/main_80077C40.s.o(.rodata); build/asm/main_80077C40.s.o(.data); }
    .main_80077C40_bss (NOLOAD) : { build/asm/main_80077C40.s.o(.bss); }
    .main_8007E118 0x8007E118 : AT(0x0000E118) { build/asm/data/main_8007E118.bin.o(.data); }
    .main_8007E170 0x8007E170 : AT(0x0000E170) { FILL(0x00000000); build/asm/main_8007E170.s.o(.text); build/asm/main_8007E170.s.o(.rodata); build/asm/main_8007E170.s.o(.data); }
    .main_8007E170_bss (NOLOAD) : { build/asm/main_8007E170.s.o(.bss); }
    .main_800A10E0 0x800A10E0 : AT(0x000310E0) { build/asm/data/main_800A10E0.bin.o(.data); }
    .main_800A1150 0x800A1150 : AT(0x00031150) { FILL(0x00000000); build/asm/main_800A1150.s.o(.text); build/asm/main_800A1150.s.o(.rodata); build/asm/main_800A1150.s.o(.data); }
    .main_800A1150_bss (NOLOAD) : { build/asm/main_800A1150.s.o(.bss); }
    .main_800BB53C 0x800BB53C : AT(0x0004B53C) { build/asm/data/main_800BB53C.bin.o(.data); }
    .main_800BC020 0x800BC020 : AT(0x0004C020) { FILL(0x00000000); build/asm/main_800BC020.s.o(.text); build/asm/main_800BC020.s.o(.rodata); build/asm/main_800BC020.s.o(.data); }
    .main_800BC020_bss (NOLOAD) : { build/asm/main_800BC020.s.o(.bss); }
    .main_800DEEDC 0x800DEEDC : AT(0x0006EEDC) { build/asm/data/main_800DEEDC.bin.o(.data); }
    .main_800DF0D0 0x800DF0D0 : AT(0x0006F0D0) { FILL(0x00000000); build/asm/main_800DF0D0.s.o(.text); build/asm/main_800DF0D0.s.o(.rodata); build/asm/main_800DF0D0.s.o(.data); }
    .main_800DF0D0_bss (NOLOAD) : { build/asm/main_800DF0D0.s.o(.bss); }
    .main_800EC778 0x800EC778 : AT(0x0007C778) { build/asm/data/main_800EC778.bin.o(.data); }
    .main_800EC790 0x800EC790 : AT(0x0007C790) { FILL(0x00000000); build/asm/main_800EC790.s.o(.text); build/asm/main_800EC790.s.o(.rodata); build/asm/main_800EC790.s.o(.data); }
    .main_800EC790_bss (NOLOAD) : { build/asm/main_800EC790.s.o(.bss); }
    .main_800F1900 0x800F1900 : AT(0x00081900) { build/asm/data/main_800F1900.bin.o(.data); }
    .main_800F1B30 0x800F1B30 : AT(0x00081B30) { FILL(0x00000000); build/asm/main_800F1B30.s.o(.text); build/asm/main_800F1B30.s.o(.rodata); build/asm/main_800F1B30.s.o(.data); }
    .main_800F1B30_bss (NOLOAD) : { build/asm/main_800F1B30.s.o(.bss); }
    .main_800F8660 0x800F8660 : AT(0x00088660) { build/asm/data/main_800F8660.bin.o(.data); }
    .main_800FAFBC 0x800FAFBC : AT(0x0008AFBC) { FILL(0x00000000); build/asm/main_800FAFBC.s.o(.text); build/asm/main_800FAFBC.s.o(.rodata); build/asm/main_800FAFBC.s.o(.data); }
    .main_800FAFBC_bss (NOLOAD) : { build/asm/main_800FAFBC.s.o(.bss); }
    .main_80114470 0x80114470 : AT(0x000A4470) { build/asm/data/main_80114470.bin.o(.data); }
    .main_80115548 0x80115548 : AT(0x000A5548) { FILL(0x00000000); build/asm/main_80115548.s.o(.text); build/asm/main_80115548.s.o(.rodata); build/asm/main_80115548.s.o(.data); }
    .main_80115548_bss (NOLOAD) : { build/asm/main_80115548.s.o(.bss); }
    .main_801155B0 0x801155B0 : AT(0x000A55B0) { build/asm/data/main_801155B0.bin.o(.data); }
    .main_80118918 0x80118918 : AT(0x000A8918) { FILL(0x00000000); build/asm/main_80118918.s.o(.text); build/asm/main_80118918.s.o(.rodata); build/asm/main_80118918.s.o(.data); }
    .main_80118918_bss (NOLOAD) : { build/asm/main_80118918.s.o(.bss); }
    .main_80118928 0x80118928 : AT(0x000A8928) { build/asm/data/main_80118928.bin.o(.data); }
    .main_80119628 0x80119628 : AT(0x000A9628) { FILL(0x00000000); build/asm/main_80119628.s.o(.text); build/asm/main_80119628.s.o(.rodata); build/asm/main_80119628.s.o(.data); }
    .main_80119628_bss (NOLOAD) : { build/asm/main_80119628.s.o(.bss); }
    .main_80119718 0x80119718 : AT(0x000A9718) { build/asm/data/main_80119718.bin.o(.data); }
    .main_8011A20C 0x8011A20C : AT(0x000AA20C) { FILL(0x00000000); build/asm/main_8011A20C.s.o(.text); build/asm/main_8011A20C.s.o(.rodata); build/asm/main_8011A20C.s.o(.data); }
    .main_8011A20C_bss (NOLOAD) : { build/asm/main_8011A20C.s.o(.bss); }
    .main_8011A218 0x8011A218 : AT(0x000AA218) { build/asm/data/main_8011A218.bin.o(.data); }
    .main_8011A254 0x8011A254 : AT(0x000AA254) { FILL(0x00000000); build/asm/main_8011A254.s.o(.text); build/asm/main_8011A254.s.o(.rodata); build/asm/main_8011A254.s.o(.data); }
    .main_8011A254_bss (NOLOAD) : { build/asm/main_8011A254.s.o(.bss); }
    .main_8011A280 0x8011A280 : AT(0x000AA280) { build/asm/data/main_8011A280.bin.o(.data); }
    .main_8011A344 0x8011A344 : AT(0x000AA344) { FILL(0x00000000); build/asm/main_8011A344.s.o(.text); build/asm/main_8011A344.s.o(.rodata); build/asm/main_8011A344.s.o(.data); }
    .main_8011A344_bss (NOLOAD) : { build/asm/main_8011A344.s.o(.bss); }
    .main_8011A350 0x8011A350 : AT(0x000AA350) { build/asm/data/main_8011A350.bin.o(.data); }
    .main_8011A3A8 0x8011A3A8 : AT(0x000AA3A8) { FILL(0x00000000); build/asm/main_8011A3A8.s.o(.text); build/asm/main_8011A3A8.s.o(.rodata); build/asm/main_8011A3A8.s.o(.data); }
    .main_8011A3A8_bss (NOLOAD) : { build/asm/main_8011A3A8.s.o(.bss); }
    .main_8011A3BC 0x8011A3BC : AT(0x000AA3BC) { build/asm/data/main_8011A3BC.bin.o(.data); }
    .main_8011A3E0 0x8011A3E0 : AT(0x000AA3E0) { FILL(0x00000000); build/asm/main_8011A3E0.s.o(.text); build/asm/main_8011A3E0.s.o(.rodata); build/asm/main_8011A3E0.s.o(.data); }
    .main_8011A3E0_bss (NOLOAD) : { build/asm/main_8011A3E0.s.o(.bss); }
    .main_8011A420 0x8011A420 : AT(0x000AA420) { build/asm/data/main_8011A420.bin.o(.data); }
    .main_8011A47C 0x8011A47C : AT(0x000AA47C) { FILL(0x00000000); build/asm/main_8011A47C.s.o(.text); build/asm/main_8011A47C.s.o(.rodata); build/asm/main_8011A47C.s.o(.data); }
    .main_8011A47C_bss (NOLOAD) : { build/asm/main_8011A47C.s.o(.bss); }
    .main_8011A484 0x8011A484 : AT(0x000AA484) { build/asm/data/main_8011A484.bin.o(.data); }
    .main_8011A4C0 0x8011A4C0 : AT(0x000AA4C0) { FILL(0x00000000); build/asm/main_8011A4C0.s.o(.text); build/asm/main_8011A4C0.s.o(.rodata); build/asm/main_8011A4C0.s.o(.data); }
    .main_8011A4C0_bss (NOLOAD) : { build/asm/main_8011A4C0.s.o(.bss); }
    .main_8011A4F8 0x8011A4F8 : AT(0x000AA4F8) { build/asm/data/main_8011A4F8.bin.o(.data); }
    .main_8011A540 0x8011A540 : AT(0x000AA540) { FILL(0x00000000); build/asm/main_8011A540.s.o(.text); build/asm/main_8011A540.s.o(.rodata); build/asm/main_8011A540.s.o(.data); }
    .main_8011A540_bss (NOLOAD) : { build/asm/main_8011A540.s.o(.bss); }
    .main_8011A784 0x8011A784 : AT(0x000AA784) { build/asm/data/main_8011A784.bin.o(.data); }
    .main_8011AB4C 0x8011AB4C : AT(0x000AAB4C) { FILL(0x00000000); build/asm/main_8011AB4C.s.o(.text); build/asm/main_8011AB4C.s.o(.rodata); build/asm/main_8011AB4C.s.o(.data); }
    .main_8011AB4C_bss (NOLOAD) : { build/asm/main_8011AB4C.s.o(.bss); }
    .main_8011AB7C 0x8011AB7C : AT(0x000AAB7C) { build/asm/data/main_8011AB7C.bin.o(.data); }
    .main_8011AD0C 0x8011AD0C : AT(0x000AAD0C) { FILL(0x00000000); build/asm/main_8011AD0C.s.o(.text); build/asm/main_8011AD0C.s.o(.rodata); build/asm/main_8011AD0C.s.o(.data); }
    .main_8011AD0C_bss (NOLOAD) : { build/asm/main_8011AD0C.s.o(.bss); }
    .main_8011AD3C 0x8011AD3C : AT(0x000AAD3C) { build/asm/data/main_8011AD3C.bin.o(.data); }
    .main_8011AECC 0x8011AECC : AT(0x000AAECC) { FILL(0x00000000); build/asm/main_8011AECC.s.o(.text); build/asm/main_8011AECC.s.o(.rodata); build/asm/main_8011AECC.s.o(.data); }
    .main_8011AECC_bss (NOLOAD) : { build/asm/main_8011AECC.s.o(.bss); }
    .main_8011AEFC 0x8011AEFC : AT(0x000AAEFC) { build/asm/data/main_8011AEFC.bin.o(.data); }
    .main_8011B08C 0x8011B08C : AT(0x000AB08C) { FILL(0x00000000); build/asm/main_8011B08C.s.o(.text); build/asm/main_8011B08C.s.o(.rodata); build/asm/main_8011B08C.s.o(.data); }
    .main_8011B08C_bss (NOLOAD) : { build/asm/main_8011B08C.s.o(.bss); }
    .main_8011B0BC 0x8011B0BC : AT(0x000AB0BC) { build/asm/data/main_8011B0BC.bin.o(.data); }
    .main_8011DBD8 0x8011DBD8 : AT(0x000ADBD8) { FILL(0x00000000); build/asm/main_8011DBD8.s.o(.text); build/asm/main_8011DBD8.s.o(.rodata); build/asm/main_8011DBD8.s.o(.data); }
    .main_8011DBD8_bss (NOLOAD) : { build/asm/main_8011DBD8.s.o(.bss); }
    .main_8011DC38 0x8011DC38 : AT(0x000ADC38) { build/asm/data/main_8011DC38.bin.o(.data); }
    .main_8011DC48 0x8011DC48 : AT(0x000ADC48) { FILL(0x00000000); build/asm/main_8011DC48.s.o(.text); build/asm/main_8011DC48.s.o(.rodata); build/asm/main_8011DC48.s.o(.data); }
    .main_8011DC48_bss (NOLOAD) : { build/asm/main_8011DC48.s.o(.bss); }
    .main_8011DD28 0x8011DD28 : AT(0x000ADD28) { build/asm/data/main_8011DD28.bin.o(.data); }
    .main_8011E710 0x8011E710 : AT(0x000AE710) { FILL(0x00000000); build/asm/main_8011E710.s.o(.text); build/asm/main_8011E710.s.o(.rodata); build/asm/main_8011E710.s.o(.data); }
    .main_8011E710_bss (NOLOAD) : { build/asm/main_8011E710.s.o(.bss); }
    .main_8011E730 0x8011E730 : AT(0x000AE730) { build/asm/data/main_8011E730.bin.o(.data); }
    .main_8011FA5C 0x8011FA5C : AT(0x000AFA5C) { FILL(0x00000000); build/asm/main_8011FA5C.s.o(.text); build/asm/main_8011FA5C.s.o(.rodata); build/asm/main_8011FA5C.s.o(.data); }
    .main_8011FA5C_bss (NOLOAD) : { build/asm/main_8011FA5C.s.o(.bss); }
    .main_8011FA8C 0x8011FA8C : AT(0x000AFA8C) { build/asm/data/main_8011FA8C.bin.o(.data); }
    .main_801279B8 0x801279B8 : AT(0x000B79B8) { FILL(0x00000000); build/asm/main_801279B8.s.o(.text); build/asm/main_801279B8.s.o(.rodata); build/asm/main_801279B8.s.o(.data); }
    .main_801279B8_bss (NOLOAD) : { build/asm/main_801279B8.s.o(.bss); }
    .main_80127EC8 0x80127EC8 : AT(0x000B7EC8) { build/asm/data/main_80127EC8.bin.o(.data); }
    .main_80145254 0x80145254 : AT(0x000D5254) { FILL(0x00000000); build/asm/main_80145254.s.o(.text); build/asm/main_80145254.s.o(.rodata); build/asm/main_80145254.s.o(.data); }
    .main_80145254_bss (NOLOAD) : { build/asm/main_80145254.s.o(.bss); }
    .main_80145598 0x80145598 : AT(0x000D5598) { build/asm/data/main_80145598.bin.o(.data); }
    .main_8014749C 0x8014749C : AT(0x000D749C) { FILL(0x00000000); build/asm/main_8014749C.s.o(.text); build/asm/main_8014749C.s.o(.rodata); build/asm/main_8014749C.s.o(.data); }
    .main_8014749C_bss (NOLOAD) : { build/asm/main_8014749C.s.o(.bss); }
    .main_80148138 0x80148138 : AT(0x000D8138) { build/asm/data/main_80148138.bin.o(.data); }
    .assets 0x80471000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
