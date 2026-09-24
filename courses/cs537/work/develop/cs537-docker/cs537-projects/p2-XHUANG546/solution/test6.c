#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  struct rusage before, after;
  int i;
  
  printf(1, "TEST_6 START: System time increase test\n");
  
  getrusage(&before);
  
  for(i = 0; i < 5000; i++){
    getpid();
  }
  
  getrusage(&after);
  
  if(after.stime <= before.stime){
    printf(1, "TEST_6 FAIL: stime did not increase (%d -> %d)\n",
           before.stime, after.stime);
    exit();
  }
  
  printf(1, "TEST_6 PASS: stime behavior checked\n",
         before.stime, after.stime);
  exit();
}