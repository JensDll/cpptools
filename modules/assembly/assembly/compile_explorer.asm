global compile_explorer

section .text

compile_explorer:
        push    rbp
        push    rbx
        push    rax
        mov     ebx, edi
        xor     ebp, ebp
        cmp     edi, 2
        jge     .LBB0_2
        mov     ecx, ebx
        jmp     .LBB0_4
.LBB0_2:
        xor     ebp, ebp
.LBB0_3:
        lea     edi, [rbx - 1]
        call    compile_explorer
        lea     ecx, [rbx - 2]
        add     ebp, eax
        cmp     ebx, 3
        mov     ebx, ecx
        ja      .LBB0_3
.LBB0_4:
        add     ebp, ecx
        mov     eax, ebp
        add     rsp, 8
        pop     rbx
        pop     rbp
        ret
