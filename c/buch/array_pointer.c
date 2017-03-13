#include <stdio.h>

int
main (void)
{
  char rn[] = { 'I', 'V', 'X', 'L', 'C', 'M' };
  char *r;
  int x;

  for (x = 0; x < 6; x++)
    {
      r = &rn[x];
      printf ("%i.) %u = %c\n", x + 1, r, rn[x]);
    }
  return 0;
}
