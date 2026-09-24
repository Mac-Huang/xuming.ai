#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  struct rusage r1, r2, r3;
  
  printf(1, "TEST_11 START: Monotonicity test\n");
  
  getrusage(&r1);
  sleep(1);
  printf(1, "X");
  getrusage(&r2);
  sleep(1);
  printf(1, "Y");
  getrusage(&r3);
  
  if(r2.utime < r1.utime || r3.utime < r2.utime){
    printf(1, "TEST_11 FAIL: utime decreased (%d -> %d -> %d)\n", 
           r1.utime, r2.utime, r3.utime);
    exit();
  }
  
  if(r2.stime < r1.stime || r3.stime < r2.stime){
    printf(1, "TEST_11 FAIL: stime decreased (%d -> %d -> %d)\n",
           r1.stime, r2.stime, r3.stime);
    exit();
  }
  
  if(r2.nvcsw < r1.nvcsw || r3.nvcsw < r2.nvcsw){
    printf(1, "TEST_11 FAIL: nvcsw decreased (%d -> %d -> %d)\n",
           r1.nvcsw, r2.nvcsw, r3.nvcsw);
    exit();
  }
  
  if(r2.write_count < r1.write_count || r3.write_count < r2.write_count){
    printf(1, "TEST_11 FAIL: write_count decreased (%d -> %d -> %d)\n",
           r1.write_count, r2.write_count, r3.write_count);
    exit();
  }
  
  printf(1, "TEST_11 PASS: All values monotonically increasing\n");
  exit();
}