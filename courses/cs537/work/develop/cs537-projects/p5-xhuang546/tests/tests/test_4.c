// Test 4: Queue correctness - tasks are neither dropped nor executed twice
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include "threadpool.h"

static void on_alarm(int sig) { (void)sig; fprintf(stderr, "TIMEOUT\n"); _exit(2); }

typedef struct {
    int id;
    int *seen;
} task_arg_t;

static void task_mark_seen(void *arg) {
    task_arg_t *t = (task_arg_t *)arg;
    __sync_fetch_and_add(&t->seen[t->id], 1);
}

int main() {
    struct sigaction sa; memset(&sa,0,sizeof(sa)); sa.sa_handler=on_alarm;
    sigaction(SIGALRM,&sa,NULL); alarm(10);

    const int num_threads = 4;
    const int queue_capacity = 8;
    const int num_tasks = 200;

    threadpool_t *pool = threadpool_create(num_threads, queue_capacity);
    if (!pool) {
        fprintf(stderr, "threadpool_create failed\n");
        return 1;
    }

    int *seen = calloc((size_t)num_tasks, sizeof(int));
    task_arg_t *args = calloc((size_t)num_tasks, sizeof(task_arg_t));
    if (!seen || !args) {
        fprintf(stderr, "allocation failed\n");
        threadpool_destroy(pool);
        free(seen);
        free(args);
        return 1;
    }

    for (int i = 0; i < num_tasks; i++) {
        args[i].id = i;
        args[i].seen = seen;
        threadpool_submit(pool, task_mark_seen, &args[i]);
    }

    threadpool_destroy(pool);

    for (int i = 0; i < num_tasks; i++) {
        if (seen[i] != 1) {
            fprintf(stderr, "task %d executed %d times (expected 1)\n", i, seen[i]);
            free(seen);
            free(args);
            return 1;
        }
    }

    free(seen);
    free(args);
    printf("PASS\n");
    return 0;
}
