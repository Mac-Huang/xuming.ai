/*
 * threadpool.h
 *
 * DO NOT MODIFY THIS FILE.
 */

#ifndef THREADPOOL_H
#define THREADPOOL_H

#include <pthread.h>

typedef struct {
    void (*func)(void *arg);
    void *arg;
} task_t;

typedef struct {
    pthread_t       *threads;
    task_t          *queue;
    int              num_threads;
    int              queue_capacity;
    int              queue_size;
    int              queue_head;
    int              queue_tail;
    int              shutdown;
    pthread_mutex_t  lock;
    pthread_cond_t   not_empty;
    pthread_cond_t   not_full;
} threadpool_t;

threadpool_t *threadpool_create(int num_threads, int queue_capacity);
int           threadpool_submit(threadpool_t *pool, void (*func)(void *), void *arg);
void          threadpool_destroy(threadpool_t *pool);

#endif
