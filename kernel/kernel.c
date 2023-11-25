#include "io.h"
#include "types.h"
#include "idt.h"
#include "port.h"

void main() {
    setup_idt();

    set_cursor(0);
    write("Welcome to the kernel.\n");
    write(":D\n");

    // Test int 0
    __asm__ __volatile__("int $0");
}