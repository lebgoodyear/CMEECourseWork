#include "node.h"

#include <stdio.h>

void node_traverse(node_t* n)
{
    // printf("mem_index of node: %i\n", n->mem_index);

    if (n->tip != 0) {
        printf("%i", n->tip);
        return;
    }

    printf("(");

    node_traverse(n->left);
    printf(",");
    node_traverse(n->right);

    printf(")");

    return;
}