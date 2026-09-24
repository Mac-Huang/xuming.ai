// Test 3: N workers run tasks in parallel; all tasks complete
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <signal.h>
#include <unistd.h>
#include "threadpool.h"

static int counter = 0;
static pthread_mutex_t counter_lock = PTHREAD_MUTEX_INITIALIZER;

static pthread_barrier_t start_barrier;

static void alarm_handler(int sig) {
    (void)sig;
    const char msg[] = "parallelism check timed out\n";
    ssize_t unused = write(2, msg, sizeof(msg) - 1);
    (void)unused;
    _exit(1);
}

static void task_barrier(void *arg) {
    (void)arg;
    int rc = pthread_barrier_wait(&start_barrier);
    if (rc != 0 && rc != PTHREAD_BARRIER_SERIAL_THREAD) {
        const char msg[] = "pthread_barrier_wait failed\n";
        ssize_t unused = write(2, msg, sizeof(msg) - 1);
        (void)unused;
        _exit(1);
    }
}

static void task_increment(void *arg) {
    (void)arg;
    pthread_mutex_lock(&counter_lock);
    counter++;
    pthread_mutex_unlock(&counter_lock);
}

int main() {
    int num_threads = 4;
    int num_tasks = 50;

    threadpool_t *pool = threadpool_create(num_threads, 8);
    if (!pool) {
        fprintf(stderr, "threadpool_create failed\n");
        return 1;
    }

    // Parallelism check: if tasks are executed synchronously inside submit
    // (or workers don't actually run), this will deadlock until alarm() fires.
    if (pthread_barrier_init(&start_barrier, NULL, (unsigned)num_threads + 1) != 0) {
        fprintf(stderr, "pthread_barrier_init failed\n");
        threadpool_destroy(pool);
        return 1;
    }
    signal(SIGALRM, alarm_handler);
    alarm(5);
    for (int i = 0; i < num_threads; i++) {
        threadpool_submit(pool, task_barrier, NULL);
    }
    int brc = pthread_barrier_wait(&start_barrier);
    if (brc != 0 && brc != PTHREAD_BARRIER_SERIAL_THREAD) {
        fprintf(stderr, "pthread_barrier_wait failed\n");
        threadpool_destroy(pool);
        return 1;
    }
    alarm(0);

    for (int i = 0; i < num_tasks; i++) {
        threadpool_submit(pool, task_increment, NULL);
    }
    threadpool_destroy(pool);

    pthread_barrier_destroy(&start_barrier);

    if (counter != num_tasks) {
        fprintf(stderr, "expected %d tasks to complete, got %d\n", num_tasks, counter);
        return 1;
    }

    printf("completed %d\n", counter);
    return 0;
}
