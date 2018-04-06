	.section	.rodata
	.int_wformat: .string "%d\n"
	.str_wformat: .string "%s\n"
	.int_rformat: .string "%d"
	.comm _gp, 44, 4
	.text
	.globl f1
	.type f1,@function
f1:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movq %rbp, %rbx
	addq $-4, %rbx
	movl $9, %ecx
	movl %ecx, (%rbx)
.L0:	nop
	movq %rbp, %rbx
	addq $-4, %rbx
	movl (%rbx), %ecx
	movl $0, %ebx
	cmpl %ebx, %ecx
	movl $0, %ecx
	movl $1, %ebx
	cmovge %ebx, %ecx
	movl $-1, %ebx
	testl %ecx, %ebx
	je .L1
	movq %rbp, %rbx
	addq $-4, %rbx
	movl (%rbx), %ecx
	movq $_gp, %rbx
	addq $4, %rbx
	movslq %ecx, %rcx
	imulq $4, %rcx
	addq %rcx, %rbx
	movq %rbp, %rcx
	addq $-4, %rcx
	movl (%rcx), %r8d
	movq $_gp, %rcx
	addq $4, %rcx
	movslq %r8d, %r8
	imulq $4, %r8
	addq %r8, %rcx
	movl (%rcx), %r8d
	movl $1, %ecx
	subl %ecx, %r8d
	movl %r8d, (%rbx)
	movq %rbp, %rbx
	addq $-4, %rbx
	movq %rbp, %rcx
	addq $-4, %rcx
	movl (%rcx), %r8d
	movl $1, %ecx
	subl %ecx, %r8d
	movl %r8d, (%rbx)
	jmp .L0
.L1:	 nop
	movl $5, %ebx
	movq $_gp, %rcx
	addq $4, %rcx
	movslq %ebx, %rbx
	imulq $4, %rbx
	addq %rbx, %rcx
	movl (%rcx), %ebx
        movl %ebx, %eax
	leave
	ret
	.globl f2
	.type f2,@function
f2:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movq %rbp, %rbx
	addq $-4, %rbx
	movl $0, %ecx
	movl %ecx, (%rbx)
.L2:	nop
	movq %rbp, %rbx
	addq $-4, %rbx
	movl (%rbx), %ecx
	movl $10, %ebx
	cmpl %ebx, %ecx
	movl $0, %ecx
	movl $1, %ebx
	cmovl %ebx, %ecx
	movl $-1, %ebx
	testl %ecx, %ebx
	je .L3
	movq %rbp, %rbx
	addq $-4, %rbx
	movl (%rbx), %ecx
	movl $5, %ebx
	cmpl %ebx, %ecx
	movl $0, %ecx
	movl $1, %ebx
	cmovl %ebx, %ecx
	movl $-1, %ebx
	testl %ecx, %ebx
	je .L4
	movq %rbp, %rbx
	addq $-4, %rbx
	movl (%rbx), %ecx
	movq %rbp, %rbx
	addq $-44, %rbx
	movslq %ecx, %rcx
	imulq $4, %rcx
	addq %rcx, %rbx
	movl $0, %ecx
	movl %ecx, (%rbx)
	jmp .L5
.L4:	 nop
	movq %rbp, %rbx
	addq $-4, %rbx
	movl (%rbx), %ecx
	movq %rbp, %rbx
	addq $-44, %rbx
	movslq %ecx, %rcx
	imulq $4, %rcx
	addq %rcx, %rbx
	movl $1, %ecx
	movl %ecx, (%rbx)
.L5:	 nop
	movq %rbp, %rbx
	addq $-4, %rbx
	movq %rbp, %rcx
	addq $-4, %rcx
	movl (%rcx), %r8d
	movl $1, %ecx
	addl %ecx, %r8d
	movl %r8d, (%rbx)
	jmp .L2
.L3:	 nop
	movl $9, %ebx
	movq %rbp, %rcx
	addq $-44, %rcx
	movslq %ebx, %rbx
	imulq $4, %rbx
	addq %rbx, %rcx
	movl (%rcx), %ebx
        movl %ebx, %eax
	leave
	ret
	.globl main
	.type main,@function
main:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movq %rbp, %rbx
	addq $-8, %rbx
	movl $0, %ecx
	movl %ecx, (%rbx)
.L6:	nop
	movq %rbp, %rbx
	addq $-8, %rbx
	movl (%rbx), %ecx
	movl $10, %ebx
	cmpl %ebx, %ecx
	movl $0, %ecx
	movl $1, %ebx
	cmovl %ebx, %ecx
	movl $-1, %ebx
	testl %ecx, %ebx
	je .L7
	movq %rbp, %rbx
	addq $-8, %rbx
	movl (%rbx), %ecx
	movq %rbp, %rcx
	addq $-8, %rcx
	movl (%rcx), %r8d
	movq %rbp, %rcx
	addq $-8, %rcx
	movl (%rcx), %r9d
	imull %r9d, %r8d
	movl %r8d, (%rbx)
	movq %rbp, %rbx
	addq $-8, %rbx
	movq %rbp, %rcx
	addq $-8, %rcx
	movl (%rcx), %r8d
	movl $1, %ecx
	addl %ecx, %r8d
	movl %r8d, (%rbx)
	jmp .L6
.L7:	 nop

        call f1

        movl %eax, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq %rbp, %rbx
	addq $-8, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf

        call f2

        movl %eax, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq %rbp, %rbx
	addq $-8, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movl $9, %ebx
	movl (%rcx), %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	leave
	ret
