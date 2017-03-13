#include <stdio.h>

long *
suche_0 (long *addr)
{
  while (*addr != 0)
    {
      addr = addr + 1;
      printf ("addr = %x \n", &addr);
    }
  return addr;
}

int
main (int argc, char **argv)
{
  long addr = 0;
  printf ("Adresse von addr = %x \n", &addr);
  suche_0 (&addr);
  printf ("Adresse des ersten 0-long Wertes: %l \n", &addr);
  return 0;
}
