#define _GNU_SOURCE

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

static int run_shell_command(const char *cmd, char *output, size_t out_sz) {
    int pipefd[2];
    pid_t pid;
    ssize_t nread;
    size_t used = 0;
    int status;

    if (pipe(pipefd) != 0) {
        perror("pipe");
        return -1;
    }

    pid = fork();
    if (pid < 0) {
        perror("fork");
        close(pipefd[0]);
        close(pipefd[1]);
        return -1;
    }

    if (pid == 0) {
        close(pipefd[0]);
        if (dup2(pipefd[1], STDOUT_FILENO) < 0) {
            perror("dup2 stdout");
            _exit(1);
        }
        if (dup2(pipefd[1], STDERR_FILENO) < 0) {
            perror("dup2 stderr");
            _exit(1);
        }
        close(pipefd[1]);
        execl("/bin/sh", "sh", "-c", cmd, (char *)NULL);
        perror("execl");
        _exit(127);
    }

    close(pipefd[1]);
    while ((nread = read(pipefd[0], output + used, out_sz - used - 1)) > 0) {
        used += (size_t)nread;
        if (used + 1 >= out_sz) {
            break;
        }
    }
    if (nread < 0) {
        perror("read from pipe");
        close(pipefd[0]);
        return -1;
    }
    output[used] = '\0';
    close(pipefd[0]);

    if (waitpid(pid, &status, 0) < 0) {
        perror("waitpid");
        return -1;
    }
    if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
        fprintf(stderr, "command failed: %s\noutput:\n%s", cmd, output);
        return -1;
    }
    return 0;
}

int main(void) {
    const char *dir = "/tmp/syscalls_demo";
    const char *file = "/tmp/syscalls_demo/message.txt";
    const char *msg = "hello from syscalls_test\n";
    char buf[256];
    char cmd_out[4096];
    int fd;
    ssize_t n;
    struct stat st;

    printf("pid=%ld ppid=%ld\n", (long)getpid(), (long)getppid());

    if (mkdir(dir, 0755) != 0 && errno != EEXIST) {
        perror("mkdir");
        return 1;
    }

    fd = open(file, O_CREAT | O_TRUNC | O_RDWR, 0644);
    if (fd < 0) {
        perror("open");
        return 1;
    }

    if (write(fd, msg, strlen(msg)) != (ssize_t)strlen(msg)) {
        perror("write");
        close(fd);
        return 1;
    }

    if (lseek(fd, 0, SEEK_SET) < 0) {
        perror("lseek");
        close(fd);
        return 1;
    }

    n = read(fd, buf, sizeof(buf) - 1);
    if (n < 0) {
        perror("read");
        close(fd);
        return 1;
    }
    buf[n] = '\0';

    if (fstat(fd, &st) != 0) {
        perror("fstat");
        close(fd);
        return 1;
    }

    if (close(fd) != 0) {
        perror("close");
        return 1;
    }

    printf("read-back=%s", buf);
    printf("size=%ld bytes\n", (long)st.st_size);

    if (run_shell_command("mkdir -p /tmp/syscalls_demo/childdir", cmd_out, sizeof(cmd_out)) != 0) {
        return 1;
    }

    if (run_shell_command("cd /tmp/syscalls_demo && /bin/ls -1", cmd_out, sizeof(cmd_out)) != 0) {
        return 1;
    }
    printf("child-output:\n%s", cmd_out);
    if (strstr(cmd_out, "childdir") == NULL || strstr(cmd_out, "message.txt") == NULL) {
        fprintf(stderr, "expected ls output not found\n");
        return 1;
    }

    if (unlink(file) != 0) {
        perror("unlink");
        return 1;
    }
    if (rmdir("/tmp/syscalls_demo/childdir") != 0) {
        perror("rmdir childdir");
        return 1;
    }
    if (rmdir(dir) != 0) {
        perror("rmdir");
        return 1;
    }

    printf("PASS\n");
    return 0;
}
