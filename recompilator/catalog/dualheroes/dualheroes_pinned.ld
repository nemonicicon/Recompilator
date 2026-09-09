SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80020854 0x80020854 : AT(0x00021454) { FILL(0x00000000); build/asm/main_80020854.s.o(.text); build/asm/main_80020854.s.o(.rodata); build/asm/main_80020854.s.o(.data); }
    .main_80020854_bss (NOLOAD) : { build/asm/main_80020854.s.o(.bss); }
    .main_80020C20 0x80020C20 : AT(0x00021820) { FILL(0x00000000); build/asm/main_80020C20.s.o(.text); build/asm/main_80020C20.s.o(.rodata); build/asm/main_80020C20.s.o(.data); }
    .main_80020C20_bss (NOLOAD) : { build/asm/main_80020C20.s.o(.bss); }
    .main_80030C70 0x80030C70 : AT(0x00031870) { FILL(0x00000000); build/asm/data/main_80030C70.data.s.o(.data); }
    .main_800318C0 0x800318C0 : AT(0x000324C0) { FILL(0x00000000); build/asm/main_800318C0.s.o(.text); build/asm/main_800318C0.s.o(.rodata); build/asm/main_800318C0.s.o(.data); }
    .main_800318C0_bss (NOLOAD) : { build/asm/main_800318C0.s.o(.bss); }
    .main_8003FFFC 0x8003FFFC : AT(0x00040BFC) { FILL(0x00000000); build/asm/main_8003FFFC.s.o(.text); build/asm/main_8003FFFC.s.o(.rodata); build/asm/main_8003FFFC.s.o(.data); }
    .main_8003FFFC_bss (NOLOAD) : { build/asm/main_8003FFFC.s.o(.bss); }
    .main_800BE7C0 0x800BE7C0 : AT(0x000BF3C0) { FILL(0x00000000); build/asm/data/main_800BE7C0.data.s.o(.data); }
    .main_800C0000 0x800C0000 : AT(0x000C0C00) { FILL(0x00000000); build/asm/main_800C0000.s.o(.text); build/asm/main_800C0000.s.o(.rodata); build/asm/main_800C0000.s.o(.data); }
    .main_800C0000_bss (NOLOAD) : { build/asm/main_800C0000.s.o(.bss); }
    .main_800C000C 0x800C000C : AT(0x000C0C0C) { FILL(0x00000000); build/asm/data/main_800C000C.data.s.o(.data); }
    .main_800C12C4 0x800C12C4 : AT(0x000C1EC4) { FILL(0x00000000); build/asm/main_800C12C4.s.o(.text); build/asm/main_800C12C4.s.o(.rodata); build/asm/main_800C12C4.s.o(.data); }
    .main_800C12C4_bss (NOLOAD) : { build/asm/main_800C12C4.s.o(.bss); }
    .main_800C1758 0x800C1758 : AT(0x000C2358) { FILL(0x00000000); build/asm/data/main_800C1758.data.s.o(.data); }
    .main_800C2B3C 0x800C2B3C : AT(0x000C373C) { FILL(0x00000000); build/asm/main_800C2B3C.s.o(.text); build/asm/main_800C2B3C.s.o(.rodata); build/asm/main_800C2B3C.s.o(.data); }
    .main_800C2B3C_bss (NOLOAD) : { build/asm/main_800C2B3C.s.o(.bss); }
    .main_800C2B74 0x800C2B74 : AT(0x000C3774) { FILL(0x00000000); build/asm/data/main_800C2B74.data.s.o(.data); }
    .main_800CAF08 0x800CAF08 : AT(0x000CBB08) { FILL(0x00000000); build/asm/data/main_800CAF08.data.s.o(.data); }
    .main_800D0D6C 0x800D0D6C : AT(0x000D196C) { FILL(0x00000000); build/asm/main_800D0D6C.s.o(.text); build/asm/main_800D0D6C.s.o(.rodata); build/asm/main_800D0D6C.s.o(.data); }
    .main_800D0D6C_bss (NOLOAD) : { build/asm/main_800D0D6C.s.o(.bss); }
    .main_800D22FC 0x800D22FC : AT(0x000D2EFC) { FILL(0x00000000); build/asm/data/main_800D22FC.data.s.o(.data); }
    .main_800D2C40 0x800D2C40 : AT(0x000D3840) { FILL(0x00000000); build/asm/main_800D2C40.s.o(.text); build/asm/main_800D2C40.s.o(.rodata); build/asm/main_800D2C40.s.o(.data); }
    .main_800D2C40_bss (NOLOAD) : { build/asm/main_800D2C40.s.o(.bss); }
    .main_800D3DD8 0x800D3DD8 : AT(0x000D49D8) { FILL(0x00000000); build/asm/data/main_800D3DD8.data.s.o(.data); }
    .main_80100020 0x80100020 : AT(0x00100C20) { FILL(0x00000000); build/asm/main_80100020.s.o(.text); build/asm/main_80100020.s.o(.rodata); build/asm/main_80100020.s.o(.data); }
    .main_80100020_bss (NOLOAD) : { build/asm/main_80100020.s.o(.bss); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
