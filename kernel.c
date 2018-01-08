#include "sys.h"

#include "vga.h"

void kmain()
{
	vga_put('K', VGA_LGRAY, VGA_RED, 0, 0);
	vga_put('e', VGA_LGRAY, VGA_RED, 1, 1);
	vga_put('r', VGA_LGRAY, VGA_RED, 2, 2);
	vga_put('n', VGA_LGRAY, VGA_RED, 3, 3);
	vga_put('e', VGA_LGRAY, VGA_RED, 4, 4);
	vga_put('l', VGA_LGRAY, VGA_RED, 5, 5);
	vga_put(' ', VGA_LGRAY, VGA_RED, 6, 6);
	vga_put('y', VGA_LGRAY, VGA_RED, 7, 7);
	vga_put('o', VGA_LGRAY, VGA_RED, 8, 8);
	vga_put('!', VGA_LGRAY, VGA_RED, 9, 9);
}
