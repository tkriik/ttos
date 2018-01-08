#ifndef _VGA_H_
#define _VGA_H_

#include "sys.h"

#define VGA_W 80
#define VGA_H 25

enum vga_color {
	VGA_BLACK	= 0x0,
	VGA_BLUE	= 0x1,
	VGA_GREEN	= 0x2,
	VGA_CYAN	= 0x3,
	VGA_RED		= 0x4,
	VGA_MAGENTA	= 0x5,
	VGA_BROWN	= 0x6,
	VGA_LGRAY	= 0x7,
	VGA_DGRAY	= 0x8,
	VGA_LBLUE	= 0x9,
	VGA_LGREEN	= 0xa,
	VGA_LCYAN	= 0xb,
	VGA_LRED	= 0xc,
	VGA_LMAGENTA	= 0xd,
	VGA_YELLOW	= 0xe,
	VGA_WHITE	= 0xf
};

struct vga_console {
	enum	vga_color bg, fg;
	size_t	cur_line;
	uint8_t	lines[VGA_H][VGA_W];
};

void vga_console_init(struct vga_console *, enum vga_color, enum vga_color);
void vga_console_println(struct vga_console *, const char *);
void vga_console_draw(struct vga_console *);

void vga_put(uint8_t, enum vga_color, enum vga_color, size_t, size_t);
void vga_clear(void);

#endif
