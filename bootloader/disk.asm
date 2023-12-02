; set dl to drive number to read from
; es:bx is pointer to buffer for data read
LoadFromDisk:
    pusha
    push dx

    mov ah, 0x02    ; read mode
    mov al, dh      ; number of sector to read
    mov cl, 0x02    ; starting from 2nd sector, as 1st sector is the bootloader
    mov ch, 0x00    ; cylinder 0
    mov dh, 0x00    ; head 0

    int 0x13
    jc DiskError

    pop dx
    cmp al, dh      ; verify sectors read
    jne DiskError

    popa
    ret

DiskError:
    jmp $