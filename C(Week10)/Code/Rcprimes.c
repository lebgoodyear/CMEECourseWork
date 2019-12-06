#include <R.h>
#include <Rdefines.h>
#include "countprimes.h"

// create the wrapper
SEXP count_primes_C_wrap(SEXP limit) // SEXP is a type of struct (actually a pointer so not declaring any memory)
{
    SEXP result;

    PROTECT(result = NEW_INTEGER(1)); // PROTECT instructs R garbage collection to leave this data alone

    int limit_c = 0;
    limit_c = *(INTEGER(limit)); //tells compiler to read the limit argument as a c-type integer

    int c_result = count_primes_C(limit_c);

    *(INTEGER(result)) = c_result;

    UNPROTECT(1); // otherwise you get a stack imbalance

    return result;
} 