; Tomash Bednarz / warlock of amnesty / (C) 1997
; NO_87.ASM
; nie dolanczamy bibliotek konwersji liczb float
; thanx go to Pascal/CT

IDEAL
P486

MODEL	FLAT,C

;נננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננננ

CODESEG

;תתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתתת public consts

PUBLIC	_CHP
PUBLIC	_8087
PUBLIC	fltused_
PUBLIC	_init_387_emulator

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
ALIGN 4
_CHP:
		frndint
fltused_:
_8087:
_init_387_emulator:
		ret
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

END
