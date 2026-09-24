# Compiler and tools
CC      := riscv64-unknown-elf-gcc
QEMU    := qemu-riscv32

# Compiler and linker flags
CFLAGS  := -march=rv32i -mabi=ilp32 -O3 -Wall -Werror
LDFLAGS := -static

# Sources and targets
UMUL_SRCS := umul.s umul_harness.c
DOT_SRCS  := dot.c dot_harness.c umul.s
UMUL      := umul
DOT       := dot
RESULTS   := results.json

# Default target builds both executables
all: $(UMUL) $(DOT)

# Build umul executable
$(UMUL): $(UMUL_SRCS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

# Build dot executable
$(DOT): $(DOT_SRCS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

# Clean build artifacts
clean:
	rm -f $(UMUL) $(DOT) $(RESULTS)

# Run executables with QEMU
run-umul: $(UMUL)
	$(QEMU) ./$(UMUL)

run-dot: $(DOT)
	$(QEMU) ./$(DOT)

# Test targets with pytest
test-umul: $(UMUL)
	pytest umul.py

test-dot: $(DOT)
	pytest dot.py

.PHONY: all clean run-umul run-dot test-umul test-dot
