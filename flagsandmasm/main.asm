
includelib kernel32.lib
includelib msvcrt.lib

GetStdHandle proto
WriteFile proto	
ReadFile proto	
ExitProcess  proto	
.data
	
hStdIn dq	? 
hStdOut dq	?


msg db "give me  n!", 10,0
cor_msg db "You got it right!",10,0

err_msg db "input doesn't make sense!", 10,0

msgln db ?


in_buffer db 100 dup( ?); hundred bytes 
.code
main proc
	;mov [destination]

	sub rsp, 28h        ; space for 4 arguments + 16byte aligned stack
	;-------getting handles ---
	;----stdin
	mov rcx, -11
	call GetStdHandle
	mov [hStdOut], rax; DWORD hStdOut = GetStdHandle(-11);
	;-----stdout
	mov rcx, -10
	call GetStdHandle
	mov [hStdIn], rax;DWORD hStdIn = GetStdHandle(-10);

	add rsp, 28h
	;-------end getting handles 


	
	mov rcx, hStdOut
	mov rdx, offset msg
	mov r8, 12
	call WriteFile
	add rsp, 28h
	;-------end write to stdout 	
	wait_unit:
	;-------start read from stdin
		sub	rsp, 28h
		mov rcx, hStdIn
		mov rdx, offset in_buffer
		mov r8, 1
		call ReadFile 		
		add rsp, 28h	
		;------finish read 
		;---start jumping 
		cmp in_buffer, 'n';xor aka if in_buffer == 'y' set ZF to 1 
		je correct;//if zf ==1 jump to label

		;end jumps 
		;all input was incorrect, tell user 
		sub rsp, 28h
		mov rcx, hStdOut
		mov rdx, offset err_msg
		mov r8, 27
		call WriteFile
		add rsp, 28h

		;reapeat
		jmp	wait_unit
	correct:
		sub rsp, 28h
		mov rcx, hStdOut
		mov rdx, offset cor_msg
		mov r8, 18
		call WriteFile
		add rsp, 28h




	call ExitProcess

main endp

end