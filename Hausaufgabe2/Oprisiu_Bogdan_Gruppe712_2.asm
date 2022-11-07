bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dw 0001000000001101b
    b dw 1100001100000001b
    c dd 00000000000000000000000000000000b
    ;c = 0001000000001101 0000001000001001
    
; our code starts here
segment code use32 class=code
    start:
        ; 0 = 0000000000000000b
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        
        mov ax, [a]
        and ax, 0111000000000000b ; ax enthalt die bits 12-14 von a
        shr ax, 12; die bits 12-14 von ax stehen auf die positionen 0-2 im ax
        
        mov bx, [b]
        and bx, 0000000000111111b; bx enthalt die ersten funf bits von
        shl bx, 3; bx enthalt auf die position 3-8 die bits 0-5 von b
        
        or ax, bx; ax enthalt die bits 0-8 von c
        
        mov bx, [a]
        and bx, 0000001111111000b
        shr bx, 3
        shl bx, 9
        
        or ax, bx
        
        mov dx, [a]
        shl edx, 16
        or eax, edx; das resultat steht im eax
        mov [c], eax
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
