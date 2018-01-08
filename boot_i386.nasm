; Real mode boot loader script for x86 machines.

[bits 16]
[org 0x7c00]

jmp rm_init

RM_BOOT_DRIVE:
	db 0

rm_init:
	; Store boot drive number.
	mov [RM_BOOT_DRIVE], dl

	; Setup stack.
	mov bp, 0x9000
	mov sp, bp

	; Load kernel into memory from disk area after boot sector.
	mov bx, RM_KERNEL_LOAD_MSG
	call rm_println
	call rm_kernel_load

	; Switch from real to protected mode.
	mov bx, RM_TO_PM_INFO_MSG
	call rm_println
	call rm_to_pm

RM_KERNEL_LOAD_MSG:
	db "Loading kernel into memory...", 0

RM_TO_PM_INFO_MSG:
	db "Switching from 16-bit real mode to protected mode...", 0

rm_kernel_load:
	; Load 15 sectors from disk after boot sector.
	mov bx, KERNEL_OFFSET
	mov dh, 15
	mov dl, [RM_BOOT_DRIVE]
	call rm_disk_load
	ret

rm_to_pm:
	; Disable interrupts.
	cli

	; Load the global descriptor table.
	lgdt [GDT_DESCRIPTOR]

	; Update control register.
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax

	; Far jump to protected mode in order to flush instruction pipeline.
	jmp SEG_CODE:pm_init

rm_println:
	pusha
	mov ah, 0x0e
_rm_println_loop:
	mov cl, [bx]
	test cl, cl
	jz _rm_println_ret
	mov al, cl
	int 0x10
	inc bx
	jmp _rm_println_loop
_rm_println_ret:
	mov al, 0x0a
	int 0x10
	mov al, 0x0d
	int 0x10
	popa
	ret

; INT 13h AH=02h: Read Sectors From Drive
;
; AH  02h
; AL  Sectors To Read Count
; CH  Cylinder
; CL  Sector
; DH  Head
; DL  Drive
; ES:BX   Buffer Address Pointer

rm_disk_load:
	push dx
	
	mov ah, 0x02
	mov al, dh
	mov ch, 0x00
	mov cl, 0x02
	mov dh, 0x00
	
	int 0x13
	;jc rm_err_disk_load ; TODO: handle this
	
	pop dx
	cmp dh, al
	;jne rm_err_disk_sector ; TODO handle this

	ret

rm_err_disk_load:
	mov bx, RM_ERR_DISK_LOAD_MSG
	call rm_println
	jmp $

rm_err_disk_sector:
	mov bx, RM_ERR_DISK_SECTOR_MSG
	call rm_println
	jmp $

RM_ERR_DISK_LOAD_MSG:
	db "Failed to load data from disk.", 0

RM_ERR_DISK_SECTOR_MSG:
	db "Read sector count differs from expected.", 0

GDT_START:

; Mandatory null descriptor.
GDT_NULL: 
	dd 0x0
	dd 0x0

; Code segment descriptor.
GDT_CODE:
	; base  = 0x0
	;
	; limit = 0xfffff
	;
	; 1st flags:
	;   present         = 1
	;   privilege       = 00
	;   descr. type     = 1
	;       = 1001b
	;
	; type flags:
	;   code            = 1
	;   conforming      = 0
	;   readable        = 1
	;   accessed        = 0
	;       = 1010b
	;
	; 2nd flags:
	;   granularity     = 1
	;   32-bit default  = 1
	;   64-bit seg      = 0
	;   AVL             = 0
	;       = 1100b
	
	dw 0xffff       ; limit (0-15)
	dw 0x0          ; base (0-15)
	db 0x0          ; base (16-23)
	db 10011010b    ; 1st flags, type flags
	db 11001111b    ; 2nd flags, limit (16-19)
	db 0x0          ; base (24-31)

; Data segment descriptor
GDT_DATA:
	; Identical to code descriptor, except for type flags.
	;
	; type flags:
	;   code        = 0
	;   expand down = 0
	;   writable    = 1
	;   accessed    = 0
	;       = 0010b
	
	dw 0xffff       ; limit (0-15)
	dw 0x0          ; base (0-15)
	db 0x0          ; base (16-23)
	db 10010010b    ; 1st flags, type flags
	db 11001111b    ; 2nd flags, limit (16-19)
	db 0x0          ; base (24-31)

GDT_END:

GDT_DESCRIPTOR:
	dw GDT_END - GDT_START - 1
	dd GDT_START

SEG_CODE equ GDT_CODE - GDT_START
SEG_DATA equ GDT_DATA - GDT_START

[bits 32]

pm_init:
	; Reset old real-mode segment registers to our defined data segment.
	mov ax, SEG_DATA
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
	call KERNEL_OFFSET
	;mov ebx, PM_ENTERED_MSG
	;call pm_println_vga

	jmp $

PM_ENTERED_MSG:
	db "Successfully entered 32-bit protected mode.", 0

VGA_MEM equ 0x000b8000 ; VGA memory start region
WHITE_ON_BLACK equ 0x0f

pm_println_vga:
	push eax
	push ebx
	push edx
	mov edx, VGA_MEM
_pm_println_vga_loop:
	mov al, [ebx]
	mov ah, WHITE_ON_BLACK
	cmp al, 0
	je _pm_println_vga_ret
	mov [edx], ax
	inc ebx
	add edx, 2
	jmp _pm_println_vga_loop
_pm_println_vga_ret:
	pop edx
	pop ebx
	pop eax
	ret

_PAD:
	times 510-($-$$) db 0

_BOOT_SIGNATURE:
	dw 0xaa55
