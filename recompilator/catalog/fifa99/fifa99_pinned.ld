SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80000438 0x80000438 : AT(0x00001038) { FILL(0x00000000); build/asm/main_80000438.s.o(.text); build/asm/main_80000438.s.o(.rodata); build/asm/main_80000438.s.o(.data); }
    .main_80000438_bss (NOLOAD) : { build/asm/main_80000438.s.o(.bss); }
    .main_8000197C 0x8000197C : AT(0x0000257C) { FILL(0x00000000); build/asm/main_8000197C.s.o(.text); build/asm/main_8000197C.s.o(.rodata); build/asm/main_8000197C.s.o(.data); }
    .main_8000197C_bss (NOLOAD) : { build/asm/main_8000197C.s.o(.bss); }
    .main_800021A8 0x800021A8 : AT(0x00002DA8) { FILL(0x00000000); build/asm/main_800021A8.s.o(.text); build/asm/main_800021A8.s.o(.rodata); build/asm/main_800021A8.s.o(.data); }
    .main_800021A8_bss (NOLOAD) : { build/asm/main_800021A8.s.o(.bss); }
    .main_80013C80 0x80013C80 : AT(0x00014880) { build/asm/data/main_80013C80.bin.o(.data); }
    .main_80014F08 0x80014F08 : AT(0x00015B08) { build/asm/data/main_80014F08.bin.o(.data); }
    .main_800168B4 0x800168B4 : AT(0x000174B4) { build/asm/data/main_800168B4.bin.o(.data); }
    .main_800174D0 0x800174D0 : AT(0x000180D0) { build/asm/data/main_800174D0.bin.o(.data); }
    .main_80017508 0x80017508 : AT(0x00018108) { build/asm/data/main_80017508.bin.o(.data); }
    .main_8001768C 0x8001768C : AT(0x0001828C) { build/asm/data/main_8001768C.bin.o(.data); }
    .main_800192B0 0x800192B0 : AT(0x00019EB0) { build/asm/data/main_800192B0.bin.o(.data); }
    .main_80032994 0x80032994 : AT(0x00033594) { build/asm/data/main_80032994.bin.o(.data); }
    .main_80032A5C 0x80032A5C : AT(0x0003365C) { build/asm/data/main_80032A5C.bin.o(.data); }
    .main_8003E564 0x8003E564 : AT(0x0003F164) { build/asm/data/main_8003E564.bin.o(.data); }
    .main_8003E588 0x8003E588 : AT(0x0003F188) { build/asm/data/main_8003E588.bin.o(.data); }
    .main_8004CEE0 0x8004CEE0 : AT(0x0004DAE0) { build/asm/data/main_8004CEE0.bin.o(.data); }
    .main_8004CF8C 0x8004CF8C : AT(0x0004DB8C) { build/asm/data/main_8004CF8C.bin.o(.data); }
    .main_8004F628 0x8004F628 : AT(0x00050228) { build/asm/data/main_8004F628.bin.o(.data); }
    .main_8004F654 0x8004F654 : AT(0x00050254) { build/asm/data/main_8004F654.bin.o(.data); }
    .main_80054C84 0x80054C84 : AT(0x00055884) { build/asm/data/main_80054C84.bin.o(.data); }
    .main_80054DA4 0x80054DA4 : AT(0x000559A4) { build/asm/data/main_80054DA4.bin.o(.data); }
    .main_80055EC0 0x80055EC0 : AT(0x00056AC0) { build/asm/data/main_80055EC0.bin.o(.data); }
    .main_80055F08 0x80055F08 : AT(0x00056B08) { build/asm/data/main_80055F08.bin.o(.data); }
    .main_80058184 0x80058184 : AT(0x00058D84) { build/asm/data/main_80058184.bin.o(.data); }
    .main_800581F8 0x800581F8 : AT(0x00058DF8) { build/asm/data/main_800581F8.bin.o(.data); }
    .main_8005C5D0 0x8005C5D0 : AT(0x0005D1D0) { build/asm/data/main_8005C5D0.bin.o(.data); }
    .main_8005C604 0x8005C604 : AT(0x0005D204) { build/asm/data/main_8005C604.bin.o(.data); }
    .main_8005C95C 0x8005C95C : AT(0x0005D55C) { build/asm/data/main_8005C95C.bin.o(.data); }
    .main_8005C9A8 0x8005C9A8 : AT(0x0005D5A8) { build/asm/data/main_8005C9A8.bin.o(.data); }
    .main_80060178 0x80060178 : AT(0x00060D78) { build/asm/data/main_80060178.bin.o(.data); }
    .main_800601B4 0x800601B4 : AT(0x00060DB4) { build/asm/data/main_800601B4.bin.o(.data); }
    .main_80060D9C 0x80060D9C : AT(0x0006199C) { build/asm/data/main_80060D9C.bin.o(.data); }
    .main_80060DBC 0x80060DBC : AT(0x000619BC) { build/asm/data/main_80060DBC.bin.o(.data); }
    .main_800647D4 0x800647D4 : AT(0x000653D4) { build/asm/data/main_800647D4.bin.o(.data); }
    .main_80064858 0x80064858 : AT(0x00065458) { build/asm/data/main_80064858.bin.o(.data); }
    .main_8006AA68 0x8006AA68 : AT(0x0006B668) { build/asm/data/main_8006AA68.bin.o(.data); }
    .main_8006AAE8 0x8006AAE8 : AT(0x0006B6E8) { build/asm/data/main_8006AAE8.bin.o(.data); }
    .main_8007009C 0x8007009C : AT(0x00070C9C) { build/asm/data/main_8007009C.bin.o(.data); }
    .main_800700A8 0x800700A8 : AT(0x00070CA8) { build/asm/data/main_800700A8.bin.o(.data); }
    .main_80070660 0x80070660 : AT(0x00071260) { build/asm/data/main_80070660.bin.o(.data); }
    .main_800706E0 0x800706E0 : AT(0x000712E0) { build/asm/data/main_800706E0.bin.o(.data); }
    .main_8007078C 0x8007078C : AT(0x0007138C) { build/asm/data/main_8007078C.bin.o(.data); }
    .main_80070798 0x80070798 : AT(0x00071398) { build/asm/data/main_80070798.bin.o(.data); }
    .main_80071824 0x80071824 : AT(0x00072424) { build/asm/data/main_80071824.bin.o(.data); }
    .main_80071840 0x80071840 : AT(0x00072440) { build/asm/data/main_80071840.bin.o(.data); }
    .main_800747CC 0x800747CC : AT(0x000753CC) { build/asm/data/main_800747CC.bin.o(.data); }
    .main_80074824 0x80074824 : AT(0x00075424) { build/asm/data/main_80074824.bin.o(.data); }
    .main_8007CD74 0x8007CD74 : AT(0x0007D974) { build/asm/data/main_8007CD74.bin.o(.data); }
    .main_8007CD80 0x8007CD80 : AT(0x0007D980) { build/asm/data/main_8007CD80.bin.o(.data); }
    .main_8007D5CC 0x8007D5CC : AT(0x0007E1CC) { build/asm/data/main_8007D5CC.bin.o(.data); }
    .main_8007D5D8 0x8007D5D8 : AT(0x0007E1D8) { build/asm/data/main_8007D5D8.bin.o(.data); }
    .main_8007F5D4 0x8007F5D4 : AT(0x000801D4) { build/asm/data/main_8007F5D4.bin.o(.data); }
    .main_8007F634 0x8007F634 : AT(0x00080234) { build/asm/data/main_8007F634.bin.o(.data); }
    .main_8008608C 0x8008608C : AT(0x00086C8C) { build/asm/data/main_8008608C.bin.o(.data); }
    .main_800860D0 0x800860D0 : AT(0x00086CD0) { build/asm/data/main_800860D0.bin.o(.data); }
    .main_80092F40 0x80092F40 : AT(0x00093B40) { build/asm/data/main_80092F40.bin.o(.data); }
    .main_80092F48 0x80092F48 : AT(0x00093B48) { build/asm/data/main_80092F48.bin.o(.data); }
    .main_8009998C 0x8009998C : AT(0x0009A58C) { build/asm/data/main_8009998C.bin.o(.data); }
    .main_800999EC 0x800999EC : AT(0x0009A5EC) { build/asm/data/main_800999EC.bin.o(.data); }
    .main_8009EA10 0x8009EA10 : AT(0x0009F610) { build/asm/data/main_8009EA10.bin.o(.data); }
    .main_8009EA40 0x8009EA40 : AT(0x0009F640) { build/asm/data/main_8009EA40.bin.o(.data); }
    .main_800A7368 0x800A7368 : AT(0x000A7F68) { build/asm/data/main_800A7368.bin.o(.data); }
    .main_800A7394 0x800A7394 : AT(0x000A7F94) { build/asm/data/main_800A7394.bin.o(.data); }
    .main_800AE964 0x800AE964 : AT(0x000AF564) { build/asm/data/main_800AE964.bin.o(.data); }
    .main_800AE9AC 0x800AE9AC : AT(0x000AF5AC) { build/asm/data/main_800AE9AC.bin.o(.data); }
    .main_800BB088 0x800BB088 : AT(0x000BBC88) { build/asm/data/main_800BB088.bin.o(.data); }
    .main_800BB0A8 0x800BB0A8 : AT(0x000BBCA8) { build/asm/data/main_800BB0A8.bin.o(.data); }
    .main_800BB868 0x800BB868 : AT(0x000BC468) { build/asm/data/main_800BB868.bin.o(.data); }
    .main_800BBA98 0x800BBA98 : AT(0x000BC698) { build/asm/data/main_800BBA98.bin.o(.data); }
    .main_800BC268 0x800BC268 : AT(0x000BCE68) { build/asm/data/main_800BC268.bin.o(.data); }
    .main_800BC2A8 0x800BC2A8 : AT(0x000BCEA8) { build/asm/data/main_800BC2A8.bin.o(.data); }
    .main_800BC2EC 0x800BC2EC : AT(0x000BCEEC) { build/asm/data/main_800BC2EC.bin.o(.data); }
    .main_800BC308 0x800BC308 : AT(0x000BCF08) { build/asm/data/main_800BC308.bin.o(.data); }
    .main_800BCB74 0x800BCB74 : AT(0x000BD774) { build/asm/data/main_800BCB74.bin.o(.data); }
    .main_800BCBC8 0x800BCBC8 : AT(0x000BD7C8) { build/asm/data/main_800BCBC8.bin.o(.data); }
    .main_800BCF00 0x800BCF00 : AT(0x000BDB00) { build/asm/data/main_800BCF00.bin.o(.data); }
    .main_800BCF04 0x800BCF04 : AT(0x000BDB04) { build/asm/data/main_800BCF04.bin.o(.data); }
    .main_800BD03C 0x800BD03C : AT(0x000BDC3C) { build/asm/data/main_800BD03C.bin.o(.data); }
    .main_800BD0F4 0x800BD0F4 : AT(0x000BDCF4) { build/asm/data/main_800BD0F4.bin.o(.data); }
    .main_800BF18C 0x800BF18C : AT(0x000BFD8C) { build/asm/data/main_800BF18C.bin.o(.data); }
    .main_800BF190 0x800BF190 : AT(0x000BFD90) { build/asm/data/main_800BF190.bin.o(.data); }
    .main_800C3FFC 0x800C3FFC : AT(0x000C4BFC) { build/asm/data/main_800C3FFC.bin.o(.data); }
    .main_800C4004 0x800C4004 : AT(0x000C4C04) { build/asm/data/main_800C4004.bin.o(.data); }
    .main_800D3F28 0x800D3F28 : AT(0x000D4B28) { build/asm/data/main_800D3F28.bin.o(.data); }
    .main_800D3F3C 0x800D3F3C : AT(0x000D4B3C) { build/asm/data/main_800D3F3C.bin.o(.data); }
    .main_800D4818 0x800D4818 : AT(0x000D5418) { build/asm/data/main_800D4818.bin.o(.data); }
    .main_800D48CC 0x800D48CC : AT(0x000D54CC) { build/asm/data/main_800D48CC.bin.o(.data); }
    .main_800E1A8C 0x800E1A8C : AT(0x000E268C) { build/asm/data/main_800E1A8C.bin.o(.data); }
    .main_800E1B10 0x800E1B10 : AT(0x000E2710) { build/asm/data/main_800E1B10.bin.o(.data); }
    .main_800E3AC8 0x800E3AC8 : AT(0x000E46C8) { build/asm/data/main_800E3AC8.bin.o(.data); }
    .main_800E3AE8 0x800E3AE8 : AT(0x000E46E8) { build/asm/data/main_800E3AE8.bin.o(.data); }
    .main_800E4B28 0x800E4B28 : AT(0x000E5728) { build/asm/data/main_800E4B28.bin.o(.data); }
    .main_800E4B30 0x800E4B30 : AT(0x000E5730) { build/asm/data/main_800E4B30.bin.o(.data); }
    .main_800E9DE0 0x800E9DE0 : AT(0x000EA9E0) { build/asm/data/main_800E9DE0.bin.o(.data); }
    .main_800E9DE8 0x800E9DE8 : AT(0x000EA9E8) { build/asm/data/main_800E9DE8.bin.o(.data); }
    .main_800EA200 0x800EA200 : AT(0x000EAE00) { build/asm/data/main_800EA200.bin.o(.data); }
    .main_800EA220 0x800EA220 : AT(0x000EAE20) { build/asm/data/main_800EA220.bin.o(.data); }
    .main_800EAF18 0x800EAF18 : AT(0x000EBB18) { build/asm/data/main_800EAF18.bin.o(.data); }
    .main_800EAF4C 0x800EAF4C : AT(0x000EBB4C) { build/asm/data/main_800EAF4C.bin.o(.data); }
    .main_800F0978 0x800F0978 : AT(0x000F1578) { build/asm/data/main_800F0978.bin.o(.data); }
    .main_800F0994 0x800F0994 : AT(0x000F1594) { build/asm/data/main_800F0994.bin.o(.data); }
    .main_800F4398 0x800F4398 : AT(0x000F4F98) { build/asm/data/main_800F4398.bin.o(.data); }
    .main_800F43C0 0x800F43C0 : AT(0x000F4FC0) { build/asm/data/main_800F43C0.bin.o(.data); }
    .main_800F63DC 0x800F63DC : AT(0x000F6FDC) { build/asm/data/main_800F63DC.bin.o(.data); }
    .main_800F6488 0x800F6488 : AT(0x000F7088) { build/asm/data/main_800F6488.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
