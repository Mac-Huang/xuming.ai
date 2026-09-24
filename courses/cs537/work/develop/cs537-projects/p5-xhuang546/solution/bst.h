/*
 * bst.h
 *
 * DO NOT MODIFY THIS FILE.
 */

#ifndef BST_H
#define BST_H

#include <pthread.h>

typedef struct bst_node {
    int key;
    int value;
    unsigned int lock_count;   /* internal - do not modify directly */
    pthread_mutex_t lock;      /* per-node lock */
    struct bst_node *left;
    struct bst_node *right;
} bst_node_t;

typedef struct {
    bst_node_t *root;
    pthread_mutex_t lock;      /* tree-level lock - protects root pointer */
} bst_t;

/* Provided locking macros - use these for ALL per-node locking. */
#define NODE_LOCK(node)   do { pthread_mutex_lock(&(node)->lock); (node)->lock_count++; } while(0)
#define NODE_UNLOCK(node) pthread_mutex_unlock(&(node)->lock)

bst_t *bst_init(void);
void   bst_destroy(bst_t *tree);
int    bst_insert(bst_t *tree, int key, int value);
int    bst_lookup(bst_t *tree, int key, int *value);
int    bst_delete(bst_t *tree, int key);

#endif
