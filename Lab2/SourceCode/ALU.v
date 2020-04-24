`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: ALU
// Tool Versions: Vivado 2017.4.1
// Description: Arithmetic and logic computation module
// 
//////////////////////////////////////////////////////////////////////////////////

//  功能说明
    //  算数运算和逻辑运算功能部件
// 输入
    // op1               第一个操作数
    // op2               第二个操作数
    // ALU_func          运算类型
// 输出
    // ALU_out           运算结果
// 实验要求
    // 补全模块

`include "Parameters.v"   
module ALU(
    input wire [31:0] op1,
    input wire [31:0] op2,
    input wire [3:0] ALU_func,
    output reg [31:0] ALU_out
    );
    wire signed [31:0] sigend_op1 = $signed(op1);//确定有符号拓展参与运算
    wire signed [31:0] signed_op2 = $signed(op2);
    // TODO: Complete this module
    always@(*)
    begin
        case (ALU_func)
            `AND:  ALU_out<=op1 & op2;
            `SLTU:  ALU_out<=op1 < op2 ? 32'd1:32'd0;//无符号数比较指令，若rs1<rs2，则对rd写入1
            `ADD:  ALU_out<=op1 + op2;
            `SUB:  ALU_out<=op1 - op2;
            `XOR:  ALU_out<=op1 ^ op2;
            `OR:  ALU_out<=op1 | op2;
            `SLT:  ALU_out<=sigend_op1 < signed_op2 ? 32'd1:32'd0;//同上，带符号比较
            `SLL:  ALU_out<=op1<<(op2[4:0]);//逻辑左移指令，左移rs2底五位
            `SRL:  ALU_out<=op1>>(op2[4:0]);//逻辑右移指令，同上
            `SRA:  ALU_out<=sigend_op1 >>> (op2[4:0]);//算数右移指令（使用算数右移算符），需对规定了有符号拓展的数进行
            `LUI:  ALU_out<={op2[31:12],12'b0};//构造u类立即数
            `CSR:  ALU_out<=op2;//直接输出op2，为csr指令准备
            default:  ALU_out<=32'hxxxxxxxx;
        endcase
    end
endmodule

//完成实现

