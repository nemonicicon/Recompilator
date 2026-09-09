SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80100000 0x80100000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80100000.s.o(.text); build/asm/main_80100000.s.o(.rodata); build/asm/main_80100000.s.o(.data); }
    .main_80100000_bss (NOLOAD) : { build/asm/main_80100000.s.o(.bss); }
    .main_801000A8 0x801000A8 : AT(0x000010A8) { FILL(0x00000000); build/asm/main_801000A8.s.o(.text); build/asm/main_801000A8.s.o(.rodata); build/asm/main_801000A8.s.o(.data); }
    .main_801000A8_bss (NOLOAD) : { build/asm/main_801000A8.s.o(.bss); }
    .main_80124F68 0x80124F68 : AT(0x00025F68) { FILL(0x00000000); build/asm/main_80124F68.s.o(.text); build/asm/main_80124F68.s.o(.rodata); build/asm/main_80124F68.s.o(.data); }
    .main_80124F68_bss (NOLOAD) : { build/asm/main_80124F68.s.o(.bss); }
    .main_80125280 0x80125280 : AT(0x00026280) { FILL(0x00000000); build/asm/main_80125280.s.o(.text); build/asm/main_80125280.s.o(.rodata); build/asm/main_80125280.s.o(.data); }
    .main_80125280_bss (NOLOAD) : { build/asm/main_80125280.s.o(.bss); }
    .main_80133EA4 0x80133EA4 : AT(0x00034EA4) { FILL(0x00000000); build/asm/main_80133EA4.s.o(.text); build/asm/main_80133EA4.s.o(.rodata); build/asm/main_80133EA4.s.o(.data); }
    .main_80133EA4_bss (NOLOAD) : { build/asm/main_80133EA4.s.o(.bss); }
    .main_80134134 0x80134134 : AT(0x00035134) { FILL(0x00000000); build/asm/main_80134134.s.o(.text); build/asm/main_80134134.s.o(.rodata); build/asm/main_80134134.s.o(.data); }
    .main_80134134_bss (NOLOAD) : { build/asm/main_80134134.s.o(.bss); }
    .main_801342A4 0x801342A4 : AT(0x000352A4) { build/asm/data/main_801342A4.bin.o(.data); }
    .main_80134300 0x80134300 : AT(0x00035300) { FILL(0x00000000); build/asm/main_80134300.s.o(.text); build/asm/main_80134300.s.o(.rodata); build/asm/main_80134300.s.o(.data); }
    .main_80134300_bss (NOLOAD) : { build/asm/main_80134300.s.o(.bss); }
    .main_80134360 0x80134360 : AT(0x00035360) { build/asm/data/main_80134360.bin.o(.data); }
    .main_8013443C 0x8013443C : AT(0x0003543C) { FILL(0x00000000); build/asm/main_8013443C.s.o(.text); build/asm/main_8013443C.s.o(.rodata); build/asm/main_8013443C.s.o(.data); }
    .main_8013443C_bss (NOLOAD) : { build/asm/main_8013443C.s.o(.bss); }
    .main_80134474 0x80134474 : AT(0x00035474) { build/asm/data/main_80134474.bin.o(.data); }
    .main_801344D0 0x801344D0 : AT(0x000354D0) { build/asm/data/main_801344D0.bin.o(.data); }
    .main_80134588 0x80134588 : AT(0x00035588) { FILL(0x00000000); build/asm/main_80134588.s.o(.text); build/asm/main_80134588.s.o(.rodata); build/asm/main_80134588.s.o(.data); }
    .main_80134588_bss (NOLOAD) : { build/asm/main_80134588.s.o(.bss); }
    .main_8013469C 0x8013469C : AT(0x0003569C) { build/asm/data/main_8013469C.bin.o(.data); }
    .main_80134B68 0x80134B68 : AT(0x00035B68) { FILL(0x00000000); build/asm/main_80134B68.s.o(.text); build/asm/main_80134B68.s.o(.rodata); build/asm/main_80134B68.s.o(.data); }
    .main_80134B68_bss (NOLOAD) : { build/asm/main_80134B68.s.o(.bss); }
    .main_80134E58 0x80134E58 : AT(0x00035E58) { FILL(0x00000000); build/asm/main_80134E58.s.o(.text); build/asm/main_80134E58.s.o(.rodata); build/asm/main_80134E58.s.o(.data); }
    .main_80134E58_bss (NOLOAD) : { build/asm/main_80134E58.s.o(.bss); }
    .main_8013C5E0 0x8013C5E0 : AT(0x0003D5E0) { build/asm/data/main_8013C5E0.bin.o(.data); }
    .main_8013D030 0x8013D030 : AT(0x0003E030) { FILL(0x00000000); build/asm/main_8013D030.s.o(.text); build/asm/main_8013D030.s.o(.rodata); build/asm/main_8013D030.s.o(.data); }
    .main_8013D030_bss (NOLOAD) : { build/asm/main_8013D030.s.o(.bss); }
    .main_80140004 0x80140004 : AT(0x00041004) { FILL(0x00000000); build/asm/main_80140004.s.o(.text); build/asm/main_80140004.s.o(.rodata); build/asm/main_80140004.s.o(.data); }
    .main_80140004_bss (NOLOAD) : { build/asm/main_80140004.s.o(.bss); }
    .main_801551D8 0x801551D8 : AT(0x000561D8) { FILL(0x00000000); build/asm/main_801551D8.s.o(.text); build/asm/main_801551D8.s.o(.rodata); build/asm/main_801551D8.s.o(.data); }
    .main_801551D8_bss (NOLOAD) : { build/asm/main_801551D8.s.o(.bss); }
    .ovl01_80900000 0x80900000 : AT(0x0005EA10) { FILL(0x00000000); build/asm/ovl01_80900000.s.o(.text); build/asm/ovl01_80900000.s.o(.rodata); build/asm/ovl01_80900000.s.o(.data); }
    .ovl01_80900000_bss (NOLOAD) : { build/asm/ovl01_80900000.s.o(.bss); }
    .ovl02_80000480 0x80000480 : AT(0x0007F110) { FILL(0x00000000); build/asm/ovl02_80000480.s.o(.text); build/asm/ovl02_80000480.s.o(.rodata); build/asm/ovl02_80000480.s.o(.data); }
    .ovl02_80000480_bss (NOLOAD) : { build/asm/ovl02_80000480.s.o(.bss); }
    .main_8017F480 0x8017F480 : AT(0x00080480) { build/asm/data/main_8017F480.bin.o(.data); }
    .main_8017F8D4 0x8017F8D4 : AT(0x000808D4) { FILL(0x00000000); build/asm/main_8017F8D4.s.o(.text); build/asm/main_8017F8D4.s.o(.rodata); build/asm/main_8017F8D4.s.o(.data); }
    .main_8017F8D4_bss (NOLOAD) : { build/asm/main_8017F8D4.s.o(.bss); }
    .main_8017FB1C 0x8017FB1C : AT(0x00080B1C) { build/asm/data/main_8017FB1C.bin.o(.data); }
    .main_80180000 0x80180000 : AT(0x00081000) { FILL(0x00000000); build/asm/main_80180000.s.o(.text); build/asm/main_80180000.s.o(.rodata); build/asm/main_80180000.s.o(.data); }
    .main_80180000_bss (NOLOAD) : { build/asm/main_80180000.s.o(.bss); }
    .main_80180004 0x80180004 : AT(0x00081004) { build/asm/data/main_80180004.bin.o(.data); }
    .main_80181818 0x80181818 : AT(0x00082818) { FILL(0x00000000); build/asm/main_80181818.s.o(.text); build/asm/main_80181818.s.o(.rodata); build/asm/main_80181818.s.o(.data); }
    .main_80181818_bss (NOLOAD) : { build/asm/main_80181818.s.o(.bss); }
    .main_80181C10 0x80181C10 : AT(0x00082C10) { build/asm/data/main_80181C10.bin.o(.data); }
    .main_80182B8C 0x80182B8C : AT(0x00083B8C) { FILL(0x00000000); build/asm/main_80182B8C.s.o(.text); build/asm/main_80182B8C.s.o(.rodata); build/asm/main_80182B8C.s.o(.data); }
    .main_80182B8C_bss (NOLOAD) : { build/asm/main_80182B8C.s.o(.bss); }
    .main_80183004 0x80183004 : AT(0x00084004) { build/asm/data/main_80183004.bin.o(.data); }
    .main_80187324 0x80187324 : AT(0x00088324) { FILL(0x00000000); build/asm/main_80187324.s.o(.text); build/asm/main_80187324.s.o(.rodata); build/asm/main_80187324.s.o(.data); }
    .main_80187324_bss (NOLOAD) : { build/asm/main_80187324.s.o(.bss); }
    .main_80188044 0x80188044 : AT(0x00089044) { build/asm/data/main_80188044.bin.o(.data); }
    .main_80188BBC 0x80188BBC : AT(0x00089BBC) { FILL(0x00000000); build/asm/main_80188BBC.s.o(.text); build/asm/main_80188BBC.s.o(.rodata); build/asm/main_80188BBC.s.o(.data); }
    .main_80188BBC_bss (NOLOAD) : { build/asm/main_80188BBC.s.o(.bss); }
    .main_8018943C 0x8018943C : AT(0x0008A43C) { build/asm/data/main_8018943C.bin.o(.data); }
    .main_80189D2C 0x80189D2C : AT(0x0008AD2C) { FILL(0x00000000); build/asm/main_80189D2C.s.o(.text); build/asm/main_80189D2C.s.o(.rodata); build/asm/main_80189D2C.s.o(.data); }
    .main_80189D2C_bss (NOLOAD) : { build/asm/main_80189D2C.s.o(.bss); }
    .main_80189EEC 0x80189EEC : AT(0x0008AEEC) { build/asm/data/main_80189EEC.bin.o(.data); }
    .main_8018B794 0x8018B794 : AT(0x0008C794) { FILL(0x00000000); build/asm/main_8018B794.s.o(.text); build/asm/main_8018B794.s.o(.rodata); build/asm/main_8018B794.s.o(.data); }
    .main_8018B794_bss (NOLOAD) : { build/asm/main_8018B794.s.o(.bss); }
    .main_8018BB24 0x8018BB24 : AT(0x0008CB24) { build/asm/data/main_8018BB24.bin.o(.data); }
    .main_8018D23C 0x8018D23C : AT(0x0008E23C) { FILL(0x00000000); build/asm/main_8018D23C.s.o(.text); build/asm/main_8018D23C.s.o(.rodata); build/asm/main_8018D23C.s.o(.data); }
    .main_8018D23C_bss (NOLOAD) : { build/asm/main_8018D23C.s.o(.bss); }
    .main_8018D3CC 0x8018D3CC : AT(0x0008E3CC) { build/asm/data/main_8018D3CC.bin.o(.data); }
    .main_8018DAB4 0x8018DAB4 : AT(0x0008EAB4) { FILL(0x00000000); build/asm/main_8018DAB4.s.o(.text); build/asm/main_8018DAB4.s.o(.rodata); build/asm/main_8018DAB4.s.o(.data); }
    .main_8018DAB4_bss (NOLOAD) : { build/asm/main_8018DAB4.s.o(.bss); }
    .main_8018DB34 0x8018DB34 : AT(0x0008EB34) { build/asm/data/main_8018DB34.bin.o(.data); }
    .main_8018E964 0x8018E964 : AT(0x0008F964) { FILL(0x00000000); build/asm/main_8018E964.s.o(.text); build/asm/main_8018E964.s.o(.rodata); build/asm/main_8018E964.s.o(.data); }
    .main_8018E964_bss (NOLOAD) : { build/asm/main_8018E964.s.o(.bss); }
    .main_8018EE2C 0x8018EE2C : AT(0x0008FE2C) { build/asm/data/main_8018EE2C.bin.o(.data); }
    .main_801910B4 0x801910B4 : AT(0x000920B4) { FILL(0x00000000); build/asm/main_801910B4.s.o(.text); build/asm/main_801910B4.s.o(.rodata); build/asm/main_801910B4.s.o(.data); }
    .main_801910B4_bss (NOLOAD) : { build/asm/main_801910B4.s.o(.bss); }
    .main_8019194C 0x8019194C : AT(0x0009294C) { build/asm/data/main_8019194C.bin.o(.data); }
    .main_80191BE4 0x80191BE4 : AT(0x00092BE4) { FILL(0x00000000); build/asm/main_80191BE4.s.o(.text); build/asm/main_80191BE4.s.o(.rodata); build/asm/main_80191BE4.s.o(.data); }
    .main_80191BE4_bss (NOLOAD) : { build/asm/main_80191BE4.s.o(.bss); }
    .main_80192574 0x80192574 : AT(0x00093574) { build/asm/data/main_80192574.bin.o(.data); }
    .main_801931FC 0x801931FC : AT(0x000941FC) { FILL(0x00000000); build/asm/main_801931FC.s.o(.text); build/asm/main_801931FC.s.o(.rodata); build/asm/main_801931FC.s.o(.data); }
    .main_801931FC_bss (NOLOAD) : { build/asm/main_801931FC.s.o(.bss); }
    .main_8019321C 0x8019321C : AT(0x0009421C) { build/asm/data/main_8019321C.bin.o(.data); }
    .main_801942F4 0x801942F4 : AT(0x000952F4) { FILL(0x00000000); build/asm/main_801942F4.s.o(.text); build/asm/main_801942F4.s.o(.rodata); build/asm/main_801942F4.s.o(.data); }
    .main_801942F4_bss (NOLOAD) : { build/asm/main_801942F4.s.o(.bss); }
    .main_801943C4 0x801943C4 : AT(0x000953C4) { build/asm/data/main_801943C4.bin.o(.data); }
    .main_80194CB4 0x80194CB4 : AT(0x00095CB4) { FILL(0x00000000); build/asm/main_80194CB4.s.o(.text); build/asm/main_80194CB4.s.o(.rodata); build/asm/main_80194CB4.s.o(.data); }
    .main_80194CB4_bss (NOLOAD) : { build/asm/main_80194CB4.s.o(.bss); }
    .main_80194FA4 0x80194FA4 : AT(0x00095FA4) { build/asm/data/main_80194FA4.bin.o(.data); }
    .main_80195DB4 0x80195DB4 : AT(0x00096DB4) { FILL(0x00000000); build/asm/main_80195DB4.s.o(.text); build/asm/main_80195DB4.s.o(.rodata); build/asm/main_80195DB4.s.o(.data); }
    .main_80195DB4_bss (NOLOAD) : { build/asm/main_80195DB4.s.o(.bss); }
    .main_80195DF4 0x80195DF4 : AT(0x00096DF4) { build/asm/data/main_80195DF4.bin.o(.data); }
    .main_80197264 0x80197264 : AT(0x00098264) { FILL(0x00000000); build/asm/main_80197264.s.o(.text); build/asm/main_80197264.s.o(.rodata); build/asm/main_80197264.s.o(.data); }
    .main_80197264_bss (NOLOAD) : { build/asm/main_80197264.s.o(.bss); }
    .main_80197654 0x80197654 : AT(0x00098654) { build/asm/data/main_80197654.bin.o(.data); }
    .main_8019D20C 0x8019D20C : AT(0x0009E20C) { FILL(0x00000000); build/asm/main_8019D20C.s.o(.text); build/asm/main_8019D20C.s.o(.rodata); build/asm/main_8019D20C.s.o(.data); }
    .main_8019D20C_bss (NOLOAD) : { build/asm/main_8019D20C.s.o(.bss); }
    .main_8019D224 0x8019D224 : AT(0x0009E224) { build/asm/data/main_8019D224.bin.o(.data); }
    .main_8019DA44 0x8019DA44 : AT(0x0009EA44) { FILL(0x00000000); build/asm/main_8019DA44.s.o(.text); build/asm/main_8019DA44.s.o(.rodata); build/asm/main_8019DA44.s.o(.data); }
    .main_8019DA44_bss (NOLOAD) : { build/asm/main_8019DA44.s.o(.bss); }
    .main_8019DC0C 0x8019DC0C : AT(0x0009EC0C) { build/asm/data/main_8019DC0C.bin.o(.data); }
    .main_8019ED74 0x8019ED74 : AT(0x0009FD74) { FILL(0x00000000); build/asm/main_8019ED74.s.o(.text); build/asm/main_8019ED74.s.o(.rodata); build/asm/main_8019ED74.s.o(.data); }
    .main_8019ED74_bss (NOLOAD) : { build/asm/main_8019ED74.s.o(.bss); }
    .main_8019F00C 0x8019F00C : AT(0x000A000C) { build/asm/data/main_8019F00C.bin.o(.data); }
    .main_8019F09C 0x8019F09C : AT(0x000A009C) { FILL(0x00000000); build/asm/main_8019F09C.s.o(.text); build/asm/main_8019F09C.s.o(.rodata); build/asm/main_8019F09C.s.o(.data); }
    .main_8019F09C_bss (NOLOAD) : { build/asm/main_8019F09C.s.o(.bss); }
    .main_8019F0AC 0x8019F0AC : AT(0x000A00AC) { build/asm/data/main_8019F0AC.bin.o(.data); }
    .main_8019F794 0x8019F794 : AT(0x000A0794) { FILL(0x00000000); build/asm/main_8019F794.s.o(.text); build/asm/main_8019F794.s.o(.rodata); build/asm/main_8019F794.s.o(.data); }
    .main_8019F794_bss (NOLOAD) : { build/asm/main_8019F794.s.o(.bss); }
    .main_8019F7C4 0x8019F7C4 : AT(0x000A07C4) { build/asm/data/main_8019F7C4.bin.o(.data); }
    .main_8019FD34 0x8019FD34 : AT(0x000A0D34) { FILL(0x00000000); build/asm/main_8019FD34.s.o(.text); build/asm/main_8019FD34.s.o(.rodata); build/asm/main_8019FD34.s.o(.data); }
    .main_8019FD34_bss (NOLOAD) : { build/asm/main_8019FD34.s.o(.bss); }
    .main_8019FF2C 0x8019FF2C : AT(0x000A0F2C) { build/asm/data/main_8019FF2C.bin.o(.data); }
    .main_801A06AC 0x801A06AC : AT(0x000A16AC) { FILL(0x00000000); build/asm/main_801A06AC.s.o(.text); build/asm/main_801A06AC.s.o(.rodata); build/asm/main_801A06AC.s.o(.data); }
    .main_801A06AC_bss (NOLOAD) : { build/asm/main_801A06AC.s.o(.bss); }
    .main_801A0A3C 0x801A0A3C : AT(0x000A1A3C) { build/asm/data/main_801A0A3C.bin.o(.data); }
    .main_801A1684 0x801A1684 : AT(0x000A2684) { FILL(0x00000000); build/asm/main_801A1684.s.o(.text); build/asm/main_801A1684.s.o(.rodata); build/asm/main_801A1684.s.o(.data); }
    .main_801A1684_bss (NOLOAD) : { build/asm/main_801A1684.s.o(.bss); }
    .main_801A1BB4 0x801A1BB4 : AT(0x000A2BB4) { build/asm/data/main_801A1BB4.bin.o(.data); }
    .main_801A34B4 0x801A34B4 : AT(0x000A44B4) { FILL(0x00000000); build/asm/main_801A34B4.s.o(.text); build/asm/main_801A34B4.s.o(.rodata); build/asm/main_801A34B4.s.o(.data); }
    .main_801A34B4_bss (NOLOAD) : { build/asm/main_801A34B4.s.o(.bss); }
    .main_801A3564 0x801A3564 : AT(0x000A4564) { build/asm/data/main_801A3564.bin.o(.data); }
    .main_801A39B4 0x801A39B4 : AT(0x000A49B4) { FILL(0x00000000); build/asm/main_801A39B4.s.o(.text); build/asm/main_801A39B4.s.o(.rodata); build/asm/main_801A39B4.s.o(.data); }
    .main_801A39B4_bss (NOLOAD) : { build/asm/main_801A39B4.s.o(.bss); }
    .main_801A39C4 0x801A39C4 : AT(0x000A49C4) { build/asm/data/main_801A39C4.bin.o(.data); }
    .main_801AAF7C 0x801AAF7C : AT(0x000ABF7C) { FILL(0x00000000); build/asm/main_801AAF7C.s.o(.text); build/asm/main_801AAF7C.s.o(.rodata); build/asm/main_801AAF7C.s.o(.data); }
    .main_801AAF7C_bss (NOLOAD) : { build/asm/main_801AAF7C.s.o(.bss); }
    .main_801AB134 0x801AB134 : AT(0x000AC134) { build/asm/data/main_801AB134.bin.o(.data); }
    .main_801B2EA4 0x801B2EA4 : AT(0x000B3EA4) { FILL(0x00000000); build/asm/main_801B2EA4.s.o(.text); build/asm/main_801B2EA4.s.o(.rodata); build/asm/main_801B2EA4.s.o(.data); }
    .main_801B2EA4_bss (NOLOAD) : { build/asm/main_801B2EA4.s.o(.bss); }
    .main_801B2FEC 0x801B2FEC : AT(0x000B3FEC) { build/asm/data/main_801B2FEC.bin.o(.data); }
    .main_801BD44C 0x801BD44C : AT(0x000BE44C) { FILL(0x00000000); build/asm/main_801BD44C.s.o(.text); build/asm/main_801BD44C.s.o(.rodata); build/asm/main_801BD44C.s.o(.data); }
    .main_801BD44C_bss (NOLOAD) : { build/asm/main_801BD44C.s.o(.bss); }
    .main_801BD480 0x801BD480 : AT(0x000BE480) { build/asm/data/main_801BD480.bin.o(.data); }
    .main_801CCFE0 0x801CCFE0 : AT(0x000CDFE0) { FILL(0x00000000); build/asm/main_801CCFE0.s.o(.text); build/asm/main_801CCFE0.s.o(.rodata); build/asm/main_801CCFE0.s.o(.data); }
    .main_801CCFE0_bss (NOLOAD) : { build/asm/main_801CCFE0.s.o(.bss); }
    .main_801CCFE8 0x801CCFE8 : AT(0x000CDFE8) { build/asm/data/main_801CCFE8.bin.o(.data); }
    .main_801CDEDC 0x801CDEDC : AT(0x000CEEDC) { FILL(0x00000000); build/asm/main_801CDEDC.s.o(.text); build/asm/main_801CDEDC.s.o(.rodata); build/asm/main_801CDEDC.s.o(.data); }
    .main_801CDEDC_bss (NOLOAD) : { build/asm/main_801CDEDC.s.o(.bss); }
    .main_801CDFA8 0x801CDFA8 : AT(0x000CEFA8) { build/asm/data/main_801CDFA8.bin.o(.data); }
    .main_801CF168 0x801CF168 : AT(0x000D0168) { FILL(0x00000000); build/asm/main_801CF168.s.o(.text); build/asm/main_801CF168.s.o(.rodata); build/asm/main_801CF168.s.o(.data); }
    .main_801CF168_bss (NOLOAD) : { build/asm/main_801CF168.s.o(.bss); }
    .main_801CF170 0x801CF170 : AT(0x000D0170) { build/asm/data/main_801CF170.bin.o(.data); }
    .main_801EBE34 0x801EBE34 : AT(0x000ECE34) { FILL(0x00000000); build/asm/main_801EBE34.s.o(.text); build/asm/main_801EBE34.s.o(.rodata); build/asm/main_801EBE34.s.o(.data); }
    .main_801EBE34_bss (NOLOAD) : { build/asm/main_801EBE34.s.o(.bss); }
    .main_801EC528 0x801EC528 : AT(0x000ED528) { build/asm/data/main_801EC528.bin.o(.data); }
    .main_801EEC10 0x801EEC10 : AT(0x000EFC10) { FILL(0x00000000); build/asm/main_801EEC10.s.o(.text); build/asm/main_801EEC10.s.o(.rodata); build/asm/main_801EEC10.s.o(.data); }
    .main_801EEC10_bss (NOLOAD) : { build/asm/main_801EEC10.s.o(.bss); }
    .main_801EED40 0x801EED40 : AT(0x000EFD40) { build/asm/data/main_801EED40.bin.o(.data); }
    .main_801F0218 0x801F0218 : AT(0x000F1218) { FILL(0x00000000); build/asm/main_801F0218.s.o(.text); build/asm/main_801F0218.s.o(.rodata); build/asm/main_801F0218.s.o(.data); }
    .main_801F0218_bss (NOLOAD) : { build/asm/main_801F0218.s.o(.bss); }
    .main_801F024C 0x801F024C : AT(0x000F124C) { build/asm/data/main_801F024C.bin.o(.data); }
    .main_801F0980 0x801F0980 : AT(0x000F1980) { FILL(0x00000000); build/asm/main_801F0980.s.o(.text); build/asm/main_801F0980.s.o(.rodata); build/asm/main_801F0980.s.o(.data); }
    .main_801F0980_bss (NOLOAD) : { build/asm/main_801F0980.s.o(.bss); }
    .main_801F09BC 0x801F09BC : AT(0x000F19BC) { build/asm/data/main_801F09BC.bin.o(.data); }
    .main_801F14A8 0x801F14A8 : AT(0x000F24A8) { FILL(0x00000000); build/asm/main_801F14A8.s.o(.text); build/asm/main_801F14A8.s.o(.rodata); build/asm/main_801F14A8.s.o(.data); }
    .main_801F14A8_bss (NOLOAD) : { build/asm/main_801F14A8.s.o(.bss); }
    .main_801F14F4 0x801F14F4 : AT(0x000F24F4) { build/asm/data/main_801F14F4.bin.o(.data); }
    .main_801F15A4 0x801F15A4 : AT(0x000F25A4) { FILL(0x00000000); build/asm/main_801F15A4.s.o(.text); build/asm/main_801F15A4.s.o(.rodata); build/asm/main_801F15A4.s.o(.data); }
    .main_801F15A4_bss (NOLOAD) : { build/asm/main_801F15A4.s.o(.bss); }
    .main_801F15B0 0x801F15B0 : AT(0x000F25B0) { build/asm/data/main_801F15B0.bin.o(.data); }
    .main_801F670C 0x801F670C : AT(0x000F770C) { FILL(0x00000000); build/asm/main_801F670C.s.o(.text); build/asm/main_801F670C.s.o(.rodata); build/asm/main_801F670C.s.o(.data); }
    .main_801F670C_bss (NOLOAD) : { build/asm/main_801F670C.s.o(.bss); }
    .main_801F6884 0x801F6884 : AT(0x000F7884) { build/asm/data/main_801F6884.bin.o(.data); }
    .main_801F7448 0x801F7448 : AT(0x000F8448) { FILL(0x00000000); build/asm/main_801F7448.s.o(.text); build/asm/main_801F7448.s.o(.rodata); build/asm/main_801F7448.s.o(.data); }
    .main_801F7448_bss (NOLOAD) : { build/asm/main_801F7448.s.o(.bss); }
    .main_801F74C0 0x801F74C0 : AT(0x000F84C0) { build/asm/data/main_801F74C0.bin.o(.data); }
    .main_801F7F1C 0x801F7F1C : AT(0x000F8F1C) { FILL(0x00000000); build/asm/main_801F7F1C.s.o(.text); build/asm/main_801F7F1C.s.o(.rodata); build/asm/main_801F7F1C.s.o(.data); }
    .main_801F7F1C_bss (NOLOAD) : { build/asm/main_801F7F1C.s.o(.bss); }
    .main_801F805C 0x801F805C : AT(0x000F905C) { build/asm/data/main_801F805C.bin.o(.data); }
    .main_801F8398 0x801F8398 : AT(0x000F9398) { FILL(0x00000000); build/asm/main_801F8398.s.o(.text); build/asm/main_801F8398.s.o(.rodata); build/asm/main_801F8398.s.o(.data); }
    .main_801F8398_bss (NOLOAD) : { build/asm/main_801F8398.s.o(.bss); }
    .main_801F87C4 0x801F87C4 : AT(0x000F97C4) { build/asm/data/main_801F87C4.bin.o(.data); }
    .main_801FC9DC 0x801FC9DC : AT(0x000FD9DC) { FILL(0x00000000); build/asm/main_801FC9DC.s.o(.text); build/asm/main_801FC9DC.s.o(.rodata); build/asm/main_801FC9DC.s.o(.data); }
    .main_801FC9DC_bss (NOLOAD) : { build/asm/main_801FC9DC.s.o(.bss); }
    .main_801FCA68 0x801FCA68 : AT(0x000FDA68) { build/asm/data/main_801FCA68.bin.o(.data); }
    .main_801FD088 0x801FD088 : AT(0x000FE088) { FILL(0x00000000); build/asm/main_801FD088.s.o(.text); build/asm/main_801FD088.s.o(.rodata); build/asm/main_801FD088.s.o(.data); }
    .main_801FD088_bss (NOLOAD) : { build/asm/main_801FD088.s.o(.bss); }
    .main_801FD0DC 0x801FD0DC : AT(0x000FE0DC) { build/asm/data/main_801FD0DC.bin.o(.data); }
    .main_801FD364 0x801FD364 : AT(0x000FE364) { FILL(0x00000000); build/asm/main_801FD364.s.o(.text); build/asm/main_801FD364.s.o(.rodata); build/asm/main_801FD364.s.o(.data); }
    .main_801FD364_bss (NOLOAD) : { build/asm/main_801FD364.s.o(.bss); }
    .main_801FD368 0x801FD368 : AT(0x000FE368) { build/asm/data/main_801FD368.bin.o(.data); }
    .main_801FDD14 0x801FDD14 : AT(0x000FED14) { FILL(0x00000000); build/asm/main_801FDD14.s.o(.text); build/asm/main_801FDD14.s.o(.rodata); build/asm/main_801FDD14.s.o(.data); }
    .main_801FDD14_bss (NOLOAD) : { build/asm/main_801FDD14.s.o(.bss); }
    .main_801FE500 0x801FE500 : AT(0x000FF500) { build/asm/data/main_801FE500.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
