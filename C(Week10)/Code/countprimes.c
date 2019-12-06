#include <stdlib.h>
#include <stdio.h>

int count_primes_C(int limit)
{
    int prime = 1;
    int divisor = 2;
    int is_prime = 0;
    int n_primes = 0;

    while (prime < limit) {
        is_prime = 0;

        for (divisor = 2; divisor <= prime / 2; ++divisor){
            if (prime % divisor == 0) {
                is_prime = 1;
                break;
            }
        }

        if (is_prime == 0) {
            ++n_primes;
        }

        ++prime;
    }

    return n_primes;
}

// run main programme to check it behaves as expected - not needed for a library
/*
int main (void) 
{
    printf("Number of primes in 0 - 10: %i\n", count_primes_C(10));
    printf("Number of primes in 0 - 100: %i\n", count_primes_C(100));
    printf("Number of primes in 0 - 1000: %i\n", count_primes_C(1000));
    printf("Number of primes in 0 - 10000: %i\n", count_primes_C(10000));
    printf("Number of primes in 0 - 100000: %i\n", count_primes_C(100000));
}
*/