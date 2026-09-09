SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80006000 0x80006000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80006000.s.o(.text); build/asm/main_80006000.s.o(.rodata); build/asm/main_80006000.s.o(.data); }
    .main_80006000_bss (NOLOAD) : { build/asm/main_80006000.s.o(.bss); }
    .main_80006840 0x80006840 : AT(0x00001840) { FILL(0x00000000); build/asm/main_80006840.s.o(.text); build/asm/main_80006840.s.o(.rodata); build/asm/main_80006840.s.o(.data); }
    .main_80006840_bss (NOLOAD) : { build/asm/main_80006840.s.o(.bss); }
    .main_800889C0 0x800889C0 : AT(0x000839C0) { build/asm/data/main_800889C0.bin.o(.data); }
    .main_8008C220 0x8008C220 : AT(0x00087220) { FILL(0x00000000); build/asm/main_8008C220.s.o(.text); build/asm/main_8008C220.s.o(.rodata); build/asm/main_8008C220.s.o(.data); }
    .main_8008C220_bss (NOLOAD) : { build/asm/main_8008C220.s.o(.bss); }
    .main_8009A4A0 0x8009A4A0 : AT(0x000954A0) { build/asm/data/main_8009A4A0.bin.o(.data); }
    .main_8009A640 0x8009A640 : AT(0x00095640) { FILL(0x00000000); build/asm/main_8009A640.s.o(.text); build/asm/main_8009A640.s.o(.rodata); build/asm/main_8009A640.s.o(.data); }
    .main_8009A640_bss (NOLOAD) : { build/asm/main_8009A640.s.o(.bss); }
    .main_800A06C0 0x800A06C0 : AT(0x0009B6C0) { build/asm/data/main_800A06C0.bin.o(.data); }
    .main_800A06E0 0x800A06E0 : AT(0x0009B6E0) { FILL(0x00000000); build/asm/main_800A06E0.s.o(.text); build/asm/main_800A06E0.s.o(.rodata); build/asm/main_800A06E0.s.o(.data); }
    .main_800A06E0_bss (NOLOAD) : { build/asm/main_800A06E0.s.o(.bss); }
    .main_800A0820 0x800A0820 : AT(0x0009B820) { build/asm/data/main_800A0820.bin.o(.data); }
    .main_800A3E84 0x800A3E84 : AT(0x0009EE84) { FILL(0x00000000); build/asm/main_800A3E84.s.o(.text); build/asm/main_800A3E84.s.o(.rodata); build/asm/main_800A3E84.s.o(.data); }
    .main_800A3E84_bss (NOLOAD) : { build/asm/main_800A3E84.s.o(.bss); }
    .main_800A4634 0x800A4634 : AT(0x0009F634) { build/asm/data/main_800A4634.bin.o(.data); }
    .main_800A9A60 0x800A9A60 : AT(0x000A4A60) { FILL(0x00000000); build/asm/main_800A9A60.s.o(.text); build/asm/main_800A9A60.s.o(.rodata); build/asm/main_800A9A60.s.o(.data); }
    .main_800A9A60_bss (NOLOAD) : { build/asm/main_800A9A60.s.o(.bss); }
    .main_800A9AD0 0x800A9AD0 : AT(0x000A4AD0) { build/asm/data/main_800A9AD0.bin.o(.data); }
    .main_800AA260 0x800AA260 : AT(0x000A5260) { FILL(0x00000000); build/asm/main_800AA260.s.o(.text); build/asm/main_800AA260.s.o(.rodata); build/asm/main_800AA260.s.o(.data); }
    .main_800AA260_bss (NOLOAD) : { build/asm/main_800AA260.s.o(.bss); }
    .main_800AA72C 0x800AA72C : AT(0x000A572C) { build/asm/data/main_800AA72C.bin.o(.data); }
    .main_800E58D4 0x800E58D4 : AT(0x000E08D4) { FILL(0x00000000); build/asm/main_800E58D4.s.o(.text); build/asm/main_800E58D4.s.o(.rodata); build/asm/main_800E58D4.s.o(.data); }
    .main_800E58D4_bss (NOLOAD) : { build/asm/main_800E58D4.s.o(.bss); }
    .main_800E59B0 0x800E59B0 : AT(0x000E09B0) { build/asm/data/main_800E59B0.bin.o(.data); }
    .main_800E6CF0 0x800E6CF0 : AT(0x000E1CF0) { FILL(0x00000000); build/asm/main_800E6CF0.s.o(.text); build/asm/main_800E6CF0.s.o(.rodata); build/asm/main_800E6CF0.s.o(.data); }
    .main_800E6CF0_bss (NOLOAD) : { build/asm/main_800E6CF0.s.o(.bss); }
    .main_800E6D88 0x800E6D88 : AT(0x000E1D88) { build/asm/data/main_800E6D88.bin.o(.data); }
    .main_800E704C 0x800E704C : AT(0x000E204C) { FILL(0x00000000); build/asm/main_800E704C.s.o(.text); build/asm/main_800E704C.s.o(.rodata); build/asm/main_800E704C.s.o(.data); }
    .main_800E704C_bss (NOLOAD) : { build/asm/main_800E704C.s.o(.bss); }
    .main_800E7050 0x800E7050 : AT(0x000E2050) { build/asm/data/main_800E7050.bin.o(.data); }
    .main_800E7364 0x800E7364 : AT(0x000E2364) { FILL(0x00000000); build/asm/main_800E7364.s.o(.text); build/asm/main_800E7364.s.o(.rodata); build/asm/main_800E7364.s.o(.data); }
    .main_800E7364_bss (NOLOAD) : { build/asm/main_800E7364.s.o(.bss); }
    .main_800E7388 0x800E7388 : AT(0x000E2388) { build/asm/data/main_800E7388.bin.o(.data); }
    .main_800E85DC 0x800E85DC : AT(0x000E35DC) { FILL(0x00000000); build/asm/main_800E85DC.s.o(.text); build/asm/main_800E85DC.s.o(.rodata); build/asm/main_800E85DC.s.o(.data); }
    .main_800E85DC_bss (NOLOAD) : { build/asm/main_800E85DC.s.o(.bss); }
    .main_800E85E4 0x800E85E4 : AT(0x000E35E4) { build/asm/data/main_800E85E4.bin.o(.data); }
    .main_800EA5AC 0x800EA5AC : AT(0x000E55AC) { FILL(0x00000000); build/asm/main_800EA5AC.s.o(.text); build/asm/main_800EA5AC.s.o(.rodata); build/asm/main_800EA5AC.s.o(.data); }
    .main_800EA5AC_bss (NOLOAD) : { build/asm/main_800EA5AC.s.o(.bss); }
    .main_800EA688 0x800EA688 : AT(0x000E5688) { build/asm/data/main_800EA688.bin.o(.data); }
    .main_800EA7CC 0x800EA7CC : AT(0x000E57CC) { FILL(0x00000000); build/asm/main_800EA7CC.s.o(.text); build/asm/main_800EA7CC.s.o(.rodata); build/asm/main_800EA7CC.s.o(.data); }
    .main_800EA7CC_bss (NOLOAD) : { build/asm/main_800EA7CC.s.o(.bss); }
    .main_800EA80C 0x800EA80C : AT(0x000E580C) { build/asm/data/main_800EA80C.bin.o(.data); }
    .main_800EA964 0x800EA964 : AT(0x000E5964) { FILL(0x00000000); build/asm/main_800EA964.s.o(.text); build/asm/main_800EA964.s.o(.rodata); build/asm/main_800EA964.s.o(.data); }
    .main_800EA964_bss (NOLOAD) : { build/asm/main_800EA964.s.o(.bss); }
    .main_800EA99C 0x800EA99C : AT(0x000E599C) { build/asm/data/main_800EA99C.bin.o(.data); }
    .main_800EB384 0x800EB384 : AT(0x000E6384) { FILL(0x00000000); build/asm/main_800EB384.s.o(.text); build/asm/main_800EB384.s.o(.rodata); build/asm/main_800EB384.s.o(.data); }
    .main_800EB384_bss (NOLOAD) : { build/asm/main_800EB384.s.o(.bss); }
    .main_800EB3A0 0x800EB3A0 : AT(0x000E63A0) { build/asm/data/main_800EB3A0.bin.o(.data); }
    .main_800EC448 0x800EC448 : AT(0x000E7448) { FILL(0x00000000); build/asm/main_800EC448.s.o(.text); build/asm/main_800EC448.s.o(.rodata); build/asm/main_800EC448.s.o(.data); }
    .main_800EC448_bss (NOLOAD) : { build/asm/main_800EC448.s.o(.bss); }
    .main_800EC458 0x800EC458 : AT(0x000E7458) { build/asm/data/main_800EC458.bin.o(.data); }
    .main_800EC66C 0x800EC66C : AT(0x000E766C) { FILL(0x00000000); build/asm/main_800EC66C.s.o(.text); build/asm/main_800EC66C.s.o(.rodata); build/asm/main_800EC66C.s.o(.data); }
    .main_800EC66C_bss (NOLOAD) : { build/asm/main_800EC66C.s.o(.bss); }
    .main_800EC708 0x800EC708 : AT(0x000E7708) { build/asm/data/main_800EC708.bin.o(.data); }
    .main_800EED5C 0x800EED5C : AT(0x000E9D5C) { FILL(0x00000000); build/asm/main_800EED5C.s.o(.text); build/asm/main_800EED5C.s.o(.rodata); build/asm/main_800EED5C.s.o(.data); }
    .main_800EED5C_bss (NOLOAD) : { build/asm/main_800EED5C.s.o(.bss); }
    .main_800EEED8 0x800EEED8 : AT(0x000E9ED8) { build/asm/data/main_800EEED8.bin.o(.data); }
    .main_800EF798 0x800EF798 : AT(0x000EA798) { FILL(0x00000000); build/asm/main_800EF798.s.o(.text); build/asm/main_800EF798.s.o(.rodata); build/asm/main_800EF798.s.o(.data); }
    .main_800EF798_bss (NOLOAD) : { build/asm/main_800EF798.s.o(.bss); }
    .main_800EF920 0x800EF920 : AT(0x000EA920) { build/asm/data/main_800EF920.bin.o(.data); }
    .main_800F1ED8 0x800F1ED8 : AT(0x000ECED8) { FILL(0x00000000); build/asm/main_800F1ED8.s.o(.text); build/asm/main_800F1ED8.s.o(.rodata); build/asm/main_800F1ED8.s.o(.data); }
    .main_800F1ED8_bss (NOLOAD) : { build/asm/main_800F1ED8.s.o(.bss); }
    .main_800F1F08 0x800F1F08 : AT(0x000ECF08) { build/asm/data/main_800F1F08.bin.o(.data); }
    .main_800F1FAC 0x800F1FAC : AT(0x000ECFAC) { FILL(0x00000000); build/asm/main_800F1FAC.s.o(.text); build/asm/main_800F1FAC.s.o(.rodata); build/asm/main_800F1FAC.s.o(.data); }
    .main_800F1FAC_bss (NOLOAD) : { build/asm/main_800F1FAC.s.o(.bss); }
    .main_800F2030 0x800F2030 : AT(0x000ED030) { build/asm/data/main_800F2030.bin.o(.data); }
    .main_800F2B40 0x800F2B40 : AT(0x000EDB40) { FILL(0x00000000); build/asm/main_800F2B40.s.o(.text); build/asm/main_800F2B40.s.o(.rodata); build/asm/main_800F2B40.s.o(.data); }
    .main_800F2B40_bss (NOLOAD) : { build/asm/main_800F2B40.s.o(.bss); }
    .main_800F2F80 0x800F2F80 : AT(0x000EDF80) { build/asm/data/main_800F2F80.bin.o(.data); }
    .main_800F3108 0x800F3108 : AT(0x000EE108) { FILL(0x00000000); build/asm/main_800F3108.s.o(.text); build/asm/main_800F3108.s.o(.rodata); build/asm/main_800F3108.s.o(.data); }
    .main_800F3108_bss (NOLOAD) : { build/asm/main_800F3108.s.o(.bss); }
    .main_800F3574 0x800F3574 : AT(0x000EE574) { build/asm/data/main_800F3574.bin.o(.data); }
    .main_800F54B0 0x800F54B0 : AT(0x000F04B0) { FILL(0x00000000); build/asm/main_800F54B0.s.o(.text); build/asm/main_800F54B0.s.o(.rodata); build/asm/main_800F54B0.s.o(.data); }
    .main_800F54B0_bss (NOLOAD) : { build/asm/main_800F54B0.s.o(.bss); }
    .main_800F54C4 0x800F54C4 : AT(0x000F04C4) { build/asm/data/main_800F54C4.bin.o(.data); }
    .main_800F6DAC 0x800F6DAC : AT(0x000F1DAC) { FILL(0x00000000); build/asm/main_800F6DAC.s.o(.text); build/asm/main_800F6DAC.s.o(.rodata); build/asm/main_800F6DAC.s.o(.data); }
    .main_800F6DAC_bss (NOLOAD) : { build/asm/main_800F6DAC.s.o(.bss); }
    .main_800F6E08 0x800F6E08 : AT(0x000F1E08) { build/asm/data/main_800F6E08.bin.o(.data); }
    .main_800F86B4 0x800F86B4 : AT(0x000F36B4) { FILL(0x00000000); build/asm/main_800F86B4.s.o(.text); build/asm/main_800F86B4.s.o(.rodata); build/asm/main_800F86B4.s.o(.data); }
    .main_800F86B4_bss (NOLOAD) : { build/asm/main_800F86B4.s.o(.bss); }
    .main_800F86B8 0x800F86B8 : AT(0x000F36B8) { build/asm/data/main_800F86B8.bin.o(.data); }
    .main_800F947C 0x800F947C : AT(0x000F447C) { FILL(0x00000000); build/asm/main_800F947C.s.o(.text); build/asm/main_800F947C.s.o(.rodata); build/asm/main_800F947C.s.o(.data); }
    .main_800F947C_bss (NOLOAD) : { build/asm/main_800F947C.s.o(.bss); }
    .main_800F9488 0x800F9488 : AT(0x000F4488) { build/asm/data/main_800F9488.bin.o(.data); }
    .main_800FBE8C 0x800FBE8C : AT(0x000F6E8C) { FILL(0x00000000); build/asm/main_800FBE8C.s.o(.text); build/asm/main_800FBE8C.s.o(.rodata); build/asm/main_800FBE8C.s.o(.data); }
    .main_800FBE8C_bss (NOLOAD) : { build/asm/main_800FBE8C.s.o(.bss); }
    .main_800FBEAC 0x800FBEAC : AT(0x000F6EAC) { build/asm/data/main_800FBEAC.bin.o(.data); }
    .main_800FC44C 0x800FC44C : AT(0x000F744C) { FILL(0x00000000); build/asm/main_800FC44C.s.o(.text); build/asm/main_800FC44C.s.o(.rodata); build/asm/main_800FC44C.s.o(.data); }
    .main_800FC44C_bss (NOLOAD) : { build/asm/main_800FC44C.s.o(.bss); }
    .main_800FC48C 0x800FC48C : AT(0x000F748C) { build/asm/data/main_800FC48C.bin.o(.data); }
    .main_800FDA6C 0x800FDA6C : AT(0x000F8A6C) { FILL(0x00000000); build/asm/main_800FDA6C.s.o(.text); build/asm/main_800FDA6C.s.o(.rodata); build/asm/main_800FDA6C.s.o(.data); }
    .main_800FDA6C_bss (NOLOAD) : { build/asm/main_800FDA6C.s.o(.bss); }
    .main_800FDA78 0x800FDA78 : AT(0x000F8A78) { build/asm/data/main_800FDA78.bin.o(.data); }
    .main_80104480 0x80104480 : AT(0x000FF480) { FILL(0x00000000); build/asm/main_80104480.s.o(.text); build/asm/main_80104480.s.o(.rodata); build/asm/main_80104480.s.o(.data); }
    .main_80104480_bss (NOLOAD) : { build/asm/main_80104480.s.o(.bss); }
    .main_80104484 0x80104484 : AT(0x000FF484) { build/asm/data/main_80104484.bin.o(.data); }
    .main_8010461C 0x8010461C : AT(0x000FF61C) { FILL(0x00000000); build/asm/main_8010461C.s.o(.text); build/asm/main_8010461C.s.o(.rodata); build/asm/main_8010461C.s.o(.data); }
    .main_8010461C_bss (NOLOAD) : { build/asm/main_8010461C.s.o(.bss); }
    .main_80104620 0x80104620 : AT(0x000FF620) { build/asm/data/main_80104620.bin.o(.data); }
    .main_8010469C 0x8010469C : AT(0x000FF69C) { FILL(0x00000000); build/asm/main_8010469C.s.o(.text); build/asm/main_8010469C.s.o(.rodata); build/asm/main_8010469C.s.o(.data); }
    .main_8010469C_bss (NOLOAD) : { build/asm/main_8010469C.s.o(.bss); }
    .main_801046A0 0x801046A0 : AT(0x000FF6A0) { build/asm/data/main_801046A0.bin.o(.data); }
    .main_801049DC 0x801049DC : AT(0x000FF9DC) { FILL(0x00000000); build/asm/main_801049DC.s.o(.text); build/asm/main_801049DC.s.o(.rodata); build/asm/main_801049DC.s.o(.data); }
    .main_801049DC_bss (NOLOAD) : { build/asm/main_801049DC.s.o(.bss); }
    .main_801049E8 0x801049E8 : AT(0x000FF9E8) { build/asm/data/main_801049E8.bin.o(.data); }
    .main_80104A5C 0x80104A5C : AT(0x000FFA5C) { FILL(0x00000000); build/asm/main_80104A5C.s.o(.text); build/asm/main_80104A5C.s.o(.rodata); build/asm/main_80104A5C.s.o(.data); }
    .main_80104A5C_bss (NOLOAD) : { build/asm/main_80104A5C.s.o(.bss); }
    .main_80104A68 0x80104A68 : AT(0x000FFA68) { build/asm/data/main_80104A68.bin.o(.data); }
    .assets 0x80406000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
