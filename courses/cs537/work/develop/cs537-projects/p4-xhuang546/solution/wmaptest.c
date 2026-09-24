#include "wmaptest.h"

// TEST HELPER
void finish() {
    printf(1, "XV6: Test finished.\n");
    exit();
}

void failed() {
    printf(1, "XV6: Test failed.\n");
    exit();
}

/**
 * @brief Prints details of a wmapinfo struct.
 */
void print_mmap_info(struct wmapinfo *info) {
    printf(1, "XV6: ------ Total mmaps: %d\n", info->total_mmaps);
    for (int i = 0; i < info->total_mmaps; i++) {
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
            i, info->addr[i], info->length[i], info->addr[i] + info->length[i], info->flags[i], info->fd[i], info->refcnt[i], info->n_loaded_pages[i]);
    }
}

void test_getwmapinfo(struct wmapinfo *info) {
    int ret = getwmapinfo(info);
    if (ret < 0) {
        printf(1, "XV6: getwmapinfo() returned %d\n", ret);
        failed();
    }
    print_mmap_info(info);
}

/**
 * @brief Prints details of a pgdirinfo struct.
 */
void print_pgdir_info(struct pgdirinfo *info) {
    printf(1, "XV6: Total n_upages: %d\n", info->n_upages);
    for (int i = 0; i < info->n_upages; i++) {
        printf(1, "XV6: n_upages[%d]: va [0x%x] pa [0x%x] \n",
            i, info->va[i], info->pa[i]);
    }
}

void test_getpgdirinfo(struct pgdirinfo *info) {
    int ret = getpgdirinfo(info);
    if (ret < 0) {
        printf(1, "XV6: getpgdirinfo() returned %d\n", ret);
        failed();
    }
    // print_pgdir_info(info);
}

int create_small_file(char *filename) {

    // create a file
    int bufflen = 512 + 2;
    char buff[bufflen];
    int fd = open(filename, O_CREATE | O_RDWR);
    if (fd < 0) {
        printf(1, "XV6: Failed to create file %s\n", filename);
        failed();
    }

    // prepare the content to write
    for (int j = 0; j < bufflen; j++) {
        buff[j] = 'a' + (j % 4);
    }
    buff[bufflen - 1] = '\0';
    buff[bufflen - 2] = '\n';

    // write to file
    if (write(fd, buff, bufflen) != bufflen) {
        printf(1, "XV6: Error: Write to file FAILED\n");
        failed();
    }

    close(fd);
    return bufflen;
}

int create_big_file(char *filename, int N_PAGES) {
    // create a file
    int bufflen = 512;
    char buff[bufflen + 1];
    int fd = open(filename, O_CREATE | O_RDWR);
    if (fd < 0) {
        printf(1, "XV6: Failed to create file %s\n", filename);
        failed();
    }
    // write in steps as we cannot have a buffer larger than PGSIZE
    char c = 'a';
    for (int i = 0; i < N_PAGES; i++) {
        int m = PGSIZE / bufflen;
        for (int k = 0; k < m; k++) {
            // prepare the content to write
            for (int j = 0; j < bufflen; j++) {
                buff[j] = c;
            }
            buff[bufflen] = '\0';
            // write to file
            if (write(fd, buff, bufflen) != bufflen) {
                printf(1, "XV6: Write to file FAILED (%d, %d)\n", i, k);
                failed();
            }
        }
        c++; // first page is filled with 'a', second with 'b', and so on
    }
    close(fd);
    return N_PAGES * PGSIZE;
}

void va_exists(struct pgdirinfo *info, uint va, int expected) {
    int found = 0;
    for (int i = 0; i < info->n_upages; i++) {
        if (info->va[i] == va) {
            found = 1;
            break;
        }
    }
    if (found != expected) {
        printf(1, "XV6: expected Virt.Addr. 0x%x to %s in the list of user pages\n", va, expected ? "exist" : "not exist");
        failed();
    }
}
