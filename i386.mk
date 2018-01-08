include kernel.mk

BOOT_SRC=	boot_i386.nasm
BOOT_BIN=	boot_i386.bin

KERNEL_OFFSET=	0x1000

IMG=		ttos_i386.img

img: $(IMG)

$(IMG): $(KERNEL_BIN) $(BOOT_BIN)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $(IMG)

$(BOOT_BIN): $(BOOT_SRC)
	nasm -DKERNEL_OFFSET=$(KERNEL_OFFSET) -o $(BOOT_BIN) $(BOOT_SRC)

$(KERNEL_OBJ): $(KERNEL_SRC)
	gcc $(KERNEL_CFLAGS) -m32 -c $(KERNEL_SRC)

$(KERNEL_BIN): $(KERNEL_OBJ)
	ld -m elf_i386 -o $(KERNEL_BIN) -Ttext $(KERNEL_OFFSET) $(KERNEL_OBJ) --oformat binary

clean:
	rm -f $(IMG) $(BOOT_BIN) $(KERNEL_BIN) $(KERNEL_OBJ)
