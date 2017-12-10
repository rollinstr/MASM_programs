TITLE Composite Numbers     (composite_numbers.asm)

; Author:Trevor Rollins                
; Date:11/5/2017
; Description:This program will display up to 999999 composite numbers, as specified by the user.
;It will then display them at 200 numbers at a time.

INCLUDE Irvine32.inc

MIN				=		1
MAX				=		999999
FALSE			=		0
TRUE			=		1
ZERO			=		0

.data

intro_1			BYTE	"Composite Numbers",0
intro_2			BYTE	"Programmed by Trevor Rollins",0
EC_1			BYTE	"**EC: This program aligns the columns of composite numbers.",0
EC_2			BYTE	"**EC: This program allows the user to choose more than 400 composite",0
EC_3			BYTE	"      numbers, and prints them in pages of 200 at a time.",0
number_prompt	BYTE	"Enter the numbers of composite numbers you'd like to see.",0
range			BYTE	"The number must be between 1 and 999999.",0
range_warning_1	BYTE	"The number must be at least 1",0
range_warning_2	BYTE	"The number must be 999999 or less",0
keypress		BYTE	"Press any key to continue...",0
spaces3			BYTE	"   ",0
spaces4			BYTE	"    ",0
spaces5			BYTE	"     ",0
spaces6			BYTE	"      ",0
spaces7			BYTE	"       ",0
spaces8			BYTE	"        ",0
spaces9			BYTE	"         ",0
outro			BYTE	"Thanks for for playing, goodbye! ",0

;These terms store the user input, and calculated results

input			DWORD	?
isValid			DWORD	FALSE
compCounter		DWORD	0
lineCounter		DWORD	0
pageCounter		DWORD	0
composite		DWORD	2
divisor			DWORD	2


.code
main PROC

call			Intro
call			ExtraCredit
call			GetUserData
call			ShowComposites
call			Farewell

	exit	; exit to operating system
main ENDP
;********************************************************************
;Description:Displays the intro messages to the user
;Recieves:None
;Returns:None
;Preconditions:Strings must have already been initialized
;Registers Changed:None
;********************************************************************
Intro PROC

;Save registers

push			edx

;Display intro

mov				edx, OFFSET intro_1
call			WriteString
Call			Crlf
mov				edx, OFFSET intro_2
call			WriteString
call			Crlf

;Restore registers

pop				edx
ret

Intro ENDP
;********************************************************************
;Description:Displays the extra credit messages
;Recieves:None
;Returns:None
;Preconditions:Strings must have already been initialized
;Registers Changed:None
;********************************************************************
ExtraCredit PROC

;Save register

push			edx

;Display extra credit lines

call		Crlf
mov			edx, OFFSET EC_1
call		WriteString
call		Crlf
mov			edx, OFFSET EC_2
call		WriteString
call		Crlf
mov			edx, OFFSET EC_3
call		WriteString
call		Crlf
call		Crlf

;Restore registers

pop			edx
ret

ExtraCredit ENDP
;********************************************************************
;Description:Prompts user for input, then calls validate procedure to
;validate input.  Reprompts if necessary
;Recieves:None
;Returns:None
;Preconditions:Variables must be global
;Registers Changed:None
;********************************************************************
GetUserData PROC

;Save registers

push			edx
push			eax

;Prompting user for number

mov				edx, OFFSET number_prompt
call			WriteString
Call			Crlf
mov				edx, OFFSET range
call			WriteString
call			Crlf

;Storing input, and calling the validate function in loop until input is valid

getinput:
call			ReadInt
mov				input, eax
call			Validate
cmp				isValid, FALSE
je				getinput

;Restore Registers

pop				eax
pop				edx
ret

GetUserData ENDP
;********************************************************************
;Description:Checks that input is within the range, gives warning messages
;if not.
;Recieves:None
;Returns:None
;Preconditions:Variables must be global
;Registers Changed:None
;********************************************************************
Validate PROC

;Save registers

push			edx

;Check input to make sure it's within the range

cmp				input, MAX
jg				toolarge
cmp				input, MIN
jl				toosmall
jmp				valid

;Display warning messages

toolarge:
mov				edx, OFFSET range_warning_2
call			WriteString
Call			Crlf
jmp				continue

toosmall:
mov				edx, OFFSET range_warning_1
call			WriteString
Call			Crlf
jmp				continue

;Change isValid to TRUE

valid:
mov				isValid, TRUE

;Restore registers

continue:
pop				edx
ret

Validate ENDP
;********************************************************************
;Description:Displays the number of composite numbers that the user specified.
;Recieves:None
;Returns:None
;Preconditions:Variables must be global
;Registers Changed:None
;********************************************************************
ShowComposites PROC

;Save registers

push			eax
push			ecx
push			edx

;Put input into ecx as a counter

mov				ecx, input

;This is an outer loop that calls Crlf after every 10 numbers

newline:
call			Crlf
mov				lineCounter, ZERO

;Inner loop continues until "input" number of composite number have been displayed

printComposites:
cmp				lineCounter, 10
je				newline
call			NextComposite
mov				eax, composite
call			WriteDec
call			PrintSpaces
inc				lineCounter
inc				pageCounter
cmp				pageCounter, 200
je				newpage
loop			printComposites

call			Crlf
jmp				continue

;This outer loop allows 200 composite number to be printed per page

newpage:
call			Crlf
mov				edx, OFFSET keypress
call			WriteString
call			ReadChar
mov				pageCounter, ZERO
jmp				printComposites

;Restore registers
continue:
pop				edx
pop				ecx
pop				eax
ret

ShowComposites ENDP
;********************************************************************
;Description:Determines the number of digits in the number, and prints
;spaces accordingly.
;Recieves:None
;Returns:None
;Preconditions:Variables must be global
;Registers Changed:None
;********************************************************************
PrintSpaces PROC

;Save Registers

push			eax
push			edx

;This determines how many digits are in the number to be printed, and
;decides how many spaces will be included.

mov				eax, composite
cmp				eax, 10
jl				digit1
cmp				eax, 100
jl				digit2
cmp				eax, 1000
jl				digit3
cmp				eax, 10000
jl				digit4
cmp				eax, 100000
jl				digit5
cmp				eax, 1000000
jl				digit6
jmp				digit7

digit1:
mov				edx, OFFSET spaces9
call			WriteString
jmp				continue

digit2:
mov				edx, OFFSET spaces8
call			WriteString
jmp				continue

digit3:
mov				edx, OFFSET spaces7
call			WriteString
jmp				continue

digit4:
mov				edx, OFFSET spaces6
call			WriteString
jmp				continue

digit5:
mov				edx, OFFSET spaces5
call			WriteString
jmp				continue

digit6:
mov				edx, OFFSET spaces4
call			WriteString
jmp				continue

digit7:
mov				edx, OFFSET spaces3
call			WriteString

;Restore registers

continue:
pop				edx
pop				eax
ret

PrintSpaces ENDP
;********************************************************************
;Description:Counts through numbers until a composite number is found.
;Starts at the value of the last composite.
;Recieves:None
;Returns:None
;Preconditions:Variables must be global
;Registers Changed:None
;********************************************************************
NextComposite PROC

;Save registers

push			eax
push			edx

;This is an outer loop that increments the number to be checked
;and sets the initial divisor back to 2.

incComposite:
inc				composite
mov				divisor, 2

;This inner loop divides the number being checked by the divisor.
;If the remainder is 0, then the number is composite and the loop
;is exited.  Otherwise the divisor is incremented until it is equal
;to the number being checked.

checkComposite:
mov				edx, ZERO
mov				eax, composite
div				divisor
cmp				edx, ZERO
je				continue
inc				divisor
mov				eax, divisor
cmp				eax, composite
je				incComposite
jmp				checkComposite

;Restore registers and set divisor back to 2

continue:
mov				divisor, 2
pop				edx
pop				eax
ret

NextComposite ENDP
;********************************************************************
;Description:Displays the farewell message
;Recieves:None
;Returns:None
;Preconditions:Strings must have already been initialized
;Registers Changed:None
;********************************************************************
Farewell PROC

push			edx
mov				edx, OFFSET outro
call			WriteString
call			Crlf
pop				edx
ret

Farewell ENDP

END main
