#include "types.h"
#include "user.h"
#include "fcntl.h"

#include "wmaptest.h"

// ====================================================================
// Test 8
// Summary: access one big filebacked map (checks for memory allocation)
//
// Checks for memory allocation
// Does not unmap any mapping
// ====================================================================

char *test_name = "TEST_8";

int main() {
    printf(1, "XV6: %s\n", test_name);

    // validate initial state
    struct wmapinfo info;
    printf(1, "XV6: Initial State: \n");
    test_getwmapinfo(&info);

    char *filename = "big.txt";
    int N_PAGES = 5;
    int filelength = create_big_file(filename, N_PAGES);
    int fd = open(filename, O_RDWR);
    if (fd < 0) {
        printf(1, "Cause: Failed to open file %s\n", filename);
        failed();
    }
    struct stat st;
    if (fstat(fd, &st) < 0) {
        printf(1, "Cause: Failed to get file stat\n");
        failed();
    }
    if (st.size != filelength) {
        printf(1, "Cause: File size %d != %d\n", st.size, filelength);
        failed();
    }
    printf(1, "Created file %s with length %d.\n", filename, filelength);

    // place map 1 (fixed and filebacked)
    int fixed_filebacked = MAP_FIXED | MAP_PRIVATE;
    uint addr = 0x60021000;
    uint length = filelength;
    uint map = wmap(addr, length, fixed_filebacked, fd);
    if (map != addr) {
        printf(1, "Cause: `wmap()` returned %d\n", map);
        failed();
    }

    // validate mid state
    printf(1, "XV6: Current State: \n");
    test_getwmapinfo(&info);

    char *arr = (char *)map;
    int val = 'a';
    for (int i = 0; i < N_PAGES; i++) {
        for (int j = 0; j < PGSIZE; j++) {
            char c = arr[i * PGSIZE + j];
            if (c != val) {
                printf(1, "Cause: expected %c at 0x%x, but found %c\n", c, map + i * PGSIZE + j, arr[i * PGSIZE + j]);
                failed();
            }
        }
        val++;
    }

    // validate final state
    printf(1, "XV6: Final State: \n");
    test_getwmapinfo(&info);

    // test ends
    finish();
}