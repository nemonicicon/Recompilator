SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80210000 0x80210000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80210000.s.o(.text); build/asm/main_80210000.s.o(.rodata); build/asm/main_80210000.s.o(.data); }
    .main_80210000_bss (NOLOAD) : { build/asm/main_80210000.s.o(.bss); }
    .main_802112EC 0x802112EC : AT(0x000022EC) { FILL(0x00000000); build/asm/main_802112EC.s.o(.text); build/asm/main_802112EC.s.o(.rodata); build/asm/main_802112EC.s.o(.data); }
    .main_802112EC_bss (NOLOAD) : { build/asm/main_802112EC.s.o(.bss); }
    .main_80211548 0x80211548 : AT(0x00002548) { FILL(0x00000000); build/asm/main_80211548.s.o(.text); build/asm/main_80211548.s.o(.rodata); build/asm/main_80211548.s.o(.data); }
    .main_80211548_bss (NOLOAD) : { build/asm/main_80211548.s.o(.bss); }
    .main_80211980 0x80211980 : AT(0x00002980) { FILL(0x00000000); build/asm/main_80211980.s.o(.text); build/asm/main_80211980.s.o(.rodata); build/asm/main_80211980.s.o(.data); }
    .main_80211980_bss (NOLOAD) : { build/asm/main_80211980.s.o(.bss); }
    .main_8021E420 0x8021E420 : AT(0x0000F420) { FILL(0x00000000); build/asm/main_8021E420.s.o(.text); build/asm/main_8021E420.s.o(.rodata); build/asm/main_8021E420.s.o(.data); }
    .main_8021E420_bss (NOLOAD) : { build/asm/main_8021E420.s.o(.bss); }
    .main_8021F098 0x8021F098 : AT(0x00010098) { FILL(0x00000000); build/asm/main_8021F098.s.o(.text); build/asm/main_8021F098.s.o(.rodata); build/asm/main_8021F098.s.o(.data); }
    .main_8021F098_bss (NOLOAD) : { build/asm/main_8021F098.s.o(.bss); }
    .main_8021F468 0x8021F468 : AT(0x00010468) { FILL(0x00000000); build/asm/main_8021F468.s.o(.text); build/asm/main_8021F468.s.o(.rodata); build/asm/main_8021F468.s.o(.data); }
    .main_8021F468_bss (NOLOAD) : { build/asm/main_8021F468.s.o(.bss); }
    .main_80220EC8 0x80220EC8 : AT(0x00011EC8) { FILL(0x00000000); build/asm/main_80220EC8.s.o(.text); build/asm/main_80220EC8.s.o(.rodata); build/asm/main_80220EC8.s.o(.data); }
    .main_80220EC8_bss (NOLOAD) : { build/asm/main_80220EC8.s.o(.bss); }
    .main_80222B38 0x80222B38 : AT(0x00013B38) { FILL(0x00000000); build/asm/main_80222B38.s.o(.text); build/asm/main_80222B38.s.o(.rodata); build/asm/main_80222B38.s.o(.data); }
    .main_80222B38_bss (NOLOAD) : { build/asm/main_80222B38.s.o(.bss); }
    .main_802232FC 0x802232FC : AT(0x000142FC) { FILL(0x00000000); build/asm/main_802232FC.s.o(.text); build/asm/main_802232FC.s.o(.rodata); build/asm/main_802232FC.s.o(.data); }
    .main_802232FC_bss (NOLOAD) : { build/asm/main_802232FC.s.o(.bss); }
    .main_80223978 0x80223978 : AT(0x00014978) { FILL(0x00000000); build/asm/main_80223978.s.o(.text); build/asm/main_80223978.s.o(.rodata); build/asm/main_80223978.s.o(.data); }
    .main_80223978_bss (NOLOAD) : { build/asm/main_80223978.s.o(.bss); }
    .main_80223F84 0x80223F84 : AT(0x00014F84) { FILL(0x00000000); build/asm/main_80223F84.s.o(.text); build/asm/main_80223F84.s.o(.rodata); build/asm/main_80223F84.s.o(.data); }
    .main_80223F84_bss (NOLOAD) : { build/asm/main_80223F84.s.o(.bss); }
    .main_8024B590 0x8024B590 : AT(0x0003C590) { FILL(0x00000000); build/asm/main_8024B590.s.o(.text); build/asm/main_8024B590.s.o(.rodata); build/asm/main_8024B590.s.o(.data); }
    .main_8024B590_bss (NOLOAD) : { build/asm/main_8024B590.s.o(.bss); }
    .main_8024B818 0x8024B818 : AT(0x0003C818) { FILL(0x00000000); build/asm/main_8024B818.s.o(.text); build/asm/main_8024B818.s.o(.rodata); build/asm/main_8024B818.s.o(.data); }
    .main_8024B818_bss (NOLOAD) : { build/asm/main_8024B818.s.o(.bss); }
    .main_8024BAA0 0x8024BAA0 : AT(0x0003CAA0) { build/asm/data/main_8024BAA0.bin.o(.data); }
    .main_8024BD28 0x8024BD28 : AT(0x0003CD28) { FILL(0x00000000); build/asm/main_8024BD28.s.o(.text); build/asm/main_8024BD28.s.o(.rodata); build/asm/main_8024BD28.s.o(.data); }
    .main_8024BD28_bss (NOLOAD) : { build/asm/main_8024BD28.s.o(.bss); }
    .main_8024BFB0 0x8024BFB0 : AT(0x0003CFB0) { FILL(0x00000000); build/asm/main_8024BFB0.s.o(.text); build/asm/main_8024BFB0.s.o(.rodata); build/asm/main_8024BFB0.s.o(.data); }
    .main_8024BFB0_bss (NOLOAD) : { build/asm/main_8024BFB0.s.o(.bss); }
    .main_8024C238 0x8024C238 : AT(0x0003D238) { FILL(0x00000000); build/asm/main_8024C238.s.o(.text); build/asm/main_8024C238.s.o(.rodata); build/asm/main_8024C238.s.o(.data); }
    .main_8024C238_bss (NOLOAD) : { build/asm/main_8024C238.s.o(.bss); }
    .main_8024F6F4 0x8024F6F4 : AT(0x000406F4) { FILL(0x00000000); build/asm/main_8024F6F4.s.o(.text); build/asm/main_8024F6F4.s.o(.rodata); build/asm/main_8024F6F4.s.o(.data); }
    .main_8024F6F4_bss (NOLOAD) : { build/asm/main_8024F6F4.s.o(.bss); }
    .main_80250B34 0x80250B34 : AT(0x00041B34) { FILL(0x00000000); build/asm/main_80250B34.s.o(.text); build/asm/main_80250B34.s.o(.rodata); build/asm/main_80250B34.s.o(.data); }
    .main_80250B34_bss (NOLOAD) : { build/asm/main_80250B34.s.o(.bss); }
    .main_80252C44 0x80252C44 : AT(0x00043C44) { build/asm/data/main_80252C44.bin.o(.data); }
    .main_8025360C 0x8025360C : AT(0x0004460C) { FILL(0x00000000); build/asm/main_8025360C.s.o(.text); build/asm/main_8025360C.s.o(.rodata); build/asm/main_8025360C.s.o(.data); }
    .main_8025360C_bss (NOLOAD) : { build/asm/main_8025360C.s.o(.bss); }
    .main_80253CDC 0x80253CDC : AT(0x00044CDC) { FILL(0x00000000); build/asm/main_80253CDC.s.o(.text); build/asm/main_80253CDC.s.o(.rodata); build/asm/main_80253CDC.s.o(.data); }
    .main_80253CDC_bss (NOLOAD) : { build/asm/main_80253CDC.s.o(.bss); }
    .main_8025759C 0x8025759C : AT(0x0004859C) { build/asm/data/main_8025759C.bin.o(.data); }
    .main_80257864 0x80257864 : AT(0x00048864) { FILL(0x00000000); build/asm/main_80257864.s.o(.text); build/asm/main_80257864.s.o(.rodata); build/asm/main_80257864.s.o(.data); }
    .main_80257864_bss (NOLOAD) : { build/asm/main_80257864.s.o(.bss); }
    .main_80257904 0x80257904 : AT(0x00048904) { build/asm/data/main_80257904.bin.o(.data); }
    .main_80257934 0x80257934 : AT(0x00048934) { FILL(0x00000000); build/asm/main_80257934.s.o(.text); build/asm/main_80257934.s.o(.rodata); build/asm/main_80257934.s.o(.data); }
    .main_80257934_bss (NOLOAD) : { build/asm/main_80257934.s.o(.bss); }
    .main_8025796C 0x8025796C : AT(0x0004896C) { build/asm/data/main_8025796C.bin.o(.data); }
    .main_80257C54 0x80257C54 : AT(0x00048C54) { FILL(0x00000000); build/asm/main_80257C54.s.o(.text); build/asm/main_80257C54.s.o(.rodata); build/asm/main_80257C54.s.o(.data); }
    .main_80257C54_bss (NOLOAD) : { build/asm/main_80257C54.s.o(.bss); }
    .main_80258D8C 0x80258D8C : AT(0x00049D8C) { build/asm/data/main_80258D8C.bin.o(.data); }
    .main_80259124 0x80259124 : AT(0x0004A124) { FILL(0x00000000); build/asm/main_80259124.s.o(.text); build/asm/main_80259124.s.o(.rodata); build/asm/main_80259124.s.o(.data); }
    .main_80259124_bss (NOLOAD) : { build/asm/main_80259124.s.o(.bss); }
    .main_8025916C 0x8025916C : AT(0x0004A16C) { build/asm/data/main_8025916C.bin.o(.data); }
    .main_802595B4 0x802595B4 : AT(0x0004A5B4) { FILL(0x00000000); build/asm/main_802595B4.s.o(.text); build/asm/main_802595B4.s.o(.rodata); build/asm/main_802595B4.s.o(.data); }
    .main_802595B4_bss (NOLOAD) : { build/asm/main_802595B4.s.o(.bss); }
    .main_8025AA14 0x8025AA14 : AT(0x0004BA14) { build/asm/data/main_8025AA14.bin.o(.data); }
    .main_8025AD3C 0x8025AD3C : AT(0x0004BD3C) { FILL(0x00000000); build/asm/main_8025AD3C.s.o(.text); build/asm/main_8025AD3C.s.o(.rodata); build/asm/main_8025AD3C.s.o(.data); }
    .main_8025AD3C_bss (NOLOAD) : { build/asm/main_8025AD3C.s.o(.bss); }
    .main_8025B6EC 0x8025B6EC : AT(0x0004C6EC) { build/asm/data/main_8025B6EC.bin.o(.data); }
    .main_8025B8A4 0x8025B8A4 : AT(0x0004C8A4) { FILL(0x00000000); build/asm/main_8025B8A4.s.o(.text); build/asm/main_8025B8A4.s.o(.rodata); build/asm/main_8025B8A4.s.o(.data); }
    .main_8025B8A4_bss (NOLOAD) : { build/asm/main_8025B8A4.s.o(.bss); }
    .main_8025B90C 0x8025B90C : AT(0x0004C90C) { build/asm/data/main_8025B90C.bin.o(.data); }
    .main_8025B944 0x8025B944 : AT(0x0004C944) { FILL(0x00000000); build/asm/main_8025B944.s.o(.text); build/asm/main_8025B944.s.o(.rodata); build/asm/main_8025B944.s.o(.data); }
    .main_8025B944_bss (NOLOAD) : { build/asm/main_8025B944.s.o(.bss); }
    .main_8025B964 0x8025B964 : AT(0x0004C964) { build/asm/data/main_8025B964.bin.o(.data); }
    .main_8025B9D4 0x8025B9D4 : AT(0x0004C9D4) { FILL(0x00000000); build/asm/main_8025B9D4.s.o(.text); build/asm/main_8025B9D4.s.o(.rodata); build/asm/main_8025B9D4.s.o(.data); }
    .main_8025B9D4_bss (NOLOAD) : { build/asm/main_8025B9D4.s.o(.bss); }
    .main_8025BE0C 0x8025BE0C : AT(0x0004CE0C) { FILL(0x00000000); build/asm/main_8025BE0C.s.o(.text); build/asm/main_8025BE0C.s.o(.rodata); build/asm/main_8025BE0C.s.o(.data); }
    .main_8025BE0C_bss (NOLOAD) : { build/asm/main_8025BE0C.s.o(.bss); }
    .main_8025C24C 0x8025C24C : AT(0x0004D24C) { FILL(0x00000000); build/asm/main_8025C24C.s.o(.text); build/asm/main_8025C24C.s.o(.rodata); build/asm/main_8025C24C.s.o(.data); }
    .main_8025C24C_bss (NOLOAD) : { build/asm/main_8025C24C.s.o(.bss); }
    .main_8025EBDC 0x8025EBDC : AT(0x0004FBDC) { build/asm/data/main_8025EBDC.bin.o(.data); }
    .main_8025F144 0x8025F144 : AT(0x00050144) { FILL(0x00000000); build/asm/main_8025F144.s.o(.text); build/asm/main_8025F144.s.o(.rodata); build/asm/main_8025F144.s.o(.data); }
    .main_8025F144_bss (NOLOAD) : { build/asm/main_8025F144.s.o(.bss); }
    .main_8025FB14 0x8025FB14 : AT(0x00050B14) { build/asm/data/main_8025FB14.bin.o(.data); }
    .main_802600AC 0x802600AC : AT(0x000510AC) { FILL(0x00000000); build/asm/main_802600AC.s.o(.text); build/asm/main_802600AC.s.o(.rodata); build/asm/main_802600AC.s.o(.data); }
    .main_802600AC_bss (NOLOAD) : { build/asm/main_802600AC.s.o(.bss); }
    .main_80260C6C 0x80260C6C : AT(0x00051C6C) { build/asm/data/main_80260C6C.bin.o(.data); }
    .main_80260D64 0x80260D64 : AT(0x00051D64) { FILL(0x00000000); build/asm/main_80260D64.s.o(.text); build/asm/main_80260D64.s.o(.rodata); build/asm/main_80260D64.s.o(.data); }
    .main_80260D64_bss (NOLOAD) : { build/asm/main_80260D64.s.o(.bss); }
    .main_80260D94 0x80260D94 : AT(0x00051D94) { build/asm/data/main_80260D94.bin.o(.data); }
    .main_80260E8C 0x80260E8C : AT(0x00051E8C) { FILL(0x00000000); build/asm/main_80260E8C.s.o(.text); build/asm/main_80260E8C.s.o(.rodata); build/asm/main_80260E8C.s.o(.data); }
    .main_80260E8C_bss (NOLOAD) : { build/asm/main_80260E8C.s.o(.bss); }
    .main_802639A4 0x802639A4 : AT(0x000549A4) { build/asm/data/main_802639A4.bin.o(.data); }
    .main_80263AD4 0x80263AD4 : AT(0x00054AD4) { FILL(0x00000000); build/asm/main_80263AD4.s.o(.text); build/asm/main_80263AD4.s.o(.rodata); build/asm/main_80263AD4.s.o(.data); }
    .main_80263AD4_bss (NOLOAD) : { build/asm/main_80263AD4.s.o(.bss); }
    .main_80263B74 0x80263B74 : AT(0x00054B74) { build/asm/data/main_80263B74.bin.o(.data); }
    .main_80263D4C 0x80263D4C : AT(0x00054D4C) { FILL(0x00000000); build/asm/main_80263D4C.s.o(.text); build/asm/main_80263D4C.s.o(.rodata); build/asm/main_80263D4C.s.o(.data); }
    .main_80263D4C_bss (NOLOAD) : { build/asm/main_80263D4C.s.o(.bss); }
    .main_80264394 0x80264394 : AT(0x00055394) { build/asm/data/main_80264394.bin.o(.data); }
    .main_80264F9C 0x80264F9C : AT(0x00055F9C) { FILL(0x00000000); build/asm/main_80264F9C.s.o(.text); build/asm/main_80264F9C.s.o(.rodata); build/asm/main_80264F9C.s.o(.data); }
    .main_80264F9C_bss (NOLOAD) : { build/asm/main_80264F9C.s.o(.bss); }
    .main_802658CC 0x802658CC : AT(0x000568CC) { build/asm/data/main_802658CC.bin.o(.data); }
    .main_8026594C 0x8026594C : AT(0x0005694C) { FILL(0x00000000); build/asm/main_8026594C.s.o(.text); build/asm/main_8026594C.s.o(.rodata); build/asm/main_8026594C.s.o(.data); }
    .main_8026594C_bss (NOLOAD) : { build/asm/main_8026594C.s.o(.bss); }
    .main_80265954 0x80265954 : AT(0x00056954) { build/asm/data/main_80265954.bin.o(.data); }
    .main_8026599C 0x8026599C : AT(0x0005699C) { FILL(0x00000000); build/asm/main_8026599C.s.o(.text); build/asm/main_8026599C.s.o(.rodata); build/asm/main_8026599C.s.o(.data); }
    .main_8026599C_bss (NOLOAD) : { build/asm/main_8026599C.s.o(.bss); }
    .main_80265BFC 0x80265BFC : AT(0x00056BFC) { FILL(0x00000000); build/asm/main_80265BFC.s.o(.text); build/asm/main_80265BFC.s.o(.rodata); build/asm/main_80265BFC.s.o(.data); }
    .main_80265BFC_bss (NOLOAD) : { build/asm/main_80265BFC.s.o(.bss); }
    .main_80265FBC 0x80265FBC : AT(0x00056FBC) { FILL(0x00000000); build/asm/main_80265FBC.s.o(.text); build/asm/main_80265FBC.s.o(.rodata); build/asm/main_80265FBC.s.o(.data); }
    .main_80265FBC_bss (NOLOAD) : { build/asm/main_80265FBC.s.o(.bss); }
    .main_802660EC 0x802660EC : AT(0x000570EC) { FILL(0x00000000); build/asm/main_802660EC.s.o(.text); build/asm/main_802660EC.s.o(.rodata); build/asm/main_802660EC.s.o(.data); }
    .main_802660EC_bss (NOLOAD) : { build/asm/main_802660EC.s.o(.bss); }
    .main_8026695C 0x8026695C : AT(0x0005795C) { build/asm/data/main_8026695C.bin.o(.data); }
    .main_80266A34 0x80266A34 : AT(0x00057A34) { FILL(0x00000000); build/asm/main_80266A34.s.o(.text); build/asm/main_80266A34.s.o(.rodata); build/asm/main_80266A34.s.o(.data); }
    .main_80266A34_bss (NOLOAD) : { build/asm/main_80266A34.s.o(.bss); }
    .main_80266E8C 0x80266E8C : AT(0x00057E8C) { FILL(0x00000000); build/asm/main_80266E8C.s.o(.text); build/asm/main_80266E8C.s.o(.rodata); build/asm/main_80266E8C.s.o(.data); }
    .main_80266E8C_bss (NOLOAD) : { build/asm/main_80266E8C.s.o(.bss); }
    .main_80267064 0x80267064 : AT(0x00058064) { FILL(0x00000000); build/asm/main_80267064.s.o(.text); build/asm/main_80267064.s.o(.rodata); build/asm/main_80267064.s.o(.data); }
    .main_80267064_bss (NOLOAD) : { build/asm/main_80267064.s.o(.bss); }
    .main_802672E4 0x802672E4 : AT(0x000582E4) { FILL(0x00000000); build/asm/main_802672E4.s.o(.text); build/asm/main_802672E4.s.o(.rodata); build/asm/main_802672E4.s.o(.data); }
    .main_802672E4_bss (NOLOAD) : { build/asm/main_802672E4.s.o(.bss); }
    .main_8026748C 0x8026748C : AT(0x0005848C) { build/asm/data/main_8026748C.bin.o(.data); }
    .main_802674B4 0x802674B4 : AT(0x000584B4) { FILL(0x00000000); build/asm/main_802674B4.s.o(.text); build/asm/main_802674B4.s.o(.rodata); build/asm/main_802674B4.s.o(.data); }
    .main_802674B4_bss (NOLOAD) : { build/asm/main_802674B4.s.o(.bss); }
    .main_802676D4 0x802676D4 : AT(0x000586D4) { FILL(0x00000000); build/asm/main_802676D4.s.o(.text); build/asm/main_802676D4.s.o(.rodata); build/asm/main_802676D4.s.o(.data); }
    .main_802676D4_bss (NOLOAD) : { build/asm/main_802676D4.s.o(.bss); }
    .main_802676EC 0x802676EC : AT(0x000586EC) { FILL(0x00000000); build/asm/main_802676EC.s.o(.text); build/asm/main_802676EC.s.o(.rodata); build/asm/main_802676EC.s.o(.data); }
    .main_802676EC_bss (NOLOAD) : { build/asm/main_802676EC.s.o(.bss); }
    .main_8026771C 0x8026771C : AT(0x0005871C) { FILL(0x00000000); build/asm/main_8026771C.s.o(.text); build/asm/main_8026771C.s.o(.rodata); build/asm/main_8026771C.s.o(.data); }
    .main_8026771C_bss (NOLOAD) : { build/asm/main_8026771C.s.o(.bss); }
    .main_80267A44 0x80267A44 : AT(0x00058A44) { FILL(0x00000000); build/asm/main_80267A44.s.o(.text); build/asm/main_80267A44.s.o(.rodata); build/asm/main_80267A44.s.o(.data); }
    .main_80267A44_bss (NOLOAD) : { build/asm/main_80267A44.s.o(.bss); }
    .main_80267B44 0x80267B44 : AT(0x00058B44) { FILL(0x00000000); build/asm/main_80267B44.s.o(.text); build/asm/main_80267B44.s.o(.rodata); build/asm/main_80267B44.s.o(.data); }
    .main_80267B44_bss (NOLOAD) : { build/asm/main_80267B44.s.o(.bss); }
    .main_80267B9C 0x80267B9C : AT(0x00058B9C) { FILL(0x00000000); build/asm/main_80267B9C.s.o(.text); build/asm/main_80267B9C.s.o(.rodata); build/asm/main_80267B9C.s.o(.data); }
    .main_80267B9C_bss (NOLOAD) : { build/asm/main_80267B9C.s.o(.bss); }
    .main_80267C34 0x80267C34 : AT(0x00058C34) { FILL(0x00000000); build/asm/main_80267C34.s.o(.text); build/asm/main_80267C34.s.o(.rodata); build/asm/main_80267C34.s.o(.data); }
    .main_80267C34_bss (NOLOAD) : { build/asm/main_80267C34.s.o(.bss); }
    .main_80267CD4 0x80267CD4 : AT(0x00058CD4) { FILL(0x00000000); build/asm/main_80267CD4.s.o(.text); build/asm/main_80267CD4.s.o(.rodata); build/asm/main_80267CD4.s.o(.data); }
    .main_80267CD4_bss (NOLOAD) : { build/asm/main_80267CD4.s.o(.bss); }
    .main_80268364 0x80268364 : AT(0x00059364) { FILL(0x00000000); build/asm/main_80268364.s.o(.text); build/asm/main_80268364.s.o(.rodata); build/asm/main_80268364.s.o(.data); }
    .main_80268364_bss (NOLOAD) : { build/asm/main_80268364.s.o(.bss); }
    .main_802685A4 0x802685A4 : AT(0x000595A4) { FILL(0x00000000); build/asm/main_802685A4.s.o(.text); build/asm/main_802685A4.s.o(.rodata); build/asm/main_802685A4.s.o(.data); }
    .main_802685A4_bss (NOLOAD) : { build/asm/main_802685A4.s.o(.bss); }
    .main_8026873C 0x8026873C : AT(0x0005973C) { FILL(0x00000000); build/asm/main_8026873C.s.o(.text); build/asm/main_8026873C.s.o(.rodata); build/asm/main_8026873C.s.o(.data); }
    .main_8026873C_bss (NOLOAD) : { build/asm/main_8026873C.s.o(.bss); }
    .main_802687D4 0x802687D4 : AT(0x000597D4) { FILL(0x00000000); build/asm/main_802687D4.s.o(.text); build/asm/main_802687D4.s.o(.rodata); build/asm/main_802687D4.s.o(.data); }
    .main_802687D4_bss (NOLOAD) : { build/asm/main_802687D4.s.o(.bss); }
    .main_8026A7B4 0x8026A7B4 : AT(0x0005B7B4) { FILL(0x00000000); build/asm/main_8026A7B4.s.o(.text); build/asm/main_8026A7B4.s.o(.rodata); build/asm/main_8026A7B4.s.o(.data); }
    .main_8026A7B4_bss (NOLOAD) : { build/asm/main_8026A7B4.s.o(.bss); }
    .main_8026AB2C 0x8026AB2C : AT(0x0005BB2C) { FILL(0x00000000); build/asm/main_8026AB2C.s.o(.text); build/asm/main_8026AB2C.s.o(.rodata); build/asm/main_8026AB2C.s.o(.data); }
    .main_8026AB2C_bss (NOLOAD) : { build/asm/main_8026AB2C.s.o(.bss); }
    .main_8026CB34 0x8026CB34 : AT(0x0005DB34) { FILL(0x00000000); build/asm/main_8026CB34.s.o(.text); build/asm/main_8026CB34.s.o(.rodata); build/asm/main_8026CB34.s.o(.data); }
    .main_8026CB34_bss (NOLOAD) : { build/asm/main_8026CB34.s.o(.bss); }
    .main_8026CDBC 0x8026CDBC : AT(0x0005DDBC) { FILL(0x00000000); build/asm/main_8026CDBC.s.o(.text); build/asm/main_8026CDBC.s.o(.rodata); build/asm/main_8026CDBC.s.o(.data); }
    .main_8026CDBC_bss (NOLOAD) : { build/asm/main_8026CDBC.s.o(.bss); }
    .main_802C03E0 0x802C03E0 : AT(0x000B13E0) { FILL(0x00000000); build/asm/main_802C03E0.s.o(.text); build/asm/main_802C03E0.s.o(.rodata); build/asm/main_802C03E0.s.o(.data); }
    .main_802C03E0_bss (NOLOAD) : { build/asm/main_802C03E0.s.o(.bss); }
    .main_802E051C 0x802E051C : AT(0x000D151C) { build/asm/data/main_802E051C.bin.o(.data); }
    .main_802E9258 0x802E9258 : AT(0x000DA258) { FILL(0x00000000); build/asm/main_802E9258.s.o(.text); build/asm/main_802E9258.s.o(.rodata); build/asm/main_802E9258.s.o(.data); }
    .main_802E9258_bss (NOLOAD) : { build/asm/main_802E9258.s.o(.bss); }
    .main_802E9274 0x802E9274 : AT(0x000DA274) { build/asm/data/main_802E9274.bin.o(.data); }
    .main_802EE4CC 0x802EE4CC : AT(0x000DF4CC) { FILL(0x00000000); build/asm/main_802EE4CC.s.o(.text); build/asm/main_802EE4CC.s.o(.rodata); build/asm/main_802EE4CC.s.o(.data); }
    .main_802EE4CC_bss (NOLOAD) : { build/asm/main_802EE4CC.s.o(.bss); }
    .main_802EE4E4 0x802EE4E4 : AT(0x000DF4E4) { build/asm/data/main_802EE4E4.bin.o(.data); }
    .main_802F99E4 0x802F99E4 : AT(0x000EA9E4) { FILL(0x00000000); build/asm/main_802F99E4.s.o(.text); build/asm/main_802F99E4.s.o(.rodata); build/asm/main_802F99E4.s.o(.data); }
    .main_802F99E4_bss (NOLOAD) : { build/asm/main_802F99E4.s.o(.bss); }
    .main_802F9BC4 0x802F9BC4 : AT(0x000EABC4) { build/asm/data/main_802F9BC4.bin.o(.data); }
    .main_80301114 0x80301114 : AT(0x000F2114) { FILL(0x00000000); build/asm/main_80301114.s.o(.text); build/asm/main_80301114.s.o(.rodata); build/asm/main_80301114.s.o(.data); }
    .main_80301114_bss (NOLOAD) : { build/asm/main_80301114.s.o(.bss); }
    .main_80301118 0x80301118 : AT(0x000F2118) { build/asm/data/main_80301118.bin.o(.data); }
    .main_803017C8 0x803017C8 : AT(0x000F27C8) { FILL(0x00000000); build/asm/main_803017C8.s.o(.text); build/asm/main_803017C8.s.o(.rodata); build/asm/main_803017C8.s.o(.data); }
    .main_803017C8_bss (NOLOAD) : { build/asm/main_803017C8.s.o(.bss); }
    .main_803017D8 0x803017D8 : AT(0x000F27D8) { build/asm/data/main_803017D8.bin.o(.data); }
    .main_80301C04 0x80301C04 : AT(0x000F2C04) { FILL(0x00000000); build/asm/main_80301C04.s.o(.text); build/asm/main_80301C04.s.o(.rodata); build/asm/main_80301C04.s.o(.data); }
    .main_80301C04_bss (NOLOAD) : { build/asm/main_80301C04.s.o(.bss); }
    .main_80301C18 0x80301C18 : AT(0x000F2C18) { build/asm/data/main_80301C18.bin.o(.data); }
    .main_80302414 0x80302414 : AT(0x000F3414) { FILL(0x00000000); build/asm/main_80302414.s.o(.text); build/asm/main_80302414.s.o(.rodata); build/asm/main_80302414.s.o(.data); }
    .main_80302414_bss (NOLOAD) : { build/asm/main_80302414.s.o(.bss); }
    .main_80302420 0x80302420 : AT(0x000F3420) { build/asm/data/main_80302420.bin.o(.data); }
    .main_80302810 0x80302810 : AT(0x000F3810) { FILL(0x00000000); build/asm/main_80302810.s.o(.text); build/asm/main_80302810.s.o(.rodata); build/asm/main_80302810.s.o(.data); }
    .main_80302810_bss (NOLOAD) : { build/asm/main_80302810.s.o(.bss); }
    .main_80302818 0x80302818 : AT(0x000F3818) { build/asm/data/main_80302818.bin.o(.data); }
    .main_8030281C 0x8030281C : AT(0x000F381C) { FILL(0x00000000); build/asm/main_8030281C.s.o(.text); build/asm/main_8030281C.s.o(.rodata); build/asm/main_8030281C.s.o(.data); }
    .main_8030281C_bss (NOLOAD) : { build/asm/main_8030281C.s.o(.bss); }
    .main_80302824 0x80302824 : AT(0x000F3824) { build/asm/data/main_80302824.bin.o(.data); }
    .main_80302C20 0x80302C20 : AT(0x000F3C20) { FILL(0x00000000); build/asm/main_80302C20.s.o(.text); build/asm/main_80302C20.s.o(.rodata); build/asm/main_80302C20.s.o(.data); }
    .main_80302C20_bss (NOLOAD) : { build/asm/main_80302C20.s.o(.bss); }
    .main_80302C28 0x80302C28 : AT(0x000F3C28) { build/asm/data/main_80302C28.bin.o(.data); }
    .main_8030301C 0x8030301C : AT(0x000F401C) { FILL(0x00000000); build/asm/main_8030301C.s.o(.text); build/asm/main_8030301C.s.o(.rodata); build/asm/main_8030301C.s.o(.data); }
    .main_8030301C_bss (NOLOAD) : { build/asm/main_8030301C.s.o(.bss); }
    .main_80303038 0x80303038 : AT(0x000F4038) { build/asm/data/main_80303038.bin.o(.data); }
    .main_80303430 0x80303430 : AT(0x000F4430) { FILL(0x00000000); build/asm/main_80303430.s.o(.text); build/asm/main_80303430.s.o(.rodata); build/asm/main_80303430.s.o(.data); }
    .main_80303430_bss (NOLOAD) : { build/asm/main_80303430.s.o(.bss); }
    .main_80303444 0x80303444 : AT(0x000F4444) { build/asm/data/main_80303444.bin.o(.data); }
    .main_80303834 0x80303834 : AT(0x000F4834) { FILL(0x00000000); build/asm/main_80303834.s.o(.text); build/asm/main_80303834.s.o(.rodata); build/asm/main_80303834.s.o(.data); }
    .main_80303834_bss (NOLOAD) : { build/asm/main_80303834.s.o(.bss); }
    .main_80303840 0x80303840 : AT(0x000F4840) { build/asm/data/main_80303840.bin.o(.data); }
    .main_80303C48 0x80303C48 : AT(0x000F4C48) { FILL(0x00000000); build/asm/main_80303C48.s.o(.text); build/asm/main_80303C48.s.o(.rodata); build/asm/main_80303C48.s.o(.data); }
    .main_80303C48_bss (NOLOAD) : { build/asm/main_80303C48.s.o(.bss); }
    .main_80303C58 0x80303C58 : AT(0x000F4C58) { build/asm/data/main_80303C58.bin.o(.data); }
    .assets 0x80610000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
