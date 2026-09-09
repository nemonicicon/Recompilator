SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000480 0x80000480 : AT(0x00001080) { FILL(0x00000000); build/asm/main_80000480.s.o(.text); build/asm/main_80000480.s.o(.rodata); build/asm/main_80000480.s.o(.data); }
    .main_80000480_bss (NOLOAD) : { build/asm/main_80000480.s.o(.bss); }
    .main_80003B00 0x80003B00 : AT(0x00004700) { FILL(0x00000000); build/asm/main_80003B00.s.o(.text); build/asm/main_80003B00.s.o(.rodata); build/asm/main_80003B00.s.o(.data); }
    .main_80003B00_bss (NOLOAD) : { build/asm/main_80003B00.s.o(.bss); }
    .main_80004038 0x80004038 : AT(0x00004C38) { FILL(0x00000000); build/asm/main_80004038.s.o(.text); build/asm/main_80004038.s.o(.rodata); build/asm/main_80004038.s.o(.data); }
    .main_80004038_bss (NOLOAD) : { build/asm/main_80004038.s.o(.bss); }
    .main_80008838 0x80008838 : AT(0x00009438) { FILL(0x00000000); build/asm/main_80008838.s.o(.text); build/asm/main_80008838.s.o(.rodata); build/asm/main_80008838.s.o(.data); }
    .main_80008838_bss (NOLOAD) : { build/asm/main_80008838.s.o(.bss); }
    .main_8000A2D0 0x8000A2D0 : AT(0x0000AED0) { FILL(0x00000000); build/asm/main_8000A2D0.s.o(.text); build/asm/main_8000A2D0.s.o(.rodata); build/asm/main_8000A2D0.s.o(.data); }
    .main_8000A2D0_bss (NOLOAD) : { build/asm/main_8000A2D0.s.o(.bss); }
    .main_8000B568 0x8000B568 : AT(0x0000C168) { build/asm/data/main_8000B568.bin.o(.data); }
    .main_8000B840 0x8000B840 : AT(0x0000C440) { FILL(0x00000000); build/asm/main_8000B840.s.o(.text); build/asm/main_8000B840.s.o(.rodata); build/asm/main_8000B840.s.o(.data); }
    .main_8000B840_bss (NOLOAD) : { build/asm/main_8000B840.s.o(.bss); }
    .main_8000BC00 0x8000BC00 : AT(0x0000C800) { FILL(0x00000000); build/asm/main_8000BC00.s.o(.text); build/asm/main_8000BC00.s.o(.rodata); build/asm/main_8000BC00.s.o(.data); }
    .main_8000BC00_bss (NOLOAD) : { build/asm/main_8000BC00.s.o(.bss); }
    .main_8000CE8C 0x8000CE8C : AT(0x0000DA8C) { FILL(0x00000000); build/asm/main_8000CE8C.s.o(.text); build/asm/main_8000CE8C.s.o(.rodata); build/asm/main_8000CE8C.s.o(.data); }
    .main_8000CE8C_bss (NOLOAD) : { build/asm/main_8000CE8C.s.o(.bss); }
    .main_8000E204 0x8000E204 : AT(0x0000EE04) { build/asm/data/main_8000E204.bin.o(.data); }
    .main_8000E5D0 0x8000E5D0 : AT(0x0000F1D0) { FILL(0x00000000); build/asm/main_8000E5D0.s.o(.text); build/asm/main_8000E5D0.s.o(.rodata); build/asm/main_8000E5D0.s.o(.data); }
    .main_8000E5D0_bss (NOLOAD) : { build/asm/main_8000E5D0.s.o(.bss); }
    .main_8000F740 0x8000F740 : AT(0x00010340) { FILL(0x00000000); build/asm/main_8000F740.s.o(.text); build/asm/main_8000F740.s.o(.rodata); build/asm/main_8000F740.s.o(.data); }
    .main_8000F740_bss (NOLOAD) : { build/asm/main_8000F740.s.o(.bss); }
    .main_800103E4 0x800103E4 : AT(0x00010FE4) { build/asm/data/main_800103E4.bin.o(.data); }
    .main_80010480 0x80010480 : AT(0x00011080) { FILL(0x00000000); build/asm/main_80010480.s.o(.text); build/asm/main_80010480.s.o(.rodata); build/asm/main_80010480.s.o(.data); }
    .main_80010480_bss (NOLOAD) : { build/asm/main_80010480.s.o(.bss); }
    .main_80013BB8 0x80013BB8 : AT(0x000147B8) { FILL(0x00000000); build/asm/main_80013BB8.s.o(.text); build/asm/main_80013BB8.s.o(.rodata); build/asm/main_80013BB8.s.o(.data); }
    .main_80013BB8_bss (NOLOAD) : { build/asm/main_80013BB8.s.o(.bss); }
    .main_80013F34 0x80013F34 : AT(0x00014B34) { FILL(0x00000000); build/asm/main_80013F34.s.o(.text); build/asm/main_80013F34.s.o(.rodata); build/asm/main_80013F34.s.o(.data); }
    .main_80013F34_bss (NOLOAD) : { build/asm/main_80013F34.s.o(.bss); }
    .main_80013FC8 0x80013FC8 : AT(0x00014BC8) { build/asm/data/main_80013FC8.bin.o(.data); }
    .main_80014124 0x80014124 : AT(0x00014D24) { FILL(0x00000000); build/asm/main_80014124.s.o(.text); build/asm/main_80014124.s.o(.rodata); build/asm/main_80014124.s.o(.data); }
    .main_80014124_bss (NOLOAD) : { build/asm/main_80014124.s.o(.bss); }
    .main_80016140 0x80016140 : AT(0x00016D40) { build/asm/data/main_80016140.bin.o(.data); }
    .main_80016280 0x80016280 : AT(0x00016E80) { FILL(0x00000000); build/asm/main_80016280.s.o(.text); build/asm/main_80016280.s.o(.rodata); build/asm/main_80016280.s.o(.data); }
    .main_80016280_bss (NOLOAD) : { build/asm/main_80016280.s.o(.bss); }
    .main_80017B98 0x80017B98 : AT(0x00018798) { build/asm/data/main_80017B98.bin.o(.data); }
    .main_800181C0 0x800181C0 : AT(0x00018DC0) { FILL(0x00000000); build/asm/main_800181C0.s.o(.text); build/asm/main_800181C0.s.o(.rodata); build/asm/main_800181C0.s.o(.data); }
    .main_800181C0_bss (NOLOAD) : { build/asm/main_800181C0.s.o(.bss); }
    .main_80018BD8 0x80018BD8 : AT(0x000197D8) { FILL(0x00000000); build/asm/main_80018BD8.s.o(.text); build/asm/main_80018BD8.s.o(.rodata); build/asm/main_80018BD8.s.o(.data); }
    .main_80018BD8_bss (NOLOAD) : { build/asm/main_80018BD8.s.o(.bss); }
    .main_80018C2C 0x80018C2C : AT(0x0001982C) { build/asm/data/main_80018C2C.bin.o(.data); }
    .main_80018C40 0x80018C40 : AT(0x00019840) { FILL(0x00000000); build/asm/main_80018C40.s.o(.text); build/asm/main_80018C40.s.o(.rodata); build/asm/main_80018C40.s.o(.data); }
    .main_80018C40_bss (NOLOAD) : { build/asm/main_80018C40.s.o(.bss); }
    .main_800193DC 0x800193DC : AT(0x00019FDC) { build/asm/data/main_800193DC.bin.o(.data); }
    .main_80019638 0x80019638 : AT(0x0001A238) { FILL(0x00000000); build/asm/main_80019638.s.o(.text); build/asm/main_80019638.s.o(.rodata); build/asm/main_80019638.s.o(.data); }
    .main_80019638_bss (NOLOAD) : { build/asm/main_80019638.s.o(.bss); }
    .main_80019A10 0x80019A10 : AT(0x0001A610) { build/asm/data/main_80019A10.bin.o(.data); }
    .main_80019A40 0x80019A40 : AT(0x0001A640) { FILL(0x00000000); build/asm/main_80019A40.s.o(.text); build/asm/main_80019A40.s.o(.rodata); build/asm/main_80019A40.s.o(.data); }
    .main_80019A40_bss (NOLOAD) : { build/asm/main_80019A40.s.o(.bss); }
    .main_8001BE04 0x8001BE04 : AT(0x0001CA04) { build/asm/data/main_8001BE04.bin.o(.data); }
    .main_8001BEC0 0x8001BEC0 : AT(0x0001CAC0) { FILL(0x00000000); build/asm/main_8001BEC0.s.o(.text); build/asm/main_8001BEC0.s.o(.rodata); build/asm/main_8001BEC0.s.o(.data); }
    .main_8001BEC0_bss (NOLOAD) : { build/asm/main_8001BEC0.s.o(.bss); }
    .main_8001C734 0x8001C734 : AT(0x0001D334) { FILL(0x00000000); build/asm/main_8001C734.s.o(.text); build/asm/main_8001C734.s.o(.rodata); build/asm/main_8001C734.s.o(.data); }
    .main_8001C734_bss (NOLOAD) : { build/asm/main_8001C734.s.o(.bss); }
    .main_8001E5F4 0x8001E5F4 : AT(0x0001F1F4) { build/asm/data/main_8001E5F4.bin.o(.data); }
    .main_8001EB40 0x8001EB40 : AT(0x0001F740) { FILL(0x00000000); build/asm/main_8001EB40.s.o(.text); build/asm/main_8001EB40.s.o(.rodata); build/asm/main_8001EB40.s.o(.data); }
    .main_8001EB40_bss (NOLOAD) : { build/asm/main_8001EB40.s.o(.bss); }
    .main_800222A4 0x800222A4 : AT(0x00022EA4) { build/asm/data/main_800222A4.bin.o(.data); }
    .main_8002249C 0x8002249C : AT(0x0002309C) { FILL(0x00000000); build/asm/main_8002249C.s.o(.text); build/asm/main_8002249C.s.o(.rodata); build/asm/main_8002249C.s.o(.data); }
    .main_8002249C_bss (NOLOAD) : { build/asm/main_8002249C.s.o(.bss); }
    .main_80024D10 0x80024D10 : AT(0x00025910) { build/asm/data/main_80024D10.bin.o(.data); }
    .main_80024DC0 0x80024DC0 : AT(0x000259C0) { FILL(0x00000000); build/asm/main_80024DC0.s.o(.text); build/asm/main_80024DC0.s.o(.rodata); build/asm/main_80024DC0.s.o(.data); }
    .main_80024DC0_bss (NOLOAD) : { build/asm/main_80024DC0.s.o(.bss); }
    .main_80027614 0x80027614 : AT(0x00028214) { FILL(0x00000000); build/asm/main_80027614.s.o(.text); build/asm/main_80027614.s.o(.rodata); build/asm/main_80027614.s.o(.data); }
    .main_80027614_bss (NOLOAD) : { build/asm/main_80027614.s.o(.bss); }
    .main_80027998 0x80027998 : AT(0x00028598) { FILL(0x00000000); build/asm/main_80027998.s.o(.text); build/asm/main_80027998.s.o(.rodata); build/asm/main_80027998.s.o(.data); }
    .main_80027998_bss (NOLOAD) : { build/asm/main_80027998.s.o(.bss); }
    .main_8002A97C 0x8002A97C : AT(0x0002B57C) { build/asm/data/main_8002A97C.bin.o(.data); }
    .main_8002A9C0 0x8002A9C0 : AT(0x0002B5C0) { FILL(0x00000000); build/asm/main_8002A9C0.s.o(.text); build/asm/main_8002A9C0.s.o(.rodata); build/asm/main_8002A9C0.s.o(.data); }
    .main_8002A9C0_bss (NOLOAD) : { build/asm/main_8002A9C0.s.o(.bss); }
    .main_8002CAAC 0x8002CAAC : AT(0x0002D6AC) { build/asm/data/main_8002CAAC.bin.o(.data); }
    .main_8002CED0 0x8002CED0 : AT(0x0002DAD0) { FILL(0x00000000); build/asm/main_8002CED0.s.o(.text); build/asm/main_8002CED0.s.o(.rodata); build/asm/main_8002CED0.s.o(.data); }
    .main_8002CED0_bss (NOLOAD) : { build/asm/main_8002CED0.s.o(.bss); }
    .main_80031330 0x80031330 : AT(0x00031F30) { FILL(0x00000000); build/asm/main_80031330.s.o(.text); build/asm/main_80031330.s.o(.rodata); build/asm/main_80031330.s.o(.data); }
    .main_80031330_bss (NOLOAD) : { build/asm/main_80031330.s.o(.bss); }
    .main_8003176C 0x8003176C : AT(0x0003236C) { FILL(0x00000000); build/asm/main_8003176C.s.o(.text); build/asm/main_8003176C.s.o(.rodata); build/asm/main_8003176C.s.o(.data); }
    .main_8003176C_bss (NOLOAD) : { build/asm/main_8003176C.s.o(.bss); }
    .main_800364FC 0x800364FC : AT(0x000370FC) { build/asm/data/main_800364FC.bin.o(.data); }
    .main_800384F8 0x800384F8 : AT(0x000390F8) { build/asm/data/main_800384F8.bin.o(.data); }
    .main_8003929C 0x8003929C : AT(0x00039E9C) { FILL(0x00000000); build/asm/main_8003929C.s.o(.text); build/asm/main_8003929C.s.o(.rodata); build/asm/main_8003929C.s.o(.data); }
    .main_8003929C_bss (NOLOAD) : { build/asm/main_8003929C.s.o(.bss); }
    .main_8003B0F0 0x8003B0F0 : AT(0x0003BCF0) { build/asm/data/main_8003B0F0.bin.o(.data); }
    .main_8003B840 0x8003B840 : AT(0x0003C440) { FILL(0x00000000); build/asm/main_8003B840.s.o(.text); build/asm/main_8003B840.s.o(.rodata); build/asm/main_8003B840.s.o(.data); }
    .main_8003B840_bss (NOLOAD) : { build/asm/main_8003B840.s.o(.bss); }
    .main_8003C1F0 0x8003C1F0 : AT(0x0003CDF0) { FILL(0x00000000); build/asm/main_8003C1F0.s.o(.text); build/asm/main_8003C1F0.s.o(.rodata); build/asm/main_8003C1F0.s.o(.data); }
    .main_8003C1F0_bss (NOLOAD) : { build/asm/main_8003C1F0.s.o(.bss); }
    .main_8003C280 0x8003C280 : AT(0x0003CE80) { FILL(0x00000000); build/asm/main_8003C280.s.o(.text); build/asm/main_8003C280.s.o(.rodata); build/asm/main_8003C280.s.o(.data); }
    .main_8003C280_bss (NOLOAD) : { build/asm/main_8003C280.s.o(.bss); }
    .main_8003C600 0x8003C600 : AT(0x0003D200) { FILL(0x00000000); build/asm/main_8003C600.s.o(.text); build/asm/main_8003C600.s.o(.rodata); build/asm/main_8003C600.s.o(.data); }
    .main_8003C600_bss (NOLOAD) : { build/asm/main_8003C600.s.o(.bss); }
    .main_8003C700 0x8003C700 : AT(0x0003D300) { FILL(0x00000000); build/asm/main_8003C700.s.o(.text); build/asm/main_8003C700.s.o(.rodata); build/asm/main_8003C700.s.o(.data); }
    .main_8003C700_bss (NOLOAD) : { build/asm/main_8003C700.s.o(.bss); }
    .main_8003C880 0x8003C880 : AT(0x0003D480) { FILL(0x00000000); build/asm/main_8003C880.s.o(.text); build/asm/main_8003C880.s.o(.rodata); build/asm/main_8003C880.s.o(.data); }
    .main_8003C880_bss (NOLOAD) : { build/asm/main_8003C880.s.o(.bss); }
    .main_8003C8C0 0x8003C8C0 : AT(0x0003D4C0) { FILL(0x00000000); build/asm/main_8003C8C0.s.o(.text); build/asm/main_8003C8C0.s.o(.rodata); build/asm/main_8003C8C0.s.o(.data); }
    .main_8003C8C0_bss (NOLOAD) : { build/asm/main_8003C8C0.s.o(.bss); }
    .main_8003D1C4 0x8003D1C4 : AT(0x0003DDC4) { FILL(0x00000000); build/asm/main_8003D1C4.s.o(.text); build/asm/main_8003D1C4.s.o(.rodata); build/asm/main_8003D1C4.s.o(.data); }
    .main_8003D1C4_bss (NOLOAD) : { build/asm/main_8003D1C4.s.o(.bss); }
    .main_8003D380 0x8003D380 : AT(0x0003DF80) { FILL(0x00000000); build/asm/main_8003D380.s.o(.text); build/asm/main_8003D380.s.o(.rodata); build/asm/main_8003D380.s.o(.data); }
    .main_8003D380_bss (NOLOAD) : { build/asm/main_8003D380.s.o(.bss); }
    .main_8003D4C0 0x8003D4C0 : AT(0x0003E0C0) { FILL(0x00000000); build/asm/main_8003D4C0.s.o(.text); build/asm/main_8003D4C0.s.o(.rodata); build/asm/main_8003D4C0.s.o(.data); }
    .main_8003D4C0_bss (NOLOAD) : { build/asm/main_8003D4C0.s.o(.bss); }
    .main_8003D900 0x8003D900 : AT(0x0003E500) { FILL(0x00000000); build/asm/main_8003D900.s.o(.text); build/asm/main_8003D900.s.o(.rodata); build/asm/main_8003D900.s.o(.data); }
    .main_8003D900_bss (NOLOAD) : { build/asm/main_8003D900.s.o(.bss); }
    .main_8003DB00 0x8003DB00 : AT(0x0003E700) { FILL(0x00000000); build/asm/main_8003DB00.s.o(.text); build/asm/main_8003DB00.s.o(.rodata); build/asm/main_8003DB00.s.o(.data); }
    .main_8003DB00_bss (NOLOAD) : { build/asm/main_8003DB00.s.o(.bss); }
    .main_8003DD00 0x8003DD00 : AT(0x0003E900) { FILL(0x00000000); build/asm/main_8003DD00.s.o(.text); build/asm/main_8003DD00.s.o(.rodata); build/asm/main_8003DD00.s.o(.data); }
    .main_8003DD00_bss (NOLOAD) : { build/asm/main_8003DD00.s.o(.bss); }
    .main_8003DE00 0x8003DE00 : AT(0x0003EA00) { FILL(0x00000000); build/asm/main_8003DE00.s.o(.text); build/asm/main_8003DE00.s.o(.rodata); build/asm/main_8003DE00.s.o(.data); }
    .main_8003DE00_bss (NOLOAD) : { build/asm/main_8003DE00.s.o(.bss); }
    .main_8003DF00 0x8003DF00 : AT(0x0003EB00) { FILL(0x00000000); build/asm/main_8003DF00.s.o(.text); build/asm/main_8003DF00.s.o(.rodata); build/asm/main_8003DF00.s.o(.data); }
    .main_8003DF00_bss (NOLOAD) : { build/asm/main_8003DF00.s.o(.bss); }
    .main_8003F500 0x8003F500 : AT(0x00040100) { FILL(0x00000000); build/asm/main_8003F500.s.o(.text); build/asm/main_8003F500.s.o(.rodata); build/asm/main_8003F500.s.o(.data); }
    .main_8003F500_bss (NOLOAD) : { build/asm/main_8003F500.s.o(.bss); }
    .main_8003F540 0x8003F540 : AT(0x00040140) { FILL(0x00000000); build/asm/main_8003F540.s.o(.text); build/asm/main_8003F540.s.o(.rodata); build/asm/main_8003F540.s.o(.data); }
    .main_8003F540_bss (NOLOAD) : { build/asm/main_8003F540.s.o(.bss); }
    .main_80042340 0x80042340 : AT(0x00042F40) { FILL(0x00000000); build/asm/main_80042340.s.o(.text); build/asm/main_80042340.s.o(.rodata); build/asm/main_80042340.s.o(.data); }
    .main_80042340_bss (NOLOAD) : { build/asm/main_80042340.s.o(.bss); }
    .main_80042B58 0x80042B58 : AT(0x00043758) { FILL(0x00000000); build/asm/main_80042B58.s.o(.text); build/asm/main_80042B58.s.o(.rodata); build/asm/main_80042B58.s.o(.data); }
    .main_80042B58_bss (NOLOAD) : { build/asm/main_80042B58.s.o(.bss); }
    .main_80042C80 0x80042C80 : AT(0x00043880) { FILL(0x00000000); build/asm/main_80042C80.s.o(.text); build/asm/main_80042C80.s.o(.rodata); build/asm/main_80042C80.s.o(.data); }
    .main_80042C80_bss (NOLOAD) : { build/asm/main_80042C80.s.o(.bss); }
    .main_80043480 0x80043480 : AT(0x00044080) { FILL(0x00000000); build/asm/main_80043480.s.o(.text); build/asm/main_80043480.s.o(.rodata); build/asm/main_80043480.s.o(.data); }
    .main_80043480_bss (NOLOAD) : { build/asm/main_80043480.s.o(.bss); }
    .main_80043640 0x80043640 : AT(0x00044240) { FILL(0x00000000); build/asm/main_80043640.s.o(.text); build/asm/main_80043640.s.o(.rodata); build/asm/main_80043640.s.o(.data); }
    .main_80043640_bss (NOLOAD) : { build/asm/main_80043640.s.o(.bss); }
    .main_80043708 0x80043708 : AT(0x00044308) { FILL(0x00000000); build/asm/main_80043708.s.o(.text); build/asm/main_80043708.s.o(.rodata); build/asm/main_80043708.s.o(.data); }
    .main_80043708_bss (NOLOAD) : { build/asm/main_80043708.s.o(.bss); }
    .main_800437C0 0x800437C0 : AT(0x000443C0) { FILL(0x00000000); build/asm/main_800437C0.s.o(.text); build/asm/main_800437C0.s.o(.rodata); build/asm/main_800437C0.s.o(.data); }
    .main_800437C0_bss (NOLOAD) : { build/asm/main_800437C0.s.o(.bss); }
    .main_80043840 0x80043840 : AT(0x00044440) { FILL(0x00000000); build/asm/main_80043840.s.o(.text); build/asm/main_80043840.s.o(.rodata); build/asm/main_80043840.s.o(.data); }
    .main_80043840_bss (NOLOAD) : { build/asm/main_80043840.s.o(.bss); }
    .main_800438C8 0x800438C8 : AT(0x000444C8) { FILL(0x00000000); build/asm/main_800438C8.s.o(.text); build/asm/main_800438C8.s.o(.rodata); build/asm/main_800438C8.s.o(.data); }
    .main_800438C8_bss (NOLOAD) : { build/asm/main_800438C8.s.o(.bss); }
    .main_80044D00 0x80044D00 : AT(0x00045900) { FILL(0x00000000); build/asm/main_80044D00.s.o(.text); build/asm/main_80044D00.s.o(.rodata); build/asm/main_80044D00.s.o(.data); }
    .main_80044D00_bss (NOLOAD) : { build/asm/main_80044D00.s.o(.bss); }
    .main_80045034 0x80045034 : AT(0x00045C34) { FILL(0x00000000); build/asm/main_80045034.s.o(.text); build/asm/main_80045034.s.o(.rodata); build/asm/main_80045034.s.o(.data); }
    .main_80045034_bss (NOLOAD) : { build/asm/main_80045034.s.o(.bss); }
    .main_80045300 0x80045300 : AT(0x00045F00) { FILL(0x00000000); build/asm/main_80045300.s.o(.text); build/asm/main_80045300.s.o(.rodata); build/asm/main_80045300.s.o(.data); }
    .main_80045300_bss (NOLOAD) : { build/asm/main_80045300.s.o(.bss); }
    .main_80045440 0x80045440 : AT(0x00046040) { FILL(0x00000000); build/asm/main_80045440.s.o(.text); build/asm/main_80045440.s.o(.rodata); build/asm/main_80045440.s.o(.data); }
    .main_80045440_bss (NOLOAD) : { build/asm/main_80045440.s.o(.bss); }
    .main_800460C0 0x800460C0 : AT(0x00046CC0) { FILL(0x00000000); build/asm/main_800460C0.s.o(.text); build/asm/main_800460C0.s.o(.rodata); build/asm/main_800460C0.s.o(.data); }
    .main_800460C0_bss (NOLOAD) : { build/asm/main_800460C0.s.o(.bss); }
    .main_80046100 0x80046100 : AT(0x00046D00) { FILL(0x00000000); build/asm/main_80046100.s.o(.text); build/asm/main_80046100.s.o(.rodata); build/asm/main_80046100.s.o(.data); }
    .main_80046100_bss (NOLOAD) : { build/asm/main_80046100.s.o(.bss); }
    .main_80046280 0x80046280 : AT(0x00046E80) { FILL(0x00000000); build/asm/main_80046280.s.o(.text); build/asm/main_80046280.s.o(.rodata); build/asm/main_80046280.s.o(.data); }
    .main_80046280_bss (NOLOAD) : { build/asm/main_80046280.s.o(.bss); }
    .main_80046580 0x80046580 : AT(0x00047180) { FILL(0x00000000); build/asm/main_80046580.s.o(.text); build/asm/main_80046580.s.o(.rodata); build/asm/main_80046580.s.o(.data); }
    .main_80046580_bss (NOLOAD) : { build/asm/main_80046580.s.o(.bss); }
    .main_80046E74 0x80046E74 : AT(0x00047A74) { FILL(0x00000000); build/asm/main_80046E74.s.o(.text); build/asm/main_80046E74.s.o(.rodata); build/asm/main_80046E74.s.o(.data); }
    .main_80046E74_bss (NOLOAD) : { build/asm/main_80046E74.s.o(.bss); }
    .main_80047200 0x80047200 : AT(0x00047E00) { FILL(0x00000000); build/asm/main_80047200.s.o(.text); build/asm/main_80047200.s.o(.rodata); build/asm/main_80047200.s.o(.data); }
    .main_80047200_bss (NOLOAD) : { build/asm/main_80047200.s.o(.bss); }
    .main_800472C0 0x800472C0 : AT(0x00047EC0) { FILL(0x00000000); build/asm/main_800472C0.s.o(.text); build/asm/main_800472C0.s.o(.rodata); build/asm/main_800472C0.s.o(.data); }
    .main_800472C0_bss (NOLOAD) : { build/asm/main_800472C0.s.o(.bss); }
    .main_80047380 0x80047380 : AT(0x00047F80) { FILL(0x00000000); build/asm/main_80047380.s.o(.text); build/asm/main_80047380.s.o(.rodata); build/asm/main_80047380.s.o(.data); }
    .main_80047380_bss (NOLOAD) : { build/asm/main_80047380.s.o(.bss); }
    .main_80047440 0x80047440 : AT(0x00048040) { FILL(0x00000000); build/asm/main_80047440.s.o(.text); build/asm/main_80047440.s.o(.rodata); build/asm/main_80047440.s.o(.data); }
    .main_80047440_bss (NOLOAD) : { build/asm/main_80047440.s.o(.bss); }
    .main_80047BC0 0x80047BC0 : AT(0x000487C0) { FILL(0x00000000); build/asm/main_80047BC0.s.o(.text); build/asm/main_80047BC0.s.o(.rodata); build/asm/main_80047BC0.s.o(.data); }
    .main_80047BC0_bss (NOLOAD) : { build/asm/main_80047BC0.s.o(.bss); }
    .main_80047CC0 0x80047CC0 : AT(0x000488C0) { FILL(0x00000000); build/asm/main_80047CC0.s.o(.text); build/asm/main_80047CC0.s.o(.rodata); build/asm/main_80047CC0.s.o(.data); }
    .main_80047CC0_bss (NOLOAD) : { build/asm/main_80047CC0.s.o(.bss); }
    .main_80047D40 0x80047D40 : AT(0x00048940) { FILL(0x00000000); build/asm/main_80047D40.s.o(.text); build/asm/main_80047D40.s.o(.rodata); build/asm/main_80047D40.s.o(.data); }
    .main_80047D40_bss (NOLOAD) : { build/asm/main_80047D40.s.o(.bss); }
    .main_80047F00 0x80047F00 : AT(0x00048B00) { FILL(0x00000000); build/asm/main_80047F00.s.o(.text); build/asm/main_80047F00.s.o(.rodata); build/asm/main_80047F00.s.o(.data); }
    .main_80047F00_bss (NOLOAD) : { build/asm/main_80047F00.s.o(.bss); }
    .main_800482AC 0x800482AC : AT(0x00048EAC) { FILL(0x00000000); build/asm/main_800482AC.s.o(.text); build/asm/main_800482AC.s.o(.rodata); build/asm/main_800482AC.s.o(.data); }
    .main_800482AC_bss (NOLOAD) : { build/asm/main_800482AC.s.o(.bss); }
    .main_80048300 0x80048300 : AT(0x00048F00) { FILL(0x00000000); build/asm/main_80048300.s.o(.text); build/asm/main_80048300.s.o(.rodata); build/asm/main_80048300.s.o(.data); }
    .main_80048300_bss (NOLOAD) : { build/asm/main_80048300.s.o(.bss); }
    .main_80048480 0x80048480 : AT(0x00049080) { FILL(0x00000000); build/asm/main_80048480.s.o(.text); build/asm/main_80048480.s.o(.rodata); build/asm/main_80048480.s.o(.data); }
    .main_80048480_bss (NOLOAD) : { build/asm/main_80048480.s.o(.bss); }
    .main_800484C0 0x800484C0 : AT(0x000490C0) { FILL(0x00000000); build/asm/main_800484C0.s.o(.text); build/asm/main_800484C0.s.o(.rodata); build/asm/main_800484C0.s.o(.data); }
    .main_800484C0_bss (NOLOAD) : { build/asm/main_800484C0.s.o(.bss); }
    .main_80048540 0x80048540 : AT(0x00049140) { FILL(0x00000000); build/asm/main_80048540.s.o(.text); build/asm/main_80048540.s.o(.rodata); build/asm/main_80048540.s.o(.data); }
    .main_80048540_bss (NOLOAD) : { build/asm/main_80048540.s.o(.bss); }
    .main_80048580 0x80048580 : AT(0x00049180) { FILL(0x00000000); build/asm/main_80048580.s.o(.text); build/asm/main_80048580.s.o(.rodata); build/asm/main_80048580.s.o(.data); }
    .main_80048580_bss (NOLOAD) : { build/asm/main_80048580.s.o(.bss); }
    .main_80049200 0x80049200 : AT(0x00049E00) { FILL(0x00000000); build/asm/main_80049200.s.o(.text); build/asm/main_80049200.s.o(.rodata); build/asm/main_80049200.s.o(.data); }
    .main_80049200_bss (NOLOAD) : { build/asm/main_80049200.s.o(.bss); }
    .main_80049340 0x80049340 : AT(0x00049F40) { FILL(0x00000000); build/asm/main_80049340.s.o(.text); build/asm/main_80049340.s.o(.rodata); build/asm/main_80049340.s.o(.data); }
    .main_80049340_bss (NOLOAD) : { build/asm/main_80049340.s.o(.bss); }
    .main_800496EC 0x800496EC : AT(0x0004A2EC) { FILL(0x00000000); build/asm/main_800496EC.s.o(.text); build/asm/main_800496EC.s.o(.rodata); build/asm/main_800496EC.s.o(.data); }
    .main_800496EC_bss (NOLOAD) : { build/asm/main_800496EC.s.o(.bss); }
    .main_80049800 0x80049800 : AT(0x0004A400) { FILL(0x00000000); build/asm/main_80049800.s.o(.text); build/asm/main_80049800.s.o(.rodata); build/asm/main_80049800.s.o(.data); }
    .main_80049800_bss (NOLOAD) : { build/asm/main_80049800.s.o(.bss); }
    .main_8004BA40 0x8004BA40 : AT(0x0004C640) { FILL(0x00000000); build/asm/main_8004BA40.s.o(.text); build/asm/main_8004BA40.s.o(.rodata); build/asm/main_8004BA40.s.o(.data); }
    .main_8004BA40_bss (NOLOAD) : { build/asm/main_8004BA40.s.o(.bss); }
    .main_8004BAC0 0x8004BAC0 : AT(0x0004C6C0) { FILL(0x00000000); build/asm/main_8004BAC0.s.o(.text); build/asm/main_8004BAC0.s.o(.rodata); build/asm/main_8004BAC0.s.o(.data); }
    .main_8004BAC0_bss (NOLOAD) : { build/asm/main_8004BAC0.s.o(.bss); }
    .main_8004BBC0 0x8004BBC0 : AT(0x0004C7C0) { FILL(0x00000000); build/asm/main_8004BBC0.s.o(.text); build/asm/main_8004BBC0.s.o(.rodata); build/asm/main_8004BBC0.s.o(.data); }
    .main_8004BBC0_bss (NOLOAD) : { build/asm/main_8004BBC0.s.o(.bss); }
    .main_8004BC40 0x8004BC40 : AT(0x0004C840) { FILL(0x00000000); build/asm/main_8004BC40.s.o(.text); build/asm/main_8004BC40.s.o(.rodata); build/asm/main_8004BC40.s.o(.data); }
    .main_8004BC40_bss (NOLOAD) : { build/asm/main_8004BC40.s.o(.bss); }
    .main_8004BD00 0x8004BD00 : AT(0x0004C900) { FILL(0x00000000); build/asm/main_8004BD00.s.o(.text); build/asm/main_8004BD00.s.o(.rodata); build/asm/main_8004BD00.s.o(.data); }
    .main_8004BD00_bss (NOLOAD) : { build/asm/main_8004BD00.s.o(.bss); }
    .main_8004BFC0 0x8004BFC0 : AT(0x0004CBC0) { FILL(0x00000000); build/asm/main_8004BFC0.s.o(.text); build/asm/main_8004BFC0.s.o(.rodata); build/asm/main_8004BFC0.s.o(.data); }
    .main_8004BFC0_bss (NOLOAD) : { build/asm/main_8004BFC0.s.o(.bss); }
    .main_8004C000 0x8004C000 : AT(0x0004CC00) { FILL(0x00000000); build/asm/main_8004C000.s.o(.text); build/asm/main_8004C000.s.o(.rodata); build/asm/main_8004C000.s.o(.data); }
    .main_8004C000_bss (NOLOAD) : { build/asm/main_8004C000.s.o(.bss); }
    .main_8004C340 0x8004C340 : AT(0x0004CF40) { FILL(0x00000000); build/asm/main_8004C340.s.o(.text); build/asm/main_8004C340.s.o(.rodata); build/asm/main_8004C340.s.o(.data); }
    .main_8004C340_bss (NOLOAD) : { build/asm/main_8004C340.s.o(.bss); }
    .main_8004C7A4 0x8004C7A4 : AT(0x0004D3A4) { FILL(0x00000000); build/asm/main_8004C7A4.s.o(.text); build/asm/main_8004C7A4.s.o(.rodata); build/asm/main_8004C7A4.s.o(.data); }
    .main_8004C7A4_bss (NOLOAD) : { build/asm/main_8004C7A4.s.o(.bss); }
    .main_800507C0 0x800507C0 : AT(0x000513C0) { FILL(0x00000000); build/asm/main_800507C0.s.o(.text); build/asm/main_800507C0.s.o(.rodata); build/asm/main_800507C0.s.o(.data); }
    .main_800507C0_bss (NOLOAD) : { build/asm/main_800507C0.s.o(.bss); }
    .main_80050AC0 0x80050AC0 : AT(0x000516C0) { FILL(0x00000000); build/asm/main_80050AC0.s.o(.text); build/asm/main_80050AC0.s.o(.rodata); build/asm/main_80050AC0.s.o(.data); }
    .main_80050AC0_bss (NOLOAD) : { build/asm/main_80050AC0.s.o(.bss); }
    .main_800515B8 0x800515B8 : AT(0x000521B8) { build/asm/data/main_800515B8.bin.o(.data); }
    .main_800517C0 0x800517C0 : AT(0x000523C0) { FILL(0x00000000); build/asm/main_800517C0.s.o(.text); build/asm/main_800517C0.s.o(.rodata); build/asm/main_800517C0.s.o(.data); }
    .main_800517C0_bss (NOLOAD) : { build/asm/main_800517C0.s.o(.bss); }
    .main_8005272C 0x8005272C : AT(0x0005332C) { build/asm/data/main_8005272C.bin.o(.data); }
    .main_80054014 0x80054014 : AT(0x00054C14) { build/asm/data/main_80054014.bin.o(.data); }
    .main_80054AEC 0x80054AEC : AT(0x000556EC) { build/asm/data/main_80054AEC.bin.o(.data); }
    .main_80055AB8 0x80055AB8 : AT(0x000566B8) { FILL(0x00000000); build/asm/main_80055AB8.s.o(.text); build/asm/main_80055AB8.s.o(.rodata); build/asm/main_80055AB8.s.o(.data); }
    .main_80055AB8_bss (NOLOAD) : { build/asm/main_80055AB8.s.o(.bss); }
    .main_80055CF4 0x80055CF4 : AT(0x000568F4) { FILL(0x00000000); build/asm/main_80055CF4.s.o(.text); build/asm/main_80055CF4.s.o(.rodata); build/asm/main_80055CF4.s.o(.data); }
    .main_80055CF4_bss (NOLOAD) : { build/asm/main_80055CF4.s.o(.bss); }
    .main_80055D2C 0x80055D2C : AT(0x0005692C) { FILL(0x00000000); build/asm/main_80055D2C.s.o(.text); build/asm/main_80055D2C.s.o(.rodata); build/asm/main_80055D2C.s.o(.data); }
    .main_80055D2C_bss (NOLOAD) : { build/asm/main_80055D2C.s.o(.bss); }
    .main_80055DA4 0x80055DA4 : AT(0x000569A4) { build/asm/data/main_80055DA4.bin.o(.data); }
    .main_80055FE8 0x80055FE8 : AT(0x00056BE8) { FILL(0x00000000); build/asm/main_80055FE8.s.o(.text); build/asm/main_80055FE8.s.o(.rodata); build/asm/main_80055FE8.s.o(.data); }
    .main_80055FE8_bss (NOLOAD) : { build/asm/main_80055FE8.s.o(.bss); }
    .main_80056078 0x80056078 : AT(0x00056C78) { build/asm/data/main_80056078.bin.o(.data); }
    .main_800561A4 0x800561A4 : AT(0x00056DA4) { FILL(0x00000000); build/asm/main_800561A4.s.o(.text); build/asm/main_800561A4.s.o(.rodata); build/asm/main_800561A4.s.o(.data); }
    .main_800561A4_bss (NOLOAD) : { build/asm/main_800561A4.s.o(.bss); }
    .main_8005629C 0x8005629C : AT(0x00056E9C) { build/asm/data/main_8005629C.bin.o(.data); }
    .main_80056340 0x80056340 : AT(0x00056F40) { FILL(0x00000000); build/asm/main_80056340.s.o(.text); build/asm/main_80056340.s.o(.rodata); build/asm/main_80056340.s.o(.data); }
    .main_80056340_bss (NOLOAD) : { build/asm/main_80056340.s.o(.bss); }
    .main_800563F4 0x800563F4 : AT(0x00056FF4) { FILL(0x00000000); build/asm/main_800563F4.s.o(.text); build/asm/main_800563F4.s.o(.rodata); build/asm/main_800563F4.s.o(.data); }
    .main_800563F4_bss (NOLOAD) : { build/asm/main_800563F4.s.o(.bss); }
    .main_800564A4 0x800564A4 : AT(0x000570A4) { build/asm/data/main_800564A4.bin.o(.data); }
    .main_80056504 0x80056504 : AT(0x00057104) { FILL(0x00000000); build/asm/main_80056504.s.o(.text); build/asm/main_80056504.s.o(.rodata); build/asm/main_80056504.s.o(.data); }
    .main_80056504_bss (NOLOAD) : { build/asm/main_80056504.s.o(.bss); }
    .main_800571D4 0x800571D4 : AT(0x00057DD4) { build/asm/data/main_800571D4.bin.o(.data); }
    .main_8005738C 0x8005738C : AT(0x00057F8C) { FILL(0x00000000); build/asm/main_8005738C.s.o(.text); build/asm/main_8005738C.s.o(.rodata); build/asm/main_8005738C.s.o(.data); }
    .main_8005738C_bss (NOLOAD) : { build/asm/main_8005738C.s.o(.bss); }
    .main_800578A0 0x800578A0 : AT(0x000584A0) { build/asm/data/main_800578A0.bin.o(.data); }
    .main_80057BC8 0x80057BC8 : AT(0x000587C8) { FILL(0x00000000); build/asm/main_80057BC8.s.o(.text); build/asm/main_80057BC8.s.o(.rodata); build/asm/main_80057BC8.s.o(.data); }
    .main_80057BC8_bss (NOLOAD) : { build/asm/main_80057BC8.s.o(.bss); }
    .main_80057BD0 0x80057BD0 : AT(0x000587D0) { build/asm/data/main_80057BD0.bin.o(.data); }
    .main_8005AA44 0x8005AA44 : AT(0x0005B644) { FILL(0x00000000); build/asm/main_8005AA44.s.o(.text); build/asm/main_8005AA44.s.o(.rodata); build/asm/main_8005AA44.s.o(.data); }
    .main_8005AA44_bss (NOLOAD) : { build/asm/main_8005AA44.s.o(.bss); }
    .main_8005AA60 0x8005AA60 : AT(0x0005B660) { FILL(0x00000000); build/asm/main_8005AA60.s.o(.text); build/asm/main_8005AA60.s.o(.rodata); build/asm/main_8005AA60.s.o(.data); }
    .main_8005AA60_bss (NOLOAD) : { build/asm/main_8005AA60.s.o(.bss); }
    .main_8005AAA4 0x8005AAA4 : AT(0x0005B6A4) { FILL(0x00000000); build/asm/main_8005AAA4.s.o(.text); build/asm/main_8005AAA4.s.o(.rodata); build/asm/main_8005AAA4.s.o(.data); }
    .main_8005AAA4_bss (NOLOAD) : { build/asm/main_8005AAA4.s.o(.bss); }
    .main_8005AC70 0x8005AC70 : AT(0x0005B870) { FILL(0x00000000); build/asm/main_8005AC70.s.o(.text); build/asm/main_8005AC70.s.o(.rodata); build/asm/main_8005AC70.s.o(.data); }
    .main_8005AC70_bss (NOLOAD) : { build/asm/main_8005AC70.s.o(.bss); }
    .main_8005ACC8 0x8005ACC8 : AT(0x0005B8C8) { build/asm/data/main_8005ACC8.bin.o(.data); }
    .main_8005AD6C 0x8005AD6C : AT(0x0005B96C) { build/asm/data/main_8005AD6C.bin.o(.data); }
    .main_8005AE0C 0x8005AE0C : AT(0x0005BA0C) { FILL(0x00000000); build/asm/main_8005AE0C.s.o(.text); build/asm/main_8005AE0C.s.o(.rodata); build/asm/main_8005AE0C.s.o(.data); }
    .main_8005AE0C_bss (NOLOAD) : { build/asm/main_8005AE0C.s.o(.bss); }
    .main_8005AE64 0x8005AE64 : AT(0x0005BA64) { build/asm/data/main_8005AE64.bin.o(.data); }
    .main_8005AEFC 0x8005AEFC : AT(0x0005BAFC) { FILL(0x00000000); build/asm/main_8005AEFC.s.o(.text); build/asm/main_8005AEFC.s.o(.rodata); build/asm/main_8005AEFC.s.o(.data); }
    .main_8005AEFC_bss (NOLOAD) : { build/asm/main_8005AEFC.s.o(.bss); }
    .main_8005B1AC 0x8005B1AC : AT(0x0005BDAC) { build/asm/data/main_8005B1AC.bin.o(.data); }
    .main_8005B22C 0x8005B22C : AT(0x0005BE2C) { FILL(0x00000000); build/asm/main_8005B22C.s.o(.text); build/asm/main_8005B22C.s.o(.rodata); build/asm/main_8005B22C.s.o(.data); }
    .main_8005B22C_bss (NOLOAD) : { build/asm/main_8005B22C.s.o(.bss); }
    .main_8005B6C0 0x8005B6C0 : AT(0x0005C2C0) { FILL(0x00000000); build/asm/main_8005B6C0.s.o(.text); build/asm/main_8005B6C0.s.o(.rodata); build/asm/main_8005B6C0.s.o(.data); }
    .main_8005B6C0_bss (NOLOAD) : { build/asm/main_8005B6C0.s.o(.bss); }
    .main_8005B730 0x8005B730 : AT(0x0005C330) { build/asm/data/main_8005B730.bin.o(.data); }
    .main_8005BEC0 0x8005BEC0 : AT(0x0005CAC0) { build/asm/data/main_8005BEC0.bin.o(.data); }
    .main_8005C310 0x8005C310 : AT(0x0005CF10) { FILL(0x00000000); build/asm/main_8005C310.s.o(.text); build/asm/main_8005C310.s.o(.rodata); build/asm/main_8005C310.s.o(.data); }
    .main_8005C310_bss (NOLOAD) : { build/asm/main_8005C310.s.o(.bss); }
    .main_8005C38C 0x8005C38C : AT(0x0005CF8C) { build/asm/data/main_8005C38C.bin.o(.data); }
    .main_8005C6C0 0x8005C6C0 : AT(0x0005D2C0) { FILL(0x00000000); build/asm/main_8005C6C0.s.o(.text); build/asm/main_8005C6C0.s.o(.rodata); build/asm/main_8005C6C0.s.o(.data); }
    .main_8005C6C0_bss (NOLOAD) : { build/asm/main_8005C6C0.s.o(.bss); }
    .main_8005CB8C 0x8005CB8C : AT(0x0005D78C) { build/asm/data/main_8005CB8C.bin.o(.data); }
    .main_8005CEC0 0x8005CEC0 : AT(0x0005DAC0) { FILL(0x00000000); build/asm/main_8005CEC0.s.o(.text); build/asm/main_8005CEC0.s.o(.rodata); build/asm/main_8005CEC0.s.o(.data); }
    .main_8005CEC0_bss (NOLOAD) : { build/asm/main_8005CEC0.s.o(.bss); }
    .main_8005D6C0 0x8005D6C0 : AT(0x0005E2C0) { build/asm/data/main_8005D6C0.bin.o(.data); }
    .main_8005D910 0x8005D910 : AT(0x0005E510) { FILL(0x00000000); build/asm/main_8005D910.s.o(.text); build/asm/main_8005D910.s.o(.rodata); build/asm/main_8005D910.s.o(.data); }
    .main_8005D910_bss (NOLOAD) : { build/asm/main_8005D910.s.o(.bss); }
    .main_8005E110 0x8005E110 : AT(0x0005ED10) { build/asm/data/main_8005E110.bin.o(.data); }
    .main_8005F090 0x8005F090 : AT(0x0005FC90) { FILL(0x00000000); build/asm/main_8005F090.s.o(.text); build/asm/main_8005F090.s.o(.rodata); build/asm/main_8005F090.s.o(.data); }
    .main_8005F090_bss (NOLOAD) : { build/asm/main_8005F090.s.o(.bss); }
    .main_80060930 0x80060930 : AT(0x00061530) { FILL(0x00000000); build/asm/main_80060930.s.o(.text); build/asm/main_80060930.s.o(.rodata); build/asm/main_80060930.s.o(.data); }
    .main_80060930_bss (NOLOAD) : { build/asm/main_80060930.s.o(.bss); }
    .main_800609F0 0x800609F0 : AT(0x000615F0) { build/asm/data/main_800609F0.bin.o(.data); }
    .main_80060F80 0x80060F80 : AT(0x00061B80) { FILL(0x00000000); build/asm/main_80060F80.s.o(.text); build/asm/main_80060F80.s.o(.rodata); build/asm/main_80060F80.s.o(.data); }
    .main_80060F80_bss (NOLOAD) : { build/asm/main_80060F80.s.o(.bss); }
    .main_80061A04 0x80061A04 : AT(0x00062604) { FILL(0x00000000); build/asm/main_80061A04.s.o(.text); build/asm/main_80061A04.s.o(.rodata); build/asm/main_80061A04.s.o(.data); }
    .main_80061A04_bss (NOLOAD) : { build/asm/main_80061A04.s.o(.bss); }
    .main_80061BA4 0x80061BA4 : AT(0x000627A4) { FILL(0x00000000); build/asm/main_80061BA4.s.o(.text); build/asm/main_80061BA4.s.o(.rodata); build/asm/main_80061BA4.s.o(.data); }
    .main_80061BA4_bss (NOLOAD) : { build/asm/main_80061BA4.s.o(.bss); }
    .main_800623D0 0x800623D0 : AT(0x00062FD0) { FILL(0x00000000); build/asm/main_800623D0.s.o(.text); build/asm/main_800623D0.s.o(.rodata); build/asm/main_800623D0.s.o(.data); }
    .main_800623D0_bss (NOLOAD) : { build/asm/main_800623D0.s.o(.bss); }
    .main_800625EC 0x800625EC : AT(0x000631EC) { build/asm/data/main_800625EC.bin.o(.data); }
    .main_80063038 0x80063038 : AT(0x00063C38) { build/asm/data/main_80063038.bin.o(.data); }
    .main_800633A8 0x800633A8 : AT(0x00063FA8) { build/asm/data/main_800633A8.bin.o(.data); }
    .main_800638BC 0x800638BC : AT(0x000644BC) { build/asm/data/main_800638BC.bin.o(.data); }
    .main_80063A98 0x80063A98 : AT(0x00064698) { build/asm/data/main_80063A98.bin.o(.data); }
    .main_80064C48 0x80064C48 : AT(0x00065848) { build/asm/data/main_80064C48.bin.o(.data); }
    .main_80066BBC 0x80066BBC : AT(0x000677BC) { build/asm/data/main_80066BBC.bin.o(.data); }
    .main_80067E28 0x80067E28 : AT(0x00068A28) { build/asm/data/main_80067E28.bin.o(.data); }
    .main_80069970 0x80069970 : AT(0x0006A570) { build/asm/data/main_80069970.bin.o(.data); }
    .main_8006A3A4 0x8006A3A4 : AT(0x0006AFA4) { build/asm/data/main_8006A3A4.bin.o(.data); }
    .main_8006BD98 0x8006BD98 : AT(0x0006C998) { build/asm/data/main_8006BD98.bin.o(.data); }
    .main_8006C1B4 0x8006C1B4 : AT(0x0006CDB4) { build/asm/data/main_8006C1B4.bin.o(.data); }
    .main_8006C6C4 0x8006C6C4 : AT(0x0006D2C4) { build/asm/data/main_8006C6C4.bin.o(.data); }
    .main_8006CA78 0x8006CA78 : AT(0x0006D678) { build/asm/data/main_8006CA78.bin.o(.data); }
    .main_8006CC74 0x8006CC74 : AT(0x0006D874) { FILL(0x00000000); build/asm/main_8006CC74.s.o(.text); build/asm/main_8006CC74.s.o(.rodata); build/asm/main_8006CC74.s.o(.data); }
    .main_8006CC74_bss (NOLOAD) : { build/asm/main_8006CC74.s.o(.bss); }
    .main_8006E0B0 0x8006E0B0 : AT(0x0006ECB0) { build/asm/data/main_8006E0B0.bin.o(.data); }
    .main_80072BFC 0x80072BFC : AT(0x000737FC) { FILL(0x00000000); build/asm/main_80072BFC.s.o(.text); build/asm/main_80072BFC.s.o(.rodata); build/asm/main_80072BFC.s.o(.data); }
    .main_80072BFC_bss (NOLOAD) : { build/asm/main_80072BFC.s.o(.bss); }
    .main_80072C00 0x80072C00 : AT(0x00073800) { build/asm/data/main_80072C00.bin.o(.data); }
    .main_80075110 0x80075110 : AT(0x00075D10) { FILL(0x00000000); build/asm/main_80075110.s.o(.text); build/asm/main_80075110.s.o(.rodata); build/asm/main_80075110.s.o(.data); }
    .main_80075110_bss (NOLOAD) : { build/asm/main_80075110.s.o(.bss); }
    .main_80075158 0x80075158 : AT(0x00075D58) { build/asm/data/main_80075158.bin.o(.data); }
    .main_80078434 0x80078434 : AT(0x00079034) { FILL(0x00000000); build/asm/main_80078434.s.o(.text); build/asm/main_80078434.s.o(.rodata); build/asm/main_80078434.s.o(.data); }
    .main_80078434_bss (NOLOAD) : { build/asm/main_80078434.s.o(.bss); }
    .main_8007843C 0x8007843C : AT(0x0007903C) { build/asm/data/main_8007843C.bin.o(.data); }
    .main_8007D334 0x8007D334 : AT(0x0007DF34) { FILL(0x00000000); build/asm/main_8007D334.s.o(.text); build/asm/main_8007D334.s.o(.rodata); build/asm/main_8007D334.s.o(.data); }
    .main_8007D334_bss (NOLOAD) : { build/asm/main_8007D334.s.o(.bss); }
    .main_8007D338 0x8007D338 : AT(0x0007DF38) { build/asm/data/main_8007D338.bin.o(.data); }
    .main_8007D5AC 0x8007D5AC : AT(0x0007E1AC) { build/asm/data/main_8007D5AC.bin.o(.data); }
    .main_8007E0C0 0x8007E0C0 : AT(0x0007ECC0) { build/asm/data/main_8007E0C0.bin.o(.data); }
    .main_8007E5E4 0x8007E5E4 : AT(0x0007F1E4) { build/asm/data/main_8007E5E4.bin.o(.data); }
    .main_8007F878 0x8007F878 : AT(0x00080478) { FILL(0x00000000); build/asm/main_8007F878.s.o(.text); build/asm/main_8007F878.s.o(.rodata); build/asm/main_8007F878.s.o(.data); }
    .main_8007F878_bss (NOLOAD) : { build/asm/main_8007F878.s.o(.bss); }
    .main_8007F9A0 0x8007F9A0 : AT(0x000805A0) { build/asm/data/main_8007F9A0.bin.o(.data); }
    .main_80081998 0x80081998 : AT(0x00082598) { build/asm/data/main_80081998.bin.o(.data); }
    .main_80083624 0x80083624 : AT(0x00084224) { FILL(0x00000000); build/asm/main_80083624.s.o(.text); build/asm/main_80083624.s.o(.rodata); build/asm/main_80083624.s.o(.data); }
    .main_80083624_bss (NOLOAD) : { build/asm/main_80083624.s.o(.bss); }
    .main_80083844 0x80083844 : AT(0x00084444) { build/asm/data/main_80083844.bin.o(.data); }
    .main_8008421C 0x8008421C : AT(0x00084E1C) { FILL(0x00000000); build/asm/main_8008421C.s.o(.text); build/asm/main_8008421C.s.o(.rodata); build/asm/main_8008421C.s.o(.data); }
    .main_8008421C_bss (NOLOAD) : { build/asm/main_8008421C.s.o(.bss); }
    .main_800858C8 0x800858C8 : AT(0x000864C8) { build/asm/data/main_800858C8.bin.o(.data); }
    .main_80088664 0x80088664 : AT(0x00089264) { FILL(0x00000000); build/asm/main_80088664.s.o(.text); build/asm/main_80088664.s.o(.rodata); build/asm/main_80088664.s.o(.data); }
    .main_80088664_bss (NOLOAD) : { build/asm/main_80088664.s.o(.bss); }
    .main_8008866C 0x8008866C : AT(0x0008926C) { build/asm/data/main_8008866C.bin.o(.data); }
    .main_800889F8 0x800889F8 : AT(0x000895F8) { FILL(0x00000000); build/asm/main_800889F8.s.o(.text); build/asm/main_800889F8.s.o(.rodata); build/asm/main_800889F8.s.o(.data); }
    .main_800889F8_bss (NOLOAD) : { build/asm/main_800889F8.s.o(.bss); }
    .main_80088A14 0x80088A14 : AT(0x00089614) { build/asm/data/main_80088A14.bin.o(.data); }
    .main_8008A894 0x8008A894 : AT(0x0008B494) { build/asm/data/main_8008A894.bin.o(.data); }
    .main_8008B120 0x8008B120 : AT(0x0008BD20) { build/asm/data/main_8008B120.bin.o(.data); }
    .main_8008BA0C 0x8008BA0C : AT(0x0008C60C) { build/asm/data/main_8008BA0C.bin.o(.data); }
    .main_8008BADC 0x8008BADC : AT(0x0008C6DC) { FILL(0x00000000); build/asm/main_8008BADC.s.o(.text); build/asm/main_8008BADC.s.o(.rodata); build/asm/main_8008BADC.s.o(.data); }
    .main_8008BADC_bss (NOLOAD) : { build/asm/main_8008BADC.s.o(.bss); }
    .main_8008BB04 0x8008BB04 : AT(0x0008C704) { build/asm/data/main_8008BB04.bin.o(.data); }
    .main_8008BDF8 0x8008BDF8 : AT(0x0008C9F8) { build/asm/data/main_8008BDF8.bin.o(.data); }
    .main_8008C700 0x8008C700 : AT(0x0008D300) { build/asm/data/main_8008C700.bin.o(.data); }
    .main_8008CCEC 0x8008CCEC : AT(0x0008D8EC) { build/asm/data/main_8008CCEC.bin.o(.data); }
    .main_8008E280 0x8008E280 : AT(0x0008EE80) { build/asm/data/main_8008E280.bin.o(.data); }
    .main_8008EE14 0x8008EE14 : AT(0x0008FA14) { build/asm/data/main_8008EE14.bin.o(.data); }
    .main_8008F79C 0x8008F79C : AT(0x0009039C) { build/asm/data/main_8008F79C.bin.o(.data); }
    .main_80091794 0x80091794 : AT(0x00092394) { build/asm/data/main_80091794.bin.o(.data); }
    .main_80091834 0x80091834 : AT(0x00092434) { build/asm/data/main_80091834.bin.o(.data); }
    .main_80092090 0x80092090 : AT(0x00092C90) { build/asm/data/main_80092090.bin.o(.data); }
    .main_80092A04 0x80092A04 : AT(0x00093604) { build/asm/data/main_80092A04.bin.o(.data); }
    .main_800952A0 0x800952A0 : AT(0x00095EA0) { FILL(0x00000000); build/asm/main_800952A0.s.o(.text); build/asm/main_800952A0.s.o(.rodata); build/asm/main_800952A0.s.o(.data); }
    .main_800952A0_bss (NOLOAD) : { build/asm/main_800952A0.s.o(.bss); }
    .main_800952A4 0x800952A4 : AT(0x00095EA4) { build/asm/data/main_800952A4.bin.o(.data); }
    .main_80098D6C 0x80098D6C : AT(0x0009996C) { FILL(0x00000000); build/asm/main_80098D6C.s.o(.text); build/asm/main_80098D6C.s.o(.rodata); build/asm/main_80098D6C.s.o(.data); }
    .main_80098D6C_bss (NOLOAD) : { build/asm/main_80098D6C.s.o(.bss); }
    .main_80098DB4 0x80098DB4 : AT(0x000999B4) { build/asm/data/main_80098DB4.bin.o(.data); }
    .main_8009EAF8 0x8009EAF8 : AT(0x0009F6F8) { FILL(0x00000000); build/asm/main_8009EAF8.s.o(.text); build/asm/main_8009EAF8.s.o(.rodata); build/asm/main_8009EAF8.s.o(.data); }
    .main_8009EAF8_bss (NOLOAD) : { build/asm/main_8009EAF8.s.o(.bss); }
    .main_8009EB44 0x8009EB44 : AT(0x0009F744) { build/asm/data/main_8009EB44.bin.o(.data); }
    .main_800A6548 0x800A6548 : AT(0x000A7148) { FILL(0x00000000); build/asm/main_800A6548.s.o(.text); build/asm/main_800A6548.s.o(.rodata); build/asm/main_800A6548.s.o(.data); }
    .main_800A6548_bss (NOLOAD) : { build/asm/main_800A6548.s.o(.bss); }
    .main_800A6564 0x800A6564 : AT(0x000A7164) { build/asm/data/main_800A6564.bin.o(.data); }
    .main_800B7920 0x800B7920 : AT(0x000B8520) { FILL(0x00000000); build/asm/main_800B7920.s.o(.text); build/asm/main_800B7920.s.o(.rodata); build/asm/main_800B7920.s.o(.data); }
    .main_800B7920_bss (NOLOAD) : { build/asm/main_800B7920.s.o(.bss); }
    .main_800B792C 0x800B792C : AT(0x000B852C) { build/asm/data/main_800B792C.bin.o(.data); }
    .main_800BD7CC 0x800BD7CC : AT(0x000BE3CC) { FILL(0x00000000); build/asm/main_800BD7CC.s.o(.text); build/asm/main_800BD7CC.s.o(.rodata); build/asm/main_800BD7CC.s.o(.data); }
    .main_800BD7CC_bss (NOLOAD) : { build/asm/main_800BD7CC.s.o(.bss); }
    .main_800BD7E0 0x800BD7E0 : AT(0x000BE3E0) { build/asm/data/main_800BD7E0.bin.o(.data); }
    .main_800CF628 0x800CF628 : AT(0x000D0228) { FILL(0x00000000); build/asm/main_800CF628.s.o(.text); build/asm/main_800CF628.s.o(.rodata); build/asm/main_800CF628.s.o(.data); }
    .main_800CF628_bss (NOLOAD) : { build/asm/main_800CF628.s.o(.bss); }
    .main_800CF630 0x800CF630 : AT(0x000D0230) { build/asm/data/main_800CF630.bin.o(.data); }
    .main_800D397C 0x800D397C : AT(0x000D457C) { FILL(0x00000000); build/asm/main_800D397C.s.o(.text); build/asm/main_800D397C.s.o(.rodata); build/asm/main_800D397C.s.o(.data); }
    .main_800D397C_bss (NOLOAD) : { build/asm/main_800D397C.s.o(.bss); }
    .main_800D3C78 0x800D3C78 : AT(0x000D4878) { build/asm/data/main_800D3C78.bin.o(.data); }
    .main_800D3F68 0x800D3F68 : AT(0x000D4B68) { build/asm/data/main_800D3F68.bin.o(.data); }
    .main_800D5848 0x800D5848 : AT(0x000D6448) { build/asm/data/main_800D5848.bin.o(.data); }
    .main_800D6658 0x800D6658 : AT(0x000D7258) { build/asm/data/main_800D6658.bin.o(.data); }
    .main_800D890C 0x800D890C : AT(0x000D950C) { FILL(0x00000000); build/asm/main_800D890C.s.o(.text); build/asm/main_800D890C.s.o(.rodata); build/asm/main_800D890C.s.o(.data); }
    .main_800D890C_bss (NOLOAD) : { build/asm/main_800D890C.s.o(.bss); }
    .main_800D8EB8 0x800D8EB8 : AT(0x000D9AB8) { build/asm/data/main_800D8EB8.bin.o(.data); }
    .main_800DB104 0x800DB104 : AT(0x000DBD04) { build/asm/data/main_800DB104.bin.o(.data); }
    .main_800DC738 0x800DC738 : AT(0x000DD338) { build/asm/data/main_800DC738.bin.o(.data); }
    .main_800DE664 0x800DE664 : AT(0x000DF264) { FILL(0x00000000); build/asm/main_800DE664.s.o(.text); build/asm/main_800DE664.s.o(.rodata); build/asm/main_800DE664.s.o(.data); }
    .main_800DE664_bss (NOLOAD) : { build/asm/main_800DE664.s.o(.bss); }
    .main_800DE99C 0x800DE99C : AT(0x000DF59C) { build/asm/data/main_800DE99C.bin.o(.data); }
    .main_800E13B0 0x800E13B0 : AT(0x000E1FB0) { build/asm/data/main_800E13B0.bin.o(.data); }
    .main_800E72AC 0x800E72AC : AT(0x000E7EAC) { FILL(0x00000000); build/asm/main_800E72AC.s.o(.text); build/asm/main_800E72AC.s.o(.rodata); build/asm/main_800E72AC.s.o(.data); }
    .main_800E72AC_bss (NOLOAD) : { build/asm/main_800E72AC.s.o(.bss); }
    .main_800E7308 0x800E7308 : AT(0x000E7F08) { build/asm/data/main_800E7308.bin.o(.data); }
    .main_800E9058 0x800E9058 : AT(0x000E9C58) { FILL(0x00000000); build/asm/main_800E9058.s.o(.text); build/asm/main_800E9058.s.o(.rodata); build/asm/main_800E9058.s.o(.data); }
    .main_800E9058_bss (NOLOAD) : { build/asm/main_800E9058.s.o(.bss); }
    .main_800E9078 0x800E9078 : AT(0x000E9C78) { build/asm/data/main_800E9078.bin.o(.data); }
    .main_800E9EC4 0x800E9EC4 : AT(0x000EAAC4) { FILL(0x00000000); build/asm/main_800E9EC4.s.o(.text); build/asm/main_800E9EC4.s.o(.rodata); build/asm/main_800E9EC4.s.o(.data); }
    .main_800E9EC4_bss (NOLOAD) : { build/asm/main_800E9EC4.s.o(.bss); }
    .main_800E9EF8 0x800E9EF8 : AT(0x000EAAF8) { build/asm/data/main_800E9EF8.bin.o(.data); }
    .main_800F1DA8 0x800F1DA8 : AT(0x000F29A8) { FILL(0x00000000); build/asm/main_800F1DA8.s.o(.text); build/asm/main_800F1DA8.s.o(.rodata); build/asm/main_800F1DA8.s.o(.data); }
    .main_800F1DA8_bss (NOLOAD) : { build/asm/main_800F1DA8.s.o(.bss); }
    .main_800F1DB0 0x800F1DB0 : AT(0x000F29B0) { build/asm/data/main_800F1DB0.bin.o(.data); }
    .main_800F2958 0x800F2958 : AT(0x000F3558) { build/asm/data/main_800F2958.bin.o(.data); }
    .main_800FC760 0x800FC760 : AT(0x000FD360) { FILL(0x00000000); build/asm/main_800FC760.s.o(.text); build/asm/main_800FC760.s.o(.rodata); build/asm/main_800FC760.s.o(.data); }
    .main_800FC760_bss (NOLOAD) : { build/asm/main_800FC760.s.o(.bss); }
    .main_800FC768 0x800FC768 : AT(0x000FD368) { build/asm/data/main_800FC768.bin.o(.data); }
    .main_800FEFC0 0x800FEFC0 : AT(0x000FFBC0) { FILL(0x00000000); build/asm/main_800FEFC0.s.o(.text); build/asm/main_800FEFC0.s.o(.rodata); build/asm/main_800FEFC0.s.o(.data); }
    .main_800FEFC0_bss (NOLOAD) : { build/asm/main_800FEFC0.s.o(.bss); }
    .main_800FEFD0 0x800FEFD0 : AT(0x000FFBD0) { build/asm/data/main_800FEFD0.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
