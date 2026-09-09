SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80096400 0x80096400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80096400.s.o(.text); build/asm/main_80096400.s.o(.rodata); build/asm/main_80096400.s.o(.data); }
    .main_80096400_bss (NOLOAD) : { build/asm/main_80096400.s.o(.bss); }
    .main_801021B0 0x801021B0 : AT(0x0006CDB0) { FILL(0x00000000); build/asm/main_801021B0.s.o(.text); build/asm/main_801021B0.s.o(.rodata); build/asm/main_801021B0.s.o(.data); }
    .main_801021B0_bss (NOLOAD) : { build/asm/main_801021B0.s.o(.bss); }
    .main_80102420 0x80102420 : AT(0x0006D020) { FILL(0x00000000); build/asm/main_80102420.s.o(.text); build/asm/main_80102420.s.o(.rodata); build/asm/main_80102420.s.o(.data); }
    .main_80102420_bss (NOLOAD) : { build/asm/main_80102420.s.o(.bss); }
    .main_80103530 0x80103530 : AT(0x0006E130) { FILL(0x00000000); build/asm/main_80103530.s.o(.text); build/asm/main_80103530.s.o(.rodata); build/asm/main_80103530.s.o(.data); }
    .main_80103530_bss (NOLOAD) : { build/asm/main_80103530.s.o(.bss); }
    .main_80103A20 0x80103A20 : AT(0x0006E620) { FILL(0x00000000); build/asm/main_80103A20.s.o(.text); build/asm/main_80103A20.s.o(.rodata); build/asm/main_80103A20.s.o(.data); }
    .main_80103A20_bss (NOLOAD) : { build/asm/main_80103A20.s.o(.bss); }
    .main_80103E80 0x80103E80 : AT(0x0006EA80) { FILL(0x00000000); build/asm/main_80103E80.s.o(.text); build/asm/main_80103E80.s.o(.rodata); build/asm/main_80103E80.s.o(.data); }
    .main_80103E80_bss (NOLOAD) : { build/asm/main_80103E80.s.o(.bss); }
    .main_80104A50 0x80104A50 : AT(0x0006F650) { FILL(0x00000000); build/asm/main_80104A50.s.o(.text); build/asm/main_80104A50.s.o(.rodata); build/asm/main_80104A50.s.o(.data); }
    .main_80104A50_bss (NOLOAD) : { build/asm/main_80104A50.s.o(.bss); }
    .main_80104C30 0x80104C30 : AT(0x0006F830) { FILL(0x00000000); build/asm/main_80104C30.s.o(.text); build/asm/main_80104C30.s.o(.rodata); build/asm/main_80104C30.s.o(.data); }
    .main_80104C30_bss (NOLOAD) : { build/asm/main_80104C30.s.o(.bss); }
    .main_80104CD0 0x80104CD0 : AT(0x0006F8D0) { FILL(0x00000000); build/asm/main_80104CD0.s.o(.text); build/asm/main_80104CD0.s.o(.rodata); build/asm/main_80104CD0.s.o(.data); }
    .main_80104CD0_bss (NOLOAD) : { build/asm/main_80104CD0.s.o(.bss); }
    .main_801051F0 0x801051F0 : AT(0x0006FDF0) { FILL(0x00000000); build/asm/main_801051F0.s.o(.text); build/asm/main_801051F0.s.o(.rodata); build/asm/main_801051F0.s.o(.data); }
    .main_801051F0_bss (NOLOAD) : { build/asm/main_801051F0.s.o(.bss); }
    .main_80105550 0x80105550 : AT(0x00070150) { FILL(0x00000000); build/asm/main_80105550.s.o(.text); build/asm/main_80105550.s.o(.rodata); build/asm/main_80105550.s.o(.data); }
    .main_80105550_bss (NOLOAD) : { build/asm/main_80105550.s.o(.bss); }
    .main_801058A0 0x801058A0 : AT(0x000704A0) { FILL(0x00000000); build/asm/main_801058A0.s.o(.text); build/asm/main_801058A0.s.o(.rodata); build/asm/main_801058A0.s.o(.data); }
    .main_801058A0_bss (NOLOAD) : { build/asm/main_801058A0.s.o(.bss); }
    .main_80105DF0 0x80105DF0 : AT(0x000709F0) { FILL(0x00000000); build/asm/main_80105DF0.s.o(.text); build/asm/main_80105DF0.s.o(.rodata); build/asm/main_80105DF0.s.o(.data); }
    .main_80105DF0_bss (NOLOAD) : { build/asm/main_80105DF0.s.o(.bss); }
    .main_80106A00 0x80106A00 : AT(0x00071600) { FILL(0x00000000); build/asm/main_80106A00.s.o(.text); build/asm/main_80106A00.s.o(.rodata); build/asm/main_80106A00.s.o(.data); }
    .main_80106A00_bss (NOLOAD) : { build/asm/main_80106A00.s.o(.bss); }
    .main_80106F30 0x80106F30 : AT(0x00071B30) { FILL(0x00000000); build/asm/main_80106F30.s.o(.text); build/asm/main_80106F30.s.o(.rodata); build/asm/main_80106F30.s.o(.data); }
    .main_80106F30_bss (NOLOAD) : { build/asm/main_80106F30.s.o(.bss); }
    .main_80107B70 0x80107B70 : AT(0x00072770) { FILL(0x00000000); build/asm/main_80107B70.s.o(.text); build/asm/main_80107B70.s.o(.rodata); build/asm/main_80107B70.s.o(.data); }
    .main_80107B70_bss (NOLOAD) : { build/asm/main_80107B70.s.o(.bss); }
    .main_80107D70 0x80107D70 : AT(0x00072970) { FILL(0x00000000); build/asm/main_80107D70.s.o(.text); build/asm/main_80107D70.s.o(.rodata); build/asm/main_80107D70.s.o(.data); }
    .main_80107D70_bss (NOLOAD) : { build/asm/main_80107D70.s.o(.bss); }
    .main_801085D0 0x801085D0 : AT(0x000731D0) { FILL(0x00000000); build/asm/main_801085D0.s.o(.text); build/asm/main_801085D0.s.o(.rodata); build/asm/main_801085D0.s.o(.data); }
    .main_801085D0_bss (NOLOAD) : { build/asm/main_801085D0.s.o(.bss); }
    .main_8010B330 0x8010B330 : AT(0x00075F30) { FILL(0x00000000); build/asm/main_8010B330.s.o(.text); build/asm/main_8010B330.s.o(.rodata); build/asm/main_8010B330.s.o(.data); }
    .main_8010B330_bss (NOLOAD) : { build/asm/main_8010B330.s.o(.bss); }
    .main_8010B8B4 0x8010B8B4 : AT(0x000764B4) { FILL(0x00000000); build/asm/main_8010B8B4.s.o(.text); build/asm/main_8010B8B4.s.o(.rodata); build/asm/main_8010B8B4.s.o(.data); }
    .main_8010B8B4_bss (NOLOAD) : { build/asm/main_8010B8B4.s.o(.bss); }
    .main_8010BDD0 0x8010BDD0 : AT(0x000769D0) { FILL(0x00000000); build/asm/main_8010BDD0.s.o(.text); build/asm/main_8010BDD0.s.o(.rodata); build/asm/main_8010BDD0.s.o(.data); }
    .main_8010BDD0_bss (NOLOAD) : { build/asm/main_8010BDD0.s.o(.bss); }
    .main_8010C6F0 0x8010C6F0 : AT(0x000772F0) { FILL(0x00000000); build/asm/main_8010C6F0.s.o(.text); build/asm/main_8010C6F0.s.o(.rodata); build/asm/main_8010C6F0.s.o(.data); }
    .main_8010C6F0_bss (NOLOAD) : { build/asm/main_8010C6F0.s.o(.bss); }
    .main_8010CA60 0x8010CA60 : AT(0x00077660) { FILL(0x00000000); build/asm/main_8010CA60.s.o(.text); build/asm/main_8010CA60.s.o(.rodata); build/asm/main_8010CA60.s.o(.data); }
    .main_8010CA60_bss (NOLOAD) : { build/asm/main_8010CA60.s.o(.bss); }
    .main_8010CC10 0x8010CC10 : AT(0x00077810) { FILL(0x00000000); build/asm/main_8010CC10.s.o(.text); build/asm/main_8010CC10.s.o(.rodata); build/asm/main_8010CC10.s.o(.data); }
    .main_8010CC10_bss (NOLOAD) : { build/asm/main_8010CC10.s.o(.bss); }
    .main_8010CE14 0x8010CE14 : AT(0x00077A14) { FILL(0x00000000); build/asm/main_8010CE14.s.o(.text); build/asm/main_8010CE14.s.o(.rodata); build/asm/main_8010CE14.s.o(.data); }
    .main_8010CE14_bss (NOLOAD) : { build/asm/main_8010CE14.s.o(.bss); }
    .main_8010CF08 0x8010CF08 : AT(0x00077B08) { FILL(0x00000000); build/asm/main_8010CF08.s.o(.text); build/asm/main_8010CF08.s.o(.rodata); build/asm/main_8010CF08.s.o(.data); }
    .main_8010CF08_bss (NOLOAD) : { build/asm/main_8010CF08.s.o(.bss); }
    .main_8010DA00 0x8010DA00 : AT(0x00078600) { FILL(0x00000000); build/asm/main_8010DA00.s.o(.text); build/asm/main_8010DA00.s.o(.rodata); build/asm/main_8010DA00.s.o(.data); }
    .main_8010DA00_bss (NOLOAD) : { build/asm/main_8010DA00.s.o(.bss); }
    .main_8010DCE0 0x8010DCE0 : AT(0x000788E0) { FILL(0x00000000); build/asm/main_8010DCE0.s.o(.text); build/asm/main_8010DCE0.s.o(.rodata); build/asm/main_8010DCE0.s.o(.data); }
    .main_8010DCE0_bss (NOLOAD) : { build/asm/main_8010DCE0.s.o(.bss); }
    .main_80114240 0x80114240 : AT(0x0007EE40) { FILL(0x00000000); build/asm/main_80114240.s.o(.text); build/asm/main_80114240.s.o(.rodata); build/asm/main_80114240.s.o(.data); }
    .main_80114240_bss (NOLOAD) : { build/asm/main_80114240.s.o(.bss); }
    .main_80114970 0x80114970 : AT(0x0007F570) { FILL(0x00000000); build/asm/main_80114970.s.o(.text); build/asm/main_80114970.s.o(.rodata); build/asm/main_80114970.s.o(.data); }
    .main_80114970_bss (NOLOAD) : { build/asm/main_80114970.s.o(.bss); }
    .main_8011C920 0x8011C920 : AT(0x00087520) { FILL(0x00000000); build/asm/main_8011C920.s.o(.text); build/asm/main_8011C920.s.o(.rodata); build/asm/main_8011C920.s.o(.data); }
    .main_8011C920_bss (NOLOAD) : { build/asm/main_8011C920.s.o(.bss); }
    .main_8012AF48 0x8012AF48 : AT(0x00095B48) { FILL(0x00000000); build/asm/main_8012AF48.s.o(.text); build/asm/main_8012AF48.s.o(.rodata); build/asm/main_8012AF48.s.o(.data); }
    .main_8012AF48_bss (NOLOAD) : { build/asm/main_8012AF48.s.o(.bss); }
    .main_8012B1BC 0x8012B1BC : AT(0x00095DBC) { FILL(0x00000000); build/asm/main_8012B1BC.s.o(.text); build/asm/main_8012B1BC.s.o(.rodata); build/asm/main_8012B1BC.s.o(.data); }
    .main_8012B1BC_bss (NOLOAD) : { build/asm/main_8012B1BC.s.o(.bss); }
    .main_8012BA94 0x8012BA94 : AT(0x00096694) { build/asm/data/main_8012BA94.bin.o(.data); }
    .main_8012BC78 0x8012BC78 : AT(0x00096878) { FILL(0x00000000); build/asm/main_8012BC78.s.o(.text); build/asm/main_8012BC78.s.o(.rodata); build/asm/main_8012BC78.s.o(.data); }
    .main_8012BC78_bss (NOLOAD) : { build/asm/main_8012BC78.s.o(.bss); }
    .main_8012E32C 0x8012E32C : AT(0x00098F2C) { FILL(0x00000000); build/asm/main_8012E32C.s.o(.text); build/asm/main_8012E32C.s.o(.rodata); build/asm/main_8012E32C.s.o(.data); }
    .main_8012E32C_bss (NOLOAD) : { build/asm/main_8012E32C.s.o(.bss); }
    .main_801302C0 0x801302C0 : AT(0x0009AEC0) { FILL(0x00000000); build/asm/main_801302C0.s.o(.text); build/asm/main_801302C0.s.o(.rodata); build/asm/main_801302C0.s.o(.data); }
    .main_801302C0_bss (NOLOAD) : { build/asm/main_801302C0.s.o(.bss); }
    .main_80138150 0x80138150 : AT(0x000A2D50) { build/asm/data/main_80138150.bin.o(.data); }
    .main_80138950 0x80138950 : AT(0x000A3550) { FILL(0x00000000); build/asm/main_80138950.s.o(.text); build/asm/main_80138950.s.o(.rodata); build/asm/main_80138950.s.o(.data); }
    .main_80138950_bss (NOLOAD) : { build/asm/main_80138950.s.o(.bss); }
    .main_80138E1C 0x80138E1C : AT(0x000A3A1C) { build/asm/data/main_80138E1C.bin.o(.data); }
    .main_80139150 0x80139150 : AT(0x000A3D50) { FILL(0x00000000); build/asm/main_80139150.s.o(.text); build/asm/main_80139150.s.o(.rodata); build/asm/main_80139150.s.o(.data); }
    .main_80139150_bss (NOLOAD) : { build/asm/main_80139150.s.o(.bss); }
    .main_80139420 0x80139420 : AT(0x000A4020) { build/asm/data/main_80139420.bin.o(.data); }
    .main_80139950 0x80139950 : AT(0x000A4550) { FILL(0x00000000); build/asm/main_80139950.s.o(.text); build/asm/main_80139950.s.o(.rodata); build/asm/main_80139950.s.o(.data); }
    .main_80139950_bss (NOLOAD) : { build/asm/main_80139950.s.o(.bss); }
    .main_8013ABA0 0x8013ABA0 : AT(0x000A57A0) { FILL(0x00000000); build/asm/main_8013ABA0.s.o(.text); build/asm/main_8013ABA0.s.o(.rodata); build/asm/main_8013ABA0.s.o(.data); }
    .main_8013ABA0_bss (NOLOAD) : { build/asm/main_8013ABA0.s.o(.bss); }
    .main_8013DE90 0x8013DE90 : AT(0x000A8A90) { FILL(0x00000000); build/asm/main_8013DE90.s.o(.text); build/asm/main_8013DE90.s.o(.rodata); build/asm/main_8013DE90.s.o(.data); }
    .main_8013DE90_bss (NOLOAD) : { build/asm/main_8013DE90.s.o(.bss); }
    .main_8013DFC0 0x8013DFC0 : AT(0x000A8BC0) { build/asm/data/main_8013DFC0.bin.o(.data); }
    .main_80150288 0x80150288 : AT(0x000BAE88) { FILL(0x00000000); build/asm/main_80150288.s.o(.text); build/asm/main_80150288.s.o(.rodata); build/asm/main_80150288.s.o(.data); }
    .main_80150288_bss (NOLOAD) : { build/asm/main_80150288.s.o(.bss); }
    .main_8017B9C4 0x8017B9C4 : AT(0x000E65C4) { build/asm/data/main_8017B9C4.bin.o(.data); }
    .main_80192F14 0x80192F14 : AT(0x000FDB14) { build/asm/data/main_80192F14.bin.o(.data); }
    .main_80194840 0x80194840 : AT(0x000FF440) { FILL(0x00000000); build/asm/main_80194840.s.o(.text); build/asm/main_80194840.s.o(.rodata); build/asm/main_80194840.s.o(.data); }
    .main_80194840_bss (NOLOAD) : { build/asm/main_80194840.s.o(.bss); }
    .main_80194958 0x80194958 : AT(0x000FF558) { build/asm/data/main_80194958.bin.o(.data); }
    .assets 0x80496400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
