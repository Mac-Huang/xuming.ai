module dmem_access (
    input  wire [31:0] EffAddr,
    input  wire [31:0] StoreData,
    input  wire [2:0]  Func3,
    input  wire        MemRead,
    input  wire        MemWrite,
    input  wire [31:0] i_dmem_rdata,

    output wire [31:0] o_dmem_addr,
    output wire [3:0]  o_dmem_mask,
    output wire [31:0] o_dmem_wdata,
    output wire        o_dmem_ren,
    output wire        o_dmem_wen,

    output wire [31:0] LoadData,
    output wire        MisalignTrap
);

    wire [1:0] byte_offset = EffAddr[1:0];

    // Data MEM word-aligned address
    assign o_dmem_addr = {EffAddr[31:2], 2'b00};

    // Misalignment checks
    wire misalign_half = EffAddr[0];
    wire misalign_word = |EffAddr[1:0];

    wire misalign_load  = MemRead & (
        ((Func3 == 3'b001) | (Func3 == 3'b101)) ? misalign_half :
        ((Func3 == 3'b010))                      ? misalign_word :
                                                   1'b0
    );

    wire misalign_store = MemWrite & (
        ((Func3 == 3'b001)) ? misalign_half :
        ((Func3 == 3'b010)) ? misalign_word :
                              1'b0
    );

    assign MisalignTrap = misalign_load | misalign_store;

    assign o_dmem_ren = MemRead  & ~MisalignTrap;
    assign o_dmem_wen = MemWrite & ~MisalignTrap;

    // ---------------------------
    // Mask decode
    // ---------------------------
    reg [3:0] mask_dec;
    always @(*) begin
        case (Func3)
            3'b000,
            3'b100: begin
                case (byte_offset)
                    2'b00: mask_dec = 4'b0001;
                    2'b01: mask_dec = 4'b0010;
                    2'b10: mask_dec = 4'b0100;
                    2'b11: mask_dec = 4'b1000;
                    default: mask_dec = 4'b0000;
                endcase
            end
            3'b001,
            3'b101: begin
                case (byte_offset[1])
                    1'b0: mask_dec = 4'b0011;
                    1'b1: mask_dec = 4'b1100;
                    default: mask_dec = 4'b0000;
                endcase
            end
            3'b010: begin
                mask_dec = 4'b1111;
            end
            default: begin
                mask_dec = 4'b0000;
            end
        endcase
    end

    assign o_dmem_mask = {4{MemRead | MemWrite}} & mask_dec;

    // ---------------------------
    // Store write-data alignment
    // ---------------------------
    reg [31:0] sb_data;
    always @(*) begin
        case (byte_offset)
            2'b00: sb_data = StoreData;
            2'b01: sb_data = {StoreData[23:0], 8'b0};
            2'b10: sb_data = {StoreData[15:0], 16'b0};
            2'b11: sb_data = {StoreData[7:0], 24'b0};
            default: sb_data = 32'b0;
        endcase
    end

    reg [31:0] sh_data;
    always @(*) begin
        case (byte_offset[1])
            1'b0: sh_data = StoreData;
            1'b1: sh_data = {StoreData[15:0], 16'b0};
            default: sh_data = 32'b0;
        endcase
    end

    reg [31:0] store_data_dec;
    always @(*) begin
        case (Func3)
            3'b000: store_data_dec = sb_data;
            3'b001: store_data_dec = sh_data;
            3'b010: store_data_dec = StoreData;
            default: store_data_dec = 32'b0;
        endcase
    end

    assign o_dmem_wdata = {32{MemWrite}} & store_data_dec;

    // ---------------------------
    // Load data alignment + extension
    // ---------------------------
    reg [31:0] rdata_shifted;
    always @(*) begin
        case (byte_offset)
            2'b00: rdata_shifted = i_dmem_rdata;
            2'b01: rdata_shifted = {8'b0,  i_dmem_rdata[31:8]};
            2'b10: rdata_shifted = {16'b0, i_dmem_rdata[31:16]};
            2'b11: rdata_shifted = {24'b0, i_dmem_rdata[31:24]};
            default: rdata_shifted = 32'b0;
        endcase
    end

    wire [7:0]  rbyte = rdata_shifted[7:0];
    wire [15:0] rhalf = rdata_shifted[15:0];

    reg [31:0] loaddata_dec;
    always @(*) begin
        case (Func3)
            3'b000: loaddata_dec = {{24{rbyte[7]}}, rbyte};
            3'b100: loaddata_dec = {24'b0, rbyte};
            3'b001: loaddata_dec = {{16{rhalf[15]}}, rhalf};
            3'b101: loaddata_dec = {16'b0, rhalf};
            3'b010: loaddata_dec = rdata_shifted;
            default: loaddata_dec = 32'b0;
        endcase
    end

    assign LoadData = {32{MemRead & ~MisalignTrap}} & loaddata_dec;

endmodule
