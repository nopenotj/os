// add scrolling
// IVT + capture keystrokes
# include "io.h"


# define CURSOR_LOC_HIGH_IDX 14
# define CURSOR_LOC_LOW_IDX 15
# define VGA_INDEX_PORT 0x3D4
# define VGA_DATA_PORT VGA_INDEX_PORT + 1 // For read/write after setting index port

typedef unsigned char uint_8;
typedef unsigned short uint_16;

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
    char* fb = (char *) 0xb8000 + s*2;
    for (i = 0;buff[i] != 0;i++)
        *(fb + i*2) = buff[i];
    set_cursor(s + i);
}

void main() {
    set_cursor(0);
    char str[] = "hello_world!!";
    char space[] = " ";
    write(str);
    write(space);
    write(str);
    
}