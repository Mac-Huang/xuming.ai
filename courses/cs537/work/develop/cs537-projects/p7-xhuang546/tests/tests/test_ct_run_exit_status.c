#include <limits.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "container.h"

int main(void) {
    container_config_t cfg;
    char *const argv[] = {"/bin/exit_7", NULL};
    char rootfs[PATH_MAX];
    char cwd[PATH_MAX];
    int rc;
    const char *suffix = "/tmp/test_10/rootfs";

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
        perror("ct_init");
        return 1;
    }

    rc = ct_run(&cfg, argv);
    if (rc != 7) {
        fprintf(stderr, "ct_run returned %d, expected 7\n", rc);
        return 1;
    }

    printf("PASS ct_run_returns_child_exit_status\n");
    return 0;
}
