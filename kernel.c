void kmain()
{
	char *vga_mem = (char *)0xb8000;

	vga_mem[0x00] = 'K';
	vga_mem[0x02] = 'e';
	vga_mem[0x04] = 'r';
	vga_mem[0x06] = 'n';
	vga_mem[0x08] = 'e';
	vga_mem[0x0a] = 'l';
	vga_mem[0x0c] = ' ';
	vga_mem[0x0e] = 'y';
	vga_mem[0x10] = 'o';
	vga_mem[0x12] = '!';
}
