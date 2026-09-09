SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800004B8 0x800004B8 : AT(0x000010B8) { FILL(0x00000000); build/asm/main_800004B8.s.o(.text); build/asm/main_800004B8.s.o(.rodata); build/asm/main_800004B8.s.o(.data); }
    .main_800004B8_bss (NOLOAD) : { build/asm/main_800004B8.s.o(.bss); }
    .main_80082D60 0x80082D60 : AT(0x00083960) { FILL(0x00000000); build/asm/main_80082D60.s.o(.text); build/asm/main_80082D60.s.o(.rodata); build/asm/main_80082D60.s.o(.data); }
    .main_80082D60_bss (NOLOAD) : { build/asm/main_80082D60.s.o(.bss); }
    .main_800842DC 0x800842DC : AT(0x00084EDC) { FILL(0x00000000); build/asm/main_800842DC.s.o(.text); build/asm/main_800842DC.s.o(.rodata); build/asm/main_800842DC.s.o(.data); }
    .main_800842DC_bss (NOLOAD) : { build/asm/main_800842DC.s.o(.bss); }
    .main_8008C520 0x8008C520 : AT(0x0008D120) { FILL(0x00000000); build/asm/main_8008C520.s.o(.text); build/asm/main_8008C520.s.o(.rodata); build/asm/main_8008C520.s.o(.data); }
    .main_8008C520_bss (NOLOAD) : { build/asm/main_8008C520.s.o(.bss); }
    .main_8008CB88 0x8008CB88 : AT(0x0008D788) { FILL(0x00000000); build/asm/main_8008CB88.s.o(.text); build/asm/main_8008CB88.s.o(.rodata); build/asm/main_8008CB88.s.o(.data); }
    .main_8008CB88_bss (NOLOAD) : { build/asm/main_8008CB88.s.o(.bss); }
    .main_8008DE08 0x8008DE08 : AT(0x0008EA08) { FILL(0x00000000); build/asm/main_8008DE08.s.o(.text); build/asm/main_8008DE08.s.o(.rodata); build/asm/main_8008DE08.s.o(.data); }
    .main_8008DE08_bss (NOLOAD) : { build/asm/main_8008DE08.s.o(.bss); }
    .main_80091F10 0x80091F10 : AT(0x00092B10) { FILL(0x00000000); build/asm/main_80091F10.s.o(.text); build/asm/main_80091F10.s.o(.rodata); build/asm/main_80091F10.s.o(.data); }
    .main_80091F10_bss (NOLOAD) : { build/asm/main_80091F10.s.o(.bss); }
    .main_80092390 0x80092390 : AT(0x00092F90) { FILL(0x00000000); build/asm/main_80092390.s.o(.text); build/asm/main_80092390.s.o(.rodata); build/asm/main_80092390.s.o(.data); }
    .main_80092390_bss (NOLOAD) : { build/asm/main_80092390.s.o(.bss); }
    .main_80092DBC 0x80092DBC : AT(0x000939BC) { FILL(0x00000000); build/asm/main_80092DBC.s.o(.text); build/asm/main_80092DBC.s.o(.rodata); build/asm/main_80092DBC.s.o(.data); }
    .main_80092DBC_bss (NOLOAD) : { build/asm/main_80092DBC.s.o(.bss); }
    .main_80093240 0x80093240 : AT(0x00093E40) { FILL(0x00000000); build/asm/main_80093240.s.o(.text); build/asm/main_80093240.s.o(.rodata); build/asm/main_80093240.s.o(.data); }
    .main_80093240_bss (NOLOAD) : { build/asm/main_80093240.s.o(.bss); }
    .main_800941A0 0x800941A0 : AT(0x00094DA0) { FILL(0x00000000); build/asm/main_800941A0.s.o(.text); build/asm/main_800941A0.s.o(.rodata); build/asm/main_800941A0.s.o(.data); }
    .main_800941A0_bss (NOLOAD) : { build/asm/main_800941A0.s.o(.bss); }
    .main_800945AC 0x800945AC : AT(0x000951AC) { FILL(0x00000000); build/asm/main_800945AC.s.o(.text); build/asm/main_800945AC.s.o(.rodata); build/asm/main_800945AC.s.o(.data); }
    .main_800945AC_bss (NOLOAD) : { build/asm/main_800945AC.s.o(.bss); }
    .main_80094720 0x80094720 : AT(0x00095320) { FILL(0x00000000); build/asm/main_80094720.s.o(.text); build/asm/main_80094720.s.o(.rodata); build/asm/main_80094720.s.o(.data); }
    .main_80094720_bss (NOLOAD) : { build/asm/main_80094720.s.o(.bss); }
    .main_8009493C 0x8009493C : AT(0x0009553C) { FILL(0x00000000); build/asm/main_8009493C.s.o(.text); build/asm/main_8009493C.s.o(.rodata); build/asm/main_8009493C.s.o(.data); }
    .main_8009493C_bss (NOLOAD) : { build/asm/main_8009493C.s.o(.bss); }
    .main_80096BD0 0x80096BD0 : AT(0x000977D0) { FILL(0x00000000); build/asm/main_80096BD0.s.o(.text); build/asm/main_80096BD0.s.o(.rodata); build/asm/main_80096BD0.s.o(.data); }
    .main_80096BD0_bss (NOLOAD) : { build/asm/main_80096BD0.s.o(.bss); }
    .main_800976F4 0x800976F4 : AT(0x000982F4) { FILL(0x00000000); build/asm/main_800976F4.s.o(.text); build/asm/main_800976F4.s.o(.rodata); build/asm/main_800976F4.s.o(.data); }
    .main_800976F4_bss (NOLOAD) : { build/asm/main_800976F4.s.o(.bss); }
    .main_800978F8 0x800978F8 : AT(0x000984F8) { FILL(0x00000000); build/asm/main_800978F8.s.o(.text); build/asm/main_800978F8.s.o(.rodata); build/asm/main_800978F8.s.o(.data); }
    .main_800978F8_bss (NOLOAD) : { build/asm/main_800978F8.s.o(.bss); }
    .main_80097FC8 0x80097FC8 : AT(0x00098BC8) { FILL(0x00000000); build/asm/main_80097FC8.s.o(.text); build/asm/main_80097FC8.s.o(.rodata); build/asm/main_80097FC8.s.o(.data); }
    .main_80097FC8_bss (NOLOAD) : { build/asm/main_80097FC8.s.o(.bss); }
    .main_80099350 0x80099350 : AT(0x00099F50) { FILL(0x00000000); build/asm/main_80099350.s.o(.text); build/asm/main_80099350.s.o(.rodata); build/asm/main_80099350.s.o(.data); }
    .main_80099350_bss (NOLOAD) : { build/asm/main_80099350.s.o(.bss); }
    .main_800B2A0C 0x800B2A0C : AT(0x000B360C) { FILL(0x00000000); build/asm/main_800B2A0C.s.o(.text); build/asm/main_800B2A0C.s.o(.rodata); build/asm/main_800B2A0C.s.o(.data); }
    .main_800B2A0C_bss (NOLOAD) : { build/asm/main_800B2A0C.s.o(.bss); }
    .main_800B7BB0 0x800B7BB0 : AT(0x000B87B0) { build/asm/data/main_800B7BB0.bin.o(.data); }
    .main_800BC430 0x800BC430 : AT(0x000BD030) { FILL(0x00000000); build/asm/main_800BC430.s.o(.text); build/asm/main_800BC430.s.o(.rodata); build/asm/main_800BC430.s.o(.data); }
    .main_800BC430_bss (NOLOAD) : { build/asm/main_800BC430.s.o(.bss); }
    .main_800C6C80 0x800C6C80 : AT(0x000C7880) { build/asm/data/main_800C6C80.bin.o(.data); }
    .main_800C78BC 0x800C78BC : AT(0x000C84BC) { FILL(0x00000000); build/asm/main_800C78BC.s.o(.text); build/asm/main_800C78BC.s.o(.rodata); build/asm/main_800C78BC.s.o(.data); }
    .main_800C78BC_bss (NOLOAD) : { build/asm/main_800C78BC.s.o(.bss); }
    .main_800C9520 0x800C9520 : AT(0x000CA120) { build/asm/data/main_800C9520.bin.o(.data); }
    .main_800C9DC8 0x800C9DC8 : AT(0x000CA9C8) { FILL(0x00000000); build/asm/main_800C9DC8.s.o(.text); build/asm/main_800C9DC8.s.o(.rodata); build/asm/main_800C9DC8.s.o(.data); }
    .main_800C9DC8_bss (NOLOAD) : { build/asm/main_800C9DC8.s.o(.bss); }
    .main_800CA050 0x800CA050 : AT(0x000CAC50) { build/asm/data/main_800CA050.bin.o(.data); }
    .main_800CA2D8 0x800CA2D8 : AT(0x000CAED8) { build/asm/data/main_800CA2D8.bin.o(.data); }
    .main_800CA6C4 0x800CA6C4 : AT(0x000CB2C4) { FILL(0x00000000); build/asm/main_800CA6C4.s.o(.text); build/asm/main_800CA6C4.s.o(.rodata); build/asm/main_800CA6C4.s.o(.data); }
    .main_800CA6C4_bss (NOLOAD) : { build/asm/main_800CA6C4.s.o(.bss); }
    .main_800CA6F8 0x800CA6F8 : AT(0x000CB2F8) { FILL(0x00000000); build/asm/main_800CA6F8.s.o(.text); build/asm/main_800CA6F8.s.o(.rodata); build/asm/main_800CA6F8.s.o(.data); }
    .main_800CA6F8_bss (NOLOAD) : { build/asm/main_800CA6F8.s.o(.bss); }
    .main_800CA7E8 0x800CA7E8 : AT(0x000CB3E8) { FILL(0x00000000); build/asm/main_800CA7E8.s.o(.text); build/asm/main_800CA7E8.s.o(.rodata); build/asm/main_800CA7E8.s.o(.data); }
    .main_800CA7E8_bss (NOLOAD) : { build/asm/main_800CA7E8.s.o(.bss); }
    .main_800CA954 0x800CA954 : AT(0x000CB554) { FILL(0x00000000); build/asm/main_800CA954.s.o(.text); build/asm/main_800CA954.s.o(.rodata); build/asm/main_800CA954.s.o(.data); }
    .main_800CA954_bss (NOLOAD) : { build/asm/main_800CA954.s.o(.bss); }
    .main_800CA980 0x800CA980 : AT(0x000CB580) { build/asm/data/main_800CA980.bin.o(.data); }
    .main_800CAA70 0x800CAA70 : AT(0x000CB670) { FILL(0x00000000); build/asm/main_800CAA70.s.o(.text); build/asm/main_800CAA70.s.o(.rodata); build/asm/main_800CAA70.s.o(.data); }
    .main_800CAA70_bss (NOLOAD) : { build/asm/main_800CAA70.s.o(.bss); }
    .main_800CABE4 0x800CABE4 : AT(0x000CB7E4) { FILL(0x00000000); build/asm/main_800CABE4.s.o(.text); build/asm/main_800CABE4.s.o(.rodata); build/asm/main_800CABE4.s.o(.data); }
    .main_800CABE4_bss (NOLOAD) : { build/asm/main_800CABE4.s.o(.bss); }
    .main_800CAC08 0x800CAC08 : AT(0x000CB808) { FILL(0x00000000); build/asm/main_800CAC08.s.o(.text); build/asm/main_800CAC08.s.o(.rodata); build/asm/main_800CAC08.s.o(.data); }
    .main_800CAC08_bss (NOLOAD) : { build/asm/main_800CAC08.s.o(.bss); }
    .main_800CAE74 0x800CAE74 : AT(0x000CBA74) { FILL(0x00000000); build/asm/main_800CAE74.s.o(.text); build/asm/main_800CAE74.s.o(.rodata); build/asm/main_800CAE74.s.o(.data); }
    .main_800CAE74_bss (NOLOAD) : { build/asm/main_800CAE74.s.o(.bss); }
    .main_800CB104 0x800CB104 : AT(0x000CBD04) { FILL(0x00000000); build/asm/main_800CB104.s.o(.text); build/asm/main_800CB104.s.o(.rodata); build/asm/main_800CB104.s.o(.data); }
    .main_800CB104_bss (NOLOAD) : { build/asm/main_800CB104.s.o(.bss); }
    .main_800CB394 0x800CB394 : AT(0x000CBF94) { FILL(0x00000000); build/asm/main_800CB394.s.o(.text); build/asm/main_800CB394.s.o(.rodata); build/asm/main_800CB394.s.o(.data); }
    .main_800CB394_bss (NOLOAD) : { build/asm/main_800CB394.s.o(.bss); }
    .main_800D538C 0x800D538C : AT(0x000D5F8C) { FILL(0x00000000); build/asm/main_800D538C.s.o(.text); build/asm/main_800D538C.s.o(.rodata); build/asm/main_800D538C.s.o(.data); }
    .main_800D538C_bss (NOLOAD) : { build/asm/main_800D538C.s.o(.bss); }
    .main_800E27E8 0x800E27E8 : AT(0x000E33E8) { FILL(0x00000000); build/asm/main_800E27E8.s.o(.text); build/asm/main_800E27E8.s.o(.rodata); build/asm/main_800E27E8.s.o(.data); }
    .main_800E27E8_bss (NOLOAD) : { build/asm/main_800E27E8.s.o(.bss); }
    .main_800E91DC 0x800E91DC : AT(0x000E9DDC) { FILL(0x00000000); build/asm/main_800E91DC.s.o(.text); build/asm/main_800E91DC.s.o(.rodata); build/asm/main_800E91DC.s.o(.data); }
    .main_800E91DC_bss (NOLOAD) : { build/asm/main_800E91DC.s.o(.bss); }
    .main_800F65E0 0x800F65E0 : AT(0x000F71E0) { FILL(0x00000000); build/asm/main_800F65E0.s.o(.text); build/asm/main_800F65E0.s.o(.rodata); build/asm/main_800F65E0.s.o(.data); }
    .main_800F65E0_bss (NOLOAD) : { build/asm/main_800F65E0.s.o(.bss); }
    .main_800F699C 0x800F699C : AT(0x000F759C) { FILL(0x00000000); build/asm/main_800F699C.s.o(.text); build/asm/main_800F699C.s.o(.rodata); build/asm/main_800F699C.s.o(.data); }
    .main_800F699C_bss (NOLOAD) : { build/asm/main_800F699C.s.o(.bss); }
    .main_800F6A98 0x800F6A98 : AT(0x000F7698) { FILL(0x00000000); build/asm/main_800F6A98.s.o(.text); build/asm/main_800F6A98.s.o(.rodata); build/asm/main_800F6A98.s.o(.data); }
    .main_800F6A98_bss (NOLOAD) : { build/asm/main_800F6A98.s.o(.bss); }
    .main_800F6D6C 0x800F6D6C : AT(0x000F796C) { FILL(0x00000000); build/asm/main_800F6D6C.s.o(.text); build/asm/main_800F6D6C.s.o(.rodata); build/asm/main_800F6D6C.s.o(.data); }
    .main_800F6D6C_bss (NOLOAD) : { build/asm/main_800F6D6C.s.o(.bss); }
    .main_800F6EBC 0x800F6EBC : AT(0x000F7ABC) { FILL(0x00000000); build/asm/main_800F6EBC.s.o(.text); build/asm/main_800F6EBC.s.o(.rodata); build/asm/main_800F6EBC.s.o(.data); }
    .main_800F6EBC_bss (NOLOAD) : { build/asm/main_800F6EBC.s.o(.bss); }
    .main_800F7034 0x800F7034 : AT(0x000F7C34) { FILL(0x00000000); build/asm/main_800F7034.s.o(.text); build/asm/main_800F7034.s.o(.rodata); build/asm/main_800F7034.s.o(.data); }
    .main_800F7034_bss (NOLOAD) : { build/asm/main_800F7034.s.o(.bss); }
    .main_800F76C4 0x800F76C4 : AT(0x000F82C4) { FILL(0x00000000); build/asm/main_800F76C4.s.o(.text); build/asm/main_800F76C4.s.o(.rodata); build/asm/main_800F76C4.s.o(.data); }
    .main_800F76C4_bss (NOLOAD) : { build/asm/main_800F76C4.s.o(.bss); }
    .main_800F9260 0x800F9260 : AT(0x000F9E60) { FILL(0x00000000); build/asm/main_800F9260.s.o(.text); build/asm/main_800F9260.s.o(.rodata); build/asm/main_800F9260.s.o(.data); }
    .main_800F9260_bss (NOLOAD) : { build/asm/main_800F9260.s.o(.bss); }
    .main_800F94E0 0x800F94E0 : AT(0x000FA0E0) { FILL(0x00000000); build/asm/main_800F94E0.s.o(.text); build/asm/main_800F94E0.s.o(.rodata); build/asm/main_800F94E0.s.o(.data); }
    .main_800F94E0_bss (NOLOAD) : { build/asm/main_800F94E0.s.o(.bss); }
    .main_800F9BAC 0x800F9BAC : AT(0x000FA7AC) { FILL(0x00000000); build/asm/main_800F9BAC.s.o(.text); build/asm/main_800F9BAC.s.o(.rodata); build/asm/main_800F9BAC.s.o(.data); }
    .main_800F9BAC_bss (NOLOAD) : { build/asm/main_800F9BAC.s.o(.bss); }
    .main_800F9E74 0x800F9E74 : AT(0x000FAA74) { FILL(0x00000000); build/asm/main_800F9E74.s.o(.text); build/asm/main_800F9E74.s.o(.rodata); build/asm/main_800F9E74.s.o(.data); }
    .main_800F9E74_bss (NOLOAD) : { build/asm/main_800F9E74.s.o(.bss); }
    .main_800FA084 0x800FA084 : AT(0x000FAC84) { FILL(0x00000000); build/asm/main_800FA084.s.o(.text); build/asm/main_800FA084.s.o(.rodata); build/asm/main_800FA084.s.o(.data); }
    .main_800FA084_bss (NOLOAD) : { build/asm/main_800FA084.s.o(.bss); }
    .main_800FD248 0x800FD248 : AT(0x000FDE48) { FILL(0x00000000); build/asm/main_800FD248.s.o(.text); build/asm/main_800FD248.s.o(.rodata); build/asm/main_800FD248.s.o(.data); }
    .main_800FD248_bss (NOLOAD) : { build/asm/main_800FD248.s.o(.bss); }
    .main_800FD538 0x800FD538 : AT(0x000FE138) { FILL(0x00000000); build/asm/main_800FD538.s.o(.text); build/asm/main_800FD538.s.o(.rodata); build/asm/main_800FD538.s.o(.data); }
    .main_800FD538_bss (NOLOAD) : { build/asm/main_800FD538.s.o(.bss); }
    .main_800FE7B4 0x800FE7B4 : AT(0x000FF3B4) { FILL(0x00000000); build/asm/main_800FE7B4.s.o(.text); build/asm/main_800FE7B4.s.o(.rodata); build/asm/main_800FE7B4.s.o(.data); }
    .main_800FE7B4_bss (NOLOAD) : { build/asm/main_800FE7B4.s.o(.bss); }
    .main_800FEB40 0x800FEB40 : AT(0x000FF740) { FILL(0x00000000); build/asm/main_800FEB40.s.o(.text); build/asm/main_800FEB40.s.o(.rodata); build/asm/main_800FEB40.s.o(.data); }
    .main_800FEB40_bss (NOLOAD) : { build/asm/main_800FEB40.s.o(.bss); }
    .main_800FEC4C 0x800FEC4C : AT(0x000FF84C) { FILL(0x00000000); build/asm/main_800FEC4C.s.o(.text); build/asm/main_800FEC4C.s.o(.rodata); build/asm/main_800FEC4C.s.o(.data); }
    .main_800FEC4C_bss (NOLOAD) : { build/asm/main_800FEC4C.s.o(.bss); }
    .main_800FF6B4 0x800FF6B4 : AT(0x001002B4) { FILL(0x00000000); build/asm/main_800FF6B4.s.o(.text); build/asm/main_800FF6B4.s.o(.rodata); build/asm/main_800FF6B4.s.o(.data); }
    .main_800FF6B4_bss (NOLOAD) : { build/asm/main_800FF6B4.s.o(.bss); }
    .main_800FFF4C 0x800FFF4C : AT(0x00100B4C) { FILL(0x00000000); build/asm/main_800FFF4C.s.o(.text); build/asm/main_800FFF4C.s.o(.rodata); build/asm/main_800FFF4C.s.o(.data); }
    .main_800FFF4C_bss (NOLOAD) : { build/asm/main_800FFF4C.s.o(.bss); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
