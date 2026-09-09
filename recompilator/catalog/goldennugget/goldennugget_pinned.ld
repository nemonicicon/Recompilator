SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80040F80 0x80040F80 : AT(0x00041B80) { FILL(0x00000000); build/asm/main_80040F80.s.o(.text); build/asm/main_80040F80.s.o(.rodata); build/asm/main_80040F80.s.o(.data); }
    .main_80040F80_bss (NOLOAD) : { build/asm/main_80040F80.s.o(.bss); }
    .main_80043EA4 0x80043EA4 : AT(0x00044AA4) { FILL(0x00000000); build/asm/main_80043EA4.s.o(.text); build/asm/main_80043EA4.s.o(.rodata); build/asm/main_80043EA4.s.o(.data); }
    .main_80043EA4_bss (NOLOAD) : { build/asm/main_80043EA4.s.o(.bss); }
    .main_8004610C 0x8004610C : AT(0x00046D0C) { FILL(0x00000000); build/asm/main_8004610C.s.o(.text); build/asm/main_8004610C.s.o(.rodata); build/asm/main_8004610C.s.o(.data); }
    .main_8004610C_bss (NOLOAD) : { build/asm/main_8004610C.s.o(.bss); }
    .main_80049C9C 0x80049C9C : AT(0x0004A89C) { FILL(0x00000000); build/asm/main_80049C9C.s.o(.text); build/asm/main_80049C9C.s.o(.rodata); build/asm/main_80049C9C.s.o(.data); }
    .main_80049C9C_bss (NOLOAD) : { build/asm/main_80049C9C.s.o(.bss); }
    .main_8004E454 0x8004E454 : AT(0x0004F054) { FILL(0x00000000); build/asm/main_8004E454.s.o(.text); build/asm/main_8004E454.s.o(.rodata); build/asm/main_8004E454.s.o(.data); }
    .main_8004E454_bss (NOLOAD) : { build/asm/main_8004E454.s.o(.bss); }
    .main_80051D6C 0x80051D6C : AT(0x0005296C) { FILL(0x00000000); build/asm/main_80051D6C.s.o(.text); build/asm/main_80051D6C.s.o(.rodata); build/asm/main_80051D6C.s.o(.data); }
    .main_80051D6C_bss (NOLOAD) : { build/asm/main_80051D6C.s.o(.bss); }
    .main_80054E74 0x80054E74 : AT(0x00055A74) { FILL(0x00000000); build/asm/main_80054E74.s.o(.text); build/asm/main_80054E74.s.o(.rodata); build/asm/main_80054E74.s.o(.data); }
    .main_80054E74_bss (NOLOAD) : { build/asm/main_80054E74.s.o(.bss); }
    .main_80059DBC 0x80059DBC : AT(0x0005A9BC) { FILL(0x00000000); build/asm/main_80059DBC.s.o(.text); build/asm/main_80059DBC.s.o(.rodata); build/asm/main_80059DBC.s.o(.data); }
    .main_80059DBC_bss (NOLOAD) : { build/asm/main_80059DBC.s.o(.bss); }
    .main_8005C5DC 0x8005C5DC : AT(0x0005D1DC) { FILL(0x00000000); build/asm/main_8005C5DC.s.o(.text); build/asm/main_8005C5DC.s.o(.rodata); build/asm/main_8005C5DC.s.o(.data); }
    .main_8005C5DC_bss (NOLOAD) : { build/asm/main_8005C5DC.s.o(.bss); }
    .main_8005DCD0 0x8005DCD0 : AT(0x0005E8D0) { FILL(0x00000000); build/asm/main_8005DCD0.s.o(.text); build/asm/main_8005DCD0.s.o(.rodata); build/asm/main_8005DCD0.s.o(.data); }
    .main_8005DCD0_bss (NOLOAD) : { build/asm/main_8005DCD0.s.o(.bss); }
    .main_8005E8E4 0x8005E8E4 : AT(0x0005F4E4) { FILL(0x00000000); build/asm/main_8005E8E4.s.o(.text); build/asm/main_8005E8E4.s.o(.rodata); build/asm/main_8005E8E4.s.o(.data); }
    .main_8005E8E4_bss (NOLOAD) : { build/asm/main_8005E8E4.s.o(.bss); }
    .main_8005EEA0 0x8005EEA0 : AT(0x0005FAA0) { FILL(0x00000000); build/asm/main_8005EEA0.s.o(.text); build/asm/main_8005EEA0.s.o(.rodata); build/asm/main_8005EEA0.s.o(.data); }
    .main_8005EEA0_bss (NOLOAD) : { build/asm/main_8005EEA0.s.o(.bss); }
    .main_8005FEF4 0x8005FEF4 : AT(0x00060AF4) { FILL(0x00000000); build/asm/main_8005FEF4.s.o(.text); build/asm/main_8005FEF4.s.o(.rodata); build/asm/main_8005FEF4.s.o(.data); }
    .main_8005FEF4_bss (NOLOAD) : { build/asm/main_8005FEF4.s.o(.bss); }
    .main_80060880 0x80060880 : AT(0x00061480) { FILL(0x00000000); build/asm/main_80060880.s.o(.text); build/asm/main_80060880.s.o(.rodata); build/asm/main_80060880.s.o(.data); }
    .main_80060880_bss (NOLOAD) : { build/asm/main_80060880.s.o(.bss); }
    .main_80060E10 0x80060E10 : AT(0x00061A10) { FILL(0x00000000); build/asm/main_80060E10.s.o(.text); build/asm/main_80060E10.s.o(.rodata); build/asm/main_80060E10.s.o(.data); }
    .main_80060E10_bss (NOLOAD) : { build/asm/main_80060E10.s.o(.bss); }
    .main_800618C0 0x800618C0 : AT(0x000624C0) { FILL(0x00000000); build/asm/main_800618C0.s.o(.text); build/asm/main_800618C0.s.o(.rodata); build/asm/main_800618C0.s.o(.data); }
    .main_800618C0_bss (NOLOAD) : { build/asm/main_800618C0.s.o(.bss); }
    .main_80062540 0x80062540 : AT(0x00063140) { FILL(0x00000000); build/asm/main_80062540.s.o(.text); build/asm/main_80062540.s.o(.rodata); build/asm/main_80062540.s.o(.data); }
    .main_80062540_bss (NOLOAD) : { build/asm/main_80062540.s.o(.bss); }
    .main_80063CA0 0x80063CA0 : AT(0x000648A0) { FILL(0x00000000); build/asm/main_80063CA0.s.o(.text); build/asm/main_80063CA0.s.o(.rodata); build/asm/main_80063CA0.s.o(.data); }
    .main_80063CA0_bss (NOLOAD) : { build/asm/main_80063CA0.s.o(.bss); }
    .main_80064680 0x80064680 : AT(0x00065280) { FILL(0x00000000); build/asm/main_80064680.s.o(.text); build/asm/main_80064680.s.o(.rodata); build/asm/main_80064680.s.o(.data); }
    .main_80064680_bss (NOLOAD) : { build/asm/main_80064680.s.o(.bss); }
    .main_80064CC0 0x80064CC0 : AT(0x000658C0) { FILL(0x00000000); build/asm/main_80064CC0.s.o(.text); build/asm/main_80064CC0.s.o(.rodata); build/asm/main_80064CC0.s.o(.data); }
    .main_80064CC0_bss (NOLOAD) : { build/asm/main_80064CC0.s.o(.bss); }
    .main_80064F64 0x80064F64 : AT(0x00065B64) { FILL(0x00000000); build/asm/main_80064F64.s.o(.text); build/asm/main_80064F64.s.o(.rodata); build/asm/main_80064F64.s.o(.data); }
    .main_80064F64_bss (NOLOAD) : { build/asm/main_80064F64.s.o(.bss); }
    .main_800662B4 0x800662B4 : AT(0x00066EB4) { FILL(0x00000000); build/asm/main_800662B4.s.o(.text); build/asm/main_800662B4.s.o(.rodata); build/asm/main_800662B4.s.o(.data); }
    .main_800662B4_bss (NOLOAD) : { build/asm/main_800662B4.s.o(.bss); }
    .main_8006785C 0x8006785C : AT(0x0006845C) { FILL(0x00000000); build/asm/main_8006785C.s.o(.text); build/asm/main_8006785C.s.o(.rodata); build/asm/main_8006785C.s.o(.data); }
    .main_8006785C_bss (NOLOAD) : { build/asm/main_8006785C.s.o(.bss); }
    .main_80069518 0x80069518 : AT(0x0006A118) { FILL(0x00000000); build/asm/main_80069518.s.o(.text); build/asm/main_80069518.s.o(.rodata); build/asm/main_80069518.s.o(.data); }
    .main_80069518_bss (NOLOAD) : { build/asm/main_80069518.s.o(.bss); }
    .main_8006974C 0x8006974C : AT(0x0006A34C) { FILL(0x00000000); build/asm/main_8006974C.s.o(.text); build/asm/main_8006974C.s.o(.rodata); build/asm/main_8006974C.s.o(.data); }
    .main_8006974C_bss (NOLOAD) : { build/asm/main_8006974C.s.o(.bss); }
    .main_8006A00C 0x8006A00C : AT(0x0006AC0C) { FILL(0x00000000); build/asm/main_8006A00C.s.o(.text); build/asm/main_8006A00C.s.o(.rodata); build/asm/main_8006A00C.s.o(.data); }
    .main_8006A00C_bss (NOLOAD) : { build/asm/main_8006A00C.s.o(.bss); }
    .main_8006A8A8 0x8006A8A8 : AT(0x0006B4A8) { FILL(0x00000000); build/asm/main_8006A8A8.s.o(.text); build/asm/main_8006A8A8.s.o(.rodata); build/asm/main_8006A8A8.s.o(.data); }
    .main_8006A8A8_bss (NOLOAD) : { build/asm/main_8006A8A8.s.o(.bss); }
    .main_8006B678 0x8006B678 : AT(0x0006C278) { FILL(0x00000000); build/asm/main_8006B678.s.o(.text); build/asm/main_8006B678.s.o(.rodata); build/asm/main_8006B678.s.o(.data); }
    .main_8006B678_bss (NOLOAD) : { build/asm/main_8006B678.s.o(.bss); }
    .main_8006B720 0x8006B720 : AT(0x0006C320) { FILL(0x00000000); build/asm/main_8006B720.s.o(.text); build/asm/main_8006B720.s.o(.rodata); build/asm/main_8006B720.s.o(.data); }
    .main_8006B720_bss (NOLOAD) : { build/asm/main_8006B720.s.o(.bss); }
    .main_8006E8D4 0x8006E8D4 : AT(0x0006F4D4) { FILL(0x00000000); build/asm/main_8006E8D4.s.o(.text); build/asm/main_8006E8D4.s.o(.rodata); build/asm/main_8006E8D4.s.o(.data); }
    .main_8006E8D4_bss (NOLOAD) : { build/asm/main_8006E8D4.s.o(.bss); }
    .main_8006EB64 0x8006EB64 : AT(0x0006F764) { FILL(0x00000000); build/asm/main_8006EB64.s.o(.text); build/asm/main_8006EB64.s.o(.rodata); build/asm/main_8006EB64.s.o(.data); }
    .main_8006EB64_bss (NOLOAD) : { build/asm/main_8006EB64.s.o(.bss); }
    .main_80071230 0x80071230 : AT(0x00071E30) { FILL(0x00000000); build/asm/main_80071230.s.o(.text); build/asm/main_80071230.s.o(.rodata); build/asm/main_80071230.s.o(.data); }
    .main_80071230_bss (NOLOAD) : { build/asm/main_80071230.s.o(.bss); }
    .main_80071710 0x80071710 : AT(0x00072310) { FILL(0x00000000); build/asm/main_80071710.s.o(.text); build/asm/main_80071710.s.o(.rodata); build/asm/main_80071710.s.o(.data); }
    .main_80071710_bss (NOLOAD) : { build/asm/main_80071710.s.o(.bss); }
    .main_800724C8 0x800724C8 : AT(0x000730C8) { FILL(0x00000000); build/asm/main_800724C8.s.o(.text); build/asm/main_800724C8.s.o(.rodata); build/asm/main_800724C8.s.o(.data); }
    .main_800724C8_bss (NOLOAD) : { build/asm/main_800724C8.s.o(.bss); }
    .main_80072758 0x80072758 : AT(0x00073358) { FILL(0x00000000); build/asm/main_80072758.s.o(.text); build/asm/main_80072758.s.o(.rodata); build/asm/main_80072758.s.o(.data); }
    .main_80072758_bss (NOLOAD) : { build/asm/main_80072758.s.o(.bss); }
    .main_80072A2C 0x80072A2C : AT(0x0007362C) { FILL(0x00000000); build/asm/main_80072A2C.s.o(.text); build/asm/main_80072A2C.s.o(.rodata); build/asm/main_80072A2C.s.o(.data); }
    .main_80072A2C_bss (NOLOAD) : { build/asm/main_80072A2C.s.o(.bss); }
    .main_80073E60 0x80073E60 : AT(0x00074A60) { FILL(0x00000000); build/asm/main_80073E60.s.o(.text); build/asm/main_80073E60.s.o(.rodata); build/asm/main_80073E60.s.o(.data); }
    .main_80073E60_bss (NOLOAD) : { build/asm/main_80073E60.s.o(.bss); }
    .main_80077A24 0x80077A24 : AT(0x00078624) { FILL(0x00000000); build/asm/main_80077A24.s.o(.text); build/asm/main_80077A24.s.o(.rodata); build/asm/main_80077A24.s.o(.data); }
    .main_80077A24_bss (NOLOAD) : { build/asm/main_80077A24.s.o(.bss); }
    .main_80077C70 0x80077C70 : AT(0x00078870) { FILL(0x00000000); build/asm/main_80077C70.s.o(.text); build/asm/main_80077C70.s.o(.rodata); build/asm/main_80077C70.s.o(.data); }
    .main_80077C70_bss (NOLOAD) : { build/asm/main_80077C70.s.o(.bss); }
    .main_800782C4 0x800782C4 : AT(0x00078EC4) { FILL(0x00000000); build/asm/main_800782C4.s.o(.text); build/asm/main_800782C4.s.o(.rodata); build/asm/main_800782C4.s.o(.data); }
    .main_800782C4_bss (NOLOAD) : { build/asm/main_800782C4.s.o(.bss); }
    .main_8007A0A0 0x8007A0A0 : AT(0x0007ACA0) { FILL(0x00000000); build/asm/main_8007A0A0.s.o(.text); build/asm/main_8007A0A0.s.o(.rodata); build/asm/main_8007A0A0.s.o(.data); }
    .main_8007A0A0_bss (NOLOAD) : { build/asm/main_8007A0A0.s.o(.bss); }
    .main_8007C700 0x8007C700 : AT(0x0007D300) { FILL(0x00000000); build/asm/main_8007C700.s.o(.text); build/asm/main_8007C700.s.o(.rodata); build/asm/main_8007C700.s.o(.data); }
    .main_8007C700_bss (NOLOAD) : { build/asm/main_8007C700.s.o(.bss); }
    .main_8007E698 0x8007E698 : AT(0x0007F298) { FILL(0x00000000); build/asm/main_8007E698.s.o(.text); build/asm/main_8007E698.s.o(.rodata); build/asm/main_8007E698.s.o(.data); }
    .main_8007E698_bss (NOLOAD) : { build/asm/main_8007E698.s.o(.bss); }
    .main_80083640 0x80083640 : AT(0x00084240) { FILL(0x00000000); build/asm/main_80083640.s.o(.text); build/asm/main_80083640.s.o(.rodata); build/asm/main_80083640.s.o(.data); }
    .main_80083640_bss (NOLOAD) : { build/asm/main_80083640.s.o(.bss); }
    .main_80087910 0x80087910 : AT(0x00088510) { FILL(0x00000000); build/asm/main_80087910.s.o(.text); build/asm/main_80087910.s.o(.rodata); build/asm/main_80087910.s.o(.data); }
    .main_80087910_bss (NOLOAD) : { build/asm/main_80087910.s.o(.bss); }
    .main_80088A90 0x80088A90 : AT(0x00089690) { FILL(0x00000000); build/asm/main_80088A90.s.o(.text); build/asm/main_80088A90.s.o(.rodata); build/asm/main_80088A90.s.o(.data); }
    .main_80088A90_bss (NOLOAD) : { build/asm/main_80088A90.s.o(.bss); }
    .main_80088CD0 0x80088CD0 : AT(0x000898D0) { FILL(0x00000000); build/asm/main_80088CD0.s.o(.text); build/asm/main_80088CD0.s.o(.rodata); build/asm/main_80088CD0.s.o(.data); }
    .main_80088CD0_bss (NOLOAD) : { build/asm/main_80088CD0.s.o(.bss); }
    .main_80088EC0 0x80088EC0 : AT(0x00089AC0) { FILL(0x00000000); build/asm/main_80088EC0.s.o(.text); build/asm/main_80088EC0.s.o(.rodata); build/asm/main_80088EC0.s.o(.data); }
    .main_80088EC0_bss (NOLOAD) : { build/asm/main_80088EC0.s.o(.bss); }
    .main_800891F0 0x800891F0 : AT(0x00089DF0) { FILL(0x00000000); build/asm/main_800891F0.s.o(.text); build/asm/main_800891F0.s.o(.rodata); build/asm/main_800891F0.s.o(.data); }
    .main_800891F0_bss (NOLOAD) : { build/asm/main_800891F0.s.o(.bss); }
    .main_80089420 0x80089420 : AT(0x0008A020) { FILL(0x00000000); build/asm/main_80089420.s.o(.text); build/asm/main_80089420.s.o(.rodata); build/asm/main_80089420.s.o(.data); }
    .main_80089420_bss (NOLOAD) : { build/asm/main_80089420.s.o(.bss); }
    .main_8008AAC0 0x8008AAC0 : AT(0x0008B6C0) { FILL(0x00000000); build/asm/main_8008AAC0.s.o(.text); build/asm/main_8008AAC0.s.o(.rodata); build/asm/main_8008AAC0.s.o(.data); }
    .main_8008AAC0_bss (NOLOAD) : { build/asm/main_8008AAC0.s.o(.bss); }
    .main_8008B394 0x8008B394 : AT(0x0008BF94) { FILL(0x00000000); build/asm/main_8008B394.s.o(.text); build/asm/main_8008B394.s.o(.rodata); build/asm/main_8008B394.s.o(.data); }
    .main_8008B394_bss (NOLOAD) : { build/asm/main_8008B394.s.o(.bss); }
    .main_8008B928 0x8008B928 : AT(0x0008C528) { FILL(0x00000000); build/asm/main_8008B928.s.o(.text); build/asm/main_8008B928.s.o(.rodata); build/asm/main_8008B928.s.o(.data); }
    .main_8008B928_bss (NOLOAD) : { build/asm/main_8008B928.s.o(.bss); }
    .main_8008CB14 0x8008CB14 : AT(0x0008D714) { FILL(0x00000000); build/asm/main_8008CB14.s.o(.text); build/asm/main_8008CB14.s.o(.rodata); build/asm/main_8008CB14.s.o(.data); }
    .main_8008CB14_bss (NOLOAD) : { build/asm/main_8008CB14.s.o(.bss); }
    .main_8008CF94 0x8008CF94 : AT(0x0008DB94) { FILL(0x00000000); build/asm/main_8008CF94.s.o(.text); build/asm/main_8008CF94.s.o(.rodata); build/asm/main_8008CF94.s.o(.data); }
    .main_8008CF94_bss (NOLOAD) : { build/asm/main_8008CF94.s.o(.bss); }
    .main_8008D1CC 0x8008D1CC : AT(0x0008DDCC) { FILL(0x00000000); build/asm/main_8008D1CC.s.o(.text); build/asm/main_8008D1CC.s.o(.rodata); build/asm/main_8008D1CC.s.o(.data); }
    .main_8008D1CC_bss (NOLOAD) : { build/asm/main_8008D1CC.s.o(.bss); }
    .main_8008D3C0 0x8008D3C0 : AT(0x0008DFC0) { FILL(0x00000000); build/asm/main_8008D3C0.s.o(.text); build/asm/main_8008D3C0.s.o(.rodata); build/asm/main_8008D3C0.s.o(.data); }
    .main_8008D3C0_bss (NOLOAD) : { build/asm/main_8008D3C0.s.o(.bss); }
    .main_8008DE70 0x8008DE70 : AT(0x0008EA70) { FILL(0x00000000); build/asm/main_8008DE70.s.o(.text); build/asm/main_8008DE70.s.o(.rodata); build/asm/main_8008DE70.s.o(.data); }
    .main_8008DE70_bss (NOLOAD) : { build/asm/main_8008DE70.s.o(.bss); }
    .main_8008EEA0 0x8008EEA0 : AT(0x0008FAA0) { FILL(0x00000000); build/asm/main_8008EEA0.s.o(.text); build/asm/main_8008EEA0.s.o(.rodata); build/asm/main_8008EEA0.s.o(.data); }
    .main_8008EEA0_bss (NOLOAD) : { build/asm/main_8008EEA0.s.o(.bss); }
    .main_80091924 0x80091924 : AT(0x00092524) { FILL(0x00000000); build/asm/main_80091924.s.o(.text); build/asm/main_80091924.s.o(.rodata); build/asm/main_80091924.s.o(.data); }
    .main_80091924_bss (NOLOAD) : { build/asm/main_80091924.s.o(.bss); }
    .main_80091B80 0x80091B80 : AT(0x00092780) { FILL(0x00000000); build/asm/main_80091B80.s.o(.text); build/asm/main_80091B80.s.o(.rodata); build/asm/main_80091B80.s.o(.data); }
    .main_80091B80_bss (NOLOAD) : { build/asm/main_80091B80.s.o(.bss); }
    .main_80091D80 0x80091D80 : AT(0x00092980) { FILL(0x00000000); build/asm/main_80091D80.s.o(.text); build/asm/main_80091D80.s.o(.rodata); build/asm/main_80091D80.s.o(.data); }
    .main_80091D80_bss (NOLOAD) : { build/asm/main_80091D80.s.o(.bss); }
    .main_80092364 0x80092364 : AT(0x00092F64) { FILL(0x00000000); build/asm/main_80092364.s.o(.text); build/asm/main_80092364.s.o(.rodata); build/asm/main_80092364.s.o(.data); }
    .main_80092364_bss (NOLOAD) : { build/asm/main_80092364.s.o(.bss); }
    .main_800927B0 0x800927B0 : AT(0x000933B0) { FILL(0x00000000); build/asm/main_800927B0.s.o(.text); build/asm/main_800927B0.s.o(.rodata); build/asm/main_800927B0.s.o(.data); }
    .main_800927B0_bss (NOLOAD) : { build/asm/main_800927B0.s.o(.bss); }
    .main_80092950 0x80092950 : AT(0x00093550) { FILL(0x00000000); build/asm/main_80092950.s.o(.text); build/asm/main_80092950.s.o(.rodata); build/asm/main_80092950.s.o(.data); }
    .main_80092950_bss (NOLOAD) : { build/asm/main_80092950.s.o(.bss); }
    .main_80092D50 0x80092D50 : AT(0x00093950) { FILL(0x00000000); build/asm/main_80092D50.s.o(.text); build/asm/main_80092D50.s.o(.rodata); build/asm/main_80092D50.s.o(.data); }
    .main_80092D50_bss (NOLOAD) : { build/asm/main_80092D50.s.o(.bss); }
    .main_80093410 0x80093410 : AT(0x00094010) { FILL(0x00000000); build/asm/main_80093410.s.o(.text); build/asm/main_80093410.s.o(.rodata); build/asm/main_80093410.s.o(.data); }
    .main_80093410_bss (NOLOAD) : { build/asm/main_80093410.s.o(.bss); }
    .main_80093CD0 0x80093CD0 : AT(0x000948D0) { FILL(0x00000000); build/asm/main_80093CD0.s.o(.text); build/asm/main_80093CD0.s.o(.rodata); build/asm/main_80093CD0.s.o(.data); }
    .main_80093CD0_bss (NOLOAD) : { build/asm/main_80093CD0.s.o(.bss); }
    .main_80094200 0x80094200 : AT(0x00094E00) { FILL(0x00000000); build/asm/main_80094200.s.o(.text); build/asm/main_80094200.s.o(.rodata); build/asm/main_80094200.s.o(.data); }
    .main_80094200_bss (NOLOAD) : { build/asm/main_80094200.s.o(.bss); }
    .main_80094AC0 0x80094AC0 : AT(0x000956C0) { FILL(0x00000000); build/asm/main_80094AC0.s.o(.text); build/asm/main_80094AC0.s.o(.rodata); build/asm/main_80094AC0.s.o(.data); }
    .main_80094AC0_bss (NOLOAD) : { build/asm/main_80094AC0.s.o(.bss); }
    .main_80095550 0x80095550 : AT(0x00096150) { FILL(0x00000000); build/asm/main_80095550.s.o(.text); build/asm/main_80095550.s.o(.rodata); build/asm/main_80095550.s.o(.data); }
    .main_80095550_bss (NOLOAD) : { build/asm/main_80095550.s.o(.bss); }
    .main_80095AD0 0x80095AD0 : AT(0x000966D0) { FILL(0x00000000); build/asm/main_80095AD0.s.o(.text); build/asm/main_80095AD0.s.o(.rodata); build/asm/main_80095AD0.s.o(.data); }
    .main_80095AD0_bss (NOLOAD) : { build/asm/main_80095AD0.s.o(.bss); }
    .main_800960A0 0x800960A0 : AT(0x00096CA0) { FILL(0x00000000); build/asm/main_800960A0.s.o(.text); build/asm/main_800960A0.s.o(.rodata); build/asm/main_800960A0.s.o(.data); }
    .main_800960A0_bss (NOLOAD) : { build/asm/main_800960A0.s.o(.bss); }
    .main_800963C8 0x800963C8 : AT(0x00096FC8) { FILL(0x00000000); build/asm/main_800963C8.s.o(.text); build/asm/main_800963C8.s.o(.rodata); build/asm/main_800963C8.s.o(.data); }
    .main_800963C8_bss (NOLOAD) : { build/asm/main_800963C8.s.o(.bss); }
    .main_80097000 0x80097000 : AT(0x00097C00) { FILL(0x00000000); build/asm/main_80097000.s.o(.text); build/asm/main_80097000.s.o(.rodata); build/asm/main_80097000.s.o(.data); }
    .main_80097000_bss (NOLOAD) : { build/asm/main_80097000.s.o(.bss); }
    .main_80097110 0x80097110 : AT(0x00097D10) { FILL(0x00000000); build/asm/main_80097110.s.o(.text); build/asm/main_80097110.s.o(.rodata); build/asm/main_80097110.s.o(.data); }
    .main_80097110_bss (NOLOAD) : { build/asm/main_80097110.s.o(.bss); }
    .main_800971D0 0x800971D0 : AT(0x00097DD0) { FILL(0x00000000); build/asm/main_800971D0.s.o(.text); build/asm/main_800971D0.s.o(.rodata); build/asm/main_800971D0.s.o(.data); }
    .main_800971D0_bss (NOLOAD) : { build/asm/main_800971D0.s.o(.bss); }
    .main_800981A0 0x800981A0 : AT(0x00098DA0) { FILL(0x00000000); build/asm/main_800981A0.s.o(.text); build/asm/main_800981A0.s.o(.rodata); build/asm/main_800981A0.s.o(.data); }
    .main_800981A0_bss (NOLOAD) : { build/asm/main_800981A0.s.o(.bss); }
    .main_800981F0 0x800981F0 : AT(0x00098DF0) { FILL(0x00000000); build/asm/main_800981F0.s.o(.text); build/asm/main_800981F0.s.o(.rodata); build/asm/main_800981F0.s.o(.data); }
    .main_800981F0_bss (NOLOAD) : { build/asm/main_800981F0.s.o(.bss); }
    .main_80099CF0 0x80099CF0 : AT(0x0009A8F0) { FILL(0x00000000); build/asm/main_80099CF0.s.o(.text); build/asm/main_80099CF0.s.o(.rodata); build/asm/main_80099CF0.s.o(.data); }
    .main_80099CF0_bss (NOLOAD) : { build/asm/main_80099CF0.s.o(.bss); }
    .main_8009B374 0x8009B374 : AT(0x0009BF74) { FILL(0x00000000); build/asm/main_8009B374.s.o(.text); build/asm/main_8009B374.s.o(.rodata); build/asm/main_8009B374.s.o(.data); }
    .main_8009B374_bss (NOLOAD) : { build/asm/main_8009B374.s.o(.bss); }
    .main_8009B6D0 0x8009B6D0 : AT(0x0009C2D0) { FILL(0x00000000); build/asm/main_8009B6D0.s.o(.text); build/asm/main_8009B6D0.s.o(.rodata); build/asm/main_8009B6D0.s.o(.data); }
    .main_8009B6D0_bss (NOLOAD) : { build/asm/main_8009B6D0.s.o(.bss); }
    .main_800A0820 0x800A0820 : AT(0x000A1420) { build/asm/data/main_800A0820.bin.o(.data); }
    .main_800A3FB0 0x800A3FB0 : AT(0x000A4BB0) { FILL(0x00000000); build/asm/main_800A3FB0.s.o(.text); build/asm/main_800A3FB0.s.o(.rodata); build/asm/main_800A3FB0.s.o(.data); }
    .main_800A3FB0_bss (NOLOAD) : { build/asm/main_800A3FB0.s.o(.bss); }
    .main_800A560C 0x800A560C : AT(0x000A620C) { FILL(0x00000000); build/asm/main_800A560C.s.o(.text); build/asm/main_800A560C.s.o(.rodata); build/asm/main_800A560C.s.o(.data); }
    .main_800A560C_bss (NOLOAD) : { build/asm/main_800A560C.s.o(.bss); }
    .main_800A6674 0x800A6674 : AT(0x000A7274) { build/asm/data/main_800A6674.bin.o(.data); }
    .main_800A682C 0x800A682C : AT(0x000A742C) { FILL(0x00000000); build/asm/main_800A682C.s.o(.text); build/asm/main_800A682C.s.o(.rodata); build/asm/main_800A682C.s.o(.data); }
    .main_800A682C_bss (NOLOAD) : { build/asm/main_800A682C.s.o(.bss); }
    .main_800A6B18 0x800A6B18 : AT(0x000A7718) { FILL(0x00000000); build/asm/main_800A6B18.s.o(.text); build/asm/main_800A6B18.s.o(.rodata); build/asm/main_800A6B18.s.o(.data); }
    .main_800A6B18_bss (NOLOAD) : { build/asm/main_800A6B18.s.o(.bss); }
    .main_800A7184 0x800A7184 : AT(0x000A7D84) { FILL(0x00000000); build/asm/main_800A7184.s.o(.text); build/asm/main_800A7184.s.o(.rodata); build/asm/main_800A7184.s.o(.data); }
    .main_800A7184_bss (NOLOAD) : { build/asm/main_800A7184.s.o(.bss); }
    .main_800A8594 0x800A8594 : AT(0x000A9194) { build/asm/data/main_800A8594.bin.o(.data); }
    .main_800A8D40 0x800A8D40 : AT(0x000A9940) { FILL(0x00000000); build/asm/main_800A8D40.s.o(.text); build/asm/main_800A8D40.s.o(.rodata); build/asm/main_800A8D40.s.o(.data); }
    .main_800A8D40_bss (NOLOAD) : { build/asm/main_800A8D40.s.o(.bss); }
    .main_800AB6D8 0x800AB6D8 : AT(0x000AC2D8) { FILL(0x00000000); build/asm/main_800AB6D8.s.o(.text); build/asm/main_800AB6D8.s.o(.rodata); build/asm/main_800AB6D8.s.o(.data); }
    .main_800AB6D8_bss (NOLOAD) : { build/asm/main_800AB6D8.s.o(.bss); }
    .main_800AB800 0x800AB800 : AT(0x000AC400) { FILL(0x00000000); build/asm/main_800AB800.s.o(.text); build/asm/main_800AB800.s.o(.rodata); build/asm/main_800AB800.s.o(.data); }
    .main_800AB800_bss (NOLOAD) : { build/asm/main_800AB800.s.o(.bss); }
    .main_800ABBDC 0x800ABBDC : AT(0x000AC7DC) { FILL(0x00000000); build/asm/main_800ABBDC.s.o(.text); build/asm/main_800ABBDC.s.o(.rodata); build/asm/main_800ABBDC.s.o(.data); }
    .main_800ABBDC_bss (NOLOAD) : { build/asm/main_800ABBDC.s.o(.bss); }
    .main_800ABD04 0x800ABD04 : AT(0x000AC904) { FILL(0x00000000); build/asm/main_800ABD04.s.o(.text); build/asm/main_800ABD04.s.o(.rodata); build/asm/main_800ABD04.s.o(.data); }
    .main_800ABD04_bss (NOLOAD) : { build/asm/main_800ABD04.s.o(.bss); }
    .main_800AC6E4 0x800AC6E4 : AT(0x000AD2E4) { FILL(0x00000000); build/asm/main_800AC6E4.s.o(.text); build/asm/main_800AC6E4.s.o(.rodata); build/asm/main_800AC6E4.s.o(.data); }
    .main_800AC6E4_bss (NOLOAD) : { build/asm/main_800AC6E4.s.o(.bss); }
    .main_800ACA8C 0x800ACA8C : AT(0x000AD68C) { FILL(0x00000000); build/asm/main_800ACA8C.s.o(.text); build/asm/main_800ACA8C.s.o(.rodata); build/asm/main_800ACA8C.s.o(.data); }
    .main_800ACA8C_bss (NOLOAD) : { build/asm/main_800ACA8C.s.o(.bss); }
    .main_800AD1AC 0x800AD1AC : AT(0x000ADDAC) { FILL(0x00000000); build/asm/main_800AD1AC.s.o(.text); build/asm/main_800AD1AC.s.o(.rodata); build/asm/main_800AD1AC.s.o(.data); }
    .main_800AD1AC_bss (NOLOAD) : { build/asm/main_800AD1AC.s.o(.bss); }
    .main_800AE09C 0x800AE09C : AT(0x000AEC9C) { FILL(0x00000000); build/asm/main_800AE09C.s.o(.text); build/asm/main_800AE09C.s.o(.rodata); build/asm/main_800AE09C.s.o(.data); }
    .main_800AE09C_bss (NOLOAD) : { build/asm/main_800AE09C.s.o(.bss); }
    .main_800AEFDC 0x800AEFDC : AT(0x000AFBDC) { FILL(0x00000000); build/asm/main_800AEFDC.s.o(.text); build/asm/main_800AEFDC.s.o(.rodata); build/asm/main_800AEFDC.s.o(.data); }
    .main_800AEFDC_bss (NOLOAD) : { build/asm/main_800AEFDC.s.o(.bss); }
    .main_800AF90C 0x800AF90C : AT(0x000B050C) { FILL(0x00000000); build/asm/main_800AF90C.s.o(.text); build/asm/main_800AF90C.s.o(.rodata); build/asm/main_800AF90C.s.o(.data); }
    .main_800AF90C_bss (NOLOAD) : { build/asm/main_800AF90C.s.o(.bss); }
    .main_800AFAB4 0x800AFAB4 : AT(0x000B06B4) { FILL(0x00000000); build/asm/main_800AFAB4.s.o(.text); build/asm/main_800AFAB4.s.o(.rodata); build/asm/main_800AFAB4.s.o(.data); }
    .main_800AFAB4_bss (NOLOAD) : { build/asm/main_800AFAB4.s.o(.bss); }
    .main_800AFCE4 0x800AFCE4 : AT(0x000B08E4) { FILL(0x00000000); build/asm/main_800AFCE4.s.o(.text); build/asm/main_800AFCE4.s.o(.rodata); build/asm/main_800AFCE4.s.o(.data); }
    .main_800AFCE4_bss (NOLOAD) : { build/asm/main_800AFCE4.s.o(.bss); }
    .main_800AFD70 0x800AFD70 : AT(0x000B0970) { FILL(0x00000000); build/asm/main_800AFD70.s.o(.text); build/asm/main_800AFD70.s.o(.rodata); build/asm/main_800AFD70.s.o(.data); }
    .main_800AFD70_bss (NOLOAD) : { build/asm/main_800AFD70.s.o(.bss); }
    .main_800B1014 0x800B1014 : AT(0x000B1C14) { build/asm/data/main_800B1014.bin.o(.data); }
    .main_800B1CD0 0x800B1CD0 : AT(0x000B28D0) { FILL(0x00000000); build/asm/main_800B1CD0.s.o(.text); build/asm/main_800B1CD0.s.o(.rodata); build/asm/main_800B1CD0.s.o(.data); }
    .main_800B1CD0_bss (NOLOAD) : { build/asm/main_800B1CD0.s.o(.bss); }
    .main_800B1D04 0x800B1D04 : AT(0x000B2904) { build/asm/data/main_800B1D04.bin.o(.data); }
    .main_800B20D0 0x800B20D0 : AT(0x000B2CD0) { FILL(0x00000000); build/asm/main_800B20D0.s.o(.text); build/asm/main_800B20D0.s.o(.rodata); build/asm/main_800B20D0.s.o(.data); }
    .main_800B20D0_bss (NOLOAD) : { build/asm/main_800B20D0.s.o(.bss); }
    .main_800B20D8 0x800B20D8 : AT(0x000B2CD8) { build/asm/data/main_800B20D8.bin.o(.data); }
    .main_800B5C9C 0x800B5C9C : AT(0x000B689C) { FILL(0x00000000); build/asm/main_800B5C9C.s.o(.text); build/asm/main_800B5C9C.s.o(.rodata); build/asm/main_800B5C9C.s.o(.data); }
    .main_800B5C9C_bss (NOLOAD) : { build/asm/main_800B5C9C.s.o(.bss); }
    .main_800B69B4 0x800B69B4 : AT(0x000B75B4) { FILL(0x00000000); build/asm/main_800B69B4.s.o(.text); build/asm/main_800B69B4.s.o(.rodata); build/asm/main_800B69B4.s.o(.data); }
    .main_800B69B4_bss (NOLOAD) : { build/asm/main_800B69B4.s.o(.bss); }
    .main_800B7330 0x800B7330 : AT(0x000B7F30) { build/asm/data/main_800B7330.bin.o(.data); }
    .main_800B73E4 0x800B73E4 : AT(0x000B7FE4) { FILL(0x00000000); build/asm/main_800B73E4.s.o(.text); build/asm/main_800B73E4.s.o(.rodata); build/asm/main_800B73E4.s.o(.data); }
    .main_800B73E4_bss (NOLOAD) : { build/asm/main_800B73E4.s.o(.bss); }
    .main_800B80E8 0x800B80E8 : AT(0x000B8CE8) { build/asm/data/main_800B80E8.bin.o(.data); }
    .main_800B89E8 0x800B89E8 : AT(0x000B95E8) { build/asm/data/main_800B89E8.bin.o(.data); }
    .main_800B963C 0x800B963C : AT(0x000BA23C) { build/asm/data/main_800B963C.bin.o(.data); }
    .main_800B9DBC 0x800B9DBC : AT(0x000BA9BC) { build/asm/data/main_800B9DBC.bin.o(.data); }
    .main_800BA73C 0x800BA73C : AT(0x000BB33C) { FILL(0x00000000); build/asm/main_800BA73C.s.o(.text); build/asm/main_800BA73C.s.o(.rodata); build/asm/main_800BA73C.s.o(.data); }
    .main_800BA73C_bss (NOLOAD) : { build/asm/main_800BA73C.s.o(.bss); }
    .main_800BA9F0 0x800BA9F0 : AT(0x000BB5F0) { build/asm/data/main_800BA9F0.bin.o(.data); }
    .main_800BAE04 0x800BAE04 : AT(0x000BBA04) { FILL(0x00000000); build/asm/main_800BAE04.s.o(.text); build/asm/main_800BAE04.s.o(.rodata); build/asm/main_800BAE04.s.o(.data); }
    .main_800BAE04_bss (NOLOAD) : { build/asm/main_800BAE04.s.o(.bss); }
    .main_800BB09C 0x800BB09C : AT(0x000BBC9C) { FILL(0x00000000); build/asm/main_800BB09C.s.o(.text); build/asm/main_800BB09C.s.o(.rodata); build/asm/main_800BB09C.s.o(.data); }
    .main_800BB09C_bss (NOLOAD) : { build/asm/main_800BB09C.s.o(.bss); }
    .main_800BFEAC 0x800BFEAC : AT(0x000C0AAC) { FILL(0x00000000); build/asm/main_800BFEAC.s.o(.text); build/asm/main_800BFEAC.s.o(.rodata); build/asm/main_800BFEAC.s.o(.data); }
    .main_800BFEAC_bss (NOLOAD) : { build/asm/main_800BFEAC.s.o(.bss); }
    .main_800C0270 0x800C0270 : AT(0x000C0E70) { build/asm/data/main_800C0270.bin.o(.data); }
    .main_800C2528 0x800C2528 : AT(0x000C3128) { FILL(0x00000000); build/asm/main_800C2528.s.o(.text); build/asm/main_800C2528.s.o(.rodata); build/asm/main_800C2528.s.o(.data); }
    .main_800C2528_bss (NOLOAD) : { build/asm/main_800C2528.s.o(.bss); }
    .main_800C2574 0x800C2574 : AT(0x000C3174) { build/asm/data/main_800C2574.bin.o(.data); }
    .main_800C2754 0x800C2754 : AT(0x000C3354) { FILL(0x00000000); build/asm/main_800C2754.s.o(.text); build/asm/main_800C2754.s.o(.rodata); build/asm/main_800C2754.s.o(.data); }
    .main_800C2754_bss (NOLOAD) : { build/asm/main_800C2754.s.o(.bss); }
    .main_800C2764 0x800C2764 : AT(0x000C3364) { build/asm/data/main_800C2764.bin.o(.data); }
    .main_800C2854 0x800C2854 : AT(0x000C3454) { FILL(0x00000000); build/asm/main_800C2854.s.o(.text); build/asm/main_800C2854.s.o(.rodata); build/asm/main_800C2854.s.o(.data); }
    .main_800C2854_bss (NOLOAD) : { build/asm/main_800C2854.s.o(.bss); }
    .main_800C2888 0x800C2888 : AT(0x000C3488) { build/asm/data/main_800C2888.bin.o(.data); }
    .main_800C2B9C 0x800C2B9C : AT(0x000C379C) { build/asm/data/main_800C2B9C.bin.o(.data); }
    .main_800C3000 0x800C3000 : AT(0x000C3C00) { FILL(0x00000000); build/asm/main_800C3000.s.o(.text); build/asm/main_800C3000.s.o(.rodata); build/asm/main_800C3000.s.o(.data); }
    .main_800C3000_bss (NOLOAD) : { build/asm/main_800C3000.s.o(.bss); }
    .main_800C3044 0x800C3044 : AT(0x000C3C44) { build/asm/data/main_800C3044.bin.o(.data); }
    .main_800C3C90 0x800C3C90 : AT(0x000C4890) { FILL(0x00000000); build/asm/main_800C3C90.s.o(.text); build/asm/main_800C3C90.s.o(.rodata); build/asm/main_800C3C90.s.o(.data); }
    .main_800C3C90_bss (NOLOAD) : { build/asm/main_800C3C90.s.o(.bss); }
    .main_800C4008 0x800C4008 : AT(0x000C4C08) { build/asm/data/main_800C4008.bin.o(.data); }
    .main_800C40E4 0x800C40E4 : AT(0x000C4CE4) { build/asm/data/main_800C40E4.bin.o(.data); }
    .main_800C4810 0x800C4810 : AT(0x000C5410) { build/asm/data/main_800C4810.bin.o(.data); }
    .main_800C4FF4 0x800C4FF4 : AT(0x000C5BF4) { FILL(0x00000000); build/asm/main_800C4FF4.s.o(.text); build/asm/main_800C4FF4.s.o(.rodata); build/asm/main_800C4FF4.s.o(.data); }
    .main_800C4FF4_bss (NOLOAD) : { build/asm/main_800C4FF4.s.o(.bss); }
    .main_800C50BC 0x800C50BC : AT(0x000C5CBC) { FILL(0x00000000); build/asm/main_800C50BC.s.o(.text); build/asm/main_800C50BC.s.o(.rodata); build/asm/main_800C50BC.s.o(.data); }
    .main_800C50BC_bss (NOLOAD) : { build/asm/main_800C50BC.s.o(.bss); }
    .main_800C52A8 0x800C52A8 : AT(0x000C5EA8) { FILL(0x00000000); build/asm/main_800C52A8.s.o(.text); build/asm/main_800C52A8.s.o(.rodata); build/asm/main_800C52A8.s.o(.data); }
    .main_800C52A8_bss (NOLOAD) : { build/asm/main_800C52A8.s.o(.bss); }
    .main_800C53E8 0x800C53E8 : AT(0x000C5FE8) { build/asm/data/main_800C53E8.bin.o(.data); }
    .main_800C54E8 0x800C54E8 : AT(0x000C60E8) { build/asm/data/main_800C54E8.bin.o(.data); }
    .main_800C56A0 0x800C56A0 : AT(0x000C62A0) { FILL(0x00000000); build/asm/main_800C56A0.s.o(.text); build/asm/main_800C56A0.s.o(.rodata); build/asm/main_800C56A0.s.o(.data); }
    .main_800C56A0_bss (NOLOAD) : { build/asm/main_800C56A0.s.o(.bss); }
    .main_800C56A4 0x800C56A4 : AT(0x000C62A4) { build/asm/data/main_800C56A4.bin.o(.data); }
    .main_800C57BC 0x800C57BC : AT(0x000C63BC) { FILL(0x00000000); build/asm/main_800C57BC.s.o(.text); build/asm/main_800C57BC.s.o(.rodata); build/asm/main_800C57BC.s.o(.data); }
    .main_800C57BC_bss (NOLOAD) : { build/asm/main_800C57BC.s.o(.bss); }
    .main_800C5FA0 0x800C5FA0 : AT(0x000C6BA0) { FILL(0x00000000); build/asm/main_800C5FA0.s.o(.text); build/asm/main_800C5FA0.s.o(.rodata); build/asm/main_800C5FA0.s.o(.data); }
    .main_800C5FA0_bss (NOLOAD) : { build/asm/main_800C5FA0.s.o(.bss); }
    .main_800C658C 0x800C658C : AT(0x000C718C) { FILL(0x00000000); build/asm/main_800C658C.s.o(.text); build/asm/main_800C658C.s.o(.rodata); build/asm/main_800C658C.s.o(.data); }
    .main_800C658C_bss (NOLOAD) : { build/asm/main_800C658C.s.o(.bss); }
    .main_800C69D0 0x800C69D0 : AT(0x000C75D0) { FILL(0x00000000); build/asm/main_800C69D0.s.o(.text); build/asm/main_800C69D0.s.o(.rodata); build/asm/main_800C69D0.s.o(.data); }
    .main_800C69D0_bss (NOLOAD) : { build/asm/main_800C69D0.s.o(.bss); }
    .main_800C6B88 0x800C6B88 : AT(0x000C7788) { build/asm/data/main_800C6B88.bin.o(.data); }
    .main_800C6C68 0x800C6C68 : AT(0x000C7868) { FILL(0x00000000); build/asm/main_800C6C68.s.o(.text); build/asm/main_800C6C68.s.o(.rodata); build/asm/main_800C6C68.s.o(.data); }
    .main_800C6C68_bss (NOLOAD) : { build/asm/main_800C6C68.s.o(.bss); }
    .main_800C6ED8 0x800C6ED8 : AT(0x000C7AD8) { FILL(0x00000000); build/asm/main_800C6ED8.s.o(.text); build/asm/main_800C6ED8.s.o(.rodata); build/asm/main_800C6ED8.s.o(.data); }
    .main_800C6ED8_bss (NOLOAD) : { build/asm/main_800C6ED8.s.o(.bss); }
    .main_800C70C8 0x800C70C8 : AT(0x000C7CC8) { build/asm/data/main_800C70C8.bin.o(.data); }
    .main_800C72D0 0x800C72D0 : AT(0x000C7ED0) { FILL(0x00000000); build/asm/main_800C72D0.s.o(.text); build/asm/main_800C72D0.s.o(.rodata); build/asm/main_800C72D0.s.o(.data); }
    .main_800C72D0_bss (NOLOAD) : { build/asm/main_800C72D0.s.o(.bss); }
    .main_800C7404 0x800C7404 : AT(0x000C8004) { FILL(0x00000000); build/asm/main_800C7404.s.o(.text); build/asm/main_800C7404.s.o(.rodata); build/asm/main_800C7404.s.o(.data); }
    .main_800C7404_bss (NOLOAD) : { build/asm/main_800C7404.s.o(.bss); }
    .main_800C79BC 0x800C79BC : AT(0x000C85BC) { FILL(0x00000000); build/asm/main_800C79BC.s.o(.text); build/asm/main_800C79BC.s.o(.rodata); build/asm/main_800C79BC.s.o(.data); }
    .main_800C79BC_bss (NOLOAD) : { build/asm/main_800C79BC.s.o(.bss); }
    .main_800C7B70 0x800C7B70 : AT(0x000C8770) { FILL(0x00000000); build/asm/main_800C7B70.s.o(.text); build/asm/main_800C7B70.s.o(.rodata); build/asm/main_800C7B70.s.o(.data); }
    .main_800C7B70_bss (NOLOAD) : { build/asm/main_800C7B70.s.o(.bss); }
    .main_800C7F30 0x800C7F30 : AT(0x000C8B30) { build/asm/data/main_800C7F30.bin.o(.data); }
    .main_800C8734 0x800C8734 : AT(0x000C9334) { build/asm/data/main_800C8734.bin.o(.data); }
    .main_800C988C 0x800C988C : AT(0x000CA48C) { build/asm/data/main_800C988C.bin.o(.data); }
    .main_800CA388 0x800CA388 : AT(0x000CAF88) { FILL(0x00000000); build/asm/main_800CA388.s.o(.text); build/asm/main_800CA388.s.o(.rodata); build/asm/main_800CA388.s.o(.data); }
    .main_800CA388_bss (NOLOAD) : { build/asm/main_800CA388.s.o(.bss); }
    .main_800CA3DC 0x800CA3DC : AT(0x000CAFDC) { build/asm/data/main_800CA3DC.bin.o(.data); }
    .main_800CA55C 0x800CA55C : AT(0x000CB15C) { FILL(0x00000000); build/asm/main_800CA55C.s.o(.text); build/asm/main_800CA55C.s.o(.rodata); build/asm/main_800CA55C.s.o(.data); }
    .main_800CA55C_bss (NOLOAD) : { build/asm/main_800CA55C.s.o(.bss); }
    .main_800CA91C 0x800CA91C : AT(0x000CB51C) { FILL(0x00000000); build/asm/main_800CA91C.s.o(.text); build/asm/main_800CA91C.s.o(.rodata); build/asm/main_800CA91C.s.o(.data); }
    .main_800CA91C_bss (NOLOAD) : { build/asm/main_800CA91C.s.o(.bss); }
    .main_800CABC4 0x800CABC4 : AT(0x000CB7C4) { build/asm/data/main_800CABC4.bin.o(.data); }
    .main_800CAE58 0x800CAE58 : AT(0x000CBA58) { FILL(0x00000000); build/asm/main_800CAE58.s.o(.text); build/asm/main_800CAE58.s.o(.rodata); build/asm/main_800CAE58.s.o(.data); }
    .main_800CAE58_bss (NOLOAD) : { build/asm/main_800CAE58.s.o(.bss); }
    .main_800CAE80 0x800CAE80 : AT(0x000CBA80) { build/asm/data/main_800CAE80.bin.o(.data); }
    .main_800CBD94 0x800CBD94 : AT(0x000CC994) { build/asm/data/main_800CBD94.bin.o(.data); }
    .main_800CD0E4 0x800CD0E4 : AT(0x000CDCE4) { FILL(0x00000000); build/asm/main_800CD0E4.s.o(.text); build/asm/main_800CD0E4.s.o(.rodata); build/asm/main_800CD0E4.s.o(.data); }
    .main_800CD0E4_bss (NOLOAD) : { build/asm/main_800CD0E4.s.o(.bss); }
    .main_800CD12C 0x800CD12C : AT(0x000CDD2C) { build/asm/data/main_800CD12C.bin.o(.data); }
    .main_800CE8D0 0x800CE8D0 : AT(0x000CF4D0) { FILL(0x00000000); build/asm/main_800CE8D0.s.o(.text); build/asm/main_800CE8D0.s.o(.rodata); build/asm/main_800CE8D0.s.o(.data); }
    .main_800CE8D0_bss (NOLOAD) : { build/asm/main_800CE8D0.s.o(.bss); }
    .main_800CE900 0x800CE900 : AT(0x000CF500) { build/asm/data/main_800CE900.bin.o(.data); }
    .main_800CE980 0x800CE980 : AT(0x000CF580) { FILL(0x00000000); build/asm/main_800CE980.s.o(.text); build/asm/main_800CE980.s.o(.rodata); build/asm/main_800CE980.s.o(.data); }
    .main_800CE980_bss (NOLOAD) : { build/asm/main_800CE980.s.o(.bss); }
    .main_800CE9C4 0x800CE9C4 : AT(0x000CF5C4) { build/asm/data/main_800CE9C4.bin.o(.data); }
    .main_800CEF88 0x800CEF88 : AT(0x000CFB88) { FILL(0x00000000); build/asm/main_800CEF88.s.o(.text); build/asm/main_800CEF88.s.o(.rodata); build/asm/main_800CEF88.s.o(.data); }
    .main_800CEF88_bss (NOLOAD) : { build/asm/main_800CEF88.s.o(.bss); }
    .main_800CEFBC 0x800CEFBC : AT(0x000CFBBC) { build/asm/data/main_800CEFBC.bin.o(.data); }
    .main_800CF168 0x800CF168 : AT(0x000CFD68) { FILL(0x00000000); build/asm/main_800CF168.s.o(.text); build/asm/main_800CF168.s.o(.rodata); build/asm/main_800CF168.s.o(.data); }
    .main_800CF168_bss (NOLOAD) : { build/asm/main_800CF168.s.o(.bss); }
    .main_800CF1C0 0x800CF1C0 : AT(0x000CFDC0) { build/asm/data/main_800CF1C0.bin.o(.data); }
    .main_800CF2DC 0x800CF2DC : AT(0x000CFEDC) { FILL(0x00000000); build/asm/main_800CF2DC.s.o(.text); build/asm/main_800CF2DC.s.o(.rodata); build/asm/main_800CF2DC.s.o(.data); }
    .main_800CF2DC_bss (NOLOAD) : { build/asm/main_800CF2DC.s.o(.bss); }
    .main_800CF2E0 0x800CF2E0 : AT(0x000CFEE0) { build/asm/data/main_800CF2E0.bin.o(.data); }
    .main_800CF3CC 0x800CF3CC : AT(0x000CFFCC) { FILL(0x00000000); build/asm/main_800CF3CC.s.o(.text); build/asm/main_800CF3CC.s.o(.rodata); build/asm/main_800CF3CC.s.o(.data); }
    .main_800CF3CC_bss (NOLOAD) : { build/asm/main_800CF3CC.s.o(.bss); }
    .main_800CF410 0x800CF410 : AT(0x000D0010) { build/asm/data/main_800CF410.bin.o(.data); }
    .main_800CF67C 0x800CF67C : AT(0x000D027C) { FILL(0x00000000); build/asm/main_800CF67C.s.o(.text); build/asm/main_800CF67C.s.o(.rodata); build/asm/main_800CF67C.s.o(.data); }
    .main_800CF67C_bss (NOLOAD) : { build/asm/main_800CF67C.s.o(.bss); }
    .main_800CF77C 0x800CF77C : AT(0x000D037C) { build/asm/data/main_800CF77C.bin.o(.data); }
    .main_800CF7DC 0x800CF7DC : AT(0x000D03DC) { FILL(0x00000000); build/asm/main_800CF7DC.s.o(.text); build/asm/main_800CF7DC.s.o(.rodata); build/asm/main_800CF7DC.s.o(.data); }
    .main_800CF7DC_bss (NOLOAD) : { build/asm/main_800CF7DC.s.o(.bss); }
    .main_800CF8A8 0x800CF8A8 : AT(0x000D04A8) { build/asm/data/main_800CF8A8.bin.o(.data); }
    .main_800D019C 0x800D019C : AT(0x000D0D9C) { FILL(0x00000000); build/asm/main_800D019C.s.o(.text); build/asm/main_800D019C.s.o(.rodata); build/asm/main_800D019C.s.o(.data); }
    .main_800D019C_bss (NOLOAD) : { build/asm/main_800D019C.s.o(.bss); }
    .main_800D01AC 0x800D01AC : AT(0x000D0DAC) { build/asm/data/main_800D01AC.bin.o(.data); }
    .main_800D0514 0x800D0514 : AT(0x000D1114) { FILL(0x00000000); build/asm/main_800D0514.s.o(.text); build/asm/main_800D0514.s.o(.rodata); build/asm/main_800D0514.s.o(.data); }
    .main_800D0514_bss (NOLOAD) : { build/asm/main_800D0514.s.o(.bss); }
    .main_800D0578 0x800D0578 : AT(0x000D1178) { build/asm/data/main_800D0578.bin.o(.data); }
    .main_800D1CEC 0x800D1CEC : AT(0x000D28EC) { FILL(0x00000000); build/asm/main_800D1CEC.s.o(.text); build/asm/main_800D1CEC.s.o(.rodata); build/asm/main_800D1CEC.s.o(.data); }
    .main_800D1CEC_bss (NOLOAD) : { build/asm/main_800D1CEC.s.o(.bss); }
    .main_800D1DA0 0x800D1DA0 : AT(0x000D29A0) { build/asm/data/main_800D1DA0.bin.o(.data); }
    .main_800D2D38 0x800D2D38 : AT(0x000D3938) { FILL(0x00000000); build/asm/main_800D2D38.s.o(.text); build/asm/main_800D2D38.s.o(.rodata); build/asm/main_800D2D38.s.o(.data); }
    .main_800D2D38_bss (NOLOAD) : { build/asm/main_800D2D38.s.o(.bss); }
    .main_800D2E40 0x800D2E40 : AT(0x000D3A40) { build/asm/data/main_800D2E40.bin.o(.data); }
    .main_800D336C 0x800D336C : AT(0x000D3F6C) { FILL(0x00000000); build/asm/main_800D336C.s.o(.text); build/asm/main_800D336C.s.o(.rodata); build/asm/main_800D336C.s.o(.data); }
    .main_800D336C_bss (NOLOAD) : { build/asm/main_800D336C.s.o(.bss); }
    .main_800D3384 0x800D3384 : AT(0x000D3F84) { build/asm/data/main_800D3384.bin.o(.data); }
    .main_800D3848 0x800D3848 : AT(0x000D4448) { FILL(0x00000000); build/asm/main_800D3848.s.o(.text); build/asm/main_800D3848.s.o(.rodata); build/asm/main_800D3848.s.o(.data); }
    .main_800D3848_bss (NOLOAD) : { build/asm/main_800D3848.s.o(.bss); }
    .main_800D385C 0x800D385C : AT(0x000D445C) { build/asm/data/main_800D385C.bin.o(.data); }
    .main_800D3928 0x800D3928 : AT(0x000D4528) { FILL(0x00000000); build/asm/main_800D3928.s.o(.text); build/asm/main_800D3928.s.o(.rodata); build/asm/main_800D3928.s.o(.data); }
    .main_800D3928_bss (NOLOAD) : { build/asm/main_800D3928.s.o(.bss); }
    .main_800D39AC 0x800D39AC : AT(0x000D45AC) { build/asm/data/main_800D39AC.bin.o(.data); }
    .main_800D3A84 0x800D3A84 : AT(0x000D4684) { FILL(0x00000000); build/asm/main_800D3A84.s.o(.text); build/asm/main_800D3A84.s.o(.rodata); build/asm/main_800D3A84.s.o(.data); }
    .main_800D3A84_bss (NOLOAD) : { build/asm/main_800D3A84.s.o(.bss); }
    .main_800D3B0C 0x800D3B0C : AT(0x000D470C) { build/asm/data/main_800D3B0C.bin.o(.data); }
    .main_800D41D4 0x800D41D4 : AT(0x000D4DD4) { FILL(0x00000000); build/asm/main_800D41D4.s.o(.text); build/asm/main_800D41D4.s.o(.rodata); build/asm/main_800D41D4.s.o(.data); }
    .main_800D41D4_bss (NOLOAD) : { build/asm/main_800D41D4.s.o(.bss); }
    .main_800D41F8 0x800D41F8 : AT(0x000D4DF8) { build/asm/data/main_800D41F8.bin.o(.data); }
    .main_800D507C 0x800D507C : AT(0x000D5C7C) { FILL(0x00000000); build/asm/main_800D507C.s.o(.text); build/asm/main_800D507C.s.o(.rodata); build/asm/main_800D507C.s.o(.data); }
    .main_800D507C_bss (NOLOAD) : { build/asm/main_800D507C.s.o(.bss); }
    .main_800D51F4 0x800D51F4 : AT(0x000D5DF4) { build/asm/data/main_800D51F4.bin.o(.data); }
    .main_800D56CC 0x800D56CC : AT(0x000D62CC) { FILL(0x00000000); build/asm/main_800D56CC.s.o(.text); build/asm/main_800D56CC.s.o(.rodata); build/asm/main_800D56CC.s.o(.data); }
    .main_800D56CC_bss (NOLOAD) : { build/asm/main_800D56CC.s.o(.bss); }
    .main_800D5790 0x800D5790 : AT(0x000D6390) { build/asm/data/main_800D5790.bin.o(.data); }
    .main_800D58F0 0x800D58F0 : AT(0x000D64F0) { FILL(0x00000000); build/asm/main_800D58F0.s.o(.text); build/asm/main_800D58F0.s.o(.rodata); build/asm/main_800D58F0.s.o(.data); }
    .main_800D58F0_bss (NOLOAD) : { build/asm/main_800D58F0.s.o(.bss); }
    .main_800D5960 0x800D5960 : AT(0x000D6560) { build/asm/data/main_800D5960.bin.o(.data); }
    .main_800D5F8C 0x800D5F8C : AT(0x000D6B8C) { FILL(0x00000000); build/asm/main_800D5F8C.s.o(.text); build/asm/main_800D5F8C.s.o(.rodata); build/asm/main_800D5F8C.s.o(.data); }
    .main_800D5F8C_bss (NOLOAD) : { build/asm/main_800D5F8C.s.o(.bss); }
    .main_800D5FD0 0x800D5FD0 : AT(0x000D6BD0) { build/asm/data/main_800D5FD0.bin.o(.data); }
    .main_800D7EF0 0x800D7EF0 : AT(0x000D8AF0) { FILL(0x00000000); build/asm/main_800D7EF0.s.o(.text); build/asm/main_800D7EF0.s.o(.rodata); build/asm/main_800D7EF0.s.o(.data); }
    .main_800D7EF0_bss (NOLOAD) : { build/asm/main_800D7EF0.s.o(.bss); }
    .main_800D7F10 0x800D7F10 : AT(0x000D8B10) { build/asm/data/main_800D7F10.bin.o(.data); }
    .main_800D9AE0 0x800D9AE0 : AT(0x000DA6E0) { FILL(0x00000000); build/asm/main_800D9AE0.s.o(.text); build/asm/main_800D9AE0.s.o(.rodata); build/asm/main_800D9AE0.s.o(.data); }
    .main_800D9AE0_bss (NOLOAD) : { build/asm/main_800D9AE0.s.o(.bss); }
    .main_800D9AFC 0x800D9AFC : AT(0x000DA6FC) { build/asm/data/main_800D9AFC.bin.o(.data); }
    .main_800DC824 0x800DC824 : AT(0x000DD424) { FILL(0x00000000); build/asm/main_800DC824.s.o(.text); build/asm/main_800DC824.s.o(.rodata); build/asm/main_800DC824.s.o(.data); }
    .main_800DC824_bss (NOLOAD) : { build/asm/main_800DC824.s.o(.bss); }
    .main_800DC83C 0x800DC83C : AT(0x000DD43C) { build/asm/data/main_800DC83C.bin.o(.data); }
    .main_800DD1E0 0x800DD1E0 : AT(0x000DDDE0) { FILL(0x00000000); build/asm/main_800DD1E0.s.o(.text); build/asm/main_800DD1E0.s.o(.rodata); build/asm/main_800DD1E0.s.o(.data); }
    .main_800DD1E0_bss (NOLOAD) : { build/asm/main_800DD1E0.s.o(.bss); }
    .main_800DD47C 0x800DD47C : AT(0x000DE07C) { build/asm/data/main_800DD47C.bin.o(.data); }
    .main_800DE3FC 0x800DE3FC : AT(0x000DEFFC) { FILL(0x00000000); build/asm/main_800DE3FC.s.o(.text); build/asm/main_800DE3FC.s.o(.rodata); build/asm/main_800DE3FC.s.o(.data); }
    .main_800DE3FC_bss (NOLOAD) : { build/asm/main_800DE3FC.s.o(.bss); }
    .main_800DEA4C 0x800DEA4C : AT(0x000DF64C) { build/asm/data/main_800DEA4C.bin.o(.data); }
    .main_800E188C 0x800E188C : AT(0x000E248C) { FILL(0x00000000); build/asm/main_800E188C.s.o(.text); build/asm/main_800E188C.s.o(.rodata); build/asm/main_800E188C.s.o(.data); }
    .main_800E188C_bss (NOLOAD) : { build/asm/main_800E188C.s.o(.bss); }
    .main_800E1954 0x800E1954 : AT(0x000E2554) { build/asm/data/main_800E1954.bin.o(.data); }
    .main_800E3044 0x800E3044 : AT(0x000E3C44) { FILL(0x00000000); build/asm/main_800E3044.s.o(.text); build/asm/main_800E3044.s.o(.rodata); build/asm/main_800E3044.s.o(.data); }
    .main_800E3044_bss (NOLOAD) : { build/asm/main_800E3044.s.o(.bss); }
    .main_800E3090 0x800E3090 : AT(0x000E3C90) { build/asm/data/main_800E3090.bin.o(.data); }
    .main_800E36D0 0x800E36D0 : AT(0x000E42D0) { FILL(0x00000000); build/asm/main_800E36D0.s.o(.text); build/asm/main_800E36D0.s.o(.rodata); build/asm/main_800E36D0.s.o(.data); }
    .main_800E36D0_bss (NOLOAD) : { build/asm/main_800E36D0.s.o(.bss); }
    .main_800E36E8 0x800E36E8 : AT(0x000E42E8) { build/asm/data/main_800E36E8.bin.o(.data); }
    .main_800E3B1C 0x800E3B1C : AT(0x000E471C) { FILL(0x00000000); build/asm/main_800E3B1C.s.o(.text); build/asm/main_800E3B1C.s.o(.rodata); build/asm/main_800E3B1C.s.o(.data); }
    .main_800E3B1C_bss (NOLOAD) : { build/asm/main_800E3B1C.s.o(.bss); }
    .main_800E3B80 0x800E3B80 : AT(0x000E4780) { build/asm/data/main_800E3B80.bin.o(.data); }
    .main_800E3EE4 0x800E3EE4 : AT(0x000E4AE4) { FILL(0x00000000); build/asm/main_800E3EE4.s.o(.text); build/asm/main_800E3EE4.s.o(.rodata); build/asm/main_800E3EE4.s.o(.data); }
    .main_800E3EE4_bss (NOLOAD) : { build/asm/main_800E3EE4.s.o(.bss); }
    .main_800E3EEC 0x800E3EEC : AT(0x000E4AEC) { build/asm/data/main_800E3EEC.bin.o(.data); }
    .main_800E40AC 0x800E40AC : AT(0x000E4CAC) { FILL(0x00000000); build/asm/main_800E40AC.s.o(.text); build/asm/main_800E40AC.s.o(.rodata); build/asm/main_800E40AC.s.o(.data); }
    .main_800E40AC_bss (NOLOAD) : { build/asm/main_800E40AC.s.o(.bss); }
    .main_800E40C4 0x800E40C4 : AT(0x000E4CC4) { build/asm/data/main_800E40C4.bin.o(.data); }
    .main_800E4CF4 0x800E4CF4 : AT(0x000E58F4) { FILL(0x00000000); build/asm/main_800E4CF4.s.o(.text); build/asm/main_800E4CF4.s.o(.rodata); build/asm/main_800E4CF4.s.o(.data); }
    .main_800E4CF4_bss (NOLOAD) : { build/asm/main_800E4CF4.s.o(.bss); }
    .main_800E4D14 0x800E4D14 : AT(0x000E5914) { build/asm/data/main_800E4D14.bin.o(.data); }
    .main_800E51BC 0x800E51BC : AT(0x000E5DBC) { FILL(0x00000000); build/asm/main_800E51BC.s.o(.text); build/asm/main_800E51BC.s.o(.rodata); build/asm/main_800E51BC.s.o(.data); }
    .main_800E51BC_bss (NOLOAD) : { build/asm/main_800E51BC.s.o(.bss); }
    .main_800E5210 0x800E5210 : AT(0x000E5E10) { build/asm/data/main_800E5210.bin.o(.data); }
    .main_800E5BB8 0x800E5BB8 : AT(0x000E67B8) { FILL(0x00000000); build/asm/main_800E5BB8.s.o(.text); build/asm/main_800E5BB8.s.o(.rodata); build/asm/main_800E5BB8.s.o(.data); }
    .main_800E5BB8_bss (NOLOAD) : { build/asm/main_800E5BB8.s.o(.bss); }
    .main_800E5C2C 0x800E5C2C : AT(0x000E682C) { build/asm/data/main_800E5C2C.bin.o(.data); }
    .main_800E66D0 0x800E66D0 : AT(0x000E72D0) { FILL(0x00000000); build/asm/main_800E66D0.s.o(.text); build/asm/main_800E66D0.s.o(.rodata); build/asm/main_800E66D0.s.o(.data); }
    .main_800E66D0_bss (NOLOAD) : { build/asm/main_800E66D0.s.o(.bss); }
    .main_800E6704 0x800E6704 : AT(0x000E7304) { build/asm/data/main_800E6704.bin.o(.data); }
    .main_800E7FCC 0x800E7FCC : AT(0x000E8BCC) { FILL(0x00000000); build/asm/main_800E7FCC.s.o(.text); build/asm/main_800E7FCC.s.o(.rodata); build/asm/main_800E7FCC.s.o(.data); }
    .main_800E7FCC_bss (NOLOAD) : { build/asm/main_800E7FCC.s.o(.bss); }
    .main_800E7FFC 0x800E7FFC : AT(0x000E8BFC) { build/asm/data/main_800E7FFC.bin.o(.data); }
    .main_800E8040 0x800E8040 : AT(0x000E8C40) { FILL(0x00000000); build/asm/main_800E8040.s.o(.text); build/asm/main_800E8040.s.o(.rodata); build/asm/main_800E8040.s.o(.data); }
    .main_800E8040_bss (NOLOAD) : { build/asm/main_800E8040.s.o(.bss); }
    .main_800E8104 0x800E8104 : AT(0x000E8D04) { build/asm/data/main_800E8104.bin.o(.data); }
    .main_800E84E8 0x800E84E8 : AT(0x000E90E8) { FILL(0x00000000); build/asm/main_800E84E8.s.o(.text); build/asm/main_800E84E8.s.o(.rodata); build/asm/main_800E84E8.s.o(.data); }
    .main_800E84E8_bss (NOLOAD) : { build/asm/main_800E84E8.s.o(.bss); }
    .main_800E8534 0x800E8534 : AT(0x000E9134) { build/asm/data/main_800E8534.bin.o(.data); }
    .main_800E859C 0x800E859C : AT(0x000E919C) { FILL(0x00000000); build/asm/main_800E859C.s.o(.text); build/asm/main_800E859C.s.o(.rodata); build/asm/main_800E859C.s.o(.data); }
    .main_800E859C_bss (NOLOAD) : { build/asm/main_800E859C.s.o(.bss); }
    .main_800E8628 0x800E8628 : AT(0x000E9228) { build/asm/data/main_800E8628.bin.o(.data); }
    .main_800E897C 0x800E897C : AT(0x000E957C) { FILL(0x00000000); build/asm/main_800E897C.s.o(.text); build/asm/main_800E897C.s.o(.rodata); build/asm/main_800E897C.s.o(.data); }
    .main_800E897C_bss (NOLOAD) : { build/asm/main_800E897C.s.o(.bss); }
    .main_800E8A7C 0x800E8A7C : AT(0x000E967C) { build/asm/data/main_800E8A7C.bin.o(.data); }
    .main_800ED3AC 0x800ED3AC : AT(0x000EDFAC) { FILL(0x00000000); build/asm/main_800ED3AC.s.o(.text); build/asm/main_800ED3AC.s.o(.rodata); build/asm/main_800ED3AC.s.o(.data); }
    .main_800ED3AC_bss (NOLOAD) : { build/asm/main_800ED3AC.s.o(.bss); }
    .main_800ED3BC 0x800ED3BC : AT(0x000EDFBC) { build/asm/data/main_800ED3BC.bin.o(.data); }
    .main_800EECF8 0x800EECF8 : AT(0x000EF8F8) { FILL(0x00000000); build/asm/main_800EECF8.s.o(.text); build/asm/main_800EECF8.s.o(.rodata); build/asm/main_800EECF8.s.o(.data); }
    .main_800EECF8_bss (NOLOAD) : { build/asm/main_800EECF8.s.o(.bss); }
    .main_800EED3C 0x800EED3C : AT(0x000EF93C) { build/asm/data/main_800EED3C.bin.o(.data); }
    .main_800EFE10 0x800EFE10 : AT(0x000F0A10) { FILL(0x00000000); build/asm/main_800EFE10.s.o(.text); build/asm/main_800EFE10.s.o(.rodata); build/asm/main_800EFE10.s.o(.data); }
    .main_800EFE10_bss (NOLOAD) : { build/asm/main_800EFE10.s.o(.bss); }
    .main_800EFE20 0x800EFE20 : AT(0x000F0A20) { build/asm/data/main_800EFE20.bin.o(.data); }
    .main_800F152C 0x800F152C : AT(0x000F212C) { FILL(0x00000000); build/asm/main_800F152C.s.o(.text); build/asm/main_800F152C.s.o(.rodata); build/asm/main_800F152C.s.o(.data); }
    .main_800F152C_bss (NOLOAD) : { build/asm/main_800F152C.s.o(.bss); }
    .main_800F1538 0x800F1538 : AT(0x000F2138) { build/asm/data/main_800F1538.bin.o(.data); }
    .main_800F16F8 0x800F16F8 : AT(0x000F22F8) { FILL(0x00000000); build/asm/main_800F16F8.s.o(.text); build/asm/main_800F16F8.s.o(.rodata); build/asm/main_800F16F8.s.o(.data); }
    .main_800F16F8_bss (NOLOAD) : { build/asm/main_800F16F8.s.o(.bss); }
    .main_800F1724 0x800F1724 : AT(0x000F2324) { build/asm/data/main_800F1724.bin.o(.data); }
    .main_800F4088 0x800F4088 : AT(0x000F4C88) { FILL(0x00000000); build/asm/main_800F4088.s.o(.text); build/asm/main_800F4088.s.o(.rodata); build/asm/main_800F4088.s.o(.data); }
    .main_800F4088_bss (NOLOAD) : { build/asm/main_800F4088.s.o(.bss); }
    .main_800F41F8 0x800F41F8 : AT(0x000F4DF8) { build/asm/data/main_800F41F8.bin.o(.data); }
    .main_800F5814 0x800F5814 : AT(0x000F6414) { FILL(0x00000000); build/asm/main_800F5814.s.o(.text); build/asm/main_800F5814.s.o(.rodata); build/asm/main_800F5814.s.o(.data); }
    .main_800F5814_bss (NOLOAD) : { build/asm/main_800F5814.s.o(.bss); }
    .main_800F58D0 0x800F58D0 : AT(0x000F64D0) { build/asm/data/main_800F58D0.bin.o(.data); }
    .main_800F5C80 0x800F5C80 : AT(0x000F6880) { FILL(0x00000000); build/asm/main_800F5C80.s.o(.text); build/asm/main_800F5C80.s.o(.rodata); build/asm/main_800F5C80.s.o(.data); }
    .main_800F5C80_bss (NOLOAD) : { build/asm/main_800F5C80.s.o(.bss); }
    .main_800F5D44 0x800F5D44 : AT(0x000F6944) { build/asm/data/main_800F5D44.bin.o(.data); }
    .main_800F618C 0x800F618C : AT(0x000F6D8C) { FILL(0x00000000); build/asm/main_800F618C.s.o(.text); build/asm/main_800F618C.s.o(.rodata); build/asm/main_800F618C.s.o(.data); }
    .main_800F618C_bss (NOLOAD) : { build/asm/main_800F618C.s.o(.bss); }
    .main_800F64B0 0x800F64B0 : AT(0x000F70B0) { build/asm/data/main_800F64B0.bin.o(.data); }
    .main_800F7F58 0x800F7F58 : AT(0x000F8B58) { FILL(0x00000000); build/asm/main_800F7F58.s.o(.text); build/asm/main_800F7F58.s.o(.rodata); build/asm/main_800F7F58.s.o(.data); }
    .main_800F7F58_bss (NOLOAD) : { build/asm/main_800F7F58.s.o(.bss); }
    .main_800F80F4 0x800F80F4 : AT(0x000F8CF4) { build/asm/data/main_800F80F4.bin.o(.data); }
    .main_800F9944 0x800F9944 : AT(0x000FA544) { FILL(0x00000000); build/asm/main_800F9944.s.o(.text); build/asm/main_800F9944.s.o(.rodata); build/asm/main_800F9944.s.o(.data); }
    .main_800F9944_bss (NOLOAD) : { build/asm/main_800F9944.s.o(.bss); }
    .main_800F99EC 0x800F99EC : AT(0x000FA5EC) { build/asm/data/main_800F99EC.bin.o(.data); }
    .main_800F9B58 0x800F9B58 : AT(0x000FA758) { FILL(0x00000000); build/asm/main_800F9B58.s.o(.text); build/asm/main_800F9B58.s.o(.rodata); build/asm/main_800F9B58.s.o(.data); }
    .main_800F9B58_bss (NOLOAD) : { build/asm/main_800F9B58.s.o(.bss); }
    .main_800F9BA4 0x800F9BA4 : AT(0x000FA7A4) { build/asm/data/main_800F9BA4.bin.o(.data); }
    .main_800FA1FC 0x800FA1FC : AT(0x000FADFC) { FILL(0x00000000); build/asm/main_800FA1FC.s.o(.text); build/asm/main_800FA1FC.s.o(.rodata); build/asm/main_800FA1FC.s.o(.data); }
    .main_800FA1FC_bss (NOLOAD) : { build/asm/main_800FA1FC.s.o(.bss); }
    .main_800FA420 0x800FA420 : AT(0x000FB020) { build/asm/data/main_800FA420.bin.o(.data); }
    .main_800FB46C 0x800FB46C : AT(0x000FC06C) { FILL(0x00000000); build/asm/main_800FB46C.s.o(.text); build/asm/main_800FB46C.s.o(.rodata); build/asm/main_800FB46C.s.o(.data); }
    .main_800FB46C_bss (NOLOAD) : { build/asm/main_800FB46C.s.o(.bss); }
    .main_800FB4E8 0x800FB4E8 : AT(0x000FC0E8) { build/asm/data/main_800FB4E8.bin.o(.data); }
    .main_800FD734 0x800FD734 : AT(0x000FE334) { FILL(0x00000000); build/asm/main_800FD734.s.o(.text); build/asm/main_800FD734.s.o(.rodata); build/asm/main_800FD734.s.o(.data); }
    .main_800FD734_bss (NOLOAD) : { build/asm/main_800FD734.s.o(.bss); }
    .main_800FD834 0x800FD834 : AT(0x000FE434) { build/asm/data/main_800FD834.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
