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
    // Branch predictor: 2-bit saturating PHT (64 entries, PC[7:2] indexed)
    // + BTB (64 entries, PC[7:2] indexed)
    // -------------------------------------------------------------------------
    localparam BP_ENTRIES  = 64;
    localparam BP_IDX_W    = 6;   // log2(BP_ENTRIES)
    // PHT states: 00=SNT, 01=WNT, 10=WT, 11=ST
    localparam PHT_SNT = 2'b00;
    localparam PHT_WNT = 2'b01;
    localparam PHT_WT  = 2'b10;
    localparam PHT_ST  = 2'b11;

    reg [1:0]  pht       [BP_ENTRIES - 1:0];
    reg [31:0] btb       [BP_ENTRIES - 1:0];
    reg        btb_valid [BP_ENTRIES - 1:0];

    // Carry prediction metadata through pipeline for misprediction detection
    reg         id_ex_bp_predicted_cur;   // was branch predicted taken in IF?
    reg  [31:0] id_ex_bp_predicted_pc_cur;// predicted target we fetched from

    // -------------------------------------------------------------------------
    // Global state
    // -------------------------------------------------------------------------
    reg [31:0] pc_cur;
    reg        halted_cur;
    reg        imem_pending_cur;
    reg        imem_pending_kill_cur;
    reg [31:0] imem_pending_pc_cur;
    wire [31:0] imem_cache_mem_addr_cur;
    wire        imem_cache_mem_ren_cur;
    wire        imem_cache_mem_wen_cur;
    wire [31:0] imem_cache_mem_wdata_cur;
    wire        imem_cache_busy_cur;
    wire [31:0] imem_cache_rdata_cur;
    // Next-line prefetch: request the cache line after the current PC's line.
    wire [31:0] imem_pf_addr_cur;
    wire        imem_pf_req_cur;
    wire [31:0] dmem_cache_mem_addr_cur;
    wire        dmem_cache_mem_ren_cur;
    wire        dmem_cache_mem_wen_cur;
    wire [31:0] dmem_cache_mem_wdata_cur;
    wire        dmem_cache_busy_cur;
    wire [31:0] dmem_cache_rdata_cur;

    // -------------------------------------------------------------------------
    // IF stage + IF/ID register
    // -------------------------------------------------------------------------
    wire [31:0] if_pc_cur;
    wire [31:0] if_pc_plus4_cur;
    wire [31:0] if_inst_cur;
    wire [31:0] pc_next;

    reg         if_id_valid_cur;
    reg  [31:0] if_id_pc_cur;
    reg  [31:0] if_id_pc_plus4_cur;
    reg  [31:0] if_id_inst_cur;

    wire        if_id_valid_next;
    wire [31:0] if_id_pc_next;
    wire [31:0] if_id_pc_plus4_next;
    wire [31:0] if_id_inst_next;

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
    wire        ex_pc_misalign_trap_cur;
    wire        ex_redirect_cur;
    wire [31:0] ex_next_pc_cur;
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

    // IF-stage prediction wires
    wire [BP_IDX_W - 1:0] if_bp_idx     = pc_cur[BP_IDX_W + 1:2];
    wire                  if_bp_predict  = btb_valid[if_bp_idx] & pht[if_bp_idx][1];
    wire [31:0]           if_bp_target   = btb[if_bp_idx];

    // EX-stage update wires (branch resolved)
    wire [BP_IDX_W - 1:0] ex_bp_idx     = id_ex_pc_cur[BP_IDX_W + 1:2];
    wire                  ex_bp_was_branch = id_ex_valid_cur & ~mem_stage_stall_cur & id_ex_branch_cur;
    wire                  ex_bp_was_jump   = id_ex_valid_cur & ~mem_stage_stall_cur & id_ex_jump_cur;
    wire                  ex_bp_was_ctrl   = ex_bp_was_branch | ex_bp_was_jump;
    wire                  ex_bp_taken      = ex_branch_taken_cur | ex_jump_taken_cur;

    wire        id_ex_bp_predicted_next     = if_bp_predict & id_branch_cur;
    wire [31:0] id_ex_bp_predicted_pc_next  = if_bp_target;

    wire        ex_bp_mismatch =
        ex_bp_was_ctrl & (
            (ex_bp_taken & (~id_ex_bp_predicted_cur |
                            (id_ex_bp_predicted_pc_cur != ex_control_target_cur))) |
            (~ex_bp_taken & id_ex_bp_predicted_cur)
        );

    wire        ex_redirect_suppress = ex_bp_taken & id_ex_bp_predicted_cur &
                                       (id_ex_bp_predicted_pc_cur == ex_control_target_cur);

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

    // -------------------------------------------------------------------------
    // Caches
    // -------------------------------------------------------------------------
    cache u_icache (
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
        .o_res_rdata(imem_cache_rdata_cur),
        .i_pf_addr  (imem_pf_addr_cur),
        .i_pf_req   (imem_pf_req_cur)
    );

    cache u_dcache (
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
        .o_res_rdata(dmem_cache_rdata_cur),
        .i_pf_addr  (32'd0),
        .i_pf_req   (1'b0)
    );

    // -------------------------------------------------------------------------
    // IF stage
    // -------------------------------------------------------------------------
    assign if_pc_cur       = pc_cur;
    assign if_pc_plus4_cur = pc_cur + 32'd4;
    assign if_inst_cur     = imem_cache_rdata_cur;
    // With branch predictor: if prediction says taken, jump to BTB target next cycle.
    assign pc_next         = ex_redirect_cur      ? ex_control_target_cur :
                             if_bp_predict         ? if_bp_target          :
                                                     if_pc_plus4_cur;

    assign if_id_consumed_cur         = if_id_valid_cur & ~hazard_stall_cur & ~mem_stage_stall_cur & ~ex_redirect_cur;
    assign if_id_buffer_available_cur = ~if_id_valid_cur | if_id_consumed_cur;
    assign imem_req_fire_cur          = ~halted_cur & ~imem_pending_cur & if_id_buffer_available_cur & ~ex_redirect_cur;
    // When BP predicts taken, the pending fetch PC is the predicted target not pc_cur+4
    assign imem_req_addr_cur          = imem_pending_cur ? imem_pending_pc_cur : if_pc_cur;
    assign imem_resp_fire_cur         = imem_pending_cur & ~imem_cache_busy_cur;
    assign imem_resp_accept_cur       = (imem_req_fire_cur & ~imem_cache_busy_cur) |
                                        (imem_resp_fire_cur & ~imem_pending_kill_cur & ~ex_redirect_cur);
    assign imem_resp_pc_cur           = imem_pending_cur ? imem_pending_pc_cur : if_pc_cur;

    // Next-line prefetch: once the IF stage issues a request for a line,
    // speculatively request the next cache line (PC aligned to next 16B boundary).
    assign imem_pf_addr_cur = {if_pc_cur[31:4] + 28'b1, 4'b0};
    assign imem_pf_req_cur  = imem_req_fire_cur;

    assign o_imem_raddr = imem_cache_mem_addr_cur;
    assign o_imem_ren   = imem_cache_mem_ren_cur;

    assign if_id_valid_next    = imem_resp_accept_cur;
    assign if_id_pc_next       = imem_resp_pc_cur;
    assign if_id_pc_plus4_next = imem_resp_pc_cur + 32'd4;
    assign if_id_inst_next     = if_inst_cur;

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

    assign hazard_ex_cur = if_id_valid_cur &
                           id_ex_valid_cur &
                           id_ex_mem_read_cur &
                           (id_ex_rd_waddr_cur != 5'd0) &
                           ((id_rs1_used_cur & (id_rs1_raddr_cur == id_ex_rd_waddr_cur)) |
                            (id_rs2_ex_used_cur & (id_rs2_raddr_cur == id_ex_rd_waddr_cur)));

    assign hazard_mem_cur = 1'b0;

    assign hazard_wb_cur = 1'b0;

    assign hazard_stall_cur = hazard_ex_cur | hazard_mem_cur | hazard_wb_cur;

    // Carry BP prediction: prediction was made when IF stage had if_id_pc_cur in flight.
    // We latch from the IF/ID pipeline register's associated prediction (stored in id_ex_bp regs).
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

    // -------------------------------------------------------------------------
    // EX stage
    // -------------------------------------------------------------------------
    assign ex_mem_forward_data_cur = ex_mem_jump_cur ? ex_mem_pc_plus4_cur :
                                     ex_mem_lui_cur  ? ex_mem_offset_cur :
                                                       ex_mem_alu_result_cur;
    assign mem_wb_forward_data_cur = wb_write_data_cur;

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

    assign mem_ex_match_rs1_cur = id_ex_valid_cur &
                                  mem_wb_valid_cur &
                                  mem_wb_reg_write_cur &
                                  (mem_wb_rd_waddr_cur != 5'd0) &
                                  ~ex_ex_match_rs1_cur &
                                  (mem_wb_rd_waddr_cur == id_ex_rs1_raddr_cur);
    assign mem_ex_match_rs2_cur = id_ex_valid_cur &
                                  mem_wb_valid_cur &
                                  mem_wb_reg_write_cur &
                                  (mem_wb_rd_waddr_cur != 5'd0) &
                                  ~ex_ex_match_rs2_cur &
                                  (mem_wb_rd_waddr_cur == id_ex_rs2_raddr_cur);

    assign ex_forward_a_sel_cur = ex_ex_match_rs1_cur ? 2'b10 :
                                  mem_ex_match_rs1_cur ? 2'b01 :
                                                         2'b00;
    assign ex_forward_b_sel_cur = ex_ex_match_rs2_cur ? 2'b10 :
                                  mem_ex_match_rs2_cur ? 2'b01 :
                                                         2'b00;

    assign ex_operand1_sel_cur = id_ex_alu_src1_cur ? 2'b11 : ex_forward_a_sel_cur;
    assign ex_operand2_sel_cur = id_ex_alu_src2_cur ? 2'b11 : ex_forward_b_sel_cur;

    assign ex_rs1_value_cur = (ex_forward_a_sel_cur == 2'b10) ? ex_mem_forward_data_cur :
                              (ex_forward_a_sel_cur == 2'b01) ? mem_wb_forward_data_cur :
                                                                id_ex_rs1_rdata_cur;
    assign ex_rs2_value_cur = (ex_forward_b_sel_cur == 2'b10) ? ex_mem_forward_data_cur :
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
    // ex_redirect_cur fires when we need to change fetch direction:
    //  - mispredicted control flow (wrong target or predicted not-taken but taken)
    //  - predicted-not-taken but branch IS taken (covers non-BTB-hit jumps too)
    //  - do NOT redirect on correctly-predicted taken (we already went there)
    assign ex_redirect_cur        = ex_control_taken_cur &
                                    ~ex_pc_misalign_trap_cur &
                                    ~ex_redirect_suppress;
    assign ex_next_pc_cur         = ex_redirect_cur ? ex_control_target_cur :
                                    (ex_control_taken_cur & ~ex_pc_misalign_trap_cur) ?
                                        ex_control_target_cur : id_ex_pc_plus4_cur;

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
    // Branch predictor sequential update
    // -------------------------------------------------------------------------
    always @(posedge i_clk) begin
        if (i_rst) begin
            pht[0]<=PHT_WNT; pht[1]<=PHT_WNT; pht[2]<=PHT_WNT; pht[3]<=PHT_WNT;
            pht[4]<=PHT_WNT; pht[5]<=PHT_WNT; pht[6]<=PHT_WNT; pht[7]<=PHT_WNT;
            pht[8]<=PHT_WNT; pht[9]<=PHT_WNT; pht[10]<=PHT_WNT; pht[11]<=PHT_WNT;
            pht[12]<=PHT_WNT; pht[13]<=PHT_WNT; pht[14]<=PHT_WNT; pht[15]<=PHT_WNT;
            pht[16]<=PHT_WNT; pht[17]<=PHT_WNT; pht[18]<=PHT_WNT; pht[19]<=PHT_WNT;
            pht[20]<=PHT_WNT; pht[21]<=PHT_WNT; pht[22]<=PHT_WNT; pht[23]<=PHT_WNT;
            pht[24]<=PHT_WNT; pht[25]<=PHT_WNT; pht[26]<=PHT_WNT; pht[27]<=PHT_WNT;
            pht[28]<=PHT_WNT; pht[29]<=PHT_WNT; pht[30]<=PHT_WNT; pht[31]<=PHT_WNT;
            pht[32]<=PHT_WNT; pht[33]<=PHT_WNT; pht[34]<=PHT_WNT; pht[35]<=PHT_WNT;
            pht[36]<=PHT_WNT; pht[37]<=PHT_WNT; pht[38]<=PHT_WNT; pht[39]<=PHT_WNT;
            pht[40]<=PHT_WNT; pht[41]<=PHT_WNT; pht[42]<=PHT_WNT; pht[43]<=PHT_WNT;
            pht[44]<=PHT_WNT; pht[45]<=PHT_WNT; pht[46]<=PHT_WNT; pht[47]<=PHT_WNT;
            pht[48]<=PHT_WNT; pht[49]<=PHT_WNT; pht[50]<=PHT_WNT; pht[51]<=PHT_WNT;
            pht[52]<=PHT_WNT; pht[53]<=PHT_WNT; pht[54]<=PHT_WNT; pht[55]<=PHT_WNT;
            pht[56]<=PHT_WNT; pht[57]<=PHT_WNT; pht[58]<=PHT_WNT; pht[59]<=PHT_WNT;
            pht[60]<=PHT_WNT; pht[61]<=PHT_WNT; pht[62]<=PHT_WNT; pht[63]<=PHT_WNT;
            btb[0]<=32'd0; btb[1]<=32'd0; btb[2]<=32'd0; btb[3]<=32'd0;
            btb[4]<=32'd0; btb[5]<=32'd0; btb[6]<=32'd0; btb[7]<=32'd0;
            btb[8]<=32'd0; btb[9]<=32'd0; btb[10]<=32'd0; btb[11]<=32'd0;
            btb[12]<=32'd0; btb[13]<=32'd0; btb[14]<=32'd0; btb[15]<=32'd0;
            btb[16]<=32'd0; btb[17]<=32'd0; btb[18]<=32'd0; btb[19]<=32'd0;
            btb[20]<=32'd0; btb[21]<=32'd0; btb[22]<=32'd0; btb[23]<=32'd0;
            btb[24]<=32'd0; btb[25]<=32'd0; btb[26]<=32'd0; btb[27]<=32'd0;
            btb[28]<=32'd0; btb[29]<=32'd0; btb[30]<=32'd0; btb[31]<=32'd0;
            btb[32]<=32'd0; btb[33]<=32'd0; btb[34]<=32'd0; btb[35]<=32'd0;
            btb[36]<=32'd0; btb[37]<=32'd0; btb[38]<=32'd0; btb[39]<=32'd0;
            btb[40]<=32'd0; btb[41]<=32'd0; btb[42]<=32'd0; btb[43]<=32'd0;
            btb[44]<=32'd0; btb[45]<=32'd0; btb[46]<=32'd0; btb[47]<=32'd0;
            btb[48]<=32'd0; btb[49]<=32'd0; btb[50]<=32'd0; btb[51]<=32'd0;
            btb[52]<=32'd0; btb[53]<=32'd0; btb[54]<=32'd0; btb[55]<=32'd0;
            btb[56]<=32'd0; btb[57]<=32'd0; btb[58]<=32'd0; btb[59]<=32'd0;
            btb[60]<=32'd0; btb[61]<=32'd0; btb[62]<=32'd0; btb[63]<=32'd0;
            btb_valid[0]<=1'b0; btb_valid[1]<=1'b0; btb_valid[2]<=1'b0; btb_valid[3]<=1'b0;
            btb_valid[4]<=1'b0; btb_valid[5]<=1'b0; btb_valid[6]<=1'b0; btb_valid[7]<=1'b0;
            btb_valid[8]<=1'b0; btb_valid[9]<=1'b0; btb_valid[10]<=1'b0; btb_valid[11]<=1'b0;
            btb_valid[12]<=1'b0; btb_valid[13]<=1'b0; btb_valid[14]<=1'b0; btb_valid[15]<=1'b0;
            btb_valid[16]<=1'b0; btb_valid[17]<=1'b0; btb_valid[18]<=1'b0; btb_valid[19]<=1'b0;
            btb_valid[20]<=1'b0; btb_valid[21]<=1'b0; btb_valid[22]<=1'b0; btb_valid[23]<=1'b0;
            btb_valid[24]<=1'b0; btb_valid[25]<=1'b0; btb_valid[26]<=1'b0; btb_valid[27]<=1'b0;
            btb_valid[28]<=1'b0; btb_valid[29]<=1'b0; btb_valid[30]<=1'b0; btb_valid[31]<=1'b0;
            btb_valid[32]<=1'b0; btb_valid[33]<=1'b0; btb_valid[34]<=1'b0; btb_valid[35]<=1'b0;
            btb_valid[36]<=1'b0; btb_valid[37]<=1'b0; btb_valid[38]<=1'b0; btb_valid[39]<=1'b0;
            btb_valid[40]<=1'b0; btb_valid[41]<=1'b0; btb_valid[42]<=1'b0; btb_valid[43]<=1'b0;
            btb_valid[44]<=1'b0; btb_valid[45]<=1'b0; btb_valid[46]<=1'b0; btb_valid[47]<=1'b0;
            btb_valid[48]<=1'b0; btb_valid[49]<=1'b0; btb_valid[50]<=1'b0; btb_valid[51]<=1'b0;
            btb_valid[52]<=1'b0; btb_valid[53]<=1'b0; btb_valid[54]<=1'b0; btb_valid[55]<=1'b0;
            btb_valid[56]<=1'b0; btb_valid[57]<=1'b0; btb_valid[58]<=1'b0; btb_valid[59]<=1'b0;
            btb_valid[60]<=1'b0; btb_valid[61]<=1'b0; btb_valid[62]<=1'b0; btb_valid[63]<=1'b0;
            id_ex_bp_predicted_cur    <= 1'b0;
            id_ex_bp_predicted_pc_cur <= 32'd0;
        end else begin
            // Update PHT and BTB when a branch/jump resolves in EX
            if (ex_bp_was_ctrl) begin
                // Update PHT (2-bit saturating counter)
                if (ex_bp_taken) begin
                    pht[ex_bp_idx] <= (pht[ex_bp_idx] == PHT_ST) ? PHT_ST : pht[ex_bp_idx] + 2'b01;
                end else begin
                    pht[ex_bp_idx] <= (pht[ex_bp_idx] == PHT_SNT) ? PHT_SNT : pht[ex_bp_idx] - 2'b01;
                end
                // Update BTB with actual target when taken
                if (ex_bp_taken) begin
                    btb[ex_bp_idx]       <= ex_control_target_cur;
                    btb_valid[ex_bp_idx] <= 1'b1;
                end
            end

            // Carry prediction through ID/EX register
            if (ex_redirect_cur) begin
                id_ex_bp_predicted_cur    <= 1'b0;
                id_ex_bp_predicted_pc_cur <= 32'd0;
            end else if (mem_stage_stall_cur) begin
                // hold
            end else if (hazard_stall_cur) begin
                id_ex_bp_predicted_cur    <= 1'b0;
                id_ex_bp_predicted_pc_cur <= 32'd0;
            end else begin
                id_ex_bp_predicted_cur    <= id_ex_bp_predicted_next;
                id_ex_bp_predicted_pc_cur <= id_ex_bp_predicted_pc_next;
            end
        end
    end

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

            if_id_valid_cur <= 1'b0;
            if_id_pc_cur <= 32'd0;
            if_id_pc_plus4_cur <= 32'd0;
            if_id_inst_cur <= 32'd0;

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

            if_id_valid_cur <= 1'b0;
            if_id_pc_cur <= 32'd0;
            if_id_pc_plus4_cur <= 32'd0;
            if_id_inst_cur <= 32'd0;

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
            if (ex_redirect_cur)
                pc_cur <= pc_next;
            else if (imem_req_fire_cur)
                pc_cur <= pc_next;

            if (imem_resp_fire_cur) begin
                imem_pending_cur <= 1'b0;
                imem_pending_kill_cur <= 1'b0;
                imem_pending_pc_cur <= 32'd0;
            end else if (imem_req_fire_cur & imem_cache_busy_cur) begin
                imem_pending_cur <= 1'b1;
                imem_pending_kill_cur <= 1'b0;
                imem_pending_pc_cur <= if_pc_cur;
            end else if (ex_redirect_cur && imem_pending_cur) begin
                imem_pending_kill_cur <= 1'b1;
            end

            if (ex_redirect_cur) begin
                // Taken branch/jump redirects fetch and squashes younger instructions.
                if_id_valid_cur <= 1'b0;
                if_id_pc_cur <= 32'd0;
                if_id_pc_plus4_cur <= 32'd0;
                if_id_inst_cur <= 32'd0;

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
            end else if (mem_stage_stall_cur) begin
                if (imem_resp_accept_cur) begin
                    if_id_valid_cur <= if_id_valid_next;
                    if_id_pc_cur <= if_id_pc_next;
                    if_id_pc_plus4_cur <= if_id_pc_plus4_next;
                    if_id_inst_cur <= if_id_inst_next;
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
            end else begin
                if_id_valid_cur <= if_id_valid_next;
                if_id_pc_cur <= if_id_pc_next;
                if_id_pc_plus4_cur <= if_id_pc_plus4_next;
                if_id_inst_cur <= if_id_inst_next;

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
