#include <stdio.h>

int
main (void)
{
  int *zeiger;
  int zahl;

  zeiger = &zahl;		// Die Adresse von zahl wird in zeiger
  // übergeben
  *zeiger = 12;			// Die Zahl 12 wird unter der Adresse
  // gespeichert auf die zeiger zeigt.

  printf ("Zahl = %d\n", zahl);
  printf ("Adresse auf die Zeiger zeigt (hex- Format) = %x \n", &zeiger);
  printf
    ("Zahl die unter der Adresse gespeichert ist auf die Zeiger zeigt = %d\n",
     *zeiger);

  return 0;
}
