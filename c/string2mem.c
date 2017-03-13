#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>

void usage(void)
{
    fprintf(stderr,
            "Usage: string2mem [options] <string>\n"
            "-o Offset in Bytes\n"
            "-f Filename for output file\n"
            "-d Prepend seconds since 1970-01-01 00:00:00 +0000 (UTC)"
            " as uint32_t\n"
            "-w Width in Bytes\n");
}

int main (int argc, char * const *argv)
{
  int offset = 0;
  int do_date = 0;
  int len;
  char *p, *q, *r;
  FILE *idfile = 0;
  char *id_name = 0;
  int bytes = 4;

  while(1) 
  {
      switch(getopt(argc, argv, "?hdf:o:w:"))
      {
      case -1:
          goto args_done;
      case 'd':
          do_date = 1;
          break;
      case 'o':
          offset = atoi(optarg);
          break;
      case 'f':
          id_name = optarg;
          break;
      case 'w':
          bytes = atoi(optarg);
          break;
      default:    
          usage();
      }
  }
  args_done:
  argc -= optind;
  argv += optind;
  if(argc < 0)  usage();
      
  if(!argv[0])
  {
      fprintf(stderr,"No string given\n");
      return 1;
  }

  if(bytes <=0)
  {
      fprintf(stderr,"Using 1 Byte instead of given %d", bytes);
      bytes = 1;
  }

  len = strlen(argv[0]);
 
  p = malloc(len +4);
  if (p == NULL)
  {
      fprintf(stderr,"Can't malloc\n");
      p = argv[0];
  }
  else
  {
      r = p;
      if(do_date)
      {
          time_t date = time(0);
          memcpy(p, &date, 4);
          r += 4;
          len += 4;
      }
      for (q = argv[0]; *q; r++, q++)
      {
          if (*q == '\\')
          {
              q++;
              len --;
              switch(*q)
              {
              case 'a':
                  *r = '\a';
                  break;
              case 'b':
                  *r = '\b';
                  break;
              case 't':
                  *r = '\b';
                  break;
              case 'n':
                  *r = '\n';
                  break;
              case 'v':
                  *r = '\v';
                  break;
              case 'f':
                  *r = '\f';
                  break;
              case 'r':
                  *r = '\r';
                  break;
              case '\\':
                  *r = '\\';
                  break;
              default:
                  *r = *q;
              }
          }
          else
              *r = *q;
      }
  }

  if(id_name)
      idfile = fopen(id_name, "w+");
  if(!idfile)
      idfile = stdout;
  if (idfile)
  {
      int i=0, j;
      if (offset)
      {
          for (i = 0; i<=offset-bytes; i+=bytes)
          {
              for(j=0; j<bytes; j++)
                  fprintf(idfile,"00");
              fprintf(idfile,"\n");
          }
      }
      for(i=i-offset; i<len; i+= bytes)
      {
          for(j = bytes-1; j >= 0; j--)
              fprintf(idfile,"%02hhx", 
                      ((i+j>=0) && (i<len-j))?p[i+j]:0);
          fprintf(idfile,"\n");
      }
      fclose(idfile);
  }
  return 0;
}
  
