BITS 64

%define DATA_SEG 0x0010
%define VRAM     0xB8000

Kernel:

    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov edi, VRAM

    mov rax, 0x1F6C1F6C1F651F48
    mov [edi], rax
    mov rax, 0x1F6F1F571F201f6F
    mov [edi + 8], rax
    mov rax, 0x1F211F641F6C1F72
    mov [edi + 16], rax

    .halt: hlt
    jmp .halt ; infinite loop
