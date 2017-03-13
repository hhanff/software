#include <stdio.h>

int
main ()
{
  int *i;
  int test = 0;

  i = &test;
  printf ("Wert von test = %i\n", test);
  printf ("Adresse von test = %i\n", &test);

  printf ("Adresse auf die i zeigt = %i\n", i);



  return 0;
}
