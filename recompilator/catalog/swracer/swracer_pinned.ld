SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000520 0x80000520 : AT(0x00001120) { FILL(0x00000000); build/asm/main_80000520.s.o(.text); build/asm/main_80000520.s.o(.rodata); build/asm/main_80000520.s.o(.data); }
    .main_80000520_bss (NOLOAD) : { build/asm/main_80000520.s.o(.bss); }
    .main_8007F22C 0x8007F22C : AT(0x0007FE2C) { FILL(0x00000000); build/asm/main_8007F22C.s.o(.text); build/asm/main_8007F22C.s.o(.rodata); build/asm/main_8007F22C.s.o(.data); }
    .main_8007F22C_bss (NOLOAD) : { build/asm/main_8007F22C.s.o(.bss); }
    .main_8008D044 0x8008D044 : AT(0x0008DC44) { FILL(0x00000000); build/asm/main_8008D044.s.o(.text); build/asm/main_8008D044.s.o(.rodata); build/asm/main_8008D044.s.o(.data); }
    .main_8008D044_bss (NOLOAD) : { build/asm/main_8008D044.s.o(.bss); }
    .main_8008D410 0x8008D410 : AT(0x0008E010) { FILL(0x00000000); build/asm/main_8008D410.s.o(.text); build/asm/main_8008D410.s.o(.rodata); build/asm/main_8008D410.s.o(.data); }
    .main_8008D410_bss (NOLOAD) : { build/asm/main_8008D410.s.o(.bss); }
    .main_800992A4 0x800992A4 : AT(0x00099EA4) { build/asm/data/main_800992A4.bin.o(.data); }
    .main_8009C18C 0x8009C18C : AT(0x0009CD8C) { build/asm/data/main_8009C18C.bin.o(.data); }
    .main_800A0204 0x800A0204 : AT(0x000A0E04) { FILL(0x00000000); build/asm/main_800A0204.s.o(.text); build/asm/main_800A0204.s.o(.rodata); build/asm/main_800A0204.s.o(.data); }
    .main_800A0204_bss (NOLOAD) : { build/asm/main_800A0204.s.o(.bss); }
    .main_800A2494 0x800A2494 : AT(0x000A3094) { build/asm/data/main_800A2494.bin.o(.data); }
    .main_800A4434 0x800A4434 : AT(0x000A5034) { FILL(0x00000000); build/asm/main_800A4434.s.o(.text); build/asm/main_800A4434.s.o(.rodata); build/asm/main_800A4434.s.o(.data); }
    .main_800A4434_bss (NOLOAD) : { build/asm/main_800A4434.s.o(.bss); }
    .main_800A4F0C 0x800A4F0C : AT(0x000A5B0C) { FILL(0x00000000); build/asm/main_800A4F0C.s.o(.text); build/asm/main_800A4F0C.s.o(.rodata); build/asm/main_800A4F0C.s.o(.data); }
    .main_800A4F0C_bss (NOLOAD) : { build/asm/main_800A4F0C.s.o(.bss); }
    .main_800AA544 0x800AA544 : AT(0x000AB144) { build/asm/data/main_800AA544.bin.o(.data); }
    .main_800AAFD0 0x800AAFD0 : AT(0x000ABBD0) { FILL(0x00000000); build/asm/main_800AAFD0.s.o(.text); build/asm/main_800AAFD0.s.o(.rodata); build/asm/main_800AAFD0.s.o(.data); }
    .main_800AAFD0_bss (NOLOAD) : { build/asm/main_800AAFD0.s.o(.bss); }
    .main_800AB7E0 0x800AB7E0 : AT(0x000AC3E0) { build/asm/data/main_800AB7E0.bin.o(.data); }
    .main_800ACF30 0x800ACF30 : AT(0x000ADB30) { FILL(0x00000000); build/asm/main_800ACF30.s.o(.text); build/asm/main_800ACF30.s.o(.rodata); build/asm/main_800ACF30.s.o(.data); }
    .main_800ACF30_bss (NOLOAD) : { build/asm/main_800ACF30.s.o(.bss); }
    .main_800ADAA4 0x800ADAA4 : AT(0x000AE6A4) { FILL(0x00000000); build/asm/main_800ADAA4.s.o(.text); build/asm/main_800ADAA4.s.o(.rodata); build/asm/main_800ADAA4.s.o(.data); }
    .main_800ADAA4_bss (NOLOAD) : { build/asm/main_800ADAA4.s.o(.bss); }
    .main_800AECA8 0x800AECA8 : AT(0x000AF8A8) { build/asm/data/main_800AECA8.bin.o(.data); }
    .main_800AF5DC 0x800AF5DC : AT(0x000B01DC) { build/asm/data/main_800AF5DC.bin.o(.data); }
    .main_800AFA40 0x800AFA40 : AT(0x000B0640) { FILL(0x00000000); build/asm/main_800AFA40.s.o(.text); build/asm/main_800AFA40.s.o(.rodata); build/asm/main_800AFA40.s.o(.data); }
    .main_800AFA40_bss (NOLOAD) : { build/asm/main_800AFA40.s.o(.bss); }
    .main_800AFCB8 0x800AFCB8 : AT(0x000B08B8) { build/asm/data/main_800AFCB8.bin.o(.data); }
    .main_800AFCC8 0x800AFCC8 : AT(0x000B08C8) { FILL(0x00000000); build/asm/main_800AFCC8.s.o(.text); build/asm/main_800AFCC8.s.o(.rodata); build/asm/main_800AFCC8.s.o(.data); }
    .main_800AFCC8_bss (NOLOAD) : { build/asm/main_800AFCC8.s.o(.bss); }
    .main_800AFCD4 0x800AFCD4 : AT(0x000B08D4) { build/asm/data/main_800AFCD4.bin.o(.data); }
    .main_800AFF50 0x800AFF50 : AT(0x000B0B50) { build/asm/data/main_800AFF50.bin.o(.data); }
    .main_800B0B44 0x800B0B44 : AT(0x000B1744) { FILL(0x00000000); build/asm/main_800B0B44.s.o(.text); build/asm/main_800B0B44.s.o(.rodata); build/asm/main_800B0B44.s.o(.data); }
    .main_800B0B44_bss (NOLOAD) : { build/asm/main_800B0B44.s.o(.bss); }
    .main_800B0B6C 0x800B0B6C : AT(0x000B176C) { build/asm/data/main_800B0B6C.bin.o(.data); }
    .main_800B48E4 0x800B48E4 : AT(0x000B54E4) { FILL(0x00000000); build/asm/main_800B48E4.s.o(.text); build/asm/main_800B48E4.s.o(.rodata); build/asm/main_800B48E4.s.o(.data); }
    .main_800B48E4_bss (NOLOAD) : { build/asm/main_800B48E4.s.o(.bss); }
    .main_800B4960 0x800B4960 : AT(0x000B5560) { build/asm/data/main_800B4960.bin.o(.data); }
    .main_800B4DA8 0x800B4DA8 : AT(0x000B59A8) { FILL(0x00000000); build/asm/main_800B4DA8.s.o(.text); build/asm/main_800B4DA8.s.o(.rodata); build/asm/main_800B4DA8.s.o(.data); }
    .main_800B4DA8_bss (NOLOAD) : { build/asm/main_800B4DA8.s.o(.bss); }
    .main_800B4DE4 0x800B4DE4 : AT(0x000B59E4) { build/asm/data/main_800B4DE4.bin.o(.data); }
    .main_800B4E68 0x800B4E68 : AT(0x000B5A68) { FILL(0x00000000); build/asm/main_800B4E68.s.o(.text); build/asm/main_800B4E68.s.o(.rodata); build/asm/main_800B4E68.s.o(.data); }
    .main_800B4E68_bss (NOLOAD) : { build/asm/main_800B4E68.s.o(.bss); }
    .main_800B4EC8 0x800B4EC8 : AT(0x000B5AC8) { build/asm/data/main_800B4EC8.bin.o(.data); }
    .main_800B4F04 0x800B4F04 : AT(0x000B5B04) { FILL(0x00000000); build/asm/main_800B4F04.s.o(.text); build/asm/main_800B4F04.s.o(.rodata); build/asm/main_800B4F04.s.o(.data); }
    .main_800B4F04_bss (NOLOAD) : { build/asm/main_800B4F04.s.o(.bss); }
    .main_800B4F40 0x800B4F40 : AT(0x000B5B40) { build/asm/data/main_800B4F40.bin.o(.data); }
    .main_800B56C8 0x800B56C8 : AT(0x000B62C8) { FILL(0x00000000); build/asm/main_800B56C8.s.o(.text); build/asm/main_800B56C8.s.o(.rodata); build/asm/main_800B56C8.s.o(.data); }
    .main_800B56C8_bss (NOLOAD) : { build/asm/main_800B56C8.s.o(.bss); }
    .main_800B56F8 0x800B56F8 : AT(0x000B62F8) { build/asm/data/main_800B56F8.bin.o(.data); }
    .main_800B5970 0x800B5970 : AT(0x000B6570) { FILL(0x00000000); build/asm/main_800B5970.s.o(.text); build/asm/main_800B5970.s.o(.rodata); build/asm/main_800B5970.s.o(.data); }
    .main_800B5970_bss (NOLOAD) : { build/asm/main_800B5970.s.o(.bss); }
    .main_800B59C0 0x800B59C0 : AT(0x000B65C0) { build/asm/data/main_800B59C0.bin.o(.data); }
    .main_800B64C0 0x800B64C0 : AT(0x000B70C0) { FILL(0x00000000); build/asm/main_800B64C0.s.o(.text); build/asm/main_800B64C0.s.o(.rodata); build/asm/main_800B64C0.s.o(.data); }
    .main_800B64C0_bss (NOLOAD) : { build/asm/main_800B64C0.s.o(.bss); }
    .main_800B6540 0x800B6540 : AT(0x000B7140) { build/asm/data/main_800B6540.bin.o(.data); }
    .main_800B6810 0x800B6810 : AT(0x000B7410) { FILL(0x00000000); build/asm/main_800B6810.s.o(.text); build/asm/main_800B6810.s.o(.rodata); build/asm/main_800B6810.s.o(.data); }
    .main_800B6810_bss (NOLOAD) : { build/asm/main_800B6810.s.o(.bss); }
    .main_800B6898 0x800B6898 : AT(0x000B7498) { build/asm/data/main_800B6898.bin.o(.data); }
    .main_800B6B7C 0x800B6B7C : AT(0x000B777C) { FILL(0x00000000); build/asm/main_800B6B7C.s.o(.text); build/asm/main_800B6B7C.s.o(.rodata); build/asm/main_800B6B7C.s.o(.data); }
    .main_800B6B7C_bss (NOLOAD) : { build/asm/main_800B6B7C.s.o(.bss); }
    .main_800B6B88 0x800B6B88 : AT(0x000B7788) { build/asm/data/main_800B6B88.bin.o(.data); }
    .main_800BD280 0x800BD280 : AT(0x000BDE80) { FILL(0x00000000); build/asm/main_800BD280.s.o(.text); build/asm/main_800BD280.s.o(.rodata); build/asm/main_800BD280.s.o(.data); }
    .main_800BD280_bss (NOLOAD) : { build/asm/main_800BD280.s.o(.bss); }
    .main_800BD288 0x800BD288 : AT(0x000BDE88) { build/asm/data/main_800BD288.bin.o(.data); }
    .main_800C7170 0x800C7170 : AT(0x000C7D70) { FILL(0x00000000); build/asm/main_800C7170.s.o(.text); build/asm/main_800C7170.s.o(.rodata); build/asm/main_800C7170.s.o(.data); }
    .main_800C7170_bss (NOLOAD) : { build/asm/main_800C7170.s.o(.bss); }
    .main_800C717C 0x800C717C : AT(0x000C7D7C) { build/asm/data/main_800C717C.bin.o(.data); }
    .main_800C97A0 0x800C97A0 : AT(0x000CA3A0) { FILL(0x00000000); build/asm/main_800C97A0.s.o(.text); build/asm/main_800C97A0.s.o(.rodata); build/asm/main_800C97A0.s.o(.data); }
    .main_800C97A0_bss (NOLOAD) : { build/asm/main_800C97A0.s.o(.bss); }
    .main_800C97B8 0x800C97B8 : AT(0x000CA3B8) { build/asm/data/main_800C97B8.bin.o(.data); }
    .main_800CCF20 0x800CCF20 : AT(0x000CDB20) { FILL(0x00000000); build/asm/main_800CCF20.s.o(.text); build/asm/main_800CCF20.s.o(.rodata); build/asm/main_800CCF20.s.o(.data); }
    .main_800CCF20_bss (NOLOAD) : { build/asm/main_800CCF20.s.o(.bss); }
    .main_800CCF24 0x800CCF24 : AT(0x000CDB24) { build/asm/data/main_800CCF24.bin.o(.data); }
    .main_800D15AC 0x800D15AC : AT(0x000D21AC) { FILL(0x00000000); build/asm/main_800D15AC.s.o(.text); build/asm/main_800D15AC.s.o(.rodata); build/asm/main_800D15AC.s.o(.data); }
    .main_800D15AC_bss (NOLOAD) : { build/asm/main_800D15AC.s.o(.bss); }
    .main_800D15B0 0x800D15B0 : AT(0x000D21B0) { build/asm/data/main_800D15B0.bin.o(.data); }
    .main_800D1E60 0x800D1E60 : AT(0x000D2A60) { build/asm/data/main_800D1E60.bin.o(.data); }
    .main_800D2014 0x800D2014 : AT(0x000D2C14) { FILL(0x00000000); build/asm/main_800D2014.s.o(.text); build/asm/main_800D2014.s.o(.rodata); build/asm/main_800D2014.s.o(.data); }
    .main_800D2014_bss (NOLOAD) : { build/asm/main_800D2014.s.o(.bss); }
    .main_800D3308 0x800D3308 : AT(0x000D3F08) { build/asm/data/main_800D3308.bin.o(.data); }
    .main_800D3C94 0x800D3C94 : AT(0x000D4894) { build/asm/data/main_800D3C94.bin.o(.data); }
    .main_800D526C 0x800D526C : AT(0x000D5E6C) { build/asm/data/main_800D526C.bin.o(.data); }
    .main_800D59BC 0x800D59BC : AT(0x000D65BC) { build/asm/data/main_800D59BC.bin.o(.data); }
    .main_800D604C 0x800D604C : AT(0x000D6C4C) { build/asm/data/main_800D604C.bin.o(.data); }
    .main_800D61A4 0x800D61A4 : AT(0x000D6DA4) { build/asm/data/main_800D61A4.bin.o(.data); }
    .main_800D63D4 0x800D63D4 : AT(0x000D6FD4) { build/asm/data/main_800D63D4.bin.o(.data); }
    .main_800D682C 0x800D682C : AT(0x000D742C) { build/asm/data/main_800D682C.bin.o(.data); }
    .main_800D6ACC 0x800D6ACC : AT(0x000D76CC) { build/asm/data/main_800D6ACC.bin.o(.data); }
    .main_800D6B58 0x800D6B58 : AT(0x000D7758) { FILL(0x00000000); build/asm/main_800D6B58.s.o(.text); build/asm/main_800D6B58.s.o(.rodata); build/asm/main_800D6B58.s.o(.data); }
    .main_800D6B58_bss (NOLOAD) : { build/asm/main_800D6B58.s.o(.bss); }
    .main_800D7508 0x800D7508 : AT(0x000D8108) { FILL(0x00000000); build/asm/main_800D7508.s.o(.text); build/asm/main_800D7508.s.o(.rodata); build/asm/main_800D7508.s.o(.data); }
    .main_800D7508_bss (NOLOAD) : { build/asm/main_800D7508.s.o(.bss); }
    .main_800D83F8 0x800D83F8 : AT(0x000D8FF8) { build/asm/data/main_800D83F8.bin.o(.data); }
    .main_800D9BD4 0x800D9BD4 : AT(0x000DA7D4) { FILL(0x00000000); build/asm/main_800D9BD4.s.o(.text); build/asm/main_800D9BD4.s.o(.rodata); build/asm/main_800D9BD4.s.o(.data); }
    .main_800D9BD4_bss (NOLOAD) : { build/asm/main_800D9BD4.s.o(.bss); }
    .main_800DA320 0x800DA320 : AT(0x000DAF20) { build/asm/data/main_800DA320.bin.o(.data); }
    .main_800DB994 0x800DB994 : AT(0x000DC594) { build/asm/data/main_800DB994.bin.o(.data); }
    .main_800E0A18 0x800E0A18 : AT(0x000E1618) { FILL(0x00000000); build/asm/main_800E0A18.s.o(.text); build/asm/main_800E0A18.s.o(.rodata); build/asm/main_800E0A18.s.o(.data); }
    .main_800E0A18_bss (NOLOAD) : { build/asm/main_800E0A18.s.o(.bss); }
    .main_800E0A28 0x800E0A28 : AT(0x000E1628) { build/asm/data/main_800E0A28.bin.o(.data); }
    .main_800E1080 0x800E1080 : AT(0x000E1C80) { build/asm/data/main_800E1080.bin.o(.data); }
    .main_800E1C48 0x800E1C48 : AT(0x000E2848) { FILL(0x00000000); build/asm/main_800E1C48.s.o(.text); build/asm/main_800E1C48.s.o(.rodata); build/asm/main_800E1C48.s.o(.data); }
    .main_800E1C48_bss (NOLOAD) : { build/asm/main_800E1C48.s.o(.bss); }
    .main_800E1C50 0x800E1C50 : AT(0x000E2850) { build/asm/data/main_800E1C50.bin.o(.data); }
    .main_800E34B0 0x800E34B0 : AT(0x000E40B0) { build/asm/data/main_800E34B0.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
