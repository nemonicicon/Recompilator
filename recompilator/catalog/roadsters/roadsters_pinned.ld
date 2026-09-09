SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004E8 0x800004E8 : AT(0x000010E8) { FILL(0x00000000); build/asm/main_800004E8.s.o(.text); build/asm/main_800004E8.s.o(.rodata); build/asm/main_800004E8.s.o(.data); }
    .main_800004E8_bss (NOLOAD) : { build/asm/main_800004E8.s.o(.bss); }
    .main_8004F574 0x8004F574 : AT(0x00050174) { FILL(0x00000000); build/asm/main_8004F574.s.o(.text); build/asm/main_8004F574.s.o(.rodata); build/asm/main_8004F574.s.o(.data); }
    .main_8004F574_bss (NOLOAD) : { build/asm/main_8004F574.s.o(.bss); }
    .main_8004F940 0x8004F940 : AT(0x00050540) { FILL(0x00000000); build/asm/main_8004F940.s.o(.text); build/asm/main_8004F940.s.o(.rodata); build/asm/main_8004F940.s.o(.data); }
    .main_8004F940_bss (NOLOAD) : { build/asm/main_8004F940.s.o(.bss); }
    .main_80062454 0x80062454 : AT(0x00063054) { FILL(0x00000000); build/asm/main_80062454.s.o(.text); build/asm/main_80062454.s.o(.rodata); build/asm/main_80062454.s.o(.data); }
    .main_80062454_bss (NOLOAD) : { build/asm/main_80062454.s.o(.bss); }
    .main_80068250 0x80068250 : AT(0x00068E50) { FILL(0x00000000); build/asm/data/main_80068250.data.s.o(.data); }
    .main_80068D68 0x80068D68 : AT(0x00069968) { FILL(0x00000000); build/asm/main_80068D68.s.o(.text); build/asm/main_80068D68.s.o(.rodata); build/asm/main_80068D68.s.o(.data); }
    .main_80068D68_bss (NOLOAD) : { build/asm/main_80068D68.s.o(.bss); }
    .main_80068DF8 0x80068DF8 : AT(0x000699F8) { FILL(0x00000000); build/asm/data/main_80068DF8.data.s.o(.data); }
    .main_80068FF0 0x80068FF0 : AT(0x00069BF0) { FILL(0x00000000); build/asm/main_80068FF0.s.o(.text); build/asm/main_80068FF0.s.o(.rodata); build/asm/main_80068FF0.s.o(.data); }
    .main_80068FF0_bss (NOLOAD) : { build/asm/main_80068FF0.s.o(.bss); }
    .main_800691B8 0x800691B8 : AT(0x00069DB8) { FILL(0x00000000); build/asm/main_800691B8.s.o(.text); build/asm/main_800691B8.s.o(.rodata); build/asm/main_800691B8.s.o(.data); }
    .main_800691B8_bss (NOLOAD) : { build/asm/main_800691B8.s.o(.bss); }
    .main_800691D8 0x800691D8 : AT(0x00069DD8) { FILL(0x00000000); build/asm/main_800691D8.s.o(.text); build/asm/main_800691D8.s.o(.rodata); build/asm/main_800691D8.s.o(.data); }
    .main_800691D8_bss (NOLOAD) : { build/asm/main_800691D8.s.o(.bss); }
    .main_80069278 0x80069278 : AT(0x00069E78) { FILL(0x00000000); build/asm/data/main_80069278.data.s.o(.data); }
    .main_80069500 0x80069500 : AT(0x0006A100) { FILL(0x00000000); build/asm/data/main_80069500.data.s.o(.data); }
    .main_8006E014 0x8006E014 : AT(0x0006EC14) { FILL(0x00000000); build/asm/main_8006E014.s.o(.text); build/asm/main_8006E014.s.o(.rodata); build/asm/main_8006E014.s.o(.data); }
    .main_8006E014_bss (NOLOAD) : { build/asm/main_8006E014.s.o(.bss); }
    .main_8006E298 0x8006E298 : AT(0x0006EE98) { FILL(0x00000000); build/asm/data/main_8006E298.data.s.o(.data); }
    .main_8007606C 0x8007606C : AT(0x00076C6C) { FILL(0x00000000); build/asm/main_8007606C.s.o(.text); build/asm/main_8007606C.s.o(.rodata); build/asm/main_8007606C.s.o(.data); }
    .main_8007606C_bss (NOLOAD) : { build/asm/main_8007606C.s.o(.bss); }
    .main_800761A8 0x800761A8 : AT(0x00076DA8) { FILL(0x00000000); build/asm/data/main_800761A8.data.s.o(.data); }
    .main_800785E4 0x800785E4 : AT(0x000791E4) { FILL(0x00000000); build/asm/main_800785E4.s.o(.text); build/asm/main_800785E4.s.o(.rodata); build/asm/main_800785E4.s.o(.data); }
    .main_800785E4_bss (NOLOAD) : { build/asm/main_800785E4.s.o(.bss); }
    .main_80078720 0x80078720 : AT(0x00079320) { FILL(0x00000000); build/asm/data/main_80078720.data.s.o(.data); }
    .main_80080038 0x80080038 : AT(0x00080C38) { FILL(0x00000000); build/asm/main_80080038.s.o(.text); build/asm/main_80080038.s.o(.rodata); build/asm/main_80080038.s.o(.data); }
    .main_80080038_bss (NOLOAD) : { build/asm/main_80080038.s.o(.bss); }
    .main_80083438 0x80083438 : AT(0x00084038) { FILL(0x00000000); build/asm/data/main_80083438.data.s.o(.data); }
    .main_80091BC4 0x80091BC4 : AT(0x000927C4) { FILL(0x00000000); build/asm/data/main_80091BC4.data.s.o(.data); }
    .main_8009C698 0x8009C698 : AT(0x0009D298) { FILL(0x00000000); build/asm/main_8009C698.s.o(.text); build/asm/main_8009C698.s.o(.rodata); build/asm/main_8009C698.s.o(.data); }
    .main_8009C698_bss (NOLOAD) : { build/asm/main_8009C698.s.o(.bss); }
    .main_8009C90C 0x8009C90C : AT(0x0009D50C) { FILL(0x00000000); build/asm/data/main_8009C90C.data.s.o(.data); }
    .main_8009C974 0x8009C974 : AT(0x0009D574) { FILL(0x00000000); build/asm/main_8009C974.s.o(.text); build/asm/main_8009C974.s.o(.rodata); build/asm/main_8009C974.s.o(.data); }
    .main_8009C974_bss (NOLOAD) : { build/asm/main_8009C974.s.o(.bss); }
    .main_8009C9DC 0x8009C9DC : AT(0x0009D5DC) { FILL(0x00000000); build/asm/data/main_8009C9DC.data.s.o(.data); }
    .main_8009CAAC 0x8009CAAC : AT(0x0009D6AC) { FILL(0x00000000); build/asm/main_8009CAAC.s.o(.text); build/asm/main_8009CAAC.s.o(.rodata); build/asm/main_8009CAAC.s.o(.data); }
    .main_8009CAAC_bss (NOLOAD) : { build/asm/main_8009CAAC.s.o(.bss); }
    .main_8009CB14 0x8009CB14 : AT(0x0009D714) { FILL(0x00000000); build/asm/data/main_8009CB14.data.s.o(.data); }
    .main_8009CB7C 0x8009CB7C : AT(0x0009D77C) { FILL(0x00000000); build/asm/main_8009CB7C.s.o(.text); build/asm/main_8009CB7C.s.o(.rodata); build/asm/main_8009CB7C.s.o(.data); }
    .main_8009CB7C_bss (NOLOAD) : { build/asm/main_8009CB7C.s.o(.bss); }
    .main_8009CBE4 0x8009CBE4 : AT(0x0009D7E4) { FILL(0x00000000); build/asm/data/main_8009CBE4.data.s.o(.data); }
    .main_8009CC4C 0x8009CC4C : AT(0x0009D84C) { FILL(0x00000000); build/asm/main_8009CC4C.s.o(.text); build/asm/main_8009CC4C.s.o(.rodata); build/asm/main_8009CC4C.s.o(.data); }
    .main_8009CC4C_bss (NOLOAD) : { build/asm/main_8009CC4C.s.o(.bss); }
    .main_8009D0C4 0x8009D0C4 : AT(0x0009DCC4) { FILL(0x00000000); build/asm/data/main_8009D0C4.data.s.o(.data); }
    .main_8009D12C 0x8009D12C : AT(0x0009DD2C) { FILL(0x00000000); build/asm/main_8009D12C.s.o(.text); build/asm/main_8009D12C.s.o(.rodata); build/asm/main_8009D12C.s.o(.data); }
    .main_8009D12C_bss (NOLOAD) : { build/asm/main_8009D12C.s.o(.bss); }
    .main_8009D194 0x8009D194 : AT(0x0009DD94) { FILL(0x00000000); build/asm/data/main_8009D194.data.s.o(.data); }
    .main_8009D1FC 0x8009D1FC : AT(0x0009DDFC) { FILL(0x00000000); build/asm/main_8009D1FC.s.o(.text); build/asm/main_8009D1FC.s.o(.rodata); build/asm/main_8009D1FC.s.o(.data); }
    .main_8009D1FC_bss (NOLOAD) : { build/asm/main_8009D1FC.s.o(.bss); }
    .main_8009D964 0x8009D964 : AT(0x0009E564) { FILL(0x00000000); build/asm/data/main_8009D964.data.s.o(.data); }
    .main_800A240C 0x800A240C : AT(0x000A300C) { FILL(0x00000000); build/asm/main_800A240C.s.o(.text); build/asm/main_800A240C.s.o(.rodata); build/asm/main_800A240C.s.o(.data); }
    .main_800A240C_bss (NOLOAD) : { build/asm/main_800A240C.s.o(.bss); }
    .main_800A246C 0x800A246C : AT(0x000A306C) { FILL(0x00000000); build/asm/data/main_800A246C.data.s.o(.data); }
    .main_800A27E8 0x800A27E8 : AT(0x000A33E8) { FILL(0x00000000); build/asm/main_800A27E8.s.o(.text); build/asm/main_800A27E8.s.o(.rodata); build/asm/main_800A27E8.s.o(.data); }
    .main_800A27E8_bss (NOLOAD) : { build/asm/main_800A27E8.s.o(.bss); }
    .main_800A2D88 0x800A2D88 : AT(0x000A3988) { FILL(0x00000000); build/asm/data/main_800A2D88.data.s.o(.data); }
    .main_800A2DD4 0x800A2DD4 : AT(0x000A39D4) { FILL(0x00000000); build/asm/main_800A2DD4.s.o(.text); build/asm/main_800A2DD4.s.o(.rodata); build/asm/main_800A2DD4.s.o(.data); }
    .main_800A2DD4_bss (NOLOAD) : { build/asm/main_800A2DD4.s.o(.bss); }
    .main_800A4664 0x800A4664 : AT(0x000A5264) { FILL(0x00000000); build/asm/data/main_800A4664.data.s.o(.data); }
    .main_800A4750 0x800A4750 : AT(0x000A5350) { FILL(0x00000000); build/asm/main_800A4750.s.o(.text); build/asm/main_800A4750.s.o(.rodata); build/asm/main_800A4750.s.o(.data); }
    .main_800A4750_bss (NOLOAD) : { build/asm/main_800A4750.s.o(.bss); }
    .main_800A4830 0x800A4830 : AT(0x000A5430) { FILL(0x00000000); build/asm/data/main_800A4830.data.s.o(.data); }
    .main_800A4F8C 0x800A4F8C : AT(0x000A5B8C) { FILL(0x00000000); build/asm/main_800A4F8C.s.o(.text); build/asm/main_800A4F8C.s.o(.rodata); build/asm/main_800A4F8C.s.o(.data); }
    .main_800A4F8C_bss (NOLOAD) : { build/asm/main_800A4F8C.s.o(.bss); }
    .main_800A5490 0x800A5490 : AT(0x000A6090) { FILL(0x00000000); build/asm/data/main_800A5490.data.s.o(.data); }
    .main_800A5BE0 0x800A5BE0 : AT(0x000A67E0) { FILL(0x00000000); build/asm/main_800A5BE0.s.o(.text); build/asm/main_800A5BE0.s.o(.rodata); build/asm/main_800A5BE0.s.o(.data); }
    .main_800A5BE0_bss (NOLOAD) : { build/asm/main_800A5BE0.s.o(.bss); }
    .main_800A5EAC 0x800A5EAC : AT(0x000A6AAC) { FILL(0x00000000); build/asm/data/main_800A5EAC.data.s.o(.data); }
    .main_800A79F8 0x800A79F8 : AT(0x000A85F8) { FILL(0x00000000); build/asm/main_800A79F8.s.o(.text); build/asm/main_800A79F8.s.o(.rodata); build/asm/main_800A79F8.s.o(.data); }
    .main_800A79F8_bss (NOLOAD) : { build/asm/main_800A79F8.s.o(.bss); }
    .main_800A7A24 0x800A7A24 : AT(0x000A8624) { FILL(0x00000000); build/asm/data/main_800A7A24.data.s.o(.data); }
    .main_800A8EE4 0x800A8EE4 : AT(0x000A9AE4) { FILL(0x00000000); build/asm/main_800A8EE4.s.o(.text); build/asm/main_800A8EE4.s.o(.rodata); build/asm/main_800A8EE4.s.o(.data); }
    .main_800A8EE4_bss (NOLOAD) : { build/asm/main_800A8EE4.s.o(.bss); }
    .main_800A8EEC 0x800A8EEC : AT(0x000A9AEC) { FILL(0x00000000); build/asm/data/main_800A8EEC.data.s.o(.data); }
    .main_800AF4A4 0x800AF4A4 : AT(0x000B00A4) { FILL(0x00000000); build/asm/main_800AF4A4.s.o(.text); build/asm/main_800AF4A4.s.o(.rodata); build/asm/main_800AF4A4.s.o(.data); }
    .main_800AF4A4_bss (NOLOAD) : { build/asm/main_800AF4A4.s.o(.bss); }
    .main_800C0400 0x800C0400 : AT(0x000C1000) { FILL(0x00000000); build/asm/main_800C0400.s.o(.text); build/asm/main_800C0400.s.o(.rodata); build/asm/main_800C0400.s.o(.data); }
    .main_800C0400_bss (NOLOAD) : { build/asm/main_800C0400.s.o(.bss); }
    .main_800D5110 0x800D5110 : AT(0x000D5D10) { FILL(0x00000000); build/asm/data/main_800D5110.data.s.o(.data); }
    .main_800E13CC 0x800E13CC : AT(0x000E1FCC) { FILL(0x00000000); build/asm/main_800E13CC.s.o(.text); build/asm/main_800E13CC.s.o(.rodata); build/asm/main_800E13CC.s.o(.data); }
    .main_800E13CC_bss (NOLOAD) : { build/asm/main_800E13CC.s.o(.bss); }
    .main_800E1F34 0x800E1F34 : AT(0x000E2B34) { FILL(0x00000000); build/asm/data/main_800E1F34.data.s.o(.data); }
    .main_800E30F0 0x800E30F0 : AT(0x000E3CF0) { FILL(0x00000000); build/asm/main_800E30F0.s.o(.text); build/asm/main_800E30F0.s.o(.rodata); build/asm/main_800E30F0.s.o(.data); }
    .main_800E30F0_bss (NOLOAD) : { build/asm/main_800E30F0.s.o(.bss); }
    .main_800E3740 0x800E3740 : AT(0x000E4340) { FILL(0x00000000); build/asm/data/main_800E3740.data.s.o(.data); }
    .main_800E45A8 0x800E45A8 : AT(0x000E51A8) { FILL(0x00000000); build/asm/main_800E45A8.s.o(.text); build/asm/main_800E45A8.s.o(.rodata); build/asm/main_800E45A8.s.o(.data); }
    .main_800E45A8_bss (NOLOAD) : { build/asm/main_800E45A8.s.o(.bss); }
    .main_800E573C 0x800E573C : AT(0x000E633C) { FILL(0x00000000); build/asm/data/main_800E573C.data.s.o(.data); }
    .main_8010005C 0x8010005C : AT(0x00100C5C) { FILL(0x00000000); build/asm/main_8010005C.s.o(.text); build/asm/main_8010005C.s.o(.rodata); build/asm/main_8010005C.s.o(.data); }
    .main_8010005C_bss (NOLOAD) : { build/asm/main_8010005C.s.o(.bss); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
