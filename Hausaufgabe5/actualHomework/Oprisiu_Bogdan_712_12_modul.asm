bits 32 

global start        

extern exit, gets, printf, printToFile
import exit msvcrt.dll
import gets msvcrt.dll
import printf msvcrt.dll

segment data use32 class=data
    s times 100 db 0
    maximum dd -2147483648
	;Der maximum startet mit dem kleinsten Wert, dass einen double word haben kann
    isNegative dd 1;Diese variable wird benutzt um zu bestimmen ob der Nummer negativ ist`
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
			;Hier bestimmen wir ob der nachste Nummer negativ ist
            
            cmp bl, '0'
            jl notNumber
            cmp bl, '9'
            ja notNumber
			;Hier bestimmen wir ob wir noch einen nummer haben, oder ob der Nummer sich beendet hat
            
            isNumber:
                sub bl, '0'
                mov edx, 10
                imul edx; edx:eax = eax * 10
                ;eigentlich eax = eax*10, da wir edx nicht beachten
                ;Das ist weil wir doublewords benutzen
                
                add eax, ebx
				;Hier bilden wir den Nummer aus dem Chars
                
                inc esi
                jmp whileBuildNumbers
                
            notNumber:
                cmp eax, 0
                je notWasNumber
				;Wenn eax 0 ist wissen wir sicher, dass wir keinen Nummer hatten und wir konnen weiter gehen
                
                wasNumber:
                    imul dword[isNegative]
					;Wir multiplitzieren den Nummer mit -1 wenn ein minus vor dem Nummer war
                    
                    mov ecx, [maximum]
                    cmp eax, ecx
					;Wir bestimmen ob den gebildeten Nummer, groesser ist als den vorigen maximum
                    jle notBigger
                    
                    bigger:
                        mov [maximum], eax
                    
                    notBigger:
                
                    push eax
                    push dword formatPrintNumbers
                    call [printf]
                    add esp, 4*3
					;Wir zeigen den gebildeten Nummer auf dem Bildschirm
                    
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
                
				;Wenn ein minus zeichen vor dem Nummer vorkommt maxhen wir isNegative -1
				;um den negativen Nummer bilden zu konnen
				
                inc esi
                jmp whileBuildNumbers
            
        endwhileBuildNumbers:
		
            cmp eax, 0
            je notWasNumberEnd
			;Wir bestimmen ob der Letzte charakter nummerisch war
			;Wenn dieser eine Ziffer war, bedeutet es, dass wir noch nicht gepruft haben
			;Ob dieser Nummer grosser ist als der letzte maximum
        
            imul dword[isNegative]
			;Wir multiplitzieren den Nummer mit -1 wenn ein minus vor dem Nummer war
            
            mov ecx, [maximum]
            cmp eax, ecx
			;Wir bestimmen ob den gebildeten Nummer, groesser ist als den vorigen maximum
            jle notBiggerEnd
                    
            biggerEnd:
                mov [maximum], eax
                    
            notBiggerEnd:
            push eax
            push dword formatPrintNumbers
            call [printf]
            add esp, 4*3
			;Wir zeigen den gebildeten Nummer auf dem Bildschirm
            
            notWasNumberEnd:
                    
            push dword [maximum]
            push dword formatPrintMaximum
            call [printf]
			;Wir zeigen den maximum auf dem Bildschirm
            add esp, 4*3
            
        push dword [maximum]
        call printToFile
		;Wir rufen die Funktion an, dass den Maximum in der Datei schreiben wird
        add esp, 4
        
        push    dword 0
        call    [exit]
