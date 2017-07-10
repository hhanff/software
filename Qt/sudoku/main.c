// indent -kr main.c
// gcc -o sudoku.exe main.c print_sudoku.c check_row.c

// -g: debuggen
// gcc -g sudoku main.c print_sudoku.c

// -O: Optimierungsstufe 1
// gcc -O -o sudoku main.c print_sudoku.c 
// -O: Optimierungsstufe 2
// gcc -O2 -o sudoku main.c print_sudoku.c 

// TO DO:
// * Alles generisch machen, so dass die Kastengrösse als Kommandozeilenparameter übergeben werden kann.
// * Die Zeile while(sum != 405 ) generisch machen
// * Das Einlesen der Datei so gestalten, dass diese so eingegeben werden kann wie sie in der Zeitung steht. Oder besser gleich ein GUI machen.

#include <stdio.h>
#include <stdlib.h>

#include "main.h"
#include "print_sudoku.h"
#include "check_row.h"
#include "check_column.h"
#include "check_box.h"

int main(void)
{
    FILE* myfile;
    myfile = fopen("sudoku.txt", "r");
    if (!myfile)
    {
        puts("Datei sudoku.txt nicht vorhanden!\n");
        exit(0);
    }

    int sudoku[SIZE][SIZE];
    int i, j, k, l, m, n, o, p;
    int temp1[SIZE];
    int sum, step;
    int sudoku_p;
    int *temp1_p;

    // Reset von temp1
    for (i = 0; i < SIZE; i++) {
        temp1[i] = 0;
    }

    // Abfrage des Sudokus
    for (i = 0; i < SIZE; i++) {
        for (j = 0; j < SIZE; j++) {
            /*             
            sudoku[i][j] = 0;
            printf("Bitte geben Sie die %i. Zahl der %i. Zeile ein: ",
            j + 1, i + 1);
            scanf("%i", &sudoku[i][j]);
            */   
            fscanf(myfile, "%i", &sudoku[i][j]);
        }
    }
    sum = 0;
    step = 0;
    // Testen ob ein Kästchen leer ist
    while (sum != 405) {
        for (i = 0; i < SIZE; i++) {
            for (j = 0; j < SIZE; j++) {
                // Reset von temp1
                for (m = 0; m < SIZE; m++) {
                    temp1[m] = 0;
                }
                if (sudoku[i][j] == 0) {	// Ist eine Zehl == 0 ?
//                    printf("i = %i , j = %i\n", i, j  );

                    for (k = 0; k < SIZE; k++) {
//                        printf("k = %i, j = %i\n", k, j);
                        //printf("temp1 vorher =  %i %i %i %i %i %i %i %i %i \n", temp1[0], temp1[1], temp1[2], temp1[3], temp1[4], temp1[5], temp1[6], temp1[7], temp1[8]);
                        check_row(&sudoku[k][j], &temp1[0]);
                        //printf("temp1 nachher = %i %i %i %i %i %i %i %i %i \n", temp1[0], temp1[1], temp1[2], temp1[3], temp1[4], temp1[5], temp1[6], temp1[7], temp1[8]);
                        check_column(&sudoku[i][k], &temp1[0]);

                        check_box(i, j, p, l, &sudoku[0][0], &temp1[0]);
                        //puts("Test!");
                    }

                    // Teste ob in temp1 alle Zahlen bis auf eine
                    // vorhanden sind.
                    // Wenn ja, dann schreibe diese Zahl in das Kästchen
                    if (temp1[0] == 0 && temp1[1] != 0 && temp1[2] != 0 && temp1[3] != 0 && temp1[4] != 0 && temp1[5] != 0 && temp1[6] != 0 && temp1[7] != 0 && temp1[8] != 0)
                    sudoku[i][j] = 1;
                    else if (temp1[0] != 0 && temp1[1] == 0 && temp1[2] != 0 && temp1[3] != 0 && temp1[4] != 0 && temp1[5] != 0 && temp1[6] != 0 && temp1[7] != 0 && temp1[8] != 0)
                    sudoku[i][j] = 2;
                    else if (temp1[0] != 0 && temp1[1] != 0 && temp1[2] == 0 && temp1[3] != 0 && temp1[4] != 0 && temp1[5] != 0 && temp1[6] != 0 && temp1[7] != 0 && temp1[8] != 0)
                    sudoku[i][j] = 3;
                    else if (temp1[0] != 0 && temp1[1] != 0 && temp1[2] != 0 && temp1[3] == 0 && temp1[4] != 0 && temp1[5] != 0 && temp1[6] != 0 && temp1[7] != 0 && temp1[8] != 0)
                    sudoku[i][j] = 4;
                    else if (temp1[0] != 0 && temp1[1] != 0 && temp1[2] != 0 && temp1[3] != 0 && temp1[4] == 0 && temp1[5] != 0 && temp1[6] != 0 && temp1[7] != 0 && temp1[8] != 0)
                    sudoku[i][j] = 5;
                    else if (temp1[0] != 0 && temp1[1] != 0 && temp1[2] != 0 && temp1[3] != 0 && temp1[4] != 0 && temp1[5] == 0 && temp1[6] != 0 && temp1[7] != 0 && temp1[8] != 0)
                    sudoku[i][j] = 6;
                    else if (temp1[0] != 0 && temp1[1] != 0 && temp1[2] != 0 && temp1[3] != 0 && temp1[4] != 0 && temp1[5] != 0 && temp1[6] == 0 && temp1[7] != 0 && temp1[8] != 0)
                    sudoku[i][j] = 7;
                    else if (temp1[0] != 0 && temp1[1] != 0 && temp1[2] != 0 && temp1[3] != 0 && temp1[4] != 0 && temp1[5] != 0 && temp1[6] != 0 && temp1[7] == 0 && temp1[8] != 0)
                    sudoku[i][j] = 8;
                    else if (temp1[0] != 0 && temp1[1] != 0 && temp1[2] != 0 && temp1[3] != 0 && temp1[4] != 0 && temp1[5] != 0 && temp1[6] != 0 && temp1[7] != 0 && temp1[8] == 0)
                    sudoku[i][j] = 9;
                    

                }

//                print_sudoku(sudoku);
//                printf("\n");
                /*                        printf("temp1[0] = %i\n", temp1[0]);
                        printf("temp1[1] = %i\n", temp1[1]);
                        printf("temp1[2] = %i\n", temp1[2]);
                        printf("temp1[3] = %i\n", temp1[3]);
                        printf("temp1[4] = %i\n", temp1[4]);
                        printf("temp1[5] = %i\n", temp1[5]);
                        printf("temp1[6] = %i\n", temp1[6]);
                        printf("temp1[7] = %i\n", temp1[7]);
                        printf("temp1[8] = %i\n", temp1[8]); */
                //                    printf ("\ni = %i\nj = %i\ntemp1[0] = %i \ntemp1[1] = %i \ntemp1[2] = %i \ntemp1[3] = %i\ntemp1[4] = %i\ntemp1[5] = %i\ntemp1[6] = %i\ntemp1[7] = %i\ntemp1[8] = %i\n",i ,j , temp1[0], temp1[1], temp1[2], temp1[3], temp1[4], temp1[5], temp1[6], temp1[7], temp1[8]);
                //printf("\n");
                //printf("\n");
                
            }

            // Summe bilden
            sum = 0;
            for (k = 0; k < SIZE; k++)	// Zeilen 
            {
                for (l = 0; l < SIZE; l++)	// Spalten
                {
                    sum = sudoku[k][l] + sum;
                }
            }
            //            printf("\nsum = %i\n", sum);




        }

    }
    
    print_sudoku(sudoku);
    
    
    fclose(myfile);
    
    scanf("%i", &sudoku[i][j]);   
    return 0;
}
