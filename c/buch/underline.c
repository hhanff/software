#include <stdio.h>
#include <ctype.h>

void novowels (char *string);

int
main (void)
{
  char *phrase = "Weg mit den Vokalen in Fredonia!";

  puts ("Vor der Saeuberung:\n");
  puts (phrase);

  vovowels (phrase);

  puts ("\nNach der Saeuberung:\n");
  puts (phrase);
  return 0;
}

void
novowels (char *string)
{
  while (*string++)



    }
