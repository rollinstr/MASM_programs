TITLE Fibonacci Numbers     (fibonacci.asm)

; Author:Trevor Rollins             
; Date:10/15/2017
; Description:This program will take the users name,
;ask them how many Fibonacci numbers they would like,
;then dispaly those numbers.

INCLUDE Irvine32.inc

MAX			=		46
MIN			=		1

ZERO		=		0

.data

;These are messages to be displayed to the user

intro_1		BYTE	"Fibonacci Numbers",0
intro_2		BYTE	"Programmed by Trevor Rollins",0
prompt_1	BYTE	"What's your name?",0
greeting	BYTE	"Hello, ",0
prompt_2	BYTE	"Please enter the number of Fibonacci terms to be displayed",0
prompt_3	BYTE	"The number must be an integer between 1 and 46.",0
prompt_4	BYTE	"How many Fibonacci terms do you want?",0
range		BYTE	"That number is out of range (1-46)",0
spaces_5	BYTE	"     ",0
spaces_6	BYTE	"      ",0
spaces_7	BYTE	"       ",0
spaces_8	BYTE	"        ",0
spaces_9	BYTE	"         ",0
spaces_10	BYTE	"          ",0
spaces_11	BYTE	"           ",0
spaces_12	BYTE	"            ",0
spaces_13	BYTE	"             ",0
spaces_14	BYTE	"              ",0
goodbye		BYTE	"Goodbye, ",0
EC_1		BYTE	"**EC: Numbers displayed in aligned columns",0

;These are variables to store user input

user_name	BYTE	25 DUP (0)
NAME_SIZE	=		24
terms		DWORD	?

;These are variables used to print Fibonacci terms

term_1		DWORD	0
term_2		DWORD	1
remainder	DWORD	?
count		DWORD	1
divisor		DWORD	5

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

mov			edx, OFFSET prompt_1
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

;Displays instructions for entering number

mov			edx, OFFSET prompt_2
call		WriteString
call		Crlf
mov			edx, OFFSET prompt_3
call		WriteString
call		Crlf


getinput:
;Gets input from user

mov			edx, OFFSET prompt_4
call		WriteString
call		ReadInt
mov			terms, eax

;Validates input

mov			eax, MIN
cmp			eax, terms
ja			tryagain					;jump if MIN>input
mov			eax, MAX
cmp			eax, terms
jb			tryagain					;jump if MAX<input
jmp			continue

tryagain:
;Tells user that input is outside range

mov			edx, OFFSET range
call		WriteString
call		Crlf
jmp			getinput

continue:
;Displays first Fibonacci term (1)

mov			eax, term_2
call		WriteDec
mov			edx, OFFSET spaces_14
call		WriteString

;Decrement the counter because first term has already been printed

dec			terms
mov			ecx, terms

;Loop for displaying Fibonacci terms

L1:
inc			count						;count will be used to check for spaces new lines

mov			eax, term_1
add			eax, term_2					;generates next Fibonacci term
call		WriteDec
mov			ebx, term_2
mov			term_1, ebx
mov			term_2, eax
jmp			spacetest					;jumps to test for spaces needed for aligned columns

print:
call		WriteString					;prints spaces between terms
mov			eax, count
mov			edx, 0
div			divisor						;checks to see if this is the fifth term
cmp			edx, ZERO
jz			newline
jmp			continueloop
newline:
call		Crlf						;caridge return if it is the fifth term printed
continueloop:
loop		L1
jmp			finish

;This will determine how many spaces are needed between terms for aligned columns.
;Each comparison is based upon how many Fibonacci terms there are with that number
;of digits.  Each time there is an additional digit, one space is removed to keep alignment.

spacetest:
mov			esi, count
cmp			esi, 6
jbe			spaces14
cmp			esi, 11
jbe			spaces13
cmp			esi, 16
jbe			spaces12
cmp			esi, 20
jbe			spaces11
cmp			esi, 25
jbe			spaces10
cmp			esi, 30
jbe			spaces9
cmp			esi, 35
jbe			spaces8
cmp			esi, 39
jbe			spaces7
cmp			esi, 44
jbe			spaces6
cmp			esi, 46
jbe			spaces5

;This sets the number of spaces to be printed between Fibonacci terms

spaces14:
mov			edx, OFFSET spaces_14
jmp			print

spaces13:
mov			edx, OFFSET spaces_13
jmp			print

spaces12:
mov			edx, OFFSET spaces_12
jmp			print

spaces11:
mov			edx, OFFSET spaces_11
jmp			print

spaces10:
mov			edx, OFFSET spaces_10
jmp			print

spaces9:
mov			edx, OFFSET spaces_9
jmp			print

spaces8:
mov			edx, OFFSET spaces_8
jmp			print

spaces7:
mov			edx, OFFSET spaces_7
jmp			print

spaces6:
mov			edx, OFFSET spaces_6
jmp			print

spaces5:
mov			edx, OFFSET spaces_5
jmp			print

finish:
;Says goodbye

call		Crlf
mov			edx, OFFSET goodbye
call		WriteString
mov			edx, OFFSET user_name
call		WriteString
call		Crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
