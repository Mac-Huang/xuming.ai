CC = gcc
CFLAGS-common = -std=gnu18 -Wall -Wextra -Werror -pedantic
CFLAGS = $(CFLAGS-common) -O2
CFLAGS-dbg = $(CFLAGS-common) -Og -ggdb
TARGET = wsh
SRC = $(TARGET).c parser.c
all: $(TARGET) $(TARGET)-dbg

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) $^ -o $@

$(TARGET)-dbg: $(SRC)
	$(CC) $(CFLAGS-dbg) $^ -o $@

clean:
	rm -f $(TARGET) $(TARGET)-dbg *.o
