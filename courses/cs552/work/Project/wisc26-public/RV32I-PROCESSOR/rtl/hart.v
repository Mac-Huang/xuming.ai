`default_nettype none

module hart #(
    // After reset, the program counter (PC) should be initialized to this
    // address and start executing instructions from there.
    parameter RESET_ADDR = 32'h00000000
) (
    // Global clock.
    input  wire        i_clk,
    // Synchronous active-high reset.
    input  wire        i_rst,
    // Instruction fetch goes through a read only instruction memory (imem)
    // port. The port accepts a 32-bit address (e.g. from the program counter)
    // per cycle and sequentially returns a 32-bit instruction word. For
    // projects 6 and 7, this memory has been updated to be more realistic
    // - reads are no longer combinational, and both read and write accesses
    // take multiple cycles to complete.
    //
    // The testbench memory models a fixed, multi cycle memory with partial
    // pipelining. The memory will accept a new request every N cycles by
    // asserting `mem_ready`, and if a request is made, the memory perform
    // the request (read or write) after M cycles, asserting mem_valid to
    // indicate the read data is ready (or the write is complete). Requests
    // are completed in order. The values of N and M are deterministic, but
    // may change between test cases - you must design your CPU to work
    // correctly by looking at `mem_ready` and `mem_valid` rather than
    // hardcoding a latency assumption.
    //
    // Indicates that the memory is ready to accept a new read request.
    input  wire        i_imem_ready,
    // 32-bit read address for the instruction memory. This is expected to be
    // 4 byte aligned - that is, the two LSBs should be zero.
    output wire [31:0] o_imem_raddr,
    // Issue a read request to the memory on this cycle. This should not be
    // asserted if `i_imem_ready` is not asserted.
    output wire        o_imem_ren,
    // Indicates that a valid instruction word is being returned from memory.
    input  wire        i_imem_valid,
    // Instruction word fetched from memory, available sequentially some
    // M cycles after a request (imem_ren) is issued.
    input  wire [31:0] i_imem_rdata,

    // Data memory accesses go through a separate read/write data memory (dmem)
    // that is shared between read (load) and write (stored). The port accepts
    // a 32-bit address, read or write enable, and mask (explained below) each
    // cycle.
    //
    // The timing of the dmem interface is the same as the imem interface. See
    // the documentation above.
    //
    // Indicates that the memory is ready to accept a new read or write request.
    input  wire        i_dmem_ready,
    // Read/write address for the data memory. This should be 32-bit aligned
    // (i.e. the two LSB should be zero). See `o_dmem_mask` for how to perform
    // half-word and byte accesses at unaligned addresses.
    output wire [31:0] o_dmem_addr,
    // When asserted, the memory will perform a read at the aligned address
    // specified by `i_addr` and return the 32-bit word at that address
    // immediately (i.e. combinationally). It is illegal to assert this and
    // `o_dmem_wen` on the same cycle.
    output wire        o_dmem_ren,
    // When asserted, the memory will perform a write to the aligned address
    // `o_dmem_addr`. When asserted, the memory will write the bytes in
    // `o_dmem_wdata` (specified by the mask) to memory at the specified
    // address. It is illegal to assert this and `o_dmem_ren` on the same
    // cycle.
    output wire        o_dmem_wen,
    // The 32-bit word to write to memory when `o_dmem_wen` is asserted. When
    // write enable is asserted, the byte lanes specified by the mask will be
    // written to the memory word at the aligned address at the next rising
    // clock edge. The other byte lanes of the word will be unaffected.
    output wire [31:0] o_dmem_wdata,
    // The dmem interface expects word (32 bit) aligned addresses. However,
    // the processor supports byte and half-word loads and stores at unaligned
    // and 16-bit aligned addresses, respectively. To support this, the access
    // mask specifies which bytes within the 32-bit word are actually read
    // from or written to memory.
    //
    // To perform a half-word read at address 0x00001002, align `o_dmem_addr`
    // to 0x00001000, assert `o_dmem_ren`, and set the mask to 0b1100 to
    // indicate that only the upper two bytes should be read. Only the upper
    // two bytes of `i_dmem_rdata` can be assumed to have valid data; to
    // calculate the final value of the `lh[u]` instruction, shift the rdata
    // word right by 16 bits and sign/zero extend as appropriate.
    //
    // To perform a byte write at address 0x00002003, align `o_dmem_addr` to
    // `0x00002000`, assert `o_dmem_wen`, and set the mask to 0b1000 to
    // indicate that only the upper byte should be written. On the next clock
    // cycle, the upper byte of `o_dmem_wdata` will be written to memory, with
    // the other three bytes of the aligned word unaffected. Remember to shift
    // the value of the `sb` instruction left by 24 bits to place it in the
    // appropriate byte lane.
    output wire [ 3:0] o_dmem_mask,
    // Indicates that a valid data word is being returned from memory.
    input  wire        i_dmem_valid,
    // The 32-bit word read from data memory. When `o_dmem_ren` is asserted,
    // this will immediately reflect the contents of memory at the specified
    // address, for the bytes enabled by the mask. When read enable is not
    // asserted, or for bytes not set in the mask, the value is undefined.
    input  wire [31:0] i_dmem_rdata,
    // The output `retire` interface is used to signal to the testbench that
    // the CPU has completed and retired an instruction. A single cycle
    // implementation will assert this every cycle; however, a pipelined
    // implementation that needs to stall (due to internal hazards or waiting
    // on memory accesses) will not assert the signal on cycles where the
    // instruction in the writeback stage is not retiring.
    //
    // Asserted when an instruction is being retired this cycle. If this is
    // not asserted, the other retire signals are ignored and may be left invalid.
    output wire        o_retire_valid,
    // The 32 bit instruction word of the instrution being retired. This
    // should be the unmodified instruction word fetched from instruction
    // memory.
    output wire [31:0] o_retire_inst,
    // Asserted if the instruction produced a trap, due to an illegal
    // instruction, unaligned data memory access, or unaligned instruction
    // address on a taken branch or jump.
    output wire        o_retire_trap,
    // Asserted if the instruction is an `ebreak` instruction used to halt the
    // processor. This is used for debugging and testing purposes to end
    // a program.
    output wire        o_retire_halt,
    // The first register address read by the instruction being retired. If
    // the instruction does not read from a register (like `lui`), this
    // should be 5'd0.
    output wire [ 4:0] o_retire_rs1_raddr,
    // The second register address read by the instruction being retired. If
    // the instruction does not read from a second register (like `addi`), this
    // should be 5'd0.
    output wire [ 4:0] o_retire_rs2_raddr,
    // The first source register data read from the register file (in the
    // decode stage) for the instruction being retired. If rs1 is 5'd0, this
    // should also be 32'd0.
    output wire [31:0] o_retire_rs1_rdata,
    // The second source register data read from the register file (in the
    // decode stage) for the instruction being retired. If rs2 is 5'd0, this
    // should also be 32'd0.
    output wire [31:0] o_retire_rs2_rdata,
    // The destination register address written by the instruction being
    // retired. If the instruction does not write to a register (like `sw`),
    // this should be 5'd0.
    output wire [ 4:0] o_retire_rd_waddr,
    // The destination register data written to the register file in the
    // writeback stage by this instruction. If rd is 5'd0, this field is
    // ignored and can be treated as a don't care.
    output wire [31:0] o_retire_rd_wdata,
    output wire [31:0] o_retire_dmem_addr,
    output wire [ 3:0] o_retire_dmem_mask,
    output wire        o_retire_dmem_ren,
    output wire        o_retire_dmem_wen,
    output wire [31:0] o_retire_dmem_rdata,
    output wire [31:0] o_retire_dmem_wdata,
    // The current program counter of the instruction being retired - i.e.
    // the instruction memory address that the instruction was fetched from.
    output wire [31:0] o_retire_pc,
    // the next program counter after the instruction is retired. For most
    // instructions, this is `o_retire_pc + 4`, but must be the branch or jump
    // target for *taken* branches and jumps.
    output wire [31:0] o_retire_next_pc
`ifdef RISCV_FORMAL
    ,`RVFI_OUTPUTS
`endif
);

    // -------------------------------------------------------------------------
    // Global state
    // -------------------------------------------------------------------------
    reg [31:0] pc_cur;
    reg        halted_cur;
    reg        imem_pending_cur;
    reg        imem_pending_kill_cur;
    reg [31:0] imem_pending_pc_cur;
    reg        imem_pending_pred_taken_cur;
    reg [31:0] imem_pending_pred_target_cur;
    wire [31:0] imem_cache_mem_addr_cur;
    wire        imem_cache_mem_ren_cur;
    wire        imem_cache_mem_wen_cur;
    wire [31:0] imem_cache_mem_wdata_cur;
    wire        imem_cache_busy_cur;
    wire [31:0] imem_cache_rdata_cur;
    wire [31:0] dmem_cache_mem_addr_cur;
    wire        dmem_cache_mem_ren_cur;
    wire        dmem_cache_mem_wen_cur;
    wire [31:0] dmem_cache_mem_wdata_cur;
    wire        dmem_cache_busy_cur;
    wire [31:0] dmem_cache_rdata_cur;

    localparam BP_WAYS    = 2;
    localparam BP_SET_W   = 7;
    localparam BP_SETS    = 128;
    localparam BP_TAG_W   = 23;

    reg [BP_SETS - 1:0]   bp_valid0_cur;
    reg [BP_SETS - 1:0]   bp_valid1_cur;
    reg [BP_TAG_W - 1:0]  bp_tags0_cur [BP_SETS - 1:0];
    reg [BP_TAG_W - 1:0]  bp_tags1_cur [BP_SETS - 1:0];
    reg [31:0]            bp_targets0_cur [BP_SETS - 1:0];
    reg [31:0]            bp_targets1_cur [BP_SETS - 1:0];
    reg [1:0]             bp_counters0_cur [BP_SETS - 1:0];
    reg [1:0]             bp_counters1_cur [BP_SETS - 1:0];
    reg [BP_SETS - 1:0]   bp_repl_cur;

    // Gshare direction predictor: separate 1024-entry PHT of 2-bit counters
    // indexed by pc[11:2] XOR bp_ghr_cur[9:0]. Direction prediction comes from
    // this PHT (when the BTB tag matches, so the target is also valid). The
    // BTB itself remains PC-only for tag/target — separating the two avoids
    // counter/target aliasing while still capturing global-history correlation.
    localparam PHT_INDEX_W = 10;
    localparam PHT_ENTRIES = 1 << PHT_INDEX_W;
    reg [1:0]               bp_pht_cur [PHT_ENTRIES - 1:0];
    reg [PHT_ENTRIES - 1:0] bp_pht_valid_cur;
    reg [PHT_INDEX_W - 1:0] bp_ghr_cur;

    // Return Address Stack (RAS). An 8-entry circular stack. Push on JAL
    // with rd in {x1, x5}, pop on JALR with rs1 in {x1, x5} and rd not
    // forming a coroutine-style push (rd != rs1 or rd == x0). The RAS is
    // purely a prediction; mispredicts fall through to the EX-stage redirect.
    localparam RAS_DEPTH = 8;
    reg [31:0] ras_stack_cur [RAS_DEPTH - 1:0];
    reg [2:0]  ras_head_cur;
    reg        ras_valid_cur;

    // -------------------------------------------------------------------------
    // IF stage + IF/ID register
    // -------------------------------------------------------------------------
    wire [31:0] if_pc_cur;
    wire [31:0] if_pc_plus4_cur;
    wire [31:0] if_inst_cur;
    wire [31:0] pc_next;
    wire [31:0] id_next_pc_cur;
    wire        id_redirect_cur;

    reg         if_id_valid_cur;
    reg  [31:0] if_id_pc_cur;
    reg  [31:0] if_id_pc_plus4_cur;
    reg  [31:0] if_id_inst_cur;
    reg         if_id_pred_taken_cur;
    reg  [31:0] if_id_pred_target_cur;
    reg  [PHT_INDEX_W - 1:0] if_id_pht_index_cur;
    // RAS rollback shadow: snapshot of ras_head/ras_valid as it stood when
    // this IF instruction was fetched, captured at the same edge IF/ID
    // latches. Since the RAS push/pop only takes effect on the next clock,
    // ras_*_cur on this edge is the pre-push/pre-pop state, which is exactly
    // the state we'd need to restore if this instruction (or one ahead of it)
    // is later squashed.
    reg  [2:0]  if_id_ras_head_cur;
    reg         if_id_ras_valid_cur;

    wire        if_id_valid_next;
    wire [31:0] if_id_pc_next;
    wire [31:0] if_id_pc_plus4_next;
    wire [31:0] if_id_inst_next;
    wire        if_id_pred_taken_next;
    wire [31:0] if_id_pred_target_next;
    wire [PHT_INDEX_W - 1:0] if_id_pht_index_next;

    // -------------------------------------------------------------------------
    // ID stage + ID/EX register
    // -------------------------------------------------------------------------
    wire        id_lui_cur;
    wire        id_pc_src_cur;
    wire [2:0]  id_alu_op_cur;
    wire        id_mem_write_cur;
    wire        id_mem_read_cur;
    wire        id_mem_to_reg_cur;
    wire        id_alu_src1_cur;
    wire        id_alu_src2_cur;
    wire        id_reg_write_cur;
    wire        id_jump_cur;
    wire        id_branch_cur;
    wire [31:0] id_offset_cur;
    wire [4:0]  id_rs1_raddr_cur;
    wire [4:0]  id_rs2_raddr_cur;
    wire [4:0]  id_rd_waddr_cur;
    wire [31:0] id_rs1_rdata_cur;
    wire [31:0] id_rs2_rdata_cur;
    wire        id_illegal_inst_cur;
    wire        id_ebreak_cur;

    reg         id_ex_valid_cur;
    reg  [31:0] id_ex_pc_cur;
    reg  [31:0] id_ex_pc_plus4_cur;
    reg  [31:0] id_ex_inst_cur;
    reg  [4:0]  id_ex_rs1_raddr_cur;
    reg  [4:0]  id_ex_rs2_raddr_cur;
    reg  [4:0]  id_ex_rd_waddr_cur;
    reg  [31:0] id_ex_rs1_rdata_cur;
    reg  [31:0] id_ex_rs2_rdata_cur;
    reg  [31:0] id_ex_offset_cur;
    reg  [6:0]  id_ex_opcode_cur;
    reg  [2:0]  id_ex_func3_cur;
    reg  [6:0]  id_ex_func7_cur;
    reg         id_ex_lui_cur;
    reg         id_ex_pc_src_cur;
    reg  [2:0]  id_ex_alu_op_cur;
    reg         id_ex_mem_write_cur;
    reg         id_ex_mem_read_cur;
    reg         id_ex_mem_to_reg_cur;
    reg         id_ex_alu_src1_cur;
    reg         id_ex_alu_src2_cur;
    reg         id_ex_reg_write_cur;
    reg         id_ex_jump_cur;
    reg         id_ex_branch_cur;
    reg         id_ex_illegal_inst_cur;
    reg         id_ex_ebreak_cur;
    reg         id_ex_pred_taken_cur;
    reg  [31:0] id_ex_pred_target_cur;
    reg  [PHT_INDEX_W - 1:0] id_ex_pht_index_cur;
    // RAS rollback shadow carried into ID/EX so an EX redirect can restore
    // the RAS to the state it had before any speculative push/pop performed
    // by squashed younger instructions.
    reg  [2:0]  id_ex_ras_head_cur;
    reg         id_ex_ras_valid_cur;

    wire        id_ex_valid_next;
    wire [31:0] id_ex_pc_next;
    wire [31:0] id_ex_pc_plus4_next;
    wire [31:0] id_ex_inst_next;
    wire [4:0]  id_ex_rs1_raddr_next;
    wire [4:0]  id_ex_rs2_raddr_next;
    wire [4:0]  id_ex_rd_waddr_next;
    wire [31:0] id_ex_rs1_rdata_next;
    wire [31:0] id_ex_rs2_rdata_next;
    wire [31:0] id_ex_offset_next;
    wire [6:0]  id_ex_opcode_next;
    wire [2:0]  id_ex_func3_next;
    wire [6:0]  id_ex_func7_next;
    wire        id_ex_lui_next;
    wire        id_ex_pc_src_next;
    wire [2:0]  id_ex_alu_op_next;
    wire        id_ex_mem_write_next;
    wire        id_ex_mem_read_next;
    wire        id_ex_mem_to_reg_next;
    wire        id_ex_alu_src1_next;
    wire        id_ex_alu_src2_next;
    wire        id_ex_reg_write_next;
    wire        id_ex_jump_next;
    wire        id_ex_branch_next;
    wire        id_ex_illegal_inst_next;
    wire        id_ex_ebreak_next;
    wire        id_ex_pred_taken_next;
    wire [31:0] id_ex_pred_target_next;
    wire [PHT_INDEX_W - 1:0] id_ex_pht_index_next;

    // -------------------------------------------------------------------------
    // EX stage + EX/MEM register
    // -------------------------------------------------------------------------
    wire [31:0] ex_operand1_cur;
    wire [31:0] ex_operand2_cur;
    wire [31:0] ex_rs1_value_cur;
    wire [31:0] ex_rs2_value_cur;
    wire [31:0] ex_store_data_cur;
    wire [31:0] ex_alu_result_cur;
    wire        ex_alu_eq_cur;
    wire        ex_alu_slt_cur;
    wire        ex_branch_taken_cur;
    wire        ex_jump_taken_cur;
    wire        ex_control_taken_cur;
    wire [31:0] ex_branch_target_cur;
    wire [31:0] ex_jump_target_raw_cur;
    wire [31:0] ex_jump_target_cur;
    wire [31:0] ex_control_target_cur;
    wire [31:0] ex_pred_next_pc_cur;
    wire        ex_pc_misalign_trap_cur;
    wire        ex_redirect_cur;
    wire [31:0] ex_next_pc_cur;
    wire        bp_update_cur;
    wire        bp_actual_taken_cur;
    wire [BP_SET_W - 1:0] bp_update_set_cur;
    wire [BP_TAG_W - 1:0] bp_update_tag_cur;
    wire                  bp_update_way0_hit_cur;
    wire                  bp_update_way1_hit_cur;
    wire                  bp_update_way_sel_cur;
    wire [31:0] ex_mem_forward_data_cur;
    wire [31:0] mem_wb_forward_data_cur;
    wire        ex_ex_match_rs1_cur;
    wire        ex_ex_match_rs2_cur;
    wire        mem_ex_match_rs1_cur;
    wire        mem_ex_match_rs2_cur;
    wire [1:0]  ex_forward_a_sel_cur;
    wire [1:0]  ex_forward_b_sel_cur;
    wire [1:0]  ex_operand1_sel_cur;
    wire [1:0]  ex_operand2_sel_cur;

    reg         ex_mem_valid_cur;
    reg  [31:0] ex_mem_pc_cur;
    reg  [31:0] ex_mem_pc_plus4_cur;
    reg  [31:0] ex_mem_next_pc_cur;
    reg  [31:0] ex_mem_inst_cur;
    reg  [4:0]  ex_mem_rs1_raddr_cur;
    reg  [4:0]  ex_mem_rs2_raddr_cur;
    reg  [4:0]  ex_mem_rd_waddr_cur;
    reg  [31:0] ex_mem_rs1_rdata_cur;
    reg  [31:0] ex_mem_rs2_rdata_cur;
    reg  [31:0] ex_mem_offset_cur;
    reg  [31:0] ex_mem_alu_result_cur;
    reg  [31:0] ex_mem_store_data_cur;
    reg  [2:0]  ex_mem_func3_cur;
    reg         ex_mem_mem_write_cur;
    reg         ex_mem_mem_read_cur;
    reg         ex_mem_mem_to_reg_cur;
    reg         ex_mem_lui_cur;
    reg         ex_mem_jump_cur;
    reg         ex_mem_reg_write_cur;
    reg         ex_mem_illegal_inst_cur;
    reg         ex_mem_pc_misalign_trap_cur;
    reg         ex_mem_ebreak_cur;
    reg         ex_mem_dmem_req_sent_cur;

    wire        ex_mem_valid_next;
    wire [31:0] ex_mem_pc_next;
    wire [31:0] ex_mem_pc_plus4_next;
    wire [31:0] ex_mem_next_pc_next;
    wire [31:0] ex_mem_inst_next;
    wire [4:0]  ex_mem_rs1_raddr_next;
    wire [4:0]  ex_mem_rs2_raddr_next;
    wire [4:0]  ex_mem_rd_waddr_next;
    wire [31:0] ex_mem_rs1_rdata_next;
    wire [31:0] ex_mem_rs2_rdata_next;
    wire [31:0] ex_mem_offset_next;
    wire [31:0] ex_mem_alu_result_next;
    wire [31:0] ex_mem_store_data_next;
    wire [2:0]  ex_mem_func3_next;
    wire        ex_mem_mem_write_next;
    wire        ex_mem_mem_read_next;
    wire        ex_mem_mem_to_reg_next;
    wire        ex_mem_lui_next;
    wire        ex_mem_jump_next;
    wire        ex_mem_reg_write_next;
    wire        ex_mem_illegal_inst_next;
    wire        ex_mem_pc_misalign_trap_next;
    wire        ex_mem_ebreak_next;

    // -------------------------------------------------------------------------
    // MEM stage + MEM/WB register
    // -------------------------------------------------------------------------
    wire        mem_read_en_cur;
    wire        mem_write_en_cur;
    wire [31:0] mem_dmem_addr_cur;
    wire [3:0]  mem_dmem_mask_cur;
    wire [31:0] mem_dmem_wdata_cur;
    wire        mem_dmem_ren_raw_cur;
    wire        mem_dmem_wen_raw_cur;
    wire        mem_dmem_ren_cur;
    wire        mem_dmem_wen_cur;
    wire [31:0] mem_load_data_cur;
    wire [31:0] mem_store_data_cur;
    wire        mem_misalign_trap_cur;
    wire        mem_store_data_fwd_cur;
    wire        mem_stage_complete_cur;
    wire        mem_stage_stall_cur;
    wire        dmem_req_fire_cur;
    wire        dmem_resp_fire_cur;
    wire        ex_mem_has_dmem_req_cur;
    wire        mem_dcache_req_ren_cur;
    wire        mem_dcache_req_wen_cur;

    reg         mem_wb_valid_cur;
    reg  [31:0] mem_wb_pc_cur;
    reg  [31:0] mem_wb_pc_plus4_cur;
    reg  [31:0] mem_wb_next_pc_cur;
    reg  [31:0] mem_wb_inst_cur;
    reg  [4:0]  mem_wb_rs1_raddr_cur;
    reg  [4:0]  mem_wb_rs2_raddr_cur;
    reg  [4:0]  mem_wb_rd_waddr_cur;
    reg  [31:0] mem_wb_rs1_rdata_cur;
    reg  [31:0] mem_wb_rs2_rdata_cur;
    reg  [31:0] mem_wb_offset_cur;
    reg  [31:0] mem_wb_alu_result_cur;
    reg  [31:0] mem_wb_load_data_cur;
    reg  [31:0] mem_wb_dmem_addr_cur;
    reg         mem_wb_dmem_ren_cur;
    reg         mem_wb_dmem_wen_cur;
    reg  [3:0]  mem_wb_dmem_mask_cur;
    reg  [31:0] mem_wb_dmem_wdata_cur;
    reg  [31:0] mem_wb_dmem_rdata_cur;
    reg         mem_wb_mem_to_reg_cur;
    reg         mem_wb_lui_cur;
    reg         mem_wb_jump_cur;
    reg         mem_wb_reg_write_cur;
    reg         mem_wb_illegal_inst_cur;
    reg         mem_wb_pc_misalign_trap_cur;
    reg         mem_wb_misalign_trap_cur;
    reg         mem_wb_ebreak_cur;

    wire        mem_wb_valid_next;
    wire [31:0] mem_wb_pc_next;
    wire [31:0] mem_wb_pc_plus4_next;
    wire [31:0] mem_wb_next_pc_next;
    wire [31:0] mem_wb_inst_next;
    wire [4:0]  mem_wb_rs1_raddr_next;
    wire [4:0]  mem_wb_rs2_raddr_next;
    wire [4:0]  mem_wb_rd_waddr_next;
    wire [31:0] mem_wb_rs1_rdata_next;
    wire [31:0] mem_wb_rs2_rdata_next;
    wire [31:0] mem_wb_offset_next;
    wire [31:0] mem_wb_alu_result_next;
    wire [31:0] mem_wb_load_data_next;
    wire [31:0] mem_wb_dmem_addr_next;
    wire        mem_wb_dmem_ren_next;
    wire        mem_wb_dmem_wen_next;
    wire [3:0]  mem_wb_dmem_mask_next;
    wire [31:0] mem_wb_dmem_wdata_next;
    wire [31:0] mem_wb_dmem_rdata_next;
    wire        mem_wb_mem_to_reg_next;
    wire        mem_wb_lui_next;
    wire        mem_wb_jump_next;
    wire        mem_wb_reg_write_next;
    wire        mem_wb_illegal_inst_next;
    wire        mem_wb_pc_misalign_trap_next;
    wire        mem_wb_misalign_trap_next;
    wire        mem_wb_ebreak_next;

    // -------------------------------------------------------------------------
    // WB stage
    // -------------------------------------------------------------------------
    wire [31:0] wb_write_data_cur;
    wire        wb_trap_cur;
    wire        wb_write_enable_cur;
    wire        retire_halt_cur;
    wire [6:0]  id_opcode_cur;
    wire        id_rs1_used_cur;
    wire        id_rs2_used_cur;
    wire        id_rs2_ex_used_cur;
    wire        hazard_ex_cur;
    wire        hazard_mem_cur;
    wire        hazard_wb_cur;
    wire        hazard_stall_cur;
    wire        if_id_consumed_cur;
    wire        if_id_buffer_available_cur;
    wire        imem_req_fire_cur;
    wire        imem_resp_fire_cur;
    wire        imem_resp_accept_cur;
    wire [31:0] imem_req_addr_cur;
    wire [31:0] imem_resp_pc_cur;
    wire [BP_SET_W - 1:0]    if_bp_set_cur;
    wire [BP_TAG_W - 1:0]    if_bp_tag_cur;
    wire                     if_bp_way0_hit_cur;
    wire                     if_bp_way1_hit_cur;
    wire                     if_bp_hit_cur;
    wire                     if_bp_hit_way_cur;
    wire [31:0]              if_bp_target_cur;
    wire [1:0]               if_bp_counter_cur;
    wire [PHT_INDEX_W - 1:0] if_pht_index_cur;
    wire                     if_pht_valid_cur;
    wire [1:0]               if_pht_counter_cur;
    wire                    if_cache_hit_cur;
    wire                    if_inst_branch_cur;
    wire                    if_inst_jal_cur;
    wire [31:0]             if_branch_offset_cur;
    wire [31:0]             if_jal_offset_cur;
    wire                    if_static_pred_taken_cur;
    wire [31:0]             if_static_pred_target_cur;
    wire                    if_pred_taken_cur;
    wire [31:0]             if_pred_target_cur;
    wire [31:0]             if_pred_next_pc_cur;
    wire                    imem_resp_pred_taken_cur;
    wire [31:0]             imem_resp_pred_target_cur;
    wire                    imem_resp_inst_branch_cur;
    wire                    imem_resp_inst_jal_cur;
    wire [31:0]             imem_resp_branch_offset_cur;
    wire [31:0]             imem_resp_jal_offset_cur;
    wire                    imem_resp_static_pred_taken_cur;
    wire [31:0]             imem_resp_static_pred_target_cur;
    wire                    imem_resp_late_redirect_cur;

    // RAS detection wires (based on the instruction currently at IF that is
    // about to be accepted into IF/ID). Only link-register forms push/pop.
    wire        if_inst_jalr_cur;
    wire [4:0]  if_inst_rd_cur;
    wire [4:0]  if_inst_rs1_cur;
    wire        if_is_ras_push_cur;
    wire        if_is_ras_pop_cur;
    wire [31:0] if_ras_pred_target_cur;
    wire        ras_push_fire_cur;
    wire        ras_pop_fire_cur;

    // -------------------------------------------------------------------------
    // Caches
    // -------------------------------------------------------------------------
    cache #(.PREFETCH_EN(1), .LINE_WIDE(1), .EARLY_RESTART_EN(1)) u_icache (
        .i_clk      (i_clk),
        .i_rst      (i_rst),
        .i_mem_ready(i_imem_ready),
        .o_mem_addr (imem_cache_mem_addr_cur),
        .o_mem_ren  (imem_cache_mem_ren_cur),
        .o_mem_wen  (imem_cache_mem_wen_cur),
        .o_mem_wdata(imem_cache_mem_wdata_cur),
        .i_mem_rdata(i_imem_rdata),
        .i_mem_valid(i_imem_valid),
        .o_busy     (imem_cache_busy_cur),
        .i_req_addr (imem_req_addr_cur),
        .i_req_ren  (imem_req_fire_cur),
        .i_req_wen  (1'b0),
        .i_req_mask (4'b1111),
        .i_req_wdata(32'd0),
        .o_res_rdata(imem_cache_rdata_cur)
    );

    cache #(.PREFETCH_EN(1), .LINE_WIDE(0), .EARLY_RESTART_EN(1)) u_dcache (
        .i_clk      (i_clk),
        .i_rst      (i_rst),
        .i_mem_ready(i_dmem_ready),
        .o_mem_addr (dmem_cache_mem_addr_cur),
        .o_mem_ren  (dmem_cache_mem_ren_cur),
        .o_mem_wen  (dmem_cache_mem_wen_cur),
        .o_mem_wdata(dmem_cache_mem_wdata_cur),
        .i_mem_rdata(i_dmem_rdata),
        .i_mem_valid(i_dmem_valid),
        .o_busy     (dmem_cache_busy_cur),
        .i_req_addr (mem_dmem_addr_cur),
        .i_req_ren  (mem_dcache_req_ren_cur),
        .i_req_wen  (mem_dcache_req_wen_cur),
        .i_req_mask (mem_dmem_mask_cur),
        .i_req_wdata(mem_dmem_wdata_cur),
        .o_res_rdata(dmem_cache_rdata_cur)
    );

    // -------------------------------------------------------------------------
    // IF stage
    // -------------------------------------------------------------------------
    assign if_pc_cur       = pc_cur;
    assign if_pc_plus4_cur = pc_cur + 32'd4;
    assign if_inst_cur     = imem_cache_rdata_cur;
    assign if_bp_set_cur        = if_pc_cur[BP_SET_W + 1:2];
    assign if_bp_tag_cur        = if_pc_cur[31:BP_SET_W + 2];
    assign if_bp_way0_hit_cur   = bp_valid0_cur[if_bp_set_cur] &
                                  (bp_tags0_cur[if_bp_set_cur] == if_bp_tag_cur);
    assign if_bp_way1_hit_cur   = bp_valid1_cur[if_bp_set_cur] &
                                  (bp_tags1_cur[if_bp_set_cur] == if_bp_tag_cur);
    assign if_bp_hit_cur        = if_bp_way0_hit_cur | if_bp_way1_hit_cur;
    assign if_bp_hit_way_cur    = if_bp_way1_hit_cur;
    assign if_bp_target_cur     = if_bp_hit_way_cur ? bp_targets1_cur[if_bp_set_cur] :
                                                      bp_targets0_cur[if_bp_set_cur];
    assign if_bp_counter_cur    = if_bp_hit_way_cur ? bp_counters1_cur[if_bp_set_cur] :
                                                      bp_counters0_cur[if_bp_set_cur];
    // Gshare PHT lookup: index = pc[9:2] XOR GHR. The BTB still uses PC-only
    // for tag/target storage; the PHT (separate 256-entry table) provides
    // the direction prediction with global-history correlation.
    assign if_pht_index_cur     = if_pc_cur[PHT_INDEX_W + 1:2] ^ bp_ghr_cur;
    assign if_pht_valid_cur     = bp_pht_valid_cur[if_pht_index_cur];
    assign if_pht_counter_cur   = if_pht_valid_cur ? bp_pht_cur[if_pht_index_cur] : 2'b01;
    assign if_cache_hit_cur     = imem_req_fire_cur & ~imem_cache_busy_cur;
    assign if_inst_branch_cur   = if_inst_cur[6:0] == 7'b1100011;
    assign if_inst_jal_cur      = if_inst_cur[6:0] == 7'b1101111;
    assign if_branch_offset_cur = {{20{if_inst_cur[31]}}, if_inst_cur[7],
                                   if_inst_cur[30:25], if_inst_cur[11:8],
                                   1'b0};
    assign if_jal_offset_cur    = {{12{if_inst_cur[31]}}, if_inst_cur[19:12],
                                   if_inst_cur[20], if_inst_cur[30:21], 1'b0};
    assign if_static_pred_taken_cur  = ~if_bp_hit_cur & if_cache_hit_cur &
                                       (if_inst_jal_cur |
                                        (if_inst_branch_cur & if_inst_cur[31]));
    assign if_static_pred_target_cur = if_inst_jal_cur ? (if_pc_cur + if_jal_offset_cur) :
                                                         (if_pc_cur + if_branch_offset_cur);

    // RAS detection and prediction target. Only looks at the current IF
    // instruction (which is only meaningful when the I-cache actually
    // returned an instruction word this cycle - if_cache_hit_cur).
    assign if_inst_jalr_cur     = if_inst_cur[6:0] == 7'b1100111;
    assign if_inst_rd_cur       = if_inst_cur[11:7];
    assign if_inst_rs1_cur      = if_inst_cur[19:15];
    // Valid instruction-on-the-bus: either a fresh IF hit, or a pending
    // response arriving this cycle.
    wire if_inst_present_cur = if_cache_hit_cur | imem_resp_fire_cur;
    assign if_is_ras_push_cur   = if_inst_present_cur & if_inst_jal_cur &
                                  ((if_inst_rd_cur == 5'd1) | (if_inst_rd_cur == 5'd5));
    assign if_is_ras_pop_cur    = if_inst_present_cur & if_inst_jalr_cur &
                                  ((if_inst_rs1_cur == 5'd1) | (if_inst_rs1_cur == 5'd5)) &
                                  ((if_inst_rd_cur == 5'd0) |
                                   (if_inst_rd_cur != if_inst_rs1_cur));
    assign if_ras_pred_target_cur = ras_stack_cur[ras_head_cur - 3'd1];

    // Base prediction combines BTB + static prediction as before. RAS
    // overrides the target for JALR-return when the stack is non-empty.
    wire        if_base_pred_taken_cur;
    wire [31:0] if_base_pred_target_cur;
    // Direction prediction priority:
    //   1) JAL/JALR are unconditional taken when BTB hits — PHT is bypassed.
    //   2) Conditional branches use the gshare PHT counter.
    //   3) BTB miss falls back to static prediction (JAL taken, backward
    //      branches taken, forward not-taken).
    // When the I-cache hasn't returned an instruction yet (cold IF), neither
    // if_inst_branch_cur nor if_inst_jal_cur is meaningful, so we can't
    // distinguish unconditional from conditional. Default in that case is
    // the BTB counter, which historically tracked direction correctly even
    // for JAL (it always saturates to taken).
    wire if_unconditional_at_if_cur = if_inst_present_cur &
                                      (if_inst_jal_cur | if_inst_jalr_cur);
    wire if_conditional_at_if_cur   = if_inst_present_cur & if_inst_branch_cur;
    wire if_btb_dir_taken_cur =
        if_unconditional_at_if_cur ? 1'b1 :
        if_conditional_at_if_cur   ? if_pht_counter_cur[1] :
                                     if_bp_counter_cur[1];
    // On a BTB miss, prefer the gshare PHT direction (trained on this branch's
    // own outcomes) for conditional branches when the PHT entry is valid.
    // Falls back to the static heuristic only when neither BTB nor PHT has
    // data. JAL on BTB miss remains unconditional-taken via the static path.
    wire if_btbmiss_dir_taken_cur =
        (if_inst_present_cur & if_inst_branch_cur & if_pht_valid_cur) ?
            if_pht_counter_cur[1] : if_static_pred_taken_cur;
    wire [31:0] if_btbmiss_pred_target_cur =
        if_btbmiss_dir_taken_cur ? if_static_pred_target_cur : if_pc_plus4_cur;

    assign if_base_pred_taken_cur  = if_bp_hit_cur ? if_btb_dir_taken_cur :
                                                      if_btbmiss_dir_taken_cur;
    assign if_base_pred_target_cur = if_bp_hit_cur ? (if_btb_dir_taken_cur ?
                                                      if_bp_target_cur :
                                                      if_pc_plus4_cur) :
                                                      if_btbmiss_pred_target_cur;
    assign if_pred_taken_cur    = (if_is_ras_pop_cur & ras_valid_cur) | if_base_pred_taken_cur;
    assign if_pred_target_cur   = (if_is_ras_pop_cur & ras_valid_cur) ? if_ras_pred_target_cur :
                                                                        if_base_pred_target_cur;
    assign if_pred_next_pc_cur  = if_pred_target_cur;
    // Priority: EX-stage JALR mispredict > ID-stage direct-branch/JAL
    // mispredict > IF-stage prediction.
    assign pc_next              = ex_redirect_cur ? ex_next_pc_cur :
                                  id_redirect_cur ? id_next_pc_cur :
                                                    if_pred_next_pc_cur;

    assign if_id_consumed_cur         = if_id_valid_cur & ~hazard_stall_cur & ~mem_stage_stall_cur & ~ex_redirect_cur;
    assign if_id_buffer_available_cur = ~if_id_valid_cur | if_id_consumed_cur;
    assign imem_req_fire_cur          = ~halted_cur & ~imem_pending_cur & if_id_buffer_available_cur & ~ex_redirect_cur;
    assign imem_req_addr_cur          = imem_pending_cur ? imem_pending_pc_cur : if_pc_cur;
    assign imem_resp_fire_cur         = imem_pending_cur & ~imem_cache_busy_cur;
    assign imem_resp_accept_cur       = (imem_req_fire_cur & ~imem_cache_busy_cur) |
                                        (imem_resp_fire_cur & ~imem_pending_kill_cur & ~ex_redirect_cur);
    assign imem_resp_pc_cur           = imem_pending_cur ? imem_pending_pc_cur : if_pc_cur;
    assign imem_resp_inst_branch_cur = if_inst_cur[6:0] == 7'b1100011;
    assign imem_resp_inst_jal_cur    = if_inst_cur[6:0] == 7'b1101111;
    assign imem_resp_branch_offset_cur = {{20{if_inst_cur[31]}}, if_inst_cur[7],
                                          if_inst_cur[30:25], if_inst_cur[11:8],
                                          1'b0};
    assign imem_resp_jal_offset_cur    = {{12{if_inst_cur[31]}}, if_inst_cur[19:12],
                                          if_inst_cur[20], if_inst_cur[30:21], 1'b0};
    assign imem_resp_static_pred_taken_cur =
        imem_pending_cur & ~imem_pending_pred_taken_cur &
        (imem_resp_inst_jal_cur |
         (imem_resp_inst_branch_cur & if_inst_cur[31]));
    assign imem_resp_static_pred_target_cur =
        imem_resp_inst_jal_cur ? (imem_resp_pc_cur + imem_resp_jal_offset_cur) :
                                 (imem_resp_pc_cur + imem_resp_branch_offset_cur);
    assign imem_resp_pred_taken_cur   = imem_pending_cur ?
                                        (imem_pending_pred_taken_cur |
                                         imem_resp_static_pred_taken_cur) :
                                        if_pred_taken_cur;
    assign imem_resp_pred_target_cur  = imem_pending_cur ?
                                        (imem_pending_pred_taken_cur ?
                                         imem_pending_pred_target_cur :
                                         (imem_resp_static_pred_taken_cur ?
                                          imem_resp_static_pred_target_cur :
                                          imem_pending_pred_target_cur)) :
                                        if_pred_target_cur;
    assign imem_resp_late_redirect_cur = imem_resp_accept_cur &
                                         imem_pending_cur &
                                         imem_resp_static_pred_taken_cur;

    // RAS push/pop fire whenever an IF instruction is actually committed to
    // IF/ID. Redirects (EX squash) do not unwind speculative pushes/pops in
    // this implementation, which is acceptable since RAS is purely a
    // predictor - mispredicts still fall through to the EX redirect.
    assign ras_push_fire_cur = imem_resp_accept_cur & if_is_ras_push_cur &
                               ~ex_redirect_cur & ~id_redirect_cur;
    assign ras_pop_fire_cur  = imem_resp_accept_cur & if_is_ras_pop_cur &
                               ~ex_redirect_cur & ~id_redirect_cur &
                               ras_valid_cur;

    assign o_imem_raddr = imem_cache_mem_addr_cur;
    assign o_imem_ren   = imem_cache_mem_ren_cur;

    assign if_id_valid_next    = imem_resp_accept_cur;
    assign if_id_pc_next       = imem_resp_pc_cur;
    assign if_id_pc_plus4_next = imem_resp_pc_cur + 32'd4;
    assign if_id_inst_next     = if_inst_cur;
    assign if_id_pred_taken_next  = imem_resp_pred_taken_cur;
    assign if_id_pred_target_next = imem_resp_pred_target_cur;
    // Capture the PHT index used at fetch so the EX stage can update the
    // exact same PHT entry — global history is the GHR seen at fetch, not
    // the GHR seen at update.
    assign if_id_pht_index_next   = if_pht_index_cur;

    // -------------------------------------------------------------------------
    // ID stage
    // -------------------------------------------------------------------------
    decode #(.BYPASS_EN(1)) u_decode (
        .i_clk              (i_clk),
        .i_rst              (i_rst),
        .Inst               (if_id_inst_cur),
        .WriteData          (wb_write_data_cur),
        .WriteAddr          (mem_wb_rd_waddr_cur),
        .WriteEn            (wb_write_enable_cur),
        .lui                (id_lui_cur),
        .PcSrc              (id_pc_src_cur),
        .AluOp              (id_alu_op_cur),
        .MemWrite           (id_mem_write_cur),
        .MemRead            (id_mem_read_cur),
        .MemToReg           (id_mem_to_reg_cur),
        .AluSrc1            (id_alu_src1_cur),
        .AluSrc2            (id_alu_src2_cur),
        .RegWrite           (id_reg_write_cur),
        .Jump               (id_jump_cur),
        .Branch             (id_branch_cur),
        .Offset             (id_offset_cur),
        .o_retire_rs1_raddr (id_rs1_raddr_cur),
        .o_retire_rs2_raddr (id_rs2_raddr_cur),
        .o_retire_rd_waddr  (id_rd_waddr_cur),
        .o_retire_rs1_rdata (id_rs1_rdata_cur),
        .o_retire_rs2_rdata (id_rs2_rdata_cur),
        .IllegalInst        (id_illegal_inst_cur),
        .EBreak             (id_ebreak_cur)
    );

    assign id_opcode_cur = if_id_inst_cur[6:0];

    assign id_rs1_used_cur = (id_opcode_cur == 7'b0110011) |  // R-type
                             (id_opcode_cur == 7'b0010011) |  // I-type ALU
                             (id_opcode_cur == 7'b0000011) |  // load
                             (id_opcode_cur == 7'b0100011) |  // store
                             (id_opcode_cur == 7'b1100011) |  // branch
                             (id_opcode_cur == 7'b1100111);   // jalr

    assign id_rs2_used_cur = (id_opcode_cur == 7'b0110011) |  // R-type
                             (id_opcode_cur == 7'b0100011) |  // store
                             (id_opcode_cur == 7'b1100011);   // branch

    assign id_rs2_ex_used_cur = (id_opcode_cur == 7'b0110011) |  // R-type
                                (id_opcode_cur == 7'b1100011);   // branch

    // ----- ID-stage early branch / JAL resolution -----
    // Resolving direct branches (BEQ/BNE/BLT/BGE/BLTU/BGEU) and JAL in ID
    // drops the mispredict penalty from 3 cycles (EX-resolution) to 1 cycle
    // (just squash the bubble the IF inserted). JALR still resolves at EX
    // because its target depends on rs1 which may need EX-time forwarding.
    wire        id_is_branch_cur;
    wire        id_is_jal_cur;
    wire        id_is_jalr_cur;
    wire [2:0]  id_func3_cur;
    wire [31:0] id_pc_cur_w;
    wire [31:0] id_pc_plus4_cur_w;
    wire [31:0] id_branch_target_cur;
    wire [31:0] id_jal_target_cur;
    wire [31:0] id_control_target_cur;
    wire [31:0] id_fwd_rs1_cur;
    wire [31:0] id_fwd_rs2_cur;
    wire        id_ex_match_rs1_cur;
    wire        id_ex_match_rs2_cur;
    wire        id_mem_match_rs1_cur;
    wire        id_mem_match_rs2_cur;
    wire        id_has_producer_ahead_rs1_cur;
    wire        id_has_producer_ahead_rs2_cur;
    wire        id_branch_stall_cur;
    wire        id_alu_eq_cur;
    wire        id_alu_slt_cur;
    wire        id_alu_sltu_cur;
    wire        id_branch_taken_cur;
    wire        id_jal_taken_cur;
    wire        id_control_taken_cur;
    wire [31:0] id_pred_next_pc_cur;
    wire        id_pc_misalign_trap_cur;

    assign id_is_branch_cur   = (id_opcode_cur == 7'b1100011);
    assign id_is_jal_cur      = (id_opcode_cur == 7'b1101111);
    assign id_is_jalr_cur     = (id_opcode_cur == 7'b1100111);
    assign id_func3_cur       = if_id_inst_cur[14:12];
    assign id_pc_cur_w        = if_id_pc_cur;
    assign id_pc_plus4_cur_w  = if_id_pc_plus4_cur;

    // ID-stage forwarding from EX/MEM (previous instruction's alu/lui/jump
    // result) and MEM/WB (one earlier - RF bypass usually handles this but
    // we bypass here explicitly too). Load data from EX/MEM is NOT
    // forwardable at ID yet; that case stalls.
    assign id_ex_match_rs1_cur = ex_mem_valid_cur & ex_mem_reg_write_cur &
                                 ~ex_mem_mem_to_reg_cur &
                                 (ex_mem_rd_waddr_cur != 5'd0) &
                                 (ex_mem_rd_waddr_cur == id_rs1_raddr_cur);
    assign id_ex_match_rs2_cur = ex_mem_valid_cur & ex_mem_reg_write_cur &
                                 ~ex_mem_mem_to_reg_cur &
                                 (ex_mem_rd_waddr_cur != 5'd0) &
                                 (ex_mem_rd_waddr_cur == id_rs2_raddr_cur);
    assign id_mem_match_rs1_cur = mem_wb_valid_cur & mem_wb_reg_write_cur &
                                  ~id_ex_match_rs1_cur &
                                  (mem_wb_rd_waddr_cur != 5'd0) &
                                  (mem_wb_rd_waddr_cur == id_rs1_raddr_cur);
    assign id_mem_match_rs2_cur = mem_wb_valid_cur & mem_wb_reg_write_cur &
                                  ~id_ex_match_rs2_cur &
                                  (mem_wb_rd_waddr_cur != 5'd0) &
                                  (mem_wb_rd_waddr_cur == id_rs2_raddr_cur);

    // A producer currently in EX (ID/EX register) whose ALU/LUI/JAL result is
    // computed combinationally this cycle can be forwarded directly into the
    // ID-stage branch comparator. Loads are excluded: their data is not
    // available until after the MEM stage, so a load producer still forces
    // id_branch_stall_cur below (1-cycle bubble) and is later satisfied via
    // the MEM-live load-forward path into EX operands.
    wire        id_ex_is_load_cur = id_ex_valid_cur & id_ex_mem_read_cur;
    wire        id_ex_is_alu_producer_cur = id_ex_valid_cur &
                                            id_ex_reg_write_cur &
                                            ~id_ex_mem_to_reg_cur;
    wire [31:0] id_ex_forward_data_cur = id_ex_jump_cur ? id_ex_pc_plus4_cur :
                                         id_ex_lui_cur  ? id_ex_offset_cur :
                                                          ex_alu_result_cur;
    wire        id_exlive_match_rs1_cur = id_ex_is_alu_producer_cur &
                                          (id_ex_rd_waddr_cur != 5'd0) &
                                          (id_ex_rd_waddr_cur == id_rs1_raddr_cur);
    wire        id_exlive_match_rs2_cur = id_ex_is_alu_producer_cur &
                                          (id_ex_rd_waddr_cur != 5'd0) &
                                          (id_ex_rd_waddr_cur == id_rs2_raddr_cur);

    assign id_fwd_rs1_cur = id_exlive_match_rs1_cur ? id_ex_forward_data_cur :
                            id_ex_match_rs1_cur     ? ex_mem_forward_data_cur :
                            id_mem_match_rs1_cur    ? mem_wb_forward_data_cur :
                                                      id_rs1_rdata_cur;
    assign id_fwd_rs2_cur = id_exlive_match_rs2_cur ? id_ex_forward_data_cur :
                            id_ex_match_rs2_cur     ? ex_mem_forward_data_cur :
                            id_mem_match_rs2_cur    ? mem_wb_forward_data_cur :
                                                      id_rs2_rdata_cur;

    // Stall when a producer of the branch's rs1 or rs2 is one step ahead at
    // ID/EX AND that producer is a load (whose data is not yet available).
    // Non-load ID/EX producers are handled by the id_exlive_* forward path
    // above, so they no longer require a stall.
    assign id_has_producer_ahead_rs1_cur = id_ex_is_load_cur &
                                           (id_ex_rd_waddr_cur != 5'd0) &
                                           (id_ex_rd_waddr_cur == id_rs1_raddr_cur);
    assign id_has_producer_ahead_rs2_cur = id_ex_is_load_cur &
                                           (id_ex_rd_waddr_cur != 5'd0) &
                                           (id_ex_rd_waddr_cur == id_rs2_raddr_cur);
    assign id_branch_stall_cur = if_id_valid_cur & id_is_branch_cur &
                                 ((id_rs1_used_cur & id_has_producer_ahead_rs1_cur) |
                                  (id_rs2_ex_used_cur & id_has_producer_ahead_rs2_cur));

    // ID-stage comparator.
    assign id_alu_eq_cur   = (id_fwd_rs1_cur == id_fwd_rs2_cur);
    assign id_alu_slt_cur  = (id_fwd_rs1_cur[31] != id_fwd_rs2_cur[31]) ?
                             id_fwd_rs1_cur[31] :
                             (id_fwd_rs1_cur < id_fwd_rs2_cur);
    assign id_alu_sltu_cur = (id_fwd_rs1_cur < id_fwd_rs2_cur);
    assign id_branch_taken_cur = if_id_valid_cur & ~id_branch_stall_cur & ~mem_stage_stall_cur &
                                 id_is_branch_cur &
                                 ((id_func3_cur == 3'b000) ?  id_alu_eq_cur   :
                                  (id_func3_cur == 3'b001) ? ~id_alu_eq_cur   :
                                  (id_func3_cur == 3'b100) ?  id_alu_slt_cur  :
                                  (id_func3_cur == 3'b101) ? ~id_alu_slt_cur  :
                                  (id_func3_cur == 3'b110) ?  id_alu_sltu_cur :
                                  (id_func3_cur == 3'b111) ? ~id_alu_sltu_cur :
                                                              1'b0);
    assign id_jal_taken_cur    = if_id_valid_cur & ~mem_stage_stall_cur & id_is_jal_cur;
    assign id_control_taken_cur = id_branch_taken_cur | id_jal_taken_cur;

    assign id_branch_target_cur = id_pc_cur_w + id_offset_cur;
    assign id_jal_target_cur    = id_pc_cur_w + id_offset_cur;
    assign id_control_target_cur = id_is_jal_cur ? id_jal_target_cur : id_branch_target_cur;

    assign id_pc_misalign_trap_cur = id_control_taken_cur & (|id_control_target_cur[1:0]);

    assign id_next_pc_cur      = id_control_taken_cur ? id_control_target_cur : id_pc_plus4_cur_w;
    assign id_pred_next_pc_cur = if_id_pred_taken_cur ? if_id_pred_target_cur : id_pc_plus4_cur_w;
    assign id_redirect_cur     = if_id_valid_cur & ~id_branch_stall_cur & ~mem_stage_stall_cur &
                                 (id_is_branch_cur | id_is_jal_cur) &
                                 ~id_pc_misalign_trap_cur &
                                 (id_next_pc_cur != id_pred_next_pc_cur);

    // Load-use hazard: no longer stalls, because a MEM-live load-forwarding
    // path from EX/MEM to the EX operands handles both the cache-hit case
    // (data flows through in the cycle the load completes) and the
    // cache-miss case (mem_stage_stall_cur holds the consumer in ID/EX
    // until the miss completes, at which point the live-load forward
    // delivers the data into EX operands). This eliminates the 1-cycle
    // bubble the previous stall injected on every load-use pair.
    assign hazard_ex_cur = 1'b0;

    assign hazard_mem_cur = 1'b0;

    assign hazard_wb_cur = 1'b0;

    assign hazard_stall_cur = hazard_ex_cur | hazard_mem_cur | hazard_wb_cur |
                              id_branch_stall_cur;

    assign id_ex_valid_next        = if_id_valid_cur;
    assign id_ex_pc_next           = if_id_pc_cur;
    assign id_ex_pc_plus4_next     = if_id_pc_plus4_cur;
    assign id_ex_inst_next         = if_id_inst_cur;
    assign id_ex_rs1_raddr_next    = id_rs1_raddr_cur;
    assign id_ex_rs2_raddr_next    = id_rs2_raddr_cur;
    assign id_ex_rd_waddr_next     = id_rd_waddr_cur;
    assign id_ex_rs1_rdata_next    = id_rs1_rdata_cur;
    assign id_ex_rs2_rdata_next    = id_rs2_rdata_cur;
    assign id_ex_offset_next       = id_offset_cur;
    assign id_ex_opcode_next       = if_id_inst_cur[6:0];
    assign id_ex_func3_next        = if_id_inst_cur[14:12];
    assign id_ex_func7_next        = if_id_inst_cur[31:25];
    assign id_ex_lui_next          = id_lui_cur;
    assign id_ex_pc_src_next       = id_pc_src_cur;
    assign id_ex_alu_op_next       = id_alu_op_cur;
    assign id_ex_mem_write_next    = id_mem_write_cur;
    assign id_ex_mem_read_next     = id_mem_read_cur;
    assign id_ex_mem_to_reg_next   = id_mem_to_reg_cur;
    assign id_ex_alu_src1_next     = id_alu_src1_cur;
    assign id_ex_alu_src2_next     = id_alu_src2_cur;
    assign id_ex_reg_write_next    = id_reg_write_cur;
    assign id_ex_jump_next         = id_jump_cur;
    assign id_ex_branch_next       = id_branch_cur;
    assign id_ex_illegal_inst_next = id_illegal_inst_cur;
    assign id_ex_ebreak_next       = id_ebreak_cur;
    assign id_ex_pred_taken_next   = if_id_pred_taken_cur;
    assign id_ex_pred_target_next  = if_id_pred_target_cur;
    assign id_ex_pht_index_next    = if_id_pht_index_cur;

    // -------------------------------------------------------------------------
    // EX stage
    // -------------------------------------------------------------------------
    assign ex_mem_forward_data_cur = ex_mem_jump_cur ? ex_mem_pc_plus4_cur :
                                     ex_mem_lui_cur  ? ex_mem_offset_cur :
                                                       ex_mem_alu_result_cur;
    assign mem_wb_forward_data_cur = wb_write_data_cur;

    // A load in EX/MEM that completes this cycle (D$ hit) can be forwarded
    // live to an ID/EX consumer, eliminating the 1-cycle load-use bubble on
    // hits. On a miss (dmem_cache_busy_cur), we fall back to the regular
    // stall.
    wire ex_mem_load_live_cur = ex_mem_valid_cur &
                                ex_mem_mem_read_cur &
                                ~mem_misalign_trap_cur &
                                (ex_mem_dmem_req_sent_cur | dmem_req_fire_cur) &
                                ~dmem_cache_busy_cur;

    assign ex_ex_match_rs1_cur = id_ex_valid_cur &
                                 ex_mem_valid_cur &
                                 ex_mem_reg_write_cur &
                                 ~ex_mem_mem_to_reg_cur &
                                 (ex_mem_rd_waddr_cur != 5'd0) &
                                 (ex_mem_rd_waddr_cur == id_ex_rs1_raddr_cur);
    assign ex_ex_match_rs2_cur = id_ex_valid_cur &
                                 ex_mem_valid_cur &
                                 ex_mem_reg_write_cur &
                                 ~ex_mem_mem_to_reg_cur &
                                 (ex_mem_rd_waddr_cur != 5'd0) &
                                 (ex_mem_rd_waddr_cur == id_ex_rs2_raddr_cur);

    // MEM-live load forward: match when the load currently at EX/MEM is
    // completing this cycle and the ID/EX consumer reads the load's rd.
    wire ex_load_match_rs1_cur = id_ex_valid_cur &
                                 ex_mem_load_live_cur &
                                 ex_mem_reg_write_cur &
                                 ex_mem_mem_to_reg_cur &
                                 (ex_mem_rd_waddr_cur != 5'd0) &
                                 (ex_mem_rd_waddr_cur == id_ex_rs1_raddr_cur);
    wire ex_load_match_rs2_cur = id_ex_valid_cur &
                                 ex_mem_load_live_cur &
                                 ex_mem_reg_write_cur &
                                 ex_mem_mem_to_reg_cur &
                                 (ex_mem_rd_waddr_cur != 5'd0) &
                                 (ex_mem_rd_waddr_cur == id_ex_rs2_raddr_cur);

    assign mem_ex_match_rs1_cur = id_ex_valid_cur &
                                  mem_wb_valid_cur &
                                  mem_wb_reg_write_cur &
                                  (mem_wb_rd_waddr_cur != 5'd0) &
                                  ~ex_ex_match_rs1_cur &
                                  ~ex_load_match_rs1_cur &
                                  (mem_wb_rd_waddr_cur == id_ex_rs1_raddr_cur);
    assign mem_ex_match_rs2_cur = id_ex_valid_cur &
                                  mem_wb_valid_cur &
                                  mem_wb_reg_write_cur &
                                  (mem_wb_rd_waddr_cur != 5'd0) &
                                  ~ex_ex_match_rs2_cur &
                                  ~ex_load_match_rs2_cur &
                                  (mem_wb_rd_waddr_cur == id_ex_rs2_raddr_cur);

    // Regular 2-bit forwarding sel: 10 = EX/MEM, 01 = MEM/WB, 00 = RF.
    assign ex_forward_a_sel_cur = ex_ex_match_rs1_cur   ? 2'b10 :
                                  mem_ex_match_rs1_cur  ? 2'b01 :
                                                          2'b00;
    assign ex_forward_b_sel_cur = ex_ex_match_rs2_cur   ? 2'b10 :
                                  mem_ex_match_rs2_cur  ? 2'b01 :
                                                          2'b00;

    assign ex_operand1_sel_cur = id_ex_alu_src1_cur ? 2'b11 : ex_forward_a_sel_cur;
    assign ex_operand2_sel_cur = id_ex_alu_src2_cur ? 2'b11 : ex_forward_b_sel_cur;

    // rs1/rs2 value selection honors the live-load forward first, then
    // regular EX/MEM and MEM/WB forwards, then the RF output.
    assign ex_rs1_value_cur = ex_load_match_rs1_cur           ? mem_load_data_cur :
                              (ex_forward_a_sel_cur == 2'b10) ? ex_mem_forward_data_cur :
                              (ex_forward_a_sel_cur == 2'b01) ? mem_wb_forward_data_cur :
                                                                id_ex_rs1_rdata_cur;
    assign ex_rs2_value_cur = ex_load_match_rs2_cur           ? mem_load_data_cur :
                              (ex_forward_b_sel_cur == 2'b10) ? ex_mem_forward_data_cur :
                              (ex_forward_b_sel_cur == 2'b01) ? mem_wb_forward_data_cur :
                                                                id_ex_rs2_rdata_cur;

    assign ex_operand1_cur = (ex_operand1_sel_cur == 2'b11) ? id_ex_pc_cur
                                                             : ex_rs1_value_cur;
    assign ex_operand2_cur = (ex_operand2_sel_cur == 2'b11) ? id_ex_offset_cur
                                                             : ex_rs2_value_cur;
    assign ex_store_data_cur = ex_rs2_value_cur;

    execute u_execute (
        .AluOp      (id_ex_alu_op_cur),
        .Func3      (id_ex_func3_cur),
        .Func7      (id_ex_func7_cur),
        .opcode     (id_ex_opcode_cur),
        .Operand1   (ex_operand1_cur),
        .Operand2   (ex_operand2_cur),
        .AluResult  (ex_alu_result_cur),
        .ALUeq      (ex_alu_eq_cur),
        .ALUslt     (ex_alu_slt_cur)
    );

    assign ex_branch_target_cur   = id_ex_pc_cur + id_ex_offset_cur;
    assign ex_jump_target_raw_cur = id_ex_pc_src_cur ? (ex_operand1_cur + id_ex_offset_cur)
                                                      : (id_ex_pc_cur + id_ex_offset_cur);
    assign ex_jump_target_cur     = id_ex_pc_src_cur ? {ex_jump_target_raw_cur[31:1], 1'b0}
                                                     : ex_jump_target_raw_cur;
    assign ex_control_target_cur  = id_ex_jump_cur ? ex_jump_target_cur : ex_branch_target_cur;

    assign ex_branch_taken_cur =
        id_ex_valid_cur & ~mem_stage_stall_cur & id_ex_branch_cur &
        ((id_ex_func3_cur == 3'b000) ?  ex_alu_eq_cur  : // beq
         (id_ex_func3_cur == 3'b001) ? ~ex_alu_eq_cur  : // bne
         (id_ex_func3_cur == 3'b100) ?  ex_alu_slt_cur : // blt
         (id_ex_func3_cur == 3'b101) ? ~ex_alu_slt_cur : // bge
         (id_ex_func3_cur == 3'b110) ?  ex_alu_slt_cur : // bltu
         (id_ex_func3_cur == 3'b111) ? ~ex_alu_slt_cur : // bgeu
                                        1'b0);
    assign ex_jump_taken_cur      = id_ex_valid_cur & ~mem_stage_stall_cur & id_ex_jump_cur;
    assign ex_control_taken_cur   = ex_branch_taken_cur | ex_jump_taken_cur;
    assign ex_pc_misalign_trap_cur= ex_control_taken_cur & (|ex_control_target_cur[1:0]);
    assign bp_actual_taken_cur    = ex_control_taken_cur & ~ex_pc_misalign_trap_cur;
    assign ex_next_pc_cur         = bp_actual_taken_cur ? ex_control_target_cur : id_ex_pc_plus4_cur;
    assign ex_pred_next_pc_cur    = id_ex_pred_taken_cur ? id_ex_pred_target_cur : id_ex_pc_plus4_cur;
    assign ex_redirect_cur        = id_ex_valid_cur & ~mem_stage_stall_cur &
                                    ~ex_pc_misalign_trap_cur &
                                    (ex_next_pc_cur != ex_pred_next_pc_cur);
    assign bp_update_cur          = id_ex_valid_cur & ~mem_stage_stall_cur &
                                    (id_ex_branch_cur | id_ex_jump_cur) &
                                    ~id_ex_illegal_inst_cur &
                                    ~id_ex_ebreak_cur &
                                    ~ex_pc_misalign_trap_cur;
    assign bp_update_set_cur      = id_ex_pc_cur[BP_SET_W + 1:2];
    assign bp_update_tag_cur      = id_ex_pc_cur[31:BP_SET_W + 2];
    assign bp_update_way0_hit_cur = bp_valid0_cur[bp_update_set_cur] &
                                    (bp_tags0_cur[bp_update_set_cur] == bp_update_tag_cur);
    assign bp_update_way1_hit_cur = bp_valid1_cur[bp_update_set_cur] &
                                    (bp_tags1_cur[bp_update_set_cur] == bp_update_tag_cur);
    assign bp_update_way_sel_cur  = bp_update_way1_hit_cur ? 1'b1 :
                                    bp_update_way0_hit_cur ? 1'b0 :
                                    ~bp_valid0_cur[bp_update_set_cur] ? 1'b0 :
                                    ~bp_valid1_cur[bp_update_set_cur] ? 1'b1 :
                                    bp_repl_cur[bp_update_set_cur];

    assign ex_mem_valid_next        = id_ex_valid_cur;
    assign ex_mem_pc_next           = id_ex_pc_cur;
    assign ex_mem_pc_plus4_next     = id_ex_pc_plus4_cur;
    assign ex_mem_next_pc_next      = ex_next_pc_cur;
    assign ex_mem_inst_next         = id_ex_inst_cur;
    assign ex_mem_rs1_raddr_next    = id_ex_rs1_raddr_cur;
    assign ex_mem_rs2_raddr_next    = id_ex_rs2_raddr_cur;
    assign ex_mem_rd_waddr_next     = id_ex_rd_waddr_cur;
    assign ex_mem_rs1_rdata_next    = ex_rs1_value_cur;
    assign ex_mem_rs2_rdata_next    = ex_rs2_value_cur;
    assign ex_mem_offset_next       = id_ex_offset_cur;
    assign ex_mem_alu_result_next   = ex_alu_result_cur;
    assign ex_mem_store_data_next   = ex_store_data_cur;
    assign ex_mem_func3_next        = id_ex_func3_cur;
    assign ex_mem_mem_write_next    = id_ex_mem_write_cur;
    assign ex_mem_mem_read_next     = id_ex_mem_read_cur;
    assign ex_mem_mem_to_reg_next   = id_ex_mem_to_reg_cur;
    assign ex_mem_lui_next          = id_ex_lui_cur;
    assign ex_mem_jump_next         = id_ex_jump_cur;
    assign ex_mem_reg_write_next    = id_ex_reg_write_cur;
    assign ex_mem_illegal_inst_next = id_ex_illegal_inst_cur;
    assign ex_mem_pc_misalign_trap_next = ex_pc_misalign_trap_cur;
    assign ex_mem_ebreak_next       = id_ex_ebreak_cur;

    // -------------------------------------------------------------------------
    // MEM stage
    // -------------------------------------------------------------------------
    assign mem_read_en_cur  = ex_mem_valid_cur & ex_mem_mem_read_cur;
    assign mem_write_en_cur = ex_mem_valid_cur & ex_mem_mem_write_cur;
    assign mem_store_data_fwd_cur = mem_wb_valid_cur &
                                    mem_wb_mem_to_reg_cur &
                                    ex_mem_valid_cur &
                                    ex_mem_mem_write_cur &
                                    (mem_wb_rd_waddr_cur != 5'd0) &
                                    (mem_wb_rd_waddr_cur == ex_mem_rs2_raddr_cur);
    assign mem_store_data_cur = mem_store_data_fwd_cur ? mem_wb_load_data_cur
                                                       : ex_mem_store_data_cur;

    dmem_access u_memory (
        .EffAddr         (ex_mem_alu_result_cur),
        .StoreData       (mem_store_data_cur),
        .Func3           (ex_mem_func3_cur),
        .MemRead         (mem_read_en_cur),
        .MemWrite        (mem_write_en_cur),
        .i_dmem_rdata    (dmem_cache_rdata_cur),
        .o_dmem_addr     (mem_dmem_addr_cur),
        .o_dmem_mask     (mem_dmem_mask_cur),
        .o_dmem_wdata    (mem_dmem_wdata_cur),
        .o_dmem_ren      (mem_dmem_ren_raw_cur),
        .o_dmem_wen      (mem_dmem_wen_raw_cur),
        .LoadData        (mem_load_data_cur),
        .MisalignTrap    (mem_misalign_trap_cur)
    );

    assign ex_mem_has_dmem_req_cur = ex_mem_valid_cur &
                                     (ex_mem_mem_read_cur | ex_mem_mem_write_cur) &
                                     ~mem_misalign_trap_cur;
    assign dmem_req_fire_cur       = ex_mem_has_dmem_req_cur &
                                     ~ex_mem_dmem_req_sent_cur;
    assign dmem_resp_fire_cur      = ex_mem_valid_cur &
                                     ex_mem_mem_read_cur &
                                     ~mem_misalign_trap_cur &
                                     (ex_mem_dmem_req_sent_cur | dmem_req_fire_cur) &
                                     ~dmem_cache_busy_cur;
    assign mem_stage_complete_cur  = ex_mem_valid_cur &
                                     (~ex_mem_has_dmem_req_cur |
                                      ~dmem_cache_busy_cur);
    assign mem_stage_stall_cur     = ex_mem_valid_cur & ~mem_stage_complete_cur;

    assign mem_dcache_req_ren_cur = mem_dmem_ren_raw_cur & dmem_req_fire_cur;
    assign mem_dcache_req_wen_cur = mem_dmem_wen_raw_cur & dmem_req_fire_cur;
    assign mem_dmem_ren_cur       = mem_dcache_req_ren_cur;
    assign mem_dmem_wen_cur       = mem_dcache_req_wen_cur;

    assign o_dmem_addr  = dmem_cache_mem_addr_cur;
    assign o_dmem_mask  = (dmem_cache_mem_ren_cur | dmem_cache_mem_wen_cur) ? 4'b1111 : 4'b0000;
    assign o_dmem_wdata = dmem_cache_mem_wdata_cur;
    assign o_dmem_ren   = dmem_cache_mem_ren_cur;
    assign o_dmem_wen   = dmem_cache_mem_wen_cur;

    assign mem_wb_valid_next            = mem_stage_complete_cur;
    assign mem_wb_pc_next               = mem_stage_complete_cur ? ex_mem_pc_cur : 32'd0;
    assign mem_wb_pc_plus4_next         = mem_stage_complete_cur ? ex_mem_pc_plus4_cur : 32'd0;
    assign mem_wb_next_pc_next          = mem_stage_complete_cur ? ex_mem_next_pc_cur : 32'd0;
    assign mem_wb_inst_next             = mem_stage_complete_cur ? ex_mem_inst_cur : 32'd0;
    assign mem_wb_rs1_raddr_next        = mem_stage_complete_cur ? ex_mem_rs1_raddr_cur : 5'd0;
    assign mem_wb_rs2_raddr_next        = mem_stage_complete_cur ? ex_mem_rs2_raddr_cur : 5'd0;
    assign mem_wb_rd_waddr_next         = mem_stage_complete_cur ? ex_mem_rd_waddr_cur : 5'd0;
    assign mem_wb_rs1_rdata_next        = mem_stage_complete_cur ? ex_mem_rs1_rdata_cur : 32'd0;
    assign mem_wb_rs2_rdata_next        = mem_stage_complete_cur ? ex_mem_rs2_rdata_cur : 32'd0;
    assign mem_wb_offset_next           = mem_stage_complete_cur ? ex_mem_offset_cur : 32'd0;
    assign mem_wb_alu_result_next       = mem_stage_complete_cur ? ex_mem_alu_result_cur : 32'd0;
    assign mem_wb_load_data_next        = dmem_resp_fire_cur ? mem_load_data_cur : 32'd0;
    assign mem_wb_dmem_addr_next        = mem_stage_complete_cur ? mem_dmem_addr_cur : 32'd0;
    assign mem_wb_dmem_ren_next         = mem_stage_complete_cur ? mem_dmem_ren_raw_cur : 1'b0;
    assign mem_wb_dmem_wen_next         = mem_stage_complete_cur ? mem_dmem_wen_raw_cur : 1'b0;
    assign mem_wb_dmem_mask_next        = mem_stage_complete_cur ? mem_dmem_mask_cur : 4'd0;
    assign mem_wb_dmem_wdata_next       = mem_stage_complete_cur ? mem_dmem_wdata_cur : 32'd0;
    assign mem_wb_dmem_rdata_next       = dmem_resp_fire_cur ? dmem_cache_rdata_cur : 32'd0;
    assign mem_wb_mem_to_reg_next       = mem_stage_complete_cur ? ex_mem_mem_to_reg_cur : 1'b0;
    assign mem_wb_lui_next              = mem_stage_complete_cur ? ex_mem_lui_cur : 1'b0;
    assign mem_wb_jump_next             = mem_stage_complete_cur ? ex_mem_jump_cur : 1'b0;
    assign mem_wb_reg_write_next        = mem_stage_complete_cur ? ex_mem_reg_write_cur : 1'b0;
    assign mem_wb_illegal_inst_next     = mem_stage_complete_cur ? ex_mem_illegal_inst_cur : 1'b0;
    assign mem_wb_pc_misalign_trap_next = mem_stage_complete_cur ? ex_mem_pc_misalign_trap_cur : 1'b0;
    assign mem_wb_misalign_trap_next    = mem_stage_complete_cur ? mem_misalign_trap_cur : 1'b0;
    assign mem_wb_ebreak_next           = mem_stage_complete_cur ? ex_mem_ebreak_cur : 1'b0;

    // -------------------------------------------------------------------------
    // WB stage
    // -------------------------------------------------------------------------
    writeback u_writeback (
        .AluResult  (mem_wb_alu_result_cur),
        .LoadData   (mem_wb_load_data_cur),
        .pc_plus4   (mem_wb_pc_plus4_cur),
        .Offset     (mem_wb_offset_cur),
        .MemToReg   (mem_wb_mem_to_reg_cur),
        .lui        (mem_wb_lui_cur),
        .Jump       (mem_wb_jump_cur),
        .WriteData  (wb_write_data_cur)
    );

    assign wb_trap_cur         = mem_wb_illegal_inst_cur |
                                 mem_wb_pc_misalign_trap_cur |
                                 mem_wb_misalign_trap_cur;
    assign wb_write_enable_cur = mem_wb_valid_cur & mem_wb_reg_write_cur & ~wb_trap_cur;
    assign retire_halt_cur     = mem_wb_valid_cur & mem_wb_ebreak_cur;

    // -------------------------------------------------------------------------
    // Retire outputs
    // -------------------------------------------------------------------------
    assign o_retire_valid     = mem_wb_valid_cur;
    assign o_retire_inst      = mem_wb_inst_cur;
    assign o_retire_trap      = mem_wb_valid_cur & wb_trap_cur;
    assign o_retire_halt      = retire_halt_cur;
    assign o_retire_rs1_raddr = mem_wb_rs1_raddr_cur;
    assign o_retire_rs2_raddr = mem_wb_rs2_raddr_cur;
    assign o_retire_rs1_rdata = mem_wb_rs1_rdata_cur;
    assign o_retire_rs2_rdata = mem_wb_rs2_rdata_cur;
    assign o_retire_rd_waddr  = wb_write_enable_cur ? mem_wb_rd_waddr_cur : 5'd0;
    assign o_retire_rd_wdata  = wb_write_data_cur;
    assign o_retire_dmem_addr = mem_wb_dmem_addr_cur;
    assign o_retire_dmem_ren  = mem_wb_dmem_ren_cur;
    assign o_retire_dmem_wen  = mem_wb_dmem_wen_cur;
    assign o_retire_dmem_mask = mem_wb_dmem_mask_cur;
    assign o_retire_dmem_wdata= mem_wb_dmem_wdata_cur;
    assign o_retire_dmem_rdata= mem_wb_dmem_rdata_cur;
    assign o_retire_pc        = mem_wb_pc_cur;
    assign o_retire_next_pc   = mem_wb_next_pc_cur;

    // -------------------------------------------------------------------------
    // Sequential update
    // -------------------------------------------------------------------------
    always @(posedge i_clk) begin
        if (i_rst) begin
            pc_cur <= RESET_ADDR;
            halted_cur <= 1'b0;
            imem_pending_cur <= 1'b0;
            imem_pending_kill_cur <= 1'b0;
            imem_pending_pc_cur <= 32'd0;
            imem_pending_pred_taken_cur <= 1'b0;
            imem_pending_pred_target_cur <= 32'd0;
            bp_valid0_cur <= {BP_SETS{1'b0}};
            bp_valid1_cur <= {BP_SETS{1'b0}};
            bp_repl_cur <= {BP_SETS{1'b0}};
            bp_pht_valid_cur <= {PHT_ENTRIES{1'b0}};
            bp_ghr_cur   <= {PHT_INDEX_W{1'b0}};

            ras_head_cur  <= 3'd0;
            ras_valid_cur <= 1'b0;

            if_id_valid_cur <= 1'b0;
            if_id_pc_cur <= 32'd0;
            if_id_pc_plus4_cur <= 32'd0;
            if_id_inst_cur <= 32'd0;
            if_id_pred_taken_cur <= 1'b0;
            if_id_pred_target_cur <= 32'd0;
            if_id_pht_index_cur <= {PHT_INDEX_W{1'b0}};
            if_id_ras_head_cur <= 3'd0;
            if_id_ras_valid_cur <= 1'b0;

            id_ex_valid_cur <= 1'b0;
            id_ex_pc_cur <= 32'd0;
            id_ex_pc_plus4_cur <= 32'd0;
            id_ex_inst_cur <= 32'd0;
            id_ex_rs1_raddr_cur <= 5'd0;
            id_ex_rs2_raddr_cur <= 5'd0;
            id_ex_rd_waddr_cur <= 5'd0;
            id_ex_rs1_rdata_cur <= 32'd0;
            id_ex_rs2_rdata_cur <= 32'd0;
            id_ex_offset_cur <= 32'd0;
            id_ex_opcode_cur <= 7'd0;
            id_ex_func3_cur <= 3'd0;
            id_ex_func7_cur <= 7'd0;
            id_ex_lui_cur <= 1'b0;
            id_ex_pc_src_cur <= 1'b0;
            id_ex_alu_op_cur <= 3'd0;
            id_ex_mem_write_cur <= 1'b0;
            id_ex_mem_read_cur <= 1'b0;
            id_ex_mem_to_reg_cur <= 1'b0;
            id_ex_alu_src1_cur <= 1'b0;
            id_ex_alu_src2_cur <= 1'b0;
            id_ex_reg_write_cur <= 1'b0;
            id_ex_jump_cur <= 1'b0;
            id_ex_branch_cur <= 1'b0;
            id_ex_illegal_inst_cur <= 1'b0;
            id_ex_ebreak_cur <= 1'b0;
            id_ex_pred_taken_cur <= 1'b0;
            id_ex_pred_target_cur <= 32'd0;
            id_ex_pht_index_cur <= {PHT_INDEX_W{1'b0}};
            id_ex_ras_head_cur <= 3'd0;
            id_ex_ras_valid_cur <= 1'b0;

            ex_mem_valid_cur <= 1'b0;
            ex_mem_pc_cur <= 32'd0;
            ex_mem_pc_plus4_cur <= 32'd0;
            ex_mem_next_pc_cur <= 32'd0;
            ex_mem_inst_cur <= 32'd0;
            ex_mem_rs1_raddr_cur <= 5'd0;
            ex_mem_rs2_raddr_cur <= 5'd0;
            ex_mem_rd_waddr_cur <= 5'd0;
            ex_mem_rs1_rdata_cur <= 32'd0;
            ex_mem_rs2_rdata_cur <= 32'd0;
            ex_mem_offset_cur <= 32'd0;
            ex_mem_alu_result_cur <= 32'd0;
            ex_mem_store_data_cur <= 32'd0;
            ex_mem_func3_cur <= 3'd0;
            ex_mem_mem_write_cur <= 1'b0;
            ex_mem_mem_read_cur <= 1'b0;
            ex_mem_mem_to_reg_cur <= 1'b0;
            ex_mem_lui_cur <= 1'b0;
            ex_mem_jump_cur <= 1'b0;
            ex_mem_reg_write_cur <= 1'b0;
            ex_mem_illegal_inst_cur <= 1'b0;
            ex_mem_pc_misalign_trap_cur <= 1'b0;
            ex_mem_ebreak_cur <= 1'b0;
            ex_mem_dmem_req_sent_cur <= 1'b0;

            mem_wb_valid_cur <= 1'b0;
            mem_wb_pc_cur <= 32'd0;
            mem_wb_pc_plus4_cur <= 32'd0;
            mem_wb_next_pc_cur <= 32'd0;
            mem_wb_inst_cur <= 32'd0;
            mem_wb_rs1_raddr_cur <= 5'd0;
            mem_wb_rs2_raddr_cur <= 5'd0;
            mem_wb_rd_waddr_cur <= 5'd0;
            mem_wb_rs1_rdata_cur <= 32'd0;
            mem_wb_rs2_rdata_cur <= 32'd0;
            mem_wb_offset_cur <= 32'd0;
            mem_wb_alu_result_cur <= 32'd0;
            mem_wb_load_data_cur <= 32'd0;
            mem_wb_dmem_addr_cur <= 32'd0;
            mem_wb_dmem_ren_cur <= 1'b0;
            mem_wb_dmem_wen_cur <= 1'b0;
            mem_wb_dmem_mask_cur <= 4'd0;
            mem_wb_dmem_wdata_cur <= 32'd0;
            mem_wb_dmem_rdata_cur <= 32'd0;
            mem_wb_mem_to_reg_cur <= 1'b0;
            mem_wb_lui_cur <= 1'b0;
            mem_wb_jump_cur <= 1'b0;
            mem_wb_reg_write_cur <= 1'b0;
            mem_wb_illegal_inst_cur <= 1'b0;
            mem_wb_pc_misalign_trap_cur <= 1'b0;
            mem_wb_misalign_trap_cur <= 1'b0;
            mem_wb_ebreak_cur <= 1'b0;
        end else if (retire_halt_cur) begin
            halted_cur <= 1'b1;
            imem_pending_cur <= 1'b0;
            imem_pending_kill_cur <= 1'b0;
            imem_pending_pc_cur <= 32'd0;
            imem_pending_pred_taken_cur <= 1'b0;
            imem_pending_pred_target_cur <= 32'd0;

            if_id_valid_cur <= 1'b0;
            if_id_pc_cur <= 32'd0;
            if_id_pc_plus4_cur <= 32'd0;
            if_id_inst_cur <= 32'd0;
            if_id_pred_taken_cur <= 1'b0;
            if_id_pred_target_cur <= 32'd0;
            if_id_pht_index_cur <= {PHT_INDEX_W{1'b0}};
            if_id_ras_head_cur <= 3'd0;
            if_id_ras_valid_cur <= 1'b0;

            id_ex_valid_cur <= 1'b0;
            id_ex_pc_cur <= 32'd0;
            id_ex_pc_plus4_cur <= 32'd0;
            id_ex_inst_cur <= 32'd0;
            id_ex_rs1_raddr_cur <= 5'd0;
            id_ex_rs2_raddr_cur <= 5'd0;
            id_ex_rd_waddr_cur <= 5'd0;
            id_ex_rs1_rdata_cur <= 32'd0;
            id_ex_rs2_rdata_cur <= 32'd0;
            id_ex_offset_cur <= 32'd0;
            id_ex_opcode_cur <= 7'd0;
            id_ex_func3_cur <= 3'd0;
            id_ex_func7_cur <= 7'd0;
            id_ex_lui_cur <= 1'b0;
            id_ex_pc_src_cur <= 1'b0;
            id_ex_alu_op_cur <= 3'd0;
            id_ex_mem_write_cur <= 1'b0;
            id_ex_mem_read_cur <= 1'b0;
            id_ex_mem_to_reg_cur <= 1'b0;
            id_ex_alu_src1_cur <= 1'b0;
            id_ex_alu_src2_cur <= 1'b0;
            id_ex_reg_write_cur <= 1'b0;
            id_ex_jump_cur <= 1'b0;
            id_ex_branch_cur <= 1'b0;
            id_ex_illegal_inst_cur <= 1'b0;
            id_ex_ebreak_cur <= 1'b0;
            id_ex_pred_taken_cur <= 1'b0;
            id_ex_pred_target_cur <= 32'd0;
            id_ex_pht_index_cur <= {PHT_INDEX_W{1'b0}};
            id_ex_ras_head_cur <= 3'd0;
            id_ex_ras_valid_cur <= 1'b0;

            ex_mem_valid_cur <= 1'b0;
            ex_mem_pc_cur <= 32'd0;
            ex_mem_pc_plus4_cur <= 32'd0;
            ex_mem_next_pc_cur <= 32'd0;
            ex_mem_inst_cur <= 32'd0;
            ex_mem_rs1_raddr_cur <= 5'd0;
            ex_mem_rs2_raddr_cur <= 5'd0;
            ex_mem_rd_waddr_cur <= 5'd0;
            ex_mem_rs1_rdata_cur <= 32'd0;
            ex_mem_rs2_rdata_cur <= 32'd0;
            ex_mem_offset_cur <= 32'd0;
            ex_mem_alu_result_cur <= 32'd0;
            ex_mem_store_data_cur <= 32'd0;
            ex_mem_func3_cur <= 3'd0;
            ex_mem_mem_write_cur <= 1'b0;
            ex_mem_mem_read_cur <= 1'b0;
            ex_mem_mem_to_reg_cur <= 1'b0;
            ex_mem_lui_cur <= 1'b0;
            ex_mem_jump_cur <= 1'b0;
            ex_mem_reg_write_cur <= 1'b0;
            ex_mem_illegal_inst_cur <= 1'b0;
            ex_mem_pc_misalign_trap_cur <= 1'b0;
            ex_mem_ebreak_cur <= 1'b0;
            ex_mem_dmem_req_sent_cur <= 1'b0;

            mem_wb_valid_cur <= 1'b0;
            mem_wb_pc_cur <= 32'd0;
            mem_wb_pc_plus4_cur <= 32'd0;
            mem_wb_next_pc_cur <= 32'd0;
            mem_wb_inst_cur <= 32'd0;
            mem_wb_rs1_raddr_cur <= 5'd0;
            mem_wb_rs2_raddr_cur <= 5'd0;
            mem_wb_rd_waddr_cur <= 5'd0;
            mem_wb_rs1_rdata_cur <= 32'd0;
            mem_wb_rs2_rdata_cur <= 32'd0;
            mem_wb_offset_cur <= 32'd0;
            mem_wb_alu_result_cur <= 32'd0;
            mem_wb_load_data_cur <= 32'd0;
            mem_wb_dmem_addr_cur <= 32'd0;
            mem_wb_dmem_ren_cur <= 1'b0;
            mem_wb_dmem_wen_cur <= 1'b0;
            mem_wb_dmem_mask_cur <= 4'd0;
            mem_wb_dmem_wdata_cur <= 32'd0;
            mem_wb_dmem_rdata_cur <= 32'd0;
            mem_wb_mem_to_reg_cur <= 1'b0;
            mem_wb_lui_cur <= 1'b0;
            mem_wb_jump_cur <= 1'b0;
            mem_wb_reg_write_cur <= 1'b0;
            mem_wb_illegal_inst_cur <= 1'b0;
            mem_wb_pc_misalign_trap_cur <= 1'b0;
            mem_wb_misalign_trap_cur <= 1'b0;
            mem_wb_ebreak_cur <= 1'b0;
        end else if (~halted_cur) begin
            // RAS update. Push on accepted JAL-with-link, pop on accepted
            // JALR-with-link-source. Both may fire in the same cycle for
            // coroutine-style swap forms, but our detection excludes that
            // case (pop requires rd != rs1 or rd == 0).
            //
            // Rollback: on EX/ID redirect, restore the RAS head/valid to the
            // snapshot captured when the redirecting instruction was at IF.
            // ras_push_fire_cur / ras_pop_fire_cur are gated to be 0 on
            // redirect cycles, so push/pop and rollback are mutually exclusive.
            if (ex_redirect_cur) begin
                ras_head_cur  <= id_ex_ras_head_cur;
                ras_valid_cur <= id_ex_ras_valid_cur;
            end else if (id_redirect_cur) begin
                ras_head_cur  <= if_id_ras_head_cur;
                ras_valid_cur <= if_id_ras_valid_cur;
            end else if (ras_push_fire_cur) begin
                ras_stack_cur[ras_head_cur] <= imem_resp_pc_cur + 32'd4;
                ras_head_cur  <= ras_head_cur + 3'd1;
                ras_valid_cur <= 1'b1;
            end else if (ras_pop_fire_cur) begin
                ras_head_cur <= ras_head_cur - 3'd1;
                // Track emptiness: after popping, if head will be 0, mark invalid.
                if (ras_head_cur == 3'd1)
                    ras_valid_cur <= 1'b0;
            end

            if (bp_update_cur) begin
                bp_repl_cur[bp_update_set_cur] <= ~bp_update_way_sel_cur;
                if (~bp_update_way_sel_cur) begin
                    bp_valid0_cur[bp_update_set_cur] <= 1'b1;
                    bp_tags0_cur[bp_update_set_cur] <= bp_update_tag_cur;
                    bp_targets0_cur[bp_update_set_cur] <= ex_control_target_cur;
                    if (~bp_update_way0_hit_cur) begin
                        bp_counters0_cur[bp_update_set_cur] <=
                            bp_actual_taken_cur ? 2'b10 : 2'b01;
                    end else if (bp_actual_taken_cur) begin
                        if (bp_counters0_cur[bp_update_set_cur] != 2'b11)
                            bp_counters0_cur[bp_update_set_cur] <=
                                bp_counters0_cur[bp_update_set_cur] + 1'b1;
                    end else begin
                        if (bp_counters0_cur[bp_update_set_cur] != 2'b00)
                            bp_counters0_cur[bp_update_set_cur] <=
                                bp_counters0_cur[bp_update_set_cur] - 1'b1;
                    end
                end else begin
                    bp_valid1_cur[bp_update_set_cur] <= 1'b1;
                    bp_tags1_cur[bp_update_set_cur] <= bp_update_tag_cur;
                    bp_targets1_cur[bp_update_set_cur] <= ex_control_target_cur;
                    if (~bp_update_way1_hit_cur) begin
                        bp_counters1_cur[bp_update_set_cur] <=
                            bp_actual_taken_cur ? 2'b10 : 2'b01;
                    end else if (bp_actual_taken_cur) begin
                        if (bp_counters1_cur[bp_update_set_cur] != 2'b11)
                            bp_counters1_cur[bp_update_set_cur] <=
                                bp_counters1_cur[bp_update_set_cur] + 1'b1;
                    end else begin
                        if (bp_counters1_cur[bp_update_set_cur] != 2'b00)
                            bp_counters1_cur[bp_update_set_cur] <=
                                bp_counters1_cur[bp_update_set_cur] - 1'b1;
                    end
                end

                // PHT update: 2-bit saturating counter at the index that was
                // used at fetch (captured in id_ex_pht_index_cur). Only
                // conditional branches contribute to global history; JAL/JALR
                // are unconditional and would just bias the GHR.
                if (id_ex_branch_cur) begin
                    bp_pht_valid_cur[id_ex_pht_index_cur] <= 1'b1;
                    if (bp_actual_taken_cur) begin
                        if (~bp_pht_valid_cur[id_ex_pht_index_cur])
                            bp_pht_cur[id_ex_pht_index_cur] <= 2'b10;
                        else if (bp_pht_cur[id_ex_pht_index_cur] != 2'b11)
                            bp_pht_cur[id_ex_pht_index_cur] <=
                                bp_pht_cur[id_ex_pht_index_cur] + 1'b1;
                    end else begin
                        if (~bp_pht_valid_cur[id_ex_pht_index_cur])
                            bp_pht_cur[id_ex_pht_index_cur] <= 2'b00;
                        else if (bp_pht_cur[id_ex_pht_index_cur] != 2'b00)
                            bp_pht_cur[id_ex_pht_index_cur] <=
                                bp_pht_cur[id_ex_pht_index_cur] - 1'b1;
                    end
                    // Shift the actual outcome into the GHR.
                    bp_ghr_cur <= {bp_ghr_cur[PHT_INDEX_W - 2:0], bp_actual_taken_cur};
                end
            end

            if (ex_redirect_cur)
                pc_cur <= pc_next;
            else if (id_redirect_cur)
                pc_cur <= pc_next;
            else if (imem_resp_late_redirect_cur)
                pc_cur <= imem_resp_static_pred_target_cur;
            else if (imem_req_fire_cur)
                pc_cur <= pc_next;

            if (imem_resp_fire_cur) begin
                imem_pending_cur <= 1'b0;
                imem_pending_kill_cur <= 1'b0;
                imem_pending_pc_cur <= 32'd0;
                imem_pending_pred_taken_cur <= 1'b0;
                imem_pending_pred_target_cur <= 32'd0;
            end else if (imem_req_fire_cur & imem_cache_busy_cur) begin
                imem_pending_cur <= 1'b1;
                imem_pending_kill_cur <= 1'b0;
                imem_pending_pc_cur <= if_pc_cur;
                imem_pending_pred_taken_cur <= if_pred_taken_cur;
                imem_pending_pred_target_cur <= if_pred_target_cur;
            end else if ((ex_redirect_cur | id_redirect_cur) && imem_pending_cur) begin
                imem_pending_kill_cur <= 1'b1;
            end

            if (ex_redirect_cur) begin
                // Taken branch/jump redirects fetch and squashes younger instructions.
                if_id_valid_cur <= 1'b0;
                if_id_pc_cur <= 32'd0;
                if_id_pc_plus4_cur <= 32'd0;
                if_id_inst_cur <= 32'd0;
                if_id_pred_taken_cur <= 1'b0;
                if_id_pred_target_cur <= 32'd0;
            if_id_pht_index_cur <= {PHT_INDEX_W{1'b0}};
                if_id_ras_head_cur <= 3'd0;
                if_id_ras_valid_cur <= 1'b0;

                id_ex_valid_cur <= 1'b0;
                id_ex_pc_cur <= 32'd0;
                id_ex_pc_plus4_cur <= 32'd0;
                id_ex_inst_cur <= 32'd0;
                id_ex_rs1_raddr_cur <= 5'd0;
                id_ex_rs2_raddr_cur <= 5'd0;
                id_ex_rd_waddr_cur <= 5'd0;
                id_ex_rs1_rdata_cur <= 32'd0;
                id_ex_rs2_rdata_cur <= 32'd0;
                id_ex_offset_cur <= 32'd0;
                id_ex_opcode_cur <= 7'd0;
                id_ex_func3_cur <= 3'd0;
                id_ex_func7_cur <= 7'd0;
                id_ex_lui_cur <= 1'b0;
                id_ex_pc_src_cur <= 1'b0;
                id_ex_alu_op_cur <= 3'd0;
                id_ex_mem_write_cur <= 1'b0;
                id_ex_mem_read_cur <= 1'b0;
                id_ex_mem_to_reg_cur <= 1'b0;
                id_ex_alu_src1_cur <= 1'b0;
                id_ex_alu_src2_cur <= 1'b0;
                id_ex_reg_write_cur <= 1'b0;
                id_ex_jump_cur <= 1'b0;
                id_ex_branch_cur <= 1'b0;
                id_ex_illegal_inst_cur <= 1'b0;
                id_ex_ebreak_cur <= 1'b0;
                id_ex_pred_taken_cur <= 1'b0;
                id_ex_pred_target_cur <= 32'd0;
            id_ex_pht_index_cur <= {PHT_INDEX_W{1'b0}};
                id_ex_ras_head_cur <= 3'd0;
                id_ex_ras_valid_cur <= 1'b0;
            end else if (id_redirect_cur) begin
                // ID-stage direct-branch/JAL mispredict: the branch instr
                // still advances into EX (for retirement and BTB update),
                // but the wrongly-fetched successor in IF (or pending imem)
                // is squashed. Only the IF/ID bubble is lost - 1 cycle
                // penalty instead of the 3 cycles an EX-stage redirect has.
                if_id_valid_cur <= 1'b0;
                if_id_pc_cur <= 32'd0;
                if_id_pc_plus4_cur <= 32'd0;
                if_id_inst_cur <= 32'd0;
                if_id_pred_taken_cur <= 1'b0;
                if_id_pred_target_cur <= 32'd0;
            if_id_pht_index_cur <= {PHT_INDEX_W{1'b0}};
                if_id_ras_head_cur <= 3'd0;
                if_id_ras_valid_cur <= 1'b0;

                id_ex_valid_cur <= id_ex_valid_next;
                id_ex_pc_cur <= id_ex_pc_next;
                id_ex_pc_plus4_cur <= id_ex_pc_plus4_next;
                id_ex_inst_cur <= id_ex_inst_next;
                id_ex_rs1_raddr_cur <= id_ex_rs1_raddr_next;
                id_ex_rs2_raddr_cur <= id_ex_rs2_raddr_next;
                id_ex_rd_waddr_cur <= id_ex_rd_waddr_next;
                id_ex_rs1_rdata_cur <= id_fwd_rs1_cur;
                id_ex_rs2_rdata_cur <= id_fwd_rs2_cur;
                id_ex_offset_cur <= id_ex_offset_next;
                id_ex_opcode_cur <= id_ex_opcode_next;
                id_ex_func3_cur <= id_ex_func3_next;
                id_ex_func7_cur <= id_ex_func7_next;
                id_ex_lui_cur <= id_ex_lui_next;
                id_ex_pc_src_cur <= id_ex_pc_src_next;
                id_ex_alu_op_cur <= id_ex_alu_op_next;
                id_ex_mem_write_cur <= id_ex_mem_write_next;
                id_ex_mem_read_cur <= id_ex_mem_read_next;
                id_ex_mem_to_reg_cur <= id_ex_mem_to_reg_next;
                id_ex_alu_src1_cur <= id_ex_alu_src1_next;
                id_ex_alu_src2_cur <= id_ex_alu_src2_next;
                id_ex_reg_write_cur <= id_ex_reg_write_next;
                id_ex_jump_cur <= id_ex_jump_next;
                id_ex_branch_cur <= id_ex_branch_next;  // keep flag so EX updates BTB
                id_ex_illegal_inst_cur <= id_ex_illegal_inst_next;
                id_ex_ebreak_cur <= id_ex_ebreak_next;
                // Give EX the RESOLVED next-PC as the predicted next-PC so
                // EX's redirect-compare remains consistent and does not fire
                // for a direct branch already handled here.
                id_ex_pred_taken_cur  <= id_control_taken_cur;
                id_ex_pred_target_cur <= id_next_pc_cur;
                id_ex_pht_index_cur   <= if_id_pht_index_cur;
                // The branch instruction itself moves from IF/ID into ID/EX,
                // so its RAS snapshot follows it.
                id_ex_ras_head_cur    <= if_id_ras_head_cur;
                id_ex_ras_valid_cur   <= if_id_ras_valid_cur;
            end else if (mem_stage_stall_cur) begin
                if (imem_resp_accept_cur) begin
                    if_id_valid_cur <= if_id_valid_next;
                    if_id_pc_cur <= if_id_pc_next;
                    if_id_pc_plus4_cur <= if_id_pc_plus4_next;
                    if_id_inst_cur <= if_id_inst_next;
                    if_id_pred_taken_cur <= if_id_pred_taken_next;
                    if_id_pred_target_cur <= if_id_pred_target_next;
                    if_id_pht_index_cur <= if_id_pht_index_next;
                    if_id_ras_head_cur <= ras_head_cur;
                    if_id_ras_valid_cur <= ras_valid_cur;
                end

                // Preserve the fully-resolved EX operands while this
                // instruction waits behind a stalled memory operation.
                // Otherwise a one-cycle WB forwarding value can disappear
                // before the held EX instruction is allowed to advance.
                id_ex_rs1_rdata_cur <= ex_rs1_value_cur;
                id_ex_rs2_rdata_cur <= ex_rs2_value_cur;
            end else if (hazard_stall_cur) begin
                // Stall fetch/decode and inject bubble into ID/EX.
                id_ex_valid_cur <= 1'b0;
                id_ex_pc_cur <= 32'd0;
                id_ex_pc_plus4_cur <= 32'd0;
                id_ex_inst_cur <= 32'd0;
                id_ex_rs1_raddr_cur <= 5'd0;
                id_ex_rs2_raddr_cur <= 5'd0;
                id_ex_rd_waddr_cur <= 5'd0;
                id_ex_rs1_rdata_cur <= 32'd0;
                id_ex_rs2_rdata_cur <= 32'd0;
                id_ex_offset_cur <= 32'd0;
                id_ex_opcode_cur <= 7'd0;
                id_ex_func3_cur <= 3'd0;
                id_ex_func7_cur <= 7'd0;
                id_ex_lui_cur <= 1'b0;
                id_ex_pc_src_cur <= 1'b0;
                id_ex_alu_op_cur <= 3'd0;
                id_ex_mem_write_cur <= 1'b0;
                id_ex_mem_read_cur <= 1'b0;
                id_ex_mem_to_reg_cur <= 1'b0;
                id_ex_alu_src1_cur <= 1'b0;
                id_ex_alu_src2_cur <= 1'b0;
                id_ex_reg_write_cur <= 1'b0;
                id_ex_jump_cur <= 1'b0;
                id_ex_branch_cur <= 1'b0;
                id_ex_illegal_inst_cur <= 1'b0;
                id_ex_ebreak_cur <= 1'b0;
                id_ex_pred_taken_cur <= 1'b0;
                id_ex_pred_target_cur <= 32'd0;
            id_ex_pht_index_cur <= {PHT_INDEX_W{1'b0}};
                id_ex_ras_head_cur <= 3'd0;
                id_ex_ras_valid_cur <= 1'b0;
            end else begin
                if_id_valid_cur <= if_id_valid_next;
                if_id_pc_cur <= if_id_pc_next;
                if_id_pc_plus4_cur <= if_id_pc_plus4_next;
                if_id_inst_cur <= if_id_inst_next;
                if_id_pred_taken_cur <= if_id_pred_taken_next;
                if_id_pred_target_cur <= if_id_pred_target_next;
                if_id_pht_index_cur <= if_id_pht_index_next;
                // Snapshot the live RAS state at the same edge IF/ID latches.
                // This is the pre-push/pre-pop state for any RAS update that
                // fires on this same cycle (push/pop apply on the same edge).
                if_id_ras_head_cur <= ras_head_cur;
                if_id_ras_valid_cur <= ras_valid_cur;

                id_ex_valid_cur <= id_ex_valid_next;
                id_ex_pc_cur <= id_ex_pc_next;
                id_ex_pc_plus4_cur <= id_ex_pc_plus4_next;
                id_ex_inst_cur <= id_ex_inst_next;
                id_ex_rs1_raddr_cur <= id_ex_rs1_raddr_next;
                id_ex_rs2_raddr_cur <= id_ex_rs2_raddr_next;
                id_ex_rd_waddr_cur <= id_ex_rd_waddr_next;
                id_ex_rs1_rdata_cur <= id_ex_rs1_rdata_next;
                id_ex_rs2_rdata_cur <= id_ex_rs2_rdata_next;
                id_ex_offset_cur <= id_ex_offset_next;
                id_ex_opcode_cur <= id_ex_opcode_next;
                id_ex_func3_cur <= id_ex_func3_next;
                id_ex_func7_cur <= id_ex_func7_next;
                id_ex_lui_cur <= id_ex_lui_next;
                id_ex_pc_src_cur <= id_ex_pc_src_next;
                id_ex_alu_op_cur <= id_ex_alu_op_next;
                id_ex_mem_write_cur <= id_ex_mem_write_next;
                id_ex_mem_read_cur <= id_ex_mem_read_next;
                id_ex_mem_to_reg_cur <= id_ex_mem_to_reg_next;
                id_ex_alu_src1_cur <= id_ex_alu_src1_next;
                id_ex_alu_src2_cur <= id_ex_alu_src2_next;
                id_ex_reg_write_cur <= id_ex_reg_write_next;
                id_ex_jump_cur <= id_ex_jump_next;
                id_ex_branch_cur <= id_ex_branch_next;
                id_ex_illegal_inst_cur <= id_ex_illegal_inst_next;
                id_ex_ebreak_cur <= id_ex_ebreak_next;
                id_ex_pred_taken_cur <= id_ex_pred_taken_next;
                id_ex_pred_target_cur <= id_ex_pred_target_next;
                id_ex_pht_index_cur <= id_ex_pht_index_next;
                // Carry the IF/ID RAS snapshot one stage ahead.
                id_ex_ras_head_cur <= if_id_ras_head_cur;
                id_ex_ras_valid_cur <= if_id_ras_valid_cur;
            end

            if (mem_stage_stall_cur) begin
                ex_mem_dmem_req_sent_cur <= ex_mem_dmem_req_sent_cur | dmem_req_fire_cur;
            end else begin
                ex_mem_valid_cur <= ex_mem_valid_next;
                ex_mem_pc_cur <= ex_mem_pc_next;
                ex_mem_pc_plus4_cur <= ex_mem_pc_plus4_next;
                ex_mem_next_pc_cur <= ex_mem_next_pc_next;
                ex_mem_inst_cur <= ex_mem_inst_next;
                ex_mem_rs1_raddr_cur <= ex_mem_rs1_raddr_next;
                ex_mem_rs2_raddr_cur <= ex_mem_rs2_raddr_next;
                ex_mem_rd_waddr_cur <= ex_mem_rd_waddr_next;
                ex_mem_rs1_rdata_cur <= ex_mem_rs1_rdata_next;
                ex_mem_rs2_rdata_cur <= ex_mem_rs2_rdata_next;
                ex_mem_offset_cur <= ex_mem_offset_next;
                ex_mem_alu_result_cur <= ex_mem_alu_result_next;
                ex_mem_store_data_cur <= ex_mem_store_data_next;
                ex_mem_func3_cur <= ex_mem_func3_next;
                ex_mem_mem_write_cur <= ex_mem_mem_write_next;
                ex_mem_mem_read_cur <= ex_mem_mem_read_next;
                ex_mem_mem_to_reg_cur <= ex_mem_mem_to_reg_next;
                ex_mem_lui_cur <= ex_mem_lui_next;
                ex_mem_jump_cur <= ex_mem_jump_next;
                ex_mem_reg_write_cur <= ex_mem_reg_write_next;
                ex_mem_illegal_inst_cur <= ex_mem_illegal_inst_next;
                ex_mem_pc_misalign_trap_cur <= ex_mem_pc_misalign_trap_next;
                ex_mem_ebreak_cur <= ex_mem_ebreak_next;
                ex_mem_dmem_req_sent_cur <= 1'b0;
            end

            mem_wb_valid_cur <= mem_wb_valid_next;
            mem_wb_pc_cur <= mem_wb_pc_next;
            mem_wb_pc_plus4_cur <= mem_wb_pc_plus4_next;
            mem_wb_next_pc_cur <= mem_wb_next_pc_next;
            mem_wb_inst_cur <= mem_wb_inst_next;
            mem_wb_rs1_raddr_cur <= mem_wb_rs1_raddr_next;
            mem_wb_rs2_raddr_cur <= mem_wb_rs2_raddr_next;
            mem_wb_rd_waddr_cur <= mem_wb_rd_waddr_next;
            mem_wb_rs1_rdata_cur <= mem_wb_rs1_rdata_next;
            mem_wb_rs2_rdata_cur <= mem_wb_rs2_rdata_next;
            mem_wb_offset_cur <= mem_wb_offset_next;
            mem_wb_alu_result_cur <= mem_wb_alu_result_next;
            mem_wb_load_data_cur <= mem_wb_load_data_next;
            mem_wb_dmem_addr_cur <= mem_wb_dmem_addr_next;
            mem_wb_dmem_ren_cur <= mem_wb_dmem_ren_next;
            mem_wb_dmem_wen_cur <= mem_wb_dmem_wen_next;
            mem_wb_dmem_mask_cur <= mem_wb_dmem_mask_next;
            mem_wb_dmem_wdata_cur <= mem_wb_dmem_wdata_next;
            mem_wb_dmem_rdata_cur <= mem_wb_dmem_rdata_next;
            mem_wb_mem_to_reg_cur <= mem_wb_mem_to_reg_next;
            mem_wb_lui_cur <= mem_wb_lui_next;
            mem_wb_jump_cur <= mem_wb_jump_next;
            mem_wb_reg_write_cur <= mem_wb_reg_write_next;
            mem_wb_illegal_inst_cur <= mem_wb_illegal_inst_next;
            mem_wb_pc_misalign_trap_cur <= mem_wb_pc_misalign_trap_next;
            mem_wb_misalign_trap_cur <= mem_wb_misalign_trap_next;
            mem_wb_ebreak_cur <= mem_wb_ebreak_next;
        end
    end

endmodule

`default_nettype wire
