#ifndef _SYS_H_
#define _SYS_H_

#if defined(_I386_)
#include "sys_i386.h"
#else
#error "No architecture defined. Use -D_(I386|...) compiler option."
#endif

#endif
