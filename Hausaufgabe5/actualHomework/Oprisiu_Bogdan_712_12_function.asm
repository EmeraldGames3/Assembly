bits 32

global start        

global printToFile

extern exit, fopen, fprintf, fclose, printf
import exit msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll

segment data use32 class=data
    tempFormat db "merge", 0
    fileName db "max.txt", 0
    accesMode db "w", 0
    fileDescriptor dd -1
    max dd 0
    text db "Der maximum ist %#x", 0

segment code use32 class=code
    printToFile:
		;Diese Funktion bekommet als Parameter den maximum
		;Dieser Maximum wird in der Datei max.txt geschrieben
		;Wenn die Datei max.txt nicht existiert, diese wird erstellt
	
        mov eax, [esp + 4]
        mov [max], eax
		;Wir tun im max den maximum, dass durch dem Stack bekommt wird
    
        push dword accesMode
        push dword fileName
        call [fopen]
        add esp, 4*2
		;Wir offnen die Datei
        
        mov [fileDescriptor], eax
        
        cmp eax, 0
        je endFunction
		;Wenn die Datei nicht erreichbar ist beenden wir die Funktion
        
        push dword [max]
        push dword text
        push dword [fileDescriptor]
        call [fprintf]
        add esp, 4*2
		;Wir schreiben in der Datei
        
        push dword [fileDescriptor]
        call [fclose]
        add esp, 4
		;Wir schliessen die Datei
        
    endFunction:
		;Hier beenden wir die Funktion und gehen zuruck im main
        ret
    
        push    dword 0
        call    [exit]
