BITS 16

Is_longmode_supported:
    
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb .not_supported

    mov eax, 0x80000001
    cpuid

    test edx, (1 << 29)

    jz .not_supported
    ret

    .not_supported:
        xor eax, eax
        ret

Enter_long_mode:

    mov edi, PAGING_DATA
    mov eax, 10100000b
    mov cr4, eax
    mov edx, edi
    mov cr3, edx
    mov ecx, 0xC0000080
    rdmsr
    or eax, 0x00000100
    wrmsr
    mov ebx, cr0
    or ebx, 0x80000001

    mov cr0, ebx
    lgdt [GDT.Pointer]
    jmp CODE_SEG:Kernel
