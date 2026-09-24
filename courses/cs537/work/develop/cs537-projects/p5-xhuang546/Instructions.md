# CS 537 Project 5: Concurrency

This project has two parts. This document covers **Part 1: Thread Pool**. Part 2 (Concurrent Binary Search Tree) is described in [Instructions_p2.md](Instructions_p2.md).

---

## Part 1: Thread Pool

### Overview

A **thread pool** is a concurrency primitive that manages a fixed set of worker threads to execute tasks submitted by callers. Instead of creating and destroying a thread for every task, callers submit work to the pool, and an idle worker picks it up. Thread pools are used everywhere in systems programming - web servers, database engines, language runtimes.

You will implement a **thread pool library**. Your code provides an API `threadpool_create`, `threadpool_submit`, `threadpool_destroy` that any program can link against and use. You do **not** write `main()`. The test programs (and any other caller) act as clients of your library.

The underlying concurrency pattern is **producer–consumer**:

- **Producers** = callers of `threadpool_submit()`. They add tasks to a bounded queue. If the queue is full, the producer blocks until a slot opens.
- **Consumers** = the pool's worker threads. They pull tasks from the queue and execute them. If the queue is empty, workers sleep until a task arrives.

This is the bounded buffer problem from OSTEP Chapter 30 (Condition Variables).

---

### Learning Objectives

By the end of this part, you should be able to:

- Implement a bounded producer–consumer queue using `pthread_mutex_t` + `pthread_cond_t`.
- Correctly handle blocking semantics (submit blocks when full; workers block when empty).
- Design clean shutdown (destroy) semantics (drain queued work, then join worker threads).
- Avoid busy-waiting and reason about CPU usage when threads are idle.

---

### What You Are Given

| File | Description |
|---|---|
| `solution/threadpool.h` | Struct definitions and function signatures. **Do not modify.** |
| `solution/threadpool.c` | Starter code with function stubs. **This is the only file you modify.** |
| `threadpool_busywait.o` | Pre-compiled busy-wait thread pool. Used only for the performance test. |
| `solution/Makefile` | Builds your code. Run `make` in `solution/` to compile. |
| `tests/` | Visible test harness and test cases. |

Read `solution/threadpool.h` carefully. Your implementation must use the `pthread_mutex_t` and `pthread_cond_t` fields provided in `threadpool_t`. Do not add additional synchronization primitives (no semaphores, spinlocks, atomics, or extra mutexes/condvars). All synchronization should go through the single mutex and two condition variables already in the struct.

---

### What You Implement

Fill in the three functions in `solution/threadpool.c`. You may add static helper functions (e.g., the worker thread routine) as needed.

---

#### `threadpool_t *threadpool_create(int num_threads, int queue_capacity)`

Allocate, initialize, and return a ready-to-use thread pool.

- Allocate the `threadpool_t` struct, the `threads` array, and the `queue` array on the heap.
- Initialize all integer fields, the mutex, and both condition variables.
- Spawn exactly `num_threads` worker threads. Each worker loops: when a task is available in the queue, it dequeues and executes it. When the queue is empty and the pool is not shutting down, the worker sleeps, it does **not** spin.
- Return a pointer to the pool, or `NULL` if any allocation or initialization fails.
- If `num_threads <= 0` or `queue_capacity <= 0`, return `NULL`.

---

#### `int threadpool_submit(threadpool_t *pool, void (*func)(void *), void *arg)`

Add a task to the pool's queue.

- If the queue is at capacity, the caller **blocks** until a worker frees a slot.
- After adding the task, wake a sleeping worker so it can execute it.
- Returns `0` on success.
- If the pool is being destroyed (e.g. a blocked submitter is woken by `threadpool_destroy`), return `-1` without adding the task.

---

#### `void threadpool_destroy(threadpool_t *pool)`

Shut down the pool cleanly. After this call returns, no pool resources remain.

- Every task already in the queue **must** run to completion. Nothing is dropped.
- All worker threads are joined (waited on).
- The mutex and condition variables are destroyed.
- All heap memory is freed, the queue, the threads array, and the pool struct itself.

---

### Building and Testing

Build your code:

```bash
cd solution
make
```

The visible test harness also uses this Makefile: it builds `solution/threadpool.o` and links each test driver against it.

Run the visible tests:

```bash
cd tests
./run-tests.sh           # run all tests
./run-tests.sh -t 4      # run only test 4
./run-tests.sh -v        # verbose output
./run-tests.sh -c        # continue past failures
```

The combined test suite covers both Part 1 (thread pool, tests 1–11) and Part 2 (BST, tests 12–17). Each test has a `.desc` file describing what it checks. Additional hidden tests on the autograder cover further edge cases.

A pre-compiled `threadpool_busywait.o` (same API) is also provided as a performance baseline; it is not part of your implementation.

---

### Hints

- Start by writing the circular queue logic (enqueue, dequeue, head/tail advancement) without any threading. Get that right first, then add the mutex and condition variables.
- Use `valgrind --leak-check=full` to check for memory leaks.
- Use `valgrind --tool=helgrind` to catch data races.
- Think carefully about when to use `pthread_cond_signal` vs `pthread_cond_broadcast`. When does only one thread need to wake up? When do multiple threads need to wake up?
- Do not use global variables. All state must live inside `threadpool_t`.

---
