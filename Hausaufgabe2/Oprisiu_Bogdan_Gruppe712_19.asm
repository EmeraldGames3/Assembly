bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ;r dd 10010001000001000010000000001000b
    ;t dd 01000010000000001000000100001001b
    ;r^t= 11010011000001001010000100000001
    r dd 10010001000001000010000000001000b
    t dd 01000010000000001000000100001001b
    q dd 00000000000000000000000000000000b
    ;q = 00000001000001001010000100100000
    ;q = 0104A120h

; our code starts here
segment code use32 class=code
    start:
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        
        mov eax, [t]
        and eax, 00000000000000011111110000000000b; wir isolieren die bits 10-16 von t
        ; eax enthalt die bits 10-16 von t
        ;eax =   00000000000000001000000000000000
        shr eax, 10; eax enthalt auf die position 0-6 die bits 10-16 von t
        ;eax =   00000000000000000000000000100000
        
        mov ebx, [t]
        mov ecx, [r]
        xor ecx, ebx; ecx = r xor t = 1101001100000100100000100000001
        and ecx, 00000001111111111111111110000000b; wir isolieren die bits 7-24 von r^t
        ; ecx = 000000_ die bits 7 - 24 von r xor t_000000 = 00000001000001001010000100000000
        or eax, ecx; eax = 0000000_ die bits 7 - 24 von r xor t_ die bits 10-16 von t

        mov ecx, 0
        mov ebx, 0
        mov ecx, [r]
        and ecx, 00000000000000000000111111100000b; wir isolieren die bits 5-11 von r
        shl ecx, 20; die bits 5-11 von r _000000000000000000000000
        or eax, ecx; die bits 5-11 von r_ die bits 7 - 24 von r xor t_ die bits 10-16 von t
        
        mov [q], eax; = die bits 5-11 von r_ die bits 7 - 24 von r xor t_ die bits 10-16 von t
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
