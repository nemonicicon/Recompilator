SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004A8 0x800004A8 : AT(0x000010A8) { FILL(0x00000000); build/asm/main_800004A8.s.o(.text); build/asm/main_800004A8.s.o(.rodata); build/asm/main_800004A8.s.o(.data); }
    .main_800004A8_bss (NOLOAD) : { build/asm/main_800004A8.s.o(.bss); }
    .main_80001118 0x80001118 : AT(0x00001D18) { FILL(0x00000000); build/asm/main_80001118.s.o(.text); build/asm/main_80001118.s.o(.rodata); build/asm/main_80001118.s.o(.data); }
    .main_80001118_bss (NOLOAD) : { build/asm/main_80001118.s.o(.bss); }
    .main_8001901C 0x8001901C : AT(0x00019C1C) { FILL(0x00000000); build/asm/main_8001901C.s.o(.text); build/asm/main_8001901C.s.o(.rodata); build/asm/main_8001901C.s.o(.data); }
    .main_8001901C_bss (NOLOAD) : { build/asm/main_8001901C.s.o(.bss); }
    .main_8001D8B0 0x8001D8B0 : AT(0x0001E4B0) { FILL(0x00000000); build/asm/main_8001D8B0.s.o(.text); build/asm/main_8001D8B0.s.o(.rodata); build/asm/main_8001D8B0.s.o(.data); }
    .main_8001D8B0_bss (NOLOAD) : { build/asm/main_8001D8B0.s.o(.bss); }
    .main_8001DB58 0x8001DB58 : AT(0x0001E758) { FILL(0x00000000); build/asm/main_8001DB58.s.o(.text); build/asm/main_8001DB58.s.o(.rodata); build/asm/main_8001DB58.s.o(.data); }
    .main_8001DB58_bss (NOLOAD) : { build/asm/main_8001DB58.s.o(.bss); }
    .main_80051A64 0x80051A64 : AT(0x00052664) { FILL(0x00000000); build/asm/main_80051A64.s.o(.text); build/asm/main_80051A64.s.o(.rodata); build/asm/main_80051A64.s.o(.data); }
    .main_80051A64_bss (NOLOAD) : { build/asm/main_80051A64.s.o(.bss); }
    .main_80051E30 0x80051E30 : AT(0x00052A30) { FILL(0x00000000); build/asm/main_80051E30.s.o(.text); build/asm/main_80051E30.s.o(.rodata); build/asm/main_80051E30.s.o(.data); }
    .main_80051E30_bss (NOLOAD) : { build/asm/main_80051E30.s.o(.bss); }
    .main_80065A4C 0x80065A4C : AT(0x0006664C) { FILL(0x00000000); build/asm/data/main_80065A4C.data.s.o(.data); }
    .main_80070300 0x80070300 : AT(0x00070F00) { FILL(0x00000000); build/asm/data/main_80070300.data.s.o(.data); }
    .main_800AA5F0 0x800AA5F0 : AT(0x000AB1F0) { FILL(0x00000000); build/asm/main_800AA5F0.s.o(.text); build/asm/main_800AA5F0.s.o(.rodata); build/asm/main_800AA5F0.s.o(.data); }
    .main_800AA5F0_bss (NOLOAD) : { build/asm/main_800AA5F0.s.o(.bss); }
    .main_800AB10C 0x800AB10C : AT(0x000ABD0C) { FILL(0x00000000); build/asm/main_800AB10C.s.o(.text); build/asm/main_800AB10C.s.o(.rodata); build/asm/main_800AB10C.s.o(.data); }
    .main_800AB10C_bss (NOLOAD) : { build/asm/main_800AB10C.s.o(.bss); }
    .main_800ADEE0 0x800ADEE0 : AT(0x000AEAE0) { FILL(0x00000000); build/asm/data/main_800ADEE0.data.s.o(.data); }
    .main_800C30EC 0x800C30EC : AT(0x000C3CEC) { FILL(0x00000000); build/asm/data/main_800C30EC.data.s.o(.data); }
    .main_800C401C 0x800C401C : AT(0x000C4C1C) { FILL(0x00000000); build/asm/main_800C401C.s.o(.text); build/asm/main_800C401C.s.o(.rodata); build/asm/main_800C401C.s.o(.data); }
    .main_800C401C_bss (NOLOAD) : { build/asm/main_800C401C.s.o(.bss); }
    .main_800C4314 0x800C4314 : AT(0x000C4F14) { FILL(0x00000000); build/asm/data/main_800C4314.data.s.o(.data); }
    .main_800C47C0 0x800C47C0 : AT(0x000C53C0) { FILL(0x00000000); build/asm/main_800C47C0.s.o(.text); build/asm/main_800C47C0.s.o(.rodata); build/asm/main_800C47C0.s.o(.data); }
    .main_800C47C0_bss (NOLOAD) : { build/asm/main_800C47C0.s.o(.bss); }
    .main_800C483C 0x800C483C : AT(0x000C543C) { FILL(0x00000000); build/asm/data/main_800C483C.data.s.o(.data); }
    .main_800C4D4C 0x800C4D4C : AT(0x000C594C) { FILL(0x00000000); build/asm/main_800C4D4C.s.o(.text); build/asm/main_800C4D4C.s.o(.rodata); build/asm/main_800C4D4C.s.o(.data); }
    .main_800C4D4C_bss (NOLOAD) : { build/asm/main_800C4D4C.s.o(.bss); }
    .main_800C5244 0x800C5244 : AT(0x000C5E44) { FILL(0x00000000); build/asm/data/main_800C5244.data.s.o(.data); }
    .main_800C5370 0x800C5370 : AT(0x000C5F70) { FILL(0x00000000); build/asm/main_800C5370.s.o(.text); build/asm/main_800C5370.s.o(.rodata); build/asm/main_800C5370.s.o(.data); }
    .main_800C5370_bss (NOLOAD) : { build/asm/main_800C5370.s.o(.bss); }
    .main_800C583C 0x800C583C : AT(0x000C643C) { FILL(0x00000000); build/asm/data/main_800C583C.data.s.o(.data); }
    .main_800C5B70 0x800C5B70 : AT(0x000C6770) { FILL(0x00000000); build/asm/main_800C5B70.s.o(.text); build/asm/main_800C5B70.s.o(.rodata); build/asm/main_800C5B70.s.o(.data); }
    .main_800C5B70_bss (NOLOAD) : { build/asm/main_800C5B70.s.o(.bss); }
    .main_800C5E7C 0x800C5E7C : AT(0x000C6A7C) { FILL(0x00000000); build/asm/data/main_800C5E7C.data.s.o(.data); }
    .main_800C5EBC 0x800C5EBC : AT(0x000C6ABC) { FILL(0x00000000); build/asm/main_800C5EBC.s.o(.text); build/asm/main_800C5EBC.s.o(.rodata); build/asm/main_800C5EBC.s.o(.data); }
    .main_800C5EBC_bss (NOLOAD) : { build/asm/main_800C5EBC.s.o(.bss); }
    .main_800C6370 0x800C6370 : AT(0x000C6F70) { FILL(0x00000000); build/asm/data/main_800C6370.data.s.o(.data); }
    .main_800C6640 0x800C6640 : AT(0x000C7240) { FILL(0x00000000); build/asm/main_800C6640.s.o(.text); build/asm/main_800C6640.s.o(.rodata); build/asm/main_800C6640.s.o(.data); }
    .main_800C6640_bss (NOLOAD) : { build/asm/main_800C6640.s.o(.bss); }
    .main_800C6F40 0x800C6F40 : AT(0x000C7B40) { FILL(0x00000000); build/asm/main_800C6F40.s.o(.text); build/asm/main_800C6F40.s.o(.rodata); build/asm/main_800C6F40.s.o(.data); }
    .main_800C6F40_bss (NOLOAD) : { build/asm/main_800C6F40.s.o(.bss); }
    .main_800C98BC 0x800C98BC : AT(0x000CA4BC) { FILL(0x00000000); build/asm/main_800C98BC.s.o(.text); build/asm/main_800C98BC.s.o(.rodata); build/asm/main_800C98BC.s.o(.data); }
    .main_800C98BC_bss (NOLOAD) : { build/asm/main_800C98BC.s.o(.bss); }
    .main_800D1868 0x800D1868 : AT(0x000D2468) { FILL(0x00000000); build/asm/main_800D1868.s.o(.text); build/asm/main_800D1868.s.o(.rodata); build/asm/main_800D1868.s.o(.data); }
    .main_800D1868_bss (NOLOAD) : { build/asm/main_800D1868.s.o(.bss); }
    .main_800DBCA8 0x800DBCA8 : AT(0x000DC8A8) { FILL(0x00000000); build/asm/data/main_800DBCA8.data.s.o(.data); }
    .main_800FBD04 0x800FBD04 : AT(0x000FC904) { FILL(0x00000000); build/asm/data/main_800FBD04.data.s.o(.data); }
    .main_801000F4 0x801000F4 : AT(0x00100CF4) { FILL(0x00000000); build/asm/data/main_801000F4.data.s.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
