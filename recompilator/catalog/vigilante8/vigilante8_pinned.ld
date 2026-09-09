SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80125800 0x80125800 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80125800.s.o(.text); build/asm/main_80125800.s.o(.rodata); build/asm/main_80125800.s.o(.data); }
    .main_80125800_bss (NOLOAD) : { build/asm/main_80125800.s.o(.bss); }
    .main_80127D38 0x80127D38 : AT(0x00003538) { FILL(0x00000000); build/asm/main_80127D38.s.o(.text); build/asm/main_80127D38.s.o(.rodata); build/asm/main_80127D38.s.o(.data); }
    .main_80127D38_bss (NOLOAD) : { build/asm/main_80127D38.s.o(.bss); }
    .main_8015E404 0x8015E404 : AT(0x00039C04) { build/asm/data/main_8015E404.bin.o(.data); }
    .main_801606C0 0x801606C0 : AT(0x0003BEC0) { FILL(0x00000000); build/asm/main_801606C0.s.o(.text); build/asm/main_801606C0.s.o(.rodata); build/asm/main_801606C0.s.o(.data); }
    .main_801606C0_bss (NOLOAD) : { build/asm/main_801606C0.s.o(.bss); }
    .main_80163BB0 0x80163BB0 : AT(0x0003F3B0) { build/asm/data/main_80163BB0.bin.o(.data); }
    .main_80163D70 0x80163D70 : AT(0x0003F570) { FILL(0x00000000); build/asm/main_80163D70.s.o(.text); build/asm/main_80163D70.s.o(.rodata); build/asm/main_80163D70.s.o(.data); }
    .main_80163D70_bss (NOLOAD) : { build/asm/main_80163D70.s.o(.bss); }
    .main_801750B0 0x801750B0 : AT(0x000508B0) { build/asm/data/main_801750B0.bin.o(.data); }
    .main_80177954 0x80177954 : AT(0x00053154) { FILL(0x00000000); build/asm/main_80177954.s.o(.text); build/asm/main_80177954.s.o(.rodata); build/asm/main_80177954.s.o(.data); }
    .main_80177954_bss (NOLOAD) : { build/asm/main_80177954.s.o(.bss); }
    .main_8017798C 0x8017798C : AT(0x0005318C) { build/asm/data/main_8017798C.bin.o(.data); }
    .main_80177D34 0x80177D34 : AT(0x00053534) { FILL(0x00000000); build/asm/main_80177D34.s.o(.text); build/asm/main_80177D34.s.o(.rodata); build/asm/main_80177D34.s.o(.data); }
    .main_80177D34_bss (NOLOAD) : { build/asm/main_80177D34.s.o(.bss); }
    .main_80177D70 0x80177D70 : AT(0x00053570) { build/asm/data/main_80177D70.bin.o(.data); }
    .main_80178070 0x80178070 : AT(0x00053870) { FILL(0x00000000); build/asm/main_80178070.s.o(.text); build/asm/main_80178070.s.o(.rodata); build/asm/main_80178070.s.o(.data); }
    .main_80178070_bss (NOLOAD) : { build/asm/main_80178070.s.o(.bss); }
    .main_80178228 0x80178228 : AT(0x00053A28) { build/asm/data/main_80178228.bin.o(.data); }
    .main_80178574 0x80178574 : AT(0x00053D74) { FILL(0x00000000); build/asm/main_80178574.s.o(.text); build/asm/main_80178574.s.o(.rodata); build/asm/main_80178574.s.o(.data); }
    .main_80178574_bss (NOLOAD) : { build/asm/main_80178574.s.o(.bss); }
    .main_801786A4 0x801786A4 : AT(0x00053EA4) { build/asm/data/main_801786A4.bin.o(.data); }
    .main_80178B38 0x80178B38 : AT(0x00054338) { FILL(0x00000000); build/asm/main_80178B38.s.o(.text); build/asm/main_80178B38.s.o(.rodata); build/asm/main_80178B38.s.o(.data); }
    .main_80178B38_bss (NOLOAD) : { build/asm/main_80178B38.s.o(.bss); }
    .main_80178B94 0x80178B94 : AT(0x00054394) { build/asm/data/main_80178B94.bin.o(.data); }
    .main_801791F8 0x801791F8 : AT(0x000549F8) { FILL(0x00000000); build/asm/main_801791F8.s.o(.text); build/asm/main_801791F8.s.o(.rodata); build/asm/main_801791F8.s.o(.data); }
    .main_801791F8_bss (NOLOAD) : { build/asm/main_801791F8.s.o(.bss); }
    .main_8017943C 0x8017943C : AT(0x00054C3C) { build/asm/data/main_8017943C.bin.o(.data); }
    .main_8017A364 0x8017A364 : AT(0x00055B64) { FILL(0x00000000); build/asm/main_8017A364.s.o(.text); build/asm/main_8017A364.s.o(.rodata); build/asm/main_8017A364.s.o(.data); }
    .main_8017A364_bss (NOLOAD) : { build/asm/main_8017A364.s.o(.bss); }
    .main_8017A3F4 0x8017A3F4 : AT(0x00055BF4) { build/asm/data/main_8017A3F4.bin.o(.data); }
    .main_8017CA18 0x8017CA18 : AT(0x00058218) { FILL(0x00000000); build/asm/main_8017CA18.s.o(.text); build/asm/main_8017CA18.s.o(.rodata); build/asm/main_8017CA18.s.o(.data); }
    .main_8017CA18_bss (NOLOAD) : { build/asm/main_8017CA18.s.o(.bss); }
    .main_8017CA68 0x8017CA68 : AT(0x00058268) { build/asm/data/main_8017CA68.bin.o(.data); }
    .main_8017CAB0 0x8017CAB0 : AT(0x000582B0) { FILL(0x00000000); build/asm/main_8017CAB0.s.o(.text); build/asm/main_8017CAB0.s.o(.rodata); build/asm/main_8017CAB0.s.o(.data); }
    .main_8017CAB0_bss (NOLOAD) : { build/asm/main_8017CAB0.s.o(.bss); }
    .main_8017CBA4 0x8017CBA4 : AT(0x000583A4) { build/asm/data/main_8017CBA4.bin.o(.data); }
    .main_8017D958 0x8017D958 : AT(0x00059158) { FILL(0x00000000); build/asm/main_8017D958.s.o(.text); build/asm/main_8017D958.s.o(.rodata); build/asm/main_8017D958.s.o(.data); }
    .main_8017D958_bss (NOLOAD) : { build/asm/main_8017D958.s.o(.bss); }
    .main_8017D960 0x8017D960 : AT(0x00059160) { build/asm/data/main_8017D960.bin.o(.data); }
    .main_8017DF74 0x8017DF74 : AT(0x00059774) { FILL(0x00000000); build/asm/main_8017DF74.s.o(.text); build/asm/main_8017DF74.s.o(.rodata); build/asm/main_8017DF74.s.o(.data); }
    .main_8017DF74_bss (NOLOAD) : { build/asm/main_8017DF74.s.o(.bss); }
    .main_8017E124 0x8017E124 : AT(0x00059924) { build/asm/data/main_8017E124.bin.o(.data); }
    .main_8017E9D0 0x8017E9D0 : AT(0x0005A1D0) { FILL(0x00000000); build/asm/main_8017E9D0.s.o(.text); build/asm/main_8017E9D0.s.o(.rodata); build/asm/main_8017E9D0.s.o(.data); }
    .main_8017E9D0_bss (NOLOAD) : { build/asm/main_8017E9D0.s.o(.bss); }
    .main_8017EA0C 0x8017EA0C : AT(0x0005A20C) { build/asm/data/main_8017EA0C.bin.o(.data); }
    .main_8017FC7C 0x8017FC7C : AT(0x0005B47C) { FILL(0x00000000); build/asm/main_8017FC7C.s.o(.text); build/asm/main_8017FC7C.s.o(.rodata); build/asm/main_8017FC7C.s.o(.data); }
    .main_8017FC7C_bss (NOLOAD) : { build/asm/main_8017FC7C.s.o(.bss); }
    .main_8017FEA8 0x8017FEA8 : AT(0x0005B6A8) { build/asm/data/main_8017FEA8.bin.o(.data); }
    .main_8017FFCC 0x8017FFCC : AT(0x0005B7CC) { FILL(0x00000000); build/asm/main_8017FFCC.s.o(.text); build/asm/main_8017FFCC.s.o(.rodata); build/asm/main_8017FFCC.s.o(.data); }
    .main_8017FFCC_bss (NOLOAD) : { build/asm/main_8017FFCC.s.o(.bss); }
    .main_80180950 0x80180950 : AT(0x0005C150) { build/asm/data/main_80180950.bin.o(.data); }
    .main_80180970 0x80180970 : AT(0x0005C170) { FILL(0x00000000); build/asm/main_80180970.s.o(.text); build/asm/main_80180970.s.o(.rodata); build/asm/main_80180970.s.o(.data); }
    .main_80180970_bss (NOLOAD) : { build/asm/main_80180970.s.o(.bss); }
    .main_80180980 0x80180980 : AT(0x0005C180) { build/asm/data/main_80180980.bin.o(.data); }
    .main_801809A8 0x801809A8 : AT(0x0005C1A8) { FILL(0x00000000); build/asm/main_801809A8.s.o(.text); build/asm/main_801809A8.s.o(.rodata); build/asm/main_801809A8.s.o(.data); }
    .main_801809A8_bss (NOLOAD) : { build/asm/main_801809A8.s.o(.bss); }
    .main_801809E8 0x801809E8 : AT(0x0005C1E8) { build/asm/data/main_801809E8.bin.o(.data); }
    .main_80180AE8 0x80180AE8 : AT(0x0005C2E8) { FILL(0x00000000); build/asm/main_80180AE8.s.o(.text); build/asm/main_80180AE8.s.o(.rodata); build/asm/main_80180AE8.s.o(.data); }
    .main_80180AE8_bss (NOLOAD) : { build/asm/main_80180AE8.s.o(.bss); }
    .main_80180B10 0x80180B10 : AT(0x0005C310) { build/asm/data/main_80180B10.bin.o(.data); }
    .main_80180C50 0x80180C50 : AT(0x0005C450) { FILL(0x00000000); build/asm/main_80180C50.s.o(.text); build/asm/main_80180C50.s.o(.rodata); build/asm/main_80180C50.s.o(.data); }
    .main_80180C50_bss (NOLOAD) : { build/asm/main_80180C50.s.o(.bss); }
    .main_80180C80 0x80180C80 : AT(0x0005C480) { build/asm/data/main_80180C80.bin.o(.data); }
    .main_801863BC 0x801863BC : AT(0x00061BBC) { FILL(0x00000000); build/asm/main_801863BC.s.o(.text); build/asm/main_801863BC.s.o(.rodata); build/asm/main_801863BC.s.o(.data); }
    .main_801863BC_bss (NOLOAD) : { build/asm/main_801863BC.s.o(.bss); }
    .main_80186410 0x80186410 : AT(0x00061C10) { build/asm/data/main_80186410.bin.o(.data); }
    .main_8018671C 0x8018671C : AT(0x00061F1C) { FILL(0x00000000); build/asm/main_8018671C.s.o(.text); build/asm/main_8018671C.s.o(.rodata); build/asm/main_8018671C.s.o(.data); }
    .main_8018671C_bss (NOLOAD) : { build/asm/main_8018671C.s.o(.bss); }
    .main_80186A2C 0x80186A2C : AT(0x0006222C) { build/asm/data/main_80186A2C.bin.o(.data); }
    .main_80187FB0 0x80187FB0 : AT(0x000637B0) { FILL(0x00000000); build/asm/main_80187FB0.s.o(.text); build/asm/main_80187FB0.s.o(.rodata); build/asm/main_80187FB0.s.o(.data); }
    .main_80187FB0_bss (NOLOAD) : { build/asm/main_80187FB0.s.o(.bss); }
    .main_8018811C 0x8018811C : AT(0x0006391C) { build/asm/data/main_8018811C.bin.o(.data); }
    .main_80189310 0x80189310 : AT(0x00064B10) { FILL(0x00000000); build/asm/main_80189310.s.o(.text); build/asm/main_80189310.s.o(.rodata); build/asm/main_80189310.s.o(.data); }
    .main_80189310_bss (NOLOAD) : { build/asm/main_80189310.s.o(.bss); }
    .main_80189598 0x80189598 : AT(0x00064D98) { build/asm/data/main_80189598.bin.o(.data); }
    .main_8018980C 0x8018980C : AT(0x0006500C) { FILL(0x00000000); build/asm/main_8018980C.s.o(.text); build/asm/main_8018980C.s.o(.rodata); build/asm/main_8018980C.s.o(.data); }
    .main_8018980C_bss (NOLOAD) : { build/asm/main_8018980C.s.o(.bss); }
    .main_80189820 0x80189820 : AT(0x00065020) { build/asm/data/main_80189820.bin.o(.data); }
    .main_80189F9C 0x80189F9C : AT(0x0006579C) { FILL(0x00000000); build/asm/main_80189F9C.s.o(.text); build/asm/main_80189F9C.s.o(.rodata); build/asm/main_80189F9C.s.o(.data); }
    .main_80189F9C_bss (NOLOAD) : { build/asm/main_80189F9C.s.o(.bss); }
    .main_8018A034 0x8018A034 : AT(0x00065834) { build/asm/data/main_8018A034.bin.o(.data); }
    .main_80193930 0x80193930 : AT(0x0006F130) { FILL(0x00000000); build/asm/main_80193930.s.o(.text); build/asm/main_80193930.s.o(.rodata); build/asm/main_80193930.s.o(.data); }
    .main_80193930_bss (NOLOAD) : { build/asm/main_80193930.s.o(.bss); }
    .main_80193970 0x80193970 : AT(0x0006F170) { build/asm/data/main_80193970.bin.o(.data); }
    .main_8019CAE8 0x8019CAE8 : AT(0x000782E8) { FILL(0x00000000); build/asm/main_8019CAE8.s.o(.text); build/asm/main_8019CAE8.s.o(.rodata); build/asm/main_8019CAE8.s.o(.data); }
    .main_8019CAE8_bss (NOLOAD) : { build/asm/main_8019CAE8.s.o(.bss); }
    .main_8019CAEC 0x8019CAEC : AT(0x000782EC) { build/asm/data/main_8019CAEC.bin.o(.data); }
    .main_801A2E98 0x801A2E98 : AT(0x0007E698) { FILL(0x00000000); build/asm/main_801A2E98.s.o(.text); build/asm/main_801A2E98.s.o(.rodata); build/asm/main_801A2E98.s.o(.data); }
    .main_801A2E98_bss (NOLOAD) : { build/asm/main_801A2E98.s.o(.bss); }
    .main_801A2EA0 0x801A2EA0 : AT(0x0007E6A0) { build/asm/data/main_801A2EA0.bin.o(.data); }
    .main_801CED34 0x801CED34 : AT(0x000AA534) { FILL(0x00000000); build/asm/main_801CED34.s.o(.text); build/asm/main_801CED34.s.o(.rodata); build/asm/main_801CED34.s.o(.data); }
    .main_801CED34_bss (NOLOAD) : { build/asm/main_801CED34.s.o(.bss); }
    .main_801CED38 0x801CED38 : AT(0x000AA538) { build/asm/data/main_801CED38.bin.o(.data); }
    .main_801E8218 0x801E8218 : AT(0x000C3A18) { FILL(0x00000000); build/asm/main_801E8218.s.o(.text); build/asm/main_801E8218.s.o(.rodata); build/asm/main_801E8218.s.o(.data); }
    .main_801E8218_bss (NOLOAD) : { build/asm/main_801E8218.s.o(.bss); }
    .main_801E8248 0x801E8248 : AT(0x000C3A48) { build/asm/data/main_801E8248.bin.o(.data); }
    .main_801E880C 0x801E880C : AT(0x000C400C) { FILL(0x00000000); build/asm/main_801E880C.s.o(.text); build/asm/main_801E880C.s.o(.rodata); build/asm/main_801E880C.s.o(.data); }
    .main_801E880C_bss (NOLOAD) : { build/asm/main_801E880C.s.o(.bss); }
    .main_801E8818 0x801E8818 : AT(0x000C4018) { build/asm/data/main_801E8818.bin.o(.data); }
    .main_801F1850 0x801F1850 : AT(0x000CD050) { FILL(0x00000000); build/asm/main_801F1850.s.o(.text); build/asm/main_801F1850.s.o(.rodata); build/asm/main_801F1850.s.o(.data); }
    .main_801F1850_bss (NOLOAD) : { build/asm/main_801F1850.s.o(.bss); }
    .main_801F1A9C 0x801F1A9C : AT(0x000CD29C) { build/asm/data/main_801F1A9C.bin.o(.data); }
    .main_801FEB28 0x801FEB28 : AT(0x000DA328) { FILL(0x00000000); build/asm/main_801FEB28.s.o(.text); build/asm/main_801FEB28.s.o(.rodata); build/asm/main_801FEB28.s.o(.data); }
    .main_801FEB28_bss (NOLOAD) : { build/asm/main_801FEB28.s.o(.bss); }
    .main_801FEB4C 0x801FEB4C : AT(0x000DA34C) { build/asm/data/main_801FEB4C.bin.o(.data); }
    .main_802029E8 0x802029E8 : AT(0x000DE1E8) { FILL(0x00000000); build/asm/main_802029E8.s.o(.text); build/asm/main_802029E8.s.o(.rodata); build/asm/main_802029E8.s.o(.data); }
    .main_802029E8_bss (NOLOAD) : { build/asm/main_802029E8.s.o(.bss); }
    .main_802029FC 0x802029FC : AT(0x000DE1FC) { build/asm/data/main_802029FC.bin.o(.data); }
    .main_8020F4B0 0x8020F4B0 : AT(0x000EACB0) { FILL(0x00000000); build/asm/main_8020F4B0.s.o(.text); build/asm/main_8020F4B0.s.o(.rodata); build/asm/main_8020F4B0.s.o(.data); }
    .main_8020F4B0_bss (NOLOAD) : { build/asm/main_8020F4B0.s.o(.bss); }
    .main_8020F538 0x8020F538 : AT(0x000EAD38) { build/asm/data/main_8020F538.bin.o(.data); }
    .assets 0x80525800 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
