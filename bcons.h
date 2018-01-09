/*
 * Basic 80x25 console.
 */

#ifndef _BCONS_H_
#define _BCONS_H_

#include <sys.h>

#define BCONS_W		80
#define BCONS_H		25
#define BCONS_SIZE	(BCONS_W * BCONS_H)

struct bcons {
	size_t	cur_row;
	size_t	cur_col;
	char	lines[BCONS_H][BCONS_W];
};

void bcons_init(struct bcons *);
void bcons_putc(struct bcons *, char);
void bcons_puts(struct bcons *, const char *);

#endif
