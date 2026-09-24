#! /bin/bash

infile=$1
testnames=$2

gawk -vtestnames=$testnames '
($1 == "_mkdir\\") {
  n = split(testnames, x, ",");
  for (i = 1; i <= n; i++) {
    printf("\t_%s\\\n", x[i]);
  }
}

/^QEMUOPTS[[:space:]]*=/ {
  print $0;
  print "sdir := $(notdir $(abspath $(dir $(CURDIR))))";
  next;
}

{
  gsub("/dev/shm/ivshmem1", "/dev/shm/$(sdir)-ivshmem1");
  gsub("/dev/shm/ivshmem",  "/dev/shm/$(sdir)-ivshmem");
  print $0;
}' $infile
