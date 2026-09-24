#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <unistd.h>

#if defined(SYS_mkdir)
#define MKDIR_SYSCALL(path, mode) syscall(SYS_mkdir, path, mode)
#elif defined(SYS_mkdirat)
#define MKDIR_SYSCALL(path, mode) syscall(SYS_mkdirat, AT_FDCWD, path, mode)
#else
#error "No mkdir-compatible syscall available on this platform"
#endif

int main(void) {
    int rc;

    errno = 0;
    rc = MKDIR_SYSCALL("/blocked", 0755);
    if (rc == -1 && errno == EPERM) {
        return 0;
    }

    if (rc == 0) {
        fprintf(stderr, "mkdir unexpectedly succeeded\n");
    } else {
        perror("mkdir");
    }
    return 1;
}
