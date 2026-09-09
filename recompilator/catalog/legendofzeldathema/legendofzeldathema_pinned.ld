SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80080000 0x80080000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80080000.s.o(.text); build/asm/main_80080000.s.o(.rodata); build/asm/main_80080000.s.o(.data); }
    .main_80080000_bss (NOLOAD) : { build/asm/main_80080000.s.o(.bss); }
    .main_80080150 0x80080150 : AT(0x00001150) { FILL(0x00000000); build/asm/main_80080150.s.o(.text); build/asm/main_80080150.s.o(.rodata); build/asm/main_80080150.s.o(.data); }
    .main_80080150_bss (NOLOAD) : { build/asm/main_80080150.s.o(.bss); }
    .main_80088BF4 0x80088BF4 : AT(0x00009BF4) { FILL(0x00000000); build/asm/main_80088BF4.s.o(.text); build/asm/main_80088BF4.s.o(.rodata); build/asm/main_80088BF4.s.o(.data); }
    .main_80088BF4_bss (NOLOAD) : { build/asm/main_80088BF4.s.o(.bss); }
    .main_8008CB44 0x8008CB44 : AT(0x0000DB44) { FILL(0x00000000); build/asm/main_8008CB44.s.o(.text); build/asm/main_8008CB44.s.o(.rodata); build/asm/main_8008CB44.s.o(.data); }
    .main_8008CB44_bss (NOLOAD) : { build/asm/main_8008CB44.s.o(.bss); }
    .main_8008FE44 0x8008FE44 : AT(0x00010E44) { FILL(0x00000000); build/asm/main_8008FE44.s.o(.text); build/asm/main_8008FE44.s.o(.rodata); build/asm/main_8008FE44.s.o(.data); }
    .main_8008FE44_bss (NOLOAD) : { build/asm/main_8008FE44.s.o(.bss); }
    .main_80093C04 0x80093C04 : AT(0x00014C04) { FILL(0x00000000); build/asm/main_80093C04.s.o(.text); build/asm/main_80093C04.s.o(.rodata); build/asm/main_80093C04.s.o(.data); }
    .main_80093C04_bss (NOLOAD) : { build/asm/main_80093C04.s.o(.bss); }
    .main_80096AE0 0x80096AE0 : AT(0x00017AE0) { FILL(0x00000000); build/asm/main_80096AE0.s.o(.text); build/asm/main_80096AE0.s.o(.rodata); build/asm/main_80096AE0.s.o(.data); }
    .main_80096AE0_bss (NOLOAD) : { build/asm/main_80096AE0.s.o(.bss); }
    .main_800982C8 0x800982C8 : AT(0x000192C8) { build/asm/data/main_800982C8.bin.o(.data); }
    .main_8009BF1C 0x8009BF1C : AT(0x0001CF1C) { FILL(0x00000000); build/asm/main_8009BF1C.s.o(.text); build/asm/main_8009BF1C.s.o(.rodata); build/asm/main_8009BF1C.s.o(.data); }
    .main_8009BF1C_bss (NOLOAD) : { build/asm/main_8009BF1C.s.o(.bss); }
    .main_8009F7B4 0x8009F7B4 : AT(0x000207B4) { build/asm/data/main_8009F7B4.bin.o(.data); }
    .main_800A0D10 0x800A0D10 : AT(0x00021D10) { FILL(0x00000000); build/asm/main_800A0D10.s.o(.text); build/asm/main_800A0D10.s.o(.rodata); build/asm/main_800A0D10.s.o(.data); }
    .main_800A0D10_bss (NOLOAD) : { build/asm/main_800A0D10.s.o(.bss); }
    .main_800A0E90 0x800A0E90 : AT(0x00021E90) { build/asm/data/main_800A0E90.bin.o(.data); }
    .main_800A4288 0x800A4288 : AT(0x00025288) { FILL(0x00000000); build/asm/main_800A4288.s.o(.text); build/asm/main_800A4288.s.o(.rodata); build/asm/main_800A4288.s.o(.data); }
    .main_800A4288_bss (NOLOAD) : { build/asm/main_800A4288.s.o(.bss); }
    .main_800A44D0 0x800A44D0 : AT(0x000254D0) { build/asm/data/main_800A44D0.bin.o(.data); }
    .main_800A45EC 0x800A45EC : AT(0x000255EC) { FILL(0x00000000); build/asm/main_800A45EC.s.o(.text); build/asm/main_800A45EC.s.o(.rodata); build/asm/main_800A45EC.s.o(.data); }
    .main_800A45EC_bss (NOLOAD) : { build/asm/main_800A45EC.s.o(.bss); }
    .main_800A46C8 0x800A46C8 : AT(0x000256C8) { build/asm/data/main_800A46C8.bin.o(.data); }
    .main_800A4B34 0x800A4B34 : AT(0x00025B34) { FILL(0x00000000); build/asm/main_800A4B34.s.o(.text); build/asm/main_800A4B34.s.o(.rodata); build/asm/main_800A4B34.s.o(.data); }
    .main_800A4B34_bss (NOLOAD) : { build/asm/main_800A4B34.s.o(.bss); }
    .main_800A4BFC 0x800A4BFC : AT(0x00025BFC) { build/asm/data/main_800A4BFC.bin.o(.data); }
    .main_800A5F24 0x800A5F24 : AT(0x00026F24) { FILL(0x00000000); build/asm/main_800A5F24.s.o(.text); build/asm/main_800A5F24.s.o(.rodata); build/asm/main_800A5F24.s.o(.data); }
    .main_800A5F24_bss (NOLOAD) : { build/asm/main_800A5F24.s.o(.bss); }
    .main_800A7A0C 0x800A7A0C : AT(0x00028A0C) { build/asm/data/main_800A7A0C.bin.o(.data); }
    .main_800A7E7C 0x800A7E7C : AT(0x00028E7C) { FILL(0x00000000); build/asm/main_800A7E7C.s.o(.text); build/asm/main_800A7E7C.s.o(.rodata); build/asm/main_800A7E7C.s.o(.data); }
    .main_800A7E7C_bss (NOLOAD) : { build/asm/main_800A7E7C.s.o(.bss); }
    .main_800A8530 0x800A8530 : AT(0x00029530) { build/asm/data/main_800A8530.bin.o(.data); }
    .main_800A89A4 0x800A89A4 : AT(0x000299A4) { FILL(0x00000000); build/asm/main_800A89A4.s.o(.text); build/asm/main_800A89A4.s.o(.rodata); build/asm/main_800A89A4.s.o(.data); }
    .main_800A89A4_bss (NOLOAD) : { build/asm/main_800A89A4.s.o(.bss); }
    .main_800A9338 0x800A9338 : AT(0x0002A338) { build/asm/data/main_800A9338.bin.o(.data); }
    .main_800AA0B4 0x800AA0B4 : AT(0x0002B0B4) { FILL(0x00000000); build/asm/main_800AA0B4.s.o(.text); build/asm/main_800AA0B4.s.o(.rodata); build/asm/main_800AA0B4.s.o(.data); }
    .main_800AA0B4_bss (NOLOAD) : { build/asm/main_800AA0B4.s.o(.bss); }
    .main_800AA1C4 0x800AA1C4 : AT(0x0002B1C4) { build/asm/data/main_800AA1C4.bin.o(.data); }
    .main_800AFCC4 0x800AFCC4 : AT(0x00030CC4) { FILL(0x00000000); build/asm/main_800AFCC4.s.o(.text); build/asm/main_800AFCC4.s.o(.rodata); build/asm/main_800AFCC4.s.o(.data); }
    .main_800AFCC4_bss (NOLOAD) : { build/asm/main_800AFCC4.s.o(.bss); }
    .main_800AFCD4 0x800AFCD4 : AT(0x00030CD4) { build/asm/data/main_800AFCD4.bin.o(.data); }
    .main_800B3664 0x800B3664 : AT(0x00034664) { FILL(0x00000000); build/asm/main_800B3664.s.o(.text); build/asm/main_800B3664.s.o(.rodata); build/asm/main_800B3664.s.o(.data); }
    .main_800B3664_bss (NOLOAD) : { build/asm/main_800B3664.s.o(.bss); }
    .main_800B3698 0x800B3698 : AT(0x00034698) { build/asm/data/main_800B3698.bin.o(.data); }
    .main_800B4164 0x800B4164 : AT(0x00035164) { FILL(0x00000000); build/asm/main_800B4164.s.o(.text); build/asm/main_800B4164.s.o(.rodata); build/asm/main_800B4164.s.o(.data); }
    .main_800B4164_bss (NOLOAD) : { build/asm/main_800B4164.s.o(.bss); }
    .main_800B4198 0x800B4198 : AT(0x00035198) { build/asm/data/main_800B4198.bin.o(.data); }
    .main_800BA844 0x800BA844 : AT(0x0003B844) { FILL(0x00000000); build/asm/main_800BA844.s.o(.text); build/asm/main_800BA844.s.o(.rodata); build/asm/main_800BA844.s.o(.data); }
    .main_800BA844_bss (NOLOAD) : { build/asm/main_800BA844.s.o(.bss); }
    .main_800BADF0 0x800BADF0 : AT(0x0003BDF0) { build/asm/data/main_800BADF0.bin.o(.data); }
    .main_800BF5DC 0x800BF5DC : AT(0x000405DC) { FILL(0x00000000); build/asm/main_800BF5DC.s.o(.text); build/asm/main_800BF5DC.s.o(.rodata); build/asm/main_800BF5DC.s.o(.data); }
    .main_800BF5DC_bss (NOLOAD) : { build/asm/main_800BF5DC.s.o(.bss); }
    .main_800BF704 0x800BF704 : AT(0x00040704) { build/asm/data/main_800BF704.bin.o(.data); }
    .main_800C4EC4 0x800C4EC4 : AT(0x00045EC4) { FILL(0x00000000); build/asm/main_800C4EC4.s.o(.text); build/asm/main_800C4EC4.s.o(.rodata); build/asm/main_800C4EC4.s.o(.data); }
    .main_800C4EC4_bss (NOLOAD) : { build/asm/main_800C4EC4.s.o(.bss); }
    .main_800C4ED4 0x800C4ED4 : AT(0x00045ED4) { build/asm/data/main_800C4ED4.bin.o(.data); }
    .main_800C51A4 0x800C51A4 : AT(0x000461A4) { FILL(0x00000000); build/asm/main_800C51A4.s.o(.text); build/asm/main_800C51A4.s.o(.rodata); build/asm/main_800C51A4.s.o(.data); }
    .main_800C51A4_bss (NOLOAD) : { build/asm/main_800C51A4.s.o(.bss); }
    .main_800C51D0 0x800C51D0 : AT(0x000461D0) { build/asm/data/main_800C51D0.bin.o(.data); }
    .main_800D7B9C 0x800D7B9C : AT(0x00058B9C) { FILL(0x00000000); build/asm/main_800D7B9C.s.o(.text); build/asm/main_800D7B9C.s.o(.rodata); build/asm/main_800D7B9C.s.o(.data); }
    .main_800D7B9C_bss (NOLOAD) : { build/asm/main_800D7B9C.s.o(.bss); }
    .main_800D7BC0 0x800D7BC0 : AT(0x00058BC0) { build/asm/data/main_800D7BC0.bin.o(.data); }
    .main_800D9C1C 0x800D9C1C : AT(0x0005AC1C) { FILL(0x00000000); build/asm/main_800D9C1C.s.o(.text); build/asm/main_800D9C1C.s.o(.rodata); build/asm/main_800D9C1C.s.o(.data); }
    .main_800D9C1C_bss (NOLOAD) : { build/asm/main_800D9C1C.s.o(.bss); }
    .main_800D9C34 0x800D9C34 : AT(0x0005AC34) { build/asm/data/main_800D9C34.bin.o(.data); }
    .main_800DDD40 0x800DDD40 : AT(0x0005ED40) { FILL(0x00000000); build/asm/main_800DDD40.s.o(.text); build/asm/main_800DDD40.s.o(.rodata); build/asm/main_800DDD40.s.o(.data); }
    .main_800DDD40_bss (NOLOAD) : { build/asm/main_800DDD40.s.o(.bss); }
    .main_800DDD50 0x800DDD50 : AT(0x0005ED50) { build/asm/data/main_800DDD50.bin.o(.data); }
    .main_800DEE90 0x800DEE90 : AT(0x0005FE90) { FILL(0x00000000); build/asm/main_800DEE90.s.o(.text); build/asm/main_800DEE90.s.o(.rodata); build/asm/main_800DEE90.s.o(.data); }
    .main_800DEE90_bss (NOLOAD) : { build/asm/main_800DEE90.s.o(.bss); }
    .main_800DF080 0x800DF080 : AT(0x00060080) { build/asm/data/main_800DF080.bin.o(.data); }
    .main_800E01C4 0x800E01C4 : AT(0x000611C4) { FILL(0x00000000); build/asm/main_800E01C4.s.o(.text); build/asm/main_800E01C4.s.o(.rodata); build/asm/main_800E01C4.s.o(.data); }
    .main_800E01C4_bss (NOLOAD) : { build/asm/main_800E01C4.s.o(.bss); }
    .main_800E021C 0x800E021C : AT(0x0006121C) { build/asm/data/main_800E021C.bin.o(.data); }
    .main_800E24F8 0x800E24F8 : AT(0x000634F8) { FILL(0x00000000); build/asm/main_800E24F8.s.o(.text); build/asm/main_800E24F8.s.o(.rodata); build/asm/main_800E24F8.s.o(.data); }
    .main_800E24F8_bss (NOLOAD) : { build/asm/main_800E24F8.s.o(.bss); }
    .main_800E251C 0x800E251C : AT(0x0006351C) { build/asm/data/main_800E251C.bin.o(.data); }
    .main_800E30EC 0x800E30EC : AT(0x000640EC) { FILL(0x00000000); build/asm/main_800E30EC.s.o(.text); build/asm/main_800E30EC.s.o(.rodata); build/asm/main_800E30EC.s.o(.data); }
    .main_800E30EC_bss (NOLOAD) : { build/asm/main_800E30EC.s.o(.bss); }
    .main_800E3148 0x800E3148 : AT(0x00064148) { build/asm/data/main_800E3148.bin.o(.data); }
    .main_800E3CD8 0x800E3CD8 : AT(0x00064CD8) { FILL(0x00000000); build/asm/main_800E3CD8.s.o(.text); build/asm/main_800E3CD8.s.o(.rodata); build/asm/main_800E3CD8.s.o(.data); }
    .main_800E3CD8_bss (NOLOAD) : { build/asm/main_800E3CD8.s.o(.bss); }
    .main_800E3D10 0x800E3D10 : AT(0x00064D10) { build/asm/data/main_800E3D10.bin.o(.data); }
    .main_800E4104 0x800E4104 : AT(0x00065104) { FILL(0x00000000); build/asm/main_800E4104.s.o(.text); build/asm/main_800E4104.s.o(.rodata); build/asm/main_800E4104.s.o(.data); }
    .main_800E4104_bss (NOLOAD) : { build/asm/main_800E4104.s.o(.bss); }
    .main_800E4110 0x800E4110 : AT(0x00065110) { build/asm/data/main_800E4110.bin.o(.data); }
    .main_800E47D0 0x800E47D0 : AT(0x000657D0) { FILL(0x00000000); build/asm/main_800E47D0.s.o(.text); build/asm/main_800E47D0.s.o(.rodata); build/asm/main_800E47D0.s.o(.data); }
    .main_800E47D0_bss (NOLOAD) : { build/asm/main_800E47D0.s.o(.bss); }
    .main_800E47EC 0x800E47EC : AT(0x000657EC) { build/asm/data/main_800E47EC.bin.o(.data); }
    .main_800E4894 0x800E4894 : AT(0x00065894) { FILL(0x00000000); build/asm/main_800E4894.s.o(.text); build/asm/main_800E4894.s.o(.rodata); build/asm/main_800E4894.s.o(.data); }
    .main_800E4894_bss (NOLOAD) : { build/asm/main_800E4894.s.o(.bss); }
    .main_800E4898 0x800E4898 : AT(0x00065898) { build/asm/data/main_800E4898.bin.o(.data); }
    .main_800E7ED4 0x800E7ED4 : AT(0x00068ED4) { FILL(0x00000000); build/asm/main_800E7ED4.s.o(.text); build/asm/main_800E7ED4.s.o(.rodata); build/asm/main_800E7ED4.s.o(.data); }
    .main_800E7ED4_bss (NOLOAD) : { build/asm/main_800E7ED4.s.o(.bss); }
    .main_800E7EFC 0x800E7EFC : AT(0x00068EFC) { build/asm/data/main_800E7EFC.bin.o(.data); }
    .main_800E8458 0x800E8458 : AT(0x00069458) { FILL(0x00000000); build/asm/main_800E8458.s.o(.text); build/asm/main_800E8458.s.o(.rodata); build/asm/main_800E8458.s.o(.data); }
    .main_800E8458_bss (NOLOAD) : { build/asm/main_800E8458.s.o(.bss); }
    .main_800E8488 0x800E8488 : AT(0x00069488) { build/asm/data/main_800E8488.bin.o(.data); }
    .main_800E89A4 0x800E89A4 : AT(0x000699A4) { FILL(0x00000000); build/asm/main_800E89A4.s.o(.text); build/asm/main_800E89A4.s.o(.rodata); build/asm/main_800E89A4.s.o(.data); }
    .main_800E89A4_bss (NOLOAD) : { build/asm/main_800E89A4.s.o(.bss); }
    .main_800E89B8 0x800E89B8 : AT(0x000699B8) { build/asm/data/main_800E89B8.bin.o(.data); }
    .main_800E925C 0x800E925C : AT(0x0006A25C) { FILL(0x00000000); build/asm/main_800E925C.s.o(.text); build/asm/main_800E925C.s.o(.rodata); build/asm/main_800E925C.s.o(.data); }
    .main_800E925C_bss (NOLOAD) : { build/asm/main_800E925C.s.o(.bss); }
    .main_800E92B0 0x800E92B0 : AT(0x0006A2B0) { build/asm/data/main_800E92B0.bin.o(.data); }
    .main_800E9E3C 0x800E9E3C : AT(0x0006AE3C) { FILL(0x00000000); build/asm/main_800E9E3C.s.o(.text); build/asm/main_800E9E3C.s.o(.rodata); build/asm/main_800E9E3C.s.o(.data); }
    .main_800E9E3C_bss (NOLOAD) : { build/asm/main_800E9E3C.s.o(.bss); }
    .main_800E9FC4 0x800E9FC4 : AT(0x0006AFC4) { build/asm/data/main_800E9FC4.bin.o(.data); }
    .main_800EADE0 0x800EADE0 : AT(0x0006BDE0) { FILL(0x00000000); build/asm/main_800EADE0.s.o(.text); build/asm/main_800EADE0.s.o(.rodata); build/asm/main_800EADE0.s.o(.data); }
    .main_800EADE0_bss (NOLOAD) : { build/asm/main_800EADE0.s.o(.bss); }
    .main_800EAE4C 0x800EAE4C : AT(0x0006BE4C) { build/asm/data/main_800EAE4C.bin.o(.data); }
    .main_800EB5AC 0x800EB5AC : AT(0x0006C5AC) { FILL(0x00000000); build/asm/main_800EB5AC.s.o(.text); build/asm/main_800EB5AC.s.o(.rodata); build/asm/main_800EB5AC.s.o(.data); }
    .main_800EB5AC_bss (NOLOAD) : { build/asm/main_800EB5AC.s.o(.bss); }
    .main_800EB644 0x800EB644 : AT(0x0006C644) { build/asm/data/main_800EB644.bin.o(.data); }
    .main_800EB6E4 0x800EB6E4 : AT(0x0006C6E4) { FILL(0x00000000); build/asm/main_800EB6E4.s.o(.text); build/asm/main_800EB6E4.s.o(.rodata); build/asm/main_800EB6E4.s.o(.data); }
    .main_800EB6E4_bss (NOLOAD) : { build/asm/main_800EB6E4.s.o(.bss); }
    .main_800EB6EC 0x800EB6EC : AT(0x0006C6EC) { build/asm/data/main_800EB6EC.bin.o(.data); }
    .main_800EB960 0x800EB960 : AT(0x0006C960) { FILL(0x00000000); build/asm/main_800EB960.s.o(.text); build/asm/main_800EB960.s.o(.rodata); build/asm/main_800EB960.s.o(.data); }
    .main_800EB960_bss (NOLOAD) : { build/asm/main_800EB960.s.o(.bss); }
    .main_800EB984 0x800EB984 : AT(0x0006C984) { build/asm/data/main_800EB984.bin.o(.data); }
    .main_800EC1D4 0x800EC1D4 : AT(0x0006D1D4) { FILL(0x00000000); build/asm/main_800EC1D4.s.o(.text); build/asm/main_800EC1D4.s.o(.rodata); build/asm/main_800EC1D4.s.o(.data); }
    .main_800EC1D4_bss (NOLOAD) : { build/asm/main_800EC1D4.s.o(.bss); }
    .main_800EC590 0x800EC590 : AT(0x0006D590) { build/asm/data/main_800EC590.bin.o(.data); }
    .main_800ED0E4 0x800ED0E4 : AT(0x0006E0E4) { FILL(0x00000000); build/asm/main_800ED0E4.s.o(.text); build/asm/main_800ED0E4.s.o(.rodata); build/asm/main_800ED0E4.s.o(.data); }
    .main_800ED0E4_bss (NOLOAD) : { build/asm/main_800ED0E4.s.o(.bss); }
    .main_800ED11C 0x800ED11C : AT(0x0006E11C) { build/asm/data/main_800ED11C.bin.o(.data); }
    .main_800EF0C8 0x800EF0C8 : AT(0x000700C8) { FILL(0x00000000); build/asm/main_800EF0C8.s.o(.text); build/asm/main_800EF0C8.s.o(.rodata); build/asm/main_800EF0C8.s.o(.data); }
    .main_800EF0C8_bss (NOLOAD) : { build/asm/main_800EF0C8.s.o(.bss); }
    .main_800EF0D4 0x800EF0D4 : AT(0x000700D4) { build/asm/data/main_800EF0D4.bin.o(.data); }
    .main_800EF9C4 0x800EF9C4 : AT(0x000709C4) { FILL(0x00000000); build/asm/main_800EF9C4.s.o(.text); build/asm/main_800EF9C4.s.o(.rodata); build/asm/main_800EF9C4.s.o(.data); }
    .main_800EF9C4_bss (NOLOAD) : { build/asm/main_800EF9C4.s.o(.bss); }
    .main_800EFA3C 0x800EFA3C : AT(0x00070A3C) { build/asm/data/main_800EFA3C.bin.o(.data); }
    .main_800F1818 0x800F1818 : AT(0x00072818) { FILL(0x00000000); build/asm/main_800F1818.s.o(.text); build/asm/main_800F1818.s.o(.rodata); build/asm/main_800F1818.s.o(.data); }
    .main_800F1818_bss (NOLOAD) : { build/asm/main_800F1818.s.o(.bss); }
    .main_800F1A14 0x800F1A14 : AT(0x00072A14) { build/asm/data/main_800F1A14.bin.o(.data); }
    .main_800F61E8 0x800F61E8 : AT(0x000771E8) { FILL(0x00000000); build/asm/main_800F61E8.s.o(.text); build/asm/main_800F61E8.s.o(.rodata); build/asm/main_800F61E8.s.o(.data); }
    .main_800F61E8_bss (NOLOAD) : { build/asm/main_800F61E8.s.o(.bss); }
    .main_800F6268 0x800F6268 : AT(0x00077268) { build/asm/data/main_800F6268.bin.o(.data); }
    .main_800F9F44 0x800F9F44 : AT(0x0007AF44) { FILL(0x00000000); build/asm/main_800F9F44.s.o(.text); build/asm/main_800F9F44.s.o(.rodata); build/asm/main_800F9F44.s.o(.data); }
    .main_800F9F44_bss (NOLOAD) : { build/asm/main_800F9F44.s.o(.bss); }
    .main_800F9F80 0x800F9F80 : AT(0x0007AF80) { build/asm/data/main_800F9F80.bin.o(.data); }
    .main_800FBEE8 0x800FBEE8 : AT(0x0007CEE8) { FILL(0x00000000); build/asm/main_800FBEE8.s.o(.text); build/asm/main_800FBEE8.s.o(.rodata); build/asm/main_800FBEE8.s.o(.data); }
    .main_800FBEE8_bss (NOLOAD) : { build/asm/main_800FBEE8.s.o(.bss); }
    .main_800FBF54 0x800FBF54 : AT(0x0007CF54) { build/asm/data/main_800FBF54.bin.o(.data); }
    .main_800FFBC4 0x800FFBC4 : AT(0x00080BC4) { FILL(0x00000000); build/asm/main_800FFBC4.s.o(.text); build/asm/main_800FFBC4.s.o(.rodata); build/asm/main_800FFBC4.s.o(.data); }
    .main_800FFBC4_bss (NOLOAD) : { build/asm/main_800FFBC4.s.o(.bss); }
    .main_800FFD50 0x800FFD50 : AT(0x00080D50) { FILL(0x00000000); build/asm/main_800FFD50.s.o(.text); build/asm/main_800FFD50.s.o(.rodata); build/asm/main_800FFD50.s.o(.data); }
    .main_800FFD50_bss (NOLOAD) : { build/asm/main_800FFD50.s.o(.bss); }
    .main_800FFD80 0x800FFD80 : AT(0x00080D80) { build/asm/data/main_800FFD80.bin.o(.data); }
    .main_800FFF8C 0x800FFF8C : AT(0x00080F8C) { build/asm/data/main_800FFF8C.bin.o(.data); }
    .main_801001E0 0x801001E0 : AT(0x000811E0) { FILL(0x00000000); build/asm/main_801001E0.s.o(.text); build/asm/main_801001E0.s.o(.rodata); build/asm/main_801001E0.s.o(.data); }
    .main_801001E0_bss (NOLOAD) : { build/asm/main_801001E0.s.o(.bss); }
    .main_80100390 0x80100390 : AT(0x00081390) { build/asm/data/main_80100390.bin.o(.data); }
    .main_80100804 0x80100804 : AT(0x00081804) { build/asm/data/main_80100804.bin.o(.data); }
    .main_80100A00 0x80100A00 : AT(0x00081A00) { FILL(0x00000000); build/asm/main_80100A00.s.o(.text); build/asm/main_80100A00.s.o(.rodata); build/asm/main_80100A00.s.o(.data); }
    .main_80100A00_bss (NOLOAD) : { build/asm/main_80100A00.s.o(.bss); }
    .main_80100A30 0x80100A30 : AT(0x00081A30) { build/asm/data/main_80100A30.bin.o(.data); }
    .main_80100F68 0x80100F68 : AT(0x00081F68) { FILL(0x00000000); build/asm/main_80100F68.s.o(.text); build/asm/main_80100F68.s.o(.rodata); build/asm/main_80100F68.s.o(.data); }
    .main_80100F68_bss (NOLOAD) : { build/asm/main_80100F68.s.o(.bss); }
    .main_80100FB8 0x80100FB8 : AT(0x00081FB8) { build/asm/data/main_80100FB8.bin.o(.data); }
    .main_801010D4 0x801010D4 : AT(0x000820D4) { FILL(0x00000000); build/asm/main_801010D4.s.o(.text); build/asm/main_801010D4.s.o(.rodata); build/asm/main_801010D4.s.o(.data); }
    .main_801010D4_bss (NOLOAD) : { build/asm/main_801010D4.s.o(.bss); }
    .main_80101354 0x80101354 : AT(0x00082354) { build/asm/data/main_80101354.bin.o(.data); }
    .main_801014F4 0x801014F4 : AT(0x000824F4) { FILL(0x00000000); build/asm/main_801014F4.s.o(.text); build/asm/main_801014F4.s.o(.rodata); build/asm/main_801014F4.s.o(.data); }
    .main_801014F4_bss (NOLOAD) : { build/asm/main_801014F4.s.o(.bss); }
    .main_80101580 0x80101580 : AT(0x00082580) { build/asm/data/main_80101580.bin.o(.data); }
    .main_8010199C 0x8010199C : AT(0x0008299C) { FILL(0x00000000); build/asm/main_8010199C.s.o(.text); build/asm/main_8010199C.s.o(.rodata); build/asm/main_8010199C.s.o(.data); }
    .main_8010199C_bss (NOLOAD) : { build/asm/main_8010199C.s.o(.bss); }
    .main_80101AA4 0x80101AA4 : AT(0x00082AA4) { build/asm/data/main_80101AA4.bin.o(.data); }
    .main_80101C3C 0x80101C3C : AT(0x00082C3C) { FILL(0x00000000); build/asm/main_80101C3C.s.o(.text); build/asm/main_80101C3C.s.o(.rodata); build/asm/main_80101C3C.s.o(.data); }
    .main_80101C3C_bss (NOLOAD) : { build/asm/main_80101C3C.s.o(.bss); }
    .main_80101CD8 0x80101CD8 : AT(0x00082CD8) { build/asm/data/main_80101CD8.bin.o(.data); }
    .main_80101D80 0x80101D80 : AT(0x00082D80) { FILL(0x00000000); build/asm/main_80101D80.s.o(.text); build/asm/main_80101D80.s.o(.rodata); build/asm/main_80101D80.s.o(.data); }
    .main_80101D80_bss (NOLOAD) : { build/asm/main_80101D80.s.o(.bss); }
    .main_80101DD4 0x80101DD4 : AT(0x00082DD4) { build/asm/data/main_80101DD4.bin.o(.data); }
    .main_80101EAC 0x80101EAC : AT(0x00082EAC) { FILL(0x00000000); build/asm/main_80101EAC.s.o(.text); build/asm/main_80101EAC.s.o(.rodata); build/asm/main_80101EAC.s.o(.data); }
    .main_80101EAC_bss (NOLOAD) : { build/asm/main_80101EAC.s.o(.bss); }
    .main_80101F30 0x80101F30 : AT(0x00082F30) { build/asm/data/main_80101F30.bin.o(.data); }
    .main_80102BD0 0x80102BD0 : AT(0x00083BD0) { FILL(0x00000000); build/asm/main_80102BD0.s.o(.text); build/asm/main_80102BD0.s.o(.rodata); build/asm/main_80102BD0.s.o(.data); }
    .main_80102BD0_bss (NOLOAD) : { build/asm/main_80102BD0.s.o(.bss); }
    .main_80102D44 0x80102D44 : AT(0x00083D44) { build/asm/data/main_80102D44.bin.o(.data); }
    .main_80103050 0x80103050 : AT(0x00084050) { FILL(0x00000000); build/asm/main_80103050.s.o(.text); build/asm/main_80103050.s.o(.rodata); build/asm/main_80103050.s.o(.data); }
    .main_80103050_bss (NOLOAD) : { build/asm/main_80103050.s.o(.bss); }
    .main_801030CC 0x801030CC : AT(0x000840CC) { build/asm/data/main_801030CC.bin.o(.data); }
    .main_8010318C 0x8010318C : AT(0x0008418C) { FILL(0x00000000); build/asm/main_8010318C.s.o(.text); build/asm/main_8010318C.s.o(.rodata); build/asm/main_8010318C.s.o(.data); }
    .main_8010318C_bss (NOLOAD) : { build/asm/main_8010318C.s.o(.bss); }
    .main_80103270 0x80103270 : AT(0x00084270) { build/asm/data/main_80103270.bin.o(.data); }
    .main_801035D0 0x801035D0 : AT(0x000845D0) { build/asm/data/main_801035D0.bin.o(.data); }
    .main_801039F4 0x801039F4 : AT(0x000849F4) { build/asm/data/main_801039F4.bin.o(.data); }
    .main_80103AB0 0x80103AB0 : AT(0x00084AB0) { FILL(0x00000000); build/asm/main_80103AB0.s.o(.text); build/asm/main_80103AB0.s.o(.rodata); build/asm/main_80103AB0.s.o(.data); }
    .main_80103AB0_bss (NOLOAD) : { build/asm/main_80103AB0.s.o(.bss); }
    .main_80103AC4 0x80103AC4 : AT(0x00084AC4) { build/asm/data/main_80103AC4.bin.o(.data); }
    .main_80103EBC 0x80103EBC : AT(0x00084EBC) { FILL(0x00000000); build/asm/main_80103EBC.s.o(.text); build/asm/main_80103EBC.s.o(.rodata); build/asm/main_80103EBC.s.o(.data); }
    .main_80103EBC_bss (NOLOAD) : { build/asm/main_80103EBC.s.o(.bss); }
    .main_80103FD4 0x80103FD4 : AT(0x00084FD4) { build/asm/data/main_80103FD4.bin.o(.data); }
    .main_80104270 0x80104270 : AT(0x00085270) { build/asm/data/main_80104270.bin.o(.data); }
    .main_8010446C 0x8010446C : AT(0x0008546C) { FILL(0x00000000); build/asm/main_8010446C.s.o(.text); build/asm/main_8010446C.s.o(.rodata); build/asm/main_8010446C.s.o(.data); }
    .main_8010446C_bss (NOLOAD) : { build/asm/main_8010446C.s.o(.bss); }
    .main_801044B8 0x801044B8 : AT(0x000854B8) { build/asm/data/main_801044B8.bin.o(.data); }
    .main_801048EC 0x801048EC : AT(0x000858EC) { FILL(0x00000000); build/asm/main_801048EC.s.o(.text); build/asm/main_801048EC.s.o(.rodata); build/asm/main_801048EC.s.o(.data); }
    .main_801048EC_bss (NOLOAD) : { build/asm/main_801048EC.s.o(.bss); }
    .main_801049B0 0x801049B0 : AT(0x000859B0) { build/asm/data/main_801049B0.bin.o(.data); }
    .main_80104DE0 0x80104DE0 : AT(0x00085DE0) { FILL(0x00000000); build/asm/main_80104DE0.s.o(.text); build/asm/main_80104DE0.s.o(.rodata); build/asm/main_80104DE0.s.o(.data); }
    .main_80104DE0_bss (NOLOAD) : { build/asm/main_80104DE0.s.o(.bss); }
    .main_80104E04 0x80104E04 : AT(0x00085E04) { build/asm/data/main_80104E04.bin.o(.data); }
    .main_801050E0 0x801050E0 : AT(0x000860E0) { FILL(0x00000000); build/asm/main_801050E0.s.o(.text); build/asm/main_801050E0.s.o(.rodata); build/asm/main_801050E0.s.o(.data); }
    .main_801050E0_bss (NOLOAD) : { build/asm/main_801050E0.s.o(.bss); }
    .main_80105170 0x80105170 : AT(0x00086170) { build/asm/data/main_80105170.bin.o(.data); }
    .main_80105608 0x80105608 : AT(0x00086608) { FILL(0x00000000); build/asm/main_80105608.s.o(.text); build/asm/main_80105608.s.o(.rodata); build/asm/main_80105608.s.o(.data); }
    .main_80105608_bss (NOLOAD) : { build/asm/main_80105608.s.o(.bss); }
    .main_801056A4 0x801056A4 : AT(0x000866A4) { build/asm/data/main_801056A4.bin.o(.data); }
    .main_80105CB8 0x80105CB8 : AT(0x00086CB8) { build/asm/data/main_80105CB8.bin.o(.data); }
    .main_801067B8 0x801067B8 : AT(0x000877B8) { FILL(0x00000000); build/asm/main_801067B8.s.o(.text); build/asm/main_801067B8.s.o(.rodata); build/asm/main_801067B8.s.o(.data); }
    .main_801067B8_bss (NOLOAD) : { build/asm/main_801067B8.s.o(.bss); }
    .main_80106818 0x80106818 : AT(0x00087818) { build/asm/data/main_80106818.bin.o(.data); }
    .main_80106870 0x80106870 : AT(0x00087870) { FILL(0x00000000); build/asm/main_80106870.s.o(.text); build/asm/main_80106870.s.o(.rodata); build/asm/main_80106870.s.o(.data); }
    .main_80106870_bss (NOLOAD) : { build/asm/main_80106870.s.o(.bss); }
    .main_801068E0 0x801068E0 : AT(0x000878E0) { build/asm/data/main_801068E0.bin.o(.data); }
    .main_80106918 0x80106918 : AT(0x00087918) { FILL(0x00000000); build/asm/main_80106918.s.o(.text); build/asm/main_80106918.s.o(.rodata); build/asm/main_80106918.s.o(.data); }
    .main_80106918_bss (NOLOAD) : { build/asm/main_80106918.s.o(.bss); }
    .main_80106950 0x80106950 : AT(0x00087950) { build/asm/data/main_80106950.bin.o(.data); }
    .main_801069F8 0x801069F8 : AT(0x000879F8) { FILL(0x00000000); build/asm/main_801069F8.s.o(.text); build/asm/main_801069F8.s.o(.rodata); build/asm/main_801069F8.s.o(.data); }
    .main_801069F8_bss (NOLOAD) : { build/asm/main_801069F8.s.o(.bss); }
    .main_80106B28 0x80106B28 : AT(0x00087B28) { build/asm/data/main_80106B28.bin.o(.data); }
    .main_80106D60 0x80106D60 : AT(0x00087D60) { FILL(0x00000000); build/asm/main_80106D60.s.o(.text); build/asm/main_80106D60.s.o(.rodata); build/asm/main_80106D60.s.o(.data); }
    .main_80106D60_bss (NOLOAD) : { build/asm/main_80106D60.s.o(.bss); }
    .main_80106D8C 0x80106D8C : AT(0x00087D8C) { build/asm/data/main_80106D8C.bin.o(.data); }
    .main_80106E5C 0x80106E5C : AT(0x00087E5C) { FILL(0x00000000); build/asm/main_80106E5C.s.o(.text); build/asm/main_80106E5C.s.o(.rodata); build/asm/main_80106E5C.s.o(.data); }
    .main_80106E5C_bss (NOLOAD) : { build/asm/main_80106E5C.s.o(.bss); }
    .main_80106EFC 0x80106EFC : AT(0x00087EFC) { build/asm/data/main_80106EFC.bin.o(.data); }
    .main_80106F1C 0x80106F1C : AT(0x00087F1C) { FILL(0x00000000); build/asm/main_80106F1C.s.o(.text); build/asm/main_80106F1C.s.o(.rodata); build/asm/main_80106F1C.s.o(.data); }
    .main_80106F1C_bss (NOLOAD) : { build/asm/main_80106F1C.s.o(.bss); }
    .main_80106F64 0x80106F64 : AT(0x00087F64) { build/asm/data/main_80106F64.bin.o(.data); }
    .main_801073C4 0x801073C4 : AT(0x000883C4) { FILL(0x00000000); build/asm/main_801073C4.s.o(.text); build/asm/main_801073C4.s.o(.rodata); build/asm/main_801073C4.s.o(.data); }
    .main_801073C4_bss (NOLOAD) : { build/asm/main_801073C4.s.o(.bss); }
    .main_801073EC 0x801073EC : AT(0x000883EC) { build/asm/data/main_801073EC.bin.o(.data); }
    .main_801074A4 0x801074A4 : AT(0x000884A4) { FILL(0x00000000); build/asm/main_801074A4.s.o(.text); build/asm/main_801074A4.s.o(.rodata); build/asm/main_801074A4.s.o(.data); }
    .main_801074A4_bss (NOLOAD) : { build/asm/main_801074A4.s.o(.bss); }
    .main_80107560 0x80107560 : AT(0x00088560) { build/asm/data/main_80107560.bin.o(.data); }
    .main_80107AD0 0x80107AD0 : AT(0x00088AD0) { FILL(0x00000000); build/asm/main_80107AD0.s.o(.text); build/asm/main_80107AD0.s.o(.rodata); build/asm/main_80107AD0.s.o(.data); }
    .main_80107AD0_bss (NOLOAD) : { build/asm/main_80107AD0.s.o(.bss); }
    .main_80107AF8 0x80107AF8 : AT(0x00088AF8) { build/asm/data/main_80107AF8.bin.o(.data); }
    .main_80107C10 0x80107C10 : AT(0x00088C10) { FILL(0x00000000); build/asm/main_80107C10.s.o(.text); build/asm/main_80107C10.s.o(.rodata); build/asm/main_80107C10.s.o(.data); }
    .main_80107C10_bss (NOLOAD) : { build/asm/main_80107C10.s.o(.bss); }
    .main_80107C1C 0x80107C1C : AT(0x00088C1C) { build/asm/data/main_80107C1C.bin.o(.data); }
    .main_801084A8 0x801084A8 : AT(0x000894A8) { FILL(0x00000000); build/asm/main_801084A8.s.o(.text); build/asm/main_801084A8.s.o(.rodata); build/asm/main_801084A8.s.o(.data); }
    .main_801084A8_bss (NOLOAD) : { build/asm/main_801084A8.s.o(.bss); }
    .main_801085A8 0x801085A8 : AT(0x000895A8) { build/asm/data/main_801085A8.bin.o(.data); }
    .main_80108C5C 0x80108C5C : AT(0x00089C5C) { FILL(0x00000000); build/asm/main_80108C5C.s.o(.text); build/asm/main_80108C5C.s.o(.rodata); build/asm/main_80108C5C.s.o(.data); }
    .main_80108C5C_bss (NOLOAD) : { build/asm/main_80108C5C.s.o(.bss); }
    .main_80108E44 0x80108E44 : AT(0x00089E44) { build/asm/data/main_80108E44.bin.o(.data); }
    .main_80108E8C 0x80108E8C : AT(0x00089E8C) { FILL(0x00000000); build/asm/main_80108E8C.s.o(.text); build/asm/main_80108E8C.s.o(.rodata); build/asm/main_80108E8C.s.o(.data); }
    .main_80108E8C_bss (NOLOAD) : { build/asm/main_80108E8C.s.o(.bss); }
    .main_80108EA4 0x80108EA4 : AT(0x00089EA4) { build/asm/data/main_80108EA4.bin.o(.data); }
    .main_80109030 0x80109030 : AT(0x0008A030) { FILL(0x00000000); build/asm/main_80109030.s.o(.text); build/asm/main_80109030.s.o(.rodata); build/asm/main_80109030.s.o(.data); }
    .main_80109030_bss (NOLOAD) : { build/asm/main_80109030.s.o(.bss); }
    .main_80109180 0x80109180 : AT(0x0008A180) { build/asm/data/main_80109180.bin.o(.data); }
    .main_801096A0 0x801096A0 : AT(0x0008A6A0) { build/asm/data/main_801096A0.bin.o(.data); }
    .main_80109734 0x80109734 : AT(0x0008A734) { FILL(0x00000000); build/asm/main_80109734.s.o(.text); build/asm/main_80109734.s.o(.rodata); build/asm/main_80109734.s.o(.data); }
    .main_80109734_bss (NOLOAD) : { build/asm/main_80109734.s.o(.bss); }
    .main_80109760 0x80109760 : AT(0x0008A760) { build/asm/data/main_80109760.bin.o(.data); }
    .main_80109968 0x80109968 : AT(0x0008A968) { FILL(0x00000000); build/asm/main_80109968.s.o(.text); build/asm/main_80109968.s.o(.rodata); build/asm/main_80109968.s.o(.data); }
    .main_80109968_bss (NOLOAD) : { build/asm/main_80109968.s.o(.bss); }
    .main_80109A40 0x80109A40 : AT(0x0008AA40) { build/asm/data/main_80109A40.bin.o(.data); }
    .main_8010A140 0x8010A140 : AT(0x0008B140) { FILL(0x00000000); build/asm/main_8010A140.s.o(.text); build/asm/main_8010A140.s.o(.rodata); build/asm/main_8010A140.s.o(.data); }
    .main_8010A140_bss (NOLOAD) : { build/asm/main_8010A140.s.o(.bss); }
    .main_8010A1D0 0x8010A1D0 : AT(0x0008B1D0) { build/asm/data/main_8010A1D0.bin.o(.data); }
    .main_8010A610 0x8010A610 : AT(0x0008B610) { FILL(0x00000000); build/asm/main_8010A610.s.o(.text); build/asm/main_8010A610.s.o(.rodata); build/asm/main_8010A610.s.o(.data); }
    .main_8010A610_bss (NOLOAD) : { build/asm/main_8010A610.s.o(.bss); }
    .main_8010A650 0x8010A650 : AT(0x0008B650) { build/asm/data/main_8010A650.bin.o(.data); }
    .main_8010AA70 0x8010AA70 : AT(0x0008BA70) { FILL(0x00000000); build/asm/main_8010AA70.s.o(.text); build/asm/main_8010AA70.s.o(.rodata); build/asm/main_8010AA70.s.o(.data); }
    .main_8010AA70_bss (NOLOAD) : { build/asm/main_8010AA70.s.o(.bss); }
    .main_8010AB70 0x8010AB70 : AT(0x0008BB70) { build/asm/data/main_8010AB70.bin.o(.data); }
    .main_8010B250 0x8010B250 : AT(0x0008C250) { FILL(0x00000000); build/asm/main_8010B250.s.o(.text); build/asm/main_8010B250.s.o(.rodata); build/asm/main_8010B250.s.o(.data); }
    .main_8010B250_bss (NOLOAD) : { build/asm/main_8010B250.s.o(.bss); }
    .main_8010B2D0 0x8010B2D0 : AT(0x0008C2D0) { build/asm/data/main_8010B2D0.bin.o(.data); }
    .main_8010BB60 0x8010BB60 : AT(0x0008CB60) { FILL(0x00000000); build/asm/main_8010BB60.s.o(.text); build/asm/main_8010BB60.s.o(.rodata); build/asm/main_8010BB60.s.o(.data); }
    .main_8010BB60_bss (NOLOAD) : { build/asm/main_8010BB60.s.o(.bss); }
    .main_8010BCB0 0x8010BCB0 : AT(0x0008CCB0) { build/asm/data/main_8010BCB0.bin.o(.data); }
    .main_8010BDE0 0x8010BDE0 : AT(0x0008CDE0) { FILL(0x00000000); build/asm/main_8010BDE0.s.o(.text); build/asm/main_8010BDE0.s.o(.rodata); build/asm/main_8010BDE0.s.o(.data); }
    .main_8010BDE0_bss (NOLOAD) : { build/asm/main_8010BDE0.s.o(.bss); }
    .main_8010C4B0 0x8010C4B0 : AT(0x0008D4B0) { build/asm/data/main_8010C4B0.bin.o(.data); }
    .main_8010C674 0x8010C674 : AT(0x0008D674) { FILL(0x00000000); build/asm/main_8010C674.s.o(.text); build/asm/main_8010C674.s.o(.rodata); build/asm/main_8010C674.s.o(.data); }
    .main_8010C674_bss (NOLOAD) : { build/asm/main_8010C674.s.o(.bss); }
    .main_8010C698 0x8010C698 : AT(0x0008D698) { build/asm/data/main_8010C698.bin.o(.data); }
    .main_8010CBC0 0x8010CBC0 : AT(0x0008DBC0) { FILL(0x00000000); build/asm/main_8010CBC0.s.o(.text); build/asm/main_8010CBC0.s.o(.rodata); build/asm/main_8010CBC0.s.o(.data); }
    .main_8010CBC0_bss (NOLOAD) : { build/asm/main_8010CBC0.s.o(.bss); }
    .main_8010CBE4 0x8010CBE4 : AT(0x0008DBE4) { build/asm/data/main_8010CBE4.bin.o(.data); }
    .main_8010CEE0 0x8010CEE0 : AT(0x0008DEE0) { build/asm/data/main_8010CEE0.bin.o(.data); }
    .main_8010D240 0x8010D240 : AT(0x0008E240) { FILL(0x00000000); build/asm/main_8010D240.s.o(.text); build/asm/main_8010D240.s.o(.rodata); build/asm/main_8010D240.s.o(.data); }
    .main_8010D240_bss (NOLOAD) : { build/asm/main_8010D240.s.o(.bss); }
    .main_8010D310 0x8010D310 : AT(0x0008E310) { build/asm/data/main_8010D310.bin.o(.data); }
    .main_8010DC50 0x8010DC50 : AT(0x0008EC50) { FILL(0x00000000); build/asm/main_8010DC50.s.o(.text); build/asm/main_8010DC50.s.o(.rodata); build/asm/main_8010DC50.s.o(.data); }
    .main_8010DC50_bss (NOLOAD) : { build/asm/main_8010DC50.s.o(.bss); }
    .main_8010DD10 0x8010DD10 : AT(0x0008ED10) { build/asm/data/main_8010DD10.bin.o(.data); }
    .main_8010EDE0 0x8010EDE0 : AT(0x0008FDE0) { FILL(0x00000000); build/asm/main_8010EDE0.s.o(.text); build/asm/main_8010EDE0.s.o(.rodata); build/asm/main_8010EDE0.s.o(.data); }
    .main_8010EDE0_bss (NOLOAD) : { build/asm/main_8010EDE0.s.o(.bss); }
    .main_8010EE08 0x8010EE08 : AT(0x0008FE08) { build/asm/data/main_8010EE08.bin.o(.data); }
    .main_8010EE40 0x8010EE40 : AT(0x0008FE40) { FILL(0x00000000); build/asm/main_8010EE40.s.o(.text); build/asm/main_8010EE40.s.o(.rodata); build/asm/main_8010EE40.s.o(.data); }
    .main_8010EE40_bss (NOLOAD) : { build/asm/main_8010EE40.s.o(.bss); }
    .main_8010EE70 0x8010EE70 : AT(0x0008FE70) { build/asm/data/main_8010EE70.bin.o(.data); }
    .main_8010F600 0x8010F600 : AT(0x00090600) { FILL(0x00000000); build/asm/main_8010F600.s.o(.text); build/asm/main_8010F600.s.o(.rodata); build/asm/main_8010F600.s.o(.data); }
    .main_8010F600_bss (NOLOAD) : { build/asm/main_8010F600.s.o(.bss); }
    .main_8010F6B0 0x8010F6B0 : AT(0x000906B0) { build/asm/data/main_8010F6B0.bin.o(.data); }
    .main_8010FA60 0x8010FA60 : AT(0x00090A60) { FILL(0x00000000); build/asm/main_8010FA60.s.o(.text); build/asm/main_8010FA60.s.o(.rodata); build/asm/main_8010FA60.s.o(.data); }
    .main_8010FA60_bss (NOLOAD) : { build/asm/main_8010FA60.s.o(.bss); }
    .main_8010FAB0 0x8010FAB0 : AT(0x00090AB0) { build/asm/data/main_8010FAB0.bin.o(.data); }
    .main_80110020 0x80110020 : AT(0x00091020) { FILL(0x00000000); build/asm/main_80110020.s.o(.text); build/asm/main_80110020.s.o(.rodata); build/asm/main_80110020.s.o(.data); }
    .main_80110020_bss (NOLOAD) : { build/asm/main_80110020.s.o(.bss); }
    .main_801100B0 0x801100B0 : AT(0x000910B0) { build/asm/data/main_801100B0.bin.o(.data); }
    .main_80110D70 0x80110D70 : AT(0x00091D70) { FILL(0x00000000); build/asm/main_80110D70.s.o(.text); build/asm/main_80110D70.s.o(.rodata); build/asm/main_80110D70.s.o(.data); }
    .main_80110D70_bss (NOLOAD) : { build/asm/main_80110D70.s.o(.bss); }
    .main_801111D0 0x801111D0 : AT(0x000921D0) { build/asm/data/main_801111D0.bin.o(.data); }
    .main_801114A0 0x801114A0 : AT(0x000924A0) { build/asm/data/main_801114A0.bin.o(.data); }
    .main_801116D0 0x801116D0 : AT(0x000926D0) { FILL(0x00000000); build/asm/main_801116D0.s.o(.text); build/asm/main_801116D0.s.o(.rodata); build/asm/main_801116D0.s.o(.data); }
    .main_801116D0_bss (NOLOAD) : { build/asm/main_801116D0.s.o(.bss); }
    .main_801116F0 0x801116F0 : AT(0x000926F0) { build/asm/data/main_801116F0.bin.o(.data); }
    .main_80111B10 0x80111B10 : AT(0x00092B10) { FILL(0x00000000); build/asm/main_80111B10.s.o(.text); build/asm/main_80111B10.s.o(.rodata); build/asm/main_80111B10.s.o(.data); }
    .main_80111B10_bss (NOLOAD) : { build/asm/main_80111B10.s.o(.bss); }
    .main_80111B40 0x80111B40 : AT(0x00092B40) { build/asm/data/main_80111B40.bin.o(.data); }
    .main_80112330 0x80112330 : AT(0x00093330) { FILL(0x00000000); build/asm/main_80112330.s.o(.text); build/asm/main_80112330.s.o(.rodata); build/asm/main_80112330.s.o(.data); }
    .main_80112330_bss (NOLOAD) : { build/asm/main_80112330.s.o(.bss); }
    .main_80112520 0x80112520 : AT(0x00093520) { build/asm/data/main_80112520.bin.o(.data); }
    .main_80112800 0x80112800 : AT(0x00093800) { FILL(0x00000000); build/asm/main_80112800.s.o(.text); build/asm/main_80112800.s.o(.rodata); build/asm/main_80112800.s.o(.data); }
    .main_80112800_bss (NOLOAD) : { build/asm/main_80112800.s.o(.bss); }
    .main_8011290C 0x8011290C : AT(0x0009390C) { build/asm/data/main_8011290C.bin.o(.data); }
    .main_80112CE8 0x80112CE8 : AT(0x00093CE8) { FILL(0x00000000); build/asm/main_80112CE8.s.o(.text); build/asm/main_80112CE8.s.o(.rodata); build/asm/main_80112CE8.s.o(.data); }
    .main_80112CE8_bss (NOLOAD) : { build/asm/main_80112CE8.s.o(.bss); }
    .main_80112E38 0x80112E38 : AT(0x00093E38) { build/asm/data/main_80112E38.bin.o(.data); }
    .main_80113800 0x80113800 : AT(0x00094800) { FILL(0x00000000); build/asm/main_80113800.s.o(.text); build/asm/main_80113800.s.o(.rodata); build/asm/main_80113800.s.o(.data); }
    .main_80113800_bss (NOLOAD) : { build/asm/main_80113800.s.o(.bss); }
    .main_80113860 0x80113860 : AT(0x00094860) { build/asm/data/main_80113860.bin.o(.data); }
    .main_80113990 0x80113990 : AT(0x00094990) { FILL(0x00000000); build/asm/main_80113990.s.o(.text); build/asm/main_80113990.s.o(.rodata); build/asm/main_80113990.s.o(.data); }
    .main_80113990_bss (NOLOAD) : { build/asm/main_80113990.s.o(.bss); }
    .main_801139A0 0x801139A0 : AT(0x000949A0) { build/asm/data/main_801139A0.bin.o(.data); }
    .main_801146E8 0x801146E8 : AT(0x000956E8) { FILL(0x00000000); build/asm/main_801146E8.s.o(.text); build/asm/main_801146E8.s.o(.rodata); build/asm/main_801146E8.s.o(.data); }
    .main_801146E8_bss (NOLOAD) : { build/asm/main_801146E8.s.o(.bss); }
    .main_80114778 0x80114778 : AT(0x00095778) { build/asm/data/main_80114778.bin.o(.data); }
    .main_80114B80 0x80114B80 : AT(0x00095B80) { FILL(0x00000000); build/asm/main_80114B80.s.o(.text); build/asm/main_80114B80.s.o(.rodata); build/asm/main_80114B80.s.o(.data); }
    .main_80114B80_bss (NOLOAD) : { build/asm/main_80114B80.s.o(.bss); }
    .main_80114BC8 0x80114BC8 : AT(0x00095BC8) { build/asm/data/main_80114BC8.bin.o(.data); }
    .main_80114F7C 0x80114F7C : AT(0x00095F7C) { FILL(0x00000000); build/asm/main_80114F7C.s.o(.text); build/asm/main_80114F7C.s.o(.rodata); build/asm/main_80114F7C.s.o(.data); }
    .main_80114F7C_bss (NOLOAD) : { build/asm/main_80114F7C.s.o(.bss); }
    .main_801151B0 0x801151B0 : AT(0x000961B0) { FILL(0x00000000); build/asm/main_801151B0.s.o(.text); build/asm/main_801151B0.s.o(.rodata); build/asm/main_801151B0.s.o(.data); }
    .main_801151B0_bss (NOLOAD) : { build/asm/main_801151B0.s.o(.bss); }
    .main_801151F0 0x801151F0 : AT(0x000961F0) { build/asm/data/main_801151F0.bin.o(.data); }
    .main_80115500 0x80115500 : AT(0x00096500) { FILL(0x00000000); build/asm/main_80115500.s.o(.text); build/asm/main_80115500.s.o(.rodata); build/asm/main_80115500.s.o(.data); }
    .main_80115500_bss (NOLOAD) : { build/asm/main_80115500.s.o(.bss); }
    .main_80115578 0x80115578 : AT(0x00096578) { build/asm/data/main_80115578.bin.o(.data); }
    .main_80116758 0x80116758 : AT(0x00097758) { FILL(0x00000000); build/asm/main_80116758.s.o(.text); build/asm/main_80116758.s.o(.rodata); build/asm/main_80116758.s.o(.data); }
    .main_80116758_bss (NOLOAD) : { build/asm/main_80116758.s.o(.bss); }
    .main_80117168 0x80117168 : AT(0x00098168) { build/asm/data/main_80117168.bin.o(.data); }
    .main_801177F8 0x801177F8 : AT(0x000987F8) { build/asm/data/main_801177F8.bin.o(.data); }
    .main_8011859C 0x8011859C : AT(0x0009959C) { FILL(0x00000000); build/asm/main_8011859C.s.o(.text); build/asm/main_8011859C.s.o(.rodata); build/asm/main_8011859C.s.o(.data); }
    .main_8011859C_bss (NOLOAD) : { build/asm/main_8011859C.s.o(.bss); }
    .main_801189F4 0x801189F4 : AT(0x000999F4) { build/asm/data/main_801189F4.bin.o(.data); }
    .main_80119094 0x80119094 : AT(0x0009A094) { FILL(0x00000000); build/asm/main_80119094.s.o(.text); build/asm/main_80119094.s.o(.rodata); build/asm/main_80119094.s.o(.data); }
    .main_80119094_bss (NOLOAD) : { build/asm/main_80119094.s.o(.bss); }
    .main_801190DC 0x801190DC : AT(0x0009A0DC) { build/asm/data/main_801190DC.bin.o(.data); }
    .main_80119DC8 0x80119DC8 : AT(0x0009ADC8) { build/asm/data/main_80119DC8.bin.o(.data); }
    .main_8011A480 0x8011A480 : AT(0x0009B480) { build/asm/data/main_8011A480.bin.o(.data); }
    .main_8011AE38 0x8011AE38 : AT(0x0009BE38) { FILL(0x00000000); build/asm/main_8011AE38.s.o(.text); build/asm/main_8011AE38.s.o(.rodata); build/asm/main_8011AE38.s.o(.data); }
    .main_8011AE38_bss (NOLOAD) : { build/asm/main_8011AE38.s.o(.bss); }
    .main_8011AF5C 0x8011AF5C : AT(0x0009BF5C) { build/asm/data/main_8011AF5C.bin.o(.data); }
    .main_8011B274 0x8011B274 : AT(0x0009C274) { build/asm/data/main_8011B274.bin.o(.data); }
    .main_8011B744 0x8011B744 : AT(0x0009C744) { build/asm/data/main_8011B744.bin.o(.data); }
    .main_8011BC7C 0x8011BC7C : AT(0x0009CC7C) { build/asm/data/main_8011BC7C.bin.o(.data); }
    .main_8011C350 0x8011C350 : AT(0x0009D350) { build/asm/data/main_8011C350.bin.o(.data); }
    .main_8011C81C 0x8011C81C : AT(0x0009D81C) { FILL(0x00000000); build/asm/main_8011C81C.s.o(.text); build/asm/main_8011C81C.s.o(.rodata); build/asm/main_8011C81C.s.o(.data); }
    .main_8011C81C_bss (NOLOAD) : { build/asm/main_8011C81C.s.o(.bss); }
    .main_8011D15C 0x8011D15C : AT(0x0009E15C) { build/asm/data/main_8011D15C.bin.o(.data); }
    .main_8011DD00 0x8011DD00 : AT(0x0009ED00) { FILL(0x00000000); build/asm/main_8011DD00.s.o(.text); build/asm/main_8011DD00.s.o(.rodata); build/asm/main_8011DD00.s.o(.data); }
    .main_8011DD00_bss (NOLOAD) : { build/asm/main_8011DD00.s.o(.bss); }
    .main_8011DD2C 0x8011DD2C : AT(0x0009ED2C) { build/asm/data/main_8011DD2C.bin.o(.data); }
    .main_8011ECA4 0x8011ECA4 : AT(0x0009FCA4) { build/asm/data/main_8011ECA4.bin.o(.data); }
    .main_8011F4A8 0x8011F4A8 : AT(0x000A04A8) { FILL(0x00000000); build/asm/main_8011F4A8.s.o(.text); build/asm/main_8011F4A8.s.o(.rodata); build/asm/main_8011F4A8.s.o(.data); }
    .main_8011F4A8_bss (NOLOAD) : { build/asm/main_8011F4A8.s.o(.bss); }
    .main_8011F87C 0x8011F87C : AT(0x000A087C) { build/asm/data/main_8011F87C.bin.o(.data); }
    .main_801215D0 0x801215D0 : AT(0x000A25D0) { FILL(0x00000000); build/asm/main_801215D0.s.o(.text); build/asm/main_801215D0.s.o(.rodata); build/asm/main_801215D0.s.o(.data); }
    .main_801215D0_bss (NOLOAD) : { build/asm/main_801215D0.s.o(.bss); }
    .main_801215E4 0x801215E4 : AT(0x000A25E4) { build/asm/data/main_801215E4.bin.o(.data); }
    .main_80122AAC 0x80122AAC : AT(0x000A3AAC) { FILL(0x00000000); build/asm/main_80122AAC.s.o(.text); build/asm/main_80122AAC.s.o(.rodata); build/asm/main_80122AAC.s.o(.data); }
    .main_80122AAC_bss (NOLOAD) : { build/asm/main_80122AAC.s.o(.bss); }
    .main_80122AB8 0x80122AB8 : AT(0x000A3AB8) { build/asm/data/main_80122AB8.bin.o(.data); }
    .main_80123218 0x80123218 : AT(0x000A4218) { FILL(0x00000000); build/asm/main_80123218.s.o(.text); build/asm/main_80123218.s.o(.rodata); build/asm/main_80123218.s.o(.data); }
    .main_80123218_bss (NOLOAD) : { build/asm/main_80123218.s.o(.bss); }
    .main_80123230 0x80123230 : AT(0x000A4230) { build/asm/data/main_80123230.bin.o(.data); }
    .main_80125494 0x80125494 : AT(0x000A6494) { FILL(0x00000000); build/asm/main_80125494.s.o(.text); build/asm/main_80125494.s.o(.rodata); build/asm/main_80125494.s.o(.data); }
    .main_80125494_bss (NOLOAD) : { build/asm/main_80125494.s.o(.bss); }
    .main_801254B4 0x801254B4 : AT(0x000A64B4) { build/asm/data/main_801254B4.bin.o(.data); }
    .main_801258A8 0x801258A8 : AT(0x000A68A8) { build/asm/data/main_801258A8.bin.o(.data); }
    .main_801260A8 0x801260A8 : AT(0x000A70A8) { FILL(0x00000000); build/asm/main_801260A8.s.o(.text); build/asm/main_801260A8.s.o(.rodata); build/asm/main_801260A8.s.o(.data); }
    .main_801260A8_bss (NOLOAD) : { build/asm/main_801260A8.s.o(.bss); }
    .main_801260B0 0x801260B0 : AT(0x000A70B0) { build/asm/data/main_801260B0.bin.o(.data); }
    .main_80127E4C 0x80127E4C : AT(0x000A8E4C) { FILL(0x00000000); build/asm/main_80127E4C.s.o(.text); build/asm/main_80127E4C.s.o(.rodata); build/asm/main_80127E4C.s.o(.data); }
    .main_80127E4C_bss (NOLOAD) : { build/asm/main_80127E4C.s.o(.bss); }
    .main_80127E70 0x80127E70 : AT(0x000A8E70) { build/asm/data/main_80127E70.bin.o(.data); }
    .main_80128D74 0x80128D74 : AT(0x000A9D74) { FILL(0x00000000); build/asm/main_80128D74.s.o(.text); build/asm/main_80128D74.s.o(.rodata); build/asm/main_80128D74.s.o(.data); }
    .main_80128D74_bss (NOLOAD) : { build/asm/main_80128D74.s.o(.bss); }
    .main_80128D88 0x80128D88 : AT(0x000A9D88) { build/asm/data/main_80128D88.bin.o(.data); }
    .main_8012AA60 0x8012AA60 : AT(0x000ABA60) { FILL(0x00000000); build/asm/main_8012AA60.s.o(.text); build/asm/main_8012AA60.s.o(.rodata); build/asm/main_8012AA60.s.o(.data); }
    .main_8012AA60_bss (NOLOAD) : { build/asm/main_8012AA60.s.o(.bss); }
    .main_8012AA80 0x8012AA80 : AT(0x000ABA80) { build/asm/data/main_8012AA80.bin.o(.data); }
    .main_8012AE80 0x8012AE80 : AT(0x000ABE80) { FILL(0x00000000); build/asm/main_8012AE80.s.o(.text); build/asm/main_8012AE80.s.o(.rodata); build/asm/main_8012AE80.s.o(.data); }
    .main_8012AE80_bss (NOLOAD) : { build/asm/main_8012AE80.s.o(.bss); }
    .main_8012AE8C 0x8012AE8C : AT(0x000ABE8C) { build/asm/data/main_8012AE8C.bin.o(.data); }
    .main_80133784 0x80133784 : AT(0x000B4784) { FILL(0x00000000); build/asm/main_80133784.s.o(.text); build/asm/main_80133784.s.o(.rodata); build/asm/main_80133784.s.o(.data); }
    .main_80133784_bss (NOLOAD) : { build/asm/main_80133784.s.o(.bss); }
    .main_80133790 0x80133790 : AT(0x000B4790) { build/asm/data/main_80133790.bin.o(.data); }
    .main_80133F50 0x80133F50 : AT(0x000B4F50) { FILL(0x00000000); build/asm/main_80133F50.s.o(.text); build/asm/main_80133F50.s.o(.rodata); build/asm/main_80133F50.s.o(.data); }
    .main_80133F50_bss (NOLOAD) : { build/asm/main_80133F50.s.o(.bss); }
    .main_80133F5C 0x80133F5C : AT(0x000B4F5C) { build/asm/data/main_80133F5C.bin.o(.data); }
    .main_80134E18 0x80134E18 : AT(0x000B5E18) { FILL(0x00000000); build/asm/main_80134E18.s.o(.text); build/asm/main_80134E18.s.o(.rodata); build/asm/main_80134E18.s.o(.data); }
    .main_80134E18_bss (NOLOAD) : { build/asm/main_80134E18.s.o(.bss); }
    .main_80134E58 0x80134E58 : AT(0x000B5E58) { build/asm/data/main_80134E58.bin.o(.data); }
    .main_80137014 0x80137014 : AT(0x000B8014) { FILL(0x00000000); build/asm/main_80137014.s.o(.text); build/asm/main_80137014.s.o(.rodata); build/asm/main_80137014.s.o(.data); }
    .main_80137014_bss (NOLOAD) : { build/asm/main_80137014.s.o(.bss); }
    .main_8013702C 0x8013702C : AT(0x000B802C) { build/asm/data/main_8013702C.bin.o(.data); }
    .main_80137ABC 0x80137ABC : AT(0x000B8ABC) { FILL(0x00000000); build/asm/main_80137ABC.s.o(.text); build/asm/main_80137ABC.s.o(.rodata); build/asm/main_80137ABC.s.o(.data); }
    .main_80137ABC_bss (NOLOAD) : { build/asm/main_80137ABC.s.o(.bss); }
    .main_80137ACC 0x80137ACC : AT(0x000B8ACC) { build/asm/data/main_80137ACC.bin.o(.data); }
    .main_801390B0 0x801390B0 : AT(0x000BA0B0) { FILL(0x00000000); build/asm/main_801390B0.s.o(.text); build/asm/main_801390B0.s.o(.rodata); build/asm/main_801390B0.s.o(.data); }
    .main_801390B0_bss (NOLOAD) : { build/asm/main_801390B0.s.o(.bss); }
    .main_80139110 0x80139110 : AT(0x000BA110) { build/asm/data/main_80139110.bin.o(.data); }
    .main_80139208 0x80139208 : AT(0x000BA208) { FILL(0x00000000); build/asm/main_80139208.s.o(.text); build/asm/main_80139208.s.o(.rodata); build/asm/main_80139208.s.o(.data); }
    .main_80139208_bss (NOLOAD) : { build/asm/main_80139208.s.o(.bss); }
    .main_80139268 0x80139268 : AT(0x000BA268) { build/asm/data/main_80139268.bin.o(.data); }
    .main_8013C5C0 0x8013C5C0 : AT(0x000BD5C0) { FILL(0x00000000); build/asm/main_8013C5C0.s.o(.text); build/asm/main_8013C5C0.s.o(.rodata); build/asm/main_8013C5C0.s.o(.data); }
    .main_8013C5C0_bss (NOLOAD) : { build/asm/main_8013C5C0.s.o(.bss); }
    .main_8013C5DC 0x8013C5DC : AT(0x000BD5DC) { build/asm/data/main_8013C5DC.bin.o(.data); }
    .main_8013F49C 0x8013F49C : AT(0x000C049C) { FILL(0x00000000); build/asm/main_8013F49C.s.o(.text); build/asm/main_8013F49C.s.o(.rodata); build/asm/main_8013F49C.s.o(.data); }
    .main_8013F49C_bss (NOLOAD) : { build/asm/main_8013F49C.s.o(.bss); }
    .main_8013F4A8 0x8013F4A8 : AT(0x000C04A8) { build/asm/data/main_8013F4A8.bin.o(.data); }
    .main_801404D0 0x801404D0 : AT(0x000C14D0) { FILL(0x00000000); build/asm/main_801404D0.s.o(.text); build/asm/main_801404D0.s.o(.rodata); build/asm/main_801404D0.s.o(.data); }
    .main_801404D0_bss (NOLOAD) : { build/asm/main_801404D0.s.o(.bss); }
    .main_80140500 0x80140500 : AT(0x000C1500) { build/asm/data/main_80140500.bin.o(.data); }
    .main_80140AF0 0x80140AF0 : AT(0x000C1AF0) { FILL(0x00000000); build/asm/main_80140AF0.s.o(.text); build/asm/main_80140AF0.s.o(.rodata); build/asm/main_80140AF0.s.o(.data); }
    .main_80140AF0_bss (NOLOAD) : { build/asm/main_80140AF0.s.o(.bss); }
    .main_80140AF4 0x80140AF4 : AT(0x000C1AF4) { build/asm/data/main_80140AF4.bin.o(.data); }
    .main_80141F88 0x80141F88 : AT(0x000C2F88) { FILL(0x00000000); build/asm/main_80141F88.s.o(.text); build/asm/main_80141F88.s.o(.rodata); build/asm/main_80141F88.s.o(.data); }
    .main_80141F88_bss (NOLOAD) : { build/asm/main_80141F88.s.o(.bss); }
    .main_80141F90 0x80141F90 : AT(0x000C2F90) { build/asm/data/main_80141F90.bin.o(.data); }
    .main_80142D00 0x80142D00 : AT(0x000C3D00) { FILL(0x00000000); build/asm/main_80142D00.s.o(.text); build/asm/main_80142D00.s.o(.rodata); build/asm/main_80142D00.s.o(.data); }
    .main_80142D00_bss (NOLOAD) : { build/asm/main_80142D00.s.o(.bss); }
    .main_80142D14 0x80142D14 : AT(0x000C3D14) { build/asm/data/main_80142D14.bin.o(.data); }
    .main_80143678 0x80143678 : AT(0x000C4678) { FILL(0x00000000); build/asm/main_80143678.s.o(.text); build/asm/main_80143678.s.o(.rodata); build/asm/main_80143678.s.o(.data); }
    .main_80143678_bss (NOLOAD) : { build/asm/main_80143678.s.o(.bss); }
    .main_80143694 0x80143694 : AT(0x000C4694) { build/asm/data/main_80143694.bin.o(.data); }
    .main_801439CC 0x801439CC : AT(0x000C49CC) { FILL(0x00000000); build/asm/main_801439CC.s.o(.text); build/asm/main_801439CC.s.o(.rodata); build/asm/main_801439CC.s.o(.data); }
    .main_801439CC_bss (NOLOAD) : { build/asm/main_801439CC.s.o(.bss); }
    .main_801439D0 0x801439D0 : AT(0x000C49D0) { build/asm/data/main_801439D0.bin.o(.data); }
    .main_8014B4C0 0x8014B4C0 : AT(0x000CC4C0) { FILL(0x00000000); build/asm/main_8014B4C0.s.o(.text); build/asm/main_8014B4C0.s.o(.rodata); build/asm/main_8014B4C0.s.o(.data); }
    .main_8014B4C0_bss (NOLOAD) : { build/asm/main_8014B4C0.s.o(.bss); }
    .main_8014B4D0 0x8014B4D0 : AT(0x000CC4D0) { build/asm/data/main_8014B4D0.bin.o(.data); }
    .main_8014F31C 0x8014F31C : AT(0x000D031C) { FILL(0x00000000); build/asm/main_8014F31C.s.o(.text); build/asm/main_8014F31C.s.o(.rodata); build/asm/main_8014F31C.s.o(.data); }
    .main_8014F31C_bss (NOLOAD) : { build/asm/main_8014F31C.s.o(.bss); }
    .main_8014F33C 0x8014F33C : AT(0x000D033C) { build/asm/data/main_8014F33C.bin.o(.data); }
    .main_80154E78 0x80154E78 : AT(0x000D5E78) { FILL(0x00000000); build/asm/main_80154E78.s.o(.text); build/asm/main_80154E78.s.o(.rodata); build/asm/main_80154E78.s.o(.data); }
    .main_80154E78_bss (NOLOAD) : { build/asm/main_80154E78.s.o(.bss); }
    .main_80154E7C 0x80154E7C : AT(0x000D5E7C) { build/asm/data/main_80154E7C.bin.o(.data); }
    .main_80155F50 0x80155F50 : AT(0x000D6F50) { FILL(0x00000000); build/asm/main_80155F50.s.o(.text); build/asm/main_80155F50.s.o(.rodata); build/asm/main_80155F50.s.o(.data); }
    .main_80155F50_bss (NOLOAD) : { build/asm/main_80155F50.s.o(.bss); }
    .main_80155F54 0x80155F54 : AT(0x000D6F54) { build/asm/data/main_80155F54.bin.o(.data); }
    .main_80159E04 0x80159E04 : AT(0x000DAE04) { FILL(0x00000000); build/asm/main_80159E04.s.o(.text); build/asm/main_80159E04.s.o(.rodata); build/asm/main_80159E04.s.o(.data); }
    .main_80159E04_bss (NOLOAD) : { build/asm/main_80159E04.s.o(.bss); }
    .main_80159E3C 0x80159E3C : AT(0x000DAE3C) { build/asm/data/main_80159E3C.bin.o(.data); }
    .main_80162F04 0x80162F04 : AT(0x000E3F04) { FILL(0x00000000); build/asm/main_80162F04.s.o(.text); build/asm/main_80162F04.s.o(.rodata); build/asm/main_80162F04.s.o(.data); }
    .main_80162F04_bss (NOLOAD) : { build/asm/main_80162F04.s.o(.bss); }
    .main_80162F18 0x80162F18 : AT(0x000E3F18) { build/asm/data/main_80162F18.bin.o(.data); }
    .main_8016C8F8 0x8016C8F8 : AT(0x000ED8F8) { FILL(0x00000000); build/asm/main_8016C8F8.s.o(.text); build/asm/main_8016C8F8.s.o(.rodata); build/asm/main_8016C8F8.s.o(.data); }
    .main_8016C8F8_bss (NOLOAD) : { build/asm/main_8016C8F8.s.o(.bss); }
    .main_8016C8FC 0x8016C8FC : AT(0x000ED8FC) { build/asm/data/main_8016C8FC.bin.o(.data); }
    .main_8016FDB8 0x8016FDB8 : AT(0x000F0DB8) { FILL(0x00000000); build/asm/main_8016FDB8.s.o(.text); build/asm/main_8016FDB8.s.o(.rodata); build/asm/main_8016FDB8.s.o(.data); }
    .main_8016FDB8_bss (NOLOAD) : { build/asm/main_8016FDB8.s.o(.bss); }
    .main_8016FDE0 0x8016FDE0 : AT(0x000F0DE0) { build/asm/data/main_8016FDE0.bin.o(.data); }
    .main_80176168 0x80176168 : AT(0x000F7168) { FILL(0x00000000); build/asm/main_80176168.s.o(.text); build/asm/main_80176168.s.o(.rodata); build/asm/main_80176168.s.o(.data); }
    .main_80176168_bss (NOLOAD) : { build/asm/main_80176168.s.o(.bss); }
    .main_801761A0 0x801761A0 : AT(0x000F71A0) { build/asm/data/main_801761A0.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
