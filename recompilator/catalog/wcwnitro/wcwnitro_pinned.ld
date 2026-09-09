SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80025C00 0x80025C00 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80025C00.s.o(.text); build/asm/main_80025C00.s.o(.rodata); build/asm/main_80025C00.s.o(.data); }
    .main_80025C00_bss (NOLOAD) : { build/asm/main_80025C00.s.o(.bss); }
    .main_8002F8B4 0x8002F8B4 : AT(0x0000ACB4) { FILL(0x00000000); build/asm/main_8002F8B4.s.o(.text); build/asm/main_8002F8B4.s.o(.rodata); build/asm/main_8002F8B4.s.o(.data); }
    .main_8002F8B4_bss (NOLOAD) : { build/asm/main_8002F8B4.s.o(.bss); }
    .main_80065CCC 0x80065CCC : AT(0x000410CC) { FILL(0x00000000); build/asm/main_80065CCC.s.o(.text); build/asm/main_80065CCC.s.o(.rodata); build/asm/main_80065CCC.s.o(.data); }
    .main_80065CCC_bss (NOLOAD) : { build/asm/main_80065CCC.s.o(.bss); }
    .main_800660B0 0x800660B0 : AT(0x000414B0) { FILL(0x00000000); build/asm/main_800660B0.s.o(.text); build/asm/main_800660B0.s.o(.rodata); build/asm/main_800660B0.s.o(.data); }
    .main_800660B0_bss (NOLOAD) : { build/asm/main_800660B0.s.o(.bss); }
    .main_80071C78 0x80071C78 : AT(0x0004D078) { build/asm/data/main_80071C78.bin.o(.data); }
    .main_800766E4 0x800766E4 : AT(0x00051AE4) { FILL(0x00000000); build/asm/main_800766E4.s.o(.text); build/asm/main_800766E4.s.o(.rodata); build/asm/main_800766E4.s.o(.data); }
    .main_800766E4_bss (NOLOAD) : { build/asm/main_800766E4.s.o(.bss); }
    .main_80076884 0x80076884 : AT(0x00051C84) { build/asm/data/main_80076884.bin.o(.data); }
    .main_80077018 0x80077018 : AT(0x00052418) { FILL(0x00000000); build/asm/main_80077018.s.o(.text); build/asm/main_80077018.s.o(.rodata); build/asm/main_80077018.s.o(.data); }
    .main_80077018_bss (NOLOAD) : { build/asm/main_80077018.s.o(.bss); }
    .main_800770B0 0x800770B0 : AT(0x000524B0) { build/asm/data/main_800770B0.bin.o(.data); }
    .main_800772CC 0x800772CC : AT(0x000526CC) { FILL(0x00000000); build/asm/main_800772CC.s.o(.text); build/asm/main_800772CC.s.o(.rodata); build/asm/main_800772CC.s.o(.data); }
    .main_800772CC_bss (NOLOAD) : { build/asm/main_800772CC.s.o(.bss); }
    .main_8007754C 0x8007754C : AT(0x0005294C) { FILL(0x00000000); build/asm/main_8007754C.s.o(.text); build/asm/main_8007754C.s.o(.rodata); build/asm/main_8007754C.s.o(.data); }
    .main_8007754C_bss (NOLOAD) : { build/asm/main_8007754C.s.o(.bss); }
    .main_8008043C 0x8008043C : AT(0x0005B83C) { FILL(0x00000000); build/asm/main_8008043C.s.o(.text); build/asm/main_8008043C.s.o(.rodata); build/asm/main_8008043C.s.o(.data); }
    .main_8008043C_bss (NOLOAD) : { build/asm/main_8008043C.s.o(.bss); }
    .main_80092DEC 0x80092DEC : AT(0x0006E1EC) { FILL(0x00000000); build/asm/main_80092DEC.s.o(.text); build/asm/main_80092DEC.s.o(.rodata); build/asm/main_80092DEC.s.o(.data); }
    .main_80092DEC_bss (NOLOAD) : { build/asm/main_80092DEC.s.o(.bss); }
    .main_80093378 0x80093378 : AT(0x0006E778) { FILL(0x00000000); build/asm/main_80093378.s.o(.text); build/asm/main_80093378.s.o(.rodata); build/asm/main_80093378.s.o(.data); }
    .main_80093378_bss (NOLOAD) : { build/asm/main_80093378.s.o(.bss); }
    .main_80093D90 0x80093D90 : AT(0x0006F190) { FILL(0x00000000); build/asm/main_80093D90.s.o(.text); build/asm/main_80093D90.s.o(.rodata); build/asm/main_80093D90.s.o(.data); }
    .main_80093D90_bss (NOLOAD) : { build/asm/main_80093D90.s.o(.bss); }
    .main_80094FE0 0x80094FE0 : AT(0x000703E0) { FILL(0x00000000); build/asm/main_80094FE0.s.o(.text); build/asm/main_80094FE0.s.o(.rodata); build/asm/main_80094FE0.s.o(.data); }
    .main_80094FE0_bss (NOLOAD) : { build/asm/main_80094FE0.s.o(.bss); }
    .main_800995D4 0x800995D4 : AT(0x000749D4) { FILL(0x00000000); build/asm/main_800995D4.s.o(.text); build/asm/main_800995D4.s.o(.rodata); build/asm/main_800995D4.s.o(.data); }
    .main_800995D4_bss (NOLOAD) : { build/asm/main_800995D4.s.o(.bss); }
    .main_8009BC60 0x8009BC60 : AT(0x00077060) { FILL(0x00000000); build/asm/main_8009BC60.s.o(.text); build/asm/main_8009BC60.s.o(.rodata); build/asm/main_8009BC60.s.o(.data); }
    .main_8009BC60_bss (NOLOAD) : { build/asm/main_8009BC60.s.o(.bss); }
    .main_8009EF98 0x8009EF98 : AT(0x0007A398) { FILL(0x00000000); build/asm/main_8009EF98.s.o(.text); build/asm/main_8009EF98.s.o(.rodata); build/asm/main_8009EF98.s.o(.data); }
    .main_8009EF98_bss (NOLOAD) : { build/asm/main_8009EF98.s.o(.bss); }
    .main_800A0038 0x800A0038 : AT(0x0007B438) { FILL(0x00000000); build/asm/main_800A0038.s.o(.text); build/asm/main_800A0038.s.o(.rodata); build/asm/main_800A0038.s.o(.data); }
    .main_800A0038_bss (NOLOAD) : { build/asm/main_800A0038.s.o(.bss); }
    .main_800A296C 0x800A296C : AT(0x0007DD6C) { FILL(0x00000000); build/asm/main_800A296C.s.o(.text); build/asm/main_800A296C.s.o(.rodata); build/asm/main_800A296C.s.o(.data); }
    .main_800A296C_bss (NOLOAD) : { build/asm/main_800A296C.s.o(.bss); }
    .main_800A453C 0x800A453C : AT(0x0007F93C) { FILL(0x00000000); build/asm/main_800A453C.s.o(.text); build/asm/main_800A453C.s.o(.rodata); build/asm/main_800A453C.s.o(.data); }
    .main_800A453C_bss (NOLOAD) : { build/asm/main_800A453C.s.o(.bss); }
    .main_800A5800 0x800A5800 : AT(0x00080C00) { FILL(0x00000000); build/asm/main_800A5800.s.o(.text); build/asm/main_800A5800.s.o(.rodata); build/asm/main_800A5800.s.o(.data); }
    .main_800A5800_bss (NOLOAD) : { build/asm/main_800A5800.s.o(.bss); }
    .main_800A879C 0x800A879C : AT(0x00083B9C) { build/asm/data/main_800A879C.bin.o(.data); }
    .main_800AB7F4 0x800AB7F4 : AT(0x00086BF4) { build/asm/data/main_800AB7F4.bin.o(.data); }
    .main_800AF1BC 0x800AF1BC : AT(0x0008A5BC) { FILL(0x00000000); build/asm/main_800AF1BC.s.o(.text); build/asm/main_800AF1BC.s.o(.rodata); build/asm/main_800AF1BC.s.o(.data); }
    .main_800AF1BC_bss (NOLOAD) : { build/asm/main_800AF1BC.s.o(.bss); }
    .main_800AF208 0x800AF208 : AT(0x0008A608) { build/asm/data/main_800AF208.bin.o(.data); }
    .main_800AF260 0x800AF260 : AT(0x0008A660) { FILL(0x00000000); build/asm/main_800AF260.s.o(.text); build/asm/main_800AF260.s.o(.rodata); build/asm/main_800AF260.s.o(.data); }
    .main_800AF260_bss (NOLOAD) : { build/asm/main_800AF260.s.o(.bss); }
    .main_800AF2D0 0x800AF2D0 : AT(0x0008A6D0) { build/asm/data/main_800AF2D0.bin.o(.data); }
    .main_800C4594 0x800C4594 : AT(0x0009F994) { FILL(0x00000000); build/asm/main_800C4594.s.o(.text); build/asm/main_800C4594.s.o(.rodata); build/asm/main_800C4594.s.o(.data); }
    .main_800C4594_bss (NOLOAD) : { build/asm/main_800C4594.s.o(.bss); }
    .main_800C45E8 0x800C45E8 : AT(0x0009F9E8) { build/asm/data/main_800C45E8.bin.o(.data); }
    .main_800D7678 0x800D7678 : AT(0x000B2A78) { FILL(0x00000000); build/asm/main_800D7678.s.o(.text); build/asm/main_800D7678.s.o(.rodata); build/asm/main_800D7678.s.o(.data); }
    .main_800D7678_bss (NOLOAD) : { build/asm/main_800D7678.s.o(.bss); }
    .main_800D769C 0x800D769C : AT(0x000B2A9C) { build/asm/data/main_800D769C.bin.o(.data); }
    .main_800DEBE0 0x800DEBE0 : AT(0x000B9FE0) { FILL(0x00000000); build/asm/main_800DEBE0.s.o(.text); build/asm/main_800DEBE0.s.o(.rodata); build/asm/main_800DEBE0.s.o(.data); }
    .main_800DEBE0_bss (NOLOAD) : { build/asm/main_800DEBE0.s.o(.bss); }
    .main_800DEBFC 0x800DEBFC : AT(0x000B9FFC) { build/asm/data/main_800DEBFC.bin.o(.data); }
    .main_800E4B24 0x800E4B24 : AT(0x000BFF24) { FILL(0x00000000); build/asm/main_800E4B24.s.o(.text); build/asm/main_800E4B24.s.o(.rodata); build/asm/main_800E4B24.s.o(.data); }
    .main_800E4B24_bss (NOLOAD) : { build/asm/main_800E4B24.s.o(.bss); }
    .main_800E4B5C 0x800E4B5C : AT(0x000BFF5C) { build/asm/data/main_800E4B5C.bin.o(.data); }
    .main_800E6384 0x800E6384 : AT(0x000C1784) { build/asm/data/main_800E6384.bin.o(.data); }
    .main_800E6694 0x800E6694 : AT(0x000C1A94) { build/asm/data/main_800E6694.bin.o(.data); }
    .main_800E925C 0x800E925C : AT(0x000C465C) { build/asm/data/main_800E925C.bin.o(.data); }
    .main_800F4594 0x800F4594 : AT(0x000CF994) { build/asm/data/main_800F4594.bin.o(.data); }
    .main_800F6A00 0x800F6A00 : AT(0x000D1E00) { FILL(0x00000000); build/asm/main_800F6A00.s.o(.text); build/asm/main_800F6A00.s.o(.rodata); build/asm/main_800F6A00.s.o(.data); }
    .main_800F6A00_bss (NOLOAD) : { build/asm/main_800F6A00.s.o(.bss); }
    .main_800F6A10 0x800F6A10 : AT(0x000D1E10) { build/asm/data/main_800F6A10.bin.o(.data); }
    .main_800FCA14 0x800FCA14 : AT(0x000D7E14) { build/asm/data/main_800FCA14.bin.o(.data); }
    .main_800FEE9C 0x800FEE9C : AT(0x000DA29C) { build/asm/data/main_800FEE9C.bin.o(.data); }
    .main_800FFBCC 0x800FFBCC : AT(0x000DAFCC) { build/asm/data/main_800FFBCC.bin.o(.data); }
    .main_8010013C 0x8010013C : AT(0x000DB53C) { build/asm/data/main_8010013C.bin.o(.data); }
    .main_80100DA0 0x80100DA0 : AT(0x000DC1A0) { FILL(0x00000000); build/asm/main_80100DA0.s.o(.text); build/asm/main_80100DA0.s.o(.rodata); build/asm/main_80100DA0.s.o(.data); }
    .main_80100DA0_bss (NOLOAD) : { build/asm/main_80100DA0.s.o(.bss); }
    .main_80102148 0x80102148 : AT(0x000DD548) { FILL(0x00000000); build/asm/main_80102148.s.o(.text); build/asm/main_80102148.s.o(.rodata); build/asm/main_80102148.s.o(.data); }
    .main_80102148_bss (NOLOAD) : { build/asm/main_80102148.s.o(.bss); }
    .main_80102154 0x80102154 : AT(0x000DD554) { build/asm/data/main_80102154.bin.o(.data); }
    .main_80102B88 0x80102B88 : AT(0x000DDF88) { FILL(0x00000000); build/asm/main_80102B88.s.o(.text); build/asm/main_80102B88.s.o(.rodata); build/asm/main_80102B88.s.o(.data); }
    .main_80102B88_bss (NOLOAD) : { build/asm/main_80102B88.s.o(.bss); }
    .main_80102B8C 0x80102B8C : AT(0x000DDF8C) { build/asm/data/main_80102B8C.bin.o(.data); }
    .main_801084D4 0x801084D4 : AT(0x000E38D4) { FILL(0x00000000); build/asm/main_801084D4.s.o(.text); build/asm/main_801084D4.s.o(.rodata); build/asm/main_801084D4.s.o(.data); }
    .main_801084D4_bss (NOLOAD) : { build/asm/main_801084D4.s.o(.bss); }
    .main_801084E0 0x801084E0 : AT(0x000E38E0) { build/asm/data/main_801084E0.bin.o(.data); }
    .main_8010EF04 0x8010EF04 : AT(0x000EA304) { FILL(0x00000000); build/asm/main_8010EF04.s.o(.text); build/asm/main_8010EF04.s.o(.rodata); build/asm/main_8010EF04.s.o(.data); }
    .main_8010EF04_bss (NOLOAD) : { build/asm/main_8010EF04.s.o(.bss); }
    .main_8010EF14 0x8010EF14 : AT(0x000EA314) { build/asm/data/main_8010EF14.bin.o(.data); }
    .main_80116E5C 0x80116E5C : AT(0x000F225C) { FILL(0x00000000); build/asm/main_80116E5C.s.o(.text); build/asm/main_80116E5C.s.o(.rodata); build/asm/main_80116E5C.s.o(.data); }
    .main_80116E5C_bss (NOLOAD) : { build/asm/main_80116E5C.s.o(.bss); }
    .main_80116E9C 0x80116E9C : AT(0x000F229C) { build/asm/data/main_80116E9C.bin.o(.data); }
    .main_80120E8C 0x80120E8C : AT(0x000FC28C) { build/asm/data/main_80120E8C.bin.o(.data); }
    .main_801216E8 0x801216E8 : AT(0x000FCAE8) { build/asm/data/main_801216E8.bin.o(.data); }
    .assets 0x80425C00 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
