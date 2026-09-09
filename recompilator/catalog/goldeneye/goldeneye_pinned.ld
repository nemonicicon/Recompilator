SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004BC 0x800004BC : AT(0x000010BC) { FILL(0x00000000); build/asm/main_800004BC.s.o(.text); build/asm/main_800004BC.s.o(.rodata); build/asm/main_800004BC.s.o(.data); }
    .main_800004BC_bss (NOLOAD) : { build/asm/main_800004BC.s.o(.bss); }
    .main_80002CD8 0x80002CD8 : AT(0x000038D8) { build/asm/data/main_80002CD8.bin.o(.data); }
    .main_80003040 0x80003040 : AT(0x00003C40) { FILL(0x00000000); build/asm/main_80003040.s.o(.text); build/asm/main_80003040.s.o(.rodata); build/asm/main_80003040.s.o(.data); }
    .main_80003040_bss (NOLOAD) : { build/asm/main_80003040.s.o(.bss); }
    .main_80003124 0x80003124 : AT(0x00003D24) { build/asm/data/main_80003124.bin.o(.data); }
    .main_80003190 0x80003190 : AT(0x00003D90) { FILL(0x00000000); build/asm/main_80003190.s.o(.text); build/asm/main_80003190.s.o(.rodata); build/asm/main_80003190.s.o(.data); }
    .main_80003190_bss (NOLOAD) : { build/asm/main_80003190.s.o(.bss); }
    .main_80003C58 0x80003C58 : AT(0x00004858) { build/asm/data/main_80003C58.bin.o(.data); }
    .main_80003EF8 0x80003EF8 : AT(0x00004AF8) { FILL(0x00000000); build/asm/main_80003EF8.s.o(.text); build/asm/main_80003EF8.s.o(.rodata); build/asm/main_80003EF8.s.o(.data); }
    .main_80003EF8_bss (NOLOAD) : { build/asm/main_80003EF8.s.o(.bss); }
    .main_80003F64 0x80003F64 : AT(0x00004B64) { build/asm/data/main_80003F64.bin.o(.data); }
    .main_80004384 0x80004384 : AT(0x00004F84) { FILL(0x00000000); build/asm/main_80004384.s.o(.text); build/asm/main_80004384.s.o(.rodata); build/asm/main_80004384.s.o(.data); }
    .main_80004384_bss (NOLOAD) : { build/asm/main_80004384.s.o(.bss); }
    .main_8000443C 0x8000443C : AT(0x0000503C) { build/asm/data/main_8000443C.bin.o(.data); }
    .main_8000449C 0x8000449C : AT(0x0000509C) { FILL(0x00000000); build/asm/main_8000449C.s.o(.text); build/asm/main_8000449C.s.o(.rodata); build/asm/main_8000449C.s.o(.data); }
    .main_8000449C_bss (NOLOAD) : { build/asm/main_8000449C.s.o(.bss); }
    .main_800044BC 0x800044BC : AT(0x000050BC) { build/asm/data/main_800044BC.bin.o(.data); }
    .main_80004514 0x80004514 : AT(0x00005114) { FILL(0x00000000); build/asm/main_80004514.s.o(.text); build/asm/main_80004514.s.o(.rodata); build/asm/main_80004514.s.o(.data); }
    .main_80004514_bss (NOLOAD) : { build/asm/main_80004514.s.o(.bss); }
    .main_80004544 0x80004544 : AT(0x00005144) { build/asm/data/main_80004544.bin.o(.data); }
    .main_800046AC 0x800046AC : AT(0x000052AC) { FILL(0x00000000); build/asm/main_800046AC.s.o(.text); build/asm/main_800046AC.s.o(.rodata); build/asm/main_800046AC.s.o(.data); }
    .main_800046AC_bss (NOLOAD) : { build/asm/main_800046AC.s.o(.bss); }
    .main_800046D0 0x800046D0 : AT(0x000052D0) { build/asm/data/main_800046D0.bin.o(.data); }
    .main_80004D20 0x80004D20 : AT(0x00005920) { FILL(0x00000000); build/asm/main_80004D20.s.o(.text); build/asm/main_80004D20.s.o(.rodata); build/asm/main_80004D20.s.o(.data); }
    .main_80004D20_bss (NOLOAD) : { build/asm/main_80004D20.s.o(.bss); }
    .main_80005D30 0x80005D30 : AT(0x00006930) { build/asm/data/main_80005D30.bin.o(.data); }
    .main_80005FF4 0x80005FF4 : AT(0x00006BF4) { FILL(0x00000000); build/asm/main_80005FF4.s.o(.text); build/asm/main_80005FF4.s.o(.rodata); build/asm/main_80005FF4.s.o(.data); }
    .main_80005FF4_bss (NOLOAD) : { build/asm/main_80005FF4.s.o(.bss); }
    .main_8000601C 0x8000601C : AT(0x00006C1C) { build/asm/data/main_8000601C.bin.o(.data); }
    .main_80006930 0x80006930 : AT(0x00007530) { FILL(0x00000000); build/asm/main_80006930.s.o(.text); build/asm/main_80006930.s.o(.rodata); build/asm/main_80006930.s.o(.data); }
    .main_80006930_bss (NOLOAD) : { build/asm/main_80006930.s.o(.bss); }
    .main_80006968 0x80006968 : AT(0x00007568) { build/asm/data/main_80006968.bin.o(.data); }
    .main_800069C0 0x800069C0 : AT(0x000075C0) { FILL(0x00000000); build/asm/main_800069C0.s.o(.text); build/asm/main_800069C0.s.o(.rodata); build/asm/main_800069C0.s.o(.data); }
    .main_800069C0_bss (NOLOAD) : { build/asm/main_800069C0.s.o(.bss); }
    .main_80006E7C 0x80006E7C : AT(0x00007A7C) { build/asm/data/main_80006E7C.bin.o(.data); }
    .main_80006FD0 0x80006FD0 : AT(0x00007BD0) { FILL(0x00000000); build/asm/main_80006FD0.s.o(.text); build/asm/main_80006FD0.s.o(.rodata); build/asm/main_80006FD0.s.o(.data); }
    .main_80006FD0_bss (NOLOAD) : { build/asm/main_80006FD0.s.o(.bss); }
    .main_80007204 0x80007204 : AT(0x00007E04) { build/asm/data/main_80007204.bin.o(.data); }
    .main_80007358 0x80007358 : AT(0x00007F58) { FILL(0x00000000); build/asm/main_80007358.s.o(.text); build/asm/main_80007358.s.o(.rodata); build/asm/main_80007358.s.o(.data); }
    .main_80007358_bss (NOLOAD) : { build/asm/main_80007358.s.o(.bss); }
    .main_8000758C 0x8000758C : AT(0x0000818C) { build/asm/data/main_8000758C.bin.o(.data); }
    .main_800076E0 0x800076E0 : AT(0x000082E0) { FILL(0x00000000); build/asm/main_800076E0.s.o(.text); build/asm/main_800076E0.s.o(.rodata); build/asm/main_800076E0.s.o(.data); }
    .main_800076E0_bss (NOLOAD) : { build/asm/main_800076E0.s.o(.bss); }
    .main_8000B27C 0x8000B27C : AT(0x0000BE7C) { build/asm/data/main_8000B27C.bin.o(.data); }
    .main_8000B560 0x8000B560 : AT(0x0000C160) { FILL(0x00000000); build/asm/main_8000B560.s.o(.text); build/asm/main_8000B560.s.o(.rodata); build/asm/main_8000B560.s.o(.data); }
    .main_8000B560_bss (NOLOAD) : { build/asm/main_8000B560.s.o(.bss); }
    .main_8000D3D0 0x8000D3D0 : AT(0x0000DFD0) { FILL(0x00000000); build/asm/main_8000D3D0.s.o(.text); build/asm/main_8000D3D0.s.o(.rodata); build/asm/main_8000D3D0.s.o(.data); }
    .main_8000D3D0_bss (NOLOAD) : { build/asm/main_8000D3D0.s.o(.bss); }
    .main_8000D740 0x8000D740 : AT(0x0000E340) { FILL(0x00000000); build/asm/main_8000D740.s.o(.text); build/asm/main_8000D740.s.o(.rodata); build/asm/main_8000D740.s.o(.data); }
    .main_8000D740_bss (NOLOAD) : { build/asm/main_8000D740.s.o(.bss); }
    .main_8000D8F0 0x8000D8F0 : AT(0x0000E4F0) { FILL(0x00000000); build/asm/main_8000D8F0.s.o(.text); build/asm/main_8000D8F0.s.o(.rodata); build/asm/main_8000D8F0.s.o(.data); }
    .main_8000D8F0_bss (NOLOAD) : { build/asm/main_8000D8F0.s.o(.bss); }
    .main_8000E0D0 0x8000E0D0 : AT(0x0000ECD0) { FILL(0x00000000); build/asm/main_8000E0D0.s.o(.text); build/asm/main_8000E0D0.s.o(.rodata); build/asm/main_8000E0D0.s.o(.data); }
    .main_8000E0D0_bss (NOLOAD) : { build/asm/main_8000E0D0.s.o(.bss); }
    .main_8000E260 0x8000E260 : AT(0x0000EE60) { FILL(0x00000000); build/asm/main_8000E260.s.o(.text); build/asm/main_8000E260.s.o(.rodata); build/asm/main_8000E260.s.o(.data); }
    .main_8000E260_bss (NOLOAD) : { build/asm/main_8000E260.s.o(.bss); }
    .main_8000E3C0 0x8000E3C0 : AT(0x0000EFC0) { FILL(0x00000000); build/asm/main_8000E3C0.s.o(.text); build/asm/main_8000E3C0.s.o(.rodata); build/asm/main_8000E3C0.s.o(.data); }
    .main_8000E3C0_bss (NOLOAD) : { build/asm/main_8000E3C0.s.o(.bss); }
    .main_8000E4E0 0x8000E4E0 : AT(0x0000F0E0) { FILL(0x00000000); build/asm/main_8000E4E0.s.o(.text); build/asm/main_8000E4E0.s.o(.rodata); build/asm/main_8000E4E0.s.o(.data); }
    .main_8000E4E0_bss (NOLOAD) : { build/asm/main_8000E4E0.s.o(.bss); }
    .main_8000E79C 0x8000E79C : AT(0x0000F39C) { FILL(0x00000000); build/asm/main_8000E79C.s.o(.text); build/asm/main_8000E79C.s.o(.rodata); build/asm/main_8000E79C.s.o(.data); }
    .main_8000E79C_bss (NOLOAD) : { build/asm/main_8000E79C.s.o(.bss); }
    .main_8000EA90 0x8000EA90 : AT(0x0000F690) { FILL(0x00000000); build/asm/main_8000EA90.s.o(.text); build/asm/main_8000EA90.s.o(.rodata); build/asm/main_8000EA90.s.o(.data); }
    .main_8000EA90_bss (NOLOAD) : { build/asm/main_8000EA90.s.o(.bss); }
    .main_8000EFC8 0x8000EFC8 : AT(0x0000FBC8) { FILL(0x00000000); build/asm/main_8000EFC8.s.o(.text); build/asm/main_8000EFC8.s.o(.rodata); build/asm/main_8000EFC8.s.o(.data); }
    .main_8000EFC8_bss (NOLOAD) : { build/asm/main_8000EFC8.s.o(.bss); }
    .main_8000F7B0 0x8000F7B0 : AT(0x000103B0) { FILL(0x00000000); build/asm/main_8000F7B0.s.o(.text); build/asm/main_8000F7B0.s.o(.rodata); build/asm/main_8000F7B0.s.o(.data); }
    .main_8000F7B0_bss (NOLOAD) : { build/asm/main_8000F7B0.s.o(.bss); }
    .main_8000FC80 0x8000FC80 : AT(0x00010880) { build/asm/data/main_8000FC80.bin.o(.data); }
    .main_8000FEB0 0x8000FEB0 : AT(0x00010AB0) { FILL(0x00000000); build/asm/main_8000FEB0.s.o(.text); build/asm/main_8000FEB0.s.o(.rodata); build/asm/main_8000FEB0.s.o(.data); }
    .main_8000FEB0_bss (NOLOAD) : { build/asm/main_8000FEB0.s.o(.bss); }
    .main_80010D30 0x80010D30 : AT(0x00011930) { FILL(0x00000000); build/asm/main_80010D30.s.o(.text); build/asm/main_80010D30.s.o(.rodata); build/asm/main_80010D30.s.o(.data); }
    .main_80010D30_bss (NOLOAD) : { build/asm/main_80010D30.s.o(.bss); }
    .main_80013850 0x80013850 : AT(0x00014450) { FILL(0x00000000); build/asm/main_80013850.s.o(.text); build/asm/main_80013850.s.o(.rodata); build/asm/main_80013850.s.o(.data); }
    .main_80013850_bss (NOLOAD) : { build/asm/main_80013850.s.o(.bss); }
    .main_80014D70 0x80014D70 : AT(0x00015970) { FILL(0x00000000); build/asm/main_80014D70.s.o(.text); build/asm/main_80014D70.s.o(.rodata); build/asm/main_80014D70.s.o(.data); }
    .main_80014D70_bss (NOLOAD) : { build/asm/main_80014D70.s.o(.bss); }
    .main_80015C40 0x80015C40 : AT(0x00016840) { FILL(0x00000000); build/asm/main_80015C40.s.o(.text); build/asm/main_80015C40.s.o(.rodata); build/asm/main_80015C40.s.o(.data); }
    .main_80015C40_bss (NOLOAD) : { build/asm/main_80015C40.s.o(.bss); }
    .main_80016860 0x80016860 : AT(0x00017460) { build/asm/data/main_80016860.bin.o(.data); }
    .main_80016A70 0x80016A70 : AT(0x00017670) { FILL(0x00000000); build/asm/main_80016A70.s.o(.text); build/asm/main_80016A70.s.o(.rodata); build/asm/main_80016A70.s.o(.data); }
    .main_80016A70_bss (NOLOAD) : { build/asm/main_80016A70.s.o(.bss); }
    .main_80017720 0x80017720 : AT(0x00018320) { build/asm/data/main_80017720.bin.o(.data); }
    .main_800178B4 0x800178B4 : AT(0x000184B4) { FILL(0x00000000); build/asm/main_800178B4.s.o(.text); build/asm/main_800178B4.s.o(.rodata); build/asm/main_800178B4.s.o(.data); }
    .main_800178B4_bss (NOLOAD) : { build/asm/main_800178B4.s.o(.bss); }
    .main_80017B20 0x80017B20 : AT(0x00018720) { FILL(0x00000000); build/asm/main_80017B20.s.o(.text); build/asm/main_80017B20.s.o(.rodata); build/asm/main_80017B20.s.o(.data); }
    .main_80017B20_bss (NOLOAD) : { build/asm/main_80017B20.s.o(.bss); }
    .main_80018630 0x80018630 : AT(0x00019230) { FILL(0x00000000); build/asm/main_80018630.s.o(.text); build/asm/main_80018630.s.o(.rodata); build/asm/main_80018630.s.o(.data); }
    .main_80018630_bss (NOLOAD) : { build/asm/main_80018630.s.o(.bss); }
    .main_80018A50 0x80018A50 : AT(0x00019650) { FILL(0x00000000); build/asm/main_80018A50.s.o(.text); build/asm/main_80018A50.s.o(.rodata); build/asm/main_80018A50.s.o(.data); }
    .main_80018A50_bss (NOLOAD) : { build/asm/main_80018A50.s.o(.bss); }
    .main_80018F30 0x80018F30 : AT(0x00019B30) { FILL(0x00000000); build/asm/main_80018F30.s.o(.text); build/asm/main_80018F30.s.o(.rodata); build/asm/main_80018F30.s.o(.data); }
    .main_80018F30_bss (NOLOAD) : { build/asm/main_80018F30.s.o(.bss); }
    .main_8001B800 0x8001B800 : AT(0x0001C400) { FILL(0x00000000); build/asm/main_8001B800.s.o(.text); build/asm/main_8001B800.s.o(.rodata); build/asm/main_8001B800.s.o(.data); }
    .main_8001B800_bss (NOLOAD) : { build/asm/main_8001B800.s.o(.bss); }
    .main_8001BC60 0x8001BC60 : AT(0x0001C860) { FILL(0x00000000); build/asm/main_8001BC60.s.o(.text); build/asm/main_8001BC60.s.o(.rodata); build/asm/main_8001BC60.s.o(.data); }
    .main_8001BC60_bss (NOLOAD) : { build/asm/main_8001BC60.s.o(.bss); }
    .main_80025F68 0x80025F68 : AT(0x00026B68) { build/asm/data/main_80025F68.bin.o(.data); }
    .main_80027A2C 0x80027A2C : AT(0x0002862C) { build/asm/data/main_80027A2C.bin.o(.data); }
    .main_8002A208 0x8002A208 : AT(0x0002AE08) { build/asm/data/main_8002A208.bin.o(.data); }
    .main_8002D090 0x8002D090 : AT(0x0002DC90) { build/asm/data/main_8002D090.bin.o(.data); }
    .main_8002F648 0x8002F648 : AT(0x00030248) { build/asm/data/main_8002F648.bin.o(.data); }
    .main_8002FB6C 0x8002FB6C : AT(0x0003076C) { build/asm/data/main_8002FB6C.bin.o(.data); }
    .main_800306A8 0x800306A8 : AT(0x000312A8) { FILL(0x00000000); build/asm/main_800306A8.s.o(.text); build/asm/main_800306A8.s.o(.rodata); build/asm/main_800306A8.s.o(.data); }
    .main_800306A8_bss (NOLOAD) : { build/asm/main_800306A8.s.o(.bss); }
    .main_80032E50 0x80032E50 : AT(0x00033A50) { FILL(0x00000000); build/asm/main_80032E50.s.o(.text); build/asm/main_80032E50.s.o(.rodata); build/asm/main_80032E50.s.o(.data); }
    .main_80032E50_bss (NOLOAD) : { build/asm/main_80032E50.s.o(.bss); }
    .main_800391C0 0x800391C0 : AT(0x00039DC0) { build/asm/data/main_800391C0.bin.o(.data); }
    .main_8003B288 0x8003B288 : AT(0x0003BE88) { build/asm/data/main_8003B288.bin.o(.data); }
    .main_8003C458 0x8003C458 : AT(0x0003D058) { FILL(0x00000000); build/asm/main_8003C458.s.o(.text); build/asm/main_8003C458.s.o(.rodata); build/asm/main_8003C458.s.o(.data); }
    .main_8003C458_bss (NOLOAD) : { build/asm/main_8003C458.s.o(.bss); }
    .main_8003C9C4 0x8003C9C4 : AT(0x0003D5C4) { build/asm/data/main_8003C9C4.bin.o(.data); }
    .main_800417A4 0x800417A4 : AT(0x000423A4) { build/asm/data/main_800417A4.bin.o(.data); }
    .main_8004FC5C 0x8004FC5C : AT(0x0005085C) { build/asm/data/main_8004FC5C.bin.o(.data); }
    .main_800C3408 0x800C3408 : AT(0x000C4008) { build/asm/data/main_800C3408.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
