SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80025C00 0x80025C00 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80025C00.s.o(.text); build/asm/main_80025C00.s.o(.rodata); build/asm/main_80025C00.s.o(.data); }
    .main_80025C00_bss (NOLOAD) : { build/asm/main_80025C00.s.o(.bss); }
    .main_80025E10 0x80025E10 : AT(0x00001210) { FILL(0x00000000); build/asm/main_80025E10.s.o(.text); build/asm/main_80025E10.s.o(.rodata); build/asm/main_80025E10.s.o(.data); }
    .main_80025E10_bss (NOLOAD) : { build/asm/main_80025E10.s.o(.bss); }
    .main_80042EB0 0x80042EB0 : AT(0x0001E2B0) { FILL(0x00000000); build/asm/main_80042EB0.s.o(.text); build/asm/main_80042EB0.s.o(.rodata); build/asm/main_80042EB0.s.o(.data); }
    .main_80042EB0_bss (NOLOAD) : { build/asm/main_80042EB0.s.o(.bss); }
    .main_80047A10 0x80047A10 : AT(0x00022E10) { FILL(0x00000000); build/asm/main_80047A10.s.o(.text); build/asm/main_80047A10.s.o(.rodata); build/asm/main_80047A10.s.o(.data); }
    .main_80047A10_bss (NOLOAD) : { build/asm/main_80047A10.s.o(.bss); }
    .main_8004D7C0 0x8004D7C0 : AT(0x00028BC0) { FILL(0x00000000); build/asm/main_8004D7C0.s.o(.text); build/asm/main_8004D7C0.s.o(.rodata); build/asm/main_8004D7C0.s.o(.data); }
    .main_8004D7C0_bss (NOLOAD) : { build/asm/main_8004D7C0.s.o(.bss); }
    .main_800520C0 0x800520C0 : AT(0x0002D4C0) { FILL(0x00000000); build/asm/main_800520C0.s.o(.text); build/asm/main_800520C0.s.o(.rodata); build/asm/main_800520C0.s.o(.data); }
    .main_800520C0_bss (NOLOAD) : { build/asm/main_800520C0.s.o(.bss); }
    .main_8005265C 0x8005265C : AT(0x0002DA5C) { FILL(0x00000000); build/asm/main_8005265C.s.o(.text); build/asm/main_8005265C.s.o(.rodata); build/asm/main_8005265C.s.o(.data); }
    .main_8005265C_bss (NOLOAD) : { build/asm/main_8005265C.s.o(.bss); }
    .main_80052AD0 0x80052AD0 : AT(0x0002DED0) { FILL(0x00000000); build/asm/main_80052AD0.s.o(.text); build/asm/main_80052AD0.s.o(.rodata); build/asm/main_80052AD0.s.o(.data); }
    .main_80052AD0_bss (NOLOAD) : { build/asm/main_80052AD0.s.o(.bss); }
    .main_80053BB0 0x80053BB0 : AT(0x0002EFB0) { FILL(0x00000000); build/asm/main_80053BB0.s.o(.text); build/asm/main_80053BB0.s.o(.rodata); build/asm/main_80053BB0.s.o(.data); }
    .main_80053BB0_bss (NOLOAD) : { build/asm/main_80053BB0.s.o(.bss); }
    .main_80053BE0 0x80053BE0 : AT(0x0002EFE0) { FILL(0x00000000); build/asm/main_80053BE0.s.o(.text); build/asm/main_80053BE0.s.o(.rodata); build/asm/main_80053BE0.s.o(.data); }
    .main_80053BE0_bss (NOLOAD) : { build/asm/main_80053BE0.s.o(.bss); }
    .main_80057FB4 0x80057FB4 : AT(0x000333B4) { FILL(0x00000000); build/asm/main_80057FB4.s.o(.text); build/asm/main_80057FB4.s.o(.rodata); build/asm/main_80057FB4.s.o(.data); }
    .main_80057FB4_bss (NOLOAD) : { build/asm/main_80057FB4.s.o(.bss); }
    .main_8005A508 0x8005A508 : AT(0x00035908) { build/asm/data/main_8005A508.bin.o(.data); }
    .main_8005E6C0 0x8005E6C0 : AT(0x00039AC0) { build/asm/data/main_8005E6C0.bin.o(.data); }
    .main_8005F1DC 0x8005F1DC : AT(0x0003A5DC) { FILL(0x00000000); build/asm/main_8005F1DC.s.o(.text); build/asm/main_8005F1DC.s.o(.rodata); build/asm/main_8005F1DC.s.o(.data); }
    .main_8005F1DC_bss (NOLOAD) : { build/asm/main_8005F1DC.s.o(.bss); }
    .main_8005F8F0 0x8005F8F0 : AT(0x0003ACF0) { build/asm/data/main_8005F8F0.bin.o(.data); }
    .main_80060804 0x80060804 : AT(0x0003BC04) { build/asm/data/main_80060804.bin.o(.data); }
    .main_80060A94 0x80060A94 : AT(0x0003BE94) { FILL(0x00000000); build/asm/main_80060A94.s.o(.text); build/asm/main_80060A94.s.o(.rodata); build/asm/main_80060A94.s.o(.data); }
    .main_80060A94_bss (NOLOAD) : { build/asm/main_80060A94.s.o(.bss); }
    .main_80060D24 0x80060D24 : AT(0x0003C124) { build/asm/data/main_80060D24.bin.o(.data); }
    .main_80060DE8 0x80060DE8 : AT(0x0003C1E8) { FILL(0x00000000); build/asm/main_80060DE8.s.o(.text); build/asm/main_80060DE8.s.o(.rodata); build/asm/main_80060DE8.s.o(.data); }
    .main_80060DE8_bss (NOLOAD) : { build/asm/main_80060DE8.s.o(.bss); }
    .main_80060FB4 0x80060FB4 : AT(0x0003C3B4) { FILL(0x00000000); build/asm/main_80060FB4.s.o(.text); build/asm/main_80060FB4.s.o(.rodata); build/asm/main_80060FB4.s.o(.data); }
    .main_80060FB4_bss (NOLOAD) : { build/asm/main_80060FB4.s.o(.bss); }
    .main_80061070 0x80061070 : AT(0x0003C470) { build/asm/data/main_80061070.bin.o(.data); }
    .main_80061244 0x80061244 : AT(0x0003C644) { FILL(0x00000000); build/asm/main_80061244.s.o(.text); build/asm/main_80061244.s.o(.rodata); build/asm/main_80061244.s.o(.data); }
    .main_80061244_bss (NOLOAD) : { build/asm/main_80061244.s.o(.bss); }
    .main_800612F8 0x800612F8 : AT(0x0003C6F8) { FILL(0x00000000); build/asm/main_800612F8.s.o(.text); build/asm/main_800612F8.s.o(.rodata); build/asm/main_800612F8.s.o(.data); }
    .main_800612F8_bss (NOLOAD) : { build/asm/main_800612F8.s.o(.bss); }
    .main_80061764 0x80061764 : AT(0x0003CB64) { FILL(0x00000000); build/asm/main_80061764.s.o(.text); build/asm/main_80061764.s.o(.rodata); build/asm/main_80061764.s.o(.data); }
    .main_80061764_bss (NOLOAD) : { build/asm/main_80061764.s.o(.bss); }
    .main_80061808 0x80061808 : AT(0x0003CC08) { FILL(0x00000000); build/asm/main_80061808.s.o(.text); build/asm/main_80061808.s.o(.rodata); build/asm/main_80061808.s.o(.data); }
    .main_80061808_bss (NOLOAD) : { build/asm/main_80061808.s.o(.bss); }
    .main_80061A90 0x80061A90 : AT(0x0003CE90) { FILL(0x00000000); build/asm/main_80061A90.s.o(.text); build/asm/main_80061A90.s.o(.rodata); build/asm/main_80061A90.s.o(.data); }
    .main_80061A90_bss (NOLOAD) : { build/asm/main_80061A90.s.o(.bss); }
    .main_80065BF8 0x80065BF8 : AT(0x00040FF8) { FILL(0x00000000); build/asm/main_80065BF8.s.o(.text); build/asm/main_80065BF8.s.o(.rodata); build/asm/main_80065BF8.s.o(.data); }
    .main_80065BF8_bss (NOLOAD) : { build/asm/main_80065BF8.s.o(.bss); }
    .main_80074830 0x80074830 : AT(0x0004FC30) { FILL(0x00000000); build/asm/main_80074830.s.o(.text); build/asm/main_80074830.s.o(.rodata); build/asm/main_80074830.s.o(.data); }
    .main_80074830_bss (NOLOAD) : { build/asm/main_80074830.s.o(.bss); }
    .main_80078C38 0x80078C38 : AT(0x00054038) { build/asm/data/main_80078C38.bin.o(.data); }
    .main_8007F5AC 0x8007F5AC : AT(0x0005A9AC) { FILL(0x00000000); build/asm/main_8007F5AC.s.o(.text); build/asm/main_8007F5AC.s.o(.rodata); build/asm/main_8007F5AC.s.o(.data); }
    .main_8007F5AC_bss (NOLOAD) : { build/asm/main_8007F5AC.s.o(.bss); }
    .main_800816E8 0x800816E8 : AT(0x0005CAE8) { FILL(0x00000000); build/asm/main_800816E8.s.o(.text); build/asm/main_800816E8.s.o(.rodata); build/asm/main_800816E8.s.o(.data); }
    .main_800816E8_bss (NOLOAD) : { build/asm/main_800816E8.s.o(.bss); }
    .main_80084A38 0x80084A38 : AT(0x0005FE38) { build/asm/data/main_80084A38.bin.o(.data); }
    .main_8008C304 0x8008C304 : AT(0x00067704) { FILL(0x00000000); build/asm/main_8008C304.s.o(.text); build/asm/main_8008C304.s.o(.rodata); build/asm/main_8008C304.s.o(.data); }
    .main_8008C304_bss (NOLOAD) : { build/asm/main_8008C304.s.o(.bss); }
    .main_80092160 0x80092160 : AT(0x0006D560) { build/asm/data/main_80092160.bin.o(.data); }
    .main_80092C0C 0x80092C0C : AT(0x0006E00C) { FILL(0x00000000); build/asm/main_80092C0C.s.o(.text); build/asm/main_80092C0C.s.o(.rodata); build/asm/main_80092C0C.s.o(.data); }
    .main_80092C0C_bss (NOLOAD) : { build/asm/main_80092C0C.s.o(.bss); }
    .main_80099494 0x80099494 : AT(0x00074894) { FILL(0x00000000); build/asm/main_80099494.s.o(.text); build/asm/main_80099494.s.o(.rodata); build/asm/main_80099494.s.o(.data); }
    .main_80099494_bss (NOLOAD) : { build/asm/main_80099494.s.o(.bss); }
    .main_80099DD0 0x80099DD0 : AT(0x000751D0) { build/asm/data/main_80099DD0.bin.o(.data); }
    .main_8009B860 0x8009B860 : AT(0x00076C60) { FILL(0x00000000); build/asm/main_8009B860.s.o(.text); build/asm/main_8009B860.s.o(.rodata); build/asm/main_8009B860.s.o(.data); }
    .main_8009B860_bss (NOLOAD) : { build/asm/main_8009B860.s.o(.bss); }
    .main_8009B890 0x8009B890 : AT(0x00076C90) { build/asm/data/main_8009B890.bin.o(.data); }
    .main_8009E104 0x8009E104 : AT(0x00079504) { build/asm/data/main_8009E104.bin.o(.data); }
    .main_8009F380 0x8009F380 : AT(0x0007A780) { FILL(0x00000000); build/asm/main_8009F380.s.o(.text); build/asm/main_8009F380.s.o(.rodata); build/asm/main_8009F380.s.o(.data); }
    .main_8009F380_bss (NOLOAD) : { build/asm/main_8009F380.s.o(.bss); }
    .main_8009F3F8 0x8009F3F8 : AT(0x0007A7F8) { build/asm/data/main_8009F3F8.bin.o(.data); }
    .main_800A0CD4 0x800A0CD4 : AT(0x0007C0D4) { FILL(0x00000000); build/asm/main_800A0CD4.s.o(.text); build/asm/main_800A0CD4.s.o(.rodata); build/asm/main_800A0CD4.s.o(.data); }
    .main_800A0CD4_bss (NOLOAD) : { build/asm/main_800A0CD4.s.o(.bss); }
    .main_800A0CE4 0x800A0CE4 : AT(0x0007C0E4) { build/asm/data/main_800A0CE4.bin.o(.data); }
    .main_800A17B8 0x800A17B8 : AT(0x0007CBB8) { FILL(0x00000000); build/asm/main_800A17B8.s.o(.text); build/asm/main_800A17B8.s.o(.rodata); build/asm/main_800A17B8.s.o(.data); }
    .main_800A17B8_bss (NOLOAD) : { build/asm/main_800A17B8.s.o(.bss); }
    .main_800A19E8 0x800A19E8 : AT(0x0007CDE8) { build/asm/data/main_800A19E8.bin.o(.data); }
    .main_800A2F98 0x800A2F98 : AT(0x0007E398) { FILL(0x00000000); build/asm/main_800A2F98.s.o(.text); build/asm/main_800A2F98.s.o(.rodata); build/asm/main_800A2F98.s.o(.data); }
    .main_800A2F98_bss (NOLOAD) : { build/asm/main_800A2F98.s.o(.bss); }
    .main_800A3168 0x800A3168 : AT(0x0007E568) { build/asm/data/main_800A3168.bin.o(.data); }
    .main_800A4444 0x800A4444 : AT(0x0007F844) { FILL(0x00000000); build/asm/main_800A4444.s.o(.text); build/asm/main_800A4444.s.o(.rodata); build/asm/main_800A4444.s.o(.data); }
    .main_800A4444_bss (NOLOAD) : { build/asm/main_800A4444.s.o(.bss); }
    .main_800A44AC 0x800A44AC : AT(0x0007F8AC) { build/asm/data/main_800A44AC.bin.o(.data); }
    .main_800A97E0 0x800A97E0 : AT(0x00084BE0) { FILL(0x00000000); build/asm/main_800A97E0.s.o(.text); build/asm/main_800A97E0.s.o(.rodata); build/asm/main_800A97E0.s.o(.data); }
    .main_800A97E0_bss (NOLOAD) : { build/asm/main_800A97E0.s.o(.bss); }
    .main_800A97E4 0x800A97E4 : AT(0x00084BE4) { build/asm/data/main_800A97E4.bin.o(.data); }
    .main_800AC07C 0x800AC07C : AT(0x0008747C) { build/asm/data/main_800AC07C.bin.o(.data); }
    .main_800AF7B4 0x800AF7B4 : AT(0x0008ABB4) { FILL(0x00000000); build/asm/main_800AF7B4.s.o(.text); build/asm/main_800AF7B4.s.o(.rodata); build/asm/main_800AF7B4.s.o(.data); }
    .main_800AF7B4_bss (NOLOAD) : { build/asm/main_800AF7B4.s.o(.bss); }
    .main_800AFA58 0x800AFA58 : AT(0x0008AE58) { build/asm/data/main_800AFA58.bin.o(.data); }
    .main_800B4300 0x800B4300 : AT(0x0008F700) { FILL(0x00000000); build/asm/main_800B4300.s.o(.text); build/asm/main_800B4300.s.o(.rodata); build/asm/main_800B4300.s.o(.data); }
    .main_800B4300_bss (NOLOAD) : { build/asm/main_800B4300.s.o(.bss); }
    .main_800B436C 0x800B436C : AT(0x0008F76C) { build/asm/data/main_800B436C.bin.o(.data); }
    .main_800B4478 0x800B4478 : AT(0x0008F878) { FILL(0x00000000); build/asm/main_800B4478.s.o(.text); build/asm/main_800B4478.s.o(.rodata); build/asm/main_800B4478.s.o(.data); }
    .main_800B4478_bss (NOLOAD) : { build/asm/main_800B4478.s.o(.bss); }
    .main_800B44B4 0x800B44B4 : AT(0x0008F8B4) { build/asm/data/main_800B44B4.bin.o(.data); }
    .main_800B5358 0x800B5358 : AT(0x00090758) { FILL(0x00000000); build/asm/main_800B5358.s.o(.text); build/asm/main_800B5358.s.o(.rodata); build/asm/main_800B5358.s.o(.data); }
    .main_800B5358_bss (NOLOAD) : { build/asm/main_800B5358.s.o(.bss); }
    .main_800B53C4 0x800B53C4 : AT(0x000907C4) { build/asm/data/main_800B53C4.bin.o(.data); }
    .main_800BBD2C 0x800BBD2C : AT(0x0009712C) { FILL(0x00000000); build/asm/main_800BBD2C.s.o(.text); build/asm/main_800BBD2C.s.o(.rodata); build/asm/main_800BBD2C.s.o(.data); }
    .main_800BBD2C_bss (NOLOAD) : { build/asm/main_800BBD2C.s.o(.bss); }
    .main_800BBD30 0x800BBD30 : AT(0x00097130) { build/asm/data/main_800BBD30.bin.o(.data); }
    .main_800BD0D8 0x800BD0D8 : AT(0x000984D8) { FILL(0x00000000); build/asm/main_800BD0D8.s.o(.text); build/asm/main_800BD0D8.s.o(.rodata); build/asm/main_800BD0D8.s.o(.data); }
    .main_800BD0D8_bss (NOLOAD) : { build/asm/main_800BD0D8.s.o(.bss); }
    .main_800BD164 0x800BD164 : AT(0x00098564) { build/asm/data/main_800BD164.bin.o(.data); }
    .main_800C0120 0x800C0120 : AT(0x0009B520) { FILL(0x00000000); build/asm/main_800C0120.s.o(.text); build/asm/main_800C0120.s.o(.rodata); build/asm/main_800C0120.s.o(.data); }
    .main_800C0120_bss (NOLOAD) : { build/asm/main_800C0120.s.o(.bss); }
    .main_800C01A8 0x800C01A8 : AT(0x0009B5A8) { build/asm/data/main_800C01A8.bin.o(.data); }
    .main_800C2A4C 0x800C2A4C : AT(0x0009DE4C) { FILL(0x00000000); build/asm/main_800C2A4C.s.o(.text); build/asm/main_800C2A4C.s.o(.rodata); build/asm/main_800C2A4C.s.o(.data); }
    .main_800C2A4C_bss (NOLOAD) : { build/asm/main_800C2A4C.s.o(.bss); }
    .main_800C2A68 0x800C2A68 : AT(0x0009DE68) { build/asm/data/main_800C2A68.bin.o(.data); }
    .main_800C4734 0x800C4734 : AT(0x0009FB34) { FILL(0x00000000); build/asm/main_800C4734.s.o(.text); build/asm/main_800C4734.s.o(.rodata); build/asm/main_800C4734.s.o(.data); }
    .main_800C4734_bss (NOLOAD) : { build/asm/main_800C4734.s.o(.bss); }
    .main_800C4748 0x800C4748 : AT(0x0009FB48) { build/asm/data/main_800C4748.bin.o(.data); }
    .main_800C8140 0x800C8140 : AT(0x000A3540) { FILL(0x00000000); build/asm/main_800C8140.s.o(.text); build/asm/main_800C8140.s.o(.rodata); build/asm/main_800C8140.s.o(.data); }
    .main_800C8140_bss (NOLOAD) : { build/asm/main_800C8140.s.o(.bss); }
    .main_800C815C 0x800C815C : AT(0x000A355C) { build/asm/data/main_800C815C.bin.o(.data); }
    .main_800CE2B8 0x800CE2B8 : AT(0x000A96B8) { FILL(0x00000000); build/asm/main_800CE2B8.s.o(.text); build/asm/main_800CE2B8.s.o(.rodata); build/asm/main_800CE2B8.s.o(.data); }
    .main_800CE2B8_bss (NOLOAD) : { build/asm/main_800CE2B8.s.o(.bss); }
    .main_800CE2CC 0x800CE2CC : AT(0x000A96CC) { build/asm/data/main_800CE2CC.bin.o(.data); }
    .main_800D45C8 0x800D45C8 : AT(0x000AF9C8) { FILL(0x00000000); build/asm/main_800D45C8.s.o(.text); build/asm/main_800D45C8.s.o(.rodata); build/asm/main_800D45C8.s.o(.data); }
    .main_800D45C8_bss (NOLOAD) : { build/asm/main_800D45C8.s.o(.bss); }
    .main_800D45D8 0x800D45D8 : AT(0x000AF9D8) { build/asm/data/main_800D45D8.bin.o(.data); }
    .main_800D5A08 0x800D5A08 : AT(0x000B0E08) { FILL(0x00000000); build/asm/main_800D5A08.s.o(.text); build/asm/main_800D5A08.s.o(.rodata); build/asm/main_800D5A08.s.o(.data); }
    .main_800D5A08_bss (NOLOAD) : { build/asm/main_800D5A08.s.o(.bss); }
    .main_800D5B8C 0x800D5B8C : AT(0x000B0F8C) { build/asm/data/main_800D5B8C.bin.o(.data); }
    .main_800DF6C4 0x800DF6C4 : AT(0x000BAAC4) { build/asm/data/main_800DF6C4.bin.o(.data); }
    .main_800E475C 0x800E475C : AT(0x000BFB5C) { build/asm/data/main_800E475C.bin.o(.data); }
    .main_800E534C 0x800E534C : AT(0x000C074C) { build/asm/data/main_800E534C.bin.o(.data); }
    .main_800E5808 0x800E5808 : AT(0x000C0C08) { build/asm/data/main_800E5808.bin.o(.data); }
    .main_800E66B8 0x800E66B8 : AT(0x000C1AB8) { build/asm/data/main_800E66B8.bin.o(.data); }
    .main_800E6BB8 0x800E6BB8 : AT(0x000C1FB8) { build/asm/data/main_800E6BB8.bin.o(.data); }
    .main_800E6F0C 0x800E6F0C : AT(0x000C230C) { FILL(0x00000000); build/asm/main_800E6F0C.s.o(.text); build/asm/main_800E6F0C.s.o(.rodata); build/asm/main_800E6F0C.s.o(.data); }
    .main_800E6F0C_bss (NOLOAD) : { build/asm/main_800E6F0C.s.o(.bss); }
    .main_800E6F28 0x800E6F28 : AT(0x000C2328) { build/asm/data/main_800E6F28.bin.o(.data); }
    .main_800E847C 0x800E847C : AT(0x000C387C) { build/asm/data/main_800E847C.bin.o(.data); }
    .main_800EB078 0x800EB078 : AT(0x000C6478) { build/asm/data/main_800EB078.bin.o(.data); }
    .main_800EC3E4 0x800EC3E4 : AT(0x000C77E4) { FILL(0x00000000); build/asm/main_800EC3E4.s.o(.text); build/asm/main_800EC3E4.s.o(.rodata); build/asm/main_800EC3E4.s.o(.data); }
    .main_800EC3E4_bss (NOLOAD) : { build/asm/main_800EC3E4.s.o(.bss); }
    .main_800EC724 0x800EC724 : AT(0x000C7B24) { build/asm/data/main_800EC724.bin.o(.data); }
    .main_800EC7FC 0x800EC7FC : AT(0x000C7BFC) { FILL(0x00000000); build/asm/main_800EC7FC.s.o(.text); build/asm/main_800EC7FC.s.o(.rodata); build/asm/main_800EC7FC.s.o(.data); }
    .main_800EC7FC_bss (NOLOAD) : { build/asm/main_800EC7FC.s.o(.bss); }
    .main_800EC8F0 0x800EC8F0 : AT(0x000C7CF0) { build/asm/data/main_800EC8F0.bin.o(.data); }
    .main_800ECC0C 0x800ECC0C : AT(0x000C800C) { FILL(0x00000000); build/asm/main_800ECC0C.s.o(.text); build/asm/main_800ECC0C.s.o(.rodata); build/asm/main_800ECC0C.s.o(.data); }
    .main_800ECC0C_bss (NOLOAD) : { build/asm/main_800ECC0C.s.o(.bss); }
    .main_800ECC68 0x800ECC68 : AT(0x000C8068) { build/asm/data/main_800ECC68.bin.o(.data); }
    .main_800ED028 0x800ED028 : AT(0x000C8428) { FILL(0x00000000); build/asm/main_800ED028.s.o(.text); build/asm/main_800ED028.s.o(.rodata); build/asm/main_800ED028.s.o(.data); }
    .main_800ED028_bss (NOLOAD) : { build/asm/main_800ED028.s.o(.bss); }
    .main_800ED094 0x800ED094 : AT(0x000C8494) { build/asm/data/main_800ED094.bin.o(.data); }
    .main_800F113C 0x800F113C : AT(0x000CC53C) { FILL(0x00000000); build/asm/main_800F113C.s.o(.text); build/asm/main_800F113C.s.o(.rodata); build/asm/main_800F113C.s.o(.data); }
    .main_800F113C_bss (NOLOAD) : { build/asm/main_800F113C.s.o(.bss); }
    .main_800F1140 0x800F1140 : AT(0x000CC540) { build/asm/data/main_800F1140.bin.o(.data); }
    .main_800F1E6C 0x800F1E6C : AT(0x000CD26C) { FILL(0x00000000); build/asm/main_800F1E6C.s.o(.text); build/asm/main_800F1E6C.s.o(.rodata); build/asm/main_800F1E6C.s.o(.data); }
    .main_800F1E6C_bss (NOLOAD) : { build/asm/main_800F1E6C.s.o(.bss); }
    .main_800F1E98 0x800F1E98 : AT(0x000CD298) { build/asm/data/main_800F1E98.bin.o(.data); }
    .main_800F360C 0x800F360C : AT(0x000CEA0C) { build/asm/data/main_800F360C.bin.o(.data); }
    .main_800F63C4 0x800F63C4 : AT(0x000D17C4) { FILL(0x00000000); build/asm/main_800F63C4.s.o(.text); build/asm/main_800F63C4.s.o(.rodata); build/asm/main_800F63C4.s.o(.data); }
    .main_800F63C4_bss (NOLOAD) : { build/asm/main_800F63C4.s.o(.bss); }
    .main_800F63FC 0x800F63FC : AT(0x000D17FC) { build/asm/data/main_800F63FC.bin.o(.data); }
    .main_800F8010 0x800F8010 : AT(0x000D3410) { FILL(0x00000000); build/asm/main_800F8010.s.o(.text); build/asm/main_800F8010.s.o(.rodata); build/asm/main_800F8010.s.o(.data); }
    .main_800F8010_bss (NOLOAD) : { build/asm/main_800F8010.s.o(.bss); }
    .main_800F9B40 0x800F9B40 : AT(0x000D4F40) { build/asm/data/main_800F9B40.bin.o(.data); }
    .main_800FB7C0 0x800FB7C0 : AT(0x000D6BC0) { FILL(0x00000000); build/asm/main_800FB7C0.s.o(.text); build/asm/main_800FB7C0.s.o(.rodata); build/asm/main_800FB7C0.s.o(.data); }
    .main_800FB7C0_bss (NOLOAD) : { build/asm/main_800FB7C0.s.o(.bss); }
    .main_800FB7DC 0x800FB7DC : AT(0x000D6BDC) { build/asm/data/main_800FB7DC.bin.o(.data); }
    .main_800FD5F8 0x800FD5F8 : AT(0x000D89F8) { build/asm/data/main_800FD5F8.bin.o(.data); }
    .main_800FDC24 0x800FDC24 : AT(0x000D9024) { build/asm/data/main_800FDC24.bin.o(.data); }
    .main_80100370 0x80100370 : AT(0x000DB770) { build/asm/data/main_80100370.bin.o(.data); }
    .main_80101834 0x80101834 : AT(0x000DCC34) { FILL(0x00000000); build/asm/main_80101834.s.o(.text); build/asm/main_80101834.s.o(.rodata); build/asm/main_80101834.s.o(.data); }
    .main_80101834_bss (NOLOAD) : { build/asm/main_80101834.s.o(.bss); }
    .main_8010186C 0x8010186C : AT(0x000DCC6C) { build/asm/data/main_8010186C.bin.o(.data); }
    .main_80102EA8 0x80102EA8 : AT(0x000DE2A8) { build/asm/data/main_80102EA8.bin.o(.data); }
    .main_8010A2A4 0x8010A2A4 : AT(0x000E56A4) { build/asm/data/main_8010A2A4.bin.o(.data); }
    .main_8010C96C 0x8010C96C : AT(0x000E7D6C) { build/asm/data/main_8010C96C.bin.o(.data); }
    .main_801119C4 0x801119C4 : AT(0x000ECDC4) { FILL(0x00000000); build/asm/main_801119C4.s.o(.text); build/asm/main_801119C4.s.o(.rodata); build/asm/main_801119C4.s.o(.data); }
    .main_801119C4_bss (NOLOAD) : { build/asm/main_801119C4.s.o(.bss); }
    .main_801119C8 0x801119C8 : AT(0x000ECDC8) { build/asm/data/main_801119C8.bin.o(.data); }
    .main_80112350 0x80112350 : AT(0x000ED750) { FILL(0x00000000); build/asm/main_80112350.s.o(.text); build/asm/main_80112350.s.o(.rodata); build/asm/main_80112350.s.o(.data); }
    .main_80112350_bss (NOLOAD) : { build/asm/main_80112350.s.o(.bss); }
    .main_801123AC 0x801123AC : AT(0x000ED7AC) { build/asm/data/main_801123AC.bin.o(.data); }
    .main_80112CDC 0x80112CDC : AT(0x000EE0DC) { build/asm/data/main_80112CDC.bin.o(.data); }
    .main_80112E04 0x80112E04 : AT(0x000EE204) { build/asm/data/main_80112E04.bin.o(.data); }
    .main_80113280 0x80113280 : AT(0x000EE680) { build/asm/data/main_80113280.bin.o(.data); }
    .main_801132B0 0x801132B0 : AT(0x000EE6B0) { build/asm/data/main_801132B0.bin.o(.data); }
    .main_801136FC 0x801136FC : AT(0x000EEAFC) { FILL(0x00000000); build/asm/main_801136FC.s.o(.text); build/asm/main_801136FC.s.o(.rodata); build/asm/main_801136FC.s.o(.data); }
    .main_801136FC_bss (NOLOAD) : { build/asm/main_801136FC.s.o(.bss); }
    .main_8011378C 0x8011378C : AT(0x000EEB8C) { FILL(0x00000000); build/asm/main_8011378C.s.o(.text); build/asm/main_8011378C.s.o(.rodata); build/asm/main_8011378C.s.o(.data); }
    .main_8011378C_bss (NOLOAD) : { build/asm/main_8011378C.s.o(.bss); }
    .main_801138EC 0x801138EC : AT(0x000EECEC) { build/asm/data/main_801138EC.bin.o(.data); }
    .main_80113990 0x80113990 : AT(0x000EED90) { build/asm/data/main_80113990.bin.o(.data); }
    .main_80113DA0 0x80113DA0 : AT(0x000EF1A0) { FILL(0x00000000); build/asm/main_80113DA0.s.o(.text); build/asm/main_80113DA0.s.o(.rodata); build/asm/main_80113DA0.s.o(.data); }
    .main_80113DA0_bss (NOLOAD) : { build/asm/main_80113DA0.s.o(.bss); }
    .main_80113DC8 0x80113DC8 : AT(0x000EF1C8) { build/asm/data/main_80113DC8.bin.o(.data); }
    .main_80113FCC 0x80113FCC : AT(0x000EF3CC) { FILL(0x00000000); build/asm/main_80113FCC.s.o(.text); build/asm/main_80113FCC.s.o(.rodata); build/asm/main_80113FCC.s.o(.data); }
    .main_80113FCC_bss (NOLOAD) : { build/asm/main_80113FCC.s.o(.bss); }
    .main_80114140 0x80114140 : AT(0x000EF540) { FILL(0x00000000); build/asm/main_80114140.s.o(.text); build/asm/main_80114140.s.o(.rodata); build/asm/main_80114140.s.o(.data); }
    .main_80114140_bss (NOLOAD) : { build/asm/main_80114140.s.o(.bss); }
    .main_80114160 0x80114160 : AT(0x000EF560) { build/asm/data/main_80114160.bin.o(.data); }
    .main_80114550 0x80114550 : AT(0x000EF950) { build/asm/data/main_80114550.bin.o(.data); }
    .main_80114640 0x80114640 : AT(0x000EFA40) { build/asm/data/main_80114640.bin.o(.data); }
    .main_80115054 0x80115054 : AT(0x000F0454) { FILL(0x00000000); build/asm/main_80115054.s.o(.text); build/asm/main_80115054.s.o(.rodata); build/asm/main_80115054.s.o(.data); }
    .main_80115054_bss (NOLOAD) : { build/asm/main_80115054.s.o(.bss); }
    .main_80115060 0x80115060 : AT(0x000F0460) { build/asm/data/main_80115060.bin.o(.data); }
    .main_80115968 0x80115968 : AT(0x000F0D68) { build/asm/data/main_80115968.bin.o(.data); }
    .main_80115D70 0x80115D70 : AT(0x000F1170) { build/asm/data/main_80115D70.bin.o(.data); }
    .main_80115DF4 0x80115DF4 : AT(0x000F11F4) { FILL(0x00000000); build/asm/main_80115DF4.s.o(.text); build/asm/main_80115DF4.s.o(.rodata); build/asm/main_80115DF4.s.o(.data); }
    .main_80115DF4_bss (NOLOAD) : { build/asm/main_80115DF4.s.o(.bss); }
    .main_80115E24 0x80115E24 : AT(0x000F1224) { build/asm/data/main_80115E24.bin.o(.data); }
    .main_8011641C 0x8011641C : AT(0x000F181C) { build/asm/data/main_8011641C.bin.o(.data); }
    .main_801170DC 0x801170DC : AT(0x000F24DC) { FILL(0x00000000); build/asm/main_801170DC.s.o(.text); build/asm/main_801170DC.s.o(.rodata); build/asm/main_801170DC.s.o(.data); }
    .main_801170DC_bss (NOLOAD) : { build/asm/main_801170DC.s.o(.bss); }
    .main_80117124 0x80117124 : AT(0x000F2524) { build/asm/data/main_80117124.bin.o(.data); }
    .main_80118040 0x80118040 : AT(0x000F3440) { build/asm/data/main_80118040.bin.o(.data); }
    .main_80118D7C 0x80118D7C : AT(0x000F417C) { FILL(0x00000000); build/asm/main_80118D7C.s.o(.text); build/asm/main_80118D7C.s.o(.rodata); build/asm/main_80118D7C.s.o(.data); }
    .main_80118D7C_bss (NOLOAD) : { build/asm/main_80118D7C.s.o(.bss); }
    .main_80118D94 0x80118D94 : AT(0x000F4194) { build/asm/data/main_80118D94.bin.o(.data); }
    .main_8011917C 0x8011917C : AT(0x000F457C) { build/asm/data/main_8011917C.bin.o(.data); }
    .main_8011AB50 0x8011AB50 : AT(0x000F5F50) { build/asm/data/main_8011AB50.bin.o(.data); }
    .main_8011B634 0x8011B634 : AT(0x000F6A34) { build/asm/data/main_8011B634.bin.o(.data); }
    .main_8011B8AC 0x8011B8AC : AT(0x000F6CAC) { build/asm/data/main_8011B8AC.bin.o(.data); }
    .main_8011C060 0x8011C060 : AT(0x000F7460) { build/asm/data/main_8011C060.bin.o(.data); }
    .main_8011D2C0 0x8011D2C0 : AT(0x000F86C0) { FILL(0x00000000); build/asm/main_8011D2C0.s.o(.text); build/asm/main_8011D2C0.s.o(.rodata); build/asm/main_8011D2C0.s.o(.data); }
    .main_8011D2C0_bss (NOLOAD) : { build/asm/main_8011D2C0.s.o(.bss); }
    .main_8011D304 0x8011D304 : AT(0x000F8704) { build/asm/data/main_8011D304.bin.o(.data); }
    .main_8011FD08 0x8011FD08 : AT(0x000FB108) { build/asm/data/main_8011FD08.bin.o(.data); }
    .main_801206E0 0x801206E0 : AT(0x000FBAE0) { FILL(0x00000000); build/asm/main_801206E0.s.o(.text); build/asm/main_801206E0.s.o(.rodata); build/asm/main_801206E0.s.o(.data); }
    .main_801206E0_bss (NOLOAD) : { build/asm/main_801206E0.s.o(.bss); }
    .main_80120980 0x80120980 : AT(0x000FBD80) { FILL(0x00000000); build/asm/main_80120980.s.o(.text); build/asm/main_80120980.s.o(.rodata); build/asm/main_80120980.s.o(.data); }
    .main_80120980_bss (NOLOAD) : { build/asm/main_80120980.s.o(.bss); }
    .main_801209C0 0x801209C0 : AT(0x000FBDC0) { build/asm/data/main_801209C0.bin.o(.data); }
    .main_80120A7C 0x80120A7C : AT(0x000FBE7C) { build/asm/data/main_80120A7C.bin.o(.data); }
    .main_80120CB4 0x80120CB4 : AT(0x000FC0B4) { FILL(0x00000000); build/asm/main_80120CB4.s.o(.text); build/asm/main_80120CB4.s.o(.rodata); build/asm/main_80120CB4.s.o(.data); }
    .main_80120CB4_bss (NOLOAD) : { build/asm/main_80120CB4.s.o(.bss); }
    .main_80120CEC 0x80120CEC : AT(0x000FC0EC) { build/asm/data/main_80120CEC.bin.o(.data); }
    .main_801219C8 0x801219C8 : AT(0x000FCDC8) { FILL(0x00000000); build/asm/main_801219C8.s.o(.text); build/asm/main_801219C8.s.o(.rodata); build/asm/main_801219C8.s.o(.data); }
    .main_801219C8_bss (NOLOAD) : { build/asm/main_801219C8.s.o(.bss); }
    .main_801219CC 0x801219CC : AT(0x000FCDCC) { build/asm/data/main_801219CC.bin.o(.data); }
    .main_801238F0 0x801238F0 : AT(0x000FECF0) { FILL(0x00000000); build/asm/main_801238F0.s.o(.text); build/asm/main_801238F0.s.o(.rodata); build/asm/main_801238F0.s.o(.data); }
    .main_801238F0_bss (NOLOAD) : { build/asm/main_801238F0.s.o(.bss); }
    .main_80124D3C 0x80124D3C : AT(0x0010013C) { build/asm/data/main_80124D3C.bin.o(.data); }
    .assets 0x80425C00 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
