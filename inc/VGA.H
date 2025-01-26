
#ifndef __VGA_SYSTEM__
#define __VGA_SYSTEM__

#define CALINECZKA __cdecl

typedef unsigned long file_h;

extern "C"
{
        void    CALINECZKA set_video_mode(int);
        void    CALINECZKA ramka();
        void    CALINECZKA set_palette(char*);

}

#endif
