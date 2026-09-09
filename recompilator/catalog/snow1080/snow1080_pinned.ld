SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80100400 0x80100400 : AT(0x00101000) { build/asm/data/main_80100400.bin.o(.data); }
    .main_8010060C 0x8010060C : AT(0x0010120C) { FILL(0x00000000); build/asm/main_8010060C.s.o(.text); build/asm/main_8010060C.s.o(.rodata); build/asm/main_8010060C.s.o(.data); }
    .main_8010060C_bss (NOLOAD) : { build/asm/main_8010060C.s.o(.bss); }
    .main_80100660 0x80100660 : AT(0x00101260) { build/asm/data/main_80100660.bin.o(.data); }
    .main_80100874 0x80100874 : AT(0x00101474) { FILL(0x00000000); build/asm/main_80100874.s.o(.text); build/asm/main_80100874.s.o(.rodata); build/asm/main_80100874.s.o(.data); }
    .main_80100874_bss (NOLOAD) : { build/asm/main_80100874.s.o(.bss); }
    .main_80100880 0x80100880 : AT(0x00101480) { build/asm/data/main_80100880.bin.o(.data); }
    .main_8010098C 0x8010098C : AT(0x0010158C) { FILL(0x00000000); build/asm/main_8010098C.s.o(.text); build/asm/main_8010098C.s.o(.rodata); build/asm/main_8010098C.s.o(.data); }
    .main_8010098C_bss (NOLOAD) : { build/asm/main_8010098C.s.o(.bss); }
    .main_80100998 0x80100998 : AT(0x00101598) { build/asm/data/main_80100998.bin.o(.data); }
    .main_80100A88 0x80100A88 : AT(0x00101688) { FILL(0x00000000); build/asm/main_80100A88.s.o(.text); build/asm/main_80100A88.s.o(.rodata); build/asm/main_80100A88.s.o(.data); }
    .main_80100A88_bss (NOLOAD) : { build/asm/main_80100A88.s.o(.bss); }
    .main_80100A98 0x80100A98 : AT(0x00101698) { build/asm/data/main_80100A98.bin.o(.data); }
    .main_80100BC4 0x80100BC4 : AT(0x001017C4) { FILL(0x00000000); build/asm/main_80100BC4.s.o(.text); build/asm/main_80100BC4.s.o(.rodata); build/asm/main_80100BC4.s.o(.data); }
    .main_80100BC4_bss (NOLOAD) : { build/asm/main_80100BC4.s.o(.bss); }
    .main_80100BD4 0x80100BD4 : AT(0x001017D4) { build/asm/data/main_80100BD4.bin.o(.data); }
    .main_801014B4 0x801014B4 : AT(0x001020B4) { FILL(0x00000000); build/asm/main_801014B4.s.o(.text); build/asm/main_801014B4.s.o(.rodata); build/asm/main_801014B4.s.o(.data); }
    .main_801014B4_bss (NOLOAD) : { build/asm/main_801014B4.s.o(.bss); }
    .main_801014C0 0x801014C0 : AT(0x001020C0) { build/asm/data/main_801014C0.bin.o(.data); }
    .main_801014CC 0x801014CC : AT(0x001020CC) { FILL(0x00000000); build/asm/main_801014CC.s.o(.text); build/asm/main_801014CC.s.o(.rodata); build/asm/main_801014CC.s.o(.data); }
    .main_801014CC_bss (NOLOAD) : { build/asm/main_801014CC.s.o(.bss); }
    .main_801014E8 0x801014E8 : AT(0x001020E8) { build/asm/data/main_801014E8.bin.o(.data); }
    .main_801016AC 0x801016AC : AT(0x001022AC) { FILL(0x00000000); build/asm/main_801016AC.s.o(.text); build/asm/main_801016AC.s.o(.rodata); build/asm/main_801016AC.s.o(.data); }
    .main_801016AC_bss (NOLOAD) : { build/asm/main_801016AC.s.o(.bss); }
    .main_801016BC 0x801016BC : AT(0x001022BC) { build/asm/data/main_801016BC.bin.o(.data); }
    .main_80101814 0x80101814 : AT(0x00102414) { FILL(0x00000000); build/asm/main_80101814.s.o(.text); build/asm/main_80101814.s.o(.rodata); build/asm/main_80101814.s.o(.data); }
    .main_80101814_bss (NOLOAD) : { build/asm/main_80101814.s.o(.bss); }
    .main_80101860 0x80101860 : AT(0x00102460) { build/asm/data/main_80101860.bin.o(.data); }
    .main_80101894 0x80101894 : AT(0x00102494) { FILL(0x00000000); build/asm/main_80101894.s.o(.text); build/asm/main_80101894.s.o(.rodata); build/asm/main_80101894.s.o(.data); }
    .main_80101894_bss (NOLOAD) : { build/asm/main_80101894.s.o(.bss); }
    .main_8010189C 0x8010189C : AT(0x0010249C) { build/asm/data/main_8010189C.bin.o(.data); }
    .main_80101CB0 0x80101CB0 : AT(0x001028B0) { FILL(0x00000000); build/asm/main_80101CB0.s.o(.text); build/asm/main_80101CB0.s.o(.rodata); build/asm/main_80101CB0.s.o(.data); }
    .main_80101CB0_bss (NOLOAD) : { build/asm/main_80101CB0.s.o(.bss); }
    .main_80101CF0 0x80101CF0 : AT(0x001028F0) { build/asm/data/main_80101CF0.bin.o(.data); }
    .main_801021D0 0x801021D0 : AT(0x00102DD0) { FILL(0x00000000); build/asm/main_801021D0.s.o(.text); build/asm/main_801021D0.s.o(.rodata); build/asm/main_801021D0.s.o(.data); }
    .main_801021D0_bss (NOLOAD) : { build/asm/main_801021D0.s.o(.bss); }
    .main_801022C8 0x801022C8 : AT(0x00102EC8) { build/asm/data/main_801022C8.bin.o(.data); }
    .main_8010275C 0x8010275C : AT(0x0010335C) { FILL(0x00000000); build/asm/main_8010275C.s.o(.text); build/asm/main_8010275C.s.o(.rodata); build/asm/main_8010275C.s.o(.data); }
    .main_8010275C_bss (NOLOAD) : { build/asm/main_8010275C.s.o(.bss); }
    .main_801027E0 0x801027E0 : AT(0x001033E0) { build/asm/data/main_801027E0.bin.o(.data); }
    .main_80102DB0 0x80102DB0 : AT(0x001039B0) { FILL(0x00000000); build/asm/main_80102DB0.s.o(.text); build/asm/main_80102DB0.s.o(.rodata); build/asm/main_80102DB0.s.o(.data); }
    .main_80102DB0_bss (NOLOAD) : { build/asm/main_80102DB0.s.o(.bss); }
    .main_80102E10 0x80102E10 : AT(0x00103A10) { build/asm/data/main_80102E10.bin.o(.data); }
    .main_80102EB4 0x80102EB4 : AT(0x00103AB4) { FILL(0x00000000); build/asm/main_80102EB4.s.o(.text); build/asm/main_80102EB4.s.o(.rodata); build/asm/main_80102EB4.s.o(.data); }
    .main_80102EB4_bss (NOLOAD) : { build/asm/main_80102EB4.s.o(.bss); }
    .main_80102EE0 0x80102EE0 : AT(0x00103AE0) { build/asm/data/main_80102EE0.bin.o(.data); }
    .main_80102F78 0x80102F78 : AT(0x00103B78) { FILL(0x00000000); build/asm/main_80102F78.s.o(.text); build/asm/main_80102F78.s.o(.rodata); build/asm/main_80102F78.s.o(.data); }
    .main_80102F78_bss (NOLOAD) : { build/asm/main_80102F78.s.o(.bss); }
    .main_80102FA8 0x80102FA8 : AT(0x00103BA8) { build/asm/data/main_80102FA8.bin.o(.data); }
    .main_801031D0 0x801031D0 : AT(0x00103DD0) { FILL(0x00000000); build/asm/main_801031D0.s.o(.text); build/asm/main_801031D0.s.o(.rodata); build/asm/main_801031D0.s.o(.data); }
    .main_801031D0_bss (NOLOAD) : { build/asm/main_801031D0.s.o(.bss); }
    .main_801031F0 0x801031F0 : AT(0x00103DF0) { build/asm/data/main_801031F0.bin.o(.data); }
    .main_80105120 0x80105120 : AT(0x00105D20) { FILL(0x00000000); build/asm/main_80105120.s.o(.text); build/asm/main_80105120.s.o(.rodata); build/asm/main_80105120.s.o(.data); }
    .main_80105120_bss (NOLOAD) : { build/asm/main_80105120.s.o(.bss); }
    .main_801051E0 0x801051E0 : AT(0x00105DE0) { build/asm/data/main_801051E0.bin.o(.data); }
    .main_801053D0 0x801053D0 : AT(0x00105FD0) { FILL(0x00000000); build/asm/main_801053D0.s.o(.text); build/asm/main_801053D0.s.o(.rodata); build/asm/main_801053D0.s.o(.data); }
    .main_801053D0_bss (NOLOAD) : { build/asm/main_801053D0.s.o(.bss); }
    .main_80105400 0x80105400 : AT(0x00106000) { build/asm/data/main_80105400.bin.o(.data); }
    .main_80106640 0x80106640 : AT(0x00107240) { FILL(0x00000000); build/asm/main_80106640.s.o(.text); build/asm/main_80106640.s.o(.rodata); build/asm/main_80106640.s.o(.data); }
    .main_80106640_bss (NOLOAD) : { build/asm/main_80106640.s.o(.bss); }
    .main_80106650 0x80106650 : AT(0x00107250) { build/asm/data/main_80106650.bin.o(.data); }
    .main_801066B0 0x801066B0 : AT(0x001072B0) { FILL(0x00000000); build/asm/main_801066B0.s.o(.text); build/asm/main_801066B0.s.o(.rodata); build/asm/main_801066B0.s.o(.data); }
    .main_801066B0_bss (NOLOAD) : { build/asm/main_801066B0.s.o(.bss); }
    .main_801066D0 0x801066D0 : AT(0x001072D0) { build/asm/data/main_801066D0.bin.o(.data); }
    .main_801069B0 0x801069B0 : AT(0x001075B0) { FILL(0x00000000); build/asm/main_801069B0.s.o(.text); build/asm/main_801069B0.s.o(.rodata); build/asm/main_801069B0.s.o(.data); }
    .main_801069B0_bss (NOLOAD) : { build/asm/main_801069B0.s.o(.bss); }
    .main_801069BC 0x801069BC : AT(0x001075BC) { build/asm/data/main_801069BC.bin.o(.data); }
    .main_80106B20 0x80106B20 : AT(0x00107720) { FILL(0x00000000); build/asm/main_80106B20.s.o(.text); build/asm/main_80106B20.s.o(.rodata); build/asm/main_80106B20.s.o(.data); }
    .main_80106B20_bss (NOLOAD) : { build/asm/main_80106B20.s.o(.bss); }
    .main_80106B90 0x80106B90 : AT(0x00107790) { build/asm/data/main_80106B90.bin.o(.data); }
    .main_80107058 0x80107058 : AT(0x00107C58) { FILL(0x00000000); build/asm/main_80107058.s.o(.text); build/asm/main_80107058.s.o(.rodata); build/asm/main_80107058.s.o(.data); }
    .main_80107058_bss (NOLOAD) : { build/asm/main_80107058.s.o(.bss); }
    .main_80107064 0x80107064 : AT(0x00107C64) { build/asm/data/main_80107064.bin.o(.data); }
    .main_801073F8 0x801073F8 : AT(0x00107FF8) { FILL(0x00000000); build/asm/main_801073F8.s.o(.text); build/asm/main_801073F8.s.o(.rodata); build/asm/main_801073F8.s.o(.data); }
    .main_801073F8_bss (NOLOAD) : { build/asm/main_801073F8.s.o(.bss); }
    .main_801074A0 0x801074A0 : AT(0x001080A0) { build/asm/data/main_801074A0.bin.o(.data); }
    .main_80108824 0x80108824 : AT(0x00109424) { FILL(0x00000000); build/asm/main_80108824.s.o(.text); build/asm/main_80108824.s.o(.rodata); build/asm/main_80108824.s.o(.data); }
    .main_80108824_bss (NOLOAD) : { build/asm/main_80108824.s.o(.bss); }
    .main_80108830 0x80108830 : AT(0x00109430) { build/asm/data/main_80108830.bin.o(.data); }
    .main_80108E08 0x80108E08 : AT(0x00109A08) { FILL(0x00000000); build/asm/main_80108E08.s.o(.text); build/asm/main_80108E08.s.o(.rodata); build/asm/main_80108E08.s.o(.data); }
    .main_80108E08_bss (NOLOAD) : { build/asm/main_80108E08.s.o(.bss); }
    .main_80108E38 0x80108E38 : AT(0x00109A38) { build/asm/data/main_80108E38.bin.o(.data); }
    .main_80109000 0x80109000 : AT(0x00109C00) { FILL(0x00000000); build/asm/main_80109000.s.o(.text); build/asm/main_80109000.s.o(.rodata); build/asm/main_80109000.s.o(.data); }
    .main_80109000_bss (NOLOAD) : { build/asm/main_80109000.s.o(.bss); }
    .main_80109030 0x80109030 : AT(0x00109C30) { build/asm/data/main_80109030.bin.o(.data); }
    .main_801096B0 0x801096B0 : AT(0x0010A2B0) { FILL(0x00000000); build/asm/main_801096B0.s.o(.text); build/asm/main_801096B0.s.o(.rodata); build/asm/main_801096B0.s.o(.data); }
    .main_801096B0_bss (NOLOAD) : { build/asm/main_801096B0.s.o(.bss); }
    .main_80109714 0x80109714 : AT(0x0010A314) { build/asm/data/main_80109714.bin.o(.data); }
    .main_80109C30 0x80109C30 : AT(0x0010A830) { FILL(0x00000000); build/asm/main_80109C30.s.o(.text); build/asm/main_80109C30.s.o(.rodata); build/asm/main_80109C30.s.o(.data); }
    .main_80109C30_bss (NOLOAD) : { build/asm/main_80109C30.s.o(.bss); }
    .main_80109C50 0x80109C50 : AT(0x0010A850) { build/asm/data/main_80109C50.bin.o(.data); }
    .main_80109EA0 0x80109EA0 : AT(0x0010AAA0) { FILL(0x00000000); build/asm/main_80109EA0.s.o(.text); build/asm/main_80109EA0.s.o(.rodata); build/asm/main_80109EA0.s.o(.data); }
    .main_80109EA0_bss (NOLOAD) : { build/asm/main_80109EA0.s.o(.bss); }
    .main_80109EB0 0x80109EB0 : AT(0x0010AAB0) { build/asm/data/main_80109EB0.bin.o(.data); }
    .main_8010A040 0x8010A040 : AT(0x0010AC40) { FILL(0x00000000); build/asm/main_8010A040.s.o(.text); build/asm/main_8010A040.s.o(.rodata); build/asm/main_8010A040.s.o(.data); }
    .main_8010A040_bss (NOLOAD) : { build/asm/main_8010A040.s.o(.bss); }
    .main_8010A090 0x8010A090 : AT(0x0010AC90) { build/asm/data/main_8010A090.bin.o(.data); }
    .main_8010A0E0 0x8010A0E0 : AT(0x0010ACE0) { FILL(0x00000000); build/asm/main_8010A0E0.s.o(.text); build/asm/main_8010A0E0.s.o(.rodata); build/asm/main_8010A0E0.s.o(.data); }
    .main_8010A0E0_bss (NOLOAD) : { build/asm/main_8010A0E0.s.o(.bss); }
    .main_8010A110 0x8010A110 : AT(0x0010AD10) { build/asm/data/main_8010A110.bin.o(.data); }
    .main_8010A260 0x8010A260 : AT(0x0010AE60) { FILL(0x00000000); build/asm/main_8010A260.s.o(.text); build/asm/main_8010A260.s.o(.rodata); build/asm/main_8010A260.s.o(.data); }
    .main_8010A260_bss (NOLOAD) : { build/asm/main_8010A260.s.o(.bss); }
    .main_8010A2DC 0x8010A2DC : AT(0x0010AEDC) { build/asm/data/main_8010A2DC.bin.o(.data); }
    .main_8010C74C 0x8010C74C : AT(0x0010D34C) { FILL(0x00000000); build/asm/main_8010C74C.s.o(.text); build/asm/main_8010C74C.s.o(.rodata); build/asm/main_8010C74C.s.o(.data); }
    .main_8010C74C_bss (NOLOAD) : { build/asm/main_8010C74C.s.o(.bss); }
    .main_8010C834 0x8010C834 : AT(0x0010D434) { build/asm/data/main_8010C834.bin.o(.data); }
    .main_8010CBE8 0x8010CBE8 : AT(0x0010D7E8) { FILL(0x00000000); build/asm/main_8010CBE8.s.o(.text); build/asm/main_8010CBE8.s.o(.rodata); build/asm/main_8010CBE8.s.o(.data); }
    .main_8010CBE8_bss (NOLOAD) : { build/asm/main_8010CBE8.s.o(.bss); }
    .main_8010CC60 0x8010CC60 : AT(0x0010D860) { build/asm/data/main_8010CC60.bin.o(.data); }
    .main_8010DD6C 0x8010DD6C : AT(0x0010E96C) { FILL(0x00000000); build/asm/main_8010DD6C.s.o(.text); build/asm/main_8010DD6C.s.o(.rodata); build/asm/main_8010DD6C.s.o(.data); }
    .main_8010DD6C_bss (NOLOAD) : { build/asm/main_8010DD6C.s.o(.bss); }
    .main_8010DDA0 0x8010DDA0 : AT(0x0010E9A0) { build/asm/data/main_8010DDA0.bin.o(.data); }
    .main_80117620 0x80117620 : AT(0x00118220) { FILL(0x00000000); build/asm/main_80117620.s.o(.text); build/asm/main_80117620.s.o(.rodata); build/asm/main_80117620.s.o(.data); }
    .main_80117620_bss (NOLOAD) : { build/asm/main_80117620.s.o(.bss); }
    .main_80117640 0x80117640 : AT(0x00118240) { build/asm/data/main_80117640.bin.o(.data); }
    .main_8011AF44 0x8011AF44 : AT(0x0011BB44) { FILL(0x00000000); build/asm/main_8011AF44.s.o(.text); build/asm/main_8011AF44.s.o(.rodata); build/asm/main_8011AF44.s.o(.data); }
    .main_8011AF44_bss (NOLOAD) : { build/asm/main_8011AF44.s.o(.bss); }
    .main_8011AF48 0x8011AF48 : AT(0x0011BB48) { build/asm/data/main_8011AF48.bin.o(.data); }
    .main_8011B364 0x8011B364 : AT(0x0011BF64) { FILL(0x00000000); build/asm/main_8011B364.s.o(.text); build/asm/main_8011B364.s.o(.rodata); build/asm/main_8011B364.s.o(.data); }
    .main_8011B364_bss (NOLOAD) : { build/asm/main_8011B364.s.o(.bss); }
    .main_8011B36C 0x8011B36C : AT(0x0011BF6C) { build/asm/data/main_8011B36C.bin.o(.data); }
    .main_8011CD60 0x8011CD60 : AT(0x0011D960) { FILL(0x00000000); build/asm/main_8011CD60.s.o(.text); build/asm/main_8011CD60.s.o(.rodata); build/asm/main_8011CD60.s.o(.data); }
    .main_8011CD60_bss (NOLOAD) : { build/asm/main_8011CD60.s.o(.bss); }
    .main_8011CDDC 0x8011CDDC : AT(0x0011D9DC) { build/asm/data/main_8011CDDC.bin.o(.data); }
    .main_8011D8A0 0x8011D8A0 : AT(0x0011E4A0) { FILL(0x00000000); build/asm/main_8011D8A0.s.o(.text); build/asm/main_8011D8A0.s.o(.rodata); build/asm/main_8011D8A0.s.o(.data); }
    .main_8011D8A0_bss (NOLOAD) : { build/asm/main_8011D8A0.s.o(.bss); }
    .main_8011D8F4 0x8011D8F4 : AT(0x0011E4F4) { build/asm/data/main_8011D8F4.bin.o(.data); }
    .main_80123E8C 0x80123E8C : AT(0x00124A8C) { FILL(0x00000000); build/asm/main_80123E8C.s.o(.text); build/asm/main_80123E8C.s.o(.rodata); build/asm/main_80123E8C.s.o(.data); }
    .main_80123E8C_bss (NOLOAD) : { build/asm/main_80123E8C.s.o(.bss); }
    .main_80123E94 0x80123E94 : AT(0x00124A94) { build/asm/data/main_80123E94.bin.o(.data); }
    .main_8012DDD4 0x8012DDD4 : AT(0x0012E9D4) { FILL(0x00000000); build/asm/main_8012DDD4.s.o(.text); build/asm/main_8012DDD4.s.o(.rodata); build/asm/main_8012DDD4.s.o(.data); }
    .main_8012DDD4_bss (NOLOAD) : { build/asm/main_8012DDD4.s.o(.bss); }
    .main_8012DE2C 0x8012DE2C : AT(0x0012EA2C) { build/asm/data/main_8012DE2C.bin.o(.data); }
    .main_8012F544 0x8012F544 : AT(0x00130144) { FILL(0x00000000); build/asm/main_8012F544.s.o(.text); build/asm/main_8012F544.s.o(.rodata); build/asm/main_8012F544.s.o(.data); }
    .main_8012F544_bss (NOLOAD) : { build/asm/main_8012F544.s.o(.bss); }
    .main_8012F584 0x8012F584 : AT(0x00130184) { build/asm/data/main_8012F584.bin.o(.data); }
    .main_80130304 0x80130304 : AT(0x00130F04) { FILL(0x00000000); build/asm/main_80130304.s.o(.text); build/asm/main_80130304.s.o(.rodata); build/asm/main_80130304.s.o(.data); }
    .main_80130304_bss (NOLOAD) : { build/asm/main_80130304.s.o(.bss); }
    .main_80130324 0x80130324 : AT(0x00130F24) { build/asm/data/main_80130324.bin.o(.data); }
    .main_80131130 0x80131130 : AT(0x00131D30) { FILL(0x00000000); build/asm/main_80131130.s.o(.text); build/asm/main_80131130.s.o(.rodata); build/asm/main_80131130.s.o(.data); }
    .main_80131130_bss (NOLOAD) : { build/asm/main_80131130.s.o(.bss); }
    .main_80131144 0x80131144 : AT(0x00131D44) { build/asm/data/main_80131144.bin.o(.data); }
    .main_80131164 0x80131164 : AT(0x00131D64) { FILL(0x00000000); build/asm/main_80131164.s.o(.text); build/asm/main_80131164.s.o(.rodata); build/asm/main_80131164.s.o(.data); }
    .main_80131164_bss (NOLOAD) : { build/asm/main_80131164.s.o(.bss); }
    .main_80131178 0x80131178 : AT(0x00131D78) { build/asm/data/main_80131178.bin.o(.data); }
    .main_8013789C 0x8013789C : AT(0x0013849C) { FILL(0x00000000); build/asm/main_8013789C.s.o(.text); build/asm/main_8013789C.s.o(.rodata); build/asm/main_8013789C.s.o(.data); }
    .main_8013789C_bss (NOLOAD) : { build/asm/main_8013789C.s.o(.bss); }
    .main_801378BC 0x801378BC : AT(0x001384BC) { build/asm/data/main_801378BC.bin.o(.data); }
    .main_8013A1CC 0x8013A1CC : AT(0x0013ADCC) { FILL(0x00000000); build/asm/main_8013A1CC.s.o(.text); build/asm/main_8013A1CC.s.o(.rodata); build/asm/main_8013A1CC.s.o(.data); }
    .main_8013A1CC_bss (NOLOAD) : { build/asm/main_8013A1CC.s.o(.bss); }
    .main_8013A1D4 0x8013A1D4 : AT(0x0013ADD4) { build/asm/data/main_8013A1D4.bin.o(.data); }
    .main_8013A464 0x8013A464 : AT(0x0013B064) { FILL(0x00000000); build/asm/main_8013A464.s.o(.text); build/asm/main_8013A464.s.o(.rodata); build/asm/main_8013A464.s.o(.data); }
    .main_8013A464_bss (NOLOAD) : { build/asm/main_8013A464.s.o(.bss); }
    .main_8013A46C 0x8013A46C : AT(0x0013B06C) { build/asm/data/main_8013A46C.bin.o(.data); }
    .main_80143530 0x80143530 : AT(0x00144130) { FILL(0x00000000); build/asm/main_80143530.s.o(.text); build/asm/main_80143530.s.o(.rodata); build/asm/main_80143530.s.o(.data); }
    .main_80143530_bss (NOLOAD) : { build/asm/main_80143530.s.o(.bss); }
    .main_8014356C 0x8014356C : AT(0x0014416C) { build/asm/data/main_8014356C.bin.o(.data); }
    .main_8014C4F8 0x8014C4F8 : AT(0x0014D0F8) { FILL(0x00000000); build/asm/main_8014C4F8.s.o(.text); build/asm/main_8014C4F8.s.o(.rodata); build/asm/main_8014C4F8.s.o(.data); }
    .main_8014C4F8_bss (NOLOAD) : { build/asm/main_8014C4F8.s.o(.bss); }
    .main_8014C514 0x8014C514 : AT(0x0014D114) { build/asm/data/main_8014C514.bin.o(.data); }
    .main_801542F0 0x801542F0 : AT(0x00154EF0) { FILL(0x00000000); build/asm/main_801542F0.s.o(.text); build/asm/main_801542F0.s.o(.rodata); build/asm/main_801542F0.s.o(.data); }
    .main_801542F0_bss (NOLOAD) : { build/asm/main_801542F0.s.o(.bss); }
    .main_80154324 0x80154324 : AT(0x00154F24) { build/asm/data/main_80154324.bin.o(.data); }
    .main_8015A058 0x8015A058 : AT(0x0015AC58) { FILL(0x00000000); build/asm/main_8015A058.s.o(.text); build/asm/main_8015A058.s.o(.rodata); build/asm/main_8015A058.s.o(.data); }
    .main_8015A058_bss (NOLOAD) : { build/asm/main_8015A058.s.o(.bss); }
    .main_8015A06C 0x8015A06C : AT(0x0015AC6C) { build/asm/data/main_8015A06C.bin.o(.data); }
    .main_8015AFE4 0x8015AFE4 : AT(0x0015BBE4) { FILL(0x00000000); build/asm/main_8015AFE4.s.o(.text); build/asm/main_8015AFE4.s.o(.rodata); build/asm/main_8015AFE4.s.o(.data); }
    .main_8015AFE4_bss (NOLOAD) : { build/asm/main_8015AFE4.s.o(.bss); }
    .main_8015B004 0x8015B004 : AT(0x0015BC04) { build/asm/data/main_8015B004.bin.o(.data); }
    .main_8015D4AC 0x8015D4AC : AT(0x0015E0AC) { FILL(0x00000000); build/asm/main_8015D4AC.s.o(.text); build/asm/main_8015D4AC.s.o(.rodata); build/asm/main_8015D4AC.s.o(.data); }
    .main_8015D4AC_bss (NOLOAD) : { build/asm/main_8015D4AC.s.o(.bss); }
    .main_8015D4D4 0x8015D4D4 : AT(0x0015E0D4) { build/asm/data/main_8015D4D4.bin.o(.data); }
    .main_8016A210 0x8016A210 : AT(0x0016AE10) { FILL(0x00000000); build/asm/main_8016A210.s.o(.text); build/asm/main_8016A210.s.o(.rodata); build/asm/main_8016A210.s.o(.data); }
    .main_8016A210_bss (NOLOAD) : { build/asm/main_8016A210.s.o(.bss); }
    .main_8016A2AC 0x8016A2AC : AT(0x0016AEAC) { build/asm/data/main_8016A2AC.bin.o(.data); }
    .main_80171894 0x80171894 : AT(0x00172494) { FILL(0x00000000); build/asm/main_80171894.s.o(.text); build/asm/main_80171894.s.o(.rodata); build/asm/main_80171894.s.o(.data); }
    .main_80171894_bss (NOLOAD) : { build/asm/main_80171894.s.o(.bss); }
    .main_801718AC 0x801718AC : AT(0x001724AC) { build/asm/data/main_801718AC.bin.o(.data); }
    .main_8017D398 0x8017D398 : AT(0x0017DF98) { FILL(0x00000000); build/asm/main_8017D398.s.o(.text); build/asm/main_8017D398.s.o(.rodata); build/asm/main_8017D398.s.o(.data); }
    .main_8017D398_bss (NOLOAD) : { build/asm/main_8017D398.s.o(.bss); }
    .main_8017D48C 0x8017D48C : AT(0x0017E08C) { build/asm/data/main_8017D48C.bin.o(.data); }
    .main_8017D8E8 0x8017D8E8 : AT(0x0017E4E8) { FILL(0x00000000); build/asm/main_8017D8E8.s.o(.text); build/asm/main_8017D8E8.s.o(.rodata); build/asm/main_8017D8E8.s.o(.data); }
    .main_8017D8E8_bss (NOLOAD) : { build/asm/main_8017D8E8.s.o(.bss); }
    .main_8017DA04 0x8017DA04 : AT(0x0017E604) { build/asm/data/main_8017DA04.bin.o(.data); }
    .main_801887AC 0x801887AC : AT(0x001893AC) { FILL(0x00000000); build/asm/main_801887AC.s.o(.text); build/asm/main_801887AC.s.o(.rodata); build/asm/main_801887AC.s.o(.data); }
    .main_801887AC_bss (NOLOAD) : { build/asm/main_801887AC.s.o(.bss); }
    .main_801887DC 0x801887DC : AT(0x001893DC) { build/asm/data/main_801887DC.bin.o(.data); }
    .main_8018C0E4 0x8018C0E4 : AT(0x0018CCE4) { FILL(0x00000000); build/asm/main_8018C0E4.s.o(.text); build/asm/main_8018C0E4.s.o(.rodata); build/asm/main_8018C0E4.s.o(.data); }
    .main_8018C0E4_bss (NOLOAD) : { build/asm/main_8018C0E4.s.o(.bss); }
    .main_8018C120 0x8018C120 : AT(0x0018CD20) { build/asm/data/main_8018C120.bin.o(.data); }
    .main_8018D9D0 0x8018D9D0 : AT(0x0018E5D0) { FILL(0x00000000); build/asm/main_8018D9D0.s.o(.text); build/asm/main_8018D9D0.s.o(.rodata); build/asm/main_8018D9D0.s.o(.data); }
    .main_8018D9D0_bss (NOLOAD) : { build/asm/main_8018D9D0.s.o(.bss); }
    .main_8018D9DC 0x8018D9DC : AT(0x0018E5DC) { build/asm/data/main_8018D9DC.bin.o(.data); }
    .main_8019733C 0x8019733C : AT(0x00197F3C) { FILL(0x00000000); build/asm/main_8019733C.s.o(.text); build/asm/main_8019733C.s.o(.rodata); build/asm/main_8019733C.s.o(.data); }
    .main_8019733C_bss (NOLOAD) : { build/asm/main_8019733C.s.o(.bss); }
    .main_8019739C 0x8019739C : AT(0x00197F9C) { build/asm/data/main_8019739C.bin.o(.data); }
    .main_80197934 0x80197934 : AT(0x00198534) { FILL(0x00000000); build/asm/main_80197934.s.o(.text); build/asm/main_80197934.s.o(.rodata); build/asm/main_80197934.s.o(.data); }
    .main_80197934_bss (NOLOAD) : { build/asm/main_80197934.s.o(.bss); }
    .main_80197940 0x80197940 : AT(0x00198540) { build/asm/data/main_80197940.bin.o(.data); }
    .main_801979E8 0x801979E8 : AT(0x001985E8) { FILL(0x00000000); build/asm/main_801979E8.s.o(.text); build/asm/main_801979E8.s.o(.rodata); build/asm/main_801979E8.s.o(.data); }
    .main_801979E8_bss (NOLOAD) : { build/asm/main_801979E8.s.o(.bss); }
    .main_80197B64 0x80197B64 : AT(0x00198764) { build/asm/data/main_80197B64.bin.o(.data); }
    .main_8019BE90 0x8019BE90 : AT(0x0019CA90) { FILL(0x00000000); build/asm/main_8019BE90.s.o(.text); build/asm/main_8019BE90.s.o(.rodata); build/asm/main_8019BE90.s.o(.data); }
    .main_8019BE90_bss (NOLOAD) : { build/asm/main_8019BE90.s.o(.bss); }
    .main_8019BEA4 0x8019BEA4 : AT(0x0019CAA4) { build/asm/data/main_8019BEA4.bin.o(.data); }
    .main_8019F5C8 0x8019F5C8 : AT(0x001A01C8) { FILL(0x00000000); build/asm/main_8019F5C8.s.o(.text); build/asm/main_8019F5C8.s.o(.rodata); build/asm/main_8019F5C8.s.o(.data); }
    .main_8019F5C8_bss (NOLOAD) : { build/asm/main_8019F5C8.s.o(.bss); }
    .main_8019F5E4 0x8019F5E4 : AT(0x001A01E4) { build/asm/data/main_8019F5E4.bin.o(.data); }
    .main_801A249C 0x801A249C : AT(0x001A309C) { FILL(0x00000000); build/asm/main_801A249C.s.o(.text); build/asm/main_801A249C.s.o(.rodata); build/asm/main_801A249C.s.o(.data); }
    .main_801A249C_bss (NOLOAD) : { build/asm/main_801A249C.s.o(.bss); }
    .main_801A24D4 0x801A24D4 : AT(0x001A30D4) { build/asm/data/main_801A24D4.bin.o(.data); }
    .main_801B603C 0x801B603C : AT(0x001B6C3C) { FILL(0x00000000); build/asm/main_801B603C.s.o(.text); build/asm/main_801B603C.s.o(.rodata); build/asm/main_801B603C.s.o(.data); }
    .main_801B603C_bss (NOLOAD) : { build/asm/main_801B603C.s.o(.bss); }
    .main_801B6134 0x801B6134 : AT(0x001B6D34) { build/asm/data/main_801B6134.bin.o(.data); }
    .main_801C42C0 0x801C42C0 : AT(0x001C4EC0) { FILL(0x00000000); build/asm/main_801C42C0.s.o(.text); build/asm/main_801C42C0.s.o(.rodata); build/asm/main_801C42C0.s.o(.data); }
    .main_801C42C0_bss (NOLOAD) : { build/asm/main_801C42C0.s.o(.bss); }
    .main_801C42D0 0x801C42D0 : AT(0x001C4ED0) { build/asm/data/main_801C42D0.bin.o(.data); }
    .main_801C5698 0x801C5698 : AT(0x001C6298) { FILL(0x00000000); build/asm/main_801C5698.s.o(.text); build/asm/main_801C5698.s.o(.rodata); build/asm/main_801C5698.s.o(.data); }
    .main_801C5698_bss (NOLOAD) : { build/asm/main_801C5698.s.o(.bss); }
    .main_801C56A8 0x801C56A8 : AT(0x001C62A8) { build/asm/data/main_801C56A8.bin.o(.data); }
    .main_801C5CC0 0x801C5CC0 : AT(0x001C68C0) { FILL(0x00000000); build/asm/main_801C5CC0.s.o(.text); build/asm/main_801C5CC0.s.o(.rodata); build/asm/main_801C5CC0.s.o(.data); }
    .main_801C5CC0_bss (NOLOAD) : { build/asm/main_801C5CC0.s.o(.bss); }
    .main_801C5CF4 0x801C5CF4 : AT(0x001C68F4) { build/asm/data/main_801C5CF4.bin.o(.data); }
    .main_801C640C 0x801C640C : AT(0x001C700C) { FILL(0x00000000); build/asm/main_801C640C.s.o(.text); build/asm/main_801C640C.s.o(.rodata); build/asm/main_801C640C.s.o(.data); }
    .main_801C640C_bss (NOLOAD) : { build/asm/main_801C640C.s.o(.bss); }
    .main_801C6488 0x801C6488 : AT(0x001C7088) { build/asm/data/main_801C6488.bin.o(.data); }
    .main_801CBF68 0x801CBF68 : AT(0x001CCB68) { FILL(0x00000000); build/asm/main_801CBF68.s.o(.text); build/asm/main_801CBF68.s.o(.rodata); build/asm/main_801CBF68.s.o(.data); }
    .main_801CBF68_bss (NOLOAD) : { build/asm/main_801CBF68.s.o(.bss); }
    .main_801CBF80 0x801CBF80 : AT(0x001CCB80) { build/asm/data/main_801CBF80.bin.o(.data); }
    .main_801D1A48 0x801D1A48 : AT(0x001D2648) { FILL(0x00000000); build/asm/main_801D1A48.s.o(.text); build/asm/main_801D1A48.s.o(.rodata); build/asm/main_801D1A48.s.o(.data); }
    .main_801D1A48_bss (NOLOAD) : { build/asm/main_801D1A48.s.o(.bss); }
    .main_801D1C18 0x801D1C18 : AT(0x001D2818) { build/asm/data/main_801D1C18.bin.o(.data); }
    .main_801D2768 0x801D2768 : AT(0x001D3368) { FILL(0x00000000); build/asm/main_801D2768.s.o(.text); build/asm/main_801D2768.s.o(.rodata); build/asm/main_801D2768.s.o(.data); }
    .main_801D2768_bss (NOLOAD) : { build/asm/main_801D2768.s.o(.bss); }
    .main_801D276C 0x801D276C : AT(0x001D336C) { build/asm/data/main_801D276C.bin.o(.data); }
    .main_801D8EF8 0x801D8EF8 : AT(0x001D9AF8) { FILL(0x00000000); build/asm/main_801D8EF8.s.o(.text); build/asm/main_801D8EF8.s.o(.rodata); build/asm/main_801D8EF8.s.o(.data); }
    .main_801D8EF8_bss (NOLOAD) : { build/asm/main_801D8EF8.s.o(.bss); }
    .main_801D8F2C 0x801D8F2C : AT(0x001D9B2C) { build/asm/data/main_801D8F2C.bin.o(.data); }
    .main_801DCDB8 0x801DCDB8 : AT(0x001DD9B8) { FILL(0x00000000); build/asm/main_801DCDB8.s.o(.text); build/asm/main_801DCDB8.s.o(.rodata); build/asm/main_801DCDB8.s.o(.data); }
    .main_801DCDB8_bss (NOLOAD) : { build/asm/main_801DCDB8.s.o(.bss); }
    .main_801DCEBC 0x801DCEBC : AT(0x001DDABC) { build/asm/data/main_801DCEBC.bin.o(.data); }
    .main_801E09EC 0x801E09EC : AT(0x001E15EC) { FILL(0x00000000); build/asm/main_801E09EC.s.o(.text); build/asm/main_801E09EC.s.o(.rodata); build/asm/main_801E09EC.s.o(.data); }
    .main_801E09EC_bss (NOLOAD) : { build/asm/main_801E09EC.s.o(.bss); }
    .main_801E0A10 0x801E0A10 : AT(0x001E1610) { build/asm/data/main_801E0A10.bin.o(.data); }
    .main_801E7A44 0x801E7A44 : AT(0x001E8644) { FILL(0x00000000); build/asm/main_801E7A44.s.o(.text); build/asm/main_801E7A44.s.o(.rodata); build/asm/main_801E7A44.s.o(.data); }
    .main_801E7A44_bss (NOLOAD) : { build/asm/main_801E7A44.s.o(.bss); }
    .main_801E7AEC 0x801E7AEC : AT(0x001E86EC) { build/asm/data/main_801E7AEC.bin.o(.data); }
    .main_801ECC00 0x801ECC00 : AT(0x001ED800) { FILL(0x00000000); build/asm/main_801ECC00.s.o(.text); build/asm/main_801ECC00.s.o(.rodata); build/asm/main_801ECC00.s.o(.data); }
    .main_801ECC00_bss (NOLOAD) : { build/asm/main_801ECC00.s.o(.bss); }
    .main_801ECC0C 0x801ECC0C : AT(0x001ED80C) { build/asm/data/main_801ECC0C.bin.o(.data); }
    .assets 0x80400000 : AT(0x001ED80C) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
