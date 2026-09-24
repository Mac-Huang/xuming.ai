// Test 14: Concurrent mixed workload — inserts + deletes + lookups
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdatomic.h>
#include <assert.h>
#include <pthread.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include "bst.h"

#define NINSERTERS 4
#define NDELETERS  2
#define NLOOKERS   2
#define PER        100

typedef struct {
    bst_t *tree;
    pthread_barrier_t *bar;
    int start;
    int end;
    int base_value;
    int failed;
} insert_args_t;

typedef struct {
    bst_t *tree;
    pthread_barrier_t *bar;
    int start;
    int end;
} delete_args_t;

typedef struct {
    bst_t *tree;
    pthread_barrier_t *bar;
    int key_min;
    int key_max;
    atomic_int *done;
} lookup_args_t;

static void on_alarm(int sig) {
    (void)sig;
    fprintf(stderr, "TIMEOUT — possible deadlock\n");
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

static void *insert_worker(void *arg) {
    insert_args_t *a = (insert_args_t *)arg;
    pthread_barrier_wait(a->bar);
    for (int k = a->start; k <= a->end; k++) {
        if (bst_insert(a->tree, k, a->base_value + k) != 0) {
            a->failed = 1;
            return NULL;
        }
    }
    return NULL;
}

static void *delete_worker(void *arg) {
    delete_args_t *a = (delete_args_t *)arg;
    pthread_barrier_wait(a->bar);
    for (int k = a->start; k <= a->end; k++) {
        (void)bst_delete(a->tree, k);
    }
    return NULL;
}

static void *lookup_worker(void *arg) {
    lookup_args_t *a = (lookup_args_t *)arg;
    uint32_t rng = 0xdeadbeefu;
    pthread_barrier_wait(a->bar);

    while (atomic_load(a->done) == 0) {
        uint32_t r = xorshift32(&rng);
        int key = a->key_min + (int)(r % (uint32_t)(a->key_max - a->key_min + 1));
        int v;
        (void)bst_lookup(a->tree, key, &v);
    }
    return NULL;
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
    alarm(15);

    bst_t *t = bst_init();
    assert(t != NULL);

    int total_threads = NINSERTERS + NDELETERS + NLOOKERS;

    pthread_t ins[NINSERTERS];
    insert_args_t ins_args[NINSERTERS];
    pthread_t del[NDELETERS];
    delete_args_t del_args[NDELETERS];
    pthread_t look[NLOOKERS];
    lookup_args_t look_args[NLOOKERS];

    pthread_barrier_t bar;
    pthread_barrier_init(&bar, NULL, (unsigned)total_threads);

    atomic_int done;
    atomic_init(&done, 0);

    // Inserters: 0→0-99, 1→100-199, 2→200-299, 3→300-399
    for (int i = 0; i < NINSERTERS; i++) {
        ins_args[i] = (insert_args_t){t, &bar, i * PER, i * PER + PER - 1, 20000, 0};
        assert(pthread_create(&ins[i], NULL, insert_worker, &ins_args[i]) == 0);
    }

    // Deleters: both try to delete keys 0-99
    for (int i = 0; i < NDELETERS; i++) {
        del_args[i] = (delete_args_t){t, &bar, 0, 99};
        assert(pthread_create(&del[i], NULL, delete_worker, &del_args[i]) == 0);
    }

    // Lookers: random lookups across entire range
    for (int i = 0; i < NLOOKERS; i++) {
        look_args[i] = (lookup_args_t){t, &bar, 0, NINSERTERS * PER - 1, &done};
        assert(pthread_create(&look[i], NULL, lookup_worker, &look_args[i]) == 0);
    }

    for (int i = 0; i < NINSERTERS; i++) {
        pthread_join(ins[i], NULL);
        assert(ins_args[i].failed == 0);
    }
    for (int i = 0; i < NDELETERS; i++) {
        pthread_join(del[i], NULL);
    }

    atomic_store(&done, 1);
    for (int i = 0; i < NLOOKERS; i++) {
        pthread_join(look[i], NULL);
    }

    // Fine-grained check: all operations must have used per-node locking
    int locked = count_locked_nodes(t->root);
    int total  = count_total_nodes(t->root);
    if (locked < 10) {
        fprintf(stderr, "FAIL: only %d/%d nodes have lock_count > 0 "
                "(expected per-node locking via NODE_LOCK)\n", locked, total);
        return 1;
    }

    // Keys 100-399 must be present (not targeted by deleters)
    for (int k = 100; k < NINSERTERS * PER; k++) {
        int v = 0;
        assert(bst_lookup(t, k, &v) == 0);
        assert(v == 20000 + k);
    }

    // Keys 0-99: may or may not be present depending on timing
    for (int k = 0; k < 100; k++) {
        int v = 0;
        int rc = bst_lookup(t, k, &v);
        if (rc == 0) {
            assert(v == 20000 + k);
        } else {
            assert(rc == -1);
        }
    }

    pthread_barrier_destroy(&bar);
    bst_destroy(t);
    printf("PASS\n");
    return 0;
}
