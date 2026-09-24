Name: Xuming Huang
CS Login: xuming
wisc ID: xhuang546
email: xhuang546@wisc.edu
status: done and pass all tests

## Implementation

First, I implemented the Interactive/Batch Mode detection based on the number of arguments. However, during the test, I found it can have one argument as well in batch mode. Thus, I set the `interactive` bit only if reading from a terminal.

Then enter the shell loop implementation: Read command line -> Parse the command into arguments -> Execute the command
Specifially in the execution, I have to iterate command lines -> pipelines -> commands due to the structure of command line. What worth to mention is that I needed to seperate pipeline and single command here with two different interface: `run_cmd(cmd)` and `run_ppl(pl)`, because they have different design of data I/O and processes forking.

`run_cmd(cmd)` is relatively easy thanks to one fork while `run_ppl(pl)` needs to be considered with 2 things when I design it:
    1. pipe: Due to the pipeline structure, file descriptor fields should be modified with the help of `dup2()`: if there is a previous pipe, connect it to stdin; if not last command, connect stdout to current pipe write end. By the way, we need to close useless fds in child.
    2. Instead of letting parent just `wait()` for all the children, I used a loop to iteratively `waitpid()` in case missing any of them.

Both executions are using a function called `run_external()` which strictly aligned to what instruction told us, nothing fancy. So is the builtin functions.
