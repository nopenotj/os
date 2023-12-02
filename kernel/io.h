#pragma once
#include "types.h"

void set_cursor(uint_16 pos);
uint_16 get_cursor();
void write(char *buff);


void outb(uint_16 port, char val);
uint_8 inb(uint_16 port);
void io_wait(void);

