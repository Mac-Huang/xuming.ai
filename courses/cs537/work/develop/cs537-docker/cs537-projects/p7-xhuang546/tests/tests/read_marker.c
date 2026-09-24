#include <stdio.h>
#include <stdlib.h>

int main(void) {
    FILE *fp;
    char buf[128];

    fp = fopen("/etc/container_only_marker.txt", "r");
    if (fp == NULL) {
        perror("fopen marker");
        return 1;
    }
    if (fgets(buf, sizeof(buf), fp) == NULL) {
        perror("fgets marker");
        fclose(fp);
        return 1;
    }
    fclose(fp);

    printf("MARKER %s", buf);
    return 0;
}
