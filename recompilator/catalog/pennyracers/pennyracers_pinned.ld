SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80025C00 0x80025C00 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80025C00.s.o(.text); build/asm/main_80025C00.s.o(.rodata); build/asm/main_80025C00.s.o(.data); }
    .main_80025C00_bss (NOLOAD) : { build/asm/main_80025C00.s.o(.bss); }
    .main_8003E644 0x8003E644 : AT(0x00019A44) { FILL(0x00000000); build/asm/main_8003E644.s.o(.text); build/asm/main_8003E644.s.o(.rodata); build/asm/main_8003E644.s.o(.data); }
    .main_8003E644_bss (NOLOAD) : { build/asm/main_8003E644.s.o(.bss); }
    .main_8003EA20 0x8003EA20 : AT(0x00019E20) { FILL(0x00000000); build/asm/main_8003EA20.s.o(.text); build/asm/main_8003EA20.s.o(.rodata); build/asm/main_8003EA20.s.o(.data); }
    .main_8003EA20_bss (NOLOAD) : { build/asm/main_8003EA20.s.o(.bss); }
    .main_800490B0 0x800490B0 : AT(0x000244B0) { build/asm/data/main_800490B0.bin.o(.data); }
    .main_800498B0 0x800498B0 : AT(0x00024CB0) { FILL(0x00000000); build/asm/main_800498B0.s.o(.text); build/asm/main_800498B0.s.o(.rodata); build/asm/main_800498B0.s.o(.data); }
    .main_800498B0_bss (NOLOAD) : { build/asm/main_800498B0.s.o(.bss); }
    .main_80049D00 0x80049D00 : AT(0x00025100) { build/asm/data/main_80049D00.bin.o(.data); }
    .main_80049D7C 0x80049D7C : AT(0x0002517C) { FILL(0x00000000); build/asm/main_80049D7C.s.o(.text); build/asm/main_80049D7C.s.o(.rodata); build/asm/main_80049D7C.s.o(.data); }
    .main_80049D7C_bss (NOLOAD) : { build/asm/main_80049D7C.s.o(.bss); }
    .main_8004A480 0x8004A480 : AT(0x00025880) { build/asm/data/main_8004A480.bin.o(.data); }
    .main_8004A4FC 0x8004A4FC : AT(0x000258FC) { build/asm/data/main_8004A4FC.bin.o(.data); }
    .main_80060F38 0x80060F38 : AT(0x0003C338) { FILL(0x00000000); build/asm/main_80060F38.s.o(.text); build/asm/main_80060F38.s.o(.rodata); build/asm/main_80060F38.s.o(.data); }
    .main_80060F38_bss (NOLOAD) : { build/asm/main_80060F38.s.o(.bss); }
    .main_8007E6C0 0x8007E6C0 : AT(0x00059AC0) { FILL(0x00000000); build/asm/main_8007E6C0.s.o(.text); build/asm/main_8007E6C0.s.o(.rodata); build/asm/main_8007E6C0.s.o(.data); }
    .main_8007E6C0_bss (NOLOAD) : { build/asm/main_8007E6C0.s.o(.bss); }
    .main_80080408 0x80080408 : AT(0x0005B808) { build/asm/data/main_80080408.bin.o(.data); }
    .main_800983AC 0x800983AC : AT(0x000737AC) { build/asm/data/main_800983AC.bin.o(.data); }
    .main_8009C714 0x8009C714 : AT(0x00077B14) { FILL(0x00000000); build/asm/main_8009C714.s.o(.text); build/asm/main_8009C714.s.o(.rodata); build/asm/main_8009C714.s.o(.data); }
    .main_8009C714_bss (NOLOAD) : { build/asm/main_8009C714.s.o(.bss); }
    .main_8009CB00 0x8009CB00 : AT(0x00077F00) { build/asm/data/main_8009CB00.bin.o(.data); }
    .main_8009DF6C 0x8009DF6C : AT(0x0007936C) { FILL(0x00000000); build/asm/main_8009DF6C.s.o(.text); build/asm/main_8009DF6C.s.o(.rodata); build/asm/main_8009DF6C.s.o(.data); }
    .main_8009DF6C_bss (NOLOAD) : { build/asm/main_8009DF6C.s.o(.bss); }
    .main_8009EB6C 0x8009EB6C : AT(0x00079F6C) { build/asm/data/main_8009EB6C.bin.o(.data); }
    .main_800A51EC 0x800A51EC : AT(0x000805EC) { FILL(0x00000000); build/asm/main_800A51EC.s.o(.text); build/asm/main_800A51EC.s.o(.rodata); build/asm/main_800A51EC.s.o(.data); }
    .main_800A51EC_bss (NOLOAD) : { build/asm/main_800A51EC.s.o(.bss); }
    .main_800A900C 0x800A900C : AT(0x0008440C) { build/asm/data/main_800A900C.bin.o(.data); }
    .main_800ADD80 0x800ADD80 : AT(0x00089180) { FILL(0x00000000); build/asm/main_800ADD80.s.o(.text); build/asm/main_800ADD80.s.o(.rodata); build/asm/main_800ADD80.s.o(.data); }
    .main_800ADD80_bss (NOLOAD) : { build/asm/main_800ADD80.s.o(.bss); }
    .main_800DE2E0 0x800DE2E0 : AT(0x000B96E0) { FILL(0x00000000); build/asm/main_800DE2E0.s.o(.text); build/asm/main_800DE2E0.s.o(.rodata); build/asm/main_800DE2E0.s.o(.data); }
    .main_800DE2E0_bss (NOLOAD) : { build/asm/main_800DE2E0.s.o(.bss); }
    .main_800DFD64 0x800DFD64 : AT(0x000BB164) { build/asm/data/main_800DFD64.bin.o(.data); }
    .main_800E0E7C 0x800E0E7C : AT(0x000BC27C) { FILL(0x00000000); build/asm/main_800E0E7C.s.o(.text); build/asm/main_800E0E7C.s.o(.rodata); build/asm/main_800E0E7C.s.o(.data); }
    .main_800E0E7C_bss (NOLOAD) : { build/asm/main_800E0E7C.s.o(.bss); }
    .main_800E358C 0x800E358C : AT(0x000BE98C) { FILL(0x00000000); build/asm/main_800E358C.s.o(.text); build/asm/main_800E358C.s.o(.rodata); build/asm/main_800E358C.s.o(.data); }
    .main_800E358C_bss (NOLOAD) : { build/asm/main_800E358C.s.o(.bss); }
    .main_800EBAF8 0x800EBAF8 : AT(0x000C6EF8) { build/asm/data/main_800EBAF8.bin.o(.data); }
    .main_800FF058 0x800FF058 : AT(0x000DA458) { FILL(0x00000000); build/asm/main_800FF058.s.o(.text); build/asm/main_800FF058.s.o(.rodata); build/asm/main_800FF058.s.o(.data); }
    .main_800FF058_bss (NOLOAD) : { build/asm/main_800FF058.s.o(.bss); }
    .main_800FF6E8 0x800FF6E8 : AT(0x000DAAE8) { build/asm/data/main_800FF6E8.bin.o(.data); }
    .main_80101004 0x80101004 : AT(0x000DC404) { FILL(0x00000000); build/asm/main_80101004.s.o(.text); build/asm/main_80101004.s.o(.rodata); build/asm/main_80101004.s.o(.data); }
    .main_80101004_bss (NOLOAD) : { build/asm/main_80101004.s.o(.bss); }
    .main_80101838 0x80101838 : AT(0x000DCC38) { build/asm/data/main_80101838.bin.o(.data); }
    .main_8010B808 0x8010B808 : AT(0x000E6C08) { FILL(0x00000000); build/asm/main_8010B808.s.o(.text); build/asm/main_8010B808.s.o(.rodata); build/asm/main_8010B808.s.o(.data); }
    .main_8010B808_bss (NOLOAD) : { build/asm/main_8010B808.s.o(.bss); }
    .main_80122E30 0x80122E30 : AT(0x000FE230) { FILL(0x00000000); build/asm/main_80122E30.s.o(.text); build/asm/main_80122E30.s.o(.rodata); build/asm/main_80122E30.s.o(.data); }
    .main_80122E30_bss (NOLOAD) : { build/asm/main_80122E30.s.o(.bss); }
    .main_80122E58 0x80122E58 : AT(0x000FE258) { build/asm/data/main_80122E58.bin.o(.data); }
    .main_80124574 0x80124574 : AT(0x000FF974) { FILL(0x00000000); build/asm/main_80124574.s.o(.text); build/asm/main_80124574.s.o(.rodata); build/asm/main_80124574.s.o(.data); }
    .main_80124574_bss (NOLOAD) : { build/asm/main_80124574.s.o(.bss); }
    .assets 0x80425C00 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
