#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <errno.h>

/* If NDEBUG is defined, no assert() calls will be executed */
#define NDEBUG
#define MAX_PATTERN_LENGTH 256
#include <assert.h>

extern int errno;

/* Flag set by `--verbose'. */
static int verbose_flag = 0;
static int outFile_flag = 0;
static int pattern_flag = 0;
int main(int argc, char *argv[]) {
  

int c = 0;
  int i = 0;
  int max = 0;
  char *pattern = "abcdefghijklmnopqrstuvwxyz1234567890!§$&/()=?";  
  FILE *stream;
  char *outFile;

  /*  errlog = fopen(logFile,"a");
  #ifndef NDEBUG
  if (errlog == NULL) {
      stderr = errlog;
      fprintf(stderr, "\r\nInternal error. Errno: %i\n", errno);
  }
  else {
    printf("Datei erfolgreich geoeffnet!");
  }
  assert(c == 1000);
  #endif
  */

  while (1)
  {
    static struct option long_options[] = {
      /* These options set a flag. */
      {"verbose", no_argument, &verbose_flag, 1},
      /* These options don't set a flag. We distinguish them by their indices.   */
      {"number", required_argument, 0, 'n'},
      {"file", required_argument, 0,'f'},
      {"pattern", required_argument, 0, 'p'},
      {"help", no_argument, 0, 'h'},
      {0, 0, 0, 0}
    };
    /* getopt_long stores the option index here. */
    int option_index = 0;

    /* ":" only for command-line arguments that require an argument themselves*/
    c = getopt_long(argc, argv, "hn:f:p:", long_options, &option_index);

    /* Detect the end of the options. */
    if (c == -1){
      break;
    }
    switch (c)
    {
    case 0:
      /* If this option set a flag, do nothing else now. */
      if (long_options[option_index].flag != 0)
        break;
      printf("option %s", long_options[option_index].name);
      if (optarg)
        printf(" with arg %s", optarg);
      printf("\n");
      break;

    case 'n':
      max = atoi(optarg);
      break;

    case 'f':
      outFile = optarg;
      if((stream = fopen(outFile,"w+"))==NULL){
        printf("\nError while opening %s\n",outFile);
        fprintf(stderr, "\r\nError while opening %s\n",outFile);
      }

      if (outFile != NULL){
        outFile_flag = 1;
      }
      break;

    case 'p':
      /*pattern[MAX_PATTERN_LENGTH]='\0';*/
        pattern = optarg;
	pattern_flag = 1;
      break;
    case 'h':
      printf("call: pat_gen [OPTION]...\n");
      printf("This program will generate a pattern that can e.g. be used for software testing.\n");
      printf("Possible arguments are:\n");
      printf("-n, --number\t\t How many times shall the test pattern be repeated?\n");
      printf("-f, --file\t\t Name of the output file. Default output is shell\n");
      printf("-p, --pattern\t\t Desired pattern can be passed with this option. Default is:\n\t\t\t 'abcdefghijklmnopqrstuvwxyz1234567890!\"§$¸&()=?\n");
      printf("--verbose\t\t Prints more info after program call\n");
      printf("Example:\n");
      printf("pat_gen -f pattern -n 1000 -p abcdef\n");
      break;
    case '?':
      /* getopt_long already printed an error message. */
      break;

    default:
      abort();
    }
  }

  /* Instead of reporting `--verbose' and `--brief' as they are encountered,
     we report the final status resulting from them. */
  if (verbose_flag)
    puts("verbose flag is set, unset with option '--verbose'\n");

  /* Print any remaining command line arguments (not options). */
  if (optind < argc)
  {
    printf("non-option ARGV-elements: ");
    while (optind < argc)
      printf("%s ", argv[optind++]);
    putchar('\n');
  }

  if (outFile_flag){
    for (i = 0; i< max; i++){
      fprintf(stream,"%s\n", pattern);
    }
  
  fclose(stream);

  }
  else 
    for (i = 0; i< max; i++)
      printf("%s\n", pattern);

  return EXIT_SUCCESS;
}



