`timescale 1ns/1ps

module unit_writeback_tb;
    reg  [31:0] AluResult;
    reg  [31:0] LoadData;
    reg  [31:0] pc_plus4;
    reg  [31:0] Offset;
    reg         MemToReg;
    reg         lui;
    reg         Jump;
    wire [31:0] WriteData;

    writeback dut (
        .AluResult(AluResult),
        .LoadData (LoadData),
        .pc_plus4 (pc_plus4),
        .Offset   (Offset),
        .MemToReg (MemToReg),
        .lui      (lui),
        .Jump     (Jump),
        .WriteData(WriteData)
    );

    task check;
        input [31:0] exp;
        input [255:0] name;
        begin
            #1;
            if (WriteData !== exp) begin
                $display("FAIL %s: got=%h exp=%h", name, WriteData, exp);
                $finish;
            end
        end
    endtask

    initial begin
        AluResult = 32'h1111_1111;
        LoadData  = 32'h2222_2222;
        pc_plus4  = 32'h3333_3333;
        Offset    = 32'h4444_4444;

        // Jump has highest priority
        Jump = 1'b1; lui = 1'b1; MemToReg = 1'b1;
        check(32'h3333_3333, "jump_priority");

        // LUI next priority
        Jump = 1'b0; lui = 1'b1; MemToReg = 1'b1;
        check(32'h4444_4444, "lui_priority");

        // MemToReg next
        Jump = 1'b0; lui = 1'b0; MemToReg = 1'b1;
        check(32'h2222_2222, "memtoreg");

        // Default ALU
        Jump = 1'b0; lui = 1'b0; MemToReg = 1'b0;
        check(32'h1111_1111, "alu_default");

        $display("PASS unit_writeback_tb");
        $finish;
    end
endmodule
