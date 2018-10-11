TITLE Program 5 (Option A)    (program5_ Rico_Christopher.asm)

; Author:				Christopher Rico
; Course / Project ID   CS271 / PG5         
; Date:					8/13/17
; Description:			Introduce the program
;						Ask user to enter 15 unsigned decimal integers
;						Validate the integers
;						Display a list of the integers, their sum, and their avg value

INCLUDE Irvine32.inc

;CONSTANTS
MAX	= 10
MIN  = 0
HI	= 4294967295

;**********************************************
;					MACROS
;**********************************************
mGetString MACRO stringIn
	push	eax

	call	ReadDec
	mov		OFFSET stringIn, eax

	pop		eax
ENDM


mDisplayString MACRO stringOut
	push	edx

	mov		edx, OFFSET stringOut
	call	WriteString

	pop		edx
ENDM


;**********************************************
;					VARIABLES
;**********************************************
.data
;text to be displayed on screen
intro_1			BYTE	"Designing low-level I/O procedures: Programmed by Christopher Rico", 0
intro_2			BYTE	"Please provide 15 unsigned decimal integers. ", 0
intro_3			BYTE	"Each number needs to be small enough to fit inside a 32-bit register.", 0
intro_4			BYTE	"After you have finished inputting the raw numbers I will display a list", 0
intro_5			BYTE	"of the integers, their sum, and their average value.", 0
prompt_1		BYTE	"Please enter an unsigned number: ", 0
vali_1			BYTE	"ERROR: Number too big, or not unsigned.", 0
enteredNums		BYTE	"You entered the following numbers: ", 0
sumNums			BYTE	"The sum of those numbers is: ", 0
avgNums			BYTE	"The average is: ", 0
farewell		BYTE	"Goodbye!", 0
spaces			BYTE	",  ", 0

;values for calculation and user input
listNums		DWORD	10 DUP(?)
outString		DWORD	?
inString		DWORD	?

;**********************************************
;					MAIN
;**********************************************
.code
main PROC


;Introduce the program
call	Intro

;Get and validate input from user
push	OFFSET listNums
push	OFFSET inString
call	ReadVal

;Print user input to screen
push	OFFSET listNums
call	WriteVal

;Calculate and display the sum
push	OFFSET listNums
call	CalcSum

;say bye
call	CrLf
mDisplayString OFFSET farewell
call	CrLf

	exit	; exit to operating system
main ENDP

;**********************************************
;					PROCEDURES
;**********************************************

;*************************************************************
;*Intro procedure
; *	Introduces the program
; *Receives:	     nothing
; *Returns:			 nothing, but displays several text strings
; *Preconditions:	 intro_1 through intro_5 must be set to text strings
; *Registers Changed: edx
;*************************************************************
Intro	PROC

	mDisplayString OFFSET intro_1
	call	CrLf
	call	CrLf

	mDisplayString OFFSET intro_2
	call	CrLf
	mDisplayString OFFSET intro_3
	call	CrLf
	mDisplayString OFFSET intro_4
	call	CrLf
	mDisplayString OFFSET intro_5
	call	CrLf

	ret
Intro	ENDP


;*************************************************************
;*readVal procedure
;* Read in and validate 10 numbers as strings, validate them, and then
;* Store them to an array as integers
; *Receives:	     list: @array and @string
; *Returns:			 nothing
; *Preconditions:	 list must be an array of minimum 10 DWORDs
; *Registers Changed: EAX, ECX, ESI, EDI, EBP, EDX
;*************************************************************
ReadVal PROC
;set up activation record
		push	ebp
		mov		ebp, esp
		mov		edi, [ebp+12]  ; get listNums into edi
		mov		ecx, 10
		call	CrLf

;get integers from user
	getInts:
		mDisplayString  OFFSET prompt_1
		call	ReadInt
		mov		[ebp+8], eax

;check that data is within range
		mov		eax,[ebp+8] ;move inString to eax
		cmp		eax, HI
		ja		vali
		cmp		eax, MIN
		jb		vali

;move integer into array and increment array index
		mov		[edi], eax
		add		edi, 4

;get next integer
		loop	getInts
		jmp		readEnd

;if number too big or small, ask for another one
	vali:
		call	CrLf
		pop		ecx
		mDisplayString OFFSET vali_1
		call	CrLf
		jmp		GetInts

	ReadEnd:
		pop		ebp
		ret		8	

ReadVal	ENDP


;*************************************************************
;*WriteVal procedure
; Read integers from an array, convert them to string values, display as a string
; *Receives:	     list: @array
; *Returns:			 nothing, but prints strings to screen
; *Preconditions:	 @array must be a list of at 10 integers
; *Registers Changed: EAX, ECX, ESI, EDI, EBX, 
;*************************************************************
WriteVal PROC
;set up activation record
		push	ebp
		mov		ebp, esp
		mov		edi, [ebp+8]   ; get listNums into esi
		mov		ecx, 10		   ; set up for 10 loops

;"The numbers you entered were:"
		call	CrLf
		mDisplayString OFFSET enteredNums

	WriteLoop1:
		push	ecx
		mov		eax, [edi]
		mov		ecx, 10
		xor		bx, bx

;convert one digit to ASCII		
		convert:
			xor		edx, edx
			div		ecx
			push	dx
			inc		bx
			test	eax, eax
			jnz		convert
			mov		cx, bx

;store that digit to the output string
			lea		esi, outString

;get the next digit and loop
		nextDig:
			pop		ax
			add		ax, '0'
			mov		[esi], ax

;read out the integer as a string
			mDisplayString OFFSET outString

			loop	nextDig
		pop		ecx

; print the comma and spaces
		mDisplayString OFFSET spaces		
		mov		edx, 0
		mov		ebx, 0
		add		edi, 4
		loop	WriteLoop1
			

		pop		ebp
		ret		8
WriteVal ENDP


;*************************************************************
;*CalcSum procedure
;Calculates the sum of 10 integers given in an array
; *Receives:	     list: @array and @sum:
; *Returns:			 sum of 10 array elements
; *Preconditions:	 array must have 10 elements
; *Registers Changed: EAX, ECX, EDI, EBP
;*************************************************************
CalcSum	PROC
;set up activation record
		push	ebp
		mov		ebp, esp
		mov		edi, [ebp+8]  ; get array into edi

		;set up to add 10 numbers together from array
		mov		ecx, 10
		mov		eax, 0

	avgLoop:
		add		eax, [edi]
		add		edi, 4
		loop	avgLoop
		
		;display sum
		call	CrLf
		call	CrLf
		mDisplayString OFFSET sumNums
		call	WriteDec

		;display average
		mov		edx, 0
		mov		ecx, 10
		div		ecx
		call	CrLf
		mDisplayString OFFSET avgNums
		call	WriteDec

		call	CrLf

		pop		ebp
		ret		4
CalcSum ENDP


END main
