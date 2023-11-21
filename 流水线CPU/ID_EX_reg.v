`timescale 1ns / 1ps


module ID_EX_reg(
 input clk,
 input rstn,
 input [31:0]pc_id_ex_in,
 input [4:0] rd_id_ex_in,
 input [31:0] imm_id_ex_in,
 input [4:0]rs1_id_ex_in,
 input [4:0]rs2_id_ex_in,
 input Memread_id_ex_in,
 input [31:0]instr_id_ex_in,
 input  [31:0] data_rs1_id_ex_in,  //寄存器1的数据
 input  [31:0] data_rs2_id_ex_in,  //寄存器2的数据
 input       RegWrite_id_ex_in, // control signal for register write
 input       MemWrite_id_ex_in, // control signal for memory write
 input [4:0] ALUOp_id_ex_in,    // ALU opertion
 //input [2:0] NPCOp_id_ex_in,    // next pc operation
 input       ALUSrc_id_ex_in,   // ALU source for A   0表示第二个操作数是寄存器，1表示第二个操作数是立即数
 input [2:0] dm_ctrl_id_ex_in,    
 input [1:0] GPRSel_id_ex_in,   // general purpose register selection input [1:0] WDSel_id_ex_in ,  // (register) write data selection
 input [1:0] WDSel ,  // (register) write data selection
// input stall,
 input flush,
 output reg[4:0]rs1_id_ex_out,
 output reg[4:0]rs2_id_ex_out,
 output reg  [31:0] pc_id_ex_out ,     //下一条指令的pc
 output reg  [4:0] rd_id_ex_out,
 output reg  [31:0] imm_id_ex_out,
 output reg  [31:0] data_rs1_id_ex_out,  
 output reg  [31:0] data_rs2_id_ex_out,
 output reg      RegWrite_id_ex_out, // control signal for register write
 output reg      MemWrite_id_ex_out, // control signal for memory write
 output reg  [4:0] ALUOp_id_ex_out,    // ALU opertion
 //output reg  [2:0] NPCOp_id_ex_out,    // next pc operation
 output reg   ALUSrc_id_ex_out,   // ALU source for A   0表示第二个操作数是寄存器，1表示第二个操作数是立即数
 output reg  [2:0] dm_ctrl_id_ex_out,    
 output reg  [1:0] GPRSel_id_ex_out,   // general purpose register selection output [1:0] WDSel_id_ex_in ,  // (register) write data selection
 output reg [1:0] WDSel_id_ex_out,  // (register) write data selection
 output reg Memread_id_ex_out,
 output reg[31:0] instr_id_ex_out
    );
    always @(posedge clk or negedge rstn) begin
    if((!rstn)||(flush))
    begin
        rd_id_ex_out<=5'b00000;
        imm_id_ex_out<=32'h00000000;
        data_rs1_id_ex_out<=32'h00000000;
        data_rs2_id_ex_out<=32'h00000000;
        pc_id_ex_out<=32'h00000000;
        RegWrite_id_ex_out<=1'b0;
        MemWrite_id_ex_out<=1'b0;
        ALUOp_id_ex_out<=5'b00000;
       // NPCOp_id_ex_out<=3'b000;
        ALUSrc_id_ex_out<=1'b0;
        dm_ctrl_id_ex_out<=3'b000;
        GPRSel_id_ex_out<=2'b00;
        WDSel_id_ex_out<=2'b00;
        rs1_id_ex_out<=5'b0;
        rs2_id_ex_out<=5'b0;
        Memread_id_ex_out<=0;
        instr_id_ex_out<=0;
    end
    else
        begin
        rd_id_ex_out<=rd_id_ex_in;
        imm_id_ex_out<=imm_id_ex_in;
        data_rs1_id_ex_out<=data_rs1_id_ex_in;
        data_rs2_id_ex_out<=data_rs2_id_ex_in;
        pc_id_ex_out<=pc_id_ex_in;
        RegWrite_id_ex_out<=RegWrite_id_ex_in;
        MemWrite_id_ex_out<= MemWrite_id_ex_in;
        ALUOp_id_ex_out<=ALUOp_id_ex_in;
       // NPCOp_id_ex_out<=NPCOp_id_ex_in;
        ALUSrc_id_ex_out<=ALUSrc_id_ex_in;
        dm_ctrl_id_ex_out<= dm_ctrl_id_ex_in;
        GPRSel_id_ex_out<=GPRSel_id_ex_in;
        WDSel_id_ex_out<=WDSel;
        rs1_id_ex_out<=rs1_id_ex_in;
        rs2_id_ex_out<=rs2_id_ex_in;
        Memread_id_ex_out<=Memread_id_ex_in;
        instr_id_ex_out<=instr_id_ex_in;
        end
end

endmodule
