---
title: CS 537 Project 2
layout: default
---

## Process Resource Usage
In this assignment, you will create a system call in xv6 which returns resource usage statistics for the current process.

Learning Objectives:

* Understand the xv6 OS, a simple UNIX operating system.
* Learn to build and customize the xv6 OS
* Understand how system calls work in general
* Understand how to implement a new system call
* Understand how to pass information between a user program and the operating system and vice versa.
* Be able to navigate a larger codebase and find the information needed to make changes.


Summary of what gets turned in:
* The entire XV6 directory ([solution](solution/) directory) has to be turned in with modifications made in appropriate places to add the new system call and a new user program. xv6 should compile successfully when you run make `qemu-nox`.
* It should (hopefully) pass the tests we supply.
* **Your code will be tested in the CS537-Docker environment.**
* Update the [README.md](solution/README.md) inside [solution](solution/) directory to describe your implementation. This file should include your name, your cs login, you wisc ID and email, and the status of your implementation. If it all works then just say that. If there are things you know don't work let us know. Please **list the names of all the files you changed in [solution](solution)**, with a brief description of what the change was. This will **not** be graded, so do not sweat it.
* Please note that xv6 source code (the [solution](solution/) directory in our case) already has a file called [README](solution/README), do not modify or delete this. If you remove the xv6 README, it will cause compilation errors.

## Project Overview

In this project you will add a new system call to the xv6 operating system. More specifically, you will have to create a system call named getrusage (implemented in a kernel function called sys_getrusage) with the following signature:
```
int getrusage(struct rusage *usage)
```
Where `usage` is a pointer to a struct that will be populated with resource usage statistics. The system call should populate this struct with the current process's resource usage information including user time, system time, voluntary context switches, and write call count.

* Tip: To exit xv6 and the qemu virtual machine type `ctrl-a` and then `x`

#### Background What is Resource Usage?
When a process runs, the operating system keeps track of various statistics about how much resources that process has consumed. This is useful for:

* Measuring how long a program takes to run (like the time command in Linux)
* Understanding if a program is spending more time in the kernel or in user code
* Seeing how often a process gets switched out by the scheduler
* Tracking process creation patterns
* Tracking I/O operations

The getrusage system call allows a user program to retrieve these statistics for the currently running process.

#### The rusage structure
You will need to define a new structure in stat.h (the header file that contains system-wide structures). The structure should look like this:
```
struct rusage {
  uint utime;        // User CPU time (number of timer ticks spent in user mode)
  uint stime;        // System CPU time (number of timer ticks spent in kernel mode)
  uint nvcsw;        // Number of voluntary context switches
  uint write_count;  // Number of times this process has called write()
};
```
**Note:** In real operating systems like Linux, the `rusage` struct contains many more fields (memory usage, I/O statistics, etc.), but we're keeping it simple for this assignment.

### Task 1: Download and Run xv6
The xv6 operating system is present inside [solution](solution) folder in your repository. This directory also contains instructions on how to get the operating system up and running in the [README](solution/README) file.

You may find it helpful to go through some of these videos from earlier semesters:

1. [Discussion video](https://www.youtube.com/watch?v=vR6z2QGcoo8&ab_channel=RemziArpaci-Dusseau) - Remzi Arpaci-Dusseau. 
2. [Discussion video](https://mediaspace.wisc.edu/media/Shivaram+Venkataraman-+Psychology105+1.30.2020+5.31.23PM/0_2ddzbo6a/150745971) - Shivaram Venkataraman.
3. [Some background on xv6 syscalls](https://github.com/remzi-arpacidusseau/ostep-projects/blob/master/initial-xv6/background.md) - Remzi Arpaci-Dusseau.

### Task 2: Modify the proc struct to track resource usage

You will need to modify the proc struct (found in [proc.h](solution/proc.h)) to hold resource usage information for each process. 

You will also need to initialize these fields to zero when a process is created.

You need to increment the appropriate counters when a process **voluntarily** context switches and when a process calls write (**NOTE:** Track the number of times write is called, regardless of whether the write succeeds or fails).

### Task 3: Track user and system time in trap.c

The operating system needs to track when a process is running in user mode versus kernel mode. This happens during timer interrupts.

In [trap.c](solution/trap.c), find where timer interrupts are handled. You need to add code that:
- Checks if the process was in user mode or kernel mode when the interrupt occurred
- Increments the appropriate counter (`utime` or `stime`) for the current process

**Hint:** Look at the trap frame (`tf`) to determine if the process was in user mode. The code segment register (`tf->cs`) can tell you this - if `(tf->cs & 3) == 3`, the process was in user mode.

### Task 4: Create the getrusage system call

You will have to add a new system call and modify the system call table and handler to contain the new call.

When `getrusage()` is called, the OS code implementing the system call should:
1. Receive the pointer to a struct rusage from user space
2. Validate that the pointer is not null
3. Copy the current process's resource usage information into the user's struct

To see an example of how arguments are passed into a system call and how structs are copied to user space, you may want to look at the implementation of the **fstat** or **wait** system calls.

#### System Call Specification

**Success case:**
- Copy the current process's utime, stime, nvcsw, and write_count values into the user's struct
- Return `0` to indicate success

**Error case:**
- If the `usage` pointer is invalid (null or pointing to invalid memory), return `-1`

## Testing Your Implementation

You are expected to write user-level test programs to verify that your implementation works correctly. We have provided some test programs, but you should write additional tests to thoroughly verify your implementation.

**NOTE:** We have omitted tests for the write_count, this is intentional, the goal is for you to think of the edge cases and write your own tests. Use the published tests as a starting point but do not rely on them to check correctness of your program.
**Important**: Test that failed writes are also counted

### Adding Your Test Programs

To add a test program to xv6:

1. Create a new `.c` file (e.g., `mytest.c`) in the solution directory
2. Add `_mytest\` to the `UPROGS` list in the [Makefile](solution/Makefile)
3. Run `make qemu-nox`
4. In xv6, run your test: `$ mytest`

**You should create multiple test programs to thoroughly test different aspects of your implementation, especially for write counting and context switches.**

**NOTE:** Unfortunetly xv6 has a cap on the number of user programs that can be added, you can add as many .c files as you want but only add 2-3 `UPROGS` at a time to test.

## Suggested Workflow

- Add the rusage struct to stat.h
- Add the four new fields (utime, stime, nvcsw, write_count) to the proc struct
- Initialize these fields to zero when a process is created
- Add a basic `getrusage` system call that returns dummy/constant values (to test the syscall mechanism works)
- Create a simple test user program to verify getrusage can be called and print the returned values
- Implement time tracking in trap.c during timer interrupts
- Implement context switch tracking
- Implement write call tracking
- Update the `getrusage` system call to return the actual tracked values
- **Write comprehensive tests for write counting** (this is critical!)
- Test incrementally - make sure each piece works before moving to the next


## Notes and Hints

- Use `make qemu-nox` instead of `make qemu` to run qemu with nographic option.
- Search the codebase for patterns. For example, `grep -r "sys_getpid" .` or use your editor's search to see all the places getpid is referenced.
- Take a look at [sysfile.c](solution/sysfile.c) and [sysproc.c](solution/sysproc.c) to find tips on how to implement syscall logic. 
- [proc.c](solution/proc.c) and [proc.h](solution/proc.h) are files you can look into to get an understanding of how process related structs look like. You can use the proc struct to store information.
- [trap.c](solution/trap.c) is where timer interrupts are handled. This is where you should track user vs system time.
- The `myproc()` function returns a pointer to the current process's proc struct.
- The `argptr()` function is useful for getting pointer arguments from user space and validating them.
- It is important to remember that the flavour of C used in xv6 differs from the standard C library (stdlib.c) that you might be used to. For example, in the small userspace example shown above, notice that printf takes in an extra first argument(the file descriptor), which differs from the standard printf you might be used to. It is best to use `grep` to search around in xv6 source code files to familiarize yourself with how such functions work.
- [user.h](solution/user.h) contains a list of system calls and userspace functions (defined in [ulib.c](solution/ulib.c)) available to you, while in userspace. It is important to remember that these functions can't be used in kernelspace and it is left as an exercise for you to figure out what helper functions are necessary(if any) in the kernel for successful completion of this project.
