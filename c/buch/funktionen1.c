#include <stdio.h>

// Übergabe eines Parameters an eine Funktion als Kopie. Auswirkung: Nicht 
// der Parameter selbst wird erhoeht, sondern nur die Kopie
// void erhoehe (int x)
// {
   // x = x + 1;
// }

// int main (void)
// {
   // int a = 0;
   // erhoehe(a);
   // /* a ist immer noch 0 */

   // return 0;
// }

// Übergabe eines Parameters an eine Funktion als Zeiger. Auswirkung: Der
// Parameter selbst wird erhoeht!

void
erhoehe (int *x)
{
  /*
   * erhoehe den Wert an der Adresse x um eins 
   */
  *x = *x + 1;
}

int
main (void)
{
  int a = 0;
  erhoehe (&a);
  /*
   * a ist jetzt 1 
   */
  printf ("a = %i", a);

  return 0;
}
