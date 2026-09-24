IVERILOG ?= iverilog
VVP ?= vvp
PYTHON ?= python3
IVERILOG_FLAGS ?= -g2001

BUILD_DIR := build

RTL_SRCS := \
	rtl/cache.v \
	rtl/hart.v \
	rtl/decode.v \
	rtl/execute.v \
	rtl/memory.v \
	rtl/writeback.v

LIB_SRCS := \
	lib/alu.v \
	lib/alu_control_unit.v \
	lib/imm.v \
	lib/rf.v

TESTS := \
	unit_alu \
	unit_alu_control_unit \
	unit_imm \
	unit_rf \
	unit_writeback \
	unit_memory \
	unit_execute \
	unit_decode \
	unit_hart \
	hart_cpi

unit_alu_TOP := unit_alu_tb
unit_alu_SRCS := tests/unit_alu_tb.v lib/alu.v

unit_alu_control_unit_TOP := unit_alu_control_unit_tb
unit_alu_control_unit_SRCS := tests/unit_alu_control_unit_tb.v lib/alu_control_unit.v

unit_imm_TOP := unit_imm_tb
unit_imm_SRCS := tests/unit_imm_tb.v lib/imm.v

unit_rf_TOP := unit_rf_tb
unit_rf_SRCS := tests/unit_rf_tb.v lib/rf.v

unit_writeback_TOP := unit_writeback_tb
unit_writeback_SRCS := tests/unit_writeback_tb.v rtl/writeback.v

unit_memory_TOP := unit_memory_tb
unit_memory_SRCS := tests/unit_memory_tb.v rtl/memory.v

unit_execute_TOP := unit_execute_tb
unit_execute_SRCS := tests/unit_execute_tb.v rtl/execute.v lib/alu_control_unit.v lib/alu.v

unit_decode_TOP := unit_decode_tb
unit_decode_SRCS := tests/unit_decode_tb.v rtl/decode.v lib/rf.v lib/imm.v

unit_hart_TOP := unit_hart_tb
unit_hart_SRCS := tests/unit_hart_tb.v rtl/tb_memory.v $(RTL_SRCS) $(LIB_SRCS)

hart_cpi_TOP := hart_tb
hart_cpi_SRCS := tb/tb.v rtl/tb_memory.v $(RTL_SRCS) $(LIB_SRCS)

.PHONY: all test clean hart-grade run-hart_grade $(addprefix run-,$(TESTS))

all: test

test: $(addprefix run-,$(TESTS))

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

define MAKE_TEST_RULES
$(BUILD_DIR)/$(1).out: $$($(1)_SRCS) | $(BUILD_DIR)
	$(IVERILOG) $(IVERILOG_FLAGS) -s $$($(1)_TOP) -o $$@ $$^

run-$(1): $(BUILD_DIR)/$(1).out
	$(VVP) $$<
endef

$(foreach t,$(TESTS),$(eval $(call MAKE_TEST_RULES,$(t))))

hart-grade run-hart_grade:
	$(PYTHON) tests/test_hart.py

clean:
	rm -rf $(BUILD_DIR)
