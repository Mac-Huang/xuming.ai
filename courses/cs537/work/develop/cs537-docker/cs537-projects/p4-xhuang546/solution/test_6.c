#include "types.h"
#include "user.h"
#include "fcntl.h"

#include "wmaptest.h"

// ====================================================================
// Test 6
// Summary: Places a number of anonymous maps at fixed and non-fixed addresses
//
// Does not access its memory
// Does not unmap any mapping
// Does not check for memory allocation
// ====================================================================

char *test_name = "TEST_6";

int main() {
    printf(1, "XV6: %s\n", test_name);

    // validate initial state
    struct wmapinfo info;
    printf(1, "XV6: Initial State: \n");
    test_getwmapinfo(&info);

    int fd = -1;
    int fixed = MAP_FIXED | MAP_ANONYMOUS | MAP_PRIVATE;
    int not_fixed = MAP_ANONYMOUS | MAP_PRIVATE;
    // Places Map 1 at fixed address with length "401 pages"
    uint addr = 0x60021000;
    uint length = PGSIZE * 400 + 8;
    uint map = wmap(addr, length, fixed, fd);
    if (map != addr) {
        printf(1, "XV6: expected map at 0x%x, but found at 0x%x\n", addr, map);
        failed();
    }

    // validate mid state
    printf(1, "XV6: Current State: \n");
    test_getwmapinfo(&info);

    // 2. Place 3 maps at non-fixed addresses with lengths "1 page", "2001 page", "4001 pages"
    for (int i = 0; i < 3; i++) {
        addr = -1;
        length = PGSIZE * (i * 2000 + 1) + i * 8;
        map = wmap(addr, length, not_fixed, fd);
        if (map < 0) {
            printf(1, "XV6: wmap() failed\n");
            failed();
        }
    }

    // validate final state
    printf(1, "XV6: Final State: \n");
    test_getwmapinfo(&info);

    // test ends
    finish();
}