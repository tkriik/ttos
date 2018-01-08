KERNEL_SRC=	kernel.c
KERNEL_OBJ=	kernel.o
KERNEL_BIN=	kernel.bin
KERNEL_CFLAGS=	-c \
		-std=c99 \
		-pedantic \
		-pedantic-errors \
		-Wall \
		-Wextra \
		-Werror \
		-fno-pie \
		-fno-stack-protector \
		-nostdlib \
		-ffreestanding

kernel.o: kernel.c
	$(CC) $(KERNEL_CFLAGS) $(ARCH_CFLAGS) $< -o $@

$(KERNEL_BIN): $(KERNEL_OBJ)
	ld -o $(KERNEL_BIN) -Ttext $(KERNEL_OFFSET) $(ARCH_LDFLAGS) $(KERNEL_OBJ) --oformat binary

kernel_clean:
	rm -f $(KERNEL_OBJ) $(KERNEL_BIN)
