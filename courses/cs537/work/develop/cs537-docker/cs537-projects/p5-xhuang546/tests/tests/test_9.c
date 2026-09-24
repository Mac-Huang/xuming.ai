// Test 9: Concurrent producers: many threads submit concurrently, all tasks complete
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

typedef struct {
    threadpool_t *pool;
    int tasks;
} producer_arg_t;

static void *producer(void *arg) {
    producer_arg_t *p = (producer_arg_t *)arg;
    for (int i = 0; i < p->tasks; i++) {
        threadpool_submit(p->pool, task_increment, NULL);
    }
    return NULL;
}

int main() {
    struct sigaction sa; memset(&sa,0,sizeof(sa)); sa.sa_handler=on_alarm;
    sigaction(SIGALRM,&sa,NULL); alarm(30);

    const int num_workers = 4;
    const int queue_capacity = 8;
    const int num_producers = 8;
    const int tasks_per_producer = 200;
    const int iters = 5;

    int expected = num_producers * tasks_per_producer;

    for (int iter = 0; iter < iters; iter++) {
        pthread_mutex_lock(&counter_lock);
        counter = 0;
        pthread_mutex_unlock(&counter_lock);

        threadpool_t *pool = threadpool_create(num_workers, queue_capacity);
        if (!pool) {
            fprintf(stderr, "threadpool_create failed\n");
            return 1;
        }

        pthread_t producers[num_producers];
        producer_arg_t pargs[num_producers];

        for (int i = 0; i < num_producers; i++) {
            pargs[i].pool = pool;
            pargs[i].tasks = tasks_per_producer;
            if (pthread_create(&producers[i], NULL, producer, &pargs[i]) != 0) {
                fprintf(stderr, "pthread_create failed\n");
                threadpool_destroy(pool);
                return 1;
            }
        }

        for (int i = 0; i < num_producers; i++) {
            pthread_join(producers[i], NULL);
        }

        threadpool_destroy(pool);

        if (counter != expected) {
            fprintf(stderr, "iter %d: expected %d tasks to complete, got %d\n", iter, expected, counter);
            return 1;
        }
    }

    printf("PASS\n");
    return 0;
}
