#include "node.h"

#include <stdio.h>

void node_traverse(node_t* n)
{
    printf("mem_index of node: %i\n", n->mem_index);

    if (n->tip != 0) {
        return;
    }

    node_traverse(n->left);
    node_traverse(n->right);

    return;
}