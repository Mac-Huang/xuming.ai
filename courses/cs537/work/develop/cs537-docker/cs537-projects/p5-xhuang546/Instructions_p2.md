# Part 2: Concurrent Binary Search Tree

---

## Overview

In Part 1, you built a thread pool where threads **cooperate** to process a shared task queue. In Part 2, threads **compete** for access to a shared data structure - a binary search tree (BST).

You will make a sequential BST implementation thread-safe using **fine-grained per-node locking** (hand-over-hand / lock-coupling traversal). This allows threads operating on different subtrees to proceed in parallel, unlike a single global lock that serializes all access.

**Example**: Thread A inserts key 5 (left subtree) while Thread B deletes key 95 (right subtree). With a global lock, one must wait for the other. With per-node locking, once the threads diverge into different subtrees, they no longer contend.

---

## Learning Objectives

By the end of this part, you should be able to:

- Implement hand-over-hand (lock-coupling) traversal of a tree structure.
- Understand why fine-grained locking outperforms coarse-grained locking under contention.
- Recognize that consistent lock ordering (top-down) prevents deadlock.
- Correctly handle concurrent physical node removal.

---

## What You Are Given

| File | Description |
|---|---|
| `bst.h` | Struct definitions, function signatures, and locking macros. **Do not modify.** |
| `bst.c` | Sequential BST implementation. **This is the only file you modify.** |
| `Makefile` | Builds your code. Run `make` to compile. |
| `tests/` | Visible test harness and test cases. |

Read `bst.h` carefully. Each `bst_node_t` contains a `pthread_mutex_t lock` field, and `bst_t` contains a tree-level `pthread_mutex_t lock`.

**Important:** Use the provided `NODE_LOCK(node)` and `NODE_UNLOCK(node)` macros for **all** per-node locking. Do **not** call `pthread_mutex_lock`/`pthread_mutex_unlock` directly on node locks. (The tree-level `tree->lock` still uses raw `pthread_mutex_lock`/`pthread_mutex_unlock`.) The macros track per-node lock usage via `lock_count`, which the test suite uses to verify that your locking is truly per-node.

```c
typedef struct bst_node {
    int key;
    int value;
    unsigned int lock_count; // internal - do not modify directly
    pthread_mutex_t lock;    // per-node lock
    struct bst_node *left;
    struct bst_node *right;
} bst_node_t;

typedef struct {
    bst_node_t *root;
    pthread_mutex_t lock;    // tree-level lock - protects root pointer
} bst_t;

#define NODE_LOCK(node)   do { pthread_mutex_lock(&(node)->lock); (node)->lock_count++; } while(0)
#define NODE_UNLOCK(node) pthread_mutex_unlock(&(node)->lock)
```

---

## What You Implement

The starter code provides correct sequential implementations of all functions. You must add fine-grained per-node locking to make them thread-safe. You do **not** rewrite the traversal or relinking logic - the challenge is in the locking strategy.

> **Important:** The starter code's `bst_node_free()` destroys a node's mutex and frees it. When you add locking, you must unlock a node before calling `pthread_mutex_destroy` on it - destroying a locked mutex is undefined behavior.

### `int bst_insert(bst_t *tree, int key, int value)`

Insert a key-value pair. Returns `0` on success, `-1` on duplicate key (the existing value is left unchanged).

### `int bst_lookup(bst_t *tree, int key, int *value)`

Find a key and write its value to `*value`. Returns `0` if found, `-1` if not.

### `int bst_delete(bst_t *tree, int key)`

Physically remove a node from the tree (unlink and free). Returns `0` on success, `-1` if not found.

Three cases (the sequential logic is provided in the starter code):

1. **Leaf** - remove node, set parent's pointer to `NULL`.
2. **One child** - splice out node, relink parent to the node's child.
3. **Two children** - find in-order successor (leftmost in right subtree), copy its key/value into the current node, remove the successor.

### `void bst_destroy(bst_t *tree)`

Provided for you. Frees all nodes and the tree struct. Called after all threads have joined - no locking needed.

---

## The Key Technique: Hand-Over-Hand Locking

The core invariant: **never release a lock until you've acquired the next one.** This prevents another thread from modifying the path between your current position and your next step.

### Why fine-grained locking?

Consider this tree with two threads operating simultaneously:

```
         [50]
         /  \
      [25]   [75]
      /  \
   [10]  [30]
```

Thread A wants to insert key 5 (left subtree). Thread B wants to delete key 75 (right subtree). With a single global lock, one must wait for the other. With per-node locking, both traverse through the root, and once they diverge into different subtrees, they no longer contend. This is the benefit of hand-over-hand locking, threads operating on different parts of the tree proceed in parallel.

### What to think about

The tree has two kinds of locks: `tree->lock` (protects the `tree->root` pointer) and per-node locks (protect each node's fields and child pointers).

For each operation, ask yourself:

- **What am I reading?** You need a lock on a node to safely read its key and child pointers.
- **What am I writing?** Inserting a new child, relinking a parent's pointer, or copying data into a node all require holding the right lock(s).
- **When can I let go?** The sooner you release a lock, the more concurrency you allow, but releasing too early leaves a gap where another thread can modify something you depend on.

Different operations (lookup, insert, delete) read and write different things, so they have different locking requirements. Delete is the most complex because it modifies a parent's child pointer to unlink a node, think about what that means for which locks you need.

### Deadlock

Concurrent locking is prone to deadlock. Think carefully about lock ordering, if every thread acquires locks in a consistent order, deadlock is impossible. What ordering does tree traversal naturally give you?

---

## Building and Testing

```bash
make                          # build
cd tests
./run-tests.sh                # run all tests (P1: 1–11, P2: 12–17)
./run-tests.sh -t 11          # run only test 11
./run-tests.sh -v             # verbose
./run-tests.sh -c             # continue past failures
```

---

## Hints

- **Lock ordering**: top-down only. If you never acquire a lock on a node above one you already hold, deadlock is impossible.
- **Two-children delete**: don't release the target node's lock before copying the successor's data - you need to hold it to write into.
- **`valgrind --leak-check=full`** - every deleted node must be freed.
- **`valgrind --tool=helgrind`** - catches data races.
- **Deadlock detection**: tests use `alarm()`. If your code hangs, check for missing unlocks or lock ordering violations.

---
