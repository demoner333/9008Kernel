; VGA Driver (0xB8000) 80x25

[BITS 32]

global cursor_x
global cursor_y
global clearscreen
global printchar
global printchar_xy
global print_string_xy
global print_string

section .text

clearscreen:
; Function For clear screen
    mov ecx, -1                          ; Loop for clear screen
.loop:
    inc ecx
    mov byte [0xB8000 + ecx], 0         ; NULL Byte
    cmp ecx, (80*25) * 2
    jne .loop
    ret 

printchar_xy:
; Function for print char on X and Y position
; eax - symbol
; ebx - x
; ecx - y
; edx - color
    push ecx

    imul ecx, ecx, 80                  ; Calculating position
    add ecx, ebx
    mov [0xB8000 + ecx*2], al          ; Symbol
    mov [0xB8000 + ecx*2 + 1], dl      ; Attribute

    pop ecx

    ret

printchar:
; Function for print char on cursor_x and cursor_y
; eax - symbol
; edx - color
    push ecx 
    push ebx

    movzx ecx, word [cursor_y]         ; Moving position to registers
    movzx ebx, word [cursor_x]         

    imul ecx, ecx, 80                  ; Calculating Position
    add ecx, ebx

    cmp al, '\n' 
    je .out
    mov [0xB8000 + ecx*2], al          ; Symbol
    mov [0xB8000 + ecx*2 + 1], dl      ; Attribute
    inc word [cursor_x]                ; Incrimenting X

    cmp word [cursor_x], 80            ; If X > 80 incrimenting Y
    je .out

    pop ebx
    pop ecx

    ret
.out:
    mov word [cursor_x], 0 
    inc word [cursor_y]

    pop ebx 
    pop ecx

    ret

print_string_xy:
; Function for printing string on X and Y
; eax - pointer to string
; edx - color
; esi - count of bytes
; ebx - x
; ecx - y
    mov edi,eax
    xor ebp,ebp                                 ; Need for counter
.loop:

    cmp esi,ebp                                 ; Know, done or not done
    je .done

    movzx eax, byte [edi + ebp]                 ; Calculating address and printing char
    call printchar_xy

    inc ebx                                     ; Go to loop
    inc ebp                                     ; Go to loop
    jmp .loop
.done:
    ret

print_string:
; Function for printing string on cursor_x and cursor_y
; eax - pointer to string
; edx - color
; esi - count of bytes 
    push edi                                    
    push esi                
    mov edi,eax                                 ; For Calculate address
    xor ebp,ebp
.loop:
    cmp esi,ebp                                 ; Know, done or not
    je .done

    movzx eax, byte [edi + ebp]                 ; Calculating address and printing ch
    call printchar

    inc ebp                                     ; Go to loop
    jmp .loop

.done:
    pop esi
    pop edi
    ret
section .data
    cursor_x dw 0                       ; X position
    cursor_y dw 0                       ; Y position
