// Test 15: Fine-grained locking verification via lock_count
// A global-lock solution never calls NODE_LOCK on individual nodes,
// so every node's lock_count stays 0 — instant fail.
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <assert.h>
#include <pthread.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include "bst.h"

#define NTHREADS   8
#define NKEYS      500
#define OPS        5000

static void on_alarm(int sig) {
    (void)sig;
    fprintf(stderr, "TIMEOUT\n");
    _exit(2);
}

static uint32_t xorshift32(uint32_t *state) {
    uint32_t x = *state;
    x ^= x << 13;
    x ^= x >> 17;
    x ^= x << 5;
    *state = x;
    return x;
}

typedef struct {
    bst_t *tree;
    pthread_barrier_t *bar;
    int tid;
} worker_args_t;

static void *mixed_worker(void *arg) {
    worker_args_t *a = (worker_args_t *)arg;
    uint32_t rng = (uint32_t)(0x9e3779b9u ^ (uint32_t)a->tid);
    pthread_barrier_wait(a->bar);

    for (int i = 0; i < OPS; i++) {
        int key = (int)(xorshift32(&rng) % NKEYS);
        int op  = (int)(xorshift32(&rng) % 100u);
        if (op < 50) {
            int v;
            (void)bst_lookup(a->tree, key, &v);
        } else if (op < 80) {
            (void)bst_insert(a->tree, key, key);
        } else {
            (void)bst_delete(a->tree, key);
        }
    }
    return NULL;
}

static void reset_lock_counts(bst_node_t *node) {
    if (node == NULL) return;
    node->lock_count = 0;
    reset_lock_counts(node->left);
    reset_lock_counts(node->right);
}

static int count_locked_nodes(bst_node_t *node) {
    if (node == NULL) return 0;
    int cnt = (node->lock_count > 0) ? 1 : 0;
    return cnt + count_locked_nodes(node->left) + count_locked_nodes(node->right);
}

static int count_total_nodes(bst_node_t *node) {
    if (node == NULL) return 0;
    return 1 + count_total_nodes(node->left) + count_total_nodes(node->right);
}

static unsigned long sum_lock_counts(bst_node_t *node) {
    if (node == NULL) return 0;
    return (unsigned long)node->lock_count
         + sum_lock_counts(node->left)
         + sum_lock_counts(node->right);
}

int main(void) {
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = on_alarm;
    sigaction(SIGALRM, &sa, NULL);
    alarm(30);

    bst_t *t = bst_init();
    assert(t != NULL);

    // Pre-populate tree
    for (int i = 0; i < NKEYS; i++) {
        bst_insert(t, i, i);
    }

    // Reset all lock_counts (single-threaded, safe)
    reset_lock_counts(t->root);

    // Run concurrent workload
    pthread_barrier_t bar;
    pthread_barrier_init(&bar, NULL, NTHREADS);
    pthread_t th[NTHREADS];
    worker_args_t args[NTHREADS];

    for (int i = 0; i < NTHREADS; i++) {
        args[i] = (worker_args_t){t, &bar, i};
        assert(pthread_create(&th[i], NULL, mixed_worker, &args[i]) == 0);
    }
    for (int i = 0; i < NTHREADS; i++) {
        pthread_join(th[i], NULL);
    }

    int total  = count_total_nodes(t->root);
    int locked = count_locked_nodes(t->root);
    unsigned long lock_sum = sum_lock_counts(t->root);

    pthread_barrier_destroy(&bar);
    bst_destroy(t);

    // Check 1: Total lock_count sum must be substantial.
    if (lock_sum < 10000UL) {
        fprintf(stderr, "FAIL: total lock_count sum = %lu "
                "(expected > 10000 for hand-over-hand locking)\n", lock_sum);
        return 1;
    }

    int threshold = total * 50 / 100;
    if (locked < threshold) {
        fprintf(stderr, "FAIL: only %d/%d nodes (%.0f%%) have lock_count > 0 "
                "(expected >= 50%% for per-node locking via NODE_LOCK)\n",
                locked, total, total > 0 ? 100.0 * locked / total : 0.0);
        return 1;
    }

    printf("PASS\n");
    return 0;
}
