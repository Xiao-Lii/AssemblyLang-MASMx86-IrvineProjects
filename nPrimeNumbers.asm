TITLE hw7.asm
;// Author:  Lee Phonthongsy
;// Date:    November 2020
;// Description: This program presents a menu allowing the user to pick a menu option
;//              which then prints all prime numbers from 2 up to n, which will be a user
;//				 input integer from 2-1000
;//              1. Print all prime numbers (2 - n <= 1000)
;//				 2. Exit
;// ====================================================================================

Include Irvine32.inc

;// Macros
ClearEAX textequ <mov eax, 0>
ClearEBX textequ <mov ebx, 0>
ClearECX textequ <mov ecx, 0>
ClearEDX textequ <mov edx, 0>
ClearESI textequ <mov esi, 0>
ClearEDI textequ <mov edi, 0>
Newline  textequ <0ah, 0dh>
maxLength = 151d

showPrimes PROTO, n:DWORD 

.data
	UserOption byte 0h
	nInput DWORD ?
	factor		DWORD ?

	
.code
	main PROC
	call ClearRegisters								;// Clears Registers

	startHere:										;// Starting point to Redisplay Menu
		mov ebx, OFFSET UserOption					;// Passing address of UserOption in ebx to display Menu Proc
		call displayMenu

	opt1:
		cmp UserOption, 1							;// Useroption 1 = Print all prime numbers 
		jne opt2
		push ebx									;// Push offset of useroption input into EBX
		mov ebx, offset nInput						;// Setting up EBX with address of nInput variable
		call getN									;// Get n-input from User, returns to nInput Variable
		invoke showPrimes, nInput
		pop ebx										;// Popping back offset of useroption input into EBX
		jmp starthere

	opt2:
		cmp UserOption, 2							;// Useroption 2 = Exit Program
		jne oops									;// Otherwise all other options = Error 
		jmp QuitIt									

	oops:											;// Invalid option entered
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
	MainMenu byte 'MAIN MENU', 0Ah, 0Dh,
	'----------------', 0Ah, 0Dh,
	'1. Print all prime numbers (2 - n <= 1000)', 0Ah, 0Dh,
	'2. Exit', 0Ah, 0Dh, 0Ah, 0Dh,
	'Please enter an option between 1 and 2 -->  ', 0h

.code
	push edx									;// preserves current value of edx - the strings offset
	call clrscr;
	mov edx, offset MainMenu					;// required by WriteString
	call WriteString
	call readhex								;// get user input
	mov byte ptr[ebx], al						;// save user input to UserOption
	pop edx										;// restores current value of edx
ret
DisplayMenu ENDP

;// -------------------------------------------------------------

getN PROC
;// Description:	Displays for n-prompt and gets user input 
;// Receives:		Nothing
;// Returns:		User input will be saved to 'N' variable 

.data
nPrompt byte 'Insert a value for "n" up to 1000: ', 0h

.code
	getNInput:
	push edx								;// preserves current value of edx - the strings offset
	call clrscr
	mov edx, offset nPrompt					;// Required by WriteString
	call WriteString
	call readInt							;// Get user input
	cmp ax, 1000d							;// If greater than 1000, request another n input again
	jg getNInput
	cmp ax, 0d								
	jle getNInput							;// If less than or equal to 0, request another n input again
	mov WORD PTR[ebx], ax					;// Otherwise save user input to UserOption
	pop edx									;// restores current value 
ret
getN ENDP

;// -------------------------------------------------------------

isPrime PROC
;// Description: Checks if number is a prime number
;// Receives: 
;// returns: 
;// Rquires: 
;// -------------------------------------------------------------

.data
checkNum DWORD ?
arrayLength2 DWORD ?
numArrayOffset DWORD ? 

.code
	mov arrayLength2, eax				;// Saving ArrayLength from EAX
	;// mov numArrayOffset, ebx
	;// mov	esi, offset numArray		;// esi = ptr to index in ebx
	mov esi, ebx
	mov ebx, 0
	mov	checkNum, ecx					;// Our temp # var to see if it's prime 
	cmp	ecx, 3							
	je	PrimeTrue

	PrimeLoop:							;// divide checkNum by every number in array
		cmp	ebx, arrayLength2			;// If EBX < ArrayLength
		jge	PrimeTrue					;// If True = End of array = prime
		mov	ecx, [esi]					;// Move current value of [ESI] to ECX
		mov	edx, 0						;// Reset EDX
		mov	eax, checkNum					
		div	ecx							;// EAX = checkNum / ECX
		cmp	edx, 0						;// If our remainder = 0 = Not a prime #
		je	PrimeFalse
		add	esi, 4						;// Else add 4 to ESI b/c 4 = next index to search array
		inc	ebx							;// Increment EBX 
		jmp	PrimeTrue

		
	PrimeTrue:
		mov bPrime, TRUE				
		ret

	PrimeFalse:
		mov bPrime, FALSE
		ret

isPrime ENDP

;// -------------------------------------------------------------

showPrimes PROC,
	n: DWORD

;// Description: Finds then displays all of the prime numbers up to nth prime, will only print 5 per line then continue to next line
;// Receives: N 
;// Returns: A prime number table up to n that has 5 columns at max

.data
spaceVal BYTE "   ", 0
columnNum DWORD 1						;// Our # tracker to print only 5 numbers per line
arrayLength DWORD 0						;// The size of our array 
bPrime BYTE	0
numArray DWORD 200 DUP(? )				;// Up to 1000 = 168 prime numbers max
counter DWORD 1							;// counter for number of primes we've printed (<= n)

.code
	mov	eax, 2
	call Crlf					
	call WriteDec						;// print 2
	mov	edx, OFFSET spaceVal			;// Setting up EDX to print space between numbers
	call WriteString					;// Print Space
	inc	columnNum						;// Increase our current Column Index
	cmp	n, 1							;// If n = 1, all done, so exit
	je ExitPrimes						;// If true, jump to exit procedure
	inc	counter							;// Otherwise, increase counter
	mov	esi, OFFSET numArray			;// EESI = Address/offset of numArray
	mov[esi], eax						;// 2 Becomes our 1st index
	inc	arrayLength						;// Increase our Array Size
	mov	ecx, 3							;// Until counter > n, loop through ecx by starting at 3 going up by an odd num 

ContinuePrime:
	mov	eax, counter				;// EAX = Current Counter # 
	cmp	eax, n						;// If EAX = n, Quit Out of Procedure 
	jg	ExitPrimes					;// Otherwise if counter <= n, continue

	pushad							;// Saves all Registers, from Textbook pg 327
	mov eax, arrayLength
	mov ebx, offset numArray
	call isPrime					;// call isPrime procedure
	popad							;// Restores all registers 

	cmp	bPrime, TRUE				;// Check if isPrime = ECX
	jne	NextIndex					;// Otherwise if not true, skip to next Odd Index 

	;// If ecx = prime
	mov	esi, OFFSET numArray		;// ESI = Offset/Address of our NumArray
	mov	eax, 4						;// move EAX = 4
	mul	arrayLength					;// EAX = 4 * arrayLength
	add	esi, eax					;// ESI += EAX
	mov[esi], ecx					
	inc	arrayLength					;// Increase ArrayLength
	mov	eax, [esi]					
	cmp	columnNum, 5				;// Check to see if we've printed 5 numbers in our row
	jle	PrintLine					;// If not, keep printing through line/row
	mov	columnNum, 1				;// Otherwise, Reset if column # > 5, back to 1
	call Crlf						;// Print new line

PrintLine:
	mov	eax, ecx					;// EAX = Our Prime number
	call WriteDec					;// Print prime # to chart 
	mov	edx, OFFSET spaceVal		;// Moving address of empty space to EDX
	call WriteString				;// Print Space for between numbers
	inc	columnNum					;// Increase our column number
	inc	counter						;// Increase our counter

;// Otherwise, add two to ECX
NextIndex:
	add	ecx, 2						;// increment ecx to next odd num
	jmp	ContinuePrime				;// loop

ExitPrimes:
	call Crlf
	call waitmsg					;// Wait for User to View Chart 

ret
showPrimes ENDP

;// -------------------------------------------------------------

errorMsg PROC
;// Description:  Displays Error Message on invalid entry
;// Receives :    Nothing
;// Returns :     An error message to the user

.data
errormessage byte 'You have entered an invalid option. Please try again.', 0h

.code
	push edx									;// Save value in currently in edx
	mov edx, offset errormessage				;// prep to write string
	call writestring
	call waitmsg
	pop edx										;// restore value in edx

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

END Main 