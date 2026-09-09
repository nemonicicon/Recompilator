SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004AC 0x800004AC : AT(0x000010AC) { FILL(0x00000000); build/asm/main_800004AC.s.o(.text); build/asm/main_800004AC.s.o(.rodata); build/asm/main_800004AC.s.o(.data); }
    .main_800004AC_bss (NOLOAD) : { build/asm/main_800004AC.s.o(.bss); }
    .main_80000B6C 0x80000B6C : AT(0x0000176C) { FILL(0x00000000); build/asm/main_80000B6C.s.o(.text); build/asm/main_80000B6C.s.o(.rodata); build/asm/main_80000B6C.s.o(.data); }
    .main_80000B6C_bss (NOLOAD) : { build/asm/main_80000B6C.s.o(.bss); }
    .main_80001794 0x80001794 : AT(0x00002394) { FILL(0x00000000); build/asm/main_80001794.s.o(.text); build/asm/main_80001794.s.o(.rodata); build/asm/main_80001794.s.o(.data); }
    .main_80001794_bss (NOLOAD) : { build/asm/main_80001794.s.o(.bss); }
    .main_80002230 0x80002230 : AT(0x00002E30) { FILL(0x00000000); build/asm/main_80002230.s.o(.text); build/asm/main_80002230.s.o(.rodata); build/asm/main_80002230.s.o(.data); }
    .main_80002230_bss (NOLOAD) : { build/asm/main_80002230.s.o(.bss); }
    .main_80003E68 0x80003E68 : AT(0x00004A68) { FILL(0x00000000); build/asm/main_80003E68.s.o(.text); build/asm/main_80003E68.s.o(.rodata); build/asm/main_80003E68.s.o(.data); }
    .main_80003E68_bss (NOLOAD) : { build/asm/main_80003E68.s.o(.bss); }
    .main_80004390 0x80004390 : AT(0x00004F90) { FILL(0x00000000); build/asm/main_80004390.s.o(.text); build/asm/main_80004390.s.o(.rodata); build/asm/main_80004390.s.o(.data); }
    .main_80004390_bss (NOLOAD) : { build/asm/main_80004390.s.o(.bss); }
    .main_80004DF4 0x80004DF4 : AT(0x000059F4) { FILL(0x00000000); build/asm/main_80004DF4.s.o(.text); build/asm/main_80004DF4.s.o(.rodata); build/asm/main_80004DF4.s.o(.data); }
    .main_80004DF4_bss (NOLOAD) : { build/asm/main_80004DF4.s.o(.bss); }
    .main_80004F78 0x80004F78 : AT(0x00005B78) { FILL(0x00000000); build/asm/main_80004F78.s.o(.text); build/asm/main_80004F78.s.o(.rodata); build/asm/main_80004F78.s.o(.data); }
    .main_80004F78_bss (NOLOAD) : { build/asm/main_80004F78.s.o(.bss); }
    .main_80005410 0x80005410 : AT(0x00006010) { FILL(0x00000000); build/asm/main_80005410.s.o(.text); build/asm/main_80005410.s.o(.rodata); build/asm/main_80005410.s.o(.data); }
    .main_80005410_bss (NOLOAD) : { build/asm/main_80005410.s.o(.bss); }
    .main_80005740 0x80005740 : AT(0x00006340) { FILL(0x00000000); build/asm/main_80005740.s.o(.text); build/asm/main_80005740.s.o(.rodata); build/asm/main_80005740.s.o(.data); }
    .main_80005740_bss (NOLOAD) : { build/asm/main_80005740.s.o(.bss); }
    .main_800058D0 0x800058D0 : AT(0x000064D0) { FILL(0x00000000); build/asm/main_800058D0.s.o(.text); build/asm/main_800058D0.s.o(.rodata); build/asm/main_800058D0.s.o(.data); }
    .main_800058D0_bss (NOLOAD) : { build/asm/main_800058D0.s.o(.bss); }
    .main_80005ABC 0x80005ABC : AT(0x000066BC) { FILL(0x00000000); build/asm/main_80005ABC.s.o(.text); build/asm/main_80005ABC.s.o(.rodata); build/asm/main_80005ABC.s.o(.data); }
    .main_80005ABC_bss (NOLOAD) : { build/asm/main_80005ABC.s.o(.bss); }
    .main_80005CB0 0x80005CB0 : AT(0x000068B0) { FILL(0x00000000); build/asm/main_80005CB0.s.o(.text); build/asm/main_80005CB0.s.o(.rodata); build/asm/main_80005CB0.s.o(.data); }
    .main_80005CB0_bss (NOLOAD) : { build/asm/main_80005CB0.s.o(.bss); }
    .main_800061E0 0x800061E0 : AT(0x00006DE0) { FILL(0x00000000); build/asm/main_800061E0.s.o(.text); build/asm/main_800061E0.s.o(.rodata); build/asm/main_800061E0.s.o(.data); }
    .main_800061E0_bss (NOLOAD) : { build/asm/main_800061E0.s.o(.bss); }
    .main_800066C4 0x800066C4 : AT(0x000072C4) { FILL(0x00000000); build/asm/main_800066C4.s.o(.text); build/asm/main_800066C4.s.o(.rodata); build/asm/main_800066C4.s.o(.data); }
    .main_800066C4_bss (NOLOAD) : { build/asm/main_800066C4.s.o(.bss); }
    .main_80006854 0x80006854 : AT(0x00007454) { FILL(0x00000000); build/asm/main_80006854.s.o(.text); build/asm/main_80006854.s.o(.rodata); build/asm/main_80006854.s.o(.data); }
    .main_80006854_bss (NOLOAD) : { build/asm/main_80006854.s.o(.bss); }
    .main_800069B0 0x800069B0 : AT(0x000075B0) { FILL(0x00000000); build/asm/main_800069B0.s.o(.text); build/asm/main_800069B0.s.o(.rodata); build/asm/main_800069B0.s.o(.data); }
    .main_800069B0_bss (NOLOAD) : { build/asm/main_800069B0.s.o(.bss); }
    .main_80006A84 0x80006A84 : AT(0x00007684) { FILL(0x00000000); build/asm/main_80006A84.s.o(.text); build/asm/main_80006A84.s.o(.rodata); build/asm/main_80006A84.s.o(.data); }
    .main_80006A84_bss (NOLOAD) : { build/asm/main_80006A84.s.o(.bss); }
    .main_80006DC4 0x80006DC4 : AT(0x000079C4) { FILL(0x00000000); build/asm/main_80006DC4.s.o(.text); build/asm/main_80006DC4.s.o(.rodata); build/asm/main_80006DC4.s.o(.data); }
    .main_80006DC4_bss (NOLOAD) : { build/asm/main_80006DC4.s.o(.bss); }
    .main_80006FB4 0x80006FB4 : AT(0x00007BB4) { FILL(0x00000000); build/asm/main_80006FB4.s.o(.text); build/asm/main_80006FB4.s.o(.rodata); build/asm/main_80006FB4.s.o(.data); }
    .main_80006FB4_bss (NOLOAD) : { build/asm/main_80006FB4.s.o(.bss); }
    .main_80007C48 0x80007C48 : AT(0x00008848) { FILL(0x00000000); build/asm/main_80007C48.s.o(.text); build/asm/main_80007C48.s.o(.rodata); build/asm/main_80007C48.s.o(.data); }
    .main_80007C48_bss (NOLOAD) : { build/asm/main_80007C48.s.o(.bss); }
    .main_80007F0C 0x80007F0C : AT(0x00008B0C) { FILL(0x00000000); build/asm/main_80007F0C.s.o(.text); build/asm/main_80007F0C.s.o(.rodata); build/asm/main_80007F0C.s.o(.data); }
    .main_80007F0C_bss (NOLOAD) : { build/asm/main_80007F0C.s.o(.bss); }
    .main_80008408 0x80008408 : AT(0x00009008) { FILL(0x00000000); build/asm/main_80008408.s.o(.text); build/asm/main_80008408.s.o(.rodata); build/asm/main_80008408.s.o(.data); }
    .main_80008408_bss (NOLOAD) : { build/asm/main_80008408.s.o(.bss); }
    .main_80008A30 0x80008A30 : AT(0x00009630) { FILL(0x00000000); build/asm/main_80008A30.s.o(.text); build/asm/main_80008A30.s.o(.rodata); build/asm/main_80008A30.s.o(.data); }
    .main_80008A30_bss (NOLOAD) : { build/asm/main_80008A30.s.o(.bss); }
    .main_80009A8C 0x80009A8C : AT(0x0000A68C) { FILL(0x00000000); build/asm/main_80009A8C.s.o(.text); build/asm/main_80009A8C.s.o(.rodata); build/asm/main_80009A8C.s.o(.data); }
    .main_80009A8C_bss (NOLOAD) : { build/asm/main_80009A8C.s.o(.bss); }
    .main_80009BB4 0x80009BB4 : AT(0x0000A7B4) { FILL(0x00000000); build/asm/main_80009BB4.s.o(.text); build/asm/main_80009BB4.s.o(.rodata); build/asm/main_80009BB4.s.o(.data); }
    .main_80009BB4_bss (NOLOAD) : { build/asm/main_80009BB4.s.o(.bss); }
    .main_8000A134 0x8000A134 : AT(0x0000AD34) { FILL(0x00000000); build/asm/main_8000A134.s.o(.text); build/asm/main_8000A134.s.o(.rodata); build/asm/main_8000A134.s.o(.data); }
    .main_8000A134_bss (NOLOAD) : { build/asm/main_8000A134.s.o(.bss); }
    .main_8000A3E8 0x8000A3E8 : AT(0x0000AFE8) { FILL(0x00000000); build/asm/main_8000A3E8.s.o(.text); build/asm/main_8000A3E8.s.o(.rodata); build/asm/main_8000A3E8.s.o(.data); }
    .main_8000A3E8_bss (NOLOAD) : { build/asm/main_8000A3E8.s.o(.bss); }
    .main_8000B594 0x8000B594 : AT(0x0000C194) { FILL(0x00000000); build/asm/main_8000B594.s.o(.text); build/asm/main_8000B594.s.o(.rodata); build/asm/main_8000B594.s.o(.data); }
    .main_8000B594_bss (NOLOAD) : { build/asm/main_8000B594.s.o(.bss); }
    .main_8000C628 0x8000C628 : AT(0x0000D228) { FILL(0x00000000); build/asm/main_8000C628.s.o(.text); build/asm/main_8000C628.s.o(.rodata); build/asm/main_8000C628.s.o(.data); }
    .main_8000C628_bss (NOLOAD) : { build/asm/main_8000C628.s.o(.bss); }
    .main_8000D080 0x8000D080 : AT(0x0000DC80) { FILL(0x00000000); build/asm/main_8000D080.s.o(.text); build/asm/main_8000D080.s.o(.rodata); build/asm/main_8000D080.s.o(.data); }
    .main_8000D080_bss (NOLOAD) : { build/asm/main_8000D080.s.o(.bss); }
    .main_8000E000 0x8000E000 : AT(0x0000EC00) { FILL(0x00000000); build/asm/main_8000E000.s.o(.text); build/asm/main_8000E000.s.o(.rodata); build/asm/main_8000E000.s.o(.data); }
    .main_8000E000_bss (NOLOAD) : { build/asm/main_8000E000.s.o(.bss); }
    .main_80012E04 0x80012E04 : AT(0x00013A04) { FILL(0x00000000); build/asm/main_80012E04.s.o(.text); build/asm/main_80012E04.s.o(.rodata); build/asm/main_80012E04.s.o(.data); }
    .main_80012E04_bss (NOLOAD) : { build/asm/main_80012E04.s.o(.bss); }
    .main_800145D8 0x800145D8 : AT(0x000151D8) { FILL(0x00000000); build/asm/main_800145D8.s.o(.text); build/asm/main_800145D8.s.o(.rodata); build/asm/main_800145D8.s.o(.data); }
    .main_800145D8_bss (NOLOAD) : { build/asm/main_800145D8.s.o(.bss); }
    .main_80015D90 0x80015D90 : AT(0x00016990) { FILL(0x00000000); build/asm/main_80015D90.s.o(.text); build/asm/main_80015D90.s.o(.rodata); build/asm/main_80015D90.s.o(.data); }
    .main_80015D90_bss (NOLOAD) : { build/asm/main_80015D90.s.o(.bss); }
    .main_80016B10 0x80016B10 : AT(0x00017710) { FILL(0x00000000); build/asm/main_80016B10.s.o(.text); build/asm/main_80016B10.s.o(.rodata); build/asm/main_80016B10.s.o(.data); }
    .main_80016B10_bss (NOLOAD) : { build/asm/main_80016B10.s.o(.bss); }
    .main_80017F68 0x80017F68 : AT(0x00018B68) { FILL(0x00000000); build/asm/main_80017F68.s.o(.text); build/asm/main_80017F68.s.o(.rodata); build/asm/main_80017F68.s.o(.data); }
    .main_80017F68_bss (NOLOAD) : { build/asm/main_80017F68.s.o(.bss); }
    .main_80024234 0x80024234 : AT(0x00024E34) { FILL(0x00000000); build/asm/main_80024234.s.o(.text); build/asm/main_80024234.s.o(.rodata); build/asm/main_80024234.s.o(.data); }
    .main_80024234_bss (NOLOAD) : { build/asm/main_80024234.s.o(.bss); }
    .main_80025370 0x80025370 : AT(0x00025F70) { FILL(0x00000000); build/asm/main_80025370.s.o(.text); build/asm/main_80025370.s.o(.rodata); build/asm/main_80025370.s.o(.data); }
    .main_80025370_bss (NOLOAD) : { build/asm/main_80025370.s.o(.bss); }
    .main_80025ED4 0x80025ED4 : AT(0x00026AD4) { FILL(0x00000000); build/asm/main_80025ED4.s.o(.text); build/asm/main_80025ED4.s.o(.rodata); build/asm/main_80025ED4.s.o(.data); }
    .main_80025ED4_bss (NOLOAD) : { build/asm/main_80025ED4.s.o(.bss); }
    .main_80028C68 0x80028C68 : AT(0x00029868) { FILL(0x00000000); build/asm/main_80028C68.s.o(.text); build/asm/main_80028C68.s.o(.rodata); build/asm/main_80028C68.s.o(.data); }
    .main_80028C68_bss (NOLOAD) : { build/asm/main_80028C68.s.o(.bss); }
    .main_8002B05C 0x8002B05C : AT(0x0002BC5C) { FILL(0x00000000); build/asm/main_8002B05C.s.o(.text); build/asm/main_8002B05C.s.o(.rodata); build/asm/main_8002B05C.s.o(.data); }
    .main_8002B05C_bss (NOLOAD) : { build/asm/main_8002B05C.s.o(.bss); }
    .main_8002B640 0x8002B640 : AT(0x0002C240) { FILL(0x00000000); build/asm/main_8002B640.s.o(.text); build/asm/main_8002B640.s.o(.rodata); build/asm/main_8002B640.s.o(.data); }
    .main_8002B640_bss (NOLOAD) : { build/asm/main_8002B640.s.o(.bss); }
    .main_8002E978 0x8002E978 : AT(0x0002F578) { FILL(0x00000000); build/asm/main_8002E978.s.o(.text); build/asm/main_8002E978.s.o(.rodata); build/asm/main_8002E978.s.o(.data); }
    .main_8002E978_bss (NOLOAD) : { build/asm/main_8002E978.s.o(.bss); }
    .main_8002FB08 0x8002FB08 : AT(0x00030708) { FILL(0x00000000); build/asm/main_8002FB08.s.o(.text); build/asm/main_8002FB08.s.o(.rodata); build/asm/main_8002FB08.s.o(.data); }
    .main_8002FB08_bss (NOLOAD) : { build/asm/main_8002FB08.s.o(.bss); }
    .main_8003354C 0x8003354C : AT(0x0003414C) { FILL(0x00000000); build/asm/main_8003354C.s.o(.text); build/asm/main_8003354C.s.o(.rodata); build/asm/main_8003354C.s.o(.data); }
    .main_8003354C_bss (NOLOAD) : { build/asm/main_8003354C.s.o(.bss); }
    .main_800366B4 0x800366B4 : AT(0x000372B4) { FILL(0x00000000); build/asm/main_800366B4.s.o(.text); build/asm/main_800366B4.s.o(.rodata); build/asm/main_800366B4.s.o(.data); }
    .main_800366B4_bss (NOLOAD) : { build/asm/main_800366B4.s.o(.bss); }
    .main_80037848 0x80037848 : AT(0x00038448) { FILL(0x00000000); build/asm/main_80037848.s.o(.text); build/asm/main_80037848.s.o(.rodata); build/asm/main_80037848.s.o(.data); }
    .main_80037848_bss (NOLOAD) : { build/asm/main_80037848.s.o(.bss); }
    .main_80037CD0 0x80037CD0 : AT(0x000388D0) { FILL(0x00000000); build/asm/main_80037CD0.s.o(.text); build/asm/main_80037CD0.s.o(.rodata); build/asm/main_80037CD0.s.o(.data); }
    .main_80037CD0_bss (NOLOAD) : { build/asm/main_80037CD0.s.o(.bss); }
    .main_8003823C 0x8003823C : AT(0x00038E3C) { FILL(0x00000000); build/asm/main_8003823C.s.o(.text); build/asm/main_8003823C.s.o(.rodata); build/asm/main_8003823C.s.o(.data); }
    .main_8003823C_bss (NOLOAD) : { build/asm/main_8003823C.s.o(.bss); }
    .main_80038770 0x80038770 : AT(0x00039370) { FILL(0x00000000); build/asm/main_80038770.s.o(.text); build/asm/main_80038770.s.o(.rodata); build/asm/main_80038770.s.o(.data); }
    .main_80038770_bss (NOLOAD) : { build/asm/main_80038770.s.o(.bss); }
    .main_8003A300 0x8003A300 : AT(0x0003AF00) { FILL(0x00000000); build/asm/main_8003A300.s.o(.text); build/asm/main_8003A300.s.o(.rodata); build/asm/main_8003A300.s.o(.data); }
    .main_8003A300_bss (NOLOAD) : { build/asm/main_8003A300.s.o(.bss); }
    .main_8003AE20 0x8003AE20 : AT(0x0003BA20) { FILL(0x00000000); build/asm/main_8003AE20.s.o(.text); build/asm/main_8003AE20.s.o(.rodata); build/asm/main_8003AE20.s.o(.data); }
    .main_8003AE20_bss (NOLOAD) : { build/asm/main_8003AE20.s.o(.bss); }
    .main_8003BA64 0x8003BA64 : AT(0x0003C664) { FILL(0x00000000); build/asm/main_8003BA64.s.o(.text); build/asm/main_8003BA64.s.o(.rodata); build/asm/main_8003BA64.s.o(.data); }
    .main_8003BA64_bss (NOLOAD) : { build/asm/main_8003BA64.s.o(.bss); }
    .main_8003BF4C 0x8003BF4C : AT(0x0003CB4C) { FILL(0x00000000); build/asm/main_8003BF4C.s.o(.text); build/asm/main_8003BF4C.s.o(.rodata); build/asm/main_8003BF4C.s.o(.data); }
    .main_8003BF4C_bss (NOLOAD) : { build/asm/main_8003BF4C.s.o(.bss); }
    .main_8003C1D0 0x8003C1D0 : AT(0x0003CDD0) { FILL(0x00000000); build/asm/main_8003C1D0.s.o(.text); build/asm/main_8003C1D0.s.o(.rodata); build/asm/main_8003C1D0.s.o(.data); }
    .main_8003C1D0_bss (NOLOAD) : { build/asm/main_8003C1D0.s.o(.bss); }
    .main_8003CFF4 0x8003CFF4 : AT(0x0003DBF4) { FILL(0x00000000); build/asm/main_8003CFF4.s.o(.text); build/asm/main_8003CFF4.s.o(.rodata); build/asm/main_8003CFF4.s.o(.data); }
    .main_8003CFF4_bss (NOLOAD) : { build/asm/main_8003CFF4.s.o(.bss); }
    .main_8003D3D4 0x8003D3D4 : AT(0x0003DFD4) { FILL(0x00000000); build/asm/main_8003D3D4.s.o(.text); build/asm/main_8003D3D4.s.o(.rodata); build/asm/main_8003D3D4.s.o(.data); }
    .main_8003D3D4_bss (NOLOAD) : { build/asm/main_8003D3D4.s.o(.bss); }
    .main_8003DE58 0x8003DE58 : AT(0x0003EA58) { FILL(0x00000000); build/asm/main_8003DE58.s.o(.text); build/asm/main_8003DE58.s.o(.rodata); build/asm/main_8003DE58.s.o(.data); }
    .main_8003DE58_bss (NOLOAD) : { build/asm/main_8003DE58.s.o(.bss); }
    .main_8003E2B4 0x8003E2B4 : AT(0x0003EEB4) { FILL(0x00000000); build/asm/main_8003E2B4.s.o(.text); build/asm/main_8003E2B4.s.o(.rodata); build/asm/main_8003E2B4.s.o(.data); }
    .main_8003E2B4_bss (NOLOAD) : { build/asm/main_8003E2B4.s.o(.bss); }
    .main_8003E448 0x8003E448 : AT(0x0003F048) { FILL(0x00000000); build/asm/main_8003E448.s.o(.text); build/asm/main_8003E448.s.o(.rodata); build/asm/main_8003E448.s.o(.data); }
    .main_8003E448_bss (NOLOAD) : { build/asm/main_8003E448.s.o(.bss); }
    .main_8003F820 0x8003F820 : AT(0x00040420) { FILL(0x00000000); build/asm/main_8003F820.s.o(.text); build/asm/main_8003F820.s.o(.rodata); build/asm/main_8003F820.s.o(.data); }
    .main_8003F820_bss (NOLOAD) : { build/asm/main_8003F820.s.o(.bss); }
    .main_8003FFC4 0x8003FFC4 : AT(0x00040BC4) { FILL(0x00000000); build/asm/main_8003FFC4.s.o(.text); build/asm/main_8003FFC4.s.o(.rodata); build/asm/main_8003FFC4.s.o(.data); }
    .main_8003FFC4_bss (NOLOAD) : { build/asm/main_8003FFC4.s.o(.bss); }
    .main_80040380 0x80040380 : AT(0x00040F80) { FILL(0x00000000); build/asm/main_80040380.s.o(.text); build/asm/main_80040380.s.o(.rodata); build/asm/main_80040380.s.o(.data); }
    .main_80040380_bss (NOLOAD) : { build/asm/main_80040380.s.o(.bss); }
    .main_800405CC 0x800405CC : AT(0x000411CC) { FILL(0x00000000); build/asm/main_800405CC.s.o(.text); build/asm/main_800405CC.s.o(.rodata); build/asm/main_800405CC.s.o(.data); }
    .main_800405CC_bss (NOLOAD) : { build/asm/main_800405CC.s.o(.bss); }
    .main_80041328 0x80041328 : AT(0x00041F28) { FILL(0x00000000); build/asm/main_80041328.s.o(.text); build/asm/main_80041328.s.o(.rodata); build/asm/main_80041328.s.o(.data); }
    .main_80041328_bss (NOLOAD) : { build/asm/main_80041328.s.o(.bss); }
    .main_80041918 0x80041918 : AT(0x00042518) { FILL(0x00000000); build/asm/main_80041918.s.o(.text); build/asm/main_80041918.s.o(.rodata); build/asm/main_80041918.s.o(.data); }
    .main_80041918_bss (NOLOAD) : { build/asm/main_80041918.s.o(.bss); }
    .main_80042590 0x80042590 : AT(0x00043190) { FILL(0x00000000); build/asm/main_80042590.s.o(.text); build/asm/main_80042590.s.o(.rodata); build/asm/main_80042590.s.o(.data); }
    .main_80042590_bss (NOLOAD) : { build/asm/main_80042590.s.o(.bss); }
    .main_80042FD4 0x80042FD4 : AT(0x00043BD4) { FILL(0x00000000); build/asm/main_80042FD4.s.o(.text); build/asm/main_80042FD4.s.o(.rodata); build/asm/main_80042FD4.s.o(.data); }
    .main_80042FD4_bss (NOLOAD) : { build/asm/main_80042FD4.s.o(.bss); }
    .main_80043514 0x80043514 : AT(0x00044114) { FILL(0x00000000); build/asm/main_80043514.s.o(.text); build/asm/main_80043514.s.o(.rodata); build/asm/main_80043514.s.o(.data); }
    .main_80043514_bss (NOLOAD) : { build/asm/main_80043514.s.o(.bss); }
    .main_80044964 0x80044964 : AT(0x00045564) { FILL(0x00000000); build/asm/main_80044964.s.o(.text); build/asm/main_80044964.s.o(.rodata); build/asm/main_80044964.s.o(.data); }
    .main_80044964_bss (NOLOAD) : { build/asm/main_80044964.s.o(.bss); }
    .main_80044B34 0x80044B34 : AT(0x00045734) { FILL(0x00000000); build/asm/main_80044B34.s.o(.text); build/asm/main_80044B34.s.o(.rodata); build/asm/main_80044B34.s.o(.data); }
    .main_80044B34_bss (NOLOAD) : { build/asm/main_80044B34.s.o(.bss); }
    .main_80044CB4 0x80044CB4 : AT(0x000458B4) { FILL(0x00000000); build/asm/main_80044CB4.s.o(.text); build/asm/main_80044CB4.s.o(.rodata); build/asm/main_80044CB4.s.o(.data); }
    .main_80044CB4_bss (NOLOAD) : { build/asm/main_80044CB4.s.o(.bss); }
    .main_80045048 0x80045048 : AT(0x00045C48) { FILL(0x00000000); build/asm/main_80045048.s.o(.text); build/asm/main_80045048.s.o(.rodata); build/asm/main_80045048.s.o(.data); }
    .main_80045048_bss (NOLOAD) : { build/asm/main_80045048.s.o(.bss); }
    .main_800453C8 0x800453C8 : AT(0x00045FC8) { FILL(0x00000000); build/asm/main_800453C8.s.o(.text); build/asm/main_800453C8.s.o(.rodata); build/asm/main_800453C8.s.o(.data); }
    .main_800453C8_bss (NOLOAD) : { build/asm/main_800453C8.s.o(.bss); }
    .main_80045A0C 0x80045A0C : AT(0x0004660C) { FILL(0x00000000); build/asm/main_80045A0C.s.o(.text); build/asm/main_80045A0C.s.o(.rodata); build/asm/main_80045A0C.s.o(.data); }
    .main_80045A0C_bss (NOLOAD) : { build/asm/main_80045A0C.s.o(.bss); }
    .main_80045E88 0x80045E88 : AT(0x00046A88) { FILL(0x00000000); build/asm/main_80045E88.s.o(.text); build/asm/main_80045E88.s.o(.rodata); build/asm/main_80045E88.s.o(.data); }
    .main_80045E88_bss (NOLOAD) : { build/asm/main_80045E88.s.o(.bss); }
    .main_80046318 0x80046318 : AT(0x00046F18) { FILL(0x00000000); build/asm/main_80046318.s.o(.text); build/asm/main_80046318.s.o(.rodata); build/asm/main_80046318.s.o(.data); }
    .main_80046318_bss (NOLOAD) : { build/asm/main_80046318.s.o(.bss); }
    .main_800469B0 0x800469B0 : AT(0x000475B0) { FILL(0x00000000); build/asm/main_800469B0.s.o(.text); build/asm/main_800469B0.s.o(.rodata); build/asm/main_800469B0.s.o(.data); }
    .main_800469B0_bss (NOLOAD) : { build/asm/main_800469B0.s.o(.bss); }
    .main_80047410 0x80047410 : AT(0x00048010) { FILL(0x00000000); build/asm/main_80047410.s.o(.text); build/asm/main_80047410.s.o(.rodata); build/asm/main_80047410.s.o(.data); }
    .main_80047410_bss (NOLOAD) : { build/asm/main_80047410.s.o(.bss); }
    .main_8004796C 0x8004796C : AT(0x0004856C) { FILL(0x00000000); build/asm/main_8004796C.s.o(.text); build/asm/main_8004796C.s.o(.rodata); build/asm/main_8004796C.s.o(.data); }
    .main_8004796C_bss (NOLOAD) : { build/asm/main_8004796C.s.o(.bss); }
    .main_80047BC8 0x80047BC8 : AT(0x000487C8) { FILL(0x00000000); build/asm/main_80047BC8.s.o(.text); build/asm/main_80047BC8.s.o(.rodata); build/asm/main_80047BC8.s.o(.data); }
    .main_80047BC8_bss (NOLOAD) : { build/asm/main_80047BC8.s.o(.bss); }
    .main_80047E10 0x80047E10 : AT(0x00048A10) { FILL(0x00000000); build/asm/main_80047E10.s.o(.text); build/asm/main_80047E10.s.o(.rodata); build/asm/main_80047E10.s.o(.data); }
    .main_80047E10_bss (NOLOAD) : { build/asm/main_80047E10.s.o(.bss); }
    .main_8004851C 0x8004851C : AT(0x0004911C) { FILL(0x00000000); build/asm/main_8004851C.s.o(.text); build/asm/main_8004851C.s.o(.rodata); build/asm/main_8004851C.s.o(.data); }
    .main_8004851C_bss (NOLOAD) : { build/asm/main_8004851C.s.o(.bss); }
    .main_80048A5C 0x80048A5C : AT(0x0004965C) { FILL(0x00000000); build/asm/main_80048A5C.s.o(.text); build/asm/main_80048A5C.s.o(.rodata); build/asm/main_80048A5C.s.o(.data); }
    .main_80048A5C_bss (NOLOAD) : { build/asm/main_80048A5C.s.o(.bss); }
    .main_800490CC 0x800490CC : AT(0x00049CCC) { FILL(0x00000000); build/asm/main_800490CC.s.o(.text); build/asm/main_800490CC.s.o(.rodata); build/asm/main_800490CC.s.o(.data); }
    .main_800490CC_bss (NOLOAD) : { build/asm/main_800490CC.s.o(.bss); }
    .main_800498A8 0x800498A8 : AT(0x0004A4A8) { FILL(0x00000000); build/asm/main_800498A8.s.o(.text); build/asm/main_800498A8.s.o(.rodata); build/asm/main_800498A8.s.o(.data); }
    .main_800498A8_bss (NOLOAD) : { build/asm/main_800498A8.s.o(.bss); }
    .main_8004A0E0 0x8004A0E0 : AT(0x0004ACE0) { FILL(0x00000000); build/asm/main_8004A0E0.s.o(.text); build/asm/main_8004A0E0.s.o(.rodata); build/asm/main_8004A0E0.s.o(.data); }
    .main_8004A0E0_bss (NOLOAD) : { build/asm/main_8004A0E0.s.o(.bss); }
    .main_8004B524 0x8004B524 : AT(0x0004C124) { FILL(0x00000000); build/asm/main_8004B524.s.o(.text); build/asm/main_8004B524.s.o(.rodata); build/asm/main_8004B524.s.o(.data); }
    .main_8004B524_bss (NOLOAD) : { build/asm/main_8004B524.s.o(.bss); }
    .main_8004C9F0 0x8004C9F0 : AT(0x0004D5F0) { FILL(0x00000000); build/asm/main_8004C9F0.s.o(.text); build/asm/main_8004C9F0.s.o(.rodata); build/asm/main_8004C9F0.s.o(.data); }
    .main_8004C9F0_bss (NOLOAD) : { build/asm/main_8004C9F0.s.o(.bss); }
    .main_8004CBC4 0x8004CBC4 : AT(0x0004D7C4) { FILL(0x00000000); build/asm/main_8004CBC4.s.o(.text); build/asm/main_8004CBC4.s.o(.rodata); build/asm/main_8004CBC4.s.o(.data); }
    .main_8004CBC4_bss (NOLOAD) : { build/asm/main_8004CBC4.s.o(.bss); }
    .main_8004DFF0 0x8004DFF0 : AT(0x0004EBF0) { FILL(0x00000000); build/asm/main_8004DFF0.s.o(.text); build/asm/main_8004DFF0.s.o(.rodata); build/asm/main_8004DFF0.s.o(.data); }
    .main_8004DFF0_bss (NOLOAD) : { build/asm/main_8004DFF0.s.o(.bss); }
    .main_8004E904 0x8004E904 : AT(0x0004F504) { FILL(0x00000000); build/asm/main_8004E904.s.o(.text); build/asm/main_8004E904.s.o(.rodata); build/asm/main_8004E904.s.o(.data); }
    .main_8004E904_bss (NOLOAD) : { build/asm/main_8004E904.s.o(.bss); }
    .main_800504C4 0x800504C4 : AT(0x000510C4) { FILL(0x00000000); build/asm/main_800504C4.s.o(.text); build/asm/main_800504C4.s.o(.rodata); build/asm/main_800504C4.s.o(.data); }
    .main_800504C4_bss (NOLOAD) : { build/asm/main_800504C4.s.o(.bss); }
    .main_8005163C 0x8005163C : AT(0x0005223C) { FILL(0x00000000); build/asm/main_8005163C.s.o(.text); build/asm/main_8005163C.s.o(.rodata); build/asm/main_8005163C.s.o(.data); }
    .main_8005163C_bss (NOLOAD) : { build/asm/main_8005163C.s.o(.bss); }
    .main_80051EB0 0x80051EB0 : AT(0x00052AB0) { FILL(0x00000000); build/asm/main_80051EB0.s.o(.text); build/asm/main_80051EB0.s.o(.rodata); build/asm/main_80051EB0.s.o(.data); }
    .main_80051EB0_bss (NOLOAD) : { build/asm/main_80051EB0.s.o(.bss); }
    .main_80052700 0x80052700 : AT(0x00053300) { FILL(0x00000000); build/asm/main_80052700.s.o(.text); build/asm/main_80052700.s.o(.rodata); build/asm/main_80052700.s.o(.data); }
    .main_80052700_bss (NOLOAD) : { build/asm/main_80052700.s.o(.bss); }
    .main_80052D78 0x80052D78 : AT(0x00053978) { FILL(0x00000000); build/asm/main_80052D78.s.o(.text); build/asm/main_80052D78.s.o(.rodata); build/asm/main_80052D78.s.o(.data); }
    .main_80052D78_bss (NOLOAD) : { build/asm/main_80052D78.s.o(.bss); }
    .main_80052FD8 0x80052FD8 : AT(0x00053BD8) { FILL(0x00000000); build/asm/main_80052FD8.s.o(.text); build/asm/main_80052FD8.s.o(.rodata); build/asm/main_80052FD8.s.o(.data); }
    .main_80052FD8_bss (NOLOAD) : { build/asm/main_80052FD8.s.o(.bss); }
    .main_800533C8 0x800533C8 : AT(0x00053FC8) { FILL(0x00000000); build/asm/main_800533C8.s.o(.text); build/asm/main_800533C8.s.o(.rodata); build/asm/main_800533C8.s.o(.data); }
    .main_800533C8_bss (NOLOAD) : { build/asm/main_800533C8.s.o(.bss); }
    .main_800556A4 0x800556A4 : AT(0x000562A4) { FILL(0x00000000); build/asm/main_800556A4.s.o(.text); build/asm/main_800556A4.s.o(.rodata); build/asm/main_800556A4.s.o(.data); }
    .main_800556A4_bss (NOLOAD) : { build/asm/main_800556A4.s.o(.bss); }
    .main_80055800 0x80055800 : AT(0x00056400) { FILL(0x00000000); build/asm/main_80055800.s.o(.text); build/asm/main_80055800.s.o(.rodata); build/asm/main_80055800.s.o(.data); }
    .main_80055800_bss (NOLOAD) : { build/asm/main_80055800.s.o(.bss); }
    .main_80055E54 0x80055E54 : AT(0x00056A54) { FILL(0x00000000); build/asm/main_80055E54.s.o(.text); build/asm/main_80055E54.s.o(.rodata); build/asm/main_80055E54.s.o(.data); }
    .main_80055E54_bss (NOLOAD) : { build/asm/main_80055E54.s.o(.bss); }
    .main_80056A8C 0x80056A8C : AT(0x0005768C) { FILL(0x00000000); build/asm/main_80056A8C.s.o(.text); build/asm/main_80056A8C.s.o(.rodata); build/asm/main_80056A8C.s.o(.data); }
    .main_80056A8C_bss (NOLOAD) : { build/asm/main_80056A8C.s.o(.bss); }
    .main_80059690 0x80059690 : AT(0x0005A290) { FILL(0x00000000); build/asm/main_80059690.s.o(.text); build/asm/main_80059690.s.o(.rodata); build/asm/main_80059690.s.o(.data); }
    .main_80059690_bss (NOLOAD) : { build/asm/main_80059690.s.o(.bss); }
    .main_80059BEC 0x80059BEC : AT(0x0005A7EC) { FILL(0x00000000); build/asm/main_80059BEC.s.o(.text); build/asm/main_80059BEC.s.o(.rodata); build/asm/main_80059BEC.s.o(.data); }
    .main_80059BEC_bss (NOLOAD) : { build/asm/main_80059BEC.s.o(.bss); }
    .main_8005A750 0x8005A750 : AT(0x0005B350) { FILL(0x00000000); build/asm/main_8005A750.s.o(.text); build/asm/main_8005A750.s.o(.rodata); build/asm/main_8005A750.s.o(.data); }
    .main_8005A750_bss (NOLOAD) : { build/asm/main_8005A750.s.o(.bss); }
    .main_8005BB30 0x8005BB30 : AT(0x0005C730) { FILL(0x00000000); build/asm/main_8005BB30.s.o(.text); build/asm/main_8005BB30.s.o(.rodata); build/asm/main_8005BB30.s.o(.data); }
    .main_8005BB30_bss (NOLOAD) : { build/asm/main_8005BB30.s.o(.bss); }
    .main_8005BC54 0x8005BC54 : AT(0x0005C854) { FILL(0x00000000); build/asm/main_8005BC54.s.o(.text); build/asm/main_8005BC54.s.o(.rodata); build/asm/main_8005BC54.s.o(.data); }
    .main_8005BC54_bss (NOLOAD) : { build/asm/main_8005BC54.s.o(.bss); }
    .main_8005EAD4 0x8005EAD4 : AT(0x0005F6D4) { FILL(0x00000000); build/asm/main_8005EAD4.s.o(.text); build/asm/main_8005EAD4.s.o(.rodata); build/asm/main_8005EAD4.s.o(.data); }
    .main_8005EAD4_bss (NOLOAD) : { build/asm/main_8005EAD4.s.o(.bss); }
    .main_8005EF5C 0x8005EF5C : AT(0x0005FB5C) { FILL(0x00000000); build/asm/main_8005EF5C.s.o(.text); build/asm/main_8005EF5C.s.o(.rodata); build/asm/main_8005EF5C.s.o(.data); }
    .main_8005EF5C_bss (NOLOAD) : { build/asm/main_8005EF5C.s.o(.bss); }
    .main_80061220 0x80061220 : AT(0x00061E20) { FILL(0x00000000); build/asm/main_80061220.s.o(.text); build/asm/main_80061220.s.o(.rodata); build/asm/main_80061220.s.o(.data); }
    .main_80061220_bss (NOLOAD) : { build/asm/main_80061220.s.o(.bss); }
    .main_80061FB0 0x80061FB0 : AT(0x00062BB0) { FILL(0x00000000); build/asm/main_80061FB0.s.o(.text); build/asm/main_80061FB0.s.o(.rodata); build/asm/main_80061FB0.s.o(.data); }
    .main_80061FB0_bss (NOLOAD) : { build/asm/main_80061FB0.s.o(.bss); }
    .main_800627B0 0x800627B0 : AT(0x000633B0) { FILL(0x00000000); build/asm/main_800627B0.s.o(.text); build/asm/main_800627B0.s.o(.rodata); build/asm/main_800627B0.s.o(.data); }
    .main_800627B0_bss (NOLOAD) : { build/asm/main_800627B0.s.o(.bss); }
    .main_80063748 0x80063748 : AT(0x00064348) { FILL(0x00000000); build/asm/main_80063748.s.o(.text); build/asm/main_80063748.s.o(.rodata); build/asm/main_80063748.s.o(.data); }
    .main_80063748_bss (NOLOAD) : { build/asm/main_80063748.s.o(.bss); }
    .main_80063DC0 0x80063DC0 : AT(0x000649C0) { FILL(0x00000000); build/asm/main_80063DC0.s.o(.text); build/asm/main_80063DC0.s.o(.rodata); build/asm/main_80063DC0.s.o(.data); }
    .main_80063DC0_bss (NOLOAD) : { build/asm/main_80063DC0.s.o(.bss); }
    .main_80064930 0x80064930 : AT(0x00065530) { FILL(0x00000000); build/asm/main_80064930.s.o(.text); build/asm/main_80064930.s.o(.rodata); build/asm/main_80064930.s.o(.data); }
    .main_80064930_bss (NOLOAD) : { build/asm/main_80064930.s.o(.bss); }
    .main_80065668 0x80065668 : AT(0x00066268) { FILL(0x00000000); build/asm/main_80065668.s.o(.text); build/asm/main_80065668.s.o(.rodata); build/asm/main_80065668.s.o(.data); }
    .main_80065668_bss (NOLOAD) : { build/asm/main_80065668.s.o(.bss); }
    .main_80065CE0 0x80065CE0 : AT(0x000668E0) { FILL(0x00000000); build/asm/main_80065CE0.s.o(.text); build/asm/main_80065CE0.s.o(.rodata); build/asm/main_80065CE0.s.o(.data); }
    .main_80065CE0_bss (NOLOAD) : { build/asm/main_80065CE0.s.o(.bss); }
    .main_80069164 0x80069164 : AT(0x00069D64) { FILL(0x00000000); build/asm/main_80069164.s.o(.text); build/asm/main_80069164.s.o(.rodata); build/asm/main_80069164.s.o(.data); }
    .main_80069164_bss (NOLOAD) : { build/asm/main_80069164.s.o(.bss); }
    .main_80069A20 0x80069A20 : AT(0x0006A620) { FILL(0x00000000); build/asm/main_80069A20.s.o(.text); build/asm/main_80069A20.s.o(.rodata); build/asm/main_80069A20.s.o(.data); }
    .main_80069A20_bss (NOLOAD) : { build/asm/main_80069A20.s.o(.bss); }
    .main_8006AC7C 0x8006AC7C : AT(0x0006B87C) { FILL(0x00000000); build/asm/main_8006AC7C.s.o(.text); build/asm/main_8006AC7C.s.o(.rodata); build/asm/main_8006AC7C.s.o(.data); }
    .main_8006AC7C_bss (NOLOAD) : { build/asm/main_8006AC7C.s.o(.bss); }
    .main_8006C27C 0x8006C27C : AT(0x0006CE7C) { FILL(0x00000000); build/asm/main_8006C27C.s.o(.text); build/asm/main_8006C27C.s.o(.rodata); build/asm/main_8006C27C.s.o(.data); }
    .main_8006C27C_bss (NOLOAD) : { build/asm/main_8006C27C.s.o(.bss); }
    .main_8006CD58 0x8006CD58 : AT(0x0006D958) { FILL(0x00000000); build/asm/main_8006CD58.s.o(.text); build/asm/main_8006CD58.s.o(.rodata); build/asm/main_8006CD58.s.o(.data); }
    .main_8006CD58_bss (NOLOAD) : { build/asm/main_8006CD58.s.o(.bss); }
    .main_8006DC18 0x8006DC18 : AT(0x0006E818) { FILL(0x00000000); build/asm/main_8006DC18.s.o(.text); build/asm/main_8006DC18.s.o(.rodata); build/asm/main_8006DC18.s.o(.data); }
    .main_8006DC18_bss (NOLOAD) : { build/asm/main_8006DC18.s.o(.bss); }
    .main_8006F870 0x8006F870 : AT(0x00070470) { FILL(0x00000000); build/asm/main_8006F870.s.o(.text); build/asm/main_8006F870.s.o(.rodata); build/asm/main_8006F870.s.o(.data); }
    .main_8006F870_bss (NOLOAD) : { build/asm/main_8006F870.s.o(.bss); }
    .main_800719C0 0x800719C0 : AT(0x000725C0) { FILL(0x00000000); build/asm/main_800719C0.s.o(.text); build/asm/main_800719C0.s.o(.rodata); build/asm/main_800719C0.s.o(.data); }
    .main_800719C0_bss (NOLOAD) : { build/asm/main_800719C0.s.o(.bss); }
    .main_800728B0 0x800728B0 : AT(0x000734B0) { FILL(0x00000000); build/asm/main_800728B0.s.o(.text); build/asm/main_800728B0.s.o(.rodata); build/asm/main_800728B0.s.o(.data); }
    .main_800728B0_bss (NOLOAD) : { build/asm/main_800728B0.s.o(.bss); }
    .main_80073CEC 0x80073CEC : AT(0x000748EC) { FILL(0x00000000); build/asm/main_80073CEC.s.o(.text); build/asm/main_80073CEC.s.o(.rodata); build/asm/main_80073CEC.s.o(.data); }
    .main_80073CEC_bss (NOLOAD) : { build/asm/main_80073CEC.s.o(.bss); }
    .main_800798A8 0x800798A8 : AT(0x0007A4A8) { FILL(0x00000000); build/asm/main_800798A8.s.o(.text); build/asm/main_800798A8.s.o(.rodata); build/asm/main_800798A8.s.o(.data); }
    .main_800798A8_bss (NOLOAD) : { build/asm/main_800798A8.s.o(.bss); }
    .main_8007D860 0x8007D860 : AT(0x0007E460) { FILL(0x00000000); build/asm/main_8007D860.s.o(.text); build/asm/main_8007D860.s.o(.rodata); build/asm/main_8007D860.s.o(.data); }
    .main_8007D860_bss (NOLOAD) : { build/asm/main_8007D860.s.o(.bss); }
    .main_8007DA60 0x8007DA60 : AT(0x0007E660) { FILL(0x00000000); build/asm/main_8007DA60.s.o(.text); build/asm/main_8007DA60.s.o(.rodata); build/asm/main_8007DA60.s.o(.data); }
    .main_8007DA60_bss (NOLOAD) : { build/asm/main_8007DA60.s.o(.bss); }
    .main_80082B38 0x80082B38 : AT(0x00083738) { FILL(0x00000000); build/asm/main_80082B38.s.o(.text); build/asm/main_80082B38.s.o(.rodata); build/asm/main_80082B38.s.o(.data); }
    .main_80082B38_bss (NOLOAD) : { build/asm/main_80082B38.s.o(.bss); }
    .main_800834BC 0x800834BC : AT(0x000840BC) { FILL(0x00000000); build/asm/main_800834BC.s.o(.text); build/asm/main_800834BC.s.o(.rodata); build/asm/main_800834BC.s.o(.data); }
    .main_800834BC_bss (NOLOAD) : { build/asm/main_800834BC.s.o(.bss); }
    .main_8008ABC0 0x8008ABC0 : AT(0x0008B7C0) { FILL(0x00000000); build/asm/main_8008ABC0.s.o(.text); build/asm/main_8008ABC0.s.o(.rodata); build/asm/main_8008ABC0.s.o(.data); }
    .main_8008ABC0_bss (NOLOAD) : { build/asm/main_8008ABC0.s.o(.bss); }
    .main_8008DFF0 0x8008DFF0 : AT(0x0008EBF0) { FILL(0x00000000); build/asm/main_8008DFF0.s.o(.text); build/asm/main_8008DFF0.s.o(.rodata); build/asm/main_8008DFF0.s.o(.data); }
    .main_8008DFF0_bss (NOLOAD) : { build/asm/main_8008DFF0.s.o(.bss); }
    .main_8008E910 0x8008E910 : AT(0x0008F510) { FILL(0x00000000); build/asm/main_8008E910.s.o(.text); build/asm/main_8008E910.s.o(.rodata); build/asm/main_8008E910.s.o(.data); }
    .main_8008E910_bss (NOLOAD) : { build/asm/main_8008E910.s.o(.bss); }
    .main_80090B90 0x80090B90 : AT(0x00091790) { FILL(0x00000000); build/asm/main_80090B90.s.o(.text); build/asm/main_80090B90.s.o(.rodata); build/asm/main_80090B90.s.o(.data); }
    .main_80090B90_bss (NOLOAD) : { build/asm/main_80090B90.s.o(.bss); }
    .main_80090F9C 0x80090F9C : AT(0x00091B9C) { FILL(0x00000000); build/asm/main_80090F9C.s.o(.text); build/asm/main_80090F9C.s.o(.rodata); build/asm/main_80090F9C.s.o(.data); }
    .main_80090F9C_bss (NOLOAD) : { build/asm/main_80090F9C.s.o(.bss); }
    .main_8009151C 0x8009151C : AT(0x0009211C) { FILL(0x00000000); build/asm/main_8009151C.s.o(.text); build/asm/main_8009151C.s.o(.rodata); build/asm/main_8009151C.s.o(.data); }
    .main_8009151C_bss (NOLOAD) : { build/asm/main_8009151C.s.o(.bss); }
    .main_80091E60 0x80091E60 : AT(0x00092A60) { FILL(0x00000000); build/asm/main_80091E60.s.o(.text); build/asm/main_80091E60.s.o(.rodata); build/asm/main_80091E60.s.o(.data); }
    .main_80091E60_bss (NOLOAD) : { build/asm/main_80091E60.s.o(.bss); }
    .main_8009207C 0x8009207C : AT(0x00092C7C) { FILL(0x00000000); build/asm/main_8009207C.s.o(.text); build/asm/main_8009207C.s.o(.rodata); build/asm/main_8009207C.s.o(.data); }
    .main_8009207C_bss (NOLOAD) : { build/asm/main_8009207C.s.o(.bss); }
    .main_800924F0 0x800924F0 : AT(0x000930F0) { FILL(0x00000000); build/asm/main_800924F0.s.o(.text); build/asm/main_800924F0.s.o(.rodata); build/asm/main_800924F0.s.o(.data); }
    .main_800924F0_bss (NOLOAD) : { build/asm/main_800924F0.s.o(.bss); }
    .main_800926F4 0x800926F4 : AT(0x000932F4) { FILL(0x00000000); build/asm/main_800926F4.s.o(.text); build/asm/main_800926F4.s.o(.rodata); build/asm/main_800926F4.s.o(.data); }
    .main_800926F4_bss (NOLOAD) : { build/asm/main_800926F4.s.o(.bss); }
    .main_80092E20 0x80092E20 : AT(0x00093A20) { FILL(0x00000000); build/asm/main_80092E20.s.o(.text); build/asm/main_80092E20.s.o(.rodata); build/asm/main_80092E20.s.o(.data); }
    .main_80092E20_bss (NOLOAD) : { build/asm/main_80092E20.s.o(.bss); }
    .main_80095270 0x80095270 : AT(0x00095E70) { FILL(0x00000000); build/asm/main_80095270.s.o(.text); build/asm/main_80095270.s.o(.rodata); build/asm/main_80095270.s.o(.data); }
    .main_80095270_bss (NOLOAD) : { build/asm/main_80095270.s.o(.bss); }
    .main_80096344 0x80096344 : AT(0x00096F44) { FILL(0x00000000); build/asm/main_80096344.s.o(.text); build/asm/main_80096344.s.o(.rodata); build/asm/main_80096344.s.o(.data); }
    .main_80096344_bss (NOLOAD) : { build/asm/main_80096344.s.o(.bss); }
    .main_80096720 0x80096720 : AT(0x00097320) { FILL(0x00000000); build/asm/main_80096720.s.o(.text); build/asm/main_80096720.s.o(.rodata); build/asm/main_80096720.s.o(.data); }
    .main_80096720_bss (NOLOAD) : { build/asm/main_80096720.s.o(.bss); }
    .main_800A17A0 0x800A17A0 : AT(0x000A23A0) { FILL(0x00000000); build/asm/main_800A17A0.s.o(.text); build/asm/main_800A17A0.s.o(.rodata); build/asm/main_800A17A0.s.o(.data); }
    .main_800A17A0_bss (NOLOAD) : { build/asm/main_800A17A0.s.o(.bss); }
    .main_800A17E4 0x800A17E4 : AT(0x000A23E4) { build/asm/data/main_800A17E4.bin.o(.data); }
    .main_800A9FD0 0x800A9FD0 : AT(0x000AABD0) { build/asm/data/main_800A9FD0.bin.o(.data); }
    .main_800AAAA0 0x800AAAA0 : AT(0x000AB6A0) { build/asm/data/main_800AAAA0.bin.o(.data); }
    .main_800B59FC 0x800B59FC : AT(0x000B65FC) { FILL(0x00000000); build/asm/main_800B59FC.s.o(.text); build/asm/main_800B59FC.s.o(.rodata); build/asm/main_800B59FC.s.o(.data); }
    .main_800B59FC_bss (NOLOAD) : { build/asm/main_800B59FC.s.o(.bss); }
    .main_800B75CC 0x800B75CC : AT(0x000B81CC) { FILL(0x00000000); build/asm/main_800B75CC.s.o(.text); build/asm/main_800B75CC.s.o(.rodata); build/asm/main_800B75CC.s.o(.data); }
    .main_800B75CC_bss (NOLOAD) : { build/asm/main_800B75CC.s.o(.bss); }
    .main_800BA6CC 0x800BA6CC : AT(0x000BB2CC) { FILL(0x00000000); build/asm/main_800BA6CC.s.o(.text); build/asm/main_800BA6CC.s.o(.rodata); build/asm/main_800BA6CC.s.o(.data); }
    .main_800BA6CC_bss (NOLOAD) : { build/asm/main_800BA6CC.s.o(.bss); }
    .main_800C2108 0x800C2108 : AT(0x000C2D08) { FILL(0x00000000); build/asm/main_800C2108.s.o(.text); build/asm/main_800C2108.s.o(.rodata); build/asm/main_800C2108.s.o(.data); }
    .main_800C2108_bss (NOLOAD) : { build/asm/main_800C2108.s.o(.bss); }
    .main_800C29BC 0x800C29BC : AT(0x000C35BC) { build/asm/data/main_800C29BC.bin.o(.data); }
    .main_800C9F5C 0x800C9F5C : AT(0x000CAB5C) { FILL(0x00000000); build/asm/main_800C9F5C.s.o(.text); build/asm/main_800C9F5C.s.o(.rodata); build/asm/main_800C9F5C.s.o(.data); }
    .main_800C9F5C_bss (NOLOAD) : { build/asm/main_800C9F5C.s.o(.bss); }
    .main_800E646C 0x800E646C : AT(0x000E706C) { build/asm/data/main_800E646C.bin.o(.data); }
    .main_800E64D8 0x800E64D8 : AT(0x000E70D8) { FILL(0x00000000); build/asm/main_800E64D8.s.o(.text); build/asm/main_800E64D8.s.o(.rodata); build/asm/main_800E64D8.s.o(.data); }
    .main_800E64D8_bss (NOLOAD) : { build/asm/main_800E64D8.s.o(.bss); }
    .main_800E65E0 0x800E65E0 : AT(0x000E71E0) { build/asm/data/main_800E65E0.bin.o(.data); }
    .main_800E6B70 0x800E6B70 : AT(0x000E7770) { FILL(0x00000000); build/asm/main_800E6B70.s.o(.text); build/asm/main_800E6B70.s.o(.rodata); build/asm/main_800E6B70.s.o(.data); }
    .main_800E6B70_bss (NOLOAD) : { build/asm/main_800E6B70.s.o(.bss); }
    .main_800E6BBC 0x800E6BBC : AT(0x000E77BC) { build/asm/data/main_800E6BBC.bin.o(.data); }
    .main_800EE178 0x800EE178 : AT(0x000EED78) { build/asm/data/main_800EE178.bin.o(.data); }
    .main_800EEEE0 0x800EEEE0 : AT(0x000EFAE0) { build/asm/data/main_800EEEE0.bin.o(.data); }
    .main_800F487C 0x800F487C : AT(0x000F547C) { FILL(0x00000000); build/asm/main_800F487C.s.o(.text); build/asm/main_800F487C.s.o(.rodata); build/asm/main_800F487C.s.o(.data); }
    .main_800F487C_bss (NOLOAD) : { build/asm/main_800F487C.s.o(.bss); }
    .main_800F4884 0x800F4884 : AT(0x000F5484) { build/asm/data/main_800F4884.bin.o(.data); }
    .main_800F6430 0x800F6430 : AT(0x000F7030) { FILL(0x00000000); build/asm/main_800F6430.s.o(.text); build/asm/main_800F6430.s.o(.rodata); build/asm/main_800F6430.s.o(.data); }
    .main_800F6430_bss (NOLOAD) : { build/asm/main_800F6430.s.o(.bss); }
    .main_800F6448 0x800F6448 : AT(0x000F7048) { build/asm/data/main_800F6448.bin.o(.data); }
    .main_800F69C0 0x800F69C0 : AT(0x000F75C0) { FILL(0x00000000); build/asm/main_800F69C0.s.o(.text); build/asm/main_800F69C0.s.o(.rodata); build/asm/main_800F69C0.s.o(.data); }
    .main_800F69C0_bss (NOLOAD) : { build/asm/main_800F69C0.s.o(.bss); }
    .main_800F69C8 0x800F69C8 : AT(0x000F75C8) { build/asm/data/main_800F69C8.bin.o(.data); }
    .main_800FB85C 0x800FB85C : AT(0x000FC45C) { FILL(0x00000000); build/asm/main_800FB85C.s.o(.text); build/asm/main_800FB85C.s.o(.rodata); build/asm/main_800FB85C.s.o(.data); }
    .main_800FB85C_bss (NOLOAD) : { build/asm/main_800FB85C.s.o(.bss); }
    .main_800FB86C 0x800FB86C : AT(0x000FC46C) { build/asm/data/main_800FB86C.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
