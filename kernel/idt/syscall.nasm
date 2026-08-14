; This file consist syscalls, their functions

[BITS 32]

section .text

global syscall_halt

; Test syscall
syscall_halt:
    cli
    hlt
    jmp $

    ret
