// coded by Tomek Bednarz (aka Warlock)
// SYSOP.CPP
// systemowe procedury napisane w watcom si plas plas

#include <malloc.h>

//� � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � �

#define PLUM __cdecl

extern "C"
{
  void   PLUM error_global(char*);
}

//� � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � �

char *memalloc(int ile_mem)
{
  char *adres=(char*)malloc(ile_mem);
  if (adres!=NULL) { return (char*)(adres); }
  error_global("� not enough memory\n");
  return NULL;
}

//� � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � �
