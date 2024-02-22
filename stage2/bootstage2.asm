BITS 16

stage2_message dw 19
db 'Entering Stage 2...'
longmode_supported_message dw 23
db 'Long mode is supported.'
longmode_not_supported_message dw 27
db 'Long mode is not supported'

Stage2_entrypoint:
    mov si, stage2_message
    call Real_mode_println

    ; check if long mode is supported
    call Is_longmode_supported
    test eax, eax
    jz .long_mode_not_supported
    mov si, longmode_supported_message
    call Real_mode_println

    ; enable gate a20
    call Enable_A20
    ; prepare paging
    call Prepare_paging
    ; Remap PIC
    call Remap_PIC
    ; Enter long mode
    call Enter_long_mode

    .long_mode_not_supported:
        mov si, longmode_not_supported_message
        call Real_mode_println
        .halt: hlt ; infinite loop
        jmp .halt ; prevent from going off in memort and executing junk

%include "stage2/a20.asm"
%include "stage2/paging.asm"
%include "stage2/pic.asm"
%include "stage2/longmode.asm"
