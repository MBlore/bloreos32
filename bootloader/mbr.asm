BITS 16
ORG 0x7C00

; Stack
mov bp, 0x8000
mov sp, bp

; Address of the kernel
KERNEL_OFFSET equ 0x9000

mov si, intro_msg
call RM_PrintStr

; Save the drive we got loaded from so we know where to load the kernel from
mov [BOOT_DRIVE], dl

mov si, loading_msg
call RM_PrintStr

call LoadKernel

mov si, switching_msg
call RM_PrintStr

call Enable32Bit

jmp $

%include "./bootloader/str.asm"
%include "./bootloader/disk.asm"
%include "./bootloader/gdt.asm"
%include "./bootloader/32bit.asm"

BITS 16
LoadKernel:
    mov bx, KERNEL_OFFSET   ; Destination address
    mov dh, 2               ; Loading 2 sectors
    mov dl, [BOOT_DRIVE]    ; The disk id we came from
    call LoadFromDisk
    ret

BITS 32
BEGIN_32BIT:
    VIDEO_MEMORY equ 0xb8000
    WHITE_ON_BLACK equ 0x0f
    WHITE_ON_RED equ 0x4f
    WHITE_ON_PURPLE equ 0x5f

    mov edx , VIDEO_MEMORY
    mov al , '1'
    mov ah , WHITE_ON_RED
    mov [edx] , ax

    call KERNEL_OFFSET
    jmp $

; Data
BOOT_DRIVE db 0
intro_msg db "BloreOS Bootloader v0.1", 0x0A, 0
loading_msg db "Loading kernel...", 0x0A, 0
switching_msg db "Switching to 32-bit mode...", 0x0A, 0

; Pad to 510 bytes + signature
TIMES 510 - ($ - $$) db 0
DW 0xAA55