
; 32-bit Kernel assembly
; In this Code setuping GDT and calling kernel_main

[BITS 32]

; Multiboot Header
section .text
align 4

dd 0x1badb002      ; magic
dd 0x00000003      ; flags
dd 0xe4524ffb      ; Checksum

global _start
extern kernel_main

_start:
    cli                                    ; Setuping Stack
    mov esp, stack_top
    lgdt [gdt_pointer]                     ; Loading GDT
    jmp 0x08:reload_cs                     ; Reloading CS

reload_cs:
    mov ax, gdt_data_kernel - gdt_start    ; Setuping registers and call kernel_main
    mov es, ax
    mov ds, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    call kernel_main

    cli
    hlt
    jmp $

section .data

; GDT Table For Kernel
gdt_start:
    dq 0x0000000000000000      ; NULL Descriptor

; Segment For Kernel (Ring0) Code
gdt_code_kernel:
    dw 0xffff                  ; Limit
    dw 0                       ; Base            
    db 0                       ; Base
    db 0b10011010              ; Present 1, Ring 0, Task Segment, Executable, DC 0
    db 0b11001111              ; Flags: 4kb block, Not Long mode, 0, limit
    db 0                       ; Base 

; Segment For Kernel (Ring0) Data
gdt_data_kernel:
    dw 0xffff                  ; Limit
    dw 0                       ; Base            
    db 0                       ; Base
    db 0b10010010              ; Present 1, Ring 0, Task Segment, Not Executable, DC 0
    db 0b11001111              ; Flags: 4kb block, Not Long mode, 0, limit
    db 0                       ; Base 

; Segment For User (Ring3) Code
gdt_code_user:
    dw 0xffff                  ; Limit                                                   
    dw 0                       ; Base            
    db 0                       ; Base
    db 0b11111010              ; Present 1, Ring 3, Task Segment, Executable, DC 1
    db 0b11001111              ; Flags: 4kb block, Not Long mode, 0, limit
    db 0                       ; Base 

; Segment For User (Ring3) Data
gdt_data_user:
    dw 0xffff                  ; Limit                                                                 
    dw 0                       ; Base            
    db 0                       ; Base
    db 0b11110110              ; Present 1, Ring 3, Task Segment, Not Executable, DC 1
    db 0b11001111              ; Flags: 4kb block, Not Long mode, 0, limit
    db 0                       ; Base 

gdt_end:

; Pointer for GDT
gdt_pointer:
    dw gdt_end - gdt_start - 1 ; Calculating
    dd gdt_start
    
; Setup Stack
section .bss
align 16
stack_bottom:
    resb 32768 
stack_top:
