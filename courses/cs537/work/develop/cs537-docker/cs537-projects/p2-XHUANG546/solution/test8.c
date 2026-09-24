#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  struct rusage before, after;
  
  printf(1, "TEST_8 START: Single sleep context switch test\n");
  
  getrusage(&before);
  
  sleep(1);
  
  getrusage(&after);
  
  int diff = after.nvcsw - before.nvcsw;
  
  if(diff != 1){
    printf(1, "TEST_8 FAIL: Expected nvcsw +1, got +%d\n", diff);
    exit();
  }
  
  printf(1, "TEST_8 PASS: nvcsw increased by exactly 1\n");
  exit();
}