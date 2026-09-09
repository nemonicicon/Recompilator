SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80002B50 0x80002B50 : AT(0x00003750) { FILL(0x00000000); build/asm/main_80002B50.s.o(.text); build/asm/main_80002B50.s.o(.rodata); build/asm/main_80002B50.s.o(.data); }
    .main_80002B50_bss (NOLOAD) : { build/asm/main_80002B50.s.o(.bss); }
    .main_8005F554 0x8005F554 : AT(0x00060154) { FILL(0x00000000); build/asm/main_8005F554.s.o(.text); build/asm/main_8005F554.s.o(.rodata); build/asm/main_8005F554.s.o(.data); }
    .main_8005F554_bss (NOLOAD) : { build/asm/main_8005F554.s.o(.bss); }
    .main_8005F920 0x8005F920 : AT(0x00060520) { FILL(0x00000000); build/asm/main_8005F920.s.o(.text); build/asm/main_8005F920.s.o(.rodata); build/asm/main_8005F920.s.o(.data); }
    .main_8005F920_bss (NOLOAD) : { build/asm/main_8005F920.s.o(.bss); }
    .main_800646A8 0x800646A8 : AT(0x000652A8) { FILL(0x00000000); build/asm/main_800646A8.s.o(.text); build/asm/main_800646A8.s.o(.rodata); build/asm/main_800646A8.s.o(.data); }
    .main_800646A8_bss (NOLOAD) : { build/asm/main_800646A8.s.o(.bss); }
    .main_800652E0 0x800652E0 : AT(0x00065EE0) { FILL(0x00000000); build/asm/main_800652E0.s.o(.text); build/asm/main_800652E0.s.o(.rodata); build/asm/main_800652E0.s.o(.data); }
    .main_800652E0_bss (NOLOAD) : { build/asm/main_800652E0.s.o(.bss); }
    .main_800653F0 0x800653F0 : AT(0x00065FF0) { FILL(0x00000000); build/asm/main_800653F0.s.o(.text); build/asm/main_800653F0.s.o(.rodata); build/asm/main_800653F0.s.o(.data); }
    .main_800653F0_bss (NOLOAD) : { build/asm/main_800653F0.s.o(.bss); }
    .main_800654B0 0x800654B0 : AT(0x000660B0) { FILL(0x00000000); build/asm/main_800654B0.s.o(.text); build/asm/main_800654B0.s.o(.rodata); build/asm/main_800654B0.s.o(.data); }
    .main_800654B0_bss (NOLOAD) : { build/asm/main_800654B0.s.o(.bss); }
    .main_800676D4 0x800676D4 : AT(0x000682D4) { FILL(0x00000000); build/asm/main_800676D4.s.o(.text); build/asm/main_800676D4.s.o(.rodata); build/asm/main_800676D4.s.o(.data); }
    .main_800676D4_bss (NOLOAD) : { build/asm/main_800676D4.s.o(.bss); }
    .main_80067A30 0x80067A30 : AT(0x00068630) { FILL(0x00000000); build/asm/main_80067A30.s.o(.text); build/asm/main_80067A30.s.o(.rodata); build/asm/main_80067A30.s.o(.data); }
    .main_80067A30_bss (NOLOAD) : { build/asm/main_80067A30.s.o(.bss); }
    .main_80068954 0x80068954 : AT(0x00069554) { build/asm/data/main_80068954.bin.o(.data); }
    .main_80069C70 0x80069C70 : AT(0x0006A870) { build/asm/data/main_80069C70.bin.o(.data); }
    .main_8006ABD8 0x8006ABD8 : AT(0x0006B7D8) { build/asm/data/main_8006ABD8.bin.o(.data); }
    .main_8006BBEC 0x8006BBEC : AT(0x0006C7EC) { build/asm/data/main_8006BBEC.bin.o(.data); }
    .main_8006C960 0x8006C960 : AT(0x0006D560) { build/asm/data/main_8006C960.bin.o(.data); }
    .main_8006D6FC 0x8006D6FC : AT(0x0006E2FC) { FILL(0x00000000); build/asm/main_8006D6FC.s.o(.text); build/asm/main_8006D6FC.s.o(.rodata); build/asm/main_8006D6FC.s.o(.data); }
    .main_8006D6FC_bss (NOLOAD) : { build/asm/main_8006D6FC.s.o(.bss); }
    .main_8006DB88 0x8006DB88 : AT(0x0006E788) { build/asm/data/main_8006DB88.bin.o(.data); }
    .main_800707BC 0x800707BC : AT(0x000713BC) { FILL(0x00000000); build/asm/main_800707BC.s.o(.text); build/asm/main_800707BC.s.o(.rodata); build/asm/main_800707BC.s.o(.data); }
    .main_800707BC_bss (NOLOAD) : { build/asm/main_800707BC.s.o(.bss); }
    .main_80070A14 0x80070A14 : AT(0x00071614) { FILL(0x00000000); build/asm/main_80070A14.s.o(.text); build/asm/main_80070A14.s.o(.rodata); build/asm/main_80070A14.s.o(.data); }
    .main_80070A14_bss (NOLOAD) : { build/asm/main_80070A14.s.o(.bss); }
    .main_80070D48 0x80070D48 : AT(0x00071948) { build/asm/data/main_80070D48.bin.o(.data); }
    .main_80071D28 0x80071D28 : AT(0x00072928) { build/asm/data/main_80071D28.bin.o(.data); }
    .main_800720E4 0x800720E4 : AT(0x00072CE4) { build/asm/data/main_800720E4.bin.o(.data); }
    .main_80072F98 0x80072F98 : AT(0x00073B98) { FILL(0x00000000); build/asm/main_80072F98.s.o(.text); build/asm/main_80072F98.s.o(.rodata); build/asm/main_80072F98.s.o(.data); }
    .main_80072F98_bss (NOLOAD) : { build/asm/main_80072F98.s.o(.bss); }
    .main_80073F2C 0x80073F2C : AT(0x00074B2C) { build/asm/data/main_80073F2C.bin.o(.data); }
    .main_80075030 0x80075030 : AT(0x00075C30) { build/asm/data/main_80075030.bin.o(.data); }
    .main_800763C0 0x800763C0 : AT(0x00076FC0) { build/asm/data/main_800763C0.bin.o(.data); }
    .main_80076A00 0x80076A00 : AT(0x00077600) { FILL(0x00000000); build/asm/main_80076A00.s.o(.text); build/asm/main_80076A00.s.o(.rodata); build/asm/main_80076A00.s.o(.data); }
    .main_80076A00_bss (NOLOAD) : { build/asm/main_80076A00.s.o(.bss); }
    .main_80077200 0x80077200 : AT(0x00077E00) { FILL(0x00000000); build/asm/main_80077200.s.o(.text); build/asm/main_80077200.s.o(.rodata); build/asm/main_80077200.s.o(.data); }
    .main_80077200_bss (NOLOAD) : { build/asm/main_80077200.s.o(.bss); }
    .main_80077214 0x80077214 : AT(0x00077E14) { build/asm/data/main_80077214.bin.o(.data); }
    .main_80077650 0x80077650 : AT(0x00078250) { build/asm/data/main_80077650.bin.o(.data); }
    .main_80078868 0x80078868 : AT(0x00079468) { build/asm/data/main_80078868.bin.o(.data); }
    .main_80079568 0x80079568 : AT(0x0007A168) { build/asm/data/main_80079568.bin.o(.data); }
    .main_80079BF4 0x80079BF4 : AT(0x0007A7F4) { build/asm/data/main_80079BF4.bin.o(.data); }
    .main_8007AE78 0x8007AE78 : AT(0x0007BA78) { build/asm/data/main_8007AE78.bin.o(.data); }
    .main_80086F70 0x80086F70 : AT(0x00087B70) { build/asm/data/main_80086F70.bin.o(.data); }
    .main_80087598 0x80087598 : AT(0x00088198) { build/asm/data/main_80087598.bin.o(.data); }
    .main_80087ACC 0x80087ACC : AT(0x000886CC) { build/asm/data/main_80087ACC.bin.o(.data); }
    .main_80088658 0x80088658 : AT(0x00089258) { build/asm/data/main_80088658.bin.o(.data); }
    .main_80088FFC 0x80088FFC : AT(0x00089BFC) { build/asm/data/main_80088FFC.bin.o(.data); }
    .main_8008A0EC 0x8008A0EC : AT(0x0008ACEC) { build/asm/data/main_8008A0EC.bin.o(.data); }
    .main_8008AF20 0x8008AF20 : AT(0x0008BB20) { build/asm/data/main_8008AF20.bin.o(.data); }
    .main_8008C7CC 0x8008C7CC : AT(0x0008D3CC) { build/asm/data/main_8008C7CC.bin.o(.data); }
    .main_8008CB24 0x8008CB24 : AT(0x0008D724) { build/asm/data/main_8008CB24.bin.o(.data); }
    .main_8008CD38 0x8008CD38 : AT(0x0008D938) { build/asm/data/main_8008CD38.bin.o(.data); }
    .main_8008DD38 0x8008DD38 : AT(0x0008E938) { build/asm/data/main_8008DD38.bin.o(.data); }
    .main_8008E9E0 0x8008E9E0 : AT(0x0008F5E0) { build/asm/data/main_8008E9E0.bin.o(.data); }
    .main_8008F5A4 0x8008F5A4 : AT(0x000901A4) { build/asm/data/main_8008F5A4.bin.o(.data); }
    .main_80090EC8 0x80090EC8 : AT(0x00091AC8) { build/asm/data/main_80090EC8.bin.o(.data); }
    .main_8009E060 0x8009E060 : AT(0x0009EC60) { build/asm/data/main_8009E060.bin.o(.data); }
    .main_8009FF84 0x8009FF84 : AT(0x000A0B84) { build/asm/data/main_8009FF84.bin.o(.data); }
    .main_800A3358 0x800A3358 : AT(0x000A3F58) { FILL(0x00000000); build/asm/main_800A3358.s.o(.text); build/asm/main_800A3358.s.o(.rodata); build/asm/main_800A3358.s.o(.data); }
    .main_800A3358_bss (NOLOAD) : { build/asm/main_800A3358.s.o(.bss); }
    .main_800A3394 0x800A3394 : AT(0x000A3F94) { build/asm/data/main_800A3394.bin.o(.data); }
    .main_800AB1A0 0x800AB1A0 : AT(0x000ABDA0) { FILL(0x00000000); build/asm/main_800AB1A0.s.o(.text); build/asm/main_800AB1A0.s.o(.rodata); build/asm/main_800AB1A0.s.o(.data); }
    .main_800AB1A0_bss (NOLOAD) : { build/asm/main_800AB1A0.s.o(.bss); }
    .main_800AB1D0 0x800AB1D0 : AT(0x000ABDD0) { build/asm/data/main_800AB1D0.bin.o(.data); }
    .main_800B60D4 0x800B60D4 : AT(0x000B6CD4) { FILL(0x00000000); build/asm/main_800B60D4.s.o(.text); build/asm/main_800B60D4.s.o(.rodata); build/asm/main_800B60D4.s.o(.data); }
    .main_800B60D4_bss (NOLOAD) : { build/asm/main_800B60D4.s.o(.bss); }
    .main_800B610C 0x800B610C : AT(0x000B6D0C) { build/asm/data/main_800B610C.bin.o(.data); }
    .main_800C4018 0x800C4018 : AT(0x000C4C18) { build/asm/data/main_800C4018.bin.o(.data); }
    .main_800C5A10 0x800C5A10 : AT(0x000C6610) { build/asm/data/main_800C5A10.bin.o(.data); }
    .main_800CAAC0 0x800CAAC0 : AT(0x000CB6C0) { build/asm/data/main_800CAAC0.bin.o(.data); }
    .main_800CC0F8 0x800CC0F8 : AT(0x000CCCF8) { build/asm/data/main_800CC0F8.bin.o(.data); }
    .main_800CCA1C 0x800CCA1C : AT(0x000CD61C) { build/asm/data/main_800CCA1C.bin.o(.data); }
    .main_800CDDE0 0x800CDDE0 : AT(0x000CE9E0) { FILL(0x00000000); build/asm/main_800CDDE0.s.o(.text); build/asm/main_800CDDE0.s.o(.rodata); build/asm/main_800CDDE0.s.o(.data); }
    .main_800CDDE0_bss (NOLOAD) : { build/asm/main_800CDDE0.s.o(.bss); }
    .main_800CDE08 0x800CDE08 : AT(0x000CEA08) { build/asm/data/main_800CDE08.bin.o(.data); }
    .main_800D731C 0x800D731C : AT(0x000D7F1C) { build/asm/data/main_800D731C.bin.o(.data); }
    .main_800D8024 0x800D8024 : AT(0x000D8C24) { build/asm/data/main_800D8024.bin.o(.data); }
    .main_800D8C34 0x800D8C34 : AT(0x000D9834) { build/asm/data/main_800D8C34.bin.o(.data); }
    .main_800DAA98 0x800DAA98 : AT(0x000DB698) { build/asm/data/main_800DAA98.bin.o(.data); }
    .main_800DAEC4 0x800DAEC4 : AT(0x000DBAC4) { build/asm/data/main_800DAEC4.bin.o(.data); }
    .main_800DBC30 0x800DBC30 : AT(0x000DC830) { build/asm/data/main_800DBC30.bin.o(.data); }
    .main_800DCC68 0x800DCC68 : AT(0x000DD868) { build/asm/data/main_800DCC68.bin.o(.data); }
    .main_800DD944 0x800DD944 : AT(0x000DE544) { build/asm/data/main_800DD944.bin.o(.data); }
    .main_800DDA74 0x800DDA74 : AT(0x000DE674) { build/asm/data/main_800DDA74.bin.o(.data); }
    .main_800DE300 0x800DE300 : AT(0x000DEF00) { build/asm/data/main_800DE300.bin.o(.data); }
    .main_800DED58 0x800DED58 : AT(0x000DF958) { build/asm/data/main_800DED58.bin.o(.data); }
    .main_800F67BC 0x800F67BC : AT(0x000F73BC) { FILL(0x00000000); build/asm/main_800F67BC.s.o(.text); build/asm/main_800F67BC.s.o(.rodata); build/asm/main_800F67BC.s.o(.data); }
    .main_800F67BC_bss (NOLOAD) : { build/asm/main_800F67BC.s.o(.bss); }
    .main_800F6800 0x800F6800 : AT(0x000F7400) { build/asm/data/main_800F6800.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
