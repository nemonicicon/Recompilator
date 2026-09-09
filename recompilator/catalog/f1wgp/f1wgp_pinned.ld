SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_8000D8F4 0x8000D8F4 : AT(0x0000E4F4) { FILL(0x00000000); build/asm/main_8000D8F4.s.o(.text); build/asm/main_8000D8F4.s.o(.rodata); build/asm/main_8000D8F4.s.o(.data); }
    .main_8000D8F4_bss (NOLOAD) : { build/asm/main_8000D8F4.s.o(.bss); }
    .main_8000E2EC 0x8000E2EC : AT(0x0000EEEC) { FILL(0x00000000); build/asm/main_8000E2EC.s.o(.text); build/asm/main_8000E2EC.s.o(.rodata); build/asm/main_8000E2EC.s.o(.data); }
    .main_8000E2EC_bss (NOLOAD) : { build/asm/main_8000E2EC.s.o(.bss); }
    .main_8000F3A0 0x8000F3A0 : AT(0x0000FFA0) { FILL(0x00000000); build/asm/main_8000F3A0.s.o(.text); build/asm/main_8000F3A0.s.o(.rodata); build/asm/main_8000F3A0.s.o(.data); }
    .main_8000F3A0_bss (NOLOAD) : { build/asm/main_8000F3A0.s.o(.bss); }
    .main_80010DE4 0x80010DE4 : AT(0x000119E4) { FILL(0x00000000); build/asm/main_80010DE4.s.o(.text); build/asm/main_80010DE4.s.o(.rodata); build/asm/main_80010DE4.s.o(.data); }
    .main_80010DE4_bss (NOLOAD) : { build/asm/main_80010DE4.s.o(.bss); }
    .main_800111B0 0x800111B0 : AT(0x00011DB0) { FILL(0x00000000); build/asm/main_800111B0.s.o(.text); build/asm/main_800111B0.s.o(.rodata); build/asm/main_800111B0.s.o(.data); }
    .main_800111B0_bss (NOLOAD) : { build/asm/main_800111B0.s.o(.bss); }
    .main_80012318 0x80012318 : AT(0x00012F18) { FILL(0x00000000); build/asm/main_80012318.s.o(.text); build/asm/main_80012318.s.o(.rodata); build/asm/main_80012318.s.o(.data); }
    .main_80012318_bss (NOLOAD) : { build/asm/main_80012318.s.o(.bss); }
    .main_80012A90 0x80012A90 : AT(0x00013690) { FILL(0x00000000); build/asm/main_80012A90.s.o(.text); build/asm/main_80012A90.s.o(.rodata); build/asm/main_80012A90.s.o(.data); }
    .main_80012A90_bss (NOLOAD) : { build/asm/main_80012A90.s.o(.bss); }
    .main_80015B90 0x80015B90 : AT(0x00016790) { FILL(0x00000000); build/asm/main_80015B90.s.o(.text); build/asm/main_80015B90.s.o(.rodata); build/asm/main_80015B90.s.o(.data); }
    .main_80015B90_bss (NOLOAD) : { build/asm/main_80015B90.s.o(.bss); }
    .main_8001699C 0x8001699C : AT(0x0001759C) { FILL(0x00000000); build/asm/main_8001699C.s.o(.text); build/asm/main_8001699C.s.o(.rodata); build/asm/main_8001699C.s.o(.data); }
    .main_8001699C_bss (NOLOAD) : { build/asm/main_8001699C.s.o(.bss); }
    .main_8001DED0 0x8001DED0 : AT(0x0001EAD0) { FILL(0x00000000); build/asm/main_8001DED0.s.o(.text); build/asm/main_8001DED0.s.o(.rodata); build/asm/main_8001DED0.s.o(.data); }
    .main_8001DED0_bss (NOLOAD) : { build/asm/main_8001DED0.s.o(.bss); }
    .main_8001E870 0x8001E870 : AT(0x0001F470) { FILL(0x00000000); build/asm/main_8001E870.s.o(.text); build/asm/main_8001E870.s.o(.rodata); build/asm/main_8001E870.s.o(.data); }
    .main_8001E870_bss (NOLOAD) : { build/asm/main_8001E870.s.o(.bss); }
    .main_8001EDF0 0x8001EDF0 : AT(0x0001F9F0) { FILL(0x00000000); build/asm/main_8001EDF0.s.o(.text); build/asm/main_8001EDF0.s.o(.rodata); build/asm/main_8001EDF0.s.o(.data); }
    .main_8001EDF0_bss (NOLOAD) : { build/asm/main_8001EDF0.s.o(.bss); }
    .main_8001F3C0 0x8001F3C0 : AT(0x0001FFC0) { FILL(0x00000000); build/asm/main_8001F3C0.s.o(.text); build/asm/main_8001F3C0.s.o(.rodata); build/asm/main_8001F3C0.s.o(.data); }
    .main_8001F3C0_bss (NOLOAD) : { build/asm/main_8001F3C0.s.o(.bss); }
    .main_8001F6E8 0x8001F6E8 : AT(0x000202E8) { FILL(0x00000000); build/asm/main_8001F6E8.s.o(.text); build/asm/main_8001F6E8.s.o(.rodata); build/asm/main_8001F6E8.s.o(.data); }
    .main_8001F6E8_bss (NOLOAD) : { build/asm/main_8001F6E8.s.o(.bss); }
    .main_80020010 0x80020010 : AT(0x00020C10) { FILL(0x00000000); build/asm/main_80020010.s.o(.text); build/asm/main_80020010.s.o(.rodata); build/asm/main_80020010.s.o(.data); }
    .main_80020010_bss (NOLOAD) : { build/asm/main_80020010.s.o(.bss); }
    .main_80020430 0x80020430 : AT(0x00021030) { FILL(0x00000000); build/asm/main_80020430.s.o(.text); build/asm/main_80020430.s.o(.rodata); build/asm/main_80020430.s.o(.data); }
    .main_80020430_bss (NOLOAD) : { build/asm/main_80020430.s.o(.bss); }
    .main_800204A8 0x800204A8 : AT(0x000210A8) { FILL(0x00000000); build/asm/main_800204A8.s.o(.text); build/asm/main_800204A8.s.o(.rodata); build/asm/main_800204A8.s.o(.data); }
    .main_800204A8_bss (NOLOAD) : { build/asm/main_800204A8.s.o(.bss); }
    .main_80021B30 0x80021B30 : AT(0x00022730) { FILL(0x00000000); build/asm/main_80021B30.s.o(.text); build/asm/main_80021B30.s.o(.rodata); build/asm/main_80021B30.s.o(.data); }
    .main_80021B30_bss (NOLOAD) : { build/asm/main_80021B30.s.o(.bss); }
    .main_80025EE4 0x80025EE4 : AT(0x00026AE4) { FILL(0x00000000); build/asm/main_80025EE4.s.o(.text); build/asm/main_80025EE4.s.o(.rodata); build/asm/main_80025EE4.s.o(.data); }
    .main_80025EE4_bss (NOLOAD) : { build/asm/main_80025EE4.s.o(.bss); }
    .main_80026240 0x80026240 : AT(0x00026E40) { FILL(0x00000000); build/asm/main_80026240.s.o(.text); build/asm/main_80026240.s.o(.rodata); build/asm/main_80026240.s.o(.data); }
    .main_80026240_bss (NOLOAD) : { build/asm/main_80026240.s.o(.bss); }
    .main_80027750 0x80027750 : AT(0x00028350) { build/asm/data/main_80027750.bin.o(.data); }
    .main_8002CC0C 0x8002CC0C : AT(0x0002D80C) { FILL(0x00000000); build/asm/main_8002CC0C.s.o(.text); build/asm/main_8002CC0C.s.o(.rodata); build/asm/main_8002CC0C.s.o(.data); }
    .main_8002CC0C_bss (NOLOAD) : { build/asm/main_8002CC0C.s.o(.bss); }
    .main_8002E480 0x8002E480 : AT(0x0002F080) { build/asm/data/main_8002E480.bin.o(.data); }
    .main_8002F350 0x8002F350 : AT(0x0002FF50) { FILL(0x00000000); build/asm/main_8002F350.s.o(.text); build/asm/main_8002F350.s.o(.rodata); build/asm/main_8002F350.s.o(.data); }
    .main_8002F350_bss (NOLOAD) : { build/asm/main_8002F350.s.o(.bss); }
    .main_80030150 0x80030150 : AT(0x00030D50) { FILL(0x00000000); build/asm/main_80030150.s.o(.text); build/asm/main_80030150.s.o(.rodata); build/asm/main_80030150.s.o(.data); }
    .main_80030150_bss (NOLOAD) : { build/asm/main_80030150.s.o(.bss); }
    .main_80031164 0x80031164 : AT(0x00031D64) { build/asm/data/main_80031164.bin.o(.data); }
    .main_80031E70 0x80031E70 : AT(0x00032A70) { FILL(0x00000000); build/asm/main_80031E70.s.o(.text); build/asm/main_80031E70.s.o(.rodata); build/asm/main_80031E70.s.o(.data); }
    .main_80031E70_bss (NOLOAD) : { build/asm/main_80031E70.s.o(.bss); }
    .main_800320C0 0x800320C0 : AT(0x00032CC0) { build/asm/data/main_800320C0.bin.o(.data); }
    .main_800328C0 0x800328C0 : AT(0x000334C0) { FILL(0x00000000); build/asm/main_800328C0.s.o(.text); build/asm/main_800328C0.s.o(.rodata); build/asm/main_800328C0.s.o(.data); }
    .main_800328C0_bss (NOLOAD) : { build/asm/main_800328C0.s.o(.bss); }
    .main_800332C0 0x800332C0 : AT(0x00033EC0) { FILL(0x00000000); build/asm/main_800332C0.s.o(.text); build/asm/main_800332C0.s.o(.rodata); build/asm/main_800332C0.s.o(.data); }
    .main_800332C0_bss (NOLOAD) : { build/asm/main_800332C0.s.o(.bss); }
    .main_80033F08 0x80033F08 : AT(0x00034B08) { build/asm/data/main_80033F08.bin.o(.data); }
    .main_800368B4 0x800368B4 : AT(0x000374B4) { FILL(0x00000000); build/asm/main_800368B4.s.o(.text); build/asm/main_800368B4.s.o(.rodata); build/asm/main_800368B4.s.o(.data); }
    .main_800368B4_bss (NOLOAD) : { build/asm/main_800368B4.s.o(.bss); }
    .main_80036B8C 0x80036B8C : AT(0x0003778C) { build/asm/data/main_80036B8C.bin.o(.data); }
    .main_80037234 0x80037234 : AT(0x00037E34) { FILL(0x00000000); build/asm/main_80037234.s.o(.text); build/asm/main_80037234.s.o(.rodata); build/asm/main_80037234.s.o(.data); }
    .main_80037234_bss (NOLOAD) : { build/asm/main_80037234.s.o(.bss); }
    .main_800372B4 0x800372B4 : AT(0x00037EB4) { build/asm/data/main_800372B4.bin.o(.data); }
    .main_80038354 0x80038354 : AT(0x00038F54) { FILL(0x00000000); build/asm/main_80038354.s.o(.text); build/asm/main_80038354.s.o(.rodata); build/asm/main_80038354.s.o(.data); }
    .main_80038354_bss (NOLOAD) : { build/asm/main_80038354.s.o(.bss); }
    .main_80038404 0x80038404 : AT(0x00039004) { build/asm/data/main_80038404.bin.o(.data); }
    .main_80038C70 0x80038C70 : AT(0x00039870) { FILL(0x00000000); build/asm/main_80038C70.s.o(.text); build/asm/main_80038C70.s.o(.rodata); build/asm/main_80038C70.s.o(.data); }
    .main_80038C70_bss (NOLOAD) : { build/asm/main_80038C70.s.o(.bss); }
    .main_80038D58 0x80038D58 : AT(0x00039958) { build/asm/data/main_80038D58.bin.o(.data); }
    .main_80038F74 0x80038F74 : AT(0x00039B74) { FILL(0x00000000); build/asm/main_80038F74.s.o(.text); build/asm/main_80038F74.s.o(.rodata); build/asm/main_80038F74.s.o(.data); }
    .main_80038F74_bss (NOLOAD) : { build/asm/main_80038F74.s.o(.bss); }
    .main_8003903C 0x8003903C : AT(0x00039C3C) { build/asm/data/main_8003903C.bin.o(.data); }
    .main_8003AADC 0x8003AADC : AT(0x0003B6DC) { build/asm/data/main_8003AADC.bin.o(.data); }
    .main_8003BE20 0x8003BE20 : AT(0x0003CA20) { build/asm/data/main_8003BE20.bin.o(.data); }
    .main_8003C848 0x8003C848 : AT(0x0003D448) { build/asm/data/main_8003C848.bin.o(.data); }
    .main_8003DAC8 0x8003DAC8 : AT(0x0003E6C8) { FILL(0x00000000); build/asm/main_8003DAC8.s.o(.text); build/asm/main_8003DAC8.s.o(.rodata); build/asm/main_8003DAC8.s.o(.data); }
    .main_8003DAC8_bss (NOLOAD) : { build/asm/main_8003DAC8.s.o(.bss); }
    .main_8003DAD4 0x8003DAD4 : AT(0x0003E6D4) { build/asm/data/main_8003DAD4.bin.o(.data); }
    .main_8003E64C 0x8003E64C : AT(0x0003F24C) { FILL(0x00000000); build/asm/main_8003E64C.s.o(.text); build/asm/main_8003E64C.s.o(.rodata); build/asm/main_8003E64C.s.o(.data); }
    .main_8003E64C_bss (NOLOAD) : { build/asm/main_8003E64C.s.o(.bss); }
    .main_8003E658 0x8003E658 : AT(0x0003F258) { build/asm/data/main_8003E658.bin.o(.data); }
    .main_8003EE38 0x8003EE38 : AT(0x0003FA38) { build/asm/data/main_8003EE38.bin.o(.data); }
    .main_8003F024 0x8003F024 : AT(0x0003FC24) { FILL(0x00000000); build/asm/main_8003F024.s.o(.text); build/asm/main_8003F024.s.o(.rodata); build/asm/main_8003F024.s.o(.data); }
    .main_8003F024_bss (NOLOAD) : { build/asm/main_8003F024.s.o(.bss); }
    .main_8003F1EC 0x8003F1EC : AT(0x0003FDEC) { build/asm/data/main_8003F1EC.bin.o(.data); }
    .main_8003F498 0x8003F498 : AT(0x00040098) { build/asm/data/main_8003F498.bin.o(.data); }
    .main_8003F734 0x8003F734 : AT(0x00040334) { build/asm/data/main_8003F734.bin.o(.data); }
    .main_8003FC84 0x8003FC84 : AT(0x00040884) { build/asm/data/main_8003FC84.bin.o(.data); }
    .main_80040490 0x80040490 : AT(0x00041090) { build/asm/data/main_80040490.bin.o(.data); }
    .main_80040D08 0x80040D08 : AT(0x00041908) { FILL(0x00000000); build/asm/main_80040D08.s.o(.text); build/asm/main_80040D08.s.o(.rodata); build/asm/main_80040D08.s.o(.data); }
    .main_80040D08_bss (NOLOAD) : { build/asm/main_80040D08.s.o(.bss); }
    .main_80040FF4 0x80040FF4 : AT(0x00041BF4) { FILL(0x00000000); build/asm/main_80040FF4.s.o(.text); build/asm/main_80040FF4.s.o(.rodata); build/asm/main_80040FF4.s.o(.data); }
    .main_80040FF4_bss (NOLOAD) : { build/asm/main_80040FF4.s.o(.bss); }
    .main_80041034 0x80041034 : AT(0x00041C34) { build/asm/data/main_80041034.bin.o(.data); }
    .main_80041380 0x80041380 : AT(0x00041F80) { FILL(0x00000000); build/asm/main_80041380.s.o(.text); build/asm/main_80041380.s.o(.rodata); build/asm/main_80041380.s.o(.data); }
    .main_80041380_bss (NOLOAD) : { build/asm/main_80041380.s.o(.bss); }
    .main_8004144C 0x8004144C : AT(0x0004204C) { build/asm/data/main_8004144C.bin.o(.data); }
    .main_80041500 0x80041500 : AT(0x00042100) { FILL(0x00000000); build/asm/main_80041500.s.o(.text); build/asm/main_80041500.s.o(.rodata); build/asm/main_80041500.s.o(.data); }
    .main_80041500_bss (NOLOAD) : { build/asm/main_80041500.s.o(.bss); }
    .main_80041834 0x80041834 : AT(0x00042434) { build/asm/data/main_80041834.bin.o(.data); }
    .main_80042120 0x80042120 : AT(0x00042D20) { FILL(0x00000000); build/asm/main_80042120.s.o(.text); build/asm/main_80042120.s.o(.rodata); build/asm/main_80042120.s.o(.data); }
    .main_80042120_bss (NOLOAD) : { build/asm/main_80042120.s.o(.bss); }
    .main_80042130 0x80042130 : AT(0x00042D30) { build/asm/data/main_80042130.bin.o(.data); }
    .main_800429D4 0x800429D4 : AT(0x000435D4) { FILL(0x00000000); build/asm/main_800429D4.s.o(.text); build/asm/main_800429D4.s.o(.rodata); build/asm/main_800429D4.s.o(.data); }
    .main_800429D4_bss (NOLOAD) : { build/asm/main_800429D4.s.o(.bss); }
    .main_8004314C 0x8004314C : AT(0x00043D4C) { FILL(0x00000000); build/asm/main_8004314C.s.o(.text); build/asm/main_8004314C.s.o(.rodata); build/asm/main_8004314C.s.o(.data); }
    .main_8004314C_bss (NOLOAD) : { build/asm/main_8004314C.s.o(.bss); }
    .main_800431F8 0x800431F8 : AT(0x00043DF8) { build/asm/data/main_800431F8.bin.o(.data); }
    .main_80043AF0 0x80043AF0 : AT(0x000446F0) { FILL(0x00000000); build/asm/main_80043AF0.s.o(.text); build/asm/main_80043AF0.s.o(.rodata); build/asm/main_80043AF0.s.o(.data); }
    .main_80043AF0_bss (NOLOAD) : { build/asm/main_80043AF0.s.o(.bss); }
    .main_80044050 0x80044050 : AT(0x00044C50) { build/asm/data/main_80044050.bin.o(.data); }
    .main_80045080 0x80045080 : AT(0x00045C80) { FILL(0x00000000); build/asm/main_80045080.s.o(.text); build/asm/main_80045080.s.o(.rodata); build/asm/main_80045080.s.o(.data); }
    .main_80045080_bss (NOLOAD) : { build/asm/main_80045080.s.o(.bss); }
    .main_8004532C 0x8004532C : AT(0x00045F2C) { FILL(0x00000000); build/asm/main_8004532C.s.o(.text); build/asm/main_8004532C.s.o(.rodata); build/asm/main_8004532C.s.o(.data); }
    .main_8004532C_bss (NOLOAD) : { build/asm/main_8004532C.s.o(.bss); }
    .main_8004534C 0x8004534C : AT(0x00045F4C) { build/asm/data/main_8004534C.bin.o(.data); }
    .main_80047120 0x80047120 : AT(0x00047D20) { FILL(0x00000000); build/asm/main_80047120.s.o(.text); build/asm/main_80047120.s.o(.rodata); build/asm/main_80047120.s.o(.data); }
    .main_80047120_bss (NOLOAD) : { build/asm/main_80047120.s.o(.bss); }
    .main_800471F4 0x800471F4 : AT(0x00047DF4) { build/asm/data/main_800471F4.bin.o(.data); }
    .main_80047918 0x80047918 : AT(0x00048518) { FILL(0x00000000); build/asm/main_80047918.s.o(.text); build/asm/main_80047918.s.o(.rodata); build/asm/main_80047918.s.o(.data); }
    .main_80047918_bss (NOLOAD) : { build/asm/main_80047918.s.o(.bss); }
    .main_80047CD8 0x80047CD8 : AT(0x000488D8) { build/asm/data/main_80047CD8.bin.o(.data); }
    .main_8004A4B8 0x8004A4B8 : AT(0x0004B0B8) { FILL(0x00000000); build/asm/main_8004A4B8.s.o(.text); build/asm/main_8004A4B8.s.o(.rodata); build/asm/main_8004A4B8.s.o(.data); }
    .main_8004A4B8_bss (NOLOAD) : { build/asm/main_8004A4B8.s.o(.bss); }
    .main_8004A4BC 0x8004A4BC : AT(0x0004B0BC) { build/asm/data/main_8004A4BC.bin.o(.data); }
    .main_8004B268 0x8004B268 : AT(0x0004BE68) { FILL(0x00000000); build/asm/main_8004B268.s.o(.text); build/asm/main_8004B268.s.o(.rodata); build/asm/main_8004B268.s.o(.data); }
    .main_8004B268_bss (NOLOAD) : { build/asm/main_8004B268.s.o(.bss); }
    .main_8004B6A4 0x8004B6A4 : AT(0x0004C2A4) { build/asm/data/main_8004B6A4.bin.o(.data); }
    .main_8004C734 0x8004C734 : AT(0x0004D334) { FILL(0x00000000); build/asm/main_8004C734.s.o(.text); build/asm/main_8004C734.s.o(.rodata); build/asm/main_8004C734.s.o(.data); }
    .main_8004C734_bss (NOLOAD) : { build/asm/main_8004C734.s.o(.bss); }
    .main_8004C794 0x8004C794 : AT(0x0004D394) { build/asm/data/main_8004C794.bin.o(.data); }
    .main_8004E568 0x8004E568 : AT(0x0004F168) { FILL(0x00000000); build/asm/main_8004E568.s.o(.text); build/asm/main_8004E568.s.o(.rodata); build/asm/main_8004E568.s.o(.data); }
    .main_8004E568_bss (NOLOAD) : { build/asm/main_8004E568.s.o(.bss); }
    .main_8004E58C 0x8004E58C : AT(0x0004F18C) { build/asm/data/main_8004E58C.bin.o(.data); }
    .main_8004F4BC 0x8004F4BC : AT(0x000500BC) { build/asm/data/main_8004F4BC.bin.o(.data); }
    .main_8004F5BC 0x8004F5BC : AT(0x000501BC) { build/asm/data/main_8004F5BC.bin.o(.data); }
    .main_80050718 0x80050718 : AT(0x00051318) { build/asm/data/main_80050718.bin.o(.data); }
    .main_80050A38 0x80050A38 : AT(0x00051638) { build/asm/data/main_80050A38.bin.o(.data); }
    .main_80050C44 0x80050C44 : AT(0x00051844) { build/asm/data/main_80050C44.bin.o(.data); }
    .main_80050C50 0x80050C50 : AT(0x00051850) { build/asm/data/main_80050C50.bin.o(.data); }
    .main_80051010 0x80051010 : AT(0x00051C10) { build/asm/data/main_80051010.bin.o(.data); }
    .main_8005114C 0x8005114C : AT(0x00051D4C) { build/asm/data/main_8005114C.bin.o(.data); }
    .main_80051840 0x80051840 : AT(0x00052440) { build/asm/data/main_80051840.bin.o(.data); }
    .main_800518D4 0x800518D4 : AT(0x000524D4) { build/asm/data/main_800518D4.bin.o(.data); }
    .main_80052164 0x80052164 : AT(0x00052D64) { build/asm/data/main_80052164.bin.o(.data); }
    .main_8005235C 0x8005235C : AT(0x00052F5C) { build/asm/data/main_8005235C.bin.o(.data); }
    .main_80053480 0x80053480 : AT(0x00054080) { build/asm/data/main_80053480.bin.o(.data); }
    .main_80053608 0x80053608 : AT(0x00054208) { build/asm/data/main_80053608.bin.o(.data); }
    .main_80055878 0x80055878 : AT(0x00056478) { build/asm/data/main_80055878.bin.o(.data); }
    .main_80055880 0x80055880 : AT(0x00056480) { build/asm/data/main_80055880.bin.o(.data); }
    .main_80057E8C 0x80057E8C : AT(0x00058A8C) { build/asm/data/main_80057E8C.bin.o(.data); }
    .main_80057EE8 0x80057EE8 : AT(0x00058AE8) { build/asm/data/main_80057EE8.bin.o(.data); }
    .main_8005896C 0x8005896C : AT(0x0005956C) { build/asm/data/main_8005896C.bin.o(.data); }
    .main_80058A50 0x80058A50 : AT(0x00059650) { build/asm/data/main_80058A50.bin.o(.data); }
    .main_8005939C 0x8005939C : AT(0x00059F9C) { build/asm/data/main_8005939C.bin.o(.data); }
    .main_800597E0 0x800597E0 : AT(0x0005A3E0) { build/asm/data/main_800597E0.bin.o(.data); }
    .main_80059F38 0x80059F38 : AT(0x0005AB38) { build/asm/data/main_80059F38.bin.o(.data); }
    .main_80059F98 0x80059F98 : AT(0x0005AB98) { build/asm/data/main_80059F98.bin.o(.data); }
    .main_8005AEC4 0x8005AEC4 : AT(0x0005BAC4) { build/asm/data/main_8005AEC4.bin.o(.data); }
    .main_8005B21C 0x8005B21C : AT(0x0005BE1C) { build/asm/data/main_8005B21C.bin.o(.data); }
    .main_8005CFD8 0x8005CFD8 : AT(0x0005DBD8) { build/asm/data/main_8005CFD8.bin.o(.data); }
    .main_8005D12C 0x8005D12C : AT(0x0005DD2C) { build/asm/data/main_8005D12C.bin.o(.data); }
    .main_8005D8DC 0x8005D8DC : AT(0x0005E4DC) { build/asm/data/main_8005D8DC.bin.o(.data); }
    .main_8005DA6C 0x8005DA6C : AT(0x0005E66C) { build/asm/data/main_8005DA6C.bin.o(.data); }
    .main_80061E70 0x80061E70 : AT(0x00062A70) { build/asm/data/main_80061E70.bin.o(.data); }
    .main_80061EA4 0x80061EA4 : AT(0x00062AA4) { build/asm/data/main_80061EA4.bin.o(.data); }
    .main_8006256C 0x8006256C : AT(0x0006316C) { build/asm/data/main_8006256C.bin.o(.data); }
    .main_80062574 0x80062574 : AT(0x00063174) { build/asm/data/main_80062574.bin.o(.data); }
    .main_80062C58 0x80062C58 : AT(0x00063858) { build/asm/data/main_80062C58.bin.o(.data); }
    .main_80062D40 0x80062D40 : AT(0x00063940) { build/asm/data/main_80062D40.bin.o(.data); }
    .main_800632F0 0x800632F0 : AT(0x00063EF0) { build/asm/data/main_800632F0.bin.o(.data); }
    .main_800632F4 0x800632F4 : AT(0x00063EF4) { build/asm/data/main_800632F4.bin.o(.data); }
    .main_80063328 0x80063328 : AT(0x00063F28) { build/asm/data/main_80063328.bin.o(.data); }
    .main_8006333C 0x8006333C : AT(0x00063F3C) { build/asm/data/main_8006333C.bin.o(.data); }
    .main_800657FC 0x800657FC : AT(0x000663FC) { build/asm/data/main_800657FC.bin.o(.data); }
    .main_8006587C 0x8006587C : AT(0x0006647C) { build/asm/data/main_8006587C.bin.o(.data); }
    .main_80065FE8 0x80065FE8 : AT(0x00066BE8) { build/asm/data/main_80065FE8.bin.o(.data); }
    .main_80066234 0x80066234 : AT(0x00066E34) { build/asm/data/main_80066234.bin.o(.data); }
    .main_8006A0CC 0x8006A0CC : AT(0x0006ACCC) { build/asm/data/main_8006A0CC.bin.o(.data); }
    .main_8006A750 0x8006A750 : AT(0x0006B350) { build/asm/data/main_8006A750.bin.o(.data); }
    .main_8006B1C8 0x8006B1C8 : AT(0x0006BDC8) { build/asm/data/main_8006B1C8.bin.o(.data); }
    .main_8006B1D8 0x8006B1D8 : AT(0x0006BDD8) { build/asm/data/main_8006B1D8.bin.o(.data); }
    .main_8006BFDC 0x8006BFDC : AT(0x0006CBDC) { build/asm/data/main_8006BFDC.bin.o(.data); }
    .main_8006C024 0x8006C024 : AT(0x0006CC24) { build/asm/data/main_8006C024.bin.o(.data); }
    .main_8006C69C 0x8006C69C : AT(0x0006D29C) { build/asm/data/main_8006C69C.bin.o(.data); }
    .main_8006C718 0x8006C718 : AT(0x0006D318) { build/asm/data/main_8006C718.bin.o(.data); }
    .main_8006EBA0 0x8006EBA0 : AT(0x0006F7A0) { build/asm/data/main_8006EBA0.bin.o(.data); }
    .main_8006EC48 0x8006EC48 : AT(0x0006F848) { build/asm/data/main_8006EC48.bin.o(.data); }
    .main_8006EDFC 0x8006EDFC : AT(0x0006F9FC) { build/asm/data/main_8006EDFC.bin.o(.data); }
    .main_8006F3C4 0x8006F3C4 : AT(0x0006FFC4) { build/asm/data/main_8006F3C4.bin.o(.data); }
    .main_8006F48C 0x8006F48C : AT(0x0007008C) { build/asm/data/main_8006F48C.bin.o(.data); }
    .main_8006FA88 0x8006FA88 : AT(0x00070688) { build/asm/data/main_8006FA88.bin.o(.data); }
    .main_80070090 0x80070090 : AT(0x00070C90) { build/asm/data/main_80070090.bin.o(.data); }
    .main_800700D8 0x800700D8 : AT(0x00070CD8) { build/asm/data/main_800700D8.bin.o(.data); }
    .main_80076050 0x80076050 : AT(0x00076C50) { build/asm/data/main_80076050.bin.o(.data); }
    .main_800761F0 0x800761F0 : AT(0x00076DF0) { build/asm/data/main_800761F0.bin.o(.data); }
    .main_8007863C 0x8007863C : AT(0x0007923C) { build/asm/data/main_8007863C.bin.o(.data); }
    .main_80078668 0x80078668 : AT(0x00079268) { build/asm/data/main_80078668.bin.o(.data); }
    .main_80080808 0x80080808 : AT(0x00081408) { build/asm/data/main_80080808.bin.o(.data); }
    .main_8008080C 0x8008080C : AT(0x0008140C) { build/asm/data/main_8008080C.bin.o(.data); }
    .main_80082D98 0x80082D98 : AT(0x00083998) { build/asm/data/main_80082D98.bin.o(.data); }
    .main_80082F5C 0x80082F5C : AT(0x00083B5C) { build/asm/data/main_80082F5C.bin.o(.data); }
    .main_800842FC 0x800842FC : AT(0x00084EFC) { build/asm/data/main_800842FC.bin.o(.data); }
    .main_80084310 0x80084310 : AT(0x00084F10) { build/asm/data/main_80084310.bin.o(.data); }
    .main_80084B1C 0x80084B1C : AT(0x0008571C) { build/asm/data/main_80084B1C.bin.o(.data); }
    .main_80084E70 0x80084E70 : AT(0x00085A70) { build/asm/data/main_80084E70.bin.o(.data); }
    .main_80085218 0x80085218 : AT(0x00085E18) { build/asm/data/main_80085218.bin.o(.data); }
    .main_80085424 0x80085424 : AT(0x00086024) { build/asm/data/main_80085424.bin.o(.data); }
    .main_80085918 0x80085918 : AT(0x00086518) { build/asm/data/main_80085918.bin.o(.data); }
    .main_80085B84 0x80085B84 : AT(0x00086784) { build/asm/data/main_80085B84.bin.o(.data); }
    .main_80085E74 0x80085E74 : AT(0x00086A74) { build/asm/data/main_80085E74.bin.o(.data); }
    .main_800863FC 0x800863FC : AT(0x00086FFC) { build/asm/data/main_800863FC.bin.o(.data); }
    .main_80086488 0x80086488 : AT(0x00087088) { build/asm/data/main_80086488.bin.o(.data); }
    .main_800864DC 0x800864DC : AT(0x000870DC) { build/asm/data/main_800864DC.bin.o(.data); }
    .main_80086B04 0x80086B04 : AT(0x00087704) { build/asm/data/main_80086B04.bin.o(.data); }
    .main_80086C60 0x80086C60 : AT(0x00087860) { build/asm/data/main_80086C60.bin.o(.data); }
    .main_800888EC 0x800888EC : AT(0x000894EC) { build/asm/data/main_800888EC.bin.o(.data); }
    .main_800888F0 0x800888F0 : AT(0x000894F0) { build/asm/data/main_800888F0.bin.o(.data); }
    .main_80088F74 0x80088F74 : AT(0x00089B74) { build/asm/data/main_80088F74.bin.o(.data); }
    .main_80089438 0x80089438 : AT(0x0008A038) { build/asm/data/main_80089438.bin.o(.data); }
    .main_80089DF8 0x80089DF8 : AT(0x0008A9F8) { build/asm/data/main_80089DF8.bin.o(.data); }
    .main_80089E6C 0x80089E6C : AT(0x0008AA6C) { build/asm/data/main_80089E6C.bin.o(.data); }
    .main_8008AD34 0x8008AD34 : AT(0x0008B934) { build/asm/data/main_8008AD34.bin.o(.data); }
    .main_8008AED4 0x8008AED4 : AT(0x0008BAD4) { build/asm/data/main_8008AED4.bin.o(.data); }
    .main_8008FAEC 0x8008FAEC : AT(0x000906EC) { build/asm/data/main_8008FAEC.bin.o(.data); }
    .main_8008FBD8 0x8008FBD8 : AT(0x000907D8) { build/asm/data/main_8008FBD8.bin.o(.data); }
    .main_800903AC 0x800903AC : AT(0x00090FAC) { build/asm/data/main_800903AC.bin.o(.data); }
    .main_80090644 0x80090644 : AT(0x00091244) { build/asm/data/main_80090644.bin.o(.data); }
    .main_800915AC 0x800915AC : AT(0x000921AC) { build/asm/data/main_800915AC.bin.o(.data); }
    .main_800915CC 0x800915CC : AT(0x000921CC) { build/asm/data/main_800915CC.bin.o(.data); }
    .main_8009216C 0x8009216C : AT(0x00092D6C) { build/asm/data/main_8009216C.bin.o(.data); }
    .main_80092170 0x80092170 : AT(0x00092D70) { build/asm/data/main_80092170.bin.o(.data); }
    .main_800935F8 0x800935F8 : AT(0x000941F8) { build/asm/data/main_800935F8.bin.o(.data); }
    .main_80093610 0x80093610 : AT(0x00094210) { build/asm/data/main_80093610.bin.o(.data); }
    .main_800941A4 0x800941A4 : AT(0x00094DA4) { build/asm/data/main_800941A4.bin.o(.data); }
    .main_800944DC 0x800944DC : AT(0x000950DC) { build/asm/data/main_800944DC.bin.o(.data); }
    .main_80095B84 0x80095B84 : AT(0x00096784) { build/asm/data/main_80095B84.bin.o(.data); }
    .main_80095D50 0x80095D50 : AT(0x00096950) { build/asm/data/main_80095D50.bin.o(.data); }
    .main_800969DC 0x800969DC : AT(0x000975DC) { build/asm/data/main_800969DC.bin.o(.data); }
    .main_80096A54 0x80096A54 : AT(0x00097654) { build/asm/data/main_80096A54.bin.o(.data); }
    .main_80096FF4 0x80096FF4 : AT(0x00097BF4) { build/asm/data/main_80096FF4.bin.o(.data); }
    .main_8009700C 0x8009700C : AT(0x00097C0C) { build/asm/data/main_8009700C.bin.o(.data); }
    .main_80097270 0x80097270 : AT(0x00097E70) { build/asm/data/main_80097270.bin.o(.data); }
    .main_80097274 0x80097274 : AT(0x00097E74) { build/asm/data/main_80097274.bin.o(.data); }
    .main_80097BB0 0x80097BB0 : AT(0x000987B0) { build/asm/data/main_80097BB0.bin.o(.data); }
    .main_80097E38 0x80097E38 : AT(0x00098A38) { build/asm/data/main_80097E38.bin.o(.data); }
    .main_8009CB90 0x8009CB90 : AT(0x0009D790) { build/asm/data/main_8009CB90.bin.o(.data); }
    .main_8009CC00 0x8009CC00 : AT(0x0009D800) { build/asm/data/main_8009CC00.bin.o(.data); }
    .main_8009FAD8 0x8009FAD8 : AT(0x000A06D8) { build/asm/data/main_8009FAD8.bin.o(.data); }
    .main_8009FAEC 0x8009FAEC : AT(0x000A06EC) { build/asm/data/main_8009FAEC.bin.o(.data); }
    .main_800A005C 0x800A005C : AT(0x000A0C5C) { build/asm/data/main_800A005C.bin.o(.data); }
    .main_800A0080 0x800A0080 : AT(0x000A0C80) { build/asm/data/main_800A0080.bin.o(.data); }
    .main_800A0CE0 0x800A0CE0 : AT(0x000A18E0) { build/asm/data/main_800A0CE0.bin.o(.data); }
    .main_800A0D0C 0x800A0D0C : AT(0x000A190C) { build/asm/data/main_800A0D0C.bin.o(.data); }
    .main_800A14BC 0x800A14BC : AT(0x000A20BC) { build/asm/data/main_800A14BC.bin.o(.data); }
    .main_800A14D8 0x800A14D8 : AT(0x000A20D8) { build/asm/data/main_800A14D8.bin.o(.data); }
    .main_800A46E4 0x800A46E4 : AT(0x000A52E4) { build/asm/data/main_800A46E4.bin.o(.data); }
    .main_800A4780 0x800A4780 : AT(0x000A5380) { build/asm/data/main_800A4780.bin.o(.data); }
    .main_800A77D8 0x800A77D8 : AT(0x000A83D8) { build/asm/data/main_800A77D8.bin.o(.data); }
    .main_800A7C64 0x800A7C64 : AT(0x000A8864) { build/asm/data/main_800A7C64.bin.o(.data); }
    .main_800A7F20 0x800A7F20 : AT(0x000A8B20) { build/asm/data/main_800A7F20.bin.o(.data); }
    .main_800A8048 0x800A8048 : AT(0x000A8C48) { build/asm/data/main_800A8048.bin.o(.data); }
    .main_800A8D5C 0x800A8D5C : AT(0x000A995C) { build/asm/data/main_800A8D5C.bin.o(.data); }
    .main_800A8D6C 0x800A8D6C : AT(0x000A996C) { build/asm/data/main_800A8D6C.bin.o(.data); }
    .main_800A920C 0x800A920C : AT(0x000A9E0C) { build/asm/data/main_800A920C.bin.o(.data); }
    .main_800A9298 0x800A9298 : AT(0x000A9E98) { build/asm/data/main_800A9298.bin.o(.data); }
    .main_800A953C 0x800A953C : AT(0x000AA13C) { build/asm/data/main_800A953C.bin.o(.data); }
    .main_800A95D4 0x800A95D4 : AT(0x000AA1D4) { build/asm/data/main_800A95D4.bin.o(.data); }
    .main_800A9D18 0x800A9D18 : AT(0x000AA918) { build/asm/data/main_800A9D18.bin.o(.data); }
    .main_800A9F4C 0x800A9F4C : AT(0x000AAB4C) { build/asm/data/main_800A9F4C.bin.o(.data); }
    .main_800AA308 0x800AA308 : AT(0x000AAF08) { build/asm/data/main_800AA308.bin.o(.data); }
    .main_800AA6D8 0x800AA6D8 : AT(0x000AB2D8) { build/asm/data/main_800AA6D8.bin.o(.data); }
    .main_800AA9B8 0x800AA9B8 : AT(0x000AB5B8) { build/asm/data/main_800AA9B8.bin.o(.data); }
    .main_800AAA0C 0x800AAA0C : AT(0x000AB60C) { build/asm/data/main_800AAA0C.bin.o(.data); }
    .main_800AAAC4 0x800AAAC4 : AT(0x000AB6C4) { build/asm/data/main_800AAAC4.bin.o(.data); }
    .main_800AABA0 0x800AABA0 : AT(0x000AB7A0) { build/asm/data/main_800AABA0.bin.o(.data); }
    .main_800AB8E8 0x800AB8E8 : AT(0x000AC4E8) { build/asm/data/main_800AB8E8.bin.o(.data); }
    .main_800ABAA0 0x800ABAA0 : AT(0x000AC6A0) { build/asm/data/main_800ABAA0.bin.o(.data); }
    .main_800AD1F4 0x800AD1F4 : AT(0x000ADDF4) { build/asm/data/main_800AD1F4.bin.o(.data); }
    .main_800AD1F8 0x800AD1F8 : AT(0x000ADDF8) { build/asm/data/main_800AD1F8.bin.o(.data); }
    .main_800ADB68 0x800ADB68 : AT(0x000AE768) { build/asm/data/main_800ADB68.bin.o(.data); }
    .main_800ADBB4 0x800ADBB4 : AT(0x000AE7B4) { build/asm/data/main_800ADBB4.bin.o(.data); }
    .main_800AF7B0 0x800AF7B0 : AT(0x000B03B0) { build/asm/data/main_800AF7B0.bin.o(.data); }
    .main_800AF7CC 0x800AF7CC : AT(0x000B03CC) { build/asm/data/main_800AF7CC.bin.o(.data); }
    .main_800AF904 0x800AF904 : AT(0x000B0504) { build/asm/data/main_800AF904.bin.o(.data); }
    .main_800AF960 0x800AF960 : AT(0x000B0560) { build/asm/data/main_800AF960.bin.o(.data); }
    .main_800AFE90 0x800AFE90 : AT(0x000B0A90) { build/asm/data/main_800AFE90.bin.o(.data); }
    .main_800AFEB0 0x800AFEB0 : AT(0x000B0AB0) { build/asm/data/main_800AFEB0.bin.o(.data); }
    .main_800B104C 0x800B104C : AT(0x000B1C4C) { build/asm/data/main_800B104C.bin.o(.data); }
    .main_800B13A0 0x800B13A0 : AT(0x000B1FA0) { build/asm/data/main_800B13A0.bin.o(.data); }
    .main_800B1AB4 0x800B1AB4 : AT(0x000B26B4) { build/asm/data/main_800B1AB4.bin.o(.data); }
    .main_800B1AF0 0x800B1AF0 : AT(0x000B26F0) { build/asm/data/main_800B1AF0.bin.o(.data); }
    .main_800B1C2C 0x800B1C2C : AT(0x000B282C) { build/asm/data/main_800B1C2C.bin.o(.data); }
    .main_800B1C48 0x800B1C48 : AT(0x000B2848) { build/asm/data/main_800B1C48.bin.o(.data); }
    .main_800B1DBC 0x800B1DBC : AT(0x000B29BC) { build/asm/data/main_800B1DBC.bin.o(.data); }
    .main_800B1EB8 0x800B1EB8 : AT(0x000B2AB8) { build/asm/data/main_800B1EB8.bin.o(.data); }
    .main_800B2018 0x800B2018 : AT(0x000B2C18) { build/asm/data/main_800B2018.bin.o(.data); }
    .main_800B201C 0x800B201C : AT(0x000B2C1C) { build/asm/data/main_800B201C.bin.o(.data); }
    .main_800B2108 0x800B2108 : AT(0x000B2D08) { build/asm/data/main_800B2108.bin.o(.data); }
    .main_800B2170 0x800B2170 : AT(0x000B2D70) { build/asm/data/main_800B2170.bin.o(.data); }
    .main_800B2260 0x800B2260 : AT(0x000B2E60) { build/asm/data/main_800B2260.bin.o(.data); }
    .main_800B2604 0x800B2604 : AT(0x000B3204) { build/asm/data/main_800B2604.bin.o(.data); }
    .main_800B2E04 0x800B2E04 : AT(0x000B3A04) { build/asm/data/main_800B2E04.bin.o(.data); }
    .main_800B2FF8 0x800B2FF8 : AT(0x000B3BF8) { build/asm/data/main_800B2FF8.bin.o(.data); }
    .main_800B4810 0x800B4810 : AT(0x000B5410) { build/asm/data/main_800B4810.bin.o(.data); }
    .main_800B482C 0x800B482C : AT(0x000B542C) { build/asm/data/main_800B482C.bin.o(.data); }
    .main_800B7410 0x800B7410 : AT(0x000B8010) { build/asm/data/main_800B7410.bin.o(.data); }
    .main_800B7680 0x800B7680 : AT(0x000B8280) { build/asm/data/main_800B7680.bin.o(.data); }
    .main_800B87A8 0x800B87A8 : AT(0x000B93A8) { build/asm/data/main_800B87A8.bin.o(.data); }
    .main_800B87F0 0x800B87F0 : AT(0x000B93F0) { build/asm/data/main_800B87F0.bin.o(.data); }
    .main_800B91B8 0x800B91B8 : AT(0x000B9DB8) { build/asm/data/main_800B91B8.bin.o(.data); }
    .main_800B94E8 0x800B94E8 : AT(0x000BA0E8) { build/asm/data/main_800B94E8.bin.o(.data); }
    .main_800BCAE0 0x800BCAE0 : AT(0x000BD6E0) { build/asm/data/main_800BCAE0.bin.o(.data); }
    .main_800BCAF4 0x800BCAF4 : AT(0x000BD6F4) { build/asm/data/main_800BCAF4.bin.o(.data); }
    .main_800BDAD0 0x800BDAD0 : AT(0x000BE6D0) { build/asm/data/main_800BDAD0.bin.o(.data); }
    .main_800BDB9C 0x800BDB9C : AT(0x000BE79C) { build/asm/data/main_800BDB9C.bin.o(.data); }
    .main_800BE114 0x800BE114 : AT(0x000BED14) { build/asm/data/main_800BE114.bin.o(.data); }
    .main_800BE1DC 0x800BE1DC : AT(0x000BEDDC) { build/asm/data/main_800BE1DC.bin.o(.data); }
    .main_800BE1F0 0x800BE1F0 : AT(0x000BEDF0) { build/asm/data/main_800BE1F0.bin.o(.data); }
    .main_800BE318 0x800BE318 : AT(0x000BEF18) { build/asm/data/main_800BE318.bin.o(.data); }
    .main_800BE7C8 0x800BE7C8 : AT(0x000BF3C8) { build/asm/data/main_800BE7C8.bin.o(.data); }
    .main_800BE808 0x800BE808 : AT(0x000BF408) { build/asm/data/main_800BE808.bin.o(.data); }
    .main_800BF5C8 0x800BF5C8 : AT(0x000C01C8) { build/asm/data/main_800BF5C8.bin.o(.data); }
    .main_800BF5D0 0x800BF5D0 : AT(0x000C01D0) { build/asm/data/main_800BF5D0.bin.o(.data); }
    .main_800BF7AC 0x800BF7AC : AT(0x000C03AC) { build/asm/data/main_800BF7AC.bin.o(.data); }
    .main_800BF91C 0x800BF91C : AT(0x000C051C) { build/asm/data/main_800BF91C.bin.o(.data); }
    .main_800C105C 0x800C105C : AT(0x000C1C5C) { build/asm/data/main_800C105C.bin.o(.data); }
    .main_800C1064 0x800C1064 : AT(0x000C1C64) { build/asm/data/main_800C1064.bin.o(.data); }
    .main_800C1C64 0x800C1C64 : AT(0x000C2864) { build/asm/data/main_800C1C64.bin.o(.data); }
    .main_800C1C6C 0x800C1C6C : AT(0x000C286C) { build/asm/data/main_800C1C6C.bin.o(.data); }
    .main_800C34B8 0x800C34B8 : AT(0x000C40B8) { build/asm/data/main_800C34B8.bin.o(.data); }
    .main_800C3844 0x800C3844 : AT(0x000C4444) { build/asm/data/main_800C3844.bin.o(.data); }
    .main_800C40D4 0x800C40D4 : AT(0x000C4CD4) { build/asm/data/main_800C40D4.bin.o(.data); }
    .main_800C43D0 0x800C43D0 : AT(0x000C4FD0) { build/asm/data/main_800C43D0.bin.o(.data); }
    .main_800C637C 0x800C637C : AT(0x000C6F7C) { build/asm/data/main_800C637C.bin.o(.data); }
    .main_800C63B4 0x800C63B4 : AT(0x000C6FB4) { build/asm/data/main_800C63B4.bin.o(.data); }
    .main_800C6B68 0x800C6B68 : AT(0x000C7768) { build/asm/data/main_800C6B68.bin.o(.data); }
    .main_800C6B6C 0x800C6B6C : AT(0x000C776C) { build/asm/data/main_800C6B6C.bin.o(.data); }
    .main_800CB328 0x800CB328 : AT(0x000CBF28) { build/asm/data/main_800CB328.bin.o(.data); }
    .main_800CB32C 0x800CB32C : AT(0x000CBF2C) { build/asm/data/main_800CB32C.bin.o(.data); }
    .main_800CB360 0x800CB360 : AT(0x000CBF60) { build/asm/data/main_800CB360.bin.o(.data); }
    .main_800CB364 0x800CB364 : AT(0x000CBF64) { build/asm/data/main_800CB364.bin.o(.data); }
    .main_800CB6B0 0x800CB6B0 : AT(0x000CC2B0) { build/asm/data/main_800CB6B0.bin.o(.data); }
    .main_800CB6BC 0x800CB6BC : AT(0x000CC2BC) { build/asm/data/main_800CB6BC.bin.o(.data); }
    .main_800CD324 0x800CD324 : AT(0x000CDF24) { build/asm/data/main_800CD324.bin.o(.data); }
    .main_800CD338 0x800CD338 : AT(0x000CDF38) { build/asm/data/main_800CD338.bin.o(.data); }
    .main_800D1C68 0x800D1C68 : AT(0x000D2868) { build/asm/data/main_800D1C68.bin.o(.data); }
    .main_800D1C70 0x800D1C70 : AT(0x000D2870) { build/asm/data/main_800D1C70.bin.o(.data); }
    .main_800D22AC 0x800D22AC : AT(0x000D2EAC) { build/asm/data/main_800D22AC.bin.o(.data); }
    .main_800D2B30 0x800D2B30 : AT(0x000D3730) { build/asm/data/main_800D2B30.bin.o(.data); }
    .main_800D38B4 0x800D38B4 : AT(0x000D44B4) { build/asm/data/main_800D38B4.bin.o(.data); }
    .main_800D38C0 0x800D38C0 : AT(0x000D44C0) { build/asm/data/main_800D38C0.bin.o(.data); }
    .main_800D41A4 0x800D41A4 : AT(0x000D4DA4) { build/asm/data/main_800D41A4.bin.o(.data); }
    .main_800D41FC 0x800D41FC : AT(0x000D4DFC) { build/asm/data/main_800D41FC.bin.o(.data); }
    .main_800D45F0 0x800D45F0 : AT(0x000D51F0) { build/asm/data/main_800D45F0.bin.o(.data); }
    .main_800D4604 0x800D4604 : AT(0x000D5204) { build/asm/data/main_800D4604.bin.o(.data); }
    .main_800D4DCC 0x800D4DCC : AT(0x000D59CC) { build/asm/data/main_800D4DCC.bin.o(.data); }
    .main_800D4DD4 0x800D4DD4 : AT(0x000D59D4) { build/asm/data/main_800D4DD4.bin.o(.data); }
    .main_800D4F44 0x800D4F44 : AT(0x000D5B44) { build/asm/data/main_800D4F44.bin.o(.data); }
    .main_800D50C4 0x800D50C4 : AT(0x000D5CC4) { build/asm/data/main_800D50C4.bin.o(.data); }
    .main_800D56F8 0x800D56F8 : AT(0x000D62F8) { build/asm/data/main_800D56F8.bin.o(.data); }
    .main_800D57A0 0x800D57A0 : AT(0x000D63A0) { build/asm/data/main_800D57A0.bin.o(.data); }
    .main_800D58D0 0x800D58D0 : AT(0x000D64D0) { build/asm/data/main_800D58D0.bin.o(.data); }
    .main_800D5B1C 0x800D5B1C : AT(0x000D671C) { build/asm/data/main_800D5B1C.bin.o(.data); }
    .main_800D5E18 0x800D5E18 : AT(0x000D6A18) { build/asm/data/main_800D5E18.bin.o(.data); }
    .main_800D5F0C 0x800D5F0C : AT(0x000D6B0C) { build/asm/data/main_800D5F0C.bin.o(.data); }
    .main_800D6424 0x800D6424 : AT(0x000D7024) { build/asm/data/main_800D6424.bin.o(.data); }
    .main_800D67D0 0x800D67D0 : AT(0x000D73D0) { build/asm/data/main_800D67D0.bin.o(.data); }
    .main_800D7E84 0x800D7E84 : AT(0x000D8A84) { build/asm/data/main_800D7E84.bin.o(.data); }
    .main_800D7EB8 0x800D7EB8 : AT(0x000D8AB8) { build/asm/data/main_800D7EB8.bin.o(.data); }
    .main_800D9360 0x800D9360 : AT(0x000D9F60) { build/asm/data/main_800D9360.bin.o(.data); }
    .main_800D936C 0x800D936C : AT(0x000D9F6C) { build/asm/data/main_800D936C.bin.o(.data); }
    .main_800DC0A0 0x800DC0A0 : AT(0x000DCCA0) { build/asm/data/main_800DC0A0.bin.o(.data); }
    .main_800DC160 0x800DC160 : AT(0x000DCD60) { build/asm/data/main_800DC160.bin.o(.data); }
    .main_800DE478 0x800DE478 : AT(0x000DF078) { build/asm/data/main_800DE478.bin.o(.data); }
    .main_800DE480 0x800DE480 : AT(0x000DF080) { build/asm/data/main_800DE480.bin.o(.data); }
    .main_800E0BB4 0x800E0BB4 : AT(0x000E17B4) { build/asm/data/main_800E0BB4.bin.o(.data); }
    .main_800E0BDC 0x800E0BDC : AT(0x000E17DC) { build/asm/data/main_800E0BDC.bin.o(.data); }
    .main_800E0CD4 0x800E0CD4 : AT(0x000E18D4) { build/asm/data/main_800E0CD4.bin.o(.data); }
    .main_800E1438 0x800E1438 : AT(0x000E2038) { build/asm/data/main_800E1438.bin.o(.data); }
    .main_800E21B0 0x800E21B0 : AT(0x000E2DB0) { build/asm/data/main_800E21B0.bin.o(.data); }
    .main_800E21D8 0x800E21D8 : AT(0x000E2DD8) { build/asm/data/main_800E21D8.bin.o(.data); }
    .main_800E4698 0x800E4698 : AT(0x000E5298) { build/asm/data/main_800E4698.bin.o(.data); }
    .main_800E46D0 0x800E46D0 : AT(0x000E52D0) { build/asm/data/main_800E46D0.bin.o(.data); }
    .main_800E6058 0x800E6058 : AT(0x000E6C58) { build/asm/data/main_800E6058.bin.o(.data); }
    .main_800E6514 0x800E6514 : AT(0x000E7114) { build/asm/data/main_800E6514.bin.o(.data); }
    .main_800E6B6C 0x800E6B6C : AT(0x000E776C) { build/asm/data/main_800E6B6C.bin.o(.data); }
    .main_800E6BAC 0x800E6BAC : AT(0x000E77AC) { build/asm/data/main_800E6BAC.bin.o(.data); }
    .main_800E6E7C 0x800E6E7C : AT(0x000E7A7C) { build/asm/data/main_800E6E7C.bin.o(.data); }
    .main_800E6E80 0x800E6E80 : AT(0x000E7A80) { build/asm/data/main_800E6E80.bin.o(.data); }
    .main_800E709C 0x800E709C : AT(0x000E7C9C) { build/asm/data/main_800E709C.bin.o(.data); }
    .main_800E7144 0x800E7144 : AT(0x000E7D44) { build/asm/data/main_800E7144.bin.o(.data); }
    .main_800E7B2C 0x800E7B2C : AT(0x000E872C) { build/asm/data/main_800E7B2C.bin.o(.data); }
    .main_800E7CA0 0x800E7CA0 : AT(0x000E88A0) { build/asm/data/main_800E7CA0.bin.o(.data); }
    .main_800E835C 0x800E835C : AT(0x000E8F5C) { build/asm/data/main_800E835C.bin.o(.data); }
    .main_800E8384 0x800E8384 : AT(0x000E8F84) { build/asm/data/main_800E8384.bin.o(.data); }
    .main_800E88AC 0x800E88AC : AT(0x000E94AC) { build/asm/data/main_800E88AC.bin.o(.data); }
    .main_800E88CC 0x800E88CC : AT(0x000E94CC) { build/asm/data/main_800E88CC.bin.o(.data); }
    .main_800E9AD4 0x800E9AD4 : AT(0x000EA6D4) { build/asm/data/main_800E9AD4.bin.o(.data); }
    .main_800E9B14 0x800E9B14 : AT(0x000EA714) { build/asm/data/main_800E9B14.bin.o(.data); }
    .main_800EADAC 0x800EADAC : AT(0x000EB9AC) { build/asm/data/main_800EADAC.bin.o(.data); }
    .main_800EAF00 0x800EAF00 : AT(0x000EBB00) { build/asm/data/main_800EAF00.bin.o(.data); }
    .main_800EBEB4 0x800EBEB4 : AT(0x000ECAB4) { build/asm/data/main_800EBEB4.bin.o(.data); }
    .main_800EC378 0x800EC378 : AT(0x000ECF78) { build/asm/data/main_800EC378.bin.o(.data); }
    .main_800EC53C 0x800EC53C : AT(0x000ED13C) { build/asm/data/main_800EC53C.bin.o(.data); }
    .main_800EC590 0x800EC590 : AT(0x000ED190) { build/asm/data/main_800EC590.bin.o(.data); }
    .main_800EC884 0x800EC884 : AT(0x000ED484) { build/asm/data/main_800EC884.bin.o(.data); }
    .main_800EC970 0x800EC970 : AT(0x000ED570) { build/asm/data/main_800EC970.bin.o(.data); }
    .main_800F07F0 0x800F07F0 : AT(0x000F13F0) { build/asm/data/main_800F07F0.bin.o(.data); }
    .main_800F0858 0x800F0858 : AT(0x000F1458) { build/asm/data/main_800F0858.bin.o(.data); }
    .main_800F09F4 0x800F09F4 : AT(0x000F15F4) { build/asm/data/main_800F09F4.bin.o(.data); }
    .main_800F0AFC 0x800F0AFC : AT(0x000F16FC) { build/asm/data/main_800F0AFC.bin.o(.data); }
    .main_800F1824 0x800F1824 : AT(0x000F2424) { build/asm/data/main_800F1824.bin.o(.data); }
    .main_800F1830 0x800F1830 : AT(0x000F2430) { build/asm/data/main_800F1830.bin.o(.data); }
    .main_800F2E90 0x800F2E90 : AT(0x000F3A90) { build/asm/data/main_800F2E90.bin.o(.data); }
    .main_800F2ED4 0x800F2ED4 : AT(0x000F3AD4) { build/asm/data/main_800F2ED4.bin.o(.data); }
    .main_800F389C 0x800F389C : AT(0x000F449C) { build/asm/data/main_800F389C.bin.o(.data); }
    .main_800F38B4 0x800F38B4 : AT(0x000F44B4) { build/asm/data/main_800F38B4.bin.o(.data); }
    .main_800F3DBC 0x800F3DBC : AT(0x000F49BC) { build/asm/data/main_800F3DBC.bin.o(.data); }
    .main_800F3E68 0x800F3E68 : AT(0x000F4A68) { build/asm/data/main_800F3E68.bin.o(.data); }
    .main_800F56F8 0x800F56F8 : AT(0x000F62F8) { build/asm/data/main_800F56F8.bin.o(.data); }
    .main_800F5838 0x800F5838 : AT(0x000F6438) { build/asm/data/main_800F5838.bin.o(.data); }
    .main_800F65C8 0x800F65C8 : AT(0x000F71C8) { build/asm/data/main_800F65C8.bin.o(.data); }
    .main_800F66EC 0x800F66EC : AT(0x000F72EC) { build/asm/data/main_800F66EC.bin.o(.data); }
    .main_800F9024 0x800F9024 : AT(0x000F9C24) { build/asm/data/main_800F9024.bin.o(.data); }
    .main_800F903C 0x800F903C : AT(0x000F9C3C) { build/asm/data/main_800F903C.bin.o(.data); }
    .main_800FCF4C 0x800FCF4C : AT(0x000FDB4C) { build/asm/data/main_800FCF4C.bin.o(.data); }
    .main_800FCFB4 0x800FCFB4 : AT(0x000FDBB4) { build/asm/data/main_800FCFB4.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
