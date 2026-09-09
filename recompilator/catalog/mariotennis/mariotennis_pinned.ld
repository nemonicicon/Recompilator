SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80300000 0x80300000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80300000.s.o(.text); build/asm/main_80300000.s.o(.rodata); build/asm/main_80300000.s.o(.data); }
    .main_80300000_bss (NOLOAD) : { build/asm/main_80300000.s.o(.bss); }
    .main_80300080 0x80300080 : AT(0x00001080) { FILL(0x00000000); build/asm/main_80300080.s.o(.text); build/asm/main_80300080.s.o(.rodata); build/asm/main_80300080.s.o(.data); }
    .main_80300080_bss (NOLOAD) : { build/asm/main_80300080.s.o(.bss); }
    .main_803002D0 0x803002D0 : AT(0x000012D0) { FILL(0x00000000); build/asm/main_803002D0.s.o(.text); build/asm/main_803002D0.s.o(.rodata); build/asm/main_803002D0.s.o(.data); }
    .main_803002D0_bss (NOLOAD) : { build/asm/main_803002D0.s.o(.bss); }
    .main_803007E8 0x803007E8 : AT(0x000017E8) { build/asm/data/main_803007E8.bin.o(.data); }
    .main_80303018 0x80303018 : AT(0x00004018) { FILL(0x00000000); build/asm/main_80303018.s.o(.text); build/asm/main_80303018.s.o(.rodata); build/asm/main_80303018.s.o(.data); }
    .main_80303018_bss (NOLOAD) : { build/asm/main_80303018.s.o(.bss); }
    .main_8030301C 0x8030301C : AT(0x0000401C) { build/asm/data/main_8030301C.bin.o(.data); }
    .main_80303238 0x80303238 : AT(0x00004238) { FILL(0x00000000); build/asm/main_80303238.s.o(.text); build/asm/main_80303238.s.o(.rodata); build/asm/main_80303238.s.o(.data); }
    .main_80303238_bss (NOLOAD) : { build/asm/main_80303238.s.o(.bss); }
    .main_8030324C 0x8030324C : AT(0x0000424C) { build/asm/data/main_8030324C.bin.o(.data); }
    .main_80309EE4 0x80309EE4 : AT(0x0000AEE4) { FILL(0x00000000); build/asm/main_80309EE4.s.o(.text); build/asm/main_80309EE4.s.o(.rodata); build/asm/main_80309EE4.s.o(.data); }
    .main_80309EE4_bss (NOLOAD) : { build/asm/main_80309EE4.s.o(.bss); }
    .main_80309EFC 0x80309EFC : AT(0x0000AEFC) { build/asm/data/main_80309EFC.bin.o(.data); }
    .main_8030A6A8 0x8030A6A8 : AT(0x0000B6A8) { FILL(0x00000000); build/asm/main_8030A6A8.s.o(.text); build/asm/main_8030A6A8.s.o(.rodata); build/asm/main_8030A6A8.s.o(.data); }
    .main_8030A6A8_bss (NOLOAD) : { build/asm/main_8030A6A8.s.o(.bss); }
    .main_8030A6B4 0x8030A6B4 : AT(0x0000B6B4) { build/asm/data/main_8030A6B4.bin.o(.data); }
    .main_8030C69C 0x8030C69C : AT(0x0000D69C) { FILL(0x00000000); build/asm/main_8030C69C.s.o(.text); build/asm/main_8030C69C.s.o(.rodata); build/asm/main_8030C69C.s.o(.data); }
    .main_8030C69C_bss (NOLOAD) : { build/asm/main_8030C69C.s.o(.bss); }
    .main_8030C780 0x8030C780 : AT(0x0000D780) { build/asm/data/main_8030C780.bin.o(.data); }
    .main_8030CD84 0x8030CD84 : AT(0x0000DD84) { FILL(0x00000000); build/asm/main_8030CD84.s.o(.text); build/asm/main_8030CD84.s.o(.rodata); build/asm/main_8030CD84.s.o(.data); }
    .main_8030CD84_bss (NOLOAD) : { build/asm/main_8030CD84.s.o(.bss); }
    .main_8030CE44 0x8030CE44 : AT(0x0000DE44) { build/asm/data/main_8030CE44.bin.o(.data); }
    .main_8030F5DC 0x8030F5DC : AT(0x000105DC) { FILL(0x00000000); build/asm/main_8030F5DC.s.o(.text); build/asm/main_8030F5DC.s.o(.rodata); build/asm/main_8030F5DC.s.o(.data); }
    .main_8030F5DC_bss (NOLOAD) : { build/asm/main_8030F5DC.s.o(.bss); }
    .main_8030F708 0x8030F708 : AT(0x00010708) { build/asm/data/main_8030F708.bin.o(.data); }
    .main_8030FB04 0x8030FB04 : AT(0x00010B04) { FILL(0x00000000); build/asm/main_8030FB04.s.o(.text); build/asm/main_8030FB04.s.o(.rodata); build/asm/main_8030FB04.s.o(.data); }
    .main_8030FB04_bss (NOLOAD) : { build/asm/main_8030FB04.s.o(.bss); }
    .main_8030FB94 0x8030FB94 : AT(0x00010B94) { build/asm/data/main_8030FB94.bin.o(.data); }
    .main_8030FEDC 0x8030FEDC : AT(0x00010EDC) { FILL(0x00000000); build/asm/main_8030FEDC.s.o(.text); build/asm/main_8030FEDC.s.o(.rodata); build/asm/main_8030FEDC.s.o(.data); }
    .main_8030FEDC_bss (NOLOAD) : { build/asm/main_8030FEDC.s.o(.bss); }
    .main_80310000 0x80310000 : AT(0x00011000) { build/asm/data/main_80310000.bin.o(.data); }
    .main_803106CC 0x803106CC : AT(0x000116CC) { FILL(0x00000000); build/asm/main_803106CC.s.o(.text); build/asm/main_803106CC.s.o(.rodata); build/asm/main_803106CC.s.o(.data); }
    .main_803106CC_bss (NOLOAD) : { build/asm/main_803106CC.s.o(.bss); }
    .main_80314434 0x80314434 : AT(0x00015434) { build/asm/data/main_80314434.bin.o(.data); }
    .main_803158D4 0x803158D4 : AT(0x000168D4) { FILL(0x00000000); build/asm/main_803158D4.s.o(.text); build/asm/main_803158D4.s.o(.rodata); build/asm/main_803158D4.s.o(.data); }
    .main_803158D4_bss (NOLOAD) : { build/asm/main_803158D4.s.o(.bss); }
    .main_80315914 0x80315914 : AT(0x00016914) { build/asm/data/main_80315914.bin.o(.data); }
    .main_803163E8 0x803163E8 : AT(0x000173E8) { FILL(0x00000000); build/asm/main_803163E8.s.o(.text); build/asm/main_803163E8.s.o(.rodata); build/asm/main_803163E8.s.o(.data); }
    .main_803163E8_bss (NOLOAD) : { build/asm/main_803163E8.s.o(.bss); }
    .main_803165A8 0x803165A8 : AT(0x000175A8) { build/asm/data/main_803165A8.bin.o(.data); }
    .main_803167A0 0x803167A0 : AT(0x000177A0) { FILL(0x00000000); build/asm/main_803167A0.s.o(.text); build/asm/main_803167A0.s.o(.rodata); build/asm/main_803167A0.s.o(.data); }
    .main_803167A0_bss (NOLOAD) : { build/asm/main_803167A0.s.o(.bss); }
    .main_80316820 0x80316820 : AT(0x00017820) { build/asm/data/main_80316820.bin.o(.data); }
    .main_8031AE2C 0x8031AE2C : AT(0x0001BE2C) { FILL(0x00000000); build/asm/main_8031AE2C.s.o(.text); build/asm/main_8031AE2C.s.o(.rodata); build/asm/main_8031AE2C.s.o(.data); }
    .main_8031AE2C_bss (NOLOAD) : { build/asm/main_8031AE2C.s.o(.bss); }
    .main_8031AE38 0x8031AE38 : AT(0x0001BE38) { build/asm/data/main_8031AE38.bin.o(.data); }
    .main_8031B0A4 0x8031B0A4 : AT(0x0001C0A4) { FILL(0x00000000); build/asm/main_8031B0A4.s.o(.text); build/asm/main_8031B0A4.s.o(.rodata); build/asm/main_8031B0A4.s.o(.data); }
    .main_8031B0A4_bss (NOLOAD) : { build/asm/main_8031B0A4.s.o(.bss); }
    .main_8031B0AC 0x8031B0AC : AT(0x0001C0AC) { build/asm/data/main_8031B0AC.bin.o(.data); }
    .main_8031D548 0x8031D548 : AT(0x0001E548) { FILL(0x00000000); build/asm/main_8031D548.s.o(.text); build/asm/main_8031D548.s.o(.rodata); build/asm/main_8031D548.s.o(.data); }
    .main_8031D548_bss (NOLOAD) : { build/asm/main_8031D548.s.o(.bss); }
    .main_8031D5C8 0x8031D5C8 : AT(0x0001E5C8) { build/asm/data/main_8031D5C8.bin.o(.data); }
    .main_8031DE28 0x8031DE28 : AT(0x0001EE28) { FILL(0x00000000); build/asm/main_8031DE28.s.o(.text); build/asm/main_8031DE28.s.o(.rodata); build/asm/main_8031DE28.s.o(.data); }
    .main_8031DE28_bss (NOLOAD) : { build/asm/main_8031DE28.s.o(.bss); }
    .main_8031DE40 0x8031DE40 : AT(0x0001EE40) { build/asm/data/main_8031DE40.bin.o(.data); }
    .main_8032317C 0x8032317C : AT(0x0002417C) { FILL(0x00000000); build/asm/main_8032317C.s.o(.text); build/asm/main_8032317C.s.o(.rodata); build/asm/main_8032317C.s.o(.data); }
    .main_8032317C_bss (NOLOAD) : { build/asm/main_8032317C.s.o(.bss); }
    .main_803231B4 0x803231B4 : AT(0x000241B4) { build/asm/data/main_803231B4.bin.o(.data); }
    .main_80323910 0x80323910 : AT(0x00024910) { FILL(0x00000000); build/asm/main_80323910.s.o(.text); build/asm/main_80323910.s.o(.rodata); build/asm/main_80323910.s.o(.data); }
    .main_80323910_bss (NOLOAD) : { build/asm/main_80323910.s.o(.bss); }
    .main_80323930 0x80323930 : AT(0x00024930) { build/asm/data/main_80323930.bin.o(.data); }
    .main_80328998 0x80328998 : AT(0x00029998) { FILL(0x00000000); build/asm/main_80328998.s.o(.text); build/asm/main_80328998.s.o(.rodata); build/asm/main_80328998.s.o(.data); }
    .main_80328998_bss (NOLOAD) : { build/asm/main_80328998.s.o(.bss); }
    .main_803289AC 0x803289AC : AT(0x000299AC) { build/asm/data/main_803289AC.bin.o(.data); }
    .main_8032991C 0x8032991C : AT(0x0002A91C) { FILL(0x00000000); build/asm/main_8032991C.s.o(.text); build/asm/main_8032991C.s.o(.rodata); build/asm/main_8032991C.s.o(.data); }
    .main_8032991C_bss (NOLOAD) : { build/asm/main_8032991C.s.o(.bss); }
    .main_80329A24 0x80329A24 : AT(0x0002AA24) { build/asm/data/main_80329A24.bin.o(.data); }
    .main_8032A878 0x8032A878 : AT(0x0002B878) { FILL(0x00000000); build/asm/main_8032A878.s.o(.text); build/asm/main_8032A878.s.o(.rodata); build/asm/main_8032A878.s.o(.data); }
    .main_8032A878_bss (NOLOAD) : { build/asm/main_8032A878.s.o(.bss); }
    .main_8032A8AC 0x8032A8AC : AT(0x0002B8AC) { build/asm/data/main_8032A8AC.bin.o(.data); }
    .main_8032C668 0x8032C668 : AT(0x0002D668) { FILL(0x00000000); build/asm/main_8032C668.s.o(.text); build/asm/main_8032C668.s.o(.rodata); build/asm/main_8032C668.s.o(.data); }
    .main_8032C668_bss (NOLOAD) : { build/asm/main_8032C668.s.o(.bss); }
    .main_8032C714 0x8032C714 : AT(0x0002D714) { build/asm/data/main_8032C714.bin.o(.data); }
    .main_8032D800 0x8032D800 : AT(0x0002E800) { FILL(0x00000000); build/asm/main_8032D800.s.o(.text); build/asm/main_8032D800.s.o(.rodata); build/asm/main_8032D800.s.o(.data); }
    .main_8032D800_bss (NOLOAD) : { build/asm/main_8032D800.s.o(.bss); }
    .main_8032D84C 0x8032D84C : AT(0x0002E84C) { build/asm/data/main_8032D84C.bin.o(.data); }
    .main_8032D874 0x8032D874 : AT(0x0002E874) { FILL(0x00000000); build/asm/main_8032D874.s.o(.text); build/asm/main_8032D874.s.o(.rodata); build/asm/main_8032D874.s.o(.data); }
    .main_8032D874_bss (NOLOAD) : { build/asm/main_8032D874.s.o(.bss); }
    .main_8032D8A0 0x8032D8A0 : AT(0x0002E8A0) { build/asm/data/main_8032D8A0.bin.o(.data); }
    .main_8032DD90 0x8032DD90 : AT(0x0002ED90) { FILL(0x00000000); build/asm/main_8032DD90.s.o(.text); build/asm/main_8032DD90.s.o(.rodata); build/asm/main_8032DD90.s.o(.data); }
    .main_8032DD90_bss (NOLOAD) : { build/asm/main_8032DD90.s.o(.bss); }
    .main_8032DE1C 0x8032DE1C : AT(0x0002EE1C) { build/asm/data/main_8032DE1C.bin.o(.data); }
    .main_8032E1A0 0x8032E1A0 : AT(0x0002F1A0) { FILL(0x00000000); build/asm/main_8032E1A0.s.o(.text); build/asm/main_8032E1A0.s.o(.rodata); build/asm/main_8032E1A0.s.o(.data); }
    .main_8032E1A0_bss (NOLOAD) : { build/asm/main_8032E1A0.s.o(.bss); }
    .main_8032E2B8 0x8032E2B8 : AT(0x0002F2B8) { build/asm/data/main_8032E2B8.bin.o(.data); }
    .main_8032E5A4 0x8032E5A4 : AT(0x0002F5A4) { FILL(0x00000000); build/asm/main_8032E5A4.s.o(.text); build/asm/main_8032E5A4.s.o(.rodata); build/asm/main_8032E5A4.s.o(.data); }
    .main_8032E5A4_bss (NOLOAD) : { build/asm/main_8032E5A4.s.o(.bss); }
    .main_8032E5C4 0x8032E5C4 : AT(0x0002F5C4) { build/asm/data/main_8032E5C4.bin.o(.data); }
    .main_8032E9C8 0x8032E9C8 : AT(0x0002F9C8) { FILL(0x00000000); build/asm/main_8032E9C8.s.o(.text); build/asm/main_8032E9C8.s.o(.rodata); build/asm/main_8032E9C8.s.o(.data); }
    .main_8032E9C8_bss (NOLOAD) : { build/asm/main_8032E9C8.s.o(.bss); }
    .main_8032E9D4 0x8032E9D4 : AT(0x0002F9D4) { build/asm/data/main_8032E9D4.bin.o(.data); }
    .main_8032ED9C 0x8032ED9C : AT(0x0002FD9C) { FILL(0x00000000); build/asm/main_8032ED9C.s.o(.text); build/asm/main_8032ED9C.s.o(.rodata); build/asm/main_8032ED9C.s.o(.data); }
    .main_8032ED9C_bss (NOLOAD) : { build/asm/main_8032ED9C.s.o(.bss); }
    .main_8032EE2C 0x8032EE2C : AT(0x0002FE2C) { build/asm/data/main_8032EE2C.bin.o(.data); }
    .main_8032F61C 0x8032F61C : AT(0x0003061C) { FILL(0x00000000); build/asm/main_8032F61C.s.o(.text); build/asm/main_8032F61C.s.o(.rodata); build/asm/main_8032F61C.s.o(.data); }
    .main_8032F61C_bss (NOLOAD) : { build/asm/main_8032F61C.s.o(.bss); }
    .main_8032F62C 0x8032F62C : AT(0x0003062C) { build/asm/data/main_8032F62C.bin.o(.data); }
    .main_803302A0 0x803302A0 : AT(0x000312A0) { FILL(0x00000000); build/asm/main_803302A0.s.o(.text); build/asm/main_803302A0.s.o(.rodata); build/asm/main_803302A0.s.o(.data); }
    .main_803302A0_bss (NOLOAD) : { build/asm/main_803302A0.s.o(.bss); }
    .main_803302AC 0x803302AC : AT(0x000312AC) { build/asm/data/main_803302AC.bin.o(.data); }
    .main_8033035C 0x8033035C : AT(0x0003135C) { FILL(0x00000000); build/asm/main_8033035C.s.o(.text); build/asm/main_8033035C.s.o(.rodata); build/asm/main_8033035C.s.o(.data); }
    .main_8033035C_bss (NOLOAD) : { build/asm/main_8033035C.s.o(.bss); }
    .main_803305A4 0x803305A4 : AT(0x000315A4) { build/asm/data/main_803305A4.bin.o(.data); }
    .main_80332270 0x80332270 : AT(0x00033270) { FILL(0x00000000); build/asm/main_80332270.s.o(.text); build/asm/main_80332270.s.o(.rodata); build/asm/main_80332270.s.o(.data); }
    .main_80332270_bss (NOLOAD) : { build/asm/main_80332270.s.o(.bss); }
    .main_80332290 0x80332290 : AT(0x00033290) { build/asm/data/main_80332290.bin.o(.data); }
    .main_80333950 0x80333950 : AT(0x00034950) { FILL(0x00000000); build/asm/main_80333950.s.o(.text); build/asm/main_80333950.s.o(.rodata); build/asm/main_80333950.s.o(.data); }
    .main_80333950_bss (NOLOAD) : { build/asm/main_80333950.s.o(.bss); }
    .main_80333974 0x80333974 : AT(0x00034974) { build/asm/data/main_80333974.bin.o(.data); }
    .main_8033568C 0x8033568C : AT(0x0003668C) { FILL(0x00000000); build/asm/main_8033568C.s.o(.text); build/asm/main_8033568C.s.o(.rodata); build/asm/main_8033568C.s.o(.data); }
    .main_8033568C_bss (NOLOAD) : { build/asm/main_8033568C.s.o(.bss); }
    .main_8033572C 0x8033572C : AT(0x0003672C) { build/asm/data/main_8033572C.bin.o(.data); }
    .main_80335FF4 0x80335FF4 : AT(0x00036FF4) { FILL(0x00000000); build/asm/main_80335FF4.s.o(.text); build/asm/main_80335FF4.s.o(.rodata); build/asm/main_80335FF4.s.o(.data); }
    .main_80335FF4_bss (NOLOAD) : { build/asm/main_80335FF4.s.o(.bss); }
    .main_80335FFC 0x80335FFC : AT(0x00036FFC) { build/asm/data/main_80335FFC.bin.o(.data); }
    .main_80338A3C 0x80338A3C : AT(0x00039A3C) { FILL(0x00000000); build/asm/main_80338A3C.s.o(.text); build/asm/main_80338A3C.s.o(.rodata); build/asm/main_80338A3C.s.o(.data); }
    .main_80338A3C_bss (NOLOAD) : { build/asm/main_80338A3C.s.o(.bss); }
    .main_80338A4C 0x80338A4C : AT(0x00039A4C) { build/asm/data/main_80338A4C.bin.o(.data); }
    .main_80339680 0x80339680 : AT(0x0003A680) { FILL(0x00000000); build/asm/main_80339680.s.o(.text); build/asm/main_80339680.s.o(.rodata); build/asm/main_80339680.s.o(.data); }
    .main_80339680_bss (NOLOAD) : { build/asm/main_80339680.s.o(.bss); }
    .main_80339690 0x80339690 : AT(0x0003A690) { build/asm/data/main_80339690.bin.o(.data); }
    .main_80339AA4 0x80339AA4 : AT(0x0003AAA4) { FILL(0x00000000); build/asm/main_80339AA4.s.o(.text); build/asm/main_80339AA4.s.o(.rodata); build/asm/main_80339AA4.s.o(.data); }
    .main_80339AA4_bss (NOLOAD) : { build/asm/main_80339AA4.s.o(.bss); }
    .main_80339AE4 0x80339AE4 : AT(0x0003AAE4) { build/asm/data/main_80339AE4.bin.o(.data); }
    .main_80339EB4 0x80339EB4 : AT(0x0003AEB4) { FILL(0x00000000); build/asm/main_80339EB4.s.o(.text); build/asm/main_80339EB4.s.o(.rodata); build/asm/main_80339EB4.s.o(.data); }
    .main_80339EB4_bss (NOLOAD) : { build/asm/main_80339EB4.s.o(.bss); }
    .main_80339EC0 0x80339EC0 : AT(0x0003AEC0) { build/asm/data/main_80339EC0.bin.o(.data); }
    .main_8033A0B8 0x8033A0B8 : AT(0x0003B0B8) { FILL(0x00000000); build/asm/main_8033A0B8.s.o(.text); build/asm/main_8033A0B8.s.o(.rodata); build/asm/main_8033A0B8.s.o(.data); }
    .main_8033A0B8_bss (NOLOAD) : { build/asm/main_8033A0B8.s.o(.bss); }
    .main_8033A114 0x8033A114 : AT(0x0003B114) { build/asm/data/main_8033A114.bin.o(.data); }
    .main_8033A6E8 0x8033A6E8 : AT(0x0003B6E8) { FILL(0x00000000); build/asm/main_8033A6E8.s.o(.text); build/asm/main_8033A6E8.s.o(.rodata); build/asm/main_8033A6E8.s.o(.data); }
    .main_8033A6E8_bss (NOLOAD) : { build/asm/main_8033A6E8.s.o(.bss); }
    .main_8033A6F4 0x8033A6F4 : AT(0x0003B6F4) { build/asm/data/main_8033A6F4.bin.o(.data); }
    .main_8033CBF8 0x8033CBF8 : AT(0x0003DBF8) { FILL(0x00000000); build/asm/main_8033CBF8.s.o(.text); build/asm/main_8033CBF8.s.o(.rodata); build/asm/main_8033CBF8.s.o(.data); }
    .main_8033CBF8_bss (NOLOAD) : { build/asm/main_8033CBF8.s.o(.bss); }
    .main_8033CCB4 0x8033CCB4 : AT(0x0003DCB4) { build/asm/data/main_8033CCB4.bin.o(.data); }
    .main_8033D558 0x8033D558 : AT(0x0003E558) { FILL(0x00000000); build/asm/main_8033D558.s.o(.text); build/asm/main_8033D558.s.o(.rodata); build/asm/main_8033D558.s.o(.data); }
    .main_8033D558_bss (NOLOAD) : { build/asm/main_8033D558.s.o(.bss); }
    .main_8033D594 0x8033D594 : AT(0x0003E594) { build/asm/data/main_8033D594.bin.o(.data); }
    .main_8033EF44 0x8033EF44 : AT(0x0003FF44) { FILL(0x00000000); build/asm/main_8033EF44.s.o(.text); build/asm/main_8033EF44.s.o(.rodata); build/asm/main_8033EF44.s.o(.data); }
    .main_8033EF44_bss (NOLOAD) : { build/asm/main_8033EF44.s.o(.bss); }
    .main_8033EF6C 0x8033EF6C : AT(0x0003FF6C) { build/asm/data/main_8033EF6C.bin.o(.data); }
    .main_80340828 0x80340828 : AT(0x00041828) { FILL(0x00000000); build/asm/main_80340828.s.o(.text); build/asm/main_80340828.s.o(.rodata); build/asm/main_80340828.s.o(.data); }
    .main_80340828_bss (NOLOAD) : { build/asm/main_80340828.s.o(.bss); }
    .main_8034084C 0x8034084C : AT(0x0004184C) { build/asm/data/main_8034084C.bin.o(.data); }
    .main_80340980 0x80340980 : AT(0x00041980) { FILL(0x00000000); build/asm/main_80340980.s.o(.text); build/asm/main_80340980.s.o(.rodata); build/asm/main_80340980.s.o(.data); }
    .main_80340980_bss (NOLOAD) : { build/asm/main_80340980.s.o(.bss); }
    .main_803409A8 0x803409A8 : AT(0x000419A8) { build/asm/data/main_803409A8.bin.o(.data); }
    .main_80341184 0x80341184 : AT(0x00042184) { FILL(0x00000000); build/asm/main_80341184.s.o(.text); build/asm/main_80341184.s.o(.rodata); build/asm/main_80341184.s.o(.data); }
    .main_80341184_bss (NOLOAD) : { build/asm/main_80341184.s.o(.bss); }
    .main_803411A8 0x803411A8 : AT(0x000421A8) { build/asm/data/main_803411A8.bin.o(.data); }
    .main_8034121C 0x8034121C : AT(0x0004221C) { FILL(0x00000000); build/asm/main_8034121C.s.o(.text); build/asm/main_8034121C.s.o(.rodata); build/asm/main_8034121C.s.o(.data); }
    .main_8034121C_bss (NOLOAD) : { build/asm/main_8034121C.s.o(.bss); }
    .main_80341220 0x80341220 : AT(0x00042220) { build/asm/data/main_80341220.bin.o(.data); }
    .main_803414A8 0x803414A8 : AT(0x000424A8) { FILL(0x00000000); build/asm/main_803414A8.s.o(.text); build/asm/main_803414A8.s.o(.rodata); build/asm/main_803414A8.s.o(.data); }
    .main_803414A8_bss (NOLOAD) : { build/asm/main_803414A8.s.o(.bss); }
    .main_803414B0 0x803414B0 : AT(0x000424B0) { build/asm/data/main_803414B0.bin.o(.data); }
    .main_80341600 0x80341600 : AT(0x00042600) { FILL(0x00000000); build/asm/main_80341600.s.o(.text); build/asm/main_80341600.s.o(.rodata); build/asm/main_80341600.s.o(.data); }
    .main_80341600_bss (NOLOAD) : { build/asm/main_80341600.s.o(.bss); }
    .main_80341628 0x80341628 : AT(0x00042628) { build/asm/data/main_80341628.bin.o(.data); }
    .main_803416AC 0x803416AC : AT(0x000426AC) { FILL(0x00000000); build/asm/main_803416AC.s.o(.text); build/asm/main_803416AC.s.o(.rodata); build/asm/main_803416AC.s.o(.data); }
    .main_803416AC_bss (NOLOAD) : { build/asm/main_803416AC.s.o(.bss); }
    .main_803416C0 0x803416C0 : AT(0x000426C0) { build/asm/data/main_803416C0.bin.o(.data); }
    .main_80341AE4 0x80341AE4 : AT(0x00042AE4) { FILL(0x00000000); build/asm/main_80341AE4.s.o(.text); build/asm/main_80341AE4.s.o(.rodata); build/asm/main_80341AE4.s.o(.data); }
    .main_80341AE4_bss (NOLOAD) : { build/asm/main_80341AE4.s.o(.bss); }
    .main_80341B20 0x80341B20 : AT(0x00042B20) { build/asm/data/main_80341B20.bin.o(.data); }
    .main_80341B58 0x80341B58 : AT(0x00042B58) { FILL(0x00000000); build/asm/main_80341B58.s.o(.text); build/asm/main_80341B58.s.o(.rodata); build/asm/main_80341B58.s.o(.data); }
    .main_80341B58_bss (NOLOAD) : { build/asm/main_80341B58.s.o(.bss); }
    .main_80341B5C 0x80341B5C : AT(0x00042B5C) { build/asm/data/main_80341B5C.bin.o(.data); }
    .main_80341B98 0x80341B98 : AT(0x00042B98) { FILL(0x00000000); build/asm/main_80341B98.s.o(.text); build/asm/main_80341B98.s.o(.rodata); build/asm/main_80341B98.s.o(.data); }
    .main_80341B98_bss (NOLOAD) : { build/asm/main_80341B98.s.o(.bss); }
    .main_80341BB8 0x80341BB8 : AT(0x00042BB8) { build/asm/data/main_80341BB8.bin.o(.data); }
    .main_80341C24 0x80341C24 : AT(0x00042C24) { FILL(0x00000000); build/asm/main_80341C24.s.o(.text); build/asm/main_80341C24.s.o(.rodata); build/asm/main_80341C24.s.o(.data); }
    .main_80341C24_bss (NOLOAD) : { build/asm/main_80341C24.s.o(.bss); }
    .main_80341C54 0x80341C54 : AT(0x00042C54) { build/asm/data/main_80341C54.bin.o(.data); }
    .main_80341E60 0x80341E60 : AT(0x00042E60) { FILL(0x00000000); build/asm/main_80341E60.s.o(.text); build/asm/main_80341E60.s.o(.rodata); build/asm/main_80341E60.s.o(.data); }
    .main_80341E60_bss (NOLOAD) : { build/asm/main_80341E60.s.o(.bss); }
    .main_80341E88 0x80341E88 : AT(0x00042E88) { build/asm/data/main_80341E88.bin.o(.data); }
    .main_80341FB4 0x80341FB4 : AT(0x00042FB4) { FILL(0x00000000); build/asm/main_80341FB4.s.o(.text); build/asm/main_80341FB4.s.o(.rodata); build/asm/main_80341FB4.s.o(.data); }
    .main_80341FB4_bss (NOLOAD) : { build/asm/main_80341FB4.s.o(.bss); }
    .main_80341FB8 0x80341FB8 : AT(0x00042FB8) { build/asm/data/main_80341FB8.bin.o(.data); }
    .main_80342448 0x80342448 : AT(0x00043448) { FILL(0x00000000); build/asm/main_80342448.s.o(.text); build/asm/main_80342448.s.o(.rodata); build/asm/main_80342448.s.o(.data); }
    .main_80342448_bss (NOLOAD) : { build/asm/main_80342448.s.o(.bss); }
    .main_8034246C 0x8034246C : AT(0x0004346C) { build/asm/data/main_8034246C.bin.o(.data); }
    .main_80342948 0x80342948 : AT(0x00043948) { FILL(0x00000000); build/asm/main_80342948.s.o(.text); build/asm/main_80342948.s.o(.rodata); build/asm/main_80342948.s.o(.data); }
    .main_80342948_bss (NOLOAD) : { build/asm/main_80342948.s.o(.bss); }
    .main_80342988 0x80342988 : AT(0x00043988) { build/asm/data/main_80342988.bin.o(.data); }
    .main_80342E70 0x80342E70 : AT(0x00043E70) { FILL(0x00000000); build/asm/main_80342E70.s.o(.text); build/asm/main_80342E70.s.o(.rodata); build/asm/main_80342E70.s.o(.data); }
    .main_80342E70_bss (NOLOAD) : { build/asm/main_80342E70.s.o(.bss); }
    .main_80342E7C 0x80342E7C : AT(0x00043E7C) { build/asm/data/main_80342E7C.bin.o(.data); }
    .main_803432F4 0x803432F4 : AT(0x000442F4) { FILL(0x00000000); build/asm/main_803432F4.s.o(.text); build/asm/main_803432F4.s.o(.rodata); build/asm/main_803432F4.s.o(.data); }
    .main_803432F4_bss (NOLOAD) : { build/asm/main_803432F4.s.o(.bss); }
    .main_80343304 0x80343304 : AT(0x00044304) { build/asm/data/main_80343304.bin.o(.data); }
    .main_80344928 0x80344928 : AT(0x00045928) { FILL(0x00000000); build/asm/main_80344928.s.o(.text); build/asm/main_80344928.s.o(.rodata); build/asm/main_80344928.s.o(.data); }
    .main_80344928_bss (NOLOAD) : { build/asm/main_80344928.s.o(.bss); }
    .main_80344938 0x80344938 : AT(0x00045938) { build/asm/data/main_80344938.bin.o(.data); }
    .main_80344B18 0x80344B18 : AT(0x00045B18) { FILL(0x00000000); build/asm/main_80344B18.s.o(.text); build/asm/main_80344B18.s.o(.rodata); build/asm/main_80344B18.s.o(.data); }
    .main_80344B18_bss (NOLOAD) : { build/asm/main_80344B18.s.o(.bss); }
    .main_80344B48 0x80344B48 : AT(0x00045B48) { build/asm/data/main_80344B48.bin.o(.data); }
    .main_80344BBC 0x80344BBC : AT(0x00045BBC) { FILL(0x00000000); build/asm/main_80344BBC.s.o(.text); build/asm/main_80344BBC.s.o(.rodata); build/asm/main_80344BBC.s.o(.data); }
    .main_80344BBC_bss (NOLOAD) : { build/asm/main_80344BBC.s.o(.bss); }
    .main_80344BE4 0x80344BE4 : AT(0x00045BE4) { build/asm/data/main_80344BE4.bin.o(.data); }
    .main_803456D4 0x803456D4 : AT(0x000466D4) { FILL(0x00000000); build/asm/main_803456D4.s.o(.text); build/asm/main_803456D4.s.o(.rodata); build/asm/main_803456D4.s.o(.data); }
    .main_803456D4_bss (NOLOAD) : { build/asm/main_803456D4.s.o(.bss); }
    .main_80345710 0x80345710 : AT(0x00046710) { build/asm/data/main_80345710.bin.o(.data); }
    .main_80346274 0x80346274 : AT(0x00047274) { FILL(0x00000000); build/asm/main_80346274.s.o(.text); build/asm/main_80346274.s.o(.rodata); build/asm/main_80346274.s.o(.data); }
    .main_80346274_bss (NOLOAD) : { build/asm/main_80346274.s.o(.bss); }
    .main_80346284 0x80346284 : AT(0x00047284) { build/asm/data/main_80346284.bin.o(.data); }
    .main_80347D08 0x80347D08 : AT(0x00048D08) { FILL(0x00000000); build/asm/main_80347D08.s.o(.text); build/asm/main_80347D08.s.o(.rodata); build/asm/main_80347D08.s.o(.data); }
    .main_80347D08_bss (NOLOAD) : { build/asm/main_80347D08.s.o(.bss); }
    .main_80347D28 0x80347D28 : AT(0x00048D28) { build/asm/data/main_80347D28.bin.o(.data); }
    .main_80349F18 0x80349F18 : AT(0x0004AF18) { FILL(0x00000000); build/asm/main_80349F18.s.o(.text); build/asm/main_80349F18.s.o(.rodata); build/asm/main_80349F18.s.o(.data); }
    .main_80349F18_bss (NOLOAD) : { build/asm/main_80349F18.s.o(.bss); }
    .main_80349F30 0x80349F30 : AT(0x0004AF30) { build/asm/data/main_80349F30.bin.o(.data); }
    .main_8034E6B8 0x8034E6B8 : AT(0x0004F6B8) { FILL(0x00000000); build/asm/main_8034E6B8.s.o(.text); build/asm/main_8034E6B8.s.o(.rodata); build/asm/main_8034E6B8.s.o(.data); }
    .main_8034E6B8_bss (NOLOAD) : { build/asm/main_8034E6B8.s.o(.bss); }
    .main_8034E6F4 0x8034E6F4 : AT(0x0004F6F4) { build/asm/data/main_8034E6F4.bin.o(.data); }
    .main_8034EAC8 0x8034EAC8 : AT(0x0004FAC8) { FILL(0x00000000); build/asm/main_8034EAC8.s.o(.text); build/asm/main_8034EAC8.s.o(.rodata); build/asm/main_8034EAC8.s.o(.data); }
    .main_8034EAC8_bss (NOLOAD) : { build/asm/main_8034EAC8.s.o(.bss); }
    .main_8034EAD0 0x8034EAD0 : AT(0x0004FAD0) { build/asm/data/main_8034EAD0.bin.o(.data); }
    .main_80351368 0x80351368 : AT(0x00052368) { FILL(0x00000000); build/asm/main_80351368.s.o(.text); build/asm/main_80351368.s.o(.rodata); build/asm/main_80351368.s.o(.data); }
    .main_80351368_bss (NOLOAD) : { build/asm/main_80351368.s.o(.bss); }
    .main_80351370 0x80351370 : AT(0x00052370) { build/asm/data/main_80351370.bin.o(.data); }
    .main_80351748 0x80351748 : AT(0x00052748) { FILL(0x00000000); build/asm/main_80351748.s.o(.text); build/asm/main_80351748.s.o(.rodata); build/asm/main_80351748.s.o(.data); }
    .main_80351748_bss (NOLOAD) : { build/asm/main_80351748.s.o(.bss); }
    .main_8035174C 0x8035174C : AT(0x0005274C) { build/asm/data/main_8035174C.bin.o(.data); }
    .main_80351AD8 0x80351AD8 : AT(0x00052AD8) { FILL(0x00000000); build/asm/main_80351AD8.s.o(.text); build/asm/main_80351AD8.s.o(.rodata); build/asm/main_80351AD8.s.o(.data); }
    .main_80351AD8_bss (NOLOAD) : { build/asm/main_80351AD8.s.o(.bss); }
    .main_80351AEC 0x80351AEC : AT(0x00052AEC) { build/asm/data/main_80351AEC.bin.o(.data); }
    .main_80352454 0x80352454 : AT(0x00053454) { FILL(0x00000000); build/asm/main_80352454.s.o(.text); build/asm/main_80352454.s.o(.rodata); build/asm/main_80352454.s.o(.data); }
    .main_80352454_bss (NOLOAD) : { build/asm/main_80352454.s.o(.bss); }
    .main_803524B4 0x803524B4 : AT(0x000534B4) { build/asm/data/main_803524B4.bin.o(.data); }
    .main_80352A5C 0x80352A5C : AT(0x00053A5C) { FILL(0x00000000); build/asm/main_80352A5C.s.o(.text); build/asm/main_80352A5C.s.o(.rodata); build/asm/main_80352A5C.s.o(.data); }
    .main_80352A5C_bss (NOLOAD) : { build/asm/main_80352A5C.s.o(.bss); }
    .main_80352A60 0x80352A60 : AT(0x00053A60) { build/asm/data/main_80352A60.bin.o(.data); }
    .main_80353748 0x80353748 : AT(0x00054748) { FILL(0x00000000); build/asm/main_80353748.s.o(.text); build/asm/main_80353748.s.o(.rodata); build/asm/main_80353748.s.o(.data); }
    .main_80353748_bss (NOLOAD) : { build/asm/main_80353748.s.o(.bss); }
    .main_80353EF0 0x80353EF0 : AT(0x00054EF0) { build/asm/data/main_80353EF0.bin.o(.data); }
    .main_80354290 0x80354290 : AT(0x00055290) { FILL(0x00000000); build/asm/main_80354290.s.o(.text); build/asm/main_80354290.s.o(.rodata); build/asm/main_80354290.s.o(.data); }
    .main_80354290_bss (NOLOAD) : { build/asm/main_80354290.s.o(.bss); }
    .main_80354808 0x80354808 : AT(0x00055808) { build/asm/data/main_80354808.bin.o(.data); }
    .main_80356C1C 0x80356C1C : AT(0x00057C1C) { FILL(0x00000000); build/asm/main_80356C1C.s.o(.text); build/asm/main_80356C1C.s.o(.rodata); build/asm/main_80356C1C.s.o(.data); }
    .main_80356C1C_bss (NOLOAD) : { build/asm/main_80356C1C.s.o(.bss); }
    .main_80356C4C 0x80356C4C : AT(0x00057C4C) { build/asm/data/main_80356C4C.bin.o(.data); }
    .main_803593AC 0x803593AC : AT(0x0005A3AC) { FILL(0x00000000); build/asm/main_803593AC.s.o(.text); build/asm/main_803593AC.s.o(.rodata); build/asm/main_803593AC.s.o(.data); }
    .main_803593AC_bss (NOLOAD) : { build/asm/main_803593AC.s.o(.bss); }
    .main_803593D4 0x803593D4 : AT(0x0005A3D4) { build/asm/data/main_803593D4.bin.o(.data); }
    .main_8036E718 0x8036E718 : AT(0x0006F718) { FILL(0x00000000); build/asm/main_8036E718.s.o(.text); build/asm/main_8036E718.s.o(.rodata); build/asm/main_8036E718.s.o(.data); }
    .main_8036E718_bss (NOLOAD) : { build/asm/main_8036E718.s.o(.bss); }
    .main_8036E730 0x8036E730 : AT(0x0006F730) { build/asm/data/main_8036E730.bin.o(.data); }
    .main_80373284 0x80373284 : AT(0x00074284) { FILL(0x00000000); build/asm/main_80373284.s.o(.text); build/asm/main_80373284.s.o(.rodata); build/asm/main_80373284.s.o(.data); }
    .main_80373284_bss (NOLOAD) : { build/asm/main_80373284.s.o(.bss); }
    .main_80373294 0x80373294 : AT(0x00074294) { build/asm/data/main_80373294.bin.o(.data); }
    .main_80375B64 0x80375B64 : AT(0x00076B64) { FILL(0x00000000); build/asm/main_80375B64.s.o(.text); build/asm/main_80375B64.s.o(.rodata); build/asm/main_80375B64.s.o(.data); }
    .main_80375B64_bss (NOLOAD) : { build/asm/main_80375B64.s.o(.bss); }
    .main_80375C90 0x80375C90 : AT(0x00076C90) { build/asm/data/main_80375C90.bin.o(.data); }
    .main_8037EE90 0x8037EE90 : AT(0x0007FE90) { FILL(0x00000000); build/asm/main_8037EE90.s.o(.text); build/asm/main_8037EE90.s.o(.rodata); build/asm/main_8037EE90.s.o(.data); }
    .main_8037EE90_bss (NOLOAD) : { build/asm/main_8037EE90.s.o(.bss); }
    .main_8037EEF4 0x8037EEF4 : AT(0x0007FEF4) { build/asm/data/main_8037EEF4.bin.o(.data); }
    .main_80384100 0x80384100 : AT(0x00085100) { FILL(0x00000000); build/asm/main_80384100.s.o(.text); build/asm/main_80384100.s.o(.rodata); build/asm/main_80384100.s.o(.data); }
    .main_80384100_bss (NOLOAD) : { build/asm/main_80384100.s.o(.bss); }
    .main_80384108 0x80384108 : AT(0x00085108) { build/asm/data/main_80384108.bin.o(.data); }
    .main_8039D134 0x8039D134 : AT(0x0009E134) { FILL(0x00000000); build/asm/main_8039D134.s.o(.text); build/asm/main_8039D134.s.o(.rodata); build/asm/main_8039D134.s.o(.data); }
    .main_8039D134_bss (NOLOAD) : { build/asm/main_8039D134.s.o(.bss); }
    .main_8039D148 0x8039D148 : AT(0x0009E148) { build/asm/data/main_8039D148.bin.o(.data); }
    .main_803B6FC8 0x803B6FC8 : AT(0x000B7FC8) { FILL(0x00000000); build/asm/main_803B6FC8.s.o(.text); build/asm/main_803B6FC8.s.o(.rodata); build/asm/main_803B6FC8.s.o(.data); }
    .main_803B6FC8_bss (NOLOAD) : { build/asm/main_803B6FC8.s.o(.bss); }
    .main_803B6FD4 0x803B6FD4 : AT(0x000B7FD4) { build/asm/data/main_803B6FD4.bin.o(.data); }
    .main_803BA9B8 0x803BA9B8 : AT(0x000BB9B8) { FILL(0x00000000); build/asm/main_803BA9B8.s.o(.text); build/asm/main_803BA9B8.s.o(.rodata); build/asm/main_803BA9B8.s.o(.data); }
    .main_803BA9B8_bss (NOLOAD) : { build/asm/main_803BA9B8.s.o(.bss); }
    .main_803BA9F8 0x803BA9F8 : AT(0x000BB9F8) { build/asm/data/main_803BA9F8.bin.o(.data); }
    .main_803BB4B4 0x803BB4B4 : AT(0x000BC4B4) { FILL(0x00000000); build/asm/main_803BB4B4.s.o(.text); build/asm/main_803BB4B4.s.o(.rodata); build/asm/main_803BB4B4.s.o(.data); }
    .main_803BB4B4_bss (NOLOAD) : { build/asm/main_803BB4B4.s.o(.bss); }
    .main_803BB4EC 0x803BB4EC : AT(0x000BC4EC) { build/asm/data/main_803BB4EC.bin.o(.data); }
    .main_803CC398 0x803CC398 : AT(0x000CD398) { FILL(0x00000000); build/asm/main_803CC398.s.o(.text); build/asm/main_803CC398.s.o(.rodata); build/asm/main_803CC398.s.o(.data); }
    .main_803CC398_bss (NOLOAD) : { build/asm/main_803CC398.s.o(.bss); }
    .main_803CC3F8 0x803CC3F8 : AT(0x000CD3F8) { build/asm/data/main_803CC3F8.bin.o(.data); }
    .main_803DA100 0x803DA100 : AT(0x000DB100) { FILL(0x00000000); build/asm/main_803DA100.s.o(.text); build/asm/main_803DA100.s.o(.rodata); build/asm/main_803DA100.s.o(.data); }
    .main_803DA100_bss (NOLOAD) : { build/asm/main_803DA100.s.o(.bss); }
    .main_803DA154 0x803DA154 : AT(0x000DB154) { build/asm/data/main_803DA154.bin.o(.data); }
    .main_803FC76C 0x803FC76C : AT(0x000FD76C) { FILL(0x00000000); build/asm/main_803FC76C.s.o(.text); build/asm/main_803FC76C.s.o(.rodata); build/asm/main_803FC76C.s.o(.data); }
    .main_803FC76C_bss (NOLOAD) : { build/asm/main_803FC76C.s.o(.bss); }
    .main_803FC780 0x803FC780 : AT(0x000FD780) { build/asm/data/main_803FC780.bin.o(.data); }
    .assets 0x80700000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
