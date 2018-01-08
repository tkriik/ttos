#include <sys.h>
#include <vga.h>

void
kmain(void)
{
	struct vga_console c;

	vga_console_init(&c, VGA_DGRAY, VGA_LRED);
	vga_console_println(&c, "Welcome to Tanel's Test Operating System!");
	vga_console_println(&c, "This is output.");
	vga_console_println(&c, "Nothing happens yet.");
	vga_console_draw(&c);
}
