#include <stdio.h>
#include <stdlib.h>

main (){
    ch  
    FILE *stream;
  char dateiname[67];
  int ch;
  printf("\nWelche Datei wollen Sie lesen? ");
  gets(dateiname);
  printf("\n");
  
  if((stream = fopen(dateiname,"r"))==NULL){
    printf("\nFEHLER!");
    fprintf(stderr, "\r\nError while opening %s\n",dateiname);
    exit(1);
  }
  
  ch = fgetc(stream);
  while(!feof(stream)){
    putchar(ch);
    ch = fgetc(stream);
  }
  
  fclose(stream);
  
}
