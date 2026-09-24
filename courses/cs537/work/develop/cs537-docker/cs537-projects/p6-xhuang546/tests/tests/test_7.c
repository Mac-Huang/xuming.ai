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
  int r;
  int bad_fd = -1;
  int unopened_fd = 50; // xv6 typically only supports 16 open files per process
  char *key = "testkey";
  char *val = "testval";
  int val_len = strlen(val) + 1;
  char buf[64];

  // 1. Test fsetxattr
  r = fsetxattr(bad_fd, key, val, val_len, 0);
  check(r == -1, "fsetxattr() did not return -1 for fd = -1.");
  
  r = fsetxattr(unopened_fd, key, val, val_len, 0);
  check(r == -1, "fsetxattr() did not return -1 for an unopened fd.");

  // 2. Test fgetxattr
  memset(buf, 0, sizeof(buf));
  r = fgetxattr(bad_fd, key, buf, sizeof(buf));
  check(r == -1, "fgetxattr() did not return -1 for fd = -1.");

  r = fgetxattr(unopened_fd, key, buf, sizeof(buf));
  check(r == -1, "fgetxattr() did not return -1 for an unopened fd.");

  // 3. Test flistxattr
  memset(buf, 0, sizeof(buf));
  r = flistxattr(bad_fd, buf, sizeof(buf));
  check(r == -1, "flistxattr() did not return -1 for fd = -1.");

  r = flistxattr(unopened_fd, buf, sizeof(buf));
  check(r == -1, "flistxattr() did not return -1 for an unopened fd.");

  // 4. Test fremovexattr
  r = fremovexattr(bad_fd, key);
  check(r == -1, "fremovexattr() did not return -1 for fd = -1.");

  r = fremovexattr(unopened_fd, key);
  check(r == -1, "fremovexattr() did not return -1 for an unopened fd.");

  printf(1, "ALL TESTS PASSED\n");

  exit();
}
