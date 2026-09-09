SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000524 0x80000524 : AT(0x00001124) { build/asm/data/main_80000524.bin.o(.data); }
    .main_800017BC 0x800017BC : AT(0x000023BC) { FILL(0x00000000); build/asm/main_800017BC.s.o(.text); build/asm/main_800017BC.s.o(.rodata); build/asm/main_800017BC.s.o(.data); }
    .main_800017BC_bss (NOLOAD) : { build/asm/main_800017BC.s.o(.bss); }
    .main_80001800 0x80001800 : AT(0x00002400) { build/asm/data/main_80001800.bin.o(.data); }
    .main_80001C00 0x80001C00 : AT(0x00002800) { FILL(0x00000000); build/asm/main_80001C00.s.o(.text); build/asm/main_80001C00.s.o(.rodata); build/asm/main_80001C00.s.o(.data); }
    .main_80001C00_bss (NOLOAD) : { build/asm/main_80001C00.s.o(.bss); }
    .main_80002024 0x80002024 : AT(0x00002C24) { build/asm/data/main_80002024.bin.o(.data); }
    .main_800039A0 0x800039A0 : AT(0x000045A0) { FILL(0x00000000); build/asm/main_800039A0.s.o(.text); build/asm/main_800039A0.s.o(.rodata); build/asm/main_800039A0.s.o(.data); }
    .main_800039A0_bss (NOLOAD) : { build/asm/main_800039A0.s.o(.bss); }
    .main_800156C4 0x800156C4 : AT(0x000162C4) { build/asm/data/main_800156C4.bin.o(.data); }
    .main_80015980 0x80015980 : AT(0x00016580) { FILL(0x00000000); build/asm/main_80015980.s.o(.text); build/asm/main_80015980.s.o(.rodata); build/asm/main_80015980.s.o(.data); }
    .main_80015980_bss (NOLOAD) : { build/asm/main_80015980.s.o(.bss); }
    .main_800298C4 0x800298C4 : AT(0x0002A4C4) { build/asm/data/main_800298C4.bin.o(.data); }
    .main_800298E0 0x800298E0 : AT(0x0002A4E0) { FILL(0x00000000); build/asm/main_800298E0.s.o(.text); build/asm/main_800298E0.s.o(.rodata); build/asm/main_800298E0.s.o(.data); }
    .main_800298E0_bss (NOLOAD) : { build/asm/main_800298E0.s.o(.bss); }
    .main_80076428 0x80076428 : AT(0x00077028) { build/asm/data/main_80076428.bin.o(.data); }
    .main_80076560 0x80076560 : AT(0x00077160) { FILL(0x00000000); build/asm/main_80076560.s.o(.text); build/asm/main_80076560.s.o(.rodata); build/asm/main_80076560.s.o(.data); }
    .main_80076560_bss (NOLOAD) : { build/asm/main_80076560.s.o(.bss); }
    .main_8007CDDC 0x8007CDDC : AT(0x0007D9DC) { FILL(0x00000000); build/asm/main_8007CDDC.s.o(.text); build/asm/main_8007CDDC.s.o(.rodata); build/asm/main_8007CDDC.s.o(.data); }
    .main_8007CDDC_bss (NOLOAD) : { build/asm/main_8007CDDC.s.o(.bss); }
    .main_8007E0B8 0x8007E0B8 : AT(0x0007ECB8) { build/assets/main_8007E0B8.bin.o(.data); }
    .main_8007F160 0x8007F160 : AT(0x0007FD60) { FILL(0x00000000); build/asm/main_8007F160.s.o(.text); build/asm/main_8007F160.s.o(.rodata); build/asm/main_8007F160.s.o(.data); }
    .main_8007F160_bss (NOLOAD) : { build/asm/main_8007F160.s.o(.bss); }
    .main_80080280 0x80080280 : AT(0x00080E80) { FILL(0x00000000); build/asm/main_80080280.s.o(.text); build/asm/main_80080280.s.o(.rodata); build/asm/main_80080280.s.o(.data); }
    .main_80080280_bss (NOLOAD) : { build/asm/main_80080280.s.o(.bss); }
    .main_80081240 0x80081240 : AT(0x00081E40) { FILL(0x00000000); build/asm/main_80081240.s.o(.text); build/asm/main_80081240.s.o(.rodata); build/asm/main_80081240.s.o(.data); }
    .main_80081240_bss (NOLOAD) : { build/asm/main_80081240.s.o(.bss); }
    .main_800816E0 0x800816E0 : AT(0x000822E0) { FILL(0x00000000); build/asm/main_800816E0.s.o(.text); build/asm/main_800816E0.s.o(.rodata); build/asm/main_800816E0.s.o(.data); }
    .main_800816E0_bss (NOLOAD) : { build/asm/main_800816E0.s.o(.bss); }
    .main_80081780 0x80081780 : AT(0x00082380) { FILL(0x00000000); build/asm/main_80081780.s.o(.text); build/asm/main_80081780.s.o(.rodata); build/asm/main_80081780.s.o(.data); }
    .main_80081780_bss (NOLOAD) : { build/asm/main_80081780.s.o(.bss); }
    .main_80087C20 0x80087C20 : AT(0x00088820) { FILL(0x00000000); build/asm/main_80087C20.s.o(.text); build/asm/main_80087C20.s.o(.rodata); build/asm/main_80087C20.s.o(.data); }
    .main_80087C20_bss (NOLOAD) : { build/asm/main_80087C20.s.o(.bss); }
    .main_80093B70 0x80093B70 : AT(0x00094770) { build/asm/data/main_80093B70.bin.o(.data); }
    .main_8009648C 0x8009648C : AT(0x0009708C) { FILL(0x00000000); build/asm/main_8009648C.s.o(.text); build/asm/main_8009648C.s.o(.rodata); build/asm/main_8009648C.s.o(.data); }
    .main_8009648C_bss (NOLOAD) : { build/asm/main_8009648C.s.o(.bss); }
    .main_8009724C 0x8009724C : AT(0x00097E4C) { build/asm/data/main_8009724C.bin.o(.data); }
    .main_8009A800 0x8009A800 : AT(0x0009B400) { FILL(0x00000000); build/asm/main_8009A800.s.o(.text); build/asm/main_8009A800.s.o(.rodata); build/asm/main_8009A800.s.o(.data); }
    .main_8009A800_bss (NOLOAD) : { build/asm/main_8009A800.s.o(.bss); }
    .main_8009AD5C 0x8009AD5C : AT(0x0009B95C) { build/asm/data/main_8009AD5C.bin.o(.data); }
    .main_8009BFAC 0x8009BFAC : AT(0x0009CBAC) { FILL(0x00000000); build/asm/main_8009BFAC.s.o(.text); build/asm/main_8009BFAC.s.o(.rodata); build/asm/main_8009BFAC.s.o(.data); }
    .main_8009BFAC_bss (NOLOAD) : { build/asm/main_8009BFAC.s.o(.bss); }
    .main_8009F67C 0x8009F67C : AT(0x000A027C) { build/asm/data/main_8009F67C.bin.o(.data); }
    .main_800A3D48 0x800A3D48 : AT(0x000A4948) { FILL(0x00000000); build/asm/main_800A3D48.s.o(.text); build/asm/main_800A3D48.s.o(.rodata); build/asm/main_800A3D48.s.o(.data); }
    .main_800A3D48_bss (NOLOAD) : { build/asm/main_800A3D48.s.o(.bss); }
    .main_800A4090 0x800A4090 : AT(0x000A4C90) { build/asm/data/main_800A4090.bin.o(.data); }
    .main_800A4768 0x800A4768 : AT(0x000A5368) { FILL(0x00000000); build/asm/main_800A4768.s.o(.text); build/asm/main_800A4768.s.o(.rodata); build/asm/main_800A4768.s.o(.data); }
    .main_800A4768_bss (NOLOAD) : { build/asm/main_800A4768.s.o(.bss); }
    .main_800A4BAC 0x800A4BAC : AT(0x000A57AC) { build/asm/data/main_800A4BAC.bin.o(.data); }
    .main_800B7000 0x800B7000 : AT(0x000B7C00) { FILL(0x00000000); build/asm/main_800B7000.s.o(.text); build/asm/main_800B7000.s.o(.rodata); build/asm/main_800B7000.s.o(.data); }
    .main_800B7000_bss (NOLOAD) : { build/asm/main_800B7000.s.o(.bss); }
    .main_800B701C 0x800B701C : AT(0x000B7C1C) { build/asm/data/main_800B701C.bin.o(.data); }
    .main_800BC358 0x800BC358 : AT(0x000BCF58) { FILL(0x00000000); build/asm/main_800BC358.s.o(.text); build/asm/main_800BC358.s.o(.rodata); build/asm/main_800BC358.s.o(.data); }
    .main_800BC358_bss (NOLOAD) : { build/asm/main_800BC358.s.o(.bss); }
    .main_800BC848 0x800BC848 : AT(0x000BD448) { build/asm/data/main_800BC848.bin.o(.data); }
    .main_800BD728 0x800BD728 : AT(0x000BE328) { FILL(0x00000000); build/asm/main_800BD728.s.o(.text); build/asm/main_800BD728.s.o(.rodata); build/asm/main_800BD728.s.o(.data); }
    .main_800BD728_bss (NOLOAD) : { build/asm/main_800BD728.s.o(.bss); }
    .main_800BD738 0x800BD738 : AT(0x000BE338) { build/asm/data/main_800BD738.bin.o(.data); }
    .main_800C0E0C 0x800C0E0C : AT(0x000C1A0C) { FILL(0x00000000); build/asm/main_800C0E0C.s.o(.text); build/asm/main_800C0E0C.s.o(.rodata); build/asm/main_800C0E0C.s.o(.data); }
    .main_800C0E0C_bss (NOLOAD) : { build/asm/main_800C0E0C.s.o(.bss); }
    .main_800C0FB0 0x800C0FB0 : AT(0x000C1BB0) { build/asm/data/main_800C0FB0.bin.o(.data); }
    .main_800C14B8 0x800C14B8 : AT(0x000C20B8) { FILL(0x00000000); build/asm/main_800C14B8.s.o(.text); build/asm/main_800C14B8.s.o(.rodata); build/asm/main_800C14B8.s.o(.data); }
    .main_800C14B8_bss (NOLOAD) : { build/asm/main_800C14B8.s.o(.bss); }
    .main_800C14E8 0x800C14E8 : AT(0x000C20E8) { build/asm/data/main_800C14E8.bin.o(.data); }
    .main_800CA0F0 0x800CA0F0 : AT(0x000CACF0) { FILL(0x00000000); build/asm/main_800CA0F0.s.o(.text); build/asm/main_800CA0F0.s.o(.rodata); build/asm/main_800CA0F0.s.o(.data); }
    .main_800CA0F0_bss (NOLOAD) : { build/asm/main_800CA0F0.s.o(.bss); }
    .main_800CA2B4 0x800CA2B4 : AT(0x000CAEB4) { build/asm/data/main_800CA2B4.bin.o(.data); }
    .main_800CB198 0x800CB198 : AT(0x000CBD98) { FILL(0x00000000); build/asm/main_800CB198.s.o(.text); build/asm/main_800CB198.s.o(.rodata); build/asm/main_800CB198.s.o(.data); }
    .main_800CB198_bss (NOLOAD) : { build/asm/main_800CB198.s.o(.bss); }
    .main_800CB1D4 0x800CB1D4 : AT(0x000CBDD4) { build/asm/data/main_800CB1D4.bin.o(.data); }
    .main_800CCF64 0x800CCF64 : AT(0x000CDB64) { FILL(0x00000000); build/asm/main_800CCF64.s.o(.text); build/asm/main_800CCF64.s.o(.rodata); build/asm/main_800CCF64.s.o(.data); }
    .main_800CCF64_bss (NOLOAD) : { build/asm/main_800CCF64.s.o(.bss); }
    .main_800CD1F0 0x800CD1F0 : AT(0x000CDDF0) { build/asm/data/main_800CD1F0.bin.o(.data); }
    .main_800CFAC4 0x800CFAC4 : AT(0x000D06C4) { FILL(0x00000000); build/asm/main_800CFAC4.s.o(.text); build/asm/main_800CFAC4.s.o(.rodata); build/asm/main_800CFAC4.s.o(.data); }
    .main_800CFAC4_bss (NOLOAD) : { build/asm/main_800CFAC4.s.o(.bss); }
    .main_800D1638 0x800D1638 : AT(0x000D2238) { build/asm/data/main_800D1638.bin.o(.data); }
    .main_800DA6EC 0x800DA6EC : AT(0x000DB2EC) { FILL(0x00000000); build/asm/main_800DA6EC.s.o(.text); build/asm/main_800DA6EC.s.o(.rodata); build/asm/main_800DA6EC.s.o(.data); }
    .main_800DA6EC_bss (NOLOAD) : { build/asm/main_800DA6EC.s.o(.bss); }
    .main_800DA714 0x800DA714 : AT(0x000DB314) { build/asm/data/main_800DA714.bin.o(.data); }
    .main_800DE83C 0x800DE83C : AT(0x000DF43C) { FILL(0x00000000); build/asm/main_800DE83C.s.o(.text); build/asm/main_800DE83C.s.o(.rodata); build/asm/main_800DE83C.s.o(.data); }
    .main_800DE83C_bss (NOLOAD) : { build/asm/main_800DE83C.s.o(.bss); }
    .main_800DE88C 0x800DE88C : AT(0x000DF48C) { build/asm/data/main_800DE88C.bin.o(.data); }
    .main_800E08EC 0x800E08EC : AT(0x000E14EC) { FILL(0x00000000); build/asm/main_800E08EC.s.o(.text); build/asm/main_800E08EC.s.o(.rodata); build/asm/main_800E08EC.s.o(.data); }
    .main_800E08EC_bss (NOLOAD) : { build/asm/main_800E08EC.s.o(.bss); }
    .main_800E08F0 0x800E08F0 : AT(0x000E14F0) { build/asm/data/main_800E08F0.bin.o(.data); }
    .main_800E18E4 0x800E18E4 : AT(0x000E24E4) { FILL(0x00000000); build/asm/main_800E18E4.s.o(.text); build/asm/main_800E18E4.s.o(.rodata); build/asm/main_800E18E4.s.o(.data); }
    .main_800E18E4_bss (NOLOAD) : { build/asm/main_800E18E4.s.o(.bss); }
    .main_800E193C 0x800E193C : AT(0x000E253C) { build/asm/data/main_800E193C.bin.o(.data); }
    .main_800E5A88 0x800E5A88 : AT(0x000E6688) { FILL(0x00000000); build/asm/main_800E5A88.s.o(.text); build/asm/main_800E5A88.s.o(.rodata); build/asm/main_800E5A88.s.o(.data); }
    .main_800E5A88_bss (NOLOAD) : { build/asm/main_800E5A88.s.o(.bss); }
    .main_800E5B80 0x800E5B80 : AT(0x000E6780) { build/asm/data/main_800E5B80.bin.o(.data); }
    .main_800E7A1C 0x800E7A1C : AT(0x000E861C) { FILL(0x00000000); build/asm/main_800E7A1C.s.o(.text); build/asm/main_800E7A1C.s.o(.rodata); build/asm/main_800E7A1C.s.o(.data); }
    .main_800E7A1C_bss (NOLOAD) : { build/asm/main_800E7A1C.s.o(.bss); }
    .main_800E7A2C 0x800E7A2C : AT(0x000E862C) { build/asm/data/main_800E7A2C.bin.o(.data); }
    .main_800F3040 0x800F3040 : AT(0x000F3C40) { FILL(0x00000000); build/asm/main_800F3040.s.o(.text); build/asm/main_800F3040.s.o(.rodata); build/asm/main_800F3040.s.o(.data); }
    .main_800F3040_bss (NOLOAD) : { build/asm/main_800F3040.s.o(.bss); }
    .main_800F3050 0x800F3050 : AT(0x000F3C50) { build/asm/data/main_800F3050.bin.o(.data); }
    .main_800F3F60 0x800F3F60 : AT(0x000F4B60) { FILL(0x00000000); build/asm/main_800F3F60.s.o(.text); build/asm/main_800F3F60.s.o(.rodata); build/asm/main_800F3F60.s.o(.data); }
    .main_800F3F60_bss (NOLOAD) : { build/asm/main_800F3F60.s.o(.bss); }
    .main_800F40E8 0x800F40E8 : AT(0x000F4CE8) { build/asm/data/main_800F40E8.bin.o(.data); }
    .main_800F925C 0x800F925C : AT(0x000F9E5C) { FILL(0x00000000); build/asm/main_800F925C.s.o(.text); build/asm/main_800F925C.s.o(.rodata); build/asm/main_800F925C.s.o(.data); }
    .main_800F925C_bss (NOLOAD) : { build/asm/main_800F925C.s.o(.bss); }
    .main_800F92E8 0x800F92E8 : AT(0x000F9EE8) { build/asm/data/main_800F92E8.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
