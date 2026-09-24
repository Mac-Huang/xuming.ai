#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  int ret;
  
  printf(1, "TEST_2 START: Null pointer test\n");
  
  ret = getrusage(0);
  
  if(ret != -1){
    printf(1, "TEST_2 FAIL: getrusage(NULL) returned %d, expected -1\n", ret);
    exit();
  }
  
  printf(1, "TEST_2 PASS: getrusage(NULL) correctly returned -1\n");
  exit();
}