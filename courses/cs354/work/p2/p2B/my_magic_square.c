////////////////////////////////////////////////////////////////////////////////
// Main File:        my_magic_square
// This File:        my_magic_square
// Other Files:      None
// Semester:         CS 354 Lecture 001 Fall 2025
// Grade Group:      gg__10
// Instructor:       Dr. Hina Mahmood
// 
// Author:           Xuming Huang
// Email:            xuming@cs.wisc.edu
// CS Login:         xuming
//
//////////////////// REQUIRED -- OTHER SOURCES OF HELP ///////////////////////// 
// Persons:         None
//
// Online sources:  I searched for if I can use assert to replace if-exit statement
//                  and I found it's negative.
//
// AI chats:        None
//////////////////////////// 80 columns wide ///////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Copyright 2020 Jim Skrentny
// Posting or sharing this file is prohibited, including any changes/additions.
// Used by permission, CS354 FALL 2025, Hina Mahmood
////////////////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Structure that represents a magic square
typedef struct {
    int size;           // dimension of the square
    int **magic_square; // ptr to 2D heap array that stores magic square values
} MagicSquare;

/* Prompts the user for magic square's size, read size, and
 * check if it is an odd number >= 3 
 * If not valid size, display the required error message and exit
 *
 * return the valid number
 */
int getSize() {
    int size;

    fprintf(stdout, "Enter magic square's size (odd integer >=3)\n");
    fscanf(stdin, "%d", &size);

    if (size % 2 == 0) {
        fprintf(stderr, "Magic square size must be odd.\n");
        exit(1);
    } 

    if (size < 3) {
        fprintf(stderr, "Magic square size must be >= 3.\n");
        exit(1);
    }

    return size;   
} 

/* Creates a magic square of size n on the heap
 *
 * May use the Siamese magic square algorithm or alternative
 * algorithm that produces a valid magic square 
 *
 * n - the number of rows and columns
 *
 * returns a pointer to the completed MagicSquare struct
 */
MagicSquare *generateMagicSquare(int n) {
    MagicSquare *magicSquare = (MagicSquare *)malloc(sizeof(MagicSquare));
    if (!magicSquare) {
        fprintf(stderr, "Magic square allocation failed\n");
        exit(1);
    }

    // Allocate memory for array of row pointers
    int **square = (int **)malloc(n * sizeof(int *));
    if (!square) {
        free(magicSquare);
        fprintf(stderr, "Magic square allocation failed\n");
        exit(1);
    }
    for (int i = 0; i < n; i++) {
        int *row = (int *)calloc(n, sizeof(**square)); // sizeof(int)

        if (!row) {
            // Free previously allocated rows on failure
            for (int j = 0; j < i; j++) {
                free(*(square + j));
            }
            free(square);
            free(magicSquare);
            fprintf(stderr, "Magic square allocation failed\n");
            exit(1);
        }
        *(square + i) = row;
    }

    // Siamese
    int i = 0, j = n/2;

    // Place numbers 1 through n*n
    for (int k = 1; k <= n*n; k++) {
        *(*(square + i) + j) = k;

        // Calculate next position (up-right)
        int ni = (i - 1 + n) % n;
        int nj = (j + 1) % n;

        // Check if next position is already filled
        if (*(*(square + ni) + nj) != 0) {
            // If filled, move down instead
            i = (i + 1) % n;
        } else {
            // If empty, use the up-right position
            i = ni;
            j = nj;
        }
    }

    // Set struct members
    magicSquare->size = n;
    magicSquare->magic_square = square;
    return magicSquare;    
} 

/* Open a new file (or overwrite the existing file)
 * and write magic square values to the file
 * in a format specified in the assignment.
 *
 * See assignment for required file format.
 *
 * magic_square - the magic square to write to a file
 * filename - the name of the output file
 */
void fileOutputMagicSquare(MagicSquare *magic_square, char *filename) {
    FILE *ofp = fopen(filename, "w");
    if (!ofp) {
        fprintf(stderr, "Can't open output file %s\n", filename);
        exit(1);
    }

    int size = magic_square->size;
    if (fprintf(ofp, "%d\n", size) < 0) {
        fprintf(stderr, "Fail to write to %s\n", filename);
        exit(1);
    }

    int **square = magic_square->magic_square;
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            if (fprintf(ofp, "%d", *(*(square + i) + j)) < 0) {
                fprintf(stderr, "Fail to write to %s\n", filename);
                exit(1);
            }
            if (fprintf(ofp, j == (size - 1) ? "\n" : ",") < 0) {
                fprintf(stderr, "Fail to write to %s\n", filename);
                exit(1);
            }
        }
    }

    if(fclose(ofp) == EOF) {
        fprintf(stderr, "Fail to write to %s\n", filename);
        exit(1);
    }
}

/* Frees all dynamically allocated memory associated with a MagicSquare structure.
 * Deallocates in reverse order of allocation to prevent memory leaks.
 */
void freeMagicSquare(MagicSquare *magicSquare) {
    int size = magicSquare->size;
    int **square = magicSquare->magic_square;

    // Free each row of the 2D array
    for (int i = 0; i < size; i++) {
        free(*(square + i));
    }

    // Free the array of row pointers
    free(square);
    
    // Free the MagicSquare structure itself
    free(magicSquare);
}

/* Calls other functions to generate a magic square 
 * of the user-specified size and outputs the
 * created square to the output filename.
 * 
 * Add description of required CLAs here
 */
int main(int argc, char **argv) {
    // Check input arguments to get output filename
    if (argc <= 1) {
        fprintf(stderr, "Usage: %s <output_filename>\n", argv[0]);
        exit(1); 
    }
    char *filename = argv[1];

    // Get magic square's size from user
    int size = getSize();

    // Generate a magic square by correctly interpreting 
    //       the algorithm(s) in the write-up or by writing on your own.  
    //       You must confirm that your program produces a 
    //       valid Magic Square. See the provided Wikipedia page link for
    //       description.
    MagicSquare *magicSquare = generateMagicSquare(size);

    // Output the magic square
    fileOutputMagicSquare(magicSquare, filename);

    freeMagicSquare(magicSquare);

    return 0;
} 

// 202509


