; In this file code fot isr_default and syscall 

[BITS 32]
    global isr_default
    global syscall_hand
    extern syscall_halt


section .text
; Isr i make later
isr_default:
    iret

; Int 0x80 syscall
syscall_hand:
    push eax
    push edx
    push ecx
    push ebx

    cmp eax,SYSCALL_COUNT
    jae .unknown
    call [syscall_table + eax*4]

    pop ebx
    pop ecx 
    pop edx
    pop eax

    iret

.unknown:
    mov eax,-1 
    iret 

section .data

align 1
syscall_table:
    dd syscall_halt ; 1
syscall_end:
SYSCALL_COUNT equ (syscall_end - syscall_table) / 4

