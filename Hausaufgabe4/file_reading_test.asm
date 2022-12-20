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

; our code starts here
segment code use32 class=code
    start:
        
        push dword accesMode
        push dword fileName
        call [fopen]
        add esp, 4*2
        
        cmp eax, 0
        je end
        
        mov [fileDescriptor], eax
        
        while:
        
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
        
        jmp while
        
    end:
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
