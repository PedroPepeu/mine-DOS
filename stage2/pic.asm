BITS 16

PIC1_COMMAND    equ 0x20 ; Command port of 1st PIC
PIC1_DATA       equ 0x21 ; Data port of 1st PIC
PIC2_COMMAND    equ 0xA0 ; Command port of 2nd PIC
PIC2_DATA       equ 0xA1 ; Data port of 2nd PIC
PIC_EOI         equ 0x20 ; EOI (End of interrupt) command (= 0x20)

ICW1_ICW4       equ 0x01 ; Initialization Command Word 4 is needed
ICW1_SINGLE     equ 0x02 ; Single mode (0: Cascade mode)
ICW1_INTERVAL4  equ 0x04 ; Call address interval 4 (0: 8)
ICW1_LEVEL      equ 0x08 ; Level triggered mode (0: Edge mode)
ICW1_INIT       equ 0x10 ; Initialization - required!

ICW4_8086       equ 0x01 ; 8086/88 mode (0: MCS-80/85 mode)
ICW4_AUTO_EOI   equ 0x02 ; Auto End Of Interrupt (0: Normal EOI)
ICW4_BUF_SLAVE  equ 0x08 ; Buffered mode/slave
ICW4_BUF_MASTER equ 0x0C ; Buffered mode/master
ICW4_SFNM       equ 0x10 ; Special Fully Nested Mode

Remap_PIC:
    push ax

    ; Disable IRQs
    mov al, 0xFF
    out PIC1_DATA, al
    out PIC2_DATA, al
    nop
    nop

    ; Remap PIC
    mov al, ICW1_INIT | ICW1_ICW4 ; ICW1 : send initialization command (= 0x11) to both PICs

    out PIC1_COMMAND, al
    out PIC2_COMMAND, al
    mov al, 0x20

    out PIC1_DATA, al
    mov al, 0x28

    out PIC2_DATA, al
    mov al, 4

    out PIC1_DATA, al
    mov al, 2

    out PIC2_DATA, al
    mov al, ICW4_8086
    out PIC1_DATA, al
    out PIC2_DATA, al

    mov al, 0xFF

    out PIC1_DATA, al
    out PIC2_DATA, al

    pop ax
    ret
