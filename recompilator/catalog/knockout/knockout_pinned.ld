SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80001024 0x80001024 : AT(0x00001C24) { FILL(0x00000000); build/asm/main_80001024.s.o(.text); build/asm/main_80001024.s.o(.rodata); build/asm/main_80001024.s.o(.data); }
    .main_80001024_bss (NOLOAD) : { build/asm/main_80001024.s.o(.bss); }
    .main_8000284C 0x8000284C : AT(0x0000344C) { build/asm/data/main_8000284C.bin.o(.data); }
    .main_80002850 0x80002850 : AT(0x00003450) { FILL(0x00000000); build/asm/main_80002850.s.o(.text); build/asm/main_80002850.s.o(.rodata); build/asm/main_80002850.s.o(.data); }
    .main_80002850_bss (NOLOAD) : { build/asm/main_80002850.s.o(.bss); }
    .main_800043B4 0x800043B4 : AT(0x00004FB4) { FILL(0x00000000); build/asm/main_800043B4.s.o(.text); build/asm/main_800043B4.s.o(.rodata); build/asm/main_800043B4.s.o(.data); }
    .main_800043B4_bss (NOLOAD) : { build/asm/main_800043B4.s.o(.bss); }
    .main_80013B70 0x80013B70 : AT(0x00014770) { FILL(0x00000000); build/asm/main_80013B70.s.o(.text); build/asm/main_80013B70.s.o(.rodata); build/asm/main_80013B70.s.o(.data); }
    .main_80013B70_bss (NOLOAD) : { build/asm/main_80013B70.s.o(.bss); }
    .main_800163B8 0x800163B8 : AT(0x00016FB8) { FILL(0x00000000); build/asm/main_800163B8.s.o(.text); build/asm/main_800163B8.s.o(.rodata); build/asm/main_800163B8.s.o(.data); }
    .main_800163B8_bss (NOLOAD) : { build/asm/main_800163B8.s.o(.bss); }
    .main_800166C8 0x800166C8 : AT(0x000172C8) { FILL(0x00000000); build/asm/main_800166C8.s.o(.text); build/asm/main_800166C8.s.o(.rodata); build/asm/main_800166C8.s.o(.data); }
    .main_800166C8_bss (NOLOAD) : { build/asm/main_800166C8.s.o(.bss); }
    .main_80018544 0x80018544 : AT(0x00019144) { FILL(0x00000000); build/asm/main_80018544.s.o(.text); build/asm/main_80018544.s.o(.rodata); build/asm/main_80018544.s.o(.data); }
    .main_80018544_bss (NOLOAD) : { build/asm/main_80018544.s.o(.bss); }
    .main_8001934C 0x8001934C : AT(0x00019F4C) { FILL(0x00000000); build/asm/main_8001934C.s.o(.text); build/asm/main_8001934C.s.o(.rodata); build/asm/main_8001934C.s.o(.data); }
    .main_8001934C_bss (NOLOAD) : { build/asm/main_8001934C.s.o(.bss); }
    .main_80019728 0x80019728 : AT(0x0001A328) { FILL(0x00000000); build/asm/main_80019728.s.o(.text); build/asm/main_80019728.s.o(.rodata); build/asm/main_80019728.s.o(.data); }
    .main_80019728_bss (NOLOAD) : { build/asm/main_80019728.s.o(.bss); }
    .main_8001AF58 0x8001AF58 : AT(0x0001BB58) { FILL(0x00000000); build/asm/main_8001AF58.s.o(.text); build/asm/main_8001AF58.s.o(.rodata); build/asm/main_8001AF58.s.o(.data); }
    .main_8001AF58_bss (NOLOAD) : { build/asm/main_8001AF58.s.o(.bss); }
    .main_8001C108 0x8001C108 : AT(0x0001CD08) { FILL(0x00000000); build/asm/main_8001C108.s.o(.text); build/asm/main_8001C108.s.o(.rodata); build/asm/main_8001C108.s.o(.data); }
    .main_8001C108_bss (NOLOAD) : { build/asm/main_8001C108.s.o(.bss); }
    .main_80021268 0x80021268 : AT(0x00021E68) { FILL(0x00000000); build/asm/main_80021268.s.o(.text); build/asm/main_80021268.s.o(.rodata); build/asm/main_80021268.s.o(.data); }
    .main_80021268_bss (NOLOAD) : { build/asm/main_80021268.s.o(.bss); }
    .main_80021AE4 0x80021AE4 : AT(0x000226E4) { FILL(0x00000000); build/asm/main_80021AE4.s.o(.text); build/asm/main_80021AE4.s.o(.rodata); build/asm/main_80021AE4.s.o(.data); }
    .main_80021AE4_bss (NOLOAD) : { build/asm/main_80021AE4.s.o(.bss); }
    .main_80021FA8 0x80021FA8 : AT(0x00022BA8) { FILL(0x00000000); build/asm/main_80021FA8.s.o(.text); build/asm/main_80021FA8.s.o(.rodata); build/asm/main_80021FA8.s.o(.data); }
    .main_80021FA8_bss (NOLOAD) : { build/asm/main_80021FA8.s.o(.bss); }
    .main_800221AC 0x800221AC : AT(0x00022DAC) { FILL(0x00000000); build/asm/main_800221AC.s.o(.text); build/asm/main_800221AC.s.o(.rodata); build/asm/main_800221AC.s.o(.data); }
    .main_800221AC_bss (NOLOAD) : { build/asm/main_800221AC.s.o(.bss); }
    .main_80022BF8 0x80022BF8 : AT(0x000237F8) { FILL(0x00000000); build/asm/main_80022BF8.s.o(.text); build/asm/main_80022BF8.s.o(.rodata); build/asm/main_80022BF8.s.o(.data); }
    .main_80022BF8_bss (NOLOAD) : { build/asm/main_80022BF8.s.o(.bss); }
    .main_80023044 0x80023044 : AT(0x00023C44) { FILL(0x00000000); build/asm/main_80023044.s.o(.text); build/asm/main_80023044.s.o(.rodata); build/asm/main_80023044.s.o(.data); }
    .main_80023044_bss (NOLOAD) : { build/asm/main_80023044.s.o(.bss); }
    .main_80026268 0x80026268 : AT(0x00026E68) { FILL(0x00000000); build/asm/main_80026268.s.o(.text); build/asm/main_80026268.s.o(.rodata); build/asm/main_80026268.s.o(.data); }
    .main_80026268_bss (NOLOAD) : { build/asm/main_80026268.s.o(.bss); }
    .main_8002AE70 0x8002AE70 : AT(0x0002BA70) { build/asm/data/main_8002AE70.bin.o(.data); }
    .main_8002C400 0x8002C400 : AT(0x0002D000) { build/asm/data/main_8002C400.bin.o(.data); }
    .main_8002D298 0x8002D298 : AT(0x0002DE98) { build/asm/data/main_8002D298.bin.o(.data); }
    .main_8002D7CC 0x8002D7CC : AT(0x0002E3CC) { FILL(0x00000000); build/asm/main_8002D7CC.s.o(.text); build/asm/main_8002D7CC.s.o(.rodata); build/asm/main_8002D7CC.s.o(.data); }
    .main_8002D7CC_bss (NOLOAD) : { build/asm/main_8002D7CC.s.o(.bss); }
    .main_8002E4C4 0x8002E4C4 : AT(0x0002F0C4) { FILL(0x00000000); build/asm/main_8002E4C4.s.o(.text); build/asm/main_8002E4C4.s.o(.rodata); build/asm/main_8002E4C4.s.o(.data); }
    .main_8002E4C4_bss (NOLOAD) : { build/asm/main_8002E4C4.s.o(.bss); }
    .main_8002E7C4 0x8002E7C4 : AT(0x0002F3C4) { build/asm/data/main_8002E7C4.bin.o(.data); }
    .main_8002EBA4 0x8002EBA4 : AT(0x0002F7A4) { build/asm/data/main_8002EBA4.bin.o(.data); }
    .main_80030E60 0x80030E60 : AT(0x00031A60) { build/asm/data/main_80030E60.bin.o(.data); }
    .main_80031310 0x80031310 : AT(0x00031F10) { build/asm/data/main_80031310.bin.o(.data); }
    .main_80033360 0x80033360 : AT(0x00033F60) { build/asm/data/main_80033360.bin.o(.data); }
    .main_8003390C 0x8003390C : AT(0x0003450C) { build/asm/data/main_8003390C.bin.o(.data); }
    .main_800346CC 0x800346CC : AT(0x000352CC) { FILL(0x00000000); build/asm/main_800346CC.s.o(.text); build/asm/main_800346CC.s.o(.rodata); build/asm/main_800346CC.s.o(.data); }
    .main_800346CC_bss (NOLOAD) : { build/asm/main_800346CC.s.o(.bss); }
    .main_80034934 0x80034934 : AT(0x00035534) { build/asm/data/main_80034934.bin.o(.data); }
    .main_80036990 0x80036990 : AT(0x00037590) { build/asm/data/main_80036990.bin.o(.data); }
    .main_80036B84 0x80036B84 : AT(0x00037784) { build/asm/data/main_80036B84.bin.o(.data); }
    .main_80036FC8 0x80036FC8 : AT(0x00037BC8) { build/asm/data/main_80036FC8.bin.o(.data); }
    .main_800386E4 0x800386E4 : AT(0x000392E4) { build/asm/data/main_800386E4.bin.o(.data); }
    .main_80038D88 0x80038D88 : AT(0x00039988) { build/asm/data/main_80038D88.bin.o(.data); }
    .main_80039358 0x80039358 : AT(0x00039F58) { build/asm/data/main_80039358.bin.o(.data); }
    .main_800399B4 0x800399B4 : AT(0x0003A5B4) { build/asm/data/main_800399B4.bin.o(.data); }
    .main_80039F54 0x80039F54 : AT(0x0003AB54) { build/asm/data/main_80039F54.bin.o(.data); }
    .main_8003B0A8 0x8003B0A8 : AT(0x0003BCA8) { build/asm/data/main_8003B0A8.bin.o(.data); }
    .main_8003C624 0x8003C624 : AT(0x0003D224) { build/asm/data/main_8003C624.bin.o(.data); }
    .main_8003D2F8 0x8003D2F8 : AT(0x0003DEF8) { FILL(0x00000000); build/asm/main_8003D2F8.s.o(.text); build/asm/main_8003D2F8.s.o(.rodata); build/asm/main_8003D2F8.s.o(.data); }
    .main_8003D2F8_bss (NOLOAD) : { build/asm/main_8003D2F8.s.o(.bss); }
    .main_8003D7D8 0x8003D7D8 : AT(0x0003E3D8) { build/asm/data/main_8003D7D8.bin.o(.data); }
    .main_8003DCC4 0x8003DCC4 : AT(0x0003E8C4) { FILL(0x00000000); build/asm/main_8003DCC4.s.o(.text); build/asm/main_8003DCC4.s.o(.rodata); build/asm/main_8003DCC4.s.o(.data); }
    .main_8003DCC4_bss (NOLOAD) : { build/asm/main_8003DCC4.s.o(.bss); }
    .main_8003DCD0 0x8003DCD0 : AT(0x0003E8D0) { build/asm/data/main_8003DCD0.bin.o(.data); }
    .main_800414A8 0x800414A8 : AT(0x000420A8) { FILL(0x00000000); build/asm/main_800414A8.s.o(.text); build/asm/main_800414A8.s.o(.rodata); build/asm/main_800414A8.s.o(.data); }
    .main_800414A8_bss (NOLOAD) : { build/asm/main_800414A8.s.o(.bss); }
    .main_800414C4 0x800414C4 : AT(0x000420C4) { build/asm/data/main_800414C4.bin.o(.data); }
    .main_80046534 0x80046534 : AT(0x00047134) { FILL(0x00000000); build/asm/main_80046534.s.o(.text); build/asm/main_80046534.s.o(.rodata); build/asm/main_80046534.s.o(.data); }
    .main_80046534_bss (NOLOAD) : { build/asm/main_80046534.s.o(.bss); }
    .main_80046588 0x80046588 : AT(0x00047188) { build/asm/data/main_80046588.bin.o(.data); }
    .main_8004BB10 0x8004BB10 : AT(0x0004C710) { FILL(0x00000000); build/asm/main_8004BB10.s.o(.text); build/asm/main_8004BB10.s.o(.rodata); build/asm/main_8004BB10.s.o(.data); }
    .main_8004BB10_bss (NOLOAD) : { build/asm/main_8004BB10.s.o(.bss); }
    .main_8004BB3C 0x8004BB3C : AT(0x0004C73C) { build/asm/data/main_8004BB3C.bin.o(.data); }
    .main_8004BE54 0x8004BE54 : AT(0x0004CA54) { FILL(0x00000000); build/asm/main_8004BE54.s.o(.text); build/asm/main_8004BE54.s.o(.rodata); build/asm/main_8004BE54.s.o(.data); }
    .main_8004BE54_bss (NOLOAD) : { build/asm/main_8004BE54.s.o(.bss); }
    .main_8004BE5C 0x8004BE5C : AT(0x0004CA5C) { build/asm/data/main_8004BE5C.bin.o(.data); }
    .main_8005722C 0x8005722C : AT(0x00057E2C) { FILL(0x00000000); build/asm/main_8005722C.s.o(.text); build/asm/main_8005722C.s.o(.rodata); build/asm/main_8005722C.s.o(.data); }
    .main_8005722C_bss (NOLOAD) : { build/asm/main_8005722C.s.o(.bss); }
    .main_80057240 0x80057240 : AT(0x00057E40) { build/asm/data/main_80057240.bin.o(.data); }
    .main_8006B72C 0x8006B72C : AT(0x0006C32C) { FILL(0x00000000); build/asm/main_8006B72C.s.o(.text); build/asm/main_8006B72C.s.o(.rodata); build/asm/main_8006B72C.s.o(.data); }
    .main_8006B72C_bss (NOLOAD) : { build/asm/main_8006B72C.s.o(.bss); }
    .main_8006B9F8 0x8006B9F8 : AT(0x0006C5F8) { build/asm/data/main_8006B9F8.bin.o(.data); }
    .main_8006CE78 0x8006CE78 : AT(0x0006DA78) { build/asm/data/main_8006CE78.bin.o(.data); }
    .main_8006D8A8 0x8006D8A8 : AT(0x0006E4A8) { build/asm/data/main_8006D8A8.bin.o(.data); }
    .main_8006FB6C 0x8006FB6C : AT(0x0007076C) { FILL(0x00000000); build/asm/main_8006FB6C.s.o(.text); build/asm/main_8006FB6C.s.o(.rodata); build/asm/main_8006FB6C.s.o(.data); }
    .main_8006FB6C_bss (NOLOAD) : { build/asm/main_8006FB6C.s.o(.bss); }
    .main_8006FBCC 0x8006FBCC : AT(0x000707CC) { build/asm/data/main_8006FBCC.bin.o(.data); }
    .main_80072690 0x80072690 : AT(0x00073290) { FILL(0x00000000); build/asm/main_80072690.s.o(.text); build/asm/main_80072690.s.o(.rodata); build/asm/main_80072690.s.o(.data); }
    .main_80072690_bss (NOLOAD) : { build/asm/main_80072690.s.o(.bss); }
    .main_8007269C 0x8007269C : AT(0x0007329C) { build/asm/data/main_8007269C.bin.o(.data); }
    .main_80073BB0 0x80073BB0 : AT(0x000747B0) { FILL(0x00000000); build/asm/main_80073BB0.s.o(.text); build/asm/main_80073BB0.s.o(.rodata); build/asm/main_80073BB0.s.o(.data); }
    .main_80073BB0_bss (NOLOAD) : { build/asm/main_80073BB0.s.o(.bss); }
    .main_80077BA8 0x80077BA8 : AT(0x000787A8) { build/asm/data/main_80077BA8.bin.o(.data); }
    .main_80081494 0x80081494 : AT(0x00082094) { FILL(0x00000000); build/asm/main_80081494.s.o(.text); build/asm/main_80081494.s.o(.rodata); build/asm/main_80081494.s.o(.data); }
    .main_80081494_bss (NOLOAD) : { build/asm/main_80081494.s.o(.bss); }
    .main_800814A8 0x800814A8 : AT(0x000820A8) { build/asm/data/main_800814A8.bin.o(.data); }
    .main_80086198 0x80086198 : AT(0x00086D98) { FILL(0x00000000); build/asm/main_80086198.s.o(.text); build/asm/main_80086198.s.o(.rodata); build/asm/main_80086198.s.o(.data); }
    .main_80086198_bss (NOLOAD) : { build/asm/main_80086198.s.o(.bss); }
    .main_8008621C 0x8008621C : AT(0x00086E1C) { build/asm/data/main_8008621C.bin.o(.data); }
    .main_80086E48 0x80086E48 : AT(0x00087A48) { FILL(0x00000000); build/asm/main_80086E48.s.o(.text); build/asm/main_80086E48.s.o(.rodata); build/asm/main_80086E48.s.o(.data); }
    .main_80086E48_bss (NOLOAD) : { build/asm/main_80086E48.s.o(.bss); }
    .main_80086E54 0x80086E54 : AT(0x00087A54) { build/asm/data/main_80086E54.bin.o(.data); }
    .main_800937F8 0x800937F8 : AT(0x000943F8) { FILL(0x00000000); build/asm/main_800937F8.s.o(.text); build/asm/main_800937F8.s.o(.rodata); build/asm/main_800937F8.s.o(.data); }
    .main_800937F8_bss (NOLOAD) : { build/asm/main_800937F8.s.o(.bss); }
    .main_80093824 0x80093824 : AT(0x00094424) { build/asm/data/main_80093824.bin.o(.data); }
    .main_8009BF1C 0x8009BF1C : AT(0x0009CB1C) { FILL(0x00000000); build/asm/main_8009BF1C.s.o(.text); build/asm/main_8009BF1C.s.o(.rodata); build/asm/main_8009BF1C.s.o(.data); }
    .main_8009BF1C_bss (NOLOAD) : { build/asm/main_8009BF1C.s.o(.bss); }
    .main_8009BF60 0x8009BF60 : AT(0x0009CB60) { build/asm/data/main_8009BF60.bin.o(.data); }
    .main_800A3A18 0x800A3A18 : AT(0x000A4618) { FILL(0x00000000); build/asm/main_800A3A18.s.o(.text); build/asm/main_800A3A18.s.o(.rodata); build/asm/main_800A3A18.s.o(.data); }
    .main_800A3A18_bss (NOLOAD) : { build/asm/main_800A3A18.s.o(.bss); }
    .main_800A3ADC 0x800A3ADC : AT(0x000A46DC) { build/asm/data/main_800A3ADC.bin.o(.data); }
    .main_800A6504 0x800A6504 : AT(0x000A7104) { FILL(0x00000000); build/asm/main_800A6504.s.o(.text); build/asm/main_800A6504.s.o(.rodata); build/asm/main_800A6504.s.o(.data); }
    .main_800A6504_bss (NOLOAD) : { build/asm/main_800A6504.s.o(.bss); }
    .main_800A6538 0x800A6538 : AT(0x000A7138) { build/asm/data/main_800A6538.bin.o(.data); }
    .main_800A9F58 0x800A9F58 : AT(0x000AAB58) { FILL(0x00000000); build/asm/main_800A9F58.s.o(.text); build/asm/main_800A9F58.s.o(.rodata); build/asm/main_800A9F58.s.o(.data); }
    .main_800A9F58_bss (NOLOAD) : { build/asm/main_800A9F58.s.o(.bss); }
    .main_800A9F68 0x800A9F68 : AT(0x000AAB68) { build/asm/data/main_800A9F68.bin.o(.data); }
    .main_800AB0F4 0x800AB0F4 : AT(0x000ABCF4) { FILL(0x00000000); build/asm/main_800AB0F4.s.o(.text); build/asm/main_800AB0F4.s.o(.rodata); build/asm/main_800AB0F4.s.o(.data); }
    .main_800AB0F4_bss (NOLOAD) : { build/asm/main_800AB0F4.s.o(.bss); }
    .main_800AB150 0x800AB150 : AT(0x000ABD50) { build/asm/data/main_800AB150.bin.o(.data); }
    .main_800ABC84 0x800ABC84 : AT(0x000AC884) { FILL(0x00000000); build/asm/main_800ABC84.s.o(.text); build/asm/main_800ABC84.s.o(.rodata); build/asm/main_800ABC84.s.o(.data); }
    .main_800ABC84_bss (NOLOAD) : { build/asm/main_800ABC84.s.o(.bss); }
    .main_800ABCB0 0x800ABCB0 : AT(0x000AC8B0) { build/asm/data/main_800ABCB0.bin.o(.data); }
    .main_800AD45C 0x800AD45C : AT(0x000AE05C) { FILL(0x00000000); build/asm/main_800AD45C.s.o(.text); build/asm/main_800AD45C.s.o(.rodata); build/asm/main_800AD45C.s.o(.data); }
    .main_800AD45C_bss (NOLOAD) : { build/asm/main_800AD45C.s.o(.bss); }
    .main_800AD470 0x800AD470 : AT(0x000AE070) { build/asm/data/main_800AD470.bin.o(.data); }
    .main_800B31FC 0x800B31FC : AT(0x000B3DFC) { FILL(0x00000000); build/asm/main_800B31FC.s.o(.text); build/asm/main_800B31FC.s.o(.rodata); build/asm/main_800B31FC.s.o(.data); }
    .main_800B31FC_bss (NOLOAD) : { build/asm/main_800B31FC.s.o(.bss); }
    .main_800B3268 0x800B3268 : AT(0x000B3E68) { build/asm/data/main_800B3268.bin.o(.data); }
    .main_800B8BF4 0x800B8BF4 : AT(0x000B97F4) { FILL(0x00000000); build/asm/main_800B8BF4.s.o(.text); build/asm/main_800B8BF4.s.o(.rodata); build/asm/main_800B8BF4.s.o(.data); }
    .main_800B8BF4_bss (NOLOAD) : { build/asm/main_800B8BF4.s.o(.bss); }
    .main_800B8C00 0x800B8C00 : AT(0x000B9800) { build/asm/data/main_800B8C00.bin.o(.data); }
    .main_800BA0A8 0x800BA0A8 : AT(0x000BACA8) { FILL(0x00000000); build/asm/main_800BA0A8.s.o(.text); build/asm/main_800BA0A8.s.o(.rodata); build/asm/main_800BA0A8.s.o(.data); }
    .main_800BA0A8_bss (NOLOAD) : { build/asm/main_800BA0A8.s.o(.bss); }
    .main_800BA0B0 0x800BA0B0 : AT(0x000BACB0) { build/asm/data/main_800BA0B0.bin.o(.data); }
    .main_800BA8B0 0x800BA8B0 : AT(0x000BB4B0) { FILL(0x00000000); build/asm/main_800BA8B0.s.o(.text); build/asm/main_800BA8B0.s.o(.rodata); build/asm/main_800BA8B0.s.o(.data); }
    .main_800BA8B0_bss (NOLOAD) : { build/asm/main_800BA8B0.s.o(.bss); }
    .main_800BA988 0x800BA988 : AT(0x000BB588) { build/asm/data/main_800BA988.bin.o(.data); }
    .main_800BA9D4 0x800BA9D4 : AT(0x000BB5D4) { FILL(0x00000000); build/asm/main_800BA9D4.s.o(.text); build/asm/main_800BA9D4.s.o(.rodata); build/asm/main_800BA9D4.s.o(.data); }
    .main_800BA9D4_bss (NOLOAD) : { build/asm/main_800BA9D4.s.o(.bss); }
    .main_800BA9F8 0x800BA9F8 : AT(0x000BB5F8) { build/asm/data/main_800BA9F8.bin.o(.data); }
    .main_800BAE0C 0x800BAE0C : AT(0x000BBA0C) { FILL(0x00000000); build/asm/main_800BAE0C.s.o(.text); build/asm/main_800BAE0C.s.o(.rodata); build/asm/main_800BAE0C.s.o(.data); }
    .main_800BAE0C_bss (NOLOAD) : { build/asm/main_800BAE0C.s.o(.bss); }
    .main_800BAEFC 0x800BAEFC : AT(0x000BBAFC) { build/asm/data/main_800BAEFC.bin.o(.data); }
    .main_800BB528 0x800BB528 : AT(0x000BC128) { FILL(0x00000000); build/asm/main_800BB528.s.o(.text); build/asm/main_800BB528.s.o(.rodata); build/asm/main_800BB528.s.o(.data); }
    .main_800BB528_bss (NOLOAD) : { build/asm/main_800BB528.s.o(.bss); }
    .main_800BB548 0x800BB548 : AT(0x000BC148) { build/asm/data/main_800BB548.bin.o(.data); }
    .main_800BB9C4 0x800BB9C4 : AT(0x000BC5C4) { FILL(0x00000000); build/asm/main_800BB9C4.s.o(.text); build/asm/main_800BB9C4.s.o(.rodata); build/asm/main_800BB9C4.s.o(.data); }
    .main_800BB9C4_bss (NOLOAD) : { build/asm/main_800BB9C4.s.o(.bss); }
    .main_800BBA1C 0x800BBA1C : AT(0x000BC61C) { build/asm/data/main_800BBA1C.bin.o(.data); }
    .main_800BBBB8 0x800BBBB8 : AT(0x000BC7B8) { FILL(0x00000000); build/asm/main_800BBBB8.s.o(.text); build/asm/main_800BBBB8.s.o(.rodata); build/asm/main_800BBBB8.s.o(.data); }
    .main_800BBBB8_bss (NOLOAD) : { build/asm/main_800BBBB8.s.o(.bss); }
    .main_800BBBD0 0x800BBBD0 : AT(0x000BC7D0) { build/asm/data/main_800BBBD0.bin.o(.data); }
    .main_800BF050 0x800BF050 : AT(0x000BFC50) { FILL(0x00000000); build/asm/main_800BF050.s.o(.text); build/asm/main_800BF050.s.o(.rodata); build/asm/main_800BF050.s.o(.data); }
    .main_800BF050_bss (NOLOAD) : { build/asm/main_800BF050.s.o(.bss); }
    .main_800BF074 0x800BF074 : AT(0x000BFC74) { build/asm/data/main_800BF074.bin.o(.data); }
    .main_800C07C8 0x800C07C8 : AT(0x000C13C8) { FILL(0x00000000); build/asm/main_800C07C8.s.o(.text); build/asm/main_800C07C8.s.o(.rodata); build/asm/main_800C07C8.s.o(.data); }
    .main_800C07C8_bss (NOLOAD) : { build/asm/main_800C07C8.s.o(.bss); }
    .main_800C07E4 0x800C07E4 : AT(0x000C13E4) { build/asm/data/main_800C07E4.bin.o(.data); }
    .main_800C96FC 0x800C96FC : AT(0x000CA2FC) { FILL(0x00000000); build/asm/main_800C96FC.s.o(.text); build/asm/main_800C96FC.s.o(.rodata); build/asm/main_800C96FC.s.o(.data); }
    .main_800C96FC_bss (NOLOAD) : { build/asm/main_800C96FC.s.o(.bss); }
    .main_800C9704 0x800C9704 : AT(0x000CA304) { build/asm/data/main_800C9704.bin.o(.data); }
    .main_800CADC4 0x800CADC4 : AT(0x000CB9C4) { FILL(0x00000000); build/asm/main_800CADC4.s.o(.text); build/asm/main_800CADC4.s.o(.rodata); build/asm/main_800CADC4.s.o(.data); }
    .main_800CADC4_bss (NOLOAD) : { build/asm/main_800CADC4.s.o(.bss); }
    .main_800CADCC 0x800CADCC : AT(0x000CB9CC) { build/asm/data/main_800CADCC.bin.o(.data); }
    .main_800CF0C4 0x800CF0C4 : AT(0x000CFCC4) { FILL(0x00000000); build/asm/main_800CF0C4.s.o(.text); build/asm/main_800CF0C4.s.o(.rodata); build/asm/main_800CF0C4.s.o(.data); }
    .main_800CF0C4_bss (NOLOAD) : { build/asm/main_800CF0C4.s.o(.bss); }
    .main_800CF0E4 0x800CF0E4 : AT(0x000CFCE4) { build/asm/data/main_800CF0E4.bin.o(.data); }
    .main_800D27AC 0x800D27AC : AT(0x000D33AC) { FILL(0x00000000); build/asm/main_800D27AC.s.o(.text); build/asm/main_800D27AC.s.o(.rodata); build/asm/main_800D27AC.s.o(.data); }
    .main_800D27AC_bss (NOLOAD) : { build/asm/main_800D27AC.s.o(.bss); }
    .main_800D27C4 0x800D27C4 : AT(0x000D33C4) { build/asm/data/main_800D27C4.bin.o(.data); }
    .main_800D6C24 0x800D6C24 : AT(0x000D7824) { FILL(0x00000000); build/asm/main_800D6C24.s.o(.text); build/asm/main_800D6C24.s.o(.rodata); build/asm/main_800D6C24.s.o(.data); }
    .main_800D6C24_bss (NOLOAD) : { build/asm/main_800D6C24.s.o(.bss); }
    .main_800D6C3C 0x800D6C3C : AT(0x000D783C) { build/asm/data/main_800D6C3C.bin.o(.data); }
    .main_800E0218 0x800E0218 : AT(0x000E0E18) { build/asm/data/main_800E0218.bin.o(.data); }
    .main_800E5AB8 0x800E5AB8 : AT(0x000E66B8) { FILL(0x00000000); build/asm/main_800E5AB8.s.o(.text); build/asm/main_800E5AB8.s.o(.rodata); build/asm/main_800E5AB8.s.o(.data); }
    .main_800E5AB8_bss (NOLOAD) : { build/asm/main_800E5AB8.s.o(.bss); }
    .main_800E5AE4 0x800E5AE4 : AT(0x000E66E4) { build/asm/data/main_800E5AE4.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
