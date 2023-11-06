gdt_start:
gdt_null:
    dd 0x0
    dd 0x0

gdt_code:
    ; First 32 bits
    dw 0xffff ; limit (bits 0-15)
    dw 0x0    ; base  (bits 0-15)

    ; Next 32 bits
    db 0x0       ; base (bits 16-26)
    db 10011010b ; (present) 1 (DPL) 00 (Descriptor type) 1 (TYPE) 1001
    db 11001111b ; (G) 1 (D/B) 1 (L) 0 (AVL) 0 (limit bits 16-19) 1111
    db 0x0       ; base (bits 24-31)

gdt_data: ; Everything the same except TYPE
    ; First 32 bits
    dw 0xffff ; limit (bits 0-15)
    dw 0x0    ; base  (bits 0-15)

    ; Next 32 bits
    db 0x0       ; base (bits 16-26)
    db 10010010b ; (present) 1 (DPL) 00 (Descriptor type) 1 (TYPE) 0010
    db 11001111b ; (G) 1 (D/B) 1 (L) 0 (AVL) 0 (limit bits 16-19) 1111
    db 0x0       ; base (bits 24-31)
gdt_end:

; 6bytes
gdt_descriptor:
    ; 2bytes size
    dw gdt_end - gdt_start - 1 ; always one less than true size
    ; 4bytes address
    dd gdt_start


CODE_SEG equ gdt_code - gdt_start ; 0x08
DATA_SEG equ gdt_data - gdt_start ; 0x10