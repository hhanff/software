#include <stdio.h>

#define WIDTH 9
#define HEIGHT 9

int Zahl1, Zahl2;
char Zeichen;

int
main (void)
{
  int var = (int) 5.912345;
  printf ("var = %i \n", var);

  int *addr;
  addr = (int *) 0x1234;
  printf ("addr = %x \n", addr);
  return 0;
}
