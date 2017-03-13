#include <stdio.h>

float
quadrat (float param1)
{
  float zahl;
  zahl = param1 * param1;
  return zahl;
}
#TEST2
#Test4
#Test3
int
main () 
{
  float zahl, ergebnis;

  printf ("Bitte Zahl eingeben: ");
  scanf ("%f", &zahl);

  ergebnis = quadrat (zahl);

  printf ("%f hoch 2 = %f\n", zahl, ergebnis);
  printf ("%f hoch 2 = %f\n", 5.0, quadrat (5));

  return 0;
}
