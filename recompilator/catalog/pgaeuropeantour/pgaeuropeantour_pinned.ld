SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_8002D400 0x8002D400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_8002D400.s.o(.text); build/asm/main_8002D400.s.o(.rodata); build/asm/main_8002D400.s.o(.data); }
    .main_8002D400_bss (NOLOAD) : { build/asm/main_8002D400.s.o(.bss); }
    .main_80036280 0x80036280 : AT(0x00009E80) { FILL(0x00000000); build/asm/main_80036280.s.o(.text); build/asm/main_80036280.s.o(.rodata); build/asm/main_80036280.s.o(.data); }
    .main_80036280_bss (NOLOAD) : { build/asm/main_80036280.s.o(.bss); }
    .main_8003823C 0x8003823C : AT(0x0000BE3C) { build/asm/data/main_8003823C.bin.o(.data); }
    .main_800382E0 0x800382E0 : AT(0x0000BEE0) { FILL(0x00000000); build/asm/main_800382E0.s.o(.text); build/asm/main_800382E0.s.o(.rodata); build/asm/main_800382E0.s.o(.data); }
    .main_800382E0_bss (NOLOAD) : { build/asm/main_800382E0.s.o(.bss); }
    .main_80039604 0x80039604 : AT(0x0000D204) { build/asm/data/main_80039604.bin.o(.data); }
    .main_800398B0 0x800398B0 : AT(0x0000D4B0) { FILL(0x00000000); build/asm/main_800398B0.s.o(.text); build/asm/main_800398B0.s.o(.rodata); build/asm/main_800398B0.s.o(.data); }
    .main_800398B0_bss (NOLOAD) : { build/asm/main_800398B0.s.o(.bss); }
    .main_8003B480 0x8003B480 : AT(0x0000F080) { FILL(0x00000000); build/asm/main_8003B480.s.o(.text); build/asm/main_8003B480.s.o(.rodata); build/asm/main_8003B480.s.o(.data); }
    .main_8003B480_bss (NOLOAD) : { build/asm/main_8003B480.s.o(.bss); }
    .main_8003BE10 0x8003BE10 : AT(0x0000FA10) { FILL(0x00000000); build/asm/main_8003BE10.s.o(.text); build/asm/main_8003BE10.s.o(.rodata); build/asm/main_8003BE10.s.o(.data); }
    .main_8003BE10_bss (NOLOAD) : { build/asm/main_8003BE10.s.o(.bss); }
    .main_8003CC60 0x8003CC60 : AT(0x00010860) { FILL(0x00000000); build/asm/main_8003CC60.s.o(.text); build/asm/main_8003CC60.s.o(.rodata); build/asm/main_8003CC60.s.o(.data); }
    .main_8003CC60_bss (NOLOAD) : { build/asm/main_8003CC60.s.o(.bss); }
    .main_8003CFB0 0x8003CFB0 : AT(0x00010BB0) { build/asm/data/main_8003CFB0.bin.o(.data); }
    .main_8003D540 0x8003D540 : AT(0x00011140) { FILL(0x00000000); build/asm/main_8003D540.s.o(.text); build/asm/main_8003D540.s.o(.rodata); build/asm/main_8003D540.s.o(.data); }
    .main_8003D540_bss (NOLOAD) : { build/asm/main_8003D540.s.o(.bss); }
    .main_8003E260 0x8003E260 : AT(0x00011E60) { FILL(0x00000000); build/asm/main_8003E260.s.o(.text); build/asm/main_8003E260.s.o(.rodata); build/asm/main_8003E260.s.o(.data); }
    .main_8003E260_bss (NOLOAD) : { build/asm/main_8003E260.s.o(.bss); }
    .main_80050C7C 0x80050C7C : AT(0x0002487C) { build/asm/data/main_80050C7C.bin.o(.data); }
    .main_80050D30 0x80050D30 : AT(0x00024930) { FILL(0x00000000); build/asm/main_80050D30.s.o(.text); build/asm/main_80050D30.s.o(.rodata); build/asm/main_80050D30.s.o(.data); }
    .main_80050D30_bss (NOLOAD) : { build/asm/main_80050D30.s.o(.bss); }
    .main_8008027C 0x8008027C : AT(0x00053E7C) { build/asm/data/main_8008027C.bin.o(.data); }
    .main_800802B0 0x800802B0 : AT(0x00053EB0) { FILL(0x00000000); build/asm/main_800802B0.s.o(.text); build/asm/main_800802B0.s.o(.rodata); build/asm/main_800802B0.s.o(.data); }
    .main_800802B0_bss (NOLOAD) : { build/asm/main_800802B0.s.o(.bss); }
    .main_800906FC 0x800906FC : AT(0x000642FC) { build/asm/data/main_800906FC.bin.o(.data); }
    .main_800907E0 0x800907E0 : AT(0x000643E0) { FILL(0x00000000); build/asm/main_800907E0.s.o(.text); build/asm/main_800907E0.s.o(.rodata); build/asm/main_800907E0.s.o(.data); }
    .main_800907E0_bss (NOLOAD) : { build/asm/main_800907E0.s.o(.bss); }
    .main_80091854 0x80091854 : AT(0x00065454) { build/asm/data/main_80091854.bin.o(.data); }
    .main_80091B90 0x80091B90 : AT(0x00065790) { FILL(0x00000000); build/asm/main_80091B90.s.o(.text); build/asm/main_80091B90.s.o(.rodata); build/asm/main_80091B90.s.o(.data); }
    .main_80091B90_bss (NOLOAD) : { build/asm/main_80091B90.s.o(.bss); }
    .main_800C7540 0x800C7540 : AT(0x0009B140) { build/asm/data/main_800C7540.bin.o(.data); }
    .main_800C75B0 0x800C75B0 : AT(0x0009B1B0) { FILL(0x00000000); build/asm/main_800C75B0.s.o(.text); build/asm/main_800C75B0.s.o(.rodata); build/asm/main_800C75B0.s.o(.data); }
    .main_800C75B0_bss (NOLOAD) : { build/asm/main_800C75B0.s.o(.bss); }
    .main_800D9628 0x800D9628 : AT(0x000AD228) { build/asm/data/main_800D9628.bin.o(.data); }
    .main_800DA4A0 0x800DA4A0 : AT(0x000AE0A0) { FILL(0x00000000); build/asm/main_800DA4A0.s.o(.text); build/asm/main_800DA4A0.s.o(.rodata); build/asm/main_800DA4A0.s.o(.data); }
    .main_800DA4A0_bss (NOLOAD) : { build/asm/main_800DA4A0.s.o(.bss); }
    .main_800DC9C0 0x800DC9C0 : AT(0x000B05C0) { build/asm/data/main_800DC9C0.bin.o(.data); }
    .main_800E5B88 0x800E5B88 : AT(0x000B9788) { FILL(0x00000000); build/asm/main_800E5B88.s.o(.text); build/asm/main_800E5B88.s.o(.rodata); build/asm/main_800E5B88.s.o(.data); }
    .main_800E5B88_bss (NOLOAD) : { build/asm/main_800E5B88.s.o(.bss); }
    .main_800E5E10 0x800E5E10 : AT(0x000B9A10) { build/asm/data/main_800E5E10.bin.o(.data); }
    .main_800E622C 0x800E622C : AT(0x000B9E2C) { FILL(0x00000000); build/asm/main_800E622C.s.o(.text); build/asm/main_800E622C.s.o(.rodata); build/asm/main_800E622C.s.o(.data); }
    .main_800E622C_bss (NOLOAD) : { build/asm/main_800E622C.s.o(.bss); }
    .main_800E6320 0x800E6320 : AT(0x000B9F20) { build/asm/data/main_800E6320.bin.o(.data); }
    .main_800E8E24 0x800E8E24 : AT(0x000BCA24) { FILL(0x00000000); build/asm/main_800E8E24.s.o(.text); build/asm/main_800E8E24.s.o(.rodata); build/asm/main_800E8E24.s.o(.data); }
    .main_800E8E24_bss (NOLOAD) : { build/asm/main_800E8E24.s.o(.bss); }
    .main_800E92F4 0x800E92F4 : AT(0x000BCEF4) { build/asm/data/main_800E92F4.bin.o(.data); }
    .main_800ED28C 0x800ED28C : AT(0x000C0E8C) { FILL(0x00000000); build/asm/main_800ED28C.s.o(.text); build/asm/main_800ED28C.s.o(.rodata); build/asm/main_800ED28C.s.o(.data); }
    .main_800ED28C_bss (NOLOAD) : { build/asm/main_800ED28C.s.o(.bss); }
    .main_800F42EC 0x800F42EC : AT(0x000C7EEC) { build/asm/data/main_800F42EC.bin.o(.data); }
    .main_800F4344 0x800F4344 : AT(0x000C7F44) { FILL(0x00000000); build/asm/main_800F4344.s.o(.text); build/asm/main_800F4344.s.o(.rodata); build/asm/main_800F4344.s.o(.data); }
    .main_800F4344_bss (NOLOAD) : { build/asm/main_800F4344.s.o(.bss); }
    .main_800F4594 0x800F4594 : AT(0x000C8194) { build/asm/data/main_800F4594.bin.o(.data); }
    .main_800F477C 0x800F477C : AT(0x000C837C) { FILL(0x00000000); build/asm/main_800F477C.s.o(.text); build/asm/main_800F477C.s.o(.rodata); build/asm/main_800F477C.s.o(.data); }
    .main_800F477C_bss (NOLOAD) : { build/asm/main_800F477C.s.o(.bss); }
    .main_800F4784 0x800F4784 : AT(0x000C8384) { build/asm/data/main_800F4784.bin.o(.data); }
    .main_800F48B4 0x800F48B4 : AT(0x000C84B4) { FILL(0x00000000); build/asm/main_800F48B4.s.o(.text); build/asm/main_800F48B4.s.o(.rodata); build/asm/main_800F48B4.s.o(.data); }
    .main_800F48B4_bss (NOLOAD) : { build/asm/main_800F48B4.s.o(.bss); }
    .main_800F5864 0x800F5864 : AT(0x000C9464) { build/asm/data/main_800F5864.bin.o(.data); }
    .main_800F5BEC 0x800F5BEC : AT(0x000C97EC) { FILL(0x00000000); build/asm/main_800F5BEC.s.o(.text); build/asm/main_800F5BEC.s.o(.rodata); build/asm/main_800F5BEC.s.o(.data); }
    .main_800F5BEC_bss (NOLOAD) : { build/asm/main_800F5BEC.s.o(.bss); }
    .main_800F5E8C 0x800F5E8C : AT(0x000C9A8C) { build/asm/data/main_800F5E8C.bin.o(.data); }
    .main_800F5EE4 0x800F5EE4 : AT(0x000C9AE4) { FILL(0x00000000); build/asm/main_800F5EE4.s.o(.text); build/asm/main_800F5EE4.s.o(.rodata); build/asm/main_800F5EE4.s.o(.data); }
    .main_800F5EE4_bss (NOLOAD) : { build/asm/main_800F5EE4.s.o(.bss); }
    .main_800F6AB4 0x800F6AB4 : AT(0x000CA6B4) { build/asm/data/main_800F6AB4.bin.o(.data); }
    .main_800F6D7C 0x800F6D7C : AT(0x000CA97C) { FILL(0x00000000); build/asm/main_800F6D7C.s.o(.text); build/asm/main_800F6D7C.s.o(.rodata); build/asm/main_800F6D7C.s.o(.data); }
    .main_800F6D7C_bss (NOLOAD) : { build/asm/main_800F6D7C.s.o(.bss); }
    .main_800F7E34 0x800F7E34 : AT(0x000CBA34) { build/asm/data/main_800F7E34.bin.o(.data); }
    .main_800F8274 0x800F8274 : AT(0x000CBE74) { FILL(0x00000000); build/asm/main_800F8274.s.o(.text); build/asm/main_800F8274.s.o(.rodata); build/asm/main_800F8274.s.o(.data); }
    .main_800F8274_bss (NOLOAD) : { build/asm/main_800F8274.s.o(.bss); }
    .main_800FB5B4 0x800FB5B4 : AT(0x000CF1B4) { build/asm/data/main_800FB5B4.bin.o(.data); }
    .main_800FB684 0x800FB684 : AT(0x000CF284) { FILL(0x00000000); build/asm/main_800FB684.s.o(.text); build/asm/main_800FB684.s.o(.rodata); build/asm/main_800FB684.s.o(.data); }
    .main_800FB684_bss (NOLOAD) : { build/asm/main_800FB684.s.o(.bss); }
    .main_800FB69C 0x800FB69C : AT(0x000CF29C) { build/asm/data/main_800FB69C.bin.o(.data); }
    .main_800FB8DC 0x800FB8DC : AT(0x000CF4DC) { FILL(0x00000000); build/asm/main_800FB8DC.s.o(.text); build/asm/main_800FB8DC.s.o(.rodata); build/asm/main_800FB8DC.s.o(.data); }
    .main_800FB8DC_bss (NOLOAD) : { build/asm/main_800FB8DC.s.o(.bss); }
    .main_800FB99C 0x800FB99C : AT(0x000CF59C) { build/asm/data/main_800FB99C.bin.o(.data); }
    .main_800FB9DC 0x800FB9DC : AT(0x000CF5DC) { FILL(0x00000000); build/asm/main_800FB9DC.s.o(.text); build/asm/main_800FB9DC.s.o(.rodata); build/asm/main_800FB9DC.s.o(.data); }
    .main_800FB9DC_bss (NOLOAD) : { build/asm/main_800FB9DC.s.o(.bss); }
    .main_800FBF04 0x800FBF04 : AT(0x000CFB04) { build/asm/data/main_800FBF04.bin.o(.data); }
    .main_800FC2F4 0x800FC2F4 : AT(0x000CFEF4) { FILL(0x00000000); build/asm/main_800FC2F4.s.o(.text); build/asm/main_800FC2F4.s.o(.rodata); build/asm/main_800FC2F4.s.o(.data); }
    .main_800FC2F4_bss (NOLOAD) : { build/asm/main_800FC2F4.s.o(.bss); }
    .main_800FC6B4 0x800FC6B4 : AT(0x000D02B4) { build/asm/data/main_800FC6B4.bin.o(.data); }
    .main_800FC904 0x800FC904 : AT(0x000D0504) { FILL(0x00000000); build/asm/main_800FC904.s.o(.text); build/asm/main_800FC904.s.o(.rodata); build/asm/main_800FC904.s.o(.data); }
    .main_800FC904_bss (NOLOAD) : { build/asm/main_800FC904.s.o(.bss); }
    .main_800FC944 0x800FC944 : AT(0x000D0544) { build/asm/data/main_800FC944.bin.o(.data); }
    .main_800FCD7C 0x800FCD7C : AT(0x000D097C) { FILL(0x00000000); build/asm/main_800FCD7C.s.o(.text); build/asm/main_800FCD7C.s.o(.rodata); build/asm/main_800FCD7C.s.o(.data); }
    .main_800FCD7C_bss (NOLOAD) : { build/asm/main_800FCD7C.s.o(.bss); }
    .main_800FE1CC 0x800FE1CC : AT(0x000D1DCC) { build/asm/data/main_800FE1CC.bin.o(.data); }
    .main_800FE3BC 0x800FE3BC : AT(0x000D1FBC) { FILL(0x00000000); build/asm/main_800FE3BC.s.o(.text); build/asm/main_800FE3BC.s.o(.rodata); build/asm/main_800FE3BC.s.o(.data); }
    .main_800FE3BC_bss (NOLOAD) : { build/asm/main_800FE3BC.s.o(.bss); }
    .main_800FEBC4 0x800FEBC4 : AT(0x000D27C4) { build/asm/data/main_800FEBC4.bin.o(.data); }
    .main_800FEFF4 0x800FEFF4 : AT(0x000D2BF4) { FILL(0x00000000); build/asm/main_800FEFF4.s.o(.text); build/asm/main_800FEFF4.s.o(.rodata); build/asm/main_800FEFF4.s.o(.data); }
    .main_800FEFF4_bss (NOLOAD) : { build/asm/main_800FEFF4.s.o(.bss); }
    .main_80108F3C 0x80108F3C : AT(0x000DCB3C) { build/asm/data/main_80108F3C.bin.o(.data); }
    .main_80112B8C 0x80112B8C : AT(0x000E678C) { FILL(0x00000000); build/asm/main_80112B8C.s.o(.text); build/asm/main_80112B8C.s.o(.rodata); build/asm/main_80112B8C.s.o(.data); }
    .main_80112B8C_bss (NOLOAD) : { build/asm/main_80112B8C.s.o(.bss); }
    .main_80113190 0x80113190 : AT(0x000E6D90) { build/asm/data/main_80113190.bin.o(.data); }
    .main_801132D8 0x801132D8 : AT(0x000E6ED8) { FILL(0x00000000); build/asm/main_801132D8.s.o(.text); build/asm/main_801132D8.s.o(.rodata); build/asm/main_801132D8.s.o(.data); }
    .main_801132D8_bss (NOLOAD) : { build/asm/main_801132D8.s.o(.bss); }
    .main_80113554 0x80113554 : AT(0x000E7154) { build/asm/data/main_80113554.bin.o(.data); }
    .main_8011357C 0x8011357C : AT(0x000E717C) { FILL(0x00000000); build/asm/main_8011357C.s.o(.text); build/asm/main_8011357C.s.o(.rodata); build/asm/main_8011357C.s.o(.data); }
    .main_8011357C_bss (NOLOAD) : { build/asm/main_8011357C.s.o(.bss); }
    .main_80113CD8 0x80113CD8 : AT(0x000E78D8) { build/asm/data/main_80113CD8.bin.o(.data); }
    .main_80113CF4 0x80113CF4 : AT(0x000E78F4) { FILL(0x00000000); build/asm/main_80113CF4.s.o(.text); build/asm/main_80113CF4.s.o(.rodata); build/asm/main_80113CF4.s.o(.data); }
    .main_80113CF4_bss (NOLOAD) : { build/asm/main_80113CF4.s.o(.bss); }
    .main_80114164 0x80114164 : AT(0x000E7D64) { build/asm/data/main_80114164.bin.o(.data); }
    .main_8011FC44 0x8011FC44 : AT(0x000F3844) { FILL(0x00000000); build/asm/main_8011FC44.s.o(.text); build/asm/main_8011FC44.s.o(.rodata); build/asm/main_8011FC44.s.o(.data); }
    .main_8011FC44_bss (NOLOAD) : { build/asm/main_8011FC44.s.o(.bss); }
    .main_80120044 0x80120044 : AT(0x000F3C44) { build/asm/data/main_80120044.bin.o(.data); }
    .main_8012274C 0x8012274C : AT(0x000F634C) { FILL(0x00000000); build/asm/main_8012274C.s.o(.text); build/asm/main_8012274C.s.o(.rodata); build/asm/main_8012274C.s.o(.data); }
    .main_8012274C_bss (NOLOAD) : { build/asm/main_8012274C.s.o(.bss); }
    .main_80124594 0x80124594 : AT(0x000F8194) { build/asm/data/main_80124594.bin.o(.data); }
    .main_80124694 0x80124694 : AT(0x000F8294) { FILL(0x00000000); build/asm/main_80124694.s.o(.text); build/asm/main_80124694.s.o(.rodata); build/asm/main_80124694.s.o(.data); }
    .main_80124694_bss (NOLOAD) : { build/asm/main_80124694.s.o(.bss); }
    .main_80124F6C 0x80124F6C : AT(0x000F8B6C) { build/asm/data/main_80124F6C.bin.o(.data); }
    .main_80125E1C 0x80125E1C : AT(0x000F9A1C) { FILL(0x00000000); build/asm/main_80125E1C.s.o(.text); build/asm/main_80125E1C.s.o(.rodata); build/asm/main_80125E1C.s.o(.data); }
    .main_80125E1C_bss (NOLOAD) : { build/asm/main_80125E1C.s.o(.bss); }
    .main_801266D4 0x801266D4 : AT(0x000FA2D4) { build/asm/data/main_801266D4.bin.o(.data); }
    .main_8012711C 0x8012711C : AT(0x000FAD1C) { FILL(0x00000000); build/asm/main_8012711C.s.o(.text); build/asm/main_8012711C.s.o(.rodata); build/asm/main_8012711C.s.o(.data); }
    .main_8012711C_bss (NOLOAD) : { build/asm/main_8012711C.s.o(.bss); }
    .main_80127124 0x80127124 : AT(0x000FAD24) { build/asm/data/main_80127124.bin.o(.data); }
    .main_801276F4 0x801276F4 : AT(0x000FB2F4) { FILL(0x00000000); build/asm/main_801276F4.s.o(.text); build/asm/main_801276F4.s.o(.rodata); build/asm/main_801276F4.s.o(.data); }
    .main_801276F4_bss (NOLOAD) : { build/asm/main_801276F4.s.o(.bss); }
    .main_80128C3C 0x80128C3C : AT(0x000FC83C) { build/asm/data/main_80128C3C.bin.o(.data); }
    .main_80128C94 0x80128C94 : AT(0x000FC894) { FILL(0x00000000); build/asm/main_80128C94.s.o(.text); build/asm/main_80128C94.s.o(.rodata); build/asm/main_80128C94.s.o(.data); }
    .main_80128C94_bss (NOLOAD) : { build/asm/main_80128C94.s.o(.bss); }
    .main_8012C03C 0x8012C03C : AT(0x000FFC3C) { build/asm/data/main_8012C03C.bin.o(.data); }
    .main_8012C2F4 0x8012C2F4 : AT(0x000FFEF4) { FILL(0x00000000); build/asm/main_8012C2F4.s.o(.text); build/asm/main_8012C2F4.s.o(.rodata); build/asm/main_8012C2F4.s.o(.data); }
    .main_8012C2F4_bss (NOLOAD) : { build/asm/main_8012C2F4.s.o(.bss); }
    .main_8012C324 0x8012C324 : AT(0x000FFF24) { build/asm/data/main_8012C324.bin.o(.data); }
    .main_8012CB84 0x8012CB84 : AT(0x00100784) { FILL(0x00000000); build/asm/main_8012CB84.s.o(.text); build/asm/main_8012CB84.s.o(.rodata); build/asm/main_8012CB84.s.o(.data); }
    .main_8012CB84_bss (NOLOAD) : { build/asm/main_8012CB84.s.o(.bss); }
    .main_8012CD84 0x8012CD84 : AT(0x00100984) { build/asm/data/main_8012CD84.bin.o(.data); }
    .main_8012CDEC 0x8012CDEC : AT(0x001009EC) { FILL(0x00000000); build/asm/main_8012CDEC.s.o(.text); build/asm/main_8012CDEC.s.o(.rodata); build/asm/main_8012CDEC.s.o(.data); }
    .main_8012CDEC_bss (NOLOAD) : { build/asm/main_8012CDEC.s.o(.bss); }
    .main_8012D124 0x8012D124 : AT(0x00100D24) { build/asm/data/main_8012D124.bin.o(.data); }
    .main_8012D17C 0x8012D17C : AT(0x00100D7C) { FILL(0x00000000); build/asm/main_8012D17C.s.o(.text); build/asm/main_8012D17C.s.o(.rodata); build/asm/main_8012D17C.s.o(.data); }
    .main_8012D17C_bss (NOLOAD) : { build/asm/main_8012D17C.s.o(.bss); }
    .main_8012D2DC 0x8012D2DC : AT(0x00100EDC) { build/asm/data/main_8012D2DC.bin.o(.data); }
    .main_8012D334 0x8012D334 : AT(0x00100F34) { FILL(0x00000000); build/asm/main_8012D334.s.o(.text); build/asm/main_8012D334.s.o(.rodata); build/asm/main_8012D334.s.o(.data); }
    .main_8012D334_bss (NOLOAD) : { build/asm/main_8012D334.s.o(.bss); }
    .assets 0x8042D400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
