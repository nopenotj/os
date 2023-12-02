
global lidt
; load interrupt descriptor table
;
;   [esp + 4] : addr of the IDT Register
;   [esp    ] : return addr
lidt:
    ; I'm not very sure why we cant just lidt [esp + 4], as nasm is able to compile but it does not work.
    ; edit: i found out why, in nasm [] allow us to define effective addresses (https://nasm.us/doc/nasmdoc3.html#section-3.3)
    ;       tldr, this computes whatever is in the [] into an address. it is NOT a dereference operator.
    ;       [] seems to dereference because it is usually used with the mov instruction that takes in an address as a 
    ;       source operand and loads it into the dest which is not the same as dereferencing [...] into x then mov dest, x.
    ;       
    ;       lidt takes in a m32 operand, and [esp + 4] merely evaluates to the an address in the stack which is not what we want.
    ;       Hence we have to use the mov instruction to get the value at the stack address out into eax then call lidt eax.
    ;       
    mov eax, [esp + 4]
    lidt [eax]
    ret


; when interrupt occurs cpu pushes the following onto the stack:
;    [esp + 12] eflags
;    [esp + 8]  cs
;    [esp + 4]  eip
;    [esp]      error code? (only for 8,10-14,17)
; once we handled the errors, we can call iret which returns to cs:eip
; we must ensure that stack is still the same.
[extern interrupt_handler]
; ISR => Interrupt Service Routine (https://wiki.osdev.org/Interrupt_Service_Routines)
%macro noerr_isr 1
global isr%1
isr%1:
    cli
    push 0
    push %1
    call interrupt_handler
    add esp, 8 ; reset stack
    sti
    iret
%endmacro
%macro err_isr 1
global isr%1
isr%1:
    cli
    push %1
    call interrupt_handler
    add esp, 8 ; reset stack
    sti
    iret
%endmacro

noerr_isr 32
noerr_isr 33
