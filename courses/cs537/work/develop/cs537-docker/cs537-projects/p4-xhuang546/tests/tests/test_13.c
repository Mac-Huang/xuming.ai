#include "types.h"
#include "user.h"
#include "fcntl.h"

#include "wmaptest.h"

// ====================================================================
// Test 13
// Summary: Validates mmaps exists in the mmap list in both parent and child for anonymous private and shared mappings with fork
//
// Checks whether the child process has the same mmaps (addr and length) as the parent
// Does not check if they share the same physical pages or not
// Does not check for deallocation of pages
// ====================================================================

char *test_name = "TEST_13";

int main() {
    printf(1, "XV6: %s\n", test_name);

    // validate initial state
    struct wmapinfo info;
    printf(1, "XV6: Initial State: \n");
    test_getwmapinfo(&info);

    int N_PAGES = 10;
    int fd = -1;
    int fixed_anon_private = MAP_FIXED | MAP_ANONYMOUS | MAP_PRIVATE;
    int fixed_anon_shared = MAP_FIXED | MAP_ANONYMOUS | MAP_SHARED;

    // 1. create an anonymous private Map 1
    printf(1, "XV6: Place one map. \n");
    int addr1 = MMAPBASE;
    int len1 = PGSIZE * N_PAGES;
    uint map1 = wmap(addr1, len1, fixed_anon_private, fd);
    if (map1 != addr1) {
        printf(1, "XV6: expected map at 0x%x, but found at 0x%x\n", addr1, map1);
        failed();
    }

    // 2. create an anonymous shared Map 2
    printf(1, "XV6: Place one map. \n");
    int addr2 = MMAPBASE + len1 + PGSIZE;
    int len2 = PGSIZE * N_PAGES + 10;
    uint map2 = wmap(addr2, len2, fixed_anon_shared, fd);
    if (map2 != addr2) {
        printf(1, "XV6: expected map at 0x%x, but found at 0x%x\n", addr2, map2);
        failed();
    }

    // validate mid state
    printf(1, "XV6: Current State: \n");
    test_getwmapinfo(&info);

    int pid = fork();
    if (pid == 0) {
        printf(1, "XV6: Child process starts\n");

        // validate mid state
        printf(1, "XV6: Child State: \n");
        test_getwmapinfo(&info);

        // child process exits
        exit();
    } else {
        // parent process waits for the child to exit
        wait();

        // validate mid state
        printf(1, "XV6: Parent State: \n");
        test_getwmapinfo(&info);

        finish();
    }

    // test ends
    finish();
}