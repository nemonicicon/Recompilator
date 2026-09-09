SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80300000 0x80300000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80300000.s.o(.text); build/asm/main_80300000.s.o(.rodata); build/asm/main_80300000.s.o(.data); }
    .main_80300000_bss (NOLOAD) : { build/asm/main_80300000.s.o(.bss); }
    .main_803001B8 0x803001B8 : AT(0x000011B8) { FILL(0x00000000); build/asm/main_803001B8.s.o(.text); build/asm/main_803001B8.s.o(.rodata); build/asm/main_803001B8.s.o(.data); }
    .main_803001B8_bss (NOLOAD) : { build/asm/main_803001B8.s.o(.bss); }
    .main_80300360 0x80300360 : AT(0x00001360) { FILL(0x00000000); build/asm/main_80300360.s.o(.text); build/asm/main_80300360.s.o(.rodata); build/asm/main_80300360.s.o(.data); }
    .main_80300360_bss (NOLOAD) : { build/asm/main_80300360.s.o(.bss); }
    .main_80300A60 0x80300A60 : AT(0x00001A60) { FILL(0x00000000); build/asm/main_80300A60.s.o(.text); build/asm/main_80300A60.s.o(.rodata); build/asm/main_80300A60.s.o(.data); }
    .main_80300A60_bss (NOLOAD) : { build/asm/main_80300A60.s.o(.bss); }
    .main_803013B4 0x803013B4 : AT(0x000023B4) { FILL(0x00000000); build/asm/main_803013B4.s.o(.text); build/asm/main_803013B4.s.o(.rodata); build/asm/main_803013B4.s.o(.data); }
    .main_803013B4_bss (NOLOAD) : { build/asm/main_803013B4.s.o(.bss); }
    .main_80301790 0x80301790 : AT(0x00002790) { FILL(0x00000000); build/asm/main_80301790.s.o(.text); build/asm/main_80301790.s.o(.rodata); build/asm/main_80301790.s.o(.data); }
    .main_80301790_bss (NOLOAD) : { build/asm/main_80301790.s.o(.bss); }
    .main_80304EB4 0x80304EB4 : AT(0x00005EB4) { build/asm/data/main_80304EB4.bin.o(.data); }
    .main_80305328 0x80305328 : AT(0x00006328) { build/asm/data/main_80305328.bin.o(.data); }
    .main_80305C8C 0x80305C8C : AT(0x00006C8C) { FILL(0x00000000); build/asm/main_80305C8C.s.o(.text); build/asm/main_80305C8C.s.o(.rodata); build/asm/main_80305C8C.s.o(.data); }
    .main_80305C8C_bss (NOLOAD) : { build/asm/main_80305C8C.s.o(.bss); }
    .main_80305E84 0x80305E84 : AT(0x00006E84) { build/asm/data/main_80305E84.bin.o(.data); }
    .main_80305FC4 0x80305FC4 : AT(0x00006FC4) { FILL(0x00000000); build/asm/main_80305FC4.s.o(.text); build/asm/main_80305FC4.s.o(.rodata); build/asm/main_80305FC4.s.o(.data); }
    .main_80305FC4_bss (NOLOAD) : { build/asm/main_80305FC4.s.o(.bss); }
    .main_80305FE4 0x80305FE4 : AT(0x00006FE4) { build/asm/data/main_80305FE4.bin.o(.data); }
    .main_80306944 0x80306944 : AT(0x00007944) { build/asm/data/main_80306944.bin.o(.data); }
    .main_803069A0 0x803069A0 : AT(0x000079A0) { FILL(0x00000000); build/asm/main_803069A0.s.o(.text); build/asm/main_803069A0.s.o(.rodata); build/asm/main_803069A0.s.o(.data); }
    .main_803069A0_bss (NOLOAD) : { build/asm/main_803069A0.s.o(.bss); }
    .main_80306A00 0x80306A00 : AT(0x00007A00) { build/asm/data/main_80306A00.bin.o(.data); }
    .main_803075A4 0x803075A4 : AT(0x000085A4) { FILL(0x00000000); build/asm/main_803075A4.s.o(.text); build/asm/main_803075A4.s.o(.rodata); build/asm/main_803075A4.s.o(.data); }
    .main_803075A4_bss (NOLOAD) : { build/asm/main_803075A4.s.o(.bss); }
    .main_803076C0 0x803076C0 : AT(0x000086C0) { build/asm/data/main_803076C0.bin.o(.data); }
    .main_80309470 0x80309470 : AT(0x0000A470) { FILL(0x00000000); build/asm/main_80309470.s.o(.text); build/asm/main_80309470.s.o(.rodata); build/asm/main_80309470.s.o(.data); }
    .main_80309470_bss (NOLOAD) : { build/asm/main_80309470.s.o(.bss); }
    .main_80309480 0x80309480 : AT(0x0000A480) { build/asm/data/main_80309480.bin.o(.data); }
    .main_8030C0CC 0x8030C0CC : AT(0x0000D0CC) { FILL(0x00000000); build/asm/main_8030C0CC.s.o(.text); build/asm/main_8030C0CC.s.o(.rodata); build/asm/main_8030C0CC.s.o(.data); }
    .main_8030C0CC_bss (NOLOAD) : { build/asm/main_8030C0CC.s.o(.bss); }
    .main_8030C0F8 0x8030C0F8 : AT(0x0000D0F8) { build/asm/data/main_8030C0F8.bin.o(.data); }
    .main_8030C7D4 0x8030C7D4 : AT(0x0000D7D4) { FILL(0x00000000); build/asm/main_8030C7D4.s.o(.text); build/asm/main_8030C7D4.s.o(.rodata); build/asm/main_8030C7D4.s.o(.data); }
    .main_8030C7D4_bss (NOLOAD) : { build/asm/main_8030C7D4.s.o(.bss); }
    .main_8030D16C 0x8030D16C : AT(0x0000E16C) { build/asm/data/main_8030D16C.bin.o(.data); }
    .main_80314000 0x80314000 : AT(0x00015000) { FILL(0x00000000); build/asm/main_80314000.s.o(.text); build/asm/main_80314000.s.o(.rodata); build/asm/main_80314000.s.o(.data); }
    .main_80314000_bss (NOLOAD) : { build/asm/main_80314000.s.o(.bss); }
    .main_80314034 0x80314034 : AT(0x00015034) { build/asm/data/main_80314034.bin.o(.data); }
    .main_80316264 0x80316264 : AT(0x00017264) { FILL(0x00000000); build/asm/main_80316264.s.o(.text); build/asm/main_80316264.s.o(.rodata); build/asm/main_80316264.s.o(.data); }
    .main_80316264_bss (NOLOAD) : { build/asm/main_80316264.s.o(.bss); }
    .main_803164D4 0x803164D4 : AT(0x000174D4) { build/asm/data/main_803164D4.bin.o(.data); }
    .main_80316BAC 0x80316BAC : AT(0x00017BAC) { FILL(0x00000000); build/asm/main_80316BAC.s.o(.text); build/asm/main_80316BAC.s.o(.rodata); build/asm/main_80316BAC.s.o(.data); }
    .main_80316BAC_bss (NOLOAD) : { build/asm/main_80316BAC.s.o(.bss); }
    .main_80317278 0x80317278 : AT(0x00018278) { build/asm/data/main_80317278.bin.o(.data); }
    .main_803179A0 0x803179A0 : AT(0x000189A0) { FILL(0x00000000); build/asm/main_803179A0.s.o(.text); build/asm/main_803179A0.s.o(.rodata); build/asm/main_803179A0.s.o(.data); }
    .main_803179A0_bss (NOLOAD) : { build/asm/main_803179A0.s.o(.bss); }
    .main_80317D80 0x80317D80 : AT(0x00018D80) { build/asm/data/main_80317D80.bin.o(.data); }
    .main_80317FA8 0x80317FA8 : AT(0x00018FA8) { FILL(0x00000000); build/asm/main_80317FA8.s.o(.text); build/asm/main_80317FA8.s.o(.rodata); build/asm/main_80317FA8.s.o(.data); }
    .main_80317FA8_bss (NOLOAD) : { build/asm/main_80317FA8.s.o(.bss); }
    .main_80318200 0x80318200 : AT(0x00019200) { build/asm/data/main_80318200.bin.o(.data); }
    .main_80318E68 0x80318E68 : AT(0x00019E68) { FILL(0x00000000); build/asm/main_80318E68.s.o(.text); build/asm/main_80318E68.s.o(.rodata); build/asm/main_80318E68.s.o(.data); }
    .main_80318E68_bss (NOLOAD) : { build/asm/main_80318E68.s.o(.bss); }
    .main_80318F24 0x80318F24 : AT(0x00019F24) { build/asm/data/main_80318F24.bin.o(.data); }
    .main_80319C88 0x80319C88 : AT(0x0001AC88) { FILL(0x00000000); build/asm/main_80319C88.s.o(.text); build/asm/main_80319C88.s.o(.rodata); build/asm/main_80319C88.s.o(.data); }
    .main_80319C88_bss (NOLOAD) : { build/asm/main_80319C88.s.o(.bss); }
    .main_80319F6C 0x80319F6C : AT(0x0001AF6C) { build/asm/data/main_80319F6C.bin.o(.data); }
    .main_8031A040 0x8031A040 : AT(0x0001B040) { FILL(0x00000000); build/asm/main_8031A040.s.o(.text); build/asm/main_8031A040.s.o(.rodata); build/asm/main_8031A040.s.o(.data); }
    .main_8031A040_bss (NOLOAD) : { build/asm/main_8031A040.s.o(.bss); }
    .main_8031A63C 0x8031A63C : AT(0x0001B63C) { build/asm/data/main_8031A63C.bin.o(.data); }
    .main_8031B3EC 0x8031B3EC : AT(0x0001C3EC) { FILL(0x00000000); build/asm/main_8031B3EC.s.o(.text); build/asm/main_8031B3EC.s.o(.rodata); build/asm/main_8031B3EC.s.o(.data); }
    .main_8031B3EC_bss (NOLOAD) : { build/asm/main_8031B3EC.s.o(.bss); }
    .main_8031B420 0x8031B420 : AT(0x0001C420) { build/asm/data/main_8031B420.bin.o(.data); }
    .main_8031C700 0x8031C700 : AT(0x0001D700) { FILL(0x00000000); build/asm/main_8031C700.s.o(.text); build/asm/main_8031C700.s.o(.rodata); build/asm/main_8031C700.s.o(.data); }
    .main_8031C700_bss (NOLOAD) : { build/asm/main_8031C700.s.o(.bss); }
    .main_8031C83C 0x8031C83C : AT(0x0001D83C) { build/asm/data/main_8031C83C.bin.o(.data); }
    .main_8031D4F0 0x8031D4F0 : AT(0x0001E4F0) { FILL(0x00000000); build/asm/main_8031D4F0.s.o(.text); build/asm/main_8031D4F0.s.o(.rodata); build/asm/main_8031D4F0.s.o(.data); }
    .main_8031D4F0_bss (NOLOAD) : { build/asm/main_8031D4F0.s.o(.bss); }
    .main_8031D848 0x8031D848 : AT(0x0001E848) { build/asm/data/main_8031D848.bin.o(.data); }
    .main_8031E0B8 0x8031E0B8 : AT(0x0001F0B8) { FILL(0x00000000); build/asm/main_8031E0B8.s.o(.text); build/asm/main_8031E0B8.s.o(.rodata); build/asm/main_8031E0B8.s.o(.data); }
    .main_8031E0B8_bss (NOLOAD) : { build/asm/main_8031E0B8.s.o(.bss); }
    .main_8031E118 0x8031E118 : AT(0x0001F118) { build/asm/data/main_8031E118.bin.o(.data); }
    .main_8031E6C8 0x8031E6C8 : AT(0x0001F6C8) { FILL(0x00000000); build/asm/main_8031E6C8.s.o(.text); build/asm/main_8031E6C8.s.o(.rodata); build/asm/main_8031E6C8.s.o(.data); }
    .main_8031E6C8_bss (NOLOAD) : { build/asm/main_8031E6C8.s.o(.bss); }
    .main_8031E6DC 0x8031E6DC : AT(0x0001F6DC) { build/asm/data/main_8031E6DC.bin.o(.data); }
    .main_8031E730 0x8031E730 : AT(0x0001F730) { FILL(0x00000000); build/asm/main_8031E730.s.o(.text); build/asm/main_8031E730.s.o(.rodata); build/asm/main_8031E730.s.o(.data); }
    .main_8031E730_bss (NOLOAD) : { build/asm/main_8031E730.s.o(.bss); }
    .main_8031E79C 0x8031E79C : AT(0x0001F79C) { build/asm/data/main_8031E79C.bin.o(.data); }
    .main_8031EB84 0x8031EB84 : AT(0x0001FB84) { FILL(0x00000000); build/asm/main_8031EB84.s.o(.text); build/asm/main_8031EB84.s.o(.rodata); build/asm/main_8031EB84.s.o(.data); }
    .main_8031EB84_bss (NOLOAD) : { build/asm/main_8031EB84.s.o(.bss); }
    .main_8031EC24 0x8031EC24 : AT(0x0001FC24) { build/asm/data/main_8031EC24.bin.o(.data); }
    .main_8031ED14 0x8031ED14 : AT(0x0001FD14) { FILL(0x00000000); build/asm/main_8031ED14.s.o(.text); build/asm/main_8031ED14.s.o(.rodata); build/asm/main_8031ED14.s.o(.data); }
    .main_8031ED14_bss (NOLOAD) : { build/asm/main_8031ED14.s.o(.bss); }
    .main_8031EDC4 0x8031EDC4 : AT(0x0001FDC4) { build/asm/data/main_8031EDC4.bin.o(.data); }
    .main_80321870 0x80321870 : AT(0x00022870) { FILL(0x00000000); build/asm/main_80321870.s.o(.text); build/asm/main_80321870.s.o(.rodata); build/asm/main_80321870.s.o(.data); }
    .main_80321870_bss (NOLOAD) : { build/asm/main_80321870.s.o(.bss); }
    .main_80321A58 0x80321A58 : AT(0x00022A58) { build/asm/data/main_80321A58.bin.o(.data); }
    .main_80321F9C 0x80321F9C : AT(0x00022F9C) { FILL(0x00000000); build/asm/main_80321F9C.s.o(.text); build/asm/main_80321F9C.s.o(.rodata); build/asm/main_80321F9C.s.o(.data); }
    .main_80321F9C_bss (NOLOAD) : { build/asm/main_80321F9C.s.o(.bss); }
    .main_80321FA4 0x80321FA4 : AT(0x00022FA4) { build/asm/data/main_80321FA4.bin.o(.data); }
    .main_803228CC 0x803228CC : AT(0x000238CC) { FILL(0x00000000); build/asm/main_803228CC.s.o(.text); build/asm/main_803228CC.s.o(.rodata); build/asm/main_803228CC.s.o(.data); }
    .main_803228CC_bss (NOLOAD) : { build/asm/main_803228CC.s.o(.bss); }
    .main_803228E0 0x803228E0 : AT(0x000238E0) { build/asm/data/main_803228E0.bin.o(.data); }
    .main_80324C8C 0x80324C8C : AT(0x00025C8C) { FILL(0x00000000); build/asm/main_80324C8C.s.o(.text); build/asm/main_80324C8C.s.o(.rodata); build/asm/main_80324C8C.s.o(.data); }
    .main_80324C8C_bss (NOLOAD) : { build/asm/main_80324C8C.s.o(.bss); }
    .main_80324C98 0x80324C98 : AT(0x00025C98) { build/asm/data/main_80324C98.bin.o(.data); }
    .main_803277BC 0x803277BC : AT(0x000287BC) { FILL(0x00000000); build/asm/main_803277BC.s.o(.text); build/asm/main_803277BC.s.o(.rodata); build/asm/main_803277BC.s.o(.data); }
    .main_803277BC_bss (NOLOAD) : { build/asm/main_803277BC.s.o(.bss); }
    .main_80327800 0x80327800 : AT(0x00028800) { build/asm/data/main_80327800.bin.o(.data); }
    .main_80328F4C 0x80328F4C : AT(0x00029F4C) { FILL(0x00000000); build/asm/main_80328F4C.s.o(.text); build/asm/main_80328F4C.s.o(.rodata); build/asm/main_80328F4C.s.o(.data); }
    .main_80328F4C_bss (NOLOAD) : { build/asm/main_80328F4C.s.o(.bss); }
    .main_80328FA0 0x80328FA0 : AT(0x00029FA0) { build/asm/data/main_80328FA0.bin.o(.data); }
    .main_8032B62C 0x8032B62C : AT(0x0002C62C) { FILL(0x00000000); build/asm/main_8032B62C.s.o(.text); build/asm/main_8032B62C.s.o(.rodata); build/asm/main_8032B62C.s.o(.data); }
    .main_8032B62C_bss (NOLOAD) : { build/asm/main_8032B62C.s.o(.bss); }
    .main_8032B6F4 0x8032B6F4 : AT(0x0002C6F4) { build/asm/data/main_8032B6F4.bin.o(.data); }
    .main_8032CB18 0x8032CB18 : AT(0x0002DB18) { FILL(0x00000000); build/asm/main_8032CB18.s.o(.text); build/asm/main_8032CB18.s.o(.rodata); build/asm/main_8032CB18.s.o(.data); }
    .main_8032CB18_bss (NOLOAD) : { build/asm/main_8032CB18.s.o(.bss); }
    .main_8032CB24 0x8032CB24 : AT(0x0002DB24) { build/asm/data/main_8032CB24.bin.o(.data); }
    .main_8032E634 0x8032E634 : AT(0x0002F634) { FILL(0x00000000); build/asm/main_8032E634.s.o(.text); build/asm/main_8032E634.s.o(.rodata); build/asm/main_8032E634.s.o(.data); }
    .main_8032E634_bss (NOLOAD) : { build/asm/main_8032E634.s.o(.bss); }
    .main_8032E64C 0x8032E64C : AT(0x0002F64C) { build/asm/data/main_8032E64C.bin.o(.data); }
    .main_8032E81C 0x8032E81C : AT(0x0002F81C) { FILL(0x00000000); build/asm/main_8032E81C.s.o(.text); build/asm/main_8032E81C.s.o(.rodata); build/asm/main_8032E81C.s.o(.data); }
    .main_8032E81C_bss (NOLOAD) : { build/asm/main_8032E81C.s.o(.bss); }
    .main_8032E830 0x8032E830 : AT(0x0002F830) { build/asm/data/main_8032E830.bin.o(.data); }
    .main_80330A6C 0x80330A6C : AT(0x00031A6C) { FILL(0x00000000); build/asm/main_80330A6C.s.o(.text); build/asm/main_80330A6C.s.o(.rodata); build/asm/main_80330A6C.s.o(.data); }
    .main_80330A6C_bss (NOLOAD) : { build/asm/main_80330A6C.s.o(.bss); }
    .main_80330D6C 0x80330D6C : AT(0x00031D6C) { build/asm/data/main_80330D6C.bin.o(.data); }
    .main_80332DFC 0x80332DFC : AT(0x00033DFC) { FILL(0x00000000); build/asm/main_80332DFC.s.o(.text); build/asm/main_80332DFC.s.o(.rodata); build/asm/main_80332DFC.s.o(.data); }
    .main_80332DFC_bss (NOLOAD) : { build/asm/main_80332DFC.s.o(.bss); }
    .main_80332E3C 0x80332E3C : AT(0x00033E3C) { build/asm/data/main_80332E3C.bin.o(.data); }
    .main_80333680 0x80333680 : AT(0x00034680) { FILL(0x00000000); build/asm/main_80333680.s.o(.text); build/asm/main_80333680.s.o(.rodata); build/asm/main_80333680.s.o(.data); }
    .main_80333680_bss (NOLOAD) : { build/asm/main_80333680.s.o(.bss); }
    .main_80333684 0x80333684 : AT(0x00034684) { build/asm/data/main_80333684.bin.o(.data); }
    .main_8033721C 0x8033721C : AT(0x0003821C) { FILL(0x00000000); build/asm/main_8033721C.s.o(.text); build/asm/main_8033721C.s.o(.rodata); build/asm/main_8033721C.s.o(.data); }
    .main_8033721C_bss (NOLOAD) : { build/asm/main_8033721C.s.o(.bss); }
    .main_803372BC 0x803372BC : AT(0x000382BC) { build/asm/data/main_803372BC.bin.o(.data); }
    .main_80337860 0x80337860 : AT(0x00038860) { FILL(0x00000000); build/asm/main_80337860.s.o(.text); build/asm/main_80337860.s.o(.rodata); build/asm/main_80337860.s.o(.data); }
    .main_80337860_bss (NOLOAD) : { build/asm/main_80337860.s.o(.bss); }
    .main_80337998 0x80337998 : AT(0x00038998) { build/asm/data/main_80337998.bin.o(.data); }
    .main_80338978 0x80338978 : AT(0x00039978) { FILL(0x00000000); build/asm/main_80338978.s.o(.text); build/asm/main_80338978.s.o(.rodata); build/asm/main_80338978.s.o(.data); }
    .main_80338978_bss (NOLOAD) : { build/asm/main_80338978.s.o(.bss); }
    .main_80338B00 0x80338B00 : AT(0x00039B00) { build/asm/data/main_80338B00.bin.o(.data); }
    .main_803396EC 0x803396EC : AT(0x0003A6EC) { FILL(0x00000000); build/asm/main_803396EC.s.o(.text); build/asm/main_803396EC.s.o(.rodata); build/asm/main_803396EC.s.o(.data); }
    .main_803396EC_bss (NOLOAD) : { build/asm/main_803396EC.s.o(.bss); }
    .main_80339984 0x80339984 : AT(0x0003A984) { build/asm/data/main_80339984.bin.o(.data); }
    .main_80339CC8 0x80339CC8 : AT(0x0003ACC8) { FILL(0x00000000); build/asm/main_80339CC8.s.o(.text); build/asm/main_80339CC8.s.o(.rodata); build/asm/main_80339CC8.s.o(.data); }
    .main_80339CC8_bss (NOLOAD) : { build/asm/main_80339CC8.s.o(.bss); }
    .main_80339DD0 0x80339DD0 : AT(0x0003ADD0) { build/asm/data/main_80339DD0.bin.o(.data); }
    .main_80339F0C 0x80339F0C : AT(0x0003AF0C) { FILL(0x00000000); build/asm/main_80339F0C.s.o(.text); build/asm/main_80339F0C.s.o(.rodata); build/asm/main_80339F0C.s.o(.data); }
    .main_80339F0C_bss (NOLOAD) : { build/asm/main_80339F0C.s.o(.bss); }
    .main_80339FE4 0x80339FE4 : AT(0x0003AFE4) { build/asm/data/main_80339FE4.bin.o(.data); }
    .main_8033A638 0x8033A638 : AT(0x0003B638) { FILL(0x00000000); build/asm/main_8033A638.s.o(.text); build/asm/main_8033A638.s.o(.rodata); build/asm/main_8033A638.s.o(.data); }
    .main_8033A638_bss (NOLOAD) : { build/asm/main_8033A638.s.o(.bss); }
    .main_8033A6A8 0x8033A6A8 : AT(0x0003B6A8) { build/asm/data/main_8033A6A8.bin.o(.data); }
    .main_8033D1E4 0x8033D1E4 : AT(0x0003E1E4) { FILL(0x00000000); build/asm/main_8033D1E4.s.o(.text); build/asm/main_8033D1E4.s.o(.rodata); build/asm/main_8033D1E4.s.o(.data); }
    .main_8033D1E4_bss (NOLOAD) : { build/asm/main_8033D1E4.s.o(.bss); }
    .main_8033D43C 0x8033D43C : AT(0x0003E43C) { build/asm/data/main_8033D43C.bin.o(.data); }
    .main_8033DBD8 0x8033DBD8 : AT(0x0003EBD8) { FILL(0x00000000); build/asm/main_8033DBD8.s.o(.text); build/asm/main_8033DBD8.s.o(.rodata); build/asm/main_8033DBD8.s.o(.data); }
    .main_8033DBD8_bss (NOLOAD) : { build/asm/main_8033DBD8.s.o(.bss); }
    .main_8033DD68 0x8033DD68 : AT(0x0003ED68) { build/asm/data/main_8033DD68.bin.o(.data); }
    .main_8033DFC0 0x8033DFC0 : AT(0x0003EFC0) { FILL(0x00000000); build/asm/main_8033DFC0.s.o(.text); build/asm/main_8033DFC0.s.o(.rodata); build/asm/main_8033DFC0.s.o(.data); }
    .main_8033DFC0_bss (NOLOAD) : { build/asm/main_8033DFC0.s.o(.bss); }
    .main_8033DFD4 0x8033DFD4 : AT(0x0003EFD4) { build/asm/data/main_8033DFD4.bin.o(.data); }
    .main_8033EC30 0x8033EC30 : AT(0x0003FC30) { FILL(0x00000000); build/asm/main_8033EC30.s.o(.text); build/asm/main_8033EC30.s.o(.rodata); build/asm/main_8033EC30.s.o(.data); }
    .main_8033EC30_bss (NOLOAD) : { build/asm/main_8033EC30.s.o(.bss); }
    .main_8033ECAC 0x8033ECAC : AT(0x0003FCAC) { build/asm/data/main_8033ECAC.bin.o(.data); }
    .main_8033ED00 0x8033ED00 : AT(0x0003FD00) { FILL(0x00000000); build/asm/main_8033ED00.s.o(.text); build/asm/main_8033ED00.s.o(.rodata); build/asm/main_8033ED00.s.o(.data); }
    .main_8033ED00_bss (NOLOAD) : { build/asm/main_8033ED00.s.o(.bss); }
    .main_8033ED50 0x8033ED50 : AT(0x0003FD50) { build/asm/data/main_8033ED50.bin.o(.data); }
    .main_8033F8DC 0x8033F8DC : AT(0x000408DC) { FILL(0x00000000); build/asm/main_8033F8DC.s.o(.text); build/asm/main_8033F8DC.s.o(.rodata); build/asm/main_8033F8DC.s.o(.data); }
    .main_8033F8DC_bss (NOLOAD) : { build/asm/main_8033F8DC.s.o(.bss); }
    .main_8033F934 0x8033F934 : AT(0x00040934) { build/asm/data/main_8033F934.bin.o(.data); }
    .main_8033FC30 0x8033FC30 : AT(0x00040C30) { FILL(0x00000000); build/asm/main_8033FC30.s.o(.text); build/asm/main_8033FC30.s.o(.rodata); build/asm/main_8033FC30.s.o(.data); }
    .main_8033FC30_bss (NOLOAD) : { build/asm/main_8033FC30.s.o(.bss); }
    .main_8033FC64 0x8033FC64 : AT(0x00040C64) { build/asm/data/main_8033FC64.bin.o(.data); }
    .main_80340678 0x80340678 : AT(0x00041678) { FILL(0x00000000); build/asm/main_80340678.s.o(.text); build/asm/main_80340678.s.o(.rodata); build/asm/main_80340678.s.o(.data); }
    .main_80340678_bss (NOLOAD) : { build/asm/main_80340678.s.o(.bss); }
    .main_803406F0 0x803406F0 : AT(0x000416F0) { build/asm/data/main_803406F0.bin.o(.data); }
    .main_80341104 0x80341104 : AT(0x00042104) { FILL(0x00000000); build/asm/main_80341104.s.o(.text); build/asm/main_80341104.s.o(.rodata); build/asm/main_80341104.s.o(.data); }
    .main_80341104_bss (NOLOAD) : { build/asm/main_80341104.s.o(.bss); }
    .main_80341128 0x80341128 : AT(0x00042128) { build/asm/data/main_80341128.bin.o(.data); }
    .main_80341864 0x80341864 : AT(0x00042864) { FILL(0x00000000); build/asm/main_80341864.s.o(.text); build/asm/main_80341864.s.o(.rodata); build/asm/main_80341864.s.o(.data); }
    .main_80341864_bss (NOLOAD) : { build/asm/main_80341864.s.o(.bss); }
    .main_803419BC 0x803419BC : AT(0x000429BC) { build/asm/data/main_803419BC.bin.o(.data); }
    .main_80341E50 0x80341E50 : AT(0x00042E50) { FILL(0x00000000); build/asm/main_80341E50.s.o(.text); build/asm/main_80341E50.s.o(.rodata); build/asm/main_80341E50.s.o(.data); }
    .main_80341E50_bss (NOLOAD) : { build/asm/main_80341E50.s.o(.bss); }
    .main_80341E8C 0x80341E8C : AT(0x00042E8C) { build/asm/data/main_80341E8C.bin.o(.data); }
    .main_80342E48 0x80342E48 : AT(0x00043E48) { FILL(0x00000000); build/asm/main_80342E48.s.o(.text); build/asm/main_80342E48.s.o(.rodata); build/asm/main_80342E48.s.o(.data); }
    .main_80342E48_bss (NOLOAD) : { build/asm/main_80342E48.s.o(.bss); }
    .main_80344180 0x80344180 : AT(0x00045180) { build/asm/data/main_80344180.bin.o(.data); }
    .main_80360A20 0x80360A20 : AT(0x00061A20) { FILL(0x00000000); build/asm/main_80360A20.s.o(.text); build/asm/main_80360A20.s.o(.rodata); build/asm/main_80360A20.s.o(.data); }
    .main_80360A20_bss (NOLOAD) : { build/asm/main_80360A20.s.o(.bss); }
    .main_80360A28 0x80360A28 : AT(0x00061A28) { build/asm/data/main_80360A28.bin.o(.data); }
    .main_80369E6C 0x80369E6C : AT(0x0006AE6C) { FILL(0x00000000); build/asm/main_80369E6C.s.o(.text); build/asm/main_80369E6C.s.o(.rodata); build/asm/main_80369E6C.s.o(.data); }
    .main_80369E6C_bss (NOLOAD) : { build/asm/main_80369E6C.s.o(.bss); }
    .main_80369E70 0x80369E70 : AT(0x0006AE70) { build/asm/data/main_80369E70.bin.o(.data); }
    .main_803809B8 0x803809B8 : AT(0x000819B8) { FILL(0x00000000); build/asm/main_803809B8.s.o(.text); build/asm/main_803809B8.s.o(.rodata); build/asm/main_803809B8.s.o(.data); }
    .main_803809B8_bss (NOLOAD) : { build/asm/main_803809B8.s.o(.bss); }
    .main_803809FC 0x803809FC : AT(0x000819FC) { build/asm/data/main_803809FC.bin.o(.data); }
    .main_8038BA6C 0x8038BA6C : AT(0x0008CA6C) { FILL(0x00000000); build/asm/main_8038BA6C.s.o(.text); build/asm/main_8038BA6C.s.o(.rodata); build/asm/main_8038BA6C.s.o(.data); }
    .main_8038BA6C_bss (NOLOAD) : { build/asm/main_8038BA6C.s.o(.bss); }
    .main_8038BAAC 0x8038BAAC : AT(0x0008CAAC) { build/asm/data/main_8038BAAC.bin.o(.data); }
    .main_80399994 0x80399994 : AT(0x0009A994) { FILL(0x00000000); build/asm/main_80399994.s.o(.text); build/asm/main_80399994.s.o(.rodata); build/asm/main_80399994.s.o(.data); }
    .main_80399994_bss (NOLOAD) : { build/asm/main_80399994.s.o(.bss); }
    .main_8039999C 0x8039999C : AT(0x0009A99C) { build/asm/data/main_8039999C.bin.o(.data); }
    .main_8039CE74 0x8039CE74 : AT(0x0009DE74) { FILL(0x00000000); build/asm/main_8039CE74.s.o(.text); build/asm/main_8039CE74.s.o(.rodata); build/asm/main_8039CE74.s.o(.data); }
    .main_8039CE74_bss (NOLOAD) : { build/asm/main_8039CE74.s.o(.bss); }
    .main_8039CE80 0x8039CE80 : AT(0x0009DE80) { build/asm/data/main_8039CE80.bin.o(.data); }
    .main_803A2658 0x803A2658 : AT(0x000A3658) { FILL(0x00000000); build/asm/main_803A2658.s.o(.text); build/asm/main_803A2658.s.o(.rodata); build/asm/main_803A2658.s.o(.data); }
    .main_803A2658_bss (NOLOAD) : { build/asm/main_803A2658.s.o(.bss); }
    .main_803A265C 0x803A265C : AT(0x000A365C) { build/asm/data/main_803A265C.bin.o(.data); }
    .main_803A6690 0x803A6690 : AT(0x000A7690) { FILL(0x00000000); build/asm/main_803A6690.s.o(.text); build/asm/main_803A6690.s.o(.rodata); build/asm/main_803A6690.s.o(.data); }
    .main_803A6690_bss (NOLOAD) : { build/asm/main_803A6690.s.o(.bss); }
    .main_803A66A4 0x803A66A4 : AT(0x000A76A4) { build/asm/data/main_803A66A4.bin.o(.data); }
    .main_803B685C 0x803B685C : AT(0x000B785C) { FILL(0x00000000); build/asm/main_803B685C.s.o(.text); build/asm/main_803B685C.s.o(.rodata); build/asm/main_803B685C.s.o(.data); }
    .main_803B685C_bss (NOLOAD) : { build/asm/main_803B685C.s.o(.bss); }
    .main_803B6860 0x803B6860 : AT(0x000B7860) { build/asm/data/main_803B6860.bin.o(.data); }
    .main_803BA71C 0x803BA71C : AT(0x000BB71C) { FILL(0x00000000); build/asm/main_803BA71C.s.o(.text); build/asm/main_803BA71C.s.o(.rodata); build/asm/main_803BA71C.s.o(.data); }
    .main_803BA71C_bss (NOLOAD) : { build/asm/main_803BA71C.s.o(.bss); }
    .main_803BA758 0x803BA758 : AT(0x000BB758) { build/asm/data/main_803BA758.bin.o(.data); }
    .main_803D2D44 0x803D2D44 : AT(0x000D3D44) { FILL(0x00000000); build/asm/main_803D2D44.s.o(.text); build/asm/main_803D2D44.s.o(.rodata); build/asm/main_803D2D44.s.o(.data); }
    .main_803D2D44_bss (NOLOAD) : { build/asm/main_803D2D44.s.o(.bss); }
    .main_803D2D58 0x803D2D58 : AT(0x000D3D58) { build/asm/data/main_803D2D58.bin.o(.data); }
    .main_803D3E00 0x803D3E00 : AT(0x000D4E00) { FILL(0x00000000); build/asm/main_803D3E00.s.o(.text); build/asm/main_803D3E00.s.o(.rodata); build/asm/main_803D3E00.s.o(.data); }
    .main_803D3E00_bss (NOLOAD) : { build/asm/main_803D3E00.s.o(.bss); }
    .main_803D3E40 0x803D3E40 : AT(0x000D4E40) { build/asm/data/main_803D3E40.bin.o(.data); }
    .main_803D8800 0x803D8800 : AT(0x000D9800) { FILL(0x00000000); build/asm/main_803D8800.s.o(.text); build/asm/main_803D8800.s.o(.rodata); build/asm/main_803D8800.s.o(.data); }
    .main_803D8800_bss (NOLOAD) : { build/asm/main_803D8800.s.o(.bss); }
    .main_803D8814 0x803D8814 : AT(0x000D9814) { build/asm/data/main_803D8814.bin.o(.data); }
    .main_803DF548 0x803DF548 : AT(0x000E0548) { FILL(0x00000000); build/asm/main_803DF548.s.o(.text); build/asm/main_803DF548.s.o(.rodata); build/asm/main_803DF548.s.o(.data); }
    .main_803DF548_bss (NOLOAD) : { build/asm/main_803DF548.s.o(.bss); }
    .main_803DF558 0x803DF558 : AT(0x000E0558) { build/asm/data/main_803DF558.bin.o(.data); }
    .main_803EA36C 0x803EA36C : AT(0x000EB36C) { FILL(0x00000000); build/asm/main_803EA36C.s.o(.text); build/asm/main_803EA36C.s.o(.rodata); build/asm/main_803EA36C.s.o(.data); }
    .main_803EA36C_bss (NOLOAD) : { build/asm/main_803EA36C.s.o(.bss); }
    .main_803EA3A8 0x803EA3A8 : AT(0x000EB3A8) { build/asm/data/main_803EA3A8.bin.o(.data); }
    .main_803EAE18 0x803EAE18 : AT(0x000EBE18) { FILL(0x00000000); build/asm/main_803EAE18.s.o(.text); build/asm/main_803EAE18.s.o(.rodata); build/asm/main_803EAE18.s.o(.data); }
    .main_803EAE18_bss (NOLOAD) : { build/asm/main_803EAE18.s.o(.bss); }
    .main_803EAE50 0x803EAE50 : AT(0x000EBE50) { build/asm/data/main_803EAE50.bin.o(.data); }
    .main_803F06AC 0x803F06AC : AT(0x000F16AC) { FILL(0x00000000); build/asm/main_803F06AC.s.o(.text); build/asm/main_803F06AC.s.o(.rodata); build/asm/main_803F06AC.s.o(.data); }
    .main_803F06AC_bss (NOLOAD) : { build/asm/main_803F06AC.s.o(.bss); }
    .main_803F06D0 0x803F06D0 : AT(0x000F16D0) { build/asm/data/main_803F06D0.bin.o(.data); }
    .assets 0x80700000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
