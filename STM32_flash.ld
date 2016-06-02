ENTRY(Reset_Handler)

__stack_end__ = 0x10010000; /* Note: stack grows down */

MEMORY
{
	FLASH (rx)			: ORIGIN = 0x08000000, LENGTH = 2M
	CCM (xrw)			: ORIGIN = 0x10000000, LENGTH = 64K
	RAM (xrw)			: ORIGIN = 0x20000000, LENGTH = 192K
}

SECTIONS
{
	.vectors :
	{
		. = ALIGN(4);
		KEEP(*(.vectors)) /* Startup */
		. = ALIGN(4);
	} >FLASH

	.text :
	{
		. = ALIGN(4);
		*(.text)
		*(.text*)
		*(.rodata)
		*(.rodata*)
		*(.glue_7)
		*(.glue_7t)
		*(.eh_frame)

		KEEP (*(.init))
		KEEP (*(.fini))

		. = ALIGN(4);
	} >FLASH

	__etext=.;

	.data : AT ( __etext)
	{
		. = ALIGN(4);
		__data_start__ = .;
		*(.data)
		*(.data*)

		. = ALIGN(4);
		__data_end__ = .;
	} >RAM

	. = ALIGN(4);
	.bss :
	{
		__bss_start__ = .;
		*(.bss)
		*(.bss*)
		*(COMMON)

		. = ALIGN(4);
		__bss_end__ = .;
	} >RAM

	/DISCARD/ :
	{
		libc.a ( * )
		libm.a ( * )
		libgcc.a ( * )
	}
}
