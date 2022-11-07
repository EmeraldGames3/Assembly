bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

;Ohne votzeichen

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
        a db 2
        b dw 2
        e dd 4
        x dq 4

; our code starts here
segment code use32 class=code
    start:
        ;(a*a / b + b*b) / (2+b) + e - x
        
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        
        mov al, [a]
        mov ah, 0
        mov bl, [a]
        mul bl; ax = a*a = 4
        mov bx, 0
        
        mov dx, 0; dx:ax = a*a = 4
        mov bx, [b]
        
        div bx; ax = dx:ax / bx =  a*a / b = 4 / 2 = 2
        mov dx, 0
        mov cx, ax; cx = a*a / b
        mov ax, [b]
        mov dx, [b]
        mul dx; dx:ax = b*b = 2 * 2 = 4
        
        clc
        mov bx, cx
        mov cx, 0
        add ax, bx; ax = ax + bx
        adc dx, cx; dx = dx + cx + cf
        ;dx:ax = a*a / b + b*b = 2 + 2*2 = 6
        
        mov ebx, 0
        mov ecx, 0
        
        mov bx, [b]
        add bx, 2; bx = b + 2
        
        div bx; ax = (a*a / b + b*b) / (b + 2) = 6 / 4 = 1
        mov bx, ax
        mov eax, 0
        mov ax, bx; eax = (a*a / b + b*b) / (b + 2)
        
        mov ebx, [e]
        add eax, ebx; eax = (a*a / b + b*b) / (b + 2) + e = 1 + 4 = 5
        mov edx, 0; edx:eax = (a*a / b + b*b) / (b + 2) + e
        
        mov ebx, [x]
        mov ecx, [x + 4]; ecx:ebx = x
        
        clc
        sub eax, ebx; eax = eax + ebx
        sbb edx, ecx; edx = edx + ecx + cf
        ; edx:eax = (a*a / b + b*b) / (b + 2) + e - x = 5 - 4 = 1
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
