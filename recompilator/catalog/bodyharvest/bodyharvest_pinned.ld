SECTIONS
{
    _gp = 0x0;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_800235E4 0x800235E4 : AT(0x000241E4) { FILL(0x00000000); build/asm/main_800235E4.s.o(.text); build/asm/main_800235E4.s.o(.rodata); build/asm/main_800235E4.s.o(.data); }
    .main_800235E4_bss (NOLOAD) : { build/asm/main_800235E4.s.o(.bss); }
    .main_800239B0 0x800239B0 : AT(0x000245B0) { FILL(0x00000000); build/asm/main_800239B0.s.o(.text); build/asm/main_800239B0.s.o(.rodata); build/asm/main_800239B0.s.o(.data); }
    .main_800239B0_bss (NOLOAD) : { build/asm/main_800239B0.s.o(.bss); }
    .main_80036050 0x80036050 : AT(0x00036C50) { FILL(0x00000000); build/asm/main_80036050.s.o(.text); build/asm/main_80036050.s.o(.rodata); build/asm/main_80036050.s.o(.data); }
    .main_80036050_bss (NOLOAD) : { build/asm/main_80036050.s.o(.bss); }
    .main_80036B6C 0x80036B6C : AT(0x0003776C) { FILL(0x00000000); build/asm/main_80036B6C.s.o(.text); build/asm/main_80036B6C.s.o(.rodata); build/asm/main_80036B6C.s.o(.data); }
    .main_80036B6C_bss (NOLOAD) : { build/asm/main_80036B6C.s.o(.bss); }
    .main_8003B45C 0x8003B45C : AT(0x0003C05C) { FILL(0x00000000); build/asm/main_8003B45C.s.o(.text); build/asm/main_8003B45C.s.o(.rodata); build/asm/main_8003B45C.s.o(.data); }
    .main_8003B45C_bss (NOLOAD) : { build/asm/main_8003B45C.s.o(.bss); }
    .main_8003C2DC 0x8003C2DC : AT(0x0003CEDC) { FILL(0x00000000); build/asm/main_8003C2DC.s.o(.text); build/asm/main_8003C2DC.s.o(.rodata); build/asm/main_8003C2DC.s.o(.data); }
    .main_8003C2DC_bss (NOLOAD) : { build/asm/main_8003C2DC.s.o(.bss); }
    .main_8003DB5C 0x8003DB5C : AT(0x0003E75C) { FILL(0x00000000); build/asm/main_8003DB5C.s.o(.text); build/asm/main_8003DB5C.s.o(.rodata); build/asm/main_8003DB5C.s.o(.data); }
    .main_8003DB5C_bss (NOLOAD) : { build/asm/main_8003DB5C.s.o(.bss); }
    .main_8003E138 0x8003E138 : AT(0x0003ED38) { FILL(0x00000000); build/asm/main_8003E138.s.o(.text); build/asm/main_8003E138.s.o(.rodata); build/asm/main_8003E138.s.o(.data); }
    .main_8003E138_bss (NOLOAD) : { build/asm/main_8003E138.s.o(.bss); }
    .main_8003E4EC 0x8003E4EC : AT(0x0003F0EC) { build/asm/data/main_8003E4EC.bin.o(.data); }
    .main_8003E9A4 0x8003E9A4 : AT(0x0003F5A4) { FILL(0x00000000); build/asm/main_8003E9A4.s.o(.text); build/asm/main_8003E9A4.s.o(.rodata); build/asm/main_8003E9A4.s.o(.data); }
    .main_8003E9A4_bss (NOLOAD) : { build/asm/main_8003E9A4.s.o(.bss); }
    .main_8003EACC 0x8003EACC : AT(0x0003F6CC) { build/asm/data/main_8003EACC.bin.o(.data); }
    .main_8003ED70 0x8003ED70 : AT(0x0003F970) { FILL(0x00000000); build/asm/main_8003ED70.s.o(.text); build/asm/main_8003ED70.s.o(.rodata); build/asm/main_8003ED70.s.o(.data); }
    .main_8003ED70_bss (NOLOAD) : { build/asm/main_8003ED70.s.o(.bss); }
    .main_8003F0A0 0x8003F0A0 : AT(0x0003FCA0) { build/asm/data/main_8003F0A0.bin.o(.data); }
    .main_8003F6E8 0x8003F6E8 : AT(0x000402E8) { FILL(0x00000000); build/asm/main_8003F6E8.s.o(.text); build/asm/main_8003F6E8.s.o(.rodata); build/asm/main_8003F6E8.s.o(.data); }
    .main_8003F6E8_bss (NOLOAD) : { build/asm/main_8003F6E8.s.o(.bss); }
    .main_8003FB60 0x8003FB60 : AT(0x00040760) { FILL(0x00000000); build/asm/main_8003FB60.s.o(.text); build/asm/main_8003FB60.s.o(.rodata); build/asm/main_8003FB60.s.o(.data); }
    .main_8003FB60_bss (NOLOAD) : { build/asm/main_8003FB60.s.o(.bss); }
    .main_8003FCF0 0x8003FCF0 : AT(0x000408F0) { FILL(0x00000000); build/asm/main_8003FCF0.s.o(.text); build/asm/main_8003FCF0.s.o(.rodata); build/asm/main_8003FCF0.s.o(.data); }
    .main_8003FCF0_bss (NOLOAD) : { build/asm/main_8003FCF0.s.o(.bss); }
    .main_8003FD6C 0x8003FD6C : AT(0x0004096C) { FILL(0x00000000); build/asm/main_8003FD6C.s.o(.text); build/asm/main_8003FD6C.s.o(.rodata); build/asm/main_8003FD6C.s.o(.data); }
    .main_8003FD6C_bss (NOLOAD) : { build/asm/main_8003FD6C.s.o(.bss); }
    .main_80057C98 0x80057C98 : AT(0x00058898) { FILL(0x00000000); build/asm/main_80057C98.s.o(.text); build/asm/main_80057C98.s.o(.rodata); build/asm/main_80057C98.s.o(.data); }
    .main_80057C98_bss (NOLOAD) : { build/asm/main_80057C98.s.o(.bss); }
    .main_80065BD0 0x80065BD0 : AT(0x000667D0) { build/asm/data/main_80065BD0.bin.o(.data); }
    .main_80066B08 0x80066B08 : AT(0x00067708) { build/asm/data/main_80066B08.bin.o(.data); }
    .main_80066F40 0x80066F40 : AT(0x00067B40) { FILL(0x00000000); build/asm/main_80066F40.s.o(.text); build/asm/main_80066F40.s.o(.rodata); build/asm/main_80066F40.s.o(.data); }
    .main_80066F40_bss (NOLOAD) : { build/asm/main_80066F40.s.o(.bss); }
    .main_80066F88 0x80066F88 : AT(0x00067B88) { build/asm/data/main_80066F88.bin.o(.data); }
    .main_80067338 0x80067338 : AT(0x00067F38) { FILL(0x00000000); build/asm/main_80067338.s.o(.text); build/asm/main_80067338.s.o(.rodata); build/asm/main_80067338.s.o(.data); }
    .main_80067338_bss (NOLOAD) : { build/asm/main_80067338.s.o(.bss); }
    .main_800673E0 0x800673E0 : AT(0x00067FE0) { build/asm/data/main_800673E0.bin.o(.data); }
    .main_80067458 0x80067458 : AT(0x00068058) { FILL(0x00000000); build/asm/main_80067458.s.o(.text); build/asm/main_80067458.s.o(.rodata); build/asm/main_80067458.s.o(.data); }
    .main_80067458_bss (NOLOAD) : { build/asm/main_80067458.s.o(.bss); }
    .main_80067490 0x80067490 : AT(0x00068090) { build/asm/data/main_80067490.bin.o(.data); }
    .main_800674E0 0x800674E0 : AT(0x000680E0) { FILL(0x00000000); build/asm/main_800674E0.s.o(.text); build/asm/main_800674E0.s.o(.rodata); build/asm/main_800674E0.s.o(.data); }
    .main_800674E0_bss (NOLOAD) : { build/asm/main_800674E0.s.o(.bss); }
    .main_80067548 0x80067548 : AT(0x00068148) { build/asm/data/main_80067548.bin.o(.data); }
    .main_8006E5C8 0x8006E5C8 : AT(0x0006F1C8) { FILL(0x00000000); build/asm/main_8006E5C8.s.o(.text); build/asm/main_8006E5C8.s.o(.rodata); build/asm/main_8006E5C8.s.o(.data); }
    .main_8006E5C8_bss (NOLOAD) : { build/asm/main_8006E5C8.s.o(.bss); }
    .main_8006FCE8 0x8006FCE8 : AT(0x000708E8) { FILL(0x00000000); build/asm/main_8006FCE8.s.o(.text); build/asm/main_8006FCE8.s.o(.rodata); build/asm/main_8006FCE8.s.o(.data); }
    .main_8006FCE8_bss (NOLOAD) : { build/asm/main_8006FCE8.s.o(.bss); }
    .main_800710D8 0x800710D8 : AT(0x00071CD8) { build/asm/data/main_800710D8.bin.o(.data); }
    .main_80071148 0x80071148 : AT(0x00071D48) { FILL(0x00000000); build/asm/main_80071148.s.o(.text); build/asm/main_80071148.s.o(.rodata); build/asm/main_80071148.s.o(.data); }
    .main_80071148_bss (NOLOAD) : { build/asm/main_80071148.s.o(.bss); }
    .main_80071228 0x80071228 : AT(0x00071E28) { build/asm/data/main_80071228.bin.o(.data); }
    .main_80071738 0x80071738 : AT(0x00072338) { FILL(0x00000000); build/asm/main_80071738.s.o(.text); build/asm/main_80071738.s.o(.rodata); build/asm/main_80071738.s.o(.data); }
    .main_80071738_bss (NOLOAD) : { build/asm/main_80071738.s.o(.bss); }
    .main_80073A20 0x80073A20 : AT(0x00074620) { FILL(0x00000000); build/asm/main_80073A20.s.o(.text); build/asm/main_80073A20.s.o(.rodata); build/asm/main_80073A20.s.o(.data); }
    .main_80073A20_bss (NOLOAD) : { build/asm/main_80073A20.s.o(.bss); }
    .main_80076208 0x80076208 : AT(0x00076E08) { build/asm/data/main_80076208.bin.o(.data); }
    .main_800762A8 0x800762A8 : AT(0x00076EA8) { FILL(0x00000000); build/asm/main_800762A8.s.o(.text); build/asm/main_800762A8.s.o(.rodata); build/asm/main_800762A8.s.o(.data); }
    .main_800762A8_bss (NOLOAD) : { build/asm/main_800762A8.s.o(.bss); }
    .main_80076C98 0x80076C98 : AT(0x00077898) { build/asm/data/main_80076C98.bin.o(.data); }
    .main_80076FCC 0x80076FCC : AT(0x00077BCC) { FILL(0x00000000); build/asm/main_80076FCC.s.o(.text); build/asm/main_80076FCC.s.o(.rodata); build/asm/main_80076FCC.s.o(.data); }
    .main_80076FCC_bss (NOLOAD) : { build/asm/main_80076FCC.s.o(.bss); }
    .main_80076FE0 0x80076FE0 : AT(0x00077BE0) { build/asm/data/main_80076FE0.bin.o(.data); }
    .main_800770D8 0x800770D8 : AT(0x00077CD8) { FILL(0x00000000); build/asm/main_800770D8.s.o(.text); build/asm/main_800770D8.s.o(.rodata); build/asm/main_800770D8.s.o(.data); }
    .main_800770D8_bss (NOLOAD) : { build/asm/main_800770D8.s.o(.bss); }
    .main_80077344 0x80077344 : AT(0x00077F44) { build/asm/data/main_80077344.bin.o(.data); }
    .main_80077494 0x80077494 : AT(0x00078094) { FILL(0x00000000); build/asm/main_80077494.s.o(.text); build/asm/main_80077494.s.o(.rodata); build/asm/main_80077494.s.o(.data); }
    .main_80077494_bss (NOLOAD) : { build/asm/main_80077494.s.o(.bss); }
    .main_8007764C 0x8007764C : AT(0x0007824C) { build/asm/data/main_8007764C.bin.o(.data); }
    .main_800776BC 0x800776BC : AT(0x000782BC) { FILL(0x00000000); build/asm/main_800776BC.s.o(.text); build/asm/main_800776BC.s.o(.rodata); build/asm/main_800776BC.s.o(.data); }
    .main_800776BC_bss (NOLOAD) : { build/asm/main_800776BC.s.o(.bss); }
    .main_80077CE0 0x80077CE0 : AT(0x000788E0) { build/asm/data/main_80077CE0.bin.o(.data); }
    .main_80077E88 0x80077E88 : AT(0x00078A88) { FILL(0x00000000); build/asm/main_80077E88.s.o(.text); build/asm/main_80077E88.s.o(.rodata); build/asm/main_80077E88.s.o(.data); }
    .main_80077E88_bss (NOLOAD) : { build/asm/main_80077E88.s.o(.bss); }
    .main_800789E4 0x800789E4 : AT(0x000795E4) { build/asm/data/main_800789E4.bin.o(.data); }
    .main_80078BC8 0x80078BC8 : AT(0x000797C8) { FILL(0x00000000); build/asm/main_80078BC8.s.o(.text); build/asm/main_80078BC8.s.o(.rodata); build/asm/main_80078BC8.s.o(.data); }
    .main_80078BC8_bss (NOLOAD) : { build/asm/main_80078BC8.s.o(.bss); }
    .main_800792E0 0x800792E0 : AT(0x00079EE0) { build/asm/data/main_800792E0.bin.o(.data); }
    .main_8007946C 0x8007946C : AT(0x0007A06C) { FILL(0x00000000); build/asm/main_8007946C.s.o(.text); build/asm/main_8007946C.s.o(.rodata); build/asm/main_8007946C.s.o(.data); }
    .main_8007946C_bss (NOLOAD) : { build/asm/main_8007946C.s.o(.bss); }
    .main_8007949C 0x8007949C : AT(0x0007A09C) { build/asm/data/main_8007949C.bin.o(.data); }
    .main_80079910 0x80079910 : AT(0x0007A510) { FILL(0x00000000); build/asm/main_80079910.s.o(.text); build/asm/main_80079910.s.o(.rodata); build/asm/main_80079910.s.o(.data); }
    .main_80079910_bss (NOLOAD) : { build/asm/main_80079910.s.o(.bss); }
    .main_80079C8C 0x80079C8C : AT(0x0007A88C) { build/asm/data/main_80079C8C.bin.o(.data); }
    .main_80079DC0 0x80079DC0 : AT(0x0007A9C0) { FILL(0x00000000); build/asm/main_80079DC0.s.o(.text); build/asm/main_80079DC0.s.o(.rodata); build/asm/main_80079DC0.s.o(.data); }
    .main_80079DC0_bss (NOLOAD) : { build/asm/main_80079DC0.s.o(.bss); }
    .main_8007A38C 0x8007A38C : AT(0x0007AF8C) { build/asm/data/main_8007A38C.bin.o(.data); }
    .main_8007A6B4 0x8007A6B4 : AT(0x0007B2B4) { FILL(0x00000000); build/asm/main_8007A6B4.s.o(.text); build/asm/main_8007A6B4.s.o(.rodata); build/asm/main_8007A6B4.s.o(.data); }
    .main_8007A6B4_bss (NOLOAD) : { build/asm/main_8007A6B4.s.o(.bss); }
    .main_8007A774 0x8007A774 : AT(0x0007B374) { build/asm/data/main_8007A774.bin.o(.data); }
    .main_8007AAEC 0x8007AAEC : AT(0x0007B6EC) { FILL(0x00000000); build/asm/main_8007AAEC.s.o(.text); build/asm/main_8007AAEC.s.o(.rodata); build/asm/main_8007AAEC.s.o(.data); }
    .main_8007AAEC_bss (NOLOAD) : { build/asm/main_8007AAEC.s.o(.bss); }
    .main_8007B370 0x8007B370 : AT(0x0007BF70) { build/asm/data/main_8007B370.bin.o(.data); }
    .main_8007C4BC 0x8007C4BC : AT(0x0007D0BC) { FILL(0x00000000); build/asm/main_8007C4BC.s.o(.text); build/asm/main_8007C4BC.s.o(.rodata); build/asm/main_8007C4BC.s.o(.data); }
    .main_8007C4BC_bss (NOLOAD) : { build/asm/main_8007C4BC.s.o(.bss); }
    .main_8007CB48 0x8007CB48 : AT(0x0007D748) { build/asm/data/main_8007CB48.bin.o(.data); }
    .main_8007CFB4 0x8007CFB4 : AT(0x0007DBB4) { FILL(0x00000000); build/asm/main_8007CFB4.s.o(.text); build/asm/main_8007CFB4.s.o(.rodata); build/asm/main_8007CFB4.s.o(.data); }
    .main_8007CFB4_bss (NOLOAD) : { build/asm/main_8007CFB4.s.o(.bss); }
    .main_8007D424 0x8007D424 : AT(0x0007E024) { build/asm/data/main_8007D424.bin.o(.data); }
    .main_8007D690 0x8007D690 : AT(0x0007E290) { FILL(0x00000000); build/asm/main_8007D690.s.o(.text); build/asm/main_8007D690.s.o(.rodata); build/asm/main_8007D690.s.o(.data); }
    .main_8007D690_bss (NOLOAD) : { build/asm/main_8007D690.s.o(.bss); }
    .main_8007D7E0 0x8007D7E0 : AT(0x0007E3E0) { build/asm/data/main_8007D7E0.bin.o(.data); }
    .main_8007D91C 0x8007D91C : AT(0x0007E51C) { FILL(0x00000000); build/asm/main_8007D91C.s.o(.text); build/asm/main_8007D91C.s.o(.rodata); build/asm/main_8007D91C.s.o(.data); }
    .main_8007D91C_bss (NOLOAD) : { build/asm/main_8007D91C.s.o(.bss); }
    .main_8007E12C 0x8007E12C : AT(0x0007ED2C) { build/asm/data/main_8007E12C.bin.o(.data); }
    .main_8007E608 0x8007E608 : AT(0x0007F208) { FILL(0x00000000); build/asm/main_8007E608.s.o(.text); build/asm/main_8007E608.s.o(.rodata); build/asm/main_8007E608.s.o(.data); }
    .main_8007E608_bss (NOLOAD) : { build/asm/main_8007E608.s.o(.bss); }
    .main_80090C14 0x80090C14 : AT(0x00091814) { FILL(0x00000000); build/asm/main_80090C14.s.o(.text); build/asm/main_80090C14.s.o(.rodata); build/asm/main_80090C14.s.o(.data); }
    .main_80090C14_bss (NOLOAD) : { build/asm/main_80090C14.s.o(.bss); }
    .main_800918E0 0x800918E0 : AT(0x000924E0) { FILL(0x00000000); build/asm/main_800918E0.s.o(.text); build/asm/main_800918E0.s.o(.rodata); build/asm/main_800918E0.s.o(.data); }
    .main_800918E0_bss (NOLOAD) : { build/asm/main_800918E0.s.o(.bss); }
    .main_80092A50 0x80092A50 : AT(0x00093650) { FILL(0x00000000); build/asm/main_80092A50.s.o(.text); build/asm/main_80092A50.s.o(.rodata); build/asm/main_80092A50.s.o(.data); }
    .main_80092A50_bss (NOLOAD) : { build/asm/main_80092A50.s.o(.bss); }
    .main_80092BBC 0x80092BBC : AT(0x000937BC) { FILL(0x00000000); build/asm/main_80092BBC.s.o(.text); build/asm/main_80092BBC.s.o(.rodata); build/asm/main_80092BBC.s.o(.data); }
    .main_80092BBC_bss (NOLOAD) : { build/asm/main_80092BBC.s.o(.bss); }
    .main_8009395C 0x8009395C : AT(0x0009455C) { FILL(0x00000000); build/asm/main_8009395C.s.o(.text); build/asm/main_8009395C.s.o(.rodata); build/asm/main_8009395C.s.o(.data); }
    .main_8009395C_bss (NOLOAD) : { build/asm/main_8009395C.s.o(.bss); }
    .main_800946CC 0x800946CC : AT(0x000952CC) { FILL(0x00000000); build/asm/main_800946CC.s.o(.text); build/asm/main_800946CC.s.o(.rodata); build/asm/main_800946CC.s.o(.data); }
    .main_800946CC_bss (NOLOAD) : { build/asm/main_800946CC.s.o(.bss); }
    .main_80094808 0x80094808 : AT(0x00095408) { FILL(0x00000000); build/asm/main_80094808.s.o(.text); build/asm/main_80094808.s.o(.rodata); build/asm/main_80094808.s.o(.data); }
    .main_80094808_bss (NOLOAD) : { build/asm/main_80094808.s.o(.bss); }
    .main_80094AA0 0x80094AA0 : AT(0x000956A0) { FILL(0x00000000); build/asm/main_80094AA0.s.o(.text); build/asm/main_80094AA0.s.o(.rodata); build/asm/main_80094AA0.s.o(.data); }
    .main_80094AA0_bss (NOLOAD) : { build/asm/main_80094AA0.s.o(.bss); }
    .main_80094B80 0x80094B80 : AT(0x00095780) { FILL(0x00000000); build/asm/main_80094B80.s.o(.text); build/asm/main_80094B80.s.o(.rodata); build/asm/main_80094B80.s.o(.data); }
    .main_80094B80_bss (NOLOAD) : { build/asm/main_80094B80.s.o(.bss); }
    .main_80095100 0x80095100 : AT(0x00095D00) { FILL(0x00000000); build/asm/main_80095100.s.o(.text); build/asm/main_80095100.s.o(.rodata); build/asm/main_80095100.s.o(.data); }
    .main_80095100_bss (NOLOAD) : { build/asm/main_80095100.s.o(.bss); }
    .main_800959DC 0x800959DC : AT(0x000965DC) { FILL(0x00000000); build/asm/main_800959DC.s.o(.text); build/asm/main_800959DC.s.o(.rodata); build/asm/main_800959DC.s.o(.data); }
    .main_800959DC_bss (NOLOAD) : { build/asm/main_800959DC.s.o(.bss); }
    .main_80095F08 0x80095F08 : AT(0x00096B08) { FILL(0x00000000); build/asm/main_80095F08.s.o(.text); build/asm/main_80095F08.s.o(.rodata); build/asm/main_80095F08.s.o(.data); }
    .main_80095F08_bss (NOLOAD) : { build/asm/main_80095F08.s.o(.bss); }
    .main_800966EC 0x800966EC : AT(0x000972EC) { FILL(0x00000000); build/asm/main_800966EC.s.o(.text); build/asm/main_800966EC.s.o(.rodata); build/asm/main_800966EC.s.o(.data); }
    .main_800966EC_bss (NOLOAD) : { build/asm/main_800966EC.s.o(.bss); }
    .main_8009BAC0 0x8009BAC0 : AT(0x0009C6C0) { FILL(0x00000000); build/asm/main_8009BAC0.s.o(.text); build/asm/main_8009BAC0.s.o(.rodata); build/asm/main_8009BAC0.s.o(.data); }
    .main_8009BAC0_bss (NOLOAD) : { build/asm/main_8009BAC0.s.o(.bss); }
    .main_800A5A10 0x800A5A10 : AT(0x000A6610) { FILL(0x00000000); build/asm/main_800A5A10.s.o(.text); build/asm/main_800A5A10.s.o(.rodata); build/asm/main_800A5A10.s.o(.data); }
    .main_800A5A10_bss (NOLOAD) : { build/asm/main_800A5A10.s.o(.bss); }
    .main_800A931C 0x800A931C : AT(0x000A9F1C) { FILL(0x00000000); build/asm/main_800A931C.s.o(.text); build/asm/main_800A931C.s.o(.rodata); build/asm/main_800A931C.s.o(.data); }
    .main_800A931C_bss (NOLOAD) : { build/asm/main_800A931C.s.o(.bss); }
    .main_800AB32C 0x800AB32C : AT(0x000ABF2C) { FILL(0x00000000); build/asm/main_800AB32C.s.o(.text); build/asm/main_800AB32C.s.o(.rodata); build/asm/main_800AB32C.s.o(.data); }
    .main_800AB32C_bss (NOLOAD) : { build/asm/main_800AB32C.s.o(.bss); }
    .main_800AC198 0x800AC198 : AT(0x000ACD98) { FILL(0x00000000); build/asm/main_800AC198.s.o(.text); build/asm/main_800AC198.s.o(.rodata); build/asm/main_800AC198.s.o(.data); }
    .main_800AC198_bss (NOLOAD) : { build/asm/main_800AC198.s.o(.bss); }
    .main_800ACA3C 0x800ACA3C : AT(0x000AD63C) { FILL(0x00000000); build/asm/main_800ACA3C.s.o(.text); build/asm/main_800ACA3C.s.o(.rodata); build/asm/main_800ACA3C.s.o(.data); }
    .main_800ACA3C_bss (NOLOAD) : { build/asm/main_800ACA3C.s.o(.bss); }
    .main_800AD814 0x800AD814 : AT(0x000AE414) { FILL(0x00000000); build/asm/main_800AD814.s.o(.text); build/asm/main_800AD814.s.o(.rodata); build/asm/main_800AD814.s.o(.data); }
    .main_800AD814_bss (NOLOAD) : { build/asm/main_800AD814.s.o(.bss); }
    .main_800AE190 0x800AE190 : AT(0x000AED90) { FILL(0x00000000); build/asm/main_800AE190.s.o(.text); build/asm/main_800AE190.s.o(.rodata); build/asm/main_800AE190.s.o(.data); }
    .main_800AE190_bss (NOLOAD) : { build/asm/main_800AE190.s.o(.bss); }
    .main_800AE1C0 0x800AE1C0 : AT(0x000AEDC0) { FILL(0x00000000); build/asm/main_800AE1C0.s.o(.text); build/asm/main_800AE1C0.s.o(.rodata); build/asm/main_800AE1C0.s.o(.data); }
    .main_800AE1C0_bss (NOLOAD) : { build/asm/main_800AE1C0.s.o(.bss); }
    .main_800AE2C0 0x800AE2C0 : AT(0x000AEEC0) { FILL(0x00000000); build/asm/main_800AE2C0.s.o(.text); build/asm/main_800AE2C0.s.o(.rodata); build/asm/main_800AE2C0.s.o(.data); }
    .main_800AE2C0_bss (NOLOAD) : { build/asm/main_800AE2C0.s.o(.bss); }
    .main_800AE3AC 0x800AE3AC : AT(0x000AEFAC) { FILL(0x00000000); build/asm/main_800AE3AC.s.o(.text); build/asm/main_800AE3AC.s.o(.rodata); build/asm/main_800AE3AC.s.o(.data); }
    .main_800AE3AC_bss (NOLOAD) : { build/asm/main_800AE3AC.s.o(.bss); }
    .main_800AE454 0x800AE454 : AT(0x000AF054) { FILL(0x00000000); build/asm/main_800AE454.s.o(.text); build/asm/main_800AE454.s.o(.rodata); build/asm/main_800AE454.s.o(.data); }
    .main_800AE454_bss (NOLOAD) : { build/asm/main_800AE454.s.o(.bss); }
    .main_800AE588 0x800AE588 : AT(0x000AF188) { FILL(0x00000000); build/asm/main_800AE588.s.o(.text); build/asm/main_800AE588.s.o(.rodata); build/asm/main_800AE588.s.o(.data); }
    .main_800AE588_bss (NOLOAD) : { build/asm/main_800AE588.s.o(.bss); }
    .main_800AE6CC 0x800AE6CC : AT(0x000AF2CC) { FILL(0x00000000); build/asm/main_800AE6CC.s.o(.text); build/asm/main_800AE6CC.s.o(.rodata); build/asm/main_800AE6CC.s.o(.data); }
    .main_800AE6CC_bss (NOLOAD) : { build/asm/main_800AE6CC.s.o(.bss); }
    .main_800AEE5C 0x800AEE5C : AT(0x000AFA5C) { FILL(0x00000000); build/asm/main_800AEE5C.s.o(.text); build/asm/main_800AEE5C.s.o(.rodata); build/asm/main_800AEE5C.s.o(.data); }
    .main_800AEE5C_bss (NOLOAD) : { build/asm/main_800AEE5C.s.o(.bss); }
    .main_800AFB38 0x800AFB38 : AT(0x000B0738) { FILL(0x00000000); build/asm/main_800AFB38.s.o(.text); build/asm/main_800AFB38.s.o(.rodata); build/asm/main_800AFB38.s.o(.data); }
    .main_800AFB38_bss (NOLOAD) : { build/asm/main_800AFB38.s.o(.bss); }
    .main_800AFF9C 0x800AFF9C : AT(0x000B0B9C) { FILL(0x00000000); build/asm/main_800AFF9C.s.o(.text); build/asm/main_800AFF9C.s.o(.rodata); build/asm/main_800AFF9C.s.o(.data); }
    .main_800AFF9C_bss (NOLOAD) : { build/asm/main_800AFF9C.s.o(.bss); }
    .main_800B034C 0x800B034C : AT(0x000B0F4C) { FILL(0x00000000); build/asm/main_800B034C.s.o(.text); build/asm/main_800B034C.s.o(.rodata); build/asm/main_800B034C.s.o(.data); }
    .main_800B034C_bss (NOLOAD) : { build/asm/main_800B034C.s.o(.bss); }
    .main_800C0E80 0x800C0E80 : AT(0x000C1A80) { FILL(0x00000000); build/asm/main_800C0E80.s.o(.text); build/asm/main_800C0E80.s.o(.rodata); build/asm/main_800C0E80.s.o(.data); }
    .main_800C0E80_bss (NOLOAD) : { build/asm/main_800C0E80.s.o(.bss); }
    .main_800D6EAC 0x800D6EAC : AT(0x000D7AAC) { FILL(0x00000000); build/asm/main_800D6EAC.s.o(.text); build/asm/main_800D6EAC.s.o(.rodata); build/asm/main_800D6EAC.s.o(.data); }
    .main_800D6EAC_bss (NOLOAD) : { build/asm/main_800D6EAC.s.o(.bss); }
    .main_800D7790 0x800D7790 : AT(0x000D8390) { FILL(0x00000000); build/asm/main_800D7790.s.o(.text); build/asm/main_800D7790.s.o(.rodata); build/asm/main_800D7790.s.o(.data); }
    .main_800D7790_bss (NOLOAD) : { build/asm/main_800D7790.s.o(.bss); }
    .main_800D80B4 0x800D80B4 : AT(0x000D8CB4) { FILL(0x00000000); build/asm/main_800D80B4.s.o(.text); build/asm/main_800D80B4.s.o(.rodata); build/asm/main_800D80B4.s.o(.data); }
    .main_800D80B4_bss (NOLOAD) : { build/asm/main_800D80B4.s.o(.bss); }
    .main_800D8FA0 0x800D8FA0 : AT(0x000D9BA0) { FILL(0x00000000); build/asm/main_800D8FA0.s.o(.text); build/asm/main_800D8FA0.s.o(.rodata); build/asm/main_800D8FA0.s.o(.data); }
    .main_800D8FA0_bss (NOLOAD) : { build/asm/main_800D8FA0.s.o(.bss); }
    .main_800DA6F0 0x800DA6F0 : AT(0x000DB2F0) { FILL(0x00000000); build/asm/main_800DA6F0.s.o(.text); build/asm/main_800DA6F0.s.o(.rodata); build/asm/main_800DA6F0.s.o(.data); }
    .main_800DA6F0_bss (NOLOAD) : { build/asm/main_800DA6F0.s.o(.bss); }
    .main_800DE150 0x800DE150 : AT(0x000DED50) { FILL(0x00000000); build/asm/main_800DE150.s.o(.text); build/asm/main_800DE150.s.o(.rodata); build/asm/main_800DE150.s.o(.data); }
    .main_800DE150_bss (NOLOAD) : { build/asm/main_800DE150.s.o(.bss); }
    .main_800DE9B8 0x800DE9B8 : AT(0x000DF5B8) { FILL(0x00000000); build/asm/main_800DE9B8.s.o(.text); build/asm/main_800DE9B8.s.o(.rodata); build/asm/main_800DE9B8.s.o(.data); }
    .main_800DE9B8_bss (NOLOAD) : { build/asm/main_800DE9B8.s.o(.bss); }
    .main_800E2668 0x800E2668 : AT(0x000E3268) { FILL(0x00000000); build/asm/main_800E2668.s.o(.text); build/asm/main_800E2668.s.o(.rodata); build/asm/main_800E2668.s.o(.data); }
    .main_800E2668_bss (NOLOAD) : { build/asm/main_800E2668.s.o(.bss); }
    .main_800F2890 0x800F2890 : AT(0x000F3490) { FILL(0x00000000); build/asm/main_800F2890.s.o(.text); build/asm/main_800F2890.s.o(.rodata); build/asm/main_800F2890.s.o(.data); }
    .main_800F2890_bss (NOLOAD) : { build/asm/main_800F2890.s.o(.bss); }
    .main_800F9F00 0x800F9F00 : AT(0x000FAB00) { FILL(0x00000000); build/asm/main_800F9F00.s.o(.text); build/asm/main_800F9F00.s.o(.rodata); build/asm/main_800F9F00.s.o(.data); }
    .main_800F9F00_bss (NOLOAD) : { build/asm/main_800F9F00.s.o(.bss); }
    .assets 0x80400000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
