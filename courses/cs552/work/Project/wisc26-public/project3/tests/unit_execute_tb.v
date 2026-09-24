`timescale 1ns/1ps

module unit_execute_tb;
    reg  [2:0]  AluOp;
    reg  [2:0]  Func3;
    reg  [6:0]  Func7;
    reg  [6:0]  opcode;
    reg  [31:0] Operand1;
    reg  [31:0] Operand2;
    wire [31:0] AluResult;
    wire        ALUeq;
    wire        ALUslt;

    execute dut (
        .AluOp    (AluOp),
        .Func3    (Func3),
        .Func7    (Func7),
        .opcode   (opcode),
        .Operand1 (Operand1),
        .Operand2 (Operand2),
        .AluResult(AluResult),
        .ALUeq    (ALUeq),
        .ALUslt   (ALUslt)
    );

    task check;
        input [31:0] exp_result;
        input        exp_eq;
        input        exp_slt;
        input [255:0] name;
        begin
            #1;
            if (AluResult !== exp_result || ALUeq !== exp_eq || ALUslt !== exp_slt) begin
                $display("FAIL %s: result=%h exp=%h eq=%b exp=%b slt=%b exp=%b", name, AluResult, exp_result, ALUeq, exp_eq, ALUslt, exp_slt);
                $finish;
            end
        end
    endtask

    initial begin
        // R-type ADD
        AluOp = 3'b011; Func3 = 3'b000; Func7 = 7'b0000000; opcode = 7'b0110011;
        Operand1 = 32'd3; Operand2 = 32'd4;
        check(32'd7, 1'b0, 1'b1, "rtype_add");

        // R-type SUB
        AluOp = 3'b011; Func3 = 3'b000; Func7 = 7'b0100000; opcode = 7'b0110011;
        Operand1 = 32'd3; Operand2 = 32'd4;
        check(32'hFFFF_FFFF, 1'b0, 1'b1, "rtype_sub");

        // I-type SRLI
        AluOp = 3'b001; Func3 = 3'b101; Func7 = 7'b0000000; opcode = 7'b0010011;
        Operand1 = 32'h8000_0000; Operand2 = 32'd1;
        check(32'h4000_0000, 1'b0, 1'b1, "itype_srli");

        // I-type SRAI
        AluOp = 3'b001; Func3 = 3'b101; Func7 = 7'b0100000; opcode = 7'b0010011;
        Operand1 = 32'h8000_0000; Operand2 = 32'd1;
        check(32'hC000_0000, 1'b0, 1'b1, "itype_srai");

        // Branch BLTU: unsigned compare
        AluOp = 3'b110; Func3 = 3'b110; Func7 = 7'b0000000; opcode = 7'b1100011;
        Operand1 = 32'hFFFF_FFFF; Operand2 = 32'd1;
        check(32'hFFFF_FFFE, 1'b0, 1'b0, "branch_bltu");

        $display("PASS unit_execute_tb");
        $finish;
    end
endmodule
