#include <stdio.h>

int
main (void)
{
  char string[] = "Darf man wirklich so riechen?";
  char ch = '!';
  int x = 0;
  char *c = &ch;

  while (ch != '\0')
    {
      ch = string[x]; 
      putchar (ch);
      x++;
    }

  return 0;
}
