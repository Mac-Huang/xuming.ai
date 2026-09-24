module cache_tb ();
    // Memory parameters.
    parameter SIZE     = 16 * 1024;
    parameter LATENCY  = 4;
    parameter INTERVAL = 2;

    localparam O = 4;            // 4 bit offset => 16 byte cache line
    localparam S = 5;            // 5 bit set index => 32 sets
    localparam DEPTH = 2 ** S;   // 32 sets
    localparam W = 2;            // 2 way set associative, NMRU
    localparam T = 32 - O - S;   // 23 bit tag
    localparam D = 2 ** O / 4;   // 16 bytes per line / 4 bytes per word = 4 words per line

    // Synchronous active-high reset.
    reg         clk, rst;

    // Memory interface signals.
    wire        mem_ready;
    wire [31:0] mem_addr;
    wire        mem_ren;
    wire        mem_wen;
    wire [3:0]  mem_mask;
    wire [31:0] mem_wdata;
    wire        mem_valid;
    wire [31:0] mem_oaddr;
    wire [31:0] mem_rdata;

    // Tie off the mask for full-word accesses in phase 6.
    assign mem_mask = 4'b1111;

    // Cache interface signals.
    wire        busy;
    reg  [31:0] req_addr;
    reg         req_ren;
    reg         req_wen;
    reg  [3:0]  req_mask;
    reg  [31:0] req_wdata;
    wire [31:0] res_rdata;

    reg [23:0] tag;
    reg [4:0]  index;
    reg [3:0]  offset;

    reg [31:0] expanded_mask;

    memory #(
        .SIZE(SIZE),
        .LATENCY(LATENCY),
        .INTERVAL(INTERVAL)
    ) mem (
        .i_clk(clk),
        .i_rst(rst),
        .o_ready(mem_ready),
        .i_addr(mem_addr),
        .i_ren(mem_ren),
        .i_wen(mem_wen),
        .i_mask(mem_mask),
        .i_wdata(mem_wdata),
        .o_valid(mem_valid),
        .o_addr(mem_oaddr),
        .o_rdata(mem_rdata)
    );

    cache dut (
        .i_clk(clk),
        .i_rst(rst),
        .i_mem_ready(mem_ready),
        .o_mem_addr(mem_addr),
        .o_mem_ren(mem_ren),
        .o_mem_wen(mem_wen),
        .o_mem_wdata(mem_wdata),
        .i_mem_rdata(mem_rdata),
        .i_mem_valid(mem_valid),
        .o_busy(busy),
        .i_req_addr(req_addr),
        .i_req_ren(req_ren),
        .i_req_wen(req_wen),
        .i_req_mask(req_mask),
        .i_req_wdata(req_wdata),
        .o_res_rdata(res_rdata)
    );

    integer i;
    initial begin
        clk = 1;
        rst = 0;

        // Open the waveform file.
        $dumpfile("cache.vcd");
        $dumpvars(0, cache_tb);

        $display("Starting.");
        reset_sequence();

        $display("Loading program.");
        $readmemh("program.mem", mem.mem);

        for (i = 0; i < DEPTH; i = i + 1) begin

            tag = 23'h000000;
            index = i[4:0];
            offset = 4'b0000;

            // read miss
            send_read(tag, index, offset, 4'b1111);

            // read hit (same read as before)
            send_read(tag, index, offset, 4'b1111);

            // read hit (different mask)
            send_read(tag, index, offset, 4'b0011);

            // read hit (different offset)
            offset = 4'b1000;
            send_read(tag, index, offset, 4'b1111);

            // write miss
            tag = 23'h000001;
            offset = 4'b0000;
            send_write(tag, index, offset, 4'b1111, 32'hDEADBEEF);

            // write hit
            send_write(tag, index, offset, 4'b1111, 32'hBEEFCAFE);

            // read hit (to verify write)
            send_read(tag, index, offset, 4'b1111);

            // eviction
            tag = 23'h000002;
            send_write(tag, index, offset, 4'b1111, 32'hCAFEBEEF);

            // write with mask
            tag = 23'h000001;
            offset = 4'b0000;
            send_write(tag, index, offset, 4'b1100, 32'hBEEF0000);
            send_read(tag, index, offset, 4'b1111);
            send_write(tag, index, offset, 4'b0011, 32'h0000CAFE);
            send_read(tag, index, offset, 4'b1111);
        end

        // test for filling up each line in the set and read everything back
        index = 5'b00000;
        reset_sequence;
        send_write(23'h000001, index, 4'b0000, 4'b1111, 32'h00000000); // miss
        send_write(23'h000001, index, 4'b0100, 4'b1111, 32'h11111111); // hit 
        send_write(23'h000001, index, 4'b1000, 4'b1111, 32'h22222222); // hit 
        send_write(23'h000001, index, 4'b1100, 4'b1111, 32'h33333333); // hit
        send_write(23'h000002, index, 4'b0000, 4'b1111, 32'h44444444); // miss
        send_write(23'h000002, index, 4'b0100, 4'b1111, 32'h55555555); // hit
        send_write(23'h000002, index, 4'b1000, 4'b1111, 32'h66666666); // hit
        send_write(23'h000002, index, 4'b1100, 4'b1111, 32'h77777777); // hit

        // read it back
        send_read(23'h000001, index, 4'b0000, 4'b1111);
        send_read(23'h000001, index, 4'b0100, 4'b1111);
        send_read(23'h000001, index, 4'b1000, 4'b1111);
        send_read(23'h000001, index, 4'b1100, 4'b1111);
        send_read(23'h000002, index, 4'b0000, 4'b1111);
        send_read(23'h000002, index, 4'b0100, 4'b1111);
        send_read(23'h000002, index, 4'b1000, 4'b1111);
        send_read(23'h000002, index, 4'b1100, 4'b1111);

        $finish;
    end

    task automatic send_write(input reg [22:0] tag, input reg [4:0] index, input reg [3:0] offset, input reg [3:0] mask, input reg [31:0] data);
        begin
            req_addr = {tag, index, offset};
            req_mask = mask;
            req_ren = 0;
            req_wen = 1;
            req_wdata = data;
            @(negedge clk);
            req_wen = 0;

            if (!busy) begin
                $display("Write HIT:  addr=%08x data=%08x mask=%04b", req_addr, req_wdata & expanded_mask, req_mask);
            end else begin
                while (busy) @(negedge clk);
                $display("Write MISS: addr=%08x data=%08x mask=%04b", req_addr, req_wdata & expanded_mask, req_mask);
            end
        end
    endtask

    task automatic send_read(input reg [22:0] tag, input reg [4:0] index, input reg [3:0] offset, input reg [3:0] mask);
        begin
            req_addr = {tag, index, offset};
            req_mask = mask;
            req_wen = 0;
            req_wdata = 32'hxxxxxxxx;
            req_ren = 1;
            @(negedge clk);
            req_ren = 0;

            #0;
            expanded_mask = { {8{req_mask[3]}}, {8{req_mask[2]}}, {8{req_mask[1]}}, {8{req_mask[0]}} };
            if (!busy) begin
                $display("Read HIT:   addr=%08x data=%08x mask=%04b", req_addr, res_rdata & expanded_mask, req_mask);
            end else begin
                while (busy) @(negedge clk);
                $display("Read MISS:  addr=%08x data=%08x mask=%04b", req_addr, res_rdata & expanded_mask, req_mask);
            end
        end
    endtask

    task automatic reset_sequence();
        begin
            $display("Resetting cache and memory.");
            @(negedge clk); rst = 1;
            @(negedge clk);
            @(negedge clk);
            @(negedge clk);
            @(negedge clk); rst = 0;

            req_addr  = 32'h00000000;
            req_ren   = 0;
            req_wen   = 0;
            req_mask  = 4'b0000;
            req_wdata = 32'h00000000;

            tag = 23'h000000;
            index = 5'h00;
            offset = 4'h0;
        end
    endtask

    always #5 clk = ~clk;
endmodule
