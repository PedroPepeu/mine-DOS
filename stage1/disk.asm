BITS 16

disk db 0x80

disk_error_message dw 11
db 'Disk error!'

DAP:
 ; Disk Address Packet

db 0x10
db 0
.num_sectors: dw 127
.buf_offset: dw 0x0
.buf_segment: dw 0x0
.LBA_lower: dd 0x0
.LBA_upper: dd 0x0

Real_mode_read_disk:

    .start:
        cmp cx, 127 ; (max sectors to read in one call = 127)
        jbe .good_size
        pusha
        mov cx, 127
        call Real_mode_read_disk
        popa
        add eax, 127
        add dx, 127 * 512 / 16
        sub cx, 127
        jmp .start

    .good_size:
        mov [DAP.LBA_lower], ax
        mov [DAP.num_sectors], cx
        mov [DAP.buf_segment], dx
        mov [DAP.buf_offset], bx
        mov dl, [disk]
        mov si, DAP
        mov ah, 0x42
        int 0x13
        jc .print_error
        ret

    .print_error:
        mov si, disk_error_message
        call Real_mode_println
        .halt: hlt
        jmp .halt ; Infinit loop. It cannot recover from disk error
