SECTIONS
{
    _gp = 0x801505B0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80096400 0x80096400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80096400.s.o(.text); build/asm/main_80096400.s.o(.rodata); build/asm/main_80096400.s.o(.data); }
    .main_80096400_bss (NOLOAD) : { build/asm/main_80096400.s.o(.bss); }
    .main_80096590 0x80096590 : AT(0x00001190) { FILL(0x00000000); build/asm/main_80096590.s.o(.text); build/asm/main_80096590.s.o(.rodata); build/asm/main_80096590.s.o(.data); }
    .main_80096590_bss (NOLOAD) : { build/asm/main_80096590.s.o(.bss); }
    .main_80096D40 0x80096D40 : AT(0x00001940) { FILL(0x00000000); build/asm/main_80096D40.s.o(.text); build/asm/main_80096D40.s.o(.rodata); build/asm/main_80096D40.s.o(.data); }
    .main_80096D40_bss (NOLOAD) : { build/asm/main_80096D40.s.o(.bss); }
    .main_80096F7C 0x80096F7C : AT(0x00001B7C) { FILL(0x00000000); build/asm/main_80096F7C.s.o(.text); build/asm/main_80096F7C.s.o(.rodata); build/asm/main_80096F7C.s.o(.data); }
    .main_80096F7C_bss (NOLOAD) : { build/asm/main_80096F7C.s.o(.bss); }
    .main_80099EC0 0x80099EC0 : AT(0x00004AC0) { FILL(0x00000000); build/asm/main_80099EC0.s.o(.text); build/asm/main_80099EC0.s.o(.rodata); build/asm/main_80099EC0.s.o(.data); }
    .main_80099EC0_bss (NOLOAD) : { build/asm/main_80099EC0.s.o(.bss); }
    .main_8009D0E0 0x8009D0E0 : AT(0x00007CE0) { FILL(0x00000000); build/asm/main_8009D0E0.s.o(.text); build/asm/main_8009D0E0.s.o(.rodata); build/asm/main_8009D0E0.s.o(.data); }
    .main_8009D0E0_bss (NOLOAD) : { build/asm/main_8009D0E0.s.o(.bss); }
    .main_8009D36C 0x8009D36C : AT(0x00007F6C) { FILL(0x00000000); build/asm/main_8009D36C.s.o(.text); build/asm/main_8009D36C.s.o(.rodata); build/asm/main_8009D36C.s.o(.data); }
    .main_8009D36C_bss (NOLOAD) : { build/asm/main_8009D36C.s.o(.bss); }
    .main_8009DB5C 0x8009DB5C : AT(0x0000875C) { FILL(0x00000000); build/asm/main_8009DB5C.s.o(.text); build/asm/main_8009DB5C.s.o(.rodata); build/asm/main_8009DB5C.s.o(.data); }
    .main_8009DB5C_bss (NOLOAD) : { build/asm/main_8009DB5C.s.o(.bss); }
    .main_8009ED7C 0x8009ED7C : AT(0x0000997C) { FILL(0x00000000); build/asm/main_8009ED7C.s.o(.text); build/asm/main_8009ED7C.s.o(.rodata); build/asm/main_8009ED7C.s.o(.data); }
    .main_8009ED7C_bss (NOLOAD) : { build/asm/main_8009ED7C.s.o(.bss); }
    .main_800A1300 0x800A1300 : AT(0x0000BF00) { FILL(0x00000000); build/asm/main_800A1300.s.o(.text); build/asm/main_800A1300.s.o(.rodata); build/asm/main_800A1300.s.o(.data); }
    .main_800A1300_bss (NOLOAD) : { build/asm/main_800A1300.s.o(.bss); }
    .main_800A29D0 0x800A29D0 : AT(0x0000D5D0) { FILL(0x00000000); build/asm/main_800A29D0.s.o(.text); build/asm/main_800A29D0.s.o(.rodata); build/asm/main_800A29D0.s.o(.data); }
    .main_800A29D0_bss (NOLOAD) : { build/asm/main_800A29D0.s.o(.bss); }
    .main_800A2EB4 0x800A2EB4 : AT(0x0000DAB4) { FILL(0x00000000); build/asm/main_800A2EB4.s.o(.text); build/asm/main_800A2EB4.s.o(.rodata); build/asm/main_800A2EB4.s.o(.data); }
    .main_800A2EB4_bss (NOLOAD) : { build/asm/main_800A2EB4.s.o(.bss); }
    .main_800A3710 0x800A3710 : AT(0x0000E310) { FILL(0x00000000); build/asm/main_800A3710.s.o(.text); build/asm/main_800A3710.s.o(.rodata); build/asm/main_800A3710.s.o(.data); }
    .main_800A3710_bss (NOLOAD) : { build/asm/main_800A3710.s.o(.bss); }
    .main_800A39D8 0x800A39D8 : AT(0x0000E5D8) { FILL(0x00000000); build/asm/main_800A39D8.s.o(.text); build/asm/main_800A39D8.s.o(.rodata); build/asm/main_800A39D8.s.o(.data); }
    .main_800A39D8_bss (NOLOAD) : { build/asm/main_800A39D8.s.o(.bss); }
    .main_800A3BF0 0x800A3BF0 : AT(0x0000E7F0) { FILL(0x00000000); build/asm/main_800A3BF0.s.o(.text); build/asm/main_800A3BF0.s.o(.rodata); build/asm/main_800A3BF0.s.o(.data); }
    .main_800A3BF0_bss (NOLOAD) : { build/asm/main_800A3BF0.s.o(.bss); }
    .main_800A3D30 0x800A3D30 : AT(0x0000E930) { FILL(0x00000000); build/asm/main_800A3D30.s.o(.text); build/asm/main_800A3D30.s.o(.rodata); build/asm/main_800A3D30.s.o(.data); }
    .main_800A3D30_bss (NOLOAD) : { build/asm/main_800A3D30.s.o(.bss); }
    .main_800A6860 0x800A6860 : AT(0x00011460) { FILL(0x00000000); build/asm/main_800A6860.s.o(.text); build/asm/main_800A6860.s.o(.rodata); build/asm/main_800A6860.s.o(.data); }
    .main_800A6860_bss (NOLOAD) : { build/asm/main_800A6860.s.o(.bss); }
    .main_800A68D0 0x800A68D0 : AT(0x000114D0) { FILL(0x00000000); build/asm/main_800A68D0.s.o(.text); build/asm/main_800A68D0.s.o(.rodata); build/asm/main_800A68D0.s.o(.data); }
    .main_800A68D0_bss (NOLOAD) : { build/asm/main_800A68D0.s.o(.bss); }
    .main_800A94A8 0x800A94A8 : AT(0x000140A8) { build/asm/data/main_800A94A8.bin.o(.data); }
    .main_800A95C0 0x800A95C0 : AT(0x000141C0) { FILL(0x00000000); build/asm/main_800A95C0.s.o(.text); build/asm/main_800A95C0.s.o(.rodata); build/asm/main_800A95C0.s.o(.data); }
    .main_800A95C0_bss (NOLOAD) : { build/asm/main_800A95C0.s.o(.bss); }
    .main_800AEBE0 0x800AEBE0 : AT(0x000197E0) { build/asm/data/main_800AEBE0.bin.o(.data); }
    .main_800AED60 0x800AED60 : AT(0x00019960) { FILL(0x00000000); build/asm/main_800AED60.s.o(.text); build/asm/main_800AED60.s.o(.rodata); build/asm/main_800AED60.s.o(.data); }
    .main_800AED60_bss (NOLOAD) : { build/asm/main_800AED60.s.o(.bss); }
    .main_800B2A64 0x800B2A64 : AT(0x0001D664) { FILL(0x00000000); build/asm/main_800B2A64.s.o(.text); build/asm/main_800B2A64.s.o(.rodata); build/asm/main_800B2A64.s.o(.data); }
    .main_800B2A64_bss (NOLOAD) : { build/asm/main_800B2A64.s.o(.bss); }
    .main_800B5248 0x800B5248 : AT(0x0001FE48) { build/asm/data/main_800B5248.bin.o(.data); }
    .main_800B56E0 0x800B56E0 : AT(0x000202E0) { FILL(0x00000000); build/asm/main_800B56E0.s.o(.text); build/asm/main_800B56E0.s.o(.rodata); build/asm/main_800B56E0.s.o(.data); }
    .main_800B56E0_bss (NOLOAD) : { build/asm/main_800B56E0.s.o(.bss); }
    .main_8011A980 0x8011A980 : AT(0x00085580) { build/asm/data/main_8011A980.bin.o(.data); }
    .main_8011B480 0x8011B480 : AT(0x00086080) { FILL(0x00000000); build/asm/main_8011B480.s.o(.text); build/asm/main_8011B480.s.o(.rodata); build/asm/main_8011B480.s.o(.data); }
    .main_8011B480_bss (NOLOAD) : { build/asm/main_8011B480.s.o(.bss); }
    .main_8011E3A0 0x8011E3A0 : AT(0x00088FA0) { FILL(0x00000000); build/asm/main_8011E3A0.s.o(.text); build/asm/main_8011E3A0.s.o(.rodata); build/asm/main_8011E3A0.s.o(.data); }
    .main_8011E3A0_bss (NOLOAD) : { build/asm/main_8011E3A0.s.o(.bss); }
    .main_8011EBF0 0x8011EBF0 : AT(0x000897F0) { FILL(0x00000000); build/asm/main_8011EBF0.s.o(.text); build/asm/main_8011EBF0.s.o(.rodata); build/asm/main_8011EBF0.s.o(.data); }
    .main_8011EBF0_bss (NOLOAD) : { build/asm/main_8011EBF0.s.o(.bss); }
    .main_8011F350 0x8011F350 : AT(0x00089F50) { FILL(0x00000000); build/asm/main_8011F350.s.o(.text); build/asm/main_8011F350.s.o(.rodata); build/asm/main_8011F350.s.o(.data); }
    .main_8011F350_bss (NOLOAD) : { build/asm/main_8011F350.s.o(.bss); }
    .main_8011F798 0x8011F798 : AT(0x0008A398) { FILL(0x00000000); build/asm/main_8011F798.s.o(.text); build/asm/main_8011F798.s.o(.rodata); build/asm/main_8011F798.s.o(.data); }
    .main_8011F798_bss (NOLOAD) : { build/asm/main_8011F798.s.o(.bss); }
    .main_80121EF4 0x80121EF4 : AT(0x0008CAF4) { FILL(0x00000000); build/asm/main_80121EF4.s.o(.text); build/asm/main_80121EF4.s.o(.rodata); build/asm/main_80121EF4.s.o(.data); }
    .main_80121EF4_bss (NOLOAD) : { build/asm/main_80121EF4.s.o(.bss); }
    .main_801222D0 0x801222D0 : AT(0x0008CED0) { FILL(0x00000000); build/asm/main_801222D0.s.o(.text); build/asm/main_801222D0.s.o(.rodata); build/asm/main_801222D0.s.o(.data); }
    .main_801222D0_bss (NOLOAD) : { build/asm/main_801222D0.s.o(.bss); }
    .main_80123DF0 0x80123DF0 : AT(0x0008E9F0) { FILL(0x00000000); build/asm/main_80123DF0.s.o(.text); build/asm/main_80123DF0.s.o(.rodata); build/asm/main_80123DF0.s.o(.data); }
    .main_80123DF0_bss (NOLOAD) : { build/asm/main_80123DF0.s.o(.bss); }
    .main_801241FC 0x801241FC : AT(0x0008EDFC) { FILL(0x00000000); build/asm/main_801241FC.s.o(.text); build/asm/main_801241FC.s.o(.rodata); build/asm/main_801241FC.s.o(.data); }
    .main_801241FC_bss (NOLOAD) : { build/asm/main_801241FC.s.o(.bss); }
    .main_8012477C 0x8012477C : AT(0x0008F37C) { FILL(0x00000000); build/asm/main_8012477C.s.o(.text); build/asm/main_8012477C.s.o(.rodata); build/asm/main_8012477C.s.o(.data); }
    .main_8012477C_bss (NOLOAD) : { build/asm/main_8012477C.s.o(.bss); }
    .main_801250D0 0x801250D0 : AT(0x0008FCD0) { FILL(0x00000000); build/asm/main_801250D0.s.o(.text); build/asm/main_801250D0.s.o(.rodata); build/asm/main_801250D0.s.o(.data); }
    .main_801250D0_bss (NOLOAD) : { build/asm/main_801250D0.s.o(.bss); }
    .main_801252EC 0x801252EC : AT(0x0008FEEC) { FILL(0x00000000); build/asm/main_801252EC.s.o(.text); build/asm/main_801252EC.s.o(.rodata); build/asm/main_801252EC.s.o(.data); }
    .main_801252EC_bss (NOLOAD) : { build/asm/main_801252EC.s.o(.bss); }
    .main_80125760 0x80125760 : AT(0x00090360) { FILL(0x00000000); build/asm/main_80125760.s.o(.text); build/asm/main_80125760.s.o(.rodata); build/asm/main_80125760.s.o(.data); }
    .main_80125760_bss (NOLOAD) : { build/asm/main_80125760.s.o(.bss); }
    .main_80125964 0x80125964 : AT(0x00090564) { FILL(0x00000000); build/asm/main_80125964.s.o(.text); build/asm/main_80125964.s.o(.rodata); build/asm/main_80125964.s.o(.data); }
    .main_80125964_bss (NOLOAD) : { build/asm/main_80125964.s.o(.bss); }
    .main_80126090 0x80126090 : AT(0x00090C90) { FILL(0x00000000); build/asm/main_80126090.s.o(.text); build/asm/main_80126090.s.o(.rodata); build/asm/main_80126090.s.o(.data); }
    .main_80126090_bss (NOLOAD) : { build/asm/main_80126090.s.o(.bss); }
    .main_8012C8A0 0x8012C8A0 : AT(0x000974A0) { FILL(0x00000000); build/asm/main_8012C8A0.s.o(.text); build/asm/main_8012C8A0.s.o(.rodata); build/asm/main_8012C8A0.s.o(.data); }
    .main_8012C8A0_bss (NOLOAD) : { build/asm/main_8012C8A0.s.o(.bss); }
    .main_8012D960 0x8012D960 : AT(0x00098560) { FILL(0x00000000); build/asm/main_8012D960.s.o(.text); build/asm/main_8012D960.s.o(.rodata); build/asm/main_8012D960.s.o(.data); }
    .main_8012D960_bss (NOLOAD) : { build/asm/main_8012D960.s.o(.bss); }
    .main_8012E030 0x8012E030 : AT(0x00098C30) { FILL(0x00000000); build/asm/main_8012E030.s.o(.text); build/asm/main_8012E030.s.o(.rodata); build/asm/main_8012E030.s.o(.data); }
    .main_8012E030_bss (NOLOAD) : { build/asm/main_8012E030.s.o(.bss); }
    .main_8012FC2C 0x8012FC2C : AT(0x0009A82C) { FILL(0x00000000); build/asm/main_8012FC2C.s.o(.text); build/asm/main_8012FC2C.s.o(.rodata); build/asm/main_8012FC2C.s.o(.data); }
    .main_8012FC2C_bss (NOLOAD) : { build/asm/main_8012FC2C.s.o(.bss); }
    .main_80130CA0 0x80130CA0 : AT(0x0009B8A0) { FILL(0x00000000); build/asm/main_80130CA0.s.o(.text); build/asm/main_80130CA0.s.o(.rodata); build/asm/main_80130CA0.s.o(.data); }
    .main_80130CA0_bss (NOLOAD) : { build/asm/main_80130CA0.s.o(.bss); }
    .main_8013CA9C 0x8013CA9C : AT(0x000A769C) { FILL(0x00000000); build/asm/main_8013CA9C.s.o(.text); build/asm/main_8013CA9C.s.o(.rodata); build/asm/main_8013CA9C.s.o(.data); }
    .main_8013CA9C_bss (NOLOAD) : { build/asm/main_8013CA9C.s.o(.bss); }
    .main_8013CCE4 0x8013CCE4 : AT(0x000A78E4) { FILL(0x00000000); build/asm/main_8013CCE4.s.o(.text); build/asm/main_8013CCE4.s.o(.rodata); build/asm/main_8013CCE4.s.o(.data); }
    .main_8013CCE4_bss (NOLOAD) : { build/asm/main_8013CCE4.s.o(.bss); }
    .main_8013CF2C 0x8013CF2C : AT(0x000A7B2C) { build/asm/data/main_8013CF2C.bin.o(.data); }
    .main_8013DCBC 0x8013DCBC : AT(0x000A88BC) { FILL(0x00000000); build/asm/main_8013DCBC.s.o(.text); build/asm/main_8013DCBC.s.o(.rodata); build/asm/main_8013DCBC.s.o(.data); }
    .main_8013DCBC_bss (NOLOAD) : { build/asm/main_8013DCBC.s.o(.bss); }
    .main_8013DD7C 0x8013DD7C : AT(0x000A897C) { build/asm/data/main_8013DD7C.bin.o(.data); }
    .main_8013DF64 0x8013DF64 : AT(0x000A8B64) { FILL(0x00000000); build/asm/main_8013DF64.s.o(.text); build/asm/main_8013DF64.s.o(.rodata); build/asm/main_8013DF64.s.o(.data); }
    .main_8013DF64_bss (NOLOAD) : { build/asm/main_8013DF64.s.o(.bss); }
    .main_8013E05C 0x8013E05C : AT(0x000A8C5C) { FILL(0x00000000); build/asm/main_8013E05C.s.o(.text); build/asm/main_8013E05C.s.o(.rodata); build/asm/main_8013E05C.s.o(.data); }
    .main_8013E05C_bss (NOLOAD) : { build/asm/main_8013E05C.s.o(.bss); }
    .main_8013E20C 0x8013E20C : AT(0x000A8E0C) { FILL(0x00000000); build/asm/main_8013E20C.s.o(.text); build/asm/main_8013E20C.s.o(.rodata); build/asm/main_8013E20C.s.o(.data); }
    .main_8013E20C_bss (NOLOAD) : { build/asm/main_8013E20C.s.o(.bss); }
    .main_8013E2A4 0x8013E2A4 : AT(0x000A8EA4) { FILL(0x00000000); build/asm/main_8013E2A4.s.o(.text); build/asm/main_8013E2A4.s.o(.rodata); build/asm/main_8013E2A4.s.o(.data); }
    .main_8013E2A4_bss (NOLOAD) : { build/asm/main_8013E2A4.s.o(.bss); }
    .main_8013E3BC 0x8013E3BC : AT(0x000A8FBC) { FILL(0x00000000); build/asm/main_8013E3BC.s.o(.text); build/asm/main_8013E3BC.s.o(.rodata); build/asm/main_8013E3BC.s.o(.data); }
    .main_8013E3BC_bss (NOLOAD) : { build/asm/main_8013E3BC.s.o(.bss); }
    .main_8013E454 0x8013E454 : AT(0x000A9054) { FILL(0x00000000); build/asm/main_8013E454.s.o(.text); build/asm/main_8013E454.s.o(.rodata); build/asm/main_8013E454.s.o(.data); }
    .main_8013E454_bss (NOLOAD) : { build/asm/main_8013E454.s.o(.bss); }
    .main_8013E4EC 0x8013E4EC : AT(0x000A90EC) { FILL(0x00000000); build/asm/main_8013E4EC.s.o(.text); build/asm/main_8013E4EC.s.o(.rodata); build/asm/main_8013E4EC.s.o(.data); }
    .main_8013E4EC_bss (NOLOAD) : { build/asm/main_8013E4EC.s.o(.bss); }
    .main_8013E6EC 0x8013E6EC : AT(0x000A92EC) { FILL(0x00000000); build/asm/main_8013E6EC.s.o(.text); build/asm/main_8013E6EC.s.o(.rodata); build/asm/main_8013E6EC.s.o(.data); }
    .main_8013E6EC_bss (NOLOAD) : { build/asm/main_8013E6EC.s.o(.bss); }
    .main_8013E934 0x8013E934 : AT(0x000A9534) { FILL(0x00000000); build/asm/main_8013E934.s.o(.text); build/asm/main_8013E934.s.o(.rodata); build/asm/main_8013E934.s.o(.data); }
    .main_8013E934_bss (NOLOAD) : { build/asm/main_8013E934.s.o(.bss); }
    .main_8013EB7C 0x8013EB7C : AT(0x000A977C) { FILL(0x00000000); build/asm/main_8013EB7C.s.o(.text); build/asm/main_8013EB7C.s.o(.rodata); build/asm/main_8013EB7C.s.o(.data); }
    .main_8013EB7C_bss (NOLOAD) : { build/asm/main_8013EB7C.s.o(.bss); }
    .main_8013EDC4 0x8013EDC4 : AT(0x000A99C4) { FILL(0x00000000); build/asm/main_8013EDC4.s.o(.text); build/asm/main_8013EDC4.s.o(.rodata); build/asm/main_8013EDC4.s.o(.data); }
    .main_8013EDC4_bss (NOLOAD) : { build/asm/main_8013EDC4.s.o(.bss); }
    .main_8013F9CC 0x8013F9CC : AT(0x000AA5CC) { FILL(0x00000000); build/asm/main_8013F9CC.s.o(.text); build/asm/main_8013F9CC.s.o(.rodata); build/asm/main_8013F9CC.s.o(.data); }
    .main_8013F9CC_bss (NOLOAD) : { build/asm/main_8013F9CC.s.o(.bss); }
    .main_8013FC14 0x8013FC14 : AT(0x000AA814) { FILL(0x00000000); build/asm/main_8013FC14.s.o(.text); build/asm/main_8013FC14.s.o(.rodata); build/asm/main_8013FC14.s.o(.data); }
    .main_8013FC14_bss (NOLOAD) : { build/asm/main_8013FC14.s.o(.bss); }
    .main_8013FE5C 0x8013FE5C : AT(0x000AAA5C) { FILL(0x00000000); build/asm/main_8013FE5C.s.o(.text); build/asm/main_8013FE5C.s.o(.rodata); build/asm/main_8013FE5C.s.o(.data); }
    .main_8013FE5C_bss (NOLOAD) : { build/asm/main_8013FE5C.s.o(.bss); }
    .main_801400A4 0x801400A4 : AT(0x000AACA4) { FILL(0x00000000); build/asm/main_801400A4.s.o(.text); build/asm/main_801400A4.s.o(.rodata); build/asm/main_801400A4.s.o(.data); }
    .main_801400A4_bss (NOLOAD) : { build/asm/main_801400A4.s.o(.bss); }
    .main_801408B4 0x801408B4 : AT(0x000AB4B4) { FILL(0x00000000); build/asm/main_801408B4.s.o(.text); build/asm/main_801408B4.s.o(.rodata); build/asm/main_801408B4.s.o(.data); }
    .main_801408B4_bss (NOLOAD) : { build/asm/main_801408B4.s.o(.bss); }
    .main_801408FC 0x801408FC : AT(0x000AB4FC) { FILL(0x00000000); build/asm/main_801408FC.s.o(.text); build/asm/main_801408FC.s.o(.rodata); build/asm/main_801408FC.s.o(.data); }
    .main_801408FC_bss (NOLOAD) : { build/asm/main_801408FC.s.o(.bss); }
    .main_801414A4 0x801414A4 : AT(0x000AC0A4) { FILL(0x00000000); build/asm/main_801414A4.s.o(.text); build/asm/main_801414A4.s.o(.rodata); build/asm/main_801414A4.s.o(.data); }
    .main_801414A4_bss (NOLOAD) : { build/asm/main_801414A4.s.o(.bss); }
    .main_801414EC 0x801414EC : AT(0x000AC0EC) { FILL(0x00000000); build/asm/main_801414EC.s.o(.text); build/asm/main_801414EC.s.o(.rodata); build/asm/main_801414EC.s.o(.data); }
    .main_801414EC_bss (NOLOAD) : { build/asm/main_801414EC.s.o(.bss); }
    .main_8014162C 0x8014162C : AT(0x000AC22C) { FILL(0x00000000); build/asm/main_8014162C.s.o(.text); build/asm/main_8014162C.s.o(.rodata); build/asm/main_8014162C.s.o(.data); }
    .main_8014162C_bss (NOLOAD) : { build/asm/main_8014162C.s.o(.bss); }
    .main_8014188C 0x8014188C : AT(0x000AC48C) { FILL(0x00000000); build/asm/main_8014188C.s.o(.text); build/asm/main_8014188C.s.o(.rodata); build/asm/main_8014188C.s.o(.data); }
    .main_8014188C_bss (NOLOAD) : { build/asm/main_8014188C.s.o(.bss); }
    .main_80142744 0x80142744 : AT(0x000AD344) { FILL(0x00000000); build/asm/main_80142744.s.o(.text); build/asm/main_80142744.s.o(.rodata); build/asm/main_80142744.s.o(.data); }
    .main_80142744_bss (NOLOAD) : { build/asm/main_80142744.s.o(.bss); }
    .main_801428EC 0x801428EC : AT(0x000AD4EC) { FILL(0x00000000); build/asm/main_801428EC.s.o(.text); build/asm/main_801428EC.s.o(.rodata); build/asm/main_801428EC.s.o(.data); }
    .main_801428EC_bss (NOLOAD) : { build/asm/main_801428EC.s.o(.bss); }
    .main_801429BC 0x801429BC : AT(0x000AD5BC) { FILL(0x00000000); build/asm/main_801429BC.s.o(.text); build/asm/main_801429BC.s.o(.rodata); build/asm/main_801429BC.s.o(.data); }
    .main_801429BC_bss (NOLOAD) : { build/asm/main_801429BC.s.o(.bss); }
    .main_80142A34 0x80142A34 : AT(0x000AD634) { FILL(0x00000000); build/asm/main_80142A34.s.o(.text); build/asm/main_80142A34.s.o(.rodata); build/asm/main_80142A34.s.o(.data); }
    .main_80142A34_bss (NOLOAD) : { build/asm/main_80142A34.s.o(.bss); }
    .main_80142A94 0x80142A94 : AT(0x000AD694) { FILL(0x00000000); build/asm/main_80142A94.s.o(.text); build/asm/main_80142A94.s.o(.rodata); build/asm/main_80142A94.s.o(.data); }
    .main_80142A94_bss (NOLOAD) : { build/asm/main_80142A94.s.o(.bss); }
    .main_80142B0C 0x80142B0C : AT(0x000AD70C) { FILL(0x00000000); build/asm/main_80142B0C.s.o(.text); build/asm/main_80142B0C.s.o(.rodata); build/asm/main_80142B0C.s.o(.data); }
    .main_80142B0C_bss (NOLOAD) : { build/asm/main_80142B0C.s.o(.bss); }
    .main_801430C4 0x801430C4 : AT(0x000ADCC4) { FILL(0x00000000); build/asm/main_801430C4.s.o(.text); build/asm/main_801430C4.s.o(.rodata); build/asm/main_801430C4.s.o(.data); }
    .main_801430C4_bss (NOLOAD) : { build/asm/main_801430C4.s.o(.bss); }
    .main_80143144 0x80143144 : AT(0x000ADD44) { FILL(0x00000000); build/asm/main_80143144.s.o(.text); build/asm/main_80143144.s.o(.rodata); build/asm/main_80143144.s.o(.data); }
    .main_80143144_bss (NOLOAD) : { build/asm/main_80143144.s.o(.bss); }
    .main_8014318C 0x8014318C : AT(0x000ADD8C) { FILL(0x00000000); build/asm/main_8014318C.s.o(.text); build/asm/main_8014318C.s.o(.rodata); build/asm/main_8014318C.s.o(.data); }
    .main_8014318C_bss (NOLOAD) : { build/asm/main_8014318C.s.o(.bss); }
    .main_801432A4 0x801432A4 : AT(0x000ADEA4) { FILL(0x00000000); build/asm/main_801432A4.s.o(.text); build/asm/main_801432A4.s.o(.rodata); build/asm/main_801432A4.s.o(.data); }
    .main_801432A4_bss (NOLOAD) : { build/asm/main_801432A4.s.o(.bss); }
    .main_8014332C 0x8014332C : AT(0x000ADF2C) { FILL(0x00000000); build/asm/main_8014332C.s.o(.text); build/asm/main_8014332C.s.o(.rodata); build/asm/main_8014332C.s.o(.data); }
    .main_8014332C_bss (NOLOAD) : { build/asm/main_8014332C.s.o(.bss); }
    .main_801433B4 0x801433B4 : AT(0x000ADFB4) { FILL(0x00000000); build/asm/main_801433B4.s.o(.text); build/asm/main_801433B4.s.o(.rodata); build/asm/main_801433B4.s.o(.data); }
    .main_801433B4_bss (NOLOAD) : { build/asm/main_801433B4.s.o(.bss); }
    .main_8014372C 0x8014372C : AT(0x000AE32C) { FILL(0x00000000); build/asm/main_8014372C.s.o(.text); build/asm/main_8014372C.s.o(.rodata); build/asm/main_8014372C.s.o(.data); }
    .main_8014372C_bss (NOLOAD) : { build/asm/main_8014372C.s.o(.bss); }
    .main_80143884 0x80143884 : AT(0x000AE484) { FILL(0x00000000); build/asm/main_80143884.s.o(.text); build/asm/main_80143884.s.o(.rodata); build/asm/main_80143884.s.o(.data); }
    .main_80143884_bss (NOLOAD) : { build/asm/main_80143884.s.o(.bss); }
    .main_801439C4 0x801439C4 : AT(0x000AE5C4) { FILL(0x00000000); build/asm/main_801439C4.s.o(.text); build/asm/main_801439C4.s.o(.rodata); build/asm/main_801439C4.s.o(.data); }
    .main_801439C4_bss (NOLOAD) : { build/asm/main_801439C4.s.o(.bss); }
    .main_80143A14 0x80143A14 : AT(0x000AE614) { FILL(0x00000000); build/asm/main_80143A14.s.o(.text); build/asm/main_80143A14.s.o(.rodata); build/asm/main_80143A14.s.o(.data); }
    .main_80143A14_bss (NOLOAD) : { build/asm/main_80143A14.s.o(.bss); }
    .main_80143A9C 0x80143A9C : AT(0x000AE69C) { FILL(0x00000000); build/asm/main_80143A9C.s.o(.text); build/asm/main_80143A9C.s.o(.rodata); build/asm/main_80143A9C.s.o(.data); }
    .main_80143A9C_bss (NOLOAD) : { build/asm/main_80143A9C.s.o(.bss); }
    .main_80143C1C 0x80143C1C : AT(0x000AE81C) { FILL(0x00000000); build/asm/main_80143C1C.s.o(.text); build/asm/main_80143C1C.s.o(.rodata); build/asm/main_80143C1C.s.o(.data); }
    .main_80143C1C_bss (NOLOAD) : { build/asm/main_80143C1C.s.o(.bss); }
    .main_801440CC 0x801440CC : AT(0x000AECCC) { FILL(0x00000000); build/asm/main_801440CC.s.o(.text); build/asm/main_801440CC.s.o(.rodata); build/asm/main_801440CC.s.o(.data); }
    .main_801440CC_bss (NOLOAD) : { build/asm/main_801440CC.s.o(.bss); }
    .main_801440DC 0x801440DC : AT(0x000AECDC) { FILL(0x00000000); build/asm/main_801440DC.s.o(.text); build/asm/main_801440DC.s.o(.rodata); build/asm/main_801440DC.s.o(.data); }
    .main_801440DC_bss (NOLOAD) : { build/asm/main_801440DC.s.o(.bss); }
    .main_80144194 0x80144194 : AT(0x000AED94) { FILL(0x00000000); build/asm/main_80144194.s.o(.text); build/asm/main_80144194.s.o(.rodata); build/asm/main_80144194.s.o(.data); }
    .main_80144194_bss (NOLOAD) : { build/asm/main_80144194.s.o(.bss); }
    .main_801441CC 0x801441CC : AT(0x000AEDCC) { FILL(0x00000000); build/asm/main_801441CC.s.o(.text); build/asm/main_801441CC.s.o(.rodata); build/asm/main_801441CC.s.o(.data); }
    .main_801441CC_bss (NOLOAD) : { build/asm/main_801441CC.s.o(.bss); }
    .main_80144284 0x80144284 : AT(0x000AEE84) { FILL(0x00000000); build/asm/main_80144284.s.o(.text); build/asm/main_80144284.s.o(.rodata); build/asm/main_80144284.s.o(.data); }
    .main_80144284_bss (NOLOAD) : { build/asm/main_80144284.s.o(.bss); }
    .main_801457F4 0x801457F4 : AT(0x000B03F4) { FILL(0x00000000); build/asm/main_801457F4.s.o(.text); build/asm/main_801457F4.s.o(.rodata); build/asm/main_801457F4.s.o(.data); }
    .main_801457F4_bss (NOLOAD) : { build/asm/main_801457F4.s.o(.bss); }
    .main_8014594C 0x8014594C : AT(0x000B054C) { FILL(0x00000000); build/asm/main_8014594C.s.o(.text); build/asm/main_8014594C.s.o(.rodata); build/asm/main_8014594C.s.o(.data); }
    .main_8014594C_bss (NOLOAD) : { build/asm/main_8014594C.s.o(.bss); }
    .main_801459D4 0x801459D4 : AT(0x000B05D4) { FILL(0x00000000); build/asm/main_801459D4.s.o(.text); build/asm/main_801459D4.s.o(.rodata); build/asm/main_801459D4.s.o(.data); }
    .main_801459D4_bss (NOLOAD) : { build/asm/main_801459D4.s.o(.bss); }
    .main_80145A3C 0x80145A3C : AT(0x000B063C) { FILL(0x00000000); build/asm/main_80145A3C.s.o(.text); build/asm/main_80145A3C.s.o(.rodata); build/asm/main_80145A3C.s.o(.data); }
    .main_80145A3C_bss (NOLOAD) : { build/asm/main_80145A3C.s.o(.bss); }
    .main_80145AAC 0x80145AAC : AT(0x000B06AC) { FILL(0x00000000); build/asm/main_80145AAC.s.o(.text); build/asm/main_80145AAC.s.o(.rodata); build/asm/main_80145AAC.s.o(.data); }
    .main_80145AAC_bss (NOLOAD) : { build/asm/main_80145AAC.s.o(.bss); }
    .main_80145C44 0x80145C44 : AT(0x000B0844) { FILL(0x00000000); build/asm/main_80145C44.s.o(.text); build/asm/main_80145C44.s.o(.rodata); build/asm/main_80145C44.s.o(.data); }
    .main_80145C44_bss (NOLOAD) : { build/asm/main_80145C44.s.o(.bss); }
    .main_80145C84 0x80145C84 : AT(0x000B0884) { FILL(0x00000000); build/asm/main_80145C84.s.o(.text); build/asm/main_80145C84.s.o(.rodata); build/asm/main_80145C84.s.o(.data); }
    .main_80145C84_bss (NOLOAD) : { build/asm/main_80145C84.s.o(.bss); }
    .main_80145CB4 0x80145CB4 : AT(0x000B08B4) { FILL(0x00000000); build/asm/main_80145CB4.s.o(.text); build/asm/main_80145CB4.s.o(.rodata); build/asm/main_80145CB4.s.o(.data); }
    .main_80145CB4_bss (NOLOAD) : { build/asm/main_80145CB4.s.o(.bss); }
    .main_80145D3C 0x80145D3C : AT(0x000B093C) { FILL(0x00000000); build/asm/main_80145D3C.s.o(.text); build/asm/main_80145D3C.s.o(.rodata); build/asm/main_80145D3C.s.o(.data); }
    .main_80145D3C_bss (NOLOAD) : { build/asm/main_80145D3C.s.o(.bss); }
    .main_80145DE4 0x80145DE4 : AT(0x000B09E4) { FILL(0x00000000); build/asm/main_80145DE4.s.o(.text); build/asm/main_80145DE4.s.o(.rodata); build/asm/main_80145DE4.s.o(.data); }
    .main_80145DE4_bss (NOLOAD) : { build/asm/main_80145DE4.s.o(.bss); }
    .main_80145F04 0x80145F04 : AT(0x000B0B04) { FILL(0x00000000); build/asm/main_80145F04.s.o(.text); build/asm/main_80145F04.s.o(.rodata); build/asm/main_80145F04.s.o(.data); }
    .main_80145F04_bss (NOLOAD) : { build/asm/main_80145F04.s.o(.bss); }
    .main_80145FD4 0x80145FD4 : AT(0x000B0BD4) { FILL(0x00000000); build/asm/main_80145FD4.s.o(.text); build/asm/main_80145FD4.s.o(.rodata); build/asm/main_80145FD4.s.o(.data); }
    .main_80145FD4_bss (NOLOAD) : { build/asm/main_80145FD4.s.o(.bss); }
    .main_80146164 0x80146164 : AT(0x000B0D64) { FILL(0x00000000); build/asm/main_80146164.s.o(.text); build/asm/main_80146164.s.o(.rodata); build/asm/main_80146164.s.o(.data); }
    .main_80146164_bss (NOLOAD) : { build/asm/main_80146164.s.o(.bss); }
    .main_801461FC 0x801461FC : AT(0x000B0DFC) { FILL(0x00000000); build/asm/main_801461FC.s.o(.text); build/asm/main_801461FC.s.o(.rodata); build/asm/main_801461FC.s.o(.data); }
    .main_801461FC_bss (NOLOAD) : { build/asm/main_801461FC.s.o(.bss); }
    .main_80146214 0x80146214 : AT(0x000B0E14) { FILL(0x00000000); build/asm/main_80146214.s.o(.text); build/asm/main_80146214.s.o(.rodata); build/asm/main_80146214.s.o(.data); }
    .main_80146214_bss (NOLOAD) : { build/asm/main_80146214.s.o(.bss); }
    .main_8014625C 0x8014625C : AT(0x000B0E5C) { FILL(0x00000000); build/asm/main_8014625C.s.o(.text); build/asm/main_8014625C.s.o(.rodata); build/asm/main_8014625C.s.o(.data); }
    .main_8014625C_bss (NOLOAD) : { build/asm/main_8014625C.s.o(.bss); }
    .main_80146344 0x80146344 : AT(0x000B0F44) { FILL(0x00000000); build/asm/main_80146344.s.o(.text); build/asm/main_80146344.s.o(.rodata); build/asm/main_80146344.s.o(.data); }
    .main_80146344_bss (NOLOAD) : { build/asm/main_80146344.s.o(.bss); }
    .main_801463AC 0x801463AC : AT(0x000B0FAC) { FILL(0x00000000); build/asm/main_801463AC.s.o(.text); build/asm/main_801463AC.s.o(.rodata); build/asm/main_801463AC.s.o(.data); }
    .main_801463AC_bss (NOLOAD) : { build/asm/main_801463AC.s.o(.bss); }
    .main_801463BC 0x801463BC : AT(0x000B0FBC) { FILL(0x00000000); build/asm/main_801463BC.s.o(.text); build/asm/main_801463BC.s.o(.rodata); build/asm/main_801463BC.s.o(.data); }
    .main_801463BC_bss (NOLOAD) : { build/asm/main_801463BC.s.o(.bss); }
    .main_80146404 0x80146404 : AT(0x000B1004) { FILL(0x00000000); build/asm/main_80146404.s.o(.text); build/asm/main_80146404.s.o(.rodata); build/asm/main_80146404.s.o(.data); }
    .main_80146404_bss (NOLOAD) : { build/asm/main_80146404.s.o(.bss); }
    .main_80146444 0x80146444 : AT(0x000B1044) { FILL(0x00000000); build/asm/main_80146444.s.o(.text); build/asm/main_80146444.s.o(.rodata); build/asm/main_80146444.s.o(.data); }
    .main_80146444_bss (NOLOAD) : { build/asm/main_80146444.s.o(.bss); }
    .main_80146494 0x80146494 : AT(0x000B1094) { FILL(0x00000000); build/asm/main_80146494.s.o(.text); build/asm/main_80146494.s.o(.rodata); build/asm/main_80146494.s.o(.data); }
    .main_80146494_bss (NOLOAD) : { build/asm/main_80146494.s.o(.bss); }
    .main_8014659C 0x8014659C : AT(0x000B119C) { FILL(0x00000000); build/asm/main_8014659C.s.o(.text); build/asm/main_8014659C.s.o(.rodata); build/asm/main_8014659C.s.o(.data); }
    .main_8014659C_bss (NOLOAD) : { build/asm/main_8014659C.s.o(.bss); }
    .main_801465F4 0x801465F4 : AT(0x000B11F4) { FILL(0x00000000); build/asm/main_801465F4.s.o(.text); build/asm/main_801465F4.s.o(.rodata); build/asm/main_801465F4.s.o(.data); }
    .main_801465F4_bss (NOLOAD) : { build/asm/main_801465F4.s.o(.bss); }
    .main_80146674 0x80146674 : AT(0x000B1274) { FILL(0x00000000); build/asm/main_80146674.s.o(.text); build/asm/main_80146674.s.o(.rodata); build/asm/main_80146674.s.o(.data); }
    .main_80146674_bss (NOLOAD) : { build/asm/main_80146674.s.o(.bss); }
    .main_8014668C 0x8014668C : AT(0x000B128C) { FILL(0x00000000); build/asm/main_8014668C.s.o(.text); build/asm/main_8014668C.s.o(.rodata); build/asm/main_8014668C.s.o(.data); }
    .main_8014668C_bss (NOLOAD) : { build/asm/main_8014668C.s.o(.bss); }
    .main_80146874 0x80146874 : AT(0x000B1474) { FILL(0x00000000); build/asm/main_80146874.s.o(.text); build/asm/main_80146874.s.o(.rodata); build/asm/main_80146874.s.o(.data); }
    .main_80146874_bss (NOLOAD) : { build/asm/main_80146874.s.o(.bss); }
    .main_8014692C 0x8014692C : AT(0x000B152C) { FILL(0x00000000); build/asm/main_8014692C.s.o(.text); build/asm/main_8014692C.s.o(.rodata); build/asm/main_8014692C.s.o(.data); }
    .main_8014692C_bss (NOLOAD) : { build/asm/main_8014692C.s.o(.bss); }
    .main_80146AD4 0x80146AD4 : AT(0x000B16D4) { FILL(0x00000000); build/asm/main_80146AD4.s.o(.text); build/asm/main_80146AD4.s.o(.rodata); build/asm/main_80146AD4.s.o(.data); }
    .main_80146AD4_bss (NOLOAD) : { build/asm/main_80146AD4.s.o(.bss); }
    .main_80146C1C 0x80146C1C : AT(0x000B181C) { FILL(0x00000000); build/asm/main_80146C1C.s.o(.text); build/asm/main_80146C1C.s.o(.rodata); build/asm/main_80146C1C.s.o(.data); }
    .main_80146C1C_bss (NOLOAD) : { build/asm/main_80146C1C.s.o(.bss); }
    .main_80146D1C 0x80146D1C : AT(0x000B191C) { FILL(0x00000000); build/asm/main_80146D1C.s.o(.text); build/asm/main_80146D1C.s.o(.rodata); build/asm/main_80146D1C.s.o(.data); }
    .main_80146D1C_bss (NOLOAD) : { build/asm/main_80146D1C.s.o(.bss); }
    .main_80146F0C 0x80146F0C : AT(0x000B1B0C) { FILL(0x00000000); build/asm/main_80146F0C.s.o(.text); build/asm/main_80146F0C.s.o(.rodata); build/asm/main_80146F0C.s.o(.data); }
    .main_80146F0C_bss (NOLOAD) : { build/asm/main_80146F0C.s.o(.bss); }
    .main_80147074 0x80147074 : AT(0x000B1C74) { FILL(0x00000000); build/asm/main_80147074.s.o(.text); build/asm/main_80147074.s.o(.rodata); build/asm/main_80147074.s.o(.data); }
    .main_80147074_bss (NOLOAD) : { build/asm/main_80147074.s.o(.bss); }
    .main_80147104 0x80147104 : AT(0x000B1D04) { FILL(0x00000000); build/asm/main_80147104.s.o(.text); build/asm/main_80147104.s.o(.rodata); build/asm/main_80147104.s.o(.data); }
    .main_80147104_bss (NOLOAD) : { build/asm/main_80147104.s.o(.bss); }
    .main_8014716C 0x8014716C : AT(0x000B1D6C) { FILL(0x00000000); build/asm/main_8014716C.s.o(.text); build/asm/main_8014716C.s.o(.rodata); build/asm/main_8014716C.s.o(.data); }
    .main_8014716C_bss (NOLOAD) : { build/asm/main_8014716C.s.o(.bss); }
    .main_801472DC 0x801472DC : AT(0x000B1EDC) { FILL(0x00000000); build/asm/main_801472DC.s.o(.text); build/asm/main_801472DC.s.o(.rodata); build/asm/main_801472DC.s.o(.data); }
    .main_801472DC_bss (NOLOAD) : { build/asm/main_801472DC.s.o(.bss); }
    .main_80147384 0x80147384 : AT(0x000B1F84) { FILL(0x00000000); build/asm/main_80147384.s.o(.text); build/asm/main_80147384.s.o(.rodata); build/asm/main_80147384.s.o(.data); }
    .main_80147384_bss (NOLOAD) : { build/asm/main_80147384.s.o(.bss); }
    .main_801473EC 0x801473EC : AT(0x000B1FEC) { FILL(0x00000000); build/asm/main_801473EC.s.o(.text); build/asm/main_801473EC.s.o(.rodata); build/asm/main_801473EC.s.o(.data); }
    .main_801473EC_bss (NOLOAD) : { build/asm/main_801473EC.s.o(.bss); }
    .main_8014742C 0x8014742C : AT(0x000B202C) { FILL(0x00000000); build/asm/main_8014742C.s.o(.text); build/asm/main_8014742C.s.o(.rodata); build/asm/main_8014742C.s.o(.data); }
    .main_8014742C_bss (NOLOAD) : { build/asm/main_8014742C.s.o(.bss); }
    .main_80147528 0x80147528 : AT(0x000B2128) { FILL(0x00000000); build/asm/main_80147528.s.o(.text); build/asm/main_80147528.s.o(.rodata); build/asm/main_80147528.s.o(.data); }
    .main_80147528_bss (NOLOAD) : { build/asm/main_80147528.s.o(.bss); }
    .main_80147654 0x80147654 : AT(0x000B2254) { FILL(0x00000000); build/asm/main_80147654.s.o(.text); build/asm/main_80147654.s.o(.rodata); build/asm/main_80147654.s.o(.data); }
    .main_80147654_bss (NOLOAD) : { build/asm/main_80147654.s.o(.bss); }
    .main_801476C4 0x801476C4 : AT(0x000B22C4) { FILL(0x00000000); build/asm/main_801476C4.s.o(.text); build/asm/main_801476C4.s.o(.rodata); build/asm/main_801476C4.s.o(.data); }
    .main_801476C4_bss (NOLOAD) : { build/asm/main_801476C4.s.o(.bss); }
    .main_801478D8 0x801478D8 : AT(0x000B24D8) { FILL(0x00000000); build/asm/main_801478D8.s.o(.text); build/asm/main_801478D8.s.o(.rodata); build/asm/main_801478D8.s.o(.data); }
    .main_801478D8_bss (NOLOAD) : { build/asm/main_801478D8.s.o(.bss); }
    .main_80147ADC 0x80147ADC : AT(0x000B26DC) { FILL(0x00000000); build/asm/main_80147ADC.s.o(.text); build/asm/main_80147ADC.s.o(.rodata); build/asm/main_80147ADC.s.o(.data); }
    .main_80147ADC_bss (NOLOAD) : { build/asm/main_80147ADC.s.o(.bss); }
    .main_80147B6C 0x80147B6C : AT(0x000B276C) { FILL(0x00000000); build/asm/main_80147B6C.s.o(.text); build/asm/main_80147B6C.s.o(.rodata); build/asm/main_80147B6C.s.o(.data); }
    .main_80147B6C_bss (NOLOAD) : { build/asm/main_80147B6C.s.o(.bss); }
    .main_80147DB4 0x80147DB4 : AT(0x000B29B4) { FILL(0x00000000); build/asm/main_80147DB4.s.o(.text); build/asm/main_80147DB4.s.o(.rodata); build/asm/main_80147DB4.s.o(.data); }
    .main_80147DB4_bss (NOLOAD) : { build/asm/main_80147DB4.s.o(.bss); }
    .main_80147FFC 0x80147FFC : AT(0x000B2BFC) { FILL(0x00000000); build/asm/main_80147FFC.s.o(.text); build/asm/main_80147FFC.s.o(.rodata); build/asm/main_80147FFC.s.o(.data); }
    .main_80147FFC_bss (NOLOAD) : { build/asm/main_80147FFC.s.o(.bss); }
    .main_80148244 0x80148244 : AT(0x000B2E44) { FILL(0x00000000); build/asm/main_80148244.s.o(.text); build/asm/main_80148244.s.o(.rodata); build/asm/main_80148244.s.o(.data); }
    .main_80148244_bss (NOLOAD) : { build/asm/main_80148244.s.o(.bss); }
    .main_80148494 0x80148494 : AT(0x000B3094) { FILL(0x00000000); build/asm/main_80148494.s.o(.text); build/asm/main_80148494.s.o(.rodata); build/asm/main_80148494.s.o(.data); }
    .main_80148494_bss (NOLOAD) : { build/asm/main_80148494.s.o(.bss); }
    .main_80148524 0x80148524 : AT(0x000B3124) { FILL(0x00000000); build/asm/main_80148524.s.o(.text); build/asm/main_80148524.s.o(.rodata); build/asm/main_80148524.s.o(.data); }
    .main_80148524_bss (NOLOAD) : { build/asm/main_80148524.s.o(.bss); }
    .main_80148954 0x80148954 : AT(0x000B3554) { FILL(0x00000000); build/asm/main_80148954.s.o(.text); build/asm/main_80148954.s.o(.rodata); build/asm/main_80148954.s.o(.data); }
    .main_80148954_bss (NOLOAD) : { build/asm/main_80148954.s.o(.bss); }
    .main_80148A54 0x80148A54 : AT(0x000B3654) { FILL(0x00000000); build/asm/main_80148A54.s.o(.text); build/asm/main_80148A54.s.o(.rodata); build/asm/main_80148A54.s.o(.data); }
    .main_80148A54_bss (NOLOAD) : { build/asm/main_80148A54.s.o(.bss); }
    .main_80148B34 0x80148B34 : AT(0x000B3734) { FILL(0x00000000); build/asm/main_80148B34.s.o(.text); build/asm/main_80148B34.s.o(.rodata); build/asm/main_80148B34.s.o(.data); }
    .main_80148B34_bss (NOLOAD) : { build/asm/main_80148B34.s.o(.bss); }
    .main_80148BD4 0x80148BD4 : AT(0x000B37D4) { FILL(0x00000000); build/asm/main_80148BD4.s.o(.text); build/asm/main_80148BD4.s.o(.rodata); build/asm/main_80148BD4.s.o(.data); }
    .main_80148BD4_bss (NOLOAD) : { build/asm/main_80148BD4.s.o(.bss); }
    .main_80148C68 0x80148C68 : AT(0x000B3868) { FILL(0x00000000); build/asm/main_80148C68.s.o(.text); build/asm/main_80148C68.s.o(.rodata); build/asm/main_80148C68.s.o(.data); }
    .main_80148C68_bss (NOLOAD) : { build/asm/main_80148C68.s.o(.bss); }
    .main_801491FC 0x801491FC : AT(0x000B3DFC) { FILL(0x00000000); build/asm/main_801491FC.s.o(.text); build/asm/main_801491FC.s.o(.rodata); build/asm/main_801491FC.s.o(.data); }
    .main_801491FC_bss (NOLOAD) : { build/asm/main_801491FC.s.o(.bss); }
    .main_801492F4 0x801492F4 : AT(0x000B3EF4) { FILL(0x00000000); build/asm/main_801492F4.s.o(.text); build/asm/main_801492F4.s.o(.rodata); build/asm/main_801492F4.s.o(.data); }
    .main_801492F4_bss (NOLOAD) : { build/asm/main_801492F4.s.o(.bss); }
    .main_801494DC 0x801494DC : AT(0x000B40DC) { FILL(0x00000000); build/asm/main_801494DC.s.o(.text); build/asm/main_801494DC.s.o(.rodata); build/asm/main_801494DC.s.o(.data); }
    .main_801494DC_bss (NOLOAD) : { build/asm/main_801494DC.s.o(.bss); }
    .main_80149544 0x80149544 : AT(0x000B4144) { FILL(0x00000000); build/asm/main_80149544.s.o(.text); build/asm/main_80149544.s.o(.rodata); build/asm/main_80149544.s.o(.data); }
    .main_80149544_bss (NOLOAD) : { build/asm/main_80149544.s.o(.bss); }
    .main_80149B14 0x80149B14 : AT(0x000B4714) { FILL(0x00000000); build/asm/main_80149B14.s.o(.text); build/asm/main_80149B14.s.o(.rodata); build/asm/main_80149B14.s.o(.data); }
    .main_80149B14_bss (NOLOAD) : { build/asm/main_80149B14.s.o(.bss); }
    .main_8014A5EC 0x8014A5EC : AT(0x000B51EC) { FILL(0x00000000); build/asm/main_8014A5EC.s.o(.text); build/asm/main_8014A5EC.s.o(.rodata); build/asm/main_8014A5EC.s.o(.data); }
    .main_8014A5EC_bss (NOLOAD) : { build/asm/main_8014A5EC.s.o(.bss); }
    .main_8014AAB4 0x8014AAB4 : AT(0x000B56B4) { FILL(0x00000000); build/asm/main_8014AAB4.s.o(.text); build/asm/main_8014AAB4.s.o(.rodata); build/asm/main_8014AAB4.s.o(.data); }
    .main_8014AAB4_bss (NOLOAD) : { build/asm/main_8014AAB4.s.o(.bss); }
    .main_8014AB14 0x8014AB14 : AT(0x000B5714) { FILL(0x00000000); build/asm/main_8014AB14.s.o(.text); build/asm/main_8014AB14.s.o(.rodata); build/asm/main_8014AB14.s.o(.data); }
    .main_8014AB14_bss (NOLOAD) : { build/asm/main_8014AB14.s.o(.bss); }
    .main_8014AB54 0x8014AB54 : AT(0x000B5754) { FILL(0x00000000); build/asm/main_8014AB54.s.o(.text); build/asm/main_8014AB54.s.o(.rodata); build/asm/main_8014AB54.s.o(.data); }
    .main_8014AB54_bss (NOLOAD) : { build/asm/main_8014AB54.s.o(.bss); }
    .main_8014ABB4 0x8014ABB4 : AT(0x000B57B4) { FILL(0x00000000); build/asm/main_8014ABB4.s.o(.text); build/asm/main_8014ABB4.s.o(.rodata); build/asm/main_8014ABB4.s.o(.data); }
    .main_8014ABB4_bss (NOLOAD) : { build/asm/main_8014ABB4.s.o(.bss); }
    .main_8014ABF4 0x8014ABF4 : AT(0x000B57F4) { FILL(0x00000000); build/asm/main_8014ABF4.s.o(.text); build/asm/main_8014ABF4.s.o(.rodata); build/asm/main_8014ABF4.s.o(.data); }
    .main_8014ABF4_bss (NOLOAD) : { build/asm/main_8014ABF4.s.o(.bss); }
    .main_8014AD74 0x8014AD74 : AT(0x000B5974) { FILL(0x00000000); build/asm/main_8014AD74.s.o(.text); build/asm/main_8014AD74.s.o(.rodata); build/asm/main_8014AD74.s.o(.data); }
    .main_8014AD74_bss (NOLOAD) : { build/asm/main_8014AD74.s.o(.bss); }
    .main_8014AFC4 0x8014AFC4 : AT(0x000B5BC4) { FILL(0x00000000); build/asm/main_8014AFC4.s.o(.text); build/asm/main_8014AFC4.s.o(.rodata); build/asm/main_8014AFC4.s.o(.data); }
    .main_8014AFC4_bss (NOLOAD) : { build/asm/main_8014AFC4.s.o(.bss); }
    .main_8014B27C 0x8014B27C : AT(0x000B5E7C) { FILL(0x00000000); build/asm/main_8014B27C.s.o(.text); build/asm/main_8014B27C.s.o(.rodata); build/asm/main_8014B27C.s.o(.data); }
    .main_8014B27C_bss (NOLOAD) : { build/asm/main_8014B27C.s.o(.bss); }
    .main_8014B714 0x8014B714 : AT(0x000B6314) { FILL(0x00000000); build/asm/main_8014B714.s.o(.text); build/asm/main_8014B714.s.o(.rodata); build/asm/main_8014B714.s.o(.data); }
    .main_8014B714_bss (NOLOAD) : { build/asm/main_8014B714.s.o(.bss); }
    .main_8014B77C 0x8014B77C : AT(0x000B637C) { build/asm/data/main_8014B77C.bin.o(.data); }
    .main_8014BA7C 0x8014BA7C : AT(0x000B667C) { FILL(0x00000000); build/asm/main_8014BA7C.s.o(.text); build/asm/main_8014BA7C.s.o(.rodata); build/asm/main_8014BA7C.s.o(.data); }
    .main_8014BA7C_bss (NOLOAD) : { build/asm/main_8014BA7C.s.o(.bss); }
    .main_8014BBF4 0x8014BBF4 : AT(0x000B67F4) { FILL(0x00000000); build/asm/main_8014BBF4.s.o(.text); build/asm/main_8014BBF4.s.o(.rodata); build/asm/main_8014BBF4.s.o(.data); }
    .main_8014BBF4_bss (NOLOAD) : { build/asm/main_8014BBF4.s.o(.bss); }
    .main_8014BD4C 0x8014BD4C : AT(0x000B694C) { FILL(0x00000000); build/asm/main_8014BD4C.s.o(.text); build/asm/main_8014BD4C.s.o(.rodata); build/asm/main_8014BD4C.s.o(.data); }
    .main_8014BD4C_bss (NOLOAD) : { build/asm/main_8014BD4C.s.o(.bss); }
    .main_8014BDBC 0x8014BDBC : AT(0x000B69BC) { FILL(0x00000000); build/asm/main_8014BDBC.s.o(.text); build/asm/main_8014BDBC.s.o(.rodata); build/asm/main_8014BDBC.s.o(.data); }
    .main_8014BDBC_bss (NOLOAD) : { build/asm/main_8014BDBC.s.o(.bss); }
    .main_8014BEDC 0x8014BEDC : AT(0x000B6ADC) { FILL(0x00000000); build/asm/main_8014BEDC.s.o(.text); build/asm/main_8014BEDC.s.o(.rodata); build/asm/main_8014BEDC.s.o(.data); }
    .main_8014BEDC_bss (NOLOAD) : { build/asm/main_8014BEDC.s.o(.bss); }
    .main_8014C21C 0x8014C21C : AT(0x000B6E1C) { FILL(0x00000000); build/asm/main_8014C21C.s.o(.text); build/asm/main_8014C21C.s.o(.rodata); build/asm/main_8014C21C.s.o(.data); }
    .main_8014C21C_bss (NOLOAD) : { build/asm/main_8014C21C.s.o(.bss); }
    .main_8014C464 0x8014C464 : AT(0x000B7064) { FILL(0x00000000); build/asm/main_8014C464.s.o(.text); build/asm/main_8014C464.s.o(.rodata); build/asm/main_8014C464.s.o(.data); }
    .main_8014C464_bss (NOLOAD) : { build/asm/main_8014C464.s.o(.bss); }
    .main_8014C58C 0x8014C58C : AT(0x000B718C) { FILL(0x00000000); build/asm/main_8014C58C.s.o(.text); build/asm/main_8014C58C.s.o(.rodata); build/asm/main_8014C58C.s.o(.data); }
    .main_8014C58C_bss (NOLOAD) : { build/asm/main_8014C58C.s.o(.bss); }
    .main_8014C634 0x8014C634 : AT(0x000B7234) { FILL(0x00000000); build/asm/main_8014C634.s.o(.text); build/asm/main_8014C634.s.o(.rodata); build/asm/main_8014C634.s.o(.data); }
    .main_8014C634_bss (NOLOAD) : { build/asm/main_8014C634.s.o(.bss); }
    .main_8014CA04 0x8014CA04 : AT(0x000B7604) { FILL(0x00000000); build/asm/main_8014CA04.s.o(.text); build/asm/main_8014CA04.s.o(.rodata); build/asm/main_8014CA04.s.o(.data); }
    .main_8014CA04_bss (NOLOAD) : { build/asm/main_8014CA04.s.o(.bss); }
    .main_8014CA74 0x8014CA74 : AT(0x000B7674) { FILL(0x00000000); build/asm/main_8014CA74.s.o(.text); build/asm/main_8014CA74.s.o(.rodata); build/asm/main_8014CA74.s.o(.data); }
    .main_8014CA74_bss (NOLOAD) : { build/asm/main_8014CA74.s.o(.bss); }
    .main_8014CF4C 0x8014CF4C : AT(0x000B7B4C) { FILL(0x00000000); build/asm/main_8014CF4C.s.o(.text); build/asm/main_8014CF4C.s.o(.rodata); build/asm/main_8014CF4C.s.o(.data); }
    .main_8014CF4C_bss (NOLOAD) : { build/asm/main_8014CF4C.s.o(.bss); }
    .main_8014D0AC 0x8014D0AC : AT(0x000B7CAC) { FILL(0x00000000); build/asm/main_8014D0AC.s.o(.text); build/asm/main_8014D0AC.s.o(.rodata); build/asm/main_8014D0AC.s.o(.data); }
    .main_8014D0AC_bss (NOLOAD) : { build/asm/main_8014D0AC.s.o(.bss); }
    .main_8014D3EC 0x8014D3EC : AT(0x000B7FEC) { FILL(0x00000000); build/asm/main_8014D3EC.s.o(.text); build/asm/main_8014D3EC.s.o(.rodata); build/asm/main_8014D3EC.s.o(.data); }
    .main_8014D3EC_bss (NOLOAD) : { build/asm/main_8014D3EC.s.o(.bss); }
    .main_8014D44C 0x8014D44C : AT(0x000B804C) { FILL(0x00000000); build/asm/main_8014D44C.s.o(.text); build/asm/main_8014D44C.s.o(.rodata); build/asm/main_8014D44C.s.o(.data); }
    .main_8014D44C_bss (NOLOAD) : { build/asm/main_8014D44C.s.o(.bss); }
    .main_8014D5E4 0x8014D5E4 : AT(0x000B81E4) { FILL(0x00000000); build/asm/main_8014D5E4.s.o(.text); build/asm/main_8014D5E4.s.o(.rodata); build/asm/main_8014D5E4.s.o(.data); }
    .main_8014D5E4_bss (NOLOAD) : { build/asm/main_8014D5E4.s.o(.bss); }
    .main_8014D624 0x8014D624 : AT(0x000B8224) { FILL(0x00000000); build/asm/main_8014D624.s.o(.text); build/asm/main_8014D624.s.o(.rodata); build/asm/main_8014D624.s.o(.data); }
    .main_8014D624_bss (NOLOAD) : { build/asm/main_8014D624.s.o(.bss); }
    .main_8014D664 0x8014D664 : AT(0x000B8264) { FILL(0x00000000); build/asm/main_8014D664.s.o(.text); build/asm/main_8014D664.s.o(.rodata); build/asm/main_8014D664.s.o(.data); }
    .main_8014D664_bss (NOLOAD) : { build/asm/main_8014D664.s.o(.bss); }
    .main_8014D6B4 0x8014D6B4 : AT(0x000B82B4) { FILL(0x00000000); build/asm/main_8014D6B4.s.o(.text); build/asm/main_8014D6B4.s.o(.rodata); build/asm/main_8014D6B4.s.o(.data); }
    .main_8014D6B4_bss (NOLOAD) : { build/asm/main_8014D6B4.s.o(.bss); }
    .main_8014D85C 0x8014D85C : AT(0x000B845C) { FILL(0x00000000); build/asm/main_8014D85C.s.o(.text); build/asm/main_8014D85C.s.o(.rodata); build/asm/main_8014D85C.s.o(.data); }
    .main_8014D85C_bss (NOLOAD) : { build/asm/main_8014D85C.s.o(.bss); }
    .main_8014E45C 0x8014E45C : AT(0x000B905C) { FILL(0x00000000); build/asm/main_8014E45C.s.o(.text); build/asm/main_8014E45C.s.o(.rodata); build/asm/main_8014E45C.s.o(.data); }
    .main_8014E45C_bss (NOLOAD) : { build/asm/main_8014E45C.s.o(.bss); }
    .main_8014E5B4 0x8014E5B4 : AT(0x000B91B4) { FILL(0x00000000); build/asm/main_8014E5B4.s.o(.text); build/asm/main_8014E5B4.s.o(.rodata); build/asm/main_8014E5B4.s.o(.data); }
    .main_8014E5B4_bss (NOLOAD) : { build/asm/main_8014E5B4.s.o(.bss); }
    .main_8014E6B4 0x8014E6B4 : AT(0x000B92B4) { build/asm/data/main_8014E6B4.bin.o(.data); }
    .main_8014E794 0x8014E794 : AT(0x000B9394) { build/asm/data/main_8014E794.bin.o(.data); }
    .main_8014E7CC 0x8014E7CC : AT(0x000B93CC) { FILL(0x00000000); build/asm/main_8014E7CC.s.o(.text); build/asm/main_8014E7CC.s.o(.rodata); build/asm/main_8014E7CC.s.o(.data); }
    .main_8014E7CC_bss (NOLOAD) : { build/asm/main_8014E7CC.s.o(.bss); }
    .main_8014E8C4 0x8014E8C4 : AT(0x000B94C4) { build/asm/data/main_8014E8C4.bin.o(.data); }
    .main_8014E8FC 0x8014E8FC : AT(0x000B94FC) { build/asm/data/main_8014E8FC.bin.o(.data); }
    .main_8014EA34 0x8014EA34 : AT(0x000B9634) { build/asm/data/main_8014EA34.bin.o(.data); }
    .main_8014EAC4 0x8014EAC4 : AT(0x000B96C4) { build/asm/data/main_8014EAC4.bin.o(.data); }
    .main_8014EB1C 0x8014EB1C : AT(0x000B971C) { build/asm/data/main_8014EB1C.bin.o(.data); }
    .main_8014EBD4 0x8014EBD4 : AT(0x000B97D4) { FILL(0x00000000); build/asm/main_8014EBD4.s.o(.text); build/asm/main_8014EBD4.s.o(.rodata); build/asm/main_8014EBD4.s.o(.data); }
    .main_8014EBD4_bss (NOLOAD) : { build/asm/main_8014EBD4.s.o(.bss); }
    .main_8014EC14 0x8014EC14 : AT(0x000B9814) { build/asm/data/main_8014EC14.bin.o(.data); }
    .main_8014EE34 0x8014EE34 : AT(0x000B9A34) { FILL(0x00000000); build/asm/main_8014EE34.s.o(.text); build/asm/main_8014EE34.s.o(.rodata); build/asm/main_8014EE34.s.o(.data); }
    .main_8014EE34_bss (NOLOAD) : { build/asm/main_8014EE34.s.o(.bss); }
    .main_8014F204 0x8014F204 : AT(0x000B9E04) { build/asm/data/main_8014F204.bin.o(.data); }
    .main_8014F32C 0x8014F32C : AT(0x000B9F2C) { FILL(0x00000000); build/asm/main_8014F32C.s.o(.text); build/asm/main_8014F32C.s.o(.rodata); build/asm/main_8014F32C.s.o(.data); }
    .main_8014F32C_bss (NOLOAD) : { build/asm/main_8014F32C.s.o(.bss); }
    .main_8014F534 0x8014F534 : AT(0x000BA134) { build/asm/data/main_8014F534.bin.o(.data); }
    .main_8014F690 0x8014F690 : AT(0x000BA290) { FILL(0x00000000); build/asm/main_8014F690.s.o(.text); build/asm/main_8014F690.s.o(.rodata); build/asm/main_8014F690.s.o(.data); }
    .main_8014F690_bss (NOLOAD) : { build/asm/main_8014F690.s.o(.bss); }
    .main_8014FA0C 0x8014FA0C : AT(0x000BA60C) { FILL(0x00000000); build/asm/main_8014FA0C.s.o(.text); build/asm/main_8014FA0C.s.o(.rodata); build/asm/main_8014FA0C.s.o(.data); }
    .main_8014FA0C_bss (NOLOAD) : { build/asm/main_8014FA0C.s.o(.bss); }
    .main_8014FB24 0x8014FB24 : AT(0x000BA724) { build/asm/data/main_8014FB24.bin.o(.data); }
    .main_8015035C 0x8015035C : AT(0x000BAF5C) { FILL(0x00000000); build/asm/main_8015035C.s.o(.text); build/asm/main_8015035C.s.o(.rodata); build/asm/main_8015035C.s.o(.data); }
    .main_8015035C_bss (NOLOAD) : { build/asm/main_8015035C.s.o(.bss); }
    .main_801506C0 0x801506C0 : AT(0x000BB2C0) { FILL(0x00000000); build/asm/main_801506C0.s.o(.text); build/asm/main_801506C0.s.o(.rodata); build/asm/main_801506C0.s.o(.data); }
    .main_801506C0_bss (NOLOAD) : { build/asm/main_801506C0.s.o(.bss); }
    .main_80150948 0x80150948 : AT(0x000BB548) { FILL(0x00000000); build/asm/main_80150948.s.o(.text); build/asm/main_80150948.s.o(.rodata); build/asm/main_80150948.s.o(.data); }
    .main_80150948_bss (NOLOAD) : { build/asm/main_80150948.s.o(.bss); }
    .main_80150BD0 0x80150BD0 : AT(0x000BB7D0) { build/asm/data/main_80150BD0.bin.o(.data); }
    .main_80150E58 0x80150E58 : AT(0x000BBA58) { build/asm/data/main_80150E58.bin.o(.data); }
    .main_801510E0 0x801510E0 : AT(0x000BBCE0) { FILL(0x00000000); build/asm/main_801510E0.s.o(.text); build/asm/main_801510E0.s.o(.rodata); build/asm/main_801510E0.s.o(.data); }
    .main_801510E0_bss (NOLOAD) : { build/asm/main_801510E0.s.o(.bss); }
    .main_80151378 0x80151378 : AT(0x000BBF78) { FILL(0x00000000); build/asm/main_80151378.s.o(.text); build/asm/main_80151378.s.o(.rodata); build/asm/main_80151378.s.o(.data); }
    .main_80151378_bss (NOLOAD) : { build/asm/main_80151378.s.o(.bss); }
    .main_80151510 0x80151510 : AT(0x000BC110) { FILL(0x00000000); build/asm/main_80151510.s.o(.text); build/asm/main_80151510.s.o(.rodata); build/asm/main_80151510.s.o(.data); }
    .main_80151510_bss (NOLOAD) : { build/asm/main_80151510.s.o(.bss); }
    .main_8015165C 0x8015165C : AT(0x000BC25C) { FILL(0x00000000); build/asm/main_8015165C.s.o(.text); build/asm/main_8015165C.s.o(.rodata); build/asm/main_8015165C.s.o(.data); }
    .main_8015165C_bss (NOLOAD) : { build/asm/main_8015165C.s.o(.bss); }
    .main_80151804 0x80151804 : AT(0x000BC404) { FILL(0x00000000); build/asm/main_80151804.s.o(.text); build/asm/main_80151804.s.o(.rodata); build/asm/main_80151804.s.o(.data); }
    .main_80151804_bss (NOLOAD) : { build/asm/main_80151804.s.o(.bss); }
    .main_80151A4C 0x80151A4C : AT(0x000BC64C) { build/asm/data/main_80151A4C.bin.o(.data); }
    .main_80151B44 0x80151B44 : AT(0x000BC744) { FILL(0x00000000); build/asm/main_80151B44.s.o(.text); build/asm/main_80151B44.s.o(.rodata); build/asm/main_80151B44.s.o(.data); }
    .main_80151B44_bss (NOLOAD) : { build/asm/main_80151B44.s.o(.bss); }
    .main_80151B9C 0x80151B9C : AT(0x000BC79C) { FILL(0x00000000); build/asm/main_80151B9C.s.o(.text); build/asm/main_80151B9C.s.o(.rodata); build/asm/main_80151B9C.s.o(.data); }
    .main_80151B9C_bss (NOLOAD) : { build/asm/main_80151B9C.s.o(.bss); }
    .main_80151E1C 0x80151E1C : AT(0x000BCA1C) { FILL(0x00000000); build/asm/main_80151E1C.s.o(.text); build/asm/main_80151E1C.s.o(.rodata); build/asm/main_80151E1C.s.o(.data); }
    .main_80151E1C_bss (NOLOAD) : { build/asm/main_80151E1C.s.o(.bss); }
    .main_80151E5C 0x80151E5C : AT(0x000BCA5C) { FILL(0x00000000); build/asm/main_80151E5C.s.o(.text); build/asm/main_80151E5C.s.o(.rodata); build/asm/main_80151E5C.s.o(.data); }
    .main_80151E5C_bss (NOLOAD) : { build/asm/main_80151E5C.s.o(.bss); }
    .main_80152B54 0x80152B54 : AT(0x000BD754) { build/asm/data/main_80152B54.bin.o(.data); }
    .main_80152BF4 0x80152BF4 : AT(0x000BD7F4) { FILL(0x00000000); build/asm/main_80152BF4.s.o(.text); build/asm/main_80152BF4.s.o(.rodata); build/asm/main_80152BF4.s.o(.data); }
    .main_80152BF4_bss (NOLOAD) : { build/asm/main_80152BF4.s.o(.bss); }
    .main_80152CC0 0x80152CC0 : AT(0x000BD8C0) { build/asm/data/main_80152CC0.bin.o(.data); }
    .main_801533EC 0x801533EC : AT(0x000BDFEC) { build/asm/data/main_801533EC.bin.o(.data); }
    .main_801555CC 0x801555CC : AT(0x000C01CC) { build/asm/data/main_801555CC.bin.o(.data); }
    .main_801562C0 0x801562C0 : AT(0x000C0EC0) { FILL(0x00000000); build/asm/main_801562C0.s.o(.text); build/asm/main_801562C0.s.o(.rodata); build/asm/main_801562C0.s.o(.data); }
    .main_801562C0_bss (NOLOAD) : { build/asm/main_801562C0.s.o(.bss); }
    .main_80156654 0x80156654 : AT(0x000C1254) { build/asm/data/main_80156654.bin.o(.data); }
    .main_80157BC4 0x80157BC4 : AT(0x000C27C4) { FILL(0x00000000); build/asm/main_80157BC4.s.o(.text); build/asm/main_80157BC4.s.o(.rodata); build/asm/main_80157BC4.s.o(.data); }
    .main_80157BC4_bss (NOLOAD) : { build/asm/main_80157BC4.s.o(.bss); }
    .main_80157BF0 0x80157BF0 : AT(0x000C27F0) { build/asm/data/main_80157BF0.bin.o(.data); }
    .main_80157E68 0x80157E68 : AT(0x000C2A68) { FILL(0x00000000); build/asm/main_80157E68.s.o(.text); build/asm/main_80157E68.s.o(.rodata); build/asm/main_80157E68.s.o(.data); }
    .main_80157E68_bss (NOLOAD) : { build/asm/main_80157E68.s.o(.bss); }
    .main_80157EE0 0x80157EE0 : AT(0x000C2AE0) { build/asm/data/main_80157EE0.bin.o(.data); }
    .main_80158474 0x80158474 : AT(0x000C3074) { build/asm/data/main_80158474.bin.o(.data); }
    .main_80158738 0x80158738 : AT(0x000C3338) { build/asm/data/main_80158738.bin.o(.data); }
    .main_80158E40 0x80158E40 : AT(0x000C3A40) { FILL(0x00000000); build/asm/main_80158E40.s.o(.text); build/asm/main_80158E40.s.o(.rodata); build/asm/main_80158E40.s.o(.data); }
    .main_80158E40_bss (NOLOAD) : { build/asm/main_80158E40.s.o(.bss); }
    .main_801596D4 0x801596D4 : AT(0x000C42D4) { build/asm/data/main_801596D4.bin.o(.data); }
    .main_80159FB4 0x80159FB4 : AT(0x000C4BB4) { build/asm/data/main_80159FB4.bin.o(.data); }
    .main_8015BFF8 0x8015BFF8 : AT(0x000C6BF8) { build/asm/data/main_8015BFF8.bin.o(.data); }
    .main_8015C358 0x8015C358 : AT(0x000C6F58) { FILL(0x00000000); build/asm/main_8015C358.s.o(.text); build/asm/main_8015C358.s.o(.rodata); build/asm/main_8015C358.s.o(.data); }
    .main_8015C358_bss (NOLOAD) : { build/asm/main_8015C358.s.o(.bss); }
    .main_8015C41C 0x8015C41C : AT(0x000C701C) { build/asm/data/main_8015C41C.bin.o(.data); }
    .main_8015CE8C 0x8015CE8C : AT(0x000C7A8C) { build/asm/data/main_8015CE8C.bin.o(.data); }
    .main_8015D80C 0x8015D80C : AT(0x000C840C) { build/asm/data/main_8015D80C.bin.o(.data); }
    .main_8015DD28 0x8015DD28 : AT(0x000C8928) { build/asm/data/main_8015DD28.bin.o(.data); }
    .main_801621B0 0x801621B0 : AT(0x000CCDB0) { build/asm/data/main_801621B0.bin.o(.data); }
    .main_801630C0 0x801630C0 : AT(0x000CDCC0) { FILL(0x00000000); build/asm/main_801630C0.s.o(.text); build/asm/main_801630C0.s.o(.rodata); build/asm/main_801630C0.s.o(.data); }
    .main_801630C0_bss (NOLOAD) : { build/asm/main_801630C0.s.o(.bss); }
    .main_801630D8 0x801630D8 : AT(0x000CDCD8) { build/asm/data/main_801630D8.bin.o(.data); }
    .main_801651B0 0x801651B0 : AT(0x000CFDB0) { FILL(0x00000000); build/asm/main_801651B0.s.o(.text); build/asm/main_801651B0.s.o(.rodata); build/asm/main_801651B0.s.o(.data); }
    .main_801651B0_bss (NOLOAD) : { build/asm/main_801651B0.s.o(.bss); }
    .main_801652C8 0x801652C8 : AT(0x000CFEC8) { build/asm/data/main_801652C8.bin.o(.data); }
    .main_801677C8 0x801677C8 : AT(0x000D23C8) { FILL(0x00000000); build/asm/main_801677C8.s.o(.text); build/asm/main_801677C8.s.o(.rodata); build/asm/main_801677C8.s.o(.data); }
    .main_801677C8_bss (NOLOAD) : { build/asm/main_801677C8.s.o(.bss); }
    .main_80167818 0x80167818 : AT(0x000D2418) { build/asm/data/main_80167818.bin.o(.data); }
    .main_80167944 0x80167944 : AT(0x000D2544) { FILL(0x00000000); build/asm/main_80167944.s.o(.text); build/asm/main_80167944.s.o(.rodata); build/asm/main_80167944.s.o(.data); }
    .main_80167944_bss (NOLOAD) : { build/asm/main_80167944.s.o(.bss); }
    .main_80167F20 0x80167F20 : AT(0x000D2B20) { build/asm/data/main_80167F20.bin.o(.data); }
    .main_80168338 0x80168338 : AT(0x000D2F38) { FILL(0x00000000); build/asm/main_80168338.s.o(.text); build/asm/main_80168338.s.o(.rodata); build/asm/main_80168338.s.o(.data); }
    .main_80168338_bss (NOLOAD) : { build/asm/main_80168338.s.o(.bss); }
    .main_80168464 0x80168464 : AT(0x000D3064) { build/asm/data/main_80168464.bin.o(.data); }
    .main_80168914 0x80168914 : AT(0x000D3514) { FILL(0x00000000); build/asm/main_80168914.s.o(.text); build/asm/main_80168914.s.o(.rodata); build/asm/main_80168914.s.o(.data); }
    .main_80168914_bss (NOLOAD) : { build/asm/main_80168914.s.o(.bss); }
    .main_80168D2C 0x80168D2C : AT(0x000D392C) { build/asm/data/main_80168D2C.bin.o(.data); }
    .main_80168E58 0x80168E58 : AT(0x000D3A58) { FILL(0x00000000); build/asm/main_80168E58.s.o(.text); build/asm/main_80168E58.s.o(.rodata); build/asm/main_80168E58.s.o(.data); }
    .main_80168E58_bss (NOLOAD) : { build/asm/main_80168E58.s.o(.bss); }
    .main_80168F84 0x80168F84 : AT(0x000D3B84) { build/asm/data/main_80168F84.bin.o(.data); }
    .main_8016B238 0x8016B238 : AT(0x000D5E38) { FILL(0x00000000); build/asm/main_8016B238.s.o(.text); build/asm/main_8016B238.s.o(.rodata); build/asm/main_8016B238.s.o(.data); }
    .main_8016B238_bss (NOLOAD) : { build/asm/main_8016B238.s.o(.bss); }
    .main_8016B26C 0x8016B26C : AT(0x000D5E6C) { build/asm/data/main_8016B26C.bin.o(.data); }
    .main_8016F3E0 0x8016F3E0 : AT(0x000D9FE0) { FILL(0x00000000); build/asm/main_8016F3E0.s.o(.text); build/asm/main_8016F3E0.s.o(.rodata); build/asm/main_8016F3E0.s.o(.data); }
    .main_8016F3E0_bss (NOLOAD) : { build/asm/main_8016F3E0.s.o(.bss); }
    .main_8016F414 0x8016F414 : AT(0x000DA014) { build/asm/data/main_8016F414.bin.o(.data); }
    .main_8016FBC0 0x8016FBC0 : AT(0x000DA7C0) { FILL(0x00000000); build/asm/main_8016FBC0.s.o(.text); build/asm/main_8016FBC0.s.o(.rodata); build/asm/main_8016FBC0.s.o(.data); }
    .main_8016FBC0_bss (NOLOAD) : { build/asm/main_8016FBC0.s.o(.bss); }
    .main_8016FBC4 0x8016FBC4 : AT(0x000DA7C4) { build/asm/data/main_8016FBC4.bin.o(.data); }
    .main_8016FF08 0x8016FF08 : AT(0x000DAB08) { FILL(0x00000000); build/asm/main_8016FF08.s.o(.text); build/asm/main_8016FF08.s.o(.rodata); build/asm/main_8016FF08.s.o(.data); }
    .main_8016FF08_bss (NOLOAD) : { build/asm/main_8016FF08.s.o(.bss); }
    .main_8016FF10 0x8016FF10 : AT(0x000DAB10) { build/asm/data/main_8016FF10.bin.o(.data); }
    .main_801702A8 0x801702A8 : AT(0x000DAEA8) { FILL(0x00000000); build/asm/main_801702A8.s.o(.text); build/asm/main_801702A8.s.o(.rodata); build/asm/main_801702A8.s.o(.data); }
    .main_801702A8_bss (NOLOAD) : { build/asm/main_801702A8.s.o(.bss); }
    .main_801702C8 0x801702C8 : AT(0x000DAEC8) { build/asm/data/main_801702C8.bin.o(.data); }
    .main_801703F4 0x801703F4 : AT(0x000DAFF4) { FILL(0x00000000); build/asm/main_801703F4.s.o(.text); build/asm/main_801703F4.s.o(.rodata); build/asm/main_801703F4.s.o(.data); }
    .main_801703F4_bss (NOLOAD) : { build/asm/main_801703F4.s.o(.bss); }
    .main_80170520 0x80170520 : AT(0x000DB120) { build/asm/data/main_80170520.bin.o(.data); }
    .main_801714E8 0x801714E8 : AT(0x000DC0E8) { FILL(0x00000000); build/asm/main_801714E8.s.o(.text); build/asm/main_801714E8.s.o(.rodata); build/asm/main_801714E8.s.o(.data); }
    .main_801714E8_bss (NOLOAD) : { build/asm/main_801714E8.s.o(.bss); }
    .main_801714F0 0x801714F0 : AT(0x000DC0F0) { build/asm/data/main_801714F0.bin.o(.data); }
    .main_80172B80 0x80172B80 : AT(0x000DD780) { FILL(0x00000000); build/asm/main_80172B80.s.o(.text); build/asm/main_80172B80.s.o(.rodata); build/asm/main_80172B80.s.o(.data); }
    .main_80172B80_bss (NOLOAD) : { build/asm/main_80172B80.s.o(.bss); }
    .main_80172C70 0x80172C70 : AT(0x000DD870) { build/asm/data/main_80172C70.bin.o(.data); }
    .main_80173824 0x80173824 : AT(0x000DE424) { FILL(0x00000000); build/asm/main_80173824.s.o(.text); build/asm/main_80173824.s.o(.rodata); build/asm/main_80173824.s.o(.data); }
    .main_80173824_bss (NOLOAD) : { build/asm/main_80173824.s.o(.bss); }
    .main_80173874 0x80173874 : AT(0x000DE474) { build/asm/data/main_80173874.bin.o(.data); }
    .main_80178E8C 0x80178E8C : AT(0x000E3A8C) { FILL(0x00000000); build/asm/main_80178E8C.s.o(.text); build/asm/main_80178E8C.s.o(.rodata); build/asm/main_80178E8C.s.o(.data); }
    .main_80178E8C_bss (NOLOAD) : { build/asm/main_80178E8C.s.o(.bss); }
    .main_80178E94 0x80178E94 : AT(0x000E3A94) { build/asm/data/main_80178E94.bin.o(.data); }
    .main_8017A778 0x8017A778 : AT(0x000E5378) { FILL(0x00000000); build/asm/main_8017A778.s.o(.text); build/asm/main_8017A778.s.o(.rodata); build/asm/main_8017A778.s.o(.data); }
    .main_8017A778_bss (NOLOAD) : { build/asm/main_8017A778.s.o(.bss); }
    .main_8017A77C 0x8017A77C : AT(0x000E537C) { build/asm/data/main_8017A77C.bin.o(.data); }
    .main_801826F8 0x801826F8 : AT(0x000ED2F8) { FILL(0x00000000); build/asm/main_801826F8.s.o(.text); build/asm/main_801826F8.s.o(.rodata); build/asm/main_801826F8.s.o(.data); }
    .main_801826F8_bss (NOLOAD) : { build/asm/main_801826F8.s.o(.bss); }
    .main_80182700 0x80182700 : AT(0x000ED300) { build/asm/data/main_80182700.bin.o(.data); }
    .main_801832A8 0x801832A8 : AT(0x000EDEA8) { FILL(0x00000000); build/asm/main_801832A8.s.o(.text); build/asm/main_801832A8.s.o(.rodata); build/asm/main_801832A8.s.o(.data); }
    .main_801832A8_bss (NOLOAD) : { build/asm/main_801832A8.s.o(.bss); }
    .main_801832C8 0x801832C8 : AT(0x000EDEC8) { build/asm/data/main_801832C8.bin.o(.data); }
    .main_801838E0 0x801838E0 : AT(0x000EE4E0) { FILL(0x00000000); build/asm/main_801838E0.s.o(.text); build/asm/main_801838E0.s.o(.rodata); build/asm/main_801838E0.s.o(.data); }
    .main_801838E0_bss (NOLOAD) : { build/asm/main_801838E0.s.o(.bss); }
    .main_801838F8 0x801838F8 : AT(0x000EE4F8) { build/asm/data/main_801838F8.bin.o(.data); }
    .main_80183CD8 0x80183CD8 : AT(0x000EE8D8) { build/asm/data/main_80183CD8.bin.o(.data); }
    .main_80184298 0x80184298 : AT(0x000EEE98) { build/asm/data/main_80184298.bin.o(.data); }
    .main_80184A00 0x80184A00 : AT(0x000EF600) { FILL(0x00000000); build/asm/main_80184A00.s.o(.text); build/asm/main_80184A00.s.o(.rodata); build/asm/main_80184A00.s.o(.data); }
    .main_80184A00_bss (NOLOAD) : { build/asm/main_80184A00.s.o(.bss); }
    .main_80184A08 0x80184A08 : AT(0x000EF608) { build/asm/data/main_80184A08.bin.o(.data); }
    .main_80184E3C 0x80184E3C : AT(0x000EFA3C) { build/asm/data/main_80184E3C.bin.o(.data); }
    .main_8018AD24 0x8018AD24 : AT(0x000F5924) { build/asm/data/main_8018AD24.bin.o(.data); }
    .main_8018AD8C 0x8018AD8C : AT(0x000F598C) { build/asm/data/main_8018AD8C.bin.o(.data); }
    .main_8018B24C 0x8018B24C : AT(0x000F5E4C) { build/asm/data/main_8018B24C.bin.o(.data); }
    .main_8018B5F8 0x8018B5F8 : AT(0x000F61F8) { build/asm/data/main_8018B5F8.bin.o(.data); }
    .main_8018BFE4 0x8018BFE4 : AT(0x000F6BE4) { build/asm/data/main_8018BFE4.bin.o(.data); }
    .main_8018C334 0x8018C334 : AT(0x000F6F34) { build/asm/data/main_8018C334.bin.o(.data); }
    .main_8018C3DC 0x8018C3DC : AT(0x000F6FDC) { FILL(0x00000000); build/asm/main_8018C3DC.s.o(.text); build/asm/main_8018C3DC.s.o(.rodata); build/asm/main_8018C3DC.s.o(.data); }
    .main_8018C3DC_bss (NOLOAD) : { build/asm/main_8018C3DC.s.o(.bss); }
    .main_8018CA6C 0x8018CA6C : AT(0x000F766C) { build/asm/data/main_8018CA6C.bin.o(.data); }
    .main_8018CE84 0x8018CE84 : AT(0x000F7A84) { build/asm/data/main_8018CE84.bin.o(.data); }
    .main_8018D084 0x8018D084 : AT(0x000F7C84) { build/asm/data/main_8018D084.bin.o(.data); }
    .main_8018DBAC 0x8018DBAC : AT(0x000F87AC) { build/asm/data/main_8018DBAC.bin.o(.data); }
    .main_8018E534 0x8018E534 : AT(0x000F9134) { build/asm/data/main_8018E534.bin.o(.data); }
    .main_8018F04C 0x8018F04C : AT(0x000F9C4C) { build/asm/data/main_8018F04C.bin.o(.data); }
    .main_8018F094 0x8018F094 : AT(0x000F9C94) { FILL(0x00000000); build/asm/main_8018F094.s.o(.text); build/asm/main_8018F094.s.o(.rodata); build/asm/main_8018F094.s.o(.data); }
    .main_8018F094_bss (NOLOAD) : { build/asm/main_8018F094.s.o(.bss); }
    .main_8018F0D4 0x8018F0D4 : AT(0x000F9CD4) { FILL(0x00000000); build/asm/main_8018F0D4.s.o(.text); build/asm/main_8018F0D4.s.o(.rodata); build/asm/main_8018F0D4.s.o(.data); }
    .main_8018F0D4_bss (NOLOAD) : { build/asm/main_8018F0D4.s.o(.bss); }
    .main_8018F134 0x8018F134 : AT(0x000F9D34) { build/asm/data/main_8018F134.bin.o(.data); }
    .main_8018F5A4 0x8018F5A4 : AT(0x000FA1A4) { FILL(0x00000000); build/asm/main_8018F5A4.s.o(.text); build/asm/main_8018F5A4.s.o(.rodata); build/asm/main_8018F5A4.s.o(.data); }
    .main_8018F5A4_bss (NOLOAD) : { build/asm/main_8018F5A4.s.o(.bss); }
    .main_8018F5DC 0x8018F5DC : AT(0x000FA1DC) { build/asm/data/main_8018F5DC.bin.o(.data); }
    .main_80190280 0x80190280 : AT(0x000FAE80) { build/asm/data/main_80190280.bin.o(.data); }
    .main_80191E04 0x80191E04 : AT(0x000FCA04) { build/asm/data/main_80191E04.bin.o(.data); }
    .assets 0x80496400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
