BITS 16
Enable32Bit:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1     ; enable protected mode
    mov cr0, eax
    jmp CODE_SEG:Init32

BITS 32
Init32:
    ; Segment registers
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Stack setup
    mov ebp, 0x90000
    mov esp, ebp

    call BEGIN_32BIT