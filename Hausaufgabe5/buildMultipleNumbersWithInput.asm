bits 32 

global start        

extern exit, gets, printf           
import exit msvcrt.dll    
import gets msvcrt.dll    
import printf msvcrt.dll    

segment data use32 class=data
    s times 100 db 0
    isNegative dd 1
    formatPrintString db "String: %s", 0Ah, 0
    formatPrintNumbers db "Number: %d", 0Ah, 0

segment code use32 class=code
    start:
        mov esi, 0
    
        push dword s
        call [gets]
        add esp, 4*1
            
        mov eax, 0
        mov ebx, 0
        mov esi, 0
        mov ecx, 10
        
        whileBuildNumbers:
    
            mov ebx, 0
            mov bl, [s + esi]
            
            cmp bl, 0
            je endwhileBuildNumbers
            
            cmp bl, '0'
            jl notNumber
            cmp bl, '9'
            ja notNumber
            
            isNumber:
                sub bl, '0'
                mul ecx; edx:eax = eax * 10
                add eax, ebx
                
                inc esi
                jmp whileBuildNumbers
                
            notNumber:
                cmp eax, 0
                je dontPritWhile
                
                printWhile:
                    push eax
                    push dword formatPrintNumbers
                    call [printf]
                    add esp, 4*3
                    mov eax, 0
            
                dontPritWhile:
                
                inc esi
                jmp whileBuildNumbers
            
        endwhileBuildNumbers:
            cmp eax, 0
            je dontPritEnd
        
            push eax
            push dword formatPrintNumbers
            call [printf]
            add esp, 4*3
            
            dontPritEnd:
        
        push    dword 0
        call    [exit]
