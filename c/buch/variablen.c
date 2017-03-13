#include <stdio.h>

#define WIDTH 9
#define HEIGHT 9

int Zahl1, Zahl2;
char Zeichen;

int
main (void)
{
  const float PI = 3.141592;

  // Änderung hiermit möglich, obwohl PI eine Konstante ist
  *((float *) &PI) = 2;
  float gleitZahl;
  float floatVariable = 3.14;
  float floatVariable2 = -1.234E-6;
  /*
   * Anweisungen 
   */
  int zahl1, zahl2 = 12;
  char zeichen1 = 'A';

  zahl1 = 52;
  zeichen1 = zeichen1 + 1;

  return 0;
}
