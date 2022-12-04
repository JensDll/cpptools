default rel
bits 64

global some_function

section .note.GNU-stack

section .text
some_function:  
    push    rbp
    mov     rbp, rsp
    pop     rbp
    ret
