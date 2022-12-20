bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf       
import exit msvcrt.dll    
import printf msvcrt.dll    

segment data use32 class=data
    a dw 23
    b dw 4
    format db "Quotient = %d, Rest = %d", 0 ;Den format fur dem Autput

; our code starts here
segment code use32 class=code
    start:
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        
        mov ax, [a]
        cwd         ; Wir konvertieren ax auf einem double word um die division durchzufuhren
        mov bx, [b]
        div bx      ; Wir divideren a durch b ( dx: ax / bx )
        ;Den quotient ist im ax und der rest is im dx 
        
        cwde ; Wir konvertieren den quotient in einem doubleword
        mov ebx, eax ; Wir speichern den quotien im ebx um eax wieder zu benutzen
        
        mov ax, dx; Wir tun den Rest im ax
        cwde ; Wir konvertieren den Rest in einem doubleword
        
        push eax; eax -> Rest: 3
        push ebx; ebx -> Quotient: 5
        push dword format
        ; Wir fugen den parametern der funktion printf auf dem stack im ungekehrten reihenfolge
        call [printf]
        add esp, 4 * 3 ; Wir befreien die Parametern auf dem Stack, 4*3 da es drei doublewords sind
        
        push    dword 0
        call    [exit]
