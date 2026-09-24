#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

int main(void) {
    const char *src = "bin2_input.txt";
    const char *dst = "file_copy_output.txt";
    char buf[128];
    int in_fd;
    int out_fd;
    ssize_t nread;

    in_fd = open(src, O_RDONLY);
    if (in_fd < 0) {
        perror("open input");
        return 1;
    }

    out_fd = open(dst, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (out_fd < 0) {
        perror("open output");
        close(in_fd);
        return 1;
    }

    nread = read(in_fd, buf, sizeof(buf) - 1);
    if (nread < 0) {
        perror("read");
        close(in_fd);
        close(out_fd);
        return 1;
    }

    buf[nread] = '\0';
    if (write(out_fd, buf, (size_t)nread) != nread) {
        perror("write output");
        close(in_fd);
        close(out_fd);
        return 1;
    }

    if (close(in_fd) != 0) {
        perror("close input");
        close(out_fd);
        return 1;
    }
    if (close(out_fd) != 0) {
        perror("close output");
        return 1;
    }

    printf("COPIED %s -> %s : %s\n", src, dst, buf);
    return 0;
}
