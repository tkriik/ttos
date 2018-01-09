#include <sys.h>

#include <mem.h>

/*
 * Zeroes len bytes starting from mem.
 */
void
mem_zero(void *mem, size_t len)
{
	uint8_t *buf = mem;
	for (size_t i = 0; i < len; i++)
		buf[i] = 0;
}

/*
 * Copies len bytes from src to dst.
 * Does NOT handle overlapping regions.
 */
void
mem_copy(void *dst, const void *src, size_t len)
{
	uint8_t *dst_buf = dst;
	const uint8_t *src_buf = src;
	for (size_t i = 0; i < len; i++)
		dst_buf[i] = src_buf[i];
}
