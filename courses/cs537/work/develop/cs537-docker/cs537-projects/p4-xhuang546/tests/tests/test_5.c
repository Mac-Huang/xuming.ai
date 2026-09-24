#include "types.h"
#include "user.h"
#include "fcntl.h"

#include "wmaptest.h"

// ====================================================================
// Test 5
// Summary: Places multiple maps at discrete addresses with both successful and failed cases.
//
// Does not access its memory
// Does not unmap any mapping
// Does not check for memory allocation
// ====================================================================

char *test_name = "TEST_5";

int main() {
    printf(1, "XV6: %s\n", test_name);

    // validate initial state
    struct wmapinfo info;
    printf(1, "XV6: Initial State: \n");
    test_getwmapinfo(&info);

    // create and open a file
    printf(1, "XV6: create and open a file. \n");
    char *filename = "file.txt";
    int filelength = create_small_file(filename);
    int fd = open(filename, O_RDWR);
    if (fd < 0) {
        printf(1, "XV6: Failed to open file %s\n", filename);
        failed();
    }
    struct stat st;
    if (fstat(fd, &st) < 0) {
        printf(1, "XV6: Failed to get file stat\n");
        failed();
    }
    if (st.size != filelength) {
        printf(1, "XV6: File size %d != %d\n", st.size, filelength);
        failed();
    }

    // place one map
    printf(1, "XV6: Place one map. \n");
    int fixed_filebacked = MAP_FIXED | MAP_PRIVATE;
    uint addr = 0x60021000;
    uint length = filelength;
    uint map = wmap(addr, length, fixed_filebacked, fd);
    if (map != addr) {
        printf(1, "XV6: expected map at 0x%x, but found at 0x%x\n", addr, map);
        failed();
    }

    // validate mid state
    printf(1, "XV6: Current State: \n");
    test_getwmapinfo(&info);

    // place one map
    printf(1, "XV6: Place one map. \n");
    int fixed_anon = MAP_FIXED | MAP_ANONYMOUS | MAP_SHARED;
    uint addr2 = addr + PGSIZE;
    uint length2 = PGSIZE * 2 + 8;
    uint map2 = wmap(addr2, length2, fixed_anon, -1);
    if (map2 != addr2) {
        printf(1, "XV6: expected map at 0x%x, but found at 0x%x\n", addr2, map2);
        failed();
    }

    // validate mid state
    printf(1, "XV6: Current State: \n");
    test_getwmapinfo(&info);

    // place one map
    printf(1, "XV6: Place one map. \n");
    uint addr3 = addr2 + PGSIZE;
    uint length3 = PGSIZE * 3 + 8;
    uint map3 = wmap(addr3, length3, fixed_anon, -1);
    if (map3 != FAILED) {
        printf(1, "XV6: wmap() should fail but no error returned\n");
        failed();
    }

    // validate mid state
    printf(1, "XV6: Current State: \n");
    test_getwmapinfo(&info);

    // place one map
    printf(1, "XV6: Place the map. \n");
    int anon = MAP_ANONYMOUS | MAP_PRIVATE;
    uint addr4 = addr + length + length2;
    uint length4 = PGSIZE * 4 + 8;
    uint map4 = wmap(addr4, length4, anon, -1);
    if (map4 == FAILED) {
        printf(1, "XV6: wmap() failed\n");
        failed();
    }

    // validate final state
    printf(1, "XV6: Final State: \n");
    test_getwmapinfo(&info);

    // test ends
    finish();
}