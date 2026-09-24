#include "types.h"
#include "user.h"
#include "fcntl.h"

#include "wmaptest.h"

// ====================================================================
// Test 10
// Summary: access anonymous map and unmap it
//
// Checks for memory allocation and deallocation
// ====================================================================

char *test_name = "TEST_10";

int main() {
    printf(1, "XV6: %s\n", test_name);

    // validate initial state
    struct wmapinfo info;
    printf(1, "XV6: Initial State: \n");
    test_getwmapinfo(&info);

    // place map 1 (fixed and anonymous)
    printf(1, "XV6: Place one map. \n");
    int fixed_anon = MAP_FIXED | MAP_ANONYMOUS | MAP_PRIVATE;
    uint addr = MMAPBASE + PGSIZE * 2;
    int length = 2 * PGSIZE + 1;
    uint map = wmap(addr, length, fixed_anon, 0);
    if (map != addr) {
        printf(1, "XV6: expected map at 0x%x, but found at 0x%x\n", addr, map);
        failed();
    }

    // validate mid state
    printf(1, "XV6: Current State: \n");
    test_getwmapinfo(&info);

    // access all pages of map 1
    char *arr = (char *)map;
    char val = 'p';
    for (int i = 0; i < length; i++) {
        arr[i] = val;
    }

    // Each va-pa pair exists in page directory after accessing all pages
    struct pgdirinfo pinfo;
    test_getpgdirinfo(&pinfo);
    for (int i = 0; i < length; i += PGSIZE) {
        va_exists(&pinfo, addr + i, TRUE); // each virtual address exists in pgdir
    }

    // unmap map 1
    int ret = wunmap(map);
    if (ret < 0) {
        printf(1, "Cause: `wunmap()` returned %d\n", ret);
        failed();
    }

    // Each va-pa pair is freed after unmap
    test_getpgdirinfo(&pinfo);
    for (int i = 0; i < length; i += PGSIZE) {
        va_exists(&pinfo, addr + i, FALSE); 
    }

    // validate final state
    printf(1, "XV6: Final State: \n");
    test_getwmapinfo(&info);

    // test ends
    finish();
}