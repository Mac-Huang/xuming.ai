`default_nettype none

// The immediate generator is responsible for decoding the 32-bit sign-extended
// immediate from the incoming instruction word. It is a purely combinational
// block that is expected to be embedded in the instruction decoder.
module imm (
    // Input instruction word. This is used to extract the relevant immediate
    // bits and assemble them into the final immediate.
    input  wire [31:0] i_inst,
    // Instruction format, determined by the instruction decoder based on the
    // opcode. This is one-hot encoded according to the following format:
    // [0] R-type
    // [1] I-type
    // [2] S-type
    // [3] B-type
    // [4] U-type
    // [5] J-type
    input  wire [5:0] i_format,
    // Output 32-bit sign-extended immediate.
    // NOTE: Because the R-type format does not have an immediate, the output
    // immediate can be treated as a don't-care under this case. It is included
    // for completeness.
    output wire [31:0] o_immediate
);
    // The immediate generation logic below has at least one bug. Fix the
    // provided implementation below to generate the correct immediate values
    // for all instruction formats. You are encouraged to make a testbench and
    // look through waveforms as you do this.
    wire [31:0] imm_r = {{32{1'bx}}};
    wire [31:0] imm_i = {{21{i_inst[31]}}, i_inst[30:20]};
    wire [31:0] imm_s = {{21{i_inst[31]}}, i_inst[30:25], i_inst[11:7]};
    // ./top_module.v:32: error: part select i_inst[25:30] is out of order.
    // FATAL: ./top_module.v:154: B imm=0 mismatch: got=xxxxxxxx exp=00000000 inst=00000000 fmt=001000
    // wire [31:0] imm_b = imm_r | {{20{i_inst[31]}}, i_inst[7], i_inst[25:30], i_inst[11:8], 1'b0};
    wire [31:0] imm_b = {{20{i_inst[31]}}, i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};
    wire [31:0] imm_u = {i_inst[31:12], 12'b0};
    wire [31:0] imm_j = {{12{i_inst[31]}}, // imm[31:20] sign extension
                        i_inst[19:12],     // imm[19:12]
                        i_inst[20],        // imm[11]
                        i_inst[30:21],     // imm[10:1]
                        1'b0};             // imm[0]

    assign o_immediate = i_format[0] ? imm_r :
                         i_format[1] ? imm_i :
                         i_format[2] ? imm_s :
                         i_format[3] ? imm_b :
                         i_format[4] ? imm_u :
                         i_format[5] ? imm_j :
                         32'b0;
endmodule

`default_nettype wire
