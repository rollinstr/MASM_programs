TITLE Combinatorics     (combinatorics.asm)

; Author:Trevor Rollins               
; Date:12/3/2017
; Description:This program gives the user pratice with combinnatorics. It randomly
; generates a problem and then evaluates the user's answer.

INCLUDE Irvine32.inc

LO				=	3
HI				=	12
TRUE			=	1
FALSE			=	0

;********************************************************************
;Description:Uses the WriteString procedure to diplay a message.
;Recieves:OFFSET of a string
;Returns:None
;Preconditions:None
;Registers Changed:None
;********************************************************************
;From lecture 26 slide
mWriteStr		MACRO	buffer
	push			edx
	mov				edx, OFFSET buffer
	call			WriteString
	pop				edx
ENDM


.data

intro_1			BYTE	"Combination Problems",0
EC_1			BYTE	"**Extra Credit: This program keeps track of the number of correct/incorrect answers.",0
intro_2			BYTE	"Programmed by Trevor Rollins",0
intro_3			BYTE	"This program generates combination problems.",0
intro_4			BYTE	"Enter an answer to the problem, and it will be evaluated.",0
problem_1		BYTE	"Problem ",0
problem_2		BYTE	":",0
set				BYTE	"Number of elements in the set:  ",0
subset			BYTE	"Number of elements to choose from set:  ",0
inputError		BYTE	"Your answer must consist only of digits.",0
answerPrompt	BYTE	"Please enter your answer: ",0
answer_1		BYTE	"There are ",0
answer_2		BYTE	" combinations of ",0
answer_3		BYTE	" items from a set of ",0
answer_4		BYTE	".",0
correct			BYTE	"You are correct!",0
incorrect		BYTE	"Keep practicing.",0
playAgain		BYTE	"Would you like to try again (y/n)? ",0
wrongChar		BYTE	"You must answer with 'y' or 'n'.",0
correct_answ	BYTE	"Number answered correctly: ",0
incorrect_answ	BYTE	"Number answered incorrectly: ",0
goodbye			BYTE	"Goodbye.",0

result			DWORD	?
n				DWORD	?
r				DWORD	?
answerInt		DWORD	0
answerString	BYTE	15	DUP(0)
validInput		DWORD	0
correctAnswer	DWORD	0
again			DWORD	0
numRight		DWORD	0
numWrong		DWORD	0
problemNum		DWORD	1

.code
main PROC

call			Randomize

call			Intro

push			OFFSET problemNum
push			OFFSET numRight
push			OFFSET numWrong
push			OFFSET again
push			OFFSET n
push			OFFSET r
push			OFFSET answerInt
push			OFFSET result
push			OFFSET correctAnswer
push			OFFSET validInput
call			ProblemLoop

	exit	; exit to operating system
main ENDP
;********************************************************************
;Description:Uses the mWritestr MACRO to display intro messages
;Recieves:OFFSETs to the 4 strings to be displayed.
;Returns:None
;Preconditions:None
;Registers Changed:None
;********************************************************************
Intro Proc

	;Save registers

	push			ebp
	mov				ebp, esp

	;Use mWriteStr MACRO to display intro

	mWriteStr		EC_1
	call			Crlf

	mWriteStr		intro_1
	call			Crlf

	mWriteStr		intro_2
	call			Crlf

	mWriteStr		intro_3
	call			Crlf

	mWriteStr		intro_4
	call			Crlf

	;Restore registers
	pop				ebp
	ret				

Intro ENDP
;********************************************************************
;Description:Takes an integer, and returns its factorial value.
;Recieves:One DWORD number
;Returns:Factorial value in EAX
;Preconditions:None
;Registers Changed:EAX
;********************************************************************
Factorial PROC

	;save registers

	push			ebx
	push			ecx
	push			edx
	push			esi
	push			edi
	push			ebp
	mov				ebp, esp

	mov				ebx, [ebp+28]	;number to take factorial of
	cmp				ebx, 0
	je				basecase		;base case of number = 0

	dec				ebx				;number-1
	push			ebx
	call			Factorial		;recursive call, returns value in eax
	mov				edx, 0
	inc				ebx				;restore number to orginal value
	mul				ebx				;factorial value stored in eax
	jmp				continue

	basecase:
	mov				eax, 1		;moves 1 to be returned into eax

	continue:
	;restore registers/stack

	mov				esp, ebp
	pop				ebp
	pop				edi
	pop				esi
	pop				edx
	pop				ecx
	pop				ebx
	ret				4

Factorial ENDP
;********************************************************************
;Description:Returns the answer to a combination problem.
;Recieves:One DWORD number for the size of the set, and the a DWROD
; for the size of the subset.
;Returns:Number of combinations possible in in result
;Preconditions:None
;Registers Changed:None
;********************************************************************
CalcCombo PROC

	;Save registers

	push			eax
	push			ebx
	push			ecx
	push			edx
	push			esi
	push			edi
	push			ebp
	mov				ebp, esp

	;Save factorial values

	push			[ebp+36]		;n
	call			Factorial
	mov				ebx, eax		;ebx=n!

	push			[ebp+32]		;r
	call			Factorial
	mov				ecx, eax		;ecx=r!

	mov				edx, [ebp+36]	;edx=n
	sub				edx, [ebp+32]	;edx=(n-r)
	push			edx
	call			Factorial		;eax=(n-r)!		

	;Calculate denominator

	mul				ecx				;eax=((n-r)!*r!)

	mov				esi, eax		;esi=((n-r)!*r!)
	mov				eax, ebx		;eax=n!
	mov				edx, 0

	div				esi				;eax=number of combinations
	mov				ebx, [ebp+40]
	mov				[ebx], eax		;result is set equal to eax

	;restore registers/stack

	mov				esp, ebp
	pop				ebp
	pop				edi
	pop				esi
	pop				edx
	pop				ecx
	pop				ebx
	pop				eax
	ret				12

CalcCombo ENDP

;********************************************************************
;Description:Returns a random int in a range between LO and HI
;Recieves:A high and low interger
;Returns:Random integer in eax
;Preconditions:None
;Registers Changed:eax
;********************************************************************
GetRandomInt PROC

	push			ebp
	mov				ebp, esp

	;Code borrowed from lecture 20 slide
	;sets a range and returns a interger within that range

	mov				eax, [ebp+12]
	sub				eax, [ebp+8]
	inc				eax
	call			RandomRange
	add				eax, [ebp+8]

	mov				esp, ebp
	pop				ebp
	ret				8

GetRandomInt ENDP
;********************************************************************
;Description:Generates a value for n between 3-12, and a value for r
; between 3-n.
;Recieves:OFFSET of n, OFFSET of r
;Returns:Modifies the values of n and r
;Preconditions:HI and LO must be set
;Registers Changed:None
;********************************************************************
CreateProb PROC

	;Save registers

	pushad
	mov				ebp, esp

	mov				ebx, [ebp+40]	;ebx=OFFSET n
	mov				ecx, [ebp+36]	;ecx=OFFSET r

	;Generate value for n

	push			HI
	push			LO
	call			GetRandomInt
	mov				[ebx], eax	;n=random int [3...12]

	;Generate value for r

	push			[ebx]	;n
	push			LO
	call			GetRandomInt
	mov				[ecx], eax	;r=random int [3...n]

	;Restore registers/stack

	mov				esp, ebp
	popad
	ret				8

CreateProb ENDP
;********************************************************************
;Description:Displays the combination problem for the user.
;Recieves:OFFSET problem, OFFSET set, OFFSET subset, OFFSET n, OFFSET r
;Returns:None
;Preconditions:None
;Registers Changed:None
;********************************************************************
DisplayProblem PROC

	;Save registers

	pushad
	mov				ebp, esp

	push			[ebp+40]	;OFFSET n
	push			[ebp+36]	;OFFSET r
	call			CreateProb

	mov				ebx, [ebp+40]	;ebx=OFFSET n
	mov				ecx, [ebp+36]	;ecx=OFFSET r
	mov				edx, [ebp+44]	;edx=OFFSET problemNum

	;Show problem number

	mWriteStr		problem_1
	mov				eax, [edx]
	call			WriteDec		;display problemNum
	mWriteStr		problem_2
	call			Crlf

	;increment problem number

	mov				eax, 1
	add				[edx], eax

	;Display set amount

	mWriteStr		set			;display set string
	mov				eax, [ebx]
	call			WriteDec	;display n
	call			Crlf

	;Display subset amount

	mWriteStr		subset		;display subset string
	mov				eax, [ecx]
	call			WriteDec	;display r
	call			Crlf

	;Restore registers/stack

	mov				esp, ebp
	popad
	ret				12

DisplayProblem ENDP
;********************************************************************
;Description:This procedure validates that the string received does,
; not contain characters other than digits.  It sets validInput to
; TRUE or FALSE depending on the outcome.
;Recieves:OFFSET of validInput
;Returns:Modifies validInput
;Preconditions:None
;Registers Changed:None
;********************************************************************
ValidateInput PROC

	;Save registers

	pushad
	mov				ebp, esp

	mov				esi, OFFSET answerString	;OFFSET answerString

	mov				edx, esi
	call			StrLength
	mov				ecx, eax					;length of answer in ecx
	mov				ebx, [ebp+36]				;ebx=OFFSET validInput

	;Checks each character of the string to make sure it is a digit

	checkStr:
	mov				eax, 0
	lodsb
	cmp				eax, 48
	jl				error						;hump if eax is less than '0' ascii code
	cmp				eax, 57			
	jg				error						;jump if eax is greater than '9' ascii code
	loop			checkStr
	jmp				valid

	;Displays inputError string and sets validInput to FALSE if not a digit

	error:
	mWriteStr		inputError					;Display inputError string
	call			Crlf
	mov				edx, FALSE
	mov				[ebx], edx					;validInput=FALSE
	jmp				continue

	;If all characters are digits, validInput is set to TRUE

	valid:
	mov				edx, TRUE
	mov				[ebx], edx					;validInput=TRUE

	continue:
	;Restore registers/stack

	mov				esp, ebp
	popad
	ret				4

ValidateInput ENDP
;********************************************************************
;Description:Converts the user's answer from a string to an integer.
;Recieves:OFFSET of answerInt
;Returns:Modifies answerInt
;Preconditions:None
;Registers Changed:None
;********************************************************************
StringToInt PROC

	;Save registers

	pushad
	mov				ebp, esp

	;Save OFFSETs of answerString and answerInt to registers and sets answerInt to 0

	mov				esi, OFFSET answerString	;esi=OFFSET answerString
	mov				edi, [ebp+36]				;edi=OFFSET answerInt
	mov				eax, 0
	mov				[edi], eax					;sets answerInt to 0

	;Gets the length of answerString and sets that to the loop counter

	mov				edx, esi
	call			StrLength
	mov				ecx, eax					;ecx=length of answerString
	cld											;So that lodsb moves in the forward direction

	;This loop loads the string character, and subtracts 48 to convert from ASCII to integer value

	convert:
	mov				eax, 0						;start with eax=0
	lodsb										;eax=ASCII code of number
	sub				eax, 48						;convert to number value
	cmp				ecx, 1						
	jg				multiply					;if loop counter>1 jump to multiply
	continue:
	add				[edi], eax					;add value to answerInt
	loop			convert
	jmp				endproc

	;Multiplies the number by it's power of 10

	multiply:
	push			ecx							;save ecx
	dec				ecx							;this will be how many times the number will be x10
	timesTen:
	mov				edx, 10
	mul				edx							;x10
	loop			timesTen
	pop				ecx							;restore original counter
	jmp				continue


	endproc:
	;Restore registers/stack

	mov				esp, ebp
	popad
	ret				4

StringToInt ENDP
;********************************************************************
;Description:Prompts user from an answer and then calls porcedures to
; validate answer and convert to an integer
;Recieves:OFFSET of validInput
;Returns:None
;Preconditions:None
;Registers Changed:None
;********************************************************************
GetAnswer PROC

	;Save registers

	pushad
	mov				ebp, esp

	;Loop asking user for input until the input is valid

	getinput:
	mWriteStr		answerPrompt
	mov				edx, OFFSET answerString	;OFFSET of answerString
	mov				ecx, 14						;Max size of user input
	call			ReadString

	push			[ebp+36]					;OFFSET of validInput
	call			ValidateInput

	mov				eax, [ebp+36]
	mov				ebx, [eax]					;ebx=validInput
	cmp				ebx, TRUE
	jne				getinput					;if validInput!=TRUE, reprompt

	;Converts string to integer

	push			[ebp+40]					;OFFSET answerInt
	call			StringToInt

	;Restore registers/stack

	mov				esp, ebp
	popad
	ret				8

GetAnswer ENDP
;********************************************************************
;Description:Compares user answer to the actual result and sets
; correctAnswer accordingly
;Recieves:OFFSET of answerInt, OFFSET of result, OFFSET of correctAnswer
;Returns:modifies correctAnswer
;Preconditions:None
;Registers Changed:None
;********************************************************************
CheckAnswer PROC

	;Save registers

	pushad
	mov				ebp, esp

	;Move OFFSETs to registers and set correctAnswer to FALSE

	mov				eax, [ebp+44]			;eax=OFFSET correctAnswer
	mov				ebx, [ebp+40]			;ebx=OFFSET result
	mov				ecx, [ebx]				;ecx=result
	mov				ebx, [ebp+36]			;ebx=OFFSET answerInt
	mov				edx, [ebx]				;edx=answerInt
	mov				esi, False
	mov				[eax], esi				;correctAnswer=false
	
	;Compare user answer to result

	cmp				ecx, edx
	jne				continue				;if result!=answerInt leave correctAnswer=false
	mov				esi, TRUE
	mov				[eax], esi				;else correctAnswer=True

	continue:

	;Restore registers/stack

	mov				esp, ebp
	popad
	ret				12

CheckAnswer ENDP
;********************************************************************
;Description: Asks user if they'd like to play again
;Recieves:OFFSET of again
;Returns:Modifies again
;Preconditions:None
;Registers Changed:None
;********************************************************************
NewProblem PROC

	;save registers

	pushad
	mov					ebp, esp
	mov					ecx,[ebp+36]		;ecx=OFFSET again

	;Ask user if they'd like to play again
	keepPlaying:
	mWriteStr			playAgain
	call				Crlf
	call				ReadChar
	cmp					al, 'y'
	je					yes					;if answer=y
	cmp					al, 'n'				;if answer=n
	je					no
	jmp					error				;if answer=anything else

	;If yes
	yes:
	mov					esi, TRUE
	mov					[ecx], esi			;again=TRUE
	jmp					continue

	;If no
	no:
	mov					esi, FALSE
	mov					[ecx], esi			;again=FALSE
	jmp					continue

	;If neither y or no
	error:
	mWriteStr			wrongChar			;error message
	call				Crlf
	jmp					keepPlaying			;reprompt for answer

	continue:
	;Restore registers/stack

	popad
	ret					4


NewProblem ENDP
;********************************************************************
;Description:Loops through all of the procedures needed to create problem,
; get user answer, and grade the user.  It then asks if the user would like to
; keep playing
;Recieves:OFFSET again, OFFSET n, OFFSET r, OFFSET answerInt, OFFSET result,
; OFFSET correctAnswer, OFFSET validInput
;Returns:None
;Preconditions:None
;Registers Changed:None
;********************************************************************
OFFSETproblemNum	EQU	DWORD PTR [ebp+72]
OFFSETnumRight		EQU	DWORD PTR [ebp+68]
OFFSETnumWrong		EQU	DWORD PTR [ebp+64]
OFFSETagain			EQU	DWORD PTR [ebp+60]
OFFSETn				EQU	DWORD PTR [ebp+56]
OFFSETr				EQU	DWORD PTR [ebp+52]
OFFSETanswerInt		EQU	DWORD PTR [ebp+48]
OFFSETresult		EQU	DWORD PTR [ebp+44]
OFFSETcorrectAnswer	EQU	DWORD PTR [ebp+40]
OFFSETvalidInput	EQU DWORD PTR [ebp+36]
ProblemLoop PROC

;save registers

pushad
mov				ebp, esp

;create loop that creates a problem, lets user answer, and evaluates the answer
combination:
push			OFFSETproblemNum
push			OFFSETn
push			OFFSETr
call			DisplayProblem

push			OFFSETanswerInt
push			OFFSETvalidInput
call			GetAnswer

mov				eax, OFFSETn
mov				ebx, [eax]			;ebx=n
mov				eax, OFFSETr
mov				ecx, [eax]			;ecx=r
push			OFFSETresult
push			ebx					;n
push			ecx					;r
call			CalcCombo

push			OFFSETcorrectAnswer
push			OFFSETresult
push			OFFSETanswerInt
call			CheckAnswer

;Displays correct answer

mWriteStr		answer_1
mov				edx, OFFSETresult
mov				eax, [edx]
call			WriteDec			;show result
mWriteStr		answer_2
mov				eax, ecx
call			WriteDec			;show r
mWriteStr		answer_3
mov				eax, ebx
call			WriteDec			;show n
mWriteStr		answer_4
call			Crlf

;Checks whether user is right or wrong

mov				eax, OFFSETcorrectAnswer
mov				ebx, [eax]
cmp				ebx, TRUE
je				right

mWriteStr		incorrect			;incorrect
call			Crlf
mov				esi, OFFSETnumWrong
mov				edi, 1
add				[esi], edi
jmp				play_again

right:
mWriteStr		correct
call			Crlf
mov				esi, OFFSETnumRight
mov				edi, 1
add				[esi], edi

play_again:

;check if user would like to play again

push			OFFSETagain
call			NewProblem

mov				eax, OFFSETagain
mov				ebx, [eax]
cmp				ebx, TRUE
jne				endprog
jmp				combination


endprog:

;Display number of problems correctly/incorrectly answered

mWriteStr		correct_answ
mov				esi, OFFSETnumRight
mov				eax, [esi]
call			WriteDec
call			Crlf

mWriteStr		incorrect_answ
mov				esi, OFFSETnumWrong
mov				eax, [esi]
call			WriteDec
call			Crlf

;Say goodbye

mWriteStr		goodbye
call			Crlf

;Restore registers/stack

popad
ret				40

ProblemLoop ENDP

END main