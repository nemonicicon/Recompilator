SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_802AD400 0x802AD400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_802AD400.s.o(.text); build/asm/main_802AD400.s.o(.rodata); build/asm/main_802AD400.s.o(.data); }
    .main_802AD400_bss (NOLOAD) : { build/asm/main_802AD400.s.o(.bss); }
    .main_802AD4C0 0x802AD4C0 : AT(0x000010C0) { FILL(0x00000000); build/asm/main_802AD4C0.s.o(.text); build/asm/main_802AD4C0.s.o(.rodata); build/asm/main_802AD4C0.s.o(.data); }
    .main_802AD4C0_bss (NOLOAD) : { build/asm/main_802AD4C0.s.o(.bss); }
    .main_8031A2E0 0x8031A2E0 : AT(0x0006DEE0) { FILL(0x00000000); build/asm/main_8031A2E0.s.o(.text); build/asm/main_8031A2E0.s.o(.rodata); build/asm/main_8031A2E0.s.o(.data); }
    .main_8031A2E0_bss (NOLOAD) : { build/asm/main_8031A2E0.s.o(.bss); }
    .main_8031A480 0x8031A480 : AT(0x0006E080) { FILL(0x00000000); build/asm/main_8031A480.s.o(.text); build/asm/main_8031A480.s.o(.rodata); build/asm/main_8031A480.s.o(.data); }
    .main_8031A480_bss (NOLOAD) : { build/asm/main_8031A480.s.o(.bss); }
    .main_8031A6E0 0x8031A6E0 : AT(0x0006E2E0) { FILL(0x00000000); build/asm/main_8031A6E0.s.o(.text); build/asm/main_8031A6E0.s.o(.rodata); build/asm/main_8031A6E0.s.o(.data); }
    .main_8031A6E0_bss (NOLOAD) : { build/asm/main_8031A6E0.s.o(.bss); }
    .main_8031D814 0x8031D814 : AT(0x00071414) { FILL(0x00000000); build/asm/main_8031D814.s.o(.text); build/asm/main_8031D814.s.o(.rodata); build/asm/main_8031D814.s.o(.data); }
    .main_8031D814_bss (NOLOAD) : { build/asm/main_8031D814.s.o(.bss); }
    .main_8031D908 0x8031D908 : AT(0x00071508) { FILL(0x00000000); build/asm/main_8031D908.s.o(.text); build/asm/main_8031D908.s.o(.rodata); build/asm/main_8031D908.s.o(.data); }
    .main_8031D908_bss (NOLOAD) : { build/asm/main_8031D908.s.o(.bss); }
    .main_8031DC40 0x8031DC40 : AT(0x00071840) { FILL(0x00000000); build/asm/main_8031DC40.s.o(.text); build/asm/main_8031DC40.s.o(.rodata); build/asm/main_8031DC40.s.o(.data); }
    .main_8031DC40_bss (NOLOAD) : { build/asm/main_8031DC40.s.o(.bss); }
    .main_8031EC70 0x8031EC70 : AT(0x00072870) { FILL(0x00000000); build/asm/main_8031EC70.s.o(.text); build/asm/main_8031EC70.s.o(.rodata); build/asm/main_8031EC70.s.o(.data); }
    .main_8031EC70_bss (NOLOAD) : { build/asm/main_8031EC70.s.o(.bss); }
    .main_8031F7E8 0x8031F7E8 : AT(0x000733E8) { FILL(0x00000000); build/asm/main_8031F7E8.s.o(.text); build/asm/main_8031F7E8.s.o(.rodata); build/asm/main_8031F7E8.s.o(.data); }
    .main_8031F7E8_bss (NOLOAD) : { build/asm/main_8031F7E8.s.o(.bss); }
    .main_8031FA30 0x8031FA30 : AT(0x00073630) { FILL(0x00000000); build/asm/main_8031FA30.s.o(.text); build/asm/main_8031FA30.s.o(.rodata); build/asm/main_8031FA30.s.o(.data); }
    .main_8031FA30_bss (NOLOAD) : { build/asm/main_8031FA30.s.o(.bss); }
    .main_803201B0 0x803201B0 : AT(0x00073DB0) { FILL(0x00000000); build/asm/main_803201B0.s.o(.text); build/asm/main_803201B0.s.o(.rodata); build/asm/main_803201B0.s.o(.data); }
    .main_803201B0_bss (NOLOAD) : { build/asm/main_803201B0.s.o(.bss); }
    .main_80320D54 0x80320D54 : AT(0x00074954) { FILL(0x00000000); build/asm/main_80320D54.s.o(.text); build/asm/main_80320D54.s.o(.rodata); build/asm/main_80320D54.s.o(.data); }
    .main_80320D54_bss (NOLOAD) : { build/asm/main_80320D54.s.o(.bss); }
    .main_80321E10 0x80321E10 : AT(0x00075A10) { FILL(0x00000000); build/asm/main_80321E10.s.o(.text); build/asm/main_80321E10.s.o(.rodata); build/asm/main_80321E10.s.o(.data); }
    .main_80321E10_bss (NOLOAD) : { build/asm/main_80321E10.s.o(.bss); }
    .main_80323120 0x80323120 : AT(0x00076D20) { FILL(0x00000000); build/asm/main_80323120.s.o(.text); build/asm/main_80323120.s.o(.rodata); build/asm/main_80323120.s.o(.data); }
    .main_80323120_bss (NOLOAD) : { build/asm/main_80323120.s.o(.bss); }
    .main_803233D0 0x803233D0 : AT(0x00076FD0) { FILL(0x00000000); build/asm/main_803233D0.s.o(.text); build/asm/main_803233D0.s.o(.rodata); build/asm/main_803233D0.s.o(.data); }
    .main_803233D0_bss (NOLOAD) : { build/asm/main_803233D0.s.o(.bss); }
    .main_80323540 0x80323540 : AT(0x00077140) { FILL(0x00000000); build/asm/main_80323540.s.o(.text); build/asm/main_80323540.s.o(.rodata); build/asm/main_80323540.s.o(.data); }
    .main_80323540_bss (NOLOAD) : { build/asm/main_80323540.s.o(.bss); }
    .main_80323B24 0x80323B24 : AT(0x00077724) { FILL(0x00000000); build/asm/main_80323B24.s.o(.text); build/asm/main_80323B24.s.o(.rodata); build/asm/main_80323B24.s.o(.data); }
    .main_80323B24_bss (NOLOAD) : { build/asm/main_80323B24.s.o(.bss); }
    .main_80323F70 0x80323F70 : AT(0x00077B70) { FILL(0x00000000); build/asm/main_80323F70.s.o(.text); build/asm/main_80323F70.s.o(.rodata); build/asm/main_80323F70.s.o(.data); }
    .main_80323F70_bss (NOLOAD) : { build/asm/main_80323F70.s.o(.bss); }
    .main_803240D0 0x803240D0 : AT(0x00077CD0) { FILL(0x00000000); build/asm/main_803240D0.s.o(.text); build/asm/main_803240D0.s.o(.rodata); build/asm/main_803240D0.s.o(.data); }
    .main_803240D0_bss (NOLOAD) : { build/asm/main_803240D0.s.o(.bss); }
    .main_803243F0 0x803243F0 : AT(0x00077FF0) { FILL(0x00000000); build/asm/main_803243F0.s.o(.text); build/asm/main_803243F0.s.o(.rodata); build/asm/main_803243F0.s.o(.data); }
    .main_803243F0_bss (NOLOAD) : { build/asm/main_803243F0.s.o(.bss); }
    .main_80324CE0 0x80324CE0 : AT(0x000788E0) { FILL(0x00000000); build/asm/main_80324CE0.s.o(.text); build/asm/main_80324CE0.s.o(.rodata); build/asm/main_80324CE0.s.o(.data); }
    .main_80324CE0_bss (NOLOAD) : { build/asm/main_80324CE0.s.o(.bss); }
    .main_80324D20 0x80324D20 : AT(0x00078920) { FILL(0x00000000); build/asm/main_80324D20.s.o(.text); build/asm/main_80324D20.s.o(.rodata); build/asm/main_80324D20.s.o(.data); }
    .main_80324D20_bss (NOLOAD) : { build/asm/main_80324D20.s.o(.bss); }
    .main_8032B070 0x8032B070 : AT(0x0007EC70) { FILL(0x00000000); build/asm/main_8032B070.s.o(.text); build/asm/main_8032B070.s.o(.rodata); build/asm/main_8032B070.s.o(.data); }
    .main_8032B070_bss (NOLOAD) : { build/asm/main_8032B070.s.o(.bss); }
    .main_8032B0C0 0x8032B0C0 : AT(0x0007ECC0) { FILL(0x00000000); build/asm/main_8032B0C0.s.o(.text); build/asm/main_8032B0C0.s.o(.rodata); build/asm/main_8032B0C0.s.o(.data); }
    .main_8032B0C0_bss (NOLOAD) : { build/asm/main_8032B0C0.s.o(.bss); }
    .main_8032B350 0x8032B350 : AT(0x0007EF50) { FILL(0x00000000); build/asm/main_8032B350.s.o(.text); build/asm/main_8032B350.s.o(.rodata); build/asm/main_8032B350.s.o(.data); }
    .main_8032B350_bss (NOLOAD) : { build/asm/main_8032B350.s.o(.bss); }
    .main_8032C0BC 0x8032C0BC : AT(0x0007FCBC) { FILL(0x00000000); build/asm/main_8032C0BC.s.o(.text); build/asm/main_8032C0BC.s.o(.rodata); build/asm/main_8032C0BC.s.o(.data); }
    .main_8032C0BC_bss (NOLOAD) : { build/asm/main_8032C0BC.s.o(.bss); }
    .main_8032C3AC 0x8032C3AC : AT(0x0007FFAC) { FILL(0x00000000); build/asm/main_8032C3AC.s.o(.text); build/asm/main_8032C3AC.s.o(.rodata); build/asm/main_8032C3AC.s.o(.data); }
    .main_8032C3AC_bss (NOLOAD) : { build/asm/main_8032C3AC.s.o(.bss); }
    .main_8032C7C0 0x8032C7C0 : AT(0x000803C0) { FILL(0x00000000); build/asm/main_8032C7C0.s.o(.text); build/asm/main_8032C7C0.s.o(.rodata); build/asm/main_8032C7C0.s.o(.data); }
    .main_8032C7C0_bss (NOLOAD) : { build/asm/main_8032C7C0.s.o(.bss); }
    .main_8032EB80 0x8032EB80 : AT(0x00082780) { FILL(0x00000000); build/asm/main_8032EB80.s.o(.text); build/asm/main_8032EB80.s.o(.rodata); build/asm/main_8032EB80.s.o(.data); }
    .main_8032EB80_bss (NOLOAD) : { build/asm/main_8032EB80.s.o(.bss); }
    .main_8033247C 0x8033247C : AT(0x0008607C) { FILL(0x00000000); build/asm/main_8033247C.s.o(.text); build/asm/main_8033247C.s.o(.rodata); build/asm/main_8033247C.s.o(.data); }
    .main_8033247C_bss (NOLOAD) : { build/asm/main_8033247C.s.o(.bss); }
    .main_8033DB48 0x8033DB48 : AT(0x00091748) { FILL(0x00000000); build/asm/main_8033DB48.s.o(.text); build/asm/main_8033DB48.s.o(.rodata); build/asm/main_8033DB48.s.o(.data); }
    .main_8033DB48_bss (NOLOAD) : { build/asm/main_8033DB48.s.o(.bss); }
    .main_8033DB5C 0x8033DB5C : AT(0x0009175C) { build/asm/data/main_8033DB5C.bin.o(.data); }
    .main_8033E554 0x8033E554 : AT(0x00092154) { FILL(0x00000000); build/asm/main_8033E554.s.o(.text); build/asm/main_8033E554.s.o(.rodata); build/asm/main_8033E554.s.o(.data); }
    .main_8033E554_bss (NOLOAD) : { build/asm/main_8033E554.s.o(.bss); }
    .main_80343364 0x80343364 : AT(0x00096F64) { build/asm/data/main_80343364.bin.o(.data); }
    .main_80343800 0x80343800 : AT(0x00097400) { FILL(0x00000000); build/asm/main_80343800.s.o(.text); build/asm/main_80343800.s.o(.rodata); build/asm/main_80343800.s.o(.data); }
    .main_80343800_bss (NOLOAD) : { build/asm/main_80343800.s.o(.bss); }
    .main_8034CD50 0x8034CD50 : AT(0x000A0950) { FILL(0x00000000); build/asm/main_8034CD50.s.o(.text); build/asm/main_8034CD50.s.o(.rodata); build/asm/main_8034CD50.s.o(.data); }
    .main_8034CD50_bss (NOLOAD) : { build/asm/main_8034CD50.s.o(.bss); }
    .main_8034D86C 0x8034D86C : AT(0x000A146C) { build/asm/data/main_8034D86C.bin.o(.data); }
    .main_8034EB48 0x8034EB48 : AT(0x000A2748) { FILL(0x00000000); build/asm/main_8034EB48.s.o(.text); build/asm/main_8034EB48.s.o(.rodata); build/asm/main_8034EB48.s.o(.data); }
    .main_8034EB48_bss (NOLOAD) : { build/asm/main_8034EB48.s.o(.bss); }
    .main_80352B20 0x80352B20 : AT(0x000A6720) { build/asm/data/main_80352B20.bin.o(.data); }
    .main_80354288 0x80354288 : AT(0x000A7E88) { FILL(0x00000000); build/asm/main_80354288.s.o(.text); build/asm/main_80354288.s.o(.rodata); build/asm/main_80354288.s.o(.data); }
    .main_80354288_bss (NOLOAD) : { build/asm/main_80354288.s.o(.bss); }
    .main_8035A1B4 0x8035A1B4 : AT(0x000ADDB4) { FILL(0x00000000); build/asm/main_8035A1B4.s.o(.text); build/asm/main_8035A1B4.s.o(.rodata); build/asm/main_8035A1B4.s.o(.data); }
    .main_8035A1B4_bss (NOLOAD) : { build/asm/main_8035A1B4.s.o(.bss); }
    .main_8035FDE8 0x8035FDE8 : AT(0x000B39E8) { FILL(0x00000000); build/asm/main_8035FDE8.s.o(.text); build/asm/main_8035FDE8.s.o(.rodata); build/asm/main_8035FDE8.s.o(.data); }
    .main_8035FDE8_bss (NOLOAD) : { build/asm/main_8035FDE8.s.o(.bss); }
    .main_80361588 0x80361588 : AT(0x000B5188) { FILL(0x00000000); build/asm/main_80361588.s.o(.text); build/asm/main_80361588.s.o(.rodata); build/asm/main_80361588.s.o(.data); }
    .main_80361588_bss (NOLOAD) : { build/asm/main_80361588.s.o(.bss); }
    .main_8036BCF8 0x8036BCF8 : AT(0x000BF8F8) { build/asm/data/main_8036BCF8.bin.o(.data); }
    .main_80383014 0x80383014 : AT(0x000D6C14) { FILL(0x00000000); build/asm/main_80383014.s.o(.text); build/asm/main_80383014.s.o(.rodata); build/asm/main_80383014.s.o(.data); }
    .main_80383014_bss (NOLOAD) : { build/asm/main_80383014.s.o(.bss); }
    .main_80383018 0x80383018 : AT(0x000D6C18) { build/asm/data/main_80383018.bin.o(.data); }
    .main_80383C38 0x80383C38 : AT(0x000D7838) { FILL(0x00000000); build/asm/main_80383C38.s.o(.text); build/asm/main_80383C38.s.o(.rodata); build/asm/main_80383C38.s.o(.data); }
    .main_80383C38_bss (NOLOAD) : { build/asm/main_80383C38.s.o(.bss); }
    .main_80383C3C 0x80383C3C : AT(0x000D783C) { build/asm/data/main_80383C3C.bin.o(.data); }
    .main_803937F8 0x803937F8 : AT(0x000E73F8) { build/asm/data/main_803937F8.bin.o(.data); }
    .main_80395DF0 0x80395DF0 : AT(0x000E99F0) { build/asm/data/main_80395DF0.bin.o(.data); }
    .main_803A4958 0x803A4958 : AT(0x000F8558) { build/asm/data/main_803A4958.bin.o(.data); }
    .main_803A4FE0 0x803A4FE0 : AT(0x000F8BE0) { build/asm/data/main_803A4FE0.bin.o(.data); }
    .assets 0x806AD400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
