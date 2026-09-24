	.file	"decode.c"
	.text
	.section	.rodata
.LC0:
	.string	"Your cipher text:\n%s\n"
.LC1:
	.string	"Plaintext:\n%s\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	leal	4(%esp), %ecx
	.cfi_def_cfa 1, 0
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	pushl	%ebx
	pushl	%ecx
	.cfi_escape 0xf,0x3,0x75,0x78,0x6
	.cfi_escape 0x10,0x3,0x2,0x75,0x7c
	subl	$16, %esp
	call	__x86.get_pc_thunk.bx
	addl	$_GLOBAL_OFFSET_TABLE_, %ebx
	call	read_cipher_file
	movl	%eax, -20(%ebp)
	subl	$8, %esp
	pushl	-20(%ebp)
	leal	.LC0@GOTOFF(%ebx), %eax
	pushl	%eax
	call	printf@PLT
	addl	$16, %esp
	call	get_login_key
	movl	%eax, -16(%ebp)
	subl	$8, %esp
	pushl	-16(%ebp)
	pushl	-20(%ebp)
	call	decode
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	subl	$8, %esp
	pushl	-12(%ebp)
	leal	.LC1@GOTOFF(%ebx), %eax
	pushl	%eax
	call	printf@PLT
	addl	$16, %esp
	movl	$0, %eax
	leal	-8(%ebp), %esp
	popl	%ecx
	.cfi_restore 1
	.cfi_def_cfa 1, 0
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	leal	-4(%ecx), %esp
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.section	.rodata
.LC2:
	.string	"r"
.LC3:
	.string	"cipher.txt"
	.align 4
.LC4:
	.string	"Cannot open file for reading.\n"
	.align 4
.LC5:
	.string	"Error reading cipher text file.\n"
	.text
	.globl	read_cipher_file
	.type	read_cipher_file, @function
read_cipher_file:
.LFB7:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$20, %esp
	.cfi_offset 3, -12
	call	__x86.get_pc_thunk.bx
	addl	$_GLOBAL_OFFSET_TABLE_, %ebx
	subl	$8, %esp
	leal	.LC2@GOTOFF(%ebx), %eax
	pushl	%eax
	leal	.LC3@GOTOFF(%ebx), %eax
	pushl	%eax
	call	fopen@PLT
	addl	$16, %esp
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	jne	.L4
	movl	stderr@GOT(%ebx), %eax
	movl	(%eax), %eax
	pushl	%eax
	pushl	$30
	pushl	$1
	leal	.LC4@GOTOFF(%ebx), %eax
	pushl	%eax
	call	fwrite@PLT
	addl	$16, %esp
	subl	$12, %esp
	pushl	$1
	call	exit@PLT
.L4:
	subl	$12, %esp
	pushl	$1000
	call	malloc@PLT
	addl	$16, %esp
	movl	%eax, -16(%ebp)
	subl	$4, %esp
	pushl	-20(%ebp)
	pushl	$1000
	pushl	-16(%ebp)
	call	fgets@PLT
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L5
	movl	stderr@GOT(%ebx), %eax
	movl	(%eax), %eax
	pushl	%eax
	pushl	$32
	pushl	$1
	leal	.LC5@GOTOFF(%ebx), %eax
	pushl	%eax
	call	fwrite@PLT
	addl	$16, %esp
	subl	$12, %esp
	pushl	$1
	call	exit@PLT
.L5:
	subl	$12, %esp
	pushl	-16(%ebp)
	call	strlen@PLT
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	-1(%eax), %edx
	movl	-16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	cmpb	$10, %al
	jne	.L6
	movl	-12(%ebp), %eax
	leal	-1(%eax), %edx
	movl	-16(%ebp), %eax
	addl	%edx, %eax
	movb	$0, (%eax)
.L6:
	movl	-16(%ebp), %eax
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE7:
	.size	read_cipher_file, .-read_cipher_file
	.section	.rodata
.LC6:
	.string	"Your CS login: "
.LC7:
	.string	"Error reading user input.\n"
	.text
	.globl	get_login_key
	.type	get_login_key, @function
get_login_key:
.LFB8:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$20, %esp
	.cfi_offset 3, -12
	call	__x86.get_pc_thunk.bx
	addl	$_GLOBAL_OFFSET_TABLE_, %ebx
	subl	$12, %esp
	pushl	$50
	call	malloc@PLT
	addl	$16, %esp
	movl	%eax, -16(%ebp)
	subl	$12, %esp
	leal	.LC6@GOTOFF(%ebx), %eax
	pushl	%eax
	call	printf@PLT
	addl	$16, %esp
	movl	stdin@GOT(%ebx), %eax
	movl	(%eax), %eax
	subl	$4, %esp
	pushl	%eax
	pushl	$50
	pushl	-16(%ebp)
	call	fgets@PLT
	addl	$16, %esp
	testl	%eax, %eax
	jne	.L9
	movl	stderr@GOT(%ebx), %eax
	movl	(%eax), %eax
	pushl	%eax
	pushl	$26
	pushl	$1
	leal	.LC7@GOTOFF(%ebx), %eax
	pushl	%eax
	call	fwrite@PLT
	addl	$16, %esp
	subl	$12, %esp
	pushl	$1
	call	exit@PLT
.L9:
	subl	$12, %esp
	pushl	-16(%ebp)
	call	strlen@PLT
	addl	$16, %esp
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	-1(%eax), %edx
	movl	-16(%ebp), %eax
	addl	%edx, %eax
	movzbl	(%eax), %eax
	cmpb	$10, %al
	jne	.L10
	movl	-12(%ebp), %eax
	leal	-1(%eax), %edx
	movl	-16(%ebp), %eax
	addl	%edx, %eax
	movb	$0, (%eax)
.L10:
	movl	-16(%ebp), %eax
	movl	-4(%ebp), %ebx
	leave
	.cfi_restore 5
	.cfi_restore 3
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE8:
	.size	get_login_key, .-get_login_key
	.globl	decode
	.type	decode, @function
decode:
.LFB9:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	call	__x86.get_pc_thunk.ax
	addl	$_GLOBAL_OFFSET_TABLE_, %eax
	subl	$12, %esp
	pushl	12(%ebp)
	call	calculate_shifts
	addl	$16, %esp
	movl	%eax, -20(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -24(%ebp)
	jmp	.L13
.L17:
	movl	-24(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$96, %al
	jle	.L19
	movl	-24(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$122, %al
	jg	.L19
	movl	-24(%ebp), %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	subl	$97, %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %edx
	movl	-20(%ebp), %eax
	leal	(%edx,%eax), %ecx
	movl	$1321528399, %edx
	movl	%ecx, %eax
	imull	%edx
	movl	%edx, %eax
	sarl	$3, %eax
	movl	%ecx, %edx
	sarl	$31, %edx
	subl	%edx, %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	imull	$26, %eax, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	movl	%edx, -12(%ebp)
	movl	-12(%ebp), %eax
	addl	$97, %eax
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	movb	%dl, (%eax)
	jmp	.L16
.L19:
	nop
.L16:
	addl	$1, -24(%ebp)
.L13:
	movl	-24(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L17
	movl	8(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE9:
	.size	decode, .-decode
	.globl	calculate_shifts
	.type	calculate_shifts, @function
calculate_shifts:
.LFB10:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	call	__x86.get_pc_thunk.ax
	addl	$_GLOBAL_OFFSET_TABLE_, %eax
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	$0, -4(%ebp)
	jmp	.L21
.L22:
	movl	-8(%ebp), %eax
	movzbl	(%eax), %eax
	movsbl	%al, %eax
	xorl	%eax, -4(%ebp)
	addl	$1, -8(%ebp)
.L21:
	movl	-8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L22
	movl	-4(%ebp), %ecx
	movl	$1321528399, %edx
	movl	%ecx, %eax
	imull	%edx
	movl	%edx, %eax
	sarl	$3, %eax
	movl	%ecx, %edx
	sarl	$31, %edx
	subl	%edx, %eax
	imull	$26, %eax, %edx
	movl	%ecx, %eax
	subl	%edx, %eax
	movl	%eax, %edx
	negl	%edx
	cmovns	%edx, %eax
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jne	.L23
	movl	$1, -4(%ebp)
.L23:
	movl	-4(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE10:
	.size	calculate_shifts, .-calculate_shifts
	.section	.text.__x86.get_pc_thunk.ax,"axG",@progbits,__x86.get_pc_thunk.ax,comdat
	.globl	__x86.get_pc_thunk.ax
	.hidden	__x86.get_pc_thunk.ax
	.type	__x86.get_pc_thunk.ax, @function
__x86.get_pc_thunk.ax:
.LFB11:
	.cfi_startproc
	movl	(%esp), %eax
	ret
	.cfi_endproc
.LFE11:
	.section	.text.__x86.get_pc_thunk.bx,"axG",@progbits,__x86.get_pc_thunk.bx,comdat
	.globl	__x86.get_pc_thunk.bx
	.hidden	__x86.get_pc_thunk.bx
	.type	__x86.get_pc_thunk.bx, @function
__x86.get_pc_thunk.bx:
.LFB12:
	.cfi_startproc
	movl	(%esp), %ebx
	ret
	.cfi_endproc
.LFE12:
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
