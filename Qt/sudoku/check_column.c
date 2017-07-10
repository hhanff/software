#include <stdio.h>
#include <stdlib.h>
#include "check_column.h"

void check_column(int *sudoku_p, int *temp1_p)
{                       
    // Teste welche Zahlen in der Spalte vorkommen
    // Schreibe die betreffendne Zahlen in temp1
    int k;

    for (k = 0; k < SIZE; k++)	// Zeilen 
    {
        {    if (*(sudoku_p) == k+1) {
                *(temp1_p+k) = k+1;
            } 

        }
    }
}
