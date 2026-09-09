SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80006000 0x80006000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80006000.s.o(.text); build/asm/main_80006000.s.o(.rodata); build/asm/main_80006000.s.o(.data); }
    .main_80006000_bss (NOLOAD) : { build/asm/main_80006000.s.o(.bss); }
    .main_80006840 0x80006840 : AT(0x00001840) { FILL(0x00000000); build/asm/main_80006840.s.o(.text); build/asm/main_80006840.s.o(.rodata); build/asm/main_80006840.s.o(.data); }
    .main_80006840_bss (NOLOAD) : { build/asm/main_80006840.s.o(.bss); }
    .main_80063BA0 0x80063BA0 : AT(0x0005EBA0) { build/asm/data/main_80063BA0.bin.o(.data); }
    .main_80063F80 0x80063F80 : AT(0x0005EF80) { FILL(0x00000000); build/asm/main_80063F80.s.o(.text); build/asm/main_80063F80.s.o(.rodata); build/asm/main_80063F80.s.o(.data); }
    .main_80063F80_bss (NOLOAD) : { build/asm/main_80063F80.s.o(.bss); }
    .main_8006A7B8 0x8006A7B8 : AT(0x000657B8) { build/asm/data/main_8006A7B8.bin.o(.data); }
    .main_8006E000 0x8006E000 : AT(0x00069000) { FILL(0x00000000); build/asm/main_8006E000.s.o(.text); build/asm/main_8006E000.s.o(.rodata); build/asm/main_8006E000.s.o(.data); }
    .main_8006E000_bss (NOLOAD) : { build/asm/main_8006E000.s.o(.bss); }
    .main_8006F680 0x8006F680 : AT(0x0006A680) { build/asm/data/main_8006F680.bin.o(.data); }
    .main_8006FB60 0x8006FB60 : AT(0x0006AB60) { FILL(0x00000000); build/asm/main_8006FB60.s.o(.text); build/asm/main_8006FB60.s.o(.rodata); build/asm/main_8006FB60.s.o(.data); }
    .main_8006FB60_bss (NOLOAD) : { build/asm/main_8006FB60.s.o(.bss); }
    .main_8006FC20 0x8006FC20 : AT(0x0006AC20) { build/asm/data/main_8006FC20.bin.o(.data); }
    .main_8006FC60 0x8006FC60 : AT(0x0006AC60) { FILL(0x00000000); build/asm/main_8006FC60.s.o(.text); build/asm/main_8006FC60.s.o(.rodata); build/asm/main_8006FC60.s.o(.data); }
    .main_8006FC60_bss (NOLOAD) : { build/asm/main_8006FC60.s.o(.bss); }
    .main_80070660 0x80070660 : AT(0x0006B660) { build/asm/data/main_80070660.bin.o(.data); }
    .main_80070900 0x80070900 : AT(0x0006B900) { FILL(0x00000000); build/asm/main_80070900.s.o(.text); build/asm/main_80070900.s.o(.rodata); build/asm/main_80070900.s.o(.data); }
    .main_80070900_bss (NOLOAD) : { build/asm/main_80070900.s.o(.bss); }
    .main_80071160 0x80071160 : AT(0x0006C160) { build/asm/data/main_80071160.bin.o(.data); }
    .main_80071180 0x80071180 : AT(0x0006C180) { FILL(0x00000000); build/asm/main_80071180.s.o(.text); build/asm/main_80071180.s.o(.rodata); build/asm/main_80071180.s.o(.data); }
    .main_80071180_bss (NOLOAD) : { build/asm/main_80071180.s.o(.bss); }
    .main_8007255C 0x8007255C : AT(0x0006D55C) { build/asm/data/main_8007255C.bin.o(.data); }
    .main_80072620 0x80072620 : AT(0x0006D620) { FILL(0x00000000); build/asm/main_80072620.s.o(.text); build/asm/main_80072620.s.o(.rodata); build/asm/main_80072620.s.o(.data); }
    .main_80072620_bss (NOLOAD) : { build/asm/main_80072620.s.o(.bss); }
    .main_800824E0 0x800824E0 : AT(0x0007D4E0) { build/asm/data/main_800824E0.bin.o(.data); }
    .main_80085964 0x80085964 : AT(0x00080964) { FILL(0x00000000); build/asm/main_80085964.s.o(.text); build/asm/main_80085964.s.o(.rodata); build/asm/main_80085964.s.o(.data); }
    .main_80085964_bss (NOLOAD) : { build/asm/main_80085964.s.o(.bss); }
    .main_80085BF8 0x80085BF8 : AT(0x00080BF8) { build/asm/data/main_80085BF8.bin.o(.data); }
    .main_80086114 0x80086114 : AT(0x00081114) { FILL(0x00000000); build/asm/main_80086114.s.o(.text); build/asm/main_80086114.s.o(.rodata); build/asm/main_80086114.s.o(.data); }
    .main_80086114_bss (NOLOAD) : { build/asm/main_80086114.s.o(.bss); }
    .main_80086708 0x80086708 : AT(0x00081708) { build/asm/data/main_80086708.bin.o(.data); }
    .main_800893A4 0x800893A4 : AT(0x000843A4) { FILL(0x00000000); build/asm/main_800893A4.s.o(.text); build/asm/main_800893A4.s.o(.rodata); build/asm/main_800893A4.s.o(.data); }
    .main_800893A4_bss (NOLOAD) : { build/asm/main_800893A4.s.o(.bss); }
    .main_80089418 0x80089418 : AT(0x00084418) { build/asm/data/main_80089418.bin.o(.data); }
    .main_8008A78C 0x8008A78C : AT(0x0008578C) { FILL(0x00000000); build/asm/main_8008A78C.s.o(.text); build/asm/main_8008A78C.s.o(.rodata); build/asm/main_8008A78C.s.o(.data); }
    .main_8008A78C_bss (NOLOAD) : { build/asm/main_8008A78C.s.o(.bss); }
    .main_8008AC00 0x8008AC00 : AT(0x00085C00) { build/asm/data/main_8008AC00.bin.o(.data); }
    .main_8008B324 0x8008B324 : AT(0x00086324) { FILL(0x00000000); build/asm/main_8008B324.s.o(.text); build/asm/main_8008B324.s.o(.rodata); build/asm/main_8008B324.s.o(.data); }
    .main_8008B324_bss (NOLOAD) : { build/asm/main_8008B324.s.o(.bss); }
    .main_8008B38C 0x8008B38C : AT(0x0008638C) { build/asm/data/main_8008B38C.bin.o(.data); }
    .main_8008C700 0x8008C700 : AT(0x00087700) { FILL(0x00000000); build/asm/main_8008C700.s.o(.text); build/asm/main_8008C700.s.o(.rodata); build/asm/main_8008C700.s.o(.data); }
    .main_8008C700_bss (NOLOAD) : { build/asm/main_8008C700.s.o(.bss); }
    .main_8008CB50 0x8008CB50 : AT(0x00087B50) { build/asm/data/main_8008CB50.bin.o(.data); }
    .main_8008D350 0x8008D350 : AT(0x00088350) { FILL(0x00000000); build/asm/main_8008D350.s.o(.text); build/asm/main_8008D350.s.o(.rodata); build/asm/main_8008D350.s.o(.data); }
    .main_8008D350_bss (NOLOAD) : { build/asm/main_8008D350.s.o(.bss); }
    .main_8008D3CC 0x8008D3CC : AT(0x000883CC) { build/asm/data/main_8008D3CC.bin.o(.data); }
    .main_8009C1A8 0x8009C1A8 : AT(0x000971A8) { FILL(0x00000000); build/asm/main_8009C1A8.s.o(.text); build/asm/main_8009C1A8.s.o(.rodata); build/asm/main_8009C1A8.s.o(.data); }
    .main_8009C1A8_bss (NOLOAD) : { build/asm/main_8009C1A8.s.o(.bss); }
    .main_8009F28C 0x8009F28C : AT(0x0009A28C) { build/asm/data/main_8009F28C.bin.o(.data); }
    .main_800A0FD0 0x800A0FD0 : AT(0x0009BFD0) { FILL(0x00000000); build/asm/main_800A0FD0.s.o(.text); build/asm/main_800A0FD0.s.o(.rodata); build/asm/main_800A0FD0.s.o(.data); }
    .main_800A0FD0_bss (NOLOAD) : { build/asm/main_800A0FD0.s.o(.bss); }
    .main_800A134C 0x800A134C : AT(0x0009C34C) { build/asm/data/main_800A134C.bin.o(.data); }
    .main_800A1C3C 0x800A1C3C : AT(0x0009CC3C) { FILL(0x00000000); build/asm/main_800A1C3C.s.o(.text); build/asm/main_800A1C3C.s.o(.rodata); build/asm/main_800A1C3C.s.o(.data); }
    .main_800A1C3C_bss (NOLOAD) : { build/asm/main_800A1C3C.s.o(.bss); }
    .main_800A4EF4 0x800A4EF4 : AT(0x0009FEF4) { build/asm/data/main_800A4EF4.bin.o(.data); }
    .main_800A63F4 0x800A63F4 : AT(0x000A13F4) { FILL(0x00000000); build/asm/main_800A63F4.s.o(.text); build/asm/main_800A63F4.s.o(.rodata); build/asm/main_800A63F4.s.o(.data); }
    .main_800A63F4_bss (NOLOAD) : { build/asm/main_800A63F4.s.o(.bss); }
    .main_800AB138 0x800AB138 : AT(0x000A6138) { build/asm/data/main_800AB138.bin.o(.data); }
    .main_800AC3A0 0x800AC3A0 : AT(0x000A73A0) { FILL(0x00000000); build/asm/main_800AC3A0.s.o(.text); build/asm/main_800AC3A0.s.o(.rodata); build/asm/main_800AC3A0.s.o(.data); }
    .main_800AC3A0_bss (NOLOAD) : { build/asm/main_800AC3A0.s.o(.bss); }
    .main_800AC9B4 0x800AC9B4 : AT(0x000A79B4) { build/asm/data/main_800AC9B4.bin.o(.data); }
    .main_800AD68C 0x800AD68C : AT(0x000A868C) { FILL(0x00000000); build/asm/main_800AD68C.s.o(.text); build/asm/main_800AD68C.s.o(.rodata); build/asm/main_800AD68C.s.o(.data); }
    .main_800AD68C_bss (NOLOAD) : { build/asm/main_800AD68C.s.o(.bss); }
    .main_800AE48C 0x800AE48C : AT(0x000A948C) { build/asm/data/main_800AE48C.bin.o(.data); }
    .main_800AFE7C 0x800AFE7C : AT(0x000AAE7C) { FILL(0x00000000); build/asm/main_800AFE7C.s.o(.text); build/asm/main_800AFE7C.s.o(.rodata); build/asm/main_800AFE7C.s.o(.data); }
    .main_800AFE7C_bss (NOLOAD) : { build/asm/main_800AFE7C.s.o(.bss); }
    .main_800B0004 0x800B0004 : AT(0x000AB004) { build/asm/data/main_800B0004.bin.o(.data); }
    .main_800B0764 0x800B0764 : AT(0x000AB764) { FILL(0x00000000); build/asm/main_800B0764.s.o(.text); build/asm/main_800B0764.s.o(.rodata); build/asm/main_800B0764.s.o(.data); }
    .main_800B0764_bss (NOLOAD) : { build/asm/main_800B0764.s.o(.bss); }
    .main_800B0B84 0x800B0B84 : AT(0x000ABB84) { build/asm/data/main_800B0B84.bin.o(.data); }
    .main_800B3018 0x800B3018 : AT(0x000AE018) { FILL(0x00000000); build/asm/main_800B3018.s.o(.text); build/asm/main_800B3018.s.o(.rodata); build/asm/main_800B3018.s.o(.data); }
    .main_800B3018_bss (NOLOAD) : { build/asm/main_800B3018.s.o(.bss); }
    .main_800B3028 0x800B3028 : AT(0x000AE028) { build/asm/data/main_800B3028.bin.o(.data); }
    .main_800D2064 0x800D2064 : AT(0x000CD064) { FILL(0x00000000); build/asm/main_800D2064.s.o(.text); build/asm/main_800D2064.s.o(.rodata); build/asm/main_800D2064.s.o(.data); }
    .main_800D2064_bss (NOLOAD) : { build/asm/main_800D2064.s.o(.bss); }
    .main_800D2094 0x800D2094 : AT(0x000CD094) { build/asm/data/main_800D2094.bin.o(.data); }
    .main_800D8B18 0x800D8B18 : AT(0x000D3B18) { FILL(0x00000000); build/asm/main_800D8B18.s.o(.text); build/asm/main_800D8B18.s.o(.rodata); build/asm/main_800D8B18.s.o(.data); }
    .main_800D8B18_bss (NOLOAD) : { build/asm/main_800D8B18.s.o(.bss); }
    .main_800D8BD8 0x800D8BD8 : AT(0x000D3BD8) { build/asm/data/main_800D8BD8.bin.o(.data); }
    .main_800DB130 0x800DB130 : AT(0x000D6130) { FILL(0x00000000); build/asm/main_800DB130.s.o(.text); build/asm/main_800DB130.s.o(.rodata); build/asm/main_800DB130.s.o(.data); }
    .main_800DB130_bss (NOLOAD) : { build/asm/main_800DB130.s.o(.bss); }
    .main_800DB1B0 0x800DB1B0 : AT(0x000D61B0) { build/asm/data/main_800DB1B0.bin.o(.data); }
    .main_800DC3F4 0x800DC3F4 : AT(0x000D73F4) { FILL(0x00000000); build/asm/main_800DC3F4.s.o(.text); build/asm/main_800DC3F4.s.o(.rodata); build/asm/main_800DC3F4.s.o(.data); }
    .main_800DC3F4_bss (NOLOAD) : { build/asm/main_800DC3F4.s.o(.bss); }
    .main_800DC400 0x800DC400 : AT(0x000D7400) { build/asm/data/main_800DC400.bin.o(.data); }
    .main_800DC6B4 0x800DC6B4 : AT(0x000D76B4) { FILL(0x00000000); build/asm/main_800DC6B4.s.o(.text); build/asm/main_800DC6B4.s.o(.rodata); build/asm/main_800DC6B4.s.o(.data); }
    .main_800DC6B4_bss (NOLOAD) : { build/asm/main_800DC6B4.s.o(.bss); }
    .main_800DC6BC 0x800DC6BC : AT(0x000D76BC) { build/asm/data/main_800DC6BC.bin.o(.data); }
    .main_800E2F90 0x800E2F90 : AT(0x000DDF90) { FILL(0x00000000); build/asm/main_800E2F90.s.o(.text); build/asm/main_800E2F90.s.o(.rodata); build/asm/main_800E2F90.s.o(.data); }
    .main_800E2F90_bss (NOLOAD) : { build/asm/main_800E2F90.s.o(.bss); }
    .main_800E2FE8 0x800E2FE8 : AT(0x000DDFE8) { build/asm/data/main_800E2FE8.bin.o(.data); }
    .main_800EC430 0x800EC430 : AT(0x000E7430) { FILL(0x00000000); build/asm/main_800EC430.s.o(.text); build/asm/main_800EC430.s.o(.rodata); build/asm/main_800EC430.s.o(.data); }
    .main_800EC430_bss (NOLOAD) : { build/asm/main_800EC430.s.o(.bss); }
    .main_800EC4AC 0x800EC4AC : AT(0x000E74AC) { build/asm/data/main_800EC4AC.bin.o(.data); }
    .assets 0x80406000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
