SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80200000 0x80200000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80200000.s.o(.text); build/asm/main_80200000.s.o(.rodata); build/asm/main_80200000.s.o(.data); }
    .main_80200000_bss (NOLOAD) : { build/asm/main_80200000.s.o(.bss); }
    .main_80208570 0x80208570 : AT(0x00009570) { FILL(0x00000000); build/asm/main_80208570.s.o(.text); build/asm/main_80208570.s.o(.rodata); build/asm/main_80208570.s.o(.data); }
    .main_80208570_bss (NOLOAD) : { build/asm/main_80208570.s.o(.bss); }
    .main_80209D70 0x80209D70 : AT(0x0000AD70) { FILL(0x00000000); build/asm/main_80209D70.s.o(.text); build/asm/main_80209D70.s.o(.rodata); build/asm/main_80209D70.s.o(.data); }
    .main_80209D70_bss (NOLOAD) : { build/asm/main_80209D70.s.o(.bss); }
    .main_80210F80 0x80210F80 : AT(0x00011F80) { FILL(0x00000000); build/asm/main_80210F80.s.o(.text); build/asm/main_80210F80.s.o(.rodata); build/asm/main_80210F80.s.o(.data); }
    .main_80210F80_bss (NOLOAD) : { build/asm/main_80210F80.s.o(.bss); }
    .main_80211150 0x80211150 : AT(0x00012150) { FILL(0x00000000); build/asm/main_80211150.s.o(.text); build/asm/main_80211150.s.o(.rodata); build/asm/main_80211150.s.o(.data); }
    .main_80211150_bss (NOLOAD) : { build/asm/main_80211150.s.o(.bss); }
    .main_80211840 0x80211840 : AT(0x00012840) { FILL(0x00000000); build/asm/main_80211840.s.o(.text); build/asm/main_80211840.s.o(.rodata); build/asm/main_80211840.s.o(.data); }
    .main_80211840_bss (NOLOAD) : { build/asm/main_80211840.s.o(.bss); }
    .main_80214A3C 0x80214A3C : AT(0x00015A3C) { FILL(0x00000000); build/asm/main_80214A3C.s.o(.text); build/asm/main_80214A3C.s.o(.rodata); build/asm/main_80214A3C.s.o(.data); }
    .main_80214A3C_bss (NOLOAD) : { build/asm/main_80214A3C.s.o(.bss); }
    .main_802172D0 0x802172D0 : AT(0x000182D0) { FILL(0x00000000); build/asm/main_802172D0.s.o(.text); build/asm/main_802172D0.s.o(.rodata); build/asm/main_802172D0.s.o(.data); }
    .main_802172D0_bss (NOLOAD) : { build/asm/main_802172D0.s.o(.bss); }
    .main_8021BE28 0x8021BE28 : AT(0x0001CE28) { FILL(0x00000000); build/asm/main_8021BE28.s.o(.text); build/asm/main_8021BE28.s.o(.rodata); build/asm/main_8021BE28.s.o(.data); }
    .main_8021BE28_bss (NOLOAD) : { build/asm/main_8021BE28.s.o(.bss); }
    .main_8021E620 0x8021E620 : AT(0x0001F620) { FILL(0x00000000); build/asm/main_8021E620.s.o(.text); build/asm/main_8021E620.s.o(.rodata); build/asm/main_8021E620.s.o(.data); }
    .main_8021E620_bss (NOLOAD) : { build/asm/main_8021E620.s.o(.bss); }
    .main_80226D9C 0x80226D9C : AT(0x00027D9C) { FILL(0x00000000); build/asm/main_80226D9C.s.o(.text); build/asm/main_80226D9C.s.o(.rodata); build/asm/main_80226D9C.s.o(.data); }
    .main_80226D9C_bss (NOLOAD) : { build/asm/main_80226D9C.s.o(.bss); }
    .main_802288D4 0x802288D4 : AT(0x000298D4) { FILL(0x00000000); build/asm/main_802288D4.s.o(.text); build/asm/main_802288D4.s.o(.rodata); build/asm/main_802288D4.s.o(.data); }
    .main_802288D4_bss (NOLOAD) : { build/asm/main_802288D4.s.o(.bss); }
    .main_80229550 0x80229550 : AT(0x0002A550) { FILL(0x00000000); build/asm/main_80229550.s.o(.text); build/asm/main_80229550.s.o(.rodata); build/asm/main_80229550.s.o(.data); }
    .main_80229550_bss (NOLOAD) : { build/asm/main_80229550.s.o(.bss); }
    .main_80234FF8 0x80234FF8 : AT(0x00035FF8) { FILL(0x00000000); build/asm/main_80234FF8.s.o(.text); build/asm/main_80234FF8.s.o(.rodata); build/asm/main_80234FF8.s.o(.data); }
    .main_80234FF8_bss (NOLOAD) : { build/asm/main_80234FF8.s.o(.bss); }
    .main_80241314 0x80241314 : AT(0x00042314) { FILL(0x00000000); build/asm/main_80241314.s.o(.text); build/asm/main_80241314.s.o(.rodata); build/asm/main_80241314.s.o(.data); }
    .main_80241314_bss (NOLOAD) : { build/asm/main_80241314.s.o(.bss); }
    .main_80242890 0x80242890 : AT(0x00043890) { FILL(0x00000000); build/asm/main_80242890.s.o(.text); build/asm/main_80242890.s.o(.rodata); build/asm/main_80242890.s.o(.data); }
    .main_80242890_bss (NOLOAD) : { build/asm/main_80242890.s.o(.bss); }
    .main_80244BA8 0x80244BA8 : AT(0x00045BA8) { FILL(0x00000000); build/asm/main_80244BA8.s.o(.text); build/asm/main_80244BA8.s.o(.rodata); build/asm/main_80244BA8.s.o(.data); }
    .main_80244BA8_bss (NOLOAD) : { build/asm/main_80244BA8.s.o(.bss); }
    .main_80256270 0x80256270 : AT(0x00057270) { FILL(0x00000000); build/asm/main_80256270.s.o(.text); build/asm/main_80256270.s.o(.rodata); build/asm/main_80256270.s.o(.data); }
    .main_80256270_bss (NOLOAD) : { build/asm/main_80256270.s.o(.bss); }
    .main_80258070 0x80258070 : AT(0x00059070) { FILL(0x00000000); build/asm/main_80258070.s.o(.text); build/asm/main_80258070.s.o(.rodata); build/asm/main_80258070.s.o(.data); }
    .main_80258070_bss (NOLOAD) : { build/asm/main_80258070.s.o(.bss); }
    .main_80266760 0x80266760 : AT(0x00067760) { FILL(0x00000000); build/asm/main_80266760.s.o(.text); build/asm/main_80266760.s.o(.rodata); build/asm/main_80266760.s.o(.data); }
    .main_80266760_bss (NOLOAD) : { build/asm/main_80266760.s.o(.bss); }
    .main_8026B204 0x8026B204 : AT(0x0006C204) { FILL(0x00000000); build/asm/main_8026B204.s.o(.text); build/asm/main_8026B204.s.o(.rodata); build/asm/main_8026B204.s.o(.data); }
    .main_8026B204_bss (NOLOAD) : { build/asm/main_8026B204.s.o(.bss); }
    .main_8026B5D0 0x8026B5D0 : AT(0x0006C5D0) { FILL(0x00000000); build/asm/main_8026B5D0.s.o(.text); build/asm/main_8026B5D0.s.o(.rodata); build/asm/main_8026B5D0.s.o(.data); }
    .main_8026B5D0_bss (NOLOAD) : { build/asm/main_8026B5D0.s.o(.bss); }
    .main_8026C760 0x8026C760 : AT(0x0006D760) { FILL(0x00000000); build/asm/main_8026C760.s.o(.text); build/asm/main_8026C760.s.o(.rodata); build/asm/main_8026C760.s.o(.data); }
    .main_8026C760_bss (NOLOAD) : { build/asm/main_8026C760.s.o(.bss); }
    .main_8026CE20 0x8026CE20 : AT(0x0006DE20) { FILL(0x00000000); build/asm/main_8026CE20.s.o(.text); build/asm/main_8026CE20.s.o(.rodata); build/asm/main_8026CE20.s.o(.data); }
    .main_8026CE20_bss (NOLOAD) : { build/asm/main_8026CE20.s.o(.bss); }
    .main_80280BD4 0x80280BD4 : AT(0x00081BD4) { FILL(0x00000000); build/asm/main_80280BD4.s.o(.text); build/asm/main_80280BD4.s.o(.rodata); build/asm/main_80280BD4.s.o(.data); }
    .main_80280BD4_bss (NOLOAD) : { build/asm/main_80280BD4.s.o(.bss); }
    .main_8029506C 0x8029506C : AT(0x0009606C) { build/asm/data/main_8029506C.bin.o(.data); }
    .main_802A109C 0x802A109C : AT(0x000A209C) { build/asm/data/main_802A109C.bin.o(.data); }
    .main_802A16F0 0x802A16F0 : AT(0x000A26F0) { FILL(0x00000000); build/asm/main_802A16F0.s.o(.text); build/asm/main_802A16F0.s.o(.rodata); build/asm/main_802A16F0.s.o(.data); }
    .main_802A16F0_bss (NOLOAD) : { build/asm/main_802A16F0.s.o(.bss); }
    .main_802A4670 0x802A4670 : AT(0x000A5670) { FILL(0x00000000); build/asm/main_802A4670.s.o(.text); build/asm/main_802A4670.s.o(.rodata); build/asm/main_802A4670.s.o(.data); }
    .main_802A4670_bss (NOLOAD) : { build/asm/main_802A4670.s.o(.bss); }
    .main_802A56EC 0x802A56EC : AT(0x000A66EC) { build/asm/data/main_802A56EC.bin.o(.data); }
    .main_802A59C8 0x802A59C8 : AT(0x000A69C8) { build/asm/data/main_802A59C8.bin.o(.data); }
    .main_802A5E50 0x802A5E50 : AT(0x000A6E50) { FILL(0x00000000); build/asm/main_802A5E50.s.o(.text); build/asm/main_802A5E50.s.o(.rodata); build/asm/main_802A5E50.s.o(.data); }
    .main_802A5E50_bss (NOLOAD) : { build/asm/main_802A5E50.s.o(.bss); }
    .main_802A61E8 0x802A61E8 : AT(0x000A71E8) { FILL(0x00000000); build/asm/main_802A61E8.s.o(.text); build/asm/main_802A61E8.s.o(.rodata); build/asm/main_802A61E8.s.o(.data); }
    .main_802A61E8_bss (NOLOAD) : { build/asm/main_802A61E8.s.o(.bss); }
    .main_802A64F8 0x802A64F8 : AT(0x000A74F8) { build/asm/data/main_802A64F8.bin.o(.data); }
    .main_802A76D4 0x802A76D4 : AT(0x000A86D4) { FILL(0x00000000); build/asm/main_802A76D4.s.o(.text); build/asm/main_802A76D4.s.o(.rodata); build/asm/main_802A76D4.s.o(.data); }
    .main_802A76D4_bss (NOLOAD) : { build/asm/main_802A76D4.s.o(.bss); }
    .main_802A7BEC 0x802A7BEC : AT(0x000A8BEC) { FILL(0x00000000); build/asm/main_802A7BEC.s.o(.text); build/asm/main_802A7BEC.s.o(.rodata); build/asm/main_802A7BEC.s.o(.data); }
    .main_802A7BEC_bss (NOLOAD) : { build/asm/main_802A7BEC.s.o(.bss); }
    .main_802A9164 0x802A9164 : AT(0x000AA164) { FILL(0x00000000); build/asm/main_802A9164.s.o(.text); build/asm/main_802A9164.s.o(.rodata); build/asm/main_802A9164.s.o(.data); }
    .main_802A9164_bss (NOLOAD) : { build/asm/main_802A9164.s.o(.bss); }
    .main_802AA6FC 0x802AA6FC : AT(0x000AB6FC) { FILL(0x00000000); build/asm/main_802AA6FC.s.o(.text); build/asm/main_802AA6FC.s.o(.rodata); build/asm/main_802AA6FC.s.o(.data); }
    .main_802AA6FC_bss (NOLOAD) : { build/asm/main_802AA6FC.s.o(.bss); }
    .main_802ABCF4 0x802ABCF4 : AT(0x000ACCF4) { FILL(0x00000000); build/asm/main_802ABCF4.s.o(.text); build/asm/main_802ABCF4.s.o(.rodata); build/asm/main_802ABCF4.s.o(.data); }
    .main_802ABCF4_bss (NOLOAD) : { build/asm/main_802ABCF4.s.o(.bss); }
    .main_802ABDC8 0x802ABDC8 : AT(0x000ACDC8) { build/asm/data/main_802ABDC8.bin.o(.data); }
    .main_802AC294 0x802AC294 : AT(0x000AD294) { FILL(0x00000000); build/asm/main_802AC294.s.o(.text); build/asm/main_802AC294.s.o(.rodata); build/asm/main_802AC294.s.o(.data); }
    .main_802AC294_bss (NOLOAD) : { build/asm/main_802AC294.s.o(.bss); }
    .main_802AC440 0x802AC440 : AT(0x000AD440) { build/asm/data/main_802AC440.bin.o(.data); }
    .main_802C0990 0x802C0990 : AT(0x000C1990) { FILL(0x00000000); build/asm/main_802C0990.s.o(.text); build/asm/main_802C0990.s.o(.rodata); build/asm/main_802C0990.s.o(.data); }
    .main_802C0990_bss (NOLOAD) : { build/asm/main_802C0990.s.o(.bss); }
    .main_802C0A5C 0x802C0A5C : AT(0x000C1A5C) { build/asm/data/main_802C0A5C.bin.o(.data); }
    .main_802C2D60 0x802C2D60 : AT(0x000C3D60) { FILL(0x00000000); build/asm/main_802C2D60.s.o(.text); build/asm/main_802C2D60.s.o(.rodata); build/asm/main_802C2D60.s.o(.data); }
    .main_802C2D60_bss (NOLOAD) : { build/asm/main_802C2D60.s.o(.bss); }
    .main_802C2D88 0x802C2D88 : AT(0x000C3D88) { build/asm/data/main_802C2D88.bin.o(.data); }
    .main_802CD498 0x802CD498 : AT(0x000CE498) { FILL(0x00000000); build/asm/main_802CD498.s.o(.text); build/asm/main_802CD498.s.o(.rodata); build/asm/main_802CD498.s.o(.data); }
    .main_802CD498_bss (NOLOAD) : { build/asm/main_802CD498.s.o(.bss); }
    .main_802CD4B8 0x802CD4B8 : AT(0x000CE4B8) { build/asm/data/main_802CD4B8.bin.o(.data); }
    .main_802DE300 0x802DE300 : AT(0x000DF300) { FILL(0x00000000); build/asm/main_802DE300.s.o(.text); build/asm/main_802DE300.s.o(.rodata); build/asm/main_802DE300.s.o(.data); }
    .main_802DE300_bss (NOLOAD) : { build/asm/main_802DE300.s.o(.bss); }
    .main_802DE33C 0x802DE33C : AT(0x000DF33C) { build/asm/data/main_802DE33C.bin.o(.data); }
    .main_802F9E24 0x802F9E24 : AT(0x000FAE24) { build/asm/data/main_802F9E24.bin.o(.data); }
    .assets 0x80600000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
