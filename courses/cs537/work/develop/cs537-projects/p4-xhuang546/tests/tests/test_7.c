#include "types.h"
#include "user.h"
#include "fcntl.h"

#include "wmaptest.h"

// ====================================================================
// Test 7
// Summary: access anonymous map (checks for memory allocation)
//
// Checks for memory allocation
// Does not unmap any mapping
// ====================================================================

char *test_name = "TEST_7";

int main() {
    printf(1, "XV6: %s\n", test_name);

    // validate initial state
    struct wmapinfo info;
    printf(1, "XV6: Initial State: \n");
    test_getwmapinfo(&info);

    // place one map
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

    // validate final state
    printf(1, "XV6: Final State: \n");
    test_getwmapinfo(&info);

    // test ends
    finish();
}