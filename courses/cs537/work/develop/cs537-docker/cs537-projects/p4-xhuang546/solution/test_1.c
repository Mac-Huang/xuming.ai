#include "types.h"
#include "user.h"
#include "fcntl.h"

#include "wmaptest.h"

// ====================================================================
// Test 1
// Summary: Validates the output of `getwmapinfo()` before placing any mmap.
//
// This test does not fully check the correctness of all the obtained output.
// ====================================================================

char *test_name = "TEST_1";

int main() {
    printf(1, "XV6: %s\n", test_name);

    struct wmapinfo info;
    test_getwmapinfo(&info);

    // test ends
    finish();
}
