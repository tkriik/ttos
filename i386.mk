ARCH_CFLAGS=	-m32
ARCH_LDFLAGS=	-m elf_i386

BOOT_SRC=	boot_i386.nasm
BOOT_BIN=	boot_i386.bin

KERNEL_OFFSET=	0x1000

IMG=		ttos_i386.img

img: $(IMG)

include kernel.mk

$(IMG): $(KERNEL_BIN) $(BOOT_BIN)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $(IMG)

$(BOOT_BIN): $(BOOT_SRC)
	nasm -DKERNEL_OFFSET=$(KERNEL_OFFSET) -o $(BOOT_BIN) $(BOOT_SRC)

clean: kernel_clean
	rm -f $(IMG) $(BOOT_BIN)
