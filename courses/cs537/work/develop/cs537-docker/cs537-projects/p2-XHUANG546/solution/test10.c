#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  struct rusage before, after;
  long long i, j;
  volatile long long dummy = 0;
  
  printf(1, "TEST_10 START: No context switch test\n");
  
  getrusage(&before);

  for(i = 0; i < 100000; i++){
    for(j = 0; j < 10000; j++){
      dummy += i*j;
    }
  }
  
  getrusage(&after);
  
  int diff = after.nvcsw - before.nvcsw;
  
  if(diff != 0){
    printf(1, "TEST_10 FAIL: nvcsw changed by %d without sleep\n", diff);
    printf(1, "TEST_10 HINT: Only track VOLUNTARY context switches\n");
    printf(1, "TEST_10 HINT: Do not track timer preemption (involuntary)\n");
    exit();
  }
  
  printf(1, "TEST_10 PASS: nvcsw unchanged (no sleeps)\n");
  exit();
}