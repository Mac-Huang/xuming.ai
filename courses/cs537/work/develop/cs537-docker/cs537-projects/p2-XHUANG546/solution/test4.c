#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  struct rusage usage;
  
  printf(1, "TEST_4 START: Non-negative values test\n");
  
  if(getrusage(&usage) < 0){
    printf(1, "TEST_4 FAIL: getrusage failed\n");
    exit();
  }
  
  if(usage.utime < 0){
    printf(1, "TEST_4 FAIL: utime=%d is negative\n", usage.utime);
    exit();
  }
  
  if(usage.stime < 0){
    printf(1, "TEST_4 FAIL: stime=%d is negative\n", usage.stime);
    exit();
  }
  
  if(usage.nvcsw < 0){
    printf(1, "TEST_4 FAIL: nvcsw=%d is negative\n", usage.nvcsw);
    exit();
  }
  
  if(usage.write_count < 0){
    printf(1, "TEST_4 FAIL: write_count=%d is negative\n", usage.write_count);
    exit();
  }
  
  printf(1, "TEST_4 PASS: All values non-negative\n");
  exit();
}