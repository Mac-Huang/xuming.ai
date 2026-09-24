// Test 5: Tasks submitted after pool starts — workers wake and execute
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

    threadpool_t *pool = threadpool_create(2, 4);
    if (!pool) {
        fprintf(stderr, "threadpool_create failed\n");
        return 1;
    }

    // Let workers go to sleep first
    usleep(200000);  // 200ms

    // Now submit tasks — workers must wake up
    for (int i = 0; i < 5; i++) {
        threadpool_submit(pool, task_increment, NULL);
    }
    threadpool_destroy(pool);

    if (counter != 5) {
        fprintf(stderr, "expected 5 tasks to complete, got %d\n", counter);
        return 1;
    }

    printf("completed %d\n", counter);
    return 0;
}
