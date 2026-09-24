/*
 * bst.c Binary Search Tree
 *
 * TODO: Add fine-grained locking to make this thread-safe.
 *
 * The current implementations are correct sequential code but NOT thread-safe.
 * You must use the tree-level lock (tree->lock) and per-node locks via the
 * NODE_LOCK(node) / NODE_UNLOCK(node) macros to make these operations safe
 * for concurrent access.
 *
 * You may add static helper functions as needed.
 */

#include "bst.h"

#include <errno.h>
#include <stdlib.h>


//Node allocation / deallocation

static bst_node_t *bst_node_create(int key, int value) {
    bst_node_t *node = (bst_node_t *)malloc(sizeof(*node));
    if (node == NULL) {
        return NULL;
    }

    node->key = key;
    node->value = value;
    node->lock_count = 0;
    node->left = NULL;
    node->right = NULL;

    if (pthread_mutex_init(&node->lock, NULL) != 0) {
        free(node);
        return NULL;
    }

    return node;
}

//Free a node that is being physically removed from the tree.
static void bst_node_free(bst_node_t *node) {
    pthread_mutex_destroy(&node->lock);
    free(node);
}

//Tree init/destroy

bst_t *bst_init(void) {
    bst_t *tree = (bst_t *)malloc(sizeof(*tree));
    if (tree == NULL) {
        return NULL;
    }

    tree->root = NULL;
    if (pthread_mutex_init(&tree->lock, NULL) != 0) {
        free(tree);
        return NULL;
    }

    return tree;
}

//Called after all threads have joined - no locking needed.
static void bst_destroy_node(bst_node_t *node) {
    if (node == NULL) {
        return;
    }

    bst_destroy_node(node->left);
    bst_destroy_node(node->right);
    pthread_mutex_destroy(&node->lock);
    free(node);
}

void bst_destroy(bst_t *tree) {
    if (tree == NULL) {
        return;
    }

    bst_destroy_node(tree->root);
    pthread_mutex_destroy(&tree->lock);
    free(tree);
}

/*
 * Insert a key-value pair. Returns 0 on success, -1 on duplicate key
 * or allocation failure.
 */
int bst_insert(bst_t *tree, int key, int value) {
    if (tree == NULL) {
        errno = EINVAL;
        return -1;
    }

    pthread_mutex_lock(&tree->lock);

    if (tree->root == NULL) {
        bst_node_t *root = bst_node_create(key, value);
        if (root == NULL) {
            pthread_mutex_unlock(&tree->lock);
            return -1;
        }
        tree->root = root;
        pthread_mutex_unlock(&tree->lock);
        return 0;
    }

    bst_node_t *cur = tree->root;

    NODE_LOCK(cur);
    pthread_mutex_unlock(&tree->lock);

    while (1) {
        if (key == cur->key) {
            NODE_UNLOCK(cur);
            return -1;
        }

        if (key < cur->key) {
            if (cur->left == NULL) {
                bst_node_t *node = bst_node_create(key, value);
                if (node == NULL) {
                    NODE_UNLOCK(cur);
                    return -1;
                }
                cur->left = node;
                NODE_UNLOCK(cur);
                return 0;
            }
            bst_node_t *next = cur->left;
            NODE_LOCK(next);
            NODE_UNLOCK(cur);
            cur = next;
        } else {
            if (cur->right == NULL) {
                bst_node_t *node = bst_node_create(key, value);
                if (node == NULL) {
                    NODE_UNLOCK(cur);
                    return -1;
                }
                cur->right = node;
                NODE_UNLOCK(cur);
                return 0;
            }
            bst_node_t *next = cur->right;
            NODE_LOCK(next);
            NODE_UNLOCK(cur);
            cur = next;
        }
    }
}

//Look up a key. Returns 0 and writes *value on success, -1 if not found.
int bst_lookup(bst_t *tree, int key, int *value) {
    if (tree == NULL || value == NULL) {
        errno = EINVAL;
        return -1;
    }

    pthread_mutex_lock(&tree->lock);

    if (tree->root == NULL) {
        pthread_mutex_unlock(&tree->lock);        
        return -1;
    }
    
    bst_node_t *cur = tree->root;

    NODE_LOCK(cur);
    pthread_mutex_unlock(&tree->lock);

    while (1) {
        if (key == cur->key) {
            *value = cur->value;
            NODE_UNLOCK(cur);
            return 0;
        }

        bst_node_t *next = (key < cur->key) ? cur->left : cur->right;

        if (next == NULL) {
            NODE_UNLOCK(cur);
            return -1;
        }
        
        NODE_LOCK(next);
        NODE_UNLOCK(cur);

        cur = next;
    }
}

/*
 * Helper: handle the two-children case.
 *
 * Called with cur being the node whose key/value will be replaced.
 * Finds the in-order successor (leftmost node in right subtree), copies
 * its key/value into cur, then removes the successor.
 */
static void delete_two_children(bst_node_t *cur) {
    bst_node_t *succ_parent = cur;
    bst_node_t *succ = cur->right;

    NODE_LOCK(succ);

    while (succ->left != NULL) {
        bst_node_t *next = succ->left;
        NODE_LOCK(next);

        if (succ_parent != cur) {
            NODE_UNLOCK(succ_parent);
        }

        succ_parent = succ;
        succ = next;
    }

    /* Copy successor's data into the node being "deleted" */
    cur->key = succ->key;
    cur->value = succ->value;

    /* Remove successor. Successor has at most a right child. */
    if (succ_parent == cur) {
        succ_parent->right = succ->right;
    } else {
        succ_parent->left = succ->right;
    }

    NODE_UNLOCK(succ);
    bst_node_free(succ);

    if (succ_parent != cur) {
        NODE_UNLOCK(succ_parent);
    }
}

//Delete a key from the BST. Returns 0 on success, -1 if key not found.
int bst_delete(bst_t *tree, int key) {
    if (tree == NULL) {
        errno = EINVAL;
        return -1;
    }

    pthread_mutex_lock(&tree->lock);
    if (tree->root == NULL) {
        pthread_mutex_unlock(&tree->lock);
        return -1;
    }

    bst_node_t *cur = tree->root;

    NODE_LOCK(cur); 

    //Deleting the root node
    if (cur->key == key) {
        /* Leaf */
        if (cur->left == NULL && cur->right == NULL) {
            tree->root = NULL;
            pthread_mutex_unlock(&tree->lock);
            NODE_UNLOCK(cur);
            bst_node_free(cur);
            return 0;
        }

        //One child
        if (cur->left == NULL || cur->right == NULL) {
            tree->root = (cur->left != NULL) ? cur->left : cur->right;
            pthread_mutex_unlock(&tree->lock);
            NODE_UNLOCK(cur);
            bst_node_free(cur);
            return 0;
        }

        pthread_mutex_unlock(&tree->lock);

        //Two children
        delete_two_children(cur);
        NODE_UNLOCK(cur);
        return 0;
    }

    pthread_mutex_unlock(&tree->lock);

    //Step one level down from root so we have parent + cur.
    bst_node_t *parent = cur;
    int is_left;

    if (key < cur->key) {
        if (cur->left == NULL) {
            NODE_UNLOCK(cur);
            return -1;
        }
        cur = cur->left;
        NODE_LOCK(cur);
        is_left = 1;
    } else {
        if (cur->right == NULL) {
            NODE_UNLOCK(cur);
            return -1;
        }
        cur = cur->right;
        NODE_LOCK(cur);
        is_left = 0;
    }

    while (cur->key != key) {
        bst_node_t *next;
        if (key < cur->key) {
            next = cur->left;
            is_left = 1;
        } else {
            next = cur->right;
            is_left = 0;
        }

        if (next == NULL) {
            NODE_UNLOCK(cur);
            NODE_UNLOCK(parent);
            return -1;
        }

        NODE_LOCK(next);
        NODE_UNLOCK(parent);
        parent = cur;
        cur = next;
    }

    //Leaf: remove node, relink parent to NULL
    if (cur->left == NULL && cur->right == NULL) {
        if (is_left) parent->left = NULL;
        else         parent->right = NULL;

        NODE_UNLOCK(cur);
        NODE_UNLOCK(parent);
        bst_node_free(cur);
        return 0;
    }

    //One child: splice out cur, relink parent to cur's child
    if (cur->left == NULL || cur->right == NULL) {
        bst_node_t *child = (cur->left != NULL) ? cur->left : cur->right;
        if (is_left) parent->left = child;
        else         parent->right = child;
        NODE_UNLOCK(cur);
        NODE_UNLOCK(parent);
        bst_node_free(cur);
        return 0;
    }

    NODE_UNLOCK(parent);

    //Two children: delegate to helper
    delete_two_children(cur);
    NODE_UNLOCK(cur);
    return 0;
}
