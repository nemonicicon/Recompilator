SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80084314 0x80084314 : AT(0x00084F14) { FILL(0x00000000); build/asm/main_80084314.s.o(.text); build/asm/main_80084314.s.o(.rodata); build/asm/main_80084314.s.o(.data); }
    .main_80084314_bss (NOLOAD) : { build/asm/main_80084314.s.o(.bss); }
    .main_800846E0 0x800846E0 : AT(0x000852E0) { FILL(0x00000000); build/asm/main_800846E0.s.o(.text); build/asm/main_800846E0.s.o(.rodata); build/asm/main_800846E0.s.o(.data); }
    .main_800846E0_bss (NOLOAD) : { build/asm/main_800846E0.s.o(.bss); }
    .main_80092384 0x80092384 : AT(0x00092F84) { build/asm/data/main_80092384.bin.o(.data); }
    .main_80095548 0x80095548 : AT(0x00096148) { build/asm/data/main_80095548.bin.o(.data); }
    .main_80096170 0x80096170 : AT(0x00096D70) { build/asm/data/main_80096170.bin.o(.data); }
    .main_80098864 0x80098864 : AT(0x00099464) { build/asm/data/main_80098864.bin.o(.data); }
    .main_8009D52C 0x8009D52C : AT(0x0009E12C) { FILL(0x00000000); build/asm/main_8009D52C.s.o(.text); build/asm/main_8009D52C.s.o(.rodata); build/asm/main_8009D52C.s.o(.data); }
    .main_8009D52C_bss (NOLOAD) : { build/asm/main_8009D52C.s.o(.bss); }
    .main_8009D65C 0x8009D65C : AT(0x0009E25C) { FILL(0x00000000); build/asm/main_8009D65C.s.o(.text); build/asm/main_8009D65C.s.o(.rodata); build/asm/main_8009D65C.s.o(.data); }
    .main_8009D65C_bss (NOLOAD) : { build/asm/main_8009D65C.s.o(.bss); }
    .main_8009D794 0x8009D794 : AT(0x0009E394) { FILL(0x00000000); build/asm/main_8009D794.s.o(.text); build/asm/main_8009D794.s.o(.rodata); build/asm/main_8009D794.s.o(.data); }
    .main_8009D794_bss (NOLOAD) : { build/asm/main_8009D794.s.o(.bss); }
    .main_8009E05C 0x8009E05C : AT(0x0009EC5C) { FILL(0x00000000); build/asm/main_8009E05C.s.o(.text); build/asm/main_8009E05C.s.o(.rodata); build/asm/main_8009E05C.s.o(.data); }
    .main_8009E05C_bss (NOLOAD) : { build/asm/main_8009E05C.s.o(.bss); }
    .main_8009E068 0x8009E068 : AT(0x0009EC68) { build/asm/data/main_8009E068.bin.o(.data); }
    .main_8009E0A8 0x8009E0A8 : AT(0x0009ECA8) { FILL(0x00000000); build/asm/main_8009E0A8.s.o(.text); build/asm/main_8009E0A8.s.o(.rodata); build/asm/main_8009E0A8.s.o(.data); }
    .main_8009E0A8_bss (NOLOAD) : { build/asm/main_8009E0A8.s.o(.bss); }
    .main_8009E0B4 0x8009E0B4 : AT(0x0009ECB4) { build/asm/data/main_8009E0B4.bin.o(.data); }
    .main_8009E91C 0x8009E91C : AT(0x0009F51C) { FILL(0x00000000); build/asm/main_8009E91C.s.o(.text); build/asm/main_8009E91C.s.o(.rodata); build/asm/main_8009E91C.s.o(.data); }
    .main_8009E91C_bss (NOLOAD) : { build/asm/main_8009E91C.s.o(.bss); }
    .main_8009EA90 0x8009EA90 : AT(0x0009F690) { FILL(0x00000000); build/asm/main_8009EA90.s.o(.text); build/asm/main_8009EA90.s.o(.rodata); build/asm/main_8009EA90.s.o(.data); }
    .main_8009EA90_bss (NOLOAD) : { build/asm/main_8009EA90.s.o(.bss); }
    .main_8009EA9C 0x8009EA9C : AT(0x0009F69C) { FILL(0x00000000); build/asm/main_8009EA9C.s.o(.text); build/asm/main_8009EA9C.s.o(.rodata); build/asm/main_8009EA9C.s.o(.data); }
    .main_8009EA9C_bss (NOLOAD) : { build/asm/main_8009EA9C.s.o(.bss); }
    .main_8009EAC4 0x8009EAC4 : AT(0x0009F6C4) { FILL(0x00000000); build/asm/main_8009EAC4.s.o(.text); build/asm/main_8009EAC4.s.o(.rodata); build/asm/main_8009EAC4.s.o(.data); }
    .main_8009EAC4_bss (NOLOAD) : { build/asm/main_8009EAC4.s.o(.bss); }
    .main_8009EB38 0x8009EB38 : AT(0x0009F738) { FILL(0x00000000); build/asm/main_8009EB38.s.o(.text); build/asm/main_8009EB38.s.o(.rodata); build/asm/main_8009EB38.s.o(.data); }
    .main_8009EB38_bss (NOLOAD) : { build/asm/main_8009EB38.s.o(.bss); }
    .main_8009EB5C 0x8009EB5C : AT(0x0009F75C) { FILL(0x00000000); build/asm/main_8009EB5C.s.o(.text); build/asm/main_8009EB5C.s.o(.rodata); build/asm/main_8009EB5C.s.o(.data); }
    .main_8009EB5C_bss (NOLOAD) : { build/asm/main_8009EB5C.s.o(.bss); }
    .main_800A789C 0x800A789C : AT(0x000A849C) { FILL(0x00000000); build/asm/main_800A789C.s.o(.text); build/asm/main_800A789C.s.o(.rodata); build/asm/main_800A789C.s.o(.data); }
    .main_800A789C_bss (NOLOAD) : { build/asm/main_800A789C.s.o(.bss); }
    .main_800A7B40 0x800A7B40 : AT(0x000A8740) { FILL(0x00000000); build/asm/main_800A7B40.s.o(.text); build/asm/main_800A7B40.s.o(.rodata); build/asm/main_800A7B40.s.o(.data); }
    .main_800A7B40_bss (NOLOAD) : { build/asm/main_800A7B40.s.o(.bss); }
    .main_800A8080 0x800A8080 : AT(0x000A8C80) { build/asm/data/main_800A8080.bin.o(.data); }
    .main_800A84B8 0x800A84B8 : AT(0x000A90B8) { FILL(0x00000000); build/asm/main_800A84B8.s.o(.text); build/asm/main_800A84B8.s.o(.rodata); build/asm/main_800A84B8.s.o(.data); }
    .main_800A84B8_bss (NOLOAD) : { build/asm/main_800A84B8.s.o(.bss); }
    .main_800AB5F0 0x800AB5F0 : AT(0x000AC1F0) { FILL(0x00000000); build/asm/main_800AB5F0.s.o(.text); build/asm/main_800AB5F0.s.o(.rodata); build/asm/main_800AB5F0.s.o(.data); }
    .main_800AB5F0_bss (NOLOAD) : { build/asm/main_800AB5F0.s.o(.bss); }
    .main_800AC10C 0x800AC10C : AT(0x000ACD0C) { build/asm/data/main_800AC10C.bin.o(.data); }
    .main_800B3AF4 0x800B3AF4 : AT(0x000B46F4) { build/asm/data/main_800B3AF4.bin.o(.data); }
    .main_800B40C0 0x800B40C0 : AT(0x000B4CC0) { build/asm/data/main_800B40C0.bin.o(.data); }
    .main_800B4D10 0x800B4D10 : AT(0x000B5910) { FILL(0x00000000); build/asm/main_800B4D10.s.o(.text); build/asm/main_800B4D10.s.o(.rodata); build/asm/main_800B4D10.s.o(.data); }
    .main_800B4D10_bss (NOLOAD) : { build/asm/main_800B4D10.s.o(.bss); }
    .main_800B4D8C 0x800B4D8C : AT(0x000B598C) { FILL(0x00000000); build/asm/main_800B4D8C.s.o(.text); build/asm/main_800B4D8C.s.o(.rodata); build/asm/main_800B4D8C.s.o(.data); }
    .main_800B4D8C_bss (NOLOAD) : { build/asm/main_800B4D8C.s.o(.bss); }
    .main_800B5470 0x800B5470 : AT(0x000B6070) { build/asm/data/main_800B5470.bin.o(.data); }
    .main_800B5C7C 0x800B5C7C : AT(0x000B687C) { build/asm/data/main_800B5C7C.bin.o(.data); }
    .main_800B6198 0x800B6198 : AT(0x000B6D98) { build/asm/data/main_800B6198.bin.o(.data); }
    .main_800B66C0 0x800B66C0 : AT(0x000B72C0) { FILL(0x00000000); build/asm/main_800B66C0.s.o(.text); build/asm/main_800B66C0.s.o(.rodata); build/asm/main_800B66C0.s.o(.data); }
    .main_800B66C0_bss (NOLOAD) : { build/asm/main_800B66C0.s.o(.bss); }
    .main_800B6AE4 0x800B6AE4 : AT(0x000B76E4) { build/asm/data/main_800B6AE4.bin.o(.data); }
    .main_800B6DA4 0x800B6DA4 : AT(0x000B79A4) { build/asm/data/main_800B6DA4.bin.o(.data); }
    .main_800B6E24 0x800B6E24 : AT(0x000B7A24) { FILL(0x00000000); build/asm/main_800B6E24.s.o(.text); build/asm/main_800B6E24.s.o(.rodata); build/asm/main_800B6E24.s.o(.data); }
    .main_800B6E24_bss (NOLOAD) : { build/asm/main_800B6E24.s.o(.bss); }
    .main_800B7238 0x800B7238 : AT(0x000B7E38) { build/asm/data/main_800B7238.bin.o(.data); }
    .main_800B72E0 0x800B72E0 : AT(0x000B7EE0) { FILL(0x00000000); build/asm/main_800B72E0.s.o(.text); build/asm/main_800B72E0.s.o(.rodata); build/asm/main_800B72E0.s.o(.data); }
    .main_800B72E0_bss (NOLOAD) : { build/asm/main_800B72E0.s.o(.bss); }
    .main_800B7950 0x800B7950 : AT(0x000B8550) { FILL(0x00000000); build/asm/main_800B7950.s.o(.text); build/asm/main_800B7950.s.o(.rodata); build/asm/main_800B7950.s.o(.data); }
    .main_800B7950_bss (NOLOAD) : { build/asm/main_800B7950.s.o(.bss); }
    .main_800B79B4 0x800B79B4 : AT(0x000B85B4) { build/asm/data/main_800B79B4.bin.o(.data); }
    .main_800B7B04 0x800B7B04 : AT(0x000B8704) { build/asm/data/main_800B7B04.bin.o(.data); }
    .main_800B7CFC 0x800B7CFC : AT(0x000B88FC) { FILL(0x00000000); build/asm/main_800B7CFC.s.o(.text); build/asm/main_800B7CFC.s.o(.rodata); build/asm/main_800B7CFC.s.o(.data); }
    .main_800B7CFC_bss (NOLOAD) : { build/asm/main_800B7CFC.s.o(.bss); }
    .main_800B7D38 0x800B7D38 : AT(0x000B8938) { build/asm/data/main_800B7D38.bin.o(.data); }
    .main_800B81EC 0x800B81EC : AT(0x000B8DEC) { FILL(0x00000000); build/asm/main_800B81EC.s.o(.text); build/asm/main_800B81EC.s.o(.rodata); build/asm/main_800B81EC.s.o(.data); }
    .main_800B81EC_bss (NOLOAD) : { build/asm/main_800B81EC.s.o(.bss); }
    .main_800B8230 0x800B8230 : AT(0x000B8E30) { build/asm/data/main_800B8230.bin.o(.data); }
    .main_800B8BFC 0x800B8BFC : AT(0x000B97FC) { FILL(0x00000000); build/asm/main_800B8BFC.s.o(.text); build/asm/main_800B8BFC.s.o(.rodata); build/asm/main_800B8BFC.s.o(.data); }
    .main_800B8BFC_bss (NOLOAD) : { build/asm/main_800B8BFC.s.o(.bss); }
    .main_800B91C8 0x800B91C8 : AT(0x000B9DC8) { build/asm/data/main_800B91C8.bin.o(.data); }
    .main_800BA1D0 0x800BA1D0 : AT(0x000BADD0) { FILL(0x00000000); build/asm/main_800BA1D0.s.o(.text); build/asm/main_800BA1D0.s.o(.rodata); build/asm/main_800BA1D0.s.o(.data); }
    .main_800BA1D0_bss (NOLOAD) : { build/asm/main_800BA1D0.s.o(.bss); }
    .main_800BA1D4 0x800BA1D4 : AT(0x000BADD4) { build/asm/data/main_800BA1D4.bin.o(.data); }
    .main_800BA81C 0x800BA81C : AT(0x000BB41C) { build/asm/data/main_800BA81C.bin.o(.data); }
    .main_800BB228 0x800BB228 : AT(0x000BBE28) { FILL(0x00000000); build/asm/main_800BB228.s.o(.text); build/asm/main_800BB228.s.o(.rodata); build/asm/main_800BB228.s.o(.data); }
    .main_800BB228_bss (NOLOAD) : { build/asm/main_800BB228.s.o(.bss); }
    .main_800BB7F4 0x800BB7F4 : AT(0x000BC3F4) { FILL(0x00000000); build/asm/main_800BB7F4.s.o(.text); build/asm/main_800BB7F4.s.o(.rodata); build/asm/main_800BB7F4.s.o(.data); }
    .main_800BB7F4_bss (NOLOAD) : { build/asm/main_800BB7F4.s.o(.bss); }
    .main_800BBADC 0x800BBADC : AT(0x000BC6DC) { build/asm/data/main_800BBADC.bin.o(.data); }
    .main_800C0758 0x800C0758 : AT(0x000C1358) { build/asm/data/main_800C0758.bin.o(.data); }
    .main_800C1AB0 0x800C1AB0 : AT(0x000C26B0) { build/asm/data/main_800C1AB0.bin.o(.data); }
    .main_800C4438 0x800C4438 : AT(0x000C5038) { build/asm/data/main_800C4438.bin.o(.data); }
    .main_800C484C 0x800C484C : AT(0x000C544C) { FILL(0x00000000); build/asm/main_800C484C.s.o(.text); build/asm/main_800C484C.s.o(.rodata); build/asm/main_800C484C.s.o(.data); }
    .main_800C484C_bss (NOLOAD) : { build/asm/main_800C484C.s.o(.bss); }
    .main_800C48EC 0x800C48EC : AT(0x000C54EC) { build/asm/data/main_800C48EC.bin.o(.data); }
    .main_800C5C74 0x800C5C74 : AT(0x000C6874) { build/asm/data/main_800C5C74.bin.o(.data); }
    .main_800C6AE8 0x800C6AE8 : AT(0x000C76E8) { build/asm/data/main_800C6AE8.bin.o(.data); }
    .main_800C83AC 0x800C83AC : AT(0x000C8FAC) { FILL(0x00000000); build/asm/main_800C83AC.s.o(.text); build/asm/main_800C83AC.s.o(.rodata); build/asm/main_800C83AC.s.o(.data); }
    .main_800C83AC_bss (NOLOAD) : { build/asm/main_800C83AC.s.o(.bss); }
    .main_800C83D0 0x800C83D0 : AT(0x000C8FD0) { build/asm/data/main_800C83D0.bin.o(.data); }
    .main_800C9384 0x800C9384 : AT(0x000C9F84) { build/asm/data/main_800C9384.bin.o(.data); }
    .main_800CABE8 0x800CABE8 : AT(0x000CB7E8) { FILL(0x00000000); build/asm/main_800CABE8.s.o(.text); build/asm/main_800CABE8.s.o(.rodata); build/asm/main_800CABE8.s.o(.data); }
    .main_800CABE8_bss (NOLOAD) : { build/asm/main_800CABE8.s.o(.bss); }
    .main_800CAC94 0x800CAC94 : AT(0x000CB894) { build/asm/data/main_800CAC94.bin.o(.data); }
    .main_800CF9A4 0x800CF9A4 : AT(0x000D05A4) { FILL(0x00000000); build/asm/main_800CF9A4.s.o(.text); build/asm/main_800CF9A4.s.o(.rodata); build/asm/main_800CF9A4.s.o(.data); }
    .main_800CF9A4_bss (NOLOAD) : { build/asm/main_800CF9A4.s.o(.bss); }
    .main_800CF9D8 0x800CF9D8 : AT(0x000D05D8) { build/asm/data/main_800CF9D8.bin.o(.data); }
    .main_800D0860 0x800D0860 : AT(0x000D1460) { FILL(0x00000000); build/asm/main_800D0860.s.o(.text); build/asm/main_800D0860.s.o(.rodata); build/asm/main_800D0860.s.o(.data); }
    .main_800D0860_bss (NOLOAD) : { build/asm/main_800D0860.s.o(.bss); }
    .main_800D096C 0x800D096C : AT(0x000D156C) { build/asm/data/main_800D096C.bin.o(.data); }
    .main_800D208C 0x800D208C : AT(0x000D2C8C) { FILL(0x00000000); build/asm/main_800D208C.s.o(.text); build/asm/main_800D208C.s.o(.rodata); build/asm/main_800D208C.s.o(.data); }
    .main_800D208C_bss (NOLOAD) : { build/asm/main_800D208C.s.o(.bss); }
    .main_800D21CC 0x800D21CC : AT(0x000D2DCC) { build/asm/data/main_800D21CC.bin.o(.data); }
    .main_800D83AC 0x800D83AC : AT(0x000D8FAC) { build/asm/data/main_800D83AC.bin.o(.data); }
    .main_800D9D2C 0x800D9D2C : AT(0x000DA92C) { build/asm/data/main_800D9D2C.bin.o(.data); }
    .main_800D9EBC 0x800D9EBC : AT(0x000DAABC) { build/asm/data/main_800D9EBC.bin.o(.data); }
    .main_800DA66C 0x800DA66C : AT(0x000DB26C) { FILL(0x00000000); build/asm/main_800DA66C.s.o(.text); build/asm/main_800DA66C.s.o(.rodata); build/asm/main_800DA66C.s.o(.data); }
    .main_800DA66C_bss (NOLOAD) : { build/asm/main_800DA66C.s.o(.bss); }
    .main_800DA700 0x800DA700 : AT(0x000DB300) { build/asm/data/main_800DA700.bin.o(.data); }
    .main_800DAE14 0x800DAE14 : AT(0x000DBA14) { build/asm/data/main_800DAE14.bin.o(.data); }
    .main_800DB640 0x800DB640 : AT(0x000DC240) { build/asm/data/main_800DB640.bin.o(.data); }
    .main_800E8564 0x800E8564 : AT(0x000E9164) { build/asm/data/main_800E8564.bin.o(.data); }
    .main_800F6094 0x800F6094 : AT(0x000F6C94) { build/asm/data/main_800F6094.bin.o(.data); }
    .main_800F83E4 0x800F83E4 : AT(0x000F8FE4) { build/asm/data/main_800F83E4.bin.o(.data); }
    .main_800F8620 0x800F8620 : AT(0x000F9220) { build/asm/data/main_800F8620.bin.o(.data); }
    .main_800F8C28 0x800F8C28 : AT(0x000F9828) { build/asm/data/main_800F8C28.bin.o(.data); }
    .main_800FB684 0x800FB684 : AT(0x000FC284) { build/asm/data/main_800FB684.bin.o(.data); }
    .main_800FD4B0 0x800FD4B0 : AT(0x000FE0B0) { build/asm/data/main_800FD4B0.bin.o(.data); }
    .main_800FE658 0x800FE658 : AT(0x000FF258) { build/asm/data/main_800FE658.bin.o(.data); }
    .main_800FFE48 0x800FFE48 : AT(0x00100A48) { build/asm/data/main_800FFE48.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
