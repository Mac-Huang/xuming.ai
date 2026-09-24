//Test 1: Single task executes correctly (no stdout from worker threads)
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include "threadpool.h"

static void on_alarm(int sig) { (void)sig; fprintf(stderr, "TIMEOUT\n"); _exit(2); }

static int counter = 0;
static pthread_mutex_t counter_lock = PTHREAD_MUTEX_INITIALIZER;

static void task_increment(void *arg) {
    (void)arg;
    pthread_mutex_lock(&counter_lock);
    counter++;
    pthread_mutex_unlock(&counter_lock);
}

int main() {
    struct sigaction sa; memset(&sa,0,sizeof(sa)); sa.sa_handler=on_alarm;
    sigaction(SIGALRM,&sa,NULL); alarm(10);

    // Basic contract checks (should be obvious from the spec): invalid args
    // should fail cleanly (return NULL), not crash.
    if (threadpool_create(0, 4) != NULL) {
        fprintf(stderr, "expected NULL for num_threads=0\n");
        return 1;
    }
    if (threadpool_create(2, 0) != NULL) {
        fprintf(stderr, "expected NULL for queue_capacity=0\n");
        return 1;
    }
    if (threadpool_create(-1, 4) != NULL) {
        fprintf(stderr, "expected NULL for num_threads<0\n");
        return 1;
    }
    if (threadpool_create(2, -1) != NULL) {
        fprintf(stderr, "expected NULL for queue_capacity<0\n");
        return 1;
    }

    threadpool_t *pool = threadpool_create(2, 4);
    if (!pool) {
        fprintf(stderr, "threadpool_create failed\n");
        return 1;
    }

    if (threadpool_submit(pool, task_increment, NULL) != 0) {
        fprintf(stderr, "threadpool_submit returned non-zero on valid pool\n");
        return 1;
    }
    threadpool_destroy(pool);

    if (counter != 1) {
        fprintf(stderr, "expected 1 task to complete, got %d\n", counter);
        return 1;
    }

    printf("completed %d\n", counter);
    return 0;
}
