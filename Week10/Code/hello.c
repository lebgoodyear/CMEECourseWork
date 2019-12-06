/* Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
 * Script: hello.c
 * Desc: creating a main function that prints a statement
 * Date: Dec 2019
 */

#include <stdio.h>

int main (void) // void is a special keyword in C that means nothing so it is an empty placeholder here. Some compilers require this, you can leave it blank for others.
{
    /* a block comment opens with slash asterisk and allows
    multiple lines in a programme at any point,
    it is closed with */

    printf("Hello, CMEE 2019!\n"); // double slash can be used to comment in C, typically for in-line comments

    return 0; // all statements in C end with a mandatory semi-colon
}

// C is very flexible with whitespace: as long as semi-colons end statements, everything could be one line