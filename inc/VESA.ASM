; Tomash Bednarz / warlock of amnesty / (C) 1997
; VESA.ASM
; upupianie VESY (czysta forma)

IDEAL
P486

MODEL   FLAT,C

;נננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננ

CODESEG

include "always.inc"

;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת public consts

PUBLIC  vesa_set_mode
PUBLIC  vesa_show
PUBLIC  vesa_show_frames

PUBLIC  vesa_linear
PUBLIC  vesa_ekran
PUBLIC  vesa_buf_size

EXTRN   timer_count     : DWORD


PROC            vesa_show_frames
                USES    edi,ecx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @vbuffer        equ esp+Arg1+2*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     ecx,[timer_count]
                cmp     ecx,0
                jnz     @@pluma
                inc     ecx
 @@pluma:       mov     edi,[@vbuffer]
                add     edi,2
                mov     ax,0ffffh
 @@loop:        stosw
                add     edi,2
                loop    @@loop
                ret
ENDP            vesa_show_frames

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                         ;[VESA_SHOW]
PROC            vesa_show
                USES    esi,edx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @vbuffer        equ esp+Arg1+2*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                VRAMKA
                mov     esi,[@vbuffer]
                call    [vesa_view_proc]
                ret
ENDP            vesa_show
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                                     ;[VESA_SET_MODE]
PROC            vesa_set_mode
                USES    ebx,esi,edi,ebp,edx,ecx
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
        @vesa@x@res     equ esp+Arg1+6*4
        @vesa@y@res     equ esp+Arg2+6*4
        @vesa@col@in    equ esp+Arg3+6*4
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
                mov     eax,[@vesa@x@res]
                mov     [vesa_x_res],eax
                mov     eax,[@vesa@y@res]
                mov     [vesa_y_res],eax
                mov     eax,[@vesa@col@in]
                mov     [vesa_col_bit],eax
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת
                call    alloc_dos_memory,512
                mov     ebx,eax
                shr     ebx,4
                mov     [vesa_mem_seg],ebx
                mov     ebp,eax
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת get vesa info
                OFS32TO16_EAX
                mov     [_eax],4f00h
                mov     [w _es],ax
                mov     [_edi],edi
                call    rmode_int,10h
                mov     eax,[_eax]
                cmp     eax,4fh
                je      @@vsa_1stok
 @@vsa_bee:     call    error_global,o msg_not_found
 @@vsa_1stok:   mov     eax,'ASEV'
                cmp     eax,[ebp]
                jne     @@vsa_bee
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת find color bit mode
                mov     eax,[vesa_col_bit]
                lea     edi,[VESA_TEXT_modes]
                cmp     eax,1                   ;textModes
                je      @@SearchFor
                lea     edi,[VESA_16c_modes]
                cmp     eax,4                   ;4-bit
                je      @@SearchFor
                lea     edi,[VESA_256c_modes]
                cmp     eax,8                   ;8-bit
                je      @@SearchFor
                lea     edi,[VESA_32c_modes]
                cmp     eax,15                  ;15-bit
                je      @@SearchFor
                lea     edi,[VESA_64c_modes]
                cmp     eax,16                  ;16-bit
                je      @@SearchFor
                lea     edi,[VESA_16Mc_modes]
                cmp     eax,24                  ;24-bit
                je      @@SearchFor
                lea     eax,[msg_colbit]
                push    eax
                call    error_global
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת moja lista
 @@searchFor:
                mov     ecx,[edi]               ;how many modes
                add     edi,4
                mov     eax,[vesa_y_res]
                shl     eax,16
                mov     ax,[w vesa_x_res]
                xor     edx,edx                 ;not found
 @@utwory:
                mov     ebx,[edi]
                cmp     ebx,eax
                jne     @@OdiProfanum
                inc     edx
                jmp     @@karta_teraz
 @@OdiProfanum:
                add     edi,8
                dec     ecx
                jnz     @@utwory
                call    error_global,o msg_nie_lista
 @@karta_teraz:
                mov     eax,[edi+4]             ;-> vesa mode of mylist
                mov     [vesa_mode],eax
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת porownaj z karta SVGA
                movzx   ecx,[w ebp+vsa_tryby]
                movzx   ebx,[w ebp+vsa_tryby+2]
                shl     ebx,4
                add     ebx,ecx
                xor     edx,edx
                and     eax,0111111111b
 @@wzorzec:
                mov     cx,[ebx]
                cmp     cx,-1
                je      @@koniecWzorca
                cmp     cx,ax
                je      @@znaleziono_tryb
                inc     ebx
                inc     ebx
                jmp     @@wzorzec
 @@koniecWzorca:
                call    error_global,o msg_nie_tryb
 @@znaleziono_tryb:
                movzx   eax,[w ebp+VSA_TotalMemory]
                mov     [vesa_totalmem],eax
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת load vesa mode info
                mov     ecx,[vesa_mode]
                and     ecx,0111111111b
                mov     [_ecx],ecx
                mov     [_eax],4f01h
                mov     eax,ebp
                OFS32TO16_EAX
                mov     [w _es],ax
                mov     [_edi],edi
                call    rmode_int,10h
                mov     eax,[_eax]
                cmp     ax,4fh
                je      @@vmodeok
                call    error_global,o msg_vmode
 @@vmodeok:
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת jaki tryb ???
                cmp     [vesa_linear],nie
                je      @@vesa_switch_bank
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת linear vesa
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת
                test    [w ebp+VSA_Atrybuty],128
                jnz     @@okline
                call    error_global,o msg_line
 @@okline:
                or      [vesa_mode],16384       ;bit liniowosci w trybie
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת
                mov     ebx,[ebp+VSA_PhysAddress]
                mov     eax,[vesa_ekran]
                cmp     eax,ebx
                je      @@bylo_wczesniej
                mov     eax,[vesa_Totalmem]
                push    eax
                push    ebx
                call    physical_mem_mapping
                add     esp,8
                mov     [vesa_ekran],eax
 @@bylo_wczesniej:
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת test for speeding vshow
                movzx   eax,[b ebp+VSA_BitsPer]
                inc     eax
                shr     eax,3           ;eax = bytes per pixel
                movzx   ebx,[w ebp+VSA_Xresolution]
                imul    eax,ebx
                movzx   ecx,[w ebp+VSA_BytesPerLn]
                cmp     eax,ecx
                jne     @@pokaz_z_dopelnieniem
                movzx   ebx,[w ebp+VSA_Yresolution]
                imul    eax,ebx
                mov     [vesa_buf_size],eax
                shr     eax,2                   ;for: movsd
                mov     [d poke_vesa_buf_bez_dopelnienia],eax
                mov     [d vesa_view_proc],o vesa_show_l_bez_dopelnienia
                mov     [vesa_dopelnic],0
                jmp     @@vesa_get_zakoncz
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת with complete
 @@pokaz_z_dopelnieniem:
                sub     ecx,eax
                mov     [d poke_vesa_buf_z_dopelnieniem_dod],ecx
                mov     edx,eax
                shr     eax,2
                mov     [d poke_vesa_buf_z_dopelnieniem_x],eax
                movzx   ebx,[w ebp+VSA_Yresolution]
                mov     eax,edx             ;ת
                imul    eax,ebx             ;ת
                mov     [vesa_buf_size],eax ;ת
                mov     [d poke_vesa_buf_z_dopelnieniem_y],ebx
                mov     [d vesa_view_proc],o vesa_show_l_z_dopelnieniem
                mov     [vesa_dopelnic],1
                jmp     @@vesa_get_zakoncz
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת vesa with bank switching
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת
 @@vesa_switch_bank:
                mov     [vesa_ekran],0A0000h


;nie zapomniec o:
;                 vesa_buf_size







;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת
 @@vesa_get_zakoncz:
                call    dealloc_dos_memory,o vesa_mem_seg
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת set vesa mode
                mov     eax,[vesa_mode]
                mov     [_ebx],eax
                mov     [_eax],4f02h
                call    rmode_int,10h
                ret
ENDP            vesa_set_mode
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                         ;[vesa_show_bez_dopelnienia]
PROC            vesa_show_l_bez_dopelnienia
                push    edi ecx
                mov     edi,[vesa_ekran]
                mov     ecx,00010001h
        poke_vesa_buf_bez_dopelnienia=$-4
                rep     movsd
                pop     ecx edi
                ret
ENDP            vesa_show_l_bez_dopelnienia
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4                                          ;[vesa_show_z_dopelnieniem]
PROC            vesa_show_l_z_dopelnieniem
                push    edi ecx                 ;kocham PLUMKI ;)
                mov     edi,[vesa_ekran]
                mov     eax,00010001h
        poke_vesa_buf_z_dopelnieniem_y=$-4
 @@vslzd:
                mov     ecx,00010001h
        poke_vesa_buf_z_dopelnieniem_x=$-4
                rep     movsd
                add     edi,00010001h
        poke_vesa_buf_z_dopelnieniem_dod=$-4
                dec     eax
                jnz     @@vslzd
                pop     ecx edi
                ret
ENDP            vesa_show_l_z_dopelnieniem
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

;נננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננ

DATASEG

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ special variables

vesa_x_res      dd 0
vesa_y_res      dd 0
vesa_col_bit    dd 0
vesa_mode       dd 0
vesa_totalmem   dd 0
vesa_linear     dd tak  ;tak or nie
vesa_ekran      dd 0    ;liniowy adres do pamieci ekranu
vesa_view_proc  dd o always_pusty_call
vesa_buf_size   dd 0

vesa_dopelnic   dd 0    ;1-tak 0-nie
vesa_mem_seg    dd ?

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

msg_not_found   db 'נ VESA not found, please run UNIVBE',7,0
msg_colbit      db 'נ wrong color bitmode, use other',7,0
msg_nie_lista   db 'נ VESA-mode-list doesn''t have resolution like your',7,0
msg_nie_tryb    db 'נ VESA mode not supported, try UniVBE',7,0
msg_vmode       db 'נ something bad with video mode, it has headache',7,0
msg_line        db 'נ linear vesa not found, please install UniVBE',7,0
msg_setm        db 'נ set video mode error',7,0

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ list of my vesa modes

MASM
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת text modes
VESA_TEXT_modes LABEL
        dd   (o _TEXT_ends-$)/8
        dw     80,  60,108h,0   ;80x60xT
        dw    132,  25,109h,0   ;132x25xT
        dw    132,  43,10ah,0   ;132x43xT
        dw    132,  50,10bh,0   ;132x50xT
        dw    132,  60,10ch,0   ;132x60xT
_TEXT_ends LABEL
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת kolorow az 16
VESA_16c_modes LABEL
        dd   (o _16_ends-$)/8
        dw    800, 600,102h,0   ;800x600x16
        dw   1024, 768,104h,0   ;1024x768x16
        dw   1280,1024,106h,0   ;1280x1024x16
_16_ends LABEL
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת 8-bit modes
VESA_256c_modes LABEL
        dd   (o _256_ends-$)/8
        dw    640, 400,100h,0   ;640x400x256
        dw    640, 480,101h,0   ;640x480x256
        dw    800, 600,103h,0   ;800x600x256
        dw   1024, 768,105h,0   ;1024x768x256
        dw   1280,1024,107h,0   ;1280x1024x256
_256_ends LABEL
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת 15-bit hicolor
VESA_32c_modes LABEL
        dd   (o _32_ends-$)/8
        dw    320, 200,10dh,0   ;320x200x32K
        dw    320, 240,12eh,0   ;320x240x32K
        dw    640, 480,110h,0   ;640x480x32K
        dw    800, 600,113h,0   ;800x600x32K
        dw   1024, 768,116h,0   ;1024x768x32K
        dw   1280,1024,119h,0   ;1280x1024x32K
_32_ends LABEL
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת 16-bit hicolor
VESA_64c_modes LABEL
        dd   (o _64_ends-$)/8
        dw    320, 200,10eh,0   ;320x200x64K
        dw    320, 240,132h,0   ;320x240x64k
        dw    360, 200,134h,0   ;360x200x64k
        dw    360, 240,135h,0   ;360x240x64k
        dw    320, 400,133h,0   ;320x400x64k
        dw    360, 400,136h,0   ;360x400x64k
        dw    640, 480,111h,0   ;640x480x64K
        dw    640, 350,11fh,0   ;640x350x64k
        dw    640, 400,120h,0   ;640x400x64k
        dw    800, 600,114h,0   ;800x600x64K
        dw   1024, 768,117h,0   ;1024x768x64K
        dw   1280,1024,11ah,0   ;1280x1024x64K
_64_ends LABEL
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת 24-bit hicolor
VESA_16Mc_modes LABEL
        dd   (o _16M_ends-$)/8
        dw    320, 200,10fh,0   ;320x200x16M
        dw    640, 480,112h,0   ;640x480x16M
        dw    800, 600,115h,0   ;800x600x16M
        dw   1024, 768,118h,0   ;1024x768x16M
        dw   1280,1024,11bh,0   ;1280x1024x16M
_16M_ends LABEL
IDEAL

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

VSA_Tryby       = 14
VSA_TotalMemory = 18

VSA_Atrybuty    = 0
VSA_Xresolution = 18
VSA_Yresolution = 20
VSA_PhysAddress = 40
VSA_BytesPerLn  = 16
VSA_BitsPer     = 25

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

END
