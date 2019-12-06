/* Author: Lucy Goodyear lucy.goodyear19@imperial.ac.uk
 * Script: composite_data_types.c
 * Desc: using structs
 * Date: Dec 2019
 */

#include <stdlib.h>
#include <stdio.h>

struct listobj { // a structure to store an integer and a pointer to another listobj

    int data;
    struct listobj* next; // same as struct listobj *next;

};

void traverse_list(struct listobj* lobj);

void traverse_list(struct listobj* lobj)
{
    /* This function traverses a list recursively
     * and calls out the integer stored inside
     */

    if (lobj != NULL) {
        printf("int data: %i\n", (*lobj).data); // preorder execution
        traverse_list((*lobj).next);
        printf("int data: %i\n", (*lobj).data); // postorder execution
    }
}

int main (void)
{

    // create 3 instances of listobj
    struct listobj l1;
    struct listobj l2;
    struct listobj l3;
    struct listobj l4;

    int intarray[3] = {10, 21, 33};

    l1.data = 10; // the '.' is the member selection option
    l2.data = 21;
    l3.data = 33;
    l4.data = 41;

    l1.next = &l2;
    l2.next = &l3;
    l3.next = NULL;

    // looped through a linked list
    struct listobj* p = NULL;
    p = &l1;

    // first look at member selection via a pointer
    int data = 0;
    data = (*p).data;
    // a nicer way of doing this (because it is done so often in c, it has its own syntax):
    data = p->data;

    // let's leverage this to do some looping

    while (p != NULL) {
        printf("Data in p: %i\n", (*p).data);
        p = p->next;
    }

    // let's traverse the list recursively using a function
    printf("Traversing recursively:\n");
    traverse_list(&l1);

    printf("\n");

    // insert a new element

    l4.next = &l2;
    l1.next = &l4;

    p = &l1;
    while (p != NULL) {
        printf("Data in p: %i\n", (*p).data);
        p = p->next;
    }

    // let's traverse the list recursively using a function
    printf("Traversing recursively:\n");
    traverse_list(&l1);

    printf("\n");

    return 0;

}