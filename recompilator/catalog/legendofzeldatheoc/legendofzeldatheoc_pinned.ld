SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80000400 0x80000400 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80000400.s.o(.text); build/asm/main_80000400.s.o(.rodata); build/asm/main_80000400.s.o(.data); }
    .main_80000400_bss (NOLOAD) : { build/asm/main_80000400.s.o(.bss); }
    .main_80001564 0x80001564 : AT(0x00002164) { FILL(0x00000000); build/asm/main_80001564.s.o(.text); build/asm/main_80001564.s.o(.rodata); build/asm/main_80001564.s.o(.data); }
    .main_80001564_bss (NOLOAD) : { build/asm/main_80001564.s.o(.bss); }
    .main_80002964 0x80002964 : AT(0x00003564) { FILL(0x00000000); build/asm/main_80002964.s.o(.text); build/asm/main_80002964.s.o(.rodata); build/asm/main_80002964.s.o(.data); }
    .main_80002964_bss (NOLOAD) : { build/asm/main_80002964.s.o(.bss); }
    .main_80002D30 0x80002D30 : AT(0x00003930) { FILL(0x00000000); build/asm/main_80002D30.s.o(.text); build/asm/main_80002D30.s.o(.rodata); build/asm/main_80002D30.s.o(.data); }
    .main_80002D30_bss (NOLOAD) : { build/asm/main_80002D30.s.o(.bss); }
    .main_80003B60 0x80003B60 : AT(0x00004760) { FILL(0x00000000); build/asm/main_80003B60.s.o(.text); build/asm/main_80003B60.s.o(.rodata); build/asm/main_80003B60.s.o(.data); }
    .main_80003B60_bss (NOLOAD) : { build/asm/main_80003B60.s.o(.bss); }
    .main_800048C0 0x800048C0 : AT(0x000054C0) { FILL(0x00000000); build/asm/main_800048C0.s.o(.text); build/asm/main_800048C0.s.o(.rodata); build/asm/main_800048C0.s.o(.data); }
    .main_800048C0_bss (NOLOAD) : { build/asm/main_800048C0.s.o(.bss); }
    .main_80005EB0 0x80005EB0 : AT(0x00006AB0) { FILL(0x00000000); build/asm/main_80005EB0.s.o(.text); build/asm/main_80005EB0.s.o(.rodata); build/asm/main_80005EB0.s.o(.data); }
    .main_80005EB0_bss (NOLOAD) : { build/asm/main_80005EB0.s.o(.bss); }
    .main_80007000 0x80007000 : AT(0x00007C00) { FILL(0x00000000); build/asm/main_80007000.s.o(.text); build/asm/main_80007000.s.o(.rodata); build/asm/main_80007000.s.o(.data); }
    .main_80007000_bss (NOLOAD) : { build/asm/main_80007000.s.o(.bss); }
    .main_80008FF4 0x80008FF4 : AT(0x00009BF4) { FILL(0x00000000); build/asm/main_80008FF4.s.o(.text); build/asm/main_80008FF4.s.o(.rodata); build/asm/main_80008FF4.s.o(.data); }
    .main_80008FF4_bss (NOLOAD) : { build/asm/main_80008FF4.s.o(.bss); }
    .main_8000C248 0x8000C248 : AT(0x0000CE48) { FILL(0x00000000); build/asm/main_8000C248.s.o(.text); build/asm/main_8000C248.s.o(.rodata); build/asm/main_8000C248.s.o(.data); }
    .main_8000C248_bss (NOLOAD) : { build/asm/main_8000C248.s.o(.bss); }
    .main_8000C314 0x8000C314 : AT(0x0000CF14) { build/asm/data/main_8000C314.bin.o(.data); }
    .main_800118B0 0x800118B0 : AT(0x000124B0) { build/asm/data/main_800118B0.bin.o(.data); }
    .main_80018BF4 0x80018BF4 : AT(0x000197F4) { build/asm/data/main_80018BF4.bin.o(.data); }
    .main_80018C34 0x80018C34 : AT(0x00019834) { build/asm/data/main_80018C34.bin.o(.data); }
    .main_8001E0FC 0x8001E0FC : AT(0x0001ECFC) { build/asm/data/main_8001E0FC.bin.o(.data); }
    .main_8001E128 0x8001E128 : AT(0x0001ED28) { build/asm/data/main_8001E128.bin.o(.data); }
    .main_80021C04 0x80021C04 : AT(0x00022804) { build/asm/data/main_80021C04.bin.o(.data); }
    .main_80021C08 0x80021C08 : AT(0x00022808) { build/asm/data/main_80021C08.bin.o(.data); }
    .main_80027774 0x80027774 : AT(0x00028374) { build/asm/data/main_80027774.bin.o(.data); }
    .main_80028BD8 0x80028BD8 : AT(0x000297D8) { build/asm/data/main_80028BD8.bin.o(.data); }
    .main_8002940C 0x8002940C : AT(0x0002A00C) { build/asm/data/main_8002940C.bin.o(.data); }
    .main_80029470 0x80029470 : AT(0x0002A070) { build/asm/data/main_80029470.bin.o(.data); }
    .main_8002A840 0x8002A840 : AT(0x0002B440) { build/asm/data/main_8002A840.bin.o(.data); }
    .main_8002A864 0x8002A864 : AT(0x0002B464) { build/asm/data/main_8002A864.bin.o(.data); }
    .main_8002C0C0 0x8002C0C0 : AT(0x0002CCC0) { build/asm/data/main_8002C0C0.bin.o(.data); }
    .main_8002C124 0x8002C124 : AT(0x0002CD24) { build/asm/data/main_8002C124.bin.o(.data); }
    .main_8002C784 0x8002C784 : AT(0x0002D384) { build/asm/data/main_8002C784.bin.o(.data); }
    .main_8002C7E8 0x8002C7E8 : AT(0x0002D3E8) { build/asm/data/main_8002C7E8.bin.o(.data); }
    .main_80031344 0x80031344 : AT(0x00031F44) { build/asm/data/main_80031344.bin.o(.data); }
    .main_80031DE8 0x80031DE8 : AT(0x000329E8) { build/asm/data/main_80031DE8.bin.o(.data); }
    .main_80040A58 0x80040A58 : AT(0x00041658) { build/asm/data/main_80040A58.bin.o(.data); }
    .main_80040A60 0x80040A60 : AT(0x00041660) { build/asm/data/main_80040A60.bin.o(.data); }
    .main_800497DC 0x800497DC : AT(0x0004A3DC) { build/asm/data/main_800497DC.bin.o(.data); }
    .main_80049860 0x80049860 : AT(0x0004A460) { build/asm/data/main_80049860.bin.o(.data); }
    .main_8004ABD0 0x8004ABD0 : AT(0x0004B7D0) { build/asm/data/main_8004ABD0.bin.o(.data); }
    .main_8004AEB8 0x8004AEB8 : AT(0x0004BAB8) { build/asm/data/main_8004AEB8.bin.o(.data); }
    .main_8004B200 0x8004B200 : AT(0x0004BE00) { build/asm/data/main_8004B200.bin.o(.data); }
    .main_8004B2F4 0x8004B2F4 : AT(0x0004BEF4) { build/asm/data/main_8004B2F4.bin.o(.data); }
    .main_8004C1E8 0x8004C1E8 : AT(0x0004CDE8) { build/asm/data/main_8004C1E8.bin.o(.data); }
    .main_8004C2BC 0x8004C2BC : AT(0x0004CEBC) { build/asm/data/main_8004C2BC.bin.o(.data); }
    .main_8004CB44 0x8004CB44 : AT(0x0004D744) { build/asm/data/main_8004CB44.bin.o(.data); }
    .main_8004CC44 0x8004CC44 : AT(0x0004D844) { build/asm/data/main_8004CC44.bin.o(.data); }
    .main_8004F1DC 0x8004F1DC : AT(0x0004FDDC) { build/asm/data/main_8004F1DC.bin.o(.data); }
    .main_8004F2B0 0x8004F2B0 : AT(0x0004FEB0) { build/asm/data/main_8004F2B0.bin.o(.data); }
    .main_80055C4C 0x80055C4C : AT(0x0005684C) { build/asm/data/main_80055C4C.bin.o(.data); }
    .main_80055C54 0x80055C54 : AT(0x00056854) { build/asm/data/main_80055C54.bin.o(.data); }
    .main_8005823C 0x8005823C : AT(0x00058E3C) { build/asm/data/main_8005823C.bin.o(.data); }
    .main_8005849C 0x8005849C : AT(0x0005909C) { build/asm/data/main_8005849C.bin.o(.data); }
    .main_800587F8 0x800587F8 : AT(0x000593F8) { build/asm/data/main_800587F8.bin.o(.data); }
    .main_80058858 0x80058858 : AT(0x00059458) { build/asm/data/main_80058858.bin.o(.data); }
    .main_80058B2C 0x80058B2C : AT(0x0005972C) { build/asm/data/main_80058B2C.bin.o(.data); }
    .main_80058B38 0x80058B38 : AT(0x00059738) { build/asm/data/main_80058B38.bin.o(.data); }
    .main_80059D60 0x80059D60 : AT(0x0005A960) { build/asm/data/main_80059D60.bin.o(.data); }
    .main_80059E58 0x80059E58 : AT(0x0005AA58) { build/asm/data/main_80059E58.bin.o(.data); }
    .main_8006CAA4 0x8006CAA4 : AT(0x0006D6A4) { build/asm/data/main_8006CAA4.bin.o(.data); }
    .main_8006CAE0 0x8006CAE0 : AT(0x0006D6E0) { build/asm/data/main_8006CAE0.bin.o(.data); }
    .main_80074C10 0x80074C10 : AT(0x00075810) { build/asm/data/main_80074C10.bin.o(.data); }
    .main_80074C3C 0x80074C3C : AT(0x0007583C) { build/asm/data/main_80074C3C.bin.o(.data); }
    .main_80076C10 0x80076C10 : AT(0x00077810) { build/asm/data/main_80076C10.bin.o(.data); }
    .main_80076C1C 0x80076C1C : AT(0x0007781C) { build/asm/data/main_80076C1C.bin.o(.data); }
    .main_8009434C 0x8009434C : AT(0x00094F4C) { build/asm/data/main_8009434C.bin.o(.data); }
    .main_8009436C 0x8009436C : AT(0x00094F6C) { build/asm/data/main_8009436C.bin.o(.data); }
    .main_8009AF08 0x8009AF08 : AT(0x0009BB08) { build/asm/data/main_8009AF08.bin.o(.data); }
    .main_8009B010 0x8009B010 : AT(0x0009BC10) { build/asm/data/main_8009B010.bin.o(.data); }
    .main_800AB3B4 0x800AB3B4 : AT(0x000ABFB4) { build/asm/data/main_800AB3B4.bin.o(.data); }
    .main_800AB3D8 0x800AB3D8 : AT(0x000ABFD8) { build/asm/data/main_800AB3D8.bin.o(.data); }
    .main_800AC5AC 0x800AC5AC : AT(0x000AD1AC) { build/asm/data/main_800AC5AC.bin.o(.data); }
    .main_800AC5CC 0x800AC5CC : AT(0x000AD1CC) { build/asm/data/main_800AC5CC.bin.o(.data); }
    .main_800B4630 0x800B4630 : AT(0x000B5230) { build/asm/data/main_800B4630.bin.o(.data); }
    .main_800B4644 0x800B4644 : AT(0x000B5244) { build/asm/data/main_800B4644.bin.o(.data); }
    .main_800B80B8 0x800B80B8 : AT(0x000B8CB8) { build/asm/data/main_800B80B8.bin.o(.data); }
    .main_800B80CC 0x800B80CC : AT(0x000B8CCC) { build/asm/data/main_800B80CC.bin.o(.data); }
    .main_800BADA0 0x800BADA0 : AT(0x000BB9A0) { build/asm/data/main_800BADA0.bin.o(.data); }
    .main_800BADB8 0x800BADB8 : AT(0x000BB9B8) { build/asm/data/main_800BADB8.bin.o(.data); }
    .main_800C0074 0x800C0074 : AT(0x000C0C74) { build/asm/data/main_800C0074.bin.o(.data); }
    .main_800C0090 0x800C0090 : AT(0x000C0C90) { build/asm/data/main_800C0090.bin.o(.data); }
    .main_800C0C4C 0x800C0C4C : AT(0x000C184C) { build/asm/data/main_800C0C4C.bin.o(.data); }
    .main_800C0C6C 0x800C0C6C : AT(0x000C186C) { build/asm/data/main_800C0C6C.bin.o(.data); }
    .main_800C6A74 0x800C6A74 : AT(0x000C7674) { build/asm/data/main_800C6A74.bin.o(.data); }
    .main_800C6AA0 0x800C6AA0 : AT(0x000C76A0) { build/asm/data/main_800C6AA0.bin.o(.data); }
    .main_800C7880 0x800C7880 : AT(0x000C8480) { build/asm/data/main_800C7880.bin.o(.data); }
    .main_800C7884 0x800C7884 : AT(0x000C8484) { build/asm/data/main_800C7884.bin.o(.data); }
    .main_800CB734 0x800CB734 : AT(0x000CC334) { build/asm/data/main_800CB734.bin.o(.data); }
    .main_800CB76C 0x800CB76C : AT(0x000CC36C) { build/asm/data/main_800CB76C.bin.o(.data); }
    .main_800CD13C 0x800CD13C : AT(0x000CDD3C) { build/asm/data/main_800CD13C.bin.o(.data); }
    .main_800CD190 0x800CD190 : AT(0x000CDD90) { build/asm/data/main_800CD190.bin.o(.data); }
    .main_800F9698 0x800F9698 : AT(0x000FA298) { FILL(0x00000000); build/asm/main_800F9698.s.o(.text); build/asm/main_800F9698.s.o(.rodata); build/asm/main_800F9698.s.o(.data); }
    .main_800F9698_bss (NOLOAD) : { build/asm/main_800F9698.s.o(.bss); }
    .main_800F9850 0x800F9850 : AT(0x000FA450) { build/asm/data/main_800F9850.bin.o(.data); }
    .assets 0x80400400 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
