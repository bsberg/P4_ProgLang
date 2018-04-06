	.section	.rodata
	.int_wformat: .string "%d\n"
	.str_wformat: .string "%s\n"
	.int_rformat: .string "%d"
	.comm _gp, 16, 4
	.text
	.globl a1
	.type a1,@function
a1:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movl $1, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movl $0, %ebx
        movl %ebx, %eax
	leave
	ret
	.globl a2
	.type a2,@function
a2:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movq $_gp, %rbx
	addq $4, %rbx
        pushq %rbx

        call a1
        popq %rbx

        movl %eax, %ecx
	movl %ecx, (%rbx)
	movl $2, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movl $0, %ebx
        movl %ebx, %eax
	leave
	ret
	.globl a3
	.type a3,@function
a3:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movq $_gp, %rbx
	addq $0, %rbx
        pushq %rbx

        call a1
        popq %rbx

        movl %eax, %ecx
	movl %ecx, (%rbx)
	movq $_gp, %rbx
	addq $4, %rbx
        pushq %rbx

        call a2
        popq %rbx

        movl %eax, %ecx
	movl %ecx, (%rbx)
	movl $3, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movl $0, %ebx
        movl %ebx, %eax
	leave
	ret
	.globl a4
	.type a4,@function
a4:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movq $_gp, %rbx
	addq $0, %rbx
        pushq %rbx

        call a1
        popq %rbx

        movl %eax, %ecx
	movl %ecx, (%rbx)
	movq $_gp, %rbx
	addq $4, %rbx
        pushq %rbx

        call a2
        popq %rbx

        movl %eax, %ecx
	movl %ecx, (%rbx)
	movq $_gp, %rbx
	addq $8, %rbx
        pushq %rbx

        call a3
        popq %rbx

        movl %eax, %ecx
	movl %ecx, (%rbx)
	movl $4, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movl $0, %ebx
        movl %ebx, %eax
	leave
	ret
	.globl main
	.type main,@function
main:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movq $_gp, %rbx
	addq $0, %rbx
        pushq %rbx

        call a1
        popq %rbx

        movl %eax, %ecx
	movl %ecx, (%rbx)
	movq $_gp, %rbx
	addq $4, %rbx
        pushq %rbx

        call a2
        popq %rbx

        movl %eax, %ecx
	movl %ecx, (%rbx)
	movq $_gp, %rbx
	addq $8, %rbx
        pushq %rbx

        call a3
        popq %rbx

        movl %eax, %ecx
	movl %ecx, (%rbx)
	movq $_gp, %rbx
	addq $12, %rbx
        pushq %rbx

        call a4
        popq %rbx

        movl %eax, %ecx
	movl %ecx, (%rbx)
	leave
	ret
