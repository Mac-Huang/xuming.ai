#ifndef CONTAINER_H
#define CONTAINER_H

#include <limits.h>
#include <stddef.h>
#include <sys/types.h>

enum { CT_MAX_SYSCALL_RULES = 128 };

#define CT_STACK_SIZE (1024 * 1024)

typedef struct {
    char rootfs[PATH_MAX];             /* Root filesystem path for the container. */
    int deny_all_syscalls;             /* Nonzero means start by denying all syscalls. */
    int allowed_syscall_count;         /* Number of syscall numbers stored in allowed_syscalls[]. */
    int allowed_syscalls[CT_MAX_SYSCALL_RULES]; /* Syscalls that remain allowed when deny_all_syscalls is enabled. */
} container_config_t;

int enter_rootfs(const container_config_t *cfg);
int ct_run(container_config_t *cfg, char *const argv[]);

// Do not modify the following functions
int ct_init(container_config_t *cfg, const char *root);
int ct_disallow_all(container_config_t *cfg);
int ct_allow(container_config_t *cfg, int syscallno);
int ct_disallow(container_config_t *cfg, int syscallno);


#endif
