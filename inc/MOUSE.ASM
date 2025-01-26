; coded by Tomek Bednarz (aka Warlock)
; MOUSE.ASM
; procedury obslugi myszki

IDEAL
P486

MODEL   FLAT,C

;נננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננ

CODESEG

INCLUDE "always.inc"

;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת public consts

M_Left_Button   EQU 1
M_Right_Button  EQU 2
M_Middle_Button EQU 4

PUBLIC  mouse_cursor_off
PUBLIC  mouse_cursor_on
PUBLIC  mouse_cursor_xy
PUBLIC  mouse_speed_xy
PUBLIC  mouse_install
PUBLIC  mouse_deinstall

;תתתתתתתתתתתתתתתתתתתתתתתתת
PUBLIC  mouse_rb
PUBLIC  mouse_lb
PUBLIC  mouse_mb
PUBLIC  mouse_x
PUBLIC  mouse_y
PUBLIC  mouse_is

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                     ;[MOUSE_HANDLER]
mouse_handler:
                pushf
                cli
                pushad
                push    edi esi
                push    fs
                mov     ax,SEG dane_myszy
                mov     fs,ax
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת
                mov     [fs:mouse_lb],0
                mov     [fs:mouse_mb],0
                mov     [fs:mouse_rb],0
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת pozycja
                shr     cx,1
                mov     [fs:mouse_x],cx
                mov     [fs:mouse_y],dx
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת przyciski
                test    ebx,M_Left_Button
                jz      @@nie_lewy
                mov     [fs:mouse_lb],1
 @@nie_lewy:    test    ebx,M_Middle_Button
                jz      @@nie_srodek
                mov     [fs:mouse_mb],1
 @@nie_srodek:  test    ebx,M_Right_Button
                jz      @@nie_prawy
                mov     [fs:mouse_rb],1
 @@nie_prawy:
                pop     fs
                pop     esi edi
                popad
                sti
                popf
                retf
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                     ;[MOUSE_INSTALL]
PROC            mouse_install
                USES    es,ebx,ecx,edx

                mov     [_eax],0
                call    rmode_int,33h
                mov     eax,[_eax]
                or      ax,ax
                jz      @@no_handler
;תתתתתתתתתתתתתת
                mov     [mouse_is],1
                mov     eax,12     ;ust. maski i adresu proc.przerwania
                mov     ecx,11111b ;maska
                push    cs
                pop     es
                lea     edx,[mouse_handler]
                int     33h
 @@no_handler:
                ret
ENDP            mouse_install
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                   ;[MOUSE_DEINSTALL]
PROC            mouse_deinstall
                USES    es,ecx,edx
                mov     [mouse_is],0
                mov     eax,12     ;ust. maski i adresu proc.przerwania
                xor     ecx,ecx
                mov     es,cx
                xor     edx,edx
                int     33h
                ret
ENDP            mouse_deinstall
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                    ;[MOUSE_SPEED_XY]
PROC            mouse_speed_xy
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @mouse_s_x      equ esp+Arg1+0*4
        @mouse_s_y      equ esp+Arg2+0*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     eax,[@mouse_s_x]
                mov     [_ecx],eax
                mov     eax,[@mouse_s_y]
                mov     [_edx],eax
                mov     [_eax],15
                call    rmode_int,33h
                ret
ENDP            mouse_speed_xy
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                   ;[MOUSE_CURSOR_XY]
PROC            mouse_cursor_xy
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @mouse_x        equ esp+Arg1+0*4
        @mouse_y        equ esp+Arg2+0*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     eax,[@mouse_x]
                mov     [_ecx],eax
                mov     eax,[@mouse_y]
                mov     [_edx],eax
                mov     [_eax],4
                call    rmode_int,33h
                ret
ENDP            mouse_cursor_xy
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                  ;[MOUSE_CURSOR_OFF]
PROC            mouse_cursor_off
                mov     [_eax],2
                call    rmode_int,33h
                ret
ENDP            mouse_cursor_off
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                   ;[MOUSE_CURSOR_ON]
PROC            mouse_cursor_on
                mov     [_eax],1
                call    rmode_int,33h
                ret
ENDP            mouse_cursor_on
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°


;נננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננ

DATASEG

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ special variables
LABEL           dane_myszy
mouse_rb        dd 0
mouse_lb        dd 0
mouse_mb        dd 0
mouse_x         dw 0,0
mouse_y         dw 0,0
mouse_is        dd 0
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

END



