`timescale 1ns/1ps

module unit_hart_tb;
    reg         clk;
    reg         rst;
    wire [31:0] imem_raddr;
    wire        imem_ren;
    wire        imem_ready;
    wire        imem_valid;
    wire [31:0] imem_rdata;
    wire [31:0] dmem_addr;
    wire        dmem_ready;
    wire        dmem_ren;
    wire        dmem_wen;
    wire        dmem_valid;
    wire [31:0] dmem_wdata;
    wire [3:0]  dmem_mask;
    wire [31:0] dmem_rdata;
    wire        dmem_rvalid;
    wire        dmem_wdone;

    wire        valid;
    wire        trap;
    wire        halt;
    wire [31:0] inst;
    wire [4:0]  rs1_raddr;
    wire [4:0]  rs2_raddr;
    wire [31:0] rs1_rdata;
    wire [31:0] rs2_rdata;
    wire [4:0]  rd_waddr;
    wire [31:0] rd_wdata;
    wire [31:0] pc;
    wire [31:0] next_pc;

    hart #(.RESET_ADDR(32'h0)) dut (
        .i_clk        (clk),
        .i_rst        (rst),
        .i_imem_ready (imem_ready),
        .o_imem_raddr (imem_raddr),
        .o_imem_ren   (imem_ren),
        .i_imem_valid (imem_valid),
        .i_imem_rdata (imem_rdata),
        .i_dmem_ready (dmem_ready),
        .o_dmem_addr  (dmem_addr),
        .o_dmem_ren   (dmem_ren),
        .o_dmem_wen   (dmem_wen),
        .o_dmem_wdata (dmem_wdata),
        .o_dmem_mask  (dmem_mask),
        .i_dmem_valid (dmem_valid),
        .i_dmem_rdata (dmem_rdata),
        .o_retire_valid     (valid),
        .o_retire_inst      (inst),
        .o_retire_trap      (trap),
        .o_retire_halt      (halt),
        .o_retire_rs1_raddr (rs1_raddr),
        .o_retire_rs1_rdata (rs1_rdata),
        .o_retire_rs2_raddr (rs2_raddr),
        .o_retire_rs2_rdata (rs2_rdata),
        .o_retire_rd_waddr  (rd_waddr),
        .o_retire_rd_wdata  (rd_wdata),
        .o_retire_pc        (pc),
        .o_retire_next_pc   (next_pc)
    );

    memory #(
        .SIZE     (256),
        .LATENCY  (4),
        .INTERVAL (2)
    ) u_imem (
        .i_clk   (clk),
        .i_rst   (rst),
        .o_ready (imem_ready),
        .i_addr  (imem_raddr),
        .i_ren   (imem_ren),
        .i_wen   (1'b0),
        .i_mask  (4'b1111),
        .i_wdata (32'd0),
        .o_valid (imem_valid),
        .o_addr  (),
        .o_wdone (),
        .o_rdata (imem_rdata)
    );

    memory #(
        .SIZE     (256),
        .LATENCY  (4),
        .INTERVAL (2)
    ) u_dmem (
        .i_clk   (clk),
        .i_rst   (rst),
        .o_ready (dmem_ready),
        .i_addr  (dmem_addr),
        .i_ren   (dmem_ren),
        .i_wen   (dmem_wen),
        .i_mask  (dmem_mask),
        .i_wdata (dmem_wdata),
        .o_valid (dmem_rvalid),
        .o_addr  (),
        .o_wdone (dmem_wdone),
        .o_rdata (dmem_rdata)
    );

    assign dmem_valid = dmem_rvalid;

    reg [31:0] regs [0:31];
    reg halted_seen;
    integer i;

    task write_inst;
        input [31:0] addr;
        input [31:0] word;
        begin
            u_imem.mem[addr + 0] = word[7:0];
            u_imem.mem[addr + 1] = word[15:8];
            u_imem.mem[addr + 2] = word[23:16];
            u_imem.mem[addr + 3] = word[31:24];
        end
    endtask

    // Architectural register scoreboard
    always @(posedge clk) begin
        if (valid && (rd_waddr != 5'd0)) begin
            regs[rd_waddr] <= rd_wdata;
        end
    end

    integer cycles;
    initial begin
        clk = 0;
        rst = 1;
        halted_seen = 1'b0;
        cycles = 0;
        for (i = 0; i < 256; i = i + 1) begin
            u_imem.mem[i] = 8'h00;
            u_dmem.mem[i] = 8'h00;
        end
        for (i = 0; i < 32; i = i + 1) begin
            regs[i] = 32'h0000_0000;
        end

        // Program
        write_inst(32'h0000_0000, 32'h0050_0093); // addi x1, x0, 5
        write_inst(32'h0000_0004, 32'h0070_8113); // addi x2, x1, 7
        write_inst(32'h0000_0008, 32'h0011_01B3); // add  x3, x2, x1
        write_inst(32'h0000_000C, 32'h0030_2023); // sw   x3, 0(x0)
        write_inst(32'h0000_0010, 32'h0000_2203); // lw   x4, 0(x0)
        write_inst(32'h0000_0014, 32'h0040_2223); // sw   x4, 4(x0)
        write_inst(32'h0000_0018, 32'h0040_2283); // lw   x5, 4(x0)
        write_inst(32'h0000_001C, 32'h0032_8463); // beq  x5, x3, +8
        write_inst(32'h0000_0020, 32'h0010_0313); // addi x6, x0, 1 (skipped)
        write_inst(32'h0000_0024, 32'h0010_0073); // ebreak

        // Reset
        @(negedge clk);
        rst = 1;
        @(negedge clk);
        rst = 0;

        // Run
        while ((cycles < 400) && !halted_seen) begin
            @(posedge clk);
            cycles = cycles + 1;
            if (valid && trap) begin
                $display("FAIL unit_hart_tb: trap asserted at pc=%h inst=%h", pc, inst);
                $finish;
            end
            if (halt) begin
                halted_seen = 1'b1;
            end
        end

        if (!halted_seen) begin
            $display("FAIL unit_hart_tb: program did not halt");
            $finish;
        end

        // Check results
        if (regs[3] !== 32'd17) begin
            $display("FAIL unit_hart_tb: x3=%h exp=00000011", regs[3]);
            $finish;
        end
        if (regs[4] !== 32'd17) begin
            $display("FAIL unit_hart_tb: x4=%h exp=00000011", regs[4]);
            $finish;
        end
        if (regs[5] !== 32'd17) begin
            $display("FAIL unit_hart_tb: x5=%h exp=00000011", regs[5]);
            $finish;
        end
        if (regs[6] !== 32'd0) begin
            $display("FAIL unit_hart_tb: x6=%h exp=00000000", regs[6]);
            $finish;
        end

        // Check memory at address 0
        if ({u_dmem.mem[3], u_dmem.mem[2], u_dmem.mem[1], u_dmem.mem[0]} !== 32'd17) begin
            $display("FAIL unit_hart_tb: mem[0]=%h exp=00000011", {u_dmem.mem[3], u_dmem.mem[2], u_dmem.mem[1], u_dmem.mem[0]});
            $finish;
        end
        if ({u_dmem.mem[7], u_dmem.mem[6], u_dmem.mem[5], u_dmem.mem[4]} !== 32'd17) begin
            $display("FAIL unit_hart_tb: mem[4]=%h exp=00000011", {u_dmem.mem[7], u_dmem.mem[6], u_dmem.mem[5], u_dmem.mem[4]});
            $finish;
        end

        $display("PASS unit_hart_tb cycles=%0d", cycles);
        $finish;
    end

    always #5 clk = ~clk;
endmodule
