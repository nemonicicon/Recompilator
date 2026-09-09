SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800691F0 0x800691F0 : AT(0x00069DF0) { FILL(0x00000000); build/asm/main_800691F0.s.o(.text); build/asm/main_800691F0.s.o(.rodata); build/asm/main_800691F0.s.o(.data); }
    .main_800691F0_bss (NOLOAD) : { build/asm/main_800691F0.s.o(.bss); }
    .main_80069450 0x80069450 : AT(0x0006A050) { FILL(0x00000000); build/asm/main_80069450.s.o(.text); build/asm/main_80069450.s.o(.rodata); build/asm/main_80069450.s.o(.data); }
    .main_80069450_bss (NOLOAD) : { build/asm/main_80069450.s.o(.bss); }
    .main_80069C24 0x80069C24 : AT(0x0006A824) { FILL(0x00000000); build/asm/main_80069C24.s.o(.text); build/asm/main_80069C24.s.o(.rodata); build/asm/main_80069C24.s.o(.data); }
    .main_80069C24_bss (NOLOAD) : { build/asm/main_80069C24.s.o(.bss); }
    .main_80069D18 0x80069D18 : AT(0x0006A918) { FILL(0x00000000); build/asm/main_80069D18.s.o(.text); build/asm/main_80069D18.s.o(.rodata); build/asm/main_80069D18.s.o(.data); }
    .main_80069D18_bss (NOLOAD) : { build/asm/main_80069D18.s.o(.bss); }
    .main_8006AD20 0x8006AD20 : AT(0x0006B920) { FILL(0x00000000); build/asm/main_8006AD20.s.o(.text); build/asm/main_8006AD20.s.o(.rodata); build/asm/main_8006AD20.s.o(.data); }
    .main_8006AD20_bss (NOLOAD) : { build/asm/main_8006AD20.s.o(.bss); }
    .main_8006ADF0 0x8006ADF0 : AT(0x0006B9F0) { FILL(0x00000000); build/asm/main_8006ADF0.s.o(.text); build/asm/main_8006ADF0.s.o(.rodata); build/asm/main_8006ADF0.s.o(.data); }
    .main_8006ADF0_bss (NOLOAD) : { build/asm/main_8006ADF0.s.o(.bss); }
    .main_8006B160 0x8006B160 : AT(0x0006BD60) { FILL(0x00000000); build/asm/main_8006B160.s.o(.text); build/asm/main_8006B160.s.o(.rodata); build/asm/main_8006B160.s.o(.data); }
    .main_8006B160_bss (NOLOAD) : { build/asm/main_8006B160.s.o(.bss); }
    .main_8006B3E0 0x8006B3E0 : AT(0x0006BFE0) { FILL(0x00000000); build/asm/main_8006B3E0.s.o(.text); build/asm/main_8006B3E0.s.o(.rodata); build/asm/main_8006B3E0.s.o(.data); }
    .main_8006B3E0_bss (NOLOAD) : { build/asm/main_8006B3E0.s.o(.bss); }
    .main_8006B648 0x8006B648 : AT(0x0006C248) { FILL(0x00000000); build/asm/main_8006B648.s.o(.text); build/asm/main_8006B648.s.o(.rodata); build/asm/main_8006B648.s.o(.data); }
    .main_8006B648_bss (NOLOAD) : { build/asm/main_8006B648.s.o(.bss); }
    .main_8006BC2C 0x8006BC2C : AT(0x0006C82C) { FILL(0x00000000); build/asm/main_8006BC2C.s.o(.text); build/asm/main_8006BC2C.s.o(.rodata); build/asm/main_8006BC2C.s.o(.data); }
    .main_8006BC2C_bss (NOLOAD) : { build/asm/main_8006BC2C.s.o(.bss); }
    .main_8006BF18 0x8006BF18 : AT(0x0006CB18) { FILL(0x00000000); build/asm/main_8006BF18.s.o(.text); build/asm/main_8006BF18.s.o(.rodata); build/asm/main_8006BF18.s.o(.data); }
    .main_8006BF18_bss (NOLOAD) : { build/asm/main_8006BF18.s.o(.bss); }
    .main_8006C280 0x8006C280 : AT(0x0006CE80) { FILL(0x00000000); build/asm/main_8006C280.s.o(.text); build/asm/main_8006C280.s.o(.rodata); build/asm/main_8006C280.s.o(.data); }
    .main_8006C280_bss (NOLOAD) : { build/asm/main_8006C280.s.o(.bss); }
    .main_8006C504 0x8006C504 : AT(0x0006D104) { FILL(0x00000000); build/asm/main_8006C504.s.o(.text); build/asm/main_8006C504.s.o(.rodata); build/asm/main_8006C504.s.o(.data); }
    .main_8006C504_bss (NOLOAD) : { build/asm/main_8006C504.s.o(.bss); }
    .main_8006EBD0 0x8006EBD0 : AT(0x0006F7D0) { FILL(0x00000000); build/asm/main_8006EBD0.s.o(.text); build/asm/main_8006EBD0.s.o(.rodata); build/asm/main_8006EBD0.s.o(.data); }
    .main_8006EBD0_bss (NOLOAD) : { build/asm/main_8006EBD0.s.o(.bss); }
    .main_8006ED90 0x8006ED90 : AT(0x0006F990) { FILL(0x00000000); build/asm/main_8006ED90.s.o(.text); build/asm/main_8006ED90.s.o(.rodata); build/asm/main_8006ED90.s.o(.data); }
    .main_8006ED90_bss (NOLOAD) : { build/asm/main_8006ED90.s.o(.bss); }
    .main_8006F304 0x8006F304 : AT(0x0006FF04) { FILL(0x00000000); build/asm/main_8006F304.s.o(.text); build/asm/main_8006F304.s.o(.rodata); build/asm/main_8006F304.s.o(.data); }
    .main_8006F304_bss (NOLOAD) : { build/asm/main_8006F304.s.o(.bss); }
    .main_8006F6D0 0x8006F6D0 : AT(0x000702D0) { FILL(0x00000000); build/asm/main_8006F6D0.s.o(.text); build/asm/main_8006F6D0.s.o(.rodata); build/asm/main_8006F6D0.s.o(.data); }
    .main_8006F6D0_bss (NOLOAD) : { build/asm/main_8006F6D0.s.o(.bss); }
    .main_80072C20 0x80072C20 : AT(0x00073820) { FILL(0x00000000); build/asm/main_80072C20.s.o(.text); build/asm/main_80072C20.s.o(.rodata); build/asm/main_80072C20.s.o(.data); }
    .main_80072C20_bss (NOLOAD) : { build/asm/main_80072C20.s.o(.bss); }
    .main_80072D40 0x80072D40 : AT(0x00073940) { FILL(0x00000000); build/asm/main_80072D40.s.o(.text); build/asm/main_80072D40.s.o(.rodata); build/asm/main_80072D40.s.o(.data); }
    .main_80072D40_bss (NOLOAD) : { build/asm/main_80072D40.s.o(.bss); }
    .main_80073A80 0x80073A80 : AT(0x00074680) { FILL(0x00000000); build/asm/main_80073A80.s.o(.text); build/asm/main_80073A80.s.o(.rodata); build/asm/main_80073A80.s.o(.data); }
    .main_80073A80_bss (NOLOAD) : { build/asm/main_80073A80.s.o(.bss); }
    .main_80073F60 0x80073F60 : AT(0x00074B60) { FILL(0x00000000); build/asm/main_80073F60.s.o(.text); build/asm/main_80073F60.s.o(.rodata); build/asm/main_80073F60.s.o(.data); }
    .main_80073F60_bss (NOLOAD) : { build/asm/main_80073F60.s.o(.bss); }
    .main_800742E0 0x800742E0 : AT(0x00074EE0) { FILL(0x00000000); build/asm/main_800742E0.s.o(.text); build/asm/main_800742E0.s.o(.rodata); build/asm/main_800742E0.s.o(.data); }
    .main_800742E0_bss (NOLOAD) : { build/asm/main_800742E0.s.o(.bss); }
    .main_80074B60 0x80074B60 : AT(0x00075760) { FILL(0x00000000); build/asm/main_80074B60.s.o(.text); build/asm/main_80074B60.s.o(.rodata); build/asm/main_80074B60.s.o(.data); }
    .main_80074B60_bss (NOLOAD) : { build/asm/main_80074B60.s.o(.bss); }
    .main_80076120 0x80076120 : AT(0x00076D20) { FILL(0x00000000); build/asm/main_80076120.s.o(.text); build/asm/main_80076120.s.o(.rodata); build/asm/main_80076120.s.o(.data); }
    .main_80076120_bss (NOLOAD) : { build/asm/main_80076120.s.o(.bss); }
    .main_8007AC4C 0x8007AC4C : AT(0x0007B84C) { FILL(0x00000000); build/asm/main_8007AC4C.s.o(.text); build/asm/main_8007AC4C.s.o(.rodata); build/asm/main_8007AC4C.s.o(.data); }
    .main_8007AC4C_bss (NOLOAD) : { build/asm/main_8007AC4C.s.o(.bss); }
    .main_8007AD00 0x8007AD00 : AT(0x0007B900) { FILL(0x00000000); build/asm/main_8007AD00.s.o(.text); build/asm/main_8007AD00.s.o(.rodata); build/asm/main_8007AD00.s.o(.data); }
    .main_8007AD00_bss (NOLOAD) : { build/asm/main_8007AD00.s.o(.bss); }
    .main_8007ADB4 0x8007ADB4 : AT(0x0007B9B4) { FILL(0x00000000); build/asm/main_8007ADB4.s.o(.text); build/asm/main_8007ADB4.s.o(.rodata); build/asm/main_8007ADB4.s.o(.data); }
    .main_8007ADB4_bss (NOLOAD) : { build/asm/main_8007ADB4.s.o(.bss); }
    .main_8007AE40 0x8007AE40 : AT(0x0007BA40) { FILL(0x00000000); build/asm/main_8007AE40.s.o(.text); build/asm/main_8007AE40.s.o(.rodata); build/asm/main_8007AE40.s.o(.data); }
    .main_8007AE40_bss (NOLOAD) : { build/asm/main_8007AE40.s.o(.bss); }
    .main_80093AF0 0x80093AF0 : AT(0x000946F0) { FILL(0x00000000); build/asm/main_80093AF0.s.o(.text); build/asm/main_80093AF0.s.o(.rodata); build/asm/main_80093AF0.s.o(.data); }
    .main_80093AF0_bss (NOLOAD) : { build/asm/main_80093AF0.s.o(.bss); }
    .main_80093D08 0x80093D08 : AT(0x00094908) { FILL(0x00000000); build/asm/main_80093D08.s.o(.text); build/asm/main_80093D08.s.o(.rodata); build/asm/main_80093D08.s.o(.data); }
    .main_80093D08_bss (NOLOAD) : { build/asm/main_80093D08.s.o(.bss); }
    .main_80096B30 0x80096B30 : AT(0x00097730) { FILL(0x00000000); build/asm/main_80096B30.s.o(.text); build/asm/main_80096B30.s.o(.rodata); build/asm/main_80096B30.s.o(.data); }
    .main_80096B30_bss (NOLOAD) : { build/asm/main_80096B30.s.o(.bss); }
    .main_80096C14 0x80096C14 : AT(0x00097814) { FILL(0x00000000); build/asm/main_80096C14.s.o(.text); build/asm/main_80096C14.s.o(.rodata); build/asm/main_80096C14.s.o(.data); }
    .main_80096C14_bss (NOLOAD) : { build/asm/main_80096C14.s.o(.bss); }
    .main_80097178 0x80097178 : AT(0x00097D78) { FILL(0x00000000); build/asm/main_80097178.s.o(.text); build/asm/main_80097178.s.o(.rodata); build/asm/main_80097178.s.o(.data); }
    .main_80097178_bss (NOLOAD) : { build/asm/main_80097178.s.o(.bss); }
    .main_8009721C 0x8009721C : AT(0x00097E1C) { FILL(0x00000000); build/asm/main_8009721C.s.o(.text); build/asm/main_8009721C.s.o(.rodata); build/asm/main_8009721C.s.o(.data); }
    .main_8009721C_bss (NOLOAD) : { build/asm/main_8009721C.s.o(.bss); }
    .main_80097328 0x80097328 : AT(0x00097F28) { FILL(0x00000000); build/asm/main_80097328.s.o(.text); build/asm/main_80097328.s.o(.rodata); build/asm/main_80097328.s.o(.data); }
    .main_80097328_bss (NOLOAD) : { build/asm/main_80097328.s.o(.bss); }
    .main_80097828 0x80097828 : AT(0x00098428) { build/asm/data/main_80097828.bin.o(.data); }
    .main_80098458 0x80098458 : AT(0x00099058) { FILL(0x00000000); build/asm/main_80098458.s.o(.text); build/asm/main_80098458.s.o(.rodata); build/asm/main_80098458.s.o(.data); }
    .main_80098458_bss (NOLOAD) : { build/asm/main_80098458.s.o(.bss); }
    .main_80098464 0x80098464 : AT(0x00099064) { FILL(0x00000000); build/asm/main_80098464.s.o(.text); build/asm/main_80098464.s.o(.rodata); build/asm/main_80098464.s.o(.data); }
    .main_80098464_bss (NOLOAD) : { build/asm/main_80098464.s.o(.bss); }
    .main_80098500 0x80098500 : AT(0x00099100) { build/asm/data/main_80098500.bin.o(.data); }
    .main_8009850C 0x8009850C : AT(0x0009910C) { FILL(0x00000000); build/asm/main_8009850C.s.o(.text); build/asm/main_8009850C.s.o(.rodata); build/asm/main_8009850C.s.o(.data); }
    .main_8009850C_bss (NOLOAD) : { build/asm/main_8009850C.s.o(.bss); }
    .main_80099958 0x80099958 : AT(0x0009A558) { build/asm/data/main_80099958.bin.o(.data); }
    .main_8009AC14 0x8009AC14 : AT(0x0009B814) { FILL(0x00000000); build/asm/main_8009AC14.s.o(.text); build/asm/main_8009AC14.s.o(.rodata); build/asm/main_8009AC14.s.o(.data); }
    .main_8009AC14_bss (NOLOAD) : { build/asm/main_8009AC14.s.o(.bss); }
    .main_8009B9DC 0x8009B9DC : AT(0x0009C5DC) { build/asm/data/main_8009B9DC.bin.o(.data); }
    .main_8009BBFC 0x8009BBFC : AT(0x0009C7FC) { FILL(0x00000000); build/asm/main_8009BBFC.s.o(.text); build/asm/main_8009BBFC.s.o(.rodata); build/asm/main_8009BBFC.s.o(.data); }
    .main_8009BBFC_bss (NOLOAD) : { build/asm/main_8009BBFC.s.o(.bss); }
    .main_8009BC0C 0x8009BC0C : AT(0x0009C80C) { build/asm/data/main_8009BC0C.bin.o(.data); }
    .main_8009BD10 0x8009BD10 : AT(0x0009C910) { FILL(0x00000000); build/asm/main_8009BD10.s.o(.text); build/asm/main_8009BD10.s.o(.rodata); build/asm/main_8009BD10.s.o(.data); }
    .main_8009BD10_bss (NOLOAD) : { build/asm/main_8009BD10.s.o(.bss); }
    .main_8009BED4 0x8009BED4 : AT(0x0009CAD4) { FILL(0x00000000); build/asm/main_8009BED4.s.o(.text); build/asm/main_8009BED4.s.o(.rodata); build/asm/main_8009BED4.s.o(.data); }
    .main_8009BED4_bss (NOLOAD) : { build/asm/main_8009BED4.s.o(.bss); }
    .main_8009C130 0x8009C130 : AT(0x0009CD30) { FILL(0x00000000); build/asm/main_8009C130.s.o(.text); build/asm/main_8009C130.s.o(.rodata); build/asm/main_8009C130.s.o(.data); }
    .main_8009C130_bss (NOLOAD) : { build/asm/main_8009C130.s.o(.bss); }
    .main_8009C194 0x8009C194 : AT(0x0009CD94) { FILL(0x00000000); build/asm/main_8009C194.s.o(.text); build/asm/main_8009C194.s.o(.rodata); build/asm/main_8009C194.s.o(.data); }
    .main_8009C194_bss (NOLOAD) : { build/asm/main_8009C194.s.o(.bss); }
    .main_8009C1F8 0x8009C1F8 : AT(0x0009CDF8) { FILL(0x00000000); build/asm/main_8009C1F8.s.o(.text); build/asm/main_8009C1F8.s.o(.rodata); build/asm/main_8009C1F8.s.o(.data); }
    .main_8009C1F8_bss (NOLOAD) : { build/asm/main_8009C1F8.s.o(.bss); }
    .main_8009C208 0x8009C208 : AT(0x0009CE08) { FILL(0x00000000); build/asm/main_8009C208.s.o(.text); build/asm/main_8009C208.s.o(.rodata); build/asm/main_8009C208.s.o(.data); }
    .main_8009C208_bss (NOLOAD) : { build/asm/main_8009C208.s.o(.bss); }
    .main_8009C298 0x8009C298 : AT(0x0009CE98) { FILL(0x00000000); build/asm/main_8009C298.s.o(.text); build/asm/main_8009C298.s.o(.rodata); build/asm/main_8009C298.s.o(.data); }
    .main_8009C298_bss (NOLOAD) : { build/asm/main_8009C298.s.o(.bss); }
    .main_8009C354 0x8009C354 : AT(0x0009CF54) { FILL(0x00000000); build/asm/main_8009C354.s.o(.text); build/asm/main_8009C354.s.o(.rodata); build/asm/main_8009C354.s.o(.data); }
    .main_8009C354_bss (NOLOAD) : { build/asm/main_8009C354.s.o(.bss); }
    .main_8009C6D0 0x8009C6D0 : AT(0x0009D2D0) { FILL(0x00000000); build/asm/main_8009C6D0.s.o(.text); build/asm/main_8009C6D0.s.o(.rodata); build/asm/main_8009C6D0.s.o(.data); }
    .main_8009C6D0_bss (NOLOAD) : { build/asm/main_8009C6D0.s.o(.bss); }
    .main_8009F96C 0x8009F96C : AT(0x000A056C) { build/asm/data/main_8009F96C.bin.o(.data); }
    .main_8009FE04 0x8009FE04 : AT(0x000A0A04) { FILL(0x00000000); build/asm/main_8009FE04.s.o(.text); build/asm/main_8009FE04.s.o(.rodata); build/asm/main_8009FE04.s.o(.data); }
    .main_8009FE04_bss (NOLOAD) : { build/asm/main_8009FE04.s.o(.bss); }
    .main_8009FE68 0x8009FE68 : AT(0x000A0A68) { FILL(0x00000000); build/asm/main_8009FE68.s.o(.text); build/asm/main_8009FE68.s.o(.rodata); build/asm/main_8009FE68.s.o(.data); }
    .main_8009FE68_bss (NOLOAD) : { build/asm/main_8009FE68.s.o(.bss); }
    .main_800A1740 0x800A1740 : AT(0x000A2340) { build/asm/data/main_800A1740.bin.o(.data); }
    .main_800A278C 0x800A278C : AT(0x000A338C) { FILL(0x00000000); build/asm/main_800A278C.s.o(.text); build/asm/main_800A278C.s.o(.rodata); build/asm/main_800A278C.s.o(.data); }
    .main_800A278C_bss (NOLOAD) : { build/asm/main_800A278C.s.o(.bss); }
    .main_800A3600 0x800A3600 : AT(0x000A4200) { build/asm/data/main_800A3600.bin.o(.data); }
    .main_800A4050 0x800A4050 : AT(0x000A4C50) { build/asm/data/main_800A4050.bin.o(.data); }
    .main_800A64C0 0x800A64C0 : AT(0x000A70C0) { build/asm/data/main_800A64C0.bin.o(.data); }
    .main_800AD398 0x800AD398 : AT(0x000ADF98) { build/asm/data/main_800AD398.bin.o(.data); }
    .main_800B292C 0x800B292C : AT(0x000B352C) { build/asm/data/main_800B292C.bin.o(.data); }
    .main_800BC1F8 0x800BC1F8 : AT(0x000BCDF8) { build/asm/data/main_800BC1F8.bin.o(.data); }
    .main_800C8D0C 0x800C8D0C : AT(0x000C990C) { build/asm/data/main_800C8D0C.bin.o(.data); }
    .main_800E494C 0x800E494C : AT(0x000E554C) { FILL(0x00000000); build/asm/main_800E494C.s.o(.text); build/asm/main_800E494C.s.o(.rodata); build/asm/main_800E494C.s.o(.data); }
    .main_800E494C_bss (NOLOAD) : { build/asm/main_800E494C.s.o(.bss); }
    .main_800E6D28 0x800E6D28 : AT(0x000E7928) { build/asm/data/main_800E6D28.bin.o(.data); }
    .main_800F0924 0x800F0924 : AT(0x000F1524) { FILL(0x00000000); build/asm/main_800F0924.s.o(.text); build/asm/main_800F0924.s.o(.rodata); build/asm/main_800F0924.s.o(.data); }
    .main_800F0924_bss (NOLOAD) : { build/asm/main_800F0924.s.o(.bss); }
    .main_800F0A30 0x800F0A30 : AT(0x000F1630) { build/asm/data/main_800F0A30.bin.o(.data); }
    .main_800F12C4 0x800F12C4 : AT(0x000F1EC4) { FILL(0x00000000); build/asm/main_800F12C4.s.o(.text); build/asm/main_800F12C4.s.o(.rodata); build/asm/main_800F12C4.s.o(.data); }
    .main_800F12C4_bss (NOLOAD) : { build/asm/main_800F12C4.s.o(.bss); }
    .main_800F1358 0x800F1358 : AT(0x000F1F58) { build/asm/data/main_800F1358.bin.o(.data); }
    .main_800F13D0 0x800F13D0 : AT(0x000F1FD0) { FILL(0x00000000); build/asm/main_800F13D0.s.o(.text); build/asm/main_800F13D0.s.o(.rodata); build/asm/main_800F13D0.s.o(.data); }
    .main_800F13D0_bss (NOLOAD) : { build/asm/main_800F13D0.s.o(.bss); }
    .main_800F1408 0x800F1408 : AT(0x000F2008) { build/asm/data/main_800F1408.bin.o(.data); }
    .main_800F1620 0x800F1620 : AT(0x000F2220) { FILL(0x00000000); build/asm/main_800F1620.s.o(.text); build/asm/main_800F1620.s.o(.rodata); build/asm/main_800F1620.s.o(.data); }
    .main_800F1620_bss (NOLOAD) : { build/asm/main_800F1620.s.o(.bss); }
    .main_800F179C 0x800F179C : AT(0x000F239C) { build/asm/data/main_800F179C.bin.o(.data); }
    .main_800F1D08 0x800F1D08 : AT(0x000F2908) { FILL(0x00000000); build/asm/main_800F1D08.s.o(.text); build/asm/main_800F1D08.s.o(.rodata); build/asm/main_800F1D08.s.o(.data); }
    .main_800F1D08_bss (NOLOAD) : { build/asm/main_800F1D08.s.o(.bss); }
    .main_800F1D64 0x800F1D64 : AT(0x000F2964) { build/asm/data/main_800F1D64.bin.o(.data); }
    .main_800F1E24 0x800F1E24 : AT(0x000F2A24) { FILL(0x00000000); build/asm/main_800F1E24.s.o(.text); build/asm/main_800F1E24.s.o(.rodata); build/asm/main_800F1E24.s.o(.data); }
    .main_800F1E24_bss (NOLOAD) : { build/asm/main_800F1E24.s.o(.bss); }
    .main_800F20C4 0x800F20C4 : AT(0x000F2CC4) { build/asm/data/main_800F20C4.bin.o(.data); }
    .main_800F256C 0x800F256C : AT(0x000F316C) { FILL(0x00000000); build/asm/main_800F256C.s.o(.text); build/asm/main_800F256C.s.o(.rodata); build/asm/main_800F256C.s.o(.data); }
    .main_800F256C_bss (NOLOAD) : { build/asm/main_800F256C.s.o(.bss); }
    .main_800F26BC 0x800F26BC : AT(0x000F32BC) { build/asm/data/main_800F26BC.bin.o(.data); }
    .main_800F2EB8 0x800F2EB8 : AT(0x000F3AB8) { FILL(0x00000000); build/asm/main_800F2EB8.s.o(.text); build/asm/main_800F2EB8.s.o(.rodata); build/asm/main_800F2EB8.s.o(.data); }
    .main_800F2EB8_bss (NOLOAD) : { build/asm/main_800F2EB8.s.o(.bss); }
    .main_800F2F60 0x800F2F60 : AT(0x000F3B60) { build/asm/data/main_800F2F60.bin.o(.data); }
    .main_800F3680 0x800F3680 : AT(0x000F4280) { FILL(0x00000000); build/asm/main_800F3680.s.o(.text); build/asm/main_800F3680.s.o(.rodata); build/asm/main_800F3680.s.o(.data); }
    .main_800F3680_bss (NOLOAD) : { build/asm/main_800F3680.s.o(.bss); }
    .main_800F36C4 0x800F36C4 : AT(0x000F42C4) { build/asm/data/main_800F36C4.bin.o(.data); }
    .main_800F370C 0x800F370C : AT(0x000F430C) { FILL(0x00000000); build/asm/main_800F370C.s.o(.text); build/asm/main_800F370C.s.o(.rodata); build/asm/main_800F370C.s.o(.data); }
    .main_800F370C_bss (NOLOAD) : { build/asm/main_800F370C.s.o(.bss); }
    .main_800F3738 0x800F3738 : AT(0x000F4338) { build/asm/data/main_800F3738.bin.o(.data); }
    .main_800F3F70 0x800F3F70 : AT(0x000F4B70) { FILL(0x00000000); build/asm/main_800F3F70.s.o(.text); build/asm/main_800F3F70.s.o(.rodata); build/asm/main_800F3F70.s.o(.data); }
    .main_800F3F70_bss (NOLOAD) : { build/asm/main_800F3F70.s.o(.bss); }
    .main_800F3F7C 0x800F3F7C : AT(0x000F4B7C) { build/asm/data/main_800F3F7C.bin.o(.data); }
    .main_800F41C0 0x800F41C0 : AT(0x000F4DC0) { FILL(0x00000000); build/asm/main_800F41C0.s.o(.text); build/asm/main_800F41C0.s.o(.rodata); build/asm/main_800F41C0.s.o(.data); }
    .main_800F41C0_bss (NOLOAD) : { build/asm/main_800F41C0.s.o(.bss); }
    .main_800F41C8 0x800F41C8 : AT(0x000F4DC8) { build/asm/data/main_800F41C8.bin.o(.data); }
    .main_800F4388 0x800F4388 : AT(0x000F4F88) { FILL(0x00000000); build/asm/main_800F4388.s.o(.text); build/asm/main_800F4388.s.o(.rodata); build/asm/main_800F4388.s.o(.data); }
    .main_800F4388_bss (NOLOAD) : { build/asm/main_800F4388.s.o(.bss); }
    .main_800F439C 0x800F439C : AT(0x000F4F9C) { build/asm/data/main_800F439C.bin.o(.data); }
    .main_800F4998 0x800F4998 : AT(0x000F5598) { FILL(0x00000000); build/asm/main_800F4998.s.o(.text); build/asm/main_800F4998.s.o(.rodata); build/asm/main_800F4998.s.o(.data); }
    .main_800F4998_bss (NOLOAD) : { build/asm/main_800F4998.s.o(.bss); }
    .main_800F49D0 0x800F49D0 : AT(0x000F55D0) { build/asm/data/main_800F49D0.bin.o(.data); }
    .main_800F5844 0x800F5844 : AT(0x000F6444) { FILL(0x00000000); build/asm/main_800F5844.s.o(.text); build/asm/main_800F5844.s.o(.rodata); build/asm/main_800F5844.s.o(.data); }
    .main_800F5844_bss (NOLOAD) : { build/asm/main_800F5844.s.o(.bss); }
    .main_800F584C 0x800F584C : AT(0x000F644C) { build/asm/data/main_800F584C.bin.o(.data); }
    .main_800F6FD4 0x800F6FD4 : AT(0x000F7BD4) { FILL(0x00000000); build/asm/main_800F6FD4.s.o(.text); build/asm/main_800F6FD4.s.o(.rodata); build/asm/main_800F6FD4.s.o(.data); }
    .main_800F6FD4_bss (NOLOAD) : { build/asm/main_800F6FD4.s.o(.bss); }
    .main_800F6FFC 0x800F6FFC : AT(0x000F7BFC) { build/asm/data/main_800F6FFC.bin.o(.data); }
    .main_800F7200 0x800F7200 : AT(0x000F7E00) { FILL(0x00000000); build/asm/main_800F7200.s.o(.text); build/asm/main_800F7200.s.o(.rodata); build/asm/main_800F7200.s.o(.data); }
    .main_800F7200_bss (NOLOAD) : { build/asm/main_800F7200.s.o(.bss); }
    .main_800F7464 0x800F7464 : AT(0x000F8064) { build/asm/data/main_800F7464.bin.o(.data); }
    .main_800F7C10 0x800F7C10 : AT(0x000F8810) { FILL(0x00000000); build/asm/main_800F7C10.s.o(.text); build/asm/main_800F7C10.s.o(.rodata); build/asm/main_800F7C10.s.o(.data); }
    .main_800F7C10_bss (NOLOAD) : { build/asm/main_800F7C10.s.o(.bss); }
    .main_800F7C24 0x800F7C24 : AT(0x000F8824) { build/asm/data/main_800F7C24.bin.o(.data); }
    .main_800F7E58 0x800F7E58 : AT(0x000F8A58) { FILL(0x00000000); build/asm/main_800F7E58.s.o(.text); build/asm/main_800F7E58.s.o(.rodata); build/asm/main_800F7E58.s.o(.data); }
    .main_800F7E58_bss (NOLOAD) : { build/asm/main_800F7E58.s.o(.bss); }
    .main_800F7E74 0x800F7E74 : AT(0x000F8A74) { build/asm/data/main_800F7E74.bin.o(.data); }
    .main_800F8490 0x800F8490 : AT(0x000F9090) { FILL(0x00000000); build/asm/main_800F8490.s.o(.text); build/asm/main_800F8490.s.o(.rodata); build/asm/main_800F8490.s.o(.data); }
    .main_800F8490_bss (NOLOAD) : { build/asm/main_800F8490.s.o(.bss); }
    .main_800F84A4 0x800F84A4 : AT(0x000F90A4) { build/asm/data/main_800F84A4.bin.o(.data); }
    .main_800F8644 0x800F8644 : AT(0x000F9244) { FILL(0x00000000); build/asm/main_800F8644.s.o(.text); build/asm/main_800F8644.s.o(.rodata); build/asm/main_800F8644.s.o(.data); }
    .main_800F8644_bss (NOLOAD) : { build/asm/main_800F8644.s.o(.bss); }
    .main_800F8650 0x800F8650 : AT(0x000F9250) { build/asm/data/main_800F8650.bin.o(.data); }
    .main_800F955C 0x800F955C : AT(0x000FA15C) { FILL(0x00000000); build/asm/main_800F955C.s.o(.text); build/asm/main_800F955C.s.o(.rodata); build/asm/main_800F955C.s.o(.data); }
    .main_800F955C_bss (NOLOAD) : { build/asm/main_800F955C.s.o(.bss); }
    .main_800F9598 0x800F9598 : AT(0x000FA198) { build/asm/data/main_800F9598.bin.o(.data); }
    .main_800F97D4 0x800F97D4 : AT(0x000FA3D4) { FILL(0x00000000); build/asm/main_800F97D4.s.o(.text); build/asm/main_800F97D4.s.o(.rodata); build/asm/main_800F97D4.s.o(.data); }
    .main_800F97D4_bss (NOLOAD) : { build/asm/main_800F97D4.s.o(.bss); }
    .main_800F97F4 0x800F97F4 : AT(0x000FA3F4) { build/asm/data/main_800F97F4.bin.o(.data); }
    .main_800F9AA8 0x800F9AA8 : AT(0x000FA6A8) { FILL(0x00000000); build/asm/main_800F9AA8.s.o(.text); build/asm/main_800F9AA8.s.o(.rodata); build/asm/main_800F9AA8.s.o(.data); }
    .main_800F9AA8_bss (NOLOAD) : { build/asm/main_800F9AA8.s.o(.bss); }
    .main_800F9B60 0x800F9B60 : AT(0x000FA760) { build/asm/data/main_800F9B60.bin.o(.data); }
    .main_800F9ED8 0x800F9ED8 : AT(0x000FAAD8) { FILL(0x00000000); build/asm/main_800F9ED8.s.o(.text); build/asm/main_800F9ED8.s.o(.rodata); build/asm/main_800F9ED8.s.o(.data); }
    .main_800F9ED8_bss (NOLOAD) : { build/asm/main_800F9ED8.s.o(.bss); }
    .main_800F9EDC 0x800F9EDC : AT(0x000FAADC) { build/asm/data/main_800F9EDC.bin.o(.data); }
    .main_800FA3EC 0x800FA3EC : AT(0x000FAFEC) { FILL(0x00000000); build/asm/main_800FA3EC.s.o(.text); build/asm/main_800FA3EC.s.o(.rodata); build/asm/main_800FA3EC.s.o(.data); }
    .main_800FA3EC_bss (NOLOAD) : { build/asm/main_800FA3EC.s.o(.bss); }
    .main_800FA414 0x800FA414 : AT(0x000FB014) { build/asm/data/main_800FA414.bin.o(.data); }
    .main_800FA658 0x800FA658 : AT(0x000FB258) { FILL(0x00000000); build/asm/main_800FA658.s.o(.text); build/asm/main_800FA658.s.o(.rodata); build/asm/main_800FA658.s.o(.data); }
    .main_800FA658_bss (NOLOAD) : { build/asm/main_800FA658.s.o(.bss); }
    .main_800FA66C 0x800FA66C : AT(0x000FB26C) { build/asm/data/main_800FA66C.bin.o(.data); }
    .main_800FB844 0x800FB844 : AT(0x000FC444) { FILL(0x00000000); build/asm/main_800FB844.s.o(.text); build/asm/main_800FB844.s.o(.rodata); build/asm/main_800FB844.s.o(.data); }
    .main_800FB844_bss (NOLOAD) : { build/asm/main_800FB844.s.o(.bss); }
    .main_800FB8B8 0x800FB8B8 : AT(0x000FC4B8) { build/asm/data/main_800FB8B8.bin.o(.data); }
    .main_800FC088 0x800FC088 : AT(0x000FCC88) { FILL(0x00000000); build/asm/main_800FC088.s.o(.text); build/asm/main_800FC088.s.o(.rodata); build/asm/main_800FC088.s.o(.data); }
    .main_800FC088_bss (NOLOAD) : { build/asm/main_800FC088.s.o(.bss); }
    .main_800FC09C 0x800FC09C : AT(0x000FCC9C) { build/asm/data/main_800FC09C.bin.o(.data); }
    .main_800FC684 0x800FC684 : AT(0x000FD284) { FILL(0x00000000); build/asm/main_800FC684.s.o(.text); build/asm/main_800FC684.s.o(.rodata); build/asm/main_800FC684.s.o(.data); }
    .main_800FC684_bss (NOLOAD) : { build/asm/main_800FC684.s.o(.bss); }
    .main_800FC74C 0x800FC74C : AT(0x000FD34C) { build/asm/data/main_800FC74C.bin.o(.data); }
    .main_800FC9B0 0x800FC9B0 : AT(0x000FD5B0) { FILL(0x00000000); build/asm/main_800FC9B0.s.o(.text); build/asm/main_800FC9B0.s.o(.rodata); build/asm/main_800FC9B0.s.o(.data); }
    .main_800FC9B0_bss (NOLOAD) : { build/asm/main_800FC9B0.s.o(.bss); }
    .main_800FC9E0 0x800FC9E0 : AT(0x000FD5E0) { build/asm/data/main_800FC9E0.bin.o(.data); }
    .main_800FD0DC 0x800FD0DC : AT(0x000FDCDC) { FILL(0x00000000); build/asm/main_800FD0DC.s.o(.text); build/asm/main_800FD0DC.s.o(.rodata); build/asm/main_800FD0DC.s.o(.data); }
    .main_800FD0DC_bss (NOLOAD) : { build/asm/main_800FD0DC.s.o(.bss); }
    .main_800FD100 0x800FD100 : AT(0x000FDD00) { build/asm/data/main_800FD100.bin.o(.data); }
    .main_800FE2D0 0x800FE2D0 : AT(0x000FEED0) { FILL(0x00000000); build/asm/main_800FE2D0.s.o(.text); build/asm/main_800FE2D0.s.o(.rodata); build/asm/main_800FE2D0.s.o(.data); }
    .main_800FE2D0_bss (NOLOAD) : { build/asm/main_800FE2D0.s.o(.bss); }
    .main_800FE2F8 0x800FE2F8 : AT(0x000FEEF8) { build/asm/data/main_800FE2F8.bin.o(.data); }
    .main_800FF1A8 0x800FF1A8 : AT(0x000FFDA8) { FILL(0x00000000); build/asm/main_800FF1A8.s.o(.text); build/asm/main_800FF1A8.s.o(.rodata); build/asm/main_800FF1A8.s.o(.data); }
    .main_800FF1A8_bss (NOLOAD) : { build/asm/main_800FF1A8.s.o(.bss); }
    .main_800FF2E8 0x800FF2E8 : AT(0x000FFEE8) { build/asm/data/main_800FF2E8.bin.o(.data); }
    .main_800FF6BC 0x800FF6BC : AT(0x001002BC) { FILL(0x00000000); build/asm/main_800FF6BC.s.o(.text); build/asm/main_800FF6BC.s.o(.rodata); build/asm/main_800FF6BC.s.o(.data); }
    .main_800FF6BC_bss (NOLOAD) : { build/asm/main_800FF6BC.s.o(.bss); }
    .main_800FF7E0 0x800FF7E0 : AT(0x001003E0) { build/asm/data/main_800FF7E0.bin.o(.data); }
    .main_8010011C 0x8010011C : AT(0x00100D1C) { FILL(0x00000000); build/asm/main_8010011C.s.o(.text); build/asm/main_8010011C.s.o(.rodata); build/asm/main_8010011C.s.o(.data); }
    .main_8010011C_bss (NOLOAD) : { build/asm/main_8010011C.s.o(.bss); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
