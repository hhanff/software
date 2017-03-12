/*
  This program is meant to determine tap addresses for a concatenation
  of srl16es used as an enable pulse generator.
  It can be compiled by
  > gcc -std=c99 -lm -g -Wall -Wextra -pedantic srl16e.c -o srl16e
  The desired enable pulse frequency can be set by the constant
  desired_pulse_frequency.
  If the program finds an ideal set of tap addresses leading to the
  exact enable pulse frequency, it will terminate with
*/

#include "stdio.h"
#include "stdlib.h"
#include <math.h>

int srl16e(){
  const unsigned int clock_frequency = 20000000; // in Hertz
  const unsigned int desired_pulse_frequency = 1000;  // in Hertz
  // This is the factor which is needed to derive the desired_pulse_frequency
  unsigned int div = clock_frequency/desired_pulse_frequency;
  unsigned int div_temp = 0;
  int error = div;
  unsigned int i = 0;

  // Determin the amount of srl16 to instantiate for the desired pulse frequency
  unsigned int nr_of_srl16e = 0;
  while ( div > 0 )  {
    div /= 16;
    nr_of_srl16e += 1;
  }
  nr_of_srl16e += 1;

  printf("nr_of_srl16es = %d\n", nr_of_srl16e);
  // restore value:
  div = clock_frequency/desired_pulse_frequency;

  // Create an array which will contain the calculated tap addresses
  unsigned char tap_array[nr_of_srl16e];

  // Reset the array
  for(i = 0; i < nr_of_srl16e; i++){
    tap_array[i] = 0;
  }
  tap_array[0] = 0;

  while (pow(16.,(float)nr_of_srl16e) != 1.0*div_temp ) {
    // Determine the sum over the array
    div_temp = tap_array[0];
    for(i = 1; i < nr_of_srl16e; i++){
      div_temp = tap_array[i] * div_temp;
    }
    /* printf("div_temp = %d\n", div_temp); */

    /*
      if the new error is smaller than the old error:
      - Store the new error
      - Output the tap values
    */
    if(abs(error) > abs(div-div_temp)){
      error = div - div_temp;
      printf("new error = %d, div = %d, div_temp = %d \n", error, div, div_temp);
      for(i = 0; i < nr_of_srl16e ; i++){
        printf("tap %d = %d | ", i, tap_array[i]);
      }
      puts("");
      if (div_temp == div){
        puts("Ideal factors found:");
         for(i = 0; i < nr_of_srl16e ; i++){
           /*
             '-1' due to the fact that tap 0 is already an output in
           the srl16e
           */
           printf("tap_addr_i(%d) = %d \n", i, tap_array[i]-1);
         }
      return 0;
      }

    }

    unsigned int tap_array_temp = 0;

    // Concatenate the complete number
    for(i = 0; i < nr_of_srl16e; i++){
      tap_array_temp = tap_array_temp+(tap_array[i]<<(i*4));
    }
    /* printf("tap_array_temp = %d \n", tap_array_temp); */
    tap_array_temp += 1;

    for(i = 0; i < nr_of_srl16e; i++){
      tap_array[i] = (tap_array_temp>>(i*4));
      tap_array[i] &= 15;
    }


  } //while
  return 0;

}

int main()
{
  srl16e();
  return 0;
}
