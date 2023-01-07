bits 32 

global start        

extern exit, gets, printf, printToFile
import exit msvcrt.dll
import gets msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    s times 100 db 0
    maximum dd -2147483648
    isNegative dd 1
    formatPrintString db "String: %s", 0Ah, 0
    formatPrintNumbers db "Number: %d", 0Ah, 0
    formatPrintMaximum db "Maximum: %d", 0Ah, 0

segment code use32 class=code
    start:
        mov esi, 0
    
        push dword s
        call [gets]
        add esp, 4*1
            
        mov eax, 0
        mov ebx, 0
        mov esi, 0
        mov ecx, 0
        mov edx, 10
        
        whileBuildNumbers:
    
            mov ebx, 0
            mov bl, [s + esi]
            
            cmp bl, 0
            je endwhileBuildNumbers
            
            cmp bl, '-'
            je negative
            
            cmp bl, '0'
            jl notNumber
            cmp bl, '9'
            ja notNumber
            
            isNumber:
                sub bl, '0'
                mov edx, 10
                imul edx; edx:eax = eax * 10
                ;eigentlich eax = eax*10, da wir edx nicht beachten
                ;Das ist weil wir doublewords benutzen
                
                add eax, ebx
                
                inc esi
                jmp whileBuildNumbers
                
            notNumber:
                cmp eax, 0
                je notWasNumber
                
                wasNumber:
                    imul dword[isNegative]
                    
                    mov ecx, [maximum]
                    cmp eax, ecx
                    jle notBigger
                    
                    bigger:
                        mov [maximum], eax
                    
                    notBigger:
                
                    push eax
                    push dword formatPrintNumbers
                    call [printf]
                    add esp, 4*3
                    
                    mov eax, 0
                        
                    inc esi
                    jmp whileBuildNumbers
            
                notWasNumber:
                    inc esi
                    jmp whileBuildNumbers
                    
            negative:
                mov edx, -1
                mov [isNegative], edx
                mov edx, 10
                
                inc esi
                jmp whileBuildNumbers
            
        endwhileBuildNumbers:
            cmp eax, 0
            je notWasNumberEnd
        
            imul dword[isNegative]
            
            mov ecx, [maximum]
            cmp eax, ecx
            jle notBiggerEnd
                    
            biggerEnd:
                mov [maximum], eax
                    
            notBiggerEnd:
            push eax
            push dword formatPrintNumbers
            call [printf]
            add esp, 4*3
            
            notWasNumberEnd:
                    
            push dword [maximum]
            push dword formatPrintMaximum
            call [printf]
            add esp, 4*3
            
        push dword [maximum]
        call printToFile
        add esp, 4
        
        push    dword 0
        call    [exit]
