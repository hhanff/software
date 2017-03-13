#include <stdio.h>
#include <time.h>
#ifdef _MSC_VER // Windows
#include <windows.h>
#include <direct.h>
#include <process.h>
#else // Linux
#include <unistd.h>
#include <sys/stat.h>
//#include <sys/types.h>
#include <pthread.h>   /* Posix 1003.1c threads */
#endif /*_MSC_VER*/



void *stoppuhr(void *ch);

int weiter = 1,count = 0;

int main (int argc, char * argv[]){
  pthread_t thread1;
  char *message1 = "Thread 1";  
  int zahl;
  printf("\nBitte Zahl eingeben:    ");
  pthread_create( &thread1, NULL, stoppuhr, (void*) message1);
  scanf("%i", &zahl);
  weiter = 0;
  printf("\nNach %i Sekunden wurde %i eingegeben.", count, zahl);
  return 0;
}

void * stoppuhr(void * dummy){
  time_t start;
  char i = 0;
  while (weiter){

    if (i == 8){
      i = 0;
    }
    time(&start);
    if (i == 0){
      fprintf(stderr, "\b\b| ");
    }
    else if(i == 1){
      fprintf(stderr, "\b\b/ ");
    }
    else if(i == 2){
      fprintf(stderr, "\b\b- ");
    }
    else if(i == 3){
      fprintf(stderr, "\b\b\\ ");
    }
    else if(i == 4){
      fprintf(stderr, "\b\b| ");
    }
    else if(i == 5){
      fprintf(stderr, "\b\b/ ");
    }
    else if(i == 6){
      fprintf(stderr, "\b\b- ");
    }
    else if(i == 7){
      fprintf(stderr, "\b\b\\ ");
    }
    i ++;
    
//    printf("%3i",count);
    while(difftime(time(NULL),start)<1);
    count++;
  }
}
