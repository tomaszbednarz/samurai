

#ifndef __KEYBOARD_SYSTEM__
#define __KEYBOARD_SYSTEM__

#define PLUM __cdecl

extern "C"
{
  void	  PLUM key_single_is(void);
  void	  PLUM key_install(void);
  void	  PLUM key_deinstall(void);
  int	  PLUM key_hit(void);
  void	  PLUM key_wait(void);
  void	  PLUM key_set_single(short);
  int	  PLUM key_check(short);
  extern  int  key_installed;
  extern  int  key_exit_is;
}

#define key_esc 	1
#define key_1		2
#define key_2		3
#define key_3		4
#define key_4		5
#define key_5		6
#define key_6		7
#define key_7		8
#define key_8		9
#define key_9		10
#define key_0		11
#define key_minus	12
#define key_plus	13
#define key_backspace	14
#define key_tab 	15
#define key_q		16
#define key_w		17
#define key_e		18
#define key_r		19
#define key_t		20
#define key_y		21
#define key_u		22
#define key_i		23
#define key_o		24
#define key_p		25
#define key_lbracket	26
#define key_rbracket	27
#define key_enter	28
#define key_lctrl	29
#define key_a		30
#define key_a		30
#define key_s		31
#define key_d		32
#define key_f		33
#define key_g		34
#define key_h		35
#define key_j		36
#define key_k		37
#define key_l		38
#define key_srednik	39
#define key_gprzecinek	40
#define key_tylda	41
#define key_lshift	42
#define key_bshlash	43
#define key_z		44
#define key_x		45
#define key_c		46
#define key_v		47
#define key_b		48
#define key_n		49
#define key_m		50
#define key_przecinek	51
#define key_kropka	52
#define key_shlash	53
#define key_rshift	54
#define key_printsc	55
#define key_lalt	56
#define key_space	57
#define key_capslock	58
#define key_numlock	69
#define key_scrolllock	70
#define key_num7	71
#define key_num8	72
#define key_num9	73
#define key_numminus	74
#define key_num4	75
#define key_num5	76
#define key_num6	77
#define key_numplus	78
#define key_num1	79
#define key_num2	80
#define key_num3	81
#define key_num0	82
#define key_numdel	83
#define key_f1		59
#define key_f2		60
#define key_f3		61
#define key_f4		62
#define key_f5		63
#define key_f6		64
#define key_f7		65
#define key_f8		66
#define key_f9		67
#define key_f10 	68
#define key_rctrl	157
#define key_ralt	184
#define key_up		200
#define key_left	203
#define key_right	205
#define key_down	208
#define key_lwindow	219
#define key_rwindow	220
#define key_kmouse	221

#endif
