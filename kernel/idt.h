#pragma once
#include "types.h"

// From interrupt.asm
void lidt(addr32 addr);
void int_handler_0();

struct idt_entry{
    uint_16 offset_low;
    uint_16 segment_selector;
    uint_8 padding;            // zeroed out
    uint_8 flags;              // | P (1)| DPL (00)| 0 | GATETYPE (1110) |
    uint_16 offset_high;
} __attribute__((packed));

// Interrupt Descriptor Table Register. refer to intel manual on lidt
struct idtr_t { // 6 bytes
    uint_16 limit;
    addr32 base_addr;
} __attribute__((packed));


extern struct idt_entry idt[256];
extern struct idtr_t idtr;

void interrupt_handler(int err, int int_no);
void set_idt(int i, addr32 fn);
void setup_idt();