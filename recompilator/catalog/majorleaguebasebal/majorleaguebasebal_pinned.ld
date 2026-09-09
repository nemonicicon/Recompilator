SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80025C00 0x80025C00 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80025C00.s.o(.text); build/asm/main_80025C00.s.o(.rodata); build/asm/main_80025C00.s.o(.data); }
    .main_80025C00_bss (NOLOAD) : { build/asm/main_80025C00.s.o(.bss); }
    .main_80025E90 0x80025E90 : AT(0x00001290) { FILL(0x00000000); build/asm/main_80025E90.s.o(.text); build/asm/main_80025E90.s.o(.rodata); build/asm/main_80025E90.s.o(.data); }
    .main_80025E90_bss (NOLOAD) : { build/asm/main_80025E90.s.o(.bss); }
    .main_80026EA4 0x80026EA4 : AT(0x000022A4) { FILL(0x00000000); build/asm/main_80026EA4.s.o(.text); build/asm/main_80026EA4.s.o(.rodata); build/asm/main_80026EA4.s.o(.data); }
    .main_80026EA4_bss (NOLOAD) : { build/asm/main_80026EA4.s.o(.bss); }
    .main_80027270 0x80027270 : AT(0x00002670) { FILL(0x00000000); build/asm/main_80027270.s.o(.text); build/asm/main_80027270.s.o(.rodata); build/asm/main_80027270.s.o(.data); }
    .main_80027270_bss (NOLOAD) : { build/asm/main_80027270.s.o(.bss); }
    .main_80029CB8 0x80029CB8 : AT(0x000050B8) { FILL(0x00000000); build/asm/main_80029CB8.s.o(.text); build/asm/main_80029CB8.s.o(.rodata); build/asm/main_80029CB8.s.o(.data); }
    .main_80029CB8_bss (NOLOAD) : { build/asm/main_80029CB8.s.o(.bss); }
    .main_8002B554 0x8002B554 : AT(0x00006954) { build/asm/data/main_8002B554.bin.o(.data); }
    .main_8002B72C 0x8002B72C : AT(0x00006B2C) { build/asm/data/main_8002B72C.bin.o(.data); }
    .main_8002C5AC 0x8002C5AC : AT(0x000079AC) { build/asm/data/main_8002C5AC.bin.o(.data); }
    .main_8002CC1C 0x8002CC1C : AT(0x0000801C) { build/asm/data/main_8002CC1C.bin.o(.data); }
    .main_8002D2C0 0x8002D2C0 : AT(0x000086C0) { FILL(0x00000000); build/asm/main_8002D2C0.s.o(.text); build/asm/main_8002D2C0.s.o(.rodata); build/asm/main_8002D2C0.s.o(.data); }
    .main_8002D2C0_bss (NOLOAD) : { build/asm/main_8002D2C0.s.o(.bss); }
    .main_8002D368 0x8002D368 : AT(0x00008768) { build/asm/data/main_8002D368.bin.o(.data); }
    .main_800328AC 0x800328AC : AT(0x0000DCAC) { FILL(0x00000000); build/asm/main_800328AC.s.o(.text); build/asm/main_800328AC.s.o(.rodata); build/asm/main_800328AC.s.o(.data); }
    .main_800328AC_bss (NOLOAD) : { build/asm/main_800328AC.s.o(.bss); }
    .main_800328E4 0x800328E4 : AT(0x0000DCE4) { build/asm/data/main_800328E4.bin.o(.data); }
    .main_800333F8 0x800333F8 : AT(0x0000E7F8) { FILL(0x00000000); build/asm/main_800333F8.s.o(.text); build/asm/main_800333F8.s.o(.rodata); build/asm/main_800333F8.s.o(.data); }
    .main_800333F8_bss (NOLOAD) : { build/asm/main_800333F8.s.o(.bss); }
    .main_80033400 0x80033400 : AT(0x0000E800) { build/asm/data/main_80033400.bin.o(.data); }
    .main_800354B4 0x800354B4 : AT(0x000108B4) { FILL(0x00000000); build/asm/main_800354B4.s.o(.text); build/asm/main_800354B4.s.o(.rodata); build/asm/main_800354B4.s.o(.data); }
    .main_800354B4_bss (NOLOAD) : { build/asm/main_800354B4.s.o(.bss); }
    .main_800354DC 0x800354DC : AT(0x000108DC) { build/asm/data/main_800354DC.bin.o(.data); }
    .main_80036F3C 0x80036F3C : AT(0x0001233C) { FILL(0x00000000); build/asm/main_80036F3C.s.o(.text); build/asm/main_80036F3C.s.o(.rodata); build/asm/main_80036F3C.s.o(.data); }
    .main_80036F3C_bss (NOLOAD) : { build/asm/main_80036F3C.s.o(.bss); }
    .main_80037254 0x80037254 : AT(0x00012654) { build/asm/data/main_80037254.bin.o(.data); }
    .main_800377F0 0x800377F0 : AT(0x00012BF0) { FILL(0x00000000); build/asm/main_800377F0.s.o(.text); build/asm/main_800377F0.s.o(.rodata); build/asm/main_800377F0.s.o(.data); }
    .main_800377F0_bss (NOLOAD) : { build/asm/main_800377F0.s.o(.bss); }
    .main_80037904 0x80037904 : AT(0x00012D04) { build/asm/data/main_80037904.bin.o(.data); }
    .main_800398C8 0x800398C8 : AT(0x00014CC8) { FILL(0x00000000); build/asm/main_800398C8.s.o(.text); build/asm/main_800398C8.s.o(.rodata); build/asm/main_800398C8.s.o(.data); }
    .main_800398C8_bss (NOLOAD) : { build/asm/main_800398C8.s.o(.bss); }
    .main_80039990 0x80039990 : AT(0x00014D90) { build/asm/data/main_80039990.bin.o(.data); }
    .main_8003AAD8 0x8003AAD8 : AT(0x00015ED8) { FILL(0x00000000); build/asm/main_8003AAD8.s.o(.text); build/asm/main_8003AAD8.s.o(.rodata); build/asm/main_8003AAD8.s.o(.data); }
    .main_8003AAD8_bss (NOLOAD) : { build/asm/main_8003AAD8.s.o(.bss); }
    .main_8003ABB8 0x8003ABB8 : AT(0x00015FB8) { build/asm/data/main_8003ABB8.bin.o(.data); }
    .main_8003BE9C 0x8003BE9C : AT(0x0001729C) { FILL(0x00000000); build/asm/main_8003BE9C.s.o(.text); build/asm/main_8003BE9C.s.o(.rodata); build/asm/main_8003BE9C.s.o(.data); }
    .main_8003BE9C_bss (NOLOAD) : { build/asm/main_8003BE9C.s.o(.bss); }
    .main_8003BEC4 0x8003BEC4 : AT(0x000172C4) { build/asm/data/main_8003BEC4.bin.o(.data); }
    .main_80042E50 0x80042E50 : AT(0x0001E250) { FILL(0x00000000); build/asm/main_80042E50.s.o(.text); build/asm/main_80042E50.s.o(.rodata); build/asm/main_80042E50.s.o(.data); }
    .main_80042E50_bss (NOLOAD) : { build/asm/main_80042E50.s.o(.bss); }
    .main_80042F34 0x80042F34 : AT(0x0001E334) { build/asm/data/main_80042F34.bin.o(.data); }
    .main_800528B8 0x800528B8 : AT(0x0002DCB8) { FILL(0x00000000); build/asm/main_800528B8.s.o(.text); build/asm/main_800528B8.s.o(.rodata); build/asm/main_800528B8.s.o(.data); }
    .main_800528B8_bss (NOLOAD) : { build/asm/main_800528B8.s.o(.bss); }
    .main_800528E0 0x800528E0 : AT(0x0002DCE0) { build/asm/data/main_800528E0.bin.o(.data); }
    .main_80053CD0 0x80053CD0 : AT(0x0002F0D0) { FILL(0x00000000); build/asm/main_80053CD0.s.o(.text); build/asm/main_80053CD0.s.o(.rodata); build/asm/main_80053CD0.s.o(.data); }
    .main_80053CD0_bss (NOLOAD) : { build/asm/main_80053CD0.s.o(.bss); }
    .main_80053CF8 0x80053CF8 : AT(0x0002F0F8) { build/asm/data/main_80053CF8.bin.o(.data); }
    .main_800602DC 0x800602DC : AT(0x0003B6DC) { FILL(0x00000000); build/asm/main_800602DC.s.o(.text); build/asm/main_800602DC.s.o(.rodata); build/asm/main_800602DC.s.o(.data); }
    .main_800602DC_bss (NOLOAD) : { build/asm/main_800602DC.s.o(.bss); }
    .main_8006035C 0x8006035C : AT(0x0003B75C) { build/asm/data/main_8006035C.bin.o(.data); }
    .main_80069048 0x80069048 : AT(0x00044448) { FILL(0x00000000); build/asm/main_80069048.s.o(.text); build/asm/main_80069048.s.o(.rodata); build/asm/main_80069048.s.o(.data); }
    .main_80069048_bss (NOLOAD) : { build/asm/main_80069048.s.o(.bss); }
    .main_80069074 0x80069074 : AT(0x00044474) { build/asm/data/main_80069074.bin.o(.data); }
    .main_8007E19C 0x8007E19C : AT(0x0005959C) { FILL(0x00000000); build/asm/main_8007E19C.s.o(.text); build/asm/main_8007E19C.s.o(.rodata); build/asm/main_8007E19C.s.o(.data); }
    .main_8007E19C_bss (NOLOAD) : { build/asm/main_8007E19C.s.o(.bss); }
    .main_8007E1BC 0x8007E1BC : AT(0x000595BC) { build/asm/data/main_8007E1BC.bin.o(.data); }
    .main_80085350 0x80085350 : AT(0x00060750) { FILL(0x00000000); build/asm/main_80085350.s.o(.text); build/asm/main_80085350.s.o(.rodata); build/asm/main_80085350.s.o(.data); }
    .main_80085350_bss (NOLOAD) : { build/asm/main_80085350.s.o(.bss); }
    .main_8008535C 0x8008535C : AT(0x0006075C) { build/asm/data/main_8008535C.bin.o(.data); }
    .main_80087A88 0x80087A88 : AT(0x00062E88) { FILL(0x00000000); build/asm/main_80087A88.s.o(.text); build/asm/main_80087A88.s.o(.rodata); build/asm/main_80087A88.s.o(.data); }
    .main_80087A88_bss (NOLOAD) : { build/asm/main_80087A88.s.o(.bss); }
    .main_80087AA8 0x80087AA8 : AT(0x00062EA8) { build/asm/data/main_80087AA8.bin.o(.data); }
    .main_80090740 0x80090740 : AT(0x0006BB40) { FILL(0x00000000); build/asm/main_80090740.s.o(.text); build/asm/main_80090740.s.o(.rodata); build/asm/main_80090740.s.o(.data); }
    .main_80090740_bss (NOLOAD) : { build/asm/main_80090740.s.o(.bss); }
    .main_8009075C 0x8009075C : AT(0x0006BB5C) { build/asm/data/main_8009075C.bin.o(.data); }
    .main_80094170 0x80094170 : AT(0x0006F570) { FILL(0x00000000); build/asm/main_80094170.s.o(.text); build/asm/main_80094170.s.o(.rodata); build/asm/main_80094170.s.o(.data); }
    .main_80094170_bss (NOLOAD) : { build/asm/main_80094170.s.o(.bss); }
    .main_800941A0 0x800941A0 : AT(0x0006F5A0) { build/asm/data/main_800941A0.bin.o(.data); }
    .main_8009A8C0 0x8009A8C0 : AT(0x00075CC0) { FILL(0x00000000); build/asm/main_8009A8C0.s.o(.text); build/asm/main_8009A8C0.s.o(.rodata); build/asm/main_8009A8C0.s.o(.data); }
    .main_8009A8C0_bss (NOLOAD) : { build/asm/main_8009A8C0.s.o(.bss); }
    .main_8009A8E4 0x8009A8E4 : AT(0x00075CE4) { build/asm/data/main_8009A8E4.bin.o(.data); }
    .main_8009FA50 0x8009FA50 : AT(0x0007AE50) { FILL(0x00000000); build/asm/main_8009FA50.s.o(.text); build/asm/main_8009FA50.s.o(.rodata); build/asm/main_8009FA50.s.o(.data); }
    .main_8009FA50_bss (NOLOAD) : { build/asm/main_8009FA50.s.o(.bss); }
    .main_8009FB64 0x8009FB64 : AT(0x0007AF64) { build/asm/data/main_8009FB64.bin.o(.data); }
    .main_800B3C0C 0x800B3C0C : AT(0x0008F00C) { FILL(0x00000000); build/asm/main_800B3C0C.s.o(.text); build/asm/main_800B3C0C.s.o(.rodata); build/asm/main_800B3C0C.s.o(.data); }
    .main_800B3C0C_bss (NOLOAD) : { build/asm/main_800B3C0C.s.o(.bss); }
    .main_800B3C90 0x800B3C90 : AT(0x0008F090) { build/asm/data/main_800B3C90.bin.o(.data); }
    .main_800BC304 0x800BC304 : AT(0x00097704) { FILL(0x00000000); build/asm/main_800BC304.s.o(.text); build/asm/main_800BC304.s.o(.rodata); build/asm/main_800BC304.s.o(.data); }
    .main_800BC304_bss (NOLOAD) : { build/asm/main_800BC304.s.o(.bss); }
    .main_800BC348 0x800BC348 : AT(0x00097748) { build/asm/data/main_800BC348.bin.o(.data); }
    .main_800C44CC 0x800C44CC : AT(0x0009F8CC) { FILL(0x00000000); build/asm/main_800C44CC.s.o(.text); build/asm/main_800C44CC.s.o(.rodata); build/asm/main_800C44CC.s.o(.data); }
    .main_800C44CC_bss (NOLOAD) : { build/asm/main_800C44CC.s.o(.bss); }
    .main_800C44D4 0x800C44D4 : AT(0x0009F8D4) { build/asm/data/main_800C44D4.bin.o(.data); }
    .main_800D258C 0x800D258C : AT(0x000AD98C) { FILL(0x00000000); build/asm/main_800D258C.s.o(.text); build/asm/main_800D258C.s.o(.rodata); build/asm/main_800D258C.s.o(.data); }
    .main_800D258C_bss (NOLOAD) : { build/asm/main_800D258C.s.o(.bss); }
    .main_800D25A4 0x800D25A4 : AT(0x000AD9A4) { build/asm/data/main_800D25A4.bin.o(.data); }
    .main_800DB3C0 0x800DB3C0 : AT(0x000B67C0) { FILL(0x00000000); build/asm/main_800DB3C0.s.o(.text); build/asm/main_800DB3C0.s.o(.rodata); build/asm/main_800DB3C0.s.o(.data); }
    .main_800DB3C0_bss (NOLOAD) : { build/asm/main_800DB3C0.s.o(.bss); }
    .main_800DB4CC 0x800DB4CC : AT(0x000B68CC) { build/asm/data/main_800DB4CC.bin.o(.data); }
    .main_800DEE20 0x800DEE20 : AT(0x000BA220) { FILL(0x00000000); build/asm/main_800DEE20.s.o(.text); build/asm/main_800DEE20.s.o(.rodata); build/asm/main_800DEE20.s.o(.data); }
    .main_800DEE20_bss (NOLOAD) : { build/asm/main_800DEE20.s.o(.bss); }
    .main_800DEEA0 0x800DEEA0 : AT(0x000BA2A0) { build/asm/data/main_800DEEA0.bin.o(.data); }
    .main_800E1CC8 0x800E1CC8 : AT(0x000BD0C8) { FILL(0x00000000); build/asm/main_800E1CC8.s.o(.text); build/asm/main_800E1CC8.s.o(.rodata); build/asm/main_800E1CC8.s.o(.data); }
    .main_800E1CC8_bss (NOLOAD) : { build/asm/main_800E1CC8.s.o(.bss); }
    .main_800E1CCC 0x800E1CCC : AT(0x000BD0CC) { build/asm/data/main_800E1CCC.bin.o(.data); }
    .main_800E35E0 0x800E35E0 : AT(0x000BE9E0) { FILL(0x00000000); build/asm/main_800E35E0.s.o(.text); build/asm/main_800E35E0.s.o(.rodata); build/asm/main_800E35E0.s.o(.data); }
    .main_800E35E0_bss (NOLOAD) : { build/asm/main_800E35E0.s.o(.bss); }
    .main_800E35F0 0x800E35F0 : AT(0x000BE9F0) { build/asm/data/main_800E35F0.bin.o(.data); }
    .main_800EB8A8 0x800EB8A8 : AT(0x000C6CA8) { FILL(0x00000000); build/asm/main_800EB8A8.s.o(.text); build/asm/main_800EB8A8.s.o(.rodata); build/asm/main_800EB8A8.s.o(.data); }
    .main_800EB8A8_bss (NOLOAD) : { build/asm/main_800EB8A8.s.o(.bss); }
    .main_800EB8AC 0x800EB8AC : AT(0x000C6CAC) { build/asm/data/main_800EB8AC.bin.o(.data); }
    .main_800FB80C 0x800FB80C : AT(0x000D6C0C) { FILL(0x00000000); build/asm/main_800FB80C.s.o(.text); build/asm/main_800FB80C.s.o(.rodata); build/asm/main_800FB80C.s.o(.data); }
    .main_800FB80C_bss (NOLOAD) : { build/asm/main_800FB80C.s.o(.bss); }
    .main_800FB81C 0x800FB81C : AT(0x000D6C1C) { build/asm/data/main_800FB81C.bin.o(.data); }
    .main_800FBB00 0x800FBB00 : AT(0x000D6F00) { FILL(0x00000000); build/asm/main_800FBB00.s.o(.text); build/asm/main_800FBB00.s.o(.rodata); build/asm/main_800FBB00.s.o(.data); }
    .main_800FBB00_bss (NOLOAD) : { build/asm/main_800FBB00.s.o(.bss); }
    .main_800FBB10 0x800FBB10 : AT(0x000D6F10) { build/asm/data/main_800FBB10.bin.o(.data); }
    .main_80103760 0x80103760 : AT(0x000DEB60) { FILL(0x00000000); build/asm/main_80103760.s.o(.text); build/asm/main_80103760.s.o(.rodata); build/asm/main_80103760.s.o(.data); }
    .main_80103760_bss (NOLOAD) : { build/asm/main_80103760.s.o(.bss); }
    .main_80103788 0x80103788 : AT(0x000DEB88) { build/asm/data/main_80103788.bin.o(.data); }
    .main_801076F8 0x801076F8 : AT(0x000E2AF8) { FILL(0x00000000); build/asm/main_801076F8.s.o(.text); build/asm/main_801076F8.s.o(.rodata); build/asm/main_801076F8.s.o(.data); }
    .main_801076F8_bss (NOLOAD) : { build/asm/main_801076F8.s.o(.bss); }
    .main_8010775C 0x8010775C : AT(0x000E2B5C) { build/asm/data/main_8010775C.bin.o(.data); }
    .main_80117DF4 0x80117DF4 : AT(0x000F31F4) { FILL(0x00000000); build/asm/main_80117DF4.s.o(.text); build/asm/main_80117DF4.s.o(.rodata); build/asm/main_80117DF4.s.o(.data); }
    .main_80117DF4_bss (NOLOAD) : { build/asm/main_80117DF4.s.o(.bss); }
    .main_80117ECC 0x80117ECC : AT(0x000F32CC) { build/asm/data/main_80117ECC.bin.o(.data); }
    .main_801197C8 0x801197C8 : AT(0x000F4BC8) { FILL(0x00000000); build/asm/main_801197C8.s.o(.text); build/asm/main_801197C8.s.o(.rodata); build/asm/main_801197C8.s.o(.data); }
    .main_801197C8_bss (NOLOAD) : { build/asm/main_801197C8.s.o(.bss); }
    .main_801197CC 0x801197CC : AT(0x000F4BCC) { build/asm/data/main_801197CC.bin.o(.data); }
    .main_80119B54 0x80119B54 : AT(0x000F4F54) { FILL(0x00000000); build/asm/main_80119B54.s.o(.text); build/asm/main_80119B54.s.o(.rodata); build/asm/main_80119B54.s.o(.data); }
    .main_80119B54_bss (NOLOAD) : { build/asm/main_80119B54.s.o(.bss); }
    .main_80119B60 0x80119B60 : AT(0x000F4F60) { build/asm/data/main_80119B60.bin.o(.data); }
    .main_8011E3A8 0x8011E3A8 : AT(0x000F97A8) { FILL(0x00000000); build/asm/main_8011E3A8.s.o(.text); build/asm/main_8011E3A8.s.o(.rodata); build/asm/main_8011E3A8.s.o(.data); }
    .main_8011E3A8_bss (NOLOAD) : { build/asm/main_8011E3A8.s.o(.bss); }
    .main_8011E3B0 0x8011E3B0 : AT(0x000F97B0) { build/asm/data/main_8011E3B0.bin.o(.data); }
    .main_8012229C 0x8012229C : AT(0x000FD69C) { FILL(0x00000000); build/asm/main_8012229C.s.o(.text); build/asm/main_8012229C.s.o(.rodata); build/asm/main_8012229C.s.o(.data); }
    .main_8012229C_bss (NOLOAD) : { build/asm/main_8012229C.s.o(.bss); }
    .main_801222A0 0x801222A0 : AT(0x000FD6A0) { build/asm/data/main_801222A0.bin.o(.data); }
    .assets 0x80425C00 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
