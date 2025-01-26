
;include "d:\wc\inc\hexi"



;²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²² [some constants] ²

o       equ offset
q       equ qword ptr
d       equ dword ptr
w       equ word ptr
b       equ byte ptr
plum    equ 10100101H

tak     = 1
nie     = 0

Arg1    = 4
Arg2    = 8
Arg3    = 12
Arg4    = 16
Arg5    = 20
Arg6    = 24
Arg7    = 28
Arg8    = 32
Arg9    = 36
Arg10   = 40

;²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²² [ macros ] ²

;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת convert 32-bit offset to 16-bit
MACRO           OFS32TO16_EAX
                mov     edi,eax
                shr     eax,4
                and     edi,0fh
ENDM
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת convert 32-bit offset to 16-bit
MACRO           OFS32TO16_EAX_EDX
                mov     edx,eax
                shr     eax,4
                and     edx,0fh
ENDM
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת vait for wretrace
MACRO           VRAMKA
                LOCAL   @@rama1,@@rama2
                push    eax edx
                mov     edx,03dah
 @@rama1:       in      al,dx
                test    al,8
                jnz     @@rama1
 @@rama2:       in      al,dx
                test    al,8
                jz      @@rama2
                pop     edx eax
ENDM
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת

;²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²

;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת

GLOBAL  set_int_vect         : PROC
GLOBAL  get_int_vect         : PROC
GLOBAL  physical_mem_mapping : PROC
GLOBAL  dealloc_dos_memory   : PROC
GLOBAL  alloc_dos_memory     : PROC
GLOBAL  mmalloc              : PROC
GLOBAL  mmdealloc            : PROC
GLOBAL  rmode_int            : PROC
GLOBAL  error_global         : PROC
GLOBAL  wprintf              : PROC
GLOBAL  always_pusty_call    : PROC
GLOBAL  fill_zero            : PROC
GLOBAL  copy_data            : PROC
GLOBAL  my_assert            : PROC
GLOBAL  mmfree               : PROC
GLOBAL  mmzalloc             : PROC

GLOBAL  fill_dword           : PROC


GLOBAL  RM_REGISTERS
GLOBAL  _edi,_esi,_ebp       : DWORD
GLOBAL  _ebx,_edx,_ecx       : DWORD
GLOBAL  _eax                 : DWORD
GLOBAL  _reg_reserved
GLOBAL  _di,_si,_bp,_bx
GLOBAL  _dx,_cx,_ax
GLOBAL  _cpuflags,_es,_ds
GLOBAL  _fs,_gs,_ip,_cs
GLOBAL  _sp,_ss

;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת important

GLOBAL  timer_installed      : DWORD

