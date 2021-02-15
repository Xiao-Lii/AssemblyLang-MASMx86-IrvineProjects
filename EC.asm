Title EC.asm
;// Program Description: In-Class Ec-Test1 Opportunity 
;// Author: Lee Phonthongsy
;// Creation Date: September 30th, 2020


include Irvine32.inc

.data
move textequ <mov>
clearEAX equ <mov eax, 0>
clearEBX equ <mov ebx, 0>
clearECX equ <mov ecx, 0>
clearEDX equ <mov edx, 0>
myArr1 SWORD 23d, 47d, 52d, 31d, 34d, 87d, 89d, 67d, 0d, 13d
myArr2 SWORD 9 DUP(?)

.code
main proc
cleareax
clearebx
clearecx
clearedx

;// Indexed Operand
mov esi, 0

;// Set ECX Register Counter to Length of Array 2
mov ecx, LENGTHOF myArr2

L1 :
	mov ax, [myArr1 + esi]				;// Move Array1 Index i(esi) to AX register
	add esi, 2							;// Increase ESI by 2 bytes
	mov bx, [myArr1 + esi]				;// Move Array1 Index i(esi) + 1 to BX register
	sub ax, bx							;// Subtract AX from BX register
	mov[myArr2 + (esi - 2)], ax			;// Save value to Array2 Index i(esi) - 1
	clearEAX							
	clearEBX							
	loop L1								;// Begin L1 Loop, Decrease ECX(counter) register


	exit
main endp
end main