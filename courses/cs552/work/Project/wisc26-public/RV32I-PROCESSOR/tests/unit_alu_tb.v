`timescale 1ns/1ps

module unit_alu_tb;
    reg  [2:0]  op;
    reg         sub;
    reg         uns;
    reg         arith;
    reg  [31:0] op1;
    reg  [31:0] op2;
    wire [31:0] result;
    wire        eq;
    wire        slt;

    alu dut (
        .i_opsel   (op),
        .i_sub     (sub),
        .i_unsigned(uns),
        .i_arith   (arith),
        .i_op1     (op1),
        .i_op2     (op2),
        .o_result  (result),
        .o_eq      (eq),
        .o_slt     (slt)
    );

    task check;
        input [31:0] exp_result;
        input        exp_eq;
        input        exp_slt;
        input [255:0] name;
        begin
            #1;
            if (result !== exp_result || eq !== exp_eq || slt !== exp_slt) begin
                $display("FAIL %s: result=%h exp=%h eq=%b exp=%b slt=%b exp=%b", name, result, exp_result, eq, exp_eq, slt, exp_slt);
                $finish;
            end
        end
    endtask

    initial begin
        // ADD
        op = 3'b000; sub = 1'b0; uns = 1'b0; arith = 1'b0; op1 = 32'd5; op2 = 32'd3;
        check(32'd8, 1'b0, 1'b0, "add");

        // SUB
        op = 3'b000; sub = 1'b1; uns = 1'b0; arith = 1'b0; op1 = 32'd5; op2 = 32'd7;
        check(32'hFFFF_FFFE, 1'b0, 1'b1, "sub");

        // SLL
        op = 3'b001; sub = 1'b0; uns = 1'b0; arith = 1'b0; op1 = 32'h1; op2 = 32'd4;
        check(32'h0000_0010, 1'b0, 1'b1, "sll");

        // SLT signed
        op = 3'b010; sub = 1'b0; uns = 1'b0; arith = 1'b0; op1 = 32'hFFFF_FFFF; op2 = 32'd1;
        check(32'h0000_0001, 1'b0, 1'b1, "slt_signed");

        // SLT unsigned
        op = 3'b010; sub = 1'b0; uns = 1'b1; arith = 1'b0; op1 = 32'hFFFF_FFFF; op2 = 32'd1;
        check(32'h0000_0000, 1'b0, 1'b0, "slt_unsigned");

        // XOR
        op = 3'b100; sub = 1'b0; uns = 1'b0; arith = 1'b0; op1 = 32'h00AA_F0F0; op2 = 32'h0F0F_0F0F;
        check(32'h0FA5_FFFF, 1'b0, 1'b1, "xor");

        // SRL
        op = 3'b101; sub = 1'b0; uns = 1'b0; arith = 1'b0; op1 = 32'h8000_0000; op2 = 32'd1;
        check(32'h4000_0000, 1'b0, 1'b1, "srl");

        // SRA
        op = 3'b101; sub = 1'b0; uns = 1'b0; arith = 1'b1; op1 = 32'h8000_0000; op2 = 32'd1;
        check(32'hC000_0000, 1'b0, 1'b1, "sra");

        // OR
        op = 3'b110; sub = 1'b0; uns = 1'b0; arith = 1'b0; op1 = 32'h0F0F_0000; op2 = 32'h00FF_00FF;
        check(32'h0FFF_00FF, 1'b0, 1'b0, "or");

        // AND
        op = 3'b111; sub = 1'b0; uns = 1'b0; arith = 1'b0; op1 = 32'h0F0F_0000; op2 = 32'h00FF_00FF;
        check(32'h000F_0000, 1'b0, 1'b0, "and");

        // EQ
        op = 3'b000; sub = 1'b0; uns = 1'b0; arith = 1'b0; op1 = 32'h1234; op2 = 32'h1234;
        check(32'h0000_2468, 1'b1, 1'b0, "eq");

        $display("PASS unit_alu_tb");
        $finish;
    end
endmodule
