// Test 7: Shutdown with pending tasks - all tasks complete
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include "threadpool.h"

static void on_alarm(int sig) { (void)sig; fprintf(stderr, "TIMEOUT\n"); _exit(2); }

static int counter = 0;
static pthread_mutex_t counter_lock = PTHREAD_MUTEX_INITIALIZER;

static void task_slow(void *arg) {
    (void)arg;
    usleep(50000);  // 50ms per task
    pthread_mutex_lock(&counter_lock);
    counter++;
    pthread_mutex_unlock(&counter_lock);
}

int main() {
    struct sigaction sa; memset(&sa,0,sizeof(sa)); sa.sa_handler=on_alarm;
    sigaction(SIGALRM,&sa,NULL); alarm(10);

    threadpool_t *pool = threadpool_create(2, 8);
    if (!pool) {
        fprintf(stderr, "threadpool_create failed\n");
        return 1;
    }

    // Submit 8 tasks that each take 50ms
    for (int i = 0; i < 8; i++) {
        threadpool_submit(pool, task_slow, NULL);
    }

    // Immediately destroy — tasks are still in queue / executing
    threadpool_destroy(pool);

    // All 8 must have completed before destroy returned
    if (counter != 8) {
        fprintf(stderr, "expected 8 tasks to complete, got %d\n", counter);
        return 1;
    }
    printf("completed %d\n", counter);
    return 0;
}
