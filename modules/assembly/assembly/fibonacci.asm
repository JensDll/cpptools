default rel
bits 64

global fibonacci

section .note.GNU-stack

section .text
fibonacci:  
    push    rbp                     ; Save return the return address of the caller
    mov     rbp, rsp
    push    r12                     ; Save any register fibonacci will use
    push    rbx
    mov     rbx, rdi                ; Get n and save it in rbx
    cmp     rbx, 2                  ; Check if n==2 (sets either SF or OF)
    jge     fibonacci_recurse       ; Jump if n>=2 (sign flag [SF] = overflow flag [OF])
    mov     rax, rbx                ; Return n by moving it into rax
    jmp     fibonacci_epilogue

fibonacci_recurse:
    lea     rdi, [rbx-1]            ; Compute n-1 and store the result in rdi
    call    fibonacci               ; Call fibonacci recursively with n-1 in rdi
    mov     r12, rax                ; Save the result of fibonacci in r12
    sub     rbx, 2                  ; Compute n-2 and save the result in rbx
    mov     rdi, rbx                ; Move n-2 to rdi
    call    fibonacci               ; Call fibonacci recursively with n-2 in rdi
    add     rax, r12                ; Add fibonacci(n-1) and fibonacci(n-2) and save the result in rax

fibonacci_epilogue:
    pop     rbx                     ; Pop all saved registers and return
    pop     r12
    pop     rbp
    ret
