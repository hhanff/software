#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>

#include <math.h>

/*
  gcc -pedantic -Wall -W -Wmissing-prototypes -Wstrict-prototypes -Wconversion -Wshadow -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings -Wnested-externs -fshort-enums -fno-common -Dinline= -g -O2 -lm ntc_conversion.c -o ntc_conversion; ./ntc_conversion
*/


double get_temp(double adc_value){
#define TEMP_RESISTOR 3000
    double temp;

    /* adc_value=( 1.0 - (adc_value/4095.0)) ; //volt over R1 //voltage is normalized to 1 and not to 5V */
    /* adc_value=(1-adc_value) / (adc_value/TEMP_RESISTOR);//resistor value of temp sensor */

    temp=(-180.8*log(log(adc_value)))+401.42; /* calculate temperature from resistance */

    return temp;
}


double temperature_raw2deg(double adc_value)
{
    double const R25 = 3000;
    /* double const B25 = 3984.; */
    double const B25 = 3984.;
    double const T25 = 298.15;
    double const Tk2c = 273.15;

    /* double const adc_res = 4096.; */
    /* double const ub = 5.; */
    /* double const rser = 3000.; // Was 10k in V1 */

    /* Mask active bits of raw value */
    /* int16_t uAdcRaw = (adc_value & 0x0fff); */
    double Rntc = adc_value ;
    /* std::cout << "Raw telemetry temperature value=  " << uAdcRaw <<"\n"; */

    /*    double uadc = (double)(uAdcRaw)*ub/adc_res; */
    /* std::cout << "Uadc= " << uadc << "\n"; */
    /* double Rntc = (ub-uadc)/uadc*rser; // Circuitry changed from V1 toV2. Rntc was on hot end in V1. */
    /*    double Rntc = uadc/(ub-uadc)*rser; // Rntc is on cold end in V2. */
    /* std::cout << "Rntc= " << Rntc << "\n"; */
    double temp = 1/(((double)log((double)Rntc/(double)R25)/B25)+1/T25)-Tk2c;
    /* std::cout << "Temperature= " << temp << "\n\n"; */

    return temp;
}



int main(int argc, char **argv) {


    double i = 0;
    /* double a=202.23; */
    /* double b=3000; */
    /* double c= 5959.1; */
    /* double d=9787.3; */
    /* double e= 16565; */
    /* double f= 52840; */
    /* double g= 199251; */

    FILE * fp;
    FILE * fp_data;
    char * line = NULL;
    size_t len = 0;
    ssize_t read;



    fp_data = fopen("ntc_conversion_values_from_datasheet.dat", "r");
    fp = fopen("ntc_conversion_values.dat", "w");
    if (fp_data == NULL)
        exit(EXIT_FAILURE);


    fprintf(fp, "Resistance;Temp Roman;Temp Hendrik \n");
    for (i = 286132.0; i>55.0; i--) {
        /* if ((read = getline(&line, &len, fp_data)) != -1) { */
           /* line[strlen(line)-1] = 0; /\* Remove \n from line *\/ */
           fprintf(fp, "%3.5f;%3.5f;%3.5f,%s\n" ,i,get_temp(i), temperature_raw2deg(i),line);
        /*     } */
        /* else { */
        /*     fclose(fp_data); */
        /*     if (line) */
        /*         free(line); */
        /*     exit(EXIT_SUCCESS); */


        /* } */
    }



    return 0;
}
