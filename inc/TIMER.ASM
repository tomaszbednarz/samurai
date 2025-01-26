; Tomash Bednarz / warlock of amnesty / (C) 1997
; KEYBOARD.ASM
; klawiatura - obsluga

IDEAL
P486

MODEL	FLAT,C

;נננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננ

CODESEG

include "always.inc"

;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת public consts

PUBLIC	timer_install
PUBLIC	timer_deinstall

PUBLIC	timer_count




timer_tofik:
		pushad
		push	fs es esi edi

		inc	[timer_count]
		pushfd
		call	[pword Old_timer_vect]

		pop	edi esi es fs
		popad
		iretd


;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4 						    ;[TIMER_INSTALL]
PROC		timer_install
		USES	edx
		call	get_int_vect,08h
		mov	[w Old_timer_Vect+4],dx
		mov	[d Old_timer_Vect+0],eax
		;install new timer
		cli
		mov	eax,08h
		push	cs
		push	offset far timer_tofik
		push	eax
		call	set_int_vect
		add	esp,0ch
		mov	[timer_installed],1
		;czestotliwosc bicia na ramki
		mov	dx,03dah
 @@fir1:	in	al,dx
		test	al,8
		jnz	@@fir1
 @@fir2:	in	al,dx
		test	al,8
		jz	@@fir2
		mov	al,36h		; reset timera
		out	43h,al
		mov	al,0
		out	40h,al
		mov	al,0
		out	40h,al
 @@fir3:	in	al,dx		; vertical retrace
		test	al,8
		jnz	@@fir3
 @@fir4:	in	al,dx
		test	al,8
		jz	@@fir4
		xor	al,al		; FC
		out	43h,al
		in	al,40h
		mov	ah,al
		in	al,40h
		xchg	al,ah
		neg	ax
		shr	ax,1
		mov	[frametime],ax
		mov	al,36h		; i zegar na frametime
		out	43h,al
		mov	ax,[frametime]
		out	40h,al
		mov	al,ah
		out	40h,al
		sti
		ret
ENDP		timer_install
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4 						  ;[TIMER_DEINSTALL]
PROC		timer_deinstall
		cli
		xor	eax,eax
		mov	ax,[w old_timer_vect+4]
		push	eax
		push	[old_timer_vect]
		mov	eax,08h
		push	eax
		call	set_int_vect
		add	esp,0ch
		mov	[timer_installed],0
		mov	al,36h
		out	43h,al
		mov	ax,0
		out	40h,al
		out	40h,al
		sti
		ret
ENDP		timer_deinstall
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

;נננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננ

DATASEG

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ special variables
Old_timer_Vect	dd 0
		dw 0
frametime	dw 666h
timer_count	dd 0
;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

END
