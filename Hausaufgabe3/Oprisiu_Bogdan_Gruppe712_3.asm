bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
;Zwei Folgen (vonBytes) S1 und S2 werden angegeben.
;Erstelle die Folge D, indem man die Elemente von
;S1 von der linken Seite zur rechten Seite und die 
;Elemente von S2 von der rechten Seite zur linken 
;Seite verkettet werden.

segment data use32 class=data
    s1 db 1, 2, 3, 4
    l1 equ $-s1
    s2 db 5, 6, 7, 8, 9
    l2 equ $-s2
    d times l1+l2 db 0
    ;d = 1, 2, 3, 4, 9, 8, 7, 6, 5

; our code starts here
segment code use32 class=code
    start:
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        mov esi, 0
        ;ESI ist aktuelle position in dem array d
        
        mov ecx, l1
        mov ebx, 0
        ;Wir benutzen EBX um den array s1 durchzulaufen
        
        ;In whileS1 werden die Elemente aus s1 in d getan in demselben reihenfolge
        whileS1:
        cmp ebx, ecx
        ; wenn ebx = ecx bedeutet es dass wir den ganzen array durchgelaufen haben
        JE endWhileS1
        
        mov al, [s1 + ebx]
        INC ebx
        
        mov [d + esi], al
        INC esi
        JMP whileS1
        endWhileS1:
        
        mov ebx, l2
        dec ebx
        ; EBX wird benutz im s2 im umgekehrten reihenfolge durchzulaufen
        ; EBX beginnt mit dem wert l2 - 1 und geht bis 0 an

        mov ecx, 0
        mov eax, 0
        
        ; In whileS2 werden die elemente aus s2 im d im umgekehrten Reihenfolge getan
        whileS2:
        mov al, [s2 + ebx]
        ; EBX enthalt die position der Wert im s2
        mov [d + esi], al
        INC esi
        
        DEC ebx
        cmp ebx, -1
        ;Wenn ebx = -1 bedeutet es, dass wir durch alle Elemente aus s2 durchgelaufen haben
        
        JE endWhileS2
        JMP whileS2
        
        endWhileS2:
        
        mov ebx, l1
        add ebx, l2
        mov esi, 0
        
        ;Dieser while ist nur um zu sehen ob die aufgabe erfolgreich gelost wurde
        whileD:
        mov al, [d + esi]
        INC esi
        cmp esi, ebx
        JE endWhileD
        JMP whileD
        
        endWhileD:
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
