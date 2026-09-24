#include "types.h"
#include "user.h"
#include "fcntl.h"

#include "wmaptest.h"

// ====================================================================
// Test 3
// Summary: Places one anonymous map at a NOT-fixed address.
//
// Does not access its memory
// Does not unmap any mapping
// Does not check for memory allocation
// ====================================================================

char *test_name = "TEST_3";

int main() {
    printf(1, "XV6: %s\n", test_name);

    // validate initial state
    struct wmapinfo info;
    printf(1, "XV6: Initial State: \n");
    test_getwmapinfo(&info);

    // place one map
    printf(1, "XV6: Place one map. \n");
    int fd = -1;
    int anon = MAP_ANONYMOUS | MAP_SHARED;
    uint addr = 0x60021000;
    uint length = PGSIZE + 8;
    uint map = wmap(addr, length, anon, fd);
    if (map % PGSIZE != 0) {
        printf(1, "XV6: map address not aligned to page size!\n", addr, map);
        failed();
    }

    // validate final state
    printf(1, "XV6: Final State: \n");
    test_getwmapinfo(&info);

    // test ends
    finish();
}