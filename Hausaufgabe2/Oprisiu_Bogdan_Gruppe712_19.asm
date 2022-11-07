bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ;r dd 100100010000010000100 000000 01000b
    ;t dd 01000010000000001000000100001001b
    r dd 1001_0001_0000_0100_0010_0000_0000_1000b
    t dd 0100_0010_0000_0000_1000_0001_0000_1001b
    q dd 00000000000000000000000000000000b
    ;q = 0000000 100000100101000010 0100000
    ;    0100000 100000000001000010 0100000
    ;r^t=1101001 100000100101000010 0000001

; our code starts here
segment code use32 class=code
    start:
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        
        mov eax, [t]
        and eax, 00000000000000011111110000000000b; eax enthalt die bits 10-16 von t
        ;eax =   00000000000000001000000000000000
        shr eax, 10; eax enthalt auf die position 0-6 die bits 10-16 von t
        ;eax =   00000000000000000000000000100000
        
        mov ebx, [t]
        mov ecx, [r]
        xor ecx, ebx; ecx = r xor t = 1101001100000100100000100000001
        and ecx, 00000000_111111111111111111_000000; ecx = 000000_ die bits 7 - 24 von r xor t_000000 = 0000000 100000100101000010 0000000
        or eax, ecx; eax = 0000000_ die bits 7 - 24 von r xor t_ die bits 10-16 von t

        mov ecx, 0
        mov ebx, 0
        mov ecx, [r]
        and ecx, 00000000000000000000111111100000b
        shl ecx, 20; die bits 5-11 von r _000000000000000000000000
        or eax, ecx; die bits 5-11 von r_ die bits 7 - 24 von r xor t_ die bits 10-16 von t
        
        mov [q], eax 
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
