SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80071000 0x80071000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80071000.s.o(.text); build/asm/main_80071000.s.o(.rodata); build/asm/main_80071000.s.o(.data); }
    .main_80071000_bss (NOLOAD) : { build/asm/main_80071000.s.o(.bss); }
    .main_80076000 0x80076000 : AT(0x00006000) { FILL(0x00000000); build/asm/main_80076000.s.o(.text); build/asm/main_80076000.s.o(.rodata); build/asm/main_80076000.s.o(.data); }
    .main_80076000_bss (NOLOAD) : { build/asm/main_80076000.s.o(.bss); }
    .main_800E1C00 0x800E1C00 : AT(0x00071C00) { build/asm/data/main_800E1C00.bin.o(.data); }
    .main_800E1D40 0x800E1D40 : AT(0x00071D40) { FILL(0x00000000); build/asm/main_800E1D40.s.o(.text); build/asm/main_800E1D40.s.o(.rodata); build/asm/main_800E1D40.s.o(.data); }
    .main_800E1D40_bss (NOLOAD) : { build/asm/main_800E1D40.s.o(.bss); }
    .main_8010DED4 0x8010DED4 : AT(0x0009DED4) { build/asm/data/main_8010DED4.bin.o(.data); }
    .main_80110480 0x80110480 : AT(0x000A0480) { FILL(0x00000000); build/asm/main_80110480.s.o(.text); build/asm/main_80110480.s.o(.rodata); build/asm/main_80110480.s.o(.data); }
    .main_80110480_bss (NOLOAD) : { build/asm/main_80110480.s.o(.bss); }
    .main_801254A0 0x801254A0 : AT(0x000B54A0) { build/asm/data/main_801254A0.bin.o(.data); }
    .main_8012814C 0x8012814C : AT(0x000B814C) { FILL(0x00000000); build/asm/main_8012814C.s.o(.text); build/asm/main_8012814C.s.o(.rodata); build/asm/main_8012814C.s.o(.data); }
    .main_8012814C_bss (NOLOAD) : { build/asm/main_8012814C.s.o(.bss); }
    .main_80128394 0x80128394 : AT(0x000B8394) { build/asm/data/main_80128394.bin.o(.data); }
    .main_80131074 0x80131074 : AT(0x000C1074) { FILL(0x00000000); build/asm/main_80131074.s.o(.text); build/asm/main_80131074.s.o(.rodata); build/asm/main_80131074.s.o(.data); }
    .main_80131074_bss (NOLOAD) : { build/asm/main_80131074.s.o(.bss); }
    .main_80131494 0x80131494 : AT(0x000C1494) { build/asm/data/main_80131494.bin.o(.data); }
    .main_801358F4 0x801358F4 : AT(0x000C58F4) { FILL(0x00000000); build/asm/main_801358F4.s.o(.text); build/asm/main_801358F4.s.o(.rodata); build/asm/main_801358F4.s.o(.data); }
    .main_801358F4_bss (NOLOAD) : { build/asm/main_801358F4.s.o(.bss); }
    .main_801379F8 0x801379F8 : AT(0x000C79F8) { build/asm/data/main_801379F8.bin.o(.data); }
    .main_801396D4 0x801396D4 : AT(0x000C96D4) { FILL(0x00000000); build/asm/main_801396D4.s.o(.text); build/asm/main_801396D4.s.o(.rodata); build/asm/main_801396D4.s.o(.data); }
    .main_801396D4_bss (NOLOAD) : { build/asm/main_801396D4.s.o(.bss); }
    .main_8013D434 0x8013D434 : AT(0x000CD434) { build/asm/data/main_8013D434.bin.o(.data); }
    .main_80150314 0x80150314 : AT(0x000E0314) { FILL(0x00000000); build/asm/main_80150314.s.o(.text); build/asm/main_80150314.s.o(.rodata); build/asm/main_80150314.s.o(.data); }
    .main_80150314_bss (NOLOAD) : { build/asm/main_80150314.s.o(.bss); }
    .main_8015032C 0x8015032C : AT(0x000E032C) { build/asm/data/main_8015032C.bin.o(.data); }
    .main_80150974 0x80150974 : AT(0x000E0974) { FILL(0x00000000); build/asm/main_80150974.s.o(.text); build/asm/main_80150974.s.o(.rodata); build/asm/main_80150974.s.o(.data); }
    .main_80150974_bss (NOLOAD) : { build/asm/main_80150974.s.o(.bss); }
    .main_801509F8 0x801509F8 : AT(0x000E09F8) { build/asm/data/main_801509F8.bin.o(.data); }
    .main_80152894 0x80152894 : AT(0x000E2894) { FILL(0x00000000); build/asm/main_80152894.s.o(.text); build/asm/main_80152894.s.o(.rodata); build/asm/main_80152894.s.o(.data); }
    .main_80152894_bss (NOLOAD) : { build/asm/main_80152894.s.o(.bss); }
    .main_801528E8 0x801528E8 : AT(0x000E28E8) { build/asm/data/main_801528E8.bin.o(.data); }
    .main_80168B48 0x80168B48 : AT(0x000F8B48) { FILL(0x00000000); build/asm/main_80168B48.s.o(.text); build/asm/main_80168B48.s.o(.rodata); build/asm/main_80168B48.s.o(.data); }
    .main_80168B48_bss (NOLOAD) : { build/asm/main_80168B48.s.o(.bss); }
    .main_80168C88 0x80168C88 : AT(0x000F8C88) { build/asm/data/main_80168C88.bin.o(.data); }
    .main_8016DCD8 0x8016DCD8 : AT(0x000FDCD8) { FILL(0x00000000); build/asm/main_8016DCD8.s.o(.text); build/asm/main_8016DCD8.s.o(.rodata); build/asm/main_8016DCD8.s.o(.data); }
    .main_8016DCD8_bss (NOLOAD) : { build/asm/main_8016DCD8.s.o(.bss); }
    .main_8016DF50 0x8016DF50 : AT(0x000FDF50) { build/asm/data/main_8016DF50.bin.o(.data); }
    .assets 0x80471000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
