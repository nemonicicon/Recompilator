SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_8004B400 0x8004B400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_8004B400.s.o(.text); build/asm/main_8004B400.s.o(.rodata); build/asm/main_8004B400.s.o(.data); }
    .main_8004B400_bss (NOLOAD) : { build/asm/main_8004B400.s.o(.bss); }
    .main_8004B8A0 0x8004B8A0 : AT(0x000014A0) { build/asm/data/main_8004B8A0.bin.o(.data); }
    .main_8004DC8C 0x8004DC8C : AT(0x0000388C) { FILL(0x00000000); build/asm/main_8004DC8C.s.o(.text); build/asm/main_8004DC8C.s.o(.rodata); build/asm/main_8004DC8C.s.o(.data); }
    .main_8004DC8C_bss (NOLOAD) : { build/asm/main_8004DC8C.s.o(.bss); }
    .main_8004DEC0 0x8004DEC0 : AT(0x00003AC0) { build/asm/data/main_8004DEC0.bin.o(.data); }
    .main_8005EB3C 0x8005EB3C : AT(0x0001473C) { FILL(0x00000000); build/asm/main_8005EB3C.s.o(.text); build/asm/main_8005EB3C.s.o(.rodata); build/asm/main_8005EB3C.s.o(.data); }
    .main_8005EB3C_bss (NOLOAD) : { build/asm/main_8005EB3C.s.o(.bss); }
    .main_8005EBE8 0x8005EBE8 : AT(0x000147E8) { build/asm/data/main_8005EBE8.bin.o(.data); }
    .main_8006F974 0x8006F974 : AT(0x00025574) { FILL(0x00000000); build/asm/main_8006F974.s.o(.text); build/asm/main_8006F974.s.o(.rodata); build/asm/main_8006F974.s.o(.data); }
    .main_8006F974_bss (NOLOAD) : { build/asm/main_8006F974.s.o(.bss); }
    .main_8006FA50 0x8006FA50 : AT(0x00025650) { build/asm/data/main_8006FA50.bin.o(.data); }
    .main_80070AB8 0x80070AB8 : AT(0x000266B8) { FILL(0x00000000); build/asm/main_80070AB8.s.o(.text); build/asm/main_80070AB8.s.o(.rodata); build/asm/main_80070AB8.s.o(.data); }
    .main_80070AB8_bss (NOLOAD) : { build/asm/main_80070AB8.s.o(.bss); }
    .main_80070AC8 0x80070AC8 : AT(0x000266C8) { build/asm/data/main_80070AC8.bin.o(.data); }
    .main_80073A1C 0x80073A1C : AT(0x0002961C) { FILL(0x00000000); build/asm/main_80073A1C.s.o(.text); build/asm/main_80073A1C.s.o(.rodata); build/asm/main_80073A1C.s.o(.data); }
    .main_80073A1C_bss (NOLOAD) : { build/asm/main_80073A1C.s.o(.bss); }
    .main_80073A24 0x80073A24 : AT(0x00029624) { build/asm/data/main_80073A24.bin.o(.data); }
    .main_80076630 0x80076630 : AT(0x0002C230) { FILL(0x00000000); build/asm/main_80076630.s.o(.text); build/asm/main_80076630.s.o(.rodata); build/asm/main_80076630.s.o(.data); }
    .main_80076630_bss (NOLOAD) : { build/asm/main_80076630.s.o(.bss); }
    .main_800766B4 0x800766B4 : AT(0x0002C2B4) { build/asm/data/main_800766B4.bin.o(.data); }
    .main_8008DC10 0x8008DC10 : AT(0x00043810) { FILL(0x00000000); build/asm/main_8008DC10.s.o(.text); build/asm/main_8008DC10.s.o(.rodata); build/asm/main_8008DC10.s.o(.data); }
    .main_8008DC10_bss (NOLOAD) : { build/asm/main_8008DC10.s.o(.bss); }
    .main_8008DC30 0x8008DC30 : AT(0x00043830) { build/asm/data/main_8008DC30.bin.o(.data); }
    .main_800BFFF4 0x800BFFF4 : AT(0x00075BF4) { FILL(0x00000000); build/asm/main_800BFFF4.s.o(.text); build/asm/main_800BFFF4.s.o(.rodata); build/asm/main_800BFFF4.s.o(.data); }
    .main_800BFFF4_bss (NOLOAD) : { build/asm/main_800BFFF4.s.o(.bss); }
    .main_800C0058 0x800C0058 : AT(0x00075C58) { build/asm/data/main_800C0058.bin.o(.data); }
    .main_800D85B4 0x800D85B4 : AT(0x0008E1B4) { FILL(0x00000000); build/asm/main_800D85B4.s.o(.text); build/asm/main_800D85B4.s.o(.rodata); build/asm/main_800D85B4.s.o(.data); }
    .main_800D85B4_bss (NOLOAD) : { build/asm/main_800D85B4.s.o(.bss); }
    .main_800D85D8 0x800D85D8 : AT(0x0008E1D8) { build/asm/data/main_800D85D8.bin.o(.data); }
    .main_800DD598 0x800DD598 : AT(0x00093198) { FILL(0x00000000); build/asm/main_800DD598.s.o(.text); build/asm/main_800DD598.s.o(.rodata); build/asm/main_800DD598.s.o(.data); }
    .main_800DD598_bss (NOLOAD) : { build/asm/main_800DD598.s.o(.bss); }
    .main_800DD5DC 0x800DD5DC : AT(0x000931DC) { build/asm/data/main_800DD5DC.bin.o(.data); }
    .main_800E5F28 0x800E5F28 : AT(0x0009BB28) { FILL(0x00000000); build/asm/main_800E5F28.s.o(.text); build/asm/main_800E5F28.s.o(.rodata); build/asm/main_800E5F28.s.o(.data); }
    .main_800E5F28_bss (NOLOAD) : { build/asm/main_800E5F28.s.o(.bss); }
    .main_800E5F44 0x800E5F44 : AT(0x0009BB44) { build/asm/data/main_800E5F44.bin.o(.data); }
    .main_800FA8A8 0x800FA8A8 : AT(0x000B04A8) { FILL(0x00000000); build/asm/main_800FA8A8.s.o(.text); build/asm/main_800FA8A8.s.o(.rodata); build/asm/main_800FA8A8.s.o(.data); }
    .main_800FA8A8_bss (NOLOAD) : { build/asm/main_800FA8A8.s.o(.bss); }
    .main_800FA920 0x800FA920 : AT(0x000B0520) { build/asm/data/main_800FA920.bin.o(.data); }
    .main_800FAEF4 0x800FAEF4 : AT(0x000B0AF4) { FILL(0x00000000); build/asm/main_800FAEF4.s.o(.text); build/asm/main_800FAEF4.s.o(.rodata); build/asm/main_800FAEF4.s.o(.data); }
    .main_800FAEF4_bss (NOLOAD) : { build/asm/main_800FAEF4.s.o(.bss); }
    .main_800FAF1C 0x800FAF1C : AT(0x000B0B1C) { build/asm/data/main_800FAF1C.bin.o(.data); }
    .main_8010DD64 0x8010DD64 : AT(0x000C3964) { FILL(0x00000000); build/asm/main_8010DD64.s.o(.text); build/asm/main_8010DD64.s.o(.rodata); build/asm/main_8010DD64.s.o(.data); }
    .main_8010DD64_bss (NOLOAD) : { build/asm/main_8010DD64.s.o(.bss); }
    .main_8010DD80 0x8010DD80 : AT(0x000C3980) { build/asm/data/main_8010DD80.bin.o(.data); }
    .main_801158F0 0x801158F0 : AT(0x000CB4F0) { FILL(0x00000000); build/asm/main_801158F0.s.o(.text); build/asm/main_801158F0.s.o(.rodata); build/asm/main_801158F0.s.o(.data); }
    .main_801158F0_bss (NOLOAD) : { build/asm/main_801158F0.s.o(.bss); }
    .main_80115914 0x80115914 : AT(0x000CB514) { build/asm/data/main_80115914.bin.o(.data); }
    .main_8012AFE4 0x8012AFE4 : AT(0x000E0BE4) { FILL(0x00000000); build/asm/main_8012AFE4.s.o(.text); build/asm/main_8012AFE4.s.o(.rodata); build/asm/main_8012AFE4.s.o(.data); }
    .main_8012AFE4_bss (NOLOAD) : { build/asm/main_8012AFE4.s.o(.bss); }
    .main_8012AFFC 0x8012AFFC : AT(0x000E0BFC) { build/asm/data/main_8012AFFC.bin.o(.data); }
    .assets 0x8044B400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
