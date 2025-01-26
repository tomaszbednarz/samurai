; coded by Tomek Bednarz (aka Warlock)
; FILE.ASM
; procedury obslugi plikow
; last update:  4-07-97 00:26:38

IDEAL
P486

MODEL   FLAT,C


;ððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððð

CODESEG

INCLUDE "always.inc"

PUBLIC  file_open
PUBLIC  file_close
PUBLIC  file_read
PUBLIC  file_size
PUBLIC  file_create
PUBLIC  file_write
PUBLIC  file_pos
PUBLIC  file_seek
PUBLIC  file_load
PUBLIC  file_save
PUBLIC  file_rw
PUBLIC  file_rdw
PUBLIC  file_rb
PUBLIC  file_rf

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                         ;[FILE_OPEN]
PROC            file_open
                USES    edx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @nazwa@pliku    equ esp+Arg1+1*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     edx,[@nazwa@pliku]
                mov     [file_name],edx
                mov     ax,3d02h
                int     21h
                jnc     @@file_opening_ok
                lea     edx,[msg_error_open]
                jmp     file_error
 @@file_opening_ok:
                ret
ENDP            file_open
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                           ;[FILE_RB]
PROC            file_rb
                USES    ebx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @uchwyt         equ esp+Arg1+1*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ebx,[@uchwyt]
                mov     eax,1
                push    eax
                mov     eax,offset @@gdzie000-4
                push    eax
                push    ebx
                call    file_read
                add     esp,12
                mov     eax,00000011h
 @@gdzie000:    ret
ENDP            file_rb
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                           ;[FILE_RW]
PROC            file_rw
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @uchwyt         equ esp+Arg1+0*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ebx,[@uchwyt]
                mov     eax,2
                push    eax
                mov     eax,offset @@gdzie000-4
                push    eax
                push    ebx
                call    file_read
                add     esp,12
                mov     eax,00001111h
 @@gdzie000:    ret
ENDP            file_rw
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                          ;[FILE_RDW]
PROC            file_rdw
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @uchwyt         equ esp+Arg1+0*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ebx,[@uchwyt]
                mov     eax,4
                push    eax
		mov     eax,offset @@gdzie001-4
                push    eax
                push    ebx
                call    file_read
                add     esp,12
                mov     eax,11111111h
 @@gdzie001:    ret
ENDP            file_rdw
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                           ;[FILE_RF]
PROC            file_rf
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @uchwyt         equ esp+Arg1+0*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ebx,[@uchwyt]
                mov     eax,4
                push    eax
                mov     eax,offset local_float
                push    eax
                push    ebx
                call    file_read
                add     esp,12
                lea     eax,[local_float]
                ret
 @@liczba       dd 0
ENDP            file_rf
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                         ;[FILE_READ]
PROC            file_read
                USES    ebx,edx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @uchwyt         equ esp+Arg1+2*4
        @gdzie          equ esp+Arg2+2*4
        @ile            equ esp+Arg3+2*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ebx,[@uchwyt]
                mov     edx,[@gdzie]
                mov     ecx,[@ile]
                mov     ah,3fh
                int     21h
                jnc     @@file_reading_ok
                lea     edx,[msg_error_read]
                jmp     file_error
 @@file_reading_ok:
                ret
ENDP            file_read
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                        ;[FILE_CLOSE]
PROC            file_close
                USES    ebx,edx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @uchwyt         equ esp+Arg1+2*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ebx,[@uchwyt]
                mov     ax,3e00h
                int     21h
                jnc     @@file_close_ok
                mov     edx,o msg_error_close
                jmp     file_error
 @@file_close_ok:
                ret
ENDP            file_close
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                       ;[FILE_CREATE]
PROC            file_create
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @nazwa@pliku    equ esp+Arg1+0*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     edx,[@nazwa@pliku]
                mov     ax,3c00h
                mov     ecx,20h
                int     21h
                jnc     @@file_create_ok
                lea     edx,[msg_error_creat]
                jmp     file_error
 @@file_create_ok:
                ret
ENDP            file_create
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                        ;[FILE_WRITE]
PROC            file_write
                USES    ebx,ecx,edx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @uchwyt         equ esp+Arg1+3*4
        @skad           equ esp+Arg2+3*4
        @ile            equ esp+Arg3+3*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ebx,[@uchwyt]
                mov     ecx,[@ile]
                mov     edx,[@skad]
                mov     ah,40h
                int     21h
                jnc     @@file_write_ok
                lea     edx,[msg_error_write]
                jmp     file_error
 @@file_write_ok:
                ret
ENDP            file_write
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                         ;[FILE_SEEK]
PROC            file_seek
                USES    ebx,ecx,edx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @uchwyt         equ esp+Arg1+3*4
        @pozycja        equ esp+Arg2+3*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ax,4200h
                mov     ebx,[@uchwyt]
                mov     ecx,[@pozycja]  ;cx:dx
                mov     edx,ecx
                shr     ecx,16
                and     edx,0ffffh
                int     21h
                jnc     @@file_seek_ok
                lea     edx,[msg_error_seek]
                jmp     file_error
 @@file_seek_ok:
                ret
ENDP            file_seek
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                          ;[FILE_POS]
PROC            file_pos
                USES    ebx,ecx,edx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @uchwyt         equ esp+Arg1+3*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ebx,[@uchwyt]
                mov     ax,4201h
                xor     ecx,ecx
                xor     edx,edx
                int     21h
                shl     edx,16
                mov     dx,ax
                xchg    eax,edx
                ret
ENDP            file_pos
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                         ;[FILE_SIZE]
PROC            file_size
                USES    ebx,ecx,edx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @uchwyt         equ esp+Arg1+3*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ebx,[@uchwyt]
                mov     ax,4201h
                xor     ecx,ecx
                xor     edx,edx
                int     21h
                mov     [@pam_low],ax
                mov     [@pam_high],dx
                mov     ax,4202h
                xor     ecx,ecx
                xor     edx,edx
                int     21h
                shl     edx,16
                mov     dx,ax
                push    edx
                mov     ax,4200h
                mov     cx,[@pam_high]
                mov     dx,[@pam_low]
                int     21h
                pop     eax
                ret
 @pam_low       dw 0
 @pam_high      dw 0
ENDP            file_size
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                         ;[FILE_LOAD]
PROC            file_load
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @nazwa@pliku    equ esp+Arg1+0*4
        @adres@gdzie    equ esp+Arg2+0*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     eax,[@adres@gdzie]
                mov     [local_adres],eax
                mov     eax,[@nazwa@pliku]
                push    eax
                call    file_open
                mov     [local_fhandle],eax
                add     esp,4
                push    eax
                call    file_size
                add     esp,4
                push    eax             ;<-file size
                push    [local_adres]
                push    [local_fhandle]
                call    file_read
                add     esp,12
                push    [local_fhandle]
                call    file_close
                add     esp,4
                ret
ENDP            file_load
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                         ;[FILE_SAVE]
PROC            file_save
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @nazwa@pliku    equ esp+Arg1+0*4
        @adres@skad     equ esp+Arg2+0*4
        @ile@bajtow     equ esp+Arg3+0*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     eax,[@nazwa@pliku]
                push    eax
                call    file_create
                mov     [local_fhandle],eax
                add     esp,4
                mov     ebx,eax
                mov     eax,[@ile@bajtow]
                mov     ecx,[@adres@skad]
                push    eax
                push    ecx
                push    ebx     ;file handle
                call    file_write
                add     esp,12
                push    [local_fhandle]
                call    file_close
                add     esp,4
                ret
ENDP            file_save
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                        ;[FILE_ERROR]
PROC            file_error
                mov     ax,3
                int     10h
                mov     eax,edx
                call    @wprintf
                lea     eax,[msg_error_file]
                call    @wprintf
                mov     eax,[file_name]
                call    @wprintf
                lea     eax,[msg_error_bra]
                call    @wprintf
                lea     eax,[msg_beep]
                call    @wprintf
                mov     ax,4c01h
                int     21h
                ret
 @wprintf:
                mov     ebx,eax
                mov     ah,2
 @jedziemy:     mov     dl,[ebx]
                inc     ebx
                or      dl,dl
                jz      @koniec_jazdy
                cmp     dl,10
                jne     @pisz
                int     21h
                mov     dl,13
 @pisz:         int     21h
                jmp     @jedziemy
 @koniec_jazdy: ret
ENDP            file_error
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°


;ððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððððð

DATASEG

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ special variables
file_name       dd 0
local_fhandle   dd 0
local_adres     dd 0
local_float     dd 0
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ error messages
msg_error_open  db 'open ',0
msg_error_file  db 'file_error [ ',0
msg_error_bra   db ' ]',0
msg_beep        db 7,0
msg_error_read  db 'read ',0
msg_error_seek  db 'seek ',0
msg_error_write db 'write ',0
msg_error_close db 'close ',0
msg_error_creat db 'create ',0
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

END



