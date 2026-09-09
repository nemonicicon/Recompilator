SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004B0 0x800004B0 : AT(0x000010B0) { FILL(0x00000000); build/asm/main_800004B0.s.o(.text); build/asm/main_800004B0.s.o(.rodata); build/asm/main_800004B0.s.o(.data); }
    .main_800004B0_bss (NOLOAD) : { build/asm/main_800004B0.s.o(.bss); }
    .main_800C8174 0x800C8174 : AT(0x000C8D74) { FILL(0x00000000); build/asm/main_800C8174.s.o(.text); build/asm/main_800C8174.s.o(.rodata); build/asm/main_800C8174.s.o(.data); }
    .main_800C8174_bss (NOLOAD) : { build/asm/main_800C8174.s.o(.bss); }
    .main_800C8540 0x800C8540 : AT(0x000C9140) { FILL(0x00000000); build/asm/main_800C8540.s.o(.text); build/asm/main_800C8540.s.o(.rodata); build/asm/main_800C8540.s.o(.data); }
    .main_800C8540_bss (NOLOAD) : { build/asm/main_800C8540.s.o(.bss); }
    .main_800DA6C8 0x800DA6C8 : AT(0x000DB2C8) { FILL(0x00000000); build/asm/main_800DA6C8.s.o(.text); build/asm/main_800DA6C8.s.o(.rodata); build/asm/main_800DA6C8.s.o(.data); }
    .main_800DA6C8_bss (NOLOAD) : { build/asm/main_800DA6C8.s.o(.bss); }
    .main_800DCB50 0x800DCB50 : AT(0x000DD750) { build/asm/data/main_800DCB50.bin.o(.data); }
    .main_800E8260 0x800E8260 : AT(0x000E8E60) { FILL(0x00000000); build/asm/main_800E8260.s.o(.text); build/asm/main_800E8260.s.o(.rodata); build/asm/main_800E8260.s.o(.data); }
    .main_800E8260_bss (NOLOAD) : { build/asm/main_800E8260.s.o(.bss); }
    .main_800F5020 0x800F5020 : AT(0x000F5C20) { FILL(0x00000000); build/asm/main_800F5020.s.o(.text); build/asm/main_800F5020.s.o(.rodata); build/asm/main_800F5020.s.o(.data); }
    .main_800F5020_bss (NOLOAD) : { build/asm/main_800F5020.s.o(.bss); }
    .main_800F582C 0x800F582C : AT(0x000F642C) { build/asm/data/main_800F582C.bin.o(.data); }
    .main_800F6408 0x800F6408 : AT(0x000F7008) { build/asm/data/main_800F6408.bin.o(.data); }
    .main_800F75C0 0x800F75C0 : AT(0x000F81C0) { build/asm/data/main_800F75C0.bin.o(.data); }
    .main_800F7DC0 0x800F7DC0 : AT(0x000F89C0) { build/asm/data/main_800F7DC0.bin.o(.data); }
    .main_800F8210 0x800F8210 : AT(0x000F8E10) { FILL(0x00000000); build/asm/main_800F8210.s.o(.text); build/asm/main_800F8210.s.o(.rodata); build/asm/main_800F8210.s.o(.data); }
    .main_800F8210_bss (NOLOAD) : { build/asm/main_800F8210.s.o(.bss); }
    .main_800F85C0 0x800F85C0 : AT(0x000F91C0) { FILL(0x00000000); build/asm/main_800F85C0.s.o(.text); build/asm/main_800F85C0.s.o(.rodata); build/asm/main_800F85C0.s.o(.data); }
    .main_800F85C0_bss (NOLOAD) : { build/asm/main_800F85C0.s.o(.bss); }
    .main_800F8DC0 0x800F8DC0 : AT(0x000F99C0) { FILL(0x00000000); build/asm/main_800F8DC0.s.o(.text); build/asm/main_800F8DC0.s.o(.rodata); build/asm/main_800F8DC0.s.o(.data); }
    .main_800F8DC0_bss (NOLOAD) : { build/asm/main_800F8DC0.s.o(.bss); }
    .main_800F910C 0x800F910C : AT(0x000F9D0C) { build/asm/data/main_800F910C.bin.o(.data); }
    .main_800F9890 0x800F9890 : AT(0x000FA490) { FILL(0x00000000); build/asm/main_800F9890.s.o(.text); build/asm/main_800F9890.s.o(.rodata); build/asm/main_800F9890.s.o(.data); }
    .main_800F9890_bss (NOLOAD) : { build/asm/main_800F9890.s.o(.bss); }
    .main_800F990C 0x800F990C : AT(0x000FA50C) { build/asm/data/main_800F990C.bin.o(.data); }
    .main_800FC2C8 0x800FC2C8 : AT(0x000FCEC8) { build/asm/data/main_800FC2C8.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
