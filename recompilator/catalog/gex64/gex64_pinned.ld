SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_8000C384 0x8000C384 : AT(0x0000CF84) { FILL(0x00000000); build/asm/main_8000C384.s.o(.text); build/asm/main_8000C384.s.o(.rodata); build/asm/main_8000C384.s.o(.data); }
    .main_8000C384_bss (NOLOAD) : { build/asm/main_8000C384.s.o(.bss); }
    .main_80012450 0x80012450 : AT(0x00013050) { FILL(0x00000000); build/asm/main_80012450.s.o(.text); build/asm/main_80012450.s.o(.rodata); build/asm/main_80012450.s.o(.data); }
    .main_80012450_bss (NOLOAD) : { build/asm/main_80012450.s.o(.bss); }
    .main_800180C8 0x800180C8 : AT(0x00018CC8) { FILL(0x00000000); build/asm/main_800180C8.s.o(.text); build/asm/main_800180C8.s.o(.rodata); build/asm/main_800180C8.s.o(.data); }
    .main_800180C8_bss (NOLOAD) : { build/asm/main_800180C8.s.o(.bss); }
    .main_80018AB4 0x80018AB4 : AT(0x000196B4) { FILL(0x00000000); build/asm/main_80018AB4.s.o(.text); build/asm/main_80018AB4.s.o(.rodata); build/asm/main_80018AB4.s.o(.data); }
    .main_80018AB4_bss (NOLOAD) : { build/asm/main_80018AB4.s.o(.bss); }
    .main_80019000 0x80019000 : AT(0x00019C00) { FILL(0x00000000); build/asm/main_80019000.s.o(.text); build/asm/main_80019000.s.o(.rodata); build/asm/main_80019000.s.o(.data); }
    .main_80019000_bss (NOLOAD) : { build/asm/main_80019000.s.o(.bss); }
    .main_80019828 0x80019828 : AT(0x0001A428) { FILL(0x00000000); build/asm/main_80019828.s.o(.text); build/asm/main_80019828.s.o(.rodata); build/asm/main_80019828.s.o(.data); }
    .main_80019828_bss (NOLOAD) : { build/asm/main_80019828.s.o(.bss); }
    .main_800199C0 0x800199C0 : AT(0x0001A5C0) { FILL(0x00000000); build/asm/main_800199C0.s.o(.text); build/asm/main_800199C0.s.o(.rodata); build/asm/main_800199C0.s.o(.data); }
    .main_800199C0_bss (NOLOAD) : { build/asm/main_800199C0.s.o(.bss); }
    .main_800231E0 0x800231E0 : AT(0x00023DE0) { FILL(0x00000000); build/asm/main_800231E0.s.o(.text); build/asm/main_800231E0.s.o(.rodata); build/asm/main_800231E0.s.o(.data); }
    .main_800231E0_bss (NOLOAD) : { build/asm/main_800231E0.s.o(.bss); }
    .main_80023E9C 0x80023E9C : AT(0x00024A9C) { FILL(0x00000000); build/asm/main_80023E9C.s.o(.text); build/asm/main_80023E9C.s.o(.rodata); build/asm/main_80023E9C.s.o(.data); }
    .main_80023E9C_bss (NOLOAD) : { build/asm/main_80023E9C.s.o(.bss); }
    .main_8003BA7C 0x8003BA7C : AT(0x0003C67C) { FILL(0x00000000); build/asm/main_8003BA7C.s.o(.text); build/asm/main_8003BA7C.s.o(.rodata); build/asm/main_8003BA7C.s.o(.data); }
    .main_8003BA7C_bss (NOLOAD) : { build/asm/main_8003BA7C.s.o(.bss); }
    .main_8003C070 0x8003C070 : AT(0x0003CC70) { FILL(0x00000000); build/asm/main_8003C070.s.o(.text); build/asm/main_8003C070.s.o(.rodata); build/asm/main_8003C070.s.o(.data); }
    .main_8003C070_bss (NOLOAD) : { build/asm/main_8003C070.s.o(.bss); }
    .main_80046730 0x80046730 : AT(0x00047330) { FILL(0x00000000); build/asm/main_80046730.s.o(.text); build/asm/main_80046730.s.o(.rodata); build/asm/main_80046730.s.o(.data); }
    .main_80046730_bss (NOLOAD) : { build/asm/main_80046730.s.o(.bss); }
    .main_80047768 0x80047768 : AT(0x00048368) { FILL(0x00000000); build/asm/main_80047768.s.o(.text); build/asm/main_80047768.s.o(.rodata); build/asm/main_80047768.s.o(.data); }
    .main_80047768_bss (NOLOAD) : { build/asm/main_80047768.s.o(.bss); }
    .main_80049A58 0x80049A58 : AT(0x0004A658) { FILL(0x00000000); build/asm/main_80049A58.s.o(.text); build/asm/main_80049A58.s.o(.rodata); build/asm/main_80049A58.s.o(.data); }
    .main_80049A58_bss (NOLOAD) : { build/asm/main_80049A58.s.o(.bss); }
    .main_8004BAAC 0x8004BAAC : AT(0x0004C6AC) { FILL(0x00000000); build/asm/main_8004BAAC.s.o(.text); build/asm/main_8004BAAC.s.o(.rodata); build/asm/main_8004BAAC.s.o(.data); }
    .main_8004BAAC_bss (NOLOAD) : { build/asm/main_8004BAAC.s.o(.bss); }
    .main_8004EA58 0x8004EA58 : AT(0x0004F658) { FILL(0x00000000); build/asm/main_8004EA58.s.o(.text); build/asm/main_8004EA58.s.o(.rodata); build/asm/main_8004EA58.s.o(.data); }
    .main_8004EA58_bss (NOLOAD) : { build/asm/main_8004EA58.s.o(.bss); }
    .main_80054770 0x80054770 : AT(0x00055370) { FILL(0x00000000); build/asm/main_80054770.s.o(.text); build/asm/main_80054770.s.o(.rodata); build/asm/main_80054770.s.o(.data); }
    .main_80054770_bss (NOLOAD) : { build/asm/main_80054770.s.o(.bss); }
    .main_800562E8 0x800562E8 : AT(0x00056EE8) { FILL(0x00000000); build/asm/main_800562E8.s.o(.text); build/asm/main_800562E8.s.o(.rodata); build/asm/main_800562E8.s.o(.data); }
    .main_800562E8_bss (NOLOAD) : { build/asm/main_800562E8.s.o(.bss); }
    .main_80056520 0x80056520 : AT(0x00057120) { FILL(0x00000000); build/asm/main_80056520.s.o(.text); build/asm/main_80056520.s.o(.rodata); build/asm/main_80056520.s.o(.data); }
    .main_80056520_bss (NOLOAD) : { build/asm/main_80056520.s.o(.bss); }
    .main_8005B7B0 0x8005B7B0 : AT(0x0005C3B0) { FILL(0x00000000); build/asm/main_8005B7B0.s.o(.text); build/asm/main_8005B7B0.s.o(.rodata); build/asm/main_8005B7B0.s.o(.data); }
    .main_8005B7B0_bss (NOLOAD) : { build/asm/main_8005B7B0.s.o(.bss); }
    .main_8005BFC0 0x8005BFC0 : AT(0x0005CBC0) { FILL(0x00000000); build/asm/main_8005BFC0.s.o(.text); build/asm/main_8005BFC0.s.o(.rodata); build/asm/main_8005BFC0.s.o(.data); }
    .main_8005BFC0_bss (NOLOAD) : { build/asm/main_8005BFC0.s.o(.bss); }
    .main_8005C320 0x8005C320 : AT(0x0005CF20) { FILL(0x00000000); build/asm/main_8005C320.s.o(.text); build/asm/main_8005C320.s.o(.rodata); build/asm/main_8005C320.s.o(.data); }
    .main_8005C320_bss (NOLOAD) : { build/asm/main_8005C320.s.o(.bss); }
    .main_8005C65C 0x8005C65C : AT(0x0005D25C) { FILL(0x00000000); build/asm/main_8005C65C.s.o(.text); build/asm/main_8005C65C.s.o(.rodata); build/asm/main_8005C65C.s.o(.data); }
    .main_8005C65C_bss (NOLOAD) : { build/asm/main_8005C65C.s.o(.bss); }
    .main_8005D90C 0x8005D90C : AT(0x0005E50C) { FILL(0x00000000); build/asm/main_8005D90C.s.o(.text); build/asm/main_8005D90C.s.o(.rodata); build/asm/main_8005D90C.s.o(.data); }
    .main_8005D90C_bss (NOLOAD) : { build/asm/main_8005D90C.s.o(.bss); }
    .main_8005DCF0 0x8005DCF0 : AT(0x0005E8F0) { FILL(0x00000000); build/asm/main_8005DCF0.s.o(.text); build/asm/main_8005DCF0.s.o(.rodata); build/asm/main_8005DCF0.s.o(.data); }
    .main_8005DCF0_bss (NOLOAD) : { build/asm/main_8005DCF0.s.o(.bss); }
    .main_8005FD40 0x8005FD40 : AT(0x00060940) { FILL(0x00000000); build/asm/main_8005FD40.s.o(.text); build/asm/main_8005FD40.s.o(.rodata); build/asm/main_8005FD40.s.o(.data); }
    .main_8005FD40_bss (NOLOAD) : { build/asm/main_8005FD40.s.o(.bss); }
    .main_8006014C 0x8006014C : AT(0x00060D4C) { FILL(0x00000000); build/asm/main_8006014C.s.o(.text); build/asm/main_8006014C.s.o(.rodata); build/asm/main_8006014C.s.o(.data); }
    .main_8006014C_bss (NOLOAD) : { build/asm/main_8006014C.s.o(.bss); }
    .main_80060680 0x80060680 : AT(0x00061280) { FILL(0x00000000); build/asm/main_80060680.s.o(.text); build/asm/main_80060680.s.o(.rodata); build/asm/main_80060680.s.o(.data); }
    .main_80060680_bss (NOLOAD) : { build/asm/main_80060680.s.o(.bss); }
    .main_80060F90 0x80060F90 : AT(0x00061B90) { FILL(0x00000000); build/asm/main_80060F90.s.o(.text); build/asm/main_80060F90.s.o(.rodata); build/asm/main_80060F90.s.o(.data); }
    .main_80060F90_bss (NOLOAD) : { build/asm/main_80060F90.s.o(.bss); }
    .main_800611AC 0x800611AC : AT(0x00061DAC) { FILL(0x00000000); build/asm/main_800611AC.s.o(.text); build/asm/main_800611AC.s.o(.rodata); build/asm/main_800611AC.s.o(.data); }
    .main_800611AC_bss (NOLOAD) : { build/asm/main_800611AC.s.o(.bss); }
    .main_800615E4 0x800615E4 : AT(0x000621E4) { FILL(0x00000000); build/asm/main_800615E4.s.o(.text); build/asm/main_800615E4.s.o(.rodata); build/asm/main_800615E4.s.o(.data); }
    .main_800615E4_bss (NOLOAD) : { build/asm/main_800615E4.s.o(.bss); }
    .main_800617E8 0x800617E8 : AT(0x000623E8) { FILL(0x00000000); build/asm/main_800617E8.s.o(.text); build/asm/main_800617E8.s.o(.rodata); build/asm/main_800617E8.s.o(.data); }
    .main_800617E8_bss (NOLOAD) : { build/asm/main_800617E8.s.o(.bss); }
    .main_80061EB8 0x80061EB8 : AT(0x00062AB8) { FILL(0x00000000); build/asm/main_80061EB8.s.o(.text); build/asm/main_80061EB8.s.o(.rodata); build/asm/main_80061EB8.s.o(.data); }
    .main_80061EB8_bss (NOLOAD) : { build/asm/main_80061EB8.s.o(.bss); }
    .main_80062750 0x80062750 : AT(0x00063350) { FILL(0x00000000); build/asm/main_80062750.s.o(.text); build/asm/main_80062750.s.o(.rodata); build/asm/main_80062750.s.o(.data); }
    .main_80062750_bss (NOLOAD) : { build/asm/main_80062750.s.o(.bss); }
    .main_80064AE0 0x80064AE0 : AT(0x000656E0) { FILL(0x00000000); build/asm/main_80064AE0.s.o(.text); build/asm/main_80064AE0.s.o(.rodata); build/asm/main_80064AE0.s.o(.data); }
    .main_80064AE0_bss (NOLOAD) : { build/asm/main_80064AE0.s.o(.bss); }
    .main_800655E0 0x800655E0 : AT(0x000661E0) { FILL(0x00000000); build/asm/main_800655E0.s.o(.text); build/asm/main_800655E0.s.o(.rodata); build/asm/main_800655E0.s.o(.data); }
    .main_800655E0_bss (NOLOAD) : { build/asm/main_800655E0.s.o(.bss); }
    .main_80070BB4 0x80070BB4 : AT(0x000717B4) { FILL(0x00000000); build/asm/data/main_80070BB4.data.s.o(.data); }
    .main_8007689C 0x8007689C : AT(0x0007749C) { FILL(0x00000000); build/asm/data/main_8007689C.data.s.o(.data); }
    .main_80078ABC 0x80078ABC : AT(0x000796BC) { FILL(0x00000000); build/asm/data/main_80078ABC.data.s.o(.data); }
    .main_8007B214 0x8007B214 : AT(0x0007BE14) { FILL(0x00000000); build/asm/main_8007B214.s.o(.text); build/asm/main_8007B214.s.o(.rodata); build/asm/main_8007B214.s.o(.data); }
    .main_8007B214_bss (NOLOAD) : { build/asm/main_8007B214.s.o(.bss); }
    .main_8007B480 0x8007B480 : AT(0x0007C080) { FILL(0x00000000); build/asm/data/main_8007B480.data.s.o(.data); }
    .main_8007C0D0 0x8007C0D0 : AT(0x0007CCD0) { FILL(0x00000000); build/asm/data/main_8007C0D0.data.s.o(.data); }
    .main_80094078 0x80094078 : AT(0x00094C78) { FILL(0x00000000); build/asm/data/main_80094078.data.s.o(.data); }
    .main_800C0970 0x800C0970 : AT(0x000C1570) { FILL(0x00000000); build/asm/main_800C0970.s.o(.text); build/asm/main_800C0970.s.o(.rodata); build/asm/main_800C0970.s.o(.data); }
    .main_800C0970_bss (NOLOAD) : { build/asm/main_800C0970.s.o(.bss); }
    .main_800DF82C 0x800DF82C : AT(0x000E042C) { FILL(0x00000000); build/asm/main_800DF82C.s.o(.text); build/asm/main_800DF82C.s.o(.rodata); build/asm/main_800DF82C.s.o(.data); }
    .main_800DF82C_bss (NOLOAD) : { build/asm/main_800DF82C.s.o(.bss); }
    .main_800EE3CC 0x800EE3CC : AT(0x000EEFCC) { FILL(0x00000000); build/asm/data/main_800EE3CC.data.s.o(.data); }
    .main_800EFAD0 0x800EFAD0 : AT(0x000F06D0) { FILL(0x00000000); build/asm/main_800EFAD0.s.o(.text); build/asm/main_800EFAD0.s.o(.rodata); build/asm/main_800EFAD0.s.o(.data); }
    .main_800EFAD0_bss (NOLOAD) : { build/asm/main_800EFAD0.s.o(.bss); }
    .main_800EFAEC 0x800EFAEC : AT(0x000F06EC) { FILL(0x00000000); build/asm/data/main_800EFAEC.data.s.o(.data); }
    .main_800F0300 0x800F0300 : AT(0x000F0F00) { FILL(0x00000000); build/asm/main_800F0300.s.o(.text); build/asm/main_800F0300.s.o(.rodata); build/asm/main_800F0300.s.o(.data); }
    .main_800F0300_bss (NOLOAD) : { build/asm/main_800F0300.s.o(.bss); }
    .main_800F03E4 0x800F03E4 : AT(0x000F0FE4) { FILL(0x00000000); build/asm/data/main_800F03E4.data.s.o(.data); }
    .main_800F14C8 0x800F14C8 : AT(0x000F20C8) { FILL(0x00000000); build/asm/main_800F14C8.s.o(.text); build/asm/main_800F14C8.s.o(.rodata); build/asm/main_800F14C8.s.o(.data); }
    .main_800F14C8_bss (NOLOAD) : { build/asm/main_800F14C8.s.o(.bss); }
    .main_800F14FC 0x800F14FC : AT(0x000F20FC) { FILL(0x00000000); build/asm/data/main_800F14FC.data.s.o(.data); }
    .main_800F16B4 0x800F16B4 : AT(0x000F22B4) { FILL(0x00000000); build/asm/main_800F16B4.s.o(.text); build/asm/main_800F16B4.s.o(.rodata); build/asm/main_800F16B4.s.o(.data); }
    .main_800F16B4_bss (NOLOAD) : { build/asm/main_800F16B4.s.o(.bss); }
    .main_800F171C 0x800F171C : AT(0x000F231C) { FILL(0x00000000); build/asm/data/main_800F171C.data.s.o(.data); }
    .main_800F1CE0 0x800F1CE0 : AT(0x000F28E0) { FILL(0x00000000); build/asm/main_800F1CE0.s.o(.text); build/asm/main_800F1CE0.s.o(.rodata); build/asm/main_800F1CE0.s.o(.data); }
    .main_800F1CE0_bss (NOLOAD) : { build/asm/main_800F1CE0.s.o(.bss); }
    .main_800F1E30 0x800F1E30 : AT(0x000F2A30) { FILL(0x00000000); build/asm/data/main_800F1E30.data.s.o(.data); }
    .main_800F2EC0 0x800F2EC0 : AT(0x000F3AC0) { FILL(0x00000000); build/asm/main_800F2EC0.s.o(.text); build/asm/main_800F2EC0.s.o(.rodata); build/asm/main_800F2EC0.s.o(.data); }
    .main_800F2EC0_bss (NOLOAD) : { build/asm/main_800F2EC0.s.o(.bss); }
    .main_800F2F98 0x800F2F98 : AT(0x000F3B98) { FILL(0x00000000); build/asm/data/main_800F2F98.data.s.o(.data); }
    .main_800F40B0 0x800F40B0 : AT(0x000F4CB0) { FILL(0x00000000); build/asm/main_800F40B0.s.o(.text); build/asm/main_800F40B0.s.o(.rodata); build/asm/main_800F40B0.s.o(.data); }
    .main_800F40B0_bss (NOLOAD) : { build/asm/main_800F40B0.s.o(.bss); }
    .main_800F4270 0x800F4270 : AT(0x000F4E70) { FILL(0x00000000); build/asm/data/main_800F4270.data.s.o(.data); }
    .main_800F45DC 0x800F45DC : AT(0x000F51DC) { FILL(0x00000000); build/asm/main_800F45DC.s.o(.text); build/asm/main_800F45DC.s.o(.rodata); build/asm/main_800F45DC.s.o(.data); }
    .main_800F45DC_bss (NOLOAD) : { build/asm/main_800F45DC.s.o(.bss); }
    .main_800F4794 0x800F4794 : AT(0x000F5394) { FILL(0x00000000); build/asm/data/main_800F4794.data.s.o(.data); }
    .main_800F4F04 0x800F4F04 : AT(0x000F5B04) { FILL(0x00000000); build/asm/main_800F4F04.s.o(.text); build/asm/main_800F4F04.s.o(.rodata); build/asm/main_800F4F04.s.o(.data); }
    .main_800F4F04_bss (NOLOAD) : { build/asm/main_800F4F04.s.o(.bss); }
    .main_800F4FD8 0x800F4FD8 : AT(0x000F5BD8) { FILL(0x00000000); build/asm/data/main_800F4FD8.data.s.o(.data); }
    .main_800F5524 0x800F5524 : AT(0x000F6124) { FILL(0x00000000); build/asm/main_800F5524.s.o(.text); build/asm/main_800F5524.s.o(.rodata); build/asm/main_800F5524.s.o(.data); }
    .main_800F5524_bss (NOLOAD) : { build/asm/main_800F5524.s.o(.bss); }
    .main_800F5864 0x800F5864 : AT(0x000F6464) { FILL(0x00000000); build/asm/data/main_800F5864.data.s.o(.data); }
    .main_800F5B4C 0x800F5B4C : AT(0x000F674C) { FILL(0x00000000); build/asm/main_800F5B4C.s.o(.text); build/asm/main_800F5B4C.s.o(.rodata); build/asm/main_800F5B4C.s.o(.data); }
    .main_800F5B4C_bss (NOLOAD) : { build/asm/main_800F5B4C.s.o(.bss); }
    .main_800F5C1C 0x800F5C1C : AT(0x000F681C) { FILL(0x00000000); build/asm/data/main_800F5C1C.data.s.o(.data); }
    .main_800F6180 0x800F6180 : AT(0x000F6D80) { FILL(0x00000000); build/asm/main_800F6180.s.o(.text); build/asm/main_800F6180.s.o(.rodata); build/asm/main_800F6180.s.o(.data); }
    .main_800F6180_bss (NOLOAD) : { build/asm/main_800F6180.s.o(.bss); }
    .main_800F6298 0x800F6298 : AT(0x000F6E98) { FILL(0x00000000); build/asm/data/main_800F6298.data.s.o(.data); }
    .main_800F6580 0x800F6580 : AT(0x000F7180) { FILL(0x00000000); build/asm/main_800F6580.s.o(.text); build/asm/main_800F6580.s.o(.rodata); build/asm/main_800F6580.s.o(.data); }
    .main_800F6580_bss (NOLOAD) : { build/asm/main_800F6580.s.o(.bss); }
    .main_800F6698 0x800F6698 : AT(0x000F7298) { FILL(0x00000000); build/asm/data/main_800F6698.data.s.o(.data); }
    .main_800F6D20 0x800F6D20 : AT(0x000F7920) { FILL(0x00000000); build/asm/main_800F6D20.s.o(.text); build/asm/main_800F6D20.s.o(.rodata); build/asm/main_800F6D20.s.o(.data); }
    .main_800F6D20_bss (NOLOAD) : { build/asm/main_800F6D20.s.o(.bss); }
    .main_800F6D48 0x800F6D48 : AT(0x000F7948) { FILL(0x00000000); build/asm/data/main_800F6D48.data.s.o(.data); }
    .main_800F7084 0x800F7084 : AT(0x000F7C84) { FILL(0x00000000); build/asm/main_800F7084.s.o(.text); build/asm/main_800F7084.s.o(.rodata); build/asm/main_800F7084.s.o(.data); }
    .main_800F7084_bss (NOLOAD) : { build/asm/main_800F7084.s.o(.bss); }
    .main_800F70B4 0x800F70B4 : AT(0x000F7CB4) { FILL(0x00000000); build/asm/data/main_800F70B4.data.s.o(.data); }
    .main_800F7418 0x800F7418 : AT(0x000F8018) { FILL(0x00000000); build/asm/main_800F7418.s.o(.text); build/asm/main_800F7418.s.o(.rodata); build/asm/main_800F7418.s.o(.data); }
    .main_800F7418_bss (NOLOAD) : { build/asm/main_800F7418.s.o(.bss); }
    .main_800F7430 0x800F7430 : AT(0x000F8030) { FILL(0x00000000); build/asm/data/main_800F7430.data.s.o(.data); }
    .main_800F8E5C 0x800F8E5C : AT(0x000F9A5C) { FILL(0x00000000); build/asm/main_800F8E5C.s.o(.text); build/asm/main_800F8E5C.s.o(.rodata); build/asm/main_800F8E5C.s.o(.data); }
    .main_800F8E5C_bss (NOLOAD) : { build/asm/main_800F8E5C.s.o(.bss); }
    .main_800F8E64 0x800F8E64 : AT(0x000F9A64) { FILL(0x00000000); build/asm/data/main_800F8E64.data.s.o(.data); }
    .main_800F9018 0x800F9018 : AT(0x000F9C18) { FILL(0x00000000); build/asm/main_800F9018.s.o(.text); build/asm/main_800F9018.s.o(.rodata); build/asm/main_800F9018.s.o(.data); }
    .main_800F9018_bss (NOLOAD) : { build/asm/main_800F9018.s.o(.bss); }
    .main_800F90D8 0x800F90D8 : AT(0x000F9CD8) { FILL(0x00000000); build/asm/data/main_800F90D8.data.s.o(.data); }
    .main_800F9EBC 0x800F9EBC : AT(0x000FAABC) { FILL(0x00000000); build/asm/main_800F9EBC.s.o(.text); build/asm/main_800F9EBC.s.o(.rodata); build/asm/main_800F9EBC.s.o(.data); }
    .main_800F9EBC_bss (NOLOAD) : { build/asm/main_800F9EBC.s.o(.bss); }
    .main_800F9F20 0x800F9F20 : AT(0x000FAB20) { FILL(0x00000000); build/asm/data/main_800F9F20.data.s.o(.data); }
    .main_800FA448 0x800FA448 : AT(0x000FB048) { FILL(0x00000000); build/asm/main_800FA448.s.o(.text); build/asm/main_800FA448.s.o(.rodata); build/asm/main_800FA448.s.o(.data); }
    .main_800FA448_bss (NOLOAD) : { build/asm/main_800FA448.s.o(.bss); }
    .main_800FA540 0x800FA540 : AT(0x000FB140) { FILL(0x00000000); build/asm/data/main_800FA540.data.s.o(.data); }
    .main_800FAEE8 0x800FAEE8 : AT(0x000FBAE8) { FILL(0x00000000); build/asm/main_800FAEE8.s.o(.text); build/asm/main_800FAEE8.s.o(.rodata); build/asm/main_800FAEE8.s.o(.data); }
    .main_800FAEE8_bss (NOLOAD) : { build/asm/main_800FAEE8.s.o(.bss); }
    .main_800FAF68 0x800FAF68 : AT(0x000FBB68) { FILL(0x00000000); build/asm/data/main_800FAF68.data.s.o(.data); }
    .main_800FB414 0x800FB414 : AT(0x000FC014) { FILL(0x00000000); build/asm/main_800FB414.s.o(.text); build/asm/main_800FB414.s.o(.rodata); build/asm/main_800FB414.s.o(.data); }
    .main_800FB414_bss (NOLOAD) : { build/asm/main_800FB414.s.o(.bss); }
    .main_800FB48C 0x800FB48C : AT(0x000FC08C) { FILL(0x00000000); build/asm/data/main_800FB48C.data.s.o(.data); }
    .main_800FCB30 0x800FCB30 : AT(0x000FD730) { FILL(0x00000000); build/asm/main_800FCB30.s.o(.text); build/asm/main_800FCB30.s.o(.rodata); build/asm/main_800FCB30.s.o(.data); }
    .main_800FCB30_bss (NOLOAD) : { build/asm/main_800FCB30.s.o(.bss); }
    .main_800FCB5C 0x800FCB5C : AT(0x000FD75C) { FILL(0x00000000); build/asm/data/main_800FCB5C.data.s.o(.data); }
    .main_800FCC74 0x800FCC74 : AT(0x000FD874) { FILL(0x00000000); build/asm/main_800FCC74.s.o(.text); build/asm/main_800FCC74.s.o(.rodata); build/asm/main_800FCC74.s.o(.data); }
    .main_800FCC74_bss (NOLOAD) : { build/asm/main_800FCC74.s.o(.bss); }
    .main_800FCFC4 0x800FCFC4 : AT(0x000FDBC4) { FILL(0x00000000); build/asm/data/main_800FCFC4.data.s.o(.data); }
    .main_800FD15C 0x800FD15C : AT(0x000FDD5C) { FILL(0x00000000); build/asm/main_800FD15C.s.o(.text); build/asm/main_800FD15C.s.o(.rodata); build/asm/main_800FD15C.s.o(.data); }
    .main_800FD15C_bss (NOLOAD) : { build/asm/main_800FD15C.s.o(.bss); }
    .main_800FD180 0x800FD180 : AT(0x000FDD80) { FILL(0x00000000); build/asm/data/main_800FD180.data.s.o(.data); }
    .main_800FD278 0x800FD278 : AT(0x000FDE78) { FILL(0x00000000); build/asm/main_800FD278.s.o(.text); build/asm/main_800FD278.s.o(.rodata); build/asm/main_800FD278.s.o(.data); }
    .main_800FD278_bss (NOLOAD) : { build/asm/main_800FD278.s.o(.bss); }
    .main_800FD434 0x800FD434 : AT(0x000FE034) { FILL(0x00000000); build/asm/data/main_800FD434.data.s.o(.data); }
    .main_800FE240 0x800FE240 : AT(0x000FEE40) { FILL(0x00000000); build/asm/main_800FE240.s.o(.text); build/asm/main_800FE240.s.o(.rodata); build/asm/main_800FE240.s.o(.data); }
    .main_800FE240_bss (NOLOAD) : { build/asm/main_800FE240.s.o(.bss); }
    .main_800FE3C0 0x800FE3C0 : AT(0x000FEFC0) { FILL(0x00000000); build/asm/data/main_800FE3C0.data.s.o(.data); }
    .main_800FE60C 0x800FE60C : AT(0x000FF20C) { FILL(0x00000000); build/asm/main_800FE60C.s.o(.text); build/asm/main_800FE60C.s.o(.rodata); build/asm/main_800FE60C.s.o(.data); }
    .main_800FE60C_bss (NOLOAD) : { build/asm/main_800FE60C.s.o(.bss); }
    .main_800FE630 0x800FE630 : AT(0x000FF230) { FILL(0x00000000); build/asm/data/main_800FE630.data.s.o(.data); }
    .main_800FF500 0x800FF500 : AT(0x00100100) { FILL(0x00000000); build/asm/main_800FF500.s.o(.text); build/asm/main_800FF500.s.o(.rodata); build/asm/main_800FF500.s.o(.data); }
    .main_800FF500_bss (NOLOAD) : { build/asm/main_800FF500.s.o(.bss); }
    .main_800FF50C 0x800FF50C : AT(0x0010010C) { FILL(0x00000000); build/asm/data/main_800FF50C.data.s.o(.data); }
    .main_800FF644 0x800FF644 : AT(0x00100244) { FILL(0x00000000); build/asm/main_800FF644.s.o(.text); build/asm/main_800FF644.s.o(.rodata); build/asm/main_800FF644.s.o(.data); }
    .main_800FF644_bss (NOLOAD) : { build/asm/main_800FF644.s.o(.bss); }
    .main_800FF7F8 0x800FF7F8 : AT(0x001003F8) { FILL(0x00000000); build/asm/data/main_800FF7F8.data.s.o(.data); }
    .main_800FFA2C 0x800FFA2C : AT(0x0010062C) { FILL(0x00000000); build/asm/main_800FFA2C.s.o(.text); build/asm/main_800FFA2C.s.o(.rodata); build/asm/main_800FFA2C.s.o(.data); }
    .main_800FFA2C_bss (NOLOAD) : { build/asm/main_800FFA2C.s.o(.bss); }
    .main_800FFAB0 0x800FFAB0 : AT(0x001006B0) { FILL(0x00000000); build/asm/data/main_800FFAB0.data.s.o(.data); }
    .main_800FFF8C 0x800FFF8C : AT(0x00100B8C) { FILL(0x00000000); build/asm/main_800FFF8C.s.o(.text); build/asm/main_800FFF8C.s.o(.rodata); build/asm/main_800FFF8C.s.o(.data); }
    .main_800FFF8C_bss (NOLOAD) : { build/asm/main_800FFF8C.s.o(.bss); }
    .main_80100000 0x80100000 : AT(0x00100C00) { FILL(0x00000000); build/asm/data/main_80100000.data.s.o(.data); }
    .main_801003D0 0x801003D0 : AT(0x00100FD0) { FILL(0x00000000); build/asm/main_801003D0.s.o(.text); build/asm/main_801003D0.s.o(.rodata); build/asm/main_801003D0.s.o(.data); }
    .main_801003D0_bss (NOLOAD) : { build/asm/main_801003D0.s.o(.bss); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
