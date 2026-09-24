#include <dirent.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

static int mkdir_if_needed(const char *path) {
    if (mkdir(path, 0755) == 0 || errno == EEXIST) {
        return 0;
    }
    return -1;
}

int main(void) {
    DIR *dir;
    struct dirent *ent;
    char cwd[256];
    int count = 0;

    if (mkdir_if_needed("/tmp/walk_root") != 0) {
        perror("mkdir /tmp/walk_root");
        return 1;
    }
    if (chdir("/tmp/walk_root") != 0) {
        perror("chdir /tmp/walk_root");
        return 1;
    }
    if (mkdir_if_needed("alpha") != 0) {
        perror("mkdir alpha");
        return 1;
    }
    if (mkdir_if_needed("beta") != 0) {
        perror("mkdir beta");
        return 1;
    }
    if (getcwd(cwd, sizeof(cwd)) == NULL) {
        perror("getcwd");
        return 1;
    }

    dir = opendir(".");
    if (dir == NULL) {
        perror("opendir");
        return 1;
    }

    while ((ent = readdir(dir)) != NULL) {
        if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0) {
            continue;
        }
        count++;
    }

    if (closedir(dir) != 0) {
        perror("closedir");
        return 1;
    }

    printf("DIR %s COUNT %d\n", cwd, count);
    return 0;
}
