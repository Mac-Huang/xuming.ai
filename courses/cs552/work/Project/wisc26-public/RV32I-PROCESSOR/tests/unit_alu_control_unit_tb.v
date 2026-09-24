`timescale 1ns/1ps

module unit_alu_control_unit_tb;
    reg  [2:0] AluOp;
    reg  [2:0] Func3;
    reg  [6:0] Func7;
    reg  [6:0] opcode;
    wire [2:0] opsel;
    wire       sub;
    wire       uns;
    wire       arith;

    alu_control_unit dut (
        .AluOp              (AluOp),
        .Func3              (Func3),
        .Func7              (Func7),
        .opcode             (opcode),
        .AluControl_opsel   (opsel),
        .AluControl_sub     (sub),
        .AluControl_unsigned(uns),
        .AluControl_arith   (arith)
    );

    task check;
        input [2:0] exp_opsel;
        input       exp_sub;
        input       exp_uns;
        input       exp_arith;
        input [255:0] name;
        begin
            #1;
            if (opsel !== exp_opsel || sub !== exp_sub || uns !== exp_uns || arith !== exp_arith) begin
                $display("FAIL %s: opsel=%b exp=%b sub=%b exp=%b uns=%b exp=%b arith=%b exp=%b",
                         name, opsel, exp_opsel, sub, exp_sub, uns, exp_uns, arith, exp_arith);
                $finish;
            end
        end
    endtask

    initial begin
        // R-type ADD
        AluOp = 3'b011; Func3 = 3'b000; Func7 = 7'b0000000; opcode = 7'b0110011;
        check(3'b000, 1'b0, 1'b0, 1'b0, "rtype_add");

        // R-type SUB
        AluOp = 3'b011; Func3 = 3'b000; Func7 = 7'b0100000; opcode = 7'b0110011;
        check(3'b000, 1'b1, 1'b0, 1'b0, "rtype_sub");

        // R-type SRA
        AluOp = 3'b011; Func3 = 3'b101; Func7 = 7'b0100000; opcode = 7'b0110011;
        check(3'b101, 1'b0, 1'b0, 1'b1, "rtype_sra");

        // I-type ADDI with imm[11:5] having bit5=1 should NOT force sub
        AluOp = 3'b001; Func3 = 3'b000; Func7 = 7'b0100000; opcode = 7'b0010011;
        check(3'b000, 1'b0, 1'b0, 1'b0, "itype_addi_no_sub");

        // I-type SLTIU
        AluOp = 3'b001; Func3 = 3'b011; Func7 = 7'b0000000; opcode = 7'b0010011;
        check(3'b011, 1'b0, 1'b1, 1'b0, "itype_sltiu");

        // Load
        AluOp = 3'b000; Func3 = 3'b010; Func7 = 7'b0000000; opcode = 7'b0000011;
        check(3'b000, 1'b0, 1'b0, 1'b0, "load");

        // Store
        AluOp = 3'b010; Func3 = 3'b010; Func7 = 7'b0000000; opcode = 7'b0100011;
        check(3'b000, 1'b0, 1'b0, 1'b0, "store");

        // Branch BEQ
        AluOp = 3'b110; Func3 = 3'b000; Func7 = 7'b0000000; opcode = 7'b1100011;
        check(3'b000, 1'b1, 1'b0, 1'b0, "branch_beq");

        // Branch BLTU
        AluOp = 3'b110; Func3 = 3'b110; Func7 = 7'b0000000; opcode = 7'b1100011;
        check(3'b000, 1'b1, 1'b1, 1'b0, "branch_bltu");

        $display("PASS unit_alu_control_unit_tb");
        $finish;
    end
endmodule
