section .data
	SYS_WRITE	equ 1
	STD_OUT		equ 1
	SYS_EXIT	equ 60
	EXIT_CODE	equ 0
	NEW_LINE	db 0xa
	;Define Data - - - - - - - - - - 
	Input db "SPB_ETU",10
	length equ $ -Input
section .bss
    OUTPUT resb 1
section .text
	global _start
_start:
	;print input string
	mov rax, SYS_WRITE
	mov rdi, STD_OUT
	mov rsi, Input
	mov rdx, length
	syscall

	mov rsi,Input ;get address of Input
	xor rcx,rcx ;zeroize rcx for counter
	cld ; df=0 si++
	mov rdi,$+15
	call StrLen ; call function to calculate string's length
	xor rax,rax ; write 0 to rax
	xor rdi,rdi ; additional counter for reverseStr
	jmp reverseStr ;jump to function reverseStr
StrLen:
	cmp byte[rsi],0 ;check if it is end of the string
	je exitCheck ;yes - so exit from loop
	lodsb ; load byte from rsi to al and increase rsi
	push rax ;push symbol to stack
	inc rcx
	jmp StrLen ;Loop again
exitCheck:
	;push return address to stack again
	push rdi 
	ret ;return to start
reverseStr:
	cmp rcx,0;check if it is end of string
	je printResult ;if yes print string
	pop rax ;pop symbol from stack
	mov [OUTPUT+rdi],rax ;write it to output buffer
	dec rcx
	inc rdi
	jmp reverseStr
printResult:
	mov rdx,rdi
	mov rax, 1
	mov rdi, 1
	mov rsi,OUTPUT
	syscall
	jmp printNewLine
printNewLine:
	mov rax,SYS_WRITE
	mov rdi,STD_OUT
	mov rsi,NEW_LINE
	mov rdx,1
	syscall
	jmp _exit
_exit:
	mov rax, SYS_EXIT
	mov rdi, EXIT_CODE
	syscall
