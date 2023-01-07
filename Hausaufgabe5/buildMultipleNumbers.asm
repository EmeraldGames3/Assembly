bits 32 

global start        

extern exit, printf              
import exit msvcrt.dll    
import printf msvcrt.dll   

segment data use32 class=data
    s db "123$4*"
    l equ $-s
    format db "Number: %d", 0Ah, 0

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
            
            cmp bl, '0'
            jl notNumber
            cmp bl, '9'
            ja notNumber
            
            isNumber:
                sub bl, '0'
                mul ecx; edx:eax = eax * 10
                add eax, ebx
                
                inc esi
                jmp while
                
            notNumber:
                push eax
                push dword format
                call [printf]
                add esp, 4*3
                mov eax, 0
            
                inc esi
                jmp while
            
        end:
            cmp eax, 0
            je dontPrit
        
            push eax
            push dword format
            call [printf]
            add esp, 4*3
            
            dontPrit:
        
        push    dword 0
        call    [exit]
