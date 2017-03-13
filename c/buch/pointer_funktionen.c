#include <stdio.h>

void peasoup (int *green);

int
main (void)
{
  int *head;
  int turn;

  turn = 13;
  head = &turn;

  peasoup (head);

  printf ("Oh nein, es ist %i!\n", *head);
  return 0;
}

void
peasoup (int *green)
{
  while ((*green)--)
    puts ("Blech!");

  *green = 13 * 51 + 3;
}
