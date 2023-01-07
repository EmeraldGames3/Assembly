bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, gets, printf           
import exit msvcrt.dll    
import gets msvcrt.dll    
import printf msvcrt.dll    

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    buffer times 100 db 0
    format db "%s", 0Ah, 0

; our code starts here
segment code use32 class=code
    start:
        push dword buffer
        call [gets]
        add esp, 4*1
        
        push dword buffer
        push dword format
        call [printf]     
        add esp, 4*2       
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
