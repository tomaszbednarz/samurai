
#ifndef __VESAWARLOCK__
#define __VESAWARLOCK__

#define PLUM __cdecl

#define vesa_text 1
#define vesa_16   4
#define vesa_256  8
#define vesa_32k  15
#define vesa_64k  16
#define vesa_16m  24

#define tak 1
#define nie 0

extern "C" int      vesa_linear;
extern "C" char*    vesa_ekran;
extern "C" int      vesa_buf_size;

extern "C" {

  void    PLUM vesa_set_mode(int,int,int);
  void    PLUM vesa_show(void*);
  void    PLUM vesa_show_frames(void*);


}

#endif