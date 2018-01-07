[org 0x7c00]

jmp init

%include "print_str.nasm"

init:
    ; Setup stack.
    mov bp, 0x9000
    mov sp, bp

    ; Print real-mode message.
    mov bx, MSG_REAL_MODE
    call print_str

    jmp pm_switch

MSG_REAL_MODE:
    db "Tanel's Test Operating System (TTOS) started in 16-bit Real Mode.", 0

%include "pm.nasm"

_PAD:
    times 510-($-$$) db 0

_BOOT_SIGNATURE:
    dw 0xaa55
