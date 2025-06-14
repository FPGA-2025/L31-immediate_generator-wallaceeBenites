`timescale 1ns/1ps

module tb();

reg [31:0] instr;
reg [6:0] opcode;
reg [2:0] func3;
reg [31:0] expected_immediate;
wire[31:0] imm_o;

reg [107:0] test_mem [0:29]; //8 + 4 + 32 + 32 + 32 = 108 bits
integer i;

Immediate_Generator imm(
    .instr_i(instr),  
    .imm_o(imm_o)
);

    initial begin
        $dumpfile("saida.vcd");
        $dumpvars(0, tb);

        $readmemh("teste.txt", test_mem);

        for (i = 0; i < 8; i = i + 1) begin
            
            opcode              = test_mem[i][107:100];
            func3               = test_mem[i][99:96];
            instr               = test_mem[i][63:32];
            expected_immediate  = test_mem[i][31:0];

            #1; // aguarda propagação

            if (imm_o === expected_immediate) begin
                $display("=== OK  [%0d] opcode=%h func3=%h instr=%h immediate=%h (esperado)", i, opcode, func3, instr, imm_o);
            end else begin
                $display("=== ERRO  [%0d] opcode=%h func3=%h instr=%h immediate=%h (esperado = %h)", i, opcode, func3, instr, imm_o, expected_immediate);
            end
        end

        $finish;
    end

endmodule