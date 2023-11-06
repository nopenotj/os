
; Load al sectors into ES:BX
;  al - no of sectors to read. 
;  dl - 0 ; drive no
;  es:bx - memory location
[bits 16]
load_sectors:

    push ax
    mov ah, 0x02 ; opcode
    

    mov dh, 0 ; track no
    mov cl, 2 ; sectors no
    mov ch, 0 ; cylinder no


    int 0x13 ; BIOS syscall

    
    ; Error handling
    jc disk_error
    
    pop dx
    cmp al, dl
    jne disk_error  

    mov bx, DISK_LOAD_SUC_MSG
    call print 
    jmp load_sectors_end
disk_error:
    mov bx, DISK_LOAD_ERR_MSG
    call print 

load_sectors_end:
    ret

DISK_LOAD_ERR_MSG:
    db 'Error loading from disk',0
DISK_LOAD_SUC_MSG:
    db 'Successfully loaded from disk',0

    
