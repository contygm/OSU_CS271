TITLE Sorting Random Integers     (program4_Rico_Christopher.asm)

; Author: Christopher Rico
; Course / Project ID CS 271 / Program 4
; Date: 8/6/17
; Description: Introduce the program
;				Get user input for how many random integers they would like to be generated
;				Generate the integers and store them in an array.
;				Display the unsorted array, 10 numbers per line
;				Sort the array in descending order
;				Calculate and display the median, rounded to the nearest integer
;				Display the sorted array, 10 numbers per line

INCLUDE Irvine32.inc

MIN = 10
MAX = 200

.data
;text to be displayed on screen
intro_1			BYTE	"Sorting Random Integers: Programmed by Christopher Rico", 0
intro_2			BYTE	"This program generates random numbers in the range 100 - 999,", 0
intro_3			BYTE	"displays the original list, sorts the list, ", 0
intro_4			BYTE	"and calculates the median value.", 0
intro_5			BYTE	"Finally, it displays the list sorted in descending order.", 0
prompt_1		BYTE	"How many numbers should be generated? Pick a number 10 - 200: ", 0
unsorted_1		BYTE	"The unsorted random numbers:", 0
median_1		BYTE	"The median is ", 0
sorted_1		BYTE	"The sorted list:", 0
vali			BYTE	"Out of range. Please enter a number 10 - 200: ", 0
spaces			BYTE	"   ", 0

;values input by user
userChoice		DWORD	?

;variables for calculations
tenLine			DWORD	10
writeCount		DWORD	0	;count of random numbers generated
list			DWORD	MAX DUP(?)
medLow			DWORD	?
medhi			DWORD	?
two				DWORD	2
four			DWORD	4

.code
main PROC

	call	intro

;call function that gets the user's choice for how many random integers to print
	push	OFFSET userChoice
	call	getUserData

;seeds a random number
	call	Randomize

;call function that fills the array with random numbers
	push	OFFSET list
	push	userChoice
	call	fillArray

;display the list header "Unsorted list" and the list, 10 ints per line
	mov		edx, OFFSET unsorted_1
	call	WriteString
	call	CrLf
	push	OFFSET list
	push	userChoice
	call	displayList

;sort the list
	push	OFFSET list
	push	userChoice
	call	sortList

;display the median header "the median is" and then calculate/display the median
	call	CrLF
	mov		edx, OFFSET median_1
	call	WriteString
	push	OFFSET list
	push	userChoice
	call	displayMedian

;display the list header "sorted list" then display the sorted list
	mov		edx, OFFSET sorted_1
	call	WriteString
	call	CrLf
	push	OFFSET list
	push	userChoice
	call	displayList

	exit	; exit to operating system
main ENDP


;***************************************************************
;						PROCEDURES							   *
;***************************************************************

;*************************************************************
;* Intro procedure
;* Introduces program and gives user instructions
;* Receives: Intro 1 - Intro 5
;* Returns: Nothing
;* Preconditions: Intro 1 - Intro 5 must be strings
;* Registers changed: EDX
;*************************************************************
intro PROC

	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	call	CrLf

	mov 	edx, OFFSET intro_2
	call	WriteString
	call	CrLf

	mov 	edx, OFFSET intro_3
	call	WriteString
	mov		edx, OFFSET intro_4
	call	WriteString
	call    CrLf

	mov		edx, OFFSET intro_5
	call	WriteString
	call	CrLf

	ret
intro ENDP


;*************************************************************
;* getUserData procedure
;* Asks user for number of random ints user would like
;* Receives: userChoice, prompt1
;* Returns: puts user's choice into userChoice variable
;* Preconditions: userChoice must be DWORD, prompt1 must be string
;* Registers changed: EDX, EAX
;*************************************************************
getUserData PROC

		push	ebp
		mov		ebp, esp
		mov		ebx, [ebp+8]			;move address of userChoice into ebx

;prompt user
		call	CrLf
		mov 	edx, OFFSET prompt_1
		call	WriteString

;get user data
	input:
		call	ReadInt
		mov		[ebx], eax

;validate user data
		mov		eax, [ebx]
		cmp		eax, MIN
		jl		reprompt
		cmp		eax, MAX
		jg		reprompt

		jmp		continue


;validation prompts if needed
	reprompt:
		call	CrLf
		mov		eax, black +(lightRed * 16) ;set text->black, background->red to alert user
		call	SetTextColor
		mov		edx, OFFSET vali						;"Not in range! Enter a number 1 - 400"
		call	WriteString
		call	CrLf
		mov		eax, lightGray +(black * 16) ;return text to std colors
		call	SetTextColor

		jmp		input

	continue:
		call	CrLf
		pop		ebp
		ret		4

getUserData ENDP

;*************************************************************
;*fillArray procedure
; *	 Fill an array with random numbers
; *Receives:	     list: @array and userChoice: number of array elements
; *Returns:			 nothing
; *Preconditions:	 userChoice must be set to an integer between 10 and 200
; *Registers Changed: EAX, ECX, ESI
;*************************************************************
fillArray PROC

		push	ebp
		mov		ebp, esp
		mov		esi, [ebp+12] ; @list
		mov		ecx, [ebp+8]  ; loop control based on userChoice

	arrayLoop:
		mov		eax, 899	; set range of numbers to be generated
		inc		eax
		call	RandomRange
		add		eax, 100
		mov		[esi], eax	 ;put random number in array
		add		esi, 4		 ;next element
		loop	arrayLoop

		pop		ebp
		ret 8

fillArray ENDP


;*************************************************************
; *displayList procedure
; *Description :		 Prints out userChoice number of values in list MIN numbers per row
; *Receives:			 list: @array and userChoice: number of array elements
; *Returns:				 nothing
; *Preconditions:		 userChoice must be set to an integer between 10 and 200
; *Registers Changed:	 eax, ecx, ebx, edx
;*************************************************************
displayList PROC

;set up stack record and prep for loop
		push	ebp
		mov		ebp, esp
		mov		esi, [ebp+12]  ;array address
		mov		ecx, [ebp+8]   ;how many nuumbers to print
		mov		ebx, 0		   ;to keep track of numbers per line

;display a number
	display:
		mov		eax, [esi]
		call	WriteDec
		mov		edx, OFFSET spaces
		call	WriteString

;check to see if a carriage return needed
		inc		ebx
		cmp		ebx, 10
		jne		noLineDown
		call	CrLf
		mov		ebx, 0

	noLineDown:
		add		esi, 4
		loop	display

;clean up the stack and return
		call	CrLf
		call	CrLf

		pop		ebp
		ret		8

displayList ENDP


;*************************************************************
; *sortList procedure
; *Description :		 sorts array in descending order
; *Receives:			 list: @array and userChoice: number of array elements
; *Returns:				 nothing
; *Preconditions:		 userChoice must be set to an integer between 10 and 200
; *Registers Changed:	 eax, ecx, ebx, edx
;*************************************************************
sortList PROC
;set up stack record and prep for loop
		push	ebp
		mov		ebp, esp
		mov		ecx, [ebp+8]   ;how many numbers to sort through
		dec		ecx

;set up outer loop
	sortLoop1:
		mov		esi, [ebp+12]  ;array address
		push	ecx

	;inner loop to check and swap the numbers
		sortLoop2:
			mov		eax, [esi]
			cmp		eax, [esi + 4]	;if the higher index number is less,
			jge		noSwap			;don't swap them
			push	esi
			call	exchange

		noSwap:
			add		esi,4			; get the next index, loop through array
			loop	sortLoop2

		pop		ecx
		loop	sortLoop1

		pop		ebp
		ret		8

sortlist ENDP


;*************************************************************
; *exchange procedure
; *Description :		 exchanges two array elements
; *Receives:			 two values by reference
; *Returns:				 nothing
; *Preconditions:		 userChoice must be set to an integer between 10 and 200
; *Registers Changed:	eax, edi
;*************************************************************
exchange PROC

;set up stack record and get array index into edi
		push	ebp
		mov		ebp, esp
		mov		edi, [ebp + 8]

;swap values
		mov		eax, [edi]
		xchg	eax, [edi + 4]
		mov		[edi], eax

		pop ebp
		ret 4

exchange ENDP


;*************************************************************
; *displayMedian procedure
; *Description :		 finds the median of a sorted array
; *Receives:			 @ array , and userChoice, the size of the array
; *Returns:				 nothing
; *Preconditions:		 userChoice must be set to an integer between 10 and 200
; *Registers Changed:	esi, eax, edx, ecx
;*************************************************************
displayMedian PROC

;set up stack frame
		push	ebp
		mov		ebp, esp

		mov		esi, [ebp+12]	 ; @ array
		mov		eax, [ebp+8]	;get number of array elements

;go to the middle of the array
		mov		edx, 0
		div		two
		mov		ecx, eax

		medLoop:
			add		esi, 4
			loop	medLoop


;check to see whether even or uneven number of elements in array

		cmp		edx, 0
		jnz		oddNum

;if it's even
		mov		eax, [esi]
		add		eax, [esi-4]
		mov		edx, 0
		div		two
		call	WriteDec
		jmp		endDM

;if it's odd
	oddNum:
		mov		eax, [esi]
		call	WriteDec

	endDM:
		call	CrLf
		call	CrLf
		pop		ebp
		ret		8

	displayMedian ENDP


END main
