#include <sys.h>
#include <bcons.h>

#include <mem.h>

void
bcons_init(struct bcons *bcons)
{
	// TODO: assert
	bcons->cur_row = 0;
	bcons->cur_col = 0;
	mem_zero(bcons->lines, BCONS_SIZE);
}

static void
shift_lines_up(struct bcons *bcons)
{
	mem_copy(bcons->lines[0], bcons->lines[1], BCONS_SIZE - BCONS_W);
	mem_zero(bcons->lines[BCONS_H - 1], BCONS_W);
}

static void
put_line(struct bcons *bcons)
{
	if (bcons->cur_row < BCONS_H - 1)
		bcons->cur_row++;
	else {
		shift_lines_up(bcons);
		bcons->cur_row = BCONS_H - 1;
	}

	bcons->cur_col = 0;
}

static void
put_at_cursor(struct bcons *bcons, char c)
{
	bcons->lines[bcons->cur_row][bcons->cur_col] = c;
}

static void
inc_cursor(struct bcons *bcons)
{
	if (bcons->cur_col < BCONS_W - 1)
		bcons->cur_col++;
	else
		put_line(bcons);
}

void
bcons_putc(struct bcons *bcons, char c)
{
	switch (c) {
	case '\n':
		put_line(bcons);
		break;
	default:
		put_at_cursor(bcons, c);
		inc_cursor(bcons);
		break;
	}
}

void
bcons_puts(struct bcons *bcons, const char *s)
{
	char c;
	while ((c = *s++) != '\0')
		bcons_putc(bcons, c);
}
