---
title: CS 537 Project 3
layout: default
---
> [!important]
> * This project will be checked for memory leaks. Make sure you free all the memory you allocate.
> * This project will have a code review. Make sure you understand the code you write and are able to explain it.

## Unix Shell
In p2 you implemented a system call. In this project you will utilize system calls to allow users to interact with the operating system. The shell is a program that reads commands from the user and executes them. These commands can be built-in commands or external programs.

Learning Objectives:

* Understand how processes are created, destroyed, and managed.
* Know how processes communicate among each other via pipes.
* Understand environment variables and their role in process execution.


Your submission:
* Should (hopefully) pass the tests we supply.
* **Will be tested in the CS537-Docker environment.** We recommend you use this environment for your testing too.
* Update the [README.md](solution/README.md) inside [solution](solution/) directory to describe your implementation. This file should include your name, your cs login, you wisc ID and email, and the status of your implementation. You are encouraged to use it to document your design decisions and any issues you faced.
* **Provided Code**: You are provided with a parser ([parser.c](solution/parser.c) and [parser.h](solution/parser.h)). You can use this parser to parse your input (it should simplify things for you significantly). It is recommended that you go through the parser code to understand how it works. Feel free to modify it if needed.

## Project Overview

In this project you will build a command line interpreter (CLI) or *shell*. The shell operates in two modes:

*   **Interactive Mode**: When run without arguments, your shell displays a prompt (`wsh> `) and waits for user input.
*   **Batch Mode**: When run with a single filename argument, the shell reads commands from the file without printing a prompt. You may not assume that the batch script ends with an `exit` command. The shell should exit when it reaches the end of the file.

### What is a Shell?
A shell is a program that acts as a command line interpreter. It reads commands from the user (via the keyboard or a script) and executes them. It serves as the primary interface between the user and the operating system.

**Basic Shell Loop:**
The core logic of a shell is a simple loop:
1.  **Read**: Get the next command line from the user/file.
2.  **Parse**: Break the command line into arguments, handle quotes, pipes, and variables.
3.  **Execute**: Run the parsed command.

**Example Session:**
```
wsh> ls
Makefile  wsh.c  wsh.h
wsh> echo hello "world"
hello world
```

Parsing command lines can be tricky (e.g., handling `"quoted arguments"`, `escaped\ characters`, and `|` pipes). To let you focus on process management and system calls (the main learning objectives), we provide a parser in [parser.c](solution/parser.c) and [parser.h](solution/parser.h). You just need to call `parse_input()` after reading the command line and then execute the returned structure.

### Task 1: Understand the Provided Parser
The `solution` folder already contains a simple parser in [parser.c](solution/parser.c) and [parser.h](solution/parser.h).

*   Inspect `parser.h` to understand the structures (`command_line`, `pipeline`, `command`).
*   The parser handles:
    *   Splitting lines into pipelines (separated by `;`).
    *   Splitting pipelines into commands (separated by `|`).
    *   Splitting commands into arguments.
    *   Handling quotes (`'` and `"`).
    *   Handling escapes (`\`).
    *   **Variable Substitution**: It calls your `get_variable` hook (feature discussed later).

    **Sample Command**: `ls -l`
    *   **Parser Output**: The parser converts this string into a `command` structure where `argv[0]` is `"ls"` and `argv[1]` is `"-l"`. Matches quotes and handles spacing for you.

### Task 2: Basic Shell Loop & Execution
Implement the main loop in `wsh.c` that:
1.  Prints the prompt `wsh> ` (if interactive).
2.  Reads a line of input.
3.  Parses the input.
4.  Executes the parsed commands.

**Behavior**: When you run `./wsh`, it should print the prompt `wsh> ` and wait for the user to type a command. If the user types `ls`, it reads that line and proceeds to parse and execute it. More on how to execute commands in the next task.

### Task 3: External Programs
You must support running **External Programs** (e.g., `ls`, `cp`, `cat`, `echo`, etc.).
*   Use `fork()`, `execv()`, and `waitpid()` (or `wait`). 
*   **Path Resolution**:
    *   **Environment Variables**: The shell maintains a list of *environment variables*, which are key-value pairs (e.g., `USER=johndoe`). A specific environment variable, `PATH`, contains a list of directories separated by colons (e.g., `/bin:/usr/bin`).
    *   **Searching**: When the user types a command like `ls`, you must search each directory (*in-order*) in the `PATH` checking if there is an executable file named `ls`. The first match is the one that should be executed.
    *   **System Calls**: For this project, you should **not use** `execvp` (which searches for you). Instead, use `execv` combined with your own search logic (use `access()` with `X_OK` to check existence/permissions, check `man access` for more information).
    *   If `PATH` is not set, initialize it to `/bin`.
    * **NOTE**: If the executable starts with a `/`, treat it as an absolute path and it should be executed directly without searching the `PATH`.

    **Sample Command**: `ls`
    *   **Behavior**: The shell searches the `PATH` (e.g., `/bin:/usr/bin`) for an executable named `ls`. It finds `/bin/ls`, fork/execs it, and waits for it to finish. The user sees the file listing of the current directory.

### Task 4: Built-in Commands
Implement the following built-in commands, executed directly by the shell - not in a child process. Built-in commands are prioritized over external programs, i.e. if a user types a command that is the same as a built-in command, the built-in command should be executed not the external program.

*   `exit`:
    *   **Behavior**: Terminates the shell by calling the `exit()` system call.
    *   **Arguments**: Ignores any arguments.
*   `cd [dir]`:
    *   **Behavior**: Changes the current working directory by calling the `chdir()` system call. Supports both absolute (starts with `/`) and relative paths (does not start with `/`, can use `.` and `..`).
    *   **No Args**: Defaults to the path specified by the environment variable `HOME`.
        *   **Error**: If `HOME` is not set, print `cd: HOME not set` to stderr and return 1.
    *   **Error**: If `chdir` fails (e.g., dir does not exist), call `perror("cd")` and return 1.
*   `env [VAR=val]`:
    *   **No arguments**: Prints **all** environment variables. (*Hint*: `man environ`)
    *   **With arguments**:
        *   `env VAR=val`: Sets `VAR` to `val`.
        *   `env VAR`: Sets `VAR` to empty string.
        *   **Error**: If `setenv` fails, call `perror("setenv")`.

    **Sample Command**: `cd /tmp`
    *   **Behavior**: The shell parses `cd` and `/tmp`. It identifies `cd` as a built-in. It calls `chdir("/tmp")`. Subsequent commands (like `ls`) will now run in `/tmp`.

### Task 5: Environment Variables
*   **What are they?**: Environment variables are variables inherited by child processes. When your shell forks a child process, it gets a copy of your shell's environment variables.
*   **Management**:
    *   Use the `env` built-in (Task 3) to set variables.
    *   You must use the `setenv()` system call to modify variables in your shell (so they can be inherited by future children).
*   **Substitution (`$VAR`)**:
    *   **Hook**: Implement `get_variable(const char *var)` in `wsh.c`. When the parser encounters a `$VAR`, it will call this function to get the value of `VAR`. 
    *   **Edge Case**: If `getenv` returns NULL, return an empty string `""`.

    **Sample Command**: `echo $USER`
    *   **Behavior**: The parser detects `$USER`, calls `get_variable("USER")`, receives "pavan" (for example), and replaces `$USER` with `pavan`. The shell then executes `echo pavan`.

### Task 6: Pipelines
*   **Syntax**: `command1 | command2 | ... | commandN`.
*   **Chain Length**: Pipelines can contain more than two commands.
    *   Example: `cat file.txt | grep "search" | wc -l` (3 commands).
    *   **Limit**: You may assume a maximum of 128 commands in a single pipeline.
*   **Execution**:
    *   Call `pipe()` to create a pipe.
    *   `fork()` for each command.
    *   Use `dup2()` to redirect stdout of left command to write-end of pipe.
    *   Use `dup2()` to redirect stdin of right command to read-end of pipe.
    *   **Close** unused file descriptors!
*   **Simultaneous Exection**: All commands run at the same time.
*   **Waiting**: The shell must wait for **all** child processes in the pipeline to finish.
*   **Edge Case**: `fork` or `pipe` failure -> call `perror` and exit with 1.
*   **Built-in Commands**: If a built-in command (e.g., `cd`, `exit`) is part of a pipeline, it must be executed in the child process. This means it will not affect the parent shell (e.g., `cd` in a pipeline will not change the shell's cwd).

For more information and examples, see [Supporting Pipelines](pipelines.md).

    **Sample Command**: `ls | wc -l`
    *   **Behavior**: The shell creates two child processes connected by a pipe. `ls` writes its output to the pipe's write-end. `wc -l` reads its input from the pipe's read-end. The result is the count of files in the directory.

## Errors and Edge Cases
You must handle the following specific error conditions:

1.  **Command Not Found**:
    *   If `execv` fails, print `Command not found` to stderr and `exit(1)` (in the child process).
2.  **Batch Mode Errors**:
    *   **File Not Found**: If `fopen` fails, call `perror("fopen")` and exit with 1.
    *   **Invalid Usage**: If >1 argument provided, print `Usage: ./wsh [file]` to stderr and exit with 1.
3.  **System Call Failures**:
    *   Check return values of `malloc`, `fork`, `execv`, `pipe`, `dup2`.
    *   On failure, use `perror("function_name")` (e.g., `perror("fork")`).
4.  **Empty Lines/Comments**:
    *   The parser handles these, checking for empty strings or lines starting with `#`. You should just ensure your loop handles `parse_input` returning NULL gracefullly.
5.  **Arbitrary Line Length**:
    *   You should support lines of any length. Do not use a fixed-size buffer. Either use `getline` or dynamically allocate memory to store the input line.

## Testing Your Implementation

You are expected to write test scripts to verify that your implementation works correctly.
We have provided a testing script `tests/run-tests.sh`.

### Running Tests
To run the provided tests:
1.  Navigate to the `tests/` directory.
2.  Run `./run-tests.sh`.


**It is recommended that you test your implementation incrementally as you go.** Look out for memory leaks using `valgrind`.

## Suggested Workflow

-   **Step 1**: Get `wsh` to compile and run the main loop (prompt/exit).
-   **Step 2**: Implement basic program execution (argument parsing is done for you!).
-   **Step 3**: Implement `cd` and `exit`.
-   **Step 4**: Implement `env` and `get_variable` hook.
-   **Step 5**: Implement `PATH` resolution.
-   **Step 6**: Implement Pipelines (`|`).
-   Test incrementally!

## Notes and Hints

-   **Memory Management**: This project will be checked for memory leaks using `valgrind`. Make sure to free all allocated memory. Use `valgrind --leak-check=full ./wsh` to check for memory leaks.
-   **Error Handling**: Print errors to `stderr`. Use `perror` for system call failures.
-   **Parser**: Understand the parser before implementing your solution. It does most of the string processing work for you.
-   **Development Environment**: Use the provided Docker container to ensure your code runs in the expected environment.

## References and Resources

For detailed information on the system calls and concepts used in this project, refer to the following chapters from [OSTEP](https://pages.cs.wisc.edu/~remzi/OSTEP/):

### Process Creation and Execution
-   **Chapter 5: [Process API](https://pages.cs.wisc.edu/~remzi/OSTEP/cpu-api.pdf)** - Essential reading for understanding `fork()` and `exec()` family of system calls.
    -   Covers how processes are created with `fork()`
    -   Explains the `exec()` family (`execv()`, `execvp()`, etc.) for running programs. For this project you should use `execv()`, not `execvp()`. You are expected to implement the path resolution yourself.
    -   Includes the `wait()` and `waitpid()` system calls for process synchronization
    -   [Code examples](https://github.com/remzi-arpacidusseau/ostep-code/tree/master/cpu-api) demonstrating these concepts

### Interprocess Communication Using Pipes
-   **Man Pages** (Essential reading for pipes):
    -   `man 2 pipe` - The `pipe()` system call for creating a unidirectional data channel
    -   `man 7 pipe` - Overview of pipes and FIFOs, including I/O semantics and capacity
    -   `man 2 dup2` - Duplicating file descriptors to redirect stdin/stdout

### Man Pages
Don't forget to use the manual pages for detailed API documentation:
-   `man 2 fork` - Process creation
-   `man 3 exec` - Execute a program (see also `execv`, `execvp`)
-   `man 2 pipe` - Create a pipe
-   `man 7 pipe` - Overview of pipes and FIFOs, including I/O semantics and capacity
-   `man 2 dup2` - Duplicate file descriptors
-   `man 2 wait` - Wait for process to change state
-   `man 3 getenv` - Get environment variable
-   `man 3 setenv` - Set environment variable
