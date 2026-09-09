SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800627DC 0x800627DC : AT(0x000633DC) { FILL(0x00000000); build/asm/main_800627DC.s.o(.text); build/asm/main_800627DC.s.o(.rodata); build/asm/main_800627DC.s.o(.data); }
    .main_800627DC_bss (NOLOAD) : { build/asm/main_800627DC.s.o(.bss); }
    .main_80062BC0 0x80062BC0 : AT(0x000637C0) { FILL(0x00000000); build/asm/main_80062BC0.s.o(.text); build/asm/main_80062BC0.s.o(.rodata); build/asm/main_80062BC0.s.o(.data); }
    .main_80062BC0_bss (NOLOAD) : { build/asm/main_80062BC0.s.o(.bss); }
    .main_8006C8A8 0x8006C8A8 : AT(0x0006D4A8) { build/asm/data/main_8006C8A8.bin.o(.data); }
    .main_8006C8B0 0x8006C8B0 : AT(0x0006D4B0) { FILL(0x00000000); build/asm/main_8006C8B0.s.o(.text); build/asm/main_8006C8B0.s.o(.rodata); build/asm/main_8006C8B0.s.o(.data); }
    .main_8006C8B0_bss (NOLOAD) : { build/asm/main_8006C8B0.s.o(.bss); }
    .main_80074320 0x80074320 : AT(0x00074F20) { FILL(0x00000000); build/asm/main_80074320.s.o(.text); build/asm/main_80074320.s.o(.rodata); build/asm/main_80074320.s.o(.data); }
    .main_80074320_bss (NOLOAD) : { build/asm/main_80074320.s.o(.bss); }
    .main_80074378 0x80074378 : AT(0x00074F78) { FILL(0x00000000); build/asm/main_80074378.s.o(.text); build/asm/main_80074378.s.o(.rodata); build/asm/main_80074378.s.o(.data); }
    .main_80074378_bss (NOLOAD) : { build/asm/main_80074378.s.o(.bss); }
    .main_80074C04 0x80074C04 : AT(0x00075804) { build/asm/data/main_80074C04.bin.o(.data); }
    .main_80079A50 0x80079A50 : AT(0x0007A650) { build/asm/data/main_80079A50.bin.o(.data); }
    .main_8007A6A0 0x8007A6A0 : AT(0x0007B2A0) { FILL(0x00000000); build/asm/main_8007A6A0.s.o(.text); build/asm/main_8007A6A0.s.o(.rodata); build/asm/main_8007A6A0.s.o(.data); }
    .main_8007A6A0_bss (NOLOAD) : { build/asm/main_8007A6A0.s.o(.bss); }
    .main_8007A71C 0x8007A71C : AT(0x0007B31C) { FILL(0x00000000); build/asm/main_8007A71C.s.o(.text); build/asm/main_8007A71C.s.o(.rodata); build/asm/main_8007A71C.s.o(.data); }
    .main_8007A71C_bss (NOLOAD) : { build/asm/main_8007A71C.s.o(.bss); }
    .main_800835DC 0x800835DC : AT(0x000841DC) { build/asm/data/main_800835DC.bin.o(.data); }
    .main_80084EAC 0x80084EAC : AT(0x00085AAC) { FILL(0x00000000); build/asm/main_80084EAC.s.o(.text); build/asm/main_80084EAC.s.o(.rodata); build/asm/main_80084EAC.s.o(.data); }
    .main_80084EAC_bss (NOLOAD) : { build/asm/main_80084EAC.s.o(.bss); }
    .main_80084EEC 0x80084EEC : AT(0x00085AEC) { build/asm/data/main_80084EEC.bin.o(.data); }
    .main_8008E8E4 0x8008E8E4 : AT(0x0008F4E4) { FILL(0x00000000); build/asm/main_8008E8E4.s.o(.text); build/asm/main_8008E8E4.s.o(.rodata); build/asm/main_8008E8E4.s.o(.data); }
    .main_8008E8E4_bss (NOLOAD) : { build/asm/main_8008E8E4.s.o(.bss); }
    .main_80092720 0x80092720 : AT(0x00093320) { build/asm/data/main_80092720.bin.o(.data); }
    .main_80092DD8 0x80092DD8 : AT(0x000939D8) { FILL(0x00000000); build/asm/main_80092DD8.s.o(.text); build/asm/main_80092DD8.s.o(.rodata); build/asm/main_80092DD8.s.o(.data); }
    .main_80092DD8_bss (NOLOAD) : { build/asm/main_80092DD8.s.o(.bss); }
    .main_80096334 0x80096334 : AT(0x00096F34) { build/asm/data/main_80096334.bin.o(.data); }
    .main_8009C140 0x8009C140 : AT(0x0009CD40) { FILL(0x00000000); build/asm/main_8009C140.s.o(.text); build/asm/main_8009C140.s.o(.rodata); build/asm/main_8009C140.s.o(.data); }
    .main_8009C140_bss (NOLOAD) : { build/asm/main_8009C140.s.o(.bss); }
    .main_8009C4A8 0x8009C4A8 : AT(0x0009D0A8) { build/asm/data/main_8009C4A8.bin.o(.data); }
    .main_8009DCEC 0x8009DCEC : AT(0x0009E8EC) { FILL(0x00000000); build/asm/main_8009DCEC.s.o(.text); build/asm/main_8009DCEC.s.o(.rodata); build/asm/main_8009DCEC.s.o(.data); }
    .main_8009DCEC_bss (NOLOAD) : { build/asm/main_8009DCEC.s.o(.bss); }
    .main_8009E110 0x8009E110 : AT(0x0009ED10) { FILL(0x00000000); build/asm/main_8009E110.s.o(.text); build/asm/main_8009E110.s.o(.rodata); build/asm/main_8009E110.s.o(.data); }
    .main_8009E110_bss (NOLOAD) : { build/asm/main_8009E110.s.o(.bss); }
    .main_8009ED20 0x8009ED20 : AT(0x0009F920) { FILL(0x00000000); build/asm/main_8009ED20.s.o(.text); build/asm/main_8009ED20.s.o(.rodata); build/asm/main_8009ED20.s.o(.data); }
    .main_8009ED20_bss (NOLOAD) : { build/asm/main_8009ED20.s.o(.bss); }
    .main_800A0C28 0x800A0C28 : AT(0x000A1828) { FILL(0x00000000); build/asm/main_800A0C28.s.o(.text); build/asm/main_800A0C28.s.o(.rodata); build/asm/main_800A0C28.s.o(.data); }
    .main_800A0C28_bss (NOLOAD) : { build/asm/main_800A0C28.s.o(.bss); }
    .main_800A1D18 0x800A1D18 : AT(0x000A2918) { FILL(0x00000000); build/asm/main_800A1D18.s.o(.text); build/asm/main_800A1D18.s.o(.rodata); build/asm/main_800A1D18.s.o(.data); }
    .main_800A1D18_bss (NOLOAD) : { build/asm/main_800A1D18.s.o(.bss); }
    .main_800A25C0 0x800A25C0 : AT(0x000A31C0) { FILL(0x00000000); build/asm/main_800A25C0.s.o(.text); build/asm/main_800A25C0.s.o(.rodata); build/asm/main_800A25C0.s.o(.data); }
    .main_800A25C0_bss (NOLOAD) : { build/asm/main_800A25C0.s.o(.bss); }
    .main_800A2618 0x800A2618 : AT(0x000A3218) { build/asm/data/main_800A2618.bin.o(.data); }
    .main_800A4338 0x800A4338 : AT(0x000A4F38) { build/asm/data/main_800A4338.bin.o(.data); }
    .main_800A4684 0x800A4684 : AT(0x000A5284) { FILL(0x00000000); build/asm/main_800A4684.s.o(.text); build/asm/main_800A4684.s.o(.rodata); build/asm/main_800A4684.s.o(.data); }
    .main_800A4684_bss (NOLOAD) : { build/asm/main_800A4684.s.o(.bss); }
    .main_800A4688 0x800A4688 : AT(0x000A5288) { build/asm/data/main_800A4688.bin.o(.data); }
    .main_800AB020 0x800AB020 : AT(0x000ABC20) { build/asm/data/main_800AB020.bin.o(.data); }
    .main_800AD060 0x800AD060 : AT(0x000ADC60) { build/asm/data/main_800AD060.bin.o(.data); }
    .main_800AF0E0 0x800AF0E0 : AT(0x000AFCE0) { build/asm/data/main_800AF0E0.bin.o(.data); }
    .main_800B4160 0x800B4160 : AT(0x000B4D60) { FILL(0x00000000); build/asm/main_800B4160.s.o(.text); build/asm/main_800B4160.s.o(.rodata); build/asm/main_800B4160.s.o(.data); }
    .main_800B4160_bss (NOLOAD) : { build/asm/main_800B4160.s.o(.bss); }
    .main_800B5510 0x800B5510 : AT(0x000B6110) { build/asm/data/main_800B5510.bin.o(.data); }
    .main_800C0004 0x800C0004 : AT(0x000C0C04) { build/asm/data/main_800C0004.bin.o(.data); }
    .main_800F3F18 0x800F3F18 : AT(0x000F4B18) { FILL(0x00000000); build/asm/main_800F3F18.s.o(.text); build/asm/main_800F3F18.s.o(.rodata); build/asm/main_800F3F18.s.o(.data); }
    .main_800F3F18_bss (NOLOAD) : { build/asm/main_800F3F18.s.o(.bss); }
    .main_800F3F20 0x800F3F20 : AT(0x000F4B20) { build/asm/data/main_800F3F20.bin.o(.data); }
    .main_800F51F4 0x800F51F4 : AT(0x000F5DF4) { FILL(0x00000000); build/asm/main_800F51F4.s.o(.text); build/asm/main_800F51F4.s.o(.rodata); build/asm/main_800F51F4.s.o(.data); }
    .main_800F51F4_bss (NOLOAD) : { build/asm/main_800F51F4.s.o(.bss); }
    .main_800F520C 0x800F520C : AT(0x000F5E0C) { build/asm/data/main_800F520C.bin.o(.data); }
    .main_800F5678 0x800F5678 : AT(0x000F6278) { FILL(0x00000000); build/asm/main_800F5678.s.o(.text); build/asm/main_800F5678.s.o(.rodata); build/asm/main_800F5678.s.o(.data); }
    .main_800F5678_bss (NOLOAD) : { build/asm/main_800F5678.s.o(.bss); }
    .main_800F567C 0x800F567C : AT(0x000F627C) { build/asm/data/main_800F567C.bin.o(.data); }
    .main_800F602C 0x800F602C : AT(0x000F6C2C) { FILL(0x00000000); build/asm/main_800F602C.s.o(.text); build/asm/main_800F602C.s.o(.rodata); build/asm/main_800F602C.s.o(.data); }
    .main_800F602C_bss (NOLOAD) : { build/asm/main_800F602C.s.o(.bss); }
    .main_800F6030 0x800F6030 : AT(0x000F6C30) { build/asm/data/main_800F6030.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
