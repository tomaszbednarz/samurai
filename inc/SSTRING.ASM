; coded by Tomek Bednarz (aka Warlock)
; STRING.ASM
; operacje na lancuchach

IDEAL
P486

MODEL   FLAT,C

;נננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננ

CODESEG

INCLUDE "always.inc"

;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת public consts
PUBLIC  str_compare

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                       ;[STR_COMPARE]
PROC            str_compare
                USES    esi,edi
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @adres_1        equ esp+Arg1+2*4
        @adres_2        equ esp+Arg2+2*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     esi,[@adres_1]
                mov     edi,[@adres_2]
 @@scomp:       mov     al,[esi]
                mov     ah,[edi]
                cmp     al,ah
                je      @@dalej
                xor     eax,eax
                jmp     @@koniec
 @@dalej:       or      al,al
                jz      @@koniec1
                inc     esi
                inc     edi
                jmp     @@scomp
 @@koniec1:     mov     eax,1
 @@koniec:      ret
ENDP            str_compare
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°


;נננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננ

DATASEG

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ special variables

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

END



