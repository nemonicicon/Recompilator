SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80010400 0x80010400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80010400.s.o(.text); build/asm/main_80010400.s.o(.rodata); build/asm/main_80010400.s.o(.data); }
    .main_80010400_bss (NOLOAD) : { build/asm/main_80010400.s.o(.bss); }
    .main_80011070 0x80011070 : AT(0x00001C70) { FILL(0x00000000); build/asm/main_80011070.s.o(.text); build/asm/main_80011070.s.o(.rodata); build/asm/main_80011070.s.o(.data); }
    .main_80011070_bss (NOLOAD) : { build/asm/main_80011070.s.o(.bss); }
    .main_80011530 0x80011530 : AT(0x00002130) { FILL(0x00000000); build/asm/main_80011530.s.o(.text); build/asm/main_80011530.s.o(.rodata); build/asm/main_80011530.s.o(.data); }
    .main_80011530_bss (NOLOAD) : { build/asm/main_80011530.s.o(.bss); }
    .main_80012B6C 0x80012B6C : AT(0x0000376C) { build/asm/data/main_80012B6C.bin.o(.data); }
    .main_80013980 0x80013980 : AT(0x00004580) { FILL(0x00000000); build/asm/main_80013980.s.o(.text); build/asm/main_80013980.s.o(.rodata); build/asm/main_80013980.s.o(.data); }
    .main_80013980_bss (NOLOAD) : { build/asm/main_80013980.s.o(.bss); }
    .main_80014054 0x80014054 : AT(0x00004C54) { FILL(0x00000000); build/asm/main_80014054.s.o(.text); build/asm/main_80014054.s.o(.rodata); build/asm/main_80014054.s.o(.data); }
    .main_80014054_bss (NOLOAD) : { build/asm/main_80014054.s.o(.bss); }
    .main_80018378 0x80018378 : AT(0x00008F78) { FILL(0x00000000); build/asm/main_80018378.s.o(.text); build/asm/main_80018378.s.o(.rodata); build/asm/main_80018378.s.o(.data); }
    .main_80018378_bss (NOLOAD) : { build/asm/main_80018378.s.o(.bss); }
    .main_80019964 0x80019964 : AT(0x0000A564) { FILL(0x00000000); build/asm/main_80019964.s.o(.text); build/asm/main_80019964.s.o(.rodata); build/asm/main_80019964.s.o(.data); }
    .main_80019964_bss (NOLOAD) : { build/asm/main_80019964.s.o(.bss); }
    .main_80019D30 0x80019D30 : AT(0x0000A930) { FILL(0x00000000); build/asm/main_80019D30.s.o(.text); build/asm/main_80019D30.s.o(.rodata); build/asm/main_80019D30.s.o(.data); }
    .main_80019D30_bss (NOLOAD) : { build/asm/main_80019D30.s.o(.bss); }
    .main_8001BE00 0x8001BE00 : AT(0x0000CA00) { FILL(0x00000000); build/asm/main_8001BE00.s.o(.text); build/asm/main_8001BE00.s.o(.rodata); build/asm/main_8001BE00.s.o(.data); }
    .main_8001BE00_bss (NOLOAD) : { build/asm/main_8001BE00.s.o(.bss); }
    .main_8001C3D0 0x8001C3D0 : AT(0x0000CFD0) { FILL(0x00000000); build/asm/main_8001C3D0.s.o(.text); build/asm/main_8001C3D0.s.o(.rodata); build/asm/main_8001C3D0.s.o(.data); }
    .main_8001C3D0_bss (NOLOAD) : { build/asm/main_8001C3D0.s.o(.bss); }
    .main_8001C850 0x8001C850 : AT(0x0000D450) { FILL(0x00000000); build/asm/main_8001C850.s.o(.text); build/asm/main_8001C850.s.o(.rodata); build/asm/main_8001C850.s.o(.data); }
    .main_8001C850_bss (NOLOAD) : { build/asm/main_8001C850.s.o(.bss); }
    .main_80022810 0x80022810 : AT(0x00013410) { FILL(0x00000000); build/asm/main_80022810.s.o(.text); build/asm/main_80022810.s.o(.rodata); build/asm/main_80022810.s.o(.data); }
    .main_80022810_bss (NOLOAD) : { build/asm/main_80022810.s.o(.bss); }
    .main_80022CE0 0x80022CE0 : AT(0x000138E0) { FILL(0x00000000); build/asm/main_80022CE0.s.o(.text); build/asm/main_80022CE0.s.o(.rodata); build/asm/main_80022CE0.s.o(.data); }
    .main_80022CE0_bss (NOLOAD) : { build/asm/main_80022CE0.s.o(.bss); }
    .main_80023760 0x80023760 : AT(0x00014360) { FILL(0x00000000); build/asm/main_80023760.s.o(.text); build/asm/main_80023760.s.o(.rodata); build/asm/main_80023760.s.o(.data); }
    .main_80023760_bss (NOLOAD) : { build/asm/main_80023760.s.o(.bss); }
    .main_800240B4 0x800240B4 : AT(0x00014CB4) { FILL(0x00000000); build/asm/main_800240B4.s.o(.text); build/asm/main_800240B4.s.o(.rodata); build/asm/main_800240B4.s.o(.data); }
    .main_800240B4_bss (NOLOAD) : { build/asm/main_800240B4.s.o(.bss); }
    .main_80024410 0x80024410 : AT(0x00015010) { FILL(0x00000000); build/asm/main_80024410.s.o(.text); build/asm/main_80024410.s.o(.rodata); build/asm/main_80024410.s.o(.data); }
    .main_80024410_bss (NOLOAD) : { build/asm/main_80024410.s.o(.bss); }
    .main_8002461C 0x8002461C : AT(0x0001521C) { FILL(0x00000000); build/asm/main_8002461C.s.o(.text); build/asm/main_8002461C.s.o(.rodata); build/asm/main_8002461C.s.o(.data); }
    .main_8002461C_bss (NOLOAD) : { build/asm/main_8002461C.s.o(.bss); }
    .main_80027810 0x80027810 : AT(0x00018410) { FILL(0x00000000); build/asm/main_80027810.s.o(.text); build/asm/main_80027810.s.o(.rodata); build/asm/main_80027810.s.o(.data); }
    .main_80027810_bss (NOLOAD) : { build/asm/main_80027810.s.o(.bss); }
    .main_80028080 0x80028080 : AT(0x00018C80) { FILL(0x00000000); build/asm/main_80028080.s.o(.text); build/asm/main_80028080.s.o(.rodata); build/asm/main_80028080.s.o(.data); }
    .main_80028080_bss (NOLOAD) : { build/asm/main_80028080.s.o(.bss); }
    .main_80028DB4 0x80028DB4 : AT(0x000199B4) { FILL(0x00000000); build/asm/main_80028DB4.s.o(.text); build/asm/main_80028DB4.s.o(.rodata); build/asm/main_80028DB4.s.o(.data); }
    .main_80028DB4_bss (NOLOAD) : { build/asm/main_80028DB4.s.o(.bss); }
    .main_8002AAA0 0x8002AAA0 : AT(0x0001B6A0) { FILL(0x00000000); build/asm/main_8002AAA0.s.o(.text); build/asm/main_8002AAA0.s.o(.rodata); build/asm/main_8002AAA0.s.o(.data); }
    .main_8002AAA0_bss (NOLOAD) : { build/asm/main_8002AAA0.s.o(.bss); }
    .main_8002F198 0x8002F198 : AT(0x0001FD98) { build/asm/data/main_8002F198.bin.o(.data); }
    .main_8002F6A8 0x8002F6A8 : AT(0x000202A8) { FILL(0x00000000); build/asm/main_8002F6A8.s.o(.text); build/asm/main_8002F6A8.s.o(.rodata); build/asm/main_8002F6A8.s.o(.data); }
    .main_8002F6A8_bss (NOLOAD) : { build/asm/main_8002F6A8.s.o(.bss); }
    .main_8002F930 0x8002F930 : AT(0x00020530) { FILL(0x00000000); build/asm/main_8002F930.s.o(.text); build/asm/main_8002F930.s.o(.rodata); build/asm/main_8002F930.s.o(.data); }
    .main_8002F930_bss (NOLOAD) : { build/asm/main_8002F930.s.o(.bss); }
    .main_8002FBB8 0x8002FBB8 : AT(0x000207B8) { FILL(0x00000000); build/asm/main_8002FBB8.s.o(.text); build/asm/main_8002FBB8.s.o(.rodata); build/asm/main_8002FBB8.s.o(.data); }
    .main_8002FBB8_bss (NOLOAD) : { build/asm/main_8002FBB8.s.o(.bss); }
    .main_8002FE40 0x8002FE40 : AT(0x00020A40) { FILL(0x00000000); build/asm/main_8002FE40.s.o(.text); build/asm/main_8002FE40.s.o(.rodata); build/asm/main_8002FE40.s.o(.data); }
    .main_8002FE40_bss (NOLOAD) : { build/asm/main_8002FE40.s.o(.bss); }
    .main_80040408 0x80040408 : AT(0x00031008) { FILL(0x00000000); build/asm/main_80040408.s.o(.text); build/asm/main_80040408.s.o(.rodata); build/asm/main_80040408.s.o(.data); }
    .main_80040408_bss (NOLOAD) : { build/asm/main_80040408.s.o(.bss); }
    .main_80046BF8 0x80046BF8 : AT(0x000377F8) { FILL(0x00000000); build/asm/main_80046BF8.s.o(.text); build/asm/main_80046BF8.s.o(.rodata); build/asm/main_80046BF8.s.o(.data); }
    .main_80046BF8_bss (NOLOAD) : { build/asm/main_80046BF8.s.o(.bss); }
    .main_8004C5D0 0x8004C5D0 : AT(0x0003D1D0) { FILL(0x00000000); build/asm/main_8004C5D0.s.o(.text); build/asm/main_8004C5D0.s.o(.rodata); build/asm/main_8004C5D0.s.o(.data); }
    .main_8004C5D0_bss (NOLOAD) : { build/asm/main_8004C5D0.s.o(.bss); }
    .main_800A0AE4 0x800A0AE4 : AT(0x000916E4) { FILL(0x00000000); build/asm/main_800A0AE4.s.o(.text); build/asm/main_800A0AE4.s.o(.rodata); build/asm/main_800A0AE4.s.o(.data); }
    .main_800A0AE4_bss (NOLOAD) : { build/asm/main_800A0AE4.s.o(.bss); }
    .main_800B6EFC 0x800B6EFC : AT(0x000A7AFC) { build/asm/data/main_800B6EFC.bin.o(.data); }
    .main_800B8014 0x800B8014 : AT(0x000A8C14) { FILL(0x00000000); build/asm/main_800B8014.s.o(.text); build/asm/main_800B8014.s.o(.rodata); build/asm/main_800B8014.s.o(.data); }
    .main_800B8014_bss (NOLOAD) : { build/asm/main_800B8014.s.o(.bss); }
    .main_800B8250 0x800B8250 : AT(0x000A8E50) { build/asm/data/main_800B8250.bin.o(.data); }
    .main_800B8A70 0x800B8A70 : AT(0x000A9670) { FILL(0x00000000); build/asm/main_800B8A70.s.o(.text); build/asm/main_800B8A70.s.o(.rodata); build/asm/main_800B8A70.s.o(.data); }
    .main_800B8A70_bss (NOLOAD) : { build/asm/main_800B8A70.s.o(.bss); }
    .main_800B8E04 0x800B8E04 : AT(0x000A9A04) { build/asm/data/main_800B8E04.bin.o(.data); }
    .main_800B8E88 0x800B8E88 : AT(0x000A9A88) { FILL(0x00000000); build/asm/main_800B8E88.s.o(.text); build/asm/main_800B8E88.s.o(.rodata); build/asm/main_800B8E88.s.o(.data); }
    .main_800B8E88_bss (NOLOAD) : { build/asm/main_800B8E88.s.o(.bss); }
    .main_800B8F40 0x800B8F40 : AT(0x000A9B40) { build/asm/data/main_800B8F40.bin.o(.data); }
    .main_800B9330 0x800B9330 : AT(0x000A9F30) { FILL(0x00000000); build/asm/main_800B9330.s.o(.text); build/asm/main_800B9330.s.o(.rodata); build/asm/main_800B9330.s.o(.data); }
    .main_800B9330_bss (NOLOAD) : { build/asm/main_800B9330.s.o(.bss); }
    .main_800B95D4 0x800B95D4 : AT(0x000AA1D4) { build/asm/data/main_800B95D4.bin.o(.data); }
    .main_800B9748 0x800B9748 : AT(0x000AA348) { FILL(0x00000000); build/asm/main_800B9748.s.o(.text); build/asm/main_800B9748.s.o(.rodata); build/asm/main_800B9748.s.o(.data); }
    .main_800B9748_bss (NOLOAD) : { build/asm/main_800B9748.s.o(.bss); }
    .main_800BA224 0x800BA224 : AT(0x000AAE24) { build/asm/data/main_800BA224.bin.o(.data); }
    .main_800BA334 0x800BA334 : AT(0x000AAF34) { FILL(0x00000000); build/asm/main_800BA334.s.o(.text); build/asm/main_800BA334.s.o(.rodata); build/asm/main_800BA334.s.o(.data); }
    .main_800BA334_bss (NOLOAD) : { build/asm/main_800BA334.s.o(.bss); }
    .main_800C2C7C 0x800C2C7C : AT(0x000B387C) { build/asm/data/main_800C2C7C.bin.o(.data); }
    .main_800C3110 0x800C3110 : AT(0x000B3D10) { FILL(0x00000000); build/asm/main_800C3110.s.o(.text); build/asm/main_800C3110.s.o(.rodata); build/asm/main_800C3110.s.o(.data); }
    .main_800C3110_bss (NOLOAD) : { build/asm/main_800C3110.s.o(.bss); }
    .main_800D7FDC 0x800D7FDC : AT(0x000C8BDC) { FILL(0x00000000); build/asm/main_800D7FDC.s.o(.text); build/asm/main_800D7FDC.s.o(.rodata); build/asm/main_800D7FDC.s.o(.data); }
    .main_800D7FDC_bss (NOLOAD) : { build/asm/main_800D7FDC.s.o(.bss); }
    .main_800E5884 0x800E5884 : AT(0x000D6484) { build/asm/data/main_800E5884.bin.o(.data); }
    .main_800E5ED4 0x800E5ED4 : AT(0x000D6AD4) { FILL(0x00000000); build/asm/main_800E5ED4.s.o(.text); build/asm/main_800E5ED4.s.o(.rodata); build/asm/main_800E5ED4.s.o(.data); }
    .main_800E5ED4_bss (NOLOAD) : { build/asm/main_800E5ED4.s.o(.bss); }
    .main_800E604C 0x800E604C : AT(0x000D6C4C) { build/asm/data/main_800E604C.bin.o(.data); }
    .main_800E83D0 0x800E83D0 : AT(0x000D8FD0) { FILL(0x00000000); build/asm/main_800E83D0.s.o(.text); build/asm/main_800E83D0.s.o(.rodata); build/asm/main_800E83D0.s.o(.data); }
    .main_800E83D0_bss (NOLOAD) : { build/asm/main_800E83D0.s.o(.bss); }
    .assets 0x80410400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
