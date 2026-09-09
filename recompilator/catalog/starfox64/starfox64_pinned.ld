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
    .main_80020920 0x80020920 : AT(0x00021520) { FILL(0x00000000); build/asm/main_80020920.s.o(.text); build/asm/main_80020920.s.o(.rodata); build/asm/main_80020920.s.o(.data); }
    .main_80020920_bss (NOLOAD) : { build/asm/main_80020920.s.o(.bss); }
    .main_80021900 0x80021900 : AT(0x00022500) { FILL(0x00000000); build/asm/main_80021900.s.o(.text); build/asm/main_80021900.s.o(.rodata); build/asm/main_80021900.s.o(.data); }
    .main_80021900_bss (NOLOAD) : { build/asm/main_80021900.s.o(.bss); }
    .main_800219F0 0x800219F0 : AT(0x000225F0) { FILL(0x00000000); build/asm/main_800219F0.s.o(.text); build/asm/main_800219F0.s.o(.rodata); build/asm/main_800219F0.s.o(.data); }
    .main_800219F0_bss (NOLOAD) : { build/asm/main_800219F0.s.o(.bss); }
    .main_80021B30 0x80021B30 : AT(0x00022730) { FILL(0x00000000); build/asm/main_80021B30.s.o(.text); build/asm/main_80021B30.s.o(.rodata); build/asm/main_80021B30.s.o(.data); }
    .main_80021B30_bss (NOLOAD) : { build/asm/main_80021B30.s.o(.bss); }
    .main_80022190 0x80022190 : AT(0x00022D90) { FILL(0x00000000); build/asm/main_80022190.s.o(.text); build/asm/main_80022190.s.o(.rodata); build/asm/main_80022190.s.o(.data); }
    .main_80022190_bss (NOLOAD) : { build/asm/main_80022190.s.o(.bss); }
    .main_800227A0 0x800227A0 : AT(0x000233A0) { FILL(0x00000000); build/asm/main_800227A0.s.o(.text); build/asm/main_800227A0.s.o(.rodata); build/asm/main_800227A0.s.o(.data); }
    .main_800227A0_bss (NOLOAD) : { build/asm/main_800227A0.s.o(.bss); }
    .main_80022D30 0x80022D30 : AT(0x00023930) { FILL(0x00000000); build/asm/main_80022D30.s.o(.text); build/asm/main_80022D30.s.o(.rodata); build/asm/main_80022D30.s.o(.data); }
    .main_80022D30_bss (NOLOAD) : { build/asm/main_80022D30.s.o(.bss); }
    .main_80023150 0x80023150 : AT(0x00023D50) { FILL(0x00000000); build/asm/main_80023150.s.o(.text); build/asm/main_80023150.s.o(.rodata); build/asm/main_80023150.s.o(.data); }
    .main_80023150_bss (NOLOAD) : { build/asm/main_80023150.s.o(.bss); }
    .main_80023BC4 0x80023BC4 : AT(0x000247C4) { FILL(0x00000000); build/asm/main_80023BC4.s.o(.text); build/asm/main_80023BC4.s.o(.rodata); build/asm/main_80023BC4.s.o(.data); }
    .main_80023BC4_bss (NOLOAD) : { build/asm/main_80023BC4.s.o(.bss); }
    .main_80024B60 0x80024B60 : AT(0x00025760) { FILL(0x00000000); build/asm/main_80024B60.s.o(.text); build/asm/main_80024B60.s.o(.rodata); build/asm/main_80024B60.s.o(.data); }
    .main_80024B60_bss (NOLOAD) : { build/asm/main_80024B60.s.o(.bss); }
    .main_80024E00 0x80024E00 : AT(0x00025A00) { FILL(0x00000000); build/asm/main_80024E00.s.o(.text); build/asm/main_80024E00.s.o(.rodata); build/asm/main_80024E00.s.o(.data); }
    .main_80024E00_bss (NOLOAD) : { build/asm/main_80024E00.s.o(.bss); }
    .main_80024FB0 0x80024FB0 : AT(0x00025BB0) { FILL(0x00000000); build/asm/main_80024FB0.s.o(.text); build/asm/main_80024FB0.s.o(.rodata); build/asm/main_80024FB0.s.o(.data); }
    .main_80024FB0_bss (NOLOAD) : { build/asm/main_80024FB0.s.o(.bss); }
    .main_80025534 0x80025534 : AT(0x00026134) { FILL(0x00000000); build/asm/main_80025534.s.o(.text); build/asm/main_80025534.s.o(.rodata); build/asm/main_80025534.s.o(.data); }
    .main_80025534_bss (NOLOAD) : { build/asm/main_80025534.s.o(.bss); }
    .main_80025AA0 0x80025AA0 : AT(0x000266A0) { FILL(0x00000000); build/asm/main_80025AA0.s.o(.text); build/asm/main_80025AA0.s.o(.rodata); build/asm/main_80025AA0.s.o(.data); }
    .main_80025AA0_bss (NOLOAD) : { build/asm/main_80025AA0.s.o(.bss); }
    .main_800268C0 0x800268C0 : AT(0x000274C0) { FILL(0x00000000); build/asm/main_800268C0.s.o(.text); build/asm/main_800268C0.s.o(.rodata); build/asm/main_800268C0.s.o(.data); }
    .main_800268C0_bss (NOLOAD) : { build/asm/main_800268C0.s.o(.bss); }
    .main_80026EA0 0x80026EA0 : AT(0x00027AA0) { FILL(0x00000000); build/asm/main_80026EA0.s.o(.text); build/asm/main_80026EA0.s.o(.rodata); build/asm/main_80026EA0.s.o(.data); }
    .main_80026EA0_bss (NOLOAD) : { build/asm/main_80026EA0.s.o(.bss); }
    .main_80027380 0x80027380 : AT(0x00027F80) { FILL(0x00000000); build/asm/main_80027380.s.o(.text); build/asm/main_80027380.s.o(.rodata); build/asm/main_80027380.s.o(.data); }
    .main_80027380_bss (NOLOAD) : { build/asm/main_80027380.s.o(.bss); }
    .main_80027990 0x80027990 : AT(0x00028590) { FILL(0x00000000); build/asm/main_80027990.s.o(.text); build/asm/main_80027990.s.o(.rodata); build/asm/main_80027990.s.o(.data); }
    .main_80027990_bss (NOLOAD) : { build/asm/main_80027990.s.o(.bss); }
    .main_80028050 0x80028050 : AT(0x00028C50) { FILL(0x00000000); build/asm/main_80028050.s.o(.text); build/asm/main_80028050.s.o(.rodata); build/asm/main_80028050.s.o(.data); }
    .main_80028050_bss (NOLOAD) : { build/asm/main_80028050.s.o(.bss); }
    .main_80028080 0x80028080 : AT(0x00028C80) { FILL(0x00000000); build/asm/main_80028080.s.o(.text); build/asm/main_80028080.s.o(.rodata); build/asm/main_80028080.s.o(.data); }
    .main_80028080_bss (NOLOAD) : { build/asm/main_80028080.s.o(.bss); }
    .main_80028280 0x80028280 : AT(0x00028E80) { FILL(0x00000000); build/asm/main_80028280.s.o(.text); build/asm/main_80028280.s.o(.rodata); build/asm/main_80028280.s.o(.data); }
    .main_80028280_bss (NOLOAD) : { build/asm/main_80028280.s.o(.bss); }
    .main_80029A60 0x80029A60 : AT(0x0002A660) { FILL(0x00000000); build/asm/main_80029A60.s.o(.text); build/asm/main_80029A60.s.o(.rodata); build/asm/main_80029A60.s.o(.data); }
    .main_80029A60_bss (NOLOAD) : { build/asm/main_80029A60.s.o(.bss); }
    .main_800318C0 0x800318C0 : AT(0x000324C0) { FILL(0x00000000); build/asm/main_800318C0.s.o(.text); build/asm/main_800318C0.s.o(.rodata); build/asm/main_800318C0.s.o(.data); }
    .main_800318C0_bss (NOLOAD) : { build/asm/main_800318C0.s.o(.bss); }
    .main_8004E114 0x8004E114 : AT(0x0004ED14) { FILL(0x00000000); build/asm/main_8004E114.s.o(.text); build/asm/main_8004E114.s.o(.rodata); build/asm/main_8004E114.s.o(.data); }
    .main_8004E114_bss (NOLOAD) : { build/asm/main_8004E114.s.o(.bss); }
    .main_8004F1E8 0x8004F1E8 : AT(0x0004FDE8) { FILL(0x00000000); build/asm/main_8004F1E8.s.o(.text); build/asm/main_8004F1E8.s.o(.rodata); build/asm/main_8004F1E8.s.o(.data); }
    .main_8004F1E8_bss (NOLOAD) : { build/asm/main_8004F1E8.s.o(.bss); }
    .main_8005693C 0x8005693C : AT(0x0005753C) { FILL(0x00000000); build/asm/main_8005693C.s.o(.text); build/asm/main_8005693C.s.o(.rodata); build/asm/main_8005693C.s.o(.data); }
    .main_8005693C_bss (NOLOAD) : { build/asm/main_8005693C.s.o(.bss); }
    .main_80062A80 0x80062A80 : AT(0x00063680) { FILL(0x00000000); build/asm/main_80062A80.s.o(.text); build/asm/main_80062A80.s.o(.rodata); build/asm/main_80062A80.s.o(.data); }
    .main_80062A80_bss (NOLOAD) : { build/asm/main_80062A80.s.o(.bss); }
    .main_800709CC 0x800709CC : AT(0x000715CC) { FILL(0x00000000); build/asm/main_800709CC.s.o(.text); build/asm/main_800709CC.s.o(.rodata); build/asm/main_800709CC.s.o(.data); }
    .main_800709CC_bss (NOLOAD) : { build/asm/main_800709CC.s.o(.bss); }
    .main_80075E1C 0x80075E1C : AT(0x00076A1C) { FILL(0x00000000); build/asm/main_80075E1C.s.o(.text); build/asm/main_80075E1C.s.o(.rodata); build/asm/main_80075E1C.s.o(.data); }
    .main_80075E1C_bss (NOLOAD) : { build/asm/main_80075E1C.s.o(.bss); }
    .main_800BE248 0x800BE248 : AT(0x000BEE48) { FILL(0x00000000); build/asm/main_800BE248.s.o(.text); build/asm/main_800BE248.s.o(.rodata); build/asm/main_800BE248.s.o(.data); }
    .main_800BE248_bss (NOLOAD) : { build/asm/main_800BE248.s.o(.bss); }
    .main_800C0190 0x800C0190 : AT(0x000C0D90) { FILL(0x00000000); build/asm/main_800C0190.s.o(.text); build/asm/main_800C0190.s.o(.rodata); build/asm/main_800C0190.s.o(.data); }
    .main_800C0190_bss (NOLOAD) : { build/asm/main_800C0190.s.o(.bss); }
    .main_800C0DE0 0x800C0DE0 : AT(0x000C19E0) { FILL(0x00000000); build/asm/main_800C0DE0.s.o(.text); build/asm/main_800C0DE0.s.o(.rodata); build/asm/main_800C0DE0.s.o(.data); }
    .main_800C0DE0_bss (NOLOAD) : { build/asm/main_800C0DE0.s.o(.bss); }
    .main_800C0E5C 0x800C0E5C : AT(0x000C1A5C) { build/asm/data/main_800C0E5C.bin.o(.data); }
    .main_800C1FD0 0x800C1FD0 : AT(0x000C2BD0) { build/asm/data/main_800C1FD0.bin.o(.data); }
    .main_800C2FAC 0x800C2FAC : AT(0x000C3BAC) { FILL(0x00000000); build/asm/main_800C2FAC.s.o(.text); build/asm/main_800C2FAC.s.o(.rodata); build/asm/main_800C2FAC.s.o(.data); }
    .main_800C2FAC_bss (NOLOAD) : { build/asm/main_800C2FAC.s.o(.bss); }
    .main_800C3204 0x800C3204 : AT(0x000C3E04) { FILL(0x00000000); build/asm/main_800C3204.s.o(.text); build/asm/main_800C3204.s.o(.rodata); build/asm/main_800C3204.s.o(.data); }
    .main_800C3204_bss (NOLOAD) : { build/asm/main_800C3204.s.o(.bss); }
    .main_800C4970 0x800C4970 : AT(0x000C5570) { build/asm/data/main_800C4970.bin.o(.data); }
    .main_800C5CFC 0x800C5CFC : AT(0x000C68FC) { FILL(0x00000000); build/asm/main_800C5CFC.s.o(.text); build/asm/main_800C5CFC.s.o(.rodata); build/asm/main_800C5CFC.s.o(.data); }
    .main_800C5CFC_bss (NOLOAD) : { build/asm/main_800C5CFC.s.o(.bss); }
    .main_800C9D0C 0x800C9D0C : AT(0x000CA90C) { build/asm/data/main_800C9D0C.bin.o(.data); }
    .main_800CED38 0x800CED38 : AT(0x000CF938) { FILL(0x00000000); build/asm/main_800CED38.s.o(.text); build/asm/main_800CED38.s.o(.rodata); build/asm/main_800CED38.s.o(.data); }
    .main_800CED38_bss (NOLOAD) : { build/asm/main_800CED38.s.o(.bss); }
    .main_800D1194 0x800D1194 : AT(0x000D1D94) { FILL(0x00000000); build/asm/main_800D1194.s.o(.text); build/asm/main_800D1194.s.o(.rodata); build/asm/main_800D1194.s.o(.data); }
    .main_800D1194_bss (NOLOAD) : { build/asm/main_800D1194.s.o(.bss); }
    .main_800D178C 0x800D178C : AT(0x000D238C) { build/asm/data/main_800D178C.bin.o(.data); }
    .main_800D28DC 0x800D28DC : AT(0x000D34DC) { FILL(0x00000000); build/asm/main_800D28DC.s.o(.text); build/asm/main_800D28DC.s.o(.rodata); build/asm/main_800D28DC.s.o(.data); }
    .main_800D28DC_bss (NOLOAD) : { build/asm/main_800D28DC.s.o(.bss); }
    .main_800D413C 0x800D413C : AT(0x000D4D3C) { FILL(0x00000000); build/asm/main_800D413C.s.o(.text); build/asm/main_800D413C.s.o(.rodata); build/asm/main_800D413C.s.o(.data); }
    .main_800D413C_bss (NOLOAD) : { build/asm/main_800D413C.s.o(.bss); }
    .main_800D4440 0x800D4440 : AT(0x000D5040) { build/asm/data/main_800D4440.bin.o(.data); }
    .main_800D7AD8 0x800D7AD8 : AT(0x000D86D8) { build/asm/data/main_800D7AD8.bin.o(.data); }
    .main_800D82FC 0x800D82FC : AT(0x000D8EFC) { FILL(0x00000000); build/asm/main_800D82FC.s.o(.text); build/asm/main_800D82FC.s.o(.rodata); build/asm/main_800D82FC.s.o(.data); }
    .main_800D82FC_bss (NOLOAD) : { build/asm/main_800D82FC.s.o(.bss); }
    .main_800DC1AC 0x800DC1AC : AT(0x000DCDAC) { build/asm/data/main_800DC1AC.bin.o(.data); }
    .main_800DCCC8 0x800DCCC8 : AT(0x000DD8C8) { build/asm/data/main_800DCCC8.bin.o(.data); }
    .main_800DD84C 0x800DD84C : AT(0x000DE44C) { build/asm/data/main_800DD84C.bin.o(.data); }
    .main_800DE850 0x800DE850 : AT(0x000DF450) { build/asm/data/main_800DE850.bin.o(.data); }
    .main_800E4060 0x800E4060 : AT(0x000E4C60) { FILL(0x00000000); build/asm/main_800E4060.s.o(.text); build/asm/main_800E4060.s.o(.rodata); build/asm/main_800E4060.s.o(.data); }
    .main_800E4060_bss (NOLOAD) : { build/asm/main_800E4060.s.o(.bss); }
    .main_800E4070 0x800E4070 : AT(0x000E4C70) { build/asm/data/main_800E4070.bin.o(.data); }
    .main_800FE0F4 0x800FE0F4 : AT(0x000FECF4) { FILL(0x00000000); build/asm/main_800FE0F4.s.o(.text); build/asm/main_800FE0F4.s.o(.rodata); build/asm/main_800FE0F4.s.o(.data); }
    .main_800FE0F4_bss (NOLOAD) : { build/asm/main_800FE0F4.s.o(.bss); }
    .main_800FE180 0x800FE180 : AT(0x000FED80) { build/asm/data/main_800FE180.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
