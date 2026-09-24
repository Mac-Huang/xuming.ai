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
  int fd, r;
  char *key = "rm_key";
  char *val = "data_to_remove";
  int val_len = strlen(val) + 1; // length of string + null terminator
  char buf[64];

  // Create and open a file
  fd = open("test_remove.txt", O_CREATE | O_RDWR);
  check(fd >= 0, "File open failed.");

  // Test 1: Set the attribute
  r = fsetxattr(fd, key, val, val_len, 0);
  check(r == 0, "fsetxattr() failed to create the attribute.");

  // Test 2: Remove the attribute
  r = fremovexattr(fd, key);
  check(r == 0, "fremovexattr() failed to remove the existing attribute.");

  // Test 3: Attempt to get the removed attribute
  memset(buf, 0, sizeof(buf));
  r = fgetxattr(fd, key, buf, sizeof(buf));
  
  // Verify it returns -1 since the attribute should no longer exist
  check(r == -1, "fgetxattr() did not return -1 for a removed attribute.");

  // Also verify that cannot remove the same key again.
  r = fremovexattr(fd, key);
  check(r == -1, "fremovexattr() accidentally removed the same key again.");

  close(fd);

  printf(1, "ALL TESTS PASSED\n");

  exit();
}
