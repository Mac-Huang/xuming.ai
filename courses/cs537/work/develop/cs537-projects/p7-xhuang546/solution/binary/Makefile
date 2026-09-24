CC = gcc
CFLAGS = -Wall -Wextra -O2 -g
LDFLAGS = -static

BUILD_DIR = build

PROGRAMS = \
	$(BUILD_DIR)/bin1 \
	$(BUILD_DIR)/bin2 \
	$(BUILD_DIR)/bin3 \
	$(BUILD_DIR)/bin4

BIN2_INPUT = $(BUILD_DIR)/bin2_input.txt

all: $(PROGRAMS) $(BIN2_INPUT)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/bin1: bin1.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

$(BUILD_DIR)/bin2: bin2.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

$(BUILD_DIR)/bin3: bin3.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

$(BUILD_DIR)/bin4: bin4.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<

$(BIN2_INPUT): | $(BUILD_DIR)
	printf 'sample payload for bin2\n' > $@

clean:
	rm -rf $(BUILD_DIR)
