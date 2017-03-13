#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define DEBUG 0

int main (int argc, char *argv[]){
  const float e = 2.71828183;
  FILE *stream;
  long double multiplyer = 0.5;
  int count = 0;
  char dateiname[6] = "tmp06";
  unsigned int ch1, ch2 = 0;
  unsigned int lotto_number = 0;
  unsigned int i = 0;
  long double lotto[50];
  if((stream = fopen(dateiname,"r"))==NULL){
    fprintf(stderr, "\r\nError while opening %s\n",dateiname);
    exit(1);
  }
  for (i = 0; i != 51; i++){
    lotto[i] = 1.0;
  }
  while(!feof(stream)){
    ch1 = fgetc(stream);
    if ((ch1 == '0') | (ch1 == '1') | (ch1 == '2') | (ch1 == '3') | (ch1 == '4') | (ch1 == '5') | (ch1 == '6') | (ch1 == '7') | (ch1 == '8') | (ch1 == '9')){
      count++;
      if (DEBUG){    
	if (count == 30){
	  return 0;
	}
      }
      
      switch(ch1)
	{
	case 48:
	  lotto_number = 0;
	  break;
	case 49:
	  lotto_number = 1;
	  break;
	case 50:
	  lotto_number = 2;
	  break;
	case 51:
	  lotto_number = 3;
	  break;
	case 52:
	  lotto_number = 4;
	  break;
	case 53:
	  lotto_number = 5;
	  break;
	case 54:
	  lotto_number = 6;
	  break;
	case 55:
	  lotto_number = 7;
	  break;
	case 56:
	  lotto_number = 8;
	  break;
	case 57:
	  lotto_number = 9;
	  break;
	default:
	  break;
	} 
      if (!feof(stream)){
	ch2 = fgetc(stream);
      }
      if ((ch2 == '0')| (ch2 == '1') | (ch2 == '2') | (ch2 == '3') | (ch2 == '4') | (ch2 == '5') | (ch2 == '6') | (ch2 == '7') | (ch2 == '8') | (ch2 == '9')){
	switch(ch2)
	  {
	  case 48:
	    lotto_number = lotto_number * 10 + 0;
	    break;
	  case 49:
	    lotto_number = lotto_number * 10 + 1;
	    break;
	  case 50:
	    lotto_number = lotto_number * 10 + 2;
	    break;
	  case 51:
	    lotto_number = lotto_number * 10 + 3;
	    break;
	  case 52:
	    lotto_number = lotto_number * 10 + 4;
	    break;
	  case 53:
	    lotto_number = lotto_number * 10 + 5;
	    break;
	  case 54:
	    lotto_number = lotto_number * 10 + 6;
	    break;
	  case 55:
	    lotto_number = lotto_number * 10 + 7;
	    break;
	  case 56:
	    lotto_number = lotto_number * 10 + 8;
	    break;
	  case 57:
	    lotto_number = lotto_number * 10 + 9;
	    break;
	  default:
	    break;
	  } 
      }

      switch(lotto_number)
	{
	case 1:
	  lotto[1] = lotto[1] - multiplyer;
	  break;
	case 2:
	  lotto[2] = lotto[2] - multiplyer;
	  break;
	case 3:
	  lotto[3] = lotto[3] - multiplyer;
	  break;
	case 4:
	  lotto[4] = lotto[4] - multiplyer;
	  break;
	case 5:
	  lotto[5] = lotto[5] - multiplyer;
	  break;
	case 6:
	  lotto[6] = lotto[6] - multiplyer;
	  break;
	case 7:
	  lotto[7] = lotto[7] - multiplyer;
	  break;
	case 8:
	  lotto[8] = lotto[8] - multiplyer;
	  break;
	case 9:
	  lotto[9] = lotto[9] - multiplyer;
	  break;
	case 10:
	  lotto[10] = lotto[10] - multiplyer;
	  break;
	case 11:
	  lotto[11] = lotto[11] - multiplyer;
	  break;
	case 12:
	  lotto[12] = lotto[12] - multiplyer;
	  break;
	case 13:
	  lotto[13] = lotto[13] - multiplyer;
	  break;
	case 14:
	  lotto[14] = lotto[14] - multiplyer;
	  break;
	case 15:
	  lotto[15] = lotto[15] - multiplyer;
	  break;
	case 16:
	  lotto[16] = lotto[16] - multiplyer;
	  break;
	case 17:
	  lotto[17] = lotto[17] - multiplyer;
	  break;
	case 18:
	  lotto[18] = lotto[18] - multiplyer;
	  break;
	case 19:
	  lotto[19] = lotto[19] - multiplyer;
	  break;
	case 20:
	  lotto[20] = lotto[20] - multiplyer;
	  break;
	case 21:
	  lotto[21] = lotto[21] - multiplyer;
	  break;
	case 22:
	  lotto[22] = lotto[22] - multiplyer;
	  break;
	case 23:
	  lotto[23] = lotto[23] - multiplyer;
	  break;
	case 24:
	  lotto[24] = lotto[24] - multiplyer;
	  break;
	case 25:
	  lotto[25] = lotto[25] - multiplyer;
	  break;
	case 26:
	  lotto[26] = lotto[26] - multiplyer;
	  break;
	case 27:
	  lotto[27] = lotto[27] - multiplyer;
	  break;
	case 28:
	  lotto[28] = lotto[28] - multiplyer;
	  break;
	case 29:
	  lotto[29] = lotto[29] - multiplyer;
	  break;
	case 30:
	  lotto[30] = lotto[30] - multiplyer;
	  break;
	case 31:
	  lotto[31] = lotto[31] - multiplyer;
	  break;
	case 32:
	  lotto[32] = lotto[32] - multiplyer;
	  break;
	case 33:
	  lotto[33] = lotto[33] - multiplyer;
	  break;
	case 34:
	  lotto[34] = lotto[34] - multiplyer;
	  break;
	case 35:
	  lotto[35] = lotto[35] - multiplyer;
	  break;
	case 36:
	  lotto[36] = lotto[36] - multiplyer;
	  break;
	case 37:
	  lotto[37] = lotto[37] - multiplyer;
	  break;
	case 38:
	  lotto[38] = lotto[38] - multiplyer;
	  break;
	case 39:
	  lotto[39] = lotto[39] - multiplyer;
	  break;
	case 40:
	  lotto[40] = lotto[40] - multiplyer;
	  break;
	case 41:
	  lotto[41] = lotto[41] - multiplyer;
	  break;
	case 42:
	  lotto[42] = lotto[42] - multiplyer;
	  break;
	case 43:
	  lotto[43] = lotto[43] - multiplyer;
	  break;
	case 44:
	  lotto[44] = lotto[44] - multiplyer;
	  break;
	case 45:
	  lotto[45] = lotto[45] - multiplyer;
	  break;
	case 46:
	  lotto[46] = lotto[46] - multiplyer;
	  break;
	case 47:
	  lotto[47] = lotto[47] - multiplyer;
	  break;
	case 48:
	  lotto[48] = lotto[48] - multiplyer;
	  break;
	case 49:
	  lotto[49] = lotto[49] - multiplyer;
	  break;
	default:
	  break;

	}
      if (DEBUG){
	printf("count = %i, lotto[49] = %Lf, lotto_number = %i\n", count ,lotto[49], lotto_number);
      }
      if (count % 6 == 0){
	if (DEBUG){
	  printf("\ncount = %i, multi = %1.30Lf lotto[49] = %Lf\n", count, multiplyer, lotto[49]);
	}
	/*	multiplyer = 0.5 * multiplyer;*/
	multiplyer = 1/(pow(e,count/6.0));
      }
    }
    if(count == 100){
      /*      return 0;*/
    }
  }
  
  fclose(stream);
  
  for (i = 1; i < 50; i++){
    printf("%1.30Lf\t[%i] \n", lotto[i], i);
  }
  return 0;
}
