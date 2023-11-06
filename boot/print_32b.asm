VGA_VIDEO_MEM:
    dw 0xb800

print_char32:
    mov al, 67
    mov ah, 0x0f
    mov ebx, VGA_VIDEO_MEM
    mov [ebx], ax

