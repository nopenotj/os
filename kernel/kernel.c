// add scrolling
// IVT + capture keystrokes
#include "io.h"
#include "types.h"


#define CURSOR_LOC_HIGH_IDX 14
#define CURSOR_LOC_LOW_IDX 15
#define VGA_INDEX_PORT 0x3D4
#define VGA_DATA_PORT VGA_INDEX_PORT + 1 // For read/write after setting index port


void set_cursor(uint_16 pos) {
    outb(VGA_INDEX_PORT, CURSOR_LOC_HIGH_IDX);
    outb(VGA_DATA_PORT, (pos >> 8) & 0x00ff);

    outb(VGA_INDEX_PORT, CURSOR_LOC_LOW_IDX);
    outb(VGA_DATA_PORT, pos & 0x00ff);
}

uint_16 get_cursor() {
    uint_16 pos = 0;
    outb(VGA_INDEX_PORT, CURSOR_LOC_LOW_IDX);
    pos |= inb(VGA_DATA_PORT);

    outb(VGA_INDEX_PORT, CURSOR_LOC_HIGH_IDX);
    pos |= inb(VGA_DATA_PORT) << 8;
    return pos;
}


void write(char *buff) {
    uint_16 s = get_cursor();
    int i;
    char* fb = (char *) 0xb8000;

    for (i = 0;buff[i] != 0;i++) {
        if (buff[i] == '\n') {
            s = 80*((s / 80) + 1);
        } else {
            *(fb + s * 2) = buff[i];
            s += 1;
        }
    }
    set_cursor(s);
}

struct idt_entry{
    uint_16 offset_high;
    uint_8 flags;              // | P (1)| DPL (00)| 0 | GATETYPE (1110) |
    uint_8 padding;            // zeroed out
    uint_16 segment_selector;
    uint_16 offset_low;
} __attribute__((packed));

struct idt_entry idt[256];

void interrupt_handler() {
    return;
}
typedef unsigned int addr32;
void setup_idt(int i, addr32 fn) {
    idt[i].offset_high = (fn >> 16);
    idt[i].offset_low = fn & 0xFFFF;
    idt[i].flags = 0b10001110;
    idt[i].segment_selector = 0x8;
}


void main() {
    setup_idt(0, (addr32) interrupt_handler);
    set_cursor(0);
    write("Welcome to the kernel.\n");
    write(":D\n");
}