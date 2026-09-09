SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_8006E074 0x8006E074 : AT(0x0006EC74) { FILL(0x00000000); build/asm/main_8006E074.s.o(.text); build/asm/main_8006E074.s.o(.rodata); build/asm/main_8006E074.s.o(.data); }
    .main_8006E074_bss (NOLOAD) : { build/asm/main_8006E074.s.o(.bss); }
    .main_8006E440 0x8006E440 : AT(0x0006F040) { FILL(0x00000000); build/asm/main_8006E440.s.o(.text); build/asm/main_8006E440.s.o(.rodata); build/asm/main_8006E440.s.o(.data); }
    .main_8006E440_bss (NOLOAD) : { build/asm/main_8006E440.s.o(.bss); }
    .main_80079758 0x80079758 : AT(0x0007A358) { FILL(0x00000000); build/asm/main_80079758.s.o(.text); build/asm/main_80079758.s.o(.rodata); build/asm/main_80079758.s.o(.data); }
    .main_80079758_bss (NOLOAD) : { build/asm/main_80079758.s.o(.bss); }
    .main_8007A79C 0x8007A79C : AT(0x0007B39C) { FILL(0x00000000); build/asm/data/main_8007A79C.data.s.o(.data); }
    .main_8007C710 0x8007C710 : AT(0x0007D310) { FILL(0x00000000); build/asm/main_8007C710.s.o(.text); build/asm/main_8007C710.s.o(.rodata); build/asm/main_8007C710.s.o(.data); }
    .main_8007C710_bss (NOLOAD) : { build/asm/main_8007C710.s.o(.bss); }
    .main_8007C940 0x8007C940 : AT(0x0007D540) { FILL(0x00000000); build/asm/data/main_8007C940.data.s.o(.data); }
    .main_8009DB80 0x8009DB80 : AT(0x0009E780) { FILL(0x00000000); build/asm/main_8009DB80.s.o(.text); build/asm/main_8009DB80.s.o(.rodata); build/asm/main_8009DB80.s.o(.data); }
    .main_8009DB80_bss (NOLOAD) : { build/asm/main_8009DB80.s.o(.bss); }
    .main_8009DCC0 0x8009DCC0 : AT(0x0009E8C0) { FILL(0x00000000); build/asm/main_8009DCC0.s.o(.text); build/asm/main_8009DCC0.s.o(.rodata); build/asm/main_8009DCC0.s.o(.data); }
    .main_8009DCC0_bss (NOLOAD) : { build/asm/main_8009DCC0.s.o(.bss); }
    .main_8009DE20 0x8009DE20 : AT(0x0009EA20) { FILL(0x00000000); build/asm/data/main_8009DE20.data.s.o(.data); }
    .main_8009DFB0 0x8009DFB0 : AT(0x0009EBB0) { FILL(0x00000000); build/asm/main_8009DFB0.s.o(.text); build/asm/main_8009DFB0.s.o(.rodata); build/asm/main_8009DFB0.s.o(.data); }
    .main_8009DFB0_bss (NOLOAD) : { build/asm/main_8009DFB0.s.o(.bss); }
    .main_800A25D0 0x800A25D0 : AT(0x000A31D0) { FILL(0x00000000); build/asm/data/main_800A25D0.data.s.o(.data); }
    .main_800A99D0 0x800A99D0 : AT(0x000AA5D0) { FILL(0x00000000); build/asm/main_800A99D0.s.o(.text); build/asm/main_800A99D0.s.o(.rodata); build/asm/main_800A99D0.s.o(.data); }
    .main_800A99D0_bss (NOLOAD) : { build/asm/main_800A99D0.s.o(.bss); }
    .main_800AA07C 0x800AA07C : AT(0x000AAC7C) { FILL(0x00000000); build/asm/main_800AA07C.s.o(.text); build/asm/main_800AA07C.s.o(.rodata); build/asm/main_800AA07C.s.o(.data); }
    .main_800AA07C_bss (NOLOAD) : { build/asm/main_800AA07C.s.o(.bss); }
    .main_800BE680 0x800BE680 : AT(0x000BF280) { FILL(0x00000000); build/asm/data/main_800BE680.data.s.o(.data); }
    .main_800BF2D0 0x800BF2D0 : AT(0x000BFED0) { FILL(0x00000000); build/asm/main_800BF2D0.s.o(.text); build/asm/main_800BF2D0.s.o(.rodata); build/asm/main_800BF2D0.s.o(.data); }
    .main_800BF2D0_bss (NOLOAD) : { build/asm/main_800BF2D0.s.o(.bss); }
    .main_800D3180 0x800D3180 : AT(0x000D3D80) { FILL(0x00000000); build/asm/main_800D3180.s.o(.text); build/asm/main_800D3180.s.o(.rodata); build/asm/main_800D3180.s.o(.data); }
    .main_800D3180_bss (NOLOAD) : { build/asm/main_800D3180.s.o(.bss); }
    .main_800D7278 0x800D7278 : AT(0x000D7E78) { FILL(0x00000000); build/asm/main_800D7278.s.o(.text); build/asm/main_800D7278.s.o(.rodata); build/asm/main_800D7278.s.o(.data); }
    .main_800D7278_bss (NOLOAD) : { build/asm/main_800D7278.s.o(.bss); }
    .main_800D85A0 0x800D85A0 : AT(0x000D91A0) { FILL(0x00000000); build/asm/data/main_800D85A0.data.s.o(.data); }
    .main_800D8D98 0x800D8D98 : AT(0x000D9998) { FILL(0x00000000); build/asm/main_800D8D98.s.o(.text); build/asm/main_800D8D98.s.o(.rodata); build/asm/main_800D8D98.s.o(.data); }
    .main_800D8D98_bss (NOLOAD) : { build/asm/main_800D8D98.s.o(.bss); }
    .main_800DD3A8 0x800DD3A8 : AT(0x000DDFA8) { FILL(0x00000000); build/asm/main_800DD3A8.s.o(.text); build/asm/main_800DD3A8.s.o(.rodata); build/asm/main_800DD3A8.s.o(.data); }
    .main_800DD3A8_bss (NOLOAD) : { build/asm/main_800DD3A8.s.o(.bss); }
    .main_800DDCFC 0x800DDCFC : AT(0x000DE8FC) { FILL(0x00000000); build/asm/main_800DDCFC.s.o(.text); build/asm/main_800DDCFC.s.o(.rodata); build/asm/main_800DDCFC.s.o(.data); }
    .main_800DDCFC_bss (NOLOAD) : { build/asm/main_800DDCFC.s.o(.bss); }
    .main_800E0120 0x800E0120 : AT(0x000E0D20) { FILL(0x00000000); build/asm/main_800E0120.s.o(.text); build/asm/main_800E0120.s.o(.rodata); build/asm/main_800E0120.s.o(.data); }
    .main_800E0120_bss (NOLOAD) : { build/asm/main_800E0120.s.o(.bss); }
    .main_800E1CD0 0x800E1CD0 : AT(0x000E28D0) { FILL(0x00000000); build/asm/data/main_800E1CD0.data.s.o(.data); }
    .main_800E35B0 0x800E35B0 : AT(0x000E41B0) { FILL(0x00000000); build/asm/main_800E35B0.s.o(.text); build/asm/main_800E35B0.s.o(.rodata); build/asm/main_800E35B0.s.o(.data); }
    .main_800E35B0_bss (NOLOAD) : { build/asm/main_800E35B0.s.o(.bss); }
    .main_800E3B34 0x800E3B34 : AT(0x000E4734) { FILL(0x00000000); build/asm/main_800E3B34.s.o(.text); build/asm/main_800E3B34.s.o(.rodata); build/asm/main_800E3B34.s.o(.data); }
    .main_800E3B34_bss (NOLOAD) : { build/asm/main_800E3B34.s.o(.bss); }
    .main_800E6F38 0x800E6F38 : AT(0x000E7B38) { FILL(0x00000000); build/asm/main_800E6F38.s.o(.text); build/asm/main_800E6F38.s.o(.rodata); build/asm/main_800E6F38.s.o(.data); }
    .main_800E6F38_bss (NOLOAD) : { build/asm/main_800E6F38.s.o(.bss); }
    .main_800E8FA8 0x800E8FA8 : AT(0x000E9BA8) { FILL(0x00000000); build/asm/main_800E8FA8.s.o(.text); build/asm/main_800E8FA8.s.o(.rodata); build/asm/main_800E8FA8.s.o(.data); }
    .main_800E8FA8_bss (NOLOAD) : { build/asm/main_800E8FA8.s.o(.bss); }
    .main_800EA3D8 0x800EA3D8 : AT(0x000EAFD8) { FILL(0x00000000); build/asm/main_800EA3D8.s.o(.text); build/asm/main_800EA3D8.s.o(.rodata); build/asm/main_800EA3D8.s.o(.data); }
    .main_800EA3D8_bss (NOLOAD) : { build/asm/main_800EA3D8.s.o(.bss); }
    .main_800F2FD0 0x800F2FD0 : AT(0x000F3BD0) { FILL(0x00000000); build/asm/main_800F2FD0.s.o(.text); build/asm/main_800F2FD0.s.o(.rodata); build/asm/main_800F2FD0.s.o(.data); }
    .main_800F2FD0_bss (NOLOAD) : { build/asm/main_800F2FD0.s.o(.bss); }
    .main_800F6A28 0x800F6A28 : AT(0x000F7628) { FILL(0x00000000); build/asm/main_800F6A28.s.o(.text); build/asm/main_800F6A28.s.o(.rodata); build/asm/main_800F6A28.s.o(.data); }
    .main_800F6A28_bss (NOLOAD) : { build/asm/main_800F6A28.s.o(.bss); }
    .main_800F77B0 0x800F77B0 : AT(0x000F83B0) { FILL(0x00000000); build/asm/data/main_800F77B0.data.s.o(.data); }
    .main_800F8178 0x800F8178 : AT(0x000F8D78) { FILL(0x00000000); build/asm/main_800F8178.s.o(.text); build/asm/main_800F8178.s.o(.rodata); build/asm/main_800F8178.s.o(.data); }
    .main_800F8178_bss (NOLOAD) : { build/asm/main_800F8178.s.o(.bss); }
    .main_800F8864 0x800F8864 : AT(0x000F9464) { FILL(0x00000000); build/asm/data/main_800F8864.data.s.o(.data); }
    .main_800F8D8C 0x800F8D8C : AT(0x000F998C) { FILL(0x00000000); build/asm/main_800F8D8C.s.o(.text); build/asm/main_800F8D8C.s.o(.rodata); build/asm/main_800F8D8C.s.o(.data); }
    .main_800F8D8C_bss (NOLOAD) : { build/asm/main_800F8D8C.s.o(.bss); }
    .main_800F9B30 0x800F9B30 : AT(0x000FA730) { FILL(0x00000000); build/asm/data/main_800F9B30.data.s.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
