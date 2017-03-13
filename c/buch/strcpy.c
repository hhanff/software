#include <stdio.h>
#include <string.h>

int
main (void)
{
  char stri1[21], eingabe[21];

  strcpy (stri1, "hallo");

  printf ("Der 1. String: %s\n", stri1);
  printf ("Bitte geben Sie maximal 20 Zeichen ein: ");
  scanf ("%s", eingabe);
  strcpy (stri1, eingabe);
  printf ("\n%s = %s", stri1, eingabe);

  return 0;
}
