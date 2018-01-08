ARCH_CFLAGS=	-D_I386_ -m32
ARCH_LDFLAGS=	-m elf_i386

BOOT_SRC=	boot_i386.nasm
BOOT_BIN=	boot_i386.bin

KERNEL_OFFSET=	0x1000

IMG=		ttos_i386.img

all: image

run: image
	qemu-system-i386 $(IMG)

image: $(IMG)

include kernel.mk

$(IMG): $(BOOT_BIN) $(KERNEL_BIN)
	cat $^ > $(IMG)

$(BOOT_BIN): $(BOOT_SRC)
	nasm -DKERNEL_OFFSET=$(KERNEL_OFFSET) -o $(BOOT_BIN) $(BOOT_SRC)

clean: kernel_clean
	rm -f $(IMG) $(BOOT_BIN)
