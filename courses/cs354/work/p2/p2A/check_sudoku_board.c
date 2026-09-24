///////////////////////////////////////////////////////////////////////////////
// File:             check_sudoku_board.c
// Semester:         CS 354 Fall 2025
// 
// Author:           Xuming Huang
// Email:            xuming@cs.wisc.edu
// CS Login:         xuming
//
/////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Copyright 2021-25 Deb Deppeler
// Posting or sharing this file is prohibited, including any changes/additions.
// Shared with permission: Hina Mahmood (FALL 2025)
// We have provided comments and structure for this program to help you get 
// started. Later programs will not provide the same level of commenting,
// rather you will be expected to add the same level of comments to your work.
////////////////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *DELIM = ",";  // commas ',' are a common delimiter character for data strings

/* Returns 1 if and only if the 2D array of ints in board 
 * is in a valid Sudoku board state. Otherwise returns 0.
 *
 * DOES NOT PRODUCE ANY PRINTED OUTPUT
 * 
 * A valid row or column contains only blanks or the digits 1-size, 
 * with no duplicate digits, where size is the value 1 to 9.
 * 
 * Note: This function only requires that each row and each column are valid.
 * 
 * board: heap allocated 2D array of integers 
 *  size: number of rows and columns in the board
 */
int valid_sudoku_board(int **board, int size) {
    // Create a all-zero set for detecting duplicates
    int *set = (int *)calloc(size + 1, sizeof(int));
    if (set == NULL) exit(1);
    // Check rows
    for (int i = 0; i < size; i++) {
        int *row = *(board + i);
        for (int j = 0; j < size; j++) {
            int index = *(row + j);
            if (!index) continue;
            else if (index < 0 || index > size || (*(set + index))) {
                free(set);
                return 0;
            } else *(set + index) = 1;
        }
        memset(set, 0, (size + 1) * sizeof(int));
    }

    // Check colums
    for (int j = 0; j < size; j++) {
        for (int i = 0; i < size; i++) {
            int index = *(*(board + i) + j);
            if (!index) continue;
            else if (index < 0 || index > size || (*(set + index))) {
                free(set);
                return 0;
            } else *(set + index) = 1;
        }
        memset(set, 0, (size + 1) * sizeof(int));
    }

    free(set);
    return 1;   
}    

/* COMPLETED (DO NOT EDIT)       
 * Read the first line of file to get the size of the board.
 * 
 * PRE-CONDITION #1: file exists
 * PRE-CONDITION #2: first line of file contains valid non-zero integer value
 *
 * fptr: file pointer for the board's input file
 * size: a pointer to an int to store the size
 *
 * POST-CONDITION: the integer whose address is passed in as size (int *) 
 * will now have the size (number of rows and cols) of the board being checked.
 */
void get_board_size(FILE *fptr, int *size) {      
    char *line = NULL;
    size_t len = 0;

    // 'man getline' to learn about <stdio.h> getline
    if ( getline(&line, &len, fptr) == -1 ) {
        printf("Error reading the input file.\n");
        free(line);
        exit(1);
    }

    char *size_chars = NULL;
    size_chars = strtok(line, DELIM); // 'man strtok' string tokenizer
    *size = atoi(size_chars);         // 'man atoi' alpha to integer
    free(line);                       // free memory allocated for line 
}


/* This program prints "valid" (without quotes) if the input file contains
 * a valid state of a Sudoku puzzle board with respect to rows and columns
 * only. It prints "invalid" (without quotes) if the input file is not valid.
 *
 * Usage: ./check_sudoku_board <input_filename>
 *
 * argc: the number of command line args (CLAs)
 * argv: the CLA strings, includes the program name
 *
 * Returns 0 if file exists and is readable.
 * Exit with any non-zero result if unable to open and read a given file.
 */
int main( int argc, char **argv ) {              

    // Check if number of command-line arguments is correct.
    if (argc != 2) {
        printf("Usage: ./check_sudoku_board <input_filename>\n");
        exit(1);
    }

    // Open the file 
    FILE *fp = fopen(*(argv + 1), "r");
    if (fp == NULL) {
        printf("Can't open file for reading.\n");
        exit(1);
    }

    // will store the board's size, number of rows and columns
    int size;

    // Call get_board_size to read first line of file as the board size.
    get_board_size(fp, &size);
    // Check the input size
    if (size < 1 || size > 9) {
        printf("invalid\n");
        fclose(fp);
        return 0;
    }

    // Dynamically allocate a 2D array for given board size.
    int **board = (int **)malloc(size * sizeof(int *));
    if (board == NULL) {
        fclose(fp);
        exit(1);
    }
    for (int i = 0; i < size; i ++) {
        int *row = (int *)malloc(size * sizeof(int));
        *(board + i) = row;
        if (row == NULL) {
            fclose(fp);
            for (int j = 0; j < i; j++) free(*(board + j));
            free(board);
            exit(1);
        }
    }


    // Read the remaining lines of the board data file.
    // Tokenize each line and store the values in your 2D array.
    char *line = NULL;
    size_t len = 0;
    char *token = NULL;
    for (int i = 0; i < size; i++) {

        // read the line
        if (getline(&line, &len, fp) == -1) {
            printf("Error while reading line %i of the file.\n", i+2);
            // I think we need free line here becasue it is allocated in getline
            free(line);
            exit(1);
        }

        token = strtok(line, DELIM); 

        // Store the row address which will be access in the loop
        int *row = *(board + i);

        for (int j = 0; j < size; j++) {
            // Initialize elements of your 2D array.
            *(row + j) = atoi(token); 
            token = strtok(NULL, DELIM);
        }
    }

    // Also free line here
    free(line);

    // Call valid_sudoku_board and print the appropriate
    // output depending on the function's return value.
    if (valid_sudoku_board(board, size)) printf("valid\n");
    else printf("invalid\n");

    // Free dynamically allocated memory.

    for (int i = 0; i < size; i++) {
        free(*(board + i));
    }
    free(board);

    //Close the file.
    if (fclose(fp) != 0) {
        printf("Error while closing the file.\n");
        exit(1);
    } 

    return 0;       
} // 202509

