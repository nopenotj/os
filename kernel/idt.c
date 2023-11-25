#include "idt.h"
#include "io.h"

struct idt_entry idt[256];
struct idtr_t idtr;

void setup_idt() {
    // Setup the IDT gates
    set_idt(0, (addr32) int_handler_0);

    // Setup IDT Register
    idtr.base_addr = (addr32) &idt;
    idtr.limit = sizeof(struct idt_entry) * 256 - 1;

    // Load IDT
    lidt((addr32) &idtr);
}

void interrupt_handler(int err, int int_no) {
    write("Interrupted");
    return;
}

void set_idt(int i, addr32 fn) {
    idt[i].offset_high = (fn >> 16);
    idt[i].offset_low = fn & 0xFFFF;
    idt[i].padding = 0;
    idt[i].flags = 0b10001110;
    idt[i].segment_selector = 0x8;
}

