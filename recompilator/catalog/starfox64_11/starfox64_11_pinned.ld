SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80002840 0x80002840 : AT(0x00003440) { FILL(0x00000000); build/asm/main_80002840.s.o(.text); build/asm/main_80002840.s.o(.rodata); build/asm/main_80002840.s.o(.data); }
    .main_80002840_bss (NOLOAD) : { build/asm/main_80002840.s.o(.bss); }
    .main_80003C50 0x80003C50 : AT(0x00004850) { FILL(0x00000000); build/asm/main_80003C50.s.o(.text); build/asm/main_80003C50.s.o(.rodata); build/asm/main_80003C50.s.o(.data); }
    .main_80003C50_bss (NOLOAD) : { build/asm/main_80003C50.s.o(.bss); }
    .main_80004560 0x80004560 : AT(0x00005160) { FILL(0x00000000); build/asm/main_80004560.s.o(.text); build/asm/main_80004560.s.o(.rodata); build/asm/main_80004560.s.o(.data); }
    .main_80004560_bss (NOLOAD) : { build/asm/main_80004560.s.o(.bss); }
    .main_80004E20 0x80004E20 : AT(0x00005A20) { FILL(0x00000000); build/asm/main_80004E20.s.o(.text); build/asm/main_80004E20.s.o(.rodata); build/asm/main_80004E20.s.o(.data); }
    .main_80004E20_bss (NOLOAD) : { build/asm/main_80004E20.s.o(.bss); }
    .main_80007088 0x80007088 : AT(0x00007C88) { FILL(0x00000000); build/asm/main_80007088.s.o(.text); build/asm/main_80007088.s.o(.rodata); build/asm/main_80007088.s.o(.data); }
    .main_80007088_bss (NOLOAD) : { build/asm/main_80007088.s.o(.bss); }
    .main_8000762C 0x8000762C : AT(0x0000822C) { FILL(0x00000000); build/asm/main_8000762C.s.o(.text); build/asm/main_8000762C.s.o(.rodata); build/asm/main_8000762C.s.o(.data); }
    .main_8000762C_bss (NOLOAD) : { build/asm/main_8000762C.s.o(.bss); }
    .main_80007FE4 0x80007FE4 : AT(0x00008BE4) { FILL(0x00000000); build/asm/main_80007FE4.s.o(.text); build/asm/main_80007FE4.s.o(.rodata); build/asm/main_80007FE4.s.o(.data); }
    .main_80007FE4_bss (NOLOAD) : { build/asm/main_80007FE4.s.o(.bss); }
    .main_8001F5E0 0x8001F5E0 : AT(0x000201E0) { FILL(0x00000000); build/asm/main_8001F5E0.s.o(.text); build/asm/main_8001F5E0.s.o(.rodata); build/asm/main_8001F5E0.s.o(.data); }
    .main_8001F5E0_bss (NOLOAD) : { build/asm/main_8001F5E0.s.o(.bss); }
    .main_800201B8 0x800201B8 : AT(0x00020DB8) { FILL(0x00000000); build/asm/main_800201B8.s.o(.text); build/asm/main_800201B8.s.o(.rodata); build/asm/main_800201B8.s.o(.data); }
    .main_800201B8_bss (NOLOAD) : { build/asm/main_800201B8.s.o(.bss); }
    .main_800204EC 0x800204EC : AT(0x000210EC) { FILL(0x00000000); build/asm/main_800204EC.s.o(.text); build/asm/main_800204EC.s.o(.rodata); build/asm/main_800204EC.s.o(.data); }
    .main_800204EC_bss (NOLOAD) : { build/asm/main_800204EC.s.o(.bss); }
    .main_80020920 0x80020920 : AT(0x00021520) { FILL(0x00000000); build/asm/main_80020920.s.o(.text); build/asm/main_80020920.s.o(.rodata); build/asm/main_80020920.s.o(.data); }
    .main_80020920_bss (NOLOAD) : { build/asm/main_80020920.s.o(.bss); }
    .main_80020F40 0x80020F40 : AT(0x00021B40) { FILL(0x00000000); build/asm/main_80020F40.s.o(.text); build/asm/main_80020F40.s.o(.rodata); build/asm/main_80020F40.s.o(.data); }
    .main_80020F40_bss (NOLOAD) : { build/asm/main_80020F40.s.o(.bss); }
    .main_80021900 0x80021900 : AT(0x00022500) { FILL(0x00000000); build/asm/main_80021900.s.o(.text); build/asm/main_80021900.s.o(.rodata); build/asm/main_80021900.s.o(.data); }
    .main_80021900_bss (NOLOAD) : { build/asm/main_80021900.s.o(.bss); }
    .main_80022190 0x80022190 : AT(0x00022D90) { FILL(0x00000000); build/asm/main_80022190.s.o(.text); build/asm/main_80022190.s.o(.rodata); build/asm/main_80022190.s.o(.data); }
    .main_80022190_bss (NOLOAD) : { build/asm/main_80022190.s.o(.bss); }
    .main_80023090 0x80023090 : AT(0x00023C90) { FILL(0x00000000); build/asm/main_80023090.s.o(.text); build/asm/main_80023090.s.o(.rodata); build/asm/main_80023090.s.o(.data); }
    .main_80023090_bss (NOLOAD) : { build/asm/main_80023090.s.o(.bss); }
    .main_800236A0 0x800236A0 : AT(0x000242A0) { FILL(0x00000000); build/asm/main_800236A0.s.o(.text); build/asm/main_800236A0.s.o(.rodata); build/asm/main_800236A0.s.o(.data); }
    .main_800236A0_bss (NOLOAD) : { build/asm/main_800236A0.s.o(.bss); }
    .main_80023960 0x80023960 : AT(0x00024560) { FILL(0x00000000); build/asm/main_80023960.s.o(.text); build/asm/main_80023960.s.o(.rodata); build/asm/main_80023960.s.o(.data); }
    .main_80023960_bss (NOLOAD) : { build/asm/main_80023960.s.o(.bss); }
    .main_80023F24 0x80023F24 : AT(0x00024B24) { FILL(0x00000000); build/asm/main_80023F24.s.o(.text); build/asm/main_80023F24.s.o(.rodata); build/asm/main_80023F24.s.o(.data); }
    .main_80023F24_bss (NOLOAD) : { build/asm/main_80023F24.s.o(.bss); }
    .main_80023FC0 0x80023FC0 : AT(0x00024BC0) { FILL(0x00000000); build/asm/main_80023FC0.s.o(.text); build/asm/main_80023FC0.s.o(.rodata); build/asm/main_80023FC0.s.o(.data); }
    .main_80023FC0_bss (NOLOAD) : { build/asm/main_80023FC0.s.o(.bss); }
    .main_80024D50 0x80024D50 : AT(0x00025950) { FILL(0x00000000); build/asm/main_80024D50.s.o(.text); build/asm/main_80024D50.s.o(.rodata); build/asm/main_80024D50.s.o(.data); }
    .main_80024D50_bss (NOLOAD) : { build/asm/main_80024D50.s.o(.bss); }
    .main_80024EC0 0x80024EC0 : AT(0x00025AC0) { FILL(0x00000000); build/asm/main_80024EC0.s.o(.text); build/asm/main_80024EC0.s.o(.rodata); build/asm/main_80024EC0.s.o(.data); }
    .main_80024EC0_bss (NOLOAD) : { build/asm/main_80024EC0.s.o(.bss); }
    .main_80025160 0x80025160 : AT(0x00025D60) { FILL(0x00000000); build/asm/main_80025160.s.o(.text); build/asm/main_80025160.s.o(.rodata); build/asm/main_80025160.s.o(.data); }
    .main_80025160_bss (NOLOAD) : { build/asm/main_80025160.s.o(.bss); }
    .main_80025310 0x80025310 : AT(0x00025F10) { FILL(0x00000000); build/asm/main_80025310.s.o(.text); build/asm/main_80025310.s.o(.rodata); build/asm/main_80025310.s.o(.data); }
    .main_80025310_bss (NOLOAD) : { build/asm/main_80025310.s.o(.bss); }
    .main_80025D08 0x80025D08 : AT(0x00026908) { FILL(0x00000000); build/asm/main_80025D08.s.o(.text); build/asm/main_80025D08.s.o(.rodata); build/asm/main_80025D08.s.o(.data); }
    .main_80025D08_bss (NOLOAD) : { build/asm/main_80025D08.s.o(.bss); }
    .main_80026270 0x80026270 : AT(0x00026E70) { FILL(0x00000000); build/asm/main_80026270.s.o(.text); build/asm/main_80026270.s.o(.rodata); build/asm/main_80026270.s.o(.data); }
    .main_80026270_bss (NOLOAD) : { build/asm/main_80026270.s.o(.bss); }
    .main_80027090 0x80027090 : AT(0x00027C90) { FILL(0x00000000); build/asm/main_80027090.s.o(.text); build/asm/main_80027090.s.o(.rodata); build/asm/main_80027090.s.o(.data); }
    .main_80027090_bss (NOLOAD) : { build/asm/main_80027090.s.o(.bss); }
    .main_80027670 0x80027670 : AT(0x00028270) { FILL(0x00000000); build/asm/main_80027670.s.o(.text); build/asm/main_80027670.s.o(.rodata); build/asm/main_80027670.s.o(.data); }
    .main_80027670_bss (NOLOAD) : { build/asm/main_80027670.s.o(.bss); }
    .main_80027C20 0x80027C20 : AT(0x00028820) { FILL(0x00000000); build/asm/main_80027C20.s.o(.text); build/asm/main_80027C20.s.o(.rodata); build/asm/main_80027C20.s.o(.data); }
    .main_80027C20_bss (NOLOAD) : { build/asm/main_80027C20.s.o(.bss); }
    .main_80028BB0 0x80028BB0 : AT(0x000297B0) { FILL(0x00000000); build/asm/main_80028BB0.s.o(.text); build/asm/main_80028BB0.s.o(.rodata); build/asm/main_80028BB0.s.o(.data); }
    .main_80028BB0_bss (NOLOAD) : { build/asm/main_80028BB0.s.o(.bss); }
    .main_80028BE0 0x80028BE0 : AT(0x000297E0) { FILL(0x00000000); build/asm/main_80028BE0.s.o(.text); build/asm/main_80028BE0.s.o(.rodata); build/asm/main_80028BE0.s.o(.data); }
    .main_80028BE0_bss (NOLOAD) : { build/asm/main_80028BE0.s.o(.bss); }
    .main_80028DE0 0x80028DE0 : AT(0x000299E0) { FILL(0x00000000); build/asm/main_80028DE0.s.o(.text); build/asm/main_80028DE0.s.o(.rodata); build/asm/main_80028DE0.s.o(.data); }
    .main_80028DE0_bss (NOLOAD) : { build/asm/main_80028DE0.s.o(.bss); }
    .main_8002A8B4 0x8002A8B4 : AT(0x0002B4B4) { FILL(0x00000000); build/asm/main_8002A8B4.s.o(.text); build/asm/main_8002A8B4.s.o(.rodata); build/asm/main_8002A8B4.s.o(.data); }
    .main_8002A8B4_bss (NOLOAD) : { build/asm/main_8002A8B4.s.o(.bss); }
    .main_8002AC30 0x8002AC30 : AT(0x0002B830) { FILL(0x00000000); build/asm/main_8002AC30.s.o(.text); build/asm/main_8002AC30.s.o(.rodata); build/asm/main_8002AC30.s.o(.data); }
    .main_8002AC30_bss (NOLOAD) : { build/asm/main_8002AC30.s.o(.bss); }
    .main_8002E340 0x8002E340 : AT(0x0002EF40) { FILL(0x00000000); build/asm/main_8002E340.s.o(.text); build/asm/main_8002E340.s.o(.rodata); build/asm/main_8002E340.s.o(.data); }
    .main_8002E340_bss (NOLOAD) : { build/asm/main_8002E340.s.o(.bss); }
    .main_80035D30 0x80035D30 : AT(0x00036930) { FILL(0x00000000); build/asm/main_80035D30.s.o(.text); build/asm/main_80035D30.s.o(.rodata); build/asm/main_80035D30.s.o(.data); }
    .main_80035D30_bss (NOLOAD) : { build/asm/main_80035D30.s.o(.bss); }
    .main_80052584 0x80052584 : AT(0x00053184) { FILL(0x00000000); build/asm/main_80052584.s.o(.text); build/asm/main_80052584.s.o(.rodata); build/asm/main_80052584.s.o(.data); }
    .main_80052584_bss (NOLOAD) : { build/asm/main_80052584.s.o(.bss); }
    .main_80053658 0x80053658 : AT(0x00054258) { FILL(0x00000000); build/asm/main_80053658.s.o(.text); build/asm/main_80053658.s.o(.rodata); build/asm/main_80053658.s.o(.data); }
    .main_80053658_bss (NOLOAD) : { build/asm/main_80053658.s.o(.bss); }
    .main_8005ADAC 0x8005ADAC : AT(0x0005B9AC) { FILL(0x00000000); build/asm/main_8005ADAC.s.o(.text); build/asm/main_8005ADAC.s.o(.rodata); build/asm/main_8005ADAC.s.o(.data); }
    .main_8005ADAC_bss (NOLOAD) : { build/asm/main_8005ADAC.s.o(.bss); }
    .main_80066EF0 0x80066EF0 : AT(0x00067AF0) { FILL(0x00000000); build/asm/main_80066EF0.s.o(.text); build/asm/main_80066EF0.s.o(.rodata); build/asm/main_80066EF0.s.o(.data); }
    .main_80066EF0_bss (NOLOAD) : { build/asm/main_80066EF0.s.o(.bss); }
    .main_80074E3C 0x80074E3C : AT(0x00075A3C) { FILL(0x00000000); build/asm/main_80074E3C.s.o(.text); build/asm/main_80074E3C.s.o(.rodata); build/asm/main_80074E3C.s.o(.data); }
    .main_80074E3C_bss (NOLOAD) : { build/asm/main_80074E3C.s.o(.bss); }
    .main_8007A28C 0x8007A28C : AT(0x0007AE8C) { FILL(0x00000000); build/asm/main_8007A28C.s.o(.text); build/asm/main_8007A28C.s.o(.rodata); build/asm/main_8007A28C.s.o(.data); }
    .main_8007A28C_bss (NOLOAD) : { build/asm/main_8007A28C.s.o(.bss); }
    .main_800C26C8 0x800C26C8 : AT(0x000C32C8) { FILL(0x00000000); build/asm/main_800C26C8.s.o(.text); build/asm/main_800C26C8.s.o(.rodata); build/asm/main_800C26C8.s.o(.data); }
    .main_800C26C8_bss (NOLOAD) : { build/asm/main_800C26C8.s.o(.bss); }
    .main_800C4610 0x800C4610 : AT(0x000C5210) { build/asm/data/main_800C4610.bin.o(.data); }
    .main_800C5260 0x800C5260 : AT(0x000C5E60) { build/asm/data/main_800C5260.bin.o(.data); }
    .main_800C6450 0x800C6450 : AT(0x000C7050) { build/asm/data/main_800C6450.bin.o(.data); }
    .main_800C742C 0x800C742C : AT(0x000C802C) { FILL(0x00000000); build/asm/main_800C742C.s.o(.text); build/asm/main_800C742C.s.o(.rodata); build/asm/main_800C742C.s.o(.data); }
    .main_800C742C_bss (NOLOAD) : { build/asm/main_800C742C.s.o(.bss); }
    .main_800C7684 0x800C7684 : AT(0x000C8284) { FILL(0x00000000); build/asm/main_800C7684.s.o(.text); build/asm/main_800C7684.s.o(.rodata); build/asm/main_800C7684.s.o(.data); }
    .main_800C7684_bss (NOLOAD) : { build/asm/main_800C7684.s.o(.bss); }
    .main_800C8DF0 0x800C8DF0 : AT(0x000C99F0) { build/asm/data/main_800C8DF0.bin.o(.data); }
    .main_800CA17C 0x800CA17C : AT(0x000CAD7C) { FILL(0x00000000); build/asm/main_800CA17C.s.o(.text); build/asm/main_800CA17C.s.o(.rodata); build/asm/main_800CA17C.s.o(.data); }
    .main_800CA17C_bss (NOLOAD) : { build/asm/main_800CA17C.s.o(.bss); }
    .main_800CA1D0 0x800CA1D0 : AT(0x000CADD0) { FILL(0x00000000); build/asm/main_800CA1D0.s.o(.text); build/asm/main_800CA1D0.s.o(.rodata); build/asm/main_800CA1D0.s.o(.data); }
    .main_800CA1D0_bss (NOLOAD) : { build/asm/main_800CA1D0.s.o(.bss); }
    .main_800CE6FC 0x800CE6FC : AT(0x000CF2FC) { build/asm/data/main_800CE6FC.bin.o(.data); }
    .main_800D3728 0x800D3728 : AT(0x000D4328) { FILL(0x00000000); build/asm/main_800D3728.s.o(.text); build/asm/main_800D3728.s.o(.rodata); build/asm/main_800D3728.s.o(.data); }
    .main_800D3728_bss (NOLOAD) : { build/asm/main_800D3728.s.o(.bss); }
    .main_800D4440 0x800D4440 : AT(0x000D5040) { FILL(0x00000000); build/asm/main_800D4440.s.o(.text); build/asm/main_800D4440.s.o(.rodata); build/asm/main_800D4440.s.o(.data); }
    .main_800D4440_bss (NOLOAD) : { build/asm/main_800D4440.s.o(.bss); }
    .main_800D4550 0x800D4550 : AT(0x000D5150) { FILL(0x00000000); build/asm/main_800D4550.s.o(.text); build/asm/main_800D4550.s.o(.rodata); build/asm/main_800D4550.s.o(.data); }
    .main_800D4550_bss (NOLOAD) : { build/asm/main_800D4550.s.o(.bss); }
    .main_800D5B84 0x800D5B84 : AT(0x000D6784) { FILL(0x00000000); build/asm/main_800D5B84.s.o(.text); build/asm/main_800D5B84.s.o(.rodata); build/asm/main_800D5B84.s.o(.data); }
    .main_800D5B84_bss (NOLOAD) : { build/asm/main_800D5B84.s.o(.bss); }
    .main_800D617C 0x800D617C : AT(0x000D6D7C) { build/asm/data/main_800D617C.bin.o(.data); }
    .main_800D72CC 0x800D72CC : AT(0x000D7ECC) { FILL(0x00000000); build/asm/main_800D72CC.s.o(.text); build/asm/main_800D72CC.s.o(.rodata); build/asm/main_800D72CC.s.o(.data); }
    .main_800D72CC_bss (NOLOAD) : { build/asm/main_800D72CC.s.o(.bss); }
    .main_800D8B2C 0x800D8B2C : AT(0x000D972C) { FILL(0x00000000); build/asm/main_800D8B2C.s.o(.text); build/asm/main_800D8B2C.s.o(.rodata); build/asm/main_800D8B2C.s.o(.data); }
    .main_800D8B2C_bss (NOLOAD) : { build/asm/main_800D8B2C.s.o(.bss); }
    .main_800DBF58 0x800DBF58 : AT(0x000DCB58) { build/asm/data/main_800DBF58.bin.o(.data); }
    .main_800DCCEC 0x800DCCEC : AT(0x000DD8EC) { FILL(0x00000000); build/asm/main_800DCCEC.s.o(.text); build/asm/main_800DCCEC.s.o(.rodata); build/asm/main_800DCCEC.s.o(.data); }
    .main_800DCCEC_bss (NOLOAD) : { build/asm/main_800DCCEC.s.o(.bss); }
    .main_800E0B9C 0x800E0B9C : AT(0x000E179C) { build/asm/data/main_800E0B9C.bin.o(.data); }
    .main_800E223C 0x800E223C : AT(0x000E2E3C) { build/asm/data/main_800E223C.bin.o(.data); }
    .main_800E2920 0x800E2920 : AT(0x000E3520) { build/asm/data/main_800E2920.bin.o(.data); }
    .main_800E3700 0x800E3700 : AT(0x000E4300) { FILL(0x00000000); build/asm/main_800E3700.s.o(.text); build/asm/main_800E3700.s.o(.rodata); build/asm/main_800E3700.s.o(.data); }
    .main_800E3700_bss (NOLOAD) : { build/asm/main_800E3700.s.o(.bss); }
    .main_800E373C 0x800E373C : AT(0x000E433C) { build/asm/data/main_800E373C.bin.o(.data); }
    .main_800E3C90 0x800E3C90 : AT(0x000E4890) { FILL(0x00000000); build/asm/main_800E3C90.s.o(.text); build/asm/main_800E3C90.s.o(.rodata); build/asm/main_800E3C90.s.o(.data); }
    .main_800E3C90_bss (NOLOAD) : { build/asm/main_800E3C90.s.o(.bss); }
    .main_800E4050 0x800E4050 : AT(0x000E4C50) { build/asm/data/main_800E4050.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
