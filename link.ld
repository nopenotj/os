SECTIONS {
    . = 0x1000;          /* the code should be loaded at 0x1000 */

    .text ALIGN (0x100) :   /* align at 8B */
    {
        *(.text)             /* all text sections from all files */
    }

    .rodata ALIGN (0x100) : /* align at 8B */
    {
        *(.rodata*)          /* all read-only data sections from all files */
    }

    .data ALIGN (0x100) :   /* align at 8B */
    {
        *(.data)             /* all data sections from all files */
    }

    .bss ALIGN (0x100) :    /* align at 8B */
    {
        *(COMMON)            /* all COMMON sections from all files */
        *(.bss)              /* all bss sections from all files */
    }
}