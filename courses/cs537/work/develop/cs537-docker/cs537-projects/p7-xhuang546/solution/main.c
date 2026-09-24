#define _GNU_SOURCE

#include "container.h"

#include <getopt.h>
#include <stdio.h>
#include <unistd.h>

static void usage(const char *prog) {
    fprintf(stderr,
            "usage: %s --root ROOTFS [-it|--it] [-- PROGRAM [ARGS...]]\n"
            "  --root ROOTFS   root filesystem path\n"
            "  -it, --it       run /bin/sh in interactive mode when no program is given\n"
            "\n"
            "everything after \"--\" is passed to the target program that will run\n"
            "inside the container\n"
            "\n"
            "examples:\n"
            "  %s --root ./normal_rootfs -- /bin/ls /\n"
            "  %s --root ./normal_rootfs -- /bin/bin2\n"
            "  %s -it --root ./normal_rootfs\n",
            prog,
            prog,
            prog,
            prog);
}

static int parse_args(int argc, char **argv, const char **root, int *interactive) {
    static struct option long_opts[] = {
        {"root", required_argument, NULL, 'r'},
        {"it", no_argument, NULL, 'i'},
        {0, 0, 0, 0}
    };
    int opt;

    *root = NULL;
    *interactive = 0;

    while ((opt = getopt_long(argc, argv, "it", long_opts, NULL)) != -1) {
        switch (opt) {
        case 'r':
            *root = optarg;
            break;
        case 'i':
            *interactive = 1;
            break;
        case 't':
            /* Accept Docker-style "-it". */
            break;
        default:
            return -1;
        }
    }

    if (*root == NULL || (!*interactive && optind >= argc)) {
        return -1;
    }
    return 0;
}

int main(int argc, char **argv) {
    const char *root = NULL;
    int interactive = 0;
    container_config_t cfg;
    char *const shell_argv[] = {"/bin/sh", NULL};
    int rc;

    if (parse_args(argc, argv, &root, &interactive) != 0) {
        usage(argv[0]);
        return 1;
    }

    if (ct_init(&cfg, root) != 0) {
        perror("ct_init");
        return 1;
    }

    if (optind >= argc) {
        rc = ct_run(&cfg, shell_argv);
    } else {
        rc = ct_run(&cfg, &argv[optind]);
    }

    if (rc < 0) {
        perror("ct_run");
        return 1;
    }
    return rc;
}
