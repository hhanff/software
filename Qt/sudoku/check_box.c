#include <stdio.h>
#include <stdlib.h>
#include "check_box.h"

void check_box(int i, int j, int p, int l, int *sudoku_p, int *temp1_p)
{                       
    //         else if (*(sudoku_p+((p*SIZE)+l)) == 9) {
    //            *(temp1_p+8) = 9;
    
    // Teste welche Zahlen in dem Kästchen vorkommen
    // 1. Kästchen
    if ((i >= 0 && i <= 2) && (j >= 0 && j <= 2)){
        for (p = 0; p <= 2; p++) {
            for (l = 0; l <= 2; l++) {
                //                       puts("TEST");
                if (*(sudoku_p+((p*SIZE)+l)) !=0){
                    if (*(sudoku_p+((p*SIZE)+l)) == 1) {
                        *(temp1_p+0) = 1;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 2) {
                        *(temp1_p+1) = 2;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 3) {
                        *(temp1_p+2) = 3;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 4) {
                        *(temp1_p+3) = 4;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 5) {
                        *(temp1_p+4) = 5;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 6) {
                        *(temp1_p+5) = 6;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 7) {
                        *(temp1_p+6) = 7;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 8) {
                        *(temp1_p+7) = 8;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 9) {
                        *(temp1_p+8) = 9;
                    }
                    
                }
            }

            
        }
    }
    else if ((i >= 0 && i <= 2) && (j >= 3 && j <= 5)){
        //                            puts("TEST");
        //                            printf ("\np = %i\nl = %i\n*(temp1_p+0) = %i \n*(temp1_p+1) = %i \n*(temp1_p+2) = %i \n*(temp1_p+3) = %i\n*(temp1_p+4) = %i\n*(temp1_p+5) = %i\n*(temp1_p+6) = %i\n*(temp1_p+7) = %i\n*(temp1_p+8) = %i\n",p ,l , *(temp1_p+0), *(temp1_p+1), *(temp1_p+2), *(temp1_p+3), *(temp1_p+4), *(temp1_p+5), *(temp1_p+6), *(temp1_p+7), *(temp1_p+8));                            
        for (p = 0; p <= 2; p++) {
            for (l = 3; l <= 5; l++) {

                if (*(sudoku_p+((p*SIZE)+l)) !=0){
                    if (*(sudoku_p+((p*SIZE)+l)) == 1) {
                        *(temp1_p+0) = 1;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 2) {
                        *(temp1_p+1) = 2;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 3) {
                        *(temp1_p+2) = 3;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 4) {
                        *(temp1_p+3) = 4;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 5) {
                        *(temp1_p+4) = 5;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 6) {
                        *(temp1_p+5) = 6;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 7) {
                        *(temp1_p+6) = 7;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 8) {
                        *(temp1_p+7) = 8;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 9) {
                        *(temp1_p+8) = 9;
                    }
                    
                }
            }
        }
    }
    else if ((i >= 0 && i <= 2) && (j >= 7 && j <= 8)){
        //                           puts("TEST");
        for (p = 0; p <= 2; p++) {
            for (l = 7; l <= 8; l++) {
                if (*(sudoku_p+((p*SIZE)+l)) !=0){
                    if (*(sudoku_p+((p*SIZE)+l)) == 1) {
                        *(temp1_p+0) = 1;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 2) {
                        *(temp1_p+1) = 2;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 3) {
                        *(temp1_p+2) = 3;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 4) {
                        *(temp1_p+3) = 4;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 5) {
                        *(temp1_p+4) = 5;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 6) {
                        *(temp1_p+5) = 6;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 7) {
                        *(temp1_p+6) = 7;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 8) {
                        *(temp1_p+7) = 8;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 9) {
                        *(temp1_p+8) = 9;
                    }
                    
                }
            }
        }

        
    }
    else if ((i >= 3 && i <= 5) && (j >= 0 && j <= 2)){
        //                            puts("TEST");
        for (p = 3; p <= 5; p++) {
            for (l = 0; l <= 2; l++) {
                if (*(sudoku_p+((p*SIZE)+l)) !=0){
                    if (*(sudoku_p+((p*SIZE)+l)) == 1) {
                        *(temp1_p+0) = 1;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 2) {
                        *(temp1_p+1) = 2;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 3) {
                        *(temp1_p+2) = 3;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 4) {
                        *(temp1_p+3) = 4;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 5) {
                        *(temp1_p+4) = 5;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 6) {
                        *(temp1_p+5) = 6;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 7) {
                        *(temp1_p+6) = 7;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 8) {
                        *(temp1_p+7) = 8;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 9) {
                        *(temp1_p+8) = 9;
                    }
                    
                }
            }

            
        }
    }
    else if ((i >= 3 && i <= 5) && (j >= 3 && j <= 5)){
        for (p = 3; p <= 5; p++) {
            for (l = 3; l <= 5; l++) {
                if (*(sudoku_p+((p*SIZE)+l)) !=0){
                    if (*(sudoku_p+((p*SIZE)+l)) == 1) {
                        *(temp1_p+0) = 1;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 2) {
                        *(temp1_p+1) = 2;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 3) {
                        *(temp1_p+2) = 3;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 4) {
                        *(temp1_p+3) = 4;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 5) {
                        *(temp1_p+4) = 5;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 6) {
                        *(temp1_p+5) = 6;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 7) {
                        *(temp1_p+6) = 7;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 8) {
                        *(temp1_p+7) = 8;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 9) {
                        *(temp1_p+8) = 9;
                    }
                    
                }
            }

            
        }
    }
    else if ((i >= 3 && i <= 5) && (j >= 7 && j <= 8)){
        for (p = 3; p <= 5; p++) {
            for (l = 7; l <= 8; l++) {
                if (*(sudoku_p+((p*SIZE)+l)) !=0){
                    if (*(sudoku_p+((p*SIZE)+l)) == 1) {
                        *(temp1_p+0) = 1;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 2) {
                        *(temp1_p+1) = 2;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 3) {
                        *(temp1_p+2) = 3;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 4) {
                        *(temp1_p+3) = 4;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 5) {
                        *(temp1_p+4) = 5;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 6) {
                        *(temp1_p+5) = 6;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 7) {
                        *(temp1_p+6) = 7;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 8) {
                        *(temp1_p+7) = 8;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 9) {
                        *(temp1_p+8) = 9;
                    }
                    
                }
            }
        }
    }

    else if ((i >= 6 && i <= 8) && (j >= 0 && j <= 2)){
        for (p = 6; p <= 8; p++) {
            for (l = 0; l <= 2; l++) {
                if (*(sudoku_p+((p*SIZE)+l)) !=0){
                    if (*(sudoku_p+((p*SIZE)+l)) == 1) {
                        *(temp1_p+0) = 1;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 2) {
                        *(temp1_p+1) = 2;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 3) {
                        *(temp1_p+2) = 3;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 4) {
                        *(temp1_p+3) = 4;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 5) {
                        *(temp1_p+4) = 5;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 6) {
                        *(temp1_p+5) = 6;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 7) {
                        *(temp1_p+6) = 7;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 8) {
                        *(temp1_p+7) = 8;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 9) {
                        *(temp1_p+8) = 9;
                    }
                    
                }
            }

            
        } 
    }    
    
    else if ((i >= 6 && i <= 8) && (j >= 3 && j <= 5)){
        for (p = 6; p <= 8; p++) {
            for (l = 3; l <= 5; l++) {
                if (*(sudoku_p+((p*SIZE)+l)) !=0){
                    if (*(sudoku_p+((p*SIZE)+l)) == 1) {
                        *(temp1_p+0) = 1;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 2) {
                        *(temp1_p+1) = 2;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 3) {
                        *(temp1_p+2) = 3;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 4) {
                        *(temp1_p+3) = 4;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 5) {
                        *(temp1_p+4) = 5;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 6) {
                        *(temp1_p+5) = 6;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 7) {
                        *(temp1_p+6) = 7;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 8) {
                        *(temp1_p+7) = 8;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 9) {
                        *(temp1_p+8) = 9;
                    }
                    
                }
            }

            
        } 
    }
    else if ((i >= 6 && i <= 8) && (j >= 6 && j <= 8)){
        for (p = 6; p <= 8; p++) {
            for (l = 6; l <= 8; l++) {
                if (*(sudoku_p+((p*SIZE)+l)) !=0){
                    if (*(sudoku_p+((p*SIZE)+l)) == 1) {
                        *(temp1_p+0) = 1;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 2) {
                        *(temp1_p+1) = 2;
                    } 
                    else if (*(sudoku_p+((p*SIZE)+l)) == 3) {
                        *(temp1_p+2) = 3;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 4) {
                        *(temp1_p+3) = 4;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 5) {
                        *(temp1_p+4) = 5;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 6) {
                        *(temp1_p+5) = 6;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 7) {
                        *(temp1_p+6) = 7;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 8) {
                        *(temp1_p+7) = 8;
                    }
                    else if (*(sudoku_p+((p*SIZE)+l)) == 9) {
                        *(temp1_p+8) = 9;
                    }
                    
                }
            }

            
        } 
    }
}
