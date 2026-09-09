SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80001000 0x80001000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80001000.s.o(.text); build/asm/main_80001000.s.o(.rodata); build/asm/main_80001000.s.o(.data); }
    .main_80001000_bss (NOLOAD) : { build/asm/main_80001000.s.o(.bss); }
    .main_800990B8 0x800990B8 : AT(0x000990B8) { FILL(0x00000000); build/asm/main_800990B8.s.o(.text); build/asm/main_800990B8.s.o(.rodata); build/asm/main_800990B8.s.o(.data); }
    .main_800990B8_bss (NOLOAD) : { build/asm/main_800990B8.s.o(.bss); }
    .main_800993D0 0x800993D0 : AT(0x000993D0) { FILL(0x00000000); build/asm/main_800993D0.s.o(.text); build/asm/main_800993D0.s.o(.rodata); build/asm/main_800993D0.s.o(.data); }
    .main_800993D0_bss (NOLOAD) : { build/asm/main_800993D0.s.o(.bss); }
    .main_800A642C 0x800A642C : AT(0x000A642C) { FILL(0x00000000); build/asm/main_800A642C.s.o(.text); build/asm/main_800A642C.s.o(.rodata); build/asm/main_800A642C.s.o(.data); }
    .main_800A642C_bss (NOLOAD) : { build/asm/main_800A642C.s.o(.bss); }
    .main_800A6448 0x800A6448 : AT(0x000A6448) { build/asm/data/main_800A6448.bin.o(.data); }
    .main_800B001C 0x800B001C : AT(0x000B001C) { build/asm/data/main_800B001C.bin.o(.data); }
    .main_800B25EC 0x800B25EC : AT(0x000B25EC) { build/asm/data/main_800B25EC.bin.o(.data); }
    .main_800B4C94 0x800B4C94 : AT(0x000B4C94) { build/asm/data/main_800B4C94.bin.o(.data); }
    .main_800B5564 0x800B5564 : AT(0x000B5564) { build/asm/data/main_800B5564.bin.o(.data); }
    .main_800BA5D0 0x800BA5D0 : AT(0x000BA5D0) { build/asm/data/main_800BA5D0.bin.o(.data); }
    .main_800BB0DC 0x800BB0DC : AT(0x000BB0DC) { FILL(0x00000000); build/asm/main_800BB0DC.s.o(.text); build/asm/main_800BB0DC.s.o(.rodata); build/asm/main_800BB0DC.s.o(.data); }
    .main_800BB0DC_bss (NOLOAD) : { build/asm/main_800BB0DC.s.o(.bss); }
    .main_800BC1AC 0x800BC1AC : AT(0x000BC1AC) { build/asm/data/main_800BC1AC.bin.o(.data); }
    .main_800BCA88 0x800BCA88 : AT(0x000BCA88) { build/asm/data/main_800BCA88.bin.o(.data); }
    .main_800BCB28 0x800BCB28 : AT(0x000BCB28) { FILL(0x00000000); build/asm/main_800BCB28.s.o(.text); build/asm/main_800BCB28.s.o(.rodata); build/asm/main_800BCB28.s.o(.data); }
    .main_800BCB28_bss (NOLOAD) : { build/asm/main_800BCB28.s.o(.bss); }
    .main_800BCB38 0x800BCB38 : AT(0x000BCB38) { build/asm/data/main_800BCB38.bin.o(.data); }
    .main_800BD258 0x800BD258 : AT(0x000BD258) { FILL(0x00000000); build/asm/main_800BD258.s.o(.text); build/asm/main_800BD258.s.o(.rodata); build/asm/main_800BD258.s.o(.data); }
    .main_800BD258_bss (NOLOAD) : { build/asm/main_800BD258.s.o(.bss); }
    .main_800BD2F0 0x800BD2F0 : AT(0x000BD2F0) { build/asm/data/main_800BD2F0.bin.o(.data); }
    .main_800BE12C 0x800BE12C : AT(0x000BE12C) { build/asm/data/main_800BE12C.bin.o(.data); }
    .main_800BFB88 0x800BFB88 : AT(0x000BFB88) { build/asm/data/main_800BFB88.bin.o(.data); }
    .main_800C09BC 0x800C09BC : AT(0x000C09BC) { build/asm/data/main_800C09BC.bin.o(.data); }
    .main_800C7530 0x800C7530 : AT(0x000C7530) { build/asm/data/main_800C7530.bin.o(.data); }
    .main_800CA720 0x800CA720 : AT(0x000CA720) { build/asm/data/main_800CA720.bin.o(.data); }
    .main_800CCE10 0x800CCE10 : AT(0x000CCE10) { build/asm/data/main_800CCE10.bin.o(.data); }
    .main_800D80A8 0x800D80A8 : AT(0x000D80A8) { FILL(0x00000000); build/asm/main_800D80A8.s.o(.text); build/asm/main_800D80A8.s.o(.rodata); build/asm/main_800D80A8.s.o(.data); }
    .main_800D80A8_bss (NOLOAD) : { build/asm/main_800D80A8.s.o(.bss); }
    .main_800D8B14 0x800D8B14 : AT(0x000D8B14) { build/asm/data/main_800D8B14.bin.o(.data); }
    .main_800DC144 0x800DC144 : AT(0x000DC144) { FILL(0x00000000); build/asm/main_800DC144.s.o(.text); build/asm/main_800DC144.s.o(.rodata); build/asm/main_800DC144.s.o(.data); }
    .main_800DC144_bss (NOLOAD) : { build/asm/main_800DC144.s.o(.bss); }
    .main_800DC29C 0x800DC29C : AT(0x000DC29C) { build/asm/data/main_800DC29C.bin.o(.data); }
    .main_800E3DBC 0x800E3DBC : AT(0x000E3DBC) { FILL(0x00000000); build/asm/main_800E3DBC.s.o(.text); build/asm/main_800E3DBC.s.o(.rodata); build/asm/main_800E3DBC.s.o(.data); }
    .main_800E3DBC_bss (NOLOAD) : { build/asm/main_800E3DBC.s.o(.bss); }
    .main_800E3F54 0x800E3F54 : AT(0x000E3F54) { build/asm/data/main_800E3F54.bin.o(.data); }
    .main_800EA91C 0x800EA91C : AT(0x000EA91C) { FILL(0x00000000); build/asm/main_800EA91C.s.o(.text); build/asm/main_800EA91C.s.o(.rodata); build/asm/main_800EA91C.s.o(.data); }
    .main_800EA91C_bss (NOLOAD) : { build/asm/main_800EA91C.s.o(.bss); }
    .main_800EAAE0 0x800EAAE0 : AT(0x000EAAE0) { build/asm/data/main_800EAAE0.bin.o(.data); }
    .main_800EB1A4 0x800EB1A4 : AT(0x000EB1A4) { FILL(0x00000000); build/asm/main_800EB1A4.s.o(.text); build/asm/main_800EB1A4.s.o(.rodata); build/asm/main_800EB1A4.s.o(.data); }
    .main_800EB1A4_bss (NOLOAD) : { build/asm/main_800EB1A4.s.o(.bss); }
    .main_800EB358 0x800EB358 : AT(0x000EB358) { FILL(0x00000000); build/asm/main_800EB358.s.o(.text); build/asm/main_800EB358.s.o(.rodata); build/asm/main_800EB358.s.o(.data); }
    .main_800EB358_bss (NOLOAD) : { build/asm/main_800EB358.s.o(.bss); }
    .main_800EC298 0x800EC298 : AT(0x000EC298) { FILL(0x00000000); build/asm/main_800EC298.s.o(.text); build/asm/main_800EC298.s.o(.rodata); build/asm/main_800EC298.s.o(.data); }
    .main_800EC298_bss (NOLOAD) : { build/asm/main_800EC298.s.o(.bss); }
    .main_800EC2BC 0x800EC2BC : AT(0x000EC2BC) { build/asm/data/main_800EC2BC.bin.o(.data); }
    .main_800F0970 0x800F0970 : AT(0x000F0970) { build/asm/data/main_800F0970.bin.o(.data); }
    .main_800F109C 0x800F109C : AT(0x000F109C) { build/asm/data/main_800F109C.bin.o(.data); }
    .main_800F5CB0 0x800F5CB0 : AT(0x000F5CB0) { build/asm/data/main_800F5CB0.bin.o(.data); }
    .main_800F6A2C 0x800F6A2C : AT(0x000F6A2C) { FILL(0x00000000); build/asm/main_800F6A2C.s.o(.text); build/asm/main_800F6A2C.s.o(.rodata); build/asm/main_800F6A2C.s.o(.data); }
    .main_800F6A2C_bss (NOLOAD) : { build/asm/main_800F6A2C.s.o(.bss); }
    .main_800F7280 0x800F7280 : AT(0x000F7280) { build/asm/data/main_800F7280.bin.o(.data); }
    .main_800F7700 0x800F7700 : AT(0x000F7700) { FILL(0x00000000); build/asm/main_800F7700.s.o(.text); build/asm/main_800F7700.s.o(.rodata); build/asm/main_800F7700.s.o(.data); }
    .main_800F7700_bss (NOLOAD) : { build/asm/main_800F7700.s.o(.bss); }
    .main_800F7E60 0x800F7E60 : AT(0x000F7E60) { build/asm/data/main_800F7E60.bin.o(.data); }
    .main_800F8B2C 0x800F8B2C : AT(0x000F8B2C) { build/asm/data/main_800F8B2C.bin.o(.data); }
    .main_800F9528 0x800F9528 : AT(0x000F9528) { build/asm/data/main_800F9528.bin.o(.data); }
    .main_800F9638 0x800F9638 : AT(0x000F9638) { FILL(0x00000000); build/asm/main_800F9638.s.o(.text); build/asm/main_800F9638.s.o(.rodata); build/asm/main_800F9638.s.o(.data); }
    .main_800F9638_bss (NOLOAD) : { build/asm/main_800F9638.s.o(.bss); }
    .main_800F9F44 0x800F9F44 : AT(0x000F9F44) { FILL(0x00000000); build/asm/main_800F9F44.s.o(.text); build/asm/main_800F9F44.s.o(.rodata); build/asm/main_800F9F44.s.o(.data); }
    .main_800F9F44_bss (NOLOAD) : { build/asm/main_800F9F44.s.o(.bss); }
    .main_800FA230 0x800FA230 : AT(0x000FA230) { build/asm/data/main_800FA230.bin.o(.data); }
    .main_800FA678 0x800FA678 : AT(0x000FA678) { build/asm/data/main_800FA678.bin.o(.data); }
    .main_800FB5FC 0x800FB5FC : AT(0x000FB5FC) { FILL(0x00000000); build/asm/main_800FB5FC.s.o(.text); build/asm/main_800FB5FC.s.o(.rodata); build/asm/main_800FB5FC.s.o(.data); }
    .main_800FB5FC_bss (NOLOAD) : { build/asm/main_800FB5FC.s.o(.bss); }
    .main_800FB62C 0x800FB62C : AT(0x000FB62C) { build/asm/data/main_800FB62C.bin.o(.data); }
    .main_800FBD08 0x800FBD08 : AT(0x000FBD08) { FILL(0x00000000); build/asm/main_800FBD08.s.o(.text); build/asm/main_800FBD08.s.o(.rodata); build/asm/main_800FBD08.s.o(.data); }
    .main_800FBD08_bss (NOLOAD) : { build/asm/main_800FBD08.s.o(.bss); }
    .main_800FC640 0x800FC640 : AT(0x000FC640) { build/asm/data/main_800FC640.bin.o(.data); }
    .main_800FC8F0 0x800FC8F0 : AT(0x000FC8F0) { FILL(0x00000000); build/asm/main_800FC8F0.s.o(.text); build/asm/main_800FC8F0.s.o(.rodata); build/asm/main_800FC8F0.s.o(.data); }
    .main_800FC8F0_bss (NOLOAD) : { build/asm/main_800FC8F0.s.o(.bss); }
    .main_800FCE5C 0x800FCE5C : AT(0x000FCE5C) { build/asm/data/main_800FCE5C.bin.o(.data); }
    .main_800FE7E4 0x800FE7E4 : AT(0x000FE7E4) { FILL(0x00000000); build/asm/main_800FE7E4.s.o(.text); build/asm/main_800FE7E4.s.o(.rodata); build/asm/main_800FE7E4.s.o(.data); }
    .main_800FE7E4_bss (NOLOAD) : { build/asm/main_800FE7E4.s.o(.bss); }
    .main_800FE7FC 0x800FE7FC : AT(0x000FE7FC) { build/asm/data/main_800FE7FC.bin.o(.data); }
    .main_80100C34 0x80100C34 : AT(0x00100C34) { FILL(0x00000000); build/asm/main_80100C34.s.o(.text); build/asm/main_80100C34.s.o(.rodata); build/asm/main_80100C34.s.o(.data); }
    .main_80100C34_bss (NOLOAD) : { build/asm/main_80100C34.s.o(.bss); }
    .assets 0x80401000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
