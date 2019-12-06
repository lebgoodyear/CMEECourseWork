/* Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
 * Script: pointers.c
 * Desc: using pointers
 * Date: Dec 2019
 */

#include <stdlib.h>
#include <stdio.h>

int main (void)
{
    int i  = 0;
    int j = 1;
    int *p = NULL;
    int *q = NULL;

    p = &i;
    q = &j;

    p = &i;

    printf("Value of i before indirection: %i\n", i);
    printf("Value of i via indirection: %i\n", *p);

    i = 4;
    *p = 5;

    printf("Value of i after indirection: %i\n", i);

    printf("Address of i using & operator: %p\n", &i);
    printf("Address of i reading p: %p\n", p);

    printf("Another way to read a pointer: %i\n", *(&i));

    printf("Arithmetic via pointers: %i\n", *p + *q);

    return 0;

}