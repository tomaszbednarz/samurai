
#ifndef __TIMER_FRAME__
#define __TIMER_FRAME__

#define PLUM __cdecl

extern "C"
{
  void	  PLUM timer_install(void);
  void	  PLUM timer_deinstall(void);
  extern  int  timer_count;
  extern  int  timer_installed;
}

#endif
