
; This is keyboard driver for PS/2

[BITS 32]

global read_key
global wait_read_key
global wait_ascii_key

section .text

read_key:
    in al, 0x60            ; Read key from PS/2 Port (0x60)
    ret

wait_read_key:
.loop:
    in al,0x64             ; Read Status from 0x64
    test al,1              ; If key presses read if not waiting
    jz .loop
    in al,0x60             ; Read fkey from PS/2
    ret

wait_ascii_key:
    call wait_read_key     ; Waiting Key
;    test al,0x80           ; Check, >= 0x80 mean the key was released
;    jne .unknown            

    cmp al, 58             ; 58 is Max scan code
    jae .unknown

    movzx eax, al          ; Zero-extend scan code
    mov al, [scan_code_table + eax]

    ret

.unknown:
    xor al,al
    ret

section .rodata
scan_code_table:
    db 0,  27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 8,
    db 9,  'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 10, 0,
    db 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', "'", '`', 0,   '\', 
    db 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0,   '*', 0,   ' ', 
    db 0                 
