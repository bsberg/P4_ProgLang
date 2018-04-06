	.section	.rodata
	.int_wformat: .string "%d\n"
	.str_wformat: .string "%s\n"
	.int_rformat: .string "%d"
	.comm _gp, 16, 4
	.text
	.globl b4
	.type b4,@function
b4:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movl $4, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq $_gp, %rbx
	addq $0, %rbx
	movl (%rbx), %ecx
	movl $1, %ebx
	addl %ebx, %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq $_gp, %rbx
	addq $0, %rbx
	movl (%rbx), %ecx
	movl $1, %ebx
	addl %ebx, %ecx
        movl %ecx, %eax
	leave
	ret
	.globl d2
	.type d2,@function
d2:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movq $_gp, %rbx
	addq $4, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq $_gp, %rbx
	addq $0, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq %rbp, %rbx
	addq $-4, %rbx
	movq $_gp, %rcx
	addq $0, %rcx
	movl (%rcx), %r8d
	movl %r8d, (%rbx)
	movq $_gp, %rbx
	addq $0, %rbx
	movq $_gp, %rcx
	addq $4, %rcx
	movl (%rcx), %r8d
	movl %r8d, (%rbx)
	movq $_gp, %rbx
	addq $4, %rbx
	movq %rbp, %rcx
	addq $-4, %rcx
	movl (%rcx), %r8d
	movl %r8d, (%rbx)
	movl $1, %ebx
        movl %ebx, %eax
	leave
	ret
	.globl d3
	.type d3,@function
d3:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movq $_gp, %rbx
	addq $0, %rbx
	movq $_gp, %rcx
	addq $0, %rcx
	movl (%rcx), %r8d
	movl $1, %ecx
	addl %ecx, %r8d
	movl %r8d, (%rbx)
	movq $_gp, %rbx
	addq $4, %rbx
	movq $_gp, %rcx
	addq $4, %rcx
	movl (%rcx), %r8d
	movl $2, %ecx
	addl %ecx, %r8d
	movl %r8d, (%rbx)
	movq $_gp, %rbx
	addq $8, %rbx
	movq $_gp, %rcx
	addq $8, %rcx
	movl (%rcx), %r8d
	movl $3, %ecx
	addl %ecx, %r8d
	movl %r8d, (%rbx)
	movq $_gp, %rbx
	addq $12, %rbx
	movq $_gp, %rcx
	addq $12, %rcx
	movl (%rcx), %r8d
	movl %r8d, (%rbx)
	movq $_gp, %rbx
	addq $8, %rbx
	movl (%rbx), %ecx
        movl %ecx, %eax
	leave
	ret
	.globl d1
	.type d1,@function
d1:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movq %rbp, %rbx
	addq $-4, %rbx
	movq $_gp, %rcx
	addq $0, %rcx
	movl (%rcx), %r8d
	movl $200, %ecx
	imull %ecx, %r8d
	movl %r8d, (%rbx)
	movq $_gp, %rbx
	addq $0, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq %rbp, %rbx
	addq $-4, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq $_gp, %rbx
	addq $8, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq $_gp, %rbx
	addq $12, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf

        call d2

        movl %eax, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq $_gp, %rbx
	addq $0, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq %rbp, %rbx
	addq $-4, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq $_gp, %rbx
	addq $8, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq $_gp, %rbx
	addq $12, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf

        call d3

        movl %eax, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq $_gp, %rbx
	addq $0, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq %rbp, %rbx
	addq $-4, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq $_gp, %rbx
	addq $8, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq $_gp, %rbx
	addq $12, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq %rbp, %rbx
	addq $-4, %rbx
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
	movl $1, %ecx
	movl %ecx, (%rbx)
	movq %rbp, %rbx
	addq $-4, %rbx
	movl $2, %ecx
	movl %ecx, (%rbx)
	movq $_gp, %rbx
	addq $8, %rbx
	movl $3, %ecx
	movl %ecx, (%rbx)
	movq $_gp, %rbx
	addq $12, %rbx
	movl $4, %ecx
	movl %ecx, (%rbx)
	movq $_gp, %rbx
	addq $0, %rbx
	movl $2, %ecx
	movl %ecx, (%rbx)

        call b4

        movl %eax, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf

        call d1

        movl %eax, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	movq $_gp, %rbx
	addq $0, %rbx
	movl $1, %ecx
	movl %ecx, (%rbx)

        call b4

        movl %eax, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	leave
	ret
