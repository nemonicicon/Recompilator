SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000F90 0x80000F90 : AT(0x00001B90) { build/asm/data/main_80000F90.bin.o(.data); }
    .main_80001150 0x80001150 : AT(0x00001D50) { FILL(0x00000000); build/asm/main_80001150.s.o(.text); build/asm/main_80001150.s.o(.rodata); build/asm/main_80001150.s.o(.data); }
    .main_80001150_bss (NOLOAD) : { build/asm/main_80001150.s.o(.bss); }
    .main_80003D28 0x80003D28 : AT(0x00004928) { build/asm/data/main_80003D28.bin.o(.data); }
    .main_800045A0 0x800045A0 : AT(0x000051A0) { FILL(0x00000000); build/asm/main_800045A0.s.o(.text); build/asm/main_800045A0.s.o(.rodata); build/asm/main_800045A0.s.o(.data); }
    .main_800045A0_bss (NOLOAD) : { build/asm/main_800045A0.s.o(.bss); }
    .main_800054B0 0x800054B0 : AT(0x000060B0) { build/asm/data/main_800054B0.bin.o(.data); }
    .main_8000587C 0x8000587C : AT(0x0000647C) { FILL(0x00000000); build/asm/main_8000587C.s.o(.text); build/asm/main_8000587C.s.o(.rodata); build/asm/main_8000587C.s.o(.data); }
    .main_8000587C_bss (NOLOAD) : { build/asm/main_8000587C.s.o(.bss); }
    .main_80005AD4 0x80005AD4 : AT(0x000066D4) { build/asm/data/main_80005AD4.bin.o(.data); }
    .main_800061FC 0x800061FC : AT(0x00006DFC) { FILL(0x00000000); build/asm/main_800061FC.s.o(.text); build/asm/main_800061FC.s.o(.rodata); build/asm/main_800061FC.s.o(.data); }
    .main_800061FC_bss (NOLOAD) : { build/asm/main_800061FC.s.o(.bss); }
    .main_80006260 0x80006260 : AT(0x00006E60) { build/asm/data/main_80006260.bin.o(.data); }
    .main_800063F0 0x800063F0 : AT(0x00006FF0) { FILL(0x00000000); build/asm/main_800063F0.s.o(.text); build/asm/main_800063F0.s.o(.rodata); build/asm/main_800063F0.s.o(.data); }
    .main_800063F0_bss (NOLOAD) : { build/asm/main_800063F0.s.o(.bss); }
    .main_80038678 0x80038678 : AT(0x00039278) { build/asm/data/main_80038678.bin.o(.data); }
    .main_80038DD8 0x80038DD8 : AT(0x000399D8) { FILL(0x00000000); build/asm/main_80038DD8.s.o(.text); build/asm/main_80038DD8.s.o(.rodata); build/asm/main_80038DD8.s.o(.data); }
    .main_80038DD8_bss (NOLOAD) : { build/asm/main_80038DD8.s.o(.bss); }
    .main_80039090 0x80039090 : AT(0x00039C90) { build/asm/data/main_80039090.bin.o(.data); }
    .main_80039690 0x80039690 : AT(0x0003A290) { FILL(0x00000000); build/asm/main_80039690.s.o(.text); build/asm/main_80039690.s.o(.rodata); build/asm/main_80039690.s.o(.data); }
    .main_80039690_bss (NOLOAD) : { build/asm/main_80039690.s.o(.bss); }
    .main_8003A880 0x8003A880 : AT(0x0003B480) { build/asm/data/main_8003A880.bin.o(.data); }
    .main_8003E840 0x8003E840 : AT(0x0003F440) { FILL(0x00000000); build/asm/main_8003E840.s.o(.text); build/asm/main_8003E840.s.o(.rodata); build/asm/main_8003E840.s.o(.data); }
    .main_8003E840_bss (NOLOAD) : { build/asm/main_8003E840.s.o(.bss); }
    .main_8003EA30 0x8003EA30 : AT(0x0003F630) { FILL(0x00000000); build/asm/main_8003EA30.s.o(.text); build/asm/main_8003EA30.s.o(.rodata); build/asm/main_8003EA30.s.o(.data); }
    .main_8003EA30_bss (NOLOAD) : { build/asm/main_8003EA30.s.o(.bss); }
    .main_8003EE6C 0x8003EE6C : AT(0x0003FA6C) { FILL(0x00000000); build/asm/main_8003EE6C.s.o(.text); build/asm/main_8003EE6C.s.o(.rodata); build/asm/main_8003EE6C.s.o(.data); }
    .main_8003EE6C_bss (NOLOAD) : { build/asm/main_8003EE6C.s.o(.bss); }
    .main_8003F15C 0x8003F15C : AT(0x0003FD5C) { FILL(0x00000000); build/asm/main_8003F15C.s.o(.text); build/asm/main_8003F15C.s.o(.rodata); build/asm/main_8003F15C.s.o(.data); }
    .main_8003F15C_bss (NOLOAD) : { build/asm/main_8003F15C.s.o(.bss); }
    .main_8003F674 0x8003F674 : AT(0x00040274) { FILL(0x00000000); build/asm/main_8003F674.s.o(.text); build/asm/main_8003F674.s.o(.rodata); build/asm/main_8003F674.s.o(.data); }
    .main_8003F674_bss (NOLOAD) : { build/asm/main_8003F674.s.o(.bss); }
    .main_8003F8D0 0x8003F8D0 : AT(0x000404D0) { FILL(0x00000000); build/asm/main_8003F8D0.s.o(.text); build/asm/main_8003F8D0.s.o(.rodata); build/asm/main_8003F8D0.s.o(.data); }
    .main_8003F8D0_bss (NOLOAD) : { build/asm/main_8003F8D0.s.o(.bss); }
    .main_8003FEA0 0x8003FEA0 : AT(0x00040AA0) { FILL(0x00000000); build/asm/main_8003FEA0.s.o(.text); build/asm/main_8003FEA0.s.o(.rodata); build/asm/main_8003FEA0.s.o(.data); }
    .main_8003FEA0_bss (NOLOAD) : { build/asm/main_8003FEA0.s.o(.bss); }
    .main_800414B4 0x800414B4 : AT(0x000420B4) { FILL(0x00000000); build/asm/main_800414B4.s.o(.text); build/asm/main_800414B4.s.o(.rodata); build/asm/main_800414B4.s.o(.data); }
    .main_800414B4_bss (NOLOAD) : { build/asm/main_800414B4.s.o(.bss); }
    .main_80041C80 0x80041C80 : AT(0x00042880) { FILL(0x00000000); build/asm/main_80041C80.s.o(.text); build/asm/main_80041C80.s.o(.rodata); build/asm/main_80041C80.s.o(.data); }
    .main_80041C80_bss (NOLOAD) : { build/asm/main_80041C80.s.o(.bss); }
    .main_80045B40 0x80045B40 : AT(0x00046740) { FILL(0x00000000); build/asm/main_80045B40.s.o(.text); build/asm/main_80045B40.s.o(.rodata); build/asm/main_80045B40.s.o(.data); }
    .main_80045B40_bss (NOLOAD) : { build/asm/main_80045B40.s.o(.bss); }
    .main_80046730 0x80046730 : AT(0x00047330) { FILL(0x00000000); build/asm/main_80046730.s.o(.text); build/asm/main_80046730.s.o(.rodata); build/asm/main_80046730.s.o(.data); }
    .main_80046730_bss (NOLOAD) : { build/asm/main_80046730.s.o(.bss); }
    .main_800471E0 0x800471E0 : AT(0x00047DE0) { FILL(0x00000000); build/asm/main_800471E0.s.o(.text); build/asm/main_800471E0.s.o(.rodata); build/asm/main_800471E0.s.o(.data); }
    .main_800471E0_bss (NOLOAD) : { build/asm/main_800471E0.s.o(.bss); }
    .main_80047520 0x80047520 : AT(0x00048120) { FILL(0x00000000); build/asm/main_80047520.s.o(.text); build/asm/main_80047520.s.o(.rodata); build/asm/main_80047520.s.o(.data); }
    .main_80047520_bss (NOLOAD) : { build/asm/main_80047520.s.o(.bss); }
    .main_800476D0 0x800476D0 : AT(0x000482D0) { FILL(0x00000000); build/asm/main_800476D0.s.o(.text); build/asm/main_800476D0.s.o(.rodata); build/asm/main_800476D0.s.o(.data); }
    .main_800476D0_bss (NOLOAD) : { build/asm/main_800476D0.s.o(.bss); }
    .main_80047750 0x80047750 : AT(0x00048350) { FILL(0x00000000); build/asm/main_80047750.s.o(.text); build/asm/main_80047750.s.o(.rodata); build/asm/main_80047750.s.o(.data); }
    .main_80047750_bss (NOLOAD) : { build/asm/main_80047750.s.o(.bss); }
    .main_80047840 0x80047840 : AT(0x00048440) { FILL(0x00000000); build/asm/main_80047840.s.o(.text); build/asm/main_80047840.s.o(.rodata); build/asm/main_80047840.s.o(.data); }
    .main_80047840_bss (NOLOAD) : { build/asm/main_80047840.s.o(.bss); }
    .main_80047A10 0x80047A10 : AT(0x00048610) { FILL(0x00000000); build/asm/main_80047A10.s.o(.text); build/asm/main_80047A10.s.o(.rodata); build/asm/main_80047A10.s.o(.data); }
    .main_80047A10_bss (NOLOAD) : { build/asm/main_80047A10.s.o(.bss); }
    .main_80048590 0x80048590 : AT(0x00049190) { FILL(0x00000000); build/asm/main_80048590.s.o(.text); build/asm/main_80048590.s.o(.rodata); build/asm/main_80048590.s.o(.data); }
    .main_80048590_bss (NOLOAD) : { build/asm/main_80048590.s.o(.bss); }
    .main_80048640 0x80048640 : AT(0x00049240) { FILL(0x00000000); build/asm/main_80048640.s.o(.text); build/asm/main_80048640.s.o(.rodata); build/asm/main_80048640.s.o(.data); }
    .main_80048640_bss (NOLOAD) : { build/asm/main_80048640.s.o(.bss); }
    .main_800487A0 0x800487A0 : AT(0x000493A0) { FILL(0x00000000); build/asm/main_800487A0.s.o(.text); build/asm/main_800487A0.s.o(.rodata); build/asm/main_800487A0.s.o(.data); }
    .main_800487A0_bss (NOLOAD) : { build/asm/main_800487A0.s.o(.bss); }
    .main_80048DC0 0x80048DC0 : AT(0x000499C0) { FILL(0x00000000); build/asm/main_80048DC0.s.o(.text); build/asm/main_80048DC0.s.o(.rodata); build/asm/main_80048DC0.s.o(.data); }
    .main_80048DC0_bss (NOLOAD) : { build/asm/main_80048DC0.s.o(.bss); }
    .main_80049310 0x80049310 : AT(0x00049F10) { FILL(0x00000000); build/asm/main_80049310.s.o(.text); build/asm/main_80049310.s.o(.rodata); build/asm/main_80049310.s.o(.data); }
    .main_80049310_bss (NOLOAD) : { build/asm/main_80049310.s.o(.bss); }
    .main_800494B0 0x800494B0 : AT(0x0004A0B0) { FILL(0x00000000); build/asm/main_800494B0.s.o(.text); build/asm/main_800494B0.s.o(.rodata); build/asm/main_800494B0.s.o(.data); }
    .main_800494B0_bss (NOLOAD) : { build/asm/main_800494B0.s.o(.bss); }
    .main_800496C0 0x800496C0 : AT(0x0004A2C0) { FILL(0x00000000); build/asm/main_800496C0.s.o(.text); build/asm/main_800496C0.s.o(.rodata); build/asm/main_800496C0.s.o(.data); }
    .main_800496C0_bss (NOLOAD) : { build/asm/main_800496C0.s.o(.bss); }
    .main_80049AD0 0x80049AD0 : AT(0x0004A6D0) { FILL(0x00000000); build/asm/main_80049AD0.s.o(.text); build/asm/main_80049AD0.s.o(.rodata); build/asm/main_80049AD0.s.o(.data); }
    .main_80049AD0_bss (NOLOAD) : { build/asm/main_80049AD0.s.o(.bss); }
    .main_8004B680 0x8004B680 : AT(0x0004C280) { build/asm/data/main_8004B680.bin.o(.data); }
    .main_8004F88C 0x8004F88C : AT(0x0005048C) { FILL(0x00000000); build/asm/main_8004F88C.s.o(.text); build/asm/main_8004F88C.s.o(.rodata); build/asm/main_8004F88C.s.o(.data); }
    .main_8004F88C_bss (NOLOAD) : { build/asm/main_8004F88C.s.o(.bss); }
    .main_8004FC4C 0x8004FC4C : AT(0x0005084C) { build/asm/data/main_8004FC4C.bin.o(.data); }
    .main_8004FF94 0x8004FF94 : AT(0x00050B94) { FILL(0x00000000); build/asm/main_8004FF94.s.o(.text); build/asm/main_8004FF94.s.o(.rodata); build/asm/main_8004FF94.s.o(.data); }
    .main_8004FF94_bss (NOLOAD) : { build/asm/main_8004FF94.s.o(.bss); }
    .main_80050024 0x80050024 : AT(0x00050C24) { build/asm/data/main_80050024.bin.o(.data); }
    .main_800C2FFC 0x800C2FFC : AT(0x000C3BFC) { build/asm/data/main_800C2FFC.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
