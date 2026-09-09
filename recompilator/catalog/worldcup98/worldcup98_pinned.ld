SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80001FB4 0x80001FB4 : AT(0x00002BB4) { FILL(0x00000000); build/asm/main_80001FB4.s.o(.text); build/asm/main_80001FB4.s.o(.rodata); build/asm/main_80001FB4.s.o(.data); }
    .main_80001FB4_bss (NOLOAD) : { build/asm/main_80001FB4.s.o(.bss); }
    .main_80002380 0x80002380 : AT(0x00002F80) { FILL(0x00000000); build/asm/main_80002380.s.o(.text); build/asm/main_80002380.s.o(.rodata); build/asm/main_80002380.s.o(.data); }
    .main_80002380_bss (NOLOAD) : { build/asm/main_80002380.s.o(.bss); }
    .main_80012880 0x80012880 : AT(0x00013480) { FILL(0x00000000); build/asm/main_80012880.s.o(.text); build/asm/main_80012880.s.o(.rodata); build/asm/main_80012880.s.o(.data); }
    .main_80012880_bss (NOLOAD) : { build/asm/main_80012880.s.o(.bss); }
    .main_8001450C 0x8001450C : AT(0x0001510C) { build/asm/data/main_8001450C.bin.o(.data); }
    .main_800153E4 0x800153E4 : AT(0x00015FE4) { FILL(0x00000000); build/asm/main_800153E4.s.o(.text); build/asm/main_800153E4.s.o(.rodata); build/asm/main_800153E4.s.o(.data); }
    .main_800153E4_bss (NOLOAD) : { build/asm/main_800153E4.s.o(.bss); }
    .main_80017688 0x80017688 : AT(0x00018288) { build/asm/data/main_80017688.bin.o(.data); }
    .main_80018660 0x80018660 : AT(0x00019260) { build/asm/data/main_80018660.bin.o(.data); }
    .main_80018C44 0x80018C44 : AT(0x00019844) { build/asm/data/main_80018C44.bin.o(.data); }
    .main_80019BA0 0x80019BA0 : AT(0x0001A7A0) { build/asm/data/main_80019BA0.bin.o(.data); }
    .main_8001E1A8 0x8001E1A8 : AT(0x0001EDA8) { FILL(0x00000000); build/asm/main_8001E1A8.s.o(.text); build/asm/main_8001E1A8.s.o(.rodata); build/asm/main_8001E1A8.s.o(.data); }
    .main_8001E1A8_bss (NOLOAD) : { build/asm/main_8001E1A8.s.o(.bss); }
    .main_8001E1C8 0x8001E1C8 : AT(0x0001EDC8) { build/asm/data/main_8001E1C8.bin.o(.data); }
    .main_800219B4 0x800219B4 : AT(0x000225B4) { FILL(0x00000000); build/asm/main_800219B4.s.o(.text); build/asm/main_800219B4.s.o(.rodata); build/asm/main_800219B4.s.o(.data); }
    .main_800219B4_bss (NOLOAD) : { build/asm/main_800219B4.s.o(.bss); }
    .main_800219CC 0x800219CC : AT(0x000225CC) { build/asm/data/main_800219CC.bin.o(.data); }
    .main_80021DAC 0x80021DAC : AT(0x000229AC) { FILL(0x00000000); build/asm/main_80021DAC.s.o(.text); build/asm/main_80021DAC.s.o(.rodata); build/asm/main_80021DAC.s.o(.data); }
    .main_80021DAC_bss (NOLOAD) : { build/asm/main_80021DAC.s.o(.bss); }
    .main_80021DCC 0x80021DCC : AT(0x000229CC) { build/asm/data/main_80021DCC.bin.o(.data); }
    .main_80028FA8 0x80028FA8 : AT(0x00029BA8) { FILL(0x00000000); build/asm/main_80028FA8.s.o(.text); build/asm/main_80028FA8.s.o(.rodata); build/asm/main_80028FA8.s.o(.data); }
    .main_80028FA8_bss (NOLOAD) : { build/asm/main_80028FA8.s.o(.bss); }
    .main_80029000 0x80029000 : AT(0x00029C00) { build/asm/data/main_80029000.bin.o(.data); }
    .main_8003F56C 0x8003F56C : AT(0x0004016C) { FILL(0x00000000); build/asm/main_8003F56C.s.o(.text); build/asm/main_8003F56C.s.o(.rodata); build/asm/main_8003F56C.s.o(.data); }
    .main_8003F56C_bss (NOLOAD) : { build/asm/main_8003F56C.s.o(.bss); }
    .main_8003F58C 0x8003F58C : AT(0x0004018C) { build/asm/data/main_8003F58C.bin.o(.data); }
    .main_8004812C 0x8004812C : AT(0x00048D2C) { FILL(0x00000000); build/asm/main_8004812C.s.o(.text); build/asm/main_8004812C.s.o(.rodata); build/asm/main_8004812C.s.o(.data); }
    .main_8004812C_bss (NOLOAD) : { build/asm/main_8004812C.s.o(.bss); }
    .main_800482BC 0x800482BC : AT(0x00048EBC) { build/asm/data/main_800482BC.bin.o(.data); }
    .main_80049750 0x80049750 : AT(0x0004A350) { FILL(0x00000000); build/asm/main_80049750.s.o(.text); build/asm/main_80049750.s.o(.rodata); build/asm/main_80049750.s.o(.data); }
    .main_80049750_bss (NOLOAD) : { build/asm/main_80049750.s.o(.bss); }
    .main_8004975C 0x8004975C : AT(0x0004A35C) { build/asm/data/main_8004975C.bin.o(.data); }
    .main_8004F1D0 0x8004F1D0 : AT(0x0004FDD0) { FILL(0x00000000); build/asm/main_8004F1D0.s.o(.text); build/asm/main_8004F1D0.s.o(.rodata); build/asm/main_8004F1D0.s.o(.data); }
    .main_8004F1D0_bss (NOLOAD) : { build/asm/main_8004F1D0.s.o(.bss); }
    .main_8004F1F4 0x8004F1F4 : AT(0x0004FDF4) { build/asm/data/main_8004F1F4.bin.o(.data); }
    .main_800515A8 0x800515A8 : AT(0x000521A8) { FILL(0x00000000); build/asm/main_800515A8.s.o(.text); build/asm/main_800515A8.s.o(.rodata); build/asm/main_800515A8.s.o(.data); }
    .main_800515A8_bss (NOLOAD) : { build/asm/main_800515A8.s.o(.bss); }
    .main_80051690 0x80051690 : AT(0x00052290) { build/asm/data/main_80051690.bin.o(.data); }
    .main_80054310 0x80054310 : AT(0x00054F10) { FILL(0x00000000); build/asm/main_80054310.s.o(.text); build/asm/main_80054310.s.o(.rodata); build/asm/main_80054310.s.o(.data); }
    .main_80054310_bss (NOLOAD) : { build/asm/main_80054310.s.o(.bss); }
    .main_8005432C 0x8005432C : AT(0x00054F2C) { build/asm/data/main_8005432C.bin.o(.data); }
    .main_800585C0 0x800585C0 : AT(0x000591C0) { FILL(0x00000000); build/asm/main_800585C0.s.o(.text); build/asm/main_800585C0.s.o(.rodata); build/asm/main_800585C0.s.o(.data); }
    .main_800585C0_bss (NOLOAD) : { build/asm/main_800585C0.s.o(.bss); }
    .main_800585C4 0x800585C4 : AT(0x000591C4) { build/asm/data/main_800585C4.bin.o(.data); }
    .main_8005CB78 0x8005CB78 : AT(0x0005D778) { FILL(0x00000000); build/asm/main_8005CB78.s.o(.text); build/asm/main_8005CB78.s.o(.rodata); build/asm/main_8005CB78.s.o(.data); }
    .main_8005CB78_bss (NOLOAD) : { build/asm/main_8005CB78.s.o(.bss); }
    .main_8005CC18 0x8005CC18 : AT(0x0005D818) { build/asm/data/main_8005CC18.bin.o(.data); }
    .main_8005F314 0x8005F314 : AT(0x0005FF14) { FILL(0x00000000); build/asm/main_8005F314.s.o(.text); build/asm/main_8005F314.s.o(.rodata); build/asm/main_8005F314.s.o(.data); }
    .main_8005F314_bss (NOLOAD) : { build/asm/main_8005F314.s.o(.bss); }
    .main_8005F430 0x8005F430 : AT(0x00060030) { build/asm/data/main_8005F430.bin.o(.data); }
    .main_8006082C 0x8006082C : AT(0x0006142C) { FILL(0x00000000); build/asm/main_8006082C.s.o(.text); build/asm/main_8006082C.s.o(.rodata); build/asm/main_8006082C.s.o(.data); }
    .main_8006082C_bss (NOLOAD) : { build/asm/main_8006082C.s.o(.bss); }
    .main_80060848 0x80060848 : AT(0x00061448) { build/asm/data/main_80060848.bin.o(.data); }
    .main_800612B0 0x800612B0 : AT(0x00061EB0) { FILL(0x00000000); build/asm/main_800612B0.s.o(.text); build/asm/main_800612B0.s.o(.rodata); build/asm/main_800612B0.s.o(.data); }
    .main_800612B0_bss (NOLOAD) : { build/asm/main_800612B0.s.o(.bss); }
    .main_800612D0 0x800612D0 : AT(0x00061ED0) { build/asm/data/main_800612D0.bin.o(.data); }
    .main_800619D0 0x800619D0 : AT(0x000625D0) { FILL(0x00000000); build/asm/main_800619D0.s.o(.text); build/asm/main_800619D0.s.o(.rodata); build/asm/main_800619D0.s.o(.data); }
    .main_800619D0_bss (NOLOAD) : { build/asm/main_800619D0.s.o(.bss); }
    .main_800619D8 0x800619D8 : AT(0x000625D8) { build/asm/data/main_800619D8.bin.o(.data); }
    .main_800714EC 0x800714EC : AT(0x000720EC) { FILL(0x00000000); build/asm/main_800714EC.s.o(.text); build/asm/main_800714EC.s.o(.rodata); build/asm/main_800714EC.s.o(.data); }
    .main_800714EC_bss (NOLOAD) : { build/asm/main_800714EC.s.o(.bss); }
    .main_80071508 0x80071508 : AT(0x00072108) { build/asm/data/main_80071508.bin.o(.data); }
    .main_800741C8 0x800741C8 : AT(0x00074DC8) { FILL(0x00000000); build/asm/main_800741C8.s.o(.text); build/asm/main_800741C8.s.o(.rodata); build/asm/main_800741C8.s.o(.data); }
    .main_800741C8_bss (NOLOAD) : { build/asm/main_800741C8.s.o(.bss); }
    .main_800741F8 0x800741F8 : AT(0x00074DF8) { build/asm/data/main_800741F8.bin.o(.data); }
    .main_800778CC 0x800778CC : AT(0x000784CC) { build/asm/data/main_800778CC.bin.o(.data); }
    .main_8008BD14 0x8008BD14 : AT(0x0008C914) { FILL(0x00000000); build/asm/main_8008BD14.s.o(.text); build/asm/main_8008BD14.s.o(.rodata); build/asm/main_8008BD14.s.o(.data); }
    .main_8008BD14_bss (NOLOAD) : { build/asm/main_8008BD14.s.o(.bss); }
    .main_8008BD44 0x8008BD44 : AT(0x0008C944) { build/asm/data/main_8008BD44.bin.o(.data); }
    .main_80092A04 0x80092A04 : AT(0x00093604) { FILL(0x00000000); build/asm/main_80092A04.s.o(.text); build/asm/main_80092A04.s.o(.rodata); build/asm/main_80092A04.s.o(.data); }
    .main_80092A04_bss (NOLOAD) : { build/asm/main_80092A04.s.o(.bss); }
    .main_80092A30 0x80092A30 : AT(0x00093630) { build/asm/data/main_80092A30.bin.o(.data); }
    .main_80092B80 0x80092B80 : AT(0x00093780) { FILL(0x00000000); build/asm/main_80092B80.s.o(.text); build/asm/main_80092B80.s.o(.rodata); build/asm/main_80092B80.s.o(.data); }
    .main_80092B80_bss (NOLOAD) : { build/asm/main_80092B80.s.o(.bss); }
    .main_80092B9C 0x80092B9C : AT(0x0009379C) { build/asm/data/main_80092B9C.bin.o(.data); }
    .main_8009599C 0x8009599C : AT(0x0009659C) { FILL(0x00000000); build/asm/main_8009599C.s.o(.text); build/asm/main_8009599C.s.o(.rodata); build/asm/main_8009599C.s.o(.data); }
    .main_8009599C_bss (NOLOAD) : { build/asm/main_8009599C.s.o(.bss); }
    .main_800959BC 0x800959BC : AT(0x000965BC) { build/asm/data/main_800959BC.bin.o(.data); }
    .main_8009DBCC 0x8009DBCC : AT(0x0009E7CC) { FILL(0x00000000); build/asm/main_8009DBCC.s.o(.text); build/asm/main_8009DBCC.s.o(.rodata); build/asm/main_8009DBCC.s.o(.data); }
    .main_8009DBCC_bss (NOLOAD) : { build/asm/main_8009DBCC.s.o(.bss); }
    .main_8009DE38 0x8009DE38 : AT(0x0009EA38) { build/asm/data/main_8009DE38.bin.o(.data); }
    .main_8009E3A0 0x8009E3A0 : AT(0x0009EFA0) { FILL(0x00000000); build/asm/main_8009E3A0.s.o(.text); build/asm/main_8009E3A0.s.o(.rodata); build/asm/main_8009E3A0.s.o(.data); }
    .main_8009E3A0_bss (NOLOAD) : { build/asm/main_8009E3A0.s.o(.bss); }
    .main_8009E3BC 0x8009E3BC : AT(0x0009EFBC) { build/asm/data/main_8009E3BC.bin.o(.data); }
    .main_8009EF1C 0x8009EF1C : AT(0x0009FB1C) { FILL(0x00000000); build/asm/main_8009EF1C.s.o(.text); build/asm/main_8009EF1C.s.o(.rodata); build/asm/main_8009EF1C.s.o(.data); }
    .main_8009EF1C_bss (NOLOAD) : { build/asm/main_8009EF1C.s.o(.bss); }
    .main_8009EF20 0x8009EF20 : AT(0x0009FB20) { build/asm/data/main_8009EF20.bin.o(.data); }
    .main_800A13B8 0x800A13B8 : AT(0x000A1FB8) { FILL(0x00000000); build/asm/main_800A13B8.s.o(.text); build/asm/main_800A13B8.s.o(.rodata); build/asm/main_800A13B8.s.o(.data); }
    .main_800A13B8_bss (NOLOAD) : { build/asm/main_800A13B8.s.o(.bss); }
    .main_800A13C8 0x800A13C8 : AT(0x000A1FC8) { build/asm/data/main_800A13C8.bin.o(.data); }
    .main_800A9AC8 0x800A9AC8 : AT(0x000AA6C8) { FILL(0x00000000); build/asm/main_800A9AC8.s.o(.text); build/asm/main_800A9AC8.s.o(.rodata); build/asm/main_800A9AC8.s.o(.data); }
    .main_800A9AC8_bss (NOLOAD) : { build/asm/main_800A9AC8.s.o(.bss); }
    .main_800A9B20 0x800A9B20 : AT(0x000AA720) { build/asm/data/main_800A9B20.bin.o(.data); }
    .main_800ABCA8 0x800ABCA8 : AT(0x000AC8A8) { FILL(0x00000000); build/asm/main_800ABCA8.s.o(.text); build/asm/main_800ABCA8.s.o(.rodata); build/asm/main_800ABCA8.s.o(.data); }
    .main_800ABCA8_bss (NOLOAD) : { build/asm/main_800ABCA8.s.o(.bss); }
    .main_800ABCB4 0x800ABCB4 : AT(0x000AC8B4) { build/asm/data/main_800ABCB4.bin.o(.data); }
    .main_800B7D08 0x800B7D08 : AT(0x000B8908) { FILL(0x00000000); build/asm/main_800B7D08.s.o(.text); build/asm/main_800B7D08.s.o(.rodata); build/asm/main_800B7D08.s.o(.data); }
    .main_800B7D08_bss (NOLOAD) : { build/asm/main_800B7D08.s.o(.bss); }
    .main_800B7D90 0x800B7D90 : AT(0x000B8990) { build/asm/data/main_800B7D90.bin.o(.data); }
    .main_800CEBE4 0x800CEBE4 : AT(0x000CF7E4) { FILL(0x00000000); build/asm/main_800CEBE4.s.o(.text); build/asm/main_800CEBE4.s.o(.rodata); build/asm/main_800CEBE4.s.o(.data); }
    .main_800CEBE4_bss (NOLOAD) : { build/asm/main_800CEBE4.s.o(.bss); }
    .main_800CEBEC 0x800CEBEC : AT(0x000CF7EC) { build/asm/data/main_800CEBEC.bin.o(.data); }
    .main_800CF1A8 0x800CF1A8 : AT(0x000CFDA8) { FILL(0x00000000); build/asm/main_800CF1A8.s.o(.text); build/asm/main_800CF1A8.s.o(.rodata); build/asm/main_800CF1A8.s.o(.data); }
    .main_800CF1A8_bss (NOLOAD) : { build/asm/main_800CF1A8.s.o(.bss); }
    .main_800CF1C0 0x800CF1C0 : AT(0x000CFDC0) { build/asm/data/main_800CF1C0.bin.o(.data); }
    .main_800D038C 0x800D038C : AT(0x000D0F8C) { FILL(0x00000000); build/asm/main_800D038C.s.o(.text); build/asm/main_800D038C.s.o(.rodata); build/asm/main_800D038C.s.o(.data); }
    .main_800D038C_bss (NOLOAD) : { build/asm/main_800D038C.s.o(.bss); }
    .main_800D050C 0x800D050C : AT(0x000D110C) { build/asm/data/main_800D050C.bin.o(.data); }
    .main_800D0DA8 0x800D0DA8 : AT(0x000D19A8) { FILL(0x00000000); build/asm/main_800D0DA8.s.o(.text); build/asm/main_800D0DA8.s.o(.rodata); build/asm/main_800D0DA8.s.o(.data); }
    .main_800D0DA8_bss (NOLOAD) : { build/asm/main_800D0DA8.s.o(.bss); }
    .main_800D0DCC 0x800D0DCC : AT(0x000D19CC) { build/asm/data/main_800D0DCC.bin.o(.data); }
    .main_800D0E10 0x800D0E10 : AT(0x000D1A10) { FILL(0x00000000); build/asm/main_800D0E10.s.o(.text); build/asm/main_800D0E10.s.o(.rodata); build/asm/main_800D0E10.s.o(.data); }
    .main_800D0E10_bss (NOLOAD) : { build/asm/main_800D0E10.s.o(.bss); }
    .main_800D0E2C 0x800D0E2C : AT(0x000D1A2C) { build/asm/data/main_800D0E2C.bin.o(.data); }
    .main_800D157C 0x800D157C : AT(0x000D217C) { FILL(0x00000000); build/asm/main_800D157C.s.o(.text); build/asm/main_800D157C.s.o(.rodata); build/asm/main_800D157C.s.o(.data); }
    .main_800D157C_bss (NOLOAD) : { build/asm/main_800D157C.s.o(.bss); }
    .main_800D1584 0x800D1584 : AT(0x000D2184) { build/asm/data/main_800D1584.bin.o(.data); }
    .main_800D1698 0x800D1698 : AT(0x000D2298) { FILL(0x00000000); build/asm/main_800D1698.s.o(.text); build/asm/main_800D1698.s.o(.rodata); build/asm/main_800D1698.s.o(.data); }
    .main_800D1698_bss (NOLOAD) : { build/asm/main_800D1698.s.o(.bss); }
    .main_800D16D8 0x800D16D8 : AT(0x000D22D8) { build/asm/data/main_800D16D8.bin.o(.data); }
    .main_800D1DFC 0x800D1DFC : AT(0x000D29FC) { FILL(0x00000000); build/asm/main_800D1DFC.s.o(.text); build/asm/main_800D1DFC.s.o(.rodata); build/asm/main_800D1DFC.s.o(.data); }
    .main_800D1DFC_bss (NOLOAD) : { build/asm/main_800D1DFC.s.o(.bss); }
    .main_800D1E1C 0x800D1E1C : AT(0x000D2A1C) { build/asm/data/main_800D1E1C.bin.o(.data); }
    .main_800D1F18 0x800D1F18 : AT(0x000D2B18) { FILL(0x00000000); build/asm/main_800D1F18.s.o(.text); build/asm/main_800D1F18.s.o(.rodata); build/asm/main_800D1F18.s.o(.data); }
    .main_800D1F18_bss (NOLOAD) : { build/asm/main_800D1F18.s.o(.bss); }
    .main_800D1F48 0x800D1F48 : AT(0x000D2B48) { build/asm/data/main_800D1F48.bin.o(.data); }
    .main_800D3C00 0x800D3C00 : AT(0x000D4800) { FILL(0x00000000); build/asm/main_800D3C00.s.o(.text); build/asm/main_800D3C00.s.o(.rodata); build/asm/main_800D3C00.s.o(.data); }
    .main_800D3C00_bss (NOLOAD) : { build/asm/main_800D3C00.s.o(.bss); }
    .main_800D3C04 0x800D3C04 : AT(0x000D4804) { build/asm/data/main_800D3C04.bin.o(.data); }
    .main_800E899C 0x800E899C : AT(0x000E959C) { FILL(0x00000000); build/asm/main_800E899C.s.o(.text); build/asm/main_800E899C.s.o(.rodata); build/asm/main_800E899C.s.o(.data); }
    .main_800E899C_bss (NOLOAD) : { build/asm/main_800E899C.s.o(.bss); }
    .main_800E89B0 0x800E89B0 : AT(0x000E95B0) { build/asm/data/main_800E89B0.bin.o(.data); }
    .main_800E928C 0x800E928C : AT(0x000E9E8C) { FILL(0x00000000); build/asm/main_800E928C.s.o(.text); build/asm/main_800E928C.s.o(.rodata); build/asm/main_800E928C.s.o(.data); }
    .main_800E928C_bss (NOLOAD) : { build/asm/main_800E928C.s.o(.bss); }
    .main_800E9340 0x800E9340 : AT(0x000E9F40) { build/asm/data/main_800E9340.bin.o(.data); }
    .main_800F6564 0x800F6564 : AT(0x000F7164) { FILL(0x00000000); build/asm/main_800F6564.s.o(.text); build/asm/main_800F6564.s.o(.rodata); build/asm/main_800F6564.s.o(.data); }
    .main_800F6564_bss (NOLOAD) : { build/asm/main_800F6564.s.o(.bss); }
    .main_800F6584 0x800F6584 : AT(0x000F7184) { build/asm/data/main_800F6584.bin.o(.data); }
    .main_800F853C 0x800F853C : AT(0x000F913C) { FILL(0x00000000); build/asm/main_800F853C.s.o(.text); build/asm/main_800F853C.s.o(.rodata); build/asm/main_800F853C.s.o(.data); }
    .main_800F853C_bss (NOLOAD) : { build/asm/main_800F853C.s.o(.bss); }
    .main_800F855C 0x800F855C : AT(0x000F915C) { build/asm/data/main_800F855C.bin.o(.data); }
    .main_800F959C 0x800F959C : AT(0x000FA19C) { FILL(0x00000000); build/asm/main_800F959C.s.o(.text); build/asm/main_800F959C.s.o(.rodata); build/asm/main_800F959C.s.o(.data); }
    .main_800F959C_bss (NOLOAD) : { build/asm/main_800F959C.s.o(.bss); }
    .main_800F95A4 0x800F95A4 : AT(0x000FA1A4) { build/asm/data/main_800F95A4.bin.o(.data); }
    .main_800FEC74 0x800FEC74 : AT(0x000FF874) { FILL(0x00000000); build/asm/main_800FEC74.s.o(.text); build/asm/main_800FEC74.s.o(.rodata); build/asm/main_800FEC74.s.o(.data); }
    .main_800FEC74_bss (NOLOAD) : { build/asm/main_800FEC74.s.o(.bss); }
    .main_800FEC94 0x800FEC94 : AT(0x000FF894) { build/asm/data/main_800FEC94.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
