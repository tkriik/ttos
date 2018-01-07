%ifndef DISK_LOAD
%define DISK_LOAD

; INT 13h AH=02h: Read Sectors From Drive
;
; AH  02h
; AL  Sectors To Read Count
; CH  Cylinder
; CL  Sector
; DH  Head
; DL  Drive
; ES:BX   Buffer Address Pointer

%include "print_str.nasm"

disk_load:
    push dx

    mov ah, 0x02
    mov al, dh
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    
    int 0x13
    jc disk_load_failed

    pop dx
    cmp dh, al
    jne sector_count_mismatch
    ret

disk_load_failed:
    mov bx, DISK_LOAD_FAILED_MSG
    call print_str
    jmp $

sector_count_mismatch:
    mov bx, SECTOR_COUNT_MISMATCH_MSG
    call print_str
    jmp $

DISK_LOAD_FAILED_MSG:
    db "Failed to load data from disk.", 0

SECTOR_COUNT_MISMATCH_MSG:
    db "Read sector count differs from expected.", 0

%endif
