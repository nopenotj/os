OUT := out
all: os-image
KERNEL_OFFSET := 0x1000

CC = gcc
CFLAGS = -fno-pie -m32 -ffreestanding -g -c

# Source files 
SOURCEDIR = kernel/
C_SOURCES := $(shell find $(SOURCEDIR) -name '*.c' -type f -printf "%f\n")
ASM_SOURCES := $(shell find $(SOURCEDIR) -name '*.asm' -type f -printf "%f\n"| grep -v kernel_start) 
C_OBJECTS = $(addprefix ${OUT}/,$(C_SOURCES:%.c=%.o))
ASM_OBJECTS = $(addprefix ${OUT}/,$(ASM_SOURCES:%.asm=%.o))


# $@ is the target file
# $^ substituted with all deps
# $< first arg

${OUT}:
	mkdir $@

# Kernel binary
${OUT}/kernel.bin: ${OUT}/kernel.elf
	objcopy -O binary $< $@
${OUT}/kernel.elf: ${OUT}/kernel_start.o ${C_OBJECTS} ${ASM_OBJECTS}
	ld -m elf_i386 -o $@ -T link.ld $^ 



# Boot binary
${OUT}/boot.bin: boot/*.asm | ${OUT}
	nasm boot/boot.asm -i boot/ -f bin -o $@



# Match alls
${OUT}/%.o: kernel/%.asm | ${OUT}
	nasm $< -f elf -o $@
${OUT}/%.o: kernel/%.c | ${OUT}
	$(CC) $(CFLAGS) $< -o $@



# OS Image
BINS := boot.bin kernel.bin
os-image: $(BINS:%=${OUT}/%)
	cat $^ > $@
run: os-image
	qemu-system-x86_64 os-image
debug: os-image ${OUT}/kernel.elf
	qemu-system-i386 os-image -s -S &
	gdb  \
	-ex 'set disassembly-flavor intel' \
	-ex 'target remote localhost:1234' \
	-ex 'symbol-file ${OUT}/kernel.elf' \
	-ex 'break main' \
	-ex 'layout src' \
	-ex 'continue'
	pkill qemu
clean:
	rm -rf out/ *.bin *.o *.dis  os-image



# Disassemble related stuffs
kernel.dis: out/kernel.bin
	ndisasm -b 32 $<  > kernel.dis
disassemble: kernel.dis
