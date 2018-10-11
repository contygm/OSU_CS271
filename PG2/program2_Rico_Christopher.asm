TITLE Fibonacci Numbers     (program2_Rico_Christopher.asm)

; Author: Christopher Rico
; CS 271 / Assignment 2                 
; Date: 7/16/17
; Description: Display the program title and programmer’s name.  
;				Then get the user’s name, and greet the user.
;				Prompt the user to enter the number of Fibonacci terms to be displayed.
;				Advise the user to enter an integer in the range [1 .. 46]. 
;				Get and validate the user input (n) 
;				Calculate and display all of the Fibonacci numbers up to and including the nth term.
;				Display a parting message that includes the user’s name, and terminate the program.

INCLUDE Irvine32.inc

MAX = 46
MIN = 1

.data
;text to be displayed on screen
intro_1		BYTE	"Fibonacci Numbers: Programmed by Christopher Rico", 0
extra_1		BYTE	"**EC: Do something incredible. Text color changes with invalid data input.", 0
prompt_1	BYTE	"What's your name? ", 0
hello_1		BYTE	"Hey, ", 0
prompt_2	BYTE	"Enter the number of Fibonacci terms to be displayed.", 0 
prompt_3	BYTE	"Give the number as an integer in the range 1-46.", 0
prompt_4	BYTE	"How many Fibonacci terms do you want? ", 0
vali_hi		BYTE	"That's too high! Enter 46 or below. ", 0
vali_lo		BYTE	"That's too low! Enter 1 or above. ", 0
spaces		BYTE	"     ", 0
certified	BYTE	"Results certified by Chris Rico.", 0
goodbye		BYTE	"Goodbye, ", 0

;values input by user
userName	BYTE 	33 DUP(0)
userChoice	DWORD	?

;variables for calculations
prevNum		DWORD	1
prevNum2	DWORD	1
holdMe		DWORD	?
fiveLine	DWORD	5
counter		DWORD	0

;E.C.: Do something incredible. Changing text and background when user enters invalid data
colVar		DWORD	16

.code
main PROC

;EC: Do something incredible. Set text, background color	
		mov		eax, white + (black *16)
		call	SetTextColor

;introduction
		mov		edx, OFFSET intro_1
		call	WriteString
		call	CrLf

		mov		edx, OFFSET extra_1
		call	WriteString
		call	CrLf
		call	CrLf		

		;get user name
		mov		edx, OFFSET prompt_1
		call	WriteString
		mov 	edx, OFFSET userName
		mov		ecx, SIZEOF userName
		call	ReadString
	
		;say hello to user
		call	CrLf
		mov		edx, OFFSET hello_1
		call	WriteString
		mov 	edx, OFFSET userName
		call	WriteString
		call	CrLf
	
;user instructions
		mov 	edx, OFFSET prompt_2
		call	WriteString
		call	CrLf
		mov 	edx, OFFSET prompt_3
		call	WriteString
		call	CrLf
		call	CrLf
	prompt:	
		mov 	edx, OFFSET prompt_4
		call	WriteString
		mov		eax, white + (black * 16) ; EC: Return text and background color to original
		call	SetTextColor
		call	CrLf
	
;get user data
		call	ReadInt
		mov		userChoice, eax
		call	CrLf

		;validate user data
		mov		eax, userChoice
		cmp		eax, MIN
		jl		lowVal		
		mov		eax, userChoice
		cmp		eax, MAX
		jg		highVal


;display fibs			
	fibLoop:
		;display first two values using inital loop
		mov		eax, 1
		call	WriteDec
		mov		edx, OFFSET spaces
		call	WriteString
		inc		counter
		cmp		counter, 1
		jg		fibLoop2
		loop	fibLoop

	fibLoop2:
		;calculate and display next number in sequence
		add		eax, prevNum2
		call	WriteDec
		mov		edx, OFFSET spaces
		call	WriteString

		;bump numbers in sequence back one 'position'
		mov		holdMe, eax
		mov		eax, prevNum
		mov		prevNum2, eax
		mov		eax, holdMe
		mov		prevNum, eax
		inc		counter
		mov		ecx, userChoice
		cmp		counter, ecx
		je		progEnd

		;line spacing - every 5 terms
		mov		edx, 0
		mov		eax, counter
		div		fiveLine
		cmp		edx, 0
		jne		nolineDown
		call	CrLf

	noLineDown:
		;give eax its value back
		mov		eax, holdMe
		loop	fibLoop2


;validate data
	lowVal:
		mov		eax, black +(lightRed * 16) ; EC: set color to alert user
		call	SetTextColor
		mov		edx, OFFSET vali_lo
		call	WriteString
		call	CrLf
		jmp		prompt

	highVal:
		mov		eax, black +(lightRed * 16) ; EC: set color to alert user
		call	SetTextColor
		mov		edx, OFFSET vali_hi
		call	WriteString
		call	CrLf
		jmp		prompt	


;farewell
	progEnd:
		call	CrLf
		call	CrLf
		mov 	edx, OFFSET certified
		call	WriteString
		call	CrLf

		mov 	edx, OFFSET goodbye
		call	WriteString
		mov 	edx, OFFSET userName
		call	WriteString
		call	CrLf

	exit	; exit to operating system
main ENDP

END main
