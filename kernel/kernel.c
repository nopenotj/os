#include "io.h"
#include "types.h"
#include "idt.h"
#include "pic.h"
void main() {
    setup_idt();
    setup_pic();

    // Re-enable hardware interrupts
    __asm__ __volatile__("sti");


    set_cursor(0);
    write("Welcome to the kernel.\n");
    write(":D\n");


}

