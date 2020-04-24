// 定义csr寄存器文件，通常csr包含4096个寄存器，此处仅设置31个（0号位不适用），地址线5位
`include "Parameters.v"  
module CsrRegisterFile(
    input wire clk,
    input wire rst,
    input wire write_en,
    input wire read_en,
    input wire [2:0] csr_type,
    input wire [4:0] r_addr, w_addr,
    input wire [31:0] in_data,
    input wire [31:0] imm,
    output wire [31:0] out_data
    );

    reg [31:0] reg_file[31:1];
    integer i;

    // init register file
    initial
    begin
        for(i = 1; i < 32; i = i + 1) 
            reg_file[i][31:0] <= 32'b0;
    end

    // write in clk negedge, reset in rst posedge
    // if write register in clk posedge,
    // new wb data also write in clk posedge,
    // so old wb data will be written to register

    
    //在下降沿进行寄存器写入，因为在流水线中，寄存器的写回是在上升沿进行，只有当寄存器写入完成后，才能进行csr寄存器写入，
    //负责会写入就的值。
    always@(negedge clk or posedge rst) 
    begin 
        if (rst)
            for (i = 1; i < 32; i = i + 1) 
                reg_file[i][31:0] <= 32'b0;
        else if (write_en)
            begin
                if (csr_type == `CSRRW)
                    reg_file[w_addr] <= in_data;
                else if (csr_type == `CSRRS)
                    reg_file[w_addr] <= reg_file[w_addr] | in_data;
                else if (csr_type == `CSRRC)
                    reg_file[w_addr] <= reg_file[w_addr] & (~in_data);
                else if (csr_type == `CSRRWI)
                    reg_file[w_addr] <= imm;
                else if (csr_type <= `CSRRSI)
                    reg_file[w_addr] <= reg_file[w_addr] | imm;
                else if (csr_type == `CSRRCI)
                    reg_file[w_addr] <= reg_file[w_addr] & (~imm);
            end
    end

    // read data changes when address changes
    assign out_data = (read_en) ? reg_file[r_addr] : 32'h0;


endmodule