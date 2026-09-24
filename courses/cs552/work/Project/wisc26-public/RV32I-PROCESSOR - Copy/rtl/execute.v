module execute (
    input  wire [2:0]  AluOp,
    input  wire [2:0]  Func3,
    input  wire [6:0]  Func7,
    input  wire [6:0]  opcode,      // optional but handy for shifts/sub, etc.
    input  wire [31:0] Operand1,
    input  wire [31:0] Operand2,
    output wire [31:0] AluResult,
    output wire        ALUeq,
    output wire        ALUslt
);

// Inside execute:
//   alu_control_unit:
//     (AluOp + Func3 + Func7 + opcode) -> (i_opsel, i_sub, i_unsigned, i_arith)
//   alu:
//     (Operand1, Operand2, i_opsel, i_sub, i_unsigned, i_arith) -> (AluResult, ALUeq, ALUslt)

    // -------------------------------------------------------------------------
    // ALU CONTROL UNIT
    // Converts your decode-level AluOp into the specific alu.v pins.
    // -------------------------------------------------------------------------
    wire [2:0] AluControl_opsel;   // maps to alu.i_opsel
    wire       AluControl_sub;     // maps to alu.i_sub
    wire       AluControl_unsigned;// maps to alu.i_unsigned
    wire       AluControl_arith;   // maps to alu.i_arith
    
    alu_control_unit u_alu_control_unit (
        .AluOp              (AluOp),
        .Func3              (Func3),
        .Func7              (Func7),
        .opcode             (opcode),
        .AluControl_opsel   (AluControl_opsel),
        .AluControl_sub     (AluControl_sub),
        .AluControl_unsigned(AluControl_unsigned),
        .AluControl_arith   (AluControl_arith)
    );

    // -------------------------------------------------------------------------
    // ALU (alu.v)
    // -------------------------------------------------------------------------
    alu u_alu (
        .i_opsel    (AluControl_opsel),
        .i_sub      (AluControl_sub),
        .i_unsigned (AluControl_unsigned),
        .i_arith    (AluControl_arith),
        .i_op1      (Operand1),
        .i_op2      (Operand2),
        .o_result   (AluResult),
        .o_eq       (ALUeq),
        .o_slt      (ALUslt)
    );

endmodule