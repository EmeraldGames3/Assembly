bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf
import exit msvcrt.dll    
import printf msvcrt.dll    
import fopen msvcrt.dll    
import fclose msvcrt.dll    
import fread msvcrt.dll    

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    fileName db "input.txt", 0
    accesMode db "r", 0
    fileDescriptor dd -1
    readCharacters dd 0
    len equ 100
    buffer times (len + 1) db 0
    format db "%s", 0
    format2 db "There are %d decimals", 0

; our code starts here
segment code use32 class=code
    start:
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        
        push dword accesMode
        push dword fileName
        call [fopen]
        add esp, 4*2
        
        cmp eax, 0
        je end
        
        mov [fileDescriptor], eax
        
        whileReadFromFile:
        
            push dword [fileDescriptor]
            push dword len
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4*4
        
            cmp eax, 0
            je end
            
            push dword buffer
            push dword format
            call [printf]
            add esp, 4*2
            
                mov esi, 0
            
                while:
                    mov edx, 0
                    mov dl, [buffer + esi]
            
                    cmp dl, '0'
                    jb nichtZiffer
            
                    cmp dl, '9'
                    jg nichtZiffer
            
                    inc ebx
            
                    nichtZiffer:
            
                    inc esi
                    cmp esi, eax
                    je whileReadFromFile
            
                jmp while
        
        jmp whileReadFromFile
        
    end:
    
        push dword ebx
        push dword format2
        call [printf]
        add esp, 4*2
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
