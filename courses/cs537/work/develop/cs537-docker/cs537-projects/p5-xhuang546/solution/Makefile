CC = gcc
CFLAGS = -Wall -Wextra -O2 -pthread

all: threadpool.o bst.o

threadpool.o: threadpool.c threadpool.h
	$(CC) $(CFLAGS) -c threadpool.c -o threadpool.o

bst.o: bst.c bst.h
	$(CC) $(CFLAGS) -c bst.c -o bst.o

clean:
	rm -f threadpool.o bst.o
