# Project 7: Mini Container Runtime

## Important! Prerequisites:
We recommend everyone follow the instructions below to re-compose the docker image. But this will result in all previous files inside the docker container being lost. Hence, we recommend you to **keep a copy of your personal access token first**, then do the following.

If you follow this [recommended workflow document](https://git.doit.wisc.edu/cdis/cs/courses/cs537/spring26/resources/-/blob/main/admin/Workflow.md), you should have stored your personal access token in `~/.gl_cs537`. Make a copy of it. If you forgot to do that, you could always regenerate your personal access token and set it up by following the instructions.


**If you are using X86_64 on your machine, you might not need to do this.** We have tested on Windows Subsystem Linux (Ubuntu 22.04.5 LTS, X86_64) and Windows (X86_64) and they worked. Hence, you could skip this for now, and if there are some other problems, feel free to come back. Don't forget to push all your changes to gitlab before stopping this container.

**If you are a Mac user, with ARM chip, you should do the following:**

Below are the steps to rebuild the new docker container. (Note that you can also use Docker Desktop, and find the containers, stop them, and also delete the images):
```shell
# cd to your existing cs537-docker directory, and run the following
cd path_to_cs537-docker
git pull

# Stop and remove the old container
docker compose down
# Docker desktop: click on the "Containers" on the left-side bar, make sure there's nothing there.

# Show the docker image, make sure you find the docker image name, in my case, is "cs537-v1:latest"
docker images

# Locate the old docker image, and delete it
docker image rm cs537-v1:latest
# Docker desktop: click on the "Images" on the left-side bar, make sure you delete the old image.

# Verify no docker container is running or image exists
docker ps
docker images
# The output should show no container or image.

# Rebuild the docker image (don't forget the trailing dot):
docker build -t cs537-v1 .

# Start the docker container in the background
docker compose up -d

# Enter the docker container
docker exec -it cs537-projects bash

# Inside the container, enter your working directory:
cd cs537-projects
```

Now, you can paste your personal access token at `~/.gl_cs537`. You can run the following command:
```shell
echo "Enter your GitLab token: "; read -s GITLAB_TOKEN; echo "$GITLAB_TOKEN" > ~/.gl_cs537; chmod 600 ~/.gl_cs537
```

Then clone `p7-base` (make sure it's clone with HTTPS, not SSH):
```shell
echo "Enter your NetID: "; read NETID; echo "Enter the repository URL (e.g. https://gitlab.com/namespace/project.git): "; read REPO_URL; STRIPPED_URL=${REPO_URL#https://}; TOKEN=$(< ~/.gl_cs537); git clone "https://${NETID}:${TOKEN}@${STRIPPED_URL}"
```

If you have problems doing this, feel free to come to Office Hours.

## Overview

A container is a way to run a program in a restricted environment on Linux.
Unlike a virtual machine, a container does not emulate hardware or boot a
separate kernel. Instead, it relies on kernel features such as mount isolation,
cgroups, and seccomp to give a process:

- a limited view of the system,
- limited access to resources,
- and limited access to system calls.

In this project, you will build a **mini container runtime in C**. The goal is to 
understand the main Linux mechanisms behind containers by building a small working
system from scratch. Don't panic, we will provide you with some skeleton code to start with.

Your runtime should take a target program and execute it inside a restricted
environment with 
- root filesystem isolation
- syscall filtering

## Why Syscalls Matter

User programs do not talk to the kernel directly in arbitrary ways. They request
kernel services through **system calls** such as `open`, `read`, `write`,
`execve`, `clone`, and `mkdir`.

One useful tool for observing this is `strace`. For example, if you compile a
tiny C program with `gcc`, you can trace the system calls made by `gcc` and the
processes it launches. The docker container does not have `strace` installed - you
should run the following commands to install `strace` **inside the container**:

```shell
apt update
apt install -y strace
```

Then, you can run `strace` on some arbitrary programs, e.g.

```shell
cd p7-base
strace -f gcc hello.c -o hello 2> gcc_strace_output.txt
```

Here, `-f` tells `strace` to follow child processes as well.

You might see output like this:

```text
execve("/usr/bin/gcc", ["gcc", "hello.c", "-o", "hello"], 0x7ffee17695e0 /* 32 vars */) = 0
brk(NULL)                               = 0x3f59d000
arch_prctl(0x3001 /* ARCH_??? */, 0x7fffb9d11820) = -1 EINVAL (Invalid argument)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7c559c180000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
newfstatat(3, "", {st_mode=S_IFREG|0644, st_size=25672, ...}, AT_EMPTY_PATH) = 0
mmap(NULL, 25672, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7c559c179000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P\237\2\0\0\0\0\0"..., 832) = 832
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
```

This example shows an important idea: even a familiar command like `gcc`
ultimately depends on many system calls and helper processes. It opens files,
reads input, does mmap, etc.

This is one reason containers are useful. Instead of trusting a program to use
the system however it wants, a container runtime can restrict what that program
is allowed to see and do. For example:

- **filesystem isolation** can restrict which files `gcc` can access,
- **cgroups** can restrict how much CPU or memory it can consume,
- **seccomp** can block specific system calls such as `mkdir`, `mount`, or `reboot`.

In other words, one goal of this project is to build a runtime that can execute
a program inside a restricted environment and prevent it from using selected kernel
functionalities.

## Design & Implementation

Your implementation must support the following functionalities:

### 1. Root Filesystem Isolation

The runtime must run a program inside a restricted root filesystem.
The goal of this part is: when the target program runs inside the container, it
should see a restricted filesystem namespace that contains the files and
directories it is allowed to access, along with the files necessary for it to
run correctly. In particular, the containerized program should treat the
provided rootfs directory as its own `/`, rather than seeing the host's real
root filesystem.

Concretely, you should make the containerized process behave as if:

- the host-provided rootfs directory is now `/`,
- files outside that rootfs are no longer visible through normal pathname lookup,
- and the program can still access the runtime files it needs inside that rootfs,
  such as `/bin/ls`, `/bin/sh`, shared libraries, and `/proc` after you mount it.

Before implementing this part, it helps to understand what `mount()` means.
The simplest way to think about `mount()` is:

- you choose a filesystem source,
- you choose a directory path,
- and Linux attaches that filesystem to that directory path.

In other words, you are deciding:
- **what** to mount,
- and **where** to mount it.

For example:

```c
mount("tmpfs", "/mytmp", "tmpfs", 0, NULL);
```

The parameters of `mount(...)` in this example are:

- first parameter: `"tmpfs"`
  This is the mount source. For some filesystem types, this names the device or
  source being mounted. For `tmpfs`, it is commonly just written as `"tmpfs"`.
- second parameter: `"/mytmp"`
  This is the target path, i.e., the directory where the new filesystem will be
  attached.
- third parameter: `"tmpfs"`
  This is the filesystem type.
- fourth parameter: `0`
  These are the mount flags. Here `0` means "no special mount flags."
- fifth parameter: `NULL`
  This is optional filesystem-specific data. Here we are not passing any extra
  options.

So this call means:

- mount a `tmpfs` filesystem,
- and attach it at the directory `/mytmp`.

After this call succeeds, `/mytmp` is no longer just an ordinary directory on
the previous filesystem. Instead, `/mytmp` now shows the contents of the new
`tmpfs` mount. You could verify this by doing `ls /mytmp` after the mount and
then creating a file inside `/mytmp`.

This example is not the exact filesystem you will use in the project. It is
just meant to show the general pattern:

- choose a filesystem type,
- choose a target directory,
- mount that filesystem onto that directory.

Later in this project, you will apply the same pattern to mount `proc` onto
`/proc`, and the idea is exactly the same as `tmpfs`.

If you want to try the same idea manually in a shell, use the shell command form:

```bash
mkdir -p /mytmp
mount -t tmpfs tmpfs /mytmp
ls /mytmp
touch /mytmp/hello
ls /mytmp
umount /mytmp
rm -rf /mytmp
```

This shell example does the following:

- creates the target directory `/mytmp`,
- mounts a `tmpfs` filesystem onto `/mytmp`,
- lets you inspect the mounted directory,
- creates a file inside that mount,
- and finally unmounts it with `umount /mytmp`,
- delete the `/mytmp` directory.

Here, `umount /mytmp` means:

- detach the mounted filesystem from `/mytmp`,
- so `/mytmp` becomes an ordinary directory again,
- and the temporary mount created by `mount -t tmpfs tmpfs /mytmp` is removed.


A **mount namespace** gives a process its own view of these mount points. This
means a container can mount something like `proc` inside its own namespace
without changing the host's mount layout. In other words, if the container
mounts something on `/proc`, that new mount stays inside the container's view.

So the implementation task in this section is not "mount arbitrary things."
Instead, it is to set up the container process so that:

- it has its own mount view,
- it enters the provided rootfs,
- and it gets a usable `/proc` inside that new root.

**Implementation notes:**
You should implement 2 functions: `enter_rootfs()` and `mount_proc()`.

+ `enter_rootfs`: 
  + this function takes in `container_config_t` as a parameter, in which it has a field `rootfs` storing the root filesystem path, where this path is a directory on the host that should become the root `/` inside the container.
  + you should implement `enter_rootfs(...)` so that the container process first makes its mount namespace private. In code, this means calling `mount(...)` on the root mount point:
    + - use `"/"` as the second parameter, because you want to apply this mount operation to the root mount point `/`.
    + - use `MS_REC | MS_PRIVATE` as the flags argument, because you want to apply the change recursively to `/` and make those mounts private, so mount operations inside the container stay inside the container.
    + use `NULL` for the rest parameters.
  + after that, call `chroot(..)` to change the container process's root directory to the root filesystem path stored in `cfg->rootfs`.
  + then call `chdir(..)` to change the current working directory to `/` inside the new root filesystem.
  + do not `chdir()` before `chroot()`, because that pattern breaks relative rootfs paths such as `./normal_rootfs`,
  + Return 0 on success, and -1 on failure of any function.
+ `mount_proc(...)`:
  + the container process mounts the `proc` filesystem at `/proc` after entering the new root.
  + first ensure that `/proc` exists by calling `mkdir("/proc", 0555)` and
  accepting both outcomes: either the directory is created successfully, or it
  already exists (`errno == EEXIST`).
  + then call `mount(...)` to mount the `proc` file system at `/proc`. Please refer to the `tmpfs` example we showed you at the beginning of this section - mounting `proc` is almost the same.
  + If `mount()` succeed, return 0. Return -1 on failure. 

### 2. Seccomp Filtering
The runtime must support syscall filtering with `seccomp()`.

The goal of this part is: run the target program with the minimum number of
system calls enabled, and block the rest. In other words, your container should
not simply "allow everything and hope it works." Instead, you should use
`strace` to figure out which syscalls a program actually needs, then allow only
those syscalls that are required for correct execution.

`seccomp` stands for **secure computing**. Its purpose is to reduce what a
process is allowed to do by restricting its available system calls. This is
useful in containers because even if a program runs successfully inside the
container, we may still want to prevent it from invoking dangerous or
unnecessary syscalls.

This is exactly where our earlier `strace` analysis becomes useful. For each
target program, you should observe which syscalls it makes, decide which ones
must remain available, and then configure the container to allow only that
minimal set.

At a high level, your code does not manually intercept syscalls one by one.
Instead, it prepares a syscall policy in `cfg`, and then asks the kernel to
enforce that policy for the container process.

We do not require you to implement the low-level seccomp internals from
scratch. Instead, we provide helper APIs that let you **describe** and
**install** the syscall policy.


We provide helper APIs such as:

- `ct_disallow_all(container_config_t *cfg)`
- `ct_allow(container_config_t *cfg, int syscallno)`

The key idea is that `container_config_t` contains an array that acts as the
syscall allowlist:

- `cfg->allowed_syscalls[]` stores syscall numbers that should remain allowed,
- if a syscall number appears in this array, your policy should allow that syscall,
- if a syscall number does not appear in this array, and
  `cfg->deny_all_syscalls` is set to true, then that syscall should be denied.

In other words, this config describes the policy "allow only these syscalls"
when deny-by-default mode is enabled.

The helper functions work by modifying this config:
- `ct_disallow_all(...)` switches the config into "deny all syscalls first"
  mode and clears the current allowlist,
- `ct_allow(...)` adds one syscall number into `cfg->allowed_syscalls[]`.

To fill this allowlist, you need syscall numbers. In code, these are usually
provided as macros such as `SYS_read`, `SYS_write`, and `SYS_exit` (make sure to `#include <sys/syscall.h>`).

However, calling `ct_allow(...)`, `ct_disallow(...)`, or
`ct_disallow_all(...)` is still not enough by itself. These functions only
modify the config data structure. They do not yet make syscall filtering
effective in the kernel. Hence, you need to call `install_seccomp_filter(...)` API, which
is also provided for you. This is the function that actually makes syscall filtering effective.

Conceptually, `install_seccomp_filter(...)`

- reads the syscall policy currently stored in `cfg`,
- build the seccomp-BPF filter rules that match that policy,
- installs those rules into the kernel.

After that, when the containerized program executes a syscall, the kernel will
check that syscall against the installed policy and decide whether it should be
allowed or denied.

**Implementation notes:**
You should learn and potentially use the provided APIs to
- Configure the `container_config_t`'s related fields about syscalls allow/disallow
- Then pass the `container_config_t` to `install_seccomp_filter()` function to make the policy effective.

Later in this project, we will provide you with several binaries, and your job
is to use `strace` to figure out what syscalls each binary invokes, then build
a runtime that allows the minimum required set for each one. We will talk more
about this later.


### 3. Combining them together - `ct_core()` and `ct_run()`
So far, you should have implemented `enter_rootfs()` and `mount_proc()`
and learned how to configure the syscalls allowlist and install it to the container. 
But those are separate functionalities and we need a way to combine them together.

At a high level, running a container means:

- first prepare a root filesystem for the container on the host,
- then start a new process that will treat that root filesystem as its own root `/`,
- and finally run some target program inside that filesystem.

In this project, a container is a `clone()`'ed process. The parent process is responsible
for preparing the container process and synchronizing with it. After that, the
container process continues, enters its new root filesystem, installs its
syscall restrictions, and runs a target program inside that filesystem.

Before implementing `ct_core()` and `ct_run()`, you should understand the structs we provide,
i.e. `struct container_ctx_t` and `struct container_config_t`.

`container_config_t`:
- `rootfs`: root filesystem path for the container. This is a path on the host,
  but after `chroot(...)`, the container process will treat that directory as `/`.
- `deny_all_syscalls`: nonzero means the syscall policy should start in
  deny-by-default mode. In that mode, only syscall numbers explicitly listed in
  `allowed_syscalls[]` should remain allowed.
- `allowed_syscall_count`: number of valid syscall numbers currently stored in
  `allowed_syscalls[]`.
- `allowed_syscalls[]`: array of syscall numbers used by the seccomp policy.
  When `deny_all_syscalls` is enabled, this array acts as the syscall allowlist.

`container_ctx_t`:
- `cfg`: pointer to the container configuration that the child should use when
  setting up rootfs isolation and syscall filtering.
- `argv`: NULL-terminated argument vector for the target program that will run
  inside the container. After the child enters the root filesystem, `argv[0]`
  is the program path/name to execute inside that filesystem, and later
  elements (`argv[1]`, `argv[2]`, ...) are the arguments passed to that program.
- `ready_pipe`: synchronization pipe shared between the parent and child. The
  child waits on this pipe until the parent finishes its setup work and writes
  one byte.

To start the container, the host-side runtime needs to create a new process
that will become the container's initial process. In this project, the
host-side logic lives in `ct_run(...)`. You should think of `ct_run(...)` as
the host: it prepares the container environment, starts the container process,
and waits for it to finish.

We use `clone()` instead of an ordinary `fork()` because we want the new
process to start with specific namespace behavior for the container. In this
project, your `ct_run(...)` should call `clone()` with the following flags:

- `CLONE_NEWNS` to give the container its own mount namespace,
- `CLONE_NEWPID` to give the container its own PID namespace,
- `SIGCHLD` so the parent can later use `waitpid(...)` on the container
  process.

Unlike `fork()`, `clone()` requires the caller to provide stack space for the
new process. This is why the host should allocate a stack buffer first, and
then pass the top of that stack into `clone()`.

The second argument to `clone(...)` is the memory address that the child
process should use as its initial stack pointer. A common pattern is:

- allocate a stack buffer with `malloc(...)`,
- compute an address near the top of that buffer,
- and pass that address as the second argument to `clone(...)`.

You can think of this as: the host allocates a region of memory for the child
to use as its stack, and `clone(...)` needs to know where that stack starts.
Because the stack typically grows downward on x86_64, code often passes the
high-address end of the allocated buffer rather than its beginning.

For example, if your code allocates the stack like this:

```c
char *s = malloc(CT_STACK_SIZE);
```

then the second argument passed to `clone(...)` should typically be:

```c
s + CT_STACK_SIZE
```

rather than just `s`.

We also need a `pipe()` for synchronization between the host and the container
process. Right after the host calls `clone()`, the container process should not
continue immediately. Instead, it should wait until the host signals that the
host-side setup is complete. The pipe is defined in `container_ctx_t`, called `ready_pipe`.

In practice, `pipe2(...)` is more convenient than plain `pipe(...)` here.
Both create a pipe, but `pipe2(...)` lets you set flags such as `O_CLOEXEC`
at creation time. `O_CLOEXEC` means the pipe file descriptors will be closed
automatically if a later `execvp(...)` succeeds. This is useful in a container
runtime because the synchronization pipe is only meant for the runtime's own
setup logic; it should not accidentally leak into the final target program.

The pipe is used for exactly this purpose:

- the host creates the pipe before `clone()`,
- the container process blocks by calling `read(...)` on the pipe,
- the host finishes its host-side setup work,
  in this project, you may assume there is no additional host-side
  preparation, so just printing `container prep done\n` would suffice,
- the host writes one byte into the pipe,
- and then the container process continues.


**Implementation notes:**

Host and container have different responsibilities.

Host responsibilities inside `ct_run(...)`:
+ validate the config and target program,
+ prepare the syscall policy that will later be installed in the container process.
  In particular, if `cfg->deny_all_syscalls` is nonzero, you should call `ct_disallow_all()` to disallow all syscalls, then, if `allowed_syscall_count` is greater than zero, you should allow those syscalls specified in the allow list (`cfg->allowed_syscalls[]`) by just calling `ct_allow(...)` on each element in the allow list. Please keep in mind that `ct_disallow_all()` will also clear the current allow list. So you might need to do some extra work before calling it.
+ allocate stack space for the container process. We provide you with a macro `CT_STACK_SIZE` defining the stack size, and you should use it. 
+ create a pipe for synchronization. 
+ use `pipe2(...)` rather than plain `pipe(...)` so you can create the pipe
  with `O_CLOEXEC` flag set immediately; this avoids leaking the pipe file
  descriptors across a later `execvp(...)` if something goes wrong,
+ call `clone(...)` with flags `CLONE_NEWNS | CLONE_NEWPID | SIGCHLD`,
  + when calling `clone(...)`, pass the child entry function (`ct_core`), and pass a pointer near the top of the allocated stack buffer as the child stack argument; conceptually, the second `clone(...)` parameter is the memory address the child should use as its initial stack,
  + also pass a context object that contains everything the child will need after it starts, such as the config pointer, target `argv`, and the synchronization pipe,
+ after `clone()` succeeds, just print `"container prep done\n"`.
+ write to the pipe to wake the container process,
+ wait for the container process with `waitpid(...)`,
+ return the child's exit status if it exits normally; otherwise return -1.

Don't forget to do error handling on all the above steps.

Container responsibilities inside `ct_core(...)`:
- wait on the pipe,
- after the host signals readiness, call `enter_rootfs(...)`,
- then mount the proc filesystem,
- then install the seccomp filter by `install_seccomp_filter()`,
- and finally call `execvp(...)` on the target program stored in `ctx->argv`.

One more important requirement is correct error handling and cleanup. In
`ct_run(...)`, many host-side operations can fail: `pipe2(...)`, `malloc(...)`,
`clone(...)`, `write(...)`, and `waitpid(...)` are all examples. Your code
should not just detect failure; it should also clean up any resources that were
already created before returning an error.

In other words, each failure path should undo whatever work was already done up
to that point. This is part of implementing a robust container runtime.


### 4. Preparing runtime for anonymous binaries
Now that you have finished your container runtime (`enter_rootfs()`, `mount_proc()`, 
`ct_core()` and `ct_run()`), it would be helpful to take a look at `solution/main.c`,
which provides an example to get the container runtime running.

```shell
# Compile the mini container program and make sure compilation passed
cd ./solution && make 

# Generate a rootfs to be used by our mini container
./scripts/build-normal-rootfs.sh
# After running this script, the rootfs will be created and locates in solution/normal_rootfs

# Start the mini container in interactive mode
./mini-container -it --root ./normal_rootfs
# Then, you will enter the container and try cd, or ls. 
# Exit by Ctrl+d. Don't worry if you see something like "/bin/sh: 1: Cannot set tty process group (No such process)"

# The following command will enter container and run `ls /`
./mini-container --root ./normal_rootfs -- /bin/ls /

# The following command will enter the container and run program /bin/bin2
./mini-container --root ./normal_rootfs -- /bin/bin2
```

If you can do the above without errors, it is also a good time to run the test script `run-tests.sh` in `tests/`. It is expected to pass tests 1 to 12.


Then, you could start the final part of this project - preparing
runtime for 4 anonymous programs in `solution/binary`. We provide the source code
for `bin1.c` through `bin4.c`, along with 4 runtime files similar to `main.c`,
`solution/runtime_1.c`, ... `solution/runtime_4.c`. They have the same skeleton
code for you to start with.

You should compile the anonymous programs locally, and the binaries will be in `solution/binary/build` directory, 
```shell
cd solution/binary
make
```

then run `strace` on the resulting executables to analyze what syscalls they invoke:
```shell
# Make sure you are in build directory, or otherwise bin2 will fail.
cd build

# Run strace on the binaries, and make sure `+++ exited with 0 +++` is printed.
strace -f ./bin1
strace -f ./bin2
strace -f ./bin3
strace -f ./bin4
```

Based on the output of `strace`, you should finish the 4 runtime files. For instance, `solution/runtime_3.c` should prepare a runtime such that `bin3` can run successfully without error after you build it from `solution/binary/bin3.c`.

All 4 runtime have `ct_disallow_all()` invoked by default, and you **should not modify it**. We have 
scripts checking that. Your job is to fill in `ct_allow()` function(s), to allow the syscalls
based on your analysis on the locally built programs using `strace`.

**Implementation notes:**
- You should run `strace` by following the instructions, and analyze the output.
- Then, finish `solution/runtime_1/2/3/4.c` files by just adding `ct_allow(...)` with syscall numbers.
- To determine a syscall number: say, `brk()` is invoked, then `SYS_brk` is its syscall number. You could also check this [website](https://filippo.io/linux-syscall-table/). Please keep in mind that `SYS_` should be capitalized.
- However, due to architecture issues, the same syscall might be different on different architectures like ARM and X86_64. We have provided you with a header file `solution/runtime_syscalls.h`. Please read it carefully. For instance, if you are on X86 and see a syscall `mkdir`, it could be `mkdirat` on ARM - in this case, instead of using `SYS_mkdir` or `SYS_mkdirat`, you should use `CT_SYSCALL_MKDIR` as the syscall number. All the syscalls in this project that are different on architectures are defined in `runtime_syscalls.h`, and you should use the syscall numbers defined in it.

Also note that the tests are not only checking whether your runtime can make
the target binary run successfully. A solution that simply allows a very large
number of syscalls is not considered correct for this project. In particular,
the tests include an upper bound on how many syscalls you are allowed to add.
So, your goal is to allow only the syscalls that are actually needed by each
binary, rather than adding many extra syscalls "just to be safe."

We also provide you with a script to test your runtime. You can test one specific runtime, say `runtime_1` by:

```bash
cd solution/scripts
./run-test-binary.sh -t 1
```

To test all 4 runtime:

```bash
cd solution/scripts
./run-test-binary.sh
```

Also note that the provided `Makefile` uses `-Werror`. This means compiler
warnings are treated as errors, so your tests may fail if your code still
produces warnings. **It is a good idea to run `make` yourself first and ensure that your code compiles cleanly without errors or warnings.**

## 5. Suggested Workflow:
1. Understand how to use `strace` to track all syscalls invoked by a program.
2. Understand how to mount a file system.
3. Finish `enter_rootfs()` and `mount_proc()`
4. Understand `ct_allow()`, `ct_disallow_all()`, and `install_seccomp_filter()` APIs
5. Finish `ct_core()` and `ct_run()`
6. Run autograder and make sure tests 1-12 passed.
7. Get your container running by following section 5. Preparing runtime for anonymous binaries
8. Finish the 4 runtime for anonymous programs.
