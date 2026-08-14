
; IDT (Interrupt Descriptor Table) Init
; I will make minimal handlers (syscall, default ISR), other handlers later

[BITS 32]

global init_idt
extern isr_default
extern syscall_hand


section .text

init_idt:
; Default isr handler
    mov eax,isr_default
    mov word [idt + 0], ax
    mov word [idt + 2], 0x08
    mov byte [idt + 4], 0
    mov byte [idt + 5], 0b10001110
    shr eax, 16
    mov word [idt + 6], ax

; Syscalls Handler (int 0x80)
    mov eax,syscall_hand
    mov word [idt + 0x80*8 + 0], ax
    mov word [idt + 0x80*8 + 2], 0x08
    mov byte [idt + 0x80*8 + 4], 0
    mov byte [idt + 0x80*8 + 5], 0b11101110
    shr eax, 16
    mov word [idt + 0x80*8 + 6], ax

    lidt [idt_pointer] 
    ret

; It's need for address

section .data

idt:
    times 256 dq 0

idt_end:
; Pointer for IDT (Interrupt Descriptor Table)
idt_pointer:
    dw idt_end - idt - 1     
    dd idt
