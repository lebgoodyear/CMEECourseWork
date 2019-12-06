/* Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
 * Script: malloc_calloc.c
 * Desc: using malloc and calloc
 * Date: Dec 2019
 */

#include <stdlib.h>
#include <stdio.h>

int main (void)
{
    int numsites = 30;
    int *sppcounts = NULL;

    // Allocate some memory using malloc
    // malloc returns a pointer of type void so we have cast it to be pointing to an int (this is not necessary in C but is in C++)
    sppcounts = (int*)malloc(numsites * sizeof(int)); // sizeof() operator makes the code portable
    // check that malloc succeeded and returned a valid pointer
    if (sppcounts == NULL) {
        printf("Insufficient memory for operation!\n");
        exit(1);
    }

    sppcounts [20] = 44;

    int i = 0;
    for (i = 0; i < numsites; ++i) {
        printf("Data in site %i is: %i\n", i, *(sppcounts +i)); // *(sppcounts +i) is equivalent to sppcounts[i]
    }

    // Free memory, return it to the system before overwriting the pointer to that memory:
    free(sppcounts); //any time you allocate memory you must free it afterwards (failing to do this leads to a memory leak)
    sppcounts = NULL;

    // calloc also returns a pointer of type void so we have cast it to be pointing to an int (this is not necessary in C but is in C++)
    sppcounts = (int*)calloc(numsites, sizeof(int)); // sizeof() operator makes the code portable

    sppcounts[20] = 44;

    for (i = 0; i < numsites; ++i) {
        printf("Data in site %i is: %i\n", i, *(sppcounts +i)); // *(sppcounts +i) is equivalent to sppcounts[i]
    }

    free(sppcounts);
    sppcounts = NULL;

    return 0;
}