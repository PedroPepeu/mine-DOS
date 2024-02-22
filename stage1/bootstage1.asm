BITS 16
ORG 0x7C00

Stage1_entrypoint: ; main entry point here BIOS leave
    
    jmp 0x0000:.setup_segments
    .setup_segments:
    ; All segments are registered to zero
    xor ax, ax
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Set up a temporary stack so that it starts growing be low Stage1_entrypoint (the stack base will be located at 0:0x7c00)

    mov sp, Stage1_entrypoint
    ; Clear direction flag (go forward in memory when using in structions like lodsb)

    cld

    ; Loading stage 2 from disk into RAM

    mov[disk], dl

    mov ax, (stage2_start-stage1_start)/512 ; ax: start sector
    mov cx, (kernel_end-stage2_start)/512 ; cx: number of sectors (512 bytes) to read
    mov bx, stage2_start ; bx:offset of buffer
    xor dx, dx ; dx: segment of buffer

    call Real_mode_read_disk

    ; Print "Stage 1 finished." message
    mov si, stage1_message
    call Real_mode_println

    ; jump to the entry point of stage 2
    jmp Stage2_entrypoint

    .halt: hlt ; Infinite loop
    jmp .halt ; It prevents from going off in memory and executing junk

%include "stage1/disk.asm"
%include "stage1/print.asm"

times 510-($-$$) db 0 ; padding
dw 0xAA55 ; the last two bytes of the boot sector should have the 0xAA55 signature
; otherwise, it'll get an error message from bios that it didn't find a bootable disk
