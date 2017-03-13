#include <math.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

/*
gcc -pedantic -Wall -W -Wmissing-prototypes -Wstrict-prototypes -Wconversion -Wshadow -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings -Wnested-externs -fshort-enums -fno-common -Dinline= -g -O2 -lm lm73.c -o lm73; ./lm73 -c 5904
*/

int
main (int argc, char **argv)
{
  const int resolution = 14;
  const int P1 = 0;
  const int P2 = 100;
  double bit_temperature = 0;
  char *raw_data = NULL;
  double raw_data_value = 0.0;
  double multiplier = 0.0;
  int index;
  int c;
  unsigned int raw_data_hex[1];
  /* int opterr = 0; */

  switch (resolution)
  {
    case 14:
      bit_temperature = 0.03125;
      break;
    case 13:
      bit_temperature = 0.0625;
      break;
    case 12:
      bit_temperature = 0.125;
      break;
    case 11:
      bit_temperature = 0.25;
      break;
    default:
      fprintf(stderr, "ERROR! Range not supported!\n");
      return -1;
      break;
  }
  while ((c = getopt (argc, argv, "c:p:t:l:")) != -1)
    switch (c)
    {
      case 'l':
        puts("Converting temperature data from lmm73 sensor");
        raw_data = optarg;
        sscanf(raw_data, "%x", raw_data_hex);
        printf("Raw_Data_Hexadecimal: %x\n",raw_data_hex[0]);
        printf("Decimal             : %d\n",raw_data_hex[0]);
        /* raw_data_hex[0] = raw_data_hex[0] >> 2; */
        while (multiplier != resolution+1){
          /* printf("Mul %f\n", multiplier); */
          if (((raw_data_hex[0] & (1 << 0))) == 1){
            raw_data_value = raw_data_value + (bit_temperature*pow(2.0, multiplier));
            /* printf("Temp: %.2f\n", raw_data_value); */
          }
          raw_data_hex[0] = raw_data_hex[0] >> 1;
          multiplier++;
        }
          
        printf("Temperature in °C   : %.2f°C\n", raw_data_value);
        break;
      case 'p':
        puts("Converting pressure data from cioi2c sensor");
        raw_data = optarg;
        sscanf(raw_data, "%x", raw_data_hex);
        printf("Raw_Data_Hexadecimal :   %x\n",raw_data_hex[0]);
        printf("Decimal              :   %d\n",raw_data_hex[0]);
        raw_data_value = ((double)raw_data_hex[0]-4096)/8192*(P2-P1)+P1;
        printf("Pressure in bar      : %.3f bar\n", raw_data_value);
        break;
      case 't':
        puts("Converting temperature data from cioi2c sensor");
        raw_data = optarg;
        sscanf(raw_data, "%x", raw_data_hex);
        printf("Raw_Data_Hexadecimal :   %x\n",raw_data_hex[0]);
        printf("Decimal              :   %d\n",raw_data_hex[0]);
        raw_data_value = ((double)raw_data_hex[0]*0.1)-50;
        printf("Temperature in °C      : %.3f °C\n", raw_data_value);
        break;
      case '?':
        if (optopt == 'i')
          fprintf (stderr, "Option -%c requires an argument.\n", optopt);
        else if (isprint (optopt))
          fprintf (stderr, "Unknown option `-%c'.\n", optopt);
        else
          fprintf (stderr,
                   "Unknown option character `\\x%x'.\n",
                   optopt);
        return 1;
      default:
        abort ();
    }
     
     
  for (index = optind; index < argc; index++)
    printf ("Non-option argument %s\n", argv[index]);
  return 0;
}
