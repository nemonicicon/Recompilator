SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80300000 0x80300000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80300000.s.o(.text); build/asm/main_80300000.s.o(.rodata); build/asm/main_80300000.s.o(.data); }
    .main_80300000_bss (NOLOAD) : { build/asm/main_80300000.s.o(.bss); }
    .main_80300040 0x80300040 : AT(0x00001040) { FILL(0x00000000); build/asm/main_80300040.s.o(.text); build/asm/main_80300040.s.o(.rodata); build/asm/main_80300040.s.o(.data); }
    .main_80300040_bss (NOLOAD) : { build/asm/main_80300040.s.o(.bss); }
    .main_80301C38 0x80301C38 : AT(0x00002C38) { build/asm/data/main_80301C38.bin.o(.data); }
    .main_80354AFC 0x80354AFC : AT(0x00055AFC) { FILL(0x00000000); build/asm/main_80354AFC.s.o(.text); build/asm/main_80354AFC.s.o(.rodata); build/asm/main_80354AFC.s.o(.data); }
    .main_80354AFC_bss (NOLOAD) : { build/asm/main_80354AFC.s.o(.bss); }
    .main_80354B14 0x80354B14 : AT(0x00055B14) { build/asm/data/main_80354B14.bin.o(.data); }
    .main_80358DE8 0x80358DE8 : AT(0x00059DE8) { FILL(0x00000000); build/asm/main_80358DE8.s.o(.text); build/asm/main_80358DE8.s.o(.rodata); build/asm/main_80358DE8.s.o(.data); }
    .main_80358DE8_bss (NOLOAD) : { build/asm/main_80358DE8.s.o(.bss); }
    .main_80358DF4 0x80358DF4 : AT(0x00059DF4) { build/asm/data/main_80358DF4.bin.o(.data); }
    .main_80362898 0x80362898 : AT(0x00063898) { FILL(0x00000000); build/asm/main_80362898.s.o(.text); build/asm/main_80362898.s.o(.rodata); build/asm/main_80362898.s.o(.data); }
    .main_80362898_bss (NOLOAD) : { build/asm/main_80362898.s.o(.bss); }
    .main_803628B0 0x803628B0 : AT(0x000638B0) { build/asm/data/main_803628B0.bin.o(.data); }
    .main_8036D188 0x8036D188 : AT(0x0006E188) { FILL(0x00000000); build/asm/main_8036D188.s.o(.text); build/asm/main_8036D188.s.o(.rodata); build/asm/main_8036D188.s.o(.data); }
    .main_8036D188_bss (NOLOAD) : { build/asm/main_8036D188.s.o(.bss); }
    .main_8036D18C 0x8036D18C : AT(0x0006E18C) { build/asm/data/main_8036D18C.bin.o(.data); }
    .main_80371594 0x80371594 : AT(0x00072594) { FILL(0x00000000); build/asm/main_80371594.s.o(.text); build/asm/main_80371594.s.o(.rodata); build/asm/main_80371594.s.o(.data); }
    .main_80371594_bss (NOLOAD) : { build/asm/main_80371594.s.o(.bss); }
    .main_803715B0 0x803715B0 : AT(0x000725B0) { build/asm/data/main_803715B0.bin.o(.data); }
    .main_8039F294 0x8039F294 : AT(0x000A0294) { FILL(0x00000000); build/asm/main_8039F294.s.o(.text); build/asm/main_8039F294.s.o(.rodata); build/asm/main_8039F294.s.o(.data); }
    .main_8039F294_bss (NOLOAD) : { build/asm/main_8039F294.s.o(.bss); }
    .main_8039F29C 0x8039F29C : AT(0x000A029C) { build/asm/data/main_8039F29C.bin.o(.data); }
    .main_803B54A8 0x803B54A8 : AT(0x000B64A8) { FILL(0x00000000); build/asm/main_803B54A8.s.o(.text); build/asm/main_803B54A8.s.o(.rodata); build/asm/main_803B54A8.s.o(.data); }
    .main_803B54A8_bss (NOLOAD) : { build/asm/main_803B54A8.s.o(.bss); }
    .main_803B54B0 0x803B54B0 : AT(0x000B64B0) { build/asm/data/main_803B54B0.bin.o(.data); }
    .main_803ED37C 0x803ED37C : AT(0x000EE37C) { FILL(0x00000000); build/asm/main_803ED37C.s.o(.text); build/asm/main_803ED37C.s.o(.rodata); build/asm/main_803ED37C.s.o(.data); }
    .main_803ED37C_bss (NOLOAD) : { build/asm/main_803ED37C.s.o(.bss); }
    .main_803ED384 0x803ED384 : AT(0x000EE384) { build/asm/data/main_803ED384.bin.o(.data); }
    .assets 0x80700000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
