#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  struct rusage before, after;
  long long i, j;
  volatile long long dummy = 0;
  
  printf(1, "TEST_5 START: User time increase test\n");
  
  getrusage(&before);
  
  for(i = 0; i < 100000; i++){
    for(j = 0; j < 10000; j++){
      dummy += i*j;
    }
  }
  
  getrusage(&after);
  
  if(after.utime <= before.utime){
    printf(1, "TEST_5 FAIL: utime did not increase (%d -> %d)\n",
           before.utime, after.utime);
    exit();
  }

  printf(1, "TEST_5 PASS: utime behavior checked\n",
         before.utime, after.utime);
  exit();
}