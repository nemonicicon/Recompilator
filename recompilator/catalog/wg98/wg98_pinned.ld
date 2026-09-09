SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80002C1C 0x80002C1C : AT(0x0000381C) { FILL(0x00000000); build/asm/main_80002C1C.s.o(.text); build/asm/main_80002C1C.s.o(.rodata); build/asm/main_80002C1C.s.o(.data); }
    .main_80002C1C_bss (NOLOAD) : { build/asm/main_80002C1C.s.o(.bss); }
    .main_80004E6C 0x80004E6C : AT(0x00005A6C) { build/asm/data/main_80004E6C.bin.o(.data); }
    .main_80013A10 0x80013A10 : AT(0x00014610) { FILL(0x00000000); build/asm/main_80013A10.s.o(.text); build/asm/main_80013A10.s.o(.rodata); build/asm/main_80013A10.s.o(.data); }
    .main_80013A10_bss (NOLOAD) : { build/asm/main_80013A10.s.o(.bss); }
    .main_80031118 0x80031118 : AT(0x00031D18) { build/asm/data/main_80031118.bin.o(.data); }
    .main_80031E78 0x80031E78 : AT(0x00032A78) { FILL(0x00000000); build/asm/main_80031E78.s.o(.text); build/asm/main_80031E78.s.o(.rodata); build/asm/main_80031E78.s.o(.data); }
    .main_80031E78_bss (NOLOAD) : { build/asm/main_80031E78.s.o(.bss); }
    .main_8007242C 0x8007242C : AT(0x0007302C) { build/asm/data/main_8007242C.bin.o(.data); }
    .main_800727E8 0x800727E8 : AT(0x000733E8) { FILL(0x00000000); build/asm/main_800727E8.s.o(.text); build/asm/main_800727E8.s.o(.rodata); build/asm/main_800727E8.s.o(.data); }
    .main_800727E8_bss (NOLOAD) : { build/asm/main_800727E8.s.o(.bss); }
    .main_800C5BF0 0x800C5BF0 : AT(0x000C67F0) { build/asm/data/main_800C5BF0.bin.o(.data); }
    .main_800C70D0 0x800C70D0 : AT(0x000C7CD0) { FILL(0x00000000); build/asm/main_800C70D0.s.o(.text); build/asm/main_800C70D0.s.o(.rodata); build/asm/main_800C70D0.s.o(.data); }
    .main_800C70D0_bss (NOLOAD) : { build/asm/main_800C70D0.s.o(.bss); }
    .main_800C81F4 0x800C81F4 : AT(0x000C8DF4) { build/asm/data/main_800C81F4.bin.o(.data); }
    .main_800C9260 0x800C9260 : AT(0x000C9E60) { FILL(0x00000000); build/asm/main_800C9260.s.o(.text); build/asm/main_800C9260.s.o(.rodata); build/asm/main_800C9260.s.o(.data); }
    .main_800C9260_bss (NOLOAD) : { build/asm/main_800C9260.s.o(.bss); }
    .main_800C9334 0x800C9334 : AT(0x000C9F34) { build/asm/data/main_800C9334.bin.o(.data); }
    .main_800CC210 0x800CC210 : AT(0x000CCE10) { FILL(0x00000000); build/asm/main_800CC210.s.o(.text); build/asm/main_800CC210.s.o(.rodata); build/asm/main_800CC210.s.o(.data); }
    .main_800CC210_bss (NOLOAD) : { build/asm/main_800CC210.s.o(.bss); }
    .main_800CCBA8 0x800CCBA8 : AT(0x000CD7A8) { build/asm/data/main_800CCBA8.bin.o(.data); }
    .main_800CE770 0x800CE770 : AT(0x000CF370) { FILL(0x00000000); build/asm/main_800CE770.s.o(.text); build/asm/main_800CE770.s.o(.rodata); build/asm/main_800CE770.s.o(.data); }
    .main_800CE770_bss (NOLOAD) : { build/asm/main_800CE770.s.o(.bss); }
    .main_800CE858 0x800CE858 : AT(0x000CF458) { build/asm/data/main_800CE858.bin.o(.data); }
    .main_800D167C 0x800D167C : AT(0x000D227C) { FILL(0x00000000); build/asm/main_800D167C.s.o(.text); build/asm/main_800D167C.s.o(.rodata); build/asm/main_800D167C.s.o(.data); }
    .main_800D167C_bss (NOLOAD) : { build/asm/main_800D167C.s.o(.bss); }
    .main_800D1CB0 0x800D1CB0 : AT(0x000D28B0) { build/asm/data/main_800D1CB0.bin.o(.data); }
    .main_800D8748 0x800D8748 : AT(0x000D9348) { FILL(0x00000000); build/asm/main_800D8748.s.o(.text); build/asm/main_800D8748.s.o(.rodata); build/asm/main_800D8748.s.o(.data); }
    .main_800D8748_bss (NOLOAD) : { build/asm/main_800D8748.s.o(.bss); }
    .main_800D8754 0x800D8754 : AT(0x000D9354) { build/asm/data/main_800D8754.bin.o(.data); }
    .main_800E9EA4 0x800E9EA4 : AT(0x000EAAA4) { FILL(0x00000000); build/asm/main_800E9EA4.s.o(.text); build/asm/main_800E9EA4.s.o(.rodata); build/asm/main_800E9EA4.s.o(.data); }
    .main_800E9EA4_bss (NOLOAD) : { build/asm/main_800E9EA4.s.o(.bss); }
    .main_800E9F08 0x800E9F08 : AT(0x000EAB08) { build/asm/data/main_800E9F08.bin.o(.data); }
    .main_800F4EFC 0x800F4EFC : AT(0x000F5AFC) { FILL(0x00000000); build/asm/main_800F4EFC.s.o(.text); build/asm/main_800F4EFC.s.o(.rodata); build/asm/main_800F4EFC.s.o(.data); }
    .main_800F4EFC_bss (NOLOAD) : { build/asm/main_800F4EFC.s.o(.bss); }
    .main_800F4F04 0x800F4F04 : AT(0x000F5B04) { build/asm/data/main_800F4F04.bin.o(.data); }
    .main_800F69C8 0x800F69C8 : AT(0x000F75C8) { FILL(0x00000000); build/asm/main_800F69C8.s.o(.text); build/asm/main_800F69C8.s.o(.rodata); build/asm/main_800F69C8.s.o(.data); }
    .main_800F69C8_bss (NOLOAD) : { build/asm/main_800F69C8.s.o(.bss); }
    .main_800F6A04 0x800F6A04 : AT(0x000F7604) { build/asm/data/main_800F6A04.bin.o(.data); }
    .main_800FB03C 0x800FB03C : AT(0x000FBC3C) { FILL(0x00000000); build/asm/main_800FB03C.s.o(.text); build/asm/main_800FB03C.s.o(.rodata); build/asm/main_800FB03C.s.o(.data); }
    .main_800FB03C_bss (NOLOAD) : { build/asm/main_800FB03C.s.o(.bss); }
    .main_800FB060 0x800FB060 : AT(0x000FBC60) { build/asm/data/main_800FB060.bin.o(.data); }
    .main_800FB244 0x800FB244 : AT(0x000FBE44) { FILL(0x00000000); build/asm/main_800FB244.s.o(.text); build/asm/main_800FB244.s.o(.rodata); build/asm/main_800FB244.s.o(.data); }
    .main_800FB244_bss (NOLOAD) : { build/asm/main_800FB244.s.o(.bss); }
    .main_800FB248 0x800FB248 : AT(0x000FBE48) { build/asm/data/main_800FB248.bin.o(.data); }
    .main_800FCA48 0x800FCA48 : AT(0x000FD648) { FILL(0x00000000); build/asm/main_800FCA48.s.o(.text); build/asm/main_800FCA48.s.o(.rodata); build/asm/main_800FCA48.s.o(.data); }
    .main_800FCA48_bss (NOLOAD) : { build/asm/main_800FCA48.s.o(.bss); }
    .main_800FCA74 0x800FCA74 : AT(0x000FD674) { build/asm/data/main_800FCA74.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
