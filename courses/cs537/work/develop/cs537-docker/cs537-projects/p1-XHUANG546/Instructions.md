---
title: CS 537 Project 1
layout: default
---

## Sort-k
In this assignment, you will write a command line program that sorts sentences by the k-th word.

Learning Objectives:

* Re-familiarize yourself with the C programming language
* Familiarize yourself with a shell / terminal / command-line of Linux
* Learn about file I/O, string processing, and simple data structures in C

Summary of what gets turned in:
* One `.c` file: `sortk.c`
* It is mandatory to compile your code with following flags `-O2 -Wall -Wextra -Werror -pedantic -o sortk`.
    * Check `man gcc` and search for these flags to understand what they do and why you will like them.
    * It is a good idea to create a `Makefile` so you just type `make` for the compilation.
    * We are trying to use the most recent version of the C language. However, the compiler (`gcc` on lab machines) does not support final C23 specification, which is the most recent one. So we are using the second most recent (C17).
    * `-std=c17` is not required.
* It should (hopefully) pass the tests we supply.
* Include a single `README.md` inside `solution` directory describing the implementation. This file should include your name, your cs login, you wisc ID and email, and the status of your implementation. If it all works then just say that. If there are things you know doesn't work let me know.

__Before beginning__: Read this [lab tutorial](http://pages.cs.wisc.edu/~remzi/OSTEP/lab-tutorial.pdf); it has some useful tips for programming in the C environment.

## Sort-k
The program you will build is called `sortk`. It sorts a file of sentences and prints the result to STDOUT.

### Command-line interface
```
./sortk [-u] <input_file> <k>
```

- `k` is a 4-byte signed integer in the range `[-2^31, 2^31-1]`, but **must not be 0**.
- If `-u` is provided, print only **unique** sentences after sorting (see below).

Examples:
```bash
$ ./sortk input.txt 7
$ ./sortk input.txt -1
$ ./sortk -u input.txt 3
```

### Sorting rules
Each line of the input file is a “sentence” (a sequence of words separated by spaces).

1) **Primary key: the k-th word**
- If `k > 0`: use the **k-th word from the start** (1-indexed).  
  Example: `k=1` means the first word.
- If `k < 0`: use the **|k|-th word from the end**.  
  Example: `k=-1` means the last word, `k=-2` means the second-to-last word, and so on.

For any given run, if a sentence is shorter than |k| words, it must be dropped and not printed to the output.

2) **Ties**
If two sentences have the same k-th word, break ties by comparing the sentences
**lexicographically word-by-word starting from the first word**, then second word, etc.
If one sentence is a prefix of the other (all its words match but it runs out of words),
the shorter sentence comes first.

Sorting is based on lexicographical order.

### Unique mode (`-u`)
If `-u` is provided, after sorting, only print unique sentences where “duplicate” means:
- the full sentence string is exactly identical (same characters)

When `-u` is used, keep the first occurrence in **sorted order** and omit later duplicates.

### Output formatting
When printing the output, every printed sentence should have a newline character at the end. Between each two words there should be **exactly one space**. After the last word (before the newline character), there should **NOT** be any spaces.

## File formats and Example Run
Here is the sample `input.txt`.

```
$ cat input.txt
sing o goddess the anger of achilles son of peleus that brought countless ills upon the achaeans
many a brave soul did it send hurrying down to hades
many a hero did it yield a prey to dogs and vultures
for so were the counsels of jove fulfilled from the day on which the son of atreus king of men
and great achilles first fell out with one another
and which of the gods was it that set them on to quarrel
```

Here's a sample command with its output:
```
$ ./sortk input.txt 1
and great achilles first fell out with one another
and which of the gods was it that set them on to quarrel
for so were the counsels of jove fulfilled from the day on which the son of atreus king of men
many a brave soul did it send hurrying down to hades
many a hero did it yield a prey to dogs and vultures
sing o goddess the anger of achilles son of peleus that brought countless ills upon the achaeans
```

* Sentences are separated by `\n`.
* **Sentences only contain lowercase alphabet letters and whitespaces (0x20).**
* There will not be any empty string (no empty input file, no consecutive `\n`).
* You must not assume a maximum limit to the number of words, number of sentences, or number of characters in a sentence.
* There will not be any trailing spaces at the end of the sentences.
* In each input file, there is **exactly one space** between each two consecutive words.

## Possible outputs
- If `k` is not an integer, exit with return code 1.
- If `k` is 0, exit with return code 1.
- All other errors (wrong number of arguments, open file failed, etc.) should exit with code 1.
- In case of an error, both stderr and stdout should be empty. It means that you must not print anything, just return the error codes given above.

## Tips
- When working with any C library functions, check their manual page (`man`) for a description and proper usage, e.g. `man 3 fopen`.
- To work with files, look at `man 3 fopen` and `man 3 fclose`.
- To read data from files, consider using `getline(3)`, `fgets(3)`, or maybe `scanf(3)`.
- Printing to the terminal can be done with `printf(3)`.
- You don't know the number of sentences, words, and characters ahead of time, so you will need to dynamically allocate memory.
- To sort an array of data, you can use `qsort(3)`. Also, you can implement your own way to sort.
