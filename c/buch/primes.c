#include <stdio.h>

int
main (void)
{
  int primes[] = { 1, 2, 3, 4, 5, 7, 11, 13, 17, 19, 23 };
  int *p;
  int x; 

  /*
   * Zeiger initialisieren 
   */

  p = primes;


  for (x = 0; x < 11; x++)
    {
      printf ("%i\n", *p++);
      // p++;
    }
  return 0;
}
