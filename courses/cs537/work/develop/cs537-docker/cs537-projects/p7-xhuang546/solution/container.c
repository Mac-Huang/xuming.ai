#define _GNU_SOURCE

#include "container.h"
#include "runtime_syscalls.h"

#include <errno.h>
#include <fcntl.h>
#include <linux/audit.h>
#include <linux/filter.h>
#include <linux/limits.h>
#include <linux/seccomp.h>
#include <sched.h>
#include <signal.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/prctl.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define CT_ERRNO_RETNO(x) (SECCOMP_RET_ERRNO | ((x) & SECCOMP_RET_DATA))

#if defined(__x86_64__)
#define CT_AUDIT_ARCH AUDIT_ARCH_X86_64
#elif defined(__aarch64__)
#define CT_AUDIT_ARCH AUDIT_ARCH_AARCH64
#else
#error "Unsupported architecture for seccomp audit checks"
#endif

typedef struct {
    // Container configuration that ct_core() should apply before execvp().
    const container_config_t *cfg;

    // This is the argument that the container is going to execute.
    // In other words, once we enter the container, we will be in the rootfs.
    // This argv specifies how to run the program in the rootfs.
    // argv[0] is the program name/path to execute, and later elements are the
    // arguments passed to the program. 
    char *const *argv;

    // Pipe used to synchronize parent and child: the child blocks on it until
    // the parent finishes setup and writes one byte.
    int ready_pipe[2];
} container_ctx_t;


static int mount_proc(void) {
    if (mkdir("/proc", 0555) != 0 && errno != EEXIST) {
        return -1;
    }
    if (mount("proc", "/proc", "proc", 0, NULL) != 0) {
        return -1;
    }
    return 0;
}

int enter_rootfs(const container_config_t *cfg) {
    if (cfg == NULL) {
        errno = EINVAL;
        return -1;
    }
    if (mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL) != 0) {
        return -1;
    }
    if (chroot(cfg->rootfs) != 0) {
        return -1;
    }
    if (chdir("/") != 0) {
        return -1;
    }
    return 0;
}

// Don't modify this function.
static int has_syscall_rule(const container_config_t *cfg, int syscallno) {
    int i;
    for (i = 0; i < cfg->allowed_syscall_count; i++) {
        if (cfg->allowed_syscalls[i] == syscallno) {
            return 1;
        }
    }
    return 0;
}

// Don't modify this function.
int ct_disallow_all(container_config_t *cfg) {
    if (cfg == NULL) {
        errno = EINVAL;
        return -1;
    }
    cfg->deny_all_syscalls = 1;
    cfg->allowed_syscall_count = 0;
    return 0;
}

// Don't modify this function.
int ct_allow(container_config_t *cfg, int syscallno) {
    if (cfg == NULL) {
        errno = EINVAL;
        return -1;
    }

    if (cfg->deny_all_syscalls) {
        if (has_syscall_rule(cfg, syscallno)) {
            return 0;
        }
        if (cfg->allowed_syscall_count >= CT_MAX_SYSCALL_RULES) {
            errno = ENOSPC;
            return -1;
        }
        cfg->allowed_syscalls[cfg->allowed_syscall_count++] = syscallno;
        return 0;
    }
    errno = EINVAL;
    return -1;
}

// Don't modify this function.
int ct_disallow(container_config_t *cfg, int syscallno) {
    int i;

    if (cfg == NULL) {
        errno = EINVAL;
        return -1;
    }

    if (cfg->deny_all_syscalls) {
        for (i = 0; i < cfg->allowed_syscall_count; i++) {
            if (cfg->allowed_syscalls[i] == syscallno) {
                memmove(&cfg->allowed_syscalls[i], &cfg->allowed_syscalls[i + 1],
                        (size_t)(cfg->allowed_syscall_count - i - 1) * sizeof(cfg->allowed_syscalls[0]));
                cfg->allowed_syscall_count--;
                break;
            }
        }
        return 0;
    }

    if (has_syscall_rule(cfg, syscallno)) {
        return 0;
    }
    if (cfg->allowed_syscall_count >= CT_MAX_SYSCALL_RULES) {
        errno = ENOSPC;
        return -1;
    }
    cfg->allowed_syscalls[cfg->allowed_syscall_count++] = syscallno;
    return 0;
}

// Don't modify this function.
static int install_seccomp_filter(const container_config_t *cfg) {
    struct sock_filter *filter;
    struct sock_fprog program;
    size_t filter_len;
    size_t idx = 0;
    int i;

    if (!cfg->deny_all_syscalls && cfg->allowed_syscall_count == 0) {
        return 0;
    }

    /* Build a small seccomp-BPF program:
     *   1) verify the syscall was issued on x86_64,
     *   2) compare the syscall number against either the deny list or the
     *      compare the syscall number against the configured list,
     *   3) return the matching action,
     *   4) fall back to the default action.
     */
    filter_len = 4 + ((size_t)cfg->allowed_syscall_count * 2) + 1;
    filter = calloc(filter_len, sizeof(*filter));
    if (filter == NULL) {
        return -1;
    }

    /* Load seccomp_data.arch into the BPF accumulator. */
    filter[idx++] = (struct sock_filter)BPF_STMT(BPF_LD | BPF_W | BPF_ABS,
            (uint32_t)offsetof(struct seccomp_data, arch));
    /* If arch == x86_64, skip the kill instruction below; otherwise fall through. */
    filter[idx++] = (struct sock_filter)BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K,
            CT_AUDIT_ARCH, 1, 0);
    /* Reject unexpected architectures instead of interpreting syscall numbers incorrectly. */
    filter[idx++] = (struct sock_filter)BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_KILL_PROCESS);
    /* Load seccomp_data.nr, i.e., the current syscall number. */
    filter[idx++] = (struct sock_filter)BPF_STMT(BPF_LD | BPF_W | BPF_ABS,
            (uint32_t)offsetof(struct seccomp_data, nr));

    for (i = 0; i < cfg->allowed_syscall_count; i++) {
        filter[idx++] = (struct sock_filter)BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K,
                (uint32_t)cfg->allowed_syscalls[i], 0, 1);
        if (cfg->deny_all_syscalls) {
            /* In deny-all mode, listed syscalls are explicitly allowed. */
            filter[idx++] = (struct sock_filter)BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW);
        } else {
            /* In default-allow mode, listed syscalls are explicitly denied. */
            filter[idx++] = (struct sock_filter)BPF_STMT(BPF_RET | BPF_K, CT_ERRNO_RETNO(EPERM));
        }
    }

    /* No explicit rule matched, so apply the default action. */
    if (cfg->deny_all_syscalls) {
        filter[idx++] = (struct sock_filter)BPF_STMT(BPF_RET | BPF_K, CT_ERRNO_RETNO(EPERM));
    } else {
        filter[idx++] = (struct sock_filter)BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW);
    }

    program.len = (unsigned short)idx;
    program.filter = filter;

    /* Linux requires NO_NEW_PRIVS before an unprivileged process can install
     * a seccomp filter.
     */
    if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) != 0) {
        int saved = errno;
        free(filter);
        errno = saved;
        return -1;
    }
    /* Hand the BPF program to the kernel so future syscalls are filtered. */
    if (syscall(SYS_seccomp, SECCOMP_SET_MODE_FILTER, 0, &program) != 0) {
        int saved = errno;
        free(filter);
        errno = saved;
        return -1;
    }

    free(filter);
    return 0;
}

static int ct_core(void *arg) {
    container_ctx_t *ctx = arg;
    char ready;

    if (ctx == NULL) {
        errno = EINVAL;
        return 1;
    }

    close(ctx->ready_pipe[1]);
    if (read(ctx->ready_pipe[0], &ready, 1) != 1) {
        perror("read");
        close(ctx->ready_pipe[0]);
        return 1;
    }
    close(ctx->ready_pipe[0]);

    if (enter_rootfs(ctx->cfg) != 0) {
        perror("enter_rootfs");
        return 1;
    }
    if (mount_proc() != 0) {
        perror("mount_proc");
        return 1;
    }
    if (install_seccomp_filter(ctx->cfg) != 0) {
        perror("install_seccomp_filter");
        return 1;
    }

    execvp(ctx->argv[0], ctx->argv);
    perror("execvp");
    exit(1);
}

// Don't modify this function.
int ct_init(container_config_t *cfg, const char *root) {
    if (cfg == NULL || root == NULL) {
        errno = EINVAL;
        return -1;
    }

    memset(cfg, 0, sizeof(*cfg));
    snprintf(cfg->rootfs, sizeof(cfg->rootfs), "%s", root);
    return 0;
}


int ct_run(container_config_t *cfg, char *const argv[]) {
    // Validate the parameters are valid.
    if (cfg == NULL || argv == NULL || argv[0] == NULL) {
        errno = EINVAL;
        return -1;
    }

    // Create the container context and initialize it with cfg and argv.
    container_ctx_t ctx;
    memset(&ctx, 0, sizeof(ctx));
    ctx.cfg = cfg;
    ctx.argv = argv;


    // Prepare the syscall policy that will later be installed in the container process
    char *stack = NULL;
    pid_t child_pid = -1;
    int saved_syscalls[CT_MAX_SYSCALL_RULES];
    int saved_count = 0;
    int status = 0;
    int i;

    if (cfg->deny_all_syscalls) {
        saved_count = cfg->allowed_syscall_count;
        if (saved_count < 0 || saved_count > CT_MAX_SYSCALL_RULES) {
            errno = EINVAL;
            return -1;
        }

        memcpy(saved_syscalls, cfg->allowed_syscalls,
                (size_t)saved_count * sizeof(saved_syscalls[0]));

        if (ct_disallow_all(cfg) != 0) {
            return -1;
        }
        for (i = 0; i < saved_count; i++) {
            if (ct_allow(cfg, saved_syscalls[i]) != 0) {
                return -1;
            }
        }
    }
    // Create the pipe using pipe2().
    if (pipe2(ctx.ready_pipe, O_CLOEXEC) != 0) {
        return -1;
    }
    // Allocate the stack for the container process.
    stack = malloc(CT_STACK_SIZE);
    if (stack == NULL) {
        int saved = errno;
        close(ctx.ready_pipe[0]);
        close(ctx.ready_pipe[1]);
        errno = saved;
        return -1;
    }
    // Clone a child (container) process with SIGCHLD, CLONE_NEWNS and CLONE_NEWPID flags.
    child_pid = clone(ct_core,
            stack + CT_STACK_SIZE,
            CLONE_NEWNS | CLONE_NEWPID | SIGCHLD,
            &ctx);
    if (child_pid < 0) {
        int saved = errno;
        close(ctx.ready_pipe[0]);
        close(ctx.ready_pipe[1]);
        free(stack);
        errno = saved;
        return -1;
    }

    close(ctx.ready_pipe[0]);
    ctx.ready_pipe[0] = -1;
    // Prep work before container starts: simply print "container prep done\n".
    printf("container prep done\n");
    // Signal the container process to start running.
    if (write(ctx.ready_pipe[1], "x", 1) != 1) {
        int saved = errno;

        close(ctx.ready_pipe[1]);
        waitpid(child_pid, NULL, 0);
        free(stack);
        errno = saved;
        return -1;
    }

    close(ctx.ready_pipe[1]);
    ctx.ready_pipe[1] = -1;
    // Wait for the container process to finish and return its exit status.
    if (waitpid(child_pid, &status, 0) < 0) {
        int saved = errno;
        free(stack);
        errno = saved;
        return -1;
    }
    // Free the stack.
    free(stack);
    // Return the child's exit status if it exits normally; otherwise return -1.

    if (WIFEXITED(status)) {
        return WEXITSTATUS(status);
    }

    errno = ECHILD;
    return -1;


}
