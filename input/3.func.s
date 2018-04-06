	.section	.rodata
	.int_wformat: .string "%d\n"
	.str_wformat: .string "%s\n"
	.int_rformat: .string "%d"
	.comm _gp, 8, 4
	.text
	.globl t
	.type t,@function
t:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movq %rbp, %rbx
	addq $-4, %rbx
	movl $2, %ecx
	movl %ecx, (%rbx)
	movq %rbp, %rbx
	addq $-4, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq %rbp, %rbx
	addq $-4, %rbx
	movl (%rbx), %ecx
	movl $1, %ebx
	addl %ebx, %ecx
        movl %ecx, %eax
	leave
	ret
	.globl main
	.type main,@function
main:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movq %rbp, %rbx
	addq $-4, %rbx
	movl $1, %ecx
	movl %ecx, (%rbx)
	movq $_gp, %rbx
	addq $4, %rbx
        pushq %rbx

        call t
        popq %rbx

        movl %eax, %ecx
	movl %ecx, (%rbx)
	movq %rbp, %rbx
	addq $-4, %rbx
	movl (%rbx), %ecx
	movq $_gp, %rbx
	addq $4, %rbx
	movl (%rbx), %r8d
	addl %r8d, %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	leave
	ret
