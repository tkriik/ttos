#include "sys.h"

#include "vga.h"

#define VGA_W 80
#define VGA_H 25

uint16_t * const VGA_MEM = (uint16_t *)0xb8000;

void
vga_put(uint8_t code, enum vga_color bg, enum vga_color fg, size_t x, size_t y)
{
	size_t i = x + y * VGA_W;
	VGA_MEM[i] = (bg << 12) | (fg << 8) | code;
}
