# C Week Notes

## Basics 
/# are included at start of programme at top of file and refer to the standard library
define macros or tell it to find files
in this case, standard input-output header file, standrad functions such as printf
the way compilers behave depend on the standard being adhered to
e.g. doesn't specify what print f does without standard library

int main (void)
function delaration for main functionall c programmes ofr main function
all have a return type (int) and a same (main ) and parameter values (void) or maybe argument parameter values
tehn curly brackets


printf is standard c library function
takes a print formatted string, which is what the f means

prompt ends up on same line, whcih is to do wtih printf
printf allows a bunch of formatting keys so can use \n for a new line

return in the main function can be used to return values indicating error codes 
shell calls main so when main is finished, 0 is returned, 0 is the okay, no error return type

typically when you read c code, look for main function to follow programme

main is required for an executable programme but not neccessary otherwise

## C compilers
1. Preprocessor
- textual substitution
- perform constant artithmetic (ahead of time so not calculatated at run-time)
- rewrites the code, effectively, e.g. all relevant library stuff (stdio) was pasted into our C code
- strips comments

2. Compilers
- translates code to assembly and then to binary
- outputs object files (.o files, whcih are compiled code (in binary))

3. Linker
- creates an executable ".exe"
- links all relevant functions and symbols


Our C script (hello.c) used up 3 files:
- main source file you wrote (hello.c)
- header file that got copied into source file (stdio)
- some object file library that includes printf (.o)

linker sets up address to get printf function when called

## Data, Memory and Variables
Main basic data types:

Integral type:
- char: ASCII (character set)
- int: integer (storage of a particularly large number)

Floating point type:
- float: floating point (real numbers)
- double: double precision float

_Bool: boolean (0/1)

All these types really do is define the capacity required to store a datum of this type

a computer's word size - how many chuncks of ram it reads at a time (32bit vs 64 bit)

A *pointer* is a memory address.

Modifiers:
-signed
-unsigned
-long
-short

C is meant to be able to be run on any OS on any machine

different bit-wise representation: integrals have all values, for float, there are infinite
integral:
char - 1 byte (8bits)
int - 4 bytes (32bit), stores every value between 0 and 2.1 billion
2s complement is a way of interpretting binary calculations
first bit is for the sign

floating point type:
32 bit floating point number will have
first bit is sign
first 52 bits is exponent, then 11 bits is decimal (total 64 bits)
floats can stoe -0.00001 to 80 billion but does NOT store every value because there are inifitely many
so there is rounding error in floating point.

these two types are read differently
defines level of changabeliltiy at binary level (char can fit in int but int may not fit in char)

using integers is much much faster than floating points so this is a tip for optimisation.

A byte was specifically defined to store an ASCII character. It doesn't actually have to be 8 bits, we just define it that way.

-Wall means show all warnings and is a flag to be run from terminal, e.g. gcc -Wall var1.c

If you don't initialise a variable, it just gives you what was last at that random memory allocation (the one given to the programme by your OS as a space it can use)

## Data Types
Integral:
char
int
long int
unsigned int
long unsigned int
unsigned char
signed char
Bool

Floating point:
float
double
long double

Variables:
int x
char y
constant literal, e.g. int x = 0, where 0 is the constant literal, taken by compiler to be type int
                       char y = 'a', where 'a' is the constant literal (not variable)
Variables and constant literal are inferred to be of the same type, e.g. float z = 1 will be converted to 1.0
if we put int x = 1.5 ???

Arithmetic operations are similar to python or R


---------------------------------------------------------------------------------------------------------------

## Ancestral states and optimising data on trees

Parsimony - the prefered solution is always the simplest.

Informal parsimony:
Fitch downpass (postorder)
- contructs orelimary ancestral states
- if descendant branches have common states, reconstruction is intersection, otherwise union

Formal parsimony:
Sankoff method
- matrix of transformation "weights"
- score a tree by considering all possible reconstructions at every single node
- can have unordered or ordered parsimony (Fitch or Wagner)

## Bit-wise operations

A bit is set when it's equal to 1, unset equal to 0 (which is empty)

| bitwise OR (creates union of the two sets), only one has to be set for result to be set

& bit-wise AND (creates intersection of two sets), both have to be set for result to be set

^ exclusive or (XOR) sets a bit only when 1 bit is set to 1 (0,1 or 1,0)

\>> right shift (shifts values one place to the right)

<< left shift (shifts values one place to the left)

~ one's complement, sets all unset, unsets all set (does opposite)

see bitwise.c for examples using these operations

## Pointers

Stack is CPU's operational structure for running a programme.
A stack is a general data structure , it is the first in and the last out (filo)
(whereas a queue is last in and last out)
Each stack frame (created by every call of a function) has stack memory associated with it that gets wiped when the function is returned.
Stacks's memory size is limited.

Heap is loacted outsidethe CPU, in RAM. We need a pointer to access memory not currently in view.

A pointer (or reference) is an integer; it is an address of data, typically hexadecimal notation.

How to declare and use a pointer:
We have to give it a name and type: ```int *intptr;``` or ```int* intptr2:```
It is used like any other variable.
When declaring the pointer: the asterisk indicates that a pointer is being declared.
In a statement: The asterisk is an operator that performs an operation on a memory address, allowing us to access the data at that address.
We need to assign data to that pointer.
The pointer stores an integer.

e.g.
'''
int *intptr;
int i = 4;
intptr = &i \\ where &i evaluates to an address)
intptr = some hexidecimal number
*inptr == 4
*intptr = 0 \\ now i becomes 0
'''

In a declaration, compiler reads from variable to right then left then right etc.

e.g. '''int *intptrs[]''' this is an array of pointers pointing to integers
     '''int(*arrayptrs)[]''' this is a pointer to an array of integers


--------------------------------------------------------------------------------------------------------

## Structs

A struct is a structure containing different attributes of soemthing as one object (a way of grouping data).
Void is undefinied type (undefined about of memory).
Pointer to void (void*) means pointed to an undefined type.
void *malloc(size_t s) gives you the s bytes of data you asked for.

An array in c is not very flexible. You always need to specify the size and you cannot add data (you need a new array for this).
We can use a variable to deterine the size of the data thta we need.

A size_t data type is a unsignde long integer really.

Malloc doesn't clear the memory before it allocates it but calloc does.

Encapsulation is an object oriented programming idea where you hide a lot of the background code form the external user. All you need to do is export the function names in a header file and a indication of the existence of the struct and then just include that header file (get rid of main function). This is how you create a library in C.

when running code ```-c``` says skip the linking page (e.g. if you don't have a main function)
e.g. gcc -c tree.c





