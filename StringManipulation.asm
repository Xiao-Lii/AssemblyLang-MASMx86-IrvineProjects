TITLE inclassMenu.asm
;// Author:  Diane Yoha(Base) - Lee Phonthongsy(Option 2-4)
;// Date:    October 2020
;// Description: This program presents a menu allowing the user to pick a menu option
;//              which then performs a given task.
;//              1.  The user enters a string of no more than 100 characters.
;//              2.  The entered string is converted to lower case.
;//              3.  The entered string has all non - letter elements removed.
;//              4.  Is the entered string a palindrome?
;//              5.  Print the string.
;//              6.  Exit
;// ====================================================================================

Include Irvine32.inc 

;//Macros
ClearEAX textequ <mov eax, 0>
ClearEBX textequ <mov ebx, 0>
ClearECX textequ <mov ecx, 0>
ClearEDX textequ <mov edx, 0>
ClearESI textequ <mov esi, 0>
ClearEDI textequ <mov edi, 0>
Newline  textequ <0ah, 0dh>
maxLength = 51d

.data
UserOption byte 0h
theString byte maxLength dup(0)	;// declare the array
theStringLen byte 0
isEmpty byte 'T'

.code
main PROC

call ClearRegisters          ;// clears registers

startHere:                   ;// starting point to redisplay menu
mov ebx, OFFSET UserOption   ;// Passing address of UserOption in ebx to display Menu Proc
call displayMenu

;// setting up for future procedure calls
mov edx, offset theString    ;// edx holds the offset of the string
mov ecx, lengthof theString  ;// holds the length of the string

;// find procedure to call
opt1:
    cmp useroption, 1             ;// useroption = 1
    jne opt2
    call clrscr
    mov ebx, offset thestringlen  ;// will hold the length of the entered string
    call option1
    mov isEmpty, 'F'
    jmp starthere

opt2:
    cmp isEmpty, 'T'
    je oops
    cmp useroption, 2             ;// useroption = 2
    jne opt3
    call clrscr
    movzx ecx, thestringlen       ;// sets the loop count for option 2 since a string has been entered

    call option2                  ;// underdevelopment
    jmp starthere

opt3:
    cmp isEmpty, 'T'
    je oops
    cmp useroption, 3             ;// useroption = 3    
    jne opt4
    call clrscr
    movzx ecx, thestringlen       ;// sets the loop count
    call option3
    jmp starthere

opt4:
    cmp isEmpty, 'T'
    je oops
    ;// awaiting development
    cmp useroption, 4
    jne opt5
    call clrscr
    movzx ecx, thestringlen
    call option4
    jmp starthere

opt5:        
    cmp isEmpty, 'T'
    je oops
    cmp useroption, 5             ;// useroption = 5  
    jne opt6
    call clrscr
    call option5
    call crlf
    call waitmsg
    jmp starthere

opt6:
    cmp useroption, 6             ;// useroption = 5  
    jne oops                      ;// invalid entry
    jmp quitit

oops:                             ;// invalid option entered
    call errorMsg
    jmp starthere  

quitit:
exit
main ENDP

;// Procedures
;// ===============================================================
DisplayMenu Proc
;// Description:  Displays the Main Menu to the screen and gets user input
;// Receives:  Offset of UserOption variable in ebx
;// Returns:  User input will be saved to UserOption variable

.data
MainMenu byte 'MAIN MENU', 0Ah, 0Dh,
              '==========', 0Ah, 0Dh,
              '1. Enter a String:', 0Ah, 0Dh,
              '2. Convert all elements to lower case: ',0Ah, 0Dh,
              '3. Remove all non-letter elements: ',0Ah, 0Dh,
              '4. Determine if the string is a palindrome: ',0Ah, 0Dh,
              '5. Display the string: ',0Ah, 0Dh,
              '6. Exit: ',0Ah, 0Dh, 0Ah, 0Dh,
              'Please enter a number between 1 and 6 -->  ', 0h

.code
push edx  				        ;// preserves current value of edx - the strings offset
call clrscr
mov edx, offset MainMenu        ;// required by WriteString
call WriteString
call readhex			        ;// get user input
mov byte ptr [ebx], al	        ;// save user input to UserOption
pop edx    				        ;// restores current value of edx

ret
DisplayMenu ENDP

;//--------------------------------------------------------------------------

ClearRegisters Proc
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

option1 proc uses edx ecx
;// Description: Gets string from user.
;// Receives:  Address of string
;// Returns:   String is modified and length of entered string is in saved in theStringLen

.data
    option1prompt byte 'Please enter a string of characters (', 0h
    option1prompt2 byte ' or less): ', newline, '--->   ', 0h

.code
    push edx                        ;// saving the address of the string pass in.

    mov edx, offset option1prompt   ;// Offsetting EDX to fit Option1 Prompt 
    call writestring                ;// Printing Option1 Prompt to screen
    mov eax, maxlength              ;// Saving EAX to hold max length of String (101 -> EAX)
    dec eax                         ;// Decrement by 1 to get our desire 100 characters
    call writedec                   ;// Print Decimal # to Screen
    mov edx, offset option1prompt2  ;// Offset EDX for prompt 2
    call writeString                ;// Display Prompt 2 for User Input - String 

    pop edx

    ;// add procedure to clear string
    call readstring                 ;// Reads String from User
    mov byte ptr [ebx], al          ;// length of user entered string, now in thestringlen

ret
option1 endp

;// ------------------------------------------------------------------------------------

option2 proc 
;// Description:  Converts all elements to lower case
;// Receives:  address of string in edx, esi = 0h
;// Returns:  noting, but string is now lower case. esi - original value

Comment !
'A' = 41h = 0100 0001b          ;// Notice that bit 5 is the only bit that changes 
'a' = 61h = 0110 0001b          ;// OR al, 20h;// 20h = 0010 0000b 
'Z' = 5Ah = 0101 1010b
'z' = 7Ah = 0111 1010b
!

.code
    push esi
    call option5                        ;// Displays/Writes User-Input String to Window
                                        ;// Note: ECX already contains length of String for Loop 
                                        ;// EDX holds the String's address 
    mov esi, 0                          ;// Setting up ESI Counter to Offset length of the String   

    L2:
        mov al, BYTE PTR[edx + esi]     ;// Moving individual index of string into register AL 
        cmp al, 41h                     ;// Checking to make sure it is within beginning range of 'A'
        jb keepgoing                    
        cmp al, 5Ah                     ;// Checking to make sure it is within end range of 'Z'
        ja keepgoing                    
        OR al, 20h                      ;// If letter is within A-Z, add 20h to convert to lowercase
        mov BYTE PTR [edx + esi], al    ;// Now save lowercase letter over the uppercase in the same index
        jmp keepgoing                   

        keepgoing:                      ;// if already lower case or not a letter, no need to change it, keep going.
            inc esi
            loop L2

    pop esi
    call option5
    call waitmsg
    ret
option2 endp

;// ------------------------------------------------------------------------------
option3 PROC
;// Description:  removes all non-letter elements.  There is no requirement for 
;//               option2 to have been executed.
;// Receives:  ecx - length of string
;//            edx - offset of string
;//            ebx - offset of string length variable
;//            esi preserved
;// Returns:   nothing, but the string will have all non-letter elements removed

.data
outerCounter DWORD ?
tempOffset DWORD ?

.code
    push esi
    call option5                        ;// Displays/Writes User-Input String to Window
                                        ;// Note: ECX already contains length of String for Loop 
                                        ;// EDX holds the String's address 
    mov esi, 0                          ;// Setting up ESI Counter to Offset length of the String   

    L3:
        mov al, BYTE PTR[edx + esi]     ;// Moving individual index of string into register AL 
        cmp al, 41h                     ;// Checking if index is less than 'A', if so go to -> remove Index 
        jl removeIndex
        cmp al, 7Ah                     ;// Checking if index is greater than 'z', if so go to -> remove Index
        ja removeIndex
        ;// Checking For symbols between between 'Z' and 'a' that aren't letters
        cmp al, 5Bh                     
        jge insideCheck                 ;// If greater than 'Z' go to insideCheck to verify if index is lowercase
        inc esi                         ;// Increase to look at next index
        loop L3

        ;// Inside Check checks for symbols between Upper & Lower case
        insideCheck:                    
            cmp al, 60h                 ;// If less than 'a' go to -> remove Index
            jle removeIndex 
            inc esi                     ;// Increase to look at next index
            cmp ecx, 1
            je endOption3
            loop L3

        ;// Moving index of string over + decreasing EBX (OFFSET of String Length Variable)
            
        removeIndex:                    ;// if not a uppercase or lowercase letter, remove index of string
            mov al, 0                   ;// A temp null value to remove later 
            mov BYTE PTR[edx + esi], al

            mov outerCounter, ecx       ;// Saving current counter of ECX to return after shifting String over 
            mov tempOffset, esi         ;// Saving current offset of String to return after shifting String over
            
            ;// Shifts Index of String over 
            shiftString:
                mov al, BYTE PTR[edx + esi + 1]     ;// Saves next index of string to register AL
                mov BYTE PTR[edx + esi], al         ;// Overwrites 'Non-letter' index with the next Index of String saved in AL
                inc esi                             ;// Increase to look at next index
                loop shiftString

            mov ecx, outerCounter       ;// Restores outerCounter of ECX prior to shifting string over
            mov esi, tempOffset         ;// Restores offset of string prior to shifting string over 
            loop L3
        
    endOption3:
        pop esi                         ;// Restores ESI value at beginning of option 3
        call option5                    ;// Displays New String after removing all non-letter symbols
        call waitmsg                    ;// Waits for User's input to coni
    ret
option3 ENDP

;// ------------------------------------------------------------------------

option4 PROC
;// Description: Checks to see if the string is a palindrome and will tell the user if it is or not 
;// Receives:  ecx - length of string
;//            edx - offset of string
;//            ebx - offset of string length variable
;//            esi preserved
;// Returns:   Nothing but will state if the string is a palindrome or not  
.data
    notMsg byte 'The string you have entered is not a palindrome. Please try again.', Newline, 0h
    isMsg byte 'The string you entered is a palindrome!', Newline, 0h

    halfVal DWORD ?

.code
    push esi
    mov esi, 0

    checkIndex:
        mov al, BYTE PTR[edx + esi]         ;// Moves starting index of string to register AL
        cmp al, BYTE PTR[edx + ecx - 1]     ;// Compares ending index of string to register AL
        jne notPalindrome                   ;// If values don't match at index = Not a Palindrom -> Go to NotPalindrome
        inc esi                             ;// Otherwise Increase starting index by 1, ECX automatically decrements = leave alone
        mov halfVal, ecx                    ;// Compare if we're already at the halfway point between the string
        ;//sub halfVal, 1
        cmp esi, halfVal                    ;// If ECX = ESI, we've now reached halfway through the string with no errors
        je isRight                          ;// This means string is a palindrome! Jump to isRight 
        loop checkIndex                     ;// Loop through the index of the String until ECX = 0 or the index at ECX != ESI 
    
    isRight:
        push edx;// Save value in currently in edx
        mov edx, offset isMsg;// prep to write string
        call writestring
        call waitmsg
        pop edx;// restore value in edx
        jmp exitOut

    notPalindrome:
        push edx                            ;// Save value in currently in edx
        mov edx, offset notMsg              ;// prep to write string
        call writestring
        call waitmsg
        pop edx                             ;// restore value in edx
    exitOut:
    pop esi
    ret
option4 ENDP
;// ------------------------------------------------------------------------


option5 proc 
;// Description:  Displays the string.
;// Receives: address of string in edx
;// Returns:  nothing

.data
option5prompt byte 'The current value of the string is: ', 0h

.code
    ;// call clrscr
    push edx	                        ;// save the address of the string to write prompt
    mov edx, offset option5prompt
    call writestring
    pop edx
    call writestring                    ;// write the string
    call crlf

ret
option5 endp

;// -------------------------------------------------------------
errorMsg PROC
;// Description:  Displays Error Message on invalid entry
;// Receives :    Nothing
;// Returns :     Nothing

.data
errormessage byte 'You have entered an invalid option. Please try again.', Newline, 0h

.code
push edx                                ;// Save value in currently in edx
mov edx, offset errormessage            ;// prep to write string
call writestring
call waitmsg
pop edx                                 ;// restore value in edx

ret
errorMsg ENDP
;// -------------------------------------------------------------


END main

