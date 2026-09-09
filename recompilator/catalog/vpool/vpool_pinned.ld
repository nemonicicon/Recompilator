SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80001344 0x80001344 : AT(0x00001F44) { FILL(0x00000000); build/asm/main_80001344.s.o(.text); build/asm/main_80001344.s.o(.rodata); build/asm/main_80001344.s.o(.data); }
    .main_80001344_bss (NOLOAD) : { build/asm/main_80001344.s.o(.bss); }
    .main_80001720 0x80001720 : AT(0x00002320) { FILL(0x00000000); build/asm/main_80001720.s.o(.text); build/asm/main_80001720.s.o(.rodata); build/asm/main_80001720.s.o(.data); }
    .main_80001720_bss (NOLOAD) : { build/asm/main_80001720.s.o(.bss); }
    .main_800C040C 0x800C040C : AT(0x000C100C) { FILL(0x00000000); build/asm/main_800C040C.s.o(.text); build/asm/main_800C040C.s.o(.rodata); build/asm/main_800C040C.s.o(.data); }
    .main_800C040C_bss (NOLOAD) : { build/asm/main_800C040C.s.o(.bss); }
    .main_800CBC50 0x800CBC50 : AT(0x000CC850) { build/asm/data/main_800CBC50.bin.o(.data); }
    .main_800CC8A0 0x800CC8A0 : AT(0x000CD4A0) { FILL(0x00000000); build/asm/main_800CC8A0.s.o(.text); build/asm/main_800CC8A0.s.o(.rodata); build/asm/main_800CC8A0.s.o(.data); }
    .main_800CC8A0_bss (NOLOAD) : { build/asm/main_800CC8A0.s.o(.bss); }
    .main_800CCC50 0x800CCC50 : AT(0x000CD850) { build/asm/data/main_800CCC50.bin.o(.data); }
    .main_800CCF20 0x800CCF20 : AT(0x000CDB20) { FILL(0x00000000); build/asm/main_800CCF20.s.o(.text); build/asm/main_800CCF20.s.o(.rodata); build/asm/main_800CCF20.s.o(.data); }
    .main_800CCF20_bss (NOLOAD) : { build/asm/main_800CCF20.s.o(.bss); }
    .main_800CCF9C 0x800CCF9C : AT(0x000CDB9C) { build/asm/data/main_800CCF9C.bin.o(.data); }
    .main_800CD820 0x800CD820 : AT(0x000CE420) { build/asm/data/main_800CD820.bin.o(.data); }
    .main_800DA8EC 0x800DA8EC : AT(0x000DB4EC) { build/asm/data/main_800DA8EC.bin.o(.data); }
    .main_800DD54C 0x800DD54C : AT(0x000DE14C) { build/asm/data/main_800DD54C.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
