
#ifndef __FPU_SYSTEM__
#define __FPU_SYSTEM__

#define PLUM __cdecl

extern "C"
{
  float   wtan(float);
  float   wsin(float);
  float   wcos(float);
  float   wsqrt(float);
  float   wsqr(float);
  float   watan2(float,float);
}

#endif

