#include <sys.h>

#include <bcons.h>
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
mk_vga_cell(char c, enum vga_color fg, enum vga_color bg)
{
	return (bg << 12) | (fg << 8) | c;
}

static void
vga_draw_cell(char c, enum vga_color fg, enum vga_color bg, size_t row, size_t col)
{
	// TODO: assert row, col
	size_t i = mk_vga_idx(row, col);
	uint16_t cell = mk_vga_cell(c, fg, bg);
	VGA_MEM[i] = cell;
}

void
vga_draw_bcons(struct bcons *bcons, enum vga_color fg, enum vga_color bg)
{
	for (size_t row = 0; row < BCONS_H; row++) {
		for (size_t col = 0; col < BCONS_W; col++) {
			char c = bcons->lines[row][col];
			vga_draw_cell(c, fg, bg, row, col);
		}
	}
}
