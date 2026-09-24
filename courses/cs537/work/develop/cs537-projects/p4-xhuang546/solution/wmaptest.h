#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

#include "wmap.h"

// TEST DEFINE
#define MMAPBASE 0x60000000
#define KERNBASE 0x80000000
#define PGSIZE 4096
#define TRUE 1
#define FALSE 0

// TEST HELPER
void finish();
void failed();
void test_getwmapinfo(struct wmapinfo *info);
void test_getpgdirinfo(struct pgdirinfo *info);
int create_small_file(char *filename);
int create_big_file(char *filename, int N_PAGES);
void va_exists(struct pgdirinfo *info, uint va, int expected);
