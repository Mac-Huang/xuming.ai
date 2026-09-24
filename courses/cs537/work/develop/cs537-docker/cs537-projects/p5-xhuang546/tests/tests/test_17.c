// Test 17: Correct API compliance — return values match spec
// Tests insert, lookup, and delete return values including edge cases:
//   delete root, re-insert after delete, duplicate handling.
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include "bst.h"

static void on_alarm(int sig) {
    (void)sig;
    fprintf(stderr, "TIMEOUT\n");
    _exit(2);
}

int main(void) {
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = on_alarm;
    sigaction(SIGALRM, &sa, NULL);
    alarm(5);

    bst_t *t = bst_init();
    assert(t != NULL);

    // Insert returns 0 on success
    assert(bst_insert(t, 10, 100) == 0);
    assert(bst_insert(t, 20, 200) == 0);
    assert(bst_insert(t, 5, 50) == 0);

    // Insert returns -1 on duplicate key
    assert(bst_insert(t, 10, 999) == -1);
    assert(bst_insert(t, 20, 999) == -1);

    // Lookup returns 0 on found, writes value
    int v = 0;
    assert(bst_lookup(t, 10, &v) == 0);
    assert(v == 100);
    assert(bst_lookup(t, 20, &v) == 0);
    assert(v == 200);

    // Lookup returns -1 on not found
    assert(bst_lookup(t, 999, &v) == -1);
    assert(bst_lookup(t, -1, &v) == -1);

    // Delete returns 0 on success
    assert(bst_delete(t, 10) == 0);

    // Delete returns -1 on not found
    assert(bst_delete(t, 999) == -1);

    // Delete on already removed key returns -1
    assert(bst_delete(t, 10) == -1);

    // Lookup on removed key returns -1
    assert(bst_lookup(t, 10, &v) == -1);

    // Re-insert a previously deleted key (creates a new node)
    assert(bst_insert(t, 10, 777) == 0);
    assert(bst_lookup(t, 10, &v) == 0);
    assert(v == 777);

    // Duplicate insert after re-insert returns -1
    assert(bst_insert(t, 10, 888) == -1);

    // Value unchanged after failed duplicate insert
    assert(bst_lookup(t, 10, &v) == 0);
    assert(v == 777);

    // Delete root node (10 is root now? depends on structure)
    // Let's explicitly test root deletion via API
    bst_destroy(t);

    // Fresh tree: single-node root deletion
    t = bst_init();
    assert(t != NULL);
    assert(bst_insert(t, 42, 420) == 0);
    assert(bst_delete(t, 42) == 0);
    assert(bst_lookup(t, 42, &v) == -1);
    // Tree is now empty — insert should work
    assert(bst_insert(t, 42, 999) == 0);
    assert(bst_lookup(t, 42, &v) == 0 && v == 999);

    // Empty tree edge cases
    bst_destroy(t);
    t = bst_init();
    assert(t != NULL);
    assert(bst_lookup(t, 1, &v) == -1);
    assert(bst_delete(t, 1) == -1);

    bst_destroy(t);
    printf("PASS\n");
    return 0;
}
