#include "types.h"
#include "user.h"
#include "fcntl.h"

// Helper function for fail-fast testing
void check(int cond, char *msg) {
  if (!cond) {
    printf(1, "FAIL: %s\n", msg);
    exit();
  }
}

int main() {
  int i, fd, r, changed;
  char *key = "trkey"; // Exactly 5 chars, well under the 8-byte limit
  char *val = "initial_data";
  char buf[64];

  // Create and open a file
  fd = open("test_trunc.txt", O_CREATE | O_RDWR);
  check(fd >= 0, "File open failed.");

  // Test 1: Set the initial attribute
  r = fsetxattr(fd, key, val, strlen(val) + 1, 0);
  check(r == 0, "fsetxattr() failed to create the initial attribute.");

  // Test 2: Truncate the attribute
  // Pass 0 as the value pointer (NULL) and 0 as the size
  r = fsetxattr(fd, key, 0, 0, 0);
  check(r == 0, "fsetxattr() failed during truncation mode.");

  // Test 3: Verify the attribute still exists but has 0 size
  // First, use size query mode to check the length
  r = fgetxattr(fd, key, 0, 0);
  check(r == 0, "fgetxattr() size query did not return 0 for the truncated attribute.");

  // Next, attempt to read it into a buffer
  memset(buf, 'X', sizeof(buf)); // Fill with 'X' to ensure it doesn't get overwritten with garbage
  r = fgetxattr(fd, key, buf, sizeof(buf));
  check(r == 0, "fgetxattr() did not return 0 when reading the truncated attribute.");
  
  // Verify the buffer was not modified by a 0-byte read
  changed = 0;
  for (i = 0; i < sizeof(buf); i++) {
    if (buf[i] != 'X') {
      changed = 1;
      break;
    }
  }
  check(changed == 0, "fgetxattr() improperly modified the buffer during a 0-byte read.");

  close(fd);

  printf(1, "ALL TESTS PASSED\n");

  exit();
}
