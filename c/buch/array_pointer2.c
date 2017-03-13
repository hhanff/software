#include <stdio.h>

int
main (void)
{
  char rn[] = { 'I', 'V', 'X', 'L', 'C', 'M' };
  char *r;
  int x;

  r = rn;
  for (x = 0; x < 6; x++)
    {
      printf ("%i.) %u = %c\n", x + 1, r, rn[x]);
      r++;
    }
  return 0;
}
