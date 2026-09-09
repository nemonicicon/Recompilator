SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80099110 0x80099110 : AT(0x00099D10) { FILL(0x00000000); build/asm/main_80099110.s.o(.text); build/asm/main_80099110.s.o(.rodata); build/asm/main_80099110.s.o(.data); }
    .main_80099110_bss (NOLOAD) : { build/asm/main_80099110.s.o(.bss); }
    .main_8009AD80 0x8009AD80 : AT(0x0009B980) { FILL(0x00000000); build/asm/main_8009AD80.s.o(.text); build/asm/main_8009AD80.s.o(.rodata); build/asm/main_8009AD80.s.o(.data); }
    .main_8009AD80_bss (NOLOAD) : { build/asm/main_8009AD80.s.o(.bss); }
    .main_8009C230 0x8009C230 : AT(0x0009CE30) { FILL(0x00000000); build/asm/main_8009C230.s.o(.text); build/asm/main_8009C230.s.o(.rodata); build/asm/main_8009C230.s.o(.data); }
    .main_8009C230_bss (NOLOAD) : { build/asm/main_8009C230.s.o(.bss); }
    .main_8009FD40 0x8009FD40 : AT(0x000A0940) { FILL(0x00000000); build/asm/main_8009FD40.s.o(.text); build/asm/main_8009FD40.s.o(.rodata); build/asm/main_8009FD40.s.o(.data); }
    .main_8009FD40_bss (NOLOAD) : { build/asm/main_8009FD40.s.o(.bss); }
    .main_800A5AC0 0x800A5AC0 : AT(0x000A66C0) { FILL(0x00000000); build/asm/main_800A5AC0.s.o(.text); build/asm/main_800A5AC0.s.o(.rodata); build/asm/main_800A5AC0.s.o(.data); }
    .main_800A5AC0_bss (NOLOAD) : { build/asm/main_800A5AC0.s.o(.bss); }
    .main_800A610C 0x800A610C : AT(0x000A6D0C) { FILL(0x00000000); build/asm/main_800A610C.s.o(.text); build/asm/main_800A610C.s.o(.rodata); build/asm/main_800A610C.s.o(.data); }
    .main_800A610C_bss (NOLOAD) : { build/asm/main_800A610C.s.o(.bss); }
    .main_800A6460 0x800A6460 : AT(0x000A7060) { FILL(0x00000000); build/asm/main_800A6460.s.o(.text); build/asm/main_800A6460.s.o(.rodata); build/asm/main_800A6460.s.o(.data); }
    .main_800A6460_bss (NOLOAD) : { build/asm/main_800A6460.s.o(.bss); }
    .main_800A6490 0x800A6490 : AT(0x000A7090) { FILL(0x00000000); build/asm/main_800A6490.s.o(.text); build/asm/main_800A6490.s.o(.rodata); build/asm/main_800A6490.s.o(.data); }
    .main_800A6490_bss (NOLOAD) : { build/asm/main_800A6490.s.o(.bss); }
    .main_800A72C0 0x800A72C0 : AT(0x000A7EC0) { FILL(0x00000000); build/asm/main_800A72C0.s.o(.text); build/asm/main_800A72C0.s.o(.rodata); build/asm/main_800A72C0.s.o(.data); }
    .main_800A72C0_bss (NOLOAD) : { build/asm/main_800A72C0.s.o(.bss); }
    .main_800AD810 0x800AD810 : AT(0x000AE410) { FILL(0x00000000); build/asm/main_800AD810.s.o(.text); build/asm/main_800AD810.s.o(.rodata); build/asm/main_800AD810.s.o(.data); }
    .main_800AD810_bss (NOLOAD) : { build/asm/main_800AD810.s.o(.bss); }
    .main_800BEE88 0x800BEE88 : AT(0x000BFA88) { build/asm/data/main_800BEE88.bin.o(.data); }
    .main_800C320C 0x800C320C : AT(0x000C3E0C) { FILL(0x00000000); build/asm/main_800C320C.s.o(.text); build/asm/main_800C320C.s.o(.rodata); build/asm/main_800C320C.s.o(.data); }
    .main_800C320C_bss (NOLOAD) : { build/asm/main_800C320C.s.o(.bss); }
    .main_800C646C 0x800C646C : AT(0x000C706C) { build/asm/data/main_800C646C.bin.o(.data); }
    .main_800C7284 0x800C7284 : AT(0x000C7E84) { FILL(0x00000000); build/asm/main_800C7284.s.o(.text); build/asm/main_800C7284.s.o(.rodata); build/asm/main_800C7284.s.o(.data); }
    .main_800C7284_bss (NOLOAD) : { build/asm/main_800C7284.s.o(.bss); }
    .main_800C7930 0x800C7930 : AT(0x000C8530) { FILL(0x00000000); build/asm/main_800C7930.s.o(.text); build/asm/main_800C7930.s.o(.rodata); build/asm/main_800C7930.s.o(.data); }
    .main_800C7930_bss (NOLOAD) : { build/asm/main_800C7930.s.o(.bss); }
    .main_800CA154 0x800CA154 : AT(0x000CAD54) { build/asm/data/main_800CA154.bin.o(.data); }
    .main_800CD988 0x800CD988 : AT(0x000CE588) { FILL(0x00000000); build/asm/main_800CD988.s.o(.text); build/asm/main_800CD988.s.o(.rodata); build/asm/main_800CD988.s.o(.data); }
    .main_800CD988_bss (NOLOAD) : { build/asm/main_800CD988.s.o(.bss); }
    .main_800D06DC 0x800D06DC : AT(0x000D12DC) { FILL(0x00000000); build/asm/main_800D06DC.s.o(.text); build/asm/main_800D06DC.s.o(.rodata); build/asm/main_800D06DC.s.o(.data); }
    .main_800D06DC_bss (NOLOAD) : { build/asm/main_800D06DC.s.o(.bss); }
    .main_800D0FA8 0x800D0FA8 : AT(0x000D1BA8) { FILL(0x00000000); build/asm/main_800D0FA8.s.o(.text); build/asm/main_800D0FA8.s.o(.rodata); build/asm/main_800D0FA8.s.o(.data); }
    .main_800D0FA8_bss (NOLOAD) : { build/asm/main_800D0FA8.s.o(.bss); }
    .main_800D3700 0x800D3700 : AT(0x000D4300) { build/asm/data/main_800D3700.bin.o(.data); }
    .main_800D3870 0x800D3870 : AT(0x000D4470) { build/asm/data/main_800D3870.bin.o(.data); }
    .main_800D41C0 0x800D41C0 : AT(0x000D4DC0) { FILL(0x00000000); build/asm/main_800D41C0.s.o(.text); build/asm/main_800D41C0.s.o(.rodata); build/asm/main_800D41C0.s.o(.data); }
    .main_800D41C0_bss (NOLOAD) : { build/asm/main_800D41C0.s.o(.bss); }
    .main_800D543C 0x800D543C : AT(0x000D603C) { FILL(0x00000000); build/asm/main_800D543C.s.o(.text); build/asm/main_800D543C.s.o(.rodata); build/asm/main_800D543C.s.o(.data); }
    .main_800D543C_bss (NOLOAD) : { build/asm/main_800D543C.s.o(.bss); }
    .main_800D56F4 0x800D56F4 : AT(0x000D62F4) { build/asm/data/main_800D56F4.bin.o(.data); }
    .main_800D5EFC 0x800D5EFC : AT(0x000D6AFC) { build/asm/data/main_800D5EFC.bin.o(.data); }
    .main_800D5FFC 0x800D5FFC : AT(0x000D6BFC) { FILL(0x00000000); build/asm/main_800D5FFC.s.o(.text); build/asm/main_800D5FFC.s.o(.rodata); build/asm/main_800D5FFC.s.o(.data); }
    .main_800D5FFC_bss (NOLOAD) : { build/asm/main_800D5FFC.s.o(.bss); }
    .main_800D66E8 0x800D66E8 : AT(0x000D72E8) { build/asm/data/main_800D66E8.bin.o(.data); }
    .main_800D8758 0x800D8758 : AT(0x000D9358) { build/asm/data/main_800D8758.bin.o(.data); }
    .main_800D90B8 0x800D90B8 : AT(0x000D9CB8) { build/asm/data/main_800D90B8.bin.o(.data); }
    .main_800D9840 0x800D9840 : AT(0x000DA440) { FILL(0x00000000); build/asm/main_800D9840.s.o(.text); build/asm/main_800D9840.s.o(.rodata); build/asm/main_800D9840.s.o(.data); }
    .main_800D9840_bss (NOLOAD) : { build/asm/main_800D9840.s.o(.bss); }
    .main_800DBBB8 0x800DBBB8 : AT(0x000DC7B8) { FILL(0x00000000); build/asm/main_800DBBB8.s.o(.text); build/asm/main_800DBBB8.s.o(.rodata); build/asm/main_800DBBB8.s.o(.data); }
    .main_800DBBB8_bss (NOLOAD) : { build/asm/main_800DBBB8.s.o(.bss); }
    .main_800DEB70 0x800DEB70 : AT(0x000DF770) { build/asm/data/main_800DEB70.bin.o(.data); }
    .main_800DF134 0x800DF134 : AT(0x000DFD34) { FILL(0x00000000); build/asm/main_800DF134.s.o(.text); build/asm/main_800DF134.s.o(.rodata); build/asm/main_800DF134.s.o(.data); }
    .main_800DF134_bss (NOLOAD) : { build/asm/main_800DF134.s.o(.bss); }
    .main_800DFB20 0x800DFB20 : AT(0x000E0720) { FILL(0x00000000); build/asm/main_800DFB20.s.o(.text); build/asm/main_800DFB20.s.o(.rodata); build/asm/main_800DFB20.s.o(.data); }
    .main_800DFB20_bss (NOLOAD) : { build/asm/main_800DFB20.s.o(.bss); }
    .main_800DFF5C 0x800DFF5C : AT(0x000E0B5C) { FILL(0x00000000); build/asm/main_800DFF5C.s.o(.text); build/asm/main_800DFF5C.s.o(.rodata); build/asm/main_800DFF5C.s.o(.data); }
    .main_800DFF5C_bss (NOLOAD) : { build/asm/main_800DFF5C.s.o(.bss); }
    .main_800E2C08 0x800E2C08 : AT(0x000E3808) { FILL(0x00000000); build/asm/main_800E2C08.s.o(.text); build/asm/main_800E2C08.s.o(.rodata); build/asm/main_800E2C08.s.o(.data); }
    .main_800E2C08_bss (NOLOAD) : { build/asm/main_800E2C08.s.o(.bss); }
    .main_800EB73C 0x800EB73C : AT(0x000EC33C) { FILL(0x00000000); build/asm/main_800EB73C.s.o(.text); build/asm/main_800EB73C.s.o(.rodata); build/asm/main_800EB73C.s.o(.data); }
    .main_800EB73C_bss (NOLOAD) : { build/asm/main_800EB73C.s.o(.bss); }
    .main_800EBFD4 0x800EBFD4 : AT(0x000ECBD4) { FILL(0x00000000); build/asm/main_800EBFD4.s.o(.text); build/asm/main_800EBFD4.s.o(.rodata); build/asm/main_800EBFD4.s.o(.data); }
    .main_800EBFD4_bss (NOLOAD) : { build/asm/main_800EBFD4.s.o(.bss); }
    .main_800ECD40 0x800ECD40 : AT(0x000ED940) { build/asm/data/main_800ECD40.bin.o(.data); }
    .main_800ED790 0x800ED790 : AT(0x000EE390) { build/asm/data/main_800ED790.bin.o(.data); }
    .main_800EE1C0 0x800EE1C0 : AT(0x000EEDC0) { FILL(0x00000000); build/asm/main_800EE1C0.s.o(.text); build/asm/main_800EE1C0.s.o(.rodata); build/asm/main_800EE1C0.s.o(.data); }
    .main_800EE1C0_bss (NOLOAD) : { build/asm/main_800EE1C0.s.o(.bss); }
    .main_800EF0FC 0x800EF0FC : AT(0x000EFCFC) { build/asm/data/main_800EF0FC.bin.o(.data); }
    .main_800EFC54 0x800EFC54 : AT(0x000F0854) { build/asm/data/main_800EFC54.bin.o(.data); }
    .main_800F8E74 0x800F8E74 : AT(0x000F9A74) { build/asm/data/main_800F8E74.bin.o(.data); }
    .main_800FAFEC 0x800FAFEC : AT(0x000FBBEC) { build/asm/data/main_800FAFEC.bin.o(.data); }
    .main_800FBF90 0x800FBF90 : AT(0x000FCB90) { build/asm/data/main_800FBF90.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
