Title fibonacci.asm
;// Program Description: Programming Assignment #3
;// Author: Lee Phonthongsy
;// Creation Date: September 22nd, 2020

include Irvine32.inc

.data
move textequ <mov>
clearEAX equ <mov eax, 0>	;// AH = LEFT SIDE 8-BITS, AL = RIGHT SIDE 8-BITS
clearEBX equ <mov ebx, 0>	;// BH = LEFT SIDE 8-BITS, BL = RIGHT SIDE 8-BITS
clearECX equ <mov ecx, 0>	;// CH = LEFT SIDE 8-BITS, CL = RIGHT SIDE 8-BITS
clearEDX equ <mov edx, 0>	;// DH = LEFT SIDE 8-BITS, DL = RIGHT SIDE 8-BITS
clearAL equ <mov al, 0>
fibArray BYTE 0d, 1d		;// Only 1st & 2nd index allowed to be filled 

.code
main proc
cleareax
clearebx
clearecx
clearedx

;// Beginning of 2.A - Fibonacci

;// Reminders: No Loops, no pre-filled array will all elements, up to n = 8 
;// BYTE array = +1 for next index

newArrayD DWORD lengthof fibArray dup(0)

;// n = 2
mov esi, offset fibArray	;// Set ESI register to offset of fibArray 
mov al, [esi]				;// Dereference Index 0 to AL register
inc esi						;// Increase ESI to next index of fibArray 
add al, [esi]				;// 0 index + 1st Index = (0 + 1) = 1
mov [fibArray + 2], al		;// Save to 2nd Index of fibArray

clearAL

;// n = 3
mov al, [esi]				;// Dereference ESI register to AL register
inc esi						;// Increase ESI to next index of fibArray 
add al, [esi]				;// 1st index + 2nd Index = (1 + 1) = 2
mov[fibArray + 3], al		;// Save to 3rd Index of fibArray

clearAL

;// n = 4
mov al, [esi]				;// Dereference ESI register to AL register
inc esi						;// Increase ESI to next index of fibArray 
add al, [esi]				;// 2nd index + 3rd Index = (1 + 2) = 3
mov[fibArray + 4], al		;// Save to 4th Index of fibArray

clearAL

;// n = 5
mov al, [esi]				;// Dereference ESI register to AL register
inc esi						;// Increase ESI to next index of fibArray 
add al, [esi]				;// 3rd index + 4th Index = (2 + 3) = 5
mov[fibArray + 5], al		;// Save to 5th Index of fibArray

clearAL

;// n = 6
mov al, [esi]				;// Dereference ESI register to AL register
inc esi						;// Increase ESI to next index of fibArray 
add al, [esi]				;// 4th index + 5th Index = (3 + 5) = 8
mov[fibArray + 6], al		;// Save to 6th Index of fibArray

clearAL

;// n = 7
mov al, [esi]				;// Dereference ESI register to AL register
inc esi						;// Increase ESI to next index of fibArray 
add al, [esi]				;// 5th index + 6th Index = (5 + 8) = 13
mov[fibArray + 7], al		;// Save to 7th Index of fibArray

clearAL

;// n = 8
mov al, [esi]				;// Dereference ESI register to AL register
inc esi						;// Increase ESI to next index of fibArray 
add al, [esi]				;// 6th index + 7th Index = (8 + 13) = 21
mov[fibArray + 8], al		;// Save to 8th Index of fibArray

call dumpregs
;// End of 2.A - Fibonacci 

;// Beginning of 2.B - Fibonacci Array [0, 1, 1, 2, 3, 5, 8, 13, 21]
clearAL
clearEBX

;// DWORD size PTR starting at FibArray Index 4: 03h, 05h, 08h, 0Dh
mov ebx, DWORD PTR [fibArray + 4]

call dumpregs

exit
main endp
end main