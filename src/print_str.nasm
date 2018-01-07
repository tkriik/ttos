%ifndef PRINT_STR
%define PRINT_STR

%include "println.nasm"

print_str:
    push ax
    push bx ; data
    push cx
    mov ah, 0x0e
    xor cx, cx

_print_str_loop: 
    mov cl, [bx]
    test cl, cl
    jz _print_str_ret
    mov al, cl
    int 0x10

_print_str_loop_update:
    inc bx
    jmp _print_str_loop

_print_str_ret:
    call println
    pop cx
    pop bx
    pop ax
    ret

%endif
