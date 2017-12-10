TITLE Array Sort     (array_sort.asm)

; Author:Trevor Rollins
; Course / Project ID: 271-400/Program 5                 
; Date:11/19/2017
; Description:This program allow the user to request a number of random integers between 100 and 999.
; These integers will then be displayed, sorted and displayed again.  The median will also be calculated.

INCLUDE Irvine32.inc

MIN				=		10
MAX				=		200
HI				=		999
LO				=		100

.data

intro_1			BYTE	"Array Sort",0
intro_2			BYTE	"Programmed by Trevor Rollins",0
intro_3			BYTE	"This program generates random numbers in the range [100 .. 999],",0
intro_4			BYTE	"displays the original list, sorts the list, and calculates the",0
intro_5			BYTE	"median value. Finally, it displays the list sorted in descending order.",0
EC_1			BYTE	"**EC: This program aligns the columns of composite numbers.",0
EC_2			BYTE	"**EC: This program allows the user to choose more than 400 composite",0
EC_3			BYTE	"      numbers, and prints them in pages of 200 at a time.",0
number_prompt	BYTE	"Enter the number of random integers you'd like.",0
range			BYTE	"The number must be between 10 and 200.",0
range_warning_1	BYTE	"The number must be at least 10",0
range_warning_2	BYTE	"The number must be 200 or less",0
median			BYTE	"Median: ",0
spaces3			BYTE	"   ",0
unsorted		BYTE	"The unsorted numbers:",0
sorted			BYTE	"The sorted numbers:",0


array			DWORD	200 DUP (0)
count			DWORD	?

.code
main PROC

call			Randomize

push			OFFSET intro_1
push			OFFSET intro_2
push			OFFSET intro_3
push			OFFSET intro_4
push			OFFSET intro_5
call			Intro

push			OFFSET range_warning_1
push			OFFSET range_warning_2
push			OFFSET number_prompt
push			OFFSET range
push			OFFSET count
call			GetRequest

push			OFFSET array
push			count
call			FillArray

push			OFFSET unsorted
push			OFFSET spaces3
push			OFFSET array
push			count
call			DisplayArray

push			OFFSET array
push			count
call			SelectionSort

push			OFFSET sorted
push			OFFSET spaces3
push			OFFSET array
push			count
call			DisplayArray

push			OFFSET median
push			OFFSET array
push			count
call			GetMedian



	exit	; exit to operating system
main ENDP

;********************************************************************
;Description:Displays the intro messages to the user
;Recieves:The OFFSETs of the 5 intro message strings
;Returns:None
;Preconditions:None
;Registers Changed:None
;********************************************************************
Intro PROC

	;Save registers

	pushad
	mov				ebp, esp

	;Display intro

	mov				edx, [ebp+52]
	call			WriteString
	Call			Crlf
	mov				edx, [ebp+48]
	call			WriteString
	call			Crlf
	mov				edx, [ebp+44]
	call			WriteString
	call			Crlf
	mov				edx, [ebp+40]
	call			WriteString
	call			Crlf
	mov				edx, [ebp+36]
	call			WriteString
	call			Crlf


	;Restore registers

	popad
	ret				20

Intro ENDP
;********************************************************************
;Description:Prompts user for input, then calls validate procedure to
;validate input.  Reprompts if necessary
;Recieves:OFFEST of the request variable, OFFSET range, OFFSET number_prompt,
;the OFFSET of range_warning_1, OFFSET range_warning_2
;Returns:Modifies the request variable to the user input
;Preconditions:None
;Registers Changed:None
;********************************************************************
GetRequest PROC

	;Save registers

	push			edx
	push			eax
	push			ebp
	mov				ebp, esp

	;Prompting user for number

	mov				edx, [ebp+24]
	call			WriteString
	Call			Crlf
	mov				edx, [ebp+20]
	call			WriteString
	call			Crlf

	;Storing input, and calling the validate function in loop until input is valid

	getinput:
	call			ReadDec
	mov				edx, [ebp+16]
	mov				[edx], eax
	push			[ebp+32]
	push			[ebp+28]
	push			eax
	call			Validate
	cmp				eax, FALSE
	je				getinput

	;Restore Registers

	pop				ebp
	pop				eax
	pop				edx
	ret				20

GetRequest ENDP

;********************************************************************
;Description:Checks that input is within the range, gives warning messages
;if not.
;Recieves:Input value parameter, OFFSET of range_warning_1, OFFSET of rane_warning_2
;Returns:TRUE or FALSE in eax
;Preconditions:None
;Registers Changed:eax
;********************************************************************
Validate PROC

	;Save registers

	push			edx
	push			ebp
	mov				ebp, esp

	;Check input to make sure it's within the range

	mov				edx, [ebp+12]
	cmp				edx, MAX
	jg				toolarge
	cmp				edx, MIN
	jl				toosmall
	jmp				valid

	;Display warning messages

	toolarge:
	mov				edx, [ebp+16]
	call			WriteString
	Call			Crlf
	mov				eax, FALSE
	jmp				continue

	toosmall:
	mov				edx, [ebp+20]
	call			WriteString
	Call			Crlf
	mov				eax, FALSE
	jmp				continue

	;Change isValid to TRUE

	valid:
	mov				eax, TRUE

	;Restore registers

	continue:
	pop				ebp
	pop				edx
	ret				12

Validate ENDP
;********************************************************************
;Description:Fills an array with random integers
;Recieves:OFFSET of the array, and the value of the array count
;Returns:Modifies array elements
;Preconditions:None
;Registers Changed:None
;********************************************************************
FillArray PROC

	;Save register

	pushad
	mov				ebp, esp

	mov				esi, [ebp+40]	;Puts array address into esi
	mov				ecx, [ebp+36]	;Sets loop counter to the size of the array

	;This loop gets random numbers and puts them into each element of the array

	fill:
	call			GetRandomInt
	mov				[esi], eax
	add				esi, 4
	loop			fill

	;Restore registers

	popad
	ret				8

FillArray ENDP
;********************************************************************
;Description:Returns a random int in a range between LO and HI
;Recieves:None
;Returns:Random integer in eax
;Preconditions:HI and LO constants must be set
;Registers Changed:eax
;********************************************************************
GetRandomInt PROC

	;Code borrowed from lecture 20 slide
	;sets a range and returns a interger within that range

	mov				eax, HI
	sub				eax, LO
	inc				eax
	call			RandomRange
	add				eax, LO
	ret

GetRandomInt ENDP

DisplayArray PROC

	;Save register

	pushad
	mov				ebp, esp

	mov				esi, [ebp+40]	;Puts array address into esi
	mov				ecx, [ebp+36]	;Sets loop counter to the size of the array
	mov				edx, [ebp+48]	;sets unsorted/sorted display

	;Display whether numbers are sorted or unsorted

	call			WriteString
	;call			Crlf

	;This is an outer loop that calls Crlf after every 10 numbers

	newline:
	call			Crlf
	mov				edi, 0

	;This loop displays each element of the array
	;Code borrowed from lecture 20 slide

	display:
	cmp				edi, 10
	je				newline
	inc				edi
	mov				eax, [esi]
	call			WriteDec
	add				esi, 4
	mov				edx, [ebp+44]
	call			WriteString
	loop			display

	call			Crlf

	;Restore registers

	popad
	ret				8

DisplayArray ENDP
;********************************************************************
;Description:Swaps the values of two elements of an array
;Recieves:OFFSET of the array, and the two positions to be swapped
;Returns:None
;Preconditions:None
;Registers Changed:None
;********************************************************************
Swap PROC

	;store registers

	pushad
	mov				ebp, esp

	;Store the array and the 2 position value in registers

	mov				edi, [ebp+44]	;array

	mov				eax, [ebp+40]	;position 1
	cmp				eax, [ebp+36]	;compare the positions
	je				endproc			;if equal, no need to swap
	mov				esi, 4
	mul				esi				;account for DWORD
	mov				edx, eax		;new value in edx

	mov				eax, [ebp+36]	;position 2
	push			edx
	mul				esi				;account for DWORD
	pop				edx
	mov				ecx, eax		;new value in ecx

	;Now the offsets of the two positions are stored in edx and ecx

	mov				eax, edi
	add				eax, edx
	mov				esi, edi
	add				esi, ecx

	;Now eax and esi contain the adresses of the elements to be swapped

	mov				edx, [eax]		;Store value of position 1
	mov				ecx, [esi]		;Store value of position 2
	mov				[esi], edx		;Put position 1 value into position 2
	mov				[eax], ecx		;Put Position 2 value into position 1

	;Restore registers
	endproc:
	popad
	ret				12

Swap ENDP
;********************************************************************
;Description:Sorts the array in descending order using the selection sort algorithm
;Recieves:OFFEST of the array, and the count of the array
;Returns:Sorted the array
;Preconditions:None
;Registers Changed:None
;********************************************************************
SelectionSort PROC

	;store registers

	pushad
	mov				ebp, esp

	;Store the OFFSET of the array and the count-1 in edi and ecx

	mov				edi, [ebp+40]		;array OFFSET
	mov				ecx, [ebp+36]		;count
	dec				ecx					;request-1
	mov				eax, 0				;k=0

	outerloop:
	mov				edx, eax			;i=k
	push			[ebp+40]			;array OFFSET
	push			[ebp+36]			;count
	push			eax					;k
	call			SelectionSortInner
	push			[ebp+40]			;array OFFSET
	push			eax					;k
	push			edx					;i
	call			Swap
	inc				eax
	cmp				eax, ecx			;k < count-1
	jl				outerloop

	;Restore registers and stack

	popad
	ret				8

SelectionSort ENDP
;********************************************************************
;Description:Provides the inner loop of the selection sort algorithm.
;It will return the position of the largest element left in the unsorted
;part of the array
;Recieves:OFFEST of the array, and the count of the array, and the value
;of k from the outer loop in selection sort
;Returns:Position of the largest element in the edx register
;Preconditions:Must be used within the outer loop in the SelectionSort 
;procedure
;Registers Changed:EDX
;********************************************************************
SelectionSortInner PROC

	;store registers

	push			eax
	push			ebx
	push			ecx
	push			esi
	push			edi
	push			ebp
	mov				ebp, esp

	;Store array OFFSET count and k+1 for the inner loop

	mov				edi, [ebp+36]		;array OFFSET
	mov				ecx, [ebp+32]		;count
	mov				esi, [ebp+28]		;j=k
	inc				esi					;j=k+1
	mov				edx, [ebp+28]		;i=k

	;compare array[j] and array[i], set i=j if appropriate

	innerloop:
	push			edi					;array OFFSET
	push			esi					;j
	call			ReturnArrayElement
	mov				ebx, eax
	push			edi					;array OFFSET
	push			edx					;i
	call			ReturnArrayElement
	cmp				ebx, eax			
	jg				greater				;array[j] > array[i]
	continue:
	inc				esi					;j++
	cmp				esi, ecx
	jl				innerloop			;j < count
	jmp				endproc


	greater:
	mov				edx, esi			;i=j
	jmp				continue

	;Restore registers and stack

	endproc:
	pop				ebp
	pop				edi
	pop				esi
	pop				ecx
	pop				ebx
	pop				eax
	ret				12

SelectionSortInner ENDP
;********************************************************************
;Description:Returns the value of an element in an array given the position
;Recieves:OFFEST of the array, and the position of the element
;Returns:value of the array element in the eax register
;Preconditions:None
;Registers Changed:EAX
;********************************************************************
ReturnArrayElement PROC

	push			ebx
	push			edi
	push			ebp
	mov				ebp, esp

	mov				edi, [ebp+20]		;array OFFSET
	mov				eax, [ebp+16]		;element position
	mov				ebx, 4
	push			edx
	mul				ebx					;account for DWORD
	pop				edx
	mov				eax, [edi+eax]		;move element value into eax

	;restore registers and stack

	pop				ebp
	pop				edi
	pop				ebx
	ret				8

ReturnArrayElement ENDP
;********************************************************************
;Description:Finds the median of a sorted array and prints it out
;Recieves:OFFEST of the array, and the count of the array, OFFSET of 
;median string
;Returns:None
;Preconditions:Array must already be sorted
;Registers Changed:None
;********************************************************************
GetMedian PROC

	;Store Registers

	pushad
	mov				ebp, esp

	;Store array OFFSET and count

	mov				edi, [ebp+40]		;array OFFSET
	mov				eax, [ebp+36]		;count

	;Find out if count is even or odd

	mov				edx, 0
	mov				esi, 2
	div				esi
	cmp				edx, 0				;remainder will be 0 if even
	je				evenCount
	jmp				oddCount

	;

	oddCount:
	inc				eax					;This will be the median position
	push			edi					;array OFFSET
	push			eax					;median position
	mov				edx, [ebp+44]
	call			WriteString
	call			ReturnArrayElement
	call			WriteDec
	call			Crlf
	jmp				continue

	evenCount:
	mov				ecx, eax			;ecx is first element position
	dec				eax					;eax is second element position
	push			edi					;array OFFSET
	push			eax					;second position
	call			ReturnArrayElement
	mov				edx, eax			;edx is value at second position
	push			edi					;array OFFSET
	push			ecx					;median position
	call			ReturnArrayElement
	add				eax, edx			;sum of values at 2 middle positions
	mov				edx, 0
	div				esi					;take the average of the 2 values
	cmp				edx, 0				
	jne				addone				;jump if there is a remainder
	mov				edx, [ebp+44]
	call			WriteString
	call			WriteDec
	call			Crlf
	jmp				continue

	;If there is a remainder, then the median would have a decimal value of .5
	;Therefore it will always round up

	addone:
	mov				edx, [ebp+44]
	call			WriteString
	inc				eax
	call			WriteDec
	call			Crlf


	;Restore registers and stack
	continue:
	popad
	ret				12

GetMedian ENDP

END main