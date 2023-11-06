
; print -> prints a string to screens
; input:
;     bx - address of string
print:
    pusha
while:
    mov al, [bx]
    cmp al, 0
    je end
    call print_char
    add bx, 1
    jmp while
end:
    popa
    ret


; print_char -> prints char to screen
; input:
;     al - character t oprint
print_char:
    pusha
    mov ah, 0x0e
    int 0x10
    popa
    ret