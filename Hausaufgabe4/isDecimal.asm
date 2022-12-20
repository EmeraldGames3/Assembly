bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    v db "1234 75* 0", 0
    l equ $-v
    format db "%d",0

; our code starts here
segment code use32 class=code
    start:
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        mov esi, 0
        
        while:
            mov edx, 0
            mov dl, [v + esi]
            
            cmp dl, '0'
            jb nichtZiffer
            
            cmp dl, '9'
            jg nichtZiffer
            
            inc ebx
            
            nichtZiffer:
            
            inc esi
            cmp esi, l
            je endWhile
            
        jmp while
        
        endWhile:
        
            push dword ebx
            push dword format
            call [printf]
            add esp, 4*2
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
