// Test 16: Integration — thread pool submits BST operations as tasks
// Tests that both Part 1 (thread pool) and Part 2 (BST) work together correctly.
#include <stdio.h>
#include <stdlib.h>
#include <stdatomic.h>
#include <assert.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include "threadpool.h"
#include "bst.h"

#define NWORKERS   4
#define QUEUE_CAP  64
#define NKEYS      200

static void on_alarm(int sig) {
    (void)sig;
    fprintf(stderr, "TIMEOUT — possible deadlock\n");
    _exit(2);
}

typedef struct {
    bst_t *tree;
    int key;
    int value;
} insert_arg_t;

static void insert_task(void *arg) {
    insert_arg_t *a = (insert_arg_t *)arg;
    bst_insert(a->tree, a->key, a->value);
}

typedef struct {
    bst_t *tree;
    int key;
    int expected_value;
    atomic_int *failed;
} lookup_arg_t;

static void lookup_task(void *arg) {
    lookup_arg_t *a = (lookup_arg_t *)arg;
    int v = 0;
    if (bst_lookup(a->tree, a->key, &v) != 0 || v != a->expected_value) {
        atomic_store(a->failed, 1);
    }
}

static int count_locked_nodes(bst_node_t *node) {
    if (node == NULL) return 0;
    return (node->lock_count > 0 ? 1 : 0)
         + count_locked_nodes(node->left)
         + count_locked_nodes(node->right);
}

static int count_total_nodes(bst_node_t *node) {
    if (node == NULL) return 0;
    return 1 + count_total_nodes(node->left) + count_total_nodes(node->right);
}

int main(void) {
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = on_alarm;
    sigaction(SIGALRM, &sa, NULL);
    alarm(30);

    bst_t *tree = bst_init();
    assert(tree != NULL);

    // === Phase 1: submit insert tasks via thread pool ===
    threadpool_t *pool = threadpool_create(NWORKERS, QUEUE_CAP);
    assert(pool != NULL);

    insert_arg_t ins_args[NKEYS];
    for (int i = 0; i < NKEYS; i++) {
        ins_args[i].tree  = tree;
        ins_args[i].key   = i;
        ins_args[i].value = i * 7;
        threadpool_submit(pool, insert_task, &ins_args[i]);
    }

    // Destroy waits for all tasks to complete
    threadpool_destroy(pool);

    // Fine-grained check: inserts via pool must have used per-node locking
    int locked = count_locked_nodes(tree->root);
    int total  = count_total_nodes(tree->root);
    if (locked < 10) {
        fprintf(stderr, "FAIL: only %d/%d nodes have lock_count > 0 "
                "(expected per-node locking via NODE_LOCK)\n", locked, total);
        return 1;
    }

    // All keys must be present with correct values
    for (int i = 0; i < NKEYS; i++) {
        int v = 0;
        assert(bst_lookup(tree, i, &v) == 0);
        assert(v == i * 7);
    }

    // === Phase 2: submit lookup tasks via thread pool ===
    pool = threadpool_create(NWORKERS, QUEUE_CAP);
    assert(pool != NULL);

    atomic_int failed = 0;
    lookup_arg_t look_args[NKEYS];
    for (int i = 0; i < NKEYS; i++) {
        look_args[i].tree           = tree;
        look_args[i].key            = i;
        look_args[i].expected_value = i * 7;
        look_args[i].failed         = &failed;
        threadpool_submit(pool, lookup_task, &look_args[i]);
    }

    threadpool_destroy(pool);
    assert(failed == 0);

    bst_destroy(tree);
    printf("PASS\n");
    return 0;
}
