/* Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
 * Script: vars2.c
 * Desc: using variables of different data types
 * Date: Dec 2019
 */

#include <stdio.h>

int main (void) {

    int a = 7; // you can do multiple declarations on single line, divided by commas, but this way is more readable and less error-prone
    int b = 2;
    float c = 0;
    int d = 0;
    int e = 0;

    c = 7.0/2;
    d = a/b;
    e = (float)7/2;

    printf("Result of literal expression: %f\n", c);
    printf("Result of variable expression: %i\n", d);
    printf("Result of literal expression passed into int: %i\n", e);

    return 0;

}