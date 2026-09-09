SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80060E6C 0x80060E6C : AT(0x00061A6C) { FILL(0x00000000); build/asm/main_80060E6C.s.o(.text); build/asm/main_80060E6C.s.o(.rodata); build/asm/main_80060E6C.s.o(.data); }
    .main_80060E6C_bss (NOLOAD) : { build/asm/main_80060E6C.s.o(.bss); }
    .main_80061250 0x80061250 : AT(0x00061E50) { FILL(0x00000000); build/asm/main_80061250.s.o(.text); build/asm/main_80061250.s.o(.rodata); build/asm/main_80061250.s.o(.data); }
    .main_80061250_bss (NOLOAD) : { build/asm/main_80061250.s.o(.bss); }
    .main_8006AF38 0x8006AF38 : AT(0x0006BB38) { build/asm/data/main_8006AF38.bin.o(.data); }
    .main_8006AF40 0x8006AF40 : AT(0x0006BB40) { FILL(0x00000000); build/asm/main_8006AF40.s.o(.text); build/asm/main_8006AF40.s.o(.rodata); build/asm/main_8006AF40.s.o(.data); }
    .main_8006AF40_bss (NOLOAD) : { build/asm/main_8006AF40.s.o(.bss); }
    .main_800732A0 0x800732A0 : AT(0x00073EA0) { FILL(0x00000000); build/asm/main_800732A0.s.o(.text); build/asm/main_800732A0.s.o(.rodata); build/asm/main_800732A0.s.o(.data); }
    .main_800732A0_bss (NOLOAD) : { build/asm/main_800732A0.s.o(.bss); }
    .main_800732F8 0x800732F8 : AT(0x00073EF8) { FILL(0x00000000); build/asm/main_800732F8.s.o(.text); build/asm/main_800732F8.s.o(.rodata); build/asm/main_800732F8.s.o(.data); }
    .main_800732F8_bss (NOLOAD) : { build/asm/main_800732F8.s.o(.bss); }
    .main_80073710 0x80073710 : AT(0x00074310) { FILL(0x00000000); build/asm/main_80073710.s.o(.text); build/asm/main_80073710.s.o(.rodata); build/asm/main_80073710.s.o(.data); }
    .main_80073710_bss (NOLOAD) : { build/asm/main_80073710.s.o(.bss); }
    .main_80073720 0x80073720 : AT(0x00074320) { build/asm/data/main_80073720.bin.o(.data); }
    .main_80073748 0x80073748 : AT(0x00074348) { FILL(0x00000000); build/asm/main_80073748.s.o(.text); build/asm/main_80073748.s.o(.rodata); build/asm/main_80073748.s.o(.data); }
    .main_80073748_bss (NOLOAD) : { build/asm/main_80073748.s.o(.bss); }
    .main_80073770 0x80073770 : AT(0x00074370) { FILL(0x00000000); build/asm/main_80073770.s.o(.text); build/asm/main_80073770.s.o(.rodata); build/asm/main_80073770.s.o(.data); }
    .main_80073770_bss (NOLOAD) : { build/asm/main_80073770.s.o(.bss); }
    .main_80073798 0x80073798 : AT(0x00074398) { FILL(0x00000000); build/asm/main_80073798.s.o(.text); build/asm/main_80073798.s.o(.rodata); build/asm/main_80073798.s.o(.data); }
    .main_80073798_bss (NOLOAD) : { build/asm/main_80073798.s.o(.bss); }
    .main_800737C8 0x800737C8 : AT(0x000743C8) { FILL(0x00000000); build/asm/main_800737C8.s.o(.text); build/asm/main_800737C8.s.o(.rodata); build/asm/main_800737C8.s.o(.data); }
    .main_800737C8_bss (NOLOAD) : { build/asm/main_800737C8.s.o(.bss); }
    .main_80079240 0x80079240 : AT(0x00079E40) { build/asm/data/main_80079240.bin.o(.data); }
    .main_80079E90 0x80079E90 : AT(0x0007AA90) { build/asm/data/main_80079E90.bin.o(.data); }
    .main_80079F0C 0x80079F0C : AT(0x0007AB0C) { FILL(0x00000000); build/asm/main_80079F0C.s.o(.text); build/asm/main_80079F0C.s.o(.rodata); build/asm/main_80079F0C.s.o(.data); }
    .main_80079F0C_bss (NOLOAD) : { build/asm/main_80079F0C.s.o(.bss); }
    .main_8008316C 0x8008316C : AT(0x00083D6C) { build/asm/data/main_8008316C.bin.o(.data); }
    .main_80084A3C 0x80084A3C : AT(0x0008563C) { FILL(0x00000000); build/asm/main_80084A3C.s.o(.text); build/asm/main_80084A3C.s.o(.rodata); build/asm/main_80084A3C.s.o(.data); }
    .main_80084A3C_bss (NOLOAD) : { build/asm/main_80084A3C.s.o(.bss); }
    .main_80084A7C 0x80084A7C : AT(0x0008567C) { build/asm/data/main_80084A7C.bin.o(.data); }
    .main_8008E474 0x8008E474 : AT(0x0008F074) { FILL(0x00000000); build/asm/main_8008E474.s.o(.text); build/asm/main_8008E474.s.o(.rodata); build/asm/main_8008E474.s.o(.data); }
    .main_8008E474_bss (NOLOAD) : { build/asm/main_8008E474.s.o(.bss); }
    .main_800922B0 0x800922B0 : AT(0x00092EB0) { build/asm/data/main_800922B0.bin.o(.data); }
    .main_800934F4 0x800934F4 : AT(0x000940F4) { FILL(0x00000000); build/asm/main_800934F4.s.o(.text); build/asm/main_800934F4.s.o(.rodata); build/asm/main_800934F4.s.o(.data); }
    .main_800934F4_bss (NOLOAD) : { build/asm/main_800934F4.s.o(.bss); }
    .main_80095D88 0x80095D88 : AT(0x00096988) { build/asm/data/main_80095D88.bin.o(.data); }
    .main_8009BCD0 0x8009BCD0 : AT(0x0009C8D0) { FILL(0x00000000); build/asm/main_8009BCD0.s.o(.text); build/asm/main_8009BCD0.s.o(.rodata); build/asm/main_8009BCD0.s.o(.data); }
    .main_8009BCD0_bss (NOLOAD) : { build/asm/main_8009BCD0.s.o(.bss); }
    .main_8009C038 0x8009C038 : AT(0x0009CC38) { build/asm/data/main_8009C038.bin.o(.data); }
    .main_8009D87C 0x8009D87C : AT(0x0009E47C) { FILL(0x00000000); build/asm/main_8009D87C.s.o(.text); build/asm/main_8009D87C.s.o(.rodata); build/asm/main_8009D87C.s.o(.data); }
    .main_8009D87C_bss (NOLOAD) : { build/asm/main_8009D87C.s.o(.bss); }
    .main_8009DCA0 0x8009DCA0 : AT(0x0009E8A0) { FILL(0x00000000); build/asm/main_8009DCA0.s.o(.text); build/asm/main_8009DCA0.s.o(.rodata); build/asm/main_8009DCA0.s.o(.data); }
    .main_8009DCA0_bss (NOLOAD) : { build/asm/main_8009DCA0.s.o(.bss); }
    .main_8009E8B0 0x8009E8B0 : AT(0x0009F4B0) { FILL(0x00000000); build/asm/main_8009E8B0.s.o(.text); build/asm/main_8009E8B0.s.o(.rodata); build/asm/main_8009E8B0.s.o(.data); }
    .main_8009E8B0_bss (NOLOAD) : { build/asm/main_8009E8B0.s.o(.bss); }
    .main_800A07B8 0x800A07B8 : AT(0x000A13B8) { FILL(0x00000000); build/asm/main_800A07B8.s.o(.text); build/asm/main_800A07B8.s.o(.rodata); build/asm/main_800A07B8.s.o(.data); }
    .main_800A07B8_bss (NOLOAD) : { build/asm/main_800A07B8.s.o(.bss); }
    .main_800A18A8 0x800A18A8 : AT(0x000A24A8) { FILL(0x00000000); build/asm/main_800A18A8.s.o(.text); build/asm/main_800A18A8.s.o(.rodata); build/asm/main_800A18A8.s.o(.data); }
    .main_800A18A8_bss (NOLOAD) : { build/asm/main_800A18A8.s.o(.bss); }
    .main_800A2150 0x800A2150 : AT(0x000A2D50) { FILL(0x00000000); build/asm/main_800A2150.s.o(.text); build/asm/main_800A2150.s.o(.rodata); build/asm/main_800A2150.s.o(.data); }
    .main_800A2150_bss (NOLOAD) : { build/asm/main_800A2150.s.o(.bss); }
    .main_800A21A8 0x800A21A8 : AT(0x000A2DA8) { build/asm/data/main_800A21A8.bin.o(.data); }
    .main_800A3EC8 0x800A3EC8 : AT(0x000A4AC8) { build/asm/data/main_800A3EC8.bin.o(.data); }
    .main_800A4214 0x800A4214 : AT(0x000A4E14) { FILL(0x00000000); build/asm/main_800A4214.s.o(.text); build/asm/main_800A4214.s.o(.rodata); build/asm/main_800A4214.s.o(.data); }
    .main_800A4214_bss (NOLOAD) : { build/asm/main_800A4214.s.o(.bss); }
    .main_800A4218 0x800A4218 : AT(0x000A4E18) { build/asm/data/main_800A4218.bin.o(.data); }
    .main_800A8CC4 0x800A8CC4 : AT(0x000A98C4) { FILL(0x00000000); build/asm/main_800A8CC4.s.o(.text); build/asm/main_800A8CC4.s.o(.rodata); build/asm/main_800A8CC4.s.o(.data); }
    .main_800A8CC4_bss (NOLOAD) : { build/asm/main_800A8CC4.s.o(.bss); }
    .main_800AABB0 0x800AABB0 : AT(0x000AB7B0) { build/asm/data/main_800AABB0.bin.o(.data); }
    .main_800ACBF0 0x800ACBF0 : AT(0x000AD7F0) { FILL(0x00000000); build/asm/main_800ACBF0.s.o(.text); build/asm/main_800ACBF0.s.o(.rodata); build/asm/main_800ACBF0.s.o(.data); }
    .main_800ACBF0_bss (NOLOAD) : { build/asm/main_800ACBF0.s.o(.bss); }
    .main_800ADC34 0x800ADC34 : AT(0x000AE834) { build/asm/data/main_800ADC34.bin.o(.data); }
    .main_800AEC70 0x800AEC70 : AT(0x000AF870) { FILL(0x00000000); build/asm/main_800AEC70.s.o(.text); build/asm/main_800AEC70.s.o(.rodata); build/asm/main_800AEC70.s.o(.data); }
    .main_800AEC70_bss (NOLOAD) : { build/asm/main_800AEC70.s.o(.bss); }
    .main_800B16B0 0x800B16B0 : AT(0x000B22B0) { FILL(0x00000000); build/asm/main_800B16B0.s.o(.text); build/asm/main_800B16B0.s.o(.rodata); build/asm/main_800B16B0.s.o(.data); }
    .main_800B16B0_bss (NOLOAD) : { build/asm/main_800B16B0.s.o(.bss); }
    .main_800B2D4C 0x800B2D4C : AT(0x000B394C) { build/asm/data/main_800B2D4C.bin.o(.data); }
    .main_800BF94C 0x800BF94C : AT(0x000C054C) { build/asm/data/main_800BF94C.bin.o(.data); }
    .main_800C7DD4 0x800C7DD4 : AT(0x000C89D4) { FILL(0x00000000); build/asm/main_800C7DD4.s.o(.text); build/asm/main_800C7DD4.s.o(.rodata); build/asm/main_800C7DD4.s.o(.data); }
    .main_800C7DD4_bss (NOLOAD) : { build/asm/main_800C7DD4.s.o(.bss); }
    .main_800C9BD0 0x800C9BD0 : AT(0x000CA7D0) { build/asm/data/main_800C9BD0.bin.o(.data); }
    .main_800F3AA8 0x800F3AA8 : AT(0x000F46A8) { FILL(0x00000000); build/asm/main_800F3AA8.s.o(.text); build/asm/main_800F3AA8.s.o(.rodata); build/asm/main_800F3AA8.s.o(.data); }
    .main_800F3AA8_bss (NOLOAD) : { build/asm/main_800F3AA8.s.o(.bss); }
    .main_800F3AB0 0x800F3AB0 : AT(0x000F46B0) { build/asm/data/main_800F3AB0.bin.o(.data); }
    .main_800F4D84 0x800F4D84 : AT(0x000F5984) { FILL(0x00000000); build/asm/main_800F4D84.s.o(.text); build/asm/main_800F4D84.s.o(.rodata); build/asm/main_800F4D84.s.o(.data); }
    .main_800F4D84_bss (NOLOAD) : { build/asm/main_800F4D84.s.o(.bss); }
    .main_800F4D9C 0x800F4D9C : AT(0x000F599C) { build/asm/data/main_800F4D9C.bin.o(.data); }
    .main_800F5BBC 0x800F5BBC : AT(0x000F67BC) { FILL(0x00000000); build/asm/main_800F5BBC.s.o(.text); build/asm/main_800F5BBC.s.o(.rodata); build/asm/main_800F5BBC.s.o(.data); }
    .main_800F5BBC_bss (NOLOAD) : { build/asm/main_800F5BBC.s.o(.bss); }
    .main_800F5BC0 0x800F5BC0 : AT(0x000F67C0) { build/asm/data/main_800F5BC0.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
