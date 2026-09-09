SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80300000 0x80300000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80300000.s.o(.text); build/asm/main_80300000.s.o(.rodata); build/asm/main_80300000.s.o(.data); }
    .main_80300000_bss (NOLOAD) : { build/asm/main_80300000.s.o(.bss); }
    .main_803001B8 0x803001B8 : AT(0x000011B8) { FILL(0x00000000); build/asm/main_803001B8.s.o(.text); build/asm/main_803001B8.s.o(.rodata); build/asm/main_803001B8.s.o(.data); }
    .main_803001B8_bss (NOLOAD) : { build/asm/main_803001B8.s.o(.bss); }
    .main_80300360 0x80300360 : AT(0x00001360) { FILL(0x00000000); build/asm/main_80300360.s.o(.text); build/asm/main_80300360.s.o(.rodata); build/asm/main_80300360.s.o(.data); }
    .main_80300360_bss (NOLOAD) : { build/asm/main_80300360.s.o(.bss); }
    .main_80300EEC 0x80300EEC : AT(0x00001EEC) { FILL(0x00000000); build/asm/main_80300EEC.s.o(.text); build/asm/main_80300EEC.s.o(.rodata); build/asm/main_80300EEC.s.o(.data); }
    .main_80300EEC_bss (NOLOAD) : { build/asm/main_80300EEC.s.o(.bss); }
    .main_80301790 0x80301790 : AT(0x00002790) { FILL(0x00000000); build/asm/main_80301790.s.o(.text); build/asm/main_80301790.s.o(.rodata); build/asm/main_80301790.s.o(.data); }
    .main_80301790_bss (NOLOAD) : { build/asm/main_80301790.s.o(.bss); }
    .main_80303FD4 0x80303FD4 : AT(0x00004FD4) { build/asm/data/main_80303FD4.bin.o(.data); }
    .main_80304014 0x80304014 : AT(0x00005014) { build/asm/data/main_80304014.bin.o(.data); }
    .main_803042D0 0x803042D0 : AT(0x000052D0) { build/asm/data/main_803042D0.bin.o(.data); }
    .main_80304D8C 0x80304D8C : AT(0x00005D8C) { FILL(0x00000000); build/asm/main_80304D8C.s.o(.text); build/asm/main_80304D8C.s.o(.rodata); build/asm/main_80304D8C.s.o(.data); }
    .main_80304D8C_bss (NOLOAD) : { build/asm/main_80304D8C.s.o(.bss); }
    .main_80304ED4 0x80304ED4 : AT(0x00005ED4) { build/asm/data/main_80304ED4.bin.o(.data); }
    .main_80304FCC 0x80304FCC : AT(0x00005FCC) { FILL(0x00000000); build/asm/main_80304FCC.s.o(.text); build/asm/main_80304FCC.s.o(.rodata); build/asm/main_80304FCC.s.o(.data); }
    .main_80304FCC_bss (NOLOAD) : { build/asm/main_80304FCC.s.o(.bss); }
    .main_8030501C 0x8030501C : AT(0x0000601C) { build/asm/data/main_8030501C.bin.o(.data); }
    .main_8030527C 0x8030527C : AT(0x0000627C) { FILL(0x00000000); build/asm/main_8030527C.s.o(.text); build/asm/main_8030527C.s.o(.rodata); build/asm/main_8030527C.s.o(.data); }
    .main_8030527C_bss (NOLOAD) : { build/asm/main_8030527C.s.o(.bss); }
    .main_8030570C 0x8030570C : AT(0x0000670C) { build/asm/data/main_8030570C.bin.o(.data); }
    .main_80305CE8 0x80305CE8 : AT(0x00006CE8) { FILL(0x00000000); build/asm/main_80305CE8.s.o(.text); build/asm/main_80305CE8.s.o(.rodata); build/asm/main_80305CE8.s.o(.data); }
    .main_80305CE8_bss (NOLOAD) : { build/asm/main_80305CE8.s.o(.bss); }
    .main_80305F30 0x80305F30 : AT(0x00006F30) { build/asm/data/main_80305F30.bin.o(.data); }
    .main_80306480 0x80306480 : AT(0x00007480) { FILL(0x00000000); build/asm/main_80306480.s.o(.text); build/asm/main_80306480.s.o(.rodata); build/asm/main_80306480.s.o(.data); }
    .main_80306480_bss (NOLOAD) : { build/asm/main_80306480.s.o(.bss); }
    .main_803065BC 0x803065BC : AT(0x000075BC) { FILL(0x00000000); build/asm/main_803065BC.s.o(.text); build/asm/main_803065BC.s.o(.rodata); build/asm/main_803065BC.s.o(.data); }
    .main_803065BC_bss (NOLOAD) : { build/asm/main_803065BC.s.o(.bss); }
    .main_80306730 0x80306730 : AT(0x00007730) { build/asm/data/main_80306730.bin.o(.data); }
    .main_80306EA8 0x80306EA8 : AT(0x00007EA8) { FILL(0x00000000); build/asm/main_80306EA8.s.o(.text); build/asm/main_80306EA8.s.o(.rodata); build/asm/main_80306EA8.s.o(.data); }
    .main_80306EA8_bss (NOLOAD) : { build/asm/main_80306EA8.s.o(.bss); }
    .main_8030A910 0x8030A910 : AT(0x0000B910) { build/asm/data/main_8030A910.bin.o(.data); }
    .main_80313278 0x80313278 : AT(0x00014278) { FILL(0x00000000); build/asm/main_80313278.s.o(.text); build/asm/main_80313278.s.o(.rodata); build/asm/main_80313278.s.o(.data); }
    .main_80313278_bss (NOLOAD) : { build/asm/main_80313278.s.o(.bss); }
    .main_8031331C 0x8031331C : AT(0x0001431C) { build/asm/data/main_8031331C.bin.o(.data); }
    .main_803233C8 0x803233C8 : AT(0x000243C8) { FILL(0x00000000); build/asm/main_803233C8.s.o(.text); build/asm/main_803233C8.s.o(.rodata); build/asm/main_803233C8.s.o(.data); }
    .main_803233C8_bss (NOLOAD) : { build/asm/main_803233C8.s.o(.bss); }
    .main_803233F4 0x803233F4 : AT(0x000243F4) { build/asm/data/main_803233F4.bin.o(.data); }
    .main_8032820C 0x8032820C : AT(0x0002920C) { FILL(0x00000000); build/asm/main_8032820C.s.o(.text); build/asm/main_8032820C.s.o(.rodata); build/asm/main_8032820C.s.o(.data); }
    .main_8032820C_bss (NOLOAD) : { build/asm/main_8032820C.s.o(.bss); }
    .main_803282A0 0x803282A0 : AT(0x000292A0) { build/asm/data/main_803282A0.bin.o(.data); }
    .main_8032DD0C 0x8032DD0C : AT(0x0002ED0C) { FILL(0x00000000); build/asm/main_8032DD0C.s.o(.text); build/asm/main_8032DD0C.s.o(.rodata); build/asm/main_8032DD0C.s.o(.data); }
    .main_8032DD0C_bss (NOLOAD) : { build/asm/main_8032DD0C.s.o(.bss); }
    .main_8032DD54 0x8032DD54 : AT(0x0002ED54) { build/asm/data/main_8032DD54.bin.o(.data); }
    .main_80342C34 0x80342C34 : AT(0x00043C34) { FILL(0x00000000); build/asm/main_80342C34.s.o(.text); build/asm/main_80342C34.s.o(.rodata); build/asm/main_80342C34.s.o(.data); }
    .main_80342C34_bss (NOLOAD) : { build/asm/main_80342C34.s.o(.bss); }
    .main_80342C50 0x80342C50 : AT(0x00043C50) { build/asm/data/main_80342C50.bin.o(.data); }
    .main_803487A0 0x803487A0 : AT(0x000497A0) { FILL(0x00000000); build/asm/main_803487A0.s.o(.text); build/asm/main_803487A0.s.o(.rodata); build/asm/main_803487A0.s.o(.data); }
    .main_803487A0_bss (NOLOAD) : { build/asm/main_803487A0.s.o(.bss); }
    .main_803487D8 0x803487D8 : AT(0x000497D8) { build/asm/data/main_803487D8.bin.o(.data); }
    .main_80354320 0x80354320 : AT(0x00055320) { FILL(0x00000000); build/asm/main_80354320.s.o(.text); build/asm/main_80354320.s.o(.rodata); build/asm/main_80354320.s.o(.data); }
    .main_80354320_bss (NOLOAD) : { build/asm/main_80354320.s.o(.bss); }
    .main_80354328 0x80354328 : AT(0x00055328) { build/asm/data/main_80354328.bin.o(.data); }
    .main_80372A8C 0x80372A8C : AT(0x00073A8C) { FILL(0x00000000); build/asm/main_80372A8C.s.o(.text); build/asm/main_80372A8C.s.o(.rodata); build/asm/main_80372A8C.s.o(.data); }
    .main_80372A8C_bss (NOLOAD) : { build/asm/main_80372A8C.s.o(.bss); }
    .main_80372A9C 0x80372A9C : AT(0x00073A9C) { build/asm/data/main_80372A9C.bin.o(.data); }
    .main_80374A70 0x80374A70 : AT(0x00075A70) { FILL(0x00000000); build/asm/main_80374A70.s.o(.text); build/asm/main_80374A70.s.o(.rodata); build/asm/main_80374A70.s.o(.data); }
    .main_80374A70_bss (NOLOAD) : { build/asm/main_80374A70.s.o(.bss); }
    .main_80374B3C 0x80374B3C : AT(0x00075B3C) { build/asm/data/main_80374B3C.bin.o(.data); }
    .main_80388248 0x80388248 : AT(0x00089248) { FILL(0x00000000); build/asm/main_80388248.s.o(.text); build/asm/main_80388248.s.o(.rodata); build/asm/main_80388248.s.o(.data); }
    .main_80388248_bss (NOLOAD) : { build/asm/main_80388248.s.o(.bss); }
    .main_8038825C 0x8038825C : AT(0x0008925C) { build/asm/data/main_8038825C.bin.o(.data); }
    .main_80389430 0x80389430 : AT(0x0008A430) { FILL(0x00000000); build/asm/main_80389430.s.o(.text); build/asm/main_80389430.s.o(.rodata); build/asm/main_80389430.s.o(.data); }
    .main_80389430_bss (NOLOAD) : { build/asm/main_80389430.s.o(.bss); }
    .main_80389450 0x80389450 : AT(0x0008A450) { build/asm/data/main_80389450.bin.o(.data); }
    .main_803E966C 0x803E966C : AT(0x000EA66C) { FILL(0x00000000); build/asm/main_803E966C.s.o(.text); build/asm/main_803E966C.s.o(.rodata); build/asm/main_803E966C.s.o(.data); }
    .main_803E966C_bss (NOLOAD) : { build/asm/main_803E966C.s.o(.bss); }
    .main_803E96EC 0x803E96EC : AT(0x000EA6EC) { build/asm/data/main_803E96EC.bin.o(.data); }
    .assets 0x80700000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
