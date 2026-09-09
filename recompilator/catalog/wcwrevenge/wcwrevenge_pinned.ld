SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004B8 0x800004B8 : AT(0x000010B8) { FILL(0x00000000); build/asm/main_800004B8.s.o(.text); build/asm/main_800004B8.s.o(.rodata); build/asm/main_800004B8.s.o(.data); }
    .main_800004B8_bss (NOLOAD) : { build/asm/main_800004B8.s.o(.bss); }
    .main_800264BC 0x800264BC : AT(0x000270BC) { FILL(0x00000000); build/asm/main_800264BC.s.o(.text); build/asm/main_800264BC.s.o(.rodata); build/asm/main_800264BC.s.o(.data); }
    .main_800264BC_bss (NOLOAD) : { build/asm/main_800264BC.s.o(.bss); }
    .main_800268A0 0x800268A0 : AT(0x000274A0) { FILL(0x00000000); build/asm/main_800268A0.s.o(.text); build/asm/main_800268A0.s.o(.rodata); build/asm/main_800268A0.s.o(.data); }
    .main_800268A0_bss (NOLOAD) : { build/asm/main_800268A0.s.o(.bss); }
    .main_8002DB4C 0x8002DB4C : AT(0x0002E74C) { FILL(0x00000000); build/asm/main_8002DB4C.s.o(.text); build/asm/main_8002DB4C.s.o(.rodata); build/asm/main_8002DB4C.s.o(.data); }
    .main_8002DB4C_bss (NOLOAD) : { build/asm/main_8002DB4C.s.o(.bss); }
    .main_8002EEDC 0x8002EEDC : AT(0x0002FADC) { build/asm/data/main_8002EEDC.bin.o(.data); }
    .main_80031490 0x80031490 : AT(0x00032090) { FILL(0x00000000); build/asm/main_80031490.s.o(.text); build/asm/main_80031490.s.o(.rodata); build/asm/main_80031490.s.o(.data); }
    .main_80031490_bss (NOLOAD) : { build/asm/main_80031490.s.o(.bss); }
    .main_800317F0 0x800317F0 : AT(0x000323F0) { build/asm/data/main_800317F0.bin.o(.data); }
    .main_800322B4 0x800322B4 : AT(0x00032EB4) { build/asm/data/main_800322B4.bin.o(.data); }
    .main_800329F0 0x800329F0 : AT(0x000335F0) { FILL(0x00000000); build/asm/main_800329F0.s.o(.text); build/asm/main_800329F0.s.o(.rodata); build/asm/main_800329F0.s.o(.data); }
    .main_800329F0_bss (NOLOAD) : { build/asm/main_800329F0.s.o(.bss); }
    .main_800329FC 0x800329FC : AT(0x000335FC) { build/asm/data/main_800329FC.bin.o(.data); }
    .main_80032A14 0x80032A14 : AT(0x00033614) { FILL(0x00000000); build/asm/main_80032A14.s.o(.text); build/asm/main_80032A14.s.o(.rodata); build/asm/main_80032A14.s.o(.data); }
    .main_80032A14_bss (NOLOAD) : { build/asm/main_80032A14.s.o(.bss); }
    .main_80032A20 0x80032A20 : AT(0x00033620) { build/asm/data/main_80032A20.bin.o(.data); }
    .main_80032A80 0x80032A80 : AT(0x00033680) { FILL(0x00000000); build/asm/main_80032A80.s.o(.text); build/asm/main_80032A80.s.o(.rodata); build/asm/main_80032A80.s.o(.data); }
    .main_80032A80_bss (NOLOAD) : { build/asm/main_80032A80.s.o(.bss); }
    .main_80032A8C 0x80032A8C : AT(0x0003368C) { build/asm/data/main_80032A8C.bin.o(.data); }
    .main_80032AC8 0x80032AC8 : AT(0x000336C8) { FILL(0x00000000); build/asm/main_80032AC8.s.o(.text); build/asm/main_80032AC8.s.o(.rodata); build/asm/main_80032AC8.s.o(.data); }
    .main_80032AC8_bss (NOLOAD) : { build/asm/main_80032AC8.s.o(.bss); }
    .main_80032AD4 0x80032AD4 : AT(0x000336D4) { build/asm/data/main_80032AD4.bin.o(.data); }
    .main_80032BD8 0x80032BD8 : AT(0x000337D8) { build/asm/data/main_80032BD8.bin.o(.data); }
    .main_80032C0C 0x80032C0C : AT(0x0003380C) { FILL(0x00000000); build/asm/main_80032C0C.s.o(.text); build/asm/main_80032C0C.s.o(.rodata); build/asm/main_80032C0C.s.o(.data); }
    .main_80032C0C_bss (NOLOAD) : { build/asm/main_80032C0C.s.o(.bss); }
    .main_80032C18 0x80032C18 : AT(0x00033818) { build/asm/data/main_80032C18.bin.o(.data); }
    .main_80032C64 0x80032C64 : AT(0x00033864) { FILL(0x00000000); build/asm/main_80032C64.s.o(.text); build/asm/main_80032C64.s.o(.rodata); build/asm/main_80032C64.s.o(.data); }
    .main_80032C64_bss (NOLOAD) : { build/asm/main_80032C64.s.o(.bss); }
    .main_80032C70 0x80032C70 : AT(0x00033870) { build/asm/data/main_80032C70.bin.o(.data); }
    .main_800360FC 0x800360FC : AT(0x00036CFC) { FILL(0x00000000); build/asm/main_800360FC.s.o(.text); build/asm/main_800360FC.s.o(.rodata); build/asm/main_800360FC.s.o(.data); }
    .main_800360FC_bss (NOLOAD) : { build/asm/main_800360FC.s.o(.bss); }
    .main_80036348 0x80036348 : AT(0x00036F48) { build/asm/data/main_80036348.bin.o(.data); }
    .main_800363A0 0x800363A0 : AT(0x00036FA0) { FILL(0x00000000); build/asm/main_800363A0.s.o(.text); build/asm/main_800363A0.s.o(.rodata); build/asm/main_800363A0.s.o(.data); }
    .main_800363A0_bss (NOLOAD) : { build/asm/main_800363A0.s.o(.bss); }
    .main_80036550 0x80036550 : AT(0x00037150) { build/asm/data/main_80036550.bin.o(.data); }
    .main_80036744 0x80036744 : AT(0x00037344) { FILL(0x00000000); build/asm/main_80036744.s.o(.text); build/asm/main_80036744.s.o(.rodata); build/asm/main_80036744.s.o(.data); }
    .main_80036744_bss (NOLOAD) : { build/asm/main_80036744.s.o(.bss); }
    .main_80036760 0x80036760 : AT(0x00037360) { FILL(0x00000000); build/asm/main_80036760.s.o(.text); build/asm/main_80036760.s.o(.rodata); build/asm/main_80036760.s.o(.data); }
    .main_80036760_bss (NOLOAD) : { build/asm/main_80036760.s.o(.bss); }
    .main_800367B0 0x800367B0 : AT(0x000373B0) { FILL(0x00000000); build/asm/main_800367B0.s.o(.text); build/asm/main_800367B0.s.o(.rodata); build/asm/main_800367B0.s.o(.data); }
    .main_800367B0_bss (NOLOAD) : { build/asm/main_800367B0.s.o(.bss); }
    .main_8003683C 0x8003683C : AT(0x0003743C) { FILL(0x00000000); build/asm/main_8003683C.s.o(.text); build/asm/main_8003683C.s.o(.rodata); build/asm/main_8003683C.s.o(.data); }
    .main_8003683C_bss (NOLOAD) : { build/asm/main_8003683C.s.o(.bss); }
    .main_80036D84 0x80036D84 : AT(0x00037984) { FILL(0x00000000); build/asm/main_80036D84.s.o(.text); build/asm/main_80036D84.s.o(.rodata); build/asm/main_80036D84.s.o(.data); }
    .main_80036D84_bss (NOLOAD) : { build/asm/main_80036D84.s.o(.bss); }
    .main_80036DD4 0x80036DD4 : AT(0x000379D4) { FILL(0x00000000); build/asm/main_80036DD4.s.o(.text); build/asm/main_80036DD4.s.o(.rodata); build/asm/main_80036DD4.s.o(.data); }
    .main_80036DD4_bss (NOLOAD) : { build/asm/main_80036DD4.s.o(.bss); }
    .main_80036E10 0x80036E10 : AT(0x00037A10) { FILL(0x00000000); build/asm/main_80036E10.s.o(.text); build/asm/main_80036E10.s.o(.rodata); build/asm/main_80036E10.s.o(.data); }
    .main_80036E10_bss (NOLOAD) : { build/asm/main_80036E10.s.o(.bss); }
    .main_80036E68 0x80036E68 : AT(0x00037A68) { build/asm/data/main_80036E68.bin.o(.data); }
    .main_800372B0 0x800372B0 : AT(0x00037EB0) { FILL(0x00000000); build/asm/main_800372B0.s.o(.text); build/asm/main_800372B0.s.o(.rodata); build/asm/main_800372B0.s.o(.data); }
    .main_800372B0_bss (NOLOAD) : { build/asm/main_800372B0.s.o(.bss); }
    .main_800373A0 0x800373A0 : AT(0x00037FA0) { FILL(0x00000000); build/asm/main_800373A0.s.o(.text); build/asm/main_800373A0.s.o(.rodata); build/asm/main_800373A0.s.o(.data); }
    .main_800373A0_bss (NOLOAD) : { build/asm/main_800373A0.s.o(.bss); }
    .main_80037408 0x80037408 : AT(0x00038008) { FILL(0x00000000); build/asm/main_80037408.s.o(.text); build/asm/main_80037408.s.o(.rodata); build/asm/main_80037408.s.o(.data); }
    .main_80037408_bss (NOLOAD) : { build/asm/main_80037408.s.o(.bss); }
    .main_8003740C 0x8003740C : AT(0x0003800C) { build/asm/data/main_8003740C.bin.o(.data); }
    .main_80037460 0x80037460 : AT(0x00038060) { FILL(0x00000000); build/asm/main_80037460.s.o(.text); build/asm/main_80037460.s.o(.rodata); build/asm/main_80037460.s.o(.data); }
    .main_80037460_bss (NOLOAD) : { build/asm/main_80037460.s.o(.bss); }
    .main_800374D4 0x800374D4 : AT(0x000380D4) { build/asm/data/main_800374D4.bin.o(.data); }
    .main_800374E8 0x800374E8 : AT(0x000380E8) { FILL(0x00000000); build/asm/main_800374E8.s.o(.text); build/asm/main_800374E8.s.o(.rodata); build/asm/main_800374E8.s.o(.data); }
    .main_800374E8_bss (NOLOAD) : { build/asm/main_800374E8.s.o(.bss); }
    .main_80037758 0x80037758 : AT(0x00038358) { FILL(0x00000000); build/asm/main_80037758.s.o(.text); build/asm/main_80037758.s.o(.rodata); build/asm/main_80037758.s.o(.data); }
    .main_80037758_bss (NOLOAD) : { build/asm/main_80037758.s.o(.bss); }
    .main_800377B8 0x800377B8 : AT(0x000383B8) { build/asm/data/main_800377B8.bin.o(.data); }
    .main_80037E44 0x80037E44 : AT(0x00038A44) { FILL(0x00000000); build/asm/main_80037E44.s.o(.text); build/asm/main_80037E44.s.o(.rodata); build/asm/main_80037E44.s.o(.data); }
    .main_80037E44_bss (NOLOAD) : { build/asm/main_80037E44.s.o(.bss); }
    .main_80037E68 0x80037E68 : AT(0x00038A68) { build/asm/data/main_80037E68.bin.o(.data); }
    .main_80037EF0 0x80037EF0 : AT(0x00038AF0) { FILL(0x00000000); build/asm/main_80037EF0.s.o(.text); build/asm/main_80037EF0.s.o(.rodata); build/asm/main_80037EF0.s.o(.data); }
    .main_80037EF0_bss (NOLOAD) : { build/asm/main_80037EF0.s.o(.bss); }
    .main_80038220 0x80038220 : AT(0x00038E20) { build/asm/data/main_80038220.bin.o(.data); }
    .main_80039898 0x80039898 : AT(0x0003A498) { build/asm/data/main_80039898.bin.o(.data); }
    .main_80039C44 0x80039C44 : AT(0x0003A844) { build/asm/data/main_80039C44.bin.o(.data); }
    .main_8003B190 0x8003B190 : AT(0x0003BD90) { FILL(0x00000000); build/asm/main_8003B190.s.o(.text); build/asm/main_8003B190.s.o(.rodata); build/asm/main_8003B190.s.o(.data); }
    .main_8003B190_bss (NOLOAD) : { build/asm/main_8003B190.s.o(.bss); }
    .main_8003BE58 0x8003BE58 : AT(0x0003CA58) { FILL(0x00000000); build/asm/main_8003BE58.s.o(.text); build/asm/main_8003BE58.s.o(.rodata); build/asm/main_8003BE58.s.o(.data); }
    .main_8003BE58_bss (NOLOAD) : { build/asm/main_8003BE58.s.o(.bss); }
    .main_8004300C 0x8004300C : AT(0x00043C0C) { FILL(0x00000000); build/asm/main_8004300C.s.o(.text); build/asm/main_8004300C.s.o(.rodata); build/asm/main_8004300C.s.o(.data); }
    .main_8004300C_bss (NOLOAD) : { build/asm/main_8004300C.s.o(.bss); }
    .main_800531E8 0x800531E8 : AT(0x00053DE8) { FILL(0x00000000); build/asm/main_800531E8.s.o(.text); build/asm/main_800531E8.s.o(.rodata); build/asm/main_800531E8.s.o(.data); }
    .main_800531E8_bss (NOLOAD) : { build/asm/main_800531E8.s.o(.bss); }
    .main_8005AE4C 0x8005AE4C : AT(0x0005BA4C) { FILL(0x00000000); build/asm/main_8005AE4C.s.o(.text); build/asm/main_8005AE4C.s.o(.rodata); build/asm/main_8005AE4C.s.o(.data); }
    .main_8005AE4C_bss (NOLOAD) : { build/asm/main_8005AE4C.s.o(.bss); }
    .main_80072DD0 0x80072DD0 : AT(0x000739D0) { build/asm/data/main_80072DD0.bin.o(.data); }
    .main_80073F60 0x80073F60 : AT(0x00074B60) { FILL(0x00000000); build/asm/main_80073F60.s.o(.text); build/asm/main_80073F60.s.o(.rodata); build/asm/main_80073F60.s.o(.data); }
    .main_80073F60_bss (NOLOAD) : { build/asm/main_80073F60.s.o(.bss); }
    .main_80073FD0 0x80073FD0 : AT(0x00074BD0) { build/asm/data/main_80073FD0.bin.o(.data); }
    .main_80074484 0x80074484 : AT(0x00075084) { FILL(0x00000000); build/asm/main_80074484.s.o(.text); build/asm/main_80074484.s.o(.rodata); build/asm/main_80074484.s.o(.data); }
    .main_80074484_bss (NOLOAD) : { build/asm/main_80074484.s.o(.bss); }
    .main_800744B4 0x800744B4 : AT(0x000750B4) { build/asm/data/main_800744B4.bin.o(.data); }
    .main_800746DC 0x800746DC : AT(0x000752DC) { FILL(0x00000000); build/asm/main_800746DC.s.o(.text); build/asm/main_800746DC.s.o(.rodata); build/asm/main_800746DC.s.o(.data); }
    .main_800746DC_bss (NOLOAD) : { build/asm/main_800746DC.s.o(.bss); }
    .main_80074F48 0x80074F48 : AT(0x00075B48) { build/asm/data/main_80074F48.bin.o(.data); }
    .main_800754BC 0x800754BC : AT(0x000760BC) { FILL(0x00000000); build/asm/main_800754BC.s.o(.text); build/asm/main_800754BC.s.o(.rodata); build/asm/main_800754BC.s.o(.data); }
    .main_800754BC_bss (NOLOAD) : { build/asm/main_800754BC.s.o(.bss); }
    .main_800759B8 0x800759B8 : AT(0x000765B8) { build/asm/data/main_800759B8.bin.o(.data); }
    .main_80079B20 0x80079B20 : AT(0x0007A720) { FILL(0x00000000); build/asm/main_80079B20.s.o(.text); build/asm/main_80079B20.s.o(.rodata); build/asm/main_80079B20.s.o(.data); }
    .main_80079B20_bss (NOLOAD) : { build/asm/main_80079B20.s.o(.bss); }
    .main_8007AB70 0x8007AB70 : AT(0x0007B770) { build/asm/data/main_8007AB70.bin.o(.data); }
    .main_8007B5D8 0x8007B5D8 : AT(0x0007C1D8) { FILL(0x00000000); build/asm/main_8007B5D8.s.o(.text); build/asm/main_8007B5D8.s.o(.rodata); build/asm/main_8007B5D8.s.o(.data); }
    .main_8007B5D8_bss (NOLOAD) : { build/asm/main_8007B5D8.s.o(.bss); }
    .main_8007C028 0x8007C028 : AT(0x0007CC28) { FILL(0x00000000); build/asm/main_8007C028.s.o(.text); build/asm/main_8007C028.s.o(.rodata); build/asm/main_8007C028.s.o(.data); }
    .main_8007C028_bss (NOLOAD) : { build/asm/main_8007C028.s.o(.bss); }
    .main_80080000 0x80080000 : AT(0x00080C00) { build/asm/data/main_80080000.bin.o(.data); }
    .main_80090000 0x80090000 : AT(0x00090C00) { FILL(0x00000000); build/asm/main_80090000.s.o(.text); build/asm/main_80090000.s.o(.rodata); build/asm/main_80090000.s.o(.data); }
    .main_80090000_bss (NOLOAD) : { build/asm/main_80090000.s.o(.bss); }
    .main_800C5C80 0x800C5C80 : AT(0x000C6880) { FILL(0x00000000); build/asm/main_800C5C80.s.o(.text); build/asm/main_800C5C80.s.o(.rodata); build/asm/main_800C5C80.s.o(.data); }
    .main_800C5C80_bss (NOLOAD) : { build/asm/main_800C5C80.s.o(.bss); }
    .main_800C5D48 0x800C5D48 : AT(0x000C6948) { FILL(0x00000000); build/asm/main_800C5D48.s.o(.text); build/asm/main_800C5D48.s.o(.rodata); build/asm/main_800C5D48.s.o(.data); }
    .main_800C5D48_bss (NOLOAD) : { build/asm/main_800C5D48.s.o(.bss); }
    .main_800C5FBC 0x800C5FBC : AT(0x000C6BBC) { FILL(0x00000000); build/asm/main_800C5FBC.s.o(.text); build/asm/main_800C5FBC.s.o(.rodata); build/asm/main_800C5FBC.s.o(.data); }
    .main_800C5FBC_bss (NOLOAD) : { build/asm/main_800C5FBC.s.o(.bss); }
    .main_800C6418 0x800C6418 : AT(0x000C7018) { FILL(0x00000000); build/asm/main_800C6418.s.o(.text); build/asm/main_800C6418.s.o(.rodata); build/asm/main_800C6418.s.o(.data); }
    .main_800C6418_bss (NOLOAD) : { build/asm/main_800C6418.s.o(.bss); }
    .main_800C6868 0x800C6868 : AT(0x000C7468) { FILL(0x00000000); build/asm/main_800C6868.s.o(.text); build/asm/main_800C6868.s.o(.rodata); build/asm/main_800C6868.s.o(.data); }
    .main_800C6868_bss (NOLOAD) : { build/asm/main_800C6868.s.o(.bss); }
    .main_800C9014 0x800C9014 : AT(0x000C9C14) { FILL(0x00000000); build/asm/main_800C9014.s.o(.text); build/asm/main_800C9014.s.o(.rodata); build/asm/main_800C9014.s.o(.data); }
    .main_800C9014_bss (NOLOAD) : { build/asm/main_800C9014.s.o(.bss); }
    .main_800C94CC 0x800C94CC : AT(0x000CA0CC) { FILL(0x00000000); build/asm/main_800C94CC.s.o(.text); build/asm/main_800C94CC.s.o(.rodata); build/asm/main_800C94CC.s.o(.data); }
    .main_800C94CC_bss (NOLOAD) : { build/asm/main_800C94CC.s.o(.bss); }
    .main_800C9970 0x800C9970 : AT(0x000CA570) { FILL(0x00000000); build/asm/main_800C9970.s.o(.text); build/asm/main_800C9970.s.o(.rodata); build/asm/main_800C9970.s.o(.data); }
    .main_800C9970_bss (NOLOAD) : { build/asm/main_800C9970.s.o(.bss); }
    .main_800CA114 0x800CA114 : AT(0x000CAD14) { FILL(0x00000000); build/asm/main_800CA114.s.o(.text); build/asm/main_800CA114.s.o(.rodata); build/asm/main_800CA114.s.o(.data); }
    .main_800CA114_bss (NOLOAD) : { build/asm/main_800CA114.s.o(.bss); }
    .main_800CB878 0x800CB878 : AT(0x000CC478) { FILL(0x00000000); build/asm/main_800CB878.s.o(.text); build/asm/main_800CB878.s.o(.rodata); build/asm/main_800CB878.s.o(.data); }
    .main_800CB878_bss (NOLOAD) : { build/asm/main_800CB878.s.o(.bss); }
    .main_800CBC4C 0x800CBC4C : AT(0x000CC84C) { FILL(0x00000000); build/asm/main_800CBC4C.s.o(.text); build/asm/main_800CBC4C.s.o(.rodata); build/asm/main_800CBC4C.s.o(.data); }
    .main_800CBC4C_bss (NOLOAD) : { build/asm/main_800CBC4C.s.o(.bss); }
    .main_800CCC64 0x800CCC64 : AT(0x000CD864) { FILL(0x00000000); build/asm/main_800CCC64.s.o(.text); build/asm/main_800CCC64.s.o(.rodata); build/asm/main_800CCC64.s.o(.data); }
    .main_800CCC64_bss (NOLOAD) : { build/asm/main_800CCC64.s.o(.bss); }
    .main_800CCE50 0x800CCE50 : AT(0x000CDA50) { FILL(0x00000000); build/asm/main_800CCE50.s.o(.text); build/asm/main_800CCE50.s.o(.rodata); build/asm/main_800CCE50.s.o(.data); }
    .main_800CCE50_bss (NOLOAD) : { build/asm/main_800CCE50.s.o(.bss); }
    .main_800CD3F8 0x800CD3F8 : AT(0x000CDFF8) { FILL(0x00000000); build/asm/main_800CD3F8.s.o(.text); build/asm/main_800CD3F8.s.o(.rodata); build/asm/main_800CD3F8.s.o(.data); }
    .main_800CD3F8_bss (NOLOAD) : { build/asm/main_800CD3F8.s.o(.bss); }
    .main_800D5438 0x800D5438 : AT(0x000D6038) { build/asm/data/main_800D5438.bin.o(.data); }
    .main_800D548C 0x800D548C : AT(0x000D608C) { FILL(0x00000000); build/asm/main_800D548C.s.o(.text); build/asm/main_800D548C.s.o(.rodata); build/asm/main_800D548C.s.o(.data); }
    .main_800D548C_bss (NOLOAD) : { build/asm/main_800D548C.s.o(.bss); }
    .main_800D54A0 0x800D54A0 : AT(0x000D60A0) { build/asm/data/main_800D54A0.bin.o(.data); }
    .main_800D5B74 0x800D5B74 : AT(0x000D6774) { FILL(0x00000000); build/asm/main_800D5B74.s.o(.text); build/asm/main_800D5B74.s.o(.rodata); build/asm/main_800D5B74.s.o(.data); }
    .main_800D5B74_bss (NOLOAD) : { build/asm/main_800D5B74.s.o(.bss); }
    .main_800D633C 0x800D633C : AT(0x000D6F3C) { FILL(0x00000000); build/asm/main_800D633C.s.o(.text); build/asm/main_800D633C.s.o(.rodata); build/asm/main_800D633C.s.o(.data); }
    .main_800D633C_bss (NOLOAD) : { build/asm/main_800D633C.s.o(.bss); }
    .main_800D6350 0x800D6350 : AT(0x000D6F50) { FILL(0x00000000); build/asm/main_800D6350.s.o(.text); build/asm/main_800D6350.s.o(.rodata); build/asm/main_800D6350.s.o(.data); }
    .main_800D6350_bss (NOLOAD) : { build/asm/main_800D6350.s.o(.bss); }
    .main_800D6498 0x800D6498 : AT(0x000D7098) { FILL(0x00000000); build/asm/main_800D6498.s.o(.text); build/asm/main_800D6498.s.o(.rodata); build/asm/main_800D6498.s.o(.data); }
    .main_800D6498_bss (NOLOAD) : { build/asm/main_800D6498.s.o(.bss); }
    .main_800D65D0 0x800D65D0 : AT(0x000D71D0) { FILL(0x00000000); build/asm/main_800D65D0.s.o(.text); build/asm/main_800D65D0.s.o(.rodata); build/asm/main_800D65D0.s.o(.data); }
    .main_800D65D0_bss (NOLOAD) : { build/asm/main_800D65D0.s.o(.bss); }
    .main_800D6610 0x800D6610 : AT(0x000D7210) { FILL(0x00000000); build/asm/main_800D6610.s.o(.text); build/asm/main_800D6610.s.o(.rodata); build/asm/main_800D6610.s.o(.data); }
    .main_800D6610_bss (NOLOAD) : { build/asm/main_800D6610.s.o(.bss); }
    .main_800D6648 0x800D6648 : AT(0x000D7248) { FILL(0x00000000); build/asm/main_800D6648.s.o(.text); build/asm/main_800D6648.s.o(.rodata); build/asm/main_800D6648.s.o(.data); }
    .main_800D6648_bss (NOLOAD) : { build/asm/main_800D6648.s.o(.bss); }
    .main_800D6E78 0x800D6E78 : AT(0x000D7A78) { build/asm/data/main_800D6E78.bin.o(.data); }
    .main_800D7A2C 0x800D7A2C : AT(0x000D862C) { FILL(0x00000000); build/asm/main_800D7A2C.s.o(.text); build/asm/main_800D7A2C.s.o(.rodata); build/asm/main_800D7A2C.s.o(.data); }
    .main_800D7A2C_bss (NOLOAD) : { build/asm/main_800D7A2C.s.o(.bss); }
    .main_800D7E80 0x800D7E80 : AT(0x000D8A80) { build/asm/data/main_800D7E80.bin.o(.data); }
    .main_800D93DC 0x800D93DC : AT(0x000D9FDC) { FILL(0x00000000); build/asm/main_800D93DC.s.o(.text); build/asm/main_800D93DC.s.o(.rodata); build/asm/main_800D93DC.s.o(.data); }
    .main_800D93DC_bss (NOLOAD) : { build/asm/main_800D93DC.s.o(.bss); }
    .main_800D96A0 0x800D96A0 : AT(0x000DA2A0) { build/asm/data/main_800D96A0.bin.o(.data); }
    .main_800DA9C0 0x800DA9C0 : AT(0x000DB5C0) { FILL(0x00000000); build/asm/main_800DA9C0.s.o(.text); build/asm/main_800DA9C0.s.o(.rodata); build/asm/main_800DA9C0.s.o(.data); }
    .main_800DA9C0_bss (NOLOAD) : { build/asm/main_800DA9C0.s.o(.bss); }
    .main_800DA9D0 0x800DA9D0 : AT(0x000DB5D0) { build/asm/data/main_800DA9D0.bin.o(.data); }
    .main_800DB4FC 0x800DB4FC : AT(0x000DC0FC) { build/asm/data/main_800DB4FC.bin.o(.data); }
    .main_800DB72C 0x800DB72C : AT(0x000DC32C) { build/asm/data/main_800DB72C.bin.o(.data); }
    .main_800DB874 0x800DB874 : AT(0x000DC474) { FILL(0x00000000); build/asm/main_800DB874.s.o(.text); build/asm/main_800DB874.s.o(.rodata); build/asm/main_800DB874.s.o(.data); }
    .main_800DB874_bss (NOLOAD) : { build/asm/main_800DB874.s.o(.bss); }
    .main_800DBB80 0x800DBB80 : AT(0x000DC780) { build/asm/data/main_800DBB80.bin.o(.data); }
    .main_800DBC94 0x800DBC94 : AT(0x000DC894) { FILL(0x00000000); build/asm/main_800DBC94.s.o(.text); build/asm/main_800DBC94.s.o(.rodata); build/asm/main_800DBC94.s.o(.data); }
    .main_800DBC94_bss (NOLOAD) : { build/asm/main_800DBC94.s.o(.bss); }
    .main_800DBFA0 0x800DBFA0 : AT(0x000DCBA0) { build/asm/data/main_800DBFA0.bin.o(.data); }
    .main_800DC798 0x800DC798 : AT(0x000DD398) { build/asm/data/main_800DC798.bin.o(.data); }
    .main_800DCB54 0x800DCB54 : AT(0x000DD754) { build/asm/data/main_800DCB54.bin.o(.data); }
    .main_800E022C 0x800E022C : AT(0x000E0E2C) { FILL(0x00000000); build/asm/main_800E022C.s.o(.text); build/asm/main_800E022C.s.o(.rodata); build/asm/main_800E022C.s.o(.data); }
    .main_800E022C_bss (NOLOAD) : { build/asm/main_800E022C.s.o(.bss); }
    .main_800E0248 0x800E0248 : AT(0x000E0E48) { build/asm/data/main_800E0248.bin.o(.data); }
    .main_800E0C68 0x800E0C68 : AT(0x000E1868) { FILL(0x00000000); build/asm/main_800E0C68.s.o(.text); build/asm/main_800E0C68.s.o(.rodata); build/asm/main_800E0C68.s.o(.data); }
    .main_800E0C68_bss (NOLOAD) : { build/asm/main_800E0C68.s.o(.bss); }
    .main_800E0D60 0x800E0D60 : AT(0x000E1960) { build/asm/data/main_800E0D60.bin.o(.data); }
    .main_800E3500 0x800E3500 : AT(0x000E4100) { FILL(0x00000000); build/asm/main_800E3500.s.o(.text); build/asm/main_800E3500.s.o(.rodata); build/asm/main_800E3500.s.o(.data); }
    .main_800E3500_bss (NOLOAD) : { build/asm/main_800E3500.s.o(.bss); }
    .main_800E4108 0x800E4108 : AT(0x000E4D08) { build/asm/data/main_800E4108.bin.o(.data); }
    .main_800E4F90 0x800E4F90 : AT(0x000E5B90) { FILL(0x00000000); build/asm/main_800E4F90.s.o(.text); build/asm/main_800E4F90.s.o(.rodata); build/asm/main_800E4F90.s.o(.data); }
    .main_800E4F90_bss (NOLOAD) : { build/asm/main_800E4F90.s.o(.bss); }
    .main_800E56FC 0x800E56FC : AT(0x000E62FC) { FILL(0x00000000); build/asm/main_800E56FC.s.o(.text); build/asm/main_800E56FC.s.o(.rodata); build/asm/main_800E56FC.s.o(.data); }
    .main_800E56FC_bss (NOLOAD) : { build/asm/main_800E56FC.s.o(.bss); }
    .main_800E76F8 0x800E76F8 : AT(0x000E82F8) { FILL(0x00000000); build/asm/main_800E76F8.s.o(.text); build/asm/main_800E76F8.s.o(.rodata); build/asm/main_800E76F8.s.o(.data); }
    .main_800E76F8_bss (NOLOAD) : { build/asm/main_800E76F8.s.o(.bss); }
    .main_800E7D88 0x800E7D88 : AT(0x000E8988) { build/asm/data/main_800E7D88.bin.o(.data); }
    .main_800E8848 0x800E8848 : AT(0x000E9448) { build/asm/data/main_800E8848.bin.o(.data); }
    .main_800E9324 0x800E9324 : AT(0x000E9F24) { FILL(0x00000000); build/asm/main_800E9324.s.o(.text); build/asm/main_800E9324.s.o(.rodata); build/asm/main_800E9324.s.o(.data); }
    .main_800E9324_bss (NOLOAD) : { build/asm/main_800E9324.s.o(.bss); }
    .main_800E9A7C 0x800E9A7C : AT(0x000EA67C) { FILL(0x00000000); build/asm/main_800E9A7C.s.o(.text); build/asm/main_800E9A7C.s.o(.rodata); build/asm/main_800E9A7C.s.o(.data); }
    .main_800E9A7C_bss (NOLOAD) : { build/asm/main_800E9A7C.s.o(.bss); }
    .main_800EA0C8 0x800EA0C8 : AT(0x000EACC8) { FILL(0x00000000); build/asm/main_800EA0C8.s.o(.text); build/asm/main_800EA0C8.s.o(.rodata); build/asm/main_800EA0C8.s.o(.data); }
    .main_800EA0C8_bss (NOLOAD) : { build/asm/main_800EA0C8.s.o(.bss); }
    .main_800EC000 0x800EC000 : AT(0x000ECC00) { build/asm/data/main_800EC000.bin.o(.data); }
    .main_800F3628 0x800F3628 : AT(0x000F4228) { build/asm/data/main_800F3628.bin.o(.data); }
    .main_800F9FD8 0x800F9FD8 : AT(0x000FABD8) { FILL(0x00000000); build/asm/main_800F9FD8.s.o(.text); build/asm/main_800F9FD8.s.o(.rodata); build/asm/main_800F9FD8.s.o(.data); }
    .main_800F9FD8_bss (NOLOAD) : { build/asm/main_800F9FD8.s.o(.bss); }
    .main_800F9FDC 0x800F9FDC : AT(0x000FABDC) { build/asm/data/main_800F9FDC.bin.o(.data); }
    .main_800FB87C 0x800FB87C : AT(0x000FC47C) { FILL(0x00000000); build/asm/main_800FB87C.s.o(.text); build/asm/main_800FB87C.s.o(.rodata); build/asm/main_800FB87C.s.o(.data); }
    .main_800FB87C_bss (NOLOAD) : { build/asm/main_800FB87C.s.o(.bss); }
    .main_800FB880 0x800FB880 : AT(0x000FC480) { build/asm/data/main_800FB880.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
