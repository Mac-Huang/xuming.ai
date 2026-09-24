`default_nettype none

module cache #(
    parameter PREFETCH_EN = 0,
    // LINE_WIDE selects line size and set count while keeping total cache
    // at 4 KB: 0 = 16B lines / 64 sets (scatter-friendly D-cache default);
    // 1 = 32B lines / 32 sets; 2 = 64B lines / 16 sets (sequential-fetch
    // friendly, best for the I-cache).
    parameter LINE_WIDE = 0,
    // EARLY_RESTART_EN enables critical-word-first early-restart bypass: on
    // the cycle the critical word arrives from memory during a demand-read
    // refill, the cache drops o_busy and forwards i_mem_rdata directly to
    // o_res_rdata. Default 0 preserves the standalone cache_tb contract,
    // which issues a same-address request the cycle after busy drops and
    // expects a tag hit (only possible when the full line has been
    // committed). The hart enables this on the I-cache only.
    parameter EARLY_RESTART_EN = 0
) (
    input  wire        i_clk,
    input  wire        i_rst,
    input  wire        i_mem_ready,
    output wire [31:0] o_mem_addr,
    output wire        o_mem_ren,
    output wire        o_mem_wen,
    output wire [31:0] o_mem_wdata,
    input  wire [31:0] i_mem_rdata,
    input  wire        i_mem_valid,
    output wire        o_busy,
    input  wire [31:0] i_req_addr,
    input  wire        i_req_ren,
    input  wire        i_req_wen,
    input  wire [ 3:0] i_req_mask,
    input  wire [31:0] i_req_wdata,
    output wire [31:0] o_res_rdata
);
    // Line-size and set-count selection.
    //   LINE_WIDE=0: 16B lines, 64 sets (default, for D-cache scatter).
    //   LINE_WIDE=1: 32B lines, 32 sets.
    //   LINE_WIDE=2: 64B lines, 16 sets (best for sequential I-cache fetch).
    // All store 4 KB.
    localparam O     = (LINE_WIDE == 2) ? 6 : (LINE_WIDE == 1) ? 5 : 4;
    localparam S     = (LINE_WIDE == 2) ? 4 : (LINE_WIDE == 1) ? 5 : 6;
    localparam DEPTH = (LINE_WIDE == 2) ? 16 : (LINE_WIDE == 1) ? 32 : 64;
    localparam T     = 32 - O - S;
    localparam D     = (LINE_WIDE == 2) ? 16 : (LINE_WIDE == 1) ? 8 : 4;

    localparam STATE_IDLE       = 2'd0;
    localparam STATE_REFILL_REQ = 2'd1;
    localparam STATE_WRITE_REQ  = 2'd2;

    localparam WB_DEPTH   = 32;
    localparam WB_PTR_W   = 5;
    localparam WB_COUNT_W = 6;
    localparam [WB_COUNT_W - 1:0] WB_COUNT_ZERO = 6'd0;
    localparam [WB_COUNT_W - 1:0] WB_COUNT_FULL = 6'd32;
    localparam [3:0] REFILL_LAST_WORD = (LINE_WIDE == 2) ? 4'd15 :
                                         (LINE_WIDE == 1) ? 4'd7  : 4'd3;

    reg [31:0] datas0 [DEPTH - 1:0][D - 1:0];
    reg [31:0] datas1 [DEPTH - 1:0][D - 1:0];
    reg [31:0] datas2 [DEPTH - 1:0][D - 1:0];
    reg [31:0] datas3 [DEPTH - 1:0][D - 1:0];
    reg [T - 1:0] tags0 [DEPTH - 1:0];
    reg [T - 1:0] tags1 [DEPTH - 1:0];
    reg [T - 1:0] tags2 [DEPTH - 1:0];
    reg [T - 1:0] tags3 [DEPTH - 1:0];
    reg [DEPTH - 1:0] valid0;
    reg [DEPTH - 1:0] valid1;
    reg [DEPTH - 1:0] valid2;
    reg [DEPTH - 1:0] valid3;
    reg [1:0] repl_way [DEPTH - 1:0];

    reg [31:0] wb_addrs [WB_DEPTH - 1:0];
    reg [31:0] wb_datas [WB_DEPTH - 1:0];
    reg [WB_PTR_W - 1:0] wb_head_cur;
    reg [WB_PTR_W - 1:0] wb_tail_cur;
    reg [WB_COUNT_W - 1:0] wb_count_cur;

    reg [1:0] state_cur;
    // Current request-side line context (what we're issuing mem requests for).
    reg [T - 1:0] miss_tag_cur;
    reg [S - 1:0] miss_set_cur;
    reg [3:0]     miss_word_cur;
    reg [1:0]     miss_way_cur;
    reg           miss_is_write_cur;
    reg           miss_is_prefetch_cur;
    reg [3:0]     miss_mask_cur;
    reg [31:0]    miss_wdata_cur;
    reg [3:0]     refill_req_word_cur;
    reg           refill_req_done_cur;
    // Response-side line context (what in-flight responses belong to).
    // Usually mirrors miss_*, but when a chained prefetch swaps the
    // request-side to a new line while the old line's responses are still
    // arriving, the response-side keeps the old line until the last
    // response lands, then is promoted to match the new request line.
    reg [T - 1:0] rsp_tag_cur;
    reg [S - 1:0] rsp_set_cur;
    reg [3:0]     rsp_word_cur;       // critical-word index for the in-flight line
    reg [1:0]     rsp_way_cur;
    reg           rsp_is_prefetch_cur;
    reg           rsp_is_write_cur;
    reg [3:0]     rsp_mask_cur;
    reg [31:0]    rsp_wdata_cur;
    reg [3:0]     refill_rsp_word_cur;  // progress within the in-flight line
    reg           early_restart_valid_cur;
    reg [31:0]    early_restart_data_cur;
    // Chained pipelined prefetch tracker: set when we begin issuing next
    // line's requests while current line's responses are still arriving.
    reg           chained_pending_cur;

    reg           pending_req_cur;
    reg [T - 1:0] pending_tag_cur;
    reg [S - 1:0] pending_set_cur;
    reg [3:0]     pending_word_cur;
    reg           pending_is_write_cur;
    reg [3:0]     pending_mask_cur;
    reg [31:0]    pending_wdata_cur;

    wire [T - 1:0] req_tag  = i_req_addr[31:O + S];
    wire [S - 1:0] req_set  = i_req_addr[O + S - 1:O];
    // Extract word index (low bits minus the byte offset). Zero-pad for
    // narrower-line configurations so the 4-bit word counter is always
    // well-defined.
    wire [3:0]     req_word = (LINE_WIDE == 2) ? i_req_addr[5:2] :
                              (LINE_WIDE == 1) ? {1'b0, i_req_addr[4:2]} :
                                                  {2'b0, i_req_addr[3:2]};

    wire        way0_valid = valid0[req_set];
    wire        way1_valid = valid1[req_set];
    wire        way2_valid = valid2[req_set];
    wire        way3_valid = valid3[req_set];
    wire        way0_hit   = way0_valid & (tags0[req_set] == req_tag);
    wire        way1_hit   = way1_valid & (tags1[req_set] == req_tag);
    wire        way2_hit   = way2_valid & (tags2[req_set] == req_tag);
    wire        way3_hit   = way3_valid & (tags3[req_set] == req_tag);
    wire        hit        = way0_hit | way1_hit | way2_hit | way3_hit;
    wire [1:0]  hit_way    = way3_hit ? 2'd3 :
                              (way2_hit ? 2'd2 :
                              (way1_hit ? 2'd1 : 2'd0));

    wire [31:0] way0_rword = datas0[req_set][req_word];
    wire [31:0] way1_rword = datas1[req_set][req_word];
    wire [31:0] way2_rword = datas2[req_set][req_word];
    wire [31:0] way3_rword = datas3[req_set][req_word];
    wire [31:0] hit_rword  = way0_hit ? way0_rword :
                              (way1_hit ? way1_rword :
                              (way2_hit ? way2_rword :
                              (way3_hit ? way3_rword : 32'b0)));

    wire [1:0] victim_way = ~way0_valid ? 2'd0 :
                            (~way1_valid ? 2'd1 :
                            (~way2_valid ? 2'd2 :
                            (~way3_valid ? 2'd3 : repl_way[req_set])));

    wire        pending_way0_hit = pending_req_cur & valid0[pending_set_cur] &
                                   (tags0[pending_set_cur] == pending_tag_cur);
    wire        pending_way1_hit = pending_req_cur & valid1[pending_set_cur] &
                                   (tags1[pending_set_cur] == pending_tag_cur);
    wire        pending_way2_hit = pending_req_cur & valid2[pending_set_cur] &
                                   (tags2[pending_set_cur] == pending_tag_cur);
    wire        pending_way3_hit = pending_req_cur & valid3[pending_set_cur] &
                                   (tags3[pending_set_cur] == pending_tag_cur);
    wire        pending_hit      = pending_way0_hit | pending_way1_hit |
                                   pending_way2_hit | pending_way3_hit;
    wire [1:0]  pending_hit_way  = pending_way3_hit ? 2'd3 :
                                   (pending_way2_hit ? 2'd2 :
                                   (pending_way1_hit ? 2'd1 : 2'd0));
    wire [1:0] pending_victim_way = ~valid0[pending_set_cur] ? 2'd0 :
                                    (~valid1[pending_set_cur] ? 2'd1 :
                                    (~valid2[pending_set_cur] ? 2'd2 :
                                    (~valid3[pending_set_cur] ? 2'd3 :
                                     repl_way[pending_set_cur])));

    wire [31:0] req_byte_mask = {{8{i_req_mask[3]}}, {8{i_req_mask[2]}},
                                 {8{i_req_mask[1]}}, {8{i_req_mask[0]}}};
    wire [31:0] merged_write_word = (hit_rword & ~req_byte_mask) |
                                    (i_req_wdata & req_byte_mask);

    wire [31:0] miss_line_addr    = {miss_tag_cur, miss_set_cur, {O{1'b0}}};
    // Wrapping word counter (CWF). For each line-size configuration only the
    // low log2(D) bits matter; the higher bits are zero-padded so the 4-bit
    // storage is uniform.
    wire [3:0]  refill_req_word_abs =
        (LINE_WIDE == 2) ? (miss_word_cur + refill_req_word_cur) :
        (LINE_WIDE == 1) ? {1'b0, (miss_word_cur[2:0] + refill_req_word_cur[2:0])} :
                           {2'b0, (miss_word_cur[1:0] + refill_req_word_cur[1:0])};
    wire [3:0]  refill_rsp_word_abs =
        (LINE_WIDE == 2) ? (rsp_word_cur + refill_rsp_word_cur) :
        (LINE_WIDE == 1) ? {1'b0, (rsp_word_cur[2:0] + refill_rsp_word_cur[2:0])} :
                           {2'b0, (rsp_word_cur[1:0] + refill_rsp_word_cur[1:0])};
    wire [31:0] refill_word_addr  = miss_line_addr | {26'b0, refill_req_word_abs, 2'b00};
    wire [31:0] miss_word_addr    = miss_line_addr |
                                    {26'b0, miss_word_cur, 2'b00};
    wire [31:0] next_line_addr    =
        miss_line_addr + ((LINE_WIDE == 2) ? 32'd64 :
                          (LINE_WIDE == 1) ? 32'd32 : 32'd16);
    wire [T - 1:0] next_line_tag  = next_line_addr[31:O + S];
    wire [S - 1:0] next_line_set  = next_line_addr[O + S - 1:O];

    wire next_way0_valid = valid0[next_line_set];
    wire next_way1_valid = valid1[next_line_set];
    wire next_way2_valid = valid2[next_line_set];
    wire next_way3_valid = valid3[next_line_set];
    wire next_line_hit   = (next_way0_valid & (tags0[next_line_set] == next_line_tag)) |
                           (next_way1_valid & (tags1[next_line_set] == next_line_tag)) |
                           (next_way2_valid & (tags2[next_line_set] == next_line_tag)) |
                           (next_way3_valid & (tags3[next_line_set] == next_line_tag));
    wire [1:0] next_victim_way = ~next_way0_valid ? 2'd0 :
                                 (~next_way1_valid ? 2'd1 :
                                 (~next_way2_valid ? 2'd2 :
                                 (~next_way3_valid ? 2'd3 :
                                  repl_way[next_line_set])));


    wire [31:0] miss_way_rword = (miss_way_cur == 2'd0) ? datas0[miss_set_cur][miss_word_cur] :
                                 ((miss_way_cur == 2'd1) ? datas1[miss_set_cur][miss_word_cur] :
                                 ((miss_way_cur == 2'd2) ? datas2[miss_set_cur][miss_word_cur] :
                                                           datas3[miss_set_cur][miss_word_cur]));
    wire [31:0] miss_byte_mask = {{8{miss_mask_cur[3]}}, {8{miss_mask_cur[2]}},
                                  {8{miss_mask_cur[1]}}, {8{miss_mask_cur[0]}}};
    wire [31:0] miss_merged_write_word = (miss_way_rword & ~miss_byte_mask) |
                                         (miss_wdata_cur & miss_byte_mask);
    wire        refill_req_matches_rsp_cur = (req_tag == rsp_tag_cur) &
                                             (req_set == rsp_set_cur);

    // Critical-word-first early-restart bypass. When EARLY_RESTART_EN is set
    // and the response-side word currently landing (i_mem_valid asserted
    // during a refill) is the critical (first requested) word of a demand
    // read miss, drop o_busy for this cycle and forward i_mem_rdata directly
    // as o_res_rdata. The array write still commits on the next clock, and
    // tag/valid are not exposed until the last word lands, so subsequent
    // tag-hit lookups stay correct. The hart's IF pipeline stops asserting
    // i_req_ren during a pending miss (it watches ~o_busy instead), so the
    // match is based on the miss state that was latched when the refill
    // started, not on a live i_req_ren.
    //
    // Default EARLY_RESTART_EN=0 preserves the standalone cache_tb contract
    // which issues a same-address request the cycle AFTER busy drops and
    // expects a clean tag hit (only valid when the full line has been
    // committed).
    wire early_restart_match_cur = EARLY_RESTART_EN &
                                   (state_cur == STATE_REFILL_REQ) &
                                   i_mem_valid &
                                   ~rsp_is_prefetch_cur &
                                   ~rsp_is_write_cur &
                                   (refill_rsp_word_cur == 4'd0);

    // Partial-hit plumbing is kept here so read_miss can reference it before
    // the final o_busy/o_res_rdata mux. It is disabled for now.
    wire [3:0]  req_word_pos_cur =
        (LINE_WIDE == 2) ? (req_word - rsp_word_cur) :
        (LINE_WIDE == 1) ? {1'b0, (req_word[2:0] - rsp_word_cur[2:0])} :
                           {2'b0, (req_word[1:0] - rsp_word_cur[1:0])};
    wire refill_partial_hit_cur = (state_cur == STATE_REFILL_REQ) &
                                  refill_req_matches_rsp_cur &
                                  i_req_ren &
                                  ~rsp_is_write_cur &
                                  (req_word_pos_cur < refill_rsp_word_cur);
    wire [31:0] refill_partial_data_cur =
        (rsp_way_cur == 2'd0) ? datas0[rsp_set_cur][req_word] :
        (rsp_way_cur == 2'd1) ? datas1[rsp_set_cur][req_word] :
        (rsp_way_cur == 2'd2) ? datas2[rsp_set_cur][req_word] :
                                datas3[rsp_set_cur][req_word];

    // read_miss / write_miss are the "needs fill" signals. A CPU request
    // that can be served by an in-progress refill (partial-hit or
    // early-restart) is not a fresh miss.
    wire        read_miss  = i_req_ren & ~hit & ~early_restart_match_cur &
                             ~refill_partial_hit_cur;
    wire        write_miss = i_req_wen & ~hit;
    wire        pending_needs_refill = pending_req_cur & ~pending_hit;
    wire        cpu_miss_req_cur = (state_cur == STATE_IDLE) &
                                   (pending_needs_refill | read_miss | write_miss);
    wire        refill_req_fire_cur = (state_cur == STATE_REFILL_REQ) &
                                      ~refill_req_done_cur &
                                      i_mem_ready;
    wire        wb_send_cur = (state_cur == STATE_IDLE) &
                              (wb_count_cur != WB_COUNT_ZERO) &
                              i_mem_ready &
                              ~cpu_miss_req_cur;
    wire        wb_has_push_space_cur = (wb_count_cur != WB_COUNT_FULL) | wb_send_cur;

    wire        write_hit_accept_cur = (state_cur == STATE_IDLE) &
                                       ~pending_req_cur &
                                       i_req_wen &
                                       hit &
                                       wb_has_push_space_cur;
    wire        write_hit_block_cur  = (state_cur == STATE_IDLE) &
                                       ~pending_req_cur &
                                       i_req_wen &
                                       hit &
                                       ~wb_has_push_space_cur;
    wire        write_req_commit_cur = (state_cur == STATE_WRITE_REQ) &
                                       wb_has_push_space_cur;

    wire        prefetch_cpu_miss_cur = (state_cur == STATE_REFILL_REQ) &
                                        miss_is_prefetch_cur &
                                        (read_miss | write_miss);
    wire        prefetch_cpu_write_cur = (state_cur == STATE_REFILL_REQ) &
                                         miss_is_prefetch_cur &
                                         i_req_wen;

    wire        wb_push_cur = write_hit_accept_cur | write_req_commit_cur;
    wire [31:0] wb_push_addr_cur = write_hit_accept_cur ? i_req_addr : miss_word_addr;
    wire [31:0] wb_push_data_cur = write_hit_accept_cur ? merged_write_word : miss_merged_write_word;

    always @(posedge i_clk) begin
        if (i_rst) begin
            state_cur <= STATE_IDLE;
            miss_tag_cur <= {T{1'b0}};
            miss_set_cur <= {S{1'b0}};
            miss_word_cur <= 4'd0;
            miss_way_cur <= 2'b00;
            miss_is_write_cur <= 1'b0;
            miss_is_prefetch_cur <= 1'b0;
            miss_mask_cur <= 4'b0000;
            miss_wdata_cur <= 32'b0;
            refill_req_word_cur <= 4'd0;
            refill_rsp_word_cur <= 4'd0;
            refill_req_done_cur <= 1'b0;
            rsp_tag_cur <= {T{1'b0}};
            rsp_set_cur <= {S{1'b0}};
            rsp_word_cur <= 4'd0;
            rsp_way_cur <= 2'b00;
            rsp_is_write_cur <= 1'b0;
            rsp_is_prefetch_cur <= 1'b0;
            rsp_mask_cur <= 4'b0000;
            rsp_wdata_cur <= 32'b0;
            chained_pending_cur <= 1'b0;
            early_restart_valid_cur <= 1'b0;
            early_restart_data_cur <= 32'b0;
            pending_req_cur <= 1'b0;
            pending_tag_cur <= {T{1'b0}};
            pending_set_cur <= {S{1'b0}};
            pending_word_cur <= 4'd0;
            pending_is_write_cur <= 1'b0;
            pending_mask_cur <= 4'b0000;
            pending_wdata_cur <= 32'b0;
            wb_head_cur <= {WB_PTR_W{1'b0}};
            wb_tail_cur <= {WB_PTR_W{1'b0}};
            wb_count_cur <= {WB_COUNT_W{1'b0}};
            valid0 <= {DEPTH{1'b0}};
            valid1 <= {DEPTH{1'b0}};
            valid2 <= {DEPTH{1'b0}};
            valid3 <= {DEPTH{1'b0}};
        end else begin
            // Default clear for the one-cycle early-restart pulse; the refill
            // handling below will re-assert it when the critical word lands.
            early_restart_valid_cur <= 1'b0;

            if (wb_push_cur) begin
                wb_addrs[wb_tail_cur] <= wb_push_addr_cur;
                wb_datas[wb_tail_cur] <= wb_push_data_cur;
            end

            if (wb_send_cur)
                wb_head_cur <= wb_head_cur + 1'b1;
            if (wb_push_cur)
                wb_tail_cur <= wb_tail_cur + 1'b1;

            case ({wb_push_cur, wb_send_cur})
                2'b10: wb_count_cur <= wb_count_cur + 1'b1;
                2'b01: wb_count_cur <= wb_count_cur - 1'b1;
                default: wb_count_cur <= wb_count_cur;
            endcase

            if (prefetch_cpu_miss_cur & ~pending_req_cur) begin
                pending_req_cur <= 1'b1;
                pending_tag_cur <= req_tag;
                pending_set_cur <= req_set;
                pending_word_cur <= req_word;
                pending_is_write_cur <= i_req_wen;
                pending_mask_cur <= i_req_mask;
                pending_wdata_cur <= i_req_wdata;
            end

            case (state_cur)
                STATE_IDLE: begin
                    if (pending_req_cur) begin
                        if (pending_hit) begin
                            repl_way[pending_set_cur] <= pending_hit_way + 2'd1;
                            pending_req_cur <= 1'b0;
                        end else begin
                            miss_tag_cur <= pending_tag_cur;
                            miss_set_cur <= pending_set_cur;
                            miss_word_cur <= pending_word_cur;
                            miss_way_cur <= pending_victim_way;
                            miss_is_write_cur <= pending_is_write_cur;
                            miss_is_prefetch_cur <= 1'b0;
                            miss_mask_cur <= pending_mask_cur;
                            miss_wdata_cur <= pending_wdata_cur;
                            refill_req_word_cur <= 4'd0;
                            refill_req_done_cur <= 1'b0;
                            rsp_tag_cur <= pending_tag_cur;
                            rsp_set_cur <= pending_set_cur;
                            rsp_word_cur <= pending_word_cur;
                            rsp_way_cur <= pending_victim_way;
                            rsp_is_write_cur <= pending_is_write_cur;
                            rsp_is_prefetch_cur <= 1'b0;
                            rsp_mask_cur <= pending_mask_cur;
                            rsp_wdata_cur <= pending_wdata_cur;
                            refill_rsp_word_cur <= 4'd0;
                            chained_pending_cur <= 1'b0;
                            pending_req_cur <= 1'b0;
                            state_cur <= STATE_REFILL_REQ;
                        end
                    end else if (i_req_ren & hit) begin
                        repl_way[req_set] <= hit_way + 2'd1;
                    end else if (write_hit_accept_cur) begin
                        case (hit_way)
                            2'd0: datas0[req_set][req_word] <= merged_write_word;
                            2'd1: datas1[req_set][req_word] <= merged_write_word;
                            2'd2: datas2[req_set][req_word] <= merged_write_word;
                            default: datas3[req_set][req_word] <= merged_write_word;
                        endcase
                        repl_way[req_set] <= hit_way + 2'd1;
                    end else if (write_hit_block_cur) begin
                        // This is a write-hit stall (waiting for write-buffer
                        // space). The line is already resident; don't
                        // invalidate it here.
                        miss_tag_cur <= req_tag;
                        miss_set_cur <= req_set;
                        miss_word_cur <= req_word;
                        miss_way_cur <= hit_way;
                        miss_is_write_cur <= 1'b1;
                        miss_is_prefetch_cur <= 1'b0;
                        miss_mask_cur <= i_req_mask;
                        miss_wdata_cur <= i_req_wdata;
                        rsp_tag_cur <= req_tag;
                        rsp_set_cur <= req_set;
                        rsp_word_cur <= req_word;
                        rsp_way_cur <= hit_way;
                        rsp_is_write_cur <= 1'b1;
                        rsp_is_prefetch_cur <= 1'b0;
                        rsp_mask_cur <= i_req_mask;
                        rsp_wdata_cur <= i_req_wdata;
                        chained_pending_cur <= 1'b0;
                        state_cur <= STATE_WRITE_REQ;
                    end else if (read_miss | write_miss) begin
                        miss_tag_cur <= req_tag;
                        miss_set_cur <= req_set;
                        miss_word_cur <= req_word;
                        miss_way_cur <= victim_way;
                        miss_is_write_cur <= i_req_wen;
                        miss_is_prefetch_cur <= 1'b0;
                        miss_mask_cur <= i_req_mask;
                        miss_wdata_cur <= i_req_wdata;
                        refill_req_word_cur <= 4'd0;
                        refill_req_done_cur <= 1'b0;
                        // Initialize response-side context to match.
                        rsp_tag_cur <= req_tag;
                        rsp_set_cur <= req_set;
                        rsp_word_cur <= req_word;
                        rsp_way_cur <= victim_way;
                        rsp_is_write_cur <= i_req_wen;
                        rsp_is_prefetch_cur <= 1'b0;
                        rsp_mask_cur <= i_req_mask;
                        rsp_wdata_cur <= i_req_wdata;
                        refill_rsp_word_cur <= 4'd0;
                        chained_pending_cur <= 1'b0;
                        state_cur <= STATE_REFILL_REQ;
                    end
                end

                STATE_REFILL_REQ: begin
                    if (refill_req_fire_cur) begin
                        if (refill_req_word_cur == REFILL_LAST_WORD) begin
                            refill_req_done_cur <= 1'b1;
                        end else begin
                            refill_req_word_cur <= refill_req_word_cur + 1'b1;
                        end
                    end

                    if (i_mem_valid) begin
                        case (rsp_way_cur)
                            2'd0: datas0[rsp_set_cur][refill_rsp_word_abs] <= i_mem_rdata;
                            2'd1: datas1[rsp_set_cur][refill_rsp_word_abs] <= i_mem_rdata;
                            2'd2: datas2[rsp_set_cur][refill_rsp_word_abs] <= i_mem_rdata;
                            default: datas3[rsp_set_cur][refill_rsp_word_abs] <= i_mem_rdata;
                        endcase

                        // Early restart: the first response is the critical word.
                        // Capture it for a combinational bypass next cycle so the
                        // demand requester can consume it without waiting for the
                        // remaining words of the line.
                        if (refill_rsp_word_cur == 4'd0 && ~rsp_is_prefetch_cur &&
                            ~rsp_is_write_cur) begin
                            early_restart_valid_cur <= 1'b1;
                            early_restart_data_cur  <= i_mem_rdata;
                        end

                        if (refill_rsp_word_cur == REFILL_LAST_WORD) begin
                            case (rsp_way_cur)
                                2'd0: begin
                                    tags0[rsp_set_cur] <= rsp_tag_cur;
                                    valid0[rsp_set_cur] <= 1'b1;
                                end
                                2'd1: begin
                                    tags1[rsp_set_cur] <= rsp_tag_cur;
                                    valid1[rsp_set_cur] <= 1'b1;
                                end
                                2'd2: begin
                                    tags2[rsp_set_cur] <= rsp_tag_cur;
                                    valid2[rsp_set_cur] <= 1'b1;
                                end
                                default: begin
                                    tags3[rsp_set_cur] <= rsp_tag_cur;
                                    valid3[rsp_set_cur] <= 1'b1;
                                end
                            endcase

                            repl_way[rsp_set_cur] <= rsp_way_cur + 2'd1;

                            if (chained_pending_cur) begin
                                // Pipelined chained prefetch is already
                                // underway on the request side: the old line
                                // just received its last response. Promote
                                // miss_* into rsp_* so the next D responses
                                // land into the new line. Preserve current
                                // miss_* (request side) as-is.
                                rsp_tag_cur         <= miss_tag_cur;
                                rsp_set_cur         <= miss_set_cur;
                                rsp_word_cur        <= miss_word_cur;
                                rsp_way_cur         <= miss_way_cur;
                                rsp_is_prefetch_cur <= miss_is_prefetch_cur;
                                rsp_is_write_cur    <= miss_is_write_cur;
                                rsp_mask_cur        <= miss_mask_cur;
                                rsp_wdata_cur       <= miss_wdata_cur;
                                refill_rsp_word_cur <= 4'd0;
                                chained_pending_cur <= 1'b0;
                                // Stay in STATE_REFILL_REQ.
                            end else if (rsp_is_prefetch_cur) begin
                                if (PREFETCH_EN && ~pending_req_cur &&
                                    ~(read_miss | write_miss | write_hit_block_cur) &&
                                    ~next_line_hit) begin
                                    miss_tag_cur <= next_line_tag;
                                    miss_set_cur <= next_line_set;
                                    miss_word_cur <= 4'd0;
                                    miss_way_cur <= next_victim_way;
                                    miss_is_write_cur <= 1'b0;
                                    miss_is_prefetch_cur <= 1'b1;
                                    miss_mask_cur <= 4'b0000;
                                    miss_wdata_cur <= 32'b0;
                                    refill_req_word_cur <= 4'd0;
                                    refill_req_done_cur <= 1'b0;
                                    rsp_tag_cur <= next_line_tag;
                                    rsp_set_cur <= next_line_set;
                                    rsp_word_cur <= 4'd0;
                                    rsp_way_cur <= next_victim_way;
                                    rsp_is_prefetch_cur <= 1'b1;
                                    rsp_is_write_cur <= 1'b0;
                                    rsp_mask_cur <= 4'b0000;
                                    rsp_wdata_cur <= 32'b0;
                                    refill_rsp_word_cur <= 4'd0;
                                end else begin
                                    miss_is_prefetch_cur <= 1'b0;
                                    rsp_is_prefetch_cur  <= 1'b0;
                                    state_cur <= STATE_IDLE;
                                end
                            end else if (rsp_is_write_cur) begin
                                state_cur <= STATE_WRITE_REQ;
                            end else if (PREFETCH_EN && ~pending_req_cur && ~next_line_hit) begin
                                miss_tag_cur <= next_line_tag;
                                miss_set_cur <= next_line_set;
                                miss_word_cur <= 4'd0;
                                miss_way_cur <= next_victim_way;
                                miss_is_write_cur <= 1'b0;
                                miss_is_prefetch_cur <= 1'b1;
                                miss_mask_cur <= 4'b0000;
                                miss_wdata_cur <= 32'b0;
                                refill_req_word_cur <= 4'd0;
                                refill_req_done_cur <= 1'b0;
                                rsp_tag_cur <= next_line_tag;
                                rsp_set_cur <= next_line_set;
                                rsp_word_cur <= 4'd0;
                                rsp_way_cur <= next_victim_way;
                                rsp_is_prefetch_cur <= 1'b1;
                                rsp_is_write_cur <= 1'b0;
                                rsp_mask_cur <= 4'b0000;
                                rsp_wdata_cur <= 32'b0;
                                refill_rsp_word_cur <= 4'd0;
                                state_cur <= STATE_REFILL_REQ;
                            end else begin
                                state_cur <= STATE_IDLE;
                            end
                        end else begin
                            refill_rsp_word_cur <= refill_rsp_word_cur + 1'b1;
                        end
                    end
                end

                STATE_WRITE_REQ: begin
                    if (write_req_commit_cur) begin
                        case (miss_way_cur)
                            2'd0: datas0[miss_set_cur][miss_word_cur] <= miss_merged_write_word;
                            2'd1: datas1[miss_set_cur][miss_word_cur] <= miss_merged_write_word;
                            2'd2: datas2[miss_set_cur][miss_word_cur] <= miss_merged_write_word;
                            default: datas3[miss_set_cur][miss_word_cur] <= miss_merged_write_word;
                        endcase

                        repl_way[miss_set_cur] <= miss_way_cur + 2'd1;
                        state_cur <= STATE_IDLE;
                    end
                end

                default: begin
                    state_cur <= STATE_IDLE;
                end
            endcase
        end
    end

    assign o_mem_addr  = (state_cur == STATE_REFILL_REQ) ? refill_word_addr :
                         (wb_send_cur ? wb_addrs[wb_head_cur] : 32'b0);
    assign o_mem_ren   = refill_req_fire_cur;
    assign o_mem_wen   = wb_send_cur;
    assign o_mem_wdata = wb_send_cur ? wb_datas[wb_head_cur] : 32'b0;

    // The CPU's live request address matches the line currently receiving
    // memory responses (rsp_* context). Until the critical word arrives
    // via early-restart, the cache must report busy even for prefetch-
    // originated refills; otherwise the CPU will latch stale data.
    wire req_matches_rsp_cur = refill_req_matches_rsp_cur;
    assign o_busy = (((state_cur == STATE_REFILL_REQ) & ~rsp_is_prefetch_cur) |
                    (state_cur == STATE_WRITE_REQ) |
                    ((state_cur == STATE_REFILL_REQ) & rsp_is_prefetch_cur &
                     (prefetch_cpu_miss_cur | prefetch_cpu_write_cur |
                      req_matches_rsp_cur)) |
                    (pending_req_cur & ~pending_hit) |
                    ((state_cur == STATE_IDLE) &
                     (read_miss | write_miss | write_hit_block_cur))) &
                    ~early_restart_match_cur &
                    ~refill_partial_hit_cur;
    assign o_res_rdata = early_restart_match_cur  ? i_mem_rdata :
                         refill_partial_hit_cur   ? refill_partial_data_cur :
                                                    hit_rword;
endmodule

`default_nettype wire
