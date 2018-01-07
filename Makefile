BOOT_SRC=	src/boot_i386.nasm

BOOT_BIN=	bin/boot_i386.bin

i386:
	mkdir -p bin/
	nasm $(BOOT_SRC) -I src/ -f bin -o $(BOOT_BIN)
