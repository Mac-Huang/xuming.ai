`default_nettype none

// The arithmetic logic unit (ALU) is responsible for performing the core
// calculations of the processor. It takes two 32-bit operands and outputs
// a 32 bit result based on the selection operation - addition, comparison,
// shift, or logical operation. This ALU is a purely combinational block, so
// you should not attempt to add any registers or pipeline it.
module alu (
    // NOTE: Both 3'b010 and 3'b011 are used for set less than operations and
    // your implementation should output the same result for both codes. The
    // reason for this will become clear in project 3.
    //
    // Major operation selection.
    // 3'b000: addition/subtraction if `i_sub` asserted
    // 3'b001: shift left logical
    // 3'b010,
    // 3'b011: set less than/unsigned if `i_unsigned` asserted
    // 3'b100: exclusive or
    // 3'b101: shift right logical/arithmetic if `i_arith` asserted
    // 3'b110: or
    // 3'b111: and
    input  wire [ 2:0] i_opsel,
    // When asserted, addition operations should subtract instead.
    // This is only used for `i_opsel == 3'b000` (addition/subtraction).
    input  wire        i_sub,
    // When asserted, comparison operations should be treated as unsigned.
    // This is used for branch comparisons and set less than unsigned. For
    // b ranch operations, the ALU result is not used, only the comparison
    // results.
    input  wire        i_unsigned,
    // When asserted, right shifts should be treated as arithmetic instead of
    // logical. This is only used for `i_opsel == 3'b101` (shift right).
    input  wire        i_arith,
    // First 32-bit input operand.
    input  wire [31:0] i_op1,
    // Second 32-bit input operand.
    input  wire [31:0] i_op2,
    // 32-bit output result. Any carry out should be ignored.
    output wire [31:0] o_result,
    // Equality result. This is used externally to determine if a branch
    // should be taken.
    output wire        o_eq,
    // Set less than result. This is used externally to determine if a branch
    // should be taken.
    output wire        o_slt
);

    wire [4:0] shamt = i_op2[4:0];

    assign o_eq  = (i_op1 == i_op2);
    assign o_slt = i_unsigned ? (i_op1 < i_op2)
                              : ($signed(i_op1) < $signed(i_op2));

    logic [31:0] result;

    always @(*) begin
        case (i_opsel)
            3'b000: result = i_sub ? (i_op1 - i_op2) : (i_op1 + i_op2);
            3'b001: result = i_op1 << shamt;
            3'b010,
            3'b011: result = {31'b0, o_slt};
            3'b100: result = i_op1 ^ i_op2;
            3'b101: result = i_arith
                          ? ( {{32{ i_op1[31] }} << (32 - shamt)} | (i_op1 >> shamt) )
                          : (i_op1 >> shamt);
            3'b110: result = i_op1 | i_op2;
            3'b111: result = i_op1 & i_op2;
            default: result = 32'b0;
        endcase
    end

    assign o_result = result;

endmodule

`default_nettype wire
