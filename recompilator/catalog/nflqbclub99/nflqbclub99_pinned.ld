SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80300000 0x80300000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80300000.s.o(.text); build/asm/main_80300000.s.o(.rodata); build/asm/main_80300000.s.o(.data); }
    .main_80300000_bss (NOLOAD) : { build/asm/main_80300000.s.o(.bss); }
    .main_80300040 0x80300040 : AT(0x00001040) { FILL(0x00000000); build/asm/main_80300040.s.o(.text); build/asm/main_80300040.s.o(.rodata); build/asm/main_80300040.s.o(.data); }
    .main_80300040_bss (NOLOAD) : { build/asm/main_80300040.s.o(.bss); }
    .main_80301D60 0x80301D60 : AT(0x00002D60) { build/asm/data/main_80301D60.bin.o(.data); }
    .main_80307AC8 0x80307AC8 : AT(0x00008AC8) { FILL(0x00000000); build/asm/main_80307AC8.s.o(.text); build/asm/main_80307AC8.s.o(.rodata); build/asm/main_80307AC8.s.o(.data); }
    .main_80307AC8_bss (NOLOAD) : { build/asm/main_80307AC8.s.o(.bss); }
    .main_80307ACC 0x80307ACC : AT(0x00008ACC) { build/asm/data/main_80307ACC.bin.o(.data); }
    .main_8032517C 0x8032517C : AT(0x0002617C) { FILL(0x00000000); build/asm/main_8032517C.s.o(.text); build/asm/main_8032517C.s.o(.rodata); build/asm/main_8032517C.s.o(.data); }
    .main_8032517C_bss (NOLOAD) : { build/asm/main_8032517C.s.o(.bss); }
    .main_803251E8 0x803251E8 : AT(0x000261E8) { build/asm/data/main_803251E8.bin.o(.data); }
    .main_8032E5C8 0x8032E5C8 : AT(0x0002F5C8) { FILL(0x00000000); build/asm/main_8032E5C8.s.o(.text); build/asm/main_8032E5C8.s.o(.rodata); build/asm/main_8032E5C8.s.o(.data); }
    .main_8032E5C8_bss (NOLOAD) : { build/asm/main_8032E5C8.s.o(.bss); }
    .main_8032E5CC 0x8032E5CC : AT(0x0002F5CC) { build/asm/data/main_8032E5CC.bin.o(.data); }
    .main_80345114 0x80345114 : AT(0x00046114) { FILL(0x00000000); build/asm/main_80345114.s.o(.text); build/asm/main_80345114.s.o(.rodata); build/asm/main_80345114.s.o(.data); }
    .main_80345114_bss (NOLOAD) : { build/asm/main_80345114.s.o(.bss); }
    .main_80345158 0x80345158 : AT(0x00046158) { build/asm/data/main_80345158.bin.o(.data); }
    .main_803501C8 0x803501C8 : AT(0x000511C8) { FILL(0x00000000); build/asm/main_803501C8.s.o(.text); build/asm/main_803501C8.s.o(.rodata); build/asm/main_803501C8.s.o(.data); }
    .main_803501C8_bss (NOLOAD) : { build/asm/main_803501C8.s.o(.bss); }
    .main_80350208 0x80350208 : AT(0x00051208) { build/asm/data/main_80350208.bin.o(.data); }
    .main_8035E0F0 0x8035E0F0 : AT(0x0005F0F0) { FILL(0x00000000); build/asm/main_8035E0F0.s.o(.text); build/asm/main_8035E0F0.s.o(.rodata); build/asm/main_8035E0F0.s.o(.data); }
    .main_8035E0F0_bss (NOLOAD) : { build/asm/main_8035E0F0.s.o(.bss); }
    .main_8035E0F8 0x8035E0F8 : AT(0x0005F0F8) { build/asm/data/main_8035E0F8.bin.o(.data); }
    .main_80366DB4 0x80366DB4 : AT(0x00067DB4) { FILL(0x00000000); build/asm/main_80366DB4.s.o(.text); build/asm/main_80366DB4.s.o(.rodata); build/asm/main_80366DB4.s.o(.data); }
    .main_80366DB4_bss (NOLOAD) : { build/asm/main_80366DB4.s.o(.bss); }
    .main_80366DB8 0x80366DB8 : AT(0x00067DB8) { build/asm/data/main_80366DB8.bin.o(.data); }
    .main_8036ADEC 0x8036ADEC : AT(0x0006BDEC) { FILL(0x00000000); build/asm/main_8036ADEC.s.o(.text); build/asm/main_8036ADEC.s.o(.rodata); build/asm/main_8036ADEC.s.o(.data); }
    .main_8036ADEC_bss (NOLOAD) : { build/asm/main_8036ADEC.s.o(.bss); }
    .main_8036AE00 0x8036AE00 : AT(0x0006BE00) { build/asm/data/main_8036AE00.bin.o(.data); }
    .main_8037AFB8 0x8037AFB8 : AT(0x0007BFB8) { FILL(0x00000000); build/asm/main_8037AFB8.s.o(.text); build/asm/main_8037AFB8.s.o(.rodata); build/asm/main_8037AFB8.s.o(.data); }
    .main_8037AFB8_bss (NOLOAD) : { build/asm/main_8037AFB8.s.o(.bss); }
    .main_8037AFBC 0x8037AFBC : AT(0x0007BFBC) { build/asm/data/main_8037AFBC.bin.o(.data); }
    .main_8037EE78 0x8037EE78 : AT(0x0007FE78) { FILL(0x00000000); build/asm/main_8037EE78.s.o(.text); build/asm/main_8037EE78.s.o(.rodata); build/asm/main_8037EE78.s.o(.data); }
    .main_8037EE78_bss (NOLOAD) : { build/asm/main_8037EE78.s.o(.bss); }
    .main_8037EEB4 0x8037EEB4 : AT(0x0007FEB4) { build/asm/data/main_8037EEB4.bin.o(.data); }
    .main_8039855C 0x8039855C : AT(0x0009955C) { FILL(0x00000000); build/asm/main_8039855C.s.o(.text); build/asm/main_8039855C.s.o(.rodata); build/asm/main_8039855C.s.o(.data); }
    .main_8039855C_bss (NOLOAD) : { build/asm/main_8039855C.s.o(.bss); }
    .main_8039859C 0x8039859C : AT(0x0009959C) { build/asm/data/main_8039859C.bin.o(.data); }
    .main_8039C4C8 0x8039C4C8 : AT(0x0009D4C8) { FILL(0x00000000); build/asm/main_8039C4C8.s.o(.text); build/asm/main_8039C4C8.s.o(.rodata); build/asm/main_8039C4C8.s.o(.data); }
    .main_8039C4C8_bss (NOLOAD) : { build/asm/main_8039C4C8.s.o(.bss); }
    .main_8039C4DC 0x8039C4DC : AT(0x0009D4DC) { build/asm/data/main_8039C4DC.bin.o(.data); }
    .main_803B06D8 0x803B06D8 : AT(0x000B16D8) { FILL(0x00000000); build/asm/main_803B06D8.s.o(.text); build/asm/main_803B06D8.s.o(.rodata); build/asm/main_803B06D8.s.o(.data); }
    .main_803B06D8_bss (NOLOAD) : { build/asm/main_803B06D8.s.o(.bss); }
    .main_803B070C 0x803B070C : AT(0x000B170C) { build/asm/data/main_803B070C.bin.o(.data); }
    .main_803B77C0 0x803B77C0 : AT(0x000B87C0) { FILL(0x00000000); build/asm/main_803B77C0.s.o(.text); build/asm/main_803B77C0.s.o(.rodata); build/asm/main_803B77C0.s.o(.data); }
    .main_803B77C0_bss (NOLOAD) : { build/asm/main_803B77C0.s.o(.bss); }
    .main_803B7848 0x803B7848 : AT(0x000B8848) { build/asm/data/main_803B7848.bin.o(.data); }
    .main_803BA880 0x803BA880 : AT(0x000BB880) { FILL(0x00000000); build/asm/main_803BA880.s.o(.text); build/asm/main_803BA880.s.o(.rodata); build/asm/main_803BA880.s.o(.data); }
    .main_803BA880_bss (NOLOAD) : { build/asm/main_803BA880.s.o(.bss); }
    .main_803BA888 0x803BA888 : AT(0x000BB888) { build/asm/data/main_803BA888.bin.o(.data); }
    .main_803BF018 0x803BF018 : AT(0x000C0018) { FILL(0x00000000); build/asm/main_803BF018.s.o(.text); build/asm/main_803BF018.s.o(.rodata); build/asm/main_803BF018.s.o(.data); }
    .main_803BF018_bss (NOLOAD) : { build/asm/main_803BF018.s.o(.bss); }
    .main_803BF024 0x803BF024 : AT(0x000C0024) { build/asm/data/main_803BF024.bin.o(.data); }
    .main_803C333C 0x803C333C : AT(0x000C433C) { FILL(0x00000000); build/asm/main_803C333C.s.o(.text); build/asm/main_803C333C.s.o(.rodata); build/asm/main_803C333C.s.o(.data); }
    .main_803C333C_bss (NOLOAD) : { build/asm/main_803C333C.s.o(.bss); }
    .main_803C3390 0x803C3390 : AT(0x000C4390) { build/asm/data/main_803C3390.bin.o(.data); }
    .main_803C7B14 0x803C7B14 : AT(0x000C8B14) { FILL(0x00000000); build/asm/main_803C7B14.s.o(.text); build/asm/main_803C7B14.s.o(.rodata); build/asm/main_803C7B14.s.o(.data); }
    .main_803C7B14_bss (NOLOAD) : { build/asm/main_803C7B14.s.o(.bss); }
    .main_803C7B6C 0x803C7B6C : AT(0x000C8B6C) { build/asm/data/main_803C7B6C.bin.o(.data); }
    .main_803CB0B0 0x803CB0B0 : AT(0x000CC0B0) { FILL(0x00000000); build/asm/main_803CB0B0.s.o(.text); build/asm/main_803CB0B0.s.o(.rodata); build/asm/main_803CB0B0.s.o(.data); }
    .main_803CB0B0_bss (NOLOAD) : { build/asm/main_803CB0B0.s.o(.bss); }
    .main_803CB0D0 0x803CB0D0 : AT(0x000CC0D0) { build/asm/data/main_803CB0D0.bin.o(.data); }
    .main_803CC180 0x803CC180 : AT(0x000CD180) { FILL(0x00000000); build/asm/main_803CC180.s.o(.text); build/asm/main_803CC180.s.o(.rodata); build/asm/main_803CC180.s.o(.data); }
    .main_803CC180_bss (NOLOAD) : { build/asm/main_803CC180.s.o(.bss); }
    .main_803CC1A4 0x803CC1A4 : AT(0x000CD1A4) { build/asm/data/main_803CC1A4.bin.o(.data); }
    .main_803D034C 0x803D034C : AT(0x000D134C) { FILL(0x00000000); build/asm/main_803D034C.s.o(.text); build/asm/main_803D034C.s.o(.rodata); build/asm/main_803D034C.s.o(.data); }
    .main_803D034C_bss (NOLOAD) : { build/asm/main_803D034C.s.o(.bss); }
    .main_803D037C 0x803D037C : AT(0x000D137C) { build/asm/data/main_803D037C.bin.o(.data); }
    .main_803DC338 0x803DC338 : AT(0x000DD338) { FILL(0x00000000); build/asm/main_803DC338.s.o(.text); build/asm/main_803DC338.s.o(.rodata); build/asm/main_803DC338.s.o(.data); }
    .main_803DC338_bss (NOLOAD) : { build/asm/main_803DC338.s.o(.bss); }
    .main_803DC350 0x803DC350 : AT(0x000DD350) { build/asm/data/main_803DC350.bin.o(.data); }
    .main_803E5438 0x803E5438 : AT(0x000E6438) { FILL(0x00000000); build/asm/main_803E5438.s.o(.text); build/asm/main_803E5438.s.o(.rodata); build/asm/main_803E5438.s.o(.data); }
    .main_803E5438_bss (NOLOAD) : { build/asm/main_803E5438.s.o(.bss); }
    .main_803E5440 0x803E5440 : AT(0x000E6440) { build/asm/data/main_803E5440.bin.o(.data); }
    .main_803F41BC 0x803F41BC : AT(0x000F51BC) { FILL(0x00000000); build/asm/main_803F41BC.s.o(.text); build/asm/main_803F41BC.s.o(.rodata); build/asm/main_803F41BC.s.o(.data); }
    .main_803F41BC_bss (NOLOAD) : { build/asm/main_803F41BC.s.o(.bss); }
    .main_803F41E0 0x803F41E0 : AT(0x000F51E0) { build/asm/data/main_803F41E0.bin.o(.data); }
    .main_803FBF88 0x803FBF88 : AT(0x000FCF88) { FILL(0x00000000); build/asm/main_803FBF88.s.o(.text); build/asm/main_803FBF88.s.o(.rodata); build/asm/main_803FBF88.s.o(.data); }
    .main_803FBF88_bss (NOLOAD) : { build/asm/main_803FBF88.s.o(.bss); }
    .main_803FBFBC 0x803FBFBC : AT(0x000FCFBC) { build/asm/data/main_803FBFBC.bin.o(.data); }
    .assets 0x80700000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
