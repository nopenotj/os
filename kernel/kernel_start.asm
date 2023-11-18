[bits 32]

; since we are arbitarily jumping to the kernel offset. 
; we must make sure we enter the main function and not 
; execute some random bits

[extern main]
call main
jmp $