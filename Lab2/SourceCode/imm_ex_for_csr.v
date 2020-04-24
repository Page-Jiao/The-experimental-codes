//id\ex阶段的csr立即数段寄存器

module Imm_EX(
    input wire clk, bubbleE, flushE,
    input wire [31:0] imm,
    output reg [31:0] imm_EX
    );

    initial imm_EX = 0;
    
    always@(posedge clk)
        if (!bubbleE) 
        begin
            if (flushE)
                imm_EX <= 0;
            else 
                imm_EX <= imm;
        end
    
endmodule