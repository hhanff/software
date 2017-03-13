#include <stdio.h>

int
main ()
{
  char c;
  int i;
  long x;
  float f;
  double d;
  double temp[8];

  puts ("Variablengroessen:");
  printf ("char variable c = %i\n", sizeof (c));
  printf ("int variable i = %i\n", sizeof (i));
  printf ("long variable x = %i\n", sizeof (x));
  printf ("float variable f = %i\n", sizeof (f));
  printf ("double variable d = %i\n", sizeof (d));

  printf ("Groesse des Arrays = %i\n", sizeof (temp));

  return 0;
}
