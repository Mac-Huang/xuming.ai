`timescale 1ns/1ps

module unit_imm_tb;
    reg  [31:0] inst;
    reg  [5:0]  fmt;
    wire [31:0] imm_out;

    imm dut (
        .i_inst     (inst),
        .i_format   (fmt),
        .o_immediate(imm_out)
    );

    task check;
        input [31:0] exp;
        input [255:0] name;
        begin
            #1;
            if (imm_out !== exp) begin
                $display("FAIL %s: imm=%h exp=%h", name, imm_out, exp);
                $finish;
            end
        end
    endtask

    reg [11:0] imm12;
    reg [12:0] imm13;
    reg [20:0] imm21;

    initial begin
        // I-type immediate (positive)
        imm12 = 12'h7A5; // +1957
        inst = {imm12, 20'b0};
        fmt  = 6'b000010; // I-type
        check(32'h0000_07A5, "i_pos");

        // I-type immediate (negative)
        imm12 = 12'hF80; // -128
        inst = {imm12, 20'b0};
        fmt  = 6'b000010;
        check(32'hFFFF_FF80, "i_neg");

        // S-type immediate (positive)
        imm12 = 12'h123;
        inst = {imm12[11:5], 5'b0, 5'b0, 3'b000, imm12[4:0], 7'b0};
        fmt  = 6'b000100; // S-type
        check(32'h0000_0123, "s_pos");

        // S-type immediate (negative)
        imm12 = 12'hF50; // -176
        inst = {imm12[11:5], 5'b0, 5'b0, 3'b000, imm12[4:0], 7'b0};
        fmt  = 6'b000100;
        check(32'hFFFF_FF50, "s_neg");

        // B-type immediate (positive, +8)
        imm13 = 13'h0008; // 8
        inst = {imm13[12], imm13[10:5], 5'b0, 5'b0, 3'b000, imm13[4:1], imm13[11], 7'b0};
        fmt  = 6'b001000; // B-type
        check(32'h0000_0008, "b_pos");

        // B-type immediate (negative, -4)
        imm13 = 13'h1FFC; // -4
        inst = {imm13[12], imm13[10:5], 5'b0, 5'b0, 3'b000, imm13[4:1], imm13[11], 7'b0};
        fmt  = 6'b001000;
        check(32'hFFFF_FFFC, "b_neg");

        // U-type immediate
        inst = {20'hABCDE, 12'b0};
        fmt  = 6'b010000;
        check(32'hABCDE000, "u_type");

        // J-type immediate (positive, +0x100)
        imm21 = 21'h00100; // 256
        inst = {imm21[20], imm21[10:1], imm21[11], imm21[19:12], 5'b0, 7'b1101111};
        fmt  = 6'b100000;
        check(32'h0000_0100, "j_pos");

        // J-type immediate (negative, -2)
        imm21 = 21'h1FFFFE; // -2 (LSB zero)
        inst = {imm21[20], imm21[10:1], imm21[11], imm21[19:12], 5'b0, 7'b1101111};
        fmt  = 6'b100000;
        check(32'hFFFF_FFFE, "j_neg");

        $display("PASS unit_imm_tb");
        $finish;
    end
endmodule
