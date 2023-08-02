MEMORY
{
  rom : org = 0x8000, len = 0x3000
  ram : org = 0xB000, len = 0x5000
}

SECTIONS {
	.text: { *(.text) } > rom
	.dtors : { *(.dtors) } > rom
	.ctors : { *(.ctors) } > rom
	.rodata: { *(.rodata) } > rom
	.data: { *(.data) } > ram AT> rom
	.bss (NOLOAD) : { *(.bss) } > ram

	__BS = ADDR(.bss);
	__BL = SIZEOF(.bss);
	__DS = ADDR(.data);
	__DC = LOADADDR(.data);
	__DL = SIZEOF(.data);

	__STACK = 0xFDFE;

}

