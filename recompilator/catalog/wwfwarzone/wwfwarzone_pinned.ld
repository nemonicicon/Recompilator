SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_8000043C 0x8000043C : AT(0x0000103C) { FILL(0x00000000); build/asm/main_8000043C.s.o(.text); build/asm/main_8000043C.s.o(.rodata); build/asm/main_8000043C.s.o(.data); }
    .main_8000043C_bss (NOLOAD) : { build/asm/main_8000043C.s.o(.bss); }
    .main_800018C4 0x800018C4 : AT(0x000024C4) { FILL(0x00000000); build/asm/main_800018C4.s.o(.text); build/asm/main_800018C4.s.o(.rodata); build/asm/main_800018C4.s.o(.data); }
    .main_800018C4_bss (NOLOAD) : { build/asm/main_800018C4.s.o(.bss); }
    .main_8000CC8C 0x8000CC8C : AT(0x0000D88C) { build/asm/data/main_8000CC8C.bin.o(.data); }
    .main_8000F48C 0x8000F48C : AT(0x0001008C) { FILL(0x00000000); build/asm/main_8000F48C.s.o(.text); build/asm/main_8000F48C.s.o(.rodata); build/asm/main_8000F48C.s.o(.data); }
    .main_8000F48C_bss (NOLOAD) : { build/asm/main_8000F48C.s.o(.bss); }
    .main_8000F498 0x8000F498 : AT(0x00010098) { build/asm/data/main_8000F498.bin.o(.data); }
    .main_8000F530 0x8000F530 : AT(0x00010130) { FILL(0x00000000); build/asm/main_8000F530.s.o(.text); build/asm/main_8000F530.s.o(.rodata); build/asm/main_8000F530.s.o(.data); }
    .main_8000F530_bss (NOLOAD) : { build/asm/main_8000F530.s.o(.bss); }
    .main_8000F550 0x8000F550 : AT(0x00010150) { build/asm/data/main_8000F550.bin.o(.data); }
    .main_8001B9DC 0x8001B9DC : AT(0x0001C5DC) { FILL(0x00000000); build/asm/main_8001B9DC.s.o(.text); build/asm/main_8001B9DC.s.o(.rodata); build/asm/main_8001B9DC.s.o(.data); }
    .main_8001B9DC_bss (NOLOAD) : { build/asm/main_8001B9DC.s.o(.bss); }
    .main_8001B9E0 0x8001B9E0 : AT(0x0001C5E0) { build/asm/data/main_8001B9E0.bin.o(.data); }
    .main_8002D948 0x8002D948 : AT(0x0002E548) { FILL(0x00000000); build/asm/main_8002D948.s.o(.text); build/asm/main_8002D948.s.o(.rodata); build/asm/main_8002D948.s.o(.data); }
    .main_8002D948_bss (NOLOAD) : { build/asm/main_8002D948.s.o(.bss); }
    .main_8002D950 0x8002D950 : AT(0x0002E550) { build/asm/data/main_8002D950.bin.o(.data); }
    .main_80043DF8 0x80043DF8 : AT(0x000449F8) { FILL(0x00000000); build/asm/main_80043DF8.s.o(.text); build/asm/main_80043DF8.s.o(.rodata); build/asm/main_80043DF8.s.o(.data); }
    .main_80043DF8_bss (NOLOAD) : { build/asm/main_80043DF8.s.o(.bss); }
    .main_80043E00 0x80043E00 : AT(0x00044A00) { build/asm/data/main_80043E00.bin.o(.data); }
    .main_80046BD0 0x80046BD0 : AT(0x000477D0) { FILL(0x00000000); build/asm/main_80046BD0.s.o(.text); build/asm/main_80046BD0.s.o(.rodata); build/asm/main_80046BD0.s.o(.data); }
    .main_80046BD0_bss (NOLOAD) : { build/asm/main_80046BD0.s.o(.bss); }
    .main_80046BE8 0x80046BE8 : AT(0x000477E8) { build/asm/data/main_80046BE8.bin.o(.data); }
    .main_80051DE0 0x80051DE0 : AT(0x000529E0) { FILL(0x00000000); build/asm/main_80051DE0.s.o(.text); build/asm/main_80051DE0.s.o(.rodata); build/asm/main_80051DE0.s.o(.data); }
    .main_80051DE0_bss (NOLOAD) : { build/asm/main_80051DE0.s.o(.bss); }
    .main_80051DF0 0x80051DF0 : AT(0x000529F0) { build/asm/data/main_80051DF0.bin.o(.data); }
    .main_80052A74 0x80052A74 : AT(0x00053674) { FILL(0x00000000); build/asm/main_80052A74.s.o(.text); build/asm/main_80052A74.s.o(.rodata); build/asm/main_80052A74.s.o(.data); }
    .main_80052A74_bss (NOLOAD) : { build/asm/main_80052A74.s.o(.bss); }
    .main_80052A80 0x80052A80 : AT(0x00053680) { build/asm/data/main_80052A80.bin.o(.data); }
    .main_80059B78 0x80059B78 : AT(0x0005A778) { FILL(0x00000000); build/asm/main_80059B78.s.o(.text); build/asm/main_80059B78.s.o(.rodata); build/asm/main_80059B78.s.o(.data); }
    .main_80059B78_bss (NOLOAD) : { build/asm/main_80059B78.s.o(.bss); }
    .main_80059B7C 0x80059B7C : AT(0x0005A77C) { build/asm/data/main_80059B7C.bin.o(.data); }
    .main_8006C274 0x8006C274 : AT(0x0006CE74) { FILL(0x00000000); build/asm/main_8006C274.s.o(.text); build/asm/main_8006C274.s.o(.rodata); build/asm/main_8006C274.s.o(.data); }
    .main_8006C274_bss (NOLOAD) : { build/asm/main_8006C274.s.o(.bss); }
    .main_8006C3A4 0x8006C3A4 : AT(0x0006CFA4) { build/asm/data/main_8006C3A4.bin.o(.data); }
    .main_80072FE4 0x80072FE4 : AT(0x00073BE4) { FILL(0x00000000); build/asm/main_80072FE4.s.o(.text); build/asm/main_80072FE4.s.o(.rodata); build/asm/main_80072FE4.s.o(.data); }
    .main_80072FE4_bss (NOLOAD) : { build/asm/main_80072FE4.s.o(.bss); }
    .main_80073014 0x80073014 : AT(0x00073C14) { build/asm/data/main_80073014.bin.o(.data); }
    .main_8007CAA0 0x8007CAA0 : AT(0x0007D6A0) { FILL(0x00000000); build/asm/main_8007CAA0.s.o(.text); build/asm/main_8007CAA0.s.o(.rodata); build/asm/main_8007CAA0.s.o(.data); }
    .main_8007CAA0_bss (NOLOAD) : { build/asm/main_8007CAA0.s.o(.bss); }
    .main_8007CAD8 0x8007CAD8 : AT(0x0007D6D8) { build/asm/data/main_8007CAD8.bin.o(.data); }
    .main_8008075C 0x8008075C : AT(0x0008135C) { FILL(0x00000000); build/asm/main_8008075C.s.o(.text); build/asm/main_8008075C.s.o(.rodata); build/asm/main_8008075C.s.o(.data); }
    .main_8008075C_bss (NOLOAD) : { build/asm/main_8008075C.s.o(.bss); }
    .main_80080788 0x80080788 : AT(0x00081388) { build/asm/data/main_80080788.bin.o(.data); }
    .main_800837E0 0x800837E0 : AT(0x000843E0) { FILL(0x00000000); build/asm/main_800837E0.s.o(.text); build/asm/main_800837E0.s.o(.rodata); build/asm/main_800837E0.s.o(.data); }
    .main_800837E0_bss (NOLOAD) : { build/asm/main_800837E0.s.o(.bss); }
    .main_80083800 0x80083800 : AT(0x00084400) { build/asm/data/main_80083800.bin.o(.data); }
    .main_80085D34 0x80085D34 : AT(0x00086934) { FILL(0x00000000); build/asm/main_80085D34.s.o(.text); build/asm/main_80085D34.s.o(.rodata); build/asm/main_80085D34.s.o(.data); }
    .main_80085D34_bss (NOLOAD) : { build/asm/main_80085D34.s.o(.bss); }
    .main_80085D3C 0x80085D3C : AT(0x0008693C) { build/asm/data/main_80085D3C.bin.o(.data); }
    .main_800AD390 0x800AD390 : AT(0x000ADF90) { FILL(0x00000000); build/asm/main_800AD390.s.o(.text); build/asm/main_800AD390.s.o(.rodata); build/asm/main_800AD390.s.o(.data); }
    .main_800AD390_bss (NOLOAD) : { build/asm/main_800AD390.s.o(.bss); }
    .main_800AD3B0 0x800AD3B0 : AT(0x000ADFB0) { build/asm/data/main_800AD3B0.bin.o(.data); }
    .main_800DE388 0x800DE388 : AT(0x000DEF88) { FILL(0x00000000); build/asm/main_800DE388.s.o(.text); build/asm/main_800DE388.s.o(.rodata); build/asm/main_800DE388.s.o(.data); }
    .main_800DE388_bss (NOLOAD) : { build/asm/main_800DE388.s.o(.bss); }
    .main_800DE394 0x800DE394 : AT(0x000DEF94) { build/asm/data/main_800DE394.bin.o(.data); }
    .main_800FF72C 0x800FF72C : AT(0x0010032C) { FILL(0x00000000); build/asm/main_800FF72C.s.o(.text); build/asm/main_800FF72C.s.o(.rodata); build/asm/main_800FF72C.s.o(.data); }
    .main_800FF72C_bss (NOLOAD) : { build/asm/main_800FF72C.s.o(.bss); }
    .main_800FF73C 0x800FF73C : AT(0x0010033C) { build/asm/data/main_800FF73C.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
