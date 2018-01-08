KERNEL_SRC=	kernel.c

KERNEL_OBJ=	kernel.o

KERNEL_BIN=	kernel.bin

KERNEL_CFLAGS=	-std=c99 \
		-pedantic \
		-pedantic-errors \
		-Wall \
		-Wextra \
		-Werror \
		-fno-pie \
		-fno-stack-protector \
		-nostdlib \
		-ffreestanding
