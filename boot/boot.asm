

[org 0x7c00]

; 1. Print welcome message
mov bx, welcome_string
call print

; 2. Enable the A20 gate to acces >1mb ram (http://kernelx.weebly.com/writing-a-bootsector.html)
mov ax, 0x2401 ;Set the function number
int 0x15 ;Call BIOS

; 3. Load the kernel into memory
; Read 6 sectors into 0x1000
mov al, 6; no of sectors to read
mov bx, 0x1000
call load_sectors

; 4. Switch to protected Mode
call switch_to_pm
jmp $


%include "print_16b.asm"
%include "gdt.asm"
%include "disk_load.asm"

switch_to_pm:
    ; stop interrupts
    cli 

    ; load gdt
    lgdt [gdt_descriptor] 
    
    ; set 1st bit of control register to 1 which turns on 32bit mode
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; do a far jump to clear pipelining
    jmp CODE_SEG:init_pm

[bits 32]

init_pm:
    ; setup segment registers
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    

    ; setup stack
    mov ebp, 0x90000
    mov esp, ebp

    call BEGIN_PM



BEGIN_PM:

    call clear_screen
    call 0x1000
    jmp $


VGA_MEM equ 0xb8000

; CLEAR SCREEN ROUTINE
clear_screen:
    pusha
    mov al, 0
    mov ah, 0x0f

    mov ebx, 0 
_WHILE_clear_screen:
    cmp ebx, 80 * 25 * 2
    je _END_clear_screen
    mov [VGA_MEM + ebx], ax
    add ebx, 2
    jmp _WHILE_clear_screen
_END_clear_screen:
    popa
    ret


welcome_string: db 'Booting up in 16 bit real mode...',0


times 510-($-$$) db 0

; Magic number so BIOS knows this is the boot sector
dw 0xaa55

