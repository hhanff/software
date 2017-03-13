#include <stdio.h>

#define NZAHLEN 10

int
main (void) 
{

  int i;
  int zahlen[NZAHLEN];		/* zahlen[0] ... zahlen[9] */

  for (i = 0; i < NZAHLEN; i++)
    {
      printf ("Bitte Zahl %d eingeben: ", i);
      scanf ("%d", &zahlen[i]);
      printf ("\n");
    }

  printf ("SUPER!\n");

  for (i = 0; i < NZAHLEN; i++)
    printf ("Zahl %d ist: %d\n", i, zahlen[i]);

  return 0;
}
