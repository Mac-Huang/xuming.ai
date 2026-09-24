module imm_tb;
    logic [31:0] i_inst;
    logic [ 5:0] i_format;
    wire [31:0] o_immediate;

    reg  [31:0] exp;

    imm imm_test (
        .i_inst      (i_inst),
        .i_format    (i_format),
        .o_immediate (o_immediate)
    );

    // -----------------------------
    // Golden immediate extractors
    // -----------------------------
    function automatic logic [31:0] gold_I(input logic [31:0] inst);
        return {{20{inst[31]}}, inst[31:20]};
    endfunction

    function automatic logic [31:0] gold_S(input logic [31:0] inst);
        return {{20{inst[31]}}, inst[31:25], inst[11:7]};
    endfunction

    function automatic logic [31:0] gold_B(input logic [31:0] inst);
        // imm[12|10:5|4:1|11|0]
        return {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
    endfunction

    function automatic logic [31:0] gold_U(input logic [31:0] inst);
        return {inst[31:12], 12'b0};
    endfunction

    function automatic logic [31:0] gold_J(input logic [31:0] inst);
        // imm[20|10:1|11|19:12|0]
        return {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
    endfunction

    // -----------------------------
    // Instruction "encoders"
    // These place immediate bits into the instruction fields.
    // (Other bits are don't-care for this module; set to 0.)
    // -----------------------------
    function automatic logic [31:0] enc_I(input logic signed [31:0] imm);
        logic [31:0] inst;
        inst = 32'b0;
        inst[31:20] = imm[11:0];
        return inst;
    endfunction

    function automatic logic [31:0] enc_S(input logic signed [31:0] imm);
        logic [31:0] inst;
        inst = 32'b0;
        inst[31:25] = imm[11:5];
        inst[11:7]  = imm[4:0];
        return inst;
    endfunction

    function automatic logic [31:0] enc_B(input logic signed [31:0] imm);
        // B-immediate is 13 bits and must be even (bit0=0). We'll assume imm already obeys that.
        logic [31:0] inst;
        inst = 32'b0;
        inst[31]    = imm[12];
        inst[7]     = imm[11];
        inst[30:25] = imm[10:5];
        inst[11:8]  = imm[4:1];
        // inst[0] is not used for imm (imm[0] is implicit 0)
        return inst;
    endfunction

    function automatic logic [31:0] enc_U(input logic signed [31:0] imm);
        // U-immediate is upper 20 bits; lower 12 bits are zero in the resulting immediate.
        logic [31:0] inst;
        inst = 32'b0;
        inst[31:12] = imm[31:12];
        return inst;
    endfunction

    function automatic logic [31:0] enc_J(input logic signed [31:0] imm);
        // J-immediate is 21 bits and must be even (bit0=0). We'll assume imm already obeys that.
        logic [31:0] inst;
        inst = 32'b0;
        inst[31]    = imm[20];
        inst[19:12] = imm[19:12];
        inst[20]    = imm[11];
        inst[30:21] = imm[10:1];
        return inst;
    endfunction

    // -----------------------------
    // One checker task to reduce copy/paste bugs
    // -----------------------------
    task automatic check_case(
        input string name,
        input logic [5:0] fmt,
        input logic [31:0] inst,
        input logic [31:0] exp
    );
        i_format = fmt;
        i_inst   = inst;
        #1;
        assert (o_immediate === exp)
        else $fatal("%s mismatch: got=%h exp=%h inst=%h fmt=%b",
                    name, o_immediate, exp, i_inst, i_format);
        #1;
    endtask

    initial begin
        $dumpfile("imm.vcd");
        $dumpvars(0, imm_tb);

        // -----------------------------
        // I-type tests (12-bit signed)
        // -----------------------------
        check_case("I imm=0",     6'b000010, enc_I(32'sd0),        32'sd0);
        check_case("I imm=+1",    6'b000010, enc_I(32'sd1),        32'sd1);
        check_case("I imm=-1",    6'b000010, enc_I(-32'sd1),      -32'sd1);
        check_case("I imm=max",   6'b000010, enc_I(32'sd2047),     32'sd2047);   // 0x7FF
        check_case("I imm=min",   6'b000010, enc_I(-32'sd2048),   -32'sd2048);  // 0x800
        check_case("I imm=0x123", 6'b000010, enc_I(32'sh123),      32'sh123);

        // Also verify your golden extractor matches the encoder round-trip
        check_case("I gold",      6'b000010, enc_I(-32'sd17),      gold_I(enc_I(-32'sd17)));

        // -----------------------------
        // S-type tests (12-bit signed)
        // -----------------------------
        check_case("S imm=0",     6'b000100, enc_S(32'sd0),        32'sd0);
        check_case("S imm=+1",    6'b000100, enc_S(32'sd1),        32'sd1);
        check_case("S imm=-1",    6'b000100, enc_S(-32'sd1),      -32'sd1);
        check_case("S imm=max",   6'b000100, enc_S(32'sd2047),     32'sd2047);
        check_case("S imm=min",   6'b000100, enc_S(-32'sd2048),   -32'sd2048);
        check_case("S imm=0x2A5", 6'b000100, enc_S(32'sh2A5),      32'sh2A5);
        check_case("S gold",      6'b000100, enc_S(-32'sd33),      gold_S(enc_S(-32'sd33)));

        // -----------------------------
        // B-type tests (13-bit signed, even)
        // -----------------------------
        check_case("B imm=0",      6'b001000, enc_B(32'sd0),         32'sd0);
        check_case("B imm=+2",     6'b001000, enc_B(32'sd2),         32'sd2);
        check_case("B imm=-2",     6'b001000, enc_B(-32'sd2),       -32'sd2);
        check_case("B imm=max",    6'b001000, enc_B(32'sd4094),      32'sd4094);   // 0x0FFE
        check_case("B imm=min",    6'b001000, enc_B(-32'sd4096),    -32'sd4096);  // 0x1000 in 13-bit signed
        check_case("B imm=0x2AA",  6'b001000, enc_B(32'sh2AA),       32'sh2AA);
        check_case("B gold",       6'b001000, enc_B(-32'sd18),       gold_B(enc_B(-32'sd18)));

        // -----------------------------
        // U-type tests (upper 20 bits)
        // -----------------------------
        check_case("U imm=0",         6'b010000, enc_U(32'h0000_0000), 32'h0000_0000);
        check_case("U imm=0x12345000",6'b010000, enc_U(32'h1234_5000), 32'h1234_5000);
        check_case("U imm=0xFFFFF000",6'b010000, enc_U(32'hFFFF_F000), 32'hFFFF_F000);
        check_case("U gold",          6'b010000, (32'hABCDEFFF),       gold_U(32'hABCDEFFF)); // note: lower 12 ignored in gold_U

        // -----------------------------
        // J-type tests (21-bit signed, even)
        // -----------------------------
        check_case("J imm=0",       6'b100000, enc_J(32'sd0),          32'sd0);
        check_case("J imm=+2",      6'b100000, enc_J(32'sd2),          32'sd2);
        check_case("J imm=-2",      6'b100000, enc_J(-32'sd2),        -32'sd2);
        check_case("J imm=max",     6'b100000, enc_J(32'sd1048574),    32'sd1048574);   // 0x0FFFFE
        check_case("J imm=min",     6'b100000, enc_J(-32'sd1048576),  -32'sd1048576);  // 0x100000 in 21-bit signed
        check_case("J imm=0x15554", 6'b100000, enc_J(32'sh15554),      32'sh15554);
        check_case("J gold",        6'b100000, enc_J(-32'sd222),       gold_J(enc_J(-32'sd222)));

        $display("All tests passed.");
        $finish;
    end
endmodule