TITLE Elementary Arithmetic   (program1_Rico_Christopher.asm)

; Author: Christopher Rico
; Course / Project ID  CS 271 /Assignment 1     
; Date: 7/9/17
; Description: Intro program that asks for two variables from user
;				then calculates and displays their sum, difference,
;				product, quotient, and remainder.


INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
;text to be displayed on screen
intro_1		BYTE	"Elementary Arithmetic	by Christopher Rico", 0
extra_1		BYTE	"**EC: Program verifies second number less than first.", 0
extra_2		BYTE	"**EC: Program repeats until user chooses to quit.", 0
intro_2		BYTE	"Enter two numbers, and I'll show you the", 0
intro_3		BYTE	"sum, difference, product, quotient, and remainder.", 0
prompt_A	BYTE	"First number: ", 0
prompt_B	BYTE	"Second number: ", 0
vali_1		BYTE	"The first value must be larger than the second value!", 0
repeat_prog	BYTE	"That was fun! Enter 'y' to play again, or any other key to quit.", 0
repeat_y	BYTE	'y', 0
bye_1		BYTE	"Goodbye!", 0

;math symbols to be shown on screen
plus		BYTE	" + ", 0
minus		BYTE	" - ", 0
mult		BYTE	" x ", 0
divide		BYTE	" / ", 0
equals		BYTE	" = ", 0
remainder	BYTE	" remainder ", 0

;values input by user
input_A		DWORD	?
input_B		DWORD	?

;variables to store calculated values
sum			DWORD	?	
diff		DWORD	?	
prod		DWORD	?	
quo			DWORD	?	
remain		WORD	?	

.code
main PROC

start:
;Introduce programmer and assignment
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	
	mov		edx, OFFSET extra_1
	call	WriteString
	call	CrLf

	mov		edx, OFFSET extra_2
	call	WriteString
	call	CrLf
	call	CrLf


	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf	

	mov		edx, OFFSET intro_3
	call	WriteString
	call	CrLf
	call	CrLf

;Get and validate **EXTRA CREDIT!** user input

getInput:
	;get input A
	mov		edx, OFFSET prompt_A
	call	WriteString
	call	ReadInt
	mov		input_A, eax

	;get input B
	mov		edx, OFFSET prompt_b
	call	WriteString
	call	ReadInt
	mov		input_B, eax
	call	CrLf

	;if A < B, throw error and ask again
	mov 	eax, input_A
	cmp		eax, input_B
	jge		valid
	mov		edx, OFFSET vali_1
	call	WriteString
	call	CrLF
	mov		input_A, 0
	mov		input_B, 0
	jmp		getInput

valid:

;Calculate sum
	mov		eax, input_A
	mov		ebx, input_B
	add		eax, ebx
	mov		sum, eax

;Display sum
	mov		eax, input_A
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, input_B
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf

;Calculate difference
	mov		eax, input_A
	mov		ebx, input_B
	sub		eax, ebx
	mov		diff, eax

;Display difference
	mov		eax, input_A
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, input_B
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, diff
	call	WriteInt
	call	CrLf

;Calculate product
	mov		eax, input_A
	mov		ebx, input_B
	mul		ebx
	mov		prod, eax

;Display product
	mov		eax, input_A
	call	WriteDec
	mov		edx, OFFSET mult
	call	WriteString
	mov		eax, input_B
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, prod
	call	WriteDec
	call	CrLf

;Calculate quotient and remainder
	mov		edx, 0
	mov		eax, input_A
	mov		ebx, input_B	
	div		ebx
	mov		quo, eax
	mov		remain, dx

;Display quotient and remainder
	mov		eax, input_A
	call	WriteDec
	mov		edx, OFFSET divide
	call	WriteString
	mov		eax, input_B
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, quo
	call	WriteDec
	
	mov		edx, OFFSET remainder
	call	WriteString
	mov		ax, remain
	call	WriteDec
	call	CrLf
	call	CrLf

;Ask if user wants to go again
	mov		edx, OFFSET repeat_prog
	call	WriteString
	call	CrLf
	call	ReadChar
	mov		bl, repeat_y
	cmp		al, bl
	call	CrLf
	jne		quit
	jmp		start


quit:
;Say goodbye
	call	CrLf
	mov		edx, OFFSET bye_1
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

END main
