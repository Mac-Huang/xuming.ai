#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  struct rusage usage;
  int pid;
  
  printf(1, "TEST_12 START: Child fresh start test\n");
  
  sleep(1);
  printf(1, "Parent working\n");
  sleep(1);
  
  pid = fork();
  if(pid < 0){
    printf(1, "TEST_7 FAIL: fork failed\n");
    exit();
  }
  
  if(pid == 0){
    getrusage(&usage);
    
    if(usage.nvcsw != 0){
      printf(1, "TEST_7 FAIL: child nvcsw=%d, expected 0\n", usage.nvcsw);
      exit();
    }
    
    if(usage.write_count != 0){
      printf(1, "TEST_7 FAIL: child write_count=%d, expected 0\n", usage.write_count);
      exit();
    }
    
    if(usage.utime > 2 || usage.stime > 2){
      printf(1, "TEST_7 FAIL: child time values too large (u:%d s:%d)\n",
             usage.utime, usage.stime);
      exit();
    }
    
    printf(1, "TEST_7 PASS: child starts with fresh counters\n");
    exit();
  }
  
  wait();
  exit();
}