#include "types.h"
#include "user.h"
#include "fcntl.h"

#include "wmaptest.h"

// ====================================================================
// Test 4
// Summary: Places one filebacked map at a fixed address.
//
// Does not access its memory
// Does not unmap any mapping
// Does not check for memory allocation
// ====================================================================

char *test_name = "TEST_4";

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

    // validate final state
    printf(1, "XV6: Final State: \n");
    test_getwmapinfo(&info);

    // test ends
    finish();
}