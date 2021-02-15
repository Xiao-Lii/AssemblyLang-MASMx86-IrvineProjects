Title

include Irvine32.inc

.data
move textequ <mov>
clearEAX equ <mov eax, 0>
clearEBX equ <mov eax, 0>
clearECX equ <mov eax, 0>
clearEDX equ <mov eax, 0>

.code
main proc
mov	eax, 5
call dumpregs
add	eax, 6

exit
main endp