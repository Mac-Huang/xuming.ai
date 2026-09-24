#include <limits.h>
#include <stdio.h>
#include <unistd.h>

#include "container.h"

int main(void) {
    container_config_t cfg;
    char *const argv[] = {"/bin/bin1", NULL};
    char rootfs[PATH_MAX];
    char cwd[PATH_MAX];
    int rc;

    if (getcwd(cwd, sizeof(cwd)) == NULL) {
        perror("getcwd");
        return 1;
    }
    snprintf(rootfs, sizeof(rootfs), "%s/tmp_rootfs", cwd);

    if (ct_init(&cfg, rootfs) != 0) {
        perror("ct_init");
        return 1;
    }

    cfg.deny_all_syscalls = 1;
    cfg.allowed_syscall_count = 0;

    rc = ct_run(&cfg, argv);
    if (rc == 0) {
        fprintf(stderr, "expected failure when allowlist is empty, but ct_run returned 0\n");
        return 1;
    }

    printf("PASS test_empty_allowlist\n");
    return 0;
}
