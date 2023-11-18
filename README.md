# Building an OS from scratch

## Tools
Emulation=qemu. Debugger=gdb. asm_compiler=nasm

```
sudo apt install qemu-system
sudo apt install nasm
```
## Building os-image
os-image just contains the boot assembly code (first 512Mib) fused together with the kernel code. In our boot code, we will read
the kernel code (everything after 512Mib) into memory at KERNEL_OFFSET=0x1000, then we jmp to 0x1000.

## Boot Process
Why are sectors 512MiB?

BIOS goes through every first sector of every disk. This first sector is known as a boot sector.
BIOS knows its a valid boot sector by looking at last 2 bytes of boot sector.
Valid boot sector is when last 2 bytes == 0xaa55. However since x86 is little endian, the actual bytes on the disk will be 0x55aa.

1. boot in 16 bit real mode
2. load kernel into memory at KERNEL_OFFSET=0x1000
3. load GDT
4. switch to 32 bit mode
5. jump to KERNEL_OFFSET


## Printing strings

now i only have stack memory since I have not setup the data segment nor have I setup bss.


## Glossary

### Global Descriptor Table

The GDT (Global Descriptor Table) is how the CPU resolves memory addresses.
We need to set it up before we can switch over to 32bit mode

## Random stuff

only BX can be used as an index register e.g. mov ax, [bx]
https://stackoverflow.com/questions/1797765/assembly-invalid-effective-address

-fno-pie https://stackoverflow.com/questions/47778099/what-is-no-pie-used-for


cdel (c declaration) calling convention used.



## References

Starting point for the project - https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf
Debugging - https://github.com/cfenollosa/os-tutorial/blob/master/14-checkpoint/Makefile
Setting up IVT - https://web.archive.org/web/20160326064709/http://jamesmolloy.co.uk/tutorial_html/4.-The%20GDT%20and%20IDT.html
CRTC Registers (for cursor position) - http://www.osdever.net/FreeVGA/vga/crtcreg.htm
