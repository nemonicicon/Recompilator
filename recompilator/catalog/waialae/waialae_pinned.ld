SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004C0 0x800004C0 : AT(0x000010C0) { FILL(0x00000000); build/asm/main_800004C0.s.o(.text); build/asm/main_800004C0.s.o(.rodata); build/asm/main_800004C0.s.o(.data); }
    .main_800004C0_bss (NOLOAD) : { build/asm/main_800004C0.s.o(.bss); }
    .main_80002978 0x80002978 : AT(0x00003578) { FILL(0x00000000); build/asm/main_80002978.s.o(.text); build/asm/main_80002978.s.o(.rodata); build/asm/main_80002978.s.o(.data); }
    .main_80002978_bss (NOLOAD) : { build/asm/main_80002978.s.o(.bss); }
    .main_80003BFC 0x80003BFC : AT(0x000047FC) { FILL(0x00000000); build/asm/main_80003BFC.s.o(.text); build/asm/main_80003BFC.s.o(.rodata); build/asm/main_80003BFC.s.o(.data); }
    .main_80003BFC_bss (NOLOAD) : { build/asm/main_80003BFC.s.o(.bss); }
    .main_80004240 0x80004240 : AT(0x00004E40) { FILL(0x00000000); build/asm/main_80004240.s.o(.text); build/asm/main_80004240.s.o(.rodata); build/asm/main_80004240.s.o(.data); }
    .main_80004240_bss (NOLOAD) : { build/asm/main_80004240.s.o(.bss); }
    .main_800060E8 0x800060E8 : AT(0x00006CE8) { FILL(0x00000000); build/asm/main_800060E8.s.o(.text); build/asm/main_800060E8.s.o(.rodata); build/asm/main_800060E8.s.o(.data); }
    .main_800060E8_bss (NOLOAD) : { build/asm/main_800060E8.s.o(.bss); }
    .main_800070B0 0x800070B0 : AT(0x00007CB0) { FILL(0x00000000); build/asm/main_800070B0.s.o(.text); build/asm/main_800070B0.s.o(.rodata); build/asm/main_800070B0.s.o(.data); }
    .main_800070B0_bss (NOLOAD) : { build/asm/main_800070B0.s.o(.bss); }
    .main_80007944 0x80007944 : AT(0x00008544) { FILL(0x00000000); build/asm/main_80007944.s.o(.text); build/asm/main_80007944.s.o(.rodata); build/asm/main_80007944.s.o(.data); }
    .main_80007944_bss (NOLOAD) : { build/asm/main_80007944.s.o(.bss); }
    .main_80007D80 0x80007D80 : AT(0x00008980) { FILL(0x00000000); build/asm/main_80007D80.s.o(.text); build/asm/main_80007D80.s.o(.rodata); build/asm/main_80007D80.s.o(.data); }
    .main_80007D80_bss (NOLOAD) : { build/asm/main_80007D80.s.o(.bss); }
    .main_80018DC0 0x80018DC0 : AT(0x000199C0) { FILL(0x00000000); build/asm/main_80018DC0.s.o(.text); build/asm/main_80018DC0.s.o(.rodata); build/asm/main_80018DC0.s.o(.data); }
    .main_80018DC0_bss (NOLOAD) : { build/asm/main_80018DC0.s.o(.bss); }
    .main_80019330 0x80019330 : AT(0x00019F30) { FILL(0x00000000); build/asm/main_80019330.s.o(.text); build/asm/main_80019330.s.o(.rodata); build/asm/main_80019330.s.o(.data); }
    .main_80019330_bss (NOLOAD) : { build/asm/main_80019330.s.o(.bss); }
    .main_80019BAC 0x80019BAC : AT(0x0001A7AC) { FILL(0x00000000); build/asm/main_80019BAC.s.o(.text); build/asm/main_80019BAC.s.o(.rodata); build/asm/main_80019BAC.s.o(.data); }
    .main_80019BAC_bss (NOLOAD) : { build/asm/main_80019BAC.s.o(.bss); }
    .main_80019E54 0x80019E54 : AT(0x0001AA54) { FILL(0x00000000); build/asm/main_80019E54.s.o(.text); build/asm/main_80019E54.s.o(.rodata); build/asm/main_80019E54.s.o(.data); }
    .main_80019E54_bss (NOLOAD) : { build/asm/main_80019E54.s.o(.bss); }
    .main_8001A754 0x8001A754 : AT(0x0001B354) { FILL(0x00000000); build/asm/main_8001A754.s.o(.text); build/asm/main_8001A754.s.o(.rodata); build/asm/main_8001A754.s.o(.data); }
    .main_8001A754_bss (NOLOAD) : { build/asm/main_8001A754.s.o(.bss); }
    .main_8001EC50 0x8001EC50 : AT(0x0001F850) { FILL(0x00000000); build/asm/main_8001EC50.s.o(.text); build/asm/main_8001EC50.s.o(.rodata); build/asm/main_8001EC50.s.o(.data); }
    .main_8001EC50_bss (NOLOAD) : { build/asm/main_8001EC50.s.o(.bss); }
    .main_80028758 0x80028758 : AT(0x00029358) { FILL(0x00000000); build/asm/main_80028758.s.o(.text); build/asm/main_80028758.s.o(.rodata); build/asm/main_80028758.s.o(.data); }
    .main_80028758_bss (NOLOAD) : { build/asm/main_80028758.s.o(.bss); }
    .main_80028C40 0x80028C40 : AT(0x00029840) { FILL(0x00000000); build/asm/main_80028C40.s.o(.text); build/asm/main_80028C40.s.o(.rodata); build/asm/main_80028C40.s.o(.data); }
    .main_80028C40_bss (NOLOAD) : { build/asm/main_80028C40.s.o(.bss); }
    .main_8002D980 0x8002D980 : AT(0x0002E580) { FILL(0x00000000); build/asm/main_8002D980.s.o(.text); build/asm/main_8002D980.s.o(.rodata); build/asm/main_8002D980.s.o(.data); }
    .main_8002D980_bss (NOLOAD) : { build/asm/main_8002D980.s.o(.bss); }
    .main_8002E9AC 0x8002E9AC : AT(0x0002F5AC) { FILL(0x00000000); build/asm/main_8002E9AC.s.o(.text); build/asm/main_8002E9AC.s.o(.rodata); build/asm/main_8002E9AC.s.o(.data); }
    .main_8002E9AC_bss (NOLOAD) : { build/asm/main_8002E9AC.s.o(.bss); }
    .main_80031A20 0x80031A20 : AT(0x00032620) { FILL(0x00000000); build/asm/main_80031A20.s.o(.text); build/asm/main_80031A20.s.o(.rodata); build/asm/main_80031A20.s.o(.data); }
    .main_80031A20_bss (NOLOAD) : { build/asm/main_80031A20.s.o(.bss); }
    .main_800320F0 0x800320F0 : AT(0x00032CF0) { FILL(0x00000000); build/asm/main_800320F0.s.o(.text); build/asm/main_800320F0.s.o(.rodata); build/asm/main_800320F0.s.o(.data); }
    .main_800320F0_bss (NOLOAD) : { build/asm/main_800320F0.s.o(.bss); }
    .main_80032AC0 0x80032AC0 : AT(0x000336C0) { FILL(0x00000000); build/asm/main_80032AC0.s.o(.text); build/asm/main_80032AC0.s.o(.rodata); build/asm/main_80032AC0.s.o(.data); }
    .main_80032AC0_bss (NOLOAD) : { build/asm/main_80032AC0.s.o(.bss); }
    .main_800333F4 0x800333F4 : AT(0x00033FF4) { FILL(0x00000000); build/asm/main_800333F4.s.o(.text); build/asm/main_800333F4.s.o(.rodata); build/asm/main_800333F4.s.o(.data); }
    .main_800333F4_bss (NOLOAD) : { build/asm/main_800333F4.s.o(.bss); }
    .main_800337D0 0x800337D0 : AT(0x000343D0) { FILL(0x00000000); build/asm/main_800337D0.s.o(.text); build/asm/main_800337D0.s.o(.rodata); build/asm/main_800337D0.s.o(.data); }
    .main_800337D0_bss (NOLOAD) : { build/asm/main_800337D0.s.o(.bss); }
    .main_80034BF0 0x80034BF0 : AT(0x000357F0) { FILL(0x00000000); build/asm/main_80034BF0.s.o(.text); build/asm/main_80034BF0.s.o(.rodata); build/asm/main_80034BF0.s.o(.data); }
    .main_80034BF0_bss (NOLOAD) : { build/asm/main_80034BF0.s.o(.bss); }
    .main_80034FFC 0x80034FFC : AT(0x00035BFC) { FILL(0x00000000); build/asm/main_80034FFC.s.o(.text); build/asm/main_80034FFC.s.o(.rodata); build/asm/main_80034FFC.s.o(.data); }
    .main_80034FFC_bss (NOLOAD) : { build/asm/main_80034FFC.s.o(.bss); }
    .main_8003557C 0x8003557C : AT(0x0003617C) { FILL(0x00000000); build/asm/main_8003557C.s.o(.text); build/asm/main_8003557C.s.o(.rodata); build/asm/main_8003557C.s.o(.data); }
    .main_8003557C_bss (NOLOAD) : { build/asm/main_8003557C.s.o(.bss); }
    .main_80036210 0x80036210 : AT(0x00036E10) { FILL(0x00000000); build/asm/main_80036210.s.o(.text); build/asm/main_80036210.s.o(.rodata); build/asm/main_80036210.s.o(.data); }
    .main_80036210_bss (NOLOAD) : { build/asm/main_80036210.s.o(.bss); }
    .main_8003642C 0x8003642C : AT(0x0003702C) { FILL(0x00000000); build/asm/main_8003642C.s.o(.text); build/asm/main_8003642C.s.o(.rodata); build/asm/main_8003642C.s.o(.data); }
    .main_8003642C_bss (NOLOAD) : { build/asm/main_8003642C.s.o(.bss); }
    .main_800368A0 0x800368A0 : AT(0x000374A0) { FILL(0x00000000); build/asm/main_800368A0.s.o(.text); build/asm/main_800368A0.s.o(.rodata); build/asm/main_800368A0.s.o(.data); }
    .main_800368A0_bss (NOLOAD) : { build/asm/main_800368A0.s.o(.bss); }
    .main_80036AA4 0x80036AA4 : AT(0x000376A4) { FILL(0x00000000); build/asm/main_80036AA4.s.o(.text); build/asm/main_80036AA4.s.o(.rodata); build/asm/main_80036AA4.s.o(.data); }
    .main_80036AA4_bss (NOLOAD) : { build/asm/main_80036AA4.s.o(.bss); }
    .main_800371D0 0x800371D0 : AT(0x00037DD0) { FILL(0x00000000); build/asm/main_800371D0.s.o(.text); build/asm/main_800371D0.s.o(.rodata); build/asm/main_800371D0.s.o(.data); }
    .main_800371D0_bss (NOLOAD) : { build/asm/main_800371D0.s.o(.bss); }
    .main_80037904 0x80037904 : AT(0x00038504) { FILL(0x00000000); build/asm/main_80037904.s.o(.text); build/asm/main_80037904.s.o(.rodata); build/asm/main_80037904.s.o(.data); }
    .main_80037904_bss (NOLOAD) : { build/asm/main_80037904.s.o(.bss); }
    .main_80039120 0x80039120 : AT(0x00039D20) { FILL(0x00000000); build/asm/main_80039120.s.o(.text); build/asm/main_80039120.s.o(.rodata); build/asm/main_80039120.s.o(.data); }
    .main_80039120_bss (NOLOAD) : { build/asm/main_80039120.s.o(.bss); }
    .main_80045214 0x80045214 : AT(0x00045E14) { FILL(0x00000000); build/asm/main_80045214.s.o(.text); build/asm/main_80045214.s.o(.rodata); build/asm/main_80045214.s.o(.data); }
    .main_80045214_bss (NOLOAD) : { build/asm/main_80045214.s.o(.bss); }
    .main_80045DE8 0x80045DE8 : AT(0x000469E8) { build/asm/data/main_80045DE8.bin.o(.data); }
    .main_800491D0 0x800491D0 : AT(0x00049DD0) { build/asm/data/main_800491D0.bin.o(.data); }
    .main_800499D0 0x800499D0 : AT(0x0004A5D0) { build/asm/data/main_800499D0.bin.o(.data); }
    .main_80049E20 0x80049E20 : AT(0x0004AA20) { build/asm/data/main_80049E20.bin.o(.data); }
    .main_80049E9C 0x80049E9C : AT(0x0004AA9C) { FILL(0x00000000); build/asm/main_80049E9C.s.o(.text); build/asm/main_80049E9C.s.o(.rodata); build/asm/main_80049E9C.s.o(.data); }
    .main_80049E9C_bss (NOLOAD) : { build/asm/main_80049E9C.s.o(.bss); }
    .main_8004A5A0 0x8004A5A0 : AT(0x0004B1A0) { FILL(0x00000000); build/asm/main_8004A5A0.s.o(.text); build/asm/main_8004A5A0.s.o(.rodata); build/asm/main_8004A5A0.s.o(.data); }
    .main_8004A5A0_bss (NOLOAD) : { build/asm/main_8004A5A0.s.o(.bss); }
    .main_8004A61C 0x8004A61C : AT(0x0004B21C) { FILL(0x00000000); build/asm/main_8004A61C.s.o(.text); build/asm/main_8004A61C.s.o(.rodata); build/asm/main_8004A61C.s.o(.data); }
    .main_8004A61C_bss (NOLOAD) : { build/asm/main_8004A61C.s.o(.bss); }
    .ovl01_80104EE0 0x80104EE0 : AT(0x0004BC50) { FILL(0x00000000); build/asm/ovl01_80104EE0.s.o(.text); build/asm/ovl01_80104EE0.s.o(.rodata); build/asm/ovl01_80104EE0.s.o(.data); }
    .ovl01_80104EE0_bss (NOLOAD) : { build/asm/ovl01_80104EE0.s.o(.bss); }
    .main2_80095590 0x80095590 : AT(0x00096190) { FILL(0x00000000); build/asm/main2_80095590.s.o(.text); build/asm/main2_80095590.s.o(.rodata); build/asm/main2_80095590.s.o(.data); }
    .main2_80095590_bss (NOLOAD) : { build/asm/main2_80095590.s.o(.bss); }
    .main2_800AFAC4 0x800AFAC4 : AT(0x000B06C4) { build/asm/data/main2_800AFAC4.bin.o(.data); }
    .main2_800C1E98 0x800C1E98 : AT(0x000C2A98) { FILL(0x00000000); build/asm/main2_800C1E98.s.o(.text); build/asm/main2_800C1E98.s.o(.rodata); build/asm/main2_800C1E98.s.o(.data); }
    .main2_800C1E98_bss (NOLOAD) : { build/asm/main2_800C1E98.s.o(.bss); }
    .main2_800C4B6C 0x800C4B6C : AT(0x000C576C) { build/asm/data/main2_800C4B6C.bin.o(.data); }
    .main2_800CEAE4 0x800CEAE4 : AT(0x000CF6E4) { build/asm/data/main2_800CEAE4.bin.o(.data); }
    .main2_800E0FCC 0x800E0FCC : AT(0x000E1BCC) { build/asm/data/main2_800E0FCC.bin.o(.data); }
    .main2_800E127C 0x800E127C : AT(0x000E1E7C) { build/asm/data/main2_800E127C.bin.o(.data); }
    .main2_800E28D0 0x800E28D0 : AT(0x000E34D0) { build/asm/data/main2_800E28D0.bin.o(.data); }
    .main2_800E4240 0x800E4240 : AT(0x000E4E40) { build/asm/data/main2_800E4240.bin.o(.data); }
    .main2_800E48E0 0x800E48E0 : AT(0x000E54E0) { build/asm/data/main2_800E48E0.bin.o(.data); }
    .main2_800E54D0 0x800E54D0 : AT(0x000E60D0) { build/asm/data/main2_800E54D0.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
