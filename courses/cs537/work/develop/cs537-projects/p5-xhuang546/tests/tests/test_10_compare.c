// Test 10 comparator: run student + busywait measurement binaries and compare CPU burn.
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int read_cpu_us(const char *cmd, long *out_cpu_us) {
    FILE *fp = popen(cmd, "r");
    if (!fp) {
        fprintf(stderr, "popen failed for '%s': %s\n", cmd, strerror(errno));
        return -1;
    }

    char label[64];
    long cpu_us = -1;
    if (fscanf(fp, "%63s %ld", label, &cpu_us) != 2) {
        int rc = pclose(fp);
        (void)rc;
        fprintf(stderr, "parse failure from '%s'\n", cmd);
        return -1;
    }

    int status = pclose(fp);
    if (status != 0) {
        fprintf(stderr, "command '%s' exited non-zero (%d)\n", cmd, status);
        return -1;
    }

    if (strcmp(label, "cpu_us") != 0 || cpu_us < 0) {
        fprintf(stderr, "unexpected output from '%s': %s %ld\n", cmd, label, cpu_us);
        return -1;
    }

    *out_cpu_us = cpu_us;
    return 0;
}

int main() {
    long student_us = -1;
    long busywait_us = -1;

    if (read_cpu_us("./test_10_student", &student_us) != 0) return 1;
    if (read_cpu_us("./test_10_busywait", &busywait_us) != 0) return 1;

    // Guardrail: if the baseline isn't actually burning CPU, comparison is meaningless.
    if (busywait_us < 200000) {
        fprintf(stderr, "busywait baseline too low: %ld us\n", busywait_us);
        return 1;
    }

    // Ratio-based check to reduce environmental flakiness.
    // busywait should burn MUCH more CPU than a sleeping implementation.
    if (busywait_us >= student_us * 5) {
        printf("PASS\n");
        return 0;
    }

    fprintf(stderr, "FAIL: your idle threads appear to be busy-waiting instead of sleeping via condition variables.\n"
            "       student CPU=%ld us, busywait CPU=%ld us (expected busywait >= 5x student)\n",
            student_us, busywait_us);
    return 1;
}
