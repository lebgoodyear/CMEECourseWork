/* Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
 * Script: pointer_ret.c
 * Desc: practice returning pointers
 * Date: Dec 2019
 */

#include <stdlib.h>
#include <stdio.h>

int *pos_first_odd(const int[], const unsigned long); // function prototype

int *pos_first_odd(const int *integers, const unsigned long size) // returns a pointer to an integer
{   
    int unsigned long c = 0;
    int *ret = NULL; // * is not actually part of the variable name

    // implementation code

    ret = (int*)integers; // cast means interpret this variable to be of this type (must be done carefully since can be used for anything)

    while ((*ret % 2) == 0 && c < size) {
        ret = ret + 1;
        ++c;
    }

    if (c == size) {
        --ret;
        if ((*ret % 2) != 0) {
            return NULL;
        }
        return NULL;
    } 

    return ret; // we can only return a pointer to an integer or it will crash
}

int main (void)
{
    int *res = NULL;    
    int intarray[] = {2, 4, 10, 21, 30};

    res = pos_first_odd(intarray, 5);

    printf("res now points to: %i\n", *res);

    *res = *res -1; // decrementing the value at res

    res = pos_first_odd(intarray, 5);
    if (res != NULL) { // any function that returns a pointer, always check for not null values
        printf("res now points to: %i\n", *res);
    }

}