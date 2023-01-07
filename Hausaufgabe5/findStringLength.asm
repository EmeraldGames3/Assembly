bits 32 

global start        

extern exit, gets, printf           
import exit msvcrt.dll    
import gets msvcrt.dll    
import printf msvcrt.dll    

segment data use32 class=data
    s times 100 db 0
    l dd 0
    format db "String: %s with the lenght: %d", 0Ah, 0

segment code use32 class=code
    start:
        mov esi, 0
    
        push dword s
        call [gets]
        add esp, 4*1
        
        while:
            mov al, [s + esi]
            cmp al, 0
            je end
            
            inc esi
            jmp while
        
        end:
            mov [l], esi
        
            push dword [l]
            push dword s
            push dword format
            call [printf]     
            add esp, 4*2       
        
        push    dword 0
        call    [exit]
