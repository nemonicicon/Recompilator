SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800A6A14 0x800A6A14 : AT(0x000A7614) { FILL(0x00000000); build/asm/main_800A6A14.s.o(.text); build/asm/main_800A6A14.s.o(.rodata); build/asm/main_800A6A14.s.o(.data); }
    .main_800A6A14_bss (NOLOAD) : { build/asm/main_800A6A14.s.o(.bss); }
    .main_800A6F80 0x800A6F80 : AT(0x000A7B80) { FILL(0x00000000); build/asm/main_800A6F80.s.o(.text); build/asm/main_800A6F80.s.o(.rodata); build/asm/main_800A6F80.s.o(.data); }
    .main_800A6F80_bss (NOLOAD) : { build/asm/main_800A6F80.s.o(.bss); }
    .main_800B719C 0x800B719C : AT(0x000B7D9C) { FILL(0x00000000); build/asm/main_800B719C.s.o(.text); build/asm/main_800B719C.s.o(.rodata); build/asm/main_800B719C.s.o(.data); }
    .main_800B719C_bss (NOLOAD) : { build/asm/main_800B719C.s.o(.bss); }
    .main_800B7900 0x800B7900 : AT(0x000B8500) { FILL(0x00000000); build/asm/main_800B7900.s.o(.text); build/asm/main_800B7900.s.o(.rodata); build/asm/main_800B7900.s.o(.data); }
    .main_800B7900_bss (NOLOAD) : { build/asm/main_800B7900.s.o(.bss); }
    .main_800BA570 0x800BA570 : AT(0x000BB170) { build/asm/data/main_800BA570.bin.o(.data); }
    .main_800BAA4C 0x800BAA4C : AT(0x000BB64C) { FILL(0x00000000); build/asm/main_800BAA4C.s.o(.text); build/asm/main_800BAA4C.s.o(.rodata); build/asm/main_800BAA4C.s.o(.data); }
    .main_800BAA4C_bss (NOLOAD) : { build/asm/main_800BAA4C.s.o(.bss); }
    .main_800BB564 0x800BB564 : AT(0x000BC164) { build/asm/data/main_800BB564.bin.o(.data); }
    .main_800BB864 0x800BB864 : AT(0x000BC464) { FILL(0x00000000); build/asm/main_800BB864.s.o(.text); build/asm/main_800BB864.s.o(.rodata); build/asm/main_800BB864.s.o(.data); }
    .main_800BB864_bss (NOLOAD) : { build/asm/main_800BB864.s.o(.bss); }
    .main_800BB8DC 0x800BB8DC : AT(0x000BC4DC) { build/asm/data/main_800BB8DC.bin.o(.data); }
    .main_800BC344 0x800BC344 : AT(0x000BCF44) { build/asm/data/main_800BC344.bin.o(.data); }
    .main_800D581C 0x800D581C : AT(0x000D641C) { FILL(0x00000000); build/asm/main_800D581C.s.o(.text); build/asm/main_800D581C.s.o(.rodata); build/asm/main_800D581C.s.o(.data); }
    .main_800D581C_bss (NOLOAD) : { build/asm/main_800D581C.s.o(.bss); }
    .main_800D5A1C 0x800D5A1C : AT(0x000D661C) { build/asm/data/main_800D5A1C.bin.o(.data); }
    .main_800D632C 0x800D632C : AT(0x000D6F2C) { FILL(0x00000000); build/asm/main_800D632C.s.o(.text); build/asm/main_800D632C.s.o(.rodata); build/asm/main_800D632C.s.o(.data); }
    .main_800D632C_bss (NOLOAD) : { build/asm/main_800D632C.s.o(.bss); }
    .main_800D636C 0x800D636C : AT(0x000D6F6C) { FILL(0x00000000); build/asm/main_800D636C.s.o(.text); build/asm/main_800D636C.s.o(.rodata); build/asm/main_800D636C.s.o(.data); }
    .main_800D636C_bss (NOLOAD) : { build/asm/main_800D636C.s.o(.bss); }
    .main_800D6984 0x800D6984 : AT(0x000D7584) { FILL(0x00000000); build/asm/main_800D6984.s.o(.text); build/asm/main_800D6984.s.o(.rodata); build/asm/main_800D6984.s.o(.data); }
    .main_800D6984_bss (NOLOAD) : { build/asm/main_800D6984.s.o(.bss); }
    .main_800D69C4 0x800D69C4 : AT(0x000D75C4) { build/asm/data/main_800D69C4.bin.o(.data); }
    .main_800D6C44 0x800D6C44 : AT(0x000D7844) { FILL(0x00000000); build/asm/main_800D6C44.s.o(.text); build/asm/main_800D6C44.s.o(.rodata); build/asm/main_800D6C44.s.o(.data); }
    .main_800D6C44_bss (NOLOAD) : { build/asm/main_800D6C44.s.o(.bss); }
    .main_800D6CBC 0x800D6CBC : AT(0x000D78BC) { build/asm/data/main_800D6CBC.bin.o(.data); }
    .main_800D768C 0x800D768C : AT(0x000D828C) { build/asm/data/main_800D768C.bin.o(.data); }
    .main_800D76B4 0x800D76B4 : AT(0x000D82B4) { FILL(0x00000000); build/asm/main_800D76B4.s.o(.text); build/asm/main_800D76B4.s.o(.rodata); build/asm/main_800D76B4.s.o(.data); }
    .main_800D76B4_bss (NOLOAD) : { build/asm/main_800D76B4.s.o(.bss); }
    .main_800D76C8 0x800D76C8 : AT(0x000D82C8) { build/asm/data/main_800D76C8.bin.o(.data); }
    .main_800D7A2C 0x800D7A2C : AT(0x000D862C) { build/asm/data/main_800D7A2C.bin.o(.data); }
    .main_800D9304 0x800D9304 : AT(0x000D9F04) { FILL(0x00000000); build/asm/main_800D9304.s.o(.text); build/asm/main_800D9304.s.o(.rodata); build/asm/main_800D9304.s.o(.data); }
    .main_800D9304_bss (NOLOAD) : { build/asm/main_800D9304.s.o(.bss); }
    .main_800D9414 0x800D9414 : AT(0x000DA014) { FILL(0x00000000); build/asm/main_800D9414.s.o(.text); build/asm/main_800D9414.s.o(.rodata); build/asm/main_800D9414.s.o(.data); }
    .main_800D9414_bss (NOLOAD) : { build/asm/main_800D9414.s.o(.bss); }
    .main_800D9548 0x800D9548 : AT(0x000DA148) { FILL(0x00000000); build/asm/main_800D9548.s.o(.text); build/asm/main_800D9548.s.o(.rodata); build/asm/main_800D9548.s.o(.data); }
    .main_800D9548_bss (NOLOAD) : { build/asm/main_800D9548.s.o(.bss); }
    .main_800D955C 0x800D955C : AT(0x000DA15C) { build/asm/data/main_800D955C.bin.o(.data); }
    .main_800D986C 0x800D986C : AT(0x000DA46C) { FILL(0x00000000); build/asm/main_800D986C.s.o(.text); build/asm/main_800D986C.s.o(.rodata); build/asm/main_800D986C.s.o(.data); }
    .main_800D986C_bss (NOLOAD) : { build/asm/main_800D986C.s.o(.bss); }
    .main_800D988C 0x800D988C : AT(0x000DA48C) { build/asm/data/main_800D988C.bin.o(.data); }
    .main_800D9FB8 0x800D9FB8 : AT(0x000DABB8) { build/asm/data/main_800D9FB8.bin.o(.data); }
    .main_800DA314 0x800DA314 : AT(0x000DAF14) { build/asm/data/main_800DA314.bin.o(.data); }
    .main_800DA3A4 0x800DA3A4 : AT(0x000DAFA4) { FILL(0x00000000); build/asm/main_800DA3A4.s.o(.text); build/asm/main_800DA3A4.s.o(.rodata); build/asm/main_800DA3A4.s.o(.data); }
    .main_800DA3A4_bss (NOLOAD) : { build/asm/main_800DA3A4.s.o(.bss); }
    .main_800DA3B8 0x800DA3B8 : AT(0x000DAFB8) { build/asm/data/main_800DA3B8.bin.o(.data); }
    .main_800DA444 0x800DA444 : AT(0x000DB044) { FILL(0x00000000); build/asm/main_800DA444.s.o(.text); build/asm/main_800DA444.s.o(.rodata); build/asm/main_800DA444.s.o(.data); }
    .main_800DA444_bss (NOLOAD) : { build/asm/main_800DA444.s.o(.bss); }
    .main_800DA46C 0x800DA46C : AT(0x000DB06C) { build/asm/data/main_800DA46C.bin.o(.data); }
    .main_800DA774 0x800DA774 : AT(0x000DB374) { build/asm/data/main_800DA774.bin.o(.data); }
    .main_800E0DD0 0x800E0DD0 : AT(0x000E19D0) { build/asm/data/main_800E0DD0.bin.o(.data); }
    .main_800E0E94 0x800E0E94 : AT(0x000E1A94) { FILL(0x00000000); build/asm/main_800E0E94.s.o(.text); build/asm/main_800E0E94.s.o(.rodata); build/asm/main_800E0E94.s.o(.data); }
    .main_800E0E94_bss (NOLOAD) : { build/asm/main_800E0E94.s.o(.bss); }
    .main_800E20C4 0x800E20C4 : AT(0x000E2CC4) { FILL(0x00000000); build/asm/main_800E20C4.s.o(.text); build/asm/main_800E20C4.s.o(.rodata); build/asm/main_800E20C4.s.o(.data); }
    .main_800E20C4_bss (NOLOAD) : { build/asm/main_800E20C4.s.o(.bss); }
    .main_800E2A00 0x800E2A00 : AT(0x000E3600) { build/asm/data/main_800E2A00.bin.o(.data); }
    .main_800E3650 0x800E3650 : AT(0x000E4250) { FILL(0x00000000); build/asm/main_800E3650.s.o(.text); build/asm/main_800E3650.s.o(.rodata); build/asm/main_800E3650.s.o(.data); }
    .main_800E3650_bss (NOLOAD) : { build/asm/main_800E3650.s.o(.bss); }
    .main_800E3704 0x800E3704 : AT(0x000E4304) { build/asm/data/main_800E3704.bin.o(.data); }
    .main_800E63C8 0x800E63C8 : AT(0x000E6FC8) { build/asm/data/main_800E63C8.bin.o(.data); }
    .main_800E8AF0 0x800E8AF0 : AT(0x000E96F0) { FILL(0x00000000); build/asm/main_800E8AF0.s.o(.text); build/asm/main_800E8AF0.s.o(.rodata); build/asm/main_800E8AF0.s.o(.data); }
    .main_800E8AF0_bss (NOLOAD) : { build/asm/main_800E8AF0.s.o(.bss); }
    .main_800E9060 0x800E9060 : AT(0x000E9C60) { build/asm/data/main_800E9060.bin.o(.data); }
    .main_800EB180 0x800EB180 : AT(0x000EBD80) { FILL(0x00000000); build/asm/main_800EB180.s.o(.text); build/asm/main_800EB180.s.o(.rodata); build/asm/main_800EB180.s.o(.data); }
    .main_800EB180_bss (NOLOAD) : { build/asm/main_800EB180.s.o(.bss); }
    .main_800EB1A0 0x800EB1A0 : AT(0x000EBDA0) { build/asm/data/main_800EB1A0.bin.o(.data); }
    .main_800EB880 0x800EB880 : AT(0x000EC480) { FILL(0x00000000); build/asm/main_800EB880.s.o(.text); build/asm/main_800EB880.s.o(.rodata); build/asm/main_800EB880.s.o(.data); }
    .main_800EB880_bss (NOLOAD) : { build/asm/main_800EB880.s.o(.bss); }
    .main_800EC8F0 0x800EC8F0 : AT(0x000ED4F0) { FILL(0x00000000); build/asm/main_800EC8F0.s.o(.text); build/asm/main_800EC8F0.s.o(.rodata); build/asm/main_800EC8F0.s.o(.data); }
    .main_800EC8F0_bss (NOLOAD) : { build/asm/main_800EC8F0.s.o(.bss); }
    .main_800EC9E0 0x800EC9E0 : AT(0x000ED5E0) { FILL(0x00000000); build/asm/main_800EC9E0.s.o(.text); build/asm/main_800EC9E0.s.o(.rodata); build/asm/main_800EC9E0.s.o(.data); }
    .main_800EC9E0_bss (NOLOAD) : { build/asm/main_800EC9E0.s.o(.bss); }
    .main_800ECA00 0x800ECA00 : AT(0x000ED600) { FILL(0x00000000); build/asm/main_800ECA00.s.o(.text); build/asm/main_800ECA00.s.o(.rodata); build/asm/main_800ECA00.s.o(.data); }
    .main_800ECA00_bss (NOLOAD) : { build/asm/main_800ECA00.s.o(.bss); }
    .main_800ECA20 0x800ECA20 : AT(0x000ED620) { FILL(0x00000000); build/asm/main_800ECA20.s.o(.text); build/asm/main_800ECA20.s.o(.rodata); build/asm/main_800ECA20.s.o(.data); }
    .main_800ECA20_bss (NOLOAD) : { build/asm/main_800ECA20.s.o(.bss); }
    .main_800ECA50 0x800ECA50 : AT(0x000ED650) { FILL(0x00000000); build/asm/main_800ECA50.s.o(.text); build/asm/main_800ECA50.s.o(.rodata); build/asm/main_800ECA50.s.o(.data); }
    .main_800ECA50_bss (NOLOAD) : { build/asm/main_800ECA50.s.o(.bss); }
    .main_800ECC68 0x800ECC68 : AT(0x000ED868) { FILL(0x00000000); build/asm/main_800ECC68.s.o(.text); build/asm/main_800ECC68.s.o(.rodata); build/asm/main_800ECC68.s.o(.data); }
    .main_800ECC68_bss (NOLOAD) : { build/asm/main_800ECC68.s.o(.bss); }
    .main_800EDA94 0x800EDA94 : AT(0x000EE694) { build/asm/data/main_800EDA94.bin.o(.data); }
    .main_800EDB18 0x800EDB18 : AT(0x000EE718) { FILL(0x00000000); build/asm/main_800EDB18.s.o(.text); build/asm/main_800EDB18.s.o(.rodata); build/asm/main_800EDB18.s.o(.data); }
    .main_800EDB18_bss (NOLOAD) : { build/asm/main_800EDB18.s.o(.bss); }
    .main_800EE138 0x800EE138 : AT(0x000EED38) { build/asm/data/main_800EE138.bin.o(.data); }
    .main_800EE2F8 0x800EE2F8 : AT(0x000EEEF8) { FILL(0x00000000); build/asm/main_800EE2F8.s.o(.text); build/asm/main_800EE2F8.s.o(.rodata); build/asm/main_800EE2F8.s.o(.data); }
    .main_800EE2F8_bss (NOLOAD) : { build/asm/main_800EE2F8.s.o(.bss); }
    .main_800EE40C 0x800EE40C : AT(0x000EF00C) { build/asm/data/main_800EE40C.bin.o(.data); }
    .main_800EE714 0x800EE714 : AT(0x000EF314) { FILL(0x00000000); build/asm/main_800EE714.s.o(.text); build/asm/main_800EE714.s.o(.rodata); build/asm/main_800EE714.s.o(.data); }
    .main_800EE714_bss (NOLOAD) : { build/asm/main_800EE714.s.o(.bss); }
    .main_800EE830 0x800EE830 : AT(0x000EF430) { build/asm/data/main_800EE830.bin.o(.data); }
    .main_800EEB58 0x800EEB58 : AT(0x000EF758) { FILL(0x00000000); build/asm/main_800EEB58.s.o(.text); build/asm/main_800EEB58.s.o(.rodata); build/asm/main_800EEB58.s.o(.data); }
    .main_800EEB58_bss (NOLOAD) : { build/asm/main_800EEB58.s.o(.bss); }
    .main_800EF350 0x800EF350 : AT(0x000EFF50) { build/asm/data/main_800EF350.bin.o(.data); }
    .main_800EF8F8 0x800EF8F8 : AT(0x000F04F8) { FILL(0x00000000); build/asm/main_800EF8F8.s.o(.text); build/asm/main_800EF8F8.s.o(.rodata); build/asm/main_800EF8F8.s.o(.data); }
    .main_800EF8F8_bss (NOLOAD) : { build/asm/main_800EF8F8.s.o(.bss); }
    .main_800EF940 0x800EF940 : AT(0x000F0540) { build/asm/data/main_800EF940.bin.o(.data); }
    .main_800EFCC0 0x800EFCC0 : AT(0x000F08C0) { FILL(0x00000000); build/asm/main_800EFCC0.s.o(.text); build/asm/main_800EFCC0.s.o(.rodata); build/asm/main_800EFCC0.s.o(.data); }
    .main_800EFCC0_bss (NOLOAD) : { build/asm/main_800EFCC0.s.o(.bss); }
    .main_800EFDC0 0x800EFDC0 : AT(0x000F09C0) { build/asm/data/main_800EFDC0.bin.o(.data); }
    .main_800EFEE0 0x800EFEE0 : AT(0x000F0AE0) { FILL(0x00000000); build/asm/main_800EFEE0.s.o(.text); build/asm/main_800EFEE0.s.o(.rodata); build/asm/main_800EFEE0.s.o(.data); }
    .main_800EFEE0_bss (NOLOAD) : { build/asm/main_800EFEE0.s.o(.bss); }
    .main_800F0A18 0x800F0A18 : AT(0x000F1618) { build/asm/data/main_800F0A18.bin.o(.data); }
    .main_800F0A8C 0x800F0A8C : AT(0x000F168C) { FILL(0x00000000); build/asm/main_800F0A8C.s.o(.text); build/asm/main_800F0A8C.s.o(.rodata); build/asm/main_800F0A8C.s.o(.data); }
    .main_800F0A8C_bss (NOLOAD) : { build/asm/main_800F0A8C.s.o(.bss); }
    .main_800F0E30 0x800F0E30 : AT(0x000F1A30) { build/asm/data/main_800F0E30.bin.o(.data); }
    .main_800F1090 0x800F1090 : AT(0x000F1C90) { FILL(0x00000000); build/asm/main_800F1090.s.o(.text); build/asm/main_800F1090.s.o(.rodata); build/asm/main_800F1090.s.o(.data); }
    .main_800F1090_bss (NOLOAD) : { build/asm/main_800F1090.s.o(.bss); }
    .main_800F12D8 0x800F12D8 : AT(0x000F1ED8) { build/asm/data/main_800F12D8.bin.o(.data); }
    .main_800F1558 0x800F1558 : AT(0x000F2158) { FILL(0x00000000); build/asm/main_800F1558.s.o(.text); build/asm/main_800F1558.s.o(.rodata); build/asm/main_800F1558.s.o(.data); }
    .main_800F1558_bss (NOLOAD) : { build/asm/main_800F1558.s.o(.bss); }
    .main_800F19E8 0x800F19E8 : AT(0x000F25E8) { build/asm/data/main_800F19E8.bin.o(.data); }
    .main_800F1D48 0x800F1D48 : AT(0x000F2948) { FILL(0x00000000); build/asm/main_800F1D48.s.o(.text); build/asm/main_800F1D48.s.o(.rodata); build/asm/main_800F1D48.s.o(.data); }
    .main_800F1D48_bss (NOLOAD) : { build/asm/main_800F1D48.s.o(.bss); }
    .main_800F1E18 0x800F1E18 : AT(0x000F2A18) { build/asm/data/main_800F1E18.bin.o(.data); }
    .main_800F2500 0x800F2500 : AT(0x000F3100) { FILL(0x00000000); build/asm/main_800F2500.s.o(.text); build/asm/main_800F2500.s.o(.rodata); build/asm/main_800F2500.s.o(.data); }
    .main_800F2500_bss (NOLOAD) : { build/asm/main_800F2500.s.o(.bss); }
    .main_800F2628 0x800F2628 : AT(0x000F3228) { build/asm/data/main_800F2628.bin.o(.data); }
    .main_800F27D8 0x800F27D8 : AT(0x000F33D8) { FILL(0x00000000); build/asm/main_800F27D8.s.o(.text); build/asm/main_800F27D8.s.o(.rodata); build/asm/main_800F27D8.s.o(.data); }
    .main_800F27D8_bss (NOLOAD) : { build/asm/main_800F27D8.s.o(.bss); }
    .main_800F27F0 0x800F27F0 : AT(0x000F33F0) { build/asm/data/main_800F27F0.bin.o(.data); }
    .main_800F2A88 0x800F2A88 : AT(0x000F3688) { FILL(0x00000000); build/asm/main_800F2A88.s.o(.text); build/asm/main_800F2A88.s.o(.rodata); build/asm/main_800F2A88.s.o(.data); }
    .main_800F2A88_bss (NOLOAD) : { build/asm/main_800F2A88.s.o(.bss); }
    .main_800F2CC8 0x800F2CC8 : AT(0x000F38C8) { build/asm/data/main_800F2CC8.bin.o(.data); }
    .main_800F2FC0 0x800F2FC0 : AT(0x000F3BC0) { FILL(0x00000000); build/asm/main_800F2FC0.s.o(.text); build/asm/main_800F2FC0.s.o(.rodata); build/asm/main_800F2FC0.s.o(.data); }
    .main_800F2FC0_bss (NOLOAD) : { build/asm/main_800F2FC0.s.o(.bss); }
    .main_800F3218 0x800F3218 : AT(0x000F3E18) { build/asm/data/main_800F3218.bin.o(.data); }
    .main_800F3314 0x800F3314 : AT(0x000F3F14) { FILL(0x00000000); build/asm/main_800F3314.s.o(.text); build/asm/main_800F3314.s.o(.rodata); build/asm/main_800F3314.s.o(.data); }
    .main_800F3314_bss (NOLOAD) : { build/asm/main_800F3314.s.o(.bss); }
    .main_800F34D0 0x800F34D0 : AT(0x000F40D0) { build/asm/data/main_800F34D0.bin.o(.data); }
    .main_800F3600 0x800F3600 : AT(0x000F4200) { FILL(0x00000000); build/asm/main_800F3600.s.o(.text); build/asm/main_800F3600.s.o(.rodata); build/asm/main_800F3600.s.o(.data); }
    .main_800F3600_bss (NOLOAD) : { build/asm/main_800F3600.s.o(.bss); }
    .main_800F39E8 0x800F39E8 : AT(0x000F45E8) { build/asm/data/main_800F39E8.bin.o(.data); }
    .main_800F3C90 0x800F3C90 : AT(0x000F4890) { FILL(0x00000000); build/asm/main_800F3C90.s.o(.text); build/asm/main_800F3C90.s.o(.rodata); build/asm/main_800F3C90.s.o(.data); }
    .main_800F3C90_bss (NOLOAD) : { build/asm/main_800F3C90.s.o(.bss); }
    .main_800F4018 0x800F4018 : AT(0x000F4C18) { FILL(0x00000000); build/asm/main_800F4018.s.o(.text); build/asm/main_800F4018.s.o(.rodata); build/asm/main_800F4018.s.o(.data); }
    .main_800F4018_bss (NOLOAD) : { build/asm/main_800F4018.s.o(.bss); }
    .main_800F4610 0x800F4610 : AT(0x000F5210) { FILL(0x00000000); build/asm/main_800F4610.s.o(.text); build/asm/main_800F4610.s.o(.rodata); build/asm/main_800F4610.s.o(.data); }
    .main_800F4610_bss (NOLOAD) : { build/asm/main_800F4610.s.o(.bss); }
    .main_800F4868 0x800F4868 : AT(0x000F5468) { build/asm/data/main_800F4868.bin.o(.data); }
    .main_800F48C0 0x800F48C0 : AT(0x000F54C0) { FILL(0x00000000); build/asm/main_800F48C0.s.o(.text); build/asm/main_800F48C0.s.o(.rodata); build/asm/main_800F48C0.s.o(.data); }
    .main_800F48C0_bss (NOLOAD) : { build/asm/main_800F48C0.s.o(.bss); }
    .main_800F4958 0x800F4958 : AT(0x000F5558) { build/asm/data/main_800F4958.bin.o(.data); }
    .main_800F4AE8 0x800F4AE8 : AT(0x000F56E8) { FILL(0x00000000); build/asm/main_800F4AE8.s.o(.text); build/asm/main_800F4AE8.s.o(.rodata); build/asm/main_800F4AE8.s.o(.data); }
    .main_800F4AE8_bss (NOLOAD) : { build/asm/main_800F4AE8.s.o(.bss); }
    .main_800F5770 0x800F5770 : AT(0x000F6370) { build/asm/data/main_800F5770.bin.o(.data); }
    .main_800F5870 0x800F5870 : AT(0x000F6470) { FILL(0x00000000); build/asm/main_800F5870.s.o(.text); build/asm/main_800F5870.s.o(.rodata); build/asm/main_800F5870.s.o(.data); }
    .main_800F5870_bss (NOLOAD) : { build/asm/main_800F5870.s.o(.bss); }
    .main_800F5880 0x800F5880 : AT(0x000F6480) { build/asm/data/main_800F5880.bin.o(.data); }
    .main_800F5898 0x800F5898 : AT(0x000F6498) { FILL(0x00000000); build/asm/main_800F5898.s.o(.text); build/asm/main_800F5898.s.o(.rodata); build/asm/main_800F5898.s.o(.data); }
    .main_800F5898_bss (NOLOAD) : { build/asm/main_800F5898.s.o(.bss); }
    .main_800F58D8 0x800F58D8 : AT(0x000F64D8) { build/asm/data/main_800F58D8.bin.o(.data); }
    .main_800F5B00 0x800F5B00 : AT(0x000F6700) { FILL(0x00000000); build/asm/main_800F5B00.s.o(.text); build/asm/main_800F5B00.s.o(.rodata); build/asm/main_800F5B00.s.o(.data); }
    .main_800F5B00_bss (NOLOAD) : { build/asm/main_800F5B00.s.o(.bss); }
    .main_800F60A8 0x800F60A8 : AT(0x000F6CA8) { build/asm/data/main_800F60A8.bin.o(.data); }
    .main_800F65E4 0x800F65E4 : AT(0x000F71E4) { FILL(0x00000000); build/asm/main_800F65E4.s.o(.text); build/asm/main_800F65E4.s.o(.rodata); build/asm/main_800F65E4.s.o(.data); }
    .main_800F65E4_bss (NOLOAD) : { build/asm/main_800F65E4.s.o(.bss); }
    .main_800F6614 0x800F6614 : AT(0x000F7214) { build/asm/data/main_800F6614.bin.o(.data); }
    .main_800F7288 0x800F7288 : AT(0x000F7E88) { FILL(0x00000000); build/asm/main_800F7288.s.o(.text); build/asm/main_800F7288.s.o(.rodata); build/asm/main_800F7288.s.o(.data); }
    .main_800F7288_bss (NOLOAD) : { build/asm/main_800F7288.s.o(.bss); }
    .main_800F7478 0x800F7478 : AT(0x000F8078) { build/asm/data/main_800F7478.bin.o(.data); }
    .main_800F7DD0 0x800F7DD0 : AT(0x000F89D0) { FILL(0x00000000); build/asm/main_800F7DD0.s.o(.text); build/asm/main_800F7DD0.s.o(.rodata); build/asm/main_800F7DD0.s.o(.data); }
    .main_800F7DD0_bss (NOLOAD) : { build/asm/main_800F7DD0.s.o(.bss); }
    .main_800F7F90 0x800F7F90 : AT(0x000F8B90) { build/asm/data/main_800F7F90.bin.o(.data); }
    .main_800F8490 0x800F8490 : AT(0x000F9090) { FILL(0x00000000); build/asm/main_800F8490.s.o(.text); build/asm/main_800F8490.s.o(.rodata); build/asm/main_800F8490.s.o(.data); }
    .main_800F8490_bss (NOLOAD) : { build/asm/main_800F8490.s.o(.bss); }
    .main_800F8788 0x800F8788 : AT(0x000F9388) { build/asm/data/main_800F8788.bin.o(.data); }
    .main_800F8A28 0x800F8A28 : AT(0x000F9628) { FILL(0x00000000); build/asm/main_800F8A28.s.o(.text); build/asm/main_800F8A28.s.o(.rodata); build/asm/main_800F8A28.s.o(.data); }
    .main_800F8A28_bss (NOLOAD) : { build/asm/main_800F8A28.s.o(.bss); }
    .main_800F8CF8 0x800F8CF8 : AT(0x000F98F8) { build/asm/data/main_800F8CF8.bin.o(.data); }
    .main_800F91D8 0x800F91D8 : AT(0x000F9DD8) { FILL(0x00000000); build/asm/main_800F91D8.s.o(.text); build/asm/main_800F91D8.s.o(.rodata); build/asm/main_800F91D8.s.o(.data); }
    .main_800F91D8_bss (NOLOAD) : { build/asm/main_800F91D8.s.o(.bss); }
    .main_800F9220 0x800F9220 : AT(0x000F9E20) { build/asm/data/main_800F9220.bin.o(.data); }
    .main_800F9370 0x800F9370 : AT(0x000F9F70) { FILL(0x00000000); build/asm/main_800F9370.s.o(.text); build/asm/main_800F9370.s.o(.rodata); build/asm/main_800F9370.s.o(.data); }
    .main_800F9370_bss (NOLOAD) : { build/asm/main_800F9370.s.o(.bss); }
    .main_800F94B4 0x800F94B4 : AT(0x000FA0B4) { build/asm/data/main_800F94B4.bin.o(.data); }
    .main_800FB9B0 0x800FB9B0 : AT(0x000FC5B0) { FILL(0x00000000); build/asm/main_800FB9B0.s.o(.text); build/asm/main_800FB9B0.s.o(.rodata); build/asm/main_800FB9B0.s.o(.data); }
    .main_800FB9B0_bss (NOLOAD) : { build/asm/main_800FB9B0.s.o(.bss); }
    .main_800FB9C8 0x800FB9C8 : AT(0x000FC5C8) { build/asm/data/main_800FB9C8.bin.o(.data); }
    .main_800FBC38 0x800FBC38 : AT(0x000FC838) { FILL(0x00000000); build/asm/main_800FBC38.s.o(.text); build/asm/main_800FBC38.s.o(.rodata); build/asm/main_800FBC38.s.o(.data); }
    .main_800FBC38_bss (NOLOAD) : { build/asm/main_800FBC38.s.o(.bss); }
    .main_800FBE68 0x800FBE68 : AT(0x000FCA68) { build/asm/data/main_800FBE68.bin.o(.data); }
    .main_800FC448 0x800FC448 : AT(0x000FD048) { FILL(0x00000000); build/asm/main_800FC448.s.o(.text); build/asm/main_800FC448.s.o(.rodata); build/asm/main_800FC448.s.o(.data); }
    .main_800FC448_bss (NOLOAD) : { build/asm/main_800FC448.s.o(.bss); }
    .main_800FC688 0x800FC688 : AT(0x000FD288) { build/asm/data/main_800FC688.bin.o(.data); }
    .main_800FCE18 0x800FCE18 : AT(0x000FDA18) { FILL(0x00000000); build/asm/main_800FCE18.s.o(.text); build/asm/main_800FCE18.s.o(.rodata); build/asm/main_800FCE18.s.o(.data); }
    .main_800FCE18_bss (NOLOAD) : { build/asm/main_800FCE18.s.o(.bss); }
    .main_800FD810 0x800FD810 : AT(0x000FE410) { build/asm/data/main_800FD810.bin.o(.data); }
    .main_800FD868 0x800FD868 : AT(0x000FE468) { FILL(0x00000000); build/asm/main_800FD868.s.o(.text); build/asm/main_800FD868.s.o(.rodata); build/asm/main_800FD868.s.o(.data); }
    .main_800FD868_bss (NOLOAD) : { build/asm/main_800FD868.s.o(.bss); }
    .main_800FDC78 0x800FDC78 : AT(0x000FE878) { build/asm/data/main_800FDC78.bin.o(.data); }
    .main_800FE210 0x800FE210 : AT(0x000FEE10) { FILL(0x00000000); build/asm/main_800FE210.s.o(.text); build/asm/main_800FE210.s.o(.rodata); build/asm/main_800FE210.s.o(.data); }
    .main_800FE210_bss (NOLOAD) : { build/asm/main_800FE210.s.o(.bss); }
    .main_800FE228 0x800FE228 : AT(0x000FEE28) { build/asm/data/main_800FE228.bin.o(.data); }
    .main_800FEE10 0x800FEE10 : AT(0x000FFA10) { FILL(0x00000000); build/asm/main_800FEE10.s.o(.text); build/asm/main_800FEE10.s.o(.rodata); build/asm/main_800FEE10.s.o(.data); }
    .main_800FEE10_bss (NOLOAD) : { build/asm/main_800FEE10.s.o(.bss); }
    .main_800FEE50 0x800FEE50 : AT(0x000FFA50) { build/asm/data/main_800FEE50.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
