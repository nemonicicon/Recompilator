SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80003890 0x80003890 : AT(0x00004490) { build/asm/data/main_80003890.bin.o(.data); }
    .main_80004F64 0x80004F64 : AT(0x00005B64) { build/asm/data/main_80004F64.bin.o(.data); }
    .main_80008C50 0x80008C50 : AT(0x00009850) { FILL(0x00000000); build/asm/main_80008C50.s.o(.text); build/asm/main_80008C50.s.o(.rodata); build/asm/main_80008C50.s.o(.data); }
    .main_80008C50_bss (NOLOAD) : { build/asm/main_80008C50.s.o(.bss); }
    .main_80087CC0 0x80087CC0 : AT(0x000888C0) { build/asm/data/main_80087CC0.bin.o(.data); }
    .main_80089010 0x80089010 : AT(0x00089C10) { FILL(0x00000000); build/asm/main_80089010.s.o(.text); build/asm/main_80089010.s.o(.rodata); build/asm/main_80089010.s.o(.data); }
    .main_80089010_bss (NOLOAD) : { build/asm/main_80089010.s.o(.bss); }
    .main_80089C5C 0x80089C5C : AT(0x0008A85C) { build/asm/data/main_80089C5C.bin.o(.data); }
    .main_8008C64C 0x8008C64C : AT(0x0008D24C) { FILL(0x00000000); build/asm/main_8008C64C.s.o(.text); build/asm/main_8008C64C.s.o(.rodata); build/asm/main_8008C64C.s.o(.data); }
    .main_8008C64C_bss (NOLOAD) : { build/asm/main_8008C64C.s.o(.bss); }
    .main_8008C9E4 0x8008C9E4 : AT(0x0008D5E4) { build/asm/data/main_8008C9E4.bin.o(.data); }
    .main_8008D49C 0x8008D49C : AT(0x0008E09C) { FILL(0x00000000); build/asm/main_8008D49C.s.o(.text); build/asm/main_8008D49C.s.o(.rodata); build/asm/main_8008D49C.s.o(.data); }
    .main_8008D49C_bss (NOLOAD) : { build/asm/main_8008D49C.s.o(.bss); }
    .main_8008DB80 0x8008DB80 : AT(0x0008E780) { build/asm/data/main_8008DB80.bin.o(.data); }
    .main_8008E64C 0x8008E64C : AT(0x0008F24C) { FILL(0x00000000); build/asm/main_8008E64C.s.o(.text); build/asm/main_8008E64C.s.o(.rodata); build/asm/main_8008E64C.s.o(.data); }
    .main_8008E64C_bss (NOLOAD) : { build/asm/main_8008E64C.s.o(.bss); }
    .main_80090850 0x80090850 : AT(0x00091450) { build/asm/data/main_80090850.bin.o(.data); }
    .main_80092B80 0x80092B80 : AT(0x00093780) { FILL(0x00000000); build/asm/main_80092B80.s.o(.text); build/asm/main_80092B80.s.o(.rodata); build/asm/main_80092B80.s.o(.data); }
    .main_80092B80_bss (NOLOAD) : { build/asm/main_80092B80.s.o(.bss); }
    .main_800932B8 0x800932B8 : AT(0x00093EB8) { build/asm/data/main_800932B8.bin.o(.data); }
    .main_800934E8 0x800934E8 : AT(0x000940E8) { FILL(0x00000000); build/asm/main_800934E8.s.o(.text); build/asm/main_800934E8.s.o(.rodata); build/asm/main_800934E8.s.o(.data); }
    .main_800934E8_bss (NOLOAD) : { build/asm/main_800934E8.s.o(.bss); }
    .main_8009385C 0x8009385C : AT(0x0009445C) { build/asm/data/main_8009385C.bin.o(.data); }
    .main_80094ABC 0x80094ABC : AT(0x000956BC) { FILL(0x00000000); build/asm/main_80094ABC.s.o(.text); build/asm/main_80094ABC.s.o(.rodata); build/asm/main_80094ABC.s.o(.data); }
    .main_80094ABC_bss (NOLOAD) : { build/asm/main_80094ABC.s.o(.bss); }
    .main_80097174 0x80097174 : AT(0x00097D74) { build/asm/data/main_80097174.bin.o(.data); }
    .main_800988BC 0x800988BC : AT(0x000994BC) { build/asm/data/main_800988BC.bin.o(.data); }
    .main_800B9ABC 0x800B9ABC : AT(0x000BA6BC) { FILL(0x00000000); build/asm/main_800B9ABC.s.o(.text); build/asm/main_800B9ABC.s.o(.rodata); build/asm/main_800B9ABC.s.o(.data); }
    .main_800B9ABC_bss (NOLOAD) : { build/asm/main_800B9ABC.s.o(.bss); }
    .main_800B9AE0 0x800B9AE0 : AT(0x000BA6E0) { build/asm/data/main_800B9AE0.bin.o(.data); }
    .main_800C3004 0x800C3004 : AT(0x000C3C04) { FILL(0x00000000); build/asm/main_800C3004.s.o(.text); build/asm/main_800C3004.s.o(.rodata); build/asm/main_800C3004.s.o(.data); }
    .main_800C3004_bss (NOLOAD) : { build/asm/main_800C3004.s.o(.bss); }
    .main_800C3018 0x800C3018 : AT(0x000C3C18) { build/asm/data/main_800C3018.bin.o(.data); }
    .main_800D3A30 0x800D3A30 : AT(0x000D4630) { FILL(0x00000000); build/asm/main_800D3A30.s.o(.text); build/asm/main_800D3A30.s.o(.rodata); build/asm/main_800D3A30.s.o(.data); }
    .main_800D3A30_bss (NOLOAD) : { build/asm/main_800D3A30.s.o(.bss); }
    .main_800D3A6C 0x800D3A6C : AT(0x000D466C) { build/asm/data/main_800D3A6C.bin.o(.data); }
    .main_800E6CEC 0x800E6CEC : AT(0x000E78EC) { FILL(0x00000000); build/asm/main_800E6CEC.s.o(.text); build/asm/main_800E6CEC.s.o(.rodata); build/asm/main_800E6CEC.s.o(.data); }
    .main_800E6CEC_bss (NOLOAD) : { build/asm/main_800E6CEC.s.o(.bss); }
    .main_800E6D08 0x800E6D08 : AT(0x000E7908) { build/asm/data/main_800E6D08.bin.o(.data); }
    .main_800E947C 0x800E947C : AT(0x000EA07C) { FILL(0x00000000); build/asm/main_800E947C.s.o(.text); build/asm/main_800E947C.s.o(.rodata); build/asm/main_800E947C.s.o(.data); }
    .main_800E947C_bss (NOLOAD) : { build/asm/main_800E947C.s.o(.bss); }
    .main_800E9498 0x800E9498 : AT(0x000EA098) { build/asm/data/main_800E9498.bin.o(.data); }
    .main_800FC64C 0x800FC64C : AT(0x000FD24C) { FILL(0x00000000); build/asm/main_800FC64C.s.o(.text); build/asm/main_800FC64C.s.o(.rodata); build/asm/main_800FC64C.s.o(.data); }
    .main_800FC64C_bss (NOLOAD) : { build/asm/main_800FC64C.s.o(.bss); }
    .main_800FC65C 0x800FC65C : AT(0x000FD25C) { build/asm/data/main_800FC65C.bin.o(.data); }
    .main_800FF47C 0x800FF47C : AT(0x0010007C) { build/asm/data/main_800FF47C.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
