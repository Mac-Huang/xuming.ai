#include <errno.h>
#include <stdio.h>
#include <sys/syscall.h>
#include <unistd.h>

int main(void) {
    char buf[8];
    ssize_t rc;

    errno = 0;
    rc = syscall(SYS_read, STDIN_FILENO, buf, sizeof(buf));
    if (rc == -1 && errno == EPERM) {
        return 0;
    }

    if (rc >= 0) {
        fprintf(stderr, "read unexpectedly succeeded\n");
    } else {
        perror("read");
    }
    return 1;
}
