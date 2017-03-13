/* Für einen Punkt mit den kartesischen Koordinaten x, y (reelle Zahl) ist zu ermitteln, in welchem Quadranten (1,2,3,4) er sich befindet.  */
#include <stdio.h>

struct wertep{
  float x;
  float y;
} wertepaar;

int quadrant(struct wertep *wertepaar);

int main(int argc, char** argv){

  printf("Bitte den x-Wert eingeben: ");
  scanf("%f",&wertepaar.x);
  printf("Bitte den y-Wert eingeben: ");
  scanf("%f",&wertepaar.y);
  printf("Quadrant: %d\n",quadrant(&wertepaar));
  return 0;
  
}
int quadrant(struct wertep *wertepaar){

  if (wertepaar->x > 0 && wertepaar->y > 0){
    return 1;
  }
  else if (wertepaar->x > 0 && wertepaar->y < 0){
    return 2;
  }
  else if (wertepaar->x < 0 && wertepaar->y < 0){
    return 3;
  }
  else if (wertepaar->x < 0 && wertepaar->y > 0){
    return 4;
  }
  else{
    return 0;
  }
    

}



