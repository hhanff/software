#include <stdio.h>

int
main (void)
{
  int array[8];
  int *a, x;

  /*
   * Zeiger initialisieren 
   */

  a = array;

  for (x = 0; x < 8; x++)
    {
      *(a) = x * 100;
      printf ("array[%i] = %i\n", x, *(a));
      a++;
    }
  return 0;
}
