Title Strings.asm
;// Program Description: Programming Assignment #4 - Program should ask user for an unsigned integer input(N)
;// and print a N # of strings of randomized capital letters ranging from 7-32 characters.
;// Author: Lee Phonthongsy
;// Creation Date: October 11th, 2020

include Irvine32.inc

.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:dword

.data
	endPrompt BYTE "Please enter any key to close program.", 0h
	inputN DWORD ? 
	clearEAX equ <mov eax, 0>
	clearEBX equ <mov ebx, 0>
	clearECX equ <mov ecx, 0>
	clearEDX equ <mov edx, 0>
	move textequ <mov>


;// USE IRVINE LIBRARY FOR:
;// 1. Print each randomly generated string
;// 2. Require a key press before exiting the program
;// 3. Set the seed for random number generations
;// 4. Generate a random unsigned integer in the required range 

;//------------- BEGINNING OF MAIN PROCEDURE --------------
.code
main proc
	clearEAX
	clearEBX
	clearECX
	clearEDX

	;// Ensuring Default Text Color is White Text on Black Background
	mov eax, white + black 
	call setTextColor
	clearEAX

	call EnterInt					;// CALL TO ENTERINT PROCEDURE
	mov inputN, eax					;// SAVES USER-INPUT N TO EAX REG TO PASS TO RSTR PROCEDURE

	clearEDX
	call RStr						;// CALL TO RSTR PROCEDURE
		
	mov edx, OFFSET endPrompt		;// End Prompt - Enter any key to end Program
	call WriteString
	call ReadChar					;// Waiting for input before closing program

exit
main endp
;//--------------- END OF MAIN PROCEDURE ------------------


;//------------- BEGINNING OF ENTER INT PROCEDURE --------------
EnterInt PROC
;// Description: Prompts the user for an unsigned integer and returns the integer back
;// Receives: Nothing
;// Returns: The user-input unsigned integer
;// Requires: Nothing 
.data
	numPrompt BYTE	"Please enter the amount of strings you would like to display.", 0ah, 0dh,
	"It must be an unsigned integer. ", 0ah, 0dh, 0h

.code	
	mov edx, OFFSET numPrompt		;// OFFSET FOR JUST NUMPROMPT = 406000h
	call WriteString
	call ReadDec
	ret
EnterInt ENDP
;//--------------- END OF ENTER INT PROCEDURE ------------------


;//------------- BEGINNING OF WRITE STRING PROCEDURE --------------
RStr PROC
;// Procedure Description: Generates a string of length L(7-32) & containing random CAPITAL letters. 
;// Receives: Input (N) from the EnterInt Procedure that goes to register ECX 
;// Returns: A String of length 7-32 with randomly generated CAPITAL letters. 
;// Requires: A value in the EAX register (preferably from the EnterInt procedure)
.data
	myArr BYTE 32 DUP(?), 0h
	minRange DWORD 65				;// What we add to get the range for A-Z in ASCII value
	count DWORD ?

.code
	mov ecx, eax					;// Setting input N as the counter/# of Strings to Display
	mov edx, offset myArr			;// Setting Memory Aside for String Arrays
	call Randomize					;// Setting up Random Seed

;// Input N = # of Strings
;// EAX after Loop Start = MAX Range of Random Values 
;// We need to decide N strings, with a range of 7-32 Uppercase Letters 

L1:
	mov eax, 25						;// Our range of 7-32 Characters
	mov count, ecx					;// Saving Outer Loop Counter
	mov esi, 0						;// Setting register ESI to 0 for Indexing 
	call RandomRange
	add eax, 7						;// Adding 7 to eax, to ensure range is from 7-32
	mov ecx, eax					;// Setting the Inner Loop Counter for # of CAP LETTERS 7-32 

	L2:
		mov eax, 26					;// Setting the Min ASCII Range for CAPITAL LETTERS A-Z = 65-90 = 1Ah 
		call RandomRange
		add eax, minRange			;// Adding 65 to get to our range from 0-25 to of 65-90
		mov[myArr + esi], al
		inc esi
		loop L2

	;// CALLING TO EXTRA CREDIT FUNCTION TO PRINT STRINGS IN A RANDOM FOREGROUND COLOR, EXCEPT BLACK ON BLACK
	;// OTHERWISE TO DISPLAY NORMAL TEXT COLOR, REMOVE COMMENT ON LINE 113-114 & COMMENT OUT LINE 115
	;//call WriteString			;// Displaying String to Window
	;//call Crlf					;// New Line for next string of Characters for cleanliness 
	call extraCredit

	;// Ensuring Register ESI & ECX are cleared for Counters/Index for Loop 3 
	mov esi, 0
	clearECX

	;// Loop3 = Clearing our Array for Next Set of Characters
	mov ecx, 32						;// ECS = COUNTER = 32 b/c Array = 32 BYTES 
	L3:
		mov [myArr + esi], 0
		inc esi
		loop L3

	mov ecx, count					;// Moving Our Outer Counter Back to register ECX to be decremented 
	loop L1
	
	ret
RStr ENDP
;//--------------- END OF WRITE STRING PROCEDURE ------------------

;//------------- BEGINNING OF EXTRA CREDIT PROCEDURE --------------
extraCredit PROC
;// Description: Prints Each Null-terminated String in a Random Foreground Color
;// Receives: Nothing
;// Returns: The null-terminated string in a random foreground color on a black background
;// Requires: A null-terminated string in 'myArr' 
.data
randNum DWORD ?

.code
mov edx, offset myArr
mov ecx, 1

L1:
	mov eax, 15						;// Max Range of Colors for Text is 0-15
	call RandomRange
	mov randNum, eax				
	add randNum, 1					;// Adding 1 to ensure no chances of black text on a black background
	mov eax, randNum + black		;// Moving to EAX Reg, Text Color + Background Color
	loop L1							

call setTextColor					;// Setting Random Color as Foreground Text Color
call WriteString					;// Writing String to User Window
call Crlf							;// New line after each printed String

mov eax, white + black				;// Resetting text color back to white on black 
call setTextColor

ret
extraCredit ENDP
;//--------------- END OF EXTRA CREDIT PROCEDURE ------------------

end main