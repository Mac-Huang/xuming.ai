#include <limits.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>

#include "container.h"

int main(void) {
    container_config_t cfg;
    char *const argv[] = {"/bin/inside_read", NULL};
    char rootfs[PATH_MAX];
    char cwd[PATH_MAX];
    int rc;

    if (getcwd(cwd, sizeof(cwd)) == NULL) {
        perror("getcwd");
        return 1;
    }
    snprintf(rootfs, sizeof(rootfs), "%s/tmp_rootfs", cwd);

    if (ct_init(&cfg, rootfs) != 0) {
        perror("ct_init(tmp_rootfs)");
        return 1;
    }

    if (ct_disallow(&cfg, SYS_read) != 0) {
        perror("ct_disallow");
        return 1;
    }

    rc = ct_run(&cfg, argv);
    if (rc != 0) {
        fprintf(stderr, "ct_run returned %d, expected 0\n", rc);
        return 1;
    }

    printf("PASS\n");
    return 0;
}
