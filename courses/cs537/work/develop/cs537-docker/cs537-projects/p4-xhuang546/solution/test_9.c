#include "types.h"
#include "user.h"
#include "fcntl.h"

#include "wmaptest.h"

// ====================================================================
// Test 9
// Summary: Places one anonymous map at a fixed address and unmaps it.
//
// Does not access its memory
// Does not check for memory allocation
// ====================================================================

char *test_name = "TEST_9";

int main() {
    printf(1, "XV6: %s\n", test_name);

    // validate initial state
    struct wmapinfo info;
    printf(1, "XV6: Initial State: \n");
    test_getwmapinfo(&info);

    // place one map
    printf(1, "XV6: Place one map. \n");
    int fd = -1;
    int fixed_anon = MAP_FIXED | MAP_ANONYMOUS | MAP_PRIVATE;
    uint addr = 0x60021000;
    uint length = PGSIZE + 8;
    uint map = wmap(addr, length, fixed_anon, fd);
    if (map != addr) {
        printf(1, "XV6: expected map at 0x%x, but found at 0x%x\n", addr, map);
        failed();
    }

    // validate mid state
    printf(1, "XV6: Current State: \n");
    test_getwmapinfo(&info);

    int ret = wunmap(map);
    if (ret < 0) {
        printf(1, "XV6: wunmap() returned %d\n", ret);
        failed();
    }

    // validate final state
    printf(1, "XV6: Final State: \n");
    test_getwmapinfo(&info);

    // test ends
    finish();
}