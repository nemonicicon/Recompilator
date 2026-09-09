SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80200400 0x80200400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80200400.s.o(.text); build/asm/main_80200400.s.o(.rodata); build/asm/main_80200400.s.o(.data); }
    .main_80200400_bss (NOLOAD) : { build/asm/main_80200400.s.o(.bss); }
    .main_802005CC 0x802005CC : AT(0x000011CC) { FILL(0x00000000); build/asm/main_802005CC.s.o(.text); build/asm/main_802005CC.s.o(.rodata); build/asm/main_802005CC.s.o(.data); }
    .main_802005CC_bss (NOLOAD) : { build/asm/main_802005CC.s.o(.bss); }
    .main_802005E8 0x802005E8 : AT(0x000011E8) { FILL(0x00000000); build/asm/main_802005E8.s.o(.text); build/asm/main_802005E8.s.o(.rodata); build/asm/main_802005E8.s.o(.data); }
    .main_802005E8_bss (NOLOAD) : { build/asm/main_802005E8.s.o(.bss); }
    .main_80200A50 0x80200A50 : AT(0x00001650) { FILL(0x00000000); build/asm/main_80200A50.s.o(.text); build/asm/main_80200A50.s.o(.rodata); build/asm/main_80200A50.s.o(.data); }
    .main_80200A50_bss (NOLOAD) : { build/asm/main_80200A50.s.o(.bss); }
    .main_802010F0 0x802010F0 : AT(0x00001CF0) { FILL(0x00000000); build/asm/main_802010F0.s.o(.text); build/asm/main_802010F0.s.o(.rodata); build/asm/main_802010F0.s.o(.data); }
    .main_802010F0_bss (NOLOAD) : { build/asm/main_802010F0.s.o(.bss); }
    .main_80201108 0x80201108 : AT(0x00001D08) { build/asm/data/main_80201108.bin.o(.data); }
    .main_802023F8 0x802023F8 : AT(0x00002FF8) { FILL(0x00000000); build/asm/main_802023F8.s.o(.text); build/asm/main_802023F8.s.o(.rodata); build/asm/main_802023F8.s.o(.data); }
    .main_802023F8_bss (NOLOAD) : { build/asm/main_802023F8.s.o(.bss); }
    .main_80202444 0x80202444 : AT(0x00003044) { build/asm/data/main_80202444.bin.o(.data); }
    .main_80203480 0x80203480 : AT(0x00004080) { FILL(0x00000000); build/asm/main_80203480.s.o(.text); build/asm/main_80203480.s.o(.rodata); build/asm/main_80203480.s.o(.data); }
    .main_80203480_bss (NOLOAD) : { build/asm/main_80203480.s.o(.bss); }
    .main_80203488 0x80203488 : AT(0x00004088) { build/asm/data/main_80203488.bin.o(.data); }
    .main_80204D44 0x80204D44 : AT(0x00005944) { FILL(0x00000000); build/asm/main_80204D44.s.o(.text); build/asm/main_80204D44.s.o(.rodata); build/asm/main_80204D44.s.o(.data); }
    .main_80204D44_bss (NOLOAD) : { build/asm/main_80204D44.s.o(.bss); }
    .main_80204D54 0x80204D54 : AT(0x00005954) { build/asm/data/main_80204D54.bin.o(.data); }
    .main_802053C0 0x802053C0 : AT(0x00005FC0) { FILL(0x00000000); build/asm/main_802053C0.s.o(.text); build/asm/main_802053C0.s.o(.rodata); build/asm/main_802053C0.s.o(.data); }
    .main_802053C0_bss (NOLOAD) : { build/asm/main_802053C0.s.o(.bss); }
    .main_802053D0 0x802053D0 : AT(0x00005FD0) { build/asm/data/main_802053D0.bin.o(.data); }
    .main_80206C6C 0x80206C6C : AT(0x0000786C) { FILL(0x00000000); build/asm/main_80206C6C.s.o(.text); build/asm/main_80206C6C.s.o(.rodata); build/asm/main_80206C6C.s.o(.data); }
    .main_80206C6C_bss (NOLOAD) : { build/asm/main_80206C6C.s.o(.bss); }
    .main_80206C88 0x80206C88 : AT(0x00007888) { build/asm/data/main_80206C88.bin.o(.data); }
    .main_80208C0C 0x80208C0C : AT(0x0000980C) { FILL(0x00000000); build/asm/main_80208C0C.s.o(.text); build/asm/main_80208C0C.s.o(.rodata); build/asm/main_80208C0C.s.o(.data); }
    .main_80208C0C_bss (NOLOAD) : { build/asm/main_80208C0C.s.o(.bss); }
    .main_80208C10 0x80208C10 : AT(0x00009810) { build/asm/data/main_80208C10.bin.o(.data); }
    .main_80209A64 0x80209A64 : AT(0x0000A664) { FILL(0x00000000); build/asm/main_80209A64.s.o(.text); build/asm/main_80209A64.s.o(.rodata); build/asm/main_80209A64.s.o(.data); }
    .main_80209A64_bss (NOLOAD) : { build/asm/main_80209A64.s.o(.bss); }
    .main_80209A98 0x80209A98 : AT(0x0000A698) { build/asm/data/main_80209A98.bin.o(.data); }
    .main_8020FEDC 0x8020FEDC : AT(0x00010ADC) { FILL(0x00000000); build/asm/main_8020FEDC.s.o(.text); build/asm/main_8020FEDC.s.o(.rodata); build/asm/main_8020FEDC.s.o(.data); }
    .main_8020FEDC_bss (NOLOAD) : { build/asm/main_8020FEDC.s.o(.bss); }
    .main_8020FEF4 0x8020FEF4 : AT(0x00010AF4) { build/asm/data/main_8020FEF4.bin.o(.data); }
    .main_802109C8 0x802109C8 : AT(0x000115C8) { FILL(0x00000000); build/asm/main_802109C8.s.o(.text); build/asm/main_802109C8.s.o(.rodata); build/asm/main_802109C8.s.o(.data); }
    .main_802109C8_bss (NOLOAD) : { build/asm/main_802109C8.s.o(.bss); }
    .main_802109D0 0x802109D0 : AT(0x000115D0) { build/asm/data/main_802109D0.bin.o(.data); }
    .main_80211140 0x80211140 : AT(0x00011D40) { FILL(0x00000000); build/asm/main_80211140.s.o(.text); build/asm/main_80211140.s.o(.rodata); build/asm/main_80211140.s.o(.data); }
    .main_80211140_bss (NOLOAD) : { build/asm/main_80211140.s.o(.bss); }
    .main_80211160 0x80211160 : AT(0x00011D60) { build/asm/data/main_80211160.bin.o(.data); }
    .main_80212294 0x80212294 : AT(0x00012E94) { FILL(0x00000000); build/asm/main_80212294.s.o(.text); build/asm/main_80212294.s.o(.rodata); build/asm/main_80212294.s.o(.data); }
    .main_80212294_bss (NOLOAD) : { build/asm/main_80212294.s.o(.bss); }
    .main_802122CC 0x802122CC : AT(0x00012ECC) { build/asm/data/main_802122CC.bin.o(.data); }
    .main_80217C14 0x80217C14 : AT(0x00018814) { FILL(0x00000000); build/asm/main_80217C14.s.o(.text); build/asm/main_80217C14.s.o(.rodata); build/asm/main_80217C14.s.o(.data); }
    .main_80217C14_bss (NOLOAD) : { build/asm/main_80217C14.s.o(.bss); }
    .main_80217C30 0x80217C30 : AT(0x00018830) { build/asm/data/main_80217C30.bin.o(.data); }
    .main_8021B2E4 0x8021B2E4 : AT(0x0001BEE4) { FILL(0x00000000); build/asm/main_8021B2E4.s.o(.text); build/asm/main_8021B2E4.s.o(.rodata); build/asm/main_8021B2E4.s.o(.data); }
    .main_8021B2E4_bss (NOLOAD) : { build/asm/main_8021B2E4.s.o(.bss); }
    .main_8021B320 0x8021B320 : AT(0x0001BF20) { build/asm/data/main_8021B320.bin.o(.data); }
    .main_8021FCA0 0x8021FCA0 : AT(0x000208A0) { FILL(0x00000000); build/asm/main_8021FCA0.s.o(.text); build/asm/main_8021FCA0.s.o(.rodata); build/asm/main_8021FCA0.s.o(.data); }
    .main_8021FCA0_bss (NOLOAD) : { build/asm/main_8021FCA0.s.o(.bss); }
    .main_8021FCDC 0x8021FCDC : AT(0x000208DC) { build/asm/data/main_8021FCDC.bin.o(.data); }
    .main_802202B4 0x802202B4 : AT(0x00020EB4) { FILL(0x00000000); build/asm/main_802202B4.s.o(.text); build/asm/main_802202B4.s.o(.rodata); build/asm/main_802202B4.s.o(.data); }
    .main_802202B4_bss (NOLOAD) : { build/asm/main_802202B4.s.o(.bss); }
    .main_802202E8 0x802202E8 : AT(0x00020EE8) { build/asm/data/main_802202E8.bin.o(.data); }
    .main_80220A7C 0x80220A7C : AT(0x0002167C) { FILL(0x00000000); build/asm/main_80220A7C.s.o(.text); build/asm/main_80220A7C.s.o(.rodata); build/asm/main_80220A7C.s.o(.data); }
    .main_80220A7C_bss (NOLOAD) : { build/asm/main_80220A7C.s.o(.bss); }
    .main_80220AA4 0x80220AA4 : AT(0x000216A4) { build/asm/data/main_80220AA4.bin.o(.data); }
    .main_80222108 0x80222108 : AT(0x00022D08) { FILL(0x00000000); build/asm/main_80222108.s.o(.text); build/asm/main_80222108.s.o(.rodata); build/asm/main_80222108.s.o(.data); }
    .main_80222108_bss (NOLOAD) : { build/asm/main_80222108.s.o(.bss); }
    .main_80222144 0x80222144 : AT(0x00022D44) { build/asm/data/main_80222144.bin.o(.data); }
    .main_802225CC 0x802225CC : AT(0x000231CC) { FILL(0x00000000); build/asm/main_802225CC.s.o(.text); build/asm/main_802225CC.s.o(.rodata); build/asm/main_802225CC.s.o(.data); }
    .main_802225CC_bss (NOLOAD) : { build/asm/main_802225CC.s.o(.bss); }
    .main_802225D0 0x802225D0 : AT(0x000231D0) { build/asm/data/main_802225D0.bin.o(.data); }
    .main_80222AAC 0x80222AAC : AT(0x000236AC) { FILL(0x00000000); build/asm/main_80222AAC.s.o(.text); build/asm/main_80222AAC.s.o(.rodata); build/asm/main_80222AAC.s.o(.data); }
    .main_80222AAC_bss (NOLOAD) : { build/asm/main_80222AAC.s.o(.bss); }
    .main_80222AB4 0x80222AB4 : AT(0x000236B4) { build/asm/data/main_80222AB4.bin.o(.data); }
    .main_80224220 0x80224220 : AT(0x00024E20) { FILL(0x00000000); build/asm/main_80224220.s.o(.text); build/asm/main_80224220.s.o(.rodata); build/asm/main_80224220.s.o(.data); }
    .main_80224220_bss (NOLOAD) : { build/asm/main_80224220.s.o(.bss); }
    .main_802242C4 0x802242C4 : AT(0x00024EC4) { build/asm/data/main_802242C4.bin.o(.data); }
    .main_80224644 0x80224644 : AT(0x00025244) { FILL(0x00000000); build/asm/main_80224644.s.o(.text); build/asm/main_80224644.s.o(.rodata); build/asm/main_80224644.s.o(.data); }
    .main_80224644_bss (NOLOAD) : { build/asm/main_80224644.s.o(.bss); }
    .main_802246A8 0x802246A8 : AT(0x000252A8) { build/asm/data/main_802246A8.bin.o(.data); }
    .main_8022981C 0x8022981C : AT(0x0002A41C) { FILL(0x00000000); build/asm/main_8022981C.s.o(.text); build/asm/main_8022981C.s.o(.rodata); build/asm/main_8022981C.s.o(.data); }
    .main_8022981C_bss (NOLOAD) : { build/asm/main_8022981C.s.o(.bss); }
    .main_80229838 0x80229838 : AT(0x0002A438) { build/asm/data/main_80229838.bin.o(.data); }
    .main_8022D21C 0x8022D21C : AT(0x0002DE1C) { FILL(0x00000000); build/asm/main_8022D21C.s.o(.text); build/asm/main_8022D21C.s.o(.rodata); build/asm/main_8022D21C.s.o(.data); }
    .main_8022D21C_bss (NOLOAD) : { build/asm/main_8022D21C.s.o(.bss); }
    .main_8022D298 0x8022D298 : AT(0x0002DE98) { build/asm/data/main_8022D298.bin.o(.data); }
    .main_8022E6F0 0x8022E6F0 : AT(0x0002F2F0) { FILL(0x00000000); build/asm/main_8022E6F0.s.o(.text); build/asm/main_8022E6F0.s.o(.rodata); build/asm/main_8022E6F0.s.o(.data); }
    .main_8022E6F0_bss (NOLOAD) : { build/asm/main_8022E6F0.s.o(.bss); }
    .main_8022E708 0x8022E708 : AT(0x0002F308) { build/asm/data/main_8022E708.bin.o(.data); }
    .main_8022E808 0x8022E808 : AT(0x0002F408) { FILL(0x00000000); build/asm/main_8022E808.s.o(.text); build/asm/main_8022E808.s.o(.rodata); build/asm/main_8022E808.s.o(.data); }
    .main_8022E808_bss (NOLOAD) : { build/asm/main_8022E808.s.o(.bss); }
    .main_8022E814 0x8022E814 : AT(0x0002F414) { build/asm/data/main_8022E814.bin.o(.data); }
    .main_8022E864 0x8022E864 : AT(0x0002F464) { FILL(0x00000000); build/asm/main_8022E864.s.o(.text); build/asm/main_8022E864.s.o(.rodata); build/asm/main_8022E864.s.o(.data); }
    .main_8022E864_bss (NOLOAD) : { build/asm/main_8022E864.s.o(.bss); }
    .main_8022E910 0x8022E910 : AT(0x0002F510) { build/asm/data/main_8022E910.bin.o(.data); }
    .main_80232824 0x80232824 : AT(0x00033424) { FILL(0x00000000); build/asm/main_80232824.s.o(.text); build/asm/main_80232824.s.o(.rodata); build/asm/main_80232824.s.o(.data); }
    .main_80232824_bss (NOLOAD) : { build/asm/main_80232824.s.o(.bss); }
    .main_80232850 0x80232850 : AT(0x00033450) { build/asm/data/main_80232850.bin.o(.data); }
    .main_802346D0 0x802346D0 : AT(0x000352D0) { FILL(0x00000000); build/asm/main_802346D0.s.o(.text); build/asm/main_802346D0.s.o(.rodata); build/asm/main_802346D0.s.o(.data); }
    .main_802346D0_bss (NOLOAD) : { build/asm/main_802346D0.s.o(.bss); }
    .main_80234858 0x80234858 : AT(0x00035458) { build/asm/data/main_80234858.bin.o(.data); }
    .main_802391AC 0x802391AC : AT(0x00039DAC) { FILL(0x00000000); build/asm/main_802391AC.s.o(.text); build/asm/main_802391AC.s.o(.rodata); build/asm/main_802391AC.s.o(.data); }
    .main_802391AC_bss (NOLOAD) : { build/asm/main_802391AC.s.o(.bss); }
    .main_802391E8 0x802391E8 : AT(0x00039DE8) { build/asm/data/main_802391E8.bin.o(.data); }
    .main_8023AD9C 0x8023AD9C : AT(0x0003B99C) { FILL(0x00000000); build/asm/main_8023AD9C.s.o(.text); build/asm/main_8023AD9C.s.o(.rodata); build/asm/main_8023AD9C.s.o(.data); }
    .main_8023AD9C_bss (NOLOAD) : { build/asm/main_8023AD9C.s.o(.bss); }
    .main_8023AE04 0x8023AE04 : AT(0x0003BA04) { build/asm/data/main_8023AE04.bin.o(.data); }
    .main_8023CB24 0x8023CB24 : AT(0x0003D724) { FILL(0x00000000); build/asm/main_8023CB24.s.o(.text); build/asm/main_8023CB24.s.o(.rodata); build/asm/main_8023CB24.s.o(.data); }
    .main_8023CB24_bss (NOLOAD) : { build/asm/main_8023CB24.s.o(.bss); }
    .main_8023CB60 0x8023CB60 : AT(0x0003D760) { build/asm/data/main_8023CB60.bin.o(.data); }
    .main_8023D2B0 0x8023D2B0 : AT(0x0003DEB0) { FILL(0x00000000); build/asm/main_8023D2B0.s.o(.text); build/asm/main_8023D2B0.s.o(.rodata); build/asm/main_8023D2B0.s.o(.data); }
    .main_8023D2B0_bss (NOLOAD) : { build/asm/main_8023D2B0.s.o(.bss); }
    .main_8023D2EC 0x8023D2EC : AT(0x0003DEEC) { build/asm/data/main_8023D2EC.bin.o(.data); }
    .main_8023D3BC 0x8023D3BC : AT(0x0003DFBC) { FILL(0x00000000); build/asm/main_8023D3BC.s.o(.text); build/asm/main_8023D3BC.s.o(.rodata); build/asm/main_8023D3BC.s.o(.data); }
    .main_8023D3BC_bss (NOLOAD) : { build/asm/main_8023D3BC.s.o(.bss); }
    .main_8023D3D0 0x8023D3D0 : AT(0x0003DFD0) { build/asm/data/main_8023D3D0.bin.o(.data); }
    .main_8023DC80 0x8023DC80 : AT(0x0003E880) { FILL(0x00000000); build/asm/main_8023DC80.s.o(.text); build/asm/main_8023DC80.s.o(.rodata); build/asm/main_8023DC80.s.o(.data); }
    .main_8023DC80_bss (NOLOAD) : { build/asm/main_8023DC80.s.o(.bss); }
    .main_8023DD28 0x8023DD28 : AT(0x0003E928) { build/asm/data/main_8023DD28.bin.o(.data); }
    .main_8023ED0C 0x8023ED0C : AT(0x0003F90C) { FILL(0x00000000); build/asm/main_8023ED0C.s.o(.text); build/asm/main_8023ED0C.s.o(.rodata); build/asm/main_8023ED0C.s.o(.data); }
    .main_8023ED0C_bss (NOLOAD) : { build/asm/main_8023ED0C.s.o(.bss); }
    .main_8023ED74 0x8023ED74 : AT(0x0003F974) { build/asm/data/main_8023ED74.bin.o(.data); }
    .main_80240060 0x80240060 : AT(0x00040C60) { FILL(0x00000000); build/asm/main_80240060.s.o(.text); build/asm/main_80240060.s.o(.rodata); build/asm/main_80240060.s.o(.data); }
    .main_80240060_bss (NOLOAD) : { build/asm/main_80240060.s.o(.bss); }
    .main_80240078 0x80240078 : AT(0x00040C78) { build/asm/data/main_80240078.bin.o(.data); }
    .main_80242868 0x80242868 : AT(0x00043468) { FILL(0x00000000); build/asm/main_80242868.s.o(.text); build/asm/main_80242868.s.o(.rodata); build/asm/main_80242868.s.o(.data); }
    .main_80242868_bss (NOLOAD) : { build/asm/main_80242868.s.o(.bss); }
    .main_8024288C 0x8024288C : AT(0x0004348C) { build/asm/data/main_8024288C.bin.o(.data); }
    .main_80242A10 0x80242A10 : AT(0x00043610) { FILL(0x00000000); build/asm/main_80242A10.s.o(.text); build/asm/main_80242A10.s.o(.rodata); build/asm/main_80242A10.s.o(.data); }
    .main_80242A10_bss (NOLOAD) : { build/asm/main_80242A10.s.o(.bss); }
    .main_80242A20 0x80242A20 : AT(0x00043620) { build/asm/data/main_80242A20.bin.o(.data); }
    .main_802444F8 0x802444F8 : AT(0x000450F8) { FILL(0x00000000); build/asm/main_802444F8.s.o(.text); build/asm/main_802444F8.s.o(.rodata); build/asm/main_802444F8.s.o(.data); }
    .main_802444F8_bss (NOLOAD) : { build/asm/main_802444F8.s.o(.bss); }
    .main_80244524 0x80244524 : AT(0x00045124) { build/asm/data/main_80244524.bin.o(.data); }
    .main_80246098 0x80246098 : AT(0x00046C98) { FILL(0x00000000); build/asm/main_80246098.s.o(.text); build/asm/main_80246098.s.o(.rodata); build/asm/main_80246098.s.o(.data); }
    .main_80246098_bss (NOLOAD) : { build/asm/main_80246098.s.o(.bss); }
    .main_80246124 0x80246124 : AT(0x00046D24) { build/asm/data/main_80246124.bin.o(.data); }
    .main_802465BC 0x802465BC : AT(0x000471BC) { FILL(0x00000000); build/asm/main_802465BC.s.o(.text); build/asm/main_802465BC.s.o(.rodata); build/asm/main_802465BC.s.o(.data); }
    .main_802465BC_bss (NOLOAD) : { build/asm/main_802465BC.s.o(.bss); }
    .main_80246648 0x80246648 : AT(0x00047248) { build/asm/data/main_80246648.bin.o(.data); }
    .main_80246758 0x80246758 : AT(0x00047358) { FILL(0x00000000); build/asm/main_80246758.s.o(.text); build/asm/main_80246758.s.o(.rodata); build/asm/main_80246758.s.o(.data); }
    .main_80246758_bss (NOLOAD) : { build/asm/main_80246758.s.o(.bss); }
    .main_802467A8 0x802467A8 : AT(0x000473A8) { build/asm/data/main_802467A8.bin.o(.data); }
    .main_802468B8 0x802468B8 : AT(0x000474B8) { FILL(0x00000000); build/asm/main_802468B8.s.o(.text); build/asm/main_802468B8.s.o(.rodata); build/asm/main_802468B8.s.o(.data); }
    .main_802468B8_bss (NOLOAD) : { build/asm/main_802468B8.s.o(.bss); }
    .main_802468E0 0x802468E0 : AT(0x000474E0) { build/asm/data/main_802468E0.bin.o(.data); }
    .main_802474F8 0x802474F8 : AT(0x000480F8) { FILL(0x00000000); build/asm/main_802474F8.s.o(.text); build/asm/main_802474F8.s.o(.rodata); build/asm/main_802474F8.s.o(.data); }
    .main_802474F8_bss (NOLOAD) : { build/asm/main_802474F8.s.o(.bss); }
    .main_80247614 0x80247614 : AT(0x00048214) { build/asm/data/main_80247614.bin.o(.data); }
    .main_80247DA8 0x80247DA8 : AT(0x000489A8) { FILL(0x00000000); build/asm/main_80247DA8.s.o(.text); build/asm/main_80247DA8.s.o(.rodata); build/asm/main_80247DA8.s.o(.data); }
    .main_80247DA8_bss (NOLOAD) : { build/asm/main_80247DA8.s.o(.bss); }
    .main_80247DCC 0x80247DCC : AT(0x000489CC) { build/asm/data/main_80247DCC.bin.o(.data); }
    .main_8024C7FC 0x8024C7FC : AT(0x0004D3FC) { FILL(0x00000000); build/asm/main_8024C7FC.s.o(.text); build/asm/main_8024C7FC.s.o(.rodata); build/asm/main_8024C7FC.s.o(.data); }
    .main_8024C7FC_bss (NOLOAD) : { build/asm/main_8024C7FC.s.o(.bss); }
    .main_8024C814 0x8024C814 : AT(0x0004D414) { build/asm/data/main_8024C814.bin.o(.data); }
    .main_8024CA2C 0x8024CA2C : AT(0x0004D62C) { FILL(0x00000000); build/asm/main_8024CA2C.s.o(.text); build/asm/main_8024CA2C.s.o(.rodata); build/asm/main_8024CA2C.s.o(.data); }
    .main_8024CA2C_bss (NOLOAD) : { build/asm/main_8024CA2C.s.o(.bss); }
    .main_8024CA84 0x8024CA84 : AT(0x0004D684) { build/asm/data/main_8024CA84.bin.o(.data); }
    .main_8024FA90 0x8024FA90 : AT(0x00050690) { FILL(0x00000000); build/asm/main_8024FA90.s.o(.text); build/asm/main_8024FA90.s.o(.rodata); build/asm/main_8024FA90.s.o(.data); }
    .main_8024FA90_bss (NOLOAD) : { build/asm/main_8024FA90.s.o(.bss); }
    .main_8024FB50 0x8024FB50 : AT(0x00050750) { build/asm/data/main_8024FB50.bin.o(.data); }
    .main_802511C8 0x802511C8 : AT(0x00051DC8) { FILL(0x00000000); build/asm/main_802511C8.s.o(.text); build/asm/main_802511C8.s.o(.rodata); build/asm/main_802511C8.s.o(.data); }
    .main_802511C8_bss (NOLOAD) : { build/asm/main_802511C8.s.o(.bss); }
    .main_802511E4 0x802511E4 : AT(0x00051DE4) { build/asm/data/main_802511E4.bin.o(.data); }
    .main_80256C84 0x80256C84 : AT(0x00057884) { FILL(0x00000000); build/asm/main_80256C84.s.o(.text); build/asm/main_80256C84.s.o(.rodata); build/asm/main_80256C84.s.o(.data); }
    .main_80256C84_bss (NOLOAD) : { build/asm/main_80256C84.s.o(.bss); }
    .main_80256CA8 0x80256CA8 : AT(0x000578A8) { build/asm/data/main_80256CA8.bin.o(.data); }
    .main_80257FBC 0x80257FBC : AT(0x00058BBC) { FILL(0x00000000); build/asm/main_80257FBC.s.o(.text); build/asm/main_80257FBC.s.o(.rodata); build/asm/main_80257FBC.s.o(.data); }
    .main_80257FBC_bss (NOLOAD) : { build/asm/main_80257FBC.s.o(.bss); }
    .main_80257FE8 0x80257FE8 : AT(0x00058BE8) { build/asm/data/main_80257FE8.bin.o(.data); }
    .main_80258100 0x80258100 : AT(0x00058D00) { FILL(0x00000000); build/asm/main_80258100.s.o(.text); build/asm/main_80258100.s.o(.rodata); build/asm/main_80258100.s.o(.data); }
    .main_80258100_bss (NOLOAD) : { build/asm/main_80258100.s.o(.bss); }
    .main_80258124 0x80258124 : AT(0x00058D24) { build/asm/data/main_80258124.bin.o(.data); }
    .main_8025853C 0x8025853C : AT(0x0005913C) { FILL(0x00000000); build/asm/main_8025853C.s.o(.text); build/asm/main_8025853C.s.o(.rodata); build/asm/main_8025853C.s.o(.data); }
    .main_8025853C_bss (NOLOAD) : { build/asm/main_8025853C.s.o(.bss); }
    .main_80258550 0x80258550 : AT(0x00059150) { build/asm/data/main_80258550.bin.o(.data); }
    .main_80259CCC 0x80259CCC : AT(0x0005A8CC) { FILL(0x00000000); build/asm/main_80259CCC.s.o(.text); build/asm/main_80259CCC.s.o(.rodata); build/asm/main_80259CCC.s.o(.data); }
    .main_80259CCC_bss (NOLOAD) : { build/asm/main_80259CCC.s.o(.bss); }
    .main_80259CD8 0x80259CD8 : AT(0x0005A8D8) { build/asm/data/main_80259CD8.bin.o(.data); }
    .main_80259E40 0x80259E40 : AT(0x0005AA40) { FILL(0x00000000); build/asm/main_80259E40.s.o(.text); build/asm/main_80259E40.s.o(.rodata); build/asm/main_80259E40.s.o(.data); }
    .main_80259E40_bss (NOLOAD) : { build/asm/main_80259E40.s.o(.bss); }
    .main_80259E5C 0x80259E5C : AT(0x0005AA5C) { build/asm/data/main_80259E5C.bin.o(.data); }
    .main_8025A378 0x8025A378 : AT(0x0005AF78) { FILL(0x00000000); build/asm/main_8025A378.s.o(.text); build/asm/main_8025A378.s.o(.rodata); build/asm/main_8025A378.s.o(.data); }
    .main_8025A378_bss (NOLOAD) : { build/asm/main_8025A378.s.o(.bss); }
    .main_8025A37C 0x8025A37C : AT(0x0005AF7C) { build/asm/data/main_8025A37C.bin.o(.data); }
    .main_8025B468 0x8025B468 : AT(0x0005C068) { FILL(0x00000000); build/asm/main_8025B468.s.o(.text); build/asm/main_8025B468.s.o(.rodata); build/asm/main_8025B468.s.o(.data); }
    .main_8025B468_bss (NOLOAD) : { build/asm/main_8025B468.s.o(.bss); }
    .main_8025B4D8 0x8025B4D8 : AT(0x0005C0D8) { build/asm/data/main_8025B4D8.bin.o(.data); }
    .main_8025C998 0x8025C998 : AT(0x0005D598) { FILL(0x00000000); build/asm/main_8025C998.s.o(.text); build/asm/main_8025C998.s.o(.rodata); build/asm/main_8025C998.s.o(.data); }
    .main_8025C998_bss (NOLOAD) : { build/asm/main_8025C998.s.o(.bss); }
    .main_8025CA3C 0x8025CA3C : AT(0x0005D63C) { build/asm/data/main_8025CA3C.bin.o(.data); }
    .main_8025D0EC 0x8025D0EC : AT(0x0005DCEC) { FILL(0x00000000); build/asm/main_8025D0EC.s.o(.text); build/asm/main_8025D0EC.s.o(.rodata); build/asm/main_8025D0EC.s.o(.data); }
    .main_8025D0EC_bss (NOLOAD) : { build/asm/main_8025D0EC.s.o(.bss); }
    .main_8025D114 0x8025D114 : AT(0x0005DD14) { build/asm/data/main_8025D114.bin.o(.data); }
    .main_802610D0 0x802610D0 : AT(0x00061CD0) { FILL(0x00000000); build/asm/main_802610D0.s.o(.text); build/asm/main_802610D0.s.o(.rodata); build/asm/main_802610D0.s.o(.data); }
    .main_802610D0_bss (NOLOAD) : { build/asm/main_802610D0.s.o(.bss); }
    .main_802610F8 0x802610F8 : AT(0x00061CF8) { build/asm/data/main_802610F8.bin.o(.data); }
    .main_802650F0 0x802650F0 : AT(0x00065CF0) { FILL(0x00000000); build/asm/main_802650F0.s.o(.text); build/asm/main_802650F0.s.o(.rodata); build/asm/main_802650F0.s.o(.data); }
    .main_802650F0_bss (NOLOAD) : { build/asm/main_802650F0.s.o(.bss); }
    .main_802651AC 0x802651AC : AT(0x00065DAC) { build/asm/data/main_802651AC.bin.o(.data); }
    .main_80265CA4 0x80265CA4 : AT(0x000668A4) { FILL(0x00000000); build/asm/main_80265CA4.s.o(.text); build/asm/main_80265CA4.s.o(.rodata); build/asm/main_80265CA4.s.o(.data); }
    .main_80265CA4_bss (NOLOAD) : { build/asm/main_80265CA4.s.o(.bss); }
    .main_80265D34 0x80265D34 : AT(0x00066934) { build/asm/data/main_80265D34.bin.o(.data); }
    .main_80265F5C 0x80265F5C : AT(0x00066B5C) { FILL(0x00000000); build/asm/main_80265F5C.s.o(.text); build/asm/main_80265F5C.s.o(.rodata); build/asm/main_80265F5C.s.o(.data); }
    .main_80265F5C_bss (NOLOAD) : { build/asm/main_80265F5C.s.o(.bss); }
    .main_80265F6C 0x80265F6C : AT(0x00066B6C) { build/asm/data/main_80265F6C.bin.o(.data); }
    .main_80266884 0x80266884 : AT(0x00067484) { FILL(0x00000000); build/asm/main_80266884.s.o(.text); build/asm/main_80266884.s.o(.rodata); build/asm/main_80266884.s.o(.data); }
    .main_80266884_bss (NOLOAD) : { build/asm/main_80266884.s.o(.bss); }
    .main_80266A64 0x80266A64 : AT(0x00067664) { build/asm/data/main_80266A64.bin.o(.data); }
    .main_80266FD8 0x80266FD8 : AT(0x00067BD8) { FILL(0x00000000); build/asm/main_80266FD8.s.o(.text); build/asm/main_80266FD8.s.o(.rodata); build/asm/main_80266FD8.s.o(.data); }
    .main_80266FD8_bss (NOLOAD) : { build/asm/main_80266FD8.s.o(.bss); }
    .main_802670CC 0x802670CC : AT(0x00067CCC) { build/asm/data/main_802670CC.bin.o(.data); }
    .main_80269E20 0x80269E20 : AT(0x0006AA20) { FILL(0x00000000); build/asm/main_80269E20.s.o(.text); build/asm/main_80269E20.s.o(.rodata); build/asm/main_80269E20.s.o(.data); }
    .main_80269E20_bss (NOLOAD) : { build/asm/main_80269E20.s.o(.bss); }
    .main_80269EC8 0x80269EC8 : AT(0x0006AAC8) { build/asm/data/main_80269EC8.bin.o(.data); }
    .main_8026D710 0x8026D710 : AT(0x0006E310) { FILL(0x00000000); build/asm/main_8026D710.s.o(.text); build/asm/main_8026D710.s.o(.rodata); build/asm/main_8026D710.s.o(.data); }
    .main_8026D710_bss (NOLOAD) : { build/asm/main_8026D710.s.o(.bss); }
    .main_8026D720 0x8026D720 : AT(0x0006E320) { build/asm/data/main_8026D720.bin.o(.data); }
    .main_8026DA48 0x8026DA48 : AT(0x0006E648) { FILL(0x00000000); build/asm/main_8026DA48.s.o(.text); build/asm/main_8026DA48.s.o(.rodata); build/asm/main_8026DA48.s.o(.data); }
    .main_8026DA48_bss (NOLOAD) : { build/asm/main_8026DA48.s.o(.bss); }
    .main_8026DA54 0x8026DA54 : AT(0x0006E654) { build/asm/data/main_8026DA54.bin.o(.data); }
    .main_8026FBDC 0x8026FBDC : AT(0x000707DC) { FILL(0x00000000); build/asm/main_8026FBDC.s.o(.text); build/asm/main_8026FBDC.s.o(.rodata); build/asm/main_8026FBDC.s.o(.data); }
    .main_8026FBDC_bss (NOLOAD) : { build/asm/main_8026FBDC.s.o(.bss); }
    .main_8026FC7C 0x8026FC7C : AT(0x0007087C) { build/asm/data/main_8026FC7C.bin.o(.data); }
    .main_802719E8 0x802719E8 : AT(0x000725E8) { FILL(0x00000000); build/asm/main_802719E8.s.o(.text); build/asm/main_802719E8.s.o(.rodata); build/asm/main_802719E8.s.o(.data); }
    .main_802719E8_bss (NOLOAD) : { build/asm/main_802719E8.s.o(.bss); }
    .main_802719F8 0x802719F8 : AT(0x000725F8) { build/asm/data/main_802719F8.bin.o(.data); }
    .main_802748E4 0x802748E4 : AT(0x000754E4) { FILL(0x00000000); build/asm/main_802748E4.s.o(.text); build/asm/main_802748E4.s.o(.rodata); build/asm/main_802748E4.s.o(.data); }
    .main_802748E4_bss (NOLOAD) : { build/asm/main_802748E4.s.o(.bss); }
    .main_802748F0 0x802748F0 : AT(0x000754F0) { build/asm/data/main_802748F0.bin.o(.data); }
    .main_80274B0C 0x80274B0C : AT(0x0007570C) { FILL(0x00000000); build/asm/main_80274B0C.s.o(.text); build/asm/main_80274B0C.s.o(.rodata); build/asm/main_80274B0C.s.o(.data); }
    .main_80274B0C_bss (NOLOAD) : { build/asm/main_80274B0C.s.o(.bss); }
    .main_80274B20 0x80274B20 : AT(0x00075720) { build/asm/data/main_80274B20.bin.o(.data); }
    .main_80274C18 0x80274C18 : AT(0x00075818) { FILL(0x00000000); build/asm/main_80274C18.s.o(.text); build/asm/main_80274C18.s.o(.rodata); build/asm/main_80274C18.s.o(.data); }
    .main_80274C18_bss (NOLOAD) : { build/asm/main_80274C18.s.o(.bss); }
    .main_80274C2C 0x80274C2C : AT(0x0007582C) { build/asm/data/main_80274C2C.bin.o(.data); }
    .main_80275DD8 0x80275DD8 : AT(0x000769D8) { FILL(0x00000000); build/asm/main_80275DD8.s.o(.text); build/asm/main_80275DD8.s.o(.rodata); build/asm/main_80275DD8.s.o(.data); }
    .main_80275DD8_bss (NOLOAD) : { build/asm/main_80275DD8.s.o(.bss); }
    .main_80275E0C 0x80275E0C : AT(0x00076A0C) { build/asm/data/main_80275E0C.bin.o(.data); }
    .main_80276C08 0x80276C08 : AT(0x00077808) { FILL(0x00000000); build/asm/main_80276C08.s.o(.text); build/asm/main_80276C08.s.o(.rodata); build/asm/main_80276C08.s.o(.data); }
    .main_80276C08_bss (NOLOAD) : { build/asm/main_80276C08.s.o(.bss); }
    .main_80276C24 0x80276C24 : AT(0x00077824) { build/asm/data/main_80276C24.bin.o(.data); }
    .main_8027ACB8 0x8027ACB8 : AT(0x0007B8B8) { FILL(0x00000000); build/asm/main_8027ACB8.s.o(.text); build/asm/main_8027ACB8.s.o(.rodata); build/asm/main_8027ACB8.s.o(.data); }
    .main_8027ACB8_bss (NOLOAD) : { build/asm/main_8027ACB8.s.o(.bss); }
    .main_8027ACD4 0x8027ACD4 : AT(0x0007B8D4) { build/asm/data/main_8027ACD4.bin.o(.data); }
    .main_8027D250 0x8027D250 : AT(0x0007DE50) { FILL(0x00000000); build/asm/main_8027D250.s.o(.text); build/asm/main_8027D250.s.o(.rodata); build/asm/main_8027D250.s.o(.data); }
    .main_8027D250_bss (NOLOAD) : { build/asm/main_8027D250.s.o(.bss); }
    .main_8027D27C 0x8027D27C : AT(0x0007DE7C) { build/asm/data/main_8027D27C.bin.o(.data); }
    .main_8027DD6C 0x8027DD6C : AT(0x0007E96C) { FILL(0x00000000); build/asm/main_8027DD6C.s.o(.text); build/asm/main_8027DD6C.s.o(.rodata); build/asm/main_8027DD6C.s.o(.data); }
    .main_8027DD6C_bss (NOLOAD) : { build/asm/main_8027DD6C.s.o(.bss); }
    .main_8027DD84 0x8027DD84 : AT(0x0007E984) { build/asm/data/main_8027DD84.bin.o(.data); }
    .main_8027DF18 0x8027DF18 : AT(0x0007EB18) { FILL(0x00000000); build/asm/main_8027DF18.s.o(.text); build/asm/main_8027DF18.s.o(.rodata); build/asm/main_8027DF18.s.o(.data); }
    .main_8027DF18_bss (NOLOAD) : { build/asm/main_8027DF18.s.o(.bss); }
    .main_8027DF20 0x8027DF20 : AT(0x0007EB20) { build/asm/data/main_8027DF20.bin.o(.data); }
    .main_8027EE70 0x8027EE70 : AT(0x0007FA70) { FILL(0x00000000); build/asm/main_8027EE70.s.o(.text); build/asm/main_8027EE70.s.o(.rodata); build/asm/main_8027EE70.s.o(.data); }
    .main_8027EE70_bss (NOLOAD) : { build/asm/main_8027EE70.s.o(.bss); }
    .main_8027EEB0 0x8027EEB0 : AT(0x0007FAB0) { build/asm/data/main_8027EEB0.bin.o(.data); }
    .main_8027F58C 0x8027F58C : AT(0x0008018C) { FILL(0x00000000); build/asm/main_8027F58C.s.o(.text); build/asm/main_8027F58C.s.o(.rodata); build/asm/main_8027F58C.s.o(.data); }
    .main_8027F58C_bss (NOLOAD) : { build/asm/main_8027F58C.s.o(.bss); }
    .main_8027F590 0x8027F590 : AT(0x00080190) { build/asm/data/main_8027F590.bin.o(.data); }
    .main_8027FF9C 0x8027FF9C : AT(0x00080B9C) { FILL(0x00000000); build/asm/main_8027FF9C.s.o(.text); build/asm/main_8027FF9C.s.o(.rodata); build/asm/main_8027FF9C.s.o(.data); }
    .main_8027FF9C_bss (NOLOAD) : { build/asm/main_8027FF9C.s.o(.bss); }
    .main_8027FFC4 0x8027FFC4 : AT(0x00080BC4) { build/asm/data/main_8027FFC4.bin.o(.data); }
    .main_80285478 0x80285478 : AT(0x00086078) { FILL(0x00000000); build/asm/main_80285478.s.o(.text); build/asm/main_80285478.s.o(.rodata); build/asm/main_80285478.s.o(.data); }
    .main_80285478_bss (NOLOAD) : { build/asm/main_80285478.s.o(.bss); }
    .main_802854C8 0x802854C8 : AT(0x000860C8) { build/asm/data/main_802854C8.bin.o(.data); }
    .main_80286FBC 0x80286FBC : AT(0x00087BBC) { FILL(0x00000000); build/asm/main_80286FBC.s.o(.text); build/asm/main_80286FBC.s.o(.rodata); build/asm/main_80286FBC.s.o(.data); }
    .main_80286FBC_bss (NOLOAD) : { build/asm/main_80286FBC.s.o(.bss); }
    .main_80286FD4 0x80286FD4 : AT(0x00087BD4) { build/asm/data/main_80286FD4.bin.o(.data); }
    .main_80287B48 0x80287B48 : AT(0x00088748) { FILL(0x00000000); build/asm/main_80287B48.s.o(.text); build/asm/main_80287B48.s.o(.rodata); build/asm/main_80287B48.s.o(.data); }
    .main_80287B48_bss (NOLOAD) : { build/asm/main_80287B48.s.o(.bss); }
    .main_80287B90 0x80287B90 : AT(0x00088790) { build/asm/data/main_80287B90.bin.o(.data); }
    .main_8028C4A8 0x8028C4A8 : AT(0x0008D0A8) { FILL(0x00000000); build/asm/main_8028C4A8.s.o(.text); build/asm/main_8028C4A8.s.o(.rodata); build/asm/main_8028C4A8.s.o(.data); }
    .main_8028C4A8_bss (NOLOAD) : { build/asm/main_8028C4A8.s.o(.bss); }
    .main_8028C4B8 0x8028C4B8 : AT(0x0008D0B8) { build/asm/data/main_8028C4B8.bin.o(.data); }
    .main_80293238 0x80293238 : AT(0x00093E38) { FILL(0x00000000); build/asm/main_80293238.s.o(.text); build/asm/main_80293238.s.o(.rodata); build/asm/main_80293238.s.o(.data); }
    .main_80293238_bss (NOLOAD) : { build/asm/main_80293238.s.o(.bss); }
    .main_80293460 0x80293460 : AT(0x00094060) { build/asm/data/main_80293460.bin.o(.data); }
    .main_80295674 0x80295674 : AT(0x00096274) { FILL(0x00000000); build/asm/main_80295674.s.o(.text); build/asm/main_80295674.s.o(.rodata); build/asm/main_80295674.s.o(.data); }
    .main_80295674_bss (NOLOAD) : { build/asm/main_80295674.s.o(.bss); }
    .main_80295720 0x80295720 : AT(0x00096320) { build/asm/data/main_80295720.bin.o(.data); }
    .main_80296764 0x80296764 : AT(0x00097364) { FILL(0x00000000); build/asm/main_80296764.s.o(.text); build/asm/main_80296764.s.o(.rodata); build/asm/main_80296764.s.o(.data); }
    .main_80296764_bss (NOLOAD) : { build/asm/main_80296764.s.o(.bss); }
    .main_802967E4 0x802967E4 : AT(0x000973E4) { build/asm/data/main_802967E4.bin.o(.data); }
    .main_802979F4 0x802979F4 : AT(0x000985F4) { FILL(0x00000000); build/asm/main_802979F4.s.o(.text); build/asm/main_802979F4.s.o(.rodata); build/asm/main_802979F4.s.o(.data); }
    .main_802979F4_bss (NOLOAD) : { build/asm/main_802979F4.s.o(.bss); }
    .main_80297AA0 0x80297AA0 : AT(0x000986A0) { build/asm/data/main_80297AA0.bin.o(.data); }
    .main_802991F8 0x802991F8 : AT(0x00099DF8) { FILL(0x00000000); build/asm/main_802991F8.s.o(.text); build/asm/main_802991F8.s.o(.rodata); build/asm/main_802991F8.s.o(.data); }
    .main_802991F8_bss (NOLOAD) : { build/asm/main_802991F8.s.o(.bss); }
    .main_80299300 0x80299300 : AT(0x00099F00) { build/asm/data/main_80299300.bin.o(.data); }
    .main_8029966C 0x8029966C : AT(0x0009A26C) { FILL(0x00000000); build/asm/main_8029966C.s.o(.text); build/asm/main_8029966C.s.o(.rodata); build/asm/main_8029966C.s.o(.data); }
    .main_8029966C_bss (NOLOAD) : { build/asm/main_8029966C.s.o(.bss); }
    .main_802996A0 0x802996A0 : AT(0x0009A2A0) { build/asm/data/main_802996A0.bin.o(.data); }
    .main_8029A754 0x8029A754 : AT(0x0009B354) { FILL(0x00000000); build/asm/main_8029A754.s.o(.text); build/asm/main_8029A754.s.o(.rodata); build/asm/main_8029A754.s.o(.data); }
    .main_8029A754_bss (NOLOAD) : { build/asm/main_8029A754.s.o(.bss); }
    .main_8029A758 0x8029A758 : AT(0x0009B358) { build/asm/data/main_8029A758.bin.o(.data); }
    .main_8029C268 0x8029C268 : AT(0x0009CE68) { FILL(0x00000000); build/asm/main_8029C268.s.o(.text); build/asm/main_8029C268.s.o(.rodata); build/asm/main_8029C268.s.o(.data); }
    .main_8029C268_bss (NOLOAD) : { build/asm/main_8029C268.s.o(.bss); }
    .main_8029C2B4 0x8029C2B4 : AT(0x0009CEB4) { build/asm/data/main_8029C2B4.bin.o(.data); }
    .main_8029CF0C 0x8029CF0C : AT(0x0009DB0C) { FILL(0x00000000); build/asm/main_8029CF0C.s.o(.text); build/asm/main_8029CF0C.s.o(.rodata); build/asm/main_8029CF0C.s.o(.data); }
    .main_8029CF0C_bss (NOLOAD) : { build/asm/main_8029CF0C.s.o(.bss); }
    .main_8029CF2C 0x8029CF2C : AT(0x0009DB2C) { build/asm/data/main_8029CF2C.bin.o(.data); }
    .main_8029EBD8 0x8029EBD8 : AT(0x0009F7D8) { FILL(0x00000000); build/asm/main_8029EBD8.s.o(.text); build/asm/main_8029EBD8.s.o(.rodata); build/asm/main_8029EBD8.s.o(.data); }
    .main_8029EBD8_bss (NOLOAD) : { build/asm/main_8029EBD8.s.o(.bss); }
    .main_8029EC50 0x8029EC50 : AT(0x0009F850) { build/asm/data/main_8029EC50.bin.o(.data); }
    .main_802A0B54 0x802A0B54 : AT(0x000A1754) { FILL(0x00000000); build/asm/main_802A0B54.s.o(.text); build/asm/main_802A0B54.s.o(.rodata); build/asm/main_802A0B54.s.o(.data); }
    .main_802A0B54_bss (NOLOAD) : { build/asm/main_802A0B54.s.o(.bss); }
    .main_802A0BF0 0x802A0BF0 : AT(0x000A17F0) { build/asm/data/main_802A0BF0.bin.o(.data); }
    .main_802A5850 0x802A5850 : AT(0x000A6450) { FILL(0x00000000); build/asm/main_802A5850.s.o(.text); build/asm/main_802A5850.s.o(.rodata); build/asm/main_802A5850.s.o(.data); }
    .main_802A5850_bss (NOLOAD) : { build/asm/main_802A5850.s.o(.bss); }
    .main_802A5890 0x802A5890 : AT(0x000A6490) { build/asm/data/main_802A5890.bin.o(.data); }
    .main_802A8424 0x802A8424 : AT(0x000A9024) { FILL(0x00000000); build/asm/main_802A8424.s.o(.text); build/asm/main_802A8424.s.o(.rodata); build/asm/main_802A8424.s.o(.data); }
    .main_802A8424_bss (NOLOAD) : { build/asm/main_802A8424.s.o(.bss); }
    .main_802A84A8 0x802A84A8 : AT(0x000A90A8) { build/asm/data/main_802A84A8.bin.o(.data); }
    .main_802ACCF0 0x802ACCF0 : AT(0x000AD8F0) { FILL(0x00000000); build/asm/main_802ACCF0.s.o(.text); build/asm/main_802ACCF0.s.o(.rodata); build/asm/main_802ACCF0.s.o(.data); }
    .main_802ACCF0_bss (NOLOAD) : { build/asm/main_802ACCF0.s.o(.bss); }
    .main_802ACD0C 0x802ACD0C : AT(0x000AD90C) { build/asm/data/main_802ACD0C.bin.o(.data); }
    .main_802ADD78 0x802ADD78 : AT(0x000AE978) { FILL(0x00000000); build/asm/main_802ADD78.s.o(.text); build/asm/main_802ADD78.s.o(.rodata); build/asm/main_802ADD78.s.o(.data); }
    .main_802ADD78_bss (NOLOAD) : { build/asm/main_802ADD78.s.o(.bss); }
    .main_802ADD80 0x802ADD80 : AT(0x000AE980) { build/asm/data/main_802ADD80.bin.o(.data); }
    .main_802AEEFC 0x802AEEFC : AT(0x000AFAFC) { FILL(0x00000000); build/asm/main_802AEEFC.s.o(.text); build/asm/main_802AEEFC.s.o(.rodata); build/asm/main_802AEEFC.s.o(.data); }
    .main_802AEEFC_bss (NOLOAD) : { build/asm/main_802AEEFC.s.o(.bss); }
    .main_802AEF14 0x802AEF14 : AT(0x000AFB14) { build/asm/data/main_802AEF14.bin.o(.data); }
    .main_802B29DC 0x802B29DC : AT(0x000B35DC) { FILL(0x00000000); build/asm/main_802B29DC.s.o(.text); build/asm/main_802B29DC.s.o(.rodata); build/asm/main_802B29DC.s.o(.data); }
    .main_802B29DC_bss (NOLOAD) : { build/asm/main_802B29DC.s.o(.bss); }
    .main_802B29F4 0x802B29F4 : AT(0x000B35F4) { build/asm/data/main_802B29F4.bin.o(.data); }
    .main_802B34D8 0x802B34D8 : AT(0x000B40D8) { FILL(0x00000000); build/asm/main_802B34D8.s.o(.text); build/asm/main_802B34D8.s.o(.rodata); build/asm/main_802B34D8.s.o(.data); }
    .main_802B34D8_bss (NOLOAD) : { build/asm/main_802B34D8.s.o(.bss); }
    .main_802B34FC 0x802B34FC : AT(0x000B40FC) { build/asm/data/main_802B34FC.bin.o(.data); }
    .main_802B3B80 0x802B3B80 : AT(0x000B4780) { FILL(0x00000000); build/asm/main_802B3B80.s.o(.text); build/asm/main_802B3B80.s.o(.rodata); build/asm/main_802B3B80.s.o(.data); }
    .main_802B3B80_bss (NOLOAD) : { build/asm/main_802B3B80.s.o(.bss); }
    .main_802B3BD8 0x802B3BD8 : AT(0x000B47D8) { build/asm/data/main_802B3BD8.bin.o(.data); }
    .main_802B712C 0x802B712C : AT(0x000B7D2C) { FILL(0x00000000); build/asm/main_802B712C.s.o(.text); build/asm/main_802B712C.s.o(.rodata); build/asm/main_802B712C.s.o(.data); }
    .main_802B712C_bss (NOLOAD) : { build/asm/main_802B712C.s.o(.bss); }
    .main_802B7168 0x802B7168 : AT(0x000B7D68) { build/asm/data/main_802B7168.bin.o(.data); }
    .main_802B8080 0x802B8080 : AT(0x000B8C80) { FILL(0x00000000); build/asm/main_802B8080.s.o(.text); build/asm/main_802B8080.s.o(.rodata); build/asm/main_802B8080.s.o(.data); }
    .main_802B8080_bss (NOLOAD) : { build/asm/main_802B8080.s.o(.bss); }
    .main_802B8090 0x802B8090 : AT(0x000B8C90) { build/asm/data/main_802B8090.bin.o(.data); }
    .main_802B88F8 0x802B88F8 : AT(0x000B94F8) { FILL(0x00000000); build/asm/main_802B88F8.s.o(.text); build/asm/main_802B88F8.s.o(.rodata); build/asm/main_802B88F8.s.o(.data); }
    .main_802B88F8_bss (NOLOAD) : { build/asm/main_802B88F8.s.o(.bss); }
    .main_802B89B8 0x802B89B8 : AT(0x000B95B8) { build/asm/data/main_802B89B8.bin.o(.data); }
    .main_802BB828 0x802BB828 : AT(0x000BC428) { FILL(0x00000000); build/asm/main_802BB828.s.o(.text); build/asm/main_802BB828.s.o(.rodata); build/asm/main_802BB828.s.o(.data); }
    .main_802BB828_bss (NOLOAD) : { build/asm/main_802BB828.s.o(.bss); }
    .main_802BB868 0x802BB868 : AT(0x000BC468) { build/asm/data/main_802BB868.bin.o(.data); }
    .main_802BDCD0 0x802BDCD0 : AT(0x000BE8D0) { FILL(0x00000000); build/asm/main_802BDCD0.s.o(.text); build/asm/main_802BDCD0.s.o(.rodata); build/asm/main_802BDCD0.s.o(.data); }
    .main_802BDCD0_bss (NOLOAD) : { build/asm/main_802BDCD0.s.o(.bss); }
    .main_802BDD6C 0x802BDD6C : AT(0x000BE96C) { build/asm/data/main_802BDD6C.bin.o(.data); }
    .main_802C211C 0x802C211C : AT(0x000C2D1C) { FILL(0x00000000); build/asm/main_802C211C.s.o(.text); build/asm/main_802C211C.s.o(.rodata); build/asm/main_802C211C.s.o(.data); }
    .main_802C211C_bss (NOLOAD) : { build/asm/main_802C211C.s.o(.bss); }
    .main_802C2154 0x802C2154 : AT(0x000C2D54) { build/asm/data/main_802C2154.bin.o(.data); }
    .main_802C309C 0x802C309C : AT(0x000C3C9C) { FILL(0x00000000); build/asm/main_802C309C.s.o(.text); build/asm/main_802C309C.s.o(.rodata); build/asm/main_802C309C.s.o(.data); }
    .main_802C309C_bss (NOLOAD) : { build/asm/main_802C309C.s.o(.bss); }
    .main_802C3108 0x802C3108 : AT(0x000C3D08) { build/asm/data/main_802C3108.bin.o(.data); }
    .main_802C5DAC 0x802C5DAC : AT(0x000C69AC) { FILL(0x00000000); build/asm/main_802C5DAC.s.o(.text); build/asm/main_802C5DAC.s.o(.rodata); build/asm/main_802C5DAC.s.o(.data); }
    .main_802C5DAC_bss (NOLOAD) : { build/asm/main_802C5DAC.s.o(.bss); }
    .main_802C5E04 0x802C5E04 : AT(0x000C6A04) { build/asm/data/main_802C5E04.bin.o(.data); }
    .main_802C6730 0x802C6730 : AT(0x000C7330) { FILL(0x00000000); build/asm/main_802C6730.s.o(.text); build/asm/main_802C6730.s.o(.rodata); build/asm/main_802C6730.s.o(.data); }
    .main_802C6730_bss (NOLOAD) : { build/asm/main_802C6730.s.o(.bss); }
    .main_802C6AC8 0x802C6AC8 : AT(0x000C76C8) { build/asm/data/main_802C6AC8.bin.o(.data); }
    .main_802C73E4 0x802C73E4 : AT(0x000C7FE4) { FILL(0x00000000); build/asm/main_802C73E4.s.o(.text); build/asm/main_802C73E4.s.o(.rodata); build/asm/main_802C73E4.s.o(.data); }
    .main_802C73E4_bss (NOLOAD) : { build/asm/main_802C73E4.s.o(.bss); }
    .main_802C740C 0x802C740C : AT(0x000C800C) { build/asm/data/main_802C740C.bin.o(.data); }
    .main_802C7470 0x802C7470 : AT(0x000C8070) { FILL(0x00000000); build/asm/main_802C7470.s.o(.text); build/asm/main_802C7470.s.o(.rodata); build/asm/main_802C7470.s.o(.data); }
    .main_802C7470_bss (NOLOAD) : { build/asm/main_802C7470.s.o(.bss); }
    .main_802C7478 0x802C7478 : AT(0x000C8078) { build/asm/data/main_802C7478.bin.o(.data); }
    .main_802CAD7C 0x802CAD7C : AT(0x000CB97C) { FILL(0x00000000); build/asm/main_802CAD7C.s.o(.text); build/asm/main_802CAD7C.s.o(.rodata); build/asm/main_802CAD7C.s.o(.data); }
    .main_802CAD7C_bss (NOLOAD) : { build/asm/main_802CAD7C.s.o(.bss); }
    .main_802CAD88 0x802CAD88 : AT(0x000CB988) { build/asm/data/main_802CAD88.bin.o(.data); }
    .main_802CD8F0 0x802CD8F0 : AT(0x000CE4F0) { FILL(0x00000000); build/asm/main_802CD8F0.s.o(.text); build/asm/main_802CD8F0.s.o(.rodata); build/asm/main_802CD8F0.s.o(.data); }
    .main_802CD8F0_bss (NOLOAD) : { build/asm/main_802CD8F0.s.o(.bss); }
    .main_802CD918 0x802CD918 : AT(0x000CE518) { build/asm/data/main_802CD918.bin.o(.data); }
    .main_802CEE0C 0x802CEE0C : AT(0x000CFA0C) { FILL(0x00000000); build/asm/main_802CEE0C.s.o(.text); build/asm/main_802CEE0C.s.o(.rodata); build/asm/main_802CEE0C.s.o(.data); }
    .main_802CEE0C_bss (NOLOAD) : { build/asm/main_802CEE0C.s.o(.bss); }
    .main_802CEEB0 0x802CEEB0 : AT(0x000CFAB0) { build/asm/data/main_802CEEB0.bin.o(.data); }
    .main_802D05E0 0x802D05E0 : AT(0x000D11E0) { FILL(0x00000000); build/asm/main_802D05E0.s.o(.text); build/asm/main_802D05E0.s.o(.rodata); build/asm/main_802D05E0.s.o(.data); }
    .main_802D05E0_bss (NOLOAD) : { build/asm/main_802D05E0.s.o(.bss); }
    .main_802D0628 0x802D0628 : AT(0x000D1228) { build/asm/data/main_802D0628.bin.o(.data); }
    .main_802D2084 0x802D2084 : AT(0x000D2C84) { FILL(0x00000000); build/asm/main_802D2084.s.o(.text); build/asm/main_802D2084.s.o(.rodata); build/asm/main_802D2084.s.o(.data); }
    .main_802D2084_bss (NOLOAD) : { build/asm/main_802D2084.s.o(.bss); }
    .main_802D208C 0x802D208C : AT(0x000D2C8C) { build/asm/data/main_802D208C.bin.o(.data); }
    .main_802DA870 0x802DA870 : AT(0x000DB470) { FILL(0x00000000); build/asm/main_802DA870.s.o(.text); build/asm/main_802DA870.s.o(.rodata); build/asm/main_802DA870.s.o(.data); }
    .main_802DA870_bss (NOLOAD) : { build/asm/main_802DA870.s.o(.bss); }
    .main_802DA89C 0x802DA89C : AT(0x000DB49C) { build/asm/data/main_802DA89C.bin.o(.data); }
    .main_802DF9B8 0x802DF9B8 : AT(0x000E05B8) { FILL(0x00000000); build/asm/main_802DF9B8.s.o(.text); build/asm/main_802DF9B8.s.o(.rodata); build/asm/main_802DF9B8.s.o(.data); }
    .main_802DF9B8_bss (NOLOAD) : { build/asm/main_802DF9B8.s.o(.bss); }
    .main_802DFA04 0x802DFA04 : AT(0x000E0604) { build/asm/data/main_802DFA04.bin.o(.data); }
    .main_802F6818 0x802F6818 : AT(0x000F7418) { FILL(0x00000000); build/asm/main_802F6818.s.o(.text); build/asm/main_802F6818.s.o(.rodata); build/asm/main_802F6818.s.o(.data); }
    .main_802F6818_bss (NOLOAD) : { build/asm/main_802F6818.s.o(.bss); }
    .main_802F6824 0x802F6824 : AT(0x000F7424) { build/asm/data/main_802F6824.bin.o(.data); }
    .main_802F77C0 0x802F77C0 : AT(0x000F83C0) { FILL(0x00000000); build/asm/main_802F77C0.s.o(.text); build/asm/main_802F77C0.s.o(.rodata); build/asm/main_802F77C0.s.o(.data); }
    .main_802F77C0_bss (NOLOAD) : { build/asm/main_802F77C0.s.o(.bss); }
    .main_802F77D0 0x802F77D0 : AT(0x000F83D0) { build/asm/data/main_802F77D0.bin.o(.data); }
    .main_802F8118 0x802F8118 : AT(0x000F8D18) { FILL(0x00000000); build/asm/main_802F8118.s.o(.text); build/asm/main_802F8118.s.o(.rodata); build/asm/main_802F8118.s.o(.data); }
    .main_802F8118_bss (NOLOAD) : { build/asm/main_802F8118.s.o(.bss); }
    .main_802F816C 0x802F816C : AT(0x000F8D6C) { build/asm/data/main_802F816C.bin.o(.data); }
    .assets 0x80600400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
