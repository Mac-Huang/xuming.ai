// Test 12: insert, lookup, delete (all cases), re-insert
// Covers: leaf delete, one-child (left), one-child (right), two-children
//         (in-order successor), root delete, empty-tree re-insert.
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include "bst.h"

static void on_alarm(int sig) { (void)sig; fprintf(stderr, "TIMEOUT\n"); _exit(2); }

int main(void) {
    struct sigaction sa; memset(&sa,0,sizeof(sa)); sa.sa_handler=on_alarm;
    sigaction(SIGALRM,&sa,NULL); alarm(10);
    bst_t *t = bst_init();
    assert(t != NULL);

    /*
     * Build tree:
     *          50
     *        /    \
     *      25      75
     *     /  \    /  \
     *   10   30  60   90
     *             \
     *             65
     */
    int keys[] = {50, 25, 75, 10, 30, 60, 90, 65};
    int nkeys = (int)(sizeof(keys) / sizeof(keys[0]));

    for (int i = 0; i < nkeys; i++) {
        assert(bst_insert(t, keys[i], keys[i] + 1000) == 0);
    }

    // Verify all keys present
    int v = 0;
    for (int i = 0; i < nkeys; i++) {
        assert(bst_lookup(t, keys[i], &v) == 0);
        assert(v == keys[i] + 1000);
    }

    // Nonexistent key
    assert(bst_lookup(t, 123456, &v) == -1);

    // --- Case 1: Delete leaf node (10) ---
    assert(bst_delete(t, 10) == 0);
    assert(bst_lookup(t, 10, &v) == -1);
    assert(bst_delete(t, 10) == -1);  // not found

    // --- Case 2: Delete node with one child (right only) ---
    // 60 has only right child 65
    assert(bst_delete(t, 60) == 0);
    assert(bst_lookup(t, 60, &v) == -1);
    // 65 should still be reachable (spliced up to 75's left)
    assert(bst_lookup(t, 65, &v) == 0 && v == 1065);

    // --- Case 3: Delete node with one child (left only) ---
    // 25 now has left=NULL (10 deleted), right=30. One child (right).
    assert(bst_delete(t, 25) == 0);
    assert(bst_lookup(t, 25, &v) == -1);
    // 30 should still be reachable (spliced up to 50's left)
    assert(bst_lookup(t, 30, &v) == 0 && v == 1030);

    // --- Case 4: Delete node with two children (75) ---
    // 75 has left=65, right=90. In-order successor = 90 (leftmost in right subtree).
    // 90's key/value replaces 75. Old 90 node freed.
    assert(bst_delete(t, 75) == 0);
    assert(bst_lookup(t, 75, &v) == -1);
    // Successor key 90 and child 65 must still be reachable
    assert(bst_lookup(t, 90, &v) == 0 && v == 1090);
    assert(bst_lookup(t, 65, &v) == 0 && v == 1065);

    // --- Case 5: Delete root with two children (50) ---
    // Tree: 50 -> left=30, right=node(key=90) -> left=65
    // In-order successor of 50: leftmost in right subtree = 65.
    // 65's key/value replaces 50. Old 65 node freed.
    assert(bst_delete(t, 50) == 0);
    assert(bst_lookup(t, 50, &v) == -1);
    // Remaining: 30, 65 (new root), 90
    assert(bst_lookup(t, 65, &v) == 0 && v == 1065);
    assert(bst_lookup(t, 30, &v) == 0 && v == 1030);
    assert(bst_lookup(t, 90, &v) == 0 && v == 1090);

    // --- Case 6: Delete all remaining nodes ---
    assert(bst_delete(t, 30) == 0);  // leaf
    assert(bst_delete(t, 90) == 0);  // one child or leaf
    assert(bst_delete(t, 65) == 0);  // root, leaf

    // Tree should be completely empty
    assert(bst_lookup(t, 30, &v) == -1);
    assert(bst_lookup(t, 65, &v) == -1);
    assert(bst_lookup(t, 90, &v) == -1);
    assert(bst_delete(t, 42) == -1);  // delete on empty tree

    // --- Case 7: Re-insert into empty tree ---
    assert(bst_insert(t, 42, 4200) == 0);
    assert(bst_lookup(t, 42, &v) == 0 && v == 4200);
    assert(bst_insert(t, 42, 9999) == -1);  // duplicate

    // Re-insert a previously deleted key as a fresh node
    assert(bst_insert(t, 50, 5555) == 0);
    assert(bst_lookup(t, 50, &v) == 0 && v == 5555);

    bst_destroy(t);
    printf("PASS\n");
    return 0;
}
