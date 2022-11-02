bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 0111011101010111b
    b dw 1001101110111110b
    c dw 0

; our code starts here
segment code use32 class=code
    start:
        mov bx, 0
        mov ax, [b]
        
        mov bx, 0
        
        mov ax, 0001110000000000b
        mov cl, 10
        ror ax, cl
        or bx, ax
        
        or bx, 0000000001111000b
        
        mov ax, [a]
        and ax, 0000000000011110b
        mov cl, 6
        rol ax, cl
        or bx, ax
        
        and bx, 1110011111111111b
        
        mov ax, [b]
        not ax
        rol ax, cl
        or bx, ax
        
        mov [c], bx
        
        push 0
        
        call [exit]