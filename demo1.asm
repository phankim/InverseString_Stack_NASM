
section .data
    prompt db "Enter string: "
    length equ $ -prompt
    text times 255 db 0
    buffer times 255 db 0
section .text 
    global _start
_start:
        ; in ra chuoi vua nhap
        mov rax,1;system call for writing
        mov rdi,1;file handle 1 is stdout (stdout has a file descriptor of 1)
        mov rsi,prompt;address of our input string prompt
        mov rdx,length;number of length string's
        syscall;invoke OS to do the write
        
        mov rax,0   
        mov rdi,0
        mov rsi,text;ham de nhap string input
        syscall

        mov rcx,rax   ;rcx la ky tu counter
        mov rsi,text; contro  tro den ky tu hien tai, bat dau 
        add rsi,rcx;dem de tro
        dec rsi;nho chi so 0
        mov rdi,buffer

    ; ; Loop to put characters into stack
    ;     mov rax,dword[prompt]
    ;     mov rbx,text
    ;     mov r12,0
    ;     mov rax,0
    ; pushLoop:
    ;     push dword[rbx+r12*8]
    ;     inc r12
    ;     loop pushLoop
    ; ; ;All characters are on stack (in reverse order)
    ; ; ;Loop to get them back off, put them back into the original list
    ;     mov rcx,dword[prompt]
    ;     mov rbx,text
    ;     mov r12,0
    ;     loop pushLoop
    ; popLoop:
    ;     pop rax
    ;     mov dword[rbx+r12*8],rax
    ;     inc rdi
    ;     loop popLoop

    ; process_loop:
    ;     mov bl,[rsi];copy back to prompt
    ;     mov [rdi],bl
    ;     inc rdi
    ;     dec rsi
    ;     dec rax
    ;     jnz process_loop

        mov eax,1;system call for writing
        mov edi,1;ile handle 1 is stdout (stdout has a file descriptor of 1)
        mov esi,buffer;address of our input string buffer
        mov edx,ecx
        syscall
    exit:
        mov rax,60;system call for exitting
        mov rdi,0;exit code =0
        syscall