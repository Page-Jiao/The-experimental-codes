`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Data Extend
// Tool Versions: Vivado 2017.4.1
// Description: Data Extension module
// 
//////////////////////////////////////////////////////////////////////////////////

//  功能说明
    //  将Cache中Load的数据扩展成32位
// 输入
    // data              cache读出的数据
    // addr              字节地址
    // load_type         load的类型
    // ALU_func          运算类型
// 输出
    // dealt_data        扩展完的数据
// 实验要求
    // 补全模块


`include "Parameters.v"

module DataExtend(
    input wire [31:0] data,
    input wire [1:0] addr,
    input wire [2:0] load_type,
    output reg [31:0] dealt_data
    );
    wire [31:0] bytes;
    wire [31:0] words;
    assign bytes=(data>>(addr*32'h08))&32'h000000ff;
    assign words=(data>>(addr*32'h08))&32'h0000ffff;
    always@(*)
    begin
        case (load_type)
            `NOREGWRITE: dealt_data<=32'hxxxxxxxx;
            `LB: dealt_data<={{24{bytes[7]}},bytes[7:0]};
            `LH: dealt_data<={{16{words[15]}},words[15:0]};
            `LW: dealt_data<=data;
            `LBU: dealt_data<={24'b0,bytes[7:0]};
            `LHU: dealt_data<={16'b0,words[15:0]};
            default: dealt_data<=32'hxxxxxxxx;
        endcase
    end
    // TODO: Complete this module

endmodule

//完成实现