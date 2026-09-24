// Implery module. The memory
// features a single shared read/write port with 32-bit address, byte masking,
// and a 32-bit read/write port. Memory transactions are pipelined with a
// configurable (but fixed) latency and initiation interval. Transactions
// commit in order.
//
// FIXME: This does not work with LATENCY = 1.
module memory #(
    // Memory size (number of bytes).
    parameter SIZE = 1024,
    // Memory reads are available this many clock cycles after the request.
    parameter LATENCY = 4,
    // New transactions can be initiated every so often.
    parameter INTERVAL = 2
) (
    // Global clock.
    input  wire        i_clk,
    // Synchronous active-high reset.
    input  wire        i_rst,
    // When asserted, the memory is ready to accept a new transaction.
    output wire        o_ready,
    // Shared read/write memory address. This is byte-addressed but
    // must be 32-bit aligned.
    input  wire [31:0] i_addr,
    // When asserted, the memory will perform a read at the specified
    // address `i_addr` with the specified byte mask `i_mask`.
    //
    // It is illegal to assert this and `i_wen` on the same cycle.
    // It is illegal to assert this if `o_ready` is not asserted.
    input  wire        i_ren,
    // When asserted, the memory will perform a write at the specified
    // address `i_addr` with the specified byte mask `i_mask` and
    // specified write data `i_wdata`.
    //
    // It is illegal to assert this and `i_ren` on the same cycle.
    // It is illegal to assert this if `o_ready` is not asserted.
    input  wire        i_wen,
    // The byte mask specifies which bytes within the 32-bit address will
    // be read or written.
    input  wire [3:0] i_mask,
    // The data to write for write transactions.
    input  wire [31:0] i_wdata,
    // When asserted, `o_rdata` contains valid read data for the oldest
    // in-flight read transaction.
    output wire        o_valid,
    // When `o_valid` is asserted, this contains the address of the oldest
    // in-flight read transaction, for introspection.
    output wire [31:0] o_addr,
    // This is asserted `LATENCY` cycles after `i_wen` is asserted, to
    // indicate that the memory has completed the write. This is not needed
    // for implementation but is useful for introspection.
    output wire        o_wdone,
    // When `o_valid` is asserted, this contains the read data for the oldest
    // in-flight read transaction.
    output wire [31:0] o_rdata
);
    reg [ 7:0] mem [0:SIZE - 1];

    // The memory is modeled as a shift register of in-flight transactions
    // which model the delay and initiation interval of the memory interface
    // without doing any real "work". The actual work is done in a single
    // cycle when the transaction "completes" and can infer a synchronous
    // single cycle memory, like a block RAM.
    //
    // NOTE: Synthesis has not been tested and likely needs adjustment.

    // Counter to enforce initiation interval.
    reg [$clog2(INTERVAL) - 1:0] interval_counter;
    wire ready = ~i_rst & interval_counter == 0;
    always @(posedge i_clk) begin
        if (i_rst)
            interval_counter <= 0;
        else if (interval_counter == INTERVAL - 1)
            interval_counter <= 0;
        else if (!ready | i_ren | i_wen)
            interval_counter <= interval_counter + 1;
    end

    // Internal shift register.
    reg [31:0] addrs [0:LATENCY - 1];
    reg        rens  [0:LATENCY - 1];
    reg        wens  [0:LATENCY - 1];
    reg [ 3:0] masks [0:LATENCY - 1];
    reg [31:0] wdatas[0:LATENCY - 1];

    always @(posedge i_clk) begin
        if (i_rst) begin
            // Only rens and wens need to be reset, as they gate
            // validity of all other state.
            rens  [0] <= 1'b0;
            wens  [0] <= 1'b0;
        end else begin
            addrs [0] <= i_addr;
            rens  [0] <= ready & i_ren;
            wens  [0] <= ready & i_wen;
            masks [0] <= i_mask;
            wdatas[0] <= i_wdata;
        end
    end

    genvar i;
    generate for (i = 1; i < LATENCY; i = i + 1) begin
        always @(posedge i_clk) begin
            if (i_rst) begin
                // Only rens and wens need to be reset, as they gate.
                // validity of all other state.
                rens  [i] <= 1'b0;
                wens  [i] <= 1'b0;
            end else begin
                addrs [i] <= addrs [i - 1];
                rens  [i] <= rens  [i - 1];
                wens  [i] <= wens  [i - 1];
                masks [i] <= masks [i - 1];
                wdatas[i] <= wdatas[i - 1];
            end
        end
    end endgenerate

    wire [31:0] raddr = addrs [LATENCY - 1];
    wire [31:0] waddr = addrs [LATENCY - 2];
    wire        ren   = rens  [LATENCY - 1];
    wire        wen   = wens  [LATENCY - 2];
    wire [ 3:0] mask  = masks [LATENCY - 2];
    wire [31:0] wdata = wdatas[LATENCY - 2];

    // Synchronous write.
    always @(posedge i_clk) begin
        if (wen & mask[0])
            mem[waddr + 0] <= wdata[ 7: 0];
        if (wen & mask[1])
            mem[waddr + 1] <= wdata[15: 8];
        if (wen & mask[2])
            mem[waddr + 2] <= wdata[23:16];
        if (wen & mask[3])
            mem[waddr + 3] <= wdata[31:24];
    end

    wire [31:0] res_addr  = raddr;
    wire [31:0] res_rdata = {mem[raddr + 3], mem[raddr + 2], mem[raddr + 1], mem[raddr + 0]};
    wire        res_valid = ren;
    wire        res_wdone = wen;

    assign o_rdata = res_rdata;
    assign o_addr  = res_addr;
    assign o_valid = res_valid;
    assign o_wdone = res_wdone;
    assign o_ready = ready;
endmodule
