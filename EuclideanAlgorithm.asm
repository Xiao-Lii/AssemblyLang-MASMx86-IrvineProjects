TITLE EuclideanAlgorithm.asm
;// Author:  Lee Phonthongsy
;// Date:    November 21 2020
;// Description: This program presents a menu allowing the user to pick a menu option that will execute:
;//              1. Find the greatest common divisor(GCD) between two integers
;//				 2. Print a Matrix of Words
;//				 3. Exit
;// ====================================================================================

Include Irvine32.inc

COMMENT !
;// SOURCE FOR EUCLIDEAN ALGORITHM LOGIC
file:///C:/Users/Lee/Downloads/CSCI-2525%20Homework%208-1.pdf
https://www.khanacademy.org/computing/computer-science/cryptography/modarithmetic/a/the-euclidean-algorithm
!

;// Macros
ClearEAX textequ <mov eax, 0>
ClearEBX textequ <mov ebx, 0>
ClearECX textequ <mov ecx, 0>
ClearEDX textequ <mov edx, 0>
ClearESI textequ <mov esi, 0>
ClearEDI textequ <mov edi, 0>
Newline  textequ <0ah, 0dh>

.data
UserOption byte 0h
;// Variables for Option 1: GCD between 2 integers
subUserOption byte 0h
num1 DWORD ?
num2 DWORD ?
;// Variables for Option 2: Produce 6x6 Matrix of random characters
mTable	BYTE 6 DUP(?)
		BYTE 6 DUP(?)
		BYTE 6 DUP(?)
		BYTE 6 DUP(?)
		BYTE 6 DUP(?)
		BYTE 6 DUP(?)
rowSize = 6


.code
	main PROC	
	call ClearRegisters					;// Clear all Registers

	startHere:							;// Starting point to Redisplay Menu
		mov ebx, OFFSET UserOption		;// Passing address of UserOption in ebx to display Menu Proc
		call displayMenu

	Option1:
		cmp UserOption, 1				;// Useroption 1 = Find the greatest common divisor(GCD) between two integers
		jne Option2
		push ebx						;// Push offset of useroption input into EBX
		call clrscr						;// Clear screen of Main Menu for GCD Prompts 

		RestartOpt1:
			mov ebx, offset num1		;// Setting up EBX with address of num1 variable
			mov edx, offset num2		;// Setting up EDX with address of num2 variable
			call getN					;// Get num-inputs from User, returns to num1 and num2 Variable
			;// EBX = Address of Num1 & EDX = Address of Num2
			call printGCD				;// Call 'printGCD' to begin printing GCD Header 
			call crlf					;// Print a new line

			;// Prompt the User if they'd like to Enter another pair of integers
			mov ebx, OFFSET subUserOption
			call displaySubMenu1
			cmp subUserOption, 'Y'		;// Check if subUserInput = 'Y'
			je RestartOpt1				;// If so, restart option 1
			cmp subUserOption, 'y'		;// Check if subUserInput = 'y'
			je RestartOpt1				;// If so, restart option 1
										;// If not, proceed to end Option1
			pop ebx						;// Popping back offset of useroption input into EBX
			jmp starthere

	Option2:
		cmp UserOption, 2				;// Useroption 2 = Print Matrix of Words
		jne Option3
		call generateMatrix
		jmp starthere

	Option3:
		cmp UserOption, 3				;// Useroption 3 = Exit Program
		jne oops						;// Otherwise all other options = Error 
		call waitmsg
		jmp QuitIt

	Oops:								;// Invalid option entered
		call errorMsg
		jmp starthere

	QuitIt:
		exit

main ENDP 

;// Procedures
;// ===============================================================

DisplayMenu PROC
;// Description:	Displays the Main Menu to the screen and gets user input 
;// Receives:		EBX = Address/Offset of UserOption variable
;// Returns:		User input will be saved to UserOption variable

.data
MainMenu byte '------------ Main Menu ------------', 0Ah, 0Dh,
'1. Find the greatest common divisor(GCD) between two integers', 0Ah, 0Dh,
'2. Print a Matrix of Words', 0Ah, 0Dh,
'3. Exit', 0Ah, 0Dh, 0Ah, 0Dh,
'Please enter an option between 1 and 3 -->  ', 0h

.code
	push edx							;// preserves current value of edx - the strings offset
	call clrscr;
	mov edx, offset MainMenu			;// required by WriteString
	call WriteString
	call readhex						;// get user input
	mov byte ptr[ebx], al				;// save user input to UserOption
	pop edx								;// restores current value of edx
ret
DisplayMenu ENDP

;// -------------------------------------------------------------

DisplaySubMenu1 PROC
;// Description:	Displays the sub Restart Prompt to the screen and gets user input 
;// Receives:		EBX = Address/Offset of subUserOption variable
;// Returns:		User input will be saved to subUserOption variable

.data
restartPrompt byte 'Do you wish to enter another pair? (Y/N)', Newline, 0h

.code
	push edx							;// preserves current value of edx - the strings offset
	mov eax, 0
	mov edx, offset restartPrompt		;// required by WriteString
	call WriteString
	call readChar						;// get user input
	mov byte ptr[ebx], al				;// save user input to subUserOption
	pop edx								;// restores current value of edx
ret
DisplaySubMenu1 ENDP

;// -------------------------------------------------------------

getN PROC
;// Description:	Displays for two integer prompts from user and checks if they're within 0 - 1000 
;// Receives:		EBX = Address/Offset of num1, EDX = Address/Offset of num2 
;// Returns:		Num1 and Num2 user-input integers  

.data
	nPrompt byte 'Enter a positive integer up to 1,000,000: ', 0h

.code
	;// Time for 1st Integer Input
	getNInput:
		push edx						;// preserves current value of edx - num2 offset
		mov edx, offset nPrompt			;// Required by WriteString
		call WriteString
		call readInt					;// Get user input integer
		cmp eax, 0F4240h				
		jg errorN1						;// If greater than 1,000,000d request aynother input again
		cmp eax, 0d						
		jl errorN1						;// If less than 0, request another n input again
		mov DWORD PTR[ebx], eax			;// Otherwise save user input to num1

	;// Time for 2nd Integer Input
	getNInput2:
		mov edx, offset nPrompt			;// Required by WriteString
		call WriteString
		pop edx							;// Restoring EDX to num2 Offset save user-input for num2 
		call readInt					;// Get user input integer
		cmp eax, 0F4240h
		jg errorN2						;// If greater than 1,000,000d request another input again
		cmp eax, 0d
		jl errorN2						;// If less than 0, request another n input again
		mov DWORD PTR[edx], eax			;// Saving 2nd User input to val2 variable 
		jmp endNInput

	errorN1:
		call errorMsg
		jmp getNInput

	errorN2:
		call errorMsg
		jmp getNInput2

	endNInput:
ret
getN ENDP

;// -------------------------------------------------------------

printGCD PROC
;// Description:	Prints GCD Header & Checks if there's a greatest common divisor for two integers 
;// Receives:		EBX = Address/Offset of num1, EDX = Address/Offset of num2 
;// Returns:		Num1 and Num2 user-input integers  

COMMENT !
If A = 0 then GCD(A, B) = B, since the GCD(0, B) = B, and we can stop.
If B = 0 then GCD(A, B) = A, since the GCD(A, 0) = A, and we can stop.
A in quotient remainder form (A = B * Q + R)
Num1 = A and Num2 = B for this case 
!

.data
gcdHeader byte 'Number #1	Number #2	GCD	GCD Prime?', Newline, 
'---------------------------------------------------', Newline, 0h
tempVal1 DWORD ?
tempVal2 DWORD ?

.code
	push edx							;// preserves current value of edx - num1 offset/address
	mov edx, offset gcdHeader			;// Required by WriteString
	call WriteString
	pop edx								;// restores edx

	;// Block for Printing Number 1(A)
	mov eax, DWORD PTR[ebx]				;// Moving value at offset in EBX = Num1 -> EAX for division
	mov tempVal1, eax
	call writeDec						;// This will print Number 1(A) to our table
	call printTab

	;// Block for Printing Number 2(B)
	mov eax, DWORD PTR[edx]				;// Setting up EAX to print Num2(B)
	mov tempVal2, eax
	call printTab
	call WriteDec						;// This will print Number 2(B) to our table
	call printTab
	call printTab

	;// Before we call findGCD, we want to ensure that the value at EBX > EDX
	;// We don't want our divisor to be greater than our Dividend for findGCD proc  
	;// EAX = tempVal2 currently 
	cmp eax, tempVal1
	jg switchValues

	call findGCD						
	jmp endPrintGCD						;// When done w/ recursive call, jump to end when we've found GCD

	switchValues:
		mov DWORD PTR[ebx], eax			;// Otherwise, overwrite & save 2nd User input to num1 = dividend 
		mov eax, tempVal1
		mov DWORD PTR[edx], eax			;// Overwrite and save 1st User input to num2 = divisor 

	call findGCD

	endPrintGCD:
ret
printGCD ENDP

;// -------------------------------------------------------------

findGCD PROC 
;// Description:	Checks if there's a greatest common divisor for two integers 
;// Receives:		EBX = Address/Offset of num1(A), EDX = Address/Offset of num2(B)
;// Returns:		New value of Num1(Quotient) and Num2(Remainder) after dividing num1 by num2

.data
tempB DWORD ? 
newB DWORD ? 
two DWORD 2d
foundPrime byte 'F'

.code
	mov ecx, 0
	mov eax, DWORD PTR[edx]				;// Saving our B value to a temp variable for division later
	mov tempB, eax
	mov eax, 0							;// Setting EAX = 0

	;// Remember we'll need to check if A or B = 0, if so, we have our GCD and need to stop calling find GCD
	cmp DWORD PTR[ebx], 0				;// Check if num1(A) = 0, if so, jump to end
	je endBGCD
	cmp DWORD PTR[edx], 0				;// Check if num2(B) = 0, if so, jump to end
	je endAGCD
	mov eax, DWORD PTR[ebx]				;// Moving value at offset in EBX = Num1 -> EAX for division
	push edx							;// Push EDX b/c Remainder from Division will be saved to EDX
	mov edx, 0							;// Important! - Must set EDX = 0 or can experience Integer Overflow 
	div tempB							;// Divide EAX = Current A number by tempB = Current B Number

	;// Remember A = B, EDX = Remainder(our new B value), and EAX = Quotient
	mov newB, edx						;// Saving EDX(remainder) to our newB value 
	pop edx								;// Return Offset/Address of our Num2(B) value
	mov eax, newB
	mov DWORD PTR[edx], eax				;// Updating Remainder(our new B value) -> New num2 Value
	mov eax, tempB						;// Moving our Previous Value of B -> EAX
	mov DWORD PTR[ebx], eax				;// Updating num1(A) -> To be our previous value of B

	call findGCD						;// Recursively call findGCD again until A or B = 0 

	;// When done calling 'findGCD' recursively, sometimes the function will try to return here
	;// We need to skip to the end if we already know if our GCD is a prime number or not
	mov eax, 0
	mov al, foundPrime
	cmp al, 'T'
	je endGCD

	;// Block for Printing GCD between both Integers
	;// If we reach this point, A = GCD & B = 0
	endAGCD:
		mov eax, DWORD PTR[ebx]
		call WriteDec					;// This will print our GCD to our table
		call printTab					
		mov ecx, DWORD PTR[ebx]			;// Moving GCD to ECX for loop counter in 'checkPrime' Proc 
		call checkPrime					;// Checking if GCD is a prime number
		mov foundPrime, 'T'				;// In case of recursion issues, we change foundPrime = T/True 
		pop edx							;// Restore EDX 
		jmp endGCD						;// Jump to end of GCD

	;// Block for Printing GCD between both Integers
	;// If we reach this point, B = GCD & A = 0
	endBGCD:
		mov eax, DWORD PTR[edx]
		call WriteDec					;// This will print our GCD to our table
		call printTab
		mov ecx, DWORD PTR[edx]			;// Moving GCD to ECX for loop counter in 'checkPrime' Proc 
		call checkPrime					;// Checking if GCD is a prime number
		mov foundPrime, 'T'				;// In case of recursion issues, we change foundPrime = T/True 
		pop edx							;// Restore EDX 
		jmp endGCD						;// Jump to end of GCD

	endGCD:
		;// mov ecx, offset foundPrime
ret
findGCD ENDP

;// -------------------------------------------------------------

checkPrime PROC
;// Description:  Checks if an integer is a prime number
;// Receives :    ECX = Integer to Check, EAX = Greatest Common Divider Integer 
;// Returns :     "Yes" if prime or "No" if integer isn't a prime number 

.data
yesPrompt byte 'Yes', 0h
noPrompt byte 'No', 0h
divisor DWORD 2
tempGCD DWORD ?

.code
	push ebx							;// Saving value of EBX
	push edx							;// Saving value of EDX 
	mov tempGCD, ecx					;// Saving ECX to tempGCD variable 
	cmp tempGCD, 1						;// Check if GCD = 1
	je notPrime							;// If so, technically not prime 
	cmp tempGCD, 2						;// Check if GCD = 2 
	je isPrime							;// If so, 2 is Prime

	checkNum:
		mov edx, 0						;// Important! - Must set EDX = 0 or can experience Integer Overflow 
		mov eax, tempGCD				;// Moving GCD to EAX to be dividend
		div divisor						;// Divide EAX by current divisor value up to GCD
		;// Remember EDX = Remainder and EAX = Quotient  
		cmp edx, 0						;// Checking if EDX(remainder) = 0
		je notPrime						;// If so, that means GCD is not a prime number 
		inc divisor						;// Increase our current divisor value 
		mov eax, divisor
		cmp eax, tempGCD				;// Checking if our divisor has reached up to our GCD/2
		jge isPrime						;// If so, we know our GCD is a prime #
		loop checkNum					;// Else, continue looping 

	notPrime:
		push edx						;// Save value in currently in edx
		mov edx, offset noPrompt		;// prep to write string
		call writestring
		pop edx							;// restore value in edx
		jmp endCheckPrime

	isPrime:
		push edx						;// Save value in currently in edx
		mov edx, offset yesPrompt		;// prep to write string
		call writestring
		pop edx							;// restore value in edx
		jmp endCheckPrime
		
	endCheckPrime:	
		mov divisor, 2
pop edx									;// Saving value of EDX
pop ebx									;// Saving value of EBX
ret
checkPrime ENDP

;// -------------------------------------------------------------


printTab PROC
;// Description:  Displays Error Message on invalid entry
;// Receives :    Nothing
;// Returns :     An error message to the user

.data
tabVal BYTE "	", 0h

.code
	push edx							;// Save value in currently in edx
	mov edx, offset tabVal				;// prep to write string
	call writestring
	pop edx								;// restore value in edx

ret
printTab ENDP

;// -------------------------------------------------------------

errorMsg PROC
;// Description:  Displays Error Message on invalid entry
;// Receives :    Nothing
;// Returns :     An error message to the user

.data
	errormessage byte 'You have entered an invalid option. Please try again.', 0h

.code
	push edx							;// Save value in currently in edx
	mov edx, offset errormessage		;// prep to write string
	call writestring
	call crlf
	pop edx								;// restore value in edx

ret
errorMsg ENDP

;// -------------------------------------------------------------

ClearRegisters PROC
;// Description:  Clears the registers EAX, EBX, ECX, EDX, ESI, EDI
;// Requires:  Nothing
;// Returns:  Nothing, but all registers will be cleared.

	clearEAX
	clearEBX
	clearECX
	clearEDX
	clearESI
	clearEDI
ret
ClearRegisters ENDP

;// ---------------------------------------------------------------

generateMatrix PROC
;// Description:  Randomly generates a 6x6 Matric of random characters
;// Receives :    Nothing
;// Returns :     An error message to the user

COMMENT !
	EBP = Row Index
	ESI = Column Index
	Rowsize(a constant) = # of bytes in each Row
	Must be Row Major Order
!

.data

.code


ret
generateMatrix ENDP

;// -------------------------------------------------------------

END main 