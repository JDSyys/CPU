// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (win64) Build 2188600 Wed Apr  4 18:40:38 MDT 2018
// Date        : Tue Jun 20 18:23:52 2023
// Host        : LAPTOP-E4IJ843E running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub C:/Users/user/Desktop/projects/edf_file/SCPU.v
// Design      : SCPU
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
// `include "ctrl_encode_def.v"
// NPC control signal
`define NPC_PLUS4   3'b000
`define NPC_BRANCH  3'b001
`define NPC_JUMP    3'b010
`define NPC_JALR 3'b100

// ALU control signal
`define ALU_NOP   3'b000 
`define ALU_ADD   3'b001
`define ALU_SUB   3'b010 
`define ALU_AND   3'b011
`define ALU_OR    3'b100

//EXT CTRL itype, stype, btype, utype, jtype
`define EXT_CTRL_ITYPE_SHAMT 6'b100000
`define EXT_CTRL_ITYPE	6'b010000
`define EXT_CTRL_STYPE	6'b001000
`define EXT_CTRL_BTYPE	6'b000100
`define EXT_CTRL_UTYPE	6'b000010
`define EXT_CTRL_JTYPE	6'b000001

`define GPRSel_RD 2'b00
`define GPRSel_RT 2'b01
`define GPRSel_31 2'b10

`define WDSel_FromALU 2'b00
`define WDSel_FromMEM 2'b01
`define WDSel_FromPC 2'b10

`define ALUOp_nop 5'b00000
`define ALUOp_lui 5'b00001
`define ALUOp_auipc 5'b00010
`define ALUOp_add 5'b00011
`define ALUOp_sub 5'b00100
`define ALUOp_bne 5'b00101
`define ALUOp_blt 5'b00110
`define ALUOp_bge 5'b00111
`define ALUOp_bltu 5'b01000
`define ALUOp_bgeu 5'b01001
`define ALUOp_slt 5'b01010
`define ALUOp_sltu 5'b01011
`define ALUOp_xor 5'b01100
`define ALUOp_or 5'b01101
`define ALUOp_and 5'b01110
`define ALUOp_sll 5'b01111
`define ALUOp_srl 5'b10000
`define ALUOp_sra 5'b10001

`define dm_word 3'b000
`define dm_halfword 3'b001
`define dm_halfword_unsigned 3'b010
`define dm_byte 3'b011
`define dm_byte_unsigned 3'b100


module SCPU(clk, reset, MIO_ready, inst_in, Data_in, mem_w, 
  PC_out, Addr_out, Data_out, dm_ctrl, CPU_MIO, INT);
  input clk;
  input reset;
  input MIO_ready;
  input [31:0]inst_in;//指令
  input [31:0]Data_in;//来自内存的数据
  output mem_w;//写信号
  output [31:0]PC_out;//PC值
  output [31:0]Addr_out;//loads指令：aluout算出的地址，送往总线和dmctrl
  output [31:0]Data_out;
  output [2:0]dm_ctrl;
  output CPU_MIO;
  input INT;

      wire        RegWrite;    // control signal to register write
      wire [5:0]       EXTOp;       // control signal to signed extension
      wire [4:0]  ALUOp;       // ALU opertion
      wire [2:0]  NPCOp;       // next PC operation
  
      wire [1:0]  WDSel;       // (register) write data selection
      wire [1:0]  GPRSel;      // general purpose register selection
     
      wire        ALUSrc;      // ALU source for A
      wire        Zero;        // ALU ouput zero
  
      wire [31:0] NPC;         // next PC
  
      wire [4:0]  rs1;          // rs
      wire [4:0]  rs2;          // rt
      wire [4:0]  rd;          // rd
      wire [6:0]  Op;          // opcode
      wire [6:0]  Funct7;       // funct7
      wire [2:0]  Funct3;       // funct3
      wire [11:0] Imm12;       // 12-bit immediate
      wire [31:0] Imm32;       // 32-bit immediate
      wire [19:0] IMM;         // 20-bit immediate (address)
      wire [4:0]  A3;          // register address for write
      reg [31:0] WD;          // register write data
      wire [31:0] RD1,RD2;         // register data specified by rs
      wire [31:0] B;           // operator for ALU B
    
    wire [4:0] iimm_shamt;
    wire [11:0] iimm,simm,bimm;
    wire [19:0] uimm,jimm;
    wire [31:0] immout;
      wire[31:0] aluout;
      assign Addr_out=aluout;
    assign B = (ALUSrc) ? immout : RD2;
    assign Data_out = RD2;
    
    assign iimm_shamt=inst_in[24:20];
    assign iimm=inst_in[31:20];
    assign simm={inst_in[31:25],inst_in[11:7]};
    assign bimm={inst_in[31],inst_in[7],inst_in[30:25],inst_in[11:8]};
    assign uimm=inst_in[31:12];
    assign jimm={inst_in[31],inst_in[19:12],inst_in[20],inst_in[30:21]};
     
      assign Op = inst_in[6:0];  // instruction
      assign Funct7 = inst_in[31:25]; // funct7
      assign Funct3 = inst_in[14:12]; // funct3
      assign rs1 = inst_in[19:15];  // rs1
      assign rs2 = inst_in[24:20];  // rs2
      assign rd = inst_in[11:7];  // rd
      assign Imm12 = inst_in[31:20];// 12-bit immediate
      assign IMM = inst_in[31:12];  // 20-bit immediate
     
     // instantiation of control unit
    ctrl U_ctrl(
      .Op(Op), .Funct7(Funct7), .Funct3(Funct3), .Zero(Zero), 
      .RegWrite(RegWrite), .MemWrite(mem_w),
      .EXTOp(EXTOp), .ALUOp(ALUOp), .NPCOp(NPCOp), 
      .ALUSrc(ALUSrc), .GPRSel(GPRSel), .WDSel(WDSel),.dm_ctrl(dm_ctrl)
    );
   // instantiation of pc unit
    PC U_PC(.clk(clk), .rst(reset), .NPC(NPC), .PC(PC_out) );
    NPC U_NPC(.PC(PC_out), .NPCOp(NPCOp), .IMM(immout), .NPC(NPC), .aluout(aluout));
    EXT U_EXT(
      .iimm_shamt(iimm_shamt), .iimm(iimm), .simm(simm), .bimm(bimm),
      .uimm(uimm), .jimm(jimm),
      .EXTOp(EXTOp), .immout(immout)
    );
    RF U_RF(
      .clk(clk), .rst(reset),
      .RFWr(RegWrite), 
      .A1(rs1), .A2(rs2), .A3(rd), 
      .WD(WD), 
      .RD1(RD1), .RD2(RD2)
      //.reg_sel(reg_sel),
      //.reg_data(reg_data)
    );
  // instantiation of alu unit
    alu U_alu(.A(RD1), .B(B), .ALUOp(ALUOp), .C(aluout), .Zero(Zero), .PC(PC_out));
  
  //please connnect the CPU by yourself
  always @*
  begin
    case(WDSel)
      `WDSel_FromALU: WD<=aluout;
      `WDSel_FromMEM: WD<=Data_in;
      `WDSel_FromPC: WD<=PC_out+4;
    endcase
  end
  
  
  endmodule



