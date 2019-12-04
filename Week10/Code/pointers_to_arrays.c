#include <stdlib.h>
#include <stdio.h>

int main (void)
{
    int integers[] = {2, 33, 4, 10, 11};
    int (*aintptr)[] = NULL; //a pointer to an array of integers
    int *aintptr2 = NULL; // a pointer to an integer

    aintptr = &integers;

    printf("The value at index 1 in intarray via indirection: %i\n", (*aintptr)[1]); // array operator takes precedent over pointer

    aintptr2 = integers; // because aintptr2 is an address of an integer, it just takes the first integer in the array

    printf("Dereferencing pointer to an array: %i\n", *aintptr2);

    printf("Get second value by pointer arithmetic: %i\n", *(aintptr2 + 1));
    printf("Get second value by array subscripting a pointer: %i\n", aintptr2 [1]);

    int *endofarray = NULL; // point to a specific value in array:

    endofarray = &integers[4]; //points to last element of array

    for (aintptr2 = integers; aintptr2 <= endofarray; ++aintptr2) {

        printf("%i ", *aintptr2);

    }

    printf("\n");

    return 0;
}