`timescale 1ns/1ps

module unit_decode_tb;
    reg clk;
    reg rst;
    reg [31:0] Inst;
    reg [31:0] WriteData;
    reg [4:0]  WriteAddr;
    reg        WriteEn;

    wire        lui;
    wire        PcSrc;
    wire [2:0]  AluOp;
    wire        MemWrite;
    wire        MemRead;
    wire        MemToReg;
    wire        AluSrc1;
    wire        AluSrc2;
    wire        RegWrite;
    wire        Jump;
    wire        Branch;
    wire [31:0] Offset;
    wire [4:0]  rs1_addr;
    wire [4:0]  rs2_addr;
    wire [4:0]  rd_addr;
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire        IllegalInst;
    wire        EBreak;

    decode dut (
        .i_clk            (clk),
        .i_rst            (rst),
        .Inst             (Inst),
        .WriteData        (WriteData),
        .WriteAddr        (WriteAddr),
        .WriteEn          (WriteEn),
        .lui              (lui),
        .PcSrc            (PcSrc),
        .AluOp            (AluOp),
        .MemWrite         (MemWrite),
        .MemRead          (MemRead),
        .MemToReg         (MemToReg),
        .AluSrc1          (AluSrc1),
        .AluSrc2          (AluSrc2),
        .RegWrite         (RegWrite),
        .Jump             (Jump),
        .Branch           (Branch),
        .Offset           (Offset),
        .o_retire_rs1_raddr(rs1_addr),
        .o_retire_rs2_raddr(rs2_addr),
        .o_retire_rd_waddr (rd_addr),
        .o_retire_rs1_rdata(rs1_data),
        .o_retire_rs2_rdata(rs2_data),
        .IllegalInst      (IllegalInst),
        .EBreak           (EBreak)
    );

    task check_basic;
        input        exp_lui;
        input        exp_pcsrc;
        input [2:0]  exp_aluop;
        input        exp_memwrite;
        input        exp_memread;
        input        exp_memtoreg;
        input        exp_alusrc1;
        input        exp_alusrc2;
        input        exp_regwrite;
        input        exp_jump;
        input        exp_branch;
        input [255:0] name;
        reg fail;
        begin
            #1;
            fail = 1'b0;
            if (exp_lui !== 1'bx && lui !== exp_lui) fail = 1'b1;
            if (exp_pcsrc !== 1'bx && PcSrc !== exp_pcsrc) fail = 1'b1;
            if (exp_aluop !== 3'bxxx && AluOp !== exp_aluop) fail = 1'b1;
            if (exp_memwrite !== 1'bx && MemWrite !== exp_memwrite) fail = 1'b1;
            if (exp_memread !== 1'bx && MemRead !== exp_memread) fail = 1'b1;
            if (exp_memtoreg !== 1'bx && MemToReg !== exp_memtoreg) fail = 1'b1;
            if (exp_alusrc1 !== 1'bx && AluSrc1 !== exp_alusrc1) fail = 1'b1;
            if (exp_alusrc2 !== 1'bx && AluSrc2 !== exp_alusrc2) fail = 1'b1;
            if (exp_regwrite !== 1'bx && RegWrite !== exp_regwrite) fail = 1'b1;
            if (exp_jump !== 1'bx && Jump !== exp_jump) fail = 1'b1;
            if (exp_branch !== 1'bx && Branch !== exp_branch) fail = 1'b1;

            if (fail) begin
                $display("FAIL %s control", name);
                $display("  lui=%b pcsrc=%b aluop=%b memw=%b memr=%b memtoreg=%b alusrc1=%b alusrc2=%b regw=%b jump=%b branch=%b",
                         lui, PcSrc, AluOp, MemWrite, MemRead, MemToReg, AluSrc1, AluSrc2, RegWrite, Jump, Branch);
                $finish;
            end
        end
    endtask

    task check_regs;
        input [4:0] exp_rs1;
        input [4:0] exp_rs2;
        input [4:0] exp_rd;
        input [31:0] exp_rs1_data;
        input [31:0] exp_rs2_data;
        input [255:0] name;
        begin
            #1;
            if (rs1_addr !== exp_rs1 || rs2_addr !== exp_rs2 || rd_addr !== exp_rd ||
                rs1_data !== exp_rs1_data || rs2_data !== exp_rs2_data) begin
                $display("FAIL %s regs", name);
                $display("  rs1=%d exp=%d rs2=%d exp=%d rd=%d exp=%d", rs1_addr, exp_rs1, rs2_addr, exp_rs2, rd_addr, exp_rd);
                $display("  rs1_data=%h exp=%h rs2_data=%h exp=%h", rs1_data, exp_rs1_data, rs2_data, exp_rs2_data);
                $finish;
            end
        end
    endtask

    task check_misc;
        input [31:0] exp_offset;
        input        exp_illegal;
        input        exp_ebreak;
        input [255:0] name;
        reg fail;
        begin
            #1;
            fail = 1'b0;
            if (exp_offset !== 32'hxxxx_xxxx && Offset !== exp_offset) fail = 1'b1;
            if (IllegalInst !== exp_illegal) fail = 1'b1;
            if (EBreak !== exp_ebreak) fail = 1'b1;
            if (fail) begin
                $display("FAIL %s misc", name);
                $display("  offset=%h exp=%h illegal=%b exp=%b ebreak=%b exp=%b", Offset, exp_offset, IllegalInst, exp_illegal, EBreak, exp_ebreak);
                $finish;
            end
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        Inst = 32'b0;
        WriteData = 32'b0;
        WriteAddr = 5'b0;
        WriteEn = 1'b0;

        // Reset
        @(posedge clk);
        rst = 0;

        // Initialize x1 and x2
        WriteAddr = 5'd1; WriteData = 32'h1111_1111; WriteEn = 1'b1;
        @(posedge clk);
        WriteAddr = 5'd2; WriteData = 32'h2222_2222; WriteEn = 1'b1;
        @(posedge clk);
        #1;
        WriteEn = 1'b0;

        // R-type ADD x3, x1, x2
        Inst = {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011};
        check_basic(1'b0, 1'b0, 3'b011, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, "rtype_add");
        check_regs(5'd1, 5'd2, 5'd3, 32'h1111_1111, 32'h2222_2222, "rtype_add");
        check_misc(32'hxxxx_xxxx, 1'b0, 1'b0, "rtype_add");

        // I-type ADDI x4, x1, 0x10
        Inst = {12'h010, 5'd1, 3'b000, 5'd4, 7'b0010011};
        check_basic(1'b0, 1'b0, 3'b001, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, "itype_addi");
        check_regs(5'd1, 5'd0, 5'd4, 32'h1111_1111, 32'h0000_0000, "itype_addi");
        check_misc(32'h0000_0010, 1'b0, 1'b0, "itype_addi");

        // Load LW x5, 4(x1)
        Inst = {12'h004, 5'd1, 3'b010, 5'd5, 7'b0000011};
        check_basic(1'b0, 1'b0, 3'b000, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, "load_lw");
        check_regs(5'd1, 5'd0, 5'd5, 32'h1111_1111, 32'h0000_0000, "load_lw");
        check_misc(32'h0000_0004, 1'b0, 1'b0, "load_lw");

        // Store SW x2, 8(x1)
        Inst = {7'b0000000, 5'd2, 5'd1, 3'b010, 5'd8, 7'b0100011};
        check_basic(1'b0, 1'b0, 3'b010, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, "store_sw");
        check_regs(5'd1, 5'd2, 5'd0, 32'h1111_1111, 32'h2222_2222, "store_sw");
        check_misc(32'h0000_0008, 1'b0, 1'b0, "store_sw");

        // Branch BEQ x1, x2, +0x10
        Inst = {1'b0, 6'b000000, 5'd2, 5'd1, 3'b000, 4'b1000, 1'b0, 7'b1100011};
        check_basic(1'b0, 1'b0, 3'b110, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, "branch_beq");
        check_regs(5'd1, 5'd2, 5'd0, 32'h1111_1111, 32'h2222_2222, "branch_beq");
        check_misc(32'h0000_0010, 1'b0, 1'b0, "branch_beq");

        // LUI x6, 0x12345
        Inst = {20'h12345, 5'd6, 7'b0110111};
        check_basic(1'b1, 1'b0, 3'b011, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, "lui");
        check_regs(5'd0, 5'd0, 5'd6, 32'h0000_0000, 32'h0000_0000, "lui");
        check_misc(32'h1234_5000, 1'b0, 1'b0, "lui");

        // AUIPC x7, 0x00012
        Inst = {20'h00012, 5'd7, 7'b0010111};
        check_basic(1'b0, 1'b0, 3'b001, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, "auipc");
        check_regs(5'd0, 5'd0, 5'd7, 32'h0000_0000, 32'h0000_0000, "auipc");
        check_misc(32'h0001_2000, 1'b0, 1'b0, "auipc");

        // JAL x1, +0x20
        Inst = {1'b0, 10'b0000010000, 1'b0, 8'b00000000, 5'd1, 7'b1101111};
        check_basic(1'b0, 1'b0, 3'b110, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx, 1'b1, 1'b1, 1'b0, "jal");
        check_regs(5'd0, 5'd0, 5'd1, 32'h0000_0000, 32'h0000_0000, "jal");
        check_misc(32'h0000_0020, 1'b0, 1'b0, "jal");

        // JALR x1, 4(x1)
        Inst = {12'h004, 5'd1, 3'b000, 5'd1, 7'b1100111};
        check_basic(1'b0, 1'b1, 3'b110, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, "jalr");
        check_regs(5'd1, 5'd0, 5'd1, 32'h1111_1111, 32'h0000_0000, "jalr");
        check_misc(32'h0000_0004, 1'b0, 1'b0, "jalr");

        // EBREAK
        Inst = 32'h0010_0073;
        check_basic(1'b0, 1'b0, 3'b111, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, "ebreak");
        check_regs(5'd0, 5'd0, 5'd0, 32'h0000_0000, 32'h0000_0000, "ebreak");
        check_misc(32'h0000_0000, 1'b0, 1'b1, "ebreak");

        $display("PASS unit_decode_tb");
        $finish;
    end

    always #5 clk = ~clk;
endmodule
