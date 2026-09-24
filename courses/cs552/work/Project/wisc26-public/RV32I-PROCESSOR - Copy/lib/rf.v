`default_nettype none

// The register file is effectively a single cycle memory with 32-bit words
// and depth 32. It has two asynchronous read ports, allowing two independent
// registers to be read at the same time combinationally, and one synchronous
// write port, allowing a register to be written to on the next clock edge.
// The register `x0` is hardwired to zero, and writes to it are ignored.
module rf #(
    // When this parameter is set to 1, "RF bypass" mode is enabled. This
    // allows data at the write port to be observed at the read ports
    // immediately without having to wait for the next clock edge. This is
    // a common forwarding optimization in a pipelined core (project 5), but
    // will cause a single-cycle processor to behave incorrectly.
    //
    // You are required to implement and test both modes. In project 3 and 4,
    // you will set this to 0, before enabling it in project 5.
    parameter BYPASS_EN = 0
) (
    // Global clock.
    input  wire        i_clk,
    // Synchronous active-high reset.
    input  wire        i_rst,
    // Both read register ports are asynchronous (zero-cycle). That is, read
    // data is visible combinationally without having to wait for a clock.
    //
    // Register read port 1, with input address [0, 31] and output data.
    input  wire [ 4:0] i_rs1_raddr,
    output wire [31:0] o_rs1_rdata,
    // Register read port 2, with input address [0, 31] and output data.
    input  wire [ 4:0] i_rs2_raddr,
    output wire [31:0] o_rs2_rdata,
    // The register write port is synchronous. When write is enabled, the
    // write data is visible after the next clock edge.
    //
    // Write register enable, address [0, 31] and input data.
    input  wire        i_rd_wen,
    input  wire [ 4:0] i_rd_waddr,
    input  wire [31:0] i_rd_wdata
);

    reg [31:0] regs [0:31];

    wire rs1_bypass_hit = BYPASS_EN && i_rd_wen && (i_rd_waddr != 5'd0) && (i_rs1_raddr == i_rd_waddr);
    wire rs2_bypass_hit = BYPASS_EN && i_rd_wen && (i_rd_waddr != 5'd0) && (i_rs2_raddr == i_rd_waddr);

    assign o_rs1_rdata = i_rst                ? 32'd0 :
                         (i_rs1_raddr == 5'd0)? 32'd0 :
                         rs1_bypass_hit       ? i_rd_wdata :
                                                regs[i_rs1_raddr];

    assign o_rs2_rdata = i_rst                ? 32'd0 :
                         (i_rs2_raddr == 5'd0)? 32'd0 :
                         rs2_bypass_hit       ? i_rd_wdata :
                                                regs[i_rs2_raddr];

    always @(posedge i_clk) begin
        if (i_rst) begin
            regs[ 0] <= 32'd0;
            regs[ 1] <= 32'd0;
            regs[ 2] <= 32'd0;
            regs[ 3] <= 32'd0;
            regs[ 4] <= 32'd0;
            regs[ 5] <= 32'd0;
            regs[ 6] <= 32'd0;
            regs[ 7] <= 32'd0;
            regs[ 8] <= 32'd0;
            regs[ 9] <= 32'd0;
            regs[10] <= 32'd0;
            regs[11] <= 32'd0;
            regs[12] <= 32'd0;
            regs[13] <= 32'd0;
            regs[14] <= 32'd0;
            regs[15] <= 32'd0;
            regs[16] <= 32'd0;
            regs[17] <= 32'd0;
            regs[18] <= 32'd0;
            regs[19] <= 32'd0;
            regs[20] <= 32'd0;
            regs[21] <= 32'd0;
            regs[22] <= 32'd0;
            regs[23] <= 32'd0;
            regs[24] <= 32'd0;
            regs[25] <= 32'd0;
            regs[26] <= 32'd0;
            regs[27] <= 32'd0;
            regs[28] <= 32'd0;
            regs[29] <= 32'd0;
            regs[30] <= 32'd0;
            regs[31] <= 32'd0;
        end else if (i_rd_wen && (i_rd_waddr != 5'd0)) begin
            regs[i_rd_waddr] <= i_rd_wdata;
        end
    end

endmodule


`default_nettype wire
