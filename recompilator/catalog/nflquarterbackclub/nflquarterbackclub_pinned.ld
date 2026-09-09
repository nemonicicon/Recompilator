SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80300000 0x80300000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80300000.s.o(.text); build/asm/main_80300000.s.o(.rodata); build/asm/main_80300000.s.o(.data); }
    .main_80300000_bss (NOLOAD) : { build/asm/main_80300000.s.o(.bss); }
    .main_80300040 0x80300040 : AT(0x00001040) { FILL(0x00000000); build/asm/main_80300040.s.o(.text); build/asm/main_80300040.s.o(.rodata); build/asm/main_80300040.s.o(.data); }
    .main_80300040_bss (NOLOAD) : { build/asm/main_80300040.s.o(.bss); }
    .main_80300BC8 0x80300BC8 : AT(0x00001BC8) { build/asm/data/main_80300BC8.bin.o(.data); }
    .main_803086BC 0x803086BC : AT(0x000096BC) { FILL(0x00000000); build/asm/main_803086BC.s.o(.text); build/asm/main_803086BC.s.o(.rodata); build/asm/main_803086BC.s.o(.data); }
    .main_803086BC_bss (NOLOAD) : { build/asm/main_803086BC.s.o(.bss); }
    .main_803086F4 0x803086F4 : AT(0x000096F4) { build/asm/data/main_803086F4.bin.o(.data); }
    .main_80313378 0x80313378 : AT(0x00014378) { FILL(0x00000000); build/asm/main_80313378.s.o(.text); build/asm/main_80313378.s.o(.rodata); build/asm/main_80313378.s.o(.data); }
    .main_80313378_bss (NOLOAD) : { build/asm/main_80313378.s.o(.bss); }
    .main_80313404 0x80313404 : AT(0x00014404) { build/asm/data/main_80313404.bin.o(.data); }
    .main_8031C6C8 0x8031C6C8 : AT(0x0001D6C8) { FILL(0x00000000); build/asm/main_8031C6C8.s.o(.text); build/asm/main_8031C6C8.s.o(.rodata); build/asm/main_8031C6C8.s.o(.data); }
    .main_8031C6C8_bss (NOLOAD) : { build/asm/main_8031C6C8.s.o(.bss); }
    .main_8031C6E0 0x8031C6E0 : AT(0x0001D6E0) { build/asm/data/main_8031C6E0.bin.o(.data); }
    .main_803206BC 0x803206BC : AT(0x000216BC) { FILL(0x00000000); build/asm/main_803206BC.s.o(.text); build/asm/main_803206BC.s.o(.rodata); build/asm/main_803206BC.s.o(.data); }
    .main_803206BC_bss (NOLOAD) : { build/asm/main_803206BC.s.o(.bss); }
    .main_803206F0 0x803206F0 : AT(0x000216F0) { build/asm/data/main_803206F0.bin.o(.data); }
    .main_80320944 0x80320944 : AT(0x00021944) { FILL(0x00000000); build/asm/main_80320944.s.o(.text); build/asm/main_80320944.s.o(.rodata); build/asm/main_80320944.s.o(.data); }
    .main_80320944_bss (NOLOAD) : { build/asm/main_80320944.s.o(.bss); }
    .main_80320958 0x80320958 : AT(0x00021958) { build/asm/data/main_80320958.bin.o(.data); }
    .main_80320B54 0x80320B54 : AT(0x00021B54) { FILL(0x00000000); build/asm/main_80320B54.s.o(.text); build/asm/main_80320B54.s.o(.rodata); build/asm/main_80320B54.s.o(.data); }
    .main_80320B54_bss (NOLOAD) : { build/asm/main_80320B54.s.o(.bss); }
    .main_80320B78 0x80320B78 : AT(0x00021B78) { build/asm/data/main_80320B78.bin.o(.data); }
    .main_8033B4F4 0x8033B4F4 : AT(0x0003C4F4) { FILL(0x00000000); build/asm/main_8033B4F4.s.o(.text); build/asm/main_8033B4F4.s.o(.rodata); build/asm/main_8033B4F4.s.o(.data); }
    .main_8033B4F4_bss (NOLOAD) : { build/asm/main_8033B4F4.s.o(.bss); }
    .main_8033B504 0x8033B504 : AT(0x0003C504) { build/asm/data/main_8033B504.bin.o(.data); }
    .main_8033C668 0x8033C668 : AT(0x0003D668) { FILL(0x00000000); build/asm/main_8033C668.s.o(.text); build/asm/main_8033C668.s.o(.rodata); build/asm/main_8033C668.s.o(.data); }
    .main_8033C668_bss (NOLOAD) : { build/asm/main_8033C668.s.o(.bss); }
    .main_8033C69C 0x8033C69C : AT(0x0003D69C) { build/asm/data/main_8033C69C.bin.o(.data); }
    .main_8033C9D0 0x8033C9D0 : AT(0x0003D9D0) { FILL(0x00000000); build/asm/main_8033C9D0.s.o(.text); build/asm/main_8033C9D0.s.o(.rodata); build/asm/main_8033C9D0.s.o(.data); }
    .main_8033C9D0_bss (NOLOAD) : { build/asm/main_8033C9D0.s.o(.bss); }
    .main_8033C9E0 0x8033C9E0 : AT(0x0003D9E0) { build/asm/data/main_8033C9E0.bin.o(.data); }
    .main_80343838 0x80343838 : AT(0x00044838) { FILL(0x00000000); build/asm/main_80343838.s.o(.text); build/asm/main_80343838.s.o(.rodata); build/asm/main_80343838.s.o(.data); }
    .main_80343838_bss (NOLOAD) : { build/asm/main_80343838.s.o(.bss); }
    .main_8034383C 0x8034383C : AT(0x0004483C) { build/asm/data/main_8034383C.bin.o(.data); }
    .main_8034D318 0x8034D318 : AT(0x0004E318) { FILL(0x00000000); build/asm/main_8034D318.s.o(.text); build/asm/main_8034D318.s.o(.rodata); build/asm/main_8034D318.s.o(.data); }
    .main_8034D318_bss (NOLOAD) : { build/asm/main_8034D318.s.o(.bss); }
    .main_8034D358 0x8034D358 : AT(0x0004E358) { build/asm/data/main_8034D358.bin.o(.data); }
    .main_80352A58 0x80352A58 : AT(0x00053A58) { FILL(0x00000000); build/asm/main_80352A58.s.o(.text); build/asm/main_80352A58.s.o(.rodata); build/asm/main_80352A58.s.o(.data); }
    .main_80352A58_bss (NOLOAD) : { build/asm/main_80352A58.s.o(.bss); }
    .main_80352A68 0x80352A68 : AT(0x00053A68) { build/asm/data/main_80352A68.bin.o(.data); }
    .main_80353FC8 0x80353FC8 : AT(0x00054FC8) { FILL(0x00000000); build/asm/main_80353FC8.s.o(.text); build/asm/main_80353FC8.s.o(.rodata); build/asm/main_80353FC8.s.o(.data); }
    .main_80353FC8_bss (NOLOAD) : { build/asm/main_80353FC8.s.o(.bss); }
    .main_80353FF4 0x80353FF4 : AT(0x00054FF4) { build/asm/data/main_80353FF4.bin.o(.data); }
    .main_8035865C 0x8035865C : AT(0x0005965C) { FILL(0x00000000); build/asm/main_8035865C.s.o(.text); build/asm/main_8035865C.s.o(.rodata); build/asm/main_8035865C.s.o(.data); }
    .main_8035865C_bss (NOLOAD) : { build/asm/main_8035865C.s.o(.bss); }
    .main_80358670 0x80358670 : AT(0x00059670) { build/asm/data/main_80358670.bin.o(.data); }
    .main_8035A2D0 0x8035A2D0 : AT(0x0005B2D0) { FILL(0x00000000); build/asm/main_8035A2D0.s.o(.text); build/asm/main_8035A2D0.s.o(.rodata); build/asm/main_8035A2D0.s.o(.data); }
    .main_8035A2D0_bss (NOLOAD) : { build/asm/main_8035A2D0.s.o(.bss); }
    .main_8035A2F8 0x8035A2F8 : AT(0x0005B2F8) { build/asm/data/main_8035A2F8.bin.o(.data); }
    .main_8036CF1C 0x8036CF1C : AT(0x0006DF1C) { FILL(0x00000000); build/asm/main_8036CF1C.s.o(.text); build/asm/main_8036CF1C.s.o(.rodata); build/asm/main_8036CF1C.s.o(.data); }
    .main_8036CF1C_bss (NOLOAD) : { build/asm/main_8036CF1C.s.o(.bss); }
    .main_8036CFD8 0x8036CFD8 : AT(0x0006DFD8) { build/asm/data/main_8036CFD8.bin.o(.data); }
    .main_8036FF88 0x8036FF88 : AT(0x00070F88) { FILL(0x00000000); build/asm/main_8036FF88.s.o(.text); build/asm/main_8036FF88.s.o(.rodata); build/asm/main_8036FF88.s.o(.data); }
    .main_8036FF88_bss (NOLOAD) : { build/asm/main_8036FF88.s.o(.bss); }
    .main_803700A8 0x803700A8 : AT(0x000710A8) { build/asm/data/main_803700A8.bin.o(.data); }
    .main_80372834 0x80372834 : AT(0x00073834) { FILL(0x00000000); build/asm/main_80372834.s.o(.text); build/asm/main_80372834.s.o(.rodata); build/asm/main_80372834.s.o(.data); }
    .main_80372834_bss (NOLOAD) : { build/asm/main_80372834.s.o(.bss); }
    .main_8037283C 0x8037283C : AT(0x0007383C) { build/asm/data/main_8037283C.bin.o(.data); }
    .main_80372E04 0x80372E04 : AT(0x00073E04) { FILL(0x00000000); build/asm/main_80372E04.s.o(.text); build/asm/main_80372E04.s.o(.rodata); build/asm/main_80372E04.s.o(.data); }
    .main_80372E04_bss (NOLOAD) : { build/asm/main_80372E04.s.o(.bss); }
    .main_80373014 0x80373014 : AT(0x00074014) { build/asm/data/main_80373014.bin.o(.data); }
    .main_80373884 0x80373884 : AT(0x00074884) { FILL(0x00000000); build/asm/main_80373884.s.o(.text); build/asm/main_80373884.s.o(.rodata); build/asm/main_80373884.s.o(.data); }
    .main_80373884_bss (NOLOAD) : { build/asm/main_80373884.s.o(.bss); }
    .main_803738D0 0x803738D0 : AT(0x000748D0) { build/asm/data/main_803738D0.bin.o(.data); }
    .main_803790F8 0x803790F8 : AT(0x0007A0F8) { FILL(0x00000000); build/asm/main_803790F8.s.o(.text); build/asm/main_803790F8.s.o(.rodata); build/asm/main_803790F8.s.o(.data); }
    .main_803790F8_bss (NOLOAD) : { build/asm/main_803790F8.s.o(.bss); }
    .main_8037910C 0x8037910C : AT(0x0007A10C) { build/asm/data/main_8037910C.bin.o(.data); }
    .main_80393004 0x80393004 : AT(0x00094004) { FILL(0x00000000); build/asm/main_80393004.s.o(.text); build/asm/main_80393004.s.o(.rodata); build/asm/main_80393004.s.o(.data); }
    .main_80393004_bss (NOLOAD) : { build/asm/main_80393004.s.o(.bss); }
    .main_80393030 0x80393030 : AT(0x00094030) { build/asm/data/main_80393030.bin.o(.data); }
    .main_803A28E0 0x803A28E0 : AT(0x000A38E0) { FILL(0x00000000); build/asm/main_803A28E0.s.o(.text); build/asm/main_803A28E0.s.o(.rodata); build/asm/main_803A28E0.s.o(.data); }
    .main_803A28E0_bss (NOLOAD) : { build/asm/main_803A28E0.s.o(.bss); }
    .main_803A296C 0x803A296C : AT(0x000A396C) { build/asm/data/main_803A296C.bin.o(.data); }
    .main_803A2D7C 0x803A2D7C : AT(0x000A3D7C) { FILL(0x00000000); build/asm/main_803A2D7C.s.o(.text); build/asm/main_803A2D7C.s.o(.rodata); build/asm/main_803A2D7C.s.o(.data); }
    .main_803A2D7C_bss (NOLOAD) : { build/asm/main_803A2D7C.s.o(.bss); }
    .main_803A2D88 0x803A2D88 : AT(0x000A3D88) { build/asm/data/main_803A2D88.bin.o(.data); }
    .main_803A307C 0x803A307C : AT(0x000A407C) { FILL(0x00000000); build/asm/main_803A307C.s.o(.text); build/asm/main_803A307C.s.o(.rodata); build/asm/main_803A307C.s.o(.data); }
    .main_803A307C_bss (NOLOAD) : { build/asm/main_803A307C.s.o(.bss); }
    .main_803A3108 0x803A3108 : AT(0x000A4108) { build/asm/data/main_803A3108.bin.o(.data); }
    .main_803BE7D0 0x803BE7D0 : AT(0x000BF7D0) { FILL(0x00000000); build/asm/main_803BE7D0.s.o(.text); build/asm/main_803BE7D0.s.o(.rodata); build/asm/main_803BE7D0.s.o(.data); }
    .main_803BE7D0_bss (NOLOAD) : { build/asm/main_803BE7D0.s.o(.bss); }
    .main_803BE7DC 0x803BE7DC : AT(0x000BF7DC) { build/asm/data/main_803BE7DC.bin.o(.data); }
    .main_803D27D4 0x803D27D4 : AT(0x000D37D4) { FILL(0x00000000); build/asm/main_803D27D4.s.o(.text); build/asm/main_803D27D4.s.o(.rodata); build/asm/main_803D27D4.s.o(.data); }
    .main_803D27D4_bss (NOLOAD) : { build/asm/main_803D27D4.s.o(.bss); }
    .main_803D2838 0x803D2838 : AT(0x000D3838) { build/asm/data/main_803D2838.bin.o(.data); }
    .assets 0x80700000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
