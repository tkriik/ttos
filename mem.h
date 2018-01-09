/*
 * Memory handling routines.
 */

#ifndef _MEM_H_
#define _MEM_H_

#include <sys.h>

void mem_zero(void *, size_t);
void mem_copy(void *, const void *, size_t);

#endif
