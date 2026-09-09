SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000480 0x80000480 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000480.s.o(.text); build/asm/main_80000480.s.o(.rodata); build/asm/main_80000480.s.o(.data); }
    .main_80000480_bss (NOLOAD) : { build/asm/main_80000480.s.o(.bss); }
    .main_80000CE4 0x80000CE4 : AT(0x00001864) { FILL(0x00000000); build/asm/main_80000CE4.s.o(.text); build/asm/main_80000CE4.s.o(.rodata); build/asm/main_80000CE4.s.o(.data); }
    .main_80000CE4_bss (NOLOAD) : { build/asm/main_80000CE4.s.o(.bss); }
    .main_80001180 0x80001180 : AT(0x00001D00) { FILL(0x00000000); build/asm/main_80001180.s.o(.text); build/asm/main_80001180.s.o(.rodata); build/asm/main_80001180.s.o(.data); }
    .main_80001180_bss (NOLOAD) : { build/asm/main_80001180.s.o(.bss); }
    .main_80015878 0x80015878 : AT(0x000163F8) { build/asm/data/main_80015878.bin.o(.data); }
    .main_80016310 0x80016310 : AT(0x00016E90) { FILL(0x00000000); build/asm/main_80016310.s.o(.text); build/asm/main_80016310.s.o(.rodata); build/asm/main_80016310.s.o(.data); }
    .main_80016310_bss (NOLOAD) : { build/asm/main_80016310.s.o(.bss); }
    .main_8001ACB8 0x8001ACB8 : AT(0x0001B838) { build/asm/data/main_8001ACB8.bin.o(.data); }
    .main_8002D840 0x8002D840 : AT(0x0002E3C0) { FILL(0x00000000); build/asm/main_8002D840.s.o(.text); build/asm/main_8002D840.s.o(.rodata); build/asm/main_8002D840.s.o(.data); }
    .main_8002D840_bss (NOLOAD) : { build/asm/main_8002D840.s.o(.bss); }
    .main_8002D87C 0x8002D87C : AT(0x0002E3FC) { build/asm/data/main_8002D87C.bin.o(.data); }
    .main_800B5BF0 0x800B5BF0 : AT(0x000B6770) { FILL(0x00000000); build/asm/main_800B5BF0.s.o(.text); build/asm/main_800B5BF0.s.o(.rodata); build/asm/main_800B5BF0.s.o(.data); }
    .main_800B5BF0_bss (NOLOAD) : { build/asm/main_800B5BF0.s.o(.bss); }
    .main_800BD1C4 0x800BD1C4 : AT(0x000BDD44) { build/asm/data/main_800BD1C4.bin.o(.data); }
    .main_800BDFBC 0x800BDFBC : AT(0x000BEB3C) { FILL(0x00000000); build/asm/main_800BDFBC.s.o(.text); build/asm/main_800BDFBC.s.o(.rodata); build/asm/main_800BDFBC.s.o(.data); }
    .main_800BDFBC_bss (NOLOAD) : { build/asm/main_800BDFBC.s.o(.bss); }
    .main_800C03C0 0x800C03C0 : AT(0x000C0F40) { build/asm/data/main_800C03C0.bin.o(.data); }
    .main_800C32B0 0x800C32B0 : AT(0x000C3E30) { FILL(0x00000000); build/asm/main_800C32B0.s.o(.text); build/asm/main_800C32B0.s.o(.rodata); build/asm/main_800C32B0.s.o(.data); }
    .main_800C32B0_bss (NOLOAD) : { build/asm/main_800C32B0.s.o(.bss); }
    .main_800C3654 0x800C3654 : AT(0x000C41D4) { build/asm/data/main_800C3654.bin.o(.data); }
    .main_800C56E4 0x800C56E4 : AT(0x000C6264) { FILL(0x00000000); build/asm/main_800C56E4.s.o(.text); build/asm/main_800C56E4.s.o(.rodata); build/asm/main_800C56E4.s.o(.data); }
    .main_800C56E4_bss (NOLOAD) : { build/asm/main_800C56E4.s.o(.bss); }
    .main_800C85C4 0x800C85C4 : AT(0x000C9144) { FILL(0x00000000); build/asm/main_800C85C4.s.o(.text); build/asm/main_800C85C4.s.o(.rodata); build/asm/main_800C85C4.s.o(.data); }
    .main_800C85C4_bss (NOLOAD) : { build/asm/main_800C85C4.s.o(.bss); }
    .main_800D6FF8 0x800D6FF8 : AT(0x000D7B78) { build/asm/data/main_800D6FF8.bin.o(.data); }
    .main_800E1198 0x800E1198 : AT(0x000E1D18) { FILL(0x00000000); build/asm/main_800E1198.s.o(.text); build/asm/main_800E1198.s.o(.rodata); build/asm/main_800E1198.s.o(.data); }
    .main_800E1198_bss (NOLOAD) : { build/asm/main_800E1198.s.o(.bss); }
    .main_800E11B8 0x800E11B8 : AT(0x000E1D38) { build/asm/data/main_800E11B8.bin.o(.data); }
    .main_800F8064 0x800F8064 : AT(0x000F8BE4) { FILL(0x00000000); build/asm/main_800F8064.s.o(.text); build/asm/main_800F8064.s.o(.rodata); build/asm/main_800F8064.s.o(.data); }
    .main_800F8064_bss (NOLOAD) : { build/asm/main_800F8064.s.o(.bss); }
    .main_800F80B8 0x800F80B8 : AT(0x000F8C38) { build/asm/data/main_800F80B8.bin.o(.data); }
    .assets 0x80400480 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
