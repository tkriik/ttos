[org 0x7c00]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 16-bit real mode routines                                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[bits 16]

jmp init

BOOT_DRIVE_NO:
	db 0

init:
	; Store boot drive number.
	mov [BOOT_DRIVE_NO], dl

	; Setup stack.
	mov bp, 0x9000
	mov sp, bp

	; Print welcome.
	mov bx, MSG_WELCOME
	call bios_println

	; Load kernel into memory from disk area after boot sector.
	mov bx, MSG_KERNEL_LOAD
	call bios_println
	call load_kernel

	; Switch from real to protected mode.
	mov bx, MSG_PM_ENTER
	call bios_println
	jmp enter_pm

load_kernel:
	; Load 15 sectors from disk after boot sector.
	mov bx, KERNEL_OFFSET
	mov dh, 15
	mov dl, [BOOT_DRIVE_NO]
	call bios_load_disk
	ret

enter_pm:
	; Disable interrupts.
	cli

	; Load the global descriptor table.
	lgdt [GDT_DESCRIPTOR]

	; Update control register.
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax

	; Far jump to protected mode in order to flush instruction pipeline.
	jmp SEG_CODE:init_pm

; BIOS utilities

bios_load_disk:
	push dx
	
	mov ah, 0x02
	mov al, dh
	mov ch, 0x00
	mov cl, 0x02
	mov dh, 0x00
	
	int 0x13
	;jc err_disk_load ; TODO: handle this
	
	pop dx
	cmp dh, al
	;jne err_disk_sector ; TODO handle this

	ret

err_disk_load:
	mov bx, MSG_ERR_DISK_LOAD
	call bios_println
	jmp $

err_disk_sector:
	mov bx, MSG_ERR_DISK_SECTOR
	call bios_println
	jmp $

bios_println:
	pusha
	mov ah, 0x0e
_bios_println_loop:
	mov cl, [bx]
	test cl, cl
	jz _bios_println_ret
	mov al, cl
	int 0x10
	inc bx
	jmp _bios_println_loop
_bios_println_ret:
	mov al, 0x0a
	int 0x10
	mov al, 0x0d
	int 0x10
	popa
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Global Descriptor Table                                                      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GDT_START:

; Mandatory null descriptor.
GDT_NULL: 
	dd 0x0
	dd 0x0

; Code segment descriptor.

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
GDT_CODE:
	dw 0xffff       ; limit (0-15)
	dw 0x0          ; base (0-15)
	db 0x0          ; base (16-23)
	db 10011010b    ; 1st flags, type flags
	db 11001111b    ; 2nd flags, limit (16-19)
	db 0x0          ; base (24-31)

; Data segment descriptor
; Identical to code descriptor, except for type flags.
;
; type flags:
;   code        = 0
;   expand down = 0
;   writable    = 1
;   accessed    = 0
;       = 0010b
GDT_DATA:
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 32-bit protected mode routines                                               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[bits 32]

init_pm:
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

	jmp enter_kernel

enter_kernel:
	call KERNEL_OFFSET
	jmp $ ; TODO: don't return

; Messages

MSG_WELCOME:
	db "Starting Tanel's Test Operating System...", 0

MSG_KERNEL_LOAD:
	db "Loading kernel into memory...", 0

MSG_PM_ENTER:
	db "Switching from 16-bit real mode to protected mode...", 0

MSG_ERR_DISK_LOAD:
	db "Failed to load data from disk.", 0

MSG_ERR_DISK_SECTOR:
	db "Read sector count differs from expected.", 0

MSG_PM_ENTERED:
	db "Successfully entered 32-bit protected mode.", 0

; Boot sector end

_PAD:
	times 510-($-$$) db 0

_BOOT_SIG:
	dw 0xaa55
