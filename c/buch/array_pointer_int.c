#include <stdio.h>

int
main (void)
{
  int rn[] = { 'I', 'V', 'X', 'L', 'C', 'M' };
  int *r;
  int x;

  r = rn;
  for (x = 0; x < 6; x++)
    {
      printf ("%i.) %u = %c\n", x + 1, r, rn[x]);
      r++;
    }
  return 0;
}
