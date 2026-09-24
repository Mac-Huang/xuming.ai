#include <limits.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <sys/syscall.h>
#include <unistd.h>

#include "container.h"

#if defined(SYS_mkdir)
#define CT_MKDIR_SYSCALL SYS_mkdir
#elif defined(SYS_mkdirat)
#define CT_MKDIR_SYSCALL SYS_mkdirat
#else
#error "No mkdir-compatible syscall available on this platform"
#endif

static int allow_common_runtime_syscalls(container_config_t *cfg) {
    if (ct_allow(cfg, SYS_execve) != 0 ||
        ct_allow(cfg, SYS_brk) != 0 ||
        ct_allow(cfg, SYS_set_tid_address) != 0 ||
        ct_allow(cfg, SYS_set_robust_list) != 0 ||
        ct_allow(cfg, SYS_uname) != 0 ||
        ct_allow(cfg, SYS_prlimit64) != 0 ||
        ct_allow(cfg, SYS_getrandom) != 0 ||
        ct_allow(cfg, SYS_mprotect) != 0 ||
        ct_allow(cfg, SYS_openat) != 0 ||
        ct_allow(cfg, SYS_read) != 0 ||
        ct_allow(cfg, SYS_write) != 0 ||
        ct_allow(cfg, SYS_close) != 0 ||
        ct_allow(cfg, SYS_newfstatat) != 0 ||
        ct_allow(cfg, SYS_exit_group) != 0) {
        return -1;
    }

#ifdef SYS_arch_prctl
    if (ct_allow(cfg, SYS_arch_prctl) != 0) {
        return -1;
    }
#endif
#ifdef SYS_rseq
    if (ct_allow(cfg, SYS_rseq) != 0) {
        return -1;
    }
#endif
#if defined(SYS_readlink)
    if (ct_allow(cfg, SYS_readlink) != 0) {
        return -1;
    }
#elif defined(SYS_readlinkat)
    if (ct_allow(cfg, SYS_readlinkat) != 0) {
        return -1;
    }
#endif

    return 0;
}

int main(void) {
    container_config_t cfg;
    char *const argv[] = {"/bin/mkdir_probe", NULL};
    char rootfs[PATH_MAX];
    char cwd[PATH_MAX];
    int rc;
    const char *suffix = "/tmp/test_12/rootfs";

    if (getcwd(cwd, sizeof(cwd)) == NULL) {
        perror("getcwd");
        return 1;
    }
    if (strlen(cwd) + strlen(suffix) + 1 > sizeof(rootfs)) {
        fprintf(stderr, "rootfs path too long\n");
        return 1;
    }
    strcpy(rootfs, cwd);
    strcat(rootfs, suffix);

    if (ct_init(&cfg, rootfs) != 0) {
        perror("ct_init allow case");
        return 1;
    }
    if (ct_disallow_all(&cfg) != 0 ||
        allow_common_runtime_syscalls(&cfg) != 0 ||
        ct_allow(&cfg, CT_MKDIR_SYSCALL) != 0) {
        perror("seccomp allow setup");
        return 1;
    }

    rc = ct_run(&cfg, argv);
    if (rc != 0) {
        fprintf(stderr, "allow case returned %d, expected 0\n", rc);
        return 1;
    }

    printf("PASS seccomp_allows_explicitly_allowed_syscall\n");
    return 0;
}
