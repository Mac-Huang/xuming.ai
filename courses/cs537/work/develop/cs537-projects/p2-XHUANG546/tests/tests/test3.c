#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  int ret;
  struct rusage *bad_ptr = (struct rusage *)0xFFFFFFFF;
  
  printf(1, "TEST_3 START: Invalid pointer test\n");
  
  ret = getrusage(bad_ptr);
  
  if(ret != -1){
    printf(1, "TEST_3 FAIL: getrusage(invalid) returned %d, expected -1\n", ret);
    exit();
  }
  
  printf(1, "TEST_3 PASS: getrusage(invalid) correctly returned -1\n");
  exit();
}