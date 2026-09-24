#include "types.h"
#include "user.h"
#include "fcntl.h"

#include "wmaptest.h"

// ====================================================================
// Test 11
// Summary: wpunmap() split one mmap with loaded pages check
//
// Does not access its memory
// Does not unmap any mapping
// ====================================================================

char *test_name = "TEST_11";

int main() {
    printf(1, "XV6: %s\n", test_name);

    // validate initial state
    struct wmapinfo info;
    printf(1, "XV6: Initial State: \n");
    test_getwmapinfo(&info);

    // place one map
    printf(1, "XV6: Place one map. \n");
    int fd = -1;
    int fixed = MAP_FIXED | MAP_ANONYMOUS | MAP_PRIVATE;
    uint addr = 0x60020000;
    uint length = PGSIZE * 4;
    uint map = wmap(addr, length, fixed, fd);
    if (map != addr) {
        printf(1, "XV6: expected map at 0x%x, but found at 0x%x\n", addr, map);
        failed();
    }

    // validate mid state
    printf(1, "XV6: Current State: \n");
    test_getwmapinfo(&info);

    // memory access
    char *arr = (char *)map;
    char val = 'p';
    for (int i = 0; i < length; i++) {
        arr[i] = val;
    }
    
    // validate mid state
    printf(1, "XV6: Current State: \n");
    test_getwmapinfo(&info);

    // place one map
    printf(1, "XV6: Place one map. \n");
    addr = 0x60022000;
    length = PGSIZE * 2;
    map = wpunmap(addr, length);
    if (map < 0) {
        printf(1, "XV6: wpunmap() failed\n");
        failed();
    }

    // validate final state
    printf(1, "XV6: Final State: \n");
    test_getwmapinfo(&info);

    // test ends
    finish();
}