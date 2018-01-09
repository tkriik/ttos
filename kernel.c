#include <sys.h>
#include <vga.h>

#include <bcons.h>

void
kmain(void)
{
	struct bcons bcons;

	bcons_init(&bcons);
	for (size_t i = 0; i < 125; i++)
		bcons_puts(&bcons, "YELLOW SUBMARINE");

	vga_draw_bcons(&bcons, VGA_LRED, VGA_DGRAY);
}
