default rel
bits 64

global some_function

section .note.GNU-stack

section .text
some_function:  
    push    rbp
    mov     rbp, rsp
    push    0x11_11_11_11
    push    0x22_22_22_22
    pop     rax
    pop     rax
    mov     rax, 33
    pop     rbp
    ret
