// Test 8: Repeated create/destroy smoke test (catches deadlocks/leaks/hangs)
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
    sigaction(SIGALRM,&sa,NULL); alarm(30);

    const int iters = 50;
    const int tasks = 50;

    for (int iter = 0; iter < iters; iter++) {
        pthread_mutex_lock(&counter_lock);
        counter = 0;
        pthread_mutex_unlock(&counter_lock);

        threadpool_t *pool = threadpool_create(2, 4);
        if (!pool) {
            fprintf(stderr, "threadpool_create failed\n");
            return 1;
        }

        for (int i = 0; i < tasks; i++) {
            threadpool_submit(pool, task_increment, NULL);
        }

        threadpool_destroy(pool);

        if (counter != tasks) {
            fprintf(stderr, "iter %d: expected %d tasks, got %d\n", iter, tasks, counter);
            return 1;
        }
    }

    printf("PASS\n");
    return 0;
}
