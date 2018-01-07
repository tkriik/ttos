%ifndef PM
%define PM

%include "gdt.nasm"
%include "print_str_vga.nasm"

[bits 16]

; Switch to protected mode.
pm_switch:
    ; Disable interrupts.
    cli

    ; Load the Global Descriptor Table.
    lgdt [gdt_descriptor]

    ; Update control register.
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; Far jump to protected mode in order to flush instruction pipeline.
    jmp CODE_SEG:pm_init

[bits 32]

pm_init:
    ; Reset old real-mode segment registers to our defined data segment.
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Setup new stack.
    mov ebp, 0x90000
    mov esp, ebp

    jmp pm_start

pm_start:
    mov ebx, MSG_PROTECTED_MODE
    call print_str_vga

    jmp $

MSG_PROTECTED_MODE:
    db "TTOS successfully landed in 32-bit Protected Mode.", 0

%endif
