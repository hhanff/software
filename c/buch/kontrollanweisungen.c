#include <stdio.h>

#define WIDTH 9
#define HEIGHT 9

int
main (void)
{
  int x = 101, x2;


  if (x > 100)
    {
      /*
       * falls x > 100 ist: Fehlerausgabe 
       */
      printf ("x = %d ist zu gross fuer die Berechnung!\n", x);
      break;
    }
  else
    {
      /*
       * falls x <= 100 ist: Berechne Summe der Zahlen 1...x 
       */
      /*
       * Die lokale Variable x2 lebt nur innerhalb dieses alse-Blocks 
       */

      for (x = 0; x2 > 0; x2--)
	x += x2;
      // continue würde mit dem nächsten Schleifendurchlauf
      // weitermachen.
      // break würde ein Verlassen der Schleife bewirken
    }


  int menu = 1;
  int total, numb1 = 1, numb2 = 2;
  char calType;
  switch (menu)
    {				/* select the type of calculation */
    case 1:
      total = numb1 + numb2;
      calType = '+';		/* assign a char to symbolise calculation
				 * type */
      break;
    case 2:
      total = numb1 - numb2;
      calType = '-';
      break;
    case 3:
      total = numb1 * numb2;
      calType = '*';
      break;
    case 4:
      total = numb1 / numb2;
      calType = '/';
      break;
    default:
      printf ("Invalid option selected\n");
    }


  int zahl1 = 0;
  int zahl2 = 1;

  while (zahl1 < 3)
    {
      zahl1 = zahl1 + 1;
      zahl2 = zahl2 * 2;
    }

  int i = 2;

  do
    {
      i = i * i;		/* i quadrieren */
      printf ("i = %d\n", i);
    }
  while (i < 20);

  int lauf, summe;

  for (lauf = 1, summe = 0; lauf <= 10; lauf += 2)
    {
      summe += lauf;
    }
}
