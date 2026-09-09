SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80009CC8 0x80009CC8 : AT(0x0000A8C8) { FILL(0x00000000); build/asm/main_80009CC8.s.o(.text); build/asm/main_80009CC8.s.o(.rodata); build/asm/main_80009CC8.s.o(.data); }
    .main_80009CC8_bss (NOLOAD) : { build/asm/main_80009CC8.s.o(.bss); }
    .main_8000AE40 0x8000AE40 : AT(0x0000BA40) { FILL(0x00000000); build/asm/main_8000AE40.s.o(.text); build/asm/main_8000AE40.s.o(.rodata); build/asm/main_8000AE40.s.o(.data); }
    .main_8000AE40_bss (NOLOAD) : { build/asm/main_8000AE40.s.o(.bss); }
    .main_8000B3C0 0x8000B3C0 : AT(0x0000BFC0) { FILL(0x00000000); build/asm/main_8000B3C0.s.o(.text); build/asm/main_8000B3C0.s.o(.rodata); build/asm/main_8000B3C0.s.o(.data); }
    .main_8000B3C0_bss (NOLOAD) : { build/asm/main_8000B3C0.s.o(.bss); }
    .main_8000BD80 0x8000BD80 : AT(0x0000C980) { FILL(0x00000000); build/asm/main_8000BD80.s.o(.text); build/asm/main_8000BD80.s.o(.rodata); build/asm/main_8000BD80.s.o(.data); }
    .main_8000BD80_bss (NOLOAD) : { build/asm/main_8000BD80.s.o(.bss); }
    .main_8000CE7C 0x8000CE7C : AT(0x0000DA7C) { FILL(0x00000000); build/asm/main_8000CE7C.s.o(.text); build/asm/main_8000CE7C.s.o(.rodata); build/asm/main_8000CE7C.s.o(.data); }
    .main_8000CE7C_bss (NOLOAD) : { build/asm/main_8000CE7C.s.o(.bss); }
    .main_8000E100 0x8000E100 : AT(0x0000ED00) { FILL(0x00000000); build/asm/main_8000E100.s.o(.text); build/asm/main_8000E100.s.o(.rodata); build/asm/main_8000E100.s.o(.data); }
    .main_8000E100_bss (NOLOAD) : { build/asm/main_8000E100.s.o(.bss); }
    .main_8000E244 0x8000E244 : AT(0x0000EE44) { build/asm/data/main_8000E244.bin.o(.data); }
    .main_8000E610 0x8000E610 : AT(0x0000F210) { FILL(0x00000000); build/asm/main_8000E610.s.o(.text); build/asm/main_8000E610.s.o(.rodata); build/asm/main_8000E610.s.o(.data); }
    .main_8000E610_bss (NOLOAD) : { build/asm/main_8000E610.s.o(.bss); }
    .main_80012D70 0x80012D70 : AT(0x00013970) { FILL(0x00000000); build/asm/main_80012D70.s.o(.text); build/asm/main_80012D70.s.o(.rodata); build/asm/main_80012D70.s.o(.data); }
    .main_80012D70_bss (NOLOAD) : { build/asm/main_80012D70.s.o(.bss); }
    .main_8001CD68 0x8001CD68 : AT(0x0001D968) { build/asm/data/main_8001CD68.bin.o(.data); }
    .main_8001CE80 0x8001CE80 : AT(0x0001DA80) { FILL(0x00000000); build/asm/main_8001CE80.s.o(.text); build/asm/main_8001CE80.s.o(.rodata); build/asm/main_8001CE80.s.o(.data); }
    .main_8001CE80_bss (NOLOAD) : { build/asm/main_8001CE80.s.o(.bss); }
    .main_80022BA8 0x80022BA8 : AT(0x000237A8) { FILL(0x00000000); build/asm/main_80022BA8.s.o(.text); build/asm/main_80022BA8.s.o(.rodata); build/asm/main_80022BA8.s.o(.data); }
    .main_80022BA8_bss (NOLOAD) : { build/asm/main_80022BA8.s.o(.bss); }
    .main_80022C00 0x80022C00 : AT(0x00023800) { FILL(0x00000000); build/asm/main_80022C00.s.o(.text); build/asm/main_80022C00.s.o(.rodata); build/asm/main_80022C00.s.o(.data); }
    .main_80022C00_bss (NOLOAD) : { build/asm/main_80022C00.s.o(.bss); }
    .main_8002A504 0x8002A504 : AT(0x0002B104) { build/asm/data/main_8002A504.bin.o(.data); }
    .main_8002A540 0x8002A540 : AT(0x0002B140) { FILL(0x00000000); build/asm/main_8002A540.s.o(.text); build/asm/main_8002A540.s.o(.rodata); build/asm/main_8002A540.s.o(.data); }
    .main_8002A540_bss (NOLOAD) : { build/asm/main_8002A540.s.o(.bss); }
    .main_8002DD14 0x8002DD14 : AT(0x0002E914) { build/asm/data/main_8002DD14.bin.o(.data); }
    .main_8002DE80 0x8002DE80 : AT(0x0002EA80) { FILL(0x00000000); build/asm/main_8002DE80.s.o(.text); build/asm/main_8002DE80.s.o(.rodata); build/asm/main_8002DE80.s.o(.data); }
    .main_8002DE80_bss (NOLOAD) : { build/asm/main_8002DE80.s.o(.bss); }
    .main_80032800 0x80032800 : AT(0x00033400) { build/asm/data/main_80032800.bin.o(.data); }
    .main_800351BC 0x800351BC : AT(0x00035DBC) { build/asm/data/main_800351BC.bin.o(.data); }
    .main_80035D64 0x80035D64 : AT(0x00036964) { FILL(0x00000000); build/asm/main_80035D64.s.o(.text); build/asm/main_80035D64.s.o(.rodata); build/asm/main_80035D64.s.o(.data); }
    .main_80035D64_bss (NOLOAD) : { build/asm/main_80035D64.s.o(.bss); }
    .main_80036000 0x80036000 : AT(0x00036C00) { build/asm/data/main_80036000.bin.o(.data); }
    .main_800376DC 0x800376DC : AT(0x000382DC) { FILL(0x00000000); build/asm/main_800376DC.s.o(.text); build/asm/main_800376DC.s.o(.rodata); build/asm/main_800376DC.s.o(.data); }
    .main_800376DC_bss (NOLOAD) : { build/asm/main_800376DC.s.o(.bss); }
    .main_8003B3C4 0x8003B3C4 : AT(0x0003BFC4) { FILL(0x00000000); build/asm/main_8003B3C4.s.o(.text); build/asm/main_8003B3C4.s.o(.rodata); build/asm/main_8003B3C4.s.o(.data); }
    .main_8003B3C4_bss (NOLOAD) : { build/asm/main_8003B3C4.s.o(.bss); }
    .main_8003BD00 0x8003BD00 : AT(0x0003C900) { FILL(0x00000000); build/asm/main_8003BD00.s.o(.text); build/asm/main_8003BD00.s.o(.rodata); build/asm/main_8003BD00.s.o(.data); }
    .main_8003BD00_bss (NOLOAD) : { build/asm/main_8003BD00.s.o(.bss); }
    .main_8003BD80 0x8003BD80 : AT(0x0003C980) { FILL(0x00000000); build/asm/main_8003BD80.s.o(.text); build/asm/main_8003BD80.s.o(.rodata); build/asm/main_8003BD80.s.o(.data); }
    .main_8003BD80_bss (NOLOAD) : { build/asm/main_8003BD80.s.o(.bss); }
    .main_8003C500 0x8003C500 : AT(0x0003D100) { FILL(0x00000000); build/asm/main_8003C500.s.o(.text); build/asm/main_8003C500.s.o(.rodata); build/asm/main_8003C500.s.o(.data); }
    .main_8003C500_bss (NOLOAD) : { build/asm/main_8003C500.s.o(.bss); }
    .main_8003CA00 0x8003CA00 : AT(0x0003D600) { FILL(0x00000000); build/asm/main_8003CA00.s.o(.text); build/asm/main_8003CA00.s.o(.rodata); build/asm/main_8003CA00.s.o(.data); }
    .main_8003CA00_bss (NOLOAD) : { build/asm/main_8003CA00.s.o(.bss); }
    .main_80046440 0x80046440 : AT(0x00047040) { FILL(0x00000000); build/asm/main_80046440.s.o(.text); build/asm/main_80046440.s.o(.rodata); build/asm/main_80046440.s.o(.data); }
    .main_80046440_bss (NOLOAD) : { build/asm/main_80046440.s.o(.bss); }
    .main_80046780 0x80046780 : AT(0x00047380) { FILL(0x00000000); build/asm/main_80046780.s.o(.text); build/asm/main_80046780.s.o(.rodata); build/asm/main_80046780.s.o(.data); }
    .main_80046780_bss (NOLOAD) : { build/asm/main_80046780.s.o(.bss); }
    .main_80046840 0x80046840 : AT(0x00047440) { FILL(0x00000000); build/asm/main_80046840.s.o(.text); build/asm/main_80046840.s.o(.rodata); build/asm/main_80046840.s.o(.data); }
    .main_80046840_bss (NOLOAD) : { build/asm/main_80046840.s.o(.bss); }
    .main_800469C0 0x800469C0 : AT(0x000475C0) { FILL(0x00000000); build/asm/main_800469C0.s.o(.text); build/asm/main_800469C0.s.o(.rodata); build/asm/main_800469C0.s.o(.data); }
    .main_800469C0_bss (NOLOAD) : { build/asm/main_800469C0.s.o(.bss); }
    .main_800469D0 0x800469D0 : AT(0x000475D0) { build/asm/data/main_800469D0.bin.o(.data); }
    .main_80046A00 0x80046A00 : AT(0x00047600) { FILL(0x00000000); build/asm/main_80046A00.s.o(.text); build/asm/main_80046A00.s.o(.rodata); build/asm/main_80046A00.s.o(.data); }
    .main_80046A00_bss (NOLOAD) : { build/asm/main_80046A00.s.o(.bss); }
    .main_80046DC0 0x80046DC0 : AT(0x000479C0) { FILL(0x00000000); build/asm/main_80046DC0.s.o(.text); build/asm/main_80046DC0.s.o(.rodata); build/asm/main_80046DC0.s.o(.data); }
    .main_80046DC0_bss (NOLOAD) : { build/asm/main_80046DC0.s.o(.bss); }
    .main_80047040 0x80047040 : AT(0x00047C40) { FILL(0x00000000); build/asm/main_80047040.s.o(.text); build/asm/main_80047040.s.o(.rodata); build/asm/main_80047040.s.o(.data); }
    .main_80047040_bss (NOLOAD) : { build/asm/main_80047040.s.o(.bss); }
    .main_80047280 0x80047280 : AT(0x00047E80) { FILL(0x00000000); build/asm/main_80047280.s.o(.text); build/asm/main_80047280.s.o(.rodata); build/asm/main_80047280.s.o(.data); }
    .main_80047280_bss (NOLOAD) : { build/asm/main_80047280.s.o(.bss); }
    .main_80047680 0x80047680 : AT(0x00048280) { FILL(0x00000000); build/asm/main_80047680.s.o(.text); build/asm/main_80047680.s.o(.rodata); build/asm/main_80047680.s.o(.data); }
    .main_80047680_bss (NOLOAD) : { build/asm/main_80047680.s.o(.bss); }
    .main_80047880 0x80047880 : AT(0x00048480) { FILL(0x00000000); build/asm/main_80047880.s.o(.text); build/asm/main_80047880.s.o(.rodata); build/asm/main_80047880.s.o(.data); }
    .main_80047880_bss (NOLOAD) : { build/asm/main_80047880.s.o(.bss); }
    .main_80047F30 0x80047F30 : AT(0x00048B30) { FILL(0x00000000); build/asm/main_80047F30.s.o(.text); build/asm/main_80047F30.s.o(.rodata); build/asm/main_80047F30.s.o(.data); }
    .main_80047F30_bss (NOLOAD) : { build/asm/main_80047F30.s.o(.bss); }
    .main_8004B0A0 0x8004B0A0 : AT(0x0004BCA0) { FILL(0x00000000); build/asm/main_8004B0A0.s.o(.text); build/asm/main_8004B0A0.s.o(.rodata); build/asm/main_8004B0A0.s.o(.data); }
    .main_8004B0A0_bss (NOLOAD) : { build/asm/main_8004B0A0.s.o(.bss); }
    .main_8004CF80 0x8004CF80 : AT(0x0004DB80) { FILL(0x00000000); build/asm/main_8004CF80.s.o(.text); build/asm/main_8004CF80.s.o(.rodata); build/asm/main_8004CF80.s.o(.data); }
    .main_8004CF80_bss (NOLOAD) : { build/asm/main_8004CF80.s.o(.bss); }
    .main_8004D240 0x8004D240 : AT(0x0004DE40) { FILL(0x00000000); build/asm/main_8004D240.s.o(.text); build/asm/main_8004D240.s.o(.rodata); build/asm/main_8004D240.s.o(.data); }
    .main_8004D240_bss (NOLOAD) : { build/asm/main_8004D240.s.o(.bss); }
    .main_8004DE0C 0x8004DE0C : AT(0x0004EA0C) { FILL(0x00000000); build/asm/main_8004DE0C.s.o(.text); build/asm/main_8004DE0C.s.o(.rodata); build/asm/main_8004DE0C.s.o(.data); }
    .main_8004DE0C_bss (NOLOAD) : { build/asm/main_8004DE0C.s.o(.bss); }
    .main_8004E3C0 0x8004E3C0 : AT(0x0004EFC0) { FILL(0x00000000); build/asm/main_8004E3C0.s.o(.text); build/asm/main_8004E3C0.s.o(.rodata); build/asm/main_8004E3C0.s.o(.data); }
    .main_8004E3C0_bss (NOLOAD) : { build/asm/main_8004E3C0.s.o(.bss); }
    .main_8004E440 0x8004E440 : AT(0x0004F040) { build/asm/data/main_8004E440.bin.o(.data); }
    .main_8004E540 0x8004E540 : AT(0x0004F140) { FILL(0x00000000); build/asm/main_8004E540.s.o(.text); build/asm/main_8004E540.s.o(.rodata); build/asm/main_8004E540.s.o(.data); }
    .main_8004E540_bss (NOLOAD) : { build/asm/main_8004E540.s.o(.bss); }
    .main_8004EC40 0x8004EC40 : AT(0x0004F840) { FILL(0x00000000); build/asm/main_8004EC40.s.o(.text); build/asm/main_8004EC40.s.o(.rodata); build/asm/main_8004EC40.s.o(.data); }
    .main_8004EC40_bss (NOLOAD) : { build/asm/main_8004EC40.s.o(.bss); }
    .main_8004F340 0x8004F340 : AT(0x0004FF40) { FILL(0x00000000); build/asm/main_8004F340.s.o(.text); build/asm/main_8004F340.s.o(.rodata); build/asm/main_8004F340.s.o(.data); }
    .main_8004F340_bss (NOLOAD) : { build/asm/main_8004F340.s.o(.bss); }
    .main_8004F394 0x8004F394 : AT(0x0004FF94) { FILL(0x00000000); build/asm/main_8004F394.s.o(.text); build/asm/main_8004F394.s.o(.rodata); build/asm/main_8004F394.s.o(.data); }
    .main_8004F394_bss (NOLOAD) : { build/asm/main_8004F394.s.o(.bss); }
    .main_8004F424 0x8004F424 : AT(0x00050024) { FILL(0x00000000); build/asm/main_8004F424.s.o(.text); build/asm/main_8004F424.s.o(.rodata); build/asm/main_8004F424.s.o(.data); }
    .main_8004F424_bss (NOLOAD) : { build/asm/main_8004F424.s.o(.bss); }
    .main_800502CC 0x800502CC : AT(0x00050ECC) { build/asm/data/main_800502CC.bin.o(.data); }
    .main_80050400 0x80050400 : AT(0x00051000) { FILL(0x00000000); build/asm/main_80050400.s.o(.text); build/asm/main_80050400.s.o(.rodata); build/asm/main_80050400.s.o(.data); }
    .main_80050400_bss (NOLOAD) : { build/asm/main_80050400.s.o(.bss); }
    .main_80050500 0x80050500 : AT(0x00051100) { build/asm/data/main_80050500.bin.o(.data); }
    .main_800505C0 0x800505C0 : AT(0x000511C0) { FILL(0x00000000); build/asm/main_800505C0.s.o(.text); build/asm/main_800505C0.s.o(.rodata); build/asm/main_800505C0.s.o(.data); }
    .main_800505C0_bss (NOLOAD) : { build/asm/main_800505C0.s.o(.bss); }
    .main_80051914 0x80051914 : AT(0x00052514) { FILL(0x00000000); build/asm/main_80051914.s.o(.text); build/asm/main_80051914.s.o(.rodata); build/asm/main_80051914.s.o(.data); }
    .main_80051914_bss (NOLOAD) : { build/asm/main_80051914.s.o(.bss); }
    .main_80052168 0x80052168 : AT(0x00052D68) { build/asm/data/main_80052168.bin.o(.data); }
    .main_8005306C 0x8005306C : AT(0x00053C6C) { build/asm/data/main_8005306C.bin.o(.data); }
    .main_80054974 0x80054974 : AT(0x00055574) { FILL(0x00000000); build/asm/main_80054974.s.o(.text); build/asm/main_80054974.s.o(.rodata); build/asm/main_80054974.s.o(.data); }
    .main_80054974_bss (NOLOAD) : { build/asm/main_80054974.s.o(.bss); }
    .main_800549AC 0x800549AC : AT(0x000555AC) { build/asm/data/main_800549AC.bin.o(.data); }
    .main_80054C68 0x80054C68 : AT(0x00055868) { FILL(0x00000000); build/asm/main_80054C68.s.o(.text); build/asm/main_80054C68.s.o(.rodata); build/asm/main_80054C68.s.o(.data); }
    .main_80054C68_bss (NOLOAD) : { build/asm/main_80054C68.s.o(.bss); }
    .main_80054CF8 0x80054CF8 : AT(0x000558F8) { build/asm/data/main_80054CF8.bin.o(.data); }
    .main_80054E24 0x80054E24 : AT(0x00055A24) { FILL(0x00000000); build/asm/main_80054E24.s.o(.text); build/asm/main_80054E24.s.o(.rodata); build/asm/main_80054E24.s.o(.data); }
    .main_80054E24_bss (NOLOAD) : { build/asm/main_80054E24.s.o(.bss); }
    .main_80054F1C 0x80054F1C : AT(0x00055B1C) { build/asm/data/main_80054F1C.bin.o(.data); }
    .main_80054FC0 0x80054FC0 : AT(0x00055BC0) { FILL(0x00000000); build/asm/main_80054FC0.s.o(.text); build/asm/main_80054FC0.s.o(.rodata); build/asm/main_80054FC0.s.o(.data); }
    .main_80054FC0_bss (NOLOAD) : { build/asm/main_80054FC0.s.o(.bss); }
    .main_80055018 0x80055018 : AT(0x00055C18) { build/asm/data/main_80055018.bin.o(.data); }
    .main_80055074 0x80055074 : AT(0x00055C74) { FILL(0x00000000); build/asm/main_80055074.s.o(.text); build/asm/main_80055074.s.o(.rodata); build/asm/main_80055074.s.o(.data); }
    .main_80055074_bss (NOLOAD) : { build/asm/main_80055074.s.o(.bss); }
    .main_80055124 0x80055124 : AT(0x00055D24) { FILL(0x00000000); build/asm/main_80055124.s.o(.text); build/asm/main_80055124.s.o(.rodata); build/asm/main_80055124.s.o(.data); }
    .main_80055124_bss (NOLOAD) : { build/asm/main_80055124.s.o(.bss); }
    .main_80055184 0x80055184 : AT(0x00055D84) { build/asm/data/main_80055184.bin.o(.data); }
    .main_800551C0 0x800551C0 : AT(0x00055DC0) { FILL(0x00000000); build/asm/main_800551C0.s.o(.text); build/asm/main_800551C0.s.o(.rodata); build/asm/main_800551C0.s.o(.data); }
    .main_800551C0_bss (NOLOAD) : { build/asm/main_800551C0.s.o(.bss); }
    .main_8005547C 0x8005547C : AT(0x0005607C) { build/asm/data/main_8005547C.bin.o(.data); }
    .main_80055F14 0x80055F14 : AT(0x00056B14) { FILL(0x00000000); build/asm/main_80055F14.s.o(.text); build/asm/main_80055F14.s.o(.rodata); build/asm/main_80055F14.s.o(.data); }
    .main_80055F14_bss (NOLOAD) : { build/asm/main_80055F14.s.o(.bss); }
    .main_800565F4 0x800565F4 : AT(0x000571F4) { build/asm/data/main_800565F4.bin.o(.data); }
    .main_80056A50 0x80056A50 : AT(0x00057650) { FILL(0x00000000); build/asm/main_80056A50.s.o(.text); build/asm/main_80056A50.s.o(.rodata); build/asm/main_80056A50.s.o(.data); }
    .main_80056A50_bss (NOLOAD) : { build/asm/main_80056A50.s.o(.bss); }
    .main_80056C30 0x80056C30 : AT(0x00057830) { build/asm/data/main_80056C30.bin.o(.data); }
    .main_800596C4 0x800596C4 : AT(0x0005A2C4) { FILL(0x00000000); build/asm/main_800596C4.s.o(.text); build/asm/main_800596C4.s.o(.rodata); build/asm/main_800596C4.s.o(.data); }
    .main_800596C4_bss (NOLOAD) : { build/asm/main_800596C4.s.o(.bss); }
    .main_800598F0 0x800598F0 : AT(0x0005A4F0) { build/asm/data/main_800598F0.bin.o(.data); }
    .main_80059AE4 0x80059AE4 : AT(0x0005A6E4) { FILL(0x00000000); build/asm/main_80059AE4.s.o(.text); build/asm/main_80059AE4.s.o(.rodata); build/asm/main_80059AE4.s.o(.data); }
    .main_80059AE4_bss (NOLOAD) : { build/asm/main_80059AE4.s.o(.bss); }
    .main_80059D6C 0x80059D6C : AT(0x0005A96C) { build/asm/data/main_80059D6C.bin.o(.data); }
    .main_80059DF0 0x80059DF0 : AT(0x0005A9F0) { FILL(0x00000000); build/asm/main_80059DF0.s.o(.text); build/asm/main_80059DF0.s.o(.rodata); build/asm/main_80059DF0.s.o(.data); }
    .main_80059DF0_bss (NOLOAD) : { build/asm/main_80059DF0.s.o(.bss); }
    .main_8005A2C0 0x8005A2C0 : AT(0x0005AEC0) { build/asm/data/main_8005A2C0.bin.o(.data); }
    .main_8005AA64 0x8005AA64 : AT(0x0005B664) { FILL(0x00000000); build/asm/main_8005AA64.s.o(.text); build/asm/main_8005AA64.s.o(.rodata); build/asm/main_8005AA64.s.o(.data); }
    .main_8005AA64_bss (NOLOAD) : { build/asm/main_8005AA64.s.o(.bss); }
    .main_8005AAC0 0x8005AAC0 : AT(0x0005B6C0) { build/asm/data/main_8005AAC0.bin.o(.data); }
    .main_8005AF10 0x8005AF10 : AT(0x0005BB10) { FILL(0x00000000); build/asm/main_8005AF10.s.o(.text); build/asm/main_8005AF10.s.o(.rodata); build/asm/main_8005AF10.s.o(.data); }
    .main_8005AF10_bss (NOLOAD) : { build/asm/main_8005AF10.s.o(.bss); }
    .main_8005AF8C 0x8005AF8C : AT(0x0005BB8C) { build/asm/data/main_8005AF8C.bin.o(.data); }
    .main_8005B2C0 0x8005B2C0 : AT(0x0005BEC0) { FILL(0x00000000); build/asm/main_8005B2C0.s.o(.text); build/asm/main_8005B2C0.s.o(.rodata); build/asm/main_8005B2C0.s.o(.data); }
    .main_8005B2C0_bss (NOLOAD) : { build/asm/main_8005B2C0.s.o(.bss); }
    .main_8005B78C 0x8005B78C : AT(0x0005C38C) { build/asm/data/main_8005B78C.bin.o(.data); }
    .main_8005BAC0 0x8005BAC0 : AT(0x0005C6C0) { FILL(0x00000000); build/asm/main_8005BAC0.s.o(.text); build/asm/main_8005BAC0.s.o(.rodata); build/asm/main_8005BAC0.s.o(.data); }
    .main_8005BAC0_bss (NOLOAD) : { build/asm/main_8005BAC0.s.o(.bss); }
    .main_8005C2C0 0x8005C2C0 : AT(0x0005CEC0) { build/asm/data/main_8005C2C0.bin.o(.data); }
    .main_8005C510 0x8005C510 : AT(0x0005D110) { FILL(0x00000000); build/asm/main_8005C510.s.o(.text); build/asm/main_8005C510.s.o(.rodata); build/asm/main_8005C510.s.o(.data); }
    .main_8005C510_bss (NOLOAD) : { build/asm/main_8005C510.s.o(.bss); }
    .main_8005C8C4 0x8005C8C4 : AT(0x0005D4C4) { build/asm/data/main_8005C8C4.bin.o(.data); }
    .main_8005CD10 0x8005CD10 : AT(0x0005D910) { build/asm/data/main_8005CD10.bin.o(.data); }
    .main_8005DE38 0x8005DE38 : AT(0x0005EA38) { build/asm/data/main_8005DE38.bin.o(.data); }
    .main_8005E2B0 0x8005E2B0 : AT(0x0005EEB0) { build/asm/data/main_8005E2B0.bin.o(.data); }
    .main_8005E65C 0x8005E65C : AT(0x0005F25C) { FILL(0x00000000); build/asm/main_8005E65C.s.o(.text); build/asm/main_8005E65C.s.o(.rodata); build/asm/main_8005E65C.s.o(.data); }
    .main_8005E65C_bss (NOLOAD) : { build/asm/main_8005E65C.s.o(.bss); }
    .main_8005E664 0x8005E664 : AT(0x0005F264) { build/asm/data/main_8005E664.bin.o(.data); }
    .main_80060134 0x80060134 : AT(0x00060D34) { FILL(0x00000000); build/asm/main_80060134.s.o(.text); build/asm/main_80060134.s.o(.rodata); build/asm/main_80060134.s.o(.data); }
    .main_80060134_bss (NOLOAD) : { build/asm/main_80060134.s.o(.bss); }
    .main_80061210 0x80061210 : AT(0x00061E10) { build/asm/data/main_80061210.bin.o(.data); }
    .main_80061A1C 0x80061A1C : AT(0x0006261C) { FILL(0x00000000); build/asm/main_80061A1C.s.o(.text); build/asm/main_80061A1C.s.o(.rodata); build/asm/main_80061A1C.s.o(.data); }
    .main_80061A1C_bss (NOLOAD) : { build/asm/main_80061A1C.s.o(.bss); }
    .main_80061C9C 0x80061C9C : AT(0x0006289C) { build/asm/data/main_80061C9C.bin.o(.data); }
    .main_8006305C 0x8006305C : AT(0x00063C5C) { build/asm/data/main_8006305C.bin.o(.data); }
    .main_80064FB0 0x80064FB0 : AT(0x00065BB0) { FILL(0x00000000); build/asm/main_80064FB0.s.o(.text); build/asm/main_80064FB0.s.o(.rodata); build/asm/main_80064FB0.s.o(.data); }
    .main_80064FB0_bss (NOLOAD) : { build/asm/main_80064FB0.s.o(.bss); }
    .main_80064FC0 0x80064FC0 : AT(0x00065BC0) { build/asm/data/main_80064FC0.bin.o(.data); }
    .main_800653B4 0x800653B4 : AT(0x00065FB4) { FILL(0x00000000); build/asm/main_800653B4.s.o(.text); build/asm/main_800653B4.s.o(.rodata); build/asm/main_800653B4.s.o(.data); }
    .main_800653B4_bss (NOLOAD) : { build/asm/main_800653B4.s.o(.bss); }
    .main_80065514 0x80065514 : AT(0x00066114) { build/asm/data/main_80065514.bin.o(.data); }
    .main_800657CC 0x800657CC : AT(0x000663CC) { FILL(0x00000000); build/asm/main_800657CC.s.o(.text); build/asm/main_800657CC.s.o(.rodata); build/asm/main_800657CC.s.o(.data); }
    .main_800657CC_bss (NOLOAD) : { build/asm/main_800657CC.s.o(.bss); }
    .main_800658FC 0x800658FC : AT(0x000664FC) { build/asm/data/main_800658FC.bin.o(.data); }
    .main_80066C90 0x80066C90 : AT(0x00067890) { FILL(0x00000000); build/asm/main_80066C90.s.o(.text); build/asm/main_80066C90.s.o(.rodata); build/asm/main_80066C90.s.o(.data); }
    .main_80066C90_bss (NOLOAD) : { build/asm/main_80066C90.s.o(.bss); }
    .main_80067638 0x80067638 : AT(0x00068238) { build/asm/data/main_80067638.bin.o(.data); }
    .main_80068064 0x80068064 : AT(0x00068C64) { build/asm/data/main_80068064.bin.o(.data); }
    .main_8006A07C 0x8006A07C : AT(0x0006AC7C) { FILL(0x00000000); build/asm/main_8006A07C.s.o(.text); build/asm/main_8006A07C.s.o(.rodata); build/asm/main_8006A07C.s.o(.data); }
    .main_8006A07C_bss (NOLOAD) : { build/asm/main_8006A07C.s.o(.bss); }
    .main_8006A948 0x8006A948 : AT(0x0006B548) { FILL(0x00000000); build/asm/main_8006A948.s.o(.text); build/asm/main_8006A948.s.o(.rodata); build/asm/main_8006A948.s.o(.data); }
    .main_8006A948_bss (NOLOAD) : { build/asm/main_8006A948.s.o(.bss); }
    .main_8006B534 0x8006B534 : AT(0x0006C134) { FILL(0x00000000); build/asm/main_8006B534.s.o(.text); build/asm/main_8006B534.s.o(.rodata); build/asm/main_8006B534.s.o(.data); }
    .main_8006B534_bss (NOLOAD) : { build/asm/main_8006B534.s.o(.bss); }
    .main_8006B880 0x8006B880 : AT(0x0006C480) { FILL(0x00000000); build/asm/main_8006B880.s.o(.text); build/asm/main_8006B880.s.o(.rodata); build/asm/main_8006B880.s.o(.data); }
    .main_8006B880_bss (NOLOAD) : { build/asm/main_8006B880.s.o(.bss); }
    .main_8006B938 0x8006B938 : AT(0x0006C538) { build/asm/data/main_8006B938.bin.o(.data); }
    .main_8006FE48 0x8006FE48 : AT(0x00070A48) { FILL(0x00000000); build/asm/main_8006FE48.s.o(.text); build/asm/main_8006FE48.s.o(.rodata); build/asm/main_8006FE48.s.o(.data); }
    .main_8006FE48_bss (NOLOAD) : { build/asm/main_8006FE48.s.o(.bss); }
    .main_800733C0 0x800733C0 : AT(0x00073FC0) { build/asm/data/main_800733C0.bin.o(.data); }
    .main_80073660 0x80073660 : AT(0x00074260) { FILL(0x00000000); build/asm/main_80073660.s.o(.text); build/asm/main_80073660.s.o(.rodata); build/asm/main_80073660.s.o(.data); }
    .main_80073660_bss (NOLOAD) : { build/asm/main_80073660.s.o(.bss); }
    .main_80073678 0x80073678 : AT(0x00074278) { build/asm/data/main_80073678.bin.o(.data); }
    .main_80075B8C 0x80075B8C : AT(0x0007678C) { FILL(0x00000000); build/asm/main_80075B8C.s.o(.text); build/asm/main_80075B8C.s.o(.rodata); build/asm/main_80075B8C.s.o(.data); }
    .main_80075B8C_bss (NOLOAD) : { build/asm/main_80075B8C.s.o(.bss); }
    .main_80075B90 0x80075B90 : AT(0x00076790) { build/asm/data/main_80075B90.bin.o(.data); }
    .main_800776DC 0x800776DC : AT(0x000782DC) { FILL(0x00000000); build/asm/main_800776DC.s.o(.text); build/asm/main_800776DC.s.o(.rodata); build/asm/main_800776DC.s.o(.data); }
    .main_800776DC_bss (NOLOAD) : { build/asm/main_800776DC.s.o(.bss); }
    .main_800778AC 0x800778AC : AT(0x000784AC) { build/asm/data/main_800778AC.bin.o(.data); }
    .main_80078C74 0x80078C74 : AT(0x00079874) { FILL(0x00000000); build/asm/main_80078C74.s.o(.text); build/asm/main_80078C74.s.o(.rodata); build/asm/main_80078C74.s.o(.data); }
    .main_80078C74_bss (NOLOAD) : { build/asm/main_80078C74.s.o(.bss); }
    .main_80078D9C 0x80078D9C : AT(0x0007999C) { build/asm/data/main_80078D9C.bin.o(.data); }
    .main_8007A530 0x8007A530 : AT(0x0007B130) { FILL(0x00000000); build/asm/main_8007A530.s.o(.text); build/asm/main_8007A530.s.o(.rodata); build/asm/main_8007A530.s.o(.data); }
    .main_8007A530_bss (NOLOAD) : { build/asm/main_8007A530.s.o(.bss); }
    .main_8007AF48 0x8007AF48 : AT(0x0007BB48) { build/asm/data/main_8007AF48.bin.o(.data); }
    .main_8007BB20 0x8007BB20 : AT(0x0007C720) { FILL(0x00000000); build/asm/main_8007BB20.s.o(.text); build/asm/main_8007BB20.s.o(.rodata); build/asm/main_8007BB20.s.o(.data); }
    .main_8007BB20_bss (NOLOAD) : { build/asm/main_8007BB20.s.o(.bss); }
    .main_8007C4A8 0x8007C4A8 : AT(0x0007D0A8) { build/asm/data/main_8007C4A8.bin.o(.data); }
    .main_8007DC98 0x8007DC98 : AT(0x0007E898) { build/asm/data/main_8007DC98.bin.o(.data); }
    .main_8007EF38 0x8007EF38 : AT(0x0007FB38) { FILL(0x00000000); build/asm/main_8007EF38.s.o(.text); build/asm/main_8007EF38.s.o(.rodata); build/asm/main_8007EF38.s.o(.data); }
    .main_8007EF38_bss (NOLOAD) : { build/asm/main_8007EF38.s.o(.bss); }
    .main_8007FBF4 0x8007FBF4 : AT(0x000807F4) { FILL(0x00000000); build/asm/main_8007FBF4.s.o(.text); build/asm/main_8007FBF4.s.o(.rodata); build/asm/main_8007FBF4.s.o(.data); }
    .main_8007FBF4_bss (NOLOAD) : { build/asm/main_8007FBF4.s.o(.bss); }
    .main_8007FC8C 0x8007FC8C : AT(0x0008088C) { FILL(0x00000000); build/asm/main_8007FC8C.s.o(.text); build/asm/main_8007FC8C.s.o(.rodata); build/asm/main_8007FC8C.s.o(.data); }
    .main_8007FC8C_bss (NOLOAD) : { build/asm/main_8007FC8C.s.o(.bss); }
    .main_800810C0 0x800810C0 : AT(0x00081CC0) { build/asm/data/main_800810C0.bin.o(.data); }
    .main_80081FB4 0x80081FB4 : AT(0x00082BB4) { build/asm/data/main_80081FB4.bin.o(.data); }
    .main_800820F0 0x800820F0 : AT(0x00082CF0) { FILL(0x00000000); build/asm/main_800820F0.s.o(.text); build/asm/main_800820F0.s.o(.rodata); build/asm/main_800820F0.s.o(.data); }
    .main_800820F0_bss (NOLOAD) : { build/asm/main_800820F0.s.o(.bss); }
    .main_800820F8 0x800820F8 : AT(0x00082CF8) { build/asm/data/main_800820F8.bin.o(.data); }
    .main_80082F80 0x80082F80 : AT(0x00083B80) { FILL(0x00000000); build/asm/main_80082F80.s.o(.text); build/asm/main_80082F80.s.o(.rodata); build/asm/main_80082F80.s.o(.data); }
    .main_80082F80_bss (NOLOAD) : { build/asm/main_80082F80.s.o(.bss); }
    .main_800830E4 0x800830E4 : AT(0x00083CE4) { build/asm/data/main_800830E4.bin.o(.data); }
    .main_80084214 0x80084214 : AT(0x00084E14) { FILL(0x00000000); build/asm/main_80084214.s.o(.text); build/asm/main_80084214.s.o(.rodata); build/asm/main_80084214.s.o(.data); }
    .main_80084214_bss (NOLOAD) : { build/asm/main_80084214.s.o(.bss); }
    .main_80084278 0x80084278 : AT(0x00084E78) { build/asm/data/main_80084278.bin.o(.data); }
    .main_800844DC 0x800844DC : AT(0x000850DC) { FILL(0x00000000); build/asm/main_800844DC.s.o(.text); build/asm/main_800844DC.s.o(.rodata); build/asm/main_800844DC.s.o(.data); }
    .main_800844DC_bss (NOLOAD) : { build/asm/main_800844DC.s.o(.bss); }
    .main_800844EC 0x800844EC : AT(0x000850EC) { build/asm/data/main_800844EC.bin.o(.data); }
    .main_800856AC 0x800856AC : AT(0x000862AC) { FILL(0x00000000); build/asm/main_800856AC.s.o(.text); build/asm/main_800856AC.s.o(.rodata); build/asm/main_800856AC.s.o(.data); }
    .main_800856AC_bss (NOLOAD) : { build/asm/main_800856AC.s.o(.bss); }
    .main_800863E8 0x800863E8 : AT(0x00086FE8) { build/asm/data/main_800863E8.bin.o(.data); }
    .main_800888C0 0x800888C0 : AT(0x000894C0) { build/asm/data/main_800888C0.bin.o(.data); }
    .main_800892C8 0x800892C8 : AT(0x00089EC8) { build/asm/data/main_800892C8.bin.o(.data); }
    .main_8008A4B0 0x8008A4B0 : AT(0x0008B0B0) { build/asm/data/main_8008A4B0.bin.o(.data); }
    .main_8008B4C4 0x8008B4C4 : AT(0x0008C0C4) { FILL(0x00000000); build/asm/main_8008B4C4.s.o(.text); build/asm/main_8008B4C4.s.o(.rodata); build/asm/main_8008B4C4.s.o(.data); }
    .main_8008B4C4_bss (NOLOAD) : { build/asm/main_8008B4C4.s.o(.bss); }
    .main_8008C654 0x8008C654 : AT(0x0008D254) { FILL(0x00000000); build/asm/main_8008C654.s.o(.text); build/asm/main_8008C654.s.o(.rodata); build/asm/main_8008C654.s.o(.data); }
    .main_8008C654_bss (NOLOAD) : { build/asm/main_8008C654.s.o(.bss); }
    .main_8008D038 0x8008D038 : AT(0x0008DC38) { FILL(0x00000000); build/asm/main_8008D038.s.o(.text); build/asm/main_8008D038.s.o(.rodata); build/asm/main_8008D038.s.o(.data); }
    .main_8008D038_bss (NOLOAD) : { build/asm/main_8008D038.s.o(.bss); }
    .main_8008D38C 0x8008D38C : AT(0x0008DF8C) { build/asm/data/main_8008D38C.bin.o(.data); }
    .main_8008E204 0x8008E204 : AT(0x0008EE04) { FILL(0x00000000); build/asm/main_8008E204.s.o(.text); build/asm/main_8008E204.s.o(.rodata); build/asm/main_8008E204.s.o(.data); }
    .main_8008E204_bss (NOLOAD) : { build/asm/main_8008E204.s.o(.bss); }
    .main_8008F930 0x8008F930 : AT(0x00090530) { FILL(0x00000000); build/asm/main_8008F930.s.o(.text); build/asm/main_8008F930.s.o(.rodata); build/asm/main_8008F930.s.o(.data); }
    .main_8008F930_bss (NOLOAD) : { build/asm/main_8008F930.s.o(.bss); }
    .main_800900A8 0x800900A8 : AT(0x00090CA8) { FILL(0x00000000); build/asm/main_800900A8.s.o(.text); build/asm/main_800900A8.s.o(.rodata); build/asm/main_800900A8.s.o(.data); }
    .main_800900A8_bss (NOLOAD) : { build/asm/main_800900A8.s.o(.bss); }
    .main_800901FC 0x800901FC : AT(0x00090DFC) { FILL(0x00000000); build/asm/main_800901FC.s.o(.text); build/asm/main_800901FC.s.o(.rodata); build/asm/main_800901FC.s.o(.data); }
    .main_800901FC_bss (NOLOAD) : { build/asm/main_800901FC.s.o(.bss); }
    .main_800910BC 0x800910BC : AT(0x00091CBC) { build/asm/data/main_800910BC.bin.o(.data); }
    .main_80091434 0x80091434 : AT(0x00092034) { FILL(0x00000000); build/asm/main_80091434.s.o(.text); build/asm/main_80091434.s.o(.rodata); build/asm/main_80091434.s.o(.data); }
    .main_80091434_bss (NOLOAD) : { build/asm/main_80091434.s.o(.bss); }
    .main_800914B8 0x800914B8 : AT(0x000920B8) { build/asm/data/main_800914B8.bin.o(.data); }
    .main_800924B8 0x800924B8 : AT(0x000930B8) { FILL(0x00000000); build/asm/main_800924B8.s.o(.text); build/asm/main_800924B8.s.o(.rodata); build/asm/main_800924B8.s.o(.data); }
    .main_800924B8_bss (NOLOAD) : { build/asm/main_800924B8.s.o(.bss); }
    .main_80092694 0x80092694 : AT(0x00093294) { build/asm/data/main_80092694.bin.o(.data); }
    .main_80092A5C 0x80092A5C : AT(0x0009365C) { FILL(0x00000000); build/asm/main_80092A5C.s.o(.text); build/asm/main_80092A5C.s.o(.rodata); build/asm/main_80092A5C.s.o(.data); }
    .main_80092A5C_bss (NOLOAD) : { build/asm/main_80092A5C.s.o(.bss); }
    .main_80092B3C 0x80092B3C : AT(0x0009373C) { build/asm/data/main_80092B3C.bin.o(.data); }
    .main_80092CE0 0x80092CE0 : AT(0x000938E0) { FILL(0x00000000); build/asm/main_80092CE0.s.o(.text); build/asm/main_80092CE0.s.o(.rodata); build/asm/main_80092CE0.s.o(.data); }
    .main_80092CE0_bss (NOLOAD) : { build/asm/main_80092CE0.s.o(.bss); }
    .main_80092D64 0x80092D64 : AT(0x00093964) { build/asm/data/main_80092D64.bin.o(.data); }
    .main_80093514 0x80093514 : AT(0x00094114) { FILL(0x00000000); build/asm/main_80093514.s.o(.text); build/asm/main_80093514.s.o(.rodata); build/asm/main_80093514.s.o(.data); }
    .main_80093514_bss (NOLOAD) : { build/asm/main_80093514.s.o(.bss); }
    .main_80093540 0x80093540 : AT(0x00094140) { build/asm/data/main_80093540.bin.o(.data); }
    .main_800936EC 0x800936EC : AT(0x000942EC) { FILL(0x00000000); build/asm/main_800936EC.s.o(.text); build/asm/main_800936EC.s.o(.rodata); build/asm/main_800936EC.s.o(.data); }
    .main_800936EC_bss (NOLOAD) : { build/asm/main_800936EC.s.o(.bss); }
    .main_800936FC 0x800936FC : AT(0x000942FC) { build/asm/data/main_800936FC.bin.o(.data); }
    .main_80093954 0x80093954 : AT(0x00094554) { FILL(0x00000000); build/asm/main_80093954.s.o(.text); build/asm/main_80093954.s.o(.rodata); build/asm/main_80093954.s.o(.data); }
    .main_80093954_bss (NOLOAD) : { build/asm/main_80093954.s.o(.bss); }
    .main_800939D4 0x800939D4 : AT(0x000945D4) { build/asm/data/main_800939D4.bin.o(.data); }
    .main_80093AAC 0x80093AAC : AT(0x000946AC) { FILL(0x00000000); build/asm/main_80093AAC.s.o(.text); build/asm/main_80093AAC.s.o(.rodata); build/asm/main_80093AAC.s.o(.data); }
    .main_80093AAC_bss (NOLOAD) : { build/asm/main_80093AAC.s.o(.bss); }
    .main_80093DA8 0x80093DA8 : AT(0x000949A8) { build/asm/data/main_80093DA8.bin.o(.data); }
    .main_80093E94 0x80093E94 : AT(0x00094A94) { FILL(0x00000000); build/asm/main_80093E94.s.o(.text); build/asm/main_80093E94.s.o(.rodata); build/asm/main_80093E94.s.o(.data); }
    .main_80093E94_bss (NOLOAD) : { build/asm/main_80093E94.s.o(.bss); }
    .main_80093EA4 0x80093EA4 : AT(0x00094AA4) { build/asm/data/main_80093EA4.bin.o(.data); }
    .main_800956C8 0x800956C8 : AT(0x000962C8) { FILL(0x00000000); build/asm/main_800956C8.s.o(.text); build/asm/main_800956C8.s.o(.rodata); build/asm/main_800956C8.s.o(.data); }
    .main_800956C8_bss (NOLOAD) : { build/asm/main_800956C8.s.o(.bss); }
    .main_800956CC 0x800956CC : AT(0x000962CC) { build/asm/data/main_800956CC.bin.o(.data); }
    .main_80096460 0x80096460 : AT(0x00097060) { FILL(0x00000000); build/asm/main_80096460.s.o(.text); build/asm/main_80096460.s.o(.rodata); build/asm/main_80096460.s.o(.data); }
    .main_80096460_bss (NOLOAD) : { build/asm/main_80096460.s.o(.bss); }
    .main_80096570 0x80096570 : AT(0x00097170) { build/asm/data/main_80096570.bin.o(.data); }
    .main_800972B4 0x800972B4 : AT(0x00097EB4) { FILL(0x00000000); build/asm/main_800972B4.s.o(.text); build/asm/main_800972B4.s.o(.rodata); build/asm/main_800972B4.s.o(.data); }
    .main_800972B4_bss (NOLOAD) : { build/asm/main_800972B4.s.o(.bss); }
    .main_800972EC 0x800972EC : AT(0x00097EEC) { build/asm/data/main_800972EC.bin.o(.data); }
    .main_800982D0 0x800982D0 : AT(0x00098ED0) { FILL(0x00000000); build/asm/main_800982D0.s.o(.text); build/asm/main_800982D0.s.o(.rodata); build/asm/main_800982D0.s.o(.data); }
    .main_800982D0_bss (NOLOAD) : { build/asm/main_800982D0.s.o(.bss); }
    .main_800982F8 0x800982F8 : AT(0x00098EF8) { build/asm/data/main_800982F8.bin.o(.data); }
    .main_800985BC 0x800985BC : AT(0x000991BC) { FILL(0x00000000); build/asm/main_800985BC.s.o(.text); build/asm/main_800985BC.s.o(.rodata); build/asm/main_800985BC.s.o(.data); }
    .main_800985BC_bss (NOLOAD) : { build/asm/main_800985BC.s.o(.bss); }
    .main_8009FA04 0x8009FA04 : AT(0x000A0604) { build/asm/data/main_8009FA04.bin.o(.data); }
    .main_800A2044 0x800A2044 : AT(0x000A2C44) { FILL(0x00000000); build/asm/main_800A2044.s.o(.text); build/asm/main_800A2044.s.o(.rodata); build/asm/main_800A2044.s.o(.data); }
    .main_800A2044_bss (NOLOAD) : { build/asm/main_800A2044.s.o(.bss); }
    .main_800A2050 0x800A2050 : AT(0x000A2C50) { build/asm/data/main_800A2050.bin.o(.data); }
    .main_800A329C 0x800A329C : AT(0x000A3E9C) { FILL(0x00000000); build/asm/main_800A329C.s.o(.text); build/asm/main_800A329C.s.o(.rodata); build/asm/main_800A329C.s.o(.data); }
    .main_800A329C_bss (NOLOAD) : { build/asm/main_800A329C.s.o(.bss); }
    .main_800A3D38 0x800A3D38 : AT(0x000A4938) { build/asm/data/main_800A3D38.bin.o(.data); }
    .main_800A4314 0x800A4314 : AT(0x000A4F14) { FILL(0x00000000); build/asm/main_800A4314.s.o(.text); build/asm/main_800A4314.s.o(.rodata); build/asm/main_800A4314.s.o(.data); }
    .main_800A4314_bss (NOLOAD) : { build/asm/main_800A4314.s.o(.bss); }
    .main_800A643C 0x800A643C : AT(0x000A703C) { build/asm/data/main_800A643C.bin.o(.data); }
    .main_800A8C8C 0x800A8C8C : AT(0x000A988C) { FILL(0x00000000); build/asm/main_800A8C8C.s.o(.text); build/asm/main_800A8C8C.s.o(.rodata); build/asm/main_800A8C8C.s.o(.data); }
    .main_800A8C8C_bss (NOLOAD) : { build/asm/main_800A8C8C.s.o(.bss); }
    .main_800AC364 0x800AC364 : AT(0x000ACF64) { build/asm/data/main_800AC364.bin.o(.data); }
    .main_800AC634 0x800AC634 : AT(0x000AD234) { FILL(0x00000000); build/asm/main_800AC634.s.o(.text); build/asm/main_800AC634.s.o(.rodata); build/asm/main_800AC634.s.o(.data); }
    .main_800AC634_bss (NOLOAD) : { build/asm/main_800AC634.s.o(.bss); }
    .main_800ACDA8 0x800ACDA8 : AT(0x000AD9A8) { build/asm/data/main_800ACDA8.bin.o(.data); }
    .main_800ADCB4 0x800ADCB4 : AT(0x000AE8B4) { FILL(0x00000000); build/asm/main_800ADCB4.s.o(.text); build/asm/main_800ADCB4.s.o(.rodata); build/asm/main_800ADCB4.s.o(.data); }
    .main_800ADCB4_bss (NOLOAD) : { build/asm/main_800ADCB4.s.o(.bss); }
    .main_800ADFEC 0x800ADFEC : AT(0x000AEBEC) { build/asm/data/main_800ADFEC.bin.o(.data); }
    .main_800AEA20 0x800AEA20 : AT(0x000AF620) { FILL(0x00000000); build/asm/main_800AEA20.s.o(.text); build/asm/main_800AEA20.s.o(.rodata); build/asm/main_800AEA20.s.o(.data); }
    .main_800AEA20_bss (NOLOAD) : { build/asm/main_800AEA20.s.o(.bss); }
    .main_800AEE78 0x800AEE78 : AT(0x000AFA78) { build/asm/data/main_800AEE78.bin.o(.data); }
    .main_800AF4A0 0x800AF4A0 : AT(0x000B00A0) { FILL(0x00000000); build/asm/main_800AF4A0.s.o(.text); build/asm/main_800AF4A0.s.o(.rodata); build/asm/main_800AF4A0.s.o(.data); }
    .main_800AF4A0_bss (NOLOAD) : { build/asm/main_800AF4A0.s.o(.bss); }
    .main_800AF5AC 0x800AF5AC : AT(0x000B01AC) { build/asm/data/main_800AF5AC.bin.o(.data); }
    .main_800B0488 0x800B0488 : AT(0x000B1088) { FILL(0x00000000); build/asm/main_800B0488.s.o(.text); build/asm/main_800B0488.s.o(.rodata); build/asm/main_800B0488.s.o(.data); }
    .main_800B0488_bss (NOLOAD) : { build/asm/main_800B0488.s.o(.bss); }
    .main_800B1014 0x800B1014 : AT(0x000B1C14) { build/asm/data/main_800B1014.bin.o(.data); }
    .main_800B16C0 0x800B16C0 : AT(0x000B22C0) { FILL(0x00000000); build/asm/main_800B16C0.s.o(.text); build/asm/main_800B16C0.s.o(.rodata); build/asm/main_800B16C0.s.o(.data); }
    .main_800B16C0_bss (NOLOAD) : { build/asm/main_800B16C0.s.o(.bss); }
    .main_800B23C0 0x800B23C0 : AT(0x000B2FC0) { build/asm/data/main_800B23C0.bin.o(.data); }
    .main_800B920C 0x800B920C : AT(0x000B9E0C) { FILL(0x00000000); build/asm/main_800B920C.s.o(.text); build/asm/main_800B920C.s.o(.rodata); build/asm/main_800B920C.s.o(.data); }
    .main_800B920C_bss (NOLOAD) : { build/asm/main_800B920C.s.o(.bss); }
    .main_800B9368 0x800B9368 : AT(0x000B9F68) { build/asm/data/main_800B9368.bin.o(.data); }
    .main_800BC438 0x800BC438 : AT(0x000BD038) { FILL(0x00000000); build/asm/main_800BC438.s.o(.text); build/asm/main_800BC438.s.o(.rodata); build/asm/main_800BC438.s.o(.data); }
    .main_800BC438_bss (NOLOAD) : { build/asm/main_800BC438.s.o(.bss); }
    .main_800BC8A0 0x800BC8A0 : AT(0x000BD4A0) { build/asm/data/main_800BC8A0.bin.o(.data); }
    .main_800BD1A8 0x800BD1A8 : AT(0x000BDDA8) { FILL(0x00000000); build/asm/main_800BD1A8.s.o(.text); build/asm/main_800BD1A8.s.o(.rodata); build/asm/main_800BD1A8.s.o(.data); }
    .main_800BD1A8_bss (NOLOAD) : { build/asm/main_800BD1A8.s.o(.bss); }
    .main_800BD630 0x800BD630 : AT(0x000BE230) { build/asm/data/main_800BD630.bin.o(.data); }
    .main_800BD9CC 0x800BD9CC : AT(0x000BE5CC) { FILL(0x00000000); build/asm/main_800BD9CC.s.o(.text); build/asm/main_800BD9CC.s.o(.rodata); build/asm/main_800BD9CC.s.o(.data); }
    .main_800BD9CC_bss (NOLOAD) : { build/asm/main_800BD9CC.s.o(.bss); }
    .main_800BDA14 0x800BDA14 : AT(0x000BE614) { build/asm/data/main_800BDA14.bin.o(.data); }
    .main_800BE454 0x800BE454 : AT(0x000BF054) { FILL(0x00000000); build/asm/main_800BE454.s.o(.text); build/asm/main_800BE454.s.o(.rodata); build/asm/main_800BE454.s.o(.data); }
    .main_800BE454_bss (NOLOAD) : { build/asm/main_800BE454.s.o(.bss); }
    .main_800BE474 0x800BE474 : AT(0x000BF074) { build/asm/data/main_800BE474.bin.o(.data); }
    .main_800BEB6C 0x800BEB6C : AT(0x000BF76C) { FILL(0x00000000); build/asm/main_800BEB6C.s.o(.text); build/asm/main_800BEB6C.s.o(.rodata); build/asm/main_800BEB6C.s.o(.data); }
    .main_800BEB6C_bss (NOLOAD) : { build/asm/main_800BEB6C.s.o(.bss); }
    .main_800BED78 0x800BED78 : AT(0x000BF978) { build/asm/data/main_800BED78.bin.o(.data); }
    .main_800BF580 0x800BF580 : AT(0x000C0180) { FILL(0x00000000); build/asm/main_800BF580.s.o(.text); build/asm/main_800BF580.s.o(.rodata); build/asm/main_800BF580.s.o(.data); }
    .main_800BF580_bss (NOLOAD) : { build/asm/main_800BF580.s.o(.bss); }
    .main_800C0000 0x800C0000 : AT(0x000C0C00) { build/asm/data/main_800C0000.bin.o(.data); }
    .main_800C1BD4 0x800C1BD4 : AT(0x000C27D4) { FILL(0x00000000); build/asm/main_800C1BD4.s.o(.text); build/asm/main_800C1BD4.s.o(.rodata); build/asm/main_800C1BD4.s.o(.data); }
    .main_800C1BD4_bss (NOLOAD) : { build/asm/main_800C1BD4.s.o(.bss); }
    .main_800C1C38 0x800C1C38 : AT(0x000C2838) { build/asm/data/main_800C1C38.bin.o(.data); }
    .main_800C9C8C 0x800C9C8C : AT(0x000CA88C) { FILL(0x00000000); build/asm/main_800C9C8C.s.o(.text); build/asm/main_800C9C8C.s.o(.rodata); build/asm/main_800C9C8C.s.o(.data); }
    .main_800C9C8C_bss (NOLOAD) : { build/asm/main_800C9C8C.s.o(.bss); }
    .main_800C9DC8 0x800C9DC8 : AT(0x000CA9C8) { build/asm/data/main_800C9DC8.bin.o(.data); }
    .main_800CDA38 0x800CDA38 : AT(0x000CE638) { FILL(0x00000000); build/asm/main_800CDA38.s.o(.text); build/asm/main_800CDA38.s.o(.rodata); build/asm/main_800CDA38.s.o(.data); }
    .main_800CDA38_bss (NOLOAD) : { build/asm/main_800CDA38.s.o(.bss); }
    .main_800CE0A0 0x800CE0A0 : AT(0x000CECA0) { build/asm/data/main_800CE0A0.bin.o(.data); }
    .main_800D1960 0x800D1960 : AT(0x000D2560) { FILL(0x00000000); build/asm/main_800D1960.s.o(.text); build/asm/main_800D1960.s.o(.rodata); build/asm/main_800D1960.s.o(.data); }
    .main_800D1960_bss (NOLOAD) : { build/asm/main_800D1960.s.o(.bss); }
    .main_800D1A70 0x800D1A70 : AT(0x000D2670) { build/asm/data/main_800D1A70.bin.o(.data); }
    .main_800D1B18 0x800D1B18 : AT(0x000D2718) { FILL(0x00000000); build/asm/main_800D1B18.s.o(.text); build/asm/main_800D1B18.s.o(.rodata); build/asm/main_800D1B18.s.o(.data); }
    .main_800D1B18_bss (NOLOAD) : { build/asm/main_800D1B18.s.o(.bss); }
    .main_800D1BB0 0x800D1BB0 : AT(0x000D27B0) { build/asm/data/main_800D1BB0.bin.o(.data); }
    .main_800D310C 0x800D310C : AT(0x000D3D0C) { build/asm/data/main_800D310C.bin.o(.data); }
    .main_800D31F8 0x800D31F8 : AT(0x000D3DF8) { FILL(0x00000000); build/asm/main_800D31F8.s.o(.text); build/asm/main_800D31F8.s.o(.rodata); build/asm/main_800D31F8.s.o(.data); }
    .main_800D31F8_bss (NOLOAD) : { build/asm/main_800D31F8.s.o(.bss); }
    .main_800D3208 0x800D3208 : AT(0x000D3E08) { build/asm/data/main_800D3208.bin.o(.data); }
    .main_800D3818 0x800D3818 : AT(0x000D4418) { FILL(0x00000000); build/asm/main_800D3818.s.o(.text); build/asm/main_800D3818.s.o(.rodata); build/asm/main_800D3818.s.o(.data); }
    .main_800D3818_bss (NOLOAD) : { build/asm/main_800D3818.s.o(.bss); }
    .main_800D38C8 0x800D38C8 : AT(0x000D44C8) { FILL(0x00000000); build/asm/main_800D38C8.s.o(.text); build/asm/main_800D38C8.s.o(.rodata); build/asm/main_800D38C8.s.o(.data); }
    .main_800D38C8_bss (NOLOAD) : { build/asm/main_800D38C8.s.o(.bss); }
    .main_800D4828 0x800D4828 : AT(0x000D5428) { FILL(0x00000000); build/asm/main_800D4828.s.o(.text); build/asm/main_800D4828.s.o(.rodata); build/asm/main_800D4828.s.o(.data); }
    .main_800D4828_bss (NOLOAD) : { build/asm/main_800D4828.s.o(.bss); }
    .main_800D4830 0x800D4830 : AT(0x000D5430) { build/asm/data/main_800D4830.bin.o(.data); }
    .main_800D60E0 0x800D60E0 : AT(0x000D6CE0) { FILL(0x00000000); build/asm/main_800D60E0.s.o(.text); build/asm/main_800D60E0.s.o(.rodata); build/asm/main_800D60E0.s.o(.data); }
    .main_800D60E0_bss (NOLOAD) : { build/asm/main_800D60E0.s.o(.bss); }
    .main_800D6680 0x800D6680 : AT(0x000D7280) { build/asm/data/main_800D6680.bin.o(.data); }
    .main_800D7738 0x800D7738 : AT(0x000D8338) { FILL(0x00000000); build/asm/main_800D7738.s.o(.text); build/asm/main_800D7738.s.o(.rodata); build/asm/main_800D7738.s.o(.data); }
    .main_800D7738_bss (NOLOAD) : { build/asm/main_800D7738.s.o(.bss); }
    .main_800D7B18 0x800D7B18 : AT(0x000D8718) { build/asm/data/main_800D7B18.bin.o(.data); }
    .main_800D87F4 0x800D87F4 : AT(0x000D93F4) { build/asm/data/main_800D87F4.bin.o(.data); }
    .main_800D9854 0x800D9854 : AT(0x000DA454) { build/asm/data/main_800D9854.bin.o(.data); }
    .main_800EF858 0x800EF858 : AT(0x000F0458) { FILL(0x00000000); build/asm/main_800EF858.s.o(.text); build/asm/main_800EF858.s.o(.rodata); build/asm/main_800EF858.s.o(.data); }
    .main_800EF858_bss (NOLOAD) : { build/asm/main_800EF858.s.o(.bss); }
    .main_800EF8AC 0x800EF8AC : AT(0x000F04AC) { build/asm/data/main_800EF8AC.bin.o(.data); }
    .main_800F0620 0x800F0620 : AT(0x000F1220) { FILL(0x00000000); build/asm/main_800F0620.s.o(.text); build/asm/main_800F0620.s.o(.rodata); build/asm/main_800F0620.s.o(.data); }
    .main_800F0620_bss (NOLOAD) : { build/asm/main_800F0620.s.o(.bss); }
    .main_800F0660 0x800F0660 : AT(0x000F1260) { build/asm/data/main_800F0660.bin.o(.data); }
    .main_800F0AD8 0x800F0AD8 : AT(0x000F16D8) { FILL(0x00000000); build/asm/main_800F0AD8.s.o(.text); build/asm/main_800F0AD8.s.o(.rodata); build/asm/main_800F0AD8.s.o(.data); }
    .main_800F0AD8_bss (NOLOAD) : { build/asm/main_800F0AD8.s.o(.bss); }
    .main_800F0B7C 0x800F0B7C : AT(0x000F177C) { build/asm/data/main_800F0B7C.bin.o(.data); }
    .main_800FE290 0x800FE290 : AT(0x000FEE90) { FILL(0x00000000); build/asm/main_800FE290.s.o(.text); build/asm/main_800FE290.s.o(.rodata); build/asm/main_800FE290.s.o(.data); }
    .main_800FE290_bss (NOLOAD) : { build/asm/main_800FE290.s.o(.bss); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
