#include <stdio.h>
#include <stdlib.h>
# Test
int
main (int argc, char *argv[], char *environ[])
{
  int i;

  printf ("Es wurden %d Parameter angegeben", argc);

  for (i = 0; i < argc; i++)
    printf ("Parameter %d: %s\n", i, argv[i]);

  for (i = 0; environ[i] != NULL; ++i)
    printf ("environ[%d] = %s\n", i, environ[i]); 
}
