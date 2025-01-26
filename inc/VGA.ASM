; coded by Tomek Bednarz (aka Warlock)
; VGA.ASM
; procedury obslugi karty VGA

IDEAL
P486

MODEL   FLAT,C

include "always.inc"
;o equ offset

CODESEG

PUBLIC  set_video_mode
PUBLIC  ramka
PUBLIC set_palette


;같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같�
ALIGN 4                                                       ;[SET_PALETTE]
PROC            set_palette
                USES    esi,edx,ecx
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
        @adres_1        equ esp+Arg1+3*4
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
                mov     esi,[@adres_1]
                mov     dx,03c8h
                mov     al,0
                out     dx,al
                inc     dx
                mov     ecx,768
                rep     outsb
                ret
ENDP            set_palette
;같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같같�

PROC            set_video_mode tryb:dword
                mov     eax,[tryb]
                int     10h
                ret
ENDP            set_video_mode


PROC            ramka


        mov edx,03dah
@i1:    in al,dx
        test al,8
        je @i1
@i2:
        in al,dx
        test al,8
        jne @i2

                ret
ENDP            ramka




DATASEG


END





