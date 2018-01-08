#include <sys.h>
#include <vga.h>

/*
 * VGA memory start.
 */
static uint16_t * const VGA_MEM = (uint16_t *)0xb8000;

static size_t
mk_vga_idx(size_t row, size_t col)
{
	return col + row * VGA_W;
}

static uint16_t
mk_vga_cell(uint8_t code, enum vga_color bg, enum vga_color fg)
{
	return (bg << 12) | (fg << 8) | code;
}

void
vga_console_init(struct vga_console *c, enum vga_color bg, enum vga_color fg)
{
	// TODO: asserts
	c->bg = bg;
	c->fg = fg;
	c->cur_line = 0;
	// TODO: memset
	for (size_t row = 0; row < VGA_H; row++)
		for (size_t col = 0; col < VGA_W; col++)
			c->lines[row][col] = '\0';
}

static void
vga_console_shift_up(struct vga_console *c)
{
	// TODO: memmove
	for (size_t row = 0; row < VGA_H - 1; row++) {
		for (size_t col = 0; col < VGA_W; col++) {
			c->lines[row][col] = c->lines[row + 1][col];
		}
	}

	for (size_t col = 0; col < VGA_W; col++) {
		c->lines[VGA_H - 1][col] = '\0';
	}
}

void
vga_console_println(struct vga_console *c, const char *s)
{
	for (size_t col = 0; *s != '\0' && col < VGA_W; s++, col++) {
		c->lines[c->cur_line][col] = *s;
	}

	if (c->cur_line == VGA_H - 1) {
		vga_console_shift_up(c);
	} else {
		c->cur_line++;
	}
}

void
vga_console_draw(struct vga_console *c)
{
	for (size_t row = 0; row < VGA_H; row++) {
		for (size_t col = 0; col < VGA_W; col++) {
			size_t i = mk_vga_idx(row, col);
			uint16_t cell = mk_vga_cell(c->lines[row][col], c->bg, c->fg);
			VGA_MEM[i] = cell;
		}
	}
}
