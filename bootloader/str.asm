; *********************************************************************************
; Real Mode Print Routines
; *********************************************************************************
; Real-mode char print
RM_PrintChar:
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x07
    int 0x10
    ret

; Real-mode line print (mov si, str)
RM_PrintStr:
    Next_Char:
        mov al, [SI]
        inc si
        
        ; Detect end of string
        or al, al
        jz Exit

        ; New line
        cmp al, 0x0A
        je HandleNewLine

        ; Print and go to next char
        call RM_PrintChar
        jmp Next_Char

    HandleNewLine:
        ; Get cursor pos
        mov ah, 0x03
        mov bh, 0x00
        int 0x10

        ; Go to next line
        inc dh
        mov ah, 0x02
        mov bh, 0x00
        mov dl, 0
        int 0x10
        jmp Next_Char

    Exit:
        ret

