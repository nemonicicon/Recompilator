SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80300000 0x80300000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80300000.s.o(.text); build/asm/main_80300000.s.o(.rodata); build/asm/main_80300000.s.o(.data); }
    .main_80300000_bss (NOLOAD) : { build/asm/main_80300000.s.o(.bss); }
    .main_80300274 0x80300274 : AT(0x00001274) { FILL(0x00000000); build/asm/main_80300274.s.o(.text); build/asm/main_80300274.s.o(.rodata); build/asm/main_80300274.s.o(.data); }
    .main_80300274_bss (NOLOAD) : { build/asm/main_80300274.s.o(.bss); }
    .main_803008E8 0x803008E8 : AT(0x000018E8) { build/asm/data/main_803008E8.bin.o(.data); }
    .main_80307EB4 0x80307EB4 : AT(0x00008EB4) { FILL(0x00000000); build/asm/main_80307EB4.s.o(.text); build/asm/main_80307EB4.s.o(.rodata); build/asm/main_80307EB4.s.o(.data); }
    .main_80307EB4_bss (NOLOAD) : { build/asm/main_80307EB4.s.o(.bss); }
    .main_80307F18 0x80307F18 : AT(0x00008F18) { build/asm/data/main_80307F18.bin.o(.data); }
    .main_80317A58 0x80317A58 : AT(0x00018A58) { FILL(0x00000000); build/asm/main_80317A58.s.o(.text); build/asm/main_80317A58.s.o(.rodata); build/asm/main_80317A58.s.o(.data); }
    .main_80317A58_bss (NOLOAD) : { build/asm/main_80317A58.s.o(.bss); }
    .main_80317A78 0x80317A78 : AT(0x00018A78) { build/asm/data/main_80317A78.bin.o(.data); }
    .main_80321738 0x80321738 : AT(0x00022738) { FILL(0x00000000); build/asm/main_80321738.s.o(.text); build/asm/main_80321738.s.o(.rodata); build/asm/main_80321738.s.o(.data); }
    .main_80321738_bss (NOLOAD) : { build/asm/main_80321738.s.o(.bss); }
    .main_80321744 0x80321744 : AT(0x00022744) { build/asm/data/main_80321744.bin.o(.data); }
    .main_8032DE44 0x8032DE44 : AT(0x0002EE44) { FILL(0x00000000); build/asm/main_8032DE44.s.o(.text); build/asm/main_8032DE44.s.o(.rodata); build/asm/main_8032DE44.s.o(.data); }
    .main_8032DE44_bss (NOLOAD) : { build/asm/main_8032DE44.s.o(.bss); }
    .main_8032DE5C 0x8032DE5C : AT(0x0002EE5C) { build/asm/data/main_8032DE5C.bin.o(.data); }
    .main_80331B6C 0x80331B6C : AT(0x00032B6C) { FILL(0x00000000); build/asm/main_80331B6C.s.o(.text); build/asm/main_80331B6C.s.o(.rodata); build/asm/main_80331B6C.s.o(.data); }
    .main_80331B6C_bss (NOLOAD) : { build/asm/main_80331B6C.s.o(.bss); }
    .main_80334A64 0x80334A64 : AT(0x00035A64) { build/asm/data/main_80334A64.bin.o(.data); }
    .main_8033971C 0x8033971C : AT(0x0003A71C) { FILL(0x00000000); build/asm/main_8033971C.s.o(.text); build/asm/main_8033971C.s.o(.rodata); build/asm/main_8033971C.s.o(.data); }
    .main_8033971C_bss (NOLOAD) : { build/asm/main_8033971C.s.o(.bss); }
    .main_8033973C 0x8033973C : AT(0x0003A73C) { build/asm/data/main_8033973C.bin.o(.data); }
    .main_80339F0C 0x80339F0C : AT(0x0003AF0C) { FILL(0x00000000); build/asm/main_80339F0C.s.o(.text); build/asm/main_80339F0C.s.o(.rodata); build/asm/main_80339F0C.s.o(.data); }
    .main_80339F0C_bss (NOLOAD) : { build/asm/main_80339F0C.s.o(.bss); }
    .main_8033A0BC 0x8033A0BC : AT(0x0003B0BC) { build/asm/data/main_8033A0BC.bin.o(.data); }
    .main_8033AB24 0x8033AB24 : AT(0x0003BB24) { FILL(0x00000000); build/asm/main_8033AB24.s.o(.text); build/asm/main_8033AB24.s.o(.rodata); build/asm/main_8033AB24.s.o(.data); }
    .main_8033AB24_bss (NOLOAD) : { build/asm/main_8033AB24.s.o(.bss); }
    .main_8033AB38 0x8033AB38 : AT(0x0003BB38) { build/asm/data/main_8033AB38.bin.o(.data); }
    .main_8033C81C 0x8033C81C : AT(0x0003D81C) { FILL(0x00000000); build/asm/main_8033C81C.s.o(.text); build/asm/main_8033C81C.s.o(.rodata); build/asm/main_8033C81C.s.o(.data); }
    .main_8033C81C_bss (NOLOAD) : { build/asm/main_8033C81C.s.o(.bss); }
    .main_8033CA4C 0x8033CA4C : AT(0x0003DA4C) { build/asm/data/main_8033CA4C.bin.o(.data); }
    .main_8033CBF4 0x8033CBF4 : AT(0x0003DBF4) { FILL(0x00000000); build/asm/main_8033CBF4.s.o(.text); build/asm/main_8033CBF4.s.o(.rodata); build/asm/main_8033CBF4.s.o(.data); }
    .main_8033CBF4_bss (NOLOAD) : { build/asm/main_8033CBF4.s.o(.bss); }
    .main_8033CEA0 0x8033CEA0 : AT(0x0003DEA0) { build/asm/data/main_8033CEA0.bin.o(.data); }
    .main_8033E27C 0x8033E27C : AT(0x0003F27C) { FILL(0x00000000); build/asm/main_8033E27C.s.o(.text); build/asm/main_8033E27C.s.o(.rodata); build/asm/main_8033E27C.s.o(.data); }
    .main_8033E27C_bss (NOLOAD) : { build/asm/main_8033E27C.s.o(.bss); }
    .main_8033E2B8 0x8033E2B8 : AT(0x0003F2B8) { build/asm/data/main_8033E2B8.bin.o(.data); }
    .main_8033E6D0 0x8033E6D0 : AT(0x0003F6D0) { FILL(0x00000000); build/asm/main_8033E6D0.s.o(.text); build/asm/main_8033E6D0.s.o(.rodata); build/asm/main_8033E6D0.s.o(.data); }
    .main_8033E6D0_bss (NOLOAD) : { build/asm/main_8033E6D0.s.o(.bss); }
    .main_8033E6D8 0x8033E6D8 : AT(0x0003F6D8) { build/asm/data/main_8033E6D8.bin.o(.data); }
    .main_8033F500 0x8033F500 : AT(0x00040500) { FILL(0x00000000); build/asm/main_8033F500.s.o(.text); build/asm/main_8033F500.s.o(.rodata); build/asm/main_8033F500.s.o(.data); }
    .main_8033F500_bss (NOLOAD) : { build/asm/main_8033F500.s.o(.bss); }
    .main_8033F648 0x8033F648 : AT(0x00040648) { build/asm/data/main_8033F648.bin.o(.data); }
    .main_8033FDC8 0x8033FDC8 : AT(0x00040DC8) { FILL(0x00000000); build/asm/main_8033FDC8.s.o(.text); build/asm/main_8033FDC8.s.o(.rodata); build/asm/main_8033FDC8.s.o(.data); }
    .main_8033FDC8_bss (NOLOAD) : { build/asm/main_8033FDC8.s.o(.bss); }
    .main_8033FE28 0x8033FE28 : AT(0x00040E28) { build/asm/data/main_8033FE28.bin.o(.data); }
    .main_8033FFA8 0x8033FFA8 : AT(0x00040FA8) { FILL(0x00000000); build/asm/main_8033FFA8.s.o(.text); build/asm/main_8033FFA8.s.o(.rodata); build/asm/main_8033FFA8.s.o(.data); }
    .main_8033FFA8_bss (NOLOAD) : { build/asm/main_8033FFA8.s.o(.bss); }
    .main_803400B0 0x803400B0 : AT(0x000410B0) { build/asm/data/main_803400B0.bin.o(.data); }
    .main_803400F0 0x803400F0 : AT(0x000410F0) { FILL(0x00000000); build/asm/main_803400F0.s.o(.text); build/asm/main_803400F0.s.o(.rodata); build/asm/main_803400F0.s.o(.data); }
    .main_803400F0_bss (NOLOAD) : { build/asm/main_803400F0.s.o(.bss); }
    .main_80340128 0x80340128 : AT(0x00041128) { build/asm/data/main_80340128.bin.o(.data); }
    .main_80340290 0x80340290 : AT(0x00041290) { FILL(0x00000000); build/asm/main_80340290.s.o(.text); build/asm/main_80340290.s.o(.rodata); build/asm/main_80340290.s.o(.data); }
    .main_80340290_bss (NOLOAD) : { build/asm/main_80340290.s.o(.bss); }
    .main_803402F8 0x803402F8 : AT(0x000412F8) { build/asm/data/main_803402F8.bin.o(.data); }
    .main_80340344 0x80340344 : AT(0x00041344) { FILL(0x00000000); build/asm/main_80340344.s.o(.text); build/asm/main_80340344.s.o(.rodata); build/asm/main_80340344.s.o(.data); }
    .main_80340344_bss (NOLOAD) : { build/asm/main_80340344.s.o(.bss); }
    .main_80340364 0x80340364 : AT(0x00041364) { build/asm/data/main_80340364.bin.o(.data); }
    .main_80341D78 0x80341D78 : AT(0x00042D78) { FILL(0x00000000); build/asm/main_80341D78.s.o(.text); build/asm/main_80341D78.s.o(.rodata); build/asm/main_80341D78.s.o(.data); }
    .main_80341D78_bss (NOLOAD) : { build/asm/main_80341D78.s.o(.bss); }
    .main_803420D0 0x803420D0 : AT(0x000430D0) { build/asm/data/main_803420D0.bin.o(.data); }
    .main_803422D4 0x803422D4 : AT(0x000432D4) { FILL(0x00000000); build/asm/main_803422D4.s.o(.text); build/asm/main_803422D4.s.o(.rodata); build/asm/main_803422D4.s.o(.data); }
    .main_803422D4_bss (NOLOAD) : { build/asm/main_803422D4.s.o(.bss); }
    .main_80342770 0x80342770 : AT(0x00043770) { build/asm/data/main_80342770.bin.o(.data); }
    .main_803439CC 0x803439CC : AT(0x000449CC) { FILL(0x00000000); build/asm/main_803439CC.s.o(.text); build/asm/main_803439CC.s.o(.rodata); build/asm/main_803439CC.s.o(.data); }
    .main_803439CC_bss (NOLOAD) : { build/asm/main_803439CC.s.o(.bss); }
    .main_803439E4 0x803439E4 : AT(0x000449E4) { build/asm/data/main_803439E4.bin.o(.data); }
    .main_8034847C 0x8034847C : AT(0x0004947C) { FILL(0x00000000); build/asm/main_8034847C.s.o(.text); build/asm/main_8034847C.s.o(.rodata); build/asm/main_8034847C.s.o(.data); }
    .main_8034847C_bss (NOLOAD) : { build/asm/main_8034847C.s.o(.bss); }
    .main_80348488 0x80348488 : AT(0x00049488) { build/asm/data/main_80348488.bin.o(.data); }
    .main_8034E924 0x8034E924 : AT(0x0004F924) { FILL(0x00000000); build/asm/main_8034E924.s.o(.text); build/asm/main_8034E924.s.o(.rodata); build/asm/main_8034E924.s.o(.data); }
    .main_8034E924_bss (NOLOAD) : { build/asm/main_8034E924.s.o(.bss); }
    .main_8034E93C 0x8034E93C : AT(0x0004F93C) { build/asm/data/main_8034E93C.bin.o(.data); }
    .main_8034EB00 0x8034EB00 : AT(0x0004FB00) { FILL(0x00000000); build/asm/main_8034EB00.s.o(.text); build/asm/main_8034EB00.s.o(.rodata); build/asm/main_8034EB00.s.o(.data); }
    .main_8034EB00_bss (NOLOAD) : { build/asm/main_8034EB00.s.o(.bss); }
    .main_8034EB0C 0x8034EB0C : AT(0x0004FB0C) { build/asm/data/main_8034EB0C.bin.o(.data); }
    .main_80354648 0x80354648 : AT(0x00055648) { FILL(0x00000000); build/asm/main_80354648.s.o(.text); build/asm/main_80354648.s.o(.rodata); build/asm/main_80354648.s.o(.data); }
    .main_80354648_bss (NOLOAD) : { build/asm/main_80354648.s.o(.bss); }
    .main_80354678 0x80354678 : AT(0x00055678) { build/asm/data/main_80354678.bin.o(.data); }
    .main_80357584 0x80357584 : AT(0x00058584) { FILL(0x00000000); build/asm/main_80357584.s.o(.text); build/asm/main_80357584.s.o(.rodata); build/asm/main_80357584.s.o(.data); }
    .main_80357584_bss (NOLOAD) : { build/asm/main_80357584.s.o(.bss); }
    .main_803575E8 0x803575E8 : AT(0x000585E8) { build/asm/data/main_803575E8.bin.o(.data); }
    .main_8035861C 0x8035861C : AT(0x0005961C) { FILL(0x00000000); build/asm/main_8035861C.s.o(.text); build/asm/main_8035861C.s.o(.rodata); build/asm/main_8035861C.s.o(.data); }
    .main_8035861C_bss (NOLOAD) : { build/asm/main_8035861C.s.o(.bss); }
    .main_80358628 0x80358628 : AT(0x00059628) { build/asm/data/main_80358628.bin.o(.data); }
    .main_80371748 0x80371748 : AT(0x00072748) { FILL(0x00000000); build/asm/main_80371748.s.o(.text); build/asm/main_80371748.s.o(.rodata); build/asm/main_80371748.s.o(.data); }
    .main_80371748_bss (NOLOAD) : { build/asm/main_80371748.s.o(.bss); }
    .main_8037174C 0x8037174C : AT(0x0007274C) { build/asm/data/main_8037174C.bin.o(.data); }
    .main_80374BAC 0x80374BAC : AT(0x00075BAC) { FILL(0x00000000); build/asm/main_80374BAC.s.o(.text); build/asm/main_80374BAC.s.o(.rodata); build/asm/main_80374BAC.s.o(.data); }
    .main_80374BAC_bss (NOLOAD) : { build/asm/main_80374BAC.s.o(.bss); }
    .main_80374BE8 0x80374BE8 : AT(0x00075BE8) { build/asm/data/main_80374BE8.bin.o(.data); }
    .main_803823FC 0x803823FC : AT(0x000833FC) { FILL(0x00000000); build/asm/main_803823FC.s.o(.text); build/asm/main_803823FC.s.o(.rodata); build/asm/main_803823FC.s.o(.data); }
    .main_803823FC_bss (NOLOAD) : { build/asm/main_803823FC.s.o(.bss); }
    .main_80382410 0x80382410 : AT(0x00083410) { build/asm/data/main_80382410.bin.o(.data); }
    .main_8038BFC8 0x8038BFC8 : AT(0x0008CFC8) { FILL(0x00000000); build/asm/main_8038BFC8.s.o(.text); build/asm/main_8038BFC8.s.o(.rodata); build/asm/main_8038BFC8.s.o(.data); }
    .main_8038BFC8_bss (NOLOAD) : { build/asm/main_8038BFC8.s.o(.bss); }
    .main_8038BFCC 0x8038BFCC : AT(0x0008CFCC) { build/asm/data/main_8038BFCC.bin.o(.data); }
    .main_80398F84 0x80398F84 : AT(0x00099F84) { FILL(0x00000000); build/asm/main_80398F84.s.o(.text); build/asm/main_80398F84.s.o(.rodata); build/asm/main_80398F84.s.o(.data); }
    .main_80398F84_bss (NOLOAD) : { build/asm/main_80398F84.s.o(.bss); }
    .main_80398FA4 0x80398FA4 : AT(0x00099FA4) { build/asm/data/main_80398FA4.bin.o(.data); }
    .main_803A7BC8 0x803A7BC8 : AT(0x000A8BC8) { FILL(0x00000000); build/asm/main_803A7BC8.s.o(.text); build/asm/main_803A7BC8.s.o(.rodata); build/asm/main_803A7BC8.s.o(.data); }
    .main_803A7BC8_bss (NOLOAD) : { build/asm/main_803A7BC8.s.o(.bss); }
    .main_803A7BDC 0x803A7BDC : AT(0x000A8BDC) { build/asm/data/main_803A7BDC.bin.o(.data); }
    .main_803AC508 0x803AC508 : AT(0x000AD508) { FILL(0x00000000); build/asm/main_803AC508.s.o(.text); build/asm/main_803AC508.s.o(.rodata); build/asm/main_803AC508.s.o(.data); }
    .main_803AC508_bss (NOLOAD) : { build/asm/main_803AC508.s.o(.bss); }
    .main_803AC50C 0x803AC50C : AT(0x000AD50C) { build/asm/data/main_803AC50C.bin.o(.data); }
    .main_803AF0C0 0x803AF0C0 : AT(0x000B00C0) { FILL(0x00000000); build/asm/main_803AF0C0.s.o(.text); build/asm/main_803AF0C0.s.o(.rodata); build/asm/main_803AF0C0.s.o(.data); }
    .main_803AF0C0_bss (NOLOAD) : { build/asm/main_803AF0C0.s.o(.bss); }
    .main_803AF0CC 0x803AF0CC : AT(0x000B00CC) { build/asm/data/main_803AF0CC.bin.o(.data); }
    .main_803B329C 0x803B329C : AT(0x000B429C) { FILL(0x00000000); build/asm/main_803B329C.s.o(.text); build/asm/main_803B329C.s.o(.rodata); build/asm/main_803B329C.s.o(.data); }
    .main_803B329C_bss (NOLOAD) : { build/asm/main_803B329C.s.o(.bss); }
    .main_803B32E4 0x803B32E4 : AT(0x000B42E4) { build/asm/data/main_803B32E4.bin.o(.data); }
    .main_803B39E8 0x803B39E8 : AT(0x000B49E8) { FILL(0x00000000); build/asm/main_803B39E8.s.o(.text); build/asm/main_803B39E8.s.o(.rodata); build/asm/main_803B39E8.s.o(.data); }
    .main_803B39E8_bss (NOLOAD) : { build/asm/main_803B39E8.s.o(.bss); }
    .main_803B39F4 0x803B39F4 : AT(0x000B49F4) { build/asm/data/main_803B39F4.bin.o(.data); }
    .main_803B58DC 0x803B58DC : AT(0x000B68DC) { FILL(0x00000000); build/asm/main_803B58DC.s.o(.text); build/asm/main_803B58DC.s.o(.rodata); build/asm/main_803B58DC.s.o(.data); }
    .main_803B58DC_bss (NOLOAD) : { build/asm/main_803B58DC.s.o(.bss); }
    .main_803B5908 0x803B5908 : AT(0x000B6908) { build/asm/data/main_803B5908.bin.o(.data); }
    .main_803B8E84 0x803B8E84 : AT(0x000B9E84) { FILL(0x00000000); build/asm/main_803B8E84.s.o(.text); build/asm/main_803B8E84.s.o(.rodata); build/asm/main_803B8E84.s.o(.data); }
    .main_803B8E84_bss (NOLOAD) : { build/asm/main_803B8E84.s.o(.bss); }
    .main_803B8E94 0x803B8E94 : AT(0x000B9E94) { build/asm/data/main_803B8E94.bin.o(.data); }
    .main_803BFF68 0x803BFF68 : AT(0x000C0F68) { FILL(0x00000000); build/asm/main_803BFF68.s.o(.text); build/asm/main_803BFF68.s.o(.rodata); build/asm/main_803BFF68.s.o(.data); }
    .main_803BFF68_bss (NOLOAD) : { build/asm/main_803BFF68.s.o(.bss); }
    .main_803BFF80 0x803BFF80 : AT(0x000C0F80) { build/asm/data/main_803BFF80.bin.o(.data); }
    .main_803C1ADC 0x803C1ADC : AT(0x000C2ADC) { FILL(0x00000000); build/asm/main_803C1ADC.s.o(.text); build/asm/main_803C1ADC.s.o(.rodata); build/asm/main_803C1ADC.s.o(.data); }
    .main_803C1ADC_bss (NOLOAD) : { build/asm/main_803C1ADC.s.o(.bss); }
    .main_803C1AE8 0x803C1AE8 : AT(0x000C2AE8) { build/asm/data/main_803C1AE8.bin.o(.data); }
    .main_803C3AF8 0x803C3AF8 : AT(0x000C4AF8) { FILL(0x00000000); build/asm/main_803C3AF8.s.o(.text); build/asm/main_803C3AF8.s.o(.rodata); build/asm/main_803C3AF8.s.o(.data); }
    .main_803C3AF8_bss (NOLOAD) : { build/asm/main_803C3AF8.s.o(.bss); }
    .main_803C3B00 0x803C3B00 : AT(0x000C4B00) { build/asm/data/main_803C3B00.bin.o(.data); }
    .main_803CBF44 0x803CBF44 : AT(0x000CCF44) { FILL(0x00000000); build/asm/main_803CBF44.s.o(.text); build/asm/main_803CBF44.s.o(.rodata); build/asm/main_803CBF44.s.o(.data); }
    .main_803CBF44_bss (NOLOAD) : { build/asm/main_803CBF44.s.o(.bss); }
    .main_803CC090 0x803CC090 : AT(0x000CD090) { build/asm/data/main_803CC090.bin.o(.data); }
    .main_803D1798 0x803D1798 : AT(0x000D2798) { FILL(0x00000000); build/asm/main_803D1798.s.o(.text); build/asm/main_803D1798.s.o(.rodata); build/asm/main_803D1798.s.o(.data); }
    .main_803D1798_bss (NOLOAD) : { build/asm/main_803D1798.s.o(.bss); }
    .main_803D17B8 0x803D17B8 : AT(0x000D27B8) { build/asm/data/main_803D17B8.bin.o(.data); }
    .main_803DA480 0x803DA480 : AT(0x000DB480) { FILL(0x00000000); build/asm/main_803DA480.s.o(.text); build/asm/main_803DA480.s.o(.rodata); build/asm/main_803DA480.s.o(.data); }
    .main_803DA480_bss (NOLOAD) : { build/asm/main_803DA480.s.o(.bss); }
    .main_803DA4A4 0x803DA4A4 : AT(0x000DB4A4) { build/asm/data/main_803DA4A4.bin.o(.data); }
    .main_803DB014 0x803DB014 : AT(0x000DC014) { FILL(0x00000000); build/asm/main_803DB014.s.o(.text); build/asm/main_803DB014.s.o(.rodata); build/asm/main_803DB014.s.o(.data); }
    .main_803DB014_bss (NOLOAD) : { build/asm/main_803DB014.s.o(.bss); }
    .main_803DB09C 0x803DB09C : AT(0x000DC09C) { build/asm/data/main_803DB09C.bin.o(.data); }
    .main_803E6C24 0x803E6C24 : AT(0x000E7C24) { FILL(0x00000000); build/asm/main_803E6C24.s.o(.text); build/asm/main_803E6C24.s.o(.rodata); build/asm/main_803E6C24.s.o(.data); }
    .main_803E6C24_bss (NOLOAD) : { build/asm/main_803E6C24.s.o(.bss); }
    .main_803E6C44 0x803E6C44 : AT(0x000E7C44) { build/asm/data/main_803E6C44.bin.o(.data); }
    .assets 0x80700000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
