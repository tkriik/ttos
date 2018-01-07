[bits 16]
[org 0x7c00]

jmp init

%include "disk_load.nasm"
%include "print_hex.nasm"
%include "print_str.nasm"

init:
    ; save boot drive number
    mov [BOOT_DRIVE_NO], dl

    ; setup stack
    mov bp, 0x8000
    mov sp, bp

    ; print boot message
    mov bx, BOOT_MSG
    call print_str

    ; read N sectors to address 0x9000
    mov bx, 0x9000
    mov dh, 2
    mov dl, [BOOT_DRIVE_NO]
    call disk_load

    ; print 4 bytes at 0x9000
    mov bx, 0x9000
    mov cx, 4
    call print_hex

    ; print 4 bytes at 0x9000 + 2 sectors
    mov bx, 0x9000 + 512
    mov cx, 4
    call print_hex

    jmp $

BOOT_MSG:
    db "Booting Tanel's Test Operating System...", 0

BOOT_DRIVE_NO:
    db 0

_PAD:
    times 510-($-$$) db 0

_BOOT_SIGNATURE:
    dw 0xaa55

_DUMMY_SECTORS:
    times 256 dw 0xdada
    times 256 db 0xfa, 0xce
