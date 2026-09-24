#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(void) {
    pid_t pid;
    int status;

    pid = fork();
    if (pid < 0) {
        perror("fork");
        return 1;
    }

    if (pid == 0) {
        printf("CHILD %ld\n", (long)getpid());
        _exit(7);
    }

    if (waitpid(pid, &status, 0) < 0) {
        perror("waitpid");
        return 1;
    }

    if (!WIFEXITED(status)) {
        fprintf(stderr, "child did not exit cleanly\n");
        return 1;
    }

    printf("PARENT %ld CHILD_EXIT %d\n", (long)getpid(), WEXITSTATUS(status));
    return 0;
}
