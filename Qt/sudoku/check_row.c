#include <stdio.h>
#include <stdlib.h>
#include "check_row.h"

void check_row(int *sudoku_p, int *temp1_p)
{
    // Teste welche Zahlen in der Zeile vorkommen
    // Schreibe die vorkommendenn  Zahlen in temp1_p
    int k;

    for (k = 0; k < SIZE; k++)	// Zeilen 
    {
        if (*(sudoku_p) == k+1) {
            *(temp1_p+k) = k+1;
        } 

        // Alternativ:
        //         else if (*(sudoku_p+((k*SIZE)+j)) == 9) {
        //            *(temp1_p+8) = 9;        
    }
    
}
