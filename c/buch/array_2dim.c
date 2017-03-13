#include <stdio.h>

#define WIDTH 9
#define HEIGHT 9

int
main (void)
{
  int x, y;
  int feld[WIDTH][HEIGHT];
  for (x = 0; x < WIDTH; x++)
    {
      for (y = 0; y < HEIGHT; y++)
	{
	  printf ("Feldwert [%d][%d] ", x, y);
	  scanf (" %d ", &feld[x][y]);
	  printf (" \n ");
	}
    }

  for (x = 0; x < WIDTH; x++)
    for (y = 0; y < HEIGHT; y++)
      printf (" Wertfeld[%d][%d] = %d \n", x, y, feld[x][y]);
  return 0;
}
