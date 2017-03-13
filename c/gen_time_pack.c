/**
 * @file   gen_time.c
 * @author Hendrik Hanff <hendrik.hanff@dfki.de>
 * @date   Mon May 16 14:13:14 2011
 * 
 * @brief  This program will 
 * @todo   - Add a switch to pass the runtime as an argument. When no runtime is passed, program shall
 *           terminate after one cycle
 *         - Adopt the output of stdout to the case when data is written to a file
 */
  
#include <stdio.h>
#include <string.h>
#include <argp.h>
#include <malloc.h>
#include <time.h>
// Needed for sleep();
#include <unistd.h>
#define NDEBUG
#include <assert.h>
#define DATE_LENGTH 24
// The time in seconds until a new file is generated
#define RUNTIME 60
#define DEFAULT_OUTPUT_FILE_NAME "gen_time_pack.vhd"
const char *argp_program_version =
    "gen_time_pack";

const char *argp_program_bug_address =
    "<hendrik.hanff@dfki.de>";


/* This structure is used by main to communicate with parse_opt. */
struct arguments
{
  char *args[1];            /* No arguments to this function */
  int verbose;              /* The -v flag */
  char *outfile;            /* Argument for -o */
};


/*
  OPTIONS.  Field 1 in ARGP.
  Order of fields: {NAME, KEY, ARG, FLAGS, DOC}.
*/
static struct argp_option options[] =
{
  {"verbose", 'v', 0, 0, "Produce verbose output"},

  {"output",  'o', "OUTFILE", 0,
   "Output to OUTFILE instead of to standard output"},

  {0}
};


/*
  PARSER. Field 2 in ARGP.
  Order of parameters: KEY, ARG, STATE.
*/
static error_t
parse_opt (int key, char *arg, struct argp_state *state)
{
  struct arguments *arguments = state->input;

  switch (key)
  {
    case 'v':
      arguments->verbose = 1;
      break;
    case 'o':
      arguments->outfile = arg;
      break;
    case ARGP_KEY_ARG:
      if (state->arg_num >= 10)
      {
        argp_usage(state);
      }
      arguments->args[state->arg_num] = arg;
      break;
    case ARGP_KEY_END:
      if (state->arg_num < 1)
      {
        // Enter things to be done at the end of input parsing here.
      }
      break;
    default:
      return ARGP_ERR_UNKNOWN;
  }
  return 0;
}


/*
  ARGS_DOC. Field 3 in ARGP.
  A description of the non-option command-line arguments
  that we accept.
*/
static char args_doc[] = "ARG";


/*
  DOC.  Field 4 in ARGP.
  Program documentation.
*/
static char doc[] =
    "gen_time_pack -- Ouput the current date and time into a vhdl package every 60 seconds\v.";

/*
  The ARGP structure itself.
*/
static struct argp argp = {options, parse_opt, args_doc, doc};

/*
  The main function.
*/
int main (int argc, char **argv){
  struct arguments arguments;
  FILE *save_stream;
  char *time_s;
  time_t sec = 0;
  time_t old_sec = 0;
  time(&old_sec);
  /* Set argument defaults */
  arguments.outfile = NULL;
  arguments.verbose = 0;

  /* Argument parsing */
  argp_parse (&argp, argc, argv, 0, 0, &arguments);
  while (1){
  time(&sec);
  
    /* Where do we send  the output? */
    if (arguments.outfile){
      save_stream = fopen (arguments.outfile, "w");

      fprintf(save_stream, "--! This package is auto-generated by %s\n", argv[0]);
      fprintf(save_stream, "--! %s was invoked by init.tcl\n", argv[0]);
      fprintf(save_stream, "--! Any changes will be lost with the run of the next\n");
      fprintf(save_stream, "--! synthesis\n");
      fprintf(save_stream, "--! If you want to use this file inside your design,\n");
      fprintf(save_stream, "--! include it via\n");
      fprintf(save_stream, "--! <code>\n");
      fprintf(save_stream, "--! > library work \n");
      fprintf(save_stream, "--! > use work.date_pack.all;\n");
      fprintf(save_stream, "--! </code>\n");
      fprintf(save_stream, "--! \n\n");
      fprintf(save_stream, "--! <small>\n");
      fprintf(save_stream, "--! Copyright (c): German Research Center for Artificial\n");
      fprintf(save_stream, "--! Intelligence (DFKI)\n");
      fprintf(save_stream, "--! Project: All\n");
      fprintf(save_stream, "--! </small>\n");
      fprintf(save_stream, "------------------------------------------------------------------------------\n");
      fprintf(save_stream, "\n");
      fprintf(save_stream, "library ieee;\n");
      fprintf(save_stream, "use ieee.std_logic_1164.all;\n");
      fprintf(save_stream, "use work.dfki_pack.all;\n");
      fprintf(save_stream, "\n");
      fprintf(save_stream, "package date_pack is\n");
      fprintf(save_stream, "  --! Synthesis time is stored here\n");
      fprintf(save_stream, "  constant SYNTH_TIMESTAMP_C : string(1 to 24) :=\"");
      time_s = ctime(&sec);
      fprintf(save_stream, "%.24s", time_s);
      fprintf(save_stream, "\";\n");
      fprintf(save_stream, "end package date_pack;\n\n");
     
      fclose(save_stream);
    }
    else{ // default output file name
      printf("--! This package is auto-generated by gen_time_pack.c\n");
      printf("--! Any changes will be lost with the run of the next\n");
      printf("--! synthesis via \n");
      printf("--! > ./gen_bit.sh\n");
      printf("--! If you want to use this file inside your design,\n");
      printf("--! include it via\n");
      printf("--! <code>\n");
      printf("--! > library work \n");
      printf("--! > use work.date_pack.all;\n");
      printf("--! </code>\n");
      printf("--! \n\n");
      printf("--! <small>\n");
      printf("--! Copyright (c): German Research Center for Artificial\n");
      printf("--! Intelligence (DFKI)\n");
      printf("--! Project: All\n");
      printf("--! </small>\n");
      printf("------------------------------------------------------------------------------\n");
      printf("\n");
      printf("library ieee;\n");
      printf("use ieee.std_logic_1164.all;\n");
      printf("use work.dfki_pack.all;\n");
      printf("\n");
      printf("package date_pack is\n");
      printf("  --! Synthesis time is stored here\n"); 
      printf("  constant SYNTH_TIMESTAMP_C : string(1 to 24) :=\"");
      time_s = ctime(&sec);
      printf("%.24s", time_s);
      printf("\";\n");
      printf("end package date_pack;\n\n");
    }
    /* while (difftime(sec, old_sec) < RUNTIME){ */
    /*   time(&sec); */
    /* } */
    sleep(60);
    //printf("Loop used %f seconds.\n", difftime(sec, old_sec));
    old_sec = sec;
  }
  return 0;
}