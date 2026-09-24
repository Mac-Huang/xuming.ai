#include <stdio.h>
#include <unistd.h>

int main(void) {
    printf("HELLO world\n");
    printf("PID %ld\n", (long)getpid());
    return 0;
}
