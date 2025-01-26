
#ifndef __MOUSE_SYSTEM__
#define __MOUSE_SYSTEM__

#define PLUM __cdecl

extern "C"
{
  void    PLUM mouse_cursor_on(void);
  void    PLUM mouse_cursor_off(void);
  void    PLUM mouse_cursor_xy(int,int);
  void    PLUM mouse_speed_xy(int,int);
  void    PLUM mouse_install(void);
  void    PLUM mouse_deinstall(void);

  extern  int PLUM mouse_rb;
  extern  int PLUM mouse_lb;
  extern  int PLUM mouse_mb;
  extern  int PLUM mouse_x;
  extern  int PLUM mouse_y;
  extern  int PLUM mouse_is; //czy mysz zainstalowana
}

#endif