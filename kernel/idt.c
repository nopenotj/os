#include "idt.h"
#include "io.h"
#include "pic.h"


struct idt_entry idt[256];
struct idtr_t idtr;

void setup_idt() {
    // Setup the IDT gates
    set_idt(32, (addr32) isr32);
    set_idt(33, (addr32) isr33);


    // Setup IDT Register
    idtr.base_addr = (addr32) &idt;
    idtr.limit = sizeof(struct idt_entry) * 256 - 1;

    // Load IDT
    lidt((addr32) &idtr);
}

void set_idt(int i, addr32 fn) {
    // See "Gate Descriptor" section: https://wiki.osdev.org/IDT
    idt[i].offset_high = (fn >> 16);
    idt[i].offset_low = fn & 0xFFFF;
    idt[i].padding = 0;
    idt[i].flags = 0b10001110;
    idt[i].segment_selector = 0x8;
}

void print_letter(uint_8 scancode) {
    switch (scancode) {
        case 0x0:
            write("ERROR");
            break;
        case 0x1:
            write("ESC");
            break;
        case 0x2:
            write("1");
            break;
        case 0x3:
            write("2");
            break;
        case 0x4:
            write("3");
            break;
        case 0x5:
            write("4");
            break;
        case 0x6:
            write("5");
            break;
        case 0x7:
            write("6");
            break;
        case 0x8:
            write("7");
            break;
        case 0x9:
            write("8");
            break;
        case 0x0A:
            write("9");
            break;
        case 0x0B:
            write("0");
            break;
        case 0x0C:
            write("-");
            break;
        case 0x0D:
            write("+");
            break;
        case 0x0E:
            write("Backspace");
            break;
        case 0x0F:
            write("Tab");
            break;
        case 0x10:
            write("Q");
            break;
        case 0x11:
            write("W");
            break;
        case 0x12:
            write("E");
            break;
        case 0x13:
            write("R");
            break;
        case 0x14:
            write("T");
            break;
        case 0x15:
            write("Y");
            break;
        case 0x16:
            write("U");
            break;
        case 0x17:
            write("I");
            break;
        case 0x18:
            write("O");
            break;
        case 0x19:
            write("P");
            break;
		case 0x1A:
			write("[");
			break;
		case 0x1B:
			write("]");
			break;
		case 0x1C:
			write("\n");
			// write("ENTER");
			break;
		case 0x1D:
			write("LCtrl");
			break;
		case 0x1E:
			write("A");
			break;
		case 0x1F:
			write("S");
			break;
        case 0x20:
            write("D");
            break;
        case 0x21:
            write("F");
            break;
        case 0x22:
            write("G");
            break;
        case 0x23:
            write("H");
            break;
        case 0x24:
            write("J");
            break;
        case 0x25:
            write("K");
            break;
        case 0x26:
            write("L");
            break;
        case 0x27:
            write(";");
            break;
        case 0x28:
            write("'");
            break;
        case 0x29:
            write("`");
            break;
		case 0x2A:
			write("LShift");
			break;
		case 0x2B:
			write("\\");
			break;
		case 0x2C:
			write("Z");
			break;
		case 0x2D:
			write("X");
			break;
		case 0x2E:
			write("C");
			break;
		case 0x2F:
			write("V");
			break;
        case 0x30:
            write("B");
            break;
        case 0x31:
            write("N");
            break;
        case 0x32:
            write("M");
            break;
        case 0x33:
            write(",");
            break;
        case 0x34:
            write(".");
            break;
        case 0x35:
            write("/");
            break;
        case 0x36:
            write("Rshift");
            break;
        case 0x37:
            write("Keypad *");
            break;
        case 0x38:
            write("LAlt");
            break;
        case 0x39:
            write("Spc");
            break;
        default:
            /* 'keuyp' event corresponds to the 'keydown' + 0x80 
             * it may still be a scancode we haven't implemented yet, or
             * maybe a control/escape sequence */
            if (scancode <= 0x7f) {
                write("Unknown key down");
            } else if (scancode <= 0x39 + 0x80) {
                // write("key up ");
                // print_letter(scancode - 0x80);
            } else write("Unknown key up");
            break;
    }
}
void keyboard_handler() {
    uint_8 scancode = inb(0x60);
    print_letter(scancode);
}

void interrupt_handler(int int_no, int err) {
    // If hardware interrupt, we need to end EOI to PIC else it will stop sending us interrupts
    PIC_sendEOI(int_no);
    
    if (int_no == 33) {
        keyboard_handler();
    }
    return;
}
