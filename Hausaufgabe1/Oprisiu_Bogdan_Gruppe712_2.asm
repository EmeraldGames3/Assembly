bits 32 ; assembling for the 32 bits architecture

;Mit vorzeihen

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db -1
    b db 2
    c db 4
    d dd 7
    e dq 6
    
; our code starts here
segment code use32 class=code
    start:
        ; 2 / (a+ b * c -9) + e - d
    
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
    
        mov al, [b]
        mov bl, [c]
        imul bl; ax = b * c = 2 * 4 = 8
        mov bx, ax; bx = b*c
        
        mov al, [a]
        cbw; ax = a
        add ax, bx; ax = a + b * c = (-1) + 8 = 7
        sub ax, 9; ax = a + b * c - 9 = 7 - 9 = -2
        
        mov bx, ax; bx = a + b * c - 9
        mov ax, 2
        mov dx, 0;dx:ax = 2
        idiv bx; ax = 2 / (a + b * c - 9) = 2 / (-2) = -1
        
        cwde; eax = 2 / (a + b * c - 9)
        cdq; edx:eax = 2 / (a + b * c - 9)
        
        mov ebx, [e]
        mov ecx, [e+4]
        ;ecx:ebx = e
        
        clc
        add eax, ebx
        adc edx, ecx
        ;edx:eax = 2 / (a + b * c - 9) + e = -1 + 6 = 5
        
        mov ebx, eax
        mov ecx, edx
        ;ecx:ebx = 2 / (a + b * c - 9) + e
        
        mov eax, [d]
        cdq; edx:eax = d
        
        clc
        sub ebx, eax
        sbb ecx, edx
        mov eax, ebx
        mov edx, ecx
        mov ebx, 0
        mov ecx, 0
        ; edx:eax = 2 / (a + b * c - 9) + e - d = 5 - 7 = -2
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
