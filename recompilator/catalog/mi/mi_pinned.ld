SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_8007A224 0x8007A224 : AT(0x0007AE24) { FILL(0x00000000); build/asm/main_8007A224.s.o(.text); build/asm/main_8007A224.s.o(.rodata); build/asm/main_8007A224.s.o(.data); }
    .main_8007A224_bss (NOLOAD) : { build/asm/main_8007A224.s.o(.bss); }
    .main_8007A600 0x8007A600 : AT(0x0007B200) { FILL(0x00000000); build/asm/main_8007A600.s.o(.text); build/asm/main_8007A600.s.o(.rodata); build/asm/main_8007A600.s.o(.data); }
    .main_8007A600_bss (NOLOAD) : { build/asm/main_8007A600.s.o(.bss); }
    .main_8007FEB0 0x8007FEB0 : AT(0x00080AB0) { FILL(0x00000000); build/asm/main_8007FEB0.s.o(.text); build/asm/main_8007FEB0.s.o(.rodata); build/asm/main_8007FEB0.s.o(.data); }
    .main_8007FEB0_bss (NOLOAD) : { build/asm/main_8007FEB0.s.o(.bss); }
    .main_80084F84 0x80084F84 : AT(0x00085B84) { build/asm/data/main_80084F84.bin.o(.data); }
    .main_80088E08 0x80088E08 : AT(0x00089A08) { FILL(0x00000000); build/asm/main_80088E08.s.o(.text); build/asm/main_80088E08.s.o(.rodata); build/asm/main_80088E08.s.o(.data); }
    .main_80088E08_bss (NOLOAD) : { build/asm/main_80088E08.s.o(.bss); }
    .main_8008A0D8 0x8008A0D8 : AT(0x0008ACD8) { FILL(0x00000000); build/asm/main_8008A0D8.s.o(.text); build/asm/main_8008A0D8.s.o(.rodata); build/asm/main_8008A0D8.s.o(.data); }
    .main_8008A0D8_bss (NOLOAD) : { build/asm/main_8008A0D8.s.o(.bss); }
    .main_8008A1C4 0x8008A1C4 : AT(0x0008ADC4) { build/asm/data/main_8008A1C4.bin.o(.data); }
    .main_8008A438 0x8008A438 : AT(0x0008B038) { build/asm/data/main_8008A438.bin.o(.data); }
    .main_8008AEEC 0x8008AEEC : AT(0x0008BAEC) { FILL(0x00000000); build/asm/main_8008AEEC.s.o(.text); build/asm/main_8008AEEC.s.o(.rodata); build/asm/main_8008AEEC.s.o(.data); }
    .main_8008AEEC_bss (NOLOAD) : { build/asm/main_8008AEEC.s.o(.bss); }
    .main_8008B300 0x8008B300 : AT(0x0008BF00) { build/asm/data/main_8008B300.bin.o(.data); }
    .main_8008BF74 0x8008BF74 : AT(0x0008CB74) { FILL(0x00000000); build/asm/main_8008BF74.s.o(.text); build/asm/main_8008BF74.s.o(.rodata); build/asm/main_8008BF74.s.o(.data); }
    .main_8008BF74_bss (NOLOAD) : { build/asm/main_8008BF74.s.o(.bss); }
    .main_8008C8B4 0x8008C8B4 : AT(0x0008D4B4) { FILL(0x00000000); build/asm/main_8008C8B4.s.o(.text); build/asm/main_8008C8B4.s.o(.rodata); build/asm/main_8008C8B4.s.o(.data); }
    .main_8008C8B4_bss (NOLOAD) : { build/asm/main_8008C8B4.s.o(.bss); }
    .main_8008D0A0 0x8008D0A0 : AT(0x0008DCA0) { build/asm/data/main_8008D0A0.bin.o(.data); }
    .main_8008DB44 0x8008DB44 : AT(0x0008E744) { FILL(0x00000000); build/asm/main_8008DB44.s.o(.text); build/asm/main_8008DB44.s.o(.rodata); build/asm/main_8008DB44.s.o(.data); }
    .main_8008DB44_bss (NOLOAD) : { build/asm/main_8008DB44.s.o(.bss); }
    .main_8008DF40 0x8008DF40 : AT(0x0008EB40) { build/asm/data/main_8008DF40.bin.o(.data); }
    .main_8008EEB0 0x8008EEB0 : AT(0x0008FAB0) { build/asm/data/main_8008EEB0.bin.o(.data); }
    .main_8008FA50 0x8008FA50 : AT(0x00090650) { build/asm/data/main_8008FA50.bin.o(.data); }
    .main_8008FDA4 0x8008FDA4 : AT(0x000909A4) { FILL(0x00000000); build/asm/main_8008FDA4.s.o(.text); build/asm/main_8008FDA4.s.o(.rodata); build/asm/main_8008FDA4.s.o(.data); }
    .main_8008FDA4_bss (NOLOAD) : { build/asm/main_8008FDA4.s.o(.bss); }
    .main_80090344 0x80090344 : AT(0x00090F44) { FILL(0x00000000); build/asm/main_80090344.s.o(.text); build/asm/main_80090344.s.o(.rodata); build/asm/main_80090344.s.o(.data); }
    .main_80090344_bss (NOLOAD) : { build/asm/main_80090344.s.o(.bss); }
    .main_8009056C 0x8009056C : AT(0x0009116C) { FILL(0x00000000); build/asm/main_8009056C.s.o(.text); build/asm/main_8009056C.s.o(.rodata); build/asm/main_8009056C.s.o(.data); }
    .main_8009056C_bss (NOLOAD) : { build/asm/main_8009056C.s.o(.bss); }
    .main_80090C68 0x80090C68 : AT(0x00091868) { FILL(0x00000000); build/asm/main_80090C68.s.o(.text); build/asm/main_80090C68.s.o(.rodata); build/asm/main_80090C68.s.o(.data); }
    .main_80090C68_bss (NOLOAD) : { build/asm/main_80090C68.s.o(.bss); }
    .main_80090E20 0x80090E20 : AT(0x00091A20) { build/asm/data/main_80090E20.bin.o(.data); }
    .main_80091524 0x80091524 : AT(0x00092124) { FILL(0x00000000); build/asm/main_80091524.s.o(.text); build/asm/main_80091524.s.o(.rodata); build/asm/main_80091524.s.o(.data); }
    .main_80091524_bss (NOLOAD) : { build/asm/main_80091524.s.o(.bss); }
    .main_80091A70 0x80091A70 : AT(0x00092670) { build/asm/data/main_80091A70.bin.o(.data); }
    .main_80091AEC 0x80091AEC : AT(0x000926EC) { build/asm/data/main_80091AEC.bin.o(.data); }
    .main_80092FB4 0x80092FB4 : AT(0x00093BB4) { FILL(0x00000000); build/asm/main_80092FB4.s.o(.text); build/asm/main_80092FB4.s.o(.rodata); build/asm/main_80092FB4.s.o(.data); }
    .main_80092FB4_bss (NOLOAD) : { build/asm/main_80092FB4.s.o(.bss); }
    .main_800942B4 0x800942B4 : AT(0x00094EB4) { build/asm/data/main_800942B4.bin.o(.data); }
    .main_80095C3C 0x80095C3C : AT(0x0009683C) { build/asm/data/main_80095C3C.bin.o(.data); }
    .main_80097468 0x80097468 : AT(0x00098068) { build/asm/data/main_80097468.bin.o(.data); }
    .main_8009D7C0 0x8009D7C0 : AT(0x0009E3C0) { FILL(0x00000000); build/asm/main_8009D7C0.s.o(.text); build/asm/main_8009D7C0.s.o(.rodata); build/asm/main_8009D7C0.s.o(.data); }
    .main_8009D7C0_bss (NOLOAD) : { build/asm/main_8009D7C0.s.o(.bss); }
    .main_8009E628 0x8009E628 : AT(0x0009F228) { build/asm/data/main_8009E628.bin.o(.data); }
    .main_8009F4E0 0x8009F4E0 : AT(0x000A00E0) { build/asm/data/main_8009F4E0.bin.o(.data); }
    .main_800A1758 0x800A1758 : AT(0x000A2358) { build/asm/data/main_800A1758.bin.o(.data); }
    .main_800A237C 0x800A237C : AT(0x000A2F7C) { build/asm/data/main_800A237C.bin.o(.data); }
    .main_800A3148 0x800A3148 : AT(0x000A3D48) { FILL(0x00000000); build/asm/main_800A3148.s.o(.text); build/asm/main_800A3148.s.o(.rodata); build/asm/main_800A3148.s.o(.data); }
    .main_800A3148_bss (NOLOAD) : { build/asm/main_800A3148.s.o(.bss); }
    .main_800A46C8 0x800A46C8 : AT(0x000A52C8) { build/asm/data/main_800A46C8.bin.o(.data); }
    .main_800A5684 0x800A5684 : AT(0x000A6284) { build/asm/data/main_800A5684.bin.o(.data); }
    .main_800A664C 0x800A664C : AT(0x000A724C) { build/asm/data/main_800A664C.bin.o(.data); }
    .main_800A7C38 0x800A7C38 : AT(0x000A8838) { build/asm/data/main_800A7C38.bin.o(.data); }
    .main_800A7D58 0x800A7D58 : AT(0x000A8958) { build/asm/data/main_800A7D58.bin.o(.data); }
    .main_800A8DF0 0x800A8DF0 : AT(0x000A99F0) { build/asm/data/main_800A8DF0.bin.o(.data); }
    .main_800A8F58 0x800A8F58 : AT(0x000A9B58) { build/asm/data/main_800A8F58.bin.o(.data); }
    .main_800A91EC 0x800A91EC : AT(0x000A9DEC) { FILL(0x00000000); build/asm/main_800A91EC.s.o(.text); build/asm/main_800A91EC.s.o(.rodata); build/asm/main_800A91EC.s.o(.data); }
    .main_800A91EC_bss (NOLOAD) : { build/asm/main_800A91EC.s.o(.bss); }
    .main_800A9274 0x800A9274 : AT(0x000A9E74) { FILL(0x00000000); build/asm/main_800A9274.s.o(.text); build/asm/main_800A9274.s.o(.rodata); build/asm/main_800A9274.s.o(.data); }
    .main_800A9274_bss (NOLOAD) : { build/asm/main_800A9274.s.o(.bss); }
    .main_800A9638 0x800A9638 : AT(0x000AA238) { FILL(0x00000000); build/asm/main_800A9638.s.o(.text); build/asm/main_800A9638.s.o(.rodata); build/asm/main_800A9638.s.o(.data); }
    .main_800A9638_bss (NOLOAD) : { build/asm/main_800A9638.s.o(.bss); }
    .main_800A9814 0x800A9814 : AT(0x000AA414) { build/asm/data/main_800A9814.bin.o(.data); }
    .main_800A9948 0x800A9948 : AT(0x000AA548) { build/asm/data/main_800A9948.bin.o(.data); }
    .main_800B9A2C 0x800B9A2C : AT(0x000BA62C) { build/asm/data/main_800B9A2C.bin.o(.data); }
    .main_800BABB0 0x800BABB0 : AT(0x000BB7B0) { FILL(0x00000000); build/asm/main_800BABB0.s.o(.text); build/asm/main_800BABB0.s.o(.rodata); build/asm/main_800BABB0.s.o(.data); }
    .main_800BABB0_bss (NOLOAD) : { build/asm/main_800BABB0.s.o(.bss); }
    .main_800BB6EC 0x800BB6EC : AT(0x000BC2EC) { build/asm/data/main_800BB6EC.bin.o(.data); }
    .main_800BCEE0 0x800BCEE0 : AT(0x000BDAE0) { FILL(0x00000000); build/asm/main_800BCEE0.s.o(.text); build/asm/main_800BCEE0.s.o(.rodata); build/asm/main_800BCEE0.s.o(.data); }
    .main_800BCEE0_bss (NOLOAD) : { build/asm/main_800BCEE0.s.o(.bss); }
    .main_800BCEFC 0x800BCEFC : AT(0x000BDAFC) { build/asm/data/main_800BCEFC.bin.o(.data); }
    .main_800C2C3C 0x800C2C3C : AT(0x000C383C) { FILL(0x00000000); build/asm/main_800C2C3C.s.o(.text); build/asm/main_800C2C3C.s.o(.rodata); build/asm/main_800C2C3C.s.o(.data); }
    .main_800C2C3C_bss (NOLOAD) : { build/asm/main_800C2C3C.s.o(.bss); }
    .main_800C2C54 0x800C2C54 : AT(0x000C3854) { build/asm/data/main_800C2C54.bin.o(.data); }
    .main_800C46DC 0x800C46DC : AT(0x000C52DC) { FILL(0x00000000); build/asm/main_800C46DC.s.o(.text); build/asm/main_800C46DC.s.o(.rodata); build/asm/main_800C46DC.s.o(.data); }
    .main_800C46DC_bss (NOLOAD) : { build/asm/main_800C46DC.s.o(.bss); }
    .main_800C4708 0x800C4708 : AT(0x000C5308) { build/asm/data/main_800C4708.bin.o(.data); }
    .main_800D639C 0x800D639C : AT(0x000D6F9C) { FILL(0x00000000); build/asm/main_800D639C.s.o(.text); build/asm/main_800D639C.s.o(.rodata); build/asm/main_800D639C.s.o(.data); }
    .main_800D639C_bss (NOLOAD) : { build/asm/main_800D639C.s.o(.bss); }
    .main_800D63C4 0x800D63C4 : AT(0x000D6FC4) { build/asm/data/main_800D63C4.bin.o(.data); }
    .main_800DE278 0x800DE278 : AT(0x000DEE78) { FILL(0x00000000); build/asm/main_800DE278.s.o(.text); build/asm/main_800DE278.s.o(.rodata); build/asm/main_800DE278.s.o(.data); }
    .main_800DE278_bss (NOLOAD) : { build/asm/main_800DE278.s.o(.bss); }
    .main_800DE280 0x800DE280 : AT(0x000DEE80) { build/asm/data/main_800DE280.bin.o(.data); }
    .main_800E3448 0x800E3448 : AT(0x000E4048) { FILL(0x00000000); build/asm/main_800E3448.s.o(.text); build/asm/main_800E3448.s.o(.rodata); build/asm/main_800E3448.s.o(.data); }
    .main_800E3448_bss (NOLOAD) : { build/asm/main_800E3448.s.o(.bss); }
    .main_800E3464 0x800E3464 : AT(0x000E4064) { build/asm/data/main_800E3464.bin.o(.data); }
    .main_800F3510 0x800F3510 : AT(0x000F4110) { FILL(0x00000000); build/asm/main_800F3510.s.o(.text); build/asm/main_800F3510.s.o(.rodata); build/asm/main_800F3510.s.o(.data); }
    .main_800F3510_bss (NOLOAD) : { build/asm/main_800F3510.s.o(.bss); }
    .main_800F3518 0x800F3518 : AT(0x000F4118) { build/asm/data/main_800F3518.bin.o(.data); }
    .main_800F5038 0x800F5038 : AT(0x000F5C38) { FILL(0x00000000); build/asm/main_800F5038.s.o(.text); build/asm/main_800F5038.s.o(.rodata); build/asm/main_800F5038.s.o(.data); }
    .main_800F5038_bss (NOLOAD) : { build/asm/main_800F5038.s.o(.bss); }
    .main_800F5050 0x800F5050 : AT(0x000F5C50) { build/asm/data/main_800F5050.bin.o(.data); }
    .main_800FBBC4 0x800FBBC4 : AT(0x000FC7C4) { FILL(0x00000000); build/asm/main_800FBBC4.s.o(.text); build/asm/main_800FBBC4.s.o(.rodata); build/asm/main_800FBBC4.s.o(.data); }
    .main_800FBBC4_bss (NOLOAD) : { build/asm/main_800FBBC4.s.o(.bss); }
    .main_800FBBD0 0x800FBBD0 : AT(0x000FC7D0) { build/asm/data/main_800FBBD0.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
