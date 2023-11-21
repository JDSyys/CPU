`include "ctrl_encode_def.v"
module SCPU(
    input      clk,            // clock
    input      reset,          // reset
    input [31:0]  inst_in,     // instruction
    input [31:0]  Data_in,     // data from data memory
    input [31:0]  pc_in,
    output    MemWrite,          // output: memory write signal
    output [31:0] PC_out,     // 下一条指令的pc，PC address
    output [31:0] Addr_out,   // ALU output
    output [31:0] Data_out,// data to data memory
    output [2:0] dm_ctrl
);
wire stall;
wire [1:0]forwardA;
wire [1:0]forwardB;
wire forwardD;
assign rstn=~reset;
wire flush;
//IF
wire [31:0]instr_if_out;
wire [31:0]pc_if_out;     //当前指令的pc
//assign pc_in=PC_out;
wire [4:0]rs1_id_if_out;
wire [4:0]rs2_id_if_out;
wire MemWrite_if_out;
IF I1_IF(.clk(clk),.rstn(rstn),.instr_if_in(inst_in),.pc_if_in(pc_in),.pc_if_out(pc_if_out),.instr_if_out(instr_if_out),.rs1_id_if_out(rs1_id_if_out),.rs2_id_if_out(rs2_id_if_out),.MemWrite_if_out(MemWrite_if_out));

//IF_ID_reg
wire [31:0]pc_if_id_out;
wire [31:0]instr_if_id_out;
wire[31:0] ALU_result_ex_mem_out;
wire [4:0]rs1_id_if_id_out;
wire [4:0]rs2_id_if_id_out;
wire MemWrite_if_id_out;
IF_ID_reg I2_IF_ID_reg(
  .clk(clk),.rstn(rstn),.pc_if_id_in(pc_if_out),.instr_if_id_in(instr_if_out),.pc_if_id_out(pc_if_id_out),.instr_if_id_out(instr_if_id_out),.stall(stall),.flush(flush),
    .MemWrite_if_id_in(MemWrite_if_out),
.rs1_id_if_id_in(rs1_id_if_out),.rs2_id_if_id_in(rs2_id_if_out),.rs1_id_if_id_out(rs1_id_if_id_out),.rs2_id_if_id_out(rs2_id_if_id_out),.MemWrite_if_id_out(MemWrite_if_id_out)
);
//ID
 wire [31:0]imm_id_out;        //译码后输出的立即数
 wire [31:0] data_rs1_id_out;  //寄存器1的数据
 wire [31:0] data_rs2_id_out;  //寄存器2的数据
 wire [31:0] data_rs1_id_in;  //寄存器1的数据
 wire [31:0] data_rs2_id_in;  //寄存器2的数据
 wire[31:0]NPC;
 wire     RegWrite; // control signal for register write
 wire[5:0] EXTOp;    // control signal to signed extension
 wire[4:0] ALUOp;    // ALU opertion
 wire[2:0] NPCOp;    // next pc operation
 wire      ALUSrc;   // ALU source for A   0表示第二个操作数是寄存器，1表示第二个操作数是立即数   
 wire[1:0] GPRSel;   // general purpose register selection
 wire[1:0] WDSel ;  // (register) write data selection
 wire [4:0] rd_id;
 wire [31:0]aluout;
 wire [4:0] rs1_id_out;
 wire [4:0] rs2_id_out;
wire MemRead_id_out;
wire [31:0]pc_id_out;
wire MemWrite_id_out;
wire [2:0]dm_ctrl_id_out;
wire [31:0]instr_id_out;
wire [31:0] Addr_out_ex_out;
ID I3_ID(
    //输入
     .clk(clk),.rstn(rstn),.instr_id_in(instr_if_id_out),.pc_id_in(pc_if_id_out),  
     .data_rs1_id_in(data_rs1_id_in),  //寄存器1的数据
    .data_rs2_id_in(data_rs2_id_in),  //寄存器2的数据   
    //输出
     .rs1_id_out(rs1_id_out),
     .rs2_id_out(rs2_id_out),
    .imm_id_out(imm_id_out),         //译码后输出的立即数
    .data_rs1_id_out(data_rs1_id_out),  //寄存器1的数据
    .data_rs2_id_out(data_rs2_id_out),  //寄存器2的数据  
    .pc_id_out(pc_id_out),       //当前指令的pc
    .RegWrite(RegWrite), // control signal for register write
    .MemWrite(MemWrite_id_out), // control signal for memory write
    .EXTOp(EXTOp),    // control signal to signed extension
    .ALUOp(ALUOp),    // ALU opertion
  //  .NPCOp(NPCOp),    // next pc operation
    .ALUSrc(ALUSrc),   // ALU source for A   0表示第二个操作数是寄存器，1表示第二个操作数是立即数
    .dm_ctrl(dm_ctrl_id_out),    
    .GPRSel(GPRSel),   // general purpose register selection
    .WDSel(WDSel) ,  // (register) write data selection
    .rd_id(rd_id),
   // .aluout(aluout),//下一条指令的pc
    .MemRead(MemRead_id_out),
    .instr_id_out(instr_id_out)
    );
    wire  RegWrite_wb_out;
    wire [4:0] rd_id_wb_out;
    wire [31:0]WD;
    wire[31:0]pc_ex_mem_out;
    wire [31:0]imm_ex_mem_out;
    PC U_PC(.clk(clk), .rst(reset), .NPC(NPC), .PC(PC_out) );
    NPC U_NPC(.PC(PC_out), .NPCOp(NPCOp), .IMM(imm_ex_mem_out), .NPC(NPC), .aluout(ALU_result_ex_mem_out),.stall(stall),.NEXTPC(pc_ex_mem_out),.flush(flush));
    RF U_RF(
        .clk(clk), .rst(reset),
        .RFWr(RegWrite_wb_out), 
        .A1(rs1_id_out), .A2(rs2_id_out),.A3(rd_id_wb_out),.WD(WD),   
        .RD1(data_rs1_id_in), .RD2(data_rs2_id_in) 
      );


//ID_EX_reg

   wire [31:0] pc_id_ex_out;      //当前指令的pc
   wire [4:0]  rd_id_ex_out;
   wire [4:0]  rs1_id_ex_out;
   wire [4:0]  rs2_id_ex_out;
   wire[31:0] imm_id_ex_out;
   wire[31:0] data_rs1_id_ex_out;  
   wire[31:0] data_rs2_id_ex_out;
   wire       RegWrite_id_ex_out; // control signal for register write
   wire       MemWrite_id_ex_out; // control signal for memory write
   wire[4:0]  ALUOp_id_ex_out;    // ALU opertion
  // wire [2:0]  NPCOp_id_ex_out;    // next pc operation
   wire        ALUSrc_id_ex_out;   // ALU source for A   0表示第二个操作数是寄存器，1表示第二个操作数是立即数
   wire [2:0]  dm_ctrl_id_ex_out;    
   wire[1:0]  GPRSel_id_ex_out;   // general purpose register selection output [1:0] WDSel_id_ex_in ,  // (register) write data selection
   wire[1:0]  WDSel_id_ex_out ; // (register) write data selection   
   wire Memread_id_ex_out;
   wire[31:0]Data_read_mem_wb_out;//写入寄存器的值
   wire [31:0]instr_id_ex_out;
ID_EX_reg  I4_ID_EX_reg(
    //输入
    .instr_id_ex_in(instr_id_out),
    .clk(clk),
    .rstn(rstn),
    //.stall(stall),
    .flush(flush),
    .pc_id_ex_in(pc_id_out),
    .rd_id_ex_in(rd_id),
    .rs1_id_ex_in(rs1_id_out),
    .rs2_id_ex_in(rs2_id_out),
    .imm_id_ex_in(imm_id_out),
    .data_rs1_id_ex_in(data_rs1_id_out),  //寄存器1的数据
    .data_rs2_id_ex_in(data_rs2_id_out),  //寄存器2的数据
    .RegWrite_id_ex_in(RegWrite), // control signal for register write
    .ALUOp_id_ex_in(ALUOp),    // ALU opertion
   // .NPCOp_id_ex_in(NPCOp),    // next pc operation
    .ALUSrc_id_ex_in(ALUSrc),   // ALU source for A   0表示第二个操作数是寄存器，1表示第二个操作数是立即数
    .dm_ctrl_id_ex_in(dm_ctrl_id_out),    
    .GPRSel_id_ex_in(GPRSel),   // general purpose register selection input [1:0] WDSel_id_ex_in ,  // (register) write data selection
    .WDSel(WDSel) ,  // (register) write data selection
    .Memread_id_ex_in(MemRead_id_out),
    .MemWrite_id_ex_in(MemWrite_id_out),
 //输出
    .instr_id_ex_out(instr_id_ex_out),
    .Memread_id_ex_out(Memread_id_ex_out),
    .pc_id_ex_out (pc_id_ex_out),     //当前指令的pc
    .rd_id_ex_out(rd_id_ex_out),
    .imm_id_ex_out(imm_id_ex_out),
    .rs1_id_ex_out(rs1_id_ex_out),
    .rs2_id_ex_out(rs2_id_ex_out),
    .data_rs1_id_ex_out(data_rs1_id_ex_out),  
    .data_rs2_id_ex_out(data_rs2_id_ex_out),
    .RegWrite_id_ex_out(RegWrite_id_ex_out), // control signal for register write
    .MemWrite_id_ex_out(MemWrite_id_ex_out), // control signal for memory write
    .ALUOp_id_ex_out(ALUOp_id_ex_out),    // ALU opertion
    //.NPCOp_id_ex_out(NPCOp_id_ex_out),    // next pc operation
    .ALUSrc_id_ex_out(ALUSrc_id_ex_out),   // ALU source for A   0表示第二个操作数是寄存器，1表示第二个操作数是立即数
    .dm_ctrl_id_ex_out(dm_ctrl_id_ex_out),    
    .GPRSel_id_ex_out(GPRSel_id_ex_out),   // general purpose register selection output [1:0] WDSel_id_ex_in ,  // (register) write data selection
    .WDSel_id_ex_out(WDSel_id_ex_out)  // (register) write data selection
) ;

//EX


wire [31:0]data_rs2_ex_out;
wire [31:0] ALU_result_mem_wb_out;
wire [31:0]imm_ex_out;
wire [2:0] NPCOp_ex_out;
wire [31:0] rs1_data_ex_out;
wire [31:0]B_ex_out;
wire [4:0]ALUOp_ex_out;
wire [31:0]rs2_data_ex_out;
EX I5_EX(
    //输入
.instr_ex_in(instr_id_ex_out),
.forwardA(forwardA),
.forwardB(forwardB),
.clk(clk),
.rstn(rstn),
.data_rs1_ex_in(data_rs1_id_ex_out),
.data_rs2_ex_in(data_rs2_id_ex_out),
.imm_ex_in(imm_id_ex_out),
.ALUOp_ex_in(ALUOp_id_ex_out),
.ALUSrc_ex_in(ALUSrc_id_ex_out),
.pc_ex_in(pc_id_ex_out),
.ALU_result_ex_mem_out(ALU_result_ex_mem_out),
.ALU_result_mem_wb_out(ALU_result_mem_wb_out),
 //输出
.ALU_result_ex_out(Addr_out_ex_out),
//.NPCOp_ex_out(NPCOp_ex_out),
.imm_ex_out(imm_ex_out),
.rs1(rs1_data_ex_out),
.rs2(rs2_data_ex_out),
.B(B_ex_out),
.ALUOp_ex_out(ALUOp_ex_out)
);

//EX_MEM_reg


 wire[4:0]  rd_id_ex_mem_out;
 wire RegWrite_ex_mem_out; // control signal for register write
 wire MemWrite_ex_mem_out; // control signal for memory write
 wire[2:0] dm_ctrl_ex_mem_out;
 wire[1:0] GPRSel_ex_mem_out;
 wire[31:0]data_rs2_ex_mem_out;
 wire[1:0] WDSel_ex_mem_out ; // (register) write data selection

 wire[4:0]rs1_ex_mem_out;
 wire[4:0]rs2_ex_mem_out;
 wire Memread_ex_mem_out;
 wire[31:0] rs1_data_ex_mem_out;
 wire[31:0]B_ex_mem_out;
 wire[4:0]ALUOp_ex_mem_out;
 wire[31:0]instr_ex_mem_out;
 wire[2:0]NPCOp_ex_mem_out;
EX_MEM_reg I6_EX_MEM_reg(
    //输入
    .imm_ex_mem_in(imm_ex_out),
    .flush(flush),
    .NPCOp_ex_mem_in(NPCOp_ex_out),
   // .forwardD(forwardD),
   // .WD(WD),
    .clk(clk),
    .rstn(rstn),
    .ALU_result_ex_mem_in(Addr_out_ex_out),
    .rd_id_ex_mem_in(rd_id_ex_out),
    .rs1_ex_mem_in(rs1_id_ex_out),
    .rs2_ex_mem_in(rs2_id_ex_out),
    .RegWrite_ex_mem_in(RegWrite_id_ex_out), // control signal for register write
    .MemWrite_ex_mem_in(MemWrite_id_ex_out), // control signal for memory write
    .dm_ctrl_ex_mem_in(dm_ctrl_id_ex_out),
    .GPRSel_ex_mem_in(GPRSel_id_ex_out),
    .data_rs2_ex_mem_in(rs2_data_ex_out),
    .WDSel(WDSel_id_ex_out) ,  // (register) write data selection
    .pc_ex_mem_in(pc_id_ex_out),
    .Memread_ex_mem_in(Memread_id_ex_out),
    .rs1_data_ex_mem_in(rs1_data_ex_out),
    .B_ex_mem_in(B_ex_out),
    .ALUOp_ex_mem_in(ALUOp_ex_out),
    .instr_ex_mem_in(instr_id_ex_out),
    //输出
    .rs1_data_ex_mem_out(rs1_data_ex_mem_out),
    .B_ex_mem_out(B_ex_mem_out),
    .ALUOp_ex_mem_out(ALUOp_ex_mem_out),
    .instr_ex_mem_out(instr_ex_mem_out),
    .ALU_result_ex_mem_out(ALU_result_ex_mem_out),
    .rd_id_ex_mem_out(rd_id_ex_mem_out),
    .rs1_ex_mem_out(rs1_ex_mem_out),
    .rs2_ex_mem_out(rs2_ex_mem_out),
    .RegWrite_ex_mem_out(RegWrite_ex_mem_out), // control signal for register write
    .MemWrite_ex_mem_out(MemWrite_ex_mem_out), // control signal for memory write
    .dm_ctrl_ex_mem_out(dm_ctrl_ex_mem_out),
    .GPRSel_ex_mem_out(GPRSel_ex_mem_out),
    .data_rs2_ex_mem_out(data_rs2_ex_mem_out),
    .WDSel_ex_mem_out(WDSel_ex_mem_out) , // (register) write data selection
    .pc_ex_mem_out(pc_ex_mem_out),
    .Memread_ex_mem_out(Memread_ex_mem_out),
    .NPCOp_ex_mem_out(NPCOp_ex_mem_out),
    .imm_ex_mem_out(imm_ex_mem_out)
);
//MEM
wire[31:0]Data_read_mem_out;

wire forwardC;
MEM I7_MEM(
    //输入
   
    .rs1_data_mem_in(rs1_data_ex_mem_out),
    .B_mem_in(B_ex_mem_out),
    .ALUOp_mem_in(ALUOp_ex_mem_out),
    .instr_mem_in(instr_ex_mem_out),
    .clk(clk),
    .rstn(rstn),
    .MemWrite_mem_in(MemWrite_ex_mem_out),
    .data_in(Data_in),
    .forwardC(forwardC),
    .dm_ctrl_mem_in(dm_ctrl_ex_mem_out),
    .ALU_result_mem_in(ALU_result_ex_mem_out), //load|store的内存地址
    //.Data_read_from_dm(Cpu_data4bus),  //内存把数据给总线，总线再把数据给dmcontrol,load出来的数据
    .data_rs2_mem_in(data_rs2_ex_mem_out),   //store时要写入内存的数据，即寄存器2的值
    .Data_read_mem_wb_out(Data_read_mem_wb_out),
    .ALU_result_mem_wb_out(ALU_result_mem_wb_out),
    //输出
    .ALU_result_mem_out(Addr_out), //load|store的内存地址
    .douta_mem_out(Data_out), //Data_out    //store指令写往内存的数据
    .Data_read_mem_out(Data_read_mem_out), //从内存读来的经过对齐后的数据,WB阶段写入寄存器,load用
    .MemWrite_mem_out(MemWrite),
    .dm_ctrl_mem_out(dm_ctrl),
    .NPCOp_mem_out(NPCOp)
);
//MEM_WB_reg

wire[4:0] rd_id_mem_wb_out;  //写回的寄存器 
wire RegWrite_mem_wb_out;
wire    [1:0] WDSel_mem_wb_out ; // (register) write data selection
wire   [31:0]pc_mem_wb_out;
wire[4:0]rs1_mem_wb_out;
wire[4:0] rs2_mem_wb_out;
wire Memread_mem_wb_out;
MEM_WB_reg I8_MEM_WB_reg(
    //输入
    .clk(clk),
    .rstn(rstn),
    .Data_read_mem_wb_in(Data_read_mem_out),//写入寄存器的值
    .rd_id_mem_wb_in(rd_id_ex_mem_out),  //写回的寄存器  
    .rs1_mem_wb_in(rs1_ex_mem_out),
    .rs2_mem_wb_in(rs2_ex_mem_out),
    .RegWrite_mem_wb_in(RegWrite_ex_mem_out), // control signal for register write
    .WDSel(WDSel_ex_mem_out) ,  // (register) write data selection
    .ALU_result_mem_wb_in(ALU_result_ex_mem_out),
    .pc_mem_wb_in(pc_ex_mem_out),
    .Memread_mem_wb_in(Memread_ex_mem_out),

    //输出
    .Data_read_mem_wb_out(Data_read_mem_wb_out),//写入寄存器的值
    .rd_id_mem_wb_out(rd_id_mem_wb_out),  //写回的寄存器 
    .rs1_mem_wb_out(rs1_mem_wb_out),
    .rs2_mem_wb_out(rs2_mem_wb_out),
    .RegWrite_mem_wb_out(RegWrite_mem_wb_out),
    .WDSel_mem_wb_out(WDSel_mem_wb_out) , // (register) write data selection
    .ALU_result_mem_wb_out(ALU_result_mem_wb_out),
    .pc_mem_wb_out(pc_mem_wb_out),
    .Memread_mem_wb_out(Memread_mem_wb_out)
);
//WB

WB I9_WB(
    //输入
    .clk(clk),
    .rstn(rstn),
    .ALU_result_wb_in(ALU_result_mem_wb_out),//将ALU的运算结果写入寄存器时的值
    .Data_read_wb_in(Data_read_mem_wb_out),//若是load则是写入寄存器的值
    .rd_id_wb_in(rd_id_mem_wb_out),  //写回的寄存器  
    .RegWrite_wb_in(RegWrite_mem_wb_out), // control signal for register write
    .pc_wb_in(pc_mem_wb_out),
    .WDSel(WDSel_mem_wb_out) ,
    //输出
    .WD(WD),
    .RegWrite_wb_out(RegWrite_wb_out),
    .rd_id_wb_out(rd_id_wb_out)
);


// forwardunit I10_for(
//     //输入
//     .RegWrite_ex_mem_out(RegWrite_ex_mem_out),
//     .rd_id_ex_mem_out(rd_id_ex_mem_out),
//     .rs1_id_ex_out(rs1_id_ex_out),
//     .RegWrite_mem_wb_out(RegWrite_mem_wb_out),
//     .rd_id_mem_wb_out(rd_id_mem_wb_out),
//     .rs2_id_ex_out(rs2_id_ex_out),
//     .Memread_mem_wb_out(Memread_mem_wb_out),
//     .MemWrite_ex_mem_out(MemWrite_ex_mem_out),
//     .rs2_ex_mem_out(rs2_ex_mem_out),
//     .Memread_ex_mem_out(Memread_ex_mem_out),
//     .MemWrite_id_ex_out(MemWrite_id_ex_out),
//     .rd_id_wb_out(rd_id_wb_out),
//     .rs1_ex_mem_out(rs1_ex_mem_out),
//     .MemRead_id_ex_out
//     .Memwrite_if_id_out
//     .
// //输出
//     .forwardA(forwardA),
//     .forwardB(forwardB),
//     .forwardC(forwardC),
//     .forwardD(forwardD),
//     .stall(stall)
// );
forwardunit I10_for(
    //输入
    .RegWrite_ex_mem_out(RegWrite_ex_mem_out),
    .rd_id_ex_mem_out(rd_id_ex_mem_out),
    .rs1_id_id_ex_out(rs1_id_ex_out),
    .RegWrite_mem_wb_out(RegWrite_mem_wb_out),
    .rd_id_mem_wb_out(rd_id_mem_wb_out),
    .rs2_id_id_ex_out(rs2_id_ex_out),
    .MemRead_id_ex_out(Memread_id_ex_out),
    .Memwrite_if_id_out(MemWrite_if_id_out),
    .rd_id_id_ex_out(rd_id_ex_out),
    .rs1_id_if_id_out(rs1_id_if_id_out),
    .rs2_id_if_id_out(rs2_id_if_id_out),
    .Memread_mem_wb_out(Memread_mem_wb_out),
    .MemWrite_ex_mem_out(MemWrite_ex_mem_out),
    .rs2_id_ex_mem_out(rs2_ex_mem_out),
    //输出
    .forwardA(forwardA),
    .forwardB(forwardB),
    .forwardC(forwardC),
    .stall(stall)
);
endmodule