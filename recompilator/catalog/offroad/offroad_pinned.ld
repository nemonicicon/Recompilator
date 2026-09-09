SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80048328 0x80048328 : AT(0x00048F28) { FILL(0x00000000); build/asm/main_80048328.s.o(.text); build/asm/main_80048328.s.o(.rodata); build/asm/main_80048328.s.o(.data); }
    .main_80048328_bss (NOLOAD) : { build/asm/main_80048328.s.o(.bss); }
    .main_80068B44 0x80068B44 : AT(0x00069744) { FILL(0x00000000); build/asm/main_80068B44.s.o(.text); build/asm/main_80068B44.s.o(.rodata); build/asm/main_80068B44.s.o(.data); }
    .main_80068B44_bss (NOLOAD) : { build/asm/main_80068B44.s.o(.bss); }
    .main_80068F20 0x80068F20 : AT(0x00069B20) { FILL(0x00000000); build/asm/main_80068F20.s.o(.text); build/asm/main_80068F20.s.o(.rodata); build/asm/main_80068F20.s.o(.data); }
    .main_80068F20_bss (NOLOAD) : { build/asm/main_80068F20.s.o(.bss); }
    .main_80080074 0x80080074 : AT(0x00080C74) { FILL(0x00000000); build/asm/main_80080074.s.o(.text); build/asm/main_80080074.s.o(.rodata); build/asm/main_80080074.s.o(.data); }
    .main_80080074_bss (NOLOAD) : { build/asm/main_80080074.s.o(.bss); }
    .main_80083058 0x80083058 : AT(0x00083C58) { FILL(0x00000000); build/asm/main_80083058.s.o(.text); build/asm/main_80083058.s.o(.rodata); build/asm/main_80083058.s.o(.data); }
    .main_80083058_bss (NOLOAD) : { build/asm/main_80083058.s.o(.bss); }
    .main_8008580C 0x8008580C : AT(0x0008640C) { FILL(0x00000000); build/asm/main_8008580C.s.o(.text); build/asm/main_8008580C.s.o(.rodata); build/asm/main_8008580C.s.o(.data); }
    .main_8008580C_bss (NOLOAD) : { build/asm/main_8008580C.s.o(.bss); }
    .main_80085C0C 0x80085C0C : AT(0x0008680C) { FILL(0x00000000); build/asm/main_80085C0C.s.o(.text); build/asm/main_80085C0C.s.o(.rodata); build/asm/main_80085C0C.s.o(.data); }
    .main_80085C0C_bss (NOLOAD) : { build/asm/main_80085C0C.s.o(.bss); }
    .main_80086A40 0x80086A40 : AT(0x00087640) { FILL(0x00000000); build/asm/main_80086A40.s.o(.text); build/asm/main_80086A40.s.o(.rodata); build/asm/main_80086A40.s.o(.data); }
    .main_80086A40_bss (NOLOAD) : { build/asm/main_80086A40.s.o(.bss); }
    .main_80087690 0x80087690 : AT(0x00088290) { FILL(0x00000000); build/asm/main_80087690.s.o(.text); build/asm/main_80087690.s.o(.rodata); build/asm/main_80087690.s.o(.data); }
    .main_80087690_bss (NOLOAD) : { build/asm/main_80087690.s.o(.bss); }
    .main_8008770C 0x8008770C : AT(0x0008830C) { FILL(0x00000000); build/asm/main_8008770C.s.o(.text); build/asm/main_8008770C.s.o(.rodata); build/asm/main_8008770C.s.o(.data); }
    .main_8008770C_bss (NOLOAD) : { build/asm/main_8008770C.s.o(.bss); }
    .main_8008C8EC 0x8008C8EC : AT(0x0008D4EC) { FILL(0x00000000); build/asm/main_8008C8EC.s.o(.text); build/asm/main_8008C8EC.s.o(.rodata); build/asm/main_8008C8EC.s.o(.data); }
    .main_8008C8EC_bss (NOLOAD) : { build/asm/main_8008C8EC.s.o(.bss); }
    .main_80094414 0x80094414 : AT(0x00095014) { FILL(0x00000000); build/asm/data/main_80094414.data.s.o(.data); }
    .main_80096374 0x80096374 : AT(0x00096F74) { FILL(0x00000000); build/asm/main_80096374.s.o(.text); build/asm/main_80096374.s.o(.rodata); build/asm/main_80096374.s.o(.data); }
    .main_80096374_bss (NOLOAD) : { build/asm/main_80096374.s.o(.bss); }
    .main_80097318 0x80097318 : AT(0x00097F18) { FILL(0x00000000); build/asm/data/main_80097318.data.s.o(.data); }
    .main_800A5B9C 0x800A5B9C : AT(0x000A679C) { FILL(0x00000000); build/asm/main_800A5B9C.s.o(.text); build/asm/main_800A5B9C.s.o(.rodata); build/asm/main_800A5B9C.s.o(.data); }
    .main_800A5B9C_bss (NOLOAD) : { build/asm/main_800A5B9C.s.o(.bss); }
    .main_800A5C90 0x800A5C90 : AT(0x000A6890) { FILL(0x00000000); build/asm/data/main_800A5C90.data.s.o(.data); }
    .main_800C3090 0x800C3090 : AT(0x000C3C90) { FILL(0x00000000); build/asm/main_800C3090.s.o(.text); build/asm/main_800C3090.s.o(.rodata); build/asm/main_800C3090.s.o(.data); }
    .main_800C3090_bss (NOLOAD) : { build/asm/main_800C3090.s.o(.bss); }
    .main_800C30B4 0x800C30B4 : AT(0x000C3CB4) { FILL(0x00000000); build/asm/data/main_800C30B4.data.s.o(.data); }
    .main_800D0A20 0x800D0A20 : AT(0x000D1620) { FILL(0x00000000); build/asm/data/main_800D0A20.data.s.o(.data); }
    .main_800D1A7C 0x800D1A7C : AT(0x000D267C) { FILL(0x00000000); build/asm/main_800D1A7C.s.o(.text); build/asm/main_800D1A7C.s.o(.rodata); build/asm/main_800D1A7C.s.o(.data); }
    .main_800D1A7C_bss (NOLOAD) : { build/asm/main_800D1A7C.s.o(.bss); }
    .main_800D1AB4 0x800D1AB4 : AT(0x000D26B4) { FILL(0x00000000); build/asm/data/main_800D1AB4.data.s.o(.data); }
    .main_800DE4F4 0x800DE4F4 : AT(0x000DF0F4) { FILL(0x00000000); build/asm/main_800DE4F4.s.o(.text); build/asm/main_800DE4F4.s.o(.rodata); build/asm/main_800DE4F4.s.o(.data); }
    .main_800DE4F4_bss (NOLOAD) : { build/asm/main_800DE4F4.s.o(.bss); }
    .main_800DE6F8 0x800DE6F8 : AT(0x000DF2F8) { FILL(0x00000000); build/asm/data/main_800DE6F8.data.s.o(.data); }
    .main_800FC388 0x800FC388 : AT(0x000FCF88) { FILL(0x00000000); build/asm/main_800FC388.s.o(.text); build/asm/main_800FC388.s.o(.rodata); build/asm/main_800FC388.s.o(.data); }
    .main_800FC388_bss (NOLOAD) : { build/asm/main_800FC388.s.o(.bss); }
    .main_800FCB6C 0x800FCB6C : AT(0x000FD76C) { FILL(0x00000000); build/asm/data/main_800FCB6C.data.s.o(.data); }
    .main_800FCF90 0x800FCF90 : AT(0x000FDB90) { FILL(0x00000000); build/asm/main_800FCF90.s.o(.text); build/asm/main_800FCF90.s.o(.rodata); build/asm/main_800FCF90.s.o(.data); }
    .main_800FCF90_bss (NOLOAD) : { build/asm/main_800FCF90.s.o(.bss); }
    .main_800FD010 0x800FD010 : AT(0x000FDC10) { FILL(0x00000000); build/asm/data/main_800FD010.data.s.o(.data); }
    .main_80100004 0x80100004 : AT(0x00100C04) { FILL(0x00000000); build/asm/main_80100004.s.o(.text); build/asm/main_80100004.s.o(.rodata); build/asm/main_80100004.s.o(.data); }
    .main_80100004_bss (NOLOAD) : { build/asm/main_80100004.s.o(.bss); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
