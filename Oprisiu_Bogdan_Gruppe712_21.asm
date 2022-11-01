bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

;Ohne votzeichen

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
        a db 2
        b db 2
        e dd 4
        x dq 4

; our code starts here
segment code use32 class=code
    start:
        ;(a*a / b + b*b) / (2+b) + e - x
        
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        clc
        
        mov al,[a]
        mov bl,[a]
        mul bl ; eax = a*a = 4
        
        mov bl,[b]
        div bl ; eax = a*a / b = 4 / 2 = 2
        mov ebx, 0
        
        mov ecx, eax ; ecx = a*a / b = 4 / 2 = 2
        mov eax, 0
        mov bl, [b]
        mov al, [b]
        mul bl; eax = b*b = 4
        
        add eax, ecx; eax = eax + ecx = a*a / b + b*b = 2 + 4 = 6 
        mov ecx, 0
        
        mov cl, [b]
        add cx, 2; ecx = b + 2 = 4
        
        div cx; eax = (a*a / b + b*b) / ( b + 2 ) = 6 / 4 = 1, EDX = Rest = 2
        mov edx, 0
        
        add eax, [e]; eax = eax + e = (a*a / b + b*b) / (b+2) + e = 1 + 4 = 5
        mov edx, 0
        
        sub eax, dword[x]
        sub edx, dword[x+4]; edx:eax = (a*a / b + b*b) / (b+2) + e - x = 5 - 4 = 1  
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
