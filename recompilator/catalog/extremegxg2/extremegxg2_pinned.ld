SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_8004B400 0x8004B400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_8004B400.s.o(.text); build/asm/main_8004B400.s.o(.rodata); build/asm/main_8004B400.s.o(.data); }
    .main_8004B400_bss (NOLOAD) : { build/asm/main_8004B400.s.o(.bss); }
    .main_8004B498 0x8004B498 : AT(0x00001098) { FILL(0x00000000); build/asm/main_8004B498.s.o(.text); build/asm/main_8004B498.s.o(.rodata); build/asm/main_8004B498.s.o(.data); }
    .main_8004B498_bss (NOLOAD) : { build/asm/main_8004B498.s.o(.bss); }
    .main_8004B7BC 0x8004B7BC : AT(0x000013BC) { FILL(0x00000000); build/asm/main_8004B7BC.s.o(.text); build/asm/main_8004B7BC.s.o(.rodata); build/asm/main_8004B7BC.s.o(.data); }
    .main_8004B7BC_bss (NOLOAD) : { build/asm/main_8004B7BC.s.o(.bss); }
    .main_8004BA20 0x8004BA20 : AT(0x00001620) { build/asm/data/main_8004BA20.bin.o(.data); }
    .main_8004BC20 0x8004BC20 : AT(0x00001820) { build/asm/data/main_8004BC20.bin.o(.data); }
    .main_8005CC2C 0x8005CC2C : AT(0x0001282C) { build/asm/data/main_8005CC2C.bin.o(.data); }
    .main_8005CCE0 0x8005CCE0 : AT(0x000128E0) { build/asm/data/main_8005CCE0.bin.o(.data); }
    .main_8005DC30 0x8005DC30 : AT(0x00013830) { build/asm/data/main_8005DC30.bin.o(.data); }
    .main_8005DD44 0x8005DD44 : AT(0x00013944) { build/asm/data/main_8005DD44.bin.o(.data); }
    .main_8006412C 0x8006412C : AT(0x00019D2C) { build/asm/data/main_8006412C.bin.o(.data); }
    .main_80064280 0x80064280 : AT(0x00019E80) { build/asm/data/main_80064280.bin.o(.data); }
    .main_8006F0D0 0x8006F0D0 : AT(0x00024CD0) { build/asm/data/main_8006F0D0.bin.o(.data); }
    .main_8006F178 0x8006F178 : AT(0x00024D78) { build/asm/data/main_8006F178.bin.o(.data); }
    .main_8007180C 0x8007180C : AT(0x0002740C) { build/asm/data/main_8007180C.bin.o(.data); }
    .main_800718D0 0x800718D0 : AT(0x000274D0) { build/asm/data/main_800718D0.bin.o(.data); }
    .main_80077B1C 0x80077B1C : AT(0x0002D71C) { build/asm/data/main_80077B1C.bin.o(.data); }
    .main_80077B34 0x80077B34 : AT(0x0002D734) { build/asm/data/main_80077B34.bin.o(.data); }
    .main_800858EC 0x800858EC : AT(0x0003B4EC) { build/asm/data/main_800858EC.bin.o(.data); }
    .main_800858F8 0x800858F8 : AT(0x0003B4F8) { build/asm/data/main_800858F8.bin.o(.data); }
    .main_8008CEF4 0x8008CEF4 : AT(0x00042AF4) { build/asm/data/main_8008CEF4.bin.o(.data); }
    .main_8008CF18 0x8008CF18 : AT(0x00042B18) { build/asm/data/main_8008CF18.bin.o(.data); }
    .main_800A4604 0x800A4604 : AT(0x0005A204) { build/asm/data/main_800A4604.bin.o(.data); }
    .main_800A4644 0x800A4644 : AT(0x0005A244) { build/asm/data/main_800A4644.bin.o(.data); }
    .main_800B3E44 0x800B3E44 : AT(0x00069A44) { build/asm/data/main_800B3E44.bin.o(.data); }
    .main_800B3E68 0x800B3E68 : AT(0x00069A68) { build/asm/data/main_800B3E68.bin.o(.data); }
    .main_800C1EA0 0x800C1EA0 : AT(0x00077AA0) { build/asm/data/main_800C1EA0.bin.o(.data); }
    .main_800C1EC4 0x800C1EC4 : AT(0x00077AC4) { build/asm/data/main_800C1EC4.bin.o(.data); }
    .main_800E8F00 0x800E8F00 : AT(0x0009EB00) { build/asm/data/main_800E8F00.bin.o(.data); }
    .main_800E8F14 0x800E8F14 : AT(0x0009EB14) { build/asm/data/main_800E8F14.bin.o(.data); }
    .main_800ECD58 0x800ECD58 : AT(0x000A2958) { build/asm/data/main_800ECD58.bin.o(.data); }
    .main_800ECD64 0x800ECD64 : AT(0x000A2964) { build/asm/data/main_800ECD64.bin.o(.data); }
    .main_800F3D0C 0x800F3D0C : AT(0x000A990C) { build/asm/data/main_800F3D0C.bin.o(.data); }
    .main_800F3D10 0x800F3D10 : AT(0x000A9910) { build/asm/data/main_800F3D10.bin.o(.data); }
    .main_800FAE7C 0x800FAE7C : AT(0x000B0A7C) { build/asm/data/main_800FAE7C.bin.o(.data); }
    .main_800FAEAC 0x800FAEAC : AT(0x000B0AAC) { build/asm/data/main_800FAEAC.bin.o(.data); }
    .main_800FBFB4 0x800FBFB4 : AT(0x000B1BB4) { build/asm/data/main_800FBFB4.bin.o(.data); }
    .main_800FBFD8 0x800FBFD8 : AT(0x000B1BD8) { build/asm/data/main_800FBFD8.bin.o(.data); }
    .main_800FF268 0x800FF268 : AT(0x000B4E68) { build/asm/data/main_800FF268.bin.o(.data); }
    .main_800FF2B0 0x800FF2B0 : AT(0x000B4EB0) { build/asm/data/main_800FF2B0.bin.o(.data); }
    .main_801051F0 0x801051F0 : AT(0x000BADF0) { build/asm/data/main_801051F0.bin.o(.data); }
    .main_80105224 0x80105224 : AT(0x000BAE24) { build/asm/data/main_80105224.bin.o(.data); }
    .main_801064CC 0x801064CC : AT(0x000BC0CC) { build/asm/data/main_801064CC.bin.o(.data); }
    .main_801064D0 0x801064D0 : AT(0x000BC0D0) { build/asm/data/main_801064D0.bin.o(.data); }
    .main_80118434 0x80118434 : AT(0x000CE034) { build/asm/data/main_80118434.bin.o(.data); }
    .main_80118464 0x80118464 : AT(0x000CE064) { build/asm/data/main_80118464.bin.o(.data); }
    .main_801191A4 0x801191A4 : AT(0x000CEDA4) { build/asm/data/main_801191A4.bin.o(.data); }
    .main_80119248 0x80119248 : AT(0x000CEE48) { build/asm/data/main_80119248.bin.o(.data); }
    .main_8011BFD8 0x8011BFD8 : AT(0x000D1BD8) { build/asm/data/main_8011BFD8.bin.o(.data); }
    .main_8011BFF0 0x8011BFF0 : AT(0x000D1BF0) { build/asm/data/main_8011BFF0.bin.o(.data); }
    .main_80125130 0x80125130 : AT(0x000DAD30) { build/asm/data/main_80125130.bin.o(.data); }
    .main_80125164 0x80125164 : AT(0x000DAD64) { build/asm/data/main_80125164.bin.o(.data); }
    .main_801290AC 0x801290AC : AT(0x000DECAC) { build/asm/data/main_801290AC.bin.o(.data); }
    .main_801290E8 0x801290E8 : AT(0x000DECE8) { build/asm/data/main_801290E8.bin.o(.data); }
    .main_80129C54 0x80129C54 : AT(0x000DF854) { build/asm/data/main_80129C54.bin.o(.data); }
    .main_80129E6C 0x80129E6C : AT(0x000DFA6C) { build/asm/data/main_80129E6C.bin.o(.data); }
    .main_8012C2D8 0x8012C2D8 : AT(0x000E1ED8) { build/asm/data/main_8012C2D8.bin.o(.data); }
    .main_8012C3BC 0x8012C3BC : AT(0x000E1FBC) { build/asm/data/main_8012C3BC.bin.o(.data); }
    .main_8012F8A0 0x8012F8A0 : AT(0x000E54A0) { build/asm/data/main_8012F8A0.bin.o(.data); }
    .main_8012F8BC 0x8012F8BC : AT(0x000E54BC) { build/asm/data/main_8012F8BC.bin.o(.data); }
    .main_801339BC 0x801339BC : AT(0x000E95BC) { build/asm/data/main_801339BC.bin.o(.data); }
    .main_80133A64 0x80133A64 : AT(0x000E9664) { build/asm/data/main_80133A64.bin.o(.data); }
    .main_801361C8 0x801361C8 : AT(0x000EBDC8) { build/asm/data/main_801361C8.bin.o(.data); }
    .main_80136410 0x80136410 : AT(0x000EC010) { build/asm/data/main_80136410.bin.o(.data); }
    .main_80145DAC 0x80145DAC : AT(0x000FB9AC) { build/asm/data/main_80145DAC.bin.o(.data); }
    .main_80145E10 0x80145E10 : AT(0x000FBA10) { build/asm/data/main_80145E10.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
