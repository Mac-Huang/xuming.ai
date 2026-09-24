// Test 6: Queue full - submitter blocks until space is available
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <time.h>
#include "threadpool.h"

static int counter = 0;
static pthread_mutex_t counter_lock = PTHREAD_MUTEX_INITIALIZER;

static void task_slow(void *arg) {
    (void)arg;
    usleep(100000);  // 100ms
    pthread_mutex_lock(&counter_lock);
    counter++;
    pthread_mutex_unlock(&counter_lock);
}

static long elapsed_us(struct timespec start, struct timespec end) {
    return (end.tv_sec - start.tv_sec) * 1000000L + (end.tv_nsec - start.tv_nsec) / 1000L;
}

int main() {
    // 1 worker, queue size 1 — submitting 5 tasks should force submit to block
    // because only one pending task can sit in the queue while one is running.
    threadpool_t *pool = threadpool_create(1, 1);
    if (!pool) {
        fprintf(stderr, "threadpool_create failed\n");
        return 1;
    }

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int i = 0; i < 5; i++) {
        threadpool_submit(pool, task_slow, NULL);
    }
    clock_gettime(CLOCK_MONOTONIC, &end);

    threadpool_destroy(pool);

    // With 5 tasks at 100ms and only 1 worker + 1-queue slot,
    // the submit loop should take noticeably longer than "instant".
    // Keep the threshold modest to reduce flakiness under load.
    long submit_time_us = elapsed_us(start, end);
    if (submit_time_us < 250000) {
        fprintf(stderr, "expected submit to block (queue full); submit loop took %ld us\n", submit_time_us);
        return 1;
    }

    if (counter != 5) {
        fprintf(stderr, "expected 5 tasks to complete, got %d\n", counter);
        return 1;
    }

    printf("completed %d\n", counter);
    return 0;
}
