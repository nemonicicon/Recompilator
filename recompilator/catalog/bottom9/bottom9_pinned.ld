SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000480 0x80000480 : AT(0x00001080) { FILL(0x00000000); build/asm/main_80000480.s.o(.text); build/asm/main_80000480.s.o(.rodata); build/asm/main_80000480.s.o(.data); }
    .main_80000480_bss (NOLOAD) : { build/asm/main_80000480.s.o(.bss); }
    .main_8003DB74 0x8003DB74 : AT(0x0003E774) { FILL(0x00000000); build/asm/main_8003DB74.s.o(.text); build/asm/main_8003DB74.s.o(.rodata); build/asm/main_8003DB74.s.o(.data); }
    .main_8003DB74_bss (NOLOAD) : { build/asm/main_8003DB74.s.o(.bss); }
    .main_8003DF50 0x8003DF50 : AT(0x0003EB50) { FILL(0x00000000); build/asm/main_8003DF50.s.o(.text); build/asm/main_8003DF50.s.o(.rodata); build/asm/main_8003DF50.s.o(.data); }
    .main_8003DF50_bss (NOLOAD) : { build/asm/main_8003DF50.s.o(.bss); }
    .main_800436FC 0x800436FC : AT(0x000442FC) { FILL(0x00000000); build/asm/main_800436FC.s.o(.text); build/asm/main_800436FC.s.o(.rodata); build/asm/main_800436FC.s.o(.data); }
    .main_800436FC_bss (NOLOAD) : { build/asm/main_800436FC.s.o(.bss); }
    .main_80045F5C 0x80045F5C : AT(0x00046B5C) { build/asm/data/main_80045F5C.bin.o(.data); }
    .main_80058310 0x80058310 : AT(0x00058F10) { FILL(0x00000000); build/asm/main_80058310.s.o(.text); build/asm/main_80058310.s.o(.rodata); build/asm/main_80058310.s.o(.data); }
    .main_80058310_bss (NOLOAD) : { build/asm/main_80058310.s.o(.bss); }
    .main_80058FD8 0x80058FD8 : AT(0x00059BD8) { build/asm/data/main_80058FD8.bin.o(.data); }
    .main_800594B4 0x800594B4 : AT(0x0005A0B4) { FILL(0x00000000); build/asm/main_800594B4.s.o(.text); build/asm/main_800594B4.s.o(.rodata); build/asm/main_800594B4.s.o(.data); }
    .main_800594B4_bss (NOLOAD) : { build/asm/main_800594B4.s.o(.bss); }
    .main_800594E8 0x800594E8 : AT(0x0005A0E8) { build/asm/data/main_800594E8.bin.o(.data); }
    .main_80059744 0x80059744 : AT(0x0005A344) { FILL(0x00000000); build/asm/main_80059744.s.o(.text); build/asm/main_80059744.s.o(.rodata); build/asm/main_80059744.s.o(.data); }
    .main_80059744_bss (NOLOAD) : { build/asm/main_80059744.s.o(.bss); }
    .main_80059770 0x80059770 : AT(0x0005A370) { build/asm/data/main_80059770.bin.o(.data); }
    .main_80059C64 0x80059C64 : AT(0x0005A864) { FILL(0x00000000); build/asm/main_80059C64.s.o(.text); build/asm/main_80059C64.s.o(.rodata); build/asm/main_80059C64.s.o(.data); }
    .main_80059C64_bss (NOLOAD) : { build/asm/main_80059C64.s.o(.bss); }
    .main_80059C80 0x80059C80 : AT(0x0005A880) { FILL(0x00000000); build/asm/main_80059C80.s.o(.text); build/asm/main_80059C80.s.o(.rodata); build/asm/main_80059C80.s.o(.data); }
    .main_80059C80_bss (NOLOAD) : { build/asm/main_80059C80.s.o(.bss); }
    .main_80059EF4 0x80059EF4 : AT(0x0005AAF4) { build/asm/data/main_80059EF4.bin.o(.data); }
    .main_8005A184 0x8005A184 : AT(0x0005AD84) { FILL(0x00000000); build/asm/main_8005A184.s.o(.text); build/asm/main_8005A184.s.o(.rodata); build/asm/main_8005A184.s.o(.data); }
    .main_8005A184_bss (NOLOAD) : { build/asm/main_8005A184.s.o(.bss); }
    .main_8005DF58 0x8005DF58 : AT(0x0005EB58) { FILL(0x00000000); build/asm/main_8005DF58.s.o(.text); build/asm/main_8005DF58.s.o(.rodata); build/asm/main_8005DF58.s.o(.data); }
    .main_8005DF58_bss (NOLOAD) : { build/asm/main_8005DF58.s.o(.bss); }
    .main_8006006C 0x8006006C : AT(0x00060C6C) { build/asm/data/main_8006006C.bin.o(.data); }
    .main_80061DB0 0x80061DB0 : AT(0x000629B0) { build/asm/data/main_80061DB0.bin.o(.data); }
    .bin_64C90 0xA0064C90 : AT(0x00064C90) { build/assets/bin_64C90.bin.o(.data); }
    .selcode_80170000 0x80170000 : AT(0x00082070) { FILL(0x00000000); build/asm/selcode_80170000.s.o(.text); build/asm/selcode_80170000.s.o(.rodata); build/asm/selcode_80170000.s.o(.data); }
    .selcode_80170000_bss (NOLOAD) : { build/asm/selcode_80170000.s.o(.bss); }
    .selcode_801AE7B0 0x801AE7B0 : AT(0x000C0820) { build/asm/data/selcode_801AE7B0.bin.o(.data); }
    .bin_CB040 0xA00CB040 : AT(0x000CB040) { build/assets/bin_CB040.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
