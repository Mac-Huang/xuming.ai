#include <stdio.h>
#include <sys/syscall.h>

#include "container.h"
#include "runtime_syscalls.h"

static void usage(const char *prog) {
    fprintf(stderr, "usage: %s ROOTFS TARGET_PROGRAM\n", prog);
}

int main(int argc, char **argv) {
    container_config_t cfg;
    char *const target_argv[] = {argv[2], NULL};
    int rc;

    if (argc != 3) {
        usage(argv[0]);
        return 1;
    }

    if (ct_init(&cfg, argv[1]) != 0) {
        perror("ct_init");
        return 1;
    }

    if (ct_disallow_all(&cfg) != 0) {
        perror("ct_disallow_all");
        return 1;
    }

    ///TODO: add more allowed syscalls here as needed by the target program.
    // Use CT_SYSCALL_READLINK, CT_SYSCALL_MKDIR, CT_SYSCALL_DUP and
    //     CT_SYSCALL_ARCH_PRCTL, CT_SYSCALL_RSEQ
    // for architecture-specific syscall numbers.

      if (ct_allow(&cfg, SYS_execve) != 0 ||
          ct_allow(&cfg, SYS_brk) != 0 ||
          ct_allow(&cfg, CT_SYSCALL_ARCH_PRCTL) != 0 ||
          ct_allow(&cfg, SYS_set_tid_address) != 0 ||
          ct_allow(&cfg, SYS_set_robust_list) != 0 ||
          ct_allow(&cfg, SYS_uname) != 0 ||
          ct_allow(&cfg, SYS_prlimit64) != 0 ||
          ct_allow(&cfg, SYS_getrandom) != 0 ||
          ct_allow(&cfg, CT_SYSCALL_RSEQ) != 0 ||
          ct_allow(&cfg, SYS_mprotect) != 0 ||
          ct_allow(&cfg, CT_SYSCALL_READLINK) != 0 ||
          ct_allow(&cfg, SYS_openat) != 0 ||
          ct_allow(&cfg, SYS_read) != 0 ||
          ct_allow(&cfg, SYS_write) != 0 ||
          ct_allow(&cfg, SYS_close) != 0 ||
          ct_allow(&cfg, SYS_newfstatat) != 0 ||
          ct_allow(&cfg, CT_SYSCALL_MKDIR) != 0 ||
          ct_allow(&cfg, SYS_chdir) != 0 ||
          ct_allow(&cfg, SYS_getcwd) != 0 ||
          ct_allow(&cfg, SYS_getdents64) != 0 ||
          ct_allow(&cfg, SYS_exit_group) != 0) {
          perror("ct_allow");
          return 1;
      }


    // Do not modify below this line.
    rc = ct_run(&cfg, target_argv);
    if (rc != 0) {
        fprintf(stderr, "ct_run returned %d, expected 0\n", rc);
        return 1;
    }

    printf("ALLOW_COUNT %d\n", cfg.allowed_syscall_count);
    printf("PASS runtime_3\n");
    return 0;
}
