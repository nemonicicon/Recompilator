SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80025C00 0x80025C00 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80025C00.s.o(.text); build/asm/main_80025C00.s.o(.rodata); build/asm/main_80025C00.s.o(.data); }
    .main_80025C00_bss (NOLOAD) : { build/asm/main_80025C00.s.o(.bss); }
    .main_80027F00 0x80027F00 : AT(0x00003300) { FILL(0x00000000); build/asm/main_80027F00.s.o(.text); build/asm/main_80027F00.s.o(.rodata); build/asm/main_80027F00.s.o(.data); }
    .main_80027F00_bss (NOLOAD) : { build/asm/main_80027F00.s.o(.bss); }
    .main_80071C38 0x80071C38 : AT(0x0004D038) { build/asm/data/main_80071C38.bin.o(.data); }
    .main_800750F0 0x800750F0 : AT(0x000504F0) { FILL(0x00000000); build/asm/main_800750F0.s.o(.text); build/asm/main_800750F0.s.o(.rodata); build/asm/main_800750F0.s.o(.data); }
    .main_800750F0_bss (NOLOAD) : { build/asm/main_800750F0.s.o(.bss); }
    .main_800753E0 0x800753E0 : AT(0x000507E0) { build/asm/data/main_800753E0.bin.o(.data); }
    .main_80075A20 0x80075A20 : AT(0x00050E20) { FILL(0x00000000); build/asm/main_80075A20.s.o(.text); build/asm/main_80075A20.s.o(.rodata); build/asm/main_80075A20.s.o(.data); }
    .main_80075A20_bss (NOLOAD) : { build/asm/main_80075A20.s.o(.bss); }
    .main_80092130 0x80092130 : AT(0x0006D530) { build/asm/data/main_80092130.bin.o(.data); }
    .main_800932F8 0x800932F8 : AT(0x0006E6F8) { FILL(0x00000000); build/asm/main_800932F8.s.o(.text); build/asm/main_800932F8.s.o(.rodata); build/asm/main_800932F8.s.o(.data); }
    .main_800932F8_bss (NOLOAD) : { build/asm/main_800932F8.s.o(.bss); }
    .main_800936AC 0x800936AC : AT(0x0006EAAC) { build/asm/data/main_800936AC.bin.o(.data); }
    .main_80093B64 0x80093B64 : AT(0x0006EF64) { FILL(0x00000000); build/asm/main_80093B64.s.o(.text); build/asm/main_80093B64.s.o(.rodata); build/asm/main_80093B64.s.o(.data); }
    .main_80093B64_bss (NOLOAD) : { build/asm/main_80093B64.s.o(.bss); }
    .main_80093B8C 0x80093B8C : AT(0x0006EF8C) { build/asm/data/main_80093B8C.bin.o(.data); }
    .main_80093E70 0x80093E70 : AT(0x0006F270) { FILL(0x00000000); build/asm/main_80093E70.s.o(.text); build/asm/main_80093E70.s.o(.rodata); build/asm/main_80093E70.s.o(.data); }
    .main_80093E70_bss (NOLOAD) : { build/asm/main_80093E70.s.o(.bss); }
    .main_80093F30 0x80093F30 : AT(0x0006F330) { build/asm/data/main_80093F30.bin.o(.data); }
    .main_8009446C 0x8009446C : AT(0x0006F86C) { FILL(0x00000000); build/asm/main_8009446C.s.o(.text); build/asm/main_8009446C.s.o(.rodata); build/asm/main_8009446C.s.o(.data); }
    .main_8009446C_bss (NOLOAD) : { build/asm/main_8009446C.s.o(.bss); }
    .main_8009460C 0x8009460C : AT(0x0006FA0C) { build/asm/data/main_8009460C.bin.o(.data); }
    .main_80095784 0x80095784 : AT(0x00070B84) { FILL(0x00000000); build/asm/main_80095784.s.o(.text); build/asm/main_80095784.s.o(.rodata); build/asm/main_80095784.s.o(.data); }
    .main_80095784_bss (NOLOAD) : { build/asm/main_80095784.s.o(.bss); }
    .main_80095924 0x80095924 : AT(0x00070D24) { build/asm/data/main_80095924.bin.o(.data); }
    .main_80095C60 0x80095C60 : AT(0x00071060) { FILL(0x00000000); build/asm/main_80095C60.s.o(.text); build/asm/main_80095C60.s.o(.rodata); build/asm/main_80095C60.s.o(.data); }
    .main_80095C60_bss (NOLOAD) : { build/asm/main_80095C60.s.o(.bss); }
    .main_80095E90 0x80095E90 : AT(0x00071290) { build/asm/data/main_80095E90.bin.o(.data); }
    .main_8009611C 0x8009611C : AT(0x0007151C) { FILL(0x00000000); build/asm/main_8009611C.s.o(.text); build/asm/main_8009611C.s.o(.rodata); build/asm/main_8009611C.s.o(.data); }
    .main_8009611C_bss (NOLOAD) : { build/asm/main_8009611C.s.o(.bss); }
    .main_80096150 0x80096150 : AT(0x00071550) { build/asm/data/main_80096150.bin.o(.data); }
    .main_800962BC 0x800962BC : AT(0x000716BC) { FILL(0x00000000); build/asm/main_800962BC.s.o(.text); build/asm/main_800962BC.s.o(.rodata); build/asm/main_800962BC.s.o(.data); }
    .main_800962BC_bss (NOLOAD) : { build/asm/main_800962BC.s.o(.bss); }
    .main_8009636C 0x8009636C : AT(0x0007176C) { build/asm/data/main_8009636C.bin.o(.data); }
    .main_8009645C 0x8009645C : AT(0x0007185C) { FILL(0x00000000); build/asm/main_8009645C.s.o(.text); build/asm/main_8009645C.s.o(.rodata); build/asm/main_8009645C.s.o(.data); }
    .main_8009645C_bss (NOLOAD) : { build/asm/main_8009645C.s.o(.bss); }
    .main_80096928 0x80096928 : AT(0x00071D28) { build/asm/data/main_80096928.bin.o(.data); }
    .main_80096EB8 0x80096EB8 : AT(0x000722B8) { FILL(0x00000000); build/asm/main_80096EB8.s.o(.text); build/asm/main_80096EB8.s.o(.rodata); build/asm/main_80096EB8.s.o(.data); }
    .main_80096EB8_bss (NOLOAD) : { build/asm/main_80096EB8.s.o(.bss); }
    .main_800971C0 0x800971C0 : AT(0x000725C0) { build/asm/data/main_800971C0.bin.o(.data); }
    .main_80097E10 0x80097E10 : AT(0x00073210) { FILL(0x00000000); build/asm/main_80097E10.s.o(.text); build/asm/main_80097E10.s.o(.rodata); build/asm/main_80097E10.s.o(.data); }
    .main_80097E10_bss (NOLOAD) : { build/asm/main_80097E10.s.o(.bss); }
    .main_80097E44 0x80097E44 : AT(0x00073244) { build/asm/data/main_80097E44.bin.o(.data); }
    .main_80098A60 0x80098A60 : AT(0x00073E60) { FILL(0x00000000); build/asm/main_80098A60.s.o(.text); build/asm/main_80098A60.s.o(.rodata); build/asm/main_80098A60.s.o(.data); }
    .main_80098A60_bss (NOLOAD) : { build/asm/main_80098A60.s.o(.bss); }
    .main_80098ADC 0x80098ADC : AT(0x00073EDC) { build/asm/data/main_80098ADC.bin.o(.data); }
    .main_800991E0 0x800991E0 : AT(0x000745E0) { FILL(0x00000000); build/asm/main_800991E0.s.o(.text); build/asm/main_800991E0.s.o(.rodata); build/asm/main_800991E0.s.o(.data); }
    .main_800991E0_bss (NOLOAD) : { build/asm/main_800991E0.s.o(.bss); }
    .main_8009925C 0x8009925C : AT(0x0007465C) { build/asm/data/main_8009925C.bin.o(.data); }
    .main_8009D1BC 0x8009D1BC : AT(0x000785BC) { FILL(0x00000000); build/asm/main_8009D1BC.s.o(.text); build/asm/main_8009D1BC.s.o(.rodata); build/asm/main_8009D1BC.s.o(.data); }
    .main_8009D1BC_bss (NOLOAD) : { build/asm/main_8009D1BC.s.o(.bss); }
    .main_800C5140 0x800C5140 : AT(0x000A0540) { build/asm/data/main_800C5140.bin.o(.data); }
    .main_800D0150 0x800D0150 : AT(0x000AB550) { FILL(0x00000000); build/asm/main_800D0150.s.o(.text); build/asm/main_800D0150.s.o(.rodata); build/asm/main_800D0150.s.o(.data); }
    .main_800D0150_bss (NOLOAD) : { build/asm/main_800D0150.s.o(.bss); }
    .main_800D017C 0x800D017C : AT(0x000AB57C) { build/asm/data/main_800D017C.bin.o(.data); }
    .main_800D19A4 0x800D19A4 : AT(0x000ACDA4) { FILL(0x00000000); build/asm/main_800D19A4.s.o(.text); build/asm/main_800D19A4.s.o(.rodata); build/asm/main_800D19A4.s.o(.data); }
    .main_800D19A4_bss (NOLOAD) : { build/asm/main_800D19A4.s.o(.bss); }
    .main_800D19D4 0x800D19D4 : AT(0x000ACDD4) { build/asm/data/main_800D19D4.bin.o(.data); }
    .main_800D5DDC 0x800D5DDC : AT(0x000B11DC) { FILL(0x00000000); build/asm/main_800D5DDC.s.o(.text); build/asm/main_800D5DDC.s.o(.rodata); build/asm/main_800D5DDC.s.o(.data); }
    .main_800D5DDC_bss (NOLOAD) : { build/asm/main_800D5DDC.s.o(.bss); }
    .main_800DC038 0x800DC038 : AT(0x000B7438) { build/asm/data/main_800DC038.bin.o(.data); }
    .main_800DC06C 0x800DC06C : AT(0x000B746C) { FILL(0x00000000); build/asm/main_800DC06C.s.o(.text); build/asm/main_800DC06C.s.o(.rodata); build/asm/main_800DC06C.s.o(.data); }
    .main_800DC06C_bss (NOLOAD) : { build/asm/main_800DC06C.s.o(.bss); }
    .main_800DC0BC 0x800DC0BC : AT(0x000B74BC) { build/asm/data/main_800DC0BC.bin.o(.data); }
    .main_800DC0D8 0x800DC0D8 : AT(0x000B74D8) { FILL(0x00000000); build/asm/main_800DC0D8.s.o(.text); build/asm/main_800DC0D8.s.o(.rodata); build/asm/main_800DC0D8.s.o(.data); }
    .main_800DC0D8_bss (NOLOAD) : { build/asm/main_800DC0D8.s.o(.bss); }
    .main_800E183C 0x800E183C : AT(0x000BCC3C) { build/asm/data/main_800E183C.bin.o(.data); }
    .main_800E22D8 0x800E22D8 : AT(0x000BD6D8) { FILL(0x00000000); build/asm/main_800E22D8.s.o(.text); build/asm/main_800E22D8.s.o(.rodata); build/asm/main_800E22D8.s.o(.data); }
    .main_800E22D8_bss (NOLOAD) : { build/asm/main_800E22D8.s.o(.bss); }
    .main_800E4B6C 0x800E4B6C : AT(0x000BFF6C) { build/asm/data/main_800E4B6C.bin.o(.data); }
    .main_800E5170 0x800E5170 : AT(0x000C0570) { FILL(0x00000000); build/asm/main_800E5170.s.o(.text); build/asm/main_800E5170.s.o(.rodata); build/asm/main_800E5170.s.o(.data); }
    .main_800E5170_bss (NOLOAD) : { build/asm/main_800E5170.s.o(.bss); }
    .main_800E5200 0x800E5200 : AT(0x000C0600) { build/asm/data/main_800E5200.bin.o(.data); }
    .main_800E542C 0x800E542C : AT(0x000C082C) { FILL(0x00000000); build/asm/main_800E542C.s.o(.text); build/asm/main_800E542C.s.o(.rodata); build/asm/main_800E542C.s.o(.data); }
    .main_800E542C_bss (NOLOAD) : { build/asm/main_800E542C.s.o(.bss); }
    .main_800EE494 0x800EE494 : AT(0x000C9894) { build/asm/data/main_800EE494.bin.o(.data); }
    .main_800EF188 0x800EF188 : AT(0x000CA588) { FILL(0x00000000); build/asm/main_800EF188.s.o(.text); build/asm/main_800EF188.s.o(.rodata); build/asm/main_800EF188.s.o(.data); }
    .main_800EF188_bss (NOLOAD) : { build/asm/main_800EF188.s.o(.bss); }
    .main_800F211C 0x800F211C : AT(0x000CD51C) { build/asm/data/main_800F211C.bin.o(.data); }
    .main_800F28C4 0x800F28C4 : AT(0x000CDCC4) { FILL(0x00000000); build/asm/main_800F28C4.s.o(.text); build/asm/main_800F28C4.s.o(.rodata); build/asm/main_800F28C4.s.o(.data); }
    .main_800F28C4_bss (NOLOAD) : { build/asm/main_800F28C4.s.o(.bss); }
    .main_800F3998 0x800F3998 : AT(0x000CED98) { build/asm/data/main_800F3998.bin.o(.data); }
    .main_800F4C80 0x800F4C80 : AT(0x000D0080) { FILL(0x00000000); build/asm/main_800F4C80.s.o(.text); build/asm/main_800F4C80.s.o(.rodata); build/asm/main_800F4C80.s.o(.data); }
    .main_800F4C80_bss (NOLOAD) : { build/asm/main_800F4C80.s.o(.bss); }
    .main_800FBD74 0x800FBD74 : AT(0x000D7174) { build/asm/data/main_800FBD74.bin.o(.data); }
    .main_800FC740 0x800FC740 : AT(0x000D7B40) { FILL(0x00000000); build/asm/main_800FC740.s.o(.text); build/asm/main_800FC740.s.o(.rodata); build/asm/main_800FC740.s.o(.data); }
    .main_800FC740_bss (NOLOAD) : { build/asm/main_800FC740.s.o(.bss); }
    .main_800FC7EC 0x800FC7EC : AT(0x000D7BEC) { build/asm/data/main_800FC7EC.bin.o(.data); }
    .main_800FCE70 0x800FCE70 : AT(0x000D8270) { FILL(0x00000000); build/asm/main_800FCE70.s.o(.text); build/asm/main_800FCE70.s.o(.rodata); build/asm/main_800FCE70.s.o(.data); }
    .main_800FCE70_bss (NOLOAD) : { build/asm/main_800FCE70.s.o(.bss); }
    .main_800FCED0 0x800FCED0 : AT(0x000D82D0) { build/asm/data/main_800FCED0.bin.o(.data); }
    .main_800FCF10 0x800FCF10 : AT(0x000D8310) { FILL(0x00000000); build/asm/main_800FCF10.s.o(.text); build/asm/main_800FCF10.s.o(.rodata); build/asm/main_800FCF10.s.o(.data); }
    .main_800FCF10_bss (NOLOAD) : { build/asm/main_800FCF10.s.o(.bss); }
    .main_800FCFB0 0x800FCFB0 : AT(0x000D83B0) { build/asm/data/main_800FCFB0.bin.o(.data); }
    .main_800FCFC4 0x800FCFC4 : AT(0x000D83C4) { FILL(0x00000000); build/asm/main_800FCFC4.s.o(.text); build/asm/main_800FCFC4.s.o(.rodata); build/asm/main_800FCFC4.s.o(.data); }
    .main_800FCFC4_bss (NOLOAD) : { build/asm/main_800FCFC4.s.o(.bss); }
    .main_800FD000 0x800FD000 : AT(0x000D8400) { build/asm/data/main_800FD000.bin.o(.data); }
    .main_800FD11C 0x800FD11C : AT(0x000D851C) { FILL(0x00000000); build/asm/main_800FD11C.s.o(.text); build/asm/main_800FD11C.s.o(.rodata); build/asm/main_800FD11C.s.o(.data); }
    .main_800FD11C_bss (NOLOAD) : { build/asm/main_800FD11C.s.o(.bss); }
    .main_800FD144 0x800FD144 : AT(0x000D8544) { build/asm/data/main_800FD144.bin.o(.data); }
    .main_800FD614 0x800FD614 : AT(0x000D8A14) { FILL(0x00000000); build/asm/main_800FD614.s.o(.text); build/asm/main_800FD614.s.o(.rodata); build/asm/main_800FD614.s.o(.data); }
    .main_800FD614_bss (NOLOAD) : { build/asm/main_800FD614.s.o(.bss); }
    .main_800FD988 0x800FD988 : AT(0x000D8D88) { build/asm/data/main_800FD988.bin.o(.data); }
    .main_800FEEAC 0x800FEEAC : AT(0x000DA2AC) { FILL(0x00000000); build/asm/main_800FEEAC.s.o(.text); build/asm/main_800FEEAC.s.o(.rodata); build/asm/main_800FEEAC.s.o(.data); }
    .main_800FEEAC_bss (NOLOAD) : { build/asm/main_800FEEAC.s.o(.bss); }
    .main_800FEED8 0x800FEED8 : AT(0x000DA2D8) { build/asm/data/main_800FEED8.bin.o(.data); }
    .main_800FF69C 0x800FF69C : AT(0x000DAA9C) { FILL(0x00000000); build/asm/main_800FF69C.s.o(.text); build/asm/main_800FF69C.s.o(.rodata); build/asm/main_800FF69C.s.o(.data); }
    .main_800FF69C_bss (NOLOAD) : { build/asm/main_800FF69C.s.o(.bss); }
    .main_800FF6A0 0x800FF6A0 : AT(0x000DAAA0) { build/asm/data/main_800FF6A0.bin.o(.data); }
    .main_800FFFF0 0x800FFFF0 : AT(0x000DB3F0) { FILL(0x00000000); build/asm/main_800FFFF0.s.o(.text); build/asm/main_800FFFF0.s.o(.rodata); build/asm/main_800FFFF0.s.o(.data); }
    .main_800FFFF0_bss (NOLOAD) : { build/asm/main_800FFFF0.s.o(.bss); }
    .main_8010008C 0x8010008C : AT(0x000DB48C) { build/asm/data/main_8010008C.bin.o(.data); }
    .main_8010CAC4 0x8010CAC4 : AT(0x000E7EC4) { FILL(0x00000000); build/asm/main_8010CAC4.s.o(.text); build/asm/main_8010CAC4.s.o(.rodata); build/asm/main_8010CAC4.s.o(.data); }
    .main_8010CAC4_bss (NOLOAD) : { build/asm/main_8010CAC4.s.o(.bss); }
    .main_8010CAC8 0x8010CAC8 : AT(0x000E7EC8) { build/asm/data/main_8010CAC8.bin.o(.data); }
    .main_801176B4 0x801176B4 : AT(0x000F2AB4) { FILL(0x00000000); build/asm/main_801176B4.s.o(.text); build/asm/main_801176B4.s.o(.rodata); build/asm/main_801176B4.s.o(.data); }
    .main_801176B4_bss (NOLOAD) : { build/asm/main_801176B4.s.o(.bss); }
    .main_801176D4 0x801176D4 : AT(0x000F2AD4) { build/asm/data/main_801176D4.bin.o(.data); }
    .assets 0x80425C00 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
