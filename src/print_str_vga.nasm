%ifndef PRINT_STR_VGA
%define PRINT_STR_VGA

[bits 32]

VGA_MEM equ 0x000b8000 ; VGA memory start region
WHITE_ON_BLACK equ 0x0f

print_str_vga:
    push eax
    push ebx
    push edx
    mov edx, VGA_MEM
_print_str_vga_loop:
    mov al, [ebx]
    mov ah, WHITE_ON_BLACK

    cmp al, 0
    je _print_str_vga_ret

    mov [edx], ax

    inc ebx
    add edx, 2
    jmp _print_str_vga_loop

_print_str_vga_ret:
    pop edx
    pop ebx
    pop eax
    ret

%endif
