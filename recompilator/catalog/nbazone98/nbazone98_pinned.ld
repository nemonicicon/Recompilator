SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004AC 0x800004AC : AT(0x000010AC) { FILL(0x00000000); build/asm/main_800004AC.s.o(.text); build/asm/main_800004AC.s.o(.rodata); build/asm/main_800004AC.s.o(.data); }
    .main_800004AC_bss (NOLOAD) : { build/asm/main_800004AC.s.o(.bss); }
    .main_800D2794 0x800D2794 : AT(0x000D3394) { FILL(0x00000000); build/asm/main_800D2794.s.o(.text); build/asm/main_800D2794.s.o(.rodata); build/asm/main_800D2794.s.o(.data); }
    .main_800D2794_bss (NOLOAD) : { build/asm/main_800D2794.s.o(.bss); }
    .main_800D2B60 0x800D2B60 : AT(0x000D3760) { FILL(0x00000000); build/asm/main_800D2B60.s.o(.text); build/asm/main_800D2B60.s.o(.rodata); build/asm/main_800D2B60.s.o(.data); }
    .main_800D2B60_bss (NOLOAD) : { build/asm/main_800D2B60.s.o(.bss); }
    .main_800E8AB8 0x800E8AB8 : AT(0x000E96B8) { FILL(0x00000000); build/asm/main_800E8AB8.s.o(.text); build/asm/main_800E8AB8.s.o(.rodata); build/asm/main_800E8AB8.s.o(.data); }
    .main_800E8AB8_bss (NOLOAD) : { build/asm/main_800E8AB8.s.o(.bss); }
    .main_800E8B48 0x800E8B48 : AT(0x000E9748) { FILL(0x00000000); build/asm/main_800E8B48.s.o(.text); build/asm/main_800E8B48.s.o(.rodata); build/asm/main_800E8B48.s.o(.data); }
    .main_800E8B48_bss (NOLOAD) : { build/asm/main_800E8B48.s.o(.bss); }
    .main_800E8BF8 0x800E8BF8 : AT(0x000E97F8) { FILL(0x00000000); build/asm/main_800E8BF8.s.o(.text); build/asm/main_800E8BF8.s.o(.rodata); build/asm/main_800E8BF8.s.o(.data); }
    .main_800E8BF8_bss (NOLOAD) : { build/asm/main_800E8BF8.s.o(.bss); }
    .main_800E8DF8 0x800E8DF8 : AT(0x000E99F8) { FILL(0x00000000); build/asm/data/main_800E8DF8.data.s.o(.data); }
    .main_800E9180 0x800E9180 : AT(0x000E9D80) { FILL(0x00000000); build/asm/main_800E9180.s.o(.text); build/asm/main_800E9180.s.o(.rodata); build/asm/main_800E9180.s.o(.data); }
    .main_800E9180_bss (NOLOAD) : { build/asm/main_800E9180.s.o(.bss); }
    .main_800E920C 0x800E920C : AT(0x000E9E0C) { FILL(0x00000000); build/asm/main_800E920C.s.o(.text); build/asm/main_800E920C.s.o(.rodata); build/asm/main_800E920C.s.o(.data); }
    .main_800E920C_bss (NOLOAD) : { build/asm/main_800E920C.s.o(.bss); }
    .main_800E9228 0x800E9228 : AT(0x000E9E28) { FILL(0x00000000); build/asm/main_800E9228.s.o(.text); build/asm/main_800E9228.s.o(.rodata); build/asm/main_800E9228.s.o(.data); }
    .main_800E9228_bss (NOLOAD) : { build/asm/main_800E9228.s.o(.bss); }
    .main_800E92A8 0x800E92A8 : AT(0x000E9EA8) { FILL(0x00000000); build/asm/main_800E92A8.s.o(.text); build/asm/main_800E92A8.s.o(.rodata); build/asm/main_800E92A8.s.o(.data); }
    .main_800E92A8_bss (NOLOAD) : { build/asm/main_800E92A8.s.o(.bss); }
    .main_800E92B4 0x800E92B4 : AT(0x000E9EB4) { FILL(0x00000000); build/asm/data/main_800E92B4.data.s.o(.data); }
    .main_800E93C0 0x800E93C0 : AT(0x000E9FC0) { FILL(0x00000000); build/asm/main_800E93C0.s.o(.text); build/asm/main_800E93C0.s.o(.rodata); build/asm/main_800E93C0.s.o(.data); }
    .main_800E93C0_bss (NOLOAD) : { build/asm/main_800E93C0.s.o(.bss); }
    .main_800E955C 0x800E955C : AT(0x000EA15C) { FILL(0x00000000); build/asm/data/main_800E955C.data.s.o(.data); }
    .main_800E95E0 0x800E95E0 : AT(0x000EA1E0) { FILL(0x00000000); build/asm/main_800E95E0.s.o(.text); build/asm/main_800E95E0.s.o(.rodata); build/asm/main_800E95E0.s.o(.data); }
    .main_800E95E0_bss (NOLOAD) : { build/asm/main_800E95E0.s.o(.bss); }
    .main_800E966C 0x800E966C : AT(0x000EA26C) { FILL(0x00000000); build/asm/data/main_800E966C.data.s.o(.data); }
    .main_800E97AC 0x800E97AC : AT(0x000EA3AC) { FILL(0x00000000); build/asm/main_800E97AC.s.o(.text); build/asm/main_800E97AC.s.o(.rodata); build/asm/main_800E97AC.s.o(.data); }
    .main_800E97AC_bss (NOLOAD) : { build/asm/main_800E97AC.s.o(.bss); }
    .main_800E97B0 0x800E97B0 : AT(0x000EA3B0) { FILL(0x00000000); build/asm/data/main_800E97B0.data.s.o(.data); }
    .main_800E992C 0x800E992C : AT(0x000EA52C) { FILL(0x00000000); build/asm/main_800E992C.s.o(.text); build/asm/main_800E992C.s.o(.rodata); build/asm/main_800E992C.s.o(.data); }
    .main_800E992C_bss (NOLOAD) : { build/asm/main_800E992C.s.o(.bss); }
    .main_800E9940 0x800E9940 : AT(0x000EA540) { FILL(0x00000000); build/asm/data/main_800E9940.data.s.o(.data); }
    .main_800F2270 0x800F2270 : AT(0x000F2E70) { FILL(0x00000000); build/asm/data/main_800F2270.data.s.o(.data); }
    .main_800F27F0 0x800F27F0 : AT(0x000F33F0) { FILL(0x00000000); build/asm/data/main_800F27F0.data.s.o(.data); }
    .main_800F2EC0 0x800F2EC0 : AT(0x000F3AC0) { FILL(0x00000000); build/asm/main_800F2EC0.s.o(.text); build/asm/main_800F2EC0.s.o(.rodata); build/asm/main_800F2EC0.s.o(.data); }
    .main_800F2EC0_bss (NOLOAD) : { build/asm/main_800F2EC0.s.o(.bss); }
    .main_800F2F3C 0x800F2F3C : AT(0x000F3B3C) { FILL(0x00000000); build/asm/data/main_800F2F3C.data.s.o(.data); }
    .main_800F3C1C 0x800F3C1C : AT(0x000F481C) { FILL(0x00000000); build/asm/main_800F3C1C.s.o(.text); build/asm/main_800F3C1C.s.o(.rodata); build/asm/main_800F3C1C.s.o(.data); }
    .main_800F3C1C_bss (NOLOAD) : { build/asm/main_800F3C1C.s.o(.bss); }
    .main_800F3C30 0x800F3C30 : AT(0x000F4830) { FILL(0x00000000); build/asm/data/main_800F3C30.data.s.o(.data); }
    .main_800F4658 0x800F4658 : AT(0x000F5258) { FILL(0x00000000); build/asm/data/main_800F4658.data.s.o(.data); }
    .main_800F4A7C 0x800F4A7C : AT(0x000F567C) { FILL(0x00000000); build/asm/main_800F4A7C.s.o(.text); build/asm/main_800F4A7C.s.o(.rodata); build/asm/main_800F4A7C.s.o(.data); }
    .main_800F4A7C_bss (NOLOAD) : { build/asm/main_800F4A7C.s.o(.bss); }
    .main_800F4AF8 0x800F4AF8 : AT(0x000F56F8) { FILL(0x00000000); build/asm/data/main_800F4AF8.data.s.o(.data); }
    .main_800F6938 0x800F6938 : AT(0x000F7538) { FILL(0x00000000); build/asm/main_800F6938.s.o(.text); build/asm/main_800F6938.s.o(.rodata); build/asm/main_800F6938.s.o(.data); }
    .main_800F6938_bss (NOLOAD) : { build/asm/main_800F6938.s.o(.bss); }
    .main_800F69E4 0x800F69E4 : AT(0x000F75E4) { FILL(0x00000000); build/asm/data/main_800F69E4.data.s.o(.data); }
    .main_800F8688 0x800F8688 : AT(0x000F9288) { FILL(0x00000000); build/asm/main_800F8688.s.o(.text); build/asm/main_800F8688.s.o(.rodata); build/asm/main_800F8688.s.o(.data); }
    .main_800F8688_bss (NOLOAD) : { build/asm/main_800F8688.s.o(.bss); }
    .main_800F8F48 0x800F8F48 : AT(0x000F9B48) { FILL(0x00000000); build/asm/data/main_800F8F48.data.s.o(.data); }
    .main_800F9618 0x800F9618 : AT(0x000FA218) { FILL(0x00000000); build/asm/main_800F9618.s.o(.text); build/asm/main_800F9618.s.o(.rodata); build/asm/main_800F9618.s.o(.data); }
    .main_800F9618_bss (NOLOAD) : { build/asm/main_800F9618.s.o(.bss); }
    .main_800F9620 0x800F9620 : AT(0x000FA220) { FILL(0x00000000); build/asm/data/main_800F9620.data.s.o(.data); }
    .main_800FC5C4 0x800FC5C4 : AT(0x000FD1C4) { FILL(0x00000000); build/asm/main_800FC5C4.s.o(.text); build/asm/main_800FC5C4.s.o(.rodata); build/asm/main_800FC5C4.s.o(.data); }
    .main_800FC5C4_bss (NOLOAD) : { build/asm/main_800FC5C4.s.o(.bss); }
    .main_800FC5CC 0x800FC5CC : AT(0x000FD1CC) { FILL(0x00000000); build/asm/data/main_800FC5CC.data.s.o(.data); }
    .main_800FF608 0x800FF608 : AT(0x00100208) { FILL(0x00000000); build/asm/main_800FF608.s.o(.text); build/asm/main_800FF608.s.o(.rodata); build/asm/main_800FF608.s.o(.data); }
    .main_800FF608_bss (NOLOAD) : { build/asm/main_800FF608.s.o(.bss); }
    .main_800FF70C 0x800FF70C : AT(0x0010030C) { FILL(0x00000000); build/asm/data/main_800FF70C.data.s.o(.data); }
    .main_80100104 0x80100104 : AT(0x00100D04) { FILL(0x00000000); build/asm/main_80100104.s.o(.text); build/asm/main_80100104.s.o(.rodata); build/asm/main_80100104.s.o(.data); }
    .main_80100104_bss (NOLOAD) : { build/asm/main_80100104.s.o(.bss); }
    .main_80100110 0x80100110 : AT(0x00100D10) { FILL(0x00000000); build/asm/data/main_80100110.data.s.o(.data); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
