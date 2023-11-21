`timescale 1ns / 1ps



module EX(
input clk,
input rstn,
input [1:0]forwardA,
input [1:0]forwardB,
input [31:0] data_rs1_ex_in,
input [31:0] data_rs2_ex_in,
input [31:0] imm_ex_in,
input [4:0] ALUOp_ex_in,
input  ALUSrc_ex_in,
input [31:0] instr_ex_in,
input [31:0] pc_ex_in,
input [31:0]ALU_result_ex_mem_out,
input [31:0]ALU_result_mem_wb_out,
output [31:0]ALU_result_ex_out,//alu计算结果
//output [2:0]NPCOp_ex_out,
output [31:0]imm_ex_out,
 output [31:0]rs1,
 output [31:0]rs2,
 output [31:0]B,
 output [4:0]ALUOp_ex_out
);

wire [6:0]  Op;          // opcode
wire [6:0]  Funct7;       // funct7
wire [2:0]  Funct3;       // funct3

assign rs1=forwardA[1]?ALU_result_ex_mem_out:(forwardA[0]?ALU_result_mem_wb_out:data_rs1_ex_in);
assign rs2=forwardB[1]?ALU_result_ex_mem_out:(forwardB[0]?ALU_result_mem_wb_out:data_rs2_ex_in);
assign imm_ex_out=imm_ex_in;
assign B = (ALUSrc_ex_in) ? imm_ex_in : rs2;//I型指令只有rs1，另外一个是立即数
assign ALUOp_ex_out=ALUOp_ex_in;
alu ex_alu(.A(rs1), .B(B), .ALUOp(ALUOp_ex_in), .C(ALU_result_ex_out), .PC(pc_ex_in),.Zero(Zero_ex_out));

// assign Op = instr_ex_in[6:0];  // instruction
// assign Funct7 = instr_ex_in[31:25]; // funct7
// assign Funct3 = instr_ex_in[14:12]; // funct3

// ctrl U_ctrl(
//       .Op(Op), .Funct7(Funct7), .Funct3(Funct3), 
//       .Zero(Zero_ex_out), .NPCOp(NPCOp_ex_out)
//     );//产生控制信号


endmodule
