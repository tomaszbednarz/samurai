; coded by Tomek Bednarz (aka Warlock)
; ALWAYS.ASM
; podstawowe funkcje systemowe

LOCALS
IDEAL
P486

MODEL   FLAT,C

;ğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğ

CODESEG

include "always.inc"

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                          ;[mmzalloc]
PROC            mmzalloc
                USES    esi,edi,ebx,ecx,edx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @ile@memora     equ esp+Arg1+5*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ecx,[@ile@memora]
                mov     [dword ptr poke_ile],ecx
                push    ecx
                call    mmalloc
                add     esp,4
                push    eax
                mov     edi,eax
                mov     ecx,00010001h
           poke_ile=$-4
                xor     eax,eax
                rep     stosb
                pop     eax
                ret
ENDP            mmzalloc
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                            ;[mmfree]
PROC            mmfree
                USES    edi
                sub     esp,48
                mov     eax,0500h
                mov     edi,esp
                int     31h
                mov     eax,[esp]
                add     esp,48
                ret
ENDP            mmfree
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                         ;[copy_data]
PROC            copy_data
                USES    ecx,edi,esi
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @adresik        equ esp+Arg1+3*4
        @adresik2       equ esp+Arg2+3*4
        @ile_tego       equ esp+Arg3+3*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ecx,[@ile_tego]
                mov     edi,[@adresik2]
                mov     esi,[@adresik]
                rep     movsb
                ret
ENDP            copy_data
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                         ;[fill_zero]
PROC            fill_zero
                USES    ecx,edi
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @adresik        equ esp+Arg1+2*4
        @ile_tego       equ esp+Arg2+2*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ecx,[@ile_tego]
                mov     edi,[@adresik]
                xor     eax,eax
                shr     ecx,1
                rep     stosw
                adc     ecx,ecx
                rep     stosb

                ;xor     eax,eax
                ;mov     ecx,[@ile_tego]
                ;mov     edi,[@adresik]
                ;rep     stosb
                ret
ENDP            fill_zero
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
PUBLIC fill_dword
ALIGN 4                                                        ;[fill_dword]
PROC            fill_dword
                USES    ecx,edi
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @adresik        equ esp+Arg1+2*4
        @ile_tego       equ esp+Arg2+2*4
        @@dwordd        equ esp+Arg3+2*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ecx,[@ile_tego]
                mov     edi,[@adresik]
                mov     eax,[@@dwordd]
                shr     ecx,2
                rep     stosd
                ret
ENDP            fill_dword
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                      ;[set_int_vect]
PROC            set_int_vect
                USES    ebx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @przerwanie     equ esp+Arg1+1*4
        @adresik        equ esp+Arg2+1*4
        @segmencik      equ esp+Arg3+1*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     eax,[@przerwanie]
                mov     edx,[@adresik]
                mov     ebx,[@segmencik]
                push    ds
                mov     ds,bx
                mov     ah,25h
                int     21h
                pop     ds
                ret
ENDP            set_int_vect
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                      ;[get_int_vect]
PROC            get_int_vect
                USES    ebx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @przerwanie     equ esp+Arg1+1*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     eax,[@przerwanie]
                mov     ah,35h
                push    es
                int     21h
                mov     eax,ebx
                mov     dx,es
                pop     es
                ret
ENDP            get_int_vect
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                              ;[physical_mem_mapping]
PROC            physical_mem_mapping
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @adres@fiz      equ esp+Arg1+0*4
        @ile@pamieci    equ esp+Arg2+0*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ax,0800h
                mov     ecx,[@adres@fiz]
                mov     edi,[@ile@pamieci]
                mov     ebx,ecx
                and     ecx,65535
                shr     ebx,16
                mov     esi,edi
                and     edi,65535
                shr     esi,16
                int     31h
                jnc     @@mapok
                call    error_global,o msg_mapp
 @@mapok:
                shl     ebx,16
                mov     bx,cx
                mov     eax,ebx
                ret
ENDP            physical_mem_mapping

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                ;[dealloc_dos_memory]
PROC            dealloc_dos_memory
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @segmemora      equ esp+Arg1+0*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     eax,[@segmemora]
                mov     eax,[eax]
                mov     [_eax],4900h
                mov     [w _es],ax
                call    rmode_int,21h
                test    [w _cpuflags],1
                jz      @@deok
                call    error_global,o msg_memddos
  @@deok:       ret
ENDP            dealloc_dos_memory
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                  ;[alloc_dos_memory]
PROC            alloc_dos_memory
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @ile@memora     equ esp+Arg1+0*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ebx,[@ile@memora]
                shr     ebx,4
                mov     [_ebx],ebx
                mov     [_eax],4800h
                call    rmode_int,21h
                test    [w _cpuflags],1
                jz      @@okdos
                call    error_global,o msg_memdos
 @@okdos:       mov     eax,[_eax]
                shl     eax,4
                ret
ENDP            alloc_dos_memory
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                         ;[mmdealloc]
PROC            mmdealloc
                USES    esi,edi,eax
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @adres_extens   equ esp+Arg1+3*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     esi,[@adres_extens]
                mov     di,[esi-4]
                mov     si,[esi-2]
                mov     ax,0502h
                int     31h
                jnc     @@memok
                call    error_global,o msg_memout
  @@memok:      ret
ENDP            mmdealloc
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                           ;[mmalloc]
PROC            mmalloc
                USES    esi,edi,ebx,ecx,edx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @ile@memora     equ esp+Arg1+5*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ecx,[@ile@memora]
                add     ecx,4
                mov     ax,0501h
                mov     ebx,ecx
                shr     ebx,16
                int     31h
                jnc     @@memok
                call    error_global,o msg_mem
 @@memok:       shl     ebx,16
                mov     bx,cx
                mov     [ebx],di
                mov     [ebx+2],si
                add     ebx,4
                mov     eax,ebx         ;linear address of alloc memory
                ret
ENDP            mmalloc
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                         ;[rmode_int]
PROC            rmode_int
                USES    ebx,ecx,edi
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @przerwanko     equ esp+Arg1+3*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ebx,[@przerwanko]
                xor     bh,bh
                mov     eax,300h
                xor     ecx,ecx
                lea     edi,[RM_REGISTERS]
                int     31h
                ret
ENDP            rmode_int
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                      ;[error_global]
PROC            error_global
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @adres@napis    equ esp+Arg1+0*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     eax,3
                int     10h
                mov     eax,[@adres@napis]
                push    eax
                call    wprintf
                add     esp,4
                push    [d o karetka]
                call    wprintf
                add     esp,4
                mov     eax,4c01h
                int     21h
                ret
ENDP            error_global



;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                           ;[wprintf]
PROC            wprintf
                USES    ebx,edx,eax
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @adres@napisu   equ esp+Arg1+3*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ebx,[@adres@napisu]
                mov     ah,2
 @@jedziemy:    mov     dl,[ebx]
                inc     ebx
                or      dl,dl
                jz      @@koniec_jazdy
                cmp     dl,0ffh
                je      @@koniec_jazdy
                cmp     dl,10
                jne     @@pisz
                int     21h
                mov     dl,13
 @@pisz:        int     21h
                jmp     @@jedziemy
 @@koniec_jazdy:
                ret
ENDP            wprintf
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                 ;[always_pusty_call]
PROC            always_pusty_call
                ret
ENDP            always_pusty_call
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                         ;[my_assert]
PROC            my_assert
                USES    eax
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @adres_assert   equ esp+Arg1+1*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     eax,[@adres_assert]
                or      eax,eax
                jnz     @@assok
                call    error_global,o msg_mem
 @@assok:       ret
ENDP            my_assert
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°


;ğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğğ

DATASEG

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ special variables

msg_free        db 'ğ Free Mem Info error',7,0
msg_mem         db 'ğ Allocation memory error',7,0
msg_memdos      db 'ğ Allocation dos memory error',7,0
karetka         db 10,13,0
msg_memddos     db 'ğ Deallocation dos memory error',7,0
msg_memout      db 'ğ Deallocation memory error',7,0
msg_mapp        db 'ğ physical memory mapping error',7,0
msg_getvect     db 'ğ Get interrupt vector error',7,0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ real mode registers

label   RM_REGISTERS
label   _di
label   _edi    dword   ;offset 00h
                dw 0,0
label   _si
label   _esi    dword   ;offset 04h
                dw 0,0
label   _bp
label   _ebp    dword   ;offset 08h
                dw 0,0
label   _reg_reserved
                dd 0    ;reserved, ignored
label   _bx
label   _ebx    dword   ;offset 10h
                dw 0,0
label   _dx
label   _edx    dword   ;offset 14h
                dw 0,0
label   _cx
label   _ecx    dword   ;offset 18h
                dw 0,0
label   _ax
label   _eax    dword   ;offset 1ch
                dw 0,0
label   _cpuflags
                dw 0    ;offset 20h
label   _es
                dw 0    ;offset 22h
label   _ds
                dw 0    ;offset 24h
label   _fs
                dw 0    ;offset 26h
label   _gs
                dw 0    ;offset 28h
label   _ip
                dw 0    ;reserved, ignored
label   _cs
                dw 0    ;reserved, ignored
label   _sp
                dw 0    ;offset 2eh
label   _ss
                dw 0    ;offset 30h

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ very important vars

timer_installed dd 0

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

END





