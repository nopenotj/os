global inb
; read bits to I/O port
;   
;   [esp    ] : return addr
;   [esp + 4] : port number to read to
inb:
    mov dx, [esp+4]
    in al, dx
    ret


global outb
; write bits to I/O port
;   
;   [esp    ] : return addr
;   [esp + 4] : port number to write to
;   [esp + 8] : 8 bit value to write
outb:
    mov dx, [esp+4]
    mov al, [esp+8]
    out dx, al
    ret