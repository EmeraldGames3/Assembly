bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               
import exit msvcrt.dll    
import printf msvcrt.dll    

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    format db "%d", 0
    number dw 123
    ;0011 0010 0001 0000
    ;0000 0001 0010 0011
    
; our code starts here
segment code use32 class=code
    start:
        
        mov ax, [number]
        mov ebx, 0
        mov esi, 4
        
        repeat:
            mov dx, 0
            cmp esi, 0
            je endwhile
            
            mov cx, 10
            div cx
            shl bx, 4
            or bx, dx
            
            dec esi
            
        jmp repeat
            
        endwhile:
        
        mov ax, bx
        and ax, 0000_0000_0000_1111b
        shl ax, 12
        
        mov cx, bx
        and cx, 0000_0000_1111_0000b
        shl cx, 4
        or ax, cx
        
        mov cx, bx
        and cx, 0000_1111_0000_0000b
        shr cx, 4
        or ax, cx
        
        mov cx, bx
        and cx, 1111_0000_0000_0000b
        shr cx, 12
        or ax, cx
        
        mov bx, ax
        
        push ebx
        push dword format
        call [printf]
        add esp, 4*2
            
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
