SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80300000 0x80300000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80300000.s.o(.text); build/asm/main_80300000.s.o(.rodata); build/asm/main_80300000.s.o(.data); }
    .main_80300000_bss (NOLOAD) : { build/asm/main_80300000.s.o(.bss); }
    .main_80300274 0x80300274 : AT(0x00001274) { FILL(0x00000000); build/asm/main_80300274.s.o(.text); build/asm/main_80300274.s.o(.rodata); build/asm/main_80300274.s.o(.data); }
    .main_80300274_bss (NOLOAD) : { build/asm/main_80300274.s.o(.bss); }
    .main_80300928 0x80300928 : AT(0x00001928) { build/asm/data/main_80300928.bin.o(.data); }
    .main_803151D0 0x803151D0 : AT(0x000161D0) { FILL(0x00000000); build/asm/main_803151D0.s.o(.text); build/asm/main_803151D0.s.o(.rodata); build/asm/main_803151D0.s.o(.data); }
    .main_803151D0_bss (NOLOAD) : { build/asm/main_803151D0.s.o(.bss); }
    .main_803151FC 0x803151FC : AT(0x000161FC) { build/asm/data/main_803151FC.bin.o(.data); }
    .main_80319E9C 0x80319E9C : AT(0x0001AE9C) { FILL(0x00000000); build/asm/main_80319E9C.s.o(.text); build/asm/main_80319E9C.s.o(.rodata); build/asm/main_80319E9C.s.o(.data); }
    .main_80319E9C_bss (NOLOAD) : { build/asm/main_80319E9C.s.o(.bss); }
    .main_80319F34 0x80319F34 : AT(0x0001AF34) { build/asm/data/main_80319F34.bin.o(.data); }
    .main_8031B4B4 0x8031B4B4 : AT(0x0001C4B4) { FILL(0x00000000); build/asm/main_8031B4B4.s.o(.text); build/asm/main_8031B4B4.s.o(.rodata); build/asm/main_8031B4B4.s.o(.data); }
    .main_8031B4B4_bss (NOLOAD) : { build/asm/main_8031B4B4.s.o(.bss); }
    .main_8031B550 0x8031B550 : AT(0x0001C550) { build/asm/data/main_8031B550.bin.o(.data); }
    .main_8032200C 0x8032200C : AT(0x0002300C) { FILL(0x00000000); build/asm/main_8032200C.s.o(.text); build/asm/main_8032200C.s.o(.rodata); build/asm/main_8032200C.s.o(.data); }
    .main_8032200C_bss (NOLOAD) : { build/asm/main_8032200C.s.o(.bss); }
    .main_80322018 0x80322018 : AT(0x00023018) { build/asm/data/main_80322018.bin.o(.data); }
    .main_80329174 0x80329174 : AT(0x0002A174) { FILL(0x00000000); build/asm/main_80329174.s.o(.text); build/asm/main_80329174.s.o(.rodata); build/asm/main_80329174.s.o(.data); }
    .main_80329174_bss (NOLOAD) : { build/asm/main_80329174.s.o(.bss); }
    .main_80329178 0x80329178 : AT(0x0002A178) { build/asm/data/main_80329178.bin.o(.data); }
    .main_8032E230 0x8032E230 : AT(0x0002F230) { FILL(0x00000000); build/asm/main_8032E230.s.o(.text); build/asm/main_8032E230.s.o(.rodata); build/asm/main_8032E230.s.o(.data); }
    .main_8032E230_bss (NOLOAD) : { build/asm/main_8032E230.s.o(.bss); }
    .main_8032FDD4 0x8032FDD4 : AT(0x00030DD4) { build/asm/data/main_8032FDD4.bin.o(.data); }
    .main_80330BA8 0x80330BA8 : AT(0x00031BA8) { FILL(0x00000000); build/asm/main_80330BA8.s.o(.text); build/asm/main_80330BA8.s.o(.rodata); build/asm/main_80330BA8.s.o(.data); }
    .main_80330BA8_bss (NOLOAD) : { build/asm/main_80330BA8.s.o(.bss); }
    .main_80330F88 0x80330F88 : AT(0x00031F88) { build/asm/data/main_80330F88.bin.o(.data); }
    .main_80338178 0x80338178 : AT(0x00039178) { FILL(0x00000000); build/asm/main_80338178.s.o(.text); build/asm/main_80338178.s.o(.rodata); build/asm/main_80338178.s.o(.data); }
    .main_80338178_bss (NOLOAD) : { build/asm/main_80338178.s.o(.bss); }
    .main_803381A0 0x803381A0 : AT(0x000391A0) { build/asm/data/main_803381A0.bin.o(.data); }
    .main_8033862C 0x8033862C : AT(0x0003962C) { FILL(0x00000000); build/asm/main_8033862C.s.o(.text); build/asm/main_8033862C.s.o(.rodata); build/asm/main_8033862C.s.o(.data); }
    .main_8033862C_bss (NOLOAD) : { build/asm/main_8033862C.s.o(.bss); }
    .main_80338690 0x80338690 : AT(0x00039690) { build/asm/data/main_80338690.bin.o(.data); }
    .main_803390A4 0x803390A4 : AT(0x0003A0A4) { FILL(0x00000000); build/asm/main_803390A4.s.o(.text); build/asm/main_803390A4.s.o(.rodata); build/asm/main_803390A4.s.o(.data); }
    .main_803390A4_bss (NOLOAD) : { build/asm/main_803390A4.s.o(.bss); }
    .main_803390C0 0x803390C0 : AT(0x0003A0C0) { build/asm/data/main_803390C0.bin.o(.data); }
    .main_8033912C 0x8033912C : AT(0x0003A12C) { FILL(0x00000000); build/asm/main_8033912C.s.o(.text); build/asm/main_8033912C.s.o(.rodata); build/asm/main_8033912C.s.o(.data); }
    .main_8033912C_bss (NOLOAD) : { build/asm/main_8033912C.s.o(.bss); }
    .main_80339160 0x80339160 : AT(0x0003A160) { build/asm/data/main_80339160.bin.o(.data); }
    .main_803399A4 0x803399A4 : AT(0x0003A9A4) { FILL(0x00000000); build/asm/main_803399A4.s.o(.text); build/asm/main_803399A4.s.o(.rodata); build/asm/main_803399A4.s.o(.data); }
    .main_803399A4_bss (NOLOAD) : { build/asm/main_803399A4.s.o(.bss); }
    .main_803399BC 0x803399BC : AT(0x0003A9BC) { build/asm/data/main_803399BC.bin.o(.data); }
    .main_80339B7C 0x80339B7C : AT(0x0003AB7C) { FILL(0x00000000); build/asm/main_80339B7C.s.o(.text); build/asm/main_80339B7C.s.o(.rodata); build/asm/main_80339B7C.s.o(.data); }
    .main_80339B7C_bss (NOLOAD) : { build/asm/main_80339B7C.s.o(.bss); }
    .main_80339DD8 0x80339DD8 : AT(0x0003ADD8) { build/asm/data/main_80339DD8.bin.o(.data); }
    .main_8033A8BC 0x8033A8BC : AT(0x0003B8BC) { FILL(0x00000000); build/asm/main_8033A8BC.s.o(.text); build/asm/main_8033A8BC.s.o(.rodata); build/asm/main_8033A8BC.s.o(.data); }
    .main_8033A8BC_bss (NOLOAD) : { build/asm/main_8033A8BC.s.o(.bss); }
    .main_8033A940 0x8033A940 : AT(0x0003B940) { build/asm/data/main_8033A940.bin.o(.data); }
    .main_8033AAFC 0x8033AAFC : AT(0x0003BAFC) { FILL(0x00000000); build/asm/main_8033AAFC.s.o(.text); build/asm/main_8033AAFC.s.o(.rodata); build/asm/main_8033AAFC.s.o(.data); }
    .main_8033AAFC_bss (NOLOAD) : { build/asm/main_8033AAFC.s.o(.bss); }
    .main_8033AB88 0x8033AB88 : AT(0x0003BB88) { build/asm/data/main_8033AB88.bin.o(.data); }
    .main_8033AECC 0x8033AECC : AT(0x0003BECC) { FILL(0x00000000); build/asm/main_8033AECC.s.o(.text); build/asm/main_8033AECC.s.o(.rodata); build/asm/main_8033AECC.s.o(.data); }
    .main_8033AECC_bss (NOLOAD) : { build/asm/main_8033AECC.s.o(.bss); }
    .main_8033AF1C 0x8033AF1C : AT(0x0003BF1C) { build/asm/data/main_8033AF1C.bin.o(.data); }
    .main_8033AF50 0x8033AF50 : AT(0x0003BF50) { FILL(0x00000000); build/asm/main_8033AF50.s.o(.text); build/asm/main_8033AF50.s.o(.rodata); build/asm/main_8033AF50.s.o(.data); }
    .main_8033AF50_bss (NOLOAD) : { build/asm/main_8033AF50.s.o(.bss); }
    .main_8033AFDC 0x8033AFDC : AT(0x0003BFDC) { build/asm/data/main_8033AFDC.bin.o(.data); }
    .main_8033BA38 0x8033BA38 : AT(0x0003CA38) { FILL(0x00000000); build/asm/main_8033BA38.s.o(.text); build/asm/main_8033BA38.s.o(.rodata); build/asm/main_8033BA38.s.o(.data); }
    .main_8033BA38_bss (NOLOAD) : { build/asm/main_8033BA38.s.o(.bss); }
    .main_8033BACC 0x8033BACC : AT(0x0003CACC) { build/asm/data/main_8033BACC.bin.o(.data); }
    .main_8033BE44 0x8033BE44 : AT(0x0003CE44) { FILL(0x00000000); build/asm/main_8033BE44.s.o(.text); build/asm/main_8033BE44.s.o(.rodata); build/asm/main_8033BE44.s.o(.data); }
    .main_8033BE44_bss (NOLOAD) : { build/asm/main_8033BE44.s.o(.bss); }
    .main_8033BE88 0x8033BE88 : AT(0x0003CE88) { build/asm/data/main_8033BE88.bin.o(.data); }
    .main_8033C458 0x8033C458 : AT(0x0003D458) { FILL(0x00000000); build/asm/main_8033C458.s.o(.text); build/asm/main_8033C458.s.o(.rodata); build/asm/main_8033C458.s.o(.data); }
    .main_8033C458_bss (NOLOAD) : { build/asm/main_8033C458.s.o(.bss); }
    .main_8033C4A0 0x8033C4A0 : AT(0x0003D4A0) { build/asm/data/main_8033C4A0.bin.o(.data); }
    .main_8033D0B0 0x8033D0B0 : AT(0x0003E0B0) { FILL(0x00000000); build/asm/main_8033D0B0.s.o(.text); build/asm/main_8033D0B0.s.o(.rodata); build/asm/main_8033D0B0.s.o(.data); }
    .main_8033D0B0_bss (NOLOAD) : { build/asm/main_8033D0B0.s.o(.bss); }
    .main_8033D0F0 0x8033D0F0 : AT(0x0003E0F0) { build/asm/data/main_8033D0F0.bin.o(.data); }
    .main_8033D9D4 0x8033D9D4 : AT(0x0003E9D4) { FILL(0x00000000); build/asm/main_8033D9D4.s.o(.text); build/asm/main_8033D9D4.s.o(.rodata); build/asm/main_8033D9D4.s.o(.data); }
    .main_8033D9D4_bss (NOLOAD) : { build/asm/main_8033D9D4.s.o(.bss); }
    .main_8033D9EC 0x8033D9EC : AT(0x0003E9EC) { build/asm/data/main_8033D9EC.bin.o(.data); }
    .main_8033DD74 0x8033DD74 : AT(0x0003ED74) { FILL(0x00000000); build/asm/main_8033DD74.s.o(.text); build/asm/main_8033DD74.s.o(.rodata); build/asm/main_8033DD74.s.o(.data); }
    .main_8033DD74_bss (NOLOAD) : { build/asm/main_8033DD74.s.o(.bss); }
    .main_8033DF78 0x8033DF78 : AT(0x0003EF78) { build/asm/data/main_8033DF78.bin.o(.data); }
    .main_80348D24 0x80348D24 : AT(0x00049D24) { FILL(0x00000000); build/asm/main_80348D24.s.o(.text); build/asm/main_80348D24.s.o(.rodata); build/asm/main_80348D24.s.o(.data); }
    .main_80348D24_bss (NOLOAD) : { build/asm/main_80348D24.s.o(.bss); }
    .main_80348D28 0x80348D28 : AT(0x00049D28) { build/asm/data/main_80348D28.bin.o(.data); }
    .main_803583C4 0x803583C4 : AT(0x000593C4) { FILL(0x00000000); build/asm/main_803583C4.s.o(.text); build/asm/main_803583C4.s.o(.rodata); build/asm/main_803583C4.s.o(.data); }
    .main_803583C4_bss (NOLOAD) : { build/asm/main_803583C4.s.o(.bss); }
    .main_80358510 0x80358510 : AT(0x00059510) { build/asm/data/main_80358510.bin.o(.data); }
    .main_8035F2C4 0x8035F2C4 : AT(0x000602C4) { FILL(0x00000000); build/asm/main_8035F2C4.s.o(.text); build/asm/main_8035F2C4.s.o(.rodata); build/asm/main_8035F2C4.s.o(.data); }
    .main_8035F2C4_bss (NOLOAD) : { build/asm/main_8035F2C4.s.o(.bss); }
    .main_8035F2F8 0x8035F2F8 : AT(0x000602F8) { build/asm/data/main_8035F2F8.bin.o(.data); }
    .main_80362710 0x80362710 : AT(0x00063710) { FILL(0x00000000); build/asm/main_80362710.s.o(.text); build/asm/main_80362710.s.o(.rodata); build/asm/main_80362710.s.o(.data); }
    .main_80362710_bss (NOLOAD) : { build/asm/main_80362710.s.o(.bss); }
    .main_80362724 0x80362724 : AT(0x00063724) { build/asm/data/main_80362724.bin.o(.data); }
    .main_80365388 0x80365388 : AT(0x00066388) { FILL(0x00000000); build/asm/main_80365388.s.o(.text); build/asm/main_80365388.s.o(.rodata); build/asm/main_80365388.s.o(.data); }
    .main_80365388_bss (NOLOAD) : { build/asm/main_80365388.s.o(.bss); }
    .main_803653B4 0x803653B4 : AT(0x000663B4) { build/asm/data/main_803653B4.bin.o(.data); }
    .main_8037622C 0x8037622C : AT(0x0007722C) { FILL(0x00000000); build/asm/main_8037622C.s.o(.text); build/asm/main_8037622C.s.o(.rodata); build/asm/main_8037622C.s.o(.data); }
    .main_8037622C_bss (NOLOAD) : { build/asm/main_8037622C.s.o(.bss); }
    .main_80376238 0x80376238 : AT(0x00077238) { build/asm/data/main_80376238.bin.o(.data); }
    .main_80378E30 0x80378E30 : AT(0x00079E30) { FILL(0x00000000); build/asm/main_80378E30.s.o(.text); build/asm/main_80378E30.s.o(.rodata); build/asm/main_80378E30.s.o(.data); }
    .main_80378E30_bss (NOLOAD) : { build/asm/main_80378E30.s.o(.bss); }
    .main_80378E48 0x80378E48 : AT(0x00079E48) { build/asm/data/main_80378E48.bin.o(.data); }
    .main_8037B210 0x8037B210 : AT(0x0007C210) { FILL(0x00000000); build/asm/main_8037B210.s.o(.text); build/asm/main_8037B210.s.o(.rodata); build/asm/main_8037B210.s.o(.data); }
    .main_8037B210_bss (NOLOAD) : { build/asm/main_8037B210.s.o(.bss); }
    .main_8037B298 0x8037B298 : AT(0x0007C298) { build/asm/data/main_8037B298.bin.o(.data); }
    .main_8037B920 0x8037B920 : AT(0x0007C920) { FILL(0x00000000); build/asm/main_8037B920.s.o(.text); build/asm/main_8037B920.s.o(.rodata); build/asm/main_8037B920.s.o(.data); }
    .main_8037B920_bss (NOLOAD) : { build/asm/main_8037B920.s.o(.bss); }
    .main_8037B954 0x8037B954 : AT(0x0007C954) { build/asm/data/main_8037B954.bin.o(.data); }
    .main_8038ED44 0x8038ED44 : AT(0x0008FD44) { FILL(0x00000000); build/asm/main_8038ED44.s.o(.text); build/asm/main_8038ED44.s.o(.rodata); build/asm/main_8038ED44.s.o(.data); }
    .main_8038ED44_bss (NOLOAD) : { build/asm/main_8038ED44.s.o(.bss); }
    .main_8038ED74 0x8038ED74 : AT(0x0008FD74) { build/asm/data/main_8038ED74.bin.o(.data); }
    .main_803A8EB0 0x803A8EB0 : AT(0x000A9EB0) { FILL(0x00000000); build/asm/main_803A8EB0.s.o(.text); build/asm/main_803A8EB0.s.o(.rodata); build/asm/main_803A8EB0.s.o(.data); }
    .main_803A8EB0_bss (NOLOAD) : { build/asm/main_803A8EB0.s.o(.bss); }
    .main_803A8F20 0x803A8F20 : AT(0x000A9F20) { build/asm/data/main_803A8F20.bin.o(.data); }
    .main_803BB8D0 0x803BB8D0 : AT(0x000BC8D0) { FILL(0x00000000); build/asm/main_803BB8D0.s.o(.text); build/asm/main_803BB8D0.s.o(.rodata); build/asm/main_803BB8D0.s.o(.data); }
    .main_803BB8D0_bss (NOLOAD) : { build/asm/main_803BB8D0.s.o(.bss); }
    .main_803BB934 0x803BB934 : AT(0x000BC934) { build/asm/data/main_803BB934.bin.o(.data); }
    .main_803BCC14 0x803BCC14 : AT(0x000BDC14) { FILL(0x00000000); build/asm/main_803BCC14.s.o(.text); build/asm/main_803BCC14.s.o(.rodata); build/asm/main_803BCC14.s.o(.data); }
    .main_803BCC14_bss (NOLOAD) : { build/asm/main_803BCC14.s.o(.bss); }
    .main_803BCC68 0x803BCC68 : AT(0x000BDC68) { build/asm/data/main_803BCC68.bin.o(.data); }
    .main_803C8134 0x803C8134 : AT(0x000C9134) { FILL(0x00000000); build/asm/main_803C8134.s.o(.text); build/asm/main_803C8134.s.o(.rodata); build/asm/main_803C8134.s.o(.data); }
    .main_803C8134_bss (NOLOAD) : { build/asm/main_803C8134.s.o(.bss); }
    .main_803C814C 0x803C814C : AT(0x000C914C) { build/asm/data/main_803C814C.bin.o(.data); }
    .main_803CBE88 0x803CBE88 : AT(0x000CCE88) { FILL(0x00000000); build/asm/main_803CBE88.s.o(.text); build/asm/main_803CBE88.s.o(.rodata); build/asm/main_803CBE88.s.o(.data); }
    .main_803CBE88_bss (NOLOAD) : { build/asm/main_803CBE88.s.o(.bss); }
    .main_803CBE8C 0x803CBE8C : AT(0x000CCE8C) { build/asm/data/main_803CBE8C.bin.o(.data); }
    .main_803DDA70 0x803DDA70 : AT(0x000DEA70) { FILL(0x00000000); build/asm/main_803DDA70.s.o(.text); build/asm/main_803DDA70.s.o(.rodata); build/asm/main_803DDA70.s.o(.data); }
    .main_803DDA70_bss (NOLOAD) : { build/asm/main_803DDA70.s.o(.bss); }
    .main_803DDAAC 0x803DDAAC : AT(0x000DEAAC) { build/asm/data/main_803DDAAC.bin.o(.data); }
    .main_803E60BC 0x803E60BC : AT(0x000E70BC) { FILL(0x00000000); build/asm/main_803E60BC.s.o(.text); build/asm/main_803E60BC.s.o(.rodata); build/asm/main_803E60BC.s.o(.data); }
    .main_803E60BC_bss (NOLOAD) : { build/asm/main_803E60BC.s.o(.bss); }
    .main_803E60D0 0x803E60D0 : AT(0x000E70D0) { build/asm/data/main_803E60D0.bin.o(.data); }
    .main_803EBFD4 0x803EBFD4 : AT(0x000ECFD4) { FILL(0x00000000); build/asm/main_803EBFD4.s.o(.text); build/asm/main_803EBFD4.s.o(.rodata); build/asm/main_803EBFD4.s.o(.data); }
    .main_803EBFD4_bss (NOLOAD) : { build/asm/main_803EBFD4.s.o(.bss); }
    .main_803EC03C 0x803EC03C : AT(0x000ED03C) { build/asm/data/main_803EC03C.bin.o(.data); }
    .assets 0x80700000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
