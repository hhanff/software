#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <math.h>

// negative Zahlen abfangen
//

int
main (int argc, char *argv[])
{
  int                 fd_in, fd_out;
  int                 x = 0, y = 0, i = 0, j = 0, temp_i[32], digit = 0;;
  char                ret;
  float               temp_f[3], sum_f;
  const char         *s = "Test-Text 0123\n";
  char                buffer[50];
  float               vect_f[51];

  if (argc != 4) {
    fprintf (stderr, "\n%s.exe:\tToo few or too many arguments\n", argv[0]);
    printf ("Usage:\t\t%s.exe <input_filename> <output_filename> <degree>\n", argv[0]);
    printf ("Example:\t%s.exe input.txt output.txt\n", argv[0]);
    return (1);
    //    pings = atoi(argv[1]);
  }
  else if (2 > 51) {
    fprintf (stderr, "\n%s.exe:\targv[4] too > 51. Choose smaller value.\n", argv[0]);
    return (1);
  }


  /* Zum Lesen öffnen */
  fd_in = open (argv[1], O_RDONLY);
  if (fd_in == -1)
    exit (-1);

  /* Zum Schreiben öffnen */
  fd_out = open (argv[2], O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR);
  if (fd_out == -1)
    exit (-1);


  while (read (fd_in, &ret, sizeof (char)) > 0) {
    if (ret == '\t') {
      x++;
      if (x == 2) {             // start reading a number
        while (read (fd_in, &ret, sizeof (char)) > 0) {
          if (ret == ',' | ret == '.') {
            for (j = 0; j < digit; j++) {
              sum_f = sum_f + (temp_i[j]) * pow (10, digit - j - 1);
            }
            digit = 0;
          }

          if (ret == '\t') {
            for (j = 0; j < digit - 1; j++) {
              sum_f = sum_f + (temp_i[j + 1]) * pow (10, -j - 1);
            }
            printf ("2: %10.5f\n", sum_f);
            sprintf (buffer, "%f\n", sum_f);
            write (fd_out, buffer, strlen (buffer));
            digit = 0;
            sum_f = 0;
            break;
          }
          temp_i[digit] = atoi (&ret);
          digit++;
        }
      }
    }
    if (ret == '\n') {
      x = 0;
      y++;
      //    printf("\n");
    }

  }
  close (fd_in);
  close (fd_out);

  return 0;

}
