SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80040174 0x80040174 : AT(0x00040D74) { FILL(0x00000000); build/asm/main_80040174.s.o(.text); build/asm/main_80040174.s.o(.rodata); build/asm/main_80040174.s.o(.data); }
    .main_80040174_bss (NOLOAD) : { build/asm/main_80040174.s.o(.bss); }
    .main_800CC638 0x800CC638 : AT(0x000CD238) { FILL(0x00000000); build/asm/main_800CC638.s.o(.text); build/asm/main_800CC638.s.o(.rodata); build/asm/main_800CC638.s.o(.data); }
    .main_800CC638_bss (NOLOAD) : { build/asm/main_800CC638.s.o(.bss); }
    .main_800CC930 0x800CC930 : AT(0x000CD530) { FILL(0x00000000); build/asm/main_800CC930.s.o(.text); build/asm/main_800CC930.s.o(.rodata); build/asm/main_800CC930.s.o(.data); }
    .main_800CC930_bss (NOLOAD) : { build/asm/main_800CC930.s.o(.bss); }
    .main_800CCE70 0x800CCE70 : AT(0x000CDA70) { FILL(0x00000000); build/asm/main_800CCE70.s.o(.text); build/asm/main_800CCE70.s.o(.rodata); build/asm/main_800CCE70.s.o(.data); }
    .main_800CCE70_bss (NOLOAD) : { build/asm/main_800CCE70.s.o(.bss); }
    .main_800CD328 0x800CD328 : AT(0x000CDF28) { FILL(0x00000000); build/asm/main_800CD328.s.o(.text); build/asm/main_800CD328.s.o(.rodata); build/asm/main_800CD328.s.o(.data); }
    .main_800CD328_bss (NOLOAD) : { build/asm/main_800CD328.s.o(.bss); }
    .main_800CD65C 0x800CD65C : AT(0x000CE25C) { FILL(0x00000000); build/asm/main_800CD65C.s.o(.text); build/asm/main_800CD65C.s.o(.rodata); build/asm/main_800CD65C.s.o(.data); }
    .main_800CD65C_bss (NOLOAD) : { build/asm/main_800CD65C.s.o(.bss); }
    .main_800CDA60 0x800CDA60 : AT(0x000CE660) { FILL(0x00000000); build/asm/main_800CDA60.s.o(.text); build/asm/main_800CDA60.s.o(.rodata); build/asm/main_800CDA60.s.o(.data); }
    .main_800CDA60_bss (NOLOAD) : { build/asm/main_800CDA60.s.o(.bss); }
    .main_800CDD40 0x800CDD40 : AT(0x000CE940) { FILL(0x00000000); build/asm/main_800CDD40.s.o(.text); build/asm/main_800CDD40.s.o(.rodata); build/asm/main_800CDD40.s.o(.data); }
    .main_800CDD40_bss (NOLOAD) : { build/asm/main_800CDD40.s.o(.bss); }
    .main_800CDE70 0x800CDE70 : AT(0x000CEA70) { FILL(0x00000000); build/asm/main_800CDE70.s.o(.text); build/asm/main_800CDE70.s.o(.rodata); build/asm/main_800CDE70.s.o(.data); }
    .main_800CDE70_bss (NOLOAD) : { build/asm/main_800CDE70.s.o(.bss); }
    .main_800CDF14 0x800CDF14 : AT(0x000CEB14) { FILL(0x00000000); build/asm/main_800CDF14.s.o(.text); build/asm/main_800CDF14.s.o(.rodata); build/asm/main_800CDF14.s.o(.data); }
    .main_800CDF14_bss (NOLOAD) : { build/asm/main_800CDF14.s.o(.bss); }
    .main_800CE008 0x800CE008 : AT(0x000CEC08) { FILL(0x00000000); build/asm/main_800CE008.s.o(.text); build/asm/main_800CE008.s.o(.rodata); build/asm/main_800CE008.s.o(.data); }
    .main_800CE008_bss (NOLOAD) : { build/asm/main_800CE008.s.o(.bss); }
    .main_800CE550 0x800CE550 : AT(0x000CF150) { FILL(0x00000000); build/asm/main_800CE550.s.o(.text); build/asm/main_800CE550.s.o(.rodata); build/asm/main_800CE550.s.o(.data); }
    .main_800CE550_bss (NOLOAD) : { build/asm/main_800CE550.s.o(.bss); }
    .main_800D11B0 0x800D11B0 : AT(0x000D1DB0) { FILL(0x00000000); build/asm/main_800D11B0.s.o(.text); build/asm/main_800D11B0.s.o(.rodata); build/asm/main_800D11B0.s.o(.data); }
    .main_800D11B0_bss (NOLOAD) : { build/asm/main_800D11B0.s.o(.bss); }
    .main_800D16E4 0x800D16E4 : AT(0x000D22E4) { FILL(0x00000000); build/asm/main_800D16E4.s.o(.text); build/asm/main_800D16E4.s.o(.rodata); build/asm/main_800D16E4.s.o(.data); }
    .main_800D16E4_bss (NOLOAD) : { build/asm/main_800D16E4.s.o(.bss); }
    .main_800D1AF0 0x800D1AF0 : AT(0x000D26F0) { FILL(0x00000000); build/asm/main_800D1AF0.s.o(.text); build/asm/main_800D1AF0.s.o(.rodata); build/asm/main_800D1AF0.s.o(.data); }
    .main_800D1AF0_bss (NOLOAD) : { build/asm/main_800D1AF0.s.o(.bss); }
    .main_800D1B60 0x800D1B60 : AT(0x000D2760) { FILL(0x00000000); build/asm/main_800D1B60.s.o(.text); build/asm/main_800D1B60.s.o(.rodata); build/asm/main_800D1B60.s.o(.data); }
    .main_800D1B60_bss (NOLOAD) : { build/asm/main_800D1B60.s.o(.bss); }
    .main_800D1C80 0x800D1C80 : AT(0x000D2880) { FILL(0x00000000); build/asm/main_800D1C80.s.o(.text); build/asm/main_800D1C80.s.o(.rodata); build/asm/main_800D1C80.s.o(.data); }
    .main_800D1C80_bss (NOLOAD) : { build/asm/main_800D1C80.s.o(.bss); }
    .main_800D2A30 0x800D2A30 : AT(0x000D3630) { FILL(0x00000000); build/asm/main_800D2A30.s.o(.text); build/asm/main_800D2A30.s.o(.rodata); build/asm/main_800D2A30.s.o(.data); }
    .main_800D2A30_bss (NOLOAD) : { build/asm/main_800D2A30.s.o(.bss); }
    .main_800D38B0 0x800D38B0 : AT(0x000D44B0) { FILL(0x00000000); build/asm/main_800D38B0.s.o(.text); build/asm/main_800D38B0.s.o(.rodata); build/asm/main_800D38B0.s.o(.data); }
    .main_800D38B0_bss (NOLOAD) : { build/asm/main_800D38B0.s.o(.bss); }
    .main_800D3900 0x800D3900 : AT(0x000D4500) { FILL(0x00000000); build/asm/main_800D3900.s.o(.text); build/asm/main_800D3900.s.o(.rodata); build/asm/main_800D3900.s.o(.data); }
    .main_800D3900_bss (NOLOAD) : { build/asm/main_800D3900.s.o(.bss); }
    .main_800D3AA0 0x800D3AA0 : AT(0x000D46A0) { FILL(0x00000000); build/asm/main_800D3AA0.s.o(.text); build/asm/main_800D3AA0.s.o(.rodata); build/asm/main_800D3AA0.s.o(.data); }
    .main_800D3AA0_bss (NOLOAD) : { build/asm/main_800D3AA0.s.o(.bss); }
    .main_800D3D60 0x800D3D60 : AT(0x000D4960) { FILL(0x00000000); build/asm/main_800D3D60.s.o(.text); build/asm/main_800D3D60.s.o(.rodata); build/asm/main_800D3D60.s.o(.data); }
    .main_800D3D60_bss (NOLOAD) : { build/asm/main_800D3D60.s.o(.bss); }
    .main_800D41C0 0x800D41C0 : AT(0x000D4DC0) { FILL(0x00000000); build/asm/main_800D41C0.s.o(.text); build/asm/main_800D41C0.s.o(.rodata); build/asm/main_800D41C0.s.o(.data); }
    .main_800D41C0_bss (NOLOAD) : { build/asm/main_800D41C0.s.o(.bss); }
    .main_800D7890 0x800D7890 : AT(0x000D8490) { FILL(0x00000000); build/asm/main_800D7890.s.o(.text); build/asm/main_800D7890.s.o(.rodata); build/asm/main_800D7890.s.o(.data); }
    .main_800D7890_bss (NOLOAD) : { build/asm/main_800D7890.s.o(.bss); }
    .main_800D7B70 0x800D7B70 : AT(0x000D8770) { FILL(0x00000000); build/asm/main_800D7B70.s.o(.text); build/asm/main_800D7B70.s.o(.rodata); build/asm/main_800D7B70.s.o(.data); }
    .main_800D7B70_bss (NOLOAD) : { build/asm/main_800D7B70.s.o(.bss); }
    .main_800E2EB8 0x800E2EB8 : AT(0x000E3AB8) { FILL(0x00000000); build/asm/main_800E2EB8.s.o(.text); build/asm/main_800E2EB8.s.o(.rodata); build/asm/main_800E2EB8.s.o(.data); }
    .main_800E2EB8_bss (NOLOAD) : { build/asm/main_800E2EB8.s.o(.bss); }
    .main_800E3C90 0x800E3C90 : AT(0x000E4890) { FILL(0x00000000); build/asm/main_800E3C90.s.o(.text); build/asm/main_800E3C90.s.o(.rodata); build/asm/main_800E3C90.s.o(.data); }
    .main_800E3C90_bss (NOLOAD) : { build/asm/main_800E3C90.s.o(.bss); }
    .main_800E3CE8 0x800E3CE8 : AT(0x000E48E8) { FILL(0x00000000); build/asm/main_800E3CE8.s.o(.text); build/asm/main_800E3CE8.s.o(.rodata); build/asm/main_800E3CE8.s.o(.data); }
    .main_800E3CE8_bss (NOLOAD) : { build/asm/main_800E3CE8.s.o(.bss); }
    .main_800E5644 0x800E5644 : AT(0x000E6244) { FILL(0x00000000); build/asm/main_800E5644.s.o(.text); build/asm/main_800E5644.s.o(.rodata); build/asm/main_800E5644.s.o(.data); }
    .main_800E5644_bss (NOLOAD) : { build/asm/main_800E5644.s.o(.bss); }
    .main_800E6404 0x800E6404 : AT(0x000E7004) { FILL(0x00000000); build/asm/main_800E6404.s.o(.text); build/asm/main_800E6404.s.o(.rodata); build/asm/main_800E6404.s.o(.data); }
    .main_800E6404_bss (NOLOAD) : { build/asm/main_800E6404.s.o(.bss); }
    .main_800E734C 0x800E734C : AT(0x000E7F4C) { FILL(0x00000000); build/asm/main_800E734C.s.o(.text); build/asm/main_800E734C.s.o(.rodata); build/asm/main_800E734C.s.o(.data); }
    .main_800E734C_bss (NOLOAD) : { build/asm/main_800E734C.s.o(.bss); }
    .main_800E7C3C 0x800E7C3C : AT(0x000E883C) { FILL(0x00000000); build/asm/main_800E7C3C.s.o(.text); build/asm/main_800E7C3C.s.o(.rodata); build/asm/main_800E7C3C.s.o(.data); }
    .main_800E7C3C_bss (NOLOAD) : { build/asm/main_800E7C3C.s.o(.bss); }
    .main_800F4540 0x800F4540 : AT(0x000F5140) { build/asm/data/main_800F4540.bin.o(.data); }
    .main_800F4D40 0x800F4D40 : AT(0x000F5940) { build/asm/data/main_800F4D40.bin.o(.data); }
    .main_800F5190 0x800F5190 : AT(0x000F5D90) { build/asm/data/main_800F5190.bin.o(.data); }
    .main_800F5990 0x800F5990 : AT(0x000F6590) { FILL(0x00000000); build/asm/main_800F5990.s.o(.text); build/asm/main_800F5990.s.o(.rodata); build/asm/main_800F5990.s.o(.data); }
    .main_800F5990_bss (NOLOAD) : { build/asm/main_800F5990.s.o(.bss); }
    .main_800F5994 0x800F5994 : AT(0x000F6594) { build/asm/data/main_800F5994.bin.o(.data); }
    .main_800F5A0C 0x800F5A0C : AT(0x000F660C) { build/asm/data/main_800F5A0C.bin.o(.data); }
    .main_800F5C1C 0x800F5C1C : AT(0x000F681C) { FILL(0x00000000); build/asm/main_800F5C1C.s.o(.text); build/asm/main_800F5C1C.s.o(.rodata); build/asm/main_800F5C1C.s.o(.data); }
    .main_800F5C1C_bss (NOLOAD) : { build/asm/main_800F5C1C.s.o(.bss); }
    .main_800F5C84 0x800F5C84 : AT(0x000F6884) { FILL(0x00000000); build/asm/main_800F5C84.s.o(.text); build/asm/main_800F5C84.s.o(.rodata); build/asm/main_800F5C84.s.o(.data); }
    .main_800F5C84_bss (NOLOAD) : { build/asm/main_800F5C84.s.o(.bss); }
    .main_800F5EA4 0x800F5EA4 : AT(0x000F6AA4) { FILL(0x00000000); build/asm/main_800F5EA4.s.o(.text); build/asm/main_800F5EA4.s.o(.rodata); build/asm/main_800F5EA4.s.o(.data); }
    .main_800F5EA4_bss (NOLOAD) : { build/asm/main_800F5EA4.s.o(.bss); }
    .main_800F6194 0x800F6194 : AT(0x000F6D94) { FILL(0x00000000); build/asm/main_800F6194.s.o(.text); build/asm/main_800F6194.s.o(.rodata); build/asm/main_800F6194.s.o(.data); }
    .main_800F6194_bss (NOLOAD) : { build/asm/main_800F6194.s.o(.bss); }
    .main_800F641C 0x800F641C : AT(0x000F701C) { FILL(0x00000000); build/asm/main_800F641C.s.o(.text); build/asm/main_800F641C.s.o(.rodata); build/asm/main_800F641C.s.o(.data); }
    .main_800F641C_bss (NOLOAD) : { build/asm/main_800F641C.s.o(.bss); }
    .main_800F66A4 0x800F66A4 : AT(0x000F72A4) { FILL(0x00000000); build/asm/main_800F66A4.s.o(.text); build/asm/main_800F66A4.s.o(.rodata); build/asm/main_800F66A4.s.o(.data); }
    .main_800F66A4_bss (NOLOAD) : { build/asm/main_800F66A4.s.o(.bss); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
