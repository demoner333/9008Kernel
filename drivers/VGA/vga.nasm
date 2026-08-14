; VGA Driver (0xB8000) 80x25

[BITS 32]

global cursor_x
global cursor_y
global clearscreen
global printchar
global printchar_xy

section .text

clearscreen:
; Function For clear screen
    mov ecx, (80*25) * 2                ; Loop for clear screen
.loop:
    mov byte [0xB8000 + ecx], 0         ; NULL Byte
    loop .loop                          ; Jump to loop
    ret 

printchar_xy:
; Function for print char on X and Y position
; eax - symbol
; ebx - x
; ecx - y
; edx - color
    imul ecx, ecx, 80                   ; Calculating position
    add ecx, ebx
    mov [0xB8000 + ecx*2], eax          ; Symbol
    mov [0xB8000 + ecx*2 + 1], edx      ; Attribute
    ret

printchar:
; Function for print char on cursor_x and cursor_y
; eax - symbol
; edx - color
    movzx ecx, word [cursor_y]          ; Moving position to registers
    movzx ebx, word [cursor_x]          

    imul ecx, ecx, 80                   ; Calculating Position
    add ecx, ebx

    mov [0xB8000 + ecx*2], eax          ; Symbol
    mov [0xB8000 + ecx*2 + 1], edx      ; Attribute

    cmp word [cursor_x], 80             ; If X > 80 incrimenting Y
    je .out

    inc word [cursor_x]                 ; Incrimenting X
    ret
.out:
    mov word [cursor_x], 0 
    inc word [cursor_y]
    ret

section .data
    cursor_x dw 0                       ; X position
    cursor_y dw 0                       ; Y position
