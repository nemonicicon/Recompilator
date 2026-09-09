SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80001088 0x80001088 : AT(0x00001C88) { build/asm/data/main_80001088.bin.o(.data); }
    .main_80001FB4 0x80001FB4 : AT(0x00002BB4) { FILL(0x00000000); build/asm/main_80001FB4.s.o(.text); build/asm/main_80001FB4.s.o(.rodata); build/asm/main_80001FB4.s.o(.data); }
    .main_80001FB4_bss (NOLOAD) : { build/asm/main_80001FB4.s.o(.bss); }
    .main_80001FC8 0x80001FC8 : AT(0x00002BC8) { build/asm/data/main_80001FC8.bin.o(.data); }
    .main_8000BEA0 0x8000BEA0 : AT(0x0000CAA0) { FILL(0x00000000); build/asm/main_8000BEA0.s.o(.text); build/asm/main_8000BEA0.s.o(.rodata); build/asm/main_8000BEA0.s.o(.data); }
    .main_8000BEA0_bss (NOLOAD) : { build/asm/main_8000BEA0.s.o(.bss); }
    .main_8000D4C0 0x8000D4C0 : AT(0x0000E0C0) { build/asm/data/main_8000D4C0.bin.o(.data); }
    .main_8000F89C 0x8000F89C : AT(0x0001049C) { FILL(0x00000000); build/asm/main_8000F89C.s.o(.text); build/asm/main_8000F89C.s.o(.rodata); build/asm/main_8000F89C.s.o(.data); }
    .main_8000F89C_bss (NOLOAD) : { build/asm/main_8000F89C.s.o(.bss); }
    .main_800948AC 0x800948AC : AT(0x000954AC) { build/asm/data/main_800948AC.bin.o(.data); }
    .main_8009568C 0x8009568C : AT(0x0009628C) { FILL(0x00000000); build/asm/main_8009568C.s.o(.text); build/asm/main_8009568C.s.o(.rodata); build/asm/main_8009568C.s.o(.data); }
    .main_8009568C_bss (NOLOAD) : { build/asm/main_8009568C.s.o(.bss); }
    .main_800AEAA0 0x800AEAA0 : AT(0x000AF6A0) { build/asm/data/main_800AEAA0.bin.o(.data); }
    .main_800B09D8 0x800B09D8 : AT(0x000B15D8) { FILL(0x00000000); build/asm/main_800B09D8.s.o(.text); build/asm/main_800B09D8.s.o(.rodata); build/asm/main_800B09D8.s.o(.data); }
    .main_800B09D8_bss (NOLOAD) : { build/asm/main_800B09D8.s.o(.bss); }
    .main_800B0C60 0x800B0C60 : AT(0x000B1860) { build/asm/data/main_800B0C60.bin.o(.data); }
    .main_800B13F8 0x800B13F8 : AT(0x000B1FF8) { FILL(0x00000000); build/asm/main_800B13F8.s.o(.text); build/asm/main_800B13F8.s.o(.rodata); build/asm/main_800B13F8.s.o(.data); }
    .main_800B13F8_bss (NOLOAD) : { build/asm/main_800B13F8.s.o(.bss); }
    .main_800B222C 0x800B222C : AT(0x000B2E2C) { build/asm/data/main_800B222C.bin.o(.data); }
    .main_800B61A8 0x800B61A8 : AT(0x000B6DA8) { FILL(0x00000000); build/asm/main_800B61A8.s.o(.text); build/asm/main_800B61A8.s.o(.rodata); build/asm/main_800B61A8.s.o(.data); }
    .main_800B61A8_bss (NOLOAD) : { build/asm/main_800B61A8.s.o(.bss); }
    .main_800B65A8 0x800B65A8 : AT(0x000B71A8) { build/asm/data/main_800B65A8.bin.o(.data); }
    .main_800B67C8 0x800B67C8 : AT(0x000B73C8) { FILL(0x00000000); build/asm/main_800B67C8.s.o(.text); build/asm/main_800B67C8.s.o(.rodata); build/asm/main_800B67C8.s.o(.data); }
    .main_800B67C8_bss (NOLOAD) : { build/asm/main_800B67C8.s.o(.bss); }
    .main_800B7678 0x800B7678 : AT(0x000B8278) { build/asm/data/main_800B7678.bin.o(.data); }
    .main_800B92A8 0x800B92A8 : AT(0x000B9EA8) { FILL(0x00000000); build/asm/main_800B92A8.s.o(.text); build/asm/main_800B92A8.s.o(.rodata); build/asm/main_800B92A8.s.o(.data); }
    .main_800B92A8_bss (NOLOAD) : { build/asm/main_800B92A8.s.o(.bss); }
    .main_800BB964 0x800BB964 : AT(0x000BC564) { build/asm/data/main_800BB964.bin.o(.data); }
    .main_800D97FC 0x800D97FC : AT(0x000DA3FC) { FILL(0x00000000); build/asm/main_800D97FC.s.o(.text); build/asm/main_800D97FC.s.o(.rodata); build/asm/main_800D97FC.s.o(.data); }
    .main_800D97FC_bss (NOLOAD) : { build/asm/main_800D97FC.s.o(.bss); }
    .main_800D9808 0x800D9808 : AT(0x000DA408) { build/asm/data/main_800D9808.bin.o(.data); }
    .main_800E601C 0x800E601C : AT(0x000E6C1C) { FILL(0x00000000); build/asm/main_800E601C.s.o(.text); build/asm/main_800E601C.s.o(.rodata); build/asm/main_800E601C.s.o(.data); }
    .main_800E601C_bss (NOLOAD) : { build/asm/main_800E601C.s.o(.bss); }
    .main_800E6030 0x800E6030 : AT(0x000E6C30) { build/asm/data/main_800E6030.bin.o(.data); }
    .main_800F976C 0x800F976C : AT(0x000FA36C) { FILL(0x00000000); build/asm/main_800F976C.s.o(.text); build/asm/main_800F976C.s.o(.rodata); build/asm/main_800F976C.s.o(.data); }
    .main_800F976C_bss (NOLOAD) : { build/asm/main_800F976C.s.o(.bss); }
    .main_800F97AC 0x800F97AC : AT(0x000FA3AC) { build/asm/data/main_800F97AC.bin.o(.data); }
    .main_800FFFFC 0x800FFFFC : AT(0x00100BFC) { FILL(0x00000000); build/asm/main_800FFFFC.s.o(.text); build/asm/main_800FFFFC.s.o(.rodata); build/asm/main_800FFFFC.s.o(.data); }
    .main_800FFFFC_bss (NOLOAD) : { build/asm/main_800FFFFC.s.o(.bss); }
    .main_80100008 0x80100008 : AT(0x00100C08) { build/asm/data/main_80100008.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
