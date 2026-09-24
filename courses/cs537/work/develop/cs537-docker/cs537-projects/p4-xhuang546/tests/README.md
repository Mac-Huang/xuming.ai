## Running Tests

You can run all the test cases by simply invoking the `run-tests.sh` script

Some of the test cases to help you get started are given in `tests/tests/`
directory. It holds the expected return code, standard output, and standard
error in files called `n.rc`, `n.out`, and `n.err` (respectively) for each
test `n`.

The files needed to describe a test number `n` are:
- `n.rc`: The return code the program should return (usually 0 or 1)
- `n.out`: The standard output expected from the test
- `n.err`: The standard error expected from the test
- `n.run`: How to run the test (which arguments it needs, etc.)
- `n.desc`: A short text description of the test
- `n.pre` (optional): Code to run before the test, to set something up
- `n.post` (optional): Code to run after the test, to clean something up

There is also a single file called `pre` which gets run once at the 
beginning of testing; this is often used to do a more complex build
of a code base, for example. To prevent repeated time-wasting pre-test
activity, suppress this with the `-s` flag (as described below).

The options for `run-tests.sh` include:
* `-h` (the help message)
* `-v` (verbose: print what each test is doing)
* `-t n` (run only test `n`)
* `-c` (continue even after a test fails)
* `-d` (run tests not from `tests/` directory but from this directory instead)
* `-s` (suppress running the one-time set of commands in `pre` file)

## Adding New Tests

The testing framework just starts at `1` and keeps incrementing
tests until it can't find any more or encounters a failure. Thus, adding new
tests is easy; All files mentioned below should be added in the `tests/tests/`
directory.

1. Add `test_n.c` (this will have the main function which would like to invoke
to test your code)
2. Add  `n.rc`, `n.out`, and `n.err` based on intended behaviour
3. Modify `pre` by adding your test in the first command and adding a command to
copy your file (follow what is done for `test_1`)

Now running `run-tests.sh` should call your newly added test too!
You can verify that by passing flag -t with value `n` (n is the number of the
test case you just added).

## Note

There are two additional scripts, `edit-makefile.sh` and `run-xv6-command.exp`.
The second one is an [`expect`](https://en.wikipedia.org/wiki/Expect) script 
which launches the qemu emulator and runs the relevant testing command in the 
xv6 environment before automatically terminating the test. 
You would generally not need to modify these to add your own test cases.
