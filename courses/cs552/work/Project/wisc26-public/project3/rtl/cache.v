`default_nettype none

// 4-way set-associative write-back cache with write buffer and next-line prefetch.
// Parameters kept compatible with the original 2-way module; associativity is
// increased from 2 to 4 ways.  The prefetch port (i_pf_addr / i_pf_req) lets
// the hart issue a speculative read for the next cache line when a fill is
// completing.  If the port is unused (tie i_pf_req=0) the module behaves like
// a plain 4-way cache.
module cache (
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
    output wire [31:0] o_res_rdata,
    // Prefetch port — tie i_pf_req=0 to disable.
    input  wire [31:0] i_pf_addr,
    input  wire        i_pf_req
);
    localparam O = 4;          // 16-byte cache line
    localparam S = 5;          // 32 sets
    localparam DEPTH = 32;
    localparam T = 23;         // tag bits
    localparam D = 4;          // 4 words per line
    localparam WAYS = 4;       // 4-way associativity

    localparam STATE_IDLE        = 2'd0;
    localparam STATE_REFILL_REQ  = 2'd1;
    localparam STATE_REFILL_WAIT = 2'd2;
    localparam STATE_WRITE_REQ   = 2'd3;

    localparam WB_DEPTH   = 8;
    localparam WB_PTR_W   = 3;
    localparam WB_COUNT_W = 4;
    localparam [WB_COUNT_W - 1:0] WB_COUNT_ZERO = 4'd0;
    localparam [WB_COUNT_W - 1:0] WB_COUNT_FULL = 4'd8;
    localparam [1:0] REFILL_LAST_WORD = 2'd3;

    // -----------------------------------------------------------------------
    // 4-way data / tag / valid arrays
    // -----------------------------------------------------------------------
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
    // 2-bit pseudo-LRU per set encoded as a tree:
    //   bit[1] = MRU side of root (0→way0/1, 1→way2/3)
    //   bit[0] = MRU within left pair (0→way0, 1→way1)  when bit[1]=0
    //            MRU within right pair (0→way2, 1→way3) when bit[1]=1
    reg [1:0] plru [DEPTH - 1:0];

    // -----------------------------------------------------------------------
    // Write-back buffer (unchanged depth from original)
    // -----------------------------------------------------------------------
    reg [31:0] wb_addrs [WB_DEPTH - 1:0];
    reg [31:0] wb_datas [WB_DEPTH - 1:0];
    reg [WB_PTR_W - 1:0] wb_head_cur;
    reg [WB_PTR_W - 1:0] wb_tail_cur;
    reg [WB_COUNT_W - 1:0] wb_count_cur;

    // -----------------------------------------------------------------------
    // FSM state
    // -----------------------------------------------------------------------
    reg [1:0] state_cur;
    reg [T - 1:0] miss_tag_cur;
    reg [S - 1:0] miss_set_cur;
    reg [1:0]     miss_word_cur;
    reg [1:0]     miss_way_cur;    // 2-bit for 4 ways
    reg           miss_is_write_cur;
    reg [3:0]     miss_mask_cur;
    reg [31:0]    miss_wdata_cur;
    reg [1:0]     refill_req_word_cur;
    reg [1:0]     refill_rsp_word_cur;
    reg           refill_req_done_cur;
    // Prefetch request latched when idle and pf_req arrives
    reg           pf_pending_cur;
    reg [T - 1:0] pf_tag_cur;
    reg [S - 1:0] pf_set_cur;

    // -----------------------------------------------------------------------
    // Address decode for CPU request
    // -----------------------------------------------------------------------
    wire [T - 1:0] req_tag  = i_req_addr[31:O + S];
    wire [S - 1:0] req_set  = i_req_addr[O + S - 1:O];
    wire [1:0]     req_word = i_req_addr[3:2];

    wire        way0_valid = valid0[req_set];
    wire        way1_valid = valid1[req_set];
    wire        way2_valid = valid2[req_set];
    wire        way3_valid = valid3[req_set];
    wire        way0_hit   = way0_valid & (tags0[req_set] == req_tag);
    wire        way1_hit   = way1_valid & (tags1[req_set] == req_tag);
    wire        way2_hit   = way2_valid & (tags2[req_set] == req_tag);
    wire        way3_hit   = way3_valid & (tags3[req_set] == req_tag);
    wire        hit        = way0_hit | way1_hit | way2_hit | way3_hit;

    wire [31:0] way0_rword = datas0[req_set][req_word];
    wire [31:0] way1_rword = datas1[req_set][req_word];
    wire [31:0] way2_rword = datas2[req_set][req_word];
    wire [31:0] way3_rword = datas3[req_set][req_word];
    wire [31:0] hit_rword  = way0_hit ? way0_rword :
                             way1_hit ? way1_rword :
                             way2_hit ? way2_rword :
                             way3_hit ? way3_rword : 32'b0;
    wire [1:0]  hit_way    = way0_hit ? 2'd0 :
                             way1_hit ? 2'd1 :
                             way2_hit ? 2'd2 : 2'd3;

    wire        read_miss  = i_req_ren & ~hit;
    wire        write_miss = i_req_wen & ~hit;

    // PLRU victim: pick the way that is least-recently used using the 2-bit tree.
    // Tree bit[1]: 0→left pair (way0/1) is LRU side, 1→right pair (way2/3)
    // Tree bit[0]: 0→way0 is LRU within left pair, 1→way1 within left pair
    //              (re-used for right pair too: 0→way2, 1→way3)
    wire        all_valid  = way0_valid & way1_valid & way2_valid & way3_valid;
    wire [1:0]  victim_way =
        ~way0_valid ? 2'd0 :
        ~way1_valid ? 2'd1 :
        ~way2_valid ? 2'd2 :
        ~way3_valid ? 2'd3 :
        (~plru[req_set][1] ? (plru[req_set][0] ? 2'd1 : 2'd0) :
                             (plru[req_set][0] ? 2'd3 : 2'd2));

    // -----------------------------------------------------------------------
    // Write-merge helpers
    // -----------------------------------------------------------------------
    wire [31:0] req_byte_mask = {{8{i_req_mask[3]}}, {8{i_req_mask[2]}},
                                 {8{i_req_mask[1]}}, {8{i_req_mask[0]}}};
    wire [31:0] merged_write_word = (hit_rword & ~req_byte_mask) |
                                    (i_req_wdata & req_byte_mask);

    wire [31:0] miss_line_addr   = {miss_tag_cur, miss_set_cur, 4'b0000};
    wire [31:0] refill_word_addr = miss_line_addr | {28'b0, refill_req_word_cur, 2'b00};
    wire [31:0] miss_word_addr   = {miss_tag_cur, miss_set_cur, miss_word_cur, 2'b00};

    wire [31:0] miss_way_rword = (miss_way_cur == 2'd0) ? datas0[miss_set_cur][miss_word_cur] :
                                 (miss_way_cur == 2'd1) ? datas1[miss_set_cur][miss_word_cur] :
                                 (miss_way_cur == 2'd2) ? datas2[miss_set_cur][miss_word_cur] :
                                                          datas3[miss_set_cur][miss_word_cur];
    wire [31:0] miss_byte_mask = {{8{miss_mask_cur[3]}}, {8{miss_mask_cur[2]}},
                                  {8{miss_mask_cur[1]}}, {8{miss_mask_cur[0]}}};
    wire [31:0] miss_merged_write_word = (miss_way_rword & ~miss_byte_mask) |
                                         (miss_wdata_cur & miss_byte_mask);

    // -----------------------------------------------------------------------
    // Control signals
    // -----------------------------------------------------------------------
    wire        cpu_miss_req_cur   = (state_cur == STATE_IDLE) & (read_miss | write_miss);
    wire        refill_req_fire_cur= (state_cur == STATE_REFILL_REQ) &
                                     ~refill_req_done_cur & i_mem_ready;
    wire        wb_send_cur        = (state_cur != STATE_REFILL_REQ) &
                                     (state_cur != STATE_REFILL_WAIT) &
                                     (wb_count_cur != WB_COUNT_ZERO) &
                                     i_mem_ready & ~cpu_miss_req_cur;
    wire        wb_has_push_space_cur = (wb_count_cur != WB_COUNT_FULL) | wb_send_cur;

    wire        write_hit_accept_cur = (state_cur == STATE_IDLE) &
                                       i_req_wen & hit & wb_has_push_space_cur;
    wire        write_hit_block_cur  = (state_cur == STATE_IDLE) &
                                       i_req_wen & hit & ~wb_has_push_space_cur;
    wire        write_req_commit_cur = (state_cur == STATE_WRITE_REQ) &
                                       wb_has_push_space_cur;

    wire        wb_push_cur          = write_hit_accept_cur | write_req_commit_cur;
    wire [31:0] wb_push_addr_cur     = write_hit_accept_cur ? i_req_addr : miss_word_addr;
    wire [31:0] wb_push_data_cur     = write_hit_accept_cur ? merged_write_word :
                                                               miss_merged_write_word;

    // -----------------------------------------------------------------------
    // Prefetch address decode
    // -----------------------------------------------------------------------
    wire [T - 1:0] pf_tag_in  = i_pf_addr[31:O + S];
    wire [S - 1:0] pf_set_in  = i_pf_addr[O + S - 1:O];
    wire           pf_way0_hit = valid0[pf_set_in] & (tags0[pf_set_in] == pf_tag_in);
    wire           pf_way1_hit = valid1[pf_set_in] & (tags1[pf_set_in] == pf_tag_in);
    wire           pf_way2_hit = valid2[pf_set_in] & (tags2[pf_set_in] == pf_tag_in);
    wire           pf_way3_hit = valid3[pf_set_in] & (tags3[pf_set_in] == pf_tag_in);
    wire           pf_already_present = pf_way0_hit | pf_way1_hit | pf_way2_hit | pf_way3_hit;
    // Don't prefetch if already in cache, already pending, or same set as CPU miss
    wire           pf_accept_cur = i_pf_req & ~pf_already_present & ~pf_pending_cur &
                                   ~cpu_miss_req_cur & (state_cur == STATE_IDLE);

    // Prefetch for a pending line: latch when cpu miss completes and pf_pending is set
    wire [S - 1:0] pf_set_eff = pf_pending_cur ? pf_set_cur : pf_set_in;
    wire [T - 1:0] pf_tag_eff = pf_pending_cur ? pf_tag_cur : pf_tag_in;
    wire           pf_way0_hit_eff = valid0[pf_set_eff] & (tags0[pf_set_eff] == pf_tag_eff);
    wire           pf_way1_hit_eff = valid1[pf_set_eff] & (tags1[pf_set_eff] == pf_tag_eff);
    wire           pf_way2_hit_eff = valid2[pf_set_eff] & (tags2[pf_set_eff] == pf_tag_eff);
    wire           pf_way3_hit_eff = valid3[pf_set_eff] & (tags3[pf_set_eff] == pf_tag_eff);
    wire           pf_effective_present = pf_way0_hit_eff | pf_way1_hit_eff |
                                          pf_way2_hit_eff | pf_way3_hit_eff;
    // Victim for prefetch line
    wire           pf_v0 = valid0[pf_set_eff];
    wire           pf_v1 = valid1[pf_set_eff];
    wire           pf_v2 = valid2[pf_set_eff];
    wire           pf_v3 = valid3[pf_set_eff];
    wire [1:0]     pf_victim_way =
        ~pf_v0 ? 2'd0 : ~pf_v1 ? 2'd1 : ~pf_v2 ? 2'd2 : ~pf_v3 ? 2'd3 :
        (~plru[pf_set_eff][1] ? (plru[pf_set_eff][0] ? 2'd1 : 2'd0) :
                                (plru[pf_set_eff][0] ? 2'd3 : 2'd2));
    // Can start prefetch fill when idle and pending pf is not yet present
    wire           pf_fill_start_cur = (state_cur == STATE_IDLE) &
                                       pf_pending_cur & ~pf_effective_present &
                                       ~cpu_miss_req_cur;

    // -----------------------------------------------------------------------
    // PLRU update helper function (as wire expressions)
    // After accessing way W in set S, update plru to mark W as most-recently-used.
    // Returns the new 2-bit plru value.
    // -----------------------------------------------------------------------
    // For hit-way update: mark the accessed way as MRU.
    // plru[1] records which side (left=0/right=1) was MRU. plru[0] records which
    // lane within the LRU side.
    // On access to way0: set plru={1,0} (right side is LRU, left-MRU=way0→plru[0]=0→LRU is way1)
    // Actually we track LRU not MRU:
    //   plru[1]=0 means left pair (way0/1) is LRU side
    //   plru[0]=0 means within left pair way0 is LRU, =1 way1 is LRU
    // On access to way W, update to point LRU away from W:
    //   W=0: plru → {0, 1}  (left side's LRU becomes way1; left is still LRU root for future)
    //         Actually: after using way0, left side used → root LRU points right: plru[1]=1; within left, LRU=way1: plru[0]=1
    //   W=1: plru → plru[1]=1, plru[0]=0
    //   W=2: plru → plru[1]=0, plru[0]=1
    //   W=3: plru → plru[1]=0, plru[0]=0
    // Summary: plru[1] = ~way[1]; plru[0] = ~way[0]
    // Victim = {~plru[1], ~plru[0]} (select the LRU way directly)
    // Actually: victim_way = {~plru[set][1], ~plru[set][0]} -- simpler!

    // -----------------------------------------------------------------------
    // Sequential logic
    // -----------------------------------------------------------------------
    always @(posedge i_clk) begin
        if (i_rst) begin
            state_cur <= STATE_IDLE;
            miss_tag_cur <= {T{1'b0}};
            miss_set_cur <= {S{1'b0}};
            miss_word_cur <= 2'b00;
            miss_way_cur <= 2'b00;
            miss_is_write_cur <= 1'b0;
            miss_mask_cur <= 4'b0000;
            miss_wdata_cur <= 32'b0;
            refill_req_word_cur <= 2'b00;
            refill_rsp_word_cur <= 2'b00;
            refill_req_done_cur <= 1'b0;
            wb_head_cur <= {WB_PTR_W{1'b0}};
            wb_tail_cur <= {WB_PTR_W{1'b0}};
            wb_count_cur <= {WB_COUNT_W{1'b0}};
            valid0 <= {DEPTH{1'b0}};
            valid1 <= {DEPTH{1'b0}};
            valid2 <= {DEPTH{1'b0}};
            valid3 <= {DEPTH{1'b0}};
            plru[0] <= 2'b00; plru[1] <= 2'b00; plru[2] <= 2'b00; plru[3] <= 2'b00;
            plru[4] <= 2'b00; plru[5] <= 2'b00; plru[6] <= 2'b00; plru[7] <= 2'b00;
            plru[8] <= 2'b00; plru[9] <= 2'b00; plru[10] <= 2'b00; plru[11] <= 2'b00;
            plru[12] <= 2'b00; plru[13] <= 2'b00; plru[14] <= 2'b00; plru[15] <= 2'b00;
            plru[16] <= 2'b00; plru[17] <= 2'b00; plru[18] <= 2'b00; plru[19] <= 2'b00;
            plru[20] <= 2'b00; plru[21] <= 2'b00; plru[22] <= 2'b00; plru[23] <= 2'b00;
            plru[24] <= 2'b00; plru[25] <= 2'b00; plru[26] <= 2'b00; plru[27] <= 2'b00;
            plru[28] <= 2'b00; plru[29] <= 2'b00; plru[30] <= 2'b00; plru[31] <= 2'b00;
            pf_pending_cur <= 1'b0;
            pf_tag_cur <= {T{1'b0}};
            pf_set_cur <= {S{1'b0}};
        end else begin
            // -----------------------------------------------------------------
            // Write-back buffer management
            // -----------------------------------------------------------------
            if (wb_push_cur) begin
                wb_addrs[wb_tail_cur] <= wb_push_addr_cur;
                wb_datas[wb_tail_cur] <= wb_push_data_cur;
            end

            if (wb_send_cur) wb_head_cur <= wb_head_cur + 1'b1;
            if (wb_push_cur) wb_tail_cur <= wb_tail_cur + 1'b1;

            case ({wb_push_cur, wb_send_cur})
                2'b10:   wb_count_cur <= wb_count_cur + 1'b1;
                2'b01:   wb_count_cur <= wb_count_cur - 1'b1;
                default: wb_count_cur <= wb_count_cur;
            endcase

            // -----------------------------------------------------------------
            // Prefetch pending latch
            // -----------------------------------------------------------------
            if (pf_accept_cur) begin
                pf_pending_cur <= 1'b1;
                pf_tag_cur     <= pf_tag_in;
                pf_set_cur     <= pf_set_in;
            end else if (pf_fill_start_cur) begin
                // Starting the prefetch fill — pf_pending cleared after refill
                // completes; keep it set so FSM knows it's a prefetch
            end
            // Cleared in REFILL_REQ when it's a prefetch fill (see below)

            // -----------------------------------------------------------------
            // Main FSM
            // -----------------------------------------------------------------
            case (state_cur)
                STATE_IDLE: begin
                    if (i_req_ren & hit) begin
                        // Update PLRU on read hit: accessed hit_way
                        plru[req_set] <= {~hit_way[1], ~hit_way[0]};
                    end else if (write_hit_accept_cur) begin
                        if (way0_hit)      datas0[req_set][req_word] <= merged_write_word;
                        else if (way1_hit) datas1[req_set][req_word] <= merged_write_word;
                        else if (way2_hit) datas2[req_set][req_word] <= merged_write_word;
                        else               datas3[req_set][req_word] <= merged_write_word;
                        plru[req_set] <= {~hit_way[1], ~hit_way[0]};
                    end else if (write_hit_block_cur) begin
                        miss_tag_cur <= req_tag;
                        miss_set_cur <= req_set;
                        miss_word_cur <= req_word;
                        miss_way_cur <= hit_way;
                        miss_is_write_cur <= 1'b1;
                        miss_mask_cur <= i_req_mask;
                        miss_wdata_cur <= i_req_wdata;
                        state_cur <= STATE_WRITE_REQ;
                    end else if (read_miss | write_miss) begin
                        miss_tag_cur <= req_tag;
                        miss_set_cur <= req_set;
                        miss_word_cur <= req_word;
                        miss_way_cur <= victim_way;
                        miss_is_write_cur <= i_req_wen;
                        miss_mask_cur <= i_req_mask;
                        miss_wdata_cur <= i_req_wdata;
                        refill_req_word_cur <= 2'b00;
                        refill_rsp_word_cur <= 2'b00;
                        refill_req_done_cur <= 1'b0;
                        state_cur <= STATE_REFILL_REQ;
                    end else if (pf_fill_start_cur) begin
                        // Start prefetch refill for the latched pf address
                        miss_tag_cur <= pf_tag_cur;
                        miss_set_cur <= pf_set_cur;
                        miss_word_cur <= 2'b00;
                        miss_way_cur <= pf_victim_way;
                        miss_is_write_cur <= 1'b0;
                        miss_mask_cur <= 4'b0000;
                        miss_wdata_cur <= 32'b0;
                        refill_req_word_cur <= 2'b00;
                        refill_rsp_word_cur <= 2'b00;
                        refill_req_done_cur <= 1'b0;
                        state_cur <= STATE_REFILL_REQ;
                        pf_pending_cur <= 1'b0;  // clear after launching
                    end
                end

                STATE_REFILL_REQ: begin
                    if (refill_req_fire_cur) begin
                        if (refill_req_word_cur == REFILL_LAST_WORD)
                            refill_req_done_cur <= 1'b1;
                        else
                            refill_req_word_cur <= refill_req_word_cur + 1'b1;
                    end

                    if (i_mem_valid) begin
                        case (miss_way_cur)
                            2'd0: datas0[miss_set_cur][refill_rsp_word_cur] <= i_mem_rdata;
                            2'd1: datas1[miss_set_cur][refill_rsp_word_cur] <= i_mem_rdata;
                            2'd2: datas2[miss_set_cur][refill_rsp_word_cur] <= i_mem_rdata;
                            2'd3: datas3[miss_set_cur][refill_rsp_word_cur] <= i_mem_rdata;
                            default: ;
                        endcase

                        if (refill_rsp_word_cur == REFILL_LAST_WORD) begin
                            case (miss_way_cur)
                                2'd0: begin tags0[miss_set_cur] <= miss_tag_cur; valid0[miss_set_cur] <= 1'b1; end
                                2'd1: begin tags1[miss_set_cur] <= miss_tag_cur; valid1[miss_set_cur] <= 1'b1; end
                                2'd2: begin tags2[miss_set_cur] <= miss_tag_cur; valid2[miss_set_cur] <= 1'b1; end
                                2'd3: begin tags3[miss_set_cur] <= miss_tag_cur; valid3[miss_set_cur] <= 1'b1; end
                                default: ;
                            endcase

                            if (miss_is_write_cur) begin
                                state_cur <= STATE_WRITE_REQ;
                            end else begin
                                // Update PLRU for the filled way
                                plru[miss_set_cur] <= {~miss_way_cur[1], ~miss_way_cur[0]};
                                state_cur <= STATE_IDLE;
                                // Accept new prefetch if arriving at this exact cycle
                                if (i_pf_req & ~pf_pending_cur & ~pf_already_present)
                                    pf_pending_cur <= 1'b1;
                            end
                        end else begin
                            refill_rsp_word_cur <= refill_rsp_word_cur + 1'b1;
                        end
                    end
                end

                STATE_REFILL_WAIT: begin
                    state_cur <= STATE_IDLE;
                end

                STATE_WRITE_REQ: begin
                    if (write_req_commit_cur) begin
                        case (miss_way_cur)
                            2'd0: datas0[miss_set_cur][miss_word_cur] <= miss_merged_write_word;
                            2'd1: datas1[miss_set_cur][miss_word_cur] <= miss_merged_write_word;
                            2'd2: datas2[miss_set_cur][miss_word_cur] <= miss_merged_write_word;
                            2'd3: datas3[miss_set_cur][miss_word_cur] <= miss_merged_write_word;
                            default: ;
                        endcase
                        plru[miss_set_cur] <= {~miss_way_cur[1], ~miss_way_cur[0]};
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

    assign o_busy = (state_cur != STATE_IDLE) |
                    ((state_cur == STATE_IDLE) & (read_miss | write_miss | write_hit_block_cur));
    assign o_res_rdata = hit_rword;
endmodule

`default_nettype wire
