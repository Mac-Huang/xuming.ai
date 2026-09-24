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
  char *key1 = "key1";
  char *val1 = "value1";
  char *key2 = "key2";
  char *val2 = "value2";
  
  int val1_len = strlen(val1) + 1;
  int val2_len = strlen(val2) + 1;
  
  // Total size expected for flistxattr: "key1\0" + "key2\0"
  int expected_list_size = strlen(key1) + 1 + strlen(key2) + 1;

  // Create and open a file
  fd = open("test_query.txt", O_CREATE | O_RDWR);
  check(fd >= 0, "File open failed.");

  // Set multiple attributes
  r = fsetxattr(fd, key1, val1, val1_len, 0);
  check(r == 0, "fsetxattr() failed to create attribute key1.");

  r = fsetxattr(fd, key2, val2, val2_len, 0);
  check(r == 0, "fsetxattr() failed to create attribute key2.");

  // Test 1: Size query mode for fgetxattr
  // Pass 0 as the buffer pointer (NULL) and 0 as the capacity
  r = fgetxattr(fd, key1, 0, 0);
  check(r == val1_len, "fgetxattr() size query mode returned an incorrect size.");

  // Test 2: Size query mode for flistxattr
  // Pass 0 as the buffer pointer (NULL) and 0 as the capacity
  r = flistxattr(fd, 0, 0);
  check(r == expected_list_size, "flistxattr() size query mode returned an incorrect size.");

  close(fd);

  printf(1, "ALL TESTS PASSED\n");

  exit();
}
