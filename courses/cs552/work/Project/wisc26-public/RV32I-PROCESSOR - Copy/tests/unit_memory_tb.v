`timescale 1ns/1ps

module unit_memory_tb;
    reg  [31:0] EffAddr;
    reg  [31:0] StoreData;
    reg  [2:0]  Func3;
    reg         MemRead;
    reg         MemWrite;
    reg  [31:0] i_dmem_rdata;

    wire [31:0] o_dmem_addr;
    wire [3:0]  o_dmem_mask;
    wire [31:0] o_dmem_wdata;
    wire        o_dmem_ren;
    wire        o_dmem_wen;
    wire [31:0] LoadData;
    wire        MisalignTrap;

    dmem_access dut (
        .EffAddr     (EffAddr),
        .StoreData   (StoreData),
        .Func3       (Func3),
        .MemRead     (MemRead),
        .MemWrite    (MemWrite),
        .i_dmem_rdata(i_dmem_rdata),
        .o_dmem_addr (o_dmem_addr),
        .o_dmem_mask (o_dmem_mask),
        .o_dmem_wdata(o_dmem_wdata),
        .o_dmem_ren  (o_dmem_ren),
        .o_dmem_wen  (o_dmem_wen),
        .LoadData    (LoadData),
        .MisalignTrap(MisalignTrap)
    );

    task check;
        input [31:0] exp_load;
        input [3:0]  exp_mask;
        input [31:0] exp_wdata;
        input        exp_ren;
        input        exp_wen;
        input        exp_trap;
        input [255:0] name;
        begin
            #1;
            if (LoadData !== exp_load || o_dmem_mask !== exp_mask || o_dmem_wdata !== exp_wdata ||
                o_dmem_ren !== exp_ren || o_dmem_wen !== exp_wen || MisalignTrap !== exp_trap) begin
                $display("FAIL %s:", name);
                $display("  LoadData=%h exp=%h", LoadData, exp_load);
                $display("  mask=%b exp=%b", o_dmem_mask, exp_mask);
                $display("  wdata=%h exp=%h", o_dmem_wdata, exp_wdata);
                $display("  ren=%b exp=%b wen=%b exp=%b trap=%b exp=%b", o_dmem_ren, exp_ren, o_dmem_wen, exp_wen, MisalignTrap, exp_trap);
                $finish;
            end
        end
    endtask

    initial begin
        i_dmem_rdata = 32'h80FF_7F01;
        StoreData    = 32'hA1B2_C3D4;

        // LB offset 0
        EffAddr = 32'h0000_0000; Func3 = 3'b000; MemRead = 1'b1; MemWrite = 1'b0;
        check(32'h0000_0001, 4'b0001, 32'h0000_0000, 1'b1, 1'b0, 1'b0, "lb_off0");

        // LBU offset 1
        EffAddr = 32'h0000_0001; Func3 = 3'b100; MemRead = 1'b1; MemWrite = 1'b0;
        check(32'h0000_007F, 4'b0010, 32'h0000_0000, 1'b1, 1'b0, 1'b0, "lbu_off1");

        // LH offset 2 (aligned)
        EffAddr = 32'h0000_0002; Func3 = 3'b001; MemRead = 1'b1; MemWrite = 1'b0;
        check(32'hFFFF_80FF, 4'b1100, 32'h0000_0000, 1'b1, 1'b0, 1'b0, "lh_off2");

        // LHU offset 0
        EffAddr = 32'h0000_0000; Func3 = 3'b101; MemRead = 1'b1; MemWrite = 1'b0;
        check(32'h0000_7F01, 4'b0011, 32'h0000_0000, 1'b1, 1'b0, 1'b0, "lhu_off0");

        // LW offset 0
        EffAddr = 32'h0000_0000; Func3 = 3'b010; MemRead = 1'b1; MemWrite = 1'b0;
        check(32'h80FF_7F01, 4'b1111, 32'h0000_0000, 1'b1, 1'b0, 1'b0, "lw_off0");

        // Misaligned LW offset 2
        EffAddr = 32'h0000_0002; Func3 = 3'b010; MemRead = 1'b1; MemWrite = 1'b0;
        check(32'h0000_0000, 4'b1111, 32'h0000_0000, 1'b0, 1'b0, 1'b1, "lw_misaligned");

        // SB offset 3
        EffAddr = 32'h0000_0003; Func3 = 3'b000; MemRead = 1'b0; MemWrite = 1'b1;
        check(32'h0000_0000, 4'b1000, 32'hD4_000000, 1'b0, 1'b1, 1'b0, "sb_off3");

        // SH offset 2
        EffAddr = 32'h0000_0002; Func3 = 3'b001; MemRead = 1'b0; MemWrite = 1'b1;
        check(32'h0000_0000, 4'b1100, 32'hC3D4_0000, 1'b0, 1'b1, 1'b0, "sh_off2");

        // SW offset 0
        EffAddr = 32'h0000_0000; Func3 = 3'b010; MemRead = 1'b0; MemWrite = 1'b1;
        check(32'h0000_0000, 4'b1111, 32'hA1B2_C3D4, 1'b0, 1'b1, 1'b0, "sw_off0");

        // Misaligned SH offset 1
        EffAddr = 32'h0000_0001; Func3 = 3'b001; MemRead = 1'b0; MemWrite = 1'b1;
        check(32'h0000_0000, 4'b0011, 32'hA1B2_C3D4, 1'b0, 1'b0, 1'b1, "sh_misaligned");

        $display("PASS unit_memory_tb");
        $finish;
    end
endmodule
