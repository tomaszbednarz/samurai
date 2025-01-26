

#ifndef __FILE_SYSTEM__
#define __FILE_SYSTEM__

#define PLUM __cdecl

typedef unsigned long file_h;

extern "C"
{
  file_h  PLUM file_open(char*);
  void    PLUM file_read(file_h,void*,int);
  void    PLUM file_close(file_h);
  int     PLUM file_size(file_h);
  int     PLUM file_pos(file_h);
  file_h  PLUM file_create(char*);
  file_h  PLUM file_write(file_h,void*,int);
  void    PLUM file_seek(file_h,int);
  void    PLUM file_load(char*,void*);
  void    PLUM file_save(char*,void*,int);
  short   PLUM file_rw(file_h);
  int     PLUM file_rdw(file_h);
  char    PLUM file_rb(file_h);
  float   PLUM file_rf(file_h);
}

#endif
