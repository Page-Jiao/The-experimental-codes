`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Controller Decoder
// Tool Versions: Vivado 2017.4.1
// Description: Controller Decoder Module
// 
//////////////////////////////////////////////////////////////////////////////////

//  功能说明
    //  对指令进行译码，将其翻译成控制信号，传输给各个部件
// 输入
    // Inst              待译码指令
// 输出
    // jal               jal跳转指令
    // jalr              jalr跳转指令
    // op2_src           ALU的第二个操作数来源。为1时，op2选择imm，为0时，op2选择reg2
    // ALU_func          ALU执行的运算类型
    // br_type           branch的判断条件，可以是不进行branch
    // load_npc          写回寄存器的值的来源（PC或者ALU计算结果）, load_npc == 1时选择PC
    // wb_select         写回寄存器的值的来源（Cache内容或者ALU计算结果），wb_select == 1时选择cache内容
    // load_type         load类型
    // src_reg_en        指令中src reg的地址是否有效，src_reg_en[1] == 1表示reg1被使用到了，src_reg_en[0]==1表示reg2被使用到了
    // reg_write_en      通用寄存器写使能，reg_write_en == 1表示需要写回reg
    // cache_write_en    按字节写入data cache
    // imm_type          指令中立即数类型
    // alu_src1          alu操作数1来源，alu_src1 == 0表示来自reg1，alu_src1 == 1表示来自PC
    // alu_src2          alu操作数2来源，alu_src2 == 2’b00表示来自reg2，alu_src2 == 2'b01表示来自reg2地址，alu_src2 == 2'b10表示来自立即数
// 实验要求
    // 补全模块


`include "Parameters.v"   
module ControllerDecoder(
    input wire [31:0] inst,
    output wire jal,//单独确定
    output wire jalr,//单独确定
    output wire op2_src,//单独确定
    output reg [3:0] ALU_func,//统一确定
    output reg [2:0] br_type,//单独确定
    output wire load_npc,//单独确定
    output wire wb_select,//单独确定
    output reg [2:0] load_type,//统一确定
    output reg [1:0] src_reg_en,//统一确定
    output reg reg_write_en,//统一确定，实际和load_type绑定
    output reg [3:0] cache_write_en,//统一确定
    output wire alu_src1,//单独确定
    output wire [1:0] alu_src2,//单独确定
    output reg [2:0] imm_type//统一确定
    );

    // TODO: Complete this module
    wire [6:0] opcode;
    wire [6:0] funct_7_bits;
    wire [2:0] funct_3_bits;

    //定义需要使用作为判断条件的指令字段
    assign opcode=inst[6:0];
    assign funct_3_bits=inst[14:12];
    assign funct_7_bits=inst[31:25];
    /*关于op2_src的注释
    op2选择imm的情况如下：
    1.立即数计算和移位指令ADDI、SLTI、SLTIU、XORI、ORI、ANDI，SLLI、SRLI、SRAI,opcode为0010011
    2.LUI指令用op2构造u类立即数并输出为aluout，opcode为0110111
    3.AUPIC指令将imm送入op2与pc相加，opcode为0010111
    4.jal和jalr指令进行立即数相加opcode为1101111，1100111
    5.br类指令选择imm进行与pc的加法
    6.lw类指令地址计算
    7.sw类指令地址计算
    因此只有opcode为0110011的指令不需要使用imm
    */
    assign op2_src=(opcode==7'b0110011)?1'b0:1'b1;
    assign load_npc=jal | jalr;//跳转并链接指令导致pc被写入寄存器
    assign jal=(opcode==7'b1101111)?1'b1:1'b0;
    assign jalr=(opcode==7'b1100111)?1'b1:1'b0;
    assign wb_select=(opcode==7'b0000011)?1'b1:1'b0;//只有lw指令才选择从cache写入
    assign alu_src1=(opcode==7'b0010111)?1'b1:1'b0;//仅AUIPC指令需要将PC送入ALU
    /*
    关于src2的注释
    选择信号为01表示选中指令中的reg2地址值进入alu，有三个指令需要：SLLI,SRAI,SRLI;其opcode均为0010011，func字段分别为001,101,101
    选择信号为00表示选中reg2寄存器进入alu进行计算，此时为寄存器-寄存器计算指令，此类指令的opcode为0110011（包含add,sub等）
    还有opcode为1100011的指令（BEQ类指令）。
    */
    // always@(*)
    // begin
    //     if((opcode==7'b0010011) && (funct_3_bits[1:0]==2'b01))
    //         alu_src2<=2'b01;
    //     else if((opcode==7'b0110011) || (opcode==7'b1100011))
    //         alu_src2<=2'b00;
    //     else
    //         alu_src2<=2'b10;
    // end
    assign alu_src2=( (opcode==7'b0010011)&&(funct_3_bits[1:0]==2'b01) )?(2'b01):(((opcode==7'b0110011)||(opcode==7'b1100011))?2'b00:2'b10);
    
    //确定分支类型信号

    always@(*)
    begin
        if(opcode==7'b1100011)
        begin
            case (funct_3_bits)
                3'b000: br_type<=`BEQ;
                3'b001: br_type<=`BNE;
                3'b100: br_type<=`BLT;
                3'b101: br_type<=`BGE;
                3'b110: br_type<=`BLTU;
                3'b111: br_type<=`BGEU;
                default: br_type<=3'bxxx;
            endcase
        end
        else br_type<=`NOBRANCH;
    end

    //确定主要运算控制信号

    always@(*)
    begin
        case (opcode)
            7'b0010011: //立即数指令（包含移位和计算）
            begin
                load_type<=`LW;//32bits加载
                reg_write_en<=1'b1;//需要写入寄存器
                cache_write_en<=4'b0000;//不写cache
                imm_type<=`ITYPE;
                src_reg_en<=2'b10;//使用rs1不使用rs2
                case (funct_3_bits)
                    3'b000: ALU_func<=`ADD;
                    3'b001: ALU_func<=`SLL;//实际为SLLI指令，但alu方式相同
                    3'b010: ALU_func<=`SLT;//SLTI
                    3'b011: ALU_func<=`SLTU;//SLTIU
                    3'b100: ALU_func<=`XOR;//XORI
                    3'b101: 
                    begin
                        if(funct_7_bits==7'b0100000)
                            ALU_func<=`SRA;//SRAI
                        else
                            ALU_func<=`SRL;//SRLI
                    end
                    3'b110: ALU_func<=`OR;//ORI
                    3'b111: ALU_func<=`AND;//ANDI 
                    default: ALU_func<=4'bxxxx;
                endcase
            end
            7'b0110011: //寄存器-寄存器指令
            begin
                load_type<=`LW;
                reg_write_en<=1'b1;//需要写入寄存器
                cache_write_en<=4'b0000;
                src_reg_en<=2'b11;//使用rs1，使用rs2
                imm_type<=`RTYPE;//此处设置R类立即数是否有必要？
                case (funct_3_bits)
                    3'b000: 
                    begin
                        if(funct_7_bits==7'b0100000)
                            ALU_func<=`SUB;
                        else
                            ALU_func<=`ADD;
                    end
                    3'b001: ALU_func<=`SLL;//SLL指令
                    3'b010: ALU_func<=`SLT;//SLT
                    3'b011: ALU_func<=`SLTU;//SLTU
                    3'b100: ALU_func<=`XOR;//XOR
                    3'b101: 
                    begin
                        if(funct_7_bits==7'b0100000)
                            ALU_func<=`SRA;//SRA
                        else
                            ALU_func<=`SRL;//SRL
                    end
                    3'b110: ALU_func<=`OR;//OR
                    3'b111: ALU_func<=`AND;//AND
                    default: ALU_func<=4'bxxxx;
                endcase
            end
            7'b0000011://LW指令家族
            begin
                cache_write_en<=4'b0000;
                imm_type<=`ITYPE;
                ALU_func<=`ADD;
                src_reg_en<=2'b10;//使用rs1不使用rs2
                reg_write_en<=1'b1;//需要写入寄存器
                case (funct_3_bits)
                    3'b000: load_type<=`LB;
                    3'b001: load_type<=`LH;
                    3'b010: load_type<=`LW;
                    3'b100: load_type<=`LBU;
                    3'b101: load_type<=`LHU;
                    default: load_type<=`LW;//默认情况下设置为加载32bits
                endcase
            end
            7'b0010011://SW指令家族
            begin
                ALU_func<=`ADD;
                load_type<=`NOREGWRITE;
                imm_type<=`STYPE;
                src_reg_en<=2'b11;//使用rs1，使用rs2
                reg_write_en<=1'b0;//不需要写入寄存器
                case (funct_3_bits)
                    3'b000: cache_write_en<=4'b0001;//SB
                    3'b001: cache_write_en<=4'b0011;//SH
                    3'b010: cache_write_en<=4'b1111;//sw
                    default: cache_write_en<=4'b1111;//默认情况下为SW
                endcase
            end
            7'b0110111://LUI:加载u类立即数到rd
            begin
                load_type<=`LW;
                src_reg_en<=2'b00;//不使用rs1不使用rs2
                reg_write_en<=1'b1;//需要写入寄存器
                cache_write_en<=4'b0000;
                ALU_func<=`LUI;
                imm_type<=`UTYPE;
            end
            7'b0010111://AUIPC:pc相对计算指令
            begin
                load_type<=`LW;
                src_reg_en<=2'b00;//不使用rs1不使用rs2
                reg_write_en<=1'b1;//需要写入寄存器
                cache_write_en<=4'b0000;
                ALU_func<=`ADD;
                imm_type<=`UTYPE;
            end
            7'b1101111://JAL使用J类立即数
            begin
                load_type<=`LW;
                src_reg_en<=2'b00;//不使用rs1不使用rs2
                reg_write_en<=1'b1;//需要写入寄存器
                cache_write_en<=4'b0000;
                ALU_func<=`ADD;
                imm_type<=`JTYPE;
            end
            7'b1100111://JALR使用I类立即数
            begin
                load_type<=`LW;
                src_reg_en<=2'b10;//使用rs1不使用rs2
                reg_write_en<=1'b1;//需要写入寄存器
                ALU_func<=`ADD;
                cache_write_en<=4'b0000;
                imm_type<=`ITYPE; 
            end
            7'b1100011://branch指令
            begin
                load_type<=`NOREGWRITE;
                reg_write_en<=1'b0;//不需要写入寄存器
                src_reg_en<=2'b11;//使用rs1，使用rs2
                ALU_func<=`ADD;//不需要alu参与，此处暂时赋为add指令
                imm_type<=`BTYPE;
                cache_write_en<=4'b0000;
            end
            default: 
            begin
                load_type<=`NOREGWRITE;
                reg_write_en<=1'b0;//不需要写入寄存器
                src_reg_en<=2'b00;//不使用rs1不使用rs2
                cache_write_en<=4'b0000;
                ALU_func<=`ADD;
                imm_type<=`ITYPE;
            end
        endcase
    end
endmodule

//完成实现