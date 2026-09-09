SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000890 0x80000890 : AT(0x00001490) { FILL(0x00000000); build/asm/main_80000890.s.o(.text); build/asm/main_80000890.s.o(.rodata); build/asm/main_80000890.s.o(.data); }
    .main_80000890_bss (NOLOAD) : { build/asm/main_80000890.s.o(.bss); }
    .main_800D31E4 0x800D31E4 : AT(0x000D3DE4) { FILL(0x00000000); build/asm/main_800D31E4.s.o(.text); build/asm/main_800D31E4.s.o(.rodata); build/asm/main_800D31E4.s.o(.data); }
    .main_800D31E4_bss (NOLOAD) : { build/asm/main_800D31E4.s.o(.bss); }
    .main_800D35B0 0x800D35B0 : AT(0x000D41B0) { FILL(0x00000000); build/asm/main_800D35B0.s.o(.text); build/asm/main_800D35B0.s.o(.rodata); build/asm/main_800D35B0.s.o(.data); }
    .main_800D35B0_bss (NOLOAD) : { build/asm/main_800D35B0.s.o(.bss); }
    .main_800D99F0 0x800D99F0 : AT(0x000DA5F0) { build/asm/data/main_800D99F0.bin.o(.data); }
    .main_800DAB58 0x800DAB58 : AT(0x000DB758) { build/asm/data/main_800DAB58.bin.o(.data); }
    .main_800DE67C 0x800DE67C : AT(0x000DF27C) { FILL(0x00000000); build/asm/main_800DE67C.s.o(.text); build/asm/main_800DE67C.s.o(.rodata); build/asm/main_800DE67C.s.o(.data); }
    .main_800DE67C_bss (NOLOAD) : { build/asm/main_800DE67C.s.o(.bss); }
    .main_800DEE8C 0x800DEE8C : AT(0x000DFA8C) { build/asm/data/main_800DEE8C.bin.o(.data); }
    .main_800DF130 0x800DF130 : AT(0x000DFD30) { build/asm/data/main_800DF130.bin.o(.data); }
    .main_800DF194 0x800DF194 : AT(0x000DFD94) { FILL(0x00000000); build/asm/main_800DF194.s.o(.text); build/asm/main_800DF194.s.o(.rodata); build/asm/main_800DF194.s.o(.data); }
    .main_800DF194_bss (NOLOAD) : { build/asm/main_800DF194.s.o(.bss); }
    .main_800DF3D0 0x800DF3D0 : AT(0x000DFFD0) { FILL(0x00000000); build/asm/main_800DF3D0.s.o(.text); build/asm/main_800DF3D0.s.o(.rodata); build/asm/main_800DF3D0.s.o(.data); }
    .main_800DF3D0_bss (NOLOAD) : { build/asm/main_800DF3D0.s.o(.bss); }
    .main_800DF670 0x800DF670 : AT(0x000E0270) { FILL(0x00000000); build/asm/main_800DF670.s.o(.text); build/asm/main_800DF670.s.o(.rodata); build/asm/main_800DF670.s.o(.data); }
    .main_800DF670_bss (NOLOAD) : { build/asm/main_800DF670.s.o(.bss); }
    .main_800DF90C 0x800DF90C : AT(0x000E050C) { FILL(0x00000000); build/asm/main_800DF90C.s.o(.text); build/asm/main_800DF90C.s.o(.rodata); build/asm/main_800DF90C.s.o(.data); }
    .main_800DF90C_bss (NOLOAD) : { build/asm/main_800DF90C.s.o(.bss); }
    .main_800DFBA4 0x800DFBA4 : AT(0x000E07A4) { FILL(0x00000000); build/asm/main_800DFBA4.s.o(.text); build/asm/main_800DFBA4.s.o(.rodata); build/asm/main_800DFBA4.s.o(.data); }
    .main_800DFBA4_bss (NOLOAD) : { build/asm/main_800DFBA4.s.o(.bss); }
    .main_800DFD40 0x800DFD40 : AT(0x000E0940) { FILL(0x00000000); build/asm/main_800DFD40.s.o(.text); build/asm/main_800DFD40.s.o(.rodata); build/asm/main_800DFD40.s.o(.data); }
    .main_800DFD40_bss (NOLOAD) : { build/asm/main_800DFD40.s.o(.bss); }
    .main_800E4D3C 0x800E4D3C : AT(0x000E593C) { build/asm/data/main_800E4D3C.bin.o(.data); }
    .main_800E5B64 0x800E5B64 : AT(0x000E6764) { build/asm/data/main_800E5B64.bin.o(.data); }
    .main_800E6C40 0x800E6C40 : AT(0x000E7840) { build/asm/data/main_800E6C40.bin.o(.data); }
    .main_800E874C 0x800E874C : AT(0x000E934C) { FILL(0x00000000); build/asm/main_800E874C.s.o(.text); build/asm/main_800E874C.s.o(.rodata); build/asm/main_800E874C.s.o(.data); }
    .main_800E874C_bss (NOLOAD) : { build/asm/main_800E874C.s.o(.bss); }
    .main_800E9DB4 0x800E9DB4 : AT(0x000EA9B4) { FILL(0x00000000); build/asm/main_800E9DB4.s.o(.text); build/asm/main_800E9DB4.s.o(.rodata); build/asm/main_800E9DB4.s.o(.data); }
    .main_800E9DB4_bss (NOLOAD) : { build/asm/main_800E9DB4.s.o(.bss); }
    .main_800EA3E0 0x800EA3E0 : AT(0x000EAFE0) { FILL(0x00000000); build/asm/main_800EA3E0.s.o(.text); build/asm/main_800EA3E0.s.o(.rodata); build/asm/main_800EA3E0.s.o(.data); }
    .main_800EA3E0_bss (NOLOAD) : { build/asm/main_800EA3E0.s.o(.bss); }
    .main_800EABE0 0x800EABE0 : AT(0x000EB7E0) { FILL(0x00000000); build/asm/main_800EABE0.s.o(.text); build/asm/main_800EABE0.s.o(.rodata); build/asm/main_800EABE0.s.o(.data); }
    .main_800EABE0_bss (NOLOAD) : { build/asm/main_800EABE0.s.o(.bss); }
    .main_800EB3E0 0x800EB3E0 : AT(0x000EBFE0) { build/asm/data/main_800EB3E0.bin.o(.data); }
    .main_800EDC0C 0x800EDC0C : AT(0x000EE80C) { build/asm/data/main_800EDC0C.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
