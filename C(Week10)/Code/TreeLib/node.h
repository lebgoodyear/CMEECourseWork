#ifndef _NODE_H_ // avoids multiple inclusions
#define _NODE_H_

// type def to save keystrokes
// typedef <known type> <new alias>
typedef struct _node node_t;
typedef struct _node {

    node_t *left;
    node_t *right;
    node_t *anc;
    int    tip;
    int    mem_index;
    char   *label; // e.g. the species name

} node_t;

void node_traverse(node_t* n);

#endif
