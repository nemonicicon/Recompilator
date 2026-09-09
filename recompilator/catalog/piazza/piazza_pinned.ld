SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_8009EBA0 0x8009EBA0 : AT(0x0009F7A0) { FILL(0x00000000); build/asm/main_8009EBA0.s.o(.text); build/asm/main_8009EBA0.s.o(.rodata); build/asm/main_8009EBA0.s.o(.data); }
    .main_8009EBA0_bss (NOLOAD) : { build/asm/main_8009EBA0.s.o(.bss); }
    .main_8009F370 0x8009F370 : AT(0x0009FF70) { FILL(0x00000000); build/asm/main_8009F370.s.o(.text); build/asm/main_8009F370.s.o(.rodata); build/asm/main_8009F370.s.o(.data); }
    .main_8009F370_bss (NOLOAD) : { build/asm/main_8009F370.s.o(.bss); }
    .main_800A97C4 0x800A97C4 : AT(0x000AA3C4) { FILL(0x00000000); build/asm/main_800A97C4.s.o(.text); build/asm/main_800A97C4.s.o(.rodata); build/asm/main_800A97C4.s.o(.data); }
    .main_800A97C4_bss (NOLOAD) : { build/asm/main_800A97C4.s.o(.bss); }
    .main_800A9B20 0x800A9B20 : AT(0x000AA720) { FILL(0x00000000); build/asm/main_800A9B20.s.o(.text); build/asm/main_800A9B20.s.o(.rodata); build/asm/main_800A9B20.s.o(.data); }
    .main_800A9B20_bss (NOLOAD) : { build/asm/main_800A9B20.s.o(.bss); }
    .main_800AE0D4 0x800AE0D4 : AT(0x000AECD4) { build/asm/data/main_800AE0D4.bin.o(.data); }
    .main_800AE918 0x800AE918 : AT(0x000AF518) { FILL(0x00000000); build/asm/main_800AE918.s.o(.text); build/asm/main_800AE918.s.o(.rodata); build/asm/main_800AE918.s.o(.data); }
    .main_800AE918_bss (NOLOAD) : { build/asm/main_800AE918.s.o(.bss); }
    .main_800B0180 0x800B0180 : AT(0x000B0D80) { build/asm/data/main_800B0180.bin.o(.data); }
    .main_800B82F0 0x800B82F0 : AT(0x000B8EF0) { FILL(0x00000000); build/asm/main_800B82F0.s.o(.text); build/asm/main_800B82F0.s.o(.rodata); build/asm/main_800B82F0.s.o(.data); }
    .main_800B82F0_bss (NOLOAD) : { build/asm/main_800B82F0.s.o(.bss); }
    .main_800B83C4 0x800B83C4 : AT(0x000B8FC4) { build/asm/data/main_800B83C4.bin.o(.data); }
    .main_800BD9AC 0x800BD9AC : AT(0x000BE5AC) { build/asm/data/main_800BD9AC.bin.o(.data); }
    .main_800BF474 0x800BF474 : AT(0x000C0074) { build/asm/data/main_800BF474.bin.o(.data); }
    .main_800C0D20 0x800C0D20 : AT(0x000C1920) { build/asm/data/main_800C0D20.bin.o(.data); }
    .main_800C1888 0x800C1888 : AT(0x000C2488) { build/asm/data/main_800C1888.bin.o(.data); }
    .main_800C2BEC 0x800C2BEC : AT(0x000C37EC) { build/asm/data/main_800C2BEC.bin.o(.data); }
    .main_800C3E00 0x800C3E00 : AT(0x000C4A00) { FILL(0x00000000); build/asm/main_800C3E00.s.o(.text); build/asm/main_800C3E00.s.o(.rodata); build/asm/main_800C3E00.s.o(.data); }
    .main_800C3E00_bss (NOLOAD) : { build/asm/main_800C3E00.s.o(.bss); }
    .main_800C3F0C 0x800C3F0C : AT(0x000C4B0C) { build/asm/data/main_800C3F0C.bin.o(.data); }
    .main_800C4060 0x800C4060 : AT(0x000C4C60) { FILL(0x00000000); build/asm/main_800C4060.s.o(.text); build/asm/main_800C4060.s.o(.rodata); build/asm/main_800C4060.s.o(.data); }
    .main_800C4060_bss (NOLOAD) : { build/asm/main_800C4060.s.o(.bss); }
    .main_800C4290 0x800C4290 : AT(0x000C4E90) { build/asm/data/main_800C4290.bin.o(.data); }
    .main_800C495C 0x800C495C : AT(0x000C555C) { FILL(0x00000000); build/asm/main_800C495C.s.o(.text); build/asm/main_800C495C.s.o(.rodata); build/asm/main_800C495C.s.o(.data); }
    .main_800C495C_bss (NOLOAD) : { build/asm/main_800C495C.s.o(.bss); }
    .main_800C49FC 0x800C49FC : AT(0x000C55FC) { build/asm/data/main_800C49FC.bin.o(.data); }
    .main_800C4A10 0x800C4A10 : AT(0x000C5610) { FILL(0x00000000); build/asm/main_800C4A10.s.o(.text); build/asm/main_800C4A10.s.o(.rodata); build/asm/main_800C4A10.s.o(.data); }
    .main_800C4A10_bss (NOLOAD) : { build/asm/main_800C4A10.s.o(.bss); }
    .main_800C4A48 0x800C4A48 : AT(0x000C5648) { build/asm/data/main_800C4A48.bin.o(.data); }
    .main_800C4DC0 0x800C4DC0 : AT(0x000C59C0) { FILL(0x00000000); build/asm/main_800C4DC0.s.o(.text); build/asm/main_800C4DC0.s.o(.rodata); build/asm/main_800C4DC0.s.o(.data); }
    .main_800C4DC0_bss (NOLOAD) : { build/asm/main_800C4DC0.s.o(.bss); }
    .main_800C4DF0 0x800C4DF0 : AT(0x000C59F0) { build/asm/data/main_800C4DF0.bin.o(.data); }
    .main_800C54D0 0x800C54D0 : AT(0x000C60D0) { FILL(0x00000000); build/asm/main_800C54D0.s.o(.text); build/asm/main_800C54D0.s.o(.rodata); build/asm/main_800C54D0.s.o(.data); }
    .main_800C54D0_bss (NOLOAD) : { build/asm/main_800C54D0.s.o(.bss); }
    .main_800C556C 0x800C556C : AT(0x000C616C) { build/asm/data/main_800C556C.bin.o(.data); }
    .main_800C563C 0x800C563C : AT(0x000C623C) { FILL(0x00000000); build/asm/main_800C563C.s.o(.text); build/asm/main_800C563C.s.o(.rodata); build/asm/main_800C563C.s.o(.data); }
    .main_800C563C_bss (NOLOAD) : { build/asm/main_800C563C.s.o(.bss); }
    .main_800C66D8 0x800C66D8 : AT(0x000C72D8) { FILL(0x00000000); build/asm/main_800C66D8.s.o(.text); build/asm/main_800C66D8.s.o(.rodata); build/asm/main_800C66D8.s.o(.data); }
    .main_800C66D8_bss (NOLOAD) : { build/asm/main_800C66D8.s.o(.bss); }
    .main_800C67F8 0x800C67F8 : AT(0x000C73F8) { FILL(0x00000000); build/asm/main_800C67F8.s.o(.text); build/asm/main_800C67F8.s.o(.rodata); build/asm/main_800C67F8.s.o(.data); }
    .main_800C67F8_bss (NOLOAD) : { build/asm/main_800C67F8.s.o(.bss); }
    .main_800C6C64 0x800C6C64 : AT(0x000C7864) { FILL(0x00000000); build/asm/main_800C6C64.s.o(.text); build/asm/main_800C6C64.s.o(.rodata); build/asm/main_800C6C64.s.o(.data); }
    .main_800C6C64_bss (NOLOAD) : { build/asm/main_800C6C64.s.o(.bss); }
    .main_800C6C9C 0x800C6C9C : AT(0x000C789C) { FILL(0x00000000); build/asm/main_800C6C9C.s.o(.text); build/asm/main_800C6C9C.s.o(.rodata); build/asm/main_800C6C9C.s.o(.data); }
    .main_800C6C9C_bss (NOLOAD) : { build/asm/main_800C6C9C.s.o(.bss); }
    .main_800C6E28 0x800C6E28 : AT(0x000C7A28) { FILL(0x00000000); build/asm/main_800C6E28.s.o(.text); build/asm/main_800C6E28.s.o(.rodata); build/asm/main_800C6E28.s.o(.data); }
    .main_800C6E28_bss (NOLOAD) : { build/asm/main_800C6E28.s.o(.bss); }
    .main_800C6E50 0x800C6E50 : AT(0x000C7A50) { FILL(0x00000000); build/asm/main_800C6E50.s.o(.text); build/asm/main_800C6E50.s.o(.rodata); build/asm/main_800C6E50.s.o(.data); }
    .main_800C6E50_bss (NOLOAD) : { build/asm/main_800C6E50.s.o(.bss); }
    .main_800C7010 0x800C7010 : AT(0x000C7C10) { FILL(0x00000000); build/asm/main_800C7010.s.o(.text); build/asm/main_800C7010.s.o(.rodata); build/asm/main_800C7010.s.o(.data); }
    .main_800C7010_bss (NOLOAD) : { build/asm/main_800C7010.s.o(.bss); }
    .main_800C70B8 0x800C70B8 : AT(0x000C7CB8) { FILL(0x00000000); build/asm/main_800C70B8.s.o(.text); build/asm/main_800C70B8.s.o(.rodata); build/asm/main_800C70B8.s.o(.data); }
    .main_800C70B8_bss (NOLOAD) : { build/asm/main_800C70B8.s.o(.bss); }
    .main_800C75C4 0x800C75C4 : AT(0x000C81C4) { FILL(0x00000000); build/asm/main_800C75C4.s.o(.text); build/asm/main_800C75C4.s.o(.rodata); build/asm/main_800C75C4.s.o(.data); }
    .main_800C75C4_bss (NOLOAD) : { build/asm/main_800C75C4.s.o(.bss); }
    .main_800C79C0 0x800C79C0 : AT(0x000C85C0) { FILL(0x00000000); build/asm/main_800C79C0.s.o(.text); build/asm/main_800C79C0.s.o(.rodata); build/asm/main_800C79C0.s.o(.data); }
    .main_800C79C0_bss (NOLOAD) : { build/asm/main_800C79C0.s.o(.bss); }
    .main_800C7D5C 0x800C7D5C : AT(0x000C895C) { FILL(0x00000000); build/asm/main_800C7D5C.s.o(.text); build/asm/main_800C7D5C.s.o(.rodata); build/asm/main_800C7D5C.s.o(.data); }
    .main_800C7D5C_bss (NOLOAD) : { build/asm/main_800C7D5C.s.o(.bss); }
    .main_800C7FEC 0x800C7FEC : AT(0x000C8BEC) { build/asm/data/main_800C7FEC.bin.o(.data); }
    .main_800C81F4 0x800C81F4 : AT(0x000C8DF4) { FILL(0x00000000); build/asm/main_800C81F4.s.o(.text); build/asm/main_800C81F4.s.o(.rodata); build/asm/main_800C81F4.s.o(.data); }
    .main_800C81F4_bss (NOLOAD) : { build/asm/main_800C81F4.s.o(.bss); }
    .main_800C8410 0x800C8410 : AT(0x000C9010) { FILL(0x00000000); build/asm/main_800C8410.s.o(.text); build/asm/main_800C8410.s.o(.rodata); build/asm/main_800C8410.s.o(.data); }
    .main_800C8410_bss (NOLOAD) : { build/asm/main_800C8410.s.o(.bss); }
    .main_800C8C18 0x800C8C18 : AT(0x000C9818) { FILL(0x00000000); build/asm/main_800C8C18.s.o(.text); build/asm/main_800C8C18.s.o(.rodata); build/asm/main_800C8C18.s.o(.data); }
    .main_800C8C18_bss (NOLOAD) : { build/asm/main_800C8C18.s.o(.bss); }
    .main_800C8C70 0x800C8C70 : AT(0x000C9870) { FILL(0x00000000); build/asm/main_800C8C70.s.o(.text); build/asm/main_800C8C70.s.o(.rodata); build/asm/main_800C8C70.s.o(.data); }
    .main_800C8C70_bss (NOLOAD) : { build/asm/main_800C8C70.s.o(.bss); }
    .main_800C8CBC 0x800C8CBC : AT(0x000C98BC) { FILL(0x00000000); build/asm/main_800C8CBC.s.o(.text); build/asm/main_800C8CBC.s.o(.rodata); build/asm/main_800C8CBC.s.o(.data); }
    .main_800C8CBC_bss (NOLOAD) : { build/asm/main_800C8CBC.s.o(.bss); }
    .main_800C9C24 0x800C9C24 : AT(0x000CA824) { FILL(0x00000000); build/asm/main_800C9C24.s.o(.text); build/asm/main_800C9C24.s.o(.rodata); build/asm/main_800C9C24.s.o(.data); }
    .main_800C9C24_bss (NOLOAD) : { build/asm/main_800C9C24.s.o(.bss); }
    .main_800C9CE4 0x800C9CE4 : AT(0x000CA8E4) { FILL(0x00000000); build/asm/main_800C9CE4.s.o(.text); build/asm/main_800C9CE4.s.o(.rodata); build/asm/main_800C9CE4.s.o(.data); }
    .main_800C9CE4_bss (NOLOAD) : { build/asm/main_800C9CE4.s.o(.bss); }
    .main_800C9CEC 0x800C9CEC : AT(0x000CA8EC) { FILL(0x00000000); build/asm/main_800C9CEC.s.o(.text); build/asm/main_800C9CEC.s.o(.rodata); build/asm/main_800C9CEC.s.o(.data); }
    .main_800C9CEC_bss (NOLOAD) : { build/asm/main_800C9CEC.s.o(.bss); }
    .main_800CA0F8 0x800CA0F8 : AT(0x000CACF8) { FILL(0x00000000); build/asm/main_800CA0F8.s.o(.text); build/asm/main_800CA0F8.s.o(.rodata); build/asm/main_800CA0F8.s.o(.data); }
    .main_800CA0F8_bss (NOLOAD) : { build/asm/main_800CA0F8.s.o(.bss); }
    .main_800CB958 0x800CB958 : AT(0x000CC558) { build/asm/data/main_800CB958.bin.o(.data); }
    .main_800CD898 0x800CD898 : AT(0x000CE498) { FILL(0x00000000); build/asm/main_800CD898.s.o(.text); build/asm/main_800CD898.s.o(.rodata); build/asm/main_800CD898.s.o(.data); }
    .main_800CD898_bss (NOLOAD) : { build/asm/main_800CD898.s.o(.bss); }
    .main_800CE5F0 0x800CE5F0 : AT(0x000CF1F0) { FILL(0x00000000); build/asm/main_800CE5F0.s.o(.text); build/asm/main_800CE5F0.s.o(.rodata); build/asm/main_800CE5F0.s.o(.data); }
    .main_800CE5F0_bss (NOLOAD) : { build/asm/main_800CE5F0.s.o(.bss); }
    .main_800CEF04 0x800CEF04 : AT(0x000CFB04) { build/asm/data/main_800CEF04.bin.o(.data); }
    .main_800D31EC 0x800D31EC : AT(0x000D3DEC) { FILL(0x00000000); build/asm/main_800D31EC.s.o(.text); build/asm/main_800D31EC.s.o(.rodata); build/asm/main_800D31EC.s.o(.data); }
    .main_800D31EC_bss (NOLOAD) : { build/asm/main_800D31EC.s.o(.bss); }
    .main_800D3580 0x800D3580 : AT(0x000D4180) { FILL(0x00000000); build/asm/main_800D3580.s.o(.text); build/asm/main_800D3580.s.o(.rodata); build/asm/main_800D3580.s.o(.data); }
    .main_800D3580_bss (NOLOAD) : { build/asm/main_800D3580.s.o(.bss); }
    .main_800D50E4 0x800D50E4 : AT(0x000D5CE4) { build/asm/data/main_800D50E4.bin.o(.data); }
    .main_800D5B70 0x800D5B70 : AT(0x000D6770) { build/asm/data/main_800D5B70.bin.o(.data); }
    .main_800D6F94 0x800D6F94 : AT(0x000D7B94) { build/asm/data/main_800D6F94.bin.o(.data); }
    .main_800DAD2C 0x800DAD2C : AT(0x000DB92C) { build/asm/data/main_800DAD2C.bin.o(.data); }
    .main_800DAED8 0x800DAED8 : AT(0x000DBAD8) { FILL(0x00000000); build/asm/main_800DAED8.s.o(.text); build/asm/main_800DAED8.s.o(.rodata); build/asm/main_800DAED8.s.o(.data); }
    .main_800DAED8_bss (NOLOAD) : { build/asm/main_800DAED8.s.o(.bss); }
    .main_800DB12C 0x800DB12C : AT(0x000DBD2C) { FILL(0x00000000); build/asm/main_800DB12C.s.o(.text); build/asm/main_800DB12C.s.o(.rodata); build/asm/main_800DB12C.s.o(.data); }
    .main_800DB12C_bss (NOLOAD) : { build/asm/main_800DB12C.s.o(.bss); }
    .main_800DB2A8 0x800DB2A8 : AT(0x000DBEA8) { build/asm/data/main_800DB2A8.bin.o(.data); }
    .main_800DBB50 0x800DBB50 : AT(0x000DC750) { build/asm/data/main_800DBB50.bin.o(.data); }
    .main_800DBD0C 0x800DBD0C : AT(0x000DC90C) { FILL(0x00000000); build/asm/main_800DBD0C.s.o(.text); build/asm/main_800DBD0C.s.o(.rodata); build/asm/main_800DBD0C.s.o(.data); }
    .main_800DBD0C_bss (NOLOAD) : { build/asm/main_800DBD0C.s.o(.bss); }
    .main_800DC414 0x800DC414 : AT(0x000DD014) { FILL(0x00000000); build/asm/main_800DC414.s.o(.text); build/asm/main_800DC414.s.o(.rodata); build/asm/main_800DC414.s.o(.data); }
    .main_800DC414_bss (NOLOAD) : { build/asm/main_800DC414.s.o(.bss); }
    .main_800DC558 0x800DC558 : AT(0x000DD158) { build/asm/data/main_800DC558.bin.o(.data); }
    .main_800DD188 0x800DD188 : AT(0x000DDD88) { FILL(0x00000000); build/asm/main_800DD188.s.o(.text); build/asm/main_800DD188.s.o(.rodata); build/asm/main_800DD188.s.o(.data); }
    .main_800DD188_bss (NOLOAD) : { build/asm/main_800DD188.s.o(.bss); }
    .main_800DE0C0 0x800DE0C0 : AT(0x000DECC0) { FILL(0x00000000); build/asm/main_800DE0C0.s.o(.text); build/asm/main_800DE0C0.s.o(.rodata); build/asm/main_800DE0C0.s.o(.data); }
    .main_800DE0C0_bss (NOLOAD) : { build/asm/main_800DE0C0.s.o(.bss); }
    .main_800DE83C 0x800DE83C : AT(0x000DF43C) { FILL(0x00000000); build/asm/main_800DE83C.s.o(.text); build/asm/main_800DE83C.s.o(.rodata); build/asm/main_800DE83C.s.o(.data); }
    .main_800DE83C_bss (NOLOAD) : { build/asm/main_800DE83C.s.o(.bss); }
    .main_800DF47C 0x800DF47C : AT(0x000E007C) { FILL(0x00000000); build/asm/main_800DF47C.s.o(.text); build/asm/main_800DF47C.s.o(.rodata); build/asm/main_800DF47C.s.o(.data); }
    .main_800DF47C_bss (NOLOAD) : { build/asm/main_800DF47C.s.o(.bss); }
    .main_800E0060 0x800E0060 : AT(0x000E0C60) { build/asm/data/main_800E0060.bin.o(.data); }
    .main_800E0BA0 0x800E0BA0 : AT(0x000E17A0) { FILL(0x00000000); build/asm/main_800E0BA0.s.o(.text); build/asm/main_800E0BA0.s.o(.rodata); build/asm/main_800E0BA0.s.o(.data); }
    .main_800E0BA0_bss (NOLOAD) : { build/asm/main_800E0BA0.s.o(.bss); }
    .main_800E1364 0x800E1364 : AT(0x000E1F64) { FILL(0x00000000); build/asm/main_800E1364.s.o(.text); build/asm/main_800E1364.s.o(.rodata); build/asm/main_800E1364.s.o(.data); }
    .main_800E1364_bss (NOLOAD) : { build/asm/main_800E1364.s.o(.bss); }
    .main_800E13D0 0x800E13D0 : AT(0x000E1FD0) { FILL(0x00000000); build/asm/main_800E13D0.s.o(.text); build/asm/main_800E13D0.s.o(.rodata); build/asm/main_800E13D0.s.o(.data); }
    .main_800E13D0_bss (NOLOAD) : { build/asm/main_800E13D0.s.o(.bss); }
    .main_800E1DC8 0x800E1DC8 : AT(0x000E29C8) { build/asm/data/main_800E1DC8.bin.o(.data); }
    .main_800E2D60 0x800E2D60 : AT(0x000E3960) { FILL(0x00000000); build/asm/main_800E2D60.s.o(.text); build/asm/main_800E2D60.s.o(.rodata); build/asm/main_800E2D60.s.o(.data); }
    .main_800E2D60_bss (NOLOAD) : { build/asm/main_800E2D60.s.o(.bss); }
    .main_800E2EDC 0x800E2EDC : AT(0x000E3ADC) { build/asm/data/main_800E2EDC.bin.o(.data); }
    .main_800E4DF4 0x800E4DF4 : AT(0x000E59F4) { FILL(0x00000000); build/asm/main_800E4DF4.s.o(.text); build/asm/main_800E4DF4.s.o(.rodata); build/asm/main_800E4DF4.s.o(.data); }
    .main_800E4DF4_bss (NOLOAD) : { build/asm/main_800E4DF4.s.o(.bss); }
    .main_800E4EAC 0x800E4EAC : AT(0x000E5AAC) { build/asm/data/main_800E4EAC.bin.o(.data); }
    .main_800E4F1C 0x800E4F1C : AT(0x000E5B1C) { FILL(0x00000000); build/asm/main_800E4F1C.s.o(.text); build/asm/main_800E4F1C.s.o(.rodata); build/asm/main_800E4F1C.s.o(.data); }
    .main_800E4F1C_bss (NOLOAD) : { build/asm/main_800E4F1C.s.o(.bss); }
    .main_800E53DC 0x800E53DC : AT(0x000E5FDC) { build/asm/data/main_800E53DC.bin.o(.data); }
    .main_800E5E5C 0x800E5E5C : AT(0x000E6A5C) { FILL(0x00000000); build/asm/main_800E5E5C.s.o(.text); build/asm/main_800E5E5C.s.o(.rodata); build/asm/main_800E5E5C.s.o(.data); }
    .main_800E5E5C_bss (NOLOAD) : { build/asm/main_800E5E5C.s.o(.bss); }
    .main_800E5F9C 0x800E5F9C : AT(0x000E6B9C) { build/asm/data/main_800E5F9C.bin.o(.data); }
    .main_800E64B8 0x800E64B8 : AT(0x000E70B8) { FILL(0x00000000); build/asm/main_800E64B8.s.o(.text); build/asm/main_800E64B8.s.o(.rodata); build/asm/main_800E64B8.s.o(.data); }
    .main_800E64B8_bss (NOLOAD) : { build/asm/main_800E64B8.s.o(.bss); }
    .main_800E64DC 0x800E64DC : AT(0x000E70DC) { build/asm/data/main_800E64DC.bin.o(.data); }
    .main_800E65CC 0x800E65CC : AT(0x000E71CC) { FILL(0x00000000); build/asm/main_800E65CC.s.o(.text); build/asm/main_800E65CC.s.o(.rodata); build/asm/main_800E65CC.s.o(.data); }
    .main_800E65CC_bss (NOLOAD) : { build/asm/main_800E65CC.s.o(.bss); }
    .main_800E68BC 0x800E68BC : AT(0x000E74BC) { build/asm/data/main_800E68BC.bin.o(.data); }
    .main_800E694C 0x800E694C : AT(0x000E754C) { FILL(0x00000000); build/asm/main_800E694C.s.o(.text); build/asm/main_800E694C.s.o(.rodata); build/asm/main_800E694C.s.o(.data); }
    .main_800E694C_bss (NOLOAD) : { build/asm/main_800E694C.s.o(.bss); }
    .main_800E69EC 0x800E69EC : AT(0x000E75EC) { build/asm/data/main_800E69EC.bin.o(.data); }
    .main_800E6B4C 0x800E6B4C : AT(0x000E774C) { FILL(0x00000000); build/asm/main_800E6B4C.s.o(.text); build/asm/main_800E6B4C.s.o(.rodata); build/asm/main_800E6B4C.s.o(.data); }
    .main_800E6B4C_bss (NOLOAD) : { build/asm/main_800E6B4C.s.o(.bss); }
    .main_800E6BDC 0x800E6BDC : AT(0x000E77DC) { build/asm/data/main_800E6BDC.bin.o(.data); }
    .main_800E6F0C 0x800E6F0C : AT(0x000E7B0C) { build/asm/data/main_800E6F0C.bin.o(.data); }
    .main_800E79CC 0x800E79CC : AT(0x000E85CC) { build/asm/data/main_800E79CC.bin.o(.data); }
    .main_800E800C 0x800E800C : AT(0x000E8C0C) { FILL(0x00000000); build/asm/main_800E800C.s.o(.text); build/asm/main_800E800C.s.o(.rodata); build/asm/main_800E800C.s.o(.data); }
    .main_800E800C_bss (NOLOAD) : { build/asm/main_800E800C.s.o(.bss); }
    .main_800E83CC 0x800E83CC : AT(0x000E8FCC) { FILL(0x00000000); build/asm/main_800E83CC.s.o(.text); build/asm/main_800E83CC.s.o(.rodata); build/asm/main_800E83CC.s.o(.data); }
    .main_800E83CC_bss (NOLOAD) : { build/asm/main_800E83CC.s.o(.bss); }
    .main_800E858C 0x800E858C : AT(0x000E918C) { FILL(0x00000000); build/asm/main_800E858C.s.o(.text); build/asm/main_800E858C.s.o(.rodata); build/asm/main_800E858C.s.o(.data); }
    .main_800E858C_bss (NOLOAD) : { build/asm/main_800E858C.s.o(.bss); }
    .main_800E880C 0x800E880C : AT(0x000E940C) { FILL(0x00000000); build/asm/main_800E880C.s.o(.text); build/asm/main_800E880C.s.o(.rodata); build/asm/main_800E880C.s.o(.data); }
    .main_800E880C_bss (NOLOAD) : { build/asm/main_800E880C.s.o(.bss); }
    .main_800E894C 0x800E894C : AT(0x000E954C) { FILL(0x00000000); build/asm/main_800E894C.s.o(.text); build/asm/main_800E894C.s.o(.rodata); build/asm/main_800E894C.s.o(.data); }
    .main_800E894C_bss (NOLOAD) : { build/asm/main_800E894C.s.o(.bss); }
    .main_800E8C5C 0x800E8C5C : AT(0x000E985C) { FILL(0x00000000); build/asm/main_800E8C5C.s.o(.text); build/asm/main_800E8C5C.s.o(.rodata); build/asm/main_800E8C5C.s.o(.data); }
    .main_800E8C5C_bss (NOLOAD) : { build/asm/main_800E8C5C.s.o(.bss); }
    .main_800E8D2C 0x800E8D2C : AT(0x000E992C) { FILL(0x00000000); build/asm/main_800E8D2C.s.o(.text); build/asm/main_800E8D2C.s.o(.rodata); build/asm/main_800E8D2C.s.o(.data); }
    .main_800E8D2C_bss (NOLOAD) : { build/asm/main_800E8D2C.s.o(.bss); }
    .main_800E939C 0x800E939C : AT(0x000E9F9C) { FILL(0x00000000); build/asm/main_800E939C.s.o(.text); build/asm/main_800E939C.s.o(.rodata); build/asm/main_800E939C.s.o(.data); }
    .main_800E939C_bss (NOLOAD) : { build/asm/main_800E939C.s.o(.bss); }
    .main_800E944C 0x800E944C : AT(0x000EA04C) { build/asm/data/main_800E944C.bin.o(.data); }
    .main_800E990C 0x800E990C : AT(0x000EA50C) { build/asm/data/main_800E990C.bin.o(.data); }
    .main_800EC110 0x800EC110 : AT(0x000ECD10) { build/asm/data/main_800EC110.bin.o(.data); }
    .main_800EC970 0x800EC970 : AT(0x000ED570) { build/asm/data/main_800EC970.bin.o(.data); }
    .main_800ECAC0 0x800ECAC0 : AT(0x000ED6C0) { FILL(0x00000000); build/asm/main_800ECAC0.s.o(.text); build/asm/main_800ECAC0.s.o(.rodata); build/asm/main_800ECAC0.s.o(.data); }
    .main_800ECAC0_bss (NOLOAD) : { build/asm/main_800ECAC0.s.o(.bss); }
    .main_800ED5C0 0x800ED5C0 : AT(0x000EE1C0) { build/asm/data/main_800ED5C0.bin.o(.data); }
    .main_800ED63C 0x800ED63C : AT(0x000EE23C) { FILL(0x00000000); build/asm/main_800ED63C.s.o(.text); build/asm/main_800ED63C.s.o(.rodata); build/asm/main_800ED63C.s.o(.data); }
    .main_800ED63C_bss (NOLOAD) : { build/asm/main_800ED63C.s.o(.bss); }
    .main_800ED7F0 0x800ED7F0 : AT(0x000EE3F0) { build/asm/data/main_800ED7F0.bin.o(.data); }
    .main_800FA7B0 0x800FA7B0 : AT(0x000FB3B0) { FILL(0x00000000); build/asm/main_800FA7B0.s.o(.text); build/asm/main_800FA7B0.s.o(.rodata); build/asm/main_800FA7B0.s.o(.data); }
    .main_800FA7B0_bss (NOLOAD) : { build/asm/main_800FA7B0.s.o(.bss); }
    .main_800FA7BC 0x800FA7BC : AT(0x000FB3BC) { build/asm/data/main_800FA7BC.bin.o(.data); }
    .main_800FB2F8 0x800FB2F8 : AT(0x000FBEF8) { FILL(0x00000000); build/asm/main_800FB2F8.s.o(.text); build/asm/main_800FB2F8.s.o(.rodata); build/asm/main_800FB2F8.s.o(.data); }
    .main_800FB2F8_bss (NOLOAD) : { build/asm/main_800FB2F8.s.o(.bss); }
    .main_800FB350 0x800FB350 : AT(0x000FBF50) { build/asm/data/main_800FB350.bin.o(.data); }
    .main_800FD088 0x800FD088 : AT(0x000FDC88) { FILL(0x00000000); build/asm/main_800FD088.s.o(.text); build/asm/main_800FD088.s.o(.rodata); build/asm/main_800FD088.s.o(.data); }
    .main_800FD088_bss (NOLOAD) : { build/asm/main_800FD088.s.o(.bss); }
    .main_800FD0B4 0x800FD0B4 : AT(0x000FDCB4) { build/asm/data/main_800FD0B4.bin.o(.data); }
    .main_801003F0 0x801003F0 : AT(0x00100FF0) { FILL(0x00000000); build/asm/main_801003F0.s.o(.text); build/asm/main_801003F0.s.o(.rodata); build/asm/main_801003F0.s.o(.data); }
    .main_801003F0_bss (NOLOAD) : { build/asm/main_801003F0.s.o(.bss); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
