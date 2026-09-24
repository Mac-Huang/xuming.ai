module writeback (
  input  wire [31:0] AluResult,
  input  wire [31:0] LoadData,
  input  wire [31:0] pc_plus4,
  input  wire [31:0] Offset,
  input  wire        MemToReg,
  input  wire        lui,
  input  wire        Jump,
  output wire [31:0] WriteData
);

	// (1) jal/jalr: rd <- pc+4
	// (2) lui:     rd <- U-imm (Offset should already be imm<<12)
	// (3) load:    rd <- LoadData
	// (4) default: rd <- AluResult

	assign WriteData = Jump     ? pc_plus4 :
					   lui      ? Offset   :
					   MemToReg ? LoadData :
								  AluResult;

endmodule