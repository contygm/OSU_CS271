TITLE Composite Numbers     (program3_Rico_Christopher.asm)

; Author: Christopher Rico
; CS 271 / Assignment 2                 
; Date: 7/16/17
; Description: Program to calculate composite numbers
;			   User is instructed to enter # of composites to be displayed btwn 1-400
;			   This entry is validated.
;			   Then, program calculates and displays up to and including the nth composite.
;			   Results displayed 10 composites per line with 3 spaces between numbers.

INCLUDE Irvine32.inc

; definitions for max and min composite numbers to be shown
MIN = 1
MAX = 400
SQMAX = 23

.data
;text to be displayed on screen
intro_1			BYTE	"Composite Numbers: Programmed by Christopher Rico", 0
prompt_2		BYTE	"Enter the number of composite numbers you would like to see.", 0 
prompt_3		BYTE	"I'll accept orders for up to 400 composites.", 0
prompt_4		BYTE	"Enter the number of composites to display [1 - 400]: ", 0
vali			BYTE	"Out of range. Please enter a number 1 - 400: ", 0
spaces			BYTE	"   ", 0
goodbye			BYTE	"Results certified by Chris Rico. Goodbye.", 0

;values input by user
userChoice		DWORD	?
	
;variables for calculations
tenLine			DWORD	10
writeCount		DWORD	0	;count of composite numbers written to the screen
listNum			DWORD	4	;variable to hold place in list of numbers to be checked for composite
boolComp		DWORD	?	;value to be returned if number is a composite
perfSqComp		DWORD	2	;every one of first 400 composite numbers has a factor 2-23

.code
main PROC
	call	intro
	call	getUserData
	call	showComposites
	call	farewell
	exit	; exit to operating system

main ENDP


;***************************************************************
;						PROCEDURES							   *
;***************************************************************

;*************************************************************
;* Intro procedure											 *
;* Introduces program and gives user instructions			 *
;* Registers changed: EDX									 *
;*************************************************************
intro PROC

	mov		edx, OFFSET intro_1	
	call	WriteString
	call	CrLf
	call	CrLf

	mov 	edx, OFFSET prompt_2		
	call	WriteString
	call	CrLf
	
	mov 	edx, OFFSET prompt_3
	call	WriteString
	call	CrLf
	call	CrLf

	ret
intro ENDP

;*************************************************************
;* getUserData procedure									 *
;* Asks user for number of composite terms 					 *
;* Validates the number of terms to be  1-400				 *
;* Registers changed: EAX, EDX								 *
;*************************************************************
getUserData PROC

;prompt user
		mov 	edx, OFFSET prompt_4
		call	WriteString

;get user data
		call	ReadInt
		mov		userChoice, eax
		call	CrLf
		call	validate

		ret
getUserData ENDP

;*************************************************************
;* showComposites procedure									 *
;* Displays composite numbers 								 *
;* Showing 10 per line with 3 spaces between each			 *
;* Registers changed: ECX, EAX, EDX							 *
;*************************************************************
showComposites PROC

	levelOne:	
		;Check that # printed integers is not greater than number user chose
		mov		ecx, writeCount
		cmp		ecx, userChoice		
		jge		exitLoop					;if greater, exit
	

		levelTwo:
			;check if next number in the list is composite
			push	OFFSET boolComp
			push	listNum
			call	isComposite

			;if it is a composite, print it
			mov		eax, boolComp
			cmp		eax, 1	
			je		levelThree				
			
			;otherwise, increment and check again
			inc		listNum
			jmp		levelTwo


			levelThree:
				;check to see if multiples of 10 have been printed
				mov		edx, 0
				mov		eax, writeCount			
				div		tenLine
				cmp		edx, 0

				;if no, print the number
				jne		printComposite	
				
				;if yes, line down then print the number					
				call	CrLf				
				jmp		printComposite						
				

				printComposite:
					;print the composite number and spaces
					mov		eax, listNum
					call	WriteDec
					mov		edx, OFFSET spaces				
					call	WriteString

					;increment both the count of numbers printed, and the number to be checked
					inc		listNum
					inc		writeCount

					;go back to the top of the loop
					jmp		levelOne

		exitLoop:
		ret	
showComposites ENDP

;*************************************************************
;* farewell procedure										 *
;* Displays "Results certified by Chris Rico				 *
;* "Goodbye"												 *
;* Registers changed: EDX									 *
;*************************************************************
farewell PROC

	call	CrLf
	call	CrLf
	mov 	edx, OFFSET goodbye
	call	WriteString
	call	CrLf

	ret
farewell ENDP


;***************************************************************
;					SUB-PROCEDURES							   *
;***************************************************************

;*************************************************************
;* validate sub-procedure									 *
;* Validates that user input is within specified range  	 *
;*															 *
;* Registers changed: EDX, EAX	    						 *
;*************************************************************
validate PROC

;check that number is within range
	compare:
		mov		eax, userChoice
		cmp		eax, MIN
		jl		reprompt						
		cmp		eax, MAX
		jg		reprompt					

		jmp		continue					

;get another number from user if number is outside range
	reprompt:
		mov		eax, black +(lightRed * 16) ;set text->black, background->red to alert user
		call	SetTextColor
		mov		edx, OFFSET vali			;"Not in range! Enter a number 1 - 400"
		call	WriteString
		call	CrLf

		mov		eax, lightGray +(black * 16) ;returun text to std colors
		call	SetTextColor
		call	ReadInt
		mov		userChoice, eax
		jmp		compare

	continue:
		ret
validate ENDP

;*************************************************************
;* isComposite sub-procedure								 *
;* checks if a number passed on stack by value is composite	 *
;* returns 1 (composite) or 0(not composite) by reference	 *
;* Registers changed:	ebp, esp, ecx, edx, ebx				 *
;*************************************************************
isComposite PROC

	;set up stack frame
		push	ebp
		mov		ebp, esp

		mov		ecx, perfSqComp
		
	Bound1:
	;Make sure the divisor we're checking against is less than 23
		cmp		ecx, SQMAX
		jg		ReturnVal
		
		Bound2:
		;make sure the number in question does not equal the divisor (avoid primes)
			mov		ebx, [ebp+8]
			cmp		ebx, ecx
			jne		Bound3

			;if so, increment divisor by 1
			inc		ecx
			jmp		Bound1

			Bound3:
				;Check to see if number in question is divisible by divisor
				mov		edx, 0
				mov		eax, ebx
				div		ecx
				cmp		edx, 0
				je		YesComposite

				;if number not divisible, increment divisor and try again
				inc		ecx
				jmp		Bound1
	
	YesComposite:
		mov		ecx, 1
		jmp		ReturnVal
	NoComposite:
		mov		ecx, 0

	ReturnVal:
	;return 1 or 0 to showComposite 
		mov		ebx, [ebp+12]
		mov		[ebx], ecx
		pop		ebp
		ret		8

isComposite ENDP

END main
