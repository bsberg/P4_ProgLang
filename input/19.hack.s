	.section	.rodata
	.int_wformat: .string "%d\n"
	.str_wformat: .string "%s\n"
	.int_rformat: .string "%d"
	.comm _gp, 4, 4
.string_const0: .string "You should not reach here"
	.text
	.globl t
	.type t,@function
t:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movq $_gp, %rbx
	addq $0, %rbx
        pushq %rbx

        call foo
        popq %rbx

        movl %eax, %ecx
	movl %ecx, (%rbx)
	movl $6, %ebx
	movq %rbp, %rcx
	addq $-16, %rcx
	movslq %ebx, %rbx
	imulq $4, %rbx
	addq %rbx, %rcx
	movl $.int_rformat, %edi
	movq %rcx, %rsi
	movl $0, %eax
	call scanf
	movl $7, %ebx
	movq %rbp, %rcx
	addq $-16, %rcx
	movslq %ebx, %rbx
	imulq $4, %rbx
	addq %rbx, %rcx
	movl $.int_rformat, %edi
	movq %rcx, %rsi
	movl $0, %eax
	call scanf
	movq $_gp, %rbx
	addq $0, %rbx
	movl (%rbx), %ecx
        movl %ecx, %eax
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

        call t
        popq %rbx

        movl %eax, %ecx
	movl %ecx, (%rbx)
	movl $.string_const0, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.str_wformat, %edi
	call printf
	leave
	ret
