Title pa2.asm
;// Program Description: Programming Assignment #2 that computes a sum, has overflow and a carry in the registers, and executes a macro
;// Author: Lee Phonthongsy
;// Creation Date: September 13th, 2020

include Irvine32.inc

.data
move textequ <mov>
clearEAX equ <mov eax, 0>
clearEBX equ <mov ebx, 0>
clearECX equ <mov ecx, 0>
clearEDX equ <mov edx, 0>
mySum DWORD 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9
overflowVal DWORD 01111111111111111111111111111111b		;// Decimal #: 2,147,483,647
overflowVal2 DWORD 01111111111111111111111111111111b	;// Decimal #: 2,147,483,647
carryVal DWORD	00101011101011001010110110101011b
carryVal2 DWORD 00111111111111111111111111111111b


.code
main proc

	;// Clearing the Registers - BEGINNING OF PART 1
	clearEAX
	clearEBX
	clearECX
	clearEDX

	;// Saving the value of mySum(20bits) into register EDX
	mov	edx, mySum			;// Setting EDX register to the value of mySum
	call dumpregs
	;// END OF PART 1 

	;// Clearing the EBX register - BEGINNING OF PART 2 (EBX Overflow)
	clearEDX
	
	;//	Creating an overflow value that will be stored in register EBX
	mov ebx, overflowVal
	add ebx, overflowVal2	;// Adding overflowVal2 to ebx (overflowVal)
	call dumpregs

	;// Saving Value to ECX register & setting off Carry Flag 
	mov ecx, carryVal
	sub ecx, carryVal2		;// Subtracting carryVal2 from value in eax (CarryVal1)
	call dumpregs
	;// END OF PART 2

	;// Clearing Registers & Creating a Macro - Beginning of Part 3
	clearEBX
	clearECX
	SECONDS_IN_DAY EQU <24 * 60 * 60>		;// Should be equivalent to Decimal #: 86400 or HEX: 15180

	;// Moving Value from Seconds_In_Day to register EAX
	mov eax, SECONDS_IN_DAY
	call dumpregs
	
	clearEAX
	;// END OF PART 3
	
	exit
main endp
end main