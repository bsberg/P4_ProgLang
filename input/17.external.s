	.section	.rodata
	.int_wformat: .string "%d\n"
	.str_wformat: .string "%s\n"
	.int_rformat: .string "%d"
	.comm _gp, 4, 4
	.text
	.globl main
	.type main,@function
main:	nop
	pushq %rbp
	movq %rsp, %rbp
	subq $2048, %rsp
	movq $_gp, %rbx
	addq $0, %rbx
        pushq %rbx

        call sum100
        popq %rbx

        movl %eax, %ecx
	movl %ecx, (%rbx)
	movq $_gp, %rbx
	addq $0, %rbx
	movl (%rbx), %ecx
	movl %ecx, %esi
	movl $0, %eax
	movl $.int_wformat, %edi
	call printf
	leave
	ret
