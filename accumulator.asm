TITLE Program Template     (accumulator.asm)

; Author:Trevor Rollins             
; Date:10/29/2017
; Description:This program will allow the user to enter numbers between -1
; and -100 and calculate the average.  It will validate user input.

INCLUDE Irvine32.inc

NAME_SIZE		=		24
MIN				=		-100
MAX				=		-1
ZERO			=		0

.data

intro_1			BYTE	"Integer Accumulator",0
intro_2			BYTE	"Programmed by Trevor Rollins",0
name_prompt		BYTE	"What's your name?",0
greeting		BYTE	"Hello, ",0
number_prompt	BYTE	"Enter numbers between -100 and -1 and I'll find the average.",0
too_low			BYTE	"Your number must be at least -100,",0
range_prompt	BYTE	"Enter a non-negative number when you are finished.",0
enter_number	BYTE	"Enter number ",0
colon			BYTE	": ",0
no_numbers		BYTE	"I can't take the average without any valid numbers.",0
numbers1		BYTE	"You entered ",0
numbers2		BYTE	" valid numbers",0
sum_display		BYTE	"The sum of your number is ",0
average_display	BYTE	"The rounded average is ",0
outro			BYTE	"Thanks for for playing ",0
EC_1			BYTE	"**EXTRA CREDIT: The number entries are numbered during user input.",0

;This is the line counter for extra credit

counter			DWORD	1

;These terms store the user input, and calculated results

user_name		BYTE	25 DUP (0)
accumulator		SDWORD	0
average			SDWORD	0
valid_numbers	DWORD	0

.code
main PROC

;Extra Credit
mov			edx, OFFSET EC_1
call		WriteString
call		Crlf

;Introductions

mov			edx, OFFSET intro_1
call		WriteString
call		Crlf
mov			edx, OFFSET intro_2
call		WriteString
call		Crlf

;Prompts the user to input name

mov			edx, OFFSET name_prompt
call		WriteString
mov			edx, OFFSET user_name
mov			ecx, NAME_SIZE
call		ReadString
call		Crlf

;Greets user

mov			edx, OFFSET greeting
call		WriteString
mov			edx, OFFSET user_name
call		WriteString
call		Crlf

;Gives user input instructions

mov			edx, OFFSET number_prompt
call		WriteString
call		Crlf
mov			edx, OFFSET range_prompt
call		WriteString
call		Crlf

getinput:
;Gets input from user

mov			edx, OFFSET enter_number
call		WriteString
mov			eax, counter
call		WriteDec
inc			counter
mov			edx, OFFSET colon
call		WriteString
call		ReadInt

;Validates input

cmp			eax, MIN						
jl			range							;jump if input<-100
cmp			eax, MAX
jg			checkzero						;jump if input>-1
add			accumulator, eax	
inc			valid_numbers
jmp			getInput

range:
;Tells user input must be within the range

mov			edx, OFFSET too_low
call		WriteString
call		Crlf
jmp			getinput

checkzero:
;Check to see if user entered no valid numbers
cmp			valid_numbers, ZERO
jnz			continue						;jump if valid_numbers!=0
mov			edx, OFFSET no_numbers
call		WriteString
call		Crlf
jmp			goodbye


continue:
;Displays valid numbers entered

mov			edx, OFFSET numbers1
call		WriteString
mov			eax, valid_numbers
call		WriteDec
mov			edx, OFFSET numbers2
call		WriteString
call		Crlf

;Displays sum

mov			edx, OFFSET sum_display
call		WriteString
mov			eax, accumulator
call		WriteInt
call		Crlf

;Displays roudned average

mov			eax, accumulator
cdq
idiv		valid_numbers
mov			average, eax
mov			edx, OFFSET average_display
call		WriteString
mov			eax, average
call		WriteInt
call		Crlf

goodbye:
;Goodbye

mov			edx, OFFSET outro
call		WriteString
mov			edx, OFFSET user_name
call		WriteString
call		Crlf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main