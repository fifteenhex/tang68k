SECTIONS
{
	. = 0x0;
	.text : { *(.text) }

	/DISCARD/ :
	{
		*(.note.*)
	}
}

