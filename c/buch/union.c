#include <stdio.h>

#define WIDTH 9
#define HEIGHT 9

int
main (void)
{
  // Bsp.: Union, das es ermöglicht, auf die einzelnen Bytes eines long
  // zuzugreifen:
  typedef union
  {
    unsigned long as_long;
    unsigned short as_short[2];
    unsigned char as_byte[4];
  } data32_t;

  data32_t wert;

  wert.as_long = 0x12345678;
  wert.as_byte[0] = 0xab;

  printf ("Wert as long: %x \n", wert.as_long);
  printf ("Wert as byte: %x \n", wert.as_byte[0]);
}
