#ifndef _NODE_H // avoids mulitple inclusions
#define _NODE_H

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

#endif
