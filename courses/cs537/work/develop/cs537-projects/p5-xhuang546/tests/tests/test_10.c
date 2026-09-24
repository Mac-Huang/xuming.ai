// Test 10 helper: measure CPU usage while pool is idle
// This binary prints: cpu_us <N>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/resource.h>
#include "threadpool.h"

int main() {
    threadpool_t *pool = threadpool_create(4, 16);
    if (!pool) {
        fprintf(stderr, "threadpool_create failed\n");
        return 1;
    }

    struct rusage before, after;
    getrusage(RUSAGE_SELF, &before);

    sleep(1);

    getrusage(RUSAGE_SELF, &after);

    long cpu_us = (after.ru_utime.tv_sec  - before.ru_utime.tv_sec)  * 1000000
                + (after.ru_utime.tv_usec - before.ru_utime.tv_usec)
                + (after.ru_stime.tv_sec  - before.ru_stime.tv_sec)  * 1000000
                + (after.ru_stime.tv_usec - before.ru_stime.tv_usec);

    threadpool_destroy(pool);

    printf("cpu_us %ld\n", cpu_us);
    return 0;
}
