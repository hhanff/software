#include <stdio.h>

int
main (void)
{
  int zahl1;
  char zeichen1;

  printf ("Bitte geben Sie eine Zahl ein: ");
  scanf ("%i", &zahl1);
  printf ("Geben Sie einen Zeichen ein: ");
  scanf ("%c", &zeichen1);
  return 0;
}
