#include <stdlib.h>
#include <pthread.h>
#include "threadpool.h"

static void *work(void *arg);
static void enqueue(threadpool_t *pool, task_t task);
static task_t dequeue(threadpool_t *pool);

threadpool_t *threadpool_create(int num_threads, int queue_capacity) {
    if (num_threads <= 0 || queue_capacity <= 0) return NULL;

    threadpool_t *pool = (threadpool_t *)malloc(sizeof(threadpool_t));
    if (pool == NULL) return NULL;

    pthread_t *p_tids = (pthread_t *)malloc(sizeof(pthread_t) * num_threads);
    if (p_tids == NULL) {
        free(pool);
        return NULL;
    }

    task_t *tasks = (task_t *)malloc(sizeof(task_t) * queue_capacity);
    if (tasks == NULL) {
        free(pool);
        free(p_tids);
        return NULL;
    }

    pool->threads = p_tids;
    pool->queue = tasks;
    pool->num_threads = num_threads;
    pool->queue_capacity = queue_capacity;
    pool->queue_size = 0;
    pool->queue_head = 0;
    pool->queue_tail = 0;
    pool->shutdown = 0;

    pthread_mutex_init(&pool->lock, NULL);
    pthread_cond_init(&pool->not_empty, NULL);
    pthread_cond_init(&pool->not_full, NULL);

    for (int i = 0; i < num_threads; i++) {
        pthread_create(&p_tids[i], NULL, work, pool);
    }

    return pool;
}

int threadpool_submit(threadpool_t *pool, void (*func)(void *), void *arg) {
    task_t task;
    task.func = func;
    task.arg = arg;

    pthread_mutex_lock(&pool->lock);

    while (pool->queue_size == pool->queue_capacity && !pool->shutdown) {
        pthread_cond_wait(&pool->not_full, &pool->lock);
    }
    if (pool->shutdown) {
        pthread_mutex_unlock(&pool->lock);
        return -1;
    }

    enqueue(pool, task);
    pthread_cond_signal(&pool->not_empty);

    pthread_mutex_unlock(&pool->lock);

    return 0;
}

void threadpool_destroy(threadpool_t *pool) {
    pthread_mutex_lock(&pool->lock);
    pool->shutdown = 1;
    pthread_cond_broadcast(&pool->not_empty);
    pthread_cond_broadcast(&pool->not_full);
    pthread_mutex_unlock(&pool->lock);

    int num_threads = pool->num_threads;
    for (int i = 0; i < num_threads; i++) {
        pthread_join(pool->threads[i], NULL);
    }

    pthread_mutex_destroy(&pool->lock);    
    pthread_cond_destroy(&pool->not_empty);
    pthread_cond_destroy(&pool->not_full);

    free(pool->threads);
    free(pool->queue);
    free(pool);
}

static void *work(void *arg) {
    threadpool_t *pool = (threadpool_t *)arg;

    while (1) {
        pthread_mutex_lock(&pool->lock);

        while (pool->queue_size == 0 && !pool->shutdown) {
            pthread_cond_wait(&pool->not_empty, &pool->lock);
        }

        if (pool->queue_size == 0 && pool->shutdown) {
            pthread_mutex_unlock(&pool->lock);
            return NULL;
        }

        task_t task = dequeue(pool);
        pthread_cond_signal(&pool->not_full);
        pthread_mutex_unlock(&pool->lock);

        task.func(task.arg);
    }
}

static void enqueue(threadpool_t *pool, task_t task) {
    if (pool->queue_capacity == pool->queue_size) return;

    pool->queue[pool->queue_head] = task;
    pool->queue_head = (pool->queue_head + 1) % pool->queue_capacity;
    pool->queue_size++;
}

static task_t dequeue(threadpool_t *pool) {
    task_t task = {0};
    if (pool->queue_size == 0) return task;

    task = pool->queue[pool->queue_tail];
    pool->queue_tail = (pool->queue_tail + 1) % pool->queue_capacity;
    pool->queue_size--;
    return task;
}
