SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000518 0x80000518 : AT(0x00001118) { FILL(0x00000000); build/asm/main_80000518.s.o(.text); build/asm/main_80000518.s.o(.rodata); build/asm/main_80000518.s.o(.data); }
    .main_80000518_bss (NOLOAD) : { build/asm/main_80000518.s.o(.bss); }
    .main_80001410 0x80001410 : AT(0x00002010) { FILL(0x00000000); build/asm/main_80001410.s.o(.text); build/asm/main_80001410.s.o(.rodata); build/asm/main_80001410.s.o(.data); }
    .main_80001410_bss (NOLOAD) : { build/asm/main_80001410.s.o(.bss); }
    .main_8000E6E4 0x8000E6E4 : AT(0x0000F2E4) { FILL(0x00000000); build/asm/main_8000E6E4.s.o(.text); build/asm/main_8000E6E4.s.o(.rodata); build/asm/main_8000E6E4.s.o(.data); }
    .main_8000E6E4_bss (NOLOAD) : { build/asm/main_8000E6E4.s.o(.bss); }
    .main_8000EAC0 0x8000EAC0 : AT(0x0000F6C0) { FILL(0x00000000); build/asm/main_8000EAC0.s.o(.text); build/asm/main_8000EAC0.s.o(.rodata); build/asm/main_8000EAC0.s.o(.data); }
    .main_8000EAC0_bss (NOLOAD) : { build/asm/main_8000EAC0.s.o(.bss); }
    .main_800173FC 0x800173FC : AT(0x00017FFC) { build/asm/data/main_800173FC.bin.o(.data); }
    .main_8001A008 0x8001A008 : AT(0x0001AC08) { build/asm/data/main_8001A008.bin.o(.data); }
    .main_8001C9E8 0x8001C9E8 : AT(0x0001D5E8) { FILL(0x00000000); build/asm/main_8001C9E8.s.o(.text); build/asm/main_8001C9E8.s.o(.rodata); build/asm/main_8001C9E8.s.o(.data); }
    .main_8001C9E8_bss (NOLOAD) : { build/asm/main_8001C9E8.s.o(.bss); }
    .main_8001D408 0x8001D408 : AT(0x0001E008) { FILL(0x00000000); build/asm/main_8001D408.s.o(.text); build/asm/main_8001D408.s.o(.rodata); build/asm/main_8001D408.s.o(.data); }
    .main_8001D408_bss (NOLOAD) : { build/asm/main_8001D408.s.o(.bss); }
    .main_8002446C 0x8002446C : AT(0x0002506C) { FILL(0x00000000); build/asm/main_8002446C.s.o(.text); build/asm/main_8002446C.s.o(.rodata); build/asm/main_8002446C.s.o(.data); }
    .main_8002446C_bss (NOLOAD) : { build/asm/main_8002446C.s.o(.bss); }
    .main_8004510C 0x8004510C : AT(0x00045D0C) { build/asm/data/main_8004510C.bin.o(.data); }
    .main_80053710 0x80053710 : AT(0x00054310) { FILL(0x00000000); build/asm/main_80053710.s.o(.text); build/asm/main_80053710.s.o(.rodata); build/asm/main_80053710.s.o(.data); }
    .main_80053710_bss (NOLOAD) : { build/asm/main_80053710.s.o(.bss); }
    .main_800569BC 0x800569BC : AT(0x000575BC) { build/asm/data/main_800569BC.bin.o(.data); }
    .main_80056A10 0x80056A10 : AT(0x00057610) { FILL(0x00000000); build/asm/main_80056A10.s.o(.text); build/asm/main_80056A10.s.o(.rodata); build/asm/main_80056A10.s.o(.data); }
    .main_80056A10_bss (NOLOAD) : { build/asm/main_80056A10.s.o(.bss); }
    .main_8005D1C8 0x8005D1C8 : AT(0x0005DDC8) { build/asm/data/main_8005D1C8.bin.o(.data); }
    .main_8005DC54 0x8005DC54 : AT(0x0005E854) { FILL(0x00000000); build/asm/main_8005DC54.s.o(.text); build/asm/main_8005DC54.s.o(.rodata); build/asm/main_8005DC54.s.o(.data); }
    .main_8005DC54_bss (NOLOAD) : { build/asm/main_8005DC54.s.o(.bss); }
    .main_8006E2F4 0x8006E2F4 : AT(0x0006EEF4) { FILL(0x00000000); build/asm/main_8006E2F4.s.o(.text); build/asm/main_8006E2F4.s.o(.rodata); build/asm/main_8006E2F4.s.o(.data); }
    .main_8006E2F4_bss (NOLOAD) : { build/asm/main_8006E2F4.s.o(.bss); }
    .main_8007AE1C 0x8007AE1C : AT(0x0007BA1C) { build/asm/data/main_8007AE1C.bin.o(.data); }
    .main_8007C614 0x8007C614 : AT(0x0007D214) { FILL(0x00000000); build/asm/main_8007C614.s.o(.text); build/asm/main_8007C614.s.o(.rodata); build/asm/main_8007C614.s.o(.data); }
    .main_8007C614_bss (NOLOAD) : { build/asm/main_8007C614.s.o(.bss); }
    .main_80088ABC 0x80088ABC : AT(0x000896BC) { build/asm/data/main_80088ABC.bin.o(.data); }
    .main_8008A8F0 0x8008A8F0 : AT(0x0008B4F0) { FILL(0x00000000); build/asm/main_8008A8F0.s.o(.text); build/asm/main_8008A8F0.s.o(.rodata); build/asm/main_8008A8F0.s.o(.data); }
    .main_8008A8F0_bss (NOLOAD) : { build/asm/main_8008A8F0.s.o(.bss); }
    .main_8008AAE4 0x8008AAE4 : AT(0x0008B6E4) { build/asm/data/main_8008AAE4.bin.o(.data); }
    .main_8008B40C 0x8008B40C : AT(0x0008C00C) { FILL(0x00000000); build/asm/main_8008B40C.s.o(.text); build/asm/main_8008B40C.s.o(.rodata); build/asm/main_8008B40C.s.o(.data); }
    .main_8008B40C_bss (NOLOAD) : { build/asm/main_8008B40C.s.o(.bss); }
    .main_8008B99C 0x8008B99C : AT(0x0008C59C) { build/asm/data/main_8008B99C.bin.o(.data); }
    .main_8008BD6C 0x8008BD6C : AT(0x0008C96C) { FILL(0x00000000); build/asm/main_8008BD6C.s.o(.text); build/asm/main_8008BD6C.s.o(.rodata); build/asm/main_8008BD6C.s.o(.data); }
    .main_8008BD6C_bss (NOLOAD) : { build/asm/main_8008BD6C.s.o(.bss); }
    .main_8008C76C 0x8008C76C : AT(0x0008D36C) { build/asm/data/main_8008C76C.bin.o(.data); }
    .main_8008CA20 0x8008CA20 : AT(0x0008D620) { FILL(0x00000000); build/asm/main_8008CA20.s.o(.text); build/asm/main_8008CA20.s.o(.rodata); build/asm/main_8008CA20.s.o(.data); }
    .main_8008CA20_bss (NOLOAD) : { build/asm/main_8008CA20.s.o(.bss); }
    .main_8008CB90 0x8008CB90 : AT(0x0008D790) { build/asm/data/main_8008CB90.bin.o(.data); }
    .main_8008CBA0 0x8008CBA0 : AT(0x0008D7A0) { FILL(0x00000000); build/asm/main_8008CBA0.s.o(.text); build/asm/main_8008CBA0.s.o(.rodata); build/asm/main_8008CBA0.s.o(.data); }
    .main_8008CBA0_bss (NOLOAD) : { build/asm/main_8008CBA0.s.o(.bss); }
    .main_8008D160 0x8008D160 : AT(0x0008DD60) { build/asm/data/main_8008D160.bin.o(.data); }
    .main_8008D180 0x8008D180 : AT(0x0008DD80) { FILL(0x00000000); build/asm/main_8008D180.s.o(.text); build/asm/main_8008D180.s.o(.rodata); build/asm/main_8008D180.s.o(.data); }
    .main_8008D180_bss (NOLOAD) : { build/asm/main_8008D180.s.o(.bss); }
    .main_8008D374 0x8008D374 : AT(0x0008DF74) { build/asm/data/main_8008D374.bin.o(.data); }
    .main_8008D658 0x8008D658 : AT(0x0008E258) { FILL(0x00000000); build/asm/main_8008D658.s.o(.text); build/asm/main_8008D658.s.o(.rodata); build/asm/main_8008D658.s.o(.data); }
    .main_8008D658_bss (NOLOAD) : { build/asm/main_8008D658.s.o(.bss); }
    .main_8009AF14 0x8009AF14 : AT(0x0009BB14) { build/asm/data/main_8009AF14.bin.o(.data); }
    .main_8009B1A4 0x8009B1A4 : AT(0x0009BDA4) { FILL(0x00000000); build/asm/main_8009B1A4.s.o(.text); build/asm/main_8009B1A4.s.o(.rodata); build/asm/main_8009B1A4.s.o(.data); }
    .main_8009B1A4_bss (NOLOAD) : { build/asm/main_8009B1A4.s.o(.bss); }
    .main_8009F098 0x8009F098 : AT(0x0009FC98) { build/asm/data/main_8009F098.bin.o(.data); }
    .main_8009F3A8 0x8009F3A8 : AT(0x0009FFA8) { FILL(0x00000000); build/asm/main_8009F3A8.s.o(.text); build/asm/main_8009F3A8.s.o(.rodata); build/asm/main_8009F3A8.s.o(.data); }
    .main_8009F3A8_bss (NOLOAD) : { build/asm/main_8009F3A8.s.o(.bss); }
    .main_8009F3B4 0x8009F3B4 : AT(0x0009FFB4) { build/asm/data/main_8009F3B4.bin.o(.data); }
    .main_8009F958 0x8009F958 : AT(0x000A0558) { FILL(0x00000000); build/asm/main_8009F958.s.o(.text); build/asm/main_8009F958.s.o(.rodata); build/asm/main_8009F958.s.o(.data); }
    .main_8009F958_bss (NOLOAD) : { build/asm/main_8009F958.s.o(.bss); }
    .main_800A12F8 0x800A12F8 : AT(0x000A1EF8) { build/asm/data/main_800A12F8.bin.o(.data); }
    .main_800A1310 0x800A1310 : AT(0x000A1F10) { FILL(0x00000000); build/asm/main_800A1310.s.o(.text); build/asm/main_800A1310.s.o(.rodata); build/asm/main_800A1310.s.o(.data); }
    .main_800A1310_bss (NOLOAD) : { build/asm/main_800A1310.s.o(.bss); }
    .main_800A18CC 0x800A18CC : AT(0x000A24CC) { build/asm/data/main_800A18CC.bin.o(.data); }
    .main_800A20B8 0x800A20B8 : AT(0x000A2CB8) { FILL(0x00000000); build/asm/main_800A20B8.s.o(.text); build/asm/main_800A20B8.s.o(.rodata); build/asm/main_800A20B8.s.o(.data); }
    .main_800A20B8_bss (NOLOAD) : { build/asm/main_800A20B8.s.o(.bss); }
    .main_800A2188 0x800A2188 : AT(0x000A2D88) { build/asm/data/main_800A2188.bin.o(.data); }
    .main_800A2EB4 0x800A2EB4 : AT(0x000A3AB4) { FILL(0x00000000); build/asm/main_800A2EB4.s.o(.text); build/asm/main_800A2EB4.s.o(.rodata); build/asm/main_800A2EB4.s.o(.data); }
    .main_800A2EB4_bss (NOLOAD) : { build/asm/main_800A2EB4.s.o(.bss); }
    .main_800A2F54 0x800A2F54 : AT(0x000A3B54) { build/asm/data/main_800A2F54.bin.o(.data); }
    .main_800A33CC 0x800A33CC : AT(0x000A3FCC) { FILL(0x00000000); build/asm/main_800A33CC.s.o(.text); build/asm/main_800A33CC.s.o(.rodata); build/asm/main_800A33CC.s.o(.data); }
    .main_800A33CC_bss (NOLOAD) : { build/asm/main_800A33CC.s.o(.bss); }
    .main_800A3570 0x800A3570 : AT(0x000A4170) { build/asm/data/main_800A3570.bin.o(.data); }
    .main_800A37C4 0x800A37C4 : AT(0x000A43C4) { FILL(0x00000000); build/asm/main_800A37C4.s.o(.text); build/asm/main_800A37C4.s.o(.rodata); build/asm/main_800A37C4.s.o(.data); }
    .main_800A37C4_bss (NOLOAD) : { build/asm/main_800A37C4.s.o(.bss); }
    .main_800A3A30 0x800A3A30 : AT(0x000A4630) { build/asm/data/main_800A3A30.bin.o(.data); }
    .main_800A3E18 0x800A3E18 : AT(0x000A4A18) { FILL(0x00000000); build/asm/main_800A3E18.s.o(.text); build/asm/main_800A3E18.s.o(.rodata); build/asm/main_800A3E18.s.o(.data); }
    .main_800A3E18_bss (NOLOAD) : { build/asm/main_800A3E18.s.o(.bss); }
    .main_800A3E20 0x800A3E20 : AT(0x000A4A20) { build/asm/data/main_800A3E20.bin.o(.data); }
    .main_800A4D7C 0x800A4D7C : AT(0x000A597C) { FILL(0x00000000); build/asm/main_800A4D7C.s.o(.text); build/asm/main_800A4D7C.s.o(.rodata); build/asm/main_800A4D7C.s.o(.data); }
    .main_800A4D7C_bss (NOLOAD) : { build/asm/main_800A4D7C.s.o(.bss); }
    .main_800A5060 0x800A5060 : AT(0x000A5C60) { build/asm/data/main_800A5060.bin.o(.data); }
    .main_800A51EC 0x800A51EC : AT(0x000A5DEC) { FILL(0x00000000); build/asm/main_800A51EC.s.o(.text); build/asm/main_800A51EC.s.o(.rodata); build/asm/main_800A51EC.s.o(.data); }
    .main_800A51EC_bss (NOLOAD) : { build/asm/main_800A51EC.s.o(.bss); }
    .main_800A6BE4 0x800A6BE4 : AT(0x000A77E4) { build/asm/data/main_800A6BE4.bin.o(.data); }
    .main_800A6E98 0x800A6E98 : AT(0x000A7A98) { FILL(0x00000000); build/asm/main_800A6E98.s.o(.text); build/asm/main_800A6E98.s.o(.rodata); build/asm/main_800A6E98.s.o(.data); }
    .main_800A6E98_bss (NOLOAD) : { build/asm/main_800A6E98.s.o(.bss); }
    .main_800A75F0 0x800A75F0 : AT(0x000A81F0) { build/asm/data/main_800A75F0.bin.o(.data); }
    .main_800A7ED8 0x800A7ED8 : AT(0x000A8AD8) { FILL(0x00000000); build/asm/main_800A7ED8.s.o(.text); build/asm/main_800A7ED8.s.o(.rodata); build/asm/main_800A7ED8.s.o(.data); }
    .main_800A7ED8_bss (NOLOAD) : { build/asm/main_800A7ED8.s.o(.bss); }
    .main_800AA7FC 0x800AA7FC : AT(0x000AB3FC) { build/asm/data/main_800AA7FC.bin.o(.data); }
    .main_800AAC90 0x800AAC90 : AT(0x000AB890) { FILL(0x00000000); build/asm/main_800AAC90.s.o(.text); build/asm/main_800AAC90.s.o(.rodata); build/asm/main_800AAC90.s.o(.data); }
    .main_800AAC90_bss (NOLOAD) : { build/asm/main_800AAC90.s.o(.bss); }
    .main_800AB610 0x800AB610 : AT(0x000AC210) { build/asm/data/main_800AB610.bin.o(.data); }
    .main_800ABBC0 0x800ABBC0 : AT(0x000AC7C0) { FILL(0x00000000); build/asm/main_800ABBC0.s.o(.text); build/asm/main_800ABBC0.s.o(.rodata); build/asm/main_800ABBC0.s.o(.data); }
    .main_800ABBC0_bss (NOLOAD) : { build/asm/main_800ABBC0.s.o(.bss); }
    .main_800AC7E8 0x800AC7E8 : AT(0x000AD3E8) { build/asm/data/main_800AC7E8.bin.o(.data); }
    .main_800AD504 0x800AD504 : AT(0x000AE104) { FILL(0x00000000); build/asm/main_800AD504.s.o(.text); build/asm/main_800AD504.s.o(.rodata); build/asm/main_800AD504.s.o(.data); }
    .main_800AD504_bss (NOLOAD) : { build/asm/main_800AD504.s.o(.bss); }
    .main_800ADB00 0x800ADB00 : AT(0x000AE700) { build/asm/data/main_800ADB00.bin.o(.data); }
    .main_800ADC20 0x800ADC20 : AT(0x000AE820) { FILL(0x00000000); build/asm/main_800ADC20.s.o(.text); build/asm/main_800ADC20.s.o(.rodata); build/asm/main_800ADC20.s.o(.data); }
    .main_800ADC20_bss (NOLOAD) : { build/asm/main_800ADC20.s.o(.bss); }
    .main_800AE668 0x800AE668 : AT(0x000AF268) { build/asm/data/main_800AE668.bin.o(.data); }
    .main_800AE73C 0x800AE73C : AT(0x000AF33C) { FILL(0x00000000); build/asm/main_800AE73C.s.o(.text); build/asm/main_800AE73C.s.o(.rodata); build/asm/main_800AE73C.s.o(.data); }
    .main_800AE73C_bss (NOLOAD) : { build/asm/main_800AE73C.s.o(.bss); }
    .main_800B0E80 0x800B0E80 : AT(0x000B1A80) { build/asm/data/main_800B0E80.bin.o(.data); }
    .main_800B18A0 0x800B18A0 : AT(0x000B24A0) { FILL(0x00000000); build/asm/main_800B18A0.s.o(.text); build/asm/main_800B18A0.s.o(.rodata); build/asm/main_800B18A0.s.o(.data); }
    .main_800B18A0_bss (NOLOAD) : { build/asm/main_800B18A0.s.o(.bss); }
    .main_800B18A8 0x800B18A8 : AT(0x000B24A8) { build/asm/data/main_800B18A8.bin.o(.data); }
    .main_800B3B10 0x800B3B10 : AT(0x000B4710) { FILL(0x00000000); build/asm/main_800B3B10.s.o(.text); build/asm/main_800B3B10.s.o(.rodata); build/asm/main_800B3B10.s.o(.data); }
    .main_800B3B10_bss (NOLOAD) : { build/asm/main_800B3B10.s.o(.bss); }
    .main_800B3B84 0x800B3B84 : AT(0x000B4784) { build/asm/data/main_800B3B84.bin.o(.data); }
    .main_800B5E08 0x800B5E08 : AT(0x000B6A08) { FILL(0x00000000); build/asm/main_800B5E08.s.o(.text); build/asm/main_800B5E08.s.o(.rodata); build/asm/main_800B5E08.s.o(.data); }
    .main_800B5E08_bss (NOLOAD) : { build/asm/main_800B5E08.s.o(.bss); }
    .main_800B60C0 0x800B60C0 : AT(0x000B6CC0) { build/asm/data/main_800B60C0.bin.o(.data); }
    .main_800BA23C 0x800BA23C : AT(0x000BAE3C) { FILL(0x00000000); build/asm/main_800BA23C.s.o(.text); build/asm/main_800BA23C.s.o(.rodata); build/asm/main_800BA23C.s.o(.data); }
    .main_800BA23C_bss (NOLOAD) : { build/asm/main_800BA23C.s.o(.bss); }
    .main_800BA28C 0x800BA28C : AT(0x000BAE8C) { build/asm/data/main_800BA28C.bin.o(.data); }
    .main_800BA710 0x800BA710 : AT(0x000BB310) { FILL(0x00000000); build/asm/main_800BA710.s.o(.text); build/asm/main_800BA710.s.o(.rodata); build/asm/main_800BA710.s.o(.data); }
    .main_800BA710_bss (NOLOAD) : { build/asm/main_800BA710.s.o(.bss); }
    .main_800BA74C 0x800BA74C : AT(0x000BB34C) { build/asm/data/main_800BA74C.bin.o(.data); }
    .main_800BC3B4 0x800BC3B4 : AT(0x000BCFB4) { FILL(0x00000000); build/asm/main_800BC3B4.s.o(.text); build/asm/main_800BC3B4.s.o(.rodata); build/asm/main_800BC3B4.s.o(.data); }
    .main_800BC3B4_bss (NOLOAD) : { build/asm/main_800BC3B4.s.o(.bss); }
    .main_800BC3CC 0x800BC3CC : AT(0x000BCFCC) { build/asm/data/main_800BC3CC.bin.o(.data); }
    .main_800BD584 0x800BD584 : AT(0x000BE184) { FILL(0x00000000); build/asm/main_800BD584.s.o(.text); build/asm/main_800BD584.s.o(.rodata); build/asm/main_800BD584.s.o(.data); }
    .main_800BD584_bss (NOLOAD) : { build/asm/main_800BD584.s.o(.bss); }
    .main_800BD598 0x800BD598 : AT(0x000BE198) { build/asm/data/main_800BD598.bin.o(.data); }
    .main_800BD84C 0x800BD84C : AT(0x000BE44C) { FILL(0x00000000); build/asm/main_800BD84C.s.o(.text); build/asm/main_800BD84C.s.o(.rodata); build/asm/main_800BD84C.s.o(.data); }
    .main_800BD84C_bss (NOLOAD) : { build/asm/main_800BD84C.s.o(.bss); }
    .main_800BD92C 0x800BD92C : AT(0x000BE52C) { build/asm/data/main_800BD92C.bin.o(.data); }
    .main_800BE190 0x800BE190 : AT(0x000BED90) { FILL(0x00000000); build/asm/main_800BE190.s.o(.text); build/asm/main_800BE190.s.o(.rodata); build/asm/main_800BE190.s.o(.data); }
    .main_800BE190_bss (NOLOAD) : { build/asm/main_800BE190.s.o(.bss); }
    .main_800BE238 0x800BE238 : AT(0x000BEE38) { build/asm/data/main_800BE238.bin.o(.data); }
    .main_800BFC18 0x800BFC18 : AT(0x000C0818) { FILL(0x00000000); build/asm/main_800BFC18.s.o(.text); build/asm/main_800BFC18.s.o(.rodata); build/asm/main_800BFC18.s.o(.data); }
    .main_800BFC18_bss (NOLOAD) : { build/asm/main_800BFC18.s.o(.bss); }
    .main_800BFC64 0x800BFC64 : AT(0x000C0864) { build/asm/data/main_800BFC64.bin.o(.data); }
    .main_800BFCBC 0x800BFCBC : AT(0x000C08BC) { FILL(0x00000000); build/asm/main_800BFCBC.s.o(.text); build/asm/main_800BFCBC.s.o(.rodata); build/asm/main_800BFCBC.s.o(.data); }
    .main_800BFCBC_bss (NOLOAD) : { build/asm/main_800BFCBC.s.o(.bss); }
    .main_800BFCD0 0x800BFCD0 : AT(0x000C08D0) { build/asm/data/main_800BFCD0.bin.o(.data); }
    .main_800BFF90 0x800BFF90 : AT(0x000C0B90) { FILL(0x00000000); build/asm/main_800BFF90.s.o(.text); build/asm/main_800BFF90.s.o(.rodata); build/asm/main_800BFF90.s.o(.data); }
    .main_800BFF90_bss (NOLOAD) : { build/asm/main_800BFF90.s.o(.bss); }
    .main_800BFFB8 0x800BFFB8 : AT(0x000C0BB8) { build/asm/data/main_800BFFB8.bin.o(.data); }
    .main_800C57C0 0x800C57C0 : AT(0x000C63C0) { FILL(0x00000000); build/asm/main_800C57C0.s.o(.text); build/asm/main_800C57C0.s.o(.rodata); build/asm/main_800C57C0.s.o(.data); }
    .main_800C57C0_bss (NOLOAD) : { build/asm/main_800C57C0.s.o(.bss); }
    .main_800C5844 0x800C5844 : AT(0x000C6444) { build/asm/data/main_800C5844.bin.o(.data); }
    .main_800C61E4 0x800C61E4 : AT(0x000C6DE4) { FILL(0x00000000); build/asm/main_800C61E4.s.o(.text); build/asm/main_800C61E4.s.o(.rodata); build/asm/main_800C61E4.s.o(.data); }
    .main_800C61E4_bss (NOLOAD) : { build/asm/main_800C61E4.s.o(.bss); }
    .main_800C61EC 0x800C61EC : AT(0x000C6DEC) { build/asm/data/main_800C61EC.bin.o(.data); }
    .main_800C7C9C 0x800C7C9C : AT(0x000C889C) { FILL(0x00000000); build/asm/main_800C7C9C.s.o(.text); build/asm/main_800C7C9C.s.o(.rodata); build/asm/main_800C7C9C.s.o(.data); }
    .main_800C7C9C_bss (NOLOAD) : { build/asm/main_800C7C9C.s.o(.bss); }
    .main_800C7CE0 0x800C7CE0 : AT(0x000C88E0) { build/asm/data/main_800C7CE0.bin.o(.data); }
    .main_800C8784 0x800C8784 : AT(0x000C9384) { FILL(0x00000000); build/asm/main_800C8784.s.o(.text); build/asm/main_800C8784.s.o(.rodata); build/asm/main_800C8784.s.o(.data); }
    .main_800C8784_bss (NOLOAD) : { build/asm/main_800C8784.s.o(.bss); }
    .main_800C87D4 0x800C87D4 : AT(0x000C93D4) { build/asm/data/main_800C87D4.bin.o(.data); }
    .main_800C880C 0x800C880C : AT(0x000C940C) { FILL(0x00000000); build/asm/main_800C880C.s.o(.text); build/asm/main_800C880C.s.o(.rodata); build/asm/main_800C880C.s.o(.data); }
    .main_800C880C_bss (NOLOAD) : { build/asm/main_800C880C.s.o(.bss); }
    .main_800C885C 0x800C885C : AT(0x000C945C) { build/asm/data/main_800C885C.bin.o(.data); }
    .main_800C8938 0x800C8938 : AT(0x000C9538) { FILL(0x00000000); build/asm/main_800C8938.s.o(.text); build/asm/main_800C8938.s.o(.rodata); build/asm/main_800C8938.s.o(.data); }
    .main_800C8938_bss (NOLOAD) : { build/asm/main_800C8938.s.o(.bss); }
    .main_800C8988 0x800C8988 : AT(0x000C9588) { build/asm/data/main_800C8988.bin.o(.data); }
    .main_800C8B60 0x800C8B60 : AT(0x000C9760) { FILL(0x00000000); build/asm/main_800C8B60.s.o(.text); build/asm/main_800C8B60.s.o(.rodata); build/asm/main_800C8B60.s.o(.data); }
    .main_800C8B60_bss (NOLOAD) : { build/asm/main_800C8B60.s.o(.bss); }
    .main_800C8B94 0x800C8B94 : AT(0x000C9794) { build/asm/data/main_800C8B94.bin.o(.data); }
    .main_800C91FC 0x800C91FC : AT(0x000C9DFC) { FILL(0x00000000); build/asm/main_800C91FC.s.o(.text); build/asm/main_800C91FC.s.o(.rodata); build/asm/main_800C91FC.s.o(.data); }
    .main_800C91FC_bss (NOLOAD) : { build/asm/main_800C91FC.s.o(.bss); }
    .main_800C928C 0x800C928C : AT(0x000C9E8C) { build/asm/data/main_800C928C.bin.o(.data); }
    .main_800C9378 0x800C9378 : AT(0x000C9F78) { FILL(0x00000000); build/asm/main_800C9378.s.o(.text); build/asm/main_800C9378.s.o(.rodata); build/asm/main_800C9378.s.o(.data); }
    .main_800C9378_bss (NOLOAD) : { build/asm/main_800C9378.s.o(.bss); }
    .main_800C94B8 0x800C94B8 : AT(0x000CA0B8) { build/asm/data/main_800C94B8.bin.o(.data); }
    .main_800C982C 0x800C982C : AT(0x000CA42C) { FILL(0x00000000); build/asm/main_800C982C.s.o(.text); build/asm/main_800C982C.s.o(.rodata); build/asm/main_800C982C.s.o(.data); }
    .main_800C982C_bss (NOLOAD) : { build/asm/main_800C982C.s.o(.bss); }
    .main_800C9870 0x800C9870 : AT(0x000CA470) { build/asm/data/main_800C9870.bin.o(.data); }
    .main_800C99A8 0x800C99A8 : AT(0x000CA5A8) { FILL(0x00000000); build/asm/main_800C99A8.s.o(.text); build/asm/main_800C99A8.s.o(.rodata); build/asm/main_800C99A8.s.o(.data); }
    .main_800C99A8_bss (NOLOAD) : { build/asm/main_800C99A8.s.o(.bss); }
    .main_800C99B0 0x800C99B0 : AT(0x000CA5B0) { build/asm/data/main_800C99B0.bin.o(.data); }
    .main_800C9A90 0x800C9A90 : AT(0x000CA690) { FILL(0x00000000); build/asm/main_800C9A90.s.o(.text); build/asm/main_800C9A90.s.o(.rodata); build/asm/main_800C9A90.s.o(.data); }
    .main_800C9A90_bss (NOLOAD) : { build/asm/main_800C9A90.s.o(.bss); }
    .main_800C9ABC 0x800C9ABC : AT(0x000CA6BC) { build/asm/data/main_800C9ABC.bin.o(.data); }
    .main_800CAFC0 0x800CAFC0 : AT(0x000CBBC0) { FILL(0x00000000); build/asm/main_800CAFC0.s.o(.text); build/asm/main_800CAFC0.s.o(.rodata); build/asm/main_800CAFC0.s.o(.data); }
    .main_800CAFC0_bss (NOLOAD) : { build/asm/main_800CAFC0.s.o(.bss); }
    .main_800CAFE4 0x800CAFE4 : AT(0x000CBBE4) { build/asm/data/main_800CAFE4.bin.o(.data); }
    .main_800CB138 0x800CB138 : AT(0x000CBD38) { FILL(0x00000000); build/asm/main_800CB138.s.o(.text); build/asm/main_800CB138.s.o(.rodata); build/asm/main_800CB138.s.o(.data); }
    .main_800CB138_bss (NOLOAD) : { build/asm/main_800CB138.s.o(.bss); }
    .main_800CB184 0x800CB184 : AT(0x000CBD84) { build/asm/data/main_800CB184.bin.o(.data); }
    .main_800CB394 0x800CB394 : AT(0x000CBF94) { FILL(0x00000000); build/asm/main_800CB394.s.o(.text); build/asm/main_800CB394.s.o(.rodata); build/asm/main_800CB394.s.o(.data); }
    .main_800CB394_bss (NOLOAD) : { build/asm/main_800CB394.s.o(.bss); }
    .main_800CB3F8 0x800CB3F8 : AT(0x000CBFF8) { build/asm/data/main_800CB3F8.bin.o(.data); }
    .main_800CB46C 0x800CB46C : AT(0x000CC06C) { FILL(0x00000000); build/asm/main_800CB46C.s.o(.text); build/asm/main_800CB46C.s.o(.rodata); build/asm/main_800CB46C.s.o(.data); }
    .main_800CB46C_bss (NOLOAD) : { build/asm/main_800CB46C.s.o(.bss); }
    .main_800CB760 0x800CB760 : AT(0x000CC360) { build/asm/data/main_800CB760.bin.o(.data); }
    .main_800CB9F0 0x800CB9F0 : AT(0x000CC5F0) { FILL(0x00000000); build/asm/main_800CB9F0.s.o(.text); build/asm/main_800CB9F0.s.o(.rodata); build/asm/main_800CB9F0.s.o(.data); }
    .main_800CB9F0_bss (NOLOAD) : { build/asm/main_800CB9F0.s.o(.bss); }
    .main_800CBA38 0x800CBA38 : AT(0x000CC638) { build/asm/data/main_800CBA38.bin.o(.data); }
    .main_800D0378 0x800D0378 : AT(0x000D0F78) { FILL(0x00000000); build/asm/main_800D0378.s.o(.text); build/asm/main_800D0378.s.o(.rodata); build/asm/main_800D0378.s.o(.data); }
    .main_800D0378_bss (NOLOAD) : { build/asm/main_800D0378.s.o(.bss); }
    .main_800D0394 0x800D0394 : AT(0x000D0F94) { build/asm/data/main_800D0394.bin.o(.data); }
    .main_800D0FD8 0x800D0FD8 : AT(0x000D1BD8) { FILL(0x00000000); build/asm/main_800D0FD8.s.o(.text); build/asm/main_800D0FD8.s.o(.rodata); build/asm/main_800D0FD8.s.o(.data); }
    .main_800D0FD8_bss (NOLOAD) : { build/asm/main_800D0FD8.s.o(.bss); }
    .main_800D10B4 0x800D10B4 : AT(0x000D1CB4) { build/asm/data/main_800D10B4.bin.o(.data); }
    .main_800D1318 0x800D1318 : AT(0x000D1F18) { FILL(0x00000000); build/asm/main_800D1318.s.o(.text); build/asm/main_800D1318.s.o(.rodata); build/asm/main_800D1318.s.o(.data); }
    .main_800D1318_bss (NOLOAD) : { build/asm/main_800D1318.s.o(.bss); }
    .main_800D1368 0x800D1368 : AT(0x000D1F68) { build/asm/data/main_800D1368.bin.o(.data); }
    .main_800D17A4 0x800D17A4 : AT(0x000D23A4) { FILL(0x00000000); build/asm/main_800D17A4.s.o(.text); build/asm/main_800D17A4.s.o(.rodata); build/asm/main_800D17A4.s.o(.data); }
    .main_800D17A4_bss (NOLOAD) : { build/asm/main_800D17A4.s.o(.bss); }
    .main_800D17F8 0x800D17F8 : AT(0x000D23F8) { build/asm/data/main_800D17F8.bin.o(.data); }
    .main_800D1854 0x800D1854 : AT(0x000D2454) { FILL(0x00000000); build/asm/main_800D1854.s.o(.text); build/asm/main_800D1854.s.o(.rodata); build/asm/main_800D1854.s.o(.data); }
    .main_800D1854_bss (NOLOAD) : { build/asm/main_800D1854.s.o(.bss); }
    .main_800D1908 0x800D1908 : AT(0x000D2508) { build/asm/data/main_800D1908.bin.o(.data); }
    .main_800D1A34 0x800D1A34 : AT(0x000D2634) { FILL(0x00000000); build/asm/main_800D1A34.s.o(.text); build/asm/main_800D1A34.s.o(.rodata); build/asm/main_800D1A34.s.o(.data); }
    .main_800D1A34_bss (NOLOAD) : { build/asm/main_800D1A34.s.o(.bss); }
    .main_800D1A68 0x800D1A68 : AT(0x000D2668) { build/asm/data/main_800D1A68.bin.o(.data); }
    .main_800D1D8C 0x800D1D8C : AT(0x000D298C) { FILL(0x00000000); build/asm/main_800D1D8C.s.o(.text); build/asm/main_800D1D8C.s.o(.rodata); build/asm/main_800D1D8C.s.o(.data); }
    .main_800D1D8C_bss (NOLOAD) : { build/asm/main_800D1D8C.s.o(.bss); }
    .main_800D1DE0 0x800D1DE0 : AT(0x000D29E0) { build/asm/data/main_800D1DE0.bin.o(.data); }
    .main_800D1E98 0x800D1E98 : AT(0x000D2A98) { FILL(0x00000000); build/asm/main_800D1E98.s.o(.text); build/asm/main_800D1E98.s.o(.rodata); build/asm/main_800D1E98.s.o(.data); }
    .main_800D1E98_bss (NOLOAD) : { build/asm/main_800D1E98.s.o(.bss); }
    .main_800D1EA0 0x800D1EA0 : AT(0x000D2AA0) { build/asm/data/main_800D1EA0.bin.o(.data); }
    .main_800D2530 0x800D2530 : AT(0x000D3130) { build/asm/data/main_800D2530.bin.o(.data); }
    .main_800D27FC 0x800D27FC : AT(0x000D33FC) { FILL(0x00000000); build/asm/main_800D27FC.s.o(.text); build/asm/main_800D27FC.s.o(.rodata); build/asm/main_800D27FC.s.o(.data); }
    .main_800D27FC_bss (NOLOAD) : { build/asm/main_800D27FC.s.o(.bss); }
    .main_800D284C 0x800D284C : AT(0x000D344C) { build/asm/data/main_800D284C.bin.o(.data); }
    .main_800DE2F4 0x800DE2F4 : AT(0x000DEEF4) { FILL(0x00000000); build/asm/main_800DE2F4.s.o(.text); build/asm/main_800DE2F4.s.o(.rodata); build/asm/main_800DE2F4.s.o(.data); }
    .main_800DE2F4_bss (NOLOAD) : { build/asm/main_800DE2F4.s.o(.bss); }
    .main_800DE30C 0x800DE30C : AT(0x000DEF0C) { build/asm/data/main_800DE30C.bin.o(.data); }
    .main_800DF2B0 0x800DF2B0 : AT(0x000DFEB0) { FILL(0x00000000); build/asm/main_800DF2B0.s.o(.text); build/asm/main_800DF2B0.s.o(.rodata); build/asm/main_800DF2B0.s.o(.data); }
    .main_800DF2B0_bss (NOLOAD) : { build/asm/main_800DF2B0.s.o(.bss); }
    .main_800DF2E4 0x800DF2E4 : AT(0x000DFEE4) { build/asm/data/main_800DF2E4.bin.o(.data); }
    .main_800DFF0C 0x800DFF0C : AT(0x000E0B0C) { FILL(0x00000000); build/asm/main_800DFF0C.s.o(.text); build/asm/main_800DFF0C.s.o(.rodata); build/asm/main_800DFF0C.s.o(.data); }
    .main_800DFF0C_bss (NOLOAD) : { build/asm/main_800DFF0C.s.o(.bss); }
    .main_800DFF44 0x800DFF44 : AT(0x000E0B44) { build/asm/data/main_800DFF44.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
