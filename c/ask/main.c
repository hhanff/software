//-------------------------------------------------------------------------------
//-- Title       : ask
//-- Project     : 
//-- Library:    : 
//-------------------------------------------------------------------------------
//-- File name   : main.c
//-- Author      : hhanff
//-- Company     : 
//-- Last update : 
//-- Platform    : 2010-02-19
//-------------------------------------------------------------------------------
//-- Purpose     : ask is a program to train e.g. vocabulary
//-------------------------------------------------------------------------------
//-- Assumptions : 
//-- Limitations :
//-- Known Errors:
//-- Notes       : 
//-- To Do       : - Implement the --name functionality
//--             : - Implement a random function
//--             : - Implement a function which lets you train the words in both 
//--                 directions
//--               - Eine Option einfügen die den Delimiter zwischen den Wörtern verändert
//--               - Einbauen dass nach einem LF sWord_1 und sWord_2 neu beschrieben werden.
//--               - Scoring einbauen
//--               - Eine Art lernkurve einbauen die nicht gewußte Wörter öfter wiederholt als Wörter die schon einmal richtig beantwortet wurden
//-------------------------------------------------------------------------------
//-- Revisions   :
//-- Date        Version  Author          Description
//-- 2010-02-19  1.0      Hendrik Hanff	Created
//-------------------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>

/* Flag set by ‘--verbose’. */
static int verbose_flag;

int main (argc, argv)
     int argc;
     char **argv;
{
  int c;
  char const sVersion[12] = "0.0.1";
  unsigned char sWord_1[64], sWord_2[64];
  unsigned char sUserSolution[64];
  unsigned char cTabFlag = 0;
  
  FILE *fopen(), *db_pointer = NULL;
  int cCharacter;
  unsigned int iCharCount = 0;

  typedef enum {
    STATE_READ_WORD_1 = 1, 
    STATE_READ_WORD_2, 
    STATE_ASK_QUESTION, 
    STATE_ANSWER_CORRECT, 
    STATE_ANSWER_INCORRECT,
    STATE_FINISHED
  } STATES;

  int state = STATE_READ_WORD_1;

  while (1)
    {
      static struct option long_options[] =
        {
          /* These options set a flag. */
          {"verbose", no_argument,       &verbose_flag, 1},
          {"file",    required_argument, 0, 'f'},
          {"help",    no_argument      , 0, 'h'},		  
          {"name",    required_argument, 0, 'n'},		  
		      {"version", no_argument	     , 0, 'v'},
          {0, 0, 0, 0}
        };
      /* getopt_long stores the option index here. */
      int option_index = 0;

      c = getopt_long (argc, argv, "f:hn:v",
                       long_options, &option_index);

      /* Detect the end of the options. */
      if (c == -1)
        break;

      switch (c)
        {
        case 0:
          /* If this option set a flag, do nothing else now. */
          if (long_options[option_index].flag != 0)
            break;
          printf ("option %s", long_options[option_index].name);
          if (optarg)
            printf (" with arg %s", optarg);
          printf ("\n");
          break;

        case 'f':
          db_pointer = fopen(optarg,"r");        
//          printf ("option -f with value `%s'\n", optarg);
          break;
        case 'h':
          puts("Report bugs to: hendrik.hanff@gmx.de");
//          puts("pkg home page: <http://www.gnu.org/software/pkg/>");
          puts("General help using GNU software: <http://www.gnu.org/gethelp/>");
          puts("Usage: ask parameters");
          puts("getopt [options] [--] ask parameters");
//          puts("getopt [options] -o|--options optstring [options] [--]");
          puts("parameters");
          puts("-h, --help                   This small usage guide");
          puts("-v, --version                Output version information");
          break;          
        case 'n':
          printf ("Enter a name to store your db.");
          break;
        case 'v':
          printf("GNU ask %s \n",sVersion);
          puts("Copyright (C) 2010 Free Software Foundation, Inc.");
          puts("License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>");
          puts("This is free software: you are free to change and redistribute it.");
          puts("There is NO WARRANTY, to the extent permitted by law.");
          break;
        case '?':
          /* getopt_long already printed an error message. */
          break;


        default:
          abort ();
        }
    }
  /* Instead of reporting ‘--verbose’
  and ‘--brief’ as they are encountered,
  we report the final status resulting from them. */
  if (verbose_flag)
    puts ("verbose flag is set");

  /* Print any remaining command line arguments (not options). */
  if (optind < argc)
    {
      printf ("non-option ARGV-elements: ");
      while (optind < argc)
        printf ("%s ", argv[optind++]);
        putchar ('\n');
    }

   // Main 
   if (db_pointer != NULL) {
     while (cCharacter!= EOF)
     {

       // Ask the question
       switch (state) 
       {
         // Read Word 1
         case (STATE_READ_WORD_1):
    	  	 cCharacter = getc(db_pointer);
           if (cCharacter == 9) {  //ASCII 9 = Tab
             state = STATE_READ_WORD_2;
             iCharCount = 0;          
             }
           sWord_1[iCharCount] = cCharacter;
           iCharCount += 1;
           if (iCharCount > 64){ // Abort if too many characters in a word
             puts("Too many characters in string.");
             exit (1);
           }
           puts (sWord_1);
         // Read Word 2
         case (STATE_READ_WORD_2): //ASCII 9 = Tab
    	  	 cCharacter = getc(db_pointer);         
           if (cCharacter == 13)  {
             state = STATE_ASK_QUESTION;
             iCharCount = 0;           
           }
           sWord_2[iCharCount] = cCharacter;
           iCharCount += 1;
           cTabFlag = 2;
           if (iCharCount > 64){ // Abort if too many characters in a word
             puts("Too many characters in string.");
             exit (1);
           }
         case (STATE_ASK_QUESTION)://ASCII 9 = Tab
           printf("%s ? ",sWord_1);
           scanf("%s", sUserSolution);
           if (strcmp(sWord_2, sUserSolution) == 0){ 
            puts("True");
            }
           else
            printf("User Solution: %s -> ", sUserSolution);
            puts("False");
            puts(sWord_2);
            bzero(sWord_1, strlen(sWord_1)); // clear string
            iCharCount = 0;
            cTabFlag = 0;
           }
     } 
     sWord_1[iCharCount-1] = ' ';  // Warum wird hier noch so ein komsiches Zeichen angehängt???
     puts(sWord_1);
     fclose(db_pointer);
   }

    
  exit (0);
}


   
