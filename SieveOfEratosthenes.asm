TITLE SieveOfEratosthenes.asm
;// Author:  Lee Phonthongsy
;// Date:    November 2020
;// Description: This program presents a menu allowing the user to pick a menu option
;//              which then prints all prime numbers from 2 up to n, which will be a user
;//				 input integer from 2-1000
;//              1. Print all prime numbers (2 - n <= 1000)
;//				 2. Exit
;// ====================================================================================

include Irvine32.inc

PrintPrimes PROTO,
count: DWORD								;// number of values ? ? to display

FIRST_PRIME = 2
LAST_PRIME = 1000;

.data
	commaStr BYTE ",", 0
	sieve BYTE LAST_PRIME DUP(? )

.code
main PROC
	;// Initialize the array to zeros
	mov ecx, LAST_PRIME
	mov edi, OFFSET sieve
	mov al, 0
	cld
	rep stosb


	mov esi, FIRST_PRIME

	.WHILE Esi < LAST_PRIME
	.IF Sieve[esi * TYPE sieve] == 0			;// is current entry prime ?
	call MarkMultiples							;// yes: mark all of its multiples
	.ENDIF
	inc esi										;// move to next table entry
	.ENDW

	INVOKE PrintPrimes, LAST_PRIME				;// display all primes found

exit
main ENDP

;// ------------------------------------------------ - -
MarkMultiples PROC
;// Mark all multiples of the value passed in ESI.
;// Notice we use ESI as the prime value, and
;// Take advantage of the "scaling" feature of indirect
;// Operands to locate the address of the indexed item :
;// [Esi * TYPE sieve]
;// ------------------------------------------------ - -
push eax
push esi
mov eax, esi									;// prime value
add esi, eax									;// start with first multiple

L1 : 
	cmp esi, LAST_PRIME; end of array ?
	ja L2; yes
	mov sieve[esi * TYPE sieve], 1				;// no: insert a marker
	add esi, eax
	jmp L1; repeat the loop

L2 : 
	pop esi
	pop eax
	ret
	MarkMultiples ENDP


;// ------------------------------------------------ - -
PrintPrimes PROC,
count: DWORD;// number of values ? ? to display
;//
;// Display the list of prime numbers
;// ------------------------------------------------ - -

.data
;// count DWORD ? ;// number of values ? ? to display

.code
mov esi, 1
mov eax, 0
mov ecx, count

L1 : 
	mov al, sieve[esi * TYPE sieve]
	.IF Al == 0
	mov eax, esi
	call WriteDec
	mov edx, OFFSET commaStr
	call WriteString
	.ENDIF
	inc esi
	loop L1

ret
PrintPrimes ENDP


END main