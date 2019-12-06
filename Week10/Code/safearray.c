/* Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
 * Script: safearray.c
 * Desc: allocating and freeing memory and using structs
 * Date: Dec 2019
 */

#include <stdlib.h>
#include <stdio.h>

struct intvec {
    size_t nelems;
    int*   data;
};

typedef struct intvec intvec_t; // you can now write intvec_t instead of struct intvec (it is an alias)

intvec_t *new_intvec(size_t nelems)
{
    intvec_t* newvec = NULL;

    newvec = (intvec_t*)calloc(1, sizeof(intvec_t));

    if (newvec != NULL) {
        // set the viurtual array bounds:
        newvec->nelems = nelems;
        // allocate the memory for the virtual array:
        newvec->data = (int*)calloc(nelems, sizeof(intvec_t));
        // check that the data was fully allocated
        if (newvec->data == NULL) {
            // if it failed, clean up resources and exit the function, returning NULL
            free(newvec);
            return NULL;
        }
    }

    return newvec;
}

void delete_intvec(intvec_t* ints)
{
    // always check that the pointer to memory being freed is non-NULL
    if (ints != NULL) {
        if (ints->data != NULL) {
            free(ints->data);
        }
        free(ints);
    }
}

/* this function sets data in the intvec at a particular position; returns 0 if success
 * and returns -1 if failed (i.e. out of bounds)
 */

int set_data(int data, int index, intvec_t* ints)
{
    if (index >= ints->nelems) {
        return -1;
    }
    ints->data[index] = data;

    return 0;
}

/* this function gets data from a particular index in the intvec; returns 0 if success
 * and returns -1 if failed (i.e. out of bounds)
 */

int get_data(int* res, int index, intvec_t* ints)
{
    if (index < ints->nelems) {
        *res = ints->data[index];
        return 0;
    }
    return -1;
}

int main (void) 
{
    intvec_t *sppcounts = new_intvec(30);

    int i = 0;
    int val = 0;

    for (i = 0; i < sppcounts->nelems; ++i) {
        set_data(i + 3, i, sppcounts);
    }

    printf("All of the elements of sppcounts:\n");
    for (i = 0; i < sppcounts->nelems; ++i) {
        get_data(&val, i, sppcounts);
        printf("%i ", val);
    }

    printf("\n");

    int error = 0;

    error = get_data(&val, 50, sppcounts);

    if (error != 0) {
        printf("Error! Tried to read out of bounds!\n");
    }

    return 0;

}
