#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  struct rusage before, after;
  int i;
  int num_sleeps = 15;
  
  printf(1, "TEST_9 START: Multiple sleep context switch test\n");
  
  getrusage(&before);
  
  for(i = 0; i < num_sleeps; i++){
    sleep(1);
  }
  
  getrusage(&after);
  
  int diff = after.nvcsw - before.nvcsw;
  
  if(diff != num_sleeps){
    printf(1, "TEST_9 FAIL: Expected nvcsw +%d, got +%d\n", num_sleeps, diff);
    exit();
  }
  
  printf(1, "TEST_9 PASS: nvcsw increased by exactly %d\n", num_sleeps);
  exit();
}