; Tomash Bednarz / warlock of amnesty / (C) 1997
; KEYBOARD.ASM
; klawiatura - obsluga

IDEAL
P486

MODEL   FLAT,C

;נננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננ

CODESEG

include "always.inc"

;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת public consts

PUBLIC  key_single_is
PUBLIC  key_install
PUBLIC  key_deinstall
PUBLIC  key_set_single
PUBLIC  key_hit
PUBLIC  key_wait
PUBLIC  key_check
PUBLIC  key_exit_is

;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת external consts

EXTRN   timer_deinstall : PROC

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                  ;[KEYBOARD_HANDLER]
keyboard_handler:
                pushf
                pushad
                push    esi edi
                mov     esi,[key]
                mov     edi,[singleHitKey]
                mov     ebx,[singleHitOk]
                xor     eax,eax
                mov     al,20h
                out     20h,al
                in      al,60h
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת
                cmp     al,0e0h
                jne     @@inner_01
                mov     [key_dodac],128
                jmp     @@kh_get_out
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת
 @@inner_01:
                cmp     al,127
                jbe     @@inner_else
                and     al,127
                add     ax,[key_dodac]
                mov     [byte ptr ebx+eax],1
                mov     [byte ptr esi+eax],0
                jmp     @@kh_inner_01
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת
 @@inner_else:
                add     ax,[key_dodac]
                cmp     [byte ptr esi+eax],1
                je      @@kh_inner_01
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת brak klawisza w tablicy
                cmp     [b edi+eax],1
                jne     @@else_1
                cmp     [b ebx+eax],1
                jne     @@after_else
 @@else_1:
                mov     [byte ptr esi+eax],1
 @@after_else:
;תתתתתתתתתתתתתת dzis bracha nie bylo w domu ;)
                cmp     [b ebx+eax],1
                jne     @@kh_inner_01
                mov     [b ebx+eax],0
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת
 @@kh_inner_01:
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת do wywalenia
                mov     [key_dodac],0
 @@kh_get_out:  cmp     [key_exit_is],0
                je      @@wyjdz
                cmp     [b esi+26],0
                je      @@wyjdz
                cmp     [b esi+27],0
                je      @@wyjdz
                cmp     [timer_installed],0
                je      @@dobra
                call    timer_deinstall
 @@dobra:       call    error_global,o msg_key_exit
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת do wywalenia
 @@wyjdz:
                pop     edi esi
                popad
                popf
                iretd
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                         ;[KEY_CHECK]
PROC            key_check
                USES    esi
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @numerKey       equ esp+Arg1+1*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     eax,[@numerKey]
                mov     esi,[key]
                movzx   eax,[b esi+eax]
 @@ok_all:      ret
ENDP            key_check
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                     ;[KEY_SINGLE_IS]
PROC            key_single_is
                USES    esi,edi
                mov     esi,[key]
                mov     edi,[singlehitkey]
                mov     ecx,256
                xor     edx,edx
 @@tak:         cmp     [byte ptr edi+edx],1
                jne     @@nie
                mov     [byte ptr esi+edx],0
 @@nie:         inc     edx
                dec     ecx
                jnz     @@tak
                ret
ENDP            key_single_is
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                    ;[KEY_SET_SINGLE]
PROC            key_set_single
                USES    esi
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @numerKey       equ esp+Arg1+1*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     eax,[@numerKey]
                mov     eax,[@numerKey]
                mov     esi,[singleHitKey]
                mov     ebx,1
                sub     bl,[esi+eax]
                mov     [esi+eax],bl
                ret
ENDP            key_set_single
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                          ;[KEY_WAIT]
PROC            key_wait
 @@powtorz:     call    key_hit
                or      eax,eax
                jz      @@powtorz
                ret
ENDP            key_wait
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                           ;[KEY_HIT]
PROC            key_hit
                cmp     [key_installed],1
                jne     @@key_hout
                mov     ebx,[key]
                mov     ecx,256
                xor     edx,edx
 @@sprawdz:     mov     al,[ebx+edx]
                or      al,al
                jz      @@oponek
                mov     eax,1
                jmp     @@key_houOK
 @@oponek:      inc     edx
                dec     ecx
                jnz     @@sprawdz
 @@key_hout:    xor     eax,eax
 @@key_houOK:   ret
ENDP            key_hit
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                       ;[KEY_INSTALL]
PROC            key_install
                USES    edi
                cmp     [key_installed],1
                je      @@key_get_out
                ;allocate memory for keyboard tables
                call    alloc_dos_memory,256+0+256+256
                mov     ebx,eax
                shr     ebx,4
                mov     [key_mem_seg],ebx
                mov     edi,eax
                mov     [key],eax
                add     eax,256
                mov     [singleHitKey],eax
                add     eax,256
                mov     [singleHitOk],eax
                xor     eax,eax
                mov     ecx,(256+0+256)/4
                rep     stosd
                inc     eax
                mov     ecx,256
                rep     stosb
                ;get bios handler
                call    get_int_vect,09h
                mov     [w Old_keyboard_Vect+4],dx
                mov     [d Old_keyboard_Vect+0],eax
                ;install new timer
                cli
                mov     eax,09h
                push    cs
                push    offset far keyboard_handler
                push    eax
                call    set_int_vect
                add     esp,0ch
                sti
                mov     [key_installed],1
 @@key_get_out:
                ret
ENDP            key_install
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                     ;[KEY_DEINSTALL]
PROC            key_deinstall
                cli
                xor     eax,eax
                mov     ax,[w old_keyboard_vect+4]
                push    eax
                push    [old_keyboard_vect]
                mov     eax,09h
                push    eax
                call    set_int_vect
                add     esp,0ch
                sti
                call    dealloc_dos_memory,o key_mem_seg
                mov     [key_installed],0
                ret
ENDP            key_deinstall
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

;נננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננ

DATASEG

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ special variables
old_keyboard_vect dd 0
                  dw 0
key_installed     dd 0
key_dodac         dw 0
key_mem_seg       dd 0
key               dd 0
singleHitKey      dd 0
singleHitOk       dd 0
key_exit_is       dd 1
msg_key_exit      db '[EXIT] secret key pressed...',7,0
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

END
