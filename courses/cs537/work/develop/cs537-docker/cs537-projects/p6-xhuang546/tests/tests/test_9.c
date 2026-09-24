#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"

// Helper function for fail-fast testing
void check(int cond, char *msg) {
  if (!cond) {
    printf(1, "FAIL: %s\n", msg);
    exit();
  }
}

int main() {
  int fd, r;
  char val_buf[BSIZE + 1];
  
  // Fill the buffer with dummy data
  memset(val_buf, 'A', sizeof(val_buf));

  // Create and open a file
  fd = open("test_valsz.txt", O_CREATE | O_RDWR);
  check(fd >= 0, "File open failed.");

  // Test 1: Set an attribute with exactly a BSIZE-byte value (maximum allowed size)
  r = fsetxattr(fd, "key_max", val_buf, BSIZE, 0);
  check(r == 0, "fsetxattr() failed to create an attribute with exactly a BSIZE-byte value.");

  // Test 2: Attempt to set an attribute with a (BSIZE + 1)-byte value (exceeds limit)
  r = fsetxattr(fd, "key_ovf", val_buf, BSIZE + 1, 0);
  check(r == -1, "fsetxattr() did not return -1 when provided a value exceeding BSIZE.");

  close(fd);

  printf(1, "ALL TESTS PASSED\n");

  exit();
}
