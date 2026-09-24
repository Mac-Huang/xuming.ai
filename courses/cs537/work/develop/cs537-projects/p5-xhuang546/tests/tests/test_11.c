// Test 11: Destroy while submit is blocked on a full queue
#include <stdio.h>
#include <stdlib.h>
#include <stdatomic.h>
#include <assert.h>
#include <pthread.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include "threadpool.h"

static void on_alarm(int sig) {
    (void)sig;
    fprintf(stderr, "TIMEOUT — destroy while submit blocked appears to hang\n");
    _exit(2);
}

static pthread_mutex_t gate_lock = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t  gate_cond = PTHREAD_COND_INITIALIZER;
static int gate_open = 0;

// Task that blocks until the gate is opened — used to keep the queue full
static void blocking_task(void *arg) {
    (void)arg;
    pthread_mutex_lock(&gate_lock);
    while (!gate_open)
        pthread_cond_wait(&gate_cond, &gate_lock);
    pthread_mutex_unlock(&gate_lock);
}

static atomic_int submit_result;

// Thread that tries to submit one more task into an already-full queue
static void *submitter(void *arg) {
    threadpool_t *pool = (threadpool_t *)arg;
    int rc = threadpool_submit(pool, blocking_task, NULL);
    atomic_store(&submit_result, rc);
    return NULL;
}

int main(void) {
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = on_alarm;
    sigaction(SIGALRM, &sa, NULL);
    alarm(15);

    // 1 worker, queue capacity 2
    threadpool_t *pool = threadpool_create(1, 2);
    assert(pool != NULL);

    // Fill queue: 1 goes to the worker (blocks), 2 sit in queue → full
    threadpool_submit(pool, blocking_task, NULL);
    threadpool_submit(pool, blocking_task, NULL);
    threadpool_submit(pool, blocking_task, NULL);

    // Give the worker time to pick up the first task
    usleep(100000);

    // Launch a submitter that will block on the full queue
    atomic_store(&submit_result, 999);
    pthread_t sub_thread;
    assert(pthread_create(&sub_thread, NULL, submitter, pool) == 0);

    // Give the submitter time to block
    usleep(100000);

    // Open the gate so blocked tasks can complete, then destroy
    pthread_mutex_lock(&gate_lock);
    gate_open = 1;
    pthread_cond_broadcast(&gate_cond);
    pthread_mutex_unlock(&gate_lock);

    threadpool_destroy(pool);

    // Join the submitter thread
    pthread_join(sub_thread, NULL);

    int rc = atomic_load(&submit_result);
    if (rc != -1 && rc != 0) {
        // Accept either -1 (unblocked by destroy) or 0 (snuck in before destroy)
        fprintf(stderr, "FAIL: submit returned %d (expected 0 or -1)\n", rc);
        return 1;
    }

    printf("PASS\n");
    return 0;
}
