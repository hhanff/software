#include <stdio.h>
#include <string.h>

int
main (void)
{
  char stri[21];

  strcpy (stri, "hallo");
  printf ("Der String ist %d Zeichen lang", strlen (stri));
}
