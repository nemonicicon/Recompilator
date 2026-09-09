SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800311A4 0x800311A4 : AT(0x00031DA4) { FILL(0x00000000); build/asm/main_800311A4.s.o(.text); build/asm/main_800311A4.s.o(.rodata); build/asm/main_800311A4.s.o(.data); }
    .main_800311A4_bss (NOLOAD) : { build/asm/main_800311A4.s.o(.bss); }
    .main_80031570 0x80031570 : AT(0x00032170) { FILL(0x00000000); build/asm/main_80031570.s.o(.text); build/asm/main_80031570.s.o(.rodata); build/asm/main_80031570.s.o(.data); }
    .main_80031570_bss (NOLOAD) : { build/asm/main_80031570.s.o(.bss); }
    .main_8003B514 0x8003B514 : AT(0x0003C114) { FILL(0x00000000); build/asm/main_8003B514.s.o(.text); build/asm/main_8003B514.s.o(.rodata); build/asm/main_8003B514.s.o(.data); }
    .main_8003B514_bss (NOLOAD) : { build/asm/main_8003B514.s.o(.bss); }
    .main_8003CB8C 0x8003CB8C : AT(0x0003D78C) { FILL(0x00000000); build/asm/main_8003CB8C.s.o(.text); build/asm/main_8003CB8C.s.o(.rodata); build/asm/main_8003CB8C.s.o(.data); }
    .main_8003CB8C_bss (NOLOAD) : { build/asm/main_8003CB8C.s.o(.bss); }
    .main_8003D6A4 0x8003D6A4 : AT(0x0003E2A4) { build/asm/data/main_8003D6A4.bin.o(.data); }
    .main_8003DF14 0x8003DF14 : AT(0x0003EB14) { FILL(0x00000000); build/asm/main_8003DF14.s.o(.text); build/asm/main_8003DF14.s.o(.rodata); build/asm/main_8003DF14.s.o(.data); }
    .main_8003DF14_bss (NOLOAD) : { build/asm/main_8003DF14.s.o(.bss); }
    .main_8003FCE0 0x8003FCE0 : AT(0x000408E0) { FILL(0x00000000); build/asm/main_8003FCE0.s.o(.text); build/asm/main_8003FCE0.s.o(.rodata); build/asm/main_8003FCE0.s.o(.data); }
    .main_8003FCE0_bss (NOLOAD) : { build/asm/main_8003FCE0.s.o(.bss); }
    .main_80040C98 0x80040C98 : AT(0x00041898) { FILL(0x00000000); build/asm/main_80040C98.s.o(.text); build/asm/main_80040C98.s.o(.rodata); build/asm/main_80040C98.s.o(.data); }
    .main_80040C98_bss (NOLOAD) : { build/asm/main_80040C98.s.o(.bss); }
    .main_80040F20 0x80040F20 : AT(0x00041B20) { FILL(0x00000000); build/asm/main_80040F20.s.o(.text); build/asm/main_80040F20.s.o(.rodata); build/asm/main_80040F20.s.o(.data); }
    .main_80040F20_bss (NOLOAD) : { build/asm/main_80040F20.s.o(.bss); }
    .main_800411A8 0x800411A8 : AT(0x00041DA8) { build/asm/data/main_800411A8.bin.o(.data); }
    .main_80058028 0x80058028 : AT(0x00058C28) { build/asm/data/main_80058028.bin.o(.data); }
    .main_800A1980 0x800A1980 : AT(0x000A2580) { FILL(0x00000000); build/asm/main_800A1980.s.o(.text); build/asm/main_800A1980.s.o(.rodata); build/asm/main_800A1980.s.o(.data); }
    .main_800A1980_bss (NOLOAD) : { build/asm/main_800A1980.s.o(.bss); }
    .main_800A2B18 0x800A2B18 : AT(0x000A3718) { FILL(0x00000000); build/asm/main_800A2B18.s.o(.text); build/asm/main_800A2B18.s.o(.rodata); build/asm/main_800A2B18.s.o(.data); }
    .main_800A2B18_bss (NOLOAD) : { build/asm/main_800A2B18.s.o(.bss); }
    .main_800A3040 0x800A3040 : AT(0x000A3C40) { build/asm/data/main_800A3040.bin.o(.data); }
    .main_800A8B28 0x800A8B28 : AT(0x000A9728) { FILL(0x00000000); build/asm/main_800A8B28.s.o(.text); build/asm/main_800A8B28.s.o(.rodata); build/asm/main_800A8B28.s.o(.data); }
    .main_800A8B28_bss (NOLOAD) : { build/asm/main_800A8B28.s.o(.bss); }
    .main_800A939C 0x800A939C : AT(0x000A9F9C) { build/asm/data/main_800A939C.bin.o(.data); }
    .main_800A9754 0x800A9754 : AT(0x000AA354) { FILL(0x00000000); build/asm/main_800A9754.s.o(.text); build/asm/main_800A9754.s.o(.rodata); build/asm/main_800A9754.s.o(.data); }
    .main_800A9754_bss (NOLOAD) : { build/asm/main_800A9754.s.o(.bss); }
    .main_800A97A8 0x800A97A8 : AT(0x000AA3A8) { build/asm/data/main_800A97A8.bin.o(.data); }
    .main_800AB53C 0x800AB53C : AT(0x000AC13C) { FILL(0x00000000); build/asm/main_800AB53C.s.o(.text); build/asm/main_800AB53C.s.o(.rodata); build/asm/main_800AB53C.s.o(.data); }
    .main_800AB53C_bss (NOLOAD) : { build/asm/main_800AB53C.s.o(.bss); }
    .main_800AB62C 0x800AB62C : AT(0x000AC22C) { build/asm/data/main_800AB62C.bin.o(.data); }
    .main_800AB7E4 0x800AB7E4 : AT(0x000AC3E4) { FILL(0x00000000); build/asm/main_800AB7E4.s.o(.text); build/asm/main_800AB7E4.s.o(.rodata); build/asm/main_800AB7E4.s.o(.data); }
    .main_800AB7E4_bss (NOLOAD) : { build/asm/main_800AB7E4.s.o(.bss); }
    .main_800CB4E0 0x800CB4E0 : AT(0x000CC0E0) { FILL(0x00000000); build/asm/main_800CB4E0.s.o(.text); build/asm/main_800CB4E0.s.o(.rodata); build/asm/main_800CB4E0.s.o(.data); }
    .main_800CB4E0_bss (NOLOAD) : { build/asm/main_800CB4E0.s.o(.bss); }
    .main_800D6490 0x800D6490 : AT(0x000D7090) { FILL(0x00000000); build/asm/main_800D6490.s.o(.text); build/asm/main_800D6490.s.o(.rodata); build/asm/main_800D6490.s.o(.data); }
    .main_800D6490_bss (NOLOAD) : { build/asm/main_800D6490.s.o(.bss); }
    .main_800E9CE8 0x800E9CE8 : AT(0x000EA8E8) { FILL(0x00000000); build/asm/main_800E9CE8.s.o(.text); build/asm/main_800E9CE8.s.o(.rodata); build/asm/main_800E9CE8.s.o(.data); }
    .main_800E9CE8_bss (NOLOAD) : { build/asm/main_800E9CE8.s.o(.bss); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
