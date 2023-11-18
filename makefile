OUT := out
all: os-image
KERNEL_OFFSET := 0x1000

CC = gcc
CFLAGS = -fno-pie -m32 -ffreestanding -g -c

# $@ is the target file
# $^ substituted with all deps
# $< first arg

${OUT}:
	mkdir $@

${OUT}/boot.bin: boot/*.asm | ${OUT}
	nasm boot/boot.asm -i boot/ -f bin -o $@

${OUT}/kernel.bin: ${OUT}/kernel.elf
	objcopy -O binary $< $@

${OUT}/%.o: kernel/%.asm | ${OUT}
	nasm $< -f elf -o $@

${OUT}/%.o: kernel/%.c | ${OUT}
	$(CC) $(CFLAGS) $< -o $@

BINS := boot.bin kernel.bin
os-image: $(BINS:%=${OUT}/%)
	cat $^ > $@

run: os-image
	qemu-system-x86_64 os-image

kernel.dis: out/kernel.bin
	ndisasm -b 32 $<  > kernel.dis
disassemble: kernel.dis

${OUT}/kernel.elf: ${OUT}/kernel_start.o ${OUT}/kernel.o ${OUT}/io.o
	ld -m elf_i386 -o $@ -Ttext ${KERNEL_OFFSET} $^ 


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