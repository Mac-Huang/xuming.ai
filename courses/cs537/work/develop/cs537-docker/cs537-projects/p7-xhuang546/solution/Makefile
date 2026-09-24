CC = gcc
CFLAGS = -Wall -Wextra -Werror -O2 -g

all: mini-container libcontainer.a

mini-container: main.o container.o
	$(CC) $(CFLAGS) -o $@ main.o container.o

libcontainer.a: container.o
	ar rcs $@ container.o

main.o: main.c container.h
	$(CC) $(CFLAGS) -c main.c -o $@

container.o: container.c container.h
	$(CC) $(CFLAGS) -c container.c -o $@

clean:
	rm -f mini-container libcontainer.a main.o container.o
	rm -rf normal_rootfs
