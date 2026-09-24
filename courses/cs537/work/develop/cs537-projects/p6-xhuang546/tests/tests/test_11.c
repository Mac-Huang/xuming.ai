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
  char *key1 = "key_c";
  char *key2 = "key_r";
  char *val = "testdata";
  int val_len = strlen(val) + 1;
  char buf[64];

  // Create and open a file
  fd = open("test_flags.txt", O_CREATE | O_RDWR);
  check(fd >= 0, "File open failed.");

  // --- Testing XATTR_CREATE ---
  
  // 1. Create it normally first (should succeed)
  r = fsetxattr(fd, key1, val, val_len, XATTR_CREATE);
  check(r == 0, "fsetxattr() failed to create a new attribute with XATTR_CREATE.");

  // Verify creation was successful
  memset(buf, 0, sizeof(buf));
  r = fgetxattr(fd, key1, buf, sizeof(buf));
  check(r == val_len, "fgetxattr() size mismatch after successful XATTR_CREATE.");
  check(strcmp(buf, val) == 0, "Data mismatch after successful XATTR_CREATE.");

  // 2. Try to create it AGAIN with XATTR_CREATE and different data (must fail)
  r = fsetxattr(fd, key1, "bad_data", strlen("bad_data") + 1, XATTR_CREATE);
  check(r == -1, "fsetxattr() did not return -1 when XATTR_CREATE was used on an existing attribute.");

  // Verify the original data wasn't accidentally overwritten during the failed call
  memset(buf, 0, sizeof(buf));
  r = fgetxattr(fd, key1, buf, sizeof(buf));
  check(strcmp(buf, val) == 0, "Original data was improperly overwritten during a failed XATTR_CREATE.");

  // --- Testing XATTR_REPLACE ---

  // 3. Try to replace an attribute that doesn't exist yet (must fail)
  r = fsetxattr(fd, key2, val, val_len, XATTR_REPLACE);
  check(r == -1, "fsetxattr() did not return -1 when XATTR_REPLACE was used on a non-existent attribute.");

  // Verify it wasn't accidentally created during the failed call
  r = fgetxattr(fd, key2, buf, sizeof(buf));
  check(r == -1, "Attribute was improperly created during a failed XATTR_REPLACE.");

  // 4. Create it normally (flags = 0)
  r = fsetxattr(fd, key2, val, val_len, 0);
  check(r == 0, "fsetxattr() failed to create a new attribute with flags=0.");

  // 5. Replace it now that it exists (should succeed)
  char *new_val = "newdata";
  int new_val_len = strlen(new_val) + 1;
  r = fsetxattr(fd, key2, new_val, new_val_len, XATTR_REPLACE);
  check(r == 0, "fsetxattr() failed to replace an existing attribute with XATTR_REPLACE.");

  // Verify replacement actually wrote the new data
  memset(buf, 0, sizeof(buf));
  r = fgetxattr(fd, key2, buf, sizeof(buf));
  check(r == new_val_len, "fgetxattr() size mismatch after successful XATTR_REPLACE.");
  check(strcmp(buf, new_val) == 0, "Data mismatch after successful XATTR_REPLACE.");

  close(fd);

  printf(1, "ALL TESTS PASSED\n");

  exit();
}
