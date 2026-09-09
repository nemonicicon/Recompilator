SECTIONS
{
    _gp = 0x00000000;
    .header 0x00000000 : AT(0x00000000) { FILL(0x00000000); build/asm/header.s.o(.data); }
    .ipl3 0x00000040 : AT(0x00000040) { FILL(0x00000000); build/assets/ipl3.bin.o(.data); }
    .main_80140000 0x80140000 : AT(0x00001000) { FILL(0x00000000); build/asm/main_80140000.s.o(.text); build/asm/main_80140000.s.o(.rodata); build/asm/main_80140000.s.o(.data); }
    .main_80140000_bss (NOLOAD) : { build/asm/main_80140000.s.o(.bss); }
    .main_801A2118 0x801A2118 : AT(0x00063118) { FILL(0x00000000); build/asm/main_801A2118.s.o(.text); build/asm/main_801A2118.s.o(.rodata); build/asm/main_801A2118.s.o(.data); }
    .main_801A2118_bss (NOLOAD) : { build/asm/main_801A2118.s.o(.bss); }
    .main_801A296C 0x801A296C : AT(0x0006396C) { FILL(0x00000000); build/asm/main_801A296C.s.o(.text); build/asm/main_801A296C.s.o(.rodata); build/asm/main_801A296C.s.o(.data); }
    .main_801A296C_bss (NOLOAD) : { build/asm/main_801A296C.s.o(.bss); }
    .main_801A2D38 0x801A2D38 : AT(0x00063D38) { FILL(0x00000000); build/asm/main_801A2D38.s.o(.text); build/asm/main_801A2D38.s.o(.rodata); build/asm/main_801A2D38.s.o(.data); }
    .main_801A2D38_bss (NOLOAD) : { build/asm/main_801A2D38.s.o(.bss); }
    .main_801A45F8 0x801A45F8 : AT(0x000655F8) { FILL(0x00000000); build/asm/main_801A45F8.s.o(.text); build/asm/main_801A45F8.s.o(.rodata); build/asm/main_801A45F8.s.o(.data); }
    .main_801A45F8_bss (NOLOAD) : { build/asm/main_801A45F8.s.o(.bss); }
    .main_801A66F8 0x801A66F8 : AT(0x000676F8) { FILL(0x00000000); build/asm/main_801A66F8.s.o(.text); build/asm/main_801A66F8.s.o(.rodata); build/asm/main_801A66F8.s.o(.data); }
    .main_801A66F8_bss (NOLOAD) : { build/asm/main_801A66F8.s.o(.bss); }
    .main_801A6EBC 0x801A6EBC : AT(0x00067EBC) { FILL(0x00000000); build/asm/main_801A6EBC.s.o(.text); build/asm/main_801A6EBC.s.o(.rodata); build/asm/main_801A6EBC.s.o(.data); }
    .main_801A6EBC_bss (NOLOAD) : { build/asm/main_801A6EBC.s.o(.bss); }
    .main_801A7538 0x801A7538 : AT(0x00068538) { FILL(0x00000000); build/asm/main_801A7538.s.o(.text); build/asm/main_801A7538.s.o(.rodata); build/asm/main_801A7538.s.o(.data); }
    .main_801A7538_bss (NOLOAD) : { build/asm/main_801A7538.s.o(.bss); }
    .main_801A80BC 0x801A80BC : AT(0x000690BC) { FILL(0x00000000); build/asm/main_801A80BC.s.o(.text); build/asm/main_801A80BC.s.o(.rodata); build/asm/main_801A80BC.s.o(.data); }
    .main_801A80BC_bss (NOLOAD) : { build/asm/main_801A80BC.s.o(.bss); }
    .main_801EA718 0x801EA718 : AT(0x000AB718) { FILL(0x00000000); build/asm/main_801EA718.s.o(.text); build/asm/main_801EA718.s.o(.rodata); build/asm/main_801EA718.s.o(.data); }
    .main_801EA718_bss (NOLOAD) : { build/asm/main_801EA718.s.o(.bss); }
    .main_801EAF18 0x801EAF18 : AT(0x000ABF18) { FILL(0x00000000); build/asm/main_801EAF18.s.o(.text); build/asm/main_801EAF18.s.o(.rodata); build/asm/main_801EAF18.s.o(.data); }
    .main_801EAF18_bss (NOLOAD) : { build/asm/main_801EAF18.s.o(.bss); }
    .main_801EB168 0x801EB168 : AT(0x000AC168) { build/asm/data/main_801EB168.bin.o(.data); }
    .main_801EB718 0x801EB718 : AT(0x000AC718) { FILL(0x00000000); build/asm/main_801EB718.s.o(.text); build/asm/main_801EB718.s.o(.rodata); build/asm/main_801EB718.s.o(.data); }
    .main_801EB718_bss (NOLOAD) : { build/asm/main_801EB718.s.o(.bss); }
    .main_801EBF18 0x801EBF18 : AT(0x000ACF18) { FILL(0x00000000); build/asm/main_801EBF18.s.o(.text); build/asm/main_801EBF18.s.o(.rodata); build/asm/main_801EBF18.s.o(.data); }
    .main_801EBF18_bss (NOLOAD) : { build/asm/main_801EBF18.s.o(.bss); }
    .main_801EC968 0x801EC968 : AT(0x000AD968) { build/asm/data/main_801EC968.bin.o(.data); }
    .main_801ED168 0x801ED168 : AT(0x000AE168) { FILL(0x00000000); build/asm/main_801ED168.s.o(.text); build/asm/main_801ED168.s.o(.rodata); build/asm/main_801ED168.s.o(.data); }
    .main_801ED168_bss (NOLOAD) : { build/asm/main_801ED168.s.o(.bss); }
    .main_801EE128 0x801EE128 : AT(0x000AF128) { build/asm/data/main_801EE128.bin.o(.data); }
    .assets 0x80540000 : AT(0x00101000) { FILL(0x00000000); build/assets/assets.bin.o(.data); }
    /DISCARD/ : { *(*); }
}
