; Main File of the kernel

[BITS 32]

extern clearscreen
extern printchar
extern init_idt

global kernel_main

kernel_main:
    call init_idt
    call clearscreen
    mov eax, 'D' 
    mov edx, 0x0a
    call printchar
    mov eax,0
    ret
