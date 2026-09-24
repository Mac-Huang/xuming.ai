`timescale 1ns/1ps

module unit_rf_tb;
    reg clk;
    reg rst;

    reg  [4:0] rs1_addr;
    reg  [4:0] rs2_addr;
    reg        wen;
    reg  [4:0] waddr;
    reg  [31:0] wdata;

    wire [31:0] rs1_no_bypass;
    wire [31:0] rs2_no_bypass;
    wire [31:0] rs1_bypass;
    wire [31:0] rs2_bypass;

    rf #(.BYPASS_EN(0)) dut_no_bypass (
        .i_clk      (clk),
        .i_rst      (rst),
        .i_rs1_raddr(rs1_addr),
        .o_rs1_rdata(rs1_no_bypass),
        .i_rs2_raddr(rs2_addr),
        .o_rs2_rdata(rs2_no_bypass),
        .i_rd_wen   (wen),
        .i_rd_waddr (waddr),
        .i_rd_wdata (wdata)
    );

    rf #(.BYPASS_EN(1)) dut_bypass (
        .i_clk      (clk),
        .i_rst      (rst),
        .i_rs1_raddr(rs1_addr),
        .o_rs1_rdata(rs1_bypass),
        .i_rs2_raddr(rs2_addr),
        .o_rs2_rdata(rs2_bypass),
        .i_rd_wen   (wen),
        .i_rd_waddr (waddr),
        .i_rd_wdata (wdata)
    );

    task check;
        input [31:0] got;
        input [31:0] exp;
        input [255:0] name;
        begin
            #1;
            if (got !== exp) begin
                $display("FAIL %s: got=%h exp=%h", name, got, exp);
                $finish;
            end
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        wen = 0;
        waddr = 0;
        wdata = 0;
        rs1_addr = 0;
        rs2_addr = 0;

        // Reset clears regs
        #2;
        rs1_addr = 5'd1;
        rs2_addr = 5'd2;
        #0;
        check(rs1_no_bypass, 32'd0, "reset_rs1_no_bypass");
        #0;
        check(rs2_no_bypass, 32'd0, "reset_rs2_no_bypass");

        // Deassert reset
        @(negedge clk);
        rst = 0;

        // Write x1 = 0xA5A5A5A5
        waddr = 5'd1;
        wdata = 32'hA5A5_A5A5;
        wen   = 1'b1;
        rs1_addr = 5'd1;

        // Before clock edge: bypass sees new data, no-bypass sees old
        #0;
        check(rs1_bypass, 32'hA5A5_A5A5, "bypass_forward");
        #0;
        check(rs1_no_bypass, 32'h0000_0000, "no_bypass_hold");

        // After clock edge, both see written data
        @(posedge clk);
        #1;
        #0;
        check(rs1_no_bypass, 32'hA5A5_A5A5, "no_bypass_after_write");
        #0;
        check(rs1_bypass, 32'hA5A5_A5A5, "bypass_after_write");

        // Write x0 should be ignored
        waddr = 5'd0;
        wdata = 32'hDEAD_BEEF;
        wen   = 1'b1;
        rs1_addr = 5'd0;
        @(posedge clk);
        #1;
        #0;
        check(rs1_no_bypass, 32'h0000_0000, "x0_ignored_no_bypass");
        #0;
        check(rs1_bypass, 32'h0000_0000, "x0_ignored_bypass");

        $display("PASS unit_rf_tb");
        $finish;
    end

    always #5 clk = ~clk;
endmodule
