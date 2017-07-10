#include "print_sudoku.h"
#include <stdio.h>
#include <stdlib.h>

void print_sudoku(int sudoku[SIZE][SIZE]){
    int n, o;
    for (n = 0; n < SIZE; n++) {
        printf("\n");
        for (o = 0; o < SIZE; o++) {
            printf("%i", sudoku[n][o]);
        }
    }
}
