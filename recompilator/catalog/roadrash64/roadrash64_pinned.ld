SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000500 0x80000500 : AT(0x00001100) { FILL(0x00000000); build/asm/main_80000500.s.o(.text); build/asm/main_80000500.s.o(.rodata); build/asm/main_80000500.s.o(.data); }
    .main_80000500_bss (NOLOAD) : { build/asm/main_80000500.s.o(.bss); }
    .main_80000580 0x80000580 : AT(0x00001180) { FILL(0x00000000); build/asm/main_80000580.s.o(.text); build/asm/main_80000580.s.o(.rodata); build/asm/main_80000580.s.o(.data); }
    .main_80000580_bss (NOLOAD) : { build/asm/main_80000580.s.o(.bss); }
    .main_80000880 0x80000880 : AT(0x00001480) { FILL(0x00000000); build/asm/main_80000880.s.o(.text); build/asm/main_80000880.s.o(.rodata); build/asm/main_80000880.s.o(.data); }
    .main_80000880_bss (NOLOAD) : { build/asm/main_80000880.s.o(.bss); }
    .main_80000900 0x80000900 : AT(0x00001500) { build/asm/data/main_80000900.bin.o(.data); }
    .main_80000C80 0x80000C80 : AT(0x00001880) { FILL(0x00000000); build/asm/main_80000C80.s.o(.text); build/asm/main_80000C80.s.o(.rodata); build/asm/main_80000C80.s.o(.data); }
    .main_80000C80_bss (NOLOAD) : { build/asm/main_80000C80.s.o(.bss); }
    .main_80000D00 0x80000D00 : AT(0x00001900) { FILL(0x00000000); build/asm/main_80000D00.s.o(.text); build/asm/main_80000D00.s.o(.rodata); build/asm/main_80000D00.s.o(.data); }
    .main_80000D00_bss (NOLOAD) : { build/asm/main_80000D00.s.o(.bss); }
    .main_80001088 0x80001088 : AT(0x00001C88) { FILL(0x00000000); build/asm/main_80001088.s.o(.text); build/asm/main_80001088.s.o(.rodata); build/asm/main_80001088.s.o(.data); }
    .main_80001088_bss (NOLOAD) : { build/asm/main_80001088.s.o(.bss); }
    .main_80001100 0x80001100 : AT(0x00001D00) { FILL(0x00000000); build/asm/main_80001100.s.o(.text); build/asm/main_80001100.s.o(.rodata); build/asm/main_80001100.s.o(.data); }
    .main_80001100_bss (NOLOAD) : { build/asm/main_80001100.s.o(.bss); }
    .main_80001180 0x80001180 : AT(0x00001D80) { FILL(0x00000000); build/asm/main_80001180.s.o(.text); build/asm/main_80001180.s.o(.rodata); build/asm/main_80001180.s.o(.data); }
    .main_80001180_bss (NOLOAD) : { build/asm/main_80001180.s.o(.bss); }
    .main_8000121C 0x8000121C : AT(0x00001E1C) { FILL(0x00000000); build/asm/main_8000121C.s.o(.text); build/asm/main_8000121C.s.o(.rodata); build/asm/main_8000121C.s.o(.data); }
    .main_8000121C_bss (NOLOAD) : { build/asm/main_8000121C.s.o(.bss); }
    .main_80001580 0x80001580 : AT(0x00002180) { build/asm/data/main_80001580.bin.o(.data); }
    .main_8000175C 0x8000175C : AT(0x0000235C) { FILL(0x00000000); build/asm/main_8000175C.s.o(.text); build/asm/main_8000175C.s.o(.rodata); build/asm/main_8000175C.s.o(.data); }
    .main_8000175C_bss (NOLOAD) : { build/asm/main_8000175C.s.o(.bss); }
    .main_800017B4 0x800017B4 : AT(0x000023B4) { FILL(0x00000000); build/asm/main_800017B4.s.o(.text); build/asm/main_800017B4.s.o(.rodata); build/asm/main_800017B4.s.o(.data); }
    .main_800017B4_bss (NOLOAD) : { build/asm/main_800017B4.s.o(.bss); }
    .main_800017E4 0x800017E4 : AT(0x000023E4) { FILL(0x00000000); build/asm/main_800017E4.s.o(.text); build/asm/main_800017E4.s.o(.rodata); build/asm/main_800017E4.s.o(.data); }
    .main_800017E4_bss (NOLOAD) : { build/asm/main_800017E4.s.o(.bss); }
    .main_80001800 0x80001800 : AT(0x00002400) { build/asm/data/main_80001800.bin.o(.data); }
    .main_80001FB4 0x80001FB4 : AT(0x00002BB4) { FILL(0x00000000); build/asm/main_80001FB4.s.o(.text); build/asm/main_80001FB4.s.o(.rodata); build/asm/main_80001FB4.s.o(.data); }
    .main_80001FB4_bss (NOLOAD) : { build/asm/main_80001FB4.s.o(.bss); }
    .main_80008630 0x80008630 : AT(0x00009230) { FILL(0x00000000); build/asm/main_80008630.s.o(.text); build/asm/main_80008630.s.o(.rodata); build/asm/main_80008630.s.o(.data); }
    .main_80008630_bss (NOLOAD) : { build/asm/main_80008630.s.o(.bss); }
    .main_80008FE0 0x80008FE0 : AT(0x00009BE0) { FILL(0x00000000); build/asm/main_80008FE0.s.o(.text); build/asm/main_80008FE0.s.o(.rodata); build/asm/main_80008FE0.s.o(.data); }
    .main_80008FE0_bss (NOLOAD) : { build/asm/main_80008FE0.s.o(.bss); }
    .main_80009740 0x80009740 : AT(0x0000A340) { FILL(0x00000000); build/asm/main_80009740.s.o(.text); build/asm/main_80009740.s.o(.rodata); build/asm/main_80009740.s.o(.data); }
    .main_80009740_bss (NOLOAD) : { build/asm/main_80009740.s.o(.bss); }
    .main_80009B8C 0x80009B8C : AT(0x0000A78C) { FILL(0x00000000); build/asm/main_80009B8C.s.o(.text); build/asm/main_80009B8C.s.o(.rodata); build/asm/main_80009B8C.s.o(.data); }
    .main_80009B8C_bss (NOLOAD) : { build/asm/main_80009B8C.s.o(.bss); }
    .main_8000A4C8 0x8000A4C8 : AT(0x0000B0C8) { FILL(0x00000000); build/asm/main_8000A4C8.s.o(.text); build/asm/main_8000A4C8.s.o(.rodata); build/asm/main_8000A4C8.s.o(.data); }
    .main_8000A4C8_bss (NOLOAD) : { build/asm/main_8000A4C8.s.o(.bss); }
    .main_8001C454 0x8001C454 : AT(0x0001D054) { FILL(0x00000000); build/asm/main_8001C454.s.o(.text); build/asm/main_8001C454.s.o(.rodata); build/asm/main_8001C454.s.o(.data); }
    .main_8001C454_bss (NOLOAD) : { build/asm/main_8001C454.s.o(.bss); }
    .main_8001C850 0x8001C850 : AT(0x0001D450) { FILL(0x00000000); build/asm/main_8001C850.s.o(.text); build/asm/main_8001C850.s.o(.rodata); build/asm/main_8001C850.s.o(.data); }
    .main_8001C850_bss (NOLOAD) : { build/asm/main_8001C850.s.o(.bss); }
    .main_800404BC 0x800404BC : AT(0x000410BC) { FILL(0x00000000); build/asm/main_800404BC.s.o(.text); build/asm/main_800404BC.s.o(.rodata); build/asm/main_800404BC.s.o(.data); }
    .main_800404BC_bss (NOLOAD) : { build/asm/main_800404BC.s.o(.bss); }
    .main_80040FC0 0x80040FC0 : AT(0x00041BC0) { FILL(0x00000000); build/asm/main_80040FC0.s.o(.text); build/asm/main_80040FC0.s.o(.rodata); build/asm/main_80040FC0.s.o(.data); }
    .main_80040FC0_bss (NOLOAD) : { build/asm/main_80040FC0.s.o(.bss); }
    .main_8004F174 0x8004F174 : AT(0x0004FD74) { FILL(0x00000000); build/asm/main_8004F174.s.o(.text); build/asm/main_8004F174.s.o(.rodata); build/asm/main_8004F174.s.o(.data); }
    .main_8004F174_bss (NOLOAD) : { build/asm/main_8004F174.s.o(.bss); }
    .main_800516B8 0x800516B8 : AT(0x000522B8) { FILL(0x00000000); build/asm/main_800516B8.s.o(.text); build/asm/main_800516B8.s.o(.rodata); build/asm/main_800516B8.s.o(.data); }
    .main_800516B8_bss (NOLOAD) : { build/asm/main_800516B8.s.o(.bss); }
    .main_80052668 0x80052668 : AT(0x00053268) { FILL(0x00000000); build/asm/main_80052668.s.o(.text); build/asm/main_80052668.s.o(.rodata); build/asm/main_80052668.s.o(.data); }
    .main_80052668_bss (NOLOAD) : { build/asm/main_80052668.s.o(.bss); }
    .main_8006C120 0x8006C120 : AT(0x0006CD20) { FILL(0x00000000); build/asm/main_8006C120.s.o(.text); build/asm/main_8006C120.s.o(.rodata); build/asm/main_8006C120.s.o(.data); }
    .main_8006C120_bss (NOLOAD) : { build/asm/main_8006C120.s.o(.bss); }
    .main_8007FB9C 0x8007FB9C : AT(0x0008079C) { FILL(0x00000000); build/asm/main_8007FB9C.s.o(.text); build/asm/main_8007FB9C.s.o(.rodata); build/asm/main_8007FB9C.s.o(.data); }
    .main_8007FB9C_bss (NOLOAD) : { build/asm/main_8007FB9C.s.o(.bss); }
    .main_800811FC 0x800811FC : AT(0x00081DFC) { FILL(0x00000000); build/asm/main_800811FC.s.o(.text); build/asm/main_800811FC.s.o(.rodata); build/asm/main_800811FC.s.o(.data); }
    .main_800811FC_bss (NOLOAD) : { build/asm/main_800811FC.s.o(.bss); }
    .main_800840FC 0x800840FC : AT(0x00084CFC) { FILL(0x00000000); build/asm/main_800840FC.s.o(.text); build/asm/main_800840FC.s.o(.rodata); build/asm/main_800840FC.s.o(.data); }
    .main_800840FC_bss (NOLOAD) : { build/asm/main_800840FC.s.o(.bss); }
    .main_80084700 0x80084700 : AT(0x00085300) { FILL(0x00000000); build/asm/main_80084700.s.o(.text); build/asm/main_80084700.s.o(.rodata); build/asm/main_80084700.s.o(.data); }
    .main_80084700_bss (NOLOAD) : { build/asm/main_80084700.s.o(.bss); }
    .main_80086700 0x80086700 : AT(0x00087300) { FILL(0x00000000); build/asm/main_80086700.s.o(.text); build/asm/main_80086700.s.o(.rodata); build/asm/main_80086700.s.o(.data); }
    .main_80086700_bss (NOLOAD) : { build/asm/main_80086700.s.o(.bss); }
    .main_800899BC 0x800899BC : AT(0x0008A5BC) { FILL(0x00000000); build/asm/main_800899BC.s.o(.text); build/asm/main_800899BC.s.o(.rodata); build/asm/main_800899BC.s.o(.data); }
    .main_800899BC_bss (NOLOAD) : { build/asm/main_800899BC.s.o(.bss); }
    .main_80089DA0 0x80089DA0 : AT(0x0008A9A0) { FILL(0x00000000); build/asm/main_80089DA0.s.o(.text); build/asm/main_80089DA0.s.o(.rodata); build/asm/main_80089DA0.s.o(.data); }
    .main_80089DA0_bss (NOLOAD) : { build/asm/main_80089DA0.s.o(.bss); }
    .main_8008C380 0x8008C380 : AT(0x0008CF80) { FILL(0x00000000); build/asm/main_8008C380.s.o(.text); build/asm/main_8008C380.s.o(.rodata); build/asm/main_8008C380.s.o(.data); }
    .main_8008C380_bss (NOLOAD) : { build/asm/main_8008C380.s.o(.bss); }
    .main_8008C78C 0x8008C78C : AT(0x0008D38C) { FILL(0x00000000); build/asm/main_8008C78C.s.o(.text); build/asm/main_8008C78C.s.o(.rodata); build/asm/main_8008C78C.s.o(.data); }
    .main_8008C78C_bss (NOLOAD) : { build/asm/main_8008C78C.s.o(.bss); }
    .main_8008CCC0 0x8008CCC0 : AT(0x0008D8C0) { FILL(0x00000000); build/asm/main_8008CCC0.s.o(.text); build/asm/main_8008CCC0.s.o(.rodata); build/asm/main_8008CCC0.s.o(.data); }
    .main_8008CCC0_bss (NOLOAD) : { build/asm/main_8008CCC0.s.o(.bss); }
    .main_8008D5D0 0x8008D5D0 : AT(0x0008E1D0) { FILL(0x00000000); build/asm/main_8008D5D0.s.o(.text); build/asm/main_8008D5D0.s.o(.rodata); build/asm/main_8008D5D0.s.o(.data); }
    .main_8008D5D0_bss (NOLOAD) : { build/asm/main_8008D5D0.s.o(.bss); }
    .main_8008D7EC 0x8008D7EC : AT(0x0008E3EC) { FILL(0x00000000); build/asm/main_8008D7EC.s.o(.text); build/asm/main_8008D7EC.s.o(.rodata); build/asm/main_8008D7EC.s.o(.data); }
    .main_8008D7EC_bss (NOLOAD) : { build/asm/main_8008D7EC.s.o(.bss); }
    .main_8008DC24 0x8008DC24 : AT(0x0008E824) { FILL(0x00000000); build/asm/main_8008DC24.s.o(.text); build/asm/main_8008DC24.s.o(.rodata); build/asm/main_8008DC24.s.o(.data); }
    .main_8008DC24_bss (NOLOAD) : { build/asm/main_8008DC24.s.o(.bss); }
    .main_8008DE28 0x8008DE28 : AT(0x0008EA28) { FILL(0x00000000); build/asm/main_8008DE28.s.o(.text); build/asm/main_8008DE28.s.o(.rodata); build/asm/main_8008DE28.s.o(.data); }
    .main_8008DE28_bss (NOLOAD) : { build/asm/main_8008DE28.s.o(.bss); }
    .main_8008E4F8 0x8008E4F8 : AT(0x0008F0F8) { FILL(0x00000000); build/asm/main_8008E4F8.s.o(.text); build/asm/main_8008E4F8.s.o(.rodata); build/asm/main_8008E4F8.s.o(.data); }
    .main_8008E4F8_bss (NOLOAD) : { build/asm/main_8008E4F8.s.o(.bss); }
    .main_8008F680 0x8008F680 : AT(0x00090280) { FILL(0x00000000); build/asm/main_8008F680.s.o(.text); build/asm/main_8008F680.s.o(.rodata); build/asm/main_8008F680.s.o(.data); }
    .main_8008F680_bss (NOLOAD) : { build/asm/main_8008F680.s.o(.bss); }
    .main_80094CA0 0x80094CA0 : AT(0x000958A0) { FILL(0x00000000); build/asm/main_80094CA0.s.o(.text); build/asm/main_80094CA0.s.o(.rodata); build/asm/main_80094CA0.s.o(.data); }
    .main_80094CA0_bss (NOLOAD) : { build/asm/main_80094CA0.s.o(.bss); }
    .main_80095CA0 0x80095CA0 : AT(0x000968A0) { FILL(0x00000000); build/asm/main_80095CA0.s.o(.text); build/asm/main_80095CA0.s.o(.rodata); build/asm/main_80095CA0.s.o(.data); }
    .main_80095CA0_bss (NOLOAD) : { build/asm/main_80095CA0.s.o(.bss); }
    .main_80096370 0x80096370 : AT(0x00096F70) { FILL(0x00000000); build/asm/main_80096370.s.o(.text); build/asm/main_80096370.s.o(.rodata); build/asm/main_80096370.s.o(.data); }
    .main_80096370_bss (NOLOAD) : { build/asm/main_80096370.s.o(.bss); }
    .main_80099480 0x80099480 : AT(0x0009A080) { FILL(0x00000000); build/asm/main_80099480.s.o(.text); build/asm/main_80099480.s.o(.rodata); build/asm/main_80099480.s.o(.data); }
    .main_80099480_bss (NOLOAD) : { build/asm/main_80099480.s.o(.bss); }
    .main_8009BA68 0x8009BA68 : AT(0x0009C668) { FILL(0x00000000); build/asm/main_8009BA68.s.o(.text); build/asm/main_8009BA68.s.o(.rodata); build/asm/main_8009BA68.s.o(.data); }
    .main_8009BA68_bss (NOLOAD) : { build/asm/main_8009BA68.s.o(.bss); }
    .main_8009BCC8 0x8009BCC8 : AT(0x0009C8C8) { FILL(0x00000000); build/asm/main_8009BCC8.s.o(.text); build/asm/main_8009BCC8.s.o(.rodata); build/asm/main_8009BCC8.s.o(.data); }
    .main_8009BCC8_bss (NOLOAD) : { build/asm/main_8009BCC8.s.o(.bss); }
    .main_8009BEBC 0x8009BEBC : AT(0x0009CABC) { FILL(0x00000000); build/asm/main_8009BEBC.s.o(.text); build/asm/main_8009BEBC.s.o(.rodata); build/asm/main_8009BEBC.s.o(.data); }
    .main_8009BEBC_bss (NOLOAD) : { build/asm/main_8009BEBC.s.o(.bss); }
    .main_8009C860 0x8009C860 : AT(0x0009D460) { build/asm/data/main_8009C860.bin.o(.data); }
    .main_8009C9F0 0x8009C9F0 : AT(0x0009D5F0) { FILL(0x00000000); build/asm/main_8009C9F0.s.o(.text); build/asm/main_8009C9F0.s.o(.rodata); build/asm/main_8009C9F0.s.o(.data); }
    .main_8009C9F0_bss (NOLOAD) : { build/asm/main_8009C9F0.s.o(.bss); }
    .main_8009F6E8 0x8009F6E8 : AT(0x000A02E8) { FILL(0x00000000); build/asm/main_8009F6E8.s.o(.text); build/asm/main_8009F6E8.s.o(.rodata); build/asm/main_8009F6E8.s.o(.data); }
    .main_8009F6E8_bss (NOLOAD) : { build/asm/main_8009F6E8.s.o(.bss); }
    .main_800A794C 0x800A794C : AT(0x000A854C) { FILL(0x00000000); build/asm/main_800A794C.s.o(.text); build/asm/main_800A794C.s.o(.rodata); build/asm/main_800A794C.s.o(.data); }
    .main_800A794C_bss (NOLOAD) : { build/asm/main_800A794C.s.o(.bss); }
    .main_800A7AB4 0x800A7AB4 : AT(0x000A86B4) { FILL(0x00000000); build/asm/main_800A7AB4.s.o(.text); build/asm/main_800A7AB4.s.o(.rodata); build/asm/main_800A7AB4.s.o(.data); }
    .main_800A7AB4_bss (NOLOAD) : { build/asm/main_800A7AB4.s.o(.bss); }
    .main_800A7B44 0x800A7B44 : AT(0x000A8744) { build/asm/data/main_800A7B44.bin.o(.data); }
    .main_800A7EAC 0x800A7EAC : AT(0x000A8AAC) { FILL(0x00000000); build/asm/main_800A7EAC.s.o(.text); build/asm/main_800A7EAC.s.o(.rodata); build/asm/main_800A7EAC.s.o(.data); }
    .main_800A7EAC_bss (NOLOAD) : { build/asm/main_800A7EAC.s.o(.bss); }
    .main_800A7EF4 0x800A7EF4 : AT(0x000A8AF4) { build/asm/data/main_800A7EF4.bin.o(.data); }
    .main_800A7F84 0x800A7F84 : AT(0x000A8B84) { FILL(0x00000000); build/asm/main_800A7F84.s.o(.text); build/asm/main_800A7F84.s.o(.rodata); build/asm/main_800A7F84.s.o(.data); }
    .main_800A7F84_bss (NOLOAD) : { build/asm/main_800A7F84.s.o(.bss); }
    .main_800A8014 0x800A8014 : AT(0x000A8C14) { FILL(0x00000000); build/asm/main_800A8014.s.o(.text); build/asm/main_800A8014.s.o(.rodata); build/asm/main_800A8014.s.o(.data); }
    .main_800A8014_bss (NOLOAD) : { build/asm/main_800A8014.s.o(.bss); }
    .main_800A81C8 0x800A81C8 : AT(0x000A8DC8) { FILL(0x00000000); build/asm/main_800A81C8.s.o(.text); build/asm/main_800A81C8.s.o(.rodata); build/asm/main_800A81C8.s.o(.data); }
    .main_800A81C8_bss (NOLOAD) : { build/asm/main_800A81C8.s.o(.bss); }
    .main_800A8210 0x800A8210 : AT(0x000A8E10) { FILL(0x00000000); build/asm/main_800A8210.s.o(.text); build/asm/main_800A8210.s.o(.rodata); build/asm/main_800A8210.s.o(.data); }
    .main_800A8210_bss (NOLOAD) : { build/asm/main_800A8210.s.o(.bss); }
    .main_800A8258 0x800A8258 : AT(0x000A8E58) { FILL(0x00000000); build/asm/main_800A8258.s.o(.text); build/asm/main_800A8258.s.o(.rodata); build/asm/main_800A8258.s.o(.data); }
    .main_800A8258_bss (NOLOAD) : { build/asm/main_800A8258.s.o(.bss); }
    .main_800A82E8 0x800A82E8 : AT(0x000A8EE8) { FILL(0x00000000); build/asm/main_800A82E8.s.o(.text); build/asm/main_800A82E8.s.o(.rodata); build/asm/main_800A82E8.s.o(.data); }
    .main_800A82E8_bss (NOLOAD) : { build/asm/main_800A82E8.s.o(.bss); }
    .main_800A9098 0x800A9098 : AT(0x000A9C98) { build/asm/data/main_800A9098.bin.o(.data); }
    .main_800A9320 0x800A9320 : AT(0x000A9F20) { FILL(0x00000000); build/asm/main_800A9320.s.o(.text); build/asm/main_800A9320.s.o(.rodata); build/asm/main_800A9320.s.o(.data); }
    .main_800A9320_bss (NOLOAD) : { build/asm/main_800A9320.s.o(.bss); }
    .main_800A95A8 0x800A95A8 : AT(0x000AA1A8) { FILL(0x00000000); build/asm/main_800A95A8.s.o(.text); build/asm/main_800A95A8.s.o(.rodata); build/asm/main_800A95A8.s.o(.data); }
    .main_800A95A8_bss (NOLOAD) : { build/asm/main_800A95A8.s.o(.bss); }
    .main_800A9830 0x800A9830 : AT(0x000AA430) { FILL(0x00000000); build/asm/main_800A9830.s.o(.text); build/asm/main_800A9830.s.o(.rodata); build/asm/main_800A9830.s.o(.data); }
    .main_800A9830_bss (NOLOAD) : { build/asm/main_800A9830.s.o(.bss); }
    .main_800A9AB8 0x800A9AB8 : AT(0x000AA6B8) { build/asm/data/main_800A9AB8.bin.o(.data); }
    .main_800A9D40 0x800A9D40 : AT(0x000AA940) { FILL(0x00000000); build/asm/main_800A9D40.s.o(.text); build/asm/main_800A9D40.s.o(.rodata); build/asm/main_800A9D40.s.o(.data); }
    .main_800A9D40_bss (NOLOAD) : { build/asm/main_800A9D40.s.o(.bss); }
    .main_800AA77C 0x800AA77C : AT(0x000AB37C) { FILL(0x00000000); build/asm/main_800AA77C.s.o(.text); build/asm/main_800AA77C.s.o(.rodata); build/asm/main_800AA77C.s.o(.data); }
    .main_800AA77C_bss (NOLOAD) : { build/asm/main_800AA77C.s.o(.bss); }
    .main_800ACD8C 0x800ACD8C : AT(0x000AD98C) { FILL(0x00000000); build/asm/main_800ACD8C.s.o(.text); build/asm/main_800ACD8C.s.o(.rodata); build/asm/main_800ACD8C.s.o(.data); }
    .main_800ACD8C_bss (NOLOAD) : { build/asm/main_800ACD8C.s.o(.bss); }
    .main_800ACE0C 0x800ACE0C : AT(0x000ADA0C) { build/asm/data/main_800ACE0C.bin.o(.data); }
    .main_800ACE4C 0x800ACE4C : AT(0x000ADA4C) { FILL(0x00000000); build/asm/main_800ACE4C.s.o(.text); build/asm/main_800ACE4C.s.o(.rodata); build/asm/main_800ACE4C.s.o(.data); }
    .main_800ACE4C_bss (NOLOAD) : { build/asm/main_800ACE4C.s.o(.bss); }
    .main_800AEA20 0x800AEA20 : AT(0x000AF620) { FILL(0x00000000); build/asm/main_800AEA20.s.o(.text); build/asm/main_800AEA20.s.o(.rodata); build/asm/main_800AEA20.s.o(.data); }
    .main_800AEA20_bss (NOLOAD) : { build/asm/main_800AEA20.s.o(.bss); }
    .main_800AEE90 0x800AEE90 : AT(0x000AFA90) { build/asm/data/main_800AEE90.bin.o(.data); }
    .main_800AEEF0 0x800AEEF0 : AT(0x000AFAF0) { FILL(0x00000000); build/asm/main_800AEEF0.s.o(.text); build/asm/main_800AEEF0.s.o(.rodata); build/asm/main_800AEEF0.s.o(.data); }
    .main_800AEEF0_bss (NOLOAD) : { build/asm/main_800AEEF0.s.o(.bss); }
    .main_800AEFA0 0x800AEFA0 : AT(0x000AFBA0) { build/asm/data/main_800AEFA0.bin.o(.data); }
    .main_800AEFE0 0x800AEFE0 : AT(0x000AFBE0) { FILL(0x00000000); build/asm/main_800AEFE0.s.o(.text); build/asm/main_800AEFE0.s.o(.rodata); build/asm/main_800AEFE0.s.o(.data); }
    .main_800AEFE0_bss (NOLOAD) : { build/asm/main_800AEFE0.s.o(.bss); }
    .main_800B3AF4 0x800B3AF4 : AT(0x000B46F4) { FILL(0x00000000); build/asm/main_800B3AF4.s.o(.text); build/asm/main_800B3AF4.s.o(.rodata); build/asm/main_800B3AF4.s.o(.data); }
    .main_800B3AF4_bss (NOLOAD) : { build/asm/main_800B3AF4.s.o(.bss); }
    .main_800B4A5C 0x800B4A5C : AT(0x000B565C) { build/asm/data/main_800B4A5C.bin.o(.data); }
    .main_800B5EB8 0x800B5EB8 : AT(0x000B6AB8) { FILL(0x00000000); build/asm/main_800B5EB8.s.o(.text); build/asm/main_800B5EB8.s.o(.rodata); build/asm/main_800B5EB8.s.o(.data); }
    .main_800B5EB8_bss (NOLOAD) : { build/asm/main_800B5EB8.s.o(.bss); }
    .main_800BE3F0 0x800BE3F0 : AT(0x000BEFF0) { build/asm/data/main_800BE3F0.bin.o(.data); }
    .main_800C0428 0x800C0428 : AT(0x000C1028) { FILL(0x00000000); build/asm/main_800C0428.s.o(.text); build/asm/main_800C0428.s.o(.rodata); build/asm/main_800C0428.s.o(.data); }
    .main_800C0428_bss (NOLOAD) : { build/asm/main_800C0428.s.o(.bss); }
    .main_800C338C 0x800C338C : AT(0x000C3F8C) { build/asm/data/main_800C338C.bin.o(.data); }
    .main_800C641C 0x800C641C : AT(0x000C701C) { build/asm/data/main_800C641C.bin.o(.data); }
    .main_800CED14 0x800CED14 : AT(0x000CF914) { FILL(0x00000000); build/asm/main_800CED14.s.o(.text); build/asm/main_800CED14.s.o(.rodata); build/asm/main_800CED14.s.o(.data); }
    .main_800CED14_bss (NOLOAD) : { build/asm/main_800CED14.s.o(.bss); }
    .main_800CED44 0x800CED44 : AT(0x000CF944) { build/asm/data/main_800CED44.bin.o(.data); }
    .main_800D20DC 0x800D20DC : AT(0x000D2CDC) { FILL(0x00000000); build/asm/main_800D20DC.s.o(.text); build/asm/main_800D20DC.s.o(.rodata); build/asm/main_800D20DC.s.o(.data); }
    .main_800D20DC_bss (NOLOAD) : { build/asm/main_800D20DC.s.o(.bss); }
    .main_800D210C 0x800D210C : AT(0x000D2D0C) { build/asm/data/main_800D210C.bin.o(.data); }
    .main_800D31DC 0x800D31DC : AT(0x000D3DDC) { FILL(0x00000000); build/asm/main_800D31DC.s.o(.text); build/asm/main_800D31DC.s.o(.rodata); build/asm/main_800D31DC.s.o(.data); }
    .main_800D31DC_bss (NOLOAD) : { build/asm/main_800D31DC.s.o(.bss); }
    .main_800E377C 0x800E377C : AT(0x000E437C) { build/asm/data/main_800E377C.bin.o(.data); }
    .main_800EB1E0 0x800EB1E0 : AT(0x000EBDE0) { build/asm/data/main_800EB1E0.bin.o(.data); }
    .main_800F3A10 0x800F3A10 : AT(0x000F4610) { FILL(0x00000000); build/asm/main_800F3A10.s.o(.text); build/asm/main_800F3A10.s.o(.rodata); build/asm/main_800F3A10.s.o(.data); }
    .main_800F3A10_bss (NOLOAD) : { build/asm/main_800F3A10.s.o(.bss); }
    .main_800F3A20 0x800F3A20 : AT(0x000F4620) { build/asm/data/main_800F3A20.bin.o(.data); }
    .main_800F8850 0x800F8850 : AT(0x000F9450) { FILL(0x00000000); build/asm/main_800F8850.s.o(.text); build/asm/main_800F8850.s.o(.rodata); build/asm/main_800F8850.s.o(.data); }
    .main_800F8850_bss (NOLOAD) : { build/asm/main_800F8850.s.o(.bss); }
    .main_800F8860 0x800F8860 : AT(0x000F9460) { build/asm/data/main_800F8860.bin.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
