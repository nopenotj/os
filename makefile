OUT := out
all: ${OUT}/boot.bin
KERNEL_OFFSET := 0x1000

# $@ is the target file
# $^ substituted with all deps
# $< first arg

${OUT}:
	mkdir $@

${OUT}/boot.bin: boot/*.asm | ${OUT}
	nasm boot/boot.asm -i boot/ -f bin -o $@


${OUT}/kernel.bin: ${OUT}/kernel_start.o ${OUT}/kernel.o
	ld -o $@ -Ttext ${KERNEL_OFFSET} $^ --oformat binary

${OUT}/%.o: kernel/%.asm | ${OUT}
	nasm $< -f elf64 -o $@

${OUT}/%.o: kernel/%.c | ${OUT}
	gcc -ffreestanding -g -c $< -o $@

BINS := boot.bin kernel.bin
os-image: $(BINS:%=${OUT}/%)
	cat $^ > $@

run: os-image
	qemu-system-x86_64 os-image


${OUT}/kernel.elf: ${OUT}/kernel_start.o ${OUT}/kernel.o
	ld -o $@ -Ttext ${KERNEL_OFFSET} $^

debug: os-image ${OUT}/kernel.elf
	qemu-system-x86_64 os-image -s -S &
	gdb  \
	-ex 'layout asm' \
	-ex 'set disassembly-flavor intel' \
	-ex 'target remote localhost:1234' \
	-ex 'symbol-file ${OUT}/kernel.elf' \
	-ex 'break *0x7c00' \
	-ex 'break *${KERNEL_OFFSET}' \
	-ex 'break main' \
	-ex 'continue'
	pkill qemu
clean:
	rm -rf out/ *.bin *.o *.dis  os-image