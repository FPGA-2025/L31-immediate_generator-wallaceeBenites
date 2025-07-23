module Immediate_Generator (
    input wire [31:0] instr_i,
    output reg [31:0] imm_o
);


    localparam LW_OPCODE        = 7'b0000011;
    localparam SW_OPCODE        = 7'b0100011;
    localparam JAL_OPCODE       = 7'b1101111;
    localparam LUI_OPCODE       = 7'b0110111;
    localparam JALR_OPCODE      = 7'b1100111;
    localparam AUIPC_OPCODE     = 7'b0010111;
    localparam BRANCH_OPCODE    = 7'b1100011;
    localparam IMMEDIATE_OPCODE = 7'b0010011;
    wire [6:0] opcode = instr_i[6:0];
    wire [2:0] funct3 = instr_i[14:12];
    wire [4:0] shamt  = instr_i[24:20];

    always @(*) begin
        case (opcode)
            LW_OPCODE, JALR_OPCODE, IMMEDIATE_OPCODE: begin

                if (funct3 == 3'b001 || funct3 == 3'b101) begin
                    imm_o = {27'b0, shamt};
                end else begin
                    imm_o = {{20{instr_i[31]}}, instr_i[31:20]};
                end
            end

            SW_OPCODE: begin
                imm_o = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
            end

            BRANCH_OPCODE: begin
                imm_o = {{19{instr_i[31]}}, instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
            end

            JAL_OPCODE: begin
                imm_o = {{11{instr_i[31]}}, instr_i[31], instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};
            end

            LUI_OPCODE, AUIPC_OPCODE: begin
                imm_o = {instr_i[31:12], 12'b0};
            end

            default: begin
                imm_o = 32'b0;
            end
        endcase
    end
endmodule