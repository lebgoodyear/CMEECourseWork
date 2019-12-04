#include <stdio.h>

int main (void) 
{
    int x = 0;
    char a = '\0';
    char b = 0;
    char c = '0';

    // '0', 0 and '\0' as a char
    /*printf("As char: %c\n", a);
    printf("As char: %c\n", b);
    printf("As char: %c\n", c);*/

    // '0', 0 and '\0' as a int
    /*printf("As int: %i\n", a);
    printf("As int: %i\n", b);
    printf("As int: %i\n", c);*/

    x = 255;
    a = x;
    x = a;
    printf("255 passed through char back to int %u\n", x);

    x = 256;
    a = x;
    x = a;
    printf("256 passed through char back to int %u\n", x);
    
    return 0;
}