SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_8000040C 0x8000040C : AT(0x0000100C) { FILL(0x00000000); build/asm/main_8000040C.s.o(.text); build/asm/main_8000040C.s.o(.rodata); build/asm/main_8000040C.s.o(.data); }
    .main_8000040C_bss (NOLOAD) : { build/asm/main_8000040C.s.o(.bss); }
    .main_80000440 0x80000440 : AT(0x00001040) { build/asm/data/main_80000440.bin.o(.data); }
    .main_80000B20 0x80000B20 : AT(0x00001720) { FILL(0x00000000); build/asm/main_80000B20.s.o(.text); build/asm/main_80000B20.s.o(.rodata); build/asm/main_80000B20.s.o(.data); }
    .main_80000B20_bss (NOLOAD) : { build/asm/main_80000B20.s.o(.bss); }
    .main_80024880 0x80024880 : AT(0x00025480) { build/asm/data/main_80024880.bin.o(.data); }
    .main_800269B0 0x800269B0 : AT(0x000275B0) { FILL(0x00000000); build/asm/main_800269B0.s.o(.text); build/asm/main_800269B0.s.o(.rodata); build/asm/main_800269B0.s.o(.data); }
    .main_800269B0_bss (NOLOAD) : { build/asm/main_800269B0.s.o(.bss); }
    .main_80029F30 0x80029F30 : AT(0x0002AB30) { FILL(0x00000000); build/asm/main_80029F30.s.o(.text); build/asm/main_80029F30.s.o(.rodata); build/asm/main_80029F30.s.o(.data); }
    .main_80029F30_bss (NOLOAD) : { build/asm/main_80029F30.s.o(.bss); }
    .main_8002A120 0x8002A120 : AT(0x0002AD20) { FILL(0x00000000); build/asm/main_8002A120.s.o(.text); build/asm/main_8002A120.s.o(.rodata); build/asm/main_8002A120.s.o(.data); }
    .main_8002A120_bss (NOLOAD) : { build/asm/main_8002A120.s.o(.bss); }
    .main_8002A55C 0x8002A55C : AT(0x0002B15C) { FILL(0x00000000); build/asm/main_8002A55C.s.o(.text); build/asm/main_8002A55C.s.o(.rodata); build/asm/main_8002A55C.s.o(.data); }
    .main_8002A55C_bss (NOLOAD) : { build/asm/main_8002A55C.s.o(.bss); }
    .main_8002A84C 0x8002A84C : AT(0x0002B44C) { FILL(0x00000000); build/asm/main_8002A84C.s.o(.text); build/asm/main_8002A84C.s.o(.rodata); build/asm/main_8002A84C.s.o(.data); }
    .main_8002A84C_bss (NOLOAD) : { build/asm/main_8002A84C.s.o(.bss); }
    .main_8002AD64 0x8002AD64 : AT(0x0002B964) { FILL(0x00000000); build/asm/main_8002AD64.s.o(.text); build/asm/main_8002AD64.s.o(.rodata); build/asm/main_8002AD64.s.o(.data); }
    .main_8002AD64_bss (NOLOAD) : { build/asm/main_8002AD64.s.o(.bss); }
    .main_8002AFC0 0x8002AFC0 : AT(0x0002BBC0) { FILL(0x00000000); build/asm/main_8002AFC0.s.o(.text); build/asm/main_8002AFC0.s.o(.rodata); build/asm/main_8002AFC0.s.o(.data); }
    .main_8002AFC0_bss (NOLOAD) : { build/asm/main_8002AFC0.s.o(.bss); }
    .main_8002B590 0x8002B590 : AT(0x0002C190) { FILL(0x00000000); build/asm/main_8002B590.s.o(.text); build/asm/main_8002B590.s.o(.rodata); build/asm/main_8002B590.s.o(.data); }
    .main_8002B590_bss (NOLOAD) : { build/asm/main_8002B590.s.o(.bss); }
    .main_8002C230 0x8002C230 : AT(0x0002CE30) { FILL(0x00000000); build/asm/main_8002C230.s.o(.text); build/asm/main_8002C230.s.o(.rodata); build/asm/main_8002C230.s.o(.data); }
    .main_8002C230_bss (NOLOAD) : { build/asm/main_8002C230.s.o(.bss); }
    .main_8002CBA4 0x8002CBA4 : AT(0x0002D7A4) { FILL(0x00000000); build/asm/main_8002CBA4.s.o(.text); build/asm/main_8002CBA4.s.o(.rodata); build/asm/main_8002CBA4.s.o(.data); }
    .main_8002CBA4_bss (NOLOAD) : { build/asm/main_8002CBA4.s.o(.bss); }
    .main_8002D370 0x8002D370 : AT(0x0002DF70) { FILL(0x00000000); build/asm/main_8002D370.s.o(.text); build/asm/main_8002D370.s.o(.rodata); build/asm/main_8002D370.s.o(.data); }
    .main_8002D370_bss (NOLOAD) : { build/asm/main_8002D370.s.o(.bss); }
    .main_80031940 0x80031940 : AT(0x00032540) { FILL(0x00000000); build/asm/main_80031940.s.o(.text); build/asm/main_80031940.s.o(.rodata); build/asm/main_80031940.s.o(.data); }
    .main_80031940_bss (NOLOAD) : { build/asm/main_80031940.s.o(.bss); }
    .main_80032530 0x80032530 : AT(0x00033130) { FILL(0x00000000); build/asm/main_80032530.s.o(.text); build/asm/main_80032530.s.o(.rodata); build/asm/main_80032530.s.o(.data); }
    .main_80032530_bss (NOLOAD) : { build/asm/main_80032530.s.o(.bss); }
    .main_80032C80 0x80032C80 : AT(0x00033880) { FILL(0x00000000); build/asm/main_80032C80.s.o(.text); build/asm/main_80032C80.s.o(.rodata); build/asm/main_80032C80.s.o(.data); }
    .main_80032C80_bss (NOLOAD) : { build/asm/main_80032C80.s.o(.bss); }
    .main_80032FD0 0x80032FD0 : AT(0x00033BD0) { FILL(0x00000000); build/asm/main_80032FD0.s.o(.text); build/asm/main_80032FD0.s.o(.rodata); build/asm/main_80032FD0.s.o(.data); }
    .main_80032FD0_bss (NOLOAD) : { build/asm/main_80032FD0.s.o(.bss); }
    .main_80033310 0x80033310 : AT(0x00033F10) { FILL(0x00000000); build/asm/main_80033310.s.o(.text); build/asm/main_80033310.s.o(.rodata); build/asm/main_80033310.s.o(.data); }
    .main_80033310_bss (NOLOAD) : { build/asm/main_80033310.s.o(.bss); }
    .main_800335E0 0x800335E0 : AT(0x000341E0) { FILL(0x00000000); build/asm/main_800335E0.s.o(.text); build/asm/main_800335E0.s.o(.rodata); build/asm/main_800335E0.s.o(.data); }
    .main_800335E0_bss (NOLOAD) : { build/asm/main_800335E0.s.o(.bss); }
    .main_800336D0 0x800336D0 : AT(0x000342D0) { FILL(0x00000000); build/asm/main_800336D0.s.o(.text); build/asm/main_800336D0.s.o(.rodata); build/asm/main_800336D0.s.o(.data); }
    .main_800336D0_bss (NOLOAD) : { build/asm/main_800336D0.s.o(.bss); }
    .main_800338A0 0x800338A0 : AT(0x000344A0) { FILL(0x00000000); build/asm/main_800338A0.s.o(.text); build/asm/main_800338A0.s.o(.rodata); build/asm/main_800338A0.s.o(.data); }
    .main_800338A0_bss (NOLOAD) : { build/asm/main_800338A0.s.o(.bss); }
    .main_80034320 0x80034320 : AT(0x00034F20) { FILL(0x00000000); build/asm/main_80034320.s.o(.text); build/asm/main_80034320.s.o(.rodata); build/asm/main_80034320.s.o(.data); }
    .main_80034320_bss (NOLOAD) : { build/asm/main_80034320.s.o(.bss); }
    .main_80034420 0x80034420 : AT(0x00035020) { FILL(0x00000000); build/asm/main_80034420.s.o(.text); build/asm/main_80034420.s.o(.rodata); build/asm/main_80034420.s.o(.data); }
    .main_80034420_bss (NOLOAD) : { build/asm/main_80034420.s.o(.bss); }
    .main_800344D0 0x800344D0 : AT(0x000350D0) { FILL(0x00000000); build/asm/main_800344D0.s.o(.text); build/asm/main_800344D0.s.o(.rodata); build/asm/main_800344D0.s.o(.data); }
    .main_800344D0_bss (NOLOAD) : { build/asm/main_800344D0.s.o(.bss); }
    .main_80034630 0x80034630 : AT(0x00035230) { FILL(0x00000000); build/asm/main_80034630.s.o(.text); build/asm/main_80034630.s.o(.rodata); build/asm/main_80034630.s.o(.data); }
    .main_80034630_bss (NOLOAD) : { build/asm/main_80034630.s.o(.bss); }
    .main_80034C50 0x80034C50 : AT(0x00035850) { FILL(0x00000000); build/asm/main_80034C50.s.o(.text); build/asm/main_80034C50.s.o(.rodata); build/asm/main_80034C50.s.o(.data); }
    .main_80034C50_bss (NOLOAD) : { build/asm/main_80034C50.s.o(.bss); }
    .main_80035110 0x80035110 : AT(0x00035D10) { FILL(0x00000000); build/asm/main_80035110.s.o(.text); build/asm/main_80035110.s.o(.rodata); build/asm/main_80035110.s.o(.data); }
    .main_80035110_bss (NOLOAD) : { build/asm/main_80035110.s.o(.bss); }
    .main_800351A0 0x800351A0 : AT(0x00035DA0) { FILL(0x00000000); build/asm/main_800351A0.s.o(.text); build/asm/main_800351A0.s.o(.rodata); build/asm/main_800351A0.s.o(.data); }
    .main_800351A0_bss (NOLOAD) : { build/asm/main_800351A0.s.o(.bss); }
    .main_80035340 0x80035340 : AT(0x00035F40) { FILL(0x00000000); build/asm/main_80035340.s.o(.text); build/asm/main_80035340.s.o(.rodata); build/asm/main_80035340.s.o(.data); }
    .main_80035340_bss (NOLOAD) : { build/asm/main_80035340.s.o(.bss); }
    .main_80035550 0x80035550 : AT(0x00036150) { FILL(0x00000000); build/asm/main_80035550.s.o(.text); build/asm/main_80035550.s.o(.rodata); build/asm/main_80035550.s.o(.data); }
    .main_80035550_bss (NOLOAD) : { build/asm/main_80035550.s.o(.bss); }
    .main_80035960 0x80035960 : AT(0x00036560) { FILL(0x00000000); build/asm/main_80035960.s.o(.text); build/asm/main_80035960.s.o(.rodata); build/asm/main_80035960.s.o(.data); }
    .main_80035960_bss (NOLOAD) : { build/asm/main_80035960.s.o(.bss); }
    .main_80037510 0x80037510 : AT(0x00038110) { build/asm/data/main_80037510.bin.o(.data); }
    .main_8003E560 0x8003E560 : AT(0x0003F160) { FILL(0x00000000); build/asm/main_8003E560.s.o(.text); build/asm/main_8003E560.s.o(.rodata); build/asm/main_8003E560.s.o(.data); }
    .main_8003E560_bss (NOLOAD) : { build/asm/main_8003E560.s.o(.bss); }
    .main_80082544 0x80082544 : AT(0x00083144) { build/asm/data/main_80082544.bin.o(.data); }
    .main_800826A0 0x800826A0 : AT(0x000832A0) { FILL(0x00000000); build/asm/main_800826A0.s.o(.text); build/asm/main_800826A0.s.o(.rodata); build/asm/main_800826A0.s.o(.data); }
    .main_800826A0_bss (NOLOAD) : { build/asm/main_800826A0.s.o(.bss); }
    .main_80099DCC 0x80099DCC : AT(0x0009A9CC) { build/asm/data/main_80099DCC.bin.o(.data); }
    .main_8009AF60 0x8009AF60 : AT(0x0009BB60) { FILL(0x00000000); build/asm/main_8009AF60.s.o(.text); build/asm/main_8009AF60.s.o(.rodata); build/asm/main_8009AF60.s.o(.data); }
    .main_8009AF60_bss (NOLOAD) : { build/asm/main_8009AF60.s.o(.bss); }
    .main_8009D978 0x8009D978 : AT(0x0009E578) { build/asm/data/main_8009D978.bin.o(.data); }
    .main_8009D980 0x8009D980 : AT(0x0009E580) { FILL(0x00000000); build/asm/main_8009D980.s.o(.text); build/asm/main_8009D980.s.o(.rodata); build/asm/main_8009D980.s.o(.data); }
    .main_8009D980_bss (NOLOAD) : { build/asm/main_8009D980.s.o(.bss); }
    .main_8009DD7C 0x8009DD7C : AT(0x0009E97C) { build/asm/data/main_8009DD7C.bin.o(.data); }
    .main_800A2114 0x800A2114 : AT(0x000A2D14) { FILL(0x00000000); build/asm/main_800A2114.s.o(.text); build/asm/main_800A2114.s.o(.rodata); build/asm/main_800A2114.s.o(.data); }
    .main_800A2114_bss (NOLOAD) : { build/asm/main_800A2114.s.o(.bss); }
    .main_800A2FE4 0x800A2FE4 : AT(0x000A3BE4) { build/asm/data/main_800A2FE4.bin.o(.data); }
    .main_800A9B80 0x800A9B80 : AT(0x000AA780) { FILL(0x00000000); build/asm/main_800A9B80.s.o(.text); build/asm/main_800A9B80.s.o(.rodata); build/asm/main_800A9B80.s.o(.data); }
    .main_800A9B80_bss (NOLOAD) : { build/asm/main_800A9B80.s.o(.bss); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
