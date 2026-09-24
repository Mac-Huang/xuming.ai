#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  struct rusage usage;
  int ret;
  
  printf(1, "TEST_1 START: Basic functionality test\n");
  
  ret = getrusage(&usage);
  
  if(ret != 0){
    printf(1, "TEST_1 FAIL: getrusage returned %d, expected 0\n", ret);
    exit();
  }
  
  printf(1, "TEST_1 PASS: getrusage returned 0\n");
  exit();
}