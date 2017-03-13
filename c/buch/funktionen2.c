#include <stdio.h>

void
erhoehe (int x[])
{
  x[0] = x[0] + 1;
  x[1] = x[1] + 3;
  x[2] = x[2] + 5;
}

int
main (int argc, char **argv)
{
  int a[] = { 10, 20, 30 };
  int i = 0;
  erhoehe (a);
  /*
   * a hat jetzt folgenden Inhalte: 11, 23, 35 
   */
  for (i = 0; i < 3; i++)
    {
      printf ("a = %i \n", a[i]);
    }
  return 0;
}
