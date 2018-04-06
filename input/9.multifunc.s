	.section	.rodata
	.int_wformat: .string "%d\n"
	.str_wformat: .string "%s\n"
	.int_rformat: .string "%d"
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
	movl $1, %ebx
        movl %ebx, %eax
	leave
	ret
	.globl a2
	.type a2,@function
a2:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movl $2, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf

        call a1

        movl %eax, %ebx
        movl %ebx, %eax
	leave
	ret
	.globl a3
	.type a3,@function
a3:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movl $4, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf

        call a1

        movl %eax, %ebx
        pushq %rbx

        call a2
        popq %rbx

        movl %eax, %ecx
	addl %ecx, %ebx
        movl %ebx, %eax
	leave
	ret
	.globl a4
	.type a4,@function
a4:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movl $4, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf

        call a1

        movl %eax, %ebx
        pushq %rbx

        call a2
        popq %rbx

        movl %eax, %ecx
	addl %ecx, %ebx
        pushq %rbx

        call a3
        popq %rbx

        movl %eax, %ecx
	addl %ecx, %ebx
        movl %ebx, %eax
	leave
	ret
	.globl main
	.type main,@function
main:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp

        call a1

        movl %eax, %ebx
        pushq %rbx

        call a2
        popq %rbx

        movl %eax, %ecx
	addl %ecx, %ebx
        pushq %rbx

        call a3
        popq %rbx

        movl %eax, %ecx
	addl %ecx, %ebx
        pushq %rbx

        call a4
        popq %rbx

        movl %eax, %ecx
	addl %ecx, %ebx
	movl %ebx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	leave
	ret
