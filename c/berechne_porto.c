#include <stdio.h>
#include <stdlib.h>
/*
  Diese Programm berechnet Permutationen aus vorhandenen Briefmarken.
  Auf diese Weise kann ein gewünschter Briefmarkenwert aus gegeben
  Briefmarken zusammengesetzt werden.

  Aufruf des Programms:
  > a.out <gewuenschter Wert> | grep "= 4.10 EUR"  
  Wobei <gewünschter Wert> z.B. durch 4.10 für 4EUR10 ersetzt werden kann.
*/

int main(int argc, char *argv[]){
  const float postkarte  = 0.45;
  const float brief      = 0.55;
  const float grossBrief = 1.45;
  const float maxiBrief  = 2.20;

  const float zielPorto = atof(argv[1]);

  int i, j, k, l;


  for (i = 0; i < 10; i++){
    for (j = 0; j < 10; j++){
      for (k = 0; k < 10; k++){
        for (l = 0; l < 10; l++){
/*           printf("%f\n", zielPorto); */
          printf("Zielporto = %i * %.2f + %i * %.2f + %i * %.2f  + %i * %.2f = %.2f EUR\n",i, postkarte, j, brief, k, grossBrief, l, maxiBrief, (i*postkarte+j*brief+k*grossBrief+ l*maxiBrief));
/*           if (i*postkarte+j*brief+k*grossBrief+ l*maxiBrief == zielPorto){ */
/*           if (4.10000 == zielPorto){ */
/*             printf("Zielporto = %i * %.2f + %i * %.2f + %i * %.2f  + %i * %.2f = %.2f EUR\n",i, postkarte, j, brief, k, grossBrief, l, maxiBrief, (i*postkarte+j*brief+k*grossBrief+ l*maxiBrief)); */
/*           } */
        }
      }
    }
  }
  
  
  return 0;

}
