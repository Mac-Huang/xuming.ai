`timescale 1ns / 1ps
module hart_tb #(
    parameter DEBUG = 0
) ();
    // Synchronous active-high reset.
    reg         clk, rst;
    // Instruction memory interface.
    wire  [31:0] imem_rdata, dmem_rdata;
    wire [31:0] imem_raddr, dmem_addr;
    // Data memory interface.
    wire        dmem_ren, dmem_wen;
    wire [31:0] dmem_wdata;
    wire [ 3:0] dmem_mask;

    // Instruction retire interface.
    wire        valid, trap, halt;
    wire [31:0] inst;
    wire [ 4:0] rs1_raddr, rs2_raddr;
    wire [31:0] rs1_rdata, rs2_rdata;
    wire [ 4:0] rd_waddr;
    wire [31:0] rd_wdata;
    wire [31:0] pc, next_pc;
    wire [31:0] retire_dmem_addr;
    wire        retire_dmem_ren, retire_dmem_wen;
    wire [ 3:0] retire_dmem_mask;
    wire [31:0] retire_dmem_rdata;
    wire [31:0] retire_dmem_wdata;

    // Instruction memory.
    wire imem_ready, imem_ren, imem_valid;
    memory #(
        .SIZE(1024),
        .LATENCY(4),
        .INTERVAL(2)
    ) imem (
        .i_clk(clk),
        .i_rst(rst),
        .o_ready(imem_ready),
        .i_addr(imem_raddr),
        .i_ren(imem_ren),
        .i_wen(1'b0),
        .i_mask(4'b1111),
        .i_wdata(32'hxxxxxxxx),
        .o_valid(imem_valid),
        .o_rdata(imem_rdata)
    );

    // Data memory.
    wire dmem_ready, dmem_valid;
    memory #(
        .SIZE(1024),
        .LATENCY(4),
        .INTERVAL(2)
    ) dmem (
        .i_clk(clk),
        .i_rst(rst),
        .o_ready(dmem_ready),
        .i_addr(dmem_addr),
        .i_ren(dmem_ren),
        .i_wen(dmem_wen),
        .i_mask(dmem_mask),
        .i_wdata(dmem_wdata),
        .o_valid(dmem_valid),
        .o_rdata(dmem_rdata)
    );

    hart #(
        .RESET_ADDR (32'h0)
    ) dut (
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
        .o_retire_dmem_addr (retire_dmem_addr),
        .o_retire_dmem_ren  (retire_dmem_ren),
        .o_retire_dmem_wen  (retire_dmem_wen),
        .o_retire_dmem_mask (retire_dmem_mask),
        .o_retire_dmem_wdata(retire_dmem_wdata),
        .o_retire_dmem_rdata(retire_dmem_rdata),
        .o_retire_pc        (pc),
        .o_retire_next_pc   (next_pc)
    );

    integer cycles, run;
    integer num_instructions;
    initial begin
        clk = 1;
        rst = 0;

        // Open the waveform file.
        if (DEBUG) begin
            $dumpfile("hart.vcd");
            $dumpvars(0, hart_tb);
        end

        // Load the test program into memory at address 0.
        $display("Loading program.");
        $readmemh("program.mem", imem.mem);

        // Reset the dut.
        $display("Resetting hart.");
        @(negedge clk); rst = 1;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk); rst = 0;

        $display("%-10s %-8s %-14s %-14s %s", "PC", "Inst", "rs1", "rs2", "[rd, load, store]");
        cycles = 0;
        run = 1;
        num_instructions = 0;
        while (run) begin
            @(posedge clk);
            cycles = cycles + 1;

            if (valid) begin
                num_instructions = num_instructions + 1;

                // Base information for all instructions.
                if (inst[3:0] == 4'b0111 || inst[6:0] == 7'b111_0011 || inst[6:0] == 7'b110_1111)
                    $write("[%08h] %08h r[--]=-------- r[--]=--------", pc, inst);
                else if (inst[6:0] == 7'b001_0011 || inst[6:0] == 7'b000_0011 ||
                          inst[6:0] == 7'b110_0111)
                    $write("[%08h] %08h r[%d]=%08h r[--]=--------", pc, inst, rs1_raddr, rs1_rdata);
                else
                    $write("[%08h] %08h r[%d]=%08h r[%d]=%08h", pc, inst, rs1_raddr, rs1_rdata, rs2_raddr, rs2_rdata);

                // Only display write information for instructions that write.
                if (rd_waddr != 5'd0)
                    $write(" w[%d]=%08h", rd_waddr, rd_wdata);
                // Only display memory information for load/store instructions.
                if (retire_dmem_ren) begin
                    $write(" l[%08h,%04b]=", retire_dmem_addr, retire_dmem_mask);
                    if (retire_dmem_mask[3])
                        $write("%02h", retire_dmem_rdata[31:24]);
                    else
                        $write("--");
                    if (retire_dmem_mask[2])
                        $write("%02h", retire_dmem_rdata[23:16]);
                    else
                        $write("--");
                    if (retire_dmem_mask[1])
                        $write("%02h", retire_dmem_rdata[15: 8]);
                    else
                        $write("--");
                    if (retire_dmem_mask[0])
                        $write("%02h", retire_dmem_rdata[ 7: 0]);
                    else
                        $write("--");
                end
                if (retire_dmem_wen)
                    $write(" s[%08h,%04b]=%08h", retire_dmem_addr, retire_dmem_mask, retire_dmem_wdata);
                // Display trap information if a trap occurred.
                if (trap)
                    $write(" TRAP");
                $display();

                if (halt)
                    run = 0;
            end

            if (cycles > 40000) begin
                $display("Program did not halt after 40000 cycles, aborting.");
                run = 0;
            end
        end

        $display("Program halted after %d cycles.", cycles);
        $display("Total instructions retired: %d", num_instructions);
        if (num_instructions == 0)
            $display("CPI: invalid (no instructions retired)");
        else
            $display("CPI: %f", cycles / (1.0 * num_instructions));
        $finish;
    end

    integer watchdog;
    initial begin
        for (watchdog = 0; watchdog < 40000; watchdog = watchdog + 1) begin
            @(posedge clk);
        end

        $finish;
    end

    always
        #5 clk = ~clk;
endmodule
