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
  int bn_pre, bn_post, fd, n;
  char buf[BSIZE];
  memset(buf, 'X', sizeof(buf));

  // Create a file
  fd = open("test.txt", O_CREATE | O_RDWR);
  check(fd >= 0, "File open failed.");

  // Base stat
  bn_pre = countusedb();

  // Write one block of data
  n = write(fd, buf, sizeof(buf));
  check(n == BSIZE, "The first write() should have written 1 disk block, but it did not.");

  // Delta test
  bn_post = countusedb();
  check(bn_post - bn_pre == 1, "bn_post and bn_pre should differ exactly 1 in the first attempt, but they do not.");
  
  // Write another block of data
  n = write(fd, buf, sizeof(buf));
  check(n == BSIZE, "The second write() should have written 1 disk block, but it did not.");

  bn_pre = bn_post;
  bn_post = countusedb();
  check(bn_post - bn_pre == 1, "bn_post and bn_pre should differ exactly 1 in the second attempt, but they do not.");
  
  close(fd);

  printf(1, "ALL TESTS PASSED\n");

  exit();
}
