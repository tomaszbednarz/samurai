
#ifndef __ALWAYS_SYSTEM__
#define __ALWAYS_SYSTEM__

#include <vga.h>
#include <vesa.h>
#include <keyboard.h>
#include <wfpu.h>
#include <file.h>
#include <timer.h>
#include <mouse.h>
#include <sstring.h>
#include <malloc.h>
#include <sysop.h>

#define PLUM __cdecl
#define M_PI 3.14159265359
#define false 0
#define true 1

typedef  unsigned short ushort;
typedef  unsigned int uint;
typedef  unsigned char uchar;
typedef  char byte;
typedef  unsigned char byteu;
typedef  short word;
typedef  unsigned short wordu;
typedef  int dword;
typedef  unsigned int dwordu;
typedef  char db;
typedef  unsigned char dbu;
typedef  short dw;
typedef  unsigned short dwu;
typedef  int dd;
typedef  unsigned int ddu;

extern "C"
{
  void   PLUM fill_zero(void*,int);
  void   PLUM copy_data(void*,void*,int);
  void   PLUM wprintf(char*);
  void   far  PLUM *get_int_vect(int);
  void   PLUM set_int_vect(unsigned char,void far *adres);
  void   PLUM error_global(char*);
  void   PLUM my_assert(void*);

  dwordu PLUM mmfree();
  byteu  PLUM *mmalloc(dwordu);
  byteu  PLUM *mmzalloc(dwordu);
  void   PLUM mmdealloc(void*);

  void   PLUM fill_dword(void*,int,dword);

}

#endif
