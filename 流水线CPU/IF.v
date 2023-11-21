`timescale 1ns / 1ps


module IF(
    input clk,
    input rstn,
    input [31:0]instr_if_in,
    input [31:0]pc_if_in,
    output [31:0]pc_if_out,
    output [31:0]instr_if_out,
    output [4:0]rs1_id_if_out,
    output [4:0]rs2_id_if_out,
    output MemWrite_if_out
    );
    wire [6:0]  Op;          // opcode
    wire [6:0]  Funct7;       // funct7
    wire [2:0]  Funct3;       // funct3
    assign Op = instr_if_in[6:0];  // instruction
    assign Funct7 = instr_if_in[31:25]; // funct7
    assign Funct3 = instr_if_in[14:12]; // funct3
    ctrl U_ctrl(
      .Op(Op), .Funct7(Funct7), .Funct3(Funct3), 
 .MemWrite(MemWrite_if_out)
      
    );//产生控制信号
// always @(posedge clk or negedge rstn) begin
//  if(!rstn)
//  begin
//     pc_if_out<=32'h0000_0000;
//     instr_if_out<=32'h0000_0000;
//  end   
//  else begin
//     pc_if_out<=pc_if_in;
//     instr_if_out<=instr_if_in;
//  end
// end
assign pc_if_out=pc_if_in;
assign instr_if_out=instr_if_in;

assign rs1_id_if_out = instr_if_in[19:15];  // rs1
assign rs2_id_if_out = instr_if_in[24:20];  // rs2

endmodule    
