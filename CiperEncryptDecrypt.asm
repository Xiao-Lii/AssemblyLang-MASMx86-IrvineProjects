TITLE hw6.asm
;// Author:  Lee Phonthongsy
;// Date:    November 2020
;// Description: This program presents a menu allowing the user to pick a menu option
;//              which then performs a given task.
;//              1.  Enter in a new message
;//              2.  Enter a key
;//              3.  Encrypt a message
;//              4.  Decrypy a message 
;//              5.  Exit
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
maxLength = 151d

.data
UserOption byte 0h
isEmpty byte 'T'
theString byte maxLength dup(0)                 ;// declare the array
theStringLen byte 0
isKeyThere byte 'F'
key byte maxLength dup(0)
keyLen byte 0

.code
main PROC

call ClearRegisters                             ;// clears registers

startHere:                                      ;// starting point to redisplay menu
    mov ebx, OFFSET UserOption                  ;// Passing address of UserOption in ebx to display Menu Proc
    call displayMenu


;// find procedure to call
opt1:
    cmp useroption, 1                           ;// Useroption 1 = Enter a String 
    jne opt2
    call clrscr
    ;// setting up for future procedure calls
    mov edx, offset theString                   ;// EDX holds the offset/address of the string
    mov ecx, lengthof theString                 ;// ECX holds the length of the string
    mov ebx, offset thestringlen                ;// will hold the length of the entered string
    call getString                              ;// Call getString PROC
    mov theStringLen, al                        ;// Updating the String Len Variable with length saved in register EAX 
    call printString                            ;// Display the user-input to screen 
    movzx ecx, thestringlen                     ;// sets the loop count for toUpper since a string has been entered
    call toUpper                                ;// Converts all lowercase letters to uppercase in user message
    movzx ecx, thestringlen                     ;// sets the loop count for toUpper since a string has been entered
    call LettersOnly                            ;// Removing all non-letter elements in user message 
    sub thestringlen, al                        ;// Updating new string length from removing non-letter symbols
    call printSaved                             ;// Display what was actually saved to the system
    mov isEmpty, 'F'                            ;// Changing that String exists now 
    jmp starthere


opt2 :
    cmp useroption, 2                           ;// Useroption 2 = Enter a Key 
    jne opt3
    call clrscr
    push edx
    push ecx
    push ebx
    ;// Prepping for Saving Key Value & Length
    mov edx, offset key                         ;// EDX holds the offset/address of the key
    mov ebx, offset keyLen                      ;// EBX will hold the length of the key 
    mov ecx, lengthof key                       ;// Setting up the max length that key can be 
    call enterKey                               ;// Calls EnterKey PROC 
    mov keyLen, al                              ;// AL = Key length, save any new length changes to KeyLen variable
    movzx ecx, keylen                           ;// sets the loop count for toUpper since a string has been entered
    call toUpper                                ;// Converts all lowercase letters to uppercase in user message
    mov eax, 0
    movzx ecx, keylen                           ;// sets the loop count for toUpper since a string has been entered
    call LettersOnly                            ;// Removing all non-letter elements in user message 
    sub keylen, al                              ;// Updating new string length from removing non-letter symbols
    call printSaved                             ;// Display what was actually saved to the system
    pop ecx
    pop edx
    pop ebx
    mov isKeyThere, 'T'                         ;// Saving that Key exists now for option 3-4
    jmp starthere                           

opt3:                                           ;// Useroption 3 = Encrypt message with Key  
    cmp useroption, 3
    jne opt4
    cmp isEmpty, 'T'                            ;// Check if String exists 
    je oops
    cmp isKeyThere, 'F'                         ;// Check if Key exists 
    je oops
    push edx
    push ecx
    push ebx
    call ClearRegisters                         ;// Clearing the register to pass variables in registers
    ;// Passing through Registers before Encrypting 
    ;// EDX = Address of string, ECX = Length of String, EDI = address of key, EBX = Length of Key 
    mov edx, offset theString                   ;// EDX = Address of String 
    mov cl, theStringLen                        ;// CL = Length of String
    mov edi, offset key                         ;// EDI = Address of Key
    mov bl, keyLen                              ;// BL = Length of Key
    call encrypt                                ;// Call encrypt PROC 
    mov ecx, 0                                  ;// Resetting ECX = 0
    mov cl, theStringLen                        ;// CL = Length of String, prepping for PrintIt
    call PrintIt                                ;// Call PrintIt PROC, prints a space between every 5 chars 
    pop ecx
    pop edx
    pop ebx
    jmp starthere


opt4:
    cmp useroption, 4                           ;// Useroption 4 = Decrypt Message w/ Key 
    jne opt5
    cmp isEmpty, 'T'                            ;// Checking if String exists
    je oops                                         
    cmp isKeyThere, 'F'                         ;// Checking if key exists
    je oops
    push edx
    push ecx
    push ebx
    call ClearRegisters                         ;// Clearing the register to pass variables in registers
    ;// Passing through Registers before Encrypting 
    ;// EDX = Address of string, ECX = Length of String, EDI = address of key, EBX = Length of Key 
    mov edx, offset theString                   ;// EDX = Address of String
    mov cl, theStringLen                        ;// CL = Length of String
    mov edi, offset key                         ;// EDI = Address of Key
    mov bl, keyLen                              ;// BL = Length of Key 
    call decrypt                                ;// Calling 'decrypt' procedure for string + key  
    call clrscr                                 ;// Clear screen for cleanliness 
    mov ecx, 0                                  
    mov cl, theStringLen                        ;// Setting up ECX = Length of String to display entire length
    call printDecrypt                           ;// Call printDecrypt PROC
    pop ecx
    pop edx
    pop ebx
    jmp starthere
    
opt5 :
    cmp useroption, 5                           ;// useroption = 5  
    jne oops                                    ;// invalid entry
    jmp quitit

oops:                                           ;// invalid option entered
    call errorMsg
    jmp starthere

quitit :
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
'1. Enter in a new message', 0Ah, 0Dh,
'2. Enter a key for the Caesar Cipher', 0Ah, 0Dh,
'3. Encrypt the message', 0Ah, 0Dh,
'4. Decrypt the message', 0Ah, 0Dh,
'5. Exit', 0Ah, 0Dh, 0Ah, 0Dh,
'Please enter an option between 1 and 5 -->  ', 0h

.code
    push edx                                    ;// preserves current value of edx - the strings offset
    call clrscr
    mov edx, offset MainMenu                    ;// required by WriteString
    call WriteString
    call readhex                                ;// get user input
    mov byte ptr[ebx], al                       ;// save user input to UserOption
    pop edx                                     ;// restores current value of edx
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
getString proc
;// Description: Gets string from user.
;// Receives:  Address of string in EDX 
;// Returns:   String is modified and length of entered string is in saved in theStringLen

.data
prompt1 byte 'Please enter a string of characters (', 0h
prompt2 byte ' or less): ', newline, '--->   ', 0h

.code
    push edx                                    ;// saving the address of the string pass in.

    mov edx, offset prompt1                     ;// Offsetting EDX to fit Option1 Prompt 
    call writestring                            ;// Printing Option1 Prompt to screen
    mov eax, maxlength                          ;// Saving EAX to hold max length of String (101 -> EAX)
    dec eax                                     ;// Decrement by 1 to get our desire 100 characters
    call writedec                               ;// Print Decimal # to Screen
    mov edx, offset prompt2                     ;// Offset EDX for prompt 2
    call writeString                            ;// Display Prompt 2 for User Input - String 

    pop edx

    ;// add procedure to clear string
    call readstring                             ;// Reads String from User
    mov byte ptr[ebx], al                       ;// length of user entered string, now in thestringlen

ret
getString endp

;// ------------------------------------------------------------------------------------
toUpper proc
;// Description:  Converts all elements to upper case
;// Receives:  address of string in edx, esi = 0h
;// Returns:  noting, but string is now lower case. esi - original value

Comment !
'A' = 41h = 0100 0001b                          ;// Notice that bit 5 is the only bit that changes 
'a' = 61h = 0110 0001b                          ;// OR al, 20h;// 20h = 0010 0000b 
'Z' = 5Ah = 0101 1010b
'z' = 7Ah = 0111 1010b
!

.code
    push esi                                    ;// ECX already contains length of String for Loop 
                                                ;// EDX holds the String's address 
mov esi, 0                                      ;// Setting up ESI Counter to Offset length of the String   

L2:
    mov al, BYTE PTR[edx + esi]                 ;// Moving individual index of string into register AL 
    cmp al, 61h                                 ;// Checking to make sure it is within beginning range of 'a'
    jb keepgoing
    cmp al, 7Ah                                 ;// Checking to make sure it is within end range of 'z'
    ja keepgoing
    sub al, 20h                                 ;// If letter is within A-Z, add 20h to convert to lowercase
    mov BYTE PTR[edx + esi], al                 ;// Now save lowercase letter over the uppercase in the same index
    jmp keepgoing

keepgoing :                                     ;// if already lower case or not a letter, no need to change it, keep going.
    inc esi
    loop L2

pop esi
ret
toUpper endp

;// ------------------------------------------------------------------------------
LettersOnly PROC
;// Description:  removes all non-letter elements. 
;// Receives:  ecx - length of string
;//            edx - offset of string
;//            ebx - offset of string length variable
;//            esi preserved
;//            eax - length of user-input string 
;// Returns:   The string without all non-letter elements and the decrement length of the new string in register EAX

.data
outerCounter DWORD ?
tempOffset DWORD ?
decCounter DWORD 0

.code
push esi                                        ;// ECX already contains length of String for Loop 
                                                ;// EDX holds the String's address 
mov esi, 0                                      ;// Setting up ESI Counter to Offset length of the String   
mov decCounter, 0

L3:
    mov al, BYTE PTR[edx + esi]                 ;// Moving individual index of string into register AL 
    cmp al, 0h                                  ;// Checking if string is empty
    je endOption3                               ;// If so, exit
    cmp al, 41h                                 ;// Checking if index is less than 'A', if so go to -> remove Index 
    jl removeIndex
    cmp al, 7Ah                                 ;// Checking if index is greater than 'z', if so go to -> remove Index
    ja removeIndex
    ;// Checking For symbols between between 'Z' and 'a' that aren't letters
    cmp al, 5Bh
    jge insideCheck                             ;// If greater than 'Z' go to insideCheck to verify if index is lowercase
    inc esi                                     ;// Increase to look at next index
    loop L3

;// Inside Check checks for symbols between Upper & Lower case
insideCheck:
    cmp ecx, 0
    je endOption3
    cmp al, 60h                                 ;// If less than 'a' go to -> remove Index
    jle removeIndex
    inc esi                                     ;// Increase to look at next index
    cmp ecx, 1
    je endOption3
    loop L3

;// Moving index of string over + decreasing EBX (OFFSET of String Length Variable)
removeIndex:                                    ;// if not a uppercase or lowercase letter, remove index of string
    mov al, 0h                                  ;// A temp null value to remove later 
    mov BYTE PTR[edx + esi], al

    mov outerCounter, ecx                       ;// Saving current counter of ECX to return after shifting String over 
    mov tempOffset, esi                         ;// Saving current offset of String to return after shifting String over

;// Shifts Index of String over 
shiftString:
    mov al, BYTE PTR[edx + esi + 1]             ;// Saves next index of string to register AL
    mov BYTE PTR[edx + esi], al                 ;// Overwrites 'Non-letter' index with the next Index of String saved in AL
    inc esi                                     ;// Increase to look at next index
    loop shiftString

    mov ecx, outerCounter                       ;// Restores outerCounter of ECX prior to shifting string over
    inc decCounter                              ;// Decreasing ECX by 1, because we removed 1 index of the string b/c it was a non-letter
    mov esi, tempOffset                         ;// Restores offset of string prior to shifting string over 
    loop L3

endOption3 :
    pop esi                                     ;// Restores ESI value at beginning of option 3
    mov eax, decCounter
    ret
LettersOnly ENDP


;// ------------------------------------------------------------------------
encrypt proc
;// Description: Displays the string after shifting/rotating to the right by the key
;// Receives: EDX = Address of string, ECX = Length of String, EDI = address of key, EBX = Length of Key 
;// Returns:  Encrypted string shited right-wards by the key

.data
shift BYTE ?
modulus1A BYTE 1Ah  ;// 1AH = 26
tempStringLen DWORD ?
tempKeyLen DWORD ?
subValue BYTE ?
keyIndex byte 0
keyOffset DWORD ?

.code
    mov tempKeyLen, ebx
    mov tempStringLen, ecx
    mov keyOffset, edi 
    push esi                                    ;// ECX already contains length of String for Loop 
    mov esi, 0                                  ;// Setting up ESI Counter to Offset length of the String  
    push ecx                                    ;// ECX -> Stack, Saving length of String for later
    mov ecx, ebx
    push edi
    push ebx

loop1:
    mov eax, 0
    mov al, BYTE PTR[edi]                       ;// Moving index of key into register AL 
    div modulus1A                               ;// Divide key index by 1A, AL = Quotient, AH = Remainder
    add ah, BYTE PTR[edx + esi]                 ;// AH(Remainder) + ASCII of Phrase at (EDX + ESI) index of String
    cmp ah, 5Ah                                 ;// Check if encryping String index is our of Capital letter range 'A - Z'
    jg OutOfRange                               ;// If past 'Z' go to OutOfRange to shift index correctly
    cmp ecx, 0                                  ;// If we traversed the entire string, go to Exit 
    je exitEncrypt
    mov BYTE PTR[edx + esi], ah                 ;// Not out of range of A-Z, encrypt current Index of String
    cmp esi, tempStringLen                      ;// Check if we've encrypted up to the length of our string, KeyLength > StringLength
    je exitEncrypt                              ;// If yes, go to exit 

IncreaseIndex:
    inc esi
    cmp esi, tempKeyLen                         ;// Checks if we've reach the length of the key
    je ResetKeyIndex                            ;// If yes, jump to ResetKeyIndex
    cmp esi, tempStringLen                      ;// Check if we've encrypted up to the length of our string, KeyLength > StringLength
    je exitEncrypt                              ;// If yes, go to exit 
    inc edi                                     ;// Else, increase key's offset index
    loop loop1

ResetKeyIndex :
    ;// Remember ECX = 0 Because we have traversed the length of the key
    mov edi, keyOffset                          ;// Resetting the offset of our key to its original place 
    mov ecx, tempKeyLen                         ;// Resetting ECX to the length of the key for Loop1
    inc ecx                                     ;// We increase ECX, because it will decrease when looping back up to loop1                                      
    loop loop1                                  ;// Go back to top at Loop1

OutOfRange:
    sub ah, 5Ah                                 ;// Subtract by end Range of 'Z' to find value in A - Z
    add ah, 40h                                 ;// Our value to encrypt over ESI index of String
    mov BYTE PTR[edx + esi], ah                 ;// Saving encrypted value after shifting to [EDX + ESI] index of string 
    jmp IncreaseIndex
    
exitEncrypt:
pop esi
pop ecx
pop edi
pop ebx 
ret
encrypt endp


;// ------------------------------------------------------------------------
decrypt proc
;// Description: Displays the string after shifting/rotating to the left by the key
;// Receives: EDX = Address of string, ECX = Length of String, EDI = address of key, EBX = Length of Key 
;// Returns:  Encrypted string shited left-wards by the key from 'Z'

COMMENT!
'A' = 41h
'Z' = 5Ah
!

.data
modulus byte 1Ah
decryptKeyLen DWORD ?
decryptStringLen DWORD ?
decryptKeyOffset DWORD ?
endKeyAddress DWORD ?

.code
    mov esi, 0                                  ;// Setting up our offset, ESI to zero 
    push edx
    mov decryptKeyLen, ebx                      ;// Saving Length of key to decryptKeyLen variable
    mov decryptStringLen, ecx                   ;// Saving Length of String to decryptStringLen variable 
    mov decryptKeyOffset, edi                   ;// Saving our starting address of our Key 
    mov endKeyAddress, edi                      ;// EndKeyAddress = Starting Key Address + Length 
    add endKeyAddress, ebx                      


startDecrypt:
    mov eax, 0
    mov al, BYTE PTR[edi]                       ;// Moving index of key into register AL 
    div modulus                                 ;// Divide key index by 1A, AL = Quotient, AH = Remainder
    mov ebx, 0
    mov bl, BYTE PTR[edx + esi]                 ;// BL = EDX + ESI index of String 
    sub bl, ah                                  ;// BL = Index of String(EDX+ESI) - AH(Remainder) = Decrypted Letter
    cmp bl, 41h                                 ;// Check if Decrypted is within the letter range 'A - Z'
    jl OutOfRange2                              ;// If less/past 'A' go to OutOfRange2 to shift index correctly
    mov BYTE PTR[edx + esi], bl                 ;// Not out of range of A-Z, encrypt current Index of String

NextIndex:
    inc esi                                     ;// Increasing ESI = Our offset for traversing our string 
    cmp esi, decryptStringLen                   ;// Checking if we've traversed the entire length of the string 
    je exitDecrypt                              ;// If yes, exit decryption 
    inc edi                                     ;// Otherwise, increase EDI = Our offset/index of the key 
    cmp edi, endKeyAddress                      ;// Checking if we've reach the end address of our key 
    je ResetKIndex                              ;// If yes, reset jump to ResetKIndex to reset to original Key address
    loop startDecrypt                           ;// Otherwise, jump back up to startDecrypt

ResetKIndex :
    mov edi, decryptKeyOffset                   ;// Resetting the offset of our key to its original place                                  ;// We increase ECX, because it will decrease when looping back up to loop1                                      
    loop startDecrypt                           ;// Go back to top at startDecrypt

OutOfRange2:
    mov bh, 40h                                 ;// BH = '@' the ASCII char before 'A'
    sub bh, bl                                  ;// BH - BL = Remaining distance to shift leftwards from 'Z'
    mov bl, 5Ah                                 ;// BL = 'Z'
    sub bl, bh                                  ;// BL - BH = Our correct decrypted letter with range of 'A - Z'
    mov BYTE PTR[edx + esi], bl                 ;// Saving encrypted value after shifting to [EDX + ESI] index of string 
    jmp NextIndex                               ;// Jump to NextIndex to increase ESI & EDI 

exitDecrypt:
pop edx
ret
decrypt endp


;// ------------------------------------------------------------------------
enterKey proc
;// Description:  Asks users for a new key and saves it
;// Receives: EDX = address of key, EBX = Length of Key 
;// Returns:  nothing

.data
prompt byte 'Please enter a key as a string of any letter(s) (150 characters max)', Newline, 0h

.code
    push edx                            ;// saving the address of the string pass in.

    mov edx, offset prompt              ;// Offsetting EDX to fit Option1 Prompt 
    call writestring                    ;// Printing Option1 Prompt to screen
    pop edx

    ;// add procedure to clear string
    call readstring                     ;// Reads String from User
    mov byte ptr[ebx], al               ;// length of user entered key, now in keyLen
ret
enterKey endp

;// ------------------------------------------------------------------------
PrintIt proc
;// Description: Prints in a set of 5 characters, either the encrypted or decrypted string, separated by spaces
;// Receives: EDX = Address of string, ECX = Length of String, EDI = address of key, EBX = Length of Key 
;// Returns: 

.data
printPrompt byte 'The message after encryption is: ', 0h
stringLength DWORD ? 
set DWORD 5
space byte ' '
counter DWORD 0

.code
    call clrscr
    push edx                            ;// saving the address of the string pass in.
    mov edx, offset printPrompt         ;// Offsetting EDX to fit Option1 Prompt 
    call writestring                    ;// Printing Option1 Prompt to screen
    pop edx
    push ecx
    mov esi, 0                          ;// Setting up our value to traverse/offset the string 

printSet:
    mov al, BYTE PTR[edx + esi] 
    call writeChar                      ;// Writes only one char of [edx + esi] index of string
    inc esi
    inc counter                         ;// Increments counter to keep track of index in set of 5 
    cmp esi, stringLength               ;// If ESI = StringLength, no more indexes to check, jump to end of PrintIt Proc
    je endIt
    push ebx                
    mov ebx, set                        ;// Set = 5 characters = Add a Space if reached 
    cmp ebx, counter                    ;// Checking if our counter has reached 5 = End of Set, Jump to AddSpace Loop
    pop ebx
    je printSpace                       
    loop printSet

printSpace:
    mov al, space                       ;// Sets empty space to register AL for WriteChar
    call writeChar
    mov counter, 0                      ;// Resets counter for index of a set
    cmp ecx, 0                          ;// If ECX = 0, no more indexes to check in string, jump to end of PrintIt Proc 
    je endIt
    loop printSet                       ;// Otherwise, return back up top, to print string as sets 

endIt:
pop ecx 
call crlf
call waitMsg
ret
PrintIt endp

;// ------------------------------------------------------------------------
printString proc
;// Description:  Displays the user-input string.
;// Receives: EDX = address of string
;// Returns:  nothing

.data
stringPrompt byte 'User-input message: ', 0h

.code
    ;//call clrscr
    push edx;// save the address of the string to write prompt
    mov edx, offset stringPrompt
    call writestring
    pop edx
    call writestring;// write the string
    call crlf

ret
printString endp

;// ------------------------------------------------------------------------
printDecrypt proc
;// Description:  Displays the decryption string.
;// Receives: EDX = address of string
;// Returns:  nothing

.data
decryptPrompt byte 'The message after decryption is: ', 0h

.code
;//call clrscr
push edx;// save the address of the string to write prompt
mov edx, offset decryptPrompt
call writestring
pop edx
call writestring;// write the string
call crlf
call waitmsg

ret
printDecrypt endp

;// ------------------------------------------------------------------------
printSaved proc
;// Description:  Displays the string.
;// Receives: EDX = address of string saved 
;// Returns:  nothing

.data
savePrompt byte 'The message saved in the system: ', 0h

.code
    ;//call clrscr
    push edx                            ;// save the address of the string to write prompt
    mov edx, offset savePrompt
    call writestring
    pop edx
    call writestring                    ;// write the string
    call crlf 
    call waitmsg

ret
printSaved endp


;// -------------------------------------------------------------
errorMsg PROC
;// Description:  Displays Error Message on invalid entry
;// Receives :    Nothing
;// Returns :     Nothing

.data
errormessage byte 'You have entered an invalid option. Please try again.', 0h

.code
    push edx                                    ;// Save value in currently in edx
    mov edx, offset errormessage                ;// prep to write string
    call writestring
    call waitmsg
    pop edx                                     ;// restore value in edx

ret
errorMsg ENDP
;// -------------------------------------------------------------



END main

