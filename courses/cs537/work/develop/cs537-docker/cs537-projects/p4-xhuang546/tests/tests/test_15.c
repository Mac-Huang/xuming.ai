#include "types.h"
#include "user.h"
#include "fcntl.h"

#include "wmaptest.h"

// ====================================================================
// Test 15
// Summary: Validates parent can see child's change for anonymous shared mappings with fork
//
// Checks whether the parent process sees the child's modification
// Does not unmap the mapping
// Does not check for deallocation of pages
// ====================================================================

char *test_name = "TEST_15";

int main() {
    printf(1, "XV6: %s\n", test_name);

    // validate initial state
    struct wmapinfo info;
    printf(1, "XV6: Initial State: \n");
    test_getwmapinfo(&info);

    int N_PAGES = 10;
    int fd = -1;
    int fixed_anon_shared = MAP_FIXED | MAP_ANONYMOUS | MAP_SHARED;

    // 1. create an anonymous private Map 1
    printf(1, "XV6: Place one map. \n");
    int addr = MMAPBASE;
    int len = PGSIZE * N_PAGES;
    uint map = wmap(addr, len, fixed_anon_shared, fd);
    if (map != addr) {
        printf(1, "XV6: expected map at 0x%x, but found at 0x%x\n", addr, map);
        failed();
    }

    // 2. write some data to all the pages of the mapping
    char val = 'a';
    char *arr = (char *)map;
    for (int i = 0; i < len; i++) {
        arr[i] = val;
    }

    int newval = 'x';
    // validate mid state
    printf(1, "XV6: Current State: \n");
    test_getwmapinfo(&info);

    int pid = fork();
    if (pid == 0) {
        printf(1, "XV6: Child process starts\n");

        // validate mid state
        printf(1, "XV6: Child State: \n");
        test_getwmapinfo(&info);

        char *arr3 = (char *)map;
        for (int i = 0; i < len; i++) {
            if (arr3[i] != val) {
                printf(1, "XV6: Child sees '%c' at Map 1, but expected '%c'\n", arr3[i], val);
                failed();
            }
        }
        printf(1, "XV6: Child sees the same data as the parent in Map 1.\n");

        //
        // 4. modify the data in Map 1 (should not affect the parent)
        //
        for (int i = 0; i < len; i++) {
            arr3[i] = newval;
        }
        printf(1, "XV6: Child modified the data in Map 1.\n");
        // child process exits
        exit();
    } else {
        // parent process waits for the child to exit
        wait();

        // validate mid state
        printf(1, "XV6: Parent State: \n");
        test_getwmapinfo(&info);

        // 5. the parent process should see the new data in Map 1
        char *arr = (char *)map;
        for (int i = 0; i < len; i++) {
            if (arr[i] != newval) {
                printf(1, "XV6: Parent sees %d at Map 1, but expected %d\n", arr[i], val);
                failed();
            }
        }
        printf(1, "XV6: Parent sees the new data in Map 1.\n");

        finish();
    }

    // test ends
    finish();
}