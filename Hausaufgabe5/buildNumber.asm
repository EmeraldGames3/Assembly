bits 32 ; assembling for the 32 bits architecture

global start     
   
extern exit, printf               
import exit msvcrt.dll                 
import printf msvcrt.dll                 

segment data use32 class=data
    s db "2000000000"
    l equ $-s
    format db "%d", 0

; our code starts here
segment code use32 class=code
    start:
        mov eax, 0
        mov ebx, 0
        mov esi, 0
        mov ecx, 10
        
        while:
            cmp esi, l
            je end
    
            mov ebx, 0
            mov bl, [s + esi]
            sub bl, '0'
            
            mul ecx; edx:eax = eax * 10
            
            add eax, ebx
            
            inc esi
            jmp while
            
        end:
            push eax
            push dword format
            call [printf]
            add esp, 4*3
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
