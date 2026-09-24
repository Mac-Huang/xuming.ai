#include <errno.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <unistd.h>

#if defined(SYS_mkdir)
#define MKDIR_SYSCALL_NUM SYS_mkdir
#define MKDIR_SYSCALL(path, mode) syscall(MKDIR_SYSCALL_NUM, path, mode)
#elif defined(SYS_mkdirat)
#define MKDIR_SYSCALL_NUM SYS_mkdirat
#define MKDIR_SYSCALL(path, mode) syscall(MKDIR_SYSCALL_NUM, AT_FDCWD, path, mode)
#else
#error "No mkdir-compatible syscall available on this platform"
#endif

int main(void) {
    int rc;

    errno = 0;
    rc = MKDIR_SYSCALL("/tmp/seccomp_probe", 0755);
    if (rc == 0 || errno == EEXIST) {
        return 0;
    }
    if (errno == EPERM) {
        return 13;
    }
    return 2;
}
