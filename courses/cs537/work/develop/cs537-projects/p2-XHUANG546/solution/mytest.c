// mytest.c - xv6 getrusage() tests for CS537 Project 2

#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "stat.h"

static void
print_ru(const char *tag, struct rusage *ru)
{
  printf(1, "%s: utime=%d stime=%d nvcsw=%d write_count=%d\n",
         tag, ru->utime, ru->stime, ru->nvcsw, ru->write_count);
}

static int
check_eq(const char *name, int got, int exp)
{
  if(got != exp){
    printf(1, "FAIL: %s got=%d exp=%d\n", name, got, exp);
    return -1;
  }
  printf(1, "PASS: %s (%d)\n", name, got);
  return 0;
}

static int
check_ge(const char *name, int got, int minv)
{
  if(got < minv){
    printf(1, "FAIL: %s got=%d min=%d\n", name, got, minv);
    return -1;
  }
  printf(1, "PASS: %s (got=%d >= %d)\n", name, got, minv);
  return 0;
}

int
main(int argc, char *argv[])
{
  int fails = 0;
  struct rusage a, b;

  printf(1, "=== getrusage() basic tests ===\n");

  // 0) NULL pointer should fail
  int r = getrusage(0);
  if(r != -1){
    printf(1, "FAIL: getrusage(NULL) expected -1 got=%d\n", r);
    fails++;
  } else {
    printf(1, "PASS: getrusage(NULL) returns -1\n");
  }

  // 1) Back-to-back sanity/monotonicity
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage(&a)\n"); exit(); }
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage(&b)\n"); exit(); }

  if(b.utime < a.utime || b.stime < a.stime || b.nvcsw < a.nvcsw || b.write_count < a.write_count){
    printf(1, "FAIL: counters decreased unexpectedly\n");
    print_ru("A", &a);
    print_ru("B", &b);
    fails++;
  } else {
    printf(1, "PASS: monotonic counters\n");
  }

  // 2) write_count increments on successful writes
  const int NWRITE = 20;
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before write success\n"); exit(); }
  for(int i = 0; i < NWRITE; i++){
    write(1, "x", 1);
  }
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after write success\n"); exit(); }
  fails += (check_eq("write_count delta (success writes)",
                     (int)(b.write_count - a.write_count), NWRITE) < 0);

  // 3) write_count increments on failed writes: bad fd
  const int NFAILFD = 10;
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before bad-fd writes\n"); exit(); }
  for(int i = 0; i < NFAILFD; i++){
    int rc = write(99, "y", 1);
    (void)rc; // ignore return
  }
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after bad-fd writes\n"); exit(); }
  fails += (check_eq("write_count delta (bad-fd failed writes)",
                     (int)(b.write_count - a.write_count), NFAILFD) < 0);

  // 4) getrusage pointer validation: straddle end of heap should fail
  // Put struct pointer at (sbrk(0) - 1), so sizeof(struct rusage) crosses into unmapped memory.
  char *brk = (char*)sbrk(0);
  struct rusage *bad = (struct rusage*)(brk - 1);
  r = getrusage(bad);
  if(r != -1){
    printf(1, "FAIL: getrusage(straddle) expected -1 got=%d (brk=%p bad=%p)\n", r, brk, bad);
    fails++;
  } else {
    printf(1, "PASS: getrusage(straddle end-of-heap) returns -1\n");
  }

  // 5) utime grows under pure user-space busy loop
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before busy loop\n"); exit(); }
  volatile int sink = 0;
  for(int i = 0; i < 200000000; i++){
    sink += i;
  }
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after busy loop\n"); exit(); }
  (void)sink;
  fails += (check_ge("utime delta after busy loop", (int)(b.utime - a.utime), 1) < 0);

  // 6) stime grows under lots of syscalls (best-effort; use >= 1)
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before syscall loop\n"); exit(); }
  for(int i = 0; i < 200000; i++){
    getpid();
  }
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after syscall loop\n"); exit(); }
  fails += (check_ge("stime delta after syscall loop", (int)(b.stime - a.stime), 1) < 0);

  // 7) nvcsw via sleep(): each sleep(1) should block once => +1 voluntary context switch
  const int NSLEEP = 10;
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before sleep loop\n"); exit(); }
  for(int i = 0; i < NSLEEP; i++){
    sleep(1);
  }
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after sleep loop\n"); exit(); }
  fails += (check_eq("nvcsw delta after N sleep(1)", (int)(b.nvcsw - a.nvcsw), NSLEEP) < 0);

  // 8) nvcsw via wait(): parent blocks once waiting for child
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before wait test\n"); exit(); }
  int pid = fork();
  if(pid < 0){
    printf(1, "FAIL: fork() for wait test\n");
    fails++;
  } else if(pid == 0){
    // child: sleep a bit so parent actually blocks
    sleep(10);
    exit();
  } else {
    wait();
    if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after wait\n"); exit(); }
    // Some implementations may count more than 1; require at least 1.
    fails += (check_ge("nvcsw delta after wait()", (int)(b.nvcsw - a.nvcsw), 1) < 0);
  }

  printf(1, "=== summary ===\n");
  if(fails == 0){
    printf(1, "ALL PASS\n");
  } else {
    printf(1, "TOTAL FAILS: %d\n", fails);
  }

  exit();
}

