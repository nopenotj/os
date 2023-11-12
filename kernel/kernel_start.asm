[bits 32]

; since we are arbitarily jumping to the kernel offset. 
; we must make sure we enter the main function and not 
; execute some random bits

[extern main]




; out 0x3D5, 0x00
; out 0x3D4, 0xF
; out 0x3D5, 0x00
call main

; format: out dest, src
;   src must be from ax and dest must be dx or 8bit literal. Refer to intel manual.
; mov al, 14
; mov dx, 0x3D4
; out dx, al

; mov al, 0x00
; mov dx, 0x3D5
; out dx, al

; mov al, 15
; mov dx, 0x3D4
; out dx, al

; mov al, 0x0D
; mov dx, 0x3D5
; out dx, al

jmp $