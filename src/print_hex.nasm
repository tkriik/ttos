%ifndef PRINT_HEX
%define PRINT_HEX

%include "println.nasm"

print_hex:
    push ax
    push bx ; data address
    push cx ; data length
    push dx
    push di
    mov ah, 0x0e
    mov dx, 16
    xor di, di

_print_hex_loop:
    test cx, cx
    jz _print_hex_ret

_print_hex_loop_line_break:
    test dx, dx
    jnz _print_hex_loop_high_nibble
    call println
    mov dx, 16

_print_hex_loop_high_nibble:
    mov di, [bx]
    and di, 0x00f0
    shr di, 4
    mov al, [_print_hex_digits + di]
    int 0x10

_print_hex_loop_low_nibble:
    mov di, [bx]
    and di, 0x000f
    mov al, [_print_hex_digits + di]
    int 0x10

_print_hex_loop_space:
    mov al, ' '
    int 0x10

_print_hex_loop_update:
    inc bx
    dec cx
    dec dx
    jmp _print_hex_loop

_print_hex_ret:
    call println
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

_print_hex_digits:
    db "0123456789abcdef"

%endif
