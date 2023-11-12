// add scrolling
// IVT + capture keystrokes
# include "io.h"

// short == 16 bit int
void set_cursor(unsigned short pos) {
    outb(0x3D4, 14);
    outb(0x3D5, (pos >> 8) & 0x00ff);
    outb(0x3D4, 15);
    outb(0x3D5, pos & 0x00ff);
}

void write(char *buff) {
    int i;
    char* fb = (char *) 0xb8000;
    for (i = 0;buff[i] != 0;i++)
        *(fb + i*2) = buff[i];
    set_cursor(i);
}

void main() {
    char str[] = "hello_world!!";
    write(str);
}