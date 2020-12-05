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
	

		mov rsi,Input ; получить адрес строки Input
		xor rcx,rcx ; обнулить rcx для счетчика
		cld ; df=0 si++
		mov rdi,$+15
		call StrLen ; вызвать функцию для вычисления длины строки
		xor rax,rax ; написать 0 в rax
		xor rdi,rdi ; дополнительный счетчик для reverseStr
		jmp reverseStr ; перейти к функции reverseStr
	StrLen:
		cmp byte[rsi],0 ; проверить, является ли это концом строки
		je exitCheck ; да - так что выход из цикла
		lodsb ; загрузить байт из RSI в AL и увеличить RSI
		push rax ; поместить символ в стек
		inc rcx
		jmp StrLen ; Цикл снова
	exitCheck:
		; снова отправить адрес возврата в стек
		push rdi 
		ret ; вернуться к началу
	reverseStr:
		cmp rcx,0; проверить, является ли это концом строки
		je printResult ; да - так что выход из цикла
		pop rax ; вытаскивать символы из стека
		mov [OUTPUT+rdi],rax ; записать его в выходной буфер
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
