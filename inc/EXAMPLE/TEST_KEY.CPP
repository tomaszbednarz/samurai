
#include <always.h>

main()
{
  key_install();

  key_set_single(key_f1);
  key_set_single(key_f5);
  key_set_single(key_enter);

  while(!key_check(key_esc))
  {
    if(key_hit())
    {
      if (key_check(key_esc)) break;
      if (key_check(key_f1)) wprintf("F1\n");
      if (key_check(key_f2)) wprintf("F2\n");
      if (key_check(key_f3)) wprintf("F3\n");
      if (key_check(key_f4)) wprintf("F4\n");
      if (key_check(key_f5)) wprintf("F5\n");
      if (key_check(key_f6)) wprintf("F6\n");
      if (key_check(key_f7)) wprintf("F7\n");
      if (key_check(key_f8)) wprintf("F8\n");
      if (key_check(key_f9)) wprintf("F9\n");
      if (key_check(key_f10)) wprintf("F10\n");
      if (key_check(key_tab)) wprintf("TAB\n");
      if (key_check(key_space)) wprintf("SPACJA\n");
      if (key_check(key_scrolllock)) wprintf("SCROLL LOCK\n");
      if (key_check(key_left)) wprintf("TURN LEFT\n");
      if (key_check(key_down)) wprintf("TURN DOWN\n");
      if (key_check(key_right)) wprintf("TURN RIGHT\n");
      if (key_check(key_up)) wprintf("TURN UP\n");
      if (key_check(key_rctrl)) wprintf("RIGHT CTRL\n");
      if (key_check(key_enter)) wprintf("ENTER\n");
      key_single_is();
    }
  }

  key_deinstall();
}