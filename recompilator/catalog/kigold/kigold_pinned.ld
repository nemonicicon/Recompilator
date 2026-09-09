SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000458 0x80000458 : AT(0x00001058) { FILL(0x00000000); build/asm/main_80000458.s.o(.text); build/asm/main_80000458.s.o(.rodata); build/asm/main_80000458.s.o(.data); }
    .main_80000458_bss (NOLOAD) : { build/asm/main_80000458.s.o(.bss); }
    .main_80002B80 0x80002B80 : AT(0x00003780) { FILL(0x00000000); build/asm/main_80002B80.s.o(.text); build/asm/main_80002B80.s.o(.rodata); build/asm/main_80002B80.s.o(.data); }
    .main_80002B80_bss (NOLOAD) : { build/asm/main_80002B80.s.o(.bss); }
    .main_80003150 0x80003150 : AT(0x00003D50) { FILL(0x00000000); build/asm/main_80003150.s.o(.text); build/asm/main_80003150.s.o(.rodata); build/asm/main_80003150.s.o(.data); }
    .main_80003150_bss (NOLOAD) : { build/asm/main_80003150.s.o(.bss); }
    .main_80003374 0x80003374 : AT(0x00003F74) { FILL(0x00000000); build/asm/main_80003374.s.o(.text); build/asm/main_80003374.s.o(.rodata); build/asm/main_80003374.s.o(.data); }
    .main_80003374_bss (NOLOAD) : { build/asm/main_80003374.s.o(.bss); }
    .main_80003650 0x80003650 : AT(0x00004250) { FILL(0x00000000); build/asm/main_80003650.s.o(.text); build/asm/main_80003650.s.o(.rodata); build/asm/main_80003650.s.o(.data); }
    .main_80003650_bss (NOLOAD) : { build/asm/main_80003650.s.o(.bss); }
    .main_80003BB0 0x80003BB0 : AT(0x000047B0) { FILL(0x00000000); build/asm/main_80003BB0.s.o(.text); build/asm/main_80003BB0.s.o(.rodata); build/asm/main_80003BB0.s.o(.data); }
    .main_80003BB0_bss (NOLOAD) : { build/asm/main_80003BB0.s.o(.bss); }
    .main_80003CD0 0x80003CD0 : AT(0x000048D0) { FILL(0x00000000); build/asm/main_80003CD0.s.o(.text); build/asm/main_80003CD0.s.o(.rodata); build/asm/main_80003CD0.s.o(.data); }
    .main_80003CD0_bss (NOLOAD) : { build/asm/main_80003CD0.s.o(.bss); }
    .main_80003D00 0x80003D00 : AT(0x00004900) { FILL(0x00000000); build/asm/main_80003D00.s.o(.text); build/asm/main_80003D00.s.o(.rodata); build/asm/main_80003D00.s.o(.data); }
    .main_80003D00_bss (NOLOAD) : { build/asm/main_80003D00.s.o(.bss); }
    .main_800042F8 0x800042F8 : AT(0x00004EF8) { FILL(0x00000000); build/asm/main_800042F8.s.o(.text); build/asm/main_800042F8.s.o(.rodata); build/asm/main_800042F8.s.o(.data); }
    .main_800042F8_bss (NOLOAD) : { build/asm/main_800042F8.s.o(.bss); }
    .main_80004690 0x80004690 : AT(0x00005290) { FILL(0x00000000); build/asm/main_80004690.s.o(.text); build/asm/main_80004690.s.o(.rodata); build/asm/main_80004690.s.o(.data); }
    .main_80004690_bss (NOLOAD) : { build/asm/main_80004690.s.o(.bss); }
    .main_800047F4 0x800047F4 : AT(0x000053F4) { FILL(0x00000000); build/asm/main_800047F4.s.o(.text); build/asm/main_800047F4.s.o(.rodata); build/asm/main_800047F4.s.o(.data); }
    .main_800047F4_bss (NOLOAD) : { build/asm/main_800047F4.s.o(.bss); }
    .main_800048A4 0x800048A4 : AT(0x000054A4) { FILL(0x00000000); build/asm/main_800048A4.s.o(.text); build/asm/main_800048A4.s.o(.rodata); build/asm/main_800048A4.s.o(.data); }
    .main_800048A4_bss (NOLOAD) : { build/asm/main_800048A4.s.o(.bss); }
    .main_800048E8 0x800048E8 : AT(0x000054E8) { FILL(0x00000000); build/asm/main_800048E8.s.o(.text); build/asm/main_800048E8.s.o(.rodata); build/asm/main_800048E8.s.o(.data); }
    .main_800048E8_bss (NOLOAD) : { build/asm/main_800048E8.s.o(.bss); }
    .main_80004A50 0x80004A50 : AT(0x00005650) { FILL(0x00000000); build/asm/main_80004A50.s.o(.text); build/asm/main_80004A50.s.o(.rodata); build/asm/main_80004A50.s.o(.data); }
    .main_80004A50_bss (NOLOAD) : { build/asm/main_80004A50.s.o(.bss); }
    .main_80004B70 0x80004B70 : AT(0x00005770) { FILL(0x00000000); build/asm/main_80004B70.s.o(.text); build/asm/main_80004B70.s.o(.rodata); build/asm/main_80004B70.s.o(.data); }
    .main_80004B70_bss (NOLOAD) : { build/asm/main_80004B70.s.o(.bss); }
    .main_80004F20 0x80004F20 : AT(0x00005B20) { FILL(0x00000000); build/asm/main_80004F20.s.o(.text); build/asm/main_80004F20.s.o(.rodata); build/asm/main_80004F20.s.o(.data); }
    .main_80004F20_bss (NOLOAD) : { build/asm/main_80004F20.s.o(.bss); }
    .main_80005800 0x80005800 : AT(0x00006400) { FILL(0x00000000); build/asm/main_80005800.s.o(.text); build/asm/main_80005800.s.o(.rodata); build/asm/main_80005800.s.o(.data); }
    .main_80005800_bss (NOLOAD) : { build/asm/main_80005800.s.o(.bss); }
    .main_80005BE0 0x80005BE0 : AT(0x000067E0) { FILL(0x00000000); build/asm/main_80005BE0.s.o(.text); build/asm/main_80005BE0.s.o(.rodata); build/asm/main_80005BE0.s.o(.data); }
    .main_80005BE0_bss (NOLOAD) : { build/asm/main_80005BE0.s.o(.bss); }
    .main_80006420 0x80006420 : AT(0x00007020) { FILL(0x00000000); build/asm/main_80006420.s.o(.text); build/asm/main_80006420.s.o(.rodata); build/asm/main_80006420.s.o(.data); }
    .main_80006420_bss (NOLOAD) : { build/asm/main_80006420.s.o(.bss); }
    .main_80006584 0x80006584 : AT(0x00007184) { FILL(0x00000000); build/asm/main_80006584.s.o(.text); build/asm/main_80006584.s.o(.rodata); build/asm/main_80006584.s.o(.data); }
    .main_80006584_bss (NOLOAD) : { build/asm/main_80006584.s.o(.bss); }
    .main_800065E8 0x800065E8 : AT(0x000071E8) { FILL(0x00000000); build/asm/main_800065E8.s.o(.text); build/asm/main_800065E8.s.o(.rodata); build/asm/main_800065E8.s.o(.data); }
    .main_800065E8_bss (NOLOAD) : { build/asm/main_800065E8.s.o(.bss); }
    .main_800069E8 0x800069E8 : AT(0x000075E8) { build/asm/data/main_800069E8.bin.o(.data); }
    .main_800073E4 0x800073E4 : AT(0x00007FE4) { build/asm/data/main_800073E4.bin.o(.data); }
    .main_80007C00 0x80007C00 : AT(0x00008800) { build/asm/data/main_80007C00.bin.o(.data); }
    .main_800086E0 0x800086E0 : AT(0x000092E0) { build/asm/data/main_800086E0.bin.o(.data); }
    .main_800095E0 0x800095E0 : AT(0x0000A1E0) { FILL(0x00000000); build/asm/main_800095E0.s.o(.text); build/asm/main_800095E0.s.o(.rodata); build/asm/main_800095E0.s.o(.data); }
    .main_800095E0_bss (NOLOAD) : { build/asm/main_800095E0.s.o(.bss); }
    .main_800095FC 0x800095FC : AT(0x0000A1FC) { build/asm/data/main_800095FC.bin.o(.data); }
    .main_8000D720 0x8000D720 : AT(0x0000E320) { build/asm/data/main_8000D720.bin.o(.data); }
    .main_8000F244 0x8000F244 : AT(0x0000FE44) { build/asm/data/main_8000F244.bin.o(.data); }
    .main_8000FFFC 0x8000FFFC : AT(0x00010BFC) { build/asm/data/main_8000FFFC.bin.o(.data); }
    .main_800123F8 0x800123F8 : AT(0x00012FF8) { FILL(0x00000000); build/asm/main_800123F8.s.o(.text); build/asm/main_800123F8.s.o(.rodata); build/asm/main_800123F8.s.o(.data); }
    .main_800123F8_bss (NOLOAD) : { build/asm/main_800123F8.s.o(.bss); }
    .main_8001246C 0x8001246C : AT(0x0001306C) { build/asm/data/main_8001246C.bin.o(.data); }
    .main_8001BF44 0x8001BF44 : AT(0x0001CB44) { FILL(0x00000000); build/asm/main_8001BF44.s.o(.text); build/asm/main_8001BF44.s.o(.rodata); build/asm/main_8001BF44.s.o(.data); }
    .main_8001BF44_bss (NOLOAD) : { build/asm/main_8001BF44.s.o(.bss); }
    .main_8001BFDC 0x8001BFDC : AT(0x0001CBDC) { build/asm/data/main_8001BFDC.bin.o(.data); }
    .main_8001C214 0x8001C214 : AT(0x0001CE14) { FILL(0x00000000); build/asm/main_8001C214.s.o(.text); build/asm/main_8001C214.s.o(.rodata); build/asm/main_8001C214.s.o(.data); }
    .main_8001C214_bss (NOLOAD) : { build/asm/main_8001C214.s.o(.bss); }
    .main_8001C234 0x8001C234 : AT(0x0001CE34) { build/asm/data/main_8001C234.bin.o(.data); }
    .main_80023454 0x80023454 : AT(0x00024054) { FILL(0x00000000); build/asm/main_80023454.s.o(.text); build/asm/main_80023454.s.o(.rodata); build/asm/main_80023454.s.o(.data); }
    .main_80023454_bss (NOLOAD) : { build/asm/main_80023454.s.o(.bss); }
    .main_80023474 0x80023474 : AT(0x00024074) { build/asm/data/main_80023474.bin.o(.data); }
    .main_80023EC8 0x80023EC8 : AT(0x00024AC8) { FILL(0x00000000); build/asm/main_80023EC8.s.o(.text); build/asm/main_80023EC8.s.o(.rodata); build/asm/main_80023EC8.s.o(.data); }
    .main_80023EC8_bss (NOLOAD) : { build/asm/main_80023EC8.s.o(.bss); }
    .main_80023EF0 0x80023EF0 : AT(0x00024AF0) { build/asm/data/main_80023EF0.bin.o(.data); }
    .main_8003E064 0x8003E064 : AT(0x0003EC64) { FILL(0x00000000); build/asm/main_8003E064.s.o(.text); build/asm/main_8003E064.s.o(.rodata); build/asm/main_8003E064.s.o(.data); }
    .main_8003E064_bss (NOLOAD) : { build/asm/main_8003E064.s.o(.bss); }
    .main_8003E0BC 0x8003E0BC : AT(0x0003ECBC) { build/asm/data/main_8003E0BC.bin.o(.data); }
    .main_800416A8 0x800416A8 : AT(0x000422A8) { FILL(0x00000000); build/asm/main_800416A8.s.o(.text); build/asm/main_800416A8.s.o(.rodata); build/asm/main_800416A8.s.o(.data); }
    .main_800416A8_bss (NOLOAD) : { build/asm/main_800416A8.s.o(.bss); }
    .main_800416F4 0x800416F4 : AT(0x000422F4) { build/asm/data/main_800416F4.bin.o(.data); }
    .main_80044884 0x80044884 : AT(0x00045484) { FILL(0x00000000); build/asm/main_80044884.s.o(.text); build/asm/main_80044884.s.o(.rodata); build/asm/main_80044884.s.o(.data); }
    .main_80044884_bss (NOLOAD) : { build/asm/main_80044884.s.o(.bss); }
    .main_800448AC 0x800448AC : AT(0x000454AC) { build/asm/data/main_800448AC.bin.o(.data); }
    .main_80044CA0 0x80044CA0 : AT(0x000458A0) { FILL(0x00000000); build/asm/main_80044CA0.s.o(.text); build/asm/main_80044CA0.s.o(.rodata); build/asm/main_80044CA0.s.o(.data); }
    .main_80044CA0_bss (NOLOAD) : { build/asm/main_80044CA0.s.o(.bss); }
    .main_80044CA8 0x80044CA8 : AT(0x000458A8) { build/asm/data/main_80044CA8.bin.o(.data); }
    .main_800455BC 0x800455BC : AT(0x000461BC) { FILL(0x00000000); build/asm/main_800455BC.s.o(.text); build/asm/main_800455BC.s.o(.rodata); build/asm/main_800455BC.s.o(.data); }
    .main_800455BC_bss (NOLOAD) : { build/asm/main_800455BC.s.o(.bss); }
    .main_80045764 0x80045764 : AT(0x00046364) { build/asm/data/main_80045764.bin.o(.data); }
    .main_80066724 0x80066724 : AT(0x00067324) { FILL(0x00000000); build/asm/main_80066724.s.o(.text); build/asm/main_80066724.s.o(.rodata); build/asm/main_80066724.s.o(.data); }
    .main_80066724_bss (NOLOAD) : { build/asm/main_80066724.s.o(.bss); }
    .main_80066748 0x80066748 : AT(0x00067348) { build/asm/data/main_80066748.bin.o(.data); }
    .main_8008040C 0x8008040C : AT(0x0008100C) { FILL(0x00000000); build/asm/main_8008040C.s.o(.text); build/asm/main_8008040C.s.o(.rodata); build/asm/main_8008040C.s.o(.data); }
    .main_8008040C_bss (NOLOAD) : { build/asm/main_8008040C.s.o(.bss); }
    .main_80080428 0x80080428 : AT(0x00081028) { build/asm/data/main_80080428.bin.o(.data); }
    .main_80080498 0x80080498 : AT(0x00081098) { FILL(0x00000000); build/asm/main_80080498.s.o(.text); build/asm/main_80080498.s.o(.rodata); build/asm/main_80080498.s.o(.data); }
    .main_80080498_bss (NOLOAD) : { build/asm/main_80080498.s.o(.bss); }
    .main_800804A8 0x800804A8 : AT(0x000810A8) { build/asm/data/main_800804A8.bin.o(.data); }
    .main_800846F4 0x800846F4 : AT(0x000852F4) { FILL(0x00000000); build/asm/main_800846F4.s.o(.text); build/asm/main_800846F4.s.o(.rodata); build/asm/main_800846F4.s.o(.data); }
    .main_800846F4_bss (NOLOAD) : { build/asm/main_800846F4.s.o(.bss); }
    .main_800846FC 0x800846FC : AT(0x000852FC) { build/asm/data/main_800846FC.bin.o(.data); }
    .main_800A3774 0x800A3774 : AT(0x000A4374) { FILL(0x00000000); build/asm/main_800A3774.s.o(.text); build/asm/main_800A3774.s.o(.rodata); build/asm/main_800A3774.s.o(.data); }
    .main_800A3774_bss (NOLOAD) : { build/asm/main_800A3774.s.o(.bss); }
    .main_800A3780 0x800A3780 : AT(0x000A4380) { build/asm/data/main_800A3780.bin.o(.data); }
    .main_800B818C 0x800B818C : AT(0x000B8D8C) { FILL(0x00000000); build/asm/main_800B818C.s.o(.text); build/asm/main_800B818C.s.o(.rodata); build/asm/main_800B818C.s.o(.data); }
    .main_800B818C_bss (NOLOAD) : { build/asm/main_800B818C.s.o(.bss); }
    .main_800B8218 0x800B8218 : AT(0x000B8E18) { build/asm/data/main_800B8218.bin.o(.data); }
    .main_800C4DC0 0x800C4DC0 : AT(0x000C59C0) { FILL(0x00000000); build/asm/main_800C4DC0.s.o(.text); build/asm/main_800C4DC0.s.o(.rodata); build/asm/main_800C4DC0.s.o(.data); }
    .main_800C4DC0_bss (NOLOAD) : { build/asm/main_800C4DC0.s.o(.bss); }
    .main_800C4FC4 0x800C4FC4 : AT(0x000C5BC4) { build/asm/data/main_800C4FC4.bin.o(.data); }
    .main_800CBC00 0x800CBC00 : AT(0x000CC800) { FILL(0x00000000); build/asm/main_800CBC00.s.o(.text); build/asm/main_800CBC00.s.o(.rodata); build/asm/main_800CBC00.s.o(.data); }
    .main_800CBC00_bss (NOLOAD) : { build/asm/main_800CBC00.s.o(.bss); }
    .main_800CBC1C 0x800CBC1C : AT(0x000CC81C) { build/asm/data/main_800CBC1C.bin.o(.data); }
    .main_800D0730 0x800D0730 : AT(0x000D1330) { FILL(0x00000000); build/asm/main_800D0730.s.o(.text); build/asm/main_800D0730.s.o(.rodata); build/asm/main_800D0730.s.o(.data); }
    .main_800D0730_bss (NOLOAD) : { build/asm/main_800D0730.s.o(.bss); }
    .main_800D0750 0x800D0750 : AT(0x000D1350) { build/asm/data/main_800D0750.bin.o(.data); }
    .main_800D82C0 0x800D82C0 : AT(0x000D8EC0) { FILL(0x00000000); build/asm/main_800D82C0.s.o(.text); build/asm/main_800D82C0.s.o(.rodata); build/asm/main_800D82C0.s.o(.data); }
    .main_800D82C0_bss (NOLOAD) : { build/asm/main_800D82C0.s.o(.bss); }
    .main_800D82C8 0x800D82C8 : AT(0x000D8EC8) { build/asm/data/main_800D82C8.bin.o(.data); }
    .main_800D8F60 0x800D8F60 : AT(0x000D9B60) { FILL(0x00000000); build/asm/main_800D8F60.s.o(.text); build/asm/main_800D8F60.s.o(.rodata); build/asm/main_800D8F60.s.o(.data); }
    .main_800D8F60_bss (NOLOAD) : { build/asm/main_800D8F60.s.o(.bss); }
    .main_800D8F78 0x800D8F78 : AT(0x000D9B78) { build/asm/data/main_800D8F78.bin.o(.data); }
    .main_800D9E7C 0x800D9E7C : AT(0x000DAA7C) { FILL(0x00000000); build/asm/main_800D9E7C.s.o(.text); build/asm/main_800D9E7C.s.o(.rodata); build/asm/main_800D9E7C.s.o(.data); }
    .main_800D9E7C_bss (NOLOAD) : { build/asm/main_800D9E7C.s.o(.bss); }
    .main_800D9E84 0x800D9E84 : AT(0x000DAA84) { build/asm/data/main_800D9E84.bin.o(.data); }
    .main_800DBB70 0x800DBB70 : AT(0x000DC770) { FILL(0x00000000); build/asm/main_800DBB70.s.o(.text); build/asm/main_800DBB70.s.o(.rodata); build/asm/main_800DBB70.s.o(.data); }
    .main_800DBB70_bss (NOLOAD) : { build/asm/main_800DBB70.s.o(.bss); }
    .main_800DBB8C 0x800DBB8C : AT(0x000DC78C) { build/asm/data/main_800DBB8C.bin.o(.data); }
    .main_800DBBF0 0x800DBBF0 : AT(0x000DC7F0) { FILL(0x00000000); build/asm/main_800DBBF0.s.o(.text); build/asm/main_800DBBF0.s.o(.rodata); build/asm/main_800DBBF0.s.o(.data); }
    .main_800DBBF0_bss (NOLOAD) : { build/asm/main_800DBBF0.s.o(.bss); }
    .main_800DBC0C 0x800DBC0C : AT(0x000DC80C) { build/asm/data/main_800DBC0C.bin.o(.data); }
    .main_800DBC8C 0x800DBC8C : AT(0x000DC88C) { FILL(0x00000000); build/asm/main_800DBC8C.s.o(.text); build/asm/main_800DBC8C.s.o(.rodata); build/asm/main_800DBC8C.s.o(.data); }
    .main_800DBC8C_bss (NOLOAD) : { build/asm/main_800DBC8C.s.o(.bss); }
    .main_800DBCCC 0x800DBCCC : AT(0x000DC8CC) { build/asm/data/main_800DBCCC.bin.o(.data); }
    .main_800DBE64 0x800DBE64 : AT(0x000DCA64) { FILL(0x00000000); build/asm/main_800DBE64.s.o(.text); build/asm/main_800DBE64.s.o(.rodata); build/asm/main_800DBE64.s.o(.data); }
    .main_800DBE64_bss (NOLOAD) : { build/asm/main_800DBE64.s.o(.bss); }
    .main_800DBF0C 0x800DBF0C : AT(0x000DCB0C) { build/asm/data/main_800DBF0C.bin.o(.data); }
    .main_800DBF2C 0x800DBF2C : AT(0x000DCB2C) { FILL(0x00000000); build/asm/main_800DBF2C.s.o(.text); build/asm/main_800DBF2C.s.o(.rodata); build/asm/main_800DBF2C.s.o(.data); }
    .main_800DBF2C_bss (NOLOAD) : { build/asm/main_800DBF2C.s.o(.bss); }
    .main_800DBF4C 0x800DBF4C : AT(0x000DCB4C) { build/asm/data/main_800DBF4C.bin.o(.data); }
    .main_800DCCF4 0x800DCCF4 : AT(0x000DD8F4) { FILL(0x00000000); build/asm/main_800DCCF4.s.o(.text); build/asm/main_800DCCF4.s.o(.rodata); build/asm/main_800DCCF4.s.o(.data); }
    .main_800DCCF4_bss (NOLOAD) : { build/asm/main_800DCCF4.s.o(.bss); }
    .main_800DCD18 0x800DCD18 : AT(0x000DD918) { build/asm/data/main_800DCD18.bin.o(.data); }
    .main_800DE418 0x800DE418 : AT(0x000DF018) { FILL(0x00000000); build/asm/main_800DE418.s.o(.text); build/asm/main_800DE418.s.o(.rodata); build/asm/main_800DE418.s.o(.data); }
    .main_800DE418_bss (NOLOAD) : { build/asm/main_800DE418.s.o(.bss); }
    .main_800DE478 0x800DE478 : AT(0x000DF078) { build/asm/data/main_800DE478.bin.o(.data); }
    .main_800EBC74 0x800EBC74 : AT(0x000EC874) { FILL(0x00000000); build/asm/main_800EBC74.s.o(.text); build/asm/main_800EBC74.s.o(.rodata); build/asm/main_800EBC74.s.o(.data); }
    .main_800EBC74_bss (NOLOAD) : { build/asm/main_800EBC74.s.o(.bss); }
    .main_800EBCB0 0x800EBCB0 : AT(0x000EC8B0) { build/asm/data/main_800EBCB0.bin.o(.data); }
    .main_800F6AB4 0x800F6AB4 : AT(0x000F76B4) { FILL(0x00000000); build/asm/main_800F6AB4.s.o(.text); build/asm/main_800F6AB4.s.o(.rodata); build/asm/main_800F6AB4.s.o(.data); }
    .main_800F6AB4_bss (NOLOAD) : { build/asm/main_800F6AB4.s.o(.bss); }
    .main_800F6AC8 0x800F6AC8 : AT(0x000F76C8) { build/asm/data/main_800F6AC8.bin.o(.data); }
    .main_800F96EC 0x800F96EC : AT(0x000FA2EC) { FILL(0x00000000); build/asm/main_800F96EC.s.o(.text); build/asm/main_800F96EC.s.o(.rodata); build/asm/main_800F96EC.s.o(.data); }
    .main_800F96EC_bss (NOLOAD) : { build/asm/main_800F96EC.s.o(.bss); }
    .main_800F96F8 0x800F96F8 : AT(0x000FA2F8) { build/asm/data/main_800F96F8.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
