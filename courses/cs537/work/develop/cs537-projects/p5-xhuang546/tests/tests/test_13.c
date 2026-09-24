// Test 13: Concurrent correctness — lookups on pre-built tree + disjoint inserts
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <pthread.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include "bst.h"

#define NKEYS    100
#define NTHREADS 4
#define PER      100

typedef struct {
    bst_t *tree;
    pthread_barrier_t *bar;
    int *keys;
    int nkeys;
    int failed;
} lookup_args_t;

typedef struct {
    bst_t *tree;
    pthread_barrier_t *bar;
    int start;
    int end;
    int base_value;
    int failed;
} insert_args_t;

static void on_alarm(int sig) {
    (void)sig;
    fprintf(stderr, "TIMEOUT — possible deadlock\n");
    _exit(2);
}

static void *lookup_worker(void *arg) {
    lookup_args_t *a = (lookup_args_t *)arg;
    pthread_barrier_wait(a->bar);
    for (int i = 0; i < a->nkeys; i++) {
        int v = 0;
        if (bst_lookup(a->tree, a->keys[i], &v) != 0) { a->failed = 1; return NULL; }
        if (v != a->keys[i] * 2) { a->failed = 1; return NULL; }
    }
    return NULL;
}

static void *insert_worker(void *arg) {
    insert_args_t *a = (insert_args_t *)arg;
    pthread_barrier_wait(a->bar);
    for (int k = a->start; k <= a->end; k++) {
        if (bst_insert(a->tree, k, a->base_value + k) != 0) { a->failed = 1; return NULL; }
    }
    return NULL;
}

// Walk tree, reset all lock_counts to 0 (call before concurrent phase)
static void reset_lock_counts(bst_node_t *node) {
    if (node == NULL) return;
    node->lock_count = 0;
    reset_lock_counts(node->left);
    reset_lock_counts(node->right);
}

// Count nodes with lock_count > 0 (call after concurrent phase)
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
    alarm(15);

    bst_t *t = bst_init();
    assert(t != NULL);

    // --- Part 1: concurrent lookups on a pre-built tree ---
    int keys[NKEYS];
    for (int i = 0; i < NKEYS; i++) {
        keys[i] = i;
        assert(bst_insert(t, i, i * 2) == 0);
    }

    // Reset counts before concurrent phase
    reset_lock_counts(t->root);

    pthread_barrier_t bar1;
    pthread_barrier_init(&bar1, NULL, NTHREADS);
    pthread_t lth[NTHREADS];
    lookup_args_t largs[NTHREADS];

    for (int i = 0; i < NTHREADS; i++) {
        largs[i] = (lookup_args_t){t, &bar1, keys, NKEYS, 0};
        assert(pthread_create(&lth[i], NULL, lookup_worker, &largs[i]) == 0);
    }
    for (int i = 0; i < NTHREADS; i++) {
        pthread_join(lth[i], NULL);
        assert(largs[i].failed == 0);
    }
    pthread_barrier_destroy(&bar1);

    // Fine-grained check: lookups must have locked individual nodes
    int locked1 = count_locked_nodes(t->root);
    int total1  = count_total_nodes(t->root);
    if (locked1 < 10) {
        fprintf(stderr, "FAIL (part 1): only %d/%d nodes have lock_count > 0\n",
                locked1, total1);
        return 1;
    }
    bst_destroy(t);

    // --- Part 2: concurrent inserts with disjoint key ranges ---
    t = bst_init();
    assert(t != NULL);

    pthread_barrier_t bar2;
    pthread_barrier_init(&bar2, NULL, NTHREADS);
    pthread_t ith[NTHREADS];
    insert_args_t iargs[NTHREADS];

    for (int i = 0; i < NTHREADS; i++) {
        iargs[i] = (insert_args_t){t, &bar2, i * PER, i * PER + PER - 1, 10000, 0};
        assert(pthread_create(&ith[i], NULL, insert_worker, &iargs[i]) == 0);
    }
    for (int i = 0; i < NTHREADS; i++) {
        pthread_join(ith[i], NULL);
        assert(iargs[i].failed == 0);
    }
    pthread_barrier_destroy(&bar2);

    // Fine-grained check: inserts must have locked individual nodes
    int locked2 = count_locked_nodes(t->root);
    int total2  = count_total_nodes(t->root);
    if (locked2 < 10) {
        fprintf(stderr, "FAIL (part 2): only %d/%d nodes have lock_count > 0\n",
                locked2, total2);
        return 1;
    }

    // Verify all keys present
    for (int k = 0; k < NTHREADS * PER; k++) {
        int v = 0;
        assert(bst_lookup(t, k, &v) == 0);
        assert(v == 10000 + k);
    }

    bst_destroy(t);
    printf("PASS\n");
    return 0;
}
