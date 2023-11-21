`timescale 1ns / 1ps
`include "ctrl_encode_def.v"


module ID(
    input clk,                  
    input rstn,
    input [31:0]instr_id_in,        //ID阶段输入的指令  
    input [31:0]pc_id_in,           //ID阶段输入的PC
    output  [31:0]imm_id_out,         //译码后输出的立即数
    input  [31:0] data_rs1_id_in,  //寄存器1的数据
    input  [31:0] data_rs2_id_in,  //寄存器2的数据
    output  [31:0]data_rs1_id_out,  //寄存器1的数据
    output  [31:0] data_rs2_id_out,
    output  [31:0] pc_id_out,       //当前指令的pc
    //output  [31:0] pc_out,//下一条指令的pc
    output [4:0]rs1_id_out,
    output [4:0]rs2_id_out,
    output       RegWrite, // control signal for register write
    output       MemWrite, // control signal for memory write
    output [5:0] EXTOp,    // control signal to signed extension
    output [4:0] ALUOp,    // ALU opertion
    //output [2:0] NPCOp,    // next pc operation
    output   ALUSrc,   // ALU source for A   0表示第二个操作数是寄存器，1表示第二个操作数是立即数
    output [2:0] dm_ctrl,    
    output [1:0] GPRSel,   // general purpose register selection
    output [1:0] WDSel ,  // (register) write data selection
    output [4:0] rd_id,
   // output [31:0]aluout,
    output MemRead,
    output [31:0]instr_id_out
    );
    assign reset=~rstn;
    assign pc_id_out=pc_id_in;
    wire [2:0]NPCOp;
      wire [4:0]  rs1;          // rs
      wire [4:0]  rs2;          // rt
      wire [6:0]  Op;          // opcode
      wire [6:0]  Funct7;       // funct7
      wire [2:0]  Funct3;       // funct3
      wire [11:0] Imm12;       // 12-bit immediate
      wire [31:0] Imm32;       // 32-bit immediate
      wire [19:0] IMM;         // 20-bit immediate (address)
      wire [4:0]  A3;          // register address for write

    wire [4:0] iimm_shamt;
    wire [11:0] iimm,simm,bimm;
    wire [19:0] uimm,jimm;
    
    assign iimm_shamt=instr_id_in[24:20];
    assign iimm=instr_id_in[31:20];
    assign simm={instr_id_in[31:25],instr_id_in[11:7]};
    assign bimm={instr_id_in[31],instr_id_in[7],instr_id_in[30:25],instr_id_in[11:8]};
    assign uimm=instr_id_in[31:12];
    assign jimm={instr_id_in[31],instr_id_in[19:12],instr_id_in[20],instr_id_in[30:21]};
     
      assign Op = instr_id_in[6:0];  // instruction
      assign Funct7 = instr_id_in[31:25]; // funct7
      assign Funct3 = instr_id_in[14:12]; // funct3
      assign rs1 = instr_id_in[19:15];  // rs1
      assign rs2 = instr_id_in[24:20];  // rs2
      assign rd_id = instr_id_in[11:7];  // rd_id
      assign Imm12 = instr_id_in[31:20];// 12-bit immediate
      assign IMM = instr_id_in[31:12];  // 20-bit immediate
    //在ID阶段就产生zero
    wire [31:0] B;
    
    assign rs1_id_out=rs1;
    assign rs2_id_out=rs2;
    assign instr_id_out=instr_id_in;
     
    //assign B = (ALUSrc) ? imm_id_out : data_rs2_id_in;
    assign B = (ALUSrc) ? imm_id_out : data_rs2_id_out;
    assign data_rs1_id_out=data_rs1_id_in;
    assign data_rs2_id_out=data_rs2_id_in;
    //alu zero(.A(data_rs1_id_in), .B(B), .ALUOp(ALUOp), .C(aluout), .Zero(Zero), .PC(pc_id_in));//根据Zero判断beq等是否跳转，为0不跳转，为1跳转
   
    ctrl U_ctrl(
      .Op(Op), .Funct7(Funct7), .Funct3(Funct3), 
      .RegWrite(RegWrite), .MemWrite(MemWrite),.Zero(Zero),
      .EXTOp(EXTOp), .ALUOp(ALUOp), .NPCOp(NPCOp), 
      .ALUSrc(ALUSrc), .GPRSel(GPRSel), .WDSel(WDSel),.dm_ctrl(dm_ctrl),.MemRead(MemRead)
    );//产生控制信号
    EXT U_EXT(
      .iimm_shamt(iimm_shamt), .iimm(iimm), .simm(simm), .bimm(bimm),
      .uimm(uimm), .jimm(jimm),
      .EXTOp(EXTOp), .immout(imm_id_out)
    );//得到立即数
    // RF U_RF1(
    //     .clk(clk), .rst(reset),
    //     .RFWr(1'b0), 
    //     .A1(rs1), .A2(rs2),   
    //     .RD1(data_rs1_id_out), .RD2(data_rs2_id_out)
    //   );//读出寄存器的数据

    
    
endmodule
